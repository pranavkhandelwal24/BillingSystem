package com.dao;

import com.model.Bill;
import com.model.BillItem;
import com.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BillDAO {

    public int createBill(Bill bill) {
        String sql = "INSERT INTO bills (customer_id, user_id, date, total_amount) VALUES (?, ?, NOW(), ?)";
        int billId = -1;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, bill.getCustomerId());
            stmt.setInt(2, bill.getUserId());  // ✅ associate user_id
            stmt.setDouble(3, bill.getTotalAmount());

            stmt.executeUpdate();
            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                billId = rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return billId;
    }

    public void addBillItems(int billId, List<BillItem> items) {
        String sql = "INSERT INTO bill_items (bill_id, item_id, quantity, price, gst_rate) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            for (BillItem item : items) {
                stmt.setInt(1, billId);
                stmt.setInt(2, item.getItemId());
                stmt.setInt(3, item.getQuantity());
                stmt.setDouble(4, item.getPrice());
                stmt.setDouble(5, item.getGstRate());
                stmt.addBatch();
            }

            stmt.executeBatch();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ✅ Optional: Get bills for a specific user
    public List<Bill> getBillsByUserId(int userId) {
        List<Bill> bills = new ArrayList<>();
        String sql = "SELECT * FROM bills WHERE user_id = ? ORDER BY date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Bill bill = new Bill();
                bill.setId(rs.getInt("id"));
                bill.setCustomerId(rs.getInt("customer_id"));
                bill.setUserId(rs.getInt("user_id"));
                bill.setDate(rs.getDate("date"));
                bill.setTotalAmount(rs.getDouble("total_amount"));
                bills.add(bill);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return bills;
    }
}
