FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY target/lens-migration-backend-*.jar app.jar
EXPOSE 8061
ENTRYPOINT ["java", "-jar", "app.jar"]

