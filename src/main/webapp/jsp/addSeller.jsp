<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%@ include file="header.jsp" %>

<div style="display: flex; min-height: 80vh;">
    <%@ include file="sidebar.jsp" %>

    <div style="flex: 1; padding: 30px;">
        <h2>Add New Seller</h2>

        <% String success = request.getParameter("success"); %>
        <% String error = request.getParameter("error"); %>

        <% if ("1".equals(success)) { %>
            <p style="color: green;">✅ Seller added successfully!</p>
        <% } else if ("1".equals(error)) { %>
            <p style="color: red;">❌ Failed to add seller. Please try again.</p>
        <% } %>

        <form action="<%= request.getContextPath() %>/addSeller" method="post">
            <table cellpadding="10">
                <tr>
                    <td><label for="firmName">Firm Name:</label></td>
                    <td><input type="text" name="firmName" id="firmName" required></td>
                </tr>
                <tr>
                    <td><label for="gstNumber">GST Number:</label></td>
                    <td><input type="text" name="gstNumber" id="gstNumber" required></td>
                </tr>
                <tr>
                    <td><label for="email">Email:</label></td>
                    <td><input type="email" name="email" id="email" required></td>
                </tr>
                <tr>
                    <td><label for="phone">Phone:</label></td>
                    <td><input type="text" name="phone" id="phone" required></td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align: center;">
                        <input type="submit" value="Add Seller" />
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>

<%@ include file="footer.jsp" %>
