<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login Selection</title>
    <style>
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
            text-align: center;
        }
        
        h1 {
            color: #333;
            margin-bottom: 20px;
        }
        
        .login-options {
            margin: 30px 0;
        }
        
        .login-option {
            margin: 15px 0;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s;
            text-align: left;
        }
        
        .login-option:hover {
            background-color: #f0f0f0;
            transform: translateY(-2px);
        }
        
        .customer {
            border-left: 5px solid #4CAF50;
        }
        
        .staff {
            border-left: 5px solid #2196F3;
        }
        
        .login-option h3 {
            margin: 0 0 5px 0;
            color: #333;
        }
        
        .login-option p {
            color: #666;
            margin: 0;
        }
        
        .quick-links {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 20px;
            margin: 30px 0;
        }
        
        .quick-links a {
            color: #333;
            text-decoration: none;
        }
        
        .quick-links a:hover {
            text-decoration: underline;
        }
        
        .contact-info {
            margin: 20px 0;
            color: #666;
            line-height: 1.6;
        }
        
        .social-icons {
            margin: 20px 0;
        }
        
        .social-icons span {
            margin: 0 10px;
            font-size: 20px;
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
    <jsp:include page="header.jsp"></jsp:include>
    
    <div class="main-content">
        <div class="login-container">
            <h1>Welcome to Our System</h1>
            <p>Please select your login type:</p>
            
            <div class="login-options">
                <div class="login-option customer" onclick="location.href='customer-login.jsp'">
                    <h3>Customer Login</h3>
                    <p>Access your customer account</p>
                </div>
                
                <div class="login-option staff" onclick="location.href='myStaff/controlPanelM.jsp'">
                    <h3>Staff Login</h3>
                    <p>Access the staff portal</p>
                </div>
            </div>
            
        </div>
    </div>
    
    <footer>
        <p>&copy; 2023 Banana Sports. All rights reserved.</p>
    </footer>
</body>
</html>