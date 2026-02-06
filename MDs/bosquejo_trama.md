# Bosquejo de la Trama "LeerConfig" (Puerto Serie)

Este documento detalla la estructura exacta de la trama de datos recibida por la función `LeerConfig` en `PuertoSerie.pas`.

La trama varía su tamaño dinámicamente según la cantidad de canales configurados (`CantCanales`), organizándose en bloques de 8 canales.

## Estructura General

| Sección | Tamaño (Bytes) | Descripción |
| :--- | :--- | :--- |
| **1. Datos de Canales** | `N * 20` | `N` bloques de datos (donde `N` depende de `CantCanales`). |
| **2. Información Sistema** | `10` | Hora, Inicio de Muestreo, Periodo. |
| **3. Configuración Canales** | `CantCanales` | 1 byte de configuración por cada canal. |
| **4. Metadatos Equipo** | `8` | Nombre del equipo y memoria utilizada. |

---

## Desglose Detallado Byte a Byte

A continuación se describe la secuencia exacta de bytes.

### 1. Sección de Datos (Variable)
Esta sección se repite `NumBloques` veces.
*   **Bloque 1**: Si `CantCanales` >= 1 (hasta 8)
*   **Bloque 2**: Si `CantCanales` >= 9 (hasta 16)
*   **Bloque 3**: Si `CantCanales` >= 17 (hasta 24)
*   **Bloque 4**: Si `CantCanales` >= 25 (hasta 32)

**Estructura de UN Bloque (20 bytes):**

| Offset Relativo | Campo | Tipo | Notas |
| :--- | :--- | :--- | :--- |
| +0 | **Canal Analógico 0** | Word (2 bytes) | Little Endian (ByteBajo, ByteAlto) |
| +2 | **Canal Analógico 1** | Word (2 bytes) | |
| +4 | **Canal Analógico 2** | Word (2 bytes) | |
| +6 | **Canal Analógico 3** | Word (2 bytes) | |
| +8 | **Canal Analógico 4** | Word (2 bytes) | |
| +10 | **Canal Analógico 5** | Word (2 bytes) | |
| +12 | **Canal Analógico 6** | Word (2 bytes) | |
| +14 | **Canal Analógico 7** | Word (2 bytes) | |
| +16 | **Canal Digital A** | Word (2 bytes) | Opción A para canales digitales del bloque |
| +18 | **Canal Digital B** | Word (2 bytes) | Opción B para canales digitales del bloque |

*(Nota: Los canales analógicos se mapean a los índices globales. Ej: En el Bloque 2, el "Canal Analógico 0" corresponde al Canal 8 global).*

---

### 2. Sección Información de Sistema (10 bytes)

| Campo | Tamaño | Tipo | Notas |
| :--- | :--- | :--- | :--- |
| **Hora Actual** | 4 bytes | Integer | Fecha/Hora del equipo. |
| **Inicio Muestreo** | 4 bytes | Integer | Fecha/Hora de inicio de muestreo. |
| **Periodo Muestreo** | 2 bytes | Word | Intervalo de muestreo en segundos (aprox). |

---

### 3. Sección Configuración de Canales (Variable)

El tamaño exacto es igual a `CantCanales` (en bytes).

| Campo | Tamaño | Descripción |
| :--- | :--- | :--- |
| **Conf. Canal 0** | 1 byte | Estado/Config del canal 0. |
| **Conf. Canal 1** | 1 byte | Estado/Config del canal 1. |
| ... | ... | ... |
| **Conf. Canal N** | 1 byte | Estado/Config del canal N (`CantCanales - 1`). |

---

### 4. Sección Metadatos (8 bytes)

| Campo | Tamaño | Tipo | Descripción |
| :--- | :--- | :--- | :--- |
| **Nombre Equipo** | 4 bytes | String[4] | 4 caracteres ASCII. Caracteres no válidos reemplazados por '_'. |
| **Memoria Ocupada** | 4 bytes | Integer | Cantidad de memoria usada (bytes). Se leen 3 bytes efectivos pero ocupa 4 en trama. |

---

## Resumen de Tamaños Totales

*   **8 Canales (1 Bloque)**: `20 + 10 + 8 + 8` = **46 bytes**
*   **16 Canales (2 Bloques)**: `40 + 10 + 16 + 8` = **74 bytes**
*   **24 Canales (3 Bloques)**: `60 + 10 + 24 + 8` = **102 bytes**
*   **32 Canales (4 Bloques)**: `80 + 10 + 32 + 8` = **130 bytes**
