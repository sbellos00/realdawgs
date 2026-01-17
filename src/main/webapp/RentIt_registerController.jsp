<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="RentIt.dao.UserDAO" %>
<%@ page import="RentIt.models.User" %>
<%@ page errorPage="RentIt_error.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <%@ include file = "RentIt_header.jsp" %>
</head>
<body>
    
    <!-- Fixed navbar -->
    <nav class="navbar navbar-inverse navbar-fixed-top">
        <div class="container">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar"
                    aria-expanded="false" aria-controls="navbar">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span> <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="#">8180012</a>
            </div>
            <div id="navbar" class="navbar-collapse collapse">
                <ul class="nav navbar-nav">
                    <li class="active"><a href="index_ex3_8180012.jsp">Home</a></li>
                    <li><a href="register_ex3_8180012.jsp">Register</a></li>
                    <li><a href="about_ex3_8180012.jsp">About</a></li>
                </ul>
            </div>
            <!--/.nav-collapse -->
        </div>
    </nav>

    <div class="container theme-showcase" role="main">
        <!-- Main jumbotron for a primary marketing message or call to action -->
        <div class="jumbotron">
            <h1>Ism Group 77</h1>
        </div>

        <%
            String name = request.getParameter("name");
            String surname = request.getParameter("surname");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone_number");
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String confirm = request.getParameter("confirm");
            String terms = request.getParameter("terms");
        
            List<String> errors = new ArrayList<String>();
        
            if (name == null || name.length() < 3) {
                errors.add("Name must be at least 3 characters long.");
            }
            if (surname == null || surname.length() < 3) {
                errors.add("Surname must be at least 3 characters long.");
            }
            if (phone == null || phone.length() != 10) {
                errors.add("Phone number must be 10 charcters long");
            }
            if (username == null || username.length() < 5) {
                errors.add("Username must be at least 5 characters long.");
            }
            if (password == null || password.length() < 6) {
                errors.add("Password must be at least 6 characters long.");
            }
            if (confirm == null || !confirm.equals(password)) {
                errors.add("Password and confirm password must match.");
            }
            if (terms == null) {
                errors.add("You must agree to the terms and conditions.");
            }
        
            if (errors.isEmpty()) {
                try {
                    UserDAO userDAO = new UserDAO();
                    User user = new User(username, password,name , surname, email, phone, "customer");
                    
                    
                    userDAO.register(user);

                    
        %>
                    <h2 class="alert-heading">Registration almost done!</h2>
                    <hr>
                    <div class="alert alert-success" role="alert">
                        <p>Note: A verification link has been sent to the email: <strong><%= email %></strong></p>
                    </div>
                    <ul class="list-unstyled">
                        <li><strong>Name:</strong> <%= name %></li>
                        <li><strong>Surname:</strong> <%= surname %></li>
                        <li><strong>Username:</strong> <%= username %></li>
                        <li><strong>Email:</strong> <%= email %></li>
                        <li><strong>Phone:</strong> <%= phone %></li>
                    </ul>
        <%
                } catch (Exception e) {
                    
                    errors.add(e.getMessage());
                }
            }

            if (!errors.isEmpty()) {
        %>
                <h2 class="alert-heading">Registration form has errors</h2>
                <hr>
                <div class="alert alert-danger" role="alert">
                    <ol>
                        <% for (String error : errors) { %>
                            <li><%= error %></li>
                        <% } %>
                    </ol>
                </div>
                <a href="RentIt_register.jsp" class="btn btn-primary">Back to the form</a>
        <%
            }
        %>
    </div>
    <!-- /container -->

    <%@ include file="RentIt_footer.jsp" %>
    <!-- =================== Place all javascript at the end of the document so the pages load faster =================== -->
    <!-- jQuery library -->
    <script src="js/jquery.min.js"></script>
    <!-- Bootstrap core JavaScript -->
    <script src="js/bootstrap.min.js"></script>

</body>
</html>