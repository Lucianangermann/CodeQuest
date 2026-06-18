-- Migration 027: Global glossary table for technical term explanations

CREATE TABLE IF NOT EXISTS public.glossary (
    term              TEXT        NOT NULL,
    explanation_de    TEXT        NOT NULL DEFAULT '',
    explanation_en    TEXT        NOT NULL DEFAULT '',
    example           TEXT,                              -- optional code snippet
    example_language  TEXT,                              -- e.g. 'javascript', 'python'
    created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (term)
);
