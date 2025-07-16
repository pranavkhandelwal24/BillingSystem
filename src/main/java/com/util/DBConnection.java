package com.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String URL = "jdbc:mysql://pranavkhandelwal24-nwrregister.i.aivencloud.com:12438/tally_system";
    private static final String USER = "avnadmin";
    private static final String PASSWORD = "AVNS_Adj10hYW-Y7UfsohGWv";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
