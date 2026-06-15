-- 008: Debug challenges and advanced coding exercises for all 11 topics

-- ============================================================
-- TOPIC 1: Variables
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json) VALUES
(
  1,
  'Debug: Fix the Variable Errors',
  'code',
  25,
  4,
  $json${
    "instructions": "The code below has 3 bugs. Fix them so it prints the correct output.",
    "starter_code": "name = \"Alice\"\nage = 25\ncity = \"Berlin\n\nprint(\"Name:\", nam)\nprint(\"Age:\", ag)\nprint(\"City:\", city)",
    "expected_output": "Name: Alice\nAge: 25\nCity: Berlin",
    "hints": [
      "Look for unclosed string literals",
      "Check variable name spelling carefully",
      "Python is case-sensitive"
    ],
    "solution": "name = \"Alice\"\nage = 25\ncity = \"Berlin\"\n\nprint(\"Name:\", name)\nprint(\"Age:\", age)\nprint(\"City:\", city)"
  }$json$
);

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json) VALUES
(
  1,
  'Advanced: Swap Without Temp Variable',
  'code',
  30,
  5,
  $json${
    "instructions": "Swap the values of a and b using only one line (tuple unpacking), then print them.",
    "starter_code": "a = 10\nb = 20\n\n# Swap a and b in one line\n\nprint(\"a:\", a)\nprint(\"b:\", b)",
    "expected_output": "a: 20\nb: 10",
    "hints": [
      "Python supports tuple unpacking: x, y = y, x",
      "You don't need a third variable",
      "Do the swap before the print statements"
    ],
    "solution": "a = 10\nb = 20\n\na, b = b, a\n\nprint(\"a:\", a)\nprint(\"b:\", b)"
  }$json$
);

-- ============================================================
-- TOPIC 2: Data Types
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json) VALUES
(
  2,
  'Debug: Fix the Type Errors',
  'code',
  25,
  4,
  $json${
    "instructions": "The code below has type errors. Fix them so it prints the correct output.",
    "starter_code": "price = \"19.99\"\nquantity = 3\n\ntotal = price * quantity\nprint(\"Total: $\" + total)",
    "expected_output": "Total: $59.97",
    "hints": [
      "price is a string, not a number",
      "Use float() to convert price",
      "Use str() or f-string to concatenate with the result"
    ],
    "solution": "price = float(\"19.99\")\nquantity = 3\n\ntotal = price * quantity\nprint(\"Total: $\" + str(total))"
  }$json$
);

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json) VALUES
(
  2,
  'Advanced: Type Conversion Pipeline',
  'code',
  30,
  5,
  $json${
    "instructions": "Read the input string '42', convert it to int, square it, then convert back to string and print it.",
    "starter_code": "raw = \"42\"\n\n# Convert to int, square it, convert to string\nresult = ???\n\nprint(result)",
    "expected_output": "1764",
    "hints": [
      "int('42') converts string to integer",
      "** is the power operator in Python",
      "str() converts numbers to string"
    ],
    "solution": "raw = \"42\"\n\nresult = str(int(raw) ** 2)\n\nprint(result)"
  }$json$
);

-- ============================================================
-- TOPIC 3: Conditionals
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json) VALUES
(
  3,
  'Debug: Fix the Grade Logic',
  'code',
  25,
  4,
  $json${
    "instructions": "The code below has syntax errors. Fix them so it prints the correct grade.",
    "starter_code": "score = 75\n\nif score >= 90:\n    grade = \"A\"\nelif score >= 80\n    grade = \"B\"\nelif score >= 70:\n    grade = \"C\"\nelse\n    grade = \"F\"\n\nprint(grade)",
    "expected_output": "C",
    "hints": [
      "Look for missing colons (:) after if/elif/else",
      "Python syntax requires a colon at the end of control flow statements",
      "There are 2 syntax errors"
    ],
    "solution": "score = 75\n\nif score >= 90:\n    grade = \"A\"\nelif score >= 80:\n    grade = \"B\"\nelif score >= 70:\n    grade = \"C\"\nelse:\n    grade = \"F\"\n\nprint(grade)"
  }$json$
);

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json) VALUES
(
  3,
  'Advanced: FizzBuzzOne',
  'code',
  30,
  5,
  $json${
    "instructions": "For the number 15, print 'FizzBuzz' if divisible by both 3 and 5, 'Fizz' if only 3, 'Buzz' if only 5, otherwise the number.",
    "starter_code": "n = 15\n\n# Write your conditional logic here\n",
    "expected_output": "FizzBuzz",
    "hints": [
      "Check divisibility with the % operator",
      "Check both conditions first (divisible by 3 AND 5)",
      "Use elif for the remaining cases"
    ],
    "solution": "n = 15\n\nif n % 3 == 0 and n % 5 == 0:\n    print(\"FizzBuzz\")\nelif n % 3 == 0:\n    print(\"Fizz\")\nelif n % 5 == 0:\n    print(\"Buzz\")\nelse:\n    print(n)"
  }$json$
);

