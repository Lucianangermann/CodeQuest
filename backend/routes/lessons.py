from fastapi import APIRouter, Depends, HTTPException
from typing import Optional
from models.schemas import SubmitAnswerRequest, SubmitAnswerResponse
from db.connection import acquire
from services.code_runner import execute_code
from deps import get_current_user, get_optional_user

router = APIRouter()


def _check_output(actual: str, expected: str) -> bool:
    return actual.strip() == expected.strip()


async def _award_badges(conn, user_id: str, user_xp: int, total_completed: int) -> None:
    badges = await conn.fetch("SELECT * FROM badges")
    owned = {r["badge_id"] for r in await conn.fetch(
        "SELECT badge_id FROM user_badges WHERE user_id = $1", user_id
    )}
    for b in badges:
        if b["id"] in owned:
            continue
        cond = b["condition_json"] or {}
        earned = (
            (cond.get("type") == "lessons_completed" and total_completed >= cond.get("count", 999))
            or (cond.get("type") == "total_xp" and user_xp >= cond.get("amount", 999))
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
            xp_earned = lesson["xp_reward"] or 10

            await conn.execute(
                "INSERT INTO user_progress (user_id, lesson_id, xp_earned) VALUES ($1, $2, $3)",
                user_id, lesson_id, xp_earned,
            )

            user_row = await conn.fetchrow("SELECT xp FROM users WHERE id = $1", user_id)
            new_xp = (user_row["xp"] or 0) + xp_earned
            new_level = max(1, new_xp // 100)

            await conn.execute(
                "UPDATE users SET xp = $1, level = $2, last_active = CURRENT_DATE WHERE id = $3",
                new_xp, new_level, user_id,
            )
            await conn.execute("SELECT log_lesson_activity($1, $2)", user_id, xp_earned)

            total_done = await conn.fetchval(
                "SELECT COUNT(*) FROM user_progress WHERE user_id = $1", user_id
            )
            await _award_badges(conn, user_id, new_xp, total_done)

        elif correct and already_done:
            feedback += " (Already completed — no XP awarded again.)"

    return SubmitAnswerResponse(
        correct=correct, feedback=feedback, xp_earned=xp_earned, output=output, error=error_out
    )
