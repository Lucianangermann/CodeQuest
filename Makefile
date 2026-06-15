.DEFAULT_GOAL := help

# ── Setup ─────────────────────────────────────────────────────────────────────

setup: ## Interactive setup wizard (creates .env files, validates keys)
	python3 setup.py

install: ## Install all dependencies without the wizard
	cd backend && pip install -r requirements.txt
	cd frontend && npm install

# ── Development ───────────────────────────────────────────────────────────────

dev: ## Start backend + frontend together (Ctrl-C to stop both)
	@echo "Starting CodeQuest..."
	@echo "  Backend  → http://localhost:8000"
	@echo "  Frontend → http://localhost:5173"
	@echo "  API docs → http://localhost:8000/docs"
	@echo ""
	@trap 'kill 0' INT EXIT; \
		(cd backend  && uvicorn main:app --reload --port 8000 --log-level warning 2>&1 | sed 's/^/\033[36m[api]\033[0m /') & \
		(cd frontend && npm run dev 2>&1 | sed 's/^/\033[35m[ui]\033[0m  /') ; \
		wait

backend: ## Start only the FastAPI backend
	cd backend && uvicorn main:app --reload --port 8000

frontend: ## Start only the Vite frontend
	cd frontend && npm run dev

# ── Database ──────────────────────────────────────────────────────────────────

migrate: ## Reset and re-apply schema + seed (destroys all data!)
	docker compose exec postgres psql -U codequest -d codequest \
		-f /docker-entrypoint-initdb.d/01_schema.sql \
		-f /docker-entrypoint-initdb.d/02_seed.sql

# ── Docker ────────────────────────────────────────────────────────────────────

docker-up: ## Start with Docker Compose
	docker compose up --build

docker-down: ## Stop Docker containers
	docker compose down

# ── Utilities ─────────────────────────────────────────────────────────────────

lint-backend: ## Run ruff linter on backend
	cd backend && python -m ruff check . || true

type-check-frontend: ## Run TypeScript type checker
	cd frontend && npx tsc --noEmit

clean: ## Remove caches and build artifacts
	find backend -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	rm -rf frontend/dist frontend/.vite 2>/dev/null || true

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
