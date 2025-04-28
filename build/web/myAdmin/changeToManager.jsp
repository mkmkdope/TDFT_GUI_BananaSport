<%@ page import="model.Staff" %>
<%@ page import="model.Manager" %>
<%@ page import="util.JPAUtil" %>
<%@ page import="jakarta.persistence.EntityManager" %>

<html>
    <head>
        <title>Change Staff to Manager</title>
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
                        // Create a new Manager object
                        Manager manager = new Manager();
                        manager.setManagerId(staff.getStaffId());
                        manager.setManagerName(staff.getStaffName());
                        manager.setManagerEmail(staff.getStaffEmail());
                        manager.setManagerPassword(staff.getStaffPassword());
                        manager.setManagerPosition(staff.getStaffPosition());
                        manager.setManagerContactNumber(staff.getStaffContactNumber());

                        // Persist the new Manager
                        em.persist(manager);

                        // Remove the Staff
                        em.remove(staff);

                        em.getTransaction().commit();
                        out.println("<div class=\"message success\">");
                        out.println("<p>Staff member successfully changed to manager.</p>");
                        out.println("</div>");
                    } else {
                        out.println("<div class=\"message error\">");
                        out.println("<p>Staff member not found.</p>");
                        out.println("</div>");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<div class=\"message error\">");
                out.println("<p>Error changing staff to manager: " + e.getMessage() + "</p>");
                out.println("</div>");
            } finally {
                em.close();
            }
        %>
        <a href="${pageContext.request.contextPath}/myAdmin/AdminModule.jsp" class="back-link">Back to Dashboard</a>
    </body>
</html>
</body>
</html>
