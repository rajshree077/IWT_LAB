<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register - MyWebtoon</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
</head>
<body class="auth-page dark-theme">
    <div class="auth-container glassmorphism">
        <h2>Join MyWebtoon</h2>
        <% if (request.getParameter("error") != null) { %>
            <p class="error-msg">Username already exists!</p>
        <% } %>
        <form action="auth" method="post" onsubmit="return validatePassword()">
            <input type="hidden" name="action" value="register">
            <div class="input-group">
                <input type="text" name="username" required>
                <label>Username</label>
            </div>
            <div class="input-group">
                <input type="password" name="password" id="regPassword" pattern="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^a-zA-Z0-9])[a-zA-Z_].{7,}$" title="Password must be at least 8 characters, start with a letter or '_', and contain at least one uppercase letter, one lowercase letter, one digit, and one special character." required>
                <label>Password</label>
                <span class="password-toggle" onclick="togglePassword('regPassword', this)">
                    <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" stroke-width="2" fill="none" class="eye-icon"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
                </span>
            </div>
            <div class="input-group">
                <input type="password" name="confirmPassword" id="verifyPassword" required>
                <label>Confirm Password</label>
                <span class="password-toggle" onclick="togglePassword('verifyPassword', this)">
                    <svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" stroke-width="2" fill="none" class="eye-icon"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
                </span>
            </div>
            <p id="passwordErrorMsg" class="error-msg" style="display: none; margin-bottom: 1rem;">Passwords do not match!</p>
            <div class="input-group">
                <label>I am a...</label>
                <select name="role">
                    <option value="USER">Reader / User</option>
                    <option value="CREATOR">Creator (Upload Comics)</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary btn-full">Sign Up</button>
        </form>
        <p class="auth-footer">Already have an account? <a href="login.jsp">Log in</a></p>
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

    function validatePassword() {
        const password = document.getElementById("regPassword").value;
        const confirmPassword = document.getElementById("verifyPassword").value;
        const errorMsg = document.getElementById("passwordErrorMsg");
        
        const regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^a-zA-Z0-9])[a-zA-Z_].{7,}$/;

        if (!regex.test(password)) {
            errorMsg.innerHTML = "Password must be at least 8 chars, start with a letter or '_', and contain an uppercase, a lowercase, a digit, and a special character.";
            errorMsg.style.display = "block";
            return false;
        }

        if (password !== confirmPassword) {
            errorMsg.innerHTML = "Passwords do not match!";
            errorMsg.style.display = "block";
            return false;
        }
        
        errorMsg.style.display = "none";
        return true;
    }
</script>

</body>
</html>
