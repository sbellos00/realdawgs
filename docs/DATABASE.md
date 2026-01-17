# Database Schema Documentation
## RealDawgs Real Estate Platform

**Version:** 1.0
**Database:** MySQL 8.0
**Last Updated:** January 2026

---

## Table of Contents
1. [Overview](#overview)
2. [Database Design Principles](#database-design-principles)
3. [Entity Relationship Diagram](#entity-relationship-diagram)
4. [Table Schemas](#table-schemas)
5. [Indexes](#indexes)
6. [Sample Data](#sample-data)
7. [Migration Scripts](#migration-scripts)
8. [Queries & Examples](#queries--examples)

---

## Overview

### Database Information

- **Database Name:** `rentit_db` *(to be renamed: `realdawgs_db`)*
- **Character Set:** UTF-8 (utf8mb4)
- **Collation:** utf8mb4_unicode_ci
- **Engine:** InnoDB (transactional, foreign keys)
- **Connection:** Cloud SQL (MySQL 8.0) on Google Cloud

### Schema Evolution

**Current State (Legacy):**
- Vacation rental platform ("RentIt")
- Tables: users, apartments (implied), reservations

**Target State (Real Estate):**
- Real estate listing platform ("RealDawgs")
- Tables: users, properties, inquiries, favorites, property_photos

---

## Database Design Principles

### Normalization
- **Third Normal Form (3NF):** Minimize redundancy
- **Foreign Keys:** Enforce referential integrity
- **Indexes:** Optimize frequent queries

### Naming Conventions
- **Tables:** Plural, lowercase (e.g., `users`, `properties`)
- **Columns:** Lowercase with underscores (e.g., `created_at`, `property_type`)
- **Primary Keys:** `id` (auto-increment integer)
- **Foreign Keys:** `{table}_id` (e.g., `user_id`, `property_id`)
- **Timestamps:** `created_at`, `updated_at`

### Data Types
- **IDs:** INT UNSIGNED AUTO_INCREMENT
- **Money:** DECIMAL(10,2) for currency
- **Dates:** TIMESTAMP (includes time) or DATE
- **Text:** VARCHAR for limited text, TEXT for long content
- **Enums:** Use for fixed options (status, type, etc.)

---

## Entity Relationship Diagram

```
┌─────────────────┐
│     users       │
├─────────────────┤
│ id (PK)         │
│ name            │
│ surname         │
│ email (UNIQUE)  │
│ username (UNQ)  │
│ password        │
│ phone           │
│ created_at      │
└────────┬────────┘
         │
         │ 1:N
         │
         ▼
┌─────────────────┐              ┌──────────────────┐
│   inquiries     │   N:1        │   properties     │
├─────────────────┤◄─────────────┤──────────────────┤
│ id (PK)         │              │ id (PK)          │
│ property_id(FK) ├──────────────│ title            │
│ user_id (FK)    │              │ description      │
│ name            │              │ price            │
│ email           │              │ listing_type     │
│ phone           │              │ property_type    │
│ message         │              │ area             │
│ status          │              │ bedrooms         │
│ created_at      │              │ bathrooms        │
└─────────────────┘              │ square_meters    │
                                 │ year_built       │
         ┌───────────────────────│ photo_url        │
         │                       │ features         │
         │                       │ status           │
         │                       │ created_at       │
         │                       │ updated_at       │
         │                       └──────────────────┘
         │                                │
         │                                │
         │                                │ 1:N
         │                                ▼
         │                       ┌──────────────────┐
         │                       │ property_photos  │
         │                       ├──────────────────┤
         │                       │ id (PK)          │
         │                       │ property_id (FK) │
         │                       │ photo_url        │
         │                       │ display_order    │
         │                       │ is_primary       │
         │                       │ created_at       │
         │                       └──────────────────┘
         │
         │ N:M (junction table)
         ▼
┌─────────────────┐
│   favorites     │
├─────────────────┤
│ user_id (FK)    │
│ property_id(FK) │
│ created_at      │
└─────────────────┘
(Composite PK: user_id + property_id)
```

---

## Table Schemas

### 1. users

Stores user account information.

```sql
CREATE TABLE users (
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
```

**Columns:**
| Column | Type | Description |
|--------|------|-------------|
| id | INT UNSIGNED | Primary key, auto-increment |
| name | VARCHAR(100) | User's first name |
| surname | VARCHAR(100) | User's last name |
| email | VARCHAR(255) | Email address (unique, used for login) |
| username | VARCHAR(50) | Username (unique, alternative login) |
| password | VARCHAR(255) | Hashed password (bcrypt, 60 chars min) |
| phone | VARCHAR(20) | Phone number (optional) |
| created_at | TIMESTAMP | Account creation timestamp |

**Constraints:**
- `email` must be unique
- `username` must be unique
- `password` must be hashed (NOT plain text)

---

### 2. properties

Stores real estate property listings.

```sql
CREATE TABLE properties (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL COMMENT 'Price in Euros',
    listing_type ENUM('sale', 'rent') NOT NULL DEFAULT 'sale',
    property_type VARCHAR(50) DEFAULT 'Apartment' COMMENT 'Apartment, House, Condo, etc.',
    area VARCHAR(100) NOT NULL COMMENT 'Neighborhood name',
    bedrooms INT UNSIGNED DEFAULT 0,
    bathrooms INT UNSIGNED DEFAULT 1,
    square_meters INT UNSIGNED COMMENT 'Size in sqm',
    year_built INT UNSIGNED COMMENT 'Year of construction',
    floor_level INT COMMENT 'Floor number (NULL for houses)',
    photo_url VARCHAR(500) COMMENT 'Primary photo URL',
    features TEXT COMMENT 'JSON or comma-separated features',
    status ENUM('available', 'pending', 'sold', 'rented') NOT NULL DEFAULT 'available',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_area (area),
    INDEX idx_listing_type (listing_type),
    INDEX idx_status (status),
    INDEX idx_price (price),
    INDEX idx_area_type (area, listing_type, status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

**Columns:**
| Column | Type | Description |
|--------|------|-------------|
| id | INT UNSIGNED | Primary key, auto-increment |
| title | VARCHAR(200) | Property title/headline |
| description | TEXT | Full property description |
| price | DECIMAL(10,2) | Price in euros (sale or monthly rent) |
| listing_type | ENUM | 'sale' or 'rent' |
| property_type | VARCHAR(50) | Apartment, House, Condo, Studio, etc. |
| area | VARCHAR(100) | Neighborhood (Kypseli, Piraeus, etc.) |
| bedrooms | INT UNSIGNED | Number of bedrooms |
| bathrooms | INT UNSIGNED | Number of bathrooms |
| square_meters | INT UNSIGNED | Size in square meters |
| year_built | INT UNSIGNED | Year property was built |
| floor_level | INT | Floor number (negative for basement, NULL for houses) |
| photo_url | VARCHAR(500) | URL to primary photo |
| features | TEXT | JSON array or comma-separated list of features |
| status | ENUM | available, pending, sold, rented |
| created_at | TIMESTAMP | When listing was created |
| updated_at | TIMESTAMP | Last modification time |

**Sample Features (JSON):**
```json
["parking", "elevator", "balcony", "air_conditioning", "pets_allowed"]
```

**Sample Features (CSV):**
```
parking,elevator,balcony,air_conditioning,pets_allowed
```

---

### 3. inquiries

Stores user inquiries about properties.

```sql
CREATE TABLE inquiries (
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
```

**Columns:**
| Column | Type | Description |
|--------|------|-------------|
| id | INT UNSIGNED | Primary key, auto-increment |
| property_id | INT UNSIGNED | Property being inquired about (FK) |
| user_id | INT UNSIGNED | User making inquiry (FK, nullable) |
| name | VARCHAR(100) | Contact name |
| email | VARCHAR(255) | Contact email |
| phone | VARCHAR(20) | Contact phone number |
| message | TEXT | Inquiry message |
| status | ENUM | new, contacted, closed |
| created_at | TIMESTAMP | When inquiry was made |

**Notes:**
- `user_id` is optional (allows non-registered users to inquire)
- If `user_id` is NULL, use `name` and `email` from form
- If property is deleted, inquiries are deleted (CASCADE)
- If user is deleted, inquiries remain with NULL user_id (SET NULL)

---

### 4. favorites (Phase 2)

Stores user's saved/favorited properties.

```sql
CREATE TABLE favorites (
    user_id INT UNSIGNED NOT NULL,
    property_id INT UNSIGNED NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (user_id, property_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (property_id) REFERENCES properties(id) ON DELETE CASCADE,

    INDEX idx_user (user_id),
    INDEX idx_property (property_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

**Columns:**
| Column | Type | Description |
|--------|------|-------------|
| user_id | INT UNSIGNED | User who favorited (FK) |
| property_id | INT UNSIGNED | Property favorited (FK) |
| created_at | TIMESTAMP | When property was favorited |

**Composite Primary Key:**
- `(user_id, property_id)` ensures one favorite per user-property pair

**Constraints:**
- Delete favorites when user is deleted (CASCADE)
- Delete favorites when property is deleted (CASCADE)

---

### 5. property_photos (Phase 2)

Stores multiple photos for each property.

```sql
CREATE TABLE property_photos (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    property_id INT UNSIGNED NOT NULL,
    photo_url VARCHAR(500) NOT NULL,
    display_order INT UNSIGNED DEFAULT 0,
    is_primary BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (property_id) REFERENCES properties(id) ON DELETE CASCADE,

    INDEX idx_property (property_id),
    INDEX idx_order (property_id, display_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

**Columns:**
| Column | Type | Description |
|--------|------|-------------|
| id | INT UNSIGNED | Primary key, auto-increment |
| property_id | INT UNSIGNED | Associated property (FK) |
| photo_url | VARCHAR(500) | URL to photo file |
| display_order | INT UNSIGNED | Order in gallery (0, 1, 2, ...) |
| is_primary | BOOLEAN | Primary photo flag |
| created_at | TIMESTAMP | When photo was uploaded |

**Notes:**
- Photos deleted when property is deleted (CASCADE)
- Order by `display_order` when displaying gallery
- Only one photo per property should have `is_primary = TRUE`

---

## Indexes

### Purpose of Indexes

Indexes speed up queries but slow down writes. Index columns that are:
- Frequently in WHERE clauses
- Used in JOIN conditions
- Used for sorting (ORDER BY)

### Index Strategy

#### users table
```sql
INDEX idx_email (email)         -- Login by email
INDEX idx_username (username)   -- Login by username
```

#### properties table
```sql
INDEX idx_area (area)                      -- Filter by neighborhood
INDEX idx_listing_type (listing_type)      -- Filter by sale/rent
INDEX idx_status (status)                  -- Filter available properties
INDEX idx_price (price)                    -- Sort by price
INDEX idx_area_type (area, listing_type, status)  -- Composite for common query
```

**Common Query Example:**
```sql
-- This query benefits from idx_area_type
SELECT * FROM properties
WHERE area = 'Kypseli'
  AND listing_type = 'sale'
  AND status = 'available'
ORDER BY price ASC;
```

#### inquiries table
```sql
INDEX idx_property (property_id)  -- Find inquiries for a property
INDEX idx_user (user_id)          -- Find user's inquiries
INDEX idx_status (status)         -- Filter by status
INDEX idx_created (created_at)    -- Sort by date
```

---

## Sample Data

### Sample Users

```sql
INSERT INTO users (name, surname, email, username, password, phone) VALUES
('John', 'Doe', 'jdoe@example.com', 'jdoe', '$2a$12$...', '+30 210 123 4567'),
('Maria', 'Papadopoulos', 'maria@example.com', 'maria', '$2a$12$...', '+30 210 234 5678'),
('Dimitris', 'Konstantinou', 'dimitris@example.com', 'dkost', '$2a$12$...', '+30 210 345 6789');
```

### Sample Properties

```sql
INSERT INTO properties (title, description, price, listing_type, property_type, area, bedrooms, bathrooms, square_meters, year_built, photo_url, features, status) VALUES

-- Kypseli properties
('Modern 2BR Apartment in Kypseli', 'Bright and spacious 2-bedroom apartment in the heart of Kypseli. Recently renovated with modern amenities. Close to metro station and local markets.', 250000.00, 'sale', 'Apartment', 'Kypseli', 2, 1, 75, 1980, 'https://example.com/photos/kypseli1.jpg', 'balcony,air_conditioning,elevator', 'available'),

('Cozy Studio in Kypseli', 'Perfect for students or young professionals. Fully furnished studio with kitchenette. Walking distance to public transport.', 450.00, 'rent', 'Studio', 'Kypseli', 0, 1, 35, 1975, 'https://example.com/photos/kypseli2.jpg', 'furnished,air_conditioning', 'available'),

-- Piraeus properties
('Sea View 3BR in Piraeus', 'Stunning sea views from this spacious 3-bedroom apartment. Close to the port and marina. Perfect for families.', 350000.00, 'sale', 'Apartment', 'Piraeus', 3, 2, 110, 2005, 'https://example.com/photos/piraeus1.jpg', 'parking,balcony,sea_view,elevator,storage', 'available'),

('Penthouse with Terrace - Piraeus', 'Luxurious penthouse with private terrace overlooking the sea. High-end finishes throughout.', 1200.00, 'rent', 'Penthouse', 'Piraeus', 2, 2, 95, 2010, 'https://example.com/photos/piraeus2.jpg', 'parking,terrace,sea_view,air_conditioning,fireplace', 'available'),

-- Peristeri properties
('Family Home in Peristeri', 'Spacious 3-bedroom house with garden. Quiet residential area, perfect for families with children. Near schools and parks.', 280000.00, 'sale', 'House', 'Peristeri', 3, 2, 120, 1990, 'https://example.com/photos/peristeri1.jpg', 'garden,parking,storage,pets_allowed', 'available'),

-- Monastiraki properties
('Historic Center Loft', 'Unique loft in a restored building in Monastiraki. Steps from Acropolis and ancient sites. Ideal for those who love city center living.', 1500.00, 'rent', 'Loft', 'Monastiraki', 1, 1, 60, 1920, 'https://example.com/photos/monastiraki1.jpg', 'balcony,air_conditioning,historic_building', 'available'),

-- Aghia Paraskevi properties
('Modern 2BR near University', 'Contemporary 2-bedroom apartment near Harokopio University. Great for students or professionals.', 750.00, 'rent', 'Apartment', 'Aghia Paraskevi', 2, 1, 70, 2015, 'https://example.com/photos/agia1.jpg', 'parking,elevator,air_conditioning,balcony', 'available'),

-- Chalandri properties
('Luxury Villa in Chalandri', 'Exclusive 4-bedroom villa in upscale Chalandri. Private pool, garden, and parking. High-end finishes.', 850000.00, 'sale', 'Villa', 'Chalandri', 4, 3, 250, 2018, 'https://example.com/photos/chalandri1.jpg', 'pool,garden,parking,air_conditioning,alarm_system,solar_panels', 'available');
```

### Sample Inquiries

```sql
INSERT INTO inquiries (property_id, user_id, name, email, phone, message, status) VALUES
(1, 2, 'Maria Papadopoulos', 'maria@example.com', '+30 210 234 5678', 'Hi, I would like to schedule a viewing for this apartment. I am available this weekend. Thank you!', 'new'),
(3, 3, 'Dimitris Konstantinou', 'dimitris@example.com', '+30 210 345 6789', 'Is the price negotiable? I am very interested in this property.', 'contacted'),
(5, 1, 'John Doe', 'jdoe@example.com', '+30 210 123 4567', 'Does this house allow pets? I have a small dog.', 'new');
```

---

## Migration Scripts

### Initial Database Setup

```sql
-- Create database
CREATE DATABASE IF NOT EXISTS realdawgs_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE realdawgs_db;

-- Create tables in correct order (respecting foreign keys)
-- 1. users (no dependencies)
-- 2. properties (no dependencies)
-- 3. inquiries (depends on users, properties)
-- 4. favorites (depends on users, properties)
-- 5. property_photos (depends on properties)
```

### Migration: Rename Database (Optional)

```sql
-- Cannot directly rename database in MySQL
-- Instead, create new database and migrate data

CREATE DATABASE realdawgs_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Use mysqldump to copy data:
-- mysqldump rentit_db | mysql realdawgs_db

-- Or use tool like MySQL Workbench migration wizard
```

### Migration: Add New Columns to Existing Table

```sql
-- Example: Add 'floor_level' to properties table
ALTER TABLE properties
ADD COLUMN floor_level INT COMMENT 'Floor number (NULL for houses)' AFTER year_built;

-- Add index
ALTER TABLE properties ADD INDEX idx_floor (floor_level);
```

### Migration: Transform Reservation to Inquiry

```sql
-- If you have existing 'reservations' table, migrate to 'inquiries'

-- Step 1: Create inquiries table (if not exists)
-- (Use CREATE TABLE statement above)

-- Step 2: Migrate data
INSERT INTO inquiries (property_id, user_id, name, email, message, created_at)
SELECT
    r.apartment_id AS property_id,
    u.id AS user_id,
    u.name,
    u.email,
    CONCAT('Reservation from ', r.check_in, ' to ', r.check_out) AS message,
    NOW() AS created_at
FROM reservations r
JOIN users u ON r.user = u.username;

-- Step 3: Drop old table (CAREFUL!)
-- DROP TABLE reservations;
```

---

## Queries & Examples

### Common Queries

#### 1. Get All Available Properties in an Area

```sql
SELECT
    id,
    title,
    price,
    listing_type,
    bedrooms,
    bathrooms,
    square_meters,
    photo_url
FROM properties
WHERE area = 'Kypseli'
  AND status = 'available'
ORDER BY price ASC;
```

#### 2. Search Properties with Filters

```sql
SELECT *
FROM properties
WHERE status = 'available'
  AND listing_type = 'sale'
  AND price BETWEEN 200000 AND 300000
  AND bedrooms >= 2
  AND area IN ('Kypseli', 'Piraeus', 'Peristeri')
ORDER BY price ASC
LIMIT 20;
```

#### 3. Get Property Details with Inquiry Count

```sql
SELECT
    p.*,
    COUNT(i.id) AS inquiry_count
FROM properties p
LEFT JOIN inquiries i ON p.id = i.property_id
WHERE p.id = 1
GROUP BY p.id;
```

#### 4. Get User's Inquiries

```sql
SELECT
    i.id AS inquiry_id,
    i.message,
    i.status,
    i.created_at,
    p.title AS property_title,
    p.area,
    p.price
FROM inquiries i
JOIN properties p ON i.property_id = p.id
WHERE i.user_id = 2
ORDER BY i.created_at DESC;
```

#### 5. Get User's Favorite Properties (Phase 2)

```sql
SELECT
    p.*,
    f.created_at AS favorited_at
FROM favorites f
JOIN properties p ON f.property_id = p.id
WHERE f.user_id = 2
  AND p.status = 'available'
ORDER BY f.created_at DESC;
```

#### 6. Top 5 Most Inquired Properties

```sql
SELECT
    p.id,
    p.title,
    p.area,
    p.price,
    COUNT(i.id) AS inquiry_count
FROM properties p
LEFT JOIN inquiries i ON p.id = i.property_id
WHERE p.status = 'available'
GROUP BY p.id
ORDER BY inquiry_count DESC
LIMIT 5;
```

#### 7. Average Price by Area

```sql
SELECT
    area,
    listing_type,
    AVG(price) AS avg_price,
    COUNT(*) AS property_count
FROM properties
WHERE status = 'available'
GROUP BY area, listing_type
ORDER BY area, listing_type;
```

#### 8. Recently Added Properties

```sql
SELECT *
FROM properties
WHERE status = 'available'
ORDER BY created_at DESC
LIMIT 10;
```

### Advanced Queries

#### Full-Text Search (Phase 2)

```sql
-- Add full-text index
ALTER TABLE properties
ADD FULLTEXT INDEX idx_fulltext (title, description);

-- Search query
SELECT *
FROM properties
WHERE MATCH(title, description) AGAINST('modern balcony sea view' IN NATURAL LANGUAGE MODE)
  AND status = 'available';
```

#### Properties with Photo Gallery (Phase 2)

```sql
SELECT
    p.*,
    GROUP_CONCAT(ph.photo_url ORDER BY ph.display_order) AS all_photos
FROM properties p
LEFT JOIN property_photos ph ON p.id = ph.property_id
WHERE p.id = 1
GROUP BY p.id;
```

---

## Backup & Restore

### Backup Database

```bash
# Full database backup
mysqldump -u username -p realdawgs_db > backup_$(date +%Y%m%d).sql

# Backup specific tables
mysqldump -u username -p realdawgs_db users properties inquiries > backup_core_tables.sql

# Backup with gzip compression
mysqldump -u username -p realdawgs_db | gzip > backup_$(date +%Y%m%d).sql.gz
```

### Restore Database

```bash
# Restore from backup
mysql -u username -p realdawgs_db < backup_20260117.sql

# Restore from gzipped backup
gunzip < backup_20260117.sql.gz | mysql -u username -p realdawgs_db
```

### Cloud SQL Backups

```bash
# Create on-demand backup
gcloud sql backups create --instance=rentit-db

# List backups
gcloud sql backups list --instance=rentit-db

# Restore from backup
gcloud sql backups restore BACKUP_ID --backup-instance=rentit-db --backup-run=BACKUP_ID
```

---

## Performance Tuning

### Query Performance

```sql
-- Analyze query performance
EXPLAIN SELECT * FROM properties WHERE area = 'Kypseli' AND status = 'available';

-- Check if indexes are being used
SHOW INDEX FROM properties;

-- Analyze table
ANALYZE TABLE properties;

-- Optimize table (defragment)
OPTIMIZE TABLE properties;
```

### Connection Pooling

```java
// In production, use connection pooling (HikariCP example)
HikariConfig config = new HikariConfig();
config.setJdbcUrl("jdbc:mysql://...");
config.setUsername("...");
config.setPassword("...");
config.setMaximumPoolSize(10);
config.setMinimumIdle(5);
config.setConnectionTimeout(30000);
config.setIdleTimeout(600000);
config.setMaxLifetime(1800000);

HikariDataSource dataSource = new HikariDataSource(config);
Connection conn = dataSource.getConnection();
```

---

## Security Best Practices

### SQL Injection Prevention

```java
// ALWAYS use PreparedStatement
String query = "SELECT * FROM users WHERE username = ? AND password = ?";
PreparedStatement stmt = conn.prepareStatement(query);
stmt.setString(1, username);
stmt.setString(2, hashedPassword);
ResultSet rs = stmt.executeQuery();

// NEVER concatenate strings
// String query = "SELECT * FROM users WHERE username = '" + username + "'"; // DANGEROUS!
```

### Password Storage

```java
// Use BCrypt for password hashing
import org.mindrot.jbcrypt.BCrypt;

// Hash password on registration
String hashedPassword = BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));

// Verify on login
if (BCrypt.checkpw(plainPassword, hashedPassword)) {
    // Login successful
}
```

### Database User Permissions

```sql
-- Create application user with limited permissions
CREATE USER 'realdawgs_app'@'%' IDENTIFIED BY 'strong_password';

-- Grant only necessary permissions
GRANT SELECT, INSERT, UPDATE ON realdawgs_db.* TO 'realdawgs_app'@'%';

-- Do NOT grant DELETE or DROP permissions to app user
-- Use separate admin user for schema changes
```

---

## Troubleshooting

### Common Issues

#### Connection Refused
```
Error: Connection refused
```
**Solution:** Check database server is running, verify host/port, check firewall rules.

#### Too Many Connections
```
Error: Too many connections
```
**Solution:** Increase `max_connections` in MySQL config or implement connection pooling.

#### Slow Queries
```
Query takes > 5 seconds
```
**Solution:** Add indexes, optimize query, check table size, analyze execution plan with EXPLAIN.

#### Character Encoding Issues
```
Characters displayed as ���
```
**Solution:** Ensure database, table, and connection all use UTF-8 (utf8mb4).

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | Jan 2026 | Initial schema design |
| 0.9 | Jan 2026 | Migration from RentIt schema |

---

**Maintained By:** RealDawgs Development Team
**Contact:** dev@realdawgs.com
