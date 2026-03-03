import serial
import struct
import time

# --- CONFIGURACIÓN ---
PORT = 'COM2'
BAUD = 1200  # Baudrate telefónico (el PC usa 1200 para TipoCom=1)
NOMBRE_EQUIPO = bytearray(b'TELF')

CANTIDAD_BLOQUES = 3
CANALES_CONFIG = [12,1,2,3,4,5,6,7,8,9] * CANTIDAD_BLOQUES  

INTERVALO_MUESTREO = 120

# Estados del emulador telefónico
ESTADO_MODEM = 'IDLE'       # IDLE, CONECTADO
MODEM_INICIALIZADO = False


def generar_respuesta_CE():
    """Genera frame CE idéntico al emulador de cable."""
    respuesta = bytearray()
    num_canales = len(CANALES_CONFIG)
    
    for i in range(num_canales):
        valor = (1000 + i * 100 + int(time.time()) % 100) % 65535
        respuesta.extend(struct.pack('<H', valor))

    hora = int(time.time()) - 946684800
    respuesta.extend(struct.pack('<I', hora))
    respuesta.extend(struct.pack('<I', hora))
    respuesta.extend(struct.pack('<H', INTERVALO_MUESTREO))
    respuesta.extend(struct.pack('<H', 0))

    for config in CANALES_CONFIG:
        respuesta.append(config)

    nombre = NOMBRE_EQUIPO[:4]
    if len(nombre) < 4:
        nombre = nombre + bytearray(b'_' * (4 - len(nombre)))
    respuesta.extend(nombre)
    
    respuesta.append(0x10)
    respuesta.append(0x20)
    respuesta.append(0x00)
    respuesta.append(16)

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
    idx = 0
    
    if idx + 4 <= len(raw_data):
        hora = struct.unpack_from('<I', raw_data, idx)[0]
        print(f"  Hora recibida: {hora}")
        idx += 4
    
    if idx + 4 <= len(raw_data):
        ini = struct.unpack_from('<I', raw_data, idx)[0]
        print(f"  Inicio Muestreo: {ini}")
        idx += 4
    
    if idx + 2 <= len(raw_data):
        intervalo = struct.unpack_from('<H', raw_data, idx)[0]
        INTERVALO_MUESTREO = intervalo
        print(f"  Intervalo ACTUALIZADO: {INTERVALO_MUESTREO} seg")
        idx += 2
    
    if idx + 2 <= len(raw_data):
        tregre = struct.unpack_from('<H', raw_data, idx)[0]
        print(f"  Cuenta Regresiva: {tregre}")
        idx += 2
    
    for i in range(num_canales):
        if idx < len(raw_data):
            CANALES_CONFIG[i] = raw_data[idx]
            idx += 1
    print(f"  Config APLICADA: {CANALES_CONFIG}")
    
    if idx + 4 <= len(raw_data):
        NOMBRE_EQUIPO = bytearray(raw_data[idx:idx+4])
        print(f"  Nombre ACTUALIZADO: {NOMBRE_EQUIPO}")


def leer_linea_at(ser, timeout=2.0):
    """Lee una línea completa terminada en \\r del puerto serie."""
    buffer = b''
    start = time.time()
    while (time.time() - start) < timeout:
        byte = ser.read(1)
        if byte:
            buffer += byte
            if byte == b'\r':
                return buffer.decode('ascii', errors='replace').strip()
    return buffer.decode('ascii', errors='replace').strip() if buffer else None


