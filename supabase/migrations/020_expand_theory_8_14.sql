-- 020: Expand theory lessons for topics 8–14
-- Updates the existing theory lessons (language IS NULL, type = 'theory')
-- with comprehensive multi-section content covering Python, JavaScript, and TypeScript.

-- ============================================================
-- TOPIC 8: Object-Oriented Programming
-- ============================================================

UPDATE lessons
SET content_json = $json${
  "sections": [
    {
      "type": "text",
      "content": "# Object-Oriented Programming\n\n**Object-Oriented Programming (OOP)** is a way of organizing code around real-world *things* rather than just sequences of instructions. Instead of writing a long script that manipulates loose variables, you group related data and behavior together into **objects**.\n\nImagine you are building software for a pet shelter. You could use scattered variables:\n\n```\ndog1_name = \"Rex\"\ndog1_breed = \"Labrador\"\ndog1_age = 3\n```\n\nOr you could model a `Dog` as an object that *knows* its own name, breed, and age, and can *do things* like bark or sit. OOP makes code that maps naturally to the problem you are solving."
    },
    {
      "type": "text",
      "content": "## The Four Pillars of OOP\n\nEvery OOP language is built around four core concepts:\n\n1. **Encapsulation** — bundle data and the functions that work on that data together inside one unit (the class). Hide internal details from the outside world.\n2. **Inheritance** — a child class can *extend* a parent class, reusing and specializing its behavior without rewriting it.\n3. **Polymorphism** — different classes can share the same method name but behave differently. A `Cat` and a `Dog` both have `.speak()`, but they produce different sounds.\n4. **Abstraction** — expose only what is necessary. A car driver does not need to understand the engine internals; they just use the steering wheel and pedals."
    },
    {
      "type": "text",
      "content": "## Classes vs Instances: Blueprint vs Object\n\nA **class** is the *blueprint* — it describes the shape of an object: what data it holds and what it can do.\n\nAn **instance** (also called an object) is one concrete thing created from that blueprint. You can create thousands of instances from a single class, each with its own data.\n\nThink of a class like a cookie cutter and an instance like a cookie. The cutter defines the shape; each cookie is a separate, real thing you can decorate differently."
    },
    {
      "type": "code",
      "language": "python",
      "content": "# Class definition — the blueprint\nclass Dog:\n    # __init__ runs every time you create a new Dog\n    def __init__(self, name, breed, age):\n        self.name = name    # instance attribute\n        self.breed = breed  # instance attribute\n        self.age = age      # instance attribute\n\n    def bark(self):\n        return f\"{self.name} says: Woof!\"\n\n    def describe(self):\n        return f\"{self.name} is a {self.age}-year-old {self.breed}.\"\n\n# Creating instances from the blueprint\ndog1 = Dog(\"Rex\", \"Labrador\", 3)\ndog2 = Dog(\"Luna\", \"Poodle\", 1)\n\nprint(dog1.bark())       # Rex says: Woof!\nprint(dog2.describe())   # Luna is a 1-year-old Poodle.\nprint(dog1.age)          # 3  — each instance has its own data"
    },
    {
      "type": "text",
      "content": "## `__init__` and `constructor`: Initializing State\n\nIn Python, `__init__` is the *initializer* — a special method that Python calls automatically when you write `Dog(\"Rex\", \"Labrador\", 3)`. Inside `__init__`, you assign values to `self.attribute_name` to give the new object its starting state.\n\nIn JavaScript and TypeScript, the equivalent is the `constructor` method inside a class body.\n\nThe first parameter of every Python method is `self`, which is a reference to the instance being worked on. In JS/TS, the equivalent keyword is `this`."
    },
    {
      "type": "code",
      "language": "javascript",
      "content": "// JavaScript class with constructor\nclass Dog {\n  constructor(name, breed, age) {\n    this.name = name;    // instance property\n    this.breed = breed;\n    this.age = age;\n  }\n\n  bark() {\n    return `${this.name} says: Woof!`;\n  }\n\n  describe() {\n    return `${this.name} is a ${this.age}-year-old ${this.breed}.`;\n  }\n}\n\nconst dog1 = new Dog(\"Rex\", \"Labrador\", 3);\nconst dog2 = new Dog(\"Luna\", \"Poodle\", 1);\n\nconsole.log(dog1.bark());       // Rex says: Woof!\nconsole.log(dog2.describe());   // Luna is a 1-year-old Poodle."
    },
    {
      "type": "text",
      "content": "## Public vs Private: Hiding Internal Details\n\nEncapsulation means hiding implementation details so the outside world can't accidentally break internal state.\n\n**Python convention:** Prefix an attribute with a single underscore `_name` to signal \"internal use only\" (it's a convention, not enforced). Prefix with double underscore `__name` for Python's name-mangling (harder to access from outside).\n\n**TypeScript:** Has the `private` keyword (and the newer `#name` syntax) which is enforced by the compiler. `public` is the default. `protected` allows access in subclasses."
    },
    {
      "type": "code",
      "language": "typescript",
      "content": "class BankAccount {\n  private balance: number;  // only accessible inside the class\n  public owner: string;     // accessible from anywhere\n\n  constructor(owner: string, initialBalance: number) {\n    this.owner = owner;\n    this.balance = initialBalance;\n  }\n\n  deposit(amount: number): void {\n    if (amount <= 0) throw new Error(\"Deposit must be positive\");\n    this.balance += amount;\n  }\n\n  getBalance(): number {\n    return this.balance;  // controlled read-only access\n  }\n}\n\nconst account = new BankAccount(\"Alice\", 100);\naccount.deposit(50);\nconsole.log(account.getBalance()); // 150\n// account.balance = 999;  // TypeScript ERROR: property is private"
    },
    {
      "type": "text",
      "content": "## Inheritance: Child Extends Parent\n\nInheritance lets one class **reuse** the behavior of another and then *extend or override* it.\n\n- The **parent class** (also called base class or superclass) defines common behavior.\n- The **child class** (subclass) inherits everything from the parent and can add new methods or override existing ones.\n\nExample: `Animal` is a parent. `Dog` and `Cat` are children. Both animals speak, but differently. Writing shared logic once in `Animal` avoids duplication."
    },
    {
      "type": "code",
      "language": "python",
      "content": "class Animal:\n    def __init__(self, name):\n        self.name = name\n\n    def speak(self):\n        # Base behavior — children will override this\n        return f\"{self.name} makes a sound.\"\n\n    def eat(self):\n        return f\"{self.name} is eating.\"\n\n\nclass Dog(Animal):  # Dog inherits from Animal\n    def speak(self):  # Override the parent's speak()\n        return f\"{self.name} says: Woof!\"\n\n\nclass Cat(Animal):  # Cat inherits from Animal\n    def speak(self):  # Override the parent's speak()\n        return f\"{self.name} says: Meow!\"\n\n\nanimals = [Dog(\"Rex\"), Cat(\"Whiskers\"), Dog(\"Buddy\")]\nfor animal in animals:\n    print(animal.speak())  # Polymorphism: same method, different behavior\n    print(animal.eat())    # Inherited from Animal — works on all\n\n# Output:\n# Rex says: Woof!\n# Rex is eating.\n# Whiskers says: Meow!\n# Whiskers is eating.\n# Buddy says: Woof!\n# Buddy is eating."
    },
    {
      "type": "text",
      "content": "## `super()`: Extending the Parent\n\nWhen you override a method in a child class, you sometimes want to *run the parent's version first*, then add extra behavior. The `super()` function lets you call the parent's method.\n\nThis is especially common in `__init__` (Python) or `constructor` (JS/TS): the child calls `super().__init__(...)` to let the parent set up its attributes, then adds its own."
    },
    {
      "type": "code",
      "language": "python",
      "content": "class Vehicle:\n    def __init__(self, make, model, year):\n        self.make = make\n        self.model = model\n        self.year = year\n\n    def describe(self):\n        return f\"{self.year} {self.make} {self.model}\"\n\n\nclass ElectricCar(Vehicle):\n    def __init__(self, make, model, year, battery_kwh):\n        super().__init__(make, model, year)  # Call Vehicle.__init__\n        self.battery_kwh = battery_kwh       # Add extra attribute\n\n    def describe(self):\n        base = super().describe()  # Get parent's description\n        return f\"{base} (Electric, {self.battery_kwh} kWh battery)\"\n\n\ncar = ElectricCar(\"Tesla\", \"Model 3\", 2023, 82)\nprint(car.describe())\n# 2023 Tesla Model 3 (Electric, 82 kWh battery)"
    },
    {
      "type": "text",
      "content": "## TypeScript: `implements` vs `extends`\n\nTypeScript adds two ways to express relationships between types:\n\n- `extends` — inheritance: the child class *is* the parent and inherits its implementation.\n- `implements` — the class promises to have certain methods/properties defined by an **interface**, but does not inherit any code.\n\nAn interface in TypeScript is a pure contract: it says \"any class that implements me must have these methods,\" but provides no code."
    },
    {
      "type": "code",
      "language": "typescript",
      "content": "// Interface: a contract, no implementation\ninterface Speakable {\n  speak(): string;\n}\n\n// Base class with implementation\nclass Animal {\n  constructor(public name: string) {}\n\n  eat(): string {\n    return `${this.name} is eating.`;\n  }\n}\n\n// Dog extends Animal (inherits eat()) AND implements Speakable\nclass Dog extends Animal implements Speakable {\n  speak(): string {\n    return `${this.name} says: Woof!`;\n  }\n}\n\nconst d = new Dog(\"Rex\");\nconsole.log(d.speak()); // Rex says: Woof!\nconsole.log(d.eat());   // Rex is eating."
    },
    {
      "type": "text",
      "content": "## Python: `isinstance()` and Method Resolution Order\n\n`isinstance(obj, ClassName)` checks whether an object is an instance of a class (or any subclass). This is more reliable than `type(obj) == ClassName` because it respects inheritance.\n\nPython's **Method Resolution Order (MRO)** determines which version of a method is called when a class inherits from multiple parents. Python uses the C3 linearization algorithm — you can inspect it with `ClassName.__mro__`.\n\nMultiple inheritance in Python:\n\n```python\nclass A:\n    def greet(self): return \"Hello from A\"\n\nclass B(A):\n    def greet(self): return \"Hello from B\"\n\nclass C(A):\n    def greet(self): return \"Hello from C\"\n\nclass D(B, C):  # Multiple inheritance\n    pass\n\nprint(D.__mro__)  # D -> B -> C -> A -> object\nd = D()\nprint(d.greet())  # Hello from B (B comes before C in MRO)\n```"
    },
    {
      "type": "text",
      "content": "## When NOT to Use OOP\n\nOOP is a powerful tool, but it is not always the right one:\n\n- **Simple scripts**: A quick data processing script with no shared state does not need classes.\n- **Pure functions**: If your logic is \"transform input → return output\" with no side effects, a plain function is cleaner.\n- **Functional programming**: Languages like Haskell, and features like Python's `map/filter/reduce` or JavaScript's array methods, offer a different but equally powerful paradigm.\n- **Over-engineering**: Writing classes for everything leads to the infamous \"AbstractSingletonProxyFactoryBean\" problem — absurdly deep hierarchies for simple problems.\n\nA good rule of thumb: use a class when you have *multiple pieces of data that belong together* **and** *methods that naturally act on that data*. Otherwise, a function or a dictionary is fine."
    }
  ],
  "summary": "- OOP organizes code around objects: bundles of related data (attributes) and behavior (methods).\n- A class is the blueprint; instances are the real objects created from it.\n- The four pillars are Encapsulation, Inheritance, Polymorphism, and Abstraction.\n- Python uses `__init__` and `self`; JavaScript/TypeScript use `constructor` and `this`.\n- `super()` lets a child class call the parent's method to extend (not replace) it.\n- Prefix with `_` (Python convention) or use `private` (TypeScript) to hide internal state.\n- Not every problem needs OOP — sometimes a plain function is simpler and better."
}$json$::jsonb
WHERE topic_id = (SELECT id FROM topics WHERE title = 'Object-Oriented Programming')
  AND type = 'theory'
  AND language IS NULL;


