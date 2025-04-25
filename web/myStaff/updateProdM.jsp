<%@page import="java.util.List"%>
<%@page import="model.Products"%>


<jsp:include page="controlPanelM.jsp">
    <jsp:param name="pageTitle" value="Products"/>
</jsp:include>



<%
    List<Products> productList = (List<Products>) request.getAttribute("products");
    if (productList == null) {
        productList = new java.util.ArrayList<>(); // fallback if nothing in request
    }
%>

<hr style="margin: 40px 0;">
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
