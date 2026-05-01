package com.mywebtoon.servlet;

import com.mywebtoon.model.Episode;
import com.mywebtoon.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/reader")
public class ReaderServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect("explore");
            return;
        }

        int episodeId = Integer.parseInt(idParam);
        Episode episode = null;
        boolean hasAccess = true; // assume true initially

        HttpSession session = request.getSession(false);
        Integer userId = (session != null && session.getAttribute("userId") != null) ? (Integer) session.getAttribute("userId") : null;
        String role = (session != null) ? (String) session.getAttribute("role") : null;

        try (Connection conn = DBConnection.getConnection()) {
            // Fetch episode
            String sql = "SELECT * FROM episodes WHERE id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, episodeId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    episode = new Episode();
                    episode.setId(rs.getInt("id"));
                    episode.setComicId(rs.getInt("comic_id"));
                    episode.setEpisodeNumber(rs.getInt("episode_number"));
                    episode.setTitle(rs.getString("title"));
                    episode.setImagesJson(rs.getString("images_json"));
                    episode.setLocked(rs.getBoolean("is_locked"));
                    episode.setPrice(rs.getInt("price"));
                }
            }

            // Check lock logic
            if (episode != null && episode.isLocked() && !"ADMIN".equals(role)) {
                hasAccess = false;
                if (userId != null) {
                    // Check if purchased
                    String chk = "SELECT id FROM purchases WHERE user_id = ? AND episode_id = ?";
                    try (PreparedStatement stmt = conn.prepareStatement(chk)) {
                        stmt.setInt(1, userId);
                        stmt.setInt(2, episodeId);
                        if (stmt.executeQuery().next()) {
                            hasAccess = true;
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (episode == null) {
            response.sendRedirect("explore");
            return;
        }

        if (!hasAccess) {
            // Redirect back to comic page with an error or show purchase prompt
            response.sendRedirect("comic?id=" + episode.getComicId() + "&error=locked");
            return;
        }

        // Fetch Comments
        java.util.List<java.util.Map<String, String>> commentsList = new java.util.ArrayList<>();
        int likeCount = 0;
        boolean hasLiked = false;
        try (Connection conn = DBConnection.getConnection()) {
            // Comments
            String cSql = "SELECT c.content, c.created_at, u.username FROM comments c JOIN users u ON c.user_id = u.id WHERE c.episode_id = ? ORDER BY c.created_at DESC";
            try (PreparedStatement cStmt = conn.prepareStatement(cSql)) {
                cStmt.setInt(1, episodeId);
                ResultSet cRs = cStmt.executeQuery();
                while (cRs.next()) {
                    java.util.Map<String, String> comment = new java.util.HashMap<>();
                    comment.put("content", cRs.getString("content"));
                    comment.put("username", cRs.getString("username"));
                    comment.put("created_at", cRs.getString("created_at"));
                    commentsList.add(comment);
                }
            }
            // Like Count
            String lCountSql = "SELECT COUNT(*) FROM likes WHERE episode_id = ?";
            try (PreparedStatement lStmt = conn.prepareStatement(lCountSql)) {
                lStmt.setInt(1, episodeId);
                ResultSet lRs = lStmt.executeQuery();
                if(lRs.next()) likeCount = lRs.getInt(1);
            }
            // Has Liked
            if (userId != null) {
                String hlSql = "SELECT id FROM likes WHERE user_id = ? AND episode_id = ?";
                try (PreparedStatement hlStmt = conn.prepareStatement(hlSql)) {
                    hlStmt.setInt(1, userId);
                    hlStmt.setInt(2, episodeId);
                    if(hlStmt.executeQuery().next()) hasLiked = true;
                }
            }
        } catch (Exception e) {}

        request.setAttribute("episode", episode);
        request.setAttribute("commentsList", commentsList);
        request.setAttribute("likeCount", likeCount);
        request.setAttribute("hasLiked", hasLiked);
        request.getRequestDispatcher("/readEpisode.jsp").forward(request, response);
    }
}
