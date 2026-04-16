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

Como se observó, `UEquipoInternet.pas` funcionaba como **Capa de Red**, **Decodificador de Protocolo**, **Máquina de Estado** y **Sistema de Archivos IO** simultáneamente. 

Actualmente, estos componentes (como el formateo de posiciones lógicas de índices en `CE` de `LeerConfig`) se reportan casi clonados en la comunicación por puerto serie local. El esfuerzo en mover los componentes rotos de Windows hacia paquetes limpios de Synapse debería acompañarse con una extracción del protocolo binario CE/LD hacia una entidad pasiva abstracta, para que tanto Sockets (Internet) como Rs232 (PuertoSerie) solamente pasen `arrays` de bytes ya recibidos y reciban instrucciones listas.

---

## 5. Cambios Realizados (Refactorización — Abril 2026)

La refactorización se realizó en **4 archivos** siguiendo un diseño de 3 capas:

### Capa 1 — Modelo: `TEquipoInternet` hereda de `TEquipo`

**`UEquipoInternet.pas`** ahora declara:

```pascal
TEquipoInternet = class(TEquipo)
  function GuardarEquipo(DirINI: string): boolean; override;
  function CargarEquipo(DirINI: string): boolean; override;
  function BorrarEquipo(DirINI: string): boolean; override;
end;
```

