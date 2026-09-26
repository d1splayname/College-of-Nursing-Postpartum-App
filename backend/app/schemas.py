from datetime import datetime

from pydantic import BaseModel, ConfigDict, Field


class LoginRequest(BaseModel):
    username: str
    password: str


class SignupRequest(LoginRequest):
    name: str


class PublicUser(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    username: str
    registered_time: datetime
    last_login_time: datetime | None
    active: bool
    is_admin: bool


class LoginResponse(BaseModel):
    token: str
    user: PublicUser


class SessionResponse(BaseModel):
    user: PublicUser