-- 019_expand_theory_1_7.sql
-- Replaces minimal theory lesson content for topics 1–7 with rich, detailed
-- educational content. These are the language-agnostic theory lessons
-- (language IS NULL, type = 'theory').

-- ============================================================
-- TOPIC 1: Variables
-- ============================================================

UPDATE lessons
SET content_json = $json${
  "sections": [
    {
      "type": "text",
      "content": "# Variables — Named Containers for Data\n\nImagine you are writing a program that needs to remember a user's name, their age, and their score in a game. Without some way to *store* that information, your program would forget it the moment it was created.\n\nA **variable** is the solution. It is a named location in your computer's memory where you can keep a value. Think of it like a labeled box: you write a name on the outside of the box, and you put a value inside. Whenever you need that value again, you just look for the box with the right label.\n\nThe name you give to a variable is called an **identifier**. The value inside can be a number, a piece of text, a list — almost anything."
    },
    {
      "type": "code",
      "language": "python",
      "content": "# Python: creating (declaring) variables\nname = \"Alice\"\nage = 25\nscore = 98.5\nis_logged_in = True\n\n# Using the variables\nprint(name)         # Alice\nprint(age)          # 25\nprint(score)        # 98.5\nprint(is_logged_in) # True"
    },
    {
      "type": "code",
      "language": "javascript",
      "content": "// JavaScript: declaring variables with let and const\nlet name = \"Alice\";\nconst AGE = 25;        // const: cannot be reassigned\nlet score = 98.5;\nlet isLoggedIn = true;\n\nconsole.log(name);        // Alice\nconsole.log(AGE);         // 25\nconsole.log(score);       // 98.5\nconsole.log(isLoggedIn);  // true"
    },
    {
      "type": "text",
      "content": "## Why Use Variables?\n\nVariables give you three major benefits:\n\n1. **Reuse** — write a value once, use it in many places. If the value ever changes, you only update it in one spot.\n2. **Readability** — `total_price` is far clearer than a raw number like `47.99` scattered through your code.\n3. **Flexibility** — programs can calculate new values at runtime (e.g., user input) and store them for later use.\n\nWithout variables you would have to hard-code every value directly — which makes code hard to maintain and nearly impossible to adapt."
    },
    {
      "type": "text",
      "content": "## Naming Rules and Conventions\n\nEvery language has rules you **must** follow and conventions you **should** follow.\n\n### Rules (mandatory)\n- Names must start with a letter (`a–z`, `A–Z`) or an underscore `_`.\n- After the first character, you can also use digits (`0–9`).\n- Names are **case-sensitive**: `score`, `Score`, and `SCORE` are three different variables.\n- You cannot use reserved keywords as variable names (`if`, `for`, `while`, `return`, etc.).\n\n### Conventions (strongly recommended)\n| Language | Style | Example |\n|---|---|---|\n| Python | `snake_case` | `user_score` |\n| JavaScript / TypeScript | `camelCase` | `userScore` |\n| Constants (JS) | `UPPER_SNAKE_CASE` | `MAX_RETRIES` |\n\nGood names tell the reader *what* is stored, not *how* it is stored. `num` is vague; `player_health` is clear."
    },
    {
      "type": "code",
      "language": "python",
      "content": "# Good Python variable names (snake_case)\nfirst_name = \"Bob\"\ntotal_score = 0\nmax_attempts = 3\nis_game_over = False\n\n# Bad names (still valid Python, but confusing)\nx = \"Bob\"       # What is x?\nn = 3            # n for what?\nTotalScore = 0   # PascalCase — reserved for class names in Python\n\n# INVALID names (syntax errors)\n# 1st_player = \"Alice\"   # starts with a digit\n# for = 5                # 'for' is a keyword\n# my-score = 100         # hyphens are not allowed"
    },
    {
      "type": "code",
      "language": "javascript",
      "content": "// Good JavaScript variable names (camelCase)\nlet firstName = \"Bob\";\nlet totalScore = 0;\nconst MAX_ATTEMPTS = 3;   // constant — upper snake case by convention\nlet isGameOver = false;\n\n// TypeScript adds optional type annotations\nlet playerName: string = \"Alice\";\nlet level: number = 1;\nlet isActive: boolean = true;\n\nconsole.log(playerName, level, isActive); // Alice 1 true"
    },
    {
      "type": "text",
      "content": "## Mutability: Can You Change a Variable?\n\nIn Python, every variable can be reassigned at any time — there is no concept of a compile-time constant. You just write a new assignment:\n\n```python\nage = 25\nage = 26   # perfectly fine\n```\n\nIn JavaScript and TypeScript there are **two keywords** that behave differently:\n\n- `let` — declares a variable that **can** be reassigned later.\n- `const` — declares a variable that **cannot** be reassigned (it is constant). Trying to reassign a `const` throws a `TypeError` at runtime.\n\n> **Rule of thumb**: default to `const` in JS/TS. Only use `let` when you know you will reassign the variable. Never use the old `var` keyword in modern code — it has confusing scoping rules.\n\nUsing `const` wherever possible makes your code safer and signals to readers that the value will not change."
    },
    {
      "type": "code",
      "language": "python",
      "content": "# Python: reassignment is always allowed\nscore = 10\nprint(score)  # 10\n\nscore = score + 5   # update the value\nprint(score)  # 15\n\nscore += 10   # shorthand for score = score + 10\nprint(score)  # 25\n\n# You can even change the type of a variable (not recommended)\nscore = \"twenty-five\"  # now score holds a string — legal but confusing"
    },
    {
      "type": "code",
      "language": "javascript",
      "content": "// JavaScript: let vs const\nlet score = 10;\nscore = score + 5;  // OK — let allows reassignment\nscore += 10;        // shorthand\nconsole.log(score); // 25\n\nconst MAX_SCORE = 100;\n// MAX_SCORE = 200; // TypeError: Assignment to constant variable.\n\n// TypeScript catches type mismatches at compile time:\nlet playerName: string = \"Alice\";\n// playerName = 42; // Error: Type 'number' is not assignable to type 'string'"
    },
    {
      "type": "text",
      "content": "## Common Mistakes to Avoid\n\n**1. Using a variable before defining it**\n```python\nprint(score)   # NameError: name 'score' is not defined\nscore = 10\n```\nAlways define a variable before you use it.\n\n**2. Typos in variable names**\n```python\nfirst_name = \"Alice\"\nprint(frist_name)  # NameError — you misspelled it\n```\nModern code editors with auto-complete help catch these immediately.\n\n**3. Shadowing a variable** — accidentally reusing a name in a nested scope:\n```python\ntotal = 100\nfor total in range(5):  # 'total' is now the loop variable!\n    pass\nprint(total)  # 4 — not 100! The loop variable shadowed the outer one.\n```\nChoose unique, descriptive names to avoid this.\n\n**4. Confusing `=` (assignment) with `==` (comparison)**\n```python\nif score = 10:   # SyntaxError — this is assignment\nif score == 10:  # Correct — this is a comparison\n```"
    }
  ],
  "summary": "- A variable is a named storage location in memory that holds a value you can use and change later.\n- Use descriptive names: snake_case in Python, camelCase in JavaScript/TypeScript.\n- Python variables can always be reassigned; in JS/TS prefer `const` and only use `let` when reassignment is needed.\n- Always define a variable before using it, or you will get a NameError (Python) or ReferenceError (JS).\n- The assignment operator `=` stores a value; the comparison operator `==` checks equality — they are not the same."
}$json$::jsonb
WHERE topic_id = (SELECT id FROM topics WHERE title = 'Variables')
  AND type = 'theory'
  AND language IS NULL;

-- ============================================================
-- TOPIC 2: Data Types
-- ============================================================

