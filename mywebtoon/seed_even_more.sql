USE mywebtoon_db;

INSERT IGNORE INTO users (username, password, role) VALUES ('Studio_Ghibli_Fan', 'password', 'CREATOR');
INSERT IGNORE INTO users (username, password, role) VALUES ('Comedy_Central', 'password', 'CREATOR');

-- Insert 5 more comics
INSERT INTO comics (creator_id, title, description, cover_image_url, status, genre) VALUES 
((SELECT id FROM users WHERE username = 'Studio_Ghibli_Fan'), 'Spirited Away: Echoes', 'A continuation of the beloved story.', 'images/cover_romance.png', 'APPROVED', 'FANTASY'),
((SELECT id FROM users WHERE username = 'Comedy_Central'), 'Life of a Coder', 'The daily struggles of a software engineer.', 'images/cover_comedy.png', 'APPROVED', 'COMEDY'),
((SELECT id FROM users WHERE username = 'Action_Webtoons'), 'Solo Leveling Up', 'The weakest hunter becomes the strongest.', 'images/cover_action.png', 'APPROVED', 'ACTION'),
((SELECT id FROM users WHERE username = 'Noir_Illustrations'), 'Detective Conan: Next Gen', 'A new genius detective appears in Tokyo.', 'images/cover_thriller.png', 'APPROVED', 'THRILLER'),
((SELECT id FROM users WHERE username = 'Duke_Translations'), 'The Villainess''s Secret', 'She isn''t evil, she just wants a quiet life.', 'images/cover_romance.png', 'APPROVED', 'ROMANCE');
