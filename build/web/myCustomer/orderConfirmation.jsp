<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.*" %>

<jsp:include page="/header.jsp">
    <jsp:param name="pageTitle" value="Order Confirmation"/>
</jsp:include>
<style>
    .card {
        border-radius: 10px;
        border: 2px solid;
        overflow: hidden;
        margin-bottom: 2rem;
        margin-top: 20px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
    }

    .card-header {
        padding: 1.5rem;
        border-bottom: none;
    }

    .card-header h3 {
        font-weight: 600;
        margin-bottom: 0;
    }

    .card-body {
        font-size: 18px;
        padding: 2rem;
    }

    .alert-success {
        background-color: #e8f5e9;
        border-color: #c8e6c9;
        color: #2e7d32;
        border-radius: 8px;
        padding: 1.25rem;
    }

    .alert-heading {
        font-weight: 600;
        color: #1b5e20;
        margin-bottom: 0.5rem;
    }

    .border-bottom {
        border-bottom: 1px solid #e0e0e0 !important;
        padding-bottom: 0.75rem;
        margin-bottom: 1.5rem;
    }

    .badge {
        font-weight: 500;
        padding: 0.35em 0.65em;
        font-size: 0.875em;
    }

    .bg-info {
        background-color: #FFC107 !important;
        border-radius: 6px;
        padding: 6px 12px;
        display: inline-block;
    }

    .bg-success {
        font-size: 25px;
        background: linear-gradient(to right, #FFC107, #FFDD00) !important;
    }

    .table {
        margin-bottom: 1.5rem;
    }

    .table th {
        font-weight: 600;
        background-color: #f8f9fa;
        border-bottom-width: 1px;
    }

    .table td, .table th {
        padding: 1rem;
        vertical-align: middle;
    }

    .table tfoot tr:last-child td {
        border-bottom: none;
    }

    .table-active {
        background-color: rgba(0, 0, 0, 0.03);
    }

    .text-end {
        text-align: right !important;
    }

    .btn {
        padding: 0.5rem 1.5rem;
        border-radius: 6px;
        font-weight: 500;
        transition: all 0.2s ease;
    }

    .btn-primary {
        display: inline-block;
        border: 2px solid black;
        margin-top: 10px;
        text-decoration: none;
        padding: 10px 20px;
        background: linear-gradient(to right, #FFC107, #FFE082);
        border-radius: 8px;
        cursor: pointer;
        font-size: 16px;
        font-weight: bold;
        transition: transform 0.2s ease, box-shadow 0.2s ease;
    }

    .btn-primary:hover {
        color: black;
        transform: scale(1.02);
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
        background: linear-gradient(to right, #FFB300, #FFD54F);
    }

    /* Responsive adjustments */
    @media (max-width: 768px) {
        .card-body {
            padding: 1.5rem;
        }

        .table td, .table th {
            padding: 0.75rem;
        }

        .d-flex {
            flex-direction: column;
            gap: 1rem;
        }

        .btn {
            width: 100%;
        }
    }

    /* Animation for the success icon */
    .fa-check-circle {
        animation: checkmark 0.6s ease-in-out;
    }

    /* Price highlighting */
    .text-danger {
        color: #dc3545 !important;
    }

    .text-success {
        color: #28a745 !important;
    }

    /* Shipping free badge */
    .badge.bg-success.ms-2 {
        margin-left: 0.5rem !important;
        font-size: 0.75rem;
        padding: 0.25em 0.5em;
    }

    /* Small text adjustments */
    small {
        font-size: 0.85em;
        opacity: 0.9;
    }
</style>
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
            cal.add(Calendar.DAY_OF_MONTH, 5 + (int) (Math.random() * 3)); // 5-7 days
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

        // Calculate subtotal (total - shipping + discount)
        subtotal = totalAmount - shippingFee + discountAmount;
%>

<div class="container my-5">
    <div class="row">
        <div class="col-lg-8 mx-auto">
            <!-- Order Confirmation Card -->
            <div class="card shadow-sm border-0">
                <div class="card-header bg-success text-white">
                    <h3 class="mb-0">Order Confirmed</h3>
                </div>

                <div class="card-body">
                    <!-- Success Message -->
                    <div class="alert alert-success">
                        <h4 class="alert-heading">Thank you for your order!</h4>
                        <p>Your order #<strong><%= orderId%></strong> has been placed successfully.</p>
                    </div>

                    <!-- Order Summary -->
                    <div class="mb-4">
                        <h5 class="border-bottom pb-2">Order Summary</h5>
                        <div class="row">
                            <div class="col-md-6">
                                <p><strong>Order Number:</strong> <%= orderId%></p>
                                <p><strong>Order Date:</strong> <%= formattedOrderDate%></p>
                                <p><strong>Order Status:</strong> <span class="badge bg-info"><%= orderStatus%></span></p>
                            </div>
                            <div class="col-md-6">
                                <p><strong>Payment Method:</strong> <%= displayPaymentMethod%></p>
                                <p><strong>Total Amount:</strong> RM <%= String.format("%.2f", totalAmount)%></p>
                                <p><strong>Estimated Delivery:</strong> <%= estimatedDelivery%></p>
                            </div>
                        </div>
                    </div>

                    <!-- Shipping Information -->
                    <div class="mb-4">
                        <h5 class="border-bottom pb-2">Shipping Information</h5>
                        <p><strong>Recipient:</strong> <%= fullName%></p>
                        <p><strong>Address:</strong> <%= shippingAddress%></p>
                        <p><strong>Contact:</strong> <%= contactNumber%></p>
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
                                        String itemsQuery = "SELECT od.product_id, od.quantity, od.price, p.PRODUCT_NAME "
                                                + "FROM Order_Details od "
                                                + "JOIN PRODUCTS p ON od.product_id = p.PRODUCT_ID "
                                                + "WHERE od.order_id = ?";
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
                                        <td><%= productName%></td>
                                        <td>RM <%= String.format("%.2f", price)%></td>
                                        <td><%= quantity%></td>
                                        <td>RM <%= String.format("%.2f", itemTotal)%></td>
                                    </tr>
                                    <%
                                        }
                                    %>
                                </tbody>
                                <tfoot>
                                    <tr>
                                        <td colspan="3" class="text-end"><strong>Subtotal:</strong></td>
                                        <td>RM <%= String.format("%.2f", subtotal)%></td>
                                    </tr>
                                    <% if (discountAmount > 0) {%>
                                    <tr>
                                        <td colspan="3" class="text-end">
                                            <strong>Discount:</strong>
                                        </td>
                                        <td class="text-danger">- RM <%= String.format("%.2f", discountAmount)%></td>
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
                                            <% }%>
                                        </td>
                                        <td>RM <%= String.format("%.2f", shippingFee)%></td>
                                    </tr>
                                    <tr class="table-active">
                                        <td colspan="3" class="text-end"><strong>Total:</strong></td>
                                        <td><strong>RM <%= String.format("%.2f", totalAmount)%></strong></td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="d-flex justify-content-between">
                        <a href="${pageContext.request.contextPath}/showProd" class="btn btn-primary">
                            Continue Shopping
                        </a>
                        <a href="${pageContext.request.contextPath}/myCustomer/orders.jsp" class="btn btn-primary">
                            View My Orders
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
            if (rs != null) {
                rs.close();
            }
            if (pstmt != null) {
                pstmt.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

<jsp:include page="/footer.jsp"/>