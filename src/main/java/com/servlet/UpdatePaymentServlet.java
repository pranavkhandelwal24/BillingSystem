package com.servlet;

import com.util.DBConnection;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.ServletException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.time.LocalDate;

@WebServlet("/updatePayment")
public class UpdatePaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("../index.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        int billId = Integer.parseInt(request.getParameter("billId"));
        double paidAmount = Double.parseDouble(request.getParameter("paidAmount"));
        String status = request.getParameter("paymentStatus");
        String today = LocalDate.now().toString();

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE bills SET paid_amount = ?, payment_status = ?, payment_date = ? " +
                "WHERE id = ? AND user_id = ?"
            );
            ps.setDouble(1, paidAmount);
            ps.setString(2, status);
            ps.setString(3, today);
            ps.setInt(4, billId);
            ps.setInt(5, userId);
            ps.executeUpdate();

            response.sendRedirect("jsp/listBills.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error updating payment: " + e.getMessage());
        }
    }
}
