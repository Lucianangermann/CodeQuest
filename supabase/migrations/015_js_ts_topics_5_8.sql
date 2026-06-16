-- 015_js_ts_topics_5_8.sql
-- Adds 3 JavaScript + 3 TypeScript code lessons for Topics 5-8
-- JavaScript: order_index 6-8, TypeScript: order_index 9-11

-- ============================================================
-- TOPIC 5: Functions
-- ============================================================

-- JS Lesson 1: Arrow Function
INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(5, 'JS: Arrow Function', 'code',
$${"instructions": "Write an arrow function called `square` that takes a number `n` and returns `n * n`.\n\nPrint the result of calling square(7).\n\nExpected output:\n49", "starter_code": "const square = (n) => {\n  // Return n squared\n};\n\nconsole.log(square(7));", "expected_output": "49", "hints": ["Arrow functions use the syntax: const fn = (param) => expression", "For a single expression you can omit the curly braces and return keyword: (n) => n * n", "n * n multiplies n by itself"], "solution": "const square = (n) => n * n;\nconsole.log(square(7));"}$$::jsonb,
20, 6, 'javascript');

-- JS Lesson 2: Default Parameters
INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(5, 'JS: Default Parameters', 'code',
$${"instructions": "Write a function `greet` that takes a parameter `name` with a default value of `\"World\"`. It should print `Hello, <name>!`.\n\nCall `greet()` with no arguments.\n\nExpected output:\nHello, World!", "starter_code": "function greet(name = \"World\") {\n  // Print the greeting\n}\n\ngreet();", "expected_output": "Hello, World!", "hints": ["Default parameters are set in the function signature: function greet(name = \"World\")", "Use console.log to print the result", "Use a template literal: `Hello, ${name}!`"], "solution": "function greet(name = \"World\") {\n  console.log(`Hello, ${name}!`);\n}\n\ngreet();"}$$::jsonb,
20, 7, 'javascript');

-- JS Lesson 3: Higher-Order Functions
INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(5, 'JS: Higher-Order Functions', 'code',
$${"instructions": "Write a function `applyTwice(fn, x)` that applies the function `fn` to `x` twice (applies fn to x, then applies fn to that result).\n\nCall it with the arrow function `x => x + 3` and an initial value of `7`, then print the result.\n\nExpected output:\n13", "starter_code": "function applyTwice(fn, x) {\n  // Apply fn to x, then apply fn to that result\n}\n\nconsole.log(applyTwice(x => x + 3, 7));", "expected_output": "13", "hints": ["Apply fn to x first: fn(x)", "Then apply fn to the result: fn(fn(x))", "7 + 3 = 10, then 10 + 3 = 13"], "solution": "function applyTwice(fn, x) {\n  return fn(fn(x));\n}\n\nconsole.log(applyTwice(x => x + 3, 7));"}$$::jsonb,
25, 8, 'javascript');

-- TS Lesson 1: Typed Function
INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(5, 'TS: Typed Function', 'code',
$${"instructions": "Write a function `add` that takes two `number` parameters `a` and `b` and has a return type of `number`. It should return their sum.\n\nPrint the result of add(15, 27).\n\nExpected output:\n42", "starter_code": "function add(a: number, b: number): number {\n  // Return the sum of a and b\n}\n\nconsole.log(add(15, 27));", "expected_output": "42", "hints": ["Type annotations come after the parameter name with a colon: a: number", "The return type goes after the closing parenthesis: ): number", "15 + 27 = 42"], "solution": "function add(a: number, b: number): number {\n  return a + b;\n}\n\nconsole.log(add(15, 27));"}$$::jsonb,
20, 9, 'typescript');

