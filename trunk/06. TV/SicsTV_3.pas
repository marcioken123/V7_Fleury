unit SicsTV_3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SicsTV_m, IniFiles, MyDlls_DR, Sics_Common_Parametros;

type
  TfrmSicsHorarioDeFuncionamento = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    chkFuncionaDomingo: TCheckBox;
    chkFuncionaSabado: TCheckBox;
    btnOK: TButton;
    btnCancela: TButton;
    edDeH: TEdit;
    Label3: TLabel;
    edDeM: TEdit;
    edAteH: TEdit;
    Label4: TLabel;
    edAteM: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure LoadHorarioDeFuncionamento (var Horario : THorarioDeFuncionamento);
procedure SaveHorarioDeFuncionamento (    Horario : THorarioDeFuncionamento);
function  SetHorarioDeFuncionamento  (var Horario : THorarioDeFuncionamento) : boolean;

implementation

{$R *.dfm}

procedure LoadHorarioDeFuncionamento (var Horario : THorarioDeFuncionamento);
var
  IniFile : TIniFile;
begin
  IniFile := TIniFile.Create(GetAppIniFileName);
  with IniFile do
    try
      Horario.DesdeHoras      := EncodeTime(vgParametrosModulo.DeH, vgParametrosModulo.DeM, 0 , 0  );
      Horario.AteHoras        := EncodeTime(vgParametrosModulo.AteH, vgParametrosModulo.AteM, 00, 000);
      Horario.FuncionaSabado  := vgParametrosModulo.FuncionaSabado;
      Horario.FuncionaDomingo := vgParametrosModulo.FuncionaDomingo;
    finally
      Free;
    end;  { try .. finally }
end;

procedure SaveHorarioDeFuncionamento (    Horario : THorarioDeFuncionamento);
var
  IniFile     : TIniFile;
  h, m, s, ms : word;
begin
  IniFile := TIniFile.Create(GetAppIniFileName);
  with IniFile do
    try
      DecodeTime  (Horario.DesdeHoras, h, m, s, ms);
      vgParametrosModulo.DeH := h;
      vgParametrosModulo.DeM := m;

      DecodeTime  (Horario.AteHoras  , h, m, s, ms);
      vgParametrosModulo.AteH := h; //WriteInteger('HorarioDeFuncionamento','AteH' , h );
      vgParametrosModulo.AteM := m; //WriteInteger('HorarioDeFuncionamento','AteM' , m );

      vgParametrosModulo.FuncionaSabado  := Horario.FuncionaSabado; //WriteBool   ('HorarioDeFuncionamento','FuncionaSabado' , Horario.FuncionaSabado );
      vgParametrosModulo.FuncionaDomingo := Horario.FuncionaDomingo; //WriteBool   ('HorarioDeFuncionamento','FuncionaDomingo', Horario.FuncionaDomingo);
    finally
      Free;
    end;  { try .. finally }
end;

function SetHorarioDeFuncionamento  (var Horario : THorarioDeFuncionamento) : boolean;
var
  frmSicsHorarioDeFuncionamento : TfrmSicsHorarioDeFuncionamento;
  h, m, s, ms                : word;
begin
  Result := false;
  frmSicsHorarioDeFuncionamento := TfrmSicsHorarioDeFuncionamento.Create(Application);
  with frmSicsHorarioDeFuncionamento do
  begin
    try
      DecodeTime (Horario.DesdeHoras, h, m, s, ms);
      edDeH.Text := FormatNumber(2, h);
      edDeM.Text := FormatNumber(2, m);
      DecodeTime (Horario.AteHoras  , h, m, s, ms);
      edAteH.Text := FormatNumber(2, h);
      edAteM.Text := FormatNumber(2, m);
      chkFuncionaSabado .Checked := Horario.FuncionaSabado;
      chkFuncionaDomingo.Checked := Horario.FuncionaDomingo;
      if ShowModal = mrOK then
      begin
        Horario.DesdeHoras := EncodeTime(strtoint(edDeH .Text), strtoint(edDeM .Text),  0,   0);
        Horario.AteHoras   := EncodeTime(strtoint(edAteH.Text), strtoint(edAteM.Text), 59, 999);
        Horario.FuncionaSabado  := chkFuncionaSabado .Checked;
        Horario.FuncionaDomingo := chkFuncionaDomingo.Checked;
        Result := true;
      end;
    finally
      Free;
    end;
  end;
end;

procedure TfrmSicsHorarioDeFuncionamento.FormCreate(Sender: TObject);
begin
  LoadPosition (Sender as TForm);
end;

procedure TfrmSicsHorarioDeFuncionamento.FormDestroy(Sender: TObject);
begin
  SavePosition (Sender as TForm);
end;

end.
