-- 016: JavaScript and TypeScript code lessons for Topics 9, 10, 11
-- order_index 6-8 = JavaScript, 9-11 = TypeScript

-- ============================================================
-- TOPIC 9: Error Handling — JavaScript (order 6-8)
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json, language) VALUES
(
  9,
  'JS: Try/Catch',
  'code',
  20,
  6,
  $json${
    "instructions": "Wrap JSON.parse('{invalid}') in a try/catch block. When the parse fails, print 'JSON parse error' in the catch block.",
    "starter_code": "try {\n  JSON.parse('{invalid}')\n} catch (e) {\n  // Print 'JSON parse error'\n}",
    "expected_output": "JSON parse error",
    "hints": [
      "The catch block receives the error object as parameter e",
      "Use console.log() inside the catch block to print the message",
      "console.log('JSON parse error') is all you need inside the catch"
    ],
    "solution": "try {\n  JSON.parse('{invalid}')\n} catch (e) {\n  console.log('JSON parse error')\n}"
  }$json$::jsonb,
  'javascript'
);

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json, language) VALUES
(
  9,
  'JS: Custom Error',
  'code',
  20,
  7,
  $json${
    "instructions": "Create a class ValidationError that extends Error. In the constructor, call super(msg) and set this.name = 'ValidationError'. Throw it with the message 'Age must be positive', catch it, and print error.name + ': ' + error.message.",
    "starter_code": "class ValidationError extends Error {\n  constructor(msg) {\n    // Call super and set this.name\n  }\n}\n\ntry {\n  throw new ValidationError('Age must be positive')\n} catch (e) {\n  // Print e.name + ': ' + e.message\n}",
    "expected_output": "ValidationError: Age must be positive",
    "hints": [
      "Inside the constructor: call super(msg) first, then set this.name = 'ValidationError'",
      "Throw the error with: throw new ValidationError('Age must be positive')",
      "In the catch block: console.log(e.name + ': ' + e.message)"
    ],
    "solution": "class ValidationError extends Error {\n  constructor(msg) {\n    super(msg)\n    this.name = 'ValidationError'\n  }\n}\n\ntry {\n  throw new ValidationError('Age must be positive')\n} catch (e) {\n  console.log(e.name + ': ' + e.message)\n}"
  }$json$::jsonb,
  'javascript'
);

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json, language) VALUES
(
  9,
  'JS: Finally Block',
  'code',
  20,
  8,
  $json${
    "instructions": "Write a function readData(fail) that uses try/catch/finally. If fail is true, throw an Error inside try and print 'Error handled' in catch. Always print 'Cleanup done' in finally. Call readData(true).",
    "starter_code": "function readData(fail) {\n  try {\n    if (fail) throw new Error('Something went wrong')\n    console.log('Data read')\n  } catch (e) {\n    // Print 'Error handled'\n  } finally {\n    // Print 'Cleanup done'\n  }\n}\n\nreadData(true)",
    "expected_output": "Error handled\nCleanup done",
    "hints": [
      "The catch block should print 'Error handled'",
      "The finally block always runs — print 'Cleanup done' there",
      "console.log('Error handled') in catch, console.log('Cleanup done') in finally"
    ],
    "solution": "function readData(fail) {\n  try {\n    if (fail) throw new Error('Something went wrong')\n    console.log('Data read')\n  } catch (e) {\n    console.log('Error handled')\n  } finally {\n    console.log('Cleanup done')\n  }\n}\n\nreadData(true)"
  }$json$::jsonb,
  'javascript'
);

