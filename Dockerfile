# Usar como base una imagen de Debian con Java 8 preinstalado
FROM openjdk:8-jre-slim

# El puerto de EXPOSE es meramente informativo
# (no expone realmente)
EXPOSE 9090

# Definir un argumento local
ARG WAR=target/portal-aquarella-*.war

# Copiar DESDE el directorio actual (pwd, NO el del contenedor)
# HACIA /app EN el contenedor
ADD ${WAR} /app/app.war

# Crear un punto de entrada para la ejecución del contenedor
ENTRYPOINT ["java","-jar","/app/app.war"]
