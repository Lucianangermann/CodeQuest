from fastapi import APIRouter, Depends, HTTPException
from datetime import date, timedelta
from typing import Optional
from models.schemas import DashboardStats, StreakUpdateResponse
from db.connection import acquire
from deps import get_current_user
from utils.streak import update_user_streak

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

        next_lesson: Optional[dict] = None
        if current_topic:
            first_incomplete = await conn.fetchrow(
                """SELECT id, title, type, order_index
                   FROM lessons
                   WHERE topic_id = $1
                     AND (language IS NULL OR language = (SELECT language_preference FROM users WHERE id = $2))
                     AND id NOT IN (SELECT lesson_id FROM user_progress WHERE user_id = $2)
                   ORDER BY order_index LIMIT 1""",
                current_topic["id"], user_id,
            )
            if first_incomplete:
                next_lesson = {
                    "id": first_incomplete["id"],
                    "title": first_incomplete["title"],
                    "type": first_incomplete["type"],
                }

        badges = await conn.fetch(
            """
            SELECT b.name, b.description, b.icon, ub.earned_at::text AS earned_at
            FROM user_badges ub JOIN badges b ON b.id = ub.badge_id
            WHERE ub.user_id = $1
            ORDER BY ub.earned_at DESC LIMIT 3
            """,
            user_id,
        )
        all_badges = await conn.fetch("SELECT * FROM badges ORDER BY id")
        owned_ids = {r["badge_id"] for r in await conn.fetch(
            "SELECT badge_id FROM user_badges WHERE user_id = $1", user_id
        )}
        activity = await conn.fetch(
            """
            SELECT date::text AS date, lessons_completed, xp_earned
            FROM activity_log
            WHERE user_id = $1 AND date >= $2
            ORDER BY date
            """,
            user_id, ninety_ago,
        )

        week_start = today - timedelta(days=today.weekday())  # Monday of current week
        lessons_this_week = await conn.fetchval(
            """SELECT COALESCE(SUM(lessons_completed), 0)
               FROM activity_log WHERE user_id = $1 AND date >= $2""",
            user_id, week_start,
        )
        total_lessons = await conn.fetchval("SELECT COUNT(*) FROM lessons")

    td = dict(today_row) if today_row else {}
    user_xp = user["xp"] or 0
    user_streak = user["streak"] or 0
    completed_count = int(total_completed or 0)

    # Compute next unearned badge closest to completion
    next_badge: Optional[dict] = None
    best_progress = -1.0
    for b in all_badges:
        if b["id"] in owned_ids:
            continue
        cond = b["condition_json"] or {}
        badge_type = cond.get("type", "")
        progress_ratio = 0.0
        goal_label = ""
        if badge_type == "lessons_completed":
            goal = cond.get("count", 1)
            progress_ratio = completed_count / goal if goal else 0.0
            goal_label = f"{completed_count}/{goal} lessons"
        elif badge_type == "total_xp":
            goal = cond.get("amount", 100)
            progress_ratio = user_xp / goal if goal else 0.0
            goal_label = f"{user_xp}/{goal} XP"
        elif badge_type == "streak":
            goal = cond.get("days", 7)
            progress_ratio = user_streak / goal if goal else 0.0
            goal_label = f"{user_streak}/{goal} day streak"
        else:
            # Skip complex types (first_attempt_streak, topic_completed, etc.)
            continue
        if progress_ratio >= 1.0:
            continue  # already meets threshold, badge award handles this elsewhere
        if progress_ratio > best_progress:
            best_progress = progress_ratio
            next_badge = {
                "id": b["id"],
                "name": b["name"],
                "icon": b["icon"],
                "progress": round(progress_ratio, 4),
                "goal_label": goal_label,
            }

    return DashboardStats(
        username=user["username"],
        avatar_url=user.get("avatar_url"),
        xp=user_xp,
        level=user["level"] or 1,
        streak=user_streak,
        streak_shields=user["streak_shields"] if user["streak_shields"] is not None else 0,
        daily_goal=user["daily_goal"] or 3,
        lessons_today=td.get("lessons_completed", 0),
        xp_today=td.get("xp_earned", 0),
        total_lessons_completed=completed_count,
        lessons_this_week=int(lessons_this_week or 0),
        total_lessons=int(total_lessons or 0),
        current_topic=current_topic,
        next_lesson=next_lesson,
        next_badge=next_badge,
        recent_badges=[dict(b) for b in badges],
        activity_data=[dict(a) for a in activity],
    )


