-- Migration 023: Add 2 more quiz lessons per topic (order_index 18 and 19)
-- 17 topics × 2 quizzes = 34 INSERT statements

-- ============================================================
-- Topic: Variables
-- ============================================================

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language)
VALUES (
  (SELECT id FROM topics WHERE title = 'Variables'),
  'Variables: Naming Rules Quiz',
  'quiz',
  $json${
    "question": "Which of the following is NOT a valid Python variable name?",
    "options": ["my_var", "_private", "2fast", "camelCase"],
    "correct_index": 2,
    "explanation": "Variable names cannot start with a digit in Python. They must start with a letter or underscore."
  }$json$::jsonb,
  10,
  18,
  NULL
);

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language)
VALUES (
  (SELECT id FROM topics WHERE title = 'Variables'),
  'Variables: Assignment & Rebinding Quiz',
  'quiz',
  $json${
    "question": "What is the output of: `a = b = c = 10; b = 20; print(a, b, c)`?",
    "options": ["10 20 10", "20 20 20", "10 10 10", "Error"],
    "correct_index": 0,
    "explanation": "In Python, `a = b = c = 10` makes all three point to the integer 10. When `b = 20`, only b is rebound — integers are immutable, so a and c still point to 10."
  }$json$::jsonb,
  10,
  19,
  NULL
);

-- ============================================================
-- Topic: Data Types
-- ============================================================

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language)
VALUES (
  (SELECT id FROM topics WHERE title = 'Data Types'),
  'Data Types: Type Conversion Quiz',
  'quiz',
  $json${
    "question": "What does `type(1 + 2.0)` return in Python?",
    "options": ["int", "float", "number", "TypeError"],
    "correct_index": 1,
    "explanation": "When you add an int and a float, Python automatically promotes the result to float — this is called implicit type conversion."
  }$json$::jsonb,
  10,
  18,
  NULL
);

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language)
VALUES (
  (SELECT id FROM topics WHERE title = 'Data Types'),
  'Data Types: JavaScript Quirks Quiz',
  'quiz',
  $json${
    "question": "What is `typeof null` in JavaScript?",
    "options": ["\"null\"", "\"undefined\"", "\"object\"", "\"boolean\""],
    "correct_index": 2,
    "explanation": "This is a famous JavaScript quirk: `typeof null === 'object'` even though null is not an object. It's a legacy bug from JavaScript's first version that was never fixed for compatibility reasons."
  }$json$::jsonb,
  10,
  19,
  NULL
);

-- ============================================================
-- Topic: Conditionals
-- ============================================================

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language)
VALUES (
  (SELECT id FROM topics WHERE title = 'Conditionals'),
  'Conditionals: Falsy Values Quiz',
  'quiz',
  $json${
    "question": "In Python, which values are falsy? (choose the most complete answer)",
    "options": ["Only False and None", "False, None, 0, '', [], {}", "Only False", "All variables that are not True"],
    "correct_index": 1,
    "explanation": "Python's falsy values include: False, None, 0, 0.0, '' (empty string), [] (empty list), {} (empty dict), () (empty tuple), and set(). Everything else is truthy."
  }$json$::jsonb,
  10,
  18,
  NULL
);

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language)
VALUES (
  (SELECT id FROM topics WHERE title = 'Conditionals'),
  'Conditionals: Nullish Coalescing Quiz',
  'quiz',
  $json${
    "question": "What does the `??` operator do in JavaScript?",
    "options": ["Returns the right side if the left is null or undefined", "Checks if both sides are equal", "Returns the right side if the left is falsy (0, '', false, null, undefined)", "Throws an error if the left side is null"],
    "correct_index": 0,
    "explanation": "The nullish coalescing operator `??` only short-circuits on null and undefined — unlike `||` which treats 0, '', and false as falsy. Use `??` when you want to allow 0 or empty string as valid values."
  }$json$::jsonb,
  10,
  19,
  NULL
);

