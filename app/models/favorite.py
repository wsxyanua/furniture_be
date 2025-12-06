from sqlalchemy import Column, Integer, String, Float, ForeignKey
from sqlalchemy.orm import relationship
from ..database import Base


class Favorite(Base):
    __tablename__ = "favorites"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    user_id = Column(String(50), ForeignKey("users.id"), nullable=False)
    product_id = Column(String(50), nullable=False)
    name = Column(String(255), nullable=False)
    img = Column(String(500), nullable=True)
    price = Column(Float, nullable=False)

    # Relationships
    user = relationship("User", back_populates="favorites")
