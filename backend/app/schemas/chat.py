"""API request and response schemas."""

from typing import Any, Literal
from pydantic import BaseModel, Field


class AskRequest(BaseModel):
    question: str = Field(min_length=1, max_length=4000)
    persona: str = Field(default="general", max_length=40)


class AnswerResponse(BaseModel):
    status: Literal["EXECUTE", "CLARIFY", "REFUSE"]
    trace_id: str
    title: str
    message: str
    metric_id: str | None = None
    definition: str | None = None
    result: Any = None
    sql: str | None = None
    join_path: list[str] = Field(default_factory=list)
    evidence: list[dict[str, Any]] = Field(default_factory=list)
    assumptions: list[str] = Field(default_factory=list)
    alternatives: list[dict[str, str]] = Field(default_factory=list)
    validation: dict[str, Any] = Field(default_factory=dict)
    query_plan_id: str | None = None
