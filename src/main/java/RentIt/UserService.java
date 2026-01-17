package RentIt;

import java.sql.*;

/**
 * UserService provides all the necessary methods related to users. 
 *  
 * @version 1.0
 */
public class UserService {

    /**
	 * This method is used to authenticate a user.     
	 * 
	 * @param username, String the username
	 * @param password, String the password
	 * @return User, the User object
	 * @throws Exception, if the credentials are not valid
	 */
    public User authenticate(String username, String password) throws Exception {
    

        DB db = new DB();
        Connection con = null;
        String query = "SELECT * FROM users_lesson6_2024_2025 WHERE username=? AND password=?;";

        try {
            
            con = db.getConnection();
            PreparedStatement stmt = con.prepareStatement(query);

            // setting parameters
            stmt.setString(1, username);
            stmt.setString(2, password);

            ResultSet rs = stmt.executeQuery();

            // case not valid credentials
            if (!rs.next()) {
                rs.close();
                stmt.close();
                db.close();
                throw new Exception("Wrong username or password");
            }

            // case valid credentials
            User user = new User(rs.getString("name"),
                        rs.getString("surname"),
                        rs.getString("email"),
                        rs.getString("username"),
                        rs.getString("password"));
            
            rs.close();
            stmt.close();
            db.close();

            return user;


        } catch (Exception e) {
            throw new Exception(e.getMessage());
        } finally {
            try {
                db.close();
            } catch (Exception e) {
                
            }
        }

    }
    
} //End of class