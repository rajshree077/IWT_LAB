<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>MyWebtoon - Home</title>
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

    <header class="hero">
        <div class="hero-content">
            <h1>Dive into Infinite Stories</h1>
            <p>Discover the best webtoons approved by our community and generated for you.</p>
            <a href="explore" class="btn btn-primary btn-large">Start Reading</a>
        </div>
    </header>

    <main class="container">
        <div class="trending-header" style="display: flex; justify-content: space-between; align-items: baseline; margin-bottom:15px;">
            <h2 style="font-size: 1.8rem; margin:0;">Trending & Popular Series</h2>
            <a href="explore" style="color: #cbd5e1; text-decoration: none; font-size: 0.9rem;">View all ></a>
        </div>
        <div class="trending-pills" style="margin-bottom: 25px;">
            <span id="pill-trending" class="pill active" onclick="togglePill('trending')">Trending</span>
            <span id="pill-popular" class="pill inactive" onclick="togglePill('popular')">Popular</span>
        </div>
        <div class="comic-section">
            <button class="scroll-btn left" onclick="document.getElementById('home-grid').scrollBy({left: -600, behavior: 'smooth'})">&#10094;</button>
            <div class="comic-grid" id="home-grid">
                <c:forEach var="comic" items="${recentComics}" varStatus="status">
                    <a href="comic?id=${comic.id}" class="comic-card">
                        <div class="comic-img-wrapper">
                            <img src="${comic.coverImageUrl != null ? comic.coverImageUrl : 'https://via.placeholder.com/200x300'}" alt="${comic.title}">
                            <span class="comic-rank">${status.index + 1}</span>
                        </div>
                        <div class="comic-info">
                            <h3>${comic.title}</h3>
                            <p>By ${comic.authorName}</p>
                        </div>
                    </a>
                </c:forEach>
            </div>
            <button class="scroll-btn right" onclick="document.getElementById('home-grid').scrollBy({left: 600, behavior: 'smooth'})">&#10095;</button>
        </div>

        <!-- Popular Series by Category Section -->
        <div class="trending-header" style="display: flex; justify-content: space-between; align-items: baseline; margin-top: 40px; margin-bottom:15px;">
            <h2 style="font-size: 1.8rem; margin:0;">Popular Series by Category</h2>
            <a href="explore" style="color: #cbd5e1; text-decoration: none; font-size: 0.9rem;">View all ></a>
        </div>
        <div class="category-pills" style="margin-bottom: 25px; display: flex; gap: 10px; overflow-x: auto; scrollbar-width: none;">
            <a href="category.jsp?name=Drama" class="pill active" style="text-decoration:none; font-size: 0.85rem; padding: 6px 16px;">Drama</a>
            <a href="category.jsp?name=Fantasy" class="pill inactive" style="text-decoration:none; font-size: 0.85rem; padding: 6px 16px;">Fantasy</a>
            <a href="category.jsp?name=Comedy" class="pill inactive" style="text-decoration:none; font-size: 0.85rem; padding: 6px 16px;">Comedy</a>
            <a href="category.jsp?name=Action" class="pill inactive" style="text-decoration:none; font-size: 0.85rem; padding: 6px 16px;">Action</a>
            <a href="category.jsp?name=Slice%20of%20life" class="pill inactive" style="text-decoration:none; font-size: 0.85rem; padding: 6px 16px;">Slice of life</a>
            <a href="category.jsp?name=Romance" class="pill inactive" style="text-decoration:none; font-size: 0.85rem; padding: 6px 16px;">Romance</a>
            <a href="category.jsp?name=Superhero" class="pill inactive" style="text-decoration:none; font-size: 0.85rem; padding: 6px 16px;">Superhero</a>
            <a href="category.jsp?name=Sci-fi" class="pill inactive" style="text-decoration:none; font-size: 0.85rem; padding: 6px 16px;">Sci-fi</a>
        </div>
        <div class="comic-section">
            <button class="scroll-btn left" onclick="document.getElementById('category-grid').scrollBy({left: -600, behavior: 'smooth'})">&#10094;</button>
            <div class="comic-grid" id="category-grid">
                <!-- Reusing recentComics for demo purposes, adding fake views & badges -->
                <c:forEach var="comic" items="${recentComics}" varStatus="status">
                    <a href="comic?id=${comic.id}" class="comic-card">
                        <div class="comic-img-wrapper" style="overflow: hidden;">
                            <c:if test="${status.index % 3 == 1}">
                                <span class="badge-new">New Series</span>
                            </c:if>
                            <img src="${comic.coverImageUrl != null ? comic.coverImageUrl : 'https://via.placeholder.com/200x300'}" alt="${comic.title}">
                        </div>
                        <div class="comic-info">
                            <h3>${comic.title}</h3>
                            <p>${comic.id * 12 + 5}M Views</p>
                        </div>
                    </a>
                </c:forEach>
            </div>
            <button class="scroll-btn right" onclick="document.getElementById('category-grid').scrollBy({left: 600, behavior: 'smooth'})">&#10095;</button>
        </div>
    </main>
    <script src="js/script.js"></script>
    <script>
    function togglePill(type) {
        const trendBtn = document.getElementById('pill-trending');
        const popBtn = document.getElementById('pill-popular');
        const grid = document.querySelector('.comic-grid');
        
        if (type === 'popular' && popBtn.classList.contains('inactive')) {
            popBtn.className = 'pill active';
            trendBtn.className = 'pill inactive';
            
            // Reverse the comics to simulate "Popular" order
            let cards = Array.from(grid.children);
            cards.reverse();
            grid.innerHTML = '';
            cards.forEach((card, index) => {
                card.querySelector('.comic-rank').innerText = index + 1;
                grid.appendChild(card);
            });
        } else if (type === 'trending' && trendBtn.classList.contains('inactive')) {
            trendBtn.className = 'pill active';
            popBtn.className = 'pill inactive';
            
            // Revert back
            let cards = Array.from(grid.children);
            cards.reverse();
            grid.innerHTML = '';
            cards.forEach((card, index) => {
                card.querySelector('.comic-rank').innerText = index + 1;
                grid.appendChild(card);
            });
        }
    }
    </script>
</body>
</html>
