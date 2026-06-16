-- 021: Additional lessons for all 14 topics (2 per language per topic)

-- ============================================================
-- TOPIC: Variables
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: Multiple Assignment', 'code', 20, 12, 'python',
$$
{
  "instructions": "Assign three variables in one line using tuple unpacking: x, y, z = 10, 20, 30. Print each on its own line.",
  "starter_code": "# Assign x, y, z in one line",
  "expected_output": "10\n20\n30",
  "hints": ["Python allows assigning multiple variables at once", "Use comma separation on both sides"],
  "solution": "x, y, z = 10, 20, 30\nprint(x)\nprint(y)\nprint(z)"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Variables';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: Constants and f-strings', 'code', 20, 13, 'python',
$$
{
  "instructions": "Define MAX_SPEED = 120. Then define a speed variable = 95. Print: Speed: 95 km/h (limit: 120 km/h)",
  "starter_code": "# Define your constants and variables here",
  "expected_output": "Speed: 95 km/h (limit: 120 km/h)",
  "hints": ["Use ALL_CAPS for constants by convention", "f-strings use curly braces: f\"Speed: {speed} km/h\""],
  "solution": "MAX_SPEED = 120\nspeed = 95\nprint(f\"Speed: {speed} km/h (limit: {MAX_SPEED} km/h)\")"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Variables';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: const vs let', 'code', 20, 14, 'javascript',
$$
{
  "instructions": "Declare a const PI = 3.14159, a let radius = 5. Calculate area = PI * radius * radius. Print area rounded to 2 decimal places using toFixed(2).",
  "starter_code": "const PI = 3.14159;\nlet radius = 5;",
  "expected_output": "78.54",
  "hints": ["const values cannot be reassigned", "area = PI * radius * radius", "Use area.toFixed(2) to format"],
  "solution": "const PI = 3.14159;\nlet radius = 5;\nconst area = PI * radius * radius;\nconsole.log(area.toFixed(2));"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Variables';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Template Literals', 'code', 20, 15, 'javascript',
$$
{
  "instructions": "Create variables name = \"Alice\", age = 25. Use a template literal to print: Hello, Alice! You are 25 years old.",
  "starter_code": "const name = \"Alice\";\nconst age = 25;\n// Use a template literal to print the greeting",
  "expected_output": "Hello, Alice! You are 25 years old.",
  "hints": ["Template literals use backticks: `...`", "Embed variables with ${name}", "The format is: `Hello, ${name}! You are ${age} years old.`"],
  "solution": "const name = \"Alice\";\nconst age = 25;\nconsole.log(`Hello, ${name}! You are ${age} years old.`);"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Variables';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Type Aliases', 'code', 20, 16, 'typescript',
$$
{
  "instructions": "Define a type alias: type Point = { x: number; y: number }. Create a point p: Point = { x: 3, y: 4 }. Calculate distance = Math.sqrt(p.x*p.x + p.y*p.y). Print the distance.",
  "starter_code": "type Point = { x: number; y: number };\n// Create a Point at x=3, y=4 and calculate distance from origin",
  "expected_output": "5",
  "hints": ["type aliases define reusable type shapes", "Math.sqrt(3*3 + 4*4) = Math.sqrt(25) = 5", "Assign p: Point = { x: 3, y: 4 }"],
  "solution": "type Point = { x: number; y: number };\nconst p: Point = { x: 3, y: 4 };\nconst dist = Math.sqrt(p.x * p.x + p.y * p.y);\nconsole.log(dist);"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Variables';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Readonly Variables', 'code', 20, 17, 'typescript',
$$
{
  "instructions": "Create a readonly config object: const config = { host: 'localhost', port: 3000 } as const. Print: localhost:3000",
  "starter_code": "// Create config with 'as const' to make it readonly",
  "expected_output": "localhost:3000",
  "hints": ["as const makes all properties readonly", "Use a template literal to combine host and port", "console.log(`${config.host}:${config.port}`)"],
  "solution": "const config = { host: 'localhost', port: 3000 } as const;\nconsole.log(`${config.host}:${config.port}`);"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Variables';

-- ============================================================
-- TOPIC: Data Types
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: Check and Convert Types', 'code', 20, 12, 'python',
$$
{
  "instructions": "Create variables: a = \"42\", b = 3.14, c = True. Convert a to int and print \"42 int\". Convert b to int and print \"3 int\". Print c.",
  "starter_code": "a = \"42\"\nb = 3.14\nc = True\n# Convert and print each",
  "expected_output": "42 int\n3 int\nTrue",
  "hints": ["int(\"42\") converts the string to integer 42", "int(3.14) truncates to 3", "print(int(a), \"int\") prints them space-separated"],
  "solution": "a = \"42\"\nb = 3.14\nc = True\nprint(int(a), \"int\")\nprint(int(b), \"int\")\nprint(c)"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Data Types';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: String Methods', 'code', 20, 13, 'python',
$$
{
  "instructions": "Given s = \"  Hello, World!  \", strip whitespace, convert to lowercase, replace \"world\" with \"python\". Print the result.",
  "starter_code": "s = \"  Hello, World!  \"\n# Chain: strip, lower, replace",
  "expected_output": "hello, python!",
  "hints": ["Chain methods: s.strip().lower().replace(...)", "strip() removes leading/trailing whitespace", "replace(\"world\", \"python\") replaces the substring"],
  "solution": "s = \"  Hello, World!  \"\nresult = s.strip().lower().replace(\"world\", \"python\")\nprint(result)"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Data Types';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Type Coercion', 'code', 20, 14, 'javascript',
$$
{
  "instructions": "JavaScript coerces types in unexpected ways. Print \"5\" + 3 (string concatenation), then print Number(\"5\") + 3 (numeric addition).",
  "starter_code": "// String + number\nconsole.log(\"5\" + 3);\n// Number conversion + number\nconsole.log(Number(\"5\") + 3);",
  "expected_output": "53\n8",
  "hints": ["When a string is added to a number, JS converts the number to string", "Number(\"5\") explicitly converts the string to number 5", "5 + 3 = 8, \"5\" + 3 = \"53\""],
  "solution": "console.log(\"5\" + 3);\nconsole.log(Number(\"5\") + 3);"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Data Types';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Strict vs Loose Equality', 'code', 20, 15, 'javascript',
$$
{
  "instructions": "Test loose (==) vs strict (===) equality. Print: 0 == false, 0 === false, \"\" == false, null == undefined",
  "starter_code": "console.log(0 == false);\nconsole.log(0 === false);\nconsole.log(\"\" == false);\nconsole.log(null == undefined);",
  "expected_output": "true\nfalse\ntrue\ntrue",
  "hints": ["== performs type coercion before comparing", "=== checks both value and type — no coercion", "null == undefined is true with loose equality"],
  "solution": "console.log(0 == false);\nconsole.log(0 === false);\nconsole.log(\"\" == false);\nconsole.log(null == undefined);"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Data Types';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Literal Types', 'code', 20, 16, 'typescript',
$$
{
  "instructions": "Define a union literal type: type Direction = \"north\" | \"south\" | \"east\" | \"west\". Create a variable d: Direction = \"north\". Print it.",
  "starter_code": "type Direction = \"north\" | \"south\" | \"east\" | \"west\";\n// Declare d as Direction and print it",
  "expected_output": "north",
  "hints": ["Literal types restrict a variable to specific string values", "const d: Direction = \"north\"", "console.log(d)"],
  "solution": "type Direction = \"north\" | \"south\" | \"east\" | \"west\";\nconst d: Direction = \"north\";\nconsole.log(d);"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Data Types';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Type Assertions', 'code', 20, 17, 'typescript',
$$
{
  "instructions": "Declare const val: unknown = \"Hello TypeScript\". Use 'as string' to assert its type, then print its length.",
  "starter_code": "const val: unknown = \"Hello TypeScript\";\n// Assert val as string and print its length",
  "expected_output": "16",
  "hints": ["Type assertions use the 'as' keyword: val as string", "Store the result: const str = val as string", "Then access str.length"],
  "solution": "const val: unknown = \"Hello TypeScript\";\nconst str = val as string;\nconsole.log(str.length);"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Data Types';

-- ============================================================
-- TOPIC: Conditionals
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: Chained Comparisons', 'code', 20, 12, 'python',
$$
{
  "instructions": "x = 15. Print \"in range\" if 10 <= x <= 20 else \"out of range\". Then y = 7; print \"small\" if (n := y * 2) < 20 else f\"big: {n}\"",
  "starter_code": "x = 15\n# Check if x is in range 10-20\n\ny = 7\n# Use walrus operator to check y * 2",
  "expected_output": "in range\nsmall",
  "hints": ["Python allows chained comparisons: 10 <= x <= 20", "The walrus operator := assigns and returns a value", "(n := y * 2) assigns y*2 to n and returns it"],
  "solution": "x = 15\nprint(\"in range\" if 10 <= x <= 20 else \"out of range\")\ny = 7\nprint(\"small\" if (n := y * 2) < 20 else f\"big: {n}\")"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Conditionals';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: match Statement', 'code', 20, 13, 'python',
$$
{
  "instructions": "status = 404. Use a match/case statement: case 200 prints \"OK\", case 404 prints \"Not Found\", default prints \"Unknown\".",
  "starter_code": "status = 404\n# Use match/case to handle status codes",
  "expected_output": "Not Found",
  "hints": ["match/case was introduced in Python 3.10", "Use case 200:, case 404:, case _: for default", "Each case block is indented under it"],
  "solution": "status = 404\nmatch status:\n    case 200:\n        print(\"OK\")\n    case 404:\n        print(\"Not Found\")\n    case _:\n        print(\"Unknown\")"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Conditionals';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Optional Chaining', 'code', 20, 14, 'javascript',
$$
{
  "instructions": "const user = { profile: { age: 25 } }. Print user?.profile?.age. Then print user?.address?.city ?? \"No city\"",
  "starter_code": "const user = { profile: { age: 25 } };\n// Access age with optional chaining\n// Access city with optional chaining and nullish coalescing",
  "expected_output": "25\nNo city",
  "hints": ["?. optional chaining returns undefined instead of throwing", "?? nullish coalescing returns the right side if left is null/undefined", "user?.address is undefined, so user?.address?.city is also undefined"],
  "solution": "const user = { profile: { age: 25 } };\nconsole.log(user?.profile?.age);\nconsole.log(user?.address?.city ?? \"No city\");"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Conditionals';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Logical Assignment', 'code', 20, 15, 'javascript',
$$
{
  "instructions": "let a = null; use a ??= \"default\". let b = 0; use b ||= 42. let c = 1; use c &&= 2. Print each.",
  "starter_code": "let a = null;\na ??= \"default\";\n\nlet b = 0;\nb ||= 42;\n\nlet c = 1;\nc &&= 2;\n\nconsole.log(a);\nconsole.log(b);\nconsole.log(c);",
  "expected_output": "default\n42\n2",
  "hints": ["??= assigns only if the variable is null or undefined", "||= assigns if the variable is falsy", "&&= assigns only if the variable is truthy"],
  "solution": "let a = null;\na ??= \"default\";\n\nlet b = 0;\nb ||= 42;\n\nlet c = 1;\nc &&= 2;\n\nconsole.log(a);\nconsole.log(b);\nconsole.log(c);"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Conditionals';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Discriminated Unions', 'code', 25, 16, 'typescript',
$$
{
  "instructions": "Define: type Shape = { kind: \"circle\"; radius: number } | { kind: \"square\"; side: number }. Write function area(s: Shape): number using switch on s.kind (circle: Math.PI * r * r, square: side * side). Print Math.round(area({ kind: \"circle\", radius: 5 })).",
  "starter_code": "type Shape = { kind: \"circle\"; radius: number } | { kind: \"square\"; side: number };\n\nfunction area(s: Shape): number {\n  // switch on s.kind\n}\n\nconsole.log(Math.round(area({ kind: \"circle\", radius: 5 })));",
  "expected_output": "79",
  "hints": ["switch (s.kind) to discriminate between circle and square", "For circle: return Math.PI * s.radius * s.radius", "Math.round(78.539...) = 79"],
  "solution": "type Shape = { kind: \"circle\"; radius: number } | { kind: \"square\"; side: number };\n\nfunction area(s: Shape): number {\n  switch (s.kind) {\n    case \"circle\": return Math.PI * s.radius * s.radius;\n    case \"square\": return s.side * s.side;\n  }\n}\n\nconsole.log(Math.round(area({ kind: \"circle\", radius: 5 })));"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Conditionals';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Type Guards', 'code', 20, 17, 'typescript',
$$
{
  "instructions": "Write a type guard: function isString(val: unknown): val is string { return typeof val === \"string\" }. Check \"hello\" and 42 — print \"string\" or \"not string\".",
  "starter_code": "function isString(val: unknown): val is string {\n  return typeof val === \"string\";\n}\n\n// Check \"hello\" and 42",
  "expected_output": "string\nnot string",
  "hints": ["val is string is a type predicate — the return type of the guard", "isString(\"hello\") returns true", "isString(42) returns false"],
  "solution": "function isString(val: unknown): val is string {\n  return typeof val === \"string\";\n}\n\nconsole.log(isString(\"hello\") ? \"string\" : \"not string\");\nconsole.log(isString(42) ? \"string\" : \"not string\");"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Conditionals';

-- ============================================================
-- TOPIC: Loops
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: enumerate and zip', 'code', 20, 12, 'python',
$$
{
  "instructions": "fruits = [\"apple\", \"banana\", \"cherry\"]; prices = [1.2, 0.5, 2.0]. Use enumerate(zip(fruits, prices)) to print: 0. apple: $1.2\n1. banana: $0.5\n2. cherry: $2.0",
  "starter_code": "fruits = [\"apple\", \"banana\", \"cherry\"]\nprices = [1.2, 0.5, 2.0]\n# Use enumerate(zip(fruits, prices))",
  "expected_output": "0. apple: $1.2\n1. banana: $0.5\n2. cherry: $2.0",
  "hints": ["zip(fruits, prices) pairs each fruit with its price", "enumerate adds an index: for i, (fruit, price) in enumerate(zip(...))", "f\"{i}. {fruit}: ${price}\" formats the output"],
  "solution": "fruits = [\"apple\", \"banana\", \"cherry\"]\nprices = [1.2, 0.5, 2.0]\nfor i, (fruit, price) in enumerate(zip(fruits, prices)):\n    print(f\"{i}. {fruit}: ${price}\")"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Loops';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: List Comprehension with Condition', 'code', 20, 13, 'python',
$$
{
  "instructions": "numbers = list(range(1, 11)). Create a list of squares of even numbers. Print the result.",
  "starter_code": "numbers = list(range(1, 11))\n# Create list of squares of even numbers using list comprehension",
  "expected_output": "[4, 16, 36, 64, 100]",
  "hints": ["List comprehension: [expr for x in iterable if condition]", "Filter even: if x % 2 == 0", "Square: x**2"],
  "solution": "numbers = list(range(1, 11))\nresult = [x**2 for x in numbers if x % 2 == 0]\nprint(result)"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Loops';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Array Methods Chain', 'code', 20, 14, 'javascript',
$$
{
  "instructions": "const nums = [1,2,3,4,5,6,7,8,9,10]. Filter even numbers, double each, sum with reduce. Print the result.",
  "starter_code": "const nums = [1,2,3,4,5,6,7,8,9,10];\n// Chain: filter even, map double, reduce sum",
  "expected_output": "60",
  "hints": [".filter(n => n % 2 === 0) keeps even numbers", ".map(n => n * 2) doubles each", ".reduce((a, b) => a + b, 0) sums them"],
  "solution": "const nums = [1,2,3,4,5,6,7,8,9,10];\nconst result = nums.filter(n => n % 2 === 0).map(n => n * 2).reduce((a, b) => a + b, 0);\nconsole.log(result);"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Loops';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: for...of with entries', 'code', 20, 15, 'javascript',
$$
{
  "instructions": "const colors = [\"red\", \"green\", \"blue\"]. Use for...of with .entries() to print: 0: red\n1: green\n2: blue",
  "starter_code": "const colors = [\"red\", \"green\", \"blue\"];\n// Use for...of with .entries()",
  "expected_output": "0: red\n1: green\n2: blue",
  "hints": [".entries() returns [index, value] pairs", "Destructure in the loop: for (const [i, color] of colors.entries())", "Use template literal: `${i}: ${color}`"],
  "solution": "const colors = [\"red\", \"green\", \"blue\"];\nfor (const [i, color] of colors.entries()) {\n  console.log(`${i}: ${color}`);\n}"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Loops';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Typed reduce', 'code', 20, 16, 'typescript',
$$
{
  "instructions": "Given interface Product { name: string; price: number }, use a typed reduce to sum prices. Print the total to 2 decimal places.",
  "starter_code": "interface Product { name: string; price: number }\n\nconst cart: Product[] = [\n  { name: \"Apple\", price: 1.99 },\n  { name: \"Bread\", price: 2.49 },\n  { name: \"Milk\", price: 3.29 },\n  { name: \"Eggs\", price: 4.99 },\n  { name: \"Cheese\", price: 5.49 },\n  { name: \"Yogurt\", price: 3.25 },\n  { name: \"Butter\", price: 4.48 }\n];\n// Sum prices with typed reduce",
  "expected_output": "25.98",
  "hints": ["reduce((total, item) => total + item.price, 0)", "Type the accumulator: (total: number, item: Product) => total + item.price", "Use .toFixed(2) on the result"],
  "solution": "interface Product { name: string; price: number }\n\nconst cart: Product[] = [\n  { name: \"Apple\", price: 1.99 },\n  { name: \"Bread\", price: 2.49 },\n  { name: \"Milk\", price: 3.29 },\n  { name: \"Eggs\", price: 4.99 },\n  { name: \"Cheese\", price: 5.49 },\n  { name: \"Yogurt\", price: 3.25 },\n  { name: \"Butter\", price: 4.48 }\n];\nconst total = cart.reduce((sum: number, item: Product) => sum + item.price, 0);\nconsole.log(total.toFixed(2));"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Loops';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Generator with TypeScript', 'code', 25, 17, 'typescript',
$$
{
  "instructions": "Write a typed generator: function* range(start: number, end: number, step: number = 1): Generator<number>. Use it to collect [0, 2, 4, 6, 8], print as JSON.",
  "starter_code": "function* range(start: number, end: number, step: number = 1): Generator<number> {\n  // yield values from start up to (not including) end, stepping by step\n}\n\nconst values = [...range(0, 10, 2)];\nconsole.log(JSON.stringify(values));",
  "expected_output": "[0,2,4,6,8]",
  "hints": ["Use a for loop: for (let i = start; i < end; i += step)", "yield i inside the loop", "Spread the generator into an array: [...range(0, 10, 2)]"],
  "solution": "function* range(start: number, end: number, step: number = 1): Generator<number> {\n  for (let i = start; i < end; i += step) {\n    yield i;\n  }\n}\n\nconst values = [...range(0, 10, 2)];\nconsole.log(JSON.stringify(values));"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Loops';

-- ============================================================
-- TOPIC: Functions
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: *args and **kwargs', 'code', 20, 12, 'python',
$$
{
  "instructions": "Write a function stats(*numbers) that prints min, max, and average of the args. Call with stats(4, 7, 2, 9, 1).",
  "starter_code": "def stats(*numbers):\n    # Print min, max, and avg\n    pass\n\nstats(4, 7, 2, 9, 1)",
  "expected_output": "min: 1\nmax: 9\navg: 4.6",
  "hints": ["Use min(numbers) and max(numbers)", "avg = sum(numbers) / len(numbers)", "f-strings: f\"min: {min(numbers)}\""],
  "solution": "def stats(*numbers):\n    print(f\"min: {min(numbers)}\")\n    print(f\"max: {max(numbers)}\")\n    print(f\"avg: {sum(numbers)/len(numbers)}\")\n\nstats(4, 7, 2, 9, 1)"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Functions';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: Lambda and sorted', 'code', 20, 13, 'python',
$$
{
  "instructions": "students = [(\"Alice\", 85), (\"Bob\", 92), (\"Carol\", 78)]. Sort by grade descending using a lambda. Print names in order.",
  "starter_code": "students = [(\"Alice\", 85), (\"Bob\", 92), (\"Carol\", 78)]\n# Sort by grade descending with lambda",
  "expected_output": "Bob\nAlice\nCarol",
  "hints": ["sorted(students, key=lambda s: s[1], reverse=True)", "The lambda returns the grade (index 1)", "Loop over sorted list: for name, _ in sorted_students"],
  "solution": "students = [(\"Alice\", 85), (\"Bob\", 92), (\"Carol\", 78)]\nsorted_students = sorted(students, key=lambda s: s[1], reverse=True)\nfor name, _ in sorted_students:\n    print(name)"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Functions';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Closure Counter', 'code', 20, 14, 'javascript',
$$
{
  "instructions": "Write a makeCounter() function that returns an increment function. Each call increments and returns the count. Call it 3 times and print 1, 2, 3.",
  "starter_code": "function makeCounter() {\n  // Return a function that increments a private count\n}\n\nconst counter = makeCounter();\nconsole.log(counter());\nconsole.log(counter());\nconsole.log(counter());",
  "expected_output": "1\n2\n3",
  "hints": ["Declare let count = 0 inside makeCounter", "Return a function that does count++ and returns count", "Each call to counter() increments the shared count"],
  "solution": "function makeCounter() {\n  let count = 0;\n  return function() {\n    count++;\n    return count;\n  };\n}\n\nconst counter = makeCounter();\nconsole.log(counter());\nconsole.log(counter());\nconsole.log(counter());"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Functions';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Function Composition', 'code', 20, 15, 'javascript',
$$
{
  "instructions": "Write compose(f, g) = x => f(g(x)). Define double = x => x * 2 and addOne = x => x + 1. Create doubleAndAdd = compose(addOne, double). Print doubleAndAdd(5).",
  "starter_code": "const compose = (f, g) => x => f(g(x));\n\nconst double = x => x * 2;\nconst addOne = x => x + 1;\n\nconst doubleAndAdd = compose(addOne, double);\nconsole.log(doubleAndAdd(5));",
  "expected_output": "11",
  "hints": ["compose(f, g) applies g first, then f", "double(5) = 10, addOne(10) = 11", "compose(addOne, double)(5) = addOne(double(5)) = 11"],
  "solution": "const compose = (f, g) => x => f(g(x));\n\nconst double = x => x * 2;\nconst addOne = x => x + 1;\n\nconst doubleAndAdd = compose(addOne, double);\nconsole.log(doubleAndAdd(5));"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Functions';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Function Overloads', 'code', 25, 16, 'typescript',
$$
{
  "instructions": "Overload function greet: greet(name: string): string and greet(firstName: string, lastName: string): string. Implementation handles both. Print greet(\"Alice\") and greet(\"John\", \"Doe\").",
  "starter_code": "function greet(name: string): string;\nfunction greet(firstName: string, lastName: string): string;\nfunction greet(first: string, last?: string): string {\n  // Implement both cases\n}\n\nconsole.log(greet(\"Alice\"));\nconsole.log(greet(\"John\", \"Doe\"));",
  "expected_output": "Hello, Alice!\nHello, John Doe!",
  "hints": ["Check if last is provided: if (last)", "If last exists: return `Hello, ${first} ${last}!`", "Otherwise: return `Hello, ${first}!`"],
  "solution": "function greet(name: string): string;\nfunction greet(firstName: string, lastName: string): string;\nfunction greet(first: string, last?: string): string {\n  if (last) return `Hello, ${first} ${last}!`;\n  return `Hello, ${first}!`;\n}\n\nconsole.log(greet(\"Alice\"));\nconsole.log(greet(\"John\", \"Doe\"));"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Functions';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Currying with Types', 'code', 20, 17, 'typescript',
$$
{
  "instructions": "Write a curried add function: const add = (a: number) => (b: number): number => a + b. Create const add5 = add(5). Print add5(3) and add5(10).",
  "starter_code": "const add = (a: number) => (b: number): number => a + b;\n\nconst add5 = add(5);\nconsole.log(add5(3));\nconsole.log(add5(10));",
  "expected_output": "8\n15",
  "hints": ["Currying breaks a function into a chain of single-argument functions", "add(5) returns a function that adds 5 to its argument", "add5(3) = 5 + 3 = 8, add5(10) = 5 + 10 = 15"],
  "solution": "const add = (a: number) => (b: number): number => a + b;\n\nconst add5 = add(5);\nconsole.log(add5(3));\nconsole.log(add5(10));"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Functions';

-- ============================================================
-- TOPIC: Arrays & Lists
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: Nested List Comprehension', 'code', 20, 12, 'python',
$$
{
  "instructions": "matrix = [[1,2,3],[4,5,6],[7,8,9]]. Flatten it with a nested list comprehension. Print the flat list.",
  "starter_code": "matrix = [[1,2,3],[4,5,6],[7,8,9]]\n# Flatten with list comprehension",
  "expected_output": "[1, 2, 3, 4, 5, 6, 7, 8, 9]",
  "hints": ["[item for row in matrix for item in row]", "The outer loop iterates over rows", "The inner loop iterates over items in each row"],
  "solution": "matrix = [[1,2,3],[4,5,6],[7,8,9]]\nflat = [item for row in matrix for item in row]\nprint(flat)"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Arrays & Lists';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: Group by First Letter', 'code', 25, 13, 'python',
$$
{
  "instructions": "words = [\"cat\", \"car\", \"bar\", \"bat\", \"can\"]. Group by first letter into a dict. Print sorted by key, each group sorted: b: bar, bat\nc: can, car, cat",
  "starter_code": "words = [\"cat\", \"car\", \"bar\", \"bat\", \"can\"]\n# Group by first letter",
  "expected_output": "b: bar, bat\nc: can, car, cat",
  "hints": ["Build a dict: groups = {}; for word in words: groups.setdefault(word[0], []).append(word)", "Sort each group: sorted(words)", "Print sorted by key: for k in sorted(groups)"],
  "solution": "words = [\"cat\", \"car\", \"bar\", \"bat\", \"can\"]\ngroups = {}\nfor word in words:\n    groups.setdefault(word[0], []).append(word)\nfor k in sorted(groups):\n    print(f\"{k}: {', '.join(sorted(groups[k]))}\")"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Arrays & Lists';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: flat and flatMap', 'code', 20, 14, 'javascript',
$$
{
  "instructions": "const nested = [[1,2],[3,[4,5]],6]. Use .flat(2) to fully flatten it. Print as JSON.",
  "starter_code": "const nested = [[1,2],[3,[4,5]],6];\n// Flatten with .flat(2)",
  "expected_output": "[1,2,3,4,5,6]",
  "hints": [".flat() flattens one level by default", ".flat(2) flattens up to 2 levels deep", "JSON.stringify converts the array to a string"],
  "solution": "const nested = [[1,2],[3,[4,5]],6];\nconsole.log(JSON.stringify(nested.flat(2)));"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Arrays & Lists';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Array from Set (unique values)', 'code', 20, 15, 'javascript',
$$
{
  "instructions": "const nums = [1,2,3,2,1,4,3,5]. Remove duplicates using Set. Print sorted unique values as JSON.",
  "starter_code": "const nums = [1,2,3,2,1,4,3,5];\n// Remove duplicates using Set, then sort",
  "expected_output": "[1,2,3,4,5]",
  "hints": ["new Set(nums) creates a set of unique values", "[...new Set(nums)] spreads back to an array", ".sort((a,b) => a-b) sorts numerically"],
  "solution": "const nums = [1,2,3,2,1,4,3,5];\nconst unique = [...new Set(nums)].sort((a,b) => a-b);\nconsole.log(JSON.stringify(unique));"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Arrays & Lists';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Tuple Types', 'code', 20, 16, 'typescript',
$$
{
  "instructions": "Define type Pair<T, U> = [T, U]. Create const p: Pair<string, number> = [\"age\", 25]. Destructure and print: age = 25",
  "starter_code": "type Pair<T, U> = [T, U];\nconst p: Pair<string, number> = [\"age\", 25];\n// Destructure and print",
  "expected_output": "age = 25",
  "hints": ["Destructure with: const [key, value] = p", "Use a template literal: `${key} = ${value}`", "Tuples have fixed length and typed positions"],
  "solution": "type Pair<T, U> = [T, U];\nconst p: Pair<string, number> = [\"age\", 25];\nconst [key, value] = p;\nconsole.log(`${key} = ${value}`);"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Arrays & Lists';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: ReadonlyArray', 'code', 20, 17, 'typescript',
$$
{
  "instructions": "const arr: ReadonlyArray<number> = [1, 2, 3, 4, 5]. Use .filter() to keep even numbers, .map() to square them, then sum them. Print the sum.",
  "starter_code": "const arr: ReadonlyArray<number> = [1, 2, 3, 4, 5];\n// Filter even, square, sum",
  "expected_output": "20",
  "hints": ["Filter even: arr.filter(n => n % 2 === 0) → [2, 4]", "Square: .map(n => n * n) → [4, 16]", "Sum: .reduce((a, b) => a + b, 0) → 20"],
  "solution": "const arr: ReadonlyArray<number> = [1, 2, 3, 4, 5];\nconst sum = arr.filter(n => n % 2 === 0).map(n => n * n).reduce((a, b) => a + b, 0);\nconsole.log(sum);"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Arrays & Lists';

-- ============================================================
-- TOPIC: Objects & Dicts
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: Dict Comprehension', 'code', 20, 12, 'python',
$$
{
  "instructions": "words = [\"hello\", \"world\", \"python\"]. Create a dict mapping each word to its length. Print sorted by length descending.",
  "starter_code": "words = [\"hello\", \"world\", \"python\"]\n# Create dict: word -> length, print sorted by length desc",
  "expected_output": "python: 6\nhello: 5\nworld: 5",
  "hints": ["Dict comprehension: {word: len(word) for word in words}", "Sort by value: sorted(d.items(), key=lambda x: x[1], reverse=True)", "f\"{k}: {v}\" for each pair"],
  "solution": "words = [\"hello\", \"world\", \"python\"]\nd = {word: len(word) for word in words}\nfor k, v in sorted(d.items(), key=lambda x: x[1], reverse=True):\n    print(f\"{k}: {v}\")"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Objects & Dicts';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: Merge Dicts', 'code', 20, 13, 'python',
$$
{
  "instructions": "defaults = {\"color\": \"blue\", \"size\": \"medium\", \"weight\": 1.0}. custom = {\"color\": \"red\", \"weight\": 2.5}. Merge so custom overrides defaults. Print sorted keys.",
  "starter_code": "defaults = {\"color\": \"blue\", \"size\": \"medium\", \"weight\": 1.0}\ncustom = {\"color\": \"red\", \"weight\": 2.5}\n# Merge dicts (custom overrides defaults)",
  "expected_output": "color: red\nsize: medium\nweight: 2.5",
  "hints": ["{**defaults, **custom} merges dicts, right side wins", "sorted(merged) sorts keys alphabetically", "f\"{k}: {merged[k]}\" prints each pair"],
  "solution": "defaults = {\"color\": \"blue\", \"size\": \"medium\", \"weight\": 1.0}\ncustom = {\"color\": \"red\", \"weight\": 2.5}\nmerged = {**defaults, **custom}\nfor k in sorted(merged):\n    print(f\"{k}: {merged[k]}\")"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Objects & Dicts';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Object.entries iteration', 'code', 20, 14, 'javascript',
$$
{
  "instructions": "const scores = { Alice: 95, Bob: 87, Carol: 92 }. Find and print the highest scorer as: Alice: 95",
  "starter_code": "const scores = { Alice: 95, Bob: 87, Carol: 92 };\n// Find the highest scorer",
  "expected_output": "Alice: 95",
  "hints": ["Object.entries(scores) gives [[\"Alice\", 95], ...]", "Use reduce to find the entry with max value", "console.log(`${name}: ${score}`)"],
  "solution": "const scores = { Alice: 95, Bob: 87, Carol: 92 };\nconst [name, score] = Object.entries(scores).reduce((max, entry) => entry[1] > max[1] ? entry : max);\nconsole.log(`${name}: ${score}`);"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Objects & Dicts';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Spread Merge Objects', 'code', 20, 15, 'javascript',
$$
{
  "instructions": "const base = { x: 0, y: 0, z: 0 }. const update = { x: 5, z: 10 }. Merge with spread so update overrides base. Print JSON.stringify of result.",
  "starter_code": "const base = { x: 0, y: 0, z: 0 };\nconst update = { x: 5, z: 10 };\n// Merge and print",
  "expected_output": "{\"x\":5,\"y\":0,\"z\":10}",
  "hints": ["Use spread: { ...base, ...update }", "Right-side properties override left-side", "JSON.stringify({x:5,y:0,z:10}) = '{\"x\":5,\"y\":0,\"z\":10}'"],
  "solution": "const base = { x: 0, y: 0, z: 0 };\nconst update = { x: 5, z: 10 };\nconst merged = { ...base, ...update };\nconsole.log(JSON.stringify(merged));"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Objects & Dicts';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Partial and Required', 'code', 25, 16, 'typescript',
$$
{
  "instructions": "interface Config { host: string; port: number; ssl: boolean }. Write function applyDefaults(partial: Partial<Config>): Config that fills missing fields with host='localhost', port=3000, ssl=false. Call and print JSON.",
  "starter_code": "interface Config { host: string; port: number; ssl: boolean }\n\nfunction applyDefaults(partial: Partial<Config>): Config {\n  // Fill in defaults\n}\n\nconsole.log(JSON.stringify(applyDefaults({})));",
  "expected_output": "{\"host\":\"localhost\",\"port\":3000,\"ssl\":false}",
  "hints": ["Partial<Config> makes all fields optional", "Use object spread with defaults: { host: 'localhost', port: 3000, ssl: false, ...partial }", "The return type Required<Config> ensures all fields are present"],
  "solution": "interface Config { host: string; port: number; ssl: boolean }\n\nfunction applyDefaults(partial: Partial<Config>): Config {\n  return { host: 'localhost', port: 3000, ssl: false, ...partial };\n}\n\nconsole.log(JSON.stringify(applyDefaults({})));"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Objects & Dicts';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Record Type', 'code', 20, 17, 'typescript',
$$
{
  "instructions": "type Lang = \"python\" | \"javascript\" | \"typescript\". const ratings: Record<Lang, number> = { python: 5, javascript: 4, typescript: 5 }. Print the average rating using toFixed(2).",
  "starter_code": "type Lang = \"python\" | \"javascript\" | \"typescript\";\nconst ratings: Record<Lang, number> = { python: 5, javascript: 4, typescript: 5 };\n// Print average rating",
  "expected_output": "4.67",
  "hints": ["Object.values(ratings) gets [5, 4, 5]", "Sum with reduce, divide by length", "toFixed(2) rounds to 2 decimal places"],
  "solution": "type Lang = \"python\" | \"javascript\" | \"typescript\";\nconst ratings: Record<Lang, number> = { python: 5, javascript: 4, typescript: 5 };\nconst vals = Object.values(ratings);\nconst avg = vals.reduce((a, b) => a + b, 0) / vals.length;\nconsole.log(avg.toFixed(2));"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Objects & Dicts';

-- ============================================================
-- TOPIC: Object-Oriented Programming
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: Property Decorator', 'code', 25, 12, 'python',
$$
{
  "instructions": "Class Temperature with _celsius. Add @property celsius getter. Add celsius setter that validates >= -273.15. Add @property fahrenheit = celsius * 9/5 + 32. Create t=Temperature(100), print t.fahrenheit, set t.celsius=0, print t.fahrenheit.",
  "starter_code": "class Temperature:\n    def __init__(self, celsius):\n        self._celsius = celsius\n\n    @property\n    def celsius(self):\n        return self._celsius\n\n    @celsius.setter\n    def celsius(self, value):\n        if value < -273.15:\n            raise ValueError(\"Temperature below absolute zero\")\n        self._celsius = value\n\n    @property\n    def fahrenheit(self):\n        return self._celsius * 9/5 + 32\n\nt = Temperature(100)\nprint(t.fahrenheit)\nt.celsius = 0\nprint(t.fahrenheit)",
  "expected_output": "212.0\n32.0",
  "hints": ["The @property decorator makes a method callable as an attribute", "fahrenheit = celsius * 9/5 + 32", "100°C = 212°F, 0°C = 32°F"],
  "solution": "class Temperature:\n    def __init__(self, celsius):\n        self._celsius = celsius\n\n    @property\n    def celsius(self):\n        return self._celsius\n\n    @celsius.setter\n    def celsius(self, value):\n        if value < -273.15:\n            raise ValueError(\"Temperature below absolute zero\")\n        self._celsius = value\n\n    @property\n    def fahrenheit(self):\n        return self._celsius * 9/5 + 32\n\nt = Temperature(100)\nprint(t.fahrenheit)\nt.celsius = 0\nprint(t.fahrenheit)"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Object-Oriented Programming';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: __str__ and __add__', 'code', 20, 13, 'python',
$$
{
  "instructions": "Class Point(x, y) with __str__ returning \"Point(x, y)\" and __add__ returning a new Point. p1 = Point(1, 2); p2 = Point(3, 4); print(p1 + p2).",
  "starter_code": "class Point:\n    def __init__(self, x, y):\n        self.x = x\n        self.y = y\n\n    def __str__(self):\n        return f\"Point({self.x}, {self.y})\"\n\n    def __add__(self, other):\n        return Point(self.x + other.x, self.y + other.y)\n\np1 = Point(1, 2)\np2 = Point(3, 4)\nprint(p1 + p2)",
  "expected_output": "Point(4, 6)",
  "hints": ["__str__ defines what print() shows", "__add__ enables the + operator between Points", "Return a new Point with summed x and y values"],
  "solution": "class Point:\n    def __init__(self, x, y):\n        self.x = x\n        self.y = y\n\n    def __str__(self):\n        return f\"Point({self.x}, {self.y})\"\n\n    def __add__(self, other):\n        return Point(self.x + other.x, self.y + other.y)\n\np1 = Point(1, 2)\np2 = Point(3, 4)\nprint(p1 + p2)"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Object-Oriented Programming';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Static Methods', 'code', 20, 14, 'javascript',
$$
{
  "instructions": "Create class MathUtils with static methods: add(a,b), multiply(a,b), isPrime(n). Call MathUtils.add(3,4), MathUtils.multiply(3,4), MathUtils.isPrime(7). Print each.",
  "starter_code": "class MathUtils {\n  static add(a, b) { return a + b; }\n  static multiply(a, b) { return a * b; }\n  static isPrime(n) {\n    if (n < 2) return false;\n    for (let i = 2; i <= Math.sqrt(n); i++) {\n      if (n % i === 0) return false;\n    }\n    return true;\n  }\n}\n\nconsole.log(MathUtils.add(3, 4));\nconsole.log(MathUtils.multiply(3, 4));\nconsole.log(MathUtils.isPrime(7));",
  "expected_output": "7\n12\ntrue",
  "hints": ["static methods are called on the class, not instances", "MathUtils.add(3,4) = 7", "isPrime(7) is true since 7 has no divisors except 1 and itself"],
  "solution": "class MathUtils {\n  static add(a, b) { return a + b; }\n  static multiply(a, b) { return a * b; }\n  static isPrime(n) {\n    if (n < 2) return false;\n    for (let i = 2; i <= Math.sqrt(n); i++) {\n      if (n % i === 0) return false;\n    }\n    return true;\n  }\n}\n\nconsole.log(MathUtils.add(3, 4));\nconsole.log(MathUtils.multiply(3, 4));\nconsole.log(MathUtils.isPrime(7));"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Object-Oriented Programming';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Symbol Iterator', 'code', 25, 15, 'javascript',
$$
{
  "instructions": "Create class Range(start, end) with [Symbol.iterator]() that yields integers from start to end inclusive. Use for...of on new Range(1,5) to print each number.",
  "starter_code": "class Range {\n  constructor(start, end) {\n    this.start = start;\n    this.end = end;\n  }\n  [Symbol.iterator]() {\n    let current = this.start;\n    const end = this.end;\n    return {\n      next() {\n        if (current <= end) {\n          return { value: current++, done: false };\n        }\n        return { value: undefined, done: true };\n      }\n    };\n  }\n}\n\nfor (const n of new Range(1, 5)) {\n  console.log(n);\n}",
  "expected_output": "1\n2\n3\n4\n5",
  "hints": ["Symbol.iterator makes an object iterable with for...of", "The iterator must return an object with a next() method", "next() returns { value, done } — done: true signals the end"],
  "solution": "class Range {\n  constructor(start, end) {\n    this.start = start;\n    this.end = end;\n  }\n  [Symbol.iterator]() {\n    let current = this.start;\n    const end = this.end;\n    return {\n      next() {\n        if (current <= end) {\n          return { value: current++, done: false };\n        }\n        return { value: undefined, done: true };\n      }\n    };\n  }\n}\n\nfor (const n of new Range(1, 5)) {\n  console.log(n);\n}"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Object-Oriented Programming';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Abstract Class', 'code', 25, 16, 'typescript',
$$
{
  "instructions": "Create abstract class Animal with abstract method sound(): string and concrete method describe() printing 'I am a Dog and I say Woof!' etc. Create Dog and Cat subclasses. Print both describe() calls.",
  "starter_code": "abstract class Animal {\n  abstract sound(): string;\n  describe(): void {\n    console.log(`I am a ${this.constructor.name} and I say ${this.sound()}!`);\n  }\n}\n\nclass Dog extends Animal {\n  sound() { return \"Woof\"; }\n}\n\nclass Cat extends Animal {\n  sound() { return \"Meow\"; }\n}\n\nnew Dog().describe();\nnew Cat().describe();",
  "expected_output": "I am a Dog and I say Woof!\nI am a Cat and I say Meow!",
  "hints": ["abstract class cannot be instantiated directly", "Subclasses must implement all abstract methods", "this.constructor.name gives the class name at runtime"],
  "solution": "abstract class Animal {\n  abstract sound(): string;\n  describe(): void {\n    console.log(`I am a ${this.constructor.name} and I say ${this.sound()}!`);\n  }\n}\n\nclass Dog extends Animal {\n  sound() { return \"Woof\"; }\n}\n\nclass Cat extends Animal {\n  sound() { return \"Meow\"; }\n}\n\nnew Dog().describe();\nnew Cat().describe();"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Object-Oriented Programming';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Decorator Factory (HOF)', 'code', 25, 17, 'typescript',
$$
{
  "instructions": "Implement log(prefix: string) as a higher-order function wrapping functions. const loggedAdd = log(\"ADD\")(add) where add(a,b) = a+b. Call loggedAdd(3,4) to print '[ADD] result: 7'.",
  "starter_code": "function log(prefix: string) {\n  return function<T extends (...args: number[]) => number>(fn: T) {\n    return function(...args: number[]): number {\n      const result = fn(...args);\n      console.log(`[${prefix}] result: ${result}`);\n      return result;\n    };\n  };\n}\n\nconst add = (a: number, b: number) => a + b;\nconst loggedAdd = log(\"ADD\")(add);\nloggedAdd(3, 4);",
  "expected_output": "[ADD] result: 7",
  "hints": ["log(prefix) returns a decorator function", "The decorator wraps fn, calls it, logs the result", "3 + 4 = 7"],
  "solution": "function log(prefix: string) {\n  return function<T extends (...args: number[]) => number>(fn: T) {\n    return function(...args: number[]): number {\n      const result = fn(...args);\n      console.log(`[${prefix}] result: ${result}`);\n      return result;\n    };\n  };\n}\n\nconst add = (a: number, b: number) => a + b;\nconst loggedAdd = log(\"ADD\")(add);\nloggedAdd(3, 4);"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Object-Oriented Programming';

-- ============================================================
-- TOPIC: Error Handling
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: Context Manager', 'code', 20, 12, 'python',
$$
{
  "instructions": "Use io.StringIO as a context manager. Read lines from it and print the count.",
  "starter_code": "from io import StringIO\n\ndata = StringIO(\"line1\\nline2\\nline3\\n\")\n# Use 'with' statement to read all lines and print their count",
  "expected_output": "3",
  "hints": [
    "Use: with data as f:",
    "f.readlines() returns a list of lines",
    "len(...) gives the count"
  ],
  "solution": "from io import StringIO\n\ndata = StringIO(\"line1\\nline2\\nline3\\n\")\nwith data as f:\n    count = len(f.readlines())\nprint(count)"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Error Handling';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: Custom Exception Chain', 'code', 25, 13, 'python',
$$
{
  "instructions": "Define DatabaseError(Exception) and ConnectionError(DatabaseError). Write connect() that raises ConnectionError('timeout'). Catch DatabaseError and print 'DB error: timeout'.",
  "starter_code": "class DatabaseError(Exception):\n    pass\n\nclass ConnectionError(DatabaseError):\n    pass\n\ndef connect():\n    raise ConnectionError(\"timeout\")\n\ntry:\n    connect()\nexcept DatabaseError as e:\n    print(f\"DB error: {e}\")",
  "expected_output": "DB error: timeout",
  "hints": [
    "DatabaseError inherits from Exception",
    "ConnectionError inherits from DatabaseError",
    "Catching DatabaseError also catches ConnectionError (subclass)"
  ],
  "solution": "class DatabaseError(Exception):\n    pass\n\nclass ConnectionError(DatabaseError):\n    pass\n\ndef connect():\n    raise ConnectionError(\"timeout\")\n\ntry:\n    connect()\nexcept DatabaseError as e:\n    print(f\"DB error: {e}\")"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Error Handling';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Error Types', 'code', 20, 14, 'javascript',
$$
{
  "instructions": "Catch a SyntaxError from JSON.parse('invalid') and print 'SyntaxError'. Catch a TypeError from null.x and print 'TypeError'.",
  "starter_code": "try {\n  JSON.parse('invalid');\n} catch(e) {\n  console.log('SyntaxError');\n}\n\ntry {\n  null.x;\n} catch(e) {\n  console.log('TypeError');\n}",
  "expected_output": "SyntaxError\nTypeError",
  "hints": [
    "JSON.parse with invalid JSON throws a SyntaxError",
    "Accessing a property on null throws a TypeError",
    "The catch block does not need to inspect e — just print the type name"
  ],
  "solution": "try {\n  JSON.parse('invalid');\n} catch(e) {\n  console.log('SyntaxError');\n}\n\ntry {\n  null.x;\n} catch(e) {\n  console.log('TypeError');\n}"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Error Handling';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Error Recovery', 'code', 20, 15, 'javascript',
$$
{
  "instructions": "function safeDivide(a, b) throws if b===0. function calculate(a, b) returns result or 'Error: division by zero'. Print calculate(10, 2) and calculate(5, 0).",
  "starter_code": "function safeDivide(a, b) {\n  if (b === 0) throw new Error('division by zero');\n  return a / b;\n}\n\nfunction calculate(a, b) {\n  try {\n    return safeDivide(a, b);\n  } catch(e) {\n    return 'Error: ' + e.message;\n  }\n}\n\nconsole.log(calculate(10, 2));\nconsole.log(calculate(5, 0));",
  "expected_output": "5\nError: division by zero",
  "hints": [
    "safeDivide throws when b === 0",
    "calculate catches the error and returns a fallback string",
    "10 / 2 = 5"
  ],
  "solution": "function safeDivide(a, b) {\n  if (b === 0) throw new Error('division by zero');\n  return a / b;\n}\n\nfunction calculate(a, b) {\n  try {\n    return safeDivide(a, b);\n  } catch(e) {\n    return 'Error: ' + e.message;\n  }\n}\n\nconsole.log(calculate(10, 2));\nconsole.log(calculate(5, 0));"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Error Handling';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Result Type Pattern', 'code', 25, 16, 'typescript',
$$
{
  "instructions": "type Result<T> = { ok: true; value: T } | { ok: false; error: string }. function parseNumber(s: string): Result<number>. Call with '42' and 'abc', print value or error.",
  "starter_code": "type Result<T> = { ok: true; value: T } | { ok: false; error: string };\n\nfunction parseNumber(s: string): Result<number> {\n  const n = Number(s);\n  if (isNaN(n)) return { ok: false, error: `Invalid number: ${s}` };\n  return { ok: true, value: n };\n}\n\nconst r1 = parseNumber('42');\nconst r2 = parseNumber('abc');\n\nif (r1.ok) console.log(r1.value);\nif (!r2.ok) console.log(r2.error);",
  "expected_output": "42\nInvalid number: abc",
  "hints": [
    "Number('abc') returns NaN",
    "isNaN() checks if a value is NaN",
    "The discriminated union uses ok: true/false to narrow the type"
  ],
  "solution": "type Result<T> = { ok: true; value: T } | { ok: false; error: string };\n\nfunction parseNumber(s: string): Result<number> {\n  const n = Number(s);\n  if (isNaN(n)) return { ok: false, error: `Invalid number: ${s}` };\n  return { ok: true, value: n };\n}\n\nconst r1 = parseNumber('42');\nconst r2 = parseNumber('abc');\n\nif (r1.ok) console.log(r1.value);\nif (!r2.ok) console.log(r2.error);"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Error Handling';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Never Type for Exhaustive Checks', 'code', 25, 17, 'typescript',
$$
{
  "instructions": "type Status = 'pending' | 'success' | 'error'. function handle(s: Status): string uses a switch with never for exhaustive checking. Call all 3 values and print each result.",
  "starter_code": "type Status = 'pending' | 'success' | 'error';\n\nfunction handle(s: Status): string {\n  switch (s) {\n    case 'pending': return 'Pending...';\n    case 'success': return 'Done!';\n    case 'error': return 'Failed!';\n    default: const _exhaustive: never = s; return _exhaustive;\n  }\n}\n\nconsole.log(handle('pending'));\nconsole.log(handle('success'));\nconsole.log(handle('error'));",
  "expected_output": "Pending...\nDone!\nFailed!",
  "hints": [
    "The never type means a value can never occur",
    "The default case assigns s to never — TypeScript errors if any case is missing",
    "All 3 Status values must be covered"
  ],
  "solution": "type Status = 'pending' | 'success' | 'error';\n\nfunction handle(s: Status): string {\n  switch (s) {\n    case 'pending': return 'Pending...';\n    case 'success': return 'Done!';\n    case 'error': return 'Failed!';\n    default: const _exhaustive: never = s; return _exhaustive;\n  }\n}\n\nconsole.log(handle('pending'));\nconsole.log(handle('success'));\nconsole.log(handle('error'));"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Error Handling';

-- ============================================================
-- TOPIC: APIs
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: JSON Nested Access', 'code', 20, 12, 'python',
$$
{
  "instructions": "Parse a JSON string and compute the average score. data = '{\"user\": {\"name\": \"Alice\", \"scores\": [95, 87, 92]}}'. Print the average to 2 decimal places.",
  "starter_code": "import json\n\ndata = '{\"user\": {\"name\": \"Alice\", \"scores\": [95, 87, 92]}}'\n# Parse data and print average score",
  "expected_output": "91.33",
  "hints": [
    "json.loads() parses a JSON string to a Python dict",
    "Access nested values: obj['user']['scores']",
    "(95+87+92)/3 = 91.333... use :.2f to format"
  ],
  "solution": "import json\n\ndata = '{\"user\": {\"name\": \"Alice\", \"scores\": [95, 87, 92]}}'\nobj = json.loads(data)\nscores = obj[\"user\"][\"scores\"]\nprint(f\"{sum(scores)/len(scores):.2f}\")"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'APIs';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: Build a JSON Response', 'code', 20, 13, 'python',
$$
{
  "instructions": "Build a Python dict representing an API response and serialize it to pretty JSON with indent=2. The dict: {\"status\": \"success\", \"data\": {\"id\": 1, \"name\": \"Test\"}, \"timestamp\": \"2024-01-01\"}. Print it.",
  "starter_code": "import json\n\nresponse = {\n    \"status\": \"success\",\n    \"data\": {\"id\": 1, \"name\": \"Test\"},\n    \"timestamp\": \"2024-01-01\"\n}\n# Print as pretty JSON",
  "expected_output": "{\n  \"status\": \"success\",\n  \"data\": {\n    \"id\": 1,\n    \"name\": \"Test\"\n  },\n  \"timestamp\": \"2024-01-01\"\n}",
  "hints": [
    "json.dumps(obj, indent=2) serializes with pretty-printing",
    "print() adds a newline at the end automatically",
    "Key order follows insertion order in Python 3.7+"
  ],
  "solution": "import json\n\nresponse = {\n    \"status\": \"success\",\n    \"data\": {\"id\": 1, \"name\": \"Test\"},\n    \"timestamp\": \"2024-01-01\"\n}\nprint(json.dumps(response, indent=2))"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'APIs';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Parse API Response', 'code', 20, 14, 'javascript',
$$
{
  "instructions": "Parse a JSON string and access its properties. const data = JSON.parse('{\"id\":1,\"name\":\"Alice\",\"role\":\"admin\"}'); Print data.name and data.role.",
  "starter_code": "const data = JSON.parse('{\"id\":1,\"name\":\"Alice\",\"role\":\"admin\"}');\nconsole.log(data.name);\nconsole.log(data.role);",
  "expected_output": "Alice\nadmin",
  "hints": [
    "JSON.parse() converts a JSON string to a JS object",
    "Access properties with dot notation: data.name",
    "data.name = 'Alice', data.role = 'admin'"
  ],
  "solution": "const data = JSON.parse('{\"id\":1,\"name\":\"Alice\",\"role\":\"admin\"}');\nconsole.log(data.name);\nconsole.log(data.role);"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'APIs';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Transform API Data', 'code', 20, 15, 'javascript',
$$
{
  "instructions": "Given an apiResponse with a users array, filter for active users, extract their names, and join with ', '. Print the result.",
  "starter_code": "const apiResponse = {\n  users: [\n    {id: 1, name: \"Alice\", active: true},\n    {id: 2, name: \"Bob\", active: false},\n    {id: 3, name: \"Carol\", active: true}\n  ]\n};\n// Filter active, extract names, join",
  "expected_output": "Alice, Carol",
  "hints": [
    ".filter(u => u.active) keeps only active users",
    ".map(u => u.name) extracts names",
    ".join(', ') combines into a string"
  ],
  "solution": "const apiResponse = {\n  users: [\n    {id: 1, name: \"Alice\", active: true},\n    {id: 2, name: \"Bob\", active: false},\n    {id: 3, name: \"Carol\", active: true}\n  ]\n};\nconst result = apiResponse.users.filter(u => u.active).map(u => u.name).join(', ');\nconsole.log(result);"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'APIs';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Interface for API Response', 'code', 20, 16, 'typescript',
$$
{
  "instructions": "Define ApiResponse<T> and User interfaces. Create a typed response with Alice and Bob as users. Print each user's name.",
  "starter_code": "interface ApiResponse<T> { data: T; status: number; message: string }\ninterface User { id: number; name: string }\n\nconst response: ApiResponse<User[]> = {\n  data: [{ id: 1, name: \"Alice\" }, { id: 2, name: \"Bob\" }],\n  status: 200,\n  message: \"OK\"\n};\n\nresponse.data.forEach(u => console.log(u.name));",
  "expected_output": "Alice\nBob",
  "hints": [
    "ApiResponse<User[]> means data is of type User[]",
    "forEach iterates the array",
    "u.name accesses each user's name"
  ],
  "solution": "interface ApiResponse<T> { data: T; status: number; message: string }\ninterface User { id: number; name: string }\n\nconst response: ApiResponse<User[]> = {\n  data: [{ id: 1, name: \"Alice\" }, { id: 2, name: \"Bob\" }],\n  status: 200,\n  message: \"OK\"\n};\n\nresponse.data.forEach(u => console.log(u.name));"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'APIs';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Type-safe JSON Parsing', 'code', 25, 17, 'typescript',
$$
{
  "instructions": "Write function parseUser(json: string): User | null that parses and validates a User object. Test with valid JSON and invalid input. Print name or 'Invalid'.",
  "starter_code": "interface User { id: number; name: string }\n\nfunction parseUser(json: string): User | null {\n  try {\n    const obj = JSON.parse(json);\n    if (typeof obj.name === 'string' && typeof obj.id === 'number') {\n      return obj as User;\n    }\n    return null;\n  } catch {\n    return null;\n  }\n}\n\nconst u1 = parseUser('{\"id\":1,\"name\":\"Alice\"}');\nconst u2 = parseUser('not json');\n\nconsole.log(u1 ? u1.name : 'Invalid');\nconsole.log(u2 ? u2.name : 'Invalid');",
  "expected_output": "Alice\nInvalid",
  "hints": [
    "Wrap JSON.parse in try/catch for invalid JSON",
    "Validate the shape: check typeof obj.name and obj.id",
    "Return null for invalid data, the User object for valid data"
  ],
  "solution": "interface User { id: number; name: string }\n\nfunction parseUser(json: string): User | null {\n  try {\n    const obj = JSON.parse(json);\n    if (typeof obj.name === 'string' && typeof obj.id === 'number') {\n      return obj as User;\n    }\n    return null;\n  } catch {\n    return null;\n  }\n}\n\nconst u1 = parseUser('{\"id\":1,\"name\":\"Alice\"}');\nconst u2 = parseUser('not json');\n\nconsole.log(u1 ? u1.name : 'Invalid');\nconsole.log(u2 ? u2.name : 'Invalid');"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'APIs';

-- ============================================================
-- TOPIC: Algorithms & Data Structures
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: Two Sum', 'code', 25, 12, 'python',
$$
{
  "instructions": "Given nums = [2, 7, 11, 15] and target = 9, find the two indices where nums[i] + nums[j] == target. Print the indices as a list.",
  "starter_code": "nums = [2, 7, 11, 15]\ntarget = 9\n# Find two indices that sum to target (O(n) solution using a dict)",
  "expected_output": "[0, 1]",
  "hints": [
    "Use a dict to store seen values: {value: index}",
    "For each num, check if (target - num) is already in the dict",
    "2 + 7 = 9, so indices 0 and 1"
  ],
  "solution": "nums = [2, 7, 11, 15]\ntarget = 9\nseen = {}\nfor i, num in enumerate(nums):\n    complement = target - num\n    if complement in seen:\n        print([seen[complement], i])\n        break\n    seen[num] = i"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Algorithms & Data Structures';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: Merge Sort', 'code', 25, 13, 'python',
$$
{
  "instructions": "Implement merge_sort(arr) recursively. Test with [64, 34, 25, 12, 22, 11, 90]. Print the sorted result.",
  "starter_code": "def merge_sort(arr):\n    if len(arr) <= 1:\n        return arr\n    mid = len(arr) // 2\n    left = merge_sort(arr[:mid])\n    right = merge_sort(arr[mid:])\n    return merge(left, right)\n\ndef merge(left, right):\n    result = []\n    i = j = 0\n    while i < len(left) and j < len(right):\n        if left[i] <= right[j]:\n            result.append(left[i])\n            i += 1\n        else:\n            result.append(right[j])\n            j += 1\n    result.extend(left[i:])\n    result.extend(right[j:])\n    return result\n\nprint(merge_sort([64, 34, 25, 12, 22, 11, 90]))",
  "expected_output": "[11, 12, 22, 25, 34, 64, 90]",
  "hints": [
    "Divide the array in half recursively until single elements",
    "Merge two sorted halves by comparing front elements",
    "Base case: array of length 0 or 1 is already sorted"
  ],
  "solution": "def merge_sort(arr):\n    if len(arr) <= 1:\n        return arr\n    mid = len(arr) // 2\n    left = merge_sort(arr[:mid])\n    right = merge_sort(arr[mid:])\n    return merge(left, right)\n\ndef merge(left, right):\n    result = []\n    i = j = 0\n    while i < len(left) and j < len(right):\n        if left[i] <= right[j]:\n            result.append(left[i])\n            i += 1\n        else:\n            result.append(right[j])\n            j += 1\n    result.extend(left[i:])\n    result.extend(right[j:])\n    return result\n\nprint(merge_sort([64, 34, 25, 12, 22, 11, 90]))"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Algorithms & Data Structures';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Queue Implementation', 'code', 25, 14, 'javascript',
$$
{
  "instructions": "Implement a Queue class with enqueue(val), dequeue(), peek(), and a size getter. Enqueue 1, 2, 3. Print dequeue result, peek result, then size.",
  "starter_code": "class Queue {\n  constructor() { this.items = []; }\n  enqueue(val) { this.items.push(val); }\n  dequeue() { return this.items.shift(); }\n  peek() { return this.items[0]; }\n  get size() { return this.items.length; }\n}\n\nconst q = new Queue();\nq.enqueue(1);\nq.enqueue(2);\nq.enqueue(3);\nconsole.log(q.dequeue());\nconsole.log(q.peek());\nconsole.log(q.size);",
  "expected_output": "1\n2\n2",
  "hints": [
    "Queue is FIFO: first in, first out",
    "enqueue adds to the end with push()",
    "dequeue removes from the front with shift()",
    "After dequeuing 1, peek sees 2 and size is 2"
  ],
  "solution": "class Queue {\n  constructor() { this.items = []; }\n  enqueue(val) { this.items.push(val); }\n  dequeue() { return this.items.shift(); }\n  peek() { return this.items[0]; }\n  get size() { return this.items.length; }\n}\n\nconst q = new Queue();\nq.enqueue(1);\nq.enqueue(2);\nq.enqueue(3);\nconsole.log(q.dequeue());\nconsole.log(q.peek());\nconsole.log(q.size);"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Algorithms & Data Structures';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Memoization', 'code', 25, 15, 'javascript',
$$
{
  "instructions": "Implement memoize(fn) that caches results by arguments. Use it to memoize a fibonacci function. Print fib(10).",
  "starter_code": "function memoize(fn) {\n  const cache = {};\n  return function(...args) {\n    const key = JSON.stringify(args);\n    if (key in cache) return cache[key];\n    return cache[key] = fn.apply(this, args);\n  };\n}\n\nconst fib = memoize(function(n) {\n  if (n <= 1) return n;\n  return fib(n - 1) + fib(n - 2);\n});\n\nconsole.log(fib(10));",
  "expected_output": "55",
  "hints": [
    "Memoization caches function results by serialized arguments",
    "fib(10) = 55",
    "The memoized version avoids redundant recursive calls"
  ],
  "solution": "function memoize(fn) {\n  const cache = {};\n  return function(...args) {\n    const key = JSON.stringify(args);\n    if (key in cache) return cache[key];\n    return cache[key] = fn.apply(this, args);\n  };\n}\n\nconst fib = memoize(function(n) {\n  if (n <= 1) return n;\n  return fib(n - 1) + fib(n - 2);\n});\n\nconsole.log(fib(10));"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Algorithms & Data Structures';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Generic Queue', 'code', 25, 16, 'typescript',
$$
{
  "instructions": "Implement class Queue<T> with typed enqueue, dequeue, peek, and size. Enqueue 10, 20, 30. Dequeue. Print peek and size.",
  "starter_code": "class Queue<T> {\n  private items: T[] = [];\n  enqueue(item: T): void { this.items.push(item); }\n  dequeue(): T | undefined { return this.items.shift(); }\n  peek(): T | undefined { return this.items[0]; }\n  get size(): number { return this.items.length; }\n}\n\nconst q = new Queue<number>();\nq.enqueue(10);\nq.enqueue(20);\nq.enqueue(30);\nq.dequeue();\nconsole.log(q.peek());\nconsole.log(q.size);",
  "expected_output": "20\n2",
  "hints": [
    "Generic Queue<T> works with any type parameter",
    "After dequeuing 10, the queue has [20, 30]",
    "peek() returns 20, size is 2"
  ],
  "solution": "class Queue<T> {\n  private items: T[] = [];\n  enqueue(item: T): void { this.items.push(item); }\n  dequeue(): T | undefined { return this.items.shift(); }\n  peek(): T | undefined { return this.items[0]; }\n  get size(): number { return this.items.length; }\n}\n\nconst q = new Queue<number>();\nq.enqueue(10);\nq.enqueue(20);\nq.enqueue(30);\nq.dequeue();\nconsole.log(q.peek());\nconsole.log(q.size);"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Algorithms & Data Structures';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: MinHeap', 'code', 25, 17, 'typescript',
$$
{
  "instructions": "Implement class MinHeap with insert(val) and extractMin(). Insert 5, 3, 8, 1, 4. Extract the minimum 3 times and print each.",
  "starter_code": "class MinHeap {\n  private heap: number[] = [];\n\n  insert(val: number): void {\n    this.heap.push(val);\n    this.bubbleUp(this.heap.length - 1);\n  }\n\n  extractMin(): number | undefined {\n    if (this.heap.length === 0) return undefined;\n    const min = this.heap[0];\n    const last = this.heap.pop()!;\n    if (this.heap.length > 0) {\n      this.heap[0] = last;\n      this.sinkDown(0);\n    }\n    return min;\n  }\n\n  private bubbleUp(i: number): void {\n    while (i > 0) {\n      const parent = Math.floor((i - 1) / 2);\n      if (this.heap[parent] > this.heap[i]) {\n        [this.heap[parent], this.heap[i]] = [this.heap[i], this.heap[parent]];\n        i = parent;\n      } else break;\n    }\n  }\n\n  private sinkDown(i: number): void {\n    const n = this.heap.length;\n    while (true) {\n      let min = i;\n      const l = 2*i+1, r = 2*i+2;\n      if (l < n && this.heap[l] < this.heap[min]) min = l;\n      if (r < n && this.heap[r] < this.heap[min]) min = r;\n      if (min === i) break;\n      [this.heap[min], this.heap[i]] = [this.heap[i], this.heap[min]];\n      i = min;\n    }\n  }\n}\n\nconst h = new MinHeap();\n[5,3,8,1,4].forEach(v => h.insert(v));\nconsole.log(h.extractMin());\nconsole.log(h.extractMin());\nconsole.log(h.extractMin());",
  "expected_output": "1\n3\n4",
  "hints": [
    "A min-heap always has the smallest value at the top",
    "insert then bubble up to maintain heap property",
    "extractMin removes the root and sinks down the replacement"
  ],
  "solution": "class MinHeap {\n  private heap: number[] = [];\n\n  insert(val: number): void {\n    this.heap.push(val);\n    this.bubbleUp(this.heap.length - 1);\n  }\n\n  extractMin(): number | undefined {\n    if (this.heap.length === 0) return undefined;\n    const min = this.heap[0];\n    const last = this.heap.pop()!;\n    if (this.heap.length > 0) {\n      this.heap[0] = last;\n      this.sinkDown(0);\n    }\n    return min;\n  }\n\n  private bubbleUp(i: number): void {\n    while (i > 0) {\n      const parent = Math.floor((i - 1) / 2);\n      if (this.heap[parent] > this.heap[i]) {\n        [this.heap[parent], this.heap[i]] = [this.heap[i], this.heap[parent]];\n        i = parent;\n      } else break;\n    }\n  }\n\n  private sinkDown(i: number): void {\n    const n = this.heap.length;\n    while (true) {\n      let min = i;\n      const l = 2*i+1, r = 2*i+2;\n      if (l < n && this.heap[l] < this.heap[min]) min = l;\n      if (r < n && this.heap[r] < this.heap[min]) min = r;\n      if (min === i) break;\n      [this.heap[min], this.heap[i]] = [this.heap[i], this.heap[min]];\n      i = min;\n    }\n  }\n}\n\nconst h = new MinHeap();\n[5,3,8,1,4].forEach(v => h.insert(v));\nconsole.log(h.extractMin());\nconsole.log(h.extractMin());\nconsole.log(h.extractMin());"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Algorithms & Data Structures';

-- ============================================================
-- TOPIC: Generators & Iterators
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: Generator Pipeline', 'code', 25, 12, 'python',
$$
{
  "instructions": "Create a generator pipeline: numbers(n) yields 1 to n-1, even_filter(it) yields only even values, squared(it) yields their squares. Print the first 5 results from the pipeline starting at numbers(20).",
  "starter_code": "import itertools\n\ndef numbers(n):\n    for i in range(1, n):\n        yield i\n\ndef even_filter(it):\n    for val in it:\n        if val % 2 == 0:\n            yield val\n\ndef squared(it):\n    for val in it:\n        yield val ** 2\n\nresult = itertools.islice(squared(even_filter(numbers(20))), 5)\nfor val in result:\n    print(val)",
  "expected_output": "4\n16\n36\n64\n100",
  "hints": [
    "Chain generators: squared(even_filter(numbers(20)))",
    "Even numbers from 1-19: 2, 4, 6, 8, 10",
    "Their squares: 4, 16, 36, 64, 100"
  ],
  "solution": "import itertools\n\ndef numbers(n):\n    for i in range(1, n):\n        yield i\n\ndef even_filter(it):\n    for val in it:\n        if val % 2 == 0:\n            yield val\n\ndef squared(it):\n    for val in it:\n        yield val ** 2\n\nresult = itertools.islice(squared(even_filter(numbers(20))), 5)\nfor val in result:\n    print(val)"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Generators & Iterators';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: send() to Generator', 'code', 25, 13, 'python',
$$
{
  "instructions": "Create a generator accumulator() that uses yield to receive values via send(). Send 10, 20, 30 and print the running total each time: 10, 30, 60.",
  "starter_code": "def accumulator():\n    total = 0\n    while True:\n        value = yield total\n        if value is None:\n            break\n        total += value\n\ngen = accumulator()\nnext(gen)  # prime the generator\nprint(gen.send(10))\nprint(gen.send(20))\nprint(gen.send(30))",
  "expected_output": "10\n30\n60",
  "hints": [
    "Call next(gen) first to advance to the first yield (priming)",
    "gen.send(value) resumes the generator and passes a value in",
    "The yield expression evaluates to the sent value; add it to total"
  ],
  "solution": "def accumulator():\n    total = 0\n    while True:\n        value = yield total\n        if value is None:\n            break\n        total += value\n\ngen = accumulator()\nnext(gen)\nprint(gen.send(10))\nprint(gen.send(20))\nprint(gen.send(30))"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Generators & Iterators';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Paginate Generator', 'code', 20, 14, 'javascript',
$$
{
  "instructions": "Write a generator function* paginate(items, pageSize) that yields subarrays of pageSize items. Call it with [1..9] and pageSize 3. Print each page as JSON.",
  "starter_code": "function* paginate(items, pageSize) {\n  for (let i = 0; i < items.length; i += pageSize) {\n    yield items.slice(i, i + pageSize);\n  }\n}\n\nfor (const page of paginate([1,2,3,4,5,6,7,8,9], 3)) {\n  console.log(JSON.stringify(page));\n}",
  "expected_output": "[1,2,3]\n[4,5,6]\n[7,8,9]",
  "hints": [
    "Slice from i to i+pageSize on each iteration",
    "yield the slice",
    "JSON.stringify([1,2,3]) = '[1,2,3]'"
  ],
  "solution": "function* paginate(items, pageSize) {\n  for (let i = 0; i < items.length; i += pageSize) {\n    yield items.slice(i, i + pageSize);\n  }\n}\n\nfor (const page of paginate([1,2,3,4,5,6,7,8,9], 3)) {\n  console.log(JSON.stringify(page));\n}"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Generators & Iterators';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Generator Protocol', 'code', 20, 15, 'javascript',
$$
{
  "instructions": "Implement class Range with *[Symbol.iterator]() generator method. Use for...of on new Range(1, 6) to print 1 through 5.",
  "starter_code": "class Range {\n  constructor(start, end) {\n    this.start = start;\n    this.end = end;\n  }\n  *[Symbol.iterator]() {\n    for (let i = this.start; i < this.end; i++) {\n      yield i;\n    }\n  }\n}\n\nfor (const n of new Range(1, 6)) {\n  console.log(n);\n}",
  "expected_output": "1\n2\n3\n4\n5",
  "hints": [
    "*[Symbol.iterator]() is a generator method syntax",
    "yield each value in the loop",
    "Range(1, 6) yields 1, 2, 3, 4, 5 (exclusive end)"
  ],
  "solution": "class Range {\n  constructor(start, end) {\n    this.start = start;\n    this.end = end;\n  }\n  *[Symbol.iterator]() {\n    for (let i = this.start; i < this.end; i++) {\n      yield i;\n    }\n  }\n}\n\nfor (const n of new Range(1, 6)) {\n  console.log(n);\n}"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Generators & Iterators';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Typed Generator Pipeline', 'code', 25, 16, 'typescript',
$$
{
  "instructions": "Write function* naturals(): Generator<number> (yields 1,2,3,...) and function* take<T>(gen, n): Generator<T>. Take the first 5 naturals, sum them, print.",
  "starter_code": "function* naturals(): Generator<number> {\n  let n = 1;\n  while (true) yield n++;\n}\n\nfunction* take<T>(gen: Iterable<T>, n: number): Generator<T> {\n  let count = 0;\n  for (const val of gen) {\n    if (count++ >= n) break;\n    yield val;\n  }\n}\n\nconst sum = [...take(naturals(), 5)].reduce((a, b) => a + b, 0);\nconsole.log(sum);",
  "expected_output": "15",
  "hints": [
    "naturals() yields 1, 2, 3, 4, 5, ...",
    "take(naturals(), 5) yields the first 5: [1,2,3,4,5]",
    "1+2+3+4+5 = 15"
  ],
  "solution": "function* naturals(): Generator<number> {\n  let n = 1;\n  while (true) yield n++;\n}\n\nfunction* take<T>(gen: Iterable<T>, n: number): Generator<T> {\n  let count = 0;\n  for (const val of gen) {\n    if (count++ >= n) break;\n    yield val;\n  }\n}\n\nconst sum = [...take(naturals(), 5)].reduce((a, b) => a + b, 0);\nconsole.log(sum);"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Generators & Iterators';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Typed Range Generator', 'code', 25, 17, 'typescript',
$$
{
  "instructions": "Write function* syncRange(start: number, end: number): Generator<number> that yields start through end inclusive. Print each value.",
  "starter_code": "function* syncRange(start: number, end: number): Generator<number> {\n  for (let i = start; i <= end; i++) {\n    yield i;\n  }\n}\n\nfor (const n of syncRange(1, 5)) {\n  console.log(n);\n}",
  "expected_output": "1\n2\n3\n4\n5",
  "hints": [
    "Generator<number> is the return type for a generator yielding numbers",
    "yield i inside a for loop from start to end",
    "for...of automatically consumes the generator"
  ],
  "solution": "function* syncRange(start: number, end: number): Generator<number> {\n  for (let i = start; i <= end; i++) {\n    yield i;\n  }\n}\n\nfor (const n of syncRange(1, 5)) {\n  console.log(n);\n}"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Generators & Iterators';

-- ============================================================
-- TOPIC: Decorators
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: Retry Decorator', 'code', 25, 12, 'python',
$$
{
  "instructions": "Write a @retry(times=3) decorator that retries a function on exception. The decorated function should fail twice then succeed (use a list as a mutable counter). Print 'Attempt 1', 'Attempt 2', 'Attempt 3', then 'Success!'.",
  "starter_code": "def retry(times):\n    def decorator(func):\n        def wrapper(*args, **kwargs):\n            for attempt in range(1, times + 1):\n                try:\n                    return func(*args, **kwargs)\n                except Exception:\n                    if attempt == times:\n                        raise\n        return wrapper\n    return decorator\n\ncounter = [0]\n\n@retry(times=3)\ndef flaky():\n    counter[0] += 1\n    print(f\"Attempt {counter[0]}\")\n    if counter[0] < 3:\n        raise ValueError(\"not yet\")\n    print(\"Success!\")\n\nflaky()",
  "expected_output": "Attempt 1\nAttempt 2\nAttempt 3\nSuccess!",
  "hints": [
    "Use a list [0] as a mutable counter so the closure can modify it",
    "The decorator loops up to 'times' attempts",
    "On the 3rd attempt, counter[0] == 3 and no exception is raised"
  ],
  "solution": "def retry(times):\n    def decorator(func):\n        def wrapper(*args, **kwargs):\n            for attempt in range(1, times + 1):\n                try:\n                    return func(*args, **kwargs)\n                except Exception:\n                    if attempt == times:\n                        raise\n        return wrapper\n    return decorator\n\ncounter = [0]\n\n@retry(times=3)\ndef flaky():\n    counter[0] += 1\n    print(f\"Attempt {counter[0]}\")\n    if counter[0] < 3:\n        raise ValueError(\"not yet\")\n    print(\"Success!\")\n\nflaky()"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Decorators';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: Decorator with Arguments', 'code', 25, 13, 'python',
$$
{
  "instructions": "Write @validate_range(min_val, max_val) decorator that validates the first argument. Apply @validate_range(0, 100) to set_volume(vol). Call set_volume(50) and set_volume(150).",
  "starter_code": "def validate_range(min_val, max_val):\n    def decorator(func):\n        def wrapper(val, *args, **kwargs):\n            if not (min_val <= val <= max_val):\n                print(f\"Error: {val} out of range [{min_val}, {max_val}]\")\n                return\n            return func(val, *args, **kwargs)\n        return wrapper\n    return decorator\n\n@validate_range(0, 100)\ndef set_volume(vol):\n    print(f\"Volume: {vol}\")\n\nset_volume(50)\nset_volume(150)",
  "expected_output": "Volume: 50\nError: 150 out of range [0, 100]",
  "hints": [
    "validate_range(0, 100) returns a decorator",
    "The decorator's wrapper checks if val is in [min_val, max_val]",
    "If out of range, print the error message and return early"
  ],
  "solution": "def validate_range(min_val, max_val):\n    def decorator(func):\n        def wrapper(val, *args, **kwargs):\n            if not (min_val <= val <= max_val):\n                print(f\"Error: {val} out of range [{min_val}, {max_val}]\")\n                return\n            return func(val, *args, **kwargs)\n        return wrapper\n    return decorator\n\n@validate_range(0, 100)\ndef set_volume(vol):\n    print(f\"Volume: {vol}\")\n\nset_volume(50)\nset_volume(150)"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Decorators';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Composable Middleware (pipe)', 'code', 20, 14, 'javascript',
$$
{
  "instructions": "Implement pipe(...fns) = x => fns.reduce((v, f) => f(v), x). Call pipe(x => x*2, x => x+1, x => x**2)(3). Print the result.",
  "starter_code": "const pipe = (...fns) => x => fns.reduce((v, f) => f(v), x);\n\nconst result = pipe(\n  x => x * 2,\n  x => x + 1,\n  x => x ** 2\n)(3);\n\nconsole.log(result);",
  "expected_output": "49",
  "hints": [
    "pipe applies functions left to right",
    "3 * 2 = 6, then 6 + 1 = 7, then 7 ** 2 = 49",
    "reduce threads the value through each function"
  ],
  "solution": "const pipe = (...fns) => x => fns.reduce((v, f) => f(v), x);\n\nconst result = pipe(\n  x => x * 2,\n  x => x + 1,\n  x => x ** 2\n)(3);\n\nconsole.log(result);"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Decorators';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: once() Function Wrapper', 'code', 20, 15, 'javascript',
$$
{
  "instructions": "Implement once(fn) — a wrapper that calls fn only the first time, ignoring subsequent calls. Let count = 0. Create const increment = once(() => { count++; }). Call it 3 times. Print count.",
  "starter_code": "function once(fn) {\n  let called = false;\n  return function(...args) {\n    if (!called) {\n      called = true;\n      return fn.apply(this, args);\n    }\n  };\n}\n\nlet count = 0;\nconst increment = once(() => { count++; });\nincrement();\nincrement();\nincrement();\nconsole.log(count);",
  "expected_output": "1",
  "hints": [
    "once() uses a closure variable 'called' to track if fn was invoked",
    "The first call sets called = true and runs fn",
    "Subsequent calls see called === true and do nothing"
  ],
  "solution": "function once(fn) {\n  let called = false;\n  return function(...args) {\n    if (!called) {\n      called = true;\n      return fn.apply(this, args);\n    }\n  };\n}\n\nlet count = 0;\nconst increment = once(() => { count++; });\nincrement();\nincrement();\nincrement();\nconsole.log(count);"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Decorators';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Readonly Property with defineProperty', 'code', 20, 16, 'typescript',
$$
{
  "instructions": "Use Object.defineProperty to create a readonly property 'value' on an object. Set it to 'original'. Try to reassign it (it will silently fail in non-strict mode). Print 'original' twice.",
  "starter_code": "const obj: { value?: string } = {};\nObject.defineProperty(obj, 'value', {\n  value: 'original',\n  writable: false,\n  configurable: false\n});\nconsole.log(obj.value);\n(obj as any).value = 'changed'; // silently ignored\nconsole.log(obj.value);",
  "expected_output": "original\noriginal",
  "hints": [
    "Object.defineProperty with writable: false prevents reassignment",
    "In non-strict mode, reassignment silently fails",
    "Both console.log calls print 'original' because the value is protected"
  ],
  "solution": "const obj: { value?: string } = {};\nObject.defineProperty(obj, 'value', {\n  value: 'original',\n  writable: false,\n  configurable: false\n});\nconsole.log(obj.value);\n(obj as any).value = 'changed';\nconsole.log(obj.value);"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Decorators';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Decorator Factory (HOF)', 'code', 25, 17, 'typescript',
$$
{
  "instructions": "Implement log(prefix: string) as a higher-order function that wraps a function to log its result. const loggedAdd = log(\"ADD\")(add) where add(a,b) = a+b. Call loggedAdd(3, 4) to print '[ADD] result: 7'.",
  "starter_code": "function log(prefix: string) {\n  return function<T extends (...args: number[]) => number>(fn: T) {\n    return function(...args: number[]): number {\n      const result = fn(...args);\n      console.log(`[${prefix}] result: ${result}`);\n      return result;\n    };\n  };\n}\n\nconst add = (a: number, b: number) => a + b;\nconst loggedAdd = log(\"ADD\")(add);\nloggedAdd(3, 4);",
  "expected_output": "[ADD] result: 7",
  "hints": [
    "log(prefix) returns a decorator function",
    "The decorator wraps fn, calls it, then logs the result",
    "3 + 4 = 7"
  ],
  "solution": "function log(prefix: string) {\n  return function<T extends (...args: number[]) => number>(fn: T) {\n    return function(...args: number[]): number {\n      const result = fn(...args);\n      console.log(`[${prefix}] result: ${result}`);\n      return result;\n    };\n  };\n}\n\nconst add = (a: number, b: number) => a + b;\nconst loggedAdd = log(\"ADD\")(add);\nloggedAdd(3, 4);"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Decorators';

-- ============================================================
-- TOPIC: Regular Expressions
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: Named Groups', 'code', 20, 12, 'python',
$$
{
  "instructions": "Use a regex with named groups to parse '2024-01-15' into year, month, day. Print: Year: 2024, Month: 01, Day: 15",
  "starter_code": "import re\n\ndate_str = '2024-01-15'\npattern = r'(?P<year>\\d{4})-(?P<month>\\d{2})-(?P<day>\\d{2})'\nm = re.match(pattern, date_str)\nprint(f\"Year: {m.group('year')}, Month: {m.group('month')}, Day: {m.group('day')}\")",
  "expected_output": "Year: 2024, Month: 01, Day: 15",
  "hints": [
    "Named groups use (?P<name>pattern) syntax",
    "Access named groups with m.group('name')",
    "\\d{4} matches exactly 4 digits"
  ],
  "solution": "import re\n\ndate_str = '2024-01-15'\npattern = r'(?P<year>\\d{4})-(?P<month>\\d{2})-(?P<day>\\d{2})'\nm = re.match(pattern, date_str)\nprint(f\"Year: {m.group('year')}, Month: {m.group('month')}, Day: {m.group('day')}\")"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Regular Expressions';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'Python: re.sub with Function', 'code', 20, 13, 'python',
$$
{
  "instructions": "Use re.sub with a lambda to double every number in a string. s = 'I have 3 cats and 7 dogs'. Print the result.",
  "starter_code": "import re\n\ns = 'I have 3 cats and 7 dogs'\nresult = re.sub(r'\\d+', lambda m: str(int(m.group()) * 2), s)\nprint(result)",
  "expected_output": "I have 6 cats and 14 dogs",
  "hints": [
    "re.sub can take a function as its replacement argument",
    "The function receives a match object m",
    "int(m.group()) converts the matched string to int, then multiply by 2"
  ],
  "solution": "import re\n\ns = 'I have 3 cats and 7 dogs'\nresult = re.sub(r'\\d+', lambda m: str(int(m.group()) * 2), s)\nprint(result)"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Regular Expressions';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Regex Named Groups', 'code', 20, 14, 'javascript',
$$
{
  "instructions": "Parse '2024-01-15' using a regex with named groups. Print match.groups.year, month, and day each on its own line.",
  "starter_code": "const dateStr = '2024-01-15';\nconst match = dateStr.match(/(?<year>\\d{4})-(?<month>\\d{2})-(?<day>\\d{2})/);\nconsole.log(match.groups.year);\nconsole.log(match.groups.month);\nconsole.log(match.groups.day);",
  "expected_output": "2024\n01\n15",
  "hints": [
    "Named groups in JS regex: (?<name>pattern)",
    "Access via match.groups.name",
    "\\d{4} matches 4 digits, \\d{2} matches 2 digits"
  ],
  "solution": "const dateStr = '2024-01-15';\nconst match = dateStr.match(/(?<year>\\d{4})-(?<month>\\d{2})-(?<day>\\d{2})/);\nconsole.log(match.groups.year);\nconsole.log(match.groups.month);\nconsole.log(match.groups.day);"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Regular Expressions';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'JS: Global Replace with Function', 'code', 20, 15, 'javascript',
$$
{
  "instructions": "Replace each word in 'foo bar baz' with its uppercase version using String.replace() with a global regex and a function. Print the result.",
  "starter_code": "const text = 'foo bar baz';\nconst result = text.replace(/\\b\\w+\\b/g, word => word.toUpperCase());\nconsole.log(result);",
  "expected_output": "FOO BAR BAZ",
  "hints": [
    "The /g flag makes replace() replace all matches",
    "\\b\\w+\\b matches whole words",
    "Pass a function as the second argument: word => word.toUpperCase()"
  ],
  "solution": "const text = 'foo bar baz';\nconst result = text.replace(/\\b\\w+\\b/g, word => word.toUpperCase());\nconsole.log(result);"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Regular Expressions';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Typed Regex Result', 'code', 20, 16, 'typescript',
$$
{
  "instructions": "Define interface DateParts { year: string; month: string; day: string }. Write function parseDate(s: string): DateParts | null using named groups. Test with '2024-03-15' and print year.",
  "starter_code": "interface DateParts { year: string; month: string; day: string }\n\nfunction parseDate(s: string): DateParts | null {\n  const m = s.match(/(?<year>\\d{4})-(?<month>\\d{2})-(?<day>\\d{2})/);\n  if (!m || !m.groups) return null;\n  return m.groups as DateParts;\n}\n\nconst d = parseDate('2024-03-15');\nif (d) console.log(d.year);",
  "expected_output": "2024",
  "hints": [
    "match() returns null if no match, so check with !m",
    "m.groups contains the named capture groups",
    "Cast as DateParts since TypeScript types groups as Record<string,string>"
  ],
  "solution": "interface DateParts { year: string; month: string; day: string }\n\nfunction parseDate(s: string): DateParts | null {\n  const m = s.match(/(?<year>\\d{4})-(?<month>\\d{2})-(?<day>\\d{2})/);\n  if (!m || !m.groups) return null;\n  return m.groups as DateParts;\n}\n\nconst d = parseDate('2024-03-15');\nif (d) console.log(d.year);"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Regular Expressions';

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, language, content_json)
SELECT t.id, 'TS: Email Validator', 'code', 20, 17, 'typescript',
$$
{
  "instructions": "Write function isValidEmail(email: string): boolean using a regex. Test 'user@example.com' (true) and 'invalid-email' (false). Print each result.",
  "starter_code": "function isValidEmail(email: string): boolean {\n  return /^[\\w.+-]+@[\\w-]+\\.[\\w.]+$/.test(email);\n}\n\nconsole.log(isValidEmail('user@example.com'));\nconsole.log(isValidEmail('invalid-email'));",
  "expected_output": "true\nfalse",
  "hints": [
    "The regex must match: local-part @ domain . tld",
    "/^[\\w.+-]+@[\\w-]+\\.[\\w.]+$/ is a simple email pattern",
    ".test(email) returns true if the regex matches"
  ],
  "solution": "function isValidEmail(email: string): boolean {\n  return /^[\\w.+-]+@[\\w-]+\\.[\\w.]+$/.test(email);\n}\n\nconsole.log(isValidEmail('user@example.com'));\nconsole.log(isValidEmail('invalid-email'));"
}
$$::jsonb
FROM public.topics t WHERE t.title = 'Regular Expressions';
