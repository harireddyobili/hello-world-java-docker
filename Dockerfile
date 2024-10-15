# Stage 1: Build the application
FROM maven:3.8.6-openjdk-11 AS build

# Set the working directory
WORKDIR /app

# Copy the pom.xml and install dependencies
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Create the runtime image
FROM registry.access.redhat.com/ubi8/ubi-minimal:8.5

LABEL maintainer="Muhammad Edwin <edwin@redhat.com>"
LABEL BASE_IMAGE="registry.access.redhat.com/ubi8/ubi-minimal:8.5"
LABEL JAVA_VERSION="11"

# Install Java
RUN microdnf install --nodocs java-11-openjdk-headless && \
    microdnf clean all && \
    rm -rf /var/cache/yum

# Set the working directory
WORKDIR /work/

# Copy the JAR file from the build stage
COPY --from=build /app/target/*.jar /work/application.jar

# Expose the application port
EXPOSE 8080

# Optional health check
HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD curl -f http://localhost:8080/ || exit 1

# Command to run the application
CMD ["java", "-jar", "application.jar"]
