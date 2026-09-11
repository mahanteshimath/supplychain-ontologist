"""Environment-backed application settings for Supabase and Snowflake."""

import os
from dataclasses import dataclass

from dotenv import load_dotenv

load_dotenv()


@dataclass(frozen=True)
class Settings:
    app_env: str = os.getenv("APP_ENV", "local")
    database_mode: str = os.getenv("DATABASE_MODE", "supabase")
    database_url: str = os.getenv("SUPABASE_DB_URL", "")
    supabase_url: str = os.getenv("SUPABASE_URL", "")
    supabase_anon_key: str = os.getenv("SUPABASE_ANON_KEY", "")
    supabase_service_role_key: str = os.getenv("SUPABASE_SERVICE_ROLE_KEY", "")
    snowflake_account: str = os.getenv("SNOWFLAKE_ACCOUNT", "")
    snowflake_user: str = os.getenv("SNOWFLAKE_USER", "")
    snowflake_authenticator: str = os.getenv("SNOWFLAKE_AUTHENTICATOR", "externalbrowser")
    snowflake_role: str = os.getenv("SNOWFLAKE_ROLE", "ROLE_APPLICATION")
    snowflake_warehouse: str = os.getenv("SNOWFLAKE_WAREHOUSE", "")
    snowflake_database: str = os.getenv("SNOWFLAKE_DATABASE", "SUPPLY_CHAIN_ONTOLOGY")
    snowflake_schema: str = os.getenv("SNOWFLAKE_SCHEMA", "SEMANTIC")
    cors_origins: tuple[str, ...] = tuple(filter(None, os.getenv("CORS_ORIGINS", "http://localhost:5173").split(",")))


settings = Settings()
