-- Cache table for AI code reviews (avoids duplicate Claude calls for same code)
CREATE TABLE IF NOT EXISTS public.code_reviews (
    lesson_id   INTEGER     NOT NULL REFERENCES public.lessons(id) ON DELETE CASCADE,
    code_hash   TEXT        NOT NULL,  -- MD5 of stripped code
    review_json JSONB       NOT NULL,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (lesson_id, code_hash)
);
