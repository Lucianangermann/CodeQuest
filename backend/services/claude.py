import anthropic
import json
import os
import re
from typing import Optional

_client: Optional[anthropic.AsyncAnthropic] = None
MODEL = "claude-haiku-4-5-20251001"
_NO_AI = "AI tutor is not configured. Set ANTHROPIC_API_KEY to enable hints and explanations."


def _get_claude() -> Optional[anthropic.AsyncAnthropic]:
    global _client
    if _client is None:
        key = os.getenv("ANTHROPIC_API_KEY")
        if not key:
            return None
        _client = anthropic.AsyncAnthropic(api_key=key)
    return _client


def _parse_json(text: str) -> dict:
    text = text.strip()
    if text.startswith("```"):
        lines = text.split("\n")
        end = -1 if lines[-1].strip() == "```" else len(lines)
        text = "\n".join(lines[1:end])
    return json.loads(text)


# ── AI Tutor ──────────────────────────────────────────────────────────────────

async def translate_lesson_content_to_german(content: dict, lesson_type: str) -> dict:
    """Translate theory or quiz lesson content to German, preserving JSON structure."""
    client = _get_claude()
    if not client:
        return {}
    content_str = json.dumps(content, ensure_ascii=False)
    if lesson_type == "theory":
        prompt = (
            "Translate the following JSON lesson content to German. Rules:\n"
            "- Translate ALL natural language text: 'summary', section 'heading' fields, and text in 'content' fields\n"
            "- For sections with '\"type\": \"code\"': leave the 'content' value COMPLETELY UNCHANGED\n"
            "- For sections with '\"type\": \"text\"' or with a 'heading' key: translate the text BUT leave code examples inside ``` fences unchanged\n"
            "- Leave technical terms, variable/function names, Python/JS keywords in English\n"
            "- Preserve the exact JSON structure, all keys, and all non-text values\n"
            "- Return ONLY valid JSON, no explanations\n\n"
            + content_str
        )
    elif lesson_type == "quiz":
        prompt = (
            "Translate the following JSON quiz content to German. Rules:\n"
            "- Translate: 'question', each item in 'options', and 'explanation'\n"
            "- Keep the 'correct' field value UNCHANGED (same integer)\n"
            "- Leave code snippets and technical terms in English\n"
            "- Preserve the exact JSON structure and all keys\n"
            "- Return ONLY valid JSON, no explanations\n\n"
            + content_str
        )
    else:
        return {}
    msg = await client.messages.create(
        model=MODEL, max_tokens=4096,
        messages=[{"role": "user", "content": prompt}],
    )
    try:
        return _parse_json(msg.content[0].text)
    except (json.JSONDecodeError, KeyError, IndexError):
        return {}


async def translate_hints_to_german(hints: list[str]) -> list[str]:
    """Translate an array of hint strings to German in a single API call."""
    client = _get_claude()
    if not client or not hints:
        return hints
    numbered = "\n".join(f"{i+1}. {h}" for i, h in enumerate(hints))
    prompt = (
        "Translate the following numbered hints to German. Rules:\n"
        "- Keep code snippets, variable names, and technical terms in English\n"
        "- Translate only the surrounding explanation text\n"
        "- Return ONLY the numbered list in the same format, nothing else\n\n"
        + numbered
    )
    msg = await client.messages.create(
        model=MODEL, max_tokens=400,
        messages=[{"role": "user", "content": prompt}],
    )
    lines = msg.content[0].text.strip().splitlines()
    result = []
    for line in lines:
        line = line.strip()
        if line and line[0].isdigit() and ". " in line:
            result.append(line.split(". ", 1)[1])
        elif line:
            result.append(line)
    return result if len(result) == len(hints) else hints


async def translate_code_comments(code: str, programming_language: str) -> str:
    """Translate only the inline comments in a code snippet to German, leaving all code unchanged."""
    client = _get_claude()
    if not client:
        return code
    comment_char = "#" if programming_language == "python" else "//"
    prompt = (
        f"Translate ONLY the existing inline comments (text after `{comment_char}`) in this {programming_language} code to German.\n"
        "Rules:\n"
        f"- ONLY translate text that already appears after an existing `{comment_char}` marker\n"
        "- Do NOT add any new comments\n"
        "- Leave every line of code COMPLETELY UNCHANGED — variables, strings, keywords, logic, structure\n"
        "- Keep the comment delimiter and any surrounding whitespace unchanged\n"
        "- Technical terms without a natural German equivalent can stay in English\n"
        "- Return ONLY the translated code — no explanation, no markdown fences\n\n"
        f"{code}"
    )
    msg = await client.messages.create(
        model=MODEL, max_tokens=600,
        messages=[{"role": "user", "content": prompt}],
    )
    result = msg.content[0].text.strip()
    if result.startswith("```"):
        result = re.sub(r'^```[a-z]*\n?', '', result)
        result = re.sub(r'\n?```$', '', result)
    return result.strip()


async def translate_to_german(text: str) -> str:
    client = _get_claude()
    if not client:
        return ""
    msg = await client.messages.create(
        model=MODEL, max_tokens=400,
        messages=[{"role": "user", "content":
            f"Translate this coding task description to German. Keep code snippets, variable names, and technical terms in English. "
            f"Return only the translated text, no explanations:\n\n{text}"}],
    )
    return msg.content[0].text


async def generate_task_intro(instructions: str, starter_code: str, language: str, ui_lang: str = "en") -> str:
    client = _get_claude()
    if not client:
        return ""

    if ui_lang == "de":
        prompt = (
            f"Aufgabe für den Schüler:\n{instructions}\n\n"
            f"Startcode:\n```{language}\n{starter_code}\n```\n\n"
            "Schreibe den Inhalt einer Konzept-Erinnerungskarte für diese Aufgabe. Direkt mit dem Inhalt beginnen — KEIN Titel, KEINE Überschrift, KEIN '💡'. Struktur:\n"
            "1. **Ein Satz**: Welches Konzept/Muster wird in dieser Aufgabe benötigt und warum.\n"
            "2. **Mini-Beispiel** (3-5 Zeilen Code): Das Muster in seiner einfachsten Form — NICHT die Lösung der Aufgabe.\n"
            "3. **Ein Satz**: Was konkret der Schüler in dieser spezifischen Aufgabe tun soll.\n\n"
            "Direkt und prägnant auf Deutsch. Code-Variablennamen auf Englisch lassen."
        )
    else:
        prompt = (
            f"Student task:\n{instructions}\n\n"
            f"Starter code:\n```{language}\n{starter_code}\n```\n\n"
            "Write the content of a concept reminder card for this task. Start directly with the content — NO title, NO heading, NO '💡'. Structure:\n"
            "1. **One sentence**: Which concept/pattern is needed for this task and why.\n"
            "2. **Mini example** (3-5 lines of code): The pattern in its simplest form — NOT the task solution.\n"
            "3. **One sentence**: What specifically the student should do in this task.\n\n"
            "Direct and punchy in English."
        )

    msg = await client.messages.create(
        model=MODEL, max_tokens=300,
        messages=[{"role": "user", "content": prompt}],
    )
    return msg.content[0].text


async def get_hint(lesson_content: dict, hint_level: int, user_code: str) -> str:
    hints = lesson_content.get("hints", [])
    if 0 < hint_level <= len(hints):
        return hints[hint_level - 1]

    client = _get_claude()
    if not client:
        return _NO_AI

    level_desc = {
        1: "very vague (just point in the right direction)",
        2: "moderately helpful",
        3: "very specific (nearly the solution)",
    }
    instructions = lesson_content.get("instructions", "complete the coding task")
    msg = await client.messages.create(
        model=MODEL, max_tokens=200,
        messages=[{"role": "user", "content":
            f"Task: {instructions}\n\nStudent code:\n{user_code}\n\n"
            f"Give a {level_desc.get(hint_level, 'helpful')} hint in 1-2 sentences. Don't give the solution."}],
    )
    return msg.content[0].text


async def explain_mistake(lesson_content: dict, user_code: str, error: str) -> str:
    client = _get_claude()
    if not client:
        return _NO_AI

    instructions = lesson_content.get("instructions", "complete the coding task")
    msg = await client.messages.create(
        model=MODEL, max_tokens=350,
        messages=[{"role": "user", "content":
            f"Aufgabe: {instructions}\n\nCode:\n{user_code}\n\nFehler/Ausgabe: {error}\n\n"
            "Erkläre in 3-4 ermutigenden Sätzen auf Deutsch, was hier schiefgelaufen ist. "
            "Sei wie ein freundlicher Lehrer für Anfänger. Gib einen Hinweis zur Lösung, "
            "aber verate sie nicht direkt. Nutze einfache Sprache ohne Fachbegriffe."}],
    )
    return msg.content[0].text


async def chat_response(messages: list, current_topic: str, language: str) -> str:
    client = _get_claude()
    if not client:
        return "AI tutor requires ANTHROPIC_API_KEY. You can still complete all lessons without it!"

    msg = await client.messages.create(
        model=MODEL, max_tokens=500,
        system=(
            f"You are a friendly coding tutor for CodeQuest. The student is learning "
            f"'{current_topic or 'programming'}' in {language or 'Python'}. "
            "Keep answers concise (under 150 words). Be supportive and positive."
        ),
        messages=[{"role": m["role"], "content": m["content"]} for m in messages],
    )
    return msg.content[0].text


# ── Training Plan ─────────────────────────────────────────────────────────────

