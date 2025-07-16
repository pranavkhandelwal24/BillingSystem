package com.servlet;

import com.util.DBConnection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.ServletException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/updateBill")
public class UpdateBillServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("../index.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        try {
            int billId = Integer.parseInt(request.getParameter("billId"));
            int customerId = Integer.parseInt(request.getParameter("customerId"));
            String billDate = request.getParameter("billDate");
            double totalAmount = Double.parseDouble(request.getParameter("totalAmount"));
            String paymentStatus = request.getParameter("paymentStatus");
            double paidAmount = Double.parseDouble(request.getParameter("paidAmount"));
            String paymentDate = request.getParameter("paymentDate");

            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE bills SET customer_id = ?, total_amount = ?, date = ?, payment_status = ?, paid_amount = ?, payment_date = ? " +
                "WHERE id = ? AND user_id = ?"
            );
            ps.setInt(1, customerId);
            ps.setDouble(2, totalAmount);
            ps.setString(3, billDate);
            ps.setString(4, paymentStatus);
            ps.setDouble(5, paidAmount);
            ps.setString(6, paymentDate);
            ps.setInt(7, billId);
            ps.setInt(8, userId);

            ps.executeUpdate();

            conn.close();

            response.sendRedirect("jsp/listBills.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error updating bill: " + e.getMessage());
        }
    }
}
