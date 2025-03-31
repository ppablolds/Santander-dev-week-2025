# Etapa de construção (build) com Java 21 e Gradle 8.6
FROM gradle:8.6-jdk21 AS build

# Definir diretório de trabalho
WORKDIR /app

# Copiar os arquivos do projeto para o container
COPY . .

# Garantir permissões de execução para o Gradle Wrapper
RUN chmod +x ./gradlew

# Rodar o build com Gradle
RUN ./gradlew clean build --no-daemon --stacktrace

# Etapa de execução
FROM openjdk:21-jdk-slim

# Definir diretório de trabalho
WORKDIR /app

# Copiar o arquivo JAR gerado na fase de build
COPY --from=build /app/build/libs/*.jar app.jar

# Definir a variável de ambiente para a porta usada pelo Render
ENV PORT=8080
EXPOSE 8080

# Comando para rodar a aplicação
CMD ["java", "-jar", "app.jar", "me.dio.BradescoDevWeek2025Application"]
