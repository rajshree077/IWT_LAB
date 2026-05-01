<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Wallet - MyWebtoon</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;900&display=swap" rel="stylesheet">
    <style>
        .wallet-container { max-width: 600px; margin: 4rem auto; background: rgba(255,255,255,0.05); padding: 3rem; border-radius: 20px; box-shadow: 0 10px 40px rgba(0,0,0,0.5); border: 1px solid rgba(255,255,255,0.1); text-align: center; }
        .coin-balance { font-size: 4rem; font-weight: 900; color: #f59e0b; margin: 1rem 0; text-shadow: 0 4px 10px rgba(245, 158, 11, 0.4); }
        .coin-packages { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-top: 3rem; }
        .coin-pkg { background: rgba(0,0,0,0.4); border: 2px solid transparent; border-radius: 15px; padding: 1.5rem; transition: transform 0.2s, border 0.2s; cursor: pointer; }
        .coin-pkg:hover { transform: translateY(-5px); border-color: #f59e0b; }
        .pkg-amount { font-size: 1.5rem; font-weight: 700; color: white; display: block; margin-bottom: 0.5rem; }
        .pkg-price { color: #00d564; font-weight: 600; }
    </style>
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
            <a href="home" class="nav-sub-link">Back to Home</a>
        </div>
    </nav>

    <main class="container">
        <div class="wallet-container">
            <h1 style="font-size: 2rem;">Your Wallet Balance</h1>
            <div class="coin-balance"><%= session.getAttribute("wallet") %> <span style="font-size: 1.5rem; color: #cbd5e1;">Coins</span></div>
            <p style="color: #94a3b8; font-size: 1.1rem;">Use coins to Fast Pass locked episodes in advance.</p>
            
            <% if(request.getParameter("success") != null) { %>
                <div class="success-msg" style="margin-top: 20px;">Successfully added <%= request.getParameter("added") %> coins instantly!</div>
            <% } %>

            <div class="coin-packages">
                <form action="wallet" method="post" class="coin-pkg" onclick="this.submit()">
                    <input type="hidden" name="amount" value="10">
                    <span class="pkg-amount">🪙 10 Coins</span>
                    <span class="pkg-price">$0.99</span>
                </form>
                <form action="wallet" method="post" class="coin-pkg" style="border-color: #e21b70;" onclick="this.submit()">
                    <div style="position:absolute; top:-10px; right:10px; background:#e21b70; font-size:0.7rem; padding: 3px 8px; border-radius: 10px; font-weight:bold;">BEST VALUE</div>
                    <input type="hidden" name="amount" value="55">
                    <span class="pkg-amount">🪙 55 Coins</span>
                    <span class="pkg-price">$4.99</span>
                </form>
            </div>
        </div>
    </main>
</body>
</html>
