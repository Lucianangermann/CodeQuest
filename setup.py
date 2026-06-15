#!/usr/bin/env python3
"""
CodeQuest — one-time setup (optional)

The only thing this script does is write your ANTHROPIC_API_KEY to a .env file
so that the AI tutor works. Everything else (database, backend, frontend) starts
automatically via Docker Compose.

Usage:
  python3 setup.py
  docker compose up
"""
import getpass
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).parent
G = "\033[92m"; Y = "\033[93m"; B = "\033[94m"; W = "\033[1m"; X = "\033[0m"


def main():
    print(f"""
{W}╔══════════════════════════════════════════╗
║   🚀  CodeQuest — Quick Setup            ║
╚══════════════════════════════════════════╝{X}

CodeQuest runs {W}completely locally{X} using Docker.
No Supabase account, no Judge0 key needed.

The only optional step: add an Anthropic key to enable
the AI tutor (hints, explanations, chat).
""")

    env_file = ROOT / ".env"
    existing_key = ""
    if env_file.exists():
        for line in env_file.read_text().splitlines():
            if line.startswith("ANTHROPIC_API_KEY="):
                existing_key = line.split("=", 1)[1].strip()

    print(f"{B}Anthropic API key{X}  →  https://console.anthropic.com")
    if existing_key:
        print(f"  Current: {existing_key[:12]}...")
    else:
        print("  Leave blank to skip (AI features show a friendly 'not configured' message)")

    key = getpass.getpass("  Key (sk-ant-... or Enter to skip): ").strip()
    if not key and existing_key:
        key = existing_key

    lines = []
    if key:
        lines.append(f"ANTHROPIC_API_KEY={key}")
    lines.append("# JWT_SECRET=change-me-in-production")
    env_file.write_text("\n".join(lines) + "\n")

    if key:
        print(f"\n{G}✅  .env written with ANTHROPIC_API_KEY{X}")
    else:
        print(f"\n{Y}⚠️   No key set — AI tutor will be disabled{X}")

    print("\nChecking Docker...")
    try:
        res = subprocess.run(["docker", "info"], capture_output=True, timeout=10)
        if res.returncode == 0:
            print(f"{G}✅  Docker is running{X}")
        else:
            print(f"{Y}⚠️   Docker doesn't seem to be running. Start Docker Desktop first.{X}")
            sys.exit(1)
    except FileNotFoundError:
        print(f"{Y}⚠️   Docker not found. Install Docker Desktop: https://docker.com/get-started{X}")
        sys.exit(1)

    print(f"""
{G}{W}╔══════════════════════════════════════════╗
║   ✅  Ready!                              ║
╚══════════════════════════════════════════╝{X}

  {W}docker compose up{X}

  • PostgreSQL, backend, and frontend all start automatically
  • Schema + seed data applied on first boot
  • App:      http://localhost:5173
  • API docs: http://localhost:8000/docs
""")

    start = input("Start now? [Y/n]: ").strip().lower()
    if start in ("", "y", "yes"):
        subprocess.run(["docker", "compose", "up", "--build"], cwd=ROOT)


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n\nCancelled.")
