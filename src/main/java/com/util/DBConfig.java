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

            if (input != null) {
                props.load(input);
                url = props.getProperty("db.url");
                user = props.getProperty("db.user");
                password = props.getProperty("db.password");
                System.out.println("✅ db.properties loaded successfully");
            } else {
                System.out.println("⚠️ db.properties file not found!");
            }

            // Fallback to Environment Variables
            if (System.getenv("DB_URL") != null) {
                url = System.getenv("DB_URL");
            }
            if (System.getenv("DB_USER") != null) {
                user = System.getenv("DB_USER");
            }
            if (System.getenv("DB_PASSWORD") != null) {
                password = System.getenv("DB_PASSWORD");
            }

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
