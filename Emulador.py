import serial
import struct
import time

# --- CONFIGURACIÓN ---
PORT = 'COM2'
BAUD = 9600
NOMBRE_EQUIPO = bytearray(b'TEST')

CANTIDAD_BLOQUES = 3
# Canales lineales: 10 por bloque (8 analógicos + 2 digitales)
CANALES_CONFIG = [12,1,2,3,4,5,6,7,8,9] * CANTIDAD_BLOQUES  

INTERVALO_MUESTREO = 120

def generar_respuesta_CE():
    """
    Genera respuesta CE con estructura LINEAL:
    - Datos:      NumCanales * 2 bytes
    - Hora:       4 bytes
    - FechaIni:   4 bytes
    - Intervalo:  2 bytes
    - Gap:        2 bytes (firmware)
    - Config:     NumCanales * 1 byte
    - Nombre:     4 bytes
    - Memoria:    3 bytes
    - MemTotal:   1 byte
    Total = (NumCanales * 3) + 20 bytes
    """
    respuesta = bytearray()
    
    num_canales = len(CANALES_CONFIG)
    
    # 1. Datos de Canales (NumCanales * 2 bytes)
    for i in range(num_canales):
        valor = (1000 + i * 100 + int(time.time()) % 100) % 65535
        respuesta.extend(struct.pack('<H', valor))

    # 2. Hora (4 bytes)
    hora = int(time.time()) - 946684800
    respuesta.extend(struct.pack('<I', hora))
    
    # 3. Fecha Inicio (4 bytes)
    respuesta.extend(struct.pack('<I', hora))
    
    # 4. Intervalo (2 bytes)
    respuesta.extend(struct.pack('<H', INTERVALO_MUESTREO))
    
    # 5. Gap Firmware (2 bytes)
    respuesta.extend(struct.pack('<H', 0))

    # 6. Configuración de Canales (NumCanales * 1 byte)
    for config in CANALES_CONFIG:
        respuesta.append(config)

    # 7. Nombre (4 bytes)
    nombre = NOMBRE_EQUIPO[:4]
    if len(nombre) < 4:
        nombre = nombre + bytearray(b'_' * (4 - len(nombre)))
    respuesta.extend(nombre)
    
    # 8. Memoria Ocupada (3 bytes)
    respuesta.append(0x10)
    respuesta.append(0x20)
    respuesta.append(0x00)

    # 9. Capacidad Memoria (1 byte)
    respuesta.append(16)

    print(f"CE Frame: {len(respuesta)} bytes ({num_canales} canales)")
    return bytes(respuesta)


def generar_datos_muestras():
    canales_activos = [i for i, c in enumerate(CANALES_CONFIG) if c > 0]
    num_canales = len(canales_activos)
    if num_canales == 0: return bytes(4)
    
    num_muestras = 10
    total_bytes = 4 + (num_canales * 2 * num_muestras)
    datos = bytearray(total_bytes)
    
    struct.pack_into('<I', datos, 0, total_bytes)
    
    pos = 4
    for muestra in range(num_muestras):
        for canal in canales_activos:
            valor = 500 + (canal * 100) + (muestra * 10)
            struct.pack_into('<H', datos, pos, valor)
            pos += 2
    return bytes(datos)


def procesar_config_recibida(raw_data):
    """Parsea los datos de configuración recibidos del PC."""
    global INTERVALO_MUESTREO, NOMBRE_EQUIPO
    
    num_canales = len(CANALES_CONFIG)
    # Header: Hora(4) + IniMuest(4) + T(2) + Tregre(2) = 12 bytes
    # Config: NumCanales bytes
    # Nombre: 4 bytes
    # Total esperado: 12 + NumCanales + 4
    esperado = 12 + num_canales + 4
    
    print(f"  Bytes recibidos: {len(raw_data)}, esperados: {esperado}")
    
    idx = 0
    
    # 1. Hora (4 bytes) - solo log
    if idx + 4 <= len(raw_data):
        hora = struct.unpack_from('<I', raw_data, idx)[0]
        print(f"  Hora recibida: {hora}")
        idx += 4
    
    # 2. Inicio Muestreo (4 bytes) - solo log
    if idx + 4 <= len(raw_data):
        ini = struct.unpack_from('<I', raw_data, idx)[0]
        print(f"  Inicio Muestreo: {ini}")
        idx += 4
    
    # 3. Intervalo (2 bytes) - GUARDAR
    if idx + 2 <= len(raw_data):
        intervalo = struct.unpack_from('<H', raw_data, idx)[0]
        INTERVALO_MUESTREO = intervalo
        print(f"  Intervalo ACTUALIZADO: {INTERVALO_MUESTREO} seg")
        idx += 2
    
    # 4. Cuenta Regresiva (2 bytes) - solo log
    if idx + 2 <= len(raw_data):
        tregre = struct.unpack_from('<H', raw_data, idx)[0]
        print(f"  Cuenta Regresiva: {tregre}")
        idx += 2
    
    # 5. Config de Canales (NumCanales bytes) - GUARDAR
    for i in range(num_canales):
        if idx < len(raw_data):
            CANALES_CONFIG[i] = raw_data[idx]
            idx += 1
    print(f"  Config APLICADA: {CANALES_CONFIG}")
    
    # 6. Nombre (4 bytes) - GUARDAR
    if idx + 4 <= len(raw_data):
        NOMBRE_EQUIPO = bytearray(raw_data[idx:idx+4])
        print(f"  Nombre ACTUALIZADO: {NOMBRE_EQUIPO}")
        idx += 4


# --- FLUJO PRINCIPAL ---
try:
    ser = serial.Serial(PORT, BAUD, timeout=0.1)
    print(f"Simulador CABLE iniciado en {PORT}. Esperando comandos...")

    while True:
        data = ser.read(1)
        
        if data == b'X':
            print("Recibido: X (heartbeat)")
            ser.write(b'CE')
            ser.write(generar_respuesta_CE())
            ser.flush()
            print("Enviado: CE + frame")
            
        elif data == b'L':
            next_byte = ser.read(1)
            if next_byte == b'D':
                print("Recibido: LD (solicitud de datos)")
                ser.write(b'DG')
                ser.write(generar_datos_muestras())
                ser.flush()
                print("Datos de muestras enviados.")
        
        elif data == b'C':
            next_byte = ser.read(1)
            if next_byte == b'E':
                print("Recibido: CE (Inicio Configuración)")
                ser.write(b'OK')
                ser.flush()
                
                # Esperar a recibir los bytes de configuración
                # Esperamos: Header(12) + Config(NumCanales) + Nombre(4) = 16 + NumCanales
                expected_bytes = 12 + len(CANALES_CONFIG) + 4
                raw_data = b''
                timeout_start = time.time()
                while len(raw_data) < expected_bytes and (time.time() - timeout_start) < 3.0:
                    chunk = ser.read(expected_bytes - len(raw_data))
                    if chunk:
                        raw_data += chunk
                
                if len(raw_data) > 0:
                    print(f"Recibidos {len(raw_data)} de {expected_bytes} bytes de configuración.")
                    try:
                        procesar_config_recibida(raw_data)
                    except Exception as e:
                        print(f"Error parseando config: {e}")
                else:
                    print("No llegaron datos de conf.")
                
                print("Configuración procesada.")
                
        time.sleep(0.1)

except serial.SerialException as e:
    print(f"Error al abrir el puerto: {e}")
except KeyboardInterrupt:
    print("\nSimulador detenido.")
finally:
    if 'ser' in locals() and ser.is_open:
        ser.close()