<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Creator Dashboard - MyWebtoon</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
</head>
<body class="dark-theme">
    <nav class="navbar">
        <a href="home" class="logo">MyWebtoon</a>
        <div class="nav-links">
            <a href="explore">Explore</a>
            <a href="home">Home</a>
        </div>
    </nav>

    <main class="container">
        <h1>Creator Dashboard</h1>
        <p>Manage your comics and episodes here.</p>
        
        <!-- Add New Comic basic placeholder UI -->
        <div class="glassmorphism" style="margin-bottom: 2rem;">
            <h3>Upload New Comic</h3>
            <p>Admin will review it before it appears in Explore.</p>
            <form action="#" method="get">
                <button type="button" class="btn btn-outline" onclick="alert('Upload functionality to be integrated with admin.')">Create Comic (Mock)</button>
            </form>
        </div>

        <h3>Your Comics</h3>
        <table class="data-table">
            <thead>
                <tr>
                    <th>Title</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="comic" items="${myComics}">
                    <tr>
                        <td>${comic.title}</td>
                        <td>
                            <span class="status-badge ${comic.status == 'APPROVED' ? 'status-green' : (comic.status == 'PENDING' ? 'status-yellow' : 'status-red')}">
                                ${comic.status}
                            </span>
                        </td>
                        <td>
                            <a href="comic?id=${comic.id}" class="btn btn-sm">View</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </main>
</body>
</html>
