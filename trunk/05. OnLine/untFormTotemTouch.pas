unit untFormTotemTouch;

interface

{$J+}

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  MyAspFuncoesUteis,
  {$IFDEF SuportaPortaCom}
  ScktComp, VaComm, VaClasses, VaPrst,
  System.AnsiStrings,
  {$ENDIF SuportaPortaCom}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  untCommonFormBase, Data.Bind.EngExt, FMX.Bind.DBEngExt,
  Data.Bind.Components, FMX.Controls.Presentation, FMX.Objects, FMX.Layouts,
  IdBaseComponent, IdComponent, IdCustomTCPServer, IdTCPServer,
  IdContext, System.IniFiles, IdTCPConnection, System.UIConsts, System.ImageList, FMX.ImgList, IdTCPClient, System.Rtti, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.DBScope, Data.DB, Datasnap.DBClient, FMX.ListBox,
  Sics_Common_Parametros,
  untCommonFormBaseOnLineTGS;

type
  TFrmTotemTouch = class(TForm)
    recSemConexao: TRectangle;
    lblAguardandoConexao: TLabel;
    pnlBotoes: TRectangle;
    imgBackground: TImage;
    btnFechar: TSpeedButton;
    AniConectando: TAniIndicator;
    imgFechar: TImage;
    recSemPapel: TRectangle;
    lblSemPapel: TLabel;
    lytRodape: TLayout;
    StyleBook1: TStyleBook;
    procedure btnFecharClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure imgFecharClick(Sender: TObject);

    {$IFDEF SuportaPortaCom}
    procedure PrinterSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure PrinterPortRxChar(Sender: TObject; Count: Integer);
    procedure PrinterSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure PrinterSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure PrinterSocketClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    {$ENDIF SuportaPortaCom}
  protected
    { Private declarations }
    FConnectedToServer: boolean;
    FBotoesCriados: boolean;
    {$IFDEF SuportaPortaCom}
    tmrReconnectTimer: TTimer;
    FImpressoraOnLine: boolean;
    procedure SetImpressoraOnLine(const Value: boolean);
    procedure tmrReconnectTimerTimer(Sender: TObject);
    {$ENDIF SuportaPortaCom}
    procedure SetBotoesCriados(const Value: boolean);
    procedure SetConnectedToServer(const Value: boolean);

    procedure HabilitarBotoes(const aHabilitar: Boolean);
  public
    {$IFDEF SuportaPortaCom}
    PrinterSocket: TServerSocket;
    PrinterPort: TVaComm;
    property ImpressoraOnLine: boolean read FImpressoraOnLine write SetImpressoraOnLine;
    {$ENDIF SuportaPortaCom}

    procedure CriaBotao(const aFilaNo: integer; const aFilaNome: string; const aCor: TAlphaColor);
    procedure MostraPainelSemConexao;
    procedure EscondePainelSemConexao;

    procedure MostraPainelSemPapel;
    procedure EscondePainelSemPapel;

    property BotoesCriados: boolean read FBotoesCriados write SetBotoesCriados;
    property ConnectedToServer: boolean read FConnectedToServer write SetConnectedToServer;

    class procedure Exibir;
    class procedure CriaBotoes;
    class function  ImpressoraEstaOnline : boolean;
  end;

const
  StrBitBtn = 'BitBtn';
  StrlblNomeFila = 'lblNomeFila';

implementation

{$R *.fmx}

uses
  untLog, untSicsOnLine,  IdGlobal, untCommonDMConnection, untCommonDMClient;

var
  FrmTotemTouch : TFrmTotemTouch;


procedure TFrmTotemTouch.CriaBotao(const aFilaNo: integer; const aFilaNome: string; const aCor: TAlphaColor);
var
  LBotaoBitBtn: TButton;
  LLabelTitulo: TLabel;
  LRecBitbtn: TRectangle;
