<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<%@ page import="java.text.DecimalFormat" %>

<%
    // Check if user is logged in
    if (session.getAttribute("loggedIn") == null || !(Boolean) session.getAttribute("loggedIn")) {
        session.setAttribute("error", "Please login to proceed with payment");
        response.sendRedirect(request.getContextPath() + "/myCustomer/loginC.jsp");
        return;
    }

    // Get current customer ID from session
    Integer customerId = (Integer) session.getAttribute("customerId");
    String customerName = (String) session.getAttribute("customerName");
    
    // Format for currency
    DecimalFormat priceFormat = new DecimalFormat("###,##0.00");
    
    // Variables to store cart information
    double subtotal = 0.0;
    double shippingFee = 25.00; // Default shipping fee
    double discountAmount = 0.0;
    double total = 0.0;
    int totalItems = 0;
    boolean hasItems = false;
    
    // Get promotion information from request parameters or session
    String subtotalParam = request.getParameter("subtotal");
    String discountParam = request.getParameter("discount");
    String totalParam = request.getParameter("total");
    String freeShippingParam = request.getParameter("freeShipping");
    
    if (subtotalParam != null && discountParam != null && totalParam != null) {
        subtotal = Double.parseDouble(subtotalParam);
        discountAmount = Double.parseDouble(discountParam);
        total = Double.parseDouble(totalParam);
        
        // Calculate shipping fee based on total amount
        boolean freeShipping = "true".equals(freeShippingParam);
        if (!freeShipping) {
            // Apply free shipping for orders of RM 1000 and above, and RM 25 for orders below RM 1000
            shippingFee = (subtotal >= 1000) ? 0.0 : 25.0;
        }
        
        // Calculate 6% sales tax on subtotal
        double salesTax = subtotal * 0.06;
        
        // Recalculate final total with shipping fee and sales tax
        total = subtotal - discountAmount + shippingFee + salesTax;
    }
    
    // Get promotion details from session if available
    Integer appliedPromotionId = (Integer) session.getAttribute("appliedPromotionId");
    String appliedPromotionName = (String) session.getAttribute("appliedPromotionName");
    String appliedPromotionType = (String) session.getAttribute("appliedPromotionType");
%>

<jsp:include page="/header.jsp">
    <jsp:param name="pageTitle" value="Payment"/>
</jsp:include>

