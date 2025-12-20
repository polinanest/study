from pydantic import BaseModel
from typing import Optional

class URLCreate(BaseModel):

class URLInfo(BaseModel):
    short_id: str
    full_url: str
    visits: int
    created_at: str
