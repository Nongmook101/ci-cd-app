FROM eclipse-temurin:17-jdk-alpine

RUN addgroup -S appgroup && adduser -S appuser -G appgroup \
    && mkdir /app && chown -R appuser:appgroup /app

WORKDIR /app

COPY target/*.jar app.jar

USER appuser

ENTRYPOINT ["java", "-jar", "/app/app.jar"]