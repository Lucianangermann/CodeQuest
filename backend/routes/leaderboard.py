from fastapi import APIRouter, Depends
from datetime import date, timedelta
from typing import List, Optional
from models.schemas import LeaderboardEntry
from db.connection import acquire
from deps import get_optional_user

router = APIRouter()


@router.get("/", response_model=List[LeaderboardEntry])
async def get_leaderboard(user_id: Optional[str] = Depends(get_optional_user)):
    seven_ago = date.today() - timedelta(days=7)

    async with acquire() as conn:
        rows = await conn.fetch(
            """
            SELECT u.id, u.username, u.avatar_url, SUM(al.xp_earned) AS weekly_xp
            FROM activity_log al
            JOIN users u ON u.id = al.user_id
            WHERE al.date >= $1
            GROUP BY u.id, u.username, u.avatar_url
            ORDER BY weekly_xp DESC
            LIMIT 50
            """,
            seven_ago,
        )

    return [
        LeaderboardEntry(
            rank=i + 1,
            user_id=str(r["id"]),
            username=r["username"],
            avatar_url=r.get("avatar_url"),
            weekly_xp=r["weekly_xp"],
            is_current_user=str(r["id"]) == user_id,
        )
        for i, r in enumerate(rows)
    ]
