<%@ page import="java.sql.*" %>
<%@ page import="com.util.DBConnection" %>
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <title>Dashboard - Tally System</title>
    <style>
        .dashboard-container {
            padding: 20px;
            font-family: Arial, sans-serif;
        }
        .dashboard-container h2 {
            text-align: center;
            margin-bottom: 30px;
            font-size: 28px;
            color: #333;
        }
        table.dashboard-table {
            width: 60%;
            margin: 0 auto;
            border-collapse: collapse;
            box-shadow: 0 0 10px #ccc;
        }
        table.dashboard-table th {
            background-color: #f0f0f0;
            color: #333;
            font-size: 18px;
            padding: 12px;
        }
        table.dashboard-table td {
            font-size: 16px;
            padding: 12px;
            text-align: center;
        }
        tr:nth-child(even) {
            background-color: #fafafa;
        }
    </style>
</head>
<body>

<%@ include file="header.jsp" %>
<%@ include file="sidebar.jsp" %>

<div class="dashboard-container">
    <h2>Dashboard Overview</h2>

    <%
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        double stockValue = 0.0;
        double totalPaid = 0.0;
        double totalDue = 0.0;
        int totalBills = 0;
        int totalCustomers = 0;

        try {
            conn = DBConnection.getConnection();

            ps = conn.prepareStatement("SELECT SUM(quantity * price) AS total_stock_value FROM items WHERE user_id = ?");
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) stockValue = rs.getDouble("total_stock_value");
            rs.close();
            ps.close();

            ps = conn.prepareStatement("SELECT SUM(paid_amount) AS total_paid FROM bills WHERE user_id = ?");
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) totalPaid = rs.getDouble("total_paid");
            rs.close();
            ps.close();

            ps = conn.prepareStatement("SELECT SUM(total_amount - paid_amount) AS total_due FROM bills WHERE user_id = ? AND total_amount > paid_amount");
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) totalDue = rs.getDouble("total_due");
            rs.close();
            ps.close();

            ps = conn.prepareStatement("SELECT COUNT(*) AS total_bills FROM bills WHERE user_id = ?");
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) totalBills = rs.getInt("total_bills");
            rs.close();
            ps.close();

            ps = conn.prepareStatement("SELECT COUNT(*) AS total_customers FROM customers WHERE user_id = ?");
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) totalCustomers = rs.getInt("total_customers");
            rs.close();
            ps.close();

        } catch (Exception e) {
            out.println("<p style='color:red;'>Error loading dashboard: " + e.getMessage() + "</p>");
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    %>

    <table class="dashboard-table">
        <tr>
            <th>Metric</th>
            <th>Value</th>
        </tr>
        <tr>
            <td>Total Stock Value</td>
            <td><%= String.format("%.2f", stockValue) %> Rs.</td>
        </tr>
        <tr>
            <td>Total Paid Amount</td>
            <td><%= String.format("%.2f", totalPaid) %> Rs.</td>
        </tr>
        <tr>
            <td>Total Outstanding Due</td>
            <td><%= String.format("%.2f", totalDue) %> Rs.</td>
        </tr>
        <tr>
            <td>Total Bills Issued</td>
            <td><%= totalBills %></td>
        </tr>
        <tr>
            <td>Total Customers</td>
            <td><%= totalCustomers %></td>
        </tr>
    </table>
</div>

<%@ include file="footer.jsp" %>
</body>
</html>
