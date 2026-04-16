unit UEquipoInternet;

{$MODE Delphi}

interface
uses
  Windows, Registry, Classes, SysUtils, Dialogs, StdCtrls, SyncObjs, Math,
  UUtiles, UEquipo, PuertoSerie, IniFiles, USensor, UFormulas,
  Sockets, ExtCtrls, DateUtils, blcksock;

type
  TpTstrings = ^TStrings;

  ////////////////////////////////////////////////////////////////////////////
  // CAPA MODELO: TEquipoInternet hereda de TEquipo
  // Override de los metodos de persistencia para usar la estructura de
  // directorios de internet: DirINI+Nombre\conf\ (en vez de DirINI\Nombre\)
  ////////////////////////////////////////////////////////////////////////////
  TEquipoInternet = class(TEquipo)
  public
    function GuardarEquipo(DirINI: string): boolean; override;
    function CargarEquipo(DirINI: string): boolean; override;
    function BorrarEquipo(DirINI: string): boolean; override;
  end;

  ////////////////////////////////////////////////////////////////////////////
  // CAPA TRANSPORTE: TServEquipoThread
  // Hilo efimero: nace con cada conexion GPRS y muere al desconectarse.
  // Ciclo de vida diferente a TThreadComm (que es permanente).
  // Usa funciones compartidas de protocolo (ParsearTramaCE, ConstruirTramaConfig)
  // definidas en PuertoSerie.pas, y accede al modelo via Equipo:TEquipoInternet.
  ////////////////////////////////////////////////////////////////////////////
  TServEquipoThread = class(TThread)
  public
    // --- Socket y control ---
    FSocket        : TTCPBlockSocket;
    FClientTimeOut : integer;
    pTStrings      : TpTstrings;

    // --- Referencia al modelo (NO posee en construccion; destruye en Destroy) ---
    Equipo         : TEquipoInternet;

    // --- Config de Internet (exclusiva de este transporte) ---
    gateway             : string;
    user                : string;
    pass                : string;
    server              : string;
    port                : string;
    IndexTConect        : byte;

    // --- Flags de operacion ---
    ConfigEquipo        : boolean;
    ConfigInternetEquipo: boolean;
    ConfigTConect       : boolean;
    DescargarDatos      : boolean;
    DescargarDatosInst  : boolean;
    ONLine              : boolean;

    // --- Archivos de datos ---
    Archivo             : string;
    ArchivoBckDly       : string;
    ArchivoDesc         : string;
    path                : string;
    sep                 : string;
    Datos               : TStrings;
    FormatoDescarga     : byte;
    PeriodoDescarga     : byte;
    IndiceFormatoFe     : byte;
    BytesOcupados       : byte;
    ForzarVaLInsta      : char;

    // --- Nombre con caracteres problematicos ---
    NombreRaw           : string;
    BadChrsName         : boolean;

    // --- Info para configurar el equipo remoto ---
    NombreEquipo        : string;
    T                   : integer;
    ConfigCHs           : array of byte;

    // --- Constructor / Destructor ---
    constructor Create(StartSuspended: boolean; ClientSocketHandle: TSocket;
                       ClientTimeOut: integer; AEquipo: TEquipoInternet;
                       pTStrs: TpTstrings; Dirpath: string);
    destructor  Destroy; override;
    procedure   Execute; override;

    // --- Log al memo de historial (hilo-seguro via pTStrings) ---
    procedure   MensajeLog(mensaje: string);

    // --- Transporte TCP ---
    function    EscribirAlSocket(chs: string): boolean;
    function    LeerDelSocket(var chs: string; TamBuffer: integer): boolean;

    // --- Protocolo (usa ParsearTramaCE / ConstruirTramaConfig de PuertoSerie) ---
    procedure   LeerConfig;
    procedure   EscribirConfig;
    procedure   EscribirConfigInternet;
    procedure   EscribirConfigTConect;

    // --- Logica exclusiva de internet ---
    procedure   Limpiar;
    procedure   ConfigEntorno;
    function    CargarNuevaConf(DirINI: string): boolean;
    function    ForzarConfig(DirINI: string): boolean;
    function    ForzarDescarga(DirINI: string): boolean;
    function    ForzarValoresInstantaneos(DirINI: string): boolean;
    function    GuardarNuevaConf(DirINI: string): boolean;
    function    GuardarSensoresDisp(DirINI: string): boolean;
    function    CargarCanales(DirINI: string): boolean;
    function    CalcPeriodoConect(index: byte): integer;
    function    RupturaTransmision: boolean;
    procedure   GuardarValoresInstantaneos(TipoHora: byte);
    procedure   DescargarLosDatos;
    procedure   LeerDatos;
  end;

implementation

////////////////////////////////////////////////////////////////////////////////
// TEquipoInternet
// Los metodos de persistencia de TEquipo usan DirINI\Nombre\Nombre.ini
// Los de internet usan DirINI+Nombre\conf\Nombre.ini (estructura original).
// Override para mantener compatibilidad con los archivos existentes en disco.
////////////////////////////////////////////////////////////////////////////////

function TEquipoInternet.GuardarEquipo(DirINI: string): boolean;
var
  ArchivoINI : TIniFile;
  i          : integer;
  PathDir    : string;