-- ============================================================
-- TOPIC 9: Error Handling
-- ============================================================

UPDATE lessons
SET content_json = $json${
  "sections": [
    {
      "type": "text",
      "content": "# Error Handling\n\nPrograms encounter unexpected situations all the time: a file that doesn't exist, a network that is down, a user who types text where a number was expected, a division by zero. How your program *responds* to these situations is called **error handling**.\n\nWithout error handling, the first unexpected event crashes your program completely. With good error handling, your program can detect the problem, report a helpful message, clean up after itself, and sometimes even recover automatically.\n\n**Two categories of errors:**\n\n- **Compile-time errors** (in TypeScript, or linting): caught before the program runs — syntax mistakes, type mismatches.\n- **Runtime errors** (exceptions): only appear when the program is actually running with specific input or conditions."
    },
    {
      "type": "text",
      "content": "## Python's Exception Hierarchy\n\nPython organizes all errors into a family tree of classes:\n\n```\nBaseException\n├── SystemExit            # raised by sys.exit()\n├── KeyboardInterrupt     # Ctrl+C from the user\n└── Exception             # all normal errors inherit from here\n    ├── TypeError         # wrong type of argument\n    ├── ValueError        # right type, wrong value (e.g. int(\"abc\"))\n    ├── KeyError          # dict key doesn't exist\n    ├── IndexError        # list index out of range\n    ├── AttributeError    # object doesn't have that attribute\n    ├── ZeroDivisionError # dividing by zero\n    ├── FileNotFoundError # file doesn't exist\n    ├── OSError           # operating system error\n    └── RuntimeError      # generic catch-all\n```\n\nKnowing the hierarchy matters because catching a parent class also catches all its children. Catching `Exception` catches almost everything; catching `TypeError` is very specific."
    },
    {
      "type": "code",
      "language": "python",
      "content": "# Triggering common exceptions\n\n# TypeError: wrong type\ntry:\n    result = \"hello\" + 5\nexcept TypeError as e:\n    print(f\"TypeError: {e}\")\n# TypeError: can only concatenate str (not \"int\") to str\n\n# ValueError: right type, wrong value\ntry:\n    number = int(\"not_a_number\")\nexcept ValueError as e:\n    print(f\"ValueError: {e}\")\n# ValueError: invalid literal for int() with base 10: 'not_a_number'\n\n# KeyError: missing dictionary key\ndata = {\"name\": \"Alice\"}\ntry:\n    age = data[\"age\"]\nexcept KeyError as e:\n    print(f\"KeyError: {e}\")\n# KeyError: 'age'\n\n# ZeroDivisionError\ntry:\n    result = 10 / 0\nexcept ZeroDivisionError as e:\n    print(f\"ZeroDivisionError: {e}\")\n# ZeroDivisionError: division by zero"
    },
    {
      "type": "text",
      "content": "## try / except / else / finally in Python\n\nPython's full error-handling structure has four optional parts:\n\n```python\ntry:\n    # Code that might raise an exception\nexcept SomeError as e:\n    # Runs only if SomeError was raised in the try block\nexcept AnotherError as e:\n    # Runs only if AnotherError was raised\nelse:\n    # Runs only if NO exception was raised in the try block\nfinally:\n    # ALWAYS runs — whether or not an exception occurred\n    # Perfect for cleanup: closing files, releasing locks, etc.\n```\n\n- You can have **multiple `except` clauses** to handle different error types differently.\n- The `else` block is a nice signal: \"this code only makes sense if everything above succeeded.\"\n- The `finally` block runs no matter what — even if you `return` inside the `try`."
    },
    {
      "type": "code",
      "language": "python",
      "content": "def safe_divide(a, b):\n    try:\n        result = a / b\n    except ZeroDivisionError:\n        print(\"Error: Cannot divide by zero.\")\n        return None\n    except TypeError:\n        print(\"Error: Both arguments must be numbers.\")\n        return None\n    else:\n        print(\"Division successful!\")\n        return result\n    finally:\n        print(\"safe_divide() finished.\")  # Always runs\n\nprint(safe_divide(10, 2))\n# Division successful!\n# safe_divide() finished.\n# 5.0\n\nprint(safe_divide(10, 0))\n# Error: Cannot divide by zero.\n# safe_divide() finished.\n# None\n\nprint(safe_divide(10, \"x\"))\n# Error: Both arguments must be numbers.\n# safe_divide() finished.\n# None"
    },
    {
      "type": "text",
      "content": "## try / catch / finally in JavaScript\n\nJavaScript uses similar concepts with slightly different syntax:\n\n```javascript\ntry {\n  // Code that might throw\n} catch (error) {\n  // Runs if anything was thrown\n  // error.message contains the message\n  // error.name contains the error type (e.g. \"TypeError\")\n} finally {\n  // Always runs\n}\n```\n\nJavaScript does **not** have multiple `catch` clauses for different types. Instead, you check `error instanceof SomeError` or `error.name` inside a single `catch` block.\n\nJavaScript also has no `else` equivalent — just put code after the `try/catch` if you want it to run only when no error occurred."
    },
    {
      "type": "code",
      "language": "javascript",
      "content": "function parseUserAge(input) {\n  try {\n    const age = parseInt(input, 10);\n    if (isNaN(age)) {\n      throw new TypeError(`\"${input}\" is not a valid age.`);\n    }\n    if (age < 0 || age > 150) {\n      throw new RangeError(`Age ${age} is out of realistic range.`);\n    }\n    return age;\n  } catch (error) {\n    if (error instanceof TypeError) {\n      console.error(\"Type problem:\", error.message);\n    } else if (error instanceof RangeError) {\n      console.error(\"Range problem:\", error.message);\n    } else {\n      console.error(\"Unknown error:\", error.message);\n    }\n    return null;\n  } finally {\n    console.log(\"parseUserAge() finished.\");\n  }\n}\n\nconsole.log(parseUserAge(\"25\"));    // 25\nconsole.log(parseUserAge(\"abc\"));   // null (TypeError)\nconsole.log(parseUserAge(\"-5\"));    // null (RangeError)"
    },
    {
      "type": "text",
      "content": "## Raising and Throwing Exceptions\n\nYou are not limited to handling exceptions — you can also *create* them when your own code detects an invalid situation.\n\n- **Python**: `raise ExceptionType(\"message\")`\n- **JavaScript/TypeScript**: `throw new Error(\"message\")` or `throw new SomeError(\"message\")`\n\nRaising/throwing early (\"fail fast\") is a good practice: it catches problems at the source rather than allowing corrupted data to travel through your system and cause confusing failures later."
    },
    {
      "type": "text",
      "content": "## Custom Exception Classes\n\nFor large applications, built-in exception types are often too generic. Creating your own exception classes makes errors self-documenting and easier to catch specifically.\n\nIn Python, simply inherit from `Exception` (or a more specific built-in). In JavaScript/TypeScript, inherit from `Error` and be sure to set `this.name`."
    },
    {
      "type": "code",
      "language": "python",
      "content": "# Python: custom exceptions\n\nclass ValidationError(Exception):\n    \"\"\"Raised when user-provided data fails validation.\"\"\"\n    pass\n\nclass InsufficientFundsError(Exception):\n    \"\"\"Raised when a withdrawal exceeds the account balance.\"\"\"\n    def __init__(self, amount, balance):\n        super().__init__(\n            f\"Cannot withdraw {amount}. Balance is only {balance}.\"\n        )\n        self.amount = amount\n        self.balance = balance\n\n\ndef withdraw(balance, amount):\n    if amount <= 0:\n        raise ValidationError(\"Withdrawal amount must be positive.\")\n    if amount > balance:\n        raise InsufficientFundsError(amount, balance)\n    return balance - amount\n\ntry:\n    new_balance = withdraw(100, 150)\nexcept InsufficientFundsError as e:\n    print(e)  # Cannot withdraw 150. Balance is only 100.\nexcept ValidationError as e:\n    print(e)"
    },
    {
      "type": "code",
      "language": "typescript",
      "content": "// TypeScript: custom error classes\n\nclass ValidationError extends Error {\n  constructor(message: string) {\n    super(message);\n    this.name = \"ValidationError\";  // important!\n  }\n}\n\nclass InsufficientFundsError extends Error {\n  amount: number;\n  balance: number;\n\n  constructor(amount: number, balance: number) {\n    super(`Cannot withdraw ${amount}. Balance is only ${balance}.`);\n    this.name = \"InsufficientFundsError\";\n    this.amount = amount;\n    this.balance = balance;\n  }\n}\n\nfunction withdraw(balance: number, amount: number): number {\n  if (amount <= 0) throw new ValidationError(\"Amount must be positive.\");\n  if (amount > balance) throw new InsufficientFundsError(amount, balance);\n  return balance - amount;\n}\n\ntry {\n  withdraw(100, 150);\n} catch (error) {\n  if (error instanceof InsufficientFundsError) {\n    console.error(error.message);\n  }\n}"
    },
    {
      "type": "text",
      "content": "## Context Managers in Python: `with` Statement\n\nPython's `with` statement is an elegant way to handle resources that need to be cleaned up — files, database connections, network sockets — even if an error occurs:\n\n```python\nwith open(\"data.txt\", \"r\") as file:\n    content = file.read()\n# file is automatically closed here, even if an exception occurred inside the block\n```\n\nWithout `with`, you would need `try/finally` to guarantee the file closes:\n\n```python\nfile = open(\"data.txt\", \"r\")\ntry:\n    content = file.read()\nfinally:\n    file.close()  # must not forget this!\n```\n\nThe `with` statement is cleaner, shorter, and less error-prone."
    },
    {
      "type": "text",
      "content": "## Promise Error Handling in JavaScript\n\nIn JavaScript, network requests and other async operations return **Promises**. Promises can either *resolve* (succeed) or *reject* (fail).\n\n**Old style — `.catch()` chaining:**\n```javascript\nfetch(\"https://api.example.com/data\")\n  .then(response => response.json())\n  .then(data => console.log(data))\n  .catch(error => console.error(\"Failed:\", error.message));\n```\n\n**Modern style — `async/await` with `try/catch`:**\n```javascript\nasync function loadData() {\n  try {\n    const response = await fetch(\"https://api.example.com/data\");\n    if (!response.ok) {\n      throw new Error(`HTTP ${response.status}`);\n    }\n    const data = await response.json();\n    return data;\n  } catch (error) {\n    console.error(\"Failed to load data:\", error.message);\n    return null;\n  }\n}\n```\n\nThe `async/await` style reads like synchronous code while remaining non-blocking — prefer it for clarity."
    },
    {
      "type": "text",
      "content": "## How to Write Helpful Error Messages\n\nA good error message tells the reader *what went wrong*, *where*, and *what they can do about it*.\n\n**Bad:** `raise Exception(\"Error\")`\n**Good:** `raise ValueError(f\"Expected age between 0 and 150, got {age}\")`\n\nBest practices:\n- Include the **actual value** that caused the problem.\n- State what was **expected**.\n- Be specific about **which parameter** or **which step** failed.\n- Never leak sensitive data (passwords, tokens) in error messages.\n- Log the full stack trace for internal debugging; show a friendly summary to end users."
    }
  ],
  "summary": "- Exceptions are runtime errors; catching them prevents your program from crashing.\n- Python uses `try/except/else/finally`; JavaScript uses `try/catch/finally`.\n- Catch *specific* exceptions — bare `except:` or catch-all `catch` hides bugs.\n- `finally` always runs — use it to close files, release locks, and clean up resources.\n- Python's `with` statement is syntactic sugar for `try/finally` resource cleanup.\n- Create custom exception classes to make errors self-documenting and easy to filter.\n- Write error messages that include the actual value, the expectation, and what to do next."
}$json$::jsonb
WHERE topic_id = (SELECT id FROM topics WHERE title = 'Error Handling')
  AND type = 'theory'
  AND language IS NULL;


