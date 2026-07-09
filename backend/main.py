from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv
import asyncio
import os

load_dotenv()

from db.connection import init_pool, close_pool
from routes import auth, topics, lessons, ai, user, leaderboard, onboarding, training_plan, checklist, weekly_checkin, interview, review, portfolio, notifications, capstone, ihk_checklist
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


async def _prewarm_hints():
    """Background: generate hints 2+3 for any code/debug lesson that has fewer than 3 pre-stored."""
    await asyncio.sleep(60)
    from db.connection import acquire
    from services.claude import generate_missing_hints

    sem = asyncio.Semaphore(2)

    async def _fill(lesson):
        import json as _json
        raw = lesson["content_json"] or {}
        hints = raw.get("hints", [])
        if len(hints) >= 3:
            return
        instructions = raw.get("instructions", "")
        if not instructions:
            return
        language = lesson["language"] or "python"
        async with sem:
            try:
                new_hints = await generate_missing_hints(instructions, hints, language)
                if not new_hints:
                    return
                updated = dict(raw)
                updated["hints"] = hints + new_hints
                async with acquire() as conn:
                    await conn.execute(
                        "UPDATE lessons SET content_json = $1 WHERE id = $2",
                        updated, lesson["id"],
                    )
            except Exception:
                pass

    try:
        async with acquire() as conn:
            rows = await conn.fetch(
                "SELECT id, content_json, language FROM lessons WHERE type IN ('code','debug','advanced')"
            )
        await asyncio.gather(*[_fill(r) for r in rows])
    except Exception:
        pass


async def _generate_test_cases_bg():
    """Background: generate stdin test cases for code lessons that only have expected_output."""
    await asyncio.sleep(90)
    from db.connection import acquire
    from services.claude import generate_test_cases_for_lesson

    sem = asyncio.Semaphore(2)

    async def _add(lesson):
        raw = lesson["content_json"] or {}
        if raw.get("test_cases"):
            return
        instructions = raw.get("instructions", "")
        solution = raw.get("solution", "")
        if not instructions or not solution:
            return
        # Only for lessons whose instructions indicate stdin usage
        if not any(kw in instructions.lower() for kw in ["input", "read", "enter", "stdin"]):
            return
        language = lesson["language"] or "python"
        async with sem:
            try:
                cases = await generate_test_cases_for_lesson(
                    instructions, raw.get("expected_output", ""), solution, language
                )
                if not cases:
                    return
                updated = dict(raw)
                updated["test_cases"] = cases
                async with acquire() as conn:
                    await conn.execute(
                        "UPDATE lessons SET content_json = $1 WHERE id = $2",
                        updated, lesson["id"],
                    )
            except Exception:
                pass

    try:
        async with acquire() as conn:
            rows = await conn.fetch(
                """SELECT id, content_json, language FROM lessons
                   WHERE type = 'code' AND NOT (content_json ? 'test_cases')"""
            )
        await asyncio.gather(*[_add(r) for r in rows])
    except Exception:
        pass


async def _generate_quiz_explanations_bg():
    """Background: generate per-option explanations for quiz lessons that lack them."""
    await asyncio.sleep(120)
    from db.connection import acquire
    from services.claude import generate_quiz_option_explanations

    sem = asyncio.Semaphore(2)

    async def _add(lesson):
        raw = lesson["content_json"] or {}
        if raw.get("option_explanations"):
            return
        question = raw.get("question", "")
        options = raw.get("options", [])
        correct_index = raw.get("correct_index", 0)
        if not question or len(options) < 2:
            return
        async with sem:
            try:
                explanations = await generate_quiz_option_explanations(question, options, correct_index)
                if not explanations or len(explanations) != len(options):
                    return
                updated = dict(raw)
                updated["option_explanations"] = explanations
                async with acquire() as conn:
                    await conn.execute(
                        "UPDATE lessons SET content_json = $1 WHERE id = $2",
                        updated, lesson["id"],
                    )
            except Exception:
                pass

    try:
        async with acquire() as conn:
            rows = await conn.fetch(
                """SELECT id, content_json FROM lessons
                   WHERE type = 'quiz' AND NOT (content_json ? 'option_explanations')"""
            )
        await asyncio.gather(*[_add(r) for r in rows])
    except Exception:
        pass