-- ============================================================
-- TOPIC 4: Loops
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json) VALUES
(
  4,
  'Debug: Fix the Loop',
  'code',
  25,
  4,
  $json${
    "instructions": "The code below has a bug. Fix it so it prints the sum of 1 through 5.",
    "starter_code": "total = 0\ni = 1\n\nwhile i <= 5\n    total = total + i\n    i = i + 1\n\nprint(total)",
    "expected_output": "15",
    "hints": [
      "Check for a missing colon in the while statement",
      "Make sure the loop variable is being incremented",
      "1+2+3+4+5 = 15"
    ],
    "solution": "total = 0\ni = 1\n\nwhile i <= 5:\n    total = total + i\n    i = i + 1\n\nprint(total)"
  }$json$
);

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json) VALUES
(
  4,
  'Advanced: Multiplication Table',
  'code',
  30,
  5,
  $json${
    "instructions": "Print the 3 times table from 1 to 5 using a for loop. Each line: '3 x N = result'",
    "starter_code": "# Print: 3 x 1 = 3, 3 x 2 = 6, ... 3 x 5 = 15\n",
    "expected_output": "3 x 1 = 3\n3 x 2 = 6\n3 x 3 = 9\n3 x 4 = 12\n3 x 5 = 15",
    "hints": [
      "Use range(1, 6) to get numbers 1 through 5",
      "Use f-string: f'3 x {n} = {3*n}'",
      "Print each line inside the loop"
    ],
    "solution": "for n in range(1, 6):\n    print(f\"3 x {n} = {3 * n}\")"
  }$json$
);

-- ============================================================
-- TOPIC 5: Functions
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json) VALUES
(
  5,
  'Debug: Fix the Function',
  'code',
  25,
  4,
  $json${
    "instructions": "The function definition has a bug. Fix it so it correctly calculates the area.",
    "starter_code": "def calculate_area(width, height)\n    area = width * height\n    return area\n\nresult = calculate_area(5, 3)\nprint(result)",
    "expected_output": "15",
    "hints": [
      "The function definition is missing something",
      "Python function definitions need a colon at the end",
      "Check the def line carefully"
    ],
    "solution": "def calculate_area(width, height):\n    area = width * height\n    return area\n\nresult = calculate_area(5, 3)\nprint(result)"
  }$json$
);

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json) VALUES
(
  5,
  'Advanced: Factorial with Recursion',
  'code',
  30,
  5,
  $json${
    "instructions": "Write a recursive function factorial(n) that returns n! and print factorial(5).",
    "starter_code": "def factorial(n):\n    # Base case: factorial of 0 or 1 is 1\n    # Recursive case: n * factorial(n-1)\n    pass\n\nprint(factorial(5))",
    "expected_output": "120",
    "hints": [
      "Base case: if n <= 1, return 1",
      "Recursive case: return n * factorial(n-1)",
      "5! = 5×4×3×2×1 = 120"
    ],
    "solution": "def factorial(n):\n    if n <= 1:\n        return 1\n    return n * factorial(n - 1)\n\nprint(factorial(5))"
  }$json$
);

