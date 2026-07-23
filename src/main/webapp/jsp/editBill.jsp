<%@ page import="java.sql.*" %>
<%@ page import="com.util.DBConnection" %>
<%@ page import="java.time.LocalDate" %>
<%@ page session="true" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
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

        // Make sure the bill belongs to the logged-in user
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
            out.println("Bill not found or access denied.");
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

<h2 class="page-title">Edit Bill</h2>

<div class="card" style="max-width: 600px;">
    <form action="<%= request.getContextPath() %>/updateBill" method="post">
        <input type="hidden" name="billId" value="<%= billId %>"/>

        <div class="form-group">
            <label for="customerId">Customer</label>
            <select name="customerId" id="customerId" required>
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
            </select>
        </div>

        <div class="form-group">
            <label for="billDate">Bill Date</label>
            <input type="date" name="billDate" id="billDate" value="<%= date %>" required />
        </div>

        <div class="form-group">
            <label for="totalAmount">Total Amount (Rs.)</label>
            <input type="number" name="totalAmount" id="totalAmount" step="0.01" value="<%= totalAmount %>" required />
        </div>

        <h3 style="font-size: 15px; font-weight: 600; margin: 25px 0 10px 0; border-bottom: 1px solid var(--border-color); padding-bottom: 8px; color: var(--text-secondary);">Payment Details</h3>

        <div class="form-group">
            <label for="paymentStatus">Payment Status</label>
            <select name="paymentStatus" id="paymentStatus" required>
                <option value="Paid" <%= "Paid".equalsIgnoreCase(paymentStatus) ? "selected" : "" %>>Paid</option>
                <option value="Pending" <%= "Pending".equalsIgnoreCase(paymentStatus) ? "selected" : "" %>>Pending</option>
            </select>
        </div>

        <div class="form-group">
            <label for="paidAmount">Paid Amount (Rs.)</label>
            <input type="number" name="paidAmount" id="paidAmount" step="0.01" value="<%= paidAmount %>" required />
        </div>

        <div class="form-group">
            <label for="paymentDate">Payment Date</label>
            <input type="date" name="paymentDate" id="paymentDate" value="<%= paymentDate != null ? paymentDate : "" %>" />
        </div>

        <button type="submit" class="btn btn-primary">Update Bill</button>
    </form>
</div>

<%@ include file="footer.jsp" %>
