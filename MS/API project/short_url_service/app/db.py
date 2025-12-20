import os
import sqlite3
from contextlib import contextmanager

DATA_DIR = os.getenv("DATA_DIR", "/app/data")
DB_PATH = os.getenv("DB_PATH", os.path.join(DATA_DIR, "shorturl.db"))

def init_db() -> None:
    os.makedirs(os.path.dirname(DB_PATH), exist_ok=True)
    with sqlite3.connect(DB_PATH) as conn:
        conn.execute("""
        CREATE TABLE IF NOT EXISTS urls (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            short_id TEXT NOT NULL,
            full_url TEXT NOT NULL,
            created_at TEXT NOT NULL DEFAULT (datetime('now')),
            visits INTEGER NOT NULL DEFAULT 0
        )
        """)
        conn.commit()

@contextmanager
def get_conn():
    conn = sqlite3.connect(DB_PATH, check_same_thread=False)
    conn.row_factory = sqlite3.Row
    try:
        yield conn
    finally:
        conn.close()
