<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import = "RentIt.dao.UserDAO"%>
<%@ page import = "RentIt.models.User"%>
<%@ page session = "true" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RENT IT</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <style>
        .jumbotron {
            background-color: #127d88;
            color: #ffffff;
            padding: 80px 25px;
            text-align: center;
            font-style: italic;
        }
        .navbar-custom {
            background-color: #095d65;
        }
        .navbar-custom .navbar-brand, .navbar-custom .nav-link {
            color: #ffffff;
        }
        .panel {
            box-shadow: 0px 2px 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            overflow: hidden;
        }
        .panel-heading {
            background-color: #127d88;
            color: #ffffff;
            padding: 15px;
            font-size: 1.25rem;
            text-align: center;
        }
        .panel-footer a {
            background-color: #127d88;
            color: #ffffff;
            font-size: 1rem;
        }
        .panel-footer a:hover {
            background-color: #095d65;
            color: #ffffff;
        }
        .container-fluid {
            margin-top: 20px;
        }
        h2 {
            color: #127d88;
            font-weight: bold;
        }
        .thumbnail img {
            border-radius: 8px;
            width: 100%;
            height: auto;
            object-fit: cover;
        }
        @media (max-width: 768px) {
            .panel {
                margin-bottom: 20px;
            }
        }
    </style>
</head>
<body>

<%
    // Attempt to retrieve the user object from the session
    RentIt.models.User loggedInUser = (RentIt.models.User) session.getAttribute("userObj2024");
%>

<nav class="navbar navbar-expand-lg navbar-custom">
    <div class="container">
        <a class="navbar-brand" href="#">Rent It</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse"
                data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false"
                aria-label="Toggle navigation">
            <span class="navbar-toggler-icon" style="color: #fff;"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav mr-auto">
                <li class="nav-item active">
                    <!-- Link to current home page or 'home.jsp' -->
                    <a class="nav-link" href="#">Home</a>
                </li>
            </ul>
            <ul class="navbar-nav">
                <%
                    // If the user object is not null, user is logged in
                    if (loggedInUser != null) {
                %>
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            Signed in as: <strong><%= loggedInUser.getUsername() %></strong>
                        </a>
                    </li>
                    <li class="nav-item">
                        <!-- A simple logout page or controller that invalidates the session -->
                        <a class="nav-link" href="logout.jsp">Logout</a>
                    </li>
                <%
                    } else {
                        // Otherwise, user is not logged in, show Sign Up & Login
                %>
                    <li class="nav-item">
                        <a class="nav-link" href="register.jsp"><span class="glyphicon glyphicon-user"></span> Sign Up</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="login.jsp"><span class="glyphicon glyphicon-log-in"></span> Login</a>
                    </li>
                <%
                    }
                %>
            </ul>
        </div>
    </div>
</nav>

<div class="jumbotron">
    <h1 class="display-4">Rent It</h1>
    <p class="lead">Choose among the best city accommodations!</p>
</div>

<div class="container-fluid">
    <div class="text-center mb-5">
        <h2>Areas</h2>
        <p class="text-muted">Please choose an area to see available options</p>
    </div>

    <div class="row">
        <div class="col-lg-4 col-md-6 mb-4">
            <div class="panel">
                <div class="panel-heading">Kypseli</div>
                <div class="panel-body">
                    <img src="http://ism.dmst.aueb.gr/ismgroup77/images/kypseli.png" alt="Kypseli" class="img-fluid thumbnail">
                </div>
                <div class="panel-footer text-center">
                    <a href="areaOptions.jsp?area=Kypseli" class="btn btn-block">See your options</a>
                </div>
            </div>
        </div>

        <div class="col-lg-4 col-md-6 mb-4">
            <div class="panel">
                <div class="panel-heading">Piraeus</div>
                <div class="panel-body">
                    <img src="http://ism.dmst.aueb.gr/ismgroup77/images/piraeus.png" alt="Piraeus" class="img-fluid thumbnail">
                </div>
                <div class="panel-footer text-center">
                    <a href="areaOptions.jsp?area=Piraeus" class="btn btn-block">See your options</a>
                </div>
            </div>
        </div>

        <div class="col-lg-4 col-md-6 mb-4">
            <div class="panel">
                <div class="panel-heading">Peristeri</div>
                <div class="panel-body">
                    <img src="http://ism.dmst.aueb.gr/ismgroup77/images/peristeri.png" alt="Peristeri" class="img-fluid thumbnail">
                </div>
                <div class="panel-footer text-center">
                    <a href="areaOptions.jsp?area=Peristeri" class="btn btn-block">See your options</a>
                </div>
            </div>
        </div>
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
