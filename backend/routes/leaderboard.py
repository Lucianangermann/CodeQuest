from fastapi import APIRouter, Depends
from datetime import date, timedelta
from typing import List, Optional
from models.schemas import LeaderboardEntry
from db.connection import acquire
from deps import get_optional_user

router = APIRouter()


@router.get("/")
async def get_leaderboard(
    user_id: Optional[str] = Depends(get_optional_user),
    page: int = 1,
    per_page: int = 20,
):
    seven_ago = date.today() - timedelta(days=7)
    offset = (page - 1) * per_page

    async with acquire() as conn:
        total_count = await conn.fetchval("SELECT COUNT(*) FROM users")
        rows = await conn.fetch(
            """
            SELECT u.id, u.username, u.avatar_url, SUM(al.xp_earned) AS weekly_xp
            FROM activity_log al
            JOIN users u ON u.id = al.user_id
            WHERE al.date >= $1
            GROUP BY u.id, u.username, u.avatar_url
            ORDER BY weekly_xp DESC
            LIMIT $2 OFFSET $3
            """,
            seven_ago, per_page, offset,
        )

    entries = [
        LeaderboardEntry(
            rank=offset + i + 1,
            user_id=str(r["id"]),
            username=r["username"],
            avatar_url=r.get("avatar_url"),
            weekly_xp=r["weekly_xp"],
            is_current_user=str(r["id"]) == user_id,
        )
        for i, r in enumerate(rows)
    ]
    return {
        "entries": [e.model_dump() for e in entries],
        "page": page,
        "per_page": per_page,
        "total": total_count,
    }
