-- =============================================
-- UPDATE DATABASE SAU KHI ĐỔI TÊN FILE
-- =============================================

USE furniture_db;

-- Living Room: Coffee tables.png → Coffeetables.png
UPDATE categories SET img = 'assets/categorys/LivingRoomFurniture/Coffeetables.png' WHERE id = 'CAT_001';

-- Bedroom: Beds.png → Beds.png (không có dấu cách, giữ nguyên)
UPDATE categories SET img = 'assets/categorys/BedroomFurniture/Beds.png' WHERE id = 'CAT_002';

-- Office: Bookcases.png → Bookcases.png (không có dấu cách, giữ nguyên)
UPDATE categories SET img = 'assets/categorys/OfficeFurniture/Bookcases.png' WHERE id = 'CAT_003';

-- Kitchen: Kitchen islands.png → Kitchenislands.png
UPDATE categories SET img = 'assets/categorys/KitchenAndDiningFurniture/Kitchenislands.png' WHERE id = 'CAT_004';

-- Bathroom: Bathroom cabinets.png → Bathroomcabinets.png
UPDATE categories SET img = 'assets/categorys/BathroomFurniture/Bathroomcabinets.png' WHERE id = 'CAT_005';

-- Entryway: Banches.png → Banches.png (không có dấu cách, giữ nguyên)
UPDATE categories SET img = 'assets/categorys/EntrywayFurnitureAndStorage/Banches.png' WHERE id = 'CAT_006';

-- Kids: Kids armchair.png → Kidsarmchair.png
UPDATE categories SET img = 'assets/categorys/KidsFurniture/Kidsarmchair.png' WHERE id = 'CAT_007';

-- Gaming: Gaming chairs.png → Gamingchairs.png
UPDATE categories SET img = 'assets/categorys/GamingFurniture/Gamingchairs.png' WHERE id = 'CAT_008';

-- Patio: Patio sets.png → Patiosets.png
UPDATE categories SET img = 'assets/categorys/PatioFurniture/Patiosets.png' WHERE id = 'CAT_009';

-- Verify
SELECT id, name, img FROM categories;
