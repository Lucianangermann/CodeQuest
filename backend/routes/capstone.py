from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from typing import Optional
from db.connection import acquire
from deps import get_current_user, get_optional_user
from services.claude import _get_claude, MODEL

router = APIRouter()


class AskRequest(BaseModel):
    topic: str
    question: str
    language: str


class EvaluateRequest(BaseModel):
    code: str
    language: str


@router.get("/{language}")
async def get_capstone(language: str, user_id: Optional[str] = Depends(get_optional_user)):
    async with acquire() as conn:
        project = await conn.fetchrow(
            "SELECT * FROM capstone_projects WHERE language = $1", language
        )
        if not project:
            raise HTTPException(status_code=404, detail="No capstone project for this language")

        is_unlocked = False
        if user_id:
            # All topics that have at least 1 lesson for this language
            topic_counts = await conn.fetch(
                """SELECT topic_id, COUNT(*) as total FROM lessons
                   WHERE (language IS NULL OR language = $1) GROUP BY topic_id""",
                language,
            )
            topics_with_lessons = {r["topic_id"] for r in topic_counts if r["total"] > 0}

            completed_topics = await conn.fetch(
                """SELECT l.topic_id
                   FROM user_progress up
                   JOIN lessons l ON l.id = up.lesson_id
                   WHERE up.user_id = $1 AND (l.language IS NULL OR l.language = $2)
                   GROUP BY l.topic_id
                   HAVING COUNT(*) = (
                       SELECT COUNT(*) FROM lessons l2
                       WHERE l2.topic_id = l.topic_id
                       AND (l2.language IS NULL OR l2.language = $2)
                   )""",
                user_id, language,
            )
            done_topic_ids = {r["topic_id"] for r in completed_topics}
            is_unlocked = topics_with_lessons.issubset(done_topic_ids) and len(topics_with_lessons) > 0

    return {
        "id": project["id"],
        "language": project["language"],
        "title": project["title"],
        "description": project["description"],
        "starter_code": project["starter_code"],
        "is_unlocked": is_unlocked,
    }


@router.post("/{language}/ask")
async def ask_about_lesson(language: str, body: AskRequest, user_id: str = Depends(get_current_user)):
    prompt = (
        f"The user is working on a capstone coding project and needs help with a specific concept.\n\n"
        f"They are asking about: **{body.topic}** in {body.language}\n"
        f"Their question: {body.question}\n\n"
        f"Explain '{body.topic}' in {body.language} clearly:\n"
        f"1. What is it and when do you use it?\n"
        f"2. A simple, standalone code example in {body.language} (unrelated to any specific project)\n"
        f"3. The key patterns to remember\n\n"
        f"IMPORTANT: Do NOT reference or hint at any specific project task or solution. "
        f"Provide only a clear, educational explanation of the concept itself. "
        f"Keep your answer concise and practical."
    )

    claude = _get_claude()
    if not claude:
        return {"answer": "AI is not configured. Set ANTHROPIC_API_KEY to enable this feature."}
    msg = await claude.messages.create(
        model=MODEL,
        max_tokens=600,
        messages=[{"role": "user", "content": prompt}],
    )
    return {"answer": msg.content[0].text}


@router.post("/{language}/evaluate")
async def evaluate_capstone(language: str, body: EvaluateRequest, user_id: str = Depends(get_current_user)):
    async with acquire() as conn:
        project = await conn.fetchrow(
            "SELECT title, description FROM capstone_projects WHERE language = $1", language
        )
    if not project:
        raise HTTPException(status_code=404, detail="Project not found")

    prompt = (
        f"A student submitted the following {body.language} code for their capstone project.\n\n"
        f"Project: {project['title']}\n"
        f"Requirements:\n{project['description']}\n\n"
        f"Student's code:\n```{body.language}\n{body.code}\n```\n\n"
        f"Evaluate the submission:\n"
        f"1. **Features implemented**: List which requirements are met ✅ and which are missing ❌\n"
        f"2. **Code quality**: Any bugs, bad patterns, or things to improve?\n"
        f"3. **Concepts used well**: Which language concepts are applied effectively?\n"
        f"4. **Verdict**: End with one of: '✅ Complete', '🔧 Mostly done — keep going!', or '🚧 Good start — keep building!'\n\n"
        f"Be encouraging and constructive. Focus on learning, not perfection."
    )

    claude = _get_claude()
    if not claude:
        return {"feedback": "AI is not configured. Set ANTHROPIC_API_KEY to enable this feature."}
    msg = await claude.messages.create(
        model=MODEL,
        max_tokens=800,
        messages=[{"role": "user", "content": prompt}],
    )
    return {"feedback": msg.content[0].text}
