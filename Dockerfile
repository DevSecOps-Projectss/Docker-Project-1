# syntax=docker/dockerfile:1

# =========================================================
# Stage 1: Build
# =========================================================
FROM maven:3.9.11-eclipse-temurin-21 AS build

WORKDIR /workspace

# Copy dependency descriptor first for better layer caching
COPY pom.xml .

# Download Maven dependencies and reuse Maven cache
RUN --mount=type=cache,target=/root/.m2 \
    mvn -B -DskipTests dependency:go-offline

# Copy application source code
COPY src ./src

# Compile, test and package application
RUN --mount=type=cache,target=/root/.m2 \
    mvn -B clean package


# =========================================================
# Stage 2: Runtime
# =========================================================
FROM eclipse-temurin:21-jre-noble AS runtime

WORKDIR /app

# Create dedicated non-root user
RUN groupadd --gid 10001 appgroup \
    && useradd \
       --uid 10001 \
       --gid appgroup \
       --create-home \
       --shell /usr/sbin/nologin \
       appuser \
    && mkdir -p /app/data \
    && chown -R appuser:appgroup /app

# Copy only the executable JAR from build stage
COPY --from=build \
    --chown=appuser:appgroup \
    /workspace/target/devops-shack-projectops.jar \
    /app/app.jar

# Run application as non-root
USER appuser:appgroup

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
