unit UEquipoInternet;

interface
uses
  Windows, Registry, Classes, SysUtils, Dialogs, StdCtrls, SyncObjs, Math,
  UUtiles, IniFiles, USensor, UFormulas, Sockets, ExtCtrls, DateUtils, blcksock;

const
    BlockSize = 1024;

type
  TAbytes    = array [0..3] of byte;
  TpTstrings = ^TStrings;

  TServEquipoThread = class(TThread)
    private
      //
    public
      // Variables propias de Thread Server
      FSocket        : TTCPBlockSocket;
      FClientTimeOut : integer;
      pTStrings      : TpTstrings;

      // Variables propias del Equipo
      Nombre      : string;                // Nombre del Equipo
      NombreRaw   : string;                // Nombre del Equipo Raw / "Como llega"
      BadChrsName : boolean;               // Caracteres invalidos en el Nombre
      Memoria     : longint;               // Cantidad de bytes ocupados de la Memoria
      Hora        : Tdatetime;             // Hora actual del Equipo
      HoraPC      : Tdatetime;             // Hora actual de la PC
      iniMuestr   : Tdatetime;             // Hora en la que se inicio el muestreo
      Tmuestreo   : integer;               // Periodo de muestreo en SEGUNDOS
      Progreso    : real;                  // Variable que representa el progreso en el proceso sea cual sea
      Canales     : TASensor;              // Arreglo que tiene Config y Seteos de cada canal
      ListaSenDir : TASensor;              // Arreglo que tiene la info de los sensores en el dir de equipo
      CalcParam   : TCalculoParam;         // Objeto que permite calcular los param de Salinidad, Densidad .....

      Hora_Base   : string;                // Hora que tomo como referencia para calcular las fechas del equipo
      NumCanales  : byte;                  // Cantidad de canales que tiene el Equipo
      Vref        : real;                  // Tensi�n de referencia usada por el A/D
      BitsAD      : integer;               // Bytes de Resuloci�n del A/D (8,10,..16)
      CantMemory  : integer;               // Capacidad de Almacenamiento en Bytes
      Escala      : real;                  // Escala para comvertir los numeros en Volts

      // Info que voy a grabar en el equipo
      T               : integer;           // Periodo de muestreo en SEGUNDOS
      NombreEquipo    : string;            // Nombre del Equipo
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

      ConfigEquipo    : boolean;
      ConfigInternetEquipo : boolean;
      ConfigTConect   : boolean;
      DescargarDatos  : boolean;
      DescargarDatosInst : boolean;
      ONLine          : boolean;
      CantCanales     : byte;
      Archivo         : string;            // Path y nombre del archivo en que guardo los datos
      ArchivoBckDly   : string;            // Path y nombre del archivo en que guardo los datos diarios de back
      ArchivoDesc     : string;            // Path y nombre del archivo en que guardo las descripciones de los canales   
      path            : string;            // Path del directorio en que guardo los datos
      sep             : string;            // Caracter que uso para separar las columas cuando bajo datos
      Datos           : Tstrings;          // Informaci�n recopilada por el equipo
      FormatoDescarga : byte;              // Elecci�n del Formato en que descargo los datos
      PeriodoDescarga : byte;              // Elecci�n del periodo de acumulaci�n de datos un archivo por dia o por mes
      //FormatoFecha    : string;            // Elecci�n del Formato de las fechas los datos
      IndiceFormatoFe : byte;              // Selecci�n del Formato de las fechas
      BytesOcupados   : byte;              // Almacena la cantidad de bytes ocupados de la memoria para otra cosa
      ForzarVaLInsta  : char;              // Char que indica si uso modalidad de valores instantaneos por errores en memoria

      // Funciones propias del Thread Server
      constructor Create( StartSuspended: boolean; ClientSocketHandle: TSocket;
                          ClientTimeOut : integer; NCanales:byte; pTStrs : TpTstrings; Dirpath: string);
      destructor  Destroy; override;
      procedure   Execute; override;
      procedure   MensajeLog(mensaje : string);

      // Propias del Equipo
      procedure   Limpiar;
      function    GuardarEquipo(DirINI : string):boolean;
      function    CargarEquipo(DirINI : string):boolean;
      function    CargarNuevaConf(DirINI : string):boolean;
      function    ForzarConfig(DirINI : string):boolean;
      function    ForzarDescarga(DirINI : string):boolean;
      function    ForzarValoresInstantaneos(DirINI : string):boolean;
      function    GuardarNuevaConf(DirINI : string):boolean;
      function    GuardarSensoresDisp(DirINI : string):boolean;
      function    BorrarEquipo(DirINI : string):boolean;
      function    CargarCanales(DirINI : string): boolean;
      function    CalcPeriodoConect(index: byte):integer;
      procedure   ConfigEntorno;

      // Funciones propias de la comunicaci�n y descarga de datos
      function    EscribirAlSocket(chs :string): boolean;
      function    LeerDelSocket(var chs :string; TamBuffer: integer):boolean;
      procedure   LeerConfig;
      procedure   EscribirConfig;
      procedure   EscribirConfigInternet;
      procedure   EscribirConfigTConect;
      function    RupturaTransmision:boolean;
      procedure   GuardarValoresInstantaneos(TipoHora:byte);
      procedure   DescargarLosDatos;
      procedure   LeerDatos;
      //
  end;

  // Funciones y Procedimientos de uso generales
  Procedure Retardo(tiempo:integer);
  function  NumToAbytes(num : longint):TAbytes;

implementation

////////////////////////////////////////////////////////////////////////////////
// TServEquipoThread
////////////////////////////////////////////////////////////////////////////////
constructor TServEquipoThread.Create( StartSuspended: boolean; ClientSocketHandle: TSocket;
                                      ClientTimeOut : integer; NCanales:byte; pTStrs : TpTstrings; Dirpath: string);
var
  i : byte;

begin
  inherited Create( StartSuspended );
  FreeOnTerminate := true;
  FSocket         := TTCPBlockSocket.Create;
  FSocket.Socket  := ClientSocketHandle;
  FClientTimeOut  := ClientTimeOut;
  pTStrings       := pTStrs;
  path            := Dirpath;

  // Configuro las variables mas generales
  Nombre        := '    ';
  Memoria       := 0;
  Hora          := now;
  HoraPC        := now;
  iniMuestr     := now;
  Tmuestreo     := 60;
  NumCanales    := NCanales;
  Hora_Base     := '01/01/2000 12:00 am';
  Vref          := 5.03;
  BitsAD        := 1024;
  CantMemory    := 32768;
  Escala        := Vref/BitsAD;
  BytesOcupados := 4;

  // Creo los canales
  SetLength(Canales,NumCanales);
  for i:=0 to NumCanales-1 do Canales[i] := TSensor.Crear;

  // Me aseguro que la lista est� v�cia
  SetLength(ListaSenDir,0);

  // Creo el objeto TCalcParam
  CalcParam := TCalculoParam.Crear;

  // Varaibles de uso exclusivo de la comunicaci�n y descarga de datos
  Datos                := TStringList.Create;
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
  CantCanales          := NumCanales;
  SetLength(ConfigCHs,NumCanales);
end;

////////////////////////////////////////////////////////////////////////////////
destructor TServEquipoThread.Destroy; //override;
var
  i : integer;

begin
  // Me aseguro que no entre a ninguna funci�n
  ConfigEquipo    := false;
  DescargarDatos  := false;

  //
  pTStrings := nil;
  for i:=0 to length(Canales)-1 do Canales[i].Destruir;
  for i:=0 to length(ListaSenDir)-1 do ListaSenDir[i].Destruir;
  setLength(ListaSenDir,0);
  SetLength(Canales,0);

  // Destruyo los objetos
  Datos.Destroy;
  CalcParam.Destruir;

  // Libero la memoria de los arreglos din�micos
  SetLength(ConfigCHs,0);

  inherited Destroy;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TServEquipoThread.MensajeLog(mensaje : string);
