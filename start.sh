#!/bin/sh

#Configuracion del usuario root
echo "root:$root_password" | chpasswd

#Lanzamiento de los servicios
/usr/sbin/sshd     # Lanza SSH en segundo plano
tor -f /etc/tor/torrc # Lanza Tor en primer plano
