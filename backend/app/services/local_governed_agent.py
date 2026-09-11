"""Compatibility adapter for the initial governed-agent contract."""

from app.models import AnswerPackage, QuestionIntent
from app.registry import ENTITY_ALIASES, METRICS
from hashlib import sha256


class GovernedAgent:
    def handle(self, question: str, persona: str = "general") -> AnswerPackage:
        trace_id = sha256(f"{persona}:{question}".encode()).hexdigest()[:16]
        lowered = question.lower()
        if "health score" in lowered:
            return AnswerPackage("REFUSE", trace_id, "Metric not defined", "Supplier health score is not defined in the governed metric registry. Choose OTD, OTIF, supplier risk, ESG, or spend concentration.")
        metric_id = "unit_fill_rate" if "fill" in lowered else "doi_forward_forecast" if "inventory" in lowered or "days of" in lowered else "otd_original_commit" if "on-time" in lowered or "otd" in lowered else None
        if metric_id is None:
            return AnswerPackage("CLARIFY", trace_id, "Choose a governed metric", "Select a registered supply-chain metric.", alternatives=METRICS["otd_original_commit"]["alternatives"])
        period = next((token for token in question.split() if token.upper().startswith("Q") and len(token) >= 2), None)
        if not period:
            return AnswerPackage("CLARIFY", trace_id, "Period required", "Which reporting period should I use? Example: Q1 2026.", metric_id=metric_id)
        aliases = [alias for alias in ENTITY_ALIASES if alias in lowered]
        evidence = [{"phrase": alias, "canonical_id": ENTITY_ALIASES[alias]} for alias in aliases]
        metric = METRICS[metric_id]
        return AnswerPackage("EXECUTE", trace_id, metric["name"], "Governed query plan is ready for execution.", metric_id=metric_id, definition=metric["definition"], sql=f"-- trace_id={trace_id}\nSELECT * FROM {metric['sql_view']} WHERE period = '{period}'", join_path=["SUPPLIER", "PURCHASE_ORDER", "PURCHASE_ORDER_LINE", "SHIPMENT_EVENT"], evidence=evidence, assumptions=[f"Persona: {persona}", f"Period: {period}", f"Grain: {metric['grain']}"], validation={"status": "PENDING_SNOWFLAKE_EXECUTION", "raw_table_access": False})
