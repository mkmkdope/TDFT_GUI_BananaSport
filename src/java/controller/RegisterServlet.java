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
            request.setAttribute("error", "Name Cannot be Empty.");
            request.getRequestDispatcher("/myCustomer/registerC.jsp").forward(request, response);
            return;
        }

        if (contactNumber == null || !contactNumber.matches("\\d+")) {
            request.setAttribute("error", "Contact Number Must Contain Numbers Only.");
            request.getRequestDispatcher("/myCustomer/registerC.jsp").forward(request, response);
            return;
        }

        if (email == null || !email.contains("@") || !email.contains(".")) {
            request.setAttribute("error", "Please Enter a Valid Email.");
            request.getRequestDispatcher("/myCustomer/registerC.jsp").forward(request, response);
            return;
        }

        if (username == null || username.trim().isEmpty()) {
            request.setAttribute("error", "Username Cannot Be Empty.");
            request.getRequestDispatcher("/myCustomer/registerC.jsp").forward(request, response);
            return;
        }

        if (password == null || password.length() < 6) {
            request.setAttribute("error", "Password Must Be at Least 6 Characters.");
            request.getRequestDispatcher("/myCustomer/registerC.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords Do Not Match.");
            request.getRequestDispatcher("/myCustomer/registerC.jsp").forward(request, response);
            return;
        }

        try {
            DBConnection db = new DBConnection();
            Connection conn = db.getConnection(); 
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
                request.setAttribute("success", "Registration Successful! Please Login.");
                request.getRequestDispatcher("/myCustomer/loginC.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Registration failed. Please try again.");
                request.getRequestDispatcher("/myCustomer/registerC.jsp").forward(request, response);
            }

            pstmt.close();
            conn.close();

        } catch (SQLException e) {
            if (e.getMessage().contains("Duplicate entry")) {
                request.setAttribute("error", "Username already exists. Choose another one.");
            } else {
                request.setAttribute("error", "Database error: " + e.getMessage());
            }
            request.getRequestDispatcher("/myCustomer/registerC.jsp").forward(request, response);
        }
    }
}


