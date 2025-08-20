# ---- Build Stage ----
FROM gradle:8.9.0-jdk17 AS builder
WORKDIR /app

# Copy Gradle build files
COPY build.gradle settings.gradle gradlew ./
COPY gradle ./gradle

# Download dependencies (caching)
RUN ./gradlew dependencies --no-daemon || return 0

# Copy source code
COPY src ./src

# Build the application
RUN ./gradlew bootJar --no-daemon

# ---- Run Stage ----
FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app

# Copy jar from build stage
COPY --from=builder /app/build/libs/*.jar app.jar

# Expose port (Render expects PORT env variable)
EXPOSE 8080

# Run app
ENTRYPOINT ["java", "-jar", "app.jar"]
