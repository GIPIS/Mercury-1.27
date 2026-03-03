unit UUtiles;

{$MODE Delphi}

interface
uses
  SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, IniFiles, UConexiones, USensor, UDiaJuliano;

type

  TMercury = class(TObject)
    private
      //
    public
      NombreExe          : string;
      NombreINIEquipos   : string; 
      DirMercury         : string;
      DirSensores        : string;
      DirEquipos         : string;
      DirDatos           : string;
      DirDatosInternet   : string;
      DirTemp            : string;
      PuertoSerie        : string;
      AutoDescargarDatos : char;
      AutoConfigurar     : char;
      SalirDescarga      : char;
      IniciarNormal      : char;
      IniciarMinimizado  : char;
      IniciarTray        : char;
      FormatoDescarga    : byte;
      IndiceFormatoFe    : byte;         // Formato de las fechas

      // Variables de internet
      Gateway            : string;
      User               : string;
      Pass               : string;
      DirServer          : string;
      Puerto             : integer;
      PeriodoDescarga    : byte;
      IndexTConect       : byte;      
      GuardarRegistro    : char;
      
      // Monitoreo en Linea
      ReporteSel         : char;
      ReporteWebSel      : char;
      DirReporte         : string;
      FormatoReporte     : byte;
      IntervaloCaptura   : byte;
      TipoArchivoReporte : byte;        // Uno por hora, uno por dia, ...
      NombrePaginaWeb    : string;      // Path y nombre de la pagina web a modificar
      NombreNuevaWeb     : string;      // Path y nombre de la pagina web a guardar

      // Variables que utilizo como flag
      DescargarDatos     : boolean;
      Configurar         : boolean;
      Salir              : boolean;
      Grabando           : boolean;

      // Variable que para el tipo de Comunicación (Serie o Telefonica)
      TipoDeComm         : byte; //0:CABLE SERIE; 1:TELEFONIA

      // Cantidad de Canales
      NumCanales         : byte;

      // Variables que utilizo en general
      HoraMuestreoLinea  : real;

      // Objeto que administra las comunicaciones telefónicas
      ConexTelefon       : TConexionesTelef;

      // Info de la conexión automática
      ConexAuto          : TConexAuto;

      constructor Crear;
      destructor  Destruir;
      procedure   CargarConfig;
      procedure   GuardarConfig;
      function    ObtenerFormatoFecha(index : integer):string;
      function    GenerarStringFecha(index : integer; fecha: TDateTime):string;
      function    GenerarStrTmuest(T : integer):string;       
  end;

  AFilesOfDir = array of TSearchRec;
  pTeroTstrings = ^Tstrings;

procedure ExtractFilesOfDir(dir :string; var ListaOfFiles :AFilesOfDir);
function  ReemplazarString(Str, ViejoStr, NuevoStr :string):string;
function  GetIndexTablaT(x: integer):byte;
function  GetValorTablaT(index: integer):integer;
function  SaveTstringsToTxtFile(FileName :string; pLines : pTeroTstrings; kIni, kFin : integer ):boolean;
function  ValidChar(Ch: char):boolean;
function  ValidCharsName(Nombre : string):boolean;
function  ReplaceInvalidCharsName(Nombre : string):string;

// Contantes
const
  Tmin      = 0.5;  // Periodo minimo de muestreo del equipo
  TMaxdelay = 10;   // Max Posible Delay entre q se recibe la config por internet y le llega el comando de descarga

// Variables globales de uso general en el programa
var
  Mercury       : TMercury;
  TablaT        : array [0..14] of integer; // Tabla del los periodos de muestreo
  TablaTMonitor : array [0..12] of real;    // Tabla del los periodos de muestreo del Monitoreo en Linea
  ListaSensores : array of TSensor;         // Lista de los sensores en el Dir de Sensores
  GraficosOpen  : integer;

implementation

////////////////////////////////////////////////////////////////////////////////
procedure ExtractFilesOfDir(dir :string; var ListaOfFiles :AFilesOfDir);
var
  sr: TSearchRec;
  FilesCont : integer;
