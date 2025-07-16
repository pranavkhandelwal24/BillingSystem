<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // ✅ Check if user is logged in
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("../index.jsp");
        return;
    }
%>

<jsp:include page="header.jsp" />

<!-- Layout wrapper -->
<div class="main-container" style="display: flex; min-height: 80vh;">
    <jsp:include page="sidebar.jsp" />

    <!-- Page content -->
    <div class="content" style="flex: 1; padding: 20px;">
        <h2>Add New Customer</h2>

        <% 
            String success = request.getParameter("success");
            String error = request.getParameter("error");
        %>

        <% if ("1".equals(success)) { %>
            <p style="color: green;">Customer added successfully!</p>
        <% } else if (error != null) { %>
            <p style="color: red;"><%= error %></p>
        <% } %>

        <form action="../addCustomer" method="post">
            <label>Name:</label><br>
            <input type="text" name="name" required /><br><br>

            <label>Address:</label><br>
            <textarea name="address" required></textarea><br><br>

            <label>Phone:</label><br>
            <input type="text" name="phone" required /><br><br>

            <label>Email:</label><br>
            <input type="email" name="email" required /><br><br>

            <label>GST Number:</label><br>
            <input type="text" name="gstNumber" required /><br><br>

            <input type="submit" value="Add Customer" />
        </form>
    </div>
</div>

<jsp:include page="footer.jsp" />
