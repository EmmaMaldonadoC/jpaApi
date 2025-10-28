# syntax=docker/dockerfile:1

############################################
# 1) Etapa de build (compila con Maven 17)
############################################
FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /app

# Copiamos solo lo mínimo para cachear dependencias
COPY .mvn/ .mvn
COPY mvnw pom.xml ./
# En Windows a veces mvnw pierde permisos
RUN chmod +x mvnw

# Descarga dependencias a cache
RUN ./mvnw -q -DskipTests dependency:go-offline

# Ahora sí copiamos el código fuente y compilamos
COPY src ./src
RUN ./mvnw -q -DskipTests package

############################################
# 2) Etapa runtime (JRE ligero)
############################################
FROM eclipse-temurin:17-jre
WORKDIR /app

# Copiamos el JAR construido (agarra el único .jar del target)
COPY --from=build /app/target/*.jar /app/app.jar

# Render expone un puerto en $PORT; Spring lo usará
ENV PORT=10000
EXPOSE 10000

# Forzamos el puerto que da Render
CMD ["sh", "-c", "java -Dserver.port=${PORT} -jar /app/app.jar"]