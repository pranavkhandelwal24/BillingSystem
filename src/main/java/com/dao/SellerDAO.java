package com.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import com.model.Seller;

public class SellerDAO {

    private Connection conn;

    public SellerDAO(Connection conn) {
        this.conn = conn;
    }

    public boolean addSeller(Seller seller) {
        boolean success = false;
        try {
            String sql = "INSERT INTO sellers (firm_name, gst_number, email, phone, user_id) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, seller.getFirmName());
            ps.setString(2, seller.getGstNumber());
            ps.setString(3, seller.getEmail());
            ps.setString(4, seller.getPhone());
            ps.setInt(5, seller.getUserId());

            int rows = ps.executeUpdate();
            success = (rows > 0);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }
}
