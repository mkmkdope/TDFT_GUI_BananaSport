package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/ProcessOrderServlet")
public class ProcessOrderServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Check if user is logged in
        if (session.getAttribute("loggedIn") == null || !(Boolean) session.getAttribute("loggedIn")) {
            session.setAttribute("error", "Please login to complete your order");
            response.sendRedirect(request.getContextPath() + "/myCustomer/loginC.jsp");
            return;
        }

        // Get customer ID from session
        Integer customerId = (Integer) session.getAttribute("customerId");

        // Get form parameters
        String fullName = request.getParameter("fullName");
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String postalCode = request.getParameter("postalCode");
        String phoneNumber = request.getParameter("phoneNumber");
        String paymentMethod = request.getParameter("paymentMethod");
        String orderNotes = request.getParameter("orderNotes");

        // Combine address parts for the shipping address
        String shippingAddress = address + ", " + city + ", " + state + " " + postalCode;

        // Variables for database operations
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // Get database connection
            DBConnection db = new DBConnection();
            conn = db.getConnection();

            // Begin transaction
            conn.setAutoCommit(false);

            // Check if we have promotion and total parameters from the form
            String subtotalParam = request.getParameter("subtotal");
            String discountParam = request.getParameter("discount");
            String shippingFeeParam = request.getParameter("shippingFee");
            String totalParam = request.getParameter("total");
            String promotionIdParam = request.getParameter("promotionId");
            String promotionNameParam = request.getParameter("promotionName");
            
            double subtotal = 0.0;
            double discountAmount = 0.0;
            double shippingFee = 10.00; // Default shipping fee
            double totalAmount = 0.0;
            Integer promotionId = null;
            String promotionName = null;
            String promotionType = null;
            Double discountValue = null;
            double salesTax = 0.0; // Sales tax (6%)
            
            // If parameters are provided from the form, use them
            if (subtotalParam != null && !subtotalParam.isEmpty() &&
                totalParam != null && !totalParam.isEmpty()) {
                
                subtotal = Double.parseDouble(subtotalParam);
                
                if (discountParam != null && !discountParam.isEmpty()) {
                    discountAmount = Double.parseDouble(discountParam);
                }
                
                if (shippingFeeParam != null && !shippingFeeParam.isEmpty()) {
                    shippingFee = Double.parseDouble(shippingFeeParam);
                }
                
                totalAmount = Double.parseDouble(totalParam);
                
                if (promotionIdParam != null && !promotionIdParam.isEmpty()) {
                    promotionId = Integer.parseInt(promotionIdParam);
                }
            } else {
                // 1. Calculate order totals from cart if parameters aren't provided
                String cartQuery = "SELECT c.product_id, c.product_quantity, p.PRODUCT_PRICE "
                        + "FROM Carts c "
                        + "JOIN PRODUCTS p ON c.product_id = p.PRODUCT_ID "
                        + "WHERE c.customer_id = ?";

                pstmt = conn.prepareStatement(cartQuery, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                pstmt.setInt(1, customerId);
                rs = pstmt.executeQuery();

                // Check if cart is empty
                if (!rs.isBeforeFirst()) {
                    session.setAttribute("error", "Your cart is empty. Please add items to your cart.");
                    response.sendRedirect(request.getContextPath() + "/myCustomer/cart.jsp");
                    return;
                }

                // Calculate subtotal
                while (rs.next()) {
                    double price = rs.getDouble("PRODUCT_PRICE");
                    int quantity = rs.getInt("product_quantity");
                    subtotal += price * quantity;
                }
                
                // Check inventory levels before processing
                rs.beforeFirst(); // Reset cursor to beginning
                boolean insufficientStock = false;
                StringBuilder outOfStockItems = new StringBuilder("The following items have insufficient stock: ");
                
                while (rs.next()) {
                    String productId = rs.getString("product_id");
                    int cartQuantity = rs.getInt("product_quantity");
                    
                    PreparedStatement stockStmt = null;
                    ResultSet stockRs = null;
                    
                    try {
                        String checkStockQuery = "SELECT PRODUCT_ID, PRODUCT_NAME, PRODUCT_QTY FROM PRODUCTS WHERE PRODUCT_ID = ?";
                        stockStmt = conn.prepareStatement(checkStockQuery);
                        stockStmt.setString(1, productId);
                        stockRs = stockStmt.executeQuery();
                        
                        if (stockRs.next()) {
                            int availableStock = stockRs.getInt("PRODUCT_QTY");
                            String productName = stockRs.getString("PRODUCT_NAME");
                            
                            if (cartQuantity > availableStock) {
                                insufficientStock = true;
                                outOfStockItems.append(productName).append(" (requested: ").append(cartQuantity)
                                              .append(", available: ").append(availableStock).append("), ");
                            }
                        }
                    } finally {
                        if (stockRs != null) stockRs.close();
                        if (stockStmt != null) stockStmt.close();
                    }
                }
                
                if (insufficientStock) {
                    // Remove trailing comma and space
                    if (outOfStockItems.toString().endsWith(", ")) {
                        outOfStockItems.setLength(outOfStockItems.length() - 2);
                    }
                    
                    session.setAttribute("error", outOfStockItems.toString());
                    conn.rollback();
                    response.sendRedirect(request.getContextPath() + "/myCustomer/cart.jsp");
                    return;
                }
                
                // Check for promotion discount in session
                Integer appliedPromotionId = (Integer) session.getAttribute("appliedPromotionId");
                String appliedPromotionName = (String) session.getAttribute("appliedPromotionName");
                String appliedPromotionType = (String) session.getAttribute("appliedPromotionType");
                Double appliedDiscountValue = (Double) session.getAttribute("appliedDiscountValue");
                Double appliedMinPurchase = (Double) session.getAttribute("appliedMinPurchase");
                String appliedApplicableTo = (String) session.getAttribute("appliedApplicableTo");
                
                if (appliedPromotionId != null && appliedDiscountValue != null && 
                    appliedMinPurchase != null && subtotal >= appliedMinPurchase) {
                    
                    promotionId = appliedPromotionId;
                    promotionName = appliedPromotionName;
                    promotionType = appliedPromotionType;
                    discountValue = appliedDiscountValue;
                    
                    if ("percentage".equals(appliedPromotionType)) {
                        discountAmount = subtotal * (appliedDiscountValue / 100.0);
                    } else if ("fixed_amount".equals(appliedPromotionType)) {
                        discountAmount = appliedDiscountValue;
                    }
                }
                
                // Calculate 6% sales tax on subtotal
                salesTax = subtotal * 0.06;
                
                // Calculate final total
                // Apply free shipping for orders of RM 1000 and above, and RM 25 for orders below RM 1000
                shippingFee = (subtotal >= 1000) ? 0.0 : 25.0;
                
                totalAmount = subtotal - discountAmount + shippingFee + salesTax;
            }

            // Append promotion details to order notes if a promotion was applied
            if (promotionId != null) {
                String promotionDetails = "";
                if (promotionName != null) {
                    promotionDetails = "Promotion applied: " + promotionName;
                    
                    if ("percentage".equals(promotionType)) {
                        promotionDetails += " (" + discountValue.intValue() + "% discount)";
                    } else if ("fixed_amount".equals(promotionType)) {
                        promotionDetails += " ($" + discountValue.intValue() + " off)";
                    }
                    
                    promotionDetails += ". Discount amount: $" + String.format("%.2f", discountAmount);
                } else {
                    promotionDetails = "Promotion ID: " + promotionId + " applied. Discount amount: $" + String.format("%.2f", discountAmount);
                }
                
                // Append to existing notes or set as notes
                if (orderNotes != null && !orderNotes.isEmpty()) {
                    orderNotes = orderNotes + "\n\n" + promotionDetails;
                } else {
                    orderNotes = promotionDetails;
                }
            }

            // 2. Create order record with discount information
            String insertOrderSQL = "INSERT INTO Orders (customer_id, order_date, total_amount, payment_method, "
                    + "shipping_address, shipping_fee, order_status, full_name, contact_number, order_notes, sales_tax) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            pstmt = conn.prepareStatement(insertOrderSQL, Statement.RETURN_GENERATED_KEYS);
            pstmt.setInt(1, customerId);
            pstmt.setTimestamp(2, new Timestamp(new Date().getTime()));
            pstmt.setDouble(3, totalAmount);
            pstmt.setString(4, paymentMethod);
            pstmt.setString(5, shippingAddress);
            pstmt.setDouble(6, shippingFee);
            pstmt.setString(7, "Pending");
            pstmt.setString(8, fullName);
            pstmt.setString(9, phoneNumber);
            pstmt.setString(10, orderNotes);
            pstmt.setDouble(11, salesTax);

            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected == 0) {
                throw new SQLException("Creating order failed, no rows affected.");
            }

            // Get the generated order ID
            rs = pstmt.getGeneratedKeys();
            int orderId;
            if (rs.next()) {
                orderId = rs.getInt(1);
            } else {
                throw new SQLException("Creating order failed, no ID obtained.");
            }

            // Insert payment record into Payments table
            String insertPaymentSQL = "INSERT INTO Payments (order_id, payment_method) VALUES (?, ?)";
            pstmt = conn.prepareStatement(insertPaymentSQL);
            pstmt.setInt(1, orderId);
            pstmt.setString(2, paymentMethod);
            pstmt.executeUpdate();

            // 3. Insert order details from cart items
            String cartItemsQuery = "SELECT c.product_id, c.product_quantity, p.PRODUCT_PRICE, p.PRODUCT_NAME "
                    + "FROM Carts c "
                    + "JOIN PRODUCTS p ON c.product_id = p.PRODUCT_ID "
                    + "WHERE c.customer_id = ?";

            pstmt = conn.prepareStatement(cartItemsQuery);
            pstmt.setInt(1, customerId);
            rs = pstmt.executeQuery();

            // Batch insert order details
            String insertOrderDetailsSQL = "INSERT INTO Order_Details (order_id, product_id, quantity, price) "
                    + "VALUES (?, ?, ?, ?)";

            pstmt = conn.prepareStatement(insertOrderDetailsSQL);

            while (rs.next()) {
                String productId = rs.getString("product_id");
                int quantity = rs.getInt("product_quantity");
                double price = rs.getDouble("PRODUCT_PRICE");
                String productName = rs.getString("PRODUCT_NAME");

                pstmt.setInt(1, orderId);
                pstmt.setString(2, productId);
                pstmt.setInt(3, quantity);
                pstmt.setDouble(4, price);
                pstmt.addBatch();

                // Update product popularity and stock
                updateProductPopularityAndStock(conn, productId, quantity);
            }

            pstmt.executeBatch();

            // 4. Clear the customer's cart
            String clearCartSQL = "DELETE FROM Carts WHERE customer_id = ?";
            pstmt = conn.prepareStatement(clearCartSQL);
            pstmt.setInt(1, customerId);
            pstmt.executeUpdate();
            
            // 5. Remove any applied promotion from the session
            session.removeAttribute("appliedPromotionId");
            session.removeAttribute("appliedPromotionName");
            session.removeAttribute("appliedPromotionType");
            session.removeAttribute("appliedDiscountValue");
            session.removeAttribute("appliedMinPurchase");
            session.removeAttribute("appliedApplicableTo");

            // Commit the transaction
            conn.commit();

            // Store the order ID in session for the confirmation page
            session.setAttribute("lastOrderId", orderId);

            // Redirect to order confirmation page
            response.sendRedirect(request.getContextPath() + "/myCustomer/orderConfirmation.jsp");

        } catch (SQLException e) {
            // Roll back the transaction in case of error
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }

            e.printStackTrace();
            session.setAttribute("error", "Failed to process your order: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/myCustomer/payment.jsp");

        } finally {
            // Reset auto-commit to true
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }

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
    }

    /**
     * Updates product popularity and stock when an order is placed
     */
    private void updateProductPopularityAndStock(Connection conn, String productId, int quantity) throws SQLException {
        PreparedStatement pstmt = null;

        try {
            // Update product popularity (increment by quantity ordered)
            String updatePopularitySQL = "UPDATE PRODUCTS SET PRODUCT_POPULARITY = PRODUCT_POPULARITY + ? WHERE PRODUCT_ID = ?";
            pstmt = conn.prepareStatement(updatePopularitySQL);
            pstmt.setInt(1, quantity);
            pstmt.setString(2, productId);
            pstmt.executeUpdate();

            // Update product stock when an order is placed
            String updateStockSQL = "UPDATE PRODUCTS SET PRODUCT_QTY = PRODUCT_QTY - ? WHERE PRODUCT_ID = ?";
            pstmt = conn.prepareStatement(updateStockSQL);
            pstmt.setInt(1, quantity);
            pstmt.setString(2, productId);
            pstmt.executeUpdate();
        } finally {
            if (pstmt != null) {
                pstmt.close();
            }
        }
    }
}
