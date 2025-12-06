from pydantic import BaseModel
from typing import Optional, List


class BannerResponse(BaseModel):
    id: str
    date_start: Optional[str] = None
    date_end: Optional[str] = None
    img: str
    status: str
    products: Optional[List[str]] = None

    class Config:
        from_attributes = True
