from datetime import datetime, timezone

from sqlalchemy import Boolean, DateTime, Integer, String
from sqlalchemy.orm import mapped_column

from ..database import Base


class Child(Base):
    __tablename__ = "child"

    child_id = mapped_column(Integer, primary_key=True, autoincrement=True)
    parent_id = mapped_column(Integer, nullable=False)
    name = mapped_column(String(64), nullable=False)
    gender = mapped_column(Boolean, default=0)
    due_date = mapped_column(DateTime, nullable=False, default=lambda: datetime.now(timezone.utc))
    app_theme = mapped_column(String(64),  nullable=False, default="neutral")