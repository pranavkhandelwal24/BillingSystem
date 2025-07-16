<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Tally System</title>
    <style>
        body {
            font-family: Arial;
            background-color: #f9f9f9;
        }
        .login-box {
            width: 350px;
            margin: 80px auto;
            padding: 20px;
            background: white;
            border: 1px solid #ddd;
            border-radius: 8px;
        }
        input[type="text"], input[type="password"] {
            width: 93%;
            padding: 10px;
            margin: 10px 0;
        }
        input[type="submit"] {
            width: 100%;
            padding: 10px;
            background-color: #4CAF50;
            color: white;
            border: none;
            cursor: pointer;
        }
        .extra-links {
            margin-top: 10px;
            font-size: 14px;
            text-align: center;
        }
        .extra-links a {
            margin: 0 10px;
            text-decoration: none;
            color: #007BFF;
        }
    </style>
</head>
<body>

<div class="login-box">
    <h2>Login to Billing System</h2>
    <% String success = request.getParameter("success"); %>
<% String error = request.getParameter("error"); %>

<% if (success != null) { %>
    <p style="color:green;"><%= success %></p>
<% } else if (error != null) { %>
    <p style="color:red;"><%= error %></p>
<% } %>
    

    <% if ("1".equals(request.getParameter("error"))) { %>
        <p style="color:red;">Invalid username or password.</p>
    <% } %>

    <form action="login" method="post">
        <label>Username:</label><br>
        <input type="text" name="username" required><br>

        <label>Password:</label><br>
        <input type="password" name="password" id="password" required>
        <input type="checkbox" onclick="togglePassword()"> Show Password<br><br>

        <input type="submit" value="Login">
    </form>

    <div class="extra-links">
        <a href="register.jsp">Register</a> |
        <a href="forgotPassword.jsp">Forgot Password?</a>
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
