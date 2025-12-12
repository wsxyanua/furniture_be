-- =============================================
-- FIX COMPLETE: Update tất cả path với tên file ĐÚNG
-- =============================================

USE furniture_db;

-- ========================================
-- 1. FIX PRODUCTS - Dùng file ảnh số 1
-- ========================================
UPDATE products SET img = 'assets/products/PRO01/PRO01-1.png' WHERE id = 'PRD_001';
UPDATE products SET img = 'assets/products/PRO02/PRO02-1.png' WHERE id = 'PRD_002';
UPDATE products SET img = 'assets/products/PRO03/PRO03-1.png' WHERE id = 'PRD_003';  -- Dùng -1.png thay vì MAIN
UPDATE products SET img = 'assets/products/PRO04/PRO04-1.png' WHERE id = 'PRD_004';  -- Dùng -1.png thay vì MAIN
UPDATE products SET img = 'assets/products/PRO05/PRO05-1.png' WHERE id = 'PRD_005';  -- Dùng -1.png thay vì MAIN
UPDATE products SET img = 'assets/products/PRO06/PRO06-1.png' WHERE id = 'PRD_006';
UPDATE products SET img = 'assets/products/PRO07/PRO07-1.png' WHERE id = 'PRD_007';  -- Nếu có
UPDATE products SET img = 'assets/products/PRO08/PRO08-1.png' WHERE id = 'PRD_008';  -- Nếu có
UPDATE products SET img = 'assets/products/PRO09/PRO09-1.png' WHERE id = 'PRD_009';  -- Nếu có

-- ========================================
-- 2. FIX CATEGORIES - Dùng ảnh với UNDERSCORE (Đã đổi tên!)
-- ========================================

-- Living Room → Dùng Coffee_tables.png
UPDATE categories SET img = 'assets/categorys/LivingRoomFurniture/Coffee_tables.png' WHERE id = 'CAT_001';

-- Bedroom → Dùng Beds.png
UPDATE categories SET img = 'assets/categorys/BedroomFurniture/Beds.png' WHERE id = 'CAT_002';

-- Office → Dùng Book_cases.png
UPDATE categories SET img = 'assets/categorys/OfficeFurniture/Book_cases.png' WHERE id = 'CAT_003';

-- Kitchen → Dùng Kitchen_islands.png
UPDATE categories SET img = 'assets/categorys/Kitchen&DiningFurniture/Kitchen_islands.png' WHERE id = 'CAT_004';

-- Bathroom → Dùng Bathroom_cabinets.png
UPDATE categories SET img = 'assets/categorys/BathroomFurniture/Bathroom_cabinets.png' WHERE id = 'CAT_005';

-- Entryway → Dùng Banches.png
UPDATE categories SET img = 'assets/categorys/EntrywayFurniture&Storage/Banches.png' WHERE id = 'CAT_006';

-- Kids → Dùng Kids_armchair.png
UPDATE categories SET img = 'assets/categorys/KidsFurniture/Kids_armchair.png' WHERE id = 'CAT_007';

-- Gaming → Dùng Gaming_chairs.png
UPDATE categories SET img = 'assets/categorys/GamingFurniture/Gaming_chairs.png' WHERE id = 'CAT_008';

-- Patio → Dùng Patio_sets.png
UPDATE categories SET img = 'assets/categorys/PatioFurniture/Patio_sets.png' WHERE id = 'CAT_009';

-- ========================================
-- 3. Verify kết quả
-- ========================================
SELECT 'PRODUCTS' as Type, id, name, img FROM products
UNION ALL
SELECT 'CATEGORIES', id, name, img FROM categories
ORDER BY Type, id;

-- ========================================
-- LƯU Ý:
-- ========================================
-- ✅ Banners đã OK (không có dấu cách)
-- ✅ Products giờ dùng PRO01-1.png (có file)
-- ✅ Categories dùng sub-folder (không dấu cách)
-- 
-- Sau khi chạy SQL này:
-- 1. Hot restart Flutter app (nhấn R)
-- 2. Ảnh sẽ hiển thị ngay!
