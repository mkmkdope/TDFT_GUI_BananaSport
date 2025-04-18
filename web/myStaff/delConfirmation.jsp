<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String id = (String) request.getAttribute("id");
%>

<jsp:include page="controlPanelM.jsp">
    <jsp:param name="pageTitle" value="Products"/>
</jsp:include>

<!DOCTYPE html>
<html>
<head>
    <title>Confirm Deletion</title>
</head>
<body>
    <h2>Are you sure you want to delete product ID: <%= id %>?</h2>

    <form action="deleteProd" method="post" style="display:inline;">
        <input type="hidden" name="id" value="<%= id %>" />

        <div>
            <button type="submit" name="delAction" value="confirm" style="background-color:green; color:white;">
                Yes, Delete
            </button>
        </div>
        <div>
            <button type="submit" name="delAction" value="Noconfirm" style="background-color:red; color:white;">
                No, Cancel
            </button>
        </div>
    </form>
</body>
</html>
