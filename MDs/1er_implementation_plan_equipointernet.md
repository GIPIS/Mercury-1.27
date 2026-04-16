# Plan de Implementación Actualizado: Unificación en PuertoSerie y Herencia de UEquipo

Este plan detalla los pasos acordados para consolidar la comunicación sin crear archivos nuevos ni capas extra (`UProtocoloMercury` o `TEquipoBase`). El objetivo es reutilizar las estructuras ya existentes (`UEquipo` y `TThreadComm`), aplicando los patrones correctos de herencia y abstracción de flujos (if/else).

## 1. Modificación de [UEquipo.pas](../UEquipo.pas) y Herencia en [UEquipoInternet.pas](../UEquipoInternet.pas)
En lugar de extraer variables, permitiremos que el equipo de internet herede todo lo que ya funciona para un equipo local, pero especializando el guardado de datos.

#### [UEquipo.pas](../UEquipo.pas)
- Modificar las funciones `GuardarEquipo`, `CargarEquipo` y `BorrarEquipo` para que sean **`virtuales`**, de modo que sus hijos puedan sobrescribirlas (`function GuardarEquipo(DirINI : string):boolean; virtual;`).
- Modificar el constructor para que **no abra** el `TPuertoSerie` (ComFile) si el parámetro `TipoCom = 2` (Internet), dejándolo suspendido para inyectar el socket después.

#### [UEquipoInternet.pas](../UEquipoInternet.pas)
- Eliminar por completo el hilo esclavo gigante `TServEquipoThread`.
- Crear la clase `TEquipoInternet = class(TEquipo)`.
- Sobrescribir (`override;`) los métodos `GuardarEquipo` y `CargarEquipo`, copiando la lógica de escritura específica a redes remotos (ej. usar el path `Datos` en lugar de `Equipos` y manipular el `Canales.txt` como lo hacía el viejo hilo).

## 2. Refactorización de [PuertoSerie.pas](../PuertoSerie.pas) (El Hilo Unificado)
Tanto para Comunicación Serial/Modem como TCP/IP, `TThreadComm` será el único motor, usando la lógica actual de lectura extendida (> 10 sensores) del puerto serie.

#### Modificaciones en `TThreadComm`
- Importar la librería de Synapse (`blcksock`) en `uses`.
- Agregar un atributo `FSocket: TTCPBlockSocket;` que se instanciará cuando `ThTipoCom = 2`.
- Crear Wrappers de Lectura/Escritura universales con condicionales para no repetir código:
  - `function EscribirCom(datos: string): boolean;` (interno: `if ThTipoCom = 2 then FSocket.SendString else PSerie.EscribirAlPuertoSerie`).
  - `function LeerCom(var datos: string; cantidad: integer): boolean;`
  - Mantener las funciones actuales intactas (`LeerConfig`, `DescargarLosDatos`, `EscribirConfig`), pero reemplazar en su interior todas las llamadas a `PSerie.LeerDelPuertoSerie` y `PSerie.EscribirAlPuertoSerie` por nuestros nuevos métodos de lectura/escritura unificada (`LeerCom(...)` / `EscribirCom(...)`) que contienen el condicional de comunicación.
  - Crear el bucle sincrónico (`CanRead`) para TCP dentro de `Execute` de forma análoga al bucle local.
- Unificar el sistema de logueo inyectando un puntero al `TPStrings` si viene por Internet, o usar `pActualizar` si viene por local.

## 3. Modificación del Servidor de Escucha ([UServerSocket.pas](../UServerSocket.pas))
El servidor debe dejar de intentar gestionar el hilo directamente, para pasar a delegar la creación de un verdadero *Equipo* instanciado dinámicamente.

#### Modificaciones al Aceptar una Conexión
- Cuando ocurre un `Accept` exitoso, el listener va a instanciar localmente `EqInternet := TEquipoInternet.Crear(10, 'TCP', 2);`
- Luego le inyectará el socket nativo y el puntero del historial: `EqInternet.ThreadComm.FSocket.Socket := ClientSocketHandle;`
- Lo des-suspenderá con `EqInternet.ThreadComm.Resume;`. 
- *(Consideración de memoria: asegurar que si la conexión se cierra, el `TEquipoInternet` instanciado al vuelo se libere correctamente sin fugas).*

---

### Tareas Resumen:
1. [UEquipo.pas](../UEquipo.pas): Convertir métodos en genéricos/Virtuales.
2. [UEquipoInternet.pas](../UEquipoInternet.pas): Reemplazar hilo por clase `TEquipoInternet`.
3. [PuertoSerie.pas](../PuertoSerie.pas): Agregar Wrappers (if Serial else TCP) en `TThreadComm`.
4. [UServerSocket.pas](../UServerSocket.pas): Instanciar `TEquipoInternet` al escuchar conexiones entrantes.
