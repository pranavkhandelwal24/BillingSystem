<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check if user is logged in
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
%>

<%@ include file="header.jsp" %>

<h2 class="page-title">Add New Item</h2>

<div class="card" style="max-width: 600px;">
    <% 
        String success = request.getParameter("success");
        String error = request.getParameter("error");
    %>

    <% if ("1".equals(success)) { %>
        <div class="alert alert-success">Item added successfully!</div>
    <% } else if (error != null) { %>
        <div class="alert alert-error"><%= error %></div>
    <% } %>

    <form action="../addItem" method="post">
        <div class="form-group">
            <label for="name">Item Name</label>
            <input type="text" id="name" name="name" placeholder="Name or description" required />
        </div>

        <div class="form-group">
            <label for="price">Unit Price (Rs.)</label>
            <input type="number" id="price" name="price" step="0.01" placeholder="0.00" required />
        </div>

        <div class="form-group">
            <label for="quantity">Initial Stock Quantity</label>
            <input type="number" id="quantity" name="quantity" placeholder="Quantity in stock" required />
        </div>

        <div class="form-group">
            <label for="gst">GST Rate (%)</label>
            <input type="number" id="gst" name="gst" step="0.01" placeholder="e.g. 18.0" required />
        </div>

        <div class="form-group">
            <label for="hsnCode">HSN Code</label>
            <input type="text" id="hsnCode" name="hsnCode" placeholder="Harmonized System Nomenclature" required />
        </div>

        <button type="submit" class="btn btn-primary">Add Item to Stock</button>
    </form>
</div>

<%@ include file="footer.jsp" %>
