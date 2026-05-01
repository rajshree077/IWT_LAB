<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Explore - MyWebtoon</title>
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
                <a href="library">LIBRARY</a>
            </div>
        </div>
        <div class="nav-right-links">
            <form action="explore" method="GET" style="display:inline; margin-right: 15px;">
                <input type="text" name="search" placeholder="Search series..." style="padding: 6px 12px; border-radius: 20px; border: 1px solid rgba(255,255,255,0.2); background: rgba(0,0,0,0.3); color: white; outline: none; font-size: 0.85rem; width: 180px;">
                <button type="submit" style="display:none;"></button>
            </form>
            <% if(session.getAttribute("user") != null) { %>
                <a href="wallet" class="user-pill" style="text-decoration:none;"><%= session.getAttribute("user") %> | 🪙 <%= session.getAttribute("wallet") %></a>
                <a href="library" class="nav-sub-link">Library</a>
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
        <c:choose>
            <c:when test="${not empty param.search}">
                <h2 style="font-size: 1.8rem; margin-bottom: 15px;">Search Results for '${param.search}'</h2>
            </c:when>
            <c:otherwise>
                <h2 style="font-size: 1.8rem; margin-bottom: 15px;">Explore All Comics</h2>
            </c:otherwise>
        </c:choose>

        <c:if test="${empty comics}">
            <p style="color:#64748b; padding:2rem; background:rgba(255,255,255,0.05); border-radius:10px;">No comic found of such name.</p>
        </c:if>

        <c:if test="${not empty comics}">
        <div class="comic-section">
            <button class="scroll-btn left" onclick="document.getElementById('explore-grid').scrollBy({left: -600, behavior: 'smooth'})">&#10094;</button>
            <div class="comic-grid" id="explore-grid" style="flex-wrap: wrap; overflow-x: visible;">
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
        </div>
        </c:if>
    </main>
</body>
</html>