def _stub_training_plan(goal: str, level: str, language: str, company_target: str = "", framework_focus: str = "") -> dict:
    lang = language.capitalize()
    is_python = language == "python"
    is_ts = language == "typescript"
    is_frontend = "frontend" in (framework_focus or "").lower()
    is_backend = "backend" in (framework_focus or "").lower()
    is_large = "large" in (company_target or "").lower()
    is_beginner = level in ("absolute_beginner", "Absolute Beginner")
    is_intermediate = level in ("intermediate", "Intermediate")

    fundamentals_weeks = 8 if is_beginner else (3 if is_intermediate else 5)

    if is_python:
        p1_topics = [
            {"name": "Python Basics", "subtopics": ["Variables & Types", "Type conversion", "String formatting", "None vs False"], "depth": "master", "why_important": "Python's dynamic typing trips up beginners. Know exactly what happens at each step.", "interview_relevance": "high"},
            {"name": "Functions & Scope", "subtopics": ["def & return", "Default args", "args/kwargs", "Lambda", "Scope (LEGB)"], "depth": "master", "why_important": "Functions are the building block of all code. Interviewers test this constantly.", "interview_relevance": "high"},
            {"name": "Data Structures", "subtopics": ["Lists & slicing", "Dicts", "Sets", "Tuples", "List comprehensions"], "depth": "apply", "why_important": "Python dict & set operations are O(1) — knowing this impresses interviewers.", "interview_relevance": "high"},
            {"name": "OOP in Python", "subtopics": ["Classes & __init__", "self", "Inheritance", "Dunder methods"], "depth": "apply", "why_important": "Every serious Python codebase uses classes. Understand them thoroughly.", "interview_relevance": "high"},
            {"name": "Error Handling & Modules", "subtopics": ["try/except/finally", "Custom exceptions", "import", "Virtual environments"], "depth": "apply", "why_important": "Professional code handles errors gracefully. This separates juniors from seniors.", "interview_relevance": "medium"},
        ]
        p1_schedule = [
            {"day": "Monday", "duration_minutes": 90, "activities": [
                {"type": "theory", "title": "Python Variables & Types", "description": "Read docs, predict output before running each snippet", "resource": "docs.python.org", "priority": "must"},
                {"type": "coding", "title": "Type conversion exercises", "description": "Write 10 examples: int('5'), str(3.14), bool(0) etc. Predict first.", "resource": "Python REPL", "priority": "must"},
            ]},
            {"day": "Wednesday", "duration_minutes": 90, "activities": [
                {"type": "coding", "title": "Build 5 functions from scratch", "description": "factorial, is_palindrome, flatten_list, word_count, safe_divide", "resource": "Your editor", "priority": "must"},
                {"type": "coding", "title": "LeetCode Easy: Two Sum + Valid Anagram", "description": "No hints. Time yourself.", "resource": "LeetCode", "priority": "must"},
            ]},
            {"day": "Friday", "duration_minutes": 60, "activities": [
                {"type": "interview_prep", "title": "Explain Python aloud", "description": "Record yourself explaining closures, list vs tuple, mutable vs immutable", "resource": "Your phone", "priority": "must"},
                {"type": "review", "title": "Spaced repetition review", "description": "Review all notes from the week", "resource": "Handwritten notes", "priority": "must"},
            ]},
        ]
        p1_project = {"title": "CLI Tool in Python", "description": "Build a command-line tool in Python: a budget tracker or task manager. Use classes, file I/O, error handling, and argparse. Zero AI.", "skills_practiced": ["Classes", "File I/O", "Error handling", "CLI interfaces"]}
        p1_complete = ["You can explain mutable vs immutable without hesitation", "You can write a class with __init__ and methods from memory", "You can implement map/filter using list comprehensions", "Your CLI tool works correctly"]
        doc_resource = "docs.python.org"
    else:
        p1_topics = [
            {"name": f"{lang} Basics", "subtopics": ["Variables & Types", "Type coercion", "Scope", "Hoisting"], "depth": "master", "why_important": "Every interview starts here. You need to explain WHY, not just HOW.", "interview_relevance": "high"},
            {"name": "Functions & Closures", "subtopics": ["Declaration vs Expression", "Arrow Functions", "Closures", "this keyword"], "depth": "master", "why_important": "Closures are a staple interview question that most juniors get wrong.", "interview_relevance": "high"},
            {"name": "Array Methods", "subtopics": ["map", "filter", "reduce", "find", "some", "every"], "depth": "apply", "why_important": "You will use these every single day. Interviews often ask you to implement them.", "interview_relevance": "high"},
            {"name": "Async Programming", "subtopics": ["Promises", "async/await", "Error handling", "Promise.all"], "depth": "apply", "why_important": "Every real app has async code. Understanding it is non-negotiable.", "interview_relevance": "high"},
            {"name": ("TypeScript Types" if is_ts else "ES6+ Features"), "subtopics": (["Interfaces", "Union types", "Generics", "Type narrowing", "Utility types"] if is_ts else ["Destructuring", "Spread/Rest", "Template literals", "Modules"]), "depth": "apply", "why_important": ("TypeScript is mandatory at most companies. No 'any' types allowed." if is_ts else "Modern codebases use these constantly."), "interview_relevance": "medium"},
        ]
        p1_schedule = [
            {"day": "Monday", "duration_minutes": 90, "activities": [
                {"type": "theory", "title": f"Study {lang} Variables & Types", "description": "Read docs, take notes by hand", "resource": "MDN Web Docs", "priority": "must"},
                {"type": "coding", "title": "Type coercion exercises", "description": "Write 10 examples predicting output before running", "resource": "Browser console", "priority": "must"},
            ]},
            {"day": "Wednesday", "duration_minutes": 90, "activities": [
                {"type": "coding", "title": "Implement map, filter, reduce from scratch", "description": "Write your own versions without using built-ins.", "resource": "Your editor", "priority": "must"},
                {"type": "coding", "title": "LeetCode Easy: Two Sum + Valid Anagram", "description": "No hints. Time yourself.", "resource": "LeetCode", "priority": "must"},
            ]},
            {"day": "Friday", "duration_minutes": 60, "activities": [
                {"type": "interview_prep", "title": "Explain concepts aloud", "description": "Record yourself explaining closures and async. Listen back.", "resource": "Your phone", "priority": "must"},
                {"type": "review", "title": "Spaced repetition review", "description": "Review all notes from the week", "resource": "Handwritten notes", "priority": "must"},
            ]},
        ]
        p1_project = {"title": "Task Manager CLI", "description": f"Build a command-line task manager in {lang} using closures for state, array methods for filtering/sorting, async file I/O, and proper error handling. Zero AI.", "skills_practiced": ["Closures", "Array methods", "Async/await", "Error handling"]}
        p1_complete = ["You can explain closures with an example — without looking it up", "You can write a Promise from scratch", f"You can implement map() and reduce() by hand in {lang}", "Your milestone project works without AI assistance"]
        doc_resource = "MDN Web Docs"

    if is_backend:
        p2_title = "Phase 2 — Backend & APIs"
        p2_goal = "Build production-quality REST APIs and understand the full request lifecycle"
        p2_topics = [
            {"name": ("Flask/FastAPI" if is_python else "Node.js & Express"), "subtopics": ["Routing", "Middleware", "Request/Response", "CORS", "Error handling"], "depth": "master", "why_important": "Your primary framework. Know it inside out.", "interview_relevance": "high"},
            {"name": "SQL & Databases", "subtopics": ["SELECT, WHERE, JOIN, GROUP BY", "Indexes", "N+1 problem", "Schema design", "Migrations"], "depth": "apply", "why_important": "SQL is everywhere. Even 'frontend' roles need basic SQL for debugging.", "interview_relevance": "high"},
            {"name": "Authentication", "subtopics": ["JWT structure", "Access vs Refresh tokens", "Password hashing", "HTTPS"], "depth": "apply", "why_important": "Auth is in every app and commonly misimplemented.", "interview_relevance": "high"},
            {"name": "API Design", "subtopics": ["REST conventions", "Status codes", "Pagination", "Versioning", "Documentation"], "depth": "apply", "why_important": "Good API design is a professional skill that gets noticed.", "interview_relevance": "medium"},
        ]
        p2_schedule = [
            {"day": "Monday", "duration_minutes": 90, "activities": [
                {"type": "coding", "title": "Build a REST API from scratch", "description": "GET/POST/PUT/DELETE /users with proper status codes and error handling", "resource": ("FastAPI docs" if is_python else "Express docs"), "priority": "must"},
            ]},
            {"day": "Wednesday", "duration_minutes": 90, "activities": [
                {"type": "coding", "title": "Add JWT authentication", "description": "Signup, login, and protected routes — from scratch", "resource": "Your editor", "priority": "must"},
                {"type": "coding", "title": "SQL JOINs and aggregates", "description": "Write queries with JOIN, GROUP BY, HAVING, subqueries", "resource": "SQLZoo", "priority": "must"},
            ]},
            {"day": "Friday", "duration_minutes": 60, "activities": [
                {"type": "interview_prep", "title": "HTTP deep-dive", "description": "401 vs 403? N+1 problem? CORS? Write answers without looking.", "resource": "Paper", "priority": "must"},
            ]},
        ]
        p2_project = {"title": "Full REST API Deployed", "description": "Build and deploy a REST API: JWT auth, CRUD with real database, SQL JOINs, input validation, error handling. Public URL required.", "skills_practiced": ["REST design", "JWT auth", "SQL", "Deployment"]}
        p2_complete = ["You can build a REST API with auth from memory", "You can write a SQL JOIN from memory", "You can explain CORS in plain English", "Your API is deployed and publicly accessible"]
    else:
        p2_title = "Phase 2 — React & Frontend"
        p2_goal = "Build production-quality React components and understand performance implications"
        p2_topics = [
            {"name": "React Fundamentals", "subtopics": ["JSX", "Components", "Props", "State", "Controlled components"], "depth": "master", "why_important": "Foundation of everything. You need to understand the virtual DOM.", "interview_relevance": "high"},
            {"name": "React Hooks", "subtopics": ["useState", "useEffect", "useContext", "useRef", "useMemo", "useCallback", "Custom hooks"], "depth": "master", "why_important": "Hooks ARE React. Interviewers WILL ask when to use useMemo vs useCallback.", "interview_relevance": "high"},
            {"name": "Performance", "subtopics": ["When React re-renders", "memo", "useMemo", "useCallback", "Lazy loading"], "depth": "apply", "why_important": "Senior devs care deeply about this. Mentioning it impresses interviewers.", "interview_relevance": "high"},
            {"name": ("TypeScript with React" if not is_python else "State Management"), "subtopics": (["Interfaces", "Typed props", "Generic components", "Event types", "useState<T>"] if not is_python else ["Local vs global state", "Context API", "When to lift state", "Zustand basics"]), "depth": "apply", "why_important": ("90% of professional React is TypeScript. Non-negotiable for most companies." if not is_python else "State management is where React apps get complex."), "interview_relevance": "high"},
        ]
        p2_schedule = [
            {"day": "Monday", "duration_minutes": 90, "activities": [
                {"type": "theory", "title": "React mental model", "description": "Understand the virtual DOM diffing algorithm conceptually", "resource": "react.dev", "priority": "must"},
                {"type": "coding", "title": "Build 3 components from memory", "description": "No copy-paste: Button, Card, Modal from scratch", "resource": "Your editor", "priority": "must"},
            ]},
            {"day": "Wednesday", "duration_minutes": 90, "activities": [
                {"type": "coding", "title": "Re-render bug exercise", "description": "Build a list with 1000 items with a re-render bug. Fix with useMemo/useCallback.", "resource": "React DevTools", "priority": "must"},
                {"type": "coding", "title": "Build a custom hook from scratch", "description": "useDebounce, useFetch, or useLocalStorage", "resource": "Your editor", "priority": "must"},
            ]},
            {"day": "Friday", "duration_minutes": 60, "activities": [
                {"type": "interview_prep", "title": "Architecture review", "description": "Draw your project's component tree on paper. Can you explain every re-render?", "resource": "Paper", "priority": "must"},
            ]},
        ]
        p2_project = {"title": "Full-Stack CRUD App", "description": "Build and deploy: signup/login (JWT), CRUD with a real database, responsive design, TypeScript throughout, no 'any' types, public URL.", "skills_practiced": ["React hooks", "TypeScript", "API integration", "State management", "Deployment"]}
        p2_complete = ["You can explain the difference between useMemo and useCallback without hesitation", "You can build a custom hook from scratch in an interview setting", "Your project has zero TypeScript 'any' types", "You can find and fix a re-render performance issue in 10 minutes"]

    cs_topics_count = 4 if is_large else 3
    cs_weeks = 6 if is_large else 3
    cs_topics = [
        {"name": "Big-O Notation", "subtopics": ["O(1) vs O(n) vs O(n²)", "Space complexity", "Recognizing complexity in code"], "depth": "apply", "why_important": "Every technical interview asks this. Analyze YOUR code, not just toy examples.", "interview_relevance": "high"},
        {"name": "Core Data Structures", "subtopics": ["Arrays", "Hash Maps", "Stacks", "Queues", "Sets", "Linked Lists"], "depth": "apply", "why_important": "Hash maps alone solve 60% of LeetCode Easy problems.", "interview_relevance": "high"},
        {"name": "Algorithm Patterns", "subtopics": ["Two Pointers", "Sliding Window", "HashMap frequency", "Binary Search", "Recursion"], "depth": "apply", "why_important": "5 patterns cover most junior interviews. Learn patterns, not individual problems.", "interview_relevance": "high"},
    ]
    if is_large:
        cs_topics.append({"name": "Trees & Graphs (intro)", "subtopics": ["Binary trees", "BFS/DFS", "When to use graphs"], "depth": "understand", "why_important": "Large company interviews often include tree traversal problems.", "interview_relevance": "high"})

    return {
        "phases": [
            {
                "phase_number": 1,
                "title": "Phase 1 — Core Language Fundamentals",
                "duration_weeks": fundamentals_weeks,
                "goal": f"Master {lang} fundamentals deeply enough to explain every concept without looking it up",
                "topics": p1_topics,
                "weekly_schedule": p1_schedule,
                "milestone_project": p1_project,
                "phase_complete_when": p1_complete,
            },
            {
                "phase_number": 2,
                "title": p2_title,
                "duration_weeks": 6,
                "goal": p2_goal,
                "topics": p2_topics,
                "weekly_schedule": p2_schedule,
                "milestone_project": p2_project,
                "phase_complete_when": p2_complete,
            },
            {
                "phase_number": 3,
                "title": "Phase 3 — Backend & APIs",
                "duration_weeks": 5,
                "goal": "Understand the full request lifecycle and be able to build and explain REST APIs",
                "topics": [
                    {"name": "HTTP & REST", "subtopics": ["HTTP methods", "Status codes", "Headers", "Request/Response cycle", "REST conventions"], "depth": "master", "why_important": "Classic interview question: 'What happens when you type a URL?' You must answer this.", "interview_relevance": "high"},
                    {"name": "Authentication", "subtopics": ["JWT structure", "Access vs Refresh tokens", "Password hashing", "HTTPS"], "depth": "apply", "why_important": "Auth is in every app and commonly misimplemented. Understanding it shows maturity.", "interview_relevance": "high"},
                    {"name": "SQL & Databases", "subtopics": ["SELECT, WHERE, JOIN, GROUP BY", "Primary & Foreign keys", "Indexes", "N+1 problem", "Schema design"], "depth": "apply", "why_important": "SQL is everywhere. Even frontend roles need basic SQL for debugging.", "interview_relevance": "high"},
                    {"name": "Security Basics", "subtopics": ["CORS", "XSS", "SQL Injection", "Environment variables", "Input validation"], "depth": "understand", "why_important": "You must know what CORS is and why it exists.", "interview_relevance": "medium"},
                ],
                "weekly_schedule": [
                    {"day": "Monday", "duration_minutes": 90, "activities": [
                        {"type": "theory", "title": "Full HTTP request lifecycle", "description": "Trace DNS → TCP → TLS → HTTP → response. Draw it by hand.", "resource": "MDN HTTP docs", "priority": "must"},
                        {"type": "coding", "title": "Build a REST API", "description": "Create /users with GET, POST, PUT, DELETE, proper status codes", "resource": "FastAPI or Express docs", "priority": "must"},
                    ]},
                    {"day": "Tuesday", "duration_minutes": 90, "activities": [
                        {"type": "theory", "title": "JWT internals", "description": "Decode a JWT manually at jwt.io. Understand header.payload.signature.", "resource": "jwt.io", "priority": "must"},
                        {"type": "coding", "title": "Add JWT auth to your API", "description": "Signup, login, and protected routes — from scratch", "resource": "Your editor", "priority": "must"},
                    ]},
                    {"day": "Wednesday", "duration_minutes": 90, "activities": [
                        {"type": "coding", "title": "SQL practice: JOINs and aggregates", "description": "Write queries with JOIN, GROUP BY, HAVING, subqueries", "resource": "SQLZoo", "priority": "must"},
                        {"type": "interview_prep", "title": "Explain the N+1 problem", "description": "What is it? Why does it happen? How do you fix it? Write it out.", "resource": "Paper", "priority": "must"},
                    ]},
                    {"day": "Thursday", "duration_minutes": 60, "activities": [
                        {"type": "theory", "title": "CORS & security", "description": "Why does CORS exist? Same-origin policy? Set up CORS correctly.", "resource": "MDN CORS docs", "priority": "must"},
                    ]},
                    {"day": "Friday", "duration_minutes": 60, "activities": [
                        {"type": "interview_prep", "title": "HTTP status code quiz", "description": "401 vs 403? 404 vs 500? GET vs POST? Answer without looking.", "resource": "Paper", "priority": "must"},
                    ]},
                    {"day": "Saturday", "duration_minutes": 180, "activities": [
                        {"type": "project", "title": "Connect frontend to real backend", "description": "Your Phase 2 frontend + a real REST API + database. Deploy it.", "resource": "Your editor", "priority": "must"},
                    ]},
                    {"day": "Sunday", "duration_minutes": 30, "activities": [
                        {"type": "review", "title": "Backend review", "description": "What parts of the request lifecycle can you explain confidently?", "resource": "Journal", "priority": "must"},
                    ]},
                ],
                "milestone_project": {
                    "title": "Full-Stack App Deployed",
                    "description": "Your Phase 2 frontend connected to a real backend: JWT auth, database with 2+ tables using a JOIN, error handling, deployed and publicly accessible.",
                    "skills_practiced": ["REST API design", "JWT auth", "SQL", "Full-stack integration", "Deployment"],
                },
                "phase_complete_when": [
                    "You can explain what happens when you type a URL (DNS → rendered HTML)",
                    "You can explain JWT auth flow without looking it up",
                    "You can write a SQL JOIN query from memory",
                    "You can explain CORS in plain English",
                    "Your full-stack project is deployed and accessible",
                ],
            },
            {
                "phase_number": 4,
                "title": "Phase 4 — Computer Science Essentials",
                "duration_weeks": 4,
                "goal": "Solve Easy LeetCode problems confidently and discuss Big-O in any interview",
                "topics": [
                    {"name": "Big-O Notation", "subtopics": ["O(1) vs O(n) vs O(n²)", "Space complexity", "Recognizing complexity in your own code"], "depth": "apply", "why_important": "Every technical interview asks this. Analyze YOUR code, not just toy examples.", "interview_relevance": "high"},
                    {"name": "Data Structures", "subtopics": ["Arrays", "Hash Maps", "Stacks", "Queues", "Sets", "Linked Lists concept"], "depth": "apply", "why_important": "Hash maps alone solve 60% of LeetCode Easy problems.", "interview_relevance": "high"},
                    {"name": "Algorithm Patterns", "subtopics": ["Two Pointers", "Sliding Window", "HashMap frequency count", "Binary Search", "Recursion basics"], "depth": "apply", "why_important": "Learn patterns, not individual problems. 5 patterns cover most junior interviews.", "interview_relevance": "high"},
                ],
                "weekly_schedule": [
                    {"day": "Monday", "duration_minutes": 75, "activities": [
                        {"type": "theory", "title": "Big-O notation", "description": "Learn O(1), O(n), O(n log n), O(n²). Analyze code snippets.", "resource": "bigocheatsheet.com", "priority": "must"},
                        {"type": "coding", "title": "Two Sum + Contains Duplicate", "description": "No hints. Analyze complexity after solving.", "resource": "LeetCode", "priority": "must"},
                    ]},
                    {"day": "Tuesday", "duration_minutes": 75, "activities": [
                        {"type": "coding", "title": "HashMap pattern: 3 problems", "description": "Frequency counting problems — recognize the pattern", "resource": "LeetCode", "priority": "must"},
                    ]},
                    {"day": "Wednesday", "duration_minutes": 75, "activities": [
                        {"type": "coding", "title": "Two Pointers + Sliding Window", "description": "Valid Palindrome, Longest Substring Without Repeating Characters", "resource": "LeetCode", "priority": "must"},
                    ]},
                    {"day": "Thursday", "duration_minutes": 75, "activities": [
                        {"type": "coding", "title": "Recursion practice", "description": "Fibonacci (iterative vs recursive), power function — understand the call stack", "resource": "Your editor", "priority": "must"},
                    ]},
                    {"day": "Friday", "duration_minutes": 60, "activities": [
                        {"type": "interview_prep", "title": "Think-aloud practice", "description": "Solve one LeetCode on paper, talking through your approach as if in a real interview", "resource": "Paper", "priority": "must"},
                    ]},
                    {"day": "Saturday", "duration_minutes": 90, "activities": [
                        {"type": "coding", "title": "3 LeetCode Easy — timed", "description": "20-30 min per problem. Move on even if not done.", "resource": "LeetCode", "priority": "must"},
                    ]},
                    {"day": "Sunday", "duration_minutes": 30, "activities": [
                        {"type": "review", "title": "Pattern review", "description": "Which patterns did you use this week? Write them without looking.", "resource": "Paper", "priority": "must"},
                    ]},
                ],
                "milestone_project": {
                    "title": "20 Easy + 5 Medium LeetCode Problems",
                    "description": "Solve 20 Easy and 5 Medium LeetCode problems. For each: write the pattern used, the time complexity, and one lesson learned. No AI assistance.",
                    "skills_practiced": ["Big-O analysis", "HashMap pattern", "Two Pointers", "Sliding Window", "Recursion"],
                },
                "phase_complete_when": [
                    "You can analyze any function's Big-O complexity on the spot",
                    "You can solve Two Sum, Valid Anagram, Best Time to Buy/Sell Stock — no hints",
                    "You can explain HashMap vs Array tradeoffs",
                    "You have solved at least 20 Easy LeetCode problems",
                ],
            },
            {
                "phase_number": 5,
                "title": "Phase 5 — Interview Preparation",
                "duration_weeks": 4,
                "goal": "Perform confidently in real technical interviews at your target company type",
                "topics": [
                    {"name": "Live Coding Skills", "subtopics": ["Thinking aloud", "Asking clarifying questions", "Brute force first", "Optimize after", "Edge cases"], "depth": "master", "why_important": "Most candidates fail not because they don't know the answer — but because they can't show their thinking.", "interview_relevance": "high"},
                    {"name": "Behavioral Questions", "subtopics": ["STAR method", "Tell me about yourself", "Biggest challenge", "Technical decisions you made", "Conflict resolution"], "depth": "apply", "why_important": "Culture fit matters as much as technical skill.", "interview_relevance": "high"},
                    {"name": "System Design Basics", "subtopics": ["What is scaling", "Database vs Cache", "API design basics", "Simplified Twitter/Instagram"], "depth": "understand", "why_important": "Junior interviews at larger companies may include basic system design.", "interview_relevance": "medium"},
                ],
                "weekly_schedule": [
                    {"day": "Monday", "duration_minutes": 90, "activities": [
                        {"type": "interview_prep", "title": "Mock interview: Interview Simulator", "description": "Do a full 10-question session in CodeQuest. Do not skip questions.", "resource": "CodeQuest Interview Mode", "priority": "must"},
                        {"type": "review", "title": "Review interview feedback", "description": "Note all weak areas. Add to study list for this week.", "resource": "CodeQuest Interview History", "priority": "must"},
                    ]},
                    {"day": "Tuesday", "duration_minutes": 75, "activities": [
                        {"type": "coding", "title": "2 LeetCode under time pressure", "description": "25 min per problem. Move on even if not done. Practice is in the time pressure.", "resource": "LeetCode", "priority": "must"},
                        {"type": "interview_prep", "title": "Project pitch practice", "description": "Record a 2-minute explanation of your main project. Refine until it's natural.", "resource": "Your phone", "priority": "must"},
                    ]},
                    {"day": "Wednesday", "duration_minutes": 60, "activities": [
                        {"type": "interview_prep", "title": "STAR stories", "description": "Prepare 5 STAR stories from your projects. Include a 'hard bug you fixed' story.", "resource": "Paper", "priority": "must"},
                    ]},
                    {"day": "Thursday", "duration_minutes": 75, "activities": [
                        {"type": "interview_prep", "title": "Job Ready Checklist study session", "description": "For each unchecked item in your checklist — study it today. Use the 'Test Yourself' button.", "resource": "CodeQuest Job Ready Checklist", "priority": "must"},
                    ]},
                    {"day": "Friday", "duration_minutes": 60, "activities": [
                        {"type": "interview_prep", "title": "Second mock interview", "description": "Another Interview Simulator session. Compare score to Monday.", "resource": "CodeQuest Interview Mode", "priority": "must"},
                    ]},
                    {"day": "Saturday", "duration_minutes": 60, "activities": [
                        {"type": "interview_prep", "title": "Company research", "description": "Find 5 companies that match your criteria. Learn their stack. Prepare one company-specific question.", "resource": "LinkedIn, company websites", "priority": "must"},
                    ]},
                    {"day": "Sunday", "duration_minutes": 30, "activities": [
                        {"type": "review", "title": "Apply", "description": "Send at least 3 job applications with your prepared materials.", "resource": "LinkedIn, AngelList, company websites", "priority": "must"},
                    ]},
                ],
                "milestone_project": {
                    "title": "5 Mock Interviews Completed",
                    "description": "Complete 5 full Interview Simulator sessions. Your final session score should be 7/10 or higher. You should answer questions about your projects without hesitation.",
                    "skills_practiced": ["Live coding", "Technical communication", "Behavioral questions", "Project presentation"],
                },
                "phase_complete_when": [
                    "You can solve a LeetCode Easy while talking through your approach — simultaneously",
                    "You can pitch your main project in under 2 minutes",
                    "You scored 7/10 or higher in your last mock interview",
                    "You have applied to at least 10 companies",
                ],
            },
        ],
        "interview_preparation": {
            "startup": {
                "topics": ["Full-stack awareness", "Product thinking", "Speed & delivery", "Wearing many hats", "Git workflow"],
                "typical_questions": [
                    "What side projects have you built on your own?",
                    "How do you prioritize when everything is urgent?",
                    "Tell me about a bug that took you a long time to find.",
                    "How do you stay up to date with the industry?",
                    "What would you build in your first 30 days here?",
                ],
                "coding_challenges": [
                    "Build a small feature end-to-end in 2 hours",
                    "Debug a broken piece of code they provide",
                    "Take-home project: simple CRUD app in your stack",
                ],
            },
            "medium_company": {
                "topics": ["System design basics", "Code quality & testing", "Process & documentation", "Team collaboration"],
                "typical_questions": [
                    "How do you approach code reviews?",
                    "Tell me about your experience with testing.",
                    "How do you handle technical debt?",
                    "Tell me about a time you disagreed with a technical decision.",
                    "How do you break down a large feature into tasks?",
                ],
                "coding_challenges": [
                    "Live coding on a shared editor: 1-2 algorithm problems",
                    "System design: how would you design a URL shortener?",
                    "Code review: find issues in a piece of code they provide",
                ],
            },
            "large_company": {
                "topics": ["Data structures & algorithms", "System design", "Scalability", "STAR behavioral method", "CS fundamentals"],
                "typical_questions": [
                    "Find the LCA of a binary tree",
                    "Design a rate limiting system",
                    "Tell me about a time you improved system performance",
                    "What's the difference between a process and a thread?",
                ],
                "coding_challenges": [
                    "2-3 LeetCode Medium problems under time pressure",
                    "System design: how would you build a notification system?",
                    "Architecture: design a database schema for an e-commerce platform",
                ],
            },
        },
        "portfolio_requirements": {
            "minimum_projects": 3,
            "must_have_features": [
                "User authentication (signup, login, protected routes)",
                "CRUD operations with a real database",
                "Responsive design — works on mobile",
                "Deployed and accessible via public URL",
                "Clean README with setup instructions and screenshots",
                "TypeScript throughout — no 'any' types",
            ],
            "nice_to_have": [
                "Automated tests (even just a few)",
                "CI/CD pipeline (GitHub Actions)",
                "Performance optimizations with documented reasoning",
                "Contribution to an open source project",
                "Technical blog post explaining something you learned",
            ],
        },
    }


