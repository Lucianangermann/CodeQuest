-- 005_more_lessons.sql: Lessons for topics 2-11

-- ============================================================
-- TOPIC 2: Data Types
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  2,
  'Understanding Python Data Types',
  'theory',
  $json${
    "sections": [
      {
        "type": "text",
        "content": "## Python Data Types\n\nEvery value in Python has a **data type**. The most common built-in types are:\n\n- `int` — whole numbers like `42` or `-7`\n- `float` — decimal numbers like `3.14` or `-0.5`\n- `str` — text enclosed in quotes like `\"hello\"`\n- `bool` — either `True` or `False`\n- `NoneType` — the special value `None`, meaning \"no value\"\n\nUse the built-in `type()` function to check the type of any value."
      },
      {
        "type": "code",
        "language": "python",
        "content": "print(type(42))        # <class 'int'>\nprint(type(3.14))      # <class 'float'>\nprint(type(\"hello\"))   # <class 'str'>\nprint(type(True))      # <class 'bool'>\nprint(type(None))      # <class 'NoneType'>"
      },
      {
        "type": "text",
        "content": "## Checking Length\n\nFor strings and other sequences, `len()` returns the number of characters (or elements).\n\n## Type Conversion\n\nYou can convert between types using built-in functions:\n\n- `int()` — converts to integer (e.g. `int(\"5\")` → `5`)\n- `float()` — converts to float (e.g. `float(3)` → `3.0`)\n- `str()` — converts to string (e.g. `str(42)` → `\"42\"`)\n- `bool()` — converts to boolean (`0`, `\"\"`, and `None` are `False`; everything else is `True`)"
      },
      {
        "type": "code",
        "language": "python",
        "content": "# len() on strings\nname = \"Python\"\nprint(len(name))        # 6\n\n# Type conversion\nage_str = \"25\"\nage_int = int(age_str)\nprint(age_int + 5)      # 30\n\nprice = 9\nprint(float(price))     # 9.0\n\ncount = 0\nprint(bool(count))      # False — 0 is falsy\nprint(bool(42))         # True — non-zero is truthy"
      }
    ],
    "summary": "Python has five core data types — int, float, str, bool, and None — and you can check or convert them using type(), len(), int(), float(), str(), and bool()."
  }$json$,
  15,
  1
);

INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  2,
  'Data Types Quiz',
  'quiz',
  $json${
    "question": "Which built-in function returns the data type of a value in Python?",
    "options": ["len()", "type()", "str()", "id()"],
    "correct_index": 1,
    "explanation": "type() returns the class/type of any Python object. For example, type(42) returns <class 'int'> and type(\"hello\") returns <class 'str'>. len() returns length, str() converts to string, and id() returns the memory address."
  }$json$,
  10,
  2
);

INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  2,
  'Celsius to Fahrenheit',
  'code',
  $json${
    "instructions": "Create a variable `celsius` with the value `100.0`. Convert it to Fahrenheit using the formula `(celsius * 9/5) + 32` and print the result.\n\nExpected output:\n```\n212.0\n```",
    "starter_code": "# Store the temperature in Celsius\ncelsius = \n\n# Convert to Fahrenheit using: (celsius * 9/5) + 32\nfahrenheit = \n\nprint(fahrenheit)\n",
    "expected_output": "212.0\n",
    "hints": [
      "Start by assigning the value 100.0 to a variable called celsius.",
      "Use the formula: fahrenheit = (celsius * 9/5) + 32",
      "celsius = 100.0\nfahrenheit = (celsius * 9/5) + 32\nprint(fahrenheit)"
    ],
    "solution": "celsius = 100.0\nfahrenheit = (celsius * 9/5) + 32\nprint(fahrenheit)\n"
  }$json$,
  20,
  3
);

-- ============================================================
-- TOPIC 3: Conditionals
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  3,
  'Making Decisions with Conditionals',
  'theory',
  $json${
    "sections": [
      {
        "type": "text",
        "content": "## if / elif / else\n\nConditionals let your program make decisions. Python uses `if`, `elif` (else-if), and `else` to branch based on conditions.\n\n```\nif <condition>:\n    # runs when condition is True\nelif <other_condition>:\n    # runs when first is False but this is True\nelse:\n    # runs when all conditions are False\n```\n\nIndentation (4 spaces) is how Python groups code into blocks."
      },
      {
        "type": "code",
        "language": "python",
        "content": "temperature = 22\n\nif temperature > 30:\n    print(\"It's hot outside\")\nelif temperature > 15:\n    print(\"Nice weather\")   # This prints\nelse:\n    print(\"It's cold outside\")"
      },
      {
        "type": "text",
        "content": "## Comparison Operators\n\n| Operator | Meaning |\n|----------|--------------------|\n| `==` | equal to |\n| `!=` | not equal to |\n| `<` | less than |\n| `>` | greater than |\n| `<=` | less than or equal |\n| `>=` | greater than or equal |\n\n## Logical Operators\n\nCombine conditions with `and`, `or`, and `not`:\n\n- `and` — both conditions must be True\n- `or` — at least one must be True\n- `not` — inverts a boolean"
      },
      {
        "type": "code",
        "language": "python",
        "content": "age = 20\nhas_ticket = True\n\n# and: both must be True\nif age >= 18 and has_ticket:\n    print(\"Welcome in!\")   # prints\n\n# or: at least one True\nif age < 13 or age > 65:\n    print(\"Discounted price\")\nelse:\n    print(\"Full price\")    # prints\n\n# not: inverts the boolean\nif not has_ticket:\n    print(\"Buy a ticket first\")\nelse:\n    print(\"You have a ticket\")  # prints"
      }
    ],
    "summary": "Use if/elif/else to branch your code based on conditions, combining comparison operators (==, !=, <, >, <=, >=) and logical operators (and, or, not)."
  }$json$,
  15,
  1
);

INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  3,
  'Conditionals Quiz',
  'quiz',
  $json${
    "question": "What does the following code print?\n\n```python\nx = 15\nif x > 10:\n    print(\"big\")\nelif x > 5:\n    print(\"medium\")\nelse:\n    print(\"small\")\n```",
    "options": ["small", "medium", "big", "Nothing — it causes an error"],
    "correct_index": 2,
    "explanation": "Python evaluates conditions top to bottom and runs the first block whose condition is True. Since x=15 satisfies x > 10, it prints \"big\" and skips the elif and else branches entirely."
  }$json$,
  10,
  2
);

INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  3,
  'Letter Grade Calculator',
  'code',
  $json${
    "instructions": "Set a variable `score = 85`. Use conditionals to print the corresponding letter grade:\n\n- 90 and above → `A`\n- 80 to 89 → `B`\n- 70 to 79 → `C`\n- 60 to 69 → `D`\n- Below 60 → `F`\n\nExpected output:\n```\nB\n```",
    "starter_code": "score = 85\n\nif score >= 90:\n    print(\"A\")\nelif score >= :\n    # print B\nelif score >= :\n    # print C\nelif score >= :\n    # print D\nelse:\n    # print F\n",
    "expected_output": "B\n",
    "hints": [
      "Use elif to check each grade boundary, starting from the highest.",
      "The boundaries are 90, 80, 70, and 60. Since you check from top to bottom, you only need >= each threshold.",
      "score = 85\nif score >= 90:\n    print(\"A\")\nelif score >= 80:\n    print(\"B\")\nelif score >= 70:\n    print(\"C\")\nelif score >= 60:\n    print(\"D\")\nelse:\n    print(\"F\")"
    ],
    "solution": "score = 85\nif score >= 90:\n    print(\"A\")\nelif score >= 80:\n    print(\"B\")\nelif score >= 70:\n    print(\"C\")\nelif score >= 60:\n    print(\"D\")\nelse:\n    print(\"F\")\n"
  }$json$,
  20,
  3
);

-- ============================================================
-- TOPIC 4: Loops
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  4,
  'Repeating Actions with Loops',
  'theory',
  $json${
    "sections": [
      {
        "type": "text",
        "content": "## for Loops\n\nA `for` loop repeats a block of code for each item in a sequence. `range()` generates a sequence of numbers.\n\n- `range(5)` → 0, 1, 2, 3, 4\n- `range(1, 6)` → 1, 2, 3, 4, 5\n- `range(0, 10, 2)` → 0, 2, 4, 6, 8 (step of 2)"
      },
      {
        "type": "code",
        "language": "python",
        "content": "# Counting from 1 to 5\nfor i in range(1, 6):\n    print(i)\n\n# Iterating over a list\nfruits = [\"apple\", \"banana\", \"cherry\"]\nfor fruit in fruits:\n    print(fruit)"
      },
      {
        "type": "text",
        "content": "## while Loops\n\nA `while` loop keeps running as long as its condition is `True`. Be careful — a wrong condition can create an infinite loop!\n\n## break and continue\n\n- `break` — immediately exits the loop\n- `continue` — skips the rest of this iteration and moves to the next\n\n## enumerate()\n\n`enumerate()` gives you both the index and the value when looping over a sequence."
      },
      {
        "type": "code",
        "language": "python",
        "content": "# while loop\ncount = 0\nwhile count < 3:\n    print(count)    # 0, 1, 2\n    count += 1\n\n# break: stop early\nfor i in range(10):\n    if i == 5:\n        break\n    print(i)        # prints 0 1 2 3 4\n\n# continue: skip even numbers\nfor i in range(5):\n    if i % 2 == 0:\n        continue\n    print(i)        # prints 1 3\n\n# enumerate: index + value\ncolors = [\"red\", \"green\", \"blue\"]\nfor index, color in enumerate(colors):\n    print(index, color)  # 0 red, 1 green, 2 blue"
      }
    ],
    "summary": "Use for loops with range() to repeat code a set number of times, while loops for condition-based repetition, and break/continue to control loop flow."
  }$json$,
  15,
  1
);

INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  4,
  'Loops Quiz',
  'quiz',
  $json${
    "question": "What does the following code print?\n\n```python\ntotal = 0\nfor i in range(1, 4):\n    total += i\nprint(total)\n```",
    "options": ["3", "4", "6", "10"],
    "correct_index": 2,
    "explanation": "range(1, 4) generates 1, 2, 3. The loop adds each to total: 0+1=1, 1+2=3, 3+3=6. So total is 6 when printed."
  }$json$,
  10,
  2
);

INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  4,
  'FizzBuzz Challenge',
  'code',
  $json${
    "instructions": "Print the numbers 1 through 10, but with special rules:\n- If a number is divisible by **both** 3 and 5, print `FizzBuzz`\n- If divisible by 3 only, print `Fizz`\n- If divisible by 5 only, print `Buzz`\n- Otherwise, print the number\n\nExpected output:\n```\n1\n2\nFizz\n4\nBuzz\nFizz\n7\n8\nFizz\nBuzz\n```",
    "starter_code": "for i in range(1, 11):\n    if i % 3 == 0 and i % 5 == 0:\n        print(\"FizzBuzz\")\n    elif :\n        # divisible by 3\n    elif :\n        # divisible by 5\n    else:\n        print(i)\n",
    "expected_output": "1\n2\nFizz\n4\nBuzz\nFizz\n7\n8\nFizz\nBuzz\n",
    "hints": [
      "Check the FizzBuzz condition (divisible by both) first, before checking 3 or 5 individually.",
      "Use the modulo operator %. A number is divisible by 3 if i % 3 == 0.",
      "for i in range(1, 11):\n    if i % 3 == 0 and i % 5 == 0:\n        print(\"FizzBuzz\")\n    elif i % 3 == 0:\n        print(\"Fizz\")\n    elif i % 5 == 0:\n        print(\"Buzz\")\n    else:\n        print(i)"
    ],
    "solution": "for i in range(1, 11):\n    if i % 3 == 0 and i % 5 == 0:\n        print(\"FizzBuzz\")\n    elif i % 3 == 0:\n        print(\"Fizz\")\n    elif i % 5 == 0:\n        print(\"Buzz\")\n    else:\n        print(i)\n"
  }$json$,
  20,
  3
);

-- ============================================================
-- TOPIC 5: Functions
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  5,
  'Writing Reusable Code with Functions',
  'theory',
  $json${
    "sections": [
      {
        "type": "text",
        "content": "## Defining Functions\n\nA function is a named, reusable block of code. Define it once with `def`, then call it as many times as you need.\n\n```\ndef function_name(parameter1, parameter2):\n    # body of the function\n    return result\n```\n\n- **Parameters** are the variables listed in the function definition\n- **Arguments** are the actual values passed when calling the function\n- `return` sends a value back to the caller; without it the function returns `None`"
      },
      {
        "type": "code",
        "language": "python",
        "content": "def add(a, b):\n    return a + b\n\nresult = add(3, 7)\nprint(result)    # 10\n\ndef greet(name):\n    print(f\"Hello, {name}!\")\n\ngreet(\"Alice\")   # Hello, Alice!"
      },
      {
        "type": "text",
        "content": "## Default Parameters\n\nYou can give parameters default values. If the caller doesn't pass that argument, the default is used.\n\n## Scope: Local vs Global\n\nVariables created **inside** a function are **local** — they exist only within that function and are destroyed when the function returns. Variables defined **outside** all functions are **global** and can be read (but not easily written) inside functions."
      },
      {
        "type": "code",
        "language": "python",
        "content": "# Default parameter\ndef greet(name, greeting=\"Hello\"):\n    return f\"{greeting}, {name}!\"\n\nprint(greet(\"Bob\"))            # Hello, Bob!\nprint(greet(\"Alice\", \"Hi\"))   # Hi, Alice!\n\n# Scope example\nglobal_var = \"I am global\"\n\ndef show_scope():\n    local_var = \"I am local\"\n    print(global_var)   # can read global\n    print(local_var)    # local is accessible here\n\nshow_scope()\n# print(local_var)  # NameError! local_var doesn't exist out here"
      }
    ],
    "summary": "Functions let you package reusable logic with def, accept inputs as parameters, return values with return, and set default parameter values to make arguments optional."
  }$json$,
  15,
  1
);

INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  5,
  'Functions Quiz',
  'quiz',
  $json${
    "question": "What does the following code print?\n\n```python\ndef greet(name, greeting=\"Hello\"):\n    return f\"{greeting}, {name}!\"\n\nprint(greet(\"Alice\"))\n```",
    "options": ["Alice, Hello!", "Hello, Alice!", "greet(\"Alice\")", "None"],
    "correct_index": 1,
    "explanation": "The function uses the default value \"Hello\" for greeting since no second argument was passed. The f-string formats as \"{greeting}, {name}!\" which becomes \"Hello, Alice!\". The return value is then passed to print()."
  }$json$,
  10,
  2
);

INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  5,
  'Sum of Squares',
  'code',
  $json${
    "instructions": "Write a function called `sum_of_squares(a, b)` that returns the sum of the squares of its two arguments (a² + b²). Then call it with the arguments `3` and `4` and print the result.\n\nExpected output:\n```\n25\n```",
    "starter_code": "def sum_of_squares(a, b):\n    # Return a squared plus b squared\n    return \n\nprint(sum_of_squares(3, 4))\n",
    "expected_output": "25\n",
    "hints": [
      "To square a number in Python you can use ** 2 (e.g. a**2) or multiply it by itself (a*a).",
      "The function body should be: return a**2 + b**2",
      "def sum_of_squares(a, b):\n    return a**2 + b**2\n\nprint(sum_of_squares(3, 4))"
    ],
    "solution": "def sum_of_squares(a, b):\n    return a**2 + b**2\n\nprint(sum_of_squares(3, 4))\n"
  }$json$,
  20,
  3
);

