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

@WebServlet("/customerLogin")
public class customerLogin extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        if (username == null || username.isEmpty() || 
            password == null || password.isEmpty()) {
            
            request.setAttribute("error", "Username and password are required");
            request.getRequestDispatcher("/myCustomer/loginC.jsp").forward(request, response);
            return;
        }
        

        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            // Get database connection
            DBConnection db = new DBConnection();
            Connection conn = db.getConnection(); 
            
            // Prepare SQL query to check credentials
            String sql = "SELECT * FROM CUSTOMERS WHERE username = ? AND password = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, password); // Note: In production, you should hash passwords
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                // Valid credentials - create session
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setAttribute("customerName", rs.getString("customer_name"));
                session.setAttribute("customerId", rs.getInt("customer_id"));
                session.setAttribute("email", rs.getString("email"));
                session.setAttribute("loggedIn", true);
                session.setMaxInactiveInterval(30 * 60); // 30 minutes
                
                // Redirect to products page
                response.sendRedirect(request.getContextPath() + "/showProd");
            } else {
                // Invalid credentials
                request.setAttribute("error", "Invalid Username or Password");
                request.getRequestDispatcher("/myCustomer/loginC.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error occurred. Please try again.");
            request.getRequestDispatcher("/myCustomer/loginC.jsp").forward(request, response);
        } finally {
            // Close resources
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}