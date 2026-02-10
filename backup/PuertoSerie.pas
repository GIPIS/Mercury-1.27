unit PuertoSerie;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Registry, Classes, SysUtils, Dialogs, StdCtrls, SyncObjs, Math,
  Windows, USensor, UUtiles, UFormulas;

const
  // Constantes para funciones de archivo Win32
  GENERIC_READ = $80000000;
  GENERIC_WRITE = $40000000;
  OPEN_EXISTING = 3;
  FILE_ATTRIBUTE_NORMAL = $80;
  INVALID_HANDLE_VALUE = THandle(-1);
  
  // Constantes para DCB
  NOPARITY = 0;
  ODDPARITY = 1;
  EVENPARITY = 2;
  MARKPARITY = 3;
  SPACEPARITY = 4;
  
  ONESTOPBIT = 0;
  ONE5STOPBITS = 1;
  TWOSTOPBITS = 2;

type
  TAbytes = array [0..3] of byte;

// Declaraciones de funciones de la API de Windows para comunicación serial
function CreateFile(lpFileName: PChar; dwDesiredAccess, dwShareMode: DWORD;
  lpSecurityAttributes: Pointer; dwCreationDisposition, dwFlagsAndAttributes: DWORD;
  hTemplateFile: THandle): THandle; stdcall; external 'kernel32.dll' name 'CreateFileA';
function SetupComm(hFile: THandle; dwInQueue, dwOutQueue: DWORD): BOOL; stdcall; external 'kernel32.dll';
function GetCommState(hFile: THandle; var lpDCB: Windows.TDCB): BOOL; stdcall; external 'kernel32.dll';
function SetCommState(hFile: THandle; const lpDCB: Windows.TDCB): BOOL; stdcall; external 'kernel32.dll';
function SetCommTimeouts(hFile: THandle; const lpCommTimeouts: Windows.TCOMMTIMEOUTS): BOOL; stdcall; external 'kernel32.dll';
function BuildCommDCB(lpDef: PChar; var lpDCB: Windows.TDCB): BOOL; stdcall; external 'kernel32.dll' name 'BuildCommDCBA';

type
  TPuertoSerie = class(Tobject)
    private
      DeviceName   : array[0..80] of Char;
      ComFile      : THandle;
      PserieOpen   : boolean;

    public
      RxBufferSize : dword;
      TxBufferSize : dword;
      RxTimeout    : dword;
      TxTimeout    : dword;
      RxBuffer     : string;
      TxBuffer     : string;
      ListaPorts   : Tstrings;
      Baud         : string;
      Parity       : string;
      Data         : string;
      Stop         : string;

      constructor  Crear;
      destructor   Destruir;
      function     CrearListaPuertosSerie(): boolean;
      function     AbrirPuertoSerie(CommPort :string):boolean;
      function     ConfigPuertoSerie():boolean;
      function     EscribirAlPuertoSerie(chs :string): boolean;
      function     LeerDelPuertoSerie(var chs :string; TamBuffer: integer):boolean;
      procedure    CerrarPuerto;
  end;

  TThreadComm = class(TThread)
    private
      //
    protected
      procedure   Execute; override;
      procedure   SyncActualizar; // Wrapper para Synchronize

    public
      pvalorCH        : array of ^integer;
      pCH_conf        : array of ^byte;
      
      // Digital channel values (2 alternates per module, choose one)
      // Index 0-3 corresponds to modules (0=Monitoreo, 1=Exp1, 2=Exp2, 3=Exp3)
      pvalorDigA      : array[0..3] of integer;  // First digital option (ch 8, 16, 24, 32)
      pvalorDigB      : array[0..3] of integer;  // Second digital option (ch 9, 17, 25, 33)
      UsarCHDigB      : array[0..3] of boolean;  // True = use B, False = use A

      // Info que leo del equipo
      pNombre         : ^string;
      pHoraEquipo     : ^Tdatetime;
      pHoraActual     : ^Tdatetime;
      pIniMuestreo    : ^Tdatetime;
      pTmuestreo      : ^integer;
      pMemoria        : ^integer;
      pCantMemory     : ^integer;
      pProgreso       : ^integer;
      pASensor        : ^TASensor;          // Puntero al arreglo de canales
      pCalcParam      : ^TCalculoParam;     // Puntero al arreglo de los calculos de Parametros

      // Info que voy a grabar en el equipo
      Hora00          : byte;
      Hora01          : byte;
      Hora02          : byte;
      Hora03          : byte;
      IniMuest00      : byte;
      IniMuest01      : byte;
      IniMuest02      : byte;
      IniMuest03      : byte;
      T00             : byte;
      T01             : byte;
      Tregre00        : byte;
      Tregre01        : byte;
      ConfigCHs       : array of byte;

      // Config de Internet - Info que voy a grabar en el equipo
      gateway         : string;
      user            : string;
      pass            : string;
      server          : string;
      port            : string;
      IndexTConect    : byte;

      // Objeto que maneja el Puerto Serie
      PSerie          : TPuertoSerie;

      T               : integer;           // Periodo de muestreo en SEGUNDOS
      NombreEquipo    : string;            // Nombre del Equipo
      Hora_Base       : string;
      ConfigEquipo    : boolean;
      ConfigInternetEquipo : boolean;     
      DescargarDatos  : boolean;
      ONLine          : boolean;
      CantCanales     : byte;
      Archivo         : string;            // Path y nombre del archivo en que guardo los datos
      sep             : string;            // Caracter que uso para separar las columas cuando bajo datos
      Datos           : Tstrings;          // Información recopilada por el equipo
      FormatoDescarga : byte;              // Elección del Formato en que descargo los datos
      //FormatoFecha    : string;            // Elección del Formato de las fechas los datos
      IndiceFormatoFe : byte;              // Selección del Formato de las fechas
      pActualizar     : TNotifyEvent;      // Actualiza los datos del equipo
      pActualProgres  : TNotifyEvent;      // Actualiza la barra de progreso para la descarga
      POnConectRemoto : TNotifyEvent;      // Realiza algún proceso cuando se CONECTA en forma remoto
      POnDesConRemoto : TNotifyEvent;      // Realiza algún proceso cuando se DESCONECTA en forma remoto

      // Comunicación remota
      ConexOK         : boolean;           // Me indica si establecí alguna conexión remota
      ThTipoCom       : byte;

      // Comunicación Telefonica (Puerto Serie)
      ConecTelef       : boolean;
      DesConecTelef    : boolean;
      IniConecTelef    : boolean; 
      AutoDesconecDesc : boolean;          // Una vez terminadas la descarga se desconecta automaticamente
      AutoDesconecConf : boolean;          // Una vez terminadas la config se desconecta automaticamente
      Ntelefono        : string;           // Número de telefono al cual llama para conectarse
      NombreConex      : string;           // Nombre de la conexión remota      

      constructor crear(CreateSuspended: Boolean; NCanales:byte);
      destructor  Destruir;
      procedure   LeerConfig;
      procedure   EscribirConfig;
      procedure   EscribirConfigInternet;
      procedure   DescargarLosDatos;      
      procedure   LeerDatos;
      procedure   ConectarTelefon;        // Inicia el protocolo de Conección
      procedure   DesConectarTelefon;     // Corta la comunicación telefonica
      procedure   IniComTelefon;          // Inicializa el Hardware de la comunicación telefonica
      function    CalcPeriodoConect(index: byte):integer;
      procedure   ActualizarCantidadCanales(NCanales: byte);
  end;

  // Funciones y Procedimientos de uso generales
  Procedure Retardo(tiempo:integer);
  function  NumToAbytes(num : longint):TAbytes;

