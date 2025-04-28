<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="/header.jsp">
    <jsp:param name="pageTitle" value="Contact Us"/>
</jsp:include>

    <!-- Contact Hero Section -->
    <section class="hero">
        <div class="container">
            <h1>Contact Us</h1>
        </div>
    </section>

    <!-- Contact Information Section -->
    <section class="contact-info">
        <div class="container">
            <div class="contact-grid">
                <div class="contact-card">
                    <i class="fas fa-map-marker-alt fa-3x"></i>
                    <h3>Visit Us</h3>
                    <p>KUALA LUMPUR BRANCH</p>
                    <p>Jalan Genting Kelang, Setapak,</p>
                    <p>53300 Kuala Lumpur.</p>
                </div>
                
                <div class="contact-card">
                    <i class="fas fa-phone fa-3x"></i>
                    <h3>Call Us</h3>
                    <p>Phone: (6)03-41450123</p>
                    <p>Fax: (6)07-9270801/3</p>
                </div>
                
                <div class="contact-card">
                    <i class="fas fa-envelope fa-3x"></i>
                    <h3>Email Us</h3>
                    <p>General Inquiries: ${applicationScope.companyEmail}</p>
                    <p>Customer Support: support@bananasport.com</p>
                    <p>Careers: careers@bananasport.com</p>
                </div>
                
                <div class="contact-card">
                    <i class="fas fa-clock fa-3x"></i>
                    <h3>Business Hours</h3>
                    <p>Monday - Friday: 9:00 AM - 8:00 PM</p>
                    <p>Saturday: 9:00 AM - 6:00 PM</p>
                    <p>Sunday: 9:00 PM - 1:00 PM</p>
                </div>
            </div>
        </div>
    </section>

<jsp:include page="/footer.jsp" /> 