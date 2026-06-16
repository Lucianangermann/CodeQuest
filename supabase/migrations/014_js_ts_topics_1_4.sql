-- 014: JavaScript and TypeScript code lessons for Topics 1-4
-- Each topic gets 3 JS lessons (order_index 6,7,8) and 3 TS lessons (order_index 9,10,11)
-- Theory (order 1) and Quiz (order 2) are language-agnostic and already exist
-- Python lessons occupy order_index 3,4,5

-- ============================================================
-- TOPIC 1: Variables — JavaScript
-- ============================================================

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(1, 'JS: Declare Variables', 'code',
$${"instructions": "Declare a const variable called name with the value \"Alice\" and a let variable called age with the value 25.\n\nThen print each on its own line.\n\nExpected output:\nAlice\n25", "starter_code": "// Declare your variables here\n// const name = ...\n// let age = ...\n\nconsole.log(name);\nconsole.log(age);", "expected_output": "Alice\n25", "hints": ["Use const for values that won't change, like name", "Use let for values that might change, like age", "Assign the string \"Alice\" to name and the number 25 to age"], "solution": "const name = \"Alice\";\nlet age = 25;\n\nconsole.log(name);\nconsole.log(age);"}$$::jsonb,
20, 6, 'javascript');

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(1, 'JS: String Interpolation', 'code',
$${"instructions": "Use a template literal to build a greeting string and print it.\n\nGiven:\n  const name = \"Alice\";\n  const age = 25;\n\nExpected output:\nHello, Alice! You are 25 years old.", "starter_code": "const name = \"Alice\";\nconst age = 25;\n\n// Use a template literal (backticks) to build the greeting\nconst greeting = ``;\n\nconsole.log(greeting);", "expected_output": "Hello, Alice! You are 25 years old.", "hints": ["Template literals use backtick characters (`), not quotes", "Embed variables with ${variableName} inside the backticks", "The format is: `Hello, ${name}! You are ${age} years old.`"], "solution": "const name = \"Alice\";\nconst age = 25;\n\nconst greeting = `Hello, ${name}! You are ${age} years old.`;\n\nconsole.log(greeting);"}$$::jsonb,
20, 7, 'javascript');

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(1, 'JS: Swap Two Variables', 'code',
$${"instructions": "Swap the values of two variables using destructuring assignment, then print both before and after.\n\nExpected output:\n5\n10\n10\n5", "starter_code": "let a = 5;\nlet b = 10;\n\nconsole.log(a);\nconsole.log(b);\n\n// Swap a and b using destructuring: [a, b] = [b, a]\n\nconsole.log(a);\nconsole.log(b);", "expected_output": "5\n10\n10\n5", "hints": ["Destructuring lets you swap in one line: [a, b] = [b, a]", "No temporary variable needed with destructuring", "The swap happens between the two pairs of console.log calls"], "solution": "let a = 5;\nlet b = 10;\n\nconsole.log(a);\nconsole.log(b);\n\n[a, b] = [b, a];\n\nconsole.log(a);\nconsole.log(b);"}$$::jsonb,
25, 8, 'javascript');

