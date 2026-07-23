<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Tally Billing System</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body class="auth-page">

<div class="auth-card">
    <div class="auth-header">
        <h2 style="color: var(--primary-color);">Tally Billing System</h2>
        <p>Sign in to your account</p>
    </div>

    <% 
        String success = request.getParameter("success"); 
        String error = request.getParameter("error"); 
    %>
    
    <% if (success != null) { %>
        <div class="alert alert-success"><%= success %></div>
    <% } %>
    <% if (error != null) { %>
        <div class="alert alert-error"><%= error %></div>
    <% } %>
    <% if ("1".equals(request.getParameter("error"))) { %>
        <div class="alert alert-error">Invalid username or password.</div>
    <% } %>

    <form action="login" method="post">
        <div class="form-group">
            <label for="username">Username</label>
            <input type="text" id="username" name="username" placeholder="Enter username" required>
        </div>

        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" placeholder="Enter password" required>
        </div>

        <div class="checkbox-group">
            <input type="checkbox" id="showPassword" onclick="togglePassword()">
            <label for="showPassword">Show Password</label>
        </div>

        <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 10px;">Login</button>
    </form>

    <div class="auth-footer">
        Don't have an account? <a href="register.jsp" style="font-weight: 500;">Register</a>
        <div style="margin-top: 10px;">
            <a href="forgotPassword.jsp" style="font-size: 13px;">Forgot Password?</a>
        </div>
    </div>
</div>

<script>
    function togglePassword() {
        var pwd = document.getElementById("password");
        pwd.type = (pwd.type === "password") ? "text" : "password";
    }
</script>

</body>
</html>
