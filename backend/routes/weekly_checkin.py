from fastapi import APIRouter, Depends
from pydantic import BaseModel
from typing import Optional
from datetime import datetime, date

from db.connection import acquire
from deps import get_current_user

router = APIRouter()


def _iso_week(d: date):
    iso = d.isocalendar()
    return iso[1], iso[0]  # week_number, year


class CheckinRequest(BaseModel):
    tasks_completed: int
    tasks_total: int
    notes: Optional[str] = None


@router.get("/current")
async def get_current_checkin(user_id: str = Depends(get_current_user)):
    week, year = _iso_week(date.today())
    async with acquire() as conn:
        row = await conn.fetchrow(
            "SELECT tasks_completed, tasks_total, notes, created_at "
            "FROM weekly_checkins WHERE user_id = $1 AND week_number = $2 AND year = $3",
            user_id, week, year,
        )

    if not row:
        return {"checkin": None, "week": week, "year": year}

    return {
        "checkin": {
            "tasks_completed": row["tasks_completed"],
            "tasks_total": row["tasks_total"],
            "notes": row["notes"],
            "created_at": row["created_at"].isoformat(),
        },
        "week": week,
        "year": year,
    }


@router.post("/")
async def create_checkin(body: CheckinRequest, user_id: str = Depends(get_current_user)):
    week, year = _iso_week(date.today())
    async with acquire() as conn:
        await conn.execute(
            """INSERT INTO weekly_checkins (user_id, week_number, year, tasks_completed, tasks_total, notes)
               VALUES ($1, $2, $3, $4, $5, $6)
               ON CONFLICT (user_id, week_number, year) DO UPDATE SET
                 tasks_completed=$4, tasks_total=$5, notes=$6""",
            user_id, week, year, body.tasks_completed, body.tasks_total, body.notes,
        )

    return {"ok": True, "week": week, "year": year}
