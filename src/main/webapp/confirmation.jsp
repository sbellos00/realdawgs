<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thank You — RealDawgs</title>
    
    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --bg-dark: #0a0a0b;
            --bg-card: #141416;
            --accent: #d4a853;
            --accent-hover: #e8bc6a;
            --text-primary: #ffffff;
            --text-secondary: #a0a0a5;
            --border: #2a2a2d;
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
            align-items: center;
            justify-content: center;
            padding: 2rem;
        }
        
        h1 {
            font-family: 'Playfair Display', serif;
        }
        
        .confirmation-card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 24px;
            padding: 3rem;
            text-align: center;
            max-width: 500px;
            animation: fadeIn 0.6s ease;
        }
        
        .success-icon {
            width: 100px;
            height: 100px;
            background: rgba(46, 204, 113, 0.15);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 2rem;
        }
        
        .success-icon svg {
            width: 50px;
            height: 50px;
            stroke: var(--success);
        }
        
        h1 {
            font-size: 2rem;
            margin-bottom: 1rem;
        }
        
        p {
            color: var(--text-secondary);
            font-size: 1.1rem;
            margin-bottom: 2rem;
            line-height: 1.6;
        }
        
        .btn {
            display: inline-block;
            padding: 1rem 2rem;
            background: var(--accent);
            color: var(--bg-dark);
            border-radius: 10px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s;
        }
        
        .btn:hover {
            background: var(--accent-hover);
            transform: translateY(-2px);
        }
        
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>
    <div class="confirmation-card">
        <div class="success-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <polyline points="20 6 9 17 4 12"></polyline>
            </svg>
        </div>
        <h1>Thank You!</h1>
        <p>Your submission has been received. We appreciate your interest and will be in touch soon.</p>
        <a href="home.jsp" class="btn">Return Home</a>
    </div>
</body>
</html>
