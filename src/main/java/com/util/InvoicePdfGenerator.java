package com.util;

import java.io.OutputStream;
import java.net.URL;
import java.sql.*;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

public class InvoicePdfGenerator {

    public static void generatePdf(HttpServletResponse response, int billId, HttpSession session) throws Exception {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=invoice_" + billId + ".pdf");

        Document document = new Document();
        OutputStream out = response.getOutputStream();
        PdfWriter.getInstance(document, out);
        document.open();

        Font titleFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD);
        Font headerFont = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD);
        Font normalFont = new Font(Font.FontFamily.HELVETICA, 11);

        // ✅ Add Logo
        try {
            String logoUrl = (String) session.getAttribute("companyLogo");
            if (logoUrl != null && !logoUrl.isEmpty()) {
                Image logo = Image.getInstance(new URL(logoUrl));
                logo.scaleToFit(100, 100);
                logo.setAlignment(Image.ALIGN_CENTER);
                document.add(logo);
            }
        } catch (Exception e) {
            System.err.println("Warning: Failed to load logo: " + e.getMessage());
        }

        Paragraph title = new Paragraph("INVOICE", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        title.setSpacingAfter(15f);
        document.add(title);

        // ✅ Company Info
        String companyName = (String) session.getAttribute("companyName");
        String companyEmail = (String) session.getAttribute("companyEmail");
        String companyPhone = (String) session.getAttribute("companyPhone");
        String companyAddress = (String) session.getAttribute("companyAddress");
        String companyGST = (String) session.getAttribute("companyGST");
        int userId = (int) session.getAttribute("userId");

        PdfPTable infoTable = new PdfPTable(2);
        infoTable.setWidthPercentage(100);
        infoTable.setSpacingAfter(10f);

        PdfPCell fromCell = new PdfPCell();
        fromCell.setBorder(Rectangle.NO_BORDER);
        fromCell.addElement(new Paragraph("From:", headerFont));
        fromCell.addElement(new Paragraph(companyName, normalFont));
        fromCell.addElement(new Paragraph("Email: " + companyEmail, normalFont));
        fromCell.addElement(new Paragraph("Phone: " + companyPhone, normalFont));
        fromCell.addElement(new Paragraph("Address: " + companyAddress, normalFont));
        fromCell.addElement(new Paragraph("GST: " + companyGST, normalFont));

        Connection conn = DBConnection.getConnection();

        // ✅ Fetch bill info
        PreparedStatement billStmt = conn.prepareStatement("SELECT * FROM bills WHERE id = ? AND user_id = ?");
        billStmt.setInt(1, billId);
        billStmt.setInt(2, userId);
        ResultSet billRs = billStmt.executeQuery();

        if (!billRs.next()) {
            document.add(new Paragraph("Error: Bill not found or access denied."));
            document.close();
            return;
        }

        int customerId = billRs.getInt("customer_id");
        String billDate = billRs.getString("date");
        String invoiceNumber = billRs.getString("invoice_number");

        // ✅ Fetch customer
        PreparedStatement custStmt = conn.prepareStatement("SELECT * FROM customers WHERE id = ?");
        custStmt.setInt(1, customerId);
        ResultSet custRs = custStmt.executeQuery();

        PdfPCell toCell = new PdfPCell();
        toCell.setBorder(Rectangle.NO_BORDER);
        toCell.addElement(new Paragraph("To:", headerFont));

        if (custRs.next()) {
            toCell.addElement(new Paragraph(custRs.getString("name"), normalFont));
            toCell.addElement(new Paragraph("Email: " + custRs.getString("email"), normalFont));
            toCell.addElement(new Paragraph("Phone: " + custRs.getString("phone"), normalFont));
            toCell.addElement(new Paragraph("Address: " + custRs.getString("address"), normalFont));
            toCell.addElement(new Paragraph("GST: " + custRs.getString("gst_number"), normalFont));
        } else {
            toCell.addElement(new Paragraph("Customer info not found.", normalFont));
        }

        infoTable.addCell(fromCell);
        infoTable.addCell(toCell);
        document.add(infoTable);

        // ✅ Bill metadata with invoice number
        Paragraph invoiceInfo = new Paragraph("Invoice #: " + invoiceNumber + "\nDate: " + billDate, normalFont);
        invoiceInfo.setSpacingAfter(10f);
        document.add(invoiceInfo);

        // ✅ Item Table
        PdfPTable table = new PdfPTable(7);
        table.setWidthPercentage(100);
        table.setWidths(new float[]{2, 1, 1, 1, 1, 1, 1});
        table.setSpacingBefore(10f);

        String[] headers = {"Item", "Price", "GST%", "Qty", "Subtotal", "GST Amt", "Total"};
        for (String h : headers) {
            PdfPCell cell = new PdfPCell(new Phrase(h, headerFont));
            cell.setBackgroundColor(BaseColor.LIGHT_GRAY);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            table.addCell(cell);
        }

        // ✅ Fetch bill items
        PreparedStatement itemStmt = conn.prepareStatement(
            "SELECT bi.*, i.name FROM bill_items bi JOIN items i ON bi.item_id = i.id WHERE bi.bill_id = ?"
        );
        itemStmt.setInt(1, billId);
        ResultSet itemRs = itemStmt.executeQuery();

        double grandTotal = 0.0;

        while (itemRs.next()) {
            String itemName = itemRs.getString("name");
            double price = itemRs.getDouble("price");
            double gstRate = itemRs.getDouble("gst_rate");
            int qty = itemRs.getInt("quantity");

            double subtotal = price * qty;
            double gstAmt = subtotal * gstRate / 100;
            double total = subtotal + gstAmt;
            grandTotal += total;

            table.addCell(new Phrase(itemName, normalFont));
            table.addCell(new Phrase(String.format("%.2f", price), normalFont));
            table.addCell(new Phrase(String.format("%.2f", gstRate), normalFont));
            table.addCell(new Phrase(String.valueOf(qty), normalFont));
            table.addCell(new Phrase(String.format("%.2f", subtotal), normalFont));
            table.addCell(new Phrase(String.format("%.2f", gstAmt), normalFont));
            table.addCell(new Phrase(String.format("%.2f", total), normalFont));
        }

        document.add(table);

        // ✅ Grand Total
        Paragraph totalPara = new Paragraph("Grand Total: Rs. " + String.format("%.2f", grandTotal), headerFont);
        totalPara.setAlignment(Element.ALIGN_RIGHT);
        totalPara.setSpacingBefore(10f);
        document.add(totalPara);

        document.close();
        conn.close();
    }
}
