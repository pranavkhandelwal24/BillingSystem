<%@ page import="java.sql.*" %>
<%@ page import="com.util.DBConnection" %>
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String name = "", email = "", phone = "", address = "", gst = "", logoUrl = "";

    try {
        conn = DBConnection.getConnection();
        ps = conn.prepareStatement("SELECT * FROM users WHERE id = ?");
        ps.setInt(1, userId);
        rs = ps.executeQuery();
        if (rs.next()) {
            name = rs.getString("name");
            email = rs.getString("email");
            phone = rs.getString("phone");
            address = rs.getString("address");
            gst = rs.getString("gst_number");
            logoUrl = rs.getString("logo_url");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
%>

<%@ include file="header.jsp" %>
<%@ include file="sidebar.jsp" %>

<div style="padding: 20px;">
    <h2>Update Profile</h2>

    <form action="../updateProfile" method="post" enctype="multipart/form-data">
        <table cellpadding="10">
            <tr>
                <td>Name:</td>
                <td><input type="text" name="name" value="<%= name %>" readonly /></td>
            </tr>
            <tr>
                <td>Email:</td>
                <td><input type="email" name="email" value="<%= email %>" required /></td>
            </tr>
            <tr>
                <td>Phone:</td>
                <td><input type="text" name="phone" value="<%= phone %>" /></td>
            </tr>
            <tr>
                <td>GST Number:</td>
                <td><input type="text" name="gst_number" value="<%= gst %>" /></td>
            </tr>
            <tr>
                <td>Address:</td>
                <td><textarea name="address"><%= address %></textarea></td>
            </tr>
            <tr>
                <td>Logo:</td>
                <td>
                    <% if (logoUrl != null && !logoUrl.isEmpty()) { %>
                        <img id="logoPreview" src="<%= logoUrl %>" alt="Company Logo" style="max-height: 100px;" /><br>
                    <% } else { %>
                        <img id="logoPreview" src="" style="max-height: 100px; display:none;" /><br>
                    <% } %>
                    <input type="file" name="logo" accept="image/*" onchange="previewLogo(this)">
                </td>
            </tr>
            <tr>
                <td>New Password:</td>
                <td><input type="password" name="new_password" placeholder="Leave blank to keep old password" /></td>
            </tr>
            <tr>
                <td colspan="2">
                    <input type="submit" value="Update Profile" />
                </td>
            </tr>
        </table>
    </form>
</div>

<script>
    function previewLogo(input) {
        const preview = document.getElementById('logoPreview');
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function (e) {
                preview.src = e.target.result;
                preview.style.display = 'block';
            };
            reader.readAsDataURL(input.files[0]);
        }
    }
</script>

<%@ include file="footer.jsp" %>
