# Funcionamiento de la Comunicación por Internet del Sistema Mercury

El sistema Mercury implementa su comunicación remota (Internet/TCP-IP) delegando cada conexión a un hilo independiente en segundo plano. Esto permite que el servidor atienda a múltiples equipos remotos (generalmente módems GPRS) de forma simultánea sin congelar la interfaz del usuario. 

A continuación se detalla la arquitectura de red, las librerías heredadas (no funcionales en Lazarus) y los procedimientos principales involucrados en el establecimiento, configuración y descarga de datos.

---

## 1. Arquitectura y Librerías No Funcionales

El código actual fue concebido originalmente en un entorno Delphi antiguo utilizando la librería **ScktComp** de Borland. Borland acopló fuertemente esta librería a la API gráfica de Windows (VCL) para la gestión de mensajes, lo que hace que sus clases sean incompatibles y no compilables en Lazarus (cuyo núcleo, la FCL, es multiplataforma).

Las cinco clases principales que paralizan el funcionamiento actual en Lazarus son:
1. **`TServerSocket`** (ubicado en `UServerSocket.pas`): Componente de escucha que intercepta conexiones disparando mensajes de Windows.
2. **`TServerClientThread`** (heredado en `UEquipoInternet.pas`): Hilo mágico de Delphi auto-enlanzado a la API Win32 que se instancia automáticamente cada vez que un cliente se conecta. En Lazarus, no existe una clase nativa de red que mezcle hilos y sockets de esta forma, por lo que `TServEquipoThread` debe refactorizarse para heredar del hilo genérico `TThread`.
3. **`TCustomWinSocket`** y **`TServerClientWinSocket`**: Punteros dependientes de los *Handles* nativos de Windows para referenciar conexiones.
4. **`TWinSocketStream`**: Utilizado dentro del hilo para operaciones bloqueantes con control de TimeOut.

El plan de acción arquitectónico general sugiere reemplazar estas dependencias de Borland por **Synapse** (`TTCPBlockSocket`), una librería implementada puramente en Pascal para operaciones de red sincrónicas.

---

## 2. Flujo de Comunicación (Diagrama de Secuencia)

El siguiente gráfico demuestra el ciclo de vida de un hilo de conexión para un equipo que reporta información a la PC servidora:

```text
  +------------------+         +------------------+         +-------------------+         +-------------------+
  |                  |         |                  |         | UEquipoInternet   |         |    Sistema de     |
  |  Equipo (GPRS)   |         |  UServerSocket   |         | TServEquipoThread |         |     Archivos      |
  |                  |         |                  |         |      (Hilo)       |         |   (INI / TXT)     |
  +--------+---------+         +--------+---------+         +---------+---------+         +---------+---------+
           |                            |                             |                             |
           | 1. Conexión TCP/IP         |                             |                             |
           |===========================>|                             |                             |
           |                            |                             |                             |
           |                            | 2. OnGetThread: Crea Hilo   |                             |
           |                            |---------------------------->|                             |
           |                            |                             |                             |
           |                            |                             | 3. Inicia ClientExecute     |
           |                            |                             |    (Crea Stream)            |
           |                            |                             +<---+                        |
           |                            |                             |                             |
           | 4. Envía cadena "OK"       |                             |                             |
           |<=========================================================|                             |
           |                            |                             |                             |
           | 5. Responde "CE" (Config)  |                             |                             |
           |=========================================================>|                             |
           |                            |                             |                             |
           | 6. Lee Trama "CE" (50+ by) |                             |                             |
           |<=========================================================|                             |
           |                            |                             |                             |
           |                            |                             | 7. Carga .INI / Modelo      |
           |                            |                             |---------------------------->|
           |                            |                             |                             |
           | . . . . . . . . . . . . . . . . . . . . . . . . . . . .  |                             |
           |                        ¿Hay ruptura de transmisión?      |                             |
           |----------------------------------------------------------|                             |
           | [SÍ] 8. Manda comando "LD" |                             |                             |
           |<===========================|                             |                             |
           |                            |                             |                             |
           | 9. Envía DATOS + "DG"      |                             |                             |
           |===========================>|                             |                             |
           |                            |                             | 10. Guarda CSV/TXT          |
           |                            |                             |---------------------------->|
           |----------------------------------------------------------|                             |
           | [NO] 8. Modo Normal        |                             | 9. Guarda Vals Instantáneos |
           |                            |                             |---------------------------->|
           | . . . . . . . . . . . . . . . . . . . . . . . . . . . .  |                             |
           |                            |                             |                             |
           |                            |                             |                             |
           | . . . . . . . . . . . . . . . . . . . . . . . . . . . .  |                             |
           |                        ¿Hay Cambios de Configuración?    |                             |
           |----------------------------------------------------------|                             |
           | [SÍ]                       |                             | 11. Lee Nueva Config .INI   |
           |                            |                             |<----------------------------|
           |                            |                             |                             |
           | 12. Transmite Nuevo "CE"   |                             |                             |
           |<===========================|                             |                             |
           |                            |                             |                             |
           |                        ¿Hay Cambios de Red?              |                             |
           |----------------------------------------------------------|                             |
           | [SÍ] 13. Transmite Comandos AT                           |                             |
           |<===========================|                             |                             |
           | . . . . . . . . . . . . . . . . . . . . . . . . . . . .  |                             |
           |                            |                             |                             |
           |                            |                             |                             |
           | 14. Cierre y Limpieza      |                             |                             |
           |<===========================|                             |                             |
           |                            |                             |                             |
```

