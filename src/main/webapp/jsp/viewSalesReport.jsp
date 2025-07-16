<%@ page import="java.sql.*, com.util.DBConnection" %>
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>

<%@ include file="header.jsp" %>
<%@ include file="sidebar.jsp" %>

<div class="main-content" style="padding: 20px;">
    <h2>Sales Report</h2>

    <table border="1" cellspacing="0" cellpadding="10" width="100%">
        <tr>
            <th>Invoice No.</th>
            <th>Date</th>
            <th>Customer</th>
            <th>Item</th>
            <th>Qty</th>
            <th>Price (₹)</th>
            <th>GST (%)</th>
            <th>Seller Firm</th>
            <th>GST Number</th>
        </tr>

        <%
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                conn = DBConnection.getConnection();

                String query = "SELECT b.invoice_number, b.date, c.name AS customer_name, " +
                               "i.name AS item_name, bi.quantity, bi.price, bi.gst_rate, " +
                               "s.firm_name, s.gst_number " +
                               "FROM bills b " +
                               "JOIN customers c ON b.customer_id = c.id " +
                               "JOIN bill_items bi ON b.id = bi.bill_id " +
                               "JOIN items i ON bi.item_id = i.id " +
                               "LEFT JOIN stock_entries se ON i.id = se.item_id AND se.user_id = ? " +
                               "LEFT JOIN sellers s ON se.seller_id = s.id " +
                               "WHERE b.user_id = ?";

                ps = conn.prepareStatement(query);
                ps.setInt(1, userId);
                ps.setInt(2, userId);
                rs = ps.executeQuery();

                while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getString("invoice_number") %></td>
            <td><%= rs.getTimestamp("date") %></td>
            <td><%= rs.getString("customer_name") %></td>
            <td><%= rs.getString("item_name") %></td>
            <td><%= rs.getInt("quantity") %></td>
            <td>₹<%= rs.getDouble("price") %></td>
            <td><%= rs.getDouble("gst_rate") %>%</td>
            <td><%= rs.getString("firm_name") != null ? rs.getString("firm_name") : "N/A" %></td>
            <td><%= rs.getString("gst_number") != null ? rs.getString("gst_number") : "N/A" %></td>
        </tr>
        <%
                }
            } catch (Exception e) {
                out.println("<tr><td colspan='9' style='color:red;'>Error loading report: " + e.getMessage() + "</td></tr>");
                e.printStackTrace();
            } finally {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            }
        %>
    </table>
</div>

<%@ include file="footer.jsp" %>
