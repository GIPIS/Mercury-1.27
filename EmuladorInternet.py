import socket
import time
import struct
import random
import datetime

CANALES_CONFIG = [12,1,2,3,4,5,6,7,8,9]

def emular_equipo():
    # Configuración de la conexión
    host = '127.0.0.1'
    port = 40000  # Usamos el puerto 40000 que vimos en tu log de Lazarus
    
    # 1. Crear el socket TCP
    cliente = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    
    try:
        print(f"Conectando al servidor {host}:{port}...")
        cliente.connect((host, port))
        
        # El servidor de Lazarus envía un 'OK' inicial al conectarse
        respuesta_ok = cliente.recv(1024)
        print(f"Servidor dice: {respuesta_ok.decode('utf-8', errors='ignore').strip()}")
        
        # 2. Enviar el comando 'CE' (Configurar Equipo)
        print("Enviando comando 'CE'...")
        cliente.sendall(b'CE')
        
        # Damos un pequeñísimo respiro para que Lazarus entre al LeerConfig
        time.sleep(0.2)
        
        # 3. Construir la trama de 50 bytes EXACTOS
        # En Pascal los strings empiezan en 1 (auxStr[1]), en Python en 0 (payload[0])
        payload = bytearray(50)
        
        # Bytes 0 al 19 (Pascal 1 al 20): Valores de 10 canales (2 bytes por canal)
        # Simularemos que los sensores marcan valores aleatorios entre 50 y 850
        for i in range(10):
            valor_sensor = random.randint(50, 850)
            payload[i*2] = valor_sensor & 0xFF          # Byte bajo
            payload[i*2 + 1] = (valor_sensor >> 8) & 0xFF # Byte alto
            
        # Obtenemos los segundos exactos desde el 01/01/2000 para sincronizar la Hora
        dt_base = datetime.datetime(2000, 1, 1)
        ahora = datetime.datetime.now()
        segs_desde_2000 = int((ahora - dt_base).total_seconds())

        # Bytes 20 al 23 (Pascal 21 al 24): Hora del equipo (4 bytes)
        struct.pack_into('<I', payload, 20, segs_desde_2000) 
        
        # Bytes 24 al 27 (Pascal 25 al 28): Fecha Inicial de muestreo (4 bytes)
        struct.pack_into('<I', payload, 24, segs_desde_2000 - 3600) # Hace una hora
        
        # Bytes 28 al 29 (Pascal 29 al 30): Tmuestreo (2 bytes)
        # Simulamos que muestrea cada 60 segundos
        struct.pack_into('<H', payload, 28, 60)
        
        # Bytes 30 y 31 quedan en 0. 
        # (En tu código Pascal saltas de la posición 29 a la 33 para la config, hay un gap de 2 bytes).
        
        # Bytes 32 al 41 (Pascal 33 al 42): Configuración de los 10 canales (1 byte c/u)
        # Usamos CANALES_CONFIG para indicar la configuración
        for i in range(10):
            payload[32 + i] = CANALES_CONFIG[i]
            
        # Bytes 42 al 45 (Pascal 43 al 46): Nombre del equipo (4 caracteres)
        payload[42:46] = b'EMU1'
        
        # Bytes 46 al 48 (Pascal 47 al 49): Memoria ocupada (3 bytes)
        # Lo dejamos en 0 para que no piense que hay datos históricos (no disparamos 'LD')
        payload[46] = 0; payload[47] = 0; payload[48] = 0
        
        # Byte 49 (Pascal 50): Memoria total (1 byte)
        # Es una potencia de 2. Si es 15, la memoria es 2^15 = 32768
        payload[49] = 15
        
        # 4. Enviar los 50 bytes de configuración
        print("Enviando 50 bytes de datos binarios...")
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