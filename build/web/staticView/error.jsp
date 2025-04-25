<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Error Page</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            color: #333;
            padding: 20px;
            text-align: center;
            margin: 0;
        }
        .error-container {
            max-width: 600px;
            margin: 50px auto;
        }
        .error-box {
            border: 1px solid #dedede;
            background-color: #fff;
            padding: 25px;
            display: inline-block;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            width: 100%;
            box-sizing: border-box;
        }
        .error-code {
            font-size: 72px;
            margin: 0;
            font-weight: bold;
        }
        .error-title {
            margin-top: 0;
            color: #333;
        }
        .error-message {
            margin: 20px 0;
            line-height: 1.5;
        }
        .back-link {
            display: inline-block;
            margin-top: 20px;
            color: #0066cc;
            text-decoration: none;
            padding: 10px 20px;
            border: 1px solid #0066cc;
            border-radius: 4px;
            transition: all 0.3s;
        }
        .back-link:hover {
            background-color: #0066cc;
            color: white;
        }
        /* Specific styles for different error types */
        .error-404 { color: #5c6bc0; }
        .error-500 { color: #e53935; }
        .error-403 { color: #f9a825; }
        .error-400 { color: #43a047; }
        .error-default { color: #757575; }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-box">
            <%
                String errorCode = (String) request.getAttribute("javax.servlet.error.status_code");
                String errorMessage = (String) request.getAttribute("error");
                String errorTitle = "Error Occurred";
                String errorClass = "error-default";
                
                if (errorCode == null) {
                    errorCode = "500";
                }
                
                switch (errorCode) {
                    case "404":
                        errorTitle = "Page Not Found";
                        errorClass = "error-404";
                        if (errorMessage == null) {
                            errorMessage = "The page you are looking for might have been removed, had its name changed, or is temporarily unavailable.";
                        }
                        break;
                    case "500":
                        errorTitle = "Internal Server Error";
                        errorClass = "error-500";
                        if (errorMessage == null) {
                            errorMessage = "The server encountered an unexpected condition that prevented it from fulfilling the request.";
                        }
                        break;
                    case "403":
                        errorTitle = "Access Forbidden";
                        errorClass = "error-403";
                        if (errorMessage == null) {
                            errorMessage = "You don't have permission to access this resource.";
                        }
                        break;
                    case "400":
                        errorTitle = "Bad Request";
                        errorClass = "error-400";
                        if (errorMessage == null) {
                            errorMessage = "The server could not understand the request due to invalid syntax.";
                        }
                        break;
                    default:
                        if (errorMessage == null) {
                            errorMessage = "An unknown error occurred.";
                        }
                }
            %>
            <h1 class="error-code <%= errorClass %>"><%= errorCode %></h1>
            <h2 class="error-title"><%= errorTitle %></h2>
            <p class="error-message"><%= errorMessage %></p>
            
            <a href="controlPanelM.jsp" class="back-link">← Back to Control Panel</a>
            <% if ("404".equals(errorCode)) { %>
                <a href="index.jsp" class="back-link">Go to Homepage</a>
            <% } %>
        </div>
    </div>
</body>
</html>
