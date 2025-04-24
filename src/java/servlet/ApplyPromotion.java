package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet to handle applying promotions to a customer's cart
 */
@WebServlet(name = "ApplyPromotion", urlPatterns = {"/ApplyPromotion"})
public class ApplyPromotion extends HttpServlet {

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer customerId = (Integer) session.getAttribute("customerId");
        
        // Check if user is logged in
        if (customerId == null) {
            request.setAttribute("errorMessage", "You must be logged in to apply promotions.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        // Get the promotion ID from the request
        String promotionIdStr = request.getParameter("promotionId");
        if (promotionIdStr == null || promotionIdStr.isEmpty()) {
            request.setAttribute("message", "Invalid promotion selected.");
            request.getRequestDispatcher("/myCustomer/promotions.jsp").forward(request, response);
            return;
        }
        
        int promotionId;
        try {
            promotionId = Integer.parseInt(promotionIdStr);
        } catch (NumberFormatException e) {
            request.setAttribute("message", "Invalid promotion ID.");
            request.getRequestDispatcher("/myCustomer/promotions.jsp").forward(request, response);
            return;
        }
        
        // Store the selected promotion in the session
        try {
            // Validate the promotion exists and is active
            DBConnection dbConn = new DBConnection();
            Connection conn = dbConn.getConnection();
            
            PreparedStatement pstmt = conn.prepareStatement(
                "SELECT * FROM Promotions WHERE promotion_id = ? AND is_active = TRUE"
            );
            pstmt.setInt(1, promotionId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                // Retrieve promotion details
                String promotionName = rs.getString("promotion_name");
                String promotionType = rs.getString("promotion_type");
                double discountValue = rs.getDouble("discount_value");
                double minPurchaseAmount = rs.getDouble("min_purchase_amount");
                String applicableTo = rs.getString("applicable_to");
                
                // Store promotion in session
                session.setAttribute("appliedPromotionId", promotionId);
                session.setAttribute("appliedPromotionName", promotionName);
                session.setAttribute("appliedPromotionType", promotionType);
                session.setAttribute("appliedDiscountValue", discountValue);
                session.setAttribute("appliedMinPurchase", minPurchaseAmount);
                session.setAttribute("appliedApplicableTo", applicableTo);
                
                // Set success message
                request.setAttribute("successMessage", "Promotion '" + promotionName + "' has been applied to your cart!");
            } else {
                request.setAttribute("message", "The selected promotion is no longer active.");
            }
            
            rs.close();
            pstmt.close();
            conn.close();
        } catch (Exception e) {
            request.setAttribute("message", "Error applying promotion: " + e.getMessage());
        }
        
        // Redirect to cart page to see the applied promotion
        response.sendRedirect(request.getContextPath() + "/myCustomer/cart.jsp");
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Handles applying promotions to a customer's cart";
    }
} 