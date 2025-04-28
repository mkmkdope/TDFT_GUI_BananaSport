<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="/header.jsp">
    <jsp:param name="pageTitle" value="Login"/>
</jsp:include>
<html>
    <head>
        <title>Login</title>
        <style>
            .form-container {
                background-color: #fff;
                padding: 30px 40px;
                border-radius: 10px; /* Smooth rounded corners */
                box-shadow: 0 12px 30px rgba(0, 0, 0, 0.1); /* Deep shadow for better contrast */
                width: 100%;
                max-width: 420px;
                box-sizing: border-box;
                position: absolute;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
            }

            h2 {
                text-align: center;
                margin-bottom: 20px;
                font-size: 24px;
                color: #333;
                font-weight: 600;
            }

            label {
                display: block;
                margin-bottom: 10px;
                color: #555;
                font-weight: 500;
            }

            /* Custom CSS for username */
            .username-input {
                width: 100%;
                padding: 12px;
                margin-bottom: 20px;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 16px;
                color: #333;
                background-color: #f9f9f9;
                box-sizing: border-box;
                transition: border-color 0.3s ease;
            }

            /* Custom CSS for password */
            .password-input {
                width: 100%;
                padding: 12px;
                margin-bottom: 20px;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 16px;
                color: #333;
                background-color: #f9f9f9;
                box-sizing: border-box;
                transition: border-color 0.3s ease;
            }

            .username-input:focus,
            .password-input:focus {
                border-color: #2196F3; /* Blue border on focus */
                outline: none;
            }

            /* Apply Yellow to Login button */
            input[type="submit"] {
                width: 100%;
                padding: 14px;
                background-color: #FFC107; /* Yellow background */
                color: black;
                font-weight: bold;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-size: 16px;
                transition: background-color 0.3s ease;
            }

            input[type="submit"]:hover {
                background-color: #FFB300;
            }

            /* Apply Yellow to Register link */
            p a {
                color: #FFC107;
                text-decoration: none;
                font-weight: 500;
            }

            p a:hover {
                text-decoration: underline;
            }

            .error,
            .success {
                text-align: center;
                font-weight: 600;
                margin-bottom: 20px;
            }

            .error {
                color: red;
            }

            .success {
                color: green;
            }

            p {
                text-align: center;
                font-size: 14px;
                color: #555;
            }
            
           
        </style>
    </head>
    <body>

        <div class="form-container">
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
                <label for="username">Username:</label>
                <input type="text" name="username" id="username" class="username-input" required />

                <label for="password">Password:</label>
                <input type="password" name="password" id="password" class="password-input" required />

                <input type="submit" value="Login" />
            </form>

            <p>Don't have an account? <a href="${pageContext.request.contextPath}/myCustomer/registerC.jsp">Register here</a></p>
        </div>

    </body>

</html>