-- ============================================================
-- TOPIC 9: Error Handling — TypeScript (order 9-11)
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json, language) VALUES
(
  9,
  'TS: Typed Error Handling',
  'code',
  20,
  9,
  $json${
    "instructions": "Write a function divide(a: number, b: number): number that throws Error('Division by zero') if b is 0. Call divide(10, 2) in a try/catch and print the result. Then call divide(5, 0) and print 'Error: Division by zero' in the catch.",
    "starter_code": "function divide(a: number, b: number): number {\n  // Throw an error if b is 0, otherwise return a / b\n}\n\ntry {\n  console.log(divide(10, 2))\n} catch (e: any) {\n  console.log('Error: ' + e.message)\n}\n\ntry {\n  console.log(divide(5, 0))\n} catch (e: any) {\n  console.log('Error: ' + e.message)\n}",
    "expected_output": "5\nError: Division by zero",
    "hints": [
      "Check if b === 0 and throw new Error('Division by zero')",
      "If b is not 0, return a / b",
      "The second try/catch will catch the error and print 'Error: Division by zero'"
    ],
    "solution": "function divide(a: number, b: number): number {\n  if (b === 0) throw new Error('Division by zero')\n  return a / b\n}\n\ntry {\n  console.log(divide(10, 2))\n} catch (e: any) {\n  console.log('Error: ' + e.message)\n}\n\ntry {\n  console.log(divide(5, 0))\n} catch (e: any) {\n  console.log('Error: ' + e.message)\n}"
  }$json$::jsonb,
  'typescript'
);

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json, language) VALUES
(
  9,
  'TS: Custom Error Class',
  'code',
  20,
  10,
  $json${
    "instructions": "Create class AppError that extends Error with a public code: number property. In the constructor, accept code and message, call super(message), and store code. Throw AppError(404, 'Not found'), catch it, and print the code on one line and the message on the next.",
    "starter_code": "class AppError extends Error {\n  constructor(public code: number, message: string) {\n    // Call super with message\n  }\n}\n\ntry {\n  throw new AppError(404, 'Not found')\n} catch (e: any) {\n  // Print e.code, then e.message\n}",
    "expected_output": "404\nNot found",
    "hints": [
      "Inside the constructor, call super(message) to set the message property",
      "The 'public code: number' shorthand automatically creates the property",
      "In catch: console.log(e.code) then console.log(e.message)"
    ],
    "solution": "class AppError extends Error {\n  constructor(public code: number, message: string) {\n    super(message)\n  }\n}\n\ntry {\n  throw new AppError(404, 'Not found')\n} catch (e: any) {\n  console.log(e.code)\n  console.log(e.message)\n}"
  }$json$::jsonb,
  'typescript'
);

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json, language) VALUES
(
  9,
  'TS: Result Pattern',
  'code',
  20,
  11,
  $json${
    "instructions": "Define type Result<T> as a union: { ok: true; value: T } | { ok: false; error: string }. Write function safeParse(s: string): Result<number> that returns { ok: true, value: n } if s is a valid number, or { ok: false, error: 'Not a number' } otherwise. Print the value for '42' and the error for 'abc'.",
    "starter_code": "type Result<T> = { ok: true; value: T } | { ok: false; error: string }\n\nfunction safeParse(s: string): Result<number> {\n  const n = Number(s)\n  // Return ok result if valid, error result if NaN\n}\n\nconst r1 = safeParse('42')\nif (r1.ok) console.log(r1.value)\n\nconst r2 = safeParse('abc')\nif (!r2.ok) console.log(r2.error)",
    "expected_output": "42\nNot a number",
    "hints": [
      "Use isNaN(n) to check if the conversion failed",
      "Return { ok: false, error: 'Not a number' } when isNaN(n) is true",
      "Return { ok: true, value: n } when the number is valid"
    ],
    "solution": "type Result<T> = { ok: true; value: T } | { ok: false; error: string }\n\nfunction safeParse(s: string): Result<number> {\n  const n = Number(s)\n  if (isNaN(n)) return { ok: false, error: 'Not a number' }\n  return { ok: true, value: n }\n}\n\nconst r1 = safeParse('42')\nif (r1.ok) console.log(r1.value)\n\nconst r2 = safeParse('abc')\nif (!r2.ok) console.log(r2.error)"
  }$json$::jsonb,
  'typescript'
);

