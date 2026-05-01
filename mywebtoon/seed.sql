USE mywebtoon_db;

-- Insert a Mock Creator
INSERT IGNORE INTO users (id, username, password, role) VALUES (2, 'studio_neon', 'mypassword', 'CREATOR');

-- Insert Beautiful New Comics with Generated Art
INSERT IGNORE INTO comics (id, creator_id, title, description, cover_image_url, status) VALUES 
(1, 2, 'Echoes of You', 'Two lovers separated by time find each other again under the eternal cherry blossoms.', 'images/cover_romance.png', 'APPROVED'),
(2, 2, 'Blade of the Neon King', 'A lone swordsman fights against corrupt mega-corporations in a cyberpunk dystopia.', 'images/cover_action.png', 'APPROVED'),
(3, 2, 'The Midnight Protocol', 'A detective with a cursed eye unravels the darkest secrets of the city.', 'images/cover_thriller.png', 'APPROVED');

-- Insert Mock Episodes for one of the comics
INSERT IGNORE INTO episodes (id, comic_id, episode_number, title, images_json, is_locked, price) VALUES 
(1, 2, 1, 'The Awakening', '["images/ep1_panel1.png", "images/ep1_panel2.png"]', FALSE, 0),
(2, 2, 2, 'First Blood (Locked)', '["images/ep1_panel1.png", "images/ep1_panel2.png"]', TRUE, 5);
