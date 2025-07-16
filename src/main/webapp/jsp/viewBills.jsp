<%@ page import="java.sql.*, java.util.*, com.util.DBConnection" %>
<jsp:include page="header.jsp" />

<div class="main-container" style="display: flex; min-height: 80vh;">
    <jsp:include page="sidebar.jsp" />

    <div class="content" style="flex: 1; padding: 20px;">
        <h2>View Past Bills</h2>

        <%
            Integer userId = (Integer) session.getAttribute("userId");
            if (userId == null) {
                response.sendRedirect("index.jsp");
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

        <form method="get" action="viewBills.jsp">
            <label>Select Bill:</label>
            <select name="billId" onchange="this.form.submit()" required>
                <option value="">-- Select a bill --</option>
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
        </form>

        <hr/>

        <%
            if (selectedBillId == -1) {
        %>
            <p style="color:gray;">No bill selected.</p>
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
            <p style="color:red;">Invalid bill or access denied.</p>
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

        <div class="print-area">
            <div class="logo" style="text-align:center; margin-bottom:20px;">
                <img src="<%= session.getAttribute("companyLogo") %>" alt="Company Logo" style="max-width:150px;" />
            </div>

            <div style="display:flex; justify-content:space-between; border-bottom:2px solid #ccc; padding-bottom:10px;">
                <div>
                    <h3>From:</h3>
                    <p><strong>Name:</strong> <%= session.getAttribute("companyName") %></p>
                    <p><strong>Email:</strong> <%= session.getAttribute("companyEmail") %></p>
                    <p><strong>Phone:</strong> <%= session.getAttribute("companyPhone") %></p>
                    <p><strong>Address:</strong> <%= session.getAttribute("companyAddress") %></p>
                    <p><strong>GST:</strong> <%= session.getAttribute("companyGST") %></p>
                </div>
                <div>
                    <h3>To:</h3>
                    <p><strong>Name:</strong> <%= custRs.getString("name") %></p>
                    <p><strong>Email:</strong> <%= custRs.getString("email") %></p>
                    <p><strong>Phone:</strong> <%= custRs.getString("phone") %></p>
                    <p><strong>Address:</strong> <%= custRs.getString("address") %></p>
                    <p><strong>GST:</strong> <%= custRs.getString("gst_number") %></p>
                </div>
            </div>

            <h3>Invoice # <%= invoiceNumber %> (Bill ID: <%= selectedBillId %>)</h3>
            <p><strong>Date:</strong> <%= billDate %></p>

            <table border="1" width="100%" cellspacing="0" cellpadding="8" style="margin-top:20px;">
                <tr>
                    <th>Item</th>
                    <th>Price</th>
                    <th>GST %</th>
                    <th>Quantity</th>
                    <th>Subtotal</th>
                    <th>GST Amount</th>
                    <th>Total</th>
                </tr>
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
                    <tr>
                        <td><%= name %></td>
                        <td><%= String.format("%.2f", price) %></td>
                        <td><%= gstRate %></td>
                        <td><%= qty %></td>
                        <td><%= String.format("%.2f", subtotal) %></td>
                        <td><%= String.format("%.2f", gstAmount) %></td>
                        <td><%= String.format("%.2f", total) %></td>
                    </tr>
                <% } %>
            </table>

            <h3>Total: <%= String.format("%.2f", grandTotal) %> Rs.</h3>
        </div>

        <div class="no-print" style="margin-top: 15px;">
            <a href="<%= request.getContextPath() %>/exportBillPdf?billId=<%= selectedBillId %>" target="_blank">Download as PDF</a> |
            <button onclick="window.print()">Print</button> |
            <form method="get" action="<%= request.getContextPath() %>/sendInvoice" style="display:inline;">
                <input type="hidden" name="billId" value="<%= selectedBillId %>" />
                <input type="submit" value="Send Email" />
            </form>
        </div>

        <%
                    }
                } catch (Exception ex) {
                    out.println("<p style='color:red;'>Error loading bill: " + ex.getMessage() + "</p>");
                    ex.printStackTrace();
                }
            }
        } catch (Exception outerEx) {
            out.println("<p style='color:red;'>Database error: " + outerEx.getMessage() + "</p>");
            outerEx.printStackTrace();
        } finally {
            if (conn != null) conn.close();
        }
        %>
    </div>
</div>

<jsp:include page="footer.jsp" />
