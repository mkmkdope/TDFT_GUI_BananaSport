<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="header.jsp">
    <jsp:param name="pageTitle" value="Contact Us"/>
</jsp:include>

    <!-- Contact Hero Section -->
    <section class="hero">
        <div class="container">
            <h1>Contact ${applicationScope.companyName}</h1>
            <p>We'd love to hear from you! Reach out to us with any questions, feedback, or inquiries.</p>
        </div>
    </section>

    <!-- Contact Information Section -->
    <section class="contact-info">
        <div class="container">
            <div class="contact-grid">
                <div class="contact-card">
                    <i class="fas fa-map-marker-alt fa-3x"></i>
                    <h3>Visit Us</h3>
                    <p>123 Fitness Street</p>
                    <p>Sports City, SC 12345</p>
                    <p>United States</p>
                </div>
                
                <div class="contact-card">
                    <i class="fas fa-phone fa-3x"></i>
                    <h3>Call Us</h3>
                    <p>Phone: +1 (555) 123-4567</p>
                    <p>Toll-Free: 1-800-BANANA-SPORTS</p>
                    <p>Fax: +1 (555) 987-6543</p>
                </div>
                
                <div class="contact-card">
                    <i class="fas fa-envelope fa-3x"></i>
                    <h3>Email Us</h3>
                    <p>General Inquiries: ${applicationScope.companyEmail}</p>
                    <p>Customer Support: support@bananasports.com</p>
                    <p>Careers: careers@bananasports.com</p>
                </div>
                
                <div class="contact-card">
                    <i class="fas fa-clock fa-3x"></i>
                    <h3>Business Hours</h3>
                    <p>Monday - Friday: 9:00 AM - 8:00 PM</p>
                    <p>Saturday: 10:00 AM - 6:00 PM</p>
                    <p>Sunday: 12:00 PM - 5:00 PM</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Contact Form Section -->
    <section class="contact-form">
        <div class="container">
            <h2 class="section-title">Send Us a Message</h2>
            
            <!-- Success Message Display -->
            <% if (session.getAttribute("contactMessage") != null) { %>
                <div class="success-message">
                    <p><%= session.getAttribute("contactMessage") %></p>
                    <% session.removeAttribute("contactMessage"); %>
                </div>
            <% } %>
            
            <form action="contact-form-handler" method="post" class="form">
                <div class="form-group">
                    <label for="name">Your Name</label>
                    <input type="text" id="name" name="name" required>
                </div>
                
                <div class="form-group">
                    <label for="email">Your Email</label>
                    <input type="email" id="email" name="email" required>
                </div>
                
                <div class="form-group">
                    <label for="phone">Phone Number</label>
                    <input type="tel" id="phone" name="phone">
                </div>
                
                <div class="form-group">
                    <label for="subject">Subject</label>
                    <select id="subject" name="subject">
                        <option value="general">General Inquiry</option>
                        <option value="support">Product Support</option>
                        <option value="order">Order Status</option>
                        <option value="feedback">Feedback</option>
                        <option value="other">Other</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="message">Your Message</label>
                    <textarea id="message" name="message" rows="6" required></textarea>
                </div>
                
                <div class="form-group">
                    <button type="submit" class="btn">Send Message</button>
                </div>
            </form>
        </div>
    </section>

    <!-- Map Section -->
    <section class="map">
        <div class="container">
            <h2 class="section-title">Find Us</h2>
            <div class="map-container">
                <!-- In a real application, you would embed a Google Map or other map service here -->
                <div class="map-placeholder">
                    <p>Map will be displayed here. For this demo, imagine a map showing the location of ${applicationScope.companyName}.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- FAQ Section -->
    <section class="faq">
        <div class="container">
            <h2 class="section-title">Frequently Asked Questions</h2>
            <div class="faq-container">
                <div class="faq-item">
                    <h3>Do you offer installation services?</h3>
                    <p>Yes, we offer professional installation services for most of our fitness equipment. The cost varies depending on the type of equipment and complexity of installation.</p>
                </div>
                
                <div class="faq-item">
                    <h3>What is your return policy?</h3>
                    <p>We offer a 30-day return policy for most items. Products must be in their original packaging and in unused condition. Some exceptions apply for hygiene reasons.</p>
                </div>
                
                <div class="faq-item">
                    <h3>Do you ship internationally?</h3>
                    <p>Yes, we ship to select international destinations. Shipping costs and delivery times vary by location. Please contact our customer service for more information.</p>
                </div>
                
                <div class="faq-item">
                    <h3>Do you offer warranties on your products?</h3>
                    <p>Yes, all our products come with manufacturer warranties. Additionally, we offer extended warranty options for most fitness equipment.</p>
                </div>
            </div>
        </div>
    </section>

<jsp:include page="footer.jsp" /> 