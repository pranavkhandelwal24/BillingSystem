<%@ page import="java.sql.*, com.util.DBConnection" %>
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
%>

<%@ include file="header.jsp" %>

<h2 class="page-title">Sales & Stock Report</h2>

<div class="card">
    <div style="overflow-x: auto;">
        <table class="table">
            <thead>
                <tr>
                    <th>Invoice No</th>
                    <th>Date Sold</th>
                    <th>Customer Name</th>
                    <th>Item Description</th>
                    <th>Quantity Sold</th>
                    <th>Unit Price (Rs.)</th>
                    <th>GST Rate</th>
                    <th>Seller Firm</th>
                    <th>GST Number</th>
                </tr>
            </thead>
            <tbody>
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

                boolean hasData = false;
                while (rs.next()) {
                    hasData = true;
        %>
                <tr>
                    <td style="font-weight: 600;"><%= rs.getString("invoice_number") %></td>
                    <td><%= rs.getTimestamp("date") %></td>
                    <td><%= rs.getString("customer_name") %></td>
                    <td style="font-weight: 500;"><%= rs.getString("item_name") %></td>
                    <td><%= rs.getInt("quantity") %></td>
                    <td>Rs. <%= String.format("%.2f", rs.getDouble("price")) %></td>
                    <td><%= rs.getDouble("gst_rate") %>%</td>
                    <td><%= rs.getString("firm_name") != null ? rs.getString("firm_name") : "N/A" %></td>
                    <td><%= rs.getString("gst_number") != null ? rs.getString("gst_number") : "N/A" %></td>
                </tr>
        <%
                }
                if (!hasData) {
        %>
                <tr>
                    <td colspan="9" style="text-align: center; color: var(--text-secondary); padding: 30px 10px;">No sales transactions recorded yet.</td>
                </tr>
        <%
                }
            } catch (Exception e) {
        %>
                <tr>
                    <td colspan="9" style="color: var(--danger-color); font-weight: 500; text-align: center;">Error loading sales report: <%= e.getMessage() %></td>
                </tr>
        <%
                e.printStackTrace();
            } finally {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            }
        %>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="footer.jsp" %>
