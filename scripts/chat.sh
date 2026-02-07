#!/bin/sh

# Forzar compatibilidad
export TERM=xterm-256color
CHAT_LOG="/var/log/chat.log"

# --- EL REINICIO ---
# Cuando cambie la ventana, matamos al lector y reiniciamos el script
trap "kill \$LECTOR_PID 2>/dev/null; exec \$0" WINCH

# 1. LIMPIEZA Y CÁLCULOS
clear
LINES=$(tput lines)
MSG_HEIGHT=$((LINES - 3))
INPUT_LINE=$((LINES - 1))

# 2. DIBUJAR INTERFAZ
# Definir zona de scroll arriba
printf "\033[1;${MSG_HEIGHT}r"
# Dibujar línea divisoria (línea fija)
printf "\033[$((LINES - 2));1H\033[36m$(printf '%*s' "$(tput cols)" | tr ' ' '-')\033[0m"

# 3. EL PROCESO LECTOR (Con nombre/PID)
tail -n "$MSG_HEIGHT" -f "$CHAT_LOG" 2>/dev/null | while read -r line; do
    printf "\033[s" # Guarda posición
    printf "\033[${MSG_HEIGHT};1H\n%s" "$line" 
    printf "\033[u" 
done &

# Guardamos el nombre (PID) del proceso que acabamos de lanzar
LECTOR_PID=$!

# 4. GESTIÓN DE SALIDA
cleanup() {
    kill $LECTOR_PID 2>/dev/null
    printf "\033[r"
    clear
    exit 0
}
trap "cleanup" EXIT INT TERM

# 5. BUCLE DE INPUT
while true; do
    printf "\033[${INPUT_LINE};1H\033[K\033[1;32m[%s]: \033[0m" "$USER"
    read -r msn
    
    [ "$msn" = "exit" ] && cleanup
    
    if [ -n "$msn" ]; then
        echo "$(date +%H:%M) [$USER]: $msn" >> "$CHAT_LOG"
    fi
done
