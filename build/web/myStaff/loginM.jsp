<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="/header.jsp">
    <jsp:param name="pageTitle" value="Staff and Manager Login"/>
</jsp:include>
<html>
<head>
    <title>Staff and Manager Login</title>
    <style>
        .login-container {
            max-width: 400px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f9f9f9;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
            color: #333;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        input {
            display: block;
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        button {
            background-color: #333;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            width: 100%;
        }
        button:hover {
            background-color: grey;
        }
        .error {
            color: red;
            font-weight: bold;
            margin-bottom: 15px;
        }
        .info {
            margin-top: 20px;
            text-align: center;
            color: #666;
        }
        .access-info {
            background-color: #e7f3ff;
            border-left: 4px solid #2196F3;
            padding: 10px;
            margin: 15px 0;
            font-size: 0.9em;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>Staff and Manager Login</h2>
        
        <!-- Show error message if there is one -->
        <div class="error">
            <%
                String error = (String) request.getAttribute("error");
                if (error != null) {
                    out.println(error);
                }
            %>
        </div>
        
        <!-- Login form -->
        <form action="${pageContext.request.contextPath}/StaffManagerLogin" method="post">
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required />
            
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required />
            
            <button type="submit">Login</button>
        </form>
    </div>
</body>
</html> 