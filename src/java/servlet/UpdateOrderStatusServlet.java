package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet to handle updates to order status
 */
@WebServlet(name = "UpdateOrderStatusServlet", urlPatterns = {"/UpdateOrderStatusServlet"})
public class UpdateOrderStatusServlet extends HttpServlet {

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
        
        // Check if user is logged in as staff or manager
        if (session.getAttribute("loggedIn") == null || 
            !(Boolean) session.getAttribute("loggedIn") || 
            (session.getAttribute("isStaff") == null && session.getAttribute("isManager") == null)) {
            
            response.sendRedirect(request.getContextPath() + "/myStaff/loginM.jsp");
            return;
        }
        
        // Get parameters
        String orderId = request.getParameter("orderId");
        String newStatus = request.getParameter("orderStatus");
        String returnTab = request.getParameter("returnTab"); // To return to the correct tab
        
        // Validate parameters
        if (orderId == null || newStatus == null) {
            request.setAttribute("message", "Order ID and status are required");
            request.getRequestDispatcher("/myStaff/controlPanelM.jsp").forward(request, response);
            return;
        }
        
        // Validate status values
        if (!newStatus.equals("Pending") && !newStatus.equals("Packaging") && 
            !newStatus.equals("Shipping") && !newStatus.equals("Delivery")) {
            request.setAttribute("message", "Invalid order status");
            request.getRequestDispatcher("/myStaff/controlPanelM.jsp").forward(request, response);
            return;
        }
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            // Get database connection
            DBConnection dbConn = new DBConnection();
            conn = dbConn.getConnection();
            
            // Prepare SQL statement
            String sql = "UPDATE Orders SET order_status = ? WHERE order_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, newStatus);
            pstmt.setInt(2, Integer.parseInt(orderId));
            
            // Execute update
            int rowsUpdated = pstmt.executeUpdate();
            
            if (rowsUpdated > 0) {
                // Update successful
                session.setAttribute("message", "Order #" + orderId + " status updated to " + newStatus);
            } else {
                // No rows were updated (order may not exist)
                session.setAttribute("error", "Order #" + orderId + " not found");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid order ID format");
        } catch (SQLException e) {
            session.setAttribute("error", "Database error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            // Close resources
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        // Redirect back to the control panel (orders tab)
        String redirectURL = request.getContextPath() + "/myStaff/controlPanelM.jsp";
        if (returnTab != null && !returnTab.isEmpty()) {
            if ("details".equals(returnTab)) {
                // If updating from the details page, redirect back to it
                redirectURL = request.getContextPath() + "/myStaff/viewOrderDetails.jsp?orderId=" + orderId;
            } else {
                redirectURL += "?tab=" + returnTab;
            }
        } else {
            redirectURL += "?tab=orders";
        }
        
        response.sendRedirect(redirectURL);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Servlet for updating order status";
    }
} 