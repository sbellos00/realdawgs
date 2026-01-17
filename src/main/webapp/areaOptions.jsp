<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="RentIt.models.Property" %>
<%@ page import="RentIt.dao.PropertyDAO" %>
<%@ page import="RentIt.dao.MockPropertyDAO" %>
<%@ page import="RentIt.models.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%
        String areaParam = request.getParameter("area");
        String area = (areaParam != null && !areaParam.trim().isEmpty()) ? areaParam : "All Areas";
    %>
    <title><%= area %> — Properties | RealDawgs</title>

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
            --success: #2ecc71;
            --info: #3498db;
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
            min-height: 100vh;
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
            color: var(--text-primary);
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
            color: var(--bg-dark);
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
            font-size: 0.95rem;
        }
        
        .user-greeting strong {
            color: var(--accent);
        }
        
        /* Page Header */
        .page-header {
            padding: 140px 2rem 60px;
            text-align: center;
            background: linear-gradient(180deg, var(--bg-dark) 0%, var(--bg-elevated) 100%);
            position: relative;
        }
        
        .page-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 600px;
            height: 400px;
            background: radial-gradient(circle, rgba(212, 168, 83, 0.06) 0%, transparent 70%);
            pointer-events: none;
        }
        
        .page-header h1 {
            font-size: 3rem;
            margin-bottom: 0.5rem;
        }
        
        .page-header h1 span {
            color: var(--accent);
        }
        
        .page-header p {
            color: var(--text-secondary);
            font-size: 1.1rem;
        }
        
        .breadcrumb {
            display: flex;
            justify-content: center;
            gap: 0.5rem;
            margin-top: 1.5rem;
            font-size: 0.9rem;
        }
        
        .breadcrumb a {
            color: var(--text-muted);
            transition: color 0.2s;
        }
        
        .breadcrumb a:hover {
            color: var(--accent);
        }
        
        .breadcrumb span {
            color: var(--text-muted);
        }
        
        .breadcrumb .current {
            color: var(--text-secondary);
        }
        
        /* Main Content */
        .main-content {
            max-width: 1400px;
            margin: 0 auto;
            padding: 3rem 2rem;
        }
        
        .results-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            padding-bottom: 1.5rem;
            border-bottom: 1px solid var(--border);
        }
        
        .results-count {
            font-size: 1.1rem;
            color: var(--text-secondary);
        }
        
        .results-count strong {
            color: var(--text-primary);
        }
        
        /* Property Grid */
        .property-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1.5rem;
        }
        
        @media (max-width: 1100px) {
            .property-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        
        @media (max-width: 700px) {
            .property-grid {
                grid-template-columns: 1fr;
            }
            .page-header h1 {
                font-size: 2rem;
            }
            .nav-links {
                display: none;
            }
        }
        
        /* Property Card */
        .property-card {
            background: var(--bg-card);
            border-radius: 16px;
            overflow: hidden;
            border: 1px solid var(--border);
            transition: transform 0.3s ease, box-shadow 0.3s ease, border-color 0.3s ease;
        }
        
        .property-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.3);
            border-color: rgba(212, 168, 83, 0.3);
        }
        
        .property-image {
            position: relative;
            height: 220px;
            overflow: hidden;
        }
        
        .property-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }
        
        .property-card:hover .property-image img {
            transform: scale(1.08);
        }
        
        .property-badge {
            position: absolute;
            top: 1rem;
            left: 1rem;
            padding: 0.4rem 0.8rem;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .badge-sale {
            background: var(--success);
            color: #fff;
        }
        
        .badge-rent {
            background: var(--info);
            color: #fff;
        }
        
        .property-content {
            padding: 1.5rem;
        }
        
        .property-title {
            font-size: 1.2rem;
            margin-bottom: 0.5rem;
            line-height: 1.3;
        }
        
        .property-price {
            font-family: 'Playfair Display', serif;
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--accent);
            margin-bottom: 1rem;
        }
        
        .property-meta {
            display: flex;
            gap: 1rem;
            margin-bottom: 1rem;
            font-size: 0.9rem;
            color: var(--text-secondary);
        }
        
        .property-meta span {
            display: flex;
            align-items: center;
            gap: 0.4rem;
        }
        
        .property-type {
            font-size: 0.85rem;
            color: var(--text-muted);
            margin-bottom: 0.75rem;
            font-style: italic;
        }
        
        .property-description {
            font-size: 0.9rem;
            color: var(--text-secondary);
            margin-bottom: 1rem;
            line-height: 1.5;
        }
        
        .property-features {
            display: flex;
            flex-wrap: wrap;
            gap: 0.5rem;
            margin-bottom: 1.25rem;
        }
        
        .feature-tag {
            background: var(--bg-elevated);
            color: var(--text-muted);
            padding: 0.3rem 0.6rem;
            border-radius: 4px;
            font-size: 0.75rem;
            text-transform: capitalize;
        }
        
        .property-card .btn-view {
            display: block;
            width: 100%;
            padding: 0.9rem;
            background: var(--bg-elevated);
            color: var(--text-primary);
            text-align: center;
            border-radius: 10px;
            font-weight: 600;
            font-size: 0.95rem;
            transition: all 0.2s;
            border: 1px solid var(--border);
        }
        
        .property-card .btn-view:hover {
            background: var(--accent);
            color: var(--bg-dark);
            border-color: var(--accent);
        }
        
        /* Alert */
        .alert {
            padding: 2rem;
            border-radius: 16px;
            text-align: center;
            background: var(--bg-card);
            border: 1px solid var(--border);
        }
        
        .alert h3 {
            margin-bottom: 0.75rem;
        }
        
        .alert p {
            color: var(--text-secondary);
            margin-bottom: 1.5rem;
        }
        
        .alert .btn-accent {
            display: inline-block;
        }
        
        /* Footer */
        footer {
            text-align: center;
            padding: 3rem 2rem;
            color: var(--text-muted);
            border-top: 1px solid var(--border);
            margin-top: 3rem;
        }
    </style>
