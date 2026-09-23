from datetime import datetime, timezone

from sqlalchemy import DateTime, Integer, String, Text, JSON
from sqlalchemy.orm import mapped_column

from ..database import Base


class Event(Base):
    __tablename__ = "events"

    child_id = mapped_column(Integer, primary_key=True, nullable=False)
    event_type = mapped_column(String(64), nullable=False)
    notes = mapped_column(Text, default=None)
    data = mapped_column(JSON, default=None)
    timestamp = mapped_column(DateTime, nullable=False, default=lambda: datetime.now(timezone.utc))