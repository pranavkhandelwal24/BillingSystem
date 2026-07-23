<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tally Billing System</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <div class="app-container">
        <!-- Minimal Top Navigation -->
        <header class="app-header">
            <div class="logo-area">
                <span class="logo-text">Tally Billing</span>
            </div>
            <div class="header-actions">
                <span class="welcome-msg">Welcome, <strong><%= session.getAttribute("username") != null ? session.getAttribute("username") : "User" %></strong></span>
                <a href="<%= request.getContextPath() %>/jsp/updateProfile.jsp" class="btn btn-secondary btn-sm">Profile</a>
                <a href="<%= request.getContextPath() %>/logout.jsp" class="btn btn-danger btn-sm">Logout</a>
            </div>
        </header>

        <!-- Sidebar + Content Wrapper -->
        <div class="main-layout">
            <%@ include file="sidebar.jsp" %>
            
            <!-- Content Area -->
            <main class="content-area">
