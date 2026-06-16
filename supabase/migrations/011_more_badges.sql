-- Add 25 new achievement badges
-- Add unique constraint on badge name if not already present
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'badges_name_unique'
  ) THEN
    ALTER TABLE badges ADD CONSTRAINT badges_name_unique UNIQUE (name);
  END IF;
END $$;

INSERT INTO badges (name, description, icon, condition_json) VALUES

  -- Lesson milestones
  ('Rising Coder',        'Complete 5 lessons',           '🌱', '{"type": "lessons_completed", "count": 5}'),
  ('Getting into It',     'Complete 10 lessons',          '🚀', '{"type": "lessons_completed", "count": 10}'),
  ('Lesson Enthusiast',   'Complete 15 lessons total',    '📖', '{"type": "lessons_completed", "count": 15}'),
  ('Quarter Century',     'Complete 25 lessons',          '🎖️', '{"type": "lessons_completed", "count": 25}'),
  ('Halfway Hero',        'Complete 50 lessons',          '🏅', '{"type": "lessons_completed", "count": 50}'),
  ('Century Learner',     'Complete 100 lessons',         '🎓', '{"type": "lessons_completed", "count": 100}'),

  -- XP milestones
  ('XP Spark',            'Earn 250 XP total',            '✨', '{"type": "total_xp", "amount": 250}'),
  ('XP Surge',            'Earn 500 XP total',            '⚡', '{"type": "total_xp", "amount": 500}'),
  ('Knowledge Seeker',    'Reach 750 XP on your journey', '🔭', '{"type": "total_xp", "amount": 750}'),
  ('Four Digits',         'Earn 1,000 XP total',          '💡', '{"type": "total_xp", "amount": 1000}'),
  ('Halfway to XP Glory', 'Earn 1,500 XP total',         '🌠', '{"type": "total_xp", "amount": 1500}'),
  ('XP Veteran',          'Earn 2,500 XP total',          '🌟', '{"type": "total_xp", "amount": 2500}'),
  ('XP Legend',           'Earn 5,000 XP total',          '👑', '{"type": "total_xp", "amount": 5000}'),

  -- Streak milestones
  ('Three-Day Streak',    'Learn 3 days in a row',                   '🔆', '{"type": "streak", "days": 3}'),
  ('Consistent Learner',  'Keep a streak going for 7 days',          '📆', '{"type": "streak", "days": 7}'),
  ('On Fire',             'Maintain a 14-day learning streak',       '🔥', '{"type": "streak", "days": 14}'),
  ('Month of Mastery',    'Maintain a 30-day learning streak',       '📅', '{"type": "streak", "days": 30}'),

  -- Perfect / first-attempt milestones
  ('Nailed It',           'Complete 3 lessons on the first attempt',  '🎯', '{"type": "first_attempt_streak", "count": 3}'),
  ('Sharp Mind',          'Complete 10 lessons on the first attempt', '🧠', '{"type": "first_attempt_streak", "count": 10}'),
  ('Flawless Coder',      'Complete 25 lessons on the first attempt', '💎', '{"type": "first_attempt_streak", "count": 25}'),

  -- Topic completion milestones
  ('Topic Trailblazer',   'Finish all lessons in your first topic',        '🗺️', '{"type": "topic_completed"}'),
  ('Double Down',         'Complete all lessons in 2 different topics',    '📚', '{"type": "topics_completed", "count": 2}'),
  ('Triple Threat',       'Complete all lessons in 3 different topics',    '🔱', '{"type": "topics_completed", "count": 3}'),
  ('Domain Dominator',    'Complete all lessons in 5 different topics',    '🏆', '{"type": "topics_completed", "count": 5}')

ON CONFLICT (name) DO NOTHING;
