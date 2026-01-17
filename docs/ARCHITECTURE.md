# Technical Architecture Documentation
## RealDawgs Real Estate Platform

**Version:** 1.0
**Last Updated:** January 2026

---

## Table of Contents
1. [Overview](#overview)
2. [System Architecture](#system-architecture)
3. [Technology Stack](#technology-stack)
4. [Application Structure](#application-structure)
5. [Data Model](#data-model)
6. [API Design](#api-design)
7. [Security Architecture](#security-architecture)
8. [Deployment Architecture](#deployment-architecture)
9. [Performance Considerations](#performance-considerations)
10. [Monitoring & Logging](#monitoring--logging)

---

## Overview

### Purpose
This document describes the technical architecture of the RealDawgs real estate platform, a Java-based web application built with JSP/Servlets and deployed on Google App Engine.

### Architecture Goals
- **Simplicity:** Easy to understand and maintain
- **Scalability:** Handle growth from 100 to 5,000+ properties
- **Reliability:** 99.5% uptime
- **Security:** Protect user data and prevent common vulnerabilities
- **Cost-Effective:** Minimize hosting costs while maintaining performance

### Architecture Principles
1. **Separation of Concerns:** MVC pattern (Model-View-Controller)
2. **DRY (Don't Repeat Yourself):** Reusable components and utilities
3. **Database-First:** Relational data model with normalized tables
4. **Stateful Sessions:** Server-side session management
5. **Progressive Enhancement:** Works without JavaScript, enhanced with it

---

## System Architecture

### High-Level Architecture

```
┌─────────────┐
│   Browser   │
│  (Client)   │
└──────┬──────┘
       │ HTTPS
       ▼
┌─────────────────────────────────────┐
│     Google App Engine (GAE)         │
│  ┌───────────────────────────────┐  │
│  │   Apache Tomcat (Runtime)     │  │
│  │  ┌─────────────────────────┐  │  │
│  │  │   JSP/Servlet Layer     │  │  │
│  │  │  ┌──────────────────┐   │  │  │
│  │  │  │  Controllers     │   │  │  │
│  │  │  │  (JSP Pages)     │   │  │  │
│  │  │  └────────┬─────────┘   │  │  │
│  │  │           │              │  │  │
│  │  │  ┌────────▼─────────┐   │  │  │
│  │  │  │  Business Logic  │   │  │  │
│  │  │  │  (Services)      │   │  │  │
│  │  │  └────────┬─────────┘   │  │  │
│  │  │           │              │  │  │
│  │  │  ┌────────▼─────────┐   │  │  │
│  │  │  │  Data Access     │   │  │  │
│  │  │  │  (DAO Layer)     │   │  │  │
│  │  │  └────────┬─────────┘   │  │  │
│  │  └───────────┼─────────────┘  │  │
│  └──────────────┼────────────────┘  │
└─────────────────┼────────────────────┘
                  │ JDBC
                  ▼
         ┌────────────────┐
         │   Cloud SQL    │
         │    (MySQL)     │
         └────────────────┘
```

### Component Interaction Flow

```
User Request Flow:
1. Browser → HTTPS → App Engine
2. App Engine → JSP Controller (e.g., areaOptions.jsp)
3. JSP → Service Layer (e.g., PropertyService.java)
4. Service → DAO Layer (e.g., PropertyDAO.java)
5. DAO → Database (Cloud SQL)
6. Database → DAO (Results)
7. DAO → Service (Process)
8. Service → JSP (Model data)
9. JSP → HTML Rendering
10. HTML → Browser
```

---

## Technology Stack

### Backend Technologies

| Technology | Version | Purpose |
|------------|---------|---------|
| Java | 11 | Core programming language |
| JSP | 2.3 | View layer / templating |
| Servlets | 4.0 | HTTP request handling |
| JDBC | 8.0 | Database connectivity |
| MySQL Connector/J | 8.0.33 | MySQL driver |
| JSTL | 1.2 | JSP tag library |

### Frontend Technologies

| Technology | Version | Purpose |
|------------|---------|---------|
| HTML5 | - | Markup |
| CSS3 | - | Styling |
| Bootstrap | 4.5.2 | UI framework |
| jQuery | 3.5.1 | JavaScript library |
| JavaScript (ES5) | - | Client-side logic |

### Infrastructure

| Service | Purpose |
|---------|---------|
| Google App Engine | Application hosting |
| Cloud SQL (MySQL 8.0) | Relational database |
| Cloud Storage (future) | Image/file storage |
| Cloud CDN (future) | Content delivery |

### Build & Development Tools

| Tool | Version | Purpose |
|------|---------|---------|
| Maven | 3.6+ | Build automation |
| Git | 2.x | Version control |
| Google Cloud SDK | Latest | Deployment CLI |

---

## Application Structure

### Directory Structure

```
realdawgs/
├── pom.xml                          # Maven configuration
├── README.md                        # Project overview
├── DEPLOYMENT.md                    # Deployment guide
├── docs/                            # Documentation
│   ├── PRD.md                      # Product requirements
│   ├── ARCHITECTURE.md             # This file
│   ├── USER_GUIDE.md               # User documentation
│   └── API.md                      # API documentation
├── src/
│   └── main/
│       ├── java/RentIt/            # Java source code
│       │   ├── models/             # Data models
│       │   │   ├── User.java
│       │   │   ├── Property.java  # (to be created)
│       │   │   └── Inquiry.java   # (to be created)
│       │   ├── dao/                # Data access objects
│       │   │   ├── UserDAO.java
│       │   │   ├── PropertyDAO.java  # (to be created)
│       │   │   └── InquiryDAO.java   # (to be created)
│       │   ├── services/           # Business logic
│       │   │   ├── UserService.java
│       │   │   ├── PropertyService.java  # (to be created)
│       │   │   └── InquiryService.java   # (to be created)
│       │   ├── utils/              # Utilities
│       │   │   ├── DB.java         # Database connection
│       │   │   ├── ValidationUtils.java  # (to be created)
│       │   │   └── SessionUtils.java     # (to be created)
│       │   └── Reservation.java    # Legacy (to be refactored)
│       └── webapp/                 # Web content
│           ├── WEB-INF/
│           │   ├── web.xml         # Deployment descriptor
│           │   └── appengine-web.xml  # App Engine config
│           ├── css/                # Stylesheets (future)
│           ├── js/                 # JavaScript (future)
│           ├── images/             # Static images (future)
│           ├── home.html           # Landing page
│           ├── home.jsp            # Dynamic home page
│           ├── areaOptions.jsp     # Property listings
│           ├── reserve.jsp         # Property details
│           ├── RentIt_login.jsp    # Login page
│           ├── RentIt_register.jsp # Registration page
│           ├── RentIt_loginController.jsp     # Login handler
│           ├── RentIt_registerController.jsp  # Register handler
│           ├── RentIt_header.jsp   # Header component
│           ├── RentIt_footer.jsp   # Footer component
│           └── RentIt_error.jsp    # Error page
└── target/                         # Build output (generated)
```

### MVC Architecture

#### Model Layer (Java Classes)
- **Location:** `src/main/java/RentIt/models/`
- **Purpose:** Represent data entities
- **Examples:**
  - `User.java` - User account data
  - `Property.java` - Property listing data
  - `Inquiry.java` - User inquiry data

```java
// Example: Property.java
public class Property {
    private int id;
    private String title;
    private String description;
    private double price;
    private String listingType; // "sale" or "rent"
    private String area;
    private int bedrooms;
    private int bathrooms;
    private int squareMeters;
    private String photoUrl;
    // Getters and setters...
}
```

#### View Layer (JSP Pages)
- **Location:** `src/main/webapp/*.jsp`
- **Purpose:** Render HTML for user interface
- **Examples:**
  - `home.jsp` - Homepage with area selection
  - `areaOptions.jsp` - Property listings for an area
  - `reserve.jsp` - Property details page
  - `RentIt_login.jsp` - Login form

```jsp
<!-- Example: areaOptions.jsp structure -->
<%@ page import="RentIt.Property" %>
<%@ page import="java.util.List" %>

<%
    String area = request.getParameter("area");
    PropertyService service = new PropertyService();
    List<Property> properties = service.getPropertiesByArea(area);
%>

<!-- Display properties -->
<% for (Property property : properties) { %>
    <div class="property-card">
        <h3><%= property.getTitle() %></h3>
        <p>€<%= property.getPrice() %></p>
        <!-- More details... -->
    </div>
<% } %>
```

#### Controller Layer (Service Classes + JSP Controllers)
- **Location:** `src/main/java/RentIt/services/` + `*.jsp`
- **Purpose:** Handle business logic and request processing
- **Examples:**
  - `UserService.java` - User authentication logic
  - `PropertyService.java` - Property search/retrieval logic
  - `RentIt_loginController.jsp` - Process login form
  - `RentIt_registerController.jsp` - Process registration

---

## Data Model

### Entity Relationship Diagram

```
┌─────────────┐           ┌──────────────┐
│    User     │           │   Property   │
├─────────────┤           ├──────────────┤
│ id (PK)     │           │ id (PK)      │
│ name        │           │ title        │
│ surname     │           │ description  │
│ email       │           │ price        │
│ username    │     ┌─────│ listing_type │
│ password    │     │     │ area         │
│ phone       │     │     │ bedrooms     │
│ created_at  │     │     │ bathrooms    │
└──────┬──────┘     │     │ square_meters│
       │            │     │ photo_url    │
       │            │     │ status       │
       │            │     │ created_at   │
       │            │     └──────────────┘
       │            │
       │     ┌──────▼────────┐
       └────►│   Inquiry     │
             ├───────────────┤
             │ id (PK)       │
             │ property_id(FK)│
             │ user_id (FK)  │
             │ name          │
             │ email         │
             │ phone         │
             │ message       │
             │ created_at    │
             │ status        │
             └───────────────┘

       ┌──────────────┐
       │  Favorites   │◄─── (Phase 2)
       ├──────────────┤
       │ user_id (FK) │
       │ property_id  │
       │ created_at   │
       └──────────────┘
```

### Database Schema Details

See `docs/DATABASE.md` for complete SQL schema.

**Key Tables:**
1. **users** - User accounts
2. **properties** - Property listings
3. **inquiries** - User inquiries about properties
4. **favorites** - Saved properties (Phase 2)
5. **property_photos** - Multiple photos per property (Phase 2)

### Data Access Pattern

```java
// DAO Pattern Example
public class PropertyDAO {

    // Get all properties by area
    public List<Property> getPropertiesByArea(String area) throws Exception {
        DB db = new DB();
        Connection con = db.getConnection();
        String query = "SELECT * FROM properties WHERE area = ? AND status = 'available'";

        PreparedStatement stmt = con.prepareStatement(query);
        stmt.setString(1, area);
        ResultSet rs = stmt.executeQuery();

        List<Property> properties = new ArrayList<>();
        while (rs.next()) {
            Property property = new Property();
            property.setId(rs.getInt("id"));
            property.setTitle(rs.getString("title"));
            // Map other fields...
            properties.add(property);
        }

        rs.close();
        stmt.close();
        db.close();

        return properties;
    }
}
```

---

## API Design

### Internal JSP API (Server-Side)

Since this is a server-rendered JSP application, there's no REST API. All logic happens server-side.

#### Page Endpoints

| URL Pattern | JSP File | HTTP Method | Purpose |
|-------------|----------|-------------|---------|
| `/` or `/home.html` | `home.html` | GET | Landing page |
| `/home.jsp` | `home.jsp` | GET | Dynamic home (if logged in) |
| `/areaOptions.jsp?area=Kypseli` | `areaOptions.jsp` | GET | List properties by area |
| `/reserve.jsp?id=123` | `reserve.jsp` | GET | Property details |
| `/RentIt_login.jsp` | `RentIt_login.jsp` | GET | Login form |
| `/RentIt_loginController.jsp` | `RentIt_loginController.jsp` | POST | Process login |
| `/RentIt_register.jsp` | `RentIt_register.jsp` | GET | Registration form |
| `/RentIt_registerController.jsp` | `RentIt_registerController.jsp` | POST | Process registration |
| `/finalize.jsp` | `finalize.jsp` | POST | Submit inquiry |

#### Request/Response Flow

**Example: User Login**

```
1. User visits /RentIt_login.jsp (GET)
   └─> Display login form

2. User submits form to /RentIt_loginController.jsp (POST)
   ├─> Parameters: username, password
   ├─> UserService.authenticate(username, password)
   ├─> If valid:
   │   ├─> session.setAttribute("userObj2024", user)
   │   └─> redirect to /home.jsp
   └─> If invalid:
       └─> forward to /RentIt_error.jsp with error message
```

**Example: Browse Properties**

```
1. User clicks "Kypseli" on homepage
   └─> Navigate to /areaOptions.jsp?area=Kypseli (GET)

2. areaOptions.jsp processes request:
   ├─> Get area parameter
   ├─> PropertyService.getByArea("Kypseli")
   ├─> PropertyDAO queries database
   ├─> Return List<Property>
   └─> Render property cards in HTML
```

### Session Management

**Session Attributes:**
- `userObj2024` - Logged-in User object
- `cart` (future) - Shopping cart for saved properties
- `searchFilters` (future) - Saved search criteria

```jsp
<!-- Check if user is logged in -->
<%
User loggedInUser = (User) session.getAttribute("userObj2024");
if (loggedInUser != null) {
    // User is logged in
    String username = loggedInUser.getUsername();
} else {
    // User not logged in
}
%>
```

---

## Security Architecture

### Authentication & Authorization

#### Password Security
- **Storage:** Bcrypt hashing (future implementation)
- **Current:** Plain text (MUST be changed before production)
- **Minimum Length:** 6 characters
- **Complexity:** Recommend letters + numbers

**TODO: Implement password hashing**
```java
// Use BCrypt library
import org.mindrot.jbcrypt.BCrypt;

// Hash password on registration
String hashedPassword = BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));

// Verify password on login
if (BCrypt.checkpw(plainPassword, hashedPassword)) {
    // Valid
}
```

#### Session Security
- **Session Timeout:** 30 minutes
- **Secure Cookies:** HTTPS-only (enforced by App Engine)
- **Session Fixation Prevention:** New session ID on login
- **Logout:** Invalidate session completely

### Input Validation & Sanitization

#### Server-Side Validation
All user input must be validated before processing:

```java
// Email validation
public static boolean isValidEmail(String email) {
    String regex = "^[A-Za-z0-9+_.-]+@(.+)$";
    return email.matches(regex);
}

// SQL Injection Prevention
// ALWAYS use PreparedStatement, NEVER string concatenation
PreparedStatement stmt = con.prepareStatement(
    "SELECT * FROM users WHERE username = ?"
);
stmt.setString(1, username); // Safe
```

#### XSS Prevention
```jsp
<!-- Escape output in JSP -->
<%@ page contentType="text/html; charset=UTF-8" %>
<p><%= org.apache.commons.text.StringEscapeUtils.escapeHtml4(userInput) %></p>

<!-- Or use JSTL c:out -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:out value="${userInput}" />
```

### HTTPS & Transport Security
- **Enforced by App Engine:** All HTTP → HTTPS redirects
- **TLS Version:** 1.2+ only
- **HSTS:** Enabled on App Engine

### CSRF Protection (Future)
Implement CSRF tokens for all forms:
```jsp
<!-- Generate token on form page -->
<%
String csrfToken = UUID.randomUUID().toString();
session.setAttribute("csrfToken", csrfToken);
%>

<form method="POST">
    <input type="hidden" name="csrfToken" value="<%= csrfToken %>">
    <!-- Form fields -->
</form>

<!-- Validate token on submission -->
<%
String submittedToken = request.getParameter("csrfToken");
String sessionToken = (String) session.getAttribute("csrfToken");
if (!submittedToken.equals(sessionToken)) {
    // Invalid request
}
%>
```

---

## Deployment Architecture

### Google App Engine Configuration

#### appengine-web.xml
```xml
<appengine-web-app xmlns="http://appengine.google.com/ns/1.0">
    <threadsafe>true</threadsafe>
    <runtime>java11</runtime>
    <sessions-enabled>true</sessions-enabled>

    <system-properties>
        <property name="java.util.logging.config.file"
                  value="WEB-INF/logging.properties"/>
    </system-properties>
</appengine-web-app>
```

#### web.xml
```xml
<web-app version="3.1">
    <display-name>RealDawgs</display-name>

    <welcome-file-list>
        <welcome-file>home.html</welcome-file>
        <welcome-file>home.jsp</welcome-file>
    </welcome-file-list>

    <session-config>
        <session-timeout>30</session-timeout>
    </session-config>

    <error-page>
        <error-code>404</error-code>
        <location>/RentIt_error.jsp</location>
    </error-page>
</web-app>
```

### Cloud SQL Connection

#### Connection String
```java
// Local development
String url = "jdbc:mysql://localhost:3306/rentit_db";

// Production (Cloud SQL)
String url = "jdbc:mysql:///<database_name>?cloudSqlInstance=<instance_connection_name>"
           + "&socketFactory=com.google.cloud.sql.mysql.SocketFactory";
```

#### Connection Pooling (Future)
Implement connection pooling for better performance:
- Use HikariCP or Apache DBCP
- Pool size: 5-10 connections initially
- Max lifetime: 30 minutes
- Connection timeout: 10 seconds

---

## Performance Considerations

### Database Optimization

#### Indexing Strategy
```sql
-- Primary indexes
ALTER TABLE properties ADD INDEX idx_area (area);
ALTER TABLE properties ADD INDEX idx_status (status);
ALTER TABLE properties ADD INDEX idx_listing_type (listing_type);

-- Composite indexes
ALTER TABLE properties ADD INDEX idx_area_type (area, listing_type);
ALTER TABLE inquiries ADD INDEX idx_property_user (property_id, user_id);
```

#### Query Optimization
- Use `SELECT` specific columns, not `SELECT *`
- Add `LIMIT` clauses for pagination
- Use `JOIN` instead of multiple queries
- Cache frequently accessed data (future)

```java
// Good: Paginated query
String query = "SELECT id, title, price, area FROM properties "
             + "WHERE area = ? LIMIT ? OFFSET ?";

// Bad: Fetch all
String query = "SELECT * FROM properties WHERE area = ?";
```

### Caching Strategy (Future)

#### Page-Level Caching
- Cache property listings for 5 minutes
- Cache area metadata indefinitely
- Invalidate on data updates

#### Object Caching
- Use Memcached or Redis
- Cache expensive queries
- TTL: 5-60 minutes depending on data

### Frontend Optimization

#### Image Optimization
- Compress images (WebP format)
- Lazy load images below fold
- Use responsive images (`srcset`)
- CDN for image delivery (future)

#### CSS/JS Optimization
- Minify CSS/JS files
- Combine files to reduce requests
- Load JavaScript asynchronously
- Use Bootstrap CDN (already doing)

#### Response Time Targets
- **Time to First Byte (TTFB):** < 500ms
- **First Contentful Paint (FCP):** < 1.5s
- **Largest Contentful Paint (LCP):** < 2.5s
- **Total Page Load:** < 3s

---

## Monitoring & Logging

### Application Logging

#### Log Levels
- **ERROR:** Exceptions, failed operations
- **WARN:** Potential issues, deprecated features
- **INFO:** Successful operations, user actions
- **DEBUG:** Detailed debugging information (dev only)

#### What to Log
```java
// Login attempts
logger.info("Login attempt for user: " + username);
logger.error("Failed login for user: " + username + ", reason: " + e.getMessage());

// Database operations
logger.debug("Querying properties for area: " + area);
logger.error("Database connection failed: " + e.getMessage());

// User actions
logger.info("User " + userId + " submitted inquiry for property " + propertyId);
```

### Google Cloud Monitoring

#### Key Metrics to Monitor
- **Request latency:** 95th percentile < 1s
- **Error rate:** < 1%
- **Memory usage:** < 80% of instance memory
- **Database connections:** Monitor pool usage
- **Active sessions:** Track concurrent users

#### Alerts to Set Up
1. Error rate > 5% for 5 minutes
2. Average latency > 2s for 10 minutes
3. Database connection failures
4. Memory usage > 90%
5. Disk usage > 80%

### Error Tracking
- Log all exceptions with stack traces
- Track user journey when errors occur
- Set up email alerts for critical errors
- Use Cloud Error Reporting (built into App Engine)

---

## Scalability Plan

### Current Capacity
- **Expected Load:** 50-100 concurrent users
- **Database:** Single Cloud SQL instance (db-f1-micro)
- **App Engine:** Automatic scaling (0-5 instances)

### Scaling Triggers

#### Horizontal Scaling (App Engine)
```yaml
# app.yaml configuration (future)
automatic_scaling:
  min_instances: 1
  max_instances: 10
  target_cpu_utilization: 0.65
  target_throughput_utilization: 0.6
```

#### Vertical Scaling (Database)
- Start: db-f1-micro (0.6 GB RAM)
- Grow to: db-n1-standard-1 (3.75 GB RAM)
- Add read replicas if read-heavy

### Performance Bottlenecks to Watch
1. **Database queries** - Optimize slow queries
2. **Image loading** - Implement CDN
3. **Session storage** - Move to distributed cache if needed
4. **Concurrent connections** - Connection pooling

---

## Disaster Recovery

### Backup Strategy

#### Database Backups
- **Automated:** Daily backups (Cloud SQL)
- **Retention:** 7 days
- **Manual:** Before major updates
- **Test Restores:** Monthly

#### Code Repository
- **Git:** All code versioned
- **Remote:** GitHub/GitLab
- **Branching:** main, dev, feature branches

### Recovery Procedures

#### Database Failure
1. App Engine detects connection failure
2. Automatic failover (if replica exists)
3. Or restore from latest backup
4. RTO (Recovery Time Objective): 2 hours
5. RPO (Recovery Point Objective): 1 day (daily backups)

#### Application Failure
1. App Engine auto-restarts unhealthy instances
2. If persistent, rollback to previous version
3. Investigate logs and fix issue
4. Deploy patched version

---

## Development Workflow

### Local Development Setup
1. Install Java 11, Maven, MySQL
2. Clone repository
3. Create local database
4. Update DB.java with local credentials
5. Run `mvn clean install`
6. Test locally with `mvn appengine:run`

### Deployment Process
1. Test locally
2. Commit to `dev` branch
3. Create PR to `main`
4. Code review
5. Merge to `main`
6. Deploy to staging (future)
7. QA testing
8. Deploy to production: `mvn appengine:deploy`
9. Monitor logs for errors

### Version Control
- **Branching Model:** Git Flow
- **Main Branch:** Production-ready code
- **Dev Branch:** Integration branch
- **Feature Branches:** `feature/property-search`
- **Hotfix Branches:** `hotfix/login-bug`

---

## Security Checklist

### Pre-Production Security Audit

- [ ] Implement password hashing (BCrypt)
- [ ] Add CSRF protection to all forms
- [ ] Sanitize all user inputs
- [ ] Escape all outputs to prevent XSS
- [ ] Use prepared statements (already done)
- [ ] Implement rate limiting on login
- [ ] Add CAPTCHA to registration
- [ ] Set secure session cookies
- [ ] Implement password reset flow
- [ ] Add account lockout after failed attempts
- [ ] Create privacy policy page
- [ ] Create terms of service page
- [ ] Implement GDPR compliance (if EU users)
- [ ] Regular dependency updates
- [ ] Security headers (CSP, X-Frame-Options, etc.)

---

## Appendix

### Code Standards

#### Java Naming Conventions
- **Classes:** PascalCase (`UserService`, `PropertyDAO`)
- **Methods:** camelCase (`getProperties`, `authenticate`)
- **Variables:** camelCase (`userName`, `propertyList`)
- **Constants:** UPPER_SNAKE_CASE (`MAX_RESULTS`, `DB_URL`)

#### JSP Best Practices
- Minimize Java code in JSP (use beans/services)
- Use JSTL tags when possible
- Include headers/footers via `<jsp:include>`
- Proper error handling with try-catch
- Close database resources in finally blocks

### References
- [Java Servlet Specification](https://javaee.github.io/servlet-spec/)
- [JSP Specification](https://javaee.github.io/javaee-spec/)
- [Google App Engine Java Docs](https://cloud.google.com/appengine/docs/standard/java11)
- [MySQL Best Practices](https://dev.mysql.com/doc/refman/8.0/en/optimization.html)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)

---

**Document Maintained By:** RealDawgs Technical Team
**Last Review:** January 2026
**Next Review:** Quarterly
