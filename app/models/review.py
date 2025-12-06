from sqlalchemy import Column, String, Float, DateTime, ForeignKey, JSON, Text
from sqlalchemy.orm import relationship
from datetime import datetime
from ..database import Base


class Review(Base):
    __tablename__ = "reviews"

    id = Column(String(50), primary_key=True, index=True)
    product_id = Column(String(50), ForeignKey("products.id"), nullable=False)
    user_id = Column(String(50), ForeignKey("users.id"), nullable=False)
    order_id = Column(String(50), nullable=True)
    star = Column(Float, nullable=False)
    message = Column(Text, nullable=True)
    img = Column(JSON, nullable=True)  # ["img1.jpg", "img2.jpg"]
    service = Column(JSON, nullable=True)  # {"delivery": 5, "quality": 4}
    timestamp = Column(DateTime, default=datetime.utcnow)

    # Relationships
    product = relationship("Product", back_populates="reviews")
    user = relationship("User", back_populates="reviews")