-- ============================================================
-- TOPIC 6: Arrays & Lists
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json) VALUES
(
  6,
  'Debug: Fix the List Operations',
  'code',
  25,
  4,
  $json${
    "instructions": "The code below has 3 bugs. Fix them so it prints the correct output.",
    "starter_code": "fruits = [\"apple\", \"banana\", \"cherry\"]\n\nprint(fruits[3])\nprint(len(fruit))\nfruits.appnd(\"date\")\nprint(fruits)",
    "expected_output": "cherry\n3\n['apple', 'banana', 'cherry', 'date']",
    "hints": [
      "List indexing starts at 0, so the last item is at index len-1",
      "Check the variable name in len()",
      "Check the method name for adding items"
    ],
    "solution": "fruits = [\"apple\", \"banana\", \"cherry\"]\n\nprint(fruits[2])\nprint(len(fruits))\nfruits.append(\"date\")\nprint(fruits)"
  }$json$
);

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json) VALUES
(
  6,
  'Advanced: List Comprehension Filter',
  'code',
  30,
  5,
  $json${
    "instructions": "Use a list comprehension to create a list of squares of even numbers from 1 to 10, then print it.",
    "starter_code": "# Create: [4, 16, 36, 64, 100]\nresult = []\n\nprint(result)",
    "expected_output": "[4, 16, 36, 64, 100]",
    "hints": [
      "range(1, 11) gives 1 through 10",
      "Check if n is even with n % 2 == 0",
      "List comprehension: [n**2 for n in range(1,11) if n%2==0]"
    ],
    "solution": "result = [n**2 for n in range(1, 11) if n % 2 == 0]\n\nprint(result)"
  }$json$
);

-- ============================================================
-- TOPIC 7: Objects & Dicts
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json) VALUES
(
  7,
  'Debug: Fix the Dictionary',
  'code',
  25,
  4,
  $json${
    "instructions": "The code below has 2 bugs. Fix them so it prints the correct output.",
    "starter_code": "person = {\n    \"name\": \"Bob\",\n    \"age\": 30\n    \"city\": \"Paris\"\n}\n\nprint(person[\"name\"])\nprint(person[\"country\"])",
    "expected_output": "Bob\nParis",
    "hints": [
      "Check the dictionary syntax — are all key-value pairs properly separated?",
      "A comma is missing between entries",
      "The second print is accessing a key that doesn't exist — use the correct key"
    ],
    "solution": "person = {\n    \"name\": \"Bob\",\n    \"age\": 30,\n    \"city\": \"Paris\"\n}\n\nprint(person[\"name\"])\nprint(person[\"city\"])"
  }$json$
);

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json) VALUES
(
  7,
  'Advanced: Word Count Dictionary',
  'code',
  30,
  5,
  $json${
    "instructions": "Count how many times each word appears in the sentence and print the dict sorted by key.",
    "starter_code": "sentence = \"the cat sat on the mat the cat\"\ncounts = {}\n\n# Count word frequencies\n\nprint(dict(sorted(counts.items())))",
    "expected_output": "{'cat': 2, 'mat': 1, 'on': 1, 'sat': 1, 'the': 3}",
    "hints": [
      "Split the sentence with .split()",
      "For each word, increment counts[word] by 1",
      "Use counts.get(word, 0) to handle missing keys"
    ],
    "solution": "sentence = \"the cat sat on the mat the cat\"\ncounts = {}\n\nfor word in sentence.split():\n    counts[word] = counts.get(word, 0) + 1\n\nprint(dict(sorted(counts.items())))"
  }$json$
);