</head>
<body>

<%
    User loggedInUser = (User) session.getAttribute("userObj2024");
%>

<!-- Navbar -->
<nav class="navbar">
    <div class="navbar-inner">
        <a href="home.html" class="brand">Real<span>Dawgs</span></a>
        
        <ul class="nav-links">
            <li><a href="home.html">Home</a></li>
            <li><a href="areaOptions.jsp">All Properties</a></li>
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

<!-- Page Header -->
<header class="page-header">
    <h1>Properties in <span><%= area %></span></h1>
    <p>Discover your perfect home in one of Athens' most vibrant neighborhoods</p>
    <div class="breadcrumb">
        <a href="home.html">Home</a>
        <span>/</span>
        <span class="current"><%= area %></span>
    </div>
</header>

<!-- Main Content -->
<main class="main-content">
    <%
        PropertyDAO propertyDAO = new MockPropertyDAO();
        List<Property> properties = new ArrayList<>();
        String errorMessage = null;

        try {
            if (area != null && !area.equals("All Areas")) {
                properties = propertyDAO.getPropertiesByArea(area);
            } else {
                properties = propertyDAO.getAllProperties();
            }
        } catch (Exception e) {
            errorMessage = "Error loading properties: " + e.getMessage();
        }

        if (errorMessage != null) {
    %>
        <div class="alert">
            <h3>Oops!</h3>
            <p><%= errorMessage %></p>
            <a href="home.html" class="btn-accent">Return Home</a>
        </div>
    <%
        } else if (properties.isEmpty()) {
    %>
        <div class="alert">
            <h3>No Properties Found</h3>
            <p>There are currently no available properties in <%= area %>. Check back soon or explore other neighborhoods.</p>
            <a href="home.html" class="btn-accent">Browse Neighborhoods</a>
        </div>
    <%
        } else {
    %>
        <div class="results-header">
            <div class="results-count">
                <strong><%= properties.size() %></strong> properties found in <%= area %>
            </div>
        </div>
        
        <div class="property-grid">
        <%
            for (Property property : properties) {
                String badgeClass = "badge-rent";
                String badgeText = "For Rent";
                if (property.getListingType() != null && property.getListingType().equals("sale")) {
                    badgeClass = "badge-sale";
                    badgeText = "For Sale";
                }
        %>
            <article class="property-card">
                <div class="property-image">
                    <% if (property.getPhotoUrl() != null && !property.getPhotoUrl().isEmpty()) { %>
                        <img src="<%= property.getPhotoUrl() %>" alt="<%= property.getTitle() %>">
                    <% } else { %>
                        <img src="https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800&q=80" alt="Property">
                    <% } %>
                    <span class="property-badge <%= badgeClass %>"><%= badgeText %></span>
                </div>
                
                <div class="property-content">
                    <h3 class="property-title"><%= property.getTitle() %></h3>
                    <div class="property-price"><%= property.getFormattedPrice() %></div>
                    
                    <div class="property-meta">
                        <span><%= property.getRoomSummary() %></span>
                        <% if (property.getSquareMeters() > 0) { %>
                            <span><%= property.getSquareMeters() %> m²</span>
                        <% } %>
                    </div>
                    
                    <% if (property.getPropertyType() != null) { %>
                        <div class="property-type"><%= property.getPropertyType() %></div>
                    <% } %>
                    
                    <% if (property.getDescription() != null && property.getDescription().length() > 0) { %>
                        <p class="property-description">
                            <%= property.getDescription().length() > 80 ?
                                property.getDescription().substring(0, 80) + "..." :
                                property.getDescription() %>
                        </p>
                    <% } %>
                    
                    <% if (property.getFeatures() != null && !property.getFeatures().isEmpty()) { %>
                        <div class="property-features">
                        <%
                            String[] features = property.getFeatures().split(",");
                            int featureCount = Math.min(features.length, 3);
                            for (int i = 0; i < featureCount; i++) {
                                String feature = features[i].trim().replace("_", " ");
                        %>
                            <span class="feature-tag"><%= feature %></span>
                        <%
                            }
                            if (features.length > 3) {
                        %>
                            <span class="feature-tag">+<%= features.length - 3 %> more</span>
                        <% } %>
                        </div>
                    <% } %>
                    
                    <a href="reserve.jsp?id=<%= property.getId() %>" class="btn-view">View Details</a>
                </div>
            </article>
        <%
            }
        %>
        </div>
    <%
        }
    %>
</main>

<!-- Footer -->
<footer>
    <p>© 2026 RealDawgs. Premium real estate in Athens.</p>
</footer>

</body>
</html>
