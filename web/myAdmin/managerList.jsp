<%@ page import="model.Manager" %>
<%@ page import="util.JPAUtil" %>
<%@ page import="jakarta.persistence.EntityManager" %>
<%@ page import="jakarta.persistence.TypedQuery" %>
<%@ page import="java.util.List" %>

<html>
<head>
    <title>Manager List</title>
    <link rel="stylesheet" type="text/css" href="../css/admin.css">
    <script type="text/javascript">
        function confirmChange(managerId) {
            if (confirm("Are you sure you want to change this manager to a staff member?")) {
                window.location.href = "${pageContext.request.contextPath}/myAdmin/changeToStaff.jsp?managerId=" + managerId;
            }
        }

        function confirmDelete(managerId) {
            if (confirm("Are you sure you want to delete this manager?")) {
                window.location.href = "${pageContext.request.contextPath}/myAdmin/deleteManager.jsp?managerId=" + managerId;
            }
        }

        function resetSearch() {
            window.location.href = "${pageContext.request.contextPath}/myAdmin/managerList.jsp";
        }
    </script>
</head>
<body>
    <h1>Manager List</h1>
    <form action="${pageContext.request.contextPath}/myAdmin/AdminModule.jsp" method="get" style="display:inline;">
        <button>Back to Dashboard</button>
    </form>

    <!-- Search Form -->
    <form method="get" style="display:inline;">
        <label for="search">Search by Name or Email:</label>
        <input type="text" id="search" name="search" value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
        <button type="submit">Search</button>
        <button type="button" onclick="resetSearch()">Reset</button>
    </form>

    <table border="1" cellpadding="5" cellspacing="0">
        <tr>
            <th>Manager ID</th>
            <th>Name</th>
            <th>Email</th>
            <th>Position</th>
            <th>Contact Number</th>
            <th>Actions</th>
        </tr>
        <%
            String search = request.getParameter("search");
            EntityManager em = JPAUtil.getEntityManager();
            List<Manager> managerList = null;
            try {
                String queryStr = "SELECT m FROM Manager m";
                if (search != null && !search.trim().isEmpty()) {
                    queryStr += " WHERE m.managerName LIKE :search OR m.managerEmail LIKE :search";
                }
                TypedQuery<Manager> query = em.createQuery(queryStr, Manager.class);
                if (search != null && !search.trim().isEmpty()) {
                    query.setParameter("search", "%" + search + "%");
                }
                managerList = query.getResultList();
                for (Manager manager : managerList) {
        %>
        <tr>
            <td><%= manager.getManagerId() %></td>
            <td><%= manager.getManagerName() %></td>
            <td><%= manager.getManagerEmail() %></td>
            <td><%= manager.getManagerPosition() %></td>
            <td><%= manager.getManagerContactNumber() %></td>
            <td>
                <form action="${pageContext.request.contextPath}/myAdmin/editManager.jsp" method="get" style="display:inline;">
                    <input type="hidden" name="managerId" value="<%= manager.getManagerId() %>">
                    <button type="submit">Edit</button>
                </form>
                <button onclick="confirmDelete(<%= manager.getManagerId() %>)">Delete</button>
                <button onclick="confirmChange(<%= manager.getManagerId() %>)">Restrict Permissions</button>
            </td>
        </tr>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p>Error retrieving manager list: " + e.getMessage() + "</p>");
            } finally {
                em.close();
            }
        %>
    </table>
</body>
</html>