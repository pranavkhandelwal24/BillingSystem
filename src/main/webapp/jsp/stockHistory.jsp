<%@ page import="java.sql.*, com.util.DBConnection" %>
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <title>Stock Entry History</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        .layout {
            display: flex;
            min-height: 80vh;
        }
        .main-content {
            flex: 1;
            padding: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        th, td {
            border: 1px solid #ccc;
            padding: 10px;
            text-align: center;
        }
        th {
            background-color: #f3f3f3;
        }
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="layout">
    <%@ include file="sidebar.jsp" %>

    <div class="main-content">
        <h2>Stock Entry History</h2>

        <table>
            <tr>
                <th>Item Name</th>
                <th>Quantity Added</th>
                <th>Date Added</th>
                <th>Seller Firm</th>
                <th>GST Number</th>
                <th>Email</th>
                <th>Phone</th>
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
                    String sql = "SELECT i.name AS item_name, se.quantity, se.date_added, " +
                                 "s.firm_name, s.gst_number, s.email, s.phone " +
                                 "FROM stock_entries se " +
                                 "JOIN items i ON se.item_id = i.id " +
                                 "JOIN sellers s ON se.seller_id = s.id " +
                                 "WHERE se.user_id = ? " +
                                 "ORDER BY se.date_added DESC";

                    ps = conn.prepareStatement(sql);
                    ps.setInt(1, userId);
                    rs = ps.executeQuery();

                    while (rs.next()) {
            %>
                <tr>
                    <td><%= rs.getString("item_name") %></td>
                    <td><%= rs.getInt("quantity") %></td>
                    <td><%= rs.getTimestamp("date_added") %></td>
                    <td><%= rs.getString("firm_name") %></td>
                    <td><%= rs.getString("gst_number") %></td>
                    <td><%= rs.getString("email") %></td>
                    <td><%= rs.getString("phone") %></td>
                </tr>
            <%
                    }
                } catch (Exception e) {
                    out.println("<p style='color:red;'>Error loading history: " + e.getMessage() + "</p>");
                    e.printStackTrace();
                } finally {
                    try {
                        if (rs != null) rs.close();
                        if (ps != null) ps.close();
                        if (conn != null) conn.close();
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                }
            %>
        </table>
    </div>
</div>

<%@ include file="footer.jsp" %>
</body>
</html>
