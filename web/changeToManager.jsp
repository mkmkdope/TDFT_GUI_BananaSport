<%@ page import="com.bananasports.servlet.Staff" %>
<%@ page import="com.bananasports.servlet.Manager" %>
<%@ page import="com.bananasports.servlet.JPAUtil" %>
<%@ page import="jakarta.persistence.EntityManager" %>

<html>
<head>
    <title>Change Staff to Manager</title>
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
                    out.println("<p>Staff member successfully changed to manager.</p>");
                } else {
                    out.println("<p>Staff member not found.</p>");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p>Error changing staff to manager: " + e.getMessage() + "</p>");
        } finally {
            em.close();
        }
    %>
    <a href="AdminModule.jsp">Back to Dashboard</a>
</body>
</html>