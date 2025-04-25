<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="/header.jsp">
    <jsp:param name="pageTitle" value="Home"/>
</jsp:include>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <!<!-- Servlet -->
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Shopping Cart - ${applicationScope.companyName}</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
        <!-- Font Awesome for icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <style>
            /* Center the cart container */
            .cart-container {
                max-width: 1450px;
                margin: 30px auto; /* Centers the container horizontally */
                padding: 20px;
                background-color: white;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                text-align: center;  /* Centers text inside */
            }

            /* Center the table and make sure it's responsive */
            table {
                width: 100%;
                border-collapse: separate;
                border-spacing: 0;
                margin-top: 20px;
                table-layout: auto;
                background: linear-gradient(to bottom right, #ffffff, #f0f0f0);
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
                border-radius: 12px;
                overflow: hidden;
                border: 2px solid black; /* Outer border for the table */
                margin-left: auto; /* Centering the table */
                margin-right: auto; /* Centering the table */
            }

            /* Center the content in the table cells */
            th, td {
                padding: 18px 20px;
                text-align: center; /* Center align the content */
                font-size: 16px;
                word-wrap: break-word;
                border-bottom: 2px solid #ddd;
            }

            th {
                background: linear-gradient(to right, #FFC107, #FFD54F);
                color: #212121;
                font-weight: bold;
                font-size: 18px;
                border-bottom: 2px solid black;
                border-right: 2px solid black; /* Border between header cells */
            }

            /* Hover effect for table rows */
            tr:hover {
                background-color: #fff8e1;
            }

            /* Center the images in the table */
            td img {
                max-width: 100px;
                border-radius: 10px;
                border: 2px solid #ccc;
                margin-left: auto;
                margin-right: auto; /* Center the image */
            }

            /* Styling for the total row (centered) */
            .total-row {
                font-weight: bold;
                background-color: #FFF9C4; /* Light yellow */
                font-size: 18px;
                border-top: 2px solid #FFC107;
                border-bottom: none;
            }

            /* Quantity control styling */
            .quantity-control {
                display: flex;
                justify-content: center; /* Center the quantity controls */
                align-items: center;
                gap: 8px;
            }

            /* Styling for the quantity buttons */
            .btn-quantity {
                padding: 5px 10px;
                font-size: 16px;
                background: linear-gradient(to right, #FFEB3B, #FF9800);
                color: #212121;
                border: 1px solid #FFC107;
                border-radius: 5px;
                cursor: pointer;
                transition: background 0.2s ease, transform 0.2s ease, box-shadow 0.2s ease;
            }

            .btn-quantity:hover {
                transform: scale(1.05);
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            }
            /* Styling for the quantity input field */
            .quantity-input {
                width: 40px;
                text-align: center;
                font-size: 14px;
                padding: 5px;
                border: 1px solid #FFC107;
                border-radius: 5px;
                background-color: #fff;
            }

            /* Remove button styling */
            .btn-remove {
                background: linear-gradient(to right, #f44336, #e57373);
                color: white;
                border: none; /* removed border */
                border-radius: 8px;
                padding: 10px 20px;
                cursor: pointer;
                font-size: 16px;
                transition: transform 0.2s ease, box-shadow 0.2s ease;
            }

            .btn-remove:hover {
                transform: scale(1.05);
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            }


            /* Proceed to checkout button styling */
            .btn-proceed {
                padding: 10px 20px;
                background: linear-gradient(to right, #FFC107, #FFE082);
                color: #212121;
                border: none; /* removed border */
                border-radius: 8px;
                cursor: pointer;
                font-size: 18px;
                font-weight: bold;
                transition: transform 0.2s ease, box-shadow 0.2s ease;
            }

            .btn-proceed:hover {
                transform: scale(1.05);
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            }

            /* Empty cart section */
            .empty-cart {
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                height: 30vh;
                color: #555;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                text-align: center;
            }

            /* Center the image in empty cart section */
            .empty-cart img {
                width: 120px;
                opacity: 0.7;
                margin-bottom: 20px;
            }

            /* Center the text in empty cart section */
            .empty-cart p {
                font-size: 1.5rem;
                font-weight: 500;
            }

            /* Center the "Continue Shopping" button */
            .empty-cart a {
                display: inline-block;
                margin-top: 10px;
                text-decoration: none;
                padding: 10px 20px;
                background: linear-gradient(to right, #FFC107, #FFE082);
                color: #212121;
                border-radius: 8px;
                cursor: pointer;
                font-size: 14px;
                font-weight: bold;
                transition: transform 0.2s ease, box-shadow 0.2s ease;
            }

            /* Add hover effect for the "Continue Shopping" button */
            .empty-cart a:hover {
                transform: scale(1.05);
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
                background: linear-gradient(to right, #FFB300, #FFD54F);
            }

            /* Promotion card styling */
            .promotion-section {
                margin: 20px 0;
                padding: 15px;
                background-color: #fff9c4;
                border-radius: 8px;
                border: 1px solid #ffd600;
            }
            
            .promotion-info {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 10px;
                background-color: white;
                border-radius: 6px;
                margin-bottom: 10px;
            }
            
            .promotion-details {
                display: flex;
                flex-direction: column;
                align-items: flex-start;
            }
            
            .promotion-name {
                font-weight: bold;
                font-size: 18px;
                color: #333;
            }
            
            .promotion-value {
                font-size: 16px;
                color: #e65100;
            }
            
            .promotion-remove {
                background-color: #f44336;
                color: white;
                border: none;
                border-radius: 4px;
                padding: 5px 10px;
                cursor: pointer;
            }
            
            .discount-row {
                background-color: #fff8e1;
                font-weight: bold;
            }
            
            .promotion-badge {
                display: inline-block;
                padding: 5px 10px;
                background-color: #e65100;
                color: white;
                border-radius: 20px;
                font-size: 14px;
                margin-left: 10px;
            }
            
            .promotion-alert {
                padding: 10px;
                margin: 10px 0;
                border-radius: 4px;
                font-size: 14px;
            }
            
            .alert-info {
                background-color: #e3f2fd;
                border: 1px solid #2196f3;
                color: #0d47a1;
            }
            
            .alert-warning {
                background-color: #fff8e1;
                border: 1px solid #ffc107;
                color: #ff6f00;
            }
        </style>
    </head>
    <body>
        <div class="cart-container">
            <h1>Your Shopping Cart</h1>

            <!-- Add message display section -->
            <%
                String message = (String) session.getAttribute("message");
                String error = (String) session.getAttribute("error");
                String successMessage = (String) request.getAttribute("successMessage");
                
                if (message != null) {
            %>
            <div class="alert alert-success" style="background-color: #dff0d8; color: #3c763d; padding: 15px; margin-bottom: 20px; border-radius: 4px;">
                <%= message%>
            </div>
            <%
                    session.removeAttribute("message");
                }
                if (error != null) {
            %>
            <div class="alert alert-danger" style="background-color: #f2dede; color: #a94442; padding: 15px; margin-bottom: 20px; border-radius: 4px;">
                <%= error%>
            </div>
            <%
                    session.removeAttribute("error");
                }
                if (successMessage != null) {
            %>
            <div class="alert alert-success" style="background-color: #dff0d8; color: #3c763d; padding: 15px; margin-bottom: 20px; border-radius: 4px;">
                <%= successMessage %>
            </div>
            <%
                }
            %>

            <%
                // Use DBConnection for database connectivity
                DBConnection dbConnection = new DBConnection();

                // Get current customer ID from session, or use a default for guests
                Integer customerId = (Integer) session.getAttribute("customerId");
                if (customerId == null) {
                    // If not logged in, redirect to login page
                    response.sendRedirect(request.getContextPath() + "/login.jsp?redirect=myCustomer/cart.jsp");
                    return;
                }

                String sqlQuery = "SELECT c.product_id, p.PRODUCT_NAME, c.product_quantity, "
                        + "p.PRODUCT_PRICE, p.PRODUCT_POPULARITY, p.IMAGELINK, p.PRODUCT_CATEGORY "
                        + "FROM Carts c "
                        + "JOIN PRODUCTS p ON c.product_id = p.PRODUCT_ID "
                        + "WHERE c.customer_id = ?";

                Connection conn = null;
                ResultSet rs = null;
                PreparedStatement pstmt = null;
                double subtotalAmount = 0.0;
                double discountAmount = 0.0;
                double totalAmount = 0.0;
                boolean hasItems = false;  // Flag to check if cart has items
                
                // Get applied promotion from session
                Integer appliedPromotionId = (Integer) session.getAttribute("appliedPromotionId");
                String appliedPromotionName = (String) session.getAttribute("appliedPromotionName");
                String appliedPromotionType = (String) session.getAttribute("appliedPromotionType");
                Double appliedDiscountValue = (Double) session.getAttribute("appliedDiscountValue");
                Double appliedMinPurchase = (Double) session.getAttribute("appliedMinPurchase");
                
                boolean promotionApplied = false;
                String promotionMessage = null;

                try {
                    // Load the Derby driver
                    Class.forName("org.apache.derby.jdbc.ClientDriver");

                    // Get connection using DBConnection
                    conn = dbConnection.getConnection();

                    // Prepare the SQL query
                    pstmt = conn.prepareStatement(sqlQuery,
                            ResultSet.TYPE_SCROLL_INSENSITIVE,
                            ResultSet.CONCUR_READ_ONLY);
                    pstmt.setInt(1, customerId);
                    rs = pstmt.executeQuery();

                    // Check if there are items in the cart
                    hasItems = rs.isBeforeFirst(); // This checks if there are any results

                    if (hasItems) {
            %>
            
            <!-- Display applied promotion if any -->
            <% if (appliedPromotionId != null && appliedPromotionName != null) { %>
            <div class="promotion-section">
                <h3><i class="fas fa-tag"></i> Applied Promotion</h3>
                <div class="promotion-info">
                    <div class="promotion-details">
                        <span class="promotion-name"><%= appliedPromotionName %></span>
                        <% if ("percentage".equals(appliedPromotionType)) { %>
                            <span class="promotion-value"><%= appliedDiscountValue.intValue() %>% discount</span>
                        <% } else if ("fixed_amount".equals(appliedPromotionType)) { %>
                            <span class="promotion-value">RM <%= String.format("%.2f", appliedDiscountValue) %> off</span>
                        <% } else if ("free_shipping".equals(appliedPromotionType)) { %>
                            <span class="promotion-value">Free shipping on orders over RM <%= String.format("%.2f", appliedMinPurchase) %></span>
                        <% } %>
                    </div>
                    <form action="${pageContext.request.contextPath}/RemovePromotion" method="post">
                        <button type="submit" class="promotion-remove">Remove</button>
                    </form>
                </div>
            </div>
            <% } else { %>
            <div style="text-align: center; margin-bottom: 20px;">
                <a href="${pageContext.request.contextPath}/myCustomer/promotions.jsp" class="btn-proceed" style="background: linear-gradient(to right, #4CAF50, #8BC34A); display: inline-block;">
                    <i class="fas fa-tag"></i> Browse Available Promotions
                </a>
            </div>
            <% } %>
            
            <table>
                <thead>
                    <tr>
                        <th>Product ID</th>
                        <th>Product Image</th>
                        <th>Product Name</th>
                        <th>Quantity</th>
                        <th>Unit Price</th>
                        <th>Total</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        // Loop through the result set and display each product in the cart
                        while (rs.next()) {
                            String productId = rs.getString("product_id");  // Use String since product_id is VARCHAR
                            String productName = rs.getString("PRODUCT_NAME");
                            String productCategory = rs.getString("PRODUCT_CATEGORY");
                            int quantity = rs.getInt("product_quantity");
                            double price = rs.getDouble("PRODUCT_PRICE");
                            String imageLink = rs.getString("IMAGELINK");  // Retrieve the image link
                            double itemTotal = quantity * price;
                            subtotalAmount += itemTotal;
                            
                            // Fetch available product quantity
                            PreparedStatement availQtyStmt = null;
                            ResultSet availQtyRs = null;
                            int availableQuantity = 0;
                            
                            try {
                                String availQtyQuery = "SELECT PRODUCT_QTY FROM PRODUCTS WHERE PRODUCT_ID = ?";
                                availQtyStmt = conn.prepareStatement(availQtyQuery);
                                availQtyStmt.setString(1, productId);
                                availQtyRs = availQtyStmt.executeQuery();
                                
                                if (availQtyRs.next()) {
                                    availableQuantity = availQtyRs.getInt("PRODUCT_QTY");
                                }
                            } finally {
                                if (availQtyRs != null) availQtyRs.close();
                                if (availQtyStmt != null) availQtyStmt.close();
                            }
                    %>
                    <tr>
                        <td><%= productId%></td>
                        <td>
                            <img src="../images/<%= imageLink%>" alt="<%= productName%>" style="width: 100px; height: auto;">                        
                        </td>
                        <td><%= productName%></td>
                        <td>
                            <div class="quantity-control">
                                <form id="updateForm-<%= productId%>" action="../CartOperationServlet" method="post" style="display: inline;">
                                    <input type="hidden" name="productId" value="<%= productId%>">
                                    <input type="hidden" name="action" value="update">
                                    <button type="button" onclick="changeQuantity('<%= productId%>', -1)" class="btn-quantity"><i class="fa-solid fa-minus"></i></button>
                                    <input type="text" name="quantity" id="qty-<%= productId%>" value="<%= quantity%>" readonly class="quantity-input" data-max-qty="<%= availableQuantity %>">
                                    <button type="button" onclick="changeQuantity('<%= productId%>', 1)" class="btn-quantity" <%= quantity >= availableQuantity ? "disabled style='opacity: 0.5; cursor: not-allowed;'" : "" %>><i class="fa-solid fa-plus"></i></button>
                                </form>
                                <% if (quantity >= availableQuantity) { %>
                                <div style="font-size: 12px; color: #ff0000; margin-top: 5px;">Max quantity reached</div>
                                <% } else { %>
                                <div style="font-size: 12px; color: #666; margin-top: 5px;"><%= availableQuantity - quantity %> more available</div>
                                <% } %>
                            </div>
                        </td>
                        <td>RM <%= String.format("%.2f", price)%></td>
                        <td>RM <%= String.format("%.2f", itemTotal)%></td>
                        <td>
                            <form action="../CartOperationServlet" method="post" style="display: inline;" onsubmit="return confirmRemove();">
                                <input type="hidden" name="productId" value="<%= productId%>">
                                <input type="hidden" name="action" value="remove">
                                <button type="submit" class="btn-update btn-remove">
                                    <i class="fa-solid fa-trash"></i>
                                </button>
                            </form>
                        </td>
                    </tr>
                    <%
                        }
                        
                        // Calculate discount if promotion is applied
                        if (appliedPromotionId != null && appliedPromotionName != null) {
                            if (subtotalAmount >= appliedMinPurchase) {
                                if ("percentage".equals(appliedPromotionType)) {
                                    discountAmount = subtotalAmount * (appliedDiscountValue / 100.0);
                                    promotionApplied = true;
                                } else if ("fixed_amount".equals(appliedPromotionType)) {
                                    discountAmount = appliedDiscountValue;
                                    promotionApplied = true;
                                } else if ("free_shipping".equals(appliedPromotionType)) {
                                    // Free shipping handled at checkout
                                    promotionApplied = true;
                                    promotionMessage = "Free shipping will be applied at checkout";
                                }
                            } else {
                                promotionMessage = "You need to spend RM " + String.format("%.2f", (appliedMinPurchase - subtotalAmount)) + " more to qualify for this promotion.";
                            }
                        }
                        
                        // Calculate final total
                        totalAmount = subtotalAmount - discountAmount;
                    %>
                    
                    <tr class="total-row">
                        <td colspan="5" style="text-align: right;"><strong>Subtotal:</strong></td>
                        <td><strong>RM <%= String.format("%.2f", subtotalAmount)%></strong></td>
                        <td></td>
                    </tr>
                    
                    <% if (promotionApplied) { %>
                    <tr class="discount-row">
                        <td colspan="5" style="text-align: right;">
                            <strong>Discount:</strong>
                            <span class="promotion-badge"><%= appliedPromotionName %></span>
                        </td>
                        <td><strong>- RM <%= String.format("%.2f", discountAmount)%></strong></td>
                        <td></td>
                    </tr>
                    <% } %>
                    
                    <tr class="total-row">
                        <td colspan="5" style="text-align: right;"><strong>Total Amount:</strong></td>
                        <td><strong>RM <%= String.format("%.2f", totalAmount)%></strong></td>
                        <td></td>
                    </tr>
                </tbody>
            </table>
            
            <% if (promotionMessage != null) { %>
            <div class="promotion-alert <%= promotionApplied ? "alert-info" : "alert-warning" %>">
                <i class="<%= promotionApplied ? "fas fa-info-circle" : "fas fa-exclamation-triangle" %>"></i>
                <%= promotionMessage %>
            </div>
            <% } %>

            <div style="text-align: right; margin-top: 20px;">
                <form action="payment.jsp" method="post">
                    <input type="hidden" name="subtotal" value="<%= subtotalAmount %>">
                    <input type="hidden" name="discount" value="<%= discountAmount %>">
                    <input type="hidden" name="total" value="<%= totalAmount %>">
                    <% if (promotionApplied && "free_shipping".equals(appliedPromotionType)) { %>
                        <input type="hidden" name="freeShipping" value="true">
                    <% } %>
                    <button type="submit" class="btn-proceed">Proceed to Payment</button>
                </form>
            </div>
            <%
            } else {
            %>
            <div class="empty-cart">
                <p>Your cart is empty</p>
                <a href="${pageContext.request.contextPath}/showProd" class="btn-update" style="display: inline-block; margin-top: 10px; text-decoration: none;">
                    Continue Shopping
                </a>
            </div>
            <%
                    }

                } catch (SQLException ex) {
                    out.println("<div style='color: red; text-align: center;'>Error: " + ex.getMessage() + "</div>");
                    ex.printStackTrace();
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
        </div>

        <!-- Include your footer if you have one -->
        <jsp:include page="/footer.jsp" />
    </body>

    <script>
        // Function to handle quantity change
        function changeQuantity(productId, change) {
            // Get the input field for the product
            var qtyField = document.getElementById('qty-' + productId);
            var currentQty = parseInt(qtyField.value);
            var maxQty = parseInt(qtyField.getAttribute('data-max-qty'));

            // Update the quantity
            var newQty = currentQty + change;

            // Ensure the quantity does not go below 0 or above max available
            if (newQty >= 0 && newQty <= maxQty) {
                qtyField.value = newQty;
                
                // Now submit the form automatically after updating the quantity
                var form = document.getElementById('updateForm-' + productId);
                form.submit();
            } else if (newQty > maxQty) {
                alert("Sorry, only " + maxQty + " units are available in stock.");
            }
        }

        // Confirm the removal of a product before submitting the form
        function confirmRemove() {
            return confirm("Are you sure you want to remove this product from the cart?");
        }
    </script>
</html>