-- TS Lesson 2: Optional Parameters
INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(5, 'TS: Optional Parameters', 'code',
$${"instructions": "Write a function `greet(name: string, greeting?: string): string` that returns `\"<greeting>, <name>\"`. If `greeting` is not provided, use `\"Hello\"` as the default.\n\nPrint greet(\"Alice\") and greet(\"Bob\", \"Hi\").\n\nExpected output:\nHello, Alice\nHi, Bob", "starter_code": "function greet(name: string, greeting?: string): string {\n  // Return the greeting string, defaulting to \"Hello\" if greeting is not provided\n}\n\nconsole.log(greet(\"Alice\"));\nconsole.log(greet(\"Bob\", \"Hi\"));", "expected_output": "Hello, Alice\nHi, Bob", "hints": ["Use ? after the parameter name to mark it optional: greeting?: string", "Check if greeting is provided with: greeting ?? \"Hello\"", "The ?? operator returns the right side if the left side is undefined or null"], "solution": "function greet(name: string, greeting?: string): string {\n  return `${greeting ?? \"Hello\"}, ${name}`;\n}\n\nconsole.log(greet(\"Alice\"));\nconsole.log(greet(\"Bob\", \"Hi\"));"}$$::jsonb,
20, 10, 'typescript');

-- TS Lesson 3: Generic Function
INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(5, 'TS: Generic Function', 'code',
$${"instructions": "Write a generic function `first<T>(arr: T[]): T` that returns the first element of an array.\n\nCall it with the string array `[\"a\", \"b\", \"c\"]` and print the result.\n\nExpected output:\na", "starter_code": "function first<T>(arr: T[]): T {\n  // Return the first element\n}\n\nconsole.log(first([\"a\", \"b\", \"c\"]));", "expected_output": "a", "hints": ["Generic type parameters are declared with angle brackets: <T>", "The array parameter type is T[]", "Return arr[0] to get the first element"], "solution": "function first<T>(arr: T[]): T {\n  return arr[0];\n}\n\nconsole.log(first([\"a\", \"b\", \"c\"]));"}$$::jsonb,
25, 11, 'typescript');

-- ============================================================
-- TOPIC 6: Arrays & Lists
-- ============================================================

-- JS Lesson 1: Array Methods
INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(6, 'JS: Array Methods', 'code',
$${"instructions": "Given the array `const nums = [3, 1, 4, 1, 5, 9, 2, 6]`:\n1. Find the maximum value using `Math.max(...nums)` and print it.\n2. Sort the array in ascending order and print it using `.join(\",\")`.\n\nExpected output:\n9\n1,1,2,3,4,5,6,9", "starter_code": "const nums = [3, 1, 4, 1, 5, 9, 2, 6];\n\n// Print the maximum value\n\n// Sort ascending and print with .join(\",\")", "expected_output": "9\n1,1,2,3,4,5,6,9", "hints": ["Use Math.max(...nums) to spread the array as arguments", "Use nums.sort((a, b) => a - b) for numeric ascending sort", "Use .join(\",\") to print the sorted array as a comma-separated string"], "solution": "const nums = [3, 1, 4, 1, 5, 9, 2, 6];\n\nconsole.log(Math.max(...nums));\nconsole.log(nums.sort((a, b) => a - b).join(\",\"));"}$$::jsonb,
20, 6, 'javascript');

-- JS Lesson 2: Filter and Map
INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(6, 'JS: Filter and Map', 'code',
$${"instructions": "Given `const nums = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]`:\n1. Filter to keep only even numbers.\n2. Double each of those numbers using `.map()`.\n3. Print the result using `.join(\",\")`.\n\nExpected output:\n4,8,12,16,20", "starter_code": "const nums = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];\n\n// Filter even numbers, then double them, then print with .join(\",\")", "expected_output": "4,8,12,16,20", "hints": ["Use .filter(n => n % 2 === 0) to keep even numbers", "Chain .map(n => n * 2) to double each number", "Use .join(\",\") at the end to print as a comma-separated string"], "solution": "const nums = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];\n\nconsole.log(nums.filter(n => n % 2 === 0).map(n => n * 2).join(\",\"));"}$$::jsonb,
20, 7, 'javascript');

