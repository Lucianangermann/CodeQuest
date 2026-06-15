-- 009: New topics: Generators, Decorators, Regular Expressions

-- ============================================================
-- TOPICS
-- ============================================================

INSERT INTO public.topics (title, description, order_index, icon) VALUES
('Generators & Iterators', 'Learn how Python generates values lazily with generators and iterators', 12, '⚡'),
('Decorators', 'Master Python decorators to modify and enhance functions', 13, '🎨'),
('Regular Expressions', 'Use regex patterns to search, validate, and extract text', 14, '🔍');

-- ============================================================
-- TOPIC 12: Generators & Iterators — 5 lessons
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json)
SELECT t.id, 'Understanding Generators and Iterators', 'theory', 15, 1,
$json${
  "sections": [
    {
      "type": "text",
      "content": "## Iterators vs Generators\n\nAn **iterator** is an object with `__iter__()` and `__next__()` methods. A **generator** is a simpler way to create an iterator using the `yield` keyword instead of `return`.\n\nGenerators are memory-efficient because they produce values **one at a time**, only when needed."
    },
    {
      "type": "code",
      "language": "python",
      "content": "def count_up(n):\n    for i in range(n):\n        yield i\n\ngen = count_up(3)\nprint(next(gen))  # 0\nprint(next(gen))  # 1\nprint(next(gen))  # 2"
    },
    {
      "type": "text",
      "content": "## Generator Expressions\n\nLike list comprehensions but with `()` instead of `[]`:\n\n```python\n# List: stores all 1000 values in memory\nnums = [x**2 for x in range(1000)]\n\n# Generator: produces values one at a time\nnums = (x**2 for x in range(1000))\n```"
    }
  ],
  "summary": "Generators use `yield` to produce values lazily, saving memory for large sequences."
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Generators & Iterators';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json)
SELECT t.id, 'Generators Quiz', 'quiz', 10, 2,
$json${
  "question": "What does the `yield` keyword do in a Python function?",
  "options": [
    "Returns a value and ends the function",
    "Pauses the function and returns a value, resuming on next() call",
    "Raises a StopIteration exception",
    "Creates a new thread"
  ],
  "correct_index": 1,
  "explanation": "yield pauses the function, saves its state, and returns a value. When next() is called again, execution resumes from where it left off."
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Generators & Iterators';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json)
SELECT t.id, 'Fibonacci Generator', 'code', 20, 3,
$json${
  "instructions": "Write a generator function fibonacci() that yields the first 6 Fibonacci numbers (0, 1, 1, 2, 3, 5).",
  "starter_code": "def fibonacci():\n    # Yield the first 6 Fibonacci numbers\n    pass\n\nfor num in fibonacci():\n    print(num)",
  "expected_output": "0\n1\n1\n2\n3\n5",
  "hints": [
    "Use two variables a, b = 0, 1 and yield a in each step",
    "Update with a, b = b, a+b",
    "Use a counter to stop after 6 iterations"
  ],
  "solution": "def fibonacci():\n    a, b = 0, 1\n    for _ in range(6):\n        yield a\n        a, b = b, a + b\n\nfor num in fibonacci():\n    print(num)"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Generators & Iterators';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json)
SELECT t.id, 'Debug: Fix the Generator', 'debug', 25, 4,
$json${
  "instructions": "Fix the generator so it yields squares of numbers 1 through 5.",
  "starter_code": "def squares(n):\n    for i in range(1, n+1):\n        return i ** 2\n\nfor s in squares(5):\n    print(s)",
  "expected_output": "1\n4\n9\n16\n25",
  "hints": [
    "A generator uses yield, not return",
    "return ends the function; yield pauses and resumes it",
    "Change return to yield"
  ],
  "solution": "def squares(n):\n    for i in range(1, n+1):\n        yield i ** 2\n\nfor s in squares(5):\n    print(s)"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Generators & Iterators';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json)
SELECT t.id, 'Advanced: Infinite Counter', 'advanced', 30, 5,
$json${
  "instructions": "Write a generator count_from(start) that yields integers starting from `start` indefinitely. Use itertools.islice to print the first 5 values starting from 10.",
  "starter_code": "import itertools\n\ndef count_from(start):\n    # Infinite generator\n    pass\n\nresult = list(itertools.islice(count_from(10), 5))\nprint(result)",
  "expected_output": "[10, 11, 12, 13, 14]",
  "hints": [
    "Use a while True loop with yield",
    "Increment the value each iteration",
    "itertools.islice handles stopping for you"
  ],
  "solution": "import itertools\n\ndef count_from(start):\n    while True:\n        yield start\n        start += 1\n\nresult = list(itertools.islice(count_from(10), 5))\nprint(result)"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Generators & Iterators';

-- ============================================================
-- TOPIC 13: Decorators — 5 lessons
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json)
SELECT t.id, 'Understanding Decorators', 'theory', 15, 1,
$json${
  "sections": [
    {
      "type": "text",
      "content": "## What is a Decorator?\n\nA **decorator** is a function that takes another function as input, adds some behavior, and returns a new function.\n\nDecorators use the `@` syntax as a shorthand."
    },
    {
      "type": "code",
      "language": "python",
      "content": "def greet(func):\n    def wrapper():\n        print('Hello!')\n        func()\n        print('Goodbye!')\n    return wrapper\n\n@greet\ndef say_name():\n    print('I am Alice')\n\nsay_name()"
    },
    {
      "type": "text",
      "content": "## Use Cases\n\n- **Logging** — automatically log function calls\n- **Timing** — measure execution time\n- **Authentication** — check if user is logged in\n- **Caching** — remember results of expensive calls"
    }
  ],
  "summary": "Decorators wrap functions to add behavior. The @decorator syntax is shorthand for func = decorator(func)."
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Decorators';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json)
SELECT t.id, 'Decorators Quiz', 'quiz', 10, 2,
$json${
  "question": "What is the equivalent of `@my_decorator` applied to `def foo():`?",
  "options": [
    "foo = my_decorator(foo)",
    "foo.decorate(my_decorator)",
    "my_decorator = foo()",
    "def foo(my_decorator):"
  ],
  "correct_index": 0,
  "explanation": "The @decorator syntax is syntactic sugar for reassigning the function: foo = my_decorator(foo)."
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Decorators';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json)
SELECT t.id, 'Timing Decorator', 'code', 20, 3,
$json${
  "instructions": "Create a decorator `shout` that wraps a function's return value in uppercase. Apply it to greet() which returns 'hello'.",
  "starter_code": "def shout(func):\n    def wrapper(*args, **kwargs):\n        result = func(*args, **kwargs)\n        # Return result in uppercase\n        pass\n    return wrapper\n\n@shout\ndef greet():\n    return 'hello'\n\nprint(greet())",
  "expected_output": "HELLO",
  "hints": [
    "Call func(*args, **kwargs) to get the result",
    "Strings have an .upper() method",
    "Return result.upper() from wrapper"
  ],
  "solution": "def shout(func):\n    def wrapper(*args, **kwargs):\n        result = func(*args, **kwargs)\n        return result.upper()\n    return wrapper\n\n@shout\ndef greet():\n    return 'hello'\n\nprint(greet())"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Decorators';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json)
SELECT t.id, 'Debug: Fix the Decorator', 'debug', 25, 4,
$json${
  "instructions": "Fix the decorator so it prints 'Before' then the function result then 'After'.",
  "starter_code": "def wrap(func):\n    def wrapper():\n        print('Before')\n        print('After')\n    return func\n\n@wrap\ndef say_hi():\n    print('Hi!')\n\nsay_hi()",
  "expected_output": "Before\nHi!\nAfter",
  "hints": [
    "The decorator should return wrapper, not func",
    "Call func() inside wrapper between the prints",
    "wrapper() should call the original function"
  ],
  "solution": "def wrap(func):\n    def wrapper():\n        print('Before')\n        func()\n        print('After')\n    return wrapper\n\n@wrap\ndef say_hi():\n    print('Hi!')\n\nsay_hi()"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Decorators';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json)
SELECT t.id, 'Advanced: Repeat Decorator', 'advanced', 30, 5,
$json${
  "instructions": "Write a decorator factory `repeat(n)` that calls the decorated function n times. Apply @repeat(3) to say_hello() which prints 'Hello'.",
  "starter_code": "def repeat(n):\n    def decorator(func):\n        def wrapper(*args, **kwargs):\n            # Call func n times\n            pass\n        return wrapper\n    return decorator\n\n@repeat(3)\ndef say_hello():\n    print('Hello')\n\nsay_hello()",
  "expected_output": "Hello\nHello\nHello",
  "hints": [
    "Use a for loop: for _ in range(n):",
    "Call func(*args, **kwargs) inside the loop",
    "The outer repeat(n) function returns the decorator"
  ],
  "solution": "def repeat(n):\n    def decorator(func):\n        def wrapper(*args, **kwargs):\n            for _ in range(n):\n                func(*args, **kwargs)\n        return wrapper\n    return decorator\n\n@repeat(3)\ndef say_hello():\n    print('Hello')\n\nsay_hello()"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Decorators';

-- ============================================================
-- TOPIC 14: Regular Expressions — 5 lessons
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json)
SELECT t.id, 'Pattern Matching with Regex', 'theory', 15, 1,
$json${
  "sections": [
    {
      "type": "text",
      "content": "## Regular Expressions\n\nRegex (regular expressions) are patterns for matching text. Python's `re` module provides regex support.\n\n**Key patterns:**\n- `.` — any character\n- `*` — zero or more\n- `+` — one or more\n- `?` — zero or one\n- `\\d` — digit\n- `\\w` — word character (letter, digit, underscore)\n- `\\s` — whitespace\n- `^` — start of string, `$` — end of string"
    },
    {
      "type": "code",
      "language": "python",
      "content": "import re\n\ntext = 'Call us at 123-456-7890 or 987-654-3210'\n\n# Find all phone numbers\npattern = r'\\d{3}-\\d{3}-\\d{4}'\nmatches = re.findall(pattern, text)\nprint(matches)"
    },
    {
      "type": "text",
      "content": "## Common Methods\n\n- `re.match()` — match at start of string\n- `re.search()` — find first match anywhere\n- `re.findall()` — find all matches (returns list)\n- `re.sub()` — replace matches"
    }
  ],
  "summary": "Regex patterns let you search and validate text efficiently. Use r'...' raw strings to avoid escaping backslashes."
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Regular Expressions';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json)
SELECT t.id, 'Regex Quiz', 'quiz', 10, 2,
$json${
  "question": "What does `re.findall(r'\\d+', 'I have 3 cats and 12 dogs')` return?",
  "options": [
    "['3', '12']",
    "['3 cats', '12 dogs']",
    "['3']",
    "3"
  ],
  "correct_index": 0,
  "explanation": "\\d+ matches one or more digits. findall returns all non-overlapping matches as a list of strings."
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Regular Expressions';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json)
SELECT t.id, 'Extract Emails', 'code', 20, 3,
$json${
  "instructions": "Use re.findall to extract all email addresses from the text and print them one per line.",
  "starter_code": "import re\n\ntext = 'Contact alice@example.com or bob@test.org for info'\n\n# Find all email addresses\n",
  "expected_output": "alice@example.com\nbob@test.org",
  "hints": [
    "An email pattern: r'[\\w.]+@[\\w]+\\.[\\w]+'",
    "Use re.findall() to get all matches as a list",
    "Use a for loop or join to print each email"
  ],
  "solution": "import re\n\ntext = 'Contact alice@example.com or bob@test.org for info'\n\nemails = re.findall(r'[\\w.]+@[\\w]+\\.[\\w]+', text)\nfor email in emails:\n    print(email)"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Regular Expressions';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json)
SELECT t.id, 'Debug: Fix the Regex', 'debug', 25, 4,
$json${
  "instructions": "Fix the regex pattern to correctly find all numbers in the text.",
  "starter_code": "import re\n\ntext = 'I scored 95 points and my friend scored 87 points'\n\nscores = re.findall('d+', text)\nprint(scores)",
  "expected_output": "['95', '87']",
  "hints": [
    "Digit patterns use a backslash: \\d",
    "The pattern should be r'\\d+' not 'd+'",
    "Use a raw string r'...' for regex patterns with backslashes"
  ],
  "solution": "import re\n\ntext = 'I scored 95 points and my friend scored 87 points'\n\nscores = re.findall(r'\\d+', text)\nprint(scores)"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Regular Expressions';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json)
SELECT t.id, 'Advanced: Validate and Replace', 'advanced', 30, 5,
$json${
  "instructions": "Use re.sub to replace all dates in format DD/MM/YYYY with YYYY-MM-DD format in the text.",
  "starter_code": "import re\n\ntext = 'Meeting on 25/12/2024 and deadline 01/03/2025'\n\n# Replace DD/MM/YYYY with YYYY-MM-DD\nresult = ???\nprint(result)",
  "expected_output": "Meeting on 2024-12-25 and deadline 2025-03-01",
  "hints": [
    "Pattern: r'(\\d{2})/(\\d{2})/(\\d{4})' captures groups",
    "re.sub with a replacement function or backreferences",
    "Use r'\\3-\\2-\\1' as replacement (group3-group2-group1)"
  ],
  "solution": "import re\n\ntext = 'Meeting on 25/12/2024 and deadline 01/03/2025'\n\nresult = re.sub(r'(\\d{2})/(\\d{2})/(\\d{4})', r'\\3-\\2-\\1', text)\nprint(result)"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Regular Expressions';

-- Allow debug and advanced lesson types
ALTER TABLE lessons DROP CONSTRAINT IF EXISTS lessons_type_check;
ALTER TABLE lessons ADD CONSTRAINT lessons_type_check
    CHECK (type = ANY (ARRAY['theory','quiz','code','debug','advanced']));
