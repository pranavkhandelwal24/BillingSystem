package com.util;

import java.io.InputStream;
import java.util.Properties;

public class DBConfig {
    private static String url;
    private static String user;
    private static String password;

    static {
        try {
            Properties props = new Properties();
            InputStream input = DBConfig.class.getClassLoader().getResourceAsStream("db.properties");

            if (input == null) {
                System.out.println("⚠️ db.properties file not found!");
                
            }

            props.load(input);

            url = props.getProperty("db.url");
            user = props.getProperty("db.user");
            password = props.getProperty("db.password");

            System.out.println("✅ db.properties loaded successfully");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static String getUrl() {
        return url;
    }

    public static String getUser() {
        return user;
    }

    public static String getPassword() {
        return password;
    }
}
