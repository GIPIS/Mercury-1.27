# EMAC Mercury 1.27

> Software de adquisición, configuración y descarga de datos para estaciones de monitoreo ambiental del grupo EMAC — Instituto Argentino de Oceanografía (IADO-CONICET).

---

## Índice

1. [¿Qué es Mercury?](#qué-es-mercury)
2. [Estructura de archivos](#estructura-de-archivos)
3. [Clonar el repositorio](#clonar-el-repositorio)
4. [Instalar y ejecutar la aplicación](#instalar-y-ejecutar-la-aplicación)

---

## ¿Qué es Mercury?

Mercury es una aplicación de escritorio para Windows desarrollada originalmente en **Delphi** y migrada a **Free Pascal / Lazarus**. Permite al operador de una estación de monitoreo ambiental:

- **Conectarse** a los equipos de adquisición de datos (dataloggers EMAC) vía puerto serie (COM1–COM255), módem telefónico o internet.
- **Configurar** los canales de medición y los sensores conectados al equipo.
- **Descargar** los datos almacenados en la memoria del datalogger.
- **Exportar** mediciones a TXT, CSV (formato español `;` o inglés `,`).
- **Calcular** parámetros oceanográficos derivados: salinidad, densidad, etc.
- **Gestionar** conexiones remotas y automáticas con múltiples equipos.

Soporta más de 70 tipos de sensores predefinidos (temperatura, conductividad, nivel, viento, radiación, pH, oxígeno disuelto, entre otros), definidos en archivos `.sen` en la carpeta `Sensores/`.

> **Estado actual (v1.27):** Migración de Delphi a Lazarus en curso. La comunicación serie, la configuración de equipos y la descarga/exportación de datos funcionan correctamente. Los módulos de gráficos y comunicación TCP/IP están temporalmente deshabilitados.

---

## Estructura de archivos

```
Mercury 1.27/
│
├── Mercury.lpi              ← Proyecto Lazarus (configuración del IDE, NO editar a mano)
├── Mercury.lpr              ← Programa principal en Pascal (punto de entrada)
├── Mercury.exe              ← Ejecutable de la raíz (copia de distribución anterior)
│
├── *.pas                    ← Código fuente (unidades del proyecto)
│   ├── Uprincipal.pas       ← Formulario principal de la aplicación
│   ├── UEquipo.pas          ← Modelo de datos del equipo/datalogger
│   ├── USensor.pas          ← Modelo de datos de sensores
│   ├── UFormulas.pas        ← Cálculo de parámetros derivados
│   ├── PuertoSerie.pas      ← Comunicación serie (API Windows directa)
│   ├── UConexiones.pas      ← Gestión de conexiones
│   ├── UEquipoInternet.pas  ← Comunicación por internet (en desarrollo)
│   └── ...                  ← Resto de unidades y formularios
│
├── *.lfm / *.dfm            ← Formularios visuales (diseñador de Lazarus)
│
├── Mercury.cfg              ← Opciones del compilador FPC
├── Mercury.ini              ← Configuración de runtime de la aplicación
│
├── Sensores/                ← Definiciones de sensores (.sen), más de 70 tipos
├── Equipos/                 ← Directorio de datos por equipo registrado
├── Datos/                   ← Directorio de descarga de datos
├── Iconos/                  ← Recursos gráficos (íconos)
├── Imagenes/                ← Recursos gráficos (imágenes de la UI)
├── Pantillas Web/           ← Plantillas para exportación web
├── temp/                    ← Archivos temporales de runtime (no modificar)
│
├── lib/
│   └── x86_64-win64/        ← Archivos generados por el compilador (NO editar)
│       ├── Mercury.exe      ← ✅ Ejecutable generado por la última compilación
│       ├── *.ppu            ← Módulos Pascal compilados
│       └── *.o              ← Objetos binarios
│
├── MDs/                     ← Documentación técnica interna
├── build.log                ← Log de la última compilación
└── errors.log               ← Log de errores de compilación
```

> **Nota:** La carpeta `lib/x86_64-win64/` es generada automáticamente por el compilador. No se edita ni se distribuye. El ejecutable actualizado siempre se encuentra en `lib/x86_64-win64/Mercury.exe`.

---

## Clonar el repositorio

### Requisitos previos

- [Git para Windows](https://git-scm.com/download/win)

### Pasos

```bash
# 1. Clonar el repositorio
git clone <URL-del-repositorio> "Mercury 1.27"

# 2. Ingresar al directorio
cd "Mercury 1.27"
```

El repositorio ya incluye todos los archivos fuente (`.pas`, `.lfm`), los recursos (`Sensores/`, `Iconos/`, etc.) y los archivos de configuración del proyecto (`.lpi`, `.lpr`).

> **La carpeta `lib/` está excluida del repositorio** (listada en `.gitignore`). Se genera localmente al compilar el proyecto.

---

## Instalar y ejecutar la aplicación

Esta sección es para **usuarios finales** que solo quieren usar Mercury, sin modificar ni compilar nada.

### Lo que se necesita

- Windows 10 o superior (64 bits)
- El archivo `Mercury.exe` compilado (ver abajo de dónde obtenerlo)

### Dónde está el ejecutable correcto

El ejecutable generado por la **última compilación** se encuentra en:

```
lib\x86_64-win64\Mercury.exe
```

> ⚠️ El `Mercury.exe` que está en la **raíz del proyecto** puede ser de una versión anterior. Siempre usar el que está dentro de `lib\x86_64-win64\`.

### Instalación manual (sin instalador)

1. Copiar los siguientes archivos y carpetas a la carpeta de destino (por ejemplo `C:\EMAC Mercury\`):

   | Qué copiar | Desde dónde |
   |---|---|
   | `Mercury.exe` | `lib\x86_64-win64\Mercury.exe` |
   | `qtintf.dll` | raíz del proyecto |
   | `Mercury.ini` | raíz del proyecto |
   | Carpeta `Sensores\` | raíz del proyecto |
   | Carpeta `Equipos\` | raíz del proyecto |
   | Carpeta `Datos\` | raíz del proyecto |
   | Carpeta `Iconos\` | raíz del proyecto |
   | Carpeta `Imagenes\` | raíz del proyecto |
   | Carpeta `Pantillas Web\` | raíz del proyecto |
   | Carpeta `temp\` | raíz del proyecto |

2. Ejecutar `Mercury.exe` desde la carpeta de destino.

   > Mercury busca sus archivos de configuración y recursos relativos a su propia ubicación, por lo que es importante que todas las carpetas estén junto al ejecutable.

### Primera ejecución

Al iniciar Mercury por primera vez, configurar:

- **Puerto serie** utilizado para conectar el datalogger (por defecto `COM1`).
- **Directorio de datos** donde se guardarán las descargas.

Estas opciones se guardan en `Mercury.ini` y se recuerdan entre sesiones.
