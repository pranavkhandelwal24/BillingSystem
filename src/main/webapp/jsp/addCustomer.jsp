<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check if user is logged in
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
%>

<%@ include file="header.jsp" %>

<h2 class="page-title">Add New Customer</h2>

<div class="card" style="max-width: 600px;">
    <% 
        String success = request.getParameter("success");
        String error = request.getParameter("error");
    %>

    <% if ("1".equals(success)) { %>
        <div class="alert alert-success">Customer added successfully!</div>
    <% } else if (error != null) { %>
        <div class="alert alert-error"><%= error %></div>
    <% } %>

    <form action="../addCustomer" method="post">
        <div class="form-group">
            <label for="name">Customer Name</label>
            <input type="text" id="name" name="name" placeholder="Full Name" required />
        </div>

        <div class="form-group">
            <label for="phone">Phone Number</label>
            <input type="text" id="phone" name="phone" placeholder="Contact number" required />
        </div>

        <div class="form-group">
            <label for="email">Email Address</label>
            <input type="email" id="email" name="email" placeholder="customer@email.com" required />
        </div>

        <div class="form-group">
            <label for="gstNumber">GST Number</label>
            <input type="text" id="gstNumber" name="gstNumber" placeholder="Customer's GSTIN (or N/A)" required />
        </div>

        <div class="form-group">
            <label for="address">Billing Address</label>
            <textarea id="address" name="address" placeholder="Physical billing address" required></textarea>
        </div>

        <button type="submit" class="btn btn-primary">Add Customer</button>
    </form>
</div>

<%@ include file="footer.jsp" %>
