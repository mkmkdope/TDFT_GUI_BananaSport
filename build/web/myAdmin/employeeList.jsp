<%@ page import="model.Staff" %>
<%@ page import="util.JPAUtil" %>
<%@ page import="jakarta.persistence.EntityManager" %>
<%@ page import="jakarta.persistence.TypedQuery" %>
<%@ page import="java.util.List" %>

<html>
<head>
    <title>Employee List</title>
    <link rel="stylesheet" type="text/css" href="../css/admin.css">
</head>
<body>
    <h1>Employee List</h1>
    <form method="get">
        <label for="search">Search by Staff ID:</label>
        <input type="text" id="search" name="search" value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
        <button type="submit">Search</button>
    </form>
    <table border="1" cellpadding="5" cellspacing="0">
        <tr>
            <th>Staff ID</th>
            <th>Name</th>
            <th>Email</th>
            <th>Position</th>
            <th>Contact Number</th>
        </tr>
        <%
            String search = request.getParameter("search");
            EntityManager em = JPAUtil.getEntityManager();
            List<Staff> staffList = null;
            try {
                String queryStr = "SELECT s FROM Staff s";
                if (search != null && !search.trim().isEmpty()) {
                    queryStr += " WHERE s.staffId = :search";
                }
                TypedQuery<Staff> query = em.createQuery(queryStr, Staff.class);
                if (search != null && !search.trim().isEmpty()) {
                    query.setParameter("search", Integer.parseInt(search));
                }
                staffList = query.getResultList();
                for (Staff staff : staffList) {
        %>
        <tr>
            <td><%= staff.getStaffId() %></td>
            <td><%= staff.getStaffName() %></td>
            <td><%= staff.getStaffEmail() %></td>
            <td><%= staff.getStaffPosition() %></td>
            <td><%= staff.getStaffContactNumber() %></td>
        </tr>
        <%
                }
            } catch (NumberFormatException e) {
                out.println("<p>Invalid Staff ID format. Please enter a valid number.</p>");
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p>Error retrieving staff list: " + e.getMessage() + "</p>");
            } finally {
                em.close();
            }
        %>
    </table>
</body>
</html>