-- ============================================================
-- TOPIC 6: Arrays & Lists
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  6,
  'Working with Python Lists',
  'theory',
  $json${
    "sections": [
      {
        "type": "text",
        "content": "## Creating and Indexing Lists\n\nA **list** is an ordered, mutable collection of items enclosed in square brackets `[]`. Items can be of any type and are accessed by their **index** (position), starting at `0`.\n\n**Negative indexing** counts from the end: `-1` is the last element, `-2` is second-to-last, etc.\n\n**Slicing** extracts a portion of a list: `lst[start:stop]` returns items from `start` up to (but not including) `stop`."
      },
      {
        "type": "code",
        "language": "python",
        "content": "fruits = [\"apple\", \"banana\", \"cherry\", \"date\"]\n\n# Indexing\nprint(fruits[0])     # apple\nprint(fruits[-1])    # date (last item)\n\n# Slicing\nprint(fruits[1:3])   # ['banana', 'cherry']\nprint(fruits[:2])    # ['apple', 'banana']\nprint(fruits[2:])    # ['cherry', 'date']"
      },
      {
        "type": "text",
        "content": "## Common List Methods\n\n| Method | Description |\n|--------|-----------------------------|\n| `append(x)` | Add `x` to the end |\n| `remove(x)` | Remove the first occurrence of `x` |\n| `pop(i)` | Remove and return item at index `i` (default: last) |\n| `sort()` | Sort the list in place |\n| `len(lst)` | Return the number of items |\n| `x in lst` | Check if `x` is in the list (returns bool) |"
      },
      {
        "type": "code",
        "language": "python",
        "content": "numbers = [3, 1, 4, 1, 5]\n\nnumbers.append(9)\nprint(numbers)      # [3, 1, 4, 1, 5, 9]\n\nnumbers.remove(1)   # removes first 1\nprint(numbers)      # [3, 4, 1, 5, 9]\n\nlast = numbers.pop()\nprint(last)         # 9\n\nnumbers.sort()\nprint(numbers)      # [1, 3, 4, 5]\n\nprint(len(numbers)) # 4\nprint(4 in numbers) # True"
      }
    ],
    "summary": "Python lists store ordered collections of items with zero-based indexing, support negative indexing and slicing, and provide methods like append, remove, pop, and sort."
  }$json$,
  15,
  1
);

INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  6,
  'Lists Quiz',
  'quiz',
  $json${
    "question": "What does the following code print?\n\n```python\nnums = [10, 20, 30, 40, 50]\nprint(nums[1:3])\n```",
    "options": ["[10, 20, 30]", "[20, 30]", "[20, 30, 40]", "[10, 20]"],
    "correct_index": 1,
    "explanation": "Slicing with [1:3] returns items at indices 1 and 2 (it includes the start index but excludes the stop index). nums[1] is 20 and nums[2] is 30, so the result is [20, 30]."
  }$json$,
  10,
  2
);

INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  6,
  'Sort and Find Max',
  'code',
  $json${
    "instructions": "You have a list `numbers = [5, 2, 8, 1, 9, 3]`. Sort the list in ascending order and print it. Then print the maximum value in the (now sorted) list.\n\nExpected output:\n```\n[1, 2, 3, 5, 8, 9]\n9\n```",
    "starter_code": "numbers = [5, 2, 8, 1, 9, 3]\n\n# Sort the list in place\n\n# Print the sorted list\n\n# Print the maximum value\n",
    "expected_output": "[1, 2, 3, 5, 8, 9]\n9\n",
    "hints": [
      "Use the .sort() method to sort the list in place, then print() it.",
      "After sorting, the maximum value is the last element. You can access it with [-1] or use the built-in max() function.",
      "numbers = [5, 2, 8, 1, 9, 3]\nnumbers.sort()\nprint(numbers)\nprint(numbers[-1])"
    ],
    "solution": "numbers = [5, 2, 8, 1, 9, 3]\nnumbers.sort()\nprint(numbers)\nprint(numbers[-1])\n"
  }$json$,
  20,
  3
);

-- ============================================================
-- TOPIC 7: Objects & Dicts
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  7,
  'Storing Key-Value Data with Dictionaries',
  'theory',
  $json${
    "sections": [
      {
        "type": "text",
        "content": "## What is a Dictionary?\n\nA **dictionary** (dict) stores data as **key-value pairs** inside curly braces `{}`. Keys are unique identifiers (usually strings), and values can be any type. Dictionaries are ideal when you want to look up a value by name rather than by position.\n\n```python\nperson = {\"name\": \"Alice\", \"age\": 30}\n```\n\nAccess values with square bracket notation `dict[key]`, or use `.get(key, default)` to avoid a `KeyError` if the key might not exist."
      },
      {
        "type": "code",
        "language": "python",
        "content": "person = {\"name\": \"Alice\", \"age\": 30, \"city\": \"Berlin\"}\n\n# Access by key\nprint(person[\"name\"])          # Alice\n\n# .get() with a default value\nprint(person.get(\"country\", \"Unknown\"))  # Unknown\n\n# Add or update a key\nperson[\"email\"] = \"alice@example.com\"\nperson[\"age\"] = 31\nprint(person[\"age\"])           # 31"
      },
      {
        "type": "text",
        "content": "## Iterating Over Dictionaries\n\nThree useful methods for looping:\n\n- `.keys()` — iterate over all keys\n- `.values()` — iterate over all values\n- `.items()` — iterate over (key, value) tuples — the most common choice"
      },
      {
        "type": "code",
        "language": "python",
        "content": "scores = {\"Alice\": 95, \"Bob\": 82, \"Charlie\": 78}\n\n# Keys\nfor name in scores.keys():\n    print(name)          # Alice, Bob, Charlie\n\n# Values\nfor score in scores.values():\n    print(score)         # 95, 82, 78\n\n# Items (most useful)\nfor name, score in scores.items():\n    print(f\"{name}: {score}\")\n# Alice: 95\n# Bob: 82\n# Charlie: 78"
      }
    ],
    "summary": "Dictionaries map unique keys to values, support fast lookup with dict[key] or .get(key, default), and can be iterated with .keys(), .values(), or .items()."
  }$json$,
  15,
  1
);

INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  7,
  'Dictionaries Quiz',
  'quiz',
  $json${
    "question": "What does the following code print?\n\n```python\nperson = {\"name\": \"Alice\", \"age\": 30}\nprint(person.get(\"city\", \"Unknown\"))\n```",
    "options": ["None", "KeyError", "Alice", "Unknown"],
    "correct_index": 3,
    "explanation": "The .get() method looks up the key \"city\" in the dictionary. Since \"city\" doesn't exist, it returns the default value \"Unknown\" instead of raising a KeyError. This is why .get() is safer than direct bracket access when a key might be missing."
  }$json$,
  10,
  2
);

INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  7,
  'Word Frequency Counter',
  'code',
  $json${
    "instructions": "Count how many times each word appears in the string `text = 'the cat sat on the mat the cat'`. Then print each unique word and its count in **alphabetical order**, formatted as `word: count`.\n\nExpected output:\n```\ncat: 2\nmat: 1\non: 1\nsat: 1\nthe: 3\n```",
    "starter_code": "text = 'the cat sat on the mat the cat'\n\n# Split the text into a list of words\nwords = text.split()\n\n# Count each word using a dictionary\ncounts = {}\nfor word in words:\n    # If word already in counts, increment; otherwise start at 1\n\n# Print in alphabetical order\nfor word in sorted(counts):\n    print()\n",
    "expected_output": "cat: 2\nmat: 1\non: 1\nsat: 1\nthe: 3\n",
    "hints": [
      "Use text.split() to get a list of words. Then loop through them and build a dictionary where each key is a word and each value is its count.",
      "To increment safely: counts[word] = counts.get(word, 0) + 1. This handles the case where the word hasn't been seen yet.",
      "text = 'the cat sat on the mat the cat'\nwords = text.split()\ncounts = {}\nfor word in words:\n    counts[word] = counts.get(word, 0) + 1\nfor word in sorted(counts):\n    print(f\"{word}: {counts[word]}\")"
    ],
    "solution": "text = 'the cat sat on the mat the cat'\nwords = text.split()\ncounts = {}\nfor word in words:\n    counts[word] = counts.get(word, 0) + 1\nfor word in sorted(counts):\n    print(f\"{word}: {counts[word]}\")\n"
  }$json$,
  20,
  3
);

-- ============================================================
-- TOPIC 8: Object-Oriented Programming
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  8,
  'Introduction to Object-Oriented Programming',
  'theory',
  $json${
    "sections": [
      {
        "type": "text",
        "content": "## What is OOP?\n\n**Object-Oriented Programming (OOP)** organizes code around **objects** — bundles of data (attributes) and behavior (methods). A **class** is the blueprint; an **instance** is the actual object created from that blueprint.\n\n```\nclass ClassName:\n    def __init__(self, param1, param2):\n        self.attribute1 = param1\n        self.attribute2 = param2\n\n    def some_method(self):\n        return self.attribute1\n```\n\n- `__init__` is the **constructor** — it runs automatically when you create a new instance\n- `self` refers to the specific instance being created or operated on\n- Instance variables (set with `self.`) belong to each individual object"
      },
      {
        "type": "code",
        "language": "python",
        "content": "class Dog:\n    def __init__(self, name, breed):\n        self.name = name      # instance variable\n        self.breed = breed    # instance variable\n\n    def bark(self):\n        return f\"{self.name} says: Woof!\"\n\n    def describe(self):\n        return f\"{self.name} is a {self.breed}\"\n\n# Create instances\ndog1 = Dog(\"Rex\", \"Labrador\")\ndog2 = Dog(\"Luna\", \"Poodle\")\n\nprint(dog1.bark())       # Rex says: Woof!\nprint(dog2.describe())   # Luna is a Poodle\nprint(dog1.name)         # Rex"
      },
      {
        "type": "text",
        "content": "## Why Use Classes?\n\nClasses let you:\n- **Encapsulate** related data and behavior together\n- **Reuse** code by creating many instances from one blueprint\n- **Model** real-world concepts in your code\n\nEach instance has its own copy of instance variables, so `dog1.name` and `dog2.name` are completely independent."
      },
      {
        "type": "code",
        "language": "python",
        "content": "class BankAccount:\n    def __init__(self, owner, balance=0):\n        self.owner = owner\n        self.balance = balance\n\n    def deposit(self, amount):\n        self.balance += amount\n        return self.balance\n\n    def withdraw(self, amount):\n        if amount > self.balance:\n            return \"Insufficient funds\"\n        self.balance -= amount\n        return self.balance\n\naccount = BankAccount(\"Alice\", 100)\nprint(account.deposit(50))   # 150\nprint(account.withdraw(30))  # 120"
      }
    ],
    "summary": "Classes are blueprints for objects: __init__ initializes instance variables with self, and methods define the behavior each object can perform."
  }$json$,
  15,
  1
);

INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  8,
  'OOP Quiz',
  'quiz',
  $json${
    "question": "Given this class, what does the code print?\n\n```python\nclass Dog:\n    def __init__(self, name):\n        self.name = name\n\n    def bark(self):\n        return f\"{self.name} says: Woof!\"\n\ndog = Dog(\"Rex\")\nprint(dog.bark())\n```",
    "options": ["Woof!", "Rex", "Rex says: Woof!", "dog.bark()"],
    "correct_index": 2,
    "explanation": "When Dog(\"Rex\") is called, __init__ sets self.name = \"Rex\". Calling dog.bark() returns the f-string f\"{self.name} says: Woof!\" which evaluates to \"Rex says: Woof!\". That string is then passed to print()."
  }$json$,
  10,
  2
);

INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  8,
  'Rectangle Class',
  'code',
  $json${
    "instructions": "Create a class called `Rectangle` that takes `width` and `height` in its constructor. Add two methods:\n- `area()` — returns width × height\n- `perimeter()` — returns 2 × (width + height)\n\nCreate a `Rectangle(4, 6)` and print its area, then its perimeter.\n\nExpected output:\n```\n24\n20\n```",
    "starter_code": "class Rectangle:\n    def __init__(self, width, height):\n        self.width = \n        self.height = \n\n    def area(self):\n        return \n\n    def perimeter(self):\n        return \n\nrect = Rectangle(4, 6)\nprint(rect.area())\nprint(rect.perimeter())\n",
    "expected_output": "24\n20\n",
    "hints": [
      "In __init__, store the parameters as instance variables: self.width = width and self.height = height.",
      "area() returns self.width * self.height. perimeter() returns 2 * (self.width + self.height).",
      "class Rectangle:\n    def __init__(self, width, height):\n        self.width = width\n        self.height = height\n\n    def area(self):\n        return self.width * self.height\n\n    def perimeter(self):\n        return 2 * (self.width + self.height)\n\nrect = Rectangle(4, 6)\nprint(rect.area())\nprint(rect.perimeter())"
    ],
    "solution": "class Rectangle:\n    def __init__(self, width, height):\n        self.width = width\n        self.height = height\n\n    def area(self):\n        return self.width * self.height\n\n    def perimeter(self):\n        return 2 * (self.width + self.height)\n\nrect = Rectangle(4, 6)\nprint(rect.area())\nprint(rect.perimeter())\n"
  }$json$,
  20,
  3
);

-- ============================================================
-- TOPIC 9: Error Handling
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  9,
  'Handling Errors Gracefully',
  'theory',
  $json${
    "sections": [
      {
        "type": "text",
        "content": "## What are Exceptions?\n\nWhen Python encounters an error at runtime, it **raises an exception** and stops executing. Instead of letting your program crash, you can **catch** exceptions with a `try/except` block.\n\n```\ntry:\n    # code that might fail\nexcept SomeError:\n    # code to handle the error\n```\n\nCommon built-in exceptions:\n- `ValueError` — wrong value type (e.g. `int(\"hello\")`)\n- `TypeError` — wrong argument type (e.g. `\"2\" + 2`)\n- `ZeroDivisionError` — dividing by zero\n- `IndexError` — list index out of range\n- `KeyError` — dict key doesn't exist"
      },
      {
        "type": "code",
        "language": "python",
        "content": "# Without error handling — program crashes\n# print(10 / 0)   # ZeroDivisionError!\n\n# With try/except\ntry:\n    result = 10 / 0\nexcept ZeroDivisionError:\n    print(\"Cannot divide by zero\")\n\n# Catching multiple exception types\ntry:\n    number = int(\"not a number\")\nexcept ValueError as e:\n    print(f\"ValueError: {e}\")\nexcept TypeError:\n    print(\"Wrong type\")"
      },
      {
        "type": "text",
        "content": "## finally and raise\n\n- `finally` runs **always**, whether an exception occurred or not — useful for cleanup (e.g. closing files)\n- `raise` lets you deliberately trigger an exception with a custom message\n\nYou can also use `except Exception as e` to catch any exception and inspect the error message stored in `e`."
      },
      {
        "type": "code",
        "language": "python",
        "content": "# finally always runs\ntry:\n    data = [1, 2, 3]\n    print(data[10])         # IndexError\nexcept IndexError:\n    print(\"Index out of range\")\nfinally:\n    print(\"This always runs\")\n\n# Raising your own exception\ndef set_age(age):\n    if age < 0:\n        raise ValueError(\"Age cannot be negative\")\n    return age\n\ntry:\n    set_age(-5)\nexcept ValueError as e:\n    print(e)   # Age cannot be negative"
      }
    ],
    "summary": "Use try/except to catch runtime exceptions like ValueError, TypeError, ZeroDivisionError, IndexError, and KeyError, and use finally for cleanup code that must always run."
  }$json$,
  15,
  1
);

INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  9,
  'Error Handling Quiz',
  'quiz',
  $json${
    "question": "What does the following code print?\n\n```python\ntry:\n    print([1, 2, 3][5])\nexcept IndexError:\n    print(\"Out of range!\")\nexcept Exception:\n    print(\"Other error\")\n```",
    "options": ["None", "Other error", "Out of range!", "IndexError: list index out of range"],
    "correct_index": 2,
    "explanation": "Accessing index 5 of a 3-element list raises an IndexError. Python checks except clauses top to bottom and the first matching one (IndexError) runs, printing \"Out of range!\". The more general except Exception clause is skipped."
  }$json$,
  10,
  2
);

INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  9,
  'Safe Division Function',
  'code',
  $json${
    "instructions": "Write a function `safe_divide(a, b)` that divides `a` by `b`. It should:\n- Return `'Error: division by zero'` if `b` is `0`\n- Return `'Error: invalid input'` if either `a` or `b` is not a number\n- Otherwise return the result of `a / b`\n\nThen print:\n- `safe_divide(10, 2)`\n- `safe_divide(5, 0)`\n- `safe_divide(10, 'a')`\n\nExpected output:\n```\n5.0\nError: division by zero\nError: invalid input\n```",
    "starter_code": "def safe_divide(a, b):\n    try:\n        return \n    except ZeroDivisionError:\n        return \n    except TypeError:\n        return \n\nprint(safe_divide(10, 2))\nprint(safe_divide(5, 0))\nprint(safe_divide(10, 'a'))\n",
    "expected_output": "5.0\nError: division by zero\nError: invalid input\n",
    "hints": [
      "Put a / b inside the try block. Each except block should return the appropriate error string.",
      "ZeroDivisionError handles dividing by zero. TypeError is raised when you try to divide by a string.",
      "def safe_divide(a, b):\n    try:\n        return a / b\n    except ZeroDivisionError:\n        return 'Error: division by zero'\n    except TypeError:\n        return 'Error: invalid input'\n\nprint(safe_divide(10, 2))\nprint(safe_divide(5, 0))\nprint(safe_divide(10, 'a'))"
    ],
    "solution": "def safe_divide(a, b):\n    try:\n        return a / b\n    except ZeroDivisionError:\n        return 'Error: division by zero'\n    except TypeError:\n        return 'Error: invalid input'\n\nprint(safe_divide(10, 2))\nprint(safe_divide(5, 0))\nprint(safe_divide(10, 'a'))\n"
  }$json$,
  20,
  3
);

-- ============================================================
-- TOPIC 10: APIs
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  10,
  'Understanding APIs and HTTP',
  'theory',
  $json${
    "sections": [
      {
        "type": "text",
        "content": "## What is an API?\n\nAn **API (Application Programming Interface)** is a way for two pieces of software to communicate. A **REST API** lets your code talk to a remote server over the internet using standard HTTP methods.\n\nThink of it like a restaurant: you (the client) give your order to the waiter (the API), who brings your request to the kitchen (the server), and returns your food (the response).\n\n## HTTP Methods\n\n| Method | Purpose |\n|--------|------------------------|\n| `GET` | Read / retrieve data |\n| `POST` | Create a new resource |\n| `PUT` | Update an existing resource |\n| `DELETE` | Delete a resource |"
      },
      {
        "type": "code",
        "language": "python",
        "content": "import requests\n\n# GET request — fetch data\nresponse = requests.get(\"https://api.example.com/users/1\")\nprint(response.status_code)  # 200\ndata = response.json()        # parse JSON response\nprint(data[\"name\"])\n\n# POST request — send data to create a resource\nnew_user = {\"name\": \"Alice\", \"email\": \"alice@example.com\"}\nresponse = requests.post(\"https://api.example.com/users\", json=new_user)\nprint(response.status_code)  # 201 Created"
      },
      {
        "type": "text",
        "content": "## HTTP Status Codes\n\nThe server responds with a status code indicating what happened:\n\n| Code | Meaning |\n|------|-------------------|\n| `200` | OK — success |\n| `201` | Created — resource created |\n| `404` | Not Found |\n| `500` | Internal Server Error |\n\n## JSON\n\n**JSON (JavaScript Object Notation)** is the standard data format for APIs. Python's built-in `json` module lets you convert between JSON strings and Python dicts/lists:\n\n- `json.loads(string)` — parse JSON string → Python object\n- `json.dumps(obj)` — convert Python object → JSON string"
      },
      {
        "type": "code",
        "language": "python",
        "content": "import json\n\n# Parsing JSON\njson_string = '{\"name\": \"Alice\", \"age\": 28}'\ndata = json.loads(json_string)\nprint(data[\"name\"])   # Alice\nprint(type(data))     # <class 'dict'>\n\n# Converting to JSON\nperson = {\"name\": \"Bob\", \"scores\": [95, 82, 78]}\njson_output = json.dumps(person, indent=2)\nprint(json_output)"
      }
    ],
    "summary": "APIs let programs communicate over HTTP using methods GET, POST, PUT, and DELETE; responses return status codes and data in JSON format, which Python's json module can easily parse."
  }$json$,
  15,
  1
);

INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  10,
  'APIs Quiz',
  'quiz',
  $json${
    "question": "Which HTTP method should you use to create a new resource on a server?",
    "options": ["GET", "POST", "DELETE", "PUT"],
    "correct_index": 1,
    "explanation": "POST is used to create a new resource. GET retrieves data, PUT updates an existing resource (replacing it entirely), and DELETE removes a resource. A successful POST typically returns status code 201 Created."
  }$json$,
  10,
  2
);

INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  10,
  'Parse a JSON String',
  'code',
  $json${
    "instructions": "Import the `json` module. Parse the JSON string below into a Python dictionary, then print the name and age on separate lines in the format shown.\n\n```python\ndata = '{\"name\": \"Alice\", \"age\": 28}'\n```\n\nExpected output:\n```\nName: Alice\nAge: 28\n```",
    "starter_code": "import json\n\ndata = '{\"name\": \"Alice\", \"age\": 28}'\n\n# Parse the JSON string into a Python dictionary\nparsed = \n\n# Print Name and Age\nprint()\nprint()\n",
    "expected_output": "Name: Alice\nAge: 28\n",
    "hints": [
      "Use json.loads() to convert the JSON string into a Python dictionary.",
      "After parsing, access the values with parsed[\"name\"] and parsed[\"age\"].",
      "import json\ndata = '{\"name\": \"Alice\", \"age\": 28}'\nparsed = json.loads(data)\nprint(f\"Name: {parsed['name']}\")\nprint(f\"Age: {parsed['age']}\")"
    ],
    "solution": "import json\n\ndata = '{\"name\": \"Alice\", \"age\": 28}'\nparsed = json.loads(data)\nprint(f\"Name: {parsed['name']}\")\nprint(f\"Age: {parsed['age']}\")\n"
  }$json$,
  20,
  3
);

