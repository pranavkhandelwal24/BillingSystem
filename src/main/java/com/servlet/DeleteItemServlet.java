package com.servlet;

import com.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/deleteItem")
public class DeleteItemServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        int itemId = Integer.parseInt(request.getParameter("itemId"));

        try (Connection conn = DBConnection.getConnection()) {

            // ✅ Check if item belongs to this user
            PreparedStatement checkStmt = conn.prepareStatement("SELECT user_id FROM items WHERE id = ?");
            checkStmt.setInt(1, itemId);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                int itemUserId = rs.getInt("user_id");
                if (itemUserId != userId) {
                    response.getWriter().println("Unauthorized access to delete item.");
                    return;
                }
            } else {
                response.getWriter().println("Item not found.");
                return;
            }

            // ✅ Delete the item
            PreparedStatement ps = conn.prepareStatement("DELETE FROM items WHERE id = ?");
            ps.setInt(1, itemId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("jsp/stockReport.jsp");
    }
}