-- ============================================================
-- TOPIC 10: APIs — JavaScript (order 6-8)
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json, language) VALUES
(
  10,
  'JS: JSON Stringify and Parse',
  'code',
  20,
  6,
  $json${
    "instructions": "Create an object with name 'Alice', age 30, and hobbies array ['coding', 'reading']. Use JSON.stringify() to convert it to a string, then JSON.parse() to parse it back. Print the name and the first hobby.",
    "starter_code": "const user = { name: 'Alice', age: 30, hobbies: ['coding', 'reading'] }\n\n// Stringify then parse back\nconst str = JSON.stringify(user)\nconst parsed = JSON.parse(str)\n\n// Print name and first hobby",
    "expected_output": "Alice\ncoding",
    "hints": [
      "JSON.stringify(user) converts the object to a JSON string",
      "JSON.parse(str) converts the string back to an object",
      "Access with parsed.name and parsed.hobbies[0]"
    ],
    "solution": "const user = { name: 'Alice', age: 30, hobbies: ['coding', 'reading'] }\n\nconst str = JSON.stringify(user)\nconst parsed = JSON.parse(str)\n\nconsole.log(parsed.name)\nconsole.log(parsed.hobbies[0])"
  }$json$::jsonb,
  'javascript'
);

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json, language) VALUES
(
  10,
  'JS: Async/Await Simulation',
  'code',
  20,
  7,
  $json${
    "instructions": "Write an async function fetchUser() that returns the object {id: 1, name: 'Bob'}. Call it using .then() and print the user's name.",
    "starter_code": "async function fetchUser() {\n  // Return {id: 1, name: 'Bob'}\n}\n\nfetchUser().then(user => {\n  // Print user.name\n})",
    "expected_output": "Bob",
    "hints": [
      "Inside fetchUser(), use: return {id: 1, name: 'Bob'}",
      "Async functions automatically wrap the return value in a Promise",
      "In .then(user => ...), use console.log(user.name)"
    ],
    "solution": "async function fetchUser() {\n  return { id: 1, name: 'Bob' }\n}\n\nfetchUser().then(user => {\n  console.log(user.name)\n})"
  }$json$::jsonb,
  'javascript'
);

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json, language) VALUES
(
  10,
  'JS: Array of API Results',
  'code',
  20,
  8,
  $json${
    "instructions": "Given the response object with a users array, filter to keep only users where id > 1, then print each matching user's name on a separate line.",
    "starter_code": "const response = {\n  users: [\n    { id: 1, name: 'Alice' },\n    { id: 2, name: 'Bob' },\n    { id: 3, name: 'Charlie' }\n  ]\n}\n\n// Filter users where id > 1 and print their names",
    "expected_output": "Bob\nCharlie",
    "hints": [
      "Use response.users.filter(u => u.id > 1) to get the matching users",
      "Chain .forEach(u => console.log(u.name)) to print each name",
      "Or store the filtered array and loop over it with for...of"
    ],
    "solution": "const response = {\n  users: [\n    { id: 1, name: 'Alice' },\n    { id: 2, name: 'Bob' },\n    { id: 3, name: 'Charlie' }\n  ]\n}\n\nresponse.users.filter(u => u.id > 1).forEach(u => console.log(u.name))"
  }$json$::jsonb,
  'javascript'
);

-- ============================================================
-- TOPIC 10: APIs — TypeScript (order 9-11)
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json, language) VALUES
(
  10,
  'TS: Typed JSON',
  'code',
  20,
  9,
  $json${
    "instructions": "Define a generic interface ApiResponse<T> with fields data: T and status: number. Create a variable res of type ApiResponse<string> with data 'Hello' and status 200. Print the status, then the data.",
    "starter_code": "interface ApiResponse<T> {\n  data: T\n  status: number\n}\n\nconst res: ApiResponse<string> = { data: 'Hello', status: 200 }\n\n// Print res.status then res.data",
    "expected_output": "200\nHello",
    "hints": [
      "The interface uses a type parameter T so it works with any data type",
      "console.log(res.status) prints the status code",
      "console.log(res.data) prints the data field"
    ],
    "solution": "interface ApiResponse<T> {\n  data: T\n  status: number\n}\n\nconst res: ApiResponse<string> = { data: 'Hello', status: 200 }\n\nconsole.log(res.status)\nconsole.log(res.data)"
  }$json$::jsonb,
  'typescript'
);

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json, language) VALUES
(
  10,
  'TS: Async Function',
  'code',
  20,
  10,
  $json${
    "instructions": "Write an async function getScore() that has return type Promise<number> and returns 95. Call it with .then() and print 'Score: ' followed by the score value.",
    "starter_code": "async function getScore(): Promise<number> {\n  // Return 95\n}\n\ngetScore().then(score => {\n  // Print 'Score: ' + score\n})",
    "expected_output": "Score: 95",
    "hints": [
      "Return 95 inside getScore()",
      "TypeScript's Promise<number> return type tells callers what the resolved value type is",
      "In .then(score => ...), use console.log('Score:', score)"
    ],
    "solution": "async function getScore(): Promise<number> {\n  return 95\n}\n\ngetScore().then(score => {\n  console.log('Score:', score)\n})"
  }$json$::jsonb,
  'typescript'
);

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json, language) VALUES
(
  10,
  'TS: Transform API Data',
  'code',
  20,
  11,
  $json${
    "instructions": "Define interface User with fields id: number, name: string, email: string. Create an array of 3 users (Alice, Bob, Charlie). Use .map() to extract only the names, then join them with a comma and print the result.",
    "starter_code": "interface User {\n  id: number\n  name: string\n  email: string\n}\n\nconst users: User[] = [\n  { id: 1, name: 'Alice', email: 'alice@example.com' },\n  { id: 2, name: 'Bob', email: 'bob@example.com' },\n  { id: 3, name: 'Charlie', email: 'charlie@example.com' }\n]\n\n// Map to names array and join with comma, then print",
    "expected_output": "Alice,Bob,Charlie",
    "hints": [
      "Use users.map(u => u.name) to get an array of names",
      "Chain .join(',') to combine them into a single string",
      "console.log() the joined result"
    ],
    "solution": "interface User {\n  id: number\n  name: string\n  email: string\n}\n\nconst users: User[] = [\n  { id: 1, name: 'Alice', email: 'alice@example.com' },\n  { id: 2, name: 'Bob', email: 'bob@example.com' },\n  { id: 3, name: 'Charlie', email: 'charlie@example.com' }\n]\n\nconsole.log(users.map(u => u.name).join(','))"
  }$json$::jsonb,
  'typescript'
);

