"""Snowflake execution adapter for approved query plans only."""

import json
from uuid import uuid4

from app.core.config import settings


class SnowflakeExecutor:
    def __init__(self) -> None:
        self.enabled = bool(settings.snowflake_account and settings.snowflake_user and settings.snowflake_warehouse)

    def execute(self, answer: object, persona: str) -> dict:
        if not self.enabled:
            return {
                "query_plan_id": None,
                "validation": {"status": "LOCAL_DRY_RUN", "raw_table_access": False},
            }

        try:
            import snowflake.connector
        except ImportError as error:
            raise RuntimeError("snowflake-connector-python is required for Snowflake execution") from error

        query_plan_id = str(uuid4())
        plan = {
            "metric_id": answer.metric_id,
            "semantic_view": self._semantic_view(answer.sql),
            "persona": persona,
            "join_path": answer.join_path,
            "assumptions": answer.assumptions,
        }
        connection = snowflake.connector.connect(
            account=settings.snowflake_account,
            user=settings.snowflake_user,
            authenticator=settings.snowflake_authenticator,
            role=settings.snowflake_role,
            warehouse=settings.snowflake_warehouse,
            database=settings.snowflake_database,
            schema=settings.snowflake_schema,
        )
        try:
            with connection.cursor() as cursor:
                cursor.execute(
                    """
                    INSERT INTO AGENT.QUERY_PLAN
                        (query_plan_id, trace_id, metric_id, semantic_view,
                         approved_join_path_id, plan_json, decision_status)
                    SELECT %s, %s, %s, %s, NULL, PARSE_JSON(%s), 'EXECUTE'
                    """,
                    (query_plan_id, answer.trace_id, answer.metric_id, plan["semantic_view"], json.dumps(plan)),
                )
                cursor.execute("CALL AGENT.EXECUTE_GOVERNED_QUERY(%s)", (query_plan_id,))
                result = cursor.fetchone()[0]
                if isinstance(result, str):
                    result = json.loads(result)
                return {"query_plan_id": query_plan_id, **result}
        finally:
            connection.close()

    @staticmethod
    def _semantic_view(sql: str | None) -> str:
        if "SUPPLIER_PERFORMANCE" in (sql or ""):
            return "SEMANTIC.SUPPLIER_PERFORMANCE"
        if "ORDER_FULFILLMENT" in (sql or ""):
            return "SEMANTIC.ORDER_FULFILLMENT"
        if "INVENTORY_COVERAGE" in (sql or ""):
            return "SEMANTIC.INVENTORY_COVERAGE"
        raise ValueError("Query plan does not reference an approved semantic view")