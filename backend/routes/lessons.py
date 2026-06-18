from fastapi import APIRouter, Depends, HTTPException
from typing import Optional
import asyncio
import json
from pydantic import BaseModel
from datetime import date as _date
from models.schemas import SubmitAnswerRequest, SubmitAnswerResponse
from db.connection import acquire
from services.code_runner import execute_code
from services.claude import generate_task_intro, translate_to_german, translate_lesson_content_to_german, translate_code_comments, translate_hints_to_german, generate_explain_code, evaluate_explanation
from deps import get_current_user, get_optional_user
from utils.streak import update_user_streak

router = APIRouter()

# In-memory fast-path cache (populated from DB or newly generated)
_task_intro_cache: dict[tuple[int, str], str] = {}


def _check_output(actual: str, expected: str) -> bool:
    a, e = actual.strip(), expected.strip()
    if a == e:
        return True
    # Normalize internal whitespace (handles extra spaces/tabs)
    if " ".join(a.split()) == " ".join(e.split()):
        return True
    # Single-value float tolerance (e.g. "3.0" matches "3", "3.14000" matches "3.14")
    try:
        return abs(float(a) - float(e)) < 1e-6
    except (ValueError, TypeError):
        pass
    # Multi-line: compare line-by-line with float tolerance
    a_lines, e_lines = a.splitlines(), e.splitlines()
    if len(a_lines) == len(e_lines) and len(a_lines) > 0:
        try:
            return all(
                abs(float(al.strip()) - float(el.strip())) < 1e-6
                for al, el in zip(a_lines, e_lines)
            )
        except (ValueError, TypeError):
            pass
    return False


async def _award_badges(
    conn,
    user_id: str,
    user_xp: int,
    total_completed: int,
    streak: int = 0,
    first_attempt_count: int = 0,
    topic_id: Optional[int] = None,
) -> None:
    badges = await conn.fetch("SELECT * FROM badges")
    owned = {r["badge_id"] for r in await conn.fetch(
        "SELECT badge_id FROM user_badges WHERE user_id = $1", user_id
    )}

    topic_done = False
    if topic_id is not None:
        total_in_topic = await conn.fetchval(
            "SELECT COUNT(*) FROM lessons WHERE topic_id = $1", topic_id
        )
        done_in_topic = await conn.fetchval(
            """SELECT COUNT(*) FROM user_progress up
               JOIN lessons l ON l.id = up.lesson_id
               WHERE up.user_id = $1 AND l.topic_id = $2""",
            user_id, topic_id,
        )
        topic_done = total_in_topic > 0 and done_in_topic >= total_in_topic

    # Count fully-completed topics for multi-topic badges
    topics_completed_count = await conn.fetchval(
        """SELECT COUNT(*) FROM (
               SELECT l.topic_id
               FROM lessons l
               GROUP BY l.topic_id
               HAVING COUNT(l.id) > 0
                  AND COUNT(l.id) = (
                      SELECT COUNT(*) FROM user_progress up
                      JOIN lessons l2 ON l2.id = up.lesson_id
                      WHERE up.user_id = $1 AND l2.topic_id = l.topic_id
                  )
           ) AS completed_topics""",
        user_id,
    )

    for b in badges:
        if b["id"] in owned:
            continue
        cond = b["condition_json"] or {}
        t = cond.get("type")
        earned = (
            (t == "lessons_completed" and total_completed >= cond.get("count", 999))
            or (t == "total_xp" and user_xp >= cond.get("amount", 999))
            or (t == "streak" and streak >= cond.get("days", 999))
            or (t == "first_attempt_streak" and first_attempt_count >= cond.get("count", 999))
            or (t == "topic_completed" and topic_done)
            or (t == "topics_completed" and topics_completed_count >= cond.get("count", 999))
        )
        if earned:
            await conn.execute(
                "INSERT INTO user_badges (user_id, badge_id) VALUES ($1, $2) ON CONFLICT DO NOTHING",
                user_id, b["id"],
            )


class RunCodeRequest(BaseModel):
    code: str
    language: str = "python"


@router.post("/run")
async def run_code_playground(body: RunCodeRequest, user_id: str = Depends(get_current_user)):
    result = await execute_code(body.code, body.language)
    return {"output": result.get("output", ""), "error": result.get("error", "")}


