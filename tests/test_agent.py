from app.agents.governed_agent import GovernedAgent


def test_governed_otd_plan_resolves_acme():
    answer = GovernedAgent().handle("What was Acme on-time delivery in Q1 2026?", "procurement")
    assert answer.status == "EXECUTE"
    assert answer.metric_id == "otd_original_commit"
    assert answer.evidence[0]["canonical_id"] == "SUP-ACME-001"
    assert answer.validation["raw_table_access"] is False


def test_undefined_metric_is_refused():
    answer = GovernedAgent().handle("What is our supplier health score?", "planning")
    assert answer.status == "REFUSE"


def test_missing_period_clarifies():
    answer = GovernedAgent().handle("What was Acme on-time delivery?", "logistics")
    assert answer.status == "CLARIFY"
    assert answer.metric_id == "otd_original_commit"
