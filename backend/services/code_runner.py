import asyncio

LANGUAGE_CMDS: dict[str, list[str]] = {
    "python":     ["python3", "-c"],
    "javascript": ["node",    "-e"],
    "typescript": ["ts-node", "--skip-project", "--compiler-options", '{"module":"commonjs"}', "-e"],
}


async def execute_code(code: str, language: str = "python", stdin: str = "") -> dict:
    cmd = LANGUAGE_CMDS.get(language.lower())
    if not cmd:
        return {
            "output": "",
            "error": f"Language '{language}' not supported locally. Use: python, javascript, typescript.",
            "status": "Error",
        }

    try:
        proc = await asyncio.create_subprocess_exec(
            *cmd, code,
            stdin=asyncio.subprocess.PIPE if stdin else asyncio.subprocess.DEVNULL,
            stdout=asyncio.subprocess.PIPE,
            stderr=asyncio.subprocess.PIPE,
        )
        try:
            stdout, stderr = await asyncio.wait_for(
                proc.communicate(input=stdin.encode() if stdin else None),
                timeout=5.0,
            )
        except asyncio.TimeoutError:
            proc.kill()
            await proc.wait()
            return {"output": "", "error": "Time limit exceeded (5 s)", "status": "Time Limit Exceeded"}

        return {
            "output": stdout.decode("utf-8", errors="replace"),
            "error": stderr.decode("utf-8", errors="replace"),
            "status": "Accepted" if proc.returncode == 0 else "Runtime Error",
        }

    except FileNotFoundError:
        runtime = cmd[0]
        return {
            "output": "",
            "error": f"Runtime '{runtime}' not found. Install it and make sure it's on PATH.",
            "status": "Error",
        }
