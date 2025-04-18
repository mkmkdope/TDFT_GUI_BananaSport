<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manager Control Panel</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
    <!-- Header Section -->
    <header>
        
        <div class="container">
            <nav class="navbar">
                <div class="logo-container">
                    <img src="${pageContext.request.contextPath}/images/logo.jpg" alt="${applicationScope.companyName} Logo" class="logo">
                    <button class="mobile-menu-toggle" id="mobileMenuToggle">
                        <i class="fas fa-bars"></i>
                    </button>
                </div>
                <ul class="nav-links" id="navLinks">
                    <li><a href="${pageContext.request.contextPath}/index.jsp">Back to Main</a></li>
                     <li><a href="controlPanelM.jsp">Home</a></li>
                  <li><a href="addProdM.jsp">Add Products</a></li>
            <li><a href="ControlProdM">Modify Products</a></li>
            
            
            


                  
                </ul>
            </nav>
        </div>
                    
                    <%
                String msg = (String) request.getAttribute("message");
                if(msg != null){
                
                %>
                <div style="color:red;"><%= msg %></div>
                <%
                    }
                     %>
         
    </header>
</body>
</html> 