from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from sqlalchemy import desc, asc
from typing import List, Optional
from ..database import get_db
from ..schemas.product import ProductResponse, ReviewSchema, ReviewCreate, ReviewUpdate
from ..models.product import Product
from ..models.review import Review
from ..models.user import User
from ..services.auth import get_current_user
from ..utils.helpers import generate_id

router = APIRouter(prefix="/products", tags=["Products"])


@router.get("", response_model=List[ProductResponse])
def get_products(
    skip: int = 0,
    limit: int = 20,
    name: Optional[str] = None,
    category_id: Optional[str] = None,
    min_price: Optional[float] = None,
    max_price: Optional[float] = None,
    sort_by: str = "timestamp",
    order: str = "desc",
    db: Session = Depends(get_db)
):
    query = db.query(Product).filter(Product.status == "active")
    
    if name:
        query = query.filter(Product.name.like(f"%{name}%"))
    if category_id:
        query = query.filter(Product.category_id == category_id)
    if min_price is not None:
        query = query.filter(Product.current_price >= min_price)
    if max_price is not None:
        query = query.filter(Product.current_price <= max_price)
    
    # Sorting
    sort_column = getattr(Product, sort_by, Product.timestamp)
    if order == "asc":
        query = query.order_by(asc(sort_column))
    else:
        query = query.order_by(desc(sort_column))
    
    products = query.offset(skip).limit(limit).all()
    return products


@router.get("/special/new-arrivals", response_model=List[ProductResponse])
def get_new_arrivals(limit: int = 10, db: Session = Depends(get_db)):
    products = db.query(Product).filter(
        Product.status == "active"
    ).order_by(desc(Product.timestamp)).limit(limit).all()
    return products


@router.get("/special/top-seller", response_model=List[ProductResponse])
def get_top_seller(limit: int = 10, db: Session = Depends(get_db)):
    products = db.query(Product).filter(
        Product.status == "active"
    ).order_by(desc(Product.sell_count)).limit(limit).all()
    return products


@router.get("/special/best-review", response_model=List[ProductResponse])
def get_best_review(limit: int = 10, db: Session = Depends(get_db)):
    products = db.query(Product).filter(
        Product.status == "active"
    ).order_by(desc(Product.review_avg)).limit(limit).all()
    return products


@router.get("/special/discount", response_model=List[ProductResponse])
def get_discount(limit: int = 20, db: Session = Depends(get_db)):
    products = db.query(Product).filter(
        Product.status == "active",
        Product.current_price < Product.root_price
    ).order_by(desc(Product.root_price - Product.current_price)).limit(limit).all()
    return products


@router.get("/{product_id}", response_model=ProductResponse)
def get_product(product_id: str, db: Session = Depends(get_db)):
    product = db.query(Product).filter(Product.id == product_id).first()
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")
    return product


@router.get("/{product_id}/reviews", response_model=List[ReviewSchema])
def get_product_reviews(
    product_id: str,
    skip: int = 0,
    limit: int = 20,
    sort_by: str = "timestamp",
    order: str = "desc",
    db: Session = Depends(get_db)
):
    query = db.query(Review).filter(Review.product_id == product_id)
    
    # Map created_at to timestamp for frontend compatibility
    if sort_by == "created_at":
        sort_by = "timestamp"
    
    sort_column = getattr(Review, sort_by, Review.timestamp)
    if order == "asc":
        query = query.order_by(asc(sort_column))
    else:
        query = query.order_by(desc(sort_column))
    
    reviews = query.offset(skip).limit(limit).all()
    return reviews


@router.post("/{product_id}/reviews", response_model=ReviewSchema, status_code=201)
def create_review(
    product_id: str,
    review_data: ReviewCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    # Check if product exists
    product = db.query(Product).filter(Product.id == product_id).first()
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")
    
    # Create review
    new_review = Review(
        id=generate_id("REV"),
        product_id=product_id,
        user_id=current_user.id,
        order_id=review_data.order_id,
        star=review_data.star,
        message=review_data.message,
        img=review_data.img,
        service=review_data.service
    )
    
    db.add(new_review)
    
    # Update product review average
    all_reviews = db.query(Review).filter(Review.product_id == product_id).all()
    total_stars = sum(r.star for r in all_reviews) + review_data.star
    product.review_avg = total_stars / (len(all_reviews) + 1)
    
    db.commit()
    db.refresh(new_review)
    return new_review
