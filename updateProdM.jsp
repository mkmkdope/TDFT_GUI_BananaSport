<%@page import="java.util.List"%>
<%@page import="model.Products"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Update Products - Staff Dashboard</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

        <style>
            body {
                background-color: #f9f9f9;
                font-family: 'Roboto', sans-serif;
                margin: 0;
                padding: 0;
            }

            h1 {
                text-align: center;
                color: #333;
                margin-bottom: 30px;
                font-size: 28px;
                font-weight: 600;
            }



            table {
                width: 100%;
                border-collapse: collapse;
                background-color: #fff;
                border-radius: 10px;
                overflow: hidden;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }

            th {
                background: linear-gradient(135deg, #f4d746, #f4eb36);
                color: #333;
                padding: 15px;
                font-size: 16px;
                text-align: center;
                font-weight: 600;
            }

            td {
                padding: 15px;
                border-bottom: 1px solid #eee;
                text-align: center;
                font-size: 15px;
                color: #555;
            }

            tr:nth-child(even) {
                background-color: #f9f9f9;
            }

            tr:hover {
                background-color: #fff9e6;
            }

            img {
                border-radius: 8px;
                width: 60px;
                height: 60px;
                object-fit: cover;
            }

            button {
                border: none;
                border-radius: 8px;
                padding: 8px 16px;
                font-size: 14px;
                cursor: pointer;
                transition: all 0.3s ease;
                display: inline-flex;
                align-items: center;
                gap: 5px;
            }

            button[name="action"][value="modify"] {
                background: linear-gradient(135deg, #2196f3, #1976d2);
                color: white;
            }

            button[name="action"][value="modify"]:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }

            button[name="action"][value="delete"] {
                background: linear-gradient(135deg, #f44336, #d32f2f);
                color: white;
            }

            button[name="action"][value="delete"]:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }



            /* Add Font Awesome icons to buttons */
            button[name="action"][value="modify"]::before {
                content: "\f044";
                font-family: "Font Awesome 6 Free";
                font-weight: 900;
            }

            button[name="action"][value="delete"]::before {
                content: "\f1f8";
                font-family: "Font Awesome 6 Free";
                font-weight: 900;
            }

            /* Header Styles */
            .section {
                padding: 20px;
                border: 1px solid #ddd;
                border-radius: 5px;
                margin-bottom: 30px;
                background-color: white;
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
            <%
                List<Products> productList = (List<Products>) request.getAttribute("products");
                if (productList == null) {
                    productList = new java.util.ArrayList<>(); // fallback if nothing in request
                }
            %>


            <div class="container">

                <h1>Product List</h1>

                <table style="width:100%; border-collapse: collapse;">
                    <tr style="background-color:#28a745; color:white;">
                        <th style="padding:10px; border:1px solid #ddd; background-color: black;">Image</th>
                        <th style="padding:10px; border:1px solid #ddd; background-color: black;">ID</th>
                        <th style="padding:10px; border:1px solid #ddd; background-color: black;">Name</th>
                        <th style="padding:10px; border:1px solid #ddd; background-color: black;">Category</th>
                        <th style="padding:10px; border:1px solid #ddd; background-color: black;">Price</th>
                        <th style="padding:10px; border:1px solid #ddd; background-color: black;">Quantity</th>
                        <th style="padding:10px; border:1px solid #ddd; background-color: black;">Description</th>

                        <th colspan ="2"; style=" padding:20px; border:1px solid #ddd; background-color: black;">Action</th>
                    </tr>


                    <%
                        if (productList == null || productList.isEmpty()) {
                    %>
                    <p>No products found matching your criteria.</p>
                    <%
                    } else {
                        for (Products product : productList) {
                    %>
                    <tr style="border:1px solid #ccc;">
                        <td style="padding:10px; border:1px solid #ddd;">
                            <img src="${pageContext.request.contextPath}/images/<%= product.getImageLink()%>" width="60" height="60" style="object-fit: cover;">
                        </td>
                        <td style="padding:10px; border:1px solid #ddd;"><%= product.getProductId()%></td>
                        <td style="padding:10px; border:1px solid #ddd;"><%= product.getProductName()%></td>
                        <td style="padding:10px; border:1px solid #ddd;"><%= product.getProductCategory()%></td>
                        <td style="padding:10px; border:1px solid #ddd;">RM <%= product.getProductPrice()%></td>
                        <td style="padding:10px; border:1px solid #ddd;"><%= product.getProductQty()%></td>
                        <td style="padding:10px; border:1px solid #ddd;"><%= product.getDescription()%></td>

                        <td style="padding:10px; border:1px solid #ddd;">
                            <form action="ControlProdM" method="post">
                                <input  type="hidden" name="id" value="<%= product.getProductId()%>" />
                                <button style="background-color:blue; color:white;" name="action" value="modify" type="submit" style="padding:6px 12px;">Modify</button>
                            </form>
                        </td>
                        <td style="padding:10px; border:1px solid #ddd;">
                            <form action="ControlProdM" method="post">
                                <input type="hidden" name="id" value="<%= product.getProductId()%>" />
                                <button style="background-color:red; color:white;" name="action" value="delete" type="submit" style="padding:6px 12px;">Delete</button>
                            </form>
                        </td>
                    </tr>

                    <%
                            }
                        }
                    %>





                </table>
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
