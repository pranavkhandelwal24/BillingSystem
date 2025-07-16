package com.servlet;

import com.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/resetPassword")
public class ResetPasswordServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String token = request.getParameter("token");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // ✅ Password match check
        if (!newPassword.equals(confirmPassword)) {
            response.sendRedirect("resetPassword.jsp?token=" + token + "&error=Passwords do not match.");
            return;
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement checkToken = conn.prepareStatement(
                     "SELECT email FROM password_reset_tokens WHERE token = ? AND used = FALSE")) {

            checkToken.setString(1, token);
            ResultSet rs = checkToken.executeQuery();

            // ❌ Token invalid or already used
            if (!rs.next()) {
                response.sendRedirect("resetPassword.jsp?error=Invalid or expired reset link.");
                return;
            }

            String email = rs.getString("email");

            // ✅ Update password
            PreparedStatement updatePwd = conn.prepareStatement(
                    "UPDATE users SET password = ? WHERE email = ?");
            updatePwd.setString(1, newPassword); // Not encrypted as per your choice
            updatePwd.setString(2, email);
            updatePwd.executeUpdate();

            // ✅ Mark token as used
            PreparedStatement markUsed = conn.prepareStatement(
                    "UPDATE password_reset_tokens SET used = TRUE WHERE token = ?");
            markUsed.setString(1, token);
            markUsed.executeUpdate();

            // ✅ Redirect with green success message
            response.sendRedirect("index.jsp?success=Password updated successfully.");

        } catch (Exception e) {
            e.printStackTrace();
            // ❌ Redirect with red error
            response.sendRedirect("index.jsp?error=Error updating password.");
        }
    }
}
