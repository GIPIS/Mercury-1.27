import serial
import struct
import time

# --- CONFIGURACIÓN ---
PORT = 'COM2'
BAUD = 9600
NOMBRE_EQUIPO = b'TEST'

CANTIDAD_BLOQUES = 1
CANALES_CONFIG = [58,1,2,3,4,5,6,7,8,9] * CANTIDAD_BLOQUES  # 8 analógicos y 2 digitales por bloque

INTERVALO_MUESTREO = 60

def generar_respuesta_CE():
    """
    Genera respuesta CE con estructura de bloques:
    - Cada bloque de 8 canales tiene: 8 analog (16 bytes) + 2 digital (4 bytes) = 20 bytes
    - Para 32 canales: 4 bloques × 20 bytes = 80 bytes de datos
    - Luego: Hora(4) + FechaIni(4) + Intervalo(2) + Config(32) + Nombre(4) + Memoria(4)
    """
    respuesta = bytearray()
    
    num_canales = len(CANALES_CONFIG)
    num_bloques = CANTIDAD_BLOQUES
    
    # 1. Datos de Canales por bloques
    for bloque in range(num_bloques):
        # 8 canales analógicos por bloque
        for ch in range(8):
            indice_real = bloque * 8 + ch
            if indice_real < num_canales:
                valor = 1000 + indice_real * 100
            else:
                valor = 0
            respuesta.extend(struct.pack('<H', valor))
        
        # 2 canales digitales (alternativas A y B)
        dig_a = 5000 + bloque * 10  # Digital A: 5000, 5010, 5020, 5030
        dig_b = 6000 + bloque * 10  # Digital B: 6000, 6010, 6020, 6030
        respuesta.extend(struct.pack('<H', dig_a))  # Digital A
        respuesta.extend(struct.pack('<H', dig_b))  # Digital B

    # 2. Hora (4 bytes)
    hora = int(time.time()) - 946684800
    respuesta.extend(struct.pack('<I', hora))
    
    # 3. Fecha Inicio (4 bytes)
    respuesta.extend(struct.pack('<I', hora))
    
    # 4. Intervalo (2 bytes)
    respuesta.extend(struct.pack('<H', INTERVALO_MUESTREO))
    
    # 2 bytes por Firmware
    respuesta.extend(struct.pack('<H', 0))

    # 5. Configuración de Canales (1 byte c/u)
    for config in CANALES_CONFIG:
        respuesta.append(config)

    # 6. Nombre (4 bytes)
    respuesta.extend(NOMBRE_EQUIPO)
    
    # 7. Memoria (4 bytes)
    respuesta.extend(struct.pack('<I', 65536))

    print(f"CE Frame: {len(respuesta)} bytes ({num_bloques} bloques)")
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
# --- FLUJO PRINCIPAL ---
import socket

def iniciar_servidor_tcp(puerto=1234):
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.bind(('0.0.0.0', puerto))
    server.listen(1)
    print(f"Modo TCP: Escuchando en el puerto {puerto}...")
    conn, addr = server.accept()
    print(f"Conexión establecida desde {addr}")
    return conn

try:
    try:
        ser = serial.Serial(PORT, BAUD, timeout=0.1)
        print(f"Simulador Serial iniciado en {PORT}. Esperando comandos...")
        modo = 'SERIAL'
        com_channel = ser
    except Exception as e:
        print(f"No se pudo abrir puerto Serial ({e}).")
        print("Intentando iniciar modo Servidor TCP en puerto 1234...")
        com_channel = iniciar_servidor_tcp(1234)
        modo = 'TCP'

    while True:
        if modo == 'SERIAL':
            data = ser.read(1)
        else:
            try:
                data = com_channel.recv(1)
                if not data: break # Conexión cerrada
            except:
                break

        if data == b'X':
            print("Recibido: X (heartbeat)")
            respuesta = b'CE' + generar_respuesta_CE()
            if modo == 'SERIAL':
                ser.write(respuesta[0:2]) # Manda CE
                ser.write(respuesta[2:])
                ser.flush()
            else:
                com_channel.sendall(respuesta)
                
            print(f"Enviado: CE + {len(respuesta)-2} bytes")
            
        elif data == b'L':
            if modo == 'SERIAL':
                next_byte = ser.read(1)
            else:
                next_byte = com_channel.recv(1)

            if next_byte == b'D':
                print("Recibido: LD (solicitud de datos)")
                bloque = b'DG' + generar_datos_muestras()
                
                if modo == 'SERIAL':
                    ser.write(bloque)
                    ser.flush()
                else:
                    com_channel.sendall(bloque)
                print("Datos de muestras enviados.")

except serial.SerialException as e:
    print(f"Error Serial: {e}")
except KeyboardInterrupt:
    print("\nSimulador detenido.")
finally:
    if 'ser' in locals() and hasattr(ser, 'is_open') and ser.is_open:
        ser.close()
    if 'com_channel' in locals() and modo == 'TCP':
        com_channel.close()