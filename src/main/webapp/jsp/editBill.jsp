<%@ page import="java.sql.*" %>
<%@ page import="com.util.DBConnection" %>
<%@ page import="java.time.LocalDate" %>
<%@ page session="true" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String billIdStr = request.getParameter("billId");
    if (billIdStr == null) {
        out.println("No bill selected.");
        return;
    }

    int billId = Integer.parseInt(billIdStr);

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    int customerId = 0;
    double totalAmount = 0;
    String date = "";
    String paymentStatus = "";
    double paidAmount = 0;
    String paymentDate = "";

    try {
        conn = DBConnection.getConnection();

        // ✅ Make sure the bill belongs to the logged-in user
        ps = conn.prepareStatement("SELECT * FROM bills WHERE id = ? AND user_id = ?");
        ps.setInt(1, billId);
        ps.setInt(2, userId);
        rs = ps.executeQuery();

        if (rs.next()) {
            customerId = rs.getInt("customer_id");
            totalAmount = rs.getDouble("total_amount");
            date = rs.getString("date");
            paymentStatus = rs.getString("payment_status");
            paidAmount = rs.getDouble("paid_amount");
            paymentDate = rs.getString("payment_date");
        } else {
            out.println("Bill not found or you do not have permission to edit this bill.");
            return;
        }

        rs.close();
        ps.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
        return;
    } finally {
        try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>

<%@ include file="header.jsp" %>

<div class="main-container" style="display: flex; min-height: 80vh;">
    <%@ include file="sidebar.jsp" %>

    <div class="content" style="flex: 1; padding: 20px;">
        <h2>Edit Bill</h2>
        <form action="<%= request.getContextPath() %>/updateBill" method="post">
            <input type="hidden" name="billId" value="<%= billId %>"/>

            <label>Customer:</label>
            <select name="customerId" required>
                <%
                    conn = DBConnection.getConnection();
                    ps = conn.prepareStatement("SELECT * FROM customers WHERE user_id = ?");
                    ps.setInt(1, userId);
                    rs = ps.executeQuery();
                    while (rs.next()) {
                        int cid = rs.getInt("id");
                        String cname = rs.getString("name");
                %>
                <option value="<%= cid %>" <%= (cid == customerId) ? "selected" : "" %>><%= cname %></option>
                <%
                    }
                    rs.close();
                    ps.close();
                    conn.close();
                %>
            </select><br><br>

            <label>Date:</label>
            <input type="date" name="billDate" value="<%= date %>" required /><br><br>

            <label>Total Amount:</label>
            <input type="number" name="totalAmount" step="0.01" value="<%= totalAmount %>" required /><br><br>

            <h3>Payment Details</h3>
            <label>Payment Status:</label>
            <select name="paymentStatus" required>
                <option value="Paid" <%= "Paid".equalsIgnoreCase(paymentStatus) ? "selected" : "" %>>Paid</option>
                <option value="Pending" <%= "Pending".equalsIgnoreCase(paymentStatus) ? "selected" : "" %>>Pending</option>
            </select><br><br>

            <label>Paid Amount:</label>
            <input type="number" name="paidAmount" step="0.01" value="<%= paidAmount %>" required /><br><br>

            <label>Payment Date:</label>
            <input type="date" name="paymentDate" value="<%= paymentDate != null ? paymentDate : "" %>" /><br><br>

            <input type="submit" value="Update Bill" />
        </form>
    </div>
</div>

<%@ include file="footer.jsp" %>
