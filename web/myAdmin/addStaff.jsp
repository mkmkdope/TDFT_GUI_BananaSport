<%@ page import="model.Staff" %>
<%@ page import="util.JPAUtil" %>
<%@ page import="jakarta.persistence.EntityManager" %>
<%@ page import="jakarta.persistence.TypedQuery" %>
<%@ page import="java.util.Random" %>

<html>
<head>
    <title>Add New Staff</title>
    <link rel="stylesheet" type="text/css" href="../css/admin.css">
</head>
<body>
    <form action="${pageContext.request.contextPath}/myAdmin/AdminModule.jsp" method="get" style="display:inline;">
        <button>Back to Dashboard</button>
    </form>
    <h1>Add New Staff</h1>
    <form method="post">
        <label for="staffName">Name:</label>
        <input type="text" id="staffName" name="staffName" required><br>
        <label for="staffEmail">Email:</label>
        <input type="email" id="staffEmail" name="staffEmail" required><br>
        <label for="staffPassword">Password:</label>
        <input type="password" id="staffPassword" name="staffPassword" required><br>
        <label for="staffPosition">Position:</label>
        <input type="text" id="staffPosition" name="staffPosition" required><br>
        <label for="staffContactNumber">Contact Number:</label>
        <input type="text" id="staffContactNumber" name="staffContactNumber" required><br>
        <button type="submit">Add Staff</button>
    </form>

<%
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String staffName = request.getParameter("staffName");
        String staffEmail = request.getParameter("staffEmail");
        String staffPassword = request.getParameter("staffPassword");
        String staffPosition = request.getParameter("staffPosition");
        String staffContactNumber = request.getParameter("staffContactNumber");

        EntityManager em = null;
        try {
            em = JPAUtil.getEntityManager();
            em.getTransaction().begin();

            // Generate a unique staff ID
            int staffId;
            boolean isUnique;
            do {
                staffId = new Random().nextInt(100); // Generate a random ID
                TypedQuery<Long> staffQuery = em.createQuery("SELECT COUNT(s) FROM Staff s WHERE s.staffId = :staffId", Long.class);
                staffQuery.setParameter("staffId", staffId);
                long staffCount = staffQuery.getSingleResult();

                TypedQuery<Long> managerQuery = em.createQuery("SELECT COUNT(m) FROM Manager m WHERE m.managerId = :managerId", Long.class);
                managerQuery.setParameter("managerId", staffId);
                long managerCount = managerQuery.getSingleResult();

                isUnique = (staffCount == 0 && managerCount == 0);
            } while (!isUnique);

            Staff staff = new Staff();
            staff.setStaffId(staffId);
            staff.setStaffName(staffName);
            staff.setStaffEmail(staffEmail);
            staff.setStaffPassword(staffPassword);
            staff.setStaffPosition(staffPosition);
            staff.setStaffContactNumber(staffContactNumber);
            em.persist(staff);
            em.getTransaction().commit();
            out.println("<p>Staff member added successfully!</p>");
            
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p>Error adding staff member: " + e.getMessage() + "</p>");
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }
%>
</body>
</html>