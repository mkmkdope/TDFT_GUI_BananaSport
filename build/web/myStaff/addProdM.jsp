<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:useBean id="Products" scope="request" class="model.Products" />

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manager - Add Product</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f4f4f4;
                margin: 0;
                padding: 0;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
            }

            .container {
                width: 100%;
                max-width: 500px;
                background: #fff;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            }

            h1 {
                text-align: center;
                color: #333;
            }

            label {
                font-weight: bold;
                margin-top: 10px;
                display: block;
                color: #555;
            }

            input, select {
                width: 100%;
                padding: 10px;
                margin-top: 5px;
                margin-bottom: 15px;
                border: 1px solid #ccc;
                border-radius: 5px;
                font-size: 16px;
                box-sizing: border-box;
            }

            textarea {
                resize: vertical;
                min-height: 100px;
            }

            input[type="file"] {
                border: none;
            }

            button {
                width: 100%;
                padding: 12px;
                background: #333;
                border: none;
                color: #fff;
                font-size: 18px;
                cursor: pointer;
                border-radius: 5px;
                transition: 0.3s;
            }

            button:hover {
                background: #ffcc00;
            }

        </style>
    </head>
    <body>
        <div class="container">
            <%
                // Get user role from session
                Boolean isManager = (Boolean) session.getAttribute("isManager");
                Boolean isStaff = (Boolean) session.getAttribute("isStaff"); // You would need to set this attribute

                if (isManager != null && isManager) {
            %>
            <a href="${pageContext.request.contextPath}/myAdmin/AdminModule.jsp">Back to<br> Admin Panel</a>
                <%
                } else if (isStaff != null && isStaff) {
                %>
            <a href="${pageContext.request.contextPath}/myStaff/staffProd.jsp">Back to<br> Staff Panel</a>
                <%
                    }
                %>

            <h1>Add a New Product</h1>

            <form action="addProdM" method="POST" enctype="multipart/form-data"> 

                <label for="name">Product Name:</label>
                <input type="text" id="name" name="name" required>


                <label for="category">Category:</label>
                <select id="category" name="category" required>
                    <option value="Cardio Equipment">Cardio Equipment</option>
                    <option value="Strength Training">Strength Training</option>
                    <option value="Yoga">Yoga & Pilates</option>
                    <option value="Accessories">Accessories</option>
                </select>

                <label for="price">Price:</label>
                <input type="number" id="price" name="price" step="0.01" required>    

                <label for="quantity">Quantity:</label>
                <input type="number" id="quantity" name="quantity" required>

                <label for="image">Upload Image:</label>
                <input type="file" id="image" name="image" accept="image/*" required>

                <label for="description">Description:</label>
                <textarea type="text" id="description" name="description" required>
              
                </textarea>
                <button type="submit">Add Product</button>    
            </form>
        </div>
    </body>
</html>
