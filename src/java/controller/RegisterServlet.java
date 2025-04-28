package controller;

import util.DBConnection;
import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String customerName = request.getParameter("customerName");
        String contactNumber = request.getParameter("contactNumber");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (customerName == null || customerName.trim().isEmpty()) {
            request.setAttribute("error", "Name cannot be empty.");
            request.getRequestDispatcher("/myCustomer/registerC.jsp").forward(request, response);
            return;
        }

        if (contactNumber == null || !contactNumber.matches("\\d+")) {
            request.setAttribute("error", "Contact number must contain only numbers.");
            request.getRequestDispatcher("/myCustomer/registerC.jsp").forward(request, response);
            return;
        }

        if (email == null || !email.contains("@") || !email.contains(".")) {
            request.setAttribute("error", "Please enter a valid email.");
            request.getRequestDispatcher("/myCustomer/registerC.jsp").forward(request, response);
            return;
        }

        if (username == null || username.trim().isEmpty()) {
            request.setAttribute("error", "Username cannot be empty.");
            request.getRequestDispatcher("/myCustomer/registerC.jsp").forward(request, response);
            return;
        }

        if (password == null || password.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters.");
            request.getRequestDispatcher("/myCustomer/registerC.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("/myCustomer/registerC.jsp").forward(request, response);
            return;
        }

        try {
            DBConnection db = new DBConnection();
            Connection conn = db.getConnection(); 
            
            // Check if username already exists
            PreparedStatement checkUsername = conn.prepareStatement("SELECT * FROM CUSTOMERS WHERE username = ?");
            checkUsername.setString(1, username);
            ResultSet rsUsername = checkUsername.executeQuery();
            
            if (rsUsername.next()) {
                request.setAttribute("error", "Username already exists. Please choose another one.");
                request.getRequestDispatcher("/myCustomer/registerC.jsp").forward(request, response);
                rsUsername.close();
                checkUsername.close();
                conn.close();
                return;
            }
            
            // Check if email already exists
            PreparedStatement checkEmail = conn.prepareStatement("SELECT * FROM CUSTOMERS WHERE email = ?");
            checkEmail.setString(1, email);
            ResultSet rsEmail = checkEmail.executeQuery();
            
            if (rsEmail.next()) {
                request.setAttribute("error", "Email address already registered. Please use another one.");
                request.getRequestDispatcher("/myCustomer/registerC.jsp").forward(request, response);
                rsEmail.close();
                checkEmail.close();
                rsUsername.close();
                checkUsername.close();
                conn.close();
                return;
            }
            
            // If no duplicate will proceed with registrater
            String sql = "INSERT INTO CUSTOMERS (customer_name, contact_number, email, username, password) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, customerName);
            pstmt.setString(2, contactNumber);
            pstmt.setString(3, email);
            pstmt.setString(4, username);
            pstmt.setString(5, password);

            int result = pstmt.executeUpdate();

            if (result > 0) {
                // Set success message and redirect to login page
                request.setAttribute("success", "Registration successful! Please login.");
                request.getRequestDispatcher("/myCustomer/loginC.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Registration failed. Please try again.");
                request.getRequestDispatcher("/myCustomer/registerC.jsp").forward(request, response);
            }

            // Close all
            pstmt.close();
            rsEmail.close();
            checkEmail.close();
            rsUsername.close();
            checkUsername.close();
            conn.close();

        } catch (SQLException e) {
            String errorMessage = e.getMessage();
            if (errorMessage.contains("Duplicate entry") || 
                errorMessage.contains("duplicate key") || 
                errorMessage.contains("UNIQUE constraint") ||
                errorMessage.contains("unique or primary key constraint")) {
                
                // Check which field caused the duplicate
                if (errorMessage.toLowerCase().contains("username")) {
                    request.setAttribute("error", "Username already exists. Please choose another one.");
                } else if (errorMessage.toLowerCase().contains("email")) {
                    request.setAttribute("error", "Email address already registered. Please use another one.");
                } else {
                    request.setAttribute("error", "Registration failed: Username or email already exists.");
                }
            } else {
                request.setAttribute("error", "Database error: " + e.getMessage());
            }
            request.getRequestDispatcher("/myCustomer/registerC.jsp").forward(request, response);
        }
    }
}