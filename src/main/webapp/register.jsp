<div class="register-box">
    <h2>Register</h2>

    <% String error = request.getParameter("error"); %>
    <% String success = request.getParameter("success"); %>
    <% if (success != null) { %>
        <p style="color:green;"><%= success %></p>
    <% } else if (error != null) { %>
        <p style="color:red;"><%= error %></p>
    <% } %>

    <form action="register" method="post">
        <!-- Company Info -->
        <label>Company Name:</label>
        <input type="text" name="companyName" required />

        <label>Your Name:</label>
        <input type="text" name="name" required />

        <label>Email:</label>
        <input type="email" name="email" required />

        <label>Phone:</label>
        <input type="text" name="phone" required />

        <label>Address:</label>
        <textarea name="address" required></textarea>
		<br>
        <label>GST Number:</label>
        <input type="text" name="gstNumber" required />

        <label>Logo URL:</label>
        <input type="text" name="logoUrl" placeholder="https://example.com/logo.png" required />

        <!-- Login Info -->
        <label>Username:</label>
        <input type="text" name="username" required />

        <label>Password:</label>
        <input type="password" name="password" id="password" required />

        <label>Confirm Password:</label>
        <input type="password" name="confirmPassword" id="confirmPassword" required />
		<br>
        <!-- Show Password Checkbox (inline) -->
        <div style="margin-bottom: 15px;">
            <input type="checkbox" id="showPassword" />
            <label for="showPassword">Show Password</label>
        </div>

        <!-- Terms -->
        <div style="margin-bottom: 20px;">
            <input type="checkbox" id="terms" required />
            <label for="terms">I agree to the <a href="#">Terms and Conditions</a></label>
        </div>

        <input type="submit" value="Register" />
    </form>

    <p style="text-align:center; margin-top: 20px;">
        <a href="index.jsp">Back to Login</a>
    </p>
</div>

<script>
    document.getElementById("showPassword").addEventListener("change", function () {
        const type = this.checked ? "text" : "password";
        document.getElementById("password").type = type;
        document.getElementById("confirmPassword").type = type;
    });
</script>
