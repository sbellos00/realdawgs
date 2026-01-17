FROM tomcat:10-jdk17

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR file
COPY target/realdawgs-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

# Cloud Run uses PORT environment variable
ENV PORT 8080
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