-- ============================================================
-- Topic: Loops
-- ============================================================

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language)
VALUES (
  (SELECT id FROM topics WHERE title = 'Loops'),
  'Loops: Variable Scope Quiz',
  'quiz',
  $json${
    "question": "What is the output of this Python code? `for i in range(3): pass` followed by `print(i)`",
    "options": ["Nothing is printed", "0\n1\n2", "2", "NameError: i is not defined"],
    "correct_index": 2,
    "explanation": "In Python, loop variables persist after the loop ends. The final value of i is 2 (the last value from range(3)). This is different from many other languages where loop variables are block-scoped."
  }$json$::jsonb,
  10,
  18,
  NULL
);

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language)
VALUES (
  (SELECT id FROM topics WHERE title = 'Loops'),
  'Loops: For vs While Quiz',
  'quiz',
  $json${
    "question": "When should you use a `while` loop instead of a `for` loop?",
    "options": ["When you know exactly how many iterations you need", "When iterating over a collection", "When the number of iterations depends on a condition that changes during execution", "while loops are always faster than for loops"],
    "correct_index": 2,
    "explanation": "Use `while` when you don't know the iteration count upfront — e.g., reading input until the user types 'quit', retrying a network request until it succeeds, or game loops. Use `for` when iterating over a known sequence."
  }$json$::jsonb,
  10,
  19,
  NULL
);

-- ============================================================
-- Topic: Functions
-- ============================================================

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language)
VALUES (
  (SELECT id FROM topics WHERE title = 'Functions'),
  'Functions: Pure Functions Quiz',
  'quiz',
  $json${
    "question": "What is a pure function?",
    "options": ["A function with no parameters", "A function that always returns the same output for the same input and has no side effects", "A function written in functional programming style", "A function that uses only built-in Python types"],
    "correct_index": 1,
    "explanation": "A pure function: (1) always returns the same result for the same arguments, (2) has no side effects (doesn't modify external state, write to files, print, etc.). Pure functions are easier to test and reason about."
  }$json$::jsonb,
  10,
  18,
  NULL
);

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language)
VALUES (
  (SELECT id FROM topics WHERE title = 'Functions'),
  'Functions: Mutable Default Arguments Quiz',
  'quiz',
  $json${
    "question": "What does this Python code print? `def f(x=[]): x.append(1); return x` called three times as `print(f(), f(), f())`",
    "options": ["[1] [1] [1]", "[1] [1, 1] [1, 1, 1]", "Error", "[1, 1, 1] [1, 1, 1] [1, 1, 1]"],
    "correct_index": 1,
    "explanation": "This is Python's infamous mutable default argument bug. The default value `x=[]` is created ONCE when the function is defined, not on each call. So the same list is reused across all calls. Always use `x=None` and set `x = []` inside the function body."
  }$json$::jsonb,
  10,
  19,
  NULL
);

-- ============================================================
-- Topic: Arrays & Lists
-- ============================================================

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language)
VALUES (
  (SELECT id FROM topics WHERE title = 'Arrays & Lists'),
  'Arrays & Lists: Time Complexity Quiz',
  'quiz',
  $json${
    "question": "What is the time complexity of accessing an element by index in a Python list?",
    "options": ["O(n)", "O(log n)", "O(1)", "O(n²)"],
    "correct_index": 2,
    "explanation": "Python lists are backed by dynamic arrays, which store elements in contiguous memory. Index access is O(1) — constant time regardless of list size. This is different from linked lists where access is O(n)."
  }$json$::jsonb,
  10,
  18,
  NULL
);

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language)
VALUES (
  (SELECT id FROM topics WHERE title = 'Arrays & Lists'),
  'Arrays & Lists: Slice Notation Quiz',
  'quiz',
  $json${
    "question": "What does `[1, 2, 3][::-1]` return in Python?",
    "options": ["[1, 2, 3]", "[3, 2, 1]", "Error", "[]"],
    "correct_index": 1,
    "explanation": "Slice notation `[start:stop:step]` with step=-1 reverses the list. `[::-1]` means 'from end to start, step -1'. This creates a new reversed list without modifying the original."
  }$json$::jsonb,
  10,
  19,
  NULL
);

