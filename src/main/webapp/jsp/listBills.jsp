<%@ page import="java.sql.*" %>
<%@ page import="com.util.DBConnection" %>
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ include file="header.jsp" %>

<h2 class="page-title">All Invoices & Bills</h2>

<div class="card">
    <div style="overflow-x: auto;">
        <table class="table">
            <thead>
                <tr>
                    <th>Invoice No</th>
                    <th>Customer Name</th>
                    <th>Date</th>
                    <th>Total Amount</th>
                    <th>Payment Status</th>
                    <th>Paid Amount</th>
                    <th>Payment Date</th>
                    <th style="width: 200px; text-align: center;">Actions</th>
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
        ps = conn.prepareStatement("SELECT b.*, c.name AS customer_name FROM bills b JOIN customers c ON b.customer_id = c.id WHERE b.user_id = ? ORDER BY b.id DESC");
        ps.setInt(1, userId);
        rs = ps.executeQuery();

        boolean hasBills = false;
        while (rs.next()) {
            hasBills = true;
            int billId = rs.getInt("id");
            String invoiceNumber = rs.getString("invoice_number");
            String customerName = rs.getString("customer_name");
            String date = rs.getString("date");
            double totalAmount = rs.getDouble("total_amount");
            String paymentStatus = rs.getString("payment_status");
            double paidAmount = rs.getDouble("paid_amount");
            String paymentDate = rs.getString("payment_date");
            
            boolean isPending = "Pending".equalsIgnoreCase(paymentStatus);
%>
                <tr>
                    <td style="font-weight: 600;"><%= invoiceNumber %></td>
                    <td><%= customerName %></td>
                    <td><%= date %></td>
                    <td style="font-weight: 500;">Rs. <%= String.format("%.2f", totalAmount) %></td>

                    <% if (isPending) { %>
                    <td colspan="3" style="background-color: #fff9f5;">
                        <form action="<%= request.getContextPath() %>/updatePayment" method="post" style="display: flex; gap: 8px; align-items: center; justify-content: start; flex-wrap: nowrap; margin: 0;">
                            <input type="hidden" name="billId" value="<%= billId %>" />
                            <input type="number" name="paidAmount" step="0.01" placeholder="Amount" required style="max-width: 100px; padding: 4px 8px; font-size: 13px;" />
                            <select name="paymentStatus" style="max-width: 100px; padding: 4px 8px; font-size: 13px;">
                                <option value="Paid">Paid</option>
                                <option value="Pending" selected>Pending</option>
                            </select>
                            <button type="submit" class="btn btn-secondary btn-sm" style="padding: 4px 10px;">Update</button>
                        </form>
                    </td>
                    <% } else { %>
                    <td>
                        <span class="badge badge-success">Paid</span>
                    </td>
                    <td style="color: var(--success-color); font-weight: 500;">Rs. <%= String.format("%.2f", paidAmount) %></td>
                    <td><%= paymentDate != null ? paymentDate : "N/A" %></td>
                    <% } %>

                    <td style="text-align: center;">
                        <div style="display: flex; gap: 10px; justify-content: center; align-items: center;">
                            <a href="<%= request.getContextPath() %>/jsp/viewBills.jsp?billId=<%= billId %>" class="btn btn-secondary btn-sm" style="padding: 3px 8px;">View</a>
                            <a href="<%= request.getContextPath() %>/jsp/editBill.jsp?billId=<%= billId %>" class="btn btn-secondary btn-sm" style="padding: 3px 8px; color: var(--primary-color);">Edit</a>
                            <a href="<%= request.getContextPath() %>/deleteBill?billId=<%= billId %>" onclick="return confirm('Are you sure you want to delete this bill?');" class="btn btn-danger btn-sm" style="padding: 3px 8px; background-color: #fef2f2; color: var(--danger-color); border-color: #fca5a5;">Delete</a>
                        </div>
                    </td>
                </tr>
<%
        }
        if (!hasBills) {
%>
            <tr>
                <td colspan="8" style="text-align: center; color: var(--text-secondary); padding: 30px 10px;">No bills or invoices issued yet.</td>
            </tr>
<%
        }
    } catch (Exception e) {
%>
        <tr>
            <td colspan="8" style="color: var(--danger-color); font-weight: 500; text-align: center;">Error loading bills: <%= e.getMessage() %></td>
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