-- ============================================================
-- TOPIC 1: Variables — TypeScript
-- ============================================================

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(1, 'TS: Typed Variables', 'code',
$${"instructions": "Declare typed variables and print them.\n\nDeclare:\n  const name: string = \"Alice\"\n  const age: number = 25\n\nThen print each on its own line.\n\nExpected output:\nAlice\n25", "starter_code": "// Declare typed variables\n// const name: string = ...\n// const age: number = ...\n\nconsole.log(name);\nconsole.log(age);", "expected_output": "Alice\n25", "hints": ["TypeScript type annotations come after the variable name with a colon: const name: string", "Strings get the type string, whole/decimal numbers get number", "Assign \"Alice\" to name and 25 to age"], "solution": "const name: string = \"Alice\";\nconst age: number = 25;\n\nconsole.log(name);\nconsole.log(age);"}$$::jsonb,
20, 9, 'typescript');

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(1, 'TS: Type Annotations', 'code',
$${"instructions": "Declare typed boolean and number variables, then print them.\n\nDeclare:\n  const isLoggedIn: boolean = true\n  const score: number = 99.5\n\nExpected output:\ntrue\n99.5", "starter_code": "// Declare a boolean and a number with type annotations\n// const isLoggedIn: boolean = ...\n// const score: number = ...\n\nconsole.log(isLoggedIn);\nconsole.log(score);", "expected_output": "true\n99.5", "hints": ["Boolean type annotation is written as boolean (lowercase)", "Decimal numbers are typed as number in TypeScript", "true is a boolean literal — no quotes needed"], "solution": "const isLoggedIn: boolean = true;\nconst score: number = 99.5;\n\nconsole.log(isLoggedIn);\nconsole.log(score);"}$$::jsonb,
20, 10, 'typescript');

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(1, 'TS: Union Types', 'code',
$${"instructions": "Declare a variable with a union type that can hold either a number or a string.\n\nDeclare let id: string | number = 42, print it.\nThen reassign id to \"abc123\" and print again.\n\nExpected output:\n42\nabc123", "starter_code": "// Declare id with a union type: string | number\n// let id: string | number = 42\n\n// Print id\n\n// Reassign id to \"abc123\"\n\n// Print id again", "expected_output": "42\nabc123", "hints": ["Union types use the pipe symbol: string | number", "Use let (not const) so you can reassign the variable", "After printing 42, reassign id = \"abc123\" before the second print"], "solution": "let id: string | number = 42;\nconsole.log(id);\n\nid = \"abc123\";\nconsole.log(id);"}$$::jsonb,
25, 11, 'typescript');

-- ============================================================
-- TOPIC 2: Data Types — JavaScript
-- ============================================================

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(2, 'JS: Explore Data Types', 'code',
$${"instructions": "JavaScript has several built-in data types. Use typeof to check each one.\n\nExpected output:\nstring\nnumber\nboolean\nobject\nundefined", "starter_code": "const text = \"hello\";\nconst num = 42;\nconst flag = true;\nconst nothing = null;\nlet undef;\n\n// Print the typeof each variable\nconsole.log(typeof text);\nconsole.log(typeof num);\nconsole.log(typeof flag);\nconsole.log(typeof nothing);\nconsole.log(typeof undef);", "expected_output": "string\nnumber\nboolean\nobject\nundefined", "hints": ["typeof returns a string describing the type", "In JavaScript, typeof null is \"object\" — this is a well-known quirk", "An undeclared or uninitialized variable has type \"undefined\""], "solution": "const text = \"hello\";\nconst num = 42;\nconst flag = true;\nconst nothing = null;\nlet undef;\n\nconsole.log(typeof text);\nconsole.log(typeof num);\nconsole.log(typeof flag);\nconsole.log(typeof nothing);\nconsole.log(typeof undef);"}$$::jsonb,
20, 6, 'javascript');

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(2, 'JS: Type Conversion', 'code',
$${"instructions": "Convert between types using built-in functions.\n\n1. Convert string \"42\" to number with Number()\n2. Convert 3.99 to integer with Math.floor()\n3. Convert number 100 to string with String(), then print its length... wait, just print the number 100 as a string\n\nExpected output:\n42\n3\n100", "starter_code": "// Convert string to number\nconst strNum = \"42\";\nconst asNumber = Number(strNum);\nconsole.log(asNumber);\n\n// Floor a decimal\nconst decimal = 3.99;\nconsole.log(Math.floor(decimal));\n\n// Convert number to string and print\nconst n = 100;\nconsole.log(String(n));", "expected_output": "42\n3\n100", "hints": ["Number(\"42\") converts the string to the number 42", "Math.floor() rounds down to the nearest integer", "String(100) converts the number 100 to the string \"100\""], "solution": "const strNum = \"42\";\nconst asNumber = Number(strNum);\nconsole.log(asNumber);\n\nconst decimal = 3.99;\nconsole.log(Math.floor(decimal));\n\nconst n = 100;\nconsole.log(String(n));"}$$::jsonb,
20, 7, 'javascript');

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(2, 'JS: NaN and Infinity', 'code',
$${"instructions": "Explore two special numeric values in JavaScript: NaN and Infinity.\n\nExpected output:\nNaN\ntrue\nInfinity", "starter_code": "// NaN: Not a Number — result of invalid numeric operation\nconst bad = Number(\"abc\");\nconsole.log(bad);\n\n// Check if a value is NaN with isNaN()\nconsole.log(isNaN(bad));\n\n// Infinity: result of dividing by zero\nconst inf = 1 / 0;\nconsole.log(inf);", "expected_output": "NaN\ntrue\nInfinity", "hints": ["Number(\"abc\") returns NaN because \"abc\" is not a valid number", "Use isNaN() to test if a value is NaN — NaN !== NaN in JavaScript", "Dividing a positive number by 0 gives Infinity"], "solution": "const bad = Number(\"abc\");\nconsole.log(bad);\n\nconsole.log(isNaN(bad));\n\nconst inf = 1 / 0;\nconsole.log(inf);"}$$::jsonb,
25, 8, 'javascript');

