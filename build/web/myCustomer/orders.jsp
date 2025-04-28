<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DecimalFormat" %>

<%
    // Check if user is logged in
    if (session.getAttribute("loggedIn") == null || !(Boolean) session.getAttribute("loggedIn")) {
        response.sendRedirect(request.getContextPath() + "/myCustomer/loginC.jsp");
        return;
    }

    // Get user info from session
    Integer customerId = (Integer) session.getAttribute("customerId");

    // Formatters
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    DecimalFormat priceFormat = new DecimalFormat("###,##0.00");
%>

<jsp:include page="/header.jsp">
    <jsp:param name="pageTitle" value="My Orders"/>
</jsp:include>

<div class="container" style="max-width: 1200px; margin: 30px auto; padding: 20px; background-color: white; border-radius: 5px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
    <h1 style="color: #333; margin-bottom: 30px; text-align: center;">My Orders</h1>

    <%
        // Database connection
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // Get database connection
            DBConnection db = new DBConnection();
            conn = db.getConnection();

            // Get orders for this customer
            String sql = "SELECT o.order_id, o.order_date, o.total_amount, o.payment_method, o.shipping_fee, "
                    + "o.order_status, o.shipping_address, o.full_name, o.contact_number, o.order_notes "
                    + "FROM Orders o "
                    + "WHERE o.customer_id = ? "
                    + "ORDER BY o.order_date DESC";

            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, customerId);
            rs = pstmt.executeQuery();

            boolean hasOrders = false;

            while (rs.next()) {
                hasOrders = true;
                int orderId = rs.getInt("order_id");
                Timestamp orderDate = rs.getTimestamp("order_date");
                double totalAmount = rs.getDouble("total_amount");
                String paymentMethod = rs.getString("payment_method");
                double shippingFee = rs.getDouble("shipping_fee");
                String orderStatus = rs.getString("order_status");
                String shippingAddress = rs.getString("shipping_address");
                String fullName = rs.getString("full_name");
                String contactNumber = rs.getString("contact_number");
                String orderNotes = rs.getString("order_notes");

                // Start order card
%>
    <div class="order-card" style="margin-bottom: 30px; border: 1px solid #ddd; border-radius: 5px; overflow: hidden;">
        <div class="order-header" style="background-color: #f5f5f5; padding: 15px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap;">
            <div>
                <h3 style="margin: 0; color: #333;">Order #<%= orderId%></h3>
                <p style="margin: 5px 0 0 0; color: #666;">Date: <%= dateFormat.format(orderDate)%></p>
            </div>
            <div>
                <span style="background-color: #FFC107; padding: 5px 10px; border-radius: 3px; font-weight: bold;">
                    <%= orderStatus%> | <%= paymentMethod%>
                </span>
            </div>
        </div>

        <div class="order-items" style="padding: 0 15px;">
            <table style="width: 100%; border-collapse: collapse; margin: 15px 0;">
                <thead>
                    <tr style="border-bottom: 1px solid #ddd;">
                        <th style="text-align: left; padding: 10px;">Product</th>
                        <th style="text-align: center; padding: 10px;">Quantity</th>
                        <th style="text-align: right; padding: 10px;">Price</th>
                        <th style="text-align: right; padding: 10px;">Total</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        // Get order details
                        PreparedStatement detailsStmt = null;
                        ResultSet detailsRs = null;

                        try {
                            String detailsSQL = "SELECT od.product_id, p.PRODUCT_NAME, od.quantity, od.price "
                                    + "FROM Order_Details od "
                                    + "JOIN PRODUCTS p ON od.product_id = p.PRODUCT_ID "
                                    + "WHERE od.order_id = ?";

                            detailsStmt = conn.prepareStatement(detailsSQL);
                            detailsStmt.setInt(1, orderId);
                            detailsRs = detailsStmt.executeQuery();

                            while (detailsRs.next()) {
                                String productId = detailsRs.getString("product_id");
                                String productName = detailsRs.getString("PRODUCT_NAME");
                                int quantity = detailsRs.getInt("quantity");
                                double price = detailsRs.getDouble("price");
                                double itemTotal = price * quantity;
                    %>
                    <tr style="border-bottom: 1px solid #eee;">
                        <td style="padding: 10px;"><%= productName%></td>
                        <td style="text-align: center; padding: 10px;"><%= quantity%></td>
                        <td style="text-align: right; padding: 10px;">RM <%= priceFormat.format(price)%></td>
                        <td style="text-align: right; padding: 10px;">RM <%= priceFormat.format(itemTotal)%></td>
                    </tr>
                    <%
                            }
                        } finally {
                            if (detailsRs != null) {
                                detailsRs.close();
                            }
                            if (detailsStmt != null) {
                                detailsStmt.close();
                            }
                        }
                    %>
                </tbody>
                <tfoot>
                    <tr style="border-top: 2px solid #ddd;">
                        <td colspan="3" style="text-align: right; padding: 10px;"><strong>Shipping Fee:</strong></td>
                        <td style="text-align: right; padding: 10px;">RM <%= priceFormat.format(shippingFee)%></td>
                    </tr>
                    <tr>
                        <td colspan="3" style="text-align: right; padding: 10px;"><strong>Total:</strong></td>
                        <td style="text-align: right; padding: 10px; font-weight: bold; font-size: 1.1em;">RM <%= priceFormat.format(totalAmount)%></td>
                    </tr>
                </tfoot>
            </table>
        </div>

        <% if (orderNotes != null && !orderNotes.trim().isEmpty()) {%>
        <div class="order-notes" style="padding: 15px; background-color: #fffbea; border-top: 1px solid #f5e8c1;">
            <h4 style="margin-top: 0; margin-bottom: 8px; color: #856404;">Order Notes & Promotions</h4>
            <p style="margin: 0; white-space: pre-line; color: #5d4a1d;"><%= orderNotes%></p>
        </div>
        <% } %>

    </div>
    <%
        }

        if (!hasOrders) {
    %>
    <div style="text-align: center; padding: 50px 20px; background-color: #f9f9f9; border-radius: 5px;">
        <img src="https://cdn-icons-png.flaticon.com/512/9018/9018889.png" alt="Empty Cart" style="width: 150px; height: auto; margin-bottom: 20px;">
        <h3 style="color: #212121; margin-bottom: 20px;">No Order Record Available</h3>
        <a href="${pageContext.request.contextPath}/showProd" style="display: inline-block; margin-top: 10px; text-decoration: none; padding: 10px 20px; background: linear-gradient(to right, #FFC107, #FFE082); color: #212121;border-radius: 8px; cursor: pointer; font-size: 14px; font-weight: bold; transition: transform 0.2s ease, box-shadow 0.2s ease;" 
           onmouseover="this.style.transform = 'scale(1.05)'; this.style.boxShadow = '0 4px 10px rgba(0, 0, 0, 0.2)'; this.style.background = 'linear-gradient(to right, #FFB300, #FFD54F)';" onmouseout="this.style.transform = ''; this.style.boxShadow = ''; this.style.background = 'linear-gradient(to right, #FFC107, #FFE082)';">
            Start Shopping
        </a>
    </div>
    <%
        }

    } catch (SQLException e) {
        e.printStackTrace();
    %>
    <div class="alert alert-danger" style="background-color: #f8d7da; color: #721c24; padding: 10px; border-radius: 4px; margin-bottom: 20px;">
        Error retrieving orders: <%= e.getMessage()%>
    </div>
    <%
        } finally {
            // Close resources
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
</div>

<jsp:include page="/footer.jsp" /> 