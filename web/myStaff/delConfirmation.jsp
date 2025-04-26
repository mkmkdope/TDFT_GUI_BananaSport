<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String id = (String) request.getAttribute("id");
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Delete Confirmation - Staff Dashboard</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

        <style>
            .section {
                padding: 20px;
                border: 1px solid #ddd;
                border-radius: 5px;
                margin-bottom: 30px;
                background-color: white;
            }

            .confirmation-form {
                max-width: 600px;
                margin: 0 auto;
                padding: 30px;
                background: white;
                border-radius: 10px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                text-align: center;
            }

            .page-title {
                text-align: center;
                margin: 30px 0;
                color: #333;
                font-size: 28px;
                font-weight: 600;
            }

            .confirmation-message {
                font-size: 18px;
                color: #333;
                margin-bottom: 30px;
                padding: 20px;
                background: #fff9e6;
                border-radius: 8px;
                border: 1px solid #f4d746;
            }

            .product-id {
                font-weight: 600;
                color: #e74c3c;
            }

            .button-group {
                display: flex;
                gap: 15px;
                justify-content: center;
                margin-top: 30px;
            }

            .confirm-btn {
                background: linear-gradient(135deg, #e74c3c, #c0392b);
                color: white;
                padding: 15px 30px;
                border: none;
                border-radius: 8px;
                font-size: 18px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                width: 200px;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
            }

            .cancel-btn {
                background: linear-gradient(135deg, #f4d746, #f4eb36);
                color: #333;
                padding: 15px 30px;
                border: none;
                border-radius: 8px;
                font-size: 18px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                width: 200px;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
            }

            .confirm-btn:hover,
            .cancel-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            }


        </style>
    </head>


    <hr 

        <body>
        <!-- Header Section -->
        <header>
            <div class="container">
                <nav class="navbar">
                    <%
                        if (session.getAttribute("isManager") != null && (Boolean) session.getAttribute("isManager")) {
                    %>
                    <a href="${pageContext.request.contextPath}/myAdmin/AdminModule.jsp">Back to<br> Admin</a>
                    <ul class="nav-links" id="navLinks">
                        <li><a href="addProdM.jsp">Add Products</a></li>
                        <li><a href="ControlProdM" class="active">Modify Products</a></li>
                        <li><a href="${pageContext.request.contextPath}/LogoutServlet">Logout</a></li>
                    </ul>
                    <%
                    } else if (session.getAttribute("isStaff") != null && (Boolean) session.getAttribute("isStaff")) {
                    %>
                    <div class="logo-container">
                        <img src="${pageContext.request.contextPath}/images/logo.jpg" alt="${applicationScope.companyName} Logo" class="logo"> 
                    </div>
                    <h2>Staff Dashboard</h2>
                    <ul class="nav-links" id="navLinks">
                        <li><a href="staffProd.jsp">Home</a></li>
                        <li><a href="addProdM.jsp">Add Products</a></li>
                        <li><a href="ControlProdM" class="active">Modify Products</a></li>
                        <li><a href="managePromo.jsp">Manage Promotions</a></li>
                        <li><a href="ordersStatus.jsp">Manage Orders</a></li>
                        <li><a href="${pageContext.request.contextPath}/LogoutServlet">Logout</a></li>
                    </ul>    

                    <%
                        }
                    %>
                </nav>
            </div>
        </header>

        <main class="container">
            <div class="section">
                <h1 class="page-title">Delete Confirmation</h1>

                <div class="confirmation-form">
                    <div class="confirmation-message">
                        <i class="fas fa-exclamation-triangle" style="font-size: 48px; color: #e74c3c; margin-bottom: 20px;"></i>
                        <p>Are you sure you want to delete product ID: <span class="product-id"><%= id%></span>?</p>
                        <p style="font-size: 14px; color: #666; margin-top: 10px;">This action cannot be undone.</p>
                    </div>

                    <form action="deleteProd" method="post">
                        <input type="hidden" name="id" value="<%= id%>" />

                        <div class="button-group">
                            <button type="submit" name="delAction" value="confirm" class="confirm-btn">
                                <i class="fas fa-trash-alt"></i> Yes, Delete
                            </button>
                            <button type="submit" name="delAction" value="Noconfirm" class="cancel-btn">
                                <i class="fas fa-times"></i> No, Cancel
                            </button>
                        </div>
                    </form>
                </div>
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
