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
            String resetLink = request.getScheme() + "://" + request.getServerName() + ":" +
                    request.getServerPort() + request.getContextPath() + "/resetPassword.jsp?token=" + token;

            String htmlBody = "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #e2e8f0; border-radius: 8px;'>" +
                    "<h2 style='color: #4f46e5;'>Reset Your Password</h2>" +
                    "<p>Hi " + companyName + ",</p>" +
                    "<p>We received a request to reset your password for your Tally Billing System account.</p>" +
                    "<p>Click the button below to choose a new password. This link is valid for one-time use only:</p>" +
                    "<p style='margin: 30px 0; text-align: center;'>" +
                    "  <a href='" + resetLink + "' style='background-color: #4f46e5; color: white; padding: 12px 24px; text-decoration: none; border-radius: 6px; font-weight: bold; display: inline-block;'>Reset Password</a>" +
                    "</p>" +
                    "<p style='color: #64748b; font-size: 14px;'>Or copy and paste this link into your browser:</p>" +
                    "<p style='color: #64748b; font-size: 14px; word-break: break-all;'>" + resetLink + "</p>" +
                    "<p>If you didn't request this, you can safely ignore this email.</p>" +
                    "<hr style='border: 0; border-top: 1px solid #e2e8f0; margin: 20px 0;'>" +
                    "<p style='color: #64748b; font-size: 12px; text-align: center;'>— Tally Billing System Team</p>" +
                    "</div>";

            boolean successSent = MailConfig.sendEmail(toEmail, "Reset Your Password - Tally System", htmlBody);

            if (successSent) {
                response.sendRedirect("forgotPassword.jsp?success=Reset link sent to your email.");
            } else {
                response.sendRedirect("forgotPassword.jsp?error=Failed to send email via Resend.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("forgotPassword.jsp?error=Failed to send email: " + e.getMessage());
        }
    }
}
