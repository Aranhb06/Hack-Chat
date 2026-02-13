#!/bin/bash

# 1. Configuración de usuarios 
echo "root:$root_password" | chpasswd /dev/null 2>&1

if [ "$unlock_singup" = "yes" ]; then
    passwd -u signup /dev/null 2>&1
fi

# 2. Lanzamiento de servicios
/usr/sbin/sshd
tor -f /etc/tor/torrc > /tmp/tor.log 2>&1 &

# 3. Esperar a que se cree el log para evitar el error de grep
printf "\033[1mIniciando sistemas...\033[0m\n"
while [ ! -f /tmp/tor.log ]; do
    sleep 0.5
done

# 4. Comprobación de circuito Tor
printf "\033[1mEsperando confirmación de circuito...\033[0m\n"
until grep -q "Bootstrapped 100% (done): Done" /tmp/tor.log; do
    printf "\033[38;2;209;154;102m[.] Sincronizando con nodos... \033[0m\r"
    sleep 2
done

# Limpiamos la línea de carga
printf "\n\033[32m[+] Circuito establecido con éxito.\033[0m\n"

# 5. Mensaje de bienvenida
printf "\033[38;2;224;108;117m"
cat << "EOF"
                     :::!~!!!!!:.
                  .xUHWH!! !!?M88WHX:.
                .X*#M@$!!  !X!M$$$$$$WWx:.
               :!!!!!!?H! :!$!$$$$$$$$$$8X:
              !!~  ~:~!! :~!$!#$$$$$$$$$$8X:
             :!~::!H!<   ~.U$X!?R$$$$$$$$MM!
             ~!~!!!!~~ .:XW$$$U!!?$$$$$$RMM!
               !:~~~ .:!M"T#$$$$WX??#MRRMMM!
               ~?WuxiW*`   `"#$$$$8!!!!??!!!
             :X- M$$$$       `"T#$T~!8$WUXU~
            :%`  ~#$$$m:        ~!~ ?$$$$$$
          :!`.-   ~T$$$$8xx.  .xWW- ~""##*"
.....   -~~:<` !    ~?T#$$@@W@*?$$      /`
W$@@M!!! .!~~ !!      .:XUW$W!~ `"~:    :
#"~~`.:x%`!!  !H:    !WM$$$$Ti.: .!WUn+!`
:::~:!!`:X~ .: ?H.!u "$$$B$$$!W:U!T$$M~
.~~   :X@!.-~    ?@WTWo("*$$$W$TH$! `
Wi.~!X$?!-~    : ?$$$B$Wu("**$RM!
$R@i.~~ !     :   ~$$$$$B$$en:``
?MXT@Wx.~     :    ~"##*$$$$M~
EOF

printf '\n      SERVIDOR LEVANTADO       \n\n'
printf "Link -\033[0m \033[4;38;2;86;182;194m$(cat /var/lib/tor/hidden_service/hostname)\033[0m\n"

# 6. Mantener vivo
wait
