import hashlib
import json
from fastapi import APIRouter, Depends, HTTPException
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
        lesson = await conn.fetchrow("SELECT content_json FROM lessons WHERE id = $1", body.lesson_id)
        if not lesson:
            raise HTTPException(status_code=404, detail="Lesson not found")

    hint = await get_hint(lesson["content_json"], body.hint_level, body.user_code)
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