-- ============================================================
-- TOPIC 2: Data Types — TypeScript
-- ============================================================

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(2, 'TS: Basic Types', 'code',
$${"instructions": "Declare variables with explicit TypeScript type annotations and print their typeof.\n\nExpected output:\nstring\nnumber\nboolean", "starter_code": "const greeting: string = \"hello\";\nconst count: number = 42;\nconst active: boolean = true;\n\n// Print the typeof each variable\nconsole.log(typeof greeting);\nconsole.log(typeof count);\nconsole.log(typeof active);", "expected_output": "string\nnumber\nboolean", "hints": ["TypeScript type annotations don't change the runtime typeof output", "typeof always returns a lowercase string like \"string\", \"number\", \"boolean\"", "The code is already written — just run it to see the output"], "solution": "const greeting: string = \"hello\";\nconst count: number = 42;\nconst active: boolean = true;\n\nconsole.log(typeof greeting);\nconsole.log(typeof count);\nconsole.log(typeof active);"}$$::jsonb,
20, 9, 'typescript');

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(2, 'TS: Arrays and Tuples', 'code',
$${"instructions": "TypeScript supports typed arrays and fixed-length tuples.\n\nDeclare:\n  const nums: number[] = [1, 2, 3]\n  const pair: [string, number] = [\"Alice\", 25]\n\nPrint nums, then pair[0], then pair[1].\n\nExpected output:\n1,2,3\nAlice\n25", "starter_code": "// Typed array\nconst nums: number[] = [1, 2, 3];\n\n// Tuple: fixed structure [string, number]\nconst pair: [string, number] = [\"Alice\", 25];\n\n// Print all three values\nconsole.log(nums);\nconsole.log(pair[0]);\nconsole.log(pair[1]);", "expected_output": "1,2,3\nAlice\n25", "hints": ["A typed array uses Type[] syntax, e.g. number[]", "A tuple uses [Type1, Type2] syntax for fixed-length arrays with known types", "console.log on an array prints its elements joined by commas: 1,2,3"], "solution": "const nums: number[] = [1, 2, 3];\nconst pair: [string, number] = [\"Alice\", 25];\n\nconsole.log(nums);\nconsole.log(pair[0]);\nconsole.log(pair[1]);"}$$::jsonb,
20, 10, 'typescript');

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(2, 'TS: Type Conversion', 'code',
$${"instructions": "Write a typed function that converts a string to a number, then use it.\n\nExpected output:\n42\n3", "starter_code": "// Write a function with proper TypeScript types\nfunction toNumber(val: string): number {\n  // Parse val as a number and return it\n  return 0; // replace this\n}\n\nconsole.log(toNumber(\"42\"));\nconsole.log(Math.floor(3.99));", "expected_output": "42\n3", "hints": ["Use Number(val) or parseInt(val) inside the function body", "The return type : number tells TypeScript what type this function returns", "Math.floor(3.99) rounds down to 3"], "solution": "function toNumber(val: string): number {\n  return Number(val);\n}\n\nconsole.log(toNumber(\"42\"));\nconsole.log(Math.floor(3.99));"}$$::jsonb,
25, 11, 'typescript');

