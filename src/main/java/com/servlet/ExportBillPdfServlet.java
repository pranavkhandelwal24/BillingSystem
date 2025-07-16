package com.servlet;

import com.util.DBConnection;
import com.util.InvoicePdfGenerator;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/exportBillPdf")
public class ExportBillPdfServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        try {
            int billId = Integer.parseInt(request.getParameter("billId"));

            // ✅ Verify the bill belongs to the current user
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement("SELECT user_id FROM bills WHERE id = ?")) {

                stmt.setInt(1, billId);
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    int billOwnerId = rs.getInt("user_id");
                    if (billOwnerId != userId) {
                        response.setContentType("text/plain");
                        response.getWriter().println("❌ Unauthorized access to export this bill.");
                        return;
                    }
                } else {
                    response.setContentType("text/plain");
                    response.getWriter().println("❌ Bill not found.");
                    return;
                }
            }

            // ✅ Proceed to generate PDF
            InvoicePdfGenerator.generatePdf(response, billId, session);

        } catch (Exception e) {
            e.printStackTrace(); // Log to Tomcat console
            response.setContentType("text/plain");
            response.getWriter().println("❌ Error generating PDF: " + e.getMessage());
        }
    }
}