-- JS Lesson 3: Array Destructuring
INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(6, 'JS: Array Destructuring', 'code',
$${"instructions": "Given `const colors = [\"red\", \"green\", \"blue\"]`, use array destructuring to extract the first element into `first`, the second into `second`, and the rest into `rest`.\n\nPrint `first`, then `second`, then `rest` joined with a comma.\n\nExpected output:\nred\ngreen\nblue", "starter_code": "const colors = [\"red\", \"green\", \"blue\"];\n\n// Destructure into first, second, and rest\n\nconsole.log(first);\nconsole.log(second);\nconsole.log(rest.join(\",\"));", "expected_output": "red\ngreen\nblue", "hints": ["Destructuring syntax: const [first, second, ...rest] = colors", "The ...rest (rest parameter) collects remaining elements into an array", "Use rest.join(\",\") to print the remaining elements as a string"], "solution": "const colors = [\"red\", \"green\", \"blue\"];\n\nconst [first, second, ...rest] = colors;\n\nconsole.log(first);\nconsole.log(second);\nconsole.log(rest.join(\",\"));"}$$::jsonb,
20, 8, 'javascript');

-- TS Lesson 1: Typed Arrays
INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(6, 'TS: Typed Arrays', 'code',
$${"instructions": "Declare a typed array `const scores: number[] = [85, 92, 78, 96, 88]`.\n\nCompute the average (sum divided by length) and print it.\n\nExpected output:\n87.8", "starter_code": "const scores: number[] = [85, 92, 78, 96, 88];\n\n// Compute and print the average", "expected_output": "87.8", "hints": ["Use .reduce((sum, n) => sum + n, 0) to compute the sum", "Divide the sum by scores.length", "85+92+78+96+88 = 439, divided by 5 = 87.8"], "solution": "const scores: number[] = [85, 92, 78, 96, 88];\n\nconst avg = scores.reduce((sum, n) => sum + n, 0) / scores.length;\nconsole.log(avg);"}$$::jsonb,
20, 9, 'typescript');

-- TS Lesson 2: Array of Interfaces
INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(6, 'TS: Array of Interfaces', 'code',
$${"instructions": "Define an interface `Student` with `name: string` and `grade: number`.\n\nCreate an array of 3 students: Alice (85), Bob (92), Diana (95).\n\nFilter for students with grade >= 90 and print their names.\n\nExpected output:\nBob\nDiana", "starter_code": "interface Student {\n  name: string;\n  grade: number;\n}\n\nconst students: Student[] = [\n  // Add 3 students here\n];\n\n// Filter grade >= 90 and print each name", "expected_output": "Bob\nDiana", "hints": ["Create objects matching the interface: { name: \"Alice\", grade: 85 }", "Use .filter(s => s.grade >= 90) to filter", "Use .forEach(s => console.log(s.name)) to print each name"], "solution": "interface Student {\n  name: string;\n  grade: number;\n}\n\nconst students: Student[] = [\n  { name: \"Alice\", grade: 85 },\n  { name: \"Bob\", grade: 92 },\n  { name: \"Diana\", grade: 95 },\n];\n\nstudents.filter(s => s.grade >= 90).forEach(s => console.log(s.name));"}$$::jsonb,
25, 10, 'typescript');

-- TS Lesson 3: Spread and Rest
INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(6, 'TS: Spread and Rest', 'code',
$${"instructions": "Write a function `sum(...nums: number[]): number` that accepts any number of arguments and returns their sum.\n\nCall `sum(1, 2, 3, 4, 5)` and print the result.\n\nExpected output:\n15", "starter_code": "function sum(...nums: number[]): number {\n  // Return the sum of all arguments\n}\n\nconsole.log(sum(1, 2, 3, 4, 5));", "expected_output": "15", "hints": ["Use ...nums to collect all arguments into an array", "Use nums.reduce((acc, n) => acc + n, 0) to sum the array", "1+2+3+4+5 = 15"], "solution": "function sum(...nums: number[]): number {\n  return nums.reduce((acc, n) => acc + n, 0);\n}\n\nconsole.log(sum(1, 2, 3, 4, 5));"}$$::jsonb,
20, 11, 'typescript');

