-- 017: JavaScript + TypeScript code lessons for Topics 12-14
-- Adds 3 JS (order_index 6-8) and 3 TS (order_index 9-11) lessons per topic

-- ============================================================
-- TOPIC 12: Generators & Iterators — JavaScript (order 6-8)
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Generator Basics', 'code', 20, 6, 'javascript',
$$
{
  "instructions": "Write a generator function counter(start, end) that yields numbers from start to end (inclusive). Use a for...of loop to collect the values into an array and print each one. Call counter(1, 5).",
  "starter_code": "function* counter(start, end) {\n  // yield each number from start to end\n}\n\nfor (const n of counter(1, 5)) {\n  console.log(n);\n}",
  "expected_output": "1\n2\n3\n4\n5",
  "hints": [
    "Use a for loop inside the generator: for (let i = start; i <= end; i++)",
    "Use the yield keyword to produce each value: yield i",
    "for...of automatically calls .next() until the generator is done"
  ],
  "solution": "function* counter(start, end) {\n  for (let i = start; i <= end; i++) {\n    yield i;\n  }\n}\n\nfor (const n of counter(1, 5)) {\n  console.log(n);\n}"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Generators & Iterators';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Infinite Generator', 'code', 20, 7, 'javascript',
$$
{
  "instructions": "Write a generator function naturals() that yields 1, 2, 3, ... forever. Use a for...of loop with a break statement to print the first 4 values.",
  "starter_code": "function* naturals() {\n  // yield 1, 2, 3, ... forever\n}\n\nlet count = 0;\nfor (const n of naturals()) {\n  console.log(n);\n  count++;\n  if (count === 4) break;\n}",
  "expected_output": "1\n2\n3\n4",
  "hints": [
    "Use a while (true) loop inside the generator",
    "Start with let n = 1 and yield n, then increment n++",
    "The for...of loop with break safely stops the infinite generator"
  ],
  "solution": "function* naturals() {\n  let n = 1;\n  while (true) {\n    yield n++;\n  }\n}\n\nlet count = 0;\nfor (const n of naturals()) {\n  console.log(n);\n  count++;\n  if (count === 4) break;\n}"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Generators & Iterators';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Generator with yield*', 'code', 25, 8, 'javascript',
$$
{
  "instructions": "Write a generator function range(n) that yields 0 to n-1. Write a second generator doubled(gen) that takes an iterable and yields each value multiplied by 2. Print all values from doubled(range(4)).",
  "starter_code": "function* range(n) {\n  // yield 0, 1, 2, ..., n-1\n}\n\nfunction* doubled(iter) {\n  // yield each value from iter multiplied by 2\n}\n\nfor (const n of doubled(range(4))) {\n  console.log(n);\n}",
  "expected_output": "0\n2\n4\n6",
  "hints": [
    "range(n): use a for loop from 0 to n-1 and yield each i",
    "doubled(iter): use for...of over iter and yield value * 2",
    "You can also use yield* range(n) inside doubled to delegate to another generator"
  ],
  "solution": "function* range(n) {\n  for (let i = 0; i < n; i++) {\n    yield i;\n  }\n}\n\nfunction* doubled(iter) {\n  for (const v of iter) {\n    yield v * 2;\n  }\n}\n\nfor (const n of doubled(range(4))) {\n  console.log(n);\n}"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Generators & Iterators';

-- ============================================================
-- TOPIC 12: Generators & Iterators — TypeScript (order 9-11)
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Typed Generator', 'code', 20, 9, 'typescript',
$$
{
  "instructions": "Write a typed generator function fibonacci() with return type Generator<number> that yields the Fibonacci sequence (starting 0, 1, 1, 2, ...). Print the first 7 values.",
  "starter_code": "function* fibonacci(): Generator<number> {\n  // yield Fibonacci numbers: 0, 1, 1, 2, 3, 5, 8, ...\n}\n\nlet count = 0;\nfor (const n of fibonacci()) {\n  console.log(n);\n  count++;\n  if (count === 7) break;\n}",
  "expected_output": "0\n1\n1\n2\n3\n5\n8",
  "hints": [
    "Start with two variables: let a = 0, b = 1",
    "In a while (true) loop: yield a, then update [a, b] = [b, a + b]",
    "The return type Generator<number> tells TypeScript this yields numbers"
  ],
  "solution": "function* fibonacci(): Generator<number> {\n  let a = 0, b = 1;\n  while (true) {\n    yield a;\n    [a, b] = [b, a + b];\n  }\n}\n\nlet count = 0;\nfor (const n of fibonacci()) {\n  console.log(n);\n  count++;\n  if (count === 7) break;\n}"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Generators & Iterators';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Iterator Protocol', 'code', 20, 10, 'typescript',
$$
{
  "instructions": "Create a class Range that implements Iterable<number>. Its constructor takes (start: number, end: number). Implement [Symbol.iterator]() so a for...of loop over new Range(1, 4) prints 1, 2, 3, 4.",
  "starter_code": "class Range implements Iterable<number> {\n  constructor(private start: number, private end: number) {}\n\n  [Symbol.iterator](): Iterator<number> {\n    // return an iterator object with a next() method\n  }\n}\n\nfor (const n of new Range(1, 4)) {\n  console.log(n);\n}",
  "expected_output": "1\n2\n3\n4",
  "hints": [
    "The iterator needs a current counter variable starting at this.start",
    "next() should return { value: current++, done: false } while current <= end",
    "When done, return { value: undefined as any, done: true }"
  ],
  "solution": "class Range implements Iterable<number> {\n  constructor(private start: number, private end: number) {}\n\n  [Symbol.iterator](): Iterator<number> {\n    let current = this.start;\n    const end = this.end;\n    return {\n      next(): IteratorResult<number> {\n        if (current <= end) {\n          return { value: current++, done: false };\n        }\n        return { value: undefined as any, done: true };\n      }\n    };\n  }\n}\n\nfor (const n of new Range(1, 4)) {\n  console.log(n);\n}"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Generators & Iterators';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Lazy Map Generator', 'code', 25, 11, 'typescript',
$$
{
  "instructions": "Write a generic generator function map<T, U>(iter: Iterable<T>, fn: (x: T) => U): Generator<U> that lazily maps a function over an iterable. Apply it to [1, 2, 3, 4, 5] squaring each element. Print only the first 3 results.",
  "starter_code": "function* map<T, U>(iter: Iterable<T>, fn: (x: T) => U): Generator<U> {\n  // yield fn(x) for each x in iter\n}\n\nconst squares = map([1, 2, 3, 4, 5], (x: number) => x * x);\nlet count = 0;\nfor (const n of squares) {\n  console.log(n);\n  count++;\n  if (count === 3) break;\n}",
  "expected_output": "1\n4\n9",
  "hints": [
    "Use for...of inside the generator to iterate over iter",
    "yield fn(item) for each item",
    "The generic types <T, U> let TypeScript infer input and output types automatically"
  ],
  "solution": "function* map<T, U>(iter: Iterable<T>, fn: (x: T) => U): Generator<U> {\n  for (const item of iter) {\n    yield fn(item);\n  }\n}\n\nconst squares = map([1, 2, 3, 4, 5], (x: number) => x * x);\nlet count = 0;\nfor (const n of squares) {\n  console.log(n);\n  count++;\n  if (count === 3) break;\n}"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Generators & Iterators';

-- ============================================================
-- TOPIC 13: Decorators — JavaScript HOF pattern (order 6-8)
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Function Wrapper (Decorator Pattern)', 'code', 20, 6, 'javascript',
$$
{
  "instructions": "Write a higher-order function withLogging(fn) that wraps any function and prints \"Calling: \" + fn.name before calling it and returning the result. Wrap the function add(a, b) that returns a + b. Call wrappedAdd(3, 4) and print the log line and the result.",
  "starter_code": "function add(a, b) {\n  return a + b;\n}\n\nfunction withLogging(fn) {\n  // return a wrapper function that logs fn.name then calls fn\n}\n\nconst wrappedAdd = withLogging(add);\nconsole.log(wrappedAdd(3, 4));",
  "expected_output": "Calling: add\n7",
  "hints": [
    "Return a function (...args) => { ... } from withLogging",
    "Inside the wrapper, print 'Calling: ' + fn.name before calling fn",
    "Call fn(...args) to forward the arguments, then return the result"
  ],
  "solution": "function add(a, b) {\n  return a + b;\n}\n\nfunction withLogging(fn) {\n  return function(...args) {\n    console.log('Calling: ' + fn.name);\n    return fn(...args);\n  };\n}\n\nconst wrappedAdd = withLogging(add);\nconsole.log(wrappedAdd(3, 4));"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Decorators';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Memoization Decorator', 'code', 20, 7, 'javascript',
$$
{
  "instructions": "Write a higher-order function memoize(fn) that caches results keyed by the first argument. Wrap function square(n) { return n * n }. Call memoizedSquare(5) twice and print both results.",
  "starter_code": "function square(n) {\n  return n * n;\n}\n\nfunction memoize(fn) {\n  // cache results and return wrapper\n}\n\nconst memoizedSquare = memoize(square);\nconsole.log(memoizedSquare(5));\nconsole.log(memoizedSquare(5));",
  "expected_output": "25\n25",
  "hints": [
    "Create a cache object or Map inside memoize: const cache = new Map()",
    "In the wrapper, check if cache.has(arg) and return cache.get(arg) if so",
    "Otherwise compute fn(arg), store it with cache.set(arg, result), then return it"
  ],
  "solution": "function square(n) {\n  return n * n;\n}\n\nfunction memoize(fn) {\n  const cache = new Map();\n  return function(arg) {\n    if (cache.has(arg)) {\n      return cache.get(arg);\n    }\n    const result = fn(arg);\n    cache.set(arg, result);\n    return result;\n  };\n}\n\nconst memoizedSquare = memoize(square);\nconsole.log(memoizedSquare(5));\nconsole.log(memoizedSquare(5));"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Decorators';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Retry Decorator', 'code', 25, 8, 'javascript',
$$
{
  "instructions": "Write a higher-order function withRetry(fn, times) that calls fn and retries up to times attempts if it throws. Create a function that throws on the first 2 calls but succeeds on the 3rd, printing \"Success\". Wrap it with withRetry(fn, 3) and call it.",
  "starter_code": "function withRetry(fn, times) {\n  // try calling fn up to 'times' times, return result on success\n}\n\nlet attempts = 0;\nfunction flakyOp() {\n  attempts++;\n  if (attempts < 3) throw new Error('Not yet');\n  return 'Success';\n}\n\nconst result = withRetry(flakyOp, 3);\nconsole.log(result);",
  "expected_output": "Success",
  "hints": [
    "Use a for loop: for (let i = 0; i < times; i++)",
    "Wrap the fn() call in try/catch; on success return the result",
    "If you exhaust all retries, throw the last caught error"
  ],
  "solution": "function withRetry(fn, times) {\n  let lastError;\n  for (let i = 0; i < times; i++) {\n    try {\n      return fn();\n    } catch (e) {\n      lastError = e;\n    }\n  }\n  throw lastError;\n}\n\nlet attempts = 0;\nfunction flakyOp() {\n  attempts++;\n  if (attempts < 3) throw new Error('Not yet');\n  return 'Success';\n}\n\nconst result = withRetry(flakyOp, 3);\nconsole.log(result);"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Decorators';

-- ============================================================
-- TOPIC 13: Decorators — TypeScript HOF pattern (order 9-11)
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Typed Function Wrapper', 'code', 20, 9, 'typescript',
$$
{
  "instructions": "Write a function readonly<T extends object>(target: T): T that uses Object.freeze() to make an object immutable. Define interface Config { url: string; port: number }. Freeze a config object with url 'http://localhost' and port 3000. Print url and port.",
  "starter_code": "interface Config {\n  url: string;\n  port: number;\n}\n\nfunction readonly<T extends object>(target: T): T {\n  // freeze and return target\n}\n\nconst config = readonly<Config>({ url: 'http://localhost', port: 3000 });\nconsole.log(config.url);\nconsole.log(config.port);",
  "expected_output": "http://localhost\n3000",
  "hints": [
    "Object.freeze(target) prevents modifications to an object",
    "Return the frozen object: return Object.freeze(target)",
    "The generic <T extends object> ensures the function only accepts objects"
  ],
  "solution": "interface Config {\n  url: string;\n  port: number;\n}\n\nfunction readonly<T extends object>(target: T): T {\n  return Object.freeze(target);\n}\n\nconst config = readonly<Config>({ url: 'http://localhost', port: 3000 });\nconsole.log(config.url);\nconsole.log(config.port);"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Decorators';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Typed Memoize', 'code', 20, 10, 'typescript',
$$
{
  "instructions": "Write a typed higher-order function memoize<T, R>(fn: (arg: T) => R): (arg: T) => R that caches results using a Map. Memoize a function (n: number) => n * n. Call it with 6 twice and print both results.",
  "starter_code": "function memoize<T, R>(fn: (arg: T) => R): (arg: T) => R {\n  // use a Map to cache results\n}\n\nconst square = memoize((n: number) => n * n);\nconsole.log(square(6));\nconsole.log(square(6));",
  "expected_output": "36\n36",
  "hints": [
    "Create const cache = new Map<T, R>() inside memoize",
    "Return (arg: T) => { ... } that checks cache.has(arg) first",
    "If not cached, compute fn(arg), cache it with cache.set(arg, result), return it"
  ],
  "solution": "function memoize<T, R>(fn: (arg: T) => R): (arg: T) => R {\n  const cache = new Map<T, R>();\n  return (arg: T): R => {\n    if (cache.has(arg)) {\n      return cache.get(arg) as R;\n    }\n    const result = fn(arg);\n    cache.set(arg, result);\n    return result;\n  };\n}\n\nconst square = memoize((n: number) => n * n);\nconsole.log(square(6));\nconsole.log(square(6));"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Decorators';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Method Decorator as HOF', 'code', 25, 11, 'typescript',
$$
{
  "instructions": "Write a function logged<T extends unknown[]>(fn: (...args: T) => unknown, name: string) that prints \"Calling \" + name before calling fn and returns the result. Wrap multiply(a: number, b: number): number. Call logged(multiply, 'multiply')(4, 5) and print the result.",
  "starter_code": "function multiply(a: number, b: number): number {\n  return a * b;\n}\n\nfunction logged<T extends unknown[]>(fn: (...args: T) => unknown, name: string) {\n  // return a wrapper that logs and calls fn\n}\n\nconst result = logged(multiply, 'multiply')(4, 5);\nconsole.log(result);",
  "expected_output": "Calling multiply\n20",
  "hints": [
    "Return (...args: T) => { ... } from logged",
    "Inside the wrapper, console.log('Calling ' + name) then call fn(...args)",
    "Return the result of fn(...args) so the caller gets the value"
  ],
  "solution": "function multiply(a: number, b: number): number {\n  return a * b;\n}\n\nfunction logged<T extends unknown[]>(fn: (...args: T) => unknown, name: string) {\n  return (...args: T) => {\n    console.log('Calling ' + name);\n    return fn(...args);\n  };\n}\n\nconst result = logged(multiply, 'multiply')(4, 5);\nconsole.log(result);"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Decorators';

-- ============================================================
-- TOPIC 14: Regular Expressions — JavaScript (order 6-8)
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Regex Basics', 'code', 20, 6, 'javascript',
$$
{
  "instructions": "Use a regex to test whether a string is a valid email address. Test \"user@example.com\" (should be true) and \"notanemail\" (should be false). Print true then false.",
  "starter_code": "const emailRegex = /^[\\w.+-]+@[\\w-]+\\.[\\w.]+$/;\n\nconsole.log(emailRegex.test('user@example.com'));\nconsole.log(emailRegex.test('notanemail'));",
  "expected_output": "true\nfalse",
  "hints": [
    "Use regex.test(string) which returns true or false",
    "An email pattern needs: local part, @, domain, dot, TLD",
    "The ^ and $ anchors ensure the entire string must match the pattern"
  ],
  "solution": "const emailRegex = /^[\\w.+-]+@[\\w-]+\\.[\\w.]+$/;\n\nconsole.log(emailRegex.test('user@example.com'));\nconsole.log(emailRegex.test('notanemail'));"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Regular Expressions';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Regex Extract', 'code', 20, 7, 'javascript',
$$
{
  "instructions": "Extract all numbers from the string \"I have 3 cats and 12 dogs and 1 bird\" using a regex with the global flag. Print them joined by a comma.",
  "starter_code": "const text = 'I have 3 cats and 12 dogs and 1 bird';\n\n// Extract all numbers and join with comma\nconst numbers = text.match(/\\d+/g);\nconsole.log(numbers.join(','));",
  "expected_output": "3,12,1",
  "hints": [
    "Use String.match() with a global regex: /\\d+/g",
    "\\d+ matches one or more consecutive digits",
    "match() returns an array of strings; use .join(',') to format"
  ],
  "solution": "const text = 'I have 3 cats and 12 dogs and 1 bird';\n\nconst numbers = text.match(/\\d+/g);\nconsole.log(numbers.join(','));"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Regular Expressions';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Regex Replace', 'code', 25, 8, 'javascript',
$$
{
  "instructions": "Replace all vowels (a, e, i, o, u — upper and lower case) in the string \"Hello World\" with \"*\". Use the regex /[aeiou]/gi and String.replace(). Print the result.",
  "starter_code": "const str = 'Hello World';\n\n// Replace all vowels with '*'\nconst result = str.replace(/[aeiou]/gi, '*');\nconsole.log(result);",
  "expected_output": "H*ll* W*rld",
  "hints": [
    "Character class [aeiou] matches any single vowel",
    "The g flag replaces all matches (not just the first); i makes it case-insensitive",
    "str.replace(regex, '*') substitutes each match with the string '*'"
  ],
  "solution": "const str = 'Hello World';\n\nconst result = str.replace(/[aeiou]/gi, '*');\nconsole.log(result);"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Regular Expressions';

-- ============================================================
-- TOPIC 14: Regular Expressions — TypeScript (order 9-11)
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Regex Validation Function', 'code', 20, 9, 'typescript',
$$
{
  "instructions": "Write a function isValidEmail(email: string): boolean using a regex to validate email addresses. Test it with \"alice@example.com\" (true) and \"bad-email\" (false). Print both results.",
  "starter_code": "function isValidEmail(email: string): boolean {\n  // use a regex to validate\n}\n\nconsole.log(isValidEmail('alice@example.com'));\nconsole.log(isValidEmail('bad-email'));",
  "expected_output": "true\nfalse",
  "hints": [
    "Use /^[\\w.+-]+@[\\w-]+\\.[\\w.]+$/.test(email)",
    "The return type boolean matches what .test() returns",
    "^ and $ anchor the match to the full string so partial matches don't pass"
  ],
  "solution": "function isValidEmail(email: string): boolean {\n  return /^[\\w.+-]+@[\\w-]+\\.[\\w.]+$/.test(email);\n}\n\nconsole.log(isValidEmail('alice@example.com'));\nconsole.log(isValidEmail('bad-email'));"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Regular Expressions';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Extract Groups', 'code', 20, 10, 'typescript',
$$
{
  "instructions": "Write a function that extracts the year, month, and day from the date string \"2024-01-15\" using regex capture groups /(\\d{4})-(\\d{2})-(\\d{2})/. Print year, month, and day on separate lines.",
  "starter_code": "const dateStr = '2024-01-15';\nconst pattern = /(\\d{4})-(\\d{2})-(\\d{2})/;\n\nconst match = dateStr.match(pattern);\nif (match) {\n  const [, year, month, day] = match;\n  console.log(year);\n  console.log(month);\n  console.log(day);\n}",
  "expected_output": "2024\n01\n15",
  "hints": [
    "String.match(regex) returns an array: [fullMatch, group1, group2, group3]",
    "Destructure with const [, year, month, day] = match to skip the full match",
    "Each (\\d{2}) or (\\d{4}) is a capture group — matched substrings appear in order"
  ],
  "solution": "const dateStr = '2024-01-15';\nconst pattern = /(\\d{4})-(\\d{2})-(\\d{2})/;\n\nconst match = dateStr.match(pattern);\nif (match) {\n  const [, year, month, day] = match;\n  console.log(year);\n  console.log(month);\n  console.log(day);\n}"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Regular Expressions';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Replace with Function', 'code', 25, 11, 'typescript',
$$
{
  "instructions": "Given the string \"hello world foo\", use String.replace() with a regex and a callback function to capitalize the first letter of each word. Print the result.",
  "starter_code": "const str = 'hello world foo';\n\nconst result = str.replace(/\\b\\w/g, (char: string) => char.toUpperCase());\nconsole.log(result);",
  "expected_output": "Hello World Foo",
  "hints": [
    "\\b is a word boundary and \\w matches a word character — together \\b\\w matches the first letter of each word",
    "The g flag applies the replacement to every word, not just the first",
    "The callback receives the matched character and returns its uppercase version"
  ],
  "solution": "const str = 'hello world foo';\n\nconst result = str.replace(/\\b\\w/g, (char: string) => char.toUpperCase());\nconsole.log(result);"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Regular Expressions';