Los overrides adaptan la ruta de archivos a la estructura de internet (`DirINI+Nombre\conf\`) vs. la de cable serie (`DirINI\Nombre\`). Todo el resto del modelo (`Canales[]`, `CalcParam`, `Tmuestreo`, `Memoria`, etc.) es heredado directamente de `TEquipo` — sin duplicación.

### Capa 2 — Protocolo compartido: `PuertoSerie.pas`

Se extrajeron dos funciones puras (sin dependencia de transporte) declaradas en la sección `interface` de `PuertoSerie.pas`:

```pascal
function ParsearTramaCE(const auxStr: string; CantCanales: byte;
                         var Config: TConfigEquipo): boolean;

function ConstruirTramaConfig(T: integer; CantCanales: byte;
                         const ConfigCHs: array of byte;
                         const NombreEquipo: string;
                         DelayCom: integer): string;
```

El record `TConfigEquipo` es la estructura de retorno de `ParsearTramaCE` y contiene todos los campos del frame CE.

**Bug crítico resuelto:** los índices hardcodeados de `LeerConfig` (`i:=21`, `i:=25`, `i:=43`, `i:=50`) fueron eliminados. Ahora el parseo usa `CantCanales` dinámico (`CantCanales * 3 + 20` bytes totales), lo que permite cualquier cantidad de sensores.

`DelayCom` en `ConstruirTramaConfig` permite compensar la latencia de cada transporte:
- Serie/Teléfono: `DelayCom = 0`
- Internet GPRS:  `DelayCom = 1`

### Capa 3 — Transporte: `TServEquipoThread` simplificado

**`TServEquipoThread`** ahora recibe una referencia `Equipo: TEquipoInternet` en su constructor (creada por `UServerSocket`). Ya no declara variables de modelo propias (`Nombre`, `Canales[]`, `Memoria`, etc.) — todo acceso es via `Equipo.Nombre`, `Equipo.Canales[i]`, etc.

Su `LeerConfig` llama a `ParsearTramaCE` y escribe el resultado directamente en `Equipo.*`.
Su `EscribirConfig` llama a `ConstruirTramaConfig` y envía el string resultante por socket de una vez (`'CE' + trama`), en vez de byte a byte como hace la comunicación serie.

Ciclo de vida del hilo:
```
TServerListenerThread acepta conexión
  → crea TEquipoInternet (TEquipo.Crear con TipoCom=2)
  → crea TServEquipoThread pasando el modelo
TServEquipoThread.Execute() procesa la sesión GPRS
TServEquipoThread.Destroy() llama Equipo.Destruir → libera modelo
  (FreeOnTerminate = true: el hilo se libera solo)
```

### `UEquipo.pas` — Opción B para TipoCom=2

Se agregó un bloque de salida anticipada en `TEquipo.Crear`:

```pascal
if TipoCom = 2 then begin
  ThreadComm := nil;
  Exit;          // No crea TThreadComm ni abre puerto serie
end;
```

El destructor y `ActualizarCantidadCanales` fueron protegidos con `Assigned(ThreadComm)` para ser seguros cuando `ThreadComm = nil`.

Los métodos `GuardarEquipo`, `CargarEquipo` y `BorrarEquipo` fueron marcados como `virtual` para permitir el override en `TEquipoInternet`.

### `UServerSocket.pas` — Instanciación dinámica

```pascal
var EqInternet: TEquipoInternet;
EqInternet := TEquipoInternet(TEquipo.Crear(Mercury.NumCanales, 'TCP', 2));

WorkerThread := TServEquipoThread.Create(False, ClientSocketHandle,
    50000, EqInternet, FpTStrings, Mercury.DirDatosInternet);
```

`Mercury.NumCanales` reemplaza el `10` hardcodeado anterior.

### Resultado

| Métrica | Antes | Después |
|---|---|---|
| Líneas `UEquipoInternet.pas` | 1689 | ~680 |
| Canales hardcodeados | Sí (`i:=21`, `i:=50`) | No (dinámico) |
| Herencia de `TEquipo` | No | Sí |
| Protocolo duplicado | Sí (2 copias) | No (1 función compartida) |
| Variables de modelo en el hilo | Sí (duplicadas) | No (via `Equipo.*`) |

---

## 6. Estructura de Directorios en Disco

### 6.1 Raíces de directorio (`UUtiles.pas`)

Cada variable tiene un **valor por defecto** definido en el código, pero se persiste en `Mercury.ini` y se puede cambiar desde la UI:

```pascal
// TMercury.Crear — valores por defecto (usados solo la primera vez, sin Mercury.ini)
DirEquipos       := ExePath + 'Equipos\';   // config de equipos cable/teléfono
DirDatos         := ExePath + 'Datos\';     // datos descargados cable/teléfono
DirDatosInternet := ExePath + 'Datos\';     // ← mismo valor que DirDatos (por defecto)
```

**Ciclo de vida del valor en cada arranque:**

```
1ª vez (sin Mercury.ini)
  TMercury.Crear → DirDatosInternet := ExePath + 'Datos\'   ← default del código

Arranques posteriores
  CargarConfig → lee Mercury.ini → DirDatosInternet := INI['DatosInternet']
                                   (si la clave no existe, usa ExePath+'Datos\' como fallback)

Cuando el usuario cambia el campo en Preferencias → Aceptar
  GuardarConfig → escribe INI['DatosInternet'] := DirDatosInternet
```

> El código solo define el **fallback de la primera vez**. A partir de que `Mercury.ini` existe,
> el valor real viene de ese archivo y se edita desde **Preferencias**.

### 6.2 Árbol real generado

```
lib\x86_64-win64\
│
├── Equipos\                        ← Mercury.DirEquipos
│     └── {NombreEquipo}\
│           ├── conf\
│           │     └── {Nombre}.ini  ← config de canales (guardada por Uprincipal, cable/teléf.)
│           └── datos\              ← siempre vacía (los datos van a Datos\)
│
└── Datos\                          ← Mercury.DirDatos = Mercury.DirDatosInternet (por defecto)
      │
      ├── {fecha}.txt/.csv          ← datos descargados por CABLE o TELÉFONO (TThreadComm)
      │
      └── {NombreEquipo}\           ← subcarpeta creada autónomamente por la conexión INTERNET
            ├── conf\
            │     ├── {Nombre}.ini        ← config de canales (TEquipoInternet.GuardarEquipo)
            │     ├── {Nombre}Conf.ini    ← flags de operación (GuardarNuevaConf)
            │     ├── {Nombre}*.sen       ← archivos de sensores individuales
            │     └── ListaSensores.txt   ← catálogo de sensores disponibles
            └── datos\
                  ├── Canales.txt         ← descrip. y unidades de canales activos (fijo, siempre)
                  ├── {mm-yyyy}.txt       ← datos mensuales  (si PeriodoDescarga=1)
                  ├── {dd-mm-yyyy}.txt    ← datos diarios    (si PeriodoDescarga=0)
                  └── datosDiarios\
                        └── {yyyy-mm-dd}.txt  ← backup diario de datos históricos
```

### 6.3 Por qué la división `Equipos\` vs `Datos\{Nombre}\`

Los dos orígenes de comunicación tienen filosofías distintas:

- **Cable/Teléfono:** la UI principal (`Uprincipal.pas`) está activa y controla la sesión. La config del equipo se guarda en `Equipos\` (donde la UI la lee/escribe), y los datos descargados van directamente a `Datos\`.

- **Internet:** el `TServEquipoThread` es completamente autónomo — nace y muere con cada conexión TCP sin interacción de la UI. Por eso necesita su propia subcarpeta (`Datos\{Nombre}\`) con `conf\` y `datos\` adentro: se autogestiona todo.

### 6.4 Archivos generados en `\datos\` — explicación

| Archivo | Cuándo se genera | Contenido |
|---|---|---|
| `Canales.txt` | Siempre, al inicio de `DescargarLosDatos` | Encabezado con nombre, unidad y descripción de cada canal activo. Sirve como leyenda permanente del equipo |
| `{mm-yyyy}.txt` | `PeriodoDescarga = 1` (mensual) | Una línea por conexión: fecha + valores de todos los canales activos |
| `{dd-mm-yyyy}.txt` | `PeriodoDescarga = 0` (diario) | Igual, agrupado por día en vez de mes |
| `datosDiarios\{fecha}` | Siempre (junto con el archivo principal) | Backup diario del mismo contenido |

El período de descarga (`PeriodoDescarga`) se configura en Preferencias → Internet. El valor `1` (mensual) produce nombres como `04-2026.txt`.

### 6.5 Mejora pendiente

Actualmente `DirDatos` y `DirDatosInternet` tienen el mismo valor por defecto, lo que hace que la subcarpeta del equipo internet aparezca **dentro** de `Datos\` junto con los archivos de cable/teléfono. Esto es funcional pero visualmente confuso.

**La separación se puede hacer desde la UI**, sin tocar el código:

> Preferencias → campo "Directorio Datos Internet" → cambiar a `...\DatosInternet\` → Aceptar

Esto escribe el nuevo valor en `Mercury.ini` y Mercury lo usa en la siguiente conexión. Los datos históricos existentes en `Datos\{Nombre}\` **no se migran automáticamente** — habría que moverlos a mano.

**Si se quisiera cambiar el default en el código** (para instalaciones nuevas) bastaría con:

```pascal
// UUtiles.pas — constructor TMercury.Crear
DirDatosInternet := ExtractFilePath(ParamStr(0)) + 'DatosInternet\';
// (actualmente: mismo valor que DirDatos → 'Datos\')
```

> **No se cambia en producción** porque los centros existentes ya tienen archivos en `Datos\{Nombre}\`
> y cambiar el default en una actualización rompería la lectura de datos históricos en esas instalaciones.
