package RentIt.dao;

import RentIt.models.User;
import RentIt.utils.DB;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * UserDAO provides all the necessary methods related to users.
 * Uses database for authentication and registration.
 *  
 * @version 2.0
 */
public class UserDAO {

    /**
     * This method returns a List with all Users from the database
     * 
     * @return List<User>
     * @throws Exception if database error occurs
     */
    public List<User> getUsers() throws Exception {
        DB db = new DB();
        String query = "SELECT * FROM users";
        List<User> users = new ArrayList<>();

        try {
            Connection con = db.getConnection();
            PreparedStatement stmt = con.prepareStatement(query);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                User user = mapResultSetToUser(rs);
                users.add(user);
            }

            rs.close();
            stmt.close();
            return users;

        } catch (Exception e) {
            throw new Exception("Error fetching users: " + e.getMessage());
        } finally {
            try {
                db.close();
            } catch (Exception e) {
                // Log error
            }
        }
    }

    /**
     * This method is used to authenticate a user against the database.
     * 
     * @param username String the username
     * @param password String the password
     * @return User the User Object 
     * @throws Exception if the credentials are not valid or an error occurs.
     */
    public User authenticate(String username, String password) throws Exception {
        DB db = new DB();
        String query = "SELECT * FROM users WHERE username = ? AND password = ?";

        try {
            Connection con = db.getConnection();
            PreparedStatement stmt = con.prepareStatement(query);
            stmt.setString(1, username);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                User user = mapResultSetToUser(rs);
                rs.close();
                stmt.close();
                return user;
            }

            rs.close();
            stmt.close();
            throw new Exception("Wrong username or password");

        } catch (SQLException e) {
            throw new Exception("Database error: " + e.getMessage());
        } finally {
            try {
                db.close();
            } catch (Exception e) {
                // Log error
            }
        }
    }

    /**
     * Get user by username
     * 
     * @param username the username to search for
     * @return User object or null if not found
     * @throws Exception if database error occurs
     */
    public User getUserByUsername(String username) throws Exception {
        DB db = new DB();
        String query = "SELECT * FROM users WHERE username = ?";

        try {
            Connection con = db.getConnection();
            PreparedStatement stmt = con.prepareStatement(query);
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();

            User user = null;
            if (rs.next()) {
                user = mapResultSetToUser(rs);
            }

            rs.close();
            stmt.close();
            return user;

        } catch (Exception e) {
            throw new Exception("Error fetching user: " + e.getMessage());
        } finally {
            try {
                db.close();
            } catch (Exception e) {
                // Log error
            }
        }
    }

    /**
     * Register a new user in the database
     * 
     * @param user User object to register
     * @throws Exception if registration fails
     */
    public void register(User user) throws Exception {
        // Validation
        if (user.getUsername() == null || user.getUsername().length() < 5) {
            throw new Exception("Username must be at least 5 characters");
        }
        if (user.getPassword() == null || user.getPassword().length() < 6) {
            throw new Exception("Password must be at least 6 characters");
        }
        if (user.getEmail() == null || !user.getEmail().contains("@")) {
            throw new Exception("Valid email is required");
        }

        // Check if username already exists
        if (getUserByUsername(user.getUsername()) != null) {
            throw new Exception("Username already exists");
        }

        DB db = new DB();
        String query = "INSERT INTO users (name, surname, email, username, password, phone) VALUES (?, ?, ?, ?, ?, ?)";

        try {
            Connection con = db.getConnection();
            PreparedStatement stmt = con.prepareStatement(query);
            stmt.setString(1, user.getName());
            stmt.setString(2, user.getSurname());
            stmt.setString(3, user.getEmail());
            stmt.setString(4, user.getUsername());
            stmt.setString(5, user.getPassword());
            stmt.setString(6, user.getPhone());

            int rowsAffected = stmt.executeUpdate();
            stmt.close();

            if (rowsAffected == 0) {
                throw new Exception("Registration failed, no rows inserted");
            }

        } catch (SQLException e) {
            if (e.getMessage().contains("Duplicate")) {
                throw new Exception("Username or email already exists");
            }
            throw new Exception("Registration error: " + e.getMessage());
        } finally {
            try {
                db.close();
            } catch (Exception e) {
                // Log error
            }
        }
    }

    /**
     * Helper method to map ResultSet to User object
     * 
     * @param rs ResultSet from database query
     * @return User object
     * @throws SQLException if column access fails
     */
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User(
            rs.getString("name"),
            rs.getString("surname"),
            rs.getString("email"),
            rs.getString("username"),
            rs.getString("password")
        );
        user.setId(rs.getInt("id"));
        user.setPhone(rs.getString("phone"));
        return user;
    }

}
