<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="header.jsp" />

<!-- Layout container -->
<div class="main-container" style="display: flex; min-height: 80vh;">
    <jsp:include page="sidebar.jsp" />

    <!-- Page-specific content will be inserted here -->
    <div class="content" style="flex: 1; padding: 20px;">
        <jsp:include page="${contentPage}" />
    </div>
</div>

<jsp:include page="footer.jsp" />
