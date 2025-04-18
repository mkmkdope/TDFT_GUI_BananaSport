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

<div class="container">
    <h1>Product List</h1>

    <table style="width:100%; border-collapse: collapse;">
        <tr style="background-color:#28a745; color:white;">
             <th style="padding:10px; border:1px solid #ddd;">Image</th>
            <th style="padding:10px; border:1px solid #ddd;">ID</th>
            <th style="padding:10px; border:1px solid #ddd;">Name</th>
            <th style="padding:10px; border:1px solid #ddd;">Category</th>
            <th style="padding:10px; border:1px solid #ddd;">Price</th>
            <th style="padding:10px; border:1px solid #ddd;">Quantity</th>
             <th style="padding:10px; border:1px solid #ddd;">Description</th>
           
            <th colspan ="2"; style=" padding:20px; border:1px solid #ddd;">Action</th>
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
                     <img src="images/<%= product.getImageLink() %>" width="60" height="60" style="object-fit: cover;">
                </td>
                <td style="padding:10px; border:1px solid #ddd;"><%= product.getProductId() %></td>
                <td style="padding:10px; border:1px solid #ddd;"><%= product.getProductName() %></td>
                <td style="padding:10px; border:1px solid #ddd;"><%= product.getProductCategory() %></td>
                <td style="padding:10px; border:1px solid #ddd;">RM <%= product.getProductPrice() %></td>
                <td style="padding:10px; border:1px solid #ddd;"><%= product.getProductQty() %></td>
                 <td style="padding:10px; border:1px solid #ddd;"><%= product.getDescription() %></td>
               
                <td style="padding:10px; border:1px solid #ddd;">
                    <form action="ControlProdM" method="post">
                        <input  type="hidden" name="id" value="<%= product.getProductId() %>" />
                        <button style="background-color:blue; color:white;" name="action" value="modify" type="submit" style="padding:6px 12px;">Modify</button>
                    </form>
                </td>
                <td style="padding:10px; border:1px solid #ddd;">
                    <form action="ControlProdM" method="post">
                        <input type="hidden" name="id" value="<%= product.getProductId() %>" />
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