-- ============================================================
-- TOPIC 10: APIs
-- ============================================================

UPDATE lessons
SET content_json = $json${
  "sections": [
    {
      "type": "text",
      "content": "# APIs\n\nAn **API** (Application Programming Interface) is a defined way for two programs to talk to each other. Think of it like a restaurant:\n\n- **You** are a program that needs data.\n- **The waiter** is the API — a structured set of rules you use to make requests.\n- **The kitchen** is the server — it holds the data and does the work.\n- **The menu** is the API documentation — it lists exactly what you can order.\n\nYou do not need to know how the kitchen prepares the food. You just use the menu (the API contract) to place your order (a request), and the waiter brings back your dish (a response).\n\nAPIs power the modern web: when your weather app shows a forecast, it called a weather API. When you log in with Google, an auth API verified your identity. When you pay online, a payment API processed the transaction."
    },
    {
      "type": "text",
      "content": "## HTTP Basics: Requests and Responses\n\nMost web APIs use **HTTP** (HyperText Transfer Protocol) — the same protocol your browser uses to load web pages.\n\nEvery HTTP interaction is a **request → response** pair:\n\n**Request** (you send):\n- **Method**: what you want to do\n- **URL**: which resource you're targeting\n- **Headers**: metadata (who you are, what format you accept)\n- **Body**: data you're sending (for POST/PUT requests)\n\n**Response** (server sends back):\n- **Status code**: did it work?\n- **Headers**: metadata about the response\n- **Body**: the actual data (usually JSON)\n\n**HTTP Methods:**\n| Method | Purpose | Example |\n|--------|---------|---------|\n| GET | Read data | Get a list of users |\n| POST | Create new data | Create a new user |\n| PUT | Replace existing data | Update an entire user record |\n| PATCH | Partially update data | Update just the email |\n| DELETE | Remove data | Delete a user |"
    },
    {
      "type": "text",
      "content": "## HTTP Status Codes\n\nThe status code tells you immediately whether your request succeeded:\n\n| Code | Name | Meaning |\n|------|------|---------|\n| 200 | OK | Success — response contains the requested data |\n| 201 | Created | A new resource was created (after POST) |\n| 204 | No Content | Success but nothing to return (after DELETE) |\n| 400 | Bad Request | Your request was malformed or missing required data |\n| 401 | Unauthorized | You need to authenticate (login) first |\n| 403 | Forbidden | You're authenticated but not allowed to do this |\n| 404 | Not Found | The resource doesn't exist |\n| 422 | Unprocessable Entity | Data was valid JSON but failed validation rules |\n| 429 | Too Many Requests | Rate limit exceeded — slow down |\n| 500 | Internal Server Error | Something went wrong on the server side |\n| 503 | Service Unavailable | Server is down or overloaded |\n\nAlways check the status code before trusting the response body."
    },
    {
      "type": "text",
      "content": "## JSON: The Standard Format for APIs\n\n**JSON** (JavaScript Object Notation) is the universal language APIs use to exchange data. It is:\n\n- **Human-readable** — you can understand it without special tools\n- **Language-agnostic** — every modern programming language can parse and generate it\n- **Lightweight** — less verbose than XML\n\nJSON supports: strings, numbers, booleans, null, arrays, and objects.\n\n```json\n{\n  \"user\": {\n    \"id\": 42,\n    \"name\": \"Alice\",\n    \"email\": \"alice@example.com\",\n    \"active\": true,\n    \"tags\": [\"admin\", \"developer\"]\n  }\n}\n```\n\nIn Python, `json.loads(text)` parses JSON into a dictionary. In JavaScript, `JSON.parse(text)` does the same."
    },
    {
      "type": "code",
      "language": "python",
      "content": "import requests  # pip install requests\n\n# GET request — fetch public GitHub user data\nurl = \"https://api.github.com/users/torvalds\"\nresponse = requests.get(url)\n\n# Always check status before using the data\nif response.status_code == 200:\n    data = response.json()  # parse JSON into a Python dict\n    print(\"Name:\", data[\"name\"])\n    print(\"Public repos:\", data[\"public_repos\"])\n    print(\"Followers:\", data[\"followers\"])\nelse:\n    print(f\"Request failed: {response.status_code}\")\n\n# Example output:\n# Name: Linus Torvalds\n# Public repos: 6\n# Followers: 217823"
    },
    {
      "type": "code",
      "language": "javascript",
      "content": "// JavaScript: fetch API (built into browsers and modern Node.js)\nasync function getGitHubUser(username) {\n  const url = `https://api.github.com/users/${username}`;\n\n  try {\n    const response = await fetch(url);\n\n    if (!response.ok) {\n      throw new Error(`HTTP error: ${response.status}`);\n    }\n\n    const data = await response.json();\n    console.log(\"Name:\", data.name);\n    console.log(\"Public repos:\", data.public_repos);\n    console.log(\"Followers:\", data.followers);\n    return data;\n  } catch (error) {\n    console.error(\"Failed to fetch user:\", error.message);\n    return null;\n  }\n}\n\ngetGitHubUser(\"torvalds\");"
    },
    {
      "type": "text",
      "content": "## Request Headers: Authorization and Content-Type\n\nHeaders are key-value pairs attached to every request. Two are especially common:\n\n**Authorization** — proves who you are. APIs use different schemes:\n- `Bearer <token>` — the most common; the token is a JWT or API key\n- `Basic base64(username:password)` — older, less common\n\n**Content-Type** — tells the server what format your request body is in:\n- `application/json` — you're sending JSON\n- `application/x-www-form-urlencoded` — HTML form data\n- `multipart/form-data` — file uploads"
    },
    {
      "type": "code",
      "language": "python",
      "content": "import requests\n\nAPI_KEY = \"your_api_key_here\"\n\n# POST request with JSON body and auth header\nurl = \"https://api.example.com/messages\"\n\nheaders = {\n    \"Authorization\": f\"Bearer {API_KEY}\",\n    \"Content-Type\": \"application/json\"\n}\n\npayload = {\n    \"to\": \"alice@example.com\",\n    \"subject\": \"Hello!\",\n    \"body\": \"This was sent via API.\"\n}\n\nresponse = requests.post(url, json=payload, headers=headers)\n# requests.post(url, json=...) automatically:\n# - serializes the dict to JSON\n# - sets Content-Type: application/json\n\nif response.status_code == 201:\n    print(\"Message created:\", response.json()[\"id\"])\nelse:\n    print(f\"Error {response.status_code}:\", response.text)"
    },
    {
      "type": "text",
      "content": "## REST vs GraphQL\n\nThe two dominant API styles you'll encounter:\n\n**REST (Representational State Transfer)**:\n- Multiple endpoints, one per resource type: `/users`, `/posts`, `/comments`\n- Use HTTP methods (GET/POST/PUT/DELETE) to signal the action\n- Simple, widely supported, easy to cache\n- Can lead to **over-fetching** (getting more data than you need) or **under-fetching** (needing multiple requests)\n\n**GraphQL**:\n- Single endpoint: `/graphql`\n- You specify *exactly* which fields you want in the query\n- Great for complex, nested data (e.g. social networks, e-commerce)\n- More complex setup, harder to cache\n- Developed by Facebook; used by GitHub, Shopify, Twitter\n\nFor most projects, REST is the right default. Use GraphQL when clients need very flexible, nested queries over rich data models."
    },
    {
      "type": "text",
      "content": "## Why API Calls Are Asynchronous\n\nNetwork requests take time — anywhere from 50ms to several seconds depending on the server, internet connection, and data size. During that time, your program should not be frozen waiting.\n\n**Asynchronous programming** lets your code *start* a request and then continue doing other things. When the response arrives, a callback runs to handle it.\n\n- In Python: use `asyncio` + `httpx` or `aiohttp` for async requests (or use synchronous `requests` for simplicity in scripts).\n- In JavaScript: everything async uses Promises + `async/await`. The browser stays interactive while waiting.\n\nFor beginners: the synchronous `requests` library in Python is fine for scripts and learning. Switch to async when building servers that handle many simultaneous requests."
    },
    {
      "type": "text",
      "content": "## Rate Limiting and Robust Error Handling\n\nPublic APIs limit how many requests you can make per second, minute, or day. Exceeding the limit returns **429 Too Many Requests**.\n\nRobust API code handles:\n1. **Rate limits**: exponential backoff — wait, retry after increasing delays\n2. **Network errors**: connection timeouts, DNS failures\n3. **Server errors** (5xx): the server failed; retry after a delay\n4. **Client errors** (4xx): you sent bad data; fix the request, do not retry blindly\n5. **Unexpected data shapes**: API responses change over time; use `.get()` with defaults"
    },
    {
      "type": "code",
      "language": "python",
      "content": "import requests\nimport time\n\ndef fetch_with_retry(url, max_retries=3):\n    \"\"\"Fetch a URL, retrying on 5xx or rate-limit errors.\"\"\"\n    for attempt in range(max_retries):\n        try:\n            response = requests.get(url, timeout=10)\n\n            if response.status_code == 200:\n                return response.json()\n            elif response.status_code == 429:  # rate limited\n                wait = 2 ** attempt  # 1s, 2s, 4s...\n                print(f\"Rate limited. Waiting {wait}s...\")\n                time.sleep(wait)\n            elif response.status_code >= 500:\n                print(f\"Server error {response.status_code}, retrying...\")\n                time.sleep(2 ** attempt)\n            else:\n                print(f\"Client error {response.status_code}: {response.text}\")\n                return None  # don't retry 4xx errors\n\n        except requests.Timeout:\n            print(f\"Timeout on attempt {attempt + 1}\")\n        except requests.ConnectionError as e:\n            print(f\"Connection failed: {e}\")\n            time.sleep(2)\n\n    print(\"All retries exhausted.\")\n    return None"
    }
  ],
  "summary": "- An API is a contract between two programs; web APIs use HTTP requests and JSON responses.\n- HTTP methods (GET/POST/PUT/DELETE) express the intent; status codes (200/201/404/500) report the outcome.\n- Always check the status code before using the response body.\n- Include an Authorization header for authenticated APIs; set Content-Type: application/json when sending JSON.\n- REST uses multiple endpoints; GraphQL uses one endpoint with flexible queries.\n- API calls are async — use async/await in JS and consider httpx/aiohttp for high-volume Python code.\n- Implement retry logic with exponential backoff for 429 and 5xx responses."
}$json$::jsonb
WHERE topic_id = (SELECT id FROM topics WHERE title = 'APIs')
  AND type = 'theory'
  AND language IS NULL;


