-- Interview Simulator + extended training plan fields
ALTER TABLE public.training_plans
    ADD COLUMN IF NOT EXISTS company_target   TEXT,
    ADD COLUMN IF NOT EXISTS framework_focus  TEXT,
    ADD COLUMN IF NOT EXISTS current_phase    INTEGER NOT NULL DEFAULT 1;

CREATE TABLE IF NOT EXISTS public.interview_sessions (
    id               SERIAL      PRIMARY KEY,
    user_id          UUID        NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    company_size     TEXT        NOT NULL,
    focus            TEXT        NOT NULL,
    questions_json   JSONB       NOT NULL DEFAULT '[]',
    score            INTEGER,
    feedback_json    JSONB,
    completed_at     TIMESTAMPTZ,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_interview_sessions_user ON public.interview_sessions(user_id);
