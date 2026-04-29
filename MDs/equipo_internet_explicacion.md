# Funcionamiento Original de la Comunicación por Internet del Sistema Mercury

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
EqInternet := TEquipoInternet(TEquipo.Crear(10, 'TCP', 2));

WorkerThread := TServEquipoThread.Create(False, ClientSocketHandle,
    50000, EqInternet, FpTStrings, Mercury.DirDatosInternet);
```

El modelo se crea con **10 canales base**. `LeerConfig` detecta la cantidad real desde la trama CE y redimensiona el modelo dinámicamente (ver Sección 7). `Mercury.NumCanales` sigue vigente solo para la comunicación por cable/teléfono.

### Cambios adicionales en `TEquipoInternet.GuardarEquipo`

Antes de escribir al INI, se hace `ArchivoINI.EraseSection(Nombre)` para borrar la sección existente. Sin esto, si la cantidad de canales se redujo (ej: de 30 a 20), los índices `CH20..CH29` del run anterior quedaban persistidos como datos stale y se releían en la siguiente conexión.

### Política de automatización original conservada

La política original de inicialización en Delphi se mantuvo intacta. `DescargarDatos := true` se preserva porque esta variable maneja la **descarga en ambos bloques** (loguea y realiza la descarga instantánea siempre, y efectúa la descarga histórica si ocurre una ruptura de transmisión). 

De manera análoga, se preservó `ConfigEquipo := true` para forzar el bloque de configuración por defecto. Sin embargo, esto no implica peligro: **esta operación por defecto no reconfigura los sensores del módulo.** La función envía de vuelta exactamente los mismos datos de hardware e intervalo de muestreo (`Tmuestreo`) que el equipo acaba de reportar. Su principal utilidad es realizar un cambio de **hora del equipo**, actualizándola para mantenerla sincronizada con el servidor.

*(Nota técnica: Eventualmente, esto se podría modificar/refactorizar para que el código por esquema separe explícitamente estas acciones. Es decir, que siempre descargue la transmisión instantánea y modifique la hora, pero dejando el resto de las descargas y configuraciones como lógicas completamente separadas y condicionales a elección del operador).*

### Resultado

| Métrica | Antes | Después |
|---|---|---|
| Líneas `UEquipoInternet.pas` | 1690 | 1309 |
| Canales hardcodeados | Sí (`i:=21`, `i:=50`) | No (dinámico) |
| Automatización por defecto | `true` absoluto | `true` absoluto (sincroniza hora / descarga instantánea) |
| Herencia de `TEquipo` | No | Sí |
| Protocolo duplicado | Sí (2 copias) | No (1 función compartida) |
| Variables de modelo en el hilo | Sí (duplicadas) | No (via `Equipo.*`) |
| Stale data en INI por reducción de canales | Posible | Prevenido (`EraseSection`) |
| Pérdida de sensores en primera conexión | Posible | Prevenido (respaldo `ConfigsCE[]`) |

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

---

## 7. Sensores Dinámicos por Equipo Internet (Abril 2026)

### 7.1 Problema

El sistema originalmente usaba `Mercury.NumCanales` (valor global del INI, configurable desde el diálogo de Expansión) para crear el modelo de cada equipo internet:

```pascal
// UServerSocket.pas (ANTES)
EqInternet := TEquipoInternet(TEquipo.Crear(Mercury.NumCanales, 'TCP', 2));
```

Esto asumía que todos los equipos tienen la misma cantidad de sensores. En la práctica, cada equipo remoto puede tener una cantidad diferente (10, 20, 30, etc.) y puede cambiar entre conexiones (ampliación o reducción de canales).

La lectura del socket era fija:
```pascal
// LeerConfig (ANTES)
BytesToRead := Equipo.NumCanales * 3 + 20;
LeerDelSocket(auxStr, BytesToRead);
```

Si el equipo real tenía más canales que `Mercury.NumCanales`, los bytes extra quedaban en el buffer TCP. Si tenía menos, la lectura se colgaba esperando bytes que nunca llegaban.

### 7.2 Solución implementada: Autodescubrimiento desde la trama CE

El frame CE tiene un tamaño determinístico: `CantCanales * 3 + 20` bytes. Leyendo **todo** lo disponible en el socket y validando el tamaño, se puede deducir la cantidad de canales sin preguntar.

#### Algoritmo de detección (Enfoque A+D combinado)

```
1. RecvPacket(timeout) → leer todo lo disponible del socket TCP
2. Validación estructural:
   - (len - 20) mod 3 == 0  (largo consistente con protocolo CE)
   - len >= 50              (mínimo: 10 canales × 3 + 20)
   → Si falla: esperar 500ms → segundo RecvPacket → concatenar → revalidar
