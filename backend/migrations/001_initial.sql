-- PostgreSQL application metadata store.
-- Analytics facts and governed semantic execution remain in Snowflake.

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS metric_registry (
    metric_id TEXT NOT NULL,
    version INTEGER NOT NULL DEFAULT 1,
    metric_name TEXT NOT NULL,
    definition TEXT NOT NULL,
    grain TEXT NOT NULL,
    semantic_view TEXT NOT NULL,
    date_policy TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'ACTIVE',
    steward TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (metric_id, version)
);

CREATE TABLE IF NOT EXISTS entity_identifier_map (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    canonical_entity_type TEXT NOT NULL,
    canonical_entity_id TEXT NOT NULL,
    source_system TEXT NOT NULL,
    source_identifier TEXT NOT NULL,
    match_method TEXT NOT NULL,
    match_confidence NUMERIC(5,4) NOT NULL CHECK (match_confidence BETWEEN 0 AND 1),
    approval_status TEXT NOT NULL DEFAULT 'PENDING',
    approved_by TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (canonical_entity_type, source_system, source_identifier)
);

CREATE TABLE IF NOT EXISTS conversation_trace (
    trace_id TEXT PRIMARY KEY,
    question TEXT NOT NULL,
    persona TEXT NOT NULL,
    decision_status TEXT NOT NULL CHECK (decision_status IN ('EXECUTE', 'CLARIFY', 'REFUSE')),
    metric_id TEXT,
    plan JSONB,
    answer JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_entity_identifier_lookup
    ON entity_identifier_map (canonical_entity_type, source_identifier);
CREATE INDEX IF NOT EXISTS idx_trace_created_at
    ON conversation_trace (created_at DESC);