UPDATE lessons
SET content_json = $json${
  "sections": [
    {
      "type": "text",
      "content": "# Data Types — What Kind of Value Is This?\n\nEvery piece of data in a program has a **type**. The type tells the computer (and other programmers) what kind of value it is and what operations make sense on it.\n\nFor example:\n- It makes sense to divide two numbers: `10 / 2` → `5`\n- It does *not* make sense to divide two words: `\"hello\" / \"world\"` → error\n- But you *can* add (concatenate) two strings: `\"hello\" + \" world\"` → `\"hello world\"`\n\nUnderstanding types prevents a whole category of bugs where you accidentally mix incompatible values."
    },
    {
      "type": "text",
      "content": "## The Core Primitive Types\n\nMost languages share the same fundamental types:\n\n| Type | Python | JavaScript | Example values |\n|---|---|---|---|\n| Integer | `int` | `number` | `0`, `42`, `-7` |\n| Floating point | `float` | `number` | `3.14`, `-0.5`, `1.0` |\n| Text | `str` | `string` | `\"hello\"`, `'world'` |\n| Boolean | `bool` | `boolean` | `True` / `False` (Py), `true` / `false` (JS) |\n| Nothing / null | `None` | `null`, `undefined` | `None`, `null`, `undefined` |\n\n> Note: JavaScript uses a single `number` type for both integers and floating-point values. Python has separate `int` and `float` types."
    },
    {
      "type": "code",
      "language": "python",
      "content": "# Python primitive types\nan_integer = 42\na_float   = 3.14\na_string  = \"Hello, Python!\"\na_boolean = True\nnothing   = None\n\n# Check the type of any value with type()\nprint(type(an_integer))  # <class 'int'>\nprint(type(a_float))     # <class 'float'>\nprint(type(a_string))    # <class 'str'>\nprint(type(a_boolean))   # <class 'bool'>\nprint(type(nothing))     # <class 'NoneType'>"
    },
    {
      "type": "code",
      "language": "javascript",
      "content": "// JavaScript types — check with typeof\nconst anInteger = 42;\nconst aFloat    = 3.14;\nconst aString   = \"Hello, JavaScript!\";\nconst aBoolean  = true;\nconst nothing   = null;\nlet   notSet;           // undefined\n\nconsole.log(typeof anInteger); // \"number\"\nconsole.log(typeof aFloat);    // \"number\"  (same type in JS!)\nconsole.log(typeof aString);   // \"string\"\nconsole.log(typeof aBoolean);  // \"boolean\"\nconsole.log(typeof nothing);   // \"object\"  (historical quirk in JS)\nconsole.log(typeof notSet);    // \"undefined\""
    },
    {
      "type": "text",
      "content": "## Type Conversion (Casting)\n\nSometimes you receive a value in one type but need it in another. For example, data from user input or a web API often arrives as a **string**, even if it represents a number.\n\nYou can explicitly convert between types — this is called **type conversion** or **casting**."
    },
    {
      "type": "code",
      "language": "python",
      "content": "# Python: explicit type conversion\nage_as_string = \"25\"           # came from user input\nage_as_int    = int(age_as_string)\nprint(age_as_int + 1)          # 26  — now we can do math\n\nprice = 9\nprint(float(price))            # 9.0\n\ncount = 42\nprint(str(count))              # \"42\"  — now it's a string\nprint(\"Count: \" + str(count))  # \"Count: 42\"\n\n# bool() follows truthiness rules\nprint(bool(0))      # False\nprint(bool(1))      # True\nprint(bool(\"\"))     # False\nprint(bool(\"hi\"))   # True\n\n# Conversion failures raise ValueError\n# int(\"hello\")  # ValueError: invalid literal for int()"
    },
    {
      "type": "code",
      "language": "javascript",
      "content": "// JavaScript: type conversion\nconst ageAsString = \"25\";          // from user input\nconst ageAsNumber = Number(ageAsString);\nconsole.log(ageAsNumber + 1);      // 26\n\nconsole.log(String(42));           // \"42\"\nconsole.log(Boolean(0));           // false\nconsole.log(Boolean(\"hello\"));     // true\n\n// parseInt / parseFloat for numeric strings with text\nconsole.log(parseInt(\"42px\"));     // 42  (stops at non-digit)\nconsole.log(parseFloat(\"3.14em\")); // 3.14\n\n// Failed conversion returns NaN (Not a Number)\nconsole.log(Number(\"hello\"));  // NaN\nconsole.log(isNaN(NaN));       // true"
    },
    {
      "type": "text",
      "content": "## Implicit Type Coercion (JavaScript Gotcha)\n\nUnlike Python, JavaScript will *automatically* convert types in certain operations — this is called **implicit coercion**. It can lead to surprising results:\n\n```javascript\n\"5\" + 3       // \"53\"  (3 was coerced to a string — + means concatenation here)\n\"5\" - 3       // 2    (- always means subtraction, so \"5\" was coerced to number)\n\"5\" * \"3\"     // 15   (both coerced to numbers)\ntrue + true   // 2    (booleans coerced to 0 or 1)\n```\n\nTo avoid this confusion, always **convert explicitly** before operations, and never rely on coercion."
    },
    {
      "type": "text",
      "content": "## Loose vs Strict Equality in JavaScript\n\nJavaScript has two equality operators:\n\n- `==` — **loose equality**: compares values *after* type coercion\n- `===` — **strict equality**: compares values *and* types — no coercion\n\n```javascript\n5 == \"5\"    // true  (\"5\" is coerced to number 5)\n5 === \"5\"   // false (different types)\nnull == undefined  // true\nnull === undefined // false\n```\n\n**Rule**: always use `===` in JavaScript. Using `==` is a common source of bugs.\n\nPython's `==` behaves like JS's `===` — no hidden coercion."
    },
    {
      "type": "text",
      "content": "## Duck Typing in Python\n\nPython uses a philosophy called **duck typing**: \"If it walks like a duck and quacks like a duck, it is a duck.\"\n\nThis means Python does not check the *declared* type of a variable — it checks whether the value *supports the operation you are trying to perform* at the moment you perform it.\n\n```python\ndef double(x):\n    return x * 2\n\nprint(double(5))       # 10    (int * 2)\nprint(double(3.14))    # 6.28  (float * 2)\nprint(double(\"hi\"))    # \"hihi\" (str * 2 = repetition)\n```\n\nThis is flexible, but it also means type errors appear at **runtime**, not before the program runs."
    },
    {
      "type": "text",
      "content": "## TypeScript: Catching Type Errors Before Runtime\n\nTypeScript is JavaScript with **static types**. You declare the type of a variable when you create it, and the TypeScript compiler checks for type errors *before* your code ever runs.\n\nThis catches entire categories of bugs during development:"
    },
    {
      "type": "code",
      "language": "typescript",
      "content": "// TypeScript: explicit type annotations\nlet age: number = 25;\nlet name: string = \"Alice\";\nlet isLoggedIn: boolean = true;\n\n// The compiler catches mistakes:\n// age = \"twenty-five\";  // Error: Type 'string' is not assignable to type 'number'\n\n// Function with typed parameters and return type\nfunction greet(userName: string): string {\n  return \"Hello, \" + userName;\n}\n\nconsole.log(greet(\"Bob\"));   // Hello, Bob\n// greet(42);  // Error: Argument of type 'number' not assignable to 'string'"
    }
  ],
  "summary": "- Every value has a type that determines which operations are valid on it.\n- Python's main types are `int`, `float`, `str`, `bool`, and `None`; JavaScript uses `number`, `string`, `boolean`, `null`, and `undefined`.\n- Use `type()` in Python and `typeof` in JavaScript to inspect a value's type.\n- Convert between types explicitly using `int()`, `str()`, `Number()`, `String()`, etc. to avoid surprises.\n- JavaScript's `==` does implicit type coercion — always prefer `===` for reliable comparisons.\n- TypeScript adds static type annotations that catch type mismatches at compile time, before your code runs."
}$json$::jsonb
WHERE topic_id = (SELECT id FROM topics WHERE title = 'Data Types')
  AND type = 'theory'
  AND language IS NULL;

-- ============================================================
-- TOPIC 3: Conditionals
-- ============================================================

