<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password - Tally Billing System</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body class="auth-page">

<div class="auth-card">
    <div class="auth-header">
        <h2 style="color: var(--primary-color);">Forgot Password</h2>
        <p>Recover your Tally Billing System account</p>
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

    <form action="sendResetEmail" method="post">
        <div class="form-group">
            <label for="email">Registered Email Address</label>
            <input type="email" id="email" name="email" placeholder="owner@company.com" required />
        </div>

        <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 10px;">Send Reset Link</button>
    </form>

    <div class="auth-footer">
        <a href="index.jsp" style="font-weight: 500;">Back to Login</a>
    </div>
</div>

</body>
</html>
