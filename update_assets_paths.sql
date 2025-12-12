-- =============================================
-- Update Database with Assets Paths for Flutter
-- =============================================

-- Chọn database
USE furniture_db;

-- Kiểm tra database đã được chọn
SELECT DATABASE();

-- Update Banners with assets paths
UPDATE banners SET img = 'assets/banners/banner1.jpg' WHERE id = 'BAN_001';
UPDATE banners SET img = 'assets/banners/banner2.jpg' WHERE id = 'BAN_002';
UPDATE banners SET img = 'assets/banners/banner3.jpg' WHERE id = 'BAN_003';

-- Update Categories with assets paths
UPDATE categories SET img = 'assets/categorys/Living Room Furniture.png' WHERE id = 'CAT_001';
UPDATE categories SET img = 'assets/categorys/Bedroom Furniture.png' WHERE id = 'CAT_002';
UPDATE categories SET img = 'assets/categorys/Office Furniture.png' WHERE id = 'CAT_003';
UPDATE categories SET img = 'assets/categorys/Kitchen & Dining Furniture.png' WHERE id = 'CAT_004';
UPDATE categories SET img = 'assets/categorys/Bathroom Furniture.png' WHERE id = 'CAT_005';
UPDATE categories SET img = 'assets/categorys/Entryway Furniture & Storage.png' WHERE id = 'CAT_006';
UPDATE categories SET img = 'assets/categorys/Kids Furniture.png' WHERE id = 'CAT_007';
UPDATE categories SET img = 'assets/categorys/Gaming Furniture.png' WHERE id = 'CAT_008';
UPDATE categories SET img = 'assets/categorys/Patio Furniture.PNG' WHERE id = 'CAT_009';

-- Update Category Items with assets paths
-- Living Room
UPDATE category_items SET img = 'assets/categorys/Living Room Furniture/Coffee tables.png' WHERE id = 'CATI_001';
UPDATE category_items SET img = 'assets/categorys/Living Room Furniture/Coffee tables.png' WHERE id = 'CATI_002';
UPDATE category_items SET img = 'assets/categorys/Living Room Furniture/Armchairs accent chairs.png' WHERE id = 'CATI_003';

-- Bedroom
UPDATE category_items SET img = 'assets/categorys/Bedroom Furniture/Beds.png' WHERE id = 'CATI_004';
UPDATE category_items SET img = 'assets/categorys/Bedroom Furniture/Armoires & warddrobes.png' WHERE id = 'CATI_005';

-- Office
UPDATE category_items SET img = 'assets/categorys/Office Furniture/Gaming desks.png' WHERE id = 'CATI_006' AND name = 'Desks';
UPDATE category_items SET img = 'assets/categorys/Gaming Furniture/Gaming chairs.png' WHERE id = 'CATI_007';

-- Kitchen & Dining
UPDATE category_items SET img = 'assets/categorys/Kitchen & Dining Furniture/Kitchen islands.png' WHERE id = 'CATI_008';
UPDATE category_items SET img = 'assets/categorys/Kitchen & Dining Furniture/Kitchen cabinets.png' WHERE id = 'CATI_009';

-- Update Products with assets paths
-- Bạn cần đặt ảnh vào: assets/products/PRO01/, assets/products/PRO02/, etc.
-- Ví dụ với các sản phẩm hiện có:

UPDATE products SET img = 'assets/products/PRO01/main.jpg' WHERE id = 'PRD_001';
UPDATE products SET img = 'assets/products/PRO02/main.jpg' WHERE id = 'PRD_002';
UPDATE products SET img = 'assets/products/PRO03/main.jpg' WHERE id = 'PRD_003';
UPDATE products SET img = 'assets/products/PRO04/main.jpg' WHERE id = 'PRD_004';
UPDATE products SET img = 'assets/products/PRO05/main.jpg' WHERE id = 'PRD_005';
UPDATE products SET img = 'assets/products/PRO06/main.jpg' WHERE id = 'PRD_006';

-- Update User avatar paths (nếu có)
-- UPDATE users SET img = 'assets/icons/user.png' WHERE img IS NULL OR img = '';

-- Verify updates
SELECT 'Banners' as Table_Name, id, img FROM banners
UNION ALL
SELECT 'Categories', id, img FROM categories
UNION ALL
SELECT 'Category Items', id, img FROM category_items
UNION ALL
SELECT 'Products', id, img FROM products;