-- ============================================================
-- TOPIC 8: OOP
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json) VALUES
(
  8,
  'Debug: Fix the Class',
  'code',
  25,
  4,
  $json${
    "instructions": "The class definition has a bug. Fix it so the dog can bark correctly.",
    "starter_code": "class Dog:\n    def __init__(name, breed):\n        self.name = name\n        self.breed = breed\n    \n    def bark(self):\n        return f\"{self.name} says: Woof!\"\n\ndog = Dog(\"Rex\", \"Labrador\")\nprint(dog.bark())",
    "expected_output": "Rex says: Woof!",
    "hints": [
      "__init__ must take 'self' as its first parameter",
      "Check the parameters of the __init__ method",
      "All instance methods need 'self' as the first argument"
    ],
    "solution": "class Dog:\n    def __init__(self, name, breed):\n        self.name = name\n        self.breed = breed\n    \n    def bark(self):\n        return f\"{self.name} says: Woof!\"\n\ndog = Dog(\"Rex\", \"Labrador\")\nprint(dog.bark())"
  }$json$
);

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json) VALUES
(
  8,
  'Advanced: Inheritance',
  'code',
  30,
  5,
  $json${
    "instructions": "Create a class Animal with a speak() method returning 'Some sound', then create class Cat that inherits from Animal and overrides speak() to return 'Meow'. Print Cat().speak().",
    "starter_code": "class Animal:\n    def speak(self):\n        return \"Some sound\"\n\nclass Cat(Animal):\n    # Override speak()\n    pass\n\nprint(Cat().speak())",
    "expected_output": "Meow",
    "hints": [
      "Override the speak() method in the Cat class",
      "Return 'Meow' from Cat's speak() method",
      "The Cat class already inherits from Animal — just add the method"
    ],
    "solution": "class Animal:\n    def speak(self):\n        return \"Some sound\"\n\nclass Cat(Animal):\n    def speak(self):\n        return \"Meow\"\n\nprint(Cat().speak())"
  }$json$
);

-- ============================================================
-- TOPIC 9: Error Handling
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json) VALUES
(
  9,
  'Debug: Fix the Error Handler',
  'code',
  25,
  4,
  $json${
    "instructions": "The error handler is too broad. Fix it to catch only ZeroDivisionError so the output matches.",
    "starter_code": "def divide(a, b):\n    try:\n        result = a / b\n        return result\n    except:\n        print(\"Error: division by zero\")\n\nprint(divide(10, 0))\nprint(divide(10, 2))",
    "expected_output": "Error: division by zero\nNone\n5.0",
    "hints": [
      "The function should return None after the error (which it already does implicitly)",
      "This code actually works — look at the expected output carefully",
      "The output should show None after the error message, then the successful result"
    ],
    "solution": "def divide(a, b):\n    try:\n        result = a / b\n        return result\n    except ZeroDivisionError:\n        print(\"Error: division by zero\")\n\nprint(divide(10, 0))\nprint(divide(10, 2))"
  }$json$
);

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json) VALUES
(
  9,
  'Advanced: Multiple Exception Types',
  'code',
  30,
  5,
  $json${
    "instructions": "Write code that tries to convert user_input to int and divide 100 by it. Handle ValueError (print 'Not a number') and ZeroDivisionError (print 'Cannot divide by zero'). Test with user_input = '0'.",
    "starter_code": "user_input = \"0\"\n\ntry:\n    # Convert to int and divide 100 by it\n    pass\nexcept ValueError:\n    print(\"Not a number\")\nexcept ZeroDivisionError:\n    print(\"Cannot divide by zero\")",
    "expected_output": "Cannot divide by zero",
    "hints": [
      "Convert with int(user_input)",
      "Then divide 100 by the converted number",
      "Each except block handles a different error type"
    ],
    "solution": "user_input = \"0\"\n\ntry:\n    n = int(user_input)\n    print(100 / n)\nexcept ValueError:\n    print(\"Not a number\")\nexcept ZeroDivisionError:\n    print(\"Cannot divide by zero\")"
  }$json$
);

