<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Staff Dashboard</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
        <!-- Font Awesome for icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <style>
            .section {
                padding: 20px;
                border: 1px solid #ddd;
                border-radius: 5px;
                margin-bottom: 30px;
            }
            /* Quick Actions */
            /* Full-page container to center everything */
            .quick-actions-container {
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 80vh; /* Takes most of the screen */
                padding: 20px;
            }

            /* Grid layout for buttons */
            .quick-actions {
                display: grid;
                grid-template-columns: repeat(2, 1fr); /* 2 columns */
                gap: 30px; /* Bigger gap between buttons */
                max-width: 800px; /* Limits width for better spacing */
            }

            /* Big, card-like buttons */
            .big-action-btn {
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                padding: 40px 20px; /* Massive padding */
                border: none;
                border-radius: 16px; /* Rounded corners */
                background: linear-gradient(135deg, #f4d746, #f4eb36);
                cursor: pointer;
                transition: all 0.3s ease;
                width: 250px; /* Fixed large size */
                height: 200px; /* Fixed large size */
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
            }

            /* Hover effect */
            .big-action-btn:hover {
                transform: translateY(-5px);
                box-shadow: 0 15px 30px rgba(0, 0, 0, 0.2);
            }

            /* Icon styling */
            .big-action-btn i {
                font-size: 48px; /* Very large icon */
                margin-bottom: 20px; /* Space below icon */
            }

            /* Text styling */
            .action-label {
                font-size: 20px; /* Big text */
                font-weight: 600; /* Bold */
            }

            /* Active state (if needed) */
            .big-action-btn.active {
                background: linear-gradient(135deg, #4CAF50, #45a049); /* Green gradient */
            }
        </style>
    </head>
    <body>
        <!-- Header Section -->
        <header>
            <div class="container">
                <nav class="navbar">
                    <% if (session.getAttribute("isManager") != null && (Boolean) session.getAttribute("isManager")) { %>
                    <a href="${pageContext.request.contextPath}/myAdmin/AdminModule.jsp">Switch to<br> Admin</a>
                        <% }%>
                    <div class="logo-container">
                        <img src="${pageContext.request.contextPath}/images/logo.jpg" alt="${applicationScope.companyName} Logo" class="logo"> 
                    </div><h2>Staff Dashboard</h2>
                    <ul class="nav-links" id="navLinks">
                        <li><a href="staffProd.jsp" class="active">Home</a></li>
                        <li><a href="addProdM.jsp">Add Products</a></li>
                        <li><a href="ControlProdM">Modify Products</a></li>
                        <li><a href="managePromo.jsp">Manage Promotions</a></li>
                        <li><a href="ordersStatus.jsp">Manage Orders</a></li>
                        <li><a href="${pageContext.request.contextPath}/LogoutServlet">Logout</a></li>
                    </ul>
                </nav>
            </div>

            <%
                String msg = (String) request.getAttribute("message");
                if (msg != null) {
            %>
            <div style="color:red;"><%= msg%></div>
            <%
                }
            %>
        </header>
        <main class="container">
            <!-- Home Section -->
            <div class="section" id="home">
                <div class="quick-actions-container">
                    <div class="quick-actions">
                        <button class="action-btn big-action-btn" onclick="window.location.href = '${pageContext.request.contextPath}/myStaff/addProdM.jsp'">
                            <i class="fas fa-plus"></i>
                            <span class="action-label">Add Products</span>
                        </button>
                        <button class="action-btn big-action-btn" onclick="window.location.href = '${pageContext.request.contextPath}/myStaff/ControlProdM'">
                            <i class="fas fa-edit"></i>
                            <span class="action-label">Modify Products</span>
                        </button>
                        <button class="action-btn big-action-btn" onclick="window.location.href = '${pageContext.request.contextPath}/myStaff/managePromo.jsp'">
                            <i class="fas fa-tags"></i>
                            <span class="action-label">Manage Promotions</span>
                        </button>
                        <button class="action-btn big-action-btn" onclick="window.location.href = '${pageContext.request.contextPath}/myStaff/ordersStatus.jsp'">
                            <i class="fas fa-clipboard-list"></i>
                            <span class="action-label">Manage Orders</span>
                        </button>
                    </div>
                </div>
            </div>
        </main>

        <script>
            // Mobile menu toggle
            document.getElementById('mobileMenuToggle').addEventListener('click', function () {
                document.getElementById('navLinks').classList.toggle('show');
            });
        </script>
    </body>
</html> 