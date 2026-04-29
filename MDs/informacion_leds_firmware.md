# Información de LEDs del Firmware Autónomo 1.5

El dispositivo cuenta con 5 indicadores LED principales (declarados dentro de los archivos de la carpeta `/lib`), cada uno asociado a un Pin específico del microcontrolador. Sus comportamientos están programados para informar visualmente el estado de las diferentes rutinas del sistema.

## LEDs de Parpadeo Constante

*   **Pin 15 (Actividad del Sistema)**
    *   **Ubicación en código:** `emac.py`
    *   **Comportamiento:** Parpadea muy rápido (1 pulso cada 1 segundo).
    *   **Función:** Indica que el procesador no está colgado y se encuentra ejecutando el ciclo principal de la máquina de estados correctamente.
*   **Pin 14 (Baliza / Beacon)**
    *   **Ubicación en código:** `emac.py` / `main.py`
    *   **Comportamiento:** Emite un pulso corto (250 ms) cada 3 segundos.
    *   **Función:** Tarea asíncrona en segundo plano que sirve puramente como "baliza" visual intermitente.

## LEDs de Activación Temporal (Fijos)

*   **Pin 6 (Alimentación de Sensores)**
    *   **Ubicación en código:** `emac.py` (función `power_sensors`)
    *   **Comportamiento:** Queda encendido de forma fija por aproximadamente **30 segundos** justo antes de realizar una medición de datos. Si el sistema necesita buscar satélites GPS, puede quedar encendido hasta 10 minutos.
    *   **Función:** Encender y proveer energía de manera anticipada a los sensores externos para darles tiempo a estabilizarse antes de tomar las muestras.
*   **Pin 7 (Alimentación de Conectividad / Módem)**
    *   **Ubicación en código:** `emac.py` (función `power_connectivity`)
    *   **Comportamiento:** Se enciende fijo por un mínimo de **aprox. 70 segundos** (un poco más de 1 minuto) durante el ciclo programado de transmisión de datos.
    *   **Función:** Encender físicamente el módem o módulo de comunicación y mantenerlo energizado mientras dura la negociación de red, tiempos de espera programados y el envío del payload al servidor.

## LED de Estado Lógico de Red

*   **Pin 3 (Status de Conexión)**
    *   **Ubicación en código:** `comunication.py` (`led_connectivity`)
    *   **Comportamiento:**
        *   **Módem:** Se enciende fijo acompañando al Pin 7 mientras la conexión esté en proceso.
        *   **Wi-Fi:** Parpadea rápidamente mientras intenta engancharse a la red, y queda fijo encendido una vez conectado o a la escucha de peticiones del servidor.
    *   **Función:** Avisar el estado lógico en el que se encuentra la transferencia de datos.
