package controller;

import util.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Customer;

@WebServlet("/CustomerServlet")
public class CustomerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            if (action == null) {
                listCustomers(request, response);
            } else if (action.equals("edit")) {
                showEditForm(request, response);
            } else if (action.equals("delete")) {
                deleteCustomer(request, response);
            } else if (action.equals("view")) {
                viewCustomer(request, response);
            } else {
                listCustomers(request, response);
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        try {
            if (action.equals("create")) {
                createCustomer(request, response);
            } else if (action.equals("update")) {
                updateCustomer(request, response);
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
    
    private void listCustomers(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String search = request.getParameter("search");
        
        List<Customer> customers = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            // Get database connection
            DBConnection db = new DBConnection();
            conn = db.getConnection();
            
            String sql = "SELECT * FROM CUSTOMERS";
            if (search != null && !search.trim().isEmpty()) {
                sql += " WHERE customer_name LIKE ? OR email LIKE ? OR username LIKE ?";
            }
            
            pstmt = conn.prepareStatement(sql);
            
            if (search != null && !search.trim().isEmpty()) {
                String searchParam = "%" + search + "%";
                pstmt.setString(1, searchParam);
                pstmt.setString(2, searchParam);
                pstmt.setString(3, searchParam);
            }
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Customer customer = new Customer();
                customer.setCustomerId(rs.getInt("customer_id"));
                customer.setCustomerName(rs.getString("customer_name"));
                customer.setContactNumber(rs.getString("contact_number"));
                customer.setEmail(rs.getString("email"));
                customer.setUsername(rs.getString("username"));
                customer.setPassword(rs.getString("password"));
                
                customers.add(customer);
            }
            
            request.setAttribute("customers", customers);
            request.getRequestDispatcher("/myAdmin/customerList.jsp").forward(request, response);
            
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int customerId = Integer.parseInt(request.getParameter("customerId"));
        Customer customer = getCustomer(customerId);
        
        request.setAttribute("customer", customer);
        request.getRequestDispatcher("/myAdmin/editCustomer.jsp").forward(request, response);
    }
    
    private void createCustomer(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String customerName = request.getParameter("customerName");
        String contactNumber = request.getParameter("contactNumber");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            // Get database connection
            DBConnection db = new DBConnection();
            conn = db.getConnection();
            
            String sql = "INSERT INTO CUSTOMERS (customer_name, contact_number, email, username, password) VALUES (?, ?, ?, ?, ?)";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, customerName);
            pstmt.setString(2, contactNumber);
            pstmt.setString(3, email);
            pstmt.setString(4, username);
            pstmt.setString(5, password);
            
            pstmt.executeUpdate();
            
            response.sendRedirect("CustomerServlet");
            
        } finally {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
    }
    
    private void updateCustomer(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int customerId = Integer.parseInt(request.getParameter("customerId"));
        String customerName = request.getParameter("customerName");
        String contactNumber = request.getParameter("contactNumber");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            // Get database connection
            DBConnection db = new DBConnection();
            conn = db.getConnection();
            
            String sql = "UPDATE CUSTOMERS SET customer_name = ?, contact_number = ?, email = ?, username = ?, password = ? WHERE customer_id = ?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, customerName);
            pstmt.setString(2, contactNumber);
            pstmt.setString(3, email);
            pstmt.setString(4, username);
            pstmt.setString(5, password);
            pstmt.setInt(6, customerId);
            
            pstmt.executeUpdate();
            
            response.sendRedirect("CustomerServlet");
            
        } finally {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
    }
    
    private void deleteCustomer(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int customerId = Integer.parseInt(request.getParameter("customerId"));
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            // Get database connection
            DBConnection db = new DBConnection();
            conn = db.getConnection();
            
            String sql = "DELETE FROM CUSTOMERS WHERE customer_id = ?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, customerId);
            
            pstmt.executeUpdate();
            
            response.sendRedirect("CustomerServlet");
            
        } finally {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
    }
    
    private void viewCustomer(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int customerId = Integer.parseInt(request.getParameter("customerId"));
        Customer customer = getCustomer(customerId);
        
        request.setAttribute("customer", customer);
        request.getRequestDispatcher("/myAdmin/viewCustomer.jsp").forward(request, response);
    }
    
    private Customer getCustomer(int customerId) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Customer customer = null;
        
        try {
            // Get database connection
            DBConnection db = new DBConnection();
            conn = db.getConnection();
            
            String sql = "SELECT * FROM CUSTOMERS WHERE customer_id = ?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, customerId);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                customer = new Customer();
                customer.setCustomerId(rs.getInt("customer_id"));
                customer.setCustomerName(rs.getString("customer_name"));
                customer.setContactNumber(rs.getString("contact_number"));
                customer.setEmail(rs.getString("email"));
                customer.setUsername(rs.getString("username"));
                customer.setPassword(rs.getString("password"));
            }
            
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
        
        return customer;
    }
} 