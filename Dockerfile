FROM eclipse-temurin:17-jdk-alpine
RUN addgroup -S appgroup && adduser -S appuser -G appgroup \
    && mkdir /app && chown -R appuser:appgroup /app
WORKDIR /app
COPY app.jar app.jar
USER appuser
ENTRYPOINT ["java","-jar","/app.jar"]

