unit UExpansion;

{$mode delphi}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Spin;

type

  { TFExpansion }

  TFExpansion = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    rbCanales24: TRadioButton;
    rbCanales32: TRadioButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
    procedure RadioButton2Change(Sender: TObject);
  private

  public

  end;

var
  FExpansion: TFExpansion;

implementation

uses Uprincipal, UUtiles;

{$R *.lfm}

{ TFExpansion }

procedure TFExpansion.Label1Click(Sender: TObject);
begin

end;

procedure TFExpansion.FormCreate(Sender: TObject);
begin
  case Mercury.NumCanales of
    8:  RadioButton1.Checked := true;
    16: RadioButton2.Checked := true;
    24: rbCanales24.Checked := true;
    32: rbCanales32.Checked := true;
    else RadioButton1.Checked := true;
  end;
end;

procedure TFExpansion.Button1Click(Sender: TObject);
begin
  if RadioButton1.Checked then Mercury.NumCanales := 8;
  if RadioButton2.Checked then Mercury.NumCanales := 16;
  if rbCanales24.Checked then Mercury.NumCanales := 24;
  if rbCanales32.Checked then Mercury.NumCanales := 32;

  ModalResult := mrOK;
end;

procedure TFExpansion.RadioButton1Change(Sender: TObject);
begin

end;

procedure TFExpansion.RadioButton2Change(Sender: TObject);
begin

end;

end.