var
  strHora : string;

begin
  if (pTStrings = nil) then exit;

  strHora := FormatDateTime('dd/mm/yy hh:nn:ss ', now);

  if length(Nombre)>0 then
    if ( Byte( Nombre[1] ) >= 48 ) then
      pTStrings^.Add(strHora + ' -> '+ Nombre+': '+ mensaje)
    else
      pTStrings^.Add(strHora + ' -> '+ 'unknown: '+ mensaje)
  else
    pTStrings^.Add(strHora + ' -> '+ mensaje);
end;

////////////////////////////////////////////////////////////////////////////////
procedure TServEquipoThread.Execute;
var
 auxStr : string;

begin
  // Me aseguro que no quede ninguna informaci�n recidente  
  Limpiar;

  // Descargo los datos 
  DescargarDatos := true;

  // Me aseguro que entre
  auxStr := ' '; 
  while (not Terminated) and (length(auxStr)>0) do begin
    try
      //
      auxStr := '';
      ONLine := false;

      EscribirAlSocket('OK');
      //Retardo(500);
      //EscribirAlSocket('OK');

      //
      if LeerDelSocket(auxStr,2) then begin
        //MensajeLog(auxStr);
        if (auxStr = 'CE') then begin
          // Configuro las variables de descarga y de mas...
          ConfigEntorno;

          // Leeo toda la config del equipo
          LeerConfig;

          // Levanto la info del equipo y de los canales
          CargarCanales(path);

          // Configuro el Equipo
          ConfigEquipo := true;

          // Indico que estoy conectado con el equipo
          ONLine       := true;

          // Error en la carga del contador de memoria
          if (Memoria > (CantMemory*0.9) ) then begin
            MensajeLog('--- Reiniciando registro. ---');
            DescargarDatos := false;
          end;
        end
        else ONLine := false;
      end
      else ONLine := false;
      
      // Descargo los datos almacenado en la memoria del Equipo
      if DescargarDatos and ONLine then begin
        Retardo(1000);
        DescargarLosDatos;                   // Procedimiento que guarda los datos en el disco con cierto formato
        DescargarDatos := false;
        Retardo(2000);                      // Espero 5 seg por las dudas que el equipo siga mandando algo mas...
      end;

      // Configuro las variables b�sicas del Equipo
      if ConfigEquipo  and ONLine then begin
        EscribirConfig;
        ConfigEquipo := false;
        Retardo(2000);
      end;

      // Configuro el nuevo intervalo de conexi�n
      if ConfigTConect  and ONLine then begin
        EscribirConfigTConect;
        ConfigTConect := false;
        Retardo(2000);
      end;
      
      {
      // Configuro las variables de internet del Equipo
      if ConfigInternetEquipo  and ONLine then begin
        EscribirConfigInternet;
        ConfigInternetEquipo := false;
        Retardo(2000);
      end;
      }
    except
      //
    end;
  end;

  FSocket.CloseSocket;
  FSocket.Free;
end;

////////////////////////////////////////////////////////////////////////////////
// Funciones de uso Exclusivo de la administraci�n del equipo
////////////////////////////////////////////////////////////////////////////////
procedure TServEquipoThread.Limpiar;
var
  i : integer;

begin
  Nombre    := '';
  Tmuestreo := 60;
  for i:=0 to NumCanales-1 do Canales[i].Limpiar;
  for i:=0 to length(ListaSenDir)-1 do ListaSenDir[i].Destruir;
  setLength(ListaSenDir,0);
end;

////////////////////////////////////////////////////////////////////////////////
function TServEquipoThread.GuardarEquipo(DirINI : string):boolean;
var
  ArchivoINI   : TIniFile;
  i            : integer;
  PathDir      : string;

