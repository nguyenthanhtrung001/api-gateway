# ========================
# 1. Build stage
# ========================
FROM maven:3.9.4-eclipse-temurin-17 AS build
WORKDIR /app

# Copy toàn bộ mã nguồn vào container
COPY . .

# Build project, bỏ qua test
RUN mvn clean package -DskipTests

# Kiểm tra file WAR
RUN ls -la /app/target

# ========================
# 2. Run stage
# ========================
FROM eclipse-temurin:17-jdk-jammy
WORKDIR /app

# Copy file WAR từ build stage
COPY --from=build /app/target/api-gateway-0.0.1-SNAPSHOT.war api-gateway.war

# Mở cổng
EXPOSE 8080

# Khởi chạy ứng dụng
ENTRYPOINT ["java", "-jar", "api-gateway.war"]