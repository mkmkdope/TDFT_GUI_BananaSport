<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.sql.*" %>
<%@ page import="servlet.DBConnection" %>

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
        <style>
            .section {
                padding: 20px;
                border: 1px solid #ddd;
                border-radius: 5px;
                margin-bottom: 30px;
            }
            .hidden {
                display: none;
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
                background-color: #f2f2f2;
            }
            .form-group {
                margin-bottom: 15px;
            }
            label {
                display: block;
                margin-bottom: 5px;
                font-weight: bold;
            }
            input, select, textarea {
                width: 100%;
                padding: 8px;
                border: 1px solid #ddd;
                border-radius: 4px;
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
                background-color: #28a745;
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
                    <% if (session.getAttribute("isManager") != null && (Boolean)session.getAttribute("isManager")) { %>
                    <a href="${pageContext.request.contextPath}/AdminModule.jsp">Switch to<br> Admin</a>
                    <% } %>
                    <div class="logo-container">
                        <img src="${pageContext.request.contextPath}/images/logo.jpg" alt="${applicationScope.companyName} Logo" class="logo"> 
                    </div><h2>Staff Dashboard</h2>
                    <ul class="nav-links" id="navLinks">
                        <li><a href="controlPanelM.jsp">Home</a></li>
                        <li><a href="addProdM.jsp">Add Products</a></li>
                        <li><a href="ControlProdM">Modify Products</a></li>
                        <li><a href="controlPanelM.jsp?section=promotions">Manage Promotions</a></li>
                        <li><a href="controlPanelM.jsp?section=orders">Manage Orders</a></li>
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
            <div class="section <%= "promotions".equals(request.getParameter("section")) ? "" : "hidden" %>" id="promotions">
                <h2>Promotion Management</h2>

                <%
                    // Process form submissions
                    String action = request.getParameter("action");
                    if (action != null) {
                        try {
                            // Use the DBConnection class instead of JNDI
                            DBConnection dbConn = new DBConnection();
                            Connection conn = dbConn.getConnection();

                            if (action.equals("add")) {
                                String promotionName = request.getParameter("promotionName");
                                String promotionType = request.getParameter("promotionType");
                                double discountValue = Double.parseDouble(request.getParameter("discountValue"));
                                double minPurchaseAmount = Double.parseDouble(request.getParameter("minPurchaseAmount"));
                                String applicableTo = request.getParameter("applicableTo");
                                String description = request.getParameter("description");

                                // Prepare SQL
                                String insertSQL = "INSERT INTO Promotions (promotion_name, promotion_type, discount_value, min_purchase_amount, "
                                        + "applicable_to, is_active, description) "
                                        + "VALUES (?, ?, ?, ?, ?, TRUE, ?)";
                                PreparedStatement pstmt = conn.prepareStatement(insertSQL);
                                pstmt.setString(1, promotionName);
                                pstmt.setString(2, promotionType);
                                pstmt.setDouble(3, discountValue);
                                pstmt.setDouble(4, minPurchaseAmount);
                                pstmt.setString(5, applicableTo);
                                pstmt.setString(6, description);

                                pstmt.executeUpdate();
                                pstmt.close();

                                out.println("<div style='color:green;'>Promotion added successfully!</div>");
                            } else if (action.equals("update")) {
                                int promotionId = Integer.parseInt(request.getParameter("promotionId"));
                                String promotionName = request.getParameter("promotionName");
                                String promotionType = request.getParameter("promotionType");
                                double discountValue = Double.parseDouble(request.getParameter("discountValue"));
                                double minPurchaseAmount = Double.parseDouble(request.getParameter("minPurchaseAmount"));
                                String applicableTo = request.getParameter("applicableTo");
                                boolean isActive = "on".equals(request.getParameter("isActive"));
                                String description = request.getParameter("description");

                                // Prepare SQL
                                String updateSQL = "UPDATE Promotions SET promotion_name = ?, promotion_type = ?, discount_value = ?, "
                                        + "min_purchase_amount = ?, applicable_to = ?, is_active = ?, description = ? "
                                        + "WHERE promotion_id = ?";
                                PreparedStatement pstmt = conn.prepareStatement(updateSQL);
                                pstmt.setString(1, promotionName);
                                pstmt.setString(2, promotionType);
                                pstmt.setDouble(3, discountValue);
                                pstmt.setDouble(4, minPurchaseAmount);
                                pstmt.setString(5, applicableTo);
                                pstmt.setBoolean(6, isActive);
                                pstmt.setString(7, description);
                                pstmt.setInt(8, promotionId);

                                pstmt.executeUpdate();
                                pstmt.close();

                                out.println("<div style='color:green;'>Promotion updated successfully!</div>");
                            } else if (action.equals("delete")) {
                                int promotionId = Integer.parseInt(request.getParameter("promotionId"));

                                PreparedStatement pstmt = conn.prepareStatement("DELETE FROM Promotions WHERE promotion_id = ?");
                                pstmt.setInt(1, promotionId);
                                pstmt.executeUpdate();
                                pstmt.close();

                                out.println("<div style='color:green;'>Promotion deleted successfully!</div>");
                            } else if (action.equals("updateOrderStatus")) {
                                int orderId = Integer.parseInt(request.getParameter("orderId"));
                                String orderStatus = request.getParameter("orderStatus");

                                PreparedStatement pstmt = conn.prepareStatement("UPDATE Orders SET order_status = ? WHERE order_id = ?");
                                pstmt.setString(1, orderStatus);
                                pstmt.setInt(2, orderId);
                                pstmt.executeUpdate();
                                pstmt.close();

                                out.println("<div style='color:green;'>Order status updated successfully!</div>");
                            }

                            conn.close();
                        } catch (Exception e) {
                            out.println("<div style='color:red;'>Error: " + e.getMessage() + "</div>");
                            e.printStackTrace();
                        }
                    }

                    // Edit form display
                    String editId = request.getParameter("edit");
                    if (editId != null) {
                        try {
                            // Use the DBConnection class instead of JNDI
                            DBConnection dbConn = new DBConnection();
                            Connection conn = dbConn.getConnection();

                            PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM Promotions WHERE promotion_id = ?");
                            pstmt.setInt(1, Integer.parseInt(editId));
                            ResultSet rs = pstmt.executeQuery();

                            if (rs.next()) {
                %>
                <h3>Edit Promotion</h3>
                <form action="controlPanelM.jsp?section=promotions" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="promotionId" value="<%= rs.getInt("promotion_id")%>">

                    <div class="form-group">
                        <label for="promotionName">Promotion Name</label>
                        <input type="text" id="promotionName" name="promotionName" value="<%= rs.getString("promotion_name")%>" required>
                    </div>

                    <div class="form-group">
                        <label for="promotionType">Promotion Type</label>
                        <select id="promotionType" name="promotionType" required>
                            <option value="percentage" <%= "percentage".equals(rs.getString("promotion_type")) ? "selected" : ""%>>Percentage Discount</option>
                            <option value="fixed_amount" <%= "fixed_amount".equals(rs.getString("promotion_type")) ? "selected" : ""%>>Fixed Amount</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="discountValue">Discount Value</label>
                        <input type="number" id="discountValue" name="discountValue" step="0.01" value="<%= rs.getDouble("discount_value")%>" required>
                    </div>

                    <div class="form-group">
                        <label for="minPurchaseAmount">Minimum Purchase Amount</label>
                        <input type="number" id="minPurchaseAmount" name="minPurchaseAmount" step="0.01" value="<%= rs.getDouble("min_purchase_amount")%>" required>
                    </div>

                    <div class="form-group">
                        <label for="applicableTo">Applicable To</label>
                        <input type="text" id="applicableTo" name="applicableTo" value="<%= rs.getString("applicable_to")%>" required>
                    </div>

                    <div class="form-group">
                        <label for="isActive">Active</label>
                        <input type="checkbox" id="isActive" name="isActive" <%= rs.getBoolean("is_active") ? "checked" : ""%>>
                    </div>

                    <div class="form-group">
                        <label for="description">Description</label>
                        <textarea id="description" name="description" rows="3"><%= rs.getString("description") != null ? rs.getString("description") : ""%></textarea>
                    </div>

                    <button type="submit" class="btn">Update Promotion</button>
                    <a href="controlPanelM.jsp?section=promotions" class="btn btn-warning">Cancel</a>
                </form>
                <%
                        }

                        rs.close();
                        pstmt.close();
                        conn.close();
                    } catch (Exception e) {
                        out.println("<div style='color:red;'>Error: " + e.getMessage() + "</div>");
                        e.printStackTrace();
                    }
                } else {
                %>

                <h3>Add New Promotion</h3>
                <form action="controlPanelM.jsp?section=promotions" method="post">
                    <input type="hidden" name="action" value="add">

                    <div class="form-group">
                        <label for="promotionName">Promotion Name</label>
                        <input type="text" id="promotionName" name="promotionName" required>
                    </div>

                    <div class="form-group">
                        <label for="promotionType">Promotion Type</label>
                        <select id="promotionType" name="promotionType" required>
                            <option value="percentage">Percentage Discount</option>
                            <option value="fixed_amount">Fixed Amount</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="discountValue">Discount Value</label>
                        <input type="number" id="discountValue" name="discountValue" step="0.01" required>
                    </div>

                    <div class="form-group">
                        <label for="minPurchaseAmount">Minimum Purchase Amount</label>
                        <input type="number" id="minPurchaseAmount" name="minPurchaseAmount" step="0.01" value="0.00" required>
                    </div>

                    <div class="form-group">
                        <label for="applicableTo">Applicable To</label>
                        <input type="text" id="applicableTo" name="applicableTo" value="all" required>
                        <small>Enter "all" for all products or a specific category name</small>
                    </div>

                    <div class="form-group">
                        <label for="description">Description</label>
                        <textarea id="description" name="description" rows="3"></textarea>
                    </div>

                    <button type="submit" class="btn">Add Promotion</button>
                </form>

                <h3>Current Promotions</h3>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Type</th>
                            <th>Value</th>
                            <th>Min Purchase</th>
                            <th>Applicable To</th>
                            <th>Active</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try {
                                // Use the DBConnection class instead of JNDI
                                DBConnection dbConn = new DBConnection();
                                Connection conn = dbConn.getConnection();

                                Statement stmt = conn.createStatement();
                                ResultSet rs = stmt.executeQuery("SELECT * FROM Promotions ORDER BY promotion_id DESC");

                                while (rs.next()) {
                        %>
                        <tr>
                            <td><%= rs.getInt("promotion_id")%></td>
                            <td><%= rs.getString("promotion_name")%></td>
                            <td><%= rs.getString("promotion_type")%></td>
                            <td><%= rs.getDouble("discount_value")%></td>
                            <td><%= rs.getDouble("min_purchase_amount")%></td>
                            <td><%= rs.getString("applicable_to")%></td>
                            <td><%= rs.getBoolean("is_active") ? "Yes" : "No"%></td>
                            <td>
                                <a href="controlPanelM.jsp?section=promotions&edit=<%= rs.getInt("promotion_id")%>" class="btn btn-warning">Edit</a>
                                <a href="controlPanelM.jsp?section=promotions&action=delete&promotionId=<%= rs.getInt("promotion_id")%>" 
                                   class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this promotion?')">Delete</a>
                            </td>
                        </tr>
                        <%
                                }

                                rs.close();
                                stmt.close();
                                conn.close();
                            } catch (Exception e) {
                                out.println("<tr><td colspan='8'>Error: " + e.getMessage() + "</td></tr>");
                                e.printStackTrace();
                            }
                        %>
                    </tbody>
                </table>
                <% }%>
            </div>

            <!-- Orders Section -->
            <div class="section <%= "orders".equals(request.getParameter("section")) ? "" : "hidden" %>" id="orders">
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
                    <form method="get" action="controlPanelM.jsp">
                        <input type="hidden" name="section" value="orders">
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
                                <form action="controlPanelM.jsp?section=orders" method="post" style="display: flex; gap: 5px;">
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
    </body>
</html> 