package com.servlet;

import com.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/restockItem")
public class RestockItemServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	
	    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	        int itemId = Integer.parseInt(request.getParameter("itemId"));
	        int addQuantity = Integer.parseInt(request.getParameter("addQuantity"));
	        int sellerId = Integer.parseInt(request.getParameter("sellerId"));
	        HttpSession session = request.getSession();
	        Integer userId = (Integer) session.getAttribute("userId");

	        if (userId == null) {
	            response.sendRedirect("index.jsp");
	            return;
	        }

	        Connection conn = null;
	        PreparedStatement ps1 = null;
	        PreparedStatement ps2 = null;

	        try {
	            conn = DBConnection.getConnection();
	            conn.setAutoCommit(false);

	            // Update item quantity
	            ps1 = conn.prepareStatement("UPDATE items SET quantity = quantity + ? WHERE id = ? AND user_id = ?");
	            ps1.setInt(1, addQuantity);
	            ps1.setInt(2, itemId);
	            ps1.setInt(3, userId);
	            ps1.executeUpdate();

	            // Insert into stock_entries
	            ps2 = conn.prepareStatement("INSERT INTO stock_entries (item_id, user_id, seller_id, quantity) VALUES (?, ?, ?, ?)");
	            ps2.setInt(1, itemId);
	            ps2.setInt(2, userId);
	            ps2.setInt(3, sellerId);
	            ps2.setInt(4, addQuantity);
	            ps2.executeUpdate();

	            conn.commit();
	            response.sendRedirect("jsp/stockReport.jsp");

	        } catch (Exception e) {
	            try { if (conn != null) conn.rollback(); } catch (SQLException ignored) {}
	            e.printStackTrace();
	            response.sendRedirect("jsp/stockReport.jsp?error=1");
	        } finally {
	            try {
	                if (ps1 != null) ps1.close();
	                if (ps2 != null) ps2.close();
	                if (conn != null) conn.close();
	            } catch (Exception e) {
	                e.printStackTrace();
	            }
	        }
	    }
	}
