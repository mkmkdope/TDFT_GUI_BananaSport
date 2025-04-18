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
            padding: 30px;
        }
        .product-container {
            border: 1px solid #ddd;
            padding: 20px;
            width: 600px;
            margin: auto;
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
    </style>
</head>
<body>
    <div class="product-container">
        <h2>Product Details</h2>

        <img class="product-image" src="images/<%= product.getImageLink() %>" alt="Product Image" />

        
        <p><span class="label">Product Name:</span> <%= product.getProductName() %></p>
        <p><span class="label">Category:</span> <%= product.getProductCategory() %></p>
        <p><span class="label">Quantity:</span> <%= product.getProductQty() %></p>
        <p><span class="label">Price:</span> RM <%= String.format("%.2f", product.getProductPrice()) %></p>
<!--        <p><span class="label">Popularity:</span> <%= product.getProductPopularity() %></p>-->
<!--        <p><span class="label">Created Time:</span> <%= product.getProductCreatedTime() %></p>-->
        
         <p><span class="label">Product Description:</span> <%= product.getDescription() %></p>

        <br/>
        <button onclick="location.href='showProd'" class="btn" >Back to home</button>


                <!-- Add to Cart -->
                <form action="${pageContext.request.contextPath}/AddCart" method="post" style="display:inline;">
                    <input type="hidden" name="productId" value="<%= product.getProductId()%>">
                    <button type="submit" class="btn">Add to Cart</button>
                </form>
    </div>
</body>
</html>