-- ============================================================
-- TOPIC 3: Conditionals — JavaScript
-- ============================================================

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(3, 'JS: If/Else', 'code',
$${"instructions": "Use if/else to classify a score.\n\nGiven score = 75:\n- Print \"Excellent\" if score >= 90\n- Print \"Pass\" if score >= 60\n- Print \"Fail\" otherwise\n\nExpected output:\nPass", "starter_code": "const score = 75;\n\n// Write your if/else chain here\nif (score >= 90) {\n  console.log(\"Excellent\");\n} else if (score >= 60) {\n  // complete this branch\n} else {\n  // complete this branch\n}", "expected_output": "Pass", "hints": ["Check the highest threshold (>= 90) first, then lower ones", "score 75 is >= 60 but not >= 90, so it falls into the second branch", "Make sure the else if and else branches each have a console.log"], "solution": "const score = 75;\n\nif (score >= 90) {\n  console.log(\"Excellent\");\n} else if (score >= 60) {\n  console.log(\"Pass\");\n} else {\n  console.log(\"Fail\");\n}"}$$::jsonb,
20, 6, 'javascript');

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(3, 'JS: Ternary Operator', 'code',
$${"instructions": "Use the ternary operator to assign a value based on a condition.\n\nGiven age = 20, assign:\n  const status = age >= 18 ? \"adult\" : \"minor\"\n\nThen print status.\n\nExpected output:\nadult", "starter_code": "const age = 20;\n\n// Use the ternary operator: condition ? valueIfTrue : valueIfFalse\nconst status = age >= 18 ? \"adult\" : \"minor\";\n\nconsole.log(status);", "expected_output": "adult", "hints": ["The ternary operator is a compact if/else: condition ? a : b", "Since age is 20 and 20 >= 18 is true, status gets the first value", "No changes needed — just read through the code and run it"], "solution": "const age = 20;\n\nconst status = age >= 18 ? \"adult\" : \"minor\";\n\nconsole.log(status);"}$$::jsonb,
20, 7, 'javascript');

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(3, 'JS: Switch Statement', 'code',
$${"instructions": "Use a switch statement to label the day of the week.\n\nGiven day = \"Wednesday\", print the label:\n- \"Monday\" → \"Start of week\"\n- \"Wednesday\" → \"Midweek\"\n- \"Friday\" → \"End of week\"\n- anything else → \"Weekday\"\n\nExpected output:\nMidweek", "starter_code": "const day = \"Wednesday\";\n\nswitch (day) {\n  case \"Monday\":\n    console.log(\"Start of week\");\n    break;\n  case \"Wednesday\":\n    // add your code here\n    break;\n  case \"Friday\":\n    console.log(\"End of week\");\n    break;\n  default:\n    console.log(\"Weekday\");\n}", "expected_output": "Midweek", "hints": ["Each case needs a console.log and a break statement", "The case for \"Wednesday\" is already matched — just add the console.log", "Don't forget break to prevent fall-through to the next case"], "solution": "const day = \"Wednesday\";\n\nswitch (day) {\n  case \"Monday\":\n    console.log(\"Start of week\");\n    break;\n  case \"Wednesday\":\n    console.log(\"Midweek\");\n    break;\n  case \"Friday\":\n    console.log(\"End of week\");\n    break;\n  default:\n    console.log(\"Weekday\");\n}"}$$::jsonb,
25, 8, 'javascript');