UPDATE lessons
SET content_json = $json${
  "sections": [
    {
      "type": "text",
      "content": "# Conditionals — Making Decisions in Code\n\nReal programs are not simple sequences of steps that always do the same thing. They need to **react** to different situations: show a different page if the user is logged in, display an error if input is invalid, apply a discount if the cart total exceeds a threshold.\n\nThis ability to choose different paths based on conditions is called **control flow**. The most fundamental tool for control flow is the **conditional statement** — code that runs only *if* a certain condition is true."
    },
    {
      "type": "text",
      "content": "## The Basic if/else Structure\n\nA conditional has three parts:\n1. A **condition** — an expression that evaluates to `True` or `False`.\n2. A **then branch** — the code that runs when the condition is true.\n3. An optional **else branch** — the code that runs when the condition is false.\n\nIn Python, indentation (4 spaces) defines the block. In JavaScript/TypeScript, curly braces `{}` define the block."
    },
    {
      "type": "code",
      "language": "python",
      "content": "# Python: if / elif / else\nscore = 75\n\nif score >= 90:\n    print(\"Grade: A\")\nelif score >= 80:\n    print(\"Grade: B\")\nelif score >= 70:\n    print(\"Grade: C\")\nelse:\n    print(\"Grade: F\")\n\n# Output: Grade: C\n\n# Python uses 'elif' (not 'else if')\n# Indentation (4 spaces) marks the block — NO curly braces"
    },
    {
      "type": "code",
      "language": "javascript",
      "content": "// JavaScript: if / else if / else\nconst score = 75;\n\nif (score >= 90) {\n  console.log(\"Grade: A\");\n} else if (score >= 80) {\n  console.log(\"Grade: B\");\n} else if (score >= 70) {\n  console.log(\"Grade: C\");\n} else {\n  console.log(\"Grade: F\");\n}\n\n// Output: Grade: C\n\n// JavaScript uses 'else if' (two words)\n// Curly braces {} define the block\n// Condition must be inside parentheses ()"
    },
    {
      "type": "text",
      "content": "## Comparison Operators\n\nA condition is usually built with a **comparison operator** that compares two values and returns a boolean:\n\n| Operator | Meaning | Python | JavaScript |\n|---|---|---|---|\n| `==` | Equal to | `x == 5` | `x === 5` (prefer strict) |\n| `!=` | Not equal to | `x != 5` | `x !== 5` |\n| `<` | Less than | `x < 5` | `x < 5` |\n| `>` | Greater than | `x > 5` | `x > 5` |\n| `<=` | Less than or equal | `x <= 5` | `x <= 5` |\n| `>=` | Greater than or equal | `x >= 5` | `x >= 5` |\n\nIn JavaScript, **always** use `===` and `!==` instead of `==` and `!=` to avoid implicit type coercion."
    },
    {
      "type": "text",
      "content": "## Logical Operators — Combining Conditions\n\nYou can combine multiple conditions with logical operators:\n\n| Logic | Python | JavaScript |\n|---|---|---|\n| Both must be true | `and` | `&&` |\n| At least one true | `or` | `\\|\\|` |\n| Negate (flip) | `not` | `!` |\n\n```python\n# Python\nage = 20\nhas_id = True\nif age >= 18 and has_id:\n    print(\"Entry allowed\")\n```\n\n```javascript\n// JavaScript\nconst age = 20;\nconst hasId = true;\nif (age >= 18 && hasId) {\n  console.log(\"Entry allowed\");\n}\n```"
    },
    {
      "type": "text",
      "content": "## Truthy and Falsy Values\n\nIn both Python and JavaScript, every value has an inherent \"truthiness\". When you use a non-boolean value as a condition, it is automatically treated as `True` or `False`.\n\n**Falsy values** (treated as `False`):\n\n| Language | Falsy values |\n|---|---|\n| Python | `False`, `0`, `0.0`, `\"\"`, `[]`, `{}`, `None` |\n| JavaScript | `false`, `0`, `\"\"`, `null`, `undefined`, `NaN` |\n\nEverything else is **truthy** (treated as `True`).\n\nThis allows compact checks like `if username:` instead of `if username != \"\":`."
    },
    {
      "type": "code",
      "language": "python",
      "content": "# Python truthy / falsy\nname = \"\"\nif name:\n    print(\"Hello,\", name)\nelse:\n    print(\"No name provided\")  # runs because empty string is falsy\n\nitems = []\nif not items:               # 'not []' is True\n    print(\"Cart is empty\")  # runs\n\n# Comparison vs truthiness\ncount = 0\nif count == 0:   # explicit comparison — clearer\n    print(\"Zero\")\nif not count:    # uses falsy — concise but less obvious\n    print(\"Zero\")"
    },
    {
      "type": "code",
      "language": "javascript",
      "content": "// JavaScript truthy / falsy\nconst username = \"\";\nif (username) {\n  console.log(\"Hello,\", username);\n} else {\n  console.log(\"No name provided\");  // runs\n}\n\nconst items = [];\nif (!items.length) {               // 0 is falsy\n  console.log(\"Cart is empty\");    // runs\n}\n\n// Nullish coalescing operator ?? (returns right side if left is null/undefined)\nconst displayName = username || \"Guest\";  // \"Guest\"\nconst definedValue = null ?? \"default\";   // \"default\""
    },
    {
      "type": "text",
      "content": "## The Ternary Operator — Inline Conditionals\n\nFor simple cases where you want to choose between two values, the **ternary operator** is a compact one-liner.\n\nPython syntax: `value_if_true if condition else value_if_false`\n\nJavaScript syntax: `condition ? value_if_true : value_if_false`"
    },
    {
      "type": "code",
      "language": "python",
      "content": "# Python ternary (conditional expression)\nage = 20\nstatus = \"adult\" if age >= 18 else \"minor\"\nprint(status)  # adult\n\n# Useful inside other expressions\nscores = [85, 92, 78, 65, 95]\npassed = [\"pass\" if s >= 70 else \"fail\" for s in scores]\nprint(passed)  # ['pass', 'pass', 'pass', 'fail', 'pass']"
    },
    {
      "type": "code",
      "language": "javascript",
      "content": "// JavaScript ternary operator\nconst age = 20;\nconst status = age >= 18 ? \"adult\" : \"minor\";\nconsole.log(status);  // adult\n\n// Common use: conditional rendering or messages\nconst score = 85;\nconst message = score >= 90 ? \"Excellent!\" : score >= 70 ? \"Good job\" : \"Keep trying\";\nconsole.log(message);  // Good job"
    },
    {
      "type": "text",
      "content": "## Switch / Match Statements\n\nWhen you have many possible values for a single variable, a chain of `if/elif/else` becomes tedious. Both languages offer a cleaner alternative.\n\n**Python 3.10+** introduced the `match` statement (pattern matching).\n**JavaScript** has the `switch` statement (older, works in all versions)."
    },
    {
      "type": "code",
      "language": "python",
      "content": "# Python 3.10+ match statement\nday = \"Monday\"\n\nmatch day:\n    case \"Monday\" | \"Tuesday\" | \"Wednesday\" | \"Thursday\" | \"Friday\":\n        print(\"Weekday\")\n    case \"Saturday\" | \"Sunday\":\n        print(\"Weekend\")\n    case _:                 # default case (like else)\n        print(\"Unknown day\")\n\n# Output: Weekday"
    },
    {
      "type": "code",
      "language": "javascript",
      "content": "// JavaScript switch statement\nconst day = \"Monday\";\n\nswitch (day) {\n  case \"Monday\":\n  case \"Tuesday\":\n  case \"Wednesday\":\n  case \"Thursday\":\n  case \"Friday\":\n    console.log(\"Weekday\");\n    break;          // IMPORTANT: break exits the switch\n  case \"Saturday\":\n  case \"Sunday\":\n    console.log(\"Weekend\");\n    break;\n  default:          // runs if no case matched\n    console.log(\"Unknown day\");\n}\n// Output: Weekday"
    },
    {
      "type": "text",
      "content": "## Nested Conditions and When to Avoid Them\n\nYou can put `if` statements inside other `if` statements — these are called **nested conditionals**. They work, but deeply nested code becomes hard to read:\n\n```python\n# Hard to read — deep nesting\nif user_logged_in:\n    if has_permission:\n        if item_in_stock:\n            process_order()\n```\n\nA cleaner approach uses **early returns** or **guard clauses** to handle failure cases first:\n\n```python\n# Easier to read — guard clauses\nif not user_logged_in:\n    return \"Not logged in\"\nif not has_permission:\n    return \"No permission\"\nif not item_in_stock:\n    return \"Out of stock\"\nprocess_order()\n```\n\nThe rule of thumb: if you are nesting more than 2 levels deep, there is likely a cleaner way to structure the logic."
    }
  ],
  "summary": "- Conditionals let programs take different paths based on whether a condition is `True` or `False`.\n- Python uses `if / elif / else`; JavaScript and TypeScript use `if / else if / else`.\n- Always prefer `===` over `==` in JavaScript to avoid implicit type coercion.\n- Combine conditions with `and`/`or`/`not` (Python) or `&&`/`||`/`!` (JS/TS).\n- Falsy values (`0`, `\"\"`, `None`, `null`, `undefined`) are treated as `False` in conditions — use this for compact checks."
}$json$::jsonb
WHERE topic_id = (SELECT id FROM topics WHERE title = 'Conditionals')
  AND type = 'theory'
  AND language IS NULL;

-- ============================================================
-- TOPIC 4: Loops
-- ============================================================

