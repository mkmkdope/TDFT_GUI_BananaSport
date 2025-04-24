<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.sql.*" %>
<%@ page import="servlet.DBConnection" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.*" %>

<jsp:include page="/header.jsp">
    <jsp:param name="pageTitle" value="Order Confirmation"/>
</jsp:include>

<%
    // Get order ID from session
    Integer orderId = (Integer) session.getAttribute("lastOrderId");
    
    if (orderId == null) {
        // Redirect if no order ID found
        response.sendRedirect(request.getContextPath() + "/myCustomer/orders.jsp");
        return;
    }
    
    // Variables to store order information
    Timestamp orderDate = null;
    String orderStatus = "Pending";
    String paymentMethod = "";
    double totalAmount = 0.0;
    double subtotal = 0.0;
    double discountAmount = 0.0;
    double shippingFee = 0.0;
    String fullName = "";
    String shippingAddress = "";
    String contactNumber = "";
    
    // Database connection
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        DBConnection db = new DBConnection();
        conn = db.getConnection();
        
        // Get order information
        String orderQuery = "SELECT * FROM Orders WHERE order_id = ?";
        pstmt = conn.prepareStatement(orderQuery);
        pstmt.setInt(1, orderId);
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
            orderDate = rs.getTimestamp("order_date");
            orderStatus = rs.getString("order_status");
            paymentMethod = rs.getString("payment_method");
            totalAmount = rs.getDouble("total_amount");
            shippingFee = rs.getDouble("shipping_fee");
            fullName = rs.getString("full_name");
            shippingAddress = rs.getString("shipping_address");
            contactNumber = rs.getString("contact_number");
        } else {
            // Order not found
            response.sendRedirect(request.getContextPath() + "/myCustomer/orders.jsp");
            return;
        }
        
        // Calculate estimated delivery date (5-7 business days)
        Calendar cal = Calendar.getInstance();
        if (orderDate != null) {
            cal.setTime(orderDate);
            cal.add(Calendar.DAY_OF_MONTH, 5 + (int)(Math.random() * 3)); // 5-7 days
        }
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy");
        String estimatedDelivery = dateFormat.format(cal.getTime());
        
        // Format payment method for display
        String displayPaymentMethod = paymentMethod;
        if ("Card".equals(paymentMethod)) {
            displayPaymentMethod = "Credit/Debit Card";
        } else if ("E-wallet".equals(paymentMethod)) {
            displayPaymentMethod = "E-Wallet";
        } else if ("Online_Transfer".equals(paymentMethod)) {
            displayPaymentMethod = "Online Bank Transfer";
        } else if ("Cash".equals(paymentMethod)) {
            displayPaymentMethod = "Cash On Delivery";
        }
        
        // Format order date
        String formattedOrderDate = "";
        if (orderDate != null) {
            SimpleDateFormat orderDateFormat = new SimpleDateFormat("MMM dd, yyyy hh:mm a");
            formattedOrderDate = orderDateFormat.format(orderDate);
        }
        
        // Generate transaction ID (order ID + timestamp)
        String transactionId = "TRX-" + orderId + "-" + System.currentTimeMillis() % 10000;
        
        // Calculate subtotal (total - shipping + discount)
        subtotal = totalAmount - shippingFee + discountAmount;
%>