-- ============================================================
-- TOPIC 11: Algorithms & Data Structures
-- ============================================================

UPDATE lessons
SET content_json = $json${
  "sections": [
    {
      "type": "text",
      "content": "# Algorithms & Data Structures\n\nAn **algorithm** is a step-by-step recipe for solving a problem. A **data structure** is an organized way of storing data so that it can be accessed and modified efficiently.\n\nThey go hand in hand: the right data structure makes the right algorithm fast. Putting a million names into a list and searching one by one is slow. Putting them into a hash set and looking up by key is instant.\n\nEvery program you write uses algorithms and data structures — even if you don't notice. Understanding the fundamentals helps you choose the right tool and avoid accidentally writing code that is 1000× slower than it needs to be."
    },
    {
      "type": "text",
      "content": "## Big O Notation: Measuring Performance\n\n**Big O notation** describes how an algorithm's *time* (or *space*) grows as the input size `n` grows. It ignores constants and focuses on the dominant term.\n\n| Notation | Name | Real-world analogy |\n|----------|------|--------------------|\n| O(1) | Constant | Looking up a word in a dictionary by page number |\n| O(log n) | Logarithmic | Searching a phone book by opening in the middle, then half again |\n| O(n) | Linear | Reading every name in a list once |\n| O(n log n) | Linearithmic | Sorting a deck of cards with merge sort |\n| O(n²) | Quadratic | Comparing every pair in a list (bubble sort) |\n| O(2ⁿ) | Exponential | Solving the Towers of Hanoi; breaks for large inputs |\n\nIf n = 1,000,000:\n- O(1): ~1 operation\n- O(log n): ~20 operations\n- O(n): ~1,000,000 operations\n- O(n²): ~1,000,000,000,000 operations — completely impractical"
    },
    {
      "type": "text",
      "content": "## Linear Search vs Binary Search\n\n**Linear search** checks each element one by one until it finds the target or exhausts the list. It works on any list, sorted or not. Time complexity: **O(n)**.\n\n**Binary search** exploits a *sorted* list: check the middle element; if too high, discard the right half; if too low, discard the left half. Repeat. This halves the problem each step. Time complexity: **O(log n)**.\n\nFor 1,000,000 elements:\n- Linear search: up to 1,000,000 comparisons\n- Binary search: at most 20 comparisons\n\nThe catch: binary search *requires the list to be sorted*. Sorting itself costs O(n log n), so binary search is only worth it if you search many times after sorting once."
    },
    {
      "type": "code",
      "language": "python",
      "content": "# Linear search — O(n)\ndef linear_search(lst, target):\n    for i, value in enumerate(lst):\n        if value == target:\n            return i  # return index of found element\n    return -1  # not found\n\n# Binary search — O(log n), list must be sorted!\ndef binary_search(lst, target):\n    left, right = 0, len(lst) - 1\n    while left <= right:\n        mid = (left + right) // 2\n        if lst[mid] == target:\n            return mid\n        elif lst[mid] < target:\n            left = mid + 1   # target is in the right half\n        else:\n            right = mid - 1  # target is in the left half\n    return -1  # not found\n\nnumbers = list(range(0, 1000000, 2))  # even numbers up to 999998\n\nprint(linear_search(numbers, 999998))  # ~500000 steps\nprint(binary_search(numbers, 999998))  # ~20 steps\n# Both return 499999 (the index)"
    },
    {
      "type": "text",
      "content": "## Arrays: The Foundation\n\nAn **array** (called a `list` in Python) stores elements in contiguous memory slots, indexed from 0.\n\n**Key operations:**\n- **Access by index**: O(1) — the computer calculates the memory address directly\n- **Search (unsorted)**: O(n) — must check each element\n- **Append to end**: O(1) amortized — fast most of the time (occasionally O(n) to resize)\n- **Insert in middle**: O(n) — must shift all elements after the insertion point\n- **Delete in middle**: O(n) — must shift all elements after the deletion point\n\nArrays are excellent for:\n- Storing ordered data you'll access by index\n- Iterating over all elements\n- Fast access by known position\n\nArrays are poor for:\n- Frequent insertions or deletions in the middle\n- Searching without sorting"
    },
    {
      "type": "text",
      "content": "## Stacks and Queues\n\n**Stack** — Last In, First Out (LIFO): like a stack of plates — you add and remove from the top.\n- **push**: add to top — O(1)\n- **pop**: remove from top — O(1)\n- **peek**: look at top without removing — O(1)\n\nUse cases: undo history, browser back-button, function call stack, balanced bracket checking, depth-first search.\n\n**Queue** — First In, First Out (FIFO): like a line at a coffee shop — first person in is first served.\n- **enqueue**: add to back — O(1)\n- **dequeue**: remove from front — O(1)\n\nUse cases: task queues, print queues, breadth-first search, message brokers.\n\nIn Python: a list works as a stack (`append`/`pop`). Use `collections.deque` for efficient queues."
    },
    {
      "type": "code",
      "language": "python",
      "content": "from collections import deque\n\n# Stack: LIFO (using a list)\nstack = []\nstack.append(\"task_1\")  # push\nstack.append(\"task_2\")\nstack.append(\"task_3\")\nprint(stack.pop())  # task_3 — last in, first out\nprint(stack.pop())  # task_2\n\n# Queue: FIFO (using deque for O(1) dequeue)\nqueue = deque()\nqueue.append(\"customer_1\")  # enqueue\nqueue.append(\"customer_2\")\nqueue.append(\"customer_3\")\nprint(queue.popleft())  # customer_1 — first in, first out\nprint(queue.popleft())  # customer_2\n\n# Balanced brackets using a stack\ndef is_balanced(s):\n    stack = []\n    pairs = {')': '(', '}': '{', ']': '['}\n    for char in s:\n        if char in '([{':\n            stack.append(char)\n        elif char in ')]}':\n            if not stack or stack[-1] != pairs[char]:\n                return False\n            stack.pop()\n    return len(stack) == 0\n\nprint(is_balanced(\"({[]})\"))  # True\nprint(is_balanced(\"({]}\"))    # False"
    },
    {
      "type": "text",
      "content": "## Hash Maps: O(1) Lookup\n\nA **hash map** (called `dict` in Python, `Map` or `{}` in JavaScript) stores key-value pairs and provides near-instant lookup by key.\n\n**How it works (simplified):**\n1. Run the key through a *hash function* to get a number.\n2. Use that number as an index into an internal array (called a bucket).\n3. Store the value there.\n4. To look up a key: hash it → find the bucket → return the value.\n\nBecause hashing is O(1), lookup/insert/delete are all **O(1) on average** (worst case O(n) with hash collisions, which are rare with good hash functions).\n\n**Use cases:** counting frequencies, caching (memoization), grouping/indexing data, removing duplicates."
    },
    {
      "type": "code",
      "language": "javascript",
      "content": "// Hash map operations in JavaScript\nconst wordCount = {};\nconst text = \"the cat sat on the mat the cat\";\n\n// Count word frequencies — O(n)\nfor (const word of text.split(\" \")) {\n  wordCount[word] = (wordCount[word] || 0) + 1;\n}\nconsole.log(wordCount);\n// { the: 3, cat: 2, sat: 1, on: 1, mat: 1 }\n\n// Lookup is O(1)\nconsole.log(wordCount[\"cat\"]);  // 2\nconsole.log(wordCount[\"the\"]);  // 3\n\n// Two-Sum problem: find two numbers that add to target\nfunction twoSum(nums, target) {\n  const seen = new Map();  // value → index\n  for (let i = 0; i < nums.length; i++) {\n    const complement = target - nums[i];\n    if (seen.has(complement)) {\n      return [seen.get(complement), i];\n    }\n    seen.set(nums[i], i);\n  }\n  return null;\n}\n\nconsole.log(twoSum([2, 7, 11, 15], 9));  // [0, 1]  (2 + 7 = 9)"
    },
    {
      "type": "text",
      "content": "## Trees: Hierarchical Data\n\nA **tree** is a hierarchical structure with a root node at the top, branches, and leaf nodes at the bottom. Each node has a value and zero or more children.\n\n**Binary Tree**: each node has at most 2 children (left and right).\n\n**Binary Search Tree (BST)**: a binary tree where:\n- All values in the *left* subtree are *less than* the node's value\n- All values in the *right* subtree are *greater than* the node's value\n\nThis property enables O(log n) search, insert, and delete (when the tree is balanced).\n\n**Tree traversal orders:**\n- **In-order** (left → root → right): visits BST nodes in sorted order\n- **Pre-order** (root → left → right): useful for copying a tree\n- **Post-order** (left → right → root): useful for deleting a tree"
    },
    {
      "type": "text",
      "content": "## Sorting Algorithms: Overview\n\n**Bubble Sort** — O(n²): compare adjacent pairs, swap if out of order, repeat. Simple to understand, terrible for large inputs.\n\n**Insertion Sort** — O(n²) worst, O(n) best: build the sorted list one element at a time. Excellent for nearly-sorted data.\n\n**Merge Sort** — O(n log n): divide the list in half, sort each half recursively, merge the sorted halves. Predictable performance, uses extra memory.\n\n**Quick Sort** — O(n log n) average, O(n²) worst: pick a pivot, partition around it, sort each partition. Very fast in practice; used by most standard libraries.\n\nPython's built-in `sorted()` and `.sort()` use **Timsort** — a hybrid of merge sort and insertion sort — guaranteed O(n log n).\n\nJavaScript's `Array.prototype.sort()` also uses Timsort in modern engines."
    },
    {
      "type": "text",
      "content": "## When to Use Which Data Structure\n\n| Situation | Choose |\n|-----------|--------|\n| Ordered collection, access by index | List / Array |\n| LIFO (undo, call stack) | Stack (list in Python) |\n| FIFO (task queue, BFS) | Queue (deque in Python) |\n| Fast lookup by key | Dict / HashMap |\n| Membership testing (is X in set?) | Set |\n| Sorted data, fast search | Binary Search Tree or sorted list |\n| Hierarchical data (file system, DOM) | Tree |\n| Weighted connections (road network) | Graph |\n\n**Practical tip for beginners**: start with a list. If lookups are too slow, switch to a dict. If you need uniqueness, use a set. Trees and graphs are for specialized problems."
    }
  ],
  "summary": "- Big O notation measures how an algorithm's time grows with input size; O(1) < O(log n) < O(n) < O(n log n) < O(n²).\n- Linear search is O(n); binary search is O(log n) but requires a sorted list.\n- Arrays give O(1) random access but O(n) insert/delete in the middle.\n- Stacks are LIFO; queues are FIFO — both support O(1) push/pop operations.\n- Hash maps provide O(1) average-case lookup, insert, and delete using a key.\n- Binary search trees keep data sorted for O(log n) operations when balanced.\n- Python's `sorted()` and JS's `.sort()` both use Timsort: O(n log n) guaranteed."
}$json$::jsonb
WHERE topic_id = (SELECT id FROM topics WHERE title = 'Algorithms & Data Structures')
  AND type = 'theory'
  AND language IS NULL;


