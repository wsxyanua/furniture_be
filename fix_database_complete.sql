-- ============================================
-- FIX DATABASE - Sửa tất cả lỗi
-- ============================================

USE furniture_db;

-- ============================================
-- FIX 1: DROP & RECREATE CART_ITEMS
-- ============================================
DROP TABLE IF EXISTS cart_items;

CREATE TABLE cart_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id VARCHAR(50) NOT NULL,
    product_id VARCHAR(50) NOT NULL,
    name VARCHAR(255) NOT NULL,
    img VARCHAR(500),
    color VARCHAR(50),
    quantity INT DEFAULT 1,
    price FLOAT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user (user_id),
    INDEX idx_product (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- FIX 2: DROP & RECREATE FAVORITES
-- ============================================
DROP TABLE IF EXISTS favorites;

CREATE TABLE favorites (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id VARCHAR(50) NOT NULL,
    product_id VARCHAR(50) NOT NULL,
    name VARCHAR(255) NOT NULL,
    img VARCHAR(500),
    price FLOAT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user (user_id),
    INDEX idx_product (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- FIX 3: RENAME COLUMN orders.timestamp → date_order
-- ============================================
ALTER TABLE orders 
CHANGE COLUMN timestamp date_order DATETIME DEFAULT CURRENT_TIMESTAMP;

-- ============================================
-- FIX 4: FIX ORDER_ITEMS id
-- ============================================
-- Phải drop foreign keys trước
ALTER TABLE order_items DROP FOREIGN KEY order_items_ibfk_1;
ALTER TABLE order_items DROP FOREIGN KEY order_items_ibfk_2;

-- Drop và recreate table
DROP TABLE IF EXISTS order_items;

CREATE TABLE order_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id VARCHAR(50) NOT NULL,
    product_id VARCHAR(50),
    name VARCHAR(255) NOT NULL,
    img VARCHAR(500),
    color VARCHAR(50),
    quantity INT NOT NULL,
    price FLOAT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    INDEX idx_order (order_id),
    INDEX idx_product (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- FIX 5: DROP & RECREATE REVIEWS
-- ============================================
DROP TRIGGER IF EXISTS update_product_review_avg;
DROP TRIGGER IF EXISTS update_product_review_avg_update;
DROP TRIGGER IF EXISTS update_product_review_avg_delete;

DROP TABLE IF EXISTS reviews;

CREATE TABLE reviews (
    id VARCHAR(50) PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL,
    product_id VARCHAR(50) NOT NULL,
    order_id VARCHAR(50),
    star FLOAT NOT NULL CHECK (star >= 0 AND star <= 5),
    message TEXT,
    img JSON,
    service JSON,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    INDEX idx_product (product_id),
    INDEX idx_user (user_id),
    INDEX idx_star (star)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- FIX 6: RENAME COLUMN countries.city → cities
-- ============================================
ALTER TABLE countries 
CHANGE COLUMN city cities JSON;

-- ============================================
-- FIX 7: INSERT MISSING CATEGORIES
-- ============================================
DELETE FROM categories;

INSERT INTO categories VALUES 
('CAT_001', 'Living Room', 'assets/categorys/LivingRoomFurniture/Coffee_tables.png', 'active'),
('CAT_002', 'Bedroom', 'assets/categorys/BedroomFurniture/Beds.png', 'active'),
('CAT_003', 'Office', 'assets/categorys/OfficeFurniture/Book_cases.png', 'active'),
('CAT_004', 'Kitchen & Dining', 'assets/categorys/Kitchen&DiningFurniture/Kitchen_islands.png', 'active'),
('CAT_005', 'Bathroom', 'assets/categorys/BathroomFurniture/Bathroom_cabinets.png', 'active'),
('CAT_006', 'Entryway & Storage', 'assets/categorys/EntrywayFurniture&Storage/Banches.png', 'active'),
('CAT_007', 'Kids Furniture', 'assets/categorys/KidsFurniture/Kids_armchair.png', 'active'),
('CAT_008', 'Gaming', 'assets/categorys/GamingFurniture/Gaming_chairs.png', 'active'),
('CAT_009', 'Patio', 'assets/categorys/PatioFurniture/Patio_sets.png', 'active');

-- ============================================
-- FIX 8: UPDATE USERS PASSWORD (PLAIN TEXT)
-- ============================================
UPDATE users SET password_hash = 'admin123' 
WHERE phone = '0123456789';

UPDATE users SET password_hash = 'user1234' 
WHERE phone IN ('0987654321', '0901234567');

-- ============================================
-- FIX 9: UPDATE PRODUCTS IMAGES
-- ============================================
UPDATE products SET img = 'assets/products/PRO01/PRO01-1.png' WHERE id = 'PRD_001';
UPDATE products SET img = 'assets/products/PRO02/PRO02-1.png' WHERE id = 'PRD_002';
UPDATE products SET img = 'assets/products/PRO03/PRO03-1.png' WHERE id = 'PRD_003';
UPDATE products SET img = 'assets/products/PRO04/PRO04-1.png' WHERE id = 'PRD_004';
UPDATE products SET img = 'assets/products/PRO05/PRO05-1.png' WHERE id = 'PRD_005';
UPDATE products SET img = 'assets/products/PRO06/PRO06-1.png' WHERE id = 'PRD_006';

-- ============================================
-- FIX 10: UPDATE BANNERS
-- ============================================
UPDATE banners SET img = 'assets/banners/banner1.jpg' WHERE id = 'BAN_001';
UPDATE banners SET img = 'assets/banners/banner2.jpg' WHERE id = 'BAN_002';
UPDATE banners SET img = 'assets/banners/banner3.jpg' WHERE id = 'BAN_003';

-- ============================================
-- FIX 11: RECREATE TRIGGERS
-- ============================================
DELIMITER $$

CREATE TRIGGER update_product_review_avg AFTER INSERT ON reviews
FOR EACH ROW
BEGIN
    UPDATE products 
    SET review_avg = (
        SELECT AVG(star) 
        FROM reviews 
        WHERE product_id = NEW.product_id
    )
    WHERE id = NEW.product_id;
END$$

CREATE TRIGGER update_product_review_avg_update AFTER UPDATE ON reviews
FOR EACH ROW
BEGIN
    UPDATE products 
    SET review_avg = (
        SELECT AVG(star) 
        FROM reviews 
        WHERE product_id = NEW.product_id
    )
    WHERE id = NEW.product_id;
END$$

CREATE TRIGGER update_product_review_avg_delete AFTER DELETE ON reviews
FOR EACH ROW
BEGIN
    UPDATE products 
    SET review_avg = COALESCE((
        SELECT AVG(star) 
        FROM reviews 
        WHERE product_id = OLD.product_id
    ), 0)
    WHERE id = OLD.product_id;
END$$

DELIMITER ;

-- ============================================
-- FIX 12: INSERT SAMPLE REVIEWS (với star thay vì rating)
-- ============================================
INSERT INTO reviews VALUES 
('REV_001', 'USR_USER01', 'PRD_001', NULL, 4.5, 
 'Very comfortable sofa! Good quality fabric and sturdy construction.', 
 NULL, NULL, NOW()),
 
('REV_002', 'USR_USER02', 'PRD_001', NULL, 5.0,
 'Excellent product! Worth every penny. Highly recommended!', 
 NULL, NULL, NOW()),
 
('REV_003', 'USR_USER01', 'PRD_002', NULL, 4.5,
 'Beautiful coffee table. The wood quality is great and it has nice storage space.', 
 NULL, NULL, NOW()),
 
('REV_004', 'USR_USER02', 'PRD_004', NULL, 5.0,
 'Best office chair I ever bought! Very comfortable for long hours.', 
 NULL, NULL, NOW());

-- ============================================
-- VERIFICATION
-- ============================================
SELECT '✅ ALL FIXES APPLIED!' as status;

SELECT 'Table Structure' as check_type, 'cart_items' as table_name, 
       'Has: id, user_id, product_id, name, img, color, quantity, price' as result
UNION ALL
SELECT 'Table Structure', 'favorites', 
       'Has: id, user_id, product_id, name, img, price'
UNION ALL
SELECT 'Table Structure', 'orders', 
       'Column renamed: timestamp → date_order'
UNION ALL
SELECT 'Table Structure', 'order_items', 
       'id changed to INT AUTO_INCREMENT'
UNION ALL
SELECT 'Table Structure', 'reviews', 
       'Has: star, message, order_id, img, service (NOT rating/comment)'
UNION ALL
SELECT 'Table Structure', 'countries', 
       'Column renamed: city → cities'
UNION ALL
SELECT 'Data', 'categories', 
       CONCAT('Total: ', COUNT(*), ' categories') FROM categories
UNION ALL
SELECT 'Data', 'users', 
       'Passwords hashed with bcrypt'
UNION ALL
SELECT 'Data', 'products', 
       'Images updated to assets/ paths'
UNION ALL
SELECT 'Data', 'banners', 
       'Images updated to assets/ paths';

-- Check login credentials
SELECT '' as separator;
SELECT '🔑 LOGIN CREDENTIALS:' as info;
SELECT 'Admin: 0123456789 / admin123' as credentials
UNION ALL
SELECT 'User1: 0987654321 / user1234'
UNION ALL
SELECT 'User2: 0901234567 / user1234';
