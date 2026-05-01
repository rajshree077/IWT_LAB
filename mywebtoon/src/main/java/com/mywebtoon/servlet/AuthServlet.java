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
import java.sql.ResultSet;

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String username = request.getParameter("username");
        String password = request.getParameter("password"); // Remember to hash in prod

        try (Connection conn = DBConnection.getConnection()) {
            if ("login".equals(action)) {
                String sql = "SELECT * FROM users WHERE username = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, username);
                    ResultSet rs = stmt.executeQuery();
                    if (rs.next()) {
                        String storedHash = rs.getString("password");
                        // Compatibility with old admin or non-bcrypt plaintext passwords if lengths differ or format differs (optional), but let's strictly enforce BCrypt or fallback:
                        boolean passwordMatch = false;
                        if(storedHash.startsWith("$2a$")) {
                            passwordMatch = org.mindrot.jbcrypt.BCrypt.checkpw(password, storedHash);
                        } else {
                            passwordMatch = storedHash.equals(password);
                        }

                        if (passwordMatch) {
                            HttpSession session = request.getSession();
                            session.setAttribute("userId", rs.getInt("id"));
                            session.setAttribute("user", rs.getString("username"));
                            session.setAttribute("role", rs.getString("role"));
                            session.setAttribute("wallet", rs.getInt("wallet_balance"));
                            response.sendRedirect(request.getContextPath() + "/home");
                        } else {
                            response.sendRedirect(request.getContextPath() + "/login.jsp?error=invalid");
                        }
                    } else {
                        response.sendRedirect(request.getContextPath() + "/login.jsp?error=invalid");
                    }
                }
            } else if ("register".equals(action)) {
                // Role defaults to USER, but user can choose Creator role in form via 'role' parameter
                String roleParam = request.getParameter("role");
                String role = ("CREATOR".equals(roleParam)) ? "CREATOR" : "USER";

                String hashedPassword = org.mindrot.jbcrypt.BCrypt.hashpw(password, org.mindrot.jbcrypt.BCrypt.gensalt());

                String sql = "INSERT INTO users (username, password, role, wallet_balance) VALUES (?, ?, ?, 200)";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, username);
                    stmt.setString(2, hashedPassword);
                    stmt.setString(3, role);
                    stmt.executeUpdate();
                    response.sendRedirect(request.getContextPath() + "/login.jsp?success=registered");
                } catch (Exception e) {
                    response.sendRedirect(request.getContextPath() + "/register.jsp?error=exists");
                }
            } else if ("logout".equals(action)) {
                request.getSession().invalidate();
                response.sendRedirect(request.getContextPath() + "/home");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}
