<%@ page import="model.Manager" %>
<%@ page import="util.JPAUtil" %>
<%@ page import="jakarta.persistence.EntityManager" %>

<html>
<head>
    <title>Delete Manager</title>
    <link rel="stylesheet" type="text/css" href="../css/admin.css">
</head>
<body>
    <%
        String managerIdStr = request.getParameter("managerId");
        EntityManager em = JPAUtil.getEntityManager();
        try {
            if (managerIdStr != null && !managerIdStr.trim().isEmpty()) {
                int managerId = Integer.parseInt(managerIdStr);
                em.getTransaction().begin();
                Manager manager = em.find(Manager.class, managerId);
                if (manager != null) {
                    em.remove(manager);
                    em.getTransaction().commit();
                    out.println("<div class='message success'>");
                    out.println("<p>Manager deleted successfully!</p>");
                    out.println("</div>");
                } else {
                    out.println("<div class='message error'>");
                    out.println("<p>Manager not found.</p>");
                    out.println("</div>");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<div class='message error'>");
            out.println("<p>Error deleting manager: " + e.getMessage() + "</p>");
            out.println("</div>");
        } finally {
            em.close();
        }
    %>
    <a href="${pageContext.request.contextPath}/myAdmin/managerList.jsp" class="back-link">Back to Manager List</a>
</body>
</html>
