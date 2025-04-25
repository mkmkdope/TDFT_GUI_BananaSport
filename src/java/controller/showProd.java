package controller;

import util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Products;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "showProd", urlPatterns = {"/showProd"})
public class showProd extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
       
        response.setContentType("text/html;charset=UTF-8");

        List<Products> products = new ArrayList<>();
        try {

            Class.forName("org.apache.derby.jdbc.ClientDriver");

           DBConnection db = new DBConnection();

            try (Connection conn = db.getConnection(); 
                    Statement stmt = conn.createStatement(); 
                    ResultSet rs = stmt.executeQuery("SELECT * FROM PRODUCTS")) {

               
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
            }

            //this is for the money sorting part 
            String sort = request.getParameter("sort");
            String category = request.getParameter("category");

            if (category != null && !category.equals("all")) {

                products = products.stream().filter(p -> p.getProductCategory().equals(category)).collect(Collectors.toList());

                request.setAttribute("category", category);//

            }

            if (sort != null && !sort.equals("no sort-option")) {
                switch (sort) {
                    case "Price (low to high)":
                        products.sort(Comparator.comparing(Products::getProductPrice));
                        break;
                    case "Price (high to low)":
                        products.sort(Comparator.comparing(Products::getProductPrice).reversed());
                        break;
                    case "Alphabet Ascending":
                        products.sort(Comparator.comparing(p -> p.getProductName().toLowerCase()));
                        break;
                    case "Alphabet Descending":
                        products.sort(Comparator.comparing((Products p) -> p.getProductName().toLowerCase()).reversed());
                        break;

                }

                request.setAttribute("sort", sort);
               
            }

            //this is for the category sorting part
            request.setAttribute("products", products);
            request.getRequestDispatcher("/products.jsp").forward(request, response);

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
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("showProd servlet invoked: doGet");
        processRequest(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("showProd servlet invoked: doPost");
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet to display products";
    }
}
