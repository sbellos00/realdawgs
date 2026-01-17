<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="RentIt.models.User" %>
<%
    // Check if user is logged in
    User loggedInUser = (User) session.getAttribute("userObj2024");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RealDawgs — Premium Athens Real Estate</title>
    
    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --bg-dark: #0a0a0b;
            --bg-card: #141416;
            --bg-elevated: #1a1a1d;
            --accent: #d4a853;
            --accent-hover: #e8bc6a;
            --text-primary: #ffffff;
            --text-secondary: #a0a0a5;
            --text-muted: #6b6b70;
            --border: #2a2a2d;
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
            line-height: 1.6;
        }
        
        h1, h2, h3, h4, h5 {
            font-family: 'Playfair Display', serif;
            font-weight: 600;
        }
        
        a {
            text-decoration: none;
            color: inherit;
        }
        
        /* Navbar */
        .navbar {
            background: rgba(10, 10, 11, 0.95);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid var(--border);
            padding: 1rem 0;
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 1000;
        }
        
        .navbar-inner {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 2rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        
        .brand {
            font-family: 'Playfair Display', serif;
            font-size: 1.5rem;
            font-weight: 700;
        }
        
        .brand span {
            color: var(--accent);
        }
        
        .nav-links {
            display: flex;
            align-items: center;
            gap: 2rem;
            list-style: none;
        }
        
        .nav-links a {
            color: var(--text-secondary);
            font-weight: 500;
            font-size: 0.95rem;
            transition: color 0.2s;
        }
        
        .nav-links a:hover {
            color: var(--text-primary);
        }
        
        .btn-accent {
            background: var(--accent);
            color: var(--bg-dark) !important;
            font-weight: 600;
            padding: 0.6rem 1.25rem;
            border-radius: 8px;
            transition: all 0.2s;
        }
        
        .btn-accent:hover {
            background: var(--accent-hover);
            transform: translateY(-2px);
        }
        
        .user-greeting {
            color: var(--text-secondary);
        }
        
        .user-greeting strong {
            color: var(--accent);
        }
        
        /* Hero Section */
        .hero {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 120px 20px 80px;
            background: linear-gradient(180deg, var(--bg-dark) 0%, #0f0f12 100%);
            position: relative;
            overflow: hidden;
        }
        
        .hero::before {
            content: '';
            position: absolute;
            top: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 800px;
            height: 800px;
            background: radial-gradient(circle, rgba(212, 168, 83, 0.08) 0%, transparent 70%);
            pointer-events: none;
        }
        
        .hero-content {
            max-width: 800px;
            z-index: 1;
        }
        
        .hero h1 {
            font-size: 4rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
            line-height: 1.1;
            animation: fadeInUp 0.8s ease;
        }
        
        .hero h1 span {
            color: var(--accent);
        }
        
        .hero p {
            font-size: 1.25rem;
            color: var(--text-secondary);
            margin-bottom: 2.5rem;
            animation: fadeInUp 0.8s ease 0.1s both;
        }
        
        .welcome-message {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 1rem 2rem;
            margin-bottom: 2rem;
            display: inline-block;
            animation: fadeInUp 0.8s ease;
        }
        
        .welcome-message span {
            color: var(--accent);
            font-weight: 600;
        }
        
        .hero-cta {
            animation: fadeInUp 0.8s ease 0.2s both;
        }
        
        .hero-cta .btn {
            display: inline-block;
            margin: 0 0.5rem;
            padding: 1rem 2rem;
            font-size: 1rem;
            font-weight: 600;
            border-radius: 10px;
            transition: all 0.2s;
        }
        
        .btn-primary {
            background: var(--accent);
            color: var(--bg-dark);
        }
        
        .btn-primary:hover {
            background: var(--accent-hover);
            transform: translateY(-2px);
        }
        
        .btn-outline {
            border: 2px solid var(--border);
            color: var(--text-primary);
            background: transparent;
        }
        
        .btn-outline:hover {
            border-color: var(--text-secondary);
            background: rgba(255,255,255,0.05);
        }
        
        /* Stats */
        .stats {
            display: flex;
            justify-content: center;
            gap: 4rem;
            margin-top: 4rem;
            animation: fadeInUp 0.8s ease 0.3s both;
        }
        
        .stat {
            text-align: center;
        }
        
        .stat-number {
            font-family: 'Playfair Display', serif;
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--accent);
        }
        
        .stat-label {
            font-size: 0.85rem;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        /* Neighborhoods */
        .neighborhoods {
            padding: 100px 0;
            background: var(--bg-dark);
        }
        
        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 2rem;
        }
        
        .section-header {
            text-align: center;
            margin-bottom: 4rem;
        }
        
        .section-header h2 {
            font-size: 2.5rem;
            margin-bottom: 1rem;
        }
        
        .section-header p {
            color: var(--text-secondary);
            font-size: 1.1rem;
        }
        
        .neighborhood-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1.5rem;
        }
        
        @media (max-width: 992px) {
            .neighborhood-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        
        @media (max-width: 576px) {
            .neighborhood-grid {
                grid-template-columns: 1fr;
            }
            .hero h1 {
                font-size: 2.5rem;
            }
            .stats {
                flex-direction: column;
                gap: 2rem;
            }
            .nav-links {
                display: none;
            }
        }
        
        .neighborhood-card {
            background: var(--bg-card);
            border-radius: 16px;
            overflow: hidden;
            border: 1px solid var(--border);
            transition: transform 0.3s ease, box-shadow 0.3s ease, border-color 0.3s ease;
            text-decoration: none;
        }
        
        .neighborhood-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.4);
            border-color: var(--accent);
        }
        
        .neighborhood-image {
            aspect-ratio: 16/10;
            overflow: hidden;
        }
        
        .neighborhood-card img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }
        
        .neighborhood-card:hover img {
            transform: scale(1.08);
        }
        
        .neighborhood-info {
            padding: 1.25rem 1.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .neighborhood-name {
            font-family: 'Playfair Display', serif;
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-primary);
            margin: 0;
        }
        
        .neighborhood-count {
            font-size: 0.85rem;
            color: var(--text-muted);
        }
        
        .neighborhood-arrow {
            width: 36px;
            height: 36px;
            background: var(--bg-elevated);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s ease;
            flex-shrink: 0;
        }
        
        .neighborhood-card:hover .neighborhood-arrow {
            background: var(--accent);
        }
        
        .neighborhood-arrow svg {
            width: 18px;
            height: 18px;
            stroke: var(--text-muted);
            fill: none;
            stroke-width: 2;
            transition: stroke 0.2s ease;
        }
        
        .neighborhood-card:hover .neighborhood-arrow svg {
            stroke: var(--bg-dark);
        }
        
        /* Footer */
        footer {
            background: var(--bg-card);
            border-top: 1px solid var(--border);
            padding: 3rem 0;
            text-align: center;
        }
        
        footer p {
            color: var(--text-muted);
            margin: 0;
        }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar">
    <div class="navbar-inner">
        <a href="home.html" class="brand">Real<span>Dawgs</span></a>
        
        <ul class="nav-links">
            <li><a href="home.html">Home</a></li>
            <li><a href="areaOptions.jsp">Properties</a></li>
            <% if (loggedInUser != null) { %>
                <li><span class="user-greeting">Welcome, <strong><%= loggedInUser.getName() %></strong></span></li>
                <li><a href="logout.jsp">Logout</a></li>
            <% } else { %>
                <li><a href="RentIt_login.jsp">Login</a></li>
                <li><a href="RentIt_register.jsp" class="btn-accent">Get Started</a></li>
            <% } %>
        </ul>
    </div>
