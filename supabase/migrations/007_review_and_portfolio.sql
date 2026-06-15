-- 007: Spaced repetition review schedule + portfolio project tracker

-- Spaced repetition: tracks when each completed lesson should be reviewed again
CREATE TABLE IF NOT EXISTS review_schedule (
    user_id       UUID    NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    lesson_id     INTEGER NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
    next_review   DATE    NOT NULL DEFAULT CURRENT_DATE + INTERVAL '1 day',
    interval_days INTEGER NOT NULL DEFAULT 1,
    ease_factor   NUMERIC(4,2) NOT NULL DEFAULT 2.5,
    last_reviewed DATE,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (user_id, lesson_id)
);

CREATE INDEX IF NOT EXISTS idx_review_schedule_due
    ON review_schedule(user_id, next_review);

-- Portfolio project tracker: one row per project per user
CREATE TABLE IF NOT EXISTS portfolio_projects (
    id           SERIAL PRIMARY KEY,
    user_id      UUID    NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title        TEXT    NOT NULL,
    description  TEXT,
    github_url   TEXT,
    live_url     TEXT,
    tech_stack   TEXT[]  NOT NULL DEFAULT '{}',
    phase_number INTEGER,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_portfolio_user
    ON portfolio_projects(user_id);