implementation


////////////////////////////////////////////////////////////////////////////////
//TPuertoSerie
////////////////////////////////////////////////////////////////////////////////
constructor TPuertoSerie.Crear;
begin
  RxBufferSize := 256;
  TxBufferSize := 256;
  RxTimeout    := 0;
  TxTimeout    := 0;
  DeviceName   := 'COM1';
  Baud         := '9600';
  Parity       := 'n';
  Data         := '8';
  Stop         := '1';
  PserieOpen   := false;

  ListaPorts   := Tstringlist.Create;
end;

////////////////////////////////////////////////////////////////////////////////
destructor  TPuertoSerie.Destruir;
begin
  ListaPorts.Free;
  CerrarPuerto;
end;

////////////////////////////////////////////////////////////////////////////////
function TPuertoSerie.CrearListaPuertosSerie(): boolean;
var
  i:integer;

begin
  ListaPorts.Clear;
  with TRegistry.create do begin
    try
      rootkey:=HKEY_LOCAL_MACHINE;
      if openkey('HARDWARE\DEVICEMAP\SERIALCOMM',false) then begin
        GetValueNames(ListaPorts);
        for i:=0 to ListaPorts.count-1 do
          ListaPorts[i] := ReadString(ListaPorts[i]);
        result := false;
      end
      else result := false;
    finally free;
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
function TPuertoSerie.AbrirPuertoSerie(CommPort :string):boolean;
begin
//PREPARA EL NOMBRE DEL PUERTO  -- LO RECIBE POR PARAMETRO Y LO COPIA EN DEVICENAME
//POR QUE NO LO MANDA DIRECTO? PASCAL USA STRING, Y LA API DE WINDOWS (ESCRITA EN C ESPERA UN PUNTERO
// (Pchar) O UN ARRAY DE CARACTERES TERMINADO EN NULO (Array of char))
//ENTONCES LO TRANSFORMA A UN ARRAY DE CARACTERES
  StrPCopy(DeviceName, CommPort);
  //LLAMA A LA API
// CreateFile FUNCION NATIVA DE WINDOWS. 
//SE LLAMA CREATE FILE PORQUE EN WINDOWS TODO SE MANEJA COMO UN ARCHIVO
//LE PASA: 
//DEVICENAME: EL NOMBRE
//GENERIC_READ or GENERIC_WRITE: "QUIERO LEER Y ESCRIBIR DATOS"
//0: ES UN SEMAFORO QUE ME DA ACCESO EXLCUSIVO, NADIE MAS PUEDE USAR ESTE RECURSO
//OPEN_EXISTING: SOLO SI EXISTE ESTE ARCHIVO, SI NO, NO LO VUELVE A CREAR 

//DEVUELVE: 
//UN HANDLE, QUE SE VA A USAR PARA LEER O ESCRIBIR EL PUERTO
//ESTE HANDLE TRABAJA CON UN BUFFER EN MEMORIA RAM, EL CUAL RECIBE LOS DATOS DEL PUERTO...
// Y LO GUARDA
  ComFile := CreateFile(DeviceName,
                        GENERIC_READ or GENERIC_WRITE,
                        0, Nil,
                        OPEN_EXISTING,
                        FILE_ATTRIBUTE_NORMAL, 0);
//MANEJADOR DE EXCEPCIONES, SI HUBO UN ERROR LANZA LA ESCEPCION, Y LA FUNCION TERMINA ACA
  if ComFile = INVALID_HANDLE_VALUE then begin
    ShowMessage('No se puede acceder al '+ CommPort);
    result := false;
    exit;
  end;
//SI NO HUBO ERROR, VIENE ACA Y TODO OK
  PserieOpen := true;
  result     := true;
end;

////////////////////////////////////////////////////////////////////////////////
function TPuertoSerie.ConfigPuertoSerie():boolean;
var
  DCB          : Windows.TDCB;
  CommTimeouts : Windows.TCOMMTIMEOUTS;
  Config       : string;
//  ConfigCom    : TCOMMCONFIG;

begin
//EN UEquipo.pas SOLO SE LLENABAN LAS VARIABLES, PERO AHORA SE SETEA EL HARDWARE
//ACA SE DEFINE EL TAMANIO DE LOS BUFFERS TANTO DE LECTURA COMO DE ESCRITURA
//AMBOS SE DEFINEN EN TPUERTOSERIE.CREAR COMO 256
  if not SetupComm(ComFile, RxBufferSize, TxBufferSize) then  begin
    result := false;
    exit;
  end;
//SE LEE LA CONFIGURACION ACTUAL PARA VER SUS VALORES ACTUALES
//ESTO SE HACE PORQUE HAY ALGUNOS PARAMETROS QUE NO SE DESEAN MODIFICAR
//ESA CONFIGURACION SE GUARDA EN DCB
  if not GetCommState(ComFile, DCB) then begin
    result := false;
    exit;
  end;
//ACA SE ARMA UN PARAMETRO DE CONFIGURACION
//USAMOS EL BAUD = 19200 (VELOCIDAD DE TRANSMISION)
//PARITY = N, SIN BIT DE PARIDAD
//DATA = 8, CANTIDAD DE BITS POR CADA LETRA/PALABRA
//STOP = 1, UN BIT DE ESPERA/PARADA POR CADA 8 BITS
  //Config := 'baud=9600 parity=n data=8 stop=1';
  Config := 'baud='+Baud+' parity='+Parity+' data='+Data+' stop='+Stop;
  {
  // Modo Binary
    DCB.fBinary=True;

  // RTS control de flujo
    //DCB.fRtsControl := RTS_CONTROL_ENABLE;
    DCB.fRtsControl := RTS_CONTROL_DISABLE;

  // CTS control de flujo
    //DCB.fOutxCtsFlow := true;
    DCB.fOutxCtsFlow := false;

  // DTR control de flujo
    //DCB.fDtrControl := DTR_CONTROL_ENABLE;
    DCB.fDtrControl := DTR_CONTROL_DISABLE;

  // DSR control de flujo
    //DCB.fOutxDsrFlow := true;
    DCB.fOutxDsrFlow := false;

  // DSR sensado
    //DCB.fDsrSensitivity := false;
    DCB.fDsrSensitivity := true;
  }
  //ESTA FUNCION DE WINDOWS USA LA CONFIGURACION QUE ARMAMOS, Y TERMINA DE COMPLETAR..
  //LA ESTRUCTURA BINARIA DCB CON LOS BITS CORRECTOS, PARA NO HACERLO MANUALMENTE
  if not BuildCommDCB(@Config[1], DCB) then begin
    result := false;
    exit;
  end;


