<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page errorPage="RentIt_error.jsp"%>

<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import = "RentIt.UserDAO"%>
<%@ page import = "RentIt.User"%>
<%@ page session = "true" %>

<%
   
    String username = request.getParameter("username");
    String password = request.getParameter("password");
%>
<%
UserDAO userDAO = new UserDAO();

try {
    
    User authenticatedUser = userDAO.authenticate(username, password);

   
    session.setAttribute("userObj2024",authenticatedUser);
    response.sendRedirect("home.html");

} catch(Exception e) {
  
    request.setAttribute("message","Wrong username or password");
%>
<!--forwards to Login page-->
<jsp:forward page="RentIt_login.jsp" />

<%
}
%>
