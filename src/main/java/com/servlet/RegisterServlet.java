package com.servlet;

import com.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String companyName = request.getParameter("companyName");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String gstNumber = request.getParameter("gstNumber");
        String logoUrl = request.getParameter("logoUrl");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!password.equals(confirmPassword)) {
            response.sendRedirect("register.jsp?error=Passwords do not match.");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {

            // ✅ Check if username or email already exists
            PreparedStatement checkStmt = conn.prepareStatement(
                "SELECT id FROM users WHERE username = ? OR email = ?"
            );
            checkStmt.setString(1, username);
            checkStmt.setString(2, email);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                response.sendRedirect("register.jsp?error=Username or email already exists.");
                return;
            }

            // ✅ Insert new user
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO users (username, password, name, email, logo_url, phone, address, gst_number, company_name) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"
            );

            ps.setString(1, username);
            ps.setString(2, password); // ❗Store encrypted in production
            ps.setString(3, name);
            ps.setString(4, email);
            ps.setString(5, logoUrl);
            ps.setString(6, phone);
            ps.setString(7, address);
            ps.setString(8, gstNumber);
            ps.setString(9, companyName);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                response.sendRedirect("register.jsp?success=Registration successful. You can now log in.");
            } else {
                response.sendRedirect("register.jsp?error=Failed to register. Please try again.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp?error=Server error: " + e.getMessage());
        }
    }
}
