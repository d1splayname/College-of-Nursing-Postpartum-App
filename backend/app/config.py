from functools import lru_cache
import os
from urllib.parse import parse_qsl, urlencode, urlsplit, urlunsplit

from dotenv import load_dotenv
from pydantic import BaseModel


class Settings(BaseModel):
    port: int = 8080
    database_url: str
    jwt_secret: str = "dev-secret-change-me"


def _sqlalchemy_database_url(value: str) -> str:
    """Accept SQLAlchemy URLs and the legacy Go MySQL DSN."""
    if not value:
        raise ValueError("DATABASE_URL is required")
    if "://" in value:
        parsed = urlsplit(value)
        query = urlencode(
            [(key, item) for key, item in parse_qsl(parsed.query, keep_blank_values=True) if key.lower() != "parsetime"]
        )
        return urlunsplit((parsed.scheme, parsed.netloc, parsed.path, query, parsed.fragment))
    if "@tcp(" not in value or ")/" not in value:
        raise ValueError("DATABASE_URL must be a SQLAlchemy URL or legacy MySQL DSN")

    credentials, remainder = value.split("@tcp(", 1)
    host_port, database = remainder.split(")/", 1)
    username, password = credentials.split(":", 1)
    if "?" in database:
        database, query = database.split("?", 1)
        query = urlencode(
            [(key, value) for key, value in parse_qsl(query, keep_blank_values=True) if key.lower() != "parsetime"]
        )
        query = f"?{query}" if query else ""
    else:
        query = ""
    return f"mysql+pymysql://{username}:{password}@{host_port}/{database}{query}"


@lru_cache
def get_settings() -> Settings:
    load_dotenv()
    return Settings(
        port=int(os.getenv("PORT", "8080")),
        database_url=_sqlalchemy_database_url(os.getenv("DATABASE_URL", "")),
        jwt_secret=os.getenv("JWT_SECRET", "dev-secret-change-me"),
    )