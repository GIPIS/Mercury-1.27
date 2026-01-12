import serial
import struct
import time

# --- CONFIGURACIÓN ---
PORT = 'COM2'
BAUD = 9600
NOMBRE_EQUIPO = b'TEST'
CANALES_CONFIG = [58] * 16  # 16 canales activos (ejemplo: config 58)
# CANALES_CONFIG = [58] * 16 + [0] * 16 # Si se quisieran 32 con solo 16 activos, pero el usuario pidio "16 canales"

INTERVALO_MUESTREO = 60

def generar_respuesta_CE():
    # Estructura del Frame para 16 canales (2 bloques de 8):
    # 1. Datos (32 bytes data + 8 bytes padding = 40 bytes)
    #    - Bloque 1 (8 ch): 16 bytes data + 4 bytes padding
    #    - Bloque 2 (8 ch): 16 bytes data + 4 bytes padding
    # 2. Hora (4 bytes)
    # 3. Fecha Inicio (4 bytes)
    # 4. Intervalo (2 bytes)
    # 5. Config (16 bytes config + 4 bytes padding = 20 bytes)
    #    - Bloque 1 (8 ch): 8 bytes config + 2 bytes padding
    #    - Bloque 2 (8 ch): 8 bytes config + 2 bytes padding
    # 6. Nombre (4 bytes)
    # 7. Memoria (4 bytes)
    
    # Total esperado: 40 + 10 + 20 + 4 + 4 = 78 bytes aprox?
    # Revisemos PuertoSerie.pas: loop de lectura con saltos.
    # El loop lee linealmente con saltos.
    # Data Loop: 
    #   Lee 2 bytes. inc(i,2).
    #   Si (i mod 8 == 0) -> inc(i,4)?? 
    #   No, PuertoSerie.pas TENIA logic comentada de saltos.
    #   En mi ultima lectura de PuertoSerie.pas, la linea de saltos estaba COMENTADA:
    #   //if ((NCanal + 1) mod 8 = 0) then
    #   //   inc(i, 4); 
    #   
    #   WAIT. If the skipping logic is COMMENTED OUT in Pascal, then the emulator MUST NOT send padding.
    #   Or I must uncomment it if padding is standard.
    #   The user said "20 bytes per block of 8 channels". this implies padding (16 data + 4 padding).
    #   If Pascal code consumes 2 bytes per channel * 16 channels = 32 bytes.
    #   And DOES NOT skip padding... then the emulator must SEND contiguous data (32 bytes).
    #
    #   However, line 620 in PuertoSerie.pas says:
    #   BytesOcupadosData := CantCanales * 2;
    #   And the reading loop iterates NCanal from 0 to CantCanales-1.
    #   So it reads exactly CantCanales*2 bytes contiguously.
    #
    #   BUT, if the protocol definition (which I can't change primarily) says "20 bytes per block",
    #   then the Pascal code is WRONG if it ignores padding?
    #   OR the emulator should just match the Pascal code.
    #   Start simple: Match Pascal code. Pascal code reads contiguous.
    #   I will implement contiguous data generation for now.
    
    #   Wait, line 630: BytesToRead calculation.
    #   BytesToRead := BytesOcupadosData (16*2=32) + 4 + 4 + 2 + BytesOcupadosConf (16*1=16) + 4 + 4;
    #   Total: 32 + 14 + 16 + 8 = 70 bytes.
    #   
    #   So Pascal expects 70 bytes for 16 channels.
    
    respuesta = bytearray()
    
    # 1. Datos de Canales (2 bytes c/u)
    for i in range(len(CANALES_CONFIG)):
        valor = 1000 + i * 100
        respuesta.extend(struct.pack('<H', valor))
    
    # 2. Hora
    hora = int(time.time()) - 946684800
    respuesta.extend(struct.pack('<I', hora))
    
    # 3. Fecha Inicio
    respuesta.extend(struct.pack('<I', hora))
    
    # 4. Intervalo
    respuesta.extend(struct.pack('<H', INTERVALO_MUESTREO))
    
    # 5. Configuración de Canales (1 byte c/u)
    for config in CANALES_CONFIG:
        respuesta.append(config)
        
    # 6. Nombre
    respuesta.extend(NOMBRE_EQUIPO)
    
    # 7. Memoria
    respuesta.extend(struct.pack('<I', 65536)) # 4 bytes memoria

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
            print("Enviado: CE + 50 bytes")
        
        elif data == b'L':
            next_byte = ser.read(1)
            if next_byte == b'D':
                print("Recibido: LD (solicitud de datos)")
                ser.write(b'DG')
                ser.write(generar_datos_muestras())
                ser.flush()
                print("Datos de muestras enviados.")

except serial.SerialException as e:
    print(f"Error al abrir el puerto: {e}")
except KeyboardInterrupt:
    print("\nSimulador detenido.")
finally:
    if 'ser' in locals() and ser.is_open:
        ser.close()