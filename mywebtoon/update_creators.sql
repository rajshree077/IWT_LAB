USE mywebtoon_db;

-- Insert new unique creators (ignoring if they somehow already exist)
INSERT IGNORE INTO users (username, password, role) VALUES ('Sakura_Studios', 'password', 'CREATOR');
INSERT IGNORE INTO users (username, password, role) VALUES ('Neon_Ink_Studio', 'password', 'CREATOR');
INSERT IGNORE INTO users (username, password, role) VALUES ('Noir_Illustrations', 'password', 'CREATOR');

-- Update the comics to assign these completely new unique creators
UPDATE comics SET creator_id = (SELECT id FROM users WHERE username = 'Sakura_Studios') WHERE title = 'Echoes of You';
UPDATE comics SET creator_id = (SELECT id FROM users WHERE username = 'Neon_Ink_Studio') WHERE title = 'Blade of the Neon King';
UPDATE comics SET creator_id = (SELECT id FROM users WHERE username = 'Noir_Illustrations') WHERE title = 'The Midnight Protocol';
