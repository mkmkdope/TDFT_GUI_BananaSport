<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Customer" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Customer</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/AdminCss.css">
    <style>
        .form-container {
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f9f9f9;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-group input {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 3px;
        }
        .form-group input:focus {
            outline: none;
            border-color: #4CAF50;
        }
        .form-buttons {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }
        .form-buttons button {
            padding: 10px 15px;
            border: none;
            border-radius: 3px;
            cursor: pointer;
        }
        .submit-btn {
            background-color: #4CAF50;
            color: white;
        }
        .cancel-btn {
            background-color: #f44336;
            color: white;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Edit Customer</h1>
        
        <div class="header-nav">
            <a href="${pageContext.request.contextPath}/AdminModule.jsp">Dashboard</a>
            <a href="${pageContext.request.contextPath}/myStaff/addProdM.jsp">Add Products</a>
            <a href="${pageContext.request.contextPath}/myStaff/ControlProdM">Modify Products</a>
            <a href="${pageContext.request.contextPath}/CustomerServlet" class="active">Manage Customers</a>
            <a href="${pageContext.request.contextPath}/AdminModule.jsp?section=reports">Sales Reports</a>
            <a href="${pageContext.request.contextPath}/LogoutServlet">Logout</a>
        </div>
        
        <div class="content">
            <div class="form-container">
                <% Customer customer = (Customer) request.getAttribute("customer"); %>
                
                <form action="${pageContext.request.contextPath}/CustomerServlet" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="customerId" value="<%= customer.getCustomerId() %>">
                    
                    <div class="form-group">
                        <label for="customerName">Customer Name:</label>
                        <input type="text" id="customerName" name="customerName" value="<%= customer.getCustomerName() %>" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="contactNumber">Contact Number:</label>
                        <input type="text" id="contactNumber" name="contactNumber" value="<%= customer.getContactNumber() %>" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="email">Email:</label>
                        <input type="email" id="email" name="email" value="<%= customer.getEmail() %>" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="username">Username:</label>
                        <input type="text" id="username" name="username" value="<%= customer.getUsername() %>" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="password">Password:</label>
                        <input type="password" id="password" name="password" value="<%= customer.getPassword() %>" required>
                    </div>
                    
                    <div class="form-buttons">
                        <button type="button" class="cancel-btn" onclick="window.location.href='${pageContext.request.contextPath}/CustomerServlet'">Cancel</button>
                        <button type="submit" class="submit-btn">Update Customer</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html> 