async def generate_training_plan(
    goal: str,
    timeline: str,
    level: str,
    language: str,
    company_target: str = "",
    framework_focus: str = "",
    progress_notes: str = "",
) -> dict:
    return _stub_training_plan(goal, level, language, company_target, framework_focus)


# ── Checklist Test Questions ──────────────────────────────────────────────────

_TEST_QUESTIONS: dict[str, dict] = {
    "js_closures": {
        "question": "Write a counter function using a closure — it should return an increment function that keeps private state.",
        "expected_answer": "Function returns another function; inner function accesses outer variable via closure. State is not on the outer scope.",
    },
    "js_eq": {
        "question": "What does `0 == '0'` evaluate to and why? What about `0 === '0'`?",
        "expected_answer": "`0 == '0'` is true (type coercion converts string to number). `0 === '0'` is false (strict equality checks type AND value).",
    },
    "js_async": {
        "question": "What is the output order of: console.log(1), setTimeout(()=>console.log(2),0), Promise.resolve().then(()=>console.log(3)), console.log(4)?",
        "expected_answer": "1, 4, 3, 2. Sync runs first (1, 4). Microtasks (Promises) run before macrotasks (setTimeout). Shows understanding of the event loop.",
    },
    "js_reduce": {
        "question": "Implement Array.prototype.reduce() from scratch — it should work exactly like the native version.",
        "expected_answer": "Loop through array, apply callback(acc, cur, i, arr), start with initialValue if provided else first element. Return accumulator.",
    },
    "js_null_undef": {
        "question": "When does JavaScript give you `undefined` vs `null`? Give one example of each.",
        "expected_answer": "`undefined` = JS set it (uninitialized variable, missing function return, missing argument). `null` = developer explicitly set it to mean 'no value'.",
    },
    "js_event_bubbling": {
        "question": "A click on a <button> inside a <div> — which handlers fire and in what order? How do you stop this?",
        "expected_answer": "Button handler fires first, then div (bubbling up). `event.stopPropagation()` stops it. Capturing phase goes top-down (addEventistener 3rd arg true).",
    },
    "js_promises": {
        "question": "Rewrite this callback code as a Promise: `fs.readFile('file.txt', (err, data) => { if (err) handleErr(err); else process(data); })`",
        "expected_answer": "Wrap in `new Promise((resolve, reject) => {...})`. Call resolve(data) on success, reject(err) on error. Chain with .then() and .catch().",
    },
    "js_debounce": {
        "question": "Implement a `debounce(fn, delay)` function from scratch. No lodash.",
        "expected_answer": "Return function that clears previous timeout and sets a new one. Callback only fires after `delay` ms of silence. Uses closure to hold the timer id.",
    },
    "react_lifecycle": {
        "question": "What is the equivalent of componentDidMount, componentDidUpdate, and componentWillUnmount in hooks?",
        "expected_answer": "All three map to useEffect. No deps = every render. [] = mount only (componentDidMount). [dep] = on dep change (componentDidUpdate). Return fn = cleanup (componentWillUnmount).",
    },
    "react_hooks": {
        "question": "You have a filtered list and an event handler — which one gets useMemo and which gets useCallback?",
        "expected_answer": "useMemo = computed value (the filtered list). useCallback = function reference (the event handler). useMemo caches the result; useCallback caches the function itself.",
    },
    "react_prop_drill": {
        "question": "You have props passed through 4 component levels but only used at the bottom. Name two solutions and when to choose each.",
        "expected_answer": "Context API (built-in, good for global state like theme/auth). Zustand/Redux (external store, good for complex/frequently updated state). Context is simpler; state managers scale better.",
    },
    "react_custom_hook": {
        "question": "Write a `useLocalStorage(key, initialValue)` custom hook that reads from and writes to localStorage.",
        "expected_answer": "useState initialized from localStorage.getItem(). Update function calls setState AND localStorage.setItem(). Return [value, setValue] pair.",
    },
    "react_keys": {
        "question": "Why is using array index as a key in a list a bad practice? Give a concrete example of what breaks.",
        "expected_answer": "When items reorder or are deleted, React reuses DOM nodes incorrectly (mismatched state, focus, animations). Use stable unique IDs. Index is fine only for static, non-reordering lists.",
    },
    "react_state_mutate": {
        "question": "What's the bug: `const [items, setItems] = useState([]); items.push('new'); setItems(items);`",
        "expected_answer": "Mutating state directly. React compares references — same array reference means no re-render. Fix: `setItems([...items, 'new'])` to create a new array.",
    },
    "react_controlled": {
        "question": "What's the difference between a controlled and uncontrolled input? Show code for both.",
        "expected_answer": "Controlled: value={state} + onChange={setState} — React owns the value. Uncontrolled: no value prop, use ref to read DOM value. Controlled is preferred for validation/sync.",
    },
    "api_http_flow": {
        "question": "Walk me through everything that happens between typing 'google.com' and seeing the page — as much detail as you can.",
        "expected_answer": "DNS lookup → TCP handshake → TLS handshake → HTTP GET → server responds → browser parses HTML → CSS/JS requested → page rendered. Bonus: CDN, caching, CORS.",
    },
    "api_401_403": {
        "question": "Your API returns 401. Your colleague says 'change it to 403'. Are they right? When is each correct?",
        "expected_answer": "401 = unauthenticated (no/invalid token — 'who are you?'). 403 = unauthorized (valid identity, wrong permissions — 'I know who you are, but you can't do this'). They're right only if the user IS authenticated.",
    },
    "api_sql_join": {
        "question": "Write a query: get all users and their order counts. Include users with 0 orders.",
        "expected_answer": "SELECT users.name, COUNT(orders.id) FROM users LEFT JOIN orders ON users.id = orders.user_id GROUP BY users.id, users.name. LEFT JOIN includes users with no orders (vs INNER JOIN which excludes them).",
    },
    "api_jwt": {
        "question": "Describe the complete JWT auth flow — from signup through making an authenticated API request.",
        "expected_answer": "Signup → hash password, store user. Login → verify password, sign JWT (header.payload.signature). Client stores token. Request → send as Authorization: Bearer <token>. Server verifies signature. Never store sensitive data in payload (it's base64, not encrypted).",
    },
    "api_cors": {
        "question": "Why does CORS exist and why can't you just disable it? What headers does the server send?",
        "expected_answer": "Same-origin policy prevents malicious sites from making authenticated requests on your behalf. CORS allows explicit whitelist. Headers: Access-Control-Allow-Origin, -Methods, -Headers. Preflight OPTIONS request for non-simple requests.",
    },
    "cs_bigo": {
        "question": "What's the Big-O of this: `for (let i = 0; i < n; i++) { for (let j = 0; j < n; j++) { ... } }`? What about adding a third loop?",
        "expected_answer": "Two nested loops = O(n²). Three nested loops = O(n³). Each additional loop multiplies by n. Key: identify how many times the inner operation runs as n grows.",
    },
    "cs_stack_heap": {
        "question": "Where is a primitive stored vs an object? What happens to a stack frame when a function returns?",
        "expected_answer": "Primitives → stack (fast, fixed size, LIFO). Objects/functions → heap (dynamic size, garbage collected). Stack frame is popped on return, freeing local variables. Reference to heap object goes on stack; object stays until GC.",
    },
    "cs_two_sum": {
        "question": "Solve Two Sum in O(n) time. Input: nums=[2,7,11,15], target=9. No nested loops.",
        "expected_answer": "Use a HashMap. For each num, check if (target - num) is in the map. If yes, return [map[complement], i]. If no, store num → index. One pass, O(n) time, O(n) space.",
    },
    "cs_recursion": {
        "question": "Write a recursive function to sum all numbers in a nested array like [1, [2, [3, 4]]]. No loops.",
        "expected_answer": "Base case: if number, return it. Recursive case: if array, reduce with sum of recursive calls on each element. Must handle the base case to avoid infinite recursion. Stack grows with depth.",
    },
    "soft_project_pitch": {
        "question": "Explain your main project in under 2 minutes. What problem does it solve, how does it work, and what was technically challenging?",
        "expected_answer": "Should cover: what it does (1 sentence), the tech stack, one interesting technical challenge and how it was solved, and what you'd do differently. Avoids buzzwords. Shows real understanding.",
    },
    "soft_hard_bug": {
        "question": "Tell me about the hardest bug you ever fixed. Walk me through your debugging process.",
        "expected_answer": "Should show systematic debugging (hypothesis, isolation, verification). Mention specific tools (console, debugger, logs, git bisect). Explain what the root cause actually was. Shows persistence and methodology.",
    },
    "soft_tech_decision": {
        "question": "Why did you choose your main project's tech stack? What tradeoffs did you consider?",
        "expected_answer": "Should show intentional decision-making: reasons beyond 'I knew it', awareness of tradeoffs (e.g. 'chose SQL because I needed joins', not just 'SQL is popular'). Bonus: what you'd choose today vs then.",
    },
    "soft_refactor": {
        "question": "Open your main project's code right now — what's the first thing you'd refactor and why?",
        "expected_answer": "Shows self-awareness and code maturity. Acceptable answers: better error handling, tests, component splitting, naming improvements. Red flag: 'nothing, it's perfect' or purely cosmetic changes.",
    },
}