-- ============================================================
-- TOPIC 3: Conditionals — TypeScript
-- ============================================================

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(3, 'TS: Typed Conditionals', 'code',
$${"instructions": "Write a typed function that classifies a score into a letter grade.\n\nFunction signature:\n  function classify(score: number): string\n\nRules: A (>=90), B (>=80), C (>=70), F otherwise.\n\nCall classify(85) and print the result.\n\nExpected output:\nB", "starter_code": "function classify(score: number): string {\n  // Return \"A\" for >= 90, \"B\" for >= 80, \"C\" for >= 70, \"F\" otherwise\n  return \"F\"; // replace with your logic\n}\n\nconsole.log(classify(85));", "expected_output": "B", "hints": ["Check >= 90 first, then >= 80, then >= 70, else return \"F\"", "Use if/else if/else inside the function body", "85 is >= 80 but not >= 90, so it should return \"B\""], "solution": "function classify(score: number): string {\n  if (score >= 90) return \"A\";\n  if (score >= 80) return \"B\";\n  if (score >= 70) return \"C\";\n  return \"F\";\n}\n\nconsole.log(classify(85));"}$$::jsonb,
20, 9, 'typescript');

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(3, 'TS: Nullish Coalescing', 'code',
$${"instructions": "Use the nullish coalescing operator (??) to provide a fallback when a value is null.\n\nDeclare:\n  const username: string | null = null\n\nUse ?? to get \"Guest\" if username is null, then print.\n\nExpected output:\nGuest", "starter_code": "const username: string | null = null;\n\n// Use ?? to fall back to \"Guest\" when username is null\nconst displayName = username ?? \"Guest\";\n\nconsole.log(displayName);", "expected_output": "Guest", "hints": ["The ?? operator returns the right-hand value when the left side is null or undefined", "Unlike ||, the ?? operator only triggers for null and undefined (not 0 or \"\")", "Since username is null, displayName will be \"Guest\""], "solution": "const username: string | null = null;\n\nconst displayName = username ?? \"Guest\";\n\nconsole.log(displayName);"}$$::jsonb,
20, 10, 'typescript');

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(3, 'TS: Type Narrowing', 'code',
$${"instructions": "Write a function that behaves differently depending on the type of its argument.\n\nFunction: printLength(val: string | number): void\n- If val is a string, print val.length\n- If val is a number, print val * 2\n\nCall with \"hello\" and 5.\n\nExpected output:\n5\n10", "starter_code": "function printLength(val: string | number): void {\n  if (typeof val === \"string\") {\n    // print the string's length\n  } else {\n    // print the number doubled\n  }\n}\n\nprintLength(\"hello\");\nprintLength(5);", "expected_output": "5\n10", "hints": ["Use typeof val === \"string\" to check if val is a string", "Inside the string branch, use val.length to get the character count", "In the else branch, val is narrowed to number, so val * 2 is valid"], "solution": "function printLength(val: string | number): void {\n  if (typeof val === \"string\") {\n    console.log(val.length);\n  } else {\n    console.log(val * 2);\n  }\n}\n\nprintLength(\"hello\");\nprintLength(5);"}$$::jsonb,
25, 11, 'typescript');

