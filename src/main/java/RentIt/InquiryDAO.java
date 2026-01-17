package RentIt;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * InquiryDAO provides data access methods for property inquiries
 *
 * @version 1.0
 */
public class InquiryDAO {

    /**
     * Create a new inquiry from a registered user
     *
     * @param inquiry Inquiry object
     * @return ID of the created inquiry
     * @throws Exception if database error occurs
     */
    public int createInquiry(Inquiry inquiry) throws Exception {
        DB db = new DB();
        Connection con = null;
        String query = "INSERT INTO inquiries (property_id, user_id, name, email, phone, message, status) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try {
            con = db.getConnection();
            PreparedStatement stmt = con.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);

            stmt.setInt(1, inquiry.getPropertyId());

            // user_id can be null for non-registered users
            if (inquiry.getUserId() != null) {
                stmt.setInt(2, inquiry.getUserId());
            } else {
                stmt.setNull(2, Types.INTEGER);
            }

            stmt.setString(3, inquiry.getName());
            stmt.setString(4, inquiry.getEmail());
            stmt.setString(5, inquiry.getPhone());
            stmt.setString(6, inquiry.getMessage());
            stmt.setString(7, inquiry.getStatus() != null ? inquiry.getStatus() : "new");

            int affectedRows = stmt.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating inquiry failed, no rows affected.");
            }

            // Get the generated ID
            int generatedId = 0;
            ResultSet generatedKeys = stmt.getGeneratedKeys();
            if (generatedKeys.next()) {
                generatedId = generatedKeys.getInt(1);
            }

            generatedKeys.close();
            stmt.close();
            return generatedId;

        } catch (Exception e) {
            throw new Exception("Error creating inquiry: " + e.getMessage());
        } finally {
            try {
                db.close();
            } catch (Exception e) {
                // Log error
            }
        }
    }

    /**
     * Get an inquiry by ID
     *
     * @param inquiryId Inquiry ID
     * @return Inquiry object or null if not found
     * @throws Exception if database error occurs
     */
    public Inquiry getInquiryById(int inquiryId) throws Exception {
        DB db = new DB();
        Connection con = null;
        String query = "SELECT * FROM inquiries WHERE id = ?";

        try {
            con = db.getConnection();
            PreparedStatement stmt = con.prepareStatement(query);
            stmt.setInt(1, inquiryId);
            ResultSet rs = stmt.executeQuery();

            Inquiry inquiry = null;
            if (rs.next()) {
                inquiry = mapResultSetToInquiry(rs);
            }

            rs.close();
            stmt.close();
            return inquiry;

        } catch (Exception e) {
            throw new Exception("Error fetching inquiry: " + e.getMessage());
        } finally {
            try {
                db.close();
            } catch (Exception e) {
                // Log error
            }
        }
    }

    /**
     * Get all inquiries for a specific property
     *
     * @param propertyId Property ID
     * @return List of inquiries for the property
     * @throws Exception if database error occurs
     */
    public List<Inquiry> getInquiriesByProperty(int propertyId) throws Exception {
        DB db = new DB();
        Connection con = null;
        String query = "SELECT * FROM inquiries WHERE property_id = ? ORDER BY created_at DESC";

        try {
            con = db.getConnection();
            PreparedStatement stmt = con.prepareStatement(query);
            stmt.setInt(1, propertyId);
            ResultSet rs = stmt.executeQuery();

            List<Inquiry> inquiries = new ArrayList<>();
            while (rs.next()) {
                inquiries.add(mapResultSetToInquiry(rs));
            }

            rs.close();
            stmt.close();
            return inquiries;

        } catch (Exception e) {
            throw new Exception("Error fetching inquiries for property: " + e.getMessage());
        } finally {
            try {
                db.close();
            } catch (Exception e) {
                // Log error
            }
        }
    }

    /**
     * Get all inquiries from a specific user
     *
     * @param userId User ID
     * @return List of user's inquiries
     * @throws Exception if database error occurs
     */
    public List<Inquiry> getInquiriesByUser(int userId) throws Exception {
        DB db = new DB();
        Connection con = null;
        String query = "SELECT * FROM inquiries WHERE user_id = ? ORDER BY created_at DESC";

        try {
            con = db.getConnection();
            PreparedStatement stmt = con.prepareStatement(query);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            List<Inquiry> inquiries = new ArrayList<>();
            while (rs.next()) {
                inquiries.add(mapResultSetToInquiry(rs));
            }

            rs.close();
            stmt.close();
            return inquiries;

        } catch (Exception e) {
            throw new Exception("Error fetching user inquiries: " + e.getMessage());
        } finally {
            try {
                db.close();
            } catch (Exception e) {
                // Log error
            }
        }
    }

    /**
     * Get inquiries by status
     *
     * @param status Inquiry status ("new", "contacted", "closed")
     * @return List of inquiries with the specified status
     * @throws Exception if database error occurs
     */
    public List<Inquiry> getInquiriesByStatus(String status) throws Exception {
        DB db = new DB();
        Connection con = null;
        String query = "SELECT * FROM inquiries WHERE status = ? ORDER BY created_at DESC";

        try {
            con = db.getConnection();
            PreparedStatement stmt = con.prepareStatement(query);
            stmt.setString(1, status);
            ResultSet rs = stmt.executeQuery();

            List<Inquiry> inquiries = new ArrayList<>();
            while (rs.next()) {
                inquiries.add(mapResultSetToInquiry(rs));
            }

            rs.close();
            stmt.close();
            return inquiries;

        } catch (Exception e) {
            throw new Exception("Error fetching inquiries by status: " + e.getMessage());
        } finally {
            try {
                db.close();
            } catch (Exception e) {
                // Log error
            }
        }
    }

    /**
     * Update inquiry status
     *
     * @param inquiryId Inquiry ID
     * @param newStatus New status value
     * @throws Exception if database error occurs
     */
    public void updateInquiryStatus(int inquiryId, String newStatus) throws Exception {
        DB db = new DB();
        Connection con = null;
        String query = "UPDATE inquiries SET status = ? WHERE id = ?";

        try {
            con = db.getConnection();
            PreparedStatement stmt = con.prepareStatement(query);
            stmt.setString(1, newStatus);
            stmt.setInt(2, inquiryId);

            int affectedRows = stmt.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Updating inquiry failed, no rows affected.");
            }

            stmt.close();

        } catch (Exception e) {
            throw new Exception("Error updating inquiry status: " + e.getMessage());
        } finally {
            try {
                db.close();
            } catch (Exception e) {
                // Log error
            }
        }
    }

    /**
     * Get count of inquiries for a property
     *
     * @param propertyId Property ID
     * @return Number of inquiries
     * @throws Exception if database error occurs
     */
    public int getInquiryCountByProperty(int propertyId) throws Exception {
        DB db = new DB();
        Connection con = null;
        String query = "SELECT COUNT(*) as count FROM inquiries WHERE property_id = ?";

        try {
            con = db.getConnection();
            PreparedStatement stmt = con.prepareStatement(query);
            stmt.setInt(1, propertyId);
            ResultSet rs = stmt.executeQuery();

            int count = 0;
            if (rs.next()) {
                count = rs.getInt("count");
            }

            rs.close();
            stmt.close();
            return count;

        } catch (Exception e) {
            throw new Exception("Error counting inquiries: " + e.getMessage());
        } finally {
            try {
                db.close();
            } catch (Exception e) {
                // Log error
            }
        }
    }

    /**
     * Delete an inquiry
     *
     * @param inquiryId Inquiry ID
     * @throws Exception if database error occurs
     */
    public void deleteInquiry(int inquiryId) throws Exception {
        DB db = new DB();
        Connection con = null;
        String query = "DELETE FROM inquiries WHERE id = ?";

        try {
            con = db.getConnection();
            PreparedStatement stmt = con.prepareStatement(query);
            stmt.setInt(1, inquiryId);

            stmt.executeUpdate();
            stmt.close();

        } catch (Exception e) {
            throw new Exception("Error deleting inquiry: " + e.getMessage());
        } finally {
            try {
                db.close();
            } catch (Exception e) {
                // Log error
            }
        }
    }

    /**
     * Helper method to map ResultSet to Inquiry object
     *
     * @param rs ResultSet from database query
     * @return Inquiry object
     * @throws SQLException if column access fails
     */
    private Inquiry mapResultSetToInquiry(ResultSet rs) throws SQLException {
        Inquiry inquiry = new Inquiry();

        inquiry.setId(rs.getInt("id"));
        inquiry.setPropertyId(rs.getInt("property_id"));

        // user_id can be NULL
        int userId = rs.getInt("user_id");
        if (!rs.wasNull()) {
            inquiry.setUserId(userId);
        }

        inquiry.setName(rs.getString("name"));
        inquiry.setEmail(rs.getString("email"));
        inquiry.setPhone(rs.getString("phone"));
        inquiry.setMessage(rs.getString("message"));
        inquiry.setStatus(rs.getString("status"));
        inquiry.setCreatedAt(rs.getTimestamp("created_at"));

        return inquiry;
    }

}