async def generate_test_question(item_key: str, item_label: str) -> dict:
    return _TEST_QUESTIONS.get(item_key, {
        "question": f"Explain '{item_label}' in your own words and give a concrete example.",
        "expected_answer": "A clear explanation with a practical example showing real understanding — not just a definition.",
    })


# ── Interview Simulator ───────────────────────────────────────────────────────

INTERVIEW_SYSTEM = """You are a senior developer conducting a technical interview for a Junior {focus} Developer position at a {company_size} company.

Rules:
- Ask ONE question at a time
- Start with easier questions and gradually increase difficulty over 10 questions
- After each candidate answer, give honest evaluation: what was good, what was missing, what a better answer would include
- Do NOT accept vague answers — ask follow-ups like a real interviewer would
- Be realistic but encouraging
- Format every response as valid JSON:
  {{"evaluation": "<feedback on the previous answer, or null for the first question>", "question": "<your next question>", "question_number": <number>}}"""


_INTERVIEW_BANK: dict[str, list[tuple[str, str]]] = {
    "frontend": [
        (
            "Tell me about yourself and your journey into frontend development. What's the most interesting thing you've built?",
            "Concrete projects with tech stack, clear timeline, genuine enthusiasm for a specific area.",
        ),
        (
            "What is the Virtual DOM and why does React use it instead of manipulating the real DOM directly?",
            "Virtual DOM = lightweight JS tree. React diffs old vs new (reconciliation), then applies minimal DOM updates in one batch. Real DOM is slow because any change can trigger reflow/repaint.",
        ),
        (
            "Explain closures in JavaScript. Give me a real use case, not just a textbook definition.",
            "Closure = function that retains access to its outer scope. Real use cases: counter with private state, memoization, event handlers that remember config, module pattern.",
        ),
        (
            "When does a React component re-render? List every scenario you can think of.",
            "Own state changes, props change, parent re-renders (even with same props unless memo), context changes, useReducer dispatch. Memo/useMemo/useCallback prevent unnecessary re-renders.",
        ),
        (
            "What's the difference between useMemo and useCallback? Show me when you'd use each.",
            "useMemo caches a computed VALUE. useCallback caches a FUNCTION reference. Use useMemo for expensive calculations; useCallback when passing callbacks to memoized children to prevent re-renders.",
        ),
        (
            "You have a list of 10,000 items rendering slowly in React. Walk me through how you'd debug and fix the performance issue.",
            "React DevTools Profiler → find which component re-renders. Solutions: virtualization (react-window), memo on list items, useCallback for handlers, pagination. Bonus: move state down to avoid parent re-renders.",
        ),
        (
            "How does async/await work under the hood in JavaScript? What is the event loop?",
            "JS is single-threaded. Event loop: call stack + task queue + microtask queue. Promises go to microtask queue (runs before next task). async/await is syntactic sugar over Promises. Microtasks before macrotasks (setTimeout).",
        ),
        (
            "What is TypeScript and why would you choose it over plain JavaScript for a new project?",
            "TypeScript = JS + static types. Benefits: catch bugs at compile time, better IDE autocomplete, safer refactoring, self-documenting code. Cost: setup, more verbose, learning curve. Worth it for any project >1 person or >2 weeks.",
        ),
        (
            "Describe the CSS box model. What's the difference between box-sizing: content-box and border-box?",
            "Box model: content + padding + border + margin. content-box (default): width = content only, padding/border add to total. border-box: width includes content + padding + border. border-box is almost always what you want.",
        ),
        (
            "Tell me about the most challenging technical problem you solved in a project. What was your debugging process?",
            "Should show systematic debugging: hypothesis → isolate → verify. Mention specific tools. Explain root cause clearly. Shows maturity and problem-solving methodology.",
        ),
    ],
    "backend": [
        (
            "Tell me about yourself and your experience with backend development. What's a system you're proud of having built?",
            "Concrete system with real tech stack, explains the problem it solved, mentions scale or interesting constraints.",
        ),
        (
            "Walk me through everything that happens between a user typing 'google.com' and seeing the page — as much detail as possible.",
            "DNS lookup → TCP handshake → TLS handshake → HTTP GET request → server processes → response → browser parses HTML → fetch CSS/JS → render. Bonus: CDN, caching, CORS, keep-alive.",
        ),
        (
            "Explain JWT authentication end-to-end. How does the server verify a token without storing it?",
            "Signup: hash password (bcrypt). Login: verify password, sign JWT (header.payload.signature using secret). Client stores token (localStorage/cookie). Request: send as Bearer token. Server verifies signature using same secret — no DB lookup needed. Never put sensitive data in payload (base64, not encrypted).",
        ),
        (
            "What is the N+1 problem? Show me an example query that causes it and how to fix it.",
            "N+1: fetch N records, then 1 query PER record to get related data. Fix: JOIN or eager loading. Example: SELECT * FROM posts, then for each post SELECT * FROM comments WHERE post_id=$id — replace with SELECT posts.*, comments.* FROM posts LEFT JOIN comments ON posts.id = comments.post_id.",
        ),
        (
            "What's the difference between HTTP 401 and 403? When would an API return each?",
            "401 Unauthorized = not authenticated (no token or invalid token — 'who are you?'). 403 Forbidden = authenticated but not permitted ('I know who you are, but you can't access this'). Wrong naming in HTTP spec but that's the accepted meaning.",
        ),
        (
            "You have a slow API endpoint — response time went from 50ms to 3 seconds. Walk me through your debugging process.",
            "Check logs for slow queries (EXPLAIN ANALYZE). Check N+1 patterns. Check if missing index. Check payload size. APM tool (Datadog/New Relic). Profile code. Add caching (Redis). Could also be network/external service — check each dependency.",
        ),
        (
            "Explain SQL indexes. When should you add one, and when can an index hurt performance?",
            "Index = B-tree data structure on a column for fast lookup. Add when: frequent WHERE/JOIN/ORDER BY on that column. Hurts: INSERT/UPDATE/DELETE are slower (index must be updated), extra disk space, optimizer can choose wrong index on low-cardinality columns.",
        ),
        (
            "What is CORS and why does it exist? What headers does the server need to send?",
            "Same-origin policy prevents scripts on evil.com from making authenticated requests to yourbank.com. CORS = server whitelist that says 'I allow requests from these origins'. Headers: Access-Control-Allow-Origin, -Methods, -Headers. Preflight OPTIONS request for non-simple requests.",
        ),
        (
            "What is the difference between SQL and NoSQL databases? Give me a scenario where you'd pick each.",
            "SQL: relational, ACID, schema, good for complex queries with JOINs. NoSQL: flexible schema, horizontal scaling, document/key-value/graph. Pick SQL when: relations matter, need transactions, data is structured. Pick NoSQL when: massive scale, flexible/unknown schema, simple access patterns.",
        ),
        (
            "Design the database schema for a simple Twitter clone. What tables, columns, and indexes would you create?",
            "Users (id, username, bio, created_at), Tweets (id, user_id FK, content, created_at), Follows (follower_id FK, followee_id FK, PK both). Indexes: tweets.user_id, follows.followee_id. Bonus: likes table, retweets as tweets with parent_id.",
        ),
    ],
}


