package RentIt.models;

/**
 * Property model class representing a real estate listing
 *
 * @version 1.0
 */
public class Property {

    private int id;
    private String title;
    private String description;
    private double price;
    private String listingType;     // "sale" or "rent"
    private String propertyType;    // "Apartment", "House", "Condo", etc.
    private String area;            // Neighborhood name
    private int bedrooms;
    private int bathrooms;
    private int squareMeters;
    private int yearBuilt;
    private Integer floorLevel;     // Can be null for houses
    private String photoUrl;
    private String features;        // Comma-separated features
    private String status;          // "available", "pending", "sold", "rented"

    /**
     * Default constructor
     */
    public Property() {
    }

    /**
     * Full constructor
     */
    public Property(int id, String title, String description, double price, String listingType,
                   String propertyType, String area, int bedrooms, int bathrooms, int squareMeters,
                   int yearBuilt, Integer floorLevel, String photoUrl, String features, String status) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.price = price;
        this.listingType = listingType;
        this.propertyType = propertyType;
        this.area = area;
        this.bedrooms = bedrooms;
        this.bathrooms = bathrooms;
        this.squareMeters = squareMeters;
        this.yearBuilt = yearBuilt;
        this.floorLevel = floorLevel;
        this.photoUrl = photoUrl;
        this.features = features;
        this.status = status;
    }

    // Getters
    public int getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public String getDescription() {
        return description;
    }

    public double getPrice() {
        return price;
    }

    public String getListingType() {
        return listingType;
    }

    public String getPropertyType() {
        return propertyType;
    }

    public String getArea() {
        return area;
    }

    public int getBedrooms() {
        return bedrooms;
    }

    public int getBathrooms() {
        return bathrooms;
    }

    public int getSquareMeters() {
        return squareMeters;
    }

    public int getYearBuilt() {
        return yearBuilt;
    }

    public Integer getFloorLevel() {
        return floorLevel;
    }

    public String getPhotoUrl() {
        return photoUrl;
    }

    public String getFeatures() {
        return features;
    }

    public String getStatus() {
        return status;
    }

    // Setters
    public void setId(int id) {
        this.id = id;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public void setListingType(String listingType) {
        this.listingType = listingType;
    }

    public void setPropertyType(String propertyType) {
        this.propertyType = propertyType;
    }

    public void setArea(String area) {
        this.area = area;
    }

    public void setBedrooms(int bedrooms) {
        this.bedrooms = bedrooms;
    }

    public void setBathrooms(int bathrooms) {
        this.bathrooms = bathrooms;
    }

    public void setSquareMeters(int squareMeters) {
        this.squareMeters = squareMeters;
    }

    public void setYearBuilt(int yearBuilt) {
        this.yearBuilt = yearBuilt;
    }

    public void setFloorLevel(Integer floorLevel) {
        this.floorLevel = floorLevel;
    }

    public void setPhotoUrl(String photoUrl) {
        this.photoUrl = photoUrl;
    }

    public void setFeatures(String features) {
        this.features = features;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    /**
     * Helper method to format price with currency
     * @return Formatted price string
     */
    public String getFormattedPrice() {
        if (listingType != null && listingType.equals("rent")) {
            return String.format("€%.0f/month", price);
        } else {
            return String.format("€%,.0f", price);
        }
    }

    /**
     * Helper method to get bedroom/bathroom summary
     * @return Summary string like "2 Bed | 1 Bath"
     */
    public String getRoomSummary() {
        if (bedrooms == 0) {
            return "Studio";
        }
        return bedrooms + " Bed | " + bathrooms + " Bath";
    }

    /**
     * Helper method to check if property has a specific feature
     * @param feature Feature to check for
     * @return true if property has the feature
     */
    public boolean hasFeature(String feature) {
        if (features == null || features.isEmpty()) {
            return false;
        }
        return features.toLowerCase().contains(feature.toLowerCase());
    }

    @Override
    public String toString() {
        return "Property{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", price=" + price +
                ", listingType='" + listingType + '\'' +
                ", area='" + area + '\'' +
                ", bedrooms=" + bedrooms +
                ", bathrooms=" + bathrooms +
                ", squareMeters=" + squareMeters +
                '}';
    }
}
