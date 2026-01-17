<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="RentIt.Property" %>
<%@ page import="RentIt.PropertyDAO" %>
<%@ page import="RentIt.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%
        String areaParam = request.getParameter("area");
        String area = (areaParam != null && !areaParam.trim().isEmpty()) ? areaParam : "All Areas";
    %>
    <title><%= area %> - Properties | RealDawgs</title>

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
        .card {
            margin: 15px 0;
            display: flex;
            flex-direction: column;
            height: 100%;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: transform 0.2s;
        }
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }
        .card-body {
            flex-grow: 1;
        }
        .card-img-top {
            object-fit: cover;
            height: 200px;
        }
        .price-tag {
            font-size: 1.5rem;
            font-weight: bold;
            color: #127d88;
        }
        .property-details {
            color: #666;
            font-size: 0.95rem;
        }
        .property-details i {
            margin-right: 5px;
        }
        .listing-type-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            z-index: 10;
        }
        .card-img-container {
            position: relative;
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

<div class="jumbotron">
    <h1 class="display-4">Properties in <%= area %></h1>
    <p class="lead">Browse available properties for sale and rent</p>
</div>

<div class="container">
    <%
        // Fetch properties for the selected area
        PropertyDAO propertyDAO = new PropertyDAO();
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
        <div class="alert alert-danger" role="alert">
            <%= errorMessage %>
        </div>
    <%
        } else if (properties.isEmpty()) {
    %>
        <div class="alert alert-info" role="alert">
            <h4>No Properties Available</h4>
            <p>There are currently no available properties in <%= area %>. Please check back later or browse other areas.</p>
            <a href="home.html" class="btn btn-primary">Browse Other Areas</a>
        </div>
    <%
        } else {
    %>
        <div class="mb-4">
            <h4><%= properties.size() %> Properties Found</h4>
        </div>

        <div class="row">
        <%
            for (Property property : properties) {
        %>
            <div class="col-lg-4 col-md-6 mb-4">
                <div class="card">
                    <div class="card-img-container">
                        <% if (property.getListingType() != null) {
                            String badgeClass = property.getListingType().equals("sale") ? "badge-success" : "badge-primary";
                            String badgeText = property.getListingType().equals("sale") ? "For Sale" : "For Rent";
                        %>
                        <span class="badge <%= badgeClass %> listing-type-badge"><%= badgeText %></span>
                        <% } %>

                        <% if (property.getPhotoUrl() != null && !property.getPhotoUrl().isEmpty()) { %>
                            <img src="<%= property.getPhotoUrl() %>" class="card-img-top" alt="<%= property.getTitle() %>">
                        <% } else { %>
                            <img src="https://via.placeholder.com/400x200?text=No+Image" class="card-img-top" alt="No image">
                        <% } %>
                    </div>

                    <div class="card-body">
                        <h5 class="card-title"><%= property.getTitle() %></h5>

                        <div class="price-tag mb-2">
                            <%= property.getFormattedPrice() %>
                        </div>

                        <div class="property-details mb-2">
                            <span><strong><%= property.getRoomSummary() %></strong></span>
                            <% if (property.getSquareMeters() > 0) { %>
                                | <%= property.getSquareMeters() %> sqm
                            <% } %>
                        </div>

                        <% if (property.getPropertyType() != null) { %>
                        <div class="property-details mb-2">
                            <small><em><%= property.getPropertyType() %></em></small>
                        </div>
                        <% } %>

                        <% if (property.getDescription() != null && property.getDescription().length() > 0) { %>
                        <p class="card-text">
                            <%= property.getDescription().length() > 100 ?
                                property.getDescription().substring(0, 100) + "..." :
                                property.getDescription() %>
                        </p>
                        <% } %>

                        <% if (property.getFeatures() != null && !property.getFeatures().isEmpty()) { %>
                        <div class="mb-2">
                            <small class="text-muted">
                                <%
                                    String[] features = property.getFeatures().split(",");
                                    int featureCount = Math.min(features.length, 3);
                                    for (int i = 0; i < featureCount; i++) {
                                        String feature = features[i].trim().replace("_", " ");
                                %>
                                    <span class="badge badge-light"><%= feature %></span>
                                <%
                                    }
                                    if (features.length > 3) {
                                %>
                                    <span class="badge badge-light">+<%= features.length - 3 %> more</span>
                                <% } %>
                            </small>
                        </div>
                        <% } %>

                        <a href="reserve.jsp?id=<%= property.getId() %>" class="btn btn-primary btn-block">
                            View Details
                        </a>
                    </div>
                </div>
            </div>
        <%
            }
        %>
        </div>
    <%
        }
    %>
</div>

<footer class="container-fluid text-center mt-5 mb-4">
    <p class="text-muted">© 2026 RealDawgs. Find your perfect property in Athens.</p>
</footer>

</body>
</html>
