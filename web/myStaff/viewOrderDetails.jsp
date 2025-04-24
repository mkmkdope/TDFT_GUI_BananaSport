<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="servlet.DBConnection" %>
<%@ page import="java.text.DecimalFormat" %>

<%
    // Check if user is logged in as staff or manager
    if (session.getAttribute("loggedIn") == null || 
        !(Boolean) session.getAttribute("loggedIn") || 
        (session.getAttribute("isStaff") == null && session.getAttribute("isManager") == null)) {
        
        session.setAttribute("error", "Please login to view order details");
        response.sendRedirect(request.getContextPath() + "/myStaff/loginM.jsp");
        return;
    }

    // Get order ID parameter
    String orderIdParam = request.getParameter("orderId");
    if (orderIdParam == null || orderIdParam.isEmpty()) {
        session.setAttribute("error", "Order ID is required");
        response.sendRedirect(request.getContextPath() + "/myStaff/controlPanelM.jsp?tab=orders");
        return;
    }
    
    int orderId;
    try {
        orderId = Integer.parseInt(orderIdParam);
    } catch (NumberFormatException e) {
        session.setAttribute("error", "Invalid order ID format");
        response.sendRedirect(request.getContextPath() + "/myStaff/controlPanelM.jsp?tab=orders");
        return;
    }
    
    // Format for currency
    DecimalFormat priceFormat = new DecimalFormat("###,##0.00");
    
    // Variables to store order information
    String customerName = "";
    String fullName = "";
    String shippingAddress = "";
    String contactNumber = "";
    String paymentMethod = "";
    String orderStatus = "";
    Timestamp orderDate = null;
    double totalAmount = 0.0;
    double shippingFee = 0.0;
    double salesTax = 0.0;
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Details #<%= orderId %></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        .card {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 25px;
            margin-bottom: 30px;
        }
        .section-title {
            color: #333;
            margin-bottom: 20px;
            border-bottom: 2px solid #FFC107;
            padding-bottom: 10px;
        }
        .info-group {
            margin-bottom: 15px;
        }
        .info-label {
            font-weight: bold;
            color: #555;
        }
        .info-value {
            margin-top: 5px;
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
        .btn {
            padding: 8px 15px;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            margin-right: 10px;
        }
        .btn-primary {
            background-color: #007bff;
        }
        .btn-warning {
            background-color: #ffc107;
            color: #212529;
        }
        .btn-success {
            background-color: #28a745;
        }
    </style>
</head>
<body>
    <header>
        <div class="container">
            <nav class="navbar">
                <div class="logo-container">
                    <img src="${pageContext.request.contextPath}/images/logo.jpg" alt="Logo" class="logo">
                </div>
                <ul class="nav-links">
                    <li><a href="${pageContext.request.contextPath}/index.jsp">Back to Main</a></li>
                    <li><a href="controlPanelM.jsp">Home</a></li>
                    <li><a href="controlPanelM.jsp?tab=orders">All Orders</a></li>
                </ul>
            </nav>
        </div>
    </header>

    <main class="container">
        <%
            try {
                // Get database connection
                DBConnection dbConn = new DBConnection();
                conn = dbConn.getConnection();
                
                // Get order information
                String orderQuery = "SELECT o.*, c.customer_name FROM Orders o " +
                                  "JOIN Customers c ON o.customer_id = c.customer_id " +
                                  "WHERE o.order_id = ?";
                pstmt = conn.prepareStatement(orderQuery);
                pstmt.setInt(1, orderId);
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    customerName = rs.getString("customer_name");
                    fullName = rs.getString("full_name");
                    shippingAddress = rs.getString("shipping_address");
                    contactNumber = rs.getString("contact_number");
                    paymentMethod = rs.getString("payment_method");
                    orderStatus = rs.getString("order_status");
                    orderDate = rs.getTimestamp("order_date");
                    totalAmount = rs.getDouble("total_amount");
                    shippingFee = rs.getDouble("shipping_fee");
                    salesTax = rs.getDouble("sales_tax");
                    
                    // Determine status class
                    String statusClass = "";
                    switch (orderStatus) {
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
                    }
        %>
        <div class="card">
            <h2 class="section-title">Order #<%= orderId %> <span class="status-badge <%= statusClass %>"><%= orderStatus %></span></h2>
            
            <div class="row" style="display: flex; flex-wrap: wrap; margin: -10px;">
                <div class="col" style="flex: 1; min-width: 300px; padding: 10px;">
                    <h3>Order Information</h3>
                    
                    <div class="info-group">
                        <div class="info-label">Order Date:</div>
                        <div class="info-value"><%= orderDate %></div>
                    </div>
                    
                    <div class="info-group">
                        <div class="info-label">Payment Method:</div>
                        <div class="info-value"><%= paymentMethod %></div>
                    </div>
                    
                    <div class="info-group">
                        <div class="info-label">Total Amount:</div>
                        <div class="info-value">RM <%= priceFormat.format(totalAmount) %></div>
                    </div>
                    
                    <div class="info-group">
                        <div class="info-label">Status:</div>
                        <div class="info-value">
                            <form action="controlPanelM.jsp?tab=orders" method="post" style="display: flex; gap: 5px; margin-top: 10px;">
                                <input type="hidden" name="action" value="updateOrderStatus">
                                <input type="hidden" name="orderId" value="<%= orderId %>">
                                <select name="orderStatus" class="form-control" style="flex: 1;">
                                    <option value="Pending" <%= "Pending".equals(orderStatus) ? "selected" : "" %>>Pending</option>
                                    <option value="Packaging" <%= "Packaging".equals(orderStatus) ? "selected" : "" %>>Packaging</option>
                                    <option value="Shipping" <%= "Shipping".equals(orderStatus) ? "selected" : "" %>>Shipping</option>
                                    <option value="Delivery" <%= "Delivery".equals(orderStatus) ? "selected" : "" %>>Delivery</option>
                                </select>
                                <button type="submit" class="btn btn-success">Update Status</button>
                            </form>
                        </div>
                    </div>
                </div>
                
                <div class="col" style="flex: 1; min-width: 300px; padding: 10px;">
                    <h3>Customer Information</h3>
                    
                    <div class="info-group">
                        <div class="info-label">Customer Name:</div>
                        <div class="info-value"><%= customerName %></div>
                    </div>
                    
                    <div class="info-group">
                        <div class="info-label">Recipient Name:</div>
                        <div class="info-value"><%= fullName %></div>
                    </div>
                    
                    <div class="info-group">
                        <div class="info-label">Contact Number:</div>
                        <div class="info-value"><%= contactNumber %></div>
                    </div>
                    
                    <div class="info-group">
                        <div class="info-label">Shipping Address:</div>
                        <div class="info-value"><%= shippingAddress %></div>
                    </div>
                </div>
            </div>
            
            <h3 class="section-title">Order Items</h3>
            
            <table>
                <thead>
                    <tr>
                        <th>Product Name</th>
                        <th>Quantity</th>
                        <th>Unit Price</th>
                        <th>Total</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        // Close previous resources to avoid conflicts
                        rs.close();
                        pstmt.close();
                        
                        // Get order items
                        String itemsQuery = "SELECT oi.*, p.PRODUCT_NAME, p.PRODUCT_PRICE " +
                                          "FROM Order_Items oi " +
                                          "JOIN PRODUCTS p ON oi.product_id = p.PRODUCT_ID " +
                                          "WHERE oi.order_id = ?";
                        pstmt = conn.prepareStatement(itemsQuery);
                        pstmt.setInt(1, orderId);
                        rs = pstmt.executeQuery();
                        
                        double subtotal = 0.0;
                        
                        while (rs.next()) {
                            String productName = rs.getString("PRODUCT_NAME");
                            int quantity = rs.getInt("quantity");
                            double unitPrice = rs.getDouble("unit_price");
                            double itemTotal = quantity * unitPrice;
                            subtotal += itemTotal;
                    %>
                    <tr>
                        <td><%= productName %></td>
                        <td><%= quantity %></td>
                        <td>RM <%= priceFormat.format(unitPrice) %></td>
                        <td>RM <%= priceFormat.format(itemTotal) %></td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="3" style="text-align: right;"><strong>Subtotal:</strong></td>
                        <td>RM <%= priceFormat.format(subtotal) %></td>
                    </tr>
                    <tr>
                        <td colspan="3" style="text-align: right;"><strong>Shipping Fee:</strong></td>
                        <td>RM <%= priceFormat.format(shippingFee) %></td>
                    </tr>
                    <tr>
                        <td colspan="3" style="text-align: right;"><strong>Sales Tax:</strong></td>
                        <td>RM <%= priceFormat.format(salesTax) %></td>
                    </tr>
                    <tr>
                        <td colspan="3" style="text-align: right;"><strong>Total:</strong></td>
                        <td><strong>RM <%= priceFormat.format(totalAmount) %></strong></td>
                    </tr>
                </tfoot>
            </table>
            
            <div style="margin-top: 20px;">
                <a href="controlPanelM.jsp?tab=orders" class="btn btn-primary">Back to Orders</a>
                <button onclick="window.print()" class="btn btn-warning"><i class="fas fa-print"></i> Print Order</button>
            </div>
        </div>
        <%
                } else {
        %>
        <div class="card">
            <h2 class="section-title">Order Not Found</h2>
            <p>The requested order (#<%= orderId %>) could not be found.</p>
            <a href="controlPanelM.jsp?tab=orders" class="btn btn-primary">Back to Orders</a>
        </div>
        <%
                }
            } catch (SQLException e) {
                e.printStackTrace();
        %>
        <div class="card">
            <h2 class="section-title">Error</h2>
            <p>An error occurred while retrieving order information: <%= e.getMessage() %></p>
            <a href="controlPanelM.jsp?tab=orders" class="btn btn-primary">Back to Orders</a>
        </div>
        <%
            } finally {
                // Close resources
                try {
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        %>
    </main>
    
    <footer style="background-color: #212121; color: white; padding: 20px 0; margin-top: 40px; text-align: center;">
        <div class="container">
            <p>&copy; <%= new java.util.Date().getYear() + 1900 %> All Rights Reserved.</p>
        </div>
    </footer>
</body>
</html> 