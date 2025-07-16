package com.servlet;

import com.util.DBConnection;
import com.util.MailConfig;

import javax.mail.*;
import javax.mail.internet.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.Properties;
import java.util.UUID;

@WebServlet("/sendResetEmail")
public class SendResetEmailServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static final String EMAIL_FROM = MailConfig.getEmail();
	private static final String EMAIL_PASSWORD = MailConfig.getPassword();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String toEmail = request.getParameter("email");
        String companyName = null;

        // ✅ Step 1: Check if email exists
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement checkUser = conn.prepareStatement("SELECT company_name FROM users WHERE email = ?")) {

            checkUser.setString(1, toEmail);
            ResultSet rs = checkUser.executeQuery();

            if (!rs.next()) {
                response.sendRedirect("forgotPassword.jsp?error=No account with this email.");
                return;
            }
            companyName = rs.getString("company_name");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("forgotPassword.jsp?error=Database error: " + e.getMessage());
            return;
        }

        // ✅ Step 2: Generate token and store
        String token = UUID.randomUUID().toString();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "INSERT INTO password_reset_tokens(email, token, used) VALUES (?, ?, FALSE)")) {

            ps.setString(1, toEmail);
            ps.setString(2, token);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("forgotPassword.jsp?error=Token generation failed.");
            return;
        }

        // ✅ Step 3: Send reset email
        try {
            Properties props = new Properties();
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");

            Session mailSession = Session.getInstance(props, new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(EMAIL_FROM, EMAIL_PASSWORD);
                }
            });

            Message message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress(EMAIL_FROM, "Tally System"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Reset Your Password - Tally System");

            String resetLink = request.getScheme() + "://" + request.getServerName() + ":" +
                    request.getServerPort() + request.getContextPath() + "/resetPassword.jsp?token=" + token;

            String body = "Hi " + companyName + ",\n\n" +
                    "Click the link below to reset your password. This link is valid for one-time use:\n\n" +
                    resetLink + "\n\n" +
                    "If you didn’t request this, please ignore this email.\n\n" +
                    "— Tally System Team";

            message.setText(body);
            Transport.send(message);

            response.sendRedirect("forgotPassword.jsp?success=Reset link sent to your email.");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("forgotPassword.jsp?error=Failed to send email.");
        }
    }
}
