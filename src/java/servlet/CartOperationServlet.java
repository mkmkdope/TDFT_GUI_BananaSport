package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/CartOperationServlet")
public class CartOperationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Process cart operations: update or remove items
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get parameters from the request
        String productId = request.getParameter("productId");
        String action = request.getParameter("action");
        HttpSession session = request.getSession();  // Get session

        // Get current customer ID from session, or use a default for guests
        Integer customerId = (Integer) session.getAttribute("customerId");
        if (customerId == null) {
            // If not logged in, could redirect to login or use a guest ID
            customerId = 1; // TODO: Handle guest users or require login
        }

        // Database connection variables
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // Load the Derby driver
            Class.forName("org.apache.derby.jdbc.ClientDriver");

            // Establish database connection using DBConnection
            DBConnection dbConnection = new DBConnection();
            conn = dbConnection.getConnection();

            if ("update".equals(action)) {
                // Update quantity in the cart
                int newQuantity = Integer.parseInt(request.getParameter("quantity"));
                
                // Check if the new quantity exceeds the available product quantity
                String checkStockQuery = "SELECT PRODUCT_QTY FROM PRODUCTS WHERE PRODUCT_ID = ?";
                pstmt = conn.prepareStatement(checkStockQuery);
                pstmt.setString(1, productId);
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    int availableQuantity = rs.getInt("PRODUCT_QTY");
                    
                    if (newQuantity > availableQuantity) {
                        // If requested quantity exceeds available stock, set to maximum available
                        newQuantity = availableQuantity;
                        session.setAttribute("message", "Quantity adjusted to maximum available stock (" + availableQuantity + ")");
                    }
                }
                
                if (newQuantity <= 0) {
                    // If quantity is zero or negative, remove the item from cart
                    String deleteQuery = "DELETE FROM Carts WHERE product_id = ? AND customer_id = ?";
                    pstmt = conn.prepareStatement(deleteQuery);
                    pstmt.setString(1, productId);
                    pstmt.setInt(2, customerId);
                    pstmt.executeUpdate();
                    
                    session.setAttribute("message", "Product removed from cart as quantity was set to zero.");
                } else {
                    // Update the cart with the validated quantity
                    String updateQuery = "UPDATE Carts SET product_quantity = ? WHERE product_id = ? AND customer_id = ?";
                    pstmt = conn.prepareStatement(updateQuery);
                    pstmt.setInt(1, newQuantity);
                    pstmt.setString(2, productId);
                    pstmt.setInt(3, customerId);
                    pstmt.executeUpdate();
                    
                    session.setAttribute("message", "Cart updated successfully!");
                }
            } else if ("remove".equals(action)) {
                // Remove item from the cart
                String deleteQuery = "DELETE FROM Carts WHERE product_id = ? AND customer_id = ?";
                pstmt = conn.prepareStatement(deleteQuery);
                pstmt.setString(1, productId);
                pstmt.setInt(2, customerId);
                pstmt.executeUpdate();

                session.setAttribute("message", "Product removed from cart successfully!");
            }

        } catch (SQLException | ClassNotFoundException ex) {
            session.setAttribute("error", "Error processing cart operation: " + ex.getMessage());
            ex.printStackTrace();
        } finally {
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
    }
}
