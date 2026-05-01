<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login - MyWebtoon</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
</head>

<body class="auth-page dark-theme">

<div class="auth-container glassmorphism">

    <h2 class="title">Welcome Back</h2>

    <% if (request.getParameter("error") != null) { %>
        <p class="error-msg">Invalid credentials or unauthorized access!</p>
    <% } %>

    <% if (request.getParameter("success") != null) { %>
        <p class="success-msg">Registration successful! Please log in.</p>
    <% } %>

    <form action="auth" method="post">
        <input type="hidden" name="action" value="login">

        <div class="input-group">
            <input type="text" name="username" required>
            <label>Username</label>
        </div>

        <div class="input-group">
            <input type="password" name="password" id="loginPassword" required>
            <label>Password</label>
            <span class="password-toggle" onclick="togglePassword('loginPassword', this)">
                <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" stroke-width="2" fill="none" class="eye-icon"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
            </span>
        </div>

        <button type="submit" class="btn btn-primary btn-full">Log In</button>
    </form>

    <p class="auth-footer">
        Don't have an account? <a href="register.jsp">Sign up</a>
    </p>

</div>

<script>
    function togglePassword(inputId, iconSpan) {
        const input = document.getElementById(inputId);
        const icon = iconSpan.querySelector('svg');
        if (input.type === 'password') {
            input.type = 'text';
            icon.innerHTML = '<path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path><line x1="1" y1="1" x2="23" y2="23"></line>';
        } else {
            input.type = 'password';
            icon.innerHTML = '<path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle>';
        }
    }
</script>

</body>
</html>
