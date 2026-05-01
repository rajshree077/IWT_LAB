<%@ page contentType="text/plain;charset=UTF-8" language="java" %>
<%@ page import="com.mywebtoon.util.DBConnection, java.sql.*, java.util.*" %>
<%
    try (Connection conn = DBConnection.getConnection()) {
        List<Integer> comicIds = new ArrayList<>();
        try (PreparedStatement stmt = conn.prepareStatement("SELECT id FROM comics")) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                comicIds.add(rs.getInt("id"));
            }
        }
        
        String insertSql = "INSERT INTO episodes (comic_id, episode_number, title, images_json, is_locked, price) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement countStmt = conn.prepareStatement("SELECT COUNT(*) FROM episodes WHERE comic_id = ?");
             PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
            
            int totalInserted = 0;
            for (Integer cid : comicIds) {
                countStmt.setInt(1, cid);
                ResultSet crs = countStmt.executeQuery();
                crs.next();
                int existingCount = crs.getInt(1);
                
                for (int i = existingCount + 1; i <= 5; i++) {
                    insertStmt.setInt(1, cid);
                    insertStmt.setInt(2, i);
                    insertStmt.setString(3, "Episode " + i);
                    
                    // Simple placeholder panels
                    String json = "[\"https://via.placeholder.com/800x1200?text=Panel+1\",\"https://via.placeholder.com/800x1200?text=Panel+2\",\"https://via.placeholder.com/800x1200?text=Panel+3\"]";
                    insertStmt.setString(4, json);
                    
                    // Make episodes 4 and 5 locked so users can test Fast Pass Wallet!
                    boolean locked = (i >= 4);
                    insertStmt.setBoolean(5, locked);
                    insertStmt.setInt(6, locked ? 5 : 0); // 5 Coins to unlock
                    
                    insertStmt.executeUpdate();
                    totalInserted++;
                }
            }
            out.println("SEED SUCCESS: Inserted " + totalInserted + " new episodes across all comics to ensure every comic has up to 5 episodes!");
        }
    } catch (Exception e) {
        e.printStackTrace(new java.io.PrintWriter(out));
    }
%>