def _stub_interview_message(question_number: int, focus: str) -> dict:
    key = "backend" if "backend" in focus.lower() else "frontend"
    bank = _INTERVIEW_BANK.get(key, _INTERVIEW_BANK["frontend"])
    idx = min(question_number - 1, len(bank) - 1)
    question, rubric = bank[idx]

    evaluation = None
    if question_number > 1:
        prev_idx = min(question_number - 2, len(bank) - 1)
        _, prev_rubric = bank[prev_idx]
        evaluation = f"A complete answer would cover: {prev_rubric}"

    return {
        "evaluation": evaluation,
        "question": question,
        "question_number": question_number,
    }


async def interview_message(
    messages: list,
    company_size: str,
    focus: str,
    question_number: int,
) -> dict:
    client = _get_claude()
    if not client:
        return _stub_interview_message(question_number, focus)

    system = INTERVIEW_SYSTEM.format(company_size=company_size, focus=focus)
    # Anthropic API requires at least one message; seed one for the opening question
    api_messages = [{"role": m["role"], "content": m["content"]} for m in messages]
    if not api_messages:
        api_messages = [{"role": "user", "content": "Please begin the interview with your first question."}]
    msg = await client.messages.create(
        model=MODEL, max_tokens=500,
        system=system,
        messages=api_messages,
    )
    return _parse_json(msg.content[0].text)


