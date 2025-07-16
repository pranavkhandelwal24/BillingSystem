<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Billing System</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
<div class="header" style="display: flex; justify-content: space-between; align-items: center; padding: 10px;">
    <h1>Billing System</h1>
    <div>
        <a href="<%= request.getContextPath() %>/jsp/updateProfile.jsp" style="margin-right: 15px;">Update Profile</a>
        <a href="<%= request.getContextPath() %>/logout.jsp">Logout</a>
    </div>
</div>
<hr/>
