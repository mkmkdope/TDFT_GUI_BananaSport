<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:useBean id="Products" scope="request" class="model.Products" />

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Add Product - Staff Dashboard</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        
        <style>
            .section {
                padding: 20px;
                border: 1px solid #ddd;
                border-radius: 5px;
                margin-bottom: 30px;
                background-color: white;
            }

            .product-form {
                max-width: 800px;
                margin: 0 auto;
                padding: 30px;
                background: white;
                border-radius: 10px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }

            .form-group {
                margin-bottom: 25px;
            }

            .form-group label {
                display: block;
                font-weight: 500;
                margin-bottom: 8px;
                color: #333;
                font-size: 16px;
            }

            .form-group input,
            .form-group select,
            .form-group textarea {
                width: 100%;
                padding: 12px;
                border: 2px solid #ddd;
                border-radius: 8px;
                font-size: 16px;
                transition: border-color 0.3s ease;
                background-color: #f9f9f9;
            }

            .form-group input:focus,
            .form-group select:focus,
            .form-group textarea:focus {
                border-color: #f4d746;
                outline: none;
                background-color: white;
            }

            .form-group textarea {
                resize: vertical;
                min-height: 120px;
            }

            .submit-btn {
                background: linear-gradient(135deg, #f4d746, #f4eb36);
                color: #333;
                padding: 15px 30px;
                border: none;
                border-radius: 8px;
                font-size: 18px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                width: 100%;
                margin-top: 20px;
            }

            .submit-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            }

            .page-title {
                text-align: center;
                margin: 30px 0;
                color: #333;
                font-size: 28px;
                font-weight: 600;
            }

            .back-link {
                display: inline-block;
                margin: 20px 0;
                color: #333;
                text-decoration: none;
                font-weight: 500;
                transition: color 0.3s ease;
            }

            .back-link:hover {
                color: #f4d746;
            }
        </style>
    </head>
    <body>
        <!-- Header Section -->
        <header>
            <div class="container">
                <nav class="navbar">
                 <% 
if (session.getAttribute("isManager") != null && (Boolean) session.getAttribute("isManager")) { 
%>
    <a href="${pageContext.request.contextPath}/myAdmin/AdminModule.jsp">Switch to<br> Admin</a>
<% 
} else if (session.getAttribute("isStaff") != null && (Boolean) session.getAttribute("isStaff")) { 
%>
    <a href="${pageContext.request.contextPath}/myStaff/staffProd.jsp">Back to<br> Staff Panel</a>
<% 
} 
%>

                    <div class="logo-container">
                        <img src="${pageContext.request.contextPath}/images/logo.jpg" alt="${applicationScope.companyName} Logo" class="logo"> 
                    </div>
                    <h2>Staff Dashboard</h2>
                    <ul class="nav-links" id="navLinks">
                        <li><a href="staffProd.jsp">Home</a></li>
                        <li><a href="addProdM.jsp" class="active">Add Products</a></li>
                        <li><a href="ControlProdM">Modify Products</a></li>
                        <li><a href="managePromo.jsp">Manage Promotions</a></li>
                        <li><a href="ordersStatus.jsp">Manage Orders</a></li>
                        <li><a href="${pageContext.request.contextPath}/LogoutServlet">Logout</a></li>
                    </ul>
                </nav>
            </div>
        </header>

        <main class="container">
            <div class="section">
                <h1 class="page-title">Add New Product</h1>
                
                <form action="addProdM" method="POST" enctype="multipart/form-data" class="product-form">
                    <div class="form-group">
                        <label for="name"><i class="fas fa-tag"></i> Product Name</label>
                        <input type="text" id="name" name="name" required placeholder="Enter product name">
                    </div>

                    <div class="form-group">
                        <label for="category"><i class="fas fa-list"></i> Category</label>
                        <select id="category" name="category" required>
                            <option value="">Select a category</option>
                            <option value="Cardio Equipment">Cardio Equipment</option>
                            <option value="Strength Training">Strength Training</option>
                            <option value="Yoga">Yoga & Pilates</option>
                            <option value="Accessories">Accessories</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="price"><i class="fas fa-dollar-sign"></i> Price</label>
                        <input type="number" id="price" name="price" step="0.01" required placeholder="Enter price">
                    </div>

                    <div class="form-group">
                        <label for="quantity"><i class="fas fa-box"></i> Quantity</label>
                        <input type="number" id="quantity" name="quantity" required placeholder="Enter quantity">
                    </div>

                    <div class="form-group">
                        <label for="image"><i class="fas fa-image"></i> Product Image</label>
                        <input type="file" id="image" name="image" accept="image/*" required>
                    </div>

                    <div class="form-group">
                        <label for="description"><i class="fas fa-align-left"></i> Description</label>
                        <textarea id="description" name="description" required placeholder="Enter product description"></textarea>
                    </div>

                    <button type="submit" class="submit-btn">
                        <i class="fas fa-plus"></i> Add Product
                    </button>
                </form>
            </div>
        </main>

        <script>
            // Mobile menu toggle
            document.getElementById('mobileMenuToggle').addEventListener('click', function () {
                document.getElementById('navLinks').classList.toggle('show');
            });
        </script>
    </body>
</html>
