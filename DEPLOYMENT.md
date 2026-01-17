# Deployment Guide for Google App Engine

## Prerequisites

1. **Google Cloud Account**: Create a free account at https://cloud.google.com/
2. **Google Cloud SDK**: Install gcloud CLI
   ```bash
   # Install instructions: https://cloud.google.com/sdk/docs/install
   ```
3. **Maven**: Install Apache Maven
   ```bash
   # Ubuntu/Debian
   sudo apt install maven

   # macOS
   brew install maven
   ```

## Step 1: Set Up Google Cloud Project

```bash
# Login to Google Cloud
gcloud auth login

# Create a new project
gcloud projects create YOUR-PROJECT-ID --name="Real Estate App"

# Set the project
gcloud config set project YOUR-PROJECT-ID

# Enable required APIs
gcloud services enable appengine.googleapis.com
gcloud services enable sqladmin.googleapis.com

# Create App Engine application
gcloud app create --region=europe-west1  # or your preferred region
```

## Step 2: Set Up Cloud SQL Database (Optional)

For a database, you have two options:

### Option A: Use Cloud SQL (Recommended for production)

```bash
# Create Cloud SQL instance
gcloud sql instances create rentit-db \
    --database-version=MYSQL_8_0 \
    --tier=db-f1-micro \
    --region=europe-west1

# Set root password
gcloud sql users set-password root \
    --host=% \
    --instance=rentit-db \
    --password=YOUR_PASSWORD

# Create database
gcloud sql databases create rentit_db --instance=rentit-db
```

Then update `src/main/java/RentIt/DB.java` with Cloud SQL connection string.

### Option B: Start with in-memory data (Simpler for testing)

Keep the current `UserDAO.java` which uses hardcoded users. No database setup needed!

## Step 3: Build the Application

```bash
# Navigate to project directory
cd /home/user/realdawgs

# Build with Maven
mvn clean package

# This creates: target/realdawgs-1.0-SNAPSHOT.war
```

## Step 4: Deploy to Google App Engine

```bash
# Deploy the application
mvn appengine:deploy

# Or use gcloud directly
gcloud app deploy target/realdawgs-1.0-SNAPSHOT.war

# View your app
gcloud app browse
```

Your app will be available at: `https://YOUR-PROJECT-ID.appspot.com`

## Step 5: View Logs

```bash
# Stream logs
gcloud app logs tail -s default

# View in browser
gcloud app logs read
```

## Project Structure

```
realdawgs/
├── pom.xml                          # Maven configuration
├── src/
│   └── main/
│       ├── java/
│       │   └── RentIt/
│       │       ├── DB.java          # Database connection
│       │       ├── User.java        # User model
│       │       ├── Reservation.java # Reservation model
│       │       ├── UserDAO.java     # User data access
│       │       └── UserService.java # User service
│       └── webapp/
│           ├── WEB-INF/
│           │   ├── web.xml          # Deployment descriptor
│           │   └── appengine-web.xml # App Engine config
│           ├── home.html            # Landing page
│           ├── home.jsp             # Home page
│           ├── areaOptions.jsp      # Property listings
│           ├── reserve.jsp          # Property details
│           └── [other JSP files]
```

## Costs

- **App Engine**: Free tier includes 28 instance hours/day
- **Cloud SQL**: db-f1-micro is ~$7/month (or use free option B above)
- **Storage**: Minimal cost for small app

## Troubleshooting

### Build fails
```bash
# Check Java version
java -version  # Should be 11 or higher

# Check Maven
mvn -version
```

### Deployment fails
```bash
# Check project is set
gcloud config get-value project

# Check App Engine is enabled
gcloud app describe
```

### Database connection fails
- Verify Cloud SQL instance is running: `gcloud sql instances list`
- Check connection string in DB.java
- Ensure Cloud SQL Admin API is enabled

## Next Steps: Transform to Real Estate

Once deployed and working, modify:
1. Database schema (add property table)
2. JSP pages (change from reservations to property inquiries)
3. UI text (vacation rental → real estate)

See main README for transformation details.
