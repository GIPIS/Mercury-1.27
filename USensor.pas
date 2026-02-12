unit USensor;

{$MODE Delphi}

interface
uses
  Classes, SysUtils, Dialogs, Math, IniFiles;

type

  TPunto = record
              x,y : real;
              txt : string;
           end;

  TSensor = class(Tobject)
    private
      //
    public
      Nombre      : string;
      Config      : byte;
      ConfigINI   : byte;
      PosLista    : byte;
      Descripcion : string;
      DescrINI    : string;
      Unidad      : string;
      Entrada     : string;
      Modo        : string; //ACUMULAR; CICLO
      Salida      : string;
      Decimales   : byte;
      Curva       : array of TPunto;
      ValorSensor : integer;
      ValorReal   : string;
      ValorNum    : real;
      ValorText   : string;
      Escala      : real;
      Minimo      : real;
      Maximo      : real;

      constructor Crear;
      destructor  Destruir;
      function    CargarDeArchivo(Archivo:string):boolean;
      function    GuardarEnArchivo(Archivo:string):boolean;
      function    ObtenerDesc:string;
      procedure   ComputarValor(x:real);
      procedure   InterpolarNum(x:real);
      procedure   InterpolarText(x:real);
      procedure   Asignar(NuevoSensor : TSensor);
      procedure   Limpiar;
  end;

  TASensor = array of TSensor;    

implementation
////////////////////////////////////////////////////////////////////////////////
// TSensor //////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TSensor.Crear;
begin
  Nombre      := 'No habilitado';
  Descripcion := '';
  DescrINI    := '';
  Unidad      := '';
  Decimales   := 0;
  Entrada     := 'TENSION';
  Modo        := 'CICLO';
  Salida      := 'NUMERO';
  Config      := 0; // Canal no habilitado
  ConfigINI   := 0; // Canal no habilitado
  PosLista    := 0;
  ValorNum    := 0;

  // Creo una curva generica
  SetLength(Curva,2);
  Curva[0].x := 0;    Curva[0].y := 0;
  Curva[1].x := 1;    Curva[1].y := 0;
end;

////////////////////////////////////////////////////////////////////////////////
destructor TSensor.Destruir;
begin
  SetLength(Curva,0);
end;

////////////////////////////////////////////////////////////////////////////////
function TSensor.CargarDeArchivo(Archivo:string):boolean;
var
  ArchivoSensor : TIniFile;
  SeccionesINI  : TStrings;
  valoresX      : string;
  valoresY      : string;
  aux           : string;
  i,k           : integer;

begin
  SeccionesINI  := TStringList.Create;
  ArchivoSensor := TIniFile.Create(Archivo);

  if not FileExists(ArchivoSensor.FileName) then begin
    result := False;
    ArchivoSensor.Free;
    exit;
  end;

  try
    SeccionesINI.Clear;
    ArchivoSensor.ReadSections(SeccionesINI);

    // Cargo los datos del sensor
    Nombre      := SeccionesINI.Strings[0];
    Config      := StrToInt(ArchivoSensor.ReadString(Nombre,'ID'       ,'0'));
    Decimales   := StrToInt(ArchivoSensor.ReadString(Nombre,'Decimales','0'));
    Descripcion := ArchivoSensor.ReadString(Nombre,'Descripcion','vacio');
    Unidad      := ArchivoSensor.ReadString(Nombre,'Unidad'     ,'vacio');
    Entrada     := ArchivoSensor.ReadString(Nombre,'Entrada'    ,'TENSION');
    Modo        := ArchivoSensor.ReadString(Nombre,'Modo'       ,'CICLO');
    Salida      := ArchivoSensor.ReadString(Nombre,'Salida'     ,'NUMERO');
    ValoresX    := ArchivoSensor.ReadString(Nombre,'X'          ,'0');
    ValoresY    := ArchivoSensor.ReadString(Nombre,'Y'          ,'0');

    // Cargo los valores X de la Curva 
    aux := '';
    SetLength(Curva,1);
    for i:=1 to length(ValoresX) do begin
      if valoresX[i]<>';' then
        aux := aux + ValoresX[i]
      else begin
        Curva[length(Curva)-1].x   := StrToFloat(aux);
        Curva[length(Curva)-1].y   := 0;
        Curva[length(Curva)-1].txt := '-';
        aux                        := '';
        SetLength(Curva,length(Curva)+1);
      end;
    end;
    SetLength(Curva,length(Curva)-1);

    // Cargo los valores Y de la Curva
    aux := '';
    k   := 0;
    for i:=1 to length(ValoresY) do begin
      if valoresY[i]<>';' then
        aux := aux + ValoresY[i]
      else begin
        if UpperCase(Salida) = 'NUMERO' then Curva[k].Y   := StrToFloat(aux);
        if UpperCase(Salida) = 'TEXTO'  then Curva[k].txt := aux;
        aux := '';
        inc(k,1);
        if (k>length(ValoresY)) then break;
      end;
    end;

    // Busco los maximo y minimo de la curva  
    if UpperCase(Salida) = 'NUMERO' then begin
      maximo := Curva[0].Y;
      minimo := Curva[0].Y;
      for i:=0 to length(Curva)-1 do begin
         maximo := max(maximo,Curva[i].Y);
         minimo := min(minimo,Curva[i].Y);
      end;
    end;

    result := true;
  except
    result := false;
  end;

  ArchivoSensor.Free;
  SeccionesINI.Free;
