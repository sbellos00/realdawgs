package RentIt;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * PropertyDAO provides data access methods for properties
 *
 * @version 1.0
 */
public class PropertyDAO {

    /**
     * Get all available properties
     *
     * @return List of all available properties
     * @throws Exception if database error occurs
     */
    public List<Property> getAllProperties() throws Exception {
        return getPropertiesByStatus("available");
    }

    /**
     * Get properties by area/neighborhood
     *
     * @param area Neighborhood name
     * @return List of properties in the specified area
     * @throws Exception if database error occurs
     */
    public List<Property> getPropertiesByArea(String area) throws Exception {
        DB db = new DB();
        Connection con = null;
        String query = "SELECT * FROM properties WHERE area = ? AND status = 'available' ORDER BY created_at DESC";

        try {
            con = db.getConnection();
            PreparedStatement stmt = con.prepareStatement(query);
            stmt.setString(1, area);
            ResultSet rs = stmt.executeQuery();

            List<Property> properties = new ArrayList<>();
            while (rs.next()) {
                properties.add(mapResultSetToProperty(rs));
            }

            rs.close();
            stmt.close();
            return properties;

        } catch (Exception e) {
            throw new Exception("Error fetching properties by area: " + e.getMessage());
        } finally {
            try {
                db.close();
            } catch (Exception e) {
                // Log error
            }
        }
    }

    /**
     * Get properties by listing type (sale or rent)
     *
     * @param listingType "sale" or "rent"
     * @return List of properties of the specified type
     * @throws Exception if database error occurs
     */
    public List<Property> getPropertiesByListingType(String listingType) throws Exception {
        DB db = new DB();
        Connection con = null;
        String query = "SELECT * FROM properties WHERE listing_type = ? AND status = 'available' ORDER BY price ASC";

        try {
            con = db.getConnection();
            PreparedStatement stmt = con.prepareStatement(query);
            stmt.setString(1, listingType);
            ResultSet rs = stmt.executeQuery();

            List<Property> properties = new ArrayList<>();
            while (rs.next()) {
                properties.add(mapResultSetToProperty(rs));
            }

            rs.close();
            stmt.close();
            return properties;

        } catch (Exception e) {
            throw new Exception("Error fetching properties by listing type: " + e.getMessage());
        } finally {
            try {
                db.close();
            } catch (Exception e) {
                // Log error
            }
        }
    }

    /**
     * Get properties by area and listing type
     *
     * @param area         Neighborhood name
     * @param listingType  "sale" or "rent"
     * @return List of matching properties
     * @throws Exception if database error occurs
     */
    public List<Property> getPropertiesByAreaAndType(String area, String listingType) throws Exception {
        DB db = new DB();
        Connection con = null;
        String query = "SELECT * FROM properties WHERE area = ? AND listing_type = ? AND status = 'available' ORDER BY price ASC";

        try {
            con = db.getConnection();
            PreparedStatement stmt = con.prepareStatement(query);
            stmt.setString(1, area);
            stmt.setString(2, listingType);
            ResultSet rs = stmt.executeQuery();

            List<Property> properties = new ArrayList<>();
            while (rs.next()) {
                properties.add(mapResultSetToProperty(rs));
            }

            rs.close();
            stmt.close();
            return properties;

        } catch (Exception e) {
            throw new Exception("Error fetching properties: " + e.getMessage());
        } finally {
            try {
                db.close();
            } catch (Exception e) {
                // Log error
            }
        }
    }

    /**
     * Get a single property by ID
     *
     * @param propertyId Property ID
     * @return Property object or null if not found
     * @throws Exception if database error occurs
     */
    public Property getPropertyById(int propertyId) throws Exception {
        DB db = new DB();
        Connection con = null;
        String query = "SELECT * FROM properties WHERE id = ?";

        try {
            con = db.getConnection();
            PreparedStatement stmt = con.prepareStatement(query);
            stmt.setInt(1, propertyId);
            ResultSet rs = stmt.executeQuery();

            Property property = null;
            if (rs.next()) {
                property = mapResultSetToProperty(rs);
            }

            rs.close();
            stmt.close();
            return property;

        } catch (Exception e) {
            throw new Exception("Error fetching property by ID: " + e.getMessage());
        } finally {
            try {
                db.close();
            } catch (Exception e) {
                // Log error
            }
        }
    }

    /**
     * Get properties by status
     *
     * @param status Property status
     * @return List of properties with the specified status
     * @throws Exception if database error occurs
     */
    public List<Property> getPropertiesByStatus(String status) throws Exception {
        DB db = new DB();
        Connection con = null;
        String query = "SELECT * FROM properties WHERE status = ? ORDER BY created_at DESC";

        try {
            con = db.getConnection();
            PreparedStatement stmt = con.prepareStatement(query);
            stmt.setString(1, status);
            ResultSet rs = stmt.executeQuery();

            List<Property> properties = new ArrayList<>();
            while (rs.next()) {
                properties.add(mapResultSetToProperty(rs));
            }

            rs.close();
            stmt.close();
            return properties;

        } catch (Exception e) {
            throw new Exception("Error fetching properties by status: " + e.getMessage());
        } finally {
            try {
                db.close();
            } catch (Exception e) {
                // Log error
            }
        }
    }

    /**
     * Search properties by price range
     *
     * @param minPrice Minimum price
     * @param maxPrice Maximum price
     * @return List of properties within price range
     * @throws Exception if database error occurs
     */
    public List<Property> getPropertiesByPriceRange(double minPrice, double maxPrice) throws Exception {
        DB db = new DB();
        Connection con = null;
        String query = "SELECT * FROM properties WHERE price BETWEEN ? AND ? AND status = 'available' ORDER BY price ASC";

        try {
            con = db.getConnection();
            PreparedStatement stmt = con.prepareStatement(query);
            stmt.setDouble(1, minPrice);
            stmt.setDouble(2, maxPrice);
            ResultSet rs = stmt.executeQuery();

            List<Property> properties = new ArrayList<>();
            while (rs.next()) {
                properties.add(mapResultSetToProperty(rs));
            }

            rs.close();
            stmt.close();
            return properties;

        } catch (Exception e) {
            throw new Exception("Error fetching properties by price range: " + e.getMessage());
        } finally {
            try {
                db.close();
            } catch (Exception e) {
                // Log error
            }
        }
    }

    /**
     * Get count of properties by area
     *
     * @param area Neighborhood name
     * @return Number of available properties in the area
     * @throws Exception if database error occurs
     */
    public int getPropertyCountByArea(String area) throws Exception {
        DB db = new DB();
        Connection con = null;
        String query = "SELECT COUNT(*) as count FROM properties WHERE area = ? AND status = 'available'";

        try {
            con = db.getConnection();
            PreparedStatement stmt = con.prepareStatement(query);
            stmt.setString(1, area);
            ResultSet rs = stmt.executeQuery();

            int count = 0;
            if (rs.next()) {
                count = rs.getInt("count");
            }

            rs.close();
            stmt.close();
            return count;

        } catch (Exception e) {
            throw new Exception("Error counting properties: " + e.getMessage());
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

        // floorLevel can be NULL
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
