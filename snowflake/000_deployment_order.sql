-- Arbiter Snowflake deployment order.
-- Run this file as ACCOUNTADMIN or a deployment role with database, schema,
-- table, view, procedure, role, and grant privileges.
-- Do not run this as ROLE_APPLICATION.

-- 1. Create the database, schemas, and governance/agent/audit tables.
-- Run: 001_database.sql

-- 2. Create the application roles and least-privilege grants.
-- Run: 003_roles.sql

-- 3. Create canonical CORE table contracts.
-- Run: 004_core_contract.sql

-- 4. Load RAW_* and STG_* data, then populate CORE tables.
-- Source registry: DATA_MANIFEST.md

-- 5. Seed the initial governed metric and entity mappings.
-- Run: 002_seed_governance.sql

-- 6. Create secure semantic views for Cortex Analyst and the application.
-- Run: 005_semantic_views.sql

-- 7. Create the controlled execution procedure.
-- Run: 006_execution_procedure.sql

-- Optional verification after all scripts complete:
USE DATABASE SUPPLY_CHAIN_ONTOLOGY;

SHOW SCHEMAS IN DATABASE SUPPLY_CHAIN_ONTOLOGY;

SHOW TABLES IN SCHEMA SUPPLY_CHAIN_ONTOLOGY.GOVERNANCE;

SHOW VIEWS IN SCHEMA SUPPLY_CHAIN_ONTOLOGY.SEMANTIC;

SHOW PROCEDURES IN SCHEMA SUPPLY_CHAIN_ONTOLOGY.AGENT;

SELECT metric_id, metric_name, status, version
FROM GOVERNANCE.METRIC_REGISTRY
ORDER BY metric_id;