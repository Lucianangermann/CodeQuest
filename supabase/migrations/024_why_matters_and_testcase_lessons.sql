-- 024: Prepend "Why This Matters" to all 17 theory lessons
--      + Add multi-test-case code lessons for 5 key topics

-- ============================================================
-- PART 1: Prepend "Why This Matters" section to theory lessons
-- ============================================================
-- Strategy: use jsonb_set + || to PREPEND a new section object
-- to the existing sections array without overwriting anything.

-- TOPIC 1: Variables
UPDATE lessons
SET content_json = jsonb_set(
    content_json,
    '{sections}',
    (
        $why$[{"type":"text","content":"## 🎯 Why This Matters\n\nVariables are the foundation of every program ever written. Without them, you couldn't store user input, remember results between steps, or configure your app's behavior. Every framework, database, and API you'll ever use relies on variables internally — understanding them deeply makes you a better debugger and architect."}]$why$::jsonb
        || (content_json -> 'sections')
    )
)
WHERE topic_id = (SELECT id FROM topics WHERE title = 'Variables')
  AND type = 'theory'
  AND language IS NULL;

-- TOPIC 2: Data Types
UPDATE lessons
SET content_json = jsonb_set(
    content_json,
    '{sections}',
    (
        $why$[{"type":"text","content":"## 🎯 Why This Matters\n\nChoosing the wrong type causes real bugs: storing a price as a string makes arithmetic fail; storing a user ID as a float risks precision loss on large integers. TypeScript's type system catches these errors before they reach production — thousands of companies use it specifically for this. A solid understanding of types is what separates junior developers from mid-level ones."}]$why$::jsonb
        || (content_json -> 'sections')
    )
)
WHERE topic_id = (SELECT id FROM topics WHERE title = 'Data Types')
  AND type = 'theory'
  AND language IS NULL;

-- TOPIC 3: Conditionals
UPDATE lessons
SET content_json = jsonb_set(
    content_json,
    '{sections}',
    (
        $why$[{"type":"text","content":"## 🎯 Why This Matters\n\nConditionals are the decision-making engine of every program. A payment system decides whether to charge or decline. A game engine decides which physics rules apply. An authentication system decides whether to grant access. Every business rule in software is ultimately an if/else — mastering them cleanly prevents entire categories of bugs."}]$why$::jsonb
        || (content_json -> 'sections')
    )
)
WHERE topic_id = (SELECT id FROM topics WHERE title = 'Conditionals')
  AND type = 'theory'
  AND language IS NULL;

-- TOPIC 4: Loops
UPDATE lessons
SET content_json = jsonb_set(
    content_json,
    '{sections}',
    (
        $why$[{"type":"text","content":"## 🎯 Why This Matters\n\nLoops process real-world scale: iterating over a million database rows, rendering 60 frames per second, processing every file in a directory. The difference between an O(n) and O(n²) loop can mean the difference between a 1-second and a 10-minute runtime. Array methods like .map() and .filter() are how modern JavaScript and data science code is written professionally."}]$why$::jsonb
        || (content_json -> 'sections')
    )
)
WHERE topic_id = (SELECT id FROM topics WHERE title = 'Loops')
  AND type = 'theory'
  AND language IS NULL;

-- TOPIC 5: Functions
UPDATE lessons
SET content_json = jsonb_set(
    content_json,
    '{sections}',
    (
        $why$[{"type":"text","content":"## 🎯 Why This Matters\n\nFunctions are the primary tool for code reuse and maintainability. Every major software project is built on thousands of functions working together. The ability to write clean, well-named functions is what makes your code readable by others (and by your future self 6 months later). Higher-order functions — functions that take other functions as arguments — are the backbone of React hooks, event listeners, and functional programming."}]$why$::jsonb
        || (content_json -> 'sections')
    )
)
WHERE topic_id = (SELECT id FROM topics WHERE title = 'Functions')
  AND type = 'theory'
  AND language IS NULL;

