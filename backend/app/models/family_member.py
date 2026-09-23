
from sqlalchemy import Integer
from sqlalchemy.orm import mapped_column

from ..database import Base


class FamilyMember(Base):
    __tablename__ = "family_member"

    family_id = mapped_column(Integer, primary_key=True)
    user_id = mapped_column(Integer, primary_key=True)