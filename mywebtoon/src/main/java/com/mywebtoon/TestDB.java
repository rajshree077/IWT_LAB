package com.mywebtoon;

import com.mywebtoon.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class TestDB {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT id, title, cover_image_url FROM comics";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    System.out.println("ID: " + rs.getInt("id") + " | Title: " + rs.getString("title") + " | ImageURL: " + rs.getString("cover_image_url"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
