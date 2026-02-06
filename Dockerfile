FROM alpine:latest

#Intalacion de los servicios necesarios
RUN apk update && apk add --no-cache \
  tor~=0.4.8 \
  openssh~=10.2

#Configuracion de tor
COPY ./config_tor/torrc /etc/tor

#Configuracion de ssh
RUN ssh-keygen -A

#Iniciar el servicio
COPY start.sh /start.sh
RUN chmod +x /start.sh
ENTRYPOINT ["/bin/sh", "/start.sh"]
