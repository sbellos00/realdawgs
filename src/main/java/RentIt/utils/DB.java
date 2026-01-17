package RentIt.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Database connection handler
 * Supports both local MySQL and Google Cloud SQL
 */
public class DB {

    private Connection con;

    public DB() {
        // Constructor
    }

    /**
     * Get database connection
     * Uses environment variables for Cloud SQL, falls back to localhost for local dev
     * @return Connection object
     * @throws Exception if connection fails
     */
    public Connection getConnection() throws Exception {
        if (con == null || con.isClosed()) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                
                String url;
                String username;
                String password;
                
                // Check if running on Cloud Run (Cloud SQL)
                String cloudSqlInstance = System.getenv("CLOUD_SQL_CONNECTION_NAME");
                
                if (cloudSqlInstance != null && !cloudSqlInstance.isEmpty()) {
                    // Cloud SQL connection using Unix socket
                    String dbName = System.getenv("DB_NAME") != null ? System.getenv("DB_NAME") : "rentit_db";
                    username = System.getenv("DB_USER") != null ? System.getenv("DB_USER") : "root";
                    password = System.getenv("DB_PASSWORD") != null ? System.getenv("DB_PASSWORD") : "";
                    
                    url = String.format(
                        "jdbc:mysql:///%s?cloudSqlInstance=%s&socketFactory=com.google.cloud.sql.mysql.SocketFactory&useSSL=false&serverTimezone=UTC",
                        dbName, cloudSqlInstance
                    );
                } else {
                    // Local development connection
                    String dbServer = System.getenv("DB_HOST") != null ? System.getenv("DB_HOST") : "localhost";
                    String dbPort = System.getenv("DB_PORT") != null ? System.getenv("DB_PORT") : "3306";
                    String dbName = System.getenv("DB_NAME") != null ? System.getenv("DB_NAME") : "rentit_db";
                    username = System.getenv("DB_USER") != null ? System.getenv("DB_USER") : "root";
                    password = System.getenv("DB_PASSWORD") != null ? System.getenv("DB_PASSWORD") : "";
                    
                    url = String.format(
                        "jdbc:mysql://%s:%s/%s?useSSL=false&serverTimezone=UTC",
                        dbServer, dbPort, dbName
                    );
                }
                
                con = DriverManager.getConnection(url, username, password);
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
