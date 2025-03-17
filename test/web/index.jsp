<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="header.jsp">
    <jsp:param name="pageTitle" value="Home"/>
</jsp:include>

    <!-- Hero Section -->
    <section class="hero">
        <div class="container">
            <h1>Welcome to ${applicationScope.companyName}</h1>
            <p>Your one-stop shop for premium fitness equipment and sports gear. We provide high-quality products to help you achieve your fitness goals.</p>
            <a href="products.jsp" class="btn">Shop Now</a>
        </div>
    </section>

    <!-- Featured Products Section -->
    <section class="featured-products">
        <div class="container">
            <h2 class="section-title">Top Selling Products</h2>
            <div class="products-grid">
                <!-- Product 1 -->
                <div class="product-card">
                    <img src="images/product1.jpg" alt="Treadmill" class="product-img">
                    <div class="product-info">
                        <h3 class="product-title">Premium Treadmill</h3>
                        <p class="product-price">$999.99</p>
                        <button class="add-to-cart">Add to Cart</button>
                    </div>
                </div>
                
                <!-- Product 2 -->
                <div class="product-card">
                    <img src="images/product2.jpg" alt="Dumbbells" class="product-img">
                    <div class="product-info">
                        <h3 class="product-title">Adjustable Dumbbells Set</h3>
                        <p class="product-price">$299.99</p>
                        <button class="add-to-cart">Add to Cart</button>
                    </div>
                </div>
                
                <!-- Product 3 -->
                <div class="product-card">
                    <img src="images/product3.jpg" alt="Exercise Bike" class="product-img">
                    <div class="product-info">
                        <h3 class="product-title">Indoor Exercise Bike</h3>
                        <p class="product-price">$499.99</p>
                        <button class="add-to-cart">Add to Cart</button>
                    </div>
                </div>
                
                <!-- Product 4 -->
                <div class="product-card">
                    <img src="images/product4.jpg" alt="Yoga Mat" class="product-img">
                    <div class="product-info">
                        <h3 class="product-title">Premium Yoga Mat</h3>
                        <p class="product-price">$49.99</p>
                        <button class="add-to-cart">Add to Cart</button>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Promotions Section -->
    <section class="promotions">
        <div class="container">
            <h2 class="section-title">Special Promotions</h2>
            <div class="products-grid">
                <!-- Birthday Promotion -->
                <div class="promotion-card">
                    <h3>Birthday Special</h3>
                    <p>Get 20% off on your birthday! Register now and enjoy special discounts on your special day.</p>
                    <a href="promotions.jsp#birthday" class="btn">Learn More</a>
                </div>
                
                <!-- Festival Promotion -->
                <div class="promotion-card">
                    <h3>Summer Fitness Festival</h3>
                    <p>Join our annual Summer Fitness Festival and get exclusive deals on all fitness equipment!</p>
                    <a href="promotions.jsp#festival" class="btn">Learn More</a>
                </div>
            </div>
        </div>
    </section>

    <!-- About Section -->
    <section class="about">
        <div class="container">
            <h2 class="section-title">About ${applicationScope.companyName}</h2>
            <p>
                ${applicationScope.companyName} is a premier fitness and sports equipment retailer dedicated to helping you achieve your fitness goals. 
                We offer a wide range of high-quality fitness equipment, from treadmills and exercise bikes to weights and yoga accessories.
            </p>
            <p>
                Our mission is to make fitness accessible to everyone by providing top-notch equipment at competitive prices. 
                With years of experience in the fitness industry, we understand what our customers need and strive to exceed their expectations.
            </p>
            <a href="about.jsp" class="btn">Read More</a>
        </div>
    </section>

<jsp:include page="footer.jsp" /> 