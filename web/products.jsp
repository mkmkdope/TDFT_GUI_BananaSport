<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, model.Products" %>

<% List<Products> productList = (List<Products>) request.getAttribute("products"); %>

<jsp:include page="header.jsp">
    <jsp:param name="pageTitle" value="Products"/>
</jsp:include>

<%
    String category = request.getParameter("category");
    String sort = request.getParameter("sort");
%>

<section class="hero">
    <div class="container">
        <h1>Shop Our Products</h1>
        <p>Browse our wide selection of premium fitness equipment and sports gear to elevate your workout experience.</p>
    </div>
</section>

<!-- Product Filters Section -->
<section class="product-filters">
    <div class="container">
        <div class="filter-container">

            <!-- Categories -->
            <div class="filter-group">
                <h3>Categories</h3>
                <ul class="filter-list">
                    <li><a href="showProd?category=all" class="<%= (category == null || "all".equals(category)) ? "active" : ""%>">All Products</a></li>
                    <li><a href="showProd?category=Cardio Equipment" class="<%= "Cardio Equipment".equals(category) ? "active" : ""%>">Cardio Equipment</a></li>
                    <li><a href="showProd?category=Strength Training" class="<%= "Strength Training".equals(category) ? "active" : ""%>">Strength Training</a></li>
                    <li><a href="showProd?category=Yoga" class="<%= "Yoga".equals(category) ? "active" : ""%>">Yoga & Pilates</a></li>
                    <li><a href="showProd?category=Accessories" class="<%= "Accessories".equals(category) ? "active" : ""%>">Accessories</a></li>
                    <li><a href="showProd?category=clearance" class="<%= "clearance".equals(category) ? "active" : ""%>">Clearance</a></li>
                </ul>
            </div>
                
 

            <!-- Sort By -->
            <div class="filter-group">
                <h3>Sort By</h3>
                <form action="showProd" method="get">
                    <select name="sort" class="sort-select" onchange="this.form.submit()">
                        <option value="no sort-option">None</option>
                        <option value="Price (low to high)" <%= "Price (low to high)".equals(sort) ? "selected" : ""%>>Price: Low to High</option>
                        <option value="Price (high to low)" <%= "Price (high to low)".equals(sort) ? "selected" : ""%>>Price: High to Low</option>
                        <option value="Alphabet Ascending" <%= "Alphabet Ascending".equals(sort) ? "selected" : ""%>>Alphabet ASC (A-Z)</option>
                        <option value="Alphabet Descending" <%= "Alphabet Descending".equals(sort) ? "selected" : ""%>>Alphabet DESC (Z-A)</option>
                    </select>
                    <input type="hidden" name="category" value="<%= category != null ? category : "all"%>">
                </form>
            </div>

        </div>
    </div>
</section>

<!-- Products Display -->
<section class="products-section">
    <div class="container">

        <!-- Title based on Category -->
        <h2 class="section-title">
            <%
                if (category == null || category.equals("all")) {
                    out.print("All Products");
                } else if (category.equals("Cardio Equipment")) {
                    out.print("Cardio Equipment");
                } else if (category.equals("Strength Training")) {
                    out.print("Strength Training");
                } else if (category.equals("Yoga")) {
                    out.print("Yoga & Pilates");
                } else if (category.equals("Accessories")) {
                    out.print("Accessories");
                } else if (category.equals("clearance")) {
                    out.print("Clearance Items");
                } else {
                    out.print("Products");
                }
            %>
        </h2>

        <!-- Selected sort option display -->
        <%
            if (sort != null && !sort.equals("no sort-option")) {
        %>
        <p>Sorted by: <strong><%= sort%></strong></p>
        <%
            }
        %>

        <!-- Product Grid -->
        <div class="products-grid">
            <%
                if (productList == null || productList.isEmpty()) {
            %>
            <p>No products found matching your criteria.</p>
            <%
            } else {
                for (Products product : productList) {
            %>
            <div class="product-card">
                <img src="images/<%= product.getImageLink()%>" alt="<%= product.getProductName()%>" class="product-img"
                     onerror="this.onerror=null; this.src='images/default.png';">
                <div class="product-title"><%= product.getProductName()%></div>
                <div class="product-category">Category: <%= product.getProductCategory()%></div>
                <div class="product-qty">Stock: <%= product.getProductQty()%></div>
                <div class="product-price">Price: $<%= product.getProductPrice()%></div>

                <!-- View Details -->
                <form action="singleProdPage" method="post" style="display:inline;">
                    <input type="hidden" name="productId" value="<%= product.getProductId()%>">
                    <button type="submit" class="btn">View Details</button>
                </form>

                <!-- Add to Cart -->
                <form action="${pageContext.request.contextPath}/AddCart" method="post" style="display:inline;">
                    <input type="hidden" name="productId" value="<%= product.getProductId()%>">
                    <button type="submit" class="btn">Add to Cart</button>
                </form>
            </div>
            <%
                    }
                }
            %>
        </div>

    </div>
</section>

<jsp:include page="footer.jsp"/>
