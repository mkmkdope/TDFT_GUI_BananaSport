<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="/header.jsp">
    <jsp:param name="pageTitle" value="Staff and Manager Login"/>
</jsp:include>
<html>
<head>
    <title>Staff and Manager Login</title>
    <style>
        /* Reuse the styles from the first JSP */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            background-color: #f8f9fa;
        }

        .main-content {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .login-container {
            background-color: white;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 500px;
        }

        h2 {
            color: #333;
            margin-bottom: 20px;
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
            background-color: #FFC107; /* Yellow for staff & manager login */
            font-weight: bold;
            padding: 10px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            width: 100%;
        }

        button:hover {
            background-color: #FFB300; /* Slightly darker yellow on hover */
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

        footer {
            background-color: #333;
            color: white;
            text-align: center;
            padding: 20px;
            margin-top: auto;
        }
    </style>
</head>
<body>
    <div class="main-content">
        <div class="login-container">
            <h2 style="text-align: center;">Staff and Manager Login</h2>
            
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
    </div>

    <footer>
        <p>${applicationScope.companyCopyright}</p>
    </footer>
</body>
</html>
