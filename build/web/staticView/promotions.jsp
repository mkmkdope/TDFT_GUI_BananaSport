<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="/header.jsp">
    <jsp:param name="pageTitle" value="Promotions"/>
</jsp:include>

    <!-- Promotions Hero Section -->
    <section class="hero">
        <div class="container">
            <h1>Special Promotions at ${applicationScope.companyName}</h1>
            <p>Take advantage of our exclusive deals and limited-time offers on premium fitness equipment.</p>
        </div>
    </section>

    <!-- Current Promotions Section -->
    <section class="current-promotions">
        <div class="container">
            <h2 class="section-title">Current Offers</h2>
            
            <!-- Birthday Promotion -->
            <div class="promotion-block" id="birthday">
                <div class="promotion-content">
                    <div class="promotion-image">
                        <img src="images/birthday-promo.jpg" alt="Birthday Promotion" class="img-responsive">
                    </div>
                    <div class="promotion-details">
                        <h3>Birthday Special Discount</h3>
                        <div class="promotion-badge">20% OFF</div>
                        <p>Celebrate your birthday with us and get a special 20% discount on any single item of your choice!</p>
                        <h4>How It Works:</h4>
                        <ol>
                            <li>Create an account or log in to your existing account</li>
                            <li>Make sure your birth date is updated in your profile</li>
                            <li>During your birthday month, you'll receive a special coupon code via email</li>
                            <li>Apply the code at checkout to receive your discount</li>
                        </ol>
                        <p><strong>Terms & Conditions:</strong> Valid for one purchase during your birthday month. Cannot be combined with other offers. Maximum discount value of $200.</p>
                        <a href="login.jsp" class="btn">Sign Up Now</a>
                    </div>
                </div>
            </div>
            
            <!-- Summer Festival Promotion -->
            <div class="promotion-block" id="festival">
                <div class="promotion-content">
                    <div class="promotion-image">
                        <img src="images/summer-festival.jpg" alt="Summer Fitness Festival" class="img-responsive">
                    </div>
                    <div class="promotion-details">
                        <h3>Summer Fitness Festival</h3>
                        <div class="promotion-badge">UP TO 30% OFF</div>
                        <p>Get ready for summer with our annual Fitness Festival! Enjoy exclusive deals on a wide range of fitness equipment and accessories.</p>
                        <h4>Festival Highlights:</h4>
                        <ul>
                            <li>Up to 30% off on selected cardio equipment</li>
                            <li>Buy one, get one 50% off on all accessories</li>
                            <li>Free delivery and installation on orders over $500</li>
                            <li>Special financing options available - 0% interest for 12 months</li>
                        </ul>
                        <p><strong>Promotion Period:</strong> June 1 - July 31, 2023</p>
                        <a href="products.jsp" class="btn">Shop Now</a>
                    </div>
                </div>
            </div>
            
            <!-- Clearance Sale -->
            <div class="promotion-block">
                <div class="promotion-content">
                    <div class="promotion-image">
                        <img src="images/clearance-sale.jpg" alt="Clearance Sale" class="img-responsive">
                    </div>
                    <div class="promotion-details">
                        <h3>End of Season Clearance</h3>
                        <div class="promotion-badge">UP TO 50% OFF</div>
                        <p>Huge savings on last season's models and floor samples. Limited quantities available, so hurry while supplies last!</p>
                        <h4>Featured Clearance Items:</h4>
                        <ul>
                            <li>Treadmills - save up to 40%</li>
                            <li>Exercise bikes - save up to 35%</li>
                            <li>Weight benches - save up to 50%</li>
                            <li>Elliptical trainers - save up to 45%</li>
                        </ul>
                        <p><strong>Note:</strong> All clearance items are sold as-is. Warranty may be limited on some items.</p>
                        <a href="products.jsp?category=clearance" class="btn">View Clearance Items</a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Upcoming Promotions -->
    <section class="upcoming-promotions">
        <div class="container">
            <h2 class="section-title">Coming Soon</h2>
            <div class="products-grid">
                <!-- Black Friday -->
                <div class="promotion-card">
                    <h3>Black Friday Sale</h3>
                    <p class="promotion-date">November 24, 2023</p>
                    <p>Our biggest sale of the year! Mark your calendar for incredible deals on premium fitness equipment.</p>
                    <a href="#" class="btn btn-outline">Remind Me</a>
                </div>
                
                <!-- Holiday Special -->
                <div class="promotion-card">
                    <h3>Holiday Gift Guide</h3>
                    <p class="promotion-date">December 1-25, 2023</p>
                    <p>Find the perfect fitness gifts for everyone on your list with our special holiday bundles and offers.</p>
                    <a href="#" class="btn btn-outline">Remind Me</a>
                </div>
                
                <!-- New Year -->
                <div class="promotion-card">
                    <h3>New Year, New You</h3>
                    <p class="promotion-date">January 1-31, 2024</p>
                    <p>Start the new year right with special deals on everything you need to achieve your fitness resolutions.</p>
                    <a href="#" class="btn btn-outline">Remind Me</a>
                </div>
            </div>
        </div>
    </section>

<jsp:include page="/footer.jsp" /> 