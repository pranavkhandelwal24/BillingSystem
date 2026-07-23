<%@ page import="java.sql.*" %>
<%@ page import="com.util.DBConnection" %>
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
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

<h2 class="page-title">Update Profile</h2>

<div class="card" style="max-width: 700px;">
    <form action="../updateProfile" method="post" enctype="multipart/form-data">
        
        <div class="form-group">
            <label for="name">Name (Read-only)</label>
            <input type="text" id="name" name="name" value="<%= name %>" readonly style="background-color: #f1f5f9; cursor: not-allowed;" />
        </div>

        <div class="form-group">
            <label for="email">Email Address</label>
            <input type="email" id="email" name="email" value="<%= email %>" required />
        </div>

        <div class="form-group">
            <label for="phone">Phone Number</label>
            <input type="text" id="phone" name="phone" value="<%= phone %>" />
        </div>

        <div class="form-group">
            <label for="gst_number">GST Number</label>
            <input type="text" id="gst_number" name="gst_number" value="<%= gst %>" />
        </div>

        <div class="form-group">
            <label for="address">Address</label>
            <textarea id="address" name="address"><%= address %></textarea>
        </div>

        <div class="form-group">
            <label>Company Logo</label>
            <div style="display: flex; gap: 20px; align-items: center; margin-bottom: 12px; margin-top: 5px;">
                <% if (logoUrl != null && !logoUrl.isEmpty()) { %>
                    <img id="logoPreview" src="<%= logoUrl %>" alt="Company Logo" style="max-height: 80px; border: 1px solid var(--border-color); padding: 5px; border-radius: var(--radius);" />
                <% } else { %>
                    <img id="logoPreview" src="" style="max-height: 80px; display:none; border: 1px solid var(--border-color); padding: 5px; border-radius: var(--radius);" />
                <% } %>
                <input type="file" name="logo" accept="image/*" onchange="previewLogo(this)" style="max-width: 300px;" />
            </div>
        </div>

        <div class="form-group" style="margin-top: 25px; border-top: 1px solid var(--border-color); padding-top: 20px;">
            <label for="new_password">New Password (Optional)</label>
            <input type="password" id="new_password" name="new_password" placeholder="Leave blank to keep existing password" />
        </div>

        <button type="submit" class="btn btn-primary">Save Profile Changes</button>
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