@router.post("/streak", response_model=StreakUpdateResponse)
async def update_streak(user_id: str = Depends(get_current_user)):
    async with acquire() as conn:
        user_check = await conn.fetchrow("SELECT id FROM users WHERE id = $1", user_id)
        if not user_check:
            raise HTTPException(status_code=404, detail="User not found")

        streak, is_new_day, shield_used = await update_user_streak(conn, user_id)

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

        # Auto-award 1 shield on Mondays if user has fewer than 3
        today = date.today()
        if today.weekday() == 0:  # Monday
            user_row = await conn.fetchrow(
                "SELECT streak_shields FROM users WHERE id = $1", user_id
            )
            current_shields = user_row["streak_shields"] if user_row and user_row["streak_shields"] is not None else 0
            if current_shields < 3:
                await conn.execute(
                    "UPDATE users SET streak_shields = streak_shields + 1 WHERE id = $1 AND streak_shields < 3",
                    user_id,
                )

    return StreakUpdateResponse(streak=streak, is_new_day=is_new_day, badges_earned=earned, shield_used=shield_used)


@router.post("/claim-shield")
async def claim_shield(user_id: str = Depends(get_current_user)):
    async with acquire() as conn:
        user_row = await conn.fetchrow(
            "SELECT streak_shields FROM users WHERE id = $1", user_id
        )
        if not user_row:
            raise HTTPException(status_code=404, detail="User not found")

        current_shields = user_row["streak_shields"] if user_row["streak_shields"] is not None else 0
        if current_shields >= 3:
            raise HTTPException(status_code=400, detail="You already have the maximum of 3 shields.")

        new_shields = await conn.fetchval(
            "UPDATE users SET streak_shields = streak_shields + 1 WHERE id = $1 AND streak_shields < 3 RETURNING streak_shields",
            user_id,
        )
        if new_shields is None:
            raise HTTPException(status_code=400, detail="Could not claim shield.")

    return {"shields": new_shields, "message": "Shield claimed! Your streak is now protected."}


@router.get("/profile")
async def get_profile(user_id: str = Depends(get_current_user)):
    async with acquire() as conn:
        user = await conn.fetchrow(
            "SELECT id, email, username, avatar_url, xp, level, streak, streak_shields, "
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


@router.get("/badges")
async def get_all_badges(user_id: str = Depends(get_current_user)):
    async with acquire() as conn:
        all_badges = await conn.fetch("SELECT * FROM badges ORDER BY id")
        earned = await conn.fetch(
            "SELECT badge_id, earned_at::text FROM user_badges WHERE user_id = $1", user_id
        )
        earned_map = {r["badge_id"]: r["earned_at"] for r in earned}

        # Fetch counts for progress toward badges
        total_lessons = await conn.fetchval(
            "SELECT COUNT(*) FROM user_progress WHERE user_id = $1", user_id
        )
        first_attempt_count = await conn.fetchval(
            "SELECT COUNT(*) FROM user_progress WHERE user_id = $1 AND first_attempt = TRUE", user_id
        )
        user_row = await conn.fetchrow("SELECT xp, streak FROM users WHERE id = $1", user_id)

    result = []
    for b in all_badges:
        cond = b["condition_json"] or {}
        badge_type = cond.get("type", "")
        earned_at = earned_map.get(b["id"])

        progress, goal = None, None
        if badge_type == "lessons_completed":
            progress, goal = int(total_lessons), cond.get("count", 1)
        elif badge_type == "total_xp":
            progress, goal = int(user_row["xp"] or 0), cond.get("amount", 100)
        elif badge_type == "streak":
            progress, goal = int(user_row["streak"] or 0), cond.get("days", 7)
        elif badge_type == "first_attempt_streak":
            progress, goal = int(first_attempt_count), cond.get("count", 5)

        result.append({
            "id": b["id"],
            "name": b["name"],
            "description": b["description"],
            "icon": b["icon"],
            "condition_json": dict(cond),
            "earned": earned_at is not None,
            "earned_at": earned_at,
            "progress": progress,
            "goal": goal,
        })

    return {"badges": result}
