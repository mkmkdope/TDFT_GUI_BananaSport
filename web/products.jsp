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
<style>
    /* Container */
    .container {
        width: 90%;
        max-width: 1300px;
        margin: 0 auto;
    }

    /* Hero Section */
    .hero {
        background: black;
        color: white;
        padding: 30px 0;
        text-align: center;
        border-radius: 8px;
    }

    /* Product Filters */
    .product-filters {
        margin-bottom: 30px;
    }

    .filter-container {
        display: flex;
        flex-wrap: wrap;
        gap: 30px;
        justify-content: center;
    }

    .filter-group {
        background: white;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        width: 250px;
    }


    .filter-list {
        list-style: none;
        padding: 0;
    }

    .filter-list li {
        margin-bottom: 10px;
    }

    .filter-list li a {
        color: #333;
        text-decoration: none;
    }

    .filter-list li a.active {
        color: #fbc02d; /* Yellow color for active link */
        font-weight: bold;
    }

    .sort-select {
        width: 100%;
        padding: 8px;
        border: 1px solid #ddd;
        border-radius: 5px;
    }

    /* Products Section */
    .products-section {
        padding: 30px 0;
    }

    .section-title {
        text-align: center;
        margin-bottom: 20px;
        font-size: 2rem;
    }

    /* Products Grid */
    .products-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
        gap: 20px;
    }

    /* Product Card */
    .product-card {
        background: white;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        text-align: center;
        padding: 20px;
        transition: transform 0.2s ease;
    }

    .product-card:hover {
        transform: translateY(-5px);
    }

    .product-img {
        width: 100%;
        height: 200px;
        object-fit: cover;
        margin-bottom: 15px;
    }

    .product-title {
        font-size: 1.2rem;
        margin-bottom: 8px;
        font-weight: bold;
    }

    .product-category,
    .product-qty,
    .product-price {
        font-size: 0.95rem;
        margin-bottom: 5px;
    }
    
    /* Buttons */
    .btn {
        background: linear-gradient(to right, #fdd835, #fbc02d); /* Yellow gradient */
        border: none;
        color: #333; /* Darker text for better contrast */
        padding: 8px 15px;
        margin: 5px;
        border-radius: 20px;
        cursor: pointer;
        transition: background 0.3s ease, color 0.3s ease;
        font-weight: bold;
    }

    .btn:hover {
        background: linear-gradient(to right, #f9a825, #fbc02d); /* Darker yellow on hover */
        color: white; /* Text turns white on hover */
    }
</style>

<section class="hero">
    <div class="container">
        <h1>Shop Our Products</h1>
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