def _stub_summary() -> dict:
    return {
        "score": 6,
        "strongest_areas": ["Communication", "Basic JavaScript knowledge"],
        "weakest_areas": ["Closures", "System design thinking"],
        "study_topics": [
            "Closures and lexical scope — practice writing 5 examples",
            "JWT authentication flow — draw it on paper",
            "Big-O notation — analyze your own code",
        ],
        "overall_feedback": "Solid foundation with room to grow. Focus on deepening your understanding of closures and async patterns before your next interview. Your communication skills are a real strength — keep that up.",
    }


async def interview_summary(messages: list, company_size: str, focus: str) -> dict:
    client = _get_claude()
    if not client:
        return _stub_summary()

    prompt = (
        f"You just conducted a 10-question technical interview for a Junior {focus} Developer at a {company_size} company. "
        "Review the full conversation and give an honest performance assessment as JSON:\n"
        '{"score": <1-10>, "strongest_areas": ["..."], "weakest_areas": ["..."], '
        '"study_topics": ["specific things to study before next interview"], '
        '"overall_feedback": "2-3 sentence honest summary"}'
    )
    all_messages = list(messages) + [{"role": "user", "content": prompt}]
    msg = await client.messages.create(
        model=MODEL, max_tokens=600,
        messages=[{"role": m["role"], "content": m["content"]} for m in all_messages],
    )
    return _parse_json(msg.content[0].text)


# ── Explain Lesson ────────────────────────────────────────────────────────────

def _forbidden_constructs(constraints: list[str], language: str) -> list[str]:
    """Derive explicitly forbidden language constructs from what has NOT been learned yet."""
    cl = " ".join(constraints).lower()
    is_js = language in ("javascript", "typescript")
    forbidden = []
    if not any(w in cl for w in ("conditional", "if", "else", "switch", "ternary")):
        forbidden += (["if/else statements", "ternary operator (?:)", "switch statements"]
                      if is_js else ["if/elif/else statements", "ternary expressions"])
    if not any(w in cl for w in ("loop", "for", "while", "foreach", "map", "filter", "reduce")):
        forbidden += (["for loops", "while loops", "forEach", "map()", "filter()", "reduce()"]
                      if is_js else ["for loops", "while loops", "list comprehensions"])
    if not any(w in cl for w in ("function", "arrow", "def ", "lambda")):
        forbidden += (["function declarations", "arrow functions (=>)", "callbacks"]
                      if is_js else ["function definitions (def)", "lambda"])
    if not any(w in cl for w in ("array", "list", "tuple")):
        forbidden += ["arrays ([])", "array methods"] if is_js else ["lists []", "tuples"]
    if not any(w in cl for w in ("object", "dict", "class", "map", "set")):
        forbidden += ["objects {}", "object methods"] if is_js else ["dicts {}", "classes"]
    if not any(w in cl for w in ("class", "oop", "inherit", "prototype")):
        forbidden += ["classes", "new keyword", "prototype"]
    if not any(w in cl for w in ("error", "try", "catch", "except", "throw", "raise")):
        forbidden += ["try/catch", "throw"] if is_js else ["try/except", "raise"]
    if not any(w in cl for w in ("async", "await", "promise", "callback")):
        forbidden += ["async/await", "Promises", "setTimeout"]
    if not any(w in cl for w in ("import", "require", "module", "export")):
        forbidden += ["import/require", "module exports"]
    return forbidden


# Regex patterns keyed by the concept name — used to detect violations in generated code
_VIOLATION_PATTERNS: dict[str, list[str]] = {
    "conditionals": [r'\bif\b', r'\belse\b', r'\bswitch\b', r'(?<!["\'])(\?[^?])'],
    "loops": [r'\bfor\b', r'\bwhile\b', r'\bforEach\b', r'\.map\s*\(', r'\.filter\s*\(', r'\.reduce\s*\('],
    "functions": [r'\bfunction\b', r'=>'],
    "arrays": [r'\[.*\]'],
    "classes": [r'\bclass\b', r'\bnew\b'],
    "try_catch": [r'\btry\b', r'\bcatch\b', r'\bthrow\b', r'\bexcept\b', r'\braise\b'],
    "async": [r'\basync\b', r'\bawait\b'],
    "import": [r'\bimport\b', r'\brequire\b'],
}


def _has_violations(code: str, constraints: list[str]) -> bool:
    cl = " ".join(constraints).lower()
    checks = []
    if not any(w in cl for w in ("conditional", "if", "else", "switch", "ternary")):
        checks += _VIOLATION_PATTERNS["conditionals"]
    if not any(w in cl for w in ("loop", "for", "while", "foreach", "map", "filter", "reduce")):
        checks += _VIOLATION_PATTERNS["loops"]
    if not any(w in cl for w in ("function", "arrow", "def ", "lambda")):
        checks += _VIOLATION_PATTERNS["functions"]
    if not any(w in cl for w in ("class", "oop", "inherit")):
        checks += _VIOLATION_PATTERNS["classes"]
    if not any(w in cl for w in ("error", "try", "catch")):
        checks += _VIOLATION_PATTERNS["try_catch"]
    if not any(w in cl for w in ("async", "await", "promise")):
        checks += _VIOLATION_PATTERNS["async"]
    if not any(w in cl for w in ("import", "require", "module")):
        checks += _VIOLATION_PATTERNS["import"]
    for pattern in checks:
        if re.search(pattern, code):
            return True
    return False


def _clean_code(text: str) -> str:
    text = text.strip()
    text = re.sub(r'^```[a-z]*\n?', '', text)
    text = re.sub(r'\n?```$', '', text)
    return text.strip()


