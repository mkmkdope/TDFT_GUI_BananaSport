<%@ page import="model.Staff" %>
<%@ page import="util.JPAUtil" %>
<%@ page import="jakarta.persistence.EntityManager" %>

<html>
<head>
    <title>Update Staff</title>
    <link rel="stylesheet" type="text/css" href="../css/admin.css">
</head>
<body>
    <h1>Update Staff Information</h1>
    <form method="get">
        <label for="staffId">Enter Staff ID:</label>
        <input type="text" id="staffId" name="staffId" required>
        <button type="submit">Search</button>
    </form>

    <%
        String staffIdStr = request.getParameter("staffId");
        EntityManager em = JPAUtil.getEntityManager();
        Staff staff = null;
        boolean staffFound = false;
        try {
            if (staffIdStr != null && !staffIdStr.trim().isEmpty()) {
                int staffId = Integer.parseInt(staffIdStr);
                staff = em.find(Staff.class, staffId);
                if (staff != null) {
                    staffFound = true;
                } else {
                    out.println("<p>Staff ID not found. Please enter a valid Staff ID.</p>");
                }
            }
        } catch (NumberFormatException e) {
            out.println("<p>Invalid Staff ID format. Please enter a valid number.</p>");
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p>Error retrieving staff details: " + e.getMessage() + "</p>");
        }
    %>

    <% if (staffFound) { %>
    <form method="post">
        <input type="hidden" name="staffId" value="<%= staff.getStaffId() %>">
        <label for="staffName">Name:</label>
        <input type="text" id="staffName" name="staffName" value="<%= staff.getStaffName() %>" required><br>
        <label for="staffEmail">Email:</label>
        <input type="email" id="staffEmail" name="staffEmail" value="<%= staff.getStaffEmail() %>" required><br>
        <label for="staffPassword">Password:</label>
        <input type="password" id="staffPassword" name="staffPassword" value="<%= staff.getStaffPassword() %>" required><br>
        <label for="staffPosition">Position:</label>
        <input type="text" id="staffPosition" name="staffPosition" value="<%= staff.getStaffPosition() %>" required><br>
        <label for="staffContactNumber">Contact Number:</label>
        <input type="text" id="staffContactNumber" name="staffContactNumber" value="<%= staff.getStaffContactNumber() %>" required><br>
        <button type="submit">Update</button>
    </form>
    <% } %>

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
                out.println("<p>Staff member updated successfully!</p>");
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p>Error updating staff member: " + e.getMessage() + "</p>");
            } finally {
                em.close();
            }
        }
    %>
</body>
</html>