-- ============================================================
-- TOPIC 4: Loops — JavaScript
-- ============================================================

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(4, 'JS: For Loop', 'code',
$${"instructions": "Use a for loop to print the numbers 1 through 5, each on its own line.\n\nExpected output:\n1\n2\n3\n4\n5", "starter_code": "// Use a for loop: for (let i = 1; i <= 5; i++)\nfor (let i = 1; i <= 5; i++) {\n  // print i\n}", "expected_output": "1\n2\n3\n4\n5", "hints": ["The loop starts at 1 (let i = 1), runs while i <= 5, and increments with i++", "Put console.log(i) inside the loop body", "The loop runs 5 times: i = 1, 2, 3, 4, 5"], "solution": "for (let i = 1; i <= 5; i++) {\n  console.log(i);\n}"}$$::jsonb,
20, 6, 'javascript');

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(4, 'JS: Array forEach', 'code',
$${"instructions": "Use the forEach method to print each element of an array.\n\nExpected output:\napple\nbanana\ncherry", "starter_code": "const fruits = [\"apple\", \"banana\", \"cherry\"];\n\n// Use forEach to print each fruit\nfruits.forEach(function(fruit) {\n  // print fruit\n});", "expected_output": "apple\nbanana\ncherry", "hints": ["forEach calls your function once for each array element", "The parameter (fruit) receives the current element on each call", "Put console.log(fruit) inside the forEach callback"], "solution": "const fruits = [\"apple\", \"banana\", \"cherry\"];\n\nfruits.forEach(function(fruit) {\n  console.log(fruit);\n});"}$$::jsonb,
20, 7, 'javascript');

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(4, 'JS: While Loop with Accumulator', 'code',
$${"instructions": "Use a while loop to sum the numbers 1 through 10 and print the result.\n\nExpected output:\n55", "starter_code": "let total = 0;\nlet i = 1;\n\n// Add i to total while i <= 10, then increment i\nwhile (i <= 10) {\n  // add i to total\n  // increment i\n}\n\nconsole.log(total);", "expected_output": "55", "hints": ["Inside the loop: total += i; then i++;", "The loop condition is i <= 10, so it runs for i = 1, 2, ..., 10", "1+2+3+4+5+6+7+8+9+10 = 55"], "solution": "let total = 0;\nlet i = 1;\n\nwhile (i <= 10) {\n  total += i;\n  i++;\n}\n\nconsole.log(total);"}$$::jsonb,
25, 8, 'javascript');

-- ============================================================
-- TOPIC 4: Loops — TypeScript
-- ============================================================

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(4, 'TS: For...of Loop', 'code',
$${"instructions": "Use a for...of loop to iterate over a typed array and print each element.\n\nExpected output:\n10\n20\n30\n40\n50", "starter_code": "const scores: number[] = [10, 20, 30, 40, 50];\n\n// Use for...of to print each score\nfor (const score of scores) {\n  // print score\n}", "expected_output": "10\n20\n30\n40\n50", "hints": ["for...of iterates over the values of an iterable like an array", "The variable score receives each element in turn", "Put console.log(score) inside the loop body"], "solution": "const scores: number[] = [10, 20, 30, 40, 50];\n\nfor (const score of scores) {\n  console.log(score);\n}"}$$::jsonb,
20, 9, 'typescript');

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(4, 'TS: Array map and filter', 'code',
$${"instructions": "Use filter to keep only even numbers, then map to double each one.\n\nGiven: const nums: number[] = [1, 2, 3, 4, 5, 6]\n\nExpected output:\n4,8,12", "starter_code": "const nums: number[] = [1, 2, 3, 4, 5, 6];\n\n// Filter to keep only even numbers, then double each\nconst result = nums\n  .filter((n) => n % 2 === 0)\n  .map((n) => n * 2);\n\nconsole.log(result);", "expected_output": "4,8,12", "hints": ["filter keeps elements where the callback returns true", "n % 2 === 0 is true for even numbers (2, 4, 6)", "map transforms each element — multiply by 2 to double it, giving 4, 8, 12"], "solution": "const nums: number[] = [1, 2, 3, 4, 5, 6];\n\nconst result = nums\n  .filter((n) => n % 2 === 0)\n  .map((n) => n * 2);\n\nconsole.log(result);"}$$::jsonb,
20, 10, 'typescript');

INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(4, 'TS: Reduce', 'code',
$${"instructions": "Use the reduce method to compute the sum of an array of prices.\n\nGiven: const prices: number[] = [10, 25, 8, 42, 3]\n\nExpected output:\n88", "starter_code": "const prices: number[] = [10, 25, 8, 42, 3];\n\n// Use reduce to sum all prices\nconst total = prices.reduce((acc, price) => acc + price, 0);\n\nconsole.log(total);", "expected_output": "88", "hints": ["reduce takes a callback (acc, current) and an initial value (0)", "On each step, acc accumulates the running sum", "10 + 25 + 8 + 42 + 3 = 88"], "solution": "const prices: number[] = [10, 25, 8, 42, 3];\n\nconst total = prices.reduce((acc, price) => acc + price, 0);\n\nconsole.log(total);"}$$::jsonb,
25, 11, 'typescript');
