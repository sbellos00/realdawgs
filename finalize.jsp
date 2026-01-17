<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.concurrent.TimeUnit" %>
<%@ page import="RentIt.DB" %>
<%@ page import="RentIt.User" %> 
<%@ page import = "RentIt.UserDAO"%>
<%@ page import = "RentIt.Reservation" %>
<%@ page session = "true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Finalize</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
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
        .container {
            margin-top: 20px;
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
        <a class="navbar-brand" href="#">Rent It</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav mr-auto">
                <li class="nav-item">
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
                    <a class="nav-link" href="#"><span class="glyphicon glyphicon-user"></span> Sign Up</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#"><span class="glyphicon glyphicon-log-in"></span> Login</a>
                </li>
                <%
            }
            %>
            </ul>
        </div>
    </div>
</nav>

<div class="jumbotron">
    <h1>Finalize Your Reservation</h1>
    <p>Review your reservation details below.</p>
</div>

<div class="container">
    <%
        // Retrieve parameters from the request
        String checkInDateStr = request.getParameter("checkIn");
        String checkOutDateStr = request.getParameter("checkOut");
        String apartmentName = request.getParameter("apartmentName");
        int nightlyRate = 50;

        if (checkInDateStr != null && checkOutDateStr != null) {
            try {
                // Parse dates
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                Date checkInDate = dateFormat.parse(checkInDateStr);
                Date checkOutDate = dateFormat.parse(checkOutDateStr);

                // Calculate the number of nights
                long diffInMillis = checkOutDate.getTime() - checkInDate.getTime();
                long numberOfNights = TimeUnit.DAYS.convert(diffInMillis, TimeUnit.MILLISECONDS);

                if (numberOfNights > 0) {
                    int totalCost = (int) numberOfNights * nightlyRate;
    %>
                    <h3>Reservation Details:</h3>
                    <p><strong>Apartment:</strong> <%= apartmentName %></p>
                    <p><strong>Check-in Date:</strong> <%= checkInDateStr %></p>
                    <p><strong>Check-out Date:</strong> <%= checkOutDateStr %></p>
                    <p><strong>Number of Nights:</strong> <%= numberOfNights %></p>
                    <p><strong>Total Cost:</strong> €<%= totalCost %></p>



                    <form action="confirmation.jsp" method="post">
                        <input type="hidden" name="apartmentName" value="<%= apartmentName %>">
                        <input type="hidden" name="totalCost" value="<%= totalCost %>">
                        <button type="submit" class="btn btn-primary">Finalize Reservation</button>
                    </form>
    <% 
            int non = (int) numberOfNights;
            Reservation r = new Reservation(apartmentName,loggedInUser.getUsername(),checkInDateStr,checkOutDateStr,non);
            UserDAO user_reservation = new UserDAO();
                    user_reservation.reservation(r);
                } else {
    %>
                    <div class="alert alert-danger" role="alert">
                        Check-out date must be after check-in date. Please go back and correct the dates.
                    </div>
    <%
                }
            } catch (Exception e) {
    %>
                <div class="alert alert-danger" role="alert">
                    Invalid date format. Please ensure dates are in the format yyyy-MM-dd.
                </div>
    <%
            }
        } else {
    %>
            <div class="alert alert-warning" role="alert">
                No dates provided. Please go back and enter your check-in and check-out dates.
            </div>
    <%
        }
    %>
</div>

</body>
</html>