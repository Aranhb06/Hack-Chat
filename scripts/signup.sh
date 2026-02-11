#!/bin/bash

# Forzar compatibilidad
export TERM=xterm-256color

opciones() {
    clear
    echo '
  ┌──> GESTION DE USUARIOS <──┐
  │  Para salir escriba exit  │
  └───────────────────────────┘'
}

while true; do
    opciones
    read -e -p "   Nombre del nuevo usuario: " NUEVO_USER


    if [ $NUEVO_USER = "exit" ]; then
       exit 
    fi

    read -s -p "   Contraseña para $NUEVO_USER: " NUEVA_PASS
    echo ""
    read -s -p "   Confirmar contraseña: " CONFIRM_PASS
    echo ""

    if [ "$NUEVA_PASS" != "$CONFIRM_PASS" ]; then
        echo "   [!] La contraseña no es la misma"
        sleep 2
        continue 
    else
        if id "$NUEVO_USER" >/dev/null 2>&1; then
            echo "  [!] Error: El usuario '$NUEVO_USER' ya existe."
            sleep 2
        else
            sudo adduser -D -G chat "$NUEVO_USER" > /dev/null 2>&1
            echo "$NUEVO_USER:$NUEVA_PASS" | sudo chpasswd > /dev/null 2>&1
            echo "   Usuario $NUEVO_USER creado con éxito."
            sleep 2
        fi
    fi
done
