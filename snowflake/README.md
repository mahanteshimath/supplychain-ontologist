# Snowflake deployment order

Run these scripts in order after connecting with a deployment role. The
`000_deployment_order.sql` file is a checklist and verification script; execute
the numbered files it references in the shown order.

```text
000_account_setup.sql
000_deployment_order.sql
001_database.sql
003_roles.sql
004_core_contract.sql
002_seed_governance.sql
005_semantic_views.sql
006_execution_procedure.sql
```

Run the setup as `ACCOUNTADMIN` or a dedicated deployment role. The application
must use `ROLE_APPLICATION`, not `ACCOUNTADMIN`.

`004_core_contract.sql` defines the canonical target tables. Source-specific loaders and transformations must populate them from the six source families in `DATA_MANIFEST.md`.

`005_semantic_views.sql` creates the governed read surface for Cortex Analyst and the application. Do not grant the app role access to `RAW_*`, `STG_*`, or unrestricted `CORE` tables.

`006_execution_procedure.sql` is a fixed-template implementation. It refuses arbitrary SQL, validates the active metric registry, executes only the approved seeded metric branches, and grants `ROLE_APPLICATION` usage on the procedure after creation.
