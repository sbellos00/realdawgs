<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page errorPage="RentIt_error.jsp"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account — RealDawgs</title>
    
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
        
        .register-container {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }
        
        .register-wrapper {
            display: grid;
            grid-template-columns: 1fr 1.2fr;
            max-width: 1100px;
            width: 100%;
            background: var(--bg-card);
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 25px 50px rgba(0,0,0,0.5);
        }
        
        @media (max-width: 900px) {
            .register-wrapper {
                grid-template-columns: 1fr;
            }
            .register-visual {
                display: none;
            }
        }
        
        .register-visual {
            background: linear-gradient(135deg, rgba(212, 168, 83, 0.2) 0%, rgba(10, 10, 11, 0.95) 100%),
                        url('https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800&q=80');
            background-size: cover;
            background-position: center;
            padding: 3rem;
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
        }
        
        .register-visual h2 {
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }
        
        .register-visual p {
            color: var(--text-secondary);
        }
        
        .register-form-container {
            padding: 2.5rem 3rem;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        
        .brand {
            font-family: 'Playfair Display', serif;
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
            text-decoration: none;
            color: var(--text-primary);
        }
        
        .brand span {
            color: var(--accent);
        }
        
        .register-form-container h1 {
            font-size: 1.75rem;
            margin-bottom: 0.5rem;
        }
        
        .register-form-container .subtitle {
            color: var(--text-secondary);
            margin-bottom: 1.5rem;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }
        
        @media (max-width: 500px) {
            .form-row {
                grid-template-columns: 1fr;
            }
        }
        
        .form-group {
            margin-bottom: 1rem;
        }
        
        .form-group label {
            display: block;
            font-size: 0.85rem;
            font-weight: 500;
            margin-bottom: 0.4rem;
            color: var(--text-secondary);
        }
        
        .form-group input {
            width: 100%;
            padding: 0.8rem 1rem;
            background: var(--bg-input);
            border: 1px solid var(--border);
            border-radius: 10px;
            color: var(--text-primary);
            font-size: 0.95rem;
            font-family: inherit;
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
        }
        
        .form-group input:focus {
            outline: none;
            border-color: var(--accent);
            box-shadow: 0 0 0 3px rgba(212, 168, 83, 0.15);
        }
        
        .form-group input::placeholder {
            color: var(--text-muted);
        }
        
        .checkbox-group {
            display: flex;
            align-items: flex-start;
            gap: 0.75rem;
            margin: 1.25rem 0;
        }
        
        .checkbox-group input[type="checkbox"] {
            width: 18px;
            height: 18px;
            margin-top: 2px;
            accent-color: var(--accent);
            cursor: pointer;
        }
        
        .checkbox-group label {
            font-size: 0.9rem;
            color: var(--text-secondary);
            cursor: pointer;
        }
        
        .checkbox-group a {
            color: var(--accent);
            text-decoration: none;
        }
        
        .checkbox-group a:hover {
            text-decoration: underline;
        }
        
        .btn-primary {
            width: 100%;
            padding: 1rem;
            background: var(--accent);
            color: var(--bg-dark);
            font-size: 1rem;
            font-weight: 600;
            font-family: inherit;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            transition: background 0.2s ease, transform 0.2s ease;
        }
        
        .btn-primary:hover {
            background: var(--accent-hover);
            transform: translateY(-2px);
        }
        
        .btn-secondary {
            padding: 1rem;
            background: transparent;
            color: var(--text-secondary);
            font-size: 0.95rem;
            font-weight: 500;
            font-family: inherit;
            border: 1px solid var(--border);
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        
        .btn-secondary:hover {
            border-color: var(--text-muted);
            color: var(--text-primary);
        }
        
        .button-group {
            display: flex;
            gap: 1rem;
            margin-top: 0.5rem;
        }
        
        .button-group .btn-primary {
            flex: 2;
        }
        
        .button-group .btn-secondary {
            flex: 1;
        }
        
        .divider {
            text-align: center;
            margin: 1.25rem 0;
            color: var(--text-muted);
            font-size: 0.85rem;
        }
        
        .login-link {
            text-align: center;
            color: var(--text-secondary);
            font-size: 0.95rem;
        }
        
        .login-link a {
            color: var(--accent);
            text-decoration: none;
            font-weight: 500;
        }
        
        .login-link a:hover {
            text-decoration: underline;
        }
        
        .alert {
            padding: 1rem;
            border-radius: 10px;
            margin-bottom: 1.5rem;
            font-size: 0.9rem;
        }
        
        .alert-error {
            background: rgba(231, 76, 60, 0.15);
            border: 1px solid var(--error);
            color: #ff6b6b;
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

<a href="home.jsp" class="back-link">← Back to Home</a>

<div class="register-container">
    <div class="register-wrapper">
        <div class="register-visual">
            <h2>Join RealDawgs</h2>
            <p>Start your journey to finding the perfect property in Athens</p>
        </div>
        
        <div class="register-form-container">
            <a href="home.jsp" class="brand">Real<span>Dawgs</span></a>
            
            <h1>Create Account</h1>
            <p class="subtitle">Fill in your details to get started</p>
            
            <% if(request.getAttribute("error") != null) { %>
                <div class="alert alert-error">
                    <%= (String)request.getAttribute("error") %>
                </div>
            <% } %>
            
            <form action="RentIt_registerController.jsp" method="post">
                <div class="form-row">
                    <div class="form-group">
                        <label for="name">First Name</label>
                        <input type="text" id="name" name="name" placeholder="John" required>
                    </div>
                    <div class="form-group">
                        <label for="surname">Last Name</label>
                        <input type="text" id="surname" name="surname" placeholder="Doe" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" placeholder="john@example.com" required>
                </div>
                
                <div class="form-group">
                    <label for="phone_number">Phone Number</label>
                    <input type="tel" id="phone_number" name="phone_number" placeholder="+30 123 456 7890" required>
                </div>
                
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" placeholder="Choose a username" required>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" placeholder="Min. 6 characters" required>
                    </div>
                    <div class="form-group">
                        <label for="confirm">Confirm Password</label>
                        <input type="password" id="confirm" name="confirm" placeholder="Repeat password" required>
                    </div>
                </div>
                
                <div class="checkbox-group">
                    <input type="checkbox" id="terms" name="terms" required>
                    <label for="terms">I agree to the <a href="#">Terms of Service</a> and <a href="#">Privacy Policy</a></label>
                </div>
                
                <div class="button-group">
                    <button type="submit" class="btn-primary">Create Account</button>
                    <button type="reset" class="btn-secondary">Clear</button>
                </div>
            </form>
            
            <div class="divider">or</div>
            
            <p class="login-link">
                Already have an account? <a href="RentIt_login.jsp">Sign in</a>
            </p>
        </div>
    </div>
</div>

</body>
</html>
