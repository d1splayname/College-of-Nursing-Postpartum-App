# Nursing AI backend

FastAPI backend with SQLAlchemy ORM, MySQL support, bcrypt password hashing, and JWT sessions.

## Setup

```powershell
cd backend
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install -r requirements.txt
```

Set `DATABASE_URL` and `JWT_SECRET` in `.env`. `DATABASE_URL` accepts a normal SQLAlchemy URL such as
`mysql+pymysql://user:password@host:3306/database` and the legacy Go MySQL DSN already used by this project.

## Run

```powershell
uvicorn main:app --host 0.0.0.0 --port 8080 --reload
```

The API provides `/health`, `/api/signup`, `/api/login`, `/api/session`, and `/api/users`.

## Test

```powershell
pytest
```