async def generate_explain_code(topic_constraints: list[str], language: str) -> str:
    """Generate a code snippet using ONLY the listed concepts — no others."""
    client = _get_claude()
    if not client:
        return ""
    topics_str = ", ".join(topic_constraints)
    lang_name = {"python": "Python", "javascript": "JavaScript", "typescript": "TypeScript"}.get(language, "Python")
    forbidden = _forbidden_constructs(topic_constraints, language)
    forbidden_str = ", ".join(forbidden) if forbidden else "none"

    def make_prompt(extra: str = "") -> str:
        return (
            f"CRITICAL CONSTRAINT: Generate a {lang_name} code snippet for a beginner student.\n"
            f"The student has ONLY learned: {topics_str}.\n\n"
            f"YOU MUST NOT USE ANY OF THESE — they are completely off-limits:\n"
            f"{forbidden_str}\n\n"
            f"This means: if the word 'if', 'else', 'for', 'while', 'function', '=>', '?', "
            f"'class', 'new', 'try', 'catch', 'import', 'require' appears in your code, it is WRONG.\n"
            f"{extra}"
            "Requirements:\n"
            "- 6–12 lines of pure assignment, arithmetic, and console.log/print only\n"
            "- Use MULTIPLE data types: strings, numbers, booleans\n"
            "- Real-world scenario (price, score, measurement)\n"
            "- NO comments (no //, no #)\n"
            "- NO markdown fences\n"
            "- Return ONLY the raw code, nothing else."
        )

    for attempt in range(3):
        extra = f"PREVIOUS ATTEMPT WAS REJECTED because it used forbidden constructs. Try again.\n\n" if attempt > 0 else ""
        msg = await client.messages.create(
            model=MODEL, max_tokens=500,
            messages=[{"role": "user", "content": make_prompt(extra)}],
        )
        result = _clean_code(msg.content[0].text)
        if not _has_violations(result, topic_constraints):
            return result

    # Return last attempt even if it has violations — better than nothing
    return result


async def evaluate_explanation(code: str, user_explanation: str, language: str) -> tuple[bool, str]:
    """Evaluate a student's plain-text explanation of a code snippet."""
    client = _get_claude()
    if not client:
        return True, "AI evaluation not available — marked as complete."
    if not user_explanation or len(user_explanation.strip()) < 15:
        return False, "Your explanation is too short. Try to describe what each part of the code does, step by step."
    prompt = (
        f"A student was shown this {language} code and asked to explain what it does:\n\n"
        f"```\n{code}\n```\n\n"
        f"The student wrote:\n\"{user_explanation}\"\n\n"
        "Evaluate whether this shows genuine understanding. Technical terms are NOT required — "
        "understanding the PURPOSE and FLOW matters most.\n\n"
        "PASS if the student:\n"
        "- Correctly describes the overall goal of the code\n"
        "- Mentions the main steps or logic (conditions, loops, function calls, etc.)\n"
        "- Shows they understand what output or result is produced\n\n"
        "FAIL if the student:\n"
        "- Is too vague ('it calculates something', 'it prints stuff')\n"
        "- Gets the purpose fundamentally wrong\n"
        "- Describes only one tiny detail while missing the whole picture\n\n"
        'Return ONLY valid JSON: {"passed": true, "feedback": "2-3 sentences: acknowledge what was right, mention what was missing if failed, end with encouragement"}'
    )
    try:
        msg = await client.messages.create(
            model=MODEL, max_tokens=300,
            messages=[{"role": "user", "content": prompt}],
        )
        result = _parse_json(msg.content[0].text)
        return bool(result.get("passed")), str(result.get("feedback", ""))
    except Exception:
        return True, "Great explanation — you clearly understand the code!"


# ── Code Review ───────────────────────────────────────────────────────────────

async def review_code(task: str, expected_output: str, user_code: str, language: str) -> dict:
    client = _get_claude()
    if not client:
        return {
            "strengths": ["Your code produced the correct output!"],
            "suggestion": "AI review is not configured. Set ANTHROPIC_API_KEY to enable detailed reviews.",
            "alternative": None,
            "grade": "Good",
        }

    prompt = (
        f"You are a code reviewer for a programming learning app. Review this student's solution.\n\n"
        f"Task: {task}\n"
        f"Expected output: {expected_output}\n"
        f"Language: {language}\n"
        f"Student's code:\n{user_code}\n\n"
        'Return ONLY valid JSON with these fields:\n'
        '- "strengths": array of 1-2 strings, each max 80 chars, what they did well\n'
        '- "suggestion": string, one specific improvement (style, efficiency, or best practice)\n'
        '- "alternative": string with cleaner code snippet, or null if already good\n'
        '- "grade": "Good", "Great", or "Excellent"\n\n'
        "Be encouraging but specific. Keep response concise. Return ONLY the JSON object."
    )

    try:
        msg = await client.messages.create(
            model=MODEL, max_tokens=500,
            messages=[{"role": "user", "content": prompt}],
        )
        return _parse_json(msg.content[0].text)
    except Exception:
        return {
            "strengths": ["Your code produced the correct output!"],
            "suggestion": "Could not parse review response. Please try again.",
            "alternative": None,
            "grade": "Good",
        }


# ── Background content generation ────────────────────────────────────────────

async def generate_missing_hints(
    instructions: str, existing_hints: list, language: str
) -> list:
    """Generate hints 2 and/or 3 for a lesson that has fewer than 3 pre-stored hints."""
    client = _get_claude()
    if not client:
        return []

    hints_needed = list(range(len(existing_hints) + 1, 4))
    if not hints_needed:
        return []

    level_desc = {
        1: "a very gentle nudge (just point in the right direction, no code)",
        2: "a moderately specific hint (explain the approach without showing code)",
        3: "a very specific hint (show the key concept or exact syntax needed)",
    }
    existing_text = ""
    if existing_hints:
        existing_text = "Existing hints (do NOT repeat):\n" + "\n".join(
            f"{i+1}. {h}" for i, h in enumerate(existing_hints)
        ) + "\n\n"
    hints_descs = "\n".join(f"Hint {i}: {level_desc[i]}" for i in hints_needed)

    try:
        msg = await client.messages.create(
            model=MODEL, max_tokens=300,
            messages=[{"role": "user", "content":
                f"Task: {instructions}\nLanguage: {language}\n\n"
                f"{existing_text}"
                f"Generate these additional hints:\n{hints_descs}\n\n"
                f"Return ONLY a JSON array of {len(hints_needed)} strings, e.g. [\"hint...\", ...]"
            }],
        )
        result = json.loads(msg.content[0].text.strip())
        if isinstance(result, list):
            return [str(h) for h in result[: len(hints_needed)]]
    except Exception:
        pass
    return []


async def generate_test_cases_for_lesson(
    instructions: str, expected_output: str, solution: str, language: str
) -> list:
    """Generate 3 stdin-based test cases for a code lesson (for lessons using input())."""
    client = _get_claude()
    if not client:
        return []

    try:
        msg = await client.messages.create(
            model=MODEL, max_tokens=600,
            messages=[{"role": "user", "content":
                f"Task: {instructions}\nLanguage: {language}\n"
                f"Solution:\n{solution}\n\n"
                "Generate 3 diverse test cases (different inputs) for this coding task.\n"
                "Cover: normal case, edge case (0/empty/negative), another variation.\n"
                'Return ONLY a JSON array: '
                '[{"description": "...", "input": "5\\n", "expected_output": "25\\n"}, ...]\n'
                "Use \\n at end of each input and output line."
            }],
        )
        text = msg.content[0].text.strip()
        if text.startswith("```"):
            text = text.split("```")[1]
            if text.startswith("json"):
                text = text[4:]
        result = json.loads(text.strip())
        if isinstance(result, list) and all(
            "input" in tc and "expected_output" in tc for tc in result
        ):
            return result[:5]
    except Exception:
        pass
    return []


async def generate_quiz_option_explanations(
    question: str, options: list, correct_index: int
) -> list:
    """Generate a one-sentence explanation for each quiz answer option."""
    client = _get_claude()
    if not client:
        return []

    options_text = "\n".join(f"{i}. {opt}" for i, opt in enumerate(options))
    try:
        msg = await client.messages.create(
            model=MODEL, max_tokens=500,
            messages=[{"role": "user", "content":
                f"Quiz question: {question}\n\nOptions:\n{options_text}\n"
                f"Correct: option {correct_index} ({options[correct_index]})\n\n"
                f"For each option (0 to {len(options)-1}), write ONE short sentence explaining "
                "why it is correct or specifically why it is wrong (be concrete).\n"
                f'Return ONLY a JSON array of {len(options)} strings: '
                '["✅ ...", "❌ ...", ...]'
            }],
        )
        text = msg.content[0].text.strip()
        if text.startswith("```"):
            text = text.split("```")[1]
            if text.startswith("json"):
                text = text[4:]
        result = json.loads(text.strip())
        if isinstance(result, list) and len(result) == len(options):
            return [str(e) for e in result]
    except Exception:
        pass
    return []


async def extract_theory_terms(sections: list, prog_language: str) -> list[str]:
    """Extract technical terms from theory lesson content that beginners may not know."""
    client = _get_claude()
    if not client:
        return []

    text = "\n".join(s.get("content", "") for s in sections if isinstance(s, dict))[:2000]
    try:
        msg = await client.messages.create(
            model=MODEL, max_tokens=200,
            messages=[{"role": "user", "content":
                f"Programming language context: {prog_language}\n\nLesson content:\n{text}\n\n"
                "List ALL technical terms, keywords, and programming concepts mentioned in this "
                "text that a beginner might not fully understand. Include things like: language "
                "keywords (async, await, callback), design patterns (MVC, singleton), protocols "
                "(HTTP, REST), and domain-specific terms. Do NOT include basic words.\n"
                "Return ONLY a JSON array of strings, max 15 terms. Example: [\"async\", \"callback\", \"Promise\"]"
            }],
        )
        result = json.loads(msg.content[0].text.strip().split("```json")[-1].split("```")[0].strip())
        if isinstance(result, list):
            return [str(t).strip() for t in result if t][:15]
    except Exception:
        pass
    return []


