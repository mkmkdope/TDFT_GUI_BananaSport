<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="servlet.DBConnection" %>

<%
    // Check if user is logged in and is a manager
    if (session.getAttribute("loggedIn") == null || 
        !(Boolean) session.getAttribute("loggedIn") || 
        !(Boolean) session.getAttribute("isManager")) {
        response.sendRedirect(request.getContextPath() + "/myStaff/loginM.jsp");
        return;
    }
    
    // Get user info from session
    int userId = (Integer) session.getAttribute("userId");
    String userName = (String) session.getAttribute("userName");
    String userEmail = (String) session.getAttribute("userEmail");
    String userPosition = (String) session.getAttribute("userPosition");
%>

<jsp:include page="/header.jsp">
    <jsp:param name="pageTitle" value="Manager Dashboard"/>
</jsp:include>

<html>
<head>
    <title>Manager Dashboard</title>
    <style>
        .dashboard-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        .welcome-section {
            background-color: #f5f5f5;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .dashboard-card {
            background-color: white;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            border-radius: 5px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }
        h1, h2, h3 {
            color: #333;
        }
        .action-button {
            display: inline-block;
            background-color: #4CAF50;
            color: white;
            padding: 8px 16px;
            text-decoration: none;
            border-radius: 4px;
            margin-top: 10px;
        }
        .action-button:hover {
            background-color: #45a049;
        }
        .manager-section {
            background-color: #e7f7ff;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #2196F3;
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <div class="welcome-section">
            <h1>Welcome, <%= userName %></h1>
            <p>Role: <%= userPosition %> (Manager)</p>
            <p>Email: <%= userEmail %></p>
        </div>
        
        <div class="manager-section">
            <h2>Manager Access</h2>
            <p>As a manager, you have access to additional features and functionality.</p>
        </div>
        
        <h2>Dashboard</h2>
        
        <div class="dashboard-grid">
            <div class="dashboard-card">
                <h3>Products Management</h3>
                <p>View and manage products in the inventory.</p>
                <a href="${pageContext.request.contextPath}/products.jsp" class="action-button">View Products</a>
            </div>
            
            <div class="dashboard-card">
                <h3>Customer Orders</h3>
                <p>View and process customer orders.</p>
                <a href="#" class="action-button">View Orders</a>
            </div>
            
            <div class="dashboard-card">
                <h3>Staff Management</h3>
                <p>View and manage staff members.</p>
                <a href="${pageContext.request.contextPath}/employeeList.jsp" class="action-button">Manage Staff</a>
            </div>
            
            <div class="dashboard-card">
                <h3>Reports</h3>
                <p>Access sales and inventory reports.</p>
                <a href="#" class="action-button">View Reports</a>
            </div>
            
            <div class="dashboard-card">
                <h3>My Profile</h3>
                <p>Update your personal information.</p>
                <a href="#" class="action-button">Edit Profile</a>
            </div>
            
            <div class="dashboard-card">
                <h3>Admin Access</h3>
                <p>Access administrative functions.</p>
                <a href="${pageContext.request.contextPath}/AdminModule.jsp" class="action-button">Admin Panel</a>
            </div>
        </div>
    </div>
    
    <footer>
        <p>&copy; 2023 Banana Sports. All rights reserved.</p>
    </footer>
</body>
</html> 