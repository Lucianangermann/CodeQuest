from fastapi import APIRouter, Depends
from typing import Optional, List
from models.schemas import TopicWithProgress
from db.connection import acquire
from deps import get_optional_user

router = APIRouter()


@router.get("/", response_model=List[TopicWithProgress])
async def get_topics(language: str = "python", user_id: Optional[str] = Depends(get_optional_user)):
    async with acquire() as conn:
        topics = await conn.fetch("SELECT * FROM topics ORDER BY order_index")

        counts = {
            r["topic_id"]: r["total"]
            for r in await conn.fetch(
                "SELECT topic_id, COUNT(*) AS total FROM lessons WHERE (language IS NULL OR language = $1) GROUP BY topic_id",
                language,
            )
        }

        completed_by_topic: dict[int, int] = {}
        if user_id:
            rows = await conn.fetch(
                """
                SELECT l.topic_id, COUNT(*) AS completed
                FROM user_progress up
                JOIN lessons l ON l.id = up.lesson_id
                WHERE up.user_id = $1 AND (l.language IS NULL OR l.language = $2)
                GROUP BY l.topic_id
                """,
                user_id,
                language,
            )
            completed_by_topic = {r["topic_id"]: r["completed"] for r in rows}

    result = []
    for i, t in enumerate(topics):
        tid = t["id"]
        total = counts.get(tid, 0)
        completed = completed_by_topic.get(tid, 0)
        is_completed = total > 0 and completed >= total

        is_locked = False
        if i > 0:
            prev_tid = topics[i - 1]["id"]
            prev_total = counts.get(prev_tid, 0)
            prev_done = completed_by_topic.get(prev_tid, 0)
            is_locked = not (prev_total > 0 and prev_done >= prev_total)

        result.append(TopicWithProgress(
            id=tid,
            title=t["title"],
            description=t.get("description"),
            order_index=t["order_index"],
            icon=t.get("icon"),
            total_lessons=total,
            completed_lessons=completed,
            is_locked=is_locked,
            is_completed=is_completed,
        ))

    return result


@router.get("/{topic_id}/lessons")
async def get_topic_lessons(topic_id: int, language: str = "python", user_id: Optional[str] = Depends(get_optional_user)):
    async with acquire() as conn:
        lessons = await conn.fetch(
            "SELECT * FROM lessons WHERE topic_id = $1 AND (language IS NULL OR language = $2) ORDER BY order_index",
            topic_id,
            language,
        )
        completed: dict[int, int] = {}
        attempts: dict[int, int] = {}
        if user_id:
            rows = await conn.fetch(
                "SELECT lesson_id, xp_earned FROM user_progress WHERE user_id = $1", user_id
            )
            completed = {r["lesson_id"]: r["xp_earned"] for r in rows}
            attempt_rows = await conn.fetch(
                "SELECT lesson_id, attempts FROM lesson_attempts WHERE user_id = $1", user_id
            )
            attempts = {r["lesson_id"]: r["attempts"] for r in attempt_rows}

    def calc_mastery(lesson_id: int) -> int:
        if lesson_id not in completed:
            return 0
        n = attempts.get(lesson_id, 4)
        if n == 1:
            return 3
        elif n <= 3:
            return 2
        else:
            return 1

    return [
        {**dict(l), "is_completed": l["id"] in completed, "xp_earned": completed.get(l["id"], 0), "mastery_level": calc_mastery(l["id"])}
        for l in lessons
    ]
