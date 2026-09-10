"""HTTP routes for the conversational analytics API."""

from fastapi import APIRouter

from app.agents.orchestrator import GovernedOrchestrator
from app.schemas.chat import AnswerResponse, AskRequest

router = APIRouter(tags=["conversation"])
orchestrator = GovernedOrchestrator()


@router.post("/ask", response_model=AnswerResponse)
def ask(request: AskRequest) -> AnswerResponse:
    answer = orchestrator.handle(request.question, request.persona)
    return AnswerResponse(**answer)
