<%@page contentType="text/html" pageEncoding="UTF-8"%>



<jsp:include page="controlPanelM.jsp">
    <jsp:param name="pageTitle" value="Products"/>
</jsp:include>

<%@ page import="model.Products" %>
<%
    Products product = (Products) request.getAttribute("product");
    
%>


<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manager - Update Product</title>
        <style>
          body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    margin: 0;
    padding: 0;
    display: flex;
    justify-content: center;
    align-items: flex-start;
    min-height: 100vh;
}

.container {
    width: 90%;
    max-width: 600px;
    background: #fff;
    padding: 30px;
    border-radius: 12px;
    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
    margin-top: 50px;
}

h1 {
    text-align: center;
    color: #333;
    margin-bottom: 25px;
}

label {
    font-weight: bold;
    margin-top: 10px;
    display: block;
    color: #444;
}

input, select, textarea {
    width: 100%;
    padding: 12px;
    margin-top: 5px;
    margin-bottom: 20px;
    border: 1px solid #ccc;
    border-radius: 6px;
    font-size: 16px;
    box-sizing: border-box;
}

textarea {
    resize: vertical;
    min-height: 100px;
}

button {
    width: 100%;
    padding: 14px;
    background: #28a745;
    border: none;
    color: #fff;
    font-size: 17px;
    cursor: pointer;
    border-radius: 6px;
    transition: background 0.3s ease;
}

button:hover {
    background: #218838;
}

button.exit {
    margin-top: 10px;
    background: #dc3545;
}

button.exit:hover {
    background: #c82333;
}



        </style>
    </head>
    <body>
        <div class="container">
            <h1>Modify Product</h1>
            <!--            enctype="multipart/form-data"-->
           <form action="updateProd" method="POST"> 
    <input type="hidden" name="id" value="<%= product.getProductId() %>">


    <label for="name">Product Name:</label>
    <input type="text" id="name" name="name" value="<%= product.getProductName() %>" required>

    <label for="category">Category:</label>
    <select id="category" name="category" required>
        <option value="Cardio Equipment" <%= "Cardio Equipment".equals(product.getProductCategory())?"selected":"" %>>Cardio Equipment</option>
        <option value="Strength Training" <%= "Strength Training".equals(product.getProductCategory())?"selected":"" %>>Strength Training</option>
        <option value="Yoga" <%= "Yoga".equals(product.getProductCategory())?"selected":"" %>>Yoga & Pilates</option>
        <option value="Accessories" <%= "Accessories".equals(product.getProductCategory())?"selected":"" %>>Accessories</option>
    </select>

    <label for="price">Price:</label>
    <input type="number" id="price" name="price" value="<%= product.getProductPrice() %>" step="0.01" required>    

    <label for="quantity">Quantity:</label>
    <input type="number" id="quantity" name="quantity" value="<%= product.getProductQty() %>" required>

    <label for="description">Description:</label>
    <textarea id="description" name="description" required><%= product.getDescription() != null ? product.getDescription() : "" %>
</textarea>

    <button name="update" value="update" type="submit">Update Product</button>
    <button type="button" class="exit" onclick="window.location.href = 'controlPanelM.jsp'">Exit</button>
</form>

        </div>
    </body>
</html>
