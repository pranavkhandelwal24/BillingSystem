<%@ page import="java.sql.*, com.util.DBConnection" %>
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ include file="header.jsp" %>

<h2 class="page-title">Manage Stock</h2>

<div class="card">
    <div style="overflow-x: auto;">
        <table class="table">
            <thead>
                <tr>
                    <th>Item Name</th>
                    <th>Unit Price (Rs.)</th>
                    <th>Current Quantity</th>
                    <th>Restock Item</th>
                    <th style="width: 100px; text-align: center;">Actions</th>
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
                PreparedStatement stmt = null;
                ResultSet rs = null;

                try {
                    conn = DBConnection.getConnection();
                    stmt = conn.prepareStatement("SELECT * FROM items WHERE user_id = ?");
                    stmt.setInt(1, userId);
                    rs = stmt.executeQuery();

                    boolean hasItems = false;
                    while (rs.next()) {
                        hasItems = true;
                        int itemId = rs.getInt("id");
                        String name = rs.getString("name");
                        double price = rs.getDouble("price");
                        int quantity = rs.getInt("quantity");
                        
                        boolean isLowStock = quantity <= 5;
            %>
            <tr>
                <td style="font-weight: 600;"><%= name %></td>
                <td>Rs. <%= String.format("%.2f", price) %></td>
                <td>
                    <% if (isLowStock) { %>
                        <span class="badge badge-danger" style="font-weight: 600;"><%= quantity %> (Low Stock)</span>
                    <% } else { %>
                        <span class="badge badge-success" style="background-color: #ecfdf5; color: #047857;"><%= quantity %></span>
                    <% } %>
                </td>
                <td style="background-color: #fcfdfe;">
                    <form action="../restockItem" method="post" style="display: flex; gap: 8px; align-items: center; justify-content: start; flex-wrap: nowrap; margin: 0;">
                        <input type="hidden" name="itemId" value="<%= itemId %>">
                        <input type="number" name="addQuantity" min="1" placeholder="Add Qty" required style="max-width: 90px; padding: 5px 8px; font-size: 13px;" />

                        <select name="sellerId" required style="max-width: 180px; padding: 5px 8px; font-size: 13px;">
                            <option value="">Select Seller</option>
                            <%
                                Connection sellerConn = DBConnection.getConnection();
                                PreparedStatement sellerPs = sellerConn.prepareStatement("SELECT id, firm_name FROM sellers WHERE user_id = ?");
                                sellerPs.setInt(1, userId);
                                ResultSet sellerRs = sellerPs.executeQuery();
                                while (sellerRs.next()) {
                            %>
                                <option value="<%= sellerRs.getInt("id") %>"><%= sellerRs.getString("firm_name") %></option>
                            <% } 
                                sellerRs.close(); 
                                sellerPs.close(); 
                                sellerConn.close(); 
                            %>
                        </select>

                        <button type="submit" class="btn btn-secondary btn-sm" style="padding: 5px 12px;">Restock</button>
                    </form>
                </td>
                <td style="text-align: center;">
                    <form action="../deleteItem" method="post" onsubmit="return confirm('Are you sure you want to delete this item?');" style="margin: 0;">
                        <input type="hidden" name="itemId" value="<%= itemId %>">
                        <button type="submit" class="btn btn-danger btn-sm" style="padding: 4px 10px; background-color: #fef2f2; color: var(--danger-color); border-color: #fca5a5;">Delete</button>
                    </form>
                </td>
            </tr>
            <%
                    }
                    if (!hasItems) {
            %>
            <tr>
                <td colspan="5" style="text-align: center; color: var(--text-secondary); padding: 30px 10px;">No items registered in stock.</td>
            </tr>
            <%
                    }
                } catch (Exception e) {
            %>
            <tr>
                <td colspan="5" style="color: var(--danger-color); font-weight: 500; text-align: center;">Error loading stock: <%= e.getMessage() %></td>
            </tr>
            <%
                    e.printStackTrace();
                } finally {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                }
            %>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="footer.jsp" %>
