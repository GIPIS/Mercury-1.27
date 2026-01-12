unit UPreferencias;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, Buttons, UUtiles, StdCtrls,
  UDataModule, MaskEdit;

type
  TFPreferencias = class(TForm)
    ImageLogo: TImage;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    Bevel1: TBevel;
    sbAceptar: TSpeedButton;
    sbCerrar: TSpeedButton;
    Bevel2: TBevel;
    GroupBox: TGroupBox;
    EDirDatos: TEdit;
    Label1: TLabel;
    sbDirDatos: TSpeedButton;
    GroupBox1: TGroupBox;
    rbNormal: TRadioButton;
    rbMinimizado: TRadioButton;
    rbTray: TRadioButton;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    cbFormatoOUT: TComboBox;
    Label3: TLabel;
    cbFormatoFecha: TComboBox;
    GroupBox3: TGroupBox;
    Label4: TLabel;
    sbBuscarPaginaWeb: TSpeedButton;
    EPaginaWeb: TEdit;
    sbMuestraWeb: TSpeedButton;
    tbConfigInternet: TTabSheet;
    GroupBox4: TGroupBox;
    Label5: TLabel;
    sbDirDatosInternet: TSpeedButton;
    eDirDatosInternet: TEdit;
    GroupBox5: TGroupBox;
    Port: TLabel;
    mePort: TMaskEdit;
    GroupBox6: TGroupBox;
    Label6: TLabel;
    cbPeriodoDescarga: TComboBox;
    GroupBox7: TGroupBox;
    Label7: TLabel;
    cbLog: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure sbCerrarClick(Sender: TObject);
    procedure sbAceptarClick(Sender: TObject);
    procedure sbDirDatosClick(Sender: TObject);
    procedure sbMuestraWebClick(Sender: TObject);
    procedure sbBuscarPaginaWebClick(Sender: TObject);
    procedure sbDirDatosInternetClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  FPreferencias: TFPreferencias;

implementation

{$R *.lfm}
////////////////////////////////////////////////////////////////////////////////
procedure TFPreferencias.FormCreate(Sender: TObject);
begin
  PageControl.ActivePageIndex := 0;
  cbFormatoOUT.ItemIndex      := Mercury.FormatoDescarga;
  cbFormatoFecha.ItemIndex    := Mercury.IndiceFormatoFe;

  // Cargo los datos
  eDirDatos.Text              := Mercury.DirDatos;
  eDirDatosInternet.Text      := Mercury.DirDatosInternet;
  ePaginaWeb.Text             := Mercury.NombrePaginaWeb;
  mePort.Text                 := IntToStr(Mercury.Puerto);
  cbPeriodoDescarga.ItemIndex := Mercury.PeriodoDescarga;

  if UpCase(Mercury.IniciarNormal)    ='S' then  rbNormal.Checked     := true;
  if UpCase(Mercury.IniciarMinimizado)='S' then  rbMinimizado.Checked := true;
  if UpCase(Mercury.IniciarTray)      ='S' then  rbTray.Checked       := true;
  if UpCase(Mercury.GuardarRegistro)  ='S' then  cbLog.Checked        := true;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFPreferencias.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFPreferencias.sbCerrarClick(Sender: TObject);
begin
  close;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFPreferencias.sbAceptarClick(Sender: TObject);
begin
  // Chequeo los parámetros, para asegurarme que sean correctos
  if not ((StrToInt(mePort.Text)>20) and (StrToInt(mePort.Text)<65536)) then begin
    // Cartel de Informacíon
    MessageBox(Handle,'El puerto debe ser mayor a 20 y menor a 65536' , PChar(Caption), MB_OK	or MB_ICONERROR );
    exit;
  end;

  // Cargo los paramétros de Configuración
  Mercury.DirDatos         := EDirDatos.Text;
  Mercury.DirDatosInternet := eDirDatosInternet.Text;
  Mercury.Puerto           := StrToInt(mePort.Text);
  Mercury.NombrePaginaWeb  := EPaginaWeb.Text;
  Mercury.FormatoDescarga  := cbFormatoOUT.ItemIndex;
  Mercury.IndiceFormatoFe  := cbFormatoFecha.ItemIndex;
  Mercury.PeriodoDescarga  := cbPeriodoDescarga.ItemIndex;  

  if rbNormal.Checked     then Mercury.IniciarNormal     := 'S' else Mercury.IniciarNormal     := 'N';
  if rbMinimizado.Checked then Mercury.IniciarMinimizado := 'S' else Mercury.IniciarMinimizado := 'N';
  if rbTray.Checked       then Mercury.IniciarTray       := 'S' else Mercury.IniciarTray       := 'N';
  if cbLog.Checked        then Mercury.GuardarRegistro   := 'S' else Mercury.GuardarRegistro   := 'N';

  close;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFPreferencias.sbDirDatosClick(Sender: TObject);
var
  aux : string;

begin
  if not SelectDirectory('Directorio de Datos','',aux) then SetFocus
  else begin
    SetFocus;
    if (length(aux)>3) then EDirDatos.Text := aux + '\'
    else EDirDatos.Text := aux
  end;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFPreferencias.sbDirDatosInternetClick(Sender: TObject);
var
  aux : string;

begin
  if not SelectDirectory('Directorio de Datos','',aux) then SetFocus
  else begin
    SetFocus;
    if (length(aux)>3) then eDirDatosInternet.Text := aux + '\'
    else eDirDatosInternet.Text := aux
  end;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFPreferencias.sbMuestraWebClick(Sender: TObject);
begin
  if not FileExists(EPaginaWeb.Text) then exit;

   OpenDocument(Pchar(EPaginaWeb.Text)); { *Convertido desde ShellExecute* }
end;

////////////////////////////////////////////////////////////////////////////////
procedure TFPreferencias.sbBuscarPaginaWebClick(Sender: TObject);
begin
  DataModule1.OpenDialog.FileName := '';
  DataModule1.OpenDialog.InitialDir := ExtractFilePath(EPaginaWeb.Text);
  DataModule1.OpenDialog.Filter := 'Paginas Web (*.htm, *.html)|*.htm;*.html|Archivos JavaScript (*.js)|*.js';

  if DataModule1.OpenDialog.Execute then EPaginaWeb.Text := DataModule1.OpenDialog.FileName;
end;

////////////////////////////////////////////////////////////////////////////////
end.