async def _generate_why_matters_bg():
    """Background: add 'why this matters' real-world context to theory lessons (EN + DE)."""
    await asyncio.sleep(150)
    from db.connection import acquire
    from services.claude import generate_why_matters
    import json as _json2

    sem = asyncio.Semaphore(2)

    async def _process(lesson):
        raw_tr = lesson["translations"]
        tr = (raw_tr if isinstance(raw_tr, dict) else _json2.loads(raw_tr)) if raw_tr else {}
        raw = lesson["content_json"] or {}
        legacy = raw.get("why_matters")
        if legacy and not tr.get("why_matters_en"):
            tr["why_matters_en"] = legacy
        language = lesson["language"] or "python"
        async with sem:
            try:
                for ui_lang in ("en", "de"):
                    key = f"why_matters_{ui_lang}"
                    if key not in tr:
                        why = await generate_why_matters(lesson["topic_title"], raw, language, ui_lang)
                        if why:
                            tr[key] = why
                if tr.get("why_matters_en") or tr.get("why_matters_de"):
                    async with acquire() as conn:
                        await conn.execute(
                            "UPDATE lessons SET translations = $1 WHERE id = $2",
                            tr, lesson["id"],
                        )
            except Exception:
                pass

    try:
        async with acquire() as conn:
            rows = await conn.fetch(
                """SELECT l.id, l.content_json, l.translations, l.language, t.title AS topic_title
                   FROM lessons l JOIN topics t ON t.id = l.topic_id
                   WHERE l.type = 'theory'
                   AND (l.translations IS NULL OR NOT (l.translations ? 'why_matters_de'))"""
            )
        await asyncio.gather(*[_process(r) for r in rows])
    except Exception:
        pass


async def _generate_learning_objectives_bg():
    """Background: generate learning objectives for all lessons that don't have them yet."""
    await asyncio.sleep(210)
    from db.connection import acquire
    from services.claude import generate_learning_objectives
    import json as _json

    sem = asyncio.Semaphore(2)

    async def _process(lesson):
        import json as _json2
        raw_tr = lesson["translations"]
        tr = (raw_tr if isinstance(raw_tr, dict) else _json2.loads(raw_tr)) if raw_tr else {}
        if tr.get("learning_objectives") is not None:
            return
        raw = lesson["content_json"] or {}
        # Build a short summary from content
        if lesson["type"] == "theory":
            sections = raw.get("sections", [])
            summary = " ".join(s.get("content", "")[:200] for s in sections[:2])
        elif lesson["type"] == "quiz":
            summary = raw.get("question", "")
        else:
            summary = raw.get("instructions", "")[:300]
        if not summary:
            return
        prog_lang = lesson["language"] or "general"
        async with sem:
            try:
                for ui_lang in ("en", "de"):
                    key = f"learning_objectives_{ui_lang}"
                    if key not in tr:
                        objs = await generate_learning_objectives(
                            lesson["title"], lesson["type"], summary, prog_lang, ui_lang
                        )
                        if objs:
                            tr[key] = objs
                if tr.get("learning_objectives_en") or tr.get("learning_objectives_de"):
                    async with acquire() as conn:
                        await conn.execute(
                            "UPDATE lessons SET translations = $1 WHERE id = $2",
                            tr, lesson["id"],
                        )
            except Exception:
                pass

    try:
        async with acquire() as conn:
            rows = await conn.fetch(
                """SELECT id, title, type, content_json, language, translations FROM lessons
                   WHERE translations IS NULL
                   OR (NOT (translations ? 'learning_objectives_en')
                   AND NOT (translations ? 'learning_objectives_de'))"""
            )
        await asyncio.gather(*[_process(r) for r in rows])
    except Exception:
        pass


async def _generate_story_contexts_bg():
    """Background: generate real-world story context for code/debug lessons."""
    await asyncio.sleep(240)
    from db.connection import acquire
    from services.claude import generate_story_context
    import json as _json

    sem = asyncio.Semaphore(2)

    async def _process(lesson):
        import json as _json2
        raw_tr = lesson["translations"]
        tr = (raw_tr if isinstance(raw_tr, dict) else _json2.loads(raw_tr)) if raw_tr else {}
        if tr.get("story_context") is not None:
            return
        raw = lesson["content_json"] or {}
        instructions = raw.get("instructions", "")
        if not instructions:
            return
        prog_lang = lesson["language"] or "python"
        async with sem:
            try:
                ctx = await generate_story_context(lesson["title"], instructions, prog_lang)
                if ctx:
                    tr["story_context"] = ctx
                    async with acquire() as conn:
                        await conn.execute(
                            "UPDATE lessons SET translations = $1 WHERE id = $2",
                            tr, lesson["id"],
                        )
            except Exception:
                pass

    try:
        async with acquire() as conn:
            rows = await conn.fetch(
                """SELECT id, title, type, content_json, language, translations FROM lessons
                   WHERE type IN ('code', 'debug', 'advanced')
                   AND (translations IS NULL OR NOT (translations ? 'story_context'))"""
            )
        await asyncio.gather(*[_process(r) for r in rows])
    except Exception:
        pass


