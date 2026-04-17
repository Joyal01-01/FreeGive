# Multi-stage build: Build stage
FROM maven:3.9.4-eclipse-temurin-11 AS builder

WORKDIR /build

# Copy the project files
COPY pom.xml .
COPY src src/
COPY database database/

# Build the WAR file (clean build)
RUN mvn clean package -DskipTests -q

# Runtime stage
FROM tomcat:9.0-jdk11

# Remove the default ROOT application
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the built WAR file to Tomcat
COPY --from=builder /build/target/FreeGive.war /usr/local/tomcat/webapps/ROOT.war

# Expose port 8080
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
