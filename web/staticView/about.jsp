<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="/header.jsp">
    <jsp:param name="pageTitle" value="About Us"/>
</jsp:include>

    <!-- About Hero Section -->
    <section class="hero">
        <div class="container">
            <h1>About Us</h1>
        </div>
    </section>

    <!-- Main About Section -->
    <section class="about-main">
        <div class="container">
            <div class="about-content">
                <div class="about-image">
                    <img src="../images/shop.jpg" alt="Our Store" class="img-responsive">
                </div>
                <div class="about-text">
                    <h2>Our Story</h2>
                    <p>
                        Founded in 2010, Banana Sport began as a small fitness equipment shop with a big dream: 
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

    <!-- Team Section -->
    <section class="team">
        <div class="container">
            <h2 class="section-title">Meet Our Team</h2>
            <div class="team-grid">
                <div class="team-member">
                    <img src="../images/cat.png" alt="Ming Kang" class="team-img">
                    <h3>Ming Kang</h3>
                    <p class="position">Leader</p>
                    <p>Work 24 hours to complete the assignment.</p>
                </div>
                
                <div class="team-member">
                    <img src="../images/cat.png" alt="Yu Hang" class="team-img">
                    <h3>Yu Hang</h3>
                    <p class="position">Head of Product</p>
                    <p>Former professional athlete with a keen eye for quality fitness equipment.</p>
                </div>
                
                <div class="team-member">
                    <img src="../images/cat.png" alt="Yae Wen" class="team-img">
                    <h3>Yea Wen</h3>
                    <p class="position">Customer Service Manager</p>
                    <p>Dedicated to ensuring every customer has an exceptional shopping experience.</p>
                </div>
                
                <div class="team-member">
                    <img src="../images/cat.png" alt="Hong Yi" class="team-img">
                    <h3>Hong Yi</h3>
                    <p class="position">Human Resources Manager</p>
                    <p>Certified personal trainer who helps customers find the right equipment for their fitness goals.</p>
                </div>
                
                <div class="team-member">
                    <img src="../images/cat.png" alt="E-Hern" class="team-img">
                    <h3>E-Hern</h3>
                    <p class="position">Head of Finance</p>
                    <p>Certified personal trainer who helps customers find the right equipment for their fitness goals.</p>
                </div>
                
            </div>
        </div>
    </section>

<jsp:include page="/footer.jsp" /> 