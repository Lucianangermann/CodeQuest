-- 022: Topics 15-17 — Closures & Scope, Async/Await & Promises, Modules & Imports
-- Each topic: theory (order 1), quiz (order 2), Python lessons (order 3-7),
--             JS lessons (order 8-11), TS lessons (order 12-14)

-- ============================================================
-- TOPICS
-- ============================================================

INSERT INTO public.topics (title, description, order_index, icon) VALUES
  ('Closures & Scope', 'Understand how JavaScript and Python handle variable scope and closures', 15, '🔒'),
  ('Async/Await & Promises', 'Master asynchronous programming patterns in JavaScript and Python', 16, '⚡'),
  ('Modules & Imports', 'Organize code with modules, imports, and packages', 17, '📦');


-- ============================================================
-- TOPIC 15: Closures & Scope — Theory (order 1)
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Understanding Closures and Scope', 'theory', 10, 1, NULL,
$json${
  "sections": [
    {
      "type": "text",
      "content": "## What is Variable Scope?\n\n**Scope** determines where in your code a variable is accessible. Every programming language defines rules for scope — these rules determine which variables a function can see and which are invisible to it.\n\nThink of scope like layers of rooms inside a house. Code in an inner room can see everything in outer rooms, but code in an outer room cannot see into inner rooms."
    },
    {
      "type": "text",
      "content": "## Python's LEGB Rule\n\nPython resolves variable names by searching four scope levels in order:\n\n1. **L — Local**: variables defined inside the current function\n2. **E — Enclosing**: variables in any enclosing (outer) functions (relevant for nested functions)\n3. **G — Global**: variables defined at the module/top level\n4. **B — Built-in**: Python's built-in names like `len`, `print`, `range`\n\nPython searches from inside out — if a name is found at the local level, the search stops there."
    },
    {
      "type": "code",
      "language": "python",
      "content": "x = 'global'       # G — global scope\n\ndef outer():\n    x = 'enclosing'  # E — enclosing scope\n\n    def inner():\n        x = 'local'  # L — local scope\n        print(x)     # prints 'local'\n\n    inner()\n    print(x)         # prints 'enclosing'\n\nouter()\nprint(x)             # prints 'global'"
    },
    {
      "type": "text",
      "content": "## Block Scope in JavaScript: var vs let/const\n\nJavaScript has two different scoping behaviours depending on which keyword you use:\n\n- **`var`** is **function-scoped**: it is hoisted to the top of its enclosing function and is visible throughout the entire function, even before the line where it is declared.\n- **`let` and `const`** are **block-scoped**: they are only accessible within the `{}` block where they are defined — inside an `if`, `for`, or any `{}` pair.\n\nThis distinction is one of the most common sources of bugs in JavaScript — always prefer `let` and `const` over `var`."
    },
    {
      "type": "code",
      "language": "javascript",
      "content": "// var is function-scoped — leaks out of blocks\nfunction demoVar() {\n  if (true) {\n    var x = 'I am var';\n  }\n  console.log(x); // 'I am var' — x leaked out of the if block!\n}\n\n// let is block-scoped — stays inside the block\nfunction demoLet() {\n  if (true) {\n    let y = 'I am let';\n  }\n  // console.log(y); // ReferenceError: y is not defined\n  console.log('y is not accessible here');\n}\n\ndemoVar();\ndemoLet();"
    },
    {
      "type": "text",
      "content": "## What is a Closure?\n\nA **closure** is a function that **remembers the variables from its enclosing scope**, even after the outer function has finished executing.\n\nWhen a function is defined inside another function, it captures a reference to the variables in the outer function. This captured environment travels with the inner function wherever it goes — even if the outer function has long returned.\n\nThis is not a copy of the variables — it is a live reference. If the outer variable changes, the closure sees the updated value."
    },
    {
      "type": "code",
      "language": "python",
      "content": "def make_greeter(greeting):\n    # 'greeting' lives in the enclosing scope of inner()\n    def greet(name):\n        # greet() 'closes over' greeting\n        return f'{greeting}, {name}!'\n    return greet\n\nhello = make_greeter('Hello')\nhi = make_greeter('Hi')\n\nprint(hello('Alice'))  # Hello, Alice!\nprint(hi('Bob'))       # Hi, Bob!\n# make_greeter() has returned, but greeting is still accessible"
    },
    {
      "type": "text",
      "content": "## Practical Uses of Closures\n\nClosures are not just a theoretical concept — they appear everywhere in real code:\n\n**1. Factory functions** — create specialised versions of a function:\n```python\ndef make_multiplier(factor):\n    def multiply(x):\n        return x * factor\n    return multiply\n\ndouble = make_multiplier(2)\ntriple = make_multiplier(3)\nprint(double(5))  # 10\nprint(triple(5))  # 15\n```\n\n**2. Data privacy** — hide state inside a closure instead of using global variables.\n\n**3. Partial application** — lock in some arguments of a function to create a new simpler function.\n\n**4. Callbacks and event handlers** — capture context (e.g. a user ID) at the time an event handler is set up."
    },
    {
      "type": "text",
      "content": "## The Classic Closure Loop Bug\n\nThis is one of the most famous gotchas in both Python and JavaScript. When you create functions inside a loop, all of them close over the *same* variable — not a snapshot of it at the time of creation.\n\nBy the time the functions run, the loop has finished and the variable has its final value, so every function returns the same thing."
    },
    {
      "type": "code",
      "language": "python",
      "content": "# BUG: all lambdas close over the same variable i\nbuggy = [lambda: i for i in range(3)]\nprint([f() for f in buggy])  # [2, 2, 2] — all return 2!\n\n# FIX 1: default argument captures the value at creation time\nfixed = [lambda i=i: i for i in range(3)]\nprint([f() for f in fixed])  # [0, 1, 2]\n\n# FIX 2: use a factory function\ndef make_fn(i):\n    return lambda: i\n\nalso_fixed = [make_fn(i) for i in range(3)]\nprint([f() for f in also_fixed])  # [0, 1, 2]"
    },
    {
      "type": "text",
      "content": "## Python's nonlocal Keyword\n\nBy default, assigning to a variable inside a function creates a new *local* variable — it does not modify the enclosing scope's variable. If you want to modify a variable in an enclosing (but not global) scope, you need the `nonlocal` keyword.\n\nWithout `nonlocal`, Python raises `UnboundLocalError` if you try to read-then-write a variable from the enclosing scope."
    },
    {
      "type": "code",
      "language": "python",
      "content": "def make_counter(start=0):\n    count = start\n\n    def increment():\n        nonlocal count   # tells Python: count lives in the enclosing scope\n        count += 1\n        return count\n\n    return increment\n\nc = make_counter(10)\nprint(c())  # 11\nprint(c())  # 12\nprint(c())  # 13"
    },
    {
      "type": "text",
      "content": "## JavaScript Closures by Reference\n\nIn JavaScript, closures capture variables **by reference**, not by value. This means:\n\n- A closure sees the *current* value of a variable, not the value it had when the closure was created.\n- Multiple closures sharing the same outer variable all see the same changes to it.\n\nThis is exactly why the loop bug exists with `var`. Using `let` in a `for` loop solves this because `let` creates a new binding for each iteration."
    },
    {
      "type": "code",
      "language": "javascript",
      "content": "// PROBLEM: var creates ONE binding shared by all closures\nconst buggy = [];\nfor (var i = 0; i < 3; i++) {\n  buggy.push(() => i);\n}\nconsole.log(buggy.map(f => f())); // [3, 3, 3]\n\n// FIX: let creates a NEW binding per iteration\nconst fixed = [];\nfor (let j = 0; j < 3; j++) {\n  fixed.push(() => j);\n}\nconsole.log(fixed.map(f => f())); // [0, 1, 2]"
    },
    {
      "type": "text",
      "content": "## The Module Pattern\n\nBefore ES6 modules, JavaScript developers used closures to simulate **private state**. The **module pattern** wraps code in an Immediately Invoked Function Expression (IIFE) and exposes only a public API:\n\n```javascript\nconst counter = (() => {\n  let _count = 0;        // private — not accessible from outside\n  return {\n    increment: () => ++_count,\n    decrement: () => --_count,\n    get: () => _count,\n  };\n})();\n\ncounter.increment();\ncounter.increment();\nconsole.log(counter.get()); // 2\nconsole.log(counter._count); // undefined — truly private\n```\n\nThis pattern is still useful today for encapsulating state without classes."
    },
    {
      "type": "text",
      "content": "## Closures for Memoization\n\nMemoization is a performance optimisation where you cache the results of expensive function calls. Closures make this elegant — the cache lives in the closure, invisible from outside:\n\n```python\ndef memoize(fn):\n    cache = {}          # lives in the closure\n    def wrapper(*args):\n        if args not in cache:\n            cache[args] = fn(*args)\n        return cache[args]\n    return wrapper\n\n@memoize\ndef slow_fib(n):\n    if n <= 1:\n        return n\n    return slow_fib(n - 1) + slow_fib(n - 2)\n\nprint(slow_fib(35))  # fast — each subproblem computed once\n```"
    }
  ],
  "summary": "Scope defines where variables are visible. Closures let inner functions remember and access variables from their enclosing scope even after that scope has exited. Python uses the LEGB rule; JavaScript uses function scope (var) or block scope (let/const). Closures power factory functions, memoization, data privacy, and the module pattern."
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Closures & Scope';


-- ============================================================
-- TOPIC 15: Closures & Scope — Quiz (order 2)
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Closures & Scope Quiz', 'quiz', 10, 2, NULL,
$json${
  "question": "What is a closure in programming?",
  "options": [
    "A function that remembers variables from its outer scope even after the outer function has returned",
    "A way to close a file or database connection",
    "A loop that terminates early with break",
    "A class that prevents inheritance"
  ],
  "correct_index": 0,
  "explanation": "A closure is a function that captures and retains access to variables from its enclosing lexical scope. Even after the outer function returns, the inner function keeps a live reference to those variables — this is what makes factory functions, memoization, and the module pattern possible."
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Closures & Scope';


-- ============================================================
-- TOPIC 15: Closures & Scope — Python lessons (order 3-7)
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: Counter with Closure', 'code', 15, 3, 'python',
$json${
  "instructions": "Write a function make_counter(start=0) that returns an increment function. Each call to the returned function should increase an internal counter by 1 and return the new value. Use nonlocal to modify the enclosing variable.\n\nCreate a counter starting at 10 and call it three times, printing each result.\n\nExpected output:\n11\n12\n13",
  "starter_code": "def make_counter(start=0):\n    count = start\n    def increment():\n        nonlocal count\n        # increment count and return it\n        pass\n    return increment\n\nc = make_counter(10)\nprint(c())\nprint(c())\nprint(c())",
  "expected_output": "11\n12\n13",
  "hints": [
    "nonlocal count tells Python that count lives in the enclosing make_counter scope",
    "Increment with count += 1, then return count",
    "Each call to c() should increase the shared count variable by 1"
  ],
  "solution": "def make_counter(start=0):\n    count = start\n    def increment():\n        nonlocal count\n        count += 1\n        return count\n    return increment\n\nc = make_counter(10)\nprint(c())\nprint(c())\nprint(c())"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Closures & Scope';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: Debug: Fix the Closure Loop Bug', 'code', 20, 4, 'python',
$json${
  "instructions": "The code below creates a list of lambda functions inside a loop, but they all return the same value due to the closure loop bug. Fix it so each function returns its own index.\n\nExpected output:\n0\n1\n2",
  "starter_code": "# Buggy: all lambdas close over the same variable i\n# funcs = [lambda: i for i in range(3)]\n# This would print 2, 2, 2\n\n# Fix: use a default argument to capture the value at creation time\nfuncs = [lambda i=i: i for i in range(3)]\n\nfor f in funcs:\n    print(f())",
  "expected_output": "0\n1\n2",
  "hints": [
    "Default arguments are evaluated at function definition time, not call time",
    "lambda i=i: i — the default value i=i captures the current value of i",
    "You could also use a factory function: def make_fn(i): return lambda: i"
  ],
  "solution": "funcs = [lambda i=i: i for i in range(3)]\n\nfor f in funcs:\n    print(f())"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Closures & Scope';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: Memoize with Closure', 'code', 20, 5, 'python',
$json${
  "instructions": "Implement a memoize(fn) decorator that caches results using a dictionary in the closure. Apply it to a recursive fibonacci function and compute fib(10).\n\nExpected output:\n55",
  "starter_code": "def memoize(fn):\n    cache = {}\n    def wrapper(*args):\n        if args not in cache:\n            cache[args] = fn(*args)\n        return cache[args]\n    return wrapper\n\n@memoize\ndef fib(n):\n    if n <= 1:\n        return n\n    return fib(n - 1) + fib(n - 2)\n\nprint(fib(10))",
  "expected_output": "55",
  "hints": [
    "The cache dict lives in the closure — each call checks cache before computing",
    "args is a tuple (e.g. (10,)) and works as a dict key",
    "fib(10) = 55; with memoization, each subproblem is computed only once"
  ],
  "solution": "def memoize(fn):\n    cache = {}\n    def wrapper(*args):\n        if args not in cache:\n            cache[args] = fn(*args)\n        return cache[args]\n    return wrapper\n\n@memoize\ndef fib(n):\n    if n <= 1:\n        return n\n    return fib(n - 1) + fib(n - 2)\n\nprint(fib(10))"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Closures & Scope';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: Partial Application', 'code', 15, 6, 'python',
$json${
  "instructions": "Write a function partial_apply(fn, x) that returns a new function. The returned function takes one argument y and calls fn(x, y).\n\nUse it to create double = partial_apply(multiply, 2) where multiply(x, y) returns x * y.\n\nExpected output:\n10\n20",
  "starter_code": "def multiply(x, y):\n    return x * y\n\ndef partial_apply(fn, x):\n    def inner(y):\n        return fn(x, y)\n    return inner\n\ndouble = partial_apply(multiply, 2)\nprint(double(5))\nprint(double(10))",
  "expected_output": "10\n20",
  "hints": [
    "inner(y) closes over both fn and x from the enclosing partial_apply scope",
    "double = partial_apply(multiply, 2) locks in x=2",
    "double(5) calls multiply(2, 5) = 10"
  ],
  "solution": "def multiply(x, y):\n    return x * y\n\ndef partial_apply(fn, x):\n    def inner(y):\n        return fn(x, y)\n    return inner\n\ndouble = partial_apply(multiply, 2)\nprint(double(5))\nprint(double(10))"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Closures & Scope';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: LEGB Scope Demo', 'code', 15, 7, 'python',
$json${
  "instructions": "Trace the LEGB rule in action. outer() has its own x = \"outer\" and an inner() that uses nonlocal to modify it. The global x = \"global\" should remain unchanged.\n\nExpected output:\ninner\nglobal",
  "starter_code": "x = 'global'\n\ndef outer():\n    x = 'outer'\n    def inner():\n        nonlocal x\n        x = 'inner'\n    inner()\n    print(x)   # what does outer's x hold now?\n\nouter()\nprint(x)       # what does the global x hold?",
  "expected_output": "inner\nglobal",
  "hints": [
    "nonlocal x inside inner() refers to outer()'s x, not the global x",
    "After inner() runs, outer's x is 'inner' — inner() changed the enclosing x",
    "The global x = 'global' is untouched because nonlocal skips global scope"
  ],
  "solution": "x = 'global'\n\ndef outer():\n    x = 'outer'\n    def inner():\n        nonlocal x\n        x = 'inner'\n    inner()\n    print(x)\n\nouter()\nprint(x)"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Closures & Scope';


-- ============================================================
-- TOPIC 15: Closures & Scope — JavaScript lessons (order 8-11)
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Closure Factory', 'code', 15, 8, 'javascript',
$json${
  "instructions": "Write a function makeAdder(x) that returns an arrow function (y) => x + y. Create add5 = makeAdder(5) and print add5(3) and add5(10).\n\nExpected output:\n8\n15",
  "starter_code": "function makeAdder(x) {\n  return (y) => x + y;\n}\n\nconst add5 = makeAdder(5);\nconsole.log(add5(3));\nconsole.log(add5(10));",
  "expected_output": "8\n15",
  "hints": [
    "The returned arrow function closes over x from makeAdder's scope",
    "add5 = makeAdder(5) locks in x=5; calling add5(3) returns 5+3=8",
    "This is a factory function — each call to makeAdder creates a fresh closure"
  ],
  "solution": "function makeAdder(x) {\n  return (y) => x + y;\n}\n\nconst add5 = makeAdder(5);\nconsole.log(add5(3));\nconsole.log(add5(10));"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Closures & Scope';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Fix Loop Closure Bug', 'code', 20, 9, 'javascript',
$json${
  "instructions": "Using let in a for loop creates a new binding per iteration, fixing the classic closure loop bug. Create an array of 3 functions — each returning its own index — using let.\n\nExpected output:\n0\n1\n2",
  "starter_code": "const funcs = [];\nfor (let i = 0; i < 3; i++) {\n  funcs.push(() => i);\n}\n\nfuncs.forEach(f => console.log(f()));",
  "expected_output": "0\n1\n2",
  "hints": [
    "let creates a new binding for each loop iteration — each closure gets its own i",
    "With var instead of let, all closures would share the same i (which ends at 3)",
    "The code is already correct — run it to see how let fixes the bug"
  ],
  "solution": "const funcs = [];\nfor (let i = 0; i < 3; i++) {\n  funcs.push(() => i);\n}\n\nfuncs.forEach(f => console.log(f()));"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Closures & Scope';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Module Pattern', 'code', 20, 10, 'javascript',
$json${
  "instructions": "Use an IIFE (Immediately Invoked Function Expression) to create a counter module with private state. The module exposes increment() and get() methods but keeps _count private.\n\nCall increment() 3 times, then print the count.\n\nExpected output:\n3",
  "starter_code": "const counter = (() => {\n  let _count = 0;\n  return {\n    increment: () => ++_count,\n    get: () => _count,\n  };\n})();\n\ncounter.increment();\ncounter.increment();\ncounter.increment();\nconsole.log(counter.get());",
  "expected_output": "3",
  "hints": [
    "The IIFE (() => { ... })() runs immediately and returns the public API object",
    "_count lives in the closure — it is inaccessible from outside but remembered by increment and get",
    "counter._count is undefined outside; only counter.get() reveals the value"
  ],
  "solution": "const counter = (() => {\n  let _count = 0;\n  return {\n    increment: () => ++_count,\n    get: () => _count,\n  };\n})();\n\ncounter.increment();\ncounter.increment();\ncounter.increment();\nconsole.log(counter.get());"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Closures & Scope';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Memoize', 'code', 25, 11, 'javascript',
$json${
  "instructions": "Write a memoize(fn) function that caches results keyed by JSON.stringify(args). Memoize an add(a, b) function. Call add(2, 3) twice and add(4, 5) once, printing each result.\n\nExpected output:\n5\n5\n9",
  "starter_code": "function memoize(fn) {\n  const cache = {};\n  return function(...args) {\n    const key = JSON.stringify(args);\n    if (key in cache) {\n      return cache[key];\n    }\n    cache[key] = fn(...args);\n    return cache[key];\n  };\n}\n\nconst add = memoize((a, b) => a + b);\nconsole.log(add(2, 3));\nconsole.log(add(2, 3));\nconsole.log(add(4, 5));",
  "expected_output": "5\n5\n9",
  "hints": [
    "JSON.stringify([2, 3]) produces the string '[2,3]' — a stable cache key for any args",
    "The cache object lives in the closure — it persists between calls",
    "The second add(2, 3) hits the cache and returns 5 without recomputing"
  ],
  "solution": "function memoize(fn) {\n  const cache = {};\n  return function(...args) {\n    const key = JSON.stringify(args);\n    if (key in cache) {\n      return cache[key];\n    }\n    cache[key] = fn(...args);\n    return cache[key];\n  };\n}\n\nconst add = memoize((a, b) => a + b);\nconsole.log(add(2, 3));\nconsole.log(add(2, 3));\nconsole.log(add(4, 5));"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Closures & Scope';


-- ============================================================
-- TOPIC 15: Closures & Scope — TypeScript lessons (order 12-14)
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Typed Closure', 'code', 15, 12, 'typescript',
$json${
  "instructions": "Define a type Incrementer = (step?: number) => number. Write makeCounter(initial: number): Incrementer that uses a closure to track state. Each call increments by 1. Create a counter starting at 0 and call it 3 times, printing the last result.\n\nExpected output:\n3",
  "starter_code": "type Incrementer = () => number;\n\nfunction makeCounter(initial: number): Incrementer {\n  let count = initial;\n  return () => {\n    count += 1;\n    return count;\n  };\n}\n\nconst c = makeCounter(0);\nc();\nc();\nconsole.log(c());",
  "expected_output": "3",
  "hints": [
    "The returned function closes over count from makeCounter's scope",
    "count += 1 modifies the enclosing variable — TypeScript allows this in closures",
    "After 3 calls starting from 0, count is 3"
  ],
  "solution": "type Incrementer = () => number;\n\nfunction makeCounter(initial: number): Incrementer {\n  let count = initial;\n  return () => {\n    count += 1;\n    return count;\n  };\n}\n\nconst c = makeCounter(0);\nc();\nc();\nconsole.log(c());"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Closures & Scope';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Generic Memoize', 'code', 25, 13, 'typescript',
$json${
  "instructions": "Write a generic memoize function. Memoize a squaring function (x: number) => x * x. Call it with 5 twice — both should return 25.\n\nExpected output:\n25\n25",
  "starter_code": "function memoize<T extends (...args: unknown[]) => unknown>(fn: T): T {\n  const cache = new Map<string, unknown>();\n  return ((...args: unknown[]) => {\n    const key = JSON.stringify(args);\n    if (cache.has(key)) return cache.get(key);\n    const result = fn(...args);\n    cache.set(key, result);\n    return result;\n  }) as T;\n}\n\nconst square = memoize((x: number) => x * x);\nconsole.log(square(5));\nconsole.log(square(5));",
  "expected_output": "25\n25",
  "hints": [
    "The generic constraint T extends (...args: unknown[]) => unknown ensures fn is callable",
    "JSON.stringify(args) creates a stable string key from the arguments array",
    "The second call hits the Map cache and returns 25 without recomputing"
  ],
  "solution": "function memoize<T extends (...args: unknown[]) => unknown>(fn: T): T {\n  const cache = new Map<string, unknown>();\n  return ((...args: unknown[]) => {\n    const key = JSON.stringify(args);\n    if (cache.has(key)) return cache.get(key);\n    const result = fn(...args);\n    cache.set(key, result);\n    return result;\n  }) as T;\n}\n\nconst square = memoize((x: number) => x * x);\nconsole.log(square(5));\nconsole.log(square(5));"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Closures & Scope';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Private State with Closure', 'code', 25, 14, 'typescript',
$json${
  "instructions": "Define interface Stack<T> with push(item: T): void, pop(): T | undefined, and size(): number. Implement createStack<T>(): Stack<T> using a closure array for private storage. Push 3 items, pop 1, print the size.\n\nExpected output:\n2",
  "starter_code": "interface Stack<T> {\n  push(item: T): void;\n  pop(): T | undefined;\n  size(): number;\n}\n\nfunction createStack<T>(): Stack<T> {\n  const items: T[] = [];\n  return {\n    push: (item) => { items.push(item); },\n    pop: () => items.pop(),\n    size: () => items.length,\n  };\n}\n\nconst s = createStack<number>();\ns.push(1);\ns.push(2);\ns.push(3);\ns.pop();\nconsole.log(s.size());",
  "expected_output": "2",
  "hints": [
    "items is private — callers cannot access it directly, only through push/pop/size",
    "All three methods close over the same items array",
    "After pushing 3 and popping 1, size() returns 2"
  ],
  "solution": "interface Stack<T> {\n  push(item: T): void;\n  pop(): T | undefined;\n  size(): number;\n}\n\nfunction createStack<T>(): Stack<T> {\n  const items: T[] = [];\n  return {\n    push: (item) => { items.push(item); },\n    pop: () => items.pop(),\n    size: () => items.length,\n  };\n}\n\nconst s = createStack<number>();\ns.push(1);\ns.push(2);\ns.push(3);\ns.pop();\nconsole.log(s.size());"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Closures & Scope';


-- ============================================================
-- TOPIC 16: Async/Await & Promises — Theory (order 1)
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Understanding Async/Await & Promises', 'theory', 10, 1, NULL,
$json${
  "sections": [
    {
      "type": "text",
      "content": "## Why Asynchronous Programming?\n\nMost programs need to wait for things: reading a file, querying a database, fetching data from an API. If your program simply **blocked** during those waits, it would freeze — a web server could only handle one request at a time, a UI would hang.\n\n**Asynchronous programming** lets your program start a long operation and move on to other work while waiting for the result. When the operation completes, it notifies your code.\n\nThis is one of the most fundamental and initially confusing topics in modern programming — mastering it unlocks the ability to write responsive, high-performance applications."
    },
    {
      "type": "text",
      "content": "## The JavaScript Event Loop\n\nJavaScript is **single-threaded** — it can only run one thing at a time. Yet it handles thousands of concurrent network requests efficiently. How?\n\nThe **event loop** is the secret:\n\n1. Your synchronous code runs to completion on the **call stack**.\n2. Async operations (network calls, timers) are handed off to the browser/Node.js runtime.\n3. When an async operation completes, a **callback** is placed in the **task queue**.\n4. Once the call stack is empty, the event loop picks the next task from the queue and runs it.\n\nThis means async code never truly runs \"at the same time\" — it runs between other tasks."
    },
    {
      "type": "text",
      "content": "## Callbacks: The Original Async Pattern\n\nThe first approach to async JavaScript was callbacks — you pass a function to be called when the async work is done:\n\n```javascript\nfs.readFile('data.txt', 'utf8', (err, data) => {\n  if (err) { console.error(err); return; }\n  processData(data, (err, result) => {\n    if (err) { console.error(err); return; }\n    saveResult(result, (err) => {\n      if (err) { console.error(err); return; }\n      console.log('Done!');\n    });\n  });\n});\n```\n\nThis is **callback hell** — deeply nested error handling and logic. It is hard to read, hard to debug, and easy to forget an error check."
    },
    {
      "type": "text",
      "content": "## Promises: A Better Way\n\nA **Promise** is an object representing the eventual result of an async operation. It has three states:\n\n- **Pending**: the operation hasn't finished yet\n- **Fulfilled**: the operation completed successfully, with a value\n- **Rejected**: the operation failed, with a reason (error)\n\nPromises let you chain operations with `.then()` and handle errors in one place with `.catch()`:"
    },
    {
      "type": "code",
      "language": "javascript",
      "content": "fetch('/api/users')\n  .then(response => response.json())\n  .then(users => {\n    console.log('Got users:', users.length);\n    return users[0];\n  })\n  .then(user => console.log('First user:', user.name))\n  .catch(err => console.error('Something went wrong:', err))\n  .finally(() => console.log('Request finished'));"
    },
    {
      "type": "text",
      "content": "## async/await: Promises Made Readable\n\n`async/await` is **syntactic sugar over Promises** — it does not create new concurrency, it just makes async code look and feel like synchronous code.\n\n- `async function` declares a function that always returns a Promise.\n- `await` pauses execution of the current async function until the awaited Promise resolves.\n- Control returns to the caller (and the event loop can run other tasks) while waiting.\n- You can use `try/catch` for error handling, just like synchronous code."
    },
    {
      "type": "code",
      "language": "javascript",
      "content": "// Without async/await (Promise chaining)\nfunction getUserName(id) {\n  return fetch(`/api/users/${id}`)\n    .then(r => r.json())\n    .then(user => user.name);\n}\n\n// With async/await (same logic, more readable)\nasync function getUserName(id) {\n  const response = await fetch(`/api/users/${id}`);\n  const user = await response.json();\n  return user.name;   // automatically wrapped in Promise.resolve()\n}"
    },
    {
      "type": "text",
      "content": "## Error Handling with async/await\n\nWith async/await, you handle errors using standard `try/catch` blocks. This is one of the key advantages over Promise chaining, where you need `.catch()` at the end of every chain."
    },
    {
      "type": "code",
      "language": "javascript",
      "content": "async function loadData(url) {\n  try {\n    const response = await fetch(url);\n    if (!response.ok) {\n      throw new Error(`HTTP error: ${response.status}`);\n    }\n    const data = await response.json();\n    return data;\n  } catch (err) {\n    console.error('Failed to load data:', err.message);\n    return null;\n  }\n}"
    },
    {
      "type": "text",
      "content": "## Running Promises in Parallel\n\n`await` executes Promises **sequentially** by default — the second `await` does not start until the first resolves. For independent operations, use `Promise.all()` to run them in parallel:\n\n```javascript\n// Sequential — takes 3 seconds if each takes 1 second\nconst a = await fetchA();\nconst b = await fetchB();\nconst c = await fetchC();\n\n// Parallel — takes ~1 second total\nconst [a, b, c] = await Promise.all([fetchA(), fetchB(), fetchC()]);\n```\n\nOther useful combinators:\n- **`Promise.race()`** — resolves/rejects with the first promise that settles\n- **`Promise.allSettled()`** — waits for all, gives both fulfilled and rejected results\n- **`Promise.any()`** — resolves with the first fulfilled promise"
    },
    {
      "type": "text",
      "content": "## Python's asyncio\n\nPython has its own async system: `asyncio`. The concepts are identical to JavaScript — there is an event loop, coroutines, and awaitables — but the syntax and mechanics differ slightly:\n\n- `async def` defines a **coroutine function**\n- `await` pauses the coroutine and yields control to the event loop\n- `asyncio.run(coro)` starts the event loop and runs a coroutine\n- `asyncio.gather(*coros)` runs multiple coroutines concurrently (like `Promise.all()`)"
    },
    {
      "type": "code",
      "language": "python",
      "content": "import asyncio\n\nasync def fetch_data(name):\n    await asyncio.sleep(0)  # simulate I/O\n    return f'data from {name}'\n\nasync def main():\n    # Sequential\n    r1 = await fetch_data('api-1')\n    r2 = await fetch_data('api-2')\n\n    # Parallel with gather\n    r1, r2 = await asyncio.gather(\n        fetch_data('api-1'),\n        fetch_data('api-2'),\n    )\n    print(r1, r2)\n\nasyncio.run(main())"
    },
    {
      "type": "text",
      "content": "## Common Async Pitfalls\n\n**Forgetting await** is the most common mistake. Without `await`, you get back a Promise object, not the resolved value:\n\n```javascript\n// Bug: result is a Promise, not a number\nconst result = fetchScore();\nconsole.log(result); // Promise { <pending> }\n\n// Fix:\nconst result = await fetchScore();\nconsole.log(result); // 42\n```\n\n**Unhandled promise rejections** can silently fail in older Node versions. Always handle errors with `.catch()` or `try/catch`.\n\n**Blocking the event loop** with synchronous heavy computation prevents other tasks from running. For CPU-intensive work, use Worker Threads (Node.js) or `asyncio.run_in_executor()` (Python)."
    }
  ],
  "summary": "Async programming lets your code start operations and move on without waiting. JavaScript's event loop + Promises + async/await handle this elegantly without threads. Python's asyncio provides the same model. Use Promise.all() / asyncio.gather() for parallel operations. Always handle errors with try/catch and never forget await."
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Async/Await & Promises';


-- ============================================================
-- TOPIC 16: Async/Await & Promises — Quiz (order 2)
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Async/Await & Promises Quiz', 'quiz', 10, 2, NULL,
$json${
  "question": "What does the await keyword do in an async function?",
  "options": [
    "Pauses the execution of the async function until the Promise resolves, without blocking the event loop",
    "Blocks the entire program until the operation completes",
    "Creates a new thread for concurrent execution",
    "Converts a callback function into a Promise"
  ],
  "correct_index": 0,
  "explanation": "await pauses only the current async function and returns control to the event loop — so other code can continue running. This is not blocking: the program stays responsive while the awaited operation completes. It is purely syntactic sugar over Promise.then()."
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Async/Await & Promises';


-- ============================================================
-- TOPIC 16: Async/Await & Promises — Python lessons (order 3-7)
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: Async Basics with asyncio', 'code', 15, 3, 'python',
$json${
  "instructions": "Write an async function greet(name) that returns f\"Hello, {name}!\". In an async main() function, await the result and print it. Run main with asyncio.run().\n\nExpected output:\nHello, Alice!",
  "starter_code": "import asyncio\n\nasync def greet(name):\n    return f'Hello, {name}!'\n\nasync def main():\n    msg = await greet('Alice')\n    print(msg)\n\nasyncio.run(main())",
  "expected_output": "Hello, Alice!",
  "hints": [
    "async def creates a coroutine — calling greet() returns a coroutine object, not the string",
    "await greet('Alice') runs the coroutine and gives you the string",
    "asyncio.run(main()) starts the event loop and runs main() to completion"
  ],
  "solution": "import asyncio\n\nasync def greet(name):\n    return f'Hello, {name}!'\n\nasync def main():\n    msg = await greet('Alice')\n    print(msg)\n\nasyncio.run(main())"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Async/Await & Promises';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: asyncio.gather', 'code', 20, 4, 'python',
$json${
  "instructions": "Write an async function fetch(id) that awaits asyncio.sleep(0) and returns f\"data-{id}\". Use asyncio.gather to run fetch(1), fetch(2), fetch(3) concurrently, then print each result.\n\nExpected output:\ndata-1\ndata-2\ndata-3",
  "starter_code": "import asyncio\n\nasync def fetch(id):\n    await asyncio.sleep(0)\n    return f'data-{id}'\n\nasync def main():\n    results = await asyncio.gather(fetch(1), fetch(2), fetch(3))\n    for r in results:\n        print(r)\n\nasyncio.run(main())",
  "expected_output": "data-1\ndata-2\ndata-3",
  "hints": [
    "asyncio.gather() takes multiple coroutines and runs them concurrently",
    "It returns a list of results in the same order as the input coroutines",
    "asyncio.sleep(0) yields control to the event loop without blocking"
  ],
  "solution": "import asyncio\n\nasync def fetch(id):\n    await asyncio.sleep(0)\n    return f'data-{id}'\n\nasync def main():\n    results = await asyncio.gather(fetch(1), fetch(2), fetch(3))\n    for r in results:\n        print(r)\n\nasyncio.run(main())"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Async/Await & Promises';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: Async Error Handling', 'code', 20, 5, 'python',
$json${
  "instructions": "Write an async function that raises ValueError(\"not found\"). In main(), wrap it in a try/except and print \"Error: not found\" when the error is caught.\n\nExpected output:\nError: not found",
  "starter_code": "import asyncio\n\nasync def find_item():\n    raise ValueError('not found')\n\nasync def main():\n    try:\n        await find_item()\n    except ValueError as e:\n        print(f'Error: {e}')\n\nasyncio.run(main())",
  "expected_output": "Error: not found",
  "hints": [
    "Errors raised inside async functions propagate through await to the caller",
    "try/except works the same with async/await as with synchronous code",
    "str(e) or f'{e}' gives you the error message"
  ],
  "solution": "import asyncio\n\nasync def find_item():\n    raise ValueError('not found')\n\nasync def main():\n    try:\n        await find_item()\n    except ValueError as e:\n        print(f'Error: {e}')\n\nasyncio.run(main())"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Async/Await & Promises';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: Async Generator', 'code', 20, 6, 'python',
$json${
  "instructions": "Write an async generator async_range(n) that yields 0, 1, ..., n-1. In main(), use async for to iterate and print each value.\n\nExpected output:\n0\n1\n2\n3\n4",
  "starter_code": "import asyncio\n\nasync def async_range(n):\n    for i in range(n):\n        yield i\n\nasync def main():\n    async for x in async_range(5):\n        print(x)\n\nasyncio.run(main())",
  "expected_output": "0\n1\n2\n3\n4",
  "hints": [
    "An async generator uses 'async def' combined with 'yield'",
    "async for is required to iterate over async generators",
    "This pattern is useful for streaming data from async sources"
  ],
  "solution": "import asyncio\n\nasync def async_range(n):\n    for i in range(n):\n        yield i\n\nasync def main():\n    async for x in async_range(5):\n        print(x)\n\nasyncio.run(main())"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Async/Await & Promises';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: Debug: Fix Missing await', 'code', 20, 7, 'python',
$json${
  "instructions": "The buggy code calls slow_function() without await. Fix it so result holds the actual return value, not a coroutine object.\n\nExpected output:\n42",
  "starter_code": "import asyncio\n\nasync def slow_function():\n    await asyncio.sleep(0)\n    return 42\n\nasync def main():\n    # Bug: missing await — result will be a coroutine object\n    # result = slow_function()\n\n    # Fix: add await\n    result = await slow_function()\n    print(result)\n\nasyncio.run(main())",
  "expected_output": "42",
  "hints": [
    "Without await, slow_function() returns a coroutine object, not 42",
    "Add 'await' before slow_function() to actually run it and get the return value",
    "Python will warn about a coroutine that was never awaited"
  ],
  "solution": "import asyncio\n\nasync def slow_function():\n    await asyncio.sleep(0)\n    return 42\n\nasync def main():\n    result = await slow_function()\n    print(result)\n\nasyncio.run(main())"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Async/Await & Promises';


-- ============================================================
-- TOPIC 16: Async/Await & Promises — JavaScript lessons (order 8-11)
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Promise Basics', 'code', 15, 8, 'javascript',
$json${
  "instructions": "Create a Promise that resolves with the value 42. Chain a .then() handler that logs the value.\n\nExpected output:\n42",
  "starter_code": "const p = new Promise((resolve) => resolve(42));\np.then(val => console.log(val));",
  "expected_output": "42",
  "hints": [
    "new Promise((resolve, reject) => ...) creates a Promise",
    "Calling resolve(value) puts the Promise in the fulfilled state with that value",
    ".then(val => ...) registers a callback that runs when the Promise fulfills"
  ],
  "solution": "const p = new Promise((resolve) => resolve(42));\np.then(val => console.log(val));"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Async/Await & Promises';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Async/Await', 'code', 15, 9, 'javascript',
$json${
  "instructions": "Write an async function double(x) that returns x * 2. Write async main() that awaits double(21) and logs the result. Call main().\n\nExpected output:\n42",
  "starter_code": "async function double(x) {\n  return x * 2;\n}\n\nasync function main() {\n  const result = await double(21);\n  console.log(result);\n}\n\nmain();",
  "expected_output": "42",
  "hints": [
    "async functions automatically wrap their return value in a Promise",
    "await double(21) pauses main() until the Promise from double() resolves",
    "21 * 2 = 42"
  ],
  "solution": "async function double(x) {\n  return x * 2;\n}\n\nasync function main() {\n  const result = await double(21);\n  console.log(result);\n}\n\nmain();"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Async/Await & Promises';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Promise.all', 'code', 20, 10, 'javascript',
$json${
  "instructions": "Create three resolved Promises with values \"a\", \"b\", \"c\". Use Promise.all() to wait for all three, then forEach to log each value.\n\nExpected output:\na\nb\nc",
  "starter_code": "const p1 = Promise.resolve('a');\nconst p2 = Promise.resolve('b');\nconst p3 = Promise.resolve('c');\n\nPromise.all([p1, p2, p3]).then(values => values.forEach(v => console.log(v)));",
  "expected_output": "a\nb\nc",
  "hints": [
    "Promise.all() takes an array of Promises and resolves with an array of values",
    "The values array preserves the order of input Promises: ['a', 'b', 'c']",
    "forEach(v => console.log(v)) prints each value on its own line"
  ],
  "solution": "const p1 = Promise.resolve('a');\nconst p2 = Promise.resolve('b');\nconst p3 = Promise.resolve('c');\n\nPromise.all([p1, p2, p3]).then(values => values.forEach(v => console.log(v)));"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Async/Await & Promises';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Async Error Handling', 'code', 20, 11, 'javascript',
$json${
  "instructions": "Write an async function riskyOp() that throws new Error(\"oops\"). In async main(), use try/catch to catch the error and log \"Caught: \" followed by the error message. Call main().\n\nExpected output:\nCaught: oops",
  "starter_code": "async function riskyOp() {\n  throw new Error('oops');\n}\n\nasync function main() {\n  try {\n    await riskyOp();\n  } catch (e) {\n    console.log('Caught:', e.message);\n  }\n}\n\nmain();",
  "expected_output": "Caught: oops",
  "hints": [
    "Errors thrown inside async functions become rejected Promises",
    "await inside try/catch converts the rejection into a thrown exception",
    "e.message gives you the error message string 'oops'"
  ],
  "solution": "async function riskyOp() {\n  throw new Error('oops');\n}\n\nasync function main() {\n  try {\n    await riskyOp();\n  } catch (e) {\n    console.log('Caught:', e.message);\n  }\n}\n\nmain();"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Async/Await & Promises';


-- ============================================================
-- TOPIC 16: Async/Await & Promises — TypeScript lessons (order 12-14)
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Typed Async Function', 'code', 15, 12, 'typescript',
$json${
  "instructions": "Write an async function fetchUser(id: number): Promise<{name: string; id: number}> that returns { id, name: \"Alice\" }. Await it in main and print the name.\n\nExpected output:\nAlice",
  "starter_code": "async function fetchUser(id: number): Promise<{ name: string; id: number }> {\n  return { id, name: 'Alice' };\n}\n\nasync function main() {\n  const user = await fetchUser(1);\n  console.log(user.name);\n}\n\nmain();",
  "expected_output": "Alice",
  "hints": [
    "Promise<T> is the return type of any async function — T is the resolved value type",
    "TypeScript knows user.name is a string because of the explicit return type",
    "await fetchUser(1) returns the resolved value { id: 1, name: 'Alice' }"
  ],
  "solution": "async function fetchUser(id: number): Promise<{ name: string; id: number }> {\n  return { id, name: 'Alice' };\n}\n\nasync function main() {\n  const user = await fetchUser(1);\n  console.log(user.name);\n}\n\nmain();"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Async/Await & Promises';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Promise.allSettled', 'code', 25, 13, 'typescript',
$json${
  "instructions": "Create three Promises: resolve(1), reject(\"err\"), resolve(3). Use Promise.allSettled() to get all results. For fulfilled results print the value; for rejected results print the reason.\n\nExpected output:\n1\nerr\n3",
  "starter_code": "const promises: Promise<number>[] = [\n  Promise.resolve(1),\n  Promise.reject('err'),\n  Promise.resolve(3),\n];\n\nPromise.allSettled(promises).then(results => {\n  results.forEach(r => {\n    if (r.status === 'fulfilled') {\n      console.log(r.value);\n    } else {\n      console.log(r.reason);\n    }\n  });\n});",
  "expected_output": "1\nerr\n3",
  "hints": [
    "Promise.allSettled() never rejects — it waits for all and reports each outcome",
    "Each result has status: 'fulfilled' | 'rejected'",
    "Fulfilled results have .value; rejected results have .reason"
  ],
  "solution": "const promises: Promise<number>[] = [\n  Promise.resolve(1),\n  Promise.reject('err'),\n  Promise.resolve(3),\n];\n\nPromise.allSettled(promises).then(results => {\n  results.forEach(r => {\n    if (r.status === 'fulfilled') {\n      console.log(r.value);\n    } else {\n      console.log(r.reason);\n    }\n  });\n});"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Async/Await & Promises';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Async Queue Processing', 'code', 20, 14, 'typescript',
$json${
  "instructions": "Write an async function processItem(item: number): Promise<string> that returns `processed-${item}`. Process items [1, 2, 3] sequentially using a for loop with await, printing each result.\n\nExpected output:\nprocessed-1\nprocessed-2\nprocessed-3",
  "starter_code": "async function processItem(item: number): Promise<string> {\n  return `processed-${item}`;\n}\n\nasync function main() {\n  const items = [1, 2, 3];\n  for (const item of items) {\n    const result = await processItem(item);\n    console.log(result);\n  }\n}\n\nmain();",
  "expected_output": "processed-1\nprocessed-2\nprocessed-3",
  "hints": [
    "await inside a for...of loop processes items one at a time, in order",
    "This is sequential processing — item 2 does not start until item 1 finishes",
    "For parallel processing you would use Promise.all(items.map(processItem))"
  ],
  "solution": "async function processItem(item: number): Promise<string> {\n  return `processed-${item}`;\n}\n\nasync function main() {\n  const items = [1, 2, 3];\n  for (const item of items) {\n    const result = await processItem(item);\n    console.log(result);\n  }\n}\n\nmain();"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Async/Await & Promises';


-- ============================================================
-- TOPIC 17: Modules & Imports — Theory (order 1)
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Understanding Modules & Imports', 'theory', 10, 1, NULL,
$json${
  "sections": [
    {
      "type": "text",
      "content": "## Why Modules?\n\nAs programs grow, keeping all code in one file becomes unmanageable. **Modules** solve this by breaking code into separate files, each with a clear responsibility. Modules provide:\n\n- **Organisation**: related code lives together\n- **Reuse**: a module can be imported by many files without copying code\n- **Namespacing**: functions in different modules can have the same name without conflicting\n- **Encapsulation**: modules can hide implementation details and only expose what is needed\n\nEvery serious programming language has a module system, and learning it unlocks the full ecosystem of libraries available to you."
    },
    {
      "type": "text",
      "content": "## Python Modules\n\nIn Python, **any `.py` file is a module**. You can import it and use its contents. There are three main import forms:\n\n```python\nimport math                    # import the module; access as math.sqrt()\nfrom math import sqrt          # import a specific name; access as sqrt()\nfrom math import sqrt, pi      # import multiple names\nimport math as m               # import with an alias; access as m.sqrt()\nfrom math import sqrt as sq    # import with an alias\n```\n\nThe `import module` form is generally preferred for clarity — it keeps the namespace visible and makes it obvious where a name comes from."
    },
    {
      "type": "code",
      "language": "python",
      "content": "import math\nfrom datetime import datetime\nimport json as j\n\nprint(math.pi)                           # 3.141592653589793\nprint(math.sqrt(16))                     # 4.0\nprint(datetime.now().year)               # current year\nprint(j.dumps({'key': 'value'}))         # {\"key\": \"value\"}"
    },
    {
      "type": "text",
      "content": "## Python Packages\n\nA **package** is a directory containing an `__init__.py` file (which can be empty). Packages let you organise modules into hierarchical namespaces:\n\n```\nmyapp/\n  __init__.py\n  models/\n    __init__.py\n    user.py\n    product.py\n  utils/\n    __init__.py\n    helpers.py\n```\n\nYou import from packages using dot notation:\n```python\nfrom myapp.models.user import User\nfrom myapp.utils import helpers\n```\n\nIn modern Python (3.3+), `__init__.py` is optional for **namespace packages**, but still recommended for regular packages."
    },
    {
      "type": "text",
      "content": "## Python Standard Library Overview\n\nPython ships with a rich standard library — hundreds of modules covering almost every common task:\n\n| Module | Purpose |\n|--------|----------|\n| `os` | Operating system interface (files, paths, processes) |\n| `sys` | Python runtime information (argv, path, version) |\n| `math` | Mathematical functions (sqrt, floor, pi, e) |\n| `datetime` | Date and time handling |\n| `json` | JSON encoding and decoding |\n| `random` | Random number generation |\n| `collections` | Specialised containers (Counter, defaultdict, deque) |\n| `re` | Regular expressions |\n| `pathlib` | Object-oriented file paths |\n| `itertools` | Functional iterator tools |\n| `functools` | Higher-order functions (partial, reduce, lru_cache) |\n\nKnowing the standard library saves enormous amounts of time — before writing utility code, check if Python already has it."
    },
    {
      "type": "text",
      "content": "## Third-Party Packages and pip\n\nBeyond the standard library, Python has hundreds of thousands of third-party packages on **PyPI** (the Python Package Index). You install them with `pip`:\n\n```bash\npip install requests          # HTTP for humans\npip install numpy             # numerical computing\npip install pandas            # data analysis\npip install fastapi           # web framework\n```\n\nBest practice: always use a **virtual environment** to isolate project dependencies:\n\n```bash\npython -m venv venv           # create virtual env\nsource venv/bin/activate      # activate (macOS/Linux)\nvenv\\Scripts\\activate         # activate (Windows)\npip install requests          # installs into the venv only\n```"
    },
    {
      "type": "text",
      "content": "## JavaScript ES Modules\n\nModern JavaScript uses **ES Modules** (ESM), which has explicit `import` and `export` syntax:\n\n```javascript\n// math.js — exporting\nexport function add(a, b) { return a + b; }\nexport const PI = 3.14159;\nexport default function multiply(a, b) { return a * b; }\n\n// main.js — importing\nimport multiply from './math.js';           // default import\nimport { add, PI } from './math.js';        // named imports\nimport { add as sum } from './math.js';     // aliased import\nimport * as math from './math.js';          // namespace import\n```"
    },
    {
      "type": "text",
      "content": "## Named vs Default Exports\n\n- **Named exports**: a module can have multiple, each identified by name. Importers must use the exact name (or alias it).\n- **Default export**: a module can have exactly one. Importers can name it anything.\n\nBest practice: prefer named exports for libraries (makes refactoring easier, enables tree shaking). Use default exports for the primary thing a module provides (e.g., a React component file)."
    },
    {
      "type": "text",
      "content": "## CommonJS vs ES Modules\n\nNode.js historically used **CommonJS** (CJS):\n\n```javascript\n// CommonJS (older Node.js)\nconst fs = require('fs');\nconst { join } = require('path');\nmodule.exports = { myFunction };\n```\n\nModern Node.js supports both. Use `\"type\": \"module\"` in `package.json` to default to ESM, or use `.mjs` extension for ES module files and `.cjs` for CommonJS files."
    },
    {
      "type": "text",
      "content": "## TypeScript Modules\n\nTypeScript uses the same ES module syntax as JavaScript, plus **type-only imports** that are erased at compile time:\n\n```typescript\nimport type { User } from './types';       // erased at compile time\nimport { createUser } from './factory';    // kept in output\n\n// Re-exporting\nexport { User } from './types';\nexport type { Config } from './config';\n```\n\nTypeScript also has **namespaces** — an older module-like feature — but modern TypeScript prefers ES module syntax."
    },
    {
      "type": "text",
      "content": "## Avoiding Circular Imports\n\nA circular import occurs when module A imports from B, and B imports from A. This creates a dependency loop. Python and Node.js handle it by partially executing modules, which can lead to `undefined` values at import time.\n\n**How to avoid it**: put shared types/utilities in a third module that neither A nor B imports from:\n\n```\n# Bad: A imports B, B imports A\n# Good: A imports shared, B imports shared — no cycle\n```\n\nIf you find yourself with a circular import, it is usually a sign that your module boundaries are wrong and some code should move."
    },
    {
      "type": "text",
      "content": "## Tree Shaking\n\n**Tree shaking** is a build-tool optimisation (used by Webpack, Rollup, Vite) that removes unused exports from the final bundle. It relies on ES module syntax — `import/export` are statically analysable, so the bundler knows at build time which exports are actually used.\n\nThis is one reason to avoid `export default { everything }` — if you put all functions in a default object, the bundler cannot tell which functions are used.\n\nWith named exports, importing only `{ add }` from a math library means `subtract`, `multiply` etc. are never included in your bundle."
    }
  ],
  "summary": "Modules break code into reusable, organised files. Python: import math / from math import sqrt. JavaScript: ES modules with import/export. Prefer named exports for tree shaking. Use pip + virtual environments for Python packages. Avoid circular imports by extracting shared code into separate modules."
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Modules & Imports';


-- ============================================================
-- TOPIC 17: Modules & Imports — Quiz (order 2)
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Modules & Imports Quiz', 'quiz', 10, 2, NULL,
$json${
  "question": "In Python, what is the difference between `import math` and `from math import sqrt`?",
  "options": [
    "The first imports the whole math module (access as math.sqrt()); the second imports only sqrt into the current namespace",
    "They are identical in behavior",
    "The second version is slower because it imports more code",
    "from ... import only works with built-in modules"
  ],
  "correct_index": 0,
  "explanation": "`import math` makes the module object available as math; you access functions via math.sqrt(). `from math import sqrt` pulls sqrt directly into your namespace so you call it as sqrt(). Both import the same underlying module — Python caches it. The second form does not import 'more code'; it is just a different way to access the same module."
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Modules & Imports';


-- ============================================================
-- TOPIC 17: Modules & Imports — Python lessons (order 3-7)
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: Standard Library Basics', 'code', 15, 3, 'python',
$json${
  "instructions": "Use the math module to print pi rounded to 4 decimal places, then print the square root of 16.\n\nExpected output:\n3.1416\n4.0",
  "starter_code": "import math\n\nprint(round(math.pi, 4))\nprint(math.sqrt(16))",
  "expected_output": "3.1416\n4.0",
  "hints": [
    "math.pi is the constant 3.141592653589793...",
    "round(value, ndigits) rounds to ndigits decimal places",
    "math.sqrt(16) returns 4.0 (a float)"
  ],
  "solution": "import math\n\nprint(round(math.pi, 4))\nprint(math.sqrt(16))"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Modules & Imports';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: collections Module', 'code', 20, 4, 'python',
$json${
  "instructions": "Use Counter from the collections module to count word frequencies in a sentence. Print the top 2 most common words as \"word: count\", sorted alphabetically.\n\nExpected output:\nfox: 2\nthe: 2",
  "starter_code": "from collections import Counter\n\nwords = 'the quick brown fox jumps over the lazy fox'.split()\nc = Counter(words)\n\nfor word, count in sorted(c.most_common(2)):\n    print(f'{word}: {count}')",
  "expected_output": "fox: 2\nthe: 2",
  "hints": [
    "Counter(iterable) counts occurrences of each element",
    "most_common(2) returns the 2 most frequent elements as [(word, count), ...]",
    "sorted() on the list sorts alphabetically by the first element (word)"
  ],
  "solution": "from collections import Counter\n\nwords = 'the quick brown fox jumps over the lazy fox'.split()\nc = Counter(words)\n\nfor word, count in sorted(c.most_common(2)):\n    print(f'{word}: {count}')"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Modules & Imports';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: datetime Module', 'code', 15, 5, 'python',
$json${
  "instructions": "Create a datetime object for 2024-01-15. Print it formatted as \"YYYY-MM-DD\". Then add 30 days with timedelta and print the new date in the same format.\n\nExpected output:\n2024-01-15\n2024-02-14",
  "starter_code": "from datetime import datetime, timedelta\n\nnow = datetime(2024, 1, 15)\nprint(now.strftime('%Y-%m-%d'))\n\nfuture = now + timedelta(days=30)\nprint(future.strftime('%Y-%m-%d'))",
  "expected_output": "2024-01-15\n2024-02-14",
  "hints": [
    "datetime(year, month, day) creates a datetime object",
    "strftime('%Y-%m-%d') formats it as 2024-01-15",
    "timedelta(days=30) creates a 30-day duration; adding it gives 2024-02-14"
  ],
  "solution": "from datetime import datetime, timedelta\n\nnow = datetime(2024, 1, 15)\nprint(now.strftime('%Y-%m-%d'))\n\nfuture = now + timedelta(days=30)\nprint(future.strftime('%Y-%m-%d'))"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Modules & Imports';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: __name__ == "__main__"', 'code', 15, 6, 'python',
$json${
  "instructions": "Write a module-style script with a greet(name) function and an if __name__ == '__main__' guard. The guard calls greet('World') and prints the result.\n\nExpected output:\nHello, World!",
  "starter_code": "def greet(name):\n    return f'Hello, {name}!'\n\nif __name__ == '__main__':\n    print(greet('World'))",
  "expected_output": "Hello, World!",
  "hints": [
    "__name__ is '__main__' when the file is run directly, not when imported",
    "This pattern lets a file act both as a reusable module and a runnable script",
    "greet('World') returns 'Hello, World!' which print() displays"
  ],
  "solution": "def greet(name):\n    return f'Hello, {name}!'\n\nif __name__ == '__main__':\n    print(greet('World'))"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Modules & Imports';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: Import Aliasing', 'code', 15, 7, 'python',
$json${
  "instructions": "Import json as j and math as m. Create a JSON string from a dict containing pi and e (with sort_keys=True), then print it.\n\nExpected output:\n{\"e\": 2.718281828459045, \"pi\": 3.141592653589793}",
  "starter_code": "import json as j\nimport math as m\n\ndata = j.dumps({'pi': m.pi, 'e': m.e}, sort_keys=True)\nprint(data)",
  "expected_output": "{\"e\": 2.718281828459045, \"pi\": 3.141592653589793}",
  "hints": [
    "import json as j makes json available as j throughout the file",
    "j.dumps() serialises a dict to a JSON string",
    "sort_keys=True ensures keys are alphabetically ordered: e before pi"
  ],
  "solution": "import json as j\nimport math as m\n\ndata = j.dumps({'pi': m.pi, 'e': m.e}, sort_keys=True)\nprint(data)"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Modules & Imports';


-- ============================================================
-- TOPIC 17: Modules & Imports — JavaScript lessons (order 8-11)
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Built-in Math Object', 'code', 15, 8, 'javascript',
$json${
  "instructions": "Destructure floor and sqrt from the Math object and use them to print the floor of the square root of 144.\n\nExpected output:\n12",
  "starter_code": "const { floor, sqrt } = Math;\nconsole.log(floor(sqrt(144)));",
  "expected_output": "12",
  "hints": [
    "Destructuring const { floor, sqrt } = Math pulls those functions out of the Math object",
    "sqrt(144) is 12.0 (a perfect square in this case)",
    "floor(12.0) is 12"
  ],
  "solution": "const { floor, sqrt } = Math;\nconsole.log(floor(sqrt(144)));"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Modules & Imports';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Destructuring Imports', 'code', 15, 9, 'javascript',
$json${
  "instructions": "Use array destructuring to split an array into its first element and the rest. Print the first element, then print the rest joined with commas.\n\nExpected output:\n1\n2,3,4,5",
  "starter_code": "const arr = [1, 2, 3, 4, 5];\nconst [first, ...rest] = arr;\nconsole.log(first);\nconsole.log(rest.join(','));",
  "expected_output": "1\n2,3,4,5",
  "hints": [
    "const [first, ...rest] = arr — first gets arr[0], rest gets the remaining elements",
    "The rest/spread operator ... collects remaining elements into an array",
    "rest.join(',') joins the array elements with commas: '2,3,4,5'"
  ],
  "solution": "const arr = [1, 2, 3, 4, 5];\nconst [first, ...rest] = arr;\nconsole.log(first);\nconsole.log(rest.join(','));"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Modules & Imports';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: JSON as a Data Format', 'code', 15, 10, 'javascript',
$json${
  "instructions": "Parse a JSON config string, then print the app name and version on one line, and the debug flag on the next.\n\nExpected output:\nCodeQuest v1.0\nDebug: false",
  "starter_code": "const config = JSON.parse('{\"name\":\"CodeQuest\",\"version\":\"1.0\",\"debug\":false}');\nconsole.log(`${config.name} v${config.version}`);\nconsole.log(`Debug: ${config.debug}`);",
  "expected_output": "CodeQuest v1.0\nDebug: false",
  "hints": [
    "JSON.parse() converts a JSON string into a JavaScript object",
    "Template literals `${expr}` interpolate values into a string",
    "config.debug is the boolean false; template literal coerces it to the string 'false'"
  ],
  "solution": "const config = JSON.parse('{\"name\":\"CodeQuest\",\"version\":\"1.0\",\"debug\":false}');\nconsole.log(`${config.name} v${config.version}`);\nconsole.log(`Debug: ${config.debug}`);"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Modules & Imports';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Dynamic Import Simulation', 'code', 20, 11, 'javascript',
$json${
  "instructions": "Simulate a dynamic module registry: a loadModule(name) function returns a module object from an internal map. Load the 'math' module and call its add(3, 4) method.\n\nExpected output:\n7",
  "starter_code": "function loadModule(name) {\n  const modules = {\n    math: { add: (a, b) => a + b },\n  };\n  return modules[name];\n}\n\nconst math = loadModule('math');\nconsole.log(math.add(3, 4));",
  "expected_output": "7",
  "hints": [
    "loadModule returns an object containing module exports",
    "This simulates how dynamic import() lets you load modules by name at runtime",
    "math.add(3, 4) calls the add function from the 'math' module: 3 + 4 = 7"
  ],
  "solution": "function loadModule(name) {\n  const modules = {\n    math: { add: (a, b) => a + b },\n  };\n  return modules[name];\n}\n\nconst math = loadModule('math');\nconsole.log(math.add(3, 4));"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Modules & Imports';


-- ============================================================
-- TOPIC 17: Modules & Imports — TypeScript lessons (order 12-14)
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Namespace', 'code', 20, 12, 'typescript',
$json${
  "instructions": "Define a namespace Utils with an exported clamp function that constrains a value between min and max. Print clamp(15, 0, 10) and clamp(-5, 0, 10).\n\nExpected output:\n10\n0",
  "starter_code": "namespace Utils {\n  export function clamp(val: number, min: number, max: number): number {\n    return Math.min(Math.max(val, min), max);\n  }\n}\n\nconsole.log(Utils.clamp(15, 0, 10));\nconsole.log(Utils.clamp(-5, 0, 10));",
  "expected_output": "10\n0",
  "hints": [
    "Math.max(val, min) ensures val is at least min",
    "Math.min(..., max) ensures the result is at most max",
    "clamp(15, 0, 10): Math.max(15,0)=15, Math.min(15,10)=10"
  ],
  "solution": "namespace Utils {\n  export function clamp(val: number, min: number, max: number): number {\n    return Math.min(Math.max(val, min), max);\n  }\n}\n\nconsole.log(Utils.clamp(15, 0, 10));\nconsole.log(Utils.clamp(-5, 0, 10));"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Modules & Imports';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Declaration Merging', 'code', 20, 13, 'typescript',
$json${
  "instructions": "Declare the same interface Config twice — first with host: string, then with port: number. TypeScript merges them. Create a Config object with both fields and print host:port.\n\nExpected output:\nlocalhost:3000",
  "starter_code": "interface Config { host: string; }\ninterface Config { port: number; }\n\nconst c: Config = { host: 'localhost', port: 3000 };\nconsole.log(`${c.host}:${c.port}`);",
  "expected_output": "localhost:3000",
  "hints": [
    "TypeScript merges multiple declarations of the same interface into one",
    "The merged Config requires both host and port",
    "Template literal `${c.host}:${c.port}` produces 'localhost:3000'"
  ],
  "solution": "interface Config { host: string; }\ninterface Config { port: number; }\n\nconst c: Config = { host: 'localhost', port: 3000 };\nconsole.log(`${c.host}:${c.port}`);"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Modules & Imports';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Re-export Pattern', 'code', 20, 14, 'typescript',
$json${
  "instructions": "Simulate a re-export pattern: create an api object with get and post methods that return formatted strings. Destructure them and call each.\n\nExpected output:\nGET /users\nPOST /users",
  "starter_code": "const api = {\n  get: (url: string) => `GET ${url}`,\n  post: (url: string) => `POST ${url}`,\n};\n\nconst { get, post } = api;\nconsole.log(get('/users'));\nconsole.log(post('/users'));",
  "expected_output": "GET /users\nPOST /users",
  "hints": [
    "Object destructuring const { get, post } = api pulls those methods out by name",
    "get and post are now standalone functions — TypeScript infers their types",
    "This mirrors how you would re-export and destructure named exports from a module"
  ],
  "solution": "const api = {\n  get: (url: string) => `GET ${url}`,\n  post: (url: string) => `POST ${url}`,\n};\n\nconst { get, post } = api;\nconsole.log(get('/users'));\nconsole.log(post('/users'));"
}$json$::jsonb
FROM public.topics t WHERE t.title = 'Modules & Imports';
