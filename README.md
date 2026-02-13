# Hack-Chat 🧅
> Un chat minimalista, seguro y totalmente anónimo basado en la red Tor y el protocolo SSH.

## 🚀 Funcionamiento
**Hack-Chat** opera bajo la filosofía de "simplicidad como base de la seguridad": a menor complejidad de código, menor superficie de ataque.

* **Infraestructura:** Basado en una imagen minimalista de **Alpine Linux** gestionada por Docker.
* **Conectividad:** Utiliza el protocolo **SSH** sobre la **red Tor** (`.onion`) para garantizar anonimato y cifrado.
* **Backend:** Scripts en **Bash** que gestionan el chat, el registro y la administración mediante la lectura/escritura de archivos locales.
* **Interfaz:** El chat está diseñado para terminal; los mensajes que excedan las 2 líneas podrían quedar ocultos por el scroll del script.

### Gestión de Accesos
Al arrancar el servicio, se generará una dirección `.onion` en los logs del contenedor. Existen dos cuentas iniciales:
1.  **root:** Acceso total al panel de administración (Contraseña por defecto: `admin`).
2.  **signup:** Cuenta sin contraseña para registros anónimos (activable desde el panel o variables de entorno).

---

## 🛠️ Despliegue y Configuración

### 1. Variables de Entorno y Persistencia
| Variable | Descripción |
| :--- | :--- |
| `root_password` | **(Obligatorio)** Contraseña para el usuario administrador. |
| `unlock_singup` | Habilita (`yes`) o deshabilita el registro de nuevos usuarios. |

**Volúmenes recomendados:**
* `hack-chat_config`: Persistencia de usuarios registrados (`/etc`).
* `hack-chat_chat`: Historial del chat (`/var/log/chat.log`).
* `hack-chat_tor`: Mantiene la misma dirección `.onion` (`/var/lib/tor/hidden_service`).

---

### 2. Opciones de Instalación

#### Opción A: Docker Run
```
docker run \
  --name hack-chat-server \
  -e root_password="Tu_Contraseña_Segura" \
  -e unlock_singup=yes \
  -v hack-chat_config:/etc \
  -v hack-chat_chat:/var/log/chat.log \
  -v hack-chat_tor:/var/lib/tor/hidden_service \
  aranhb06/hack-chat:latest
```

#### Opción B: Docker Compose (Recomendado)

Utilizar **Docker Compose** es la forma más eficiente de gestionar el servicio, ya que permite definir volúmenes, redes y variables de entorno en un solo archivo estructurado.

##### 1. Archivo `docker-compose.yml`

Crea un archivo .yalm con este nombre y pega el siguiente contenido:

```
services:
  hack-chat:
    image: aranhb06/hack-chat:latest
    container_name: hack-chat-server
    restart: unless-stopped
    environment:
      # Define la contraseña del administrador
      - root_password=TU_CONTRASEÑA_SEGURA
      # Habilita el registro de usuarios anónimos (predefinido: no)
      - unlock_singup=no
    volumes:
      - hack-chat_config:/etc
      - hack-chat_chat:/var/log/chat.log
      - hack-chat_tor:/var/lib/tor/hidden_service

volumes:
  hack-chat_config:
  hack-chat_chat:
  hack-chat_tor:
```

---

## ⚖️ Licencia

Este proyecto está bajo la licencia **GNU GPLv3**. Esto significa que eres libre de usarlo, estudiarlo y modificarlo, siempre que cualquier derivado mantenga la misma licencia abierta.

Puedes leer el texto completo aquí:  
👉 [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.html)

---
