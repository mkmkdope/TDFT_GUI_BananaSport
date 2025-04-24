package servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet to handle removing promotions from a customer's cart
 */
@WebServlet(name = "RemovePromotion", urlPatterns = {"/RemovePromotion"})
public class RemovePromotion extends HttpServlet {

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
        
        // Remove promotion attributes from session
        session.removeAttribute("appliedPromotionId");
        session.removeAttribute("appliedPromotionName");
        session.removeAttribute("appliedPromotionType");
        session.removeAttribute("appliedDiscountValue");
        session.removeAttribute("appliedMinPurchase");
        session.removeAttribute("appliedApplicableTo");
        
        // Set a success message
        session.setAttribute("message", "Promotion has been removed from your cart.");
        
        // Redirect back to the cart page
        response.sendRedirect(request.getContextPath() + "/myCustomer/cart.jsp");
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Handles removing promotions from a customer's cart";
    }
} 