//ACA SE APLICAN LOS CAMBIOS AL HARDWARE: "CONFIGURA EL CHIP DEL PUERTO SERIE DE TAL MANERA"
  if not SetCommState(ComFile, DCB) then begin
    result := false;
    exit;
  end;

  with CommTimeouts do  begin
    ReadIntervalTimeout         := 0;
    ReadTotalTimeoutMultiplier  := 0;
    ReadTotalTimeoutConstant    := RxTimeout;// IMPORTANTE: 750 MS SIN LEER NADA Y "CORTA" CONEXION
    WriteTotalTimeoutMultiplier := 0;
    WriteTotalTimeoutConstant   := TxTimeout;//IMPORTANTE: NO HAY TIEMPO DE ESPERA DEFINIDO PARA ESCRITURA;
  end;
//SE CONFIGURAN LOS TIMEOUTS EN ELCHIP
  if not SetCommTimeouts(ComFile, CommTimeouts) then begin
    result := false;
    exit;
  end;

  result := true;
end;

////////////////////////////////////////////////////////////////////////////////
function TPuertoSerie.EscribirAlPuertoSerie(chs :string): boolean;
var
  BytesEscritos : dword;

begin
//EN VEZ DE CONVERTIR UN STRING, A UN ARRAY DE CARACTERES, LE PASA EL PRIMER CARACTER DEL STRING..
//COMO REFERENCIA.
//ENTONCES LA FUNCION WriteFile TERMINA DE LEER EL RESTO DEL STRING COMO SI FUERA UN ARRAY
//POR ESO ES QUE TAMBIEN LE PASAMOS LA LONGITUD DEL STRING
  if not WriteFile(ComFile, chs[1], Length(chs), BytesEscritos, Nil) then begin
    result := false;
    exit;
  end;

  result := true;
end;

////////////////////////////////////////////////////////////////////////////////
function TPuertoSerie.LeerDelPuertoSerie(var chs :string; TamBuffer: integer): boolean;
var
//BUFFER TEMPORAL LOCAL
   d            : array[1..256] of Char; //Buffer de lectura
   //CONTADOR REAL
   BytesLeidos  : dword;
   i            : Integer;

begin
//EL BUFFER 'd' TIENE TAMANIO FIJO DE 256
//SI SE PIDE LEER, POR EJEMPLO, 1000 BYTES, SE ROMPE
//ENTONCES ESTA LINEA EVITA ESTO RECORTANDO EL PEDIDO A 256
//PERO SI QUISIERAMOS LEER MAS INFORMAICON, TENEMOS QUE AUMENTAR EL TAMANIO DE 'd'
//O LEER DE A 256 BYTES EN UN BUCLE
  if (TamBuffer > length(d)) then TamBuffer := length(d);

  //FUNCION DE LA API DE WINDOWS
  //ComFile ES EL MANEJADR DEL PUERTO QUE YA HABIAMOS VISTO
  //'d' ES A DONDE GUARDA LOS DATOS CRUDOS
  //TamBuffer CUANTOS BYTES MAXIMOS QUEREMOS LEER
  //BytesLeidos: WINDOWS ESCRIBE ACA REALMENTE CUANTOS BYTES LLEGARON
  //nil INFO TECNICA
  //FUNCIONA COMO UNA COLA, SI LEO 2 BYTES, ENTONCES SACA ESOS 3 BYTES DE LA COLA, NO ESTAN MAS EN EL..
  //BUFFER DE LA RAM
  if not ReadFile(ComFile, d, TamBuffer, BytesLeidos, nil) then begin
    result := false; //FALLO, SE DESCONECTA
    exit;
  end;
//CONVERSION DE TIPOS: COMO DIJIMOS ANTES, WINDOWS USA C, POR LO QUE DEVUELVE UN ARREGLO DE CARACTERES
//ENTONCES LO TRANSFORMAMOS A UN TIPO STRING
//PASA DE ['C','E'] a 'ABC'
  chs := '';
  for i := 1 to BytesLeidos do chs := chs + d[i];
//  FlushFileBuffers(ComFile);
  result := true;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TPuertoSerie.CerrarPuerto;
begin
  if PSerieOpen then FileClose(ComFile); { *Convertido desde CloseHandle* }
  PSerieOpen := false;
end;

////////////////////////////////////////////////////////////////////////////////
//TThreadComm
//buscatr ncanales
////////////////////////////////////////////////////////////////////////////////
constructor TThreadComm.crear(CreateSuspended: Boolean; NCanales:byte);
begin
  inherited Create(CreateSuspended);
  Priority        := tpNormal;
  FreeOnTerminate := true;
  PSerie          := TPuertoSerie.Crear;
  Datos           := TStringList.Create;

  ConfigEquipo    := false;
  DescargarDatos  := false;
  Hora_Base       := '01/01/2000 12:00 am';
  ONLine          := false;
  Archivo         := 'NoNombre.txt';
  sep             := #9;
  pActualizar     := nil;
  pActualProgres  := nil;
  POnConectRemoto := nil;
  POnDesConRemoto := nil;
  CantCanales     := NCanales;
  SetLength(pvalorCH ,NCanales);
  SetLength(pCH_conf ,NCanales);
  SetLength(ConfigCHs,NCanales);

  // Tipo de comunicación
  ThTipoCom        := 0;             // Directa por cable serie

  // Comunicación Telefonica
  ConecTelef       := false;
  DesConecTelef    := false;
  IniConecTelef    := false;
  AutoDesconecDesc := false;         // Una vez terminadas la descarga se desconecta automaticamente
  AutoDesconecConf := false;         // Una vez terminadas la config se desconecta automaticamente
  Ntelefono        := '';            // Número de telefono al cual llama para conectarse
  NombreConex      := '';            // Nombre de la conexión remota
end;

procedure TThreadComm.ActualizarCantidadCanales(NCanales: byte);
begin
  // Update internal count
  CantCanales := NCanales;
  
  // Resize dynamic arrays
  SetLength(pvalorCH, NCanales);
  SetLength(pCH_conf, NCanales);
  SetLength(ConfigCHs, NCanales);
end;

////////////////////////////////////////////////////////////////////////////////
destructor TThreadComm.destruir;
begin
  // Me aseguro que no entre a ninguna función
  ConfigEquipo    := false;
  DescargarDatos  := false;

  // Destruyo los objetos
  Pserie.Destruir;
  Datos.Destroy;

  // Libero la memoria de los arreglos dinámicos
  SetLength(pvalorCH ,0);
  SetLength(pCH_conf ,0);
  SetLength(ConfigCHs,0);
end;

////////////////////////////////////////////////////////////////////////////////
procedure TThreadComm.SyncActualizar;
begin
  if Assigned(pActualizar) then
     pActualizar(Self); // Llama al evento en el contexto del hilo principal
end;

////////////////////////////////////////////////////////////////////////////////
procedure TThreadComm.Execute;
var
  auxStr  : string;
  i      : integer;
begin
  // Inicializo las variables
  ConfigEquipo     := false;fonia Celular
  if (ThTipoCom = 1) then begin
    IniComTelefon;
    retardo(500);   // Espero 1/2seg hasta que se inicialize
  end;
