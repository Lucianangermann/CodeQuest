-- Seed topics
INSERT INTO public.topics (title, description, order_index, icon) VALUES
('Variables', 'Learn how to store and manage data in variables', 1, '📦'),
('Data Types', 'Explore numbers, strings, booleans, and more', 2, '🔤'),
('Conditionals', 'Make decisions in your code with if/else', 3, '🔀'),
('Loops', 'Repeat actions with for and while loops', 4, '🔄'),
('Functions', 'Organize code into reusable blocks', 5, '⚡'),
('Arrays & Lists', 'Store multiple values in ordered collections', 6, '📋'),
('Objects & Dicts', 'Store data as key-value pairs', 7, '🗂️'),
('Object-Oriented Programming', 'Model the world with classes and objects', 8, '🏗️'),
('Error Handling', 'Write robust code that handles mistakes gracefully', 9, '🛡️'),
('APIs', 'Connect your code to external services', 10, '🌐'),
('Algorithms & Data Structures', 'Master efficient problem-solving techniques', 11, '🧮');

-- Seed 3 complete lessons for "Variables" topic (id=1)
INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  1,
  'Introduction to Variables',
  'theory',
  $json${
    "sections": [
      {
        "type": "text",
        "content": "## What is a Variable?\n\nA **variable** is like a labeled box where you store information. You give it a name, and inside it you store a value that you can use and change later.\n\nIn Python, creating a variable is simple — just write the name, an equals sign, and the value:"
      },
      {
        "type": "code",
        "language": "python",
        "content": "# Creating variables\nname = \"Alice\"\nage = 25\nheight = 5.6\nis_student = True\n\n# Using variables\nprint(name)       # Alice\nprint(age)        # 25\nprint(is_student) # True"
      },
      {
        "type": "text",
        "content": "## Variable Naming Rules\n\nVariables must follow these rules:\n- **Start** with a letter or underscore `_`\n- Contain only letters, numbers, and underscores\n- Be **case-sensitive** (`name` ≠ `Name`)\n- Cannot be Python keywords (`if`, `for`, `while`)\n\nBest practice: use `snake_case` for readability."
      },
      {
        "type": "code",
        "language": "python",
        "content": "# Good variable names\nfirst_name = \"Bob\"\nuser_age = 30\ntotal_score = 100\n\n# You can update variables\nuser_age = 31  # Happy birthday!\nprint(user_age)  # 31\n\n# Multiple assignment\nx, y, z = 1, 2, 3\nprint(x, y, z)  # 1 2 3"
      },
      {
        "type": "text",
        "content": "## Key Takeaways\n\n✅ Variables are named containers for storing data\n✅ Use `=` to assign values (not `==`)\n✅ You can update a variable any time\n✅ Use descriptive names to make code readable"
      }
    ],
    "summary": "Variables are named containers for storing data. Use = to assign values and choose descriptive snake_case names."
  }$json$,
  10,
  1
),
(
  1,
  'Quiz: Variable Basics',
  'quiz',
  $json${
    "question": "Which of the following is the CORRECT way to create a variable called `score` with the value 100 in Python?",
    "options": [
      "score = 100",
      "var score = 100",
      "score == 100",
      "int score = 100"
    ],
    "correct_index": 0,
    "explanation": "In Python, you create variables with simple assignment: name = value. No keywords like 'var' or type declarations like 'int' are needed! The == operator is for comparison, not assignment."
  }$json$,
  10,
  2
),
(
  1,
  'Code Challenge: Your First Variable',
  'code',
  $json${
    "instructions": "Create a variable called `greeting` and assign the string 'Hello, CodeQuest!' to it. Then print the variable using the `print()` function.\n\nExpected output:\n```\nHello, CodeQuest!\n```",
    "starter_code": "# Create your greeting variable below\n\n\n# Then print it\n",
    "expected_output": "Hello, CodeQuest!\n",
    "test_cases": [
      {
        "description": "Should print exactly: Hello, CodeQuest!",
        "expected_pattern": "Hello, CodeQuest!"
      }
    ],
    "hints": [
      "Variables store values using the = sign. Think: variable_name = value",
      "Strings (text) must be wrapped in quotes. Try: greeting = 'Hello, CodeQuest!'",
      "You need two lines: first assign the variable, then print it:\ngreeting = 'Hello, CodeQuest!'\nprint(greeting)"
    ],
    "solution": "greeting = 'Hello, CodeQuest!'\nprint(greeting)"
  }$json$,
  10,
  3
);

-- Seed badges
INSERT INTO public.badges (name, description, icon, condition_json) VALUES
('First Step', 'Complete your very first lesson', '🎯', '{"type": "lessons_completed", "count": 1}'),
('Week Warrior', 'Maintain a 7-day learning streak', '🔥', '{"type": "streak", "days": 7}'),
('Topic Master', 'Complete all lessons in a topic', '🏆', '{"type": "topic_completed", "count": 1}'),
('Speed Coder', 'Complete a code lesson in under 2 minutes', '⚡', '{"type": "lesson_time_seconds", "threshold": 120}'),
('Bug Hunter', 'Find the error in a broken code challenge', '🐛', '{"type": "bug_found", "count": 1}'),
('Century Club', 'Earn 100 XP total', '💎', '{"type": "total_xp", "amount": 100}'),
('Curious Mind', 'Use the AI tutor 5 times', '🤖', '{"type": "ai_used", "count": 5}'),
('Perfect Start', 'Complete 5 lessons on the first attempt', '⭐', '{"type": "first_attempt_streak", "count": 5}');
