import sys
import uvicorn
import jwt

from datetime import datetime, timezone

from fastapi import Cookie, Depends, FastAPI, Header, HTTPException, Response, status
from fastapi.exceptions import RequestValidationError
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import PlainTextResponse
from sqlalchemy import select
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from app.auth import create_token, decode_token, hash_password, verify_password
from app.database import get_db

# models
from app.models.child import Child
from app.models.event import Event
from app.models.family_member import FamilyMember
from app.models.family import Family
from app.models.permissions import Permission
from app.models.user import User

from app.schemas import LoginRequest, LoginResponse, PublicUser, SessionResponse, SignupRequest

app = FastAPI(title="Nursing AI API")
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["GET", "POST", "OPTIONS"],
    allow_headers=["*"],
)


# ====== EXCEPTION HANDLERS ======
@app.exception_handler(HTTPException)
async def http_exception_handler(_, exc: HTTPException):
    return PlainTextResponse(str(exc.detail), status_code=exc.status_code)


@app.exception_handler(RequestValidationError)
async def validation_exception_handler(_, __):
    return PlainTextResponse("invalid JSON", status_code=status.HTTP_400_BAD_REQUEST)


# ====== UTILITY FUNCTIONS ======
def public_user(user: User) -> PublicUser:
    return PublicUser.model_validate(user)


def set_session_cookie(response: Response, token: str) -> None:
    response.set_cookie(
        key="session",
        value=token,
        max_age=24 * 60 * 60,
        httponly=True,
        samesite="lax",
        path="/",
    )


def bearer_or_cookie(authorization: str | None, session: str | None) -> str:
    if authorization and authorization.lower().startswith("bearer "):
        return authorization[7:].strip()
    if session:
        return session
    raise HTTPException(status_code=401, detail="authentication required")


def authenticated_user(
    authorization: str | None = Header(default=None),
    session: str | None = Cookie(default=None),
    db: Session = Depends(get_db),
) -> User:
    try:
        claims = decode_token(bearer_or_cookie(authorization, session))
        user = db.get(User, int(claims["user_id"]))
    except (KeyError, TypeError, ValueError, jwt.PyJWTError):
        raise HTTPException(status_code=401, detail="invalid or expired session") from None
    if user is None or not user.active:
        raise HTTPException(status_code=401, detail="user is inactive")
    return user


# ====== HEALTH CHECK ENDPOINT ======
@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok", "time": datetime.now(timezone.utc).isoformat().replace("+00:00", "Z")}


# ====== AUTHENTICATION ENDPOINTS ======
@app.post("/api/signup", response_model=LoginResponse, status_code=status.HTTP_201_CREATED)
def signup(payload: SignupRequest, response: Response, db: Session = Depends(get_db)) -> LoginResponse:
    name = payload.name.strip()
    username = payload.username.strip()
    if not name or not username or not payload.password:
        raise HTTPException(400, "name, username, and password are required")
    if len(payload.password) < 8:
        raise HTTPException(400, "password must be at least 8 characters")
    if db.scalar(select(User).where(User.username == username)) is not None:
        raise HTTPException(409, "username is already registered")

    user = User(name=name, username=username, password_hash=hash_password(payload.password))
    db.add(user)
    try:
        db.commit()
    except IntegrityError as exc:
        db.rollback()
        raise HTTPException(500, "failed to create account") from exc
    db.refresh(user)
    token = create_token(user.id, user.username, user.is_admin)
    set_session_cookie(response, token)
    return LoginResponse(token=token, user=public_user(user))


@app.post("/api/login", response_model=LoginResponse)
def login(payload: LoginRequest, response: Response, db: Session = Depends(get_db)) -> LoginResponse:
    user = db.scalar(select(User).where(User.username == payload.username))
    if user is None or not user.active or not verify_password(payload.password, user.password_hash):
        raise HTTPException(401, "invalid credentials")
    user.last_login_time = datetime.now(timezone.utc)
    db.commit()
    token = create_token(user.id, user.username, user.is_admin)
    set_session_cookie(response, token)
    return LoginResponse(token=token, user=public_user(user))


# ====== USER MANAGEMENT ENDPOINTS ======
@app.get("/api/users", response_model=list[PublicUser])
def users(db: Session = Depends(get_db)) -> list[PublicUser]:
    return [public_user(user) for user in db.scalars(select(User).order_by(User.id)).all()]


@app.get("/api/session", response_model=SessionResponse)
def session(user: User = Depends(authenticated_user)) -> SessionResponse:
    return SessionResponse(user=public_user(user))


if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "dev":
        uvicorn.run("main:app", host="localhost", port=8080, reload=True)
    else:
        uvicorn.run("main:app", host="localhost", port=8080, reload=False)