UPDATE lessons
SET content_json = $json${
  "sections": [
    {
      "type": "text",
      "content": "# Loops — Repeating Actions Without Copy-Pasting\n\nImagine you need to print a greeting for every user in a list of 1,000 users. You could write 1,000 `print()` calls — or you could use a **loop** to do it in 3 lines.\n\nA **loop** is a control flow structure that repeats a block of code multiple times. Every language supports two fundamental kinds of loops:\n\n1. **`for` loop** — repeats for each item in a collection, or a fixed number of times.\n2. **`while` loop** — repeats as long as a condition remains true.\n\nLoops are one of the most powerful tools in programming. They let you process thousands of items, animate every frame of a game, and check input until it's valid."
    },
    {
      "type": "text",
      "content": "## The `for` Loop\n\nA `for` loop iterates over a **sequence** — a list, a string, a range of numbers, or any other iterable collection."
    },
    {
      "type": "code",
      "language": "python",
      "content": "# Python for loop — iterating over a list\nfruits = [\"apple\", \"banana\", \"cherry\"]\nfor fruit in fruits:\n    print(fruit)\n# apple\n# banana\n# cherry\n\n# Iterating a fixed number of times with range()\nfor i in range(5):       # 0, 1, 2, 3, 4\n    print(i)\n\n# range(start, stop, step)\nfor i in range(2, 10, 2):  # 2, 4, 6, 8\n    print(i)\n\n# Looping over a string character by character\nfor char in \"hello\":\n    print(char)  # h, e, l, l, o"
    },
    {
      "type": "code",
      "language": "javascript",
      "content": "// JavaScript for loops\n\n// Classic C-style for loop\nfor (let i = 0; i < 5; i++) {\n  console.log(i);  // 0, 1, 2, 3, 4\n}\n\n// for...of — iterates over values (preferred for arrays)\nconst fruits = [\"apple\", \"banana\", \"cherry\"];\nfor (const fruit of fruits) {\n  console.log(fruit);  // apple, banana, cherry\n}\n\n// for...in — iterates over keys/indices (use cautiously with arrays)\nconst person = { name: \"Alice\", age: 25 };\nfor (const key in person) {\n  console.log(key, person[key]);  // name Alice, age 25\n}"
    },
    {
      "type": "text",
      "content": "## The `while` Loop\n\nA `while` loop keeps running as long as a condition is `True`. Use it when you do not know in advance how many iterations you need — for example, reading user input until it is valid, or retrying a network request until it succeeds."
    },
    {
      "type": "code",
      "language": "python",
      "content": "# Python while loop\ncountdown = 5\nwhile countdown > 0:\n    print(countdown)\n    countdown -= 1    # IMPORTANT: always update the condition variable!\nprint(\"Blast off!\")\n# 5, 4, 3, 2, 1, Blast off!\n\n# Simulating user input (in real code, use input())\nattempts = 0\npassword = \"\"\nwhile password != \"secret123\" and attempts < 3:\n    password = \"wrong\"  # imagine this is user input\n    attempts += 1\nif password == \"secret123\":\n    print(\"Access granted\")\nelse:\n    print(\"Too many failed attempts\")"
    },
    {
      "type": "code",
      "language": "javascript",
      "content": "// JavaScript while loop\nlet countdown = 5;\nwhile (countdown > 0) {\n  console.log(countdown);\n  countdown--;      // countdown -= 1\n}\nconsole.log(\"Blast off!\");\n// 5, 4, 3, 2, 1, Blast off!\n\n// do...while: always runs at least once\nlet num;\ndo {\n  num = Math.floor(Math.random() * 10);\n} while (num < 5);\nconsole.log(\"Got a number >= 5:\", num);"
    },
    {
      "type": "text",
      "content": "## Loop Control: `break` and `continue`\n\nTwo keywords let you control loop flow mid-iteration:\n\n- **`break`** — immediately exits the entire loop, skipping any remaining iterations.\n- **`continue`** — skips the rest of the current iteration and jumps to the next one.\n\nBoth work the same way in Python and JavaScript."
    },
    {
      "type": "code",
      "language": "python",
      "content": "# break: exit when we find what we need\nnumbers = [3, 7, 2, 9, 1, 5]\nfor num in numbers:\n    if num == 9:\n        print(f\"Found 9 at some position!\")\n        break       # stop searching once found\n    print(num)      # prints 3, 7, 2\n\n# continue: skip certain items\nfor i in range(10):\n    if i % 2 == 0:  # skip even numbers\n        continue\n    print(i)        # prints 1, 3, 5, 7, 9"
    },
    {
      "type": "code",
      "language": "javascript",
      "content": "// break and continue in JavaScript\nconst numbers = [3, 7, 2, 9, 1, 5];\nfor (const num of numbers) {\n  if (num === 9) {\n    console.log(\"Found 9!\");\n    break;\n  }\n  console.log(num);  // 3, 7, 2\n}\n\n// continue: skip even numbers\nfor (let i = 0; i < 10; i++) {\n  if (i % 2 === 0) continue;\n  console.log(i);  // 1, 3, 5, 7, 9\n}"
    },
    {
      "type": "text",
      "content": "## Nested Loops and Complexity\n\nYou can place a loop inside another loop — this is called a **nested loop**. Every iteration of the outer loop runs the entire inner loop.\n\n```python\nfor i in range(3):       # runs 3 times\n    for j in range(3):   # runs 3 times for EACH outer iteration\n        print(i, j)      # runs 3 × 3 = 9 times total\n```\n\nNested loops are necessary for working with grids, tables, and matrices. However, they multiply execution time: if the outer loop runs *n* times and the inner loop also runs *n* times, the total work is *n²*. This is called **O(n²) complexity** — for large datasets, it can be very slow. Always ask: \"Do I really need to nest here, or is there a smarter approach?\""
    },
    {
      "type": "text",
      "content": "## Python List Comprehensions — Elegant Loop Shorthand\n\nPython offers a compact syntax for building a new list by applying an expression to each item in an iterable. This is called a **list comprehension** and it is often more readable than an equivalent `for` loop."
    },
    {
      "type": "code",
      "language": "python",
      "content": "# Traditional loop to build a list\nsquares = []\nfor i in range(1, 6):\n    squares.append(i ** 2)\nprint(squares)  # [1, 4, 9, 16, 25]\n\n# Same thing as a list comprehension\nsquares = [i ** 2 for i in range(1, 6)]\nprint(squares)  # [1, 4, 9, 16, 25]\n\n# With a filter condition\neven_squares = [i ** 2 for i in range(1, 11) if i % 2 == 0]\nprint(even_squares)  # [4, 16, 36, 64, 100]"
    },
    {
      "type": "text",
      "content": "## Array Methods as Loops in JavaScript\n\nJavaScript arrays have built-in methods that replace many common loop patterns. They take a **function** as an argument and apply it to each element — no explicit `for` loop needed."
    },
    {
      "type": "code",
      "language": "javascript",
      "content": "const numbers = [1, 2, 3, 4, 5];\n\n// forEach — runs a function for each element (no return value)\nnumbers.forEach(n => console.log(n));  // 1 2 3 4 5\n\n// map — builds a new array by transforming each element\nconst squares = numbers.map(n => n ** 2);\nconsole.log(squares);  // [1, 4, 9, 16, 25]\n\n// filter — builds a new array with only matching elements\nconst evens = numbers.filter(n => n % 2 === 0);\nconsole.log(evens);    // [2, 4]\n\n// reduce — boils the array down to a single value\nconst total = numbers.reduce((sum, n) => sum + n, 0);\nconsole.log(total);    // 15"
    },
    {
      "type": "text",
      "content": "## Infinite Loops — and How to Avoid Them\n\nAn **infinite loop** runs forever because its condition never becomes false. In a `while` loop this almost always means you forgot to update the condition variable:\n\n```python\n# INFINITE LOOP — never update countdown\ncountdown = 5\nwhile countdown > 0:\n    print(countdown)    # prints 5 forever\n    # countdown -= 1   # forgot this!\n```\n\nAlways check:\n1. Does the condition variable get updated inside the loop?\n2. Is there a `break` statement for edge cases?\n3. Could the condition ever be `False` given real input?\n\nIn development, an accidental infinite loop will freeze your program. Most environments let you kill it with `Ctrl+C`."
    }
  ],
  "summary": "- A `for` loop iterates over a sequence or a fixed number of times; a `while` loop repeats as long as a condition stays true.\n- Python uses `for item in sequence:` and `range()`; JavaScript offers classic `for`, `for...of`, and `for...in`.\n- `break` exits the loop immediately; `continue` skips the current iteration and moves to the next.\n- Nested loops multiply execution time (O(n²)) — use them carefully with large data.\n- Python list comprehensions (`[expr for x in iterable]`) and JS array methods (`.map()`, `.filter()`, `.reduce()`) provide concise, readable alternatives to manual loops."
}$json$::jsonb
WHERE topic_id = (SELECT id FROM topics WHERE title = 'Loops')
  AND type = 'theory'
  AND language IS NULL;

-- ============================================================
-- TOPIC 5: Functions
-- ============================================================

