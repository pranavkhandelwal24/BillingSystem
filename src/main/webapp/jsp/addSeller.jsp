<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%@ include file="header.jsp" %>

<h2 class="page-title">Add New Seller</h2>

<div class="card" style="max-width: 600px;">
    <% String success = request.getParameter("success"); %>
    <% String error = request.getParameter("error"); %>

    <% if ("1".equals(success)) { %>
        <div class="alert alert-success">Seller added successfully!</div>
    <% } else if ("1".equals(error)) { %>
        <div class="alert alert-error">Failed to add seller. Please try again.</div>
    <% } %>

    <form action="<%= request.getContextPath() %>/addSeller" method="post">
        <div class="form-group">
            <label for="firmName">Firm Name</label>
            <input type="text" name="firmName" id="firmName" placeholder="Seller's Firm Name" required>
        </div>

        <div class="form-group">
            <label for="gstNumber">GST Number</label>
            <input type="text" name="gstNumber" id="gstNumber" placeholder="Seller's GSTIN" required>
        </div>

        <div class="form-group">
            <label for="email">Email Address</label>
            <input type="email" name="email" id="email" placeholder="seller@email.com" required>
        </div>

        <div class="form-group">
            <label for="phone">Phone Number</label>
            <input type="text" name="phone" id="phone" placeholder="Phone number" required>
        </div>

        <button type="submit" class="btn btn-primary">Add Seller</button>
    </form>
</div>

<%@ include file="footer.jsp" %>
