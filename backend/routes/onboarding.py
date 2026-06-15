from fastapi import APIRouter, Depends
from pydantic import BaseModel
from typing import Optional

from db.connection import acquire
from deps import get_current_user
from services.claude import generate_training_plan

router = APIRouter()


class OnboardingRequest(BaseModel):
    goal: str
    timeline: str
    level: str
    language: str
    company_target: Optional[str] = ""
    framework_focus: Optional[str] = ""


@router.post("/complete")
async def complete_onboarding(body: OnboardingRequest, user_id: str = Depends(get_current_user)):
    plan = await generate_training_plan(
        body.goal, body.timeline, body.level, body.language,
        company_target=body.company_target or "",
        framework_focus=body.framework_focus or "",
    )

    async with acquire() as conn:
        await conn.execute(
            """INSERT INTO training_plans
                 (user_id, goal, timeline, level, language, company_target, framework_focus, plan_json)
               VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
               ON CONFLICT (user_id) DO UPDATE SET
                 goal=$2, timeline=$3, level=$4, language=$5,
                 company_target=$6, framework_focus=$7, plan_json=$8,
                 current_phase=1, updated_at=NOW()""",
            user_id, body.goal, body.timeline, body.level, body.language,
            body.company_target, body.framework_focus, plan,
        )
        await conn.execute(
            "UPDATE users SET onboarding_completed = TRUE, language_preference = $2 WHERE id = $1",
            user_id, body.language,
        )

    return {"plan": plan}
