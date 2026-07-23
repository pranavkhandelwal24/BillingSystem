package com.util;

import java.io.InputStream;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.Properties;

public class MailConfig {
    private static String email = "testbotpranav@gmail.com";
    private static String password = "ujzkixdbwyunttmc";
    private static String resendApiKey = "re_5DWNBVz3_EY9XfJya2nyAFaCWS5V2LozY";

    static {
        try {
            Properties props = new Properties();
            InputStream input = MailConfig.class.getClassLoader().getResourceAsStream("db.properties");

            if (input != null) {
                props.load(input);
                email = props.getProperty("mail.email");
                password = props.getProperty("mail.password");
                if (props.getProperty("mail.resend.key") != null) {
                    resendApiKey = props.getProperty("mail.resend.key");
                }
                System.out.println("Success: db.properties loaded successfully for mail");
            } else {
                System.out.println("Warning: db.properties file not found for mail!");
            }

            // Fallback to Environment Variables
            if (System.getenv("MAIL_EMAIL") != null) {
                email = System.getenv("MAIL_EMAIL");
            }
            if (System.getenv("MAIL_PASSWORD") != null) {
                password = System.getenv("MAIL_PASSWORD");
            }
            if (System.getenv("RESEND_API_KEY") != null) {
                resendApiKey = System.getenv("RESEND_API_KEY");
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

    public static String getResendApiKey() {
        return resendApiKey;
    }

    /**
     * Sends an email using Resend API.
     */
    public static boolean sendEmail(String to, String subject, String htmlBody) {
        try {
            String apiKey = getResendApiKey();
            if (apiKey == null || apiKey.isEmpty()) {
                System.out.println("Error: Resend API Key is empty");
                return false;
            }

            String jsonBody = String.format(
                "{\"from\":\"Tally System <onboarding@resend.dev>\",\"to\":[\"%s\"],\"subject\":\"%s\",\"html\":\"%s\"}",
                escapeJson(to),
                escapeJson(subject),
                escapeJson(htmlBody)
            );

            HttpClient client = HttpClient.newHttpClient();
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create("https://api.resend.com/emails"))
                    .header("Authorization", "Bearer " + apiKey)
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(jsonBody))
                    .build();

            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() >= 200 && response.statusCode() < 300) {
                System.out.println("Success: Email sent successfully via Resend: " + response.body());
                return true;
            } else {
                System.out.println("Error: Failed to send email via Resend: Status " + response.statusCode() + " - " + response.body());
                return false;
            }
        } catch (Exception e) {
            System.out.println("Error: Exception sending email via Resend: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    private static String escapeJson(String input) {
        if (input == null) return "";
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < input.length(); i++) {
            char ch = input.charAt(i);
            switch (ch) {
                case '\\':
                    sb.append("\\\\");
                    break;
                case '"':
                    sb.append("\\\"");
                    break;
                case '\b':
                    sb.append("\\b");
                    break;
                case '\f':
                    sb.append("\\f");
                    break;
                case '\n':
                    sb.append("\\n");
                    break;
                case '\r':
                    sb.append("\\r");
                    break;
                case '\t':
                    sb.append("\\t");
                    break;
                default:
                    if (ch >= 0 && ch <= 0x1F) {
                        String ss = Integer.toHexString(ch);
                        sb.append("\\u");
                        for (int k = 0; k < 4 - ss.length(); k++) {
                            sb.append('0');
                        }
                        sb.append(ss.toUpperCase());
                    } else {
                        sb.append(ch);
                    }
            }
        }
        return sb.toString();
    }
}
