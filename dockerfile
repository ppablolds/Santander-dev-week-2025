# Etapa de construção (Build Stage)
FROM gradle:8.6-jdk21 AS build

# Definir diretório de trabalho
WORKDIR /app

# Copiar os arquivos do projeto para o container
COPY . .

# Garantir permissões de execução para o Gradle Wrapper
RUN chmod +x ./gradlew

# Construir o projeto sem usar bootJar
RUN ./gradlew clean build --no-daemon --stacktrace

# Etapa de execução (Runtime Stage)
FROM openjdk:21-jdk-slim

# Definir diretório de trabalho
WORKDIR /app

# Copiar o arquivo JAR gerado na etapa de build
COPY --from=build /app/build/libs/*SNAPSHOT.jar app.jar

# Definir variável de ambiente para a porta usada pelo Render
ENV PORT=8080
EXPOSE 8080

# Comando para rodar a aplicação
CMD ["java", "-jar", "app.jar"]
