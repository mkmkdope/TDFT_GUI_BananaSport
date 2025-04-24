<%@ page import="com.bananasports.servlet.Manager" %>
<%@ page import="com.bananasports.servlet.JPAUtil" %>
<%@ page import="jakarta.persistence.EntityManager" %>

<html>
<head>
    <title>Delete Manager</title>
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
                    out.println("<p>Manager deleted successfully!</p>");
                } else {
                    out.println("<p>Manager not found.</p>");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p>Error deleting manager: " + e.getMessage() + "</p>");
        } finally {
            em.close();
        }
    %>
    <a href="managerList.jsp">Back to Manager List</a>
</body>
</html>