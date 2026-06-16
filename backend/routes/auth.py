from fastapi import APIRouter, HTTPException
from jose import jwt
from passlib.context import CryptContext
from pydantic import BaseModel
from datetime import datetime, timedelta
from typing import Optional
import os
import uuid

from db.connection import acquire

router = APIRouter()
pwd = CryptContext(schemes=["bcrypt"], deprecated="auto")
SECRET = os.getenv("JWT_SECRET", "dev-secret-change-in-production")
ALGO = "HS256"


class SignupRequest(BaseModel):
    username: str
    password: str


class LoginRequest(BaseModel):
    username: str
    password: str


def _make_token(user_id: str) -> str:
    return jwt.encode(
        {"sub": user_id, "exp": datetime.utcnow() + timedelta(days=30)},
        SECRET,
        algorithm=ALGO,
    )


@router.post("/signup")
async def signup(body: SignupRequest):
    async with acquire() as conn:
        existing = await conn.fetchval("SELECT id FROM users WHERE username = $1", body.username)
        if existing:
            raise HTTPException(status_code=400, detail="Username already taken")

        user_id = str(uuid.uuid4())
        hashed = pwd.hash(body.password)
        await conn.execute(
            "INSERT INTO users (id, username, password_hash) VALUES ($1, $2, $3)",
            user_id, body.username, hashed,
        )

    return {
        "token": _make_token(user_id),
        "user": {
            "id": user_id,
            "username": body.username,
            "xp": 0, "level": 1, "streak": 0,
            "language_preference": "python",
            "daily_goal": 3,
            "avatar_url": None,
            "onboarding_completed": False,
        },
    }


@router.post("/login")
async def login(body: LoginRequest):
    async with acquire() as conn:
        row = await conn.fetchrow(
            "SELECT id, username, password_hash, xp, level, streak, "
            "language_preference, daily_goal, avatar_url, onboarding_completed "
            "FROM users WHERE username = $1",
            body.username,
        )

    if not row or not pwd.verify(body.password, row["password_hash"]):
        raise HTTPException(status_code=401, detail="Invalid username or password")

    user = dict(row)
    user["id"] = str(user["id"])
    del user["password_hash"]

    return {"token": _make_token(user["id"]), "user": user}
