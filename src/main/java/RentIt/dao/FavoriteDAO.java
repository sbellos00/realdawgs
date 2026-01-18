package RentIt.dao;

import RentIt.models.Property;
import RentIt.utils.DB;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * FavoriteDAO provides methods to manage user favorite properties.
 * Uses database for persistence.
 *
 * @version 1.0
 */
public class FavoriteDAO {

    /**
     * Add a property to user's favorites
     *
     * @param userId     the user ID
     * @param propertyId the property ID
     * @return true if added successfully, false if already exists
     * @throws Exception if database error occurs
     */
    public boolean addFavorite(int userId, int propertyId) throws Exception {
        DB db = new DB();
        String query = "INSERT IGNORE INTO favorites (user_id, property_id) VALUES (?, ?)";

        try {
            Connection con = db.getConnection();
            PreparedStatement stmt = con.prepareStatement(query);
            stmt.setInt(1, userId);
            stmt.setInt(2, propertyId);

            int rowsAffected = stmt.executeUpdate();
            stmt.close();

            return rowsAffected > 0;

        } catch (SQLException e) {
            throw new Exception("Error adding favorite: " + e.getMessage());
        } finally {
            try {
                db.close();
            } catch (Exception e) {
                // Log error
            }
        }
    }

    /**
     * Remove a property from user's favorites
     *
     * @param userId     the user ID
     * @param propertyId the property ID
     * @return true if removed successfully, false if not found
     * @throws Exception if database error occurs
     */
    public boolean removeFavorite(int userId, int propertyId) throws Exception {
        DB db = new DB();
        String query = "DELETE FROM favorites WHERE user_id = ? AND property_id = ?";

        try {
            Connection con = db.getConnection();
            PreparedStatement stmt = con.prepareStatement(query);
            stmt.setInt(1, userId);
            stmt.setInt(2, propertyId);

            int rowsAffected = stmt.executeUpdate();
            stmt.close();

            return rowsAffected > 0;

        } catch (SQLException e) {
            throw new Exception("Error removing favorite: " + e.getMessage());
        } finally {
            try {
                db.close();
            } catch (Exception e) {
                // Log error
            }
        }
    }

    /**
     * Check if a property is in user's favorites
     *
     * @param userId     the user ID
     * @param propertyId the property ID
     * @return true if the property is a favorite
     * @throws Exception if database error occurs
     */
    public boolean isFavorite(int userId, int propertyId) throws Exception {
        DB db = new DB();
        String query = "SELECT 1 FROM favorites WHERE user_id = ? AND property_id = ?";

        try {
            Connection con = db.getConnection();
            PreparedStatement stmt = con.prepareStatement(query);
            stmt.setInt(1, userId);
            stmt.setInt(2, propertyId);
            ResultSet rs = stmt.executeQuery();

            boolean exists = rs.next();

            rs.close();
            stmt.close();
            return exists;

        } catch (SQLException e) {
            throw new Exception("Error checking favorite: " + e.getMessage());
        } finally {
            try {
                db.close();
            } catch (Exception e) {
                // Log error
            }
        }
    }

    /**
     * Get all favorite property IDs for a user
     *
     * @param userId the user ID
     * @return Set of property IDs
     * @throws Exception if database error occurs
     */
    public Set<Integer> getFavoritesByUser(int userId) throws Exception {
        DB db = new DB();
        String query = "SELECT property_id FROM favorites WHERE user_id = ? ORDER BY created_at DESC";
        Set<Integer> favorites = new HashSet<>();

        try {
            Connection con = db.getConnection();
            PreparedStatement stmt = con.prepareStatement(query);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                favorites.add(rs.getInt("property_id"));
            }

            rs.close();
            stmt.close();
            return favorites;

        } catch (SQLException e) {
            throw new Exception("Error fetching favorites: " + e.getMessage());
        } finally {
            try {
                db.close();
            } catch (Exception e) {
                // Log error
            }
        }
    }

    /**
     * Get all favorite properties for a user with full property details
     *
     * @param userId the user ID
     * @return List of Property objects
     * @throws Exception if database error occurs
     */
    public List<Property> getFavoriteProperties(int userId) throws Exception {
        DB db = new DB();
        String query = "SELECT p.* FROM properties p " +
                       "INNER JOIN favorites f ON p.id = f.property_id " +
                       "WHERE f.user_id = ? " +
                       "ORDER BY f.created_at DESC";
        List<Property> properties = new ArrayList<>();

        try {
            Connection con = db.getConnection();
            PreparedStatement stmt = con.prepareStatement(query);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Property property = mapResultSetToProperty(rs);
                properties.add(property);
            }

            rs.close();
            stmt.close();
            return properties;

        } catch (SQLException e) {
            throw new Exception("Error fetching favorite properties: " + e.getMessage());
        } finally {
            try {
                db.close();
            } catch (Exception e) {
                // Log error
            }
        }
    }

    /**
     * Get the count of favorites for a user
     *
     * @param userId the user ID
     * @return count of favorites
     * @throws Exception if database error occurs
     */
    public int getFavoriteCount(int userId) throws Exception {
        DB db = new DB();
        String query = "SELECT COUNT(*) as count FROM favorites WHERE user_id = ?";

        try {
            Connection con = db.getConnection();
            PreparedStatement stmt = con.prepareStatement(query);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            int count = 0;
            if (rs.next()) {
                count = rs.getInt("count");
            }

            rs.close();
            stmt.close();
            return count;

        } catch (SQLException e) {
            throw new Exception("Error counting favorites: " + e.getMessage());
        } finally {
            try {
                db.close();
            } catch (Exception e) {
                // Log error
            }
        }
    }

    /**
     * Helper method to map ResultSet to Property object
     *
     * @param rs ResultSet from database query
     * @return Property object
     * @throws SQLException if column access fails
     */
    private Property mapResultSetToProperty(ResultSet rs) throws SQLException {
        Property property = new Property();
        property.setId(rs.getInt("id"));
        property.setTitle(rs.getString("title"));
        property.setDescription(rs.getString("description"));
        property.setPrice(rs.getDouble("price"));
        property.setListingType(rs.getString("listing_type"));
        property.setPropertyType(rs.getString("property_type"));
        property.setArea(rs.getString("area"));
        property.setBedrooms(rs.getInt("bedrooms"));
        property.setBathrooms(rs.getInt("bathrooms"));
        property.setSquareMeters(rs.getInt("square_meters"));
        property.setYearBuilt(rs.getInt("year_built"));
        
        int floorLevel = rs.getInt("floor_level");
        if (!rs.wasNull()) {
            property.setFloorLevel(floorLevel);
        }
        
        property.setPhotoUrl(rs.getString("photo_url"));
        property.setFeatures(rs.getString("features"));
        property.setStatus(rs.getString("status"));
        
        return property;
    }
}