async def generate_glossary_entry(term: str, prog_language: str) -> dict:
    """Generate DE + EN explanation and optional code example for a technical term."""
    client = _get_claude()
    if not client:
        return {}

    try:
        msg = await client.messages.create(
            model=MODEL, max_tokens=400,
            messages=[{"role": "user", "content":
                f"Term: \"{term}\"\nContext: {prog_language} programming\n\n"
                "Generate a glossary entry. Return JSON with these exact keys:\n"
                "- explanation_de: 2-3 sentence German explanation for a beginner. Be concrete, avoid jargon.\n"
                "- explanation_en: 2-3 sentence English explanation for a beginner.\n"
                "- example: a SHORT code snippet (max 5 lines) demonstrating the term, or null if not applicable.\n"
                "- example_language: the programming language of the example (e.g. 'javascript'), or null.\n"
                "Return ONLY valid JSON, no markdown."
            }],
        )
        raw = msg.content[0].text.strip()
        if raw.startswith("```"):
            raw = raw.split("```json")[-1].split("```")[0].strip()
        data = json.loads(raw)
        return {
            "explanation_de": str(data.get("explanation_de", "")),
            "explanation_en": str(data.get("explanation_en", "")),
            "example": data.get("example"),
            "example_language": data.get("example_language"),
        }
    except Exception:
        return {}


async def generate_why_matters(
    topic_title: str, theory_content: dict, language: str, ui_lang: str = "en"
) -> str:
    """Generate a 2-3 sentence 'where this is used in real projects' section."""
    client = _get_claude()
    if not client:
        return ""

    summary = str(theory_content.get("summary", ""))[:300]
    lang_instruction = "in German" if ui_lang == "de" else "in English"
    prefix = "🌍 Real world" if ui_lang != "de" else "🌍 In der Praxis"
    try:
        msg = await client.messages.create(
            model=MODEL, max_tokens=150,
            messages=[{"role": "user", "content":
                f"Topic: {topic_title}\nLanguage: {language}\nSummary: {summary}\n\n"
                f"Write 2 sentences {lang_instruction} explaining where this concept is used in REAL "
                f"{language} projects. Be concrete: mention specific frameworks, APIs, "
                f"or code patterns. Start with '{prefix}:'"
            }],
        )
        return msg.content[0].text.strip()
    except Exception:
        return ""


async def generate_learning_objectives(
    title: str, lesson_type: str, content_summary: str, prog_language: str, ui_lang: str = "en"
) -> list[str]:
    """Generate 3 learning objectives ('Nach dieser Lektion kannst du...') for a lesson."""
    client = _get_claude()
    if not client:
        return []

    lang_instruction = "in German (du-form), each starting with a verb" if ui_lang == "de" else "in English, each starting with a verb"
    try:
        msg = await client.messages.create(
            model=MODEL, max_tokens=200,
            messages=[{"role": "user", "content":
                f"Lesson title: \"{title}\"\nType: {lesson_type}\nLanguage: {prog_language}\n"
                f"Content summary: {content_summary[:400]}\n\n"
                f"Write exactly 3 learning objectives {lang_instruction}. "
                "Each should complete 'After this lesson you can...' (or German equivalent). "
                "Be specific and measurable. Return ONLY a JSON array of 3 strings."
            }],
        )
        raw = msg.content[0].text.strip()
        if raw.startswith("```"):
            raw = raw.split("```json")[-1].split("```")[0].strip()
        result = json.loads(raw)
        if isinstance(result, list):
            return [str(r) for r in result[:3]]
    except Exception:
        pass
    return []


async def generate_story_context(
    title: str, instructions: str, prog_language: str
) -> str:
    """Generate a 2-sentence real-world scenario that frames a code lesson."""
    client = _get_claude()
    if not client:
        return ""

    try:
        msg = await client.messages.create(
            model=MODEL, max_tokens=120,
            messages=[{"role": "user", "content":
                f"Code lesson: \"{title}\"\nTask: {instructions[:300]}\nLanguage: {prog_language}\n\n"
                "Write a 2-sentence real-world scenario that makes this task feel meaningful. "
                "Example style: 'Du arbeitest als Backend-Entwickler bei einem Startup. "
                "Dein Team braucht eine Funktion, die...' "
                "Keep it concrete, relatable, professional. NO generic phrases like 'Stell dir vor'. "
                "Write in German. Return ONLY the scenario text, no quotes."
            }],
        )
        return msg.content[0].text.strip()
    except Exception:
        return ""


async def generate_alt_explanation(
    section_heading: str, section_content: str, prog_language: str
) -> str:
    """Generate an alternative explanation of a theory section using a different approach."""
    client = _get_claude()
    if not client:
        return ""

    try:
        msg = await client.messages.create(
            model=MODEL, max_tokens=300,
            messages=[{"role": "user", "content":
                f"Programming context: {prog_language}\n"
                f"Section: \"{section_heading}\"\n"
                f"Original explanation: {section_content[:600]}\n\n"
                "The learner didn't understand the original explanation. "
                "Explain the SAME concept differently: use a real-world analogy, "
                "break it into smaller steps, or give a concrete code example. "
                "Write in the same language as the original (detect it). "
                "Max 4 sentences + optional short code snippet. "
                "Do NOT repeat the original explanation word for word."
            }],
        )
        return msg.content[0].text.strip()
    except Exception:
        return ""


async def generate_solution_walkthrough(
    instructions: str, starter_code: str, solution: str, language: str
) -> str:
    """Explain the solution step by step — not just the answer, but WHY each part works."""
    client = _get_claude()
    if not client:
        return ""

    try:
        msg = await client.messages.create(
            model=MODEL, max_tokens=600,
            messages=[{"role": "user", "content":
                f"Language: {language}\nTask: {instructions[:400]}\n"
                f"Correct solution:\n```{language}\n{solution[:600]}\n```\n\n"
                "The learner tried multiple times and still can't solve it. "
                "Walk through the solution step by step. For each meaningful part:\n"
                "1. Quote that part of the code\n"
                "2. Explain in plain language WHY it works and what it does\n"
                "Write in the same language as the task description (German if German). "
                "Use numbered steps. Be encouraging. Max 5 steps."
            }],
        )
        return msg.content[0].text.strip()
    except Exception:
        return ""


async def generate_concept_refs(
    title: str, content_text: str, prog_language: str
) -> list:
    """Extract prerequisite concepts a learner must know before this lesson."""
    client = _get_claude()
    if not client:
        return []

    try:
        msg = await client.messages.create(
            model=MODEL, max_tokens=300,
            messages=[{"role": "user", "content":
                f"Lesson: \"{title}\" ({prog_language})\nContent: {content_text[:600]}\n\n"
                "List the prerequisite concepts a beginner MUST understand BEFORE this lesson. "
                "Only include concepts NOT explained in this lesson itself — things assumed as prior knowledge.\n"
                "Write in the SAME language as the content (German if German, English if English).\n"
                "Return ONLY a JSON array of objects (max 4), each with:\n"
                "- concept: short name (e.g. 'for-Schleifen', 'Variablen')\n"
                "- recap: one sentence reminder of what it is\n"
                "If no prerequisites are needed, return []."
            }],
        )
        raw = msg.content[0].text.strip()
        if "```" in raw:
            raw = raw.split("```json")[-1].split("```")[0].strip()
        result = json.loads(raw)
        if isinstance(result, list):
            return result[:4]
    except Exception:
        pass
    return []


async def get_contextual_hint(
    instructions: str, starter_code: str, user_code: str, hint_level: int, language: str
) -> str:
    """Generate a hint that reacts to what the user has actually typed so far."""
    client = _get_claude()
    if not client:
        return ""

    specificity = {
        1: "Give a gentle nudge — just point at WHAT to think about, not HOW. One sentence.",
        2: "Be more specific — mention the exact concept or method they should use. Two sentences max.",
        3: "Almost give the answer — describe the exact fix needed without writing the code. Two sentences.",
    }.get(hint_level, "Give a helpful hint.")

    try:
        msg = await client.messages.create(
            model=MODEL, max_tokens=150,
            messages=[{"role": "user", "content":
                f"Language: {language}\nTask: {instructions[:400]}\n"
                f"Starter code:\n```\n{starter_code[:300]}\n```\n"
                f"User's current code:\n```\n{user_code[:500]}\n```\n\n"
                f"The user is stuck. {specificity} "
                "Comment on what they have so far — acknowledge what's right, "
                "then point at the specific gap. Never reveal the full solution."
            }],
        )
        return msg.content[0].text.strip()
    except Exception:
        return ""


async def generate_recap_quiz(
    title: str, lesson_type: str, content: dict, prog_language: str
) -> list:
    """Generate 3 recap questions testing the core concepts of a lesson."""
    client = _get_claude()
    if not client:
        return []

    if lesson_type == "theory":
        summary = " ".join(
            s.get("content", "")[:200] for s in content.get("sections", [])[:3]
        )
    elif lesson_type == "quiz":
        summary = content.get("question", "") + " " + content.get("explanation", "")
    else:
        summary = content.get("instructions", "")[:400]

    if not summary.strip():
        return []

    try:
        msg = await client.messages.create(
            model=MODEL, max_tokens=600,
            messages=[{"role": "user", "content":
                f"Lesson: \"{title}\" ({prog_language})\nContent: {summary[:600]}\n\n"
                "Create exactly 3 short multiple-choice recap questions testing "
                "the core concepts. Each answerable in under 10 seconds. "
                "Write in the SAME language as the content (German if German, English if English).\n"
                "Return ONLY a JSON array of 3 objects, each with:\n"
                "- question (string)\n- options (array of 4 strings)\n"
                "- correct_index (0-3)\n- explanation (one sentence why correct)"
            }],
        )
        raw = msg.content[0].text.strip()
        if "```" in raw:
            raw = raw.split("```json")[-1].split("```")[0].strip()
        result = json.loads(raw)
        if isinstance(result, list) and len(result) == 3:
            return result
    except Exception:
        pass
    return []


async def generate_debug_error_context(starter_code: str, language: str) -> str:
    """Predict the realistic error output a user would see when running buggy starter code."""
    client = _get_claude()
    if not client:
        return ""

    try:
        msg = await client.messages.create(
            model=MODEL, max_tokens=200,
            messages=[{"role": "user", "content":
                f"Language: {language}\nBuggy code:\n```\n{starter_code[:600]}\n```\n\n"
                "This code has an intentional bug. Predict the EXACT error output "
                "a user would see when running it — including error type, message, "
                "and a realistic 2-3 line traceback/stack trace. "
                "Format exactly like real terminal output (Python traceback or JS console error). "
                "Do NOT explain the bug — just show the raw error output."
            }],
        )
        return msg.content[0].text.strip()
    except Exception:
        return ""