end;

////////////////////////////////////////////////////////////////////////////////
function TSensor.GuardarEnArchivo(Archivo:string):boolean;
var
  ArchivoSensor : TIniFile;
  i             : integer;
  auxX, auxY    : string;

begin
  if FileExists(Archivo) then begin
    if not DeleteFile(Archivo) then begin
      result := False;
      exit;
    end;
  end;

  ArchivoSensor := TIniFile.Create(Archivo);
  try
    ArchivoSensor.WriteString(Nombre,'ID'         ,IntToStr(Config));
    ArchivoSensor.WriteString(Nombre,'Descripcion',Descripcion);
    ArchivoSensor.WriteString(Nombre,'Unidad'     ,Unidad);
    ArchivoSensor.WriteString(Nombre,'Decimales'  ,IntToStr(Decimales));
    ArchivoSensor.WriteString(Nombre,'Entrada'    ,Entrada);
    ArchivoSensor.WriteString(Nombre,'Modo'       ,Modo);
    ArchivoSensor.WriteString(Nombre,'Salida'     ,Salida);

    auxX := '';
    auxY := '';
    for i:=0 to length(Curva)-1 do begin
      auxX := auxX + FloatToStr(Curva[i].x) + ';';
      if UpperCase(Salida) = 'NUMERO' then auxY := auxY + FloatToStr(Curva[i].y)+ ';';
      if UpperCase(Salida) = 'TEXTO'  then auxY := auxY + Curva[i].txt          + ';';
    end;
    ArchivoSensor.WriteString(Nombre,'X' ,auxX);
    ArchivoSensor.WriteString(Nombre,'Y' ,auxY);
    ArchivoSensor.WriteString(Nombre,'--','--');
  except
    ArchivoSensor.Free;
    result := False;
    exit;
  end;

  ArchivoSensor.Free;
  result := true;
end;

////////////////////////////////////////////////////////////////////////////////
function TSensor.ObtenerDesc:string;
begin
  // Genero la linea que contine una descripción básica del Sensor
  result := '('+intToStr(Config)+')'+#9+ Descripcion+'; ['+Unidad+']; '+Entrada+'; '+Modo+'; '+Salida+'.';
end;

////////////////////////////////////////////////////////////////////////////////
procedure TSensor.ComputarValor(x:real);
var
  auxDecimales : string;
  i            : byte;

