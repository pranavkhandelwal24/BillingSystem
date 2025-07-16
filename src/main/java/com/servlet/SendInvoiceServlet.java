package com.servlet;

import java.io.IOException;
import java.sql.*;
import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.util.DBConnection;

@WebServlet("/sendInvoice")
public class SendInvoiceServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int billId = Integer.parseInt(request.getParameter("billId"));

        try (Connection conn = DBConnection.getConnection()) {

            // Fetch bill, customer and company details
            PreparedStatement billStmt = conn.prepareStatement("SELECT * FROM bills WHERE id = ?");
            billStmt.setInt(1, billId);
            ResultSet billRs = billStmt.executeQuery();

            if (!billRs.next()) {
                response.getWriter().println("Bill not found");
                return;
            }

            int customerId = billRs.getInt("customer_id");
            double total = billRs.getDouble("total_amount");
            String date = billRs.getString("date");
            String invoice = billRs.getString("invoice_number");

            PreparedStatement custStmt = conn.prepareStatement("SELECT * FROM customers WHERE id = ?");
            custStmt.setInt(1, customerId);
            ResultSet custRs = custStmt.executeQuery();
            custRs.next();

            String customerEmail = custRs.getString("email");
            String customerName = custRs.getString("name");

            // Fetch bill items
            PreparedStatement itemStmt = conn.prepareStatement(
                "SELECT bi.*, i.name FROM bill_items bi JOIN items i ON bi.item_id = i.id WHERE bi.bill_id = ?");
            itemStmt.setInt(1, billId);
            ResultSet itemRs = itemStmt.executeQuery();

            // Build email content
            StringBuilder body = new StringBuilder();
            body.append("<h3>Invoice #: ").append(invoice).append("</h3>");
            body.append("<p><strong>Date:</strong> ").append(date).append("</p>");
            body.append("<p><strong>To:</strong> ").append(customerName).append("</p>");

            body.append("<table border='1' cellpadding='6' cellspacing='0'>");
            body.append("<tr><th>Item</th><th>Qty</th><th>Price</th><th>GST %</th><th>Total</th></tr>");

            double grandTotal = 0;
            while (itemRs.next()) {
                String name = itemRs.getString("name");
                int qty = itemRs.getInt("quantity");
                double price = itemRs.getDouble("price");
                double gst = itemRs.getDouble("gst_rate");

                double sub = price * qty;
                double gstAmt = sub * gst / 100;
                double totalAmt = sub + gstAmt;

                body.append("<tr><td>").append(name).append("</td>")
                    .append("<td>").append(qty).append("</td>")
                    .append("<td>").append(price).append("</td>")
                    .append("<td>").append(gst).append("</td>")
                    .append("<td>").append(String.format("%.2f", totalAmt)).append("</td></tr>");

                grandTotal += totalAmt;
            }
            body.append("</table>");
            body.append("<h4>Total Payable: ₹").append(String.format("%.2f", grandTotal)).append("</h4>");

            // Send email
            sendEmail(customerEmail, "Invoice: " + invoice, body.toString());

            response.sendRedirect("jsp/viewBills.jsp?billId=" + billId + "&emailSent=true");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error sending invoice: " + e.getMessage());
        }
    }

    private void sendEmail(String to, String subject, String htmlBody) throws MessagingException {
        final String from = "testbotpranav@gmail.com"; // replace with your sender email
        final String pass = "nufrwezsmsvtitdb"; // replace with your sender email password

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com"); // for Gmail
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true"); // TLS

        Session session = Session.getInstance(props, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, pass);
            }
        });

        Message msg = new MimeMessage(session);
        msg.setFrom(new InternetAddress(from));
        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        msg.setSubject(subject);
        msg.setContent(htmlBody, "text/html");

        Transport.send(msg);
    }
}