async def _generate_concept_refs_bg():
    """Background: extract prerequisite concepts for each lesson."""
    await asyncio.sleep(330)
    from db.connection import acquire
    from services.claude import generate_concept_refs
    import json as _json

    sem = asyncio.Semaphore(2)

    async def _process(lesson):
        import json as _json2
        raw_tr = lesson["translations"]
        tr = (raw_tr if isinstance(raw_tr, dict) else _json2.loads(raw_tr)) if raw_tr else {}
        if tr.get("concept_refs") is not None:
            return
        raw = lesson["content_json"] or {}
        if lesson["type"] == "theory":
            text = " ".join(s.get("content", "")[:200] for s in raw.get("sections", [])[:3])
        else:
            text = raw.get("instructions", "")[:500]
        if not text.strip():
            return
        prog_lang = lesson["language"] or "general"
        async with sem:
            try:
                refs = await generate_concept_refs(lesson["title"], text, prog_lang)
                tr["concept_refs"] = refs  # store even if empty list
                async with acquire() as conn:
                    await conn.execute(
                        "UPDATE lessons SET translations = $1 WHERE id = $2",
                        tr, lesson["id"],
                    )
            except Exception:
                pass

    try:
        async with acquire() as conn:
            rows = await conn.fetch(
                """SELECT id, title, type, content_json, language, translations FROM lessons
                   WHERE translations IS NULL OR NOT (translations ? 'concept_refs')"""
            )
        await asyncio.gather(*[_process(r) for r in rows])
    except Exception:
        pass


async def _generate_recap_quizzes_bg():
    """Background: generate 3 recap questions for every theory/code lesson."""
    await asyncio.sleep(270)
    from db.connection import acquire
    from services.claude import generate_recap_quiz
    import json as _json

    sem = asyncio.Semaphore(2)

    async def _process(lesson):
        import json as _json2
        raw_tr = lesson["translations"]
        tr = (raw_tr if isinstance(raw_tr, dict) else _json2.loads(raw_tr)) if raw_tr else {}
        if tr.get("recap_quiz") is not None:
            return
        raw = lesson["content_json"] or {}
        prog_lang = lesson["language"] or "general"
        async with sem:
            try:
                questions = await generate_recap_quiz(lesson["title"], lesson["type"], raw, prog_lang)
                if questions:
                    tr["recap_quiz"] = questions
                    async with acquire() as conn:
                        await conn.execute(
                            "UPDATE lessons SET translations = $1 WHERE id = $2",
                            tr, lesson["id"],
                        )
            except Exception:
                pass

    try:
        async with acquire() as conn:
            rows = await conn.fetch(
                """SELECT id, title, type, content_json, language, translations FROM lessons
                   WHERE type IN ('theory', 'code', 'debug', 'advanced')
                   AND (translations IS NULL OR NOT (translations ? 'recap_quiz'))"""
            )
        await asyncio.gather(*[_process(r) for r in rows])
    except Exception:
        pass


async def _generate_debug_contexts_bg():
    """Background: generate realistic error output for debug lessons."""
    await asyncio.sleep(300)
    from db.connection import acquire
    from services.claude import generate_debug_error_context
    import json as _json

    sem = asyncio.Semaphore(2)

    async def _process(lesson):
        import json as _json2
        raw_tr = lesson["translations"]
        tr = (raw_tr if isinstance(raw_tr, dict) else _json2.loads(raw_tr)) if raw_tr else {}
        if tr.get("error_context") is not None:
            return
        raw = lesson["content_json"] or {}
        starter = raw.get("starter_code", "")
        if not starter:
            return
        prog_lang = lesson["language"] or "python"
        async with sem:
            try:
                error_ctx = await generate_debug_error_context(starter, prog_lang)
                if error_ctx:
                    tr["error_context"] = error_ctx
                    async with acquire() as conn:
                        await conn.execute(
                            "UPDATE lessons SET translations = $1 WHERE id = $2",
                            tr, lesson["id"],
                        )
            except Exception:
                pass

    try:
        async with acquire() as conn:
            rows = await conn.fetch(
                """SELECT id, content_json, language, translations FROM lessons
                   WHERE type = 'debug'
                   AND (translations IS NULL OR NOT (translations ? 'error_context'))"""
            )
        await asyncio.gather(*[_process(r) for r in rows])
    except Exception:
        pass


