<%@ page contentType="text/plain;charset=UTF-8" language="java" %>
<%@ page import="com.mywebtoon.util.DBConnection, java.sql.*" %>
<%
    try (Connection conn = DBConnection.getConnection()) {
        String updateSql = "UPDATE episodes SET images_json = '[\"https://placehold.co/800x1200/png?text=Chapter+Panel+1\", \"https://placehold.co/800x1200/png?text=Chapter+Panel+2\", \"https://placehold.co/800x1200/png?text=Chapter+Panel+3\"]'";
        try (PreparedStatement stmt = conn.prepareStatement(updateSql)) {
            int rows = stmt.executeUpdate();
            out.println("SUCCESS: Updated images for " + rows + " episodes to use placehold.co instead of via.placeholder.com");
        }
    } catch (Exception e) {
        e.printStackTrace(new java.io.PrintWriter(out));
    }
%>