-- ============================================================
-- TOPIC 7: Objects & Dicts
-- ============================================================

-- JS Lesson 1: Object Literals
INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(7, 'JS: Object Literals', 'code',
$${"instructions": "Create an object `person` with the properties `name` (\"Alice\"), `age` (30), and `city` (\"Berlin\").\n\nPrint a sentence using template literals.\n\nExpected output:\nAlice is 30 years old from Berlin", "starter_code": "const person = {\n  // Add name, age, and city properties\n};\n\nconsole.log(`${person.name} is ${person.age} years old from ${person.city}`);", "expected_output": "Alice is 30 years old from Berlin", "hints": ["Object properties are key-value pairs separated by colons: name: \"Alice\"", "Separate multiple properties with commas", "Access properties with dot notation: person.name"], "solution": "const person = {\n  name: \"Alice\",\n  age: 30,\n  city: \"Berlin\",\n};\n\nconsole.log(`${person.name} is ${person.age} years old from ${person.city}`);"}$$::jsonb,
20, 6, 'javascript');

-- JS Lesson 2: Object Destructuring
INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(7, 'JS: Object Destructuring', 'code',
$${"instructions": "Given `const book = { title: \"JS Deep Dive\", author: \"Kyle\", pages: 612 }`, use object destructuring to extract `title`, `author`, and `pages`.\n\nPrint them in the format shown.\n\nExpected output:\nJS Deep Dive by Kyle (612 pages)", "starter_code": "const book = { title: \"JS Deep Dive\", author: \"Kyle\", pages: 612 };\n\n// Destructure title, author, and pages\n\nconsole.log(`${title} by ${author} (${pages} pages)`);", "expected_output": "JS Deep Dive by Kyle (612 pages)", "hints": ["Object destructuring syntax: const { title, author, pages } = book", "The variable names must match the property keys", "Use a template literal to format the output"], "solution": "const book = { title: \"JS Deep Dive\", author: \"Kyle\", pages: 612 };\n\nconst { title, author, pages } = book;\n\nconsole.log(`${title} by ${author} (${pages} pages)`);"}$$::jsonb,
20, 7, 'javascript');

-- JS Lesson 3: Object Methods
INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(7, 'JS: Object Methods', 'code',
$${"instructions": "Create an object `counter` with:\n- a `count` property starting at `0`\n- an `increment()` method that adds 1 to `count`\n- a `decrement()` method that subtracts 1 from `count`\n\nCall `increment()` 3 times and `decrement()` once, then print `counter.count`.\n\nExpected output:\n2", "starter_code": "const counter = {\n  count: 0,\n  increment() {\n    // Increment count\n  },\n  decrement() {\n    // Decrement count\n  },\n};\n\ncounter.increment();\ncounter.increment();\ncounter.increment();\ncounter.decrement();\nconsole.log(counter.count);", "expected_output": "2", "hints": ["Use this.count to refer to the count property inside a method", "this.count++ adds 1, this.count-- subtracts 1", "3 increments minus 1 decrement = 2"], "solution": "const counter = {\n  count: 0,\n  increment() {\n    this.count++;\n  },\n  decrement() {\n    this.count--;\n  },\n};\n\ncounter.increment();\ncounter.increment();\ncounter.increment();\ncounter.decrement();\nconsole.log(counter.count);"}$$::jsonb,
20, 8, 'javascript');

