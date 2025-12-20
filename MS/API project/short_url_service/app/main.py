from fastapi import FastAPI, HTTPException, Depends
from typing import List
import random
import string
from datetime import datetime
from .db import init_db, get_conn
from .schemas import URLCreate, URLInfo

app = FastAPI(title="URL Shortener Service", version="1.0.0")

@app.on_event("startup")
def startup():
    init_db()

def generate_short_id(length=6):
    characters = string.ascii_letters + string.digits
    short_id = ''.join(random.choice(characters) for _ in range(length))
    return short_id

@app.post("/shorten", response_model=URLInfo, status_code=201)
def shorten_url(payload: URLCreate):
    short_id = generate_short_id()

    with get_conn() as conn:
        conn.execute(
            "INSERT INTO urls (short_id, full_url) VALUES (?, ?)",
            (short_id, payload.url)
        )
        conn.commit()

    return URLInfo(short_id=short_id, full_url=payload.url, visits=0, created_at=str(datetime.now()))

@app.get("/{short_id}", status_code=301)
def redirect_to_url(short_id: str):
    with get_conn() as conn:
        row = conn.execute("SELECT * FROM urls WHERE short_id = ?", (short_id,)).fetchone()
        if not row:
            raise HTTPException(status_code=404, detail="Short URL not found")

        conn.execute(
            "UPDATE urls SET visits = visits + 1 WHERE short_id = ?",
            (short_id,)
        )
        conn.commit()
        return {"url": row["full_url"]}

@app.get("/stats/{short_id}", response_model=URLInfo)
def get_url_info(short_id: str):
    with get_conn() as conn:
        row = conn.execute("SELECT * FROM urls WHERE short_id = ?", (short_id,)).fetchone()
        if not row:
            raise HTTPException(status_code=404, detail="Short URL not found")

        return URLInfo(
            short_id=row["short_id"],
            full_url=row["full_url"],
            visits=row["visits"],
            created_at=row["created_at"]
        )
