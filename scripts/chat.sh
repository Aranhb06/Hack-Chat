#!/bin/bash

# Forzar compatibilidad
export TERM=xterm-256color
CHAT_LOG="/var/log/chat/chat.log"

# --- EL REINICIO ---
# Cuando cambie la ventana, matamos al lector y reiniciamos el script
trap "kill \$LECTOR_PID 2>/dev/null; exec \$0" WINCH

# 1. LIMPIEZA Y CÁLCULOS
clear
LINES=$(tput lines)
MSG_HEIGHT=$((LINES - 3))
INPUT_LINE=$((LINES - 1))

# 2. DIBUJAR INTERFAZ
# zona de scroll arriba
printf "\033[1;${MSG_HEIGHT}r"
# línea divisoria (línea fija)
printf "\033[$((LINES - 2));1H\033[36m$(printf '%*s' "$(tput cols)" | tr ' ' '-')\033[0m"

# 3. EL PROCESO LECTOR 
tail -n "$MSG_HEIGHT" -f "$CHAT_LOG" 2>/dev/null | while read -r line; do
    printf "\033[s" # Guarda posición
    printf "\033[${MSG_HEIGHT};1H\n%s" "$line" 
    printf "\033[u" 
done &

# (PID) 
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
    # Cursor en la línea de entrada
    printf "\033[${INPUT_LINE};1H"
    
    # Secuencias del promt
    GREEN=$'\001\e[1;32m\002'
    RESET=$'\001\e[0m\002'
    PRE_PROMPT="${GREEN}[$USER]: ${RESET}"

    # Usamos read -e con el prompt limpio
    if read -e -p "$PRE_PROMPT" msn; then
        
        [ "$msn" = "exit" ] && cleanup
        
        if [ -n "$msn" ]; then
            echo "$(date +%H:%M:%S) [$USER]: $msn" >> "$CHAT_LOG"
            
            # --- TU SOLUCIÓN: REINICIO TOTAL ---
            # Esto limpia la pantalla, recalcula líneas y mata el proceso tail anterior
            kill $LECTOR_PID 2>/dev/null
            exec $0
        fi
    else
        cleanup
    fi
done
