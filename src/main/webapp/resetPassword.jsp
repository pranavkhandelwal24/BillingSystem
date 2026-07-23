<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String token = request.getParameter("token");
    if (token == null || token.isEmpty()) {
        response.sendRedirect("index.jsp?error=Invalid or missing reset token.");
        return;
    }

    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password - Tally Billing System</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body class="auth-page">

<div class="auth-card">
    <div class="auth-header">
        <h2 style="color: var(--primary-color);">Reset Password</h2>
        <p>Set a new password for your account</p>
    </div>

    <% if (success != null) { %>
        <div class="alert alert-success"><%= success %></div>
    <% } %>
    <% if (error != null) { %>
        <div class="alert alert-error"><%= error %></div>
    <% } %>

    <form action="resetPassword" method="post">
        <input type="hidden" name="token" value="<%= token %>" />
        
        <div class="form-group">
            <label for="newPassword">New Password</label>
            <input type="password" id="newPassword" name="newPassword" placeholder="Enter new password" required />
        </div>

        <div class="form-group">
            <label for="confirmPassword">Confirm New Password</label>
            <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Repeat new password" required />
        </div>

        <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 10px;">Reset Password</button>
    </form>

    <div class="auth-footer">
        <a href="index.jsp" style="font-weight: 500;">Back to Login</a>
    </div>
</div>

</body>
</html>
