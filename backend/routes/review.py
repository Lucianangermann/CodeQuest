from fastapi import APIRouter, Depends
from pydantic import BaseModel
from db.connection import acquire
from deps import get_current_user

router = APIRouter()


class ReviewResultRequest(BaseModel):
    lesson_id: int
    quality: int  # 1=hard, 3=good, 5=easy


@router.get("/due")
async def get_due_reviews(user_id: str = Depends(get_current_user)):
    async with acquire() as conn:
        rows = await conn.fetch(
            """SELECT rs.lesson_id, rs.next_review, rs.interval_days, rs.ease_factor,
                      l.title, l.type, l.topic_id, l.content_json, l.xp_reward,
                      t.title AS topic_title
               FROM review_schedule rs
               JOIN lessons l ON l.id = rs.lesson_id
               JOIN topics t ON t.id = l.topic_id
               WHERE rs.user_id = $1 AND rs.next_review <= CURRENT_DATE
               ORDER BY rs.next_review ASC LIMIT 10""",
            user_id,
        )
    return {
        "due": [
            {
                "lesson_id": r["lesson_id"],
                "title": r["title"],
                "type": r["type"],
                "topic_title": r["topic_title"],
                "content": dict(r["content_json"]),
                "interval_days": r["interval_days"],
                "next_review": r["next_review"].isoformat(),
            }
            for r in rows
        ]
    }


@router.post("/result")
async def submit_review_result(body: ReviewResultRequest, user_id: str = Depends(get_current_user)):
    # SM-2 simplified: adjust interval based on quality (1-5)
    async with acquire() as conn:
        row = await conn.fetchrow(
            "SELECT interval_days, ease_factor FROM review_schedule WHERE user_id=$1 AND lesson_id=$2",
            user_id, body.lesson_id,
        )
    if not row:
        return {"ok": False, "error": "Card not found"}

    interval = row["interval_days"]
    ease = row["ease_factor"] or 2.5

    if body.quality < 3:
        # Failed: reset to 1 day
        new_interval = 1
    else:
        # Passed: extend interval
        if interval == 1:
            new_interval = 3
        elif interval == 3:
            new_interval = 7
        else:
            new_interval = round(interval * ease)

    # Update ease factor
    new_ease = max(1.3, ease + 0.1 - (5 - body.quality) * 0.08)

    async with acquire() as conn:
        await conn.execute(
            """UPDATE review_schedule
               SET next_review = CURRENT_DATE + ($3 || ' days')::interval,
                   interval_days = $3, ease_factor = $4, last_reviewed = CURRENT_DATE
               WHERE user_id = $1 AND lesson_id = $2""",
            user_id, body.lesson_id, new_interval, new_ease,
        )
    return {"ok": True, "next_interval_days": new_interval}


@router.get("/count")
async def get_due_count(user_id: str = Depends(get_current_user)):
    async with acquire() as conn:
        count = await conn.fetchval(
            "SELECT COUNT(*) FROM review_schedule WHERE user_id=$1 AND next_review <= CURRENT_DATE",
            user_id,
        )
    return {"due_count": int(count or 0)}