//ESTA ES LA FUNCION QUE SE ESTA EJECUTANDO EN BACKGROUND TODO EL TIEMPO
//TERMINATED SE PONE EN TRUE SOLO CUANDO SE CIERRA EL PROGRAMA
  while not Terminated do begin
    try
      // Conexión por Telefónica (Puerto Serie)
      if (ThTipoCom = 1) then begin
        if ConecTelef then begin
          // Ejecuto el procedure que realiza cosas cuando me conecto
          POnConectRemoto(nil);
          ConecTelef    := false;
          DesConecTelef := false;
          // Me indica si establecí alguna conexión remota
          ConexOK       := true;
          // Inicia la conección telefónica
          ConectarTelefon;
          // Espero 15seg hasta que se conecte
          retardo(15000);
        end;
        // Termina la conección telefónica
        if DesConecTelef  and ConexOK then begin
          // Ejecuto el procedure que realiza cosas cuando me desconecto
          POnDesConRemoto(nil);
          // Acutalizo el flag
          DesConecTelef := false;
          // Inicia la Desconección telefónica
          DesConectarTelefon;
          // Espero 1seg hasta que se Desconecte
          retardo(1000);
          // Me aseguro que no haga nada una vez desconectado
          ONLine           := false;
          ConfigEquipo     := false;
          DescargarDatos   := false;
          AutoDesconecDesc := false;
          AutoDesconecConf := false;
          ConexOK          := false;
        end;

        // Resetea el hardware de la conección telefónica
        if IniConecTelef  then begin
          // Resetea el hardware de la conección telefónica
          IniComTelefon;
          // Me aseguro que no entre mas al ciclo
          IniConecTelef := false;
        end;
      end;

      // Conexión por Internet (TCP/IP)
      if (ThTipoCom = 2) then begin
        //
      end;
//ESTA ES LA CONEXION QUE NOS IMPORTA A NOSOTROS, LAS ANTERIORES ERAN TELEFONICAS O TCP/IP
      // Indico al equipo que esta conectado a la PC
      //SI NO ESTAMOS CONECTADOS, EL EQUIPO ENVIA CONSTANTEMENTE LA LETRA X POR EL CABLE
      if not ONLine then PSerie.EscribirAlPuertoSerie('X');
      //ACA LA RESPUESTA. SE ESPERA A RECIBIR 'CE' A TRAVES DEL PUERTO
      auxStr := '';
      if PSerie.LeerDelPuertoSerie(auxStr,2) then begin
        if (auxStr = 'CE') then begin
        //SI SE RECIBE EXACTAMENTE 'CE', SE ESTABLECE LA CONEXION
        //APENAS SE RECIBE 'CE', SE LLAMA A LEERCONFIG QUE BAJA:
        //EL NOMBRE DEL EQUIPO, LA HORA, LA MEMORIA USADA, ETC.
          LeerConfig;                         // Leeo toda la config del equipo
          //VUELVE A ENVIAR X PARA CONFIRMAR QUE SE RECIBIO LA INFORMACION
          PSerie.EscribirAlPuertoSerie('X');  // Indico al equipo que esta conectado a la PC
          //ONLINE ES TRUE, YA NO SE EJECUTA EL IF DENTRO DEL BUCLE
          ONLine := true;
        end
        else begin
          ONLine        := false;
          DesConecTelef := true;              // Si se pierde la comunicación me desconecto
        end;
      end;
      //ESTO AVISA AL FORMULARIO QUE DATOS NUEVOS, PARA QUE VUELVA A RENDERIZARSE Y SE VEA EN PANTALLA
      // USO SYNCHRONIZE PARA EVITAR ERRORES DE PANTALLA (VCL/LCL no es thread-safe)
      if Assigned(pActualizar) then Synchronize(SyncActualizar); 
      //pActualizar(Self);                      // Actualizo la info en pantalla

      // Configuro las variables básicas del Equipo
      //ESTO VERIFICA SI EL USUARIO CAMBIO ALGUNA CONFIGURACION PARA EL EQUIPO
      //SI SE CAMBIO ALGO, ConfigEquipo ESTA EN TRUE.
      if ConfigEquipo  and ONLine then begin
        //ESCRIBE LA NUEVA CONFIGURACION DEL EQUIPO
        EscribirConfig;
        ConfigEquipo := false;
      end;
  //SI HAY QUE CONFIGURAR INTERNET (POR AHORA NO LO VEREMOS)
      // Configuro las variables de internet del Equipo
      if ConfigInternetEquipo  and ONLine then begin
        EscribirConfigInternet;
        ConfigInternetEquipo := false;
      end;
//SI HAY QUE DESCARGAR UN HISTORIAL DE INFORMACION
      // Descargo los datos almacenado en la memoria del Equipo 
      if DescargarDatos and ONLine then begin
        DescargarDatos := false;
        DescargarLosDatos;                   // Procedimiento que guarda los datos en el disco con cierto formato
      end;
    except
      Mercury.Configurar := false;
    end;
  end;
  //SE EJECUTA EL BUCLE CONSTANTEMENTE, ESPERANDO OTRO 'CE'
end;

////////////////////////////////////////////////////////////////////////////////
procedure TThreadComm.LeerConfig;
var
  NCanal   : byte;
  NBloque  : integer;
  IndiceCanalReal : integer;
  numDate  : double;
  num      : integer;
  FechaINI : double;
  auxStr   : string;
  i        : integer;
  BytesOcupadosData: Integer;
  BytesOcupadosConf: Integer;
  BytesToRead      : Integer;
  NumBloques       : Integer;
  fLog             : TextFile;
