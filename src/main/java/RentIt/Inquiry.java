package RentIt;

import java.sql.Timestamp;

/**
 * Inquiry model class representing a user inquiry about a property
 *
 * @version 1.0
 */
public class Inquiry {

    private int id;
    private int propertyId;
    private Integer userId;         // Can be null for non-registered users
    private String name;
    private String email;
    private String phone;
    private String message;
    private String status;          // "new", "contacted", "closed"
    private Timestamp createdAt;

    /**
     * Default constructor
     */
    public Inquiry() {
    }

    /**
     * Constructor for registered users
     */
    public Inquiry(int propertyId, int userId, String name, String email, String phone, String message) {
        this.propertyId = propertyId;
        this.userId = userId;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.message = message;
        this.status = "new";
    }

    /**
     * Constructor for non-registered users
     */
    public Inquiry(int propertyId, String name, String email, String phone, String message) {
        this.propertyId = propertyId;
        this.userId = null;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.message = message;
        this.status = "new";
    }

    /**
     * Full constructor
     */
    public Inquiry(int id, int propertyId, Integer userId, String name, String email,
                   String phone, String message, String status, Timestamp createdAt) {
        this.id = id;
        this.propertyId = propertyId;
        this.userId = userId;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.message = message;
        this.status = status;
        this.createdAt = createdAt;
    }

    // Getters
    public int getId() {
        return id;
    }

    public int getPropertyId() {
        return propertyId;
    }

    public Integer getUserId() {
        return userId;
    }

    public String getName() {
        return name;
    }

    public String getEmail() {
        return email;
    }

    public String getPhone() {
        return phone;
    }

    public String getMessage() {
        return message;
    }

    public String getStatus() {
        return status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    // Setters
    public void setId(int id) {
        this.id = id;
    }

    public void setPropertyId(int propertyId) {
        this.propertyId = propertyId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    /**
     * Helper method to check if inquiry is from a registered user
     * @return true if user is registered
     */
    public boolean isRegisteredUser() {
        return userId != null;
    }

    /**
     * Helper method to get status display name
     * @return Formatted status
     */
    public String getStatusDisplay() {
        if (status == null) return "Unknown";

        switch (status.toLowerCase()) {
            case "new":
                return "New";
            case "contacted":
                return "Contacted";
            case "closed":
                return "Closed";
            default:
                return status;
        }
    }

    @Override
    public String toString() {
        return "Inquiry{" +
                "id=" + id +
                ", propertyId=" + propertyId +
                ", userId=" + userId +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
