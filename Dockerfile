# syntax=docker/dockerfile:1

# 1) Build de la app
FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn -q -DskipTests package

# 2) Imagen runtime ligera
FROM eclipse-temurin:17-jre
WORKDIR /app
# copia el jar construido (ajusta el patrón si tu jar no termina en -SNAPSHOT)
COPY --from=build /app/target/*SNAPSHOT.jar app.jar

# Render te asigna un puerto en la var PORT
ENV PORT=10000
EXPOSE 10000
# Forzamos Spring a usar el puerto de Render
CMD ["sh", "-c", "java -Dserver.port=${PORT} -jar app.jar"]