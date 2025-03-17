    <!-- Footer -->
    <footer>
        <div class="container">
            <div class="footer-content">
                <div class="footer-section">
                    <h3>Quick Links</h3>
                    <ul>
                        <li><a href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
                        <li><a href="${pageContext.request.contextPath}/products.jsp">Products</a></li>
                        <li><a href="${pageContext.request.contextPath}/promotions.jsp">Promotions</a></li>
                        <li><a href="${pageContext.request.contextPath}/about.jsp">About Us</a></li>
                        <li><a href="${pageContext.request.contextPath}/contact.jsp">Contact</a></li>
                    </ul>
                </div>
                
                <div class="footer-section">
                    <h3>Contact Us</h3>
                    <ul>
                        <li><i class="fas fa-map-marker-alt"></i> 123 Fitness Street, Sports City</li>
                        <li><i class="fas fa-phone"></i> +1 (555) 123-4567</li>
                        <li><i class="fas fa-envelope"></i> ${applicationScope.companyEmail}</li>
                    </ul>
                </div>
                
                <div class="footer-section">
                    <h3>Follow Us</h3>
                    <div class="social-links">
                        <a href="#"><i class="fab fa-facebook"></i></a>
                        <a href="#"><i class="fab fa-twitter"></i></a>
                        <a href="#"><i class="fab fa-instagram"></i></a>
                        <a href="#"><i class="fab fa-youtube"></i></a>
                    </div>
                </div>
            </div>
            
            <div class="copyright">
                <p>${applicationScope.companyCopyright}</p>
            </div>
        </div>
    </footer>

    <!-- JavaScript for interactive elements -->
    <script>
        // Add to cart functionality
        document.querySelectorAll('.add-to-cart').forEach(button => {
            button.addEventListener('click', function() {
                alert('Product added to cart!');
                // In a real application, this would add the product to the cart
            });
        });
        
        // Mobile menu toggle
        document.addEventListener('DOMContentLoaded', function() {
            const mobileMenuToggle = document.getElementById('mobileMenuToggle');
            const navLinks = document.getElementById('navLinks');
            
            if (mobileMenuToggle && navLinks) {
                mobileMenuToggle.addEventListener('click', function() {
                    navLinks.classList.toggle('active');
                });
            }
        });
    </script>
</body>
</html> 