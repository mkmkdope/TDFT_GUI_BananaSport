<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Customer" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Management</title>
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
        .customer-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .customer-table th, .customer-table td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        .customer-table th {
            background-color: #333;
            color: #ffcc00;
        }
        .customer-table tr:hover {
            background-color: #f5f5f5;
        }
        .action-buttons {
            display: flex;
            gap: 5px;
        }
        .action-buttons button, .action-buttons form button {
            padding: 5px 10px;
            cursor: pointer;
            border: none;
            border-radius: 3px;
        }
        .view-btn {
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
        .search-box {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }
        .search-box input[type="text"] {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 3px;
            flex-grow: 1;
        }
        .search-box button {
            padding: 8px 15px;
            background-color: #333;
            color: #ffcc00;
            border: none;
            border-radius: 3px;
            cursor: pointer;
        }
        .add-customer-btn {
            padding: 10px 15px;
            background-color: #333;
            color: #ffcc00;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            margin-bottom: 20px;
            display: inline-block;
            text-decoration: none;
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
        <h1>Customer Management</h1>
        
        <div class="header-nav">
            <a href="${pageContext.request.contextPath}/myAdmin/AdminModule.jsp">Dashboard</a>
            <a href="${pageContext.request.contextPath}/myStaff/addProdM.jsp">Add Products</a>
            <a href="${pageContext.request.contextPath}/myStaff/ControlProdM">Modify Products</a>
            <a href="${pageContext.request.contextPath}/CustomerServlet" class="active">Manage Customers</a>
            <a href="${pageContext.request.contextPath}/myAdmin/AdminModule.jsp?section=reports">Sales Reports</a>
            <a href="${pageContext.request.contextPath}/LogoutServlet">Logout</a>
        </div>
        
        <div class="content">
            <a href="${pageContext.request.contextPath}/myAdmin/addCustomer.jsp" class="add-customer-btn">Add New Customer</a>
            
            <form action="${pageContext.request.contextPath}/CustomerServlet" method="get" class="search-box">
                <input type="text" name="search" placeholder="Search by name, email or username" value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                <button type="submit">Search</button>
                <button type="button" onclick="window.location.href='${pageContext.request.contextPath}/CustomerServlet'">Reset</button>
            </form>
            
            <table class="customer-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Contact Number</th>
                        <th>Email</th>
                        <th>Username</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    List<Customer> customers = (List<Customer>) request.getAttribute("customers");
                    if (customers != null && !customers.isEmpty()) {
                        for (Customer customer : customers) {
                    %>
                    <tr>
                        <td><%= customer.getCustomerId() %></td>
                        <td><%= customer.getCustomerName() %></td>
                        <td><%= customer.getContactNumber() %></td>
                        <td><%= customer.getEmail() %></td>
                        <td><%= customer.getUsername() %></td>
                        <td class="action-buttons">
                            <form action="${pageContext.request.contextPath}/CustomerServlet" method="get" style="display:inline;">
                                <input type="hidden" name="action" value="view">
                                <input type="hidden" name="customerId" value="<%= customer.getCustomerId() %>">
                                <button type="submit" class="view-btn">View</button>
                            </form>
                            <form action="${pageContext.request.contextPath}/CustomerServlet" method="get" style="display:inline;">
                                <input type="hidden" name="action" value="edit">
                                <input type="hidden" name="customerId" value="<%= customer.getCustomerId() %>">
                                <button type="submit" class="edit-btn">Edit</button>
                            </form>
                            <button onclick="confirmDelete(<%= customer.getCustomerId() %>)" class="delete-btn">Delete</button>
                        </td>
                    </tr>
                    <% 
                        }
                    } else {
                    %>
                    <tr>
                        <td colspan="6" style="text-align: center;">No customers found.</td>
                    </tr>
                    <% 
                    }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html> 