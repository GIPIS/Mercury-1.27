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
      NuevaConfiguracionRemota : boolean;  // Indica si se recibio una nueva configuracion desde el equipo
      PendingUserConfig : boolean;           // Indica que el usuario selecciono un sensor pero no confirmo aun

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
      DebugMsg         : string;           // Variable para debug seguro      

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

  // Record que contiene todos los datos parseados de una trama CE del equipo.
  // Usado por ParsearTramaCE como estructura de retorno compartida entre
  // TThreadComm (serie/telefono) y TServEquipoThread (internet).
  TConfigEquipo = record
    Valores     : array of integer;  // Valores crudos de sensores (CantCanales)
    Hora        : TDateTime;         // Hora del equipo
    IniMuestreo : TDateTime;         // Fecha inicio muestreo
    Tmuestreo   : integer;           // Periodo en segundos
    ConfigCHs   : array of byte;     // Configuracion de cada canal (CantCanales)
    Nombre      : string;            // Nombre del equipo (4 chars)
    Memoria     : longint;           // Bytes ocupados
    CantMemory  : integer;           // Capacidad total
    BadChrsName : boolean;           // Nombre con caracteres invalidos
    NombreRaw   : string;            // Nombre original si BadChrsName=true
  end;

  // Funciones y Procedimientos de uso generales
  Procedure Retardo(tiempo:integer);
  function  NumToAbytes(num : longint):TAbytes;

  // Protocolo compartido: parseo y construccion de tramas binarias CE.
  // Estas funciones son puras (sin dependencia de transporte) y pueden
  // ser usadas tanto por TThreadComm (serie) como por TServEquipoThread (internet).
  function  ParsearTramaCE(const auxStr: string; CantCanales: byte;
                            var Config: TConfigEquipo): boolean;
  function  ConstruirTramaConfig(T: integer; CantCanales: byte;
                            const ConfigCHs: array of byte;
                            const NombreEquipo: string;
                            DelayCom: integer): string;

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
  NuevaConfiguracionRemota := false;
  PendingUserConfig := false;
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
  ConfigEquipo     := false;//telefonia Celular
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
  auxStr      : string;
  Config      : TConfigEquipo;
  BytesToRead : integer;
  NCanal      : integer;

begin
  // Estructura del frame LINEAL:
  // CantCanales x 2 bytes (valores) + 4 (hora) + 4 (fechaIni) + 2 (intervalo)
  // + 2 (gap fw) + CantCanales x 1 byte (config) + 4 (nombre) + 3 (memoria) + 1 (memTotal)
  // Total = CantCanales * 3 + 20
  BytesToRead := CantCanales * 3 + 20;

  auxStr := '';
  if not PSerie.LeerDelPuertoSerie(auxStr, BytesToRead) then exit;

  if not ParsearTramaCE(auxStr, CantCanales, Config) then exit;

  // Actualizar punteros compartidos con TEquipo
  for NCanal := 0 to CantCanales - 1 do
    pvalorCH[NCanal]^ := Config.Valores[NCanal];

  pHoraEquipo^  := Config.Hora;
  pHoraActual^  := now;
  pIniMuestreo^ := Config.IniMuestreo;
  pTmuestreo^   := Config.Tmuestreo;

  // Copiar la config recibida del equipo a pCH_conf.
  // Solo si el usuario NO tiene cambios pendientes (PendingUserConfig protege
  // los cambios hechos en la UI que aun no se confirmaron con EscribirConfig).
  if not PendingUserConfig then begin
    for NCanal := 0 to CantCanales - 1 do
      if Assigned(pCH_conf[NCanal]) then
        pCH_conf[NCanal]^ := Config.ConfigCHs[NCanal];
  end;

  pNombre^      := Config.Nombre;
  pMemoria^     := Config.Memoria;
  pCantMemory^  := Config.CantMemory;

  NuevaConfiguracionRemota := true;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TThreadComm.EscribirConfig;
var
  auxStr : string;
  trama  : string;
  i      : integer;

begin
  // IMPORTANTE: Copiar valores actuales de pCH_conf -> ConfigCHs antes de construir trama.
  // Los sensores se modifican en la UI (pCH_conf apunta a Canales[i].Config),
  // pero ConfigCHs es la copia local que se usa para enviar.
  for i := 0 to CantCanales - 1 do begin
    if Assigned(pCH_conf[i]) then ConfigCHs[i] := pCH_conf[i]^
    else ConfigCHs[i] := 0;
  end;

  //--------------------------------------------------------------------------//
  //ENVIA 'CE' PARA AVISARLE AL EQUIPO QUE VA A EMPEZAR UNA CONFIGURACION
  // Handshake serie: CE -> byte a byte -> espera OK
  if not PSerie.EscribirAlPuertoSerie('CE') then exit;

  //ESPERA HASTA RECIBIR 'OK' DEL EQUIPO
  i      := 0;
  auxStr := '';
  while ((auxStr <> 'OK') and (i<=200)) do begin
    if not PSerie.LeerDelPuertoSerie(auxStr,2) then break;
    inc(i,1);
  end;
  if (i>200) then exit;

  // Construir la trama con la funcion compartida (DelayCom=0 para cable/telefono)
  trama := ConstruirTramaConfig(T, CantCanales, ConfigCHs, NombreEquipo, 0);

  // Enviar trama completa por puerto serie
  PSerie.EscribirAlPuertoSerie(trama);

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