UPDATE lessons
SET content_json = $json${
  "sections": [
    {
      "type": "text",
      "content": "# Functions — Reusable Blocks of Code\n\nAs programs grow, you will find yourself writing the same logic in multiple places. Functions solve this with the **DRY principle**: **Don't Repeat Yourself**.\n\nA **function** is a named, reusable block of code that performs a specific task. Instead of copying and pasting the same lines, you define the logic once, give it a name, and **call** it wherever you need it.\n\nFunctions have two other major benefits beyond reuse:\n- **Abstraction**: callers do not need to know *how* a function works, just *what* it does.\n- **Testability**: isolated functions are easy to test independently."
    },
    {
      "type": "text",
      "content": "## Defining and Calling Functions\n\nIn Python, use the `def` keyword. In JavaScript, you can use the `function` keyword or the modern **arrow function** syntax. In TypeScript, you add type annotations."
    },
    {
      "type": "code",
      "language": "python",
      "content": "# Python: defining a function with 'def'\ndef greet(name):\n    message = \"Hello, \" + name + \"!\"\n    return message\n\n# Calling the function\nresult = greet(\"Alice\")\nprint(result)          # Hello, Alice!\nprint(greet(\"Bob\"))    # Hello, Bob!\n\n# A function with no parameters\ndef say_hello():\n    print(\"Hello, world!\")\n\nsay_hello()  # Hello, world!"
    },
    {
      "type": "code",
      "language": "javascript",
      "content": "// JavaScript: three ways to define a function\n\n// 1. Function declaration (hoisted — can be called before definition)\nfunction greet(name) {\n  return \"Hello, \" + name + \"!\";\n}\n\n// 2. Function expression\nconst greetExpr = function(name) {\n  return \"Hello, \" + name + \"!\";\n};\n\n// 3. Arrow function (concise, modern — preferred in most contexts)\nconst greetArrow = (name) => \"Hello, \" + name + \"!\";\nconst greetArrowMultiLine = (name) => {\n  const message = \"Hello, \" + name + \"!\";\n  return message;\n};\n\nconsole.log(greet(\"Alice\"));       // Hello, Alice!\nconsole.log(greetArrow(\"Bob\"));    // Hello, Bob!"
    },
    {
      "type": "text",
      "content": "## Parameters vs Arguments\n\nThese two words are often confused:\n\n- **Parameter** — the variable name listed in the function *definition*. It is a placeholder.\n- **Argument** — the actual value you *pass* when you call the function.\n\n```python\n# 'name' is a PARAMETER\ndef greet(name):\n    print(\"Hello,\", name)\n\n# \"Alice\" is an ARGUMENT\ngreet(\"Alice\")\n```\n\n### Positional vs Keyword Arguments (Python)\n\nPython lets you pass arguments by **position** or by **name** (keyword):"
    },
    {
      "type": "code",
      "language": "python",
      "content": "def make_sandwich(bread, filling, sauce):\n    return f\"{filling} on {bread} with {sauce}\"\n\n# Positional: order matters\nprint(make_sandwich(\"rye\", \"turkey\", \"mustard\"))\n# turkey on rye with mustard\n\n# Keyword: order doesn't matter\nprint(make_sandwich(filling=\"tuna\", sauce=\"mayo\", bread=\"white\"))\n# tuna on white with mayo\n\n# Mix: positional first, then keyword\nprint(make_sandwich(\"wheat\", sauce=\"ketchup\", filling=\"chicken\"))\n# chicken on wheat with ketchup"
    },
    {
      "type": "text",
      "content": "## Return Values\n\nA function can **return** a value to the caller using the `return` keyword. The caller can then use that value in an expression, assign it to a variable, or pass it to another function.\n\nIf a function reaches the end without a `return`, it returns `None` in Python and `undefined` in JavaScript."
    },
    {
      "type": "code",
      "language": "python",
      "content": "def add(a, b):\n    return a + b\n\nresult = add(3, 4)\nprint(result)           # 7\nprint(add(10, 20) * 2)  # 60  — used directly in an expression\n\n# No return — returns None\ndef log_message(msg):\n    print(\"[LOG]\", msg)\n    # implicitly returns None\n\noutput = log_message(\"Starting up\")\nprint(output)  # None\n\n# Python can return multiple values (as a tuple)\ndef min_max(numbers):\n    return min(numbers), max(numbers)\n\nlow, high = min_max([3, 1, 7, 2, 9])\nprint(low, high)  # 1 9"
    },
    {
      "type": "text",
      "content": "## Default Parameters\n\nYou can give parameters a **default value**. If the caller does not provide an argument for that parameter, the default is used. This makes functions more flexible without requiring every argument every time."
    },
    {
      "type": "code",
      "language": "python",
      "content": "# Python: default parameter values\ndef greet(name, greeting=\"Hello\"):\n    return f\"{greeting}, {name}!\"\n\nprint(greet(\"Alice\"))              # Hello, Alice!\nprint(greet(\"Bob\", \"Good morning\")) # Good morning, Bob!\n\n# Default parameters must come AFTER non-default ones\n# def greet(greeting=\"Hi\", name):   # SyntaxError!"
    },
    {
      "type": "code",
      "language": "javascript",
      "content": "// JavaScript / TypeScript: default parameters\nfunction greet(name, greeting = \"Hello\") {\n  return `${greeting}, ${name}!`;\n}\n\nconsole.log(greet(\"Alice\"));               // Hello, Alice!\nconsole.log(greet(\"Bob\", \"Good morning\")); // Good morning, Bob!\n\n// Arrow function with defaults\nconst power = (base, exponent = 2) => base ** exponent;\nconsole.log(power(3));    // 9   (3²)\nconsole.log(power(2, 8)); // 256 (2⁸)"
    },
    {
      "type": "text",
      "content": "## Scope — Where Does a Variable Live?\n\n**Scope** determines which parts of the code can *see* and *use* a variable.\n\n- **Local scope**: a variable defined inside a function only exists within that function. It disappears when the function returns.\n- **Global scope**: a variable defined at the top level of a file can be seen everywhere.\n\nFunctions should work through their **parameters** and **return values**, not by reading or writing global variables. Global state makes code hard to test and debug."
    },
    {
      "type": "code",
      "language": "python",
      "content": "total = 100  # global variable\n\ndef add_to_total(amount):\n    # Reading a global is fine\n    return total + amount\n\nprint(add_to_total(50))  # 150\n\n# To WRITE to a global, you need the 'global' keyword (usually avoid this)\ndef reset():\n    global total\n    total = 0\n\nreset()\nprint(total)  # 0  — global was modified\n\n# Local variable — invisible outside\ndef compute():\n    local_var = 42\n    return local_var\n\n# print(local_var)  # NameError — local_var doesn't exist here"
    },
    {
      "type": "text",
      "content": "## Pure Functions vs Side Effects\n\nA **pure function** is a function that:\n1. Given the same inputs, always returns the same output.\n2. Has **no side effects** — it does not modify anything outside itself (no global state, no file writes, no network calls, no print statements).\n\nPure functions are easier to test, understand, and reuse. Aim for them whenever possible.\n\nA **side effect** is any observable change to the outside world: printing to screen, writing to a database, modifying a global variable, sending an HTTP request."
    },
    {
      "type": "text",
      "content": "## First-Class Functions — Passing Functions as Arguments\n\nIn Python and JavaScript, functions are **first-class citizens** — you can store them in variables, pass them as arguments to other functions, and return them from functions. This enables powerful patterns."
    },
    {
      "type": "code",
      "language": "python",
      "content": "# Passing a function as an argument\ndef apply(func, value):\n    return func(value)\n\ndef double(x):\n    return x * 2\n\nprint(apply(double, 5))    # 10\nprint(apply(str, 42))      # \"42\"  — built-in functions work too\n\n# Python lambda: anonymous one-liner function\nsquare = lambda x: x ** 2\nprint(square(4))            # 16\n\n# Common use: sorting with a custom key\nwords = [\"banana\", \"apple\", \"kiwi\", \"cherry\"]\nwords.sort(key=lambda w: len(w))  # sort by word length\nprint(words)  # ['kiwi', 'apple', 'banana', 'cherry']"
    },
    {
      "type": "text",
      "content": "## Recursion — Functions That Call Themselves\n\nA function can **call itself**. This is called **recursion**. It is useful for problems that can be broken down into smaller versions of the same problem.\n\nEvery recursive function needs a **base case** — a condition where it stops calling itself, or it will loop forever (stack overflow)."
    },
    {
      "type": "code",
      "language": "python",
      "content": "# Classic example: factorial\n# 5! = 5 × 4 × 3 × 2 × 1 = 120\ndef factorial(n):\n    if n == 0 or n == 1:   # base case — stop here\n        return 1\n    return n * factorial(n - 1)  # recursive call with smaller n\n\nprint(factorial(5))   # 120\nprint(factorial(0))   # 1\n\n# Tracing the calls:\n# factorial(5)\n#   5 * factorial(4)\n#        4 * factorial(3)\n#             3 * factorial(2)\n#                  2 * factorial(1)\n#                       returns 1\n#                  returns 2 * 1 = 2\n#             returns 3 * 2 = 6\n#        returns 4 * 6 = 24\n#   returns 5 * 24 = 120"
    },
    {
      "type": "text",
      "content": "## Variable-Length Arguments\n\nSometimes you do not know how many arguments a function will receive. Both languages support collecting extra arguments into a collection."
    },
    {
      "type": "code",
      "language": "python",
      "content": "# Python: *args collects extra positional arguments as a tuple\ndef add_all(*numbers):\n    return sum(numbers)\n\nprint(add_all(1, 2, 3))       # 6\nprint(add_all(1, 2, 3, 4, 5)) # 15\n\n# **kwargs collects extra keyword arguments as a dict\ndef describe(**info):\n    for key, value in info.items():\n        print(f\"{key}: {value}\")\n\ndescribe(name=\"Alice\", age=25, city=\"Berlin\")\n# name: Alice\n# age: 25\n# city: Berlin"
    },
    {
      "type": "code",
      "language": "javascript",
      "content": "// JavaScript: rest parameters with ...\nfunction addAll(...numbers) {\n  return numbers.reduce((sum, n) => sum + n, 0);\n}\n\nconsole.log(addAll(1, 2, 3));       // 6\nconsole.log(addAll(1, 2, 3, 4, 5)); // 15\n\n// Spread operator — the opposite of rest: expand an array into arguments\nconst nums = [3, 7, 1, 9, 4];\nconsole.log(Math.max(...nums));  // 9"
    }
  ],
  "summary": "- Functions let you define reusable logic once and call it many times, following the DRY principle.\n- Use `def` in Python, `function` or `=>` (arrow) in JavaScript/TypeScript.\n- Parameters are placeholders in the definition; arguments are the actual values passed when calling.\n- Functions return values with `return`; without it they return `None` (Python) or `undefined` (JS).\n- Pure functions have no side effects and always return the same output for the same input — prefer them.\n- Python supports `*args` and `**kwargs` for variable-length arguments; JavaScript uses rest parameters `...args`."
}$json$::jsonb
WHERE topic_id = (SELECT id FROM topics WHERE title = 'Functions')
  AND type = 'theory'
  AND language IS NULL;

