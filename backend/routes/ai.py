import hashlib
import json
from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from models.schemas import HintRequest, HintResponse, ExplainRequest, ExplainResponse, ChatRequest, ChatResponse, CodeReviewRequest, CodeReviewResponse
from db.connection import acquire
from services.claude import get_hint, explain_mistake, chat_response, review_code
from deps import get_current_user

router = APIRouter()


@router.post("/hint", response_model=HintResponse)
async def get_lesson_hint(body: HintRequest, user_id: str = Depends(get_current_user)):
    if body.hint_level not in (1, 2, 3):
        raise HTTPException(status_code=400, detail="hint_level must be 1, 2, or 3")

    async with acquire() as conn:
        lesson = await conn.fetchrow("SELECT content_json, language FROM lessons WHERE id = $1", body.lesson_id)
        if not lesson:
            raise HTTPException(status_code=404, detail="Lesson not found")

    content = lesson["content_json"] or {}

    # If user provided their current code and it's meaningfully different from starter code,
    # generate a contextual hint instead of the static one
    starter_code = (content.get("starter_code") or "").strip()
    user_code = (body.current_code or "").strip()

    if user_code and user_code != starter_code and len(user_code) > 10:
        from services.claude import get_contextual_hint
        contextual = await get_contextual_hint(
            instructions=content.get("instructions", ""),
            starter_code=starter_code,
            user_code=user_code,
            hint_level=body.hint_level,
            language=lesson.get("language") or "python",
        )
        if contextual:
            return HintResponse(hint=contextual, hint_level=body.hint_level)
    # fall through to static hint if contextual generation failed

    hint = await get_hint(content, body.hint_level, body.user_code)
    return HintResponse(hint=hint, hint_level=body.hint_level)


@router.post("/explain", response_model=ExplainResponse)
async def explain_wrong_answer(body: ExplainRequest, user_id: str = Depends(get_current_user)):
    async with acquire() as conn:
        lesson = await conn.fetchrow("SELECT content_json FROM lessons WHERE id = $1", body.lesson_id)
        if not lesson:
            raise HTTPException(status_code=404, detail="Lesson not found")

    explanation = await explain_mistake(lesson["content_json"], body.user_code, body.error)
    return ExplainResponse(explanation=explanation)


@router.post("/chat", response_model=ChatResponse)
async def ai_chat(body: ChatRequest, user_id: str = Depends(get_current_user)):
    if not body.messages:
        raise HTTPException(status_code=400, detail="messages cannot be empty")

    reply = await chat_response([m.model_dump() for m in body.messages], body.current_topic, body.language)
    return ChatResponse(message=reply)


@router.post("/review", response_model=CodeReviewResponse)
async def review_code_endpoint(body: CodeReviewRequest, user_id: str = Depends(get_current_user)):
    async with acquire() as conn:
        lesson = await conn.fetchrow(
            "SELECT content_json FROM lessons WHERE id = $1 AND type IN ('code','debug','advanced')",
            body.lesson_id,
        )
        if not lesson:
            raise HTTPException(status_code=404, detail="Lesson not found or not a code lesson")

    content = lesson["content_json"]
    task = content.get("instructions", "Complete the coding task")
    expected = content.get("expected_output", "")

    # Check review cache (same lesson + same code → reuse result)
    code_hash = hashlib.md5(body.code.strip().encode()).hexdigest()
    async with acquire() as conn:
        cached = await conn.fetchval(
            "SELECT review_json FROM code_reviews WHERE lesson_id = $1 AND code_hash = $2",
            body.lesson_id, code_hash,
        )
    if cached:
        data = cached if isinstance(cached, dict) else json.loads(cached)
        return CodeReviewResponse(**data)

    result = await review_code(task, expected, body.code, body.language)

    # Store in cache (ignore errors — cache is best-effort)
    try:
        async with acquire() as conn:
            await conn.execute(
                """INSERT INTO code_reviews (lesson_id, code_hash, review_json)
                   VALUES ($1, $2, $3) ON CONFLICT DO NOTHING""",
                body.lesson_id, code_hash, result,
            )
    except Exception:
        pass

    return CodeReviewResponse(**result)


class AltExplanationRequest(BaseModel):
    lesson_id: int
    section_index: int
    section_heading: str
    section_content: str
    prog_language: str = "python"


@router.post("/alt-explanation")
async def get_alt_explanation(
    body: AltExplanationRequest,
    user_id: str = Depends(get_current_user),
):
    """Return a cached alternative explanation for a theory section, generating if needed."""
    from services.claude import generate_alt_explanation

    cache_key = str(body.section_index)

    async with acquire() as conn:
        lesson = await conn.fetchrow(
            "SELECT translations FROM lessons WHERE id = $1", body.lesson_id
        )

    if not lesson:
        raise HTTPException(status_code=404, detail="Lesson not found")

    raw_tr = lesson["translations"]
    tr = (raw_tr if isinstance(raw_tr, dict) else json.loads(raw_tr)) if raw_tr else {}

    alt_cache = tr.get("alt_explanations") or {}
    if cache_key in alt_cache:
        return {"explanation": alt_cache[cache_key], "cached": True}

    # Generate new
    explanation = await generate_alt_explanation(
        body.section_heading, body.section_content, body.prog_language
    )
    if not explanation:
        raise HTTPException(status_code=500, detail="Could not generate explanation")

    alt_cache[cache_key] = explanation
    tr["alt_explanations"] = alt_cache

    async with acquire() as conn:
        await conn.execute(
            "UPDATE lessons SET translations = $1 WHERE id = $2",
            tr, body.lesson_id,
        )

    return {"explanation": explanation, "cached": False}


class ExplainSolutionRequest(BaseModel):
    lesson_id: int
    current_code: str = ""


@router.post("/explain-solution")
async def explain_solution(
    body: ExplainSolutionRequest,
    user_id: str = Depends(get_current_user),
):
    """Return a step-by-step solution walkthrough, cached after first generation."""
    from services.claude import generate_solution_walkthrough

    async with acquire() as conn:
        lesson = await conn.fetchrow(
            "SELECT content_json, language, translations FROM lessons WHERE id = $1",
            body.lesson_id,
        )

    if not lesson:
        raise HTTPException(status_code=404, detail="Lesson not found")

    raw_tr = lesson["translations"]
    tr = (raw_tr if isinstance(raw_tr, dict) else json.loads(raw_tr)) if raw_tr else {}

    # Return cached walkthrough if available
    if tr.get("solution_walkthrough"):
        return {"walkthrough": tr["solution_walkthrough"], "cached": True}

    content = lesson["content_json"] or {}
    solution = content.get("solution", "")
    if not solution:
        raise HTTPException(status_code=400, detail="No solution available for this lesson")

    walkthrough = await generate_solution_walkthrough(
        instructions=content.get("instructions", ""),
        starter_code=content.get("starter_code", ""),
        solution=solution,
        language=lesson["language"] or "python",
    )
    if not walkthrough:
        raise HTTPException(status_code=500, detail="Could not generate walkthrough")

    tr["solution_walkthrough"] = walkthrough
    async with acquire() as conn:
        await conn.execute(
            "UPDATE lessons SET translations = $1 WHERE id = $2",
            tr, body.lesson_id,
        )

    return {"walkthrough": walkthrough, "cached": False}
