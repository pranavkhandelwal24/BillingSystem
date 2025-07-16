package com.dao;

import com.model.Customer;
import com.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {

    // ✅ Add customer with user ID
    public void addCustomer(Customer customer) {
        String sql = "INSERT INTO customers (name, address, phone, email, gst_number, user_id) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, customer.getName());
            stmt.setString(2, customer.getAddress());
            stmt.setString(3, customer.getPhone());
            stmt.setString(4, customer.getEmail());
            stmt.setString(5, customer.getGstNumber());
            stmt.setInt(6, customer.getUserId()); // ✅ Save user ID

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ✅ Fetch customers only for specific user
    public List<Customer> getAllCustomers(int userId) {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM customers WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Customer customer = new Customer();
                customer.setId(rs.getInt("id"));
                customer.setName(rs.getString("name"));
                customer.setAddress(rs.getString("address"));
                customer.setPhone(rs.getString("phone"));
                customer.setEmail(rs.getString("email"));
                customer.setGstNumber(rs.getString("gst_number"));
                customer.setUserId(rs.getInt("user_id")); // ✅ optional
                customers.add(customer);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return customers;
    }

    // ✅ Fetch customer by ID and user ID
    public Customer getCustomerById(int id, int userId) {
        String sql = "SELECT * FROM customers WHERE id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            stmt.setInt(2, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Customer customer = new Customer();
                customer.setId(rs.getInt("id"));
                customer.setName(rs.getString("name"));
                customer.setAddress(rs.getString("address"));
                customer.setPhone(rs.getString("phone"));
                customer.setEmail(rs.getString("email"));
                customer.setGstNumber(rs.getString("gst_number"));
                customer.setUserId(rs.getInt("user_id")); // ✅ optional
                return customer;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }
    public List<Customer> getAllCustomersByUserId(int userId) {
        List<Customer> customers = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM customers WHERE user_id = ?");
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Customer c = new Customer();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                c.setAddress(rs.getString("address"));
                c.setPhone(rs.getString("phone"));
                c.setEmail(rs.getString("email"));
                c.setGstNumber(rs.getString("gst_number"));
                c.setUserId(rs.getInt("user_id"));
                customers.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return customers;
    }

}
