package servlet;

import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter("/*")
public class AuthorizationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        
        // Check if the requested URI is publicly accessible
        if (isPublicPage(requestURI, contextPath) || isPublicResource(requestURI) || isResourceFile(requestURI)) {
            chain.doFilter(request, response);
            return;
        }
        
        // Check if the request is add-to-cart or cart-related
        if (isCartOrPaymentPage(requestURI) || requestURI.contains("CartOperationServlet") || requestURI.contains("addToCart")) {
            // Check if there's a session or if it contains customer attribute
            if (session == null) {
                // No session at all, redirect to login
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp");
                return;
            }
            
            // Check if the customer information exists in the session
            Object customerObj = session.getAttribute("customer");
            Object customerId = session.getAttribute("customerId");
            Object customerLoggedIn = session.getAttribute("customerLoggedIn");
            
            // If any customer session attribute is present, consider them logged in
            if (customerObj != null || customerId != null || (customerLoggedIn != null && ((Boolean)customerLoggedIn))) {
                // Customer is logged in, allow access
                chain.doFilter(request, response);
                return;
            } else {
                // No customer session found, redirect to login
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp");
                return;
            }
        }
        
        // Check if user is logged in for non-public pages (staff/admin)
        if (session == null || session.getAttribute("loggedIn") == null 
                || !(Boolean)session.getAttribute("loggedIn")) {
            // Not logged in, redirect to login page
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp");
            return;
        }
        
        // User is logged in, check role-based access
        boolean isManager = session.getAttribute("isManager") != null ? 
                (Boolean)session.getAttribute("isManager") : false;
        
        // Access control based on roles
        if (requestURI.contains("/AdminModule.jsp") && !isManager) {
            // Staff trying to access manager-only page
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/myStaff/controlPanelM.jsp");
            return;
        }
        
        // Allow the request to proceed
        chain.doFilter(request, response);
    }
    
    private boolean isCartOrPaymentPage(String uri) {
        return uri.contains("/cart") || 
               uri.contains("/Cart") || 
               uri.contains("/checkout") || 
               uri.contains("/payment") ||
               uri.contains("/Payment") || 
               uri.contains("/order") || 
               uri.contains("/Order");
    }
    
    private boolean isPublicPage(String uri, String contextPath) {
        // Root and index
        if (uri.equals(contextPath + "/") || uri.equals(contextPath + "/index.jsp")) {
            return true;
        }
        
        // Login pages
        if (uri.contains("/login.jsp") || 
            uri.contains("/loginC.jsp") || 
            uri.contains("/loginM.jsp")) {
            return true;
        }
        
        // Product-related pages
        if (uri.contains("/products.jsp") || 
            uri.contains("/showProd") || 
            uri.contains("/searchProd") || 
            uri.contains("/singleProdPage")) {
            return true;
        }
        
        // Information pages
        if (uri.contains("/about.jsp") || 
            uri.contains("/contact.jsp") || 
            uri.contains("/promotions.jsp")) {
            return true;
        }
        
        // Customer authentication
        if (uri.contains("/myCustomer/loginC.jsp") ||
            uri.contains("/customerRegister.jsp") ||
            uri.contains("/customerLogin") ||
            uri.contains("/RegisterServlet")) {
            return true;
        }
        
        return false;
    }
    
    private boolean isPublicResource(String uri) {
        return uri.endsWith("loginM.jsp") || 
               uri.endsWith("/StaffManagerLogin") ||
               uri.endsWith("/LogoutServlet") ||
               uri.endsWith("/error.jsp");
    }
    
    private boolean isResourceFile(String uri) {
        return uri.contains("/css/") || 
               uri.contains("/js/") || 
               uri.contains("/images/") ||
               uri.endsWith(".css") ||
               uri.endsWith(".js") ||
               uri.endsWith(".jpg") ||
               uri.endsWith(".png") ||
               uri.endsWith(".gif");
    }

    @Override
    public void destroy() {
        // Cleanup code if needed
    }
} 