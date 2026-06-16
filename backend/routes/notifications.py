from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from db.connection import acquire
from deps import get_current_user
import os

router = APIRouter()

VAPID_PUBLIC_KEY = os.getenv("VAPID_PUBLIC_KEY", "")


class PushSubscriptionBody(BaseModel):
    endpoint: str
    p256dh: str
    auth: str


@router.get("/vapid-public-key")
async def get_vapid_key():
    return {"public_key": VAPID_PUBLIC_KEY}


@router.post("/subscribe")
async def subscribe(body: PushSubscriptionBody, user_id: str = Depends(get_current_user)):
    async with acquire() as conn:
        await conn.execute(
            """INSERT INTO push_subscriptions (user_id, endpoint, p256dh, auth)
               VALUES ($1, $2, $3, $4)
               ON CONFLICT (user_id, endpoint) DO UPDATE
               SET p256dh = EXCLUDED.p256dh, auth = EXCLUDED.auth""",
            user_id, body.endpoint, body.p256dh, body.auth,
        )
    return {"status": "subscribed"}


@router.delete("/unsubscribe")
async def unsubscribe(body: PushSubscriptionBody, user_id: str = Depends(get_current_user)):
    async with acquire() as conn:
        await conn.execute(
            "DELETE FROM push_subscriptions WHERE user_id = $1 AND endpoint = $2",
            user_id, body.endpoint,
        )
    return {"status": "unsubscribed"}