-- ============================================================
-- Topic: Objects & Dicts
-- ============================================================

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language)
VALUES (
  (SELECT id FROM topics WHERE title = 'Objects & Dicts'),
  'Objects & Dicts: Hash Map Complexity Quiz',
  'quiz',
  $json${
    "question": "What is the average time complexity of a dict lookup in Python?",
    "options": ["O(n)", "O(log n)", "O(1)", "O(n²)"],
    "correct_index": 2,
    "explanation": "Python dicts are hash maps. Hashing the key and computing the bucket index takes constant time. In the worst case (many hash collisions), it degrades to O(n), but this is extremely rare in practice."
  }$json$::jsonb,
  10,
  18,
  NULL
);

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language)
VALUES (
  (SELECT id FROM topics WHERE title = 'Objects & Dicts'),
  'Objects & Dicts: Property Access Quiz',
  'quiz',
  $json${
    "question": "In JavaScript, what is the difference between `obj.key` and `obj['key']`?",
    "options": ["There is no difference — they are identical", "`obj.key` only works if key is a valid JS identifier; `obj['key']` works with any string including spaces and reserved words", "`obj['key']` is always faster", "`obj.key` creates a copy of the value"],
    "correct_index": 1,
    "explanation": "Dot notation only works when the key is a valid JS identifier (no spaces, doesn't start with a digit, not a reserved word). Bracket notation `obj['key']` works with any string, and also lets you use variables: `obj[dynamicKey]`."
  }$json$::jsonb,
  10,
  19,
  NULL
);

-- ============================================================
-- Topic: Object-Oriented Programming
-- ============================================================

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language)
VALUES (
  (SELECT id FROM topics WHERE title = 'Object-Oriented Programming'),
  'OOP: super().__init__() Quiz',
  'quiz',
  $json${
    "question": "What is the purpose of `super().__init__()` in a Python subclass?",
    "options": ["It creates a copy of the parent class", "It calls the parent class's __init__ to initialize inherited attributes", "It makes the subclass private", "It prevents the parent class from being instantiated"],
    "correct_index": 1,
    "explanation": "When a subclass defines __init__, it overrides the parent's. Calling `super().__init__()` explicitly runs the parent's initialization code, ensuring the inherited attributes are properly set up before the subclass adds its own."
  }$json$::jsonb,
  10,
  18,
  NULL
);

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language)
VALUES (
  (SELECT id FROM topics WHERE title = 'Object-Oriented Programming'),
  'OOP: isinstance() vs type() Quiz',
  'quiz',
  $json${
    "question": "What is the difference between `isinstance()` and `type()` for type checking in Python?",
    "options": ["`isinstance(x, T)` returns True if x is T or any subclass of T; `type(x) == T` only matches exactly T", "They are identical", "`type()` is faster", "`isinstance()` can only check built-in types"],
    "correct_index": 0,
    "explanation": "Prefer `isinstance()` for type checking because it respects inheritance. If `Dog` extends `Animal`, then `isinstance(dog, Animal)` is True but `type(dog) == Animal` is False. This follows the Liskov Substitution Principle."
  }$json$::jsonb,
  10,
  19,
  NULL
);

-- ============================================================
-- Topic: Error Handling
-- ============================================================

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language)
VALUES (
  (SELECT id FROM topics WHERE title = 'Error Handling'),
  'Error Handling: finally Block Quiz',
  'quiz',
  $json${
    "question": "When does the `finally` block execute in a try/except/finally statement?",
    "options": ["Only when no exception is raised", "Only when an exception is raised", "Always — whether an exception was raised or not, even if there is a return statement", "Only when the except block runs"],
    "correct_index": 2,
    "explanation": "`finally` ALWAYS runs — after try succeeds, after except handles an error, or even after a return or break. This makes it ideal for cleanup code like closing files or database connections."
  }$json$::jsonb,
  10,
  18,
  NULL
);

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language)
VALUES (
  (SELECT id FROM topics WHERE title = 'Error Handling'),
  'Error Handling: Fail Fast Principle Quiz',
  'quiz',
  $json${
    "question": "What is the 'fail fast' principle in error handling?",
    "options": ["Always use try/catch to prevent any errors from reaching the user", "Detect errors as early as possible and raise exceptions immediately rather than letting invalid state propagate", "Retry failed operations automatically", "Log all errors without raising exceptions"],
    "correct_index": 1,
    "explanation": "Fail fast means: validate inputs immediately and raise exceptions early when something is wrong. This prevents invalid data from corrupting state deeper in the system and makes debugging easier since the error location is close to the root cause."
  }$json$::jsonb,
  10,
  19,
  NULL
);

