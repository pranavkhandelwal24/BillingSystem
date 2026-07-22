package com.util;

import java.io.InputStream;
import java.util.Properties;

public class MailConfig {
    private static String email;
    private static String password;

    static {
        try {
            Properties props = new Properties();
            InputStream input = MailConfig.class.getClassLoader().getResourceAsStream("db.properties");

            if (input != null) {
                props.load(input);
                email = props.getProperty("mail.email");
                password = props.getProperty("mail.password");
                System.out.println("✅ db.properties loaded successfully for mail");
            } else {
                System.out.println("⚠️ db.properties file not found for mail!");
            }

            // Fallback to Environment Variables
            if (System.getenv("MAIL_EMAIL") != null) {
                email = System.getenv("MAIL_EMAIL");
            }
            if (System.getenv("MAIL_PASSWORD") != null) {
                password = System.getenv("MAIL_PASSWORD");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static String getEmail() {
        return email;
    }

    public static String getPassword() {
        return password;
    }
}
