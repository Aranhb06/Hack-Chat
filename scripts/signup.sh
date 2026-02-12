#!/bin/bash

# Forzar compatibilidad
export TERM=xterm-256color

# BUCLE PRINCIPAL DEL PROGRAMA
while true; do
    printf '\033[1;38;2;198;120;221m
  ╔════> SIGNUP: GESTION DE USUARIOS <═══╗
  ║             Bienvenido               ║
  ║  Para crear un usuario rellene los   ║
  ║   campos luego acceda a este mismo   ║
  ║ .onion con la cuenta para participar ║
  ║              en el chat              ║
  ╚══════════════════════════════════════╝\n'

    printf "      ⌦ Escriba exit para salir ⌫\033[0m\n"

    read -e -p "   Nombre del nuevo usuario: " NUEVO_USER


    # Si se escribe exit se sale
    if [ $NUEVO_USER = "exit" ]; then
       exit 
    fi

    read -s -p "   Contraseña para $NUEVO_USER: " NUEVA_PASS
    echo ""
    read -s -p "   Confirmar contraseña: " CONFIRM_PASS
    echo ""

    # Si la contraseña no es la misma mensaje de error
    if [ "$NUEVA_PASS" != "$CONFIRM_PASS" ]; then
        printf "\033[38;2;224;108;117m   [!] La contraseña no es la misma\033[0m\n"
        sleep 2

    # Seguimos con la creacion de usuario
    else

        # Si el usuario ya existe mensaje de error
        if id "$NUEVO_USER" >/dev/null 2>&1; then
            printf "\033[38;2;224;108;117m  [!] Error: El usuario '$NUEVO_USER' ya existe.\033[0m\n"
            sleep 2
            
        # Finalizamos la creacion de usuario
        else
            sudo adduser -D -G chat "$NUEVO_USER" > /dev/null 2>&1
            echo "$NUEVO_USER:$NUEVA_PASS" | sudo chpasswd > /dev/null 2>&1
            printf "\033[38;2;152;195;121m   Usuario $NUEVO_USER creado con éxito.\033[0m\n"
            sleep 2
            exit 
        fi
    fi
done
