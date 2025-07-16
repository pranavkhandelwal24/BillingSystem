<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Forgot Password</title>
</head>
<body>
    <h2>Forgot Password</h2>

    <%
        String success = request.getParameter("success");
        String error = request.getParameter("error");
        if (success != null) {
    %>
        <p style="color:green;"><%= success %></p>
    <% } else if (error != null) { %>
        <p style="color:red;"><%= error %></p>
    <% } %>

    <form action="sendResetEmail" method="post">
        <label>Enter your registered email:</label><br>
        <input type="email" name="email" required /><br><br>
        <input type="submit" value="Send Reset Link" />
    </form>
</body>
</html>