begin
  ArchivoINI   := TIniFile.Create(DirINI+Nombre+'\conf\'+Nombre+'.ini');
  PathDir      := DirINI + Nombre + '\conf\';

  // Cargo los datos desde el Archivo INI
  try
    // Me aseguro que exista el dir sino lo creo
    if not DirectoryExists(DirINI + Nombre) then MkDir(DirINI + Nombre);
    if not DirectoryExists(DirINI + Nombre+'\datos\') then MkDir(DirINI + Nombre+'\datos\');
    if not DirectoryExists(PathDir) then MkDir(PathDir);

    for i:=0 to NumCanales-1 do begin
      ArchivoINI.WriteString(Nombre, 'CH'+intToStr(i)+'_desc', Canales[i].Descripcion);
      ArchivoINI.WriteString(Nombre, 'CH'+intToStr(i)+'_conf', IntToStr(Canales[i].Config));
    end;

    // Guardo la config del los calculos de los par�metros
    CalcParam.GuardarParametros(DirINI+Nombre+'\conf\'+Nombre+'.ini', Nombre);

    // Pongo el separador de las distintas secciones
    ArchivoINI.WriteString(Nombre, '------', '------');

    // Guardo los sensores en el dir del Equipo
    for i:=0 to NumCanales-1 do begin
      if (not FileExists(PathDir + Canales[i].Nombre + '.sen')) and (Canales[i].Config >1) then
        Canales[i].GuardarEnArchivo(PathDir + Canales[i].Nombre + '.sen');
    end;
  except
    ArchivoINI.Destroy;
    result := false;
    exit;
  end;


  ArchivoINI.Destroy;
  result := true;
end;

////////////////////////////////////////////////////////////////////////////////
function TServEquipoThread.CargarEquipo(DirINI : string):boolean;
var
  ArchivoINI   : TIniFile;
  SeccionesINI : TStrings;
  i            : integer;
  AFiles       : AFilesOfDir;
  PathDir      : string;

begin
  SeccionesINI := TStringList.Create;
  ArchivoINI   := TIniFile.Create(DirINI+Nombre+'\conf\'+Nombre+'.ini');
  PathDir      := DirINI+Nombre+'\conf\';

  if not FileExists(ArchivoINI.FileName) then begin
    ArchivoINI.Destroy;
    SeccionesINI.Destroy;
    result := false;
    exit;
  end;

  SeccionesINI.Clear;
  ArchivoINI.ReadSections(SeccionesINI);

  // Me aseguro que este el equipo en el Archivo INI
  if not ArchivoINI.SectionExists(Nombre) then begin
    ArchivoINI.Destroy;
    SeccionesINI.Destroy;
    result := false;
    exit;
  end;

  // Cargo los datos desde el Archivo INI
  try
    for i:=0 to NumCanales-1 do begin
      Canales[i].DescrINI  := ArchivoINI.ReadString(Nombre, 'CH'+intToStr(i)+'_desc'         , '');
      Canales[i].ConfigINI := StrToInt(ArchivoINI.ReadString(Nombre, 'CH'+intToStr(i)+'_conf', '0'));
    end;

    // Cargo  la config del los calculos de los par�metros
    CalcParam.CargarParametros(DirINI+Nombre+'\conf\'+Nombre+'.ini', Nombre);

    // Obtengo una lista de los archivos de sensores en el dir del equipo
    ExtractFilesOfDir(PathDir + '*.sen', AFiles);
    // Redimenciono el arreglo para la cantidad de Sensores
    SetLength(ListaSenDir, length(AFiles));
    // Cargo los sensores
    for i:=0 to length(AFiles)-1 do begin
      ListaSenDir[i] := TSensor.Crear;
      ListaSenDir[i].CargarDeArchivo(PathDir + AFiles[i].Name);
    end;
  except
    ArchivoINI.Destroy;
    result := false;
    exit;
  end;

  ArchivoINI.Destroy;
  SeccionesINI.Destroy;
  result := true;
end;

////////////////////////////////////////////////////////////////////////////////
function TServEquipoThread.CargarNuevaConf(DirINI : string):boolean;
var
  i              : byte;
  CambiarConf    : char;
  CambConfInt    : char;
  CambiarTConect : char;
  ArchivoINI     : TIniFile;

begin
  ArchivoINI     := TIniFile.Create(DirINI+Nombre+'\conf\'+Nombre+'Conf.ini');
  CambiarConf    := 'N';
  CambConfInt    := 'N';
  CambiarTConect := 'N';

  try
    // Me Aseguro que exista el Archivo
    if FileExists(ArchivoINI.FileName) then begin
      // Me aseguro que halla que cambiar la config del equipo
      CambiarConf    := ArchivoINI.ReadString(Nombre,'CambiarConf'        , 'N')[1];
      CambConfInt    := ArchivoINI.ReadString(Nombre,'CambiarConfInternet', 'N')[1];
      CambiarTConect := ArchivoINI.ReadString(Nombre,'CambiarTConect'     , 'N')[1];
    end;

    if CambiarConf='S' then begin
      // Cargo los parametros b�sicos del equipo desde el archivo para re-configurarlo
      NombreEquipo := ArchivoINI.ReadString(Nombre,'Nombre'   , Nombre);

      T            := GetValorTablaT(StrToint(ArchivoINI.ReadString(Nombre,'Tmuestreo', intToStr(GetIndexTablaT(Tmuestreo)))));
      for i:=0 to length(Canales)-1 do
        ConfigCHs[i] := StrToint(ArchivoINI.ReadString(Nombre,'CH'+intToStr(i)+'_conf', IntToStr(Canales[i].Config)));

      // Si cambio el periodo de muestreo tambien debo cambiar cada x muestras me conecto
      if (T <> Tmuestreo) then CambiarTConect:='S';

      //
      MensajeLog('Nueva configuraci�n leida.');
    end
    else begin
      // Cargo los parametros b�sicos del equipo para re-configurarlo
      NombreEquipo := Nombre;
      T            := Tmuestreo;

      // Por las Dudas, Nunca tengo puedo tener periodos de muestreo > a media hora
      if (T>1800) then T:=300; // Re-configuro a un perido de 5 min.

      // Configuro los canales
      for i:=0 to length(Canales)-1 do ConfigCHs[i] := Canales[i].Config;
    end;

    // Cargo la nueva config de internet para el equipo desde el archivo
    if CambConfInt='S' then begin
      gateway := ArchivoINI.ReadString(Nombre,'gateway', gateway);
      user    := ArchivoINI.ReadString(Nombre,'user'   , user);
      pass    := ArchivoINI.ReadString(Nombre,'pass'   , pass);
      server  := ArchivoINI.ReadString(Nombre,'server' , server);
      port    := ArchivoINI.ReadString(Nombre,'port'   , port);

      // Si est� todo bien mando a transmitir la nueva config
      ConfigInternetEquipo := true;

      //
      MensajeLog('Nueva configuraci�n de internet leida.');
    end;

    // Cargo la nueva config de internet para el equipo desde el archivo
    if CambiarTConect='S' then begin
      IndexTConect := StrToint(ArchivoINI.ReadString(Nombre,'IndexTConect', intToStr(IndexTConect)));

      // Si est� todo bien mando a transmitir la nueva config
      ConfigTConect := true;

      //
      MensajeLog('Nuevo peri�do de conexi�n leido.');
    end;

  except
    // Cargo los parametros b�sicos del equipo para re-configurarlo
    NombreEquipo := Nombre;
    T            := Tmuestreo;

    // Por las Dudas, Nunca tengo puedo tener periodos de muestreo > a media hora 
    if (T>1800) then T:=300; // Re-configuro a un perido de 5 min.

    // Configuro los canales
    for i:=0 to length(Canales)-1 do ConfigCHs[i] := Canales[i].Config;

    // Me aseguro que no toque la config de internet
    ConfigInternetEquipo := false;
  end;

  // Todo ok
  Result := true;
  ArchivoINI.Destroy;
end;

////////////////////////////////////////////////////////////////////////////////
function TServEquipoThread.ForzarConfig(DirINI : string):boolean;
var
  ForzarConfig   : char;
  ArchivoINI     : TIniFile;

begin
  ArchivoINI     := TIniFile.Create(DirINI+Nombre+'\conf\'+Nombre+'Conf.ini');
  ForzarConfig   := 'N';

  try
    // Me Aseguro que exista el Archivo
    if FileExists(ArchivoINI.FileName) then begin
      ForzarConfig   := ArchivoINI.ReadString(Nombre,'ForzarConfig' , 'N')[1];
    end;

    // Fuerzo la reconfiguraci�n del Equipo
    if ForzarConfig ='S' then begin
      // Aborto la descarga de datos
      DescargarDatos := false;

      // Configuro el Equipo
      ConfigEquipo := true;

      //
      MensajeLog('Reconfiguraci�n forzada ejecutada.');
    end;

    Result := true;
  except

    Result := false;
  end;

  // Todo ok
  ArchivoINI.Destroy;
end;

////////////////////////////////////////////////////////////////////////////////
function TServEquipoThread.ForzarDescarga(DirINI : string):boolean;
var
  ForzarDescarga : char;
  ArchivoINI     : TIniFile;

begin
  ArchivoINI      := TIniFile.Create(DirINI+Nombre+'\conf\'+Nombre+'Conf.ini');
  ForzarDescarga  := 'N';
  Result          := false;

  try
    // Me Aseguro que exista el Archivo
    if FileExists(ArchivoINI.FileName) then begin
      ForzarDescarga   := ArchivoINI.ReadString(Nombre,'ForzarDescarga', 'N')[1];
    end;

    // Fuerzo la reconfiguraci�n del Equipo
    if ForzarDescarga ='S' then begin
      //
      MensajeLog('Descarga forzada ejecutada.');
      Result := true;
    end;

  except
    Result := false;
  end;

  // Todo ok
  ArchivoINI.Destroy;
end;

////////////////////////////////////////////////////////////////////////////////
function TServEquipoThread.ForzarValoresInstantaneos(DirINI : string):boolean;
var
  ArchivoINI     : TIniFile;

begin
  ArchivoINI      := TIniFile.Create(DirINI+Nombre+'\conf\'+Nombre+'Conf.ini');
  ForzarVaLInsta  := 'N';
  Result          := false;
  DescargarDatosInst := False;

  try
    // Me Aseguro que exista el Archivo
    if FileExists(ArchivoINI.FileName) then begin
      ForzarVaLInsta   := ArchivoINI.ReadString(Nombre,'ForzarValoresInstantaneos', 'N')[1];
    end;

    // Fuerzo la reconfiguraci�n del Equipo
    if ForzarVaLInsta ='S' then begin
      DescargarDatos     := True; // Aborto la descarga de datos
      DescargarDatosInst := True;
      ConfigEquipo       := True;
      //GuardarValoresInstantaneos(1);
      MensajeLog('Valores instantaneos forzados ejecutada.');
      
      Result := true;
    end;

  except
    Result := false;
  end;

  // Todo ok
  ArchivoINI.Destroy;
end;


////////////////////////////////////////////////////////////////////////////////
function TServEquipoThread.GuardarNuevaConf(DirINI : string):boolean;
var
  i           : byte;
  ArchivoINI  : TIniFile;
  PathDir     : string;

begin
  ArchivoINI   := TIniFile.Create(DirINI+Nombre+'\conf\'+Nombre+'Conf.ini');
  PathDir      := DirINI + Nombre + '\conf\';

  // Cargo los datos desde el Archivo INI
  try
    // Me aseguro que exista el dir sino lo creo
    if not DirectoryExists(DirINI + Nombre) then MkDir(DirINI +Nombre);
    if not DirectoryExists(PathDir) then MkDir(PathDir);

    // Guardo los par�ametros b�sicos del equipo
    ArchivoINI.WriteString(Nombre, 'CambiarConf', 'N');
    ArchivoINI.WriteString(Nombre, 'Nombre'     , Nombre);
    ArchivoINI.WriteString(Nombre, 'Tmuestreo'  , intToStr(GetIndexTablaT(Tmuestreo)));
    for i:=0 to length(Canales)-1 do
      ArchivoINI.WriteString(Nombre,'CH'+intToStr(i)+'_conf', intToStr(Canales[i].Config));

    // Pongo el separador de las distintas secciones
    ArchivoINI.WriteString(Nombre, '--','--');

    // Configuraci�n de Internet del Equipo
    ArchivoINI.WriteString(Nombre, 'CambiarConfInternet', 'N');
    ArchivoINI.WriteString(Nombre, 'gateway'      , gateway);
    ArchivoINI.WriteString(Nombre, 'user'         , user);
    ArchivoINI.WriteString(Nombre, 'pass'         , pass);
    ArchivoINI.WriteString(Nombre, 'server'       , server);
    ArchivoINI.WriteString(Nombre, 'port'         , port);

    // Pongo el separador de las distintas secciones
    ArchivoINI.WriteString(Nombre, '-','-');

    // Configuraci�n del periodo de conexi�n
    ArchivoINI.WriteString(Nombre, 'CambiarTConect', 'N');
    ArchivoINI.WriteString(Nombre, 'IndexTConect'  , IntToStr(IndexTConect));

    // Pongo el separador de las distintas secciones
    ArchivoINI.WriteString(Nombre, '-.','.-');

    // Reconfiguraci�n Forzada
    ArchivoINI.WriteString(Nombre, 'ForzarConfig', 'N');
    ArchivoINI.WriteString(Nombre, 'ForzarDescarga', 'N');
    ArchivoINI.WriteString(Nombre, 'ForzarValoresInstantaneos', ForzarVaLInsta);

  except
    ArchivoINI.Destroy;
    result := false;
    exit;
  end;

  // Todo ok
  ArchivoINI.Destroy;
  result := true;
end;

////////////////////////////////////////////////////////////////////////////////
function TServEquipoThread.GuardarSensoresDisp(DirINI : string):boolean;
var
  DescSensores : Tstrings;
  i            : integer;
  NombreDesc   : string;

begin
  result       := false;
  NombreDesc   := DirINI+Nombre+'\conf\ListaSensores.txt';
  DescSensores := TStringList.Create;

  // Creo la lista de los sensores disponibles
  DescSensores.Clear;
  for i:=1 to Length(ListaSensores)-1 do DescSensores.Add(ListaSensores[i].ObtenerDesc);

  // Guardo la lista de los sensores disponibles
  try
    if not FileExists(NombreDesc) then DescSensores.SaveToFile(NombreDesc)
    else if DeleteFile(NombreDesc) then DescSensores.SaveToFile(NombreDesc);
    MensajeLog('Lista de sensores disponibles guardada en "'+NombreDesc+'".');
    result := true;
  except
    // Mensaje para indicar la tarea
    MensajeLog('No se pudo guardar la informaci�n en "'+NombreDesc+'"');
    MensajeLog('cerci�rese de tener permiso de escritura en "'+ExtractFilePath(NombreDesc)+'".');
  end;

  DescSensores.Destroy;
end;

////////////////////////////////////////////////////////////////////////////////
function TServEquipoThread.BorrarEquipo(DirINI : string):boolean;
var
  ArchivoINI   : TIniFile;
  SeccionesINI : TStrings;

begin
  SeccionesINI := TStringList.Create;
  ArchivoINI   := TIniFile.Create(DirINI+Nombre+'\conf\'+Nombre+'.ini');

  // Me Aseguro que exista el Archivo
  if not FileExists(ArchivoINI.FileName) then begin
    ArchivoINI.Destroy;
    SeccionesINI.Destroy;
    result := false;
    exit;
  end;

  SeccionesINI.Clear;
  ArchivoINI.ReadSections(SeccionesINI);

  // Me aseguro que este el equipo en el Archivo INI
  if not ArchivoINI.SectionExists(Nombre) then begin
    ArchivoINI.Destroy;
    SeccionesINI.Destroy;
    result := false;
    exit;
  end;

  // Borro la Configuraci�n del Equipo en el Archivo INI
  ArchivoINI.EraseSection(Nombre);

  // Libero los objetos creados
  ArchivoINI.Destroy;
  SeccionesINI.Destroy;
  result := true;
end;

////////////////////////////////////////////////////////////////////////////////
function TServEquipoThread.CargarCanales(DirINI : string): boolean;
var
  i,k,j        : integer;
  ExisteSensor : boolean;
  
begin
  result := true;
  try
    // Cargo los sensores al equipo
    CargarEquipo(DirINI);
    for i:=0 to NumCanales-1 do begin
      ExisteSensor := false; //Flag para determinar si no existe el archivo del sensor
      for j:=0 to length(ListaSensores)-1 do begin
        if (Canales[i].Config = ListaSensores[j].Config) then begin
          // Asigno el sensor al canal
          Canales[i].Asignar(ListaSensores[j]);

          // Chequeo antes de asignar si el sensor no lo tengo en el dir del Equipo
          for k:=0 to length(ListaSenDir)-1 do begin
            if Canales[i].Config = ListaSenDir[k].Config then begin
              Canales[i].Asignar(ListaSenDir[k]);
              break;
            end;
          end;

          // Me aseguro de no perder la posici�n en la lista
          Canales[i].PosLista := ListaSensores[j].PosLista;

          // Levanto la descripci�n de cada canal del archivo
          if (Canales[i].Config = Canales[i].ConfigINI) and
             (length(Canales[i].DescrINI)>0) then
            Canales[i].Descripcion := Canales[i].DescrINI;

          // Cambio el flag para indicar que exite el archivo del sensor.
          ExisteSensor := true;
        end;
      end;

      //Si no encuentro el archivo del sensor... asigno uno generico ("DATO ORIGINAL")
      if not ExisteSensor then begin
        // Asigno el sensor al canal
        Canales[i].Asignar(ListaSensores[1]);

        // Me aseguro de no perder la posici�n en la lista
        Canales[i].PosLista := ListaSensores[1].PosLista;
      end;
    end;
    GuardarEquipo(DirINI);
    CargarEquipo(DirINI);

    // En caso de problemas puedo indicar re-configurar solamente
    ForzarConfig(DirINI);

    // En caso de problemas con la memoria puedo indicar valores actuales solamente
    ForzarValoresInstantaneos(DirINI);
    
  except
    result := false;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TServEquipoThread.ConfigEntorno;
begin
  // Configuro las variables de configuraci�n
  // Config de Internet
  gateway      := Mercury.Gateway;
  user         := Mercury.User;
  pass         := Mercury.Pass;
  server       := Mercury.DirServer;
  port         := intToStr(Mercury.Puerto);
  IndexTConect := Mercury.IndexTConect;

  // Config de descarga
  PeriodoDescarga := Mercury.PeriodoDescarga;
  FormatoDescarga := Mercury.FormatoDescarga;
  IndiceFormatoFe := Mercury.IndiceFormatoFe;

  // Configuro las varable para adaptar la fecha con el formato elegido
  //FormatoFecha := Mercury.ObtenerFormatoFecha(IndiceFormatoFe);
end;

////////////////////////////////////////////////////////////////////////////////
// Funciones de uso Exclusivo de la comunicaci�n
////////////////////////////////////////////////////////////////////////////////
function TServEquipoThread.EscribirAlSocket(chs :string): boolean;
begin
  result := true;

  try
    // Me aseguro que trasmita todos los bytes
    FSocket.SendString(chs);
    if FSocket.LastError <> 0 then result := false;
  except
    // Desconexi�n inesperada
    result := false;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
function TServEquipoThread.LeerDelSocket(var chs :string; TamBuffer: integer):boolean;
var
  RequestBuf  : string;
 
begin
  result := true;
  chs    := '';

  if FSocket.CanRead(FClientTimeOut) then begin
    try
      SetLength( RequestBuf, TamBuffer );
      RequestBuf := FSocket.RecvBufferStr(TamBuffer, FClientTimeOut); if (Length(RequestBuf) >= TamBuffer) then chs := RequestBuf
      else result := false;   // El cliente envi� menos datos datos de lo esperado
    except
      result := false;        // Desconexi�n inesperada
    end;
  end
  else result := false;       // El cliente no envi� datos dentro del tiempo limite
end;

////////////////////////////////////////////////////////////////////////////////
procedure TServEquipoThread.LeerConfig;
var
  NCanal   : byte;
  numDate  : double;
  num      : integer;
  FechaINI : double;
  auxStr   : string;
  i        : byte;

begin
  // Mensaje para indicar la tarea
  MensajeLog('Leyendo la configuraci�n...');

  auxStr := '';
  if not LeerDelSocket(auxStr,50) then exit;

  // Obtengo todos los valores de los canales
  i := 1;
  for NCanal:=0 to length(Canales)-1 do begin
    num := Byte(auxStr[i])+Byte(auxStr[i+1])+Byte(auxStr[i+1])*255;
    //pvalorCH[NCanal]^ := num;
    Canales[NCanal].ValorSensor := num;
    inc(i,2);
  end;

  // Leeo la Hora del Equipo
  i := 21;
  // Formo el n�mero de la fecha a partir de los 4 Bytes (32 bits)
  numDate := Byte(auxStr[i])+Byte(auxStr[i+1])+ Byte(auxStr[i+2])+Byte(auxStr[i+3])+
             Byte(auxStr[i+1])*255+Byte(auxStr[i+2])*65535+Byte(auxStr[i+3])*16777215;

  //Paso a D�as la fecha de numDate que esta en segundos
  numDate := numDate/86400 + StrToDateTime(Hora_Base);
  Hora    := numDate;
  HoraPC  := now;

  // Leo la fecha inicial del muestreo
  i := 25;
        // Formo el n�mero de la fecha a partir de los 4 Bytes (32 bits)
  numDate   := Byte(auxStr[i])+Byte(auxStr[i+1])+ Byte(auxStr[i+2])+Byte(auxStr[i+3])+
               Byte(auxStr[i+1])*255+Byte(auxStr[i+2])*65535+Byte(auxStr[i+3])*16777215;
        //Paso a D�as la fecha de numDate que esta en segundos
  FechaINI  := numDate/86400 + StrToDateTime(Hora_Base);
  iniMuestr := FechaINI;

  // Leo el intervalo de muestreo
  i         := 29;
  Tmuestreo := (Byte(auxStr[i])+Byte(auxStr[i+1])+Byte(auxStr[i+1])*255);

  // Leeo la configuraci�n de los Canales
  i := 33;
  for NCanal:=0 to length(Canales)-1 do
    Canales[NCanal].Config := Byte(auxStr[i+NCanal]); //    pCH_conf[NCanal]^ := Byte(auxStr[i+NCanal]);

  // Leo el nombre del Equipo
  i := 43;
  Nombre := auxStr[i]+auxStr[i+1]+auxStr[i+2]+auxStr[i+3];

  // Leo la cantidad de memoria ocupada (Numeros de Bytes)
  i := 47;
  Memoria := Byte(auxStr[i])+Byte(auxStr[i+1])+Byte(auxStr[i+2])+Byte(auxStr[i+1])*255+Byte(auxStr[i+2])*65535;

  // Leo la cantidad de memoria que tiene el equipo disponible (Numeros de Bytes)
  i := 50;
  CantMemory := trunc(power(2,Byte(auxStr[i])));

  // Corrijo por caracteres invalidos en el nombre
  //if Nombre[1]='' then Nombre[1]:= 'X';
  NombreRaw   := '';
  BadChrsName := false;
  if not ValidCharsName(Nombre) then begin
    NombreRaw   := Nombre;
    Nombre      := ReplaceInvalidCharsName(Nombre);
    BadChrsName := true;
    MensajeLog('Caracter/s invalidos en el Nombre!!!');
  end;

  // Mensaje para indicar la tarea
  MensajeLog('Configuraci�n recibida correctamente.');

  // Mensaje de advertencia por equipo fuera de Linea
  if ( YearOf(Hora) = YearOf( StrToDateTime(Hora_Base) ) ) then begin
    MensajeLog('��Advertencia!! - Equipo Fuera de Linea.');
  end;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TServEquipoThread.EscribirConfig;
var
//  auxStr  : string;
  NewConf  : string;
  hora     : longint;
  Abytes   : TAbytes;
  HoraAux  : double;
  i        : integer;
  Tt       : integer;   // Periodo auxiliar de muestreo
  DelayCom : integer;   // Retardo estimado de la Comunicacion

begin
  // Estimo que la comunicacion tiene 1 seg. de retardo.
  DelayCom := 1;

  // Cargo la nueva config para los canales
  CargarNuevaConf(path);

  // Por caracteres invalidos en el Nombre
  if ( BadChrsName ) then begin
    NombreEquipo := NombreRaw;
    MensajeLog('��Advertencia!! - Usando "RAW Name" !!!');
  end;

  // Mensaje para indicar la tarea
  MensajeLog('Transmitiendo la nueva configuraci�n...');

  // Calculos de los Valores Nuevos de Configuraci�n //
  // Nueva hora del Equipo la paso a un formato de 4 bytes
  hora   := round((now-StrToDateTime(Hora_Base))*86400)+ DelayCom; //+Delay para compensar los delays
  ABytes := NumToAbytes(hora);
  Hora00 := Abytes[0];
  Hora01 := Abytes[1];
  Hora02 := Abytes[2];
  Hora03 := Abytes[3];

  // C�lculo la hora del inicio de muestreo
  if (T<60) then Tt := 60 else Tt := T;
  HoraAux := trunc(now*24)/24;
  while (HoraAux <= (now + 2/86400)) do begin
    HoraAux := HoraAux + Tt/86400; // Paso el T a D�as para poder Sumar con la Fecha Actual
  end;
  ABytes := NumToAbytes( round((HoraAux-StrToDateTime(Hora_Base))*86400)); 
  IniMuest00 := Abytes[0];
  IniMuest01 := Abytes[1];
  IniMuest02 := Abytes[2];
  IniMuest03 := Abytes[3];

  // C�lculo del nuevo periodo de muestreo
  ABytes := NumToAbytes(T);
  T00    := ABytes[0];
  T01    := ABytes[1];

  // Calculo la cuenta regresiva para muestrear
  ABytes := NumToAbytes( round((HoraAux-now)*86400) - DelayCom); //-Delay por el "+Delay" en la hora para compensar los delays
  Tregre00 := ABytes[0];
  Tregre01 := ABytes[1];

  //--------------------------------------------------------------------------//
  // Escribo el codigo para que entre a la subrrutina
{  if not EscribirAlSocket('CE') then exit;

  // Espero la se�al que indica que esta listo para recibir la nueva config
  if not PSerie.LeerDelPuertoSerie(auxStr,2) then exit;
  Retardo(500);

  // Espero la se�al ("OK") que indica que esta listo para recibir la nueva config
  i      := 0;
  auxStr := '';
  while ((auxStr <> 'OK') and (i<=200)) do begin
    if not LeerDelSocket(auxStr,2) then break;
    inc(i,1);
  end;

  // Me aseguro que si hay problemas aborto
  if (i>200) then exit;}

  // Inicializo la nueva configuraci�n
  NewConf := 'CE';

  // Escribo la nueva hora al equipo
  NewConf := NewConf + chr(Hora00);
  NewConf := NewConf + chr(Hora01);
  NewConf := NewConf + chr(Hora02);
  NewConf := NewConf + chr(Hora03);

  // Escribo la nueva hora de inicio del muestreo
  NewConf := NewConf + chr(IniMuest00);
  NewConf := NewConf + chr(IniMuest01);
  NewConf := NewConf + chr(IniMuest02);
  NewConf := NewConf + chr(IniMuest03);

  // Escribo el nuevo periodo de muestreo
  NewConf := NewConf + chr(T00);
  NewConf := NewConf + chr(T01);

  // Escribo la Cuenta regresiva para muestrear
  NewConf := NewConf + chr(Tregre00);
  NewConf := NewConf + chr(Tregre01);

  // Escribo la nueva configuraci�n de cada canal
  for i:=0 to length(ConfigCHs)-1 do
    NewConf := NewConf + chr(ConfigCHs[i]);

  // Escribo el Nombre del Equipo
  NewConf := NewConf + NombreEquipo[1];
  NewConf := NewConf + NombreEquipo[2];
  NewConf := NewConf + NombreEquipo[3];
  NewConf := NewConf + NombreEquipo[4];

  // Trasmito la nueva configuraci�n
  if EscribirAlSocket(NewConf) then begin
    // Guardo la config b�sica en archivo para poder re-configurar el equipo
    GuardarNuevaConf(path);
    // Guardo la lista de sensores disponibles
    GuardarSensoresDisp(path);
    // Mensaje para indicar la tarea
    MensajeLog('Nueva configuraci�n transmitida correctamente.');
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Comunicaci�n por Internet (TCP/IP)
procedure TServEquipoThread.EscribirConfigInternet;
var
  strIni     : string;
  strFin     : string; 
  strGateway : string;
  strServer  : string;
  auxStr     : string;
  Abytes     : TAbytes;

begin
  //
  MensajeLog('Transmitiendo la nueva configuraci�n de internet...');

  // Genero el String de Inicializaci�n del modem
  strIni := 'ATE0'+#13+'ATE0'+#13+'AT+CMGF=1'+#13+'AT+CNMI=3,2,2,0,0'+#13+'AT+CMGD=1,4'+#13
             +'AT+CREG=1'+#13;

  // Genero el String del gateway   "internet.ctimovil.com.ar","gprs","gprs"
  strGateway := 'AT+MIPCALL=1,"'+gateway+'","'+user+'","'+pass+'"'+#13+'/';

  // Genero el String del server    40000,"168.96.131.146",40000,0
  strServer := 'AT+MIPOPEN=1,'+port+',"'+server+'",'+port+',0'+#13+'/';

  // Genero el String de finalizaci�n del modem
  ABytes := NumToAbytes(CalcPeriodoConect(IndexTConect));
  strFin := chr(Abytes[1])+chr(Abytes[0])+'AT+MIPCLOSE=1'+#13+'/'+'AT+MIPCALL=0'+#13+'/';
  //strFin := chr(CalcPeriodoConect(IndexTConect))+'AT+MIPCLOSE=1'+#13+'/'+'AT+MIPCALL=0'+#13+'/';

  // Escribo toda la config de internet
  auxStr := strIni + strGateway + strServer + ';' + strFin + '#';

  // Escribo toda la config de internet
  if not EscribirAlSocket('GA' + auxStr) then
    MensajeLog('No se pudo transmitir los nuevos par�metros de internet.')
  else
    MensajeLog('Nueva configuraci�n de internet enviada.');
end;

////////////////////////////////////////////////////////////////////////////////
procedure TServEquipoThread.EscribirConfigTConect;
var
  Abytes : TAbytes;
  n      : integer;
begin
  // Escribo toda la config de internet
  ABytes := NumToAbytes(CalcPeriodoConect(IndexTConect));
  n      := (Abytes[1]*255 + Abytes[0]); // * T;

  if not EscribirAlSocket('TX'+chr(Abytes[1])+chr(Abytes[0])) then
    MensajeLog('No se pudo transmitir el nuevo peri�do.')
  else
    MensajeLog('Nuevo peri�do de conexi�n transmitido. - (Periodo = '+IntToStr(IndexTConect)+ '; ' + intToStr(n) +' muestras)');
end;

////////////////////////////////////////////////////////////////////////////////
procedure TServEquipoThread.DescargarLosDatos;
var
  i : byte;

begin
  // Configuro los nombres de los distintos archivos de descargas de datos
  ArchivoDesc   := path+Nombre+'\datos\Canales.txt';
  ArchivoBckDly := path+Nombre+'\datos\datosDiarios\'+FormatDateTime('yyyy-mm-dd', now);

  case PeriodoDescarga of
    0 : Archivo := path+Nombre+'\datos\'+FormatDateTime('dd-mm-yyyy', now);
    1 : Archivo := path+Nombre+'\datos\'+FormatDateTime('mm-yyyy', now);
  else
    Archivo := path+Nombre+'\datos\'+FormatDateTime('dd-mm-yyyy', now);
  end;

  // Configuro las varables para adaptar la descarga con el formato elegido
  case FormatoDescarga of
    0 : begin //Texto (delimitado por tabulaciones)
          sep           := #9;
          Archivo       := Archivo +'.txt';
          ArchivoBckDly := ArchivoBckDly + '.txt';
        end;

    1 : begin //CSV - Planilla de c�lculo (formato en espa�ol)
          sep           := ';';
          Archivo       := Archivo +'.csv';
          ArchivoBckDly := ArchivoBckDly + '.csv';
        end;

    2 : begin //CSV - Planilla de c�lculo (formato en ingles)
          sep           := ',';
          Archivo       := Archivo +'.csv';
          ArchivoBckDly := ArchivoBckDly + '.csv';
        end;

    3 : begin //P�gina Web
          sep           := #9;
          Archivo       := Archivo +'.txt';
          ArchivoBckDly := ArchivoBckDly + '.txt';
        end;
  else
    //Texto (delimitado por tabulaciones)
    sep           := #9;
    Archivo       := Archivo +'.txt';
    ArchivoBckDly := ArchivoBckDly + '.txt';
  end;

  // Me aseguro que no halla ning�n dato previo
  Datos.Clear;

  // Incorporo la info en el archivo de texto y los titulos
  with Datos do begin
    Add('Datos Generales');
    Add('--------------------------');
    Add('Nombre del Equipo '  +sep+': '+ Nombre);
    Add('Intervalo de Captura'+sep+': '+ Mercury.GenerarStrTmuest(Tmuestreo)); //FloatToStr(Tmuestreo div 60)+' min');
    Add('Hora del Equipo   '  +sep+': '+ Mercury.GenerarStringFecha(IndiceFormatoFe,Hora));  //FormatDateTime(FormatoFecha, Hora));
    Add('Hora de la PC     '  +sep+': '+ Mercury.GenerarStringFecha(IndiceFormatoFe,HoraPC)); //FormatDateTime(FormatoFecha, HoraPC));
    Add('');
    Add('');

    // Descripci�n de los canales
    Add('Descripci�n de los Canales');
    Add('--------------------------');
    for i:=0 to length(Canales)-1 do begin
      if (Canales[i].Config > 0) then begin //
        Add('CH '+IntToStr(i)+sep+': '+ Canales[i].Descripcion +
            ' ' + '[' + Canales[i].Unidad+']');
      end;
    end;
    Add('');
    Add('');

    // Descripci�n de los valores calculados
    Add('Valores Calculados');
    Add('--------------------------');
    for i:=0 to CalcParam.CantParm-1 do begin
      if (CalcParam.Parametros[i].Calcular = 1) then begin
        Add('VC '+IntToStr(i)+sep+': '+ CalcParam.Parametros[i].Descripcion +
            ' ' + '[' + CalcParam.Parametros[i].Unidad+']');
      end;
    end;
    Add('');
    Add('');
  end;

  // Guardo los encabezados de cada canal
  try
    if not FileExists(ArchivoDesc) then Datos.SaveToFile(ArchivoDesc)
    else if DeleteFile(ArchivoDesc) then Datos.SaveToFile(ArchivoDesc);
    MensajeLog('Descripci�n de los canales guardada en "'+ArchivoDesc+'".');
  except
    // Mensaje para indicar la tarea
    MensajeLog('No se pudo guardar la informaci�n en "'+ArchivoDesc+'"');
    MensajeLog('cerci�rese de tener permiso de escritura en "'+ExtractFilePath(ArchivoDesc)+'".');
  end;

  // Si no tengo problemas en la memoria trabajo de forma normal como logger
  //DescargarDatosInst := false;
  if not DescargarDatosInst then begin
    // Me aseguro que no hubo una discontinuidad en la transmisi�n de datos
    // si es asi tengo que bajar los datos de la memoria del equipo
    if not RupturaTransmision then GuardarValoresInstantaneos(0) // Guardo los valores de cada canal
    else LeerDatos; // Leo los datos del equipo alacenados en su memoria y guardo en el disco
  end
  else GuardarValoresInstantaneos(1);
end;

////////////////////////////////////////////////////////////////////////////////
function TServEquipoThread.RupturaTransmision:boolean;
var
  i        : byte;
  NActivos : byte;
  mem      : integer;

begin
  // Devuelve falso si no hay ruptura y verdadero si hay un hueco en los datos
 
  // me fijo cuantos canales est�n activos
  NActivos := 0;
  for i:=0 to NumCanales-1 do if (Canales[i].Config>0) then inc(NActivos,1);

  // calculo cuanto seria la memoria ocupada si solo tiene almacenado los �ltimos valores
  mem := NActivos*2 + BytesOcupados;

  // Me fijo si huvo ruptura
  if (Memoria > mem) then result := true // Huvo ruptura.
  else result := false; // No huvo ruptura.
end;

////////////////////////////////////////////////////////////////////////////////
procedure TServEquipoThread.GuardarValoresInstantaneos(TipoHora:byte);
var
  i     : byte;
  linea : string;

begin
  // Mensaje para indicar la tarea
  MensajeLog('Guardando datos instantaneos del equipo...');

  linea := '';
  for i:=0 to NumCanales-1 do begin
    // Acutalizo el valor del canal
    if Canales[i].Config<>0 then begin
      // Calculo el valor de cada canal
      Canales[i].Escala := Escala;
      Canales[i].ComputarValor(Canales[i].ValorSensor);

      // Agrego la info en la linea
      if length(Linea)>0 then Linea := Linea + sep + Canales[i].ValorReal
      else Linea := Canales[i].ValorReal;
    end;
  end;

  // Me aseguro que no halla ning�n dato previo
  Datos.Clear;

  // Guardo la info en el archivo
  try
    if not FileExists(Archivo) then begin
      //Datos.Add(FormatDateTime(FormatoFecha,Hora)+sep+Linea);
      if TipoHora=1 then
        Datos.Add(Mercury.GenerarStringFecha(IndiceFormatoFe,HoraPC)+sep+Linea)
      else
        Datos.Add(Mercury.GenerarStringFecha(IndiceFormatoFe,Hora)+sep+Linea);

      Datos.SaveToFile(Archivo);
      MensajeLog('Archivo creado, datos recibidos y guardados en '+ Archivo);
    end
    else begin
      //Datos.LoadFromFile(Archivo);
      //Datos.Add(FormatDateTime(FormatoFecha,Hora)+sep+Linea);
      if TipoHora=1 then
        Datos.Add(Mercury.GenerarStringFecha(IndiceFormatoFe,HoraPC)+sep+Linea)
      else
        Datos.Add(Mercury.GenerarStringFecha(IndiceFormatoFe,Hora)+sep+Linea);

      {
      if DeleteFile(Archivo) then begin
        Datos.SaveToFile(Archivo);
        MensajeLog('Datos recibidos y guardados en '+ Archivo);
      end;
      }

      // Guardo la info en el archivo principal
      if not SaveTstringsToTxtFile(Archivo, @Datos, 0, Datos.Count-1 ) then begin
        MensajeLog('Error al escribir en  '+ Archivo);
        Datos.SaveToFile(Archivo + '.' + FormatDateTime('yyyymmdd_hhnnss',now) + '.back' );
      end;

    end;
  except
    // Mensaje para indicar la tarea
    MensajeLog('No se pudo guardar la informaci�n en "'+Archivo+'"');
    MensajeLog('cerci�rese de tener permiso de escritura en "'+ExtractFilePath(Archivo)+'".');
  end;

  // Me aseguro de liberar memoria
  Datos.Clear;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TServEquipoThread.LeerDatos;
var
  auxStr     : string;
  Nbytes     : LongInt;
  i,j,k,kIni : LongInt;
  linea      : string;
  num        : integer;
  NCanal     : byte;
  MaxCanales : byte;
  IniMuestreo: double;
  periodo    : real;
  Nlineas    : integer;
  CanalesAct : array of byte;
  PorCenFlag : Real;

begin
  Nbytes      := Memoria;
  IniMuestreo := iniMuestr;
  periodo     := Tmuestreo;
  PorCenFlag  := 12.4;  // Procentaje que uso para actualizar el progreso de la operacion

  // Periodo de muestreo de 500 mseg.
  if (periodo = 0) then periodo := Tmin;

  // Mensaje para indicar la tarea
  MensajeLog('Leyendo '+intToStr(Nbytes)+' bytes del equipo...');

  // Me aseguro de levantar la info existente para anexarle la nueva info
  {
  if FileExists(Archivo) then Datos.LoadFromFile(Archivo)
  else Datos.Clear;
  }
  Datos.Clear;

  // Cantidad de registros actuales en el archivo 
  kIni := Datos.Count;

  // Analiso cual son los canales activos
  SetLength(CanalesAct,0);
  for i:=0 to CantCanales-1 do begin
    if (Canales[i].Config > 0) then begin
      SetLength(CanalesAct,length(CanalesAct)+1);
      CanalesAct[length(CanalesAct)-1] := i;
      Canales[i].Escala                := Escala; 
    end;
  end;
  MaxCanales := length(CanalesAct);

  if (MaxCanales > 0) and (Nbytes > BytesOcupados)then begin
    // Escribo el codigo para que entre a la subrrutina ("L"eer "D"atos)
    if not EscribirAlSocket('LD') then exit;

    // Espero que me envie el equipo el codigo "DG" Datos Guardados, para Sincronizar
    i      := 0;
    auxStr := '';
    while ((auxStr <> 'DG') and (i<=200)) do begin
      if not LeerDelSocket(auxStr,2) then break;
      inc(i,1);
    end;

    // Me aseguro que si hay problemas aborto
    if (i>200) then exit;

    // Leo los Datos
    NCanal  := 0;
    Linea   := '';
    Nlineas := 0;

    // Estos primeros 4 datos son la cantidad de memoria ocupada,
    // con esto chequeo la integridad del paquete
    LeerDelSocket(auxStr,BytesOcupados);
    num := Byte(auxStr[1])+Byte(auxStr[1+1])+Byte(auxStr[1+2])+Byte(auxStr[1+1])*255+Byte(auxStr[1+2])*65535;
    MensajeLog('--- '+intToStr(num)+' ---');

    //112b  - 4b  - 9ch 
    // Chequeo la integridad del paquete de datos
    
    if ( (num>=4) and (((num>=Nbytes-2*MaxCanales*5) and (num<=Nbytes+2*MaxCanales*(TMaxdelay/periodo))) or (Nbytes = BytesOcupados) ) ) then begin
      MensajeLog('--- Integridad OK ---');
    end
    else begin
      MensajeLog('--- Integridad DUDOSA. ---');
      if not ForzarDescarga(path) then begin
        MensajeLog('--- Comunicaci�n abortada con el equipo. ---');
        ConfigEquipo := False;
        GuardarValoresInstantaneos(0);
        exit;
      end;  
    end;
    
    // Descargo la Info
    for i:=3 to (Nbytes div 2) do begin
      auxStr := '';
      if not LeerDelSocket(auxStr,2) then break;  

      num := Byte(auxStr[1])+Byte(auxStr[2])+Byte(auxStr[2])*255;
      Canales[CanalesAct[NCanal]].ComputarValor(num);

      if length(Linea)>0 then Linea := Linea + sep + Canales[CanalesAct[NCanal]].ValorReal
      else Linea := Canales[CanalesAct[NCanal]].ValorReal;

      inc(NCanal,1);
      if (NCanal > MaxCanales-1) then begin
        // Computo el valor de los parametros a calcular, salinidad, densidad...
        for j:=0 to CalcParam.CantParm-1 do begin
          with CalcParam.Parametros[j] do begin
            if (Calcular = 1) then begin
              // Cargo la info de los valores de entrada temp, cond, profundidad...
              for k:=0 to Nparam-1 do begin
                if (AParam[k].canal >= 0) then AParam[k].valor := Canales[AParam[k].canal].ValorNum
                else AParam[k].valor := 0;
              end;

              // Calculo los par�metros salinidad, densidad.....
              CalcParam.CalcularValorParam(j);

              // Incorporo la info del parametro calculado a la linea
              Linea := Linea + sep + ResultCalcStr;
            end;
          end;
        end;

        // Incorporo la linea a la info total, que se guarda en el archivo
        //Datos.Add(FormatDateTime(FormatoFecha,IniMuestreo+Nlineas*(periodo/86400))+sep+Linea);
        Datos.Add(Mercury.GenerarStringFecha(IndiceFormatoFe,IniMuestreo+Nlineas*(periodo/86400))+sep+Linea);
        NCanal := 0;
        Linea  := '';
        inc(NLineas,1);
      end;

      // Muestro el progreso de la descarga
      if (i/(Nbytes/2))*100 > PorCenFlag then begin
        MensajeLog('Recibido... '+ FormatFloat('#.0',(i/(Nbytes/2))*100)+'%');
        PorCenFlag := PorCenFlag*2;  // Me aseguro de mostrar el progreso de a pasos 12%, 25%, 50%, 100%
      end;
    end;

    // Escribo la info en el archivo
    try
      // Guardo back en el archivo diario
      //if not SaveTstringsToTxtFile(ArchivoBckDly, @Datos, kIni, Datos.Count-1 ) then begin
      if not SaveTstringsToTxtFile(ArchivoBckDly, @Datos, 0, Datos.Count-1 ) then begin
        MensajeLog('Error al escribir el backup diario. '+ ArchivoBckDly);
        Datos.SaveToFile(ArchivoBckDly + '.' + FormatDateTime('yyyymmdd_hhnnss',now) + '.back' );
      end;

      {
      // Borro el archivo de datos principales
      if FileExists(Archivo) then begin
        if not DeleteFile(Archivo) then begin
          Datos.SaveToFile(Archivo + '.' + FormatDateTime('ddmmyyyyhhnnss',now) + '.back' );
        end;
      end;

      // Guardo la info en el archivo principal
      Datos.SaveToFile(Archivo);
      }

      // Guardo la info en el archivo principal
      if not SaveTstringsToTxtFile(Archivo, @Datos, 0, Datos.Count-1 ) then begin
        MensajeLog('Error al escribir en  '+ Archivo);
        Datos.SaveToFile(Archivo + '.' + FormatDateTime('yyyymmdd_hhnnss',now) + '.back' );
      end;

      //
      if (i-1)=(Nbytes div 2) then MensajeLog(intToStr((i-1)*2)+' bytes recibidos y guardados')
      else begin
        MensajeLog('No se pudo descargar los ' +intToStr(Nbytes)+' bytes desde el equipo.');
        MensajeLog('Comunicaci�n abortada con el equipo.');
        ConfigEquipo := False;
      end;

      {
      else begin
        if DeleteFile(Archivo) then begin
          ///////////////////
          Datos.SaveToFile(Archivo);

          //if (i>(Nbytes div 2)-2) then MensajeLog('Datos recibidos y guardados en '+ Archivo)
          if (i-1)=(Nbytes div 2) then MensajeLog(intToStr((i-1)*2)+' bytes recibidos y guardados en '+ Archivo)
          else
            begin
              MensajeLog('No se pudo descargar los ' +intToStr(Nbytes)+' bytes desde el equipo.');
              MensajeLog('Comunicaci�n abortada con el equipo.');
              ConfigEquipo := False;
            end;
        end
        else begin
          // Si no tengo permiso de escritura guardo la info en otro archivo
          try
            Datos.SaveToFile(Archivo + '.' + FormatDateTime('ddmmyyyyhhnnss',now) + '.back' );
          except
            //
          end;
        end;
      end;
      }
    except
      // Si no tengo permiso de escritura guardo la info en otro archivo
      try
        Datos.SaveToFile(Archivo + '.' + FormatDateTime('yyyymmdd_hhnnss',now) + '.back' );
      except
        //
      end;

      // Mensaje para indicar el problema
      MensajeLog('No se pudo guardar la informaci�n en "'+Archivo+'"');
      MensajeLog('cerci�rese de tener permiso de escritura en "'+ExtractFilePath(Archivo)+'".');
    end;
  end
  else MensajeLog('No habia informaci�n para ser guardada');

  // Me aseguro de liberar memoria
  SetLength(CanalesAct,0);
  Datos.Clear;
end;

////////////////////////////////////////////////////////////////////////////////
function TServEquipoThread.CalcPeriodoConect(index: byte):integer;
var
  P  : integer;
  i  : byte;
  N  : byte;
  Tp : real; // Periodo de muestreo en seg.

begin
  N  := 0;
  //T := Tmuestreo;  //!!!!!!!!!!!!!!1
  Tp := T;
  if (Tp=0) then Tp:=Tmin;

  for i:=0 to length(Canales)-1 do
    if Canales[i].Config>0 then inc(N,1);

  case index of
    // Conectar Simpre
    0 : P := 0;
    // Conectar cada 1/2 hora
    1 : P := round(30/(Tp/60))-1;
    // Conectar cada 1 hora
    2 : P := round(60/(Tp/60))-1;
    // Conectar cada 2 horas
    3 : P := round(2*60/(Tp/60))-1;
    // Conectar cada 4 horas
    4 : P := round(4*60/(Tp/60))-1;
    // Conectar cada 6 horas
    5 : P := round(6*60/(Tp/60))-1;
    // Conectar cada 8 horas
    6 : P := round(8*60/(Tp/60))-1;
    // Conectar cada 10 horas
    7 : P := round(10*60/(Tp/60))-1;
    // Conectar cada 12 horas
    8 : P := round(12*60/(Tp/60))-1;
    // Conectar cada 24 horas
    9 : P := round(24*60/(Tp/60))-1;
    // �ptima, minimo costo de comunicaci�n
    10: P := round(980/(N*2)); // 980 son los bytes maximos que meto en un paquete
  else
    P :=0;
  end;

  // Me aseguro que este en rango.
  if P>65535 then P:= 65535;
  if P<0   then P:= 0;

  // Me aseguro que como minimo no se re-conecte en un periodo menor a 10 min.
  if ((Tp<600) and (P<600/Tp)) then P:=round(600/Tp)-1;

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

////////////////////////////////////////////////////////////////////////////////
end.
