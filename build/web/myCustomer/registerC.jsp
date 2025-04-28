<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*" %>
<jsp:include page="/header.jsp">
    <jsp:param name="pageTitle" value="Register"/>
</jsp:include>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register</title>
    <style>
        .main-content {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .register-container {
            background-color: white;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 500px;
            text-align: center;        }

        h2 {
            color: #333;
            margin-bottom: 20px;
        }

        .error {
            color: #d9534f;
            font-weight: bold;
            margin-bottom: 15px;
        }

        form {
            max-width: 400px;
            margin: 0 auto;
            text-align: left;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: bold;
        }

        input {
            display: block;
            margin-bottom: 15px;
            padding: 12px;
            width: 100%;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 14px;
            transition: all 0.3s;
        }

        input:focus {
            border-color: #FFC107;
            outline: none;
            box-shadow: 0 0 5px rgba(255, 193, 7, 0.5);
        }

        input[type="submit"] {
            background-color: #FFC107; 
            color: #333;
            border: none;
            padding: 14px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            transition: all 0.3s;
            margin-top: 10px;
        }

        input[type="submit"]:hover {
            background-color: #ffb300;
            transform: translateY(-2px);
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .login-link {
            margin-top: 25px;
            color: #666;
            font-size: 15px;
        }

        .login-link a {
            color: #FFC107; 
            text-decoration: none;
            font-weight: bold;
            transition: all 0.3s;
        }

        .login-link a:hover {
            text-decoration: underline;
            color: #ffab00; 
            transform: translateY(-1px);
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
        <div class="register-container">
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

            <p class="login-link">Already have an account? <a href="${pageContext.request.contextPath}/myCustomer/loginC.jsp">Login here</a></p>
        </div>
    </div>

    <footer>
        <p>${applicationScope.companyCopyright}</p>
    </footer>
</body>
</html>