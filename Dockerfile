# Step 1: Use a lightweight JDK image for building
FROM eclipse-temurin:17-jdk AS build

WORKDIR /app

# Copy Gradle wrapper and project files
COPY gradlew gradlew
COPY gradle gradle
COPY build.gradle settings.gradle ./
COPY src src

# Make Gradle wrapper executable
RUN chmod +x gradlew

# Build the Spring Boot jar
RUN ./gradlew clean bootJar --no-daemon

# Step 2: Create a smaller runtime image
FROM eclipse-temurin:17-jre

WORKDIR /app

# Copy the built jar from the build stage
COPY --from=build /app/build/libs/*.jar app.jar

# Expose the port your app uses
EXPOSE 10000

# Run the Spring Boot app
ENTRYPOINT ["java","-jar","app.jar"]

