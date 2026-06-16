from datetime import date
from typing import Optional


async def update_user_streak(conn, user_id: str) -> tuple[int, bool, bool]:
    """Update user streak. Returns (new_streak, is_new_day, shield_used)."""
    row = await conn.fetchrow(
        "SELECT streak, last_active, streak_shields FROM users WHERE id = $1", user_id
    )
    if not row:
        return 0, False, False

    today = date.today()
    last: Optional[date] = row["last_active"]
    streak = row["streak"] or 0
    shields = row["streak_shields"] or 0
    is_new_day = False
    shield_used = False

    if last:
        delta = (today - last).days
        if delta == 1:
            streak += 1
            is_new_day = True
        elif delta > 1:
            if shields > 0:
                # Consume 1 shield and preserve the streak
                await conn.execute(
                    "UPDATE users SET streak_shields = streak_shields - 1 WHERE id = $1",
                    user_id,
                )
                shield_used = True
                is_new_day = True
                # streak stays unchanged (protected)
            else:
                streak = 1
                is_new_day = True
        # delta == 0: same day, no change
    else:
        streak = 1
        is_new_day = True

    if is_new_day:
        await conn.execute(
            "UPDATE users SET streak = $1, last_active = $2 WHERE id = $3",
            streak, today, user_id,
        )

    return streak, is_new_day, shield_used
