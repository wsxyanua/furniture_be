from pydantic import BaseModel
from typing import Optional


class CartItemCreate(BaseModel):
    product_id: str
    name: str
    img: Optional[str] = None
    color: Optional[str] = None
    quantity: int = 1
    price: float


class CartItemUpdate(BaseModel):
    quantity: int


class CartItemResponse(BaseModel):
    id: int
    product_id: str
    name: str
    img: Optional[str] = None
    color: Optional[str] = None
    quantity: int
    price: float

    class Config:
        from_attributes = True
