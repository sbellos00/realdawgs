<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="RentIt.models.Property" %>
<%@ page import="RentIt.dao.PropertyDAO" %>
<%@ page import="RentIt.dao.MockPropertyDAO" %>
<%@ page import="RentIt.models.Inquiry" %>
<%@ page import="RentIt.dao.InquiryDAO" %>
<%@ page import="RentIt.dao.MockInquiryDAO" %>
<%@ page import="RentIt.models.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Express Interest — RealDawgs</title>

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
            --error: #e74c3c;
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
            max-width: 1200px;
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
        
        /* Main Content */
        .main-content {
            max-width: 900px;
            margin: 0 auto;
            padding: 120px 2rem 4rem;
        }
        
        /* Page Header */
        .page-header {
            text-align: center;
            margin-bottom: 3rem;
        }
        
        .page-header h1 {
            font-size: 2.5rem;
            margin-bottom: 0.5rem;
        }
        
        .page-header p {
            color: var(--text-secondary);
            font-size: 1.1rem;
        }
        
        /* Success Card */
        .success-card {
            background: var(--bg-card);
            border: 1px solid var(--success);
            border-radius: 20px;
            padding: 3rem;
            text-align: center;
        }
        
        .success-icon {
            width: 80px;
            height: 80px;
            background: rgba(46, 204, 113, 0.15);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
        }
        
        .success-icon svg {
            width: 40px;
            height: 40px;
            stroke: var(--success);
        }
        
        .success-card h2 {
            color: var(--success);
            margin-bottom: 1rem;
        }
        
        .success-card p {
            color: var(--text-secondary);
            margin-bottom: 2rem;
        }
        
        .button-group {
            display: flex;
            gap: 1rem;
            justify-content: center;
        }
        
        .btn-primary {
            display: inline-block;
            padding: 1rem 2rem;
            background: var(--accent);
            color: var(--bg-dark);
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.2s;
        }
        
        .btn-primary:hover {
            background: var(--accent-hover);
            transform: translateY(-2px);
        }
        
        .btn-secondary {
            display: inline-block;
            padding: 1rem 2rem;
            background: transparent;
            color: var(--text-primary);
            border: 1px solid var(--border);
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.2s;
        }
        
        .btn-secondary:hover {
            border-color: var(--text-muted);
            background: rgba(255,255,255,0.05);
        }
        
        /* Property Summary */
        .property-summary {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            display: grid;
            grid-template-columns: 1fr auto;
            gap: 1.5rem;
            align-items: center;
        }
        
        @media (max-width: 600px) {
            .property-summary {
                grid-template-columns: 1fr;
                text-align: center;
            }
        }
        
        .property-summary h3 {
            font-size: 1.25rem;
            margin-bottom: 0.5rem;
        }
        
        .property-summary .meta {
            color: var(--text-secondary);
            font-size: 0.9rem;
        }
        
        .property-summary .price {
            font-family: 'Playfair Display', serif;
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--accent);
        }
        
        .property-badge {
            display: inline-block;
            padding: 0.3rem 0.6rem;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            margin-top: 0.5rem;
        }
        
        .badge-sale {
            background: var(--success);
            color: #fff;
        }
        
        .badge-rent {
            background: var(--info);
            color: #fff;
        }
        
        /* Form Card */
        .form-card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 20px;
            padding: 2rem;
        }
        
        .form-card h3 {
            font-size: 1.25rem;
            margin-bottom: 1.5rem;
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
        
        .form-group label .required {
            color: var(--error);
        }
        
        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 0.9rem 1rem;
            background: var(--bg-input);
            border: 1px solid var(--border);
            border-radius: 10px;
            color: var(--text-primary);
            font-size: 1rem;
            font-family: inherit;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        
        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: var(--accent);
            box-shadow: 0 0 0 3px rgba(212, 168, 83, 0.15);
        }
        
        .form-group input::placeholder,
        .form-group textarea::placeholder {
            color: var(--text-muted);
        }
        
        .form-group small {
            display: block;
            margin-top: 0.4rem;
            font-size: 0.8rem;
            color: var(--text-muted);
        }
        
        .form-group textarea {
            resize: vertical;
            min-height: 120px;
        }
        
        .checkbox-group {
            display: flex;
            align-items: flex-start;
            gap: 0.75rem;
            margin: 1.5rem 0;
        }
        
        .checkbox-group input {
            width: 18px;
            height: 18px;
            margin-top: 2px;
            accent-color: var(--accent);
        }
        
        .checkbox-group label {
            font-size: 0.9rem;
            color: var(--text-secondary);
        }
        
        /* Info Box */
        .info-box {
            background: var(--bg-elevated);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 1.25rem;
            margin: 1.5rem 0;
        }
        
        .info-box h5 {
            font-size: 0.9rem;
            margin-bottom: 0.75rem;
            color: var(--accent);
        }
        
        .info-box ol {
            padding-left: 1.25rem;
            margin: 0;
            color: var(--text-secondary);
            font-size: 0.9rem;
        }
        
        .info-box li {
            margin-bottom: 0.4rem;
        }
        
        /* Form Actions */
        .form-actions {
            display: flex;
            gap: 1rem;
            margin-top: 1.5rem;
        }
        
        .form-actions .btn-primary {
            flex: 2;
            text-align: center;
            border: none;
            cursor: pointer;
            font-size: 1rem;
        }
        
        .form-actions .btn-secondary {
            flex: 1;
            text-align: center;
        }
        
        /* Alert */
        .alert {
            padding: 1rem 1.25rem;
            border-radius: 10px;
            margin-bottom: 1.5rem;
            font-size: 0.95rem;
        }
        
        .alert-error {
            background: rgba(231, 76, 60, 0.15);
            border: 1px solid var(--error);
            color: #ff6b6b;
        }
        
        .alert-info {
            background: rgba(52, 152, 219, 0.15);
            border: 1px solid var(--info);
            color: #5dade2;
        }
        
        /* Tip Box */
        .tip-box {
            background: rgba(212, 168, 83, 0.1);
            border: 1px solid rgba(212, 168, 83, 0.3);
            border-radius: 12px;
            padding: 1rem 1.25rem;
            margin-top: 1.5rem;
            font-size: 0.9rem;
            color: var(--text-secondary);
        }
        
        .tip-box a {
            color: var(--accent);
        }
        
        .tip-box a:hover {
            text-decoration: underline;
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
            .page-header h1 {
                font-size: 2rem;
            }
            .form-actions {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>

<%
    User loggedInUser = (User) session.getAttribute("userObj2024");
    
    String propertyIdParam = request.getParameter("id");
    Property property = null;
    String errorMessage = null;
    String successMessage = null;

    if (propertyIdParam != null && !propertyIdParam.trim().isEmpty()) {
        try {
            int propertyId = Integer.parseInt(propertyIdParam);
            PropertyDAO propertyDAO = new MockPropertyDAO();
            property = propertyDAO.getPropertyById(propertyId);

            if (property == null) {
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

    if (request.getMethod().equals("POST") && property != null) {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String message = request.getParameter("message");

        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            message == null || message.trim().isEmpty()) {
            errorMessage = "Please fill in all required fields.";
        } else {
            try {
                InquiryDAO inquiryDAO = new MockInquiryDAO();
                Inquiry inquiry;

                if (loggedInUser != null) {
                    inquiry = new Inquiry(property.getId(), loggedInUser.getId(),
                                        name, email, phone, message);
                } else {
                    inquiry = new Inquiry(property.getId(), name, email, phone, message);
                }

                int inquiryId = inquiryDAO.createInquiry(inquiry);

                if (inquiryId > 0) {
                    successMessage = "Your inquiry has been submitted successfully! We will contact you within 24-48 hours.";
                } else {
                    errorMessage = "Failed to submit inquiry. Please try again.";
                }
            } catch (Exception e) {
                errorMessage = "Error submitting inquiry: " + e.getMessage();
            }
        }
    }
%>

<!-- Navbar -->
<nav class="navbar">
    <div class="navbar-inner">
        <a href="home.html" class="brand">Real<span>Dawgs</span></a>
        
        <ul class="nav-links">
            <li><a href="home.html">Home</a></li>
            <% if (property != null) { %>
                <li><a href="reserve.jsp?id=<%= property.getId() %>">Back to Property</a></li>
            <% } %>
            <% if (loggedInUser != null) { %>
                <li><span style="color: var(--text-secondary);">Welcome, <strong style="color: var(--accent);"><%= loggedInUser.getName() %></strong></span></li>
                <li><a href="logout.jsp">Logout</a></li>
            <% } else { %>
                <li><a href="RentIt_login.jsp">Login</a></li>
            <% } %>
        </ul>
    </div>
</nav>

<main class="main-content">
    <% if (successMessage != null) { %>
        <div class="success-card">
            <div class="success-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="20 6 9 17 4 12"></polyline>
                </svg>
            </div>
            <h2>Inquiry Submitted!</h2>
            <p><%= successMessage %></p>
            <div class="button-group">
                <a href="home.html" class="btn-primary">Return Home</a>
                <a href="reserve.jsp?id=<%= property.getId() %>" class="btn-secondary">Back to Property</a>
            </div>
        </div>
    <% } else if (errorMessage != null && property == null) { %>
        <div class="page-header">
            <h1>Error</h1>
            <p><%= errorMessage %></p>
        </div>
        <div style="text-align: center;">
            <a href="home.html" class="btn-primary">Return Home</a>
        </div>
    <% } else if (property != null) { %>
        <div class="page-header">
            <h1>Express Interest</h1>
            <p>Tell us about your interest in this property</p>
        </div>
        
        <!-- Property Summary -->
        <div class="property-summary">
            <div>
                <h3><%= property.getTitle() %></h3>
                <p class="meta"><%= property.getArea() %>, Athens · <%= property.getRoomSummary() %> · <%= property.getSquareMeters() %> sqm</p>
                <% if (property.getListingType() != null) {
                    String badgeClass = property.getListingType().equals("sale") ? "badge-sale" : "badge-rent";
                    String badgeText = property.getListingType().equals("sale") ? "For Sale" : "For Rent";
                %>
                <span class="property-badge <%= badgeClass %>"><%= badgeText %></span>
                <% } %>
            </div>
            <div class="price"><%= property.getFormattedPrice() %></div>
        </div>
        
        <!-- Inquiry Form -->
        <div class="form-card">
            <h3>Contact Information</h3>
            
            <% if (errorMessage != null) { %>
                <div class="alert alert-error"><%= errorMessage %></div>
            <% } %>
            
            <form method="POST" action="finalize.jsp?id=<%= property.getId() %>">
                <div class="form-group">
                    <label for="name">Full Name <span class="required">*</span></label>
                    <input type="text" id="name" name="name" 
                           value="<%= loggedInUser != null ? loggedInUser.getName() + " " + loggedInUser.getSurname() : "" %>"
                           placeholder="Enter your full name" required>
                </div>
                
                <div class="form-group">
                    <label for="email">Email Address <span class="required">*</span></label>
                    <input type="email" id="email" name="email"
                           value="<%= loggedInUser != null ? loggedInUser.getEmail() : "" %>"
                           placeholder="your@email.com" required>
                    <small>We'll use this to contact you</small>
                </div>
                
                <div class="form-group">
                    <label for="phone">Phone Number</label>
                    <input type="tel" id="phone" name="phone"
                           value="<%= loggedInUser != null && loggedInUser.getPhone() != null ? loggedInUser.getPhone() : "" %>"
                           placeholder="+30 210 123 4567">
                    <small>Optional, but helps us reach you faster</small>
                </div>
                
                <div class="form-group">
                    <label for="message">Message <span class="required">*</span></label>
                    <textarea id="message" name="message" rows="5" required
                              placeholder="Tell us about your interest in this property. Would you like to schedule a viewing? Do you have any questions?"></textarea>
                </div>
                
                <div class="checkbox-group">
                    <input type="checkbox" id="termsCheck" required>
                    <label for="termsCheck">I agree to be contacted regarding this property</label>
                </div>
                
                <div class="info-box">
                    <h5>What happens next?</h5>
                    <ol>
                        <li>We'll review your inquiry</li>
                        <li>A real estate agent will contact you within 24-48 hours</li>
                        <li>You can schedule a viewing or ask more questions</li>
                        <li>The agent will guide you through the next steps</li>
                    </ol>
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="btn-primary">Submit Inquiry</button>
                    <a href="reserve.jsp?id=<%= property.getId() %>" class="btn-secondary">Cancel</a>
                </div>
            </form>
            
            <% if (loggedInUser == null) { %>
            <div class="tip-box">
                <strong>Tip:</strong> <a href="RentIt_register.jsp">Create an account</a> to save your favorite properties and track your inquiries!
            </div>
            <% } %>
        </div>
    <% } %>
</main>

<!-- Footer -->
<footer>
    <p>© 2026 RealDawgs. Premium real estate in Athens.</p>
</footer>

</body>
</html>
