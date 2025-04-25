/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import util.DBConnection;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Products;

/**
 *
 * @author Admin
 */
@WebServlet(name = "searchProd", urlPatterns = {"/searchProd"})
public class searchProd extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");

            DBConnection db = new DBConnection();

            List<Products> products = new ArrayList<>();

            try (Connection conn = db.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery("SELECT * FROM PRODUCTS")) {

                 String searchparameter = request.getParameter("search"); 
                 
                 if(searchparameter != null &&!searchparameter.trim().isEmpty()){
                while (rs.next()) {
                    Products product = new Products(
                            rs.getString("PRODUCT_ID"),
                            rs.getString("PRODUCT_NAME"),
                            rs.getString("PRODUCT_CATEGORY"),
                            rs.getInt("PRODUCT_QTY"),
                            rs.getDouble("PRODUCT_PRICE"),
                            rs.getInt("PRODUCT_POPULARITY"),
                            rs.getTimestamp("PRODUCT_CREATEDTIME"),
                            rs.getString("IMAGELINK"),
                            rs.getString("description")
                    );
                      String productId = rs.getString("PRODUCT_ID");
                        String productName = rs.getString("PRODUCT_NAME");
                        
                        if(productId.equalsIgnoreCase(searchparameter)||productName.toLowerCase().contains(searchparameter.toLowerCase())){
                          products.add(product);
                        }
                }
                 }else{
                     
                     
                     
               }
                 
                 
                  request.setAttribute("products", products);
            request.getRequestDispatcher("/products.jsp").forward(request, response);
                 
                

            }

        } catch (ClassNotFoundException ex) {
            ex.printStackTrace();
            System.out.println("ClassNotFoundException: " + ex.getMessage());
            request.setAttribute("error", "Error loading products: " + ex.getMessage());
            request.getRequestDispatcher("/staticView/error.jsp").forward(request, response);
        } catch (SQLException ex) {
            ex.printStackTrace();
            System.out.println("SQLException: " + ex.getMessage());
            request.setAttribute("error", "Error loading products: " + ex.getMessage());
            request.getRequestDispatcher("/staticView/error.jsp").forward(request, response);
        }

//        try (PrintWriter out = response.getWriter()) {
//            /* TODO output your page here. You may use following sample code. */
//            out.println("<!DOCTYPE html>");
//            out.println("<html>");
//            out.println("<head>");
//            out.println("<title>Servlet searchProd</title>");
//            out.println("</head>");
//            out.println("<body>");
//            out.println("<h1>Servlet searchProd at " + request.getContextPath() + "</h1>");
//            out.println("</body>");
//            out.println("</html>");
//        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

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
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
