"""Repository boundary for PostgreSQL governance metadata."""

from app.registry import METRICS


class MetricRepository:
    def get(self, metric_id: str) -> dict | None:
        return METRICS.get(metric_id)