@router.get("/daily")
async def get_daily_challenge(user_id: Optional[str] = Depends(get_optional_user)):
    today = _date.today()
    day_seed = today.year * 1000 + today.timetuple().tm_yday
    async with acquire() as conn:
        # Pick a code lesson, cycling by day
        total = await conn.fetchval("SELECT COUNT(*) FROM lessons WHERE type = 'code'")
        if not total:
            raise HTTPException(404, "No lessons available")
        offset = day_seed % int(total)
        lesson = await conn.fetchrow(
            """SELECT l.*, t.title AS topic_title
               FROM lessons l JOIN topics t ON t.id = l.topic_id
               WHERE l.type = 'code'
               ORDER BY l.id LIMIT 1 OFFSET $1""",
            offset,
        )
        is_completed = False
        if user_id and lesson:
            is_completed = bool(await conn.fetchval(
                "SELECT 1 FROM user_progress WHERE user_id=$1 AND lesson_id=$2",
                user_id, lesson["id"],
            ))
    if not lesson:
        raise HTTPException(404, "No lesson found")
    return {**dict(lesson), "is_completed": is_completed, "today": today.isoformat()}


@router.get("/quick-practice")
async def get_quick_practice(count: int = 5, ui_lang: str = "en", user_id: str = Depends(get_current_user)):
    """Returns random quiz lessons from topics the user has already started."""
    async with acquire() as conn:
        lessons = await conn.fetch(
            """
            SELECT l.id, l.title, l.type, l.content_json, l.xp_reward, l.topic_id,
                   l.language, l.order_index, t.title AS topic_title, l.translations
            FROM lessons l
            JOIN topics t ON t.id = l.topic_id
            WHERE l.type = 'quiz'
              AND l.topic_id IN (
                  SELECT DISTINCT l2.topic_id
                  FROM user_progress up
                  JOIN lessons l2 ON l2.id = up.lesson_id
                  WHERE up.user_id = $1
              )
            ORDER BY RANDOM()
            LIMIT $2
            """,
            user_id, min(count, 10),
        )

    result = []
    for lesson in lessons:
        d = dict(lesson)
        if ui_lang == "de":
            raw_tr = d.pop("translations", None)
            tr: dict = (raw_tr if isinstance(raw_tr, dict) else json.loads(raw_tr)) if raw_tr else {}
            if tr.get("content"):
                content = dict(d.get("content_json") or {})
                content.update(tr["content"])
                d["content_json"] = content
        else:
            d.pop("translations", None)
        result.append(d)
    return result


