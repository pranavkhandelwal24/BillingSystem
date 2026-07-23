<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Tally Billing System</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body class="auth-page">

<div class="auth-card" style="max-width: 500px; margin: 40px auto;">
    <div class="auth-header">
        <h2 style="color: var(--primary-color);">Create Account</h2>
        <p>Register your firm on Tally Billing System</p>
    </div>

    <% 
        String error = request.getParameter("error"); 
        String success = request.getParameter("success"); 
    %>
    <% if (success != null) { %>
        <div class="alert alert-success"><%= success %></div>
    <% } %>
    <% if (error != null) { %>
        <div class="alert alert-error"><%= error %></div>
    <% } %>

    <form action="register" method="post">
        <!-- Company Info -->
        <h3 style="font-size: 15px; font-weight: 600; border-bottom: 1px solid var(--border-color); padding-bottom: 5px; margin-bottom: 15px; color: var(--text-secondary);">Company Details</h3>
        
        <div class="form-group">
            <label for="companyName">Company Name</label>
            <input type="text" id="companyName" name="companyName" placeholder="e.g. Acme Corp" required />
        </div>

        <div class="form-group">
            <label for="gstNumber">GST Number</label>
            <input type="text" id="gstNumber" name="gstNumber" placeholder="15-digit GSTIN" required />
        </div>

        <div class="form-group">
            <label for="logoUrl">Logo URL</label>
            <input type="text" id="logoUrl" name="logoUrl" placeholder="https://example.com/logo.png" required />
        </div>

        <div class="form-group">
            <label for="address">Address</label>
            <textarea id="address" name="address" placeholder="Company physical address" required></textarea>
        </div>

        <!-- Personal Info -->
        <h3 style="font-size: 15px; font-weight: 600; border-bottom: 1px solid var(--border-color); padding-bottom: 5px; margin-bottom: 15px; color: var(--text-secondary); margin-top: 25px;">Owner Details</h3>

        <div class="form-group">
            <label for="name">Contact Name</label>
            <input type="text" id="name" name="name" placeholder="Full Name" required />
        </div>

        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" id="email" name="email" placeholder="owner@company.com" required />
        </div>

        <div class="form-group">
            <label for="phone">Phone</label>
            <input type="text" id="phone" name="phone" placeholder="Phone number" required />
        </div>

        <!-- Login Info -->
        <h3 style="font-size: 15px; font-weight: 600; border-bottom: 1px solid var(--border-color); padding-bottom: 5px; margin-bottom: 15px; color: var(--text-secondary); margin-top: 25px;">Account Details</h3>

        <div class="form-group">
            <label for="username">Username</label>
            <input type="text" id="username" name="username" placeholder="Choose username" required />
        </div>

        <div class="form-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" placeholder="Create password" required />
        </div>

        <div class="form-group">
            <label for="confirmPassword">Confirm Password</label>
            <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Repeat password" required />
        </div>

        <div class="checkbox-group">
            <input type="checkbox" id="showPassword" />
            <label for="showPassword">Show Passwords</label>
        </div>

        <div class="checkbox-group" style="margin-top: 20px;">
            <input type="checkbox" id="terms" required />
            <label for="terms">I agree to the <a href="#">Terms and Conditions</a></label>
        </div>

        <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 15px;">Register Firm</button>
    </form>

    <div class="auth-footer">
        Already registered? <a href="index.jsp" style="font-weight: 500;">Back to Login</a>
    </div>
</div>

<script>
    document.getElementById("showPassword").addEventListener("change", function () {
        const type = this.checked ? "text" : "password";
        document.getElementById("password").type = type;
        document.getElementById("confirmPassword").type = type;
    });
</script>

</body>
</html>
