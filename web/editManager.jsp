<%@ page import="com.bananasports.servlet.Manager" %>
<%@ page import="com.bananasports.servlet.JPAUtil" %>
<%@ page import="jakarta.persistence.EntityManager" %>

<html>
<head>
    <title>Edit Manager</title>
    <link rel="stylesheet" type="text/css" href="AdminCss.css">
</head>
<body>
    <h1>Edit Manager Information</h1>
    <%
        String managerIdStr = request.getParameter("managerId");
        EntityManager em = JPAUtil.getEntityManager();
        Manager manager = null;
        try {
            if (managerIdStr != null) {
                int managerId = Integer.parseInt(managerIdStr);
                manager = em.find(Manager.class, managerId);
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p>Error retrieving manager details: " + e.getMessage() + "</p>");
        }
    %>
    <form method="post">
        <input type="hidden" name="managerId" value="<%= manager != null ? manager.getManagerId() : "" %>">
        <label for="managerName">Name:</label>
        <input type="text" id="managerName" name="managerName" value="<%= manager != null ? manager.getManagerName() : "" %>" required><br>
        <label for="managerEmail">Email:</label>
        <input type="email" id="managerEmail" name="managerEmail" value="<%= manager != null ? manager.getManagerEmail() : "" %>" required><br>
        <label for="managerPassword">Password:</label>
        <input type="password" id="managerPassword" name="managerPassword" value="<%= manager != null ? manager.getManagerPassword() : "" %>" required><br>
        <label for="managerPosition">Position:</label>
        <input type="text" id="managerPosition" name="managerPosition" value="<%= manager != null ? manager.getManagerPosition() : "" %>" required><br>
        <label for="managerContactNumber">Contact Number:</label>
        <input type="text" id="managerContactNumber" name="managerContactNumber" value="<%= manager != null ? manager.getManagerContactNumber() : "" %>" required><br>
        <button type="submit">Update</button>
    </form>

    <%
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String managerName = request.getParameter("managerName");
            String managerEmail = request.getParameter("managerEmail");
            String managerPassword = request.getParameter("managerPassword");
            String managerPosition = request.getParameter("managerPosition");
            String managerContactNumber = request.getParameter("managerContactNumber");

            try {
                em.getTransaction().begin();
                manager.setManagerName(managerName);
                manager.setManagerEmail(managerEmail);
                manager.setManagerPassword(managerPassword);
                manager.setManagerPosition(managerPosition);
                manager.setManagerContactNumber(managerContactNumber);
                em.getTransaction().commit();
                out.println("<p>Manager updated successfully!</p>");
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p>Error updating manager: " + e.getMessage() + "</p>");
            } finally {
                em.close();
            }
        }
    %>
</body>
</html>