# Multi-stage build for OTP NEXT backend

# ============================================================================
# Stage 1: Build (Maven + JDK 17)
# ============================================================================
FROM maven:3.9-eclipse-temurin-17 AS build

WORKDIR /build

# Cache dependencies layer
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Build
COPY src ./src
RUN mvn clean package -DskipTests -B

# ============================================================================
# Stage 2: Runtime (JRE 17 slim)
# ============================================================================
FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

# JVM heap 768m (per SESSION_SNAPSHOT: -Xmx768m)
ENV JAVA_OPTS="-Xmx768m -XX:+UseG1GC -XX:+ExitOnOutOfMemoryError"

# Non-root user for security
RUN useradd -r -u 1000 -m otpnext
USER otpnext

COPY --from=build --chown=otpnext:otpnext /build/target/*.jar app.jar

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=10s --start-period=90s --retries=3 \
    CMD wget -q --spider http://localhost:3000/actuator/health || exit 1

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
