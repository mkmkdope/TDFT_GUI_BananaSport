<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    // Redirect to the servlet if accessed directly
    if (request.getAttribute("products") == null) {
        response.sendRedirect(request.getContextPath() + "/product");
        return;
    }
%>
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

    <!-- Products Section with CRUD -->
    <section class="products-section">
        <div class="container">
            <div class="admin-controls mb-4">
                <a href="${pageContext.request.contextPath}/product?action=new" class="btn btn-primary">Add New Product</a>
            </div>
            
            <c:if test="${!empty products}">
                <div class="row">
                    <c:forEach var="product" items="${products}">
                        <div class="col-md-4 mb-4">
                            <div class="card h-100">
                                <c:if test="${not empty product.imageUrl}">
                                    <img src="${product.imageUrl}" class="card-img-top" alt="${product.name}">
                                </c:if>
                                <c:if test="${empty product.imageUrl}">
                                    <img src="${pageContext.request.contextPath}/images/product-placeholder.jpg" class="card-img-top" alt="Product placeholder">
                                </c:if>
                                <div class="card-body">
                                    <h5 class="card-title">${product.name}</h5>
                                    <p class="card-text">${product.description}</p>
                                    <p class="card-text"><strong>Price: $${product.price}</strong></p>
                                    <p class="card-text">Stock: ${product.stockQuantity}</p>
                                    <p class="card-text">Category: ${product.category}</p>
                                </div>
                                <div class="card-footer d-flex justify-content-between">
                                    <a href="${pageContext.request.contextPath}/product?action=edit&id=${product.id}" class="btn btn-warning">Edit</a>
                                    <a href="${pageContext.request.contextPath}/product?action=delete&id=${product.id}" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this product?')">Delete</a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
            
            <c:if test="${empty products}">
                <div class="alert alert-info">
                    No products available. <a href="${pageContext.request.contextPath}/product?action=new">Add a product</a> to get started.
                </div>
            </c:if>
        </div>
    </section>

<jsp:include page="footer.jsp" /> 