package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Products;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "ControlProdM", urlPatterns = {"/myStaff/ControlProdM"})
public class ControlProdM extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        List<Products> products = new ArrayList<>();
        Connection conn = null;

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            DBConnection db = new DBConnection();
            conn = db.getConnection();

            // Get parameters
            String action = request.getParameter("action");
            String id = request.getParameter("id");
            String update = request.getParameter("update");

            // Modify - Step 1: Show update form
            if ("modify".equals(action)) {
                PreparedStatement ps = conn.prepareStatement("SELECT * FROM PRODUCTS WHERE PRODUCT_ID = ?");
                ps.setString(1, id);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
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
                    request.setAttribute("product", product); 
                      request.getRequestDispatcher("/myStaff/updatePageM.jsp").forward(request, response);
                }
              
                
            } else if ("delete".equals(action)) {
                request.setAttribute("id", id);
                request.getRequestDispatcher("/myStaff/delConfirmation.jsp").forward(request, response);
                return;
            }

            // Load product list
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM PRODUCTS");
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
                products.add(product);
            }

            request.setAttribute("products", products);
            request.getRequestDispatcher("/myStaff/updateProdM.jsp").forward(request, response);

        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("error", "Error: " + ex.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet to modify or delete products using JDBC";
    }
}
