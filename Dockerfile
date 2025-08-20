# ---- Build Stage ----
FROM ghcr.io/graalvm/native-image-community:17 AS builder
WORKDIR /app

# Copy Gradle files
COPY build.gradle settings.gradle gradlew ./
COPY gradle ./gradle

# Make gradlew executable
RUN chmod +x ./gradlew

# Download dependencies (cache)
RUN ./gradlew dependencies --no-daemon || return 0

# Copy source code
COPY src ./src

# Build native image
RUN ./gradlew nativeCompile --no-daemon

# ---- Run Stage ----
FROM ubuntu:22.04
WORKDIR /app

# Install required libraries for native image
RUN apt-get update && apt-get install -y \
    libgmp-dev \
    libssl-dev \
    libz-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy the native executable from builder
COPY --from=builder /app/build/native/nativeCompile/application .

# Make sure it’s executable
RUN chmod +x ./application

# Expose port (Render expects $PORT)
EXPOSE 8080

# Run the native binary
ENTRYPOINT ["./application"]
