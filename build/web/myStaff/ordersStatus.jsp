<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Order Management</title>
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
            table {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 20px;
            }
            th, td {
                padding: 10px;
                border: 1px solid #ddd;
                text-align: left;
            }
            th {
                background-color: #333;
                color:white;
            }
            .btn {
                padding: 8px 15px;
                background-color: #007bff;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
            }
            .btn-danger {
                background-color: #dc3545;
            }
            .btn-warning {
                background-color: #ffc107;
                color: #212529;
            }
            .btn-success {
                background-color: #ffcc00;
                color: #333;
            }
            .status-badge {
                display: inline-block;
                padding: 5px 10px;
                border-radius: 3px;
                font-size: 0.85em;
                font-weight: bold;
            }
            .status-pending {
                background-color: #ffc107;
                color: #212529;
            }
            .status-packaging {
                background-color: #17a2b8;
                color: white;
            }
            .status-shipping {
                background-color: #6f42c1;
                color: white;
            }
            .status-delivery {
                background-color: #28a745;
                color: white;
            }
            .status-dropdown {
                width: auto;
                min-width: 150px;
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
                    </div><h2>Order Management</h2>
                    <ul class="nav-links" id="navLinks">
                        <li><a href="staffProd.jsp">Home</a></li>
                        <li><a href="addProdM.jsp">Add Products</a></li>
                        <li><a href="ControlProdM">Modify Products</a></li>
                        <li><a href="managePromo.jsp">Manage Promotions</a></li>
                        <li><a href="ordersStatus.jsp" class="active">Manage Orders</a></li>
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
            <!-- Orders Section -->
            <div class="section" id="orders">
                <h2>Order Management</h2>

                <!-- Message Display Section -->
                <%
                    String orderMessage = (String) session.getAttribute("message");
                    String orderError = (String) session.getAttribute("error");
                    if (orderMessage != null) {
                %>
                <div class="alert alert-success" style="background-color: #dff0d8; color: #3c763d; padding: 15px; margin-bottom: 20px; border-radius: 4px;">
                    <%= orderMessage%>
                </div>
                <%
                        session.removeAttribute("message");
                    }
                    if (orderError != null) {
                %>
                <div class="alert alert-danger" style="background-color: #f2dede; color: #a94442; padding: 15px; margin-bottom: 20px; border-radius: 4px;">
                    <%= orderError%>
                </div>
                <%
                        session.removeAttribute("error");
                    }
                %>

                <div class="order-filter" style="margin-bottom: 20px;">
                    <form method="get" action="ordersStatus.jsp">
                        <div style="display: flex; gap: 10px;">
                            <div style="flex: 1;">
                                <select name="statusFilter" class="form-control">
                                    <option value="all" <%= "all".equals(request.getParameter("statusFilter")) || request.getParameter("statusFilter") == null ? "selected" : ""%>>All Statuses</option>
                                    <option value="Pending" <%= "Pending".equals(request.getParameter("statusFilter")) ? "selected" : ""%>>Pending</option>
                                    <option value="Packaging" <%= "Packaging".equals(request.getParameter("statusFilter")) ? "selected" : ""%>>Packaging</option>
                                    <option value="Shipping" <%= "Shipping".equals(request.getParameter("statusFilter")) ? "selected" : ""%>>Shipping</option>
                                    <option value="Delivery" <%= "Delivery".equals(request.getParameter("statusFilter")) ? "selected" : ""%>>Delivery</option>
                                </select>
                            </div>
                            <button type="submit" class="btn">Filter</button>
                        </div>
                    </form>
                </div>

                <table>
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>Customer</th>
                            <th>Date</th>
                            <th>Total</th>
                            <th>Payment Method</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try {
                                DBConnection dbConn = new DBConnection();
                                Connection conn = dbConn.getConnection();

                                String statusFilter = request.getParameter("statusFilter");
                                String query = "SELECT o.*, c.customer_name FROM Orders o "
                                        + "JOIN Customers c ON o.customer_id = c.customer_id ";

                                if (statusFilter != null && !statusFilter.equals("all")) {
                                    query += "WHERE o.order_status = ? ";
                                }

                                query += "ORDER BY o.order_date DESC";

                                PreparedStatement pstmt = conn.prepareStatement(query);
                                if (statusFilter != null && !statusFilter.equals("all")) {
                                    pstmt.setString(1, statusFilter);
                                }

                                ResultSet rs = pstmt.executeQuery();

                                while (rs.next()) {
                                    String status = rs.getString("order_status");
                                    String statusClass;

                                    switch (status) {
                                        case "Pending":
                                            statusClass = "status-pending";
                                            break;
                                        case "Packaging":
                                            statusClass = "status-packaging";
                                            break;
                                        case "Shipping":
                                            statusClass = "status-shipping";
                                            break;
                                        case "Delivery":
                                            statusClass = "status-delivery";
                                            break;
                                        default:
                                            statusClass = "";
                                            break;
                                    }
                        %>
                        <tr>
                            <td><%= rs.getInt("order_id")%></td>
                            <td><%= rs.getString("customer_name")%></td>
                            <td><%= rs.getTimestamp("order_date")%></td>
                            <td>RM <%= String.format("%.2f", rs.getDouble("total_amount"))%></td>
                            <td><%= rs.getString("payment_method")%></td>
                            <td>
                                <span class="status-badge <%= statusClass%>"><%= status%></span>
                            </td>
                            <td>
                                <form action="ordersStatus.jsp" method="post" style="display: flex; gap: 5px;">
                                    <input type="hidden" name="action" value="updateOrderStatus">
                                    <input type="hidden" name="orderId" value="<%= rs.getInt("order_id")%>">
                                    <select name="orderStatus" class="status-dropdown">
                                        <option value="Pending" <%= "Pending".equals(status) ? "selected" : ""%>>Pending</option>
                                        <option value="Packaging" <%= "Packaging".equals(status) ? "selected" : ""%>>Packaging</option>
                                        <option value="Shipping" <%= "Shipping".equals(status) ? "selected" : ""%>>Shipping</option>
                                        <option value="Delivery" <%= "Delivery".equals(status) ? "selected" : ""%>>Delivery</option>
                                    </select>
                                    <button type="submit" class="btn btn-success">Update</button>
                                </form>
                                <a href="${pageContext.request.contextPath}/myStaff/viewOrderDetails.jsp?orderId=<%= rs.getInt("order_id")%>" 
                                   class="btn" style="margin-top: 10px;">View Details</a>
                            </td>
                        </tr>
                        <%
                                }

                                rs.close();
                                pstmt.close();
                                conn.close();
                            } catch (Exception e) {
                                out.println("<tr><td colspan='7'>Error: " + e.getMessage() + "</td></tr>");
                                e.printStackTrace();
                            }
                        %>
                    </tbody>
                </table>

                <!-- Order Details Modal -->
                <div id="orderDetailsModal" class="modal" style="display: none;">
                    <div class="modal-content">
                        <span class="close">&times;</span>
                        <h2>Order Details</h2>
                        <div id="orderDetailsContent"></div>
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
        
        <%
            // Process form submissions
            String action = request.getParameter("action");
            if (action != null) {
                try {
                    DBConnection dbConn = new DBConnection();
                    Connection conn = dbConn.getConnection();

                    if (action.equals("updateOrderStatus")) {
                        int orderId = Integer.parseInt(request.getParameter("orderId"));
                        String orderStatus = request.getParameter("orderStatus");

                        PreparedStatement pstmt = conn.prepareStatement("UPDATE Orders SET order_status = ? WHERE order_id = ?");
                        pstmt.setString(1, orderStatus);
                        pstmt.setInt(2, orderId);
                        pstmt.executeUpdate();
                        pstmt.close();

                        session.setAttribute("message", "Order status updated successfully!");
                        response.sendRedirect("ordersStatus.jsp");
                    }

                    conn.close();
                } catch (Exception e) {
                    session.setAttribute("error", "Error: " + e.getMessage());
                    response.sendRedirect("ordersStatus.jsp");
                }
            }
        %>
    </body>
</html> 