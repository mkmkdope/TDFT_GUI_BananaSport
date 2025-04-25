package controller;

import util.DBConnection;
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

@WebServlet("/StaffManagerLogin")
public class StaffManagerLogin extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        if (email == null || email.isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("error", "Email and password are required");
            request.getRequestDispatcher("/myStaff/loginM.jsp").forward(request, response);
            return;
        }
        
        // Check if user is a manager
        boolean isManager = false;
        boolean isStaff = false;
        int userId = 0;
        String userName = "";
        String userPosition = "";
        String userContactNumber = "";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            // Get database connection
            DBConnection db = new DBConnection();
            conn = db.getConnection();
            
            // First check MANAGERS table
            String managerSql = "SELECT * FROM MANAGERS WHERE managers_email = ? AND managers_password = ?";
            pstmt = conn.prepareStatement(managerSql);
            pstmt.setString(1, email);
            pstmt.setString(2, password);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                isManager = true;
                userId = rs.getInt("managers_manager_id");
                userName = rs.getString("managers_name");
                userPosition = rs.getString("managers_position");
                userContactNumber = rs.getString("managers_contact_number");
            } else {
                // If not a manager, check STAFF table
                if (pstmt != null) pstmt.close();
                if (rs != null) rs.close();
                
                String staffSql = "SELECT * FROM STAFF WHERE staff_email = ? AND staff_password = ?";
                pstmt = conn.prepareStatement(staffSql);
                pstmt.setString(1, email);
                pstmt.setString(2, password);
                
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    isStaff = true;
                    userId = rs.getInt("staff_id");
                    userName = rs.getString("staff_name");
                    userPosition = rs.getString("staff_position");
                    userContactNumber = rs.getString("staff_contact_number");
                }
            }
            
            if (isManager || isStaff) {
                // Valid credentials - create session
                HttpSession session = request.getSession();
                session.setAttribute("userId", userId);
                session.setAttribute("userName", userName);
                session.setAttribute("userEmail", email);
                session.setAttribute("userPosition", userPosition);
                session.setAttribute("userContactNumber", userContactNumber);
                session.setAttribute("isManager", isManager);
                session.setAttribute("isStaff", isStaff);
                session.setAttribute("loggedIn", true);
                session.setMaxInactiveInterval(30 * 60); // 30 minutes
                
                // Redirect to appropriate dashboard based on role
                if (isManager) {
                    response.sendRedirect(request.getContextPath() + "/myAdmin/AdminModule.jsp");
                } else {
                    response.sendRedirect(request.getContextPath() + "/myStaff/controlPanelM.jsp");
                }
            } else {
                // Invalid credentials
                request.setAttribute("error", "Invalid email or password");
                request.getRequestDispatcher("/myStaff/loginM.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error occurred. Please try again.");
            request.getRequestDispatcher("/myStaff/loginM.jsp").forward(request, response);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
} 