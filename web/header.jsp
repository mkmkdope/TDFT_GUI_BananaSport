<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${param.pageTitle} - ${applicationScope.companyName}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .dropdown {
            position: relative;
            display: inline-block;
        }
        
        .dropdown-content {
            display: none;
            position: absolute;
            right: 0;
            background-color: #f9f9f9;
            min-width: 160px;
            box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
            z-index: 1;
            border-radius: 4px;
        }
        
        .dropdown-content a {
            color: black;
            padding: 12px 16px;
            text-decoration: none;
            display: block;
            text-align: left;
        }
        
        .dropdown-content a:hover {
            background-color: #f1f1f1;
        }
        
        .dropdown:hover .dropdown-content {
            display: block;
        }
        
        .welcome-user {
            color: black;
            font-weight: bold;
        }
    </style>
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
                    <li><a href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/showProd">Products</a></li>
                    <li><a href="${pageContext.request.contextPath}/myCustomer/promotions.jsp">Promotions</a></li>
                    <li><a href="${pageContext.request.contextPath}/staticView/about.jsp">About Us</a></li>
                    <li><a href="${pageContext.request.contextPath}/staticView/contact.jsp">Contact</a></li>
                    <li>
                        <form action="searchProd" method="get" class="search-form">
                            <input type="text" id="search" name="search" placeholder="Search products..." value="${requestScope.searchparameter}">
                            <button type="submit"><i class="fas fa-search"></i></button>
                        </form>
                    </li>
                    <li><a href="${pageContext.request.contextPath}/myCustomer/cart.jsp"><i class="fas fa-shopping-cart"></i> Cart</a></li>
                    
                    <% if (session.getAttribute("loggedIn") != null && (Boolean) session.getAttribute("loggedIn")) { %>
                        <li class="dropdown">
                            <a href="#"><i class="fas fa-user"></i> <span class="welcome-user">Hi, <%= session.getAttribute("username") %></span></a>
                            <div class="dropdown-content">
                                <a href="${pageContext.request.contextPath}/myCustomer/profile.jsp">My Profile</a>
                                <a href="${pageContext.request.contextPath}/myCustomer/orders.jsp">My Orders</a>
                                <a href="${pageContext.request.contextPath}/LogoutServlet">Logout</a>
                            </div>
                        </li>
                    <% } else { %>
                        <li><a href="${pageContext.request.contextPath}/login.jsp"><i class="fas fa-user"></i> Login</a></li>
                    <% } %>
                </ul>
            </nav>
        </div>
    </header>
</body>
</html> 