begin
  // Formato de salida en función de la cantidad de decimales requeridos   
  
  auxDecimales :='0';
  if Decimales>0 then begin
    auxDecimales :='0.';
    for i:=1 to Decimales do auxDecimales := auxDecimales + '0';
  end;

  // Corrección por la escala.
  if UpperCase(Entrada)= 'TENSION'then x := x*escala;

  // Calculo el valor real del sensor
  if UpperCase(Salida) = 'NUMERO' then begin
    InterpolarNum(x);
    ValorReal := FormatFloat(auxDecimales,ValorNum);
  end;
  if UpperCase(Salida) = 'TEXTO'  then begin
    InterpolarText(x);
    ValorReal := ValorText;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TSensor.InterpolarNum(x:real);
var
  i,n,iant,imin,imax : integer;
  paux, paux1        : TPunto;

begin
  n := length(Curva)-1;
  if (n = 0)           then begin ValorNum := 0;          exit; end;
  if (Curva[0].x >= x) then begin ValorNum := Curva[0].y; exit; end;
  if (Curva[n].x <= x) then begin ValorNum := Curva[n].y; exit; end;

  imin :=0; imax := n; i := imax;
  repeat
    iant := i;
    i    := (imax+imin) shr 1;
    paux := Curva[i];
    if (x >paux.x) then
    begin
      imin := i;
      continue;
    end;
    if (x <paux.x) then
    begin
      imax := i;
      continue;
    end;
    if (x = paux.x) then begin ValorNum := paux.y ; exit; end;
  until (iant=i);

  paux      := Curva[imin];    paux1 := Curva[imax];
  ValorNum  := (x-paux.x)*(paux1.y-paux.y)/(paux1.x-paux.x) + paux.y;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TSensor.InterpolarText(x:real);
var
  i,n,iant,imin,imax : integer;
  paux, paux1        : TPunto;

begin
  n := length(Curva)-1;
  if (n = 0)           then begin ValorText := '-';          exit; end;
  if (Curva[0].x >= x) then begin ValorText := Curva[0].txt; exit; end;
  if (Curva[n].x <= x) then begin ValorText := Curva[n].txt; exit; end;

  imin :=0; imax := n; i := imax;
  repeat
    iant := i;
    i := (imax+imin) shr 1;
    paux := Curva[i];
    if (x >paux.x) then
    begin
      imin := i;
      continue;
    end;
    if (x <paux.x) then
    begin
      imax := i;
      continue;
    end;
    if (x = paux.x) then begin ValorText := paux.txt; exit end;
  until (iant=i);

  paux  := Curva[imin];    paux1 := Curva[imax];
//  Valor := (x-paux.x)*(paux1.y-paux.y)/(paux1.x-paux.x) + paux.y;

  if abs(x-paux.x) < abs(x-paux1.x) then ValorText := paux.txt
  else ValorText := paux1.txt;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TSensor.Asignar(NuevoSensor : TSensor);
var
  i : integer;
  
begin
  // Cargo los datos generales
  Nombre      := NuevoSensor.Nombre;
  Config      := NuevoSensor.Config;
  PosLista    := NuevoSensor.PosLista;
  Descripcion := NuevoSensor.Descripcion;
  Unidad      := NuevoSensor.Unidad;
  Decimales   := NuevoSensor.Decimales;
  Entrada     := NuevoSensor.Entrada;
  Modo        := NuevoSensor.Modo;
  Salida      := NuevoSensor.Salida;
  Maximo      := NuevoSensor.Maximo;
  Minimo      := NuevoSensor.Minimo;
  //Escala      := NuevoSensor.Escala;

  // Asigno la curva
  SetLength(Curva,length(NuevoSensor.Curva));
  for i:=0 to length(NuevoSensor.Curva)-1 do begin
    Curva[i].x   := NuevoSensor.Curva[i].x;
    Curva[i].y   := NuevoSensor.Curva[i].y;
    Curva[i].txt := NuevoSensor.Curva[i].txt;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
procedure  TSensor.Limpiar;
begin
  Nombre      := 'No habilitado';
  Descripcion := '';
  Unidad      := '';
  Entrada     := 'TENSION';
  Modo        := 'CICLO';
  Salida      := 'NUMERO';
  Config      := 0; // Canal no habilitado
  ValorNum    := 0;
end;

////////////////////////////////////////////////////////////////////////////////
end.
