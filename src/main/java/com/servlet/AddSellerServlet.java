package com.servlet;

import com.dao.SellerDAO;
import com.model.Seller;
import com.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;

@WebServlet("/addSeller")
public class AddSellerServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String firmName = request.getParameter("firmName");
        String gstNumber = request.getParameter("gstNumber");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            SellerDAO dao = new SellerDAO(conn);
            Seller seller = new Seller();
            seller.setFirmName(firmName);
            seller.setGstNumber(gstNumber);
            seller.setEmail(email);
            seller.setPhone(phone);
            seller.setUserId(userId);

            boolean saved = dao.addSeller(seller);
            if (saved) {
                response.sendRedirect("jsp/addSeller.jsp?success=1");
            } else {
                response.sendRedirect("jsp/addSeller.jsp?error=1");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("jsp/addSeller.jsp?error=1");
        }
    }
}
