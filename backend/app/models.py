from datetime import datetime

from sqlalchemy import Boolean, DateTime, Integer, String, Text
from sqlalchemy.orm import mapped_column

from .database import Base


class User(Base):
    __tablename__ = "user"

    id = mapped_column(Integer, primary_key=True, autoincrement=True)
    name = mapped_column(String(255), nullable=False, default="")
    username = mapped_column(String(255), unique=True, index=True, nullable=False)
    password_hash = mapped_column(String(255), nullable=False)
    registered_time = mapped_column(DateTime, nullable=False, default=datetime.utcnow)
    last_login_time = mapped_column(DateTime, nullable=True)
    reset_password = mapped_column(Text, nullable=True)
    active = mapped_column(Boolean, nullable=False, default=True)
    is_admin = mapped_column(Boolean, nullable=False, default=False)