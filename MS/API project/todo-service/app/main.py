from fastapi import FastAPI, HTTPException
from typing import List
from .db import init_db, get_conn
from .schemas import ItemCreate, ItemUpdate, ItemOut

app = FastAPI(title="TODO Service", version="1.0.0")


@app.on_event("startup")
def startup():
    init_db()


def get_task_by_id(conn, item_id: int):
    return conn.execute("SELECT * FROM items WHERE id = ?", (item_id,)).fetchone()


@app.post("/items", response_model=ItemOut, status_code=201)
def create_item(payload: ItemCreate):
    with get_conn() as conn:
        conn.execute(
            "INSERT INTO items (title, description, completed) VALUES (?, ?, ?)", 
            (payload.title, payload.description, 0),
        )
        conn.commit()

        last_insert_id = conn.lastrowid
        row = get_task_by_id(conn, last_insert_id)
        return _row_to_item(row)


@app.get("/items", response_model=List[ItemOut])
def list_items():
    with get_conn() as conn:
        rows = conn.execute("SELECT * FROM items ORDER BY id DESC").fetchall()
        return [_row_to_item(row) for row in rows]


@app.get("/items/{item_id}", response_model=ItemOut)
def get_item(item_id: int):
    with get_conn() as conn:
        row = get_task_by_id(conn, item_id)
        if not row:
            raise HTTPException(status_code=404, detail="Item not found")
        return _row_to_item(row)


@app.put("/items/{item_id}", response_model=ItemOut)
def update_item(item_id: int, payload: ItemUpdate):
    with get_conn() as conn:
        row = get_task_by_id(conn, item_id)
        if not row:
            raise HTTPException(status_code=404, detail="Item not found")

        updated_data = {
            "title": payload.title if payload.title is not None else row["title"],
            "description": payload.description if payload.description is not None else row["description"],
            "completed": payload.completed if payload.completed is not None else bool(row["completed"]),
        }

        conn.execute(
            "UPDATE items SET title = ?, description = ?, completed = ? WHERE id = ?",
            (updated_data["title"], updated_data["description"], 1 if updated_data["completed"] else 0, item_id),
        )
        conn.commit()

        row = get_task_by_id(conn, item_id)
        return _row_to_item(row)


@app.delete("/items/{item_id}", status_code=204)
def delete_item(item_id: int):
    with get_conn() as conn:
        row = get_task_by_id(conn, item_id)
        if not row:
            raise HTTPException(status_code=404, detail="Item not found")

      
        conn.execute("DELETE FROM items WHERE id = ?", (item_id,))
        conn.commit()
        return None


def _row_to_item(row) -> ItemOut:
    return ItemOut(
        id=row["id"],
        title=row["title"],
        description=row["description"],
        completed=bool(row["completed"]),
        created_at=row["created_at"],
    )
