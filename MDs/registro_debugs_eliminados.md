# Registro de Archivos de Debug Eliminados

Este documento registra los archivos de debug temporal que se utilizaban para desarrollo y pruebas de la migración que fueron eliminados del código fuente en la versión 1.27.

---

## 1. `debug_config.log`

*   **Ubicación original en código:** [`UEquipo.pas`](file:///c:/Users/hotma/Desktop/Lázarus/Documento%20de%20Carlos%20De%20Marziani/Mercury%201.27/UEquipo.pas) en la función `TEquipo.CargarEquipo`.
*   **Propósito original:** Monitorear y registrar la lectura de la configuración guardada del equipo (específicamente del archivo `.ini` en la carpeta `Equipos/`). Volcaba información sobre si el canal 8 (Digital 0) estaba habilitado, su descripción y unidad correspondientes para validar que la lectura fuera correcta y persistente tras reiniciar la aplicación.

## 2. `debug_funcion_configuracion.txt`

*   **Ubicación original en código:** [`Uprincipal.pas`](file:///c:/Users/hotma/Desktop/Lázarus/Documento%20de%20Carlos%20De%20Marziani/Mercury%201.27/Uprincipal.pas) en el evento `TFprincipal.tsConfiguracionShow`.
*   **Propósito original:** Rastrear el flujo de inicialización visual de la pestaña de configuración de canales. Volcaba los bloques detectados, índices lógicos de los canales que se cargaban dinámicamente y la vinculación a los labels de la interfaz gráfica (`LConfigXX` y `LDescConfigXX`), permitiendo verificar que la UI correspondiera al mapeo real de sensores y canales asignados.

## 3. `debug_actualizarinfo.txt`

*   **Ubicación original en código:** [`Uprincipal.pas`](file:///c:/Users/hotma/Desktop/Lázarus/Documento%20de%20Carlos%20De%20Marziani/Mercury%201.27/Uprincipal.pas) en la actualización periódica de información del equipo.
*   **Propósito original:** Registrar las tramas y datos recibidos durante los ciclos de refresco automáticos del equipo conectado para analizar el estado de los hilos de comunicación.
*   **Estado:** El código que lo generaba ya había sido comentado (desactivado) en versiones previas de la migración. En esta versión se eliminaron definitivamente las variables residuales asociadas.

## 4. `debug_mercury.txt` y `debug_digital.txt`

*   **Ubicación original en código:** Generados en versiones anteriores del sistema (probablemente durante el desarrollo en Delphi).
*   **Propósito original:** Volcados generales de información del estado del programa y de la lectura de los canales digitales, respectivamente.
*   **Estado:** El código que los generaba ya no existe en el proyecto fuente actual en Lazarus. Estos archivos pueden seguir existiendo en el disco rígido de instalaciones antiguas, pero han sido agregados al `.gitignore` para prevenir que se sigan subiendo al repositorio si algún remanente de código los generara.

---

## Razones de la eliminación

1.  **Limpieza de Consola y Disco:** Estos archivos se escribían constantemente en la carpeta de ejecución de la aplicación, consumiendo E/S de disco innecesaria.
2.  **Preparación para Producción:** Al distribuir la carpeta `lib/x86_64-win64` de manera directa para los usuarios finales, evitamos la acumulación de archivos `.log` y `.txt` ajenos a la operación normal del software.
