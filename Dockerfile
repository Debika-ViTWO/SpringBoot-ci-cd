# Build stage
FROM --platform=$BUILDPLATFORM eclipse-temurin:21.0.5_11-jdk@sha256:a20cfa6afdbf57ff2c4de77ae2d0e3725a6349f1936b5ad7c3d1b06f6d1b840a AS builder

WORKDIR /app

# Copy Maven wrapper and config
COPY mvnw .
#COPY .mvn .mvn

# Copy pom and source code
COPY pom.xml .
COPY src ./src

RUN chmod +x mvnw
RUN apt-get update && apt-get install -y maven
RUN mvn -B package -DskipTests

# Runtime stage
FROM eclipse-temurin:21.0.5_11-jre-alpine@sha256:4300bfe1e11f3dfc3e3512f39939f9093cf18d0e581d1ab1ccd0512f32fe33f0

WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]