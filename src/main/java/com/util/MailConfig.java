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
            props.load(input);

            email = props.getProperty("mail.email");
            password = props.getProperty("mail.password");
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
