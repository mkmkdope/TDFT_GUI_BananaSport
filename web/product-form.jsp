<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="header.jsp">
    <jsp:param name="pageTitle" value="${empty product ? 'Add New Product' : 'Edit Product'}"/>
</jsp:include>

    <!-- Product Form Section -->
    <section class="form-section">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-8">
                    <div class="card">
                        <div class="card-header">
                            <h2>${empty product ? 'Add New Product' : 'Edit Product'}</h2>
                        </div>
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/product" method="post">
                                <input type="hidden" name="action" value="${empty product ? 'create' : 'update'}">
                                
                                <c:if test="${not empty product}">
                                    <input type="hidden" name="id" value="${product.id}">
                                </c:if>
                                
                                <div class="mb-3">
                                    <label for="name" class="form-label">Product Name</label>
                                    <input type="text" class="form-control" id="name" name="name" value="${product.name}" required>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="description" class="form-label">Description</label>
                                    <textarea class="form-control" id="description" name="description" rows="4">${product.description}</textarea>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="price" class="form-label">Price</label>
                                    <input type="number" class="form-control" id="price" name="price" step="0.01" value="${product.price}" required>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="stockQuantity" class="form-label">Stock Quantity</label>
                                    <input type="number" class="form-control" id="stockQuantity" name="stockQuantity" value="${product.stockQuantity}" required>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="category" class="form-label">Category</label>
                                    <input type="text" class="form-control" id="category" name="category" value="${product.category}">
                                </div>
                                
                                <div class="mb-3">
                                    <label for="imageUrl" class="form-label">Image URL</label>
                                    <input type="text" class="form-control" id="imageUrl" name="imageUrl" value="${product.imageUrl}">
                                </div>
                                
                                <div class="d-flex justify-content-between">
                                    <button type="submit" class="btn btn-primary">Save</button>
                                    <a href="${pageContext.request.contextPath}/product" class="btn btn-secondary">Cancel</a>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

<jsp:include page="footer.jsp" /> 