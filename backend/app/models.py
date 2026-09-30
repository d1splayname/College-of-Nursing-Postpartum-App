from datetime import datetime

from sqlalchemy import Boolean, Date, DateTime, ForeignKey, Integer, String, Text
from sqlalchemy.dialects.mysql import INTEGER as MySQLInteger
from sqlalchemy.orm import mapped_column

from .database import Base


class User(Base):
    __tablename__ = "user"

    id = mapped_column(MySQLInteger(unsigned=True), primary_key=True, autoincrement=True)
    name = mapped_column(String(255), nullable=True)
    username = mapped_column(String(255), unique=True, index=True, nullable=False)
    password_hash = mapped_column(String(255), nullable=False)
    registered_time = mapped_column(DateTime, nullable=False, default=datetime.utcnow)
    last_login_time = mapped_column(DateTime, nullable=True)
    reset_password = mapped_column(Text, nullable=False, default=False)
    active = mapped_column(Boolean, nullable=False, default=True)
    is_admin = mapped_column(Boolean, nullable=False, default=False)


class PostpartumProfile(Base):
    __tablename__ = "postpartum_profile"

    user_id = mapped_column(MySQLInteger(unsigned=True), ForeignKey("user.id"), primary_key=True)
    birth_date = mapped_column(Date, nullable=False)


class CalendarEvent(Base):
    __tablename__ = "calendar_event"

    id = mapped_column(Integer, primary_key=True, autoincrement=True)
    user_id = mapped_column(
        MySQLInteger(unsigned=True),
        ForeignKey("user.id"),
        nullable=False,
        index=True,
    )
    title = mapped_column(String(255), nullable=False)
    description = mapped_column(Text, nullable=False, default="")
    start_time = mapped_column(DateTime, nullable=False)
    end_time = mapped_column(DateTime, nullable=False)
    event_type = mapped_column(String(50), nullable=False, default="personal")
    postpartum_stage = mapped_column(String(100), nullable=True)
    created_at = mapped_column(DateTime, nullable=False, default=datetime.utcnow)