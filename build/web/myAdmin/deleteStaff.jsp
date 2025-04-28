<%@ page import="model.Staff" %>
<%@ page import="util.JPAUtil" %>
<%@ page import="jakarta.persistence.EntityManager" %>

<html>
<head>
    <title>Delete Staff</title>
    <link rel="stylesheet" type="text/css" href="../css/admin.css">
</head>
<body>
    <%
        String staffIdStr = request.getParameter("staffId");
        EntityManager em = JPAUtil.getEntityManager();
        try {
            if (staffIdStr != null && !staffIdStr.trim().isEmpty()) {
                int staffId = Integer.parseInt(staffIdStr);
                em.getTransaction().begin();
                Staff staff = em.find(Staff.class, staffId);
                if (staff != null) {
                    em.remove(staff);
                    em.getTransaction().commit();
                    out.println("<div class='message success'>");
                    out.println("<p>Staff member deleted successfully!</p>");
                    out.println("</div>");
                } else {
                    out.println("<div class='message error'>");
                    out.println("<p>Staff member not found.</p>");
                    out.println("</div>");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<div class='message error'>");
            out.println("<p>Error deleting staff member: " + e.getMessage() + "</p>");
            out.println("</div>");
        } finally {
            em.close();
        }
    %>
    <a href="${pageContext.request.contextPath}/myAdmin/AdminModule.jsp" class="back-link">Back to Dashboard</a>
</body>
</html>
