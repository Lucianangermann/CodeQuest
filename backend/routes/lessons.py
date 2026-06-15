from fastapi import APIRouter, Depends, HTTPException
from typing import Optional
from models.schemas import SubmitAnswerRequest, SubmitAnswerResponse
from db.connection import acquire
from services.code_runner import execute_code
from deps import get_current_user, get_optional_user

router = APIRouter()


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
        )
        if earned:
            await conn.execute(
                "INSERT INTO user_badges (user_id, badge_id) VALUES ($1, $2) ON CONFLICT DO NOTHING",
                user_id, b["id"],
            )


@router.get("/{lesson_id}")
async def get_lesson(lesson_id: int, user_id: Optional[str] = Depends(get_optional_user)):
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

    return {**dict(lesson), "is_completed": is_completed, "xp_earned": xp_earned}


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
            result = await execute_code(body.answer, body.language)
            output = result.get("output", "")
            error_out = result.get("error", "")
            expected = content.get("expected_output", "")
            if error_out and not output:
                correct, feedback = False, f"Your code has an error:\n{error_out}"
            else:
                correct = _check_output(output, expected)
                feedback = (
                    "Perfect! Your code produced the correct output." if correct
                    else f"Not quite right.\n\nExpected:\n{expected.strip()}\n\nYour output:\n{output.strip() or '(empty)'}"
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

            user_row = await conn.fetchrow("SELECT xp, streak FROM users WHERE id = $1", user_id)
            new_xp = (user_row["xp"] or 0) + xp_earned
            new_level = max(1, new_xp // 100)
            streak = user_row["streak"] or 0

            await conn.execute(
                "UPDATE users SET xp = $1, level = $2, last_active = CURRENT_DATE WHERE id = $3",
                new_xp, new_level, user_id,
            )
            await conn.execute("SELECT log_lesson_activity($1, $2)", user_id, xp_earned)

            total_done = await conn.fetchval(
                "SELECT COUNT(*) FROM user_progress WHERE user_id = $1", user_id
            )
            first_attempt_count = await conn.fetchval(
                "SELECT COUNT(*) FROM user_progress WHERE user_id = $1 AND first_attempt = TRUE",
                user_id,
            )
            await _award_badges(
                conn, user_id, new_xp, total_done,
                streak=streak,
                first_attempt_count=first_attempt_count,
                topic_id=lesson["topic_id"],
            )

        elif correct and already_done:
            feedback += " (Already completed — no XP awarded again.)"

    return SubmitAnswerResponse(
        correct=correct, feedback=feedback, xp_earned=xp_earned, output=output, error=error_out
    )