@router.get("/{lesson_id}")
async def get_lesson(lesson_id: int, ui_lang: str = "en", user_id: Optional[str] = Depends(get_optional_user)):
    async with acquire() as conn:
        lesson = await conn.fetchrow("SELECT * FROM lessons WHERE id = $1", lesson_id)
        if not lesson:
            raise HTTPException(status_code=404, detail="Lesson not found")

        is_completed, xp_earned = False, 0
        if user_id:
            row = await conn.fetchrow(
                "SELECT xp_earned FROM user_progress WHERE user_id = $1 AND lesson_id = $2",
                user_id, lesson_id,
            )
            if row:
                is_completed, xp_earned = True, row["xp_earned"]

        _raw_tr = lesson["translations"]
        existing_tr: dict = (_raw_tr if isinstance(_raw_tr, dict) else json.loads(_raw_tr)) if _raw_tr else {}
        needs_tr_update = False

        # For code/debug/advanced lessons: task-specific intro (lazy-persisted)
        concept_intro: Optional[str] = None
        if lesson["type"] in ("code", "debug", "advanced"):
            intro_key = f"task_intro_{ui_lang}"
            cache_key = (lesson_id, ui_lang)
            content = lesson["content_json"] or {}
            instructions = content.get("instructions", "")
            starter_code = content.get("starter_code", "")
            lang = lesson["language"] or "python"
            comment_char = "#" if lang == "python" else "//"
            de_content = existing_tr.get("content") or {}

            # Determine what still needs to be generated/translated
            need_intro = cache_key not in _task_intro_cache and intro_key not in existing_tr
            need_de_instr = ui_lang == "de" and not de_content.get("instructions") and bool(instructions)
            need_de_starter = (ui_lang == "de" and not de_content.get("starter_code")
                               and bool(starter_code) and comment_char in starter_code)
            need_de_hints = ui_lang == "de" and not de_content.get("hints") and bool(content.get("hints"))

            # Build coroutines for all needed calls, then gather them in parallel
            coros = []
            coro_keys = []
            if need_intro and instructions:
                coros.append(generate_task_intro(instructions, starter_code, lang, ui_lang))
                coro_keys.append("intro")
            if need_de_instr:
                coros.append(translate_to_german(instructions))
                coro_keys.append("de_instr")
            if need_de_starter:
                coros.append(translate_code_comments(starter_code, lang))
                coro_keys.append("de_starter")
            if need_de_hints:
                coros.append(translate_hints_to_german(content["hints"]))
                coro_keys.append("de_hints")

            if coros:
                results = await asyncio.gather(*coros, return_exceptions=True)
                result_map = dict(zip(coro_keys, results))

                if "intro" in result_map and not isinstance(result_map["intro"], Exception):
                    concept_intro = result_map["intro"]
                    if concept_intro:
                        _task_intro_cache[cache_key] = concept_intro
                        existing_tr[intro_key] = concept_intro
                        needs_tr_update = True
                if "de_instr" in result_map and not isinstance(result_map["de_instr"], Exception):
                    v = result_map["de_instr"]
                    if v:
                        de_content["instructions"] = v
                        existing_tr["content"] = de_content
                        needs_tr_update = True
                if "de_starter" in result_map and not isinstance(result_map["de_starter"], Exception):
                    v = result_map["de_starter"]
                    if v:
                        de_content["starter_code"] = v
                        existing_tr["content"] = de_content
                        needs_tr_update = True
                if "de_hints" in result_map and not isinstance(result_map["de_hints"], Exception):
                    v = result_map["de_hints"]
                    if v:
                        de_content["hints"] = v
                        existing_tr["content"] = de_content
                        needs_tr_update = True

            # Always populate concept_intro from existing cache/DB if not set above
            if concept_intro is None:
                if cache_key in _task_intro_cache:
                    concept_intro = _task_intro_cache[cache_key]
                elif intro_key in existing_tr:
                    concept_intro = existing_tr[intro_key]
                    _task_intro_cache[cache_key] = concept_intro

        elif lesson["type"] in ("theory", "quiz") and ui_lang == "de":
            # Translate full content on-demand and persist
            if not existing_tr.get("content"):
                raw_content = lesson["content_json"] or {}
                translated = await translate_lesson_content_to_german(raw_content, lesson["type"])
                if translated:
                    existing_tr["content"] = translated
                    needs_tr_update = True

        elif lesson["type"] == "explain":
            # Generate code snippet on first request and cache globally
            if not existing_tr.get("generated_code"):
                topic_constraints = (lesson["content_json"] or {}).get("topic_constraints", [])
                lang = lesson["language"] or "python"
                generated = await generate_explain_code(topic_constraints, lang)
                if generated:
                    existing_tr["generated_code"] = generated
                    needs_tr_update = True

        if needs_tr_update:
            # Pass dict directly — asyncpg's jsonb codec encodes it; json.dumps() would double-encode
            await conn.execute(
                "UPDATE lessons SET translations = $1 WHERE id = $2",
                existing_tr, lesson_id,
            )

        # Glossary: fetch cached explanations for this lesson's technical terms
        glossary = {}
        glossary_terms = existing_tr.get("glossary_terms") or []
        if glossary_terms:
            g_rows = await conn.fetch(
                "SELECT term, explanation_de, explanation_en, example, example_language FROM glossary WHERE term = ANY($1)",
                glossary_terms,
            )
            for g in g_rows:
                glossary[g["term"]] = {
                    "explanation": g["explanation_de"] if ui_lang == "de" else g["explanation_en"],
                    "example": g["example"],
                    "example_language": g["example_language"],
                }

    # Learning objectives (language-aware)
    lo_key = f"learning_objectives_{ui_lang}"
    learning_objectives = existing_tr.get(lo_key) or existing_tr.get("learning_objectives_en") or []

    story_context = existing_tr.get("story_context") or None

    # Recap quiz (3 questions testing lesson concepts)
    recap_quiz = existing_tr.get("recap_quiz") or []

    # Error context for debug lessons (realistic terminal error output)
    error_context = existing_tr.get("error_context") or None

    concept_refs = existing_tr.get("concept_refs") or []

    d = {**dict(lesson), "is_completed": is_completed, "xp_earned": xp_earned, "concept_intro": concept_intro, "glossary": glossary, "learning_objectives": learning_objectives, "story_context": story_context, "recap_quiz": recap_quiz, "error_context": error_context, "concept_refs": concept_refs}
    if ui_lang == "de":
        tr = existing_tr
        if tr.get("title"):
            d["title"] = tr["title"]
        if tr.get("content"):
            content = dict(d.get("content_json") or {})
            content.update(tr["content"])
            d["content_json"] = content
    # For explain lessons, embed the generated code into content_json
    if lesson["type"] == "explain":
        cj = dict(d.get("content_json") or {})
        cj["generated_code"] = existing_tr.get("generated_code", "")
        d["content_json"] = cj
    d.pop("translations", None)
    return d


