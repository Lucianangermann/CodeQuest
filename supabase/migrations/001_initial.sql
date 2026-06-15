-- Standalone PostgreSQL schema — no Supabase auth dependency
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE IF NOT EXISTS public.users (
    id                  UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    email               TEXT        UNIQUE NOT NULL,
    username            TEXT        NOT NULL,
    password_hash       TEXT        NOT NULL,
    avatar_url          TEXT,
    xp                  INTEGER     NOT NULL DEFAULT 0,
    level               INTEGER     NOT NULL DEFAULT 1,
    streak              INTEGER     NOT NULL DEFAULT 0,
    last_active         DATE,
    language_preference TEXT        NOT NULL DEFAULT 'python',
    daily_goal              INTEGER     NOT NULL DEFAULT 3,
    onboarding_completed    BOOLEAN     NOT NULL DEFAULT FALSE,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.topics (
    id          SERIAL  PRIMARY KEY,
    title       TEXT    NOT NULL,
    description TEXT,
    order_index INTEGER NOT NULL,
    icon        TEXT
);

CREATE TABLE IF NOT EXISTS public.lessons (
    id           SERIAL  PRIMARY KEY,
    topic_id     INTEGER NOT NULL REFERENCES public.topics(id) ON DELETE CASCADE,
    title        TEXT    NOT NULL,
    type         TEXT    NOT NULL CHECK (type IN ('theory', 'quiz', 'code')),
    content_json JSONB   NOT NULL DEFAULT '{}',
    xp_reward    INTEGER NOT NULL DEFAULT 10,
    order_index  INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS public.user_progress (
    id           SERIAL      PRIMARY KEY,
    user_id      UUID        NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    lesson_id    INTEGER     NOT NULL REFERENCES public.lessons(id) ON DELETE CASCADE,
    completed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    xp_earned    INTEGER     NOT NULL DEFAULT 0,
    attempts     INTEGER     NOT NULL DEFAULT 1,
    UNIQUE(user_id, lesson_id)
);

CREATE TABLE IF NOT EXISTS public.badges (
    id             SERIAL PRIMARY KEY,
    name           TEXT   NOT NULL,
    description    TEXT,
    icon           TEXT,
    condition_json JSONB  DEFAULT '{}'
);

CREATE TABLE IF NOT EXISTS public.user_badges (
    id        SERIAL      PRIMARY KEY,
    user_id   UUID        NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    badge_id  INTEGER     NOT NULL REFERENCES public.badges(id) ON DELETE CASCADE,
    earned_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(user_id, badge_id)
);

CREATE TABLE IF NOT EXISTS public.activity_log (
    id                SERIAL   PRIMARY KEY,
    user_id           UUID     NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    date              DATE     NOT NULL DEFAULT CURRENT_DATE,
    lessons_completed INTEGER  NOT NULL DEFAULT 0,
    xp_earned         INTEGER  NOT NULL DEFAULT 0,
    UNIQUE(user_id, date)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_user_progress_user_id   ON public.user_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_user_progress_lesson_id ON public.user_progress(lesson_id);
CREATE INDEX IF NOT EXISTS idx_activity_log_user_date  ON public.activity_log(user_id, date);
CREATE INDEX IF NOT EXISTS idx_lessons_topic_id        ON public.lessons(topic_id);

-- Atomic activity log upsert (avoids read-modify-write races)
CREATE OR REPLACE FUNCTION public.log_lesson_activity(p_user_id UUID, p_xp_earned INTEGER)
RETURNS void AS $$
BEGIN
    INSERT INTO public.activity_log (user_id, date, lessons_completed, xp_earned)
    VALUES (p_user_id, CURRENT_DATE, 1, p_xp_earned)
    ON CONFLICT (user_id, date) DO UPDATE SET
        lessons_completed = activity_log.lessons_completed + 1,
        xp_earned         = activity_log.xp_earned + p_xp_earned;
END;
$$ LANGUAGE plpgsql;
