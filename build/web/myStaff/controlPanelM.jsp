<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>

<% 
    // Redirect to appropriate page based on the section parameter
    String section = request.getParameter("section");
    
    if (section == null || section.equals("home")) {
        response.sendRedirect("staffProd.jsp");
        return;
    } else if (section.equals("promotions")) {
        response.sendRedirect("managePromo.jsp");
        return;
    } else if (section.equals("orders")) {
        response.sendRedirect("ordersStatus.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="refresh" content="0;url=staffProd.jsp">
        <title>Redirecting...</title>
    </head>
    <body>
        <p>Redirecting to dashboard...</p>
    </body>
</html> 