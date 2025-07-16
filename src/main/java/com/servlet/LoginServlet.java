package com.servlet;

import com.dao.UserDAO;
import com.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        UserDAO userDAO = new UserDAO();
        User user = userDAO.validateUser(username, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("username", user.getUsername());
            session.setAttribute("userId", user.getId());
            session.setAttribute("companyName", user.getName());
            session.setAttribute("companyEmail", user.getEmail());
            session.setAttribute("companyPhone", user.getPhone());
            session.setAttribute("companyAddress", user.getAddress());
            session.setAttribute("companyGST", user.getGstNumber());
            session.setAttribute("companyLogo", user.getLogoUrl());

            response.sendRedirect("jsp/dashboard.jsp");
        } else {
            response.sendRedirect("index.jsp?error=1");
        }
    }
}