begin
  auxStr := '';
  
  // Calculate Frame Size logic:
  // For each 8-channel block: 8 analog + 2 digital alternates = 10 channels × 2 bytes = 20 bytes
  // So the total is ((CantCanales / 8) * 10) * 2 bytes for data
  //   8ch  = 10 channels = 20 bytes
  //   16ch = 20 channels = 40 bytes
  //   24ch = 30 channels = 60 bytes
  //   32ch = 40 channels = 80 bytes
  // Config: CantCanales * 1 byte (no change for config, no digital config)
  
  // Determine number of 8-channel blocks (1, 2, 3, or 4)
  if CantCanales <= 8 then NumBloques := 1
  else if CantCanales <= 16 then NumBloques := 2
  else if CantCanales <= 24 then NumBloques := 3
  else NumBloques := 4; // 32 channels
  
  // Data bytes: analog + digital channels
  // Each block has 8 analog (16 bytes) + 2 digital (4 bytes) = 20 bytes per block
  BytesOcupadosData := NumBloques * 20;
  BytesOcupadosConf := CantCanales * 1 + 2 * NumBloques; // 2 digitales por bloque
  
  // Total Frame calculation:
  // Data (BytesOcupadosData) + 
  // Time (4) + StartTime (4) + Interval (2) + Bytes Skipped (2) +
  // Config (BytesOcupadosConf) + 
  // Name (4) + Memory (4)
  BytesToRead := BytesOcupadosData + 4 + 4 + 2 + 2 + BytesOcupadosConf + 4 + 4;

  if not PSerie.LeerDelPuertoSerie(auxStr, BytesToRead) then exit;
  
  // 1. Read Channel Values
  i := 1;
  // We iterate through whatever channels we have configured (CantCanales)
  // The 'auxStr' contains padding bytes that we need to skip if we cross block boundaries,
  // but the simple logic is: read block by block.
  // However, simpler approach: Just consume bytes linearly and skip padding at end of blocks?
  // Let's stick to the user's definition: "20 bytes for 8 channels".
  // So bytes 1..16 are data for ch 0..7. Bytes 17..20 are padding.
  // Bytes 21..36 are data for ch 8..15. Bytes 37..40 are padding.
  
  // Implementation note: Read data in blocks of 10 channels (8 analog + 2 digital)
  // Each block is 20 bytes (10 channels × 2 bytes)
  // DEBUG LOGGING START
  AssignFile(fLog, 'debug_mercury.txt');
  try
    if FileExists('debug_mercury.txt') then Append(fLog) else Rewrite(fLog);
    Writeln(fLog, '--- LECTURA CE (Values) --- Channels: ' + IntToStr(CantCanales) + ' Blocks: ' + IntToStr(NumBloques));
  except
    // Safe fail if file access denied
  end;

  // Process each 8-channel block (analog + digital)
  for NBloque := 1 to NumBloques do begin
    // Read 8 analog channels for this block
    for NCanal := 0 to 7 do begin
      IndiceCanalReal := ((NBloque - 1) * 8) + NCanal;
      
      // Only read if this channel exists in our configuration
      if IndiceCanalReal < CantCanales then begin
        // Read 2 bytes for channel data
        num := Byte(auxStr[i]) + Byte(auxStr[i+1])*256;
        
        // LOG VALUE
        try
          Writeln(fLog, Format('Block%d CH%d(real:%d) Val: %d', [NBloque, NCanal, IndiceCanalReal, num]));
        except
        end;
        
        pvalorCH[IndiceCanalReal]^ := num;
      end;
      inc(i, 2);
    end;
    // Read 2 digital channels for this block (alternatives A and B)

    // Digital A (e.g., ch 8 for block 0, ch 16 for block 1...)
    num := Byte(auxStr[i]) + Byte(auxStr[i+1])*256;
    pvalorDigA[NBloque-1] := num;
    try
      Writeln(fLog, Format('Block%d DigA Val: %d', [NBloque, num]));
    except
    end;
    inc(i, 2);
    
    // Digital B (e.g., ch 9 for block 0, ch 17 for block 1...)
    num := Byte(auxStr[i]) + Byte(auxStr[i+1])*256;
    pvalorDigB[NBloque-1] := num;
    try
      Writeln(fLog, Format('Block%d DigB Val: %d', [NBloque, num]));
    except
    end;
    inc(i, 2);

  end;
  
  try
    CloseFile(fLog);
  except
  end;
  
  // Safety sync: Data section ends at Start + BytesOcupadosData
  // i started at 1. It should now be 1 + BytesOcupadosData.
  //i := 1 + BytesOcupadosData; 

  // 2. Read Time (4 bytes)
  // ... rest of the function ... (Keeping original structure for now)
  // We will need to offset 'i' for subsequent reads.
  
  // Since original code hardcoded indices (21, 25...), we must update them to be relative to 'i'.
  
  // Leo la Hora del Equipo (4 bytes)
  numDate := Byte(auxStr[i])+Byte(auxStr[i+1])+ Byte(auxStr[i+2])+Byte(auxStr[i+3])+
             Byte(auxStr[i+1])*255+Byte(auxStr[i+2])*65535+Byte(auxStr[i+3])*16777215; // Original weird formula
             
  // Better parsing:
  // numDate := ... (keeping strict original logic to avoid breaking legacy math quirks if any)
  numDate := Byte(auxStr[i]) + Byte(auxStr[i+1])*256 + Byte(auxStr[i+2])*65536 + Byte(auxStr[i+3])*16777216;
  // Actually, let's stick to the original formula structure to be safe, just adjusting 'i'.
  
  numDate := Byte(auxStr[i])+Byte(auxStr[i+1])+ Byte(auxStr[i+2])+Byte(auxStr[i+3])+
             Byte(auxStr[i+1])*255+Byte(auxStr[i+2])*65535+Byte(auxStr[i+3])*16777215;

  numDate := numDate/86400 + StrToDateTime(Hora_Base);
  pHoraEquipo^ := numDate;
  pHoraActual^ := now;
  inc(i, 4); 

  // 3. Read Start Measurement Time (4 bytes)
  numDate  := Byte(auxStr[i])+Byte(auxStr[i+1])+ Byte(auxStr[i+2])+Byte(auxStr[i+3])+
              Byte(auxStr[i+1])*255+Byte(auxStr[i+2])*65535+Byte(auxStr[i+3])*16777215;
  FechaINI      := numDate/86400 + StrToDateTime(Hora_Base);
  pIniMuestreo^ := FechaINI;
  inc(i, 4);

  // 4. Read Sampling Interval (2 bytes)
  pTmuestreo^ := (Byte(auxStr[i])+Byte(auxStr[i+1])+Byte(auxStr[i+1])*255);
  inc(i, 2);

  // Bytes skipped for firmware (2 bytes)
  inc(i, 2);

  // 5. Read Channel Config (10 bytes per block -> 8 bytes config + 2 bytes padding)
  for NCanal := 0 to CantCanales - 1 do begin
      pCH_conf[NCanal]^ := Byte(auxStr[i]);
      inc(i, 1);
      
      // ACÁ DEBERÍA VER CONFIGURACIÓN DE DIGITALES
      // If end of block (every 8 channels), skip 2 bytes padding
      //if ((NCanal + 1) mod 8 = 0) then
      //   inc(i, 2);
  end;
  
  // Re-sync 'i' just in case
  // Start of Config was at: 1 + BytesOcupadosData + 4 + 4 + 2
  // End of Config is at: Start + BytesOcupadosConf
  // Current i should match that.
  i := 1 + BytesOcupadosData + 4 + 4 + 2 + 2 + BytesOcupadosConf;

  // 6. Read Equipment Name (4 bytes)
  pNombre^ := auxStr[i]+auxStr[i+1]+auxStr[i+2]+auxStr[i+3];
  
  // SANITIZE NAME: remove invalid chars for filenames
  // Strict whitelist to avoid any filesystem errors
  if not (pNombre^[1] in ['A'..'Z', 'a'..'z', '0'..'9', '_', '-', ' ']) then pNombre^[1] := '_';
  if not (pNombre^[2] in ['A'..'Z', 'a'..'z', '0'..'9', '_', '-', ' ']) then pNombre^[2] := '_';
  if not (pNombre^[3] in ['A'..'Z', 'a'..'z', '0'..'9', '_', '-', ' ']) then pNombre^[3] := '_';
  if not (pNombre^[4] in ['A'..'Z', 'a'..'z', '0'..'9', '_', '-', ' ']) then pNombre^[4] := '_';
  inc(i, 4);

  // 7. Read Memory Used (4 bytes)
  pMemoria^ := Byte(auxStr[i])+Byte(auxStr[i+1])+Byte(auxStr[i+2])+Byte(auxStr[i+1])*255+Byte(auxStr[i+2])*65535; // Keeping original weird formula
  // Note: Original read 3 bytes? "Byte(auxStr[i])+Byte(auxStr[i+1])+Byte(auxStr[i+2])..."
  // User said "4 bytes para la memoria ocupada".
  // Original code: i:=47. Frame length 50. 50-47+1 = 4 bytes (47,48,49,50). 
  // Wait, original was reading 50 bytes total.
  // Original map:
  // 1..20 (Data 10ch?? No, loop was length(pvalorCH)-1. Defaut 10 chans. 20 bytes.)
  // 21..24 (Hora)
  // 25..28 (IniMuestreo)
  // 29..30 (TMuestreo)
  // 31..32 (Gap?) Original i=33 for config. 31,32 skipped?
  // 33..42 (Config 10ch)
  // 43..46 (Nombre)
  // 47..49 (Memoria Ocupada)
  // 50 (Memoria Total)

  // User instruction: "4 bytes para la memoria ocupada".
  // Let's explicitly read 4 bytes for memory.
  // Keeping safe implementation.
