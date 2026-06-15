import httpx
import asyncio
import os

JUDGE0_URL = os.getenv("JUDGE0_API_URL", "https://judge0-ce.p.rapidapi.com")
JUDGE0_KEY = os.getenv("JUDGE0_API_KEY", "")

LANGUAGE_IDS = {
    "python": 71,
    "javascript": 63,
    "typescript": 74,
    "java": 62,
    "cpp": 54,
    "c": 50,
    "go": 60,
    "rust": 73,
    "ruby": 72,
}


async def execute_code(code: str, language: str = "python", stdin: str = "") -> dict:
    lang_id = LANGUAGE_IDS.get(language.lower(), 71)

    headers = {
        "X-RapidAPI-Host": "judge0-ce.p.rapidapi.com",
        "X-RapidAPI-Key": JUDGE0_KEY,
        "Content-Type": "application/json",
    }

    payload = {
        "source_code": code,
        "language_id": lang_id,
        "stdin": stdin,
    }

    async with httpx.AsyncClient(timeout=30.0) as client:
        response = await client.post(
            f"{JUDGE0_URL}/submissions?base64_encoded=false&wait=false",
            json=payload,
            headers=headers,
        )
        response.raise_for_status()
        token = response.json()["token"]

        for _ in range(15):
            await asyncio.sleep(1)
            result = await client.get(
                f"{JUDGE0_URL}/submissions/{token}?base64_encoded=false",
                headers=headers,
            )
            result.raise_for_status()
            data = result.json()

            if data["status"]["id"] > 2:  # Done (not In Queue or Processing)
                stderr = data.get("stderr") or ""
                compile_err = data.get("compile_output") or ""
                error = stderr or compile_err

                return {
                    "output": data.get("stdout") or "",
                    "error": error,
                    "status": data["status"]["description"],
                    "time": data.get("time"),
                    "memory": data.get("memory"),
                    "exit_code": data.get("exit_code"),
                }

    return {
        "output": "",
        "error": "Execution timed out",
        "status": "Time Limit Exceeded",
    }
