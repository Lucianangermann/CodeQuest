import anthropic
import json
import os
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
            f"Task: {instructions}\n\nCode:\n{user_code}\n\nError: {error}\n\n"
            "Explain what went wrong in 3-4 encouraging sentences. Guide toward the fix without giving it away."}],
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

def _stub_training_plan(goal: str, level: str, language: str) -> dict:
    lang = language.capitalize()
    return {
        "phases": [
            {
                "phase_number": 1,
                "title": "Phase 1 — Core Language Fundamentals",
                "duration_weeks": 6,
                "goal": f"Master {lang} fundamentals deeply enough to explain every concept without looking it up",
                "topics": [
                    {"name": f"{lang} Basics", "subtopics": ["Variables & Types", "Type coercion", "Scope", "Hoisting"], "depth": "master", "why_important": "Every interview starts here. You need to explain WHY, not just HOW.", "interview_relevance": "high"},
                    {"name": "Functions & Closures", "subtopics": ["Declaration vs Expression", "Arrow Functions", "Closures", "this keyword"], "depth": "master", "why_important": "Closures are a staple interview question that most juniors get wrong.", "interview_relevance": "high"},
                    {"name": "Array Methods", "subtopics": ["map", "filter", "reduce", "find", "some", "every"], "depth": "apply", "why_important": "You will use these every single day. Interviews often ask you to implement them.", "interview_relevance": "high"},
                    {"name": "Async Programming", "subtopics": ["Promises", "async/await", "Error handling", "Promise.all"], "depth": "apply", "why_important": "Every real app has async code. Understanding it is non-negotiable.", "interview_relevance": "high"},
                    {"name": "ES6+ Features", "subtopics": ["Destructuring", "Spread/Rest", "Template literals", "Modules"], "depth": "apply", "why_important": "Modern codebases use these constantly.", "interview_relevance": "medium"},
                ],
                "weekly_schedule": [
                    {"day": "Monday", "duration_minutes": 90, "activities": [
                        {"type": "theory", "title": f"Study {lang} Variables & Types", "description": "Read docs, take notes by hand", "resource": "MDN Web Docs", "priority": "must"},
                        {"type": "coding", "title": "Type coercion exercises", "description": "Write 10 examples predicting output before running", "resource": "Browser console", "priority": "must"},
                    ]},
                    {"day": "Tuesday", "duration_minutes": 90, "activities": [
                        {"type": "theory", "title": "Functions & Scope deep dive", "description": "Understand the call stack with a diagram", "resource": "JavaScript.info", "priority": "must"},
                        {"type": "coding", "title": "Write 5 closure examples", "description": "Counter, memoize, private variables — without AI", "resource": "Your editor", "priority": "must"},
                    ]},
                    {"day": "Wednesday", "duration_minutes": 90, "activities": [
                        {"type": "coding", "title": "Implement map, filter, reduce from scratch", "description": "Write your own versions. Do not use built-ins.", "resource": "Your editor", "priority": "must"},
                        {"type": "coding", "title": "LeetCode Easy: Two Sum + Valid Anagram", "description": "No hints. Time yourself.", "resource": "LeetCode", "priority": "must"},
                    ]},
                    {"day": "Thursday", "duration_minutes": 90, "activities": [
                        {"type": "theory", "title": "Promises & async/await", "description": "Understand microtask queue vs macrotask queue", "resource": "JavaScript.info", "priority": "must"},
                        {"type": "coding", "title": "Build a mini fetch wrapper", "description": "Handle loading, error, and success states", "resource": "Your editor", "priority": "must"},
                    ]},
                    {"day": "Friday", "duration_minutes": 60, "activities": [
                        {"type": "interview_prep", "title": "Explain concepts aloud", "description": "Record yourself explaining closures and async. Listen back.", "resource": "Your phone", "priority": "must"},
                        {"type": "review", "title": "Spaced repetition review", "description": "Review all notes from the week", "resource": "Handwritten notes", "priority": "must"},
                    ]},
                    {"day": "Saturday", "duration_minutes": 120, "activities": [
                        {"type": "project", "title": "Build milestone project", "description": "See milestone project below", "resource": "Your editor", "priority": "must"},
                    ]},
                    {"day": "Sunday", "duration_minutes": 30, "activities": [
                        {"type": "review", "title": "Weekly reflection", "description": "What did you understand deeply? What's still fuzzy? Plan next week.", "resource": "Journal", "priority": "must"},
                    ]},
                ],
                "milestone_project": {
                    "title": "Task Manager CLI",
                    "description": f"Build a command-line task manager in {lang} using closures for state, array methods for filtering/sorting, async file I/O for persistence, and proper error handling. Zero AI assistance.",
                    "skills_practiced": ["Closures", "Array methods", "Async/await", "Error handling", "Modules"],
                },
                "phase_complete_when": [
                    "You can explain closures with an example — without looking it up",
                    "You can write a Promise from scratch",
                    f"You can implement map() and reduce() by hand in {lang}",
                    "Your milestone project works without AI assistance",
                ],
            },
            {
                "phase_number": 2,
                "title": "Phase 2 — React & Frontend",
                "duration_weeks": 8,
                "goal": "Build production-quality React components and understand performance implications",
                "topics": [
                    {"name": "React Fundamentals", "subtopics": ["JSX", "Components", "Props", "State", "Controlled components"], "depth": "master", "why_important": "Foundation of everything. You need to understand the virtual DOM.", "interview_relevance": "high"},
                    {"name": "React Hooks", "subtopics": ["useState", "useEffect", "useContext", "useRef", "useMemo", "useCallback", "Custom hooks"], "depth": "master", "why_important": "Hooks ARE React. Interviewers WILL ask when to use useMemo vs useCallback.", "interview_relevance": "high"},
                    {"name": "Performance", "subtopics": ["When React re-renders", "memo", "useMemo", "useCallback", "Lazy loading"], "depth": "apply", "why_important": "Senior devs care deeply about this. Mentioning it impresses interviewers.", "interview_relevance": "high"},
                    {"name": "TypeScript with React", "subtopics": ["Interfaces", "Typed props", "Generic components", "Event types", "useState<T>"], "depth": "apply", "why_important": "90% of professional React is TypeScript. Non-negotiable for most companies.", "interview_relevance": "high"},
                ],
                "weekly_schedule": [
                    {"day": "Monday", "duration_minutes": 90, "activities": [
                        {"type": "theory", "title": "React mental model", "description": "Understand the virtual DOM diffing algorithm conceptually", "resource": "react.dev", "priority": "must"},
                        {"type": "coding", "title": "Build 3 components from memory", "description": "No copy-paste: Button, Card, Modal from scratch", "resource": "Your editor", "priority": "must"},
                    ]},
                    {"day": "Tuesday", "duration_minutes": 90, "activities": [
                        {"type": "theory", "title": "Hooks deep dive: useEffect", "description": "Cleanup functions, dependency arrays, infinite loops — understand all pitfalls", "resource": "react.dev hooks reference", "priority": "must"},
                        {"type": "coding", "title": "Build useDebounce custom hook", "description": "Implement from scratch, use in a search input", "resource": "Your editor", "priority": "must"},
                    ]},
                    {"day": "Wednesday", "duration_minutes": 90, "activities": [
                        {"type": "coding", "title": "Re-render bug exercise", "description": "Build a list with 1000 items with a re-render bug. Fix with useMemo/useCallback.", "resource": "React DevTools", "priority": "must"},
                        {"type": "interview_prep", "title": "Re-render scenarios", "description": "List every scenario that causes a re-render. Write them out without looking.", "resource": "Paper", "priority": "must"},
                    ]},
                    {"day": "Thursday", "duration_minutes": 90, "activities": [
                        {"type": "coding", "title": "Add TypeScript to existing components", "description": "Take plain JS components, fully type them. No 'any' allowed.", "resource": "TypeScript docs", "priority": "must"},
                        {"type": "coding", "title": "Controlled form with validation", "description": "Error states, submission handling, all typed", "resource": "Your editor", "priority": "must"},
                    ]},
                    {"day": "Friday", "duration_minutes": 60, "activities": [
                        {"type": "interview_prep", "title": "Architecture review", "description": "Draw your project's component tree on paper. Could you explain it in an interview?", "resource": "Paper", "priority": "must"},
                    ]},
                    {"day": "Saturday", "duration_minutes": 180, "activities": [
                        {"type": "project", "title": "Full CRUD App with Auth", "description": "Build a task/note app: signup/login (JWT), CRUD, search, loading/error states, TypeScript, deployed.", "resource": "Your editor", "priority": "must"},
                    ]},
                    {"day": "Sunday", "duration_minutes": 30, "activities": [
                        {"type": "review", "title": "Weekly reflection", "description": "What clicked? What still feels shaky?", "resource": "Journal", "priority": "must"},
                    ]},
                ],
                "milestone_project": {
                    "title": "Full-Stack CRUD App",
                    "description": "Build and deploy: signup/login (JWT), CRUD with a real database, responsive design, TypeScript throughout, no 'any' types, public URL.",
                    "skills_practiced": ["React hooks", "TypeScript", "API integration", "State management", "Deployment"],
                },
                "phase_complete_when": [
                    "You can explain the difference between useMemo and useCallback without hesitation",
                    "You can build a custom hook from scratch in an interview setting",
                    "Your project has zero TypeScript 'any' types",
                    "You can find and fix a re-render performance issue in 10 minutes",
                ],
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
    client = _get_claude()
    if not client:
        return _stub_training_plan(goal, level, language)

    progress_ctx = f" Adjustment: {progress_notes}" if progress_notes else ""
    prompt = f"""Create a 5-phase junior developer training plan. Be concise — keep each field short.

Profile: goal={goal}, timeline={timeline}, company={company_target or 'Any'}, level={level}, language={language}, focus={framework_focus or 'Fullstack'}{progress_ctx}

Phases: 1=Core Fundamentals, 2=React/Frontend, 3=Backend/APIs, 4=CS Basics, 5=Interview Prep

Return ONLY valid JSON, no markdown. Keep all strings short (under 80 chars). Max 4 topics per phase, max 3 subtopics each, max 2 activities per day, only 3 days (Mon/Wed/Fri):
{{
  "phases": [
    {{
      "phase_number": 1,
      "title": "Phase 1 — Core Fundamentals",
      "duration_weeks": 4,
      "goal": "one sentence goal",
      "topics": [
        {{"name": "Topic", "subtopics": ["a", "b"], "depth": "master", "why_important": "short reason", "interview_relevance": "high"}}
      ],
      "weekly_schedule": [
        {{"day": "Monday", "duration_minutes": 90, "activities": [{{"type": "theory", "title": "short title", "description": "short desc", "resource": "MDN/url", "priority": "must"}}]}},
        {{"day": "Wednesday", "duration_minutes": 90, "activities": [{{"type": "coding", "title": "short title", "description": "short desc", "resource": "url", "priority": "must"}}]}},
        {{"day": "Friday", "duration_minutes": 60, "activities": [{{"type": "review", "title": "short title", "description": "short desc", "resource": "url", "priority": "must"}}]}}
      ],
      "milestone_project": {{"title": "Project title", "description": "one sentence", "skills_practiced": ["skill1", "skill2"]}},
      "phase_complete_when": ["criterion 1", "criterion 2"]
    }}
  ],
  "interview_preparation": {{
    "startup": {{"topics": ["t1", "t2"], "typical_questions": ["q1", "q2", "q3"], "coding_challenges": ["c1", "c2"]}},
    "medium_company": {{"topics": ["t1", "t2"], "typical_questions": ["q1", "q2", "q3"], "coding_challenges": ["c1", "c2"]}},
    "large_company": {{"topics": ["t1", "t2"], "typical_questions": ["q1", "q2", "q3"], "coding_challenges": ["c1", "c2"]}}
  }},
  "portfolio_requirements": {{
    "minimum_projects": 3,
    "must_have_features": ["feature1", "feature2", "feature3"],
    "nice_to_have": ["nice1", "nice2"]
  }}
}}"""

    msg = await client.messages.create(
        model=MODEL, max_tokens=6000,
        messages=[{"role": "user", "content": prompt}],
    )
    return _parse_json(msg.content[0].text)


# ── Checklist Test Questions ──────────────────────────────────────────────────

def _stub_test_question(item_key: str) -> dict:
    return {
        "question": f"Explain '{item_key.replace('_', ' ')}' in your own words and give a concrete example.",
        "expected_answer": "A clear explanation with a practical example showing real understanding — not just a definition.",
    }


async def generate_test_question(item_key: str, item_label: str) -> dict:
    client = _get_claude()
    if not client:
        return _stub_test_question(item_key)

    prompt = (
        f"Generate a short interview-style test question for the skill: '{item_label}'.\n"
        "Return JSON only: "
        '{"question": "...", "expected_answer": "..."}\n'
        "The question should be answerable in 2-3 sentences. The expected_answer is a brief rubric showing what a good answer covers, not a full solution."
    )
    msg = await client.messages.create(
        model=MODEL, max_tokens=300,
        messages=[{"role": "user", "content": prompt}],
    )
    return _parse_json(msg.content[0].text)


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


def _stub_interview_message(question_number: int, focus: str) -> dict:
    questions = {
        1: f"Tell me about yourself and why you're interested in {focus} development.",
        2: "What's the difference between == and === in JavaScript?",
        3: "Explain what a closure is and give me a real-world use case.",
        4: "What happens when you type a URL in the browser and press Enter?",
        5: "Explain the difference between useMemo and useCallback in React.",
        6: "What is the N+1 problem in databases?",
        7: "How does JWT authentication work? Walk me through the full flow.",
        8: "What is Big-O notation? What's the complexity of finding an item in a HashMap?",
        9: "Tell me about the hardest bug you've ever debugged.",
        10: "Where do you see yourself in 2 years as a developer?",
    }
    return {
        "evaluation": "Good start." if question_number > 1 else None,
        "question": questions.get(question_number, "Tell me about your latest project."),
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