end;

////////////////////////////////////////////////////////////////////////////////
procedure TThreadComm.EscribirConfig;
var
  auxStr  : string;
  hora    : longint;
  Abytes  : TAbytes;
  HoraAux : double;
  i       : integer;
  Tt      : integer;   // Periodo auxiliar de muestreo

begin
  // Calculos de los Valores Nuevos de Configuración //
//SE CONVIERTE LA HORA, A BYTES INDIVUDUALES
  // Nueva hora del Equipo la paso a un formato de 4 bytes
  hora   := round((now-StrToDateTime(Hora_Base))*86400);
  ABytes := NumToAbytes(hora);
  Hora00 := Abytes[0];
  Hora01 := Abytes[1];
  Hora02 := Abytes[2];
  Hora03 := Abytes[3];
//ACA HACE UN REDONDEO 
//SI SE VA A MUESTREAR CADA 10 MINUTOS, Y SON LAS 10:14, EL MUESTREO ESPERA A LAS 10:20 PARA EMPEZAR
  // Cálculo la hora del inicio de muestreo
  if (T<60) then Tt := 60 else Tt := T;
  HoraAux := trunc(now*24)/24;
  while (HoraAux <= (now + 2/86400)) do begin
    HoraAux := HoraAux + Tt/86400; // Paso el T a Días para poder Sumar con la Fecha Actual
  end;
  ABytes := NumToAbytes( round((HoraAux-StrToDateTime(Hora_Base))*86400) );
  IniMuest00 := Abytes[0];
  IniMuest01 := Abytes[1];
  IniMuest02 := Abytes[2];
  IniMuest03 := Abytes[3];

  // Cálculo del nuevo periodo de muestreo
  ABytes := NumToAbytes(T);
  T00    := ABytes[0];
  T01    := ABytes[1];

  // Calculo la cuenta regresiva para muestrear
  ABytes := NumToAbytes( round((HoraAux-now)*86400) );
  Tregre00 := ABytes[0];
  Tregre01 := ABytes[1];
//DE ACA NO HABRIA QUE TOCAR MUCHO
//LO IMPORTANTE ES SABER QUE TODA ESTA INFORMAICON OCUPA 12 BYTES.
//4 BYTES PARA LA HORA DEL EQUIPO, 4 PARA HORA DE INICIO DE MUESTREO...
//2 PARA EL INICIO DE MUESTREO, Y 2 PARA CUENTA REGRESIVA

  //--------------------------------------------------------------------------//
  //ENVIA 'CE' PARA AVISARLE AL EQUIPO QUE VA A EMPEZAR UNA CONFIGURACION
  // Escribo el codigo para que entre a la subrrutina
  if not PSerie.EscribirAlPuertoSerie('CE') then exit;

//ESPERA HASTA RECIBI 'OKDEL EQUIPO'
  // Espero la señal ("OK") que indica que esta listo para recibir la nueva config
  i      := 0;
  auxStr := '';
  while ((auxStr <> 'OK') and (i<=200)) do begin
    if not PSerie.LeerDelPuertoSerie(auxStr,2) then break;
    inc(i,1);
  end;
//SI NO SE RECIBIO NADA EN 200 ITERACIONES SE CORTA LA CONFIGURACION
  // Me aseguro que si hay problemas aborto
  if (i>200) then exit;
//MANDA LOS 4 BYTES DE LA HORA
  // Escribo la nueva hora al equipo
  PSerie.EscribirAlPuertoSerie(chr(Hora00));
  PSerie.EscribirAlPuertoSerie(chr(Hora01));
  PSerie.EscribirAlPuertoSerie(chr(Hora02));
  PSerie.EscribirAlPuertoSerie(chr(Hora03));
//aca hay que trabajar 
//MANDA LOS 4 BYTES DEL INICIO DE MUESTREO
  // Escribo la nueva hora de inicio del muestreo
  PSerie.EscribirAlPuertoSerie(chr(IniMuest00));
  PSerie.EscribirAlPuertoSerie(chr(IniMuest01));
  PSerie.EscribirAlPuertoSerie(chr(IniMuest02));
  PSerie.EscribirAlPuertoSerie(chr(IniMuest03));
//MANDA LOS 2 BYTES DEL PERIODO DE MUESTREO
  // Escribo el nuevo periodo de muestreo
  PSerie.EscribirAlPuertoSerie(chr(T00));
  PSerie.EscribirAlPuertoSerie(chr(T01));
//MANDA LOS 2 BYTES DE LA CUENTA REGRESIVA
  // Escribo la Cuenta regresiva para muestrear
  PSerie.EscribirAlPuertoSerie(chr(Tregre00));
  PSerie.EscribirAlPuertoSerie(chr(Tregre01));
  //MANDA LA CONFIGURACION DE CADA CANAL.
  // SE ADAPTA A BLOQUES DE 8 CANALES (10 bytes = 8 config + 2 padding)
  
  for i:=0 to CantCanales - 1 do begin
      PSerie.EscribirAlPuertoSerie(chr(ConfigCHs[i]));
      
      // If end of block (every 8 channels), send 2 bytes padding
      if ((i + 1) mod 8 = 0) then begin
         PSerie.EscribirAlPuertoSerie(chr(0)); // Padding
         PSerie.EscribirAlPuertoSerie(chr(0)); // Padding
      end;
  end;

  //ENVIA 4 BYTES PARA EL NOMBRE
  // Escribo el Nombre del Equipo
  PSerie.EscribirAlPuertoSerie(NombreEquipo[1]);
  PSerie.EscribirAlPuertoSerie(NombreEquipo[2]);
  PSerie.EscribirAlPuertoSerie(NombreEquipo[3]);
  PSerie.EscribirAlPuertoSerie(NombreEquipo[4]);
  //TOTAL: Variable dependent on CantCanales
 
  if AutoDesconecConf then DesConecTelef := true;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TThreadComm.DescargarLosDatos;
