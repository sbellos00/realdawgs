<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="RentIt.dao.UserDAO" %>
<%@ page import="RentIt.models.User" %>
<%@ page errorPage="RentIt_error.jsp"%>
<%
    String name = request.getParameter("name");
    String surname = request.getParameter("surname");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone_number");
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String confirm = request.getParameter("confirm");
    String terms = request.getParameter("terms");

    List<String> errors = new ArrayList<String>();
    boolean registrationSuccess = false;

    if (name == null || name.length() < 3) {
        errors.add("Name must be at least 3 characters long.");
    }
    if (surname == null || surname.length() < 3) {
        errors.add("Surname must be at least 3 characters long.");
    }
    // Clean phone number (remove spaces, dashes, etc.) for validation
    String cleanPhone = phone != null ? phone.replaceAll("[\\s\\-\\(\\)\\+]", "") : "";
    if (cleanPhone.length() < 10 || cleanPhone.length() > 15) {
        errors.add("Phone number must be between 10 and 15 digits.");
    }
    if (username == null || username.length() < 5) {
        errors.add("Username must be at least 5 characters long.");
    }
    if (password == null || password.length() < 6) {
        errors.add("Password must be at least 6 characters long.");
    }
    if (confirm == null || !confirm.equals(password)) {
        errors.add("Password and confirm password must match.");
    }
    if (terms == null) {
        errors.add("You must agree to the terms and conditions.");
    }

    if (errors.isEmpty()) {
        try {
            UserDAO userDAO = new UserDAO();
            User user = new User(username, password, name, surname, email, phone, "customer");
            userDAO.register(user);
            registrationSuccess = true;
        } catch (Exception e) {
            errors.add(e.getMessage());
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= registrationSuccess ? "Registration Successful" : "Registration Error" %> — RealDawgs</title>
    
    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --bg-dark: #0a0a0b;
            --bg-card: #141416;
            --bg-elevated: #1a1a1d;
            --bg-input: #1f1f23;
            --accent: #d4a853;
            --accent-hover: #e8bc6a;
            --text-primary: #ffffff;
            --text-secondary: #a0a0a5;
            --text-muted: #6b6b70;
            --border: #2a2a2d;
            --error: #e74c3c;
            --success: #2ecc71;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'DM Sans', sans-serif;
            background-color: var(--bg-dark);
            color: var(--text-primary);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        
        h1, h2, h3 {
            font-family: 'Playfair Display', serif;
        }
        
        .result-container {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }
        
        .result-card {
            max-width: 550px;
            width: 100%;
            background: var(--bg-card);
            border-radius: 20px;
            padding: 3rem;
            box-shadow: 0 25px 50px rgba(0,0,0,0.5);
            text-align: center;
        }
        
        .brand {
            font-family: 'Playfair Display', serif;
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 2rem;
            text-decoration: none;
            color: var(--text-primary);
            display: inline-block;
        }
        
        .brand span {
            color: var(--accent);
        }
        
        .icon-circle {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
            font-size: 2.5rem;
        }
        
        .icon-success {
            background: rgba(46, 204, 113, 0.15);
            color: var(--success);
        }
        
        .icon-error {
            background: rgba(231, 76, 60, 0.15);
            color: var(--error);
        }
        
        .result-card h1 {
            font-size: 1.75rem;
            margin-bottom: 0.75rem;
        }
        
        .result-card .subtitle {
            color: var(--text-secondary);
            margin-bottom: 2rem;
            line-height: 1.6;
        }
        
        .user-details {
            background: var(--bg-elevated);
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            text-align: left;
        }
        
        .user-details .detail-row {
            display: flex;
            justify-content: space-between;
            padding: 0.6rem 0;
            border-bottom: 1px solid var(--border);
        }
        
        .user-details .detail-row:last-child {
            border-bottom: none;
        }
        
        .user-details .label {
            color: var(--text-muted);
            font-size: 0.9rem;
        }
        
        .user-details .value {
            color: var(--text-primary);
            font-weight: 500;
        }
        
        .error-list {
            background: rgba(231, 76, 60, 0.1);
            border: 1px solid rgba(231, 76, 60, 0.3);
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            text-align: left;
        }
        
        .error-list ul {
            margin: 0;
            padding-left: 1.25rem;
        }
        
        .error-list li {
            color: #ff6b6b;
            margin-bottom: 0.5rem;
            line-height: 1.5;
        }
        
        .error-list li:last-child {
            margin-bottom: 0;
        }
        
        .btn-primary {
            display: inline-block;
            padding: 1rem 2rem;
            background: var(--accent);
            color: var(--bg-dark);
            font-size: 1rem;
            font-weight: 600;
            font-family: inherit;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            text-decoration: none;
            transition: background 0.2s ease, transform 0.2s ease;
        }
        
        .btn-primary:hover {
            background: var(--accent-hover);
            transform: translateY(-2px);
        }
        
        .btn-secondary {
            display: inline-block;
            padding: 1rem 2rem;
            background: transparent;
            color: var(--text-secondary);
            font-size: 1rem;
            font-weight: 500;
            font-family: inherit;
            border: 1px solid var(--border);
            border-radius: 10px;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.2s ease;
            margin-left: 1rem;
        }
        
        .btn-secondary:hover {
            border-color: var(--text-muted);
            color: var(--text-primary);
        }
        
        .button-group {
            display: flex;
            justify-content: center;
            gap: 1rem;
            flex-wrap: wrap;
        }
        
        .back-link {
            position: fixed;
            top: 20px;
            left: 20px;
            color: var(--text-secondary);
            text-decoration: none;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            transition: color 0.2s;
        }
        
        .back-link:hover {
            color: var(--text-primary);
        }
    </style>
</head>
<body>

<a href="home.html" class="back-link">← Back to Home</a>

<div class="result-container">
    <div class="result-card">
        <a href="home.html" class="brand">Real<span>Dawgs</span></a>
        
        <% if (registrationSuccess) { %>
            <div class="icon-circle icon-success">✓</div>
            <h1>Registration Successful!</h1>
            <p class="subtitle">Welcome to RealDawgs, <strong><%= name %></strong>! Your account has been created successfully. You can now sign in to start browsing properties.</p>
            
            <div class="user-details">
                <div class="detail-row">
                    <span class="label">Name</span>
                    <span class="value"><%= name %> <%= surname %></span>
                </div>
                <div class="detail-row">
                    <span class="label">Username</span>
                    <span class="value"><%= username %></span>
                </div>
                <div class="detail-row">
                    <span class="label">Email</span>
                    <span class="value"><%= email %></span>
                </div>
                <div class="detail-row">
                    <span class="label">Phone</span>
                    <span class="value"><%= phone %></span>
                </div>
            </div>
            
            <div class="button-group">
                <a href="RentIt_login.jsp" class="btn-primary">Sign In Now</a>
                <a href="home.html" class="btn-secondary">Browse Properties</a>
            </div>
        <% } else { %>
            <div class="icon-circle icon-error">✕</div>
            <h1>Registration Failed</h1>
            <p class="subtitle">Please correct the following errors and try again.</p>
            
            <div class="error-list">
                <ul>
                    <% for (String error : errors) { %>
                        <li><%= error %></li>
                    <% } %>
                </ul>
            </div>
            
            <div class="button-group">
                <a href="RentIt_register.jsp" class="btn-primary">Try Again</a>
                <a href="home.html" class="btn-secondary">Back to Home</a>
            </div>
        <% } %>
    </div>
</div>

</body>
</html>