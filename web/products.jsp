<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="header.jsp">
    <jsp:param name="pageTitle" value="Products"/>
</jsp:include>

    <!-- Hero Section for Products -->
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
                <div class="filter-group">
                    <h3>Categories</h3>
                    <ul class="filter-list">
                        <li><a href="products.jsp?category=all" class="<%= request.getParameter("category") == null || "all".equals(request.getParameter("category")) ? "active" : "" %>">All Products</a></li>
                        <li><a href="products.jsp?category=cardio" class="<%= "cardio".equals(request.getParameter("category")) ? "active" : "" %>">Cardio Equipment</a></li>
                        <li><a href="products.jsp?category=strength" class="<%= "strength".equals(request.getParameter("category")) ? "active" : "" %>">Strength Training</a></li>
                        <li><a href="products.jsp?category=yoga" class="<%= "yoga".equals(request.getParameter("category")) ? "active" : "" %>">Yoga & Pilates</a></li>
                        <li><a href="products.jsp?category=accessories" class="<%= "accessories".equals(request.getParameter("category")) ? "active" : "" %>">Accessories</a></li>
                        <li><a href="products.jsp?category=clearance" class="<%= "clearance".equals(request.getParameter("category")) ? "active" : "" %>">Clearance</a></li>
                    </ul>
                </div>
                
                <div class="filter-group">
                    <h3>Price Range</h3>
                    <form action="products.jsp" method="get" class="price-filter">
                        <div class="price-inputs">
                            <div class="price-input">
                                <label for="min-price">Min:</label>
                                <input type="number" id="min-price" name="min_price" placeholder="$0" min="0" value="${param.min_price}">
                            </div>
                            <div class="price-input">
                                <label for="max-price">Max:</label>
                                <input type="number" id="max-price" name="max_price" placeholder="$2000" min="0" value="${param.max_price}">
                            </div>
                        </div>
                        <input type="hidden" name="category" value="${param.category}">
                        <button type="submit" class="btn">Apply</button>
                    </form>
                </div>
                
                <div class="filter-group">
                    <h3>Sort By</h3>
                    <select id="sort-options" class="sort-select">
                        <option value="popularity">Popularity</option>
                        <option value="price-low">Price: Low to High</option>
                        <option value="price-high">Price: High to Low</option>
                        <option value="newest">Newest First</option>
                    </select>
                </div>
            </div>
        </div>
    </section>

    <!-- Products Section -->
    <section class="products-section">
        <div class="container">
            <!-- Display category title based on parameter -->
            <h2 class="section-title">
                <% 
                String categoryParam = request.getParameter("category");
                if (categoryParam == null || categoryParam.equals("all")) {
                    out.print("All Products");
                } else if (categoryParam.equals("cardio")) {
                    out.print("Cardio Equipment");
                } else if (categoryParam.equals("strength")) {
                    out.print("Strength Training");
                } else if (categoryParam.equals("yoga")) {
                    out.print("Yoga & Pilates");
                } else if (categoryParam.equals("accessories")) {
                    out.print("Accessories");
                } else if (categoryParam.equals("clearance")) {
                    out.print("Clearance Items");
                }
                %>
            </h2>
            
            <div class="products-grid">
                <!-- Cardio Equipment Products -->
                <% if (categoryParam == null || categoryParam.equals("all") || categoryParam.equals("cardio")) { %>
                    <!-- Product 1 -->
                    <div class="product-card">
                        <div class="product-badge new">New</div>
                        <img src="images/treadmill.jpeg" alt="Treadmill" class="product-img">
                        <div class="product-info">
                            <h3 class="product-title">Premium Treadmill</h3>
                            <p class="product-category">Cardio Equipment</p>
                            <p class="product-price">$999.99</p>
                            <div class="product-rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star-half-alt"></i>
                                <span>(42)</span>
                            </div>
                            <button class="add-to-cart">Add to Cart</button>
                            <a href="product-detail.jsp?id=1" class="btn-outline">View Details</a>
                        </div>
                    </div>
                    
                    <!-- Product 2 -->
                    <div class="product-card">
                        <img src="images/bike.jpg" alt="Exercise Bike" class="product-img">
                        <div class="product-info">
                            <h3 class="product-title">Indoor Exercise Bike</h3>
                            <p class="product-category">Cardio Equipment</p>
                            <p class="product-price">$499.99</p>
                            <div class="product-rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="far fa-star"></i>
                                <span>(28)</span>
                            </div>
                            <button class="add-to-cart">Add to Cart</button>
                            <a href="product-detail.jsp?id=2" class="btn-outline">View Details</a>
                        </div>
                    </div>
                    
                    <!-- Product 3 -->
                    <div class="product-card">
                        <div class="product-badge sale">Sale</div>
                        <img src="images/elliptical.jpg" alt="Elliptical Trainer" class="product-img">
                        <div class="product-info">
                            <h3 class="product-title">Elliptical Trainer</h3>
                            <p class="product-category">Cardio Equipment</p>
                            <p class="product-price"><span class="original-price">$799.99</span> $649.99</p>
                            <div class="product-rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <span>(56)</span>
                            </div>
                            <button class="add-to-cart">Add to Cart</button>
                            <a href="product-detail.jsp?id=3" class="btn-outline">View Details</a>
                        </div>
                    </div>
                <% } %>
                
                <!-- Strength Training Products -->
                <% if (categoryParam == null || categoryParam.equals("all") || categoryParam.equals("strength")) { %>
                    <!-- Product 4 -->
                    <div class="product-card">
                        <img src="images/dumbbell.jpeg" alt="Dumbbells" class="product-img">
                        <div class="product-info">
                            <h3 class="product-title">Adjustable Dumbbells Set</h3>
                            <p class="product-category">Strength Training</p>
                            <p class="product-price">$299.99</p>
                            <div class="product-rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star-half-alt"></i>
                                <span>(63)</span>
                            </div>
                            <button class="add-to-cart">Add to Cart</button>
                            <a href="product-detail.jsp?id=4" class="btn-outline">View Details</a>
                        </div>
                    </div>
                    
                    <!-- Product 5 -->
                    <div class="product-card">
                        <img src="images/weight-bench.jpg" alt="Weight Bench" class="product-img">
                        <div class="product-info">
                            <h3 class="product-title">Adjustable Weight Bench</h3>
                            <p class="product-category">Strength Training</p>
                            <p class="product-price">$199.99</p>
                            <div class="product-rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="far fa-star"></i>
                                <span>(35)</span>
                            </div>
                            <button class="add-to-cart">Add to Cart</button>
                            <a href="product-detail.jsp?id=5" class="btn-outline">View Details</a>
                        </div>
                    </div>
                    
                    <!-- Product 6 -->
                    <div class="product-card">
                        <img src="images/kettlebell.jpg" alt="Kettlebell" class="product-img">
                        <div class="product-info">
                            <h3 class="product-title">Kettlebell Set</h3>
                            <p class="product-category">Strength Training</p>
                            <p class="product-price">$149.99</p>
                            <div class="product-rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="far fa-star"></i>
                                <span>(42)</span>
                            </div>
                            <button class="add-to-cart">Add to Cart</button>
                            <a href="product-detail.jsp?id=6" class="btn-outline">View Details</a>
                        </div>
                    </div>
                <% } %>
                
                <!-- Yoga & Pilates Products -->
                <% if (categoryParam == null || categoryParam.equals("all") || categoryParam.equals("yoga")) { %>
                    <!-- Product 7 -->
                    <div class="product-card">
                        <img src="images/yoga.jpeg" alt="Yoga Mat" class="product-img">
                        <div class="product-info">
                            <h3 class="product-title">Premium Yoga Mat</h3>
                            <p class="product-category">Yoga & Pilates</p>
                            <p class="product-price">$49.99</p>
                            <div class="product-rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <span>(89)</span>
                            </div>
                            <button class="add-to-cart">Add to Cart</button>
                            <a href="product-detail.jsp?id=7" class="btn-outline">View Details</a>
                        </div>
                    </div>
                    
                    <!-- Product 8 -->
                    <div class="product-card">
                        <img src="images/yoga-block.jpg" alt="Yoga Block" class="product-img">
                        <div class="product-info">
                            <h3 class="product-title">Yoga Block Set</h3>
                            <p class="product-category">Yoga & Pilates</p>
                            <p class="product-price">$24.99</p>
                            <div class="product-rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="far fa-star"></i>
                                <span>(37)</span>
                            </div>
                            <button class="add-to-cart">Add to Cart</button>
                            <a href="product-detail.jsp?id=8" class="btn-outline">View Details</a>
                        </div>
                    </div>
                <% } %>
                
                <!-- Accessories Products -->
                <% if (categoryParam == null || categoryParam.equals("all") || categoryParam.equals("accessories")) { %>
                    <!-- Product 9 -->
                    <div class="product-card">
                        <img src="images/resistance-bands.jpg" alt="Resistance Bands" class="product-img">
                        <div class="product-info">
                            <h3 class="product-title">Resistance Bands Set</h3>
                            <p class="product-category">Accessories</p>
                            <p class="product-price">$29.99</p>
                            <div class="product-rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star-half-alt"></i>
                                <span>(54)</span>
                            </div>
                            <button class="add-to-cart">Add to Cart</button>
                            <a href="product-detail.jsp?id=9" class="btn-outline">View Details</a>
                        </div>
                    </div>
                    
                    <!-- Product 10 -->
                    <div class="product-card">
                        <div class="product-badge new">New</div>
                        <img src="images/water-bottle.jpg" alt="Water Bottle" class="product-img">
                        <div class="product-info">
                            <h3 class="product-title">Insulated Water Bottle</h3>
                            <p class="product-category">Accessories</p>
                            <p class="product-price">$19.99</p>
                            <div class="product-rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="far fa-star"></i>
                                <span>(28)</span>
                            </div>
                            <button class="add-to-cart">Add to Cart</button>
                            <a href="product-detail.jsp?id=10" class="btn-outline">View Details</a>
                        </div>
                    </div>
                <% } %>
                
                <!-- Clearance Products -->
                <% if (categoryParam == null || categoryParam.equals("all") || categoryParam.equals("clearance")) { %>
                    <!-- Product 11 -->
                    <div class="product-card">
                        <div class="product-badge clearance">Clearance</div>
                        <img src="images/old-treadmill.jpg" alt="Basic Treadmill" class="product-img">
                        <div class="product-info">
                            <h3 class="product-title">Basic Treadmill</h3>
                            <p class="product-category">Cardio Equipment</p>
                            <p class="product-price"><span class="original-price">$799.99</span> $479.99</p>
                            <div class="product-rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="far fa-star"></i>
                                <i class="far fa-star"></i>
                                <span>(15)</span>
                            </div>
                            <button class="add-to-cart">Add to Cart</button>
                            <a href="product-detail.jsp?id=11" class="btn-outline">View Details</a>
                        </div>
                    </div>
                    
                    <!-- Product 12 -->
                    <div class="product-card">
                        <div class="product-badge clearance">Clearance</div>
                        <img src="images/old-bike.jpg" alt="Basic Exercise Bike" class="product-img">
                        <div class="product-info">
                            <h3 class="product-title">Basic Exercise Bike</h3>
                            <p class="product-category">Cardio Equipment</p>
                            <p class="product-price"><span class="original-price">$399.99</span> $259.99</p>
                            <div class="product-rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star-half-alt"></i>
                                <i class="far fa-star"></i>
                                <span>(22)</span>
                            </div>
                            <button class="add-to-cart">Add to Cart</button>
                            <a href="product-detail.jsp?id=12" class="btn-outline">View Details</a>
                        </div>
                    </div>
                <% } %>
            </div>
            
            <!-- Pagination -->
            <div class="pagination">
                <a href="#" class="pagination-link active">1</a>
                <a href="#" class="pagination-link">2</a>
                <a href="#" class="pagination-link">3</a>
                <span class="pagination-ellipsis">...</span>
                <a href="#" class="pagination-link">10</a>
                <a href="#" class="pagination-link next">Next <i class="fas fa-chevron-right"></i></a>
            </div>
        </div>
    </section>

<jsp:include page="footer.jsp" /> 