begin
  if not (vgParametrosModulo.JaEstaConfigurado) then
    raise Exception.Create('Parametro não foi configurado.');

  if pnlBotoes.FindComponent(StrBitBtn + inttostr(aFilaNo)) <> nil then
    Exit;

  LBotaoBitBtn            := TButton.Create(pnlBotoes);
  LBotaoBitBtn.Parent     := pnlBotoes;
  LBotaoBitBtn.Name       := StrBitBtn + inttostr(aFilaNo);
  LBotaoBitBtn.Visible    := True;
  LBotaoBitBtn.Tag        := aFilaNo;
  LBotaoBitBtn.Text       := '';

  LRecBitbtn              := TRectangle.Create(LBotaoBitBtn);
  LRecBitbtn.Parent       := LBotaoBitBtn;
  LRecBitbtn.Align        := TAlignLayout.Client;
  LRecBitbtn.Visible      := True;
  LRecBitbtn.Tag          := aFilaNo;

  LLabelTitulo            := TLabel.Create(LRecBitbtn);
  LLabelTitulo.Parent     := LRecBitbtn;
  LLabelTitulo.Name       := StrlblNomeFila + inttostr(aFilaNo);
  LLabelTitulo.Align      := TAlignLayout.Client;

  LLabelTitulo.Visible    := True;
  LLabelTitulo.Tag        := aFilaNo;
  LLabelTitulo.Text       := aFilaNome;

  if Integer(aCor) <> 0 then
    LRecBitbtn.Fill.Color := aCor
  else
    LRecBitbtn.Fill.Color := claBtnFace;

  LRecBitbtn.HitTest      := False;
  LLabelTitulo.HitTest    := False;

  if vgParametrosModulo.ParametrosTotemTouch.BotoesTransparentes then
    LLabelTitulo.Opacity := 0
  else
    LLabelTitulo.Opacity := 1;

  LBotaoBitBtn.Opacity      := LLabelTitulo.Opacity;
  LRecBitbtn.Opacity        := LLabelTitulo.Opacity;

  LLabelTitulo.WordWrap     := true;
  LLabelTitulo.TabStop      := false;

  LLabelTitulo.StyledSettings := [];
  if vgParametrosModulo.ParametrosTotemTouch.FonteBotaoNegrito then
    LLabelTitulo.TextSettings.Font.Style := LLabelTitulo.Font.Style + [TFontStyle.fsBold];
  if vgParametrosModulo.ParametrosTotemTouch.FonteBotaoItalico then
    LLabelTitulo.TextSettings.Font.Style := LLabelTitulo.Font.Style + [TFontStyle.fsItalic];
  if vgParametrosModulo.ParametrosTotemTouch.FonteBotaoSublinhado then
    LLabelTitulo.TextSettings.Font.Style := LLabelTitulo.Font.Style + [TFontStyle.fsUnderline];

  LLabelTitulo.TextSettings.Font.Family := Coalesce(vgParametrosModulo.ParametrosTotemTouch.FonteBotaoNome, LLabelTitulo.TextSettings.Font.Family);
  LLabelTitulo.TextSettings.Font.Size   := Coalesce(vgParametrosModulo.ParametrosTotemTouch.FonteBotaoTamanho, LLabelTitulo.TextSettings.Font.Size);
  LLabelTitulo.TextSettings.FontColor   := Coalesce(vgParametrosModulo.ParametrosTotemTouch.FonteBotaoCor, LLabelTitulo.TextSettings.FontColor);
  LLabelTitulo.TextSettings.HorzAlign   := TTextAlign.Center;
  LLabelTitulo.TextSettings.VertAlign   := TTextAlign.Center;
  LBotaoBitBtn.OnClick                  := FrmSicsOnLine.BitBtn1Click;

  BringToFront;
  LBotaoBitBtn.BringToFront;
  LRecBitbtn  .BringToFront;
  LLabelTitulo.BringToFront;
  LBotaoBitBtn.Cursor      := -1;

  FormResize(Self);
end;


procedure TFrmTotemTouch.MostraPainelSemConexao;
begin
  if not Assigned(AniConectando) then
    Exit;

  //AniConectando.Enabled := true;
  recSemConexao.Visible := true;

  pnlBotoes.Visible := False;
  recSemPapel.Visible := false;
  recSemPapel.Align := TAlignLayout.None;

  HabilitarBotoes(False);

  FrmSicsOnLine.PopUpMenuReimprimir.Enabled := false;
end;


