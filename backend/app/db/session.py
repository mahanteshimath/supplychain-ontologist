"""Supabase PostgreSQL session boundary."""

from app.core.config import settings


def database_url() -> str:
    if not settings.database_url:
        raise RuntimeError("SUPABASE_DB_URL is required to connect to Supabase PostgreSQL")
    return settings.database_url
