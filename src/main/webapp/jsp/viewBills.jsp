<%@ page import="java.sql.*, java.util.*, com.util.DBConnection" %>
<%@ include file="header.jsp" %>

<h2 class="page-title no-print">View Past Bills & Invoices</h2>

<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    Connection conn = null;
    try {
        conn = DBConnection.getConnection();

        // Step 1: Fetch all bills for dropdown (only for logged-in user)
        PreparedStatement billDropdownStmt = conn.prepareStatement(
            "SELECT b.id, b.invoice_number, b.date, c.name FROM bills b JOIN customers c ON b.customer_id = c.id WHERE b.user_id = ? ORDER BY b.id DESC"
        );
        billDropdownStmt.setInt(1, userId);
        ResultSet allBills = billDropdownStmt.executeQuery();
%>

<div class="card no-print">
    <form method="get" action="viewBills.jsp">
        <div class="form-group" style="max-width: 400px; margin-bottom: 0;">
            <label for="billSelect">Select Invoice to View</label>
            <select name="billId" id="billSelect" onchange="this.form.submit()" required>
                <option value="">-- Choose an invoice --</option>
                <%
                    String billIdParam = request.getParameter("billId");
                    int selectedBillId = (billIdParam != null && !billIdParam.equals("")) ? Integer.parseInt(billIdParam) : -1;

                    while (allBills.next()) {
                        int bId = allBills.getInt("id");
                        String date = allBills.getString("date");
                        String customer = allBills.getString("name");
                        String invoice = allBills.getString("invoice_number");
                %>
                    <option value="<%= bId %>" <%= (selectedBillId == bId) ? "selected" : "" %>>
                        <%= invoice %> - <%= customer %> - <%= date %>
                    </option>
                <% } %>
            </select>
        </div>
    </form>
</div>

<%
    if (selectedBillId == -1) {
%>
    <div class="card no-print" style="text-align: center; color: var(--text-secondary); padding: 40px 10px;">
        Please select an invoice from the dropdown above to view details.
    </div>
<%
    } else {
        try {
            // Step 2: Verify selected bill belongs to this user
            PreparedStatement verifyBillStmt = conn.prepareStatement("SELECT * FROM bills WHERE id = ? AND user_id = ?");
            verifyBillStmt.setInt(1, selectedBillId);
            verifyBillStmt.setInt(2, userId);
            ResultSet billRs = verifyBillStmt.executeQuery();

            if (!billRs.next()) {
%>
    <div class="alert alert-error no-print">Invalid bill selection or access denied.</div>
<%
            } else {
                int customerId = billRs.getInt("customer_id");
                double totalAmount = billRs.getDouble("total_amount");
                String billDate = billRs.getString("date");
                String invoiceNumber = billRs.getString("invoice_number");

                // Step 3: Get customer
                PreparedStatement custStmt = conn.prepareStatement("SELECT * FROM customers WHERE id = ?");
                custStmt.setInt(1, customerId);
                ResultSet custRs = custStmt.executeQuery();
                custRs.next();

                // Step 4: Get bill items
                PreparedStatement itemStmt = conn.prepareStatement(
                    "SELECT bi.*, i.name FROM bill_items bi JOIN items i ON bi.item_id = i.id WHERE bi.bill_id = ?"
                );
                itemStmt.setInt(1, selectedBillId);
                ResultSet itemRs = itemStmt.executeQuery();
%>

<% if (request.getParameter("emailSent") != null) { %>
    <div class="alert alert-success no-print">Invoice has been successfully sent to customer's email!</div>
<% } %>

<div class="card print-area" style="background: #fff; padding: 40px; border: 1px solid #d1d5db; max-width: 800px; margin: 0 auto; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);">
    
    <!-- Invoice Header -->
    <div style="display: flex; justify-content: space-between; align-items: start; border-bottom: 2px solid #e5e7eb; padding-bottom: 20px; margin-bottom: 25px;">
        <div>
            <% if (session.getAttribute("companyLogo") != null && !session.getAttribute("companyLogo").toString().isEmpty()) { %>
                <img src="<%= session.getAttribute("companyLogo") %>" alt="Company Logo" style="max-height: 50px; margin-bottom: 10px;" />
            <% } %>
            <h2 style="font-size: 20px; font-weight: 700; color: #111827; margin: 0;"><%= session.getAttribute("companyName") %></h2>
            <p style="color: #4b5563; font-size: 13px; margin-top: 5px; line-height: 1.4;">
                <%= session.getAttribute("companyAddress") %><br/>
                GSTIN: <%= session.getAttribute("companyGST") %><br/>
                Email: <%= session.getAttribute("companyEmail") %><br/>
                Phone: <%= session.getAttribute("companyPhone") %>
            </p>
        </div>
        <div style="text-align: right;">
            <h1 style="font-size: 28px; font-weight: 800; color: #4f46e5; margin: 0; text-transform: uppercase; letter-spacing: 0.05em;">Invoice</h1>
            <p style="font-size: 14px; color: #4b5563; margin-top: 5px;">
                <strong>Invoice No:</strong> <%= invoiceNumber %><br/>
                <strong>Date:</strong> <%= billDate %><br/>
                <strong>Bill ID:</strong> <%= selectedBillId %>
            </p>
        </div>
    </div>

    <!-- Bill To / Bill From Details -->
    <div style="margin-bottom: 30px;">
        <h3 style="font-size: 12px; text-transform: uppercase; font-weight: 700; color: #9ca3af; letter-spacing: 0.05em; border-bottom: 1px solid #f3f4f6; padding-bottom: 5px; margin-bottom: 8px;">Bill To</h3>
        <p style="font-size: 14px; color: #1f2937; font-weight: 600; margin: 0;"><%= custRs.getString("name") %></p>
        <p style="color: #4b5563; font-size: 13px; margin-top: 4px; line-height: 1.4;">
            <%= custRs.getString("address") %><br/>
            GSTIN: <%= custRs.getString("gst_number") %><br/>
            Email: <%= custRs.getString("email") %><br/>
            Phone: <%= custRs.getString("phone") %>
        </p>
    </div>

    <!-- Items Table -->
    <table style="width: 100%; border-collapse: collapse; margin-bottom: 25px; font-size: 13px;">
        <thead>
            <tr style="border-bottom: 2px solid #e5e7eb; color: #374151; font-weight: 600; text-align: left;">
                <th style="padding: 10px 5px;">Item Description</th>
                <th style="padding: 10px 5px; text-align: right;">Price (Rs.)</th>
                <th style="padding: 10px 5px; text-align: right;">GST (%)</th>
                <th style="padding: 10px 5px; text-align: right;">Quantity</th>
                <th style="padding: 10px 5px; text-align: right;">Subtotal (Rs.)</th>
                <th style="padding: 10px 5px; text-align: right;">GST Amt (Rs.)</th>
                <th style="padding: 10px 5px; text-align: right;">Total (Rs.)</th>
            </tr>
        </thead>
        <tbody>
            <%
                double grandTotal = 0.0;
                while (itemRs.next()) {
                    String name = itemRs.getString("name");
                    double price = itemRs.getDouble("price");
                    double gstRate = itemRs.getDouble("gst_rate");
                    int qty = itemRs.getInt("quantity");

                    double subtotal = price * qty;
                    double gstAmount = subtotal * gstRate / 100;
                    double total = subtotal + gstAmount;
                    grandTotal += total;
            %>
                <tr style="border-bottom: 1px solid #f3f4f6; color: #4b5563;">
                    <td style="padding: 10px 5px; font-weight: 500; color: #111827;"><%= name %></td>
                    <td style="padding: 10px 5px; text-align: right;"><%= String.format("%.2f", price) %></td>
                    <td style="padding: 10px 5px; text-align: right;"><%= gstRate %>%</td>
                    <td style="padding: 10px 5px; text-align: right;"><%= qty %></td>
                    <td style="padding: 10px 5px; text-align: right;"><%= String.format("%.2f", subtotal) %></td>
                    <td style="padding: 10px 5px; text-align: right;"><%= String.format("%.2f", gstAmount) %></td>
                    <td style="padding: 10px 5px; text-align: right; font-weight: 500; color: #111827;"><%= String.format("%.2f", total) %></td>
                </tr>
            <% } %>
        </tbody>
    </table>

    <!-- Totals Area -->
    <div style="display: flex; justify-content: flex-end; border-top: 1px solid #e5e7eb; padding-top: 15px;">
        <div style="width: 300px; font-size: 14px;">
            <div style="display: flex; justify-content: space-between; font-weight: 700; font-size: 16px; color: #111827; border-top: 2px double #e5e7eb; padding-top: 8px;">
                <span>Total Amount:</span>
                <span style="color: #4f46e5;">Rs. <%= String.format("%.2f", grandTotal) %></span>
            </div>
        </div>
    </div>
</div>

<div class="no-print" style="margin-top: 25px; display: flex; gap: 10px; justify-content: center;">
    <a href="<%= request.getContextPath() %>/exportBillPdf?billId=<%= selectedBillId %>" target="_blank" class="btn btn-primary">Download as PDF</a>
    <button onclick="window.print()" class="btn btn-secondary">Print Invoice</button>
    <form method="get" action="<%= request.getContextPath() %>/sendInvoice" style="display:inline; margin: 0;">
        <input type="hidden" name="billId" value="<%= selectedBillId %>" />
        <button type="submit" class="btn btn-secondary" style="color: var(--primary-color);">Send Invoice to Customer Email</button>
    </form>
</div>

<!-- Print-specific styles override -->
<style>
@media print {
    .no-print, .app-header, .sidebar, .app-footer, .page-title {
        display: none !important;
    }
    body, .app-container, .main-layout, .content-area {
        background: #fff !important;
        padding: 0 !important;
        margin: 0 !important;
    }
    .print-area {
        border: none !important;
        box-shadow: none !important;
        padding: 0 !important;
        margin: 0 auto !important;
        max-width: 100% !important;
    }
}
</style>

<%
            }
        } catch (Exception ex) {
%>
    <div class="alert alert-error no-print">Error loading bill: <%= ex.getMessage() %></div>
<%
            ex.printStackTrace();
        }
    }
} catch (Exception outerEx) {
%>
    <div class="alert alert-error no-print">Database error: <%= outerEx.getMessage() %></div>
<%
    outerEx.printStackTrace();
} finally {
    if (conn != null) conn.close();
}
%>

<%@ include file="footer.jsp" %>
