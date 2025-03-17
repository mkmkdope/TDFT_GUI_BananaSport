<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="header.jsp">
    <jsp:param name="pageTitle" value="About Us"/>
</jsp:include>

    <!-- About Hero Section -->
    <section class="hero">
        <div class="container">
            <h1>About ${applicationScope.companyName}</h1>
            <p>Learn more about our mission, values, and the team behind your favorite fitness equipment store.</p>
        </div>
    </section>

    <!-- Main About Section -->
    <section class="about-main">
        <div class="container">
            <div class="about-content">
                <div class="about-image">
                    <img src="images/about-store.jpg" alt="Our Store" class="img-responsive">
                </div>
                <div class="about-text">
                    <h2>Our Story</h2>
                    <p>
                        Founded in 2010, ${applicationScope.companyName} began as a small fitness equipment shop with a big dream: 
                        to make high-quality fitness equipment accessible to everyone. Our founder, John Banana, was a fitness 
                        enthusiast who struggled to find reliable equipment at reasonable prices.
                    </p>
                    <p>
                        What started as a small store with just a few treadmills and weight sets has now grown into one of the 
                        region's most trusted fitness equipment retailers. Today, we offer a comprehensive range of fitness and 
                        sports equipment for both home and commercial use.
                    </p>
                    <p>
                        Despite our growth, we've never lost sight of our original mission: to help people achieve their fitness 
                        goals with quality equipment, expert advice, and exceptional service.
                    </p>
                </div>
            </div>
        </div>
    </section>

    <!-- Our Values Section -->
    <section class="values">
        <div class="container">
            <h2 class="section-title">Our Values</h2>
            <div class="values-grid">
                <div class="value-card">
                    <i class="fas fa-medal fa-3x"></i>
                    <h3>Quality</h3>
                    <p>We never compromise on the quality of our products. Every piece of equipment we sell undergoes rigorous testing to ensure durability and performance.</p>
                </div>
                
                <div class="value-card">
                    <i class="fas fa-handshake fa-3x"></i>
                    <h3>Integrity</h3>
                    <p>We believe in honest business practices and transparent pricing. What you see is what you get - no hidden fees or misleading information.</p>
                </div>
                
                <div class="value-card">
                    <i class="fas fa-users fa-3x"></i>
                    <h3>Community</h3>
                    <p>We're more than just a store; we're a community of fitness enthusiasts. We regularly organize events and workshops to bring our community together.</p>
                </div>
                
                <div class="value-card">
                    <i class="fas fa-headset fa-3x"></i>
                    <h3>Service</h3>
                    <p>Our knowledgeable staff is always ready to assist you in finding the right equipment for your needs and fitness goals.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Team Section -->
    <section class="team">
        <div class="container">
            <h2 class="section-title">Meet Our Team</h2>
            <div class="team-grid">
                <div class="team-member">
                    <img src="images/team1.jpg" alt="John Banana" class="team-img">
                    <h3>John Banana</h3>
                    <p class="position">Founder & CEO</p>
                    <p>A fitness enthusiast with over 20 years of experience in the fitness industry.</p>
                </div>
                
                <div class="team-member">
                    <img src="images/team2.jpg" alt="Sarah Johnson" class="team-img">
                    <h3>Sarah Johnson</h3>
                    <p class="position">Head of Product</p>
                    <p>Former professional athlete with a keen eye for quality fitness equipment.</p>
                </div>
                
                <div class="team-member">
                    <img src="images/team3.jpg" alt="Mike Chen" class="team-img">
                    <h3>Mike Chen</h3>
                    <p class="position">Customer Service Manager</p>
                    <p>Dedicated to ensuring every customer has an exceptional shopping experience.</p>
                </div>
                
                <div class="team-member">
                    <img src="images/team4.jpg" alt="Lisa Rodriguez" class="team-img">
                    <h3>Lisa Rodriguez</h3>
                    <p class="position">Fitness Consultant</p>
                    <p>Certified personal trainer who helps customers find the right equipment for their fitness goals.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Testimonials Section -->
    <section class="testimonials">
        <div class="container">
            <h2 class="section-title">What Our Customers Say</h2>
            <div class="testimonial-grid">
                <div class="testimonial-card">
                    <div class="testimonial-text">
                        <p>"${applicationScope.companyName} has the best selection of fitness equipment I've ever seen. Their staff is knowledgeable and helped me find the perfect treadmill for my home gym."</p>
                    </div>
                    <div class="testimonial-author">
                        <p><strong>- David M.</strong></p>
                    </div>
                </div>
                
                <div class="testimonial-card">
                    <div class="testimonial-text">
                        <p>"I've been shopping at ${applicationScope.companyName} for years, and I'm always impressed by their quality and service. They truly care about their customers."</p>
                    </div>
                    <div class="testimonial-author">
                        <p><strong>- Jennifer K.</strong></p>
                    </div>
                </div>
                
                <div class="testimonial-card">
                    <div class="testimonial-text">
                        <p>"The team at ${applicationScope.companyName} went above and beyond to help me set up my home gym. I couldn't be happier with my purchase!"</p>
                    </div>
                    <div class="testimonial-author">
                        <p><strong>- Robert T.</strong></p>
                    </div>
                </div>
            </div>
        </div>
    </section>

<jsp:include page="footer.jsp" /> 