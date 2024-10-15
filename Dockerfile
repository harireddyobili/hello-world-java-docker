FROM registry.access.redhat.com/ubi8/ubi-minimal:8.5

LABEL maintainer="Muhammad Edwin <edwin@redhat.com>"
LABEL BASE_IMAGE="registry.access.redhat.com/ubi8/ubi-minimal:8.5"
LABEL JAVA_VERSION="11"

RUN microdnf install --nodocs java-11-openjdk-headless && \
    microdnf clean all && \
    rm -rf /var/cache/yum

WORKDIR /work/
COPY target/*.jar /work/application.jar

EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD curl -f http://localhost:8080/ || exit 1

CMD ["java", "-jar", "application.jar"]