3. CantCanales = (len - 20) div 3
4. NombreOffset = CantCanales × 3 + 13  (12 bytes fijos + 1 por indexación Pascal)
5. Verificar que en NombreOffset haya ≥ 1 byte imprimible (ASCII 32..126)
   → Esto distingue un nombre real de datos de sensor
6. Si ambas validaciones pasan → trama válida, parsear con CantCanalesReal
```

#### ¿Por qué funciona la doble validación?

- **Validación mod 3:** la trama siempre tiene `N*3 + 20` bytes. Si llegan menos (fragmentación TCP), solo pasa el mod por coincidencia si los bytes faltantes son múltiplo de 3.
- **Validación del nombre:** datos de sensor en la posición del nombre tendrían valores 0-12 (config) o 0-3 (byte alto ADC 10-bit) — ninguno es ASCII imprimible (mínimo 32). Un nombre real, incluso con `BadChrsName`, tiene al menos 1 byte imprimible.

### 7.3 Cambios en archivos

#### `UServerSocket.pas` — Inicialización con cantidad base

```pascal
// DESPUÉS: modelo con 10 canales base, LeerConfig redimensiona al vuelo
EqInternet := TEquipoInternet(TEquipo.Crear(10, 'TCP', 2));
```

`Mercury.NumCanales` sigue vigente para cable/serie (donde la UI controla la cantidad).

#### `UEquipoInternet.pas` — Nuevas funciones

1. **`LeerTodoDelSocket`**: lee todo lo disponible con `RecvPacket`. Si la validación estructural falla (fragmentación TCP), reintenta con timeout corto de 500ms y concatena.

2. **`PosibleNombre`**: verifica que en una posición dada haya al menos 1 byte imprimible. Función pura sin dependencias.

3. **`LeerConfig` reescrito**: usa `LeerTodoDelSocket`, aplica la doble validación, deduce la cantidad de canales, y llama a `ActualizarCantidadCanales` si cambió. Los logs reportan `Configuracion recibida correctamente (N canales).`

#### `UEquipo.pas` — Fix de `ActualizarCantidadCanales`

La lógica de reducción (shrink) estaba comentada y causaba memory leak. Ahora:
- **Crecimiento:** crea nuevos `TSensor` (como antes)
- **Reducción:** libera sensores sobrantes con `Destruir` **antes** de `SetLength` (para no perder los punteros)

### 7.4 Flujo actualizado

```
TServerListenerThread acepta conexión TCP
  → TEquipo.Crear(10, 'TCP', 2)              ← modelo con 10 canales iniciales
  → TServEquipoThread.Create(modelo, ...)

TServEquipoThread.Execute():
  ConfigEntorno()                             ← init con 10 canales
  LeerConfig()                                ← lee TODO del socket
    → valida (len-20) mod 3 == 0
    → CantCanalesReal = (len-20) div 3        ← ej: 30
    → valida PosibleNombre en offset 103
    → ActualizarCantidadCanales(30)            ← redimensiona modelo
    → ParsearTramaCE(auxStr, 30, Config)
  CargarCanales(path)                         ← usa Equipo.NumCanales = 30
  EscribirConfig()                            ← construye trama con 30 canales
  DescargarLosDatos()                         ← guarda datos de 30 canales
