unit ufrmPingMonitor_DX;

interface
{$INCLUDE ..\AspDefineDiretivas.inc}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  MyDlls_DR,  MyAspFuncoesUteis_VCL,
  Controls, Forms, Dialogs, AdvSmoothGauge, ExtCtrls, StdCtrls;

type
  TfrmPingMonitor = class;

  TPingThread = class(TThread)
  protected
    _Form      : TfrmPingMonitor;
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: Boolean; aForm: TfrmPingMonitor);
  end;

  TfrmPingMonitor = class(TForm)
    Memo1: TMemo;
    gauge100: TAdvSmoothGauge;
    gauge20: TAdvSmoothGauge;
    lblEstatisticasTotais: TLabel;
    lblNome: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AnyComponentClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    Enviados, Recebidos : integer;
    UltimoEm            : TDateTime;
    LogPing             : boolean;
    LogFileName         : string;

    PingThread : TPingThread;
  public
    { Public declarations }
    IP   : string;
    Nome : string;
  end;

procedure CriaMonitorPing(AParent : TWinControl; PingarNome, PingarIP : string; LogarPing : boolean; const AOnDestroy : TNotifyEvent = nil);

implementation

var
  _OnDestroy : TNotifyEvent;

{$R *.dfm}

procedure LogPing (FileName, s : string);
var
  f : textfile;
begin
  AssignFile(f, FileName);
  if FileExists(FileName) then
    Append(f)
  else
    Rewrite(f);

  try
    write(f, s);
  finally
    CloseFile(f);
  end;
end;


function SetValidStringForFileName (s : string) : string;
var
  i : integer;
begin
  Result := '';
  for i := 1 to length(s) do
  begin
    if CharInSet(s[i], ['A'..'Z', 'a'..'z']) then
      Result := Result + s[i];
  end;
end;


procedure CriaMonitorPing(AParent : TWinControl; PingarNome, PingarIP : string; LogarPing : boolean; const AOnDestroy : TNotifyEvent = nil);
var
  frmPingMonitor : TfrmPingMonitor;
begin
  if AParent = nil then
    frmPingMonitor := TfrmPingMonitor.Create(Application)
  else
  begin
    frmPingMonitor := TfrmPingMonitor.Create(AParent);
    frmPingMonitor.BorderStyle := bsNone;
    frmPingMonitor.Parent := AParent;
    frmPingMonitor.Align := alClient;
  end;

  with frmPingMonitor do
  begin
    Enviados        := 0;
    Recebidos       := 0;
    UltimoEm        := 0;
    IP              := PingarIP;
    Nome            := PingarNome;
    LogPing         := LogarPing;
    lblNome.Caption := PingarNome;

    if LogPing then
    begin
      LogFileName := GetApplicationPath + '\LogPing\' + SetValidStringForFileName(Nome)  + ' - ' + IP + ' - ' + FormatDateTime('yymmdd hhnnss', now) + '.txt';
      ForceDirectories(GetApplicationPath + '\LogPing');
      Color := clYellow;
    end
    else
      LogFileName := '';

    _OnDestroy := AOnDestroy;
    Show;
    PingThread := TPingThread.Create(True, frmPingMonitor);
    PingThread.Start;
  end;
end;

procedure TfrmPingMonitor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TerminateThread(PingThread.Handle,0);

  if Owner is TPanel then
    (Owner as TPanel).Destroy
  else
    Action := caFree;

  if Assigned(_OnDestroy) then
    _OnDestroy(Application);
end;

procedure TfrmPingMonitor.FormCreate(Sender: TObject);
begin
  inherited;
  LoadPosition(Sender as TForm);
end;

procedure TfrmPingMonitor.FormDestroy(Sender: TObject);
begin
  SavePosition(Sender as TForm);
  inherited;
end;

procedure TfrmPingMonitor.AnyComponentClick(Sender: TObject);
begin
  Close;
end;

{ TPingThread }

constructor TPingThread.Create(CreateSuspended: Boolean; aForm: TfrmPingMonitor);
begin
  Inherited Create (CreateSuspended);
  _Form := aForm;
  FreeOnTerminate := true;
end;


procedure TPingThread.Execute;
var
  {$IFDEF SuportaPing}
  RTT : cardinal;
  {$ENDIF SuportaPing}
  i, j, Sucesso100, Sucesso20 : integer;
begin
  inherited;
  while not Terminated do
  begin
    _Form.Memo1.Lines.Add('Pingando ' + _Form.IP + '... ');
    if _Form.LogPing then
      LogPing(_Form.LogFileName, FormatDateTime('dd/mm/yy hh:nn:ss,zzz', now) + ' - Pingando ' + _Form.IP + '... ');

    _Form.Enviados := _Form.Enviados + 1;
    {$IFDEF SuportaPing}
    if Ping(_Form.IP, 5000, RTT) then
    begin
      _Form.Memo1.Lines[_Form.memo1.Lines.Count - 1] := _Form.Memo1.Lines[_Form.memo1.Lines.Count - 1] + 'Sucesso, ' + Format('%4d', [RTT]) + 'ms';
      _Form.Recebidos := _Form.Recebidos + 1;
      _Form.UltimoEm  := now;

      if _Form.LogPing then
        LogPing(_Form.LogFileName, 'Sucesso, ' + Format('%4d', [RTT]) + 'ms' + #13#10);
    end
    else
    {$ENDIF SuportaPing}
    begin
      _Form.Memo1.Lines[_Form.memo1.Lines.Count - 1] := _Form.Memo1.Lines[_Form.memo1.Lines.Count - 1] + 'Falha';
      if _Form.LogPing then
        LogPing(_Form.LogFileName, 'Falha' + #13#10);
    end;

    Sucesso100 := 0;
    Sucesso20  := 0;
    j          := 0;
    for i := _Form.Memo1.Lines.Count - 1 downto 0 do
    begin
      j := j + 1;
      if Pos('Sucesso', _Form.Memo1.Lines[i]) > 0 then
      begin
        if j <= 20 then
          Sucesso20  := Sucesso20  + 1;
        if j <= 100 then
          Sucesso100 := Sucesso100 + 1;
      end;
    end;

    if _Form.Memo1.Lines.Count > 100 then
    begin
      _Form.Memo1.Lines.Delete(0);
      _Form.Memo1.SelStart := length(_Form.Memo1.Text);
      _Form.Memo1.SelLength:=0;
      SendMessage(_Form.Memo1.Handle, EM_SCROLLCARET, 0, 0);
    end;

    _Form.gauge20 .Value := Sucesso20 ;
    _Form.gauge100.Value := Sucesso100;

    _Form.lblEstatisticasTotais.Caption := IntToStr(_Form.Recebidos) + '/' + inttostr(_Form.Enviados) + '  (' + Format('%1.1f', [100 * _Form.Recebidos / _Form.Enviados]) + '%)';
    if _Form.UltimoEm = 0 then
      _Form.lblEstatisticasTotais.Caption := _Form.lblEstatisticasTotais.Caption + '  -  Ult: ---'
    else
      _Form.lblEstatisticasTotais.Caption := _Form.lblEstatisticasTotais.Caption + '  -  Ult: ' + FormatDateTime ('hh:nn:ss', now - _Form.UltimoEm);

    Sleep(1500);
  end;
end;

end.
