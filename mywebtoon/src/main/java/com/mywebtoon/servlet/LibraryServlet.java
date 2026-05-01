package com.mywebtoon.servlet;

import com.mywebtoon.model.Comic;
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
import java.util.List;

@WebServlet("/library")
public class LibraryServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int userId = (Integer) session.getAttribute("userId");
        List<Comic> comics = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT c.*, u.username as author_name FROM comics c " +
                         "JOIN subscriptions s ON c.id = s.comic_id " +
                         "JOIN users u ON c.creator_id = u.id " +
                         "WHERE s.user_id = ? ORDER BY s.created_at DESC";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, userId);
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    Comic comic = new Comic();
                    comic.setId(rs.getInt("id"));
                    comic.setTitle(rs.getString("title"));
                    comic.setDescription(rs.getString("description"));
                    comic.setCoverImageUrl(rs.getString("cover_image_url"));
                    comic.setAuthorName(rs.getString("author_name"));
                    comics.add(comic);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        request.setAttribute("comics", comics);
        request.getRequestDispatcher("/library.jsp").forward(request, response);
    }
}