-- ============================================================
-- Topic: APIs
-- ============================================================

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language)
VALUES (
  (SELECT id FROM topics WHERE title = 'APIs'),
  'APIs: HTTP Methods Quiz',
  'quiz',
  $json${
    "question": "What HTTP method should be used to partially update a resource (e.g., change only a user's email)?",
    "options": ["GET", "POST", "PUT", "PATCH"],
    "correct_index": 3,
    "explanation": "PATCH is used for partial updates — sending only the fields to change. PUT replaces the entire resource. POST creates new resources. GET retrieves data. Using PATCH is more efficient as you don't need to send the full object."
  }$json$::jsonb,
  10,
  18,
  NULL
);

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language)
VALUES (
  (SELECT id FROM topics WHERE title = 'APIs'),
  'APIs: Status Codes Quiz',
  'quiz',
  $json${
    "question": "A server returns status code 429. What does this mean?",
    "options": ["The resource was not found", "The request was unauthorized", "Too Many Requests — the client is being rate-limited", "The server had an internal error"],
    "correct_index": 2,
    "explanation": "429 Too Many Requests means the client has sent too many requests in a given time period. The server is rate-limiting you. You should wait (often the response includes a Retry-After header) before retrying."
  }$json$::jsonb,
  10,
  19,
  NULL
);

-- ============================================================
-- Topic: Algorithms & Data Structures
-- ============================================================

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language)
VALUES (
  (SELECT id FROM topics WHERE title = 'Algorithms & Data Structures'),
  'Algorithms: Hash Map vs Sorted Array Quiz',
  'quiz',
  $json${
    "question": "What is the key advantage of a hash map over a sorted array for lookups?",
    "options": ["Hash maps use less memory", "Hash map lookup is O(1) average vs O(log n) for binary search on a sorted array", "Hash maps support range queries", "Sorted arrays can't store duplicate values"],
    "correct_index": 1,
    "explanation": "Hash maps offer O(1) average-case lookup by computing the key's hash directly. A sorted array requires O(log n) binary search. However, sorted arrays support range queries (find all elements between X and Y), which hash maps cannot do efficiently."
  }$json$::jsonb,
  10,
  18,
  NULL
);

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language)
VALUES (
  (SELECT id FROM topics WHERE title = 'Algorithms & Data Structures'),
  'Data Structures: Stack vs Queue Quiz',
  'quiz',
  $json${
    "question": "What is the difference between a stack and a queue?",
    "options": ["A stack is LIFO (last-in, first-out); a queue is FIFO (first-in, first-out)", "A stack is FIFO; a queue is LIFO", "A stack can only store numbers; a queue stores any type", "They are identical data structures"],
    "correct_index": 0,
    "explanation": "Stack = LIFO: the last item added is the first removed (like a stack of plates). Used for: undo history, function call stack, bracket matching. Queue = FIFO: the first item added is the first removed (like a waiting line). Used for: task queues, BFS traversal, message buffers."
  }$json$::jsonb,
  10,
  19,
  NULL
);

-- ============================================================
-- Topic: Generators & Iterators
-- ============================================================

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language)
VALUES (
  (SELECT id FROM topics WHERE title = 'Generators & Iterators'),
  'Generators: Memory Efficiency Quiz',
  'quiz',
  $json${
    "question": "What is the key memory advantage of generators over lists?",
    "options": ["Generators are always faster to iterate", "Generators produce values one at a time (lazy evaluation), using O(1) memory vs O(n) for a list", "Generators can store more items than lists", "Generators support random access by index"],
    "correct_index": 1,
    "explanation": "A generator only holds one value in memory at a time. A list materializes all values upfront. For example, `range(1_000_000)` in Python 3 is a generator-like object using ~50 bytes, while `list(range(1_000_000))` uses ~8 MB. This matters when processing large datasets."
  }$json$::jsonb,
  10,
  18,
  NULL
);

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language)
VALUES (
  (SELECT id FROM topics WHERE title = 'Generators & Iterators'),
  'Generators: Exhaustion Quiz',
  'quiz',
  $json${
    "question": "What happens when a generator function returns (reaches the end or `return`) in Python?",
    "options": ["It resets and starts from the beginning", "It raises StopIteration, signaling that the iterator is exhausted", "It loops back to the first yield", "It raises GeneratorExit"],
    "correct_index": 1,
    "explanation": "When a generator is exhausted (no more `yield` statements), Python raises `StopIteration`. This is what makes `for` loops stop — Python's for loop calls `next()` repeatedly and catches `StopIteration` to know when to stop."
  }$json$::jsonb,
  10,
  19,
  NULL
);