```

### 7.5 Inestabilidad conocida y limitaciones

> ⚠️ **Dependencia de protocolo:** la posición del nombre se calcula como
> `CantCanales * 3 + 12` bytes desde el inicio del frame. Esto asume que los
> campos fijos (Hora:4 + FechaIni:4 + Tmuestreo:2 + Gap:2 = **12 bytes**) no
> cambian. Si se agregan campos al protocolo CE, este offset debe actualizarse
> en `PosibleNombre` **y** en `ParsearTramaCE` simultáneamente.

> ⚠️ **Criterio relajado:** el umbral `countPrintable >= 1` puede tener falsos
> positivos en casos extremos (un byte de datos que casualmente sea >= 32).
> En la práctica, los valores de config de sensor son 0-12 y los bytes altos de
> ADC son 0-3, por lo que la probabilidad es muy baja. Si se detectan problemas
> en producción, elevar el umbral a `>= 2`.

> ⚠️ **Fragmentación TCP residual:** si un fragmento llega con un tamaño que
> coincidentemente pasa `(len-20) mod 3 == 0` (ej: 80 bytes de un frame de 110),
> y uno de los bytes en la posición calculada del nombre es >= 32, se parsearía
> con canales incorrectos. El reintento de 500ms mitiga esto, pero no es
> garantía absoluta en enlaces GPRS muy degradados.

---

## 8. Trama GA — Ciclo de Configuración de Internet por SIM (Abril 2026)

### 8.1 Propósito

La trama `GA` es el mecanismo por el cual el software Mercury envía al firmware remoto los parámetros de conexión a internet: APN/gateway, usuario, contraseña, IP del servidor, puerto y período de reconexión. Permite reconfigurar un equipo en campo sin intervención física, únicamente a través de la sesión TCP activa.


---

### 8.2 Ciclo de vida completo de `Execute` (con GA activo)

El método `Execute` de `TServEquipoThread` sigue este orden estricto dentro del bucle principal de cada sesión TCP:

```
1.  SW → FW  : "OK"                    ← saludo inicial del servidor
2.  FW → SW  : "CE"                    ← el equipo anuncia que enviará su configuración
3.  FW → SW  : <payload CE>            ← trama binaria con hora, canales, nombre, memoria
4.  SW       : LeerConfig()            ← parsea CE, redimensiona modelo si cambió Ncanales
5.  SW       : CargarCanales()         ← carga INI de disco, asigna sensores, guarda
6.  SW       : ForzarConfig()          ← evalúa si el INI pide reconfig forzada
7.  SW       : ForzarValoresInstantaneos() ← evalúa si pide descarga instantánea

    ┌─ if DescargarDatos ──────────────────────────────────────────────────────────┐
    │  Retardo(1000)                                                               │
    │  DescargarLosDatos()   ← RupturaTransmisión ? LeerDatos : GuardarInstant.   │
    │  Retardo(2000)                                                               │
    └──────────────────────────────────────────────────────────────────────────────┘

    ┌─ if ConfigEquipo ────────────────────────────────────────────────────────────┐
    │  EscribirConfig()                                                            │
    │   ├── CargarNuevaConf()   ← lee {Nombre}Conf.ini                            │
    │   │    ├── CambiarConf=S  → actualiza T, nombre, ConfigCHs[]                │
    │   │    ├── CambConfInt=S  → actualiza gateway/user/pass/server/port         │
    │   │    │                    → activa flag ConfigInternetEquipo               │
    │   │    └── CambiarTConect=S → actualiza IndexTConect                        │
    │   │                           → activa flag ConfigTConect                   │
    │   └── SW → FW: "CE" + trama   ← envía config general (hora, canales, T)    │
    │  GuardarNuevaConf()   ← persiste flags en 'N' para no repetir              │
    │  Retardo(2000)                                                               │
    └──────────────────────────────────────────────────────────────────────────────┘

    ┌─ if ConfigTConect ───────────────────────────────────────────────────────────┐
    │  EscribirConfigTConect()                                                     │
    │   └── SW → FW: "TX" + 2 bytes   ← periodo de conexión en big-endian        │
    │  Retardo(2000)                                                               │
    └──────────────────────────────────────────────────────────────────────────────┘

    ┌─ if ConfigInternetEquipo ────────────────────────────────────────────────────┐
    │  EscribirConfigInternet()                                                    │
    │   └── SW → FW: "GA" + trama AT  ← comandos de modem + período              │
    │  Retardo(2000)                                                               │
    └──────────────────────────────────────────────────────────────────────────────┘
