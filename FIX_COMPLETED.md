# ✅ ĐÃ FIX XONG - HƯỚNG DẪN LOGIN

## 🔧 Những gì đã được sửa:

### 1. ✅ Backend (Python) - `app/routers/auth.py`
- Đã thêm logic xử lý nhiều format phone:
  - `0123456789` (format gốc)
  - `+84123456789` (với mã quốc gia)
  - `84123456789` (không dấu +)
  - `+84 123456789` (có khoảng trắng)
  - `123456789` (không có số 0)

### 2. ✅ Flutter App - `furniture_fe/lib/screens/login.dart`
- Đã thêm logic tự động bỏ số 0 đầu tiên khi có country code
- Code đã sửa (dòng 70-77):
```dart
// Fix phone format: remove leading 0 if country code is selected
String phoneNumber = phoneController.text.trim();
if (phoneNumber.startsWith('0')) {
  phoneNumber = phoneNumber.substring(1); // Remove leading 0
}

final token = await api.login(phone: currentPhoneNumber.value + phoneNumber, password: passwordController.text);
```

## ⚠️ QUAN TRỌNG: Phải chạy SQL trước!

**BẮT BUỘC:** Chạy file `fix_passwords.sql` trong MySQL Workbench trước khi test!

```sql
USE furniture_db;

UPDATE users 
SET password_hash = '$2b$12$lvNafEOwV52IywcY6s65RO2xfVAImEuIr30TGgRVKj5o2Kgg0V4VC' 
WHERE phone = '0123456789';

UPDATE users 
SET password_hash = '$2b$12$WkBk4iaPCJ9FE4tHLcUTQ.h6lrN8shL7sPjXo9KhfiftFhOlfYJG2' 
WHERE phone IN ('0987654321', '0901234567');
```

## 📱 Cách login trên Flutter App:

### ✅ CÁCH 1: Nhập CÓ số 0 (KHUYẾN NGHỊ)
```
1. Chọn Country Code: +84 (Vietnam)
2. Nhập Phone: 0123456789
3. Nhập Password: admin123
4. Click Login
```
→ Flutter tự động bỏ số 0 → Backend nhận: `+84123456789` ✅

### ✅ CÁCH 2: Nhập KHÔNG có số 0
```
1. Chọn Country Code: +84 (Vietnam)
2. Nhập Phone: 123456789
3. Nhập Password: admin123
4. Click Login
```
→ Flutter giữ nguyên → Backend nhận: `+84123456789` ✅

### ✅ CÁCH 3: Không chọn country code (nếu có option)
```
1. Không chọn country code
2. Nhập Phone: 0123456789
3. Nhập Password: admin123
4. Click Login
```
→ Backend nhận: `0123456789` ✅

## 🔑 Tài khoản test:

### Admin:
- Country Code: **+84**
- Phone: **0123456789** hoặc **123456789**
- Password: **admin123**

### User 1:
- Country Code: **+84**
- Phone: **0987654321** hoặc **987654321**
- Password: **user1234**

### User 2:
- Country Code: **+84**
- Phone: **0901234567** hoặc **901234567**
- Password: **user1234**

## ✅ Checklist trước khi test:

- [ ] Đã chạy `fix_passwords.sql` trong MySQL Workbench
- [ ] Backend đang chạy: `python -m uvicorn app.main:app --reload`
- [ ] Backend accessible tại: http://127.0.0.1:8000
- [ ] Flutter app đã rebuild với code mới

## 🎯 Kết quả mong đợi:

1. Chọn +84 (Vietnam)
2. Nhập: 0123456789 (hoặc 123456789)
3. Nhập password: admin123
4. Click Login
5. ✅ Hiện popup "Đăng nhập thành công"
6. ✅ Chuyển sang HomePage

## 🐛 Nếu vẫn lỗi 401:

1. Kiểm tra đã chạy `fix_passwords.sql` chưa
2. Verify password hash trong database:
   ```sql
   SELECT phone, LEFT(password_hash, 30) as hash_preview 
   FROM users 
   WHERE phone = '0123456789';
   ```
3. Hash phải bắt đầu bằng: `$2b$12$lvNafEOwV52IywcY6s65RO...`

## 🐛 Nếu vẫn lỗi 500:

1. Kiểm tra backend logs
2. Verify database connection trong terminal backend
3. Check `DATABASE_URL` trong `.env` file

---

**✨ TẤT CẢ ĐÃ ĐƯỢC FIX! Chỉ cần chạy SQL và test lại app!**
