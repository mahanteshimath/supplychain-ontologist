"""Agent orchestration boundary.

Specialist agents will be split into modules as the workflow grows. This first
orchestrator keeps the decision order explicit and delegates business contracts
to the existing governed agent implementation.
"""

from app.agents.governed_agent import GovernedAgent
from app.services.snowflake_executor import SnowflakeExecutor


class GovernedOrchestrator:
    def __init__(self) -> None:
        self.agent = GovernedAgent()
        self.executor = SnowflakeExecutor()

    def handle(self, question: str, persona: str) -> dict:
        answer = self.agent.handle(question, persona)
        if answer.status == "EXECUTE":
            execution = self.executor.execute(answer, persona)
            answer.validation = execution.get("validation", answer.validation)
            answer.query_plan_id = execution.get("query_plan_id")
            if execution.get("status") == "EXECUTE":
                answer.result = execution.get("result")
                answer.message = "Governed query executed and validated."
        return answer.__dict__
