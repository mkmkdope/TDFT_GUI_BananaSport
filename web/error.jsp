<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Error Page</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #fff4f4;
            color: #a94442;
            padding: 20px;
            text-align: center;
        }
        .error-box {
            border: 1px solid #a94442;
            background-color: #f2dede;
            padding: 20px;
            display: inline-block;
            border-radius: 8px;
        }
    </style>
</head>
<body>
    <div class="error-box">
        <h1>Error Occurred!</h1>
        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
            <p><strong><%= error %></strong></p>
        <%
            } else {
        %>
            <p>Unknown error occurred.</p>
        <%
            }
        %>
        <br>
        <a href="controlPanelM.jsp">← Back to Control Panel</a>
    </div>
</body>
</html>
