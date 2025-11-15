# ============================
# Stage 1: Build the JAR
# ============================
FROM amazoncorretto:11-alpine-jdk AS builder

WORKDIR /app

# Copy source code
COPY . .

# Fix: Ensure mvnw is executable
RUN chmod +x mvnw

# Build the application
RUN ./mvnw clean package -DskipTests

# ============================
# Stage 2: Run the Application
# ============================
FROM amazoncorretto:11-alpine-jdk

WORKDIR /app

# Copy only the final JAR from builder image
COPY --from=builder /app/target/*.jar app.jar

# Expose application port
EXPOSE 8081

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
