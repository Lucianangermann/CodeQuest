from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv
import asyncio
import os

load_dotenv()

from db.connection import init_pool, close_pool
from routes import auth, topics, lessons, ai, user, leaderboard, onboarding, training_plan, checklist, weekly_checkin, interview, review, portfolio, notifications, capstone
from services.push import send_push


async def _warm_task_intro_cache():
    """On startup: load all existing task_intro_en/de from DB into in-memory cache (no AI calls)."""
    from db.connection import acquire
    from routes.lessons import _task_intro_cache
    try:
        async with acquire() as conn:
            rows = await conn.fetch(
                """SELECT id, translations FROM lessons
                   WHERE type IN ('code','debug','advanced')
                   AND translations IS NOT NULL
                   AND (translations ? 'task_intro_en' OR translations ? 'task_intro_de')"""
            )
        for r in rows:
            tr = r["translations"]
            if isinstance(tr, str):
                import json as _json
                tr = _json.loads(tr)
            for lang in ("en", "de"):
                key = f"task_intro_{lang}"
                if key in tr:
                    _task_intro_cache[(r["id"], lang)] = tr[key]
    except Exception:
        pass


async def _pregenerate_task_intros():
    """Background: generate EN + DE task intros for all code lessons missing them."""
    await asyncio.sleep(15)  # Let startup settle + cache warm first
    from db.connection import acquire
    from services.claude import generate_task_intro, translate_to_german
    from routes.lessons import _task_intro_cache

    sem = asyncio.Semaphore(3)  # Max 3 concurrent AI calls

    async def _process(lesson):
        import json as _json
        raw_tr = lesson["translations"]
        tr = (raw_tr if isinstance(raw_tr, dict) else _json.loads(raw_tr)) if raw_tr else {}
        content = lesson["content_json"] or {}
        instructions = content.get("instructions", "")
        starter_code = content.get("starter_code", "")
        lang = lesson["language"] or "python"
        if not instructions:
            return

        changed = False
        async with sem:
            for ui_lang in ("en", "de"):
                key = f"task_intro_{ui_lang}"
                cache_key = (lesson["id"], ui_lang)
                if key not in tr and cache_key not in _task_intro_cache:
                    try:
                        intro = await generate_task_intro(instructions, starter_code, lang, ui_lang)
                        if intro:
                            tr[key] = intro
                            _task_intro_cache[cache_key] = intro
                            changed = True
                    except Exception:
                        pass
            if not (tr.get("content") or {}).get("instructions"):
                try:
                    de_instr = await translate_to_german(instructions)
                    if de_instr:
                        de_content = tr.get("content") or {}
                        de_content["instructions"] = de_instr
                        tr["content"] = de_content
                        changed = True
                except Exception:
                    pass

        if changed:
            try:
                async with acquire() as conn:
                    await conn.execute(
                        "UPDATE lessons SET translations = $1 WHERE id = $2",
                        tr, lesson["id"],
                    )
            except Exception:
                pass

    try:
        async with acquire() as conn:
            lessons = await conn.fetch(
                """SELECT id, type, content_json, language, translations
                   FROM lessons WHERE type IN ('code','debug','advanced')
                   AND (translations->>'task_intro_en' IS NULL OR translations->>'task_intro_de' IS NULL)"""
            )
        await asyncio.gather(*[_process(l) for l in lessons])
    except Exception:
        pass


async def _prewarm_theory_quiz_de():
    """Background: translate all theory/quiz lessons to German if not yet cached."""
    await asyncio.sleep(20)
    from db.connection import acquire
    from services.claude import translate_lesson_content_to_german

    sem = asyncio.Semaphore(3)

    async def _translate_one(lesson):
        import json as _json
        raw_tr = lesson["translations"]
        tr = (raw_tr if isinstance(raw_tr, dict) else _json.loads(raw_tr)) if raw_tr else {}
        if tr.get("content"):
            return
        raw_content = lesson["content_json"] or {}
        async with sem:
            try:
                translated = await translate_lesson_content_to_german(raw_content, lesson["type"])
                if translated:
                    tr["content"] = translated
                    async with acquire() as conn:
                        await conn.execute(
                            "UPDATE lessons SET translations = $1 WHERE id = $2",
                            tr, lesson["id"],
                        )
            except Exception:
                pass

    try:
        async with acquire() as conn:
            lessons = await conn.fetch(
                """SELECT id, type, content_json, translations
                   FROM lessons WHERE type IN ('theory','quiz')
                   AND (translations IS NULL OR NOT (translations ? 'content'))"""
            )
        await asyncio.gather(*[_translate_one(l) for l in lessons])
    except Exception:
        pass


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
    await _warm_task_intro_cache()  # Synchronous: populate in-memory cache before serving
    task = asyncio.create_task(_daily_reminder_scheduler())
    pregen_task = asyncio.create_task(_pregenerate_task_intros())
    theory_task = asyncio.create_task(_prewarm_theory_quiz_de())
    yield
    task.cancel()
    pregen_task.cancel()
    theory_task.cancel()
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
app.include_router(capstone.router,       prefix="/capstone",        tags=["capstone"])


@app.get("/health")
async def health():
    return {"status": "ok", "version": "2.0.0"}
