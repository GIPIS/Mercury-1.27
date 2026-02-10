unit Uprincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, ShellAPI, LCLIntf, PuertoSerie,
  ImgList, StdCtrls, Buttons, UUtiles, UEquipo, MaskEdit, UPresentacion, UExpansion,
  USensor, UPreferencias, ExtCtrls, UDataModule, UCalculoParam,
  UConexionesRemotas, UConexionAuto, UConfiguracionInternet, Types;

const
  WM_ICONTRAY = WM_USER + 1;   

type

  { TFprincipal }

  TFprincipal = class(TForm)
    Bevel102: TBevel;
    Bevel103: TBevel;
    Bevel104: TBevel;
    Bevel105: TBevel;
    Bevel106: TBevel;
    Bevel107: TBevel;
    Bevel108: TBevel;
    Bevel109: TBevel;
    Bevel110: TBevel;
    Bevel111: TBevel;
    Bevel112: TBevel;
    Bevel113: TBevel;
    Bevel114: TBevel;
    Bevel115: TBevel;
    Bevel116: TBevel;
    Bevel126: TBevel;
    Bevel75: TBevel;
    Bevel76: TBevel;
    Bevel77: TBevel;
    Bevel78: TBevel;
    Bevel79: TBevel;
    Bevel80: TBevel;
    Bevel84: TBevel;
    Bevel85: TBevel;
    Bevel86: TBevel;
    Bevel87: TBevel;
    Bevel88: TBevel;
    Bevel89: TBevel;
    Bevel90: TBevel;
    Bevel91: TBevel;
    Bevel92: TBevel;
    Bevel93: TBevel;
    Bevel94: TBevel;
    Bevel95: TBevel;
    Bevel96: TBevel;
    Bevel97: TBevel;
    Bevel98: TBevel;
    GroupBox9: TGroupBox;
    Label18: TLabel;
    Label19: TLabel;
    Label21: TLabel;
    Label24: TLabel;
    Label28: TLabel;
    Label30: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label41: TLabel;
    LDescripcion1: TLabel;
    LDescripcion2: TLabel;
    LDescripcion3: TLabel;
    LDescripcion4: TLabel;
    LDescripcion5: TLabel;
    LDescripcion6: TLabel;
    LDescripcion7: TLabel;
    LDescripcion8: TLabel;
    LDescripcion9: TLabel;
    LUnidad1: TLabel;
    LUnidad2: TLabel;
    LUnidad3: TLabel;
    LUnidad4: TLabel;
    LUnidad5: TLabel;
    LUnidad6: TLabel;
    LUnidad7: TLabel;
    LUnidad8: TLabel;
    LUnidad9: TLabel;
    LValor1: TLabel;
    LValor2: TLabel;
    LValor3: TLabel;
    LValor4: TLabel;
    LValor5: TLabel;
    LValor6: TLabel;
    LValor7: TLabel;
    LValor8: TLabel;
    LValor9: TLabel;
    MenuPrincipal: TMainMenu;
    Archivo1: TMenuItem;
    mEquipo: TMenuItem;
    Opciones1: TMenuItem;
    Ayuda1: TMenuItem;
    mAcerca: TMenuItem;
    N1: TMenuItem;
    mSalir: TMenuItem;
    N2: TMenuItem;
    sbComentario1: TSpeedButton;
    sbComentario2: TSpeedButton;
    sbComentario3: TSpeedButton;
    sbComentario4: TSpeedButton;
    sbComentario5: TSpeedButton;
    sbComentario6: TSpeedButton;
    sbComentario7: TSpeedButton;
    sbComentario8: TSpeedButton;
    sbComentario9: TSpeedButton;
    sbGrafico08_Dup: TSpeedButton;
    sbGrafico09_Dup: TSpeedButton;
    sbGrafico1: TSpeedButton;
    sbGrafico2: TSpeedButton;
    sbGrafico3: TSpeedButton;
    sbGrafico4: TSpeedButton;
    sbGrafico5: TSpeedButton;
    sbGrafico6: TSpeedButton;
    sbGrafico7: TSpeedButton;
    sbGrafico8: TSpeedButton;
    sbGrafico9: TSpeedButton;
    StatusBar: TStatusBar;
    mIraSystemtray: TMenuItem;
    PopupMenuST: TPopupMenu;
    N3: TMenuItem;
    Salir: TMenuItem;
    Restaurar: TMenuItem;
    N4: TMenuItem;
    CoolBar1: TCoolBar;
    tbPreferencias1: TToolButton;
    ToolBar1: TToolBar;
    PageControl: TPageControl;
    tsMonitoreo: TTabSheet;
    tsConfiguracion: TTabSheet;
    mTAutomaticas: TMenuItem;
    mAutoConectar: TMenuItem;
    mAutoDescargarDatos: TMenuItem;
    mSalirDescarga: TMenuItem;
    N5: TMenuItem;
    mPuertoSerie: TMenuItem;
    COM1: TMenuItem;
    mAutoConfigurar: TMenuItem;
    mDescargarDatos: TMenuItem;
    mConexionesRemotas: TMenuItem;
    N6: TMenuItem;
    mPreferencias: TMenuItem;
    tsMonitorOnLine: TTabSheet;
    sbConfigurar: TSpeedButton;
    tbCerrar: TToolButton;
    ToolButton2: TToolButton;
    tbDescargar: TToolButton;
    tbIraSystemtray: TToolButton;
    tbPreferencias: TToolButton;
    TimerCierre: TTimer;
    ToolButton1: TToolButton;
    ToolButton3: TToolButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    LNombreEquipo: TLabel;
    LHoraEquipo: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Label6: TLabel;
    LNbytesEquipo: TLabel;
    LIniMuesEquipo: TLabel;
    Bevel1: TBevel;
    Gauge: TProgressBar;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    eNombre: TEdit;
    Label5: TLabel;
    Label7: TLabel;
    cbIntervalo: TComboBox;
    sbGrabar: TSpeedButton;
    ToolButton4: TToolButton;
    tbGrabar: TToolButton;
    tbParar: TToolButton;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    Label8: TLabel;
    cbIntervaloCaptura: TComboBox;
    Label9: TLabel;
    cbTipoArchivo: TComboBox;
    Label10: TLabel;
    cbFormatoReporte: TComboBox;
    GroupBox: TGroupBox;
    Label11: TLabel;
    sbDirDatos: TSpeedButton;
    EDirReporte: TEdit;
    GroupBox5: TGroupBox;
    cbReporte: TCheckBox;
    cbReporteWeb: TCheckBox;
    Label12: TLabel;
    Label13: TLabel;
    ImgCaptura: TImage;
    Bevel2: TBevel;
    Label14: TLabel;
    EdirNuevaWeb: TEdit;
    sbSaveWeb: TSpeedButton;
    GroupBox7: TGroupBox;
    LDescConfig08: TLabel;
    LDescConfig07: TLabel;
    LDescConfig06: TLabel;
    LDescConfig05: TLabel;
    LConfig00: TLabel;
    Label25: TLabel;
    Label27: TLabel;
    LConfig01: TLabel;
    Label31: TLabel;
    LConfig02: TLabel;
    Label37: TLabel;
    LConfig03: TLabel;
    Label40: TLabel;
    LConfig04: TLabel;
    Label43: TLabel;
    LConfig05: TLabel;
    LConfig06: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    LConfig08: TLabel;
    LConfig07: TLabel;
    // Nuevas etiquetas de configuración para canales 09-15
    LConfig09: TLabel;
    LConfig10: TLabel;
    LConfig11: TLabel;
    LConfig12: TLabel;
    LConfig13: TLabel;
    LConfig14: TLabel;
    LConfig15: TLabel;
    LDescConfig00: TLabel;
    Bevel39: TBevel;
    LDescConfig01: TLabel;
    LDescConfig02: TLabel;
    LDescConfig03: TLabel;
    LDescConfig04: TLabel;
    // Nuevas etiquetas de descripción de configuración para canales 09-15
    LDescConfig09: TLabel;
    LDescConfig10: TLabel;
    LDescConfig11: TLabel;
    LDescConfig12: TLabel;
    LDescConfig13: TLabel;
    LDescConfig14: TLabel;
    LDescConfig15: TLabel;
    Bevel40: TBevel;
    Bevel41: TBevel;
    Bevel42: TBevel;
    Bevel43: TBevel;
    Bevel44: TBevel;
    Bevel45: TBevel;
    Bevel46: TBevel;
    Bevel47: TBevel;
    Bevel48: TBevel;
    Bevel49: TBevel;
    Bevel50: TBevel;
    Bevel51: TBevel;
    Bevel52: TBevel;
    Bevel53: TBevel;
    Bevel54: TBevel;
    Bevel55: TBevel;
    Bevel56: TBevel;
    Bevel57: TBevel;
    Bevel58: TBevel;
    Bevel59: TBevel;
    Bevel60: TBevel;
    Bevel61: TBevel;
    Bevel62: TBevel;
    Bevel63: TBevel;
    Bevel64: TBevel;
    Bevel65: TBevel;
    cbSensores: TComboBox;
    mCalculos: TMenuItem;
    mSalinidad: TMenuItem;
    mDensidad: TMenuItem;
    mVelocidaddelSonido: TMenuItem;
    ScrollBox: TScrollBox;
    GroupBox6: TGroupBox;
    LValor08: TLabel;
    LValor07: TLabel;
    LValor06: TLabel;
    LValor05: TLabel;
    // Nuevas etiquetas de valores para canales 09-15
    LValor09: TLabel;
    LValor10: TLabel;
    LValor11: TLabel;
    LValor12: TLabel;
    LValor13: TLabel;
    LValor14: TLabel;
    LValor15: TLabel;
    LDescripcion00: TLabel;
    LUnidad00: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    LDescripcion01: TLabel;
    LUnidad01: TLabel;
    Label20: TLabel;
    LDescripcion02: TLabel;
    LUnidad02: TLabel;
    Label23: TLabel;
    LDescripcion03: TLabel;
    LUnidad03: TLabel;
    Label26: TLabel;
    LDescripcion04: TLabel;
    LUnidad04: TLabel;
    Label29: TLabel;
    LDescripcion05: TLabel;
    LUnidad05: TLabel;
    LUnidad06: TLabel;
    LDescripcion06: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    LDescripcion08: TLabel;
    LDescripcion07: TLabel;
    LUnidad08: TLabel;
    LUnidad07: TLabel;
    // Nuevos canales visuales (09-15)
    LDescripcion09: TLabel;
    LDescripcion10: TLabel;
    LDescripcion11: TLabel;
    LDescripcion12: TLabel;
    LDescripcion13: TLabel;
    LDescripcion14: TLabel;
    LDescripcion15: TLabel;
    LUnidad09: TLabel;
    LUnidad10: TLabel;
    LUnidad11: TLabel;
    LUnidad12: TLabel;
    LUnidad13: TLabel;
    LUnidad14: TLabel;
    LUnidad15: TLabel;
    sbGrafico00: TSpeedButton;
    sbGrafico01: TSpeedButton;
    sbGrafico02: TSpeedButton;
    sbGrafico03: TSpeedButton;
    sbGrafico04: TSpeedButton;
    sbGrafico05: TSpeedButton;
    sbGrafico06: TSpeedButton;
    sbGrafico07: TSpeedButton;
    sbGrafico08: TSpeedButton;
    // Nuevos SpeedButtons gráficos para canales 09-15
    sbGrafico09: TSpeedButton;
    sbGrafico10: TSpeedButton;
    sbGrafico11: TSpeedButton;
    sbGrafico12: TSpeedButton;
    sbGrafico13: TSpeedButton;
    sbGrafico14: TSpeedButton;
    sbGrafico15: TSpeedButton;
    sbComentario00: TSpeedButton;
    sbComentario01: TSpeedButton;
    sbComentario02: TSpeedButton;
    sbComentario03: TSpeedButton;
    sbComentario04: TSpeedButton;
    sbComentario05: TSpeedButton;
    sbComentario06: TSpeedButton;
    sbComentario07: TSpeedButton;
    sbComentario08: TSpeedButton;
    // Nuevos SpeedButtons comentarios para canales 09-15
    sbComentario09: TSpeedButton;
    sbComentario10: TSpeedButton;
    sbComentario11: TSpeedButton;
    sbComentario12: TSpeedButton;
    sbComentario13: TSpeedButton;
    sbComentario14: TSpeedButton;
    sbComentario15: TSpeedButton;
    LValor00: TLabel;
    Bevel3: TBevel;
    LValor01: TLabel;
    LValor02: TLabel;
    LValor03: TLabel;
    LValor04: TLabel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Bevel6: TBevel;
    Bevel7: TBevel;
    Bevel8: TBevel;
    Bevel9: TBevel;
    Bevel10: TBevel;
    Bevel11: TBevel;
    Bevel12: TBevel;
    Bevel13: TBevel;
    Bevel14: TBevel;
    Bevel15: TBevel;
    Bevel16: TBevel;
    Bevel17: TBevel;
    Bevel18: TBevel;
    Bevel19: TBevel;
    Bevel20: TBevel;
    Bevel21: TBevel;
    Bevel22: TBevel;
    Bevel23: TBevel;
    Bevel24: TBevel;
    Bevel25: TBevel;
    Bevel26: TBevel;
    Bevel27: TBevel;
    Bevel28: TBevel;
    Bevel29: TBevel;
    Bevel30: TBevel;
    Bevel31: TBevel;
    Bevel32: TBevel;
    Bevel33: TBevel;
    Bevel34: TBevel;
    Bevel35: TBevel;
    Bevel36: TBevel;
    Bevel37: TBevel;
    Bevel38: TBevel;
    GroupBox8: TGroupBox;
    LDescripcionParam00: TLabel;
    LUnidadParam00: TLabel;
    LDescripcionParam01: TLabel;
    LUnidadParam01: TLabel;
    LDescripcionParam02: TLabel;
    LUnidadParam02: TLabel;
    sbGraficoParam00: TSpeedButton;
    sbGraficoParam01: TSpeedButton;
    sbGraficoParam02: TSpeedButton;
    LValorParam00: TLabel;
    Bevel66: TBevel;
    LValorParam01: TLabel;
    LValorParam02: TLabel;
    Bevel67: TBevel;
    Bevel68: TBevel;
    Bevel81: TBevel;
    Bevel82: TBevel;
    Bevel83: TBevel;
    Bevel99: TBevel;
    Bevel100: TBevel;
    Bevel101: TBevel;
    Bevel117: TBevel;
    Bevel118: TBevel;
    Bevel119: TBevel;
    Bevel120: TBevel;
    Bevel121: TBevel;
    Bevel122: TBevel;
    Bevel123: TBevel;
    Bevel124: TBevel;
    Bevel125: TBevel;
    SensacinTrmica1: TMenuItem;
    sbGraficoParam03: TSpeedButton;
    LUnidadParam03: TLabel;
    Bevel69: TBevel;
    LValorParam03: TLabel;
    Bevel70: TBevel;
    Bevel71: TBevel;
    LDescripcionParam03: TLabel;
    N7: TMenuItem;
    mTipoDeComunicacion: TMenuItem;
    mDirectaCableSERIE: TMenuItem;
    mTelefoniaCelular: TMenuItem;
    mConexionesTelefonicas: TMenuItem;
    mConexionAuto: TMenuItem;
    mConexionMan: TMenuItem;
    N8: TMenuItem;
    tbConexAutoEN: TToolButton;
    ToolButton7: TToolButton;
    tbDesconectar: TToolButton;
    N9: TMenuItem;
    mDesconectar: TMenuItem;
    mInternet: TMenuItem;
    mConfiguracionDeInternet: TMenuItem;
    N10: TMenuItem;
    tsInternet: TTabSheet;
    mHistorialInternet: TMemo;
    N11: TMenuItem;
    mBorrarHistorial: TMenuItem;
    mConductividadCorr: TMenuItem;
    LDescripcionParam04: TLabel;
    LValorParam04: TLabel;
    LUnidadParam04: TLabel;
    sbGraficoParam04: TSpeedButton;
    Bevel72: TBevel;
    Bevel73: TBevel;
    Bevel74: TBevel;
    procedure Bevel102ChangeBounds(Sender: TObject);
    procedure Bevel107ChangeBounds(Sender: TObject);
    procedure Bevel27ChangeBounds(Sender: TObject);
    procedure Bevel28ChangeBounds(Sender: TObject);
    procedure Bevel29ChangeBounds(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GroupBox6Click(Sender: TObject);
    procedure GroupBox9Click(Sender: TObject);
    procedure mSalirClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure IraSystemTray;
    procedure mIraSystemtrayClick(Sender: TObject);
    procedure RestaurarClick(Sender: TObject);
    procedure SalirClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ActualizarInfo(Sender: TObject);
    function  CentrarTexto(texto:string; Ancho:integer):string;
    procedure tsConfiguracionShow(Sender: TObject);
    procedure cbSensoresCloseUp(Sender: TObject);
    procedure cbSensoresExit(Sender: TObject);
    procedure sbConfigurarClick(Sender: TObject);
    procedure CrearListaSensores;
    procedure mAcercaClick(Sender: TObject);
    procedure mDescargarDatosClick(Sender: TObject);
    procedure StatusBarDrawPanel(StatusBar: TStatusBar;
      Panel: TStatusPanel; const Rect: TRect);
    procedure ActualizarProgreso(Sender: TObject);
    procedure CargarDatosConfig;
    procedure mAutoDescargarDatosClick(Sender: TObject);
    procedure mAutoConfigurarClick(Sender: TObject);
    procedure mSalirDescargaClick(Sender: TObject);
    procedure PuertoSerieClick(Sender: TObject);
    procedure mPreferenciasClick(Sender: TObject);
    procedure tbExpansionClick (Sender:Tobject);

    procedure TimerCierreTimer(Sender: TObject);
    procedure LimpiarMonitor;
    procedure sbGrabarClick(Sender: TObject);
    procedure tsMonitoreoContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure tsMonitorOnLineShow(Sender: TObject);
    procedure sbDirDatosClick(Sender: TObject);
    procedure MonitoreoEnLinea;
    procedure GenerarReporteWeb;
    procedure BotonGraficoCanalClick(Sender: TObject);
    procedure sbComentarioClick(Sender: TObject);
    procedure sbSaveWebClick(Sender: TObject);
    procedure LConfigsClick(Sender: TObject);
    procedure mCalculosParam(Sender: TObject);
    procedure TipoDeComunicacionClick(Sender: TObject);
    procedure mConexionesTelefonicasClick(Sender: TObject);
    procedure mConexionAutoClick(Sender: TObject);
    procedure ConexionManualClick(Sender: TObject);
    procedure ConcectarConRemoto(index : integer;  AutoDesconecDesc, AutoDesconecConf : boolean);
    procedure DesconcectarConRemoto;
    procedure mDesconectarClick(Sender: TObject);
    procedure ConexionAutomatica(Sender: TObject);
    procedure ONConexionRemota(Sender: TObject);
    procedure ONDesconexionRemota(Sender: TObject);
    procedure mConfiguracionDeInternetClick(Sender: TObject);
    procedure PageControlChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure PageControlChange(Sender: TObject);
    procedure mHistorialInternetChange(Sender: TObject);
    procedure mBorrarHistorialClick(Sender: TObject);
    
    // Procedimientos para los nuevos canales visuales (09-15)
    procedure sbGrafico09Click(Sender: TObject);
    procedure sbGrafico10Click(Sender: TObject);
    procedure sbGrafico11Click(Sender: TObject);
    procedure sbGrafico12Click(Sender: TObject);
    procedure sbGrafico13Click(Sender: TObject);
    procedure sbGrafico14Click(Sender: TObject);
    procedure sbGrafico15Click(Sender: TObject);
    procedure sbComentario09Click(Sender: TObject);
    procedure sbComentario10Click(Sender: TObject);
    procedure sbComentario11Click(Sender: TObject);
    procedure sbComentario12Click(Sender: TObject);
    procedure sbComentario13Click(Sender: TObject);
    procedure sbComentario14Click(Sender: TObject);
    procedure sbComentario15Click(Sender: TObject);

  private
    TrayIconData: TNotifyIconData;
    { Private declarations }
  public
    procedure TrayMessage(var Msg: TMessage); message WM_ICONTRAY;
    procedure ActualizarVisibilidadCanales(Es16Canales: Boolean);
    procedure InstanciarComponentesFaltantes;
    { Public declarations }
  end;

var
  Fprincipal    : TFprincipal;
  PSerie        : TPuertoSerie;  
  PorPrimerVez  : boolean;
  Cerrando      : boolean;
  Creando       : boolean;
  ActualizarCHs : boolean;                  // Carga los sensores al Equipo
  Equipo        : TEquipo;                  // Objeto que realiza toda la intefaze con el equipo fisico
  //Server        : TServer;                  // Objeto que administra la conexi�n por Internet
  NCanal        : integer;                  // Numero del Canal Activo por el ComboBox de Config
  TagOLD        : integer;
  OnCambio      : boolean;
  IniLine       : integer;                  // Ultima linea del log guardada en file

implementation

uses UFormulas, UConexiones;

{$R *.lfm}

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.FormCreate(Sender: TObject);
var
  NewItem : TMenuItem;
  i       : integer;

begin
  //show;      

  // Creo la presentaci�n
  FPresentacion := TFPresentacion.Create(Self);
  FPresentacion.Show;
  FPresentacion.Repaint;

  // Configuro las variables globales
  DefaultFormatSettings.DateSeparator      := '/';
  DefaultFormatSettings.DecimalSeparator   := '.';
  DefaultFormatSettings.ShortDateFormat    := 'dd/mm/yyyy';
  DefaultFormatSettings.LongDateFormat     := 'dd/mm/yyyy';
  PageControl.ActivePageIndex      := 0;
  ScrollBox.VertScrollBar.Position := 0;
  TagOLD                           := 0;
  GraficosOpen                     := 0;
  PorPrimerVez                     := true;
  Cerrando                         := false;
  OnCambio                         := false;
  IniLine                          := 0;
  Creando                          := true;
  ActualizarCHs                    := true;
  Mercury                          := TMercury.Crear;
  Equipo                           := nil;
  //Server                           := nil;

  // Cargo la configuraci�n del programa guardada en el Archivo INI
  FPresentacion.LMensaje.Caption := 'Cargando Configuraci�n...';
  FPresentacion.Repaint;
  Mercury.CargarConfig;
  Retardo(200);

  // Cargo la config a la aplicaci�n, a las vantanas, etc
  CargarDatosConfig;

  // Cargo la configuraci�n de las Comuicaciones Telef�nicas guardada en el Archivo INI
  FPresentacion.LMensaje.Caption := 'Cargando conexiones remotas...';
  FPresentacion.Repaint;
  Mercury.ConexTelefon.CargarConexiones;
  Mercury.ConexAuto.pEnHora := ConexionAutomatica;

  // Cargo la lista de puertos serie en el men�
  mConexionMan.Clear;
  for i:=0 to Mercury.ConexTelefon.NumConex-1 do begin
    NewItem         := TMenuItem.Create(Self);
    NewItem.Tag     := i;
    NewItem.Checked := false;
    NewItem.Caption := Mercury.ConexTelefon.AConexiones[i].Nombre;
    NewItem.OnClick := ConexionManualClick;
    mConexionMan.Add(NewItem);    
  end;
  Retardo(200);
  
  // Creo la tabla de perioodos de muestreo del Monitoreo en Linea
  TablaTMonitor[0] := 0.45/86400; TablaTMonitor[1] := 0.9/86400;  TablaTMonitor[2] := 4.9/86400;
  TablaTMonitor[3] := 9.9/86400;  TablaTMonitor[4] := 29.9/86400; TablaTMonitor[5] := 1/1440;
  TablaTMonitor[6] := 2/1440;     TablaTMonitor[7] := 5/1440;     TablaTMonitor[8] := 10/1440;
  TablaTMonitor[9] := 15/1440;    TablaTMonitor[10]:= 20/1440;    TablaTMonitor[11]:= 30/1440;
  TablaTMonitor[12]:= 1/24;

  // Creo la tabla de perioodos de muestreo.
  TablaT[0] := 0;    TablaT[1] := 1;     TablaT[2] := 2;     TablaT[3] := 5;  TablaT[4] := 10;
  TablaT[5] := 60;   TablaT[6] := 120;   TablaT[7] := 300;   TablaT[8] := 600;
  TablaT[9] := 900;  TablaT[10]:= 1800; TablaT[11]:= 3600;  TablaT[12]:= 5400;
  TablaT[13]:= 7200;

  // Obtengo la lista de Puerto serie que tiene la PC
  FPresentacion.LMensaje.Caption := 'Buscando Puertos Serie...';
  FPresentacion.Repaint;
  PSerie := TPuertoSerie.Crear;
  PSerie.CrearListaPuertosSerie;
  Retardo(200);

  // Cargo la lista de puertos serie en el men�
  mPuertoSerie.Clear;
  for i:=0 to PSerie.ListaPorts.Count-1 do begin
    NewItem         := TMenuItem.Create(Self);
    NewItem.Checked := false;
    NewItem.Caption := PSerie.ListaPorts.Strings[i];
    NewItem.OnClick := PuertoSerieClick;
    if (PSerie.ListaPorts.Strings[i] = Mercury.PuertoSerie) then NewItem.Checked := true;
    mPuertoSerie.Add(NewItem);
  end;

  // Inicializo el Tipo de Comunicaci�n SERIE O CELULAR
  FPresentacion.LMensaje.Caption := 'Iniciando el motor de comunicaciones ...';
  FPresentacion.Repaint;
  mDirectaCableSERIE.Checked := false;
  mTelefoniaCelular.Checked  := false;

  case Mercury.TipoDeComm of
    0 : mDirectaCableSERIE.Checked := true;
    1 : mTelefoniaCelular.Checked  := true;
    2 : mInternet.Checked          := true;
  else
    mDirectaCableSERIE.Checked := true;
  end;
  Retardo(200);

  // Creo y Configuro el Equipo con 10 canales si es necesario por el tipo de Comunicaci�n
  if (Mercury.TipoDeComm <> 2) then begin
    Equipo                           := TEquipo.crear(10,Mercury.PuertoSerie, Mercury.TipoDeComm);
    Equipo.ThreadComm.pProgreso      := @statusbar.Tag;
    Equipo.ThreadComm.pActualizar    := ActualizarInfo;
    Equipo.ThreadComm.pActualProgres := ActualizarProgreso;
    Equipo.ThreadComm.POnConectRemoto:= ONConexionRemota;
    Equipo.ThreadComm.POnDesConRemoto:= ONDesconexionRemota;
  end;

  // Creo y configuro el Socket si es necesario para porder comunicarme por internet
  //if (Mercury.TipoDeComm = 2) then Server := TServer.Crear(Mercury.Puerto,@mHistorialInternet.Lines);

  // Creo la lista de los sensores que se encuentran el  DirSensores
  FPresentacion.LMensaje.Caption := 'Generando lista de Sensores...';
  FPresentacion.Repaint;
  CrearListaSensores;
  Retardo(200);

  // Configuro las opciones de captura
  tsMonitorOnLineShow(sender);

  // Libero la Ventana de Presentaci�n (sola se libera despues de 500ms)
  FPresentacion.Timer1.Interval := 500;
  FPresentacion.Timer1.Enabled  := true;
  Creando                       := false;


  // Manera de iniciar la ventana Principal Inicio
  if UpCase(Mercury.IniciarMinimizado)='S' then begin
    Fprincipal.WindowState := wsMinimized;
    Fprincipal.show;
    exit;
  end;

  if UpCase(Mercury.IniciarTray)      ='S' then begin
    IraSystemTray;
    Fprincipal.WindowState := wsMinimized;
    exit;
  end;


  // Prueba de Ocultar la primera solapa
  //PageControl.Pages[0].TabVisible := false;

  // Estado inicial: 8 Canales (ocultar canales 08-15)
  InstanciarComponentesFaltantes;
  ActualizarVisibilidadCanales(False);
end;

procedure TFprincipal.GroupBox6Click(Sender: TObject);
begin

end;

procedure TFprincipal.GroupBox9Click(Sender: TObject);
begin

end;

procedure TFprincipal.Bevel29ChangeBounds(Sender: TObject);
begin

end;

procedure TFprincipal.Bevel107ChangeBounds(Sender: TObject);
begin

end;

procedure TFprincipal.Bevel27ChangeBounds(Sender: TObject);
begin

end;

procedure TFprincipal.Bevel102ChangeBounds(Sender: TObject);
begin

end;

procedure TFprincipal.Bevel28ChangeBounds(Sender: TObject);
begin

end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i      : integer;
  AFiles : AFilesOfDir;

begin
  Cerrando := true;

  // Borro todos los archivos del Directorio Temporal
  if DirectoryExists(Mercury.DirTemp) then begin
    SetLength(AFiles, 0); // Inicializar el array
    ExtractFilesOfDir(Mercury.DirTemp + '*.*', AFiles);
    for i:=0 to length(AFiles)-1 do DeleteFile(PChar(Mercury.DirTemp + AFiles[i].Name));
  end;

  // Borro el icono de la barra de tareas
  Shell_NotifyIcon(NIM_DELETE, PNOTIFYICONDATAA(@TrayIconData));
  if (Equipo <> nil) then Equipo.Destruir;
  //if (Server <> nil) then Server.Destroy;
  Mercury.GuardarConfig;
  Mercury.Destruir;

  // Libero la lista de Sensores
  for i:=length(ListaSensores)-1 downto 0 do begin
    if Assigned(ListaSensores[i]) then
      ListaSensores[i].Destruir;
  end;
  SetLength(ListaSensores, 0);

  // Libero los Objetos Creados
  PSerie.Destruir;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.CargarDatosConfig;
begin
  if (UpCase(Mercury.AutoDescargarDatos) = 'S') then mAutoDescargarDatos.Checked := true;
  if (UpCase(Mercury.AutoConfigurar)     = 'S') then mAutoConfigurar.Checked     := true;
  if (UpCase(Mercury.SalirDescarga)      = 'S') then mSalirDescarga.Checked      := true;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.mSalirClick(Sender: TObject);
begin
  close;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.TrayMessage(var Msg: TMessage);
var
  CursorPos : TPoint;

begin
  case Msg.lParam of
    WM_LBUTTONDOWN:
    begin
      // Restore window on left click
      WindowState := wsNormal;
      Show;
      Shell_NotifyIcon(NIM_DELETE, PNOTIFYICONDATAA(@TrayIconData));
    end;

    WM_RBUTTONDOWN:
    begin
      GetCursorPos(CursorPos);
      PopupMenuST.Popup(CursorPos.X,CursorPos.Y);
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.IraSystemTray;
begin
  with TrayIconData do begin
    cbSize           := SizeOf(TrayIconData);
    hWnd             := Handle;
    uID              := 0;
    uFlags           := NIF_MESSAGE + NIF_ICON + NIF_TIP;
    uCallbackMessage := WM_ICONTRAY;
    hIcon            := Application.Icon.Handle;
    StrPCopy(szTip, Caption);
  end;

  Shell_NotifyIcon(NIM_ADD, PNOTIFYICONDATAA(@TrayIconData));
  Hide;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.mIraSystemtrayClick(Sender: TObject);
begin
  IraSystemTray;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.RestaurarClick(Sender: TObject);
begin
  WindowState := wsNormal;
  show;
  Shell_NotifyIcon(NIM_DELETE, PNOTIFYICONDATAA(@TrayIconData));
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.SalirClick(Sender: TObject);
begin
  close;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.FormActivate(Sender: TObject);
begin
  if not PorPrimerVez then exit;
  PorPrimerVez := false;

  // habilito el bot�n para indicar que est� habilitada la conexi�n auto
  if (Mercury.ConexAuto.intervalo > 0) then begin
    tbConexAutoEN.Enabled := true;
    tbConexAutoEN.Hint    := 'Conexiones automaticas habilitadas';
  end
  else begin
    tbConexAutoEN.Enabled := false;
    tbConexAutoEN.Hint    := 'Conexiones automaticas deshabilitadas';
  end;

  // Si estoy en modalidad "Telefonia Celular" habilito los menus de conexiones remotas
  if (Mercury.TipoDeComm = 1) then begin
    mConexionesTelefonicas.Enabled := true;
    mConexionAuto.Enabled          := true;
    mConexionMan.Enabled           := true;
  end;

  // Chequeo los par�metros de la conexi�n autom�tica y habilito la timer para la conexi�n
  Mercury.ConexAuto.ChequearParam;
  Mercury.ConexAuto.CalcularFecha;
  Mercury.ConexAuto.CalcularMomentoConx;

  // Inicio la cuenta regreciva de ser necesario
  if (Mercury.TipoDeComm = 1) and (Mercury.ConexAuto.intervalo>0) then Mercury.ConexAuto.IniciarCuentaRegreciva;

  // Si est� habilitada la conexi�n por internet desabilito todas la paginas.
  if (Mercury.TipoDeComm = 2) then begin
    PageControl.ActivePageIndex := 3;
    tsMonitoreo.Enabled         := false;
    tsConfiguracion.Enabled     := false;
    tsMonitorOnLine.Enabled     := false;

    // Activo el Server para que se ponga a escuchar en el puerto predeterminado
    //Server.SrvSocket.Active     := true;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.ActualizarInfo(Sender: TObject);
var
  i, j, k      : integer;
  ExisteSensor : boolean;

begin
  if (Cerrando or Creando) then exit;

  // Procedimiento que actualiza la info del equipo en la pantalla
  if not Equipo.ThreadComm.ONLine then begin
    StatusBar.Panels[0].Text    := 'Equipo fuera de Linea';
    ActualizarCHs               := true;
    LimpiarMonitor;
    if (PageControl.ActivePageIndex = 2) then
      if PageControl.Pages[0].TabVisible then PageControl.ActivePageIndex := 0
      else PageControl.ActivePageIndex := 1;
    // Desabilito los botones del monitoreo en linea
    sbGrabar.Enabled := false;
    tbGrabar.Enabled := false;
    // Detengo el monitoreo en Linea
    if Mercury.Grabando then sbGrabarClick(Sender);
    exit;
  end;

  // Actualizo el cartel de la barra de estado
  if not Equipo.ThreadComm.DescargarDatos then
    StatusBar.Panels[0].Text := 'Conectado con "' + Equipo.Nombre + '"';

  // Cargo los sensores al equipo
  if ActualizarCHs and (not Equipo.ThreadComm.ConfigEquipo) then begin
    Equipo.CargarEquipo(Mercury.DirEquipos);
    for i:=0 to Equipo.NumCanales-1 do begin
      ExisteSensor := false; //Flag para determinar si no existe el archivo del sensor
      for j:=0 to length(ListaSensores)-1 do begin
        if (Equipo.Canales[i].Config = ListaSensores[j].Config) then
        begin
          // Asigno el sensor al canal
          Equipo.Canales[i].Asignar(ListaSensores[j]);

          // Chequeo antes de asignar si el sensor no lo tengo en el dir del Equipo
          for k:=0 to length(Equipo.ListaSenDir)-1 do begin
            if Equipo.Canales[i].Config = Equipo.ListaSenDir[k].Config then begin
              Equipo.Canales[i].Asignar(Equipo.ListaSenDir[k]);
              break;
            end;
          end;

          // Me aseguro de no perder la posici�n en la lista
          Equipo.Canales[i].PosLista := ListaSensores[j].PosLista;

          // Levanto la descripci�n de cada canal del archivo
          if (Equipo.Canales[i].Config = Equipo.Canales[i].ConfigINI) and
             (length(Equipo.Canales[i].DescrINI)>0) then
            Equipo.Canales[i].Descripcion := Equipo.Canales[i].DescrINI;

          // Cambio el flag para indicar que exite el archivo del sensor.
          ExisteSensor := true;
        end;
      end;

      //Si no encuentro el archivo del sensor... asigno uno generico ("DATO ORIGINAL")
      if not ExisteSensor then begin
        // Asigno el sensor al canal
        Equipo.Canales[i].Asignar(ListaSensores[1]);

        // Me aseguro de no perder la posici�n en la lista
        Equipo.Canales[i].PosLista := ListaSensores[1].PosLista;
      end;
    end;
    // Me fijo que canal digital Uso...  
    if (Equipo.Canales[Equipo.NumCanales-1].Config<>0) then Equipo.UsarCH9 := true
    else Equipo.UsarCH9 := false;
    //
    Equipo.GuardarEquipo(Mercury.DirEquipos);
    Equipo.CargarEquipo(Mercury.DirEquipos);
    ActualizarCHs := false;
  end;

  // Habilito los Botones
  tbDescargar.Enabled              := true;
  mDescargarDatos.Enabled          := true;
  mConfiguracionDeInternet.Enabled := true;

  // Habilito los Botones para el monitoreo en linea
  if not Mercury.Grabando then begin
    sbGrabar.Enabled := true;
    tbGrabar.Enabled := true;
  end;  

  // Cargo la Info del Equipo en pantalla
  LNombreEquipo.Caption  := Equipo.Nombre;
  LHoraEquipo.Caption    := FormatDateTime('dd/mm/yyyy hh:nn:ss am/pm',Equipo.Hora);
  LNbytesEquipo.Caption  := IntToStr(Equipo.Memoria)+' bytes';
  Gauge.Position         := (Equipo.Memoria*100) div Equipo.CantMemory;
  LIniMuesEquipo.Caption := FormatDateTime('dd/mm/yyyy hh:nn:ss am/pm',Equipo.iniMuestr)
                            + ' - (int '+ Mercury.GenerarStrTmuest(Equipo.Tmuestreo) +')';


  //IntToStr(Equipo.Tmuestreo div 60)+' min

  // Cargo la info de los canales en pantalla 
  for i:=0 to Equipo.NumCanales-1 do begin
     // Muestro la Descripci�n
    case i of
     0 : LDescripcion00.Caption := Equipo.Canales[i].Descripcion;
     1 : LDescripcion01.Caption := Equipo.Canales[i].Descripcion;
     2 : LDescripcion02.Caption := Equipo.Canales[i].Descripcion;
     3 : LDescripcion03.Caption := Equipo.Canales[i].Descripcion;
     4 : LDescripcion04.Caption := Equipo.Canales[i].Descripcion;
     5 : LDescripcion05.Caption := Equipo.Canales[i].Descripcion;
     6 : LDescripcion06.Caption := Equipo.Canales[i].Descripcion;
     7 : LDescripcion07.Caption := Equipo.Canales[i].Descripcion;
     // Canales Digitales
     8 : if not Equipo.UsarCH9 then LDescripcion08.Caption := Equipo.Canales[i].Descripcion;
     9 : if Equipo.UsarCH9 then LDescripcion08.Caption := Equipo.Canales[i].Descripcion;
    end;

    // Acutalizo el valor del canal
    if Equipo.Canales[i].Config<>0 then begin
      // Calculo el valor de cada canal
      Equipo.Canales[i].Escala := Equipo.Escala;
      Equipo.Canales[i].ComputarValor(Equipo.Canales[i].ValorSensor);

      // Muestro el valor del canal
      case i of
       0 : begin LValor00.Caption:=Equipo.Canales[i].ValorReal; LUnidad00.Caption:='['+Equipo.Canales[i].Unidad+']'; sbGrafico00.Enabled := true; sbComentario00.Enabled := true; end;
       1 : begin LValor01.Caption:=Equipo.Canales[i].ValorReal; LUnidad01.Caption:='['+Equipo.Canales[i].Unidad+']'; sbGrafico01.Enabled := true; sbComentario01.Enabled := true; end;
       2 : begin LValor02.Caption:=Equipo.Canales[i].ValorReal; LUnidad02.Caption:='['+Equipo.Canales[i].Unidad+']'; sbGrafico02.Enabled := true; sbComentario02.Enabled := true; end;
       3 : begin LValor03.Caption:=Equipo.Canales[i].ValorReal; LUnidad03.Caption:='['+Equipo.Canales[i].Unidad+']'; sbGrafico03.Enabled := true; sbComentario03.Enabled := true; end;
       4 : begin LValor04.Caption:=Equipo.Canales[i].ValorReal; LUnidad04.Caption:='['+Equipo.Canales[i].Unidad+']'; sbGrafico04.Enabled := true; sbComentario04.Enabled := true; end;
       5 : begin LValor05.Caption:=Equipo.Canales[i].ValorReal; LUnidad05.Caption:='['+Equipo.Canales[i].Unidad+']'; sbGrafico05.Enabled := true; sbComentario05.Enabled := true; end;
       6 : begin LValor06.Caption:=Equipo.Canales[i].ValorReal; LUnidad06.Caption:='['+Equipo.Canales[i].Unidad+']'; sbGrafico06.Enabled := true; sbComentario06.Enabled := true; end;
       7 : begin LValor07.Caption:=Equipo.Canales[i].ValorReal; LUnidad07.Caption:='['+Equipo.Canales[i].Unidad+']'; sbGrafico07.Enabled := true; sbComentario07.Enabled := true; end;
       // Canales Digitales
       8 : if not Equipo.UsarCH9 then begin LValor08.Caption:=Equipo.Canales[i].ValorReal; LUnidad08.Caption:='['+Equipo.Canales[i].Unidad+']'; sbGrafico08.Enabled := true; sbComentario08.Enabled := true; end;
       9 : if Equipo.UsarCH9 then begin LValor08.Caption:=Equipo.Canales[i].ValorReal; LUnidad08.Caption:='['+Equipo.Canales[i].Unidad+']'; sbGrafico08.Enabled := true; sbComentario08.Enabled := true; end;
      end;

      {sgCanales.Cells[2,i+1]:= CentrarTexto(Equipo.Canales[i].ValorReal,sgCanales.ColWidths[2]);
      sgCanales.Cells[3,i+1]:= CentrarTexto(Equipo.Canales[i].Unidad,sgCanales.ColWidths[3]);}
    end
    else begin
      // Muestro el valor del canal
      case i of
       0 : begin LValor00.Caption:=''; LUnidad00.Caption:=''; sbGrafico00.Enabled := false; sbComentario00.Enabled := false; end;
       1 : begin LValor01.Caption:=''; LUnidad01.Caption:=''; sbGrafico01.Enabled := false; sbComentario01.Enabled := false; end;
       2 : begin LValor02.Caption:=''; LUnidad02.Caption:=''; sbGrafico02.Enabled := false; sbComentario02.Enabled := false; end;
       3 : begin LValor03.Caption:=''; LUnidad03.Caption:=''; sbGrafico03.Enabled := false; sbComentario03.Enabled := false; end;
       4 : begin LValor04.Caption:=''; LUnidad04.Caption:=''; sbGrafico04.Enabled := false; sbComentario04.Enabled := false; end;
       5 : begin LValor05.Caption:=''; LUnidad05.Caption:=''; sbGrafico05.Enabled := false; sbComentario05.Enabled := false; end;
       6 : begin LValor06.Caption:=''; LUnidad06.Caption:=''; sbGrafico06.Enabled := false; sbComentario06.Enabled := false; end;
       7 : begin LValor07.Caption:=''; LUnidad07.Caption:=''; sbGrafico07.Enabled := false; sbComentario07.Enabled := false; end;
       // Canales Digitales
       8 : if not Equipo.UsarCH9 then begin LValor08.Caption:=''; LUnidad08.Caption:=''; sbGrafico08.Enabled := false; sbComentario08.Enabled := false; end;
       end;
    end;
  end;

  // Actualizo la info y el valor de los parametros calculados
  for i:=0 to Equipo.CalcParam.CantParm-1 do begin
    with Equipo.CalcParam.Parametros[i] do begin
      if Calcular = 1 then begin
          // Cargo la info de los valores de entrada temp, cond, profundidad...
        for j:=0 to Nparam-1 do begin
          // me aseguro que el canal est� habilitado
          if (AParam[j].canal >= 0) then begin
            if (Equipo.Canales[AParam[j].canal].Config > 0) then
              AParam[j].valor := Equipo.Canales[AParam[j].canal].ValorNum
            else begin
              // Si falta un par�metro que no es necesario no importa
              if (j<NparamNecesa) then Calcular := 0
              else AParam[j].valor := 0;
            end;
          end
          // Si falta un par�metro que no es necesario no importa
          else AParam[j].valor := 0;
        end;

        // Calculo los par�metros salinidad, densidad.....
        Equipo.CalcParam.CalcularValorParam(i);
      end;

      // Muestro la info de los par�metros calculados cuando es necesario
      if (Calcular = 1) then begin
        case i of
          0 : begin LDescripcionParam00.Caption := Descripcion; LValorParam00.Caption:=ResultCalcStr; LUnidadParam00.Caption:='['+Unidad+']'; sbGraficoParam00.Enabled := false; end; //True
          1 : begin LDescripcionParam01.Caption := Descripcion; LValorParam01.Caption:=ResultCalcStr; LUnidadParam01.Caption:='['+Unidad+']'; sbGraficoParam01.Enabled := false; end; //True
          2 : begin LDescripcionParam02.Caption := Descripcion; LValorParam02.Caption:=ResultCalcStr; LUnidadParam02.Caption:='['+Unidad+']'; sbGraficoParam02.Enabled := false; end; //True
          3 : begin LDescripcionParam03.Caption := Descripcion; LValorParam03.Caption:=ResultCalcStr; LUnidadParam03.Caption:='['+Unidad+']'; sbGraficoParam03.Enabled := false; end; //True
          4 : begin LDescripcionParam04.Caption := Descripcion; LValorParam04.Caption:=ResultCalcStr; LUnidadParam04.Caption:='['+Unidad+']'; sbGraficoParam04.Enabled := false; end; //True
        end;
      end
      else begin
        case i of
          0 : begin LDescripcionParam00.Caption := ''; LValorParam00.Caption:=''; LUnidadParam00.Caption:=''; sbGraficoParam00.Enabled := false; end;
          1 : begin LDescripcionParam01.Caption := ''; LValorParam01.Caption:=''; LUnidadParam01.Caption:=''; sbGraficoParam01.Enabled := false; end;
          2 : begin LDescripcionParam02.Caption := ''; LValorParam02.Caption:=''; LUnidadParam02.Caption:=''; sbGraficoParam02.Enabled := false; end;
          3 : begin LDescripcionParam03.Caption := ''; LValorParam03.Caption:=''; LUnidadParam03.Caption:=''; sbGraficoParam03.Enabled := false; end;
          4 : begin LDescripcionParam04.Caption := ''; LValorParam04.Caption:=''; LUnidadParam04.Caption:=''; sbGraficoParam04.Enabled := false; end;          
        end;
      end;
    end;
  end;

  // Realizo la tareas Predetermindas
  // AutoDescargarDatos
  if Mercury.DescargarDatos then begin
    mDescargarDatosClick(nil);          // Llamo al procedure que tengo para descargar datos.
    Mercury.DescargarDatos := false;    // Borro el Flag.
  end;

  // AutoConfigurar 
  if (Mercury.Configurar and (not Equipo.ThreadComm.DescargarDatos)) then begin
    tsConfiguracionShow(nil);          // Cargo los datos para trasmitir al equipo
    sbConfigurarClick(nil);            // Transmito al equipo los nuevos datos
    Mercury.Configurar := false;
  end;

  // SalirDescarga
  if (Mercury.Salir and (not Equipo.ThreadComm.DescargarDatos)
  and (not Equipo.ThreadComm.ConfigEquipo)) then begin
    Mercury.Salir       := false;      // Me aseguro que no entre mas.
    TimerCierre.Enabled := true;       // Despues de 50ms se cierra la aplicaci�n.
  end;

  // Monitoreo en Linea
  if Mercury.Grabando and (not Mercury.Salir) then MonitoreoEnLinea;


  ///////////////////////////////////////////////////////
  // Actualizo los Graficos de los canales en tiempo real
{  if GraficosOpen >0 then begin
    FGraficoSensor.FechaActual                   := now;
    FGraficoSensor.TimerActualizarSeries.Enabled := true;
  end;}
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.LimpiarMonitor;
begin
  // Desabilito los botones
  tbDescargar.Enabled              := false;
//  tbGrabar.Enabled               := false;
  mDescargarDatos.Enabled          := false;
  mConfiguracionDeInternet.Enabled := false;

  // Limpio la Info del Equipo en pantalla
  LNombreEquipo.Caption  := '';
  LHoraEquipo.Caption    := '';
  LNbytesEquipo.Caption  := '';
  Gauge.Position         := 0;
  LIniMuesEquipo.Caption := '';

  // Limpio la info de los canales
  LDescripcion00.Caption := ''; LValor00.Caption := ''; LUnidad00.Caption := ''; sbGrafico00.Enabled := false; sbComentario00.Enabled := false;
  LDescripcion01.Caption := ''; LValor01.Caption := ''; LUnidad01.Caption := ''; sbGrafico01.Enabled := false; sbComentario01.Enabled := false;
  LDescripcion02.Caption := ''; LValor02.Caption := ''; LUnidad02.Caption := ''; sbGrafico02.Enabled := false; sbComentario02.Enabled := false;
  LDescripcion03.Caption := ''; LValor03.Caption := ''; LUnidad03.Caption := ''; sbGrafico03.Enabled := false; sbComentario03.Enabled := false;
  LDescripcion04.Caption := ''; LValor04.Caption := ''; LUnidad04.Caption := ''; sbGrafico04.Enabled := false; sbComentario04.Enabled := false;
  LDescripcion05.Caption := ''; LValor05.Caption := ''; LUnidad05.Caption := ''; sbGrafico05.Enabled := false; sbComentario05.Enabled := false;
  LDescripcion06.Caption := ''; LValor06.Caption := ''; LUnidad06.Caption := ''; sbGrafico06.Enabled := false; sbComentario06.Enabled := false;
  LDescripcion07.Caption := ''; LValor07.Caption := ''; LUnidad07.Caption := ''; sbGrafico07.Enabled := false; sbComentario07.Enabled := false;
  LDescripcion08.Caption := ''; LValor08.Caption := ''; LUnidad08.Caption := ''; sbGrafico08.Enabled := false; sbComentario08.Enabled := false;

  // Inicialización de canales visuales adicionales (09-15) - Solo visuales, sin lógica
  LDescripcion09.Caption := 'Canal 09 (Visual)'; LValor09.Caption := '---'; LUnidad09.Caption := '[---]'; sbGrafico09.Enabled := false; sbComentario09.Enabled := false;
  LDescripcion10.Caption := 'Canal 10 (Visual)'; LValor10.Caption := '---'; LUnidad10.Caption := '[---]'; sbGrafico10.Enabled := false; sbComentario10.Enabled := false;
  LDescripcion11.Caption := 'Canal 11 (Visual)'; LValor11.Caption := '---'; LUnidad11.Caption := '[---]'; sbGrafico11.Enabled := false; sbComentario11.Enabled := false;
  LDescripcion12.Caption := 'Canal 12 (Visual)'; LValor12.Caption := '---'; LUnidad12.Caption := '[---]'; sbGrafico12.Enabled := false; sbComentario12.Enabled := false;
  LDescripcion13.Caption := 'Canal 13 (Visual)'; LValor13.Caption := '---'; LUnidad13.Caption := '[---]'; sbGrafico13.Enabled := false; sbComentario13.Enabled := false;
  LDescripcion14.Caption := 'Canal 14 (Visual)'; LValor14.Caption := '---'; LUnidad14.Caption := '[---]'; sbGrafico14.Enabled := false; sbComentario14.Enabled := false;
  LDescripcion15.Caption := 'Canal 15 (Visual)'; LValor15.Caption := '---'; LUnidad15.Caption := '[---]'; sbGrafico15.Enabled := false; sbComentario15.Enabled := false;

  // Limpio la info de los valores calculados
  LDescripcionParam00.Caption := ''; LValorParam00.Caption := ''; LUnidadParam00.Caption := ''; sbGraficoParam00.Enabled := false;
  LDescripcionParam01.Caption := ''; LValorParam01.Caption := ''; LUnidadParam01.Caption := ''; sbGraficoParam01.Enabled := false;
  LDescripcionParam02.Caption := ''; LValorParam02.Caption := ''; LUnidadParam02.Caption := ''; sbGraficoParam02.Enabled := false;
  LDescripcionParam03.Caption := ''; LValorParam03.Caption := ''; LUnidadParam03.Caption := ''; sbGraficoParam03.Enabled := false;
  LDescripcionParam04.Caption := ''; LValorParam04.Caption := ''; LUnidadParam04.Caption := ''; sbGraficoParam04.Enabled := false;  

  // Limpio el equipo
  Equipo.Limpiar;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.InstanciarComponentesFaltantes;
var
  DeltaY, TopBase: Integer;
begin
  // Chequeo si faltan los componentes visuales (indicador de que no estan en el LFM)
  if LConfig09 = nil then begin
     // Calculo el espaciado basado en los canales anteriores (07 y 08)
     // Asumo 24 pixels si no puedo calcular, pero trataré de usar LConfig00 y 01
     DeltaY := 24;
     if (LConfig01 <> nil) and (LConfig00 <> nil) then DeltaY := LConfig01.Top - LConfig00.Top;
     
     // --- CONFIGURACION (LConfigXX y LDescConfigXX) ---
     // Uso LConfig07 como base si existe, sino LConfig00 (ajustando top)
     if LConfig08 <> nil then TopBase := LConfig08.Top else TopBase := 216; // Fallback
     
     // Canal 09
     LConfig09 := TLabel.Create(Self); LConfig09.Parent := LConfig00.Parent; 
     LConfig09.Left := LConfig00.Left; LConfig09.Top := TopBase + DeltaY;
     LConfig09.AutoSize := False; LConfig09.Width := LConfig00.Width; LConfig09.Height := LConfig00.Height;
     LConfig09.Alignment := taCenter; LConfig09.Font := LConfig00.Font;
     
     LDescConfig09 := TLabel.Create(Self); LDescConfig09.Parent := LDescConfig00.Parent;
     LDescConfig09.Left := LDescConfig00.Left; LDescConfig09.Top := TopBase + DeltaY;
     LDescConfig09.AutoSize := False; LDescConfig09.Width := LDescConfig00.Width; LDescConfig09.Height := LDescConfig00.Height;
     LDescConfig09.Alignment := taCenter; LDescConfig09.Font := LDescConfig00.Font;
     LDescConfig09.Color := LDescConfig00.Color; LDescConfig09.Transparent := False;

     // Canal 10
     LConfig10 := TLabel.Create(Self); LConfig10.Parent := LConfig00.Parent;
     LConfig10.Left := LConfig00.Left; LConfig10.Top := TopBase + DeltaY * 2;
     LConfig10.AutoSize := False; LConfig10.Width := LConfig00.Width; LConfig10.Height := LConfig00.Height;
     LConfig10.Alignment := taCenter; LConfig10.Font := LConfig00.Font;

     LDescConfig10 := TLabel.Create(Self); LDescConfig10.Parent := LDescConfig00.Parent;
     LDescConfig10.Left := LDescConfig00.Left; LDescConfig10.Top := TopBase + DeltaY * 2;
     LDescConfig10.AutoSize := False; LDescConfig10.Width := LDescConfig00.Width; LDescConfig10.Height := LDescConfig00.Height;
     LDescConfig10.Alignment := taCenter; LDescConfig10.Font := LDescConfig00.Font;
     LDescConfig10.Color := LDescConfig00.Color; LDescConfig10.Transparent := False;

     // Canal 11
     LConfig11 := TLabel.Create(Self); LConfig11.Parent := LConfig00.Parent;
     LConfig11.Left := LConfig00.Left; LConfig11.Top := TopBase + DeltaY * 3;
     LConfig11.AutoSize := False; LConfig11.Width := LConfig00.Width; LConfig11.Height := LConfig00.Height;
     LConfig11.Alignment := taCenter; LConfig11.Font := LConfig00.Font;

     LDescConfig11 := TLabel.Create(Self); LDescConfig11.Parent := LDescConfig00.Parent;
     LDescConfig11.Left := LDescConfig00.Left; LDescConfig11.Top := TopBase + DeltaY * 3;
     LDescConfig11.AutoSize := False; LDescConfig11.Width := LDescConfig00.Width; LDescConfig11.Height := LDescConfig00.Height;
     LDescConfig11.Alignment := taCenter; LDescConfig11.Font := LDescConfig00.Font;
     LDescConfig11.Color := LDescConfig00.Color; LDescConfig11.Transparent := False;

     // Canal 12
     LConfig12 := TLabel.Create(Self); LConfig12.Parent := LConfig00.Parent;
     LConfig12.Left := LConfig00.Left; LConfig12.Top := TopBase + DeltaY * 4;
     LConfig12.AutoSize := False; LConfig12.Width := LConfig00.Width; LConfig12.Height := LConfig00.Height;
     LConfig12.Alignment := taCenter; LConfig12.Font := LConfig00.Font;

     LDescConfig12 := TLabel.Create(Self); LDescConfig12.Parent := LDescConfig00.Parent;
     LDescConfig12.Left := LDescConfig00.Left; LDescConfig12.Top := TopBase + DeltaY * 4;
     LDescConfig12.AutoSize := False; LDescConfig12.Width := LDescConfig00.Width; LDescConfig12.Height := LDescConfig00.Height;
     LDescConfig12.Alignment := taCenter; LDescConfig12.Font := LDescConfig00.Font;
     LDescConfig12.Color := LDescConfig00.Color; LDescConfig12.Transparent := False;

     // Canal 13
     LConfig13 := TLabel.Create(Self); LConfig13.Parent := LConfig00.Parent;
     LConfig13.Left := LConfig00.Left; LConfig13.Top := TopBase + DeltaY * 5;
     LConfig13.AutoSize := False; LConfig13.Width := LConfig00.Width; LConfig13.Height := LConfig00.Height;
     LConfig13.Alignment := taCenter; LConfig13.Font := LConfig00.Font;

     LDescConfig13 := TLabel.Create(Self); LDescConfig13.Parent := LDescConfig00.Parent;
     LDescConfig13.Left := LDescConfig00.Left; LDescConfig13.Top := TopBase + DeltaY * 5;
     LDescConfig13.AutoSize := False; LDescConfig13.Width := LDescConfig00.Width; LDescConfig13.Height := LDescConfig00.Height;
     LDescConfig13.Alignment := taCenter; LDescConfig13.Font := LDescConfig00.Font;
     LDescConfig13.Color := LDescConfig00.Color; LDescConfig13.Transparent := False;

     // Canal 14
     LConfig14 := TLabel.Create(Self); LConfig14.Parent := LConfig00.Parent;
     LConfig14.Left := LConfig00.Left; LConfig14.Top := TopBase + DeltaY * 6;
     LConfig14.AutoSize := False; LConfig14.Width := LConfig00.Width; LConfig14.Height := LConfig00.Height;
     LConfig14.Alignment := taCenter; LConfig14.Font := LConfig00.Font;

     LDescConfig14 := TLabel.Create(Self); LDescConfig14.Parent := LDescConfig00.Parent;
     LDescConfig14.Left := LDescConfig00.Left; LDescConfig14.Top := TopBase + DeltaY * 6;
     LDescConfig14.AutoSize := False; LDescConfig14.Width := LDescConfig00.Width; LDescConfig14.Height := LDescConfig00.Height;
     LDescConfig14.Alignment := taCenter; LDescConfig14.Font := LDescConfig00.Font;
     LDescConfig14.Color := LDescConfig00.Color; LDescConfig14.Transparent := False;

     // Canal 15
     LConfig15 := TLabel.Create(Self); LConfig15.Parent := LConfig00.Parent;
     LConfig15.Left := LConfig00.Left; LConfig15.Top := TopBase + DeltaY * 7;
     LConfig15.AutoSize := False; LConfig15.Width := LConfig00.Width; LConfig15.Height := LConfig00.Height;
     LConfig15.Alignment := taCenter; LConfig15.Font := LConfig00.Font;

     LDescConfig15 := TLabel.Create(Self); LDescConfig15.Parent := LDescConfig00.Parent;
     LDescConfig15.Left := LDescConfig00.Left; LDescConfig15.Top := TopBase + DeltaY * 7;
     LDescConfig15.AutoSize := False; LDescConfig15.Width := LDescConfig00.Width; LDescConfig15.Height := LDescConfig00.Height;
     LDescConfig15.Alignment := taCenter; LDescConfig15.Font := LDescConfig00.Font;
     LDescConfig15.Color := LDescConfig00.Color; LDescConfig15.Transparent := False;


     // --- VISUALIZACION (LValorXX, LUnidadXX, LDescripcionXX, sbGraficoXX, sbComentarioXX) ---
     // Uso LValor08 como base si existe.
     if LValor08 <> nil then TopBase := LValor08.Top else TopBase := 214;

     // Canal 09 (Visual)
     LValor09 := TLabel.Create(Self); LValor09.Parent := LValor00.Parent;
     LValor09.Left := LValor00.Left; LValor09.Top := TopBase + DeltaY;
     LValor09.AutoSize := False; LValor09.Width := LValor00.Width; LValor09.Height := LValor00.Height; 
     LValor09.Alignment := taCenter; LValor09.Font := LValor00.Font; LValor09.Color := LValor00.Color; LValor09.Transparent := False;
     
     LUnidad09 := TLabel.Create(Self); LUnidad09.Parent := LUnidad00.Parent;
     LUnidad09.Left := LUnidad00.Left; LUnidad09.Top := TopBase + DeltaY;
     LUnidad09.AutoSize := False; LUnidad09.Width := LUnidad00.Width; LUnidad09.Height := LUnidad00.Height;
     LUnidad09.Alignment := taCenter; LUnidad09.Font := LUnidad00.Font;
     
     LDescripcion09 := TLabel.Create(Self); LDescripcion09.Parent := LDescripcion00.Parent;
     LDescripcion09.Left := LDescripcion00.Left; LDescripcion09.Top := TopBase + DeltaY;
     LDescripcion09.AutoSize := False; LDescripcion09.Width := LDescripcion00.Width; LDescripcion09.Height := LDescripcion00.Height;
     LDescripcion09.Alignment := taCenter; LDescripcion09.Font := LDescripcion00.Font;

     sbGrafico09 := TSpeedButton.Create(Self); sbGrafico09.Parent := sbGrafico00.Parent;
     sbGrafico09.Left := sbGrafico00.Left; sbGrafico09.Top := TopBase + DeltaY;
     sbGrafico09.Width := sbGrafico00.Width; sbGrafico09.Height := sbGrafico00.Height;
     sbGrafico09.NumGlyphs := sbGrafico00.NumGlyphs; sbGrafico09.Flat := sbGrafico00.Flat;
     
     sbComentario09 := TSpeedButton.Create(Self); sbComentario09.Parent := sbComentario00.Parent;
     sbComentario09.Left := sbComentario00.Left; sbComentario09.Top := TopBase + DeltaY;
     sbComentario09.Width := sbComentario00.Width; sbComentario09.Height := sbComentario00.Height;
     sbComentario09.NumGlyphs := sbComentario00.NumGlyphs; sbComentario09.Flat := sbComentario00.Flat;

     // Canal 10
     LValor10 := TLabel.Create(Self); LValor10.Parent := LValor00.Parent;
     LValor10.Left := LValor00.Left; LValor10.Top := TopBase + DeltaY*2;
     LValor10.AutoSize := False; LValor10.Width := LValor00.Width; LValor10.Height := LValor00.Height;
     LValor10.Alignment := taCenter; LValor10.Font := LValor00.Font; LValor10.Color := LValor00.Color; LValor10.Transparent := False;

     LUnidad10 := TLabel.Create(Self); LUnidad10.Parent := LUnidad00.Parent;
     LUnidad10.Left := LUnidad00.Left; LUnidad10.Top := TopBase + DeltaY*2;
     LUnidad10.AutoSize := False; LUnidad10.Width := LUnidad00.Width; LUnidad10.Height := LUnidad00.Height;
     LUnidad10.Alignment := taCenter; LUnidad10.Font := LUnidad00.Font;

     LDescripcion10 := TLabel.Create(Self); LDescripcion10.Parent := LDescripcion00.Parent;
     LDescripcion10.Left := LDescripcion00.Left; LDescripcion10.Top := TopBase + DeltaY*2;
     LDescripcion10.AutoSize := False; LDescripcion10.Width := LDescripcion00.Width; LDescripcion10.Height := LDescripcion00.Height;
     LDescripcion10.Alignment := taCenter; LDescripcion10.Font := LDescripcion00.Font;

     sbGrafico10 := TSpeedButton.Create(Self); sbGrafico10.Parent := sbGrafico00.Parent;
     sbGrafico10.Left := sbGrafico00.Left; sbGrafico10.Top := TopBase + DeltaY*2;
     sbGrafico10.Width := sbGrafico00.Width; sbGrafico10.Height := sbGrafico00.Height;
     sbGrafico10.Flat := sbGrafico00.Flat; // Simplifico propiedades

     sbComentario10 := TSpeedButton.Create(Self); sbComentario10.Parent := sbComentario00.Parent;
     sbComentario10.Left := sbComentario00.Left; sbComentario10.Top := TopBase + DeltaY*2;
     sbComentario10.Width := sbComentario00.Width; sbComentario10.Height := sbComentario00.Height;
     sbComentario10.Flat := sbComentario00.Flat;

     // Canal 11
     LValor11 := TLabel.Create(Self); LValor11.Parent := LValor00.Parent;
     LValor11.Left := LValor00.Left; LValor11.Top := TopBase + DeltaY*3;
     LValor11.AutoSize := False; LValor11.Width := LValor00.Width; LValor11.Height := LValor00.Height;
     LValor11.Alignment := taCenter; LValor11.Font := LValor00.Font; LValor11.Color := LValor00.Color; LValor11.Transparent := False;

     LUnidad11 := TLabel.Create(Self); LUnidad11.Parent := LUnidad00.Parent;
     LUnidad11.Left := LUnidad00.Left; LUnidad11.Top := TopBase + DeltaY*3;
     LUnidad11.AutoSize := False; LUnidad11.Width := LUnidad00.Width; LUnidad11.Height := LUnidad00.Height;
     LUnidad11.Alignment := taCenter; LUnidad11.Font := LUnidad00.Font;

     LDescripcion11 := TLabel.Create(Self); LDescripcion11.Parent := LDescripcion00.Parent;
     LDescripcion11.Left := LDescripcion00.Left; LDescripcion11.Top := TopBase + DeltaY*3;
     LDescripcion11.AutoSize := False; LDescripcion11.Width := LDescripcion00.Width; LDescripcion11.Height := LDescripcion00.Height;
     LDescripcion11.Alignment := taCenter; LDescripcion11.Font := LDescripcion00.Font;
     
     sbGrafico11 := TSpeedButton.Create(Self); sbGrafico11.Parent := sbGrafico00.Parent; 
     sbGrafico11.Left := sbGrafico00.Left; sbGrafico11.Top := TopBase + DeltaY*3;
     sbGrafico11.Width := sbGrafico00.Width; sbGrafico11.Height := sbGrafico00.Height; sbGrafico11.Flat := sbGrafico00.Flat;

     sbComentario11 := TSpeedButton.Create(Self); sbComentario11.Parent := sbComentario00.Parent;
     sbComentario11.Left := sbComentario00.Left; sbComentario11.Top := TopBase + DeltaY*3;
     sbComentario11.Width := sbComentario00.Width; sbComentario11.Height := sbComentario00.Height; sbComentario11.Flat := sbComentario00.Flat;

     // Canal 12
     LValor12 := TLabel.Create(Self); LValor12.Parent := LValor00.Parent;
     LValor12.Left := LValor00.Left; LValor12.Top := TopBase + DeltaY*4;
     LValor12.AutoSize := False; LValor12.Width := LValor00.Width; LValor12.Height := LValor00.Height;
     LValor12.Alignment := taCenter; LValor12.Font := LValor00.Font; LValor12.Color := LValor00.Color; LValor12.Transparent := False;

     LUnidad12 := TLabel.Create(Self); LUnidad12.Parent := LUnidad00.Parent;
     LUnidad12.Left := LUnidad00.Left; LUnidad12.Top := TopBase + DeltaY*4;
     LUnidad12.AutoSize := False; LUnidad12.Width := LUnidad00.Width; LUnidad12.Height := LUnidad00.Height;
     LUnidad12.Alignment := taCenter; LUnidad12.Font := LUnidad00.Font;

     LDescripcion12 := TLabel.Create(Self); LDescripcion12.Parent := LDescripcion00.Parent;
     LDescripcion12.Left := LDescripcion00.Left; LDescripcion12.Top := TopBase + DeltaY*4;
     LDescripcion12.AutoSize := False; LDescripcion12.Width := LDescripcion00.Width; LDescripcion12.Height := LDescripcion00.Height;
     LDescripcion12.Alignment := taCenter; LDescripcion12.Font := LDescripcion00.Font;

     sbGrafico12 := TSpeedButton.Create(Self); sbGrafico12.Parent := sbGrafico00.Parent;
     sbGrafico12.Left := sbGrafico00.Left; sbGrafico12.Top := TopBase + DeltaY*4;
     sbGrafico12.Width := sbGrafico00.Width; sbGrafico12.Height := sbGrafico00.Height; sbGrafico12.Flat := sbGrafico00.Flat;

     sbComentario12 := TSpeedButton.Create(Self); sbComentario12.Parent := sbComentario00.Parent;
     sbComentario12.Left := sbComentario00.Left; sbComentario12.Top := TopBase + DeltaY*4;
     sbComentario12.Width := sbComentario00.Width; sbComentario12.Height := sbComentario00.Height; sbComentario12.Flat := sbComentario00.Flat;

     // Canal 13
     LValor13 := TLabel.Create(Self); LValor13.Parent := LValor00.Parent;
     LValor13.Left := LValor00.Left; LValor13.Top := TopBase + DeltaY*5;
     LValor13.AutoSize := False; LValor13.Width := LValor00.Width; LValor13.Height := LValor00.Height;
     LValor13.Alignment := taCenter; LValor13.Font := LValor00.Font; LValor13.Color := LValor00.Color; LValor13.Transparent := False;

     LUnidad13 := TLabel.Create(Self); LUnidad13.Parent := LUnidad00.Parent;
     LUnidad13.Left := LUnidad00.Left; LUnidad13.Top := TopBase + DeltaY*5;
     LUnidad13.AutoSize := False; LUnidad13.Width := LUnidad00.Width; LUnidad13.Height := LUnidad00.Height;
     LUnidad13.Alignment := taCenter; LUnidad13.Font := LUnidad00.Font;

     LDescripcion13 := TLabel.Create(Self); LDescripcion13.Parent := LDescripcion00.Parent;
     LDescripcion13.Left := LDescripcion00.Left; LDescripcion13.Top := TopBase + DeltaY*5;
     LDescripcion13.AutoSize := False; LDescripcion13.Width := LDescripcion00.Width; LDescripcion13.Height := LDescripcion00.Height;
     LDescripcion13.Alignment := taCenter; LDescripcion13.Font := LDescripcion00.Font;

     sbGrafico13 := TSpeedButton.Create(Self); sbGrafico13.Parent := sbGrafico00.Parent;
     sbGrafico13.Left := sbGrafico00.Left; sbGrafico13.Top := TopBase + DeltaY*5;
     sbGrafico13.Width := sbGrafico00.Width; sbGrafico13.Height := sbGrafico00.Height; sbGrafico13.Flat := sbGrafico00.Flat;

     sbComentario13 := TSpeedButton.Create(Self); sbComentario13.Parent := sbComentario00.Parent;
     sbComentario13.Left := sbComentario00.Left; sbComentario13.Top := TopBase + DeltaY*5;
     sbComentario13.Width := sbComentario00.Width; sbComentario13.Height := sbComentario00.Height; sbComentario13.Flat := sbComentario00.Flat;

     // Canal 14
     LValor14 := TLabel.Create(Self); LValor14.Parent := LValor00.Parent;
     LValor14.Left := LValor00.Left; LValor14.Top := TopBase + DeltaY*6;
     LValor14.AutoSize := False; LValor14.Width := LValor00.Width; LValor14.Height := LValor00.Height;
     LValor14.Alignment := taCenter; LValor14.Font := LValor00.Font; LValor14.Color := LValor00.Color; LValor14.Transparent := False;

     LUnidad14 := TLabel.Create(Self); LUnidad14.Parent := LUnidad00.Parent;
     LUnidad14.Left := LUnidad00.Left; LUnidad14.Top := TopBase + DeltaY*6;
     LUnidad14.AutoSize := False; LUnidad14.Width := LUnidad00.Width; LUnidad14.Height := LUnidad00.Height;
     LUnidad14.Alignment := taCenter; LUnidad14.Font := LUnidad00.Font;

     LDescripcion14 := TLabel.Create(Self); LDescripcion14.Parent := LDescripcion00.Parent;
     LDescripcion14.Left := LDescripcion00.Left; LDescripcion14.Top := TopBase + DeltaY*6;
     LDescripcion14.AutoSize := False; LDescripcion14.Width := LDescripcion00.Width; LDescripcion14.Height := LDescripcion00.Height;
     LDescripcion14.Alignment := taCenter; LDescripcion14.Font := LDescripcion00.Font;

     sbGrafico14 := TSpeedButton.Create(Self); sbGrafico14.Parent := sbGrafico00.Parent;
     sbGrafico14.Left := sbGrafico00.Left; sbGrafico14.Top := TopBase + DeltaY*6;
     sbGrafico14.Width := sbGrafico00.Width; sbGrafico14.Height := sbGrafico00.Height; sbGrafico14.Flat := sbGrafico00.Flat;

     sbComentario14 := TSpeedButton.Create(Self); sbComentario14.Parent := sbComentario00.Parent;
     sbComentario14.Left := sbComentario00.Left; sbComentario14.Top := TopBase + DeltaY*6;
     sbComentario14.Width := sbComentario00.Width; sbComentario14.Height := sbComentario00.Height; sbComentario14.Flat := sbComentario00.Flat;

     // Canal 15
     LValor15 := TLabel.Create(Self); LValor15.Parent := LValor00.Parent;
     LValor15.Left := LValor00.Left; LValor15.Top := TopBase + DeltaY*7;
     LValor15.AutoSize := False; LValor15.Width := LValor00.Width; LValor15.Height := LValor00.Height;
     LValor15.Alignment := taCenter; LValor15.Font := LValor00.Font; LValor15.Color := LValor00.Color; LValor15.Transparent := False;

     LUnidad15 := TLabel.Create(Self); LUnidad15.Parent := LUnidad00.Parent;
     LUnidad15.Left := LUnidad00.Left; LUnidad15.Top := TopBase + DeltaY*7;
     LUnidad15.AutoSize := False; LUnidad15.Width := LUnidad00.Width; LUnidad15.Height := LUnidad00.Height;
     LUnidad15.Alignment := taCenter; LUnidad15.Font := LUnidad00.Font;

     LDescripcion15 := TLabel.Create(Self); LDescripcion15.Parent := LDescripcion00.Parent;
     LDescripcion15.Left := LDescripcion00.Left; LDescripcion15.Top := TopBase + DeltaY*7;
     LDescripcion15.AutoSize := False; LDescripcion15.Width := LDescripcion00.Width; LDescripcion15.Height := LDescripcion00.Height;
     LDescripcion15.Alignment := taCenter; LDescripcion15.Font := LDescripcion00.Font;
     
     sbGrafico15 := TSpeedButton.Create(Self); sbGrafico15.Parent := sbGrafico00.Parent;
     sbGrafico15.Left := sbGrafico00.Left; sbGrafico15.Top := TopBase + DeltaY*7;
     sbGrafico15.Width := sbGrafico00.Width; sbGrafico15.Height := sbGrafico00.Height; sbGrafico15.Flat := sbGrafico00.Flat;
     
     sbComentario15 := TSpeedButton.Create(Self); sbComentario15.Parent := sbComentario00.Parent;
     sbComentario15.Left := sbComentario00.Left; sbComentario15.Top := TopBase + DeltaY*7;
     sbComentario15.Width := sbComentario00.Width; sbComentario15.Height := sbComentario00.Height; sbComentario15.Flat := sbComentario00.Flat;

     // Force hide all new components by default
     LConfig09.Visible := False; LDescConfig09.Visible := False;
     LConfig10.Visible := False; LDescConfig10.Visible := False;
     LConfig11.Visible := False; LDescConfig11.Visible := False;
     LConfig12.Visible := False; LDescConfig12.Visible := False;
     LConfig13.Visible := False; LDescConfig13.Visible := False;
     LConfig14.Visible := False; LDescConfig14.Visible := False;
     LConfig15.Visible := False; LDescConfig15.Visible := False;
     
     LValor09.Visible := False; LUnidad09.Visible := False; LDescripcion09.Visible := False; sbGrafico09.Visible := False; sbComentario09.Visible := False;
     LValor10.Visible := False; LUnidad10.Visible := False; LDescripcion10.Visible := False; sbGrafico10.Visible := False; sbComentario10.Visible := False;
     LValor11.Visible := False; LUnidad11.Visible := False; LDescripcion11.Visible := False; sbGrafico11.Visible := False; sbComentario11.Visible := False;
     LValor12.Visible := False; LUnidad12.Visible := False; LDescripcion12.Visible := False; sbGrafico12.Visible := False; sbComentario12.Visible := False;
     LValor13.Visible := False; LUnidad13.Visible := False; LDescripcion13.Visible := False; sbGrafico13.Visible := False; sbComentario13.Visible := False;
     LValor14.Visible := False; LUnidad14.Visible := False; LDescripcion14.Visible := False; sbGrafico14.Visible := False; sbComentario14.Visible := False;
     LValor15.Visible := False; LUnidad15.Visible := False; LDescripcion15.Visible := False; sbGrafico15.Visible := False; sbComentario15.Visible := False;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.ActualizarVisibilidadCanales(Es16Canales: Boolean);
begin
  // Canales 09 a 15 (indices de configuracion y valores visuales) - Canal 08 es Digital 1 y siempre visible
  
  // Configuracion (LConfig, LDescConfig)
  LConfig09.Visible := Es16Canales; LDescConfig09.Visible := Es16Canales;
  LConfig10.Visible := Es16Canales; LDescConfig10.Visible := Es16Canales;
  LConfig11.Visible := Es16Canales; LDescConfig11.Visible := Es16Canales;
  LConfig12.Visible := Es16Canales; LDescConfig12.Visible := Es16Canales;
  LConfig13.Visible := Es16Canales; LDescConfig13.Visible := Es16Canales;
  LConfig14.Visible := Es16Canales; LDescConfig14.Visible := Es16Canales;
  LConfig15.Visible := Es16Canales; LDescConfig15.Visible := Es16Canales;

  // Visualizacion (Valores, Unidades, Descripciones, Graficos, Comentarios)
  LValor09.Visible := Es16Canales; LUnidad09.Visible := Es16Canales; LDescripcion09.Visible := Es16Canales;
  sbGrafico09.Visible := Es16Canales; sbComentario09.Visible := Es16Canales;

  LValor10.Visible := Es16Canales; LUnidad10.Visible := Es16Canales; LDescripcion10.Visible := Es16Canales;
  sbGrafico10.Visible := Es16Canales; sbComentario10.Visible := Es16Canales;

  LValor11.Visible := Es16Canales; LUnidad11.Visible := Es16Canales; LDescripcion11.Visible := Es16Canales;
  sbGrafico11.Visible := Es16Canales; sbComentario11.Visible := Es16Canales;

  LValor12.Visible := Es16Canales; LUnidad12.Visible := Es16Canales; LDescripcion12.Visible := Es16Canales;
  sbGrafico12.Visible := Es16Canales; sbComentario12.Visible := Es16Canales;

  LValor13.Visible := Es16Canales; LUnidad13.Visible := Es16Canales; LDescripcion13.Visible := Es16Canales;
  sbGrafico13.Visible := Es16Canales; sbComentario13.Visible := Es16Canales;

  LValor14.Visible := Es16Canales; LUnidad14.Visible := Es16Canales; LDescripcion14.Visible := Es16Canales;
  sbGrafico14.Visible := Es16Canales; sbComentario14.Visible := Es16Canales;

  LValor15.Visible := Es16Canales; LUnidad15.Visible := Es16Canales; LDescripcion15.Visible := Es16Canales;
  sbGrafico15.Visible := Es16Canales; sbComentario15.Visible := Es16Canales;
end;

////////////////////////////////////////////////////////////////////////////////
function TFprincipal.CentrarTexto(texto:string; Ancho:integer):string;
var
  k,N     : integer;
  auxText : string;

begin
  auxText := Texto;
  N := ((Ancho div 8)-length(texto)) div 2;
  for k:=1 to N do auxText := ' ' + auxText;

  if N>0 then result := auxText
  else result := texto;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.tsConfiguracionShow(Sender: TObject);
var
  i : integer;

begin
  // Oculto el ComboBox
  cbSensores.Visible   := false;

  // Cargo el Nombre del Equipo
  eNombre.Text          := Equipo.Nombre;

  // Averiguo el periodo de muestro para el ComboBox
  cbIntervalo.ItemIndex := 0;
  for i:=0 to length(TablaT)-1 do
    if (Equipo.Tmuestreo = TablaT[i]) then cbIntervalo.ItemIndex := i;

  // Cargo la info de los canales
  // Canal 0
  LConfig00.Caption              := ListaSensores[Equipo.Canales[0].PosLista].Nombre;
  LDescConfig00.Caption          := ListaSensores[Equipo.Canales[0].PosLista].Descripcion;
  Equipo.ThreadComm.ConfigCHs[0] := Equipo.Canales[0].Config;
  // Canal 1
  LConfig01.Caption              := ListaSensores[Equipo.Canales[1].PosLista].Nombre;
  LDescConfig01.Caption          := ListaSensores[Equipo.Canales[1].PosLista].Descripcion;
  Equipo.ThreadComm.ConfigCHs[1] := Equipo.Canales[1].Config;
  // Canal 2
  LConfig02.Caption              := ListaSensores[Equipo.Canales[2].PosLista].Nombre;
  LDescConfig02.Caption          := ListaSensores[Equipo.Canales[2].PosLista].Descripcion;
  Equipo.ThreadComm.ConfigCHs[2] := Equipo.Canales[2].Config;
  // Canal 3
  LConfig03.Caption              := ListaSensores[Equipo.Canales[3].PosLista].Nombre;
  LDescConfig03.Caption          := ListaSensores[Equipo.Canales[3].PosLista].Descripcion;
  Equipo.ThreadComm.ConfigCHs[3] := Equipo.Canales[3].Config;
  // Canal 4
  LConfig04.Caption              := ListaSensores[Equipo.Canales[4].PosLista].Nombre;
  LDescConfig04.Caption          := ListaSensores[Equipo.Canales[4].PosLista].Descripcion;
  Equipo.ThreadComm.ConfigCHs[4] := Equipo.Canales[4].Config;
  // Canal 5
  LConfig05.Caption              := ListaSensores[Equipo.Canales[5].PosLista].Nombre;
  LDescConfig05.Caption          := ListaSensores[Equipo.Canales[5].PosLista].Descripcion;
  Equipo.ThreadComm.ConfigCHs[5] := Equipo.Canales[5].Config;
  // Canal 6
  LConfig06.Caption              := ListaSensores[Equipo.Canales[6].PosLista].Nombre;
  LDescConfig06.Caption          := ListaSensores[Equipo.Canales[6].PosLista].Descripcion;
  Equipo.ThreadComm.ConfigCHs[6] := Equipo.Canales[6].Config;
  // Canal 7
  LConfig07.Caption              := ListaSensores[Equipo.Canales[7].PosLista].Nombre;
  LDescConfig07.Caption          := ListaSensores[Equipo.Canales[7].PosLista].Descripcion;
  Equipo.ThreadComm.ConfigCHs[7] := Equipo.Canales[7].Config;

  // Canales Digitales (Tengo 2 pero lo Uso como uno)
  // Canal 8
  if not Equipo.UsarCH9 then begin
    LConfig08.Caption              := ListaSensores[Equipo.Canales[8].PosLista].Nombre;
    LDescConfig08.Caption          := ListaSensores[Equipo.Canales[8].PosLista].Descripcion;
    Equipo.ThreadComm.ConfigCHs[8] := Equipo.Canales[8].Config;
  end
  else begin // Canal 9
    LConfig08.Caption              := ListaSensores[Equipo.Canales[9].PosLista].Nombre;
    LDescConfig08.Caption          := ListaSensores[Equipo.Canales[9].PosLista].Descripcion;
    Equipo.ThreadComm.ConfigCHs[9] := Equipo.Canales[9].Config;
  end;

  // Configuración visual de canales adicionales (09-15) - Solo visuales, sin lógica
  LConfig09.Caption := 'Canal 09 (Visual)';
  LDescConfig09.Caption := 'Canal visual - sin funcionalidad';
  LConfig10.Caption := 'Canal 10 (Visual)';
  LDescConfig10.Caption := 'Canal visual - sin funcionalidad';
  LConfig11.Caption := 'Canal 11 (Visual)';
  LDescConfig11.Caption := 'Canal visual - sin funcionalidad';
  LConfig12.Caption := 'Canal 12 (Visual)';
  LDescConfig12.Caption := 'Canal visual - sin funcionalidad';
  LConfig13.Caption := 'Canal 13 (Visual)';
  LDescConfig13.Caption := 'Canal visual - sin funcionalidad';
  LConfig14.Caption := 'Canal 14 (Visual)';
  LDescConfig14.Caption := 'Canal visual - sin funcionalidad';
  LConfig15.Caption := 'Canal 15 (Visual)';
  LDescConfig15.Caption := 'Canal visual - sin funcionalidad';

  // Desabilito el boton para configurar si el equipo no est� conectado
  if not Equipo.ThreadComm.ONLine then  sbConfigurar.Enabled := false
  else sbConfigurar.Enabled := true;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.LConfigsClick(Sender: TObject);
begin
  NCanal               := (Sender as TLabel).tag;
  cbSensores.Parent    := (Sender as TLabel).Parent; // Fix: Reparent to current container
  cbSensores.Left      := (Sender as TLabel).Left-6;
  cbSensores.Top       := (Sender as TLabel).top-3;
  if not Equipo.UsarCH9 then cbSensores.ItemIndex := Equipo.Canales[NCanal].config
  else cbSensores.ItemIndex := Equipo.Canales[NCanal+1].config;
  cbSensores.Visible   := True;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.cbSensoresCloseUp(Sender: TObject);
var
  i           : byte;
  descripcion : string;

begin
  for i:=0 to length(ListaSensores) do begin
    if (ListaSensores[i].Config=cbSensores.ItemIndex) then begin
      descripcion := ListaSensores[i].Descripcion;
      break;
    end;
  end;

  // Chequeo de integridad - Si este canal soporta este sensor...
  // Para canales Anal�gicos.....
  if (i>1) and (NCanal<8) and (ListaSensores[i].Entrada<>'TENSION')then begin
    // Cartel de Error
    MessageBox(Handle,'El sensor seleccionado corresponde a un canal DIGITAL.',
               PChar(Caption), MB_OK	or MB_ICONERROR );
    cbSensores.Visible := False;
    exit;
  end;
  // Para canales Digitales.....
  if (i>1) and (NCanal>7) and (ListaSensores[i].Entrada<>'PULSO')then begin
    // Cartel de Error
    MessageBox(Handle,'El sensor seleccionado corresponde a un canal ANAL�GICO.',
               PChar(Caption), MB_OK	or MB_ICONERROR );
    cbSensores.Visible := False;
    exit;
  end;

  // Cargo el Nombre y la desc del sensor en la Ventana
  case NCanal of
  0 : begin LConfig00.Caption     := cbSensores.Text;
            LDescConfig00.Caption := descripcion; end;
  1 : begin LConfig01.Caption     := cbSensores.Text;
            LDescConfig01.Caption := descripcion; end;
  2 : begin LConfig02.Caption     := cbSensores.Text;
            LDescConfig02.Caption := descripcion; end;
  3 : begin LConfig03.Caption     := cbSensores.Text;
            LDescConfig03.Caption := descripcion; end;
  4 : begin LConfig04.Caption     := cbSensores.Text;
            LDescConfig04.Caption := descripcion; end;
  5 : begin LConfig05.Caption     := cbSensores.Text;
            LDescConfig05.Caption := descripcion; end;
  6 : begin LConfig06.Caption     := cbSensores.Text;
            LDescConfig06.Caption := descripcion; end;
  7 : begin LConfig07.Caption     := cbSensores.Text;
            LDescConfig07.Caption := descripcion; end;
  // Canales Digitales
  8 : begin LConfig08.Caption     := cbSensores.Text;
            LDescConfig08.Caption := descripcion; end;
  // Canales visuales adicionales (09-15) - No se pueden cambiar
  9,10,11,12,13,14,15 : begin 
    // No hacer nada - mantener el texto visual
    MessageBox(Handle,'Este es un canal solo visual. No se puede configurar.',
               PChar(Caption), MB_OK or MB_ICONINFORMATION);
  end;
  end;

  Equipo.ThreadComm.ConfigCHs[NCanal] := cbSensores.ItemIndex;
  cbSensores.Visible                  := False;
  
  // Chequeo que canal digital debo usar.... CH8 o el CH9
  if (NCanal=8) and (ListaSensores[i].Modo='ACUMULAR') then begin
    Equipo.ThreadComm.ConfigCHs[NCanal]   := 0;
    Equipo.ThreadComm.ConfigCHs[NCanal+1] := cbSensores.ItemIndex;
  end;
  if (NCanal=8) and (ListaSensores[i].Modo<>'ACUMULAR') then begin
    Equipo.ThreadComm.ConfigCHs[NCanal+1]   := 0;
  end;
  //
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.cbSensoresExit(Sender: TObject);
begin
  cbSensores.Visible := False;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.sbConfigurarClick(Sender: TObject);
var
  i         : byte;
  auxNombre : string;
  Qst       : byte;

begin
  // Cartel de advertencia
  if (Sender <> nil) then begin
    Qst := MessageBox(Handle,'�Advertencia, los datos en la memoria se borraran!. '+
                      #13+'�Desea continuar?' , PChar(Caption), MB_YESNO or MB_ICONQUESTION );
    if (Qst=7) then exit; // Presion� "NO"
  end;

  // Cargo el nuevo nombre
  auxNombre := '____';
  for i:=1 to length(eNombre.Text) do if (eNombre.Text[i]<>' ') then auxNombre[i] := eNombre.Text[i];
  Equipo.ThreadComm.NombreEquipo := auxNombre;

  // Cargo el nuevo periodo de muestreo
  Equipo.ThreadComm.T            := TablaT[cbIntervalo.ItemIndex];

  // Cartel de informaci�n para que cambie periodo de conexi�n por internet
  if Equipo.ThreadComm.pTmuestreo^ <> Equipo.ThreadComm.T then begin
    MessageBox(Handle,'Al cambiar el periodo de muestreo se debe re-configurar los par�metros '+
              #13+'de conexi�n por internet, en caso de usarse.' , PChar(Caption), MB_OK	or MB_ICONINFORMATION );
  end;

{  // La configuraci�n de cada canal ya fue cargada cuando se seleccionan el combobox
  // Esto lo hago porque tengo dos canales que en realidad los trabajo como uno.
  Equipo.ThreadComm.ConfigCHs[Equipo.NumCanales-1] := 0;}

  // Borro la Config de Equipo para luego reemplazarla por una Nueva
  Equipo.BorrarEquipo(Mercury.NombreINIEquipos);

  // Indico al Thread que transfiera los cambios al equipo
  ActualizarCHs                  := true;
  Equipo.ThreadComm.ConfigEquipo := true;
  PageControl.ActivePageIndex    := 0;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.CrearListaSensores;
var
  AFiles : AFilesOfDir;
  i,j    : integer;

begin
  ExtractFilesOfDir(Mercury.DirSensores + '*.sen',AFiles);
  SetLength(ListaSensores,length(AFiles)+2);

  // Creo los sensores B�sicos
  ListaSensores[0]             := TSensor.Crear;
  ListaSensores[1]             := TSensor.Crear;
  ListaSensores[1].Nombre      := 'Dato Original';
  ListaSensores[1].Config      := 1;
  ListaSensores[1].Descripcion := 'Dato Original';
  ListaSensores[1].Unidad      := '-';
  ListaSensores[1].Entrada     := 'PULSO';
  ListaSensores[1].Modo        := 'CICLO';
  ListaSensores[1].Salida      := 'NUMERO';
  ListaSensores[1].Curva[0].x  := 0;      ListaSensores[1].Curva[0].y  := 0;
  ListaSensores[1].Curva[1].x  := 65536;  ListaSensores[1].Curva[1].y  := 65536;
  ListaSensores[1].Minimo      := 0;
  ListaSensores[1].Maximo      := 65536;

  //Cargo cada sensor
  for i:=0 to length(AFiles)-1 do begin
    ListaSensores[i+2] := TSensor.Crear;
    ListaSensores[i+2].CargarDeArchivo(Mercury.DirSensores + AFiles[i].Name);
  end;

  // Cargo los nombres de los sensores al ComboBox
  cbSensores.Items.Clear;
  for i:=0 to length(ListaSensores)-1 do begin
    for j:=0 to length(ListaSensores)-1 do begin
      if (ListaSensores[j].Config = i) then begin
        ListaSensores[j].PosLista := j;
        cbSensores.Items.Add(ListaSensores[j].Nombre);
      end;
    end;
  end;

  SetLength(AFiles,0);
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.mAcercaClick(Sender: TObject);
begin
  // Creo la presentaci�n
  FPresentacion := TFPresentacion.Create(Self);
  FPresentacion.Timer1.Interval := 4000;
  FPresentacion.Timer1.Enabled  := true;
  FPresentacion.Showmodal;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.mDescargarDatosClick(Sender: TObject);
begin
  // Adapto el sistema para el formato elejido (espa�ol - ingles)

  StatusBar.Panels[0].Text          := 'Descargando ' + IntToStr(Equipo.Memoria) + ' Bytes...';
  Equipo.ThreadComm.FormatoDescarga := Mercury.FormatoDescarga;
  Equipo.ThreadComm.IndiceFormatoFe := Mercury.IndiceFormatoFe;  
  Equipo.ThreadComm.Archivo         := Mercury.DirDatos+Equipo.Nombre+'_'+FormatDateTime('dd.mm.yyyy hh.nn',now);
  Equipo.ThreadComm.DescargarDatos  := true;

  // Una vez descargados los datos se AutoConfigura al Equipo
  if upCase(Mercury.AutoConfigurar) ='S' then Mercury.Configurar := true;
  if upCase(Mercury.SalirDescarga)  ='S' then Mercury.Salir      := true;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.StatusBarDrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
var
  area : trect;

 begin
  if (statusbar.Tag <= 0) then exit;

  area := rect;
  with statusbar do begin
    Canvas.Brush.Style := bsSolid;
    Canvas.Brush.color := $00DF860D;//clblack;
    area.Right         := rect.Left + ((Panel.Width*Tag) div 100);
    Canvas.Fillrect(area);
    canvas.Font.Color  := clwhite;
    canvas.Brush.Style := bsclear;
    Canvas.TextOut((rect.Right+rect.Left-canvas.TextExtent(inttostr(Tag)+'%').cx)div 2,area.top,inttostr(Tag)+'%');
  end;
  TagOLD := statusbar.Tag;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.ActualizarProgreso(Sender: TObject);
begin
  Statusbar.Refresh;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.mAutoDescargarDatosClick(Sender: TObject);
begin
  if (sender as TMenuItem).Checked then begin
    (sender as TMenuItem).Checked := false;
    Mercury.AutoDescargarDatos    := 'N';
  end
  else begin
    (sender as TMenuItem).Checked := true;
    Mercury.AutoDescargarDatos    := 'S';
  end;

  // Cartel de Informac�on
  MessageBox(Handle,'Debe reiniciar el programa para que '+
            #13+'los cambios tengan efecto.' , PChar(Caption), MB_OK	or MB_ICONINFORMATION );
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.mAutoConfigurarClick(Sender: TObject);
begin
  if (sender as TMenuItem).Checked then begin
    (sender as TMenuItem).Checked := false;
    Mercury.AutoConfigurar        := 'N';
  end
  else begin
    (sender as TMenuItem).Checked := true;
    Mercury.AutoConfigurar        := 'S';
  end;

  // Cartel de Informac�on
  MessageBox(Handle,'Debe reiniciar el programa para que '+
            #13+'los cambios tengan efecto.' , PChar(Caption), MB_OK	or MB_ICONINFORMATION );
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.mSalirDescargaClick(Sender: TObject);
begin
  if (sender as TMenuItem).Checked then begin
    (sender as TMenuItem).Checked := false;
    Mercury.SalirDescarga         := 'N';
  end
  else begin
    (sender as TMenuItem).Checked := true;
    Mercury.SalirDescarga         := 'S';
  end;

  // Cartel de Informac�on
  MessageBox(Handle,'Debe reiniciar el programa para que '+
            #13+'los cambios tengan efecto.' , PChar(Caption), MB_OK	or MB_ICONINFORMATION );
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.PuertoSerieClick(Sender: TObject);
var
  i : byte;

begin
  // Quito el tilde de todos los items
  for i:=0 to mPuertoSerie.Count-1 do mPuertoSerie.Items[i].Checked := false;

  // Pongo el tilde
  (sender as TMenuItem).Checked := true;
  Mercury.PuertoSerie           := PSerie.ListaPorts.Strings[(sender as TMenuItem).MenuIndex];

  // Cartel de Informac�on
  MessageBox(Handle,'Debe reiniciar el programa para que '+
            #13+'los cambios tengan efecto.' , PChar(Caption), MB_OK	or MB_ICONINFORMATION );
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.mPreferenciasClick(Sender: TObject);
begin
  FPreferencias := TFPreferencias.Create(self);
  FPreferencias.ShowModal;
end;


////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.TimerCierreTimer(Sender: TObject);
begin
  close;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.sbGrabarClick(Sender: TObject);
var
  ImgAux : TBitmap;

begin
  ImgAux := TBitmap.Create;

  if not Mercury.Grabando then begin
    Mercury.Grabando := true;
    caption          := ' EMAC MERCURY - Monitoreo en Linea';
    sbGrabar.Caption := 'Detener';

    // Asigno la imagen de Stop
    DataModule1.ImageList32x32.GetBitmap(13,ImgAux);
    sbGrabar.Glyph.Assign(ImgAux);

    // Desabilito los objetos para que no se puedan modificar las opciones
    tbGrabar.Enabled           := false;
    cbReporte.Enabled          := false;
    cbReporteWeb.Enabled       := false;
    sbDirDatos.Enabled         := false;
    sbSaveWeb.Enabled          := false;
    cbFormatoReporte.Enabled   := false;
    cbIntervaloCaptura.Enabled := false;
    cbTipoArchivo.Enabled      := false;
    tbParar.Enabled            := true;

    // Codigo de la Captura
    // Guardo los par�metreos de Monitoreo
    if cbReporte.Checked then Mercury.ReporteSel := 'S'
    else Mercury.ReporteSel := 'N';

    if cbReporteWeb.Checked then Mercury.ReporteWebSel := 'S'
    else Mercury.ReporteWebSel := 'N';

    Mercury.DirReporte         := EDirReporte.Text;
    Mercury.NombreNuevaWeb     := EdirNuevaWeb.Text;
    Mercury.FormatoReporte     := cbFormatoReporte.ItemIndex;
    Mercury.IntervaloCaptura   := cbIntervaloCaptura.ItemIndex;
    Mercury.TipoArchivoReporte := cbTipoArchivo.ItemIndex;

    // Hora del Muestreo
    // Redondeo los segundos
    Mercury.HoraMuestreoLinea  := trunc(now*86400+1)/86400; 
  end
  else begin
    Mercury.Grabando := false;
    caption          := ' EMAC MERCURY';
    sbGrabar.Caption := 'Capturar';

    // Asigno la imagen de Grabar
    DataModule1.ImageList32x32.GetBitmap(11,ImgAux);
    sbGrabar.Glyph.Assign(ImgAux);

    // Modifico los Botones de la Toolbar
    tbParar.Enabled            := false;    
    tbGrabar.Enabled           := true;
    cbReporte.Enabled          := true;
    cbReporteWeb.Enabled       := true;
    sbDirDatos.Enabled         := true;
    sbSaveWeb.Enabled          := true;
    cbFormatoReporte.Enabled   := true;
    cbIntervaloCaptura.Enabled := true;
    cbTipoArchivo.Enabled      := true;
  end;

  ImgAux.Free;
end;

procedure TFprincipal.tsMonitoreoContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin

end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.tsMonitorOnLineShow(Sender: TObject);
begin
  if (UpCase(Mercury.ReporteSel)   ='S') then cbReporte.Checked    := true
  else cbReporte.Checked := false;

  if (UpCase(Mercury.ReporteWebSel)='S') then cbReporteWeb.Checked := true
  else cbReporteWeb.Checked := false;

  EDirReporte.Text             := Mercury.DirReporte;
  EdirNuevaWeb.Text            := Mercury.NombreNuevaWeb;
  cbFormatoReporte.ItemIndex   := Mercury.FormatoReporte;
  cbIntervaloCaptura.ItemIndex := Mercury.IntervaloCaptura;
  cbTipoArchivo.ItemIndex      := Mercury.TipoArchivoReporte;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.sbDirDatosClick(Sender: TObject);
var
  aux : string;

begin
  if not SelectDirectory('Directorio de Datos','',aux) then SetFocus
  else begin
    SetFocus;
    if (length(aux)>3) then EDirReporte.Text := aux + '\'
    else EDirReporte.Text := aux;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.sbSaveWebClick(Sender: TObject);
begin
  DataModule1.SaveDialog.FileName := ExtractFileName(EdirNuevaWeb.Text);
  DataModule1.SaveDialog.InitialDir := ExtractFilePath(EdirNuevaWeb.Text);
  DataModule1.SaveDialog.Filter := 'Paginas Web (*.htm, *.html)|*.htm;*.html';

  if DataModule1.SaveDialog.Execute then begin
    if length(ExtractFileExt(DataModule1.SaveDialog.FileName))>0 then
      EdirNuevaWeb.Text := DataModule1.SaveDialog.FileName
    else
      EdirNuevaWeb.Text := DataModule1.SaveDialog.FileName + '.htm';
  end;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.MonitoreoEnLinea;
var
  Archivo      : string;
  sep          : string;
  ext          : string;
  Linea        : string;
  lineaAux1    : string;
  lineaAux2    : string;
  F            : TextFile;
  i            : byte;
  FormatoFecha : string;

begin
  // me fijo que es el momento de generar lo(s) reporte(s)
  if (now < Mercury.HoraMuestreoLinea) then exit;

  // Nueva hora de Muestra
  Mercury.HoraMuestreoLinea := now + TablaTMonitor[Mercury.IntervaloCaptura];

  // Me aseguro que exista el directorio de destino
  if not DirectoryExists(Mercury.DirReporte) then exit;

  // Configuro los par�metros seg�n el formato elegido
  case Mercury.FormatoReporte of
    // Texto (delimitado por tabulaciones)
    0 : begin
          sep := #9;
          ext := '.txt';
        end;
    // CSV - Planilla de c�lculo (formato en espa�ol)
    1 : begin
          sep := ';';
          ext := '.txt';
        end;
    // CSV - Planilla de c�lculo (formato en ingles)
    2 : begin
          sep := ',';
          ext := '.txt';
        end;
    else begin
      // Texto (delimitado por tabulaciones)
      sep := #9;
      ext := '.txt';
    end;
  end;

  // Genero el nombre del archivo seg�n el tipo de archivo elejido
  case Mercury.TipoArchivoReporte of
    // Generar un archivo por Hora
    0 : Archivo  := Mercury.DirReporte+'Monitoreo_'+Equipo.Nombre+'_'+FormatDateTime('dd.mm.yyyy hh',now) + ext;
    // Generar un archivo por D�a
    1 : Archivo  := Mercury.DirReporte+'Monitoreo_'+Equipo.Nombre+'_'+FormatDateTime('dd.mm.yyyy',now) + ext;
    // Generar un archivo por Mes
    2 : Archivo  := Mercury.DirReporte+'Monitoreo_'+Equipo.Nombre+'_'+FormatDateTime('mm.yyyy',now) + ext;
    // Generar un archivo por A�o
    3 : Archivo  := Mercury.DirReporte+'Monitoreo_'+Equipo.Nombre+'_'+FormatDateTime('yyyy',now) + ext;
    else
      // Generar un archivo por D�a
      Archivo  := Mercury.DirReporte+'Monitoreo_'+Equipo.Nombre+'_'+FormatDateTime('dd.mm.yyyy',now) + ext;
  end;

  // Configuro las varable para adaptar la fecha con el formato elegido
  FormatoFecha := Mercury.ObtenerFormatoFecha(Mercury.IndiceFormatoFe);

  // Genero el reporte en el archivo de texto
  if (upcase(Mercury.ReporteSel)='S') then begin
    try // Guardo la info en el archivo
      AssignFile(F, Archivo);

      if FileExists(Archivo) then Append(F)
      else begin
        // Incorporo la info en el archivo de texto y los titulos
        Rewrite(F);

        // Para reporte en archivo de texto
        Writeln(F,'Datos Generales');
        Writeln(F,'--------------------------');
        Writeln(F,'Nombre del Equipo '+sep+'= '+ Equipo.Nombre);
        Writeln(F,'Intervalo de Captura'+sep+'= '+ cbIntervaloCaptura.text);
        Writeln(F,'Hora del Equipo   '+sep+'= '+ FormatDateTime(FormatoFecha, Equipo.Hora));
        Writeln(F,'Hora de la PC     '+sep+'= '+ FormatDateTime(FormatoFecha, Equipo.HoraPC));
        Writeln(F,'');
        Writeln(F,'');

        // Descripci�n de los canales
        Writeln(F,'Descripci�n de los Canales');
        Writeln(F,'--------------------------');

        for i:=0 to Equipo.NumCanales-1 do begin
          if (Equipo.Canales[i].Config > 0) then
            if (sep = #9) then
              Writeln(F,'CH '+IntToStr(i)+#9#9+sep+'= '+Equipo.Canales[i].Descripcion +
                      ' ' + '[' + Equipo.Canales[i].Unidad + ']')
            else
              Writeln(F,'CH '+IntToStr(i)+sep+'= '+Equipo.Canales[i].Descripcion +
                      ' ' + '[' + Equipo.Canales[i].Unidad + ']');
        end;
        Writeln(F,'');
        Writeln(F,'');

        // Descripci�n de los valores calculados
        Writeln(F,'Valores Calculados');
        Writeln(F,'--------------------------');

        for i:=0 to Equipo.CalcParam.CantParm-1 do begin
          if (Equipo.CalcParam.Parametros[i].Calcular = 1) then
            if (sep = #9) then
              Writeln(F,'VC '+IntToStr(i)+#9#9+sep+'= '+Equipo.CalcParam.Parametros[i].Descripcion +
                      ' ' + '[' + Equipo.CalcParam.Parametros[i].Unidad + ']')
            else
              Writeln(F,'VC '+IntToStr(i)+sep+'= '+Equipo.CalcParam.Parametros[i].Descripcion +
                      ' ' + '[' + Equipo.CalcParam.Parametros[i].Unidad + ']');
        end;
        Writeln(F,'');
        Writeln(F,'');


        // Titulos de la tabla de los valores de los canales y valores
        for i:=0 to Equipo.CalcParam.CantParm-1 do begin
          if (Equipo.CalcParam.Parametros[i].Calcular = 1) then begin
            lineaAux1 := lineaAux1 + 'VC ' + IntToStr(i) + sep;
            lineaAux2 := lineaAux2 + '----' + sep;
          end;
        end;

        Writeln(F,lineaAux1);
        Writeln(F,lineaAux2);
      end;

      // Incorporo la info del monitoreo en linea al archivo
      Linea := FormatDateTime('dd/mm/yyyy hh:nn:ss.zzz',now);

      // Info de los valores de los Canales
      for i:=0 to Equipo.NumCanales-1 do
        if (Equipo.Canales[i].Config<>0) then
          Linea := Linea + sep + Equipo.Canales[i].ValorReal;

      // Info de los valores Calculdaos
      for i:=0 to Equipo.CalcParam.CantParm-1 do
        if (Equipo.CalcParam.Parametros[i].Calcular = 1) then
          Linea := Linea + sep + Equipo.CalcParam.Parametros[i].ResultCalcStr;

      Writeln(F,Linea);
      CloseFile(F);
    except
      // Cartel de ERROR
      //MessageDlg('No se puede escribir en el archivo ', mtError,[mbOk], 0);
    end;
  end;

  // Genero el Reporte Web si es necessario
  if (upcase(Mercury.ReporteWebSel)='S') then GenerarReporteWeb;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.GenerarReporteWeb;
var
  PaginaWeb    : Tstrings;
  i            : integer;
  FormatoFecha : string;

begin
  if not FileExists(Mercury.NombrePaginaWeb) then exit;
  PaginaWeb := TStringlist.Create;
  PaginaWeb.Clear;

  // Levanto la plantilla web para cargar los datos
  PaginaWeb.LoadFromFile(Mercury.NombrePaginaWeb);

  // Configuro las varable para adaptar la fecha con el formato elegido
  FormatoFecha := Mercury.ObtenerFormatoFecha(Mercury.IndiceFormatoFe);

  // Inserto la info en la pagina
  for i:=0 to PaginaWeb.Count-1 do begin
    // Informarc�on del Equipo
    PaginaWeb.Strings[i] := ReemplazarString(PaginaWeb.Strings[i],'#FECHA#',FormatDateTime(FormatoFecha, now));
    PaginaWeb.Strings[i] := ReemplazarString(PaginaWeb.Strings[i],'#NOMBRE#',Equipo.Nombre);
    if (round(TablaTMonitor[Mercury.IntervaloCaptura]*86400)>30) then
      PaginaWeb.Strings[i] := ReemplazarString(PaginaWeb.Strings[i],'#T#',IntToStr(round(TablaTMonitor[Mercury.IntervaloCaptura]*86400)))
    else
      PaginaWeb.Strings[i] := ReemplazarString(PaginaWeb.Strings[i],'#T#',IntToStr(30));

    // Informarc�on de los valores de los canales
    PaginaWeb.Strings[i] := ReemplazarString(PaginaWeb.Strings[i],'#CANAL0#',Equipo.Canales[0].ValorReal + ' ['+Equipo.Canales[0].Unidad+']');
    PaginaWeb.Strings[i] := ReemplazarString(PaginaWeb.Strings[i],'#CANAL1#',Equipo.Canales[1].ValorReal + ' ['+Equipo.Canales[1].Unidad+']');
    PaginaWeb.Strings[i] := ReemplazarString(PaginaWeb.Strings[i],'#CANAL2#',Equipo.Canales[2].ValorReal + ' ['+Equipo.Canales[2].Unidad+']');
    PaginaWeb.Strings[i] := ReemplazarString(PaginaWeb.Strings[i],'#CANAL3#',Equipo.Canales[3].ValorReal + ' ['+Equipo.Canales[3].Unidad+']');
    PaginaWeb.Strings[i] := ReemplazarString(PaginaWeb.Strings[i],'#CANAL4#',Equipo.Canales[4].ValorReal + ' ['+Equipo.Canales[4].Unidad+']');
    PaginaWeb.Strings[i] := ReemplazarString(PaginaWeb.Strings[i],'#CANAL5#',Equipo.Canales[5].ValorReal + ' ['+Equipo.Canales[5].Unidad+']');
    PaginaWeb.Strings[i] := ReemplazarString(PaginaWeb.Strings[i],'#CANAL6#',Equipo.Canales[6].ValorReal + ' ['+Equipo.Canales[6].Unidad+']');
    PaginaWeb.Strings[i] := ReemplazarString(PaginaWeb.Strings[i],'#CANAL7#',Equipo.Canales[7].ValorReal + ' ['+Equipo.Canales[7].Unidad+']');
    PaginaWeb.Strings[i] := ReemplazarString(PaginaWeb.Strings[i],'#CANALD#',Equipo.Canales[8].ValorReal + ' ['+Equipo.Canales[8].Unidad+']');

    // Informarc�on de los valores calculados
    PaginaWeb.Strings[i] := ReemplazarString(PaginaWeb.Strings[i],'#VC0#',Equipo.CalcParam.Parametros[0].ResultCalcStr + ' ['+Equipo.CalcParam.Parametros[0].Unidad+']');
    PaginaWeb.Strings[i] := ReemplazarString(PaginaWeb.Strings[i],'#VC1#',Equipo.CalcParam.Parametros[1].ResultCalcStr + ' ['+Equipo.CalcParam.Parametros[1].Unidad+']');
    PaginaWeb.Strings[i] := ReemplazarString(PaginaWeb.Strings[i],'#VC2#',Equipo.CalcParam.Parametros[2].ResultCalcStr + ' ['+Equipo.CalcParam.Parametros[2].Unidad+']');
    PaginaWeb.Strings[i] := ReemplazarString(PaginaWeb.Strings[i],'#VC3#',Equipo.CalcParam.Parametros[3].ResultCalcStr + ' ['+Equipo.CalcParam.Parametros[3].Unidad+']');
  end;

  try
    // Guardo la pagina web con los nuevos valores
    PaginaWeb.SaveToFile(Mercury.NombreNuevaWeb);
  except
    //
  end;

  PaginaWeb.Free;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.BotonGraficoCanalClick(Sender: TObject);
var
  Canal : byte;

begin
  // Charting functionality temporarily disabled for Lazarus compatibility
  {FGraficoSensor := TFGraficoSensor.Create(self);
  Canal          := (sender as TSpeedButton).Tag;
  // Solo cuando uso el canal 9 
  if (Canal=8) and Equipo.UsarCH9 then Canal:=9;

  FGraficoSensor.Caption                              := FGraficoSensor.ListaCanales.Strings[Canal];
  FGraficoSensor.CanalOrg                             := Canal;
  FGraficoSensor.pEquipo                              := @Equipo;
  FGraficoSensor.DBGrafico.Title.Text.Text            := Equipo.Canales[Canal].Descripcion;
  FGraficoSensor.FechaInicial                         := now;
  FGraficoSensor.PopupMenuSeries.Items[Canal].Checked := true;
  FGraficoSensor.CrearSerie;
  FGraficoSensor.Show;

  inc(GraficosOpen,1);}
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.sbComentarioClick(Sender: TObject);
var
  NuevaDesc : string;
  Canal     : byte;

begin
  Canal:= (sender as TSpeedButton).Tag;
  // Solo cuando uso el canal 9
  if (Canal=8) and Equipo.UsarCH9 then Canal:=9;

  NuevaDesc := Equipo.Canales[Canal].Descripcion;
  if not InputQuery('Cambiar Descripci�n del Canal '+intToStr(Canal),
                    'Ingrese una nueva Descripci�n',NuevaDesc) then exit;

  Equipo.Canales[Canal].Descripcion := NuevaDesc;
  Equipo.GuardarEquipo(Mercury.DirEquipos);
  Equipo.CargarEquipo(Mercury.DirEquipos);
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.mCalculosParam(Sender: TObject);
begin
  FCalculoParam            := TFCalculoParam.Create(self);
//  FCalculoParam.Caption    := 'C�lculo de par�metros - ' + (sender as TMenuItem).Caption;
  FCalculoParam.pEquipo    := @Equipo;
  FCalculoParam.Nparametro := (sender as TMenuItem).Tag;
  FCalculoParam.ShowModal;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.TipoDeComunicacionClick(Sender: TObject);
begin
  mDirectaCableSERIE.Checked := false;
  mTelefoniaCelular.Checked  := false;
  mInternet.Checked          := false;

  // Aplico la nueva configuraci�n                                                  
  (sender as TMenuItem).Checked := true;
  Mercury.TipoDeComm            := (sender as TMenuItem).Tag;

  // Cartel de Informac�on
  MessageBox(Handle,'Debe reiniciar el programa para que '+
            #13+'los cambios tengan efecto.' , PChar(Caption), MB_OK	or MB_ICONINFORMATION );
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.mConexionesTelefonicasClick(Sender: TObject);
begin
  FConexionesRemotas := TFConexionesRemotas.Create(self);
  FConexionesRemotas.pConexTelefon := @Mercury.ConexTelefon;
  
  FConexionesRemotas.ShowModal;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.mConexionAutoClick(Sender: TObject);
begin
  FConexionAuto          := TFConexionAuto.Create(self);
  FConexionAuto.pMercury := @Mercury;
  FConexionAuto.ShowModal;

  // habilito el bot�n para indicar que est� habilitada la conexi�n auto
  if (Mercury.ConexAuto.intervalo > 0) then begin
    tbConexAutoEN.Enabled := true;
    tbConexAutoEN.Hint    := 'Conexiones automaticas habilitadas';
  end
  else begin
    tbConexAutoEN.Enabled := false;
    tbConexAutoEN.Hint    := 'Conexiones automaticas deshabilitadas';
  end;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.ConexionManualClick(Sender: TObject);
var
  Nitem, msg : integer;

begin
  Nitem := (sender as TMenuItem).Tag;
  msg   := MessageBox(Handle,pchar('�Seguro que desea conectarce con '+Mercury.ConexTelefon.AConexiones[Nitem].Nombre+'?'),
                      PChar(Caption), MB_YESNO or MB_ICONQUESTION );
  if (msg = 7) then exit;     // Presiono el Boton "NO", No hago nada

  ConcectarConRemoto(Nitem, false, false);
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.mDesconectarClick(Sender: TObject);
begin
  DesconcectarConRemoto;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.ConcectarConRemoto(index : integer;  AutoDesconecDesc, AutoDesconecConf : boolean);
begin
  // Asigno el Numero de telefono al que hay que llamar
  Equipo.ThreadComm.NombreConex := Mercury.ConexTelefon.AConexiones[index].Nombre;
  Equipo.ThreadComm.Ntelefono   := Mercury.ConexTelefon.AConexiones[index].Ntelefono;

  // Inicio la conexi�n
  Equipo.ThreadComm.ConecTelef := true;

  // Indico si se debe desconectar solo una vez bajados los datos
  Equipo.ThreadComm.AutoDesconecDesc := AutoDesconecDesc;
  // Indico si se debe desconectar solo una vez configurado el equipo  
  Equipo.ThreadComm.AutoDesconecConf := AutoDesconecConf;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.DesconcectarConRemoto;
begin
  // Termino la conexi�n
  Equipo.ThreadComm.DesConecTelef := true;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.ConexionAutomatica(Sender: TObject);
var
  aux : TStrings;

begin
  // Me aseguro que no excista una conexi�n activa
  if Equipo.ThreadComm.ConexOK then exit;

  // Si est� en la lista me conecto
  if Mercury.ConexTelefon.AConexiones[Mercury.ConexAuto.indexConex].Select = 'S' then begin
    // Selecciono los distintos tipos de conexi�n
    case Mercury.ConexAuto.CritDesconec of
      0 :  ConcectarConRemoto(Mercury.ConexAuto.indexConex, true , false);
      1 :  ConcectarConRemoto(Mercury.ConexAuto.indexConex, false, true);
    else
      ConcectarConRemoto(Mercury.ConexAuto.indexConex, false, true);
    end;

    // Prueba de conexi�n - Generaci�n del archivo de logeo
    aux := TStringlist.Create;
    aux.Clear;
    try
      if FileExists('horaConexion.txt') then aux.LoadFromFile('horaConexion.txt');
      aux.Add(Mercury.ConexTelefon.AConexiones[Mercury.ConexAuto.indexConex].Nombre
              + ' ' + FormatDateTime('dd/mm/yy hh:nn:ss',now));
      aux.SaveToFile('horaConexion.txt');
    except
      //
    end;
    aux.Destroy;
  end;

  // Incremento el indice
  inc(Mercury.ConexAuto.indexConex,1);

  // Me fijo si termine de conectarme con todos los equipos - reseteo el indice
  if (Mercury.ConexAuto.indexConex > Mercury.ConexTelefon.NumConex-1) then
    Mercury.ConexAuto.indexConex :=0;

  // Guardo la config ya que tiene la nueva fecha y hora de muestreo
  Mercury.GuardarConfig;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.ONConexionRemota(Sender: TObject);
begin
  // Escribo el cartel para indicar que me estoy conectando
  StatusBar.Panels[0].Text := 'Conectando con "'+ Equipo.ThreadComm.NombreConex +'"...';

  // Habilito el bot�n y el men� para desconectar
  tbDesconectar.Enabled := true;
  mDesconectar.Enabled  := true;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.ONDesconexionRemota(Sender: TObject);
begin
  // Deshabilito el bot�n y el men� para desconectar
  tbDesconectar.Enabled := false;
  mDesconectar.Enabled  := false;

  // Escribo el cartel para indicar que me estoy Desconectando
  StatusBar.Panels[0].Text := 'Desconectando...';
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.mConfiguracionDeInternetClick(Sender: TObject);
begin
  FConfiguracionInternet          := TFConfiguracionInternet.Create(self);
  FConfiguracionInternet.pEquipo  := @Equipo;
  FConfiguracionInternet.ShowModal;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.PageControlChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  if (Mercury.TipoDeComm = 2) then AllowChange := false;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.PageControlChange(Sender: TObject);
begin
  if ((Mercury.TipoDeComm <> 2) and (PageControl.ActivePageIndex = 3)) then
    PageControl.ActivePageIndex := 0;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.mHistorialInternetChange(Sender: TObject);
var
  NombreM  : string;
  //dirM     : string;
  auxLines : Tstrings; 

begin
  if not (Mercury.GuardarRegistro = 'S') then exit;
  if not (mHistorialInternet.Lines.Count > 0) or OnCambio then exit;
  if (mHistorialInternet.Lines.Count = IniLine) then exit;
  OnCambio := true;

  // Guardo el registro de conexiones de internet
  try
    NombreM := Mercury.DirMercury+'\logs\LogInternet '+FormatDateTime('dd-mm-yyyy',now)+'.txt';
    {dirM    := ExtractFilePath(NombreM);


    // Me aseguro que exista el dir sino lo creo
    if not DirectoryExists(dirM) then MkDir(dirM);

    // Guardo la info en el disco
    if not FileExists(NombreM) then mHistorialInternet.Lines.SaveToFile(NombreM)
    else begin
      auxLines := TStringList.Create;
      auxLines.LoadFromFile(NombreM);
      auxLines.Add(mHistorialInternet.Lines.Strings[mHistorialInternet.Lines.Count-1]);
      if DeleteFile(NombreM) then auxLines.SaveToFile(NombreM);
      auxLines.Destroy;
    end;
    }

    // Guardo la nueva linea en el archivo de logs
    auxLines := TStringList.Create;
    auxLines.Add(mHistorialInternet.Lines.Strings[mHistorialInternet.Lines.Count-1]);
    SaveTstringsToTxtFile(NombreM, @auxLines, 0, 0 );
    IniLine := mHistorialInternet.Lines.Count;
    auxLines.Destroy;

    // Quito la primera linea del historial si tiene mas de 50 lineas
    with mHistorialInternet.Lines do begin
      if Count>500 then begin
        {// Quito la primera linea
        Delete(0);
        // Modifico la �ltima linea para que el curso quede sobre la �ltima linea
        Strings[Count-1] := Strings[Count-1]+'';
        IniLine         := Count;  }

        mHistorialInternet.Lines.Clear;
        IniLine := 0;
      end;
    end;
  except
    //
  end;
  OnCambio := false;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.mBorrarHistorialClick(Sender: TObject);
begin
  mHistorialInternet.Clear;
end;

////////////////////////////////////////////////////////////////////////////////
// Implementaciones para los nuevos canales visuales (09-15)
// Solo muestran mensajes informativos - No tienen funcionalidad real

procedure TFprincipal.sbGrafico09Click(Sender: TObject);
begin
  MessageBox(Handle,'Canal 09 es solo visual. No tiene gráfico disponible.',
             PChar(Caption), MB_OK or MB_ICONINFORMATION);
end;

procedure TFprincipal.sbGrafico10Click(Sender: TObject);
begin
  MessageBox(Handle,'Canal 10 es solo visual. No tiene gráfico disponible.',
             PChar(Caption), MB_OK or MB_ICONINFORMATION);
end;

procedure TFprincipal.sbGrafico11Click(Sender: TObject);
begin
  MessageBox(Handle,'Canal 11 es solo visual. No tiene gráfico disponible.',
             PChar(Caption), MB_OK or MB_ICONINFORMATION);
end;

procedure TFprincipal.sbGrafico12Click(Sender: TObject);
begin
  MessageBox(Handle,'Canal 12 es solo visual. No tiene gráfico disponible.',
             PChar(Caption), MB_OK or MB_ICONINFORMATION);
end;

procedure TFprincipal.sbGrafico13Click(Sender: TObject);
begin
  MessageBox(Handle,'Canal 13 es solo visual. No tiene gráfico disponible.',
             PChar(Caption), MB_OK or MB_ICONINFORMATION);
end;

procedure TFprincipal.sbGrafico14Click(Sender: TObject);
begin
  MessageBox(Handle,'Canal 14 es solo visual. No tiene gráfico disponible.',
             PChar(Caption), MB_OK or MB_ICONINFORMATION);
end;

procedure TFprincipal.sbGrafico15Click(Sender: TObject);
begin
  MessageBox(Handle,'Canal 15 es solo visual. No tiene gráfico disponible.',
             PChar(Caption), MB_OK or MB_ICONINFORMATION);
end;

procedure TFprincipal.sbComentario09Click(Sender: TObject);
begin
  MessageBox(Handle,'Canal 09 es solo visual. No tiene comentarios disponibles.',
             PChar(Caption), MB_OK or MB_ICONINFORMATION);
end;

procedure TFprincipal.sbComentario10Click(Sender: TObject);
begin
  MessageBox(Handle,'Canal 10 es solo visual. No tiene comentarios disponibles.',
             PChar(Caption), MB_OK or MB_ICONINFORMATION);
end;

procedure TFprincipal.sbComentario11Click(Sender: TObject);
begin
  MessageBox(Handle,'Canal 11 es solo visual. No tiene comentarios disponibles.',
             PChar(Caption), MB_OK or MB_ICONINFORMATION);
end;

procedure TFprincipal.sbComentario12Click(Sender: TObject);
begin
  MessageBox(Handle,'Canal 12 es solo visual. No tiene comentarios disponibles.',
             PChar(Caption), MB_OK or MB_ICONINFORMATION);
end;

procedure TFprincipal.sbComentario13Click(Sender: TObject);
begin
  MessageBox(Handle,'Canal 13 es solo visual. No tiene comentarios disponibles.',
             PChar(Caption), MB_OK or MB_ICONINFORMATION);
end;

procedure TFprincipal.sbComentario14Click(Sender: TObject);
begin
  MessageBox(Handle,'Canal 14 es solo visual. No tiene comentarios disponibles.',
             PChar(Caption), MB_OK or MB_ICONINFORMATION);
end;

procedure TFprincipal.sbComentario15Click(Sender: TObject);
begin
  MessageBox(Handle,'Canal 15 es solo visual. No tiene comentarios disponibles.',
             PChar(Caption), MB_OK or MB_ICONINFORMATION);
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure TFprincipal.tbExpansionClick(Sender: TObject);
begin
  if not Assigned(FExpansion) then
    FExpansion := TFExpansion.Create(Application);
  
  // Set radio button state based on current visibility?
  // Ideally FExpansion should know current state.
  // For now, just show it.
  FExpansion.ShowModal;
end;

end.
