<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="servlet.DBConnection" %>

<%
    // Check if user is logged in
    if (session.getAttribute("loggedIn") == null || !(Boolean) session.getAttribute("loggedIn")) {
        response.sendRedirect(request.getContextPath() + "/myCustomer/loginC.jsp");
        return;
    }

    // Get user info from session
    Integer customerId = (Integer) session.getAttribute("customerId");
    String username = (String) session.getAttribute("username");
    String customerName = (String) session.getAttribute("customerName");
    String email = (String) session.getAttribute("email");
    
    // Additional customer details from database
    String contactNumber = "";
    
    // Database connection
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        // Get database connection
        DBConnection db = new DBConnection();
        conn = db.getConnection();
        
        // Get customer details
        String sql = "SELECT * FROM CUSTOMERS WHERE customer_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, customerId);
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
            contactNumber = rs.getString("contact_number");
            // Update session variables in case they were modified elsewhere
            customerName = rs.getString("customer_name");
            email = rs.getString("email");
            session.setAttribute("customerName", customerName);
            session.setAttribute("email", email);
        }
        
    } catch (SQLException e) {
        e.printStackTrace();
        request.setAttribute("error", "Database error: " + e.getMessage());
    } finally {
        // Close resources
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

<jsp:include page="/header.jsp">
    <jsp:param name="pageTitle" value="My Profile"/>
</jsp:include>

<div class="container" style="max-width: 800px; margin: 30px auto; padding: 20px; background-color: white; border-radius: 5px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
    <h1 style="color: #333; margin-bottom: 30px; text-align: center;">My Profile</h1>
    
    <!-- Show error/success messages if any -->
    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger" style="background-color: #f8d7da; color: #721c24; padding: 10px; border-radius: 4px; margin-bottom: 20px;">
            <%= request.getAttribute("error") %>
        </div>
    <% } %>
    
    <% if (request.getAttribute("success") != null) { %>
        <div class="alert alert-success" style="background-color: #d4edda; color: #155724; padding: 10px; border-radius: 4px; margin-bottom: 20px;">
            <%= request.getAttribute("success") %>
        </div>
    <% } %>

    <div class="profile-section" style="background-color: #f9f9f9; padding: 20px; border-radius: 5px; margin-bottom: 30px;">
        <h2 style="color: #555; margin-bottom: 20px;">Account Information</h2>
        
        <div class="profile-info" style="display: flex; flex-wrap: wrap;">
            <div style="flex: 1; min-width: 300px; margin-bottom: 20px;">
                <p><strong>Username:</strong> <%= username %></p>
                <p><strong>Full Name:</strong> <%= customerName %></p>
                <p><strong>Email:</strong> <%= email %></p>
                <p><strong>Contact Number:</strong> <%= contactNumber %></p>
            </div>
        </div>
        
        <div style="margin-top: 20px;">
            <button onclick="toggleEditForm()" style="background-color: #FFC107; color: #212121; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer;">
                Edit Profile
            </button>
        </div>
    </div>
    
    <!-- Edit Profile Form (Hidden by default) -->
    <div id="editProfileForm" style="display: none; background-color: #f9f9f9; padding: 20px; border-radius: 5px;">
        <h2 style="color: #555; margin-bottom: 20px;">Edit Profile</h2>
        
        <form action="${pageContext.request.contextPath}/UpdateProfileServlet" method="post" style="max-width: 500px; margin: 0 auto;">
            <div style="margin-bottom: 15px;">
                <label for="customerName" style="display: block; margin-bottom: 5px; font-weight: bold;">Full Name:</label>
                <input type="text" id="customerName" name="customerName" value="<%= customerName %>" required 
                       style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
            </div>
            
            <div style="margin-bottom: 15px;">
                <label for="email" style="display: block; margin-bottom: 5px; font-weight: bold;">Email:</label>
                <input type="email" id="email" name="email" value="<%= email %>" required 
                       style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
            </div>
            
            <div style="margin-bottom: 15px;">
                <label for="contactNumber" style="display: block; margin-bottom: 5px; font-weight: bold;">Contact Number:</label>
                <input type="text" id="contactNumber" name="contactNumber" value="<%= contactNumber %>" required 
                       style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
            </div>
            
            <div style="margin-bottom: 15px;">
                <label for="currentPassword" style="display: block; margin-bottom: 5px; font-weight: bold;">Current Password (required to save changes):</label>
                <input type="password" id="currentPassword" name="currentPassword" required 
                       style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
            </div>
            
            <div style="margin-top: 25px; border-top: 1px solid #ddd; padding-top: 15px;">
                <h3 style="margin-bottom: 15px;">Change Password (Optional)</h3>
                
                <div style="margin-bottom: 15px;">
                    <label for="newPassword" style="display: block; margin-bottom: 5px; font-weight: bold;">New Password:</label>
                    <input type="password" id="newPassword" name="newPassword" 
                           style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
                </div>
                
                <div style="margin-bottom: 15px;">
                    <label for="confirmPassword" style="display: block; margin-bottom: 5px; font-weight: bold;">Confirm New Password:</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" 
                           style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
                </div>
            </div>
            
            <div style="margin-top: 20px; display: flex; justify-content: space-between;">
                <button type="button" onclick="toggleEditForm()" style="background-color: #f44336; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer;">
                    Cancel
                </button>
                <button type="submit" style="background-color: #4CAF50; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer;">
                    Save Changes
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    function toggleEditForm() {
        var form = document.getElementById('editProfileForm');
        var currentDisplay = form.style.display;
        form.style.display = currentDisplay === 'none' ? 'block' : 'none';
    }
</script>

<jsp:include page="/footer.jsp" /> 