unit UServerSocket;

interface
uses
  Classes, SysUtils, Sockets, UUtiles, blcksock, UEquipo, UEquipoInternet;

type
  { Creamos un Hilo puro de Free Pascal }
  TServerListenerThread = class(TThread)
  private
    FPort: Integer;
    FpTStrings: TpTstrings; // Puntero al cuadro de Logs de la ventana
    FServerIP: string;
    FListenerSocket: TTCPBlockSocket; // El 'socket padre' de Synapse
    
    // Variables temporales para el Log a través de Synchronize
    FLogMsg: string;
    procedure LogMessage;
  protected
    procedure Execute; override;
  public
    constructor Create(Port: Integer; pStrings: TpTstrings; IP: string = '0.0.0.0');
    destructor Destroy; override;
    procedure Detener;
  end;

implementation

constructor TServerListenerThread.Create(Port: Integer; pStrings: TpTstrings; IP: string = '0.0.0.0');
begin
  inherited Create(True); // Se crea suspendido (Esperando a que le den a Start)
  FreeOnTerminate := True;
  FPort := Port;
  FpTStrings := pStrings;
  FServerIP := IP;
  FListenerSocket := TTCPBlockSocket.Create;
end;

destructor TServerListenerThread.Destroy;
begin
  FListenerSocket.Free;
  inherited Destroy;
end;

procedure TServerListenerThread.Detener;
begin
  Terminate;
  // Al cerrar el socket, destrabamos instantáneamente el Hilo.
  if Assigned(FListenerSocket) then
    FListenerSocket.CloseSocket; 
end;

procedure TServerListenerThread.LogMessage;
var
  strHora: string;
begin
  if FpTStrings <> nil then
  begin
    strHora := FormatDateTime('dd/mm/yy hh:nn:ss ', now);
    FpTStrings^.Add(strHora + ' -> ' + FLogMsg);
  end;
end;

procedure TServerListenerThread.Execute;
var
  ClientSocketHandle: TSocket;
  WorkerThread: TServEquipoThread;
  EqInternet: TEquipoInternet;
begin
  FListenerSocket.CreateSocket;
  FListenerSocket.EnableReuse(True);
  FListenerSocket.setLinger(True, 10000);
  
  // Le decimos al puerto que escuche
  FListenerSocket.Bind(FServerIP, IntToStr(FPort));
  FListenerSocket.Listen;

  if FListenerSocket.LastError = 0 then
  begin
    FLogMsg := 'El servidor est escuchando en el puerto ' + IntToStr(FPort) + '...';
    Synchronize(LogMessage); // Escribimos en el Memo principal de forma segura
  end
  else
  begin
    FLogMsg := 'Error al iniciar escucha: ' + FListenerSocket.LastErrorDesc;
    Synchronize(LogMessage);
    Exit;
  end;

  // LOOP PRINCIPAL DE ESTADOS ========================
  while not Terminated do
  begin
    // Se "duerme" 1000ms esperando que un equipo intente conectarse. 
    // Como está en un hilo, no traba la pantalla del usuario.
    if FListenerSocket.CanRead(1000) then
    begin
      ClientSocketHandle := FListenerSocket.Accept;
      
      if FListenerSocket.LastError = 0 then
      begin
        FLogMsg := 'Cliente GPRS conectado.';
        Synchronize(LogMessage);

        // Crear el modelo con cantidad base (10 canales). LeerConfig detectara
        // la cantidad real desde la trama CE y redimensionara dinamicamente.
        EqInternet := TEquipoInternet(TEquipo.Crear(10, 'TCP', 2));

        // Crear hilo esclavo con referencia al modelo y al log
        WorkerThread := TServEquipoThread.Create(False, ClientSocketHandle,
            50000, EqInternet, FpTStrings, Mercury.DirDatosInternet);
        // Note: FreeOnTerminate should be set inside TServEquipoThread
      end;
    end;
  end;
  // FIN LOOP =========================================

  FLogMsg := 'Apagando el servidor...';
  Synchronize(LogMessage);
end;

end.
