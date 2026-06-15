-- My Learning Path feature: personalized training plans, weekly check-ins, job-ready checklist
ALTER TABLE public.users ADD COLUMN IF NOT EXISTS onboarding_completed BOOLEAN NOT NULL DEFAULT FALSE;

CREATE TABLE IF NOT EXISTS public.training_plans (
    id          SERIAL      PRIMARY KEY,
    user_id     UUID        NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    goal        TEXT        NOT NULL,
    timeline    TEXT        NOT NULL,
    level       TEXT        NOT NULL,
    language    TEXT        NOT NULL,
    plan_json   JSONB       NOT NULL,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(user_id)
);

CREATE TABLE IF NOT EXISTS public.weekly_checkins (
    id                SERIAL   PRIMARY KEY,
    user_id           UUID     NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    week_number       INTEGER  NOT NULL,
    year              INTEGER  NOT NULL,
    tasks_completed   INTEGER  NOT NULL DEFAULT 0,
    tasks_total       INTEGER  NOT NULL DEFAULT 0,
    notes             TEXT,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(user_id, week_number, year)
);

CREATE TABLE IF NOT EXISTS public.job_ready_checklist (
    id           SERIAL      PRIMARY KEY,
    user_id      UUID        NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    item_key     TEXT        NOT NULL,
    completed    BOOLEAN     NOT NULL DEFAULT FALSE,
    completed_at TIMESTAMPTZ,
    UNIQUE(user_id, item_key)
);

CREATE INDEX IF NOT EXISTS idx_training_plans_user_id    ON public.training_plans(user_id);
CREATE INDEX IF NOT EXISTS idx_weekly_checkins_user_id   ON public.weekly_checkins(user_id);
CREATE INDEX IF NOT EXISTS idx_job_ready_checklist_user  ON public.job_ready_checklist(user_id);
