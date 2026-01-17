#!/bin/bash

# RealDawgs Deployment Script for Google App Engine
# This script automates the deployment process

set -e  # Exit on error

echo "========================================="
echo "  RealDawgs Deployment Script"
echo "========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if gcloud is installed
if ! command -v gcloud &> /dev/null; then
    echo -e "${RED}Error: Google Cloud SDK (gcloud) is not installed${NC}"
    echo "Please install it from: https://cloud.google.com/sdk/docs/install"
    exit 1
fi

echo -e "${GREEN}✓ Google Cloud SDK found${NC}"

# Check if maven is installed
if ! command -v mvn &> /dev/null; then
    echo -e "${RED}Error: Maven is not installed${NC}"
    echo "Please install Maven: sudo apt install maven"
    exit 1
fi

echo -e "${GREEN}✓ Maven found${NC}"
echo ""

# Get current project
CURRENT_PROJECT=$(gcloud config get-value project 2>/dev/null)

if [ -z "$CURRENT_PROJECT" ]; then
    echo -e "${YELLOW}No Google Cloud project is currently set.${NC}"
    echo "Please run: gcloud config set project YOUR-PROJECT-ID"
    exit 1
fi

echo "Current Google Cloud Project: ${GREEN}${CURRENT_PROJECT}${NC}"
echo ""

# Ask for confirmation
read -p "Do you want to deploy to this project? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Deployment cancelled."
    exit 1
fi

echo ""
echo "Step 1: Using Mock DAOs (no database required)"
echo -e "${YELLOW}Note: The app will use in-memory data for this deployment${NC}"
echo ""

# Step 2: Clean and build
echo "Step 2: Building the application..."
mvn clean package

if [ $? -ne 0 ]; then
    echo -e "${RED}Build failed!${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Build successful${NC}"
echo ""

# Step 3: Deploy
echo "Step 3: Deploying to Google App Engine..."
echo -e "${YELLOW}This may take 5-10 minutes...${NC}"
echo ""

mvn appengine:deploy

if [ $? -ne 0 ]; then
    echo -e "${RED}Deployment failed!${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}  Deployment Successful!${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""
echo "Your app is now live at:"
echo -e "${GREEN}https://${CURRENT_PROJECT}.appspot.com${NC}"
echo ""
echo "To view logs:"
echo "  gcloud app logs tail"
echo ""
echo "To open in browser:"
echo "  gcloud app browse"
echo ""