begin
  FilesCont := 0;
  if FindFirst(dir, faAnyFile, sr) = 0 then begin
    repeat
      FilesCont := FilesCont + 1;
      SetLength(ListaOfFiles,FilesCont);
      ListaOfFiles[FilesCont-1] := sr;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
function ReemplazarString(Str, ViejoStr, NuevoStr :string):string;
var
  pc     : pchar;
  i,L    : integer;
  auxStr : string;

begin
  pc := StrPos(pchar(Str), pchar(ViejoStr));
  if (pc = nil) then begin result:=Str; exit; end;

  // Busco e inserto el nuevo string sobre el viejo
  auxStr := '';
  L      := pc-pchar(Str);

  for i:=1 to L do auxStr := auxStr + Str[i];
  auxStr := auxStr + NuevoStr;
  for i:= L+length(ViejoStr)+1 to length(Str) do auxStr := auxStr + Str[i];

  // Devuelvo la nueva cadena
  result := auxStr;
end;

////////////////////////////////////////////////////////////////////////////////
function GetIndexTablaT(x: integer):byte;
var
  i  : byte;
  ok : boolean;

begin
  result := 8;
  ok     := false;

  for i:=0 to length(TablaT) do begin
    if (TablaT[i]=x) and (not ok) then begin
      result := i;
      ok     := true;
    end;
  end;

  if not ok then result := 8; // Diez minutos de periodo de muestreo
end;

////////////////////////////////////////////////////////////////////////////////
function GetValorTablaT(index: integer):integer;
begin
  if ((index>=0) and (index<=length(TablaT))) then
    result := TablaT[index]
  else
    result := 600;
end;

////////////////////////////////////////////////////////////////////////////////
function  SaveTstringsToTxtFile(FileName :string; pLines : pTeroTstrings; kIni, kFin : integer ):boolean;
var
  F   : TextFile;
  i   : integer;
  pth : string;
  
