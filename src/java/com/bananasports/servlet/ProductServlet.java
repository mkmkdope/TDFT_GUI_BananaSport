package com.bananasports.servlet;

import com.bananasports.controller.ProductController;
import com.bananasports.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "ProductServlet", urlPatterns = {"/product"})
public class ProductServlet extends HttpServlet {
    
    private static final Logger logger = Logger.getLogger(ProductServlet.class.getName());
    private ProductController productController;
    
    @Override
    public void init() throws ServletException {
        try {
            productController = new ProductController();
            logger.info("ProductServlet initialized successfully");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error initializing ProductServlet", e);
            throw new ServletException(e);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        logger.info("Processing GET request with action: " + action);
        
        try {
            switch (action) {
                case "new":
                    showNewForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteProduct(request, response);
                    break;
                default:
                    listProducts(request, response);
                    break;
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error processing GET request", e);
            throw new ServletException(e);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        logger.info("Processing POST request with action: " + action);
        
        try {
            switch (action) {
                case "create":
                    createProduct(request, response);
                    break;
                case "update":
                    updateProduct(request, response);
                    break;
                default:
                    listProducts(request, response);
                    break;
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error processing POST request", e);
            throw new ServletException(e);
        }
    }
    
    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            logger.info("Fetching all products");
            List<Product> products = productController.findAllProducts();
            logger.info("Found " + products.size() + " products");
            request.setAttribute("products", products);
            request.getRequestDispatcher("/products.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error listing products", e);
            throw new ServletException(e);
        }
    }
    
    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        logger.info("Showing new product form");
        request.getRequestDispatcher("/product-form.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Long id = Long.parseLong(request.getParameter("id"));
            logger.info("Showing edit form for product ID: " + id);
            Product product = productController.findProductById(id);
            request.setAttribute("product", product);
            request.getRequestDispatcher("/product-form.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            logger.warning("Invalid product ID format");
            response.sendRedirect(request.getContextPath() + "/product");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error showing edit form", e);
            throw new ServletException(e);
        }
    }
    
    private void createProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            String imageUrl = request.getParameter("imageUrl");
            Integer stockQuantity = Integer.parseInt(request.getParameter("stockQuantity"));
            String category = request.getParameter("category");
            
            logger.info("Creating new product: " + name);
            
            Product product = new Product(name, description, price, stockQuantity, category, imageUrl);
            productController.createProduct(product);
            
            logger.info("Product created successfully");
            response.sendRedirect(request.getContextPath() + "/product");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error creating product", e);
            throw new ServletException(e);
        }
    }
    
    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Long id = Long.parseLong(request.getParameter("id"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            String imageUrl = request.getParameter("imageUrl");
            Integer stockQuantity = Integer.parseInt(request.getParameter("stockQuantity"));
            String category = request.getParameter("category");
            
            logger.info("Updating product with ID: " + id);
            
            Product product = new Product(name, description, price, stockQuantity, category, imageUrl);
            product.setId(id);
            productController.updateProduct(product);
            
            logger.info("Product updated successfully");
            response.sendRedirect(request.getContextPath() + "/product");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error updating product", e);
            throw new ServletException(e);
        }
    }
    
    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Long id = Long.parseLong(request.getParameter("id"));
            logger.info("Deleting product with ID: " + id);
            productController.deleteProduct(id);
            logger.info("Product deleted successfully");
        } catch (NumberFormatException e) {
            logger.warning("Invalid product ID format");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error deleting product", e);
            throw new ServletException(e);
        }
        
        response.sendRedirect(request.getContextPath() + "/product");
    }
    
    @Override
    public void destroy() {
        if (productController != null) {
            logger.info("Destroying ProductServlet");
            productController.close();
        }
    }
} 