<div class="container my-5">
    <div class="row">
        <div class="col-lg-8 mx-auto">
            <!-- Order Confirmation Card -->
            <div class="card shadow-sm border-0">
                <div class="card-header bg-success text-white">
                    <h3 class="mb-0"><i class="fas fa-check-circle me-2"></i>Order Confirmed</h3>
                </div>
                
                <div class="card-body">
                    <!-- Success Message -->
                    <div class="alert alert-success">
                        <h4 class="alert-heading">Thank you for your order!</h4>
                        <p>Your order #<strong><%= orderId %></strong> has been placed successfully.</p>
                        <p>Transaction ID: <strong><%= transactionId %></strong></p>
                    </div>
                    
                    <!-- Order Summary -->
                    <div class="mb-4">
                        <h5 class="border-bottom pb-2">Order Summary</h5>
                        <div class="row">
                            <div class="col-md-6">
                                <p><strong>Order Number:</strong> <%= orderId %></p>
                                <p><strong>Order Date:</strong> <%= formattedOrderDate %></p>
                                <p><strong>Status:</strong> <span class="badge bg-info"><%= orderStatus %></span></p>
                            </div>
                            <div class="col-md-6">
                                <p><strong>Payment Method:</strong> <%= displayPaymentMethod %></p>
                                <p><strong>Total Amount:</strong> RM <%= String.format("%.2f", totalAmount) %></p>
                                <p><strong>Estimated Delivery:</strong> <%= estimatedDelivery %></p>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Shipping Information -->
                    <div class="mb-4">
                        <h5 class="border-bottom pb-2">Shipping Information</h5>
                        <p><strong>Recipient:</strong> <%= fullName %></p>
                        <p><strong>Address:</strong> <%= shippingAddress %></p>
                        <p><strong>Contact:</strong> <%= contactNumber %></p>
                    </div>
                    
                    <!-- Order Items -->
                    <div class="mb-4">
                        <h5 class="border-bottom pb-2">Order Items</h5>
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Product</th>
                                        <th>Price</th>
                                        <th>Quantity</th>
                                        <th>Total</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <%
                                    // Get order items
                                    String itemsQuery = "SELECT od.product_id, od.quantity, od.price, p.PRODUCT_NAME " +
                                                      "FROM Order_Details od " +
                                                      "JOIN PRODUCTS p ON od.product_id = p.PRODUCT_ID " +
                                                      "WHERE od.order_id = ?";
                                    pstmt = conn.prepareStatement(itemsQuery);
                                    pstmt.setInt(1, orderId);
                                    rs = pstmt.executeQuery();
                                    
                                    while (rs.next()) {
                                        String productName = rs.getString("PRODUCT_NAME");
                                        int quantity = rs.getInt("quantity");
                                        double price = rs.getDouble("price");
                                        double itemTotal = price * quantity;
                                %>
                                    <tr>
                                        <td><%= productName %></td>
                                        <td>RM <%= String.format("%.2f", price) %></td>
                                        <td><%= quantity %></td>
                                        <td>RM <%= String.format("%.2f", itemTotal) %></td>
                                    </tr>
                                <%
                                    }
                                %>
                                </tbody>
                                <tfoot>
                                    <tr>
                                        <td colspan="3" class="text-end"><strong>Subtotal:</strong></td>
                                        <td>RM <%= String.format("%.2f", subtotal) %></td>
                                    </tr>
                                    <% if (discountAmount > 0) { %>
                                    <tr>
                                        <td colspan="3" class="text-end">
                                            <strong>Discount:</strong>
                                        </td>
                                        <td class="text-danger">- RM <%= String.format("%.2f", discountAmount) %></td>
                                    </tr>
                                    <% } %>
                                    <tr>
                                        <td colspan="3" class="text-end">
                                            <strong>Shipping Fee:</strong>
                                            <% if (shippingFee == 0) { %>
                                                <span class="badge bg-success ms-2">FREE</span>
                                                <% if (subtotal >= 1000) { %>
                                                <small class="text-success">(Order over RM 1000)</small>
                                                <% } %>
                                            <% } %>
                                        </td>
                                        <td>RM <%= String.format("%.2f", shippingFee) %></td>
                                    </tr>
                                    <tr class="table-active">
                                        <td colspan="3" class="text-end"><strong>Total:</strong></td>
                                        <td><strong>RM <%= String.format("%.2f", totalAmount) %></strong></td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>
                    
                    <!-- Next Steps -->
                    <div class="alert alert-info">
                        <h5 class="alert-heading">What's Next?</h5>
                        <ul class="mb-0">
                            <li>You will receive an order confirmation email shortly</li>
                            <li>We'll notify you when your order ships</li>
                            <li>Estimated delivery: <%= estimatedDelivery %></li>
                        </ul>
                    </div>
                    
                    <!-- Action Buttons -->
                    <div class="d-flex justify-content-between">
                        <a href="${pageContext.request.contextPath}/showProd" class="btn btn-outline-primary">
                            <i class="fas fa-shopping-bag me-2"></i>Continue Shopping
                        </a>
                        <a href="${pageContext.request.contextPath}/myCustomer/orders.jsp" class="btn btn-primary">
                            <i class="fas fa-clipboard-list me-2"></i>View My Orders
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

<jsp:include page="/footer.jsp"/>