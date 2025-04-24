<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*" %>
<jsp:include page="/header.jsp">
    <jsp:param name="pageTitle" value="Register"/>
</jsp:include>
<html>
<head>
    <title>Register</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 20px;
        }
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

    <h2>Register</h2>

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
        <input type="text" name="customerName" required />

        <label>Contact Number:</label>
        <input type="text" name="contactNumber" required />

        <label>Email:</label>
        <input type="email" name="email" required />

        <label>Username:</label>
        <input type="text" name="username" required />

        <label>Password:</label>
        <input type="password" name="password" required />

        <label>Confirm Password:</label>
        <input type="password" name="confirmPassword" required />

        <input type="submit" value="Register" />
    </form>

    <p>Already have an account? <a href="loginC.jsp">Login here</a></p>

</body>
</html>


