from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from typing import List, Optional

from db.connection import acquire
from deps import get_current_user
from services.claude import interview_message, interview_summary

router = APIRouter()


class ChatMessage(BaseModel):
    role: str
    content: str


class InterviewMessageRequest(BaseModel):
    session_id: int
    messages: List[ChatMessage]
    question_number: int
    company_size: str
    focus: str


class InterviewCompleteRequest(BaseModel):
    session_id: int
    messages: List[ChatMessage]
    qa_pairs: list
    company_size: str
    focus: str


class InterviewStartRequest(BaseModel):
    company_size: str
    focus: str


@router.post("/start")
async def start_interview(body: InterviewStartRequest, user_id: str = Depends(get_current_user)):
    async with acquire() as conn:
        row = await conn.fetchrow(
            "INSERT INTO interview_sessions (user_id, company_size, focus) VALUES ($1, $2, $3) RETURNING id",
            user_id, body.company_size, body.focus,
        )
    session_id = row["id"]

    first = await interview_message(
        messages=[],
        company_size=body.company_size,
        focus=body.focus,
        question_number=1,
    )

    return {"session_id": session_id, **first}


@router.post("/message")
async def send_message(body: InterviewMessageRequest, user_id: str = Depends(get_current_user)):
    async with acquire() as conn:
        row = await conn.fetchrow(
            "SELECT id FROM interview_sessions WHERE id = $1 AND user_id = $2 AND completed_at IS NULL",
            body.session_id, user_id,
        )
    if not row:
        raise HTTPException(status_code=404, detail="Session not found")

    result = await interview_message(
        messages=[m.model_dump() for m in body.messages],
        company_size=body.company_size,
        focus=body.focus,
        question_number=body.question_number,
    )
    return result


@router.post("/complete")
async def complete_interview(body: InterviewCompleteRequest, user_id: str = Depends(get_current_user)):
    async with acquire() as conn:
        row = await conn.fetchrow(
            "SELECT id FROM interview_sessions WHERE id = $1 AND user_id = $2",
            body.session_id, user_id,
        )
    if not row:
        raise HTTPException(status_code=404, detail="Session not found")

    summary = await interview_summary(
        messages=[m.model_dump() for m in body.messages],
        company_size=body.company_size,
        focus=body.focus,
    )

    async with acquire() as conn:
        await conn.execute(
            """UPDATE interview_sessions SET
               questions_json = $2, score = $3, feedback_json = $4, completed_at = NOW()
               WHERE id = $1""",
            body.session_id,
            body.qa_pairs,
            summary.get("score"),
            summary,
        )

    return summary


@router.get("/history")
async def get_interview_history(user_id: str = Depends(get_current_user)):
    async with acquire() as conn:
        rows = await conn.fetch(
            """SELECT id, company_size, focus, score, feedback_json, completed_at, created_at
               FROM interview_sessions WHERE user_id = $1
               ORDER BY created_at DESC LIMIT 20""",
            user_id,
        )

    return {
        "sessions": [
            {
                "id": r["id"],
                "company_size": r["company_size"],
                "focus": r["focus"],
                "score": r["score"],
                "feedback": dict(r["feedback_json"]) if r["feedback_json"] else None,
                "completed": r["completed_at"] is not None,
                "completed_at": r["completed_at"].isoformat() if r["completed_at"] else None,
                "created_at": r["created_at"].isoformat(),
            }
            for r in rows
        ]
    }


@router.get("/session/{session_id}")
async def get_session_detail(session_id: int, user_id: str = Depends(get_current_user)):
    async with acquire() as conn:
        row = await conn.fetchrow(
            """SELECT id, company_size, focus, score, feedback_json, questions_json,
                      completed_at, created_at
               FROM interview_sessions WHERE id = $1 AND user_id = $2""",
            session_id, user_id,
        )
    if not row:
        raise HTTPException(status_code=404, detail="Session not found")
    return {
        "id": row["id"],
        "company_size": row["company_size"],
        "focus": row["focus"],
        "score": row["score"],
        "feedback": dict(row["feedback_json"]) if row["feedback_json"] else None,
        "qa_pairs": list(row["questions_json"]) if row["questions_json"] else [],
        "completed_at": row["completed_at"].isoformat() if row["completed_at"] else None,
        "created_at": row["created_at"].isoformat(),
    }
