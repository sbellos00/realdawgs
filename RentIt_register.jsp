
<%@ page errorPage="RentIt_error.jsp"%>
<head>
	<%@ include file="RentIt_header.jsp" %>
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

		<!-- Page Title -->
		<div class="page-header">

			<h1>Registration Form</h1>
			<div class="alert alert-warning" role="alert">Please fill in the following form to create an account.</div>
			<form action="RentIt_registerController.jsp" method="post" class="form-horizontal">
				<div class="form-group">
					<label for="name" class="col-sm-2 control-label">Name</label>
					<div class="col-sm-10">
						<input type="text" id="name" name="name" class="form-control" placeholder="your name" required>
					</div>
				</div>
				<div class="form-group">
					<label for="surname" class="col-sm-2 control-label">Surname</label>
					<div class="col-sm-10">
						<input type="text" id="surname" name="surname" class="form-control" placeholder="your surname"
							required>
					</div>
				</div>
				<div class="form-group">
					<label for="email" class="col-sm-2 control-label">Email</label>
					<div class="col-sm-10">
						<input type="email" id="email" name="email" class="form-control" placeholder="your email"
							required>
					</div>
				</div>

				<div class="form-group">
					<label for="phone_number" class="col-sm-2 control-label">Phone Number</label>
					<div class="col-sm-10">
						<input type="text" id="phone_number" name="phone_number" class="form-control"
							placeholder="your phone number" required>
					</div>
				</div>				
				<div class="form-group">
					<label for="username" class="col-sm-2 control-label">Username</label>
					<div class="col-sm-10">
						<input type="text" id="username" name="username" class="form-control"
							placeholder="your username" required>
					</div>
				</div>
				<div class="form-group">
					<label for="password" class="col-sm-2 control-label">Password</label>
					<div class="col-sm-10">
						<input type="password" id="password" name="password" class="form-control"
							placeholder="your password" required>
					</div>
				</div>
				<div class="form-group">
					<label for="confirm" class="col-sm-2 control-label">Confirm</label>
					<div class="col-sm-10">
						<input type="password" id="confirm" name="confirm" class="form-control"
							placeholder="confirm your password" required>
					</div>
				</div>
				
				<div class="form-group">
					<div class="col-sm-offset-2 col-sm-10">
						<div class="checkbox">
							<label>
								<input type="checkbox" name="terms" required> I agree to the terms and conditions
							</label>
						</div>
					</div>
				</div>
				<div class="form-group">
					<div class="col-sm-offset-2 col-sm-10">
						<button type="submit" class="btn btn-success">Submit</button>
						<button type="reset" class="btn btn-danger">Cancel</button>
					</div>
				</div>
			</form>

		</div>

	</div>
	<%@ include file="RentIt_footer.jsp" %>
<body>
<html>