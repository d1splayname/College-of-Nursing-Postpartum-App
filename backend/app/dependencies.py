import jwt

from fastapi import Cookie, Depends, Header, HTTPException
from sqlalchemy.orm import Session

from .auth import decode_token
from .database import get_db
from .models import User


def authenticated_user(
    authorization: str | None = Header(default=None),
    session: str | None = Cookie(default=None),
    db: Session = Depends(get_db),
) -> User:
    try:
        token = ""
        if authorization and authorization.lower().startswith("bearer "):
            token = authorization[7:].strip()
        elif session:
            token = session
        else:
            raise HTTPException(status_code=401, detail="authentication required")

        claims = decode_token(token)
        user = db.get(User, int(claims["user_id"]))
    except HTTPException:
        raise
    except (KeyError, TypeError, ValueError, jwt.PyJWTError):
        raise HTTPException(status_code=401, detail="invalid or expired session") from None
    if user is None or not user.active:
        raise HTTPException(status_code=401, detail="user is inactive")
    return user