-- ============================================================
-- Topic: Decorators
-- ============================================================

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language)
VALUES (
  (SELECT id FROM topics WHERE title = 'Decorators'),
  'Decorators: functools.wraps Quiz',
  'quiz',
  $json${
    "question": "What does `@functools.wraps(func)` do inside a decorator?",
    "options": ["It makes the decorator run faster", "It copies the original function's __name__, __doc__, and other metadata to the wrapper, so the decorated function appears unchanged", "It prevents the decorator from being applied twice", "It validates that func is actually a function"],
    "correct_index": 1,
    "explanation": "Without `@wraps(func)`, the decorated function's `__name__` would be 'wrapper' instead of the original name, and its docstring would be lost. `@wraps(func)` copies `__name__`, `__doc__`, `__module__`, etc. This matters for debugging, documentation, and other decorators."
  }$json$::jsonb,
  10,
  18,
  NULL
);

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language)
VALUES (
  (SELECT id FROM topics WHERE title = 'Decorators'),
  'Decorators: Built-in Decorators Quiz',
  'quiz',
  $json${
    "question": "Which built-in Python decorator makes a method callable on the class itself without creating an instance?",
    "options": ["@property", "@classmethod", "@staticmethod", "@abstractmethod"],
    "correct_index": 2,
    "explanation": "`@staticmethod` makes a method that belongs to the class namespace but doesn't receive `self` or `cls`. It's just a regular function namespaced inside a class. Use it for utility functions that logically belong with the class but don't need to access instance or class state."
  }$json$::jsonb,
  10,
  19,
  NULL
);

-- ============================================================
-- Topic: Regular Expressions
-- ============================================================

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language)
VALUES (
  (SELECT id FROM topics WHERE title = 'Regular Expressions'),
  'Regex: match() vs search() Quiz',
  'quiz',
  $json${
    "question": "What is the difference between `re.match()` and `re.search()` in Python?",
    "options": ["They are identical", "`re.match()` only matches at the beginning of the string; `re.search()` scans the entire string for a match anywhere", "`re.search()` is deprecated; always use `re.match()`", "`re.match()` is case-insensitive by default"],
    "correct_index": 1,
    "explanation": "`re.match()` anchors the pattern to the start of the string (like adding `^`). `re.search()` looks for the pattern anywhere in the string. For example, `re.match(r'world', 'hello world')` returns None, but `re.search(r'world', 'hello world')` finds it."
  }$json$::jsonb,
  10,
  18,
  NULL
);

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language)
VALUES (
  (SELECT id FROM topics WHERE title = 'Regular Expressions'),
  'Regex: Quantifiers Quiz',
  'quiz',
  $json${
    "question": "What does `?` mean in the regex pattern `colou?r`?",
    "options": ["The `u` must appear exactly once", "The `u` is optional (matches 0 or 1 times)", "The `u` must appear one or more times", "The `u` is captured in a group"],
    "correct_index": 1,
    "explanation": "`?` makes the preceding character or group optional — it matches 0 or 1 occurrences. So `colou?r` matches both 'color' (0 u's) and 'colour' (1 u). This is commonly used for optional characters or groups."
  }$json$::jsonb,
  10,
  19,
  NULL
);

-- ============================================================
-- Topic: Closures & Scope
-- ============================================================

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language)
VALUES (
  (SELECT id FROM topics WHERE title = 'Closures & Scope'),
  'Closures: What Is a Closure Quiz',
  'quiz',
  $json${
    "question": "What is a closure?",
    "options": ["A class that cannot be instantiated", "A function that captures and remembers variables from its enclosing scope, even after the outer function has returned", "A way to close a file or database connection", "A method that is private to its class"],
    "correct_index": 1,
    "explanation": "A closure is formed when an inner function references variables from its outer function's scope. Even after the outer function returns, the inner function still has access to those variables. This enables patterns like factory functions, private state, and partial application."
  }$json$::jsonb,
  10,
  18,
  NULL
);

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language)
VALUES (
  (SELECT id FROM topics WHERE title = 'Closures & Scope'),
  'Closures: nonlocal Keyword Quiz',
  'quiz',
  $json${
    "question": "In Python, what keyword must you use to reassign (not just read) an enclosing scope variable inside a nested function?",
    "options": ["global", "nonlocal", "outer", "free"],
    "correct_index": 1,
    "explanation": "`nonlocal` tells Python to look for the variable in the nearest enclosing scope (not global). Without it, Python would treat the assignment as creating a new local variable, shadowing the outer one. Use `global` to modify a module-level variable, `nonlocal` for enclosing function scope."
  }$json$::jsonb,
  10,
  19,
  NULL
);