begin
  PathDir    := DirINI + Nombre + '\conf\';
  ArchivoINI := TIniFile.Create(PathDir + Nombre + '.ini');
  try
    if not DirectoryExists(DirINI + Nombre) then MkDir(DirINI + Nombre);
    if not DirectoryExists(DirINI + Nombre + '\datos\') then MkDir(DirINI + Nombre + '\datos\');
    if not DirectoryExists(PathDir) then MkDir(PathDir);

    for i := 0 to NumCanales - 1 do begin
      ArchivoINI.WriteString(Nombre, 'CH' + IntToStr(i) + '_desc', Canales[i].Descripcion);
      ArchivoINI.WriteString(Nombre, 'CH' + IntToStr(i) + '_conf', IntToStr(Canales[i].Config));
    end;

    ArchivoINI.Free;
    CalcParam.GuardarParametros(PathDir + Nombre + '.ini', Nombre);
    ArchivoINI := TIniFile.Create(PathDir + Nombre + '.ini');

    ArchivoINI.WriteString(Nombre, '------', '------');

    for i := 0 to NumCanales - 1 do begin
      if (not FileExists(PathDir + Canales[i].Nombre + '.sen')) and (Canales[i].Config > 1) then
        Canales[i].GuardarEnArchivo(PathDir + Canales[i].Nombre + '.sen');
    end;

    ArchivoINI.Free;
    result := true;
  except
    ArchivoINI.Free;
    result := false;
  end;
end;

function TEquipoInternet.CargarEquipo(DirINI: string): boolean;
var
  ArchivoINI   : TIniFile;
  SeccionesINI : TStrings;
  i            : integer;
  AFiles       : AFilesOfDir;
  PathDir      : string;
begin
  PathDir      := DirINI + Nombre + '\conf\';
  SeccionesINI := TStringList.Create;
  ArchivoINI   := TIniFile.Create(PathDir + Nombre + '.ini');

  if not FileExists(ArchivoINI.FileName) then begin
    ArchivoINI.Free; SeccionesINI.Free;
    result := false; exit;
  end;

  ArchivoINI.ReadSections(SeccionesINI);

  if not ArchivoINI.SectionExists(Nombre) then begin
    ArchivoINI.Free; SeccionesINI.Free;
    result := false; exit;
  end;

  try
    for i := 0 to NumCanales - 1 do begin
      Canales[i].DescrINI  := ArchivoINI.ReadString(Nombre, 'CH' + IntToStr(i) + '_desc', '');
      Canales[i].ConfigINI := StrToInt(ArchivoINI.ReadString(Nombre, 'CH' + IntToStr(i) + '_conf', '0'));
      Canales[i].Config    := Canales[i].ConfigINI;
    end;

    CalcParam.CargarParametros(PathDir + Nombre + '.ini', Nombre);

    ExtractFilesOfDir(PathDir + '*.sen', AFiles);
    SetLength(ListaSenDir, Length(AFiles));
    for i := 0 to Length(AFiles) - 1 do begin
      ListaSenDir[i] := TSensor.Crear;
      ListaSenDir[i].CargarDeArchivo(PathDir + AFiles[i].Name);
    end;
  except
    ArchivoINI.Free; SeccionesINI.Free;
    result := false; exit;
  end;

  ArchivoINI.Free; SeccionesINI.Free;
  result := true;
end;

function TEquipoInternet.BorrarEquipo(DirINI: string): boolean;
var
  ArchivoINI   : TIniFile;
  SeccionesINI : TStrings;
  PathDir      : string;
begin
  PathDir      := DirINI + Nombre + '\conf\';
  SeccionesINI := TStringList.Create;
  ArchivoINI   := TIniFile.Create(PathDir + Nombre + '.ini');

  if not FileExists(ArchivoINI.FileName) then begin
    ArchivoINI.Free; SeccionesINI.Free;
    result := false; exit;
  end;

  ArchivoINI.ReadSections(SeccionesINI);

  if not ArchivoINI.SectionExists(Nombre) then begin
    ArchivoINI.Free; SeccionesINI.Free;
    result := false; exit;
  end;

  ArchivoINI.EraseSection(Nombre);
  ArchivoINI.Free; SeccionesINI.Free;
  result := true;
end;

////////////////////////////////////////////////////////////////////////////////
// TServEquipoThread
////////////////////////////////////////////////////////////////////////////////

constructor TServEquipoThread.Create(StartSuspended: boolean;
    ClientSocketHandle: TSocket; ClientTimeOut: integer;
    AEquipo: TEquipoInternet; pTStrs: TpTstrings; Dirpath: string);
begin
  inherited Create(StartSuspended);
  FreeOnTerminate := true;

  FSocket        := TTCPBlockSocket.Create;
  FSocket.Socket := ClientSocketHandle;
  FClientTimeOut := ClientTimeOut;
  pTStrings      := pTStrs;
  path           := Dirpath;

  // Referencia al modelo ya creado por UServerSocket
  Equipo := AEquipo;

  // Variables de operacion
  ConfigEquipo         := false;
  ConfigInternetEquipo := false;
  ConfigTConect        := false;
  DescargarDatos       := false;
  DescargarDatosInst   := false;
  ONLine               := false;
  Archivo              := 'NoNombre';
  ArchivoBckDly        := 'NoNombreBckDly';
  ArchivoDesc          := 'NoNombreDesc';
  sep                  := #9;
  BytesOcupados        := 4;
  BadChrsName          := false;
  NombreRaw            := '';
  ForzarVaLInsta       := 'N';

  SetLength(ConfigCHs, Equipo.NumCanales);

  // Datos es una TStringList local para armar archivos de salida
  Datos := TStringList.Create;
end;

////////////////////////////////////////////////////////////////////////////////
destructor TServEquipoThread.Destroy;
begin
  pTStrings := nil;

  // Liberar el modelo de equipo asociado a esta conexion
  if Assigned(Equipo) then begin
    Equipo.Destruir;
    Equipo := nil;
  end;

  FSocket.CloseSocket;
  FSocket.Free;
  Datos.Free;
  SetLength(ConfigCHs, 0);

  inherited Destroy;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TServEquipoThread.MensajeLog(mensaje: string);
var
  strHora : string;
begin
  if (pTStrings = nil) then exit;

  strHora := FormatDateTime('dd/mm/yy hh:nn:ss ', now);

  if Length(Equipo.Nombre) > 0 then
    if (Byte(Equipo.Nombre[1]) >= 48) then
      pTStrings^.Add(strHora + ' -> ' + Equipo.Nombre + ': ' + mensaje)
    else
      pTStrings^.Add(strHora + ' -> ' + 'unknown: ' + mensaje)
  else
    pTStrings^.Add(strHora + ' -> ' + mensaje);
end;

////////////////////////////////////////////////////////////////////////////////
procedure TServEquipoThread.Execute;
var
  auxStr : string;
begin
  Limpiar;
  DescargarDatos := true;

  auxStr := ' ';
  while (not Terminated) and (Length(auxStr) > 0) do begin
    try
      auxStr := '';
      ONLine := false;

      EscribirAlSocket('OK');

      if LeerDelSocket(auxStr, 2) then begin
        if (auxStr = 'CE') then begin
          ConfigEntorno;
          LeerConfig;
          CargarCanales(path);
          ConfigEquipo := true;
          ONLine       := true;

          if (Equipo.Memoria > (Equipo.CantMemory * 0.9)) then begin
            MensajeLog('--- Reiniciando registro. ---');
            DescargarDatos := false;
          end;
        end
        else ONLine := false;
      end
      else ONLine := false;

      if DescargarDatos and ONLine then begin
        Retardo(1000);
        DescargarLosDatos;
        DescargarDatos := false;
        Retardo(2000);
      end;

      if ConfigEquipo and ONLine then begin
        EscribirConfig;
        ConfigEquipo := false;
        Retardo(2000);
      end;

      if ConfigTConect and ONLine then begin
        EscribirConfigTConect;
        ConfigTConect := false;
        Retardo(2000);
      end;

      {
      if ConfigInternetEquipo and ONLine then begin
        EscribirConfigInternet;
        ConfigInternetEquipo := false;
        Retardo(2000);
      end;
      }
    except
      //
    end;
  end;
  // FSocket se cierra en Destroy
end;

////////////////////////////////////////////////////////////////////////////////
procedure TServEquipoThread.Limpiar;
var
  i : integer;
begin
  Equipo.Nombre    := '';
  Equipo.Tmuestreo := 60;
  for i := 0 to Equipo.NumCanales - 1 do Equipo.Canales[i].Limpiar;
  for i := 0 to Length(Equipo.ListaSenDir) - 1 do Equipo.ListaSenDir[i].Destruir;
  SetLength(Equipo.ListaSenDir, 0);
end;

////////////////////////////////////////////////////////////////////////////////
// Transporte TCP
////////////////////////////////////////////////////////////////////////////////

function TServEquipoThread.EscribirAlSocket(chs: string): boolean;
begin
  result := true;
  try
    FSocket.SendString(chs);
    if FSocket.LastError <> 0 then result := false;
  except
    result := false;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
function TServEquipoThread.LeerDelSocket(var chs: string; TamBuffer: integer): boolean;
var
  RequestBuf : string;
begin
  result := true;
  chs    := '';

  if FSocket.CanRead(FClientTimeOut) then begin
    try
      SetLength(RequestBuf, TamBuffer);
      RequestBuf := FSocket.RecvBufferStr(TamBuffer, FClientTimeOut);
      if Length(RequestBuf) >= TamBuffer then chs := RequestBuf
      else result := false;
    except
      result := false;
    end;
  end
  else result := false;
end;

////////////////////////////////////////////////////////////////////////////////
// Protocolo: usa funciones compartidas de PuertoSerie.pas
////////////////////////////////////////////////////////////////////////////////

procedure TServEquipoThread.LeerConfig;
var
  auxStr      : string;
  Config      : TConfigEquipo;
  BytesToRead : integer;
  NCanal      : integer;
begin
  MensajeLog('Leyendo la configuracion...');

  // Tamano dinamico: arregla el bug de indices hardcodeados (i=21, i=25, etc.)
  BytesToRead := Equipo.NumCanales * 3 + 20;
  if not LeerDelSocket(auxStr, BytesToRead) then exit;

  // Parsear con funcion compartida (misma logica que TThreadComm)
  if not ParsearTramaCE(auxStr, Equipo.NumCanales, Config) then exit;

  // Actualizar el MODELO (Equipo), no variables locales
  for NCanal := 0 to Equipo.NumCanales - 1 do begin
    Equipo.Canales[NCanal].ValorSensor := Config.Valores[NCanal];
    Equipo.Canales[NCanal].Config      := Config.ConfigCHs[NCanal];
  end;

  Equipo.Hora        := Config.Hora;
  Equipo.HoraPC      := now;
  Equipo.iniMuestr   := Config.IniMuestreo;
  Equipo.Tmuestreo   := Config.Tmuestreo;
  Equipo.Nombre      := Config.Nombre;
  Equipo.Memoria     := Config.Memoria;
  Equipo.CantMemory  := Config.CantMemory;
  BadChrsName        := Config.BadChrsName;
  NombreRaw          := Config.NombreRaw;

  MensajeLog('Configuracion recibida correctamente.');

  if (YearOf(Equipo.Hora) = YearOf(StrToDateTime('01/01/2000 12:00 am'))) then
    MensajeLog('!!Advertencia!! - Equipo Fuera de Linea.');
end;

////////////////////////////////////////////////////////////////////////////////
procedure TServEquipoThread.EscribirConfig;
var
  NewConf : string;
  trama   : string;
  i       : integer;
begin
  // Leer nueva config desde archivo INI en disco (puede haber cambios del operador)
  CargarNuevaConf(path);

  // Si el nombre tenia caracteres invalidos, usar el nombre raw para configurar
  if BadChrsName then begin
    NombreEquipo := NombreRaw;
    MensajeLog('!!Advertencia!! - Usando "RAW Name".');
  end;

  MensajeLog('Transmitiendo la nueva configuracion...');

  // Construir trama con funcion compartida (DelayCom=1 para compensar latencia GPRS)
  trama := ConstruirTramaConfig(T, Equipo.NumCanales, ConfigCHs, NombreEquipo, 1);

  // Internet envia 'CE' + trama completa de una vez (diferente a serie que va byte a byte)
  NewConf := 'CE' + trama;

  if EscribirAlSocket(NewConf) then begin
    GuardarNuevaConf(path);
    GuardarSensoresDisp(path);
    MensajeLog('Nueva configuracion transmitida correctamente.');
  end;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TServEquipoThread.EscribirConfigInternet;
var
  strIni     : string;
  strFin     : string;
  strGateway : string;
  strServer  : string;
  auxStr     : string;
  Abytes     : TAbytes;
begin
  MensajeLog('Transmitiendo la nueva configuracion de internet...');

  strIni := 'ATE0' + #13 + 'ATE0' + #13 + 'AT+CMGF=1' + #13 +
            'AT+CNMI=3,2,2,0,0' + #13 + 'AT+CMGD=1,4' + #13 + 'AT+CREG=1' + #13;

  strGateway := 'AT+MIPCALL=1,"' + gateway + '","' + user + '","' + pass + '"' + #13 + '/';

  strServer := 'AT+MIPOPEN=1,' + port + ',"' + server + '",' + port + ',0' + #13 + '/';

  ABytes := NumToAbytes(CalcPeriodoConect(IndexTConect));
  strFin := chr(Abytes[1]) + chr(Abytes[0]) + 'AT+MIPCLOSE=1' + #13 + '/' + 'AT+MIPCALL=0' + #13 + '/';

  auxStr := strIni + strGateway + strServer + ';' + strFin + '#';

  if not EscribirAlSocket('GA' + auxStr) then
    MensajeLog('No se pudo transmitir los nuevos parametros de internet.')
  else
    MensajeLog('Nueva configuracion de internet enviada.');
end;

////////////////////////////////////////////////////////////////////////////////
procedure TServEquipoThread.EscribirConfigTConect;
var
  Abytes : TAbytes;
  n      : integer;
begin
  ABytes := NumToAbytes(CalcPeriodoConect(IndexTConect));
  n      := (Abytes[1] * 255 + Abytes[0]);

  if not EscribirAlSocket('TX' + chr(Abytes[1]) + chr(Abytes[0])) then
    MensajeLog('No se pudo transmitir el nuevo periodo.')
  else
    MensajeLog('Nuevo periodo de conexion transmitido. - (Periodo = ' +
               IntToStr(IndexTConect) + '; ' + IntToStr(n) + ' muestras)');
end;

////////////////////////////////////////////////////////////////////////////////
// Logica exclusiva de internet
////////////////////////////////////////////////////////////////////////////////

procedure TServEquipoThread.ConfigEntorno;
begin
  gateway         := Mercury.Gateway;
  user            := Mercury.User;
  pass            := Mercury.Pass;
  server          := Mercury.DirServer;
  port            := IntToStr(Mercury.Puerto);
  IndexTConect    := Mercury.IndexTConect;
  PeriodoDescarga := Mercury.PeriodoDescarga;
  FormatoDescarga := Mercury.FormatoDescarga;
  IndiceFormatoFe := Mercury.IndiceFormatoFe;
end;

////////////////////////////////////////////////////////////////////////////////
function TServEquipoThread.CargarNuevaConf(DirINI: string): boolean;
var
  i              : byte;
  CambiarConf    : char;
  CambConfInt    : char;
  CambiarTConect : char;
  ArchivoINI     : TIniFile;
begin
  ArchivoINI     := TIniFile.Create(DirINI + Equipo.Nombre + '\conf\' + Equipo.Nombre + 'Conf.ini');
  CambiarConf    := 'N';
  CambConfInt    := 'N';
  CambiarTConect := 'N';

  try
    if FileExists(ArchivoINI.FileName) then begin
      CambiarConf    := ArchivoINI.ReadString(Equipo.Nombre, 'CambiarConf',         'N')[1];
      CambConfInt    := ArchivoINI.ReadString(Equipo.Nombre, 'CambiarConfInternet',  'N')[1];
      CambiarTConect := ArchivoINI.ReadString(Equipo.Nombre, 'CambiarTConect',       'N')[1];
    end;

    if CambiarConf = 'S' then begin
      NombreEquipo := ArchivoINI.ReadString(Equipo.Nombre, 'Nombre', Equipo.Nombre);
      T            := GetValorTablaT(StrToInt(ArchivoINI.ReadString(Equipo.Nombre, 'Tmuestreo', IntToStr(GetIndexTablaT(Equipo.Tmuestreo)))));
      for i := 0 to Length(Equipo.Canales) - 1 do
        ConfigCHs[i] := StrToInt(ArchivoINI.ReadString(Equipo.Nombre, 'CH' + IntToStr(i) + '_conf', IntToStr(Equipo.Canales[i].Config)));

      if (T <> Equipo.Tmuestreo) then CambiarTConect := 'S';
      MensajeLog('Nueva configuracion leida.');
    end
    else begin
      NombreEquipo := Equipo.Nombre;
      T            := Equipo.Tmuestreo;
      if (T > 1800) then T := 300;
      for i := 0 to Length(Equipo.Canales) - 1 do ConfigCHs[i] := Equipo.Canales[i].Config;
    end;

    if CambConfInt = 'S' then begin
      gateway := ArchivoINI.ReadString(Equipo.Nombre, 'gateway', gateway);
      user    := ArchivoINI.ReadString(Equipo.Nombre, 'user',    user);
      pass    := ArchivoINI.ReadString(Equipo.Nombre, 'pass',    pass);
      server  := ArchivoINI.ReadString(Equipo.Nombre, 'server',  server);
      port    := ArchivoINI.ReadString(Equipo.Nombre, 'port',    port);
      ConfigInternetEquipo := true;
      MensajeLog('Nueva configuracion de internet leida.');
    end;

    if CambiarTConect = 'S' then begin
      IndexTConect  := StrToInt(ArchivoINI.ReadString(Equipo.Nombre, 'IndexTConect', IntToStr(IndexTConect)));
      ConfigTConect := true;
      MensajeLog('Nuevo periodo de conexion leido.');
    end;

  except
    NombreEquipo := Equipo.Nombre;
    T            := Equipo.Tmuestreo;
    if (T > 1800) then T := 300;
    for i := 0 to Length(Equipo.Canales) - 1 do ConfigCHs[i] := Equipo.Canales[i].Config;
    ConfigInternetEquipo := false;
  end;

  Result := true;
  ArchivoINI.Free;
end;

////////////////////////////////////////////////////////////////////////////////
function TServEquipoThread.ForzarConfig(DirINI: string): boolean;
var
  ForzarConf : char;
  ArchivoINI : TIniFile;
begin
  ArchivoINI := TIniFile.Create(DirINI + Equipo.Nombre + '\conf\' + Equipo.Nombre + 'Conf.ini');
  ForzarConf := 'N';

  try
    if FileExists(ArchivoINI.FileName) then
      ForzarConf := ArchivoINI.ReadString(Equipo.Nombre, 'ForzarConfig', 'N')[1];

    if ForzarConf = 'S' then begin
      DescargarDatos := false;
      ConfigEquipo   := true;
      MensajeLog('Reconfiguracion forzada ejecutada.');
    end;

    Result := true;
  except
    Result := false;
  end;

  ArchivoINI.Free;
end;

////////////////////////////////////////////////////////////////////////////////
function TServEquipoThread.ForzarDescarga(DirINI: string): boolean;
var
  ForzarDsc  : char;
  ArchivoINI : TIniFile;
begin
  ArchivoINI := TIniFile.Create(DirINI + Equipo.Nombre + '\conf\' + Equipo.Nombre + 'Conf.ini');
  ForzarDsc  := 'N';
  Result     := false;

  try
    if FileExists(ArchivoINI.FileName) then
      ForzarDsc := ArchivoINI.ReadString(Equipo.Nombre, 'ForzarDescarga', 'N')[1];

    if ForzarDsc = 'S' then begin
      MensajeLog('Descarga forzada ejecutada.');
      Result := true;
    end;
  except
    Result := false;
  end;

  ArchivoINI.Free;
end;

////////////////////////////////////////////////////////////////////////////////
function TServEquipoThread.ForzarValoresInstantaneos(DirINI: string): boolean;
var
  ArchivoINI : TIniFile;
begin
  ArchivoINI     := TIniFile.Create(DirINI + Equipo.Nombre + '\conf\' + Equipo.Nombre + 'Conf.ini');
  ForzarVaLInsta := 'N';
  Result         := false;
  DescargarDatosInst := false;

  try
    if FileExists(ArchivoINI.FileName) then
      ForzarVaLInsta := ArchivoINI.ReadString(Equipo.Nombre, 'ForzarValoresInstantaneos', 'N')[1];

    if ForzarVaLInsta = 'S' then begin
      DescargarDatos     := true;
      DescargarDatosInst := true;
      ConfigEquipo       := true;
      MensajeLog('Valores instantaneos forzados ejecutada.');
      Result := true;
    end;
  except
    Result := false;
  end;

  ArchivoINI.Free;
end;

////////////////////////////////////////////////////////////////////////////////
function TServEquipoThread.GuardarNuevaConf(DirINI: string): boolean;
var
  i          : byte;
  ArchivoINI : TIniFile;
  PathDir    : string;
begin
  PathDir    := DirINI + Equipo.Nombre + '\conf\';
  ArchivoINI := TIniFile.Create(PathDir + Equipo.Nombre + 'Conf.ini');

  try
    if not DirectoryExists(DirINI + Equipo.Nombre) then MkDir(DirINI + Equipo.Nombre);
    if not DirectoryExists(PathDir) then MkDir(PathDir);

    ArchivoINI.WriteString(Equipo.Nombre, 'CambiarConf', 'N');
    ArchivoINI.WriteString(Equipo.Nombre, 'Nombre',      Equipo.Nombre);
    ArchivoINI.WriteString(Equipo.Nombre, 'Tmuestreo',   IntToStr(GetIndexTablaT(Equipo.Tmuestreo)));
    for i := 0 to Length(Equipo.Canales) - 1 do
      ArchivoINI.WriteString(Equipo.Nombre, 'CH' + IntToStr(i) + '_conf', IntToStr(Equipo.Canales[i].Config));

    ArchivoINI.WriteString(Equipo.Nombre, '--', '--');
    ArchivoINI.WriteString(Equipo.Nombre, 'CambiarConfInternet', 'N');
    ArchivoINI.WriteString(Equipo.Nombre, 'gateway', gateway);
    ArchivoINI.WriteString(Equipo.Nombre, 'user',    user);
    ArchivoINI.WriteString(Equipo.Nombre, 'pass',    pass);
    ArchivoINI.WriteString(Equipo.Nombre, 'server',  server);
    ArchivoINI.WriteString(Equipo.Nombre, 'port',    port);

    ArchivoINI.WriteString(Equipo.Nombre, '-', '-');
    ArchivoINI.WriteString(Equipo.Nombre, 'CambiarTConect', 'N');
    ArchivoINI.WriteString(Equipo.Nombre, 'IndexTConect',   IntToStr(IndexTConect));

    ArchivoINI.WriteString(Equipo.Nombre, '-.', '.-');
    ArchivoINI.WriteString(Equipo.Nombre, 'ForzarConfig',              'N');
    ArchivoINI.WriteString(Equipo.Nombre, 'ForzarDescarga',            'N');
    ArchivoINI.WriteString(Equipo.Nombre, 'ForzarValoresInstantaneos', ForzarVaLInsta);

    ArchivoINI.Free;
    result := true;
  except
    ArchivoINI.Free;
    result := false;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
function TServEquipoThread.GuardarSensoresDisp(DirINI: string): boolean;
var
  DescSensores : TStrings;
  i            : integer;
  NombreDesc   : string;
begin
  result       := false;
  NombreDesc   := DirINI + Equipo.Nombre + '\conf\ListaSensores.txt';
  DescSensores := TStringList.Create;

  DescSensores.Clear;
  for i := 1 to Length(ListaSensores) - 1 do DescSensores.Add(ListaSensores[i].ObtenerDesc);

  try
    if not FileExists(NombreDesc) then DescSensores.SaveToFile(NombreDesc)
    else if DeleteFile(NombreDesc) then DescSensores.SaveToFile(NombreDesc);
    MensajeLog('Lista de sensores disponibles guardada en "' + NombreDesc + '".');
    result := true;
  except
    MensajeLog('No se pudo guardar la informacion en "' + NombreDesc + '"');
  end;

  DescSensores.Free;
end;

////////////////////////////////////////////////////////////////////////////////
function TServEquipoThread.CargarCanales(DirINI: string): boolean;
var
  i, k, j     : integer;
  ExisteSensor : boolean;
  DDir         : string;
begin
  result := true;

  // Crear directorios ANTES de cualquier operacion que pueda fallar.
  // El codigo viejo los creaba inline aqui; la refactorizacion los movia
  // dentro de GuardarEquipo (al final del try), lo que causaba que si algo
  // fallaba en el medio, los dirs nunca se creaban.
  DDir := DirINI + Equipo.Nombre + '\';
  if not DirectoryExists(DDir)                             then MkDir(DDir);
  if not DirectoryExists(DDir + 'datos\')                 then MkDir(DDir + 'datos\');
  if not DirectoryExists(DDir + 'datos\datosDiarios\')   then MkDir(DDir + 'datos\datosDiarios\');
  if not DirectoryExists(DDir + 'conf\')                  then MkDir(DDir + 'conf\');

  try
    Equipo.CargarEquipo(DirINI);
    for i := 0 to Equipo.NumCanales - 1 do begin
      ExisteSensor := false;
      for j := 0 to Length(ListaSensores) - 1 do begin
        if (Equipo.Canales[i].Config = ListaSensores[j].Config) then begin
          Equipo.Canales[i].Asignar(ListaSensores[j]);

          for k := 0 to Length(Equipo.ListaSenDir) - 1 do begin
            if Equipo.Canales[i].Config = Equipo.ListaSenDir[k].Config then begin
              Equipo.Canales[i].Asignar(Equipo.ListaSenDir[k]);
              break;
            end;
          end;

          Equipo.Canales[i].PosLista := ListaSensores[j].PosLista;

          if (Equipo.Canales[i].Config = Equipo.Canales[i].ConfigINI) and
             (Length(Equipo.Canales[i].DescrINI) > 0) then
            Equipo.Canales[i].Descripcion := Equipo.Canales[i].DescrINI;

          ExisteSensor := true;
        end;
      end;

      if (not ExisteSensor) and (Length(ListaSensores) >= 2) then begin
        Equipo.Canales[i].Asignar(ListaSensores[1]);
        Equipo.Canales[i].PosLista := ListaSensores[1].PosLista;
      end;
    end;
    Equipo.GuardarEquipo(DirINI);
    Equipo.CargarEquipo(DirINI);

    ForzarConfig(DirINI);
    ForzarValoresInstantaneos(DirINI);

  except
    result := false;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
function TServEquipoThread.CalcPeriodoConect(index: byte): integer;
var
  P  : integer;
  i  : byte;
  N  : byte;
  Tp : real;
begin
  N  := 0;
  Tp := T;
  if (Tp = 0) then Tp := Tmin;

  for i := 0 to Length(Equipo.Canales) - 1 do
    if Equipo.Canales[i].Config > 0 then inc(N, 1);

  case index of
    0 : P := 0;
    1 : P := round(30  / (Tp / 60)) - 1;
    2 : P := round(60  / (Tp / 60)) - 1;
    3 : P := round(2  * 60 / (Tp / 60)) - 1;
    4 : P := round(4  * 60 / (Tp / 60)) - 1;
    5 : P := round(6  * 60 / (Tp / 60)) - 1;
    6 : P := round(8  * 60 / (Tp / 60)) - 1;
    7 : P := round(10 * 60 / (Tp / 60)) - 1;
    8 : P := round(12 * 60 / (Tp / 60)) - 1;
    9 : P := round(24 * 60 / (Tp / 60)) - 1;
   10 : P := round(980 / (N * 2));
  else
    P := 0;
  end;

  if P > 65535 then P := 65535;
  if P < 0    then P := 0;
  if ((Tp < 600) and (P < 600 / Tp)) then P := round(600 / Tp) - 1;

  result := P;
end;

////////////////////////////////////////////////////////////////////////////////
function TServEquipoThread.RupturaTransmision: boolean;
var
  i        : byte;
  NActivos : byte;
  mem      : integer;
begin
  NActivos := 0;
  for i := 0 to Equipo.NumCanales - 1 do
    if (Equipo.Canales[i].Config > 0) then inc(NActivos, 1);

  mem := NActivos * 2 + BytesOcupados;

  if (Equipo.Memoria > mem) then result := true
  else result := false;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TServEquipoThread.GuardarValoresInstantaneos(TipoHora: byte);
var
  i     : byte;
  linea : string;
begin
  MensajeLog('Guardando datos instantaneos del equipo...');

  linea := '';
  for i := 0 to Equipo.NumCanales - 1 do begin
    if Equipo.Canales[i].Config <> 0 then begin
      Equipo.Canales[i].Escala := Equipo.Escala;
      Equipo.Canales[i].ComputarValor(Equipo.Canales[i].ValorSensor);

      if Length(Linea) > 0 then Linea := Linea + sep + Equipo.Canales[i].ValorReal
      else Linea := Equipo.Canales[i].ValorReal;
    end;
  end;

  Datos.Clear;

  try
    if not FileExists(Archivo) then begin
      if TipoHora = 1 then
        Datos.Add(Mercury.GenerarStringFecha(IndiceFormatoFe, Equipo.HoraPC) + sep + Linea)
      else
        Datos.Add(Mercury.GenerarStringFecha(IndiceFormatoFe, Equipo.Hora) + sep + Linea);

      Datos.SaveToFile(Archivo);
      MensajeLog('Archivo creado, datos recibidos y guardados en ' + Archivo);
    end
    else begin
      if TipoHora = 1 then
        Datos.Add(Mercury.GenerarStringFecha(IndiceFormatoFe, Equipo.HoraPC) + sep + Linea)
      else
        Datos.Add(Mercury.GenerarStringFecha(IndiceFormatoFe, Equipo.Hora) + sep + Linea);

      if not SaveTstringsToTxtFile(Archivo, @Datos, 0, Datos.Count - 1) then begin
        MensajeLog('Error al escribir en ' + Archivo);
        Datos.SaveToFile(Archivo + '.' + FormatDateTime('yyyymmdd_hhnnss', now) + '.back');
      end;
    end;
  except
    MensajeLog('No se pudo guardar la informacion en "' + Archivo + '"');
    MensajeLog('cerciurese de tener permiso de escritura en "' + ExtractFilePath(Archivo) + '".');
  end;

  Datos.Clear;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TServEquipoThread.DescargarLosDatos;
var
  i : byte;
begin
  ArchivoDesc   := path + Equipo.Nombre + '\datos\Canales.txt';
  ArchivoBckDly := path + Equipo.Nombre + '\datos\datosDiarios\' + FormatDateTime('yyyy-mm-dd', now);

  case PeriodoDescarga of
    0 : Archivo := path + Equipo.Nombre + '\datos\' + FormatDateTime('dd-mm-yyyy', now);
    1 : Archivo := path + Equipo.Nombre + '\datos\' + FormatDateTime('mm-yyyy', now);
  else
    Archivo := path + Equipo.Nombre + '\datos\' + FormatDateTime('dd-mm-yyyy', now);
  end;

  case FormatoDescarga of
    0 : begin
          sep           := #9;
          Archivo       := Archivo + '.txt';
          ArchivoBckDly := ArchivoBckDly + '.txt';
        end;
    1 : begin
          sep           := ';';
          Archivo       := Archivo + '.csv';
          ArchivoBckDly := ArchivoBckDly + '.csv';
        end;
    2 : begin
          sep           := ',';
          Archivo       := Archivo + '.csv';
          ArchivoBckDly := ArchivoBckDly + '.csv';
        end;
    3 : begin
          sep           := #9;
          Archivo       := Archivo + '.txt';
          ArchivoBckDly := ArchivoBckDly + '.txt';
        end;
  else
    sep           := #9;
    Archivo       := Archivo + '.txt';
    ArchivoBckDly := ArchivoBckDly + '.txt';
  end;

  Datos.Clear;

  with Datos do begin
    Add('Datos Generales');
    Add('--------------------------');
    Add('Nombre del Equipo '   + sep + ': ' + Equipo.Nombre);
    Add('Intervalo de Captura' + sep + ': ' + Mercury.GenerarStrTmuest(Equipo.Tmuestreo));
    Add('Hora del Equipo   '   + sep + ': ' + Mercury.GenerarStringFecha(IndiceFormatoFe, Equipo.Hora));
    Add('Hora de la PC     '   + sep + ': ' + Mercury.GenerarStringFecha(IndiceFormatoFe, Equipo.HoraPC));
    Add('');
    Add('');

    Add('Descripcion de los Canales');
    Add('--------------------------');
    for i := 0 to Length(Equipo.Canales) - 1 do begin
      if (Equipo.Canales[i].Config > 0) then
        Add('CH ' + IntToStr(i) + sep + ': ' + Equipo.Canales[i].Descripcion +
            ' ' + '[' + Equipo.Canales[i].Unidad + ']');
    end;
    Add('');
    Add('');

    Add('Valores Calculados');
    Add('--------------------------');
    for i := 0 to Equipo.CalcParam.CantParm - 1 do begin
      if (Equipo.CalcParam.Parametros[i].Calcular = 1) then
        Add('VC ' + IntToStr(i) + sep + ': ' + Equipo.CalcParam.Parametros[i].Descripcion +
            ' ' + '[' + Equipo.CalcParam.Parametros[i].Unidad + ']');
    end;
    Add('');
    Add('');
  end;

  try
    if not FileExists(ArchivoDesc) then Datos.SaveToFile(ArchivoDesc)
    else if DeleteFile(ArchivoDesc) then Datos.SaveToFile(ArchivoDesc);
    MensajeLog('Descripcion de los canales guardada en "' + ArchivoDesc + '".');
  except
    MensajeLog('No se pudo guardar la informacion en "' + ArchivoDesc + '"');
    MensajeLog('cerciurese de tener permiso de escritura en "' + ExtractFilePath(ArchivoDesc) + '".');
  end;

  if not DescargarDatosInst then begin
    if not RupturaTransmision then GuardarValoresInstantaneos(0)
    else LeerDatos;
  end
  else GuardarValoresInstantaneos(1);
end;

////////////////////////////////////////////////////////////////////////////////
procedure TServEquipoThread.LeerDatos;
var
  auxStr           : string;
  Nbytes           : LongInt;
  i, j, k, kIni   : LongInt;
  linea            : string;
  num              : integer;
  NCanal           : byte;
  MaxCanales       : byte;
  IniMuestreo      : double;
  periodo          : real;
  Nlineas          : integer;
  CanalesAct       : array of byte;
  PorCenFlag       : Real;
begin
  Nbytes      := Equipo.Memoria;
  IniMuestreo := Equipo.iniMuestr;
  periodo     := Equipo.Tmuestreo;
  PorCenFlag  := 12.4;

  if (periodo = 0) then periodo := Tmin;

  MensajeLog('Leyendo ' + IntToStr(Nbytes) + ' bytes del equipo...');

  Datos.Clear;
  kIni := Datos.Count;

  SetLength(CanalesAct, 0);
  for i := 0 to Equipo.NumCanales - 1 do begin
    if (Equipo.Canales[i].Config > 0) then begin
      SetLength(CanalesAct, Length(CanalesAct) + 1);
      CanalesAct[Length(CanalesAct) - 1] := i;
      Equipo.Canales[i].Escala := Equipo.Escala;
    end;
  end;
  MaxCanales := Length(CanalesAct);

  if (MaxCanales > 0) and (Nbytes > BytesOcupados) then begin
    if not EscribirAlSocket('LD') then exit;

    i      := 0;
    auxStr := '';
    while ((auxStr <> 'DG') and (i <= 200)) do begin
      if not LeerDelSocket(auxStr, 2) then break;
      inc(i, 1);
    end;
    if (i > 200) then exit;

    NCanal  := 0;
    Linea   := '';
    Nlineas := 0;

    LeerDelSocket(auxStr, BytesOcupados);
    num := Byte(auxStr[1]) + Byte(auxStr[2]) + Byte(auxStr[3])
         + Byte(auxStr[2]) * 255 + Byte(auxStr[3]) * 65535;
    MensajeLog('--- ' + IntToStr(num) + ' ---');

    if ((num >= 4) and
        (((num >= Nbytes - 2 * MaxCanales * 5) and (num <= Nbytes + 2 * MaxCanales * (TMaxdelay / periodo)))
          or (Nbytes = BytesOcupados))) then
      MensajeLog('--- Integridad OK ---')
    else begin
      MensajeLog('--- Integridad DUDOSA. ---');
      if not ForzarDescarga(path) then begin
        MensajeLog('--- Comunicacion abortada con el equipo. ---');
        ConfigEquipo := False;
        GuardarValoresInstantaneos(0);
        exit;
      end;
    end;

    for i := 3 to (Nbytes div 2) do begin
      auxStr := '';
      if not LeerDelSocket(auxStr, 2) then break;

      num := Byte(auxStr[1]) + Byte(auxStr[2]) + Byte(auxStr[2]) * 255;
      Equipo.Canales[CanalesAct[NCanal]].ComputarValor(num);

      if Length(Linea) > 0 then Linea := Linea + sep + Equipo.Canales[CanalesAct[NCanal]].ValorReal
      else Linea := Equipo.Canales[CanalesAct[NCanal]].ValorReal;

      inc(NCanal, 1);
      if (NCanal > MaxCanales - 1) then begin
        for j := 0 to Equipo.CalcParam.CantParm - 1 do begin
          with Equipo.CalcParam.Parametros[j] do begin
            if (Calcular = 1) then begin
              for k := 0 to Nparam - 1 do begin
                if (AParam[k].canal >= 0) then AParam[k].valor := Equipo.Canales[AParam[k].canal].ValorNum
                else AParam[k].valor := 0;
              end;
              Equipo.CalcParam.CalcularValorParam(j);
              Linea := Linea + sep + ResultCalcStr;
            end;
          end;
        end;

        Datos.Add(Mercury.GenerarStringFecha(IndiceFormatoFe, IniMuestreo + Nlineas * (periodo / 86400)) + sep + Linea);
        NCanal := 0;
        Linea  := '';
        inc(NLineas, 1);
      end;

      if (i / (Nbytes / 2)) * 100 > PorCenFlag then begin
        MensajeLog('Recibido... ' + FormatFloat('#.0', (i / (Nbytes / 2)) * 100) + '%');
        PorCenFlag := PorCenFlag * 2;
      end;
    end;

    try
      if not SaveTstringsToTxtFile(ArchivoBckDly, @Datos, 0, Datos.Count - 1) then begin
        MensajeLog('Error al escribir el backup diario. ' + ArchivoBckDly);
        Datos.SaveToFile(ArchivoBckDly + '.' + FormatDateTime('yyyymmdd_hhnnss', now) + '.back');
      end;

      if not SaveTstringsToTxtFile(Archivo, @Datos, 0, Datos.Count - 1) then begin
        MensajeLog('Error al escribir en ' + Archivo);
        Datos.SaveToFile(Archivo + '.' + FormatDateTime('yyyymmdd_hhnnss', now) + '.back');
      end;

      if (i - 1) = (Nbytes div 2) then
        MensajeLog(IntToStr((i - 1) * 2) + ' bytes recibidos y guardados')
      else begin
        MensajeLog('No se pudo descargar los ' + IntToStr(Nbytes) + ' bytes desde el equipo.');
        MensajeLog('Comunicacion abortada con el equipo.');
        ConfigEquipo := False;
      end;
    except
      try
        Datos.SaveToFile(Archivo + '.' + FormatDateTime('yyyymmdd_hhnnss', now) + '.back');
      except end;
      MensajeLog('No se pudo guardar la informacion en "' + Archivo + '"');
      MensajeLog('cerciurese de tener permiso de escritura en "' + ExtractFilePath(Archivo) + '".');
    end;
  end
  else MensajeLog('No habia informacion para ser guardada');

  SetLength(CanalesAct, 0);
  Datos.Clear;
end;

////////////////////////////////////////////////////////////////////////////////
end.
