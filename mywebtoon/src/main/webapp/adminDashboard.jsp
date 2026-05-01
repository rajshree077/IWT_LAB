<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - MyWebtoon</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
</head>
<body class="dark-theme">
    <nav class="navbar">
        <a href="home" class="logo">MyWebtoon Admin</a>
        <div class="nav-links">
            <a href="home">Home</a>
        </div>
    </nav>

    <main class="container">
        <h1>Admin Control Panel</h1>
        
        <div class="stats-grid">
            <div class="stat-card glassmorphism">
                <h3>Total Users</h3>
                <p class="stat-num">${totalUsers}</p>
            </div>
            <div class="stat-card glassmorphism">
                <h3>Total Revenue (Coins)</h3>
                <p class="stat-num">${totalRevenue != null ? totalRevenue : 0}</p>
            </div>
        </div>

        <h3 style="margin-top:2rem;">Pending Approvals</h3>
        <table class="data-table">
            <thead>
                <tr>
                    <th>Title</th>
                    <th>Author</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="comic" items="${pendingComics}">
                    <tr>
                        <td>${comic.title}</td>
                        <td>${comic.authorName}</td>
                        <td>
                            <form action="adminDashboard" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="approve">
                                <input type="hidden" name="comicId" value="${comic.id}">
                                <button type="submit" class="btn btn-success btn-sm">Approve</button>
                            </form>
                            <form action="adminDashboard" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="reject">
                                <input type="hidden" name="comicId" value="${comic.id}">
                                <button type="submit" class="btn btn-danger btn-sm">Reject</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </main>
</body>
</html>
