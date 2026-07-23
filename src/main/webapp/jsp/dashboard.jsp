<%@ page import="java.sql.*" %>
<%@ page import="com.util.DBConnection" %>
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ include file="header.jsp" %>

<h2 class="page-title">Dashboard Overview</h2>

<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
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
%>
        <div class="alert alert-error">Error loading dashboard: <%= e.getMessage() %></div>
<%
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

<div class="metrics-grid">
    <div class="metric-card">
        <div class="metric-label">Total Stock Value</div>
        <div class="metric-value">Rs. <%= String.format("%.2f", stockValue) %></div>
    </div>
    
    <div class="metric-card">
        <div class="metric-label">Total Paid Amount</div>
        <div class="metric-value" style="color: #10b981;">Rs. <%= String.format("%.2f", totalPaid) %></div>
    </div>
    
    <div class="metric-card">
        <div class="metric-label">Total Outstanding Due</div>
        <div class="metric-value" style="color: #ef4444;">Rs. <%= String.format("%.2f", totalDue) %></div>
    </div>

    <div class="metric-card">
        <div class="metric-label">Bills Issued</div>
        <div class="metric-value"><%= totalBills %></div>
    </div>

    <div class="metric-card">
        <div class="metric-label">Total Customers</div>
        <div class="metric-value"><%= totalCustomers %></div>
    </div>
</div>

<div class="card">
    <h3 style="margin-bottom: 15px; font-weight: 600;">Welcome to Tally Billing</h3>
    <p style="color: var(--text-secondary);">Use the left side menu to manage your items, register sellers, add customers, generate bills, and view real-time reports of your stock and invoice status.</p>
</div>

<%@ include file="footer.jsp" %>
