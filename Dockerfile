# WindBot - YGOPro AI Bot
# Compilado con Mono para Linux/Docker

FROM mono:latest

LABEL maintainer="YGO Legacy Team"

WORKDIR /windbot

# Copiar código fuente
COPY . .

# Compilar WindBot
RUN msbuild WindBot.sln /p:Configuration=Release /p:TargetFrameworkVersion=v4.5

# Copiar binarios compilados y cards.cdb
RUN mkdir -p /app && \
    cp -r bin/Release/* /app/ && \
    cp -r Decks /app/Decks && \
    cp -r Dialogs /app/Dialogs && \
    if [ -f cards.cdb ]; then cp cards.cdb /app/; fi

WORKDIR /app

# Variables de entorno para conexión a srvpro
ENV SRVPRO_HOST=srvpro
ENV SRVPRO_PORT=7911

# WindBot espera argumentos en formato KEY=VALUE
# Inicia en modo servidor esperando conexiones de srvpro
CMD ["mono", "WindBot.exe", "ServerMode=true", "ServerPort=2399"]
