package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "InitServlet", urlPatterns = {"/init"}, loadOnStartup = 1)
public class InitServlet extends HttpServlet {
    
    @Override
    public void init() throws ServletException {
        // Get application-wide parameters from web.xml
        String companyName = getServletContext().getInitParameter("companyName");
        String companyEmail = getServletContext().getInitParameter("companyEmail");
        String companyCopyright = getServletContext().getInitParameter("companyCopyright");
        
        // Set attributes in application scope
        getServletContext().setAttribute("companyName", companyName);
        getServletContext().setAttribute("companyEmail", companyEmail);
        getServletContext().setAttribute("companyCopyright", companyCopyright);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
} 