from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from ..database import get_db
from ..schemas.user import UserCreate, UserResponse, LoginRequest, Token
from ..models.user import User
from ..utils.security import verify_password, get_password_hash, create_access_token
from ..utils.helpers import generate_id
import logging
import traceback

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

router = APIRouter(prefix="/auth", tags=["Authentication"])


@router.post("/register", response_model=Token, status_code=status.HTTP_201_CREATED)
def register(user_data: UserCreate, db: Session = Depends(get_db)):
    try:
        logger.info(f"📝 REGISTER ATTEMPT - Phone: {user_data.phone}, Email: {user_data.email}")
        
        # Check if user already exists
        if user_data.email:
            existing_user = db.query(User).filter(User.email == user_data.email).first()
            if existing_user:
                logger.warning(f"❌ Email already exists: {user_data.email}")
                raise HTTPException(status_code=400, detail="Email already registered")
        
        if user_data.phone:
            existing_user = db.query(User).filter(User.phone == user_data.phone).first()
            if existing_user:
                logger.warning(f"❌ Phone already exists: {user_data.phone}")
                raise HTTPException(status_code=400, detail="Phone already registered")
        
        if not user_data.email and not user_data.phone:
            logger.error("❌ No email or phone provided")
            raise HTTPException(status_code=400, detail="Email or phone is required")
        
        # Create new user
        new_user = User(
            id=generate_id("USR"),
            email=user_data.email,
            phone=user_data.phone,
            password_hash=get_password_hash(user_data.password),
            full_name=user_data.full_name,
            role=user_data.role
        )
        
        logger.info(f"Creating new user: {new_user.phone or new_user.email}")
        db.add(new_user)
        db.commit()
        db.refresh(new_user)
        
        logger.info(f"✅ REGISTER SUCCESS - User: {new_user.id} - {new_user.phone or new_user.email}")
        
        # Generate token
        access_token = create_access_token(data={"sub": new_user.id})
        return {"access_token": access_token, "token_type": "bearer"}
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"❌ REGISTER ERROR: {str(e)}")
        logger.error(f"Traceback: {traceback.format_exc()}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Internal server error: {str(e)}"
        )


@router.post("/login", response_model=Token)
def login(login_data: LoginRequest, db: Session = Depends(get_db)):
    try:
        logger.info(f"🔐 LOGIN ATTEMPT - Phone: {login_data.phone}, Email: {login_data.email}")
        
        # Find user by email or phone
        user = None
        if login_data.email:
            logger.info(f"Searching user by email: {login_data.email}")
            user = db.query(User).filter(User.email == login_data.email).first()
        elif login_data.phone:
            # Normalize phone number - remove country code and spaces
            phone = login_data.phone.strip()
            logger.info(f"Searching user by phone: {phone}")
            
            # Try multiple formats to find user
            # 1. Try as-is
            user = db.query(User).filter(User.phone == phone).first()
            logger.info(f"Try format 1 (as-is): {phone} - Found: {user is not None}")
            
            # 2. If not found and starts with +84, try with 0
            if not user and phone.startswith('+84'):
                phone_with_0 = '0' + phone[3:].replace(' ', '')
                logger.info(f"Try format 2 (+84 → 0): {phone_with_0}")
                user = db.query(User).filter(User.phone == phone_with_0).first()
                logger.info(f"Found: {user is not None}")
            
            # 3. If not found and starts with 84, try with 0
            if not user and phone.startswith('84') and not phone.startswith('0'):
                phone_with_0 = '0' + phone[2:].replace(' ', '')
                logger.info(f"Try format 3 (84 → 0): {phone_with_0}")
                user = db.query(User).filter(User.phone == phone_with_0).first()
                logger.info(f"Found: {user is not None}")
            
            # 4. If not found and starts with 0, try without 0 (maybe stored as +84)
            if not user and phone.startswith('0'):
                phone_without_0 = phone[1:]
                logger.info(f"Try format 4 (remove 0): {phone_without_0}")
                user = db.query(User).filter(User.phone == phone_without_0).first()
                logger.info(f"Found: {user is not None}")
        else:
            logger.error("❌ No email or phone provided")
            raise HTTPException(status_code=400, detail="Email or phone is required")
        
        if not user:
            logger.warning(f"❌ USER NOT FOUND - Phone: {login_data.phone}")
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Incorrect credentials"
            )
        
        logger.info(f"✅ User found: {user.id} - {user.phone} - {user.full_name}")
        
        # Verify password
        logger.info(f"Verifying password for user: {user.phone}")
        password_valid = verify_password(login_data.password, user.password_hash)
        logger.info(f"Password valid: {password_valid}")
        
        if not password_valid:
            logger.warning(f"❌ INVALID PASSWORD for user: {user.phone}")
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Incorrect credentials"
            )
        
        # Generate token
        logger.info(f"✅ LOGIN SUCCESS - User: {user.phone}")
        access_token = create_access_token(data={"sub": user.id})
        return {"access_token": access_token, "token_type": "bearer"}
        
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"❌ LOGIN ERROR: {str(e)}")
        logger.error(f"Traceback: {traceback.format_exc()}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Internal server error: {str(e)}"
        )
