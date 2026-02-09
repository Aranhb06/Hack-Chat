FROM alpine:latest

# Variables de entorno
ENV root_password=admin
ENV unlock_singup=""

# Intalacion de los servicios necesarios
RUN apk update && apk add --no-cache \
  tor~=0.4.8 \
  openssh~=10.2 \
  sudo=1.9.17_p2-r0 \
  bash=5.3.3-r1 \
  ncurses=6.5_p20251123-r0

# Configuracion de tor
COPY ./config_tor/torrc /etc/tor

# Configuracion de ssh
RUN ssh-keygen -A
COPY ./config_sshd/sshd_config /etc/ssh/sshd_config

# Configuracion de usuarios
RUN addgroup chat
RUN adduser -D signup && passwd -d signup && passwd -l signup
RUN echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers && addgroup signup wheel

# Copiando scripts de usuarios
COPY ./scripts/admin_panel.sh /root
RUN chmod +x /root/admin_panel.sh

COPY ./scripts/signup.sh /usr/bin
RUN chmod +x /usr/bin/signup.sh

COPY ./scripts/chat.sh /usr/bin
RUN chmod +x /usr/bin/chat.sh
RUN touch /var/log/chat.log && chmod 666 /var/log/chat.log

# Iniciar el servicio
COPY start.sh /start.sh
RUN chmod +x /start.sh
ENTRYPOINT ["/bin/sh", "/start.sh"]