-- ============================================================
-- TOPIC 11: Algorithms & Data Structures — JavaScript (order 6-8)
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json, language) VALUES
(
  11,
  'JS: Linear Search',
  'code',
  20,
  6,
  $json${
    "instructions": "Write a function linearSearch(arr, target) that iterates through the array and returns the index of the target, or -1 if not found. Search for 7 in [2, 5, 7, 1, 9, 3] and print the index.",
    "starter_code": "function linearSearch(arr, target) {\n  for (let i = 0; i < arr.length; i++) {\n    // If arr[i] equals target, return i\n  }\n  return -1\n}\n\nconsole.log(linearSearch([2, 5, 7, 1, 9, 3], 7))",
    "expected_output": "2",
    "hints": [
      "Inside the loop, check if arr[i] === target",
      "If the condition is true, return i immediately",
      "The loop falls through to return -1 if nothing matched"
    ],
    "solution": "function linearSearch(arr, target) {\n  for (let i = 0; i < arr.length; i++) {\n    if (arr[i] === target) return i\n  }\n  return -1\n}\n\nconsole.log(linearSearch([2, 5, 7, 1, 9, 3], 7))"
  }$json$::jsonb,
  'javascript'
);

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json, language) VALUES
(
  11,
  'JS: Binary Search',
  'code',
  20,
  7,
  $json${
    "instructions": "Write a function binarySearch(arr, target) that searches a sorted array by repeatedly halving the search space. Return the index if found, -1 if not. Search for 15 in [1, 5, 10, 15, 20, 25] and print the index.",
    "starter_code": "function binarySearch(arr, target) {\n  let left = 0\n  let right = arr.length - 1\n\n  while (left <= right) {\n    const mid = Math.floor((left + right) / 2)\n    // Compare arr[mid] with target and update left or right\n  }\n\n  return -1\n}\n\nconsole.log(binarySearch([1, 5, 10, 15, 20, 25], 15))",
    "expected_output": "3",
    "hints": [
      "If arr[mid] === target, return mid",
      "If arr[mid] < target, the answer is to the right: set left = mid + 1",
      "If arr[mid] > target, the answer is to the left: set right = mid - 1"
    ],
    "solution": "function binarySearch(arr, target) {\n  let left = 0\n  let right = arr.length - 1\n\n  while (left <= right) {\n    const mid = Math.floor((left + right) / 2)\n    if (arr[mid] === target) return mid\n    else if (arr[mid] < target) left = mid + 1\n    else right = mid - 1\n  }\n\n  return -1\n}\n\nconsole.log(binarySearch([1, 5, 10, 15, 20, 25], 15))"
  }$json$::jsonb,
  'javascript'
);

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json, language) VALUES
(
  11,
  'JS: Stack with Array',
  'code',
  20,
  8,
  $json${
    "instructions": "Implement a stack using a JavaScript array. Push 1, 2, and 3 onto the stack. Pop once. Then print the top element (peek) without removing it.",
    "starter_code": "const stack = []\n\n// Push 1, 2, 3\n\n// Pop once\n\n// Print the top element (peek)",
    "expected_output": "2",
    "hints": [
      "Use stack.push(value) to add elements",
      "Use stack.pop() to remove the top element",
      "Peek without removing: stack[stack.length - 1]"
    ],
    "solution": "const stack = []\n\nstack.push(1)\nstack.push(2)\nstack.push(3)\n\nstack.pop()\n\nconsole.log(stack[stack.length - 1])"
  }$json$::jsonb,
  'javascript'
);

