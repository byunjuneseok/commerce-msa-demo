FROM gradle:8.13.0-jdk21 AS build
ARG APP_NAME

COPY --chown=gradle:gradle .. /home/gradle/src
WORKDIR /home/gradle/src

RUN bash -c "gradle build --no-daemon :${APP_NAME}:build -x test --parallel"

FROM amazoncorretto:21
ARG APP_NAME

EXPOSE 8080
COPY --from=build /home/gradle/src /app
RUN bash -c "cp /app/${APP_NAME}/build/libs/*.jar /app.jar"

CMD ["java", "-jar", "/app.jar"]