-- TS Lesson 1: Interface
INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(7, 'TS: Interface', 'code',
$${"instructions": "Define an interface `Car` with properties `brand: string`, `model: string`, and `year: number`.\n\nCreate a `Car` object with brand \"Toyota\", model \"Corolla\", and year 2023.\n\nPrint it in the format shown.\n\nExpected output:\n2023 Toyota Corolla", "starter_code": "interface Car {\n  brand: string;\n  model: string;\n  year: number;\n}\n\nconst myCar: Car = {\n  // Fill in the properties\n};\n\nconsole.log(`${myCar.year} ${myCar.brand} ${myCar.model}`);", "expected_output": "2023 Toyota Corolla", "hints": ["Interface properties are declared with a semicolon after each: brand: string;", "Assign the object to a variable typed as Car: const myCar: Car = {...}", "Use a template literal with year, brand, and model"], "solution": "interface Car {\n  brand: string;\n  model: string;\n  year: number;\n}\n\nconst myCar: Car = {\n  brand: \"Toyota\",\n  model: \"Corolla\",\n  year: 2023,\n};\n\nconsole.log(`${myCar.year} ${myCar.brand} ${myCar.model}`);"}$$::jsonb,
20, 9, 'typescript');

-- TS Lesson 2: Optional Properties
INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(7, 'TS: Optional Properties', 'code',
$${"instructions": "Define an interface `Config` with:\n- `host: string` (required)\n- `port?: number` (optional)\n- `ssl?: boolean` (optional)\n\nCreate a `Config` object with only `host` set to `\"localhost\"`.\n\nPrint the host, then print the port (defaulting to `3000` if not set).\n\nExpected output:\nlocalhost\n3000", "starter_code": "interface Config {\n  host: string;\n  port?: number;\n  ssl?: boolean;\n}\n\nconst config: Config = {\n  // Only set host\n};\n\nconsole.log(config.host);\nconsole.log(config.port ?? 3000);", "expected_output": "localhost\n3000", "hints": ["Optional properties use ? after the name: port?: number", "You can omit optional properties when creating the object", "The ?? operator returns the right-hand value when the left is undefined: config.port ?? 3000"], "solution": "interface Config {\n  host: string;\n  port?: number;\n  ssl?: boolean;\n}\n\nconst config: Config = {\n  host: \"localhost\",\n};\n\nconsole.log(config.host);\nconsole.log(config.port ?? 3000);"}$$::jsonb,
20, 10, 'typescript');

-- TS Lesson 3: Index Signatures
INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(7, 'TS: Index Signatures', 'code',
$${"instructions": "Define an interface `WordCount` with an index signature `[word: string]: number` that maps words to their counts.\n\nManually count the words in `\"hello world hello\"` and store the counts in a `WordCount` object.\n\nPrint the count for `\"hello\"`.\n\nExpected output:\n2", "starter_code": "interface WordCount {\n  [word: string]: number;\n}\n\nconst counts: WordCount = {};\n\n// Count words in \"hello world hello\"\n\nconsole.log(counts[\"hello\"]);", "expected_output": "2", "hints": ["An index signature allows any string key: [word: string]: number", "Split the sentence into words: \"hello world hello\".split(\" \")", "For each word, increment counts[word] — initialise to 0 if undefined: counts[word] = (counts[word] ?? 0) + 1"], "solution": "interface WordCount {\n  [word: string]: number;\n}\n\nconst counts: WordCount = {};\n\n\"hello world hello\".split(\" \").forEach(word => {\n  counts[word] = (counts[word] ?? 0) + 1;\n});\n\nconsole.log(counts[\"hello\"]);"}$$::jsonb,
25, 11, 'typescript');

-- ============================================================
-- TOPIC 8: Object-Oriented Programming
-- ============================================================

-- JS Lesson 1: Class Basics
INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(8, 'JS: Class Basics', 'code',
$${"instructions": "Create a class `Animal` with:\n- A constructor that takes `name` and `sound`\n- A method `speak()` that returns `\"<name> says <sound>\"`\n\nCreate an `Animal` instance with name `\"Rex\"` and sound `\"Woof\"`, call `speak()`, and print the result.\n\nExpected output:\nRex says Woof", "starter_code": "class Animal {\n  constructor(name, sound) {\n    // Store name and sound\n  }\n\n  speak() {\n    // Return \"<name> says <sound>\"\n  }\n}\n\nconst dog = new Animal(\"Rex\", \"Woof\");\nconsole.log(dog.speak());", "expected_output": "Rex says Woof", "hints": ["Store constructor arguments with this.name = name and this.sound = sound", "The speak method returns a template literal: `${this.name} says ${this.sound}`", "Call the method with dog.speak() and log the return value"], "solution": "class Animal {\n  constructor(name, sound) {\n    this.name = name;\n    this.sound = sound;\n  }\n\n  speak() {\n    return `${this.name} says ${this.sound}`;\n  }\n}\n\nconst dog = new Animal(\"Rex\", \"Woof\");\nconsole.log(dog.speak());"}$$::jsonb,
20, 6, 'javascript');

