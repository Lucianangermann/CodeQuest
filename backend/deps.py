from fastapi import HTTPException, Security
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from jose import jwt, JWTError
from typing import Optional
import os

SECRET = os.getenv("JWT_SECRET", "dev-secret-change-in-production")
ALGO = "HS256"
_bearer = HTTPBearer(auto_error=False)


def get_current_user(creds: Optional[HTTPAuthorizationCredentials] = Security(_bearer)) -> str:
    if not creds:
        raise HTTPException(status_code=401, detail="Not authenticated")
    try:
        payload = jwt.decode(creds.credentials, SECRET, algorithms=[ALGO])
        user_id = payload.get("sub")
        if not user_id:
            raise HTTPException(status_code=401, detail="Invalid token payload")
        return user_id
    except JWTError:
        raise HTTPException(status_code=401, detail="Invalid or expired token")


def get_optional_user(creds: Optional[HTTPAuthorizationCredentials] = Security(_bearer)) -> Optional[str]:
    if not creds:
        return None
    try:
        payload = jwt.decode(creds.credentials, SECRET, algorithms=[ALGO])
        return payload.get("sub")
    except JWTError:
        return None
