package com.bananasports.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "ContactFormServlet", urlPatterns = {"/contact-form-handler"})
public class ContactFormServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get form data
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");
        
        // In a real application, you would:
        // 1. Validate the form data
        // 2. Store the message in a database
        // 3. Send an email notification
        // 4. Possibly send a confirmation email to the user
        
        // For this demo, we'll just set a success message and redirect back to the contact page
        request.getSession().setAttribute("contactMessage", "Thank you for your message, " + name + "! We will get back to you soon.");
        
        // Redirect to contact page
        response.sendRedirect(request.getContextPath() + "/contact.jsp");
    }
} 