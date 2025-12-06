from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from .routers import auth, users, products, categories, banners, cart, favorites, orders, countries, filters, reviews

app = FastAPI(
    title="Furniture Store API",
    description="Backend API for Furniture E-commerce Application",
    version="1.0.0"
)

# CORS Configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, replace with specific origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(auth.router)
app.include_router(users.router)
app.include_router(products.router)
app.include_router(categories.router)
app.include_router(banners.router)
app.include_router(cart.router)
app.include_router(favorites.router)
app.include_router(orders.router)
app.include_router(countries.router)
app.include_router(filters.router)
app.include_router(reviews.router)


@app.get("/")
def root():
    return {
        "message": "Furniture Store API",
        "version": "1.0.0",
        "docs": "/docs",
        "redoc": "/redoc"
    }


@app.get("/health")
def health_check():
    return {"status": "healthy"}
