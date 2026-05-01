package com.mywebtoon.servlet;

import com.mywebtoon.model.Comic;
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
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@WebServlet("/comic")
public class ComicServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect("explore");
            return;
        }

        int comicId = Integer.parseInt(idParam);
        Comic comic = null;
        List<Episode> episodes = new ArrayList<>();
        Set<Integer> purchasedEpisodeIds = new HashSet<>();

        HttpSession session = request.getSession(false);
        Integer userId = (session != null && session.getAttribute("userId") != null) ? (Integer) session.getAttribute("userId") : null;
        boolean isSubscribed = false;
        double avgRating = 0.0;

        try (Connection conn = DBConnection.getConnection()) {
            // Get Comic details
            String sqlComic = "SELECT c.*, u.username as author_name FROM comics c JOIN users u ON c.creator_id = u.id WHERE c.id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sqlComic)) {
                stmt.setInt(1, comicId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    comic = new Comic();
                    comic.setId(rs.getInt("id"));
                    comic.setTitle(rs.getString("title"));
                    comic.setDescription(rs.getString("description"));
                    comic.setCoverImageUrl(rs.getString("cover_image_url"));
                    comic.setAuthorName(rs.getString("author_name"));
                }
            }

            // Get Episodes
            String sqlEpisodes = "SELECT * FROM episodes WHERE comic_id = ? ORDER BY episode_number ASC";
            try (PreparedStatement stmt = conn.prepareStatement(sqlEpisodes)) {
                stmt.setInt(1, comicId);
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    Episode ep = new Episode();
                    ep.setId(rs.getInt("id"));
                    ep.setEpisodeNumber(rs.getInt("episode_number"));
                    ep.setTitle(rs.getString("title"));
                    ep.setLocked(rs.getBoolean("is_locked"));
                    ep.setPrice(rs.getInt("price"));
                    ep.setCreatedAt(rs.getTimestamp("created_at"));
                    episodes.add(ep);
                }
            }
            // If user is logged in, fetch their purchased episodes & subscription state
            String sqlRating = "SELECT AVG(score) FROM comic_ratings WHERE comic_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sqlRating)) {
                stmt.setInt(1, comicId);
                ResultSet rs = stmt.executeQuery();
                if(rs.next()) {
                    avgRating = rs.getDouble(1);
                }
            }

            if (userId != null) {
                String sqlPurchases = "SELECT episode_id FROM purchases WHERE user_id = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sqlPurchases)) {
                    stmt.setInt(1, userId);
                    ResultSet rs = stmt.executeQuery();
                    while (rs.next()) {
                        purchasedEpisodeIds.add(rs.getInt("episode_id"));
                    }
                }
                
                String sqlSub = "SELECT id FROM subscriptions WHERE user_id = ? AND comic_id = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sqlSub)) {
                    stmt.setInt(1, userId);
                    stmt.setInt(2, comicId);
                    ResultSet rs = stmt.executeQuery();
                    if (rs.next()) {
                        isSubscribed = true;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("comic", comic);
        request.setAttribute("episodes", episodes);
        request.setAttribute("purchasedEpisodeIds", purchasedEpisodeIds);
        request.setAttribute("isSubscribed", isSubscribed);
        request.setAttribute("avgRating", avgRating == 0.0 ? "9.8" : String.format("%.1f", avgRating)); // default 9.8 if no rating
        request.getRequestDispatcher("/comic.jsp").forward(request, response);
    }
}
