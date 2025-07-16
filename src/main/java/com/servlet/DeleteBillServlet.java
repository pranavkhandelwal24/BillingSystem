package com.servlet;

import com.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/deleteBill")
public class DeleteBillServlet extends HttpServlet {
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

        String billIdParam = request.getParameter("billId");
        if (billIdParam == null || billIdParam.isEmpty()) {
            response.sendRedirect("jsp/listBills.jsp");
            return;
        }

        int billId = Integer.parseInt(billIdParam);

        try (Connection conn = DBConnection.getConnection()) {

            // ✅ Step 0: Verify bill belongs to the user
            PreparedStatement checkStmt = conn.prepareStatement("SELECT user_id FROM bills WHERE id = ?");
            checkStmt.setInt(1, billId);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                int billUserId = rs.getInt("user_id");
                if (billUserId != userId) {
                    response.getWriter().println("Unauthorized access.");
                    return;
                }
            } else {
                response.getWriter().println("Bill not found.");
                return;
            }

            // Step 1: Delete associated bill items
            PreparedStatement ps1 = conn.prepareStatement("DELETE FROM bill_items WHERE bill_id = ?");
            ps1.setInt(1, billId);
            ps1.executeUpdate();

            // Step 2: Delete bill
            PreparedStatement ps2 = conn.prepareStatement("DELETE FROM bills WHERE id = ?");
            ps2.setInt(1, billId);
            ps2.executeUpdate();

            response.sendRedirect("jsp/listBills.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error deleting bill: " + e.getMessage());
        }
    }
}