</nav>

<!-- Hero Section -->
<section class="hero">
    <div class="hero-content">
        <% if (loggedInUser != null) { %>
            <div class="welcome-message">
                Welcome back, <span><%= loggedInUser.getName() %></span>! 👋
            </div>
        <% } %>
        
        <h1>Find Your <span>Dream Home</span> in Athens</h1>
        <p>Discover exceptional properties in the most sought-after neighborhoods. From modern apartments to luxury villas.</p>
        
        <div class="hero-cta">
            <a href="areaOptions.jsp" class="btn btn-primary">Browse Properties</a>
            <% if (loggedInUser == null) { %>
                <a href="RentIt_register.jsp" class="btn btn-outline">Create Account</a>
            <% } %>
        </div>
        
        <div class="stats">
            <div class="stat">
                <div class="stat-number">500+</div>
                <div class="stat-label">Properties</div>
            </div>
            <div class="stat">
                <div class="stat-number">6</div>
                <div class="stat-label">Neighborhoods</div>
            </div>
            <div class="stat">
                <div class="stat-number">98%</div>
                <div class="stat-label">Happy Clients</div>
            </div>
        </div>
    </div>
</section>

<!-- Neighborhoods Section -->
<section class="neighborhoods">
    <div class="container">
        <div class="section-header">
            <h2>Explore Neighborhoods</h2>
            <p>Each area offers its own unique character and lifestyle</p>
        </div>
        
        <div class="neighborhood-grid">
            <a href="areaOptions.jsp?area=Kypseli" class="neighborhood-card">
                <div class="neighborhood-image">
                    <img src="https://images.unsplash.com/photo-1555993539-1732b0258235?w=800&q=80" alt="Kypseli">
                </div>
                <div class="neighborhood-info">
                    <div>
                        <div class="neighborhood-name">Kypseli</div>
                        <div class="neighborhood-count">12 properties</div>
                    </div>
                    <div class="neighborhood-arrow">
                        <svg viewBox="0 0 24 24"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
                    </div>
                </div>
            </a>
            
            <a href="areaOptions.jsp?area=Piraeus" class="neighborhood-card">
                <div class="neighborhood-image">
                    <img src="https://images.unsplash.com/photo-1534430480872-3498386e7856?w=800&q=80" alt="Piraeus">
                </div>
                <div class="neighborhood-info">
                    <div>
                        <div class="neighborhood-name">Piraeus</div>
                        <div class="neighborhood-count">8 properties</div>
                    </div>
                    <div class="neighborhood-arrow">
                        <svg viewBox="0 0 24 24"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
                    </div>
                </div>
            </a>
            
            <a href="areaOptions.jsp?area=Peristeri" class="neighborhood-card">
                <div class="neighborhood-image">
                    <img src="https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800&q=80" alt="Peristeri">
                </div>
                <div class="neighborhood-info">
                    <div>
                        <div class="neighborhood-name">Peristeri</div>
                        <div class="neighborhood-count">10 properties</div>
                    </div>
                    <div class="neighborhood-arrow">
                        <svg viewBox="0 0 24 24"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
                    </div>
                </div>
            </a>
            
            <a href="areaOptions.jsp?area=Monastiraki" class="neighborhood-card">
                <div class="neighborhood-image">
                    <img src="https://images.unsplash.com/photo-1603565816030-6b389eeb23cb?w=800&q=80" alt="Monastiraki">
                </div>
                <div class="neighborhood-info">
                    <div>
                        <div class="neighborhood-name">Monastiraki</div>
                        <div class="neighborhood-count">6 properties</div>
                    </div>
                    <div class="neighborhood-arrow">
                        <svg viewBox="0 0 24 24"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
                    </div>
                </div>
            </a>
            
            <a href="areaOptions.jsp?area=Aghia Paraskevi" class="neighborhood-card">
                <div class="neighborhood-image">
                    <img src="https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800&q=80" alt="Aghia Paraskevi">
                </div>
                <div class="neighborhood-info">
                    <div>
                        <div class="neighborhood-name">Aghia Paraskevi</div>
                        <div class="neighborhood-count">9 properties</div>
                    </div>
                    <div class="neighborhood-arrow">
                        <svg viewBox="0 0 24 24"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
                    </div>
                </div>
            </a>
            
            <a href="areaOptions.jsp?area=Chalandri" class="neighborhood-card">
                <div class="neighborhood-image">
                    <img src="https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800&q=80" alt="Chalandri">
                </div>
                <div class="neighborhood-info">
                    <div>
                        <div class="neighborhood-name">Chalandri</div>
                        <div class="neighborhood-count">11 properties</div>
                    </div>
                    <div class="neighborhood-arrow">
                        <svg viewBox="0 0 24 24"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
                    </div>
                </div>
            </a>
        </div>
    </div>
</section>

<!-- Footer -->
<footer>
    <div class="container">
        <p>© 2026 RealDawgs. Premium real estate in Athens.</p>
    </div>
</footer>

</body>
</html>
