from fastapi import APIRouter, Depends
from pydantic import BaseModel

from db.connection import acquire
from deps import get_current_user
from services.claude import generate_test_question

router = APIRouter()

CHECKLIST_ITEMS = [
    # JavaScript Fundamentals
    {"key": "js_closures",        "label": "Erkläre Closures mit einem Beispiel",                  "category": "javascript"},
    {"key": "js_eq",              "label": "== vs === — was ist der Unterschied?",                 "category": "javascript"},
    {"key": "js_async",           "label": "Wie funktioniert async/await unter der Haube?",        "category": "javascript"},
    {"key": "js_reduce",          "label": "Schreibe Array reduce() selbst nach",                  "category": "javascript"},
    {"key": "js_null_undef",      "label": "null vs undefined — Unterschied erklären",             "category": "javascript"},
    {"key": "js_event_bubbling",  "label": "Erkläre Event Bubbling",                               "category": "javascript"},
    {"key": "js_promises",        "label": "Was sind Promises und warum brauchen wir sie?",        "category": "javascript"},
    {"key": "js_debounce",        "label": "Schreibe eine debounce Funktion",                      "category": "javascript"},
    # React
    {"key": "react_lifecycle",    "label": "Erkläre den React Component Lifecycle",                "category": "react"},
    {"key": "react_hooks",        "label": "useCallback vs useMemo — wann welches?",               "category": "react"},
    {"key": "react_prop_drill",   "label": "Was ist Prop Drilling und wie vermeidest du es?",      "category": "react"},
    {"key": "react_custom_hook",  "label": "Baue einen Custom Hook von Grund auf",                 "category": "react"},
    {"key": "react_keys",         "label": "Warum sind Keys in Listen wichtig?",                   "category": "react"},
    {"key": "react_state_mutate", "label": "Was passiert wenn du State direkt mutierst?",          "category": "react"},
    {"key": "react_controlled",   "label": "Controlled vs Uncontrolled Components",                "category": "react"},
    # Backend & APIs
    {"key": "api_http_flow",      "label": "Erkläre den kompletten Flow eines HTTP Requests",      "category": "backend"},
    {"key": "api_401_403",        "label": "Unterschied zwischen 401 und 403?",                    "category": "backend"},
    {"key": "api_sql_join",       "label": "Schreibe einen SQL JOIN Query",                        "category": "backend"},
    {"key": "api_jwt",            "label": "Erkläre wie JWT Authentication funktioniert",          "category": "backend"},
    {"key": "api_cors",           "label": "Was ist CORS und warum existiert es?",                 "category": "backend"},
    # Computer Science
    {"key": "cs_bigo",            "label": "Erkläre Big-O Notation mit Beispielen",                "category": "cs"},
    {"key": "cs_stack_heap",      "label": "Unterschied zwischen Stack und Heap?",                 "category": "cs"},
    {"key": "cs_two_sum",         "label": "Löse 'Two Sum' ohne Hilfe",                            "category": "cs"},
    {"key": "cs_recursion",       "label": "Erkläre Rekursion und zeige ein Beispiel",             "category": "cs"},
    # Soft Skills & Projects
    {"key": "soft_project_pitch", "label": "Erkläre dein Hauptprojekt in 2 Minuten",              "category": "soft"},
    {"key": "soft_hard_bug",      "label": "Beschreibe den schwierigsten Bug den du je gefixt hast","category": "soft"},
    {"key": "soft_tech_decision", "label": "Warum hast du bestimmte technische Entscheidungen getroffen?","category": "soft"},
    {"key": "soft_refactor",      "label": "Was würdest du an deinem Projekt anders machen?",     "category": "soft"},
]


class ChecklistUpdateRequest(BaseModel):
    item_key: str
    completed: bool


@router.get("/")
async def get_checklist(user_id: str = Depends(get_current_user)):
    async with acquire() as conn:
        rows = await conn.fetch(
            "SELECT item_key, completed FROM job_ready_checklist WHERE user_id = $1",
            user_id,
        )

    saved = {r["item_key"]: r["completed"] for r in rows}

    items = [{**item, "completed": saved.get(item["key"], False)} for item in CHECKLIST_ITEMS]
    return {"items": items}


@router.patch("/item")
async def update_checklist_item(body: ChecklistUpdateRequest, user_id: str = Depends(get_current_user)):
    async with acquire() as conn:
        if body.completed:
            await conn.execute(
                """INSERT INTO job_ready_checklist (user_id, item_key, completed, completed_at)
                   VALUES ($1, $2, TRUE, NOW())
                   ON CONFLICT (user_id, item_key) DO UPDATE SET completed=TRUE, completed_at=NOW()""",
                user_id, body.item_key,
            )
        else:
            await conn.execute(
                """INSERT INTO job_ready_checklist (user_id, item_key, completed)
                   VALUES ($1, $2, FALSE)
                   ON CONFLICT (user_id, item_key) DO UPDATE SET completed=FALSE, completed_at=NULL""",
                user_id, body.item_key,
            )
    return {"ok": True}


@router.get("/test-question/{item_key}")
async def get_test_question(item_key: str, user_id: str = Depends(get_current_user)):
    label = next((i["label"] for i in CHECKLIST_ITEMS if i["key"] == item_key), item_key)
    return await generate_test_question(item_key, label)
