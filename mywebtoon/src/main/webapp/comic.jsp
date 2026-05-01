<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${comic.title} - MyWebtoon</title>
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
        <div class="comic-detail-header glassmorphism">
            <img src="${comic.coverImageUrl != null ? comic.coverImageUrl : 'https://via.placeholder.com/300x400'}" alt="${comic.title}" class="detail-cover">
            <div class="detail-info">
                <h1>${comic.title}</h1>
                <p class="author">By ${comic.authorName}</p>
                <div style="color: #00d564; font-weight: bold; font-size: 1.1rem; margin-bottom: 15px;">⭐ ${avgRating} <span style="font-size:0.8rem; color:#94a3b8; font-weight:normal;">/ 10</span></div>
                <% if (session.getAttribute("user") != null) { %>
                    <form action="interact" method="post" style="margin-bottom: 1.5rem;">
                        <input type="hidden" name="comicId" value="${comic.id}">
                        <c:choose>
                            <c:when test="${isSubscribed}">
                                <input type="hidden" name="action" value="unsubscribe">
                                <button type="submit" class="btn btn-outline btn-sm">Unsubscribe</button>
                            </c:when>
                            <c:otherwise>
                                <input type="hidden" name="action" value="subscribe">
                                <button type="submit" class="btn btn-success btn-sm">+ Subscribe</button>
                            </c:otherwise>
                        </c:choose>
                    </form>
                <% } %>
                <p class="desc">${comic.description}</p>
            </div>
        </div>

        <h3 class="episodes-title">Episodes</h3>
        
        <% if (request.getParameter("error") != null) { %>
            <div class="error-msg">
                <% if ("locked".equals(request.getParameter("error"))) { %>
                    This episode is locked. Please purchase it first.
                <% } else if ("insufficient_funds".equals(request.getParameter("error"))) { %>
                    Insufficient coins in your wallet!
                <% } %>
            </div>
        <% } %>

        <ul class="episode-list">
            <c:forEach var="ep" items="${episodes}">
                <li class="episode-item glassmorphism">
                    <div class="ep-info">
                        <strong>Ep. ${ep.episodeNumber}</strong> - ${ep.title}
                    </div>
                    
                    <div class="ep-actions">
                        <c:choose>
                            <c:when test="${ep.locked && !purchasedEpisodeIds.contains(ep.id) && sessionScope.role != 'ADMIN'}">
                                <span class="price-tag">🔒 ${ep.price} Coins</span>
                                <% if (session.getAttribute("user") != null) { %>
                                <form action="interact" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="purchase">
                                    <input type="hidden" name="episodeId" value="${ep.id}">
                                    <input type="hidden" name="price" value="${ep.price}">
                                    <button type="submit" class="btn btn-primary btn-sm">Unlock</button>
                                </form>
                                <% } else { %>
                                    <a href="login.jsp" class="btn btn-sm">Login to Unlock</a>
                                <% } %>
                            </c:when>
                            <c:otherwise>
                                <a href="reader?id=${ep.id}" class="btn btn-success btn-sm">Read</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </li>
            </c:forEach>
        </ul>
    </main>
</body>
</html>
