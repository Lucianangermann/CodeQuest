from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from typing import Optional
from db.connection import acquire
from deps import get_current_user

router = APIRouter()


class ProjectCreate(BaseModel):
    title: str
    description: Optional[str] = None
    github_url: Optional[str] = None
    live_url: Optional[str] = None
    tech_stack: Optional[list[str]] = None
    phase_number: Optional[int] = None


class ProjectUpdate(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    github_url: Optional[str] = None
    live_url: Optional[str] = None
    tech_stack: Optional[list[str]] = None


@router.get("/")
async def get_projects(user_id: str = Depends(get_current_user)):
    async with acquire() as conn:
        rows = await conn.fetch(
            "SELECT * FROM portfolio_projects WHERE user_id=$1 ORDER BY phase_number, created_at",
            user_id,
        )
    return {"projects": [dict(r) for r in rows]}


@router.post("/")
async def create_project(body: ProjectCreate, user_id: str = Depends(get_current_user)):
    async with acquire() as conn:
        row = await conn.fetchrow(
            """INSERT INTO portfolio_projects (user_id, title, description, github_url, live_url, tech_stack, phase_number)
               VALUES ($1,$2,$3,$4,$5,$6,$7) RETURNING *""",
            user_id, body.title, body.description, body.github_url,
            body.live_url, body.tech_stack or [], body.phase_number,
        )
    return dict(row)


@router.patch("/{project_id}")
async def update_project(project_id: int, body: ProjectUpdate, user_id: str = Depends(get_current_user)):
    allowed = {k: v for k, v in body.model_dump().items() if v is not None}
    if not allowed:
        raise HTTPException(400, "Nothing to update")
    set_clause = ", ".join(f"{k}=${i+2}" for i, k in enumerate(allowed))
    async with acquire() as conn:
        row = await conn.fetchrow(
            f"UPDATE portfolio_projects SET {set_clause} WHERE id=$1 AND user_id=${len(allowed)+2} RETURNING *",
            project_id, *allowed.values(), user_id,
        )
    if not row:
        raise HTTPException(404, "Not found")
    return dict(row)


@router.delete("/{project_id}")
async def delete_project(project_id: int, user_id: str = Depends(get_current_user)):
    async with acquire() as conn:
        await conn.execute(
            "DELETE FROM portfolio_projects WHERE id=$1 AND user_id=$2",
            project_id, user_id,
        )
    return {"ok": True}
