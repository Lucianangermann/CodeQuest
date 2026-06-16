-- Add language column to lessons (NULL = language-agnostic, shown to everyone)
ALTER TABLE lessons ADD COLUMN IF NOT EXISTS language VARCHAR(20);

-- Mark all existing code/debug/advanced lessons as Python
UPDATE lessons SET language = 'python' WHERE type IN ('code', 'debug', 'advanced');

-- Theory and quiz stay NULL (language-agnostic, shown to all)
