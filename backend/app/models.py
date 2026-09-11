"""Backend domain models re-exported during the migration."""

from app.models_legacy import AnswerPackage, QuestionIntent

__all__ = ["AnswerPackage", "QuestionIntent"]