-- TOPIC 6: Arrays & Lists
UPDATE lessons
SET content_json = jsonb_set(
    content_json,
    '{sections}',
    (
        $why$[{"type":"text","content":"## 🎯 Why This Matters\n\nLists are everywhere: shopping carts, search results, timelines, playlists, database query results. Sorting, filtering, and transforming lists efficiently is one of the most common tasks in software development. Python list comprehensions and JavaScript's .map()/.filter()/.reduce() chain are what you'll write every single day as a developer."}]$why$::jsonb
        || (content_json -> 'sections')
    )
)
WHERE topic_id = (SELECT id FROM topics WHERE title = 'Arrays & Lists')
  AND type = 'theory'
  AND language IS NULL;

-- TOPIC 7: Objects & Dicts
UPDATE lessons
SET content_json = jsonb_set(
    content_json,
    '{sections}',
    (
        $why$[{"type":"text","content":"## 🎯 Why This Matters\n\nObjects and dicts are how structured data is represented in virtually every modern application. API responses, database records, user sessions, configuration files — all are key-value data. JSON (JavaScript Object Notation) is named after JS objects because the format is so ubiquitous. Mastering dicts means you can work with any API or dataset."}]$why$::jsonb
        || (content_json -> 'sections')
    )
)
WHERE topic_id = (SELECT id FROM topics WHERE title = 'Objects & Dicts')
  AND type = 'theory'
  AND language IS NULL;

-- TOPIC 8: Object-Oriented Programming
UPDATE lessons
SET content_json = jsonb_set(
    content_json,
    '{sections}',
    (
        $why$[{"type":"text","content":"## 🎯 Why This Matters\n\nOOP is the dominant paradigm in enterprise software, game development, and UI frameworks. React components are objects. Django models are classes. Unity GameObjects use inheritance and interfaces. Even when you don't write classes yourself, you'll constantly work with libraries and frameworks built on OOP principles — understanding them makes documentation and Stack Overflow answers click."}]$why$::jsonb
        || (content_json -> 'sections')
    )
)
WHERE topic_id = (SELECT id FROM topics WHERE title = 'Object-Oriented Programming')
  AND type = 'theory'
  AND language IS NULL;

-- TOPIC 9: Error Handling
UPDATE lessons
SET content_json = jsonb_set(
    content_json,
    '{sections}',
    (
        $why$[{"type":"text","content":"## 🎯 Why This Matters\n\nUnhandled exceptions crash production apps and expose security vulnerabilities. A server that doesn't catch errors returns a 500 status to every user. Proper error handling is the difference between a hobby project and production-ready software. In job interviews, senior engineers are explicitly judged on how they handle edge cases and failure modes."}]$why$::jsonb
        || (content_json -> 'sections')
    )
)
WHERE topic_id = (SELECT id FROM topics WHERE title = 'Error Handling')
  AND type = 'theory'
  AND language IS NULL;

-- TOPIC 10: APIs
UPDATE lessons
SET content_json = jsonb_set(
    content_json,
    '{sections}',
    (
        $why$[{"type":"text","content":"## 🎯 Why This Matters\n\nREST APIs are the language of the internet. Every modern app — Spotify, Uber, Instagram — is built on dozens of APIs communicating with each other. As a developer, you'll consume and build APIs daily. Understanding HTTP, status codes, and JSON parsing is not optional — it's the water you swim in as a backend or frontend developer."}]$why$::jsonb
        || (content_json -> 'sections')
    )
)
WHERE topic_id = (SELECT id FROM topics WHERE title = 'APIs')
  AND type = 'theory'
  AND language IS NULL;