begin
  // kinu, kFin = representan las posiciones de las lineas, entre las cuales se guardan en el file 
  //

  //
  result := true;

  // Obtengo la carpeta destino
  pth := ExtractFilePath(FileName);

  try
    // Si no existe la carpeta la creo
    if not DirectoryExists( pth + '\' ) then MkDir( pth + '\' );

    // Creo el vinculo al archivo
    AssignFile(F, FileName);

    // Creo o anexo info al archivo
    if FileExists(FileName) then Append(F)
    else Rewrite(F);

    // Escribo las lineas
    for i:=kIni to kFin do Writeln(F, pLines^.Strings[i] );

    // Cierro el archivo
    CloseFile(F);

  except

    result := false;
  end;

end;

////////////////////////////////////////////////////////////////////////////////
function ValidChar(Ch: char):boolean;
var
  j : byte;
begin
  result := true;
  j := Byte( Ch );

  if not ( ((j>=48)and(j<=57)) or ((j>=65)and(j<=90)) or ((j>=95)and(j<=122)) ) then result := false;
end;

////////////////////////////////////////////////////////////////////////////////
function ValidCharsName(Nombre : string):boolean;
var
  i : byte;
begin
  result := true;
  for i:=1 to length(Nombre) do begin
    if not ( ValidChar(Nombre[i]) ) then  result := false;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
function ReplaceInvalidCharsName(Nombre : string):string;
var
  i : byte;
begin
  for i:=1 to length(Nombre) do begin
    if not ( ValidChar(Nombre[i]) ) then  Nombre[i] := '-';
  end;

  result := Nombre;
end;

////////////////////////////////////////////////////////////////////////////////
// TMercury
////////////////////////////////////////////////////////////////////////////////
constructor TMercury.Crear;
begin
  NombreExe          := 'Mercury';
  DirMercury         := ExtractFilePath(ParamStr(0));
  DirSensores        := ExtractFilePath(ParamStr(0)) + 'Sensores\';
  DirEquipos         := ExtractFilePath(ParamStr(0)) + 'Equipos\';
  Dirdatos           := ExtractFilePath(ParamStr(0)) + 'Datos\';
  DirDatosInternet   := ExtractFilePath(ParamStr(0)) + 'Datos\';  
  Dirtemp            := ExtractFilePath(ParamStr(0)) + 'temp\';
  NombreINIEquipos   := DirEquipos;

  // Creo el objeto de las comunicaciones telefonicas
  ConexTelefon           := TConexionesTelef.Crear;
  ConexTelefon.NombreINI := ExtractFilePath(ParamStr(0)) + 'ConexTelefon.ini';

  // Creo el objeto de la conexión automática
  ConexAuto := TConexAuto.Crear;
//POR DEFECTO ES 'COM1'
  // Dirección de los distintos puertos de comunicación
  PuertoSerie        := 'COM1';
  Puerto             := 40000;

  // Tareas Automaticas
  AutoDescargarDatos := 'N';
  AutoConfigurar     := 'S';
  SalirDescarga      := 'N';

  // Control de Inicio
  IniciarNormal      := 'S';
  IniciarMinimizado  := 'N';
  IniciarTray        := 'N';

  // Formato de descarga
  FormatoDescarga    := 0;
  PeriodoDescarga    := 1; 
  IndiceFormatoFe    := 0;

  // Monitoreo en Linea
  ReporteSel         := 'S';
  ReporteWebSel      := 'N';
  DirReporte         := Dirdatos;
  FormatoReporte     := 0;
  IntervaloCaptura   := 0;
  TipoArchivoReporte := 1;
  NombrePaginaWeb    := ExtractFilePath(ParamStr(0)) + 'Plantillas Web\Plantilla01.html';
  NombreNuevaWeb     := Dirdatos+'index.htm';

  // Variables que utilizo como flag
  DescargarDatos     := false;
  Configurar         := false;
  Salir              := false;
  Grabando           := false;

  // Variables de internet
  Gateway            := 'internet.ctimovil.com.ar';
  User               := 'gprs';
  Pass               := 'gprs';
  DirServer          := '168.96.131.178';
  GuardarRegistro    := 'N';
  IndexTConect       := 1; 
//POR DEFECTO ES 0
  // Variables que para el tipo de Comunicación (Serie o Telefonica)
  TipoDeComm         := 0; // CABLE SERIE

  // Cantidad de Canales Default
  NumCanales         := 10;

  // Variables que utilizo en general
  HoraMuestreoLinea  := now;
end;

////////////////////////////////////////////////////////////////////////////////
destructor TMercury.Destruir;
begin
  // Destruyo el objeto de las comunicaciones telefónicas
  ConexTelefon.Destruir;

  // Destruyo el objeto de la conexión automática
  ConexAuto.Destruir;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TMercury.CargarConfig;
var
  ArchivoINI   : TIniFile;
  SeccionesINI : TStrings;

begin
  SeccionesINI := TStringList.Create;
  ArchivoINI   := TIniFile.Create(DirMercury+NombreExe+'.ini');

  if not FileExists(ArchivoINI.FileName) then begin
    ArchivoINI.Free;
    exit;
  end;

  try
    SeccionesINI.Clear;
    ArchivoINI.ReadSections(SeccionesINI);

    // Cargo los datos desde el Archivo INI
    Dirdatos           := ArchivoINI.ReadString(NombreExe, 'Datos'             ,DirMercury+'Datos\');
    DirdatosInternet   := ArchivoINI.ReadString(NombreExe, 'DatosInternet'     ,DirMercury+'Datos\');    
    PuertoSerie        := ArchivoINI.ReadString(NombreExe, 'PuertoSerie'       ,'COM1');
    AutoDescargarDatos := ArchivoINI.ReadString(NombreExe, 'AutoDescargarDatos','N')[1];
    AutoConfigurar     := ArchivoINI.ReadString(NombreExe, 'AutoConfigurar'    ,'N')[1];
    SalirDescarga      := ArchivoINI.ReadString(NombreExe, 'SalirDescarga'     ,'N')[1];
    IniciarNormal      := ArchivoINI.ReadString(NombreExe, 'IniciarNormal'     ,'S')[1];
    IniciarMinimizado  := ArchivoINI.ReadString(NombreExe, 'IniciarMinimizado' ,'N')[1];
    IniciarTray        := ArchivoINI.ReadString(NombreExe, 'IniciarTray'       ,'N')[1];
    FormatoDescarga    := StrToInt(ArchivoINI.ReadString(NombreExe, 'FormatoDescarga','0'));
    IndiceFormatoFe    := StrToInt(ArchivoINI.ReadString(NombreExe, 'IndiceFormatoFe','0'));

    // Variables de internet
    Gateway            := ArchivoINI.ReadString(NombreExe, 'Gateway'        , 'internet.ctimovil.com.ar');
    User               := ArchivoINI.ReadString(NombreExe, 'User'           , 'gprs');
    Pass               := ArchivoINI.ReadString(NombreExe, 'Pass'           , 'gprs');
    DirServer          := ArchivoINI.ReadString(NombreExe, 'DirServer'      , '168.96.131.146');
    GuardarRegistro    := ArchivoINI.ReadString(NombreExe, 'GuardarRegistro', 'N')[1];
    Puerto             := StrToInt(ArchivoINI.ReadString(NombreExe, 'Puerto'         , '40000'));
    PeriodoDescarga    := StrToInt(ArchivoINI.ReadString(NombreExe, 'PeriodoDescarga', '1'));
    IndexTConect       := StrToInt(ArchivoINI.ReadString(NombreExe, 'IndexTConect'   , '1'));

    // Monitoreo en Linea
    ReporteSel         := ArchivoINI.ReadString(NombreExe, 'ReporteSel'       ,'S')[1];
    ReporteWebSel      := ArchivoINI.ReadString(NombreExe, 'ReporteWebSel'    ,'N')[1];
    DirReporte         := ArchivoINI.ReadString(NombreExe, 'DirReporte'       ,DirMercury+'Datos\');
    NombrePaginaWeb    := ArchivoINI.ReadString(NombreExe, 'NombrePaginaWeb'  ,'');
    NombreNuevaWeb     := ArchivoINI.ReadString(NombreExe, 'NombreNuevaWeb'   ,'');
    FormatoReporte     := StrToInt(ArchivoINI.ReadString(NombreExe, 'FormatoReporte'    ,'0'));
    IntervaloCaptura   := StrToInt(ArchivoINI.ReadString(NombreExe, 'IntervaloCaptura'  ,'0'));
    TipoArchivoReporte := StrToInt(ArchivoINI.ReadString(NombreExe, 'TipoArchivoReporte','1'));

    // Tipo de Comunicación
    TipoDeComm         := StrToInt(ArchivoINI.ReadString(NombreExe, 'TipoDeComm','0'));

    // Cantidad de Canales
    NumCanales         := StrToInt(ArchivoINI.ReadString(NombreExe, 'NumCanales','10'));
    


    // Info de la conexión automática
    ConexAuto.intervalo    := StrToInt(ArchivoINI.ReadString(NombreExe, 'intervalo_Auto'   , '0'));
    ConexAuto.CritDesconec := StrToInt(ArchivoINI.ReadString(NombreExe, 'CritDesconec_Auto', '1'));
    ConexAuto.fecha        := ArchivoINI.ReadString(NombreExe,          'fecha_Auto'       , FormatDateTime('dd/mm/yy',now));
    ConexAuto.hora         := ArchivoINI.ReadString(NombreExe,          'hora_Auto'        , FormatDateTime('hh:nn',now));

    if upCase(AutoDescargarDatos)='S' then DescargarDatos := true;
  except
    //
  end;

  ArchivoINI.Destroy;
  SeccionesINI.Destroy;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TMercury.GuardarConfig;
var
  ArchivoINI : TIniFile;

begin
  if FileExists(DirMercury+NombreExe+'.ini') then begin
    if not DeleteFile(DirMercury+NombreExe+'.ini') then exit;
  end;

  ArchivoINI := TIniFile.Create(DirMercury+NombreExe+'.ini');
  try
    ArchivoINI.WriteString(NombreExe, 'Datos'             , DirDatos);
    ArchivoINI.WriteString(NombreExe, 'DatosInternet'     , DirDatosInternet);    
    ArchivoINI.WriteString(NombreExe, 'PuertoSerie'       , PuertoSerie);
    ArchivoINI.WriteString(NombreExe, 'AutoDescargarDatos', AutoDescargarDatos);
    ArchivoINI.WriteString(NombreExe, 'AutoConfigurar'    , AutoConfigurar);
    ArchivoINI.WriteString(NombreExe, 'SalirDescarga'     , SalirDescarga);
    ArchivoINI.WriteString(NombreExe, 'IniciarNormal'     , IniciarNormal);
    ArchivoINI.WriteString(NombreExe, 'IniciarMinimizado' , IniciarMinimizado);
    ArchivoINI.WriteString(NombreExe, 'IniciarTray'       , IniciarTray);
    ArchivoINI.WriteString(NombreExe, 'FormatoDescarga'   , IntToStr(FormatoDescarga));
    ArchivoINI.WriteString(NombreExe, 'IndiceFormatoFe'   , IntToStr(IndiceFormatoFe));

    // Variables de internet
    ArchivoINI.WriteString(NombreExe, 'Gateway'           , Gateway);
    ArchivoINI.WriteString(NombreExe, 'User'              , User);
    ArchivoINI.WriteString(NombreExe, 'Pass'              , Pass);
    ArchivoINI.WriteString(NombreExe, 'DirServer'         , DirServer);
    ArchivoINI.WriteString(NombreExe, 'GuardarRegistro'   , GuardarRegistro);
    ArchivoINI.WriteString(NombreExe, 'Puerto'            , IntToStr(Puerto));
    ArchivoINI.WriteString(NombreExe, 'PeriodoDescarga'   , IntToStr(PeriodoDescarga));
    ArchivoINI.WriteString(NombreExe, 'IndexTConect'      , IntToStr(IndexTConect));

    // Monitoreo en Linea
    ArchivoINI.WriteString(NombreExe, 'ReporteSel'        , ReporteSel);
    ArchivoINI.WriteString(NombreExe, 'ReporteWebSel'     , ReporteWebSel);
    ArchivoINI.WriteString(NombreExe, 'DirReporte'        , DirReporte);
    ArchivoINI.WriteString(NombreExe, 'NombrePaginaWeb'   , NombrePaginaWeb);
    ArchivoINI.WriteString(NombreExe, 'NombreNuevaWeb'    , NombreNuevaWeb);
    ArchivoINI.WriteString(NombreExe, 'FormatoReporte'    , IntToStr(FormatoReporte));
    ArchivoINI.WriteString(NombreExe, 'IntervaloCaptura'  , IntToStr(IntervaloCaptura));
    ArchivoINI.WriteString(NombreExe, 'TipoArchivoReporte', IntToStr(TipoArchivoReporte));

    // Tipo de Comunicación
    ArchivoINI.WriteString(NombreExe, 'TipoDeComm'        , IntToStr(TipoDeComm));

    // Cantidad de Canales
    ArchivoINI.WriteString(NombreExe, 'NumCanales'        , IntToStr(NumCanales));
    


    // Info de la conexión automática
    ArchivoINI.WriteString(NombreExe, 'intervalo_Auto'    , IntToStr(ConexAuto.intervalo));
    ArchivoINI.WriteString(NombreExe, 'CritDesconec_Auto' , IntToStr(ConexAuto.CritDesconec));
    ArchivoINI.WriteString(NombreExe, 'fecha_Auto'        , ConexAuto.fecha);
    ArchivoINI.WriteString(NombreExe, 'hora_Auto'         , ConexAuto.hora);

  except
    //
  end;

  // Guardo las conexiones telefonicas
  ConexTelefon.GuardarConexiones;

  ArchivoINI.Destroy;
end;

////////////////////////////////////////////////////////////////////////////////
function TMercury.ObtenerFormatoFecha(index : integer):string;
begin
  // Configuro las varable para adaptar la fecha con el formato elegido
  case index of
    0  : result := 'dd/mm/yyyy hh:nn:ss.zzz';
    1  : result := 'mm/dd/yyyy hh:nn:ss.zzz';
    2  : result := 'ddd/mmm/yyyy hh:nn:ss.zzz';
    3  : result := 'mmm/ddd/yyyy hh:nn:ss.zzz';
    4  : result := 'dddd/mmmm/yyyy hh:nn:ss.zzz';
    5  : result := 'mmmm/dddd/yyyy hh:nn:ss.zzz';
    6  : result := 'dd/mm/yyyy hh:nn:ss.zzz am/pm';
    7  : result := 'mm/dd/yyyy hh:nn:ss.zzz am/pm';
    8  : result := 'ddd/mmm/yyyy hh:nn:ss.zzz am/pm';
    9  : result := 'mmm/ddd/yyyy hh:nn:ss.lzzz am/pm';
    10 : result := 'dddd/mmmm/yyyy hh:nn:ss.zzz am/pm';
    11 : result := 'mmmm/dddd/yyyy hh:nn:ss.zzz am/pm';
    12 : result := 'dd-mm-yyyy hh:nn:ss.zzz';
    13 : result := 'mm-dd-yyyy hh:nn:ss.zzz';
    14 : result := 'ddd-mmm-yyyy hh:nn:ss.zzz';
    15 : result := 'mmm-ddd-yyyy hh:nn:ss.zzz';
    16 : result := 'dddd-mmmm-yyyy hh:nn:ss.zzz';
    17 : result := 'mmmm-dddd-yyyy hh:nn:ss.zzz';
    18 : result := 'dd-mm-yyyy hh:nn:ss.zzz am/pm';
    19 : result := 'mm-dd-yyyy hh:nn:ss.zzz am/pm';
    20 : result := 'ddd-mmm-yyyy hh:nn:ss.zzz am/pm';
    21 : result := 'mmm-ddd-yyyy hh:nn:ss.zzz am/pm';
    22 : result := 'dddd-mmmm-yyyy hh:nn:ss.zzz am/pm';
    23 : result := 'mmmm-dddd-yyyy hh:nn:ss.zzz am/pm';
  else
    result := 'dd/mm/yyyy hh:nn:ss.zzz';
  end;

end;

////////////////////////////////////////////////////////////////////////////////
function TMercury.GenerarStringFecha(index : integer; fecha: TDateTime):string;
begin
  // En caso de no tener un indice valido
  result := FormatDateTime(ObtenerFormatoFecha(0), fecha);

  // Genero el String de la fecha con el formato elegido
  if (index >=0) and (index <=23) then begin
    result := FormatDateTime(ObtenerFormatoFecha(index), fecha);
  end;

  case index of
    24 : result :=  FormatFloat('#.000000000000',DiaJuliano(fecha));
    25 : result :=  FormatFloat('#.000000000000',DiaJulianoModificado(fecha));
    26 : result :=  FormatFloat('#.000000000000',DiaJulianoReducido(fecha));
    27 : result :=  FormatFloat('#.000000000000',DiaJulianoTruncado(fecha));
    28 : result :=  FormatFloat('#.000000000000',DiaJulianoExcel(fecha));    
  end;
end;

////////////////////////////////////////////////////////////////////////////////
function TMercury.GenerarStrTmuest(T : integer):string;
begin
  case T of
    0         : result := '500 ms';
    1..59     : result := FloatToStr(T)+' seg';
    60..20000 : result := FloatToStr(T div 60)+' min';
  else
    result := FloatToStr(T div 60)+' min';
  end;
  
end;

////////////////////////////////////////////////////////////////////////////////
end.
