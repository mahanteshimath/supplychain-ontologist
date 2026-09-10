from dataclasses import dataclass, field
from typing import Any, Literal

DecisionStatus = Literal["EXECUTE", "CLARIFY", "REFUSE"]

@dataclass
class QuestionIntent:
    question: str
    metric_phrase: str | None = None
    entities: list[str] = field(default_factory=list)
    period: str | None = None
    persona: str = "general"

@dataclass
class AnswerPackage:
    status: DecisionStatus
    trace_id: str
    title: str
    message: str
    metric_id: str | None = None
    definition: str | None = None
    result: Any = None
    sql: str | None = None
    join_path: list[str] = field(default_factory=list)
    evidence: list[dict[str, Any]] = field(default_factory=list)
    assumptions: list[str] = field(default_factory=list)
    alternatives: list[dict[str, str]] = field(default_factory=list)
    validation: dict[str, Any] = field(default_factory=dict)
    query_plan_id: str | None = None