<div class="container">
    <div class="row" style="margin: 30px auto; max-width: 1200px;">
        <!-- Left Column - Payment Form -->
        <div class="col-md-8" style="float: left; width: 65%; padding-right: 30px;">
            <div class="card" style="background-color: white; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); padding: 25px; margin-bottom: 30px;">
                <h2 style="color: #333; margin-bottom: 25px; border-bottom: 2px solid #FFC107; padding-bottom: 10px;">Payment Information</h2>
                
                <!-- Message Display Section -->
                <%
                    String message = (String) session.getAttribute("message");
                    String error = (String) session.getAttribute("error");
                    if (message != null) {
                %>
                <div class="alert alert-success" style="background-color: #dff0d8; color: #3c763d; padding: 15px; margin-bottom: 20px; border-radius: 4px;">
                    <%= message %>
                </div>
                <%
                        session.removeAttribute("message");
                    }
                    if (error != null) {
                %>
                <div class="alert alert-danger" style="background-color: #f2dede; color: #a94442; padding: 15px; margin-bottom: 20px; border-radius: 4px;">
                    <%= error %>
                </div>
                <%
                        session.removeAttribute("error");
                    }
                %>
                
                <form id="paymentForm" action="${pageContext.request.contextPath}/ProcessOrderServlet" method="post" onsubmit="return validateForm()">
                    <!-- Hidden fields to pass promotion and total information -->
                    <input type="hidden" name="subtotal" value="<%= subtotal %>">
                    <input type="hidden" name="discount" value="<%= discountAmount %>">
                    <input type="hidden" name="shippingFee" value="<%= shippingFee %>">
                    <input type="hidden" name="total" value="<%= total %>">
                    <% if (appliedPromotionId != null) { %>
                    <input type="hidden" name="promotionId" value="<%= appliedPromotionId %>">
                    <input type="hidden" name="promotionName" value="<%= appliedPromotionName %>">
                    <% } %>
                    
                    <!-- Shipping Information Section -->
                    <div class="section" style="margin-bottom: 25px;">
                        <h3 style="color: #555; margin-bottom: 15px;">Shipping Information</h3>
                        
                        <div class="form-group" style="margin-bottom: 15px;">
                            <label for="fullName" style="display: block; margin-bottom: 5px; font-weight: bold;">Full Name:</label>
                            <input type="text" id="fullName" name="fullName" class="form-control" value="<%= customerName %>" required
                                  style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px;">
                        </div>
                        
                        <div class="form-group" style="margin-bottom: 15px;">
                            <label for="address" style="display: block; margin-bottom: 5px; font-weight: bold;">Shipping Address:</label>
                            <textarea id="address" name="address" class="form-control" rows="3" required
                                     style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px;"></textarea>
                        </div>
                        
                        <div class="row" style="display: flex; margin: 0 -10px;">
                            <div class="col" style="flex: 1; padding: 0 10px;">
                                <div class="form-group" style="margin-bottom: 15px;">
                                    <label for="city" style="display: block; margin-bottom: 5px; font-weight: bold;">City:</label>
                                    <input type="text" id="city" name="city" class="form-control" required
                                          style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px;">
                                </div>
                            </div>
                            <div class="col" style="flex: 1; padding: 0 10px;">
                                <div class="form-group" style="margin-bottom: 15px;">
                                    <label for="state" style="display: block; margin-bottom: 5px; font-weight: bold;">State:</label>
                                    <input type="text" id="state" name="state" class="form-control" required
                                          style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px;">
                                </div>
                            </div>
                            <div class="col" style="flex: 1; padding: 0 10px;">
                                <div class="form-group" style="margin-bottom: 15px;">
                                    <label for="postalCode" style="display: block; margin-bottom: 5px; font-weight: bold;">Postal Code:</label>
                                    <input type="text" id="postalCode" name="postalCode" class="form-control" required
                                          style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px;">
                                </div>
                            </div>
                        </div>
                        
                        <div class="form-group" style="margin-bottom: 15px;">
                            <label for="phoneNumber" style="display: block; margin-bottom: 5px; font-weight: bold;">Phone Number:</label>
                            <input type="tel" id="phoneNumber" name="phoneNumber" class="form-control" required
                                  style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px;">
                        </div>
                    </div>
                    
                    <!-- Payment Method Selection -->
                    <div class="section" style="margin-bottom: 25px;">
                        <h3 style="color: #555; margin-bottom: 15px;">Payment Method</h3>
                        
                        <div class="payment-methods" style="margin-bottom: 20px;">
                            <div class="form-check" style="margin-bottom: 10px;">
                                <input type="radio" id="creditCard" name="paymentMethod" value="Card" checked
                                      style="margin-right: 10px;">
                                <label for="creditCard" style="font-weight: normal;">
                                    <i class="fas fa-credit-card" style="margin-right: 5px; color: #FFC107;"></i> Credit Card
                                </label>
                            </div>
                            
                            <div class="form-check" style="margin-bottom: 10px;">
                                <input type="radio" id="paypal" name="paymentMethod" value="E-wallet"
                                      style="margin-right: 10px;">
                                <label for="paypal" style="font-weight: normal;">
                                    <i class="fab fa-paypal" style="margin-right: 5px; color: #0070BA;"></i> E-Wallet
                                </label>
                            </div>
                            
                            <div class="form-check" style="margin-bottom: 10px;">
                                <input type="radio" id="bankTransfer" name="paymentMethod" value="Online_Transfer"
                                      style="margin-right: 10px;">
                                <label for="bankTransfer" style="font-weight: normal;">
                                    <i class="fas fa-bank" style="margin-right: 5px; color: #4CAF50;"></i> Online Transfer
                                </label>
                            </div>
                            
                            <div class="form-check">
                                <input type="radio" id="cashOnDelivery" name="paymentMethod" value="Cash"
                                      style="margin-right: 10px;">
                                <label for="cashOnDelivery" style="font-weight: normal;">
                                    <i class="fas fa-money-bill-wave" style="margin-right: 5px; color: #28a745;"></i> Cash On Delivery
                                </label>
                            </div>
                        </div>
                        
                        <!-- Credit Card Details (Shown/Hidden based on selection) -->
                        <div id="creditCardDetails">
                            <div class="form-group" style="margin-bottom: 15px;">
                                <label for="cardHolder" style="display: block; margin-bottom: 5px; font-weight: bold;">Card Holder Name:</label>
                                <input type="text" id="cardHolder" name="cardHolder" class="form-control"
                                      style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px;">
                            </div>
                            
                            <div class="form-group" style="margin-bottom: 15px;">
                                <label for="cardNumber" style="display: block; margin-bottom: 5px; font-weight: bold;">Card Number:</label>
                                <input type="text" id="cardNumber" name="cardNumber" class="form-control" placeholder="XXXX XXXX XXXX XXXX"
                                      style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px;">
                            </div>
                            
                            <div class="row" style="display: flex; margin: 0 -10px;">
                                <div class="col" style="flex: 1; padding: 0 10px;">
                                    <div class="form-group" style="margin-bottom: 15px;">
                                        <label for="expiryDate" style="display: block; margin-bottom: 5px; font-weight: bold;">Expiry Date (MM/YY):</label>
                                        <input type="text" id="expiryDate" name="expiryDate" class="form-control" placeholder="MM/YY"
                                              style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px;">
                                    </div>
                                </div>
                                <div class="col" style="flex: 1; padding: 0 10px;">
                                    <div class="form-group" style="margin-bottom: 15px;">
                                        <label for="cvv" style="display: block; margin-bottom: 5px; font-weight: bold;">CVV:</label>
                                        <input type="text" id="cvv" name="cvv" class="form-control" placeholder="XXX"
                                              style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px;">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Submit Button -->
                    <div style="text-align: right;">
                        <a href="${pageContext.request.contextPath}/myCustomer/cart.jsp" class="btn btn-secondary" 
                           style="background-color: #6c757d; color: white; padding: 10px 20px; border-radius: 4px; text-decoration: none; margin-right: 10px;">
                            Back to Cart
                        </a>
                        <button type="submit" class="btn btn-primary" 
                                style="background: linear-gradient(to right, #FFC107, #FF9800); color: #212121; border: none; padding: 10px 30px; border-radius: 4px; font-weight: bold; cursor: pointer;">
                            Complete Order
                        </button>
                    </div>
                </form>
            </div>
        </div>
        
        <!-- Right Column - Order Summary -->
        <div class="col-md-4" style="float: right; width: 30%;">
            <div class="card" style="background-color: white; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); padding: 25px; position: flex; top: 20px;">
                <h3 style="color: #333; margin-bottom: 20px; border-bottom: 2px solid #FFC107; padding-bottom: 10px;">Order Summary</h3>
                
                <%
                    // If parameters weren't passed, calculate from database
                    if (subtotalParam == null) {
                        // Database connection
                        Connection conn = null;
                        PreparedStatement pstmt = null;
                        ResultSet rs = null;
                        
                        try {
                            // Get database connection
                            DBConnection db = new DBConnection();
                            conn = db.getConnection();
                            
                            // Get cart items
                            String sqlQuery = "SELECT c.product_id, p.PRODUCT_NAME, c.product_quantity, p.PRODUCT_PRICE " +
                                           "FROM Carts c " +
                                           "JOIN PRODUCTS p ON c.product_id = p.PRODUCT_ID " +
                                           "WHERE c.customer_id = ?";
                            
                        
                            pstmt = conn.prepareStatement(sqlQuery, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            pstmt.setInt(1, customerId);
                            rs = pstmt.executeQuery();
                            
                            hasItems = rs.isBeforeFirst();
                            
                            if (!hasItems) {
                                // No items in cart, redirect to cart page
                                session.setAttribute("error", "Your cart is empty. Please add items to your cart before proceeding to payment.");
                                response.sendRedirect(request.getContextPath() + "/myCustomer/cart.jsp");
                                return;
                            }
                %>
                
                <div class="order-items" style="margin-bottom: 20px;">
                    <%
                            while (rs.next()) {
                                String productName = rs.getString("PRODUCT_NAME");
                                int quantity = rs.getInt("product_quantity");
                                double price = rs.getDouble("PRODUCT_PRICE");
                                double itemTotal = quantity * price;
                                
                                subtotal += itemTotal;
                                totalItems += quantity;
                    %>
                    <div class="item" style="display: flex; justify-content: space-between; margin-bottom: 10px; padding-bottom: 10px; border-bottom: 1px solid #eee;">
                        <div>
                            <div style="font-weight: bold;"><%= productName %></div>
                            <div style="color: #666; font-size: 0.9em;">Qty: <%= quantity %></div>
                        </div>
                        <div style="text-align: right;">
                            <div>RM <%= priceFormat.format(itemTotal) %></div>
                            <div style="color: #666; font-size: 0.9em;">RM <%= priceFormat.format(price) %> each</div>
                        </div>
                    </div>
                    <%
                            }
                            
                            // Calculate promotion discount if we have one in session
                            if (appliedPromotionId != null) {
                                String applicableType = (String) session.getAttribute("appliedPromotionType");
                                Double discountValue = (Double) session.getAttribute("appliedDiscountValue");
                                Double minPurchaseAmount = (Double) session.getAttribute("appliedMinPurchase");
                                
                                if (subtotal >= minPurchaseAmount && discountValue != null) {
                                    if ("percentage".equals(applicableType)) {
                                        discountAmount = subtotal * (discountValue / 100.0);
                                    } else if ("fixed_amount".equals(applicableType)) {
                                        discountAmount = discountValue;
                                    } else if ("free_shipping".equals(applicableType)) {
                                        shippingFee = 0.0;
                                    }
                                }
                            }
                            
                            // Calculate final total
                            total = subtotal - discountAmount + shippingFee;
                        } catch (SQLException e) {
                            e.printStackTrace();
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
                    }
                %>
                
                <% if (subtotalParam != null) { %>
                <!-- Display items from the cart when parameters are passed -->
                <div class="order-items" style="margin-bottom: 20px;">
                    <%
                    // Get cart items from database even when parameters are passed
                    Connection itemsConn = null;
                    PreparedStatement itemsStmt = null;
                    ResultSet itemsRs = null;
                    
                    try {
                        // Get database connection
                        DBConnection db = new DBConnection();
                        itemsConn = db.getConnection();
                        
                        // Get cart items
                        String itemsQuery = "SELECT c.product_id, p.PRODUCT_NAME, c.product_quantity, p.PRODUCT_PRICE " +
                                       "FROM Carts c " +
                                       "JOIN PRODUCTS p ON c.product_id = p.PRODUCT_ID " +
                                       "WHERE c.customer_id = ?";
                        
                        itemsStmt = itemsConn.prepareStatement(itemsQuery);
                        itemsStmt.setInt(1, customerId);
                        itemsRs = itemsStmt.executeQuery();
                        
                        while (itemsRs.next()) {
                            String productName = itemsRs.getString("PRODUCT_NAME");
                            int quantity = itemsRs.getInt("product_quantity");
                            double price = itemsRs.getDouble("PRODUCT_PRICE");
                            double itemTotal = quantity * price;
                    %>
                    <div class="item" style="display: flex; justify-content: space-between; margin-bottom: 10px; padding-bottom: 10px; border-bottom: 1px solid #eee;">
                        <div>
                            <div style="font-weight: bold;"><%= productName %></div>
                            <div style="color: #666; font-size: 0.9em;">Qty: <%= quantity %></div>
                        </div>
                        <div style="text-align: right;">
                            <div>RM <%= priceFormat.format(itemTotal) %></div>
                            <div style="color: #666; font-size: 0.9em;">RM <%= priceFormat.format(price) %> each</div>
                        </div>
                    </div>
                    <%
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    } finally {
                        // Close resources
                        try {
                            if (itemsRs != null) itemsRs.close();
                            if (itemsStmt != null) itemsStmt.close();
                            if (itemsConn != null) itemsConn.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                    %>
                </div>
                <% } %>
                </div>
                
                <div class="order-summary" style="margin-bottom: 20px;">
                    <div class="summary-row" style="display: flex; justify-content: space-between; margin-bottom: 10px;">
                        <span>Subtotal:</span>
                        <span>RM <%= priceFormat.format(subtotal) %></span>
                    </div>
                    
                    <% if (discountAmount > 0) { %>
                    <div class="summary-row" style="display: flex; justify-content: space-between; margin-bottom: 10px; color: #e65100;">
                        <span>Discount<% if (appliedPromotionName != null) { %> (<%= appliedPromotionName %>)<% } %>:</span>
                        <span>- RM <%= priceFormat.format(discountAmount) %></span>
                    </div>
                    <% } %>
                    
                    <div class="summary-row" style="display: flex; justify-content: space-between; margin-bottom: 10px;">
                        <span>Shipping Fee:</span>
                        <span>RM <%= priceFormat.format(shippingFee) %></span>
                    </div>
                    
                    <div class="summary-row" style="display: flex; justify-content: space-between; margin-bottom: 10px;">
                        <span>Sales Tax:</span>
                        <span>RM <%= priceFormat.format(subtotal * 0.06) %></span>
                    </div>
                    
                    <div class="summary-row total" style="display: flex; justify-content: space-between; margin-top: 15px; padding-top: 15px; border-top: 2px solid #FFC107; font-weight: bold; font-size: 1.2em;">
                        <span>Total:</span>
                        <span>RM <%= priceFormat.format(total) %></span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


<script>
    // Toggle credit card details based on payment method selection
    document.addEventListener('DOMContentLoaded', function() {
        const paymentMethods = document.querySelectorAll('input[name="paymentMethod"]');
        const creditCardDetails = document.getElementById('creditCardDetails');
        
        paymentMethods.forEach(method => {
            method.addEventListener('change', function() {
                if (this.value === 'Card') {
                    creditCardDetails.style.display = 'block';
                } else {
                    creditCardDetails.style.display = 'none';
                }
            });
        });
    });
    
    // Form validation function
    function validateForm() {
        let isValid = true;
        
        // Validate required fields
        const requiredFields = ['fullName', 'address', 'city', 'state', 'postalCode', 'phoneNumber'];
        requiredFields.forEach(field => {
            const input = document.getElementById(field);
            if (!input.value.trim()) {
                alert(`${input.previousElementSibling.textContent.replace(':', '')} is required`);
                input.focus();
                isValid = false;
                return false;
            }
        });
        
        if (!isValid) return false;
        
        // Validate phone number format
        const phoneNumber = document.getElementById('phoneNumber').value;
        if (!/^\d{10,12}$/.test(phoneNumber.replace(/[-\s]/g, ''))) {
            alert('Please enter a valid phone number');
            document.getElementById('phoneNumber').focus();
            return false;
        }
        
        // Validate postal code format
        const postalCode = document.getElementById('postalCode').value;
        if (!/^\d{5}$/.test(postalCode)) {
            alert('Please enter a valid 5-digit postal code');
            document.getElementById('postalCode').focus();
            return false;
        }
        
        // Validate credit card details if credit card payment method is selected
        const creditCardSelected = document.getElementById('creditCard').checked;
        if (creditCardSelected) {
            // Validate card number (16 digits, spaces allowed for readability)
            const cardNumber = document.getElementById('cardNumber').value.replace(/\s/g, '');
            if (!/^\d{16}$/.test(cardNumber)) {
                alert('Please enter a valid 16-digit card number');
                document.getElementById('cardNumber').focus();
                return false;
            }
            
            // Validate expiry date (MM/YY format)
            const expiryDate = document.getElementById('expiryDate').value;
            if (!/^(0[1-9]|1[0-2])\/\d{2}$/.test(expiryDate)) {
                alert('Please enter a valid expiry date in MM/YY format');
                document.getElementById('expiryDate').focus();
                return false;
            }
            
            // Validate CVV (3 or 4 digits)
            const cvv = document.getElementById('cvv').value;
            if (!/^\d{3,4}$/.test(cvv)) {
                alert('Please enter a valid CVV number (3 or 4 digits)');
                document.getElementById('cvv').focus();
                return false;
            }
        }
        
        // Add confirmation dialog
        const confirmed = confirm("Are you sure you want to place this order?\n\n" +
                                "By clicking OK, you confirm that all information is correct");
        
        return confirmed; // Only submit if user confirms
    }
</script> 