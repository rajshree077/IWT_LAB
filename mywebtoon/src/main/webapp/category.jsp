<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.mywebtoon.model.Comic, com.mywebtoon.util.DBConnection, java.sql.*, java.util.*" %>
<%
    String categoryName = request.getParameter("name");
    if(categoryName == null) categoryName = "Category";

    List<Comic> comics = new ArrayList<>();
    try (Connection conn = DBConnection.getConnection()) {
        // Fetch comics out of DB (simulating the category filter by just fetching all or a random subset)
        String sql = "SELECT c.*, u.username as author_name FROM comics c JOIN users u ON c.creator_id = u.id WHERE c.status = 'APPROVED' ORDER BY RAND()";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
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
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title><%= categoryName %> Series - MyWebtoon</title>
    <link rel="stylesheet" href="css/style.css?v=4">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
</head>
<body class="dark-theme">
    <nav class="navbar">
        <div style="display: flex; align-items: center; gap: 30px;">
            <a href="home" class="logo">MyWebtoon</a>
            <div class="nav-main-links">
                <a href="explore">ORIGINALS</a>
                <a href="explore">CATEGORIES</a>
                <a href="explore">RANKINGS</a>
                <a href="explore">CANVAS</a>
            </div>
        </div>
        <div class="nav-right-links">
            <% if(session.getAttribute("user") != null) { %>
                <span class="user-pill"><%= session.getAttribute("user") %></span>
                <% if ("ADMIN".equals(session.getAttribute("role"))) { %>
                    <a href="adminDashboard" class="nav-sub-link">Admin</a>
                <% } %>
                <form action="auth" method="post" style="display:inline; margin-left: 5px;">
                    <input type="hidden" name="action" value="logout">
                    <button type="submit" class="nav-icon-btn">Logout</button>
                </form>
            <% } else { %>
                <a href="login.jsp" class="user-pill" style="text-decoration:none; display:inline-block;">Log In</a>
            <% } %>
        </div>
    </nav>

    <main class="container">
        <h2 style="font-size: 1.8rem; margin-bottom: 15px; color:#e21b70;"><%= categoryName %> Series</h2>
        <p style="color: #94a3b8; margin-bottom: 25px;">Discover the best stories in our <%= categoryName %> section.</p>
        
        <div class="comic-section">
            <button class="scroll-btn left" onclick="document.getElementById('category-grid').scrollBy({left: -600, behavior: 'smooth'})">&#10094;</button>
            <div class="comic-grid" id="category-grid">
                <c:forEach var="comic" items="${comics}">
                    <a href="comic?id=${comic.id}" class="comic-card">
                        <div class="comic-img-wrapper">
                            <img src="${comic.coverImageUrl != null ? comic.coverImageUrl : 'https://via.placeholder.com/200x300'}" alt="${comic.title}">
                        </div>
                        <div class="comic-info">
                            <h3>${comic.title}</h3>
                            <p>By ${comic.authorName}</p>
                        </div>
                    </a>
                </c:forEach>
            </div>
            <button class="scroll-btn right" onclick="document.getElementById('category-grid').scrollBy({left: 600, behavior: 'smooth'})">&#10095;</button>
        </div>
    </main>
</body>
</html>
