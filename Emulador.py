import serial
import struct
import time

# --- CONFIGURACIÓN ---
# --- CONFIGURACIÓN ---
PORT = 'COM2'
BAUD = 9600
NOMBRE_EQUIPO = b'TEST'

CANTIDAD_BLOQUES = 4
# 20 canales lineales (sin estructura de bloques en el frame)
# Para simular, definimos 10 canales por bloque lógico, pero el frame es lineal.
CANALES_CONFIG = [12,1,2,3,4,5,6,7,8,9] * CANTIDAD_BLOQUES  

INTERVALO_MUESTREO = 120

def generar_respuesta_CE():
    """
    Genera respuesta CE con estructura LINEAL (sin bloques de padding):
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
        # Generar valor simulado
        # Simular variación para ver que refresca
        valor = (1000 + i * 100 + int(time.time()) % 100) % 65535
        respuesta.extend(struct.pack('<H', valor))

    # 2. Hora (4 bytes)
    hora = int(time.time()) - 946684800 # Ajuste fecha base Delphi (aprox)
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
    if len(NOMBRE_EQUIPO) >= 4:
        respuesta.extend(NOMBRE_EQUIPO[:4])
    else:
        respuesta.extend(NOMBRE_EQUIPO + b'_'*(4-len(NOMBRE_EQUIPO)))
    
    # 8. Memoria Ocupada (3 bytes)
    # Simular 3 bytes: 0x10, 0x20, 0x00 -> 0x002010
    respuesta.append(0x10)
    respuesta.append(0x20)
    respuesta.append(0x00)

    # 9. Capacidad Memoria (1 byte)
    # Potencia de 2. Ej: 16 -> 2^16 = 65536 bytes
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

# --- FLUJO PRINCIPAL ---
try:
    ser = serial.Serial(PORT, BAUD, timeout=0.1) # Timeout bajo para no bloquear el script
    print(f"Simulador iniciado en {PORT}. Esperando comandos...")

    while True:
        data = ser.read(1)
        
        if data == b'X':
            print("Recibido: X (heartbeat)")
            ser.write(b'CE')
            ser.write(generar_respuesta_CE())
            ser.flush() # Asegura el envío
            print("Enviado: CE + "+str(len(generar_respuesta_CE()))+" bytes")
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
                
                # Leer bytes de configuración (aprox 50 bytes)
                # 4(Hora)+4(Ini)+2(T)+2(Regre) + (10*Bloques)
                time.sleep(0.5) # Esperar a que lleguen
                
                num_config_bytes = ser.in_waiting
                if num_config_bytes > 0:
                    raw_data = ser.read(num_config_bytes)
                    print(f"Recibidos {len(raw_data)} bytes de configuración.")
                    
                    # 1. Skip Header (12 bytes)
                    # Hora(4) + Ini(4) + T(2) + Regre(2)
                    header_size = 12
                    
                    # 2. Parse Channel Config
                    current_idx = header_size
                    
                    try:
                        # Assuming PC sends config for OUR number of channels
                        for i in range(len(CANALES_CONFIG)):
                            if current_idx < len(raw_data):
                                CANALES_CONFIG[i] = raw_data[current_idx]
                                current_idx += 1
                                
                                # Skip padding if block boundary (every 8 channels)
                                if (i + 1) % 8 == 0:
                                    current_idx += 2
                        
                        print(f"Configuración APLICADA: {CANALES_CONFIG}")
                    except Exception as e:
                        print(f"Error parseando config: {e}")
                else:
                    print("No llegaron datos de conf.")
                
                # Opcional: Actualizar INTERVALO_MUESTREO si se decodifica
                print("Configuración aplicada en simulador.")
                
        # --- PAUSA DEL BUCLE PRINCIPAL ---
        # Reduce CPU usage and slows down the loop as requested
        time.sleep(1) 

except serial.SerialException as e:
    print(f"Error al abrir el puerto: {e}")
except KeyboardInterrupt:
    print("\nSimulador detenido.")
finally:
    if 'ser' in locals() and ser.is_open:
        ser.close()