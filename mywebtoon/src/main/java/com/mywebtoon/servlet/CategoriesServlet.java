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

@WebServlet("/categories")
public class CategoriesServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Comic> comics = new ArrayList<>();
        String genre = request.getParameter("genre");
        
        // Default to FANTASY if no genre provided
        if (genre == null || genre.trim().isEmpty()) {
            genre = "FANTASY";
        }
        
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT c.*, u.username as author_name FROM comics c JOIN users u ON c.creator_id = u.id WHERE c.status = 'APPROVED' AND c.genre = ? ORDER BY c.title ASC";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, genre.toUpperCase());
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    Comic comic = new Comic();
                    comic.setId(rs.getInt("id"));
                    comic.setTitle(rs.getString("title"));
                    comic.setDescription(rs.getString("description"));
                    comic.setCoverImageUrl(rs.getString("cover_image_url"));
                    comic.setAuthorName(rs.getString("author_name"));
                    // comic.setGenre(rs.getString("genre"));
                    comics.add(comic);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        request.setAttribute("comics", comics);
        request.setAttribute("currentGenre", genre.toUpperCase());
        request.getRequestDispatcher("/categories.jsp").forward(request, response);
    }
}
