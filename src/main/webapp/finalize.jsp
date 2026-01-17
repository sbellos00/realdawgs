<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="RentIt.Property" %>
<%@ page import="RentIt.PropertyDAO" %>
<%@ page import="RentIt.MockPropertyDAO" %>
<%@ page import="RentIt.Inquiry" %>
<%@ page import="RentIt.InquiryDAO" %>
<%@ page import="RentIt.MockInquiryDAO" %>
<%@ page import="RentIt.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Express Interest | RealDawgs</title>

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
        .property-summary {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
        }
        .form-section {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>

<%
    // Check if user is logged in
    User loggedInUser = (User) session.getAttribute("userObj2024");

    // Get property ID
    String propertyIdParam = request.getParameter("id");
    Property property = null;
    String errorMessage = null;
    String successMessage = null;

    // Load property details
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

    // Handle form submission
    if (request.getMethod().equals("POST") && property != null) {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String message = request.getParameter("message");

        // Validation
        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            message == null || message.trim().isEmpty()) {
            errorMessage = "Please fill in all required fields.";
        } else {
            try {
                InquiryDAO inquiryDAO = new MockInquiryDAO();
                Inquiry inquiry;

                if (loggedInUser != null) {
                    // Registered user
                    inquiry = new Inquiry(property.getId(), loggedInUser.getId(),
                                        name, email, phone, message);
                } else {
                    // Guest user
                    inquiry = new Inquiry(property.getId(), name, email, phone, message);
                }

                int inquiryId = inquiryDAO.createInquiry(inquiry);

                if (inquiryId > 0) {
                    successMessage = "Your inquiry has been submitted successfully! We will contact you soon.";
                } else {
                    errorMessage = "Failed to submit inquiry. Please try again.";
                }
            } catch (Exception e) {
                errorMessage = "Error submitting inquiry: " + e.getMessage();
            }
        }
    }
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
                <% if (property != null) { %>
                <li class="nav-item">
                    <a class="nav-link" href="reserve.jsp?id=<%= property.getId() %>">Back to Property</a>
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

<div class="jumbotron">
    <h1 class="display-4">Express Interest</h1>
    <p class="lead">Tell us about your interest in this property</p>
</div>

<div class="container mb-5">
    <% if (successMessage != null) { %>
        <div class="alert alert-success" role="alert">
            <h4 class="alert-heading">Success!</h4>
            <p><%= successMessage %></p>
            <hr>
            <p class="mb-0">
                <a href="home.html" class="btn btn-primary">Return to Home</a>
                <a href="reserve.jsp?id=<%= property.getId() %>" class="btn btn-secondary">Back to Property</a>
            </p>
        </div>
    <% } else if (errorMessage != null && property == null) { %>
        <div class="alert alert-danger" role="alert">
            <h4>Error</h4>
            <p><%= errorMessage %></p>
            <a href="home.html" class="btn btn-primary">Return to Home</a>
        </div>
    <% } else if (property != null) { %>
        <div class="row">
            <div class="col-lg-8 offset-lg-2">
                <!-- Property Summary -->
                <div class="property-summary">
                    <h4>Property Details</h4>
                    <hr>
                    <div class="row">
                        <div class="col-md-8">
                            <h5><%= property.getTitle() %></h5>
                            <p class="mb-1"><strong>Location:</strong> <%= property.getArea() %>, Athens</p>
                            <p class="mb-1"><strong>Type:</strong> <%= property.getPropertyType() %></p>
                            <p class="mb-1"><strong>Size:</strong> <%= property.getRoomSummary() %> | <%= property.getSquareMeters() %> sqm</p>
                        </div>
                        <div class="col-md-4 text-right">
                            <h3 class="text-primary"><%= property.getFormattedPrice() %></h3>
                            <% if (property.getListingType() != null) {
                                String badgeClass = property.getListingType().equals("sale") ? "badge-success" : "badge-primary";
                                String badgeText = property.getListingType().equals("sale") ? "For Sale" : "For Rent";
                            %>
                            <span class="badge <%= badgeClass %>"><%= badgeText %></span>
                            <% } %>
                        </div>
                    </div>
                </div>

                <!-- Inquiry Form -->
                <div class="form-section">
                    <h4 class="mb-4">Contact Information</h4>

                    <% if (errorMessage != null) { %>
                        <div class="alert alert-danger" role="alert">
                            <%= errorMessage %>
                        </div>
                    <% } %>

                    <form method="POST" action="finalize.jsp?id=<%= property.getId() %>">
                        <div class="form-group">
                            <label for="name">Full Name <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="name" name="name"
                                   value="<%= loggedInUser != null ? loggedInUser.getName() + " " + loggedInUser.getSurname() : "" %>"
                                   required>
                        </div>

                        <div class="form-group">
                            <label for="email">Email Address <span class="text-danger">*</span></label>
                            <input type="email" class="form-control" id="email" name="email"
                                   value="<%= loggedInUser != null ? loggedInUser.getEmail() : "" %>"
                                   required>
                            <small class="form-text text-muted">We'll use this to contact you</small>
                        </div>

                        <div class="form-group">
                            <label for="phone">Phone Number</label>
                            <input type="tel" class="form-control" id="phone" name="phone"
                                   value="<%= loggedInUser != null && loggedInUser.getPhone() != null ? loggedInUser.getPhone() : "" %>"
                                   placeholder="+30 210 123 4567">
                            <small class="form-text text-muted">Optional, but helps us reach you faster</small>
                        </div>

                        <div class="form-group">
                            <label for="message">Message <span class="text-danger">*</span></label>
                            <textarea class="form-control" id="message" name="message" rows="5" required
                                      placeholder="Tell us about your interest in this property. Would you like to schedule a viewing? Do you have any questions?"></textarea>
                        </div>

                        <div class="form-group form-check">
                            <input type="checkbox" class="form-check-input" id="termsCheck" required>
                            <label class="form-check-label" for="termsCheck">
                                I agree to be contacted regarding this property
                            </label>
                        </div>

                        <hr>

                        <div class="alert alert-info">
                            <strong>What happens next?</strong>
                            <ol class="mb-0 pl-3">
                                <li>We'll review your inquiry</li>
                                <li>A real estate agent will contact you within 24-48 hours</li>
                                <li>You can schedule a viewing or ask more questions</li>
                                <li>The agent will guide you through the next steps</li>
                            </ol>
                        </div>

                        <div class="text-center mt-4">
                            <button type="submit" class="btn btn-primary btn-lg">
                                Submit Inquiry
                            </button>
                            <a href="reserve.jsp?id=<%= property.getId() %>" class="btn btn-secondary btn-lg">
                                Cancel
                            </a>
                        </div>
                    </form>
                </div>

                <% if (loggedInUser == null) { %>
                <div class="alert alert-info mt-4">
                    <strong>Tip:</strong> <a href="RentIt_register.jsp">Create an account</a> to save your favorite properties and track your inquiries!
                </div>
                <% } %>
            </div>
        </div>
    <% } %>
</div>

<footer class="container-fluid text-center mt-5 mb-4 py-4" style="background-color: #f8f9fa;">
    <p class="text-muted mb-0">© 2026 RealDawgs. Find your perfect property in Athens.</p>
</footer>

</body>
</html>
