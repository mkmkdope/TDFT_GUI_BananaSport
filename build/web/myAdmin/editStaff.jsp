<%@ page import="model.Staff" %>
<%@ page import="util.JPAUtil" %>
<%@ page import="jakarta.persistence.EntityManager" %>

<html>
<head>
    <title>Edit Staff</title>
    <link rel="stylesheet" type="text/css" href="../css/admin.css">
</head>
<body>
    
    <h1>Edit Staff Information</h1>
    <%
        String staffIdStr = request.getParameter("staffId");
        EntityManager em = JPAUtil.getEntityManager();
        Staff staff = null;
        try {
            if (staffIdStr != null) {
                int staffId = Integer.parseInt(staffIdStr);
                staff = em.find(Staff.class, staffId);
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p>Error retrieving staff details: " + e.getMessage() + "</p>");
        }
    %>
        <form action="${pageContext.request.contextPath}/myAdmin/AdminModule.jsp" method="get" style="display:inline;">
        <button>Back to Dashboard</button>
    </form>
    <form method="post">
        <input type="hidden" name="staffId" value="<%= staff != null ? staff.getStaffId() : "" %>">
        <label for="staffName">Name:</label>
        <input type="text" id="staffName" name="staffName" value="<%= staff != null ? staff.getStaffName() : "" %>" required><br>
        <label for="staffEmail">Email:</label>
        <input type="email" id="staffEmail" name="staffEmail" value="<%= staff != null ? staff.getStaffEmail() : "" %>" required><br>
        <label for="staffPassword">Password:</label>
        <input type="password" id="staffPassword" name="staffPassword" value="<%= staff != null ? staff.getStaffPassword() : "" %>" required><br>
        <label for="staffPosition">Position:</label>
        <input type="text" id="staffPosition" name="staffPosition" value="<%= staff != null ? staff.getStaffPosition() : "" %>" required><br>
        <label for="staffContactNumber">Contact Number:</label>
        <input type="text" id="staffContactNumber" name="staffContactNumber" value="<%= staff != null ? staff.getStaffContactNumber() : "" %>" required><br>
        <button type="submit">Update</button>
    </form>

    <%
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String staffName = request.getParameter("staffName");
            String staffEmail = request.getParameter("staffEmail");
            String staffPassword = request.getParameter("staffPassword");
            String staffPosition = request.getParameter("staffPosition");
            String staffContactNumber = request.getParameter("staffContactNumber");

            try {
                em.getTransaction().begin();
                staff.setStaffName(staffName);
                staff.setStaffEmail(staffEmail);
                staff.setStaffPassword(staffPassword);
                staff.setStaffPosition(staffPosition);
                staff.setStaffContactNumber(staffContactNumber);
                em.getTransaction().commit();
                out.println("<p>Staff updated successfully!</p>");
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p>Error updating staff: " + e.getMessage() + "</p>");
            } finally {
                em.close();
            }
        }
    %>
</body>
</html>