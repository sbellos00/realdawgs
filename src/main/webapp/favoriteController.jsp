<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="RentIt.models.User" %>
<%@ page import="RentIt.dao.MockFavoriteDAO" %>
<%
    // Set response type to JSON
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    
    // Get parameters
    String action = request.getParameter("action");
    String propertyIdParam = request.getParameter("propertyId");
    
    // Check if user is logged in
    User loggedInUser = (User) session.getAttribute("userObj2024");
    
    if (loggedInUser == null) {
        out.print("{\"success\": false, \"error\": \"not_logged_in\", \"message\": \"Please log in to save favorites\"}");
        return;
    }
    
    if (action == null || propertyIdParam == null) {
        out.print("{\"success\": false, \"error\": \"invalid_params\", \"message\": \"Missing required parameters\"}");
        return;
    }
    
    int userId = loggedInUser.getId();
    int propertyId;
    
    try {
        propertyId = Integer.parseInt(propertyIdParam);
    } catch (NumberFormatException e) {
        out.print("{\"success\": false, \"error\": \"invalid_property_id\", \"message\": \"Invalid property ID\"}");
        return;
    }
    
    MockFavoriteDAO favoriteDAO = new MockFavoriteDAO(session);
    
    try {
        boolean isFavorite = false;
        String message = "";
        
        switch (action) {
            case "add":
                favoriteDAO.addFavorite(userId, propertyId);
                isFavorite = true;
                message = "Added to favorites";
                break;
                
            case "remove":
                favoriteDAO.removeFavorite(userId, propertyId);
                isFavorite = false;
                message = "Removed from favorites";
                break;
                
            case "toggle":
                if (favoriteDAO.isFavorite(userId, propertyId)) {
                    favoriteDAO.removeFavorite(userId, propertyId);
                    isFavorite = false;
                    message = "Removed from favorites";
                } else {
                    favoriteDAO.addFavorite(userId, propertyId);
                    isFavorite = true;
                    message = "Added to favorites";
                }
                break;
                
            case "check":
                isFavorite = favoriteDAO.isFavorite(userId, propertyId);
                message = isFavorite ? "Property is in favorites" : "Property is not in favorites";
                break;
                
            default:
                out.print("{\"success\": false, \"error\": \"invalid_action\", \"message\": \"Invalid action\"}");
                return;
        }
        
        int favoriteCount = favoriteDAO.getFavoriteCount(userId);
        out.print("{\"success\": true, \"isFavorite\": " + isFavorite + ", \"message\": \"" + message + "\", \"favoriteCount\": " + favoriteCount + "}");
        
    } catch (Exception e) {
        out.print("{\"success\": false, \"error\": \"server_error\", \"message\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
    }
%>
