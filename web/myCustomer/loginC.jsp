<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="/header.jsp">
    <jsp:param name="pageTitle" value="Login"/>
</jsp:include>
<html>
<head>
    <title>Login</title>
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
        .success {
            color: green;
            font-weight: bold;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>

    <h2>Login</h2>

    <!-- Show error message if there is one -->
    <div class="error">
        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
                out.println(error);
            }
        %>
    </div>
    
    <!-- Show success message if redirected from registration -->
    <div class="success">
        <%
            String success = (String) request.getAttribute("success");
            if (success != null) {
                out.println(success);
            }
        %>
    </div>

    <!-- Login form -->
    <form action="${pageContext.request.contextPath}/customerLogin" method="post">
        <label>Username:</label>
        <input type="text" name="username" required />

        <label>Password:</label>
        <input type="password" name="password" required />

        <input type="submit" value="Login" />
    </form>

    <p>Don't have an account? <a href="registerC.jsp">Register here</a></p>

</body>
</html>