var
  i          : byte;
  lineaAux1  : string;
  lineaAux2  : string;

begin
  // Configuro las varables para adaptar la descarga con el formato elegido
  case FormatoDescarga of
    0 : begin //Texto (delimitado por tabulaciones)
          sep        := #9;
          Archivo    := Archivo +'.txt';
        end;

    1 : begin //CSV - Planilla de cálculo (formato en español)
          sep        := ';';
          Archivo    := Archivo +'.csv';
        end;

    2 : begin //CSV - Planilla de cálculo (formato en ingles)
          sep        := ',';
          Archivo    := Archivo +'.csv';
        end;

    3 : begin //Página Web
          sep        := #9;
          Archivo    := Archivo +'.txt';
        end;
  end;

  // Configuro las varable para adaptar la fecha con el formato elegido
  //FormatoFecha := Mercury.ObtenerFormatoFecha(IndiceFormatoFe);
  
  // Me aseguro que no alla ningún dato previo
  Datos.Clear;

  // Incorporo la info en el archivo de texto y los titulos
  with Datos do begin
    Add('Datos Generales');
    Add('--------------------------');
    Add('Nombre del Equipo '  +sep+': '+ pNombre^);
    Add('Intervalo de Captura'+sep+': '+ Mercury.GenerarStrTmuest(pTmuestreo^)); //FloatToStr(pTmuestreo^ div 60)+' min');
    Add('Hora del Equipo   '  +sep+': '+ Mercury.GenerarStringFecha(IndiceFormatoFe, pHoraEquipo^));//FormatDateTime(FormatoFecha, pHoraEquipo^));
    Add('Hora de la PC     '  +sep+': '+ Mercury.GenerarStringFecha(IndiceFormatoFe, pHoraActual^)); //FormatDateTime(FormatoFecha, pHoraActual^));
    Add('');
    Add('');

    // Descripción de los canales
    Add('Descripción de los Canales');
    Add('--------------------------');

    for i:=0 to length(pCH_conf)-1 do begin
      if (pCH_conf[i]^ > 0) then begin
        Add('CH '+IntToStr(i)+sep+': '+ pASensor^[i].Descripcion +
            ' ' + '[' + pASensor^[i].Unidad+']');
      end;
    end;
    Add('');
    Add('');


    // Descripción de los valores calculados
    Add('Valores Calculados');
    Add('--------------------------');

    for i:=0 to pCalcParam^.CantParm-1 do begin
      if (pCalcParam^.Parametros[i].Calcular = 1) then begin
        Add('VC '+IntToStr(i)+sep+': '+ pCalcParam^.Parametros[i].Descripcion +
            ' ' + '[' + pCalcParam^.Parametros[i].Unidad+']');
      end;       
    end;
    Add('');
    Add('');

    // Titulos de la tabla de los valores de los canales y los valores Calculados
    lineaAux1 := 'Fecha y Hora           ' + sep;
    lineaAux2 := '-----------------------' + sep;

    // Titulos de la tabla de los valores de los canales
    for i:=0 to length(pCH_conf)-1 do begin
      if (pCH_conf[i]^ > 0) then begin
        lineaAux1 := lineaAux1 + 'CH ' + IntToStr(i) + sep;
        lineaAux2 := lineaAux2 + '----' + sep;
      end;
    end;

    // Titulos de la tabla de los valores Calculados
    for i:=0 to pCalcParam^.CantParm-1 do begin
      if (pCalcParam^.Parametros[i].Calcular = 1) then begin
        lineaAux1 := lineaAux1 + 'VC ' + IntToStr(i) + sep;
        lineaAux2 := lineaAux2 + '----' + sep;
      end;
    end;

    Add(lineaAux1);
    Add(lineaAux2);
  end;

  // Leo los datos del equipo
  LeerDatos;

  // Me desconecto de la conexión remota
  if AutoDesconecDesc then DesConecTelef := true;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TThreadComm.LeerDatos;
var
  auxStr     : string;
  Nbytes     : LongInt;
  i,j,k      : LongInt;
  linea      : string;
  num        : integer;
  progresoOLD: integer; 
  NCanal     : byte;
  MaxCanales : byte;
  IniMuestr  : double;
  periodo    : real;
  Nlineas    : integer;
  CanalesAct : array of byte;

