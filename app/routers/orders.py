from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from ..database import get_db
from ..schemas.order import OrderCreate, OrderWithItemsResponse, OrderItemSchema
from ..models.order import Order, OrderItem
from ..models.user import User
from ..models.product import Product
from ..services.auth import get_current_user
from ..utils.helpers import generate_id

router = APIRouter(prefix="/orders", tags=["Orders"])


@router.get("", response_model=List[OrderWithItemsResponse])
def get_orders(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    orders = db.query(Order).filter(
        Order.user_id == current_user.id
    ).order_by(Order.date_order.desc()).all()
    
    result = []
    for order in orders:
        items = db.query(OrderItem).filter(OrderItem.order_id == order.id).all()
        result.append({
            "order": order,
            "items": items
        })
    
    return result


@router.post("", status_code=200)
def create_order(
    order_data: OrderCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    # Create order
    order_id = generate_id("ORD")
    new_order = Order(
        id=order_id,
        user_id=current_user.id,
        full_name=order_data.full_name,
        phone=order_data.phone,
        country=order_data.country,
        city=order_data.city,
        address=order_data.address,
        note=order_data.note,
        payment_method=order_data.payment_method,
        sub_total=order_data.sub_total,
        vat=order_data.vat,
        delivery_fee=order_data.delivery_fee,
        total_order=order_data.total_order
    )
    
    db.add(new_order)
    
    # Create order items
    for item in order_data.items:
        order_item = OrderItem(
            order_id=order_id,
            product_id=item.product_id,
            name=item.name,
            img=item.img,
            color=item.color,
            quantity=item.quantity,
            price=item.price
        )
        db.add(order_item)
        
        # Update product sell count
        product = db.query(Product).filter(Product.id == item.product_id).first()
        if product:
            product.sell_count += item.quantity
    
    db.commit()
    
    return {"order_id": order_id}