-- ============================================================
-- TOPIC 12: Generators & Iterators
-- ============================================================

UPDATE lessons
SET content_json = $json${
  "sections": [
    {
      "type": "text",
      "content": "# Generators & Iterators\n\nPython and JavaScript both have powerful tools for *producing values on demand* rather than building the entire collection upfront. This is called **lazy evaluation**, and it can save enormous amounts of memory when working with large datasets.\n\nTo understand generators, we first need to understand iterators."
    },
    {
      "type": "text",
      "content": "## What is an Iterator?\n\nAn **iterator** is any object that:\n1. Implements an `__iter__()` method that returns itself.\n2. Implements a `__next__()` method that returns the next value each time it is called, and raises `StopIteration` when there are no more values.\n\nThis pair of methods is called the **iterator protocol**. Python's `for` loop calls `iter()` to get an iterator, then calls `next()` repeatedly until `StopIteration` is raised.\n\nThe key insight: an iterator computes values **one at a time**, on demand. It does not need to hold all values in memory at once.\n\n**Iterables vs Iterators:**\n- An **iterable** is anything you can loop over: lists, strings, dicts, files.\n- An **iterator** is a stateful object that produces values one at a time.\n- Calling `iter()` on an iterable gives you an iterator."
    },
    {
      "type": "code",
      "language": "python",
      "content": "# Under the hood of a for loop:\nnumbers = [10, 20, 30]\nit = iter(numbers)     # get an iterator\nprint(next(it))        # 10\nprint(next(it))        # 20\nprint(next(it))        # 30\n# next(it) would raise StopIteration now\n\n# Building a custom iterator class\nclass Countdown:\n    def __init__(self, start):\n        self.current = start\n\n    def __iter__(self):\n        return self  # the iterator is itself\n\n    def __next__(self):\n        if self.current < 0:\n            raise StopIteration\n        value = self.current\n        self.current -= 1\n        return value\n\nfor n in Countdown(3):\n    print(n)  # 3, 2, 1, 0"
    },
    {
      "type": "text",
      "content": "## Generators: The Easy Way to Make Iterators\n\nWriting a class with `__iter__` and `__next__` is verbose. **Generators** give you the same power with much less code.\n\nA **generator function** looks like a normal function, but instead of `return` it uses `yield`. Each time `yield` is executed, the function *pauses*, sends the yielded value to the caller, and saves its entire local state. The next call to `next()` resumes execution right after the `yield`.\n\nThis is fundamentally different from `return`: `return` exits the function permanently. `yield` pauses it and remembers where it left off."
    },
    {
      "type": "code",
      "language": "python",
      "content": "# Generator function — produces values lazily\ndef countdown(start):\n    while start >= 0:\n        yield start   # pause here, send 'start' to caller\n        start -= 1    # resume here on next call\n\n# The function doesn't run yet — it returns a generator object\ngen = countdown(3)\nprint(type(gen))     # <class 'generator'>\n\nprint(next(gen))     # 3 — function runs until first yield\nprint(next(gen))     # 2 — resumes from after yield\nprint(next(gen))     # 1\nprint(next(gen))     # 0\n# next(gen) would raise StopIteration\n\n# Or use in a for loop:\nfor n in countdown(5):\n    print(n, end=\" \")  # 5 4 3 2 1 0"
    },
    {
      "type": "text",
      "content": "## Generator Expressions: Compact Lazy Sequences\n\nJust as list comprehensions `[x*2 for x in range(10)]` create a list, **generator expressions** use parentheses `(x*2 for x in range(10))` and create a lazy generator instead.\n\nThe difference is dramatic for large inputs:\n\n```python\nimport sys\n\nnumbers_list = [x * 2 for x in range(1_000_000)]   # list — all in memory\nnumbers_gen  = (x * 2 for x in range(1_000_000))   # generator — lazy\n\nprint(sys.getsizeof(numbers_list))  # ~8 MB\nprint(sys.getsizeof(numbers_gen))   # ~112 bytes!\n```\n\nUse a generator expression when you only need to iterate once and don't need random access."
    },
    {
      "type": "text",
      "content": "## Why Generators? Memory Efficiency\n\nConsider reading a log file with 10 million lines. With a list:\n\n```python\nlines = open(\"big.log\").readlines()  # loads ALL 10M lines into RAM\nfor line in lines:\n    process(line)\n```\n\nWith a generator:\n\n```python\ndef read_lines(path):\n    with open(path) as f:\n        for line in f:\n            yield line  # one line in memory at a time\n\nfor line in read_lines(\"big.log\"):\n    process(line)\n```\n\nThe generator approach uses a few kilobytes of RAM regardless of file size. This pattern is essential for data pipelines, stream processing, and working with databases."
    },
    {
      "type": "code",
      "language": "python",
      "content": "# Practical example: infinite sequence + lazy pipeline\ndef natural_numbers():\n    \"\"\"Generator of 1, 2, 3, 4, 5, ... forever\"\"\"\n    n = 1\n    while True:  # infinite loop — fine because we yield each step\n        yield n\n        n += 1\n\ndef only_even(numbers):\n    \"\"\"Filter: yield only even numbers.\"\"\"\n    for n in numbers:\n        if n % 2 == 0:\n            yield n\n\ndef take(n, iterable):\n    \"\"\"Take the first n values from any iterable.\"\"\"\n    for i, value in enumerate(iterable):\n        if i >= n:\n            break\n        yield value\n\n# Compose a lazy pipeline\npipeline = take(5, only_even(natural_numbers()))\nprint(list(pipeline))  # [2, 4, 6, 8, 10]\n# At no point did we create a list of all natural numbers!"
    },
    {
      "type": "text",
      "content": "## `yield from`: Delegating to Sub-Generators\n\nPython's `yield from` lets a generator delegate part of its work to another iterable or generator. This is useful for flattening nested structures or composing generators."
    },
    {
      "type": "code",
      "language": "python",
      "content": "# yield from: delegate to another iterable\ndef flatten(nested):\n    \"\"\"Flatten one level of nesting.\"\"\"\n    for item in nested:\n        if isinstance(item, list):\n            yield from item   # delegate to the inner list\n        else:\n            yield item\n\ndata = [1, [2, 3], 4, [5, 6, 7]]\nprint(list(flatten(data)))  # [1, 2, 3, 4, 5, 6, 7]\n\n# Compare without yield from:\ndef flatten_verbose(nested):\n    for item in nested:\n        if isinstance(item, list):\n            for sub in item:  # must manually loop\n                yield sub\n        else:\n            yield item\n# Both work the same; yield from is cleaner."
    },
    {
      "type": "code",
      "language": "javascript",
      "content": "// JavaScript generators: function* and yield\nfunction* countdown(start) {\n  while (start >= 0) {\n    yield start;   // pause, send value\n    start -= 1;\n  }\n}\n\nconst gen = countdown(3);\nconsole.log(gen.next());  // { value: 3, done: false }\nconsole.log(gen.next());  // { value: 2, done: false }\nconsole.log(gen.next());  // { value: 1, done: false }\nconsole.log(gen.next());  // { value: 0, done: false }\nconsole.log(gen.next());  // { value: undefined, done: true }\n\n// Spread or for...of loop works too\nconsole.log([...countdown(5)]);  // [5, 4, 3, 2, 1, 0]\n\n// Infinite generator in JS\nfunction* naturals() {\n  let n = 1;\n  while (true) {\n    yield n++;\n  }\n}\n\nfunction take(n, gen) {\n  const result = [];\n  for (const value of gen) {\n    result.push(value);\n    if (result.length === n) break;\n  }\n  return result;\n}\n\nconsole.log(take(5, naturals()));  // [1, 2, 3, 4, 5]"
    }
  ],
  "summary": "- An iterator is an object with `__iter__` and `__next__` (Python) or `.next()` (JS) that produces values one at a time.\n- A generator function uses `yield` to pause and resume execution, automatically implementing the iterator protocol.\n- Generator expressions `(x for x in ...)` are lazy — they use constant memory regardless of size.\n- `yield from` in Python delegates to a sub-generator, simplifying composition.\n- JavaScript uses `function*` and `yield`; `.next()` returns `{ value, done }`.\n- Generators are perfect for large files, data pipelines, and infinite sequences where loading everything into memory is impractical."
}$json$::jsonb
WHERE topic_id = (SELECT id FROM topics WHERE title = 'Generators & Iterators')
  AND type = 'theory'
  AND language IS NULL;


