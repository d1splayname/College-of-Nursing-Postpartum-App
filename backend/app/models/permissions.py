from sqlalchemy import Integer
from sqlalchemy.orm import mapped_column

from ..database import Base


class Permission(Base):
    __tablename__ = "permissions"

    user_id = mapped_column(Integer, primary_key=True)
    family_id = mapped_column(Integer, primary_key=True, default=0)
    access_level  = mapped_column(Integer, nullable=False, default=0)
    permissions = mapped_column(Integer, nullable=False, default=0)