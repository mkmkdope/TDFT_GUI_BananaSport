<%@ page import="model.Staff" %>
<%@ page import="model.Manager" %>
<%@ page import="util.JPAUtil" %>
<%@ page import="jakarta.persistence.EntityManager" %>

<html>
<head>
    <title>Change Manager to Staff</title>
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
                    // Create a new Staff object
                    Staff staff = new Staff();
                    staff.setStaffId(manager.getManagerId());
                    staff.setStaffName(manager.getManagerName());
                    staff.setStaffEmail(manager.getManagerEmail());
                    staff.setStaffPassword(manager.getManagerPassword());
                    staff.setStaffPosition(manager.getManagerPosition());
                    staff.setStaffContactNumber(manager.getManagerContactNumber());

                    // Persist the new Staff
                    em.persist(staff);

                    // Remove the Manager
                    em.remove(manager);

                    em.getTransaction().commit();
                    out.println("<p>Manager successfully changed to staff member.</p>");
                } else {
                    out.println("<p>Manager not found.</p>");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p>Error changing manager to staff: " + e.getMessage() + "</p>");
        } finally {
            em.close();
        }
    %>
    <a href="${pageContext.request.contextPath}/myAdmin/AdminModule.jsp">Back to Dashboard</a>
</body>
</html>