<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String[] genres = {"DRAMA", "FANTASY", "COMEDY", "ACTION", "SLICE OF LIFE", "ROMANCE", "THRILLER"};
    request.setAttribute("allGenres", genres);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Categories - MyWebtoon</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        .genre-nav {
            background: #1e2025;
            padding: 15px 0;
            border-bottom: 1px solid rgba(255,255,255,0.05);
            margin-bottom: 30px;
        }
        .genre-list {
            display: flex;
            gap: 25px;
            list-style: none;
            overflow-x: auto;
            white-space: nowrap;
            scrollbar-width: none;
        }
        .genre-list::-webkit-scrollbar { display: none; }
        .genre-item a {
            color: #94a3b8;
            text-decoration: none;
            font-weight: 700;
            font-size: 0.9rem;
            text-transform: uppercase;
            padding-bottom: 5px;
            transition: color 0.2s;
        }
        .genre-item a:hover { color: white; }
        .genre-item.active a {
            color: white;
            border-bottom: 2px solid #00d564;
        }
        .series-count {
            color: #94a3b8;
            margin-bottom: 20px;
            font-weight: 600;
        }
    </style>
</head>
<body class="dark-theme">
    <nav class="navbar">
        <div style="display: flex; align-items: center; gap: 30px;">
            <a href="home" class="logo">MyWebtoon</a>
            <div class="nav-main-links">
                <a href="explore">ORIGINALS</a>
                <a href="categories" style="color:white; font-weight:700;">CATEGORIES</a>
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

    <div class="genre-nav">
        <div class="container">
            <ul class="genre-list">
                <c:forEach var="g" items="${allGenres}">
                    <li class="genre-item ${currentGenre == g ? 'active' : ''}">
                        <a href="categories?genre=${g}">${g}</a>
                    </li>
                </c:forEach>
            </ul>
        </div>
    </div>

    <main class="container">
        <div class="series-count">${comics.size()} series</div>
        
        <c:if test="${empty comics}">
            <p style="color:#64748b; padding:2rem; background:rgba(255,255,255,0.05); border-radius:10px;">No series found in this genre.</p>
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
