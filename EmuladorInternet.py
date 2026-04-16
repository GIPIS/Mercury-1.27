import socket
import time
import struct
import random
import datetime

CANALES_CONFIG = [12,1,2,3,4,5,6,7,8,9]*1

def emular_equipo():
    # Configuración de la conexión
    host = '127.0.0.1'
    port = 40000  # Usamos el puerto 40000 que vimos en tu log de Lazarus
    
    # 1. Crear el socket TCP
    cliente = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    
    try:
        num_canales = len(CANALES_CONFIG)
        total_bytes = num_canales * 3 + 20
        
        print(f"Conectando al servidor {host}:{port}...")
        print(f"Canales: {num_canales}, Trama CE: {total_bytes} bytes")
        cliente.connect((host, port))
        
        # El servidor de Lazarus envía un 'OK' inicial al conectarse
        respuesta_ok = cliente.recv(1024)
        print(f"Servidor dice: {respuesta_ok.decode('utf-8', errors='ignore').strip()}")
        
        # 2. Enviar el comando 'CE' (Configurar Equipo)
        print("Enviando comando 'CE'...")
        cliente.sendall(b'CE')
        
        # Damos un pequeñísimo respiro para que Lazarus entre al LeerConfig
        time.sleep(0.2)
        
        # 3. Construir la trama dinámica: NumCanales*3 + 20 bytes
        payload = bytearray(total_bytes)
        idx = 0
        
        # Sección 1: Valores de canales (NumCanales * 2 bytes)
        for i in range(num_canales):
            valor_sensor = random.randint(50, 850)
            payload[idx] = valor_sensor & 0xFF          # Byte bajo
            payload[idx + 1] = (valor_sensor >> 8) & 0xFF # Byte alto
            idx += 2
            
        # Obtenemos los segundos exactos desde el 01/01/2000 para sincronizar la Hora
        dt_base = datetime.datetime(2000, 1, 1)
        ahora = datetime.datetime.now()
        segs_desde_2000 = int((ahora - dt_base).total_seconds())

        # Sección 2: Hora del equipo (4 bytes)
        struct.pack_into('<I', payload, idx, segs_desde_2000) 
        idx += 4
        
        # Sección 3: Fecha Inicial de muestreo (4 bytes)
        struct.pack_into('<I', payload, idx, segs_desde_2000 - 3600)  # Hace una hora
        idx += 4
        
        # Sección 4: Tmuestreo (2 bytes)
        struct.pack_into('<H', payload, idx, 60)
        idx += 2
        
        # Sección 5: Gap firmware (2 bytes)
        struct.pack_into('<H', payload, idx, 0)
        idx += 2
        
        # Sección 6: Configuración de canales (NumCanales * 1 byte)
        for i in range(num_canales):
            payload[idx] = CANALES_CONFIG[i]
            idx += 1
            
        # Sección 7: Nombre del equipo (4 caracteres)
        nombre = b'EMU2'
        payload[idx:idx+4] = nombre[:4]
        idx += 4
        
        # Sección 8: Memoria ocupada (3 bytes)
        payload[idx] = 0; payload[idx+1] = 0; payload[idx+2] = 0
        idx += 3
        
        # Sección 9: Memoria total (1 byte)
        payload[idx] = 15
        idx += 1
        
        assert idx == total_bytes, f"Error: idx={idx} != total_bytes={total_bytes}"
        
        # 4. Enviar los bytes de configuración
        print(f"Enviando {total_bytes} bytes de datos binarios...")
        cliente.sendall(payload)
        
        # 5. Esperar la respuesta del servidor
        # Si todo sale bien, Lazarus procesará los datos, guardará en disco y nos 
        # enviará de vuelta la nueva configuración que vimos en 'EscribirConfig'
        print("Esperando la re-configuración del servidor...")
        datos_recibidos = cliente.recv(1024)
        
        print(f"\n¡Éxito! El servidor respondió con {len(datos_recibidos)} bytes.")
        if len(datos_recibidos) > 0:
            print(f"Datos recibidos (Hexadecimal): {datos_recibidos.hex()}")
            print(f"Cabecera ASCII: {datos_recibidos[:2].decode('utf-8', errors='ignore')}")

    except Exception as e:
        print(f"Ocurrió un error en la conexión: {e}")
    finally:
        cliente.close()
        print("Conexión finalizada.")

if __name__ == '__main__':
    emular_equipo()