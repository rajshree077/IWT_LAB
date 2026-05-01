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

@WebServlet("/creatorDashboard")
public class CreatorDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        int creatorId = (Integer) session.getAttribute("userId");
        List<Comic> myComics = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM comics WHERE creator_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, creatorId);
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    Comic comic = new Comic();
                    comic.setId(rs.getInt("id"));
                    comic.setTitle(rs.getString("title"));
                    comic.setStatus(rs.getString("status"));
                    comic.setCoverImageUrl(rs.getString("cover_image_url"));
                    myComics.add(comic);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        request.setAttribute("myComics", myComics);
        request.getRequestDispatcher("/creatorDashboard.jsp").forward(request, response);
    }
}
