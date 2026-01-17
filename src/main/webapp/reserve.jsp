<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
        String propertyIdParam = request.getParameter("id");
        Property property = null;
        String errorMessage = null;
        String pageTitle = "Property Details";

        if (propertyIdParam != null && !propertyIdParam.trim().isEmpty()) {
            try {
                int propertyId = Integer.parseInt(propertyIdParam);
                PropertyDAO propertyDAO = new MockPropertyDAO();
                property = propertyDAO.getPropertyById(propertyId);

                if (property != null) {
                    pageTitle = property.getTitle() + " — RealDawgs";
                } else {
                    errorMessage = "Property not found.";
                }
            } catch (NumberFormatException e) {
                errorMessage = "Invalid property ID.";
            } catch (Exception e) {
                errorMessage = "Error loading property: " + e.getMessage();
            }
        } else {
            errorMessage = "No property ID specified.";
        }
    %>
    <title><%= pageTitle %></title>

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
            --warning: #f39c12;
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
            color: var(--bg-dark) !important;
            font-weight: 600;
            padding: 0.6rem 1.25rem;
            border-radius: 8px;
            transition: all 0.2s;
            display: inline-block;
        }
        
        .btn-accent:hover {
            background: var(--accent-hover);
            transform: translateY(-2px);
        }
        
        /* Main Content */
        .main-content {
            max-width: 1400px;
            margin: 0 auto;
            padding: 100px 2rem 4rem;
        }
        
        /* Back Link */
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--text-secondary);
            font-size: 0.9rem;
            margin-bottom: 2rem;
            transition: color 0.2s;
        }
        
        .back-link:hover {
            color: var(--accent);
        }
        
        /* Property Layout */
        .property-layout {
            display: grid;
            grid-template-columns: 1fr 400px;
            gap: 3rem;
        }
        
        @media (max-width: 1000px) {
            .property-layout {
                grid-template-columns: 1fr;
            }
        }
        
        /* Property Image */
        .property-hero {
            position: relative;
            border-radius: 20px;
            overflow: hidden;
            aspect-ratio: 16/10;
            margin-bottom: 2rem;
        }
        
        .property-hero img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .property-badge {
            position: absolute;
            top: 1.5rem;
            left: 1.5rem;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            font-size: 0.85rem;
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
        
        /* Property Info */
        .property-title {
            font-size: 2.5rem;
            margin-bottom: 0.5rem;
            line-height: 1.2;
        }
        
        .property-location {
            color: var(--text-secondary);
            font-size: 1.1rem;
            margin-bottom: 1.5rem;
        }
        
        .property-price {
            font-family: 'Playfair Display', serif;
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--accent);
            margin-bottom: 2rem;
        }
        
        /* Specs Grid */
        .specs-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 1rem;
            margin-bottom: 2.5rem;
        }
        
        @media (max-width: 600px) {
            .specs-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        
        .spec-box {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 1.25rem;
            text-align: center;
        }
        
        .spec-value {
            font-family: 'Playfair Display', serif;
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.25rem;
        }
        
        .spec-label {
            font-size: 0.85rem;
            color: var(--text-muted);
        }
        
        /* Section */
        .section {
            margin-bottom: 2.5rem;
        }
        
        .section-title {
            font-size: 1.25rem;
            margin-bottom: 1rem;
            padding-bottom: 0.75rem;
            border-bottom: 1px solid var(--border);
        }
        
        .section p {
            color: var(--text-secondary);
            line-height: 1.8;
        }
        
        /* Details List */
        .details-list {
            display: grid;
            gap: 0.75rem;
        }
        
        .detail-item {
            display: flex;
            justify-content: space-between;
            padding: 0.75rem 0;
            border-bottom: 1px solid var(--border);
        }
        
        .detail-item:last-child {
            border-bottom: none;
        }
        
        .detail-label {
            color: var(--text-muted);
        }
        
        .detail-value {
            color: var(--text-primary);
            font-weight: 500;
        }
        
        /* Features */
        .features-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 0.75rem;
        }
        
        .feature-tag {
            background: var(--bg-elevated);
            border: 1px solid var(--border);
            color: var(--text-secondary);
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.9rem;
            text-transform: capitalize;
        }
        
        /* Sidebar */
        .sidebar {
            position: sticky;
            top: 100px;
        }
        
        .sidebar-card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 20px;
            padding: 2rem;
        }
        
        .sidebar-title {
            font-size: 1.25rem;
            margin-bottom: 1rem;
        }
        
        .sidebar-text {
            color: var(--text-secondary);
            margin-bottom: 1.5rem;
            font-size: 0.95rem;
        }
        
        .btn-primary {
            display: block;
            width: 100%;
            padding: 1rem;
            background: var(--accent);
            color: var(--bg-dark);
            text-align: center;
            border-radius: 12px;
            font-weight: 600;
            font-size: 1rem;
            transition: all 0.2s;
            border: none;
            cursor: pointer;
            margin-bottom: 1rem;
        }
        
        .btn-primary:hover {
            background: var(--accent-hover);
            transform: translateY(-2px);
        }
        
        .btn-secondary {
            display: block;
            width: 100%;
            padding: 1rem;
            background: transparent;
            color: var(--text-primary);
            text-align: center;
            border-radius: 12px;
            font-weight: 600;
            font-size: 1rem;
            transition: all 0.2s;
            border: 1px solid var(--border);
        }
        
        .btn-secondary:hover {
            border-color: var(--text-muted);
            background: rgba(255,255,255,0.05);
        }
        
        .steps-list {
            margin-top: 1.5rem;
            padding-top: 1.5rem;
            border-top: 1px solid var(--border);
        }
        
        .steps-list h5 {
            font-size: 0.9rem;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 1rem;
        }
        
        .steps-list ol {
            padding-left: 1.25rem;
            margin: 0;
        }
        
        .steps-list li {
            color: var(--text-secondary);
            font-size: 0.9rem;
            margin-bottom: 0.5rem;
        }
        
        .quick-facts {
            margin-top: 1.5rem;
            padding-top: 1.5rem;
            border-top: 1px solid var(--border);
        }
        
        .quick-facts h5 {
            font-size: 0.9rem;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 1rem;
        }
        
        .fact-item {
            display: flex;
            justify-content: space-between;
            font-size: 0.9rem;
            margin-bottom: 0.5rem;
        }
        
        .fact-label {
            color: var(--text-muted);
        }
        
        .fact-value {
            color: var(--text-secondary);
        }
        
        /* Alert */
        .alert {
            padding: 2rem;
            border-radius: 16px;
            text-align: center;
            background: var(--bg-card);
            border: 1px solid var(--border);
            max-width: 600px;
            margin: 100px auto;
        }
        
        .alert h3 {
            margin-bottom: 0.75rem;
        }
        
        .alert p {
            color: var(--text-secondary);
            margin-bottom: 1.5rem;
        }
        
        .alert-warning {
            background: rgba(243, 156, 18, 0.1);
            border-color: var(--warning);
        }
        
        /* Footer */
        footer {
            text-align: center;
            padding: 3rem 2rem;
            color: var(--text-muted);
            border-top: 1px solid var(--border);
            margin-top: 3rem;
        }
        
        @media (max-width: 768px) {
            .nav-links {
                display: none;
            }
            .property-title {
                font-size: 1.75rem;
            }
            .property-price {
                font-size: 2rem;
            }
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
                <li><span style="color: var(--text-secondary);">Welcome, <strong style="color: var(--accent);"><%= loggedInUser.getName() %></strong></span></li>
                <li><a href="logout.jsp">Logout</a></li>
            <% } else { %>
                <li><a href="RentIt_login.jsp">Login</a></li>
                <li><a href="RentIt_register.jsp" class="btn-accent">Get Started</a></li>
                <% } %>
            </ul>
    </div>
