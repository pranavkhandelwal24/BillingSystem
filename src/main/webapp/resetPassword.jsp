<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String token = request.getParameter("token");
    if (token == null) {
        out.println("<p style='color:red;'>Invalid reset link.</p>");
        return;
    }

    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Reset Password</title>
</head>
<body>
    <h2>Reset Password</h2>

    <% if (success != null) { %>
        <p style="color:green;"><%= success %></p>
    <% } else if (error != null) { %>
        <p style="color:red;"><%= error %></p>
    <% } %>

    <form action="resetPassword" method="post">
        <input type="hidden" name="token" value="<%= token %>" />
        <label>New Password:</label><br>
        <input type="password" name="newPassword" required /><br><br>
        <label>Confirm Password:</label><br>
        <input type="password" name="confirmPassword" required /><br><br>
        <input type="submit" value="Reset Password" />
    </form>
</body>
</html>