-- TOPIC 11: Algorithms & Data Structures
UPDATE lessons
SET content_json = jsonb_set(
    content_json,
    '{sections}',
    (
        $why$[{"type":"text","content":"## 🎯 Why This Matters\n\nThe gap between a program that handles 100 users and 1 million users is almost always an algorithm choice. Google's search, Spotify's recommendation system, and GPS routing all depend on efficient algorithms. Big-O notation is how engineers communicate performance, and it's the most common topic in technical interviews at top companies."}]$why$::jsonb
        || (content_json -> 'sections')
    )
)
WHERE topic_id = (SELECT id FROM topics WHERE title = 'Algorithms & Data Structures')
  AND type = 'theory'
  AND language IS NULL;

-- TOPIC 12: Generators & Iterators
UPDATE lessons
SET content_json = jsonb_set(
    content_json,
    '{sections}',
    (
        $why$[{"type":"text","content":"## 🎯 Why This Matters\n\nMemory efficiency separates scripts that work on small datasets from production pipelines that process terabytes. Python generators power libraries like pandas, SQLAlchemy, and every streaming data pipeline. When you read a 10 GB log file without running out of RAM, you're using lazy evaluation — the principle generators embody."}]$why$::jsonb
        || (content_json -> 'sections')
    )
)
WHERE topic_id = (SELECT id FROM topics WHERE title = 'Generators & Iterators')
  AND type = 'theory'
  AND language IS NULL;

-- TOPIC 13: Decorators
UPDATE lessons
SET content_json = jsonb_set(
    content_json,
    '{sections}',
    (
        $why$[{"type":"text","content":"## 🎯 Why This Matters\n\nDecorators are Python's answer to cross-cutting concerns — functionality that spans multiple parts of your app. In Flask and FastAPI, @app.route() is a decorator. In Django, @login_required protects views. In pytest, @pytest.mark.parametrize runs tests with multiple inputs. You'll encounter and use decorators constantly in real Python codebases."}]$why$::jsonb
        || (content_json -> 'sections')
    )
)
WHERE topic_id = (SELECT id FROM topics WHERE title = 'Decorators')
  AND type = 'theory'
  AND language IS NULL;

-- TOPIC 14: Regular Expressions
UPDATE lessons
SET content_json = jsonb_set(
    content_json,
    '{sections}',
    (
        $why$[{"type":"text","content":"## 🎯 Why This Matters\n\nRegex powers form validation, log parsing, search-and-replace in editors, and data extraction pipelines. Every major programming language, database, and command-line tool supports regex. When a senior developer gets a task like 'extract all phone numbers from this dataset' or 'validate email format', their first tool is regex."}]$why$::jsonb
        || (content_json -> 'sections')
    )
)
WHERE topic_id = (SELECT id FROM topics WHERE title = 'Regular Expressions')
  AND type = 'theory'
  AND language IS NULL;

-- TOPIC 15: Closures & Scope
UPDATE lessons
SET content_json = jsonb_set(
    content_json,
    '{sections}',
    (
        $why$[{"type":"text","content":"## 🎯 Why This Matters\n\nClosures are the mechanism behind React Hooks, event listeners, and JavaScript module patterns. When you write useState() in React or addEventListener() in JavaScript, you're relying on closures to capture state. Understanding scope bugs is essential for debugging the most confusing JavaScript errors — where a variable is undefined or has an unexpected value."}]$why$::jsonb
        || (content_json -> 'sections')
    )
)
WHERE topic_id = (SELECT id FROM topics WHERE title = 'Closures & Scope')
  AND type = 'theory'
  AND language IS NULL;

-- TOPIC 16: Async/Await & Promises
UPDATE lessons
SET content_json = jsonb_set(
    content_json,
    '{sections}',
    (
        $why$[{"type":"text","content":"## 🎯 Why This Matters\n\nAlmost every real-world app is async: fetching from databases, calling external APIs, reading files — all take time and shouldn't block the UI. React, Node.js, and Python's FastAPI are all built around async execution. Without understanding async, you'll write code that freezes UIs, times out servers, or has race conditions that only appear in production."}]$why$::jsonb
        || (content_json -> 'sections')
    )
)
WHERE topic_id = (SELECT id FROM topics WHERE title = 'Async/Await & Promises')
  AND type = 'theory'
  AND language IS NULL;