-- ============================================================
-- TOPIC 6: Arrays & Lists
-- ============================================================

UPDATE lessons
SET content_json = $json${
  "sections": [
    {
      "type": "text",
      "content": "# Arrays & Lists — Ordered Collections of Values\n\nSo far, every variable you have seen holds a *single* value: one number, one string, one boolean. But real programs constantly work with *collections* of values: all the items in a shopping cart, all the scores in a game, all the users in a database.\n\nAn **array** (JavaScript) or **list** (Python) is an ordered collection of values where:\n- Values are stored in a specific **order** (they have a position).\n- Each position has an **index** (a number starting at 0).\n- The collection is **mutable** — you can add, remove, and change items.\n\nArrays and lists are the most commonly used data structure in programming."
    },
    {
      "type": "text",
      "content": "## Creating Lists and Arrays\n\nBoth Python and JavaScript use square brackets `[]` to create a collection. Lists/arrays can hold values of mixed types, though it is best practice to keep them homogeneous."
    },
    {
      "type": "code",
      "language": "python",
      "content": "# Python lists\nempty_list = []\nnumbers = [1, 2, 3, 4, 5]\nnames = [\"Alice\", \"Bob\", \"Charlie\"]\nmixed = [42, \"hello\", True, 3.14]  # mixed types — valid but unusual\n\n# Alternative constructors\nfrom_range = list(range(1, 6))   # [1, 2, 3, 4, 5]\nrepeated  = [0] * 5              # [0, 0, 0, 0, 0]\n\nprint(numbers)     # [1, 2, 3, 4, 5]\nprint(len(names))  # 3  — number of items"
    },
    {
      "type": "code",
      "language": "javascript",
      "content": "// JavaScript arrays\nconst emptyArray = [];\nconst numbers = [1, 2, 3, 4, 5];\nconst names = [\"Alice\", \"Bob\", \"Charlie\"];\n\n// Alternative constructors\nconst fromArray  = Array.from({ length: 5 }, (_, i) => i + 1); // [1,2,3,4,5]\nconst repeated   = new Array(5).fill(0);                        // [0,0,0,0,0]\n\nconsole.log(numbers);       // [1, 2, 3, 4, 5]\nconsole.log(names.length);  // 3"
    },
    {
      "type": "text",
      "content": "## Accessing Elements by Index\n\nEvery element in a list/array has an **index** — its position, starting from **0** (not 1). This is called **zero-based indexing** and it is used by almost all programming languages.\n\nPython additionally supports **negative indices**: `-1` refers to the last element, `-2` to the second-to-last, etc. JavaScript does not support negative indices directly (use `.at(-1)` instead)."
    },
    {
      "type": "code",
      "language": "python",
      "content": "fruits = [\"apple\", \"banana\", \"cherry\", \"date\", \"elderberry\"]\n\n# Positive indices (start at 0)\nprint(fruits[0])   # apple\nprint(fruits[1])   # banana\nprint(fruits[4])   # elderberry\n\n# Negative indices (count from the end)\nprint(fruits[-1])  # elderberry  (last item)\nprint(fruits[-2])  # date\nprint(fruits[-5])  # apple       (same as index 0)\n\n# IndexError if you go out of bounds\n# print(fruits[10])  # IndexError: list index out of range"
    },
    {
      "type": "code",
      "language": "javascript",
      "content": "const fruits = [\"apple\", \"banana\", \"cherry\", \"date\", \"elderberry\"];\n\n// Positive indices\nconsole.log(fruits[0]);     // apple\nconsole.log(fruits[4]);     // elderberry\n\n// JavaScript doesn't have negative indices in []\nconsole.log(fruits[-1]);    // undefined (not an error!)\n// Use .at() for negative indexing (modern JS)\nconsole.log(fruits.at(-1)); // elderberry\nconsole.log(fruits.at(-2)); // date"
    },
    {
      "type": "text",
      "content": "## Slicing in Python\n\nPython lets you extract a portion of a list using **slice notation**: `list[start:stop:step]`.\n\n- `start` — the index to begin at (inclusive). Defaults to 0.\n- `stop` — the index to stop at (exclusive). Defaults to the end.\n- `step` — how many to skip between each element. Defaults to 1.\n\nSlices always return a *new* list, leaving the original unchanged."
    },
    {
      "type": "code",
      "language": "python",
      "content": "nums = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]\n\nprint(nums[2:5])    # [2, 3, 4]  — index 2 up to (not including) 5\nprint(nums[:3])     # [0, 1, 2]  — from start to index 3\nprint(nums[7:])     # [7, 8, 9]  — from index 7 to end\nprint(nums[::2])    # [0, 2, 4, 6, 8]  — every other item\nprint(nums[::-1])   # [9, 8, 7, ..., 0]  — reversed!\n\n# Copy a list\nnums_copy = nums[:]  # creates a shallow copy"
    },
    {
      "type": "text",
      "content": "## Mutating Lists and Arrays\n\nLists and arrays are **mutable** — you can change their contents after creation. Here are the most common operations:"
    },
    {
      "type": "code",
      "language": "python",
      "content": "items = [\"a\", \"b\", \"c\"]\n\n# Add items\nitems.append(\"d\")         # add to end:    ['a', 'b', 'c', 'd']\nitems.insert(1, \"x\")      # at index 1:    ['a', 'x', 'b', 'c', 'd']\nitems.extend([\"e\", \"f\"])  # merge another: ['a', 'x', 'b', 'c', 'd', 'e', 'f']\n\n# Remove items\nitems.pop()         # remove & return last: 'f'\nitems.pop(1)        # remove & return at index 1: 'x'\nitems.remove(\"c\")   # remove first occurrence of 'c'\n\n# Find and sort\nprint(items.index(\"b\"))  # 1 — index of first 'b'\nitems.sort()             # sort in place: ['a', 'b', 'd', 'e']\nitems.reverse()          # reverse in place\n\nprint(items)"
    },
    {
      "type": "code",
      "language": "javascript",
      "content": "const items = [\"a\", \"b\", \"c\"];\n\n// Add items\nitems.push(\"d\");           // add to end:    ['a','b','c','d']\nitems.unshift(\"z\");        // add to start:  ['z','a','b','c','d']\n\n// Remove items\nconst last = items.pop();  // remove & return last: 'd'\nconst first = items.shift(); // remove & return first: 'z'\n\n// splice(startIndex, deleteCount, ...itemsToInsert)\nitems.splice(1, 1);          // remove 1 item at index 1 → ['a','c']\nitems.splice(1, 0, \"b\");     // insert 'b' at index 1 → ['a','b','c']\n\n// Find\nconsole.log(items.indexOf(\"b\"));   // 1\nconsole.log(items.includes(\"z\"));  // false\n\n// Sort (sorts as strings by default!)\nconst numbers = [10, 1, 5, 3];\nnumbers.sort((a, b) => a - b);  // numeric sort\nconsole.log(numbers);  // [1, 3, 5, 10]"
    },
    {
      "type": "text",
      "content": "## Functional Array Methods — map, filter, reduce\n\nThese three methods are available in both Python and JavaScript. They take a **function** and apply it to the array, producing a result without mutating the original.\n\n| Method | What it does |\n|---|---|\n| `map` | Transform each element into a new value |\n| `filter` | Keep only elements that pass a test |\n| `reduce` | Combine all elements into a single value |"
    },
    {
      "type": "code",
      "language": "python",
      "content": "numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]\n\n# map: transform each element\ndoubled = list(map(lambda x: x * 2, numbers))\nprint(doubled)   # [2, 4, 6, 8, 10, 12, 14, 16, 18, 20]\n\n# filter: keep only elements where function returns True\nevens = list(filter(lambda x: x % 2 == 0, numbers))\nprint(evens)     # [2, 4, 6, 8, 10]\n\n# reduce: combine into one value\nfrom functools import reduce\ntotal = reduce(lambda acc, x: acc + x, numbers, 0)\nprint(total)     # 55\n\n# List comprehension is often more Pythonic than map/filter\ndoubled_comp = [x * 2 for x in numbers]\nevens_comp   = [x for x in numbers if x % 2 == 0]\nprint(doubled_comp)  # [2, 4, 6, 8, 10, 12, 14, 16, 18, 20]\nprint(evens_comp)    # [2, 4, 6, 8, 10]"
    },
    {
      "type": "code",
      "language": "javascript",
      "content": "const numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];\n\n// map: transform each element\nconst doubled = numbers.map(x => x * 2);\nconsole.log(doubled);  // [2, 4, 6, 8, 10, 12, 14, 16, 18, 20]\n\n// filter: keep elements where function returns true\nconst evens = numbers.filter(x => x % 2 === 0);\nconsole.log(evens);    // [2, 4, 6, 8, 10]\n\n// reduce: accumulate into a single value\nconst total = numbers.reduce((acc, x) => acc + x, 0);\nconsole.log(total);    // 55\n\n// Chaining methods\nconst sumOfEvenSquares = numbers\n  .filter(x => x % 2 === 0)\n  .map(x => x ** 2)\n  .reduce((acc, x) => acc + x, 0);\nconsole.log(sumOfEvenSquares);  // 220  (4+16+36+64+100)"
    },
    {
      "type": "text",
      "content": "## List Comprehensions — Python's Power Feature\n\nList comprehensions are a concise, readable way to create lists in Python. They can replace `map()` and `filter()` with a more Pythonic syntax:\n\n```\n[expression for item in iterable if condition]\n```\n\nThe `if condition` part is optional."
    },
    {
      "type": "code",
      "language": "python",
      "content": "# Create a list of squares\nsquares = [x**2 for x in range(1, 11)]\nprint(squares)  # [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]\n\n# Filter: only positive numbers, doubled\nnums = [-3, -1, 0, 2, 5, 8]\nresult = [x * 2 for x in nums if x > 0]\nprint(result)   # [4, 10, 16]\n\n# Flatten a 2D list\nmatrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]\nflat = [num for row in matrix for num in row]\nprint(flat)     # [1, 2, 3, 4, 5, 6, 7, 8, 9]\n\n# String operations\nwords = [\"hello\", \"world\", \"python\"]\nupper = [w.upper() for w in words]\nprint(upper)    # ['HELLO', 'WORLD', 'PYTHON']"
    }
  ],
  "summary": "- A list (Python) or array (JavaScript) is an ordered, mutable collection of values accessed by zero-based index.\n- Python supports negative indices (`-1` for last) and slice notation (`arr[start:stop:step]`); JS uses `.at(-1)` for negative access.\n- Python list methods: `.append()`, `.insert()`, `.extend()`, `.pop()`, `.remove()`, `.sort()`.\n- JavaScript array methods: `.push()`, `.pop()`, `.shift()`, `.unshift()`, `.splice()`, `.indexOf()`, `.includes()`.\n- `.map()`, `.filter()`, and `.reduce()` transform arrays functionally without mutation — prefer these for clarity.\n- Python list comprehensions (`[expr for x in iterable if condition]`) are the idiomatic alternative to `map`/`filter`."
}$json$::jsonb
WHERE topic_id = (SELECT id FROM topics WHERE title = 'Arrays & Lists')
  AND type = 'theory'
  AND language IS NULL;