begin
  Nbytes     := pMemoria^;
  IniMuestr  := pIniMuestreo^;
  periodo    := (pTmuestreo^);

  // Periodo de muestreo de 500 mseg.
  if (periodo = 0) then periodo := Tmin;  

  // Analiso cual son los canales activos
  SetLength(CanalesAct,0);
  for i:=0 to CantCanales-1 do begin
    if (pASensor^[i].Config > 0) then begin
      SetLength(CanalesAct,length(CanalesAct)+1);
      CanalesAct[length(CanalesAct)-1] := i;
    end;
  end;
  MaxCanales := length(CanalesAct);

  if (MaxCanales > 0) and (Nbytes > 4)then begin
    // Escribo el codigo para que entre a la subrrutina ("L"eer "D"atos)
    if not PSerie.EscribirAlPuertoSerie('LD') then exit;

    // Espero que me envie el equipo el codigo "DG" Datos Guardados, para Sincronizar
    i      := 0;
    auxStr := '';
    while ((auxStr <> 'DG') and (i<=200)) do begin
      if not PSerie.LeerDelPuertoSerie(auxStr,2) then break;
      inc(i,1);
    end;

    // Me aseguro que si hay problemas aborto
    if (i>200) then exit;

    // Inicializo el Progreso
    progresoOLD := 0;
    pProgreso^  := 0;
    pActualProgres(self);

    // Leo los Datos
    NCanal  := 0;
    Linea   := '';
    Nlineas := 0;

    // Estos primeros 4 datos son la cantidad de memoria ocupada, no le doy importancia
    PSerie.LeerDelPuertoSerie(auxStr,2);
    PSerie.LeerDelPuertoSerie(auxStr,2);
    
    for i:=3 to (Nbytes div 2) do begin
      auxStr := '';
      if not PSerie.LeerDelPuertoSerie(auxStr,2) then break;

      num := Byte(auxStr[1])+Byte(auxStr[2])+Byte(auxStr[2])*255;
      pASensor^[CanalesAct[NCanal]].ComputarValor(num);

      if length(Linea)>0 then Linea := Linea + sep + pASensor^[CanalesAct[NCanal]].ValorReal
      else Linea := pASensor^[CanalesAct[NCanal]].ValorReal;

      inc(NCanal,1);
      if (NCanal > MaxCanales-1) then begin
        // Computo el valor de los parametros a calcular, salinidad, densidad...
        for j:=0 to pCalcParam^.CantParm-1 do begin
          with pCalcParam^.Parametros[j] do begin
            if (Calcular = 1) then begin
              // Cargo la info de los valores de entrada temp, cond, profundidad...
              for k:=0 to Nparam-1 do begin
                if (AParam[k].canal >= 0) then AParam[k].valor := pASensor^[AParam[k].canal].ValorNum
                else AParam[k].valor := 0;
              end;

              // Calculo los parámetros salinidad, densidad.....
              pCalcParam^.CalcularValorParam(j);

              // Incorporo la info del parametro calculado a la linea
              Linea := Linea + sep + ResultCalcStr;
            end;
          end;
        end;

        // Incorporo la linea a la info total, que se guarda en el archivo
        Datos.Add(Mercury.GenerarStringFecha(IndiceFormatoFe,IniMuestr+Nlineas*(periodo/86400))+sep+Linea);
        NCanal := 0;
        Linea  := '';
        inc(NLineas,1);
      end;

      //pProgreso^ := trunc(((2*i)/Nbytes)*100);
      pProgreso^ := 2*i;
      if not (pProgreso^ = progresoOLD) then  pActualProgres(self);
      progresoOLD := pProgreso^;
    end;

    try
        if not FileExists(Archivo) then Datos.SaveToFile(Archivo)
        else if DeleteFile(PChar(Archivo)) then Datos.SaveToFile(Archivo);
    except
        MessageBox(Handle,PChar('No se puede escribir en "'+ Archivo + '".'+
                   #13+'La carpeta no existe o no tiene permiso de escritura.') ,
                   PChar('Descarga'), MB_OK	or MB_ICONINFORMATION );

        // Me aseguro que no borre la memoria automaticamente si hubo problemas  
        Mercury.Configurar := false;
    end;
  end;

  pProgreso^ := 0;
  pActualProgres(self);
  SetLength(CanalesAct,0);
end;

// Comunicación Telefonica (Puerto Serie) 
////////////////////////////////////////////////////////////////////////////////
procedure TThreadComm.ConectarTelefon;     // Inicia el protocolo de Conección
begin
  // Escribo el codigo para conectar al equipo
  if not PSerie.EscribirAlPuertoSerie('atd'+Ntelefono+#13) then exit;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TThreadComm.DesConectarTelefon;  // Corta la comunicación telefonica
begin
  // Escribo el codigo para conectar al equipo
  if not PSerie.EscribirAlPuertoSerie('ath'+#13) then exit;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TThreadComm.IniComTelefon; // Inicializa el hardware de la comunicación telefónica
begin
  // Escribo el codigo para resetear el hardware de la comunicación telefónica 
  if not PSerie.EscribirAlPuertoSerie('atz'+#13) then exit;
end;

////////////////////////////////////////////////////////////////////////////////
// Comunicación por Internet (TCP/IP)
procedure TThreadComm.EscribirConfigInternet;
var
  strIni     : string;
  strFin     : string; 
  strGateway : string;
  strServer  : string;
  auxStr     : string;
  Abytes     : TAbytes;
  i          : byte;

begin
  // Genero el String de Inicialización del modem
  strIni := 'ATE0'+#13+'ATE0'+#13+'AT+CMGF=1'+#13+'AT+CNMI=3,2,2,0,0'+#13+'AT+CMGD=1,4'+#13
             +'AT+CREG=1'+#13;

  // Genero el String del gateway   "internet.ctimovil.com.ar","gprs","gprs"
  strGateway := 'AT+MIPCALL=1,"'+gateway+'","'+user+'","'+pass+'"'+#13+'/';

  // Genero el String del server    40000,"168.96.131.146",40000,0
  strServer := 'AT+MIPOPEN=1,'+port+',"'+server+'",'+port+',0'+#13+'/';

  // Genero el String de finalización del modem
  ABytes := NumToAbytes(CalcPeriodoConect(IndexTConect));
  strFin := chr(Abytes[1])+chr(Abytes[0])+'AT+MIPCLOSE=1'+#13+'/'+'AT+MIPCALL=0'+#13+'/';
  //strFin := chr(CalcPeriodoConect(IndexTConect))+'AT+MIPCLOSE=1'+#13+'/'+'AT+MIPCALL=0'+#13+'/';

  // Escribo toda la config de internet
  auxStr := strIni + strGateway + strServer + ';' + strFin + '#';

  PSerie.EscribirAlPuertoSerie('GA');
  for i:=1 to length(auxStr) do begin
    PSerie.EscribirAlPuertoSerie(auxStr[i]);
    retardo(5);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
function TThreadComm.CalcPeriodoConect(index: byte):integer;
var
  P : integer;
  i : byte;
  N : byte;
  T : real; // Periodo de muestreo en seg.

begin
  N := 0;
  T := pTmuestreo^;
  if (T=0) then T:=Tmin; 

  for i:=0 to length(pvalorCH)-1 do
    if pCH_conf[i]^>0 then inc(N,1);

  case index of
    // Conectar Simpre
    0 : P := 0;
    // Conectar cada 1/2 hora
    1 : P := round(30/(T/60))-1;
    // Conectar cada 1 hora
    2 : P := round(60/(T/60))-1;
    // Conectar cada 2 horas
    3 : P := round(2*60/(T/60))-1;
    // Conectar cada 4 horas
    4 : P := round(4*60/(T/60))-1;
    // Conectar cada 6 horas
    5 : P := round(6*60/(T/60))-1;
    // Conectar cada 8 horas
    6 : P := round(8*60/(T/60))-1;
    // Conectar cada 10 horas
    7 : P := round(10*60/(T/60))-1;
    // Conectar cada 12 horas
    8 : P := round(12*60/(T/60))-1;
    // Conectar cada 24 horas
    9 : P := round(24*60/(T/60))-1;
    // Óptima, minimo costo de comunicación
    10: P := round(980/(N*2)); // 980 son los bytes maximos que meto en un paquete
  else
    P :=0;
  end;

  // Me aseguro que este en rango.
  if P>65535 then P:= 65535;
  if P<0   then P:= 0;

  // Me aseguro que como minimo no se re-conecte en un periodo menor a 10 min.
  if ((T<600) and (P<600/T)) then P:=round(600/T)-1;

  result := P;
end;

////////////////////////////////////////////////////////////////////////////////
// Funciones de Uso Generales //////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
Procedure Retardo(tiempo:integer);
var
  evento : Tevent;
begin
  evento := Tevent.Create(nil,true,false,'');
  evento.WaitFor(tiempo);
  evento.Free;
end;

////////////////////////////////////////////////////////////////////////////////
function NumToAbytes(num : longint):TAbytes;
var
  resto  : byte;
  pos    : byte;
  i,j    : integer;
  Abytes : TAbytes;

begin
  // Inicializo el arreglo;
  for i:=0 to length(Abytes)-1 do Abytes[i] :=0;

  // Si es negativo entonces 0
  if (num < 0) then num := 0;

  // El numero lo paso a un formato de 4 bytes
  pos  := 0;
  for i:=0 to 8*length(Abytes)-1 do begin
    j         := i div 8;
    resto     := num mod 2;
    num       := num div 2;
    Abytes[j] := Abytes[j]+ trunc(resto*power(2,pos));

    inc(pos,1);
    if pos>7 then pos := 0;
  end;
  Abytes[j] := Abytes[j]+ trunc(num*power(2,7));

  result := Abytes;
end;

end.
