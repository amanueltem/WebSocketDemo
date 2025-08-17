# -------- Build stage --------
FROM maven:3.9.6-eclipse-temurin-17-alpine AS build

# Set work directory
WORKDIR /app

# Copy pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source code
COPY src ./src

# Build the application (skip tests for faster build)
RUN mvn clean package -DskipTests

# -------- Runtime stage --------
FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

# Copy only the final JAR from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose Spring Boot default port
EXPOSE 8080

# Run the app with memory limits
CMD ["java", "-Xms64m", "-Xmx128m", "-jar", "app.jar"]

