import asyncio
import json
import os
import tempfile
from typing import Optional

VAPID_PUBLIC_KEY = os.getenv("VAPID_PUBLIC_KEY", "")
_VAPID_PRIVATE_KEY_PEM = os.getenv("VAPID_PRIVATE_KEY_PEM", "")
VAPID_CONTACT = os.getenv("VAPID_CONTACT", "mailto:admin@codequest.dev")
_vapid_key_file: Optional[str] = None


def _get_vapid_key_file() -> Optional[str]:
    """Write VAPID private key PEM to a temp file once, return path."""
    global _vapid_key_file
    if _vapid_key_file:
        return _vapid_key_file
    if not _VAPID_PRIVATE_KEY_PEM:
        return None
    pem = _VAPID_PRIVATE_KEY_PEM.replace('\\n', '\n')
    tmp = tempfile.NamedTemporaryFile(suffix='.pem', delete=False, mode='w')
    tmp.write(pem)
    tmp.close()
    _vapid_key_file = tmp.name
    return _vapid_key_file


async def send_push(subscription_json: dict, title: str, body: str, url: str = "/dashboard") -> bool:
    """Send a push notification. Returns True on success."""
    key_file = _get_vapid_key_file()
    if not key_file or not VAPID_PUBLIC_KEY:
        return False
    try:
        from pywebpush import webpush, WebPushException
        payload = json.dumps({"title": title, "body": body, "url": url})
        loop = asyncio.get_event_loop()
        await loop.run_in_executor(
            None,
            lambda: webpush(
                subscription_info=subscription_json,
                data=payload,
                vapid_private_key=key_file,
                vapid_claims={"sub": VAPID_CONTACT},
            )
        )
        return True
    except Exception:
        return False
