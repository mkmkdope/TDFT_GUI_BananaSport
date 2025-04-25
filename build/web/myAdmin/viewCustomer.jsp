<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Customer" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Customer</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/admin.css">
    <style>
                            .header-nav {
                background-color: #333;
                overflow: hidden;
                margin-bottom: 20px;
                border-radius: 5px;
            }
            .header-nav a {
                float: left;
                color: white;
                text-align: center;
                padding: 14px 20px;
                text-decoration: none;
                font-size: 16px;
                transition: background-color 0.3s;
            }
            .header-nav a:hover {
                background-color: #555;
            }
        .customer-details {
            max-width: 600px;
            margin: 0 auto;
            background-color: #f9f9f9;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .detail-item {
            margin-bottom: 15px;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }
        .detail-item:last-child {
            border-bottom: none;
        }
        .detail-label {
            font-weight: bold;
            color: #333;
            display: block;
            margin-bottom: 5px;
        }
        .detail-value {
            color: #666;
        }
        .action-buttons {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }
        .action-buttons button, .action-buttons a {
            padding: 10px 15px;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            text-decoration: none;
            text-align: center;
        }
        .back-btn {
            background-color: #2196F3;
            color: white;
        }
        .edit-btn {
            background-color: #FFC107;
            color: #000;
        }
        .delete-btn {
            background-color: #F44336;
            color: white;
        }
    </style>
    <script>
        function confirmDelete(customerId) {
            if (confirm('Are you sure you want to delete this customer?')) {
                window.location.href = '${pageContext.request.contextPath}/CustomerServlet?action=delete&customerId=' + customerId;
            }
        }
    </script>
</head>
<body>
    <div class="container">
        <h1>Customer Details</h1>
        
        <div class="header-nav">
            <a href="${pageContext.request.contextPath}/myAdmin/AdminModule.jsp">Dashboard</a>
            <a href="${pageContext.request.contextPath}/myStaff/addProdM.jsp">Add Products</a>
            <a href="${pageContext.request.contextPath}/myStaff/ControlProdM">Modify Products</a>
            <a href="${pageContext.request.contextPath}/CustomerServlet" class="active">Manage Customers</a>
            <a href="${pageContext.request.contextPath}/myAdmin/AdminModule.jsp?section=reports">Sales Reports</a>
            <a href="${pageContext.request.contextPath}/LogoutServlet">Logout</a>
        </div>
        
        <div class="content">
            <% Customer customer = (Customer) request.getAttribute("customer"); %>
            
            <div class="customer-details">
                <div class="detail-item">
                    <span class="detail-label">Customer ID:</span>
                    <span class="detail-value"><%= customer.getCustomerId() %></span>
                </div>
                
                <div class="detail-item">
                    <span class="detail-label">Name:</span>
                    <span class="detail-value"><%= customer.getCustomerName() %></span>
                </div>
                
                <div class="detail-item">
                    <span class="detail-label">Contact Number:</span>
                    <span class="detail-value"><%= customer.getContactNumber() %></span>
                </div>
                
                <div class="detail-item">
                    <span class="detail-label">Email:</span>
                    <span class="detail-value"><%= customer.getEmail() %></span>
                </div>
                
                <div class="detail-item">
                    <span class="detail-label">Username:</span>
                    <span class="detail-value"><%= customer.getUsername() %></span>
                </div>
                
                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/CustomerServlet" class="back-btn">Back to List</a>
                    <a href="${pageContext.request.contextPath}/CustomerServlet?action=edit&customerId=<%= customer.getCustomerId() %>" class="edit-btn">Edit</a>
                    <button onclick="confirmDelete(<%= customer.getCustomerId() %>)" class="delete-btn">Delete</button>
                </div>
            </div>
        </div>
    </div>
</body>
</html> 