<%@ page import="java.util.*, com.dao.*, com.model.*" %>
<%@ page session="true" %>
<%@ include file="header.jsp" %>

<h2 class="page-title">Create New Bill</h2>

<% 
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    CustomerDAO customerDAO = new CustomerDAO();
    ItemDAO itemDAO = new ItemDAO();
    List<Customer> customers = customerDAO.getAllCustomersByUserId(userId);
    List<Item> items = itemDAO.getAllItemsByUserId(userId);
%>

<% String error = request.getParameter("error"); %>
<% if ("1".equals(error)) { %>
    <div class="alert alert-error">Error creating bill. Please try again.</div>
<% } %>

<div class="card">
    <form action="../createBill" method="post">
        <!-- Customer Select -->
        <div class="form-group" style="max-width: 400px;">
            <label for="customerId">Select Customer</label>
            <select name="customerId" id="customerId" required>
                <option value="">-- Choose a customer --</option>
                <% for (Customer c : customers) { %>
                    <option value="<%= c.getId() %>"><%= c.getName() %> - <%= c.getPhone() %></option>
                <% } %>
            </select>
        </div>

        <h3 style="font-size: 16px; font-weight: 600; margin: 25px 0 10px 0; border-bottom: 1px solid var(--border-color); padding-bottom: 8px;">Select Items</h3>

        <!-- Searchable Items list -->
        <div class="form-group" style="max-width: 400px;">
            <input type="text" id="itemSearch" placeholder="Search items by name..." />
        </div>

        <div style="overflow-x: auto; margin-bottom: 25px;">
            <table id="itemTable" class="table">
                <thead>
                    <tr>
                        <th style="width: 60px; text-align: center;">Select</th>
                        <th>Item Name</th>
                        <th>Price (Rs.)</th>
                        <th>GST (%)</th>
                        <th style="width: 150px;">Quantity</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Item i : items) { %>
                        <tr>
                            <td style="text-align: center;">
                                <input type="checkbox" value="<%= i.getId() %>"
                                       onclick="toggleItem(this, <%= i.getId() %>, <%= i.getPrice() %>, <%= i.getGstRate() %>)" />
                            </td>
                            <td class="item-name" style="font-weight: 500;"><%= i.getName() %></td>
                            <td>
                                <input type="text" id="price_<%= i.getId() %>" value="<%= String.format("%.2f", i.getPrice()) %>" disabled style="max-width: 100px; padding: 6px;" />
                            </td>
                            <td>
                                <input type="text" id="gst_<%= i.getId() %>" value="<%= i.getGstRate() %>" disabled style="max-width: 80px; padding: 6px;" />
                            </td>
                            <td>
                                <input type="number" id="qty_<%= i.getId() %>" min="1" value="1" disabled style="max-width: 100px; padding: 6px;" />
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <button type="submit" class="btn btn-primary">Generate Invoice</button>
    </form>
</div>

<script>
    function toggleItem(checkbox, id, price, gst) {
        const priceInput = document.getElementById("price_" + id);
        const gstInput = document.getElementById("gst_" + id);
        const qtyInput = document.getElementById("qty_" + id);

        priceInput.disabled = !checkbox.checked;
        gstInput.disabled = !checkbox.checked;
        qtyInput.disabled = !checkbox.checked;

        priceInput.name = checkbox.checked ? "price" : "";
        gstInput.name = checkbox.checked ? "gstRate" : "";
        qtyInput.name = checkbox.checked ? "quantity" : "";
        checkbox.name = checkbox.checked ? "itemId" : "";
    }

    // Live search for item table
    document.getElementById("itemSearch").addEventListener("keyup", function () {
        const query = this.value.toLowerCase();
        const rows = document.querySelectorAll("#itemTable tbody tr");

        rows.forEach(row => {
            const itemName = row.querySelector(".item-name").innerText.toLowerCase();
            row.style.display = itemName.includes(query) ? "" : "none";
        });
    });
</script>

<%@ include file="footer.jsp" %>
