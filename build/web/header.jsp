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
                    <li><a href="${pageContext.request.contextPath}/products.jsp">Products</a></li>
                    <li><a href="${pageContext.request.contextPath}/promotions.jsp">Promotions</a></li>
                    <li><a href="${pageContext.request.contextPath}/about.jsp">About Us</a></li>
                    <li><a href="${pageContext.request.contextPath}/contact.jsp">Contact</a></li>
                    <li>
                        <form action="${pageContext.request.contextPath}/search" method="get" class="search-form">
                            <input type="text" name="query" placeholder="Search products..." value="${requestScope.searchQuery}">
                            <button type="submit"><i class="fas fa-search"></i></button>
                        </form>
                    </li>
                    <li><a href="${pageContext.request.contextPath}/cart.jsp"><i class="fas fa-shopping-cart"></i> Cart</a></li>
                    <li><a href="${pageContext.request.contextPath}/login.jsp"><i class="fas fa-user"></i> Login</a></li>
                </ul>
            </nav>
        </div>
    </header>
</body>
</html> 