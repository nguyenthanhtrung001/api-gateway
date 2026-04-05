# ========================
# 1. Build stage
# ========================
FROM maven:3.9.4-eclipse-temurin-17 AS build
WORKDIR /app

# Copy pom trước để cache dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Build project (skip test + chỉ định main class)
RUN mvn clean package \
    -DskipTests \
    -Dspring-boot.main-class=com.devteria.gateway.ApiGatewayApplication \
    -B

# Debug: xem file build ra
RUN ls -la /app/target

# ========================
# 2. Run stage
# ========================
FROM eclipse-temurin:17-jdk-jammy
WORKDIR /app

# Copy file JAR (KHÔNG phải WAR)
COPY --from=build /app/target/api-gateway-0.0.1-SNAPSHOT.jar app.jar

# Port gateway
EXPOSE 8080

# Run app
ENTRYPOINT ["java", "-jar", "app.jar"]