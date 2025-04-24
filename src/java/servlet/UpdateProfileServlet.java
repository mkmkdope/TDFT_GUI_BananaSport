package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import servlet.DBConnection;

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get session
        HttpSession session = request.getSession();
        
        // Check if user is logged in
        if (session.getAttribute("loggedIn") == null || !(Boolean) session.getAttribute("loggedIn")) {
            response.sendRedirect(request.getContextPath() + "/myCustomer/loginC.jsp");
            return;
        }
        
        // Get parameters
        String customerName = request.getParameter("customerName");
        String email = request.getParameter("email");
        String contactNumber = request.getParameter("contactNumber");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Get customerId from session
        Integer customerId = (Integer) session.getAttribute("customerId");
        
        // Input validation
        if (customerName == null || customerName.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            contactNumber == null || contactNumber.trim().isEmpty() ||
            currentPassword == null || currentPassword.trim().isEmpty()) {
            
            request.setAttribute("error", "All required fields must be filled out.");
            request.getRequestDispatcher("/myCustomer/profile.jsp").forward(request, response);
            return;
        }
        
        // Database connection
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            // Get database connection
            DBConnection db = new DBConnection();
            conn = db.getConnection();
            
            // Verify current password
            String verifySQL = "SELECT password FROM CUSTOMERS WHERE customer_id = ?";
            pstmt = conn.prepareStatement(verifySQL);
            pstmt.setInt(1, customerId);
            rs = pstmt.executeQuery();
            
            if (!rs.next() || !rs.getString("password").equals(currentPassword)) {
                request.setAttribute("error", "Current password is incorrect.");
                request.getRequestDispatcher("/myCustomer/profile.jsp").forward(request, response);
                return;
            }
            
            // Update profile
            String updateSQL;
            
            // Check if new password is being set
            if (newPassword != null && !newPassword.isEmpty() && confirmPassword != null && !confirmPassword.isEmpty()) {
                // Password change requested, validate
                if (!newPassword.equals(confirmPassword)) {
                    request.setAttribute("error", "New passwords do not match.");
                    request.getRequestDispatcher("/myCustomer/profile.jsp").forward(request, response);
                    return;
                }
                
                if (newPassword.length() < 6) {
                    request.setAttribute("error", "New password must be at least 6 characters.");
                    request.getRequestDispatcher("/myCustomer/profile.jsp").forward(request, response);
                    return;
                }
                
                // Update with new password
                updateSQL = "UPDATE CUSTOMERS SET customer_name = ?, email = ?, contact_number = ?, password = ? WHERE customer_id = ?";
                pstmt = conn.prepareStatement(updateSQL);
                pstmt.setString(1, customerName);
                pstmt.setString(2, email);
                pstmt.setString(3, contactNumber);
                pstmt.setString(4, newPassword);
                pstmt.setInt(5, customerId);
            } else {
                // Update without changing password
                updateSQL = "UPDATE CUSTOMERS SET customer_name = ?, email = ?, contact_number = ? WHERE customer_id = ?";
                pstmt = conn.prepareStatement(updateSQL);
                pstmt.setString(1, customerName);
                pstmt.setString(2, email);
                pstmt.setString(3, contactNumber);
                pstmt.setInt(4, customerId);
            }
            
            int result = pstmt.executeUpdate();
            
            if (result > 0) {
                // Update session attributes
                session.setAttribute("customerName", customerName);
                session.setAttribute("email", email);
                
                // Set success message
                request.setAttribute("success", "Profile updated successfully!");
            } else {
                request.setAttribute("error", "Failed to update profile. Please try again.");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
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
        
        // Forward back to profile page
        request.getRequestDispatcher("/myCustomer/profile.jsp").forward(request, response);
    }
} 