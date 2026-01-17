package RentIt;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Database connection handler
 */
public class DB {

    private final String dbServer = "localhost";
    private final String dbServerPort = "3306";
    private final String dbName = "rentit_db";
    private final String dbusername = "root";
    private final String dbpassword = "";
    private Connection con;

    public DB() {
        // Constructor
    }

    /**
     * Get database connection
     * @return Connection object
     * @throws Exception if connection fails
     */
    public Connection getConnection() throws Exception {
        if (con == null || con.isClosed()) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                String url = "jdbc:mysql://" + dbServer + ":" + dbServerPort + "/" + dbName
                           + "?useSSL=false&serverTimezone=UTC";
                con = DriverManager.getConnection(url, dbusername, dbpassword);
            } catch (Exception e) {
                throw new Exception("Database connection error: " + e.getMessage());
            }
        }
        return con;
    }

    /**
     * Close database connection
     * @throws SQLException if close fails
     */
    public void close() throws SQLException {
        if (con != null && !con.isClosed()) {
            con.close();
        }
    }
}
