<%
    String currentUri = request.getRequestURI();
    boolean activeDashboard = currentUri.endsWith("dashboard.jsp");
    boolean activeCreateBill = currentUri.endsWith("createBill.jsp");
    boolean activeListBills = currentUri.endsWith("listBills.jsp") || currentUri.contains("editBill.jsp");
    boolean activeAddItem = currentUri.endsWith("addItem.jsp");
    boolean activeAddCustomer = currentUri.endsWith("addCustomer.jsp");
    boolean activeViewBills = currentUri.endsWith("viewBills.jsp");
    boolean activeStockReport = currentUri.endsWith("stockReport.jsp");
    boolean activeAddSeller = currentUri.endsWith("addSeller.jsp");
    boolean activeStockHistory = currentUri.endsWith("stockHistory.jsp");
    boolean activeSalesReport = currentUri.endsWith("viewSalesReport.jsp");
%>
<aside class="sidebar">
    <ul>
        <li>
            <a href="<%= request.getContextPath() %>/jsp/dashboard.jsp" class="<%= activeDashboard ? "active" : "" %>">
                Dashboard
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/jsp/createBill.jsp" class="<%= activeCreateBill ? "active" : "" %>">
                Create Bill
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/jsp/listBills.jsp" class="<%= activeListBills ? "active" : "" %>">
                All Bills
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/jsp/addItem.jsp" class="<%= activeAddItem ? "active" : "" %>">
                Add Items
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/jsp/addCustomer.jsp" class="<%= activeAddCustomer ? "active" : "" %>">
                Add Customers
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/jsp/viewBills.jsp" class="<%= activeViewBills ? "active" : "" %>">
                View Bill
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/jsp/stockReport.jsp" class="<%= activeStockReport ? "active" : "" %>">
                View & Manage Stock
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/jsp/addSeller.jsp" class="<%= activeAddSeller ? "active" : "" %>">
                Add Sellers
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/jsp/stockHistory.jsp" class="<%= activeStockHistory ? "active" : "" %>">
                Stock History
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/jsp/viewSalesReport.jsp" class="<%= activeSalesReport ? "active" : "" %>">
                View Stock Report
            </a>
        </li>
    </ul>
</aside>
