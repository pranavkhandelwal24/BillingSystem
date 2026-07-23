<%@ page import="java.sql.*, com.util.DBConnection" %>
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ include file="header.jsp" %>

<h2 class="page-title">Stock Entry History</h2>

<div class="card">
    <div style="overflow-x: auto;">
        <table class="table">
            <thead>
                <tr>
                    <th>Item Name</th>
                    <th>Type</th>
                    <th>Quantity Change</th>
                    <th>Party (Seller / Customer)</th>
                    <th>Date</th>
                    <th>GST Number</th>
                    <th>Email Address</th>
                    <th>Phone Number</th>
                </tr>
            </thead>
            <tbody>
            <%
                Integer userId = (Integer) session.getAttribute("userId");
                if (userId == null) {
                    response.sendRedirect(request.getContextPath() + "/index.jsp");
                    return;
                }

                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                try {
                    conn = DBConnection.getConnection();
                    String sql = "SELECT * FROM (" +
                                 "  SELECT i.name AS item_name, se.quantity AS quantity, se.date_added AS date_added, " +
                                 "  s.firm_name AS party_name, s.gst_number AS gst_number, s.email AS email, s.phone AS phone, " +
                                 "  'IN' AS flow_type " +
                                 "  FROM stock_entries se " +
                                 "  JOIN items i ON se.item_id = i.id " +
                                 "  JOIN sellers s ON se.seller_id = s.id " +
                                 "  WHERE se.user_id = ? " +
                                 "  UNION ALL " +
                                 "  SELECT i.name AS item_name, -bi.quantity AS quantity, b.date AS date_added, " +
                                 "  c.name AS party_name, c.gst_number AS gst_number, c.email AS email, c.phone AS phone, " +
                                 "  'OUT' AS flow_type " +
                                 "  FROM bill_items bi " +
                                 "  JOIN items i ON bi.item_id = i.id " +
                                 "  JOIN bills b ON bi.bill_id = b.id " +
                                 "  JOIN customers c ON b.customer_id = c.id " +
                                 "  WHERE bi.user_id = ?" +
                                 ") combined " +
                                 "ORDER BY date_added DESC";

                    ps = conn.prepareStatement(sql);
                    ps.setInt(1, userId);
                    ps.setInt(2, userId);
                    rs = ps.executeQuery();

                    boolean hasEntries = false;
                    while (rs.next()) {
                        hasEntries = true;
                        String flowType = rs.getString("flow_type");
                        int qty = rs.getInt("quantity");
                        boolean isIncoming = "IN".equals(flowType);
            %>
                <tr>
                    <td style="font-weight: 600;"><%= rs.getString("item_name") %></td>
                    <td>
                        <% if (isIncoming) { %>
                            <span class="badge badge-success">Restock</span>
                        <% } else { %>
                            <span class="badge badge-danger" style="background-color: #fee2e2; color: #b91c1c;">Sale</span>
                        <% } %>
                    </td>
                    <td>
                        <% if (isIncoming) { %>
                            <span style="color: var(--success-color); font-weight: 600;">+<%= qty %></span>
                        <% } else { %>
                            <span style="color: var(--danger-color); font-weight: 600;"><%= qty %></span>
                        <% } %>
                    </td>
                    <td><%= rs.getString("party_name") %></td>
                    <td><%= rs.getTimestamp("date_added") %></td>
                    <td><%= rs.getString("gst_number") %></td>
                    <td><%= rs.getString("email") %></td>
                    <td><%= rs.getString("phone") %></td>
                </tr>
            <%
                    }
                    if (!hasEntries) {
            %>
                <tr>
                    <td colspan="8" style="text-align: center; color: var(--text-secondary); padding: 30px 10px;">No stock restock or sales history found.</td>
                </tr>
            <%
                    }
                } catch (Exception e) {
            %>
                <tr>
                    <td colspan="8" style="color: var(--danger-color); font-weight: 500; text-align: center;">Error loading history: <%= e.getMessage() %></td>
                </tr>
            <%
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
            </tbody>
        </table>
    </div>
</div>

<%@ include file="footer.jsp" %>
