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

FROM ubuntu:22.04
WORKDIR /app

RUN apt-get update && apt-get install -y \
    libgmp-dev libssl-dev libz-dev \
    && rm -rf /var/lib/apt/lists/*

COPY application .
RUN chmod +x ./application

EXPOSE 8080
ENTRYPOINT ["./application"]
