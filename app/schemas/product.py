from pydantic import BaseModel
from typing import Optional, List, Dict
from datetime import datetime


class ProductItemSchema(BaseModel):
    id: str
    color: Optional[Dict[str, str]] = None
    img: Optional[List[str]] = None

    class Config:
        from_attributes = True


class ReviewSchema(BaseModel):
    id: str
    user_id: str
    order_id: Optional[str] = None
    star: float
    message: Optional[str] = None
    img: Optional[List[str]] = None
    service: Optional[Dict[str, any]] = None
    timestamp: datetime

    class Config:
        from_attributes = True


class ProductBase(BaseModel):
    name: str
    img: Optional[str] = None
    title: Optional[str] = None
    description: Optional[str] = None
    status: str = "active"
    category_id: Optional[str] = None
    material: Optional[Dict[str, str]] = None
    size: Optional[Dict[str, str]] = None
    root_price: float = 0
    current_price: float = 0


class ProductResponse(BaseModel):
    id: str
    name: str
    img: Optional[str] = None
    title: Optional[str] = None
    description: Optional[str] = None
    status: str
    category_id: Optional[str] = None
    material: Optional[Dict[str, str]] = None
    size: Optional[Dict[str, str]] = None
    root_price: float
    current_price: float
    review_avg: float
    sell_count: float
    timestamp: datetime
    items: List[ProductItemSchema] = []
    reviews: List[ReviewSchema] = []

    class Config:
        from_attributes = True


class ReviewCreate(BaseModel):
    product_id: str
    order_id: Optional[str] = None
    star: float
    message: Optional[str] = None
    img: Optional[List[str]] = None
    service: Optional[Dict[str, any]] = None


class ReviewUpdate(BaseModel):
    star: Optional[float] = None
    message: Optional[str] = None
    img: Optional[List[str]] = None
    service: Optional[Dict[str, any]] = None