////////////////////////////////////////////////////////////////////////////////
// ParsearTramaCE: parsea el frame binario CE recibido del equipo.
// Funcion pura - sin dependencia de transporte (usada por TThreadComm y TServEquipoThread).
// La Hora_Base es siempre '01/01/2000 12:00 am' (constante del protocolo).
// Devuelve false si la trama es demasiado corta.
function ParsearTramaCE(const auxStr: string; CantCanales: byte;
                         var Config: TConfigEquipo): boolean;
const
  HoraBase = '01/01/2000 12:00 am';
var
  i, NCanal : integer;
  numDate   : double;
begin
  Result := false;
  if Length(auxStr) < CantCanales * 3 + 20 then Exit;

  SetLength(Config.Valores,   CantCanales);
  SetLength(Config.ConfigCHs, CantCanales);

  // 1. Valores de canales (CantCanales x 2 bytes)
  i := 1;
  for NCanal := 0 to CantCanales - 1 do begin
    Config.Valores[NCanal] := Byte(auxStr[i]) + (Byte(auxStr[i+1]) shl 8);
    inc(i, 2);
  end;

  // 2. Hora del equipo (4 bytes)
  numDate := Byte(auxStr[i]) + Byte(auxStr[i+1]) + Byte(auxStr[i+2]) + Byte(auxStr[i+3])
           + Byte(auxStr[i+1])*255 + Byte(auxStr[i+2])*65535 + Byte(auxStr[i+3])*16777215;
  Config.Hora := numDate / 86400 + StrToDateTime(HoraBase);
  inc(i, 4);

  // 3. Fecha inicio muestreo (4 bytes)
  numDate := Byte(auxStr[i]) + Byte(auxStr[i+1]) + Byte(auxStr[i+2]) + Byte(auxStr[i+3])
           + Byte(auxStr[i+1])*255 + Byte(auxStr[i+2])*65535 + Byte(auxStr[i+3])*16777215;
  Config.IniMuestreo := numDate / 86400 + StrToDateTime(HoraBase);
  inc(i, 4);

  // 4. Intervalo de muestreo (2 bytes)
  Config.Tmuestreo := Byte(auxStr[i]) + Byte(auxStr[i+1]) + Byte(auxStr[i+1])*255;
  inc(i, 2);

  // 5. Gap de firmware (2 bytes, ignorado)
  inc(i, 2);

  // 6. Configuracion de canales (CantCanales x 1 byte)
  for NCanal := 0 to CantCanales - 1 do
    Config.ConfigCHs[NCanal] := Byte(auxStr[i + NCanal]);
  inc(i, CantCanales);

  // 7. Nombre del equipo (4 bytes)
  Config.Nombre := auxStr[i] + auxStr[i+1] + auxStr[i+2] + auxStr[i+3];
  Config.BadChrsName := false;
  Config.NombreRaw   := '';
  inc(i, 4);

  // 8. Memoria ocupada (3 bytes)
  Config.Memoria := Byte(auxStr[i]) + Byte(auxStr[i+1]) + Byte(auxStr[i+2])
                  + Byte(auxStr[i+1])*255 + Byte(auxStr[i+2])*65535;
  inc(i, 3);

  // 9. Capacidad total de memoria (1 byte)
  Config.CantMemory := trunc(power(2, Byte(auxStr[i])));

  Result := true;
end;

////////////////////////////////////////////////////////////////////////////////
// ConstruirTramaConfig: construye el payload binario para EscribirConfig.
// Funcion pura - sin dependencia de transporte.
// DelayCom: compensacion en segundos del retardo de comunicacion (0 para serie, 1 para internet).
// Devuelve el string binario sin el prefijo 'CE' (cada transporte lo agrega como necesite).
function ConstruirTramaConfig(T: integer; CantCanales: byte;
                         const ConfigCHs: array of byte;
                         const NombreEquipo: string;
                         DelayCom: integer): string;
const
  HoraBase = '01/01/2000 12:00 am';
var
  hora    : longint;
  ABytes  : TAbytes;
  HoraAux : double;
  Tt, i   : integer;
begin
  Result := '';

  // Hora actual del equipo (4 bytes), con compensacion de retardo de comunicacion
  hora   := round((now - StrToDateTime(HoraBase)) * 86400) + DelayCom;
  ABytes := NumToAbytes(hora);
  Result := Result + chr(ABytes[0]) + chr(ABytes[1]) + chr(ABytes[2]) + chr(ABytes[3]);

  // Hora de inicio de muestreo: proximo multiplo del periodo T (4 bytes)
  // Si T < 60 seg, usar 60 seg como minimo para el calculo del inicio
  if (T < 60) then Tt := 60 else Tt := T;
  HoraAux := trunc(now * 24) / 24;
  while (HoraAux <= (now + 2/86400)) do
    HoraAux := HoraAux + Tt / 86400;
  ABytes := NumToAbytes(round((HoraAux - StrToDateTime(HoraBase)) * 86400));
  Result := Result + chr(ABytes[0]) + chr(ABytes[1]) + chr(ABytes[2]) + chr(ABytes[3]);

  // Periodo de muestreo T (2 bytes)
  ABytes := NumToAbytes(T);
  Result := Result + chr(ABytes[0]) + chr(ABytes[1]);

  // Cuenta regresiva hasta primer muestreo (2 bytes), compensada por retardo
  ABytes := NumToAbytes(round((HoraAux - now) * 86400) - DelayCom);
  Result := Result + chr(ABytes[0]) + chr(ABytes[1]);

  // Configuracion de cada canal (CantCanales bytes)
  for i := 0 to CantCanales - 1 do
    Result := Result + chr(ConfigCHs[i]);

  // Nombre del equipo (4 bytes fijos)
  Result := Result + NombreEquipo[1] + NombreEquipo[2]
                   + NombreEquipo[3] + NombreEquipo[4];
end;

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
