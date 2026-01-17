# Stage 1: Build with Maven
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Run with Tomcat 9 (compatible with javax.servlet)
FROM tomcat:9-jdk17

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR file from build stage
COPY --from=build /app/target/realdawgs-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

# Cloud Run uses PORT environment variable
ENV PORT 8080
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
