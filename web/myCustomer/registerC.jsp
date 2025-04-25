<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*" %>
<jsp:include page="/header.jsp">
    <jsp:param name="pageTitle" value="Register"/>
</jsp:include>
<html>
<head>
    <title>Register</title>
    <style>
        form {
            max-width: 400px;
            margin: auto;
        }
        input {
            display: block;
            margin-bottom: 10px;
            padding: 8px;
            width: 100%;
        }
        .error {
            color: red;
            font-weight: bold;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>

    <h2 style="text-align: center;">Register</h2>

    <!-- Show error message if there is one -->
    <div class="error">
        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
                out.println(error);
            }
        %>
    </div>

    <!-- Registration form -->
    <form action="${pageContext.request.contextPath}/RegisterServlet" method="post">
        <label>Full Name:</label>
        <input type="text" name="customerName" value="<%= request.getParameter("customerName") != null ? request.getParameter("customerName") : "" %>" required />

        <label>Contact Number:</label>
        <input type="text" name="contactNumber" value="<%= request.getParameter("contactNumber") != null ? request.getParameter("contactNumber") : "" %>" required />

        <label>Email:</label>
        <input type="email" name="email" value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>" required />

        <label>Username:</label>
        <input type="text" name="username" value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>" required />

        <label>Password:</label>
        <input type="password" name="password" value="" required />

        <label>Confirm Password:</label>
        <input type="password" name="confirmPassword" value="" required />

        <input type="submit" value="Register" />
    </form>

    <p style="text-align: center;">Already have an account? <a href="${pageContext.request.contextPath}/myCustomer/loginC.jsp">Login here</a></p>

</body>
</html>


