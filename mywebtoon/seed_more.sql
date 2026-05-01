USE mywebtoon_db;

INSERT IGNORE INTO users (username, password, role) VALUES ('Duke_Translations', 'password', 'CREATOR');
INSERT IGNORE INTO users (username, password, role) VALUES ('Action_Webtoons', 'password', 'CREATOR');

-- Add 4 more mock comics to fill out the grid!
-- We reuse the generated image assets but use unique names so they look distinct.
INSERT IGNORE INTO comics (id, creator_id, title, description, cover_image_url, status) VALUES 
(4, (SELECT id FROM users WHERE username = 'Duke_Translations'), 'The Villainess Returns', 'A classic reincarnation story with a handsome duke.', 'images/cover_duke.png', 'APPROVED'),
(5, (SELECT id FROM users WHERE username = 'Neon_Ink_Studio'), 'Omniscient Player 99', 'Only he knows the ending to the apocalypse.', 'images/cover_action.png', 'APPROVED'),
(6, (SELECT id FROM users WHERE username = 'Action_Webtoons'), 'High School Mercenary', 'The strongest agent returns to school.', 'images/ep1_panel2.png', 'APPROVED'),
(7, (SELECT id FROM users WHERE username = 'Noir_Illustrations'), 'Sweet Home', 'Survival thriller in a monster infested apartment building.', 'images/cover_thriller.png', 'APPROVED');
