package RentIt.dao;

import RentIt.models.User;

import java.util.ArrayList;
import java.util.List;

/**
 * UserDAO provides all the necessary methods related to users.
 * In future lesson we will change the code in order to provide data from a Database.
 *  
 * @version 1.0
 */
public class UserDAO {

    /**
     * This method returns a List with all Users
     * 
     * @return List<User>
     */
    public List<User> getUsers() {

        List<User> users = new ArrayList<User>();
        
        // adding some users for the sake of the example
        users.add(new User("John", "Doe", "jdoe@somewhere.com", "jdoe", "1111"));
        users.add(new User("Mary", "Smith", "msmith@somewhere.com", "msmith",  "2222"));
        users.add(new User("Bob", "Jakson", "bjakson@somewhere.com", "bjakson",  "3333"));
        
        return users;

    } //End of getUsers

    /**
     * This method is used to authenticate a user.     
     * 
     * @param username, String the username
     * @param password, String the password
     * @return User, the User Object 
     * @throws Exception, if the credentials are not valid or an error occurs.
     */
    public User authenticate(String username, String password) throws Exception {
    
        List<User> users = getUsers();

        for (User user: users) {

            if (user.getUsername().equals(username) && user.getPassword().equals(password)) {
                return user; // credentials are valid, so return the User object
            }

        }
        //credentials are Wrong, so throw an error
        throw new Exception("Wrong username or password");

    } // End of authenticate

    /**
     * Register a new user (stub - stores in memory only)
     * 
     * @param user User object to register
     * @throws Exception if registration fails
     */
    public void register(User user) throws Exception {
        // In a real app, this would insert into database
        // For now, just validate and accept (in-memory only)
        if (user.getUsername() == null || user.getUsername().length() < 5) {
            throw new Exception("Username must be at least 5 characters");
        }
        if (user.getPassword() == null || user.getPassword().length() < 6) {
            throw new Exception("Password must be at least 6 characters");
        }
        // Registration accepted (not persisted in this mock version)
    }

    
} //End of class
