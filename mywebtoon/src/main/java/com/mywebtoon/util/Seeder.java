package com.mywebtoon.util;

import java.sql.Connection;
import java.sql.Statement;

public class Seeder {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            String[] queries = {
                "INSERT IGNORE INTO users (username, password, role) VALUES ('Studio_Ghibli_Fan', 'password', 'CREATOR')",
                "INSERT IGNORE INTO users (username, password, role) VALUES ('Comedy_Central', 'password', 'CREATOR')",
                "INSERT INTO comics (creator_id, title, description, cover_image_url, status, genre) VALUES ((SELECT id FROM users WHERE username = 'Studio_Ghibli_Fan'), 'Spirited Away: Echoes', 'A continuation of the beloved story.', 'images/cover_romance.png', 'APPROVED', 'FANTASY')",
                "INSERT INTO comics (creator_id, title, description, cover_image_url, status, genre) VALUES ((SELECT id FROM users WHERE username = 'Comedy_Central'), 'Life of a Coder', 'The daily struggles of a software engineer.', 'images/cover_comedy.png', 'APPROVED', 'COMEDY')",
                "INSERT INTO comics (creator_id, title, description, cover_image_url, status, genre) VALUES ((SELECT id FROM users WHERE username = 'Action_Webtoons'), 'Solo Leveling Up', 'The weakest hunter becomes the strongest.', 'images/cover_action.png', 'APPROVED', 'ACTION')",
                "INSERT INTO comics (creator_id, title, description, cover_image_url, status, genre) VALUES ((SELECT id FROM users WHERE username = 'Noir_Illustrations'), 'Detective Conan: Next Gen', 'A new genius detective appears in Tokyo.', 'images/cover_thriller.png', 'APPROVED', 'THRILLER')",
                "INSERT INTO comics (creator_id, title, description, cover_image_url, status, genre) VALUES ((SELECT id FROM users WHERE username = 'Duke_Translations'), 'The Villainess''s Secret', 'She isn''t evil, she just wants a quiet life.', 'images/cover_romance.png', 'APPROVED', 'ROMANCE')"
            };

            for (String sql : queries) {
                stmt.addBatch(sql);
            }
            
            int[] results = stmt.executeBatch();
            System.out.println("Seeded " + results.length + " queries successfully.");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
