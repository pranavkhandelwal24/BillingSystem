package com.model;

import java.util.Date;
import java.util.List;

public class Bill {
    private int id;
    private int customerId;
    private int userId;
    private Date date;
    private double totalAmount;

    private List<BillItem> items; // Optional: can hold item details if needed for display

    // Constructors
    public Bill() {}

    public Bill(int id, int customerId, int userId, Date date, double totalAmount) {
        this.id = id;
        this.customerId = customerId;
        this.userId = userId;
        this.date = date;
        this.totalAmount = totalAmount;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public List<BillItem> getItems() {
        return items;
    }

    public void setItems(List<BillItem> items) {
        this.items = items;
    }
}
