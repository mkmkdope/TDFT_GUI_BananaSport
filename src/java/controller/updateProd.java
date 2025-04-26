/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import util.DBConnection;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;

/**
 *
 * @author Admin
 */
@MultipartConfig(fileSizeThreshold = 1024 * 1024,  // 1MB
                 maxFileSize = 1024 * 1024 * 5,    // 5MB
                 maxRequestSize = 1024 * 1024 * 10) // 10MB

@WebServlet(name = "updateProd", urlPatterns = {"/myStaff/updateProd"})
public class updateProd extends HttpServlet {

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
        Connection conn = null;
        try {

            Class.forName("org.apache.derby.jdbc.ClientDriver");
            DBConnection db = new DBConnection();
            conn = db.getConnection();

            String id = request.getParameter("id");
            String update = request.getParameter("update");

            if (("update").equals(update)) {

                String productName = request.getParameter("name");
                String productCategory = request.getParameter("category");
                int productQuantity = Integer.parseInt(request.getParameter("quantity"));
                double productPrice = Double.parseDouble(request.getParameter("price"));
                String description = request.getParameter("description");

                String queryUpdate = "UPDATE PRODUCTS SET PRODUCT_NAME = ?, PRODUCT_CATEGORY = ?, PRODUCT_QTY = ?, PRODUCT_PRICE = ?, PRODUCT_CREATEDTIME = ?,DESCRIPTION = ? WHERE PRODUCT_ID = ?";
                PreparedStatement up = conn.prepareStatement(queryUpdate);
                up.setString(1, productName);
                up.setString(2, productCategory);
                up.setInt(3, productQuantity);
                up.setDouble(4, productPrice);
                up.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
                up.setString(6, description);
                up.setString(7, id);
                
                
                    //this part is for save the image and combine change the imgae name to store
            Part imagePart = request.getPart("image");
            String submittedImageName = java.nio.file.Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
            
            String imageExtension = "";
            int i = submittedImageName .lastIndexOf('.');
            
            if(i >= 0){
             imageExtension = submittedImageName.substring(i);
            }

           String newImageName = String.format("%s%s",id,imageExtension);
            
            String uploadPath = getServletContext().getInitParameter("uploadPath");

            //java.io.File.separator
            
              String fullImagePath =  uploadPath + java.io.File.separator + newImageName;
            
              try(InputStream input = imagePart.getInputStream()){
                  
                  java.nio.file.Files.copy(
                  input,
                          java.nio.file.Paths.get(fullImagePath),
                          java.nio.file.StandardCopyOption.REPLACE_EXISTING
                  );
              }
                
                int updated = up.executeUpdate();
                if (updated > 0) {
                    request.setAttribute("message", "Product updated successfully!");
                   request.getRequestDispatcher("ControlProdM").forward(request, response);

                } else {
                    request.setAttribute("error", "Failed to update product.");
                   request.getRequestDispatcher("/staticView/error.jsp").forward(request, response);
                }
                
                
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("error", "Error: " + ex.getMessage());
            request.getRequestDispatcher("/staticView/error.jsp").forward(request, response);
        } finally {
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

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
