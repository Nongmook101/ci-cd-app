FROM eclipse-temurin:17-jdk-alpine
RUN addgroup -S appgroup && adduser -S appuser -G appgroup \
    && mkdir /app && chown -R appuser:appgroup /app
WORKDIR /app
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar
USER appuser
ENTRYPOINT ["java","-jar","/app.jar"]