-- ============================================================
-- TOPIC 10: APIs
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json) VALUES
(
  10,
  'Debug: Fix the JSON Parsing',
  'code',
  25,
  4,
  $json${
    "instructions": "The code uses the wrong key name to access JSON data. Fix it so it prints the correct output.",
    "starter_code": "import json\n\nresponse = '{\"user\": \"Alice\", \"score\": 42, \"active\": true}'\n\ndata = json.loads(response)\n\nprint(data[\"username\"])\nprint(data[\"score\"] + 8)\nprint(data[\"active\"])",
    "expected_output": "Alice\n50\nTrue",
    "hints": [
      "Check the key name — is it 'username' or something else?",
      "Look at the JSON string for the exact key name",
      "The key in the JSON is 'user', not 'username'"
    ],
    "solution": "import json\n\nresponse = '{\"user\": \"Alice\", \"score\": 42, \"active\": true}'\n\ndata = json.loads(response)\n\nprint(data[\"user\"])\nprint(data[\"score\"] + 8)\nprint(data[\"active\"])"
  }$json$
);

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json) VALUES
(
  10,
  'Advanced: JSON Data Transformation',
  'code',
  30,
  5,
  $json${
    "instructions": "Parse the JSON list of users and print only active users' names, one per line, sorted alphabetically.",
    "starter_code": "import json\n\nraw = '[{\"name\":\"Charlie\",\"active\":true},{\"name\":\"Alice\",\"active\":true},{\"name\":\"Bob\",\"active\":false}]'\n\nusers = json.loads(raw)\n\n# Print active user names sorted alphabetically\n",
    "expected_output": "Alice\nCharlie",
    "hints": [
      "Filter with a list comprehension: [u for u in users if u['active']]",
      "Extract names with another comprehension or map",
      "Use sorted() to sort the names"
    ],
    "solution": "import json\n\nraw = '[{\"name\":\"Charlie\",\"active\":true},{\"name\":\"Alice\",\"active\":true},{\"name\":\"Bob\",\"active\":false}]'\n\nusers = json.loads(raw)\n\nactive_names = sorted(u[\"name\"] for u in users if u[\"active\"])\nfor name in active_names:\n    print(name)"
  }$json$
);

-- ============================================================
-- TOPIC 11: Algorithms
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json) VALUES
(
  11,
  'Debug: Fix the Search Algorithm',
  'code',
  25,
  4,
  $json${
    "instructions": "The linear search has a bug — it uses the wrong index. Fix it so it returns the correct position.",
    "starter_code": "def linear_search(lst, target):\n    for i in range(len(lst)):\n        if lst[1] == target:\n            return i\n    return -1\n\nnumbers = [3, 7, 1, 9, 4]\nprint(linear_search(numbers, 9))\nprint(linear_search(numbers, 5))",
    "expected_output": "3\n-1",
    "hints": [
      "Look at the index used to access the list element",
      "Should you be using 'i' or '1' (the number one)?",
      "The loop index variable is 'i', but the code uses the literal '1'"
    ],
    "solution": "def linear_search(lst, target):\n    for i in range(len(lst)):\n        if lst[i] == target:\n            return i\n    return -1\n\nnumbers = [3, 7, 1, 9, 4]\nprint(linear_search(numbers, 9))\nprint(linear_search(numbers, 5))"
  }$json$
);

INSERT INTO public.lessons (topic_id, title, type, xp_reward, order_index, content_json) VALUES
(
  11,
  'Advanced: Binary Search',
  'code',
  30,
  5,
  $json${
    "instructions": "Implement binary search on a sorted list. Return the index of target (7) or -1 if not found.",
    "starter_code": "def binary_search(lst, target):\n    left, right = 0, len(lst) - 1\n    \n    while left <= right:\n        mid = (left + right) // 2\n        # Compare lst[mid] with target and adjust left/right\n        pass\n    \n    return -1\n\nnumbers = [1, 3, 5, 7, 9, 11, 13]\nprint(binary_search(numbers, 7))\nprint(binary_search(numbers, 6))",
    "expected_output": "3\n-1",
    "hints": [
      "If lst[mid] == target, return mid",
      "If lst[mid] < target, search the right half: left = mid + 1",
      "If lst[mid] > target, search the left half: right = mid - 1"
    ],
    "solution": "def binary_search(lst, target):\n    left, right = 0, len(lst) - 1\n    \n    while left <= right:\n        mid = (left + right) // 2\n        if lst[mid] == target:\n            return mid\n        elif lst[mid] < target:\n            left = mid + 1\n        else:\n            right = mid - 1\n    \n    return -1\n\nnumbers = [1, 3, 5, 7, 9, 11, 13]\nprint(binary_search(numbers, 7))\nprint(binary_search(numbers, 6))"
  }$json$
);