-- ============================================================
-- TOPIC 11: Algorithms & Data Structures
-- ============================================================

INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  11,
  'Big O Notation and Core Data Structures',
  'theory',
  $json${
    "sections": [
      {
        "type": "text",
        "content": "## Big O Notation\n\n**Big O notation** describes how an algorithm's runtime or memory usage grows as the input size `n` increases. It helps you compare algorithms regardless of hardware.\n\n| Notation | Name | Example |\n|----------|-------------|-------------------------------|\n| O(1) | Constant | Dictionary lookup by key |\n| O(log n) | Logarithmic | Binary search |\n| O(n) | Linear | Loop through a list once |\n| O(n²) | Quadratic | Nested loops over same data |\n\nGenerally: O(1) < O(log n) < O(n) < O(n²)"
      },
      {
        "type": "code",
        "language": "python",
        "content": "# O(1) — constant time: same speed no matter the list size\ndef get_first(lst):\n    return lst[0]\n\n# O(n) — linear: visits each element once\ndef linear_search(lst, target):\n    for item in lst:\n        if item == target:\n            return True\n    return False\n\n# O(n²) — quadratic: nested loop, slows fast with large inputs\ndef has_duplicates(lst):\n    for i in range(len(lst)):\n        for j in range(i + 1, len(lst)):\n            if lst[i] == lst[j]:\n                return True\n    return False"
      },
      {
        "type": "text",
        "content": "## Search Algorithms\n\n**Linear Search** — checks every element one by one. Works on any list. O(n).\n\n**Binary Search** — only works on a **sorted** list. Repeatedly halves the search space. O(log n) — much faster for large lists.\n\n## Stacks and Queues\n\n- **Stack** — Last In, First Out (LIFO). Like a stack of plates. Use Python list with `.append()` and `.pop()`.\n- **Queue** — First In, First Out (FIFO). Like a checkout line. Use `collections.deque` with `.append()` and `.popleft()`."
      },
      {
        "type": "code",
        "language": "python",
        "content": "# Stack (LIFO) using a list\nstack = []\nstack.append(\"first\")\nstack.append(\"second\")\nstack.append(\"third\")\nprint(stack.pop())   # third (last in, first out)\n\n# Queue (FIFO) using deque\nfrom collections import deque\nqueue = deque()\nqueue.append(\"first\")\nqueue.append(\"second\")\nqueue.append(\"third\")\nprint(queue.popleft())  # first (first in, first out)"
      }
    ],
    "summary": "Big O notation measures how algorithms scale with input size; O(1) is constant, O(n) is linear, O(n²) is quadratic, and O(log n) is logarithmic — and stacks/queues are fundamental data structures with LIFO and FIFO behavior."
  }$json$,
  15,
  1
);

INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  11,
  'Algorithms Quiz',
  'quiz',
  $json${
    "question": "An algorithm that checks every element in a list exactly once has what time complexity?",
    "options": ["O(1)", "O(log n)", "O(n)", "O(n²)"],
    "correct_index": 2,
    "explanation": "Checking every element once means the number of operations grows linearly with the number of elements (n). This is O(n) — linear time. O(1) is constant (independent of size), O(log n) halves the problem each step (like binary search), and O(n²) uses nested loops over the same data."
  }$json$,
  10,
  2
);

INSERT INTO public.lessons (topic_id, title, type, content_json, xp_reward, order_index) VALUES
(
  11,
  'Implement Linear Search',
  'code',
  $json${
    "instructions": "Write a function `linear_search(lst, target)` that searches through the list `lst` for `target`. Return the **index** of the target if found, or `-1` if it is not in the list.\n\nThen print:\n- `linear_search([3, 7, 1, 9, 4], 9)`\n- `linear_search([3, 7, 1, 9, 4], 5)`\n\nExpected output:\n```\n3\n-1\n```",
    "starter_code": "def linear_search(lst, target):\n    for i in range(len(lst)):\n        if lst[i] == :\n            return \n    return \n\nprint(linear_search([3, 7, 1, 9, 4], 9))\nprint(linear_search([3, 7, 1, 9, 4], 5))\n",
    "expected_output": "3\n-1\n",
    "hints": [
      "Loop through the list using range(len(lst)) so you have access to the index i at each step.",
      "Inside the loop, compare lst[i] == target. If they match, return i immediately. After the loop finishes without finding it, return -1.",
      "def linear_search(lst, target):\n    for i in range(len(lst)):\n        if lst[i] == target:\n            return i\n    return -1\n\nprint(linear_search([3, 7, 1, 9, 4], 9))\nprint(linear_search([3, 7, 1, 9, 4], 5))"
    ],
    "solution": "def linear_search(lst, target):\n    for i in range(len(lst)):\n        if lst[i] == target:\n            return i\n    return -1\n\nprint(linear_search([3, 7, 1, 9, 4], 9))\nprint(linear_search([3, 7, 1, 9, 4], 5))\n"
  }$json$,
  20,
  3
);
