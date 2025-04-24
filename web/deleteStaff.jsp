<%@ page import="com.bananasports.servlet.Staff" %>
<%@ page import="com.bananasports.servlet.JPAUtil" %>
<%@ page import="jakarta.persistence.EntityManager" %>

<html>
<head>
    <title>Delete Staff</title>
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
                    out.println("<p>Staff member deleted successfully!</p>");
                } else {
                    out.println("<p>Staff member not found.</p>");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p>Error deleting staff member: " + e.getMessage() + "</p>");
        } finally {
            em.close();
        }
    %>
    <a href="AdminModule.jsp">Back to Dashboard</a>
</body>
</html>