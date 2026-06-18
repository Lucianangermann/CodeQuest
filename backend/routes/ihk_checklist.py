# Requires ihk_checklist table (see migration 026_umschulung_track.sql)
# Expected schema:
#   CREATE TABLE ihk_checklist (
#       id SERIAL PRIMARY KEY,
#       user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
#       item_key TEXT NOT NULL,
#       completed BOOLEAN NOT NULL DEFAULT FALSE,
#       completed_at TIMESTAMPTZ,
#       UNIQUE (user_id, item_key)
#   );
from fastapi import APIRouter, Depends
from pydantic import BaseModel
from db.connection import acquire
from deps import get_current_user

router = APIRouter()

IHK_CHECKLIST_ITEMS = [
    # Teil 1 (nach 18 Monaten Umschulung)
    {"key": "ihk_t1_project_proposal", "label": "Projektantrag für Teil 1 eingereicht", "category": "teil1"},
    {"key": "ihk_t1_sql", "label": "SQL-Grundlagen beherrscht (SELECT, JOIN, GROUP BY)", "category": "teil1"},
    {"key": "ihk_t1_data_model", "label": "ER-Diagramme lesen und erstellen", "category": "teil1"},
    {"key": "ihk_t1_networks", "label": "Subnetting und OSI-Modell sicher", "category": "teil1"},
    {"key": "ihk_t1_hardware", "label": "Hardware-Kalkulation und Angebotserstellung", "category": "teil1"},
    # WiSo
    {"key": "ihk_wiso_sozialversicherung", "label": "Sozialversicherungssystem (5 Säulen)", "category": "wiso"},
    {"key": "ihk_wiso_arbeitsrecht", "label": "Arbeitsrecht Grundlagen (Kündigung, Probezeit)", "category": "wiso"},
    {"key": "ihk_wiso_tarifvertrag", "label": "Tarifverträge und Mitbestimmung", "category": "wiso"},
    # Teil 2 (Abschlussprüfung)
    {"key": "ihk_t2_project_doc", "label": "Projektdokumentation (15 Seiten) geschrieben", "category": "teil2"},
    {"key": "ihk_t2_presentation", "label": "Präsentation geübt (max. 15 Minuten)", "category": "teil2"},
    {"key": "ihk_t2_fachgesprach", "label": "Fachgespräch vorbereitet (30 Min Fragen)", "category": "teil2"},
    {"key": "ihk_t2_oop", "label": "OOP-Konzepte vertieft (Vererbung, Polymorphismus)", "category": "teil2"},
    {"key": "ihk_t2_testing", "label": "Softwaretests verstanden (Unit, Integration, System)", "category": "teil2"},
    {"key": "ihk_t2_agile", "label": "Scrum/Kanban Grundlagen beherrscht", "category": "teil2"},
    # Projekt
    {"key": "ihk_project_requirement", "label": "Lastenheft/Pflichtenheft erstellt", "category": "projekt"},
    {"key": "ihk_project_implementation", "label": "Anwendung implementiert und dokumentiert", "category": "projekt"},
    {"key": "ihk_project_testing", "label": "Testprotokoll erstellt", "category": "projekt"},
]


class IHKChecklistUpdateRequest(BaseModel):
    item_key: str
    completed: bool


@router.get("/")
async def get_ihk_checklist(user_id: str = Depends(get_current_user)):
    async with acquire() as conn:
        rows = await conn.fetch(
            "SELECT item_key, completed FROM ihk_checklist WHERE user_id = $1", user_id
        )
    saved = {r["item_key"]: r["completed"] for r in rows}
    items = [{**item, "completed": saved.get(item["key"], False)} for item in IHK_CHECKLIST_ITEMS]
    return {"items": items}


@router.patch("/item")
async def update_ihk_checklist_item(body: IHKChecklistUpdateRequest, user_id: str = Depends(get_current_user)):
    async with acquire() as conn:
        if body.completed:
            await conn.execute(
                """INSERT INTO ihk_checklist (user_id, item_key, completed, completed_at)
                   VALUES ($1, $2, TRUE, NOW())
                   ON CONFLICT (user_id, item_key) DO UPDATE SET completed=TRUE, completed_at=NOW()""",
                user_id, body.item_key,
            )
        else:
            await conn.execute(
                """INSERT INTO ihk_checklist (user_id, item_key, completed)
                   VALUES ($1, $2, FALSE)
                   ON CONFLICT (user_id, item_key) DO UPDATE SET completed=FALSE, completed_at=NULL""",
                user_id, body.item_key,
            )
    return {"ok": True}
