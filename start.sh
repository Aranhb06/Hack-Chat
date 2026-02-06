# Configuracion del usuario root
echo "root:$root_password" | chpasswd

# Configuracion del usuario singup (inicio)
if [ $unlock_singup = "true" ]; then
  passwd -u signup
fi

# Lanzamiento de los servicios
/usr/sbin/sshd     # Lanza SSH en segundo plano
tor -f /etc/tor/torrc # Lanza Tor en primer plano
