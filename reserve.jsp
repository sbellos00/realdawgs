<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="RentIt.DB" %>
<%@ page import="RentIt.User" %> 
<%@ page import = "RentIt.UserDAO"%>
<%@ page session = "true" %> <!-- Import your User class so we can cast session attribute -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <%
            // Read the apartment ID from the query parameter (?id=...)
            String aptID = request.getParameter("id");

            // Fallback if ID is missing
            if (aptID == null || aptID.trim().isEmpty()) {
                aptID = "0"; // or handle it gracefully
            }

            // Variables to store apartment details
            String aptName       = "Unknown Apartment";
            String aptDescription= "";
            String aptPhotoURL   = "http://ism.dmst.aueb.gr/ismgroup77/images/placeholder.png";
            // If you want to show in <title>, we can do it dynamically:
            String pageTitle = "Reserve Apartment";

            // Now fetch details from DB
            DB db = new DB();
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                con = db.getConnection();
                // Example query; adjust columns or table name if needed
                String sql = "SELECT Name, Description, Photo_URL "
                           + "FROM apartment "
                           + "WHERE ID = ?";
                ps = con.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(aptID));
                rs = ps.executeQuery();

                if (rs.next()) {
                    aptName        = rs.getString("Name");
                    aptDescription = rs.getString("Description");
                    String tmpURL  = rs.getString("Photo_URL");
                    if (tmpURL != null && !tmpURL.isEmpty()) {
                        aptPhotoURL = tmpURL;
                    }
                    pageTitle = "Reserve " + aptName;
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null)  try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (ps != null)  try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (con != null) {
                    try { db.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
            }

            // Output the dynamic page title
            out.print(pageTitle);
        %>
    </title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
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
        .apartment-img {
            max-width: 300px;
            height: auto;
            margin-right: 20px;
            border-radius: 5px;
        }
        .reservation-container {
            display: flex;
            align-items: flex-start;
            flex-wrap: wrap;
        }
        .reservation-form {
            flex-grow: 1;
            margin-right: 20px;
            margin-bottom: 20px; /* for smaller screens */
        }
        .review-section {
            flex-grow: 1;
            max-width: 500px;
        }
    </style>
</head>
<body>

<%
    // Check if user is logged in: 'userObj2024' is set by your login controller
    User loggedInUser = (User) session.getAttribute("userObj2024");
%>

<nav class="navbar navbar-expand-lg navbar-custom">
    <div class="container">
        <a class="navbar-brand" href="home.jsp">Rent It</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" 
                data-target="#navbarNav" aria-controls="navbarNav" 
                aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon" style="color:#fff;"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav mr-auto">
                <li class="nav-item">
                    <!-- Link to your actual home page -->
                    <a class="nav-link" href="home.jsp">Home</a>
                </li>
            </ul>
            <ul class="navbar-nav">
                <%
                    // If a user object is in the session, they are logged in
                    if (loggedInUser != null) {
                %>
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            Signed in as: <strong><%= loggedInUser.getUsername() %></strong>
                        </a>
                    </li>
                    <li class="nav-item">
                        <!-- Logout link => let 'logout.jsp' remove the session or invalidate -->
                        <a class="nav-link" href="logout.jsp"><span class="glyphicon glyphicon-log-out"></span> Logout</a>
                    </li>
                <%
                    } else {
                        request.setAttribute("message", "You are not authorized to access this resource. Please login");
                        // Not logged in => show Sign Up & Login
                %>
                <jsp:forward page="login.jsp" />
                    <li class="nav-item">
                        <a class="nav-link" href="register.jsp">
                            <span class="glyphicon glyphicon-user"></span> Sign Up
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="login.jsp">
                            <span class="glyphicon glyphicon-log-in"></span> Login
                        </a>
                    </li>
                <%
                    }
                %>
            </ul>
        </div>
    </div>
</nav>

<div class="jumbotron">
    <!-- Title: Reserve Cozy Apartment, or dynamically from aptName -->
    <h1>
        Reserve 
        <%= aptName %>
    </h1>
    <p>Secure your stay in this apartment today!</p>
</div>

<div class="container reservation-container">
    <!-- Display the fetched apartment image -->
    <img 
        src="<%= aptPhotoURL %>"
        alt="<%= aptName %>"
        class="apartment-img"
    >

    <!-- The reservation form -->
    <form class="reservation-form" action="finalize.jsp" method="get">
        <!-- Pass the apartment ID to finalize.jsp as a hidden field -->
        <input type="hidden" name="id" value="<%= aptID %>" />

        <div class="form-group">
            <label for="apartmentName">Apartment Name:</label>
            <input type="text" class="form-control" id="apartmentName" name="apartmentName" 
                   value="<%= aptName %>" readonly>
        </div>
        <div class="form-group">
            <label for="checkIn">Check-in Date:</label>
            <input type="date" class="form-control" id="checkIn" name="checkIn" required>
        </div>
        <div class="form-group">
            <label for="checkOut">Check-out Date:</label>
            <input type="date" class="form-control" id="checkOut" name="checkOut" required>
        </div>
        <div class="form-group">
            <label for="guests">Number of Guests:</label>
            <input type="number" class="form-control" id="guests" name="guests" min="1" required>
        </div>
        <button type="submit" class="btn btn-primary">Make Reservation</button>
    </form>

    <!-- Optional Review Section -->
    <div class="review-section">
        <h3>Leave a Review</h3>
        <form>
            <div class="form-group">
                <label for="rating">Rating:</label>
                <select class="form-control" id="rating" required>
                    <option value="5">5 Stars</option>
                    <option value="4">4 Stars</option>
                    <option value="3">3 Stars</option>
                    <option value="2">2 Stars</option>
                    <option value="1">1 Star</option>
                </select>
            </div>
            <div class="form-group">
                <label for="comments">Comments:</label>
                <textarea class="form-control" id="comments" rows="5" 
                          placeholder="Write your review here..." required></textarea>
            </div>
            <button type="submit" class="btn btn-secondary">Submit Review</button>
        </form>
    </div>
</div>

<!-- New Bottom Bar (replaces the previous footer include) -->
<nav class="navbar navbar-custom mt-5">
    <div class="container">
        <span class="mx-auto text-white">
            © 2025 Rent It
        </span>
    </div>
</nav>

</body>
</html>
