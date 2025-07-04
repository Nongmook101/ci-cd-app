FROM eclipse-temurin:17-jdk-alpine
JAR_FILE=target/*.jarCOPY ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]