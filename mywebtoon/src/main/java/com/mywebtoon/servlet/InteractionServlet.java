package com.mywebtoon.servlet;

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

@WebServlet("/interact")
public class InteractionServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String action = request.getParameter("action");
        String episodeIdStr = request.getParameter("episodeId");
        int episodeId = 0;
        if (episodeIdStr != null && !episodeIdStr.trim().isEmpty()) {
            try { episodeId = Integer.parseInt(episodeIdStr); } catch (Exception e) {}
        }

        try (Connection conn = DBConnection.getConnection()) {
            if ("like".equals(action)) {
                String sql = "INSERT IGNORE INTO likes (user_id, episode_id) VALUES (?, ?)";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setInt(1, userId);
                    stmt.setInt(2, episodeId);
                    stmt.executeUpdate();
                }
            } else if ("unlike".equals(action)) {
                String sql = "DELETE FROM likes WHERE user_id = ? AND episode_id = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setInt(1, userId);
                    stmt.setInt(2, episodeId);
                    stmt.executeUpdate();
                }
            } else if ("comment".equals(action)) {
                String content = request.getParameter("content");
                String sql = "INSERT INTO comments (user_id, episode_id, content) VALUES (?, ?, ?)";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setInt(1, userId);
                    stmt.setInt(2, episodeId);
                    stmt.setString(3, content);
                    stmt.executeUpdate();
                }
            } else if ("purchase".equals(action)) {
                // Simplified purchase logic: deduct from wallet
                int price = Integer.parseInt(request.getParameter("price"));
                int currentWallet = (Integer) session.getAttribute("wallet");
                
                if (currentWallet >= price) {
                    conn.setAutoCommit(false);
                    try {
                        // Insert purchase
                        PreparedStatement pStmt = conn.prepareStatement("INSERT INTO purchases (user_id, episode_id, coins_spent) VALUES (?, ?, ?)");
                        pStmt.setInt(1, userId);
                        pStmt.setInt(2, episodeId);
                        pStmt.setInt(3, price);
                        pStmt.executeUpdate();

                        // Deduct wallet
                        PreparedStatement pWallet = conn.prepareStatement("UPDATE users SET wallet_balance = wallet_balance - ? WHERE id = ?");
                        pWallet.setInt(1, price);
                        pWallet.setInt(2, userId);
                        pWallet.executeUpdate();

                        conn.commit();
                        session.setAttribute("wallet", currentWallet - price);
                    } catch (Exception e) {
                        conn.rollback();
                        throw e;
                    } finally {
                        conn.setAutoCommit(true);
                    }
                } else {
                    response.sendRedirect(request.getHeader("Referer") + "&error=insufficient_funds");
                    return;
                }
            } else if ("subscribe".equals(action)) {
                String comicIdStr = request.getParameter("comicId");
                if (comicIdStr != null) {
                    String sql = "INSERT IGNORE INTO subscriptions (user_id, comic_id) VALUES (?, ?)";
                    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                        stmt.setInt(1, userId);
                        stmt.setInt(2, Integer.parseInt(comicIdStr));
                        stmt.executeUpdate();
                    }
                }
            } else if ("unsubscribe".equals(action)) {
                String comicIdStr = request.getParameter("comicId");
                if (comicIdStr != null) {
                    String sql = "DELETE FROM subscriptions WHERE user_id = ? AND comic_id = ?";
                    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                        stmt.setInt(1, userId);
                        stmt.setInt(2, Integer.parseInt(comicIdStr));
                        stmt.executeUpdate();
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        response.sendRedirect(request.getHeader("Referer"));
    }
}
