from fastapi import APIRouter, Depends, HTTPException
from typing import Optional
from pydantic import BaseModel
from datetime import date as _date
from models.schemas import SubmitAnswerRequest, SubmitAnswerResponse
from db.connection import acquire
from services.code_runner import execute_code
from services.claude import generate_task_intro
from deps import get_current_user, get_optional_user
from utils.streak import update_user_streak

router = APIRouter()

# Cache task intros per (lesson_id, ui_lang) to avoid repeated AI calls
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
async def get_quick_practice(count: int = 5, user_id: str = Depends(get_current_user)):
    """Returns random quiz lessons from topics the user has already started."""
    async with acquire() as conn:
        lessons = await conn.fetch(
            """
            SELECT l.id, l.title, l.type, l.content_json, l.xp_reward, l.topic_id,
                   l.language, l.order_index, t.title AS topic_title
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
    return [dict(l) for l in lessons]


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

        # For code/debug/advanced lessons: generate a task-specific intro via AI (cached per lesson+lang)
        concept_intro: Optional[str] = None
        if lesson["type"] in ("code", "debug", "advanced"):
            cache_key = (lesson_id, ui_lang)
            if cache_key in _task_intro_cache:
                concept_intro = _task_intro_cache[cache_key]
            else:
                content = lesson["content_json"] or {}
                instructions = content.get("instructions", "")
                starter_code = content.get("starter_code", "")
                if instructions:
                    concept_intro = await generate_task_intro(
                        instructions, starter_code, lesson["language"] or "python", ui_lang
                    )
                    _task_intro_cache[cache_key] = concept_intro or ""

    d = {**dict(lesson), "is_completed": is_completed, "xp_earned": xp_earned, "concept_intro": concept_intro}
    if ui_lang == "de":
        tr = d.pop("translations", None) or {}
        if tr.get("title"):
            d["title"] = tr["title"]
        if tr.get("content"):
            content = dict(d.get("content_json") or {})
            content.update(tr["content"])
            d["content_json"] = content
    else:
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
            if correct:
                feedback = "Correct! " + content.get("explanation", "Well done!")
            else:
                opts = content.get("options", [])
                correct_text = opts[ci] if ci < len(opts) else "the correct option"
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
