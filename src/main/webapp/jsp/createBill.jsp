<%@ page import="java.util.*, com.dao.*, com.model.*" %>
<%@ page session="true" %>
<jsp:include page="header.jsp" />

<!-- Layout wrapper -->
<div class="main-container" style="display: flex; min-height: 80vh;">
    <jsp:include page="sidebar.jsp" />

    <!-- Main content -->
    <div class="content" style="flex: 1; padding: 20px;">
        <h2>Create New Bill</h2>

        <% 
            Integer userId = (Integer) session.getAttribute("userId");
            if (userId == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            CustomerDAO customerDAO = new CustomerDAO();
            ItemDAO itemDAO = new ItemDAO();
            List<Customer> customers = customerDAO.getAllCustomersByUserId(userId);
            List<Item> items = itemDAO.getAllItemsByUserId(userId);
        %>

        <% String error = request.getParameter("error"); %>
        <% if ("1".equals(error)) { %>
            <p style="color:red;">Error creating bill. Please try again.</p>
        <% } %>

        <form action="../createBill" method="post">
            <!-- Searchable customer -->
            <label for="customerSearch">Select Customer:</label><br>
            <input list="customerList" name="customerId" id="customerSearch" required />
            <datalist id="customerList">
                <% for (Customer c : customers) { %>
                    <option value="<%= c.getId() %>"><%= c.getName() %> - <%= c.getPhone() %></option>
                <% } %>
            </datalist><br><br>

            <h3>Items</h3>

            <!-- Live item search -->
            <input type="text" id="itemSearch" placeholder="Search item..." style="width: 300px; padding: 5px;" />

            <table id="itemTable" border="1" cellpadding="5" style="margin-top: 10px; width:100%;">
                <tr>
                    <th>Select</th>
                    <th>Item</th>
                    <th>Price</th>
                    <th>GST %</th>
                    <th>Quantity</th>
                </tr>
                <% for (Item i : items) { %>
                    <tr>
                        <td>
                            <input type="checkbox" value="<%= i.getId() %>"
                                   onclick="toggleItem(this, <%= i.getId() %>, <%= i.getPrice() %>, <%= i.getGstRate() %>)" />
                        </td>
                        <td class="item-name"><%= i.getName() %></td>
                        <td>
                            <input type="text" id="price_<%= i.getId() %>" value="<%= i.getPrice() %>" disabled />
                        </td>
                        <td>
                            <input type="text" id="gst_<%= i.getId() %>" value="<%= i.getGstRate() %>" disabled />
                        </td>
                        <td>
                            <input type="number" id="qty_<%= i.getId() %>" min="1" value="1" disabled />
                        </td>
                    </tr>
                <% } %>
            </table><br>

            <input type="submit" value="Generate Bill" />
        </form>

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
                const rows = document.querySelectorAll("#itemTable tr");

                for (let i = 1; i < rows.length; i++) {
                    const itemName = rows[i].querySelector(".item-name").innerText.toLowerCase();
                    rows[i].style.display = itemName.includes(query) ? "" : "none";
                }
            });
        </script>
    </div>
</div>

<jsp:include page="footer.jsp" />