-- ============================================================
-- TOPIC 11: Algorithms & Data Structures — TypeScript (order 9-11)
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json, language) VALUES
(
  11,
  'TS: Generic Stack',
  'code',
  20,
  9,
  $json${
    "instructions": "Implement a generic class Stack<T> with a private items: T[] array and three methods: push(item: T): void, pop(): T | undefined, and peek(): T | undefined. Push 'a', 'b', 'c', pop once, then print the result of peek().",
    "starter_code": "class Stack<T> {\n  private items: T[] = []\n\n  push(item: T): void {\n    // Add item to items\n  }\n\n  pop(): T | undefined {\n    // Remove and return last item\n  }\n\n  peek(): T | undefined {\n    // Return last item without removing\n  }\n}\n\nconst s = new Stack<string>()\ns.push('a')\ns.push('b')\ns.push('c')\ns.pop()\nconsole.log(s.peek())",
    "expected_output": "b",
    "hints": [
      "push: this.items.push(item)",
      "pop: return this.items.pop()",
      "peek: return this.items[this.items.length - 1]"
    ],
    "solution": "class Stack<T> {\n  private items: T[] = []\n\n  push(item: T): void {\n    this.items.push(item)\n  }\n\n  pop(): T | undefined {\n    return this.items.pop()\n  }\n\n  peek(): T | undefined {\n    return this.items[this.items.length - 1]\n  }\n}\n\nconst s = new Stack<string>()\ns.push('a')\ns.push('b')\ns.push('c')\ns.pop()\nconsole.log(s.peek())"
  }$json$::jsonb,
  'typescript'
);

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json, language) VALUES
(
  11,
  'TS: Bubble Sort',
  'code',
  20,
  10,
  $json${
    "instructions": "Write a function bubbleSort(arr: number[]): number[] that returns a sorted copy of the array without mutating the original. Sort [64, 34, 25, 12, 22, 11, 90] and print the result joined with commas.",
    "starter_code": "function bubbleSort(arr: number[]): number[] {\n  const a = [...arr]\n  for (let i = 0; i < a.length - 1; i++) {\n    for (let j = 0; j < a.length - i - 1; j++) {\n      // Swap a[j] and a[j+1] if a[j] > a[j+1]\n    }\n  }\n  return a\n}\n\nconsole.log(bubbleSort([64, 34, 25, 12, 22, 11, 90]).join(','))",
    "expected_output": "11,12,22,25,34,64,90",
    "hints": [
      "Use destructuring to swap: [a[j], a[j+1]] = [a[j+1], a[j]]",
      "The condition to swap is: if (a[j] > a[j+1])",
      "The spread [...arr] at the start ensures you don't mutate the input"
    ],
    "solution": "function bubbleSort(arr: number[]): number[] {\n  const a = [...arr]\n  for (let i = 0; i < a.length - 1; i++) {\n    for (let j = 0; j < a.length - i - 1; j++) {\n      if (a[j] > a[j+1]) {\n        [a[j], a[j+1]] = [a[j+1], a[j]]\n      }\n    }\n  }\n  return a\n}\n\nconsole.log(bubbleSort([64, 34, 25, 12, 22, 11, 90]).join(','))"
  }$json$::jsonb,
  'typescript'
);

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json, language) VALUES
(
  11,
  'TS: Hash Map Frequency',
  'code',
  20,
  11,
  $json${
    "instructions": "Write a generic function frequency<T extends string>(arr: T[]): Record<T, number> that counts how many times each element appears. Count occurrences in ['a', 'b', 'a', 'c', 'b', 'a'] and print the count of 'a'.",
    "starter_code": "function frequency<T extends string>(arr: T[]): Record<T, number> {\n  return arr.reduce((acc, val) => {\n    // Increment acc[val] by 1, defaulting to 0 if not set\n    return acc\n  }, {} as Record<T, number>)\n}\n\nconst result = frequency(['a', 'b', 'a', 'c', 'b', 'a'])\nconsole.log(result['a'])",
    "expected_output": "3",
    "hints": [
      "Inside reduce: acc[val] = (acc[val] || 0) + 1",
      "The || 0 handles the first occurrence when acc[val] is undefined",
      "reduce starts with an empty object {} cast to Record<T, number>"
    ],
    "solution": "function frequency<T extends string>(arr: T[]): Record<T, number> {\n  return arr.reduce((acc, val) => {\n    acc[val] = (acc[val] || 0) + 1\n    return acc\n  }, {} as Record<T, number>)\n}\n\nconst result = frequency(['a', 'b', 'a', 'c', 'b', 'a'])\nconsole.log(result['a'])"
  }$json$::jsonb,
  'typescript'
);
