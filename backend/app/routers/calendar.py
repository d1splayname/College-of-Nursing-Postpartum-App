from fastapi import APIRouter, Depends, HTTPException, Response, status
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.calendar import postpartum_milestones
from app.database import get_db
from app.dependencies import authenticated_user
from app.models import CalendarEvent, PostpartumProfile, User
from app.schemas import (
    CalendarEventRequest,
    CalendarEventResponse,
    PostpartumProfileRequest,
    PostpartumProfileResponse,
)


router = APIRouter()


@router.put("/api/profile/postpartum", response_model=PostpartumProfileResponse)
def save_postpartum_profile(
    payload: PostpartumProfileRequest,
    user: User = Depends(authenticated_user),
    db: Session = Depends(get_db),
) -> PostpartumProfileResponse:
    profile = db.get(PostpartumProfile, user.id)
    if profile is None:
        profile = PostpartumProfile(user_id=user.id, birth_date=payload.birth_date)
        db.add(profile)
    else:
        profile.birth_date = payload.birth_date
    db.commit()
    db.refresh(profile)
    return PostpartumProfileResponse(birth_date=profile.birth_date)


@router.get("/api/profile/postpartum", response_model=PostpartumProfileResponse)
def get_postpartum_profile(
    user: User = Depends(authenticated_user),
    db: Session = Depends(get_db),
) -> PostpartumProfileResponse:
    profile = db.get(PostpartumProfile, user.id)
    if profile is None:
        raise HTTPException(404, "postpartum profile has not been saved")
    return PostpartumProfileResponse(birth_date=profile.birth_date)


@router.get("/api/calendar/events", response_model=list[CalendarEventResponse])
def calendar_events(
    user: User = Depends(authenticated_user),
    db: Session = Depends(get_db),
) -> list[CalendarEventResponse]:
    events = [
        CalendarEventResponse.model_validate(event).model_copy(update={"source": "personal"})
        for event in db.scalars(
            select(CalendarEvent)
            .where(CalendarEvent.user_id == user.id)
            .order_by(CalendarEvent.start_time)
        ).all()
    ]
    profile = db.get(PostpartumProfile, user.id)
    if profile is not None:
        generated = [CalendarEventResponse.model_validate(event) for event in postpartum_milestones(profile.birth_date)]
        events = generated + events
    return sorted(events, key=lambda event: event.start_time)


@router.post("/api/calendar/events", response_model=CalendarEventResponse, status_code=status.HTTP_201_CREATED)
def create_calendar_event(
    payload: CalendarEventRequest,
    user: User = Depends(authenticated_user),
    db: Session = Depends(get_db),
) -> CalendarEventResponse:
    if payload.end_time <= payload.start_time:
        raise HTTPException(400, "end_time must be after start_time")
    event = CalendarEvent(user_id=user.id, **payload.model_dump())
    db.add(event)
    db.commit()
    db.refresh(event)
    return CalendarEventResponse.model_validate(event).model_copy(update={"source": "personal"})


@router.delete("/api/calendar/events/{event_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_calendar_event(
    event_id: int,
    user: User = Depends(authenticated_user),
    db: Session = Depends(get_db),
) -> Response:
    event = db.scalar(select(CalendarEvent).where(CalendarEvent.id == event_id, CalendarEvent.user_id == user.id))
    if event is None:
        raise HTTPException(404, "calendar event not found")
    db.delete(event)
    db.commit()
    return Response(status_code=status.HTTP_204_NO_CONTENT)