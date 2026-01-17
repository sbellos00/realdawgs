package RentIt;

import java.util.ArrayList;
import java.util.List;

/**
 * Mock PropertyDAO for deployment without database
 * Returns hardcoded sample data
 *
 * TO USE THIS: In your JSP files, replace:
 *   PropertyDAO propertyDAO = new PropertyDAO();
 * WITH:
 *   PropertyDAO propertyDAO = new MockPropertyDAO();
 *
 * @version 1.0
 */
public class MockPropertyDAO extends PropertyDAO {

    private List<Property> mockProperties;

    public MockPropertyDAO() {
        initializeMockData();
    }

    private void initializeMockData() {
        mockProperties = new ArrayList<>();

        // Kypseli Properties
        mockProperties.add(createProperty(1, "Modern 2BR Apartment in Kypseli",
            "Bright and spacious 2-bedroom apartment in the heart of Kypseli. Recently renovated with modern amenities, hardwood floors, and large windows. Close to metro station, local markets, and parks.",
            250000.00, "sale", "Apartment", "Kypseli", 2, 1, 75, 1980, 3,
            "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800",
            "balcony,air_conditioning,elevator,renovated", "available"));

        mockProperties.add(createProperty(2, "Cozy Studio in Kypseli",
            "Perfect for students or young professionals. Fully furnished studio with kitchenette and modern bathroom. Walking distance to public transport.",
            450.00, "rent", "Studio", "Kypseli", 0, 1, 35, 1975, 2,
            "https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800",
            "furnished,air_conditioning,internet", "available"));

        mockProperties.add(createProperty(3, "Spacious 3BR Family Apartment",
            "Large family apartment with 3 bedrooms and 2 bathrooms. Bright living room, separate kitchen, and two balconies.",
            320000.00, "sale", "Apartment", "Kypseli", 3, 2, 95, 1985, 4,
            "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800",
            "parking,balcony,storage,elevator", "available"));

        // Piraeus Properties
        mockProperties.add(createProperty(4, "Sea View 3BR Apartment",
            "Stunning sea views from this spacious 3-bedroom apartment. Large balconies overlooking the marina. Modern kitchen, marble bathrooms.",
            350000.00, "sale", "Apartment", "Piraeus", 3, 2, 110, 2005, 5,
            "https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800",
            "parking,balcony,sea_view,elevator,storage", "available"));

        mockProperties.add(createProperty(5, "Penthouse with Terrace",
            "Luxurious penthouse with private terrace overlooking the sea. High-end finishes throughout, designer kitchen, marble bathrooms.",
            1200.00, "rent", "Penthouse", "Piraeus", 2, 2, 95, 2010, 7,
            "https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800",
            "parking,terrace,sea_view,air_conditioning,fireplace,security", "available"));

        // Peristeri Properties
        mockProperties.add(createProperty(6, "Family Home with Garden",
            "Spacious 3-bedroom house with private garden and parking. Quiet residential area, perfect for families with children.",
            280000.00, "sale", "House", "Peristeri", 3, 2, 120, 1990, null,
            "https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=800",
            "garden,parking,storage,pets_allowed,bbq_area", "available"));

        mockProperties.add(createProperty(7, "Affordable 2BR Apartment",
            "Well-maintained 2-bedroom apartment in family-friendly neighborhood. Bright and airy with balcony.",
            650.00, "rent", "Apartment", "Peristeri", 2, 1, 70, 1995, 3,
            "https://images.unsplash.com/photo-1560185127-6ed189bf02f4?w=800",
            "balcony,elevator,air_conditioning", "available"));

        // Monastiraki Properties
        mockProperties.add(createProperty(8, "Historic Center Loft",
            "Unique industrial loft in a beautifully restored building in Monastiraki. High ceilings, exposed brick, modern amenities.",
            1500.00, "rent", "Loft", "Monastiraki", 1, 1, 60, 1920, 4,
            "https://images.unsplash.com/photo-1502672023488-70e25813eb80?w=800",
            "balcony,air_conditioning,historic_building,city_center", "available"));

        // Aghia Paraskevi Properties
        mockProperties.add(createProperty(9, "Modern 2BR near University",
            "Contemporary 2-bedroom apartment near Harokopio University. Modern design, energy-efficient, underground parking.",
            750.00, "rent", "Apartment", "Aghia Paraskevi", 2, 1, 70, 2015, 2,
            "https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=800",
            "parking,elevator,air_conditioning,balcony,energy_efficient", "available"));

        mockProperties.add(createProperty(10, "Spacious 4BR Family Home",
            "Large family home with 4 bedrooms and 3 bathrooms. Private garden, garage, and storage. Excellent school district.",
            420000.00, "sale", "House", "Aghia Paraskevi", 4, 3, 150, 2008, null,
            "https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=800",
            "garden,garage,storage,air_conditioning,alarm_system", "available"));

        // Chalandri Properties
        mockProperties.add(createProperty(11, "Luxury Villa in Chalandri",
            "Exclusive 4-bedroom villa in upscale Chalandri. Private pool, landscaped garden, and covered parking for 2 cars.",
            850000.00, "sale", "Villa", "Chalandri", 4, 3, 250, 2018, null,
            "https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800",
            "pool,garden,parking,air_conditioning,alarm_system,solar_panels,smart_home", "available"));

        mockProperties.add(createProperty(12, "Elegant 3BR Apartment",
            "Sophisticated 3-bedroom apartment in prestigious area. High-quality finishes, spacious rooms, two parking spaces.",
            1100.00, "rent", "Apartment", "Chalandri", 3, 2, 115, 2012, 3,
            "https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=800",
            "parking,elevator,air_conditioning,balcony,gym,security", "available"));
    }

