USE mywebtoon_db;

-- Add 4 brand new comics to the system!
-- Since our AI image generator hit its safety cooldown earlier, we are using a dynamic image service (LoremFlickr) 
-- that will perfectly inject completely unique anime/fantasy images for each new cover!

INSERT IGNORE INTO comics (id, creator_id, title, description, cover_image_url, status) VALUES 
(8, (SELECT id FROM users WHERE username = 'Sakura_Studios'), 'True Beauty', 'After watching a ton of beauty videos online, a shy comic book fan masters the art of make-up.', 'https://loremflickr.com/250/350/anime,girl?lock=10', 'APPROVED'),
(9, (SELECT id FROM users WHERE username = 'Neon_Ink_Studio'), 'Lore Olympus', 'Witness what the gods do after dark in this modern retelling of Hades and Persephone.', 'https://loremflickr.com/250/350/greece,neon?lock=11', 'APPROVED'),
(10, (SELECT id FROM users WHERE username = 'Action_Webtoons'), 'UnOrdinary', 'A teenager at a high school where the social elite possess powers.', 'https://loremflickr.com/250/350/hero,anime?lock=12', 'APPROVED'),
(11, (SELECT id FROM users WHERE username = 'Noir_Illustrations'), 'Tower of God', 'Welcome to the Tower. What do you desire? Money and wealth? Honor and pride?', 'https://loremflickr.com/250/350/tower,fantasy?lock=25', 'APPROVED');
