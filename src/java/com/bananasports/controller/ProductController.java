package com.bananasports.controller;

import com.bananasports.model.Product;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.Query;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ProductController {
    
    private static final Logger logger = Logger.getLogger(ProductController.class.getName());
    private final EntityManagerFactory emf;
    
    public ProductController() {
        try {
            this.emf = Persistence.createEntityManagerFactory("BananaSportsPU");
            logger.info("EntityManagerFactory created successfully");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error creating EntityManagerFactory", e);
            throw e;
        }
    }
    
    public List<Product> findAllProducts() {
        EntityManager em = emf.createEntityManager();
        try {
            logger.info("Fetching all products from database");
            List<Product> products = em.createNamedQuery("Product.findAll", Product.class).getResultList();
            logger.info("Found " + products.size() + " products");
            return products;
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error fetching products", e);
            throw e;
        } finally {
            em.close();
        }
    }
    
    public Product findProductById(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            logger.info("Fetching product with ID: " + id);
            Product product = em.find(Product.class, id);
            if (product != null) {
                logger.info("Found product: " + product.getName());
            } else {
                logger.info("No product found with ID: " + id);
            }
            return product;
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error fetching product with ID: " + id, e);
            throw e;
        } finally {
            em.close();
        }
    }
    
    public void createProduct(Product product) {
        EntityManager em = emf.createEntityManager();
        try {
            logger.info("Creating new product: " + product.getName());
            em.getTransaction().begin();
            em.persist(product);
            em.getTransaction().commit();
            logger.info("Product created successfully with ID: " + product.getId());
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error creating product: " + product.getName(), e);
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }
    
    public void updateProduct(Product product) {
        EntityManager em = emf.createEntityManager();
        try {
            logger.info("Updating product with ID: " + product.getId());
            em.getTransaction().begin();
            em.merge(product);
            em.getTransaction().commit();
            logger.info("Product updated successfully");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error updating product with ID: " + product.getId(), e);
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }
    
    public void deleteProduct(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            logger.info("Deleting product with ID: " + id);
            em.getTransaction().begin();
            Product product = em.find(Product.class, id);
            if (product != null) {
                em.remove(product);
                em.getTransaction().commit();
                logger.info("Product deleted successfully");
            } else {
                em.getTransaction().rollback();
                logger.warning("No product found with ID: " + id);
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error deleting product with ID: " + id, e);
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }
    
    public void close() {
        if (emf != null && emf.isOpen()) {
            logger.info("Closing EntityManagerFactory");
            emf.close();
        }
    }
} 