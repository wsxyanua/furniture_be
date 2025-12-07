from passlib.context import CryptContext

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# Generate correct password hashes
passwords = {
    "admin123": None,
    "user1234": None
}

print("=" * 80)
print("🔐 GENERATING CORRECT PASSWORD HASHES")
print("=" * 80)
print()

for password in passwords:
    hash_value = pwd_context.hash(password)
    passwords[password] = hash_value
    print(f"Password: {password}")
    print(f"Hash: {hash_value}")
    print()
    
print("=" * 80)
print("SQL UPDATE COMMANDS:")
print("=" * 80)
print()

print(f"""
-- Update Admin password (0123456789)
UPDATE users SET password_hash = '{passwords['admin123']}' WHERE phone = '0123456789';

-- Update User passwords (0987654321, 0901234567)
UPDATE users SET password_hash = '{passwords['user1234']}' WHERE phone IN ('0987654321', '0901234567');
""")

print()
print("=" * 80)
print("Copy and run these commands in MySQL Workbench!")
print("=" * 80)
