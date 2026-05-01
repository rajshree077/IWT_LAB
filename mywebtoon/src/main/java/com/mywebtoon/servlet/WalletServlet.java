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

@WebServlet("/wallet")
public class WalletServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        request.getRequestDispatcher("/wallet.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int amount = Integer.parseInt(request.getParameter("amount"));
        int userId = (Integer) session.getAttribute("userId");
        int currentWallet = (Integer) session.getAttribute("wallet");
        
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE users SET wallet_balance = wallet_balance + ? WHERE id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, amount);
                stmt.setInt(2, userId);
                stmt.executeUpdate();
            }
            session.setAttribute("wallet", currentWallet + amount);
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("wallet?success=true&added=" + amount);
    }
}
