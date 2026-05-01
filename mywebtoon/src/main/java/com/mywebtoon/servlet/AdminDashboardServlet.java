package com.mywebtoon.servlet;

import com.mywebtoon.model.Comic;
import com.mywebtoon.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/adminDashboard")
public class AdminDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Comic> pendingComics = new ArrayList<>();
        int totalUsers = 0;
        int totalRevenue = 0;

        try (Connection conn = DBConnection.getConnection()) {
            // Get Pending
            String sqlPending = "SELECT c.*, u.username as author_name FROM comics c JOIN users u ON c.creator_id = u.id WHERE c.status = 'PENDING'";
            try (PreparedStatement stmt = conn.prepareStatement(sqlPending)) {
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    Comic comic = new Comic();
                    comic.setId(rs.getInt("id"));
                    comic.setTitle(rs.getString("title"));
                    comic.setAuthorName(rs.getString("author_name"));
                    pendingComics.add(comic);
                }
            }

            // Stats
            try (PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) FROM users")) {
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) totalUsers = rs.getInt(1);
            }
            try (PreparedStatement stmt = conn.prepareStatement("SELECT SUM(coins_spent) FROM purchases")) {
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) totalRevenue = rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        
        request.setAttribute("pendingComics", pendingComics);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalRevenue", totalRevenue);
        request.getRequestDispatcher("/adminDashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        int comicId = Integer.parseInt(request.getParameter("comicId"));

        try (Connection conn = DBConnection.getConnection()) {
            String status = "approve".equals(action) ? "APPROVED" : "REJECTED";
            String sql = "UPDATE comics SET status = ? WHERE id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, status);
                stmt.setInt(2, comicId);
                stmt.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/adminDashboard");
    }
}