```

> **Punto clave de orden:** `CargarNuevaConf` es llamada **dentro** de `EscribirConfig` (paso `ConfigEquipo`). Es ahí donde se activa `ConfigInternetEquipo`. Por eso, el bloque de GA siempre aparece **después** del bloque de CE — el flag ya está listo cuando se evalúa.

---

### 8.3 Cómo se activa el envío de GA

El flag `ConfigInternetEquipo` se pone en `true` desde `CargarNuevaConf` cuando el archivo `{Nombre}Conf.ini` contiene `CambiarConfInternet=S`. El operador edita ese archivo (o la UI lo hace desde un formulario de configuración de internet), y en la próxima conexión del equipo el SW detecta el cambio y envía la trama GA.

Una vez enviada, `GuardarNuevaConf` escribe `CambiarConfInternet=N` para que no se reenvíe en sesiones futuras.

---

### 8.4 Formato de la trama GA

Construida en `EscribirConfigInternet`:

```
"GA" + strIni + strGateway + strServer + ";" + strFin + "#"
```

| Segmento | Contenido | Ejemplo literal |
|---|---|---|
| `"GA"` | Identificador de comando | `GA` |
| `strIni` | Comandos AT de init del módem | `ATE0\rATE0\rAT+CMGF=1\rAT+CNMI=3,2,2,0,0\rAT+CMGD=1,4\rAT+CREG=1\r` |
| `strGateway` | Configuración de APN/SIM | `AT+MIPCALL=1,"apn.operador","user","pass"\r/` |
| `strServer` | Apertura de socket TCP | `AT+MIPOPEN=1,8080,"192.168.x.x",8080,0\r/` |
| `";"` | **Separador** entre comandos y período | `;` |
| `strFin` | 2 bytes período + comandos de cierre | `{byte_hi}{byte_lo}AT+MIPCLOSE=1\r/AT+MIPCALL=0\r/` |
| `"#"` | Terminador de trama | `#` |

Los 2 bytes del período en `strFin` son producidos por `NumToAbytes(CalcPeriodoConect(IndexTConect))` y representan la cantidad de muestras entre conexiones al servidor en orden `[byte_hi, byte_lo]`.

---

### 8.5 Recepción y procesamiento en el Firmware

El dispatcher de comandos del firmware (`commands()` en `lib/comunication.py`) detecta el prefijo `GA` y delega en `command_GA()`:

#### Paso 1 — Separación de secciones

```python
config = config.split(b'GA')[-1]                  # quita el prefijo "GA"
modem_commands, send_period = config.split(b';')   # separa comandos AT del período
```

Si el `;` no está presente (fragmentación TCP), el `except` asigna un período por defecto de 30 minutos calculado desde `_t_sample`, pero **no parsea los comandos AT** — la configuración de modem queda incompleta hasta la siguiente sesión que entregue la trama completa.

#### Paso 2 — Período de conexión

```python
send_period = send_period[0:2]   # primeros 2 bytes después del ';'
command_TX(send_period)          # int.from_bytes(send_period, 'big') + 1
```

Este valor se guarda en `config.txt` bajo la clave `periodes_to_send`.

#### Paso 3 — Parseo de comandos AT

```python
modem_commands = modem_commands.replace(b'/', b'')     # elimina separadores '/'
modem_commands = modem_commands.split(b'\r')[0:-1]     # divide por '\r', descarta vacío final
modem_commands = [command + b'\r' for command in modem_commands]
```

Resulta en una lista de comandos AT listos para enviar al módem UART, por ejemplo:
```
[b'ATE0\r', b'AT+CMGF=1\r', b'AT+MIPCALL=1,"apn","user","pass"\r', b'AT+MIPOPEN=1,8080,"ip",8080,0\r', ...]
```

