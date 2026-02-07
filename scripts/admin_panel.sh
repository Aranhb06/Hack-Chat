#!/bin/sh

# Forzar compatibilidad
export TERM=xterm-256color

menu() {
  clear
  echo "--- MODO: ADMINISTRADOR - MENU ----"
  echo "0) Salir" 
  echo "1) Crear usuario"
  echo "2) Eliminar usuario"
  echo "3) Mostrar usuario"
  echo "4) Habilitar / Des habilitar singup"
  echo "5) Ir a la terminal root"
  echo "-----------------------------------"
}

mostrar_usuario() {
  clear
  echo "<-- USUARIOS REGISTRADOS -->"

  USUARIOS=$(grep "^chat:" /etc/group | cut -d: -f4 | tr ',' '\n')

  if [ -z "$USUARIOS" ]; then
    echo " [!] No hay usuarios registrados todavía."
  else
    # Enumerar la lista para que quede más elegante
    echo "$USUARIOS" | nl -w2 -s') '
  fi
  echo "----------------------------"
  echo ""

}

crear_usuario() {
    echo "--- CREAR NUEVO USUARIO ---"
    read -p "Nombre del usuario: " NUEVO_USER
    read -p "Contraseña: " NUEVA_PASS

    # Comprobamos si el usuario ya existe en el sistema
    if id "$NUEVO_USER" >/dev/null 2>&1; then
        echo "Error: El usuario '$NUEVO_USER' ya existe."
        sleep 2
    else
        # Si no existe, procedemos con la creación
        # -D (sin password inicial), -G (grupo chat_users)
        adduser -D -G chat "$NUEVO_USER"
        
        # Aplicamos la contraseña de forma segura
        echo "$NUEVO_USER:$NUEVA_PASS" | chpasswd
        
        echo "Usuario $NUEVO_USER creado y añadido a chat_users."
        sleep 1
    fi
}


eliminar_usuario() {
  read -p "Introduce el nombre del usuario a eliminar: " USER_DEL

  # Comprobamos si el usuario existe antes de intentar borrar
  if id "$USER_DEL" >/dev/null 2>&1; then
    deluser "$USER_DEL"
    echo "Usuario $USER_DEL eliminado con éxito."
    sleep 1
  else
    echo "El usuario $USER_DEL no existe."
    sleep 1
  fi
}

activar_desactivar_singup() {
  clear
  signup_status=$(grep "signup" /etc/shadow | cut -d ":" -f2)

  # Cambiamos el estado del usuario singup
  if [ $signup_status = "!" ]; then
    passwd -u signup
    echo "Singup activado"
    sleep 1
  else
    passwd -l signup
    echo "Singup desactivado"
    sleep 1
  fi 
}

# Bucle principal de sesion
while true; do
  menu
  read -p "Introduce el indice: " menu_seleccion
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
      read -p "Presiona enter para salir " 
    ;;

    4) 
      activar_desactivar_singup
    ;;

    5) 
      sh
    ;;

    *)
    ;;
  esac
done

