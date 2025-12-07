# 📱 HƯỚNG DẪN LOGIN VỚI TẠI KHOẢN ADMIN

## ⚠️ QUAN TRỌNG: Phải chạy fix_passwords.sql TRƯỚC!

Trước khi login, bạn PHẢI chạy file `fix_passwords.sql` trong MySQL Workbench để cập nhật password hash đúng.

## 🔑 Thông tin tài khoản Admin

**Phone trong database:** `0123456789`
**Password:** `admin123`

## 📞 Cách chọn mã quốc gia khi login

Vì admin phone là `0123456789` (định dạng Việt Nam), bạn có 3 cách login:

### ✅ CÁCH 1: Chọn +84 (Vietnam) - KHUYẾN NGHỊ
```
Country Code: +84
Phone Number: 123456789  (bỏ số 0 đầu)
Password: admin123
```

### ✅ CÁCH 2: Chọn +84 và giữ nguyên số 0
```
Country Code: +84
Phone Number: 0123456789  (giữ nguyên số 0)
Password: admin123
```

### ✅ CÁCH 3: Không chọn mã quốc gia (nếu app cho phép)
```
Phone Number: 0123456789  (nhập đúng như trong database)
Password: admin123
```

## 🌍 Giải thích mã quốc gia

- **+84** = Vietnam 🇻🇳 → **CHỌN CÁI NÀY CHO ADMIN**
- +1 = USA/Canada 🇺🇸
- +86 = China 🇨🇳
- +81 = Japan 🇯🇵
- +44 = UK 🇬🇧

## 🔧 Backend đã được cập nhật

Backend giờ tự động xử lý các format:
- `0123456789` (format gốc)
- `+84123456789` (với +84)
- `84123456789` (không có +)
- `+84 123456789` (có khoảng trắng)
- `123456789` (không có số 0)

**➡️ TẤT CẢ ĐỀU SẼ HOẠT ĐỘNG!** ✅

## 👥 Tài khoản test khác

### User 1:
- Country Code: +84
- Phone: 987654321 (hoặc 0987654321)
- Password: user1234

### User 2:
- Country Code: +84
- Phone: 901234567 (hoặc 0901234567)
- Password: user1234

---

## 🚨 Lưu ý quan trọng

1. **Phải chạy `fix_passwords.sql` trước** - Password hash cũ không đúng!
2. **Chọn +84 (Vietnam)** cho tất cả tài khoản test
3. Backend đang chạy trên `http://127.0.0.1:8000`
4. Kiểm tra server có đang chạy bằng: http://127.0.0.1:8000/docs

## ✅ Checklist

- [ ] Chạy `fix_passwords.sql` trong MySQL Workbench
- [ ] Backend đang chạy (port 8000)
- [ ] Chọn +84 trong Flutter app
- [ ] Nhập số điện thoại (với hoặc không có số 0 đầu)
- [ ] Nhập password: admin123
- [ ] Click Login

**Nếu vẫn lỗi 401, hãy kiểm tra lại đã chạy fix_passwords.sql chưa!**
