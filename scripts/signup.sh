
#!/bin/sh

# Forzar compatibilidad
export TERM=xterm-256color

while true; do
    clear
    echo "----- GESTIÓN DE USUARIOS ------"
    echo "¿Quieres crear un nuevo usuario?"
    echo "0) No"
    echo "1) Sí"
    read -p "Opción: " CONFIRMAR

    # Si elige 0 (No), salimos de la función con return (el equivalente a break en funciones)
    if [ "$CONFIRMAR" = "0" ]; then
        echo "Operación cancelada."
        sleep 1
        return 
    fi

    # Si no eligió 1, y escribió cualquier otra cosa que no sea 1, también salimos por seguridad
    if [ "$CONFIRMAR" != "1" ]; then
        echo "Opción no válida."
        sleep 1
        return
    fi

    # --- A partir de aquí empieza tu lógica de creación ---
    echo ""
    read -p "Nombre del nuevo usuario: " NUEVO_USER
    read -p "Contraseña para $NUEVO_USER: " NUEVA_PASS

    # Comprobación de existencia (la que añadimos antes)
    if id "$NUEVO_USER" >/dev/null 2>&1; then
        echo "Error: El usuario '$NUEVO_USER' ya existe."
        sleep 2
    else
        sudo adduser -D -G chat "$NUEVO_USER"
        echo "$NUEVO_USER:$NUEVA_PASS" | sudo chpasswd
        echo "Usuario $NUEVO_USER creado con éxito."
        sleep 1
    fi
done

