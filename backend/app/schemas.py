from datetime import date, datetime

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
    last_login_time: datetime | None = None
    active: bool
    is_admin: bool


class LoginResponse(BaseModel):
    token: str
    user: PublicUser


class SessionResponse(BaseModel):
    user: PublicUser


class PostpartumProfileRequest(BaseModel):
    birth_date: date


class PostpartumProfileResponse(PostpartumProfileRequest):
    pass


class CalendarEventRequest(BaseModel):
    title: str = Field(min_length=1, max_length=255)
    description: str = ""
    start_time: datetime
    end_time: datetime
    event_type: str = Field(default="personal", max_length=50)


class CalendarEventResponse(CalendarEventRequest):
    model_config = ConfigDict(from_attributes=True)

    id: int | None = None
    postpartum_stage: str | None = None
    source: str = "personal"