-- ============================================================
-- TOPIC 13: Decorators
-- ============================================================

UPDATE lessons
SET content_json = $json${
  "sections": [
    {
      "type": "text",
      "content": "# Decorators\n\nA **decorator** is a function that takes another function as input, wraps it with additional behavior, and returns the enhanced function.\n\nDecorators are powerful because in Python (and JavaScript), **functions are first-class values**: you can store them in variables, pass them as arguments, and return them from other functions. Decorators exploit this to add behavior (logging, timing, access control, retrying) without modifying the original function's body.\n\nYou have already used decorators if you've seen `@staticmethod`, `@property`, or `@app.route('/')` in Flask."
    },
    {
      "type": "text",
      "content": "## First-Class Functions: The Foundation\n\nBefore understanding decorators, you need to see that Python treats functions like any other value."
    },
    {
      "type": "code",
      "language": "python",
      "content": "# Functions are values — store them, pass them, return them\ndef greet(name):\n    return f\"Hello, {name}!\"\n\n# Store in a variable\nsay_hello = greet\nprint(say_hello(\"Alice\"))  # Hello, Alice!\n\n# Pass as an argument\ndef apply(func, value):\n    return func(value)\n\nprint(apply(greet, \"Bob\"))  # Hello, Bob!\n\n# Return a function from a function\ndef make_multiplier(n):\n    def multiply(x):\n        return x * n\n    return multiply  # return the inner function\n\ndouble = make_multiplier(2)\ntriple = make_multiplier(3)\nprint(double(5))   # 10\nprint(triple(5))   # 15"
    },
    {
      "type": "text",
      "content": "## Building a Decorator Step by Step\n\nNow let's build a decorator manually, then see how `@` is just shorthand."
    },
    {
      "type": "code",
      "language": "python",
      "content": "import time\n\n# Step 1: a function we want to time\ndef slow_square(n):\n    time.sleep(0.1)  # simulate slow work\n    return n * n\n\n# Step 2: write a wrapper function manually\ndef timer(func):\n    def wrapper(*args, **kwargs):\n        start = time.time()\n        result = func(*args, **kwargs)  # call the original function\n        elapsed = time.time() - start\n        print(f\"{func.__name__} took {elapsed:.3f}s\")\n        return result\n    return wrapper\n\n# Step 3: apply the decorator manually\nslow_square = timer(slow_square)  # replace original with wrapped version\n\nprint(slow_square(5))\n# slow_square took 0.100s\n# 25\n\n# Step 4: the @syntax is IDENTICAL — just syntactic sugar\n@timer\ndef slow_cube(n):\n    time.sleep(0.1)\n    return n ** 3\n\n# @timer is exactly the same as: slow_cube = timer(slow_cube)\nprint(slow_cube(3))\n# slow_cube took 0.100s\n# 27"
    },
    {
      "type": "text",
      "content": "## `@functools.wraps`: Preserving Metadata\n\nWhen you wrap a function, the wrapper replaces it — including its name, docstring, and other metadata. This breaks introspection tools and documentation generators.\n\n`@functools.wraps(func)` copies the original function's metadata onto the wrapper. **Always include it** when writing decorators."
    },
    {
      "type": "code",
      "language": "python",
      "content": "import functools\nimport time\n\ndef timer(func):\n    @functools.wraps(func)  # copy __name__, __doc__, etc. from func\n    def wrapper(*args, **kwargs):\n        start = time.time()\n        result = func(*args, **kwargs)\n        elapsed = time.time() - start\n        print(f\"{func.__name__} took {elapsed:.3f}s\")\n        return result\n    return wrapper\n\n@timer\ndef compute(n):\n    \"\"\"Compute n squared.\"\"\"\n    return n * n\n\nprint(compute.__name__)  # 'compute'  (not 'wrapper')\nprint(compute.__doc__)   # 'Compute n squared.'\n# Without @functools.wraps, these would show 'wrapper' and None"
    },
    {
      "type": "text",
      "content": "## Real Use Cases for Decorators\n\nDecorators shine for cross-cutting concerns — behavior that many functions need:\n\n- **Logging**: automatically record when each function is called and with what arguments\n- **Timing/profiling**: measure how long each function takes\n- **Authentication**: check that the user is logged in before running a view function\n- **Retry logic**: re-run a function if it raises an exception (for flaky network calls)\n- **Caching**: remember results so the same input is never computed twice (`@functools.lru_cache`)\n- **Input validation**: check arguments before the function runs\n- **Rate limiting**: ensure a function is not called more than N times per second"
    },
    {
      "type": "code",
      "language": "python",
      "content": "import functools\nimport time\n\n# Retry decorator: re-run up to max_attempts times on failure\ndef retry(max_attempts=3, delay=1.0):\n    \"\"\"Decorator factory: accepts arguments.\"\"\"\n    def decorator(func):\n        @functools.wraps(func)\n        def wrapper(*args, **kwargs):\n            for attempt in range(1, max_attempts + 1):\n                try:\n                    return func(*args, **kwargs)\n                except Exception as e:\n                    print(f\"Attempt {attempt} failed: {e}\")\n                    if attempt < max_attempts:\n                        time.sleep(delay)\n            raise RuntimeError(f\"{func.__name__} failed after {max_attempts} attempts\")\n        return wrapper\n    return decorator\n\n# Usage: @retry() is a decorator FACTORY — it returns the actual decorator\n@retry(max_attempts=3, delay=0.5)\ndef unstable_api_call():\n    import random\n    if random.random() < 0.7:  # 70% chance of failure\n        raise ConnectionError(\"Network timeout\")\n    return \"Success!\"\n\nprint(unstable_api_call())"
    },
    {
      "type": "text",
      "content": "## Python's Built-in Decorators\n\nPython ships with several important decorators for classes:\n\n- **`@property`**: turns a method into a read-only attribute. Getter/setter pattern without explicit call syntax.\n- **`@staticmethod`**: a method that belongs to the class namespace but doesn't receive `self` or `cls`. Purely a utility function grouped with the class.\n- **`@classmethod`**: receives `cls` (the class itself) instead of `self`. Used for factory methods and alternative constructors.\n- **`@functools.lru_cache(maxsize=128)`**: memoizes a function's results — the same input will be returned from cache without recomputing.\n\n```python\nclass Temperature:\n    def __init__(self, celsius):\n        self._celsius = celsius\n\n    @property\n    def fahrenheit(self):  # access as temp.fahrenheit, not temp.fahrenheit()\n        return self._celsius * 9/5 + 32\n\n    @staticmethod\n    def absolute_zero_celsius():\n        return -273.15\n\n    @classmethod\n    def from_fahrenheit(cls, f):  # alternative constructor\n        return cls((f - 32) * 5/9)\n\nt = Temperature(100)\nprint(t.fahrenheit)  # 212.0\nprint(Temperature.absolute_zero_celsius())  # -273.15\nprint(Temperature.from_fahrenheit(32)._celsius)  # 0.0\n```"
    },
    {
      "type": "code",
      "language": "javascript",
      "content": "// JavaScript: no native @decorator syntax for functions,\n// but higher-order functions achieve the same thing.\n\n// Higher-order function wrapping (equivalent to a Python decorator)\nfunction withLogging(fn) {\n  return function(...args) {\n    console.log(`Calling ${fn.name} with`, args);\n    const result = fn(...args);\n    console.log(`${fn.name} returned`, result);\n    return result;\n  };\n}\n\nfunction add(a, b) {\n  return a + b;\n}\n\nconst loggedAdd = withLogging(add);\nloggedAdd(3, 4);\n// Calling add with [3, 4]\n// add returned 7\n\n// Memoization decorator\nfunction memoize(fn) {\n  const cache = new Map();\n  return function(...args) {\n    const key = JSON.stringify(args);\n    if (cache.has(key)) {\n      console.log(\"Cache hit!\");\n      return cache.get(key);\n    }\n    const result = fn(...args);\n    cache.set(key, result);\n    return result;\n  };\n}\n\nconst expensiveSquare = memoize((n) => {\n  console.log(`Computing ${n}²`);\n  return n * n;\n});\n\nconsole.log(expensiveSquare(5));  // Computing 5² → 25\nconsole.log(expensiveSquare(5));  // Cache hit! → 25"
    }
  ],
  "summary": "- A decorator is a function that wraps another function to add behavior without modifying the original.\n- Functions are first-class in Python and JS — they can be stored, passed, and returned like any value.\n- The `@decorator` syntax is shorthand for `func = decorator(func)`.\n- Always use `@functools.wraps(func)` to preserve the wrapped function's name and docstring.\n- Decorator factories are decorators that accept arguments: `@retry(max_attempts=3)`.\n- Python's built-in decorators include `@property`, `@staticmethod`, `@classmethod`, and `@functools.lru_cache`.\n- JavaScript achieves the same pattern with higher-order functions."
}$json$::jsonb
WHERE topic_id = (SELECT id FROM topics WHERE title = 'Decorators')
  AND type = 'theory'
  AND language IS NULL;