---

## 3. Procedimientos Centrales de `UEquipoInternet.pas`

El hilo `TServEquipoThread` contiene la inteligencia principal del protocolo Mercury en internet. Sus procedimientos de control abarcan todo el proceso desde el inicio de la sesión hasta su desvinculación.

### A. `ClientExecute`
Constituye el método **Main** (Bucle principal) del hilo. 
1. Reinstancia un `TWinSocketStream` con el puntero nativo de socket entrante.
2. Comienza el saludo (*Handshake*) enviando `"OK"`.
3. Si el equipo del otro lado responde enviando `"CE"` en dos bytes, comienza cascada de configuración invocando a `ConfigEntorno`, `LeerConfig` y `CargarCanales`.
4. Evalúa variables bandera (`ConfigEquipo`, `DescargarDatos`) para enviar confirmaciones, configuraciones o solicitar la memoria.

### B. `LeerConfig`
Procedimiento que *desempaqueta*, decodifica y asigna el frame principal del equipo remoto. 
1. Lee del buffer del socket los ~50 bytes subsiguientes a la orden `CE`.
2. Parsea numéricamente usando sumas aritméticas y corrimientos (multiplicaciones por 256, 65535).
3. **Estructura posicional importante:**
   - **Índice 1..N:** Los valores directos (estado) de cada canal de los sensores. (2 bytes por canal)
   - **Índice 21:** Hora y Fecha del Equipo (4 bytes en Unix-like epoch que luego se adapta descontando la variable `Hora_Base`).
   - **Índice 25:** Fecha de inicio de muestreo (4 bytes).
   - **Índice 29:** Intervalo/Período de muestreo (2 bytes).
   - **Índice 33:** Un bytemap indicando la configuracion/activación de los diversos canales.
   - **Índice 43:** Nombre del equipo (4 bytes de caracteres).
   - **Índice 47 y 50:** Bytes consumidos de Memoria y capacidad Máxima en el chip del equipo.
4. Incluye funciones sanitizadoras automáticas como la verificación/corrección de caracteres inválidos de red en el nombre del equipo (`ReplaceInvalidCharsName`).

### C. `DescargarLosDatos` y `LeerDatos / GuardarValoresInstantaneos`
Dependiendo del análisis topológico actual de la configuración y lo que indique `RupturaTransmision` (una anomalía entre la cantidad que se estima ocupada vs detectada en la configuración CE), puede tomar dos caminos lógicos:
*   **Camino A (`GuardarValoresInstantaneos`):** Toma los valores presentados en `LeerConfig`, les aplica las escalas y fórmulas pertinentes matemáticas mediante el modelo cargado (`ComputarValor`) y simplemente anexa una nueva línea a la base de datos CSV o Archivo de texto final.
*   **Camino B (`LeerDatos`):** Hace un pedido riguroso y completo al módem a través de comandos como `"LD"` para volcar íntegramente el datalogger binario de nuevo y llenar el hueco de información faltante.

### D. `EscribirConfig` / `EscribirConfigTConect`
Una vez configurado y evaluado, si el servidor reconoce en su sistema de archivos (INI) que existen configuraciones editadas por el operador de Windows, arma la estructura del frame inverso:
1. Pone el tag del header `"CE"`.
2. Convierte todo lo calculado en el servidor (fechas, deltas e intervalos) de las entidades lógicas inversamente iterando rutinas como `NumToAbytes` (convierte variables LongInt a tramas de 4 bytes).
3. Transmite el binario directamente al Socket.
En el caso de `EscribirConfigInternet`, no usa la trama CE, sino que envía inyecciones explícitas de comandos **AT GSM (AT+MIPCALL, AT+MIPOPEN, ATE0, etc.)** para que el módem interno del equipo remoto impacte y rearme su ruteo de red hacia un servidor, un APN del transportista (Gateway) o puertos diferentes.

---

## 4. Notas para la Refactorización

Como se observó, `UEquipoInternet.pas` funciona como **Capa de Red**, **Decodificador de Protocolo**, **Máquina de Estado** y **Sistema de Archivos IO** simultáneamente. 

Actualmente, estos componentes (como el formateo de posiciones lógicas de índices en `CE` de `LeerConfig`) se reportan casi clonados en la comunicación por puerto serie local. El esfuerzo en mover los componentes rotos de Windows hacia paquetes limpios de Synapse debería acompañarse con una extracción del protocolo binario CE/LD hacia una entidad pasiva abstracta, para que tanto Sockets (Internet) como Rs232 (PuertoSerie) solamente pasen `arrays` de bytes ya recibidos y reciban instrucciones listas.
