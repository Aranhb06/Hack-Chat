#!/bin/bash

# Forzar compatibilidad
export TERM=xterm-256color

menu() {
  clear
  echo '
  ┌──> MENU <─> MODO:ADMINISTRADOR <──┐
  │ 1) Crear usuario                  │
  │ 2) Eliminar usuario               │
  │ 3) Mostrar usuarios               │
  │ 4) Habilitar usuarios signup      │
  │ 5) Entrar en la shell             │
  │ 0) Salir                          │
  └───────────────────────────────────┘'
}

mostrar_usuario() {
  clear
  
  # Ancho
  local ancho=35

  USUARIOS=$(grep "^chat:" /etc/group | cut -d: -f4 | tr ',' '\n')
  
  echo ""
  echo "  ┌──────> USUARIOS REGISTRADOS <─────┐"
  if [ -z "$USUARIOS" ]; then
    printf "  │ %-33s │\n" " [!] No hay registrados"
  else
    # Enumerar y formatear cada línea
    echo "$USUARIOS" | nl -w2 -s') ' | while read -r linea; do
    # Ajustar el texto a la izquierda dentro de los bordes
    printf "  │ %-33s │\n" "$linea"
  done
  fi
  echo "  └────> Escriba exit para salir <────┘"
}

crear_usuario() {
    read -e -p "   Nombre del nuevo usuario: " NUEVO_USER

    if [ $NUEVO_USER = "exit" ]; then
      continue 
    else
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
          echo "   [!] Error: El usuario '$NUEVO_USER' ya existe."
          sleep 2
        else
          sudo adduser -D -G chat "$NUEVO_USER" > /dev/null 2>&1
          echo "$NUEVO_USER:$NUEVA_PASS" | sudo chpasswd > /dev/null 2>&1
          echo "   Usuario $NUEVO_USER creado con éxito."
          sleep 2
        fi
      fi
    fi
}

eliminar_usuario() {
  read -p "   Nombre del usuario a eliminar: " USER_DEL

  if [ $USER_DEL = "exit" ]; then
    continue 
  else
    # Comprobamos si el usuario existe antes de intentar borrar
    if id "$USER_DEL" > /dev/null 2>&1; then
      deluser "$USER_DEL" > /dev/null 2>&1
      echo "   Usuario $USER_DEL eliminado con éxito."
      sleep 1
    else
      echo "   [!] El usuario $USER_DEL no existe."
      sleep 1
    fi
  fi
}

activar_desactivar_singup() {
  clear
  signup_status=$(grep "signup" /etc/shadow | cut -d ":" -f2)

  # Cambiamos el estado del usuario singup
  if [ $signup_status = "!" ]; then
    passwd -u signup > /dev/null 2>&1
    echo ""
    echo "  [🢙] Singup activado"
    sleep 1.5
  else
    passwd -l signup > /dev/null 2>&1
    echo ""
    echo "  [🢛] Singup desactivado"
    sleep 1.5
  fi 
}

# Bucle principal de sesion
while true; do
  menu
  read -p "   Introduce el indice: " menu_seleccion
  case "$menu_seleccion" in
    0)
      break
    ;;

    1)
      mostrar_usuario
      crear_usuario
    ;;

    2)
      mostrar_usuario
      eliminar_usuario
    ;;

    3) 
      mostrar_usuario
      read -p "   Presiona enter para salir " 
    ;;

    4) 
      activar_desactivar_singup
    ;;

    5) 
      bash
    ;;

    *)
    ;;
  esac
done

