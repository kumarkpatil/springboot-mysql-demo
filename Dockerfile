# -------- Stage 1: Build --------
FROM eclipse-temurin:21-jdk-alpine AS build

WORKDIR /app

# Copy only required files first (better caching)
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

# Download dependencies (cached layer)
RUN chmod +x mvnw && ./mvnw -B dependency:go-offline

# Now copy source code
COPY src src

# Build application
RUN ./mvnw -B clean package -DskipTests


# -------- Stage 2: Runtime --------
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Copy only final artifact
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

# Use exec form + memory optimizations
ENTRYPOINT ["java","-XX:+UseContainerSupport","-XX:MaxRAMPercentage=75.0","-jar","app.jar"]