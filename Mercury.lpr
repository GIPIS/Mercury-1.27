program Mercury;

{$MODE Delphi}

uses
  Forms, Interfaces,
  Uprincipal in 'Uprincipal.pas' {Fprincipal},
  UEquipo in 'UEquipo.pas',
  PuertoSerie in 'PuertoSerie.pas',
  UUtiles in 'UUtiles.pas',
  UPresentacion in 'UPresentacion.pas' {FPresentacion},
  USensor in 'USensor.pas',
  UPreferencias in 'UPreferencias.pas' {FPreferencias},
  // UGrafico in 'UGrafico.pas' {FGraficoSensor}, // Temporarily disabled - requires Chart component
  // UOpciones3D in 'UOpciones3D.pas' {FormOpciones3D}, // Temporarily disabled
  // UColor in 'UColor.pas' {FColor}, // Temporarily disabled
  UDataModule in 'UDataModule.pas' {DataModule1: TDataModule},
  UFormulas in 'UFormulas.pas',
  UCalculoParam in 'UCalculoParam.pas' {FCalculoParam},
  UConexionesRemotas in 'UConexionesRemotas.pas' {FConexionesRemotas},
  UConexiones in 'UConexiones.pas',
  UConexionAuto in 'UConexionAuto.pas' {FConexionAuto},
  UConfiguracionInternet in 'UConfiguracionInternet.pas' {FConfiguracionInternet},
  UServerSocket in 'UServerSocket.pas', // Temporarily disabled - requires socket implementation
  UEquipoInternet in 'UEquipoInternet.pas', // Temporarily disabled - requires socket implementation
  UDiaJuliano in 'UDiaJuliano.pas',
  UExpansion in 'UExpansion.pas' {FExpansion};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFprincipal, Fprincipal);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.CreateForm(TFExpansion, FExpansion);
  Application.Run;
end.
