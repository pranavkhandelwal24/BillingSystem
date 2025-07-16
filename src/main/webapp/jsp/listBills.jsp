<%@ page import="java.sql.*" %>
<%@ page import="com.util.DBConnection" %>
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <title>All Bills - Tally System</title>
    <style>
        .layout-container {
            display: flex;
        }

        .main-content {
            flex: 1;
            padding: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        table, th, td {
            border: 1px solid #aaa;
        }

        th, td {
            padding: 10px;
            text-align: center;
        }

        .paid {
            color: green;
            font-weight: bold;
        }

        .pending {
            color: red;
            font-weight: bold;
        }

        .inline-form input[type="number"],
        .inline-form select {
            padding: 4px;
            width: 100px;
        }

        .inline-form input[type="submit"] {
            padding: 5px 10px;
            cursor: pointer;
        }
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="layout-container">
    <%@ include file="sidebar.jsp" %>

    <div class="main-content">
        <h2>All Bills</h2>

        <table>
            <tr>
                <th>Invoice #</th>
                <th>Bill ID</th>
                <th>Customer</th>
                <th>Date</th>
                <th>Total Amount</th>
                <th>Payment Status</th>
                <th>Paid Amount</th>
                <th>Payment Date</th>
                <th>Actions</th>
            </tr>

<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = DBConnection.getConnection();
        ps = conn.prepareStatement("SELECT b.*, c.name AS customer_name FROM bills b JOIN customers c ON b.customer_id = c.id WHERE b.user_id = ? ORDER BY b.id DESC");
        ps.setInt(1, userId);
        rs = ps.executeQuery();

        while (rs.next()) {
            int billId = rs.getInt("id");
            String invoiceNumber = rs.getString("invoice_number");
            String customerName = rs.getString("customer_name");
            String date = rs.getString("date");
            double totalAmount = rs.getDouble("total_amount");
            String paymentStatus = rs.getString("payment_status");
            double paidAmount = rs.getDouble("paid_amount");
            String paymentDate = rs.getString("payment_date");
%>
            <tr>
                <td><%= invoiceNumber %></td>
                <td><%= billId %></td>
                <td><%= customerName %></td>
                <td><%= date %></td>
                <td>₹<%= String.format("%.2f", totalAmount) %></td>

                <% if ("Pending".equalsIgnoreCase(paymentStatus)) { %>
                <td colspan="3">
                    <form action="<%= request.getContextPath() %>/updatePayment" method="post" class="inline-form" style="display: flex; gap: 10px; justify-content: center;">
                        <input type="hidden" name="billId" value="<%= billId %>" />
                        <input type="number" name="paidAmount" step="0.01" placeholder="Enter amount" required />
                        <select name="paymentStatus">
                            <option value="Paid">Paid</option>
                            <option value="Pending" selected>Pending</option>
                        </select>
                        <input type="submit" value="Update" />
                    </form>
                </td>
                <% } else { %>
                <td class="paid"><%= paymentStatus %></td>
                <td>₹<%= String.format("%.2f", paidAmount) %></td>
                <td><%= paymentDate != null ? paymentDate : "N/A" %></td>
                <% } %>

                <td>
                    <a href="<%= request.getContextPath() %>/jsp/viewBills.jsp?billId=<%= billId %>">View</a> |
                    <a href="<%= request.getContextPath() %>/jsp/editBill.jsp?billId=<%= billId %>">Edit</a> |
                    <a href="<%= request.getContextPath() %>/deleteBill?billId=<%= billId %>" onclick="return confirm('Are you sure you want to delete this bill?');">Delete</a>
                </td>
            </tr>
<%
        }
    } catch (Exception e) {
        out.println("<tr><td colspan='9' style='color:red;'>Error loading bills: " + e.getMessage() + "</td></tr>");
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
%>

        </table>
    </div>
</div>

<%@ include file="footer.jsp" %>

</body>
</html>