    private Property createProperty(int id, String title, String description, double price,
                                   String listingType, String propertyType, String area,
                                   int bedrooms, int bathrooms, int squareMeters, int yearBuilt,
                                   Integer floorLevel, String photoUrl, String features, String status) {
        Property property = new Property();
        property.setId(id);
        property.setTitle(title);
        property.setDescription(description);
        property.setPrice(price);
        property.setListingType(listingType);
        property.setPropertyType(propertyType);
        property.setArea(area);
        property.setBedrooms(bedrooms);
        property.setBathrooms(bathrooms);
        property.setSquareMeters(squareMeters);
        property.setYearBuilt(yearBuilt);
        property.setFloorLevel(floorLevel);
        property.setPhotoUrl(photoUrl);
        property.setFeatures(features);
        property.setStatus(status);
        return property;
    }

    @Override
    public List<Property> getAllProperties() throws Exception {
        List<Property> available = new ArrayList<>();
        for (Property p : mockProperties) {
            if ("available".equals(p.getStatus())) {
                available.add(p);
            }
        }
        return available;
    }

    @Override
    public List<Property> getPropertiesByArea(String area) throws Exception {
        List<Property> result = new ArrayList<>();
        for (Property p : mockProperties) {
            if (p.getArea().equalsIgnoreCase(area) && "available".equals(p.getStatus())) {
                result.add(p);
            }
        }
        return result;
    }

    @Override
    public List<Property> getPropertiesByListingType(String listingType) throws Exception {
        List<Property> result = new ArrayList<>();
        for (Property p : mockProperties) {
            if (p.getListingType().equalsIgnoreCase(listingType) && "available".equals(p.getStatus())) {
                result.add(p);
            }
        }
        return result;
    }

    @Override
    public List<Property> getPropertiesByAreaAndType(String area, String listingType) throws Exception {
        List<Property> result = new ArrayList<>();
        for (Property p : mockProperties) {
            if (p.getArea().equalsIgnoreCase(area) &&
                p.getListingType().equalsIgnoreCase(listingType) &&
                "available".equals(p.getStatus())) {
                result.add(p);
            }
        }
        return result;
    }

    @Override
    public Property getPropertyById(int propertyId) throws Exception {
        for (Property p : mockProperties) {
            if (p.getId() == propertyId) {
                return p;
            }
        }
        return null;
    }

    @Override
    public List<Property> getPropertiesByStatus(String status) throws Exception {
        List<Property> result = new ArrayList<>();
        for (Property p : mockProperties) {
            if (p.getStatus().equalsIgnoreCase(status)) {
                result.add(p);
            }
        }
        return result;
    }

    @Override
    public List<Property> getPropertiesByPriceRange(double minPrice, double maxPrice) throws Exception {
        List<Property> result = new ArrayList<>();
        for (Property p : mockProperties) {
            if (p.getPrice() >= minPrice && p.getPrice() <= maxPrice && "available".equals(p.getStatus())) {
                result.add(p);
            }
        }
        return result;
    }

    @Override
    public int getPropertyCountByArea(String area) throws Exception {
        int count = 0;
        for (Property p : mockProperties) {
            if (p.getArea().equalsIgnoreCase(area) && "available".equals(p.getStatus())) {
                count++;
            }
        }
        return count;
    }
}
