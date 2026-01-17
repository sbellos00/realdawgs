# Quick Start Deployment Guide
## Deploy RealDawgs to Google App Engine in 30 Minutes

---

## Prerequisites Checklist

Before starting, make sure you have:
- [ ] A Google account (free Gmail account)
- [ ] A credit/debit card (for Google Cloud - won't be charged on free tier)
- [ ] Internet connection
- [ ] This repository cloned locally

---

## Step 1: Install Google Cloud SDK (5 minutes)

### On Linux/Ubuntu:
```bash
# Add Cloud SDK repo
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

# Import Google Cloud public key
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

# Install
sudo apt-get update && sudo apt-get install google-cloud-sdk

# Verify installation
gcloud version
```

### On macOS:
```bash
# Install with Homebrew
brew install --cask google-cloud-sdk

# Or download installer from:
# https://cloud.google.com/sdk/docs/install#mac

# Verify installation
gcloud version
```

### On Windows:
1. Download installer: https://cloud.google.com/sdk/docs/install#windows
2. Run the installer
3. Follow the prompts
4. Verify: Open PowerShell and run `gcloud version`

---

## Step 2: Set Up Google Cloud Project (10 minutes)

### 2.1 Login to Google Cloud
```bash
gcloud auth login
```
- This opens a browser window
- Log in with your Google account
- Grant permissions when asked

### 2.2 Create a New Project
```bash
# Create project (choose a unique project ID)
gcloud projects create realdawgs-2026 --name="RealDawgs Real Estate"

# Set as active project
gcloud config set project realdawgs-2026

# Verify
gcloud config get-value project
```

**Note:** If `realdawgs-2026` is taken, try:
- `realdawgs-yourname`
- `realdawgs-${RANDOM}`
- Any unique name

### 2.3 Enable Billing (Free Tier)
1. Go to: https://console.cloud.google.com/billing
2. Click "Link a billing account"
3. Create a new billing account (requires credit card)
4. Link it to your project

**Don't worry:** App Engine has a generous free tier:
- 28 instance hours per day FREE
- 1 GB outbound data FREE per day
- You won't be charged unless you exceed these limits

### 2.4 Enable Required APIs
```bash
# Enable App Engine API
gcloud services enable appengine.googleapis.com

# Enable Cloud Build API (for deployment)
gcloud services enable cloudbuild.googleapis.com

# Verify
gcloud services list --enabled | grep appengine
```

### 2.5 Create App Engine Application
```bash
# Create App Engine app in Europe
gcloud app create --region=europe-west

# Or choose your preferred region:
# us-central (United States)
# asia-northeast1 (Tokyo)
# See all: gcloud app regions list
```

---

## Step 3: Deploy with Mock Data (No Database Required!)

Good news! We've already configured the application to use **in-memory mock data**, so you can deploy immediately without any database setup.

### What's been configured for you:
- ✅ **MockPropertyDAO**: 12 sample properties across 6 Athens neighborhoods
- ✅ **MockInquiryDAO**: In-memory inquiry storage
- ✅ All JSP pages updated to use mock DAOs
- ✅ No database connection required

**Note:** Inquiries will reset when the app restarts, but this is perfect for testing and demos!

---

## Step 4: Build and Deploy (10 minutes)

### 4.1 Install Maven (if not already installed)
```bash
# Ubuntu/Debian
sudo apt-get install maven

# macOS
brew install maven

# Windows
# Download from: https://maven.apache.org/download.cgi

# Verify
mvn -version
```

### 4.2 Run the Deployment Script
We've created an automated deployment script for you:

```bash
# Make the script executable
chmod +x deploy.sh

# Run deployment
./deploy.sh
```

### 4.3 Manual Deployment (Alternative)
If you prefer to deploy manually:

```bash
# Clean and package the application
mvn clean package

# Deploy to App Engine
gcloud app deploy target/RentIt.war --project=realdawgs-2026

# When prompted "Do you want to continue (Y/n)?" type: Y
```

---

## Step 5: Access Your Live Application

### 5.1 Get Your Application URL
```bash
# Open in browser
gcloud app browse

# Or get the URL
gcloud app describe --format="value(defaultHostname)"
```

Your app will be available at:
**https://realdawgs-2026.appspot.com**

(Replace `realdawgs-2026` with your actual project ID)

### 5.2 Test the Application
1. **Homepage**: Browse properties by area
2. **Property Listings**: Click on any Athens neighborhood
3. **Property Details**: Click "View Details" on any property
4. **Submit Inquiry**: Click "Express Interest" and fill out the form
5. **User Registration**: Create an account (optional)

---

## Step 6: View Logs and Monitor

### View Logs
```bash
# Stream logs in real-time
gcloud app logs tail -s default

# View logs in browser
gcloud app logs read
```

### Open Cloud Console
```bash
# Open App Engine dashboard
gcloud app open-console
```

---

## Troubleshooting

### Build Errors
If Maven build fails:
```bash
# Clean Maven cache
mvn clean

# Try building again
mvn package
```

### Deployment Errors

**Error: "The App Engine appengine-web.xml does not exist"**
- Make sure you're in the project root directory
- Check that `src/main/webapp/WEB-INF/appengine-web.xml` exists

**Error: "Project does not have billing enabled"**
- Follow Step 2.3 to enable billing
- Make sure billing account is linked to your project

**Error: "API not enabled"**
- Run: `gcloud services enable appengine.googleapis.com cloudbuild.googleapis.com`

### 404 Errors After Deployment

If you get 404 errors:
1. Check that all JSP files are in `src/main/webapp/`
2. Make sure `home.html` is in `src/main/webapp/`
3. Verify deployment completed successfully in logs

---

## Next Steps (After Deployment)

Once your app is live, you can:

### 1. Add a Real Database (Optional)
To persist data permanently:
- Set up Google Cloud SQL (MySQL)
- Update `DB.java` with Cloud SQL connection
- Switch JSP files back to regular DAOs (not Mock DAOs)
- See `docs/DATABASE.md` for schema

### 2. Custom Domain
Connect your own domain:
```bash
gcloud app domain-mappings create www.yourdomain.com
```

### 3. SSL Certificate
App Engine provides free SSL automatically!

### 4. Continuous Deployment
Set up GitHub Actions or Cloud Build for automatic deployment on git push.

### 5. Scale Your Application
App Engine scales automatically, but you can configure:
```yaml
# In appengine-web.xml
<automatic-scaling>
  <min-instances>1</min-instances>
  <max-instances>5</max-instances>
</automatic-scaling>
```

---

## Costs and Free Tier Limits

### Free Tier (Always Free)
- **28 instance hours/day**: ~1 instance running 24/7
- **1 GB outbound data/day**
- **Shared memcache**
- **1,000 search operations/day**

### Your App's Expected Usage (Mock Data)
- **Very low cost**: Likely stays within free tier
- **No database charges**: Using in-memory data
- **Minimal compute**: JSP pages are lightweight

### Monitoring Costs
```bash
# Check current usage
gcloud app instances list

# View billing reports
# Visit: https://console.cloud.google.com/billing
```

---

## Quick Reference

### Useful Commands
```bash
# Deploy new version
gcloud app deploy

# View logs
gcloud app logs tail

# Open app in browser
gcloud app browse

# Stop all instances (to save costs)
gcloud app instances delete <instance-id>

# List all versions
gcloud app versions list

# Delete old versions
gcloud app versions delete <version-id>
```

### Important Files
- `pom.xml`: Maven dependencies and build config
- `src/main/webapp/WEB-INF/appengine-web.xml`: App Engine configuration
- `src/main/webapp/WEB-INF/web.xml`: Servlet configuration
- `src/main/java/RentIt/MockPropertyDAO.java`: Sample property data
- `src/main/java/RentIt/MockInquiryDAO.java`: In-memory inquiry storage

---

## Support

### Need Help?
- **App Engine Docs**: https://cloud.google.com/appengine/docs/standard/java11
- **Quickstart Tutorial**: https://cloud.google.com/appengine/docs/standard/java11/quickstart
- **Stack Overflow**: Tag questions with `google-app-engine` and `java`

### Common Issues
- Check logs: `gcloud app logs tail`
- Verify project: `gcloud config get-value project`
- Check billing: https://console.cloud.google.com/billing
- View dashboard: `gcloud app open-console`

---

## Success!

🎉 **Congratulations!** Your RealDawgs real estate platform is now live on Google App Engine!

Share your URL with friends and start showcasing properties in Athens.

**Your Application URL:**
```
https://YOUR-PROJECT-ID.appspot.com
```

---

**Ready to deploy?** Start with Step 1 and you'll be live in 30 minutes!
