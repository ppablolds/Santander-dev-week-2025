# Etapa de construção (build)
FROM gradle:7.5.0-jdk17 AS build
WORKDIR /app
COPY . .
RUN gradle build --no-daemon

# Etapa de execução
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=build /app/build/libs/*.jar app.jar

# Definir a variável de ambiente para a porta usada pelo Render
ENV PORT=8080
EXPOSE 8080

# Comando para iniciar a aplicação
CMD ["java", "-jar", "app.jar"]
