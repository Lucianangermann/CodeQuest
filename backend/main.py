from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv
import asyncio
import os

load_dotenv()

from db.connection import init_pool, close_pool
from routes import auth, topics, lessons, ai, user, leaderboard, onboarding, training_plan, checklist, weekly_checkin, interview, review, portfolio, notifications
from services.push import send_push


async def _daily_reminder_scheduler():
    """At 20:00 server time, push reminders to users who haven't practiced today."""
    from datetime import datetime, timedelta
    while True:
        try:
            now = datetime.now()
            target = now.replace(hour=20, minute=0, second=0, microsecond=0)
            if now >= target:
                target += timedelta(days=1)
            await asyncio.sleep((target - now).total_seconds())

            from db.connection import acquire
            async with acquire() as conn:
                subs = await conn.fetch(
                    """SELECT ps.endpoint, ps.p256dh, ps.auth, u.username, u.streak
                       FROM push_subscriptions ps
                       JOIN users u ON u.id = ps.user_id
                       WHERE NOT EXISTS (
                           SELECT 1 FROM activity_log al
                           WHERE al.user_id = ps.user_id AND al.date = CURRENT_DATE
                       )"""
                )
            for sub in subs:
                await send_push(
                    {"endpoint": sub["endpoint"], "keys": {"p256dh": sub["p256dh"], "auth": sub["auth"]}},
                    title=f"Keep your {sub['streak']}-day streak! 🔥" if sub["streak"] > 0 else "Time to practice! 📚",
                    body="You haven't coded today. Don't break the habit!",
                    url="/dashboard"
                )
        except asyncio.CancelledError:
            break
        except Exception:
            await asyncio.sleep(3600)


@asynccontextmanager
async def lifespan(app: FastAPI):
    await init_pool()
    task = asyncio.create_task(_daily_reminder_scheduler())
    yield
    task.cancel()
    await close_pool()


app = FastAPI(title="CodeQuest API", version="2.0.0", lifespan=lifespan)

origins = [o.strip() for o in os.getenv("CORS_ORIGINS", "http://localhost:5173").split(",")]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router,           prefix="/auth",           tags=["auth"])
app.include_router(topics.router,         prefix="/topics",         tags=["topics"])
app.include_router(lessons.router,        prefix="/lessons",        tags=["lessons"])
app.include_router(ai.router,             prefix="/ai",             tags=["ai"])
app.include_router(user.router,           prefix="/user",           tags=["user"])
app.include_router(leaderboard.router,    prefix="/leaderboard",    tags=["leaderboard"])
app.include_router(onboarding.router,     prefix="/onboarding",     tags=["onboarding"])
app.include_router(training_plan.router,  prefix="/training-plan",  tags=["training-plan"])
app.include_router(checklist.router,      prefix="/checklist",      tags=["checklist"])
app.include_router(weekly_checkin.router, prefix="/weekly-checkin", tags=["weekly-checkin"])
app.include_router(interview.router,      prefix="/interview",      tags=["interview"])
app.include_router(review.router,         prefix="/review",         tags=["review"])
app.include_router(portfolio.router,      prefix="/portfolio",      tags=["portfolio"])
app.include_router(notifications.router,  prefix="/notifications",  tags=["notifications"])


@app.get("/health")
async def health():
    return {"status": "ok", "version": "2.0.0"}
