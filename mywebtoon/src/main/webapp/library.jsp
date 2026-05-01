<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Library - MyWebtoon</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
</head>
<body class="dark-theme">
    <nav class="navbar">
        <div style="display: flex; align-items: center; gap: 30px;">
            <a href="home" class="logo">MyWebtoon</a>
            <div class="nav-main-links">
                <a href="explore">ORIGINALS</a>
                <a href="explore">CATEGORIES</a>
                <a href="library" style="color:white; font-weight:700;">LIBRARY</a>
            </div>
        </div>
        <div class="nav-right-links">
            <form action="explore" method="GET" style="display:inline; margin-right: 15px;">
                <input type="text" name="search" placeholder="Search series..." style="padding: 6px 12px; border-radius: 20px; border: 1px solid rgba(255,255,255,0.2); background: rgba(0,0,0,0.3); color: white; outline: none; font-size: 0.85rem; width: 180px;">
                <button type="submit" style="display:none;"></button>
            </form>
            <% if(session.getAttribute("user") != null) { %>
                <a href="wallet" class="user-pill" style="text-decoration:none;"><%= session.getAttribute("user") %> | 🪙 <%= session.getAttribute("wallet") %></a>
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
        <h2 style="font-size: 1.8rem; margin-bottom: 5px; color:#00d564;">My Subscriptions</h2>
        <p style="color: #94a3b8; margin-bottom: 25px;">Series you are actively tracking.</p>
        
        <c:if test="${empty comics}">
            <p style="color:#64748b; padding:2rem; background:rgba(255,255,255,0.05); border-radius:10px;">You are not subscribed to any comics yet. Go <a href="explore" style="color:#00d564;">explore</a>!</p>
        </c:if>

        <div class="comic-grid-wrap">
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
    </main>
</body>
</html>
