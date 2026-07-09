-- Capstone projects: one final project per language, unlocked once every topic
-- with lessons in that language is completed. Referenced by backend/routes/capstone.py
-- but never had a migration — table did not exist, GET /capstone/{language} 404/500'd.

CREATE TABLE IF NOT EXISTS capstone_projects (
    id            SERIAL PRIMARY KEY,
    language      TEXT NOT NULL UNIQUE,
    title         TEXT NOT NULL,
    description   TEXT NOT NULL,
    starter_code  TEXT NOT NULL
);

INSERT INTO capstone_projects (language, title, description, starter_code) VALUES
(
    'python',
    'CLI Expense Tracker',
    '## Goal

Build a command-line expense tracker that stores expenses in a JSON file and can report spending by category.

## Requirements

- Add an expense with an amount, a category, and a description.
- List all expenses, most recent first.
- Delete an expense by its index/id.
- Show a summary of total spending per category.
- Persist expenses to `expenses.json` so they survive between runs.
- Handle invalid input gracefully (e.g. a non-numeric amount) instead of crashing.

## Concepts you''ll use

Variables & data types, loops, functions, dictionaries/lists, file I/O, error handling (`try/except`), and basic string formatting.

## Stretch goals

- Filter expenses by date range or category.
- Export the summary as a formatted report.
- Add a monthly budget and warn when it''s exceeded.',
    'expenses = []


def add_expense(amount, category, description):
    # TODO: append a new expense dict to `expenses`
    pass


def list_expenses():
    # TODO: print all expenses, most recent first
    pass


def summary_by_category():
    # TODO: print total spending per category
    pass


def main():
    # TODO: build a simple menu loop (add / list / delete / summary / quit)
    pass


if __name__ == "__main__":
    main()
'
),
(
    'javascript',
    'Task Manager CLI',
    '## Goal

Build a command-line task manager (Node.js) that lets you add, complete, and remove tasks, with due dates and priorities.

## Requirements

- Add a task with a title, priority (`low`/`medium`/`high`), and optional due date.
- Mark a task as complete.
- Remove a task.
- List tasks, sorted by priority then due date.
- Persist tasks to `tasks.json` between runs.
- Handle errors gracefully (e.g. completing a task that doesn''t exist).

## Concepts you''ll use

Arrays & array methods (`map`/`filter`/`sort`), objects, functions, closures, `try/catch`, and reading/writing JSON files with Node''s `fs` module.

## Stretch goals

- Support async file I/O (`fs.promises`) instead of sync.
- Add recurring tasks.
- Color-code priorities in the terminal output.',
    'const tasks = [];

function addTask(title, priority = "medium", dueDate = null) {
  // TODO: push a new task object onto `tasks`
}

function completeTask(id) {
  // TODO: mark the task with this id as complete
}

function removeTask(id) {
  // TODO: remove the task with this id
}

function listTasks() {
  // TODO: print tasks sorted by priority then due date
}

function main() {
  // TODO: wire up a simple CLI loop
}

main();
'
),
(
    'typescript',
    'Type-Safe Inventory Manager',
    '## Goal

Build a small inventory management tool with strict TypeScript types — track items, quantities, and get low-stock alerts.

## Requirements

- Define an `InventoryItem` interface (id, name, quantity, lowStockThreshold).
- Add, update, and remove items — all functions must be fully typed, no `any`.
- List items below their low-stock threshold.
- Persist inventory to `inventory.json` between runs.
- Validate input (e.g. reject negative quantities) and surface clear errors.

## Concepts you''ll use

Interfaces & type aliases, generics (for a small typed storage helper), union types, array methods, and error handling — all the TypeScript-specific additions on top of the JavaScript fundamentals.

## Stretch goals

- Add categories with a union type (`"electronics" | "food" | "office"`).
- Generate a typed low-stock report you could export as JSON.
- Add a generic `Repository<T>` class you could reuse for other entities.',
    'interface InventoryItem {
  id: number;
  name: string;
  quantity: number;
  lowStockThreshold: number;
}

const inventory: InventoryItem[] = [];

function addItem(name: string, quantity: number, lowStockThreshold: number): void {
  // TODO: push a new InventoryItem onto `inventory`
}

function updateQuantity(id: number, quantity: number): void {
  // TODO: update the quantity for the item with this id
}

function lowStockItems(): InventoryItem[] {
  // TODO: return items where quantity < lowStockThreshold
  return [];
}

function main(): void {
  // TODO: wire up a simple CLI loop
}

main();
'
)
ON CONFLICT (language) DO NOTHING;
