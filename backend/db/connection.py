import asyncpg
import json
import os
from contextlib import asynccontextmanager

_pool: asyncpg.Pool | None = None


async def _init_conn(conn: asyncpg.Connection) -> None:
    """Register JSON/JSONB codecs so JSONB columns decode to Python dicts."""
    await conn.set_type_codec("json",  encoder=json.dumps, decoder=json.loads, schema="pg_catalog")
    await conn.set_type_codec("jsonb", encoder=json.dumps, decoder=json.loads, schema="pg_catalog")


async def init_pool() -> None:
    global _pool
    dsn = os.getenv(
        "DATABASE_URL",
        "postgresql://codequest:codequest@localhost:5432/codequest",
    )
    _pool = await asyncpg.create_pool(dsn, min_size=2, max_size=10, init=_init_conn)


async def close_pool() -> None:
    if _pool:
        await _pool.close()


@asynccontextmanager
async def acquire():
    async with _pool.acquire() as conn:
        yield conn