async def _generate_glossary_bg():
    """Background: extract technical terms from theory lessons and generate glossary entries."""
    await asyncio.sleep(180)
    from db.connection import acquire
    from services.claude import extract_theory_terms, generate_glossary_entry
    import json as _json

    sem = asyncio.Semaphore(2)

    async def _process_lesson(lesson):
        import json as _json2
        raw_tr = lesson["translations"]
        tr = (raw_tr if isinstance(raw_tr, dict) else _json2.loads(raw_tr)) if raw_tr else {}
        if tr.get("glossary_terms") is not None:
            return
        raw_content = lesson["content_json"] or {}
        sections = raw_content.get("sections", [])
        if not sections:
            return
        prog_lang = lesson["language"] or "general"
        async with sem:
            try:
                terms = await extract_theory_terms(sections, prog_lang)
                if not terms:
                    tr["glossary_terms"] = []
                else:
                    tr["glossary_terms"] = terms
                    async with acquire() as conn:
                        existing = await conn.fetch(
                            "SELECT term FROM glossary WHERE term = ANY($1)", terms
                        )
                    existing_terms = {r["term"] for r in existing}
                    new_terms = [t for t in terms if t not in existing_terms]
                    for term in new_terms:
                        entry = await generate_glossary_entry(term, prog_lang)
                        if entry.get("explanation_de") or entry.get("explanation_en"):
                            async with acquire() as conn:
                                await conn.execute(
                                    """INSERT INTO glossary (term, explanation_de, explanation_en, example, example_language)
                                       VALUES ($1, $2, $3, $4, $5)
                                       ON CONFLICT (term) DO NOTHING""",
                                    term,
                                    entry.get("explanation_de", ""),
                                    entry.get("explanation_en", ""),
                                    entry.get("example"),
                                    entry.get("example_language"),
                                )
                async with acquire() as conn:
                    await conn.execute(
                        "UPDATE lessons SET translations = $1 WHERE id = $2",
                        tr, lesson["id"],
                    )
            except Exception:
                pass

    try:
        async with acquire() as conn:
            rows = await conn.fetch(
                """SELECT id, content_json, language, translations FROM lessons
                   WHERE type = 'theory'
                   AND (translations IS NULL OR NOT (translations ? 'glossary_terms'))"""
            )
        await asyncio.gather(*[_process_lesson(r) for r in rows])
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
    hints_task = asyncio.create_task(_prewarm_hints())
    testcases_task = asyncio.create_task(_generate_test_cases_bg())
    quiz_exp_task = asyncio.create_task(_generate_quiz_explanations_bg())
    why_task = asyncio.create_task(_generate_why_matters_bg())
    glossary_task = asyncio.create_task(_generate_glossary_bg())
    objectives_task = asyncio.create_task(_generate_learning_objectives_bg())
    story_task = asyncio.create_task(_generate_story_contexts_bg())
    recap_task = asyncio.create_task(_generate_recap_quizzes_bg())
    debug_ctx_task = asyncio.create_task(_generate_debug_contexts_bg())
    concept_refs_task = asyncio.create_task(_generate_concept_refs_bg())
    yield
    task.cancel()
    pregen_task.cancel()
    theory_task.cancel()
    hints_task.cancel()
    testcases_task.cancel()
    quiz_exp_task.cancel()
    why_task.cancel()
    glossary_task.cancel()
    objectives_task.cancel()
    story_task.cancel()
    recap_task.cancel()
    debug_ctx_task.cancel()
    concept_refs_task.cancel()
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
app.include_router(ihk_checklist.router,  prefix="/ihk-checklist",   tags=["ihk-checklist"])


@app.get("/health")
async def health():
    return {"status": "ok", "version": "2.0.0"}
