package com.servlet;

import com.util.DBConnection;
import org.apache.commons.io.IOUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;

@WebServlet("/updateProfile")
@MultipartConfig
public class UpdateProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String gst = request.getParameter("gst_number");
        String address = request.getParameter("address");
        String newPassword = request.getParameter("new_password");

        Part logoPart = request.getPart("logo");
        String logoUrl = null;

        if (logoPart != null && logoPart.getSize() > 0) {
            // Save logo to disk (e.g., inside /uploads)
            String uploadsPath = getServletContext().getRealPath("/uploads");
            File uploadsDir = new File(uploadsPath);
            if (!uploadsDir.exists()) uploadsDir.mkdirs();

            String fileName = "user_" + userId + "_" + System.currentTimeMillis() + "_" + logoPart.getSubmittedFileName();
            File file = new File(uploadsDir, fileName);

            try (InputStream input = logoPart.getInputStream(); FileOutputStream out = new FileOutputStream(file)) {
                IOUtils.copy(input, out);
                logoUrl = request.getContextPath() + "/uploads/" + fileName;
            }
        }

        try (Connection conn = DBConnection.getConnection()) {
            StringBuilder sql = new StringBuilder("UPDATE users SET email=?, phone=?, gst_number=?, address=?");
            if (logoUrl != null) {
                sql.append(", logo_url=?");
            }
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                sql.append(", password=?");
            }
            sql.append(" WHERE id=?");

            PreparedStatement ps = conn.prepareStatement(sql.toString());

            int i = 1;
            ps.setString(i++, email);
            ps.setString(i++, phone);
            ps.setString(i++, gst);
            ps.setString(i++, address);

            if (logoUrl != null) {
                ps.setString(i++, logoUrl);
                session.setAttribute("companyLogo", logoUrl);
            }

            if (newPassword != null && !newPassword.trim().isEmpty()) {
                ps.setString(i++, newPassword); // In production, hash it
            }

            ps.setInt(i, userId);

            int updated = ps.executeUpdate();

            if (updated > 0) {
                session.setAttribute("companyEmail", email);
                session.setAttribute("companyPhone", phone);
                session.setAttribute("companyAddress", address);
                session.setAttribute("companyGST", gst);
                response.sendRedirect("jsp/updateProfile.jsp?success=1");
            } else {
                response.sendRedirect("jsp/updateProfile.jsp?error=1");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("jsp/updateProfile.jsp?error=1");
        }
    }
}