procedure TFrmTotemTouch.MostraPainelSemPapel;
begin
  recSemPapel.Visible := true;
  recSemPapel.Align := TAlignLayout.Client;

  pnlBotoes.Visible := False;

  HabilitarBotoes(False);

  FrmSicsOnLine.PopUpMenuReimprimir.Enabled := false;
end;


procedure TFrmTotemTouch.EscondePainelSemConexao;
begin
  if (Self.fBotoesCriados) and (Self.fConnectedToServer) and (Self.fImpressoraOnLine) then
  begin
    {$IFDEF SuportaPortaCom}
    tmrReconnectTimer.Enabled := True;
    {$ENDIF SuportaPortaCom}
    recSemConexao.Visible := false;
    recSemPapel.Align := TAlignLayout.None;

    AniConectando.Enabled := false;
    pnlBotoes.Visible := True;
    HabilitarBotoes(True);
    FrmSicsOnLine.PopUpMenuReimprimir.Enabled := true;
  end
  else
    MostraPainelSemConexao;
end;


procedure TFrmTotemTouch.EscondePainelSemPapel;
begin
  if (Self.fBotoesCriados) and (Self.fConnectedToServer) and (Self.fImpressoraOnLine) then
  begin
    recSemPapel.Visible := false;
    recSemPapel.Align := TAlignLayout.None;

    pnlBotoes.Visible := true;

    HabilitarBotoes(true);

    FrmSicsOnLine.PopUpMenuReimprimir.Enabled := true;
  end
  else
    MostraPainelSemConexao;
end;


procedure TFrmTotemTouch.HabilitarBotoes(const aHabilitar: Boolean);
var
  I: Integer;
begin
  for i := 0 to pnlBotoes.ComponentCount - 1 do
  begin
    if (pnlBotoes.Components[i] is TButton) then
      TButton(pnlBotoes.Components[i]).Enabled := aHabilitar;
  end;
end;


procedure TFrmTotemTouch.imgFecharClick(Sender: TObject);
begin

end;

//========================================================================
// Ações dos componentes

procedure TFrmTotemTouch.btnFecharClick(Sender: TObject);
begin
  Close;
end;

{$IFDEF SuportaPortaCom}
procedure TFrmTotemTouch.tmrReconnectTimerTimer(Sender: TObject);
var
  LOldReconnectTimer: Boolean;
begin
  if not tmrReconnectTimer.Enabled then
    Exit;
  if not (vgParametrosModulo.JaEstaConfigurado) then
    Exit;

  LOldReconnectTimer := tmrReconnectTimer.Enabled;
  tmrReconnectTimer.Enabled := False;
  try
    if (not fConnectedToServer) and (not PrinterSocket.Active) then
    begin
      PrinterSocket.Active := False;
      PrinterSocket.Active := True;
    end;
  finally
    tmrReconnectTimer.Enabled := LOldReconnectTimer;
  end;

  if btnFechar.Visible then
    btnFechar.BringToFront;
end;
{$ENDIF SuportaPortaCom}

//========================================================================
// Printer socket e serial printer port

{$IFDEF SuportaPortaCom}
procedure TFrmTotemTouch.PrinterPortRxChar(Sender: TObject; Count: Integer);
var
  i : word;
  x : AnsiChar;
  s : string;
begin
  s := '';
  for i := 1 to Count do
  begin
    PrinterPort.ReadChar(x);
    s := s + AspAnsiCharToString(x);
  end;

  for i := PrinterSocket.Socket.ActiveConnections - 1 downto 0 do
    if i <= PrinterSocket.Socket.ActiveConnections - 1 then
      PrinterSocket.Socket.Connections[i].SendText(AspStringToAnsiString('!I' + s + '$'));
end;


procedure TFrmTotemTouch.PrinterSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  ConnectedToServer := true;
end;


procedure TFrmTotemTouch.PrinterSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  ConnectedToServer := false;
end;

procedure TFrmTotemTouch.PrinterSocketClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  if ((ErrorCode = 10060) or (ErrorCode = 10061) or (ErrorCode = 10053) or (ErrorCode = 10054)  or (ErrorCode = 10065)) then
  begin
     ErrorCode := 0;
     Socket.Close;
     ConnectedToServer := false;
  end;
