<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<jsp:include page="/header.jsp">
    <jsp:param name="pageTitle" value="Promotions"/>
</jsp:include>

    <!-- Promotions Hero Section -->
    <section class="hero">
        <div class="container">
            <h1>Special Promotions !!!</h1>
        </div>
    </section>

    <!-- Current Promotions Section -->
    <section class="current-promotions">
        <div class="container">
            <h2 class="section-title">Current Offers</h2>
            
            <%
            // Check if user is logged in
            boolean isLoggedIn = session.getAttribute("customerId") != null;
            
            try {
                // Use your existing DBConnection class
                DBConnection dbConn = new DBConnection();
                Connection conn = dbConn.getConnection();
                
                // Get active promotions - simplified to just show all active promotions
                String query = "SELECT * FROM Promotions WHERE is_active = TRUE";
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(query);
                
                boolean hasPromotions = false;
                
                while (rs.next()) {
                    hasPromotions = true;
                    int promotionId = rs.getInt("promotion_id");
                    String promotionName = rs.getString("promotion_name");
                    String description = rs.getString("description");
                    String promotionType = rs.getString("promotion_type");
                    double discountValue = rs.getDouble("discount_value");
                    double minPurchaseAmount = rs.getDouble("min_purchase_amount");
                    String applicableTo = rs.getString("applicable_to");
                    
                    // Determine badge text
                    String badgeText = "";
                    if ("percentage".equals(promotionType)) {
                        badgeText = (int)discountValue + "% OFF";
                    } else if ("fixed_amount".equals(promotionType)) {
                        badgeText = "$" + (int)discountValue + " OFF";
                    }
                    
                    // Use single default image for all promotions
                    String imagePath = "images/promo.png";
                    
                    // Determine browse URL for related products
                    String browseUrl = "products.jsp";
                    if (!"all".equals(applicableTo) && applicableTo != null) {
                        browseUrl += "?category=" + applicableTo;
                    }
            %>
            <div class="promotion-block" id="<%= "promo" + promotionId %>">
                <div class="promotion-content">
                    <div class="promotion-image">
                        <img src="${pageContext.request.contextPath}/<%= imagePath %>" alt="<%= promotionName %>" class="img-responsive">
                    </div>
                    <div class="promotion-details">
                        <h3><%= promotionName %></h3>
                        <div class="promotion-badge"><%= badgeText %></div>
                        <p><%= description != null ? description : "" %></p>
                        
                        <% if ("percentage".equals(promotionType) || "fixed_amount".equals(promotionType)) { %>
                            <h4>Promotion Details:</h4>
                            <ul>
                                <% if ("percentage".equals(promotionType)) { %>
                                    <li><%= (int)discountValue %>% off 
                                    <% if ("all".equals(applicableTo)) { %>
                                        all products
                                    <% } else { %>
                                        <%= applicableTo %> products
                                    <% } %>
                                    </li>
                                <% } else if ("fixed_amount".equals(promotionType)) { %>
                                    <li>$<%= (int)discountValue %> off 
                                    <% if ("all".equals(applicableTo)) { %>
                                        all products
                                    <% } else { %>
                                        <%= applicableTo %> products
                                    <% } %>
                                    </li>
                                <% } %>
                                
                                <% if (minPurchaseAmount > 0) { %>
                                    <li>Minimum purchase amount: $<%= String.format("%.2f", minPurchaseAmount) %></li>
                                <% } %>
                            </ul>
                        <% } %>
                        
                        <div class="promotion-actions">
                            <% if (isLoggedIn) { %>
                                <form action="${pageContext.request.contextPath}/ApplyPromotion" method="post">
                                    <input type="hidden" name="promotionId" value="<%= promotionId %>">
                                    <button type="submit" class="btn">Apply to My Cart</button>
                                </form>
                            <% } else { %>
                                <a href="${pageContext.request.contextPath}/login.jsp?redirect=promotions.jsp" class="btn">Login to Apply</a>
                            <% } %>
                           
                        </div>
                    </div>
                </div>
            </div>
            <%
                }
                
                if (!hasPromotions) {
            %>
                <div class="no-promotions">
                    <p>There are currently no active promotions. Please check back soon for new offers!</p>
                </div>
            <%
                }
                
                rs.close();
                stmt.close();
                conn.close();
            } catch (Exception e) {
                out.println("<div style='color:red;'>Error loading promotions: " + e.getMessage() + "</div>");
                e.printStackTrace();
            }
            %>
        </div>
    </section>

<style>
    .promotion-actions {
        margin-top: 20px;
        display: flex;
        gap: 10px;
    }
    
    .btn-outline {
        background-color: transparent;
        border: 1px solid #007bff;
        color: #007bff;
    }
    
    .btn-outline:hover {
        background-color: #f8f9fa;
    }
</style>

<jsp:include page="/footer.jsp" /> 