-- ============================================================
-- TOPIC 14: Regular Expressions
-- ============================================================

UPDATE lessons
SET content_json = $json${
  "sections": [
    {
      "type": "text",
      "content": "# Regular Expressions\n\nA **regular expression** (regex or regexp) is a pattern that describes a set of strings. You use it to *search*, *validate*, *extract*, and *replace* text.\n\nFor example, the pattern `\\d{3}-\\d{4}` matches a phone number like `555-1234`. The pattern `^[A-Z]` matches any string that starts with an uppercase letter.\n\nRegex looks intimidating at first, but it is built from a small set of building blocks that you learn once and use everywhere. Every major programming language supports regex — the syntax is nearly identical across Python, JavaScript, Java, Ruby, and more."
    },
    {
      "type": "text",
      "content": "## Basic Syntax: Literals, `.`, `^`, `$`\n\nThe simplest pattern is a **literal**: `cat` matches the string `cat` anywhere in the text.\n\nSpecial characters add power:\n\n| Symbol | Meaning | Example |\n|--------|---------|--------|\n| `.` | Any single character (except newline) | `c.t` matches `cat`, `cut`, `cot` |\n| `^` | Start of string (or line in multiline mode) | `^Hello` matches strings starting with Hello |\n| `$` | End of string (or line) | `world$` matches strings ending with world |\n| `\\` | Escape the next special character | `\\.` matches a literal dot |\n\n**Important:** In a regex, `.` means \"any character\", not a literal dot. To match an actual dot (like in a URL or IP address), you must escape it: `\\.`"
    },
    {
      "type": "text",
      "content": "## Character Classes: `[...]`, `\\d`, `\\w`, `\\s`\n\nA **character class** matches any one character from a set.\n\n| Pattern | Matches |\n|---------|---------|\n| `[aeiou]` | Any single vowel |\n| `[a-z]` | Any lowercase letter |\n| `[A-Z]` | Any uppercase letter |\n| `[0-9]` | Any digit (same as `\\d`) |\n| `[a-zA-Z0-9_]` | Any word character (same as `\\w`) |\n| `[^aeiou]` | Any character that is NOT a vowel (`^` inside `[]` means NOT) |\n\n**Shorthand classes:**\n- `\\d` — digit (0–9)\n- `\\D` — NOT a digit\n- `\\w` — word character (letter, digit, underscore)\n- `\\W` — NOT a word character\n- `\\s` — whitespace (space, tab, newline)\n- `\\S` — NOT whitespace"
    },
    {
      "type": "text",
      "content": "## Quantifiers: How Many?\n\nQuantifiers specify how many times the preceding element must occur:\n\n| Quantifier | Meaning | Example |\n|------------|---------|--------|\n| `*` | 0 or more | `ab*c` matches `ac`, `abc`, `abbc`, `abbbc`... |\n| `+` | 1 or more | `ab+c` matches `abc`, `abbc`... but NOT `ac` |\n| `?` | 0 or 1 (optional) | `colou?r` matches both `color` and `colour` |\n| `{n}` | Exactly n times | `\\d{4}` matches exactly 4 digits |\n| `{n,m}` | Between n and m times | `\\d{2,4}` matches 2, 3, or 4 digits |\n| `{n,}` | n or more times | `\\d{3,}` matches 3 or more digits |\n\n**Greedy vs non-greedy:** By default, quantifiers are *greedy* — they match as much as possible. Adding `?` makes them *non-greedy* (lazy) — they match as little as possible.\n\n```\nText:    <b>bold</b> and <i>italic</i>\nGreedy   <.*>   matches: <b>bold</b> and <i>italic</i>  (too much!)\nLazy     <.*?>  matches: <b>  (then <i>  separately — much better)\n```"
    },
    {
      "type": "code",
      "language": "python",
      "content": "import re\n\n# Python's re module: core functions\ntext = \"My phone is 555-1234 and work is 800-9876.\"\n\n# re.search() — find first match anywhere in the string\nmatch = re.search(r\"\\d{3}-\\d{4}\", text)\nif match:\n    print(\"Found:\", match.group())   # 555-1234\n    print(\"At position:\", match.start(), \"-\", match.end())  # 15 - 23\n\n# re.findall() — find ALL non-overlapping matches, return list\nphones = re.findall(r\"\\d{3}-\\d{4}\", text)\nprint(phones)  # ['555-1234', '800-9876']\n\n# re.match() — only matches at the START of the string\nif re.match(r\"My\", text):\n    print(\"Starts with 'My'\")  # Starts with 'My'\n\n# re.sub() — replace matches with a string\nredacted = re.sub(r\"\\d{3}-\\d{4}\", \"XXX-XXXX\", text)\nprint(redacted)  # My phone is XXX-XXXX and work is XXX-XXXX."
    },
    {
      "type": "text",
      "content": "## Groups and Capturing\n\nParentheses `()` create a **capturing group** — they match the pattern inside and let you extract that specific part of the match.\n\nThis is how you extract structured data: match a complex pattern and pull out just the pieces you care about."
    },
    {
      "type": "code",
      "language": "python",
      "content": "import re\n\n# Numbered groups: group(1), group(2), ...\ndate_text = \"Today is 2024-03-15.\"\nmatch = re.search(r\"(\\d{4})-(\\d{2})-(\\d{2})\", date_text)\nif match:\n    print(\"Full match:\", match.group(0))   # 2024-03-15\n    print(\"Year:\",       match.group(1))   # 2024\n    print(\"Month:\",      match.group(2))   # 03\n    print(\"Day:\",        match.group(3))   # 15\n\n# Named groups: (?P<name>...)\nmatch = re.search(r\"(?P<year>\\d{4})-(?P<month>\\d{2})-(?P<day>\\d{2})\", date_text)\nif match:\n    print(match.group(\"year\"))   # 2024  — much more readable!\n    print(match.group(\"month\"))  # 03\n    print(match.group(\"day\"))    # 15\n\n# findall with groups returns a list of tuples\nlog = \"Error 404 at /page1, Error 500 at /page2\"\nerrors = re.findall(r\"Error (\\d+) at (\\S+)\", log)\nprint(errors)  # [('404', '/page1,'), ('500', '/page2')]"
    },
    {
      "type": "code",
      "language": "javascript",
      "content": "// JavaScript regex: /pattern/flags literal syntax\nconst text = \"My phone is 555-1234 and work is 800-9876.\";\n\n// .test() — returns true/false\nconst phoneRegex = /\\d{3}-\\d{4}/;\nconsole.log(phoneRegex.test(text));  // true\n\n// .match() — returns first match (without g flag)\nconst first = text.match(/\\d{3}-\\d{4}/);\nconsole.log(first[0]);  // 555-1234\n\n// With g (global) flag — returns all matches\nconst all = text.match(/\\d{3}-\\d{4}/g);\nconsole.log(all);  // ['555-1234', '800-9876']\n\n// .replace() — replace first match\nconsole.log(text.replace(/\\d{3}-\\d{4}/, \"XXX-XXXX\"));\n// My phone is XXX-XXXX and work is 800-9876.\n\n// With g flag — replace all\nconsole.log(text.replace(/\\d{3}-\\d{4}/g, \"XXX-XXXX\"));\n// My phone is XXX-XXXX and work is XXX-XXXX.\n\n// Named groups in JavaScript (ES2018+)\nconst dateText = \"Today is 2024-03-15.\";\nconst match = dateText.match(/(?<year>\\d{4})-(?<month>\\d{2})-(?<day>\\d{2})/);\nif (match) {\n  console.log(match.groups.year);   // 2024\n  console.log(match.groups.month);  // 03\n  console.log(match.groups.day);    // 15\n}"
    },
    {
      "type": "text",
      "content": "## Common Patterns: Email, Phone, URL\n\nHere are practical patterns you will use frequently:\n\n```python\nimport re\n\n# Email validation (simplified — full RFC 5322 is very complex)\nemail_pattern = r\"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$\"\n\ndef is_valid_email(email):\n    return bool(re.match(email_pattern, email))\n\nprint(is_valid_email(\"alice@example.com\"))   # True\nprint(is_valid_email(\"not-an-email\"))         # False\nprint(is_valid_email(\"missing@domain\"))       # False\n\n# Extract all URLs from text\nurl_pattern = r\"https?://[\\w./-]+\"\nurls = re.findall(url_pattern, \"Visit https://example.com or http://test.org/path\")\nprint(urls)  # ['https://example.com', 'http://test.org/path']\n\n# Strip HTML tags\nhtml = \"<h1>Hello</h1> <p>World</p>\"\nclean = re.sub(r\"<[^>]+>\", \"\", html)\nprint(clean)  # Hello  World\n```"
    },
    {
      "type": "text",
      "content": "## Flags (Modifiers)\n\nBoth Python and JavaScript support flags that modify how the pattern matches:\n\n| Python flag | JS flag | Effect |\n|-------------|---------|--------|\n| `re.IGNORECASE` or `re.I` | `i` | Case-insensitive matching |\n| `re.MULTILINE` or `re.M` | `m` | `^` and `$` match each line, not just the whole string |\n| `re.DOTALL` or `re.S` | `s` | `.` matches newlines too |\n| `re.VERBOSE` or `re.X` | — | Allow whitespace and comments in the pattern |\n\nPython's `re.VERBOSE` is especially useful for complex patterns:\n\n```python\ndate_pattern = re.compile(r\"\"\"\n    (\\d{4})  # year\n    -\n    (\\d{2})  # month\n    -\n    (\\d{2})  # day\n\"\"\", re.VERBOSE)\n```"
    },
    {
      "type": "text",
      "content": "## When NOT to Use Regex\n\nRegex is powerful but not the right tool for everything:\n\n- **Parsing HTML or XML**: regex cannot handle nested tags reliably. Use `BeautifulSoup` (Python) or the DOM API (JS) instead.\n- **Parsing JSON**: just use `json.loads()` or `JSON.parse()` — regex will break on edge cases.\n- **Complex grammars** (programming languages, math expressions): use a proper parser library (e.g. `pyparsing`, `PLY`, or `antlr4`).\n- **Email validation as a security gate**: the full RFC 5322 email spec is notoriously complex. For real validation, send a confirmation email instead.\n- **Performance-critical code with huge strings**: regex can have exponential worst-case backtracking. Benchmarking and catastrophic backtracking are real concerns in production.\n\nA famous saying: *\"Some people, when confronted with a problem, think 'I know, I'll use regular expressions.' Now they have two problems.\"* — Jamie Zawinski\n\nUse regex for what it excels at: simple pattern extraction, search-and-replace, and input validation of well-defined formats."
    }
  ],
  "summary": "- Regex is a pattern language for matching, extracting, and replacing text — the syntax is nearly identical in Python and JavaScript.\n- `.` matches any character; `^` anchors to start; `$` anchors to end; `\\` escapes special characters.\n- Character classes `[a-z]`, `\\d`, `\\w`, `\\s` match sets of characters; capitalize for negation (`\\D`, `\\W`, `\\S`).\n- Quantifiers `*`, `+`, `?`, `{n,m}` control repetition; add `?` to make them non-greedy.\n- Groups `()` capture parts of a match; named groups `(?P<name>...)` (Python) / `(?<name>...)` (JS) make extraction readable.\n- Python uses the `re` module (`re.search`, `re.findall`, `re.sub`); JS uses regex literals `/pattern/flags` with `.test()`, `.match()`, `.replace()`.\n- Do NOT use regex to parse HTML, JSON, or complex grammars — use dedicated parsers instead."
}$json$::jsonb
WHERE topic_id = (SELECT id FROM topics WHERE title = 'Regular Expressions')
  AND type = 'theory'
  AND language IS NULL;