-- TOPIC 17: Modules & Imports
UPDATE lessons
SET content_json = jsonb_set(
    content_json,
    '{sections}',
    (
        $why$[{"type":"text","content":"## 🎯 Why This Matters\n\nModules are how you organize a codebase beyond 100 lines. Every npm package, pip library, and framework you'll ever use is a module. Python's standard library (json, os, datetime, collections) saves you from reinventing the wheel constantly. Understanding how module systems work prevents import errors, circular dependencies, and namespace conflicts."}]$why$::jsonb
        || (content_json -> 'sections')
    )
)
WHERE topic_id = (SELECT id FROM topics WHERE title = 'Modules & Imports')
  AND type = 'theory'
  AND language IS NULL;


-- ============================================================
-- PART 2: Multi-test-case code lessons
-- ============================================================

-- Functions — Python (order 20): Square of Input
INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id,
       'Python: Square of Input (3 Test Cases)',
       'code',
       25,
       20,
       'python',
       $json${
  "instructions": "Read an integer from stdin and print its square.",
  "starter_code": "n = int(input())\n# Your code here",
  "expected_output": "",
  "test_cases": [
    {"description": "Square of 5", "input": "5\n", "expected_output": "25\n"},
    {"description": "Square of 0", "input": "0\n", "expected_output": "0\n"},
    {"description": "Square of negative", "input": "-4\n", "expected_output": "16\n"}
  ],
  "hints": [
    "Use int(input()) to read a number",
    "n**2 computes the square",
    "print() adds a newline automatically"
  ],
  "solution": "n = int(input())\nprint(n ** 2)"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Functions';

-- Functions — JavaScript (order 21): Cube Root
INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id,
       'JS: Cube Root (3 Test Cases)',
       'code',
       25,
       21,
       'javascript',
       $json${
  "instructions": "Read a number from stdin and print its cube (n to the power of 3).",
  "starter_code": "const n = parseInt(require('fs').readFileSync('/dev/stdin','utf8').trim());\n// Your code here",
  "expected_output": "",
  "test_cases": [
    {"description": "Cube of 3", "input": "3\n", "expected_output": "27\n"},
    {"description": "Cube of 0", "input": "0\n", "expected_output": "0\n"},
    {"description": "Cube of 4", "input": "4\n", "expected_output": "64\n"}
  ],
  "hints": [
    "Use parseInt(require('fs').readFileSync('/dev/stdin','utf8').trim()) to read stdin",
    "n**3 computes the cube",
    "console.log() adds a newline automatically"
  ],
  "solution": "const n = parseInt(require('fs').readFileSync('/dev/stdin','utf8').trim());\nconsole.log(n**3);"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Functions';

-- Loops — Python (order 20): FizzBuzz to N
INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id,
       'Python: FizzBuzz to N (3 Test Cases)',
       'code',
       25,
       20,
       'python',
       $json${
  "instructions": "Read an integer N from stdin. Print FizzBuzz from 1 to N inclusive.\n\nRules:\n- Print \"FizzBuzz\" if the number is divisible by both 3 and 5\n- Print \"Fizz\" if divisible by 3 only\n- Print \"Buzz\" if divisible by 5 only\n- Otherwise print the number itself",
  "starter_code": "n = int(input())\n# Print FizzBuzz from 1 to n",
  "expected_output": "",
  "test_cases": [
    {"description": "FizzBuzz up to 5", "input": "5\n", "expected_output": "1\n2\nFizz\n4\nBuzz\n"},
    {"description": "FizzBuzz up to 3", "input": "3\n", "expected_output": "1\n2\nFizz\n"},
    {"description": "FizzBuzz up to 15", "input": "15\n", "expected_output": "1\n2\nFizz\n4\nBuzz\nFizz\n7\n8\nFizz\nBuzz\n11\nFizz\n13\n14\nFizzBuzz\n"}
  ],
  "hints": [
    "Use range(1, n+1) to iterate from 1 to n inclusive",
    "Check divisibility by 15 first (both 3 and 5), then 3, then 5",
    "Use % (modulo) to check divisibility: i % 3 == 0"
  ],
  "solution": "n = int(input())\nfor i in range(1, n+1):\n    if i % 15 == 0:\n        print(\"FizzBuzz\")\n    elif i % 3 == 0:\n        print(\"Fizz\")\n    elif i % 5 == 0:\n        print(\"Buzz\")\n    else:\n        print(i)"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Loops';

-- Algorithms & Data Structures — Python (order 20): Count Unique Values
INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id,
       'Python: Count Unique Values (3 Test Cases)',
       'code',
       25,
       20,
       'python',
       $json${
  "instructions": "Read a space-separated line of integers from stdin. Print the count of unique values.",
  "starter_code": "nums = list(map(int, input().split()))\n# Count unique values",
  "expected_output": "",
  "test_cases": [
    {"description": "Mixed list with duplicates", "input": "1 2 3 2 1\n", "expected_output": "3\n"},
    {"description": "Single element", "input": "5\n", "expected_output": "1\n"},
    {"description": "All duplicates", "input": "7 7 7 7\n", "expected_output": "1\n"}
  ],
  "hints": [
    "Use input().split() to get a list of strings",
    "Use map(int, ...) to convert them to integers",
    "A set() automatically removes duplicates — len(set(nums)) gives the unique count"
  ],
  "solution": "nums = list(map(int, input().split()))\nprint(len(set(nums)))"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Algorithms & Data Structures';

-- Arrays & Lists — JavaScript (order 20): Sum of Array
INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id,
       'JS: Sum of Array (3 Test Cases)',
       'code',
       25,
       20,
       'javascript',
       $json${
  "instructions": "Read a comma-separated line of numbers from stdin. Print their sum.",
  "starter_code": "const line = require('fs').readFileSync('/dev/stdin','utf8').trim();\n// Parse and sum the numbers",
  "expected_output": "",
  "test_cases": [
    {"description": "Sum of 1 to 5", "input": "1,2,3,4,5\n", "expected_output": "15\n"},
    {"description": "Sum of multiples of 10", "input": "10,20,30\n", "expected_output": "60\n"},
    {"description": "Single number", "input": "7\n", "expected_output": "7\n"}
  ],
  "hints": [
    "Use .split(',') to split the input into an array of strings",
    "Use .map(Number) to convert strings to numbers",
    "Use .reduce((a, b) => a + b, 0) to sum all values"
  ],
  "solution": "const line = require('fs').readFileSync('/dev/stdin','utf8').trim();\nconst nums = line.split(',').map(Number);\nconsole.log(nums.reduce((a,b)=>a+b,0));"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Arrays & Lists';

-- Error Handling — Python (order 20): Safe Integer Parse
INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id,
       'Python: Safe Integer Parse (3 Test Cases)',
       'code',
       25,
       20,
       'python',
       $json${
  "instructions": "Read a string from stdin. Try to convert it to an integer. If successful, print the integer. If conversion fails, print \"invalid\".",
  "starter_code": "s = input()\n# Try to parse as int",
  "expected_output": "",
  "test_cases": [
    {"description": "Valid integer", "input": "42\n", "expected_output": "42\n"},
    {"description": "Non-numeric string", "input": "hello\n", "expected_output": "invalid\n"},
    {"description": "Negative integer", "input": "-7\n", "expected_output": "-7\n"}
  ],
  "hints": [
    "Use a try/except block to handle potential errors",
    "int(s) raises a ValueError if the string is not a valid integer",
    "Catch ValueError specifically: except ValueError:"
  ],
  "solution": "s = input()\ntry:\n    print(int(s))\nexcept ValueError:\n    print(\"invalid\")"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Error Handling';