</nav>

<main class="main-content">
    <% if (errorMessage != null) { %>
        <div class="alert">
            <h3>Oops!</h3>
            <p><%= errorMessage %></p>
            <a href="home.html" class="btn-accent">Return Home</a>
        </div>
    <% } else if (property != null) { %>
        
        <a href="areaOptions.jsp?area=<%= property.getArea() %>" class="back-link">
            ← Back to <%= property.getArea() %>
        </a>
        
        <div class="property-layout">
            <div class="property-main">
                <!-- Hero Image -->
                <div class="property-hero">
                <% if (property.getPhotoUrl() != null && !property.getPhotoUrl().isEmpty()) { %>
                        <img src="<%= property.getPhotoUrl() %>" alt="<%= property.getTitle() %>">
                <% } else { %>
                        <img src="https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=1200&q=80" alt="Property">
                <% } %>
                        <% if (property.getListingType() != null) {
                        String badgeClass = property.getListingType().equals("sale") ? "badge-sale" : "badge-rent";
                            String badgeText = property.getListingType().equals("sale") ? "For Sale" : "For Rent";
                        %>
                    <span class="property-badge <%= badgeClass %>"><%= badgeText %></span>
                        <% } %>
                </div>

                <!-- Title & Price -->
                <h1 class="property-title"><%= property.getTitle() %></h1>
                <p class="property-location"><%= property.getArea() %>, Athens</p>
                <div class="property-price"><%= property.getFormattedPrice() %></div>
                
                <!-- Specs Grid -->
                <div class="specs-grid">
                    <div class="spec-box">
                        <div class="spec-value"><%= property.getBedrooms() == 0 ? "Studio" : property.getBedrooms() %></div>
                        <div class="spec-label">Bedrooms</div>
                    </div>
                    <div class="spec-box">
                        <div class="spec-value"><%= property.getBathrooms() %></div>
                        <div class="spec-label">Bathrooms</div>
                    </div>
                    <div class="spec-box">
                        <div class="spec-value"><%= property.getSquareMeters() %></div>
                        <div class="spec-label">sqm</div>
                    </div>
                    <div class="spec-box">
                        <div class="spec-value"><%= property.getYearBuilt() > 0 ? property.getYearBuilt() : "—" %></div>
                        <div class="spec-label">Year Built</div>
                    </div>
                </div>
                
                <!-- Description -->
                <div class="section">
                    <h3 class="section-title">Description</h3>
                    <p><%= property.getDescription() != null ? property.getDescription() : "No description available for this property." %></p>
                    </div>

                <!-- Details -->
                <div class="section">
                    <h3 class="section-title">Property Details</h3>
                    <div class="details-list">
                        <div class="detail-item">
                            <span class="detail-label">Property Type</span>
                            <span class="detail-value"><%= property.getPropertyType() != null ? property.getPropertyType() : "N/A" %></span>
                        </div>
                    <% if (property.getFloorLevel() != null) { %>
                        <div class="detail-item">
                            <span class="detail-label">Floor Level</span>
                            <span class="detail-value">
                            <%= property.getFloorLevel() == 0 ? "Ground Floor" :
                                property.getFloorLevel() > 0 ? property.getFloorLevel() + "th Floor" : "Basement" %>
                        </span>
                    </div>
                    <% } %>
                        <div class="detail-item">
                            <span class="detail-label">Location</span>
                            <span class="detail-value"><%= property.getArea() %>, Athens</span>
                    </div>
                        <div class="detail-item">
                            <span class="detail-label">Status</span>
                            <span class="detail-value" style="text-transform: capitalize;"><%= property.getStatus() %></span>
                    </div>
                    </div>
                </div>

                <!-- Features -->
                <% if (property.getFeatures() != null && !property.getFeatures().isEmpty()) { %>
                <div class="section">
                    <h3 class="section-title">Features & Amenities</h3>
                    <div class="features-grid">
                        <%
                            String[] features = property.getFeatures().split(",");
                            for (String feature : features) {
                                String displayFeature = feature.trim().replace("_", " ");
                        %>
                            <span class="feature-tag"><%= displayFeature %></span>
                        <% } %>
                    </div>
                </div>
                <% } %>
            </div>

            <!-- Sidebar -->
            <div class="sidebar">
                <div class="sidebar-card">
                    <h4 class="sidebar-title">Interested in this property?</h4>

                    <% if (property.getStatus() != null && property.getStatus().equals("available")) { %>
                        <p class="sidebar-text">Contact us to schedule a viewing or get more information about this listing.</p>

                        <a href="finalize.jsp?id=<%= property.getId() %>" class="btn-primary">
                            Express Interest
                        </a>

                        <a href="areaOptions.jsp?area=<%= property.getArea() %>" class="btn-secondary">
                            Browse Similar
                        </a>
                        
                        <div class="steps-list">
                            <h5>Next Steps</h5>
                            <ol>
                                <li>Submit your inquiry</li>
                                <li>Our agent contacts you</li>
                                <li>Schedule a viewing</li>
                                <li>Make an offer</li>
                            </ol>
                        </div>

                        <div class="quick-facts">
                            <h5>Quick Facts</h5>
                            <div class="fact-item">
                                <span class="fact-label">Property ID</span>
                                <span class="fact-value">#<%= property.getId() %></span>
                            </div>
                            <div class="fact-item">
                                <span class="fact-label">Type</span>
                                <span class="fact-value"><%= property.getPropertyType() %></span>
                            </div>
                            <div class="fact-item">
                                <span class="fact-label">Area</span>
                                <span class="fact-value"><%= property.getArea() %></span>
                            </div>
                        </div>
                    <% } else { %>
                        <div class="alert-warning" style="padding: 1rem; border-radius: 10px; margin-bottom: 1rem;">
                            <strong>Not Available</strong><br>
                            <small>This property is currently <%= property.getStatus() %></small>
                        </div>

                        <a href="areaOptions.jsp?area=<%= property.getArea() %>" class="btn-secondary">
                            Browse Similar Properties
                        </a>
                    <% } %>
                </div>
            </div>
        </div>
    <% } %>
</main>

<!-- Footer -->
<footer>
    <p>© 2026 RealDawgs. Premium real estate in Athens.</p>
</footer>

</body>
</html>
