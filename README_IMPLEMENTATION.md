# Implementation Guide

This is the first runnable vertical slice for Arbiter. The primary application stack is React, FastAPI, PostgreSQL, and Snowflake.

## Components

```text
frontend/                 React + Vite + TypeScript UI
frontend/src/api.ts       Typed API client
frontend/src/App.tsx      Conversational workspace
frontend/src/styles.css   Product interface styles
backend/app/main.py      FastAPI application
backend/app/api/          HTTP routes
backend/app/schemas/      Pydantic request/response contracts
backend/app/agents/       Agent orchestration boundary
backend/app/services/     Governed agent and domain services
backend/app/repositories/ PostgreSQL repository boundary
backend/app/db/           Database session boundary
backend/migrations/       PostgreSQL schema migrations
snowflake/                Analytics database, governance, and semantic SQL
tests/                    Agent contract tests
```

## Local setup

The repository expects Python 3.11+, Node.js 20+, npm, and a Supabase project. Supabase provides the hosted PostgreSQL database; a local PostgreSQL container is not required.

```powershell
cd backend
py -m venv .venv
.\.venv\Scripts\Activate.ps1
py -m pip install -r requirements.txt
Copy-Item .env.example .env
cd ..
```

Start the FastAPI backend:

```powershell
$env:PYTHONPATH = "$PWD/backend"
uvicorn app.main:app --reload --port 8000
```

Run the backend tests:

```powershell
py -m pytest
```

Install and start the React frontend in a second terminal:

```powershell
cd frontend
npm install
npm run dev
```

Open `http://localhost:5173`.

The local frontend configuration is in `frontend/.env` and points to `http://localhost:8000` by default.

The API endpoints are:

```text
GET  http://localhost:8000/health
POST http://localhost:8000/api/ask
```

Example request:

```json
{
  "question": "What was Acme on-time delivery in Q1 2026?",
  "persona": "procurement"
}
```

The maintained frontend is `frontend/src`. Streamlit is not part of the application runtime; Snowflake is the governed analytics platform behind the FastAPI service.

## Supabase setup

1. Create a project at [supabase.com](https://supabase.com/).
2. Open **Project Settings -> Database -> Connection string**.
3. Select the **Transaction pooler** connection for the FastAPI application.
4. Copy the connection string into `SUPABASE_DB_URL` in `backend/.env`.
5. Replace the password placeholder with the database password from the Supabase project.
6. Run `backend/migrations/001_initial.sql` in the Supabase SQL Editor.
7. Add the project URL to `SUPABASE_URL`.
8. Add the publishable/anon key to `SUPABASE_ANON_KEY` only if frontend Supabase APIs are enabled.
9. Keep `SUPABASE_SERVICE_ROLE_KEY` backend-only and never expose it to React.

Supabase database URLs are PostgreSQL URLs and use the existing `psycopg` driver. URL-encode special characters in the database password.

## Configuration handoff

You can provide the exact deployment values for:

- Supabase project URL, database pooler URL, and database password
- Snowflake account, user or key-pair authentication, role, warehouse, database, schema, and network policy
- Frontend API origin and deployment URL
- CORS origins and environment name

Put local values in `backend/.env` and `frontend/.env`; do not commit those files. The FastAPI backend loads `backend/.env` automatically through `python-dotenv`.

## Snowflake setup

1. Create a Snowflake connection using `backend/.env.example`.
2. Run `snowflake/001_database.sql`.
3. Load source files into the `RAW_*` schemas using `DATA_MANIFEST.md`.
4. Add source-specific `STG_*` transformations.
5. Build `CORE` canonical entities and facts.
6. Run `snowflake/002_seed_governance.sql`.
7. Create semantic views with `snowflake/005_semantic_views.sql`.
8. Apply `snowflake/003_roles.sql` after reviewing account policies.
9. Replace the local registry execution with `AGENT.EXECUTE_GOVERNED_QUERY`.

The local agent deliberately returns a query plan rather than a fake numeric result. Numeric execution belongs in Snowflake after semantic views and validation SQL are deployed.
