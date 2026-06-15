from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel

from db.connection import acquire
from deps import get_current_user
from services.claude import generate_training_plan

router = APIRouter()


class AdjustRequest(BaseModel):
    notes: str


class AdvancePhaseRequest(BaseModel):
    phase: int


@router.get("/")
async def get_training_plan(user_id: str = Depends(get_current_user)):
    async with acquire() as conn:
        row = await conn.fetchrow(
            "SELECT goal, timeline, level, language, company_target, framework_focus, "
            "current_phase, plan_json, created_at, updated_at "
            "FROM training_plans WHERE user_id = $1",
            user_id,
        )

    if not row:
        return {"plan": None}

    return {
        "plan": dict(row["plan_json"]),
        "meta": {
            "goal": row["goal"],
            "timeline": row["timeline"],
            "level": row["level"],
            "language": row["language"],
            "company_target": row["company_target"],
            "framework_focus": row["framework_focus"],
            "current_phase": row["current_phase"],
            "created_at": row["created_at"].isoformat(),
            "updated_at": row["updated_at"].isoformat(),
        },
    }


@router.post("/adjust")
async def adjust_training_plan(body: AdjustRequest, user_id: str = Depends(get_current_user)):
    async with acquire() as conn:
        row = await conn.fetchrow(
            "SELECT goal, timeline, level, language, company_target, framework_focus "
            "FROM training_plans WHERE user_id = $1",
            user_id,
        )

    if not row:
        raise HTTPException(status_code=404, detail="No training plan found")

    plan = await generate_training_plan(
        row["goal"], row["timeline"], row["level"], row["language"],
        company_target=row["company_target"] or "",
        framework_focus=row["framework_focus"] or "",
        progress_notes=body.notes,
    )

    async with acquire() as conn:
        await conn.execute(
            "UPDATE training_plans SET plan_json = $2, updated_at = NOW() WHERE user_id = $1",
            user_id, plan,
        )

    return {"plan": plan}


@router.post("/advance-phase")
async def advance_phase(body: AdvancePhaseRequest, user_id: str = Depends(get_current_user)):
    async with acquire() as conn:
        await conn.execute(
            "UPDATE training_plans SET current_phase = $2 WHERE user_id = $1",
            user_id, body.phase,
        )
    return {"current_phase": body.phase}
