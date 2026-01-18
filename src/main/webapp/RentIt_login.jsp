<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page errorPage="RentIt_error.jsp"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
	<head>  
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login — RealDawgs</title>
    
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
        
        .login-container {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }
        
        .login-wrapper {
            display: grid;
            grid-template-columns: 1fr 1fr;
            max-width: 1000px;
            width: 100%;
            background: var(--bg-card);
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 25px 50px rgba(0,0,0,0.5);
        }
        
        @media (max-width: 768px) {
            .login-wrapper {
                grid-template-columns: 1fr;
            }
            .login-visual {
                display: none;
            }
        }
        
        .login-visual {
            background: linear-gradient(135deg, rgba(212, 168, 83, 0.2) 0%, rgba(10, 10, 11, 0.95) 100%),
                        url('https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800&q=80');
            background-size: cover;
            background-position: center;
            padding: 3rem;
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
        }
        
        .login-visual h2 {
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }
        
        .login-visual p {
            color: var(--text-secondary);
        }
        
        .login-form-container {
            padding: 3rem;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        
        .brand {
            font-family: 'Playfair Display', serif;
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 2rem;
            text-decoration: none;
            color: var(--text-primary);
        }
        
        .brand span {
            color: var(--accent);
        }
        
        .login-form-container h1 {
            font-size: 1.75rem;
            margin-bottom: 0.5rem;
        }
        
        .login-form-container .subtitle {
            color: var(--text-secondary);
            margin-bottom: 2rem;
        }
        
        .form-group {
            margin-bottom: 1.25rem;
        }
        
        .form-group label {
            display: block;
            font-size: 0.9rem;
            font-weight: 500;
            margin-bottom: 0.5rem;
            color: var(--text-secondary);
        }
        
        .form-group input {
            width: 100%;
            padding: 0.9rem 1rem;
            background: var(--bg-input);
            border: 1px solid var(--border);
            border-radius: 10px;
            color: var(--text-primary);
            font-size: 1rem;
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
            margin-top: 0.5rem;
        }
        
        .btn-primary:hover {
            background: var(--accent-hover);
            transform: translateY(-2px);
        }
        
        .divider {
            text-align: center;
            margin: 1.5rem 0;
            color: var(--text-muted);
            font-size: 0.85rem;
        }
        
        .register-link {
            text-align: center;
            color: var(--text-secondary);
            font-size: 0.95rem;
        }
        
        .register-link a {
            color: var(--accent);
            text-decoration: none;
            font-weight: 500;
        }
        
        .register-link a:hover {
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
        
        .alert-info {
            background: rgba(212, 168, 83, 0.15);
            border: 1px solid var(--accent);
            color: var(--accent);
        }
        
        .demo-accounts {
            margin-top: 2rem;
            padding: 1rem;
            background: var(--bg-elevated);
            border-radius: 10px;
            border: 1px solid var(--border);
        }
        
        .demo-accounts h4 {
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-secondary);
            margin-bottom: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .demo-accounts ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .demo-accounts li {
            font-size: 0.9rem;
            color: var(--text-muted);
            margin-bottom: 0.25rem;
        }
        
        .demo-accounts code {
            background: var(--bg-input);
            padding: 0.15rem 0.4rem;
            border-radius: 4px;
            font-size: 0.85rem;
            color: var(--accent);
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

<div class="login-container">
    <div class="login-wrapper">
        <div class="login-visual">
            <h2>Welcome Back</h2>
            <p>Sign in to continue your property search</p>
        </div>
        
        <div class="login-form-container">
            <a href="home.jsp" class="brand">Real<span>Dawgs</span></a>
            
            <h1>Sign In</h1>
            <p class="subtitle">Enter your credentials to access your account</p>

            <% if(request.getAttribute("message") != null) { %>		
                <div class="alert alert-error">
                    <%= (String)request.getAttribute("message") %>
                </div>
            <% } %>
    
            <form method="post" action="RentIt_loginController.jsp">
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" placeholder="Enter your username" required>
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" placeholder="Enter your password" required>
                </div>
                
                <button type="submit" class="btn-primary">Sign In</button>
            </form>
            
            <div class="divider">or</div>
            
            <p class="register-link">
                Don't have an account? <a href="RentIt_register.jsp">Create one</a>
            </p>
            
            <div class="demo-accounts">
                <h4>Demo Accounts</h4>
                <ul>
                    <li><code>jdoe</code> / <code>1111</code></li>
                    <li><code>msmith</code> / <code>2222</code></li>
                    </ul>
            </div>
        </div>
    </div>
</div>
		
	</body>
</html>
