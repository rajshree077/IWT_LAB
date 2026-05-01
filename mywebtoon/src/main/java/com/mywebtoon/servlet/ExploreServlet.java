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

@WebServlet("/explore")
public class ExploreServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Comic> comics = new ArrayList<>();
        String searchQuery = request.getParameter("search");
        
        try (Connection conn = DBConnection.getConnection()) {
            StringBuilder sql = new StringBuilder("SELECT c.*, u.username as author_name FROM comics c JOIN users u ON c.creator_id = u.id WHERE c.status = 'APPROVED'");
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                sql.append(" AND c.title LIKE ?");
            }
            sql.append(" ORDER BY c.title ASC");

            try (PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
                if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                    stmt.setString(1, "%" + searchQuery.trim() + "%");
                }
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
        request.getRequestDispatcher("/browse.jsp").forward(request, response);
    }
}