# --- FLUJO PRINCIPAL ---
try:
    ser = serial.Serial(PORT, BAUD, timeout=0.1)
    print(f"=" * 60)
    print(f"Simulador TELEFÓNICO iniciado en {PORT} @ {BAUD} baud")
    print(f"Canales: {len(CANALES_CONFIG)} ({CANTIDAD_BLOQUES} bloques)")
    print(f"=" * 60)
    print(f"Esperando comandos AT del modem...")

    while True:
        data = ser.read(1)
        
        if not data:
            continue
            
        # --- FASE MODEM: Comandos AT ---
        if ESTADO_MODEM == 'IDLE':
            if data in (b'A', b'a'):
                # Posible comando AT
                rest = leer_linea_at(ser, timeout=2.0)
                if rest is None:
                    continue
                    
                comando = ('A' + rest).upper()
                print(f"[MODEM] Comando recibido: {comando}")
                
                if comando.startswith('ATZ'):
                    # Reset modem
                    time.sleep(0.3)
                    ser.write(b'OK\r\n')
                    ser.flush()
                    MODEM_INICIALIZADO = True
                    print(f"[MODEM] Reset → OK (modem inicializado)")
                    
                elif comando.startswith('ATD'):
                    # Marcar número
                    numero = comando[3:].strip()
                    print(f"[MODEM] Marcando: {numero}")
                    time.sleep(1.0)  # Simula tono de marcado
                    ser.write(b'CONNECT\r\n')
                    ser.flush()
                    ESTADO_MODEM = 'CONECTADO'
                    print(f"[MODEM] Conectado! → Pasando a protocolo de equipo")
                    
                elif comando.startswith('ATH'):
                    # Colgar
                    time.sleep(0.3)
                    ser.write(b'OK\r\n')
                    ser.flush()
                    ESTADO_MODEM = 'IDLE'
                    print(f"[MODEM] Colgado → OK")
                    
                elif comando.startswith('ATE'):
                    # Echo on/off
                    time.sleep(0.1)
                    ser.write(b'OK\r\n')
                    ser.flush()
                    print(f"[MODEM] Echo config → OK")
                    
                else:
                    # Cualquier otro AT
                    time.sleep(0.1)
                    ser.write(b'OK\r\n')
                    ser.flush()
                    print(f"[MODEM] Comando genérico → OK")
        
        # --- FASE EQUIPO: Protocolo CE (después de CONNECT) ---
        elif ESTADO_MODEM == 'CONECTADO':
            
            if data == b'X':
                print("[EQUIPO] Recibido: X (heartbeat)")
                ser.write(b'CE')
                frame = generar_respuesta_CE()
                ser.write(frame)
                ser.flush()
                print(f"[EQUIPO] Enviado: CE + {len(frame)} bytes")
                
            elif data == b'L':
                next_byte = ser.read(1)
                if next_byte == b'D':
                    print("[EQUIPO] Recibido: LD (solicitud de datos)")
                    ser.write(b'DG')
                    ser.write(generar_datos_muestras())
                    ser.flush()
                    print("[EQUIPO] Datos de muestras enviados.")
            
            elif data == b'C':
                next_byte = ser.read(1)
                if next_byte == b'E':
                    print("[EQUIPO] Recibido: CE (Inicio Configuración)")
                    ser.write(b'OK')
                    ser.flush()
                    
                    time.sleep(0.5)
                    
                    num_config_bytes = ser.in_waiting
                    if num_config_bytes > 0:
                        raw_data = ser.read(num_config_bytes)
                        print(f"[EQUIPO] Recibidos {len(raw_data)} bytes de configuración.")
                        try:
                            procesar_config_recibida(raw_data)
                        except Exception as e:
                            print(f"[EQUIPO] Error parseando config: {e}")
                    else:
                        print("[EQUIPO] No llegaron datos de conf.")
            
            elif data in (b'A', b'a'):
                # Posible comando AT para colgar (ATH)
                rest = leer_linea_at(ser, timeout=2.0)
                if rest:
                    comando = ('A' + rest).upper()
                    print(f"[MODEM] Comando en conexión: {comando}")
                    if comando.startswith('ATH'):
                        time.sleep(0.3)
                        ser.write(b'OK\r\n')
                        ser.flush()
                        ESTADO_MODEM = 'IDLE'
                        print(f"[MODEM] Colgado → Volviendo a modo IDLE")
        
        time.sleep(0.1)  # Loop más rápido para telefónica

except serial.SerialException as e:
    print(f"Error al abrir el puerto: {e}")
except KeyboardInterrupt:
    print("\nSimulador telefónico detenido.")
finally:
    if 'ser' in locals() and ser.is_open:
        ser.close()
