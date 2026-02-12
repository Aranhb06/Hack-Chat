#!/bin/bash

# Forzar compatibilidad
export TERM=xterm-256color

# FUNCION MOSTRAR LAS OPCIONES DEL MENU
menu() {
  clear
  printf '\033[1;38;2;229;192;123m
  ┌──> MENU <─> MODO:ADMINISTRADOR <──┐
  │ 1) Crear usuario                  │
  │ 2) Eliminar usuario               │
  │ 3) Mostrar usuarios               │
  │ 4) Habilitar usuarios signup      │
  │ 5) Entrar en la shell             │
  │ 0) Salir                          │
  └───────────────────────────────────┘\033[0m\n'
}

# FUNCION MOSTRAR USUARIOS DEL GRUPO CHAT 
mostrar_usuario() {
  clear

  # Ancho total
  local ancho=35

  # Obtener los ususarios del grupo chat y formatear la salida
  USUARIOS=$(grep "^chat:" /etc/group | cut -d: -f4 | tr ',' '\n')

  # Muestro los usuarios con el formato correspondiente y encerrado en el marco
  echo ""
  printf "\033[1;38;2;86;182;194m  ┌──────> USUARIOS REGISTRADOS <─────┐\n"

  # Condicional usuarios registrados o no hay usuarios
  # > Si no hay mensaje de error
  if [ -z "$USUARIOS" ]; then
    printf "  │\033[38;2;224;108;117m %-33s\033[0m\033[1;38;2;86;182;194m │\n" " [!] No hay registrados "

  # Si hay se muestra los usuarios formateados
  else
    # Enumerar y formatear cada línea
    echo "$USUARIOS" | nl -w2 -s') ' | while read -r linea; do
    # Ajustar el texto a la izquierda dentro de los bordes
    printf "  │ %-33s │\n" "$linea"
  done
  fi
  printf "  └────> Escriba exit para salir <────┘\033[0m\n"
}

# FUNCION CREAR USUARIOS
crear_usuario() {
  read -e -p "   Nombre del nuevo usuario: " NUEVO_USER

  # Si escribes exit sales
  if [ $NUEVO_USER = "exit" ]; then
    continue 

  # Siguiente paso para la creacion de usuarios
  else
    read -s -p "   Contraseña para $NUEVO_USER: " NUEVA_PASS
    echo ""
    read -s -p "   Confirmar contraseña: " CONFIRM_PASS
    echo ""

    # Si la contraseña no es la misma mensaje de error
    if [ "$NUEVA_PASS" != "$CONFIRM_PASS" ]; then
      printf "\033[38;2;224;108;117m   [!] La contraseña no es la misma\033[0m\n"
      sleep 2
      continue 

    # Siguiente paso para la creacion de usuarios
    else

      # Si ya existe el usuario mensaje el usuario de error
      if id "$NUEVO_USER" >/dev/null 2>&1; then
        printf "\033[38;2;224;108;117m   [!] Error: El usuario '$NUEVO_USER' ya existe.\033[0m\n"
        sleep 2

      # Creamos el usuario
      else
        sudo adduser -D -G chat "$NUEVO_USER" > /dev/null 2>&1
        echo "$NUEVO_USER:$NUEVA_PASS" | sudo chpasswd > /dev/null 2>&1
        printf "\033[38;2;152;195;121m   Usuario $NUEVO_USER creado con éxito.\033[0m\n"
        sleep 2
      fi
    fi
  fi
}

# FUNCION ELIMINAR USUARIOS
eliminar_usuario() {
  read -p "   Nombre del usuario a eliminar: " USER_DEL

  # Si escribes exit sales
  if [ $USER_DEL = "exit" ]; then
    continue 

  # Seguimos con la eliminacion del ususario
  else
    # Si el ususario existe lo borramos
    if id "$USER_DEL" > /dev/null 2>&1; then
      deluser "$USER_DEL" > /dev/null 2>&1
      printf "\033[38;2;152;195;121m   Usuario $USER_DEL eliminado con éxito.\033[0m\n"
      sleep 1

    # Si no existe mensaje de error
    else
      printf "\033[38;2;224;108;117m   [!] El usuario $USER_DEL no existe.\033[0m\n"
      sleep 1
    fi
  fi
}

# FUNCION ACTIVAR EL USUSARIO SIGNUP
activar_desactivar_singup() {
  clear

  # Obtenemos el estado del usuario {deshabilitado | habilitado}
  signup_status=$(grep "signup" /etc/shadow | cut -d ":" -f2)

  # Cambiamos el estado del usuario singup
  if [ $signup_status = "!" ]; then
    passwd -u signup > /dev/null 2>&1
    echo ""
    printf "\033[38;2;152;195;121m  [🢙] Singup activado\033[0m"
    sleep 1.5
  else
    passwd -l signup > /dev/null 2>&1
    echo ""
    printf "\033[38;2;224;108;117m  [🢛] Singup desactivado\033[0m"
    sleep 1.5
  fi 
}

# BUCLE PRINCIPAL DE SESION
while true; do
  menu
  read -p "   Introduce el indice: " menu_seleccion
  case "$menu_seleccion" in
    #Salir del programa
    0)
      break
    ;;

    # Crear ususario
    1)
      mostrar_usuario
      crear_usuario
    ;;

    # Eliminar usuario 
    2)
      mostrar_usuario
      eliminar_usuario
    ;;

    # Mostrar ususario
    3) 
      mostrar_usuario
      read -p "   Presiona enter para salir " 
    ;;

    # Activar el signup
    4) 
      activar_desactivar_singup
    ;;

    # Entrar en bash
    5) 
      bash
    ;;

    # Enseriop has introducido mal un numero
    *)
    ;;
  esac
done

