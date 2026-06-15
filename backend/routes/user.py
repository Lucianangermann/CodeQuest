from fastapi import APIRouter, Depends, HTTPException
from datetime import date, timedelta
from typing import Optional
from models.schemas import DashboardStats, StreakUpdateResponse
from db.connection import acquire
from deps import get_current_user

router = APIRouter()


@router.get("/dashboard", response_model=DashboardStats)
async def get_dashboard(user_id: str = Depends(get_current_user)):
    async with acquire() as conn:
        user = await conn.fetchrow("SELECT * FROM users WHERE id = $1", user_id)
        if not user:
            raise HTTPException(status_code=404, detail="User not found")

        today = date.today()
        ninety_ago = today - timedelta(days=90)

        today_row = await conn.fetchrow(
            "SELECT lessons_completed, xp_earned FROM activity_log WHERE user_id = $1 AND date = $2",
            user_id, today,
        )
        total_completed = await conn.fetchval(
            "SELECT COUNT(*) FROM user_progress WHERE user_id = $1", user_id
        )
        topics = await conn.fetch(
            "SELECT id, title, icon, order_index FROM topics ORDER BY order_index"
        )
        topic_progress = await conn.fetch(
            """
            SELECT l.topic_id,
                   COUNT(l.id)  AS total,
                   COUNT(up.id) AS completed
            FROM topics t
            JOIN lessons l ON l.topic_id = t.id
            LEFT JOIN user_progress up ON up.lesson_id = l.id AND up.user_id = $1
            GROUP BY l.topic_id
            """,
            user_id,
        )
        progress_map = {r["topic_id"]: (r["total"], r["completed"]) for r in topic_progress}

        current_topic: Optional[dict] = None
        for t in topics:
            tid = t["id"]
            total, completed = progress_map.get(tid, (0, 0))
            if completed < total:
                current_topic = {
                    "id": tid, "title": t["title"], "icon": t["icon"],
                    "total": total, "completed": completed,
                }
                break

        badges = await conn.fetch(
            """
            SELECT b.name, b.description, b.icon, ub.earned_at::text AS earned_at
            FROM user_badges ub JOIN badges b ON b.id = ub.badge_id
            WHERE ub.user_id = $1
            ORDER BY ub.earned_at DESC LIMIT 3
            """,
            user_id,
        )
        activity = await conn.fetch(
            """
            SELECT date::text AS date, lessons_completed, xp_earned
            FROM activity_log
            WHERE user_id = $1 AND date >= $2
            ORDER BY date
            """,
            user_id, ninety_ago,
        )

    td = dict(today_row) if today_row else {}
    return DashboardStats(
        username=user["username"],
        avatar_url=user.get("avatar_url"),
        xp=user["xp"] or 0,
        level=user["level"] or 1,
        streak=user["streak"] or 0,
        daily_goal=user["daily_goal"] or 3,
        lessons_today=td.get("lessons_completed", 0),
        xp_today=td.get("xp_earned", 0),
        total_lessons_completed=total_completed or 0,
        current_topic=current_topic,
        recent_badges=[dict(b) for b in badges],
        activity_data=[dict(a) for a in activity],
    )


@router.post("/streak", response_model=StreakUpdateResponse)
async def update_streak(user_id: str = Depends(get_current_user)):
    async with acquire() as conn:
        row = await conn.fetchrow(
            "SELECT streak, last_active FROM users WHERE id = $1", user_id
        )
        if not row:
            raise HTTPException(status_code=404, detail="User not found")

        today = date.today()
        last = row["last_active"]
        streak = row["streak"] or 0
        is_new_day = False

        if last:
            delta = (today - last).days
            if delta == 1:
                streak += 1
                is_new_day = True
            elif delta > 1:
                streak = 1
                is_new_day = True
        else:
            streak = 1
            is_new_day = True

        if is_new_day:
            await conn.execute(
                "UPDATE users SET streak = $1, last_active = $2 WHERE id = $3",
                streak, today, user_id,
            )

        earned: list[dict] = []
        if is_new_day:
            badges = await conn.fetch("SELECT * FROM badges")
            owned = {r["badge_id"] for r in await conn.fetch(
                "SELECT badge_id FROM user_badges WHERE user_id = $1", user_id
            )}
            for b in badges:
                if b["id"] in owned:
                    continue
                cond = b["condition_json"] or {}
                if cond.get("type") == "streak" and streak >= cond.get("days", 999):
                    await conn.execute(
                        "INSERT INTO user_badges (user_id, badge_id) VALUES ($1, $2) ON CONFLICT DO NOTHING",
                        user_id, b["id"],
                    )
                    earned.append(dict(b))

    return StreakUpdateResponse(streak=streak, is_new_day=is_new_day, badges_earned=earned)


@router.get("/profile")
async def get_profile(user_id: str = Depends(get_current_user)):
    async with acquire() as conn:
        user = await conn.fetchrow(
            "SELECT id, email, username, avatar_url, xp, level, streak, "
            "language_preference, daily_goal, created_at FROM users WHERE id = $1",
            user_id,
        )
        if not user:
            raise HTTPException(status_code=404, detail="User not found")

        badges = await conn.fetch(
            """
            SELECT b.id, b.name, b.description, b.icon, b.condition_json,
                   ub.earned_at::text AS earned_at
            FROM user_badges ub JOIN badges b ON b.id = ub.badge_id
            WHERE ub.user_id = $1 ORDER BY ub.earned_at DESC
            """,
            user_id,
        )
        total = await conn.fetchval(
            "SELECT COUNT(*) FROM user_progress WHERE user_id = $1", user_id
        )

    u = dict(user)
    u["id"] = str(u["id"])
    if u.get("created_at"):
        u["created_at"] = u["created_at"].isoformat()
    return {**u, "badges": [dict(b) for b in badges], "total_lessons_completed": total or 0}


@router.patch("/profile")
async def update_profile(body: dict, user_id: str = Depends(get_current_user)):
    allowed = {"username", "avatar_url", "language_preference", "daily_goal"}
    update = {k: v for k, v in body.items() if k in allowed}
    if not update:
        raise HTTPException(status_code=400, detail="No valid fields to update")

    set_clause = ", ".join(f"{k} = ${i + 2}" for i, k in enumerate(update))
    async with acquire() as conn:
        row = await conn.fetchrow(
            f"UPDATE users SET {set_clause} WHERE id = $1 "
            f"RETURNING id, email, username, avatar_url, xp, level, streak, language_preference, daily_goal",
            user_id, *update.values(),
        )
    if not row:
        raise HTTPException(status_code=404, detail="User not found")
    r = dict(row)
    r["id"] = str(r["id"])
    return r