-- ============================================================
-- TOPIC 7: Objects & Dicts
-- ============================================================

UPDATE lessons
SET content_json = $json${
  "sections": [
    {
      "type": "text",
      "content": "# Objects & Dictionaries — Key-Value Pairs\n\nLists are great for ordered collections of similar items: a list of scores, a list of names. But what if you want to describe a *single thing* with many different properties? A user has a name, an age, an email, and a location. Storing that in a list would mean you would have to remember that index 0 is the name, index 1 is the age — fragile and unreadable.\n\n**Dictionaries** (Python) and **Objects** (JavaScript) solve this with **key-value pairs**. Instead of a numbered index, each value gets a descriptive **key** (a name).\n\nThink of a phone book: you look up a person's *name* (the key) and find their *phone number* (the value). Or a real-world dictionary: you look up a *word* (key) to find its *definition* (value)."
    },
    {
      "type": "text",
      "content": "## Creating Dictionaries and Objects"
    },
    {
      "type": "code",
      "language": "python",
      "content": "# Python dictionaries — use curly braces {}\nempty_dict = {}\n\nuser = {\n    \"name\": \"Alice\",\n    \"age\": 25,\n    \"email\": \"alice@example.com\",\n    \"is_active\": True\n}\n\n# Alternative: dict() constructor\npoint = dict(x=10, y=20)   # {\"x\": 10, \"y\": 20}\n\nprint(user)          # the whole dict\nprint(type(user))    # <class 'dict'>"
    },
    {
      "type": "code",
      "language": "javascript",
      "content": "// JavaScript objects — also use curly braces {}\nconst emptyObj = {};\n\nconst user = {\n  name: \"Alice\",\n  age: 25,\n  email: \"alice@example.com\",\n  isActive: true\n};\n\n// Note: JS object keys don't need quotes (unless they have special chars)\n// Python dict keys are always strings (or other hashable types)\nconsole.log(user);        // { name: 'Alice', age: 25, ... }\nconsole.log(typeof user); // \"object\""
    },
    {
      "type": "text",
      "content": "## Accessing Values\n\nYou retrieve a value by looking up its key. Both languages support two syntaxes:\n\n- **Bracket notation** `dict[\"key\"]` / `obj[\"key\"]` — works with any key, including computed keys stored in variables.\n- **Dot notation** `obj.key` — shorter, but only works with keys that are valid identifiers (Python dicts do not have dot notation; JavaScript objects do).\n\nAccessing a key that does not exist: Python raises a `KeyError`; JavaScript returns `undefined`."
    },
    {
      "type": "code",
      "language": "python",
      "content": "user = {\"name\": \"Alice\", \"age\": 25, \"city\": \"Berlin\"}\n\n# Bracket notation\nprint(user[\"name\"])   # Alice\nprint(user[\"age\"])    # 25\n\n# .get() — safe access with an optional default\nprint(user.get(\"city\"))           # Berlin\nprint(user.get(\"country\"))        # None  (key missing, no error)\nprint(user.get(\"country\", \"N/A\")) # N/A   (custom default)\n\n# KeyError if key doesn't exist\n# print(user[\"country\"])  # KeyError: 'country'\n\n# Dynamic key access\nfield = \"name\"\nprint(user[field])  # Alice"
    },
    {
      "type": "code",
      "language": "javascript",
      "content": "const user = { name: \"Alice\", age: 25, city: \"Berlin\" };\n\n// Dot notation\nconsole.log(user.name);  // Alice\nconsole.log(user.age);   // 25\n\n// Bracket notation — required for dynamic or special-char keys\nconsole.log(user[\"city\"]);  // Berlin\nconst field = \"name\";\nconsole.log(user[field]);   // Alice\n\n// Missing key returns undefined (no error)\nconsole.log(user.country);   // undefined\n\n// Safe access with optional chaining ?.\nconsole.log(user?.address?.street);  // undefined (no error, no crash)"
    },
    {
      "type": "text",
      "content": "## Creating, Updating, and Deleting Entries\n\nBoth Python dicts and JavaScript objects are mutable — you can freely add, change, and remove key-value pairs after creation."
    },
    {
      "type": "code",
      "language": "python",
      "content": "profile = {\"name\": \"Bob\", \"level\": 1}\n\n# Add a new key\nprofile[\"score\"] = 0\nprint(profile)  # {'name': 'Bob', 'level': 1, 'score': 0}\n\n# Update an existing key\nprofile[\"level\"] = 5\nprofile[\"score\"] += 100\nprint(profile)  # {'name': 'Bob', 'level': 5, 'score': 100}\n\n# Delete a key\ndel profile[\"score\"]      # raises KeyError if key missing\npopped = profile.pop(\"level\")  # remove and return value\nprint(popped)   # 5\nprint(profile)  # {'name': 'Bob'}\n\n# .pop() with default — no error if key missing\nval = profile.pop(\"missing_key\", \"default\")\nprint(val)  # default"
    },
    {
      "type": "code",
      "language": "javascript",
      "content": "const profile = { name: \"Bob\", level: 1 };\n\n// Add a new key\nprofile.score = 0;\nconsole.log(profile);  // { name: 'Bob', level: 1, score: 0 }\n\n// Update an existing key\nprofile.level = 5;\nprofile.score += 100;\nconsole.log(profile);  // { name: 'Bob', level: 5, score: 100 }\n\n// Delete a key\ndelete profile.score;\nconsole.log(profile);  // { name: 'Bob', level: 5 }\n\n// Spread to create a modified copy (immutable style)\nconst updated = { ...profile, level: 10 };\nconsole.log(updated);  // { name: 'Bob', level: 10 }"
    },
    {
      "type": "text",
      "content": "## Checking If a Key Exists"
    },
    {
      "type": "code",
      "language": "python",
      "content": "config = {\"debug\": True, \"max_retries\": 3}\n\n# Python: 'in' operator\nif \"debug\" in config:\n    print(\"Debug mode:\", config[\"debug\"])\n\nif \"timeout\" not in config:\n    print(\"No timeout set — using default\")\n\n# All keys as a view object\nprint(config.keys())    # dict_keys(['debug', 'max_retries'])\nprint(\"debug\" in config.keys())  # True (same as 'in' on dict)"
    },
    {
      "type": "code",
      "language": "javascript",
      "content": "const config = { debug: true, maxRetries: 3 };\n\n// hasOwnProperty (older, explicit)\nif (config.hasOwnProperty(\"debug\")) {\n  console.log(\"Debug mode:\", config.debug);\n}\n\n// 'in' operator (also checks prototype chain)\nif (\"timeout\" in config === false) {\n  console.log(\"No timeout set\");\n}\n\n// Modern: Object.hasOwn() — preferred over hasOwnProperty\nif (Object.hasOwn(config, \"debug\")) {\n  console.log(\"Has debug key\");\n}"
    },
    {
      "type": "text",
      "content": "## Iterating Over Dictionaries and Objects"
    },
    {
      "type": "code",
      "language": "python",
      "content": "scores = {\"Alice\": 95, \"Bob\": 82, \"Charlie\": 88}\n\n# Iterate over keys (default)\nfor name in scores:\n    print(name)       # Alice, Bob, Charlie\n\n# Iterate over values\nfor score in scores.values():\n    print(score)      # 95, 82, 88\n\n# Iterate over key-value pairs (most common)\nfor name, score in scores.items():\n    print(f\"{name}: {score}\")\n# Alice: 95\n# Bob: 82\n# Charlie: 88\n\n# keys(), values(), items() return view objects — they reflect changes\nkeys_view = scores.keys()\nscores[\"Diana\"] = 91\nprint(list(keys_view))  # ['Alice', 'Bob', 'Charlie', 'Diana']"
    },
    {
      "type": "code",
      "language": "javascript",
      "content": "const scores = { Alice: 95, Bob: 82, Charlie: 88 };\n\n// Object.keys() — array of keys\nObject.keys(scores).forEach(name => console.log(name));\n// Alice, Bob, Charlie\n\n// Object.values() — array of values\nconst total = Object.values(scores).reduce((sum, s) => sum + s, 0);\nconsole.log(\"Total:\", total);  // Total: 265\n\n// Object.entries() — array of [key, value] pairs\nfor (const [name, score] of Object.entries(scores)) {\n  console.log(`${name}: ${score}`);\n}\n// Alice: 95, Bob: 82, Charlie: 88"
    },
    {
      "type": "text",
      "content": "## Nested Objects and Dictionaries\n\nDictionaries and objects can contain other dictionaries/objects as values, allowing you to model complex, hierarchical data."
    },
    {
      "type": "code",
      "language": "python",
      "content": "user = {\n    \"name\": \"Alice\",\n    \"age\": 25,\n    \"address\": {\n        \"street\": \"123 Main St\",\n        \"city\": \"Berlin\",\n        \"zip\": \"10115\"\n    },\n    \"scores\": [85, 92, 78]  # can also contain lists\n}\n\n# Accessing nested values\nprint(user[\"address\"][\"city\"])  # Berlin\nprint(user[\"scores\"][0])        # 85\n\n# Updating nested values\nuser[\"address\"][\"city\"] = \"Munich\"\nuser[\"scores\"].append(95)\nprint(user[\"address\"][\"city\"])  # Munich\nprint(user[\"scores\"])           # [85, 92, 78, 95]"
    },
    {
      "type": "text",
      "content": "## JSON — Dicts/Objects for Data Exchange\n\n**JSON** (JavaScript Object Notation) is the most widely used format for sending data between a frontend and a backend, or between APIs. It looks almost identical to Python dicts and JavaScript objects:\n\n```json\n{\n  \"name\": \"Alice\",\n  \"age\": 25,\n  \"scores\": [85, 92, 78],\n  \"address\": { \"city\": \"Berlin\" }\n}\n```\n\nJSON supports strings, numbers, booleans, null, arrays, and objects. In Python you convert between JSON strings and dicts with the `json` module. In JavaScript, `JSON.parse()` and `JSON.stringify()` handle conversion.\n\nThis is why understanding dicts/objects is essential for web development: virtually every API response you will ever receive is JSON."
    },
    {
      "type": "text",
      "content": "## Common Patterns — Counting and Grouping\n\nDictionaries are perfect for two very common programming tasks: counting occurrences and grouping items."
    },
    {
      "type": "code",
      "language": "python",
      "content": "# Count character occurrences\ntext = \"hello world\"\ncounts = {}\nfor char in text:\n    counts[char] = counts.get(char, 0) + 1\nprint(counts)\n# {'h': 1, 'e': 1, 'l': 3, 'o': 2, ' ': 1, 'w': 1, 'r': 1, 'd': 1}\n\n# Pythonic: use collections.Counter\nfrom collections import Counter\nprint(Counter(text))  # Counter({'l': 3, 'o': 2, ...})\n\n# Group items by a property\nstudents = [\n    {\"name\": \"Alice\", \"grade\": \"A\"},\n    {\"name\": \"Bob\",   \"grade\": \"B\"},\n    {\"name\": \"Carol\", \"grade\": \"A\"},\n    {\"name\": \"Dan\",   \"grade\": \"B\"},\n]\nby_grade = {}\nfor s in students:\n    grade = s[\"grade\"]\n    by_grade.setdefault(grade, []).append(s[\"name\"])\nprint(by_grade)  # {'A': ['Alice', 'Carol'], 'B': ['Bob', 'Dan']}"
    },
    {
      "type": "text",
      "content": "## TypeScript: Typed Objects with Interfaces\n\nIn TypeScript, you define the shape of an object using an **interface** or a **type alias**. This gives you autocomplete and catches typos at compile time."
    },
    {
      "type": "code",
      "language": "typescript",
      "content": "// TypeScript: define the shape with an interface\ninterface User {\n  name: string;\n  age: number;\n  email: string;\n  isActive?: boolean;  // ? means optional\n}\n\nconst user: User = {\n  name: \"Alice\",\n  age: 25,\n  email: \"alice@example.com\"\n};\n\n// TypeScript catches mistakes:\n// user.age = \"twenty-five\";  // Error: Type 'string' not assignable to 'number'\n// user.unknownProp = true;    // Error: Property 'unknownProp' not in 'User'\n\n// Function that accepts a typed object\nfunction greetUser(u: User): string {\n  return `Hello, ${u.name}! You are ${u.age} years old.`;\n}\n\nconsole.log(greetUser(user));"
    }
  ],
  "summary": "- A dictionary (Python) or object (JavaScript) stores data as key-value pairs, allowing you to describe a thing by named properties instead of numbered positions.\n- Access values with `dict[\"key\"]` or `obj.key`; use Python's `.get(key, default)` or JS optional chaining `?.` for safe access.\n- Add/update entries with assignment (`dict[\"key\"] = value`); delete with `del` (Python) or `delete` (JS).\n- Check for key existence with `\"key\" in dict` (Python) or `Object.hasOwn(obj, \"key\")` (JS).\n- Iterate with `.items()` / `.keys()` / `.values()` (Python) or `Object.entries()` / `Object.keys()` (JS).\n- JSON format is built on the same key-value structure — mastering dicts/objects is essential for web APIs and data exchange."
}$json$::jsonb
WHERE topic_id = (SELECT id FROM topics WHERE title = 'Objects & Dicts')
  AND type = 'theory'
  AND language IS NULL;
