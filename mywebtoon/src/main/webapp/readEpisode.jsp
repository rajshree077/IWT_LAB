<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${episode.title} - MyWebtoon Reader</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/reader.css">
</head>
<body class="reader-mode dark-theme">
    <div class="reader-nav">
        <a href="comic?id=${episode.comicId}" class="back-btn">⬅ Back to Comic</a>
        <h2>Ep. ${episode.episodeNumber} - ${episode.title}</h2>
        <div class="reader-actions">
            <form action="interact" method="post" style="display:inline;">
                <input type="hidden" name="action" value="${hasLiked ? 'unlike' : 'like'}">
                <input type="hidden" name="episodeId" value="${episode.id}">
                <button type="submit" class="btn btn-outline btn-sm" ${hasLiked ? 'style="border-color:#e21b70; color:#e21b70;"' : ''}>
                    ${hasLiked ? '❤️ Liked' : '🤍 Like'} (${likeCount})
                </button>
            </form>
            <button class="btn btn-outline btn-sm" onclick="alert('Link copied to clipboard!')">Share</button>
        </div>
    </div>

    <!-- The Webtoon Reader Container -->
    <div class="reader-container" id="reader-container">
        <!-- Images injected via JS below since it's JSON -->
    </div>

    <div class="comments-section container" style="margin-top: 3rem; max-width: 800px; padding: 0 1rem;">
        <h3 style="margin-bottom: 20px;">Comments</h3>
        <!-- Very Basic Comment Form -->
        <% if (session.getAttribute("user") != null) { %>
        <form action="interact" method="post" class="comment-form" style="display:flex; flex-direction:column; gap:10px; margin-bottom: 30px;">
            <input type="hidden" name="action" value="comment">
            <input type="hidden" name="episodeId" value="${episode.id}">
            <textarea name="content" required placeholder="Leave a comment..." style="padding: 10px; border-radius: 8px; border: 1px solid rgba(255,255,255,0.2); background: rgba(0,0,0,0.5); color:white; min-height: 80px;"></textarea>
            <button type="submit" class="btn btn-primary" style="align-self: flex-start;">Post Comment</button>
        </form>
        <% } else { %>
            <p style="margin-bottom:30px;"><a href="login.jsp" style="color:#00d564;">Log in</a> to post comments.</p>
        <% } %>

        <div class="comments-list" style="display:flex; flex-direction:column; gap: 15px;">
            <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
            <c:forEach var="c" items="${commentsList}">
                <div class="comment-item" style="padding: 15px; background: rgba(255,255,255,0.05); border-radius: 8px;">
                    <div style="font-weight:bold; color:#00d564; margin-bottom: 5px;">${c.username} <span style="font-size:0.8rem; color:#64748b; font-weight:normal;">${c.created_at}</span></div>
                    <div style="color:#cbd5e1;">${c.content}</div>
                </div>
            </c:forEach>
            <c:if test="${empty commentsList}">
                <p style="color:#64748b;">No comments yet. Be the first!</p>
            </c:if>
        </div>
    </div>

    <script>
        const episodeId = '${episode.id}';
        const userId = '${sessionScope.user != null ? sessionScope.user : "guest"}';
        const bookmarkKey = `bookmark_ep_${episodeId}_user_${userId}`;
        
        // Prevent saving bookmark during initial load and auto-scroll
        let canSaveBookmark = false;

        // Setup observer to track which image is currently being viewed
        const observer = new IntersectionObserver((entries) => {
            if (!canSaveBookmark) return;
            
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const index = entry.target.dataset.index;
                    // Save progress in localStorage
                    localStorage.setItem(bookmarkKey, index);
                }
            });
        }, { threshold: 0.1 }); // Trigger when 10% of image is visible

        // Parse the JSON array of image URLs
        const imagesRaw = '${episode.imagesJson}';
        try {
            const images = JSON.parse(imagesRaw);
            const container = document.getElementById('reader-container');
            const savedIndex = localStorage.getItem(bookmarkKey);
            
            images.forEach((url, index) => {
                const img = document.createElement('img');
                img.src = url;
                img.className = 'reader-img';
                img.style.minHeight = '300px'; // Prevent 0-height intersection bugs
                img.dataset.index = index;
                img.id = `reader-img-${index}`;
                
                // Observe this image
                observer.observe(img);
                
                container.appendChild(img);
            });
            
            // Check if we have a saved position to resume from
            if (savedIndex && parseInt(savedIndex) > 0) {
                // Show a small toast notification
                const toast = document.createElement('div');
                toast.innerHTML = 'Resumed from where you left off.';
                toast.style.position = 'fixed';
                toast.style.bottom = '20px';
                toast.style.left = '50%';
                toast.style.transform = 'translateX(-50%)';
                toast.style.background = 'linear-gradient(135deg, #e21b70, #ff4d4d)';
                toast.style.color = 'white';
                toast.style.padding = '10px 20px';
                toast.style.borderRadius = '30px';
                toast.style.zIndex = '1000';
                toast.style.fontWeight = 'bold';
                toast.style.boxShadow = '0 4px 15px rgba(226, 27, 112, 0.4)';
                toast.style.transition = 'opacity 0.5s';
                document.body.appendChild(toast);
                
                // Fade out toast after 3 seconds
                setTimeout(() => {
                    toast.style.opacity = '0';
                    setTimeout(() => toast.remove(), 500);
                }, 3000);

                const restoreScroll = () => {
                    const targetImg = document.getElementById(`reader-img-${savedIndex}`);
                    if (targetImg) {
                        targetImg.scrollIntoView({ behavior: 'auto', block: 'start' });
                        window.scrollBy(0, -60); // Offset for navbar
                    }
                };

                // 1. Jump immediately based on placeholders or cached sizes
                restoreScroll();

                // 2. The real problem: as images ABOVE the target load, they expand and push the target down.
                // We must re-adjust the scroll whenever any image above or including the target finishes loading!
                for (let i = 0; i <= savedIndex; i++) {
                    const imgNode = document.getElementById(`reader-img-${i}`);
                    if (imgNode) {
                        imgNode.addEventListener('load', restoreScroll);
                    }
                }
                
                // 3. Keep a safety interval for 2 seconds just in case of weird browser layout bugs
                let enforceInterval = setInterval(restoreScroll, 100);
                setTimeout(() => {
                    clearInterval(enforceInterval);
                    canSaveBookmark = true;
                }, 2000);
                
            } else {
                // Enable saving shortly after page load if no bookmark
                setTimeout(() => { canSaveBookmark = true; }, 1000);
            }
        } catch (e) {
            console.error("Invalid images JSON format");
        }
    </script>
</body>
</html>
