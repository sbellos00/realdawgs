<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="RentIt.DB" %>
<%@ page import="RentIt.User" %>  <!-- Import your User class so we can cast session attribute -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <%
            String areaParam = request.getParameter("area");
            String area = (areaParam != null && !areaParam.trim().isEmpty()) ? areaParam : "Unknown Area";
        %>
        <%= area %> Apartments
    </title>
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
        /* Make columns stretch so each card has the same height. */
        .col-md-4.d-flex {
            display: flex !important;
            align-items: stretch !important;
        }
        /* Let the card itself flex so it fills its column. */
        .card {
            margin: 15px;
            display: flex;
            flex-direction: column;
            width: 100%;
        }
        /* Let the card body grow to fill leftover space. */
        .card-body {
            flex-grow: 1;
        }
        /* Fix or limit the image height to ensure uniformity. */
        .card-img-top {
            object-fit: cover;
            height: 200px; /* Adjust to your preference. */
        }
    </style>
</head>
<body>

<%
    // Check if user is logged in: 'userObj2024' is set by RentIt_loginController.jsp
    User loggedInUser = (User) session.getAttribute("userObj2024");
%>

<nav class="navbar navbar-expand-lg navbar-custom">
    <div class="container">
        <a class="navbar-brand" href="home.jsp">Rent It</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse"
                data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" 
                aria-label="Toggle navigation">
            <span class="navbar-toggler-icon" style="color:#fff;"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav mr-auto">
                <!-- Link back to home.jsp -->
                <li class="nav-item">
                    <a class="nav-link" href="home.jsp">Home</a>
                </li>
            </ul>
            <ul class="navbar-nav">
                <%
                    if (loggedInUser != null) {
                        // User is logged in
                %>
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            Signed in as: <strong><%= loggedInUser.getUsername() %></strong>
                        </a>
                    </li>
                    <li class="nav-item">
                        <!-- Logout link => let 'logout.jsp' remove session attribute or invalidate session -->
                        <a class="nav-link" href="logout.jsp">Logout</a>
                    </li>
                <%
                    } else {
                        // Not logged in => show Sign Up & Login
                %>
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
    <h1><%= area %> Apartments</h1>
    <p>Explore the best apartments in <%= area %>!</p>
</div>

<%
    // We'll store apartment data, including ID, in a list
    List<String[]> apartments = new ArrayList<String[]>();

    DB db = new DB();
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        con = db.getConnection();

        String sql = "SELECT ID, Name, Description, Daily_rate, Size, Photo_URL "
                   + "FROM apartment "
                   + "WHERE Area = ?";

        ps = con.prepareStatement(sql);
        ps.setString(1, area);
        rs = ps.executeQuery();

        while (rs.next()) {
            // Convert ID to String for easy array storage
            String aptID      = String.valueOf(rs.getInt("ID"));
            String aptName    = rs.getString("Name");
            String aptDesc    = rs.getString("Description");
            String aptRate    = rs.getString("Daily_rate");
            String aptSize    = rs.getString("Size");
            String aptPhoto   = rs.getString("Photo_URL");

            apartments.add(new String[]{ aptID, aptName, aptDesc, aptRate, aptSize, aptPhoto });
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
%>

<div class="container">
    <div class="row">
        <%
            if (!apartments.isEmpty()) {
                for (String[] apt : apartments) {
                    String aptID   = apt[0];
                    String aptName = apt[1];
                    String aptDesc = apt[2];
                    String aptRate = apt[3];
                    String aptSize = apt[4];
                    String aptPhoto= apt[5];
        %>
        <div class="col-md-4 d-flex">
            <div class="card">
                <img
                    src="<%= (aptPhoto != null && !aptPhoto.isEmpty())
                            ? aptPhoto
                            : "http://ism.dmst.aueb.gr/ismgroup77/images/placeholder.png" %>"
                    class="card-img-top"
                    alt="<%= aptName %>">
                <div class="card-body">
                    <h5 class="card-title"><%= aptName %></h5>
                    <p class="card-text"><%= aptDesc %></p>
                    <p>
                        <strong>Daily Rate:</strong> €<%= aptRate %><br>
                        <strong>Size:</strong> <%= aptSize %> sq.m
                    </p>
                    <!-- Reserve => sends apartment ID to reserve.jsp -->
                    <a href="reserve.jsp?id=<%= aptID %>" class="btn btn-primary">Reserve</a>
                </div>
            </div>
        </div>
        <%
                }
            } else {
        %>
        <div class="col-12">
            <h3 class="text-center text-muted">
                No apartments found for "<%= area %>".
            </h3>
        </div>
        <%
            }
        %>
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