@router.post("/{lesson_id}/submit", response_model=SubmitAnswerResponse)
async def submit_lesson(
    lesson_id: int,
    body: SubmitAnswerRequest,
    user_id: str = Depends(get_current_user),
):
    async with acquire() as conn:
        lesson = await conn.fetchrow("SELECT * FROM lessons WHERE id = $1", lesson_id)
        if not lesson:
            raise HTTPException(status_code=404, detail="Lesson not found")

        content = lesson["content_json"]
        already_done = await conn.fetchval(
            "SELECT 1 FROM user_progress WHERE user_id = $1 AND lesson_id = $2",
            user_id, lesson_id,
        )

        # Count this attempt before evaluating correctness
        await conn.execute(
            """INSERT INTO lesson_attempts (user_id, lesson_id, attempts)
               VALUES ($1, $2, 1)
               ON CONFLICT (user_id, lesson_id) DO UPDATE
               SET attempts = lesson_attempts.attempts + 1""",
            user_id, lesson_id,
        )

        correct, feedback, output, error_out = False, "", None, None
        expected_output_val: Optional[str] = None
        level_val: Optional[int] = None
        test_results_val: Optional[list] = None

        if lesson["type"] == "quiz":
            try:
                selected = int(body.answer)
            except ValueError:
                raise HTTPException(status_code=400, detail="Answer must be an integer index")
            ci = content.get("correct_index", 0)
            correct = selected == ci
            opts = content.get("options", [])
            option_explanations = content.get("option_explanations", [])
            correct_text = opts[ci] if ci < len(opts) else "the correct option"
            if correct:
                if option_explanations and selected < len(option_explanations):
                    feedback = option_explanations[selected]
                else:
                    feedback = "Correct! " + content.get("explanation", "Well done!")
            else:
                if option_explanations and selected < len(option_explanations):
                    feedback = option_explanations[selected] + f" The correct answer is: {correct_text}."
                else:
                    feedback = f"Not quite. The correct answer is: {correct_text}. {content.get('explanation', '')}"

        elif lesson["type"] == "code":
            # Check for input-based test cases (new multi-test format)
            all_test_cases = content.get("test_cases", [])
            input_test_cases = [tc for tc in all_test_cases if "input" in tc]

            if input_test_cases:
                # Multi-test-case mode: run code once per test case with different stdin
                results_list = []
                all_correct = True
                for tc in input_test_cases:
                    tc_result = await execute_code(body.answer, body.language, stdin=tc["input"])
                    tc_out = tc_result.get("output", "")
                    tc_err = tc_result.get("error", "")
                    tc_passed = bool(tc_out) and not tc_err and _check_output(tc_out, tc["expected_output"])
                    if tc_err and not tc_out:
                        tc_passed = False
                    if not tc_passed:
                        all_correct = False
                    results_list.append({
                        "description": tc.get("description", "Test case"),
                        "passed": tc_passed,
                        "expected": tc["expected_output"],
                        "actual": tc_out,
                        "error": tc_err if tc_err else None,
                    })
                correct = all_correct
                passed_count = sum(1 for r in results_list if r["passed"])
                feedback = (
                    f"All {len(results_list)} tests passed! Great work." if correct
                    else f"{passed_count}/{len(results_list)} tests passed."
                )
                test_results_val = results_list
                output = None  # not used in multi-test mode
                error_out = None
                expected_output_val = None
            else:
                # Single expected_output mode (existing behavior, backward compatible)
                result = await execute_code(body.answer, body.language)
                output = result.get("output", "")
                error_out = result.get("error", "")
                expected = content.get("expected_output", "")
                expected_output_val = expected
                if error_out and not output:
                    correct, feedback = False, f"Your code has an error:\n{error_out}"
                else:
                    correct = _check_output(output, expected)
                    feedback = (
                        "Perfect! Your code produced the correct output." if correct
                        else "Not quite right."
                    )

        elif lesson["type"] == "explain":
            raw_tr = lesson["translations"]
            tr: dict = (raw_tr if isinstance(raw_tr, dict) else json.loads(raw_tr)) if raw_tr else {}
            generated_code = tr.get("generated_code", "")
            if not generated_code:
                correct, feedback = True, "Code not found — lesson marked as complete."
            else:
                correct, feedback = await evaluate_explanation(generated_code, body.answer, lesson["language"] or "python")

        elif lesson["type"] == "theory":
            correct, feedback = True, "Great! Theory lesson completed."

        xp_earned = 0
        if correct and not already_done:
            attempt_count = await conn.fetchval(
                "SELECT attempts FROM lesson_attempts WHERE user_id = $1 AND lesson_id = $2",
                user_id, lesson_id,
            )
            is_first_attempt = (attempt_count == 1)
            xp_earned = lesson["xp_reward"] or 10

            await conn.execute(
                "INSERT INTO user_progress (user_id, lesson_id, xp_earned, first_attempt) VALUES ($1, $2, $3, $4)",
                user_id, lesson_id, xp_earned, is_first_attempt,
            )

            user_row = await conn.fetchrow("SELECT xp FROM users WHERE id = $1", user_id)
            new_xp = (user_row["xp"] or 0) + xp_earned
            new_level = max(1, new_xp // 100)

            await conn.execute(
                "UPDATE users SET xp = $1, level = $2 WHERE id = $3",
                new_xp, new_level, user_id,
            )
            level_val = new_level
            await conn.execute("SELECT log_lesson_activity($1, $2)", user_id, xp_earned)

            total_done = await conn.fetchval(
                "SELECT COUNT(*) FROM user_progress WHERE user_id = $1", user_id
            )
            first_attempt_count = await conn.fetchval(
                "SELECT COUNT(*) FROM user_progress WHERE user_id = $1 AND first_attempt = TRUE",
                user_id,
            )
            new_streak, _, _shield = await update_user_streak(conn, user_id)
            await _award_badges(
                conn, user_id, new_xp, total_done,
                streak=new_streak,
                first_attempt_count=first_attempt_count,
                topic_id=lesson["topic_id"],
            )

            # Schedule spaced repetition review (1 day from now)
            await conn.execute(
                """INSERT INTO review_schedule (user_id, lesson_id, next_review, interval_days)
                   VALUES ($1, $2, CURRENT_DATE + INTERVAL '1 day', 1)
                   ON CONFLICT (user_id, lesson_id) DO NOTHING""",
                user_id, lesson_id,
            )

        elif correct and already_done:
            feedback += " (Already completed — no XP awarded again.)"

        topic_completed = False
        if correct and not already_done and lesson["topic_id"]:
            _total = await conn.fetchval(
                "SELECT COUNT(*) FROM lessons WHERE topic_id = $1", lesson["topic_id"]
            )
            _done = await conn.fetchval(
                """SELECT COUNT(*) FROM user_progress up
                   JOIN lessons l ON l.id = up.lesson_id
                   WHERE up.user_id = $1 AND l.topic_id = $2""",
                user_id, lesson["topic_id"],
            )
            topic_completed = _total > 0 and _done >= _total

    return SubmitAnswerResponse(
        correct=correct, feedback=feedback, xp_earned=xp_earned, output=output, error=error_out,
        topic_completed=topic_completed,
        expected_output=expected_output_val,
        level=level_val,
        test_results=test_results_val,
    )