end;

procedure TFrmTotemTouch.PrinterSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
var
  s : string;
begin
  s := AspAnsiStringToString(Socket.ReceiveText);

  if (length(s) = 12) and (s[1] = #2) and (s[length(s)] = #3) and (s[10] = Chr($37)) then
  begin
    if s[11] = '0' then
      MostraPainelSemPapel
    else
      EscondePainelSemPapel;

    Exit;
  end;

  if Pos('!S$', s) > 0 then   //Impressora Zebra
  begin
    Socket.SendText('!I' + Chr(1) + '$');
    s := StringReplace(s, '!S$', '', [rfReplaceAll]);
  end;

  if Pos(#$1D'r1', s) > 0 then   //Impressora Seiko
  begin
    if PrinterPort.Active then
      PrinterPort.WriteText(#$1D'r1');
    s := StringReplace(s, #$1D'r1', '', [rfReplaceAll, rfIgnoreCase]);
  end;

  PrinterPort.WriteText(AspStringToAnsiString(s));
end;
{$ENDIF SuportaPortaCom}

//========================================================================
// Propriedades do formulários

procedure TFrmTotemTouch.SetBotoesCriados(const Value: boolean);
begin
  FBotoesCriados := Value;
  EscondePainelSemConexao;
end;


procedure TFrmTotemTouch.SetConnectedToServer(const Value: boolean);
begin
  FConnectedToServer := Value;
  EscondePainelSemConexao;
end;

{$IFDEF SuportaPortaCom}
procedure TFrmTotemTouch.SetImpressoraOnLine(const Value: boolean);
begin
  FImpressoraOnLine := Value;
  EscondePainelSemConexao;
end;
{$ENDIF SuportaPortaCom}

//========================================================================
// Eventos do formulários

procedure TFrmTotemTouch.FormCreate(Sender: TObject);
begin
  {$IFDEF SuportaPortaCom}
  PrinterSocket := TServerSocket.Create(Self);
  PrinterSocket.Active := False;
  PrinterSocket.Port := 3001;
  PrinterSocket.ServerType := stNonBlocking;
  PrinterSocket.OnClientConnect := PrinterSocketClientConnect;
  PrinterSocket.OnClientDisconnect := PrinterSocketClientDisconnect;
  PrinterSocket.OnClientRead := PrinterSocketClientRead;
  PrinterSocket.OnClientError := PrinterSocketClientError;

  PrinterPort := TVaComm.Create(Self);
  PrinterPort.Baudrate := br9600;
  PrinterPort.FlowControl.OutCtsFlow := False;
  PrinterPort.FlowControl.OutDsrFlow := False;
  PrinterPort.FlowControl.ControlDtr := VaPrst.TVaControlDtr.dtrDisabled;
  PrinterPort.FlowControl.ControlRts := VaPrst.TVaControlRts.rtsDisabled;
  PrinterPort.FlowControl.XonXoffOut := False;
  PrinterPort.FlowControl.XonXoffIn := False;
  PrinterPort.FlowControl.DsrSensitivity := False;
  PrinterPort.FlowControl.TxContinueOnXoff := False;
  PrinterPort.DeviceName := 'COM1';
  PrinterPort.OnRxChar := PrinterPortRxChar;
  FImpressoraOnLine := False;

  tmrReconnectTimer := TTimer.Create(Self);
  tmrReconnectTimer.OnTimer := tmrReconnectTimerTimer;
  tmrReconnectTimer.Interval:= 10000;
  tmrReconnectTimer.Enabled := False;
  {$ENDIF SuportaPortaCom}

  recSemConexao.Align := TAlignLayout.Client;
  pnlBotoes.Align       := TAlignLayout.Client;
  fBotoesCriados        := false;
  fConnectedToServer    := false;
  MostraPainelSemConexao;

  imgFechar.Visible := vgParametrosModulo.ParametrosTotemTouch.MostrarBotaoFechar;

  if vgParametrosModulo.ParametrosTotemTouch.BotaoFecharTamanhoMaior then
  begin
    btnFechar.Position.X   := btnFechar.Position.X - btnFechar.Width;
    btnFechar.Width  := btnFechar.Width  * 2;
    btnFechar.Height := btnFechar.Height * 2;

    imgFechar.Width  := imgFechar.Width  * 2;
    imgFechar.Height := imgFechar.Height * 2;
  end;
end;


procedure TFrmTotemTouch.FormShow(Sender: TObject);
begin
  {$IFDEF SuportaPortaCom}
  PrinterSocket.Active := False;
  PrinterSocket.Port   := vgParametrosModulo.ParametrosTotemTouch.PortaTcp;
  {$ENDIF SuportaPortaCom}
  try
    MostraPainelSemConexao;
    try
      if FileExists(vgParametrosModulo.ParametrosTotemTouch.ImagemFundo) then
        imgBackground.MultiResBitmap.Add.Bitmap.LoadFromFile(vgParametrosModulo.ParametrosTotemTouch.ImagemFundo);
    except
    end;

    {$IFDEF SuportaPortaCom}
    try
      if not PrinterPort.Active then
      begin
        PortaSerial_SetConfig(PrinterPort, vgParametrosModulo.ParametrosTotemTouch.PortaSerialImpressora);
        PrinterPort.Open;
      end;
    except
      on e: Exception do
      begin
        ErrorMessage('Erro ao abrir porta serial!' + #13 + 'Erro: ' + e.Message);
      end;
    end;

    ImpressoraOnLine := PrinterPort.Active;

    try
      if DMConnection(0, not CRIAR_SE_NAO_EXISTIR).SocketEmConflito(PrinterSocket.Port, IPLocalhost, PrinterSocket) then
        ErrorMessage(Format('Erro ao conectar com printer socket %d está em conflito com servidor.', [PrinterSocket.Port]))
      else
        PrinterSocket.Active := True;
    except
      ErrorMessage('Erro ao abrir socket no modo totem!');
    end;
    {$ENDIF SuportaPortaCom}
  finally
    Self.FormResize(Self);
  end;
end;


procedure TFrmTotemTouch.FormActivate(Sender: TObject);
begin
  {$IFDEF SuportaPortaCom}
  tmrReconnectTimer.Enabled := true;
  tmrReconnectTimer.OnTimer(tmrReconnectTimer);
  {$ENDIF SuportaPortaCom}
end;


procedure TFrmTotemTouch.FormResize(Sender: TObject);
const
  LarguraSeta = 24;
  AlturaSeta  = 31;
var
  i, BoundAtual                                : integer;
  NumeroDeBtns, BtnsPorColuna, Largura, Altura : integer;
  BoundsArray                                  : array of TRect;
begin
  if not (vgParametrosModulo.JaEstaConfigurado) then
    Exit;

  NumeroDeBtns := 0;
  for i := 0 to pnlBotoes.ComponentCount - 1 do
  begin
    if (pnlBotoes.Components[i] is TButton) then
      NumeroDeBtns := NumeroDeBtns + 1;
  end;

  SetLength(BoundsArray, NumeroDeBtns + 1);  //seria de 0 a Numero-1 (Total de "NumeroDeBtns"), porém como índice do array é mais fácil varrer nos loops a partir de 1, irá de 0 a Número (Total "Numero + 1"), desprezando o 0 nos loops

  if NumeroDeBtns > 0 then
  begin
    if NumeroDeBtns mod vgParametrosModulo.ParametrosTotemTouch.ColunasDeBotoes = 0 then
      BtnsPorColuna := (NumeroDeBtns div vgParametrosModulo.ParametrosTotemTouch.ColunasDeBotoes)
    else
      BtnsPorColuna := (NumeroDeBtns div vgParametrosModulo.ParametrosTotemTouch.ColunasDeBotoes) + 1;
    Altura  := (ClientHeight - vgParametrosModulo.ParametrosTotemTouch.BotoesMargemSuperior - vgParametrosModulo.ParametrosTotemTouch.BotoesMargemInferior - (vgParametrosModulo.ParametrosTotemTouch.BotoesEspacoEntreLinhas * (BtnsPorColuna - 1))) div BtnsPorColuna;
    Largura := ((ClientWidth  - vgParametrosModulo.ParametrosTotemTouch.BotoesMargemEsquerda - vgParametrosModulo.ParametrosTotemTouch.BotoesMargemDireita ) div vgParametrosModulo.ParametrosTotemTouch.ColunasDeBotoes) - (vgParametrosModulo.ParametrosTotemTouch.BotoesEspacoEntreColunas div 2);

    for i := 1 to NumeroDeBtns do
    begin
      if ((i-1) mod vgParametrosModulo.ParametrosTotemTouch.ColunasDeBotoes) = 0 then
      begin
        BoundsArray[i].Left   := vgParametrosModulo.ParametrosTotemTouch.BotoesMargemEsquerda;
        BoundsArray[i].Top    := vgParametrosModulo.ParametrosTotemTouch.BotoesMargemSuperior + (((i-1) div vgParametrosModulo.ParametrosTotemTouch.ColunasDeBotoes) * (Altura + vgParametrosModulo.ParametrosTotemTouch.BotoesEspacoEntreLinhas));
        BoundsArray[i].Right  := BoundsArray[1].Left + Largura;
        BoundsArray[i].Bottom := BoundsArray[i].Top  + Altura;
      end
      else
      begin
        BoundsArray[i].Left   := BoundsArray[i-1].Right + vgParametrosModulo.ParametrosTotemTouch.BotoesEspacoEntreColunas;
        BoundsArray[i].Top    := BoundsArray[i-1].Top;
        BoundsArray[i].Right  := BoundsArray[i].Left + Largura;
        BoundsArray[i].Bottom := BoundsArray[i-1].Bottom;
      end;
    end;  { for i }

    BoundAtual := 1;
    for i := 0 to pnlBotoes.ComponentCount - 1 do
    begin
      if (pnlBotoes.Components[i] is TButton) then
      begin
        (pnlBotoes.Components[i] as TControl).Position.X   := BoundsArray[BoundAtual].Left;
        (pnlBotoes.Components[i] as TControl).Position.Y    := BoundsArray[BoundAtual].Top;
        (pnlBotoes.Components[i] as TControl).Width  := BoundsArray[BoundAtual].Right  - BoundsArray[BoundAtual].Left;
        (pnlBotoes.Components[i] as TControl).Height := BoundsArray[BoundAtual].Bottom - BoundsArray[BoundAtual].Top ;

        BoundAtual := BoundAtual + 1;
      end;
    end;
  end;
end;

//========================================================================
// Class procedures

class procedure TFrmTotemTouch.Exibir;
begin
  if FrmTotemTouch = nil then
    FrmTotemTouch := TFrmTotemTouch.Create(GetApplication);

  FrmTotemTouch.CriaBotoes;

  FrmTotemTouch.Show;
end;

class procedure TFrmTotemTouch.CriaBotoes;
var
  FilaNo, FilaCor : Integer;
  FilaNome        : string;
  ShowButton      : Boolean;
  LDMClient       : TDMClient;
begin
  LDMClient := DMClient(0, not CRIAR_SE_NAO_EXISTIR);
  if (LDMClient <> nil) and (FrmTotemTouch <> nil) and (not FrmTotemTouch.BotoesCriados) and (LDMClient.cdsFilas.RecordCount > 0) then
  begin
    with LDMClient.cdsFilas do
    begin
      First;
      while not eof do
      begin
        FilaNo     := FieldByName('Id'  ).AsInteger;
        FilaNome   := FieldByName('Nome').AsString;
        FilaCor    := FieldByName('Cor' ).AsInteger;
        ShowButton := ((ExisteNoIntArray(FilaNo, vgParametrosModulo.MostrarBotaoNasFilas)) and (vgParametrosModulo.ImpressoraComandada >= 0));

        if ShowButton then
          FrmTotemTouch.CriaBotao(FilaNo, FilaNome, TAlphaColor(RGBtoBGR(FilaCor) or $FF000000));

        Next;
      end;
    end;
    FrmTotemTouch.BotoesCriados := true;
  end;
end;


class function TFrmTotemTouch.ImpressoraEstaOnline : boolean;
begin
  Result := (FrmTotemTouch <> nil) and (FrmTotemTouch.ImpressoraOnLine);
end;

end.
