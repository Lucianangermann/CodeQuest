-- 006: Track lesson attempts, first_attempt success, and add Topic 1 lessons

-- 1. Track raw attempt count per lesson (to detect first-attempt success)
CREATE TABLE IF NOT EXISTS lesson_attempts (
    user_id   UUID    NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    lesson_id INTEGER NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
    attempts  INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY (user_id, lesson_id)
);

-- 2. Record whether a lesson was solved on the very first attempt
ALTER TABLE user_progress ADD COLUMN IF NOT EXISTS first_attempt BOOLEAN NOT NULL DEFAULT FALSE;

-- 3. Topic 1 (Variables) already has quiz + code in seed — no action needed.
