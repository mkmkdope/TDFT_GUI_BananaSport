<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="servlet.DBConnection" %>
<%
    // Using DBConnection class for database connection
    DBConnection dbConnection = new DBConnection();
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        // Load the Derby driver
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        
        // Get product details from the form
        String productId = request.getParameter("productId");
        
        if (productId == null || productId.trim().isEmpty()) {
            throw new Exception("Product ID is missing");
        }
        
        // Get current customer ID from session, or use a default for guests
        Integer customerId = (Integer) session.getAttribute("customerId");
        if (customerId == null) {
            // If not logged in, could redirect to login or use a guest ID
            // For now, we'll use 1 as a default customer ID
            customerId = 1; // TODO: Handle guest users or require login
        }
        
        // Establish database connection using DBConnection
        conn = dbConnection.getConnection();
        
        // First, check if the product exists in the Carts table for this customer
        String checkCartQuery = "SELECT product_quantity FROM Carts WHERE product_id = ? AND customer_id = ?";
        pstmt = conn.prepareStatement(checkCartQuery);
        pstmt.setString(1, productId);
        pstmt.setInt(2, customerId);
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
            // Product already in cart, update quantity
            int currentQuantity = rs.getInt("product_quantity");
            String updateCartQuery = "UPDATE Carts SET product_quantity = ? WHERE product_id = ? AND customer_id = ?";
            
            // Close the previous statement and create a new one
            pstmt.close();
            pstmt = conn.prepareStatement(updateCartQuery);
            pstmt.setInt(1, currentQuantity + 1);
            pstmt.setString(2, productId);
            pstmt.setInt(3, customerId);
            pstmt.executeUpdate();
            
            session.setAttribute("message", "Product quantity updated in cart!");
        } else {
            // Product not in cart, add it
            String insertCartQuery = "INSERT INTO Carts (customer_id, product_id, product_quantity) VALUES (?, ?, 1)";
            
            // Close the previous statement and create a new one
            if (pstmt != null) pstmt.close();
            pstmt = conn.prepareStatement(insertCartQuery);
            pstmt.setInt(1, customerId);
            pstmt.setString(2, productId);
            pstmt.executeUpdate();
            
            session.setAttribute("message", "Product added to cart successfully!");
        }
        
    } catch (Exception ex) {
        // Set error message with more details
        session.setAttribute("error", "Error adding product to cart: " + ex.getMessage());
        System.out.println("Error in addToCart.jsp: " + ex.getMessage());
        ex.printStackTrace();
    } finally {
        // Close all resources
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // Redirect back to cart page
    response.sendRedirect(request.getContextPath() + "/myCustomer/cart.jsp");
%>