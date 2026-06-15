from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv
import os

load_dotenv()

from db.connection import init_pool, close_pool
from routes import auth, topics, lessons, ai, user, leaderboard, onboarding, training_plan, checklist, weekly_checkin, interview, review, portfolio


@asynccontextmanager
async def lifespan(app: FastAPI):
    await init_pool()
    yield
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


@app.get("/health")
async def health():
    return {"status": "ok", "version": "2.0.0"}
