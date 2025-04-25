<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="header.jsp">
    <jsp:param name="pageTitle" value="Home"/>
</jsp:include>

<style>
    .section-title {
        text-align: center;
        margin: 60px 0 30px;
        font-size: 32px;
        color: var(--primary);
    }

    .categories {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 20px;
        margin-bottom: 60px;
    }

    .category-card {
        position: relative;
        height: 300px;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        transition: transform 0.3s ease;
    }

    .category-card:hover {
        transform: translateY(-10px);
    }

    .category-card img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .category-overlay {
        position: absolute;
        bottom: 0;
        left: 0;
        right: 0;
        background: linear-gradient(to top, rgba(0, 0, 0, 0.8), transparent);
        padding: 20px;
        color: white;
    }

    .category-overlay h3 {
        font-size: 24px;
        margin-bottom: 10px;
    }

    .features {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 30px;
        margin-bottom: 60px;
    }

    .feature {
        text-align: center;
        padding: 30px 20px;
        border-radius: 8px;
        background-color: #333333;
        color: #f8f9fa;
        transition: transform 0.3s ease;
        margin-top:30px;
    }

    .feature:hover {
        transform: translateY(-10px);
        box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
    }

    .feature i {
        font-size: 40px;
        color: #f8f9fa;
        margin-bottom: 20px;
    }

    .feature h3 {
        font-size: 20px;
        margin-bottom: 15px;
        color: #f8f9fa;
    }

    .hero {
        background: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)),
            url("${pageContext.request.contextPath}/images/banana.gif");
        background-size: cover;
        background-position: center;
        height: 50vh;
        display: flex;
        align-items: center;
        color: white;
        text-align: center;
    }

    .about{
        background: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)),
            url("${pageContext.request.contextPath}/images/banner.gif");
        background-size: cover;
        background-position: center;
        height: 70vh;
        display: flex;
        align-items: center;
        color: white;
        text-align: center;

    }
</style>

<!-- Hero Section -->
<section class="hero">
    <div class="container">
        <h1>Welcome to ${applicationScope.companyName}</h1>
        <p>Your one-stop shop for premium fitness equipment and sports gear. We provide high-quality products to help you achieve your fitness goals.</p>
        <a href="${pageContext.request.contextPath}/showProd" class="btn">Shop Now</a>
    </div>
</section>

<!-- category -->
<section class="container">
    <h2 class="section-title">Top Selling Products</h2>
    <div class="categories">
        <div class="category-card">
            <img
                src="${pageContext.request.contextPath}/images/gymBike.jpg"
                alt="Moutain Bike Pro"
                />
            <div class="category-overlay">
                <h3>Mountain Bike Pro</h3>
                <a href="${pageContext.request.contextPath}/showProd" class="btn">Shop Now</a>
            </div>
        </div>
        <div class="category-card">
            <img
                src="${pageContext.request.contextPath}/images/gymMat.jpeg"
                alt="Premium Yoga Mat"
                />
            <div class="category-overlay">
                <h3>Premium Yoga Mat</h3>
                <a href="${pageContext.request.contextPath}/showProd" class="btn">Shop Now</a>
            </div>
        </div>
        <div class="category-card">
            <img
                src="${pageContext.request.contextPath}/images/gymTreadmill.jpg"
                alt="Electric Treadmill X9"
                />
            <div class="category-overlay">
                <h3>Electric Treadmill X9</h3>
                <a href="${pageContext.request.contextPath}/showProd" class="btn">Shop Now</a>
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
                <a href="${pageContext.request.contextPath}/myCustomer/promotions.jsp" class="btn">Learn More</a>
            </div>

            <!-- Festival Promotion -->
            <div class="promotion-card">
                <h3>Summer Fitness Festival</h3>
                <p>Join our annual Summer Fitness Festival and get exclusive deals on all fitness equipment!</p>
                <a href="${pageContext.request.contextPath}/myCustomer/promotions.jsp" class="btn">Learn More</a>
            </div>

            <div class="promotion-card">
                <h3>Black Friday Sale</h3>
                <p>Our biggest sale of the year! Incredible deals on premium fitness equipment with up to 50% off storewide.</p>
                <a href="${pageContext.request.contextPath}/myCustomer/promotions.jsp" class="btn">Learn More</a>
            </div>

            <div class="promotion-card">
                <h3>Holiday Gift Guide</h3>
                <p>Find the perfect fitness gifts for everyone on your list. Get RM25 off when you spend RM75 or more on any products!</p>
                <a href="${pageContext.request.contextPath}/myCustomer/promotions.jsp" class="btn">Learn More</a>
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
        
        <a href="${pageContext.request.contextPath}/staticView/about.jsp" class="btn" style="text-align: center;">Read More</a>
    </div>
</section>
    
<!-- Features -->
<section class="container">
    <div class="features">
        <div class="feature">
            <i class="fas fa-shipping-fast"></i>
            <h3>Free Shipping</h3>
            <p>On all orders over RM1000</p>
        </div>
        <div class="feature">
            <i class="fas fa-undo"></i>
            <h3>Easy Returns</h3>
            <p>30-day return policy</p>
        </div>
        <div class="feature">
            <i class="fas fa-headset"></i>
            <h3>24/7 Support</h3>
            <p>Dedicated support</p>
        </div>
    </div>
</section>
<jsp:include page="footer.jsp" /> 