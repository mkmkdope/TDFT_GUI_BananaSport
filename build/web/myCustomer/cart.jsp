<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="/header.jsp">
    <jsp:param name="pageTitle" value="Home"/>
</jsp:include>
<%@ page import="java.sql.*" %>
<%@ page import="servlet.DBConnection" %>
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
                height: 60vh;
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
        </style>
    </head>
    <body>
        <div class="cart-container">
            <h1>Your Shopping Cart <i class="fas fa-shopping-cart"></i></h1>

            <!-- Add message display section -->
            <%
                String message = (String) session.getAttribute("message");
                String error = (String) session.getAttribute("error");
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
            %>

            <%
                // Use DBConnection for database connectivity
                DBConnection dbConnection = new DBConnection();

                // Get current customer ID from session, or use a default for guests
                Integer customerId = (Integer) session.getAttribute("customerId");
                if (customerId == null) {
                    // If not logged in, could redirect to login or use a guest ID
                    customerId = 1; // TODO: Handle guest users or require login
                }

                String sqlQuery = "SELECT c.product_id, p.PRODUCT_NAME, c.product_quantity, "
                        + "p.PRODUCT_PRICE, p.PRODUCT_POPULARITY, p.IMAGELINK "
                        + "FROM Carts c "
                        + "JOIN PRODUCTS p ON c.product_id = p.PRODUCT_ID "
                        + "WHERE c.customer_id = ?";

                Connection conn = null;
                ResultSet rs = null;
                PreparedStatement pstmt = null;
                double totalAmount = 0.0;
                boolean hasItems = false;  // Flag to check if cart has items

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
                            int quantity = rs.getInt("product_quantity");
                            double price = rs.getDouble("PRODUCT_PRICE");
                            String imageLink = rs.getString("IMAGELINK");  // Retrieve the image link
                            double itemTotal = quantity * price;
                            totalAmount += itemTotal;
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
                                    <input type="text" name="quantity" id="qty-<%= productId%>" value="<%= quantity%>" readonly class="quantity-input">
                                    <button type="button" onclick="changeQuantity('<%= productId%>', 1)" class="btn-quantity"><i class="fa-solid fa-plus"></i></button>
                                </form>
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
                    %>
                    <tr class="total-row">
                        <td colspan="5" style="text-align: right;"><strong>Total Amount:</strong></td>
                        <td><strong>RM <%= String.format("%.2f", totalAmount)%></strong></td>
                        <td></td>
                    </tr>
                </tbody>
            </table>

            <div style="text-align: right; margin-top: 20px;">
                <form action="payment.jsp" method="post">
                    <button type="submit" class="btn-proceed">🛍️ Proceed to Payment</button>
                </form>
            </div>
            <%
            } else {
            %>
            <div class="empty-cart">
                <img src="https://cdn-icons-png.flaticon.com/512/2038/2038854.png" alt="Empty Cart" />
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

            // Update the quantity
            var newQty = currentQty + change;

            // Ensure the quantity does not go below 0
            if (newQty >= 0) {
                qtyField.value = newQty;
            }

            // Now submit the form automatically after updating the quantity
            var form = document.getElementById('updateForm-' + productId);
            form.submit();
        }

        // Confirm the removal of a product before submitting the form
        function confirmRemove() {
            return confirm("Are you sure you want to remove this product from the cart?");
        }
    </script>
</html>