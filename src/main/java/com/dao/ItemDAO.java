package com.dao;

import com.model.Item;
import com.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ItemDAO {

    // Add new item
    public boolean addItem(Item item) {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO items (name, price, quantity, gst_rate, hsn_code, user_id) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, item.getName());
            ps.setDouble(2, item.getPrice());
            ps.setInt(3, item.getQuantity());
            ps.setDouble(4, item.getGstRate());
            ps.setString(5, item.getHsnCode());
            ps.setInt(6, item.getUserId());

            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Get all items for a specific user
    public List<Item> getAllItemsByUserId(int userId) {
        List<Item> items = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM items WHERE user_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Item item = new Item();
                item.setId(rs.getInt("id"));
                item.setName(rs.getString("name"));
                item.setPrice(rs.getDouble("price"));
                item.setQuantity(rs.getInt("quantity"));
                item.setGstRate(rs.getDouble("gst_rate"));
                item.setHsnCode(rs.getString("hsn_code"));
                item.setUserId(rs.getInt("user_id"));
                items.add(item);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return items;
    }

    // Get item by ID
    public Item getItemById(int itemId) {
        Item item = null;
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM items WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, itemId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                item = new Item();
                item.setId(rs.getInt("id"));
                item.setName(rs.getString("name"));
                item.setPrice(rs.getDouble("price"));
                item.setQuantity(rs.getInt("quantity"));
                item.setGstRate(rs.getDouble("gst_rate"));
                item.setHsnCode(rs.getString("hsn_code"));
                item.setUserId(rs.getInt("user_id"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return item;
    }

    // Update item quantity (e.g., during restocking or billing)
    public boolean updateQuantity(int itemId, int newQuantity) {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE items SET quantity = ? WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, newQuantity);
            ps.setInt(2, itemId);

            return ps.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Delete item
    public boolean deleteItem(int itemId) {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "DELETE FROM items WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, itemId);
            return ps.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Restock item (add quantity)
    public boolean restockItem(int itemId, int addQuantity) {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE items SET quantity = quantity + ? WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, addQuantity);
            ps.setInt(2, itemId);
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
