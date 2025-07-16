<%@ page import="java.sql.*, com.util.DBConnection" %>
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <title>Stock Report</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        .layout-container {
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
            border: 1px solid #aaa;
            padding: 10px;
            text-align: center;
        }
        select, input[type="number"], input[type="submit"] {
            padding: 5px;
        }
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="layout-container">
    <%@ include file="sidebar.jsp" %>

    <div class="main-content">
        <h2>Stock Report</h2>

        <table>
            <tr>
                <th>Item Name</th>
                <th>Price (₹)</th>
                <th>Quantity Left</th>
                <th>Restock</th>
                <th>Delete</th>
            </tr>
            <%
                Integer userId = (Integer) session.getAttribute("userId");
                if (userId == null) {
                    response.sendRedirect("index.jsp");
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

                    while (rs.next()) {
                        int itemId = rs.getInt("id");
                        String name = rs.getString("name");
                        double price = rs.getDouble("price");
                        int quantity = rs.getInt("quantity");
            %>
            <tr>
                <td><%= name %></td>
                <td><%= String.format("%.2f", price) %></td>
                <td><%= quantity %></td>
                <td>
                    <form action="../restockItem" method="post" style="display:inline;">
                        <input type="hidden" name="itemId" value="<%= itemId %>">
                        <input type="number" name="addQuantity" min="1" placeholder="Qty" required style="width: 60px;" />

                        <select name="sellerId" required>
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

                        <input type="submit" value="Add">
                    </form>
                </td>
                <td>
                    <form action="../deleteItem" method="post" onsubmit="return confirm('Are you sure?');">
                        <input type="hidden" name="itemId" value="<%= itemId %>">
                        <input type="submit" value="Delete">
                    </form>
                </td>
            </tr>
            <%
                    }
                } catch (Exception e) {
                    out.println("<p style='color:red;'>Error loading stock: " + e.getMessage() + "</p>");
                    e.printStackTrace();
                } finally {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                }
            %>
        </table>
    </div>
</div>

<%@ include file="footer.jsp" %>
</body>
</html>