-- JS Lesson 2: Inheritance
INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(8, 'JS: Inheritance', 'code',
$${"instructions": "Build on the `Animal` class by creating a subclass `Dog` that overrides `speak()` to append `\"!\"` to the sound (e.g. `\"Rex says Woof!\"`).\n\nCreate a `Dog` instance with name `\"Rex\"` and sound `\"Woof\"`, call `speak()`, and print the result.\n\nExpected output:\nRex says Woof!", "starter_code": "class Animal {\n  constructor(name, sound) {\n    this.name = name;\n    this.sound = sound;\n  }\n\n  speak() {\n    return `${this.name} says ${this.sound}`;\n  }\n}\n\nclass Dog extends Animal {\n  speak() {\n    // Override to add \"!\" at the end\n  }\n}\n\nconst dog = new Dog(\"Rex\", \"Woof\");\nconsole.log(dog.speak());", "expected_output": "Rex says Woof!", "hints": ["Use extends Animal to inherit from Animal", "Call super.speak() to get the parent result, then add \"!\"", "Or build the string directly: `${this.name} says ${this.sound}!`"], "solution": "class Animal {\n  constructor(name, sound) {\n    this.name = name;\n    this.sound = sound;\n  }\n\n  speak() {\n    return `${this.name} says ${this.sound}`;\n  }\n}\n\nclass Dog extends Animal {\n  speak() {\n    return super.speak() + \"!\";\n  }\n}\n\nconst dog = new Dog(\"Rex\", \"Woof\");\nconsole.log(dog.speak());"}$$::jsonb,
20, 7, 'javascript');

-- JS Lesson 3: Getters and Setters
INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(8, 'JS: Getters and Setters', 'code',
$${"instructions": "Create a class `Circle` with:\n- A constructor that stores the radius in `this._radius`\n- A getter `radius` that returns `_radius`\n- A getter `area` that returns π * r² (use `Math.PI`)\n\nCreate a `Circle` with radius `5`. Print the radius, then print the area rounded to 2 decimal places.\n\nExpected output:\n5\n78.54", "starter_code": "class Circle {\n  constructor(radius) {\n    this._radius = radius;\n  }\n\n  get radius() {\n    // Return _radius\n  }\n\n  get area() {\n    // Return Math.PI * radius squared\n  }\n}\n\nconst c = new Circle(5);\nconsole.log(c.radius);\nconsole.log(c.area.toFixed(2));", "expected_output": "5\n78.54", "hints": ["A getter is defined with the get keyword before the method name", "Return this._radius in the radius getter", "Area formula: Math.PI * this._radius ** 2, use .toFixed(2) for rounding"], "solution": "class Circle {\n  constructor(radius) {\n    this._radius = radius;\n  }\n\n  get radius() {\n    return this._radius;\n  }\n\n  get area() {\n    return Math.PI * this._radius ** 2;\n  }\n}\n\nconst c = new Circle(5);\nconsole.log(c.radius);\nconsole.log(c.area.toFixed(2));"}$$::jsonb,
25, 8, 'javascript');

