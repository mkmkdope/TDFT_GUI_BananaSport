<!-- Footer -->
<footer>
    <div class="container">
        <div class="footer-content">
            <div class="footer-section">
                <h3>Quick Links</h3>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/showProd">Products</a></li>
                    <li><a href="${pageContext.request.contextPath}/myCustomer/promotions.jsp">Promotions</a></li>
                    <li><a href="${pageContext.request.contextPath}/staticView/about.jsp">About Us</a></li>
                    <li><a href="${pageContext.request.contextPath}/staticView/contact.jsp">Contact</a></li>
                </ul>
            </div>

            <div class="footer-section">
                <h3>Contact Us</h3>
                <ul>
                    <li><i class="fas fa-map-marker-alt"></i> Jalan Genting Kelang, Setapak,53300 Kuala Lumpur.</li>
                    <li><i class="fas fa-phone"></i> (6)03-41450123</li>
                    <li><i class="fas fa-envelope"></i> ${applicationScope.companyEmail}</li>
                </ul>
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
        button.addEventListener('click', function () {
            alert('Product added to cart!');
            // In a real application, this would add the product to the cart
        });
    });

    // Mobile menu toggle
    document.addEventListener('DOMContentLoaded', function () {
        const mobileMenuToggle = document.getElementById('mobileMenuToggle');
        const navLinks = document.getElementById('navLinks');

        if (mobileMenuToggle && navLinks) {
            mobileMenuToggle.addEventListener('click', function () {
                navLinks.classList.toggle('active');
            });
        }
    });
</script>
</body>
</html> 