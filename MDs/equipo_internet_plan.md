# Plan de Acción: Refactorización Arquitectónica del Sistema Mercury

## Objetivo General
Lograr el correcto funcinoamiento de la funcionalidad de comunicación mediante Internet.  Luego, eliminar la duplicación de código existente entre el manejo de equipos locales (`UEquipo.pas` / `PuertoSerie.pas`) y equipos remotos (`UEquipoInternet.pas`).
Actualmente, el parseo del protocolo de comunicación, la lectura/escritura de configuraciones y el manejo de archivos (INI y descargas) se encuentran clonados en distintos archivos.

El enfoque es separar responsabilidades: **Transporte** (Serial/Modem vs TCP/IP), **Protocolo** (Codificación/Decodificación de tramas CE, LD, DG) y **Dominio** (Estructura del equipo, cálculo de parámetros, persistencia).

---
## 1. Actualización de librerías para el socket (Synapse)

### A. ¿Cuáles son los controles específicos que NO andan?

El problema fue cómo Borland (la empresa que creó el Delphi viejo) decidió diseñar los Sockets en los años 90. Borland creó una librería llamada ScktComp (Socket Components) que era un envoltorio (wrapper) directo de la librería Winsock.dll de Windows.

A diferencia del hilo de Windows y Linux que es genérico, los Sockets de Borland estaban atados directamente al motor gráfico de Windows (la VCL) para recibir notificaciones. Lazarus, al ser un entorno multiplataforma gratuito (no puede depender del código privado de Windows/Borland), implementó los sockets de manera diferente y eliminó los componentes ScktComp.

Estas son las 5 Clases de Borland que existen en tu código y hacen que no re-compile en Lazarus:

``TServerSocket`` (Usado en ``UServerSocket.pas``)
Era el objeto principal. Tú le decías Port := 40000; Active := True; y él se encargaba de interceptar las conexiones. Pero lo hacía disparando "Mensajes de Ventana de Windows" (Window Messages). Lazarus no soporta esto porque en Linux o Mac esos mensajes no existen.

``TServerClientThread`` (Usado en ``UEquipoInternet.pas``)
Aca está la gran diferencia con la Serie: A tu clase TServEquipoThread el desarrollador original no la hizo heredar del hilo genérico TThread, sino que la hizo heredar de TServerClientThread. Esta era una clase "mágica" de Delphi que ya venía pre-enlazada a la API de Windows y generaba solita un hilo nuevo con cada cliente que se conectaba. Al no existir esta clase "padre" en Lazarus, tu clase no tiene de quién heredar.

``TCustomWinSocket`` y ``TServerClientWinSocket``
Eran unos punteros puros al Handle (identificador numérico) de conexión que te entregaba Windows para un cliente específico. Las funciones automáticas OnAccept o OnDisconnect de Borland pasaban este tipo de variable nativa y Lazarus lo rechaza.

``TWinSocketStream``
Las lecturas y escrituras en internet pueden "congelarse" si se corta la red. Para evitar esto, Borland creó este Stream de Windows que te permitía poner una variable "TimeOut" (tiempo máximo de espera). En tu código, si el cliente remoto no mandaba nada en X milisegundos, esta clase abortaba automáticamente.

**Ninguna de estas clases existe en la FCL (Free Component Library) estándar de Lazarus para uso directo.**

### B. Opción Principal: Synapse
Synapse es una biblioteca de red sincrónica y bloqueante puramente escrita en código Pascal (no requiere instalar componentes visuales en la paleta).

+ **¿Por qué Synapse?** El código actual de Internet (``UEquipoInternet.pas``) está fuertemente diseñado alrededor del concepto de "Hilos" (Threads) con lecturas bloqueantes y TimeOuts (TWinSocketStream). Synapse brilla en esto.
+ **¿Cómo se implementaría?** Reemplazás heredar de TServerClientThread por un TThread estándar de Lazarus, y usás el objeto TTCPBlockSocket de Synapse dentro del hilo para hacer tus RecvBuffer y SendString.

### C. Otras opciones

**Opción 2: LNet (Lazarus Node Elements)**

LNet es un paquete de componentes visuales muy ligero, rápido y asincrónico proveído casi por defecto instalando con el gestor de paquetes de Lazarus.
+ Por qué sirve: Tiene componentes como TLTCPComponent que actúa casi idéntico al viejo TServerSocket de Delphi, basado en eventos (OnAccept, OnReceive, OnDisconnect).
+ Contras: Como tu lógica actual depende de "Dormir" un hilo esperando datos (Thread), adaptarlo a LNet (que es puramente basado en eventos asincrónicos sin trabar el hilo principal) requerirá reescribir un poco el flujo de tu ClientExecute.

**Opción 3: Indy (Internet Direct)**

Indy es la biblioteca de red "monstruo" por excelencia en Delphi moderno, y existe una versión para Lazarus.
+ Por qué sirve: Indy tiene TIdTCPServer, que casualmente funciona exactamente como pensó tu código original: Crea un hilo por conexión aislándolo mágicamente. El equivalente es ``TIdContext.Connection.IOHandler.Read...``
+ Contras: Instalar Indy en Lazarus suele ser un dolor de cabeza, es una librería gigante, pesada, y muchas veces tiene bugs o inestabilidad si no se configura bien el paquete en FPC.

---
## 2. Puntos Clave del Diseño Propuesto

### A. Centralización del Protocolo (`UProtocoloMercury.pas`)
Crear una nueva unidad dedicada exclusivamente a traducir secuencias de Bytes (strings/arrays) a datos con sentido para el equipo, y viceversa.
*   **Decodificador (Parser):** Analiza la trama recibida (ej. `CE`), extrae la cantidad de canales (dinámicamente), hora, inicio de muestreo, intervalo, configuración, nombre y memoria, protegiendo desbordamientos.
*   **Codificador (Builder):** Construye la trama que se enviará al equipo (ej. nueva configuración, inicio de muestreo, reset).
*   **Impacto:** Tanto `TThreadComm` (Serial) como `TServEquipoThread` (Internet) solo tendrán que hacer `Protocolo.ParsearTrama(BytesRecibidos)` y actualizar el modelo.

### B. Herencia o Composición en el Modelo del Equipo
Actualmente `UEquipo` y `UEquipoInternet` duplican la información del modelo (arreglos de canales, memorias, configuración, métodos de archivos INI).
*   Se propone crear una clase base (ej. `TEquipoBase` abstracto o común) que maneje:
    *   La lista de `TSensor` (`Canales: array of TSensor`).
    *   Las rutinas paramétricas y matemáticas.
    *   Funciones de inicialización y persistencia (guardar/cargar de INI).
*   Las clases específicas (si existieran) heredarían de esta clase base y solo implementarían la inyección del manejador de conexión correspondiente.

### C. Abstracción del Hilo de Transporte (Transport Layer)
*   **`PuertoSerie.pas` (`TThreadComm`):** Se encarga únicamente de abrir el puerto COM/Modem, leer bytes del buffer RS232 y escribirlos. Los bytes crudos recibidos se los pasa al *ProtocoloCentral*.
*   **`UEquipoInternet.pas` (`TServEquipoThread`):** Se encarga únicamente de escuchar en el socket TCP. Al recibir un bloque de memoria, hace exactamente lo mismo: pasárselo al *ProtocoloCentral*.

---

## 3. Inventario de Bloques de Código Repetidos (Candidatos a Unificación)

El análisis cruzado revela repeticiones literales en las siguientes funciones y unidades:

### Entre `PuertoSerie.pas` y `UEquipoInternet.pas`
Ambos gestionan los hilos (`TThreadComm` y `TServEquipoThread` respectivamente) y duplican la lógica de empaquetado y desempaquetado de la comunicación:
1.  **`LeerConfig`**: Ambos archivos tienen este procedimiento para desarmar la trama que viene tras responder el equipo con `'CE'`. (Acá radica el bug de desbordamiento en Internet).
2.  **`EscribirConfig` / `EscribirConfigInternet` / `EscribirConfigTConect`**: La lógica para convertir horas, generar delays de muestreo y enviar comandos de configuración es idéntica en ambos lados.
3.  **`DescargarLosDatos` / `LeerDatos`**: Envían comandos `'LD'`, esperan `'DG'` y convierten datos binarios a CSV/TXT separados por tabulaciones o comas según la configuración, ensamblando líneas y grabándolas a disco.
4.  **`NumToAbytes` y Matemática Auxiliar**: Convertir números estandarizados de fecha/hora y enteros a arrays de 4 bytes (ej. `NumToAbytes`) para enviar por la trama se repite literalmente en ambas unidades. Otras conversiones binarias lógicas (`shl 8` o `Byte * 256`) se repiten decenas de veces. Se propone modularizar estas pequeñas funciones en un archivo tipo utilerías (`UProtocoloMercury` o `UUtiles`) porque evita reescribirlas y duplicar el riesgo cuando se corrigen detalles sutiles de transformaciones binarias.

### Entre `UEquipo.pas` y `UEquipoInternet.pas`
`UEquipoInternet.pas` mezcla variables del hilo *y* del equipo en una mega-clase (`TServEquipoThread`). 
1.  **Definición de Variables de Estado:** Ambos repiten la lista extensa de variables como `Canales: array of TSensor`, `CalcParam: TCalculoParam`, `Nombre`, `Memoria`, `CantMemory`, `Tmuestreo`, variables de entorno y directorios.
2.  **Gestión de Sensores Adicionales (Calculados):** La lógica de cargar listas de directivas para cálculos (Salinidad, Densidad, Velocidad del sonido, etc.) repite estructuras similares.
3.  **Operaciones sobre Archivos INI:**
    *   **`GuardarEquipo` y `CargarEquipo`**: Tienen variaciones mínimas por el tratamiento de rutas y bloqueos de archivos remotos, pero la esencia de escribir pares Clave-Valor en INI es clonada.
    *   **Lectura de archivos `.sen`**: Ambos iteran leyendo y escribiendo la configuración particular de cada canal del sensor.

---

## 4. Estructura de Módulos Propuesta

```pascal
UProtocoloMercury.pas
---
- BufferTrama: array of byte
- EstructuraConfigRecibida: record
---
ParsearTramaCE(Trama: string; var ConfigRecibida)
  - Recibe el string binario 'CE'.
  - Extrae de forma dinámica y segura Canales, Hora, FechaInicial, Intervalo, Memoria.
  - Verifica desbordamientos y devuelve una estructura de datos verificada.
  
ConstruirTramaConfig(Parametros): string
  - Toma las horas (double), los enteros y el tamaño.
  - LLAMADO A FUNCION: `NumToAbytes` de archivo auxiliar para construir el binario y devolver el string de la trama a enviar.
fin UProtocoloMercury.pas
```

```pascal
TEquipoBase.pas (nueva jerarquía o expansión de UEquipo.pas)
---
- Nombre: string
- Memoria, CantMemory: integer
- Tmuestreo, Hora: double
- Canales: array of TSensor
---
GuardarEquipo(DirINI: string)
  - Abre y gestiona TIniFile y directorios, iterando por Canales[i].GuardarEnArchivo. Guarda toda la config del modelo.
  
CargarEquipo(DirINI: string)
  - Reversa de GuardarEquipo. Carga los `.sen` en la clase base re-instanciando `TSensor`.

ActualizarDesdeConfigRemota(ConfigRecibida)
  - Actualiza el Modelo interno (Canales, Memoria) insertando los datos recibidos valiéndose de la estructura ya procesada por `UProtocoloMercury`.
fin TEquipoBase.pas
```

```pascal
PuertoSerie.pas
---
- PSerie: TBlockSerial
- EquipoAsociado: TEquipoBase
---
ClientExecute()
  - Loop principal infinito interrogando el puerto serie.
  - Lee bytes crudos de los transceptores locales.
  
LeerConfig()
  - Lee trama del puerto serie.
  - LLAMADO A FUNCION: `UProtocoloMercury.ParsearTramaCE`  (para parsear lo remoto)
  - LLAMADO A FUNCION: `EquipoAsociado.ActualizarDesdeConfigRemota` (para actualizar dominio)

EscribirConfig()
  - LLAMADO A FUNCION: `UProtocoloMercury.ConstruirTramaConfig`
  - Envía la trama generada por el puerto serie mediante `PSerie.EscribirAlPuertoSerie`.
fin PuertoSerie.pas
```

```pascal
UEquipoInternet.pas
---
- SockStream: TWinSocketStream
- EquipoAsociado: TEquipoBase
---
ClientExecute()
  - Acepta la conexión remota generada por socket pasivo TCP/IP en Background.
  - Escucha si el equipo en GPRS manda paquetes de datos.
  
LeerConfig()
  - Recibe el buffer HTTP/TCP tras recibir el handshake 'CE'.
  - LLAMADO A FUNCION: `UProtocoloMercury.ParsearTramaCE` (convierte buffer GPRS en datos)
  - LLAMADO A FUNCION: `EquipoAsociado.ActualizarDesdeConfigRemota` (impacta todo en memoria y UI)

EscribirConfig()
  - LLAMADO A FUNCION: `UProtocoloMercury.ConstruirTramaConfig`
  - Transmite el string al cliente remoto GPRS usando el buffer de `SockStream`.
fin UEquipoInternet.pas
```
