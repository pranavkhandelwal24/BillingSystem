package com.servlet;

import com.dao.ItemDAO;
import com.model.Item;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/addItem")
public class AddItemServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 🧠 Get logged-in user's ID from session
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("index.jsp?error=Please login first");
            return;
        }

        // 🧾 Read form data
        String name = request.getParameter("name");
        double price = Double.parseDouble(request.getParameter("price"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        double gst = Double.parseDouble(request.getParameter("gst"));
        String hsnCode = request.getParameter("hsnCode");

        // 📦 Create item and set values
        Item item = new Item();
        item.setName(name);
        item.setPrice(price);
        item.setQuantity(quantity);
        item.setGstRate(gst);
        item.setHsnCode(hsnCode);
        item.setUserId(userId); // ✅ Associate with logged-in user

        // 💾 Save to DB
        ItemDAO dao = new ItemDAO();
        dao.addItem(item);

        response.sendRedirect("jsp/addItem.jsp?success=1");
    }
}