-- ============================================================
-- Topic: Async/Await & Promises
-- ============================================================

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language)
VALUES (
  (SELECT id FROM topics WHERE title = 'Async/Await & Promises'),
  'Async: Event Loop Quiz',
  'quiz',
  $json${
    "question": "What is the JavaScript event loop?",
    "options": ["A special type of for loop for async code", "A mechanism that allows JavaScript (single-threaded) to handle async operations by processing a queue of callbacks after the current synchronous code finishes", "A loop that continuously polls for new network requests", "A built-in debugging tool"],
    "correct_index": 1,
    "explanation": "JavaScript is single-threaded but non-blocking. The event loop monitors the call stack and the callback queue. When async operations (timers, fetch, I/O) complete, their callbacks are pushed to the queue. The event loop moves them to the call stack when it's empty. This is why you can't block the main thread."
  }$json$::jsonb,
  10,
  18,
  NULL
);

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language)
VALUES (
  (SELECT id FROM topics WHERE title = 'Async/Await & Promises'),
  'Async: Promise.all vs Promise.allSettled Quiz',
  'quiz',
  $json${
    "question": "What is the difference between `Promise.all()` and `Promise.allSettled()`?",
    "options": ["They are identical", "`Promise.all()` rejects immediately if any promise rejects; `Promise.allSettled()` waits for all promises and returns all results including rejections", "`Promise.allSettled()` is faster", "`Promise.all()` can only take 2 promises"],
    "correct_index": 1,
    "explanation": "`Promise.all()` fails fast — if any promise rejects, the entire `.all()` rejects. `Promise.allSettled()` always waits for ALL promises and returns an array of `{status: 'fulfilled', value: ...}` or `{status: 'rejected', reason: ...}` objects. Use `allSettled` when you need results from all operations even if some fail."
  }$json$::jsonb,
  10,
  19,
  NULL
);

-- ============================================================
-- Topic: Modules & Imports
-- ============================================================

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language)
VALUES (
  (SELECT id FROM topics WHERE title = 'Modules & Imports'),
  'Modules: __name__ == __main__ Quiz',
  'quiz',
  $json${
    "question": "What is the purpose of `if __name__ == '__main__':` in Python?",
    "options": ["It makes the file private and unimportable", "It ensures the code block only runs when the file is executed directly, not when imported as a module", "It defines the main function of the program", "It improves performance by skipping module initialization"],
    "correct_index": 1,
    "explanation": "When Python imports a module, it sets `__name__` to the module's filename. When you run a file directly, `__name__` is set to '__main__'. So `if __name__ == '__main__':` guards code (tests, demos) that should only run when the file is executed directly — not when it's imported by another module."
  }$json$::jsonb,
  10,
  18,
  NULL
);

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language)
VALUES (
  (SELECT id FROM topics WHERE title = 'Modules & Imports'),
  'Modules: Named vs Default Exports Quiz',
  'quiz',
  $json${
    "question": "What is the difference between a named export and a default export in ES modules (JavaScript/TypeScript)?",
    "options": ["Named exports are faster", "A file can have multiple named exports but only one default export; named exports must be imported with their exact name (or aliased with `as`)", "Default exports are deprecated", "Named exports cannot be functions"],
    "correct_index": 1,
    "explanation": "A module can export many named exports (`export const foo = ...`) but only one default export (`export default ...`). Named imports use `{}`: `import { foo } from './mod'`. Default imports don't: `import whatever from './mod'` (you can name it anything). Most style guides prefer named exports for better tree-shaking and IDE autocomplete."
  }$json$::jsonb,
  10,
  19,
  NULL
);
