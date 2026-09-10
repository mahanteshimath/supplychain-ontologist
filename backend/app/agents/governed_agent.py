"""Backend-owned governed agent facade.

The implementation delegates to the proven local contract while the database and
Snowflake adapters are being connected. This keeps HTTP concerns out of agent logic.
"""

from app.services.local_governed_agent import GovernedAgent

__all__ = ["GovernedAgent"]
