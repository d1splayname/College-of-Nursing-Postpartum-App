from sqlalchemy import Integer, String
from sqlalchemy.orm import mapped_column

from ..database import Base


class Family(Base):
    __tablename__ = "family"

    family_id = mapped_column(Integer, primary_key=True, autoincrement=True)
    family_name = mapped_column(String(64), nullable=False)