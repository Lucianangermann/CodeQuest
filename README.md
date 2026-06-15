# CodeQuest

A Duolingo-style platform for learning programming, with interactive lessons, AI tutoring, code execution, and gamification.

## Tech Stack

| Layer | Tech |
|---|---|
| Frontend | React 18 + TypeScript + Vite + Tailwind CSS + Zustand |
| Backend | FastAPI + Python 3.11+ + asyncpg |
| Database | PostgreSQL 16 (runs locally in Docker) |
| Code Execution | Local subprocess (python3 / node — no external API) |
| AI | Claude API — `claude-3-haiku-20240307` (optional) |
| Editor | Monaco Editor |

---

## Quick Start

**Prerequisites:** [Docker Desktop](https://docker.com/get-started)

```bash
git clone <repo-url>
cd codequest
docker compose up
```

Open `http://localhost:5173`. That's it.

- The database schema and seed data are applied automatically on first boot.
- Code execution works out of the box (Python + JavaScript run locally).
- AI tutor (hints, chat) works if you add `ANTHROPIC_API_KEY` to a `.env` file.

---

## AI Tutor (optional)

To enable hints, explanations, and the AI chat:

```bash
echo "ANTHROPIC_API_KEY=sk-ant-..." > .env
docker compose up
```

Or run the interactive setup wizard:

```bash
python3 setup.py   # asks for your key, writes .env, then starts docker compose
```

Without the key, everything else works normally — the AI features show a "not configured" message.

---

## Make Commands

```
make dev            Start backend + frontend without Docker (for local dev)
make backend        Start only the FastAPI backend
make frontend       Start only the Vite frontend
make install        Install Python + Node dependencies
make docker-up      docker compose up --build
make docker-down    docker compose down
make clean          Remove caches and build artifacts
```

---

## Project Structure

```
codequest/
├── setup.py                              # Optional setup wizard (Anthropic key + docker compose up)
├── Makefile
├── docker-compose.yml                    # PostgreSQL + backend + frontend
│
├── supabase/
│   ├── migrations/001_initial.sql        # Schema (auto-applied by Docker on first boot)
│   └── seed.sql                          # Topics, lessons, badges (auto-applied on first boot)
│
├── backend/
│   ├── main.py                           # FastAPI app
│   ├── deps.py                           # JWT auth dependency
│   ├── requirements.txt
│   ├── Dockerfile
│   ├── db/connection.py                  # asyncpg pool
│   ├── models/schemas.py                 # Pydantic models
│   ├── routes/
│   │   ├── auth.py                       # POST /auth/signup, /auth/login
│   │   ├── topics.py                     # GET /topics, GET /topics/{id}/lessons
│   │   ├── lessons.py                    # GET /lessons/{id}, POST /lessons/{id}/submit
│   │   ├── ai.py                         # POST /ai/hint, /ai/explain, /ai/chat
│   │   ├── leaderboard.py                # GET /leaderboard/
│   │   └── user.py                       # GET /user/dashboard, profile, streak
│   └── services/
│       ├── code_runner.py                # Local code execution (python3, node)
│       └── claude.py                     # AI hints, explanations, chat
│
└── frontend/
    ├── Dockerfile
    └── src/
        ├── pages/                        # Auth, Dashboard, Roadmap, Lesson, Leaderboard, Profile
        ├── components/                   # Editor, AIChat, HintSystem, Heatmap, BadgeCard, ...
        ├── store/                        # useUserStore (Zustand + JWT)
        ├── lib/                          # auth.ts, api.ts
        └── types/index.ts
```

---

## Features

- **Auth**: Email/password signup + login (JWT, no external service)
- **Roadmap**: Visual topic tree with sequential unlocking
- **Lessons**: Theory (Markdown), multiple-choice quiz, code execution via local subprocess
- **Hints**: 3-level progressive hint system (backed by Claude if configured)
- **AI Tutor**: Floating chat powered by Claude Haiku (optional)
- **XP & Levels**: 10 XP per lesson, XP / 100 = level
- **Streaks**: Daily tracking with automatic reset after 24h gap
- **Badges**: 8 achievement badges auto-awarded on criteria
- **Leaderboard**: Weekly XP ranking (all users)
- **Activity Heatmap**: GitHub-style 90-day activity grid
- **Dark mode** (default) with light mode toggle

---

## API Reference

| Method | Endpoint | Description |
|---|---|---|
| POST | `/auth/signup` | Create account |
| POST | `/auth/login` | Log in, get JWT |
| GET | `/topics/` | All topics with user progress |
| GET | `/topics/{id}/lessons` | Lessons for a topic |
| GET | `/lessons/{id}` | Single lesson |
| POST | `/lessons/{id}/submit` | Submit quiz answer or code |
| POST | `/ai/hint` | Get progressive hint (level 1–3) |
| POST | `/ai/explain` | Explain why answer was wrong |
| POST | `/ai/chat` | AI tutor chat |
| GET | `/user/dashboard` | Dashboard stats |
| POST | `/user/streak` | Update daily streak |
| GET | `/user/profile` | Full profile + badges |
| PATCH | `/user/profile` | Update username, language, daily goal |
| GET | `/leaderboard/` | Weekly XP ranking |
| GET | `/health` | Health check |

---

## Environment Variables

All optional. Set in a `.env` file at the project root.

| Variable | Default | Description |
|---|---|---|
| `ANTHROPIC_API_KEY` | *(unset)* | Enables AI tutor — get one at console.anthropic.com |
| `JWT_SECRET` | `dev-secret-change-in-production` | Change this for production |
