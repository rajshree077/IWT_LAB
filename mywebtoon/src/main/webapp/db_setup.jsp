<%@ page contentType="text/plain;charset=UTF-8" language="java" %>
<%@ page import="com.mywebtoon.util.DBConnection, java.sql.*" %>
<%
    try (Connection conn = DBConnection.getConnection(); Statement stmt = conn.createStatement()) {
        stmt.execute("CREATE TABLE IF NOT EXISTS subscriptions (id INT AUTO_INCREMENT PRIMARY KEY, user_id INT NOT NULL, comic_id INT NOT NULL, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE, FOREIGN KEY (comic_id) REFERENCES comics(id) ON DELETE CASCADE, UNIQUE(user_id, comic_id));");
        stmt.execute("CREATE TABLE IF NOT EXISTS comic_ratings (id INT AUTO_INCREMENT PRIMARY KEY, user_id INT NOT NULL, comic_id INT NOT NULL, score DECIMAL(3,1) NOT NULL, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE, FOREIGN KEY (comic_id) REFERENCES comics(id) ON DELETE CASCADE, UNIQUE(user_id, comic_id));");
        // We will NOT TRUNCATE users unless needed, maybe just clear out if BCrypt fails. Wait, truncate involves foreign key constraints, which will fail if there are comics.
        // Actually, deleting all users fails if comics exist due to foreign key referencing users(id). 
        // We should instead update the password format later or just drop schema and run everything via seed.
        out.println("SUCCESS");
    } catch (Exception e) {
        e.printStackTrace(new java.io.PrintWriter(out));
    }
%>
