<%@ page contentType="text/plain;charset=UTF-8" language="java" %>
<%@ page import="com.mywebtoon.util.DBConnection, java.sql.*" %>
<%
    try (Connection conn = DBConnection.getConnection()) {
        try (Statement stmt = conn.createStatement()) {
            // 1. Add Genre column
            stmt.executeUpdate("ALTER TABLE comics ADD COLUMN IF NOT EXISTS genre VARCHAR(50) DEFAULT 'FANTASY'");
            
            // 2. Assign Random Genres to our 10 existing Comics
            String[] genres = {"FANTASY", "ROMANCE", "ACTION", "THRILLER", "COMEDY"};
            ResultSet rs = stmt.executeQuery("SELECT id FROM comics");
            java.util.List<Integer> ids = new java.util.ArrayList<>();
            while (rs.next()) ids.add(rs.getInt("id"));
            
            int count = 0;
            for (Integer id : ids) {
                String genre = genres[count % genres.length];
                try(PreparedStatement ps = conn.prepareStatement("UPDATE comics SET genre = ? WHERE id = ?")) {
                    ps.setString(1, genre);
                    ps.setInt(2, id);
                    ps.executeUpdate();
                }
                count++;
            }
            
            out.println("SUCCESS: Genre column added and seeded " + count + " comics with assigned genres!");
        }
    } catch (Exception e) {
        e.printStackTrace(new java.io.PrintWriter(out));
    }
%>