#### Paso 4 — Determinación del modo de comunicación

El firmware detecta el modo leyendo el campo `user` del comando `AT+MIPCALL`:

```
AT+MIPCALL=1, "gateway/APN" , "user" , "password"
                  ↑ campo 1     ↑ campo 2   ↑ campo 3
                  (ssid)        (mode)       (password)
```

| Valor del campo `user` | Modo asignado |
|---|---|
| `"WIFI"` | WiFi directo |
| `"TERMINAL"`, `"ARSAT"`, `"GATEWAY"` | WiFi con terminal satelital ARSAT |
| `"GLOBAL_STAR"` | Módulo GlobalStar |
| Cualquier otro (ej: vacío, `"wap"`) | **MODEM** — conexión por tarjeta SIM ← caso normal |

Para uso con tarjeta SIM, el campo `user` del APN típicamente es vacío (`""`) o un string corto del operador, por lo que cae correctamente en el caso `MODEM`.

#### Paso 5 — Persistencia en `config.txt`

```python
set_in_file('wireless_config', ...)       # comandos AT como texto plano
set_in_file('ssid',            ...)       # APN/gateway
set_in_file('password',        ...)       # contraseña del APN
set_in_file('ip_port',         ...)       # "ip puerto"
set_in_file('communication_using', ...)   # "MODEM" / "WIFI" / "GLOBAL_STAR"
set_in_file('terminal',        ...)       # "True" / "False"
```

Al siguiente boot del firmware, `get_wireless_config()` lee estos valores y reconstruye `modem_commands[]`, `ip_port`, `ssid`, `password` y `communication_using` sin necesidad de recibir otra trama GA.

---

### 8.6 Diagrama de secuencia GA completo

```text
  +------------------+                         +------------------+
  |  Firmware (SIM)  |                         |    Mercury (PC)  |
  +--------+---------+                         +---------+--------+
           |                                             |
           |  [Sesión TCP activa, CE ya procesado]       |
           |                                             |
           |               ← CambiarConfInternet=S       |
           |                 detectado en Conf.ini       |
           |                                             |
           |      "GA" + strIni + strGateway             |
           |      + strServer + ";" + strFin + "#"       |
           |<============================================|
           |                                             |
           |  command_GA():                              |
           |    split(b';') → modem_cmds + period        |
           |    command_TX(period[0:2])                  |
           |    parsea AT+MIPCALL → ssid, mode, pass     |
           |    parsea AT+MIPOPEN → ip, port             |
           |    determina communication_using            |
           |    guarda en config.txt                     |
           |                                             |
           |    return b''  (sin ACK al SW)              |
           |                                             |
           |  [Nuevos parámetros aplican                 |
           |   en la PRÓXIMA conexión GPRS]              |
           |                                             |
           |               Retardo(2000) en SW           |
           |                                             |
           |  [Sesión TCP cierra]                        |
           |============================================>|
           |                                             |
```

---

### 8.7 Consideraciones y limitaciones conocidas

| # | Situación | Impacto | Estado |
|---|---|---|---|
| 1 | El FW no devuelve ACK tras GA (`return b''`) | El SW no sabe si la trama llegó correctamente | ⚠️ Limitación conocida |
| 2 | Fragmentación TCP parte la trama en el `;` | Comandos AT no se parsean; período se estima por defecto | ⚠️ Improbable en LAN, posible en GPRS degradado |
| 3 | El terminador `#` no es validado por el FW | No hay verificación de integridad de trama | ⚠️ Sin impacto práctico actual |
| 4 | GA y TX enviados en la misma sesión | El período se escribe dos veces con el mismo valor | ✅ Redundante pero inocuo |
| 5 | Los parámetros aplican en la **próxima** conexión | No hay reconexión inmediata tras recibir GA | ✅ Comportamiento esperado y correcto |
| 6 | `CambiarConfInternet` se resetea a `N` en `GuardarNuevaConf` | GA solo se envía una vez por cambio de config | ✅ Correcto |

