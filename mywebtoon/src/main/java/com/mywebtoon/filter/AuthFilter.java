package com.mywebtoon.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);
        
        String path = req.getRequestURI().substring(req.getContextPath().length());
        String role = (session != null) ? (String) session.getAttribute("role") : null;

        // Protective Routes
        boolean isCreatorRoute = path.contains("creatorDashboard") || path.contains("/creator/");
        boolean isAdminRoute = path.contains("adminDashboard") || path.contains("/admin/");
        
        if (isCreatorRoute && (role == null || (!role.equals("CREATOR") && !role.equals("ADMIN")))) {
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }

        if (isAdminRoute && (role == null || !role.equals("ADMIN"))) {
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
