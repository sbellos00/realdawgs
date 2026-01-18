-- RealDawgs Database Schema
-- Real Estate Platform
-- Version: 1.0

-- Create database (if using local MySQL)
-- CREATE DATABASE IF NOT EXISTS realdawgs_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
-- USE realdawgs_db;

-- ============================================
-- Table: users
-- Stores user account information
-- ============================================
CREATE TABLE IF NOT EXISTS users (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    surname VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL COMMENT 'Hashed password (bcrypt)',
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: properties
-- Stores real estate property listings
-- ============================================
CREATE TABLE IF NOT EXISTS properties (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL COMMENT 'Price in Euros',
    listing_type ENUM('sale', 'rent') NOT NULL DEFAULT 'sale',
    property_type VARCHAR(50) DEFAULT 'Apartment' COMMENT 'Apartment, House, Condo, Studio, etc.',
    area VARCHAR(100) NOT NULL COMMENT 'Neighborhood name',
    bedrooms INT UNSIGNED DEFAULT 0,
    bathrooms INT UNSIGNED DEFAULT 1,
    square_meters INT UNSIGNED COMMENT 'Size in sqm',
    year_built INT UNSIGNED COMMENT 'Year of construction',
    floor_level INT COMMENT 'Floor number (NULL for houses)',
    photo_url VARCHAR(500) COMMENT 'Primary photo URL',
    features TEXT COMMENT 'Comma-separated features',
    status ENUM('available', 'pending', 'sold', 'rented') NOT NULL DEFAULT 'available',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_area (area),
    INDEX idx_listing_type (listing_type),
    INDEX idx_status (status),
    INDEX idx_price (price),
    INDEX idx_area_type (area, listing_type, status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: inquiries
-- Stores user inquiries about properties
-- ============================================
CREATE TABLE IF NOT EXISTS inquiries (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    property_id INT UNSIGNED NOT NULL,
    user_id INT UNSIGNED,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    message TEXT NOT NULL,
    status ENUM('new', 'contacted', 'closed') NOT NULL DEFAULT 'new',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (property_id) REFERENCES properties(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,

    INDEX idx_property (property_id),
    INDEX idx_user (user_id),
    INDEX idx_status (status),
    INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: favorites
-- Stores user favorite properties
-- ============================================
CREATE TABLE IF NOT EXISTS favorites (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNSIGNED NOT NULL,
    property_id INT UNSIGNED NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    UNIQUE KEY unique_favorite (user_id, property_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (property_id) REFERENCES properties(id) ON DELETE CASCADE,

    INDEX idx_user (user_id),
    INDEX idx_property (property_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Insert Sample Users
-- ============================================
INSERT INTO users (name, surname, email, username, password, phone) VALUES
('John', 'Doe', 'jdoe@example.com', 'jdoe', '1111', '+30 210 123 4567'),
('Maria', 'Papadopoulos', 'maria@example.com', 'maria', '2222', '+30 210 234 5678'),
('Dimitris', 'Konstantinou', 'dimitris@example.com', 'dkost', '3333', '+30 210 345 6789');

-- ============================================
-- Insert Sample Properties
-- ============================================

-- Kypseli Properties
INSERT INTO properties (title, description, price, listing_type, property_type, area, bedrooms, bathrooms, square_meters, year_built, floor_level, photo_url, features, status) VALUES
('Modern 2BR Apartment in Kypseli', 'Bright and spacious 2-bedroom apartment in the heart of Kypseli. Recently renovated with modern amenities, hardwood floors, and large windows. Close to metro station, local markets, and parks. Perfect for young professionals or small families.', 250000.00, 'sale', 'Apartment', 'Kypseli', 2, 1, 75, 1980, 3, 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800', 'balcony,air_conditioning,elevator,renovated', 'available'),

('Cozy Studio in Kypseli', 'Perfect for students or young professionals. Fully furnished studio with kitchenette and modern bathroom. Walking distance to public transport, universities, and city center. Available immediately.', 450.00, 'rent', 'Studio', 'Kypseli', 0, 1, 35, 1975, 2, 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800', 'furnished,air_conditioning,internet', 'available'),

('Spacious 3BR Family Apartment', 'Large family apartment with 3 bedrooms and 2 bathrooms. Bright living room, separate kitchen, and two balconies. Quiet street with parking. Near schools and playgrounds.', 320000.00, 'sale', 'Apartment', 'Kypseli', 3, 2, 95, 1985, 4, 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800', 'parking,balcony,storage,elevator', 'available');

-- Piraeus Properties
INSERT INTO properties (title, description, price, listing_type, property_type, area, bedrooms, bathrooms, square_meters, year_built, floor_level, photo_url, features, status) VALUES
('Sea View 3BR Apartment', 'Stunning sea views from this spacious 3-bedroom apartment. Large balconies overlooking the marina. Modern kitchen, marble bathrooms. Close to the port, restaurants, and shopping. Perfect for families.', 350000.00, 'sale', 'Apartment', 'Piraeus', 3, 2, 110, 2005, 5, 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800', 'parking,balcony,sea_view,elevator,storage', 'available'),

('Penthouse with Terrace', 'Luxurious penthouse with private terrace overlooking the sea. High-end finishes throughout, designer kitchen, marble bathrooms. 2 bedrooms, 2 bathrooms, plus office. Exclusive building with concierge.', 1200.00, 'rent', 'Penthouse', 'Piraeus', 2, 2, 95, 2010, 7, 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800', 'parking,terrace,sea_view,air_conditioning,fireplace,security', 'available');

-- Peristeri Properties
INSERT INTO properties (title, description, price, listing_type, property_type, area, bedrooms, bathrooms, square_meters, year_built, floor_level, photo_url, features, status) VALUES
('Family Home with Garden', 'Spacious 3-bedroom house with private garden and parking. Quiet residential area, perfect for families with children. Near schools, parks, and shopping centers. Recently renovated interior.', 280000.00, 'sale', 'House', 'Peristeri', 3, 2, 120, 1990, NULL, 'https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=800', 'garden,parking,storage,pets_allowed,bbq_area', 'available'),

('Affordable 2BR Apartment', 'Well-maintained 2-bedroom apartment in family-friendly neighborhood. Bright and airy with balcony. Near public transport and amenities. Great value for money.', 650.00, 'rent', 'Apartment', 'Peristeri', 2, 1, 70, 1995, 3, 'https://images.unsplash.com/photo-1560185127-6ed189bf02f4?w=800', 'balcony,elevator,air_conditioning', 'available');

-- Monastiraki Properties
INSERT INTO properties (title, description, price, listing_type, property_type, area, bedrooms, bathrooms, square_meters, year_built, floor_level, photo_url, features, status) VALUES
('Historic Center Loft', 'Unique industrial loft in a beautifully restored building in Monastiraki. High ceilings, exposed brick, modern amenities. Steps from Acropolis, ancient sites, and vibrant nightlife. Ideal for those who love city center living.', 1500.00, 'rent', 'Loft', 'Monastiraki', 1, 1, 60, 1920, 4, 'https://images.unsplash.com/photo-1502672023488-70e25813eb80?w=800', 'balcony,air_conditioning,historic_building,city_center', 'available');

-- Aghia Paraskevi Properties
INSERT INTO properties (title, description, price, listing_type, property_type, area, bedrooms, bathrooms, square_meters, year_built, floor_level, photo_url, features, status) VALUES
('Modern 2BR near University', 'Contemporary 2-bedroom apartment near Harokopio University. Modern design, energy-efficient, underground parking. Perfect for students, faculty, or young professionals. Quiet neighborhood with easy access to center.', 750.00, 'rent', 'Apartment', 'Aghia Paraskevi', 2, 1, 70, 2015, 2, 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=800', 'parking,elevator,air_conditioning,balcony,energy_efficient', 'available'),

('Spacious 4BR Family Home', 'Large family home with 4 bedrooms and 3 bathrooms. Private garden, garage, and storage. Excellent school district. Modern kitchen and bathrooms. Move-in ready.', 420000.00, 'sale', 'House', 'Aghia Paraskevi', 4, 3, 150, 2008, NULL, 'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=800', 'garden,garage,storage,air_conditioning,alarm_system', 'available');

-- Chalandri Properties
INSERT INTO properties (title, description, price, listing_type, property_type, area, bedrooms, bathrooms, square_meters, year_built, floor_level, photo_url, features, status) VALUES
('Luxury Villa in Chalandri', 'Exclusive 4-bedroom villa in upscale Chalandri. Private pool, landscaped garden, and covered parking for 2 cars. High-end finishes, smart home system, solar panels. Ultimate luxury living.', 850000.00, 'sale', 'Villa', 'Chalandri', 4, 3, 250, 2018, NULL, 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800', 'pool,garden,parking,air_conditioning,alarm_system,solar_panels,smart_home', 'available'),

('Elegant 3BR Apartment', 'Sophisticated 3-bedroom apartment in prestigious area. High-quality finishes, spacious rooms, two parking spaces. Building has gym and playroom. Walking distance to cafes and boutiques.', 1100.00, 'rent', 'Apartment', 'Chalandri', 3, 2, 115, 2012, 3, 'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=800', 'parking,elevator,air_conditioning,balcony,gym,security', 'available');
