# Configuracion del usuario root

# Paleta de colores {https://www.color-hex.com/color-palette/1017619 | https://www.color-hex.com/color-palette/1017620}

echo "root:$root_password" | chpasswd

# Configuracion del usuario singup (inicio)
if [ $unlock_singup = "yes" ]; then
  passwd -u signup
fi

# Lanzamiento de los servicios
/usr/sbin/sshd     
tor -f /etc/tor/torrc >/dev/null 2>&1 &

# Mensaje de espera
printf "\033[1mEsperando a que la red Tor se estabilice...\033[0m\n"
sleep 10

# Mensaje de bienvenida
printf "\033[38;2;224;108;117m"
echo '
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
W$@@M!!! .!~~ !!     .:XUW$W!~ `"~:    :
#"~~`.:x%`!!  !H:   !WM$$$$Ti.: .!WUn+!`
:::~:!!`:X~ .: ?H.!u "$$$B$$$!W:U!T$$M~
.~~   :X@!.-~   ?@WTWo("*$$$W$TH$! `
Wi.~!X$?!-~    : ?$$$B$Wu("**$RM!
$R@i.~~ !     :   ~$$$$$B$$en:``
?MXT@Wx.~    :     ~"##*$$$$M~
'

printf '
      SERVIDOR LEVANTADO        
\n'
printf "Link\033[0m \033[38;2;86;182;194m- $(cat /var/lib/tor/other_hidden_service/hostname)\033[0m\n"

# Mantener conexion activa
tail -f /dev/null
