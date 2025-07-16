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
        <h2>Add New Item</h2>

        <% 
            String success = request.getParameter("success");
            String error = request.getParameter("error");
        %>

        <% if ("1".equals(success)) { %>
            <p style="color: green;">Item added successfully!</p>
        <% } else if (error != null) { %>
            <p style="color: red;"><%= error %></p>
        <% } %>

        <form action="../addItem" method="post">
            <label>Item Name:</label><br>
            <input type="text" name="name" required /><br><br>

            <label>Price:</label><br>
            <input type="number" name="price" step="0.01" required /><br><br>

            <label>Quantity:</label><br>
            <input type="number" name="quantity" required /><br><br>

            <label>GST Rate (%):</label><br>
            <input type="number" name="gst" step="0.01" required /><br><br>

            <label>HSN Code:</label><br>
            <input type="text" name="hsnCode" required /><br><br>

            <input type="submit" value="Add Item" />
        </form>
    </div>
</div>

<jsp:include page="footer.jsp" />
