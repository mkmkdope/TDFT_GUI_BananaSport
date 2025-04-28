<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Products" %>
<%
    Products product = (Products) request.getAttribute("product");
%>

<jsp:include page="/header.jsp">
    <jsp:param name="pageTitle" value="Products"/>
</jsp:include>

<!DOCTYPE html>
<html>
    <head>
        <title>Product Details</title>
        <style>
            body {
                font-family: Arial, sans-serif;
            }
            .product-container {
                border: 1px solid #ddd;
                padding: 20px;
                width: 600px;
                margin: 30px auto;
                box-shadow: 0 0 10px #ccc;
                border-radius: 10px;
            }
            .product-image {
                max-width: 100%;
                height: auto;
            }
            .label {
                font-weight: bold;
            }
            .value {
                margin-bottom: 10px;
            }
            .btn {
                display: inline-block;
                margin-top: 10px;
                padding: 10px 20px;
                background: linear-gradient(to right, #FFC107, #FFE082);
                color: #212121;
                border-radius: 8px;
                cursor: pointer;
                font-size: 14px;
                font-weight: bold;
                text-decoration: none;
                transition: transform 0.2s ease, box-shadow 0.2s ease;
            }

            .btn:hover {
                transform: scale(1.05);
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
                background: linear-gradient(to right, #FFB300, #FFD54F);
            }
        </style>
    </head>
    <body>
        <div class="product-container">
            <h2>Product Details</h2>

            <img class="product-image" src="images/<%= product.getImageLink()%>" alt="Product Image" />


            <p><span class="label">Product Name:</span> <%= product.getProductName()%></p>
            <p><span class="label">Category:</span> <%= product.getProductCategory()%></p>
            <p><span class="label">Quantity:</span> <%= product.getProductQty()%></p>
            <p><span class="label">Price:</span> RM <%= String.format("%.2f", product.getProductPrice())%></p>
    <!--        <p><span class="label">Popularity:</span> <%= product.getProductPopularity()%></p>-->
    <!--        <p><span class="label">Created Time:</span> <%= product.getProductCreatedTime()%></p>-->

            <p><span class="label">Product Description:</span> <%= product.getDescription()%></p>

            <br/>
            <button onclick="location.href = 'showProd'" class="btn">Back to Home</button>

            <form action="${pageContext.request.contextPath}/AddCart" method="post" style="display: inline;">
                <input type="hidden" name="productId" value="<%= product.getProductId()%>">
                <button type="submit" class="btn">Add to Cart</button>
            </form>
        </div>
    </body>
    <jsp:include page="/footer.jsp" />
</html>
