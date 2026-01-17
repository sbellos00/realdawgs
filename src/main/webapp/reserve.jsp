<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="RentIt.Property" %>
<%@ page import="RentIt.PropertyDAO" %>
<%@ page import="RentIt.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%
        // Get property ID from URL parameter
        String propertyIdParam = request.getParameter("id");
        Property property = null;
        String errorMessage = null;
        String pageTitle = "Property Details";

        if (propertyIdParam != null && !propertyIdParam.trim().isEmpty()) {
            try {
                int propertyId = Integer.parseInt(propertyIdParam);
                PropertyDAO propertyDAO = new PropertyDAO();
                property = propertyDAO.getPropertyById(propertyId);

                if (property != null) {
                    pageTitle = property.getTitle() + " | RealDawgs";
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

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- jQuery, Popper, Bootstrap JS -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

    <style>
        .jumbotron {
            background-color: #127d88;
            color: white;
            padding: 50px;
            text-align: center;
        }
        .navbar-custom {
            background-color: #095d65;
        }
        .navbar-custom .navbar-brand, .navbar-custom .nav-link {
            color: #ffffff;
        }
        .navbar-custom .nav-link:hover {
            color: #e0e0e0;
        }
        .property-image {
            width: 100%;
            height: 400px;
            object-fit: cover;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .price-display {
            font-size: 2.5rem;
            font-weight: bold;
            color: #127d88;
            margin: 20px 0;
        }
        .property-specs {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
        }
        .spec-item {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #dee2e6;
        }
        .spec-item:last-child {
            border-bottom: none;
        }
        .spec-label {
            font-weight: bold;
            color: #666;
        }
        .spec-value {
            color: #333;
        }
        .feature-badge {
            display: inline-block;
            margin: 5px;
            padding: 8px 15px;
            background-color: #127d88;
            color: white;
            border-radius: 20px;
            font-size: 0.9rem;
        }
        .listing-type-badge {
            font-size: 1.2rem;
            padding: 10px 20px;
        }
        .contact-section {
            background-color: #f8f9fa;
            padding: 30px;
            border-radius: 8px;
            margin-top: 30px;
        }
    </style>
</head>
<body>

<%
    // Check if user is logged in
    User loggedInUser = (User) session.getAttribute("userObj2024");
%>

<nav class="navbar navbar-expand-lg navbar-custom">
    <div class="container">
        <a class="navbar-brand" href="home.html">RealDawgs</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse"
                data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false"
                aria-label="Toggle navigation">
            <span class="navbar-toggler-icon" style="color:#fff;"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav mr-auto">
                <li class="nav-item">
                    <a class="nav-link" href="home.html">Home</a>
                </li>
                <% if (property != null && property.getArea() != null) { %>
                <li class="nav-item">
                    <a class="nav-link" href="areaOptions.jsp?area=<%= property.getArea() %>">
                        Back to <%= property.getArea() %>
                    </a>
                </li>
                <% } %>
            </ul>
            <ul class="navbar-nav">
                <%
                    if (loggedInUser != null) {
                %>
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            Welcome, <strong><%= loggedInUser.getName() %></strong>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="logout.jsp">Logout</a>
                    </li>
                <%
                    } else {
                %>
                    <li class="nav-item">
                        <a class="nav-link" href="RentIt_register.jsp">Sign Up</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="RentIt_login.jsp">Login</a>
                    </li>
                <%
                    }
                %>
            </ul>
        </div>
    </div>
</nav>

<div class="container mt-4 mb-5">
    <%
        if (errorMessage != null) {
    %>
        <div class="alert alert-danger" role="alert">
            <h4>Error</h4>
            <p><%= errorMessage %></p>
            <a href="home.html" class="btn btn-primary">Return to Home</a>
        </div>
    <%
        } else if (property != null) {
    %>
        <!-- Property Details -->
        <div class="row">
            <div class="col-lg-8">
                <!-- Property Image -->
                <% if (property.getPhotoUrl() != null && !property.getPhotoUrl().isEmpty()) { %>
                    <img src="<%= property.getPhotoUrl() %>" class="property-image" alt="<%= property.getTitle() %>">
                <% } else { %>
                    <img src="https://via.placeholder.com/800x400?text=No+Image+Available" class="property-image" alt="No image">
                <% } %>

                <!-- Title and Price -->
                <div class="mt-4">
                    <h1><%= property.getTitle() %></h1>

                    <div class="mb-3">
                        <% if (property.getListingType() != null) {
                            String badgeClass = property.getListingType().equals("sale") ? "badge-success" : "badge-primary";
                            String badgeText = property.getListingType().equals("sale") ? "For Sale" : "For Rent";
                        %>
                        <span class="badge <%= badgeClass %> listing-type-badge"><%= badgeText %></span>
                        <% } %>
                    </div>

                    <div class="price-display">
                        <%= property.getFormattedPrice() %>
                    </div>
                </div>

                <!-- Property Specifications -->
                <div class="property-specs">
                    <h4 class="mb-3">Property Details</h4>

                    <div class="spec-item">
                        <span class="spec-label">Property Type</span>
                        <span class="spec-value"><%= property.getPropertyType() != null ? property.getPropertyType() : "N/A" %></span>
                    </div>

                    <div class="spec-item">
                        <span class="spec-label">Bedrooms</span>
                        <span class="spec-value"><%= property.getBedrooms() == 0 ? "Studio" : property.getBedrooms() + " Bedroom(s)" %></span>
                    </div>

                    <div class="spec-item">
                        <span class="spec-label">Bathrooms</span>
                        <span class="spec-value"><%= property.getBathrooms() %> Bathroom(s)</span>
                    </div>

                    <div class="spec-item">
                        <span class="spec-label">Size</span>
                        <span class="spec-value"><%= property.getSquareMeters() > 0 ? property.getSquareMeters() + " sqm" : "N/A" %></span>
                    </div>

                    <% if (property.getFloorLevel() != null) { %>
                    <div class="spec-item">
                        <span class="spec-label">Floor Level</span>
                        <span class="spec-value">
                            <%= property.getFloorLevel() == 0 ? "Ground Floor" :
                                property.getFloorLevel() > 0 ? property.getFloorLevel() + "th Floor" : "Basement" %>
                        </span>
                    </div>
                    <% } %>

                    <% if (property.getYearBuilt() > 0) { %>
                    <div class="spec-item">
                        <span class="spec-label">Year Built</span>
                        <span class="spec-value"><%= property.getYearBuilt() %></span>
                    </div>
                    <% } %>

                    <div class="spec-item">
                        <span class="spec-label">Location</span>
                        <span class="spec-value"><%= property.getArea() %>, Athens</span>
                    </div>

                    <div class="spec-item">
                        <span class="spec-label">Status</span>
                        <span class="spec-value text-capitalize"><%= property.getStatus() %></span>
                    </div>
                </div>

                <!-- Description -->
                <div class="mt-4">
                    <h4>Description</h4>
                    <p class="text-justify">
                        <%= property.getDescription() != null ? property.getDescription() : "No description available." %>
                    </p>
                </div>

                <!-- Features -->
                <% if (property.getFeatures() != null && !property.getFeatures().isEmpty()) { %>
                <div class="mt-4">
                    <h4>Features & Amenities</h4>
                    <div class="mt-3">
                        <%
                            String[] features = property.getFeatures().split(",");
                            for (String feature : features) {
                                String displayFeature = feature.trim().replace("_", " ");
                                displayFeature = displayFeature.substring(0, 1).toUpperCase() + displayFeature.substring(1);
                        %>
                            <span class="feature-badge"><%= displayFeature %></span>
                        <%
                            }
                        %>
                    </div>
                </div>
                <% } %>
            </div>

            <!-- Sidebar - Contact Section -->
            <div class="col-lg-4">
                <div class="contact-section">
                    <h4 class="mb-4">Interested in this property?</h4>

                    <% if (property.getStatus() != null && property.getStatus().equals("available")) { %>
                        <p class="text-muted">Contact us to schedule a viewing or get more information.</p>

                        <a href="finalize.jsp?id=<%= property.getId() %>" class="btn btn-primary btn-lg btn-block mb-3">
                            Express Interest
                        </a>

                        <div class="alert alert-info">
                            <small>
                                <strong>Next Steps:</strong><br>
                                1. Submit your inquiry<br>
                                2. Our agent will contact you<br>
                                3. Schedule a viewing<br>
                                4. Make an offer
                            </small>
                        </div>

                        <hr>

                        <h5 class="mt-4">Quick Facts</h5>
                        <ul class="list-unstyled">
                            <li class="mb-2">
                                <strong>Property ID:</strong> #<%= property.getId() %>
                            </li>
                            <li class="mb-2">
                                <strong>Area:</strong> <%= property.getArea() %>
                            </li>
                            <li class="mb-2">
                                <strong>Type:</strong> <%= property.getPropertyType() %>
                            </li>
                        </ul>

                    <% } else { %>
                        <div class="alert alert-warning">
                            <strong>Not Available</strong><br>
                            This property is currently <%= property.getStatus() %> and not available for viewing.
                        </div>

                        <a href="areaOptions.jsp?area=<%= property.getArea() %>" class="btn btn-secondary btn-block">
                            Browse Similar Properties
                        </a>
                    <% } %>
                </div>
            </div>
        </div>
    <%
        }
    %>
</div>

<footer class="container-fluid text-center mt-5 mb-4 py-4" style="background-color: #f8f9fa;">
    <p class="text-muted mb-0">© 2026 RealDawgs. Find your perfect property in Athens.</p>
</footer>

</body>
</html>
