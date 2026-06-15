from pydantic import BaseModel
from typing import Optional, List, Any


class SubmitAnswerRequest(BaseModel):
    answer: str
    language: str = "python"


class SubmitAnswerResponse(BaseModel):
    correct: bool
    feedback: str
    xp_earned: int
    output: Optional[str] = None
    error: Optional[str] = None


class HintRequest(BaseModel):
    lesson_id: int
    hint_level: int  # 1, 2, or 3
    user_code: str


class HintResponse(BaseModel):
    hint: str
    hint_level: int


class ExplainRequest(BaseModel):
    lesson_id: int
    user_code: str
    error: str


class ExplainResponse(BaseModel):
    explanation: str


class ChatMessage(BaseModel):
    role: str  # "user" or "assistant"
    content: str


class ChatRequest(BaseModel):
    messages: List[ChatMessage]
    current_topic: str = ""
    language: str = "python"


class ChatResponse(BaseModel):
    message: str


class TopicWithProgress(BaseModel):
    id: int
    title: str
    description: Optional[str] = None
    order_index: int
    icon: Optional[str] = None
    total_lessons: int
    completed_lessons: int
    is_locked: bool
    is_completed: bool


class LessonWithProgress(BaseModel):
    id: int
    topic_id: int
    title: str
    type: str
    content_json: Any
    xp_reward: int
    order_index: int
    is_completed: bool
    xp_earned: int


class DashboardStats(BaseModel):
    username: str
    avatar_url: Optional[str] = None
    xp: int
    level: int
    streak: int
    daily_goal: int
    lessons_today: int
    xp_today: int
    total_lessons_completed: int
    lessons_this_week: int = 0
    current_topic: Optional[dict] = None
    recent_badges: List[dict]
    activity_data: List[dict]


class LeaderboardEntry(BaseModel):
    rank: int
    user_id: str
    username: str
    avatar_url: Optional[str] = None
    weekly_xp: int
    is_current_user: bool


class StreakUpdateResponse(BaseModel):
    streak: int
    is_new_day: bool
    badges_earned: List[dict]
