package com.servlet;

import com.dao.BillDAO;
import com.model.Bill;
import com.model.BillItem;
import com.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/createBill")
public class CreateBillServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            String[] itemIds = request.getParameterValues("itemId");
            String[] prices = request.getParameterValues("price");
            String[] gstRates = request.getParameterValues("gstRate");
            String[] quantities = request.getParameterValues("quantity");

            int customerId = Integer.parseInt(request.getParameter("customerId"));

            if (itemIds == null || itemIds.length == 0) {
                response.sendRedirect("jsp/createBill.jsp?error=1");
                return;
            }

            List<BillItem> billItems = new ArrayList<>();
            double totalAmount = 0.0;

            for (int i = 0; i < itemIds.length; i++) {
                int itemId = Integer.parseInt(itemIds[i]);
                double price = Double.parseDouble(prices[i]);
                double gst = Double.parseDouble(gstRates[i]);
                int qty = Integer.parseInt(quantities[i]);

                double subtotal = price * qty;
                double gstAmount = subtotal * gst / 100;
                double total = subtotal + gstAmount;

                totalAmount += total;

                BillItem bi = new BillItem();
                bi.setItemId(itemId);
                bi.setPrice(price);
                bi.setGstRate(gst);
                bi.setQuantity(qty);
                billItems.add(bi);
            }

            Connection conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Insert into bills table
            String insertBillSQL = "INSERT INTO bills (customer_id, user_id, total_amount, paid_amount, payment_status, date) VALUES (?, ?, ?, 0, 'Pending', CURRENT_DATE)";
            PreparedStatement billStmt = conn.prepareStatement(insertBillSQL, Statement.RETURN_GENERATED_KEYS);
            billStmt.setInt(1, customerId);
            billStmt.setInt(2, userId);
            billStmt.setDouble(3, totalAmount);
            billStmt.executeUpdate();

            ResultSet generatedKeys = billStmt.getGeneratedKeys();
            int billId = 0;
            if (generatedKeys.next()) {
                billId = generatedKeys.getInt(1);
            } else {
                conn.rollback();
                throw new SQLException("Failed to create bill.");
            }

            // Auto-invoice number
            String invoiceNumber = "INV-" + String.format("%05d", billId);
            PreparedStatement invoiceStmt = conn.prepareStatement("UPDATE bills SET invoice_number = ? WHERE id = ?");
            invoiceStmt.setString(1, invoiceNumber);
            invoiceStmt.setInt(2, billId);
            invoiceStmt.executeUpdate();

            // Insert bill items
            String insertItemSQL = "INSERT INTO bill_items (bill_id, item_id, price, gst_rate, quantity, user_id) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement itemStmt = conn.prepareStatement(insertItemSQL);

            for (BillItem item : billItems) {
                itemStmt.setInt(1, billId);
                itemStmt.setInt(2, item.getItemId());
                itemStmt.setDouble(3, item.getPrice());
                itemStmt.setDouble(4, item.getGstRate());
                itemStmt.setInt(5, item.getQuantity());
                itemStmt.setInt(6, userId);
                itemStmt.addBatch();
            }
            itemStmt.executeBatch();

            conn.commit();
            conn.close();

            response.sendRedirect("jsp/listBills.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("jsp/createBill.jsp?error=1");
        }
    }
}