-- TS Lesson 1: Class with Types
INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(8, 'TS: Class with Types', 'code',
$${"instructions": "Create a class `Person` with:\n- Private fields `name: string` and `age: number`\n- A constructor that sets both\n- A method `greet(): string` that returns `\"Hi, I'm <name>, age <age>\"`\n\nCreate a `Person(\"Alice\", 30)` and print `greet()`.\n\nExpected output:\nHi, I'm Alice, age 30", "starter_code": "class Person {\n  private name: string;\n  private age: number;\n\n  constructor(name: string, age: number) {\n    // Assign name and age\n  }\n\n  greet(): string {\n    // Return the greeting string\n  }\n}\n\nconst p = new Person(\"Alice\", 30);\nconsole.log(p.greet());", "expected_output": "Hi, I'm Alice, age 30", "hints": ["Assign constructor params with this.name = name and this.age = age", "Return a template literal: `Hi, I'm ${this.name}, age ${this.age}`", "private means the field can only be accessed within the class"], "solution": "class Person {\n  private name: string;\n  private age: number;\n\n  constructor(name: string, age: number) {\n    this.name = name;\n    this.age = age;\n  }\n\n  greet(): string {\n    return `Hi, I'm ${this.name}, age ${this.age}`;\n  }\n}\n\nconst p = new Person(\"Alice\", 30);\nconsole.log(p.greet());"}$$::jsonb,
20, 9, 'typescript');

-- TS Lesson 2: Abstract Class
INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(8, 'TS: Abstract Class', 'code',
$${"instructions": "Define an abstract class `Shape` with:\n- An abstract method `area(): number`\n- A concrete method `describe(): string` that returns `\"Area: \" + this.area()`\n\nImplement a `Rectangle` class that extends `Shape`, stores `width` and `height` in the constructor, and implements `area()` as `width * height`.\n\nPrint `new Rectangle(4, 5).describe()`.\n\nExpected output:\nArea: 20", "starter_code": "abstract class Shape {\n  abstract area(): number;\n\n  describe(): string {\n    return \"Area: \" + this.area();\n  }\n}\n\nclass Rectangle extends Shape {\n  constructor(private w: number, private h: number) {\n    super();\n  }\n\n  area(): number {\n    // Return width * height\n  }\n}\n\nconsole.log(new Rectangle(4, 5).describe());", "expected_output": "Area: 20", "hints": ["abstract methods have no body — subclasses must implement them", "Return this.w * this.h in Rectangle's area() method", "4 * 5 = 20, so describe() returns \"Area: 20\""], "solution": "abstract class Shape {\n  abstract area(): number;\n\n  describe(): string {\n    return \"Area: \" + this.area();\n  }\n}\n\nclass Rectangle extends Shape {\n  constructor(private w: number, private h: number) {\n    super();\n  }\n\n  area(): number {\n    return this.w * this.h;\n  }\n}\n\nconsole.log(new Rectangle(4, 5).describe());"}$$::jsonb,
25, 10, 'typescript');

-- TS Lesson 3: Implements Interface
INSERT INTO lessons (topic_id, title, type, content_json, xp_reward, order_index, language) VALUES
(8, 'TS: Implements Interface', 'code',
$${"instructions": "Define an interface `Printable` with a method `print(): void`.\n\nCreate a class `Document` that implements `Printable`. It should have a `title` property set in the constructor. The `print()` method should log `\"Printing: \" + title`.\n\nCreate a `Document(\"My Report\")` and call `print()`.\n\nExpected output:\nPrinting: My Report", "starter_code": "interface Printable {\n  print(): void;\n}\n\nclass Document implements Printable {\n  constructor(private title: string) {}\n\n  print(): void {\n    // Log \"Printing: \" + title\n  }\n}\n\nnew Document(\"My Report\").print();", "expected_output": "Printing: My Report", "hints": ["Use implements Printable after the class name", "Access the title with this.title inside the method", "Use console.log(\"Printing: \" + this.title)"], "solution": "interface Printable {\n  print(): void;\n}\n\nclass Document implements Printable {\n  constructor(private title: string) {}\n\n  print(): void {\n    console.log(\"Printing: \" + this.title);\n  }\n}\n\nnew Document(\"My Report\").print();"}$$::jsonb,
20, 11, 'typescript');
