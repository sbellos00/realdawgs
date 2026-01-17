<%@ page errorPage="RentIt_error.jsp"%>
<!DOCTYPE html>
<html lang="en">
	<div class="header">
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
		<meta name="description" content="RentIt">
		<meta name="author" content="your email">
		<link rel="icon" href="<%=request.getContextPath() %>/images/favicon.ico">
	
		<title><%= (request.getAttribute("pageTitle") != null) ? request.getAttribute("pageTitle") : "RentIt" %></title>
	
		<!-- Bootstrap core CSS -->
		<link rel="stylesheet" href="<%=request.getContextPath() %>/css/bootstrap.min.css">	
		<!-- Bootstrap Optional theme -->
		<link rel="stylesheet" href="<%=request.getContextPath() %>/css/bootstrap-theme.min.css">
		<!-- Custom styles for this template -->
		<link href="<%=request.getContextPath() %>/css/theme_8180012.css" rel="stylesheet">
		<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
		<!--[if lt IE 9]>
			  <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
			  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
		<![endif]-->			
	</div>