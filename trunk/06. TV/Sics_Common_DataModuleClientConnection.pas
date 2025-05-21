unit Sics_Common_DataModuleClientConnection;

{$INCLUDE ..\AspDefineDiretivas.inc}

{$J+}

interface

uses
  SysUtils, Classes, ScktComp, JvTrayIcon, ASPClientSocket, ExtCtrls,
  Graphics, Forms, IniFiles, Controls, Dialogs,
  Windows, VaClasses, VaComm, MyDlls_DR, MMSystem, JvPanel,
  Sics_Common_Parametros;

const
  cgVERSAOPROTOCOLO = 3;

  cgTipoModulo: TModuloSics = {$IF Defined(CompilarPara_PA)          }
                                msPA
                              {$ELSEIF Defined(CompilarPara_MULTIPA) }
                                msMPA
                              {$ELSEIF Defined(CompilarPara_TGS)     }
                                msTGS
                              {$ELSEIF Defined(CompilarPara_ONLINE)  }
                                msOnLine
                              {$ELSEIF Defined(CompilarPara_SICSTV)  }
                                msTV
                              {$ELSEIF Defined(CompilarPara_CALLCENTER)  }
                                msCallCenter
                              {$ELSEIF Defined(CompilarPara_TOTEMTOUCH)  }
                                msTotemTouch
                              {$ELSE}
                                msNone
                              {$ENDIF};

type
  TConexao = (tcPrincipal, tcContingente);
  TdmSicsClientConnection = class(TDataModule)
    ClientSocketPrincipal: TASPClientSocket;
    ClientSocketContingente: TASPClientSocket;
    ReconnectTimer: TTimer;
    CodeBarPort: TVaComm;
    procedure ClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure ReconnectTimerTimer(Sender: TObject);
    procedure CodeBarPortRxChar(Sender: TObject; Count: Integer);
  private
    { Private declarations }
    lfConexaoServidor : TConexao;
    FIdModulo: Integer;
{$IFDEF CompilarPara_TGS}
    procedure CriaComponenteSocket (Id : Integer; EnderecoIp : String; PortaIP : Integer);
{$ENDIF}

{$IFDEF CompilarPara_TV}
    function  ArrayOfByte_StringToAnsiString (s : string) : AnsiString;
    function  FormatarProtocolo(const aProtocolo: string): String;
    function  EnviaProtocolo(const ASocket: TCustomWinSocket; const s : string): Integer;
{$ENDIF}
  public
    { Public declarations }
    lfAtdsConfigured, lfPAsConfigured, lfFilasConfigured, lfTAGsConfigured,
      lfPPsConfigured, lfMotivosPausaConfigured,
      lfUseCodeBar, lfGruposAtdsConfigured, lfGruposPAsConfigured,
      lfGruposTagsConfigured, lfGruposPPsConfigured, lfGruposMotivosPausaConfigured,
      lfStatusPAsConfigured                                                          : boolean;
      LValorAlertaPI                                                : array of string;
    procedure Redireciona            (IdPA, NF       : integer);
    procedure RedirecionaEProximo    (IdPA, NF       : integer);
    procedure RedirecionaEEspecifica (IdPA, NF, Pswd : integer);
    procedure RedirecionaEForca      (IdPA, NF, Pswd : integer);
    procedure RedirecionaPelaSenha   (      NF, Pswd : integer);
    procedure Proximo                (IdPA           : integer);
    procedure Rechama                (IdPA           : integer);
    procedure Finaliza               (IdPA           : integer);
    procedure ChamaEspecifica        (IdPA, Pswd     : integer);
    procedure ForcaChamada           (IdPA, Pswd     : integer);
    procedure FinalizaPelaSenha      (Pswd           : integer);
    procedure DefinirTag             (PA, Pswd, Tag  : Integer);
    procedure DesassociarTag         (PA, Pswd, Tag  : Integer);
    procedure SolicitarTags          (IdPA           : Integer; Pswd: string);
    procedure DefinirNomeCliente     (PA, Pswd : Integer; Nome : string);
    procedure SolicitarNomeCliente   (PA, Pswd       : integer);

    procedure DecifraProtocolo (s : string; Socket : TCustomWinSocket; IdUnidade : integer);
    procedure DecifraCodeBar   (s : string);

    function  SendCommandToHost (ADR : integer; CMD : byte; PROTDATA : string; IdUnidade : integer; const SinalizarTelaAzul : boolean = true) : boolean;

  end;

var
  dmSicsClientConnection : TdmSicsClientConnection;
  vgParametrosSicsClient: TParametrosSicsClients;
  ClientConectadoDB: Boolean;

implementation

uses
{$IFDEF CompilarPara_PA}
  SicsPA_m,
  Sics_Common_LogoutAtd,
{$ELSE} {$IFDEF CompilarPara_MULTIPA}
  SixMPA_m,
{$ELSE} {$IFDEF CompilarPara_TGS}
  SixTgs_m,
  SixTgs_2,
  Sics_94,
{$ELSE} {$IFDEF CompilarPara_ONLINE}
  SixOnL_m, SixOnL_1,
{$ELSE} {$IFDEF CompilarPara_TV}
  SicsTV_m,SicsTV_2, WinApi.WinSock,
{$ENDIF} {$ENDIF} {$ENDIF} {$ENDIF} {$ENDIF}

{$IFDEF CompilarPara_PA_MULTIPA}
  Sics_Common_EscolheFila,
  Sics_Common_LCDBInput,
  Sics_Common_EscolhePP,
  Sics_Common_EscolheMotivoPausa,
{$ENDIF}

{$IFDEF CompilarPara_TGS_ONLINE}
  Sics_Common_SituationShow,
{$ENDIF}

{$IF Defined(CompilarPara_TGS_ONLINE) or Defined(CompilarPara_TV) }
  Sics_Common_PIShow,
{$IFEND}

{$IFnDEF CompilarPara_TV}
  Sics_Common_DataModuleClientes,
  Sics_Common_LoginAtd,
  Sics_Common_VisualizaManipulaPPs,
  untCommonDMConnection,
{$ENDIF}

  DB, MyAspFuncoesUteis_VCL, untLog, SicsTV_Parametros;

{$R *.dfm}

const
  STX = Chr(02);
  ETX = Chr(03);
  TAB = Chr(09);
  ACK = Chr(06);

{=============================================================================}
{ procedures do form }

function MyConverteStringToASCII (s : string; const ConverterTudo : boolean = true; const Decimal : boolean = false) : string;
var
  i : integer;
begin
  Result := '';

  for i := 1 to length(s) do
  begin
    if (ConverterTudo) or (s[i] < '!') or (s[i] > 'z') then
    begin
      if Decimal then
        Result := Result + '<' + FormatNumber(3, ord(s[i])) + 'd> '
      else
        Result := Result + '<' + IntToHex(ord(s[i]), 2) + '> '
    end
    else
      Result := Result + s[i] + ' ' ;
  end;
end;


procedure TdmSicsClientConnection.DataModuleCreate(Sender: TObject);
var
  ArqIni : TIniFile;
{$IFnDEF CompilarPara_TV}
  frmDataModuleClientes : TfrmSicsCommon_DataModuleClientes;
{$ENDIF}
begin
  ClientConectadoDB := False;

{$IFDEF CompilarPara_MULTIPA}
  ReconnectTimer.Enabled := false; // porque precisa criar todos os componentes do MultiPA para só então começar a pedir os tags (habilita este timer no OnShow do MainForm)
{$ENDIF}

  ArqIni := TIniFile.Create(GetAppIniFileName);
  try
{$IFDEF CompilarPara_TV}
    FIdModulo                       := ArqIni.ReadInteger ('Settings', 'IdModulo'               , 0      );
{$ENDIF CompilarPara_TV}
{$IFDEF CompilarPara_PA_MULTIPA}
    ClientSocketPrincipal.Host      := ArqIni.ReadString  ('Conexoes', 'TCPSrvAdr'              , ''     );
    ClientSocketPrincipal.Port      := ArqIni.ReadInteger ('Conexoes', 'TCPSrvPort'             , 6601   );
    ClientSocketContingente.Host    := ArqIni.ReadString  ('Conexoes', 'TCPSrvAdrContingencia'  , ''     );
    ClientSocketContingente.Port    := ArqIni.ReadInteger ('Conexoes', 'TCPSrvPort'             , 6601   );
{$ELSE}
    ClientSocketPrincipal.Host      := ArqIni.ReadString  ('Conexoes', 'TCPSrvAdr'              , ''     );
    ClientSocketPrincipal.Port      := ArqIni.ReadInteger ('Conexoes', 'TCPSrvPort'             , 6602   );
    ClientSocketContingente.Host    := ArqIni.ReadString  ('Conexoes', 'TCPSrvAdrContingencia'  , ''     );
    ClientSocketContingente.Port    := ArqIni.ReadInteger ('Conexoes', 'TCPSrvPort'             , 6602   );
{$ENDIF}

    lfUseCodeBar                    := ArqIni.ReadBool    ('Settings', 'UseCodeBar'             , false  );
    CodeBarPort.DeviceName          := ArqIni.ReadString  ('Settings', 'CodeBarPort'            , 'com1' );
  finally
    ArqIni.Free;
  end;

  lfAtdsConfigured               := false;
  lfPAsConfigured                := false;
  lfFilasConfigured              := false;
  lfTAGsConfigured               := false;
  lfPPsConfigured                := false;
  lfMotivosPausaConfigured       := false;
  lfStatusPAsConfigured          := false;
  lfGruposAtdsConfigured         := false;
  lfGruposPAsConfigured          := false;
  lfGruposTagsConfigured         := false;
  lfGruposPPsConfigured          := false;
  lfGruposMotivosPausaConfigured := false;

  lfConexaoServidor  := tcContingente;

{$IFDEF CompilarPara_TGS}
  with dmSicsMain.cdsUnidades do
  begin
    First;
    while not eof do
    begin
      CriaComponenteSocket (FieldByName('ID').AsInteger, FieldByName('IP_ENDERECO').AsString, FieldByName('IP_PORTA').AsInteger);

      frmDataModuleClientes := TfrmSicsCommon_DataModuleClientes.Create(Application);
      with frmDataModuleClientes do
      begin
        Name := 'frmSicsCommon_DataModuleClientes' + FieldByName('ID').AsString;
        Tag  := FieldByName('ID').AsInteger;
      end;

      with TfrmSicsLines.Create(Application) do
      begin
        Name := 'frmSicsLines' + FieldByName('ID').AsString;
        Tag  := FieldByName('ID').AsInteger;

        if RecordCount > 1 then
          Caption := Caption + ' - ' + FieldByName('NOME').AsString;
      end;

      with TfrmSicsCommon_MostraSituacaoAtendimento.Create(Application) do
      begin
        Name := 'frmSicsCommon_MostraSituacaoAtendimento' + FieldByName('ID').AsString;
        Tag  := FieldByName('ID').AsInteger;

        if RecordCount > 1 then
          Caption := Caption + ' - ' + FieldByName('NOME').AsString;

        cdsPAsLKUP_PA         .LookupDataSet := frmDataModuleClientes.cdsPAs;
        cdsPAsLKUP_ID_GRUPO   .LookupDataSet := frmDataModuleClientes.cdsPAs;
        cdsPAsLKUP_GRUPO      .LookupDataSet := frmDataModuleClientes.cdsGruposDePAs;
        cdsPAsLKUP_ATD        .LookupDataSet := frmDataModuleClientes.cdsAtendentes;
        cdsPAsLKUP_FILA       .LookupDataSet := frmDataModuleClientes.cdsFilas;
        cdsPAsLKUP_STATUS     .LookupDataSet := frmDataModuleClientes.cdsStatusPAs;
        cdsPAsLKUP_MOTIVOPAUSA.LookupDataSet := frmDataModuleClientes.cdsMotivosPausa;

        cdsAtdsLKUP_ATD        .LookupDataSet := frmDataModuleClientes.cdsAtendentes;
        cdsAtdsLKUP_ID_GRUPO   .LookupDataSet := frmDataModuleClientes.cdsAtendentes;
        cdsAtdsLKUP_GRUPO      .LookupDataSet := frmDataModuleClientes.cdsGruposDeAtendentes;
        cdsAtdsLKUP_PA         .LookupDataSet := frmDataModuleClientes.cdsPAs;
        cdsAtdsLKUP_FILA       .LookupDataSet := frmDataModuleClientes.cdsFilas;
        cdsAtdsLKUP_STATUS     .LookupDataSet := frmDataModuleClientes.cdsStatusPAs;
        cdsAtdsLKUP_MOTIVOPAUSA.LookupDataSet := frmDataModuleClientes.cdsMotivosPausa;

        cdsPAs .CreateDataSet;
        cdsAtds.CreateDataSet;

        cdsPAS .LogChanges := false;
        cdsAtds.LogChanges := false;
      end;

      with TfrmSicsCommom_PIShow.Create(Application) do
      begin
        Name := 'frmSicsCommom_PIShow' + FieldByName('ID').AsString;
        Tag  := FieldByName('ID').AsInteger;

        if RecordCount > 1 then
          Caption := Caption + ' - ' + FieldByName('NOME').AsString;
      end;

      with TfrmSicsCommon_VisualizaManipulaPPs.Create(Application) do
      begin
        Name := 'frmSicsCommon_VisualizaManipulaPPs' + FieldByName('ID').AsString;
        Tag  := FieldByName('ID').AsInteger;

        if RecordCount > 1 then
          Caption := Caption + ' - ' + FieldByName('NOME').AsString;

        cdsPPslkp_TipoPP_Nome.LookupDataSet := frmDataModuleClientes.cdsPPs;
        cdsPPslkp_PA_Nome    .LookupDataSet := frmDataModuleClientes.cdsPAs;
        cdsPPslkp_ATD_Nome   .LookupDataSet := frmDataModuleClientes.cdsAtendentes;

        cdsPPs .CreateDataSet;

        cdsPPS .LogChanges := false;
      end;

      LoadPosition (Application.FindComponent('frmSicsLines'                            + FieldByName('ID').AsString) as TForm);
      LoadPosition (Application.FindComponent('frmSicsCommon_MostraSituacaoAtendimento' + FieldByName('ID').AsString) as TForm);
      LoadPosition (Application.FindComponent('frmSicsCommom_PIShow'                    + FieldByName('ID').AsString) as TForm);
      LoadPosition (Application.FindComponent('frmSicsCommon_VisualizaManipulaPPs'      + FieldByName('ID').AsString) as TForm);

      Next;
    end;
  end;
{$ELSE} {$IFnDEF CompilarPara_TV}
  frmDataModuleClientes := TfrmSicsCommon_DataModuleClientes.Create(Application);
  with frmDataModuleClientes do
  begin
    Name := 'frmSicsCommon_DataModuleClientes' + '0';
    Tag  := 0;
  end;


  with TfrmSicsCommon_VisualizaManipulaPPs.Create(Application) do
  begin
    Name := 'frmSicsCommon_VisualizaManipulaPPs' + '0';
    Tag  := 0;

    cdsPPslkp_TipoPP_Nome.LookupDataSet := frmDataModuleClientes.cdsPPs;
    cdsPPslkp_PA_Nome    .LookupDataSet := frmDataModuleClientes.cdsPAs;
    cdsPPslkp_ATD_Nome   .LookupDataSet := frmDataModuleClientes.cdsAtendentes;

    cdsPPs .CreateDataSet;
    cdsPPS .LogChanges := false;
  end;

  LoadPosition (Application.FindComponent('frmSicsCommon_VisualizaManipulaPPs' + '0') as TForm);
{$ENDIF} {$ENDIF}

{$IFDEF CompilarPara_ONLINE}
  with TfrmSicsCommon_MostraSituacaoAtendimento.Create(Application) do
  begin
    Name := 'frmSicsCommon_MostraSituacaoAtendimento' + '0';
    Tag  := 0;

    cdsPAsLKUP_PA         .LookupDataSet := frmDataModuleClientes.cdsPAs;
    cdsPAsLKUP_ID_GRUPO   .LookupDataSet := frmDataModuleClientes.cdsPAs;
    cdsPAsLKUP_GRUPO      .LookupDataSet := frmDataModuleClientes.cdsGruposDePAs;
    cdsPAsLKUP_ATD        .LookupDataSet := frmDataModuleClientes.cdsAtendentes;
    cdsPAsLKUP_FILA       .LookupDataSet := frmDataModuleClientes.cdsFilas;
    cdsPAsLKUP_STATUS     .LookupDataSet := frmDataModuleClientes.cdsStatusPAs;
    cdsPAsLKUP_MOTIVOPAUSA.LookupDataSet := frmDataModuleClientes.cdsMotivosPausa;

    cdsAtdsLKUP_ATD        .LookupDataSet := frmDataModuleClientes.cdsAtendentes;
    cdsAtdsLKUP_ID_GRUPO   .LookupDataSet := frmDataModuleClientes.cdsAtendentes;
    cdsAtdsLKUP_GRUPO      .LookupDataSet := frmDataModuleClientes.cdsGruposDeAtendentes;
    cdsAtdsLKUP_PA         .LookupDataSet := frmDataModuleClientes.cdsPAs;
    cdsAtdsLKUP_FILA       .LookupDataSet := frmDataModuleClientes.cdsFilas;
    cdsAtdsLKUP_STATUS     .LookupDataSet := frmDataModuleClientes.cdsStatusPAs;
    cdsAtdsLKUP_MOTIVOPAUSA.LookupDataSet := frmDataModuleClientes.cdsMotivosPausa;

    cdsPAs .CreateDataSet;
    cdsAtds.CreateDataSet;

    cdsPAS .LogChanges := false;
    cdsAtds.LogChanges := false;
  end;

  with TfrmSicsCommom_PIShow.Create(Application) do
  begin
    Name := 'frmSicsCommom_PIShow' + '0';
    Tag  := 0;
  end;

   LoadPosition (Application.FindComponent('frmSicsCommon_MostraSituacaoAtendimento' + '0') as TForm);
{$ENDIF}


//  {$IFDEF CompilarPara_TV}
//  IniciarAtualizacao;
//  {$ENDIF}


{$IFDEF CompilarPara_TV}
  with TfrmSicsCommom_PIShow.Create(Application) do
  begin
    Name := 'frmSicsCommom_PIShow' + '0';
    Tag  := 0;
  end;
{$ENDIF}

  if lfUseCodeBar then
  try
    CodeBarPort.Open;
  except
    Application.MessageBox('Erro ao abrir porta serial do leitor de código de barras.', 'Erro', MB_ICONSTOP);
  end;
end;


procedure TdmSicsClientConnection.DataModuleDestroy(Sender: TObject);
var
  ArqIni : TIniFile;
begin
  ArqIni := TIniFile.Create(GetAppIniFileName);
  try
    ArqIni.WriteString  ('Conexoes', 'TCPSrvAdr'              , ClientSocketPrincipal.Host           );
    ArqIni.WriteString  ('Conexoes', 'TCPSrvAdrContingencia'  , ClientSocketContingente.Host         );
    ArqIni.WriteInteger ('Conexoes', 'TCPSrvPort'             , ClientSocketPrincipal.Port           );

    ArqIni.WriteBool    ('Settings', 'UseCodeBar'             , lfUseCodeBar                         );
    ArqIni.WriteString  ('Settings', 'CodeBarPort'            , CodeBarPort.DeviceName               );

    ArqIni.DeleteKey ('Settings', 'TCPSrvAdr'            );
    ArqIni.DeleteKey ('Settings', 'TCPSrvPort'           );
    ArqIni.DeleteKey ('Settings', 'TCPSrvAdrContingencia');
    ArqIni.DeleteKey ('Settings', 'TCPSrvPort'           );
  finally
    ArqIni.Free;
  end;

  ClientSocketPrincipal  .Close;
  ClientSocketContingente.Close;
end;


{$IFDEF CompilarPara_TGS}
procedure TdmSicsClientConnection.CriaComponenteSocket (Id : integer; EnderecoIp : String; PortaIP : Integer);
begin
  with TASPClientSocket.Create(dmSicsClientConnection) do
  begin
    Name       := 'ClientSocketUnidade' + inttostr(ID);
    Tag        := ID;
    Host       := EnderecoIp;
    Port       := PortaIP;
    Active     := False;
    ClientType := ctNonBlocking;

    OnConnect    := ClientSocketConnect;
    OnDisconnect := ClientSocketDisconnect;
    OnRead       := ClientSocketRead;
    OnError      := ClientSocketError;
  end;
end;
{$ENDIF}


procedure TdmSicsClientConnection.ReconnectTimerTimer(Sender: TObject);
{$IFDEF CompilarPara_TGS}
var
  i : integer;
{$ENDIF}
begin
  if ((not ClientSocketPrincipal.Active) and (not ClientSocketContingente.Active)) then
  begin
    frmSicsTVPrincipal.SetDisconnectedMode(0);

    case lfConexaoServidor of
      tcPrincipal   : begin
                        lfConexaoServidor := tcContingente;
                        if (((ClientSocketPrincipal.Address <> '') or (ClientSocketPrincipal.Host <> '')) and (ClientSocketPrincipal.Port <> 0) and (ClientSocketPrincipal.Status = AspClientSocket.ssIdle)) then
                        begin
                           ClientSocketPrincipal.Open;
                           TLog.MyLog('ClientSocketPrincipalConnected', Sender, 0, false, TCriticalLog.tlINFO);
                        end;
                      end;
      tcContingente : begin
                        lfConexaoServidor := tcPrincipal;
                        if (((ClientSocketContingente.Address <> '') or (ClientSocketContingente.Host <> '')) and (ClientSocketContingente.Port <> 0) and (ClientSocketContingente.Status = AspClientSocket.ssIdle)) then
                        begin
                          ClientSocketContingente.Open;
                          TLog.MyLog('ClientSocketContingenteConnected', Sender, 0, false, TCriticalLog.tlINFO);
                        end;
                    end;
    end;
  end;

{$IFDEF CompilarPara_TGS}
  for i := 0 to ComponentCount - 1 do
    if Pos('ClientSocketUnidade', Components[i].Name) = 1 then
      with Components[i] as TASPClientSocket do
      begin
        if (((Address <> '') or (Host <> '')) and (Port <> 0) and (Status = AspClientSocket.ssIdle)) then
          Open;
      end;
{$ENDIF}
end;

{=============================================================================}
{ PROCEDURES PARA ENVIO DO PROTOCOLO TCP/IP PARA O SERVIDOR                   }

function TdmSicsClientConnection.SendCommandToHost (ADR : integer; CMD : byte; PROTDATA : string; IdUnidade : integer; const SinalizarTelaAzul : boolean = true) : boolean;
var
  ClientSocket : TAspClientSocket;
begin
  Result := false;

  if IdUnidade = 0 then
  begin
    if ClientSocketPrincipal.Active then
      ClientSocket := ClientSocketPrincipal
    else
      ClientSocket := ClientSocketContingente;
  end
  else
    ClientSocket := FindComponent('ClientSocketUnidade' + inttostr(IdUnidade)) as TASPClientSocket;

  if ClientSocket.Active then
  begin
    if SinalizarTelaAzul then
      frmSicsTVPrincipal.Color := clBlue;

    ClientSocket.Socket.SendText (STX + IntToHex(cgVERSAOPROTOCOLO, 4) + IntToHex(ADR, 4) + Chr(CMD) + PROTDATA + ETX);
    Application.ProcessMessages;
    TLog.MyLog('Comando: ' + Chr(CMD) + GetDescProtoculo(CMD) + ' | Protocolo: ' + PROTDATA, Self);

    Result := true;
  end  { if algum Socket.Active }
  else
  begin
    ReconnectTimerTimer(ReconnectTimer);

    Delay(500);

    if IdUnidade = 0 then
    begin
      if ClientSocketPrincipal.Active then
        ClientSocket := ClientSocketPrincipal
      else
        ClientSocket := ClientSocketContingente;
    end;

    if not ClientSocket.Active then
    begin
//{$IFnDEF CompilarPara_TGS}                                                            //removido em 02/06/2012, acho que não precisa mais
//      Application.MessageBox('Não está conectado.','Informação',MB_ICONINFORMATION);  //removido em 02/06/2012, acho que não precisa mais
//{$ENDIF}                                                                              //removido em 02/06/2012, acho que não precisa mais
    end
    else
    begin
      if SinalizarTelaAzul then
        frmSicsTVPrincipal.Color := clBlue;

      ClientSocket.Socket.SendText (STX + IntToHex(cgVERSAOPROTOCOLO, 4) + IntToHex(ADR, 4) + Chr(CMD) + PROTDATA + ETX);
      Application.ProcessMessages;
      TLog.MyLog('Comando: ' + Chr(CMD) + GetDescProtoculo(CMD) + ' | Protocolo: ' + PROTDATA, Self);
      Result := true;
    end;  { if algum Socket.Active }
  end;  { else }
end;  { proc SendCommandToHost }


procedure TdmSicsClientConnection.Redireciona (IdPA, NF : integer);
begin
  SendCommandToHost (IdPA, $2E, IntToHex(NF,4), 0);
end;  { proc Redireciona }


procedure TdmSicsClientConnection.RedirecionaPelaSenha (NF, Pswd : integer);
begin
  SendCommandToHost (0, $77, IntToHex(NF,4) + inttostr(Pswd), 0);
end;


procedure TdmSicsClientConnection.RedirecionaEProximo (IdPA, NF : integer);
begin
  SendCommandToHost(IdPA, $2F, IntToHex(NF,4), 0);
end;  { proc RedirecionaEProximo }

procedure TdmSicsClientConnection.RedirecionaEEspecifica (IdPA, NF, Pswd : integer);
begin
  SendCommandToHost(IdPA, $31, IntToHex(NF,4) + inttostr(Pswd), 0);
end;  { proc RedirecionaEEspecifica }


procedure TdmSicsClientConnection.RedirecionaEForca (IdPA, NF, Pswd : integer);
begin
  SendCommandToHost(IdPA, $32, IntToHex(NF,4) + inttostr(Pswd), 0);
end;  { proc RedirecionaEForca }


procedure TdmSicsClientConnection.Proximo (IdPA : integer);
begin
  SendCommandToHost(IdPA, $20, '', 0);
end;  { proc Proximo }


procedure TdmSicsClientConnection.Rechama (IdPA : integer);
begin
  SendCommandToHost(IdPA, $22, '', 0);
end;  { proc Rechama }


procedure TdmSicsClientConnection.Finaliza (IdPA : integer);
begin
  SendCommandToHost(IdPA, $25, '', 0);
end;  { proc Finaliza }


function TdmSicsClientConnection.ArrayOfByte_StringToAnsiString(
  s: string): AnsiString;
var
  i : integer;
begin
  Result := '';
  for i := 1 to length(s) do
  begin
    if Ord(s[i]) <= 255 then
      Result := Result + AnsiChar(Ord(s[i]))
    else
      Result := Result + AnsiString(s[i]);
  end;
end;

procedure TdmSicsClientConnection.ChamaEspecifica(IdPA, Pswd : integer);
begin
  SendCommandToHost(IdPA, $21, inttostr(Pswd), 0);
end;  { proc ChamaEspecifica }


procedure TdmSicsClientConnection.ForcaChamada(IdPA, Pswd : integer);
begin
  SendCommandToHost(IdPA, $30, inttostr(Pswd), 0);
end;

function TdmSicsClientConnection.FormatarProtocolo(const aProtocolo: string): String;
begin
  result := STX + IntToHex(cgVERSAOPROTOCOLO, 4) + aProtocolo + ETX;
end;

{ proc ForcaChamada }

procedure TdmSicsClientConnection.FinalizaPelaSenha (Pswd : integer);
begin
  SendCommandToHost(0, $53, inttostr(Pswd), 0);
end;  { proc ForcaChamada }


procedure TdmSicsClientConnection.DefinirTag(PA: Integer; Pswd, Tag: Integer);
begin
  SendCommandToHost(PA, $7D, IntToHex(Tag,4) + inttostr(Pswd), 0);
end;


procedure TdmSicsClientConnection.DesassociarTag(PA, Pswd, Tag: Integer);
begin
  SendCommandToHost(PA, $83, IntToHex(Tag,4) + inttostr(Pswd), 0);
end;

function TdmSicsClientConnection.EnviaProtocolo(const ASocket: TCustomWinSocket;
  const s: string): Integer;
begin
  Result := SOCKET_ERROR;
  if Assigned(ASocket) and ASocket.Connected then
    Result := ASocket.SendText(ArrayOfByte_StringToAnsiString(FormatarProtocolo(s)));
end;

procedure TdmSicsClientConnection.SolicitarNomeCliente(PA, Pswd: integer);
begin
  SendCommandToHost(PA, $56, IntToStr(Pswd), 0);
end;


procedure TdmSicsClientConnection.DefinirNomeCliente (PA, Pswd : Integer; Nome : string);
begin
  SendCommandToHost(PA, $57, IntToStr(Pswd) + TAB + Nome, 0);
end;


procedure TdmSicsClientConnection.SolicitarTags(IdPA: Integer; Pswd: string);
{$IFDEF CompilarPara_PA_MULTIPA}
var
  frmDataModuleClientes : TfrmSicsCommon_DataModuleClientes;
{$ENDIF}
begin
{$IFDEF CompilarPara_PA_MULTIPA}
  frmDataModuleClientes := (Application.FindComponent('frmSicsCommon_DataModuleClientes' + inttostr(0)) as TfrmSicsCommon_DataModuleClientes);
  if frmDataModuleClientes.cdsGruposDeTags.IsEmpty then
    Exit;

  if frmSicsPrincipal.ValidarPA(IdPA) then
    if (Pswd <> '') and (Pswd <> '---') then
      SendCommandToHost(IdPA, $81, Pswd, 0)
    else
      frmSicsPrincipal.DesligarTags(IdPA);
{$ENDIF}
end;

{=============================================================================}
{ procedures dos sockets }

procedure TdmSicsClientConnection.ClientSocketConnect (Sender: TObject;
                                                       Socket: TCustomWinSocket);
{$IFDEF CompilarPara_TGS_ONLINE}
var
  frmMostraSituacaoAtendimento: TfrmSicsCommon_MostraSituacaoAtendimento;
{$ENDIF}
begin
  if Sender = ClientSocketPrincipal then
  begin
    lfConexaoServidor := tcPrincipal;
    ClientSocketContingente.Close;
    frmSicsTVPrincipal.DisplayMessage('Conectado ao servidor.');
  end
  else if Sender = ClientSocketContingente then
  begin
    lfConexaoServidor := tcContingente;
    ClientSocketPrincipal.Close;
    frmSicsTVPrincipal.DisplayMessage('Conectado ao servidor CONTINGENTE.');
  end;

  frmSicsTVPrincipal.Color := clBtnFace;

  //Obter Update de versão
  SendCommandToHost(0, $0A, 'TV', 0);

  //Obtém Status de Pausas
  {$IFDEF CompilarPara_TGS_ONLINE}
  if not lfStatusPAsConfigured then
  begin
    SendCommandToHost (0, $2A, '', (Sender as TASPClientSocket).Tag);
    Delay(300);
  end;
  {$ENDIF}

  //Solicitar Parametros Modulo SICS
  dmSicsClientConnection.SendCommandToHost (0, $8D, Chr($56) + TAspEncode.AspIntToHex(vgParametrosModulo.IdModulo, 4), 0);
  Delay(500);
  Application.ProcessMessages;

  dmSicsClientConnection.SendCommandToHost (0, $8F, Chr($4E) + TAspEncode.AspIntToHex(vgParametrosModulo.IdModulo, 4), 0);
  Delay(500);
  //InicializarForm;
  Application.ProcessMessages;

  Delay(300);
  Application.ProcessMessages;
  //Obtém Grupos de Atendentes
  SendCommandToHost (0, $78, 'A', (Sender as TASPClientSocket).Tag);
  Delay(300);

  //Obtém Grupos de PAs
  SendCommandToHost (0, $78, 'P', (Sender as TASPClientSocket).Tag);
  Delay(300);

  //Obtém Grupos de TAGs
  if not lfGruposTAGsConfigured then
  begin
    SendCommandToHost (0, $78, 'T', (Sender as TASPClientSocket).Tag);
    Delay(300);
  end;

  {$IFnDEF CompilarPara_TV}
  //Obtém Grupos de PPs
  if vgVisualizarPPs then
  begin
    if not lfGruposPPsConfigured then
    begin
      SendCommandToHost (0, $78, 'p', (Sender as TASPClientSocket).Tag);
      Delay(300);
    end;
  end;

  //Obtém Grupos de Motivos de Pausa
  if vgVisualizarPausa then
  begin
    if not lfGruposMotivosPausaConfigured then
    begin
      SendCommandToHost (0, $78, 'M', (Sender as TASPClientSocket).Tag);
      Delay(300);
    end;
  end;
  {$ENDIF}

  //Obtém Filas
  SendCommandToHost (0, $7B, '', (Sender as TASPClientSocket).Tag);
  Delay(300);

  //Obtem TAGs
  if not lfTAGsConfigured then
  begin
    SendCommandToHost (0, $7F, '', (Sender as TASPClientSocket).Tag);
    Delay(300);
  end;

  {$IFnDEF CompilarPara_TV}
  //Obtem PPs
  if vgVisualizarPPs then
  begin
    if not lfPPsConfigured then
    begin
      SendCommandToHost (0, $3F, '', (Sender as TASPClientSocket).Tag);
      Delay(300);
    end;
  end;

  //Obtem Motivos de Pausa
  if vgVisualizarPausa then
  begin
    if not lfMotivosPausaConfigured then
    begin
      SendCommandToHost (0, $41, '', (Sender as TASPClientSocket).Tag);
      Delay(300);
    end;
  end;

  // ********************************************************************************
  // 07/07/2014 - Tabela de Atendentes e PAs serão carregadas via Query
  // ********************************************************************************
  if ClientConectadoDB then
  begin
    lfAtdsConfigured  := True;
    lfPAsConfigured   := True;
    if Assigned(frmSicsCommon_LoginAtd) then
    begin
      frmSicsCommon_LoginAtd.AtualizaListaDeAtendentes;
      frmSicsCommon_LoginAtd.AtualizaListaDePAs;

      {$IFDEF CompilarPara_TGS_ONLINE}
      frmMostraSituacaoAtendimento := TfrmSicsCommon_MostraSituacaoAtendimento(Application.FindComponent('frmSicsCommon_MostraSituacaoAtendimento' + IntToStr((Sender as TASPClientSocket).Tag)));
      frmMostraSituacaoAtendimento.AtualizaListaDePAs;
      frmMostraSituacaoAtendimento.AtualizaListaDeAtendentes;
      {$ENDIF}
    end;
  end else
  begin
    //*** LBC 27/11/2015 - INVERTI A ORDEM AQUI, PARA SOLUCIONAR PROBLEMA DE RECEBIMENTO DE INFORMAÇÕES NO TGS MULTIUNIDADES (TGS V4.4.G bug #3).
    //*** LBC 27/11/2015 - ANTES ESTAVA SOLICITANDO 1o ATENDENTES DEPOIS PAs. OBSERVAR SE ISTO PODE PREJUDICAR OUTROS MÓDULOS.

    //Obtem PAs
    SendCommandToHost (0, $3D, '', (Sender as TASPClientSocket).Tag);
    Delay(300);

    //Obtem Atendentes
    SendCommandToHost (0, $71, '', (Sender as TASPClientSocket).Tag);
    Delay(300);
  end;
  {$ENDIF}

  //Obtem qtd de senhas em espera
  SendCommandToHost (0, $36, '', (Sender as TASPClientSocket).Tag);
  Delay(300);

  //Obtem situação do atendimento
  SendCommandToHost (0, $29, '', (Sender as TASPClientSocket).Tag);
  Delay(300);

  frmSicsTVPrincipal.SetConnectedMode ((Sender as TClientSocket).Tag);
end;  { proc ClientSocketConnect }


procedure TdmSicsClientConnection.ClientSocketDisconnect (Sender: TObject;
                                                      Socket: TCustomWinSocket);
begin
  frmSicsTVPrincipal.SetDisconnectedMode ((Sender as TClientSocket).Tag);
end;  { proc ClientSocketDisconnect }


procedure TdmSicsClientConnection.ClientSocketError (Sender: TObject;
                                                     Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
                                                     var ErrorCode: Integer);
begin
//  ShowMessage('ClientSocket - erro ' + IntToStr(ErrorCode));
  if ((ErrorCode = 10060) or (ErrorCode = 10061) or (ErrorCode = 10053) or (ErrorCode = 10054)  or (ErrorCode = 10065)) then
  begin
     ErrorCode := 0;
     (Sender as TClientSocket).Close;
     frmSicsTVPrincipal.SetDisconnectedMode ((Sender as TClientSocket).Tag);
  end;
end;  { proc ClientSocket1Error }



procedure TdmSicsClientConnection.ClientSocketRead (Sender: TObject;
                                                    Socket: TCustomWinSocket);
const
  ReceivingProtocol : boolean = false;
  Protocol          : string = '';
var
  i : word;
  s : string;
begin
  try
    s := Socket.ReceiveText;

    for i := 1 to length(s) do
    begin
      if s[i] = STX then
      begin
         ReceivingProtocol := true;
         Protocol := '';
      end
      else if s[i] = ETX then
      begin
         ReceivingProtocol := false;

         Protocol := STX + Protocol + ETX;

         DecifraProtocolo (Protocol, Socket, (Sender as TAspClientSocket).Tag);
         //frmSicsTVPrincipal.DecifraProtocolo (Protocol, Socket);
         frmSicsTVPrincipal.Color := clBtnFace;

         Protocol := '';
      end
      else if ReceivingProtocol then
         Protocol := Protocol + s[i];
    end;  { for }
  except
    on E: Exception do
    begin
      MyLogException(Exception.Create ('Erro ao receber comandos TCP/IP (clientport): "' +
                                        s + '" / Remote: "' + Socket.RemoteAddress + '" / Erro: "' + E.Message + '"'));
    end;
  end;  { try .. except }
end;


//OBS: Para a função abaixo funcionar, necessário que mesmo o 1o bloco seja precedido de TAB.
//     Como não venha assim do servidor, isto deve ser ajustado após o recebimento, em DecifraProtocolo
function AlterouStatusPA (PA : integer; Anterior, Atual : string) : boolean;
var
  BlocoAnterior, BlocoAtual : string;
  i                         : integer;
begin
  try
    BlocoAnterior := '';
    BlocoAtual    := '';

    i := Pos(TAB+IntToHex(PA, 4), Anterior) + 1;
    if i >= 2 then
      while Anterior[i] <> TAB do
      begin
        BlocoAnterior := BlocoAnterior + Anterior[i];
        i := i + 1;
      end;

    i := Pos(TAB+IntToHex(PA, 4), Atual) + 1;
    if i >= 2 then
      while Atual[i] <> TAB do
      begin
        BlocoAtual := BlocoAtual + Atual[i];
        i := i + 1;
      end;

    Result := BlocoAnterior <> BlocoAtual;
  except
    Result := true;
  end;
end;


procedure TdmSicsClientConnection.DecifraProtocolo (s : string; Socket : TCustomWinSocket; IdUnidade : integer);
const
  UltimoProtocolo3C : string = '';
  UltimoProtocolo59 : string = '';

  InicioTagJE  = '{{PI';
  FimTagJE     = '}}';
var
  LPosInicioTAG, LIdModulo    : Integer;
  LPosFimTAG                  : Integer;
  LIdIndicador                : Integer;
  LTagJE, Parametros          : string;
  VersaoProtocolo                                               : integer;
  aux, aux2, aux3                                               : string;
  CMD                                                           : char;
  i,P,A, PA                                                     : integer;
  Nome, Senha, ProtData                                         : string;
  LComponent                                                    : TComponent;
  LEmitirAlertaPI                                               : Boolean;
  LIdAlertaPI                                                   : Integer;
  LFileNameAlertaPI                                             : string;
  TipoModulo                                                    : TModuloSics;
{$IFnDEF CompilarPara_TV}
  frmDataModuleClientes                                         : TfrmSicsCommon_DataModuleClientes;
  frmSicsCommon_VisualizaManipulaPPs                            : TfrmSicsCommon_VisualizaManipulaPPs;
  StatusPA, ATD, Fila, MotivoPausa, Cor, IdEventoPP, IdPP, IdMP : integer;
  aux3, aux4, PSWD, RegistroFuncional, Grupo                    : string;
  TIM                                                           : TDateTime;
{$ENDIF}

{$IFDEF CompilarPara_TGS_ONLINE}
  frmMostraSituacaoAtendimento                                  : TfrmSicsCommon_MostraSituacaoAtendimento;
  IdStatusPA                                                    : integer;
{$ENDIF}

{$IF Defined(CompilarPara_TGS_ONLINE) or Defined(CompilarPara_TV) }
  frmPIs                                                        : TfrmSicsCommom_PIShow;
  PI, NPI, IndexPI                                              : integer;
  Valor                                                         : string;
  EstadoPI                                                      : char;
  TodosPIsOK                                                    : boolean;
  TextoJornalEletronico                                         : string;
{$IFEND}

{$IFDEF CompilarPara_ONLINE}
  IdTag                                                         : integer;
  HoraStr, TagsStr                                              : string;
  y1, m1, d1, h1, n1, s1                                        : word;
  Tags                                                          : TIntArray;
{$ENDIF}
{$IFDEF CompilarPara_PA_MULTIPA}
  IdTag                                                         : integer;
  Tags                                                          : TIntArray;
  NPSWD                                                         : integer;
{$ENDIF}
{$IFDEF CompilarPara_TGS}
  frmLines                                                      : TfrmSicsLines;
  NPSWD                                                         : integer;
  MetaEspera                                                    : TTime;
{$ENDIF}

  procedure ParametrosModuloSICS;
  {$IFDEF CompilarPara_MULTIPA}
  var
    LCodPA : integer;
  {$ENDIF CompilarPara_MULTIPA}
  begin
    case ProtData[1] of
      'P' : TipoModulo := msPA;
      'M' : TipoModulo := msMPA;
      'O' : TipoModulo := msOnLine;
      'T' : TipoModulo := msTGS;
      'V' : TipoModulo := msTV;
      'N' : TipoModulo := msTV;
      'C' : TipoModulo := msCallCenter;
      'H' : TipoModulo := msTotemTouch;
      else raise TAspException.create(Self, 'Tipo módulo não encontrado');
    end;

    LIdModulo := StrToInt('$' + Copy(ProtData, 2, 4));

    Parametros := Copy(ProtData, 6, Length(ProtData));
    if (Length(Parametros) <= 1) then
    begin
      if ProtData[1] = 'V' then
      begin
        ErrorMessage(Format('O ID módulo %d não foi encontrado no servidor.', [FIdModulo]));
        SalvarParametrosTV(True);
      end
      else
        CarregarParametrosINI;

      Application.ProcessMessages;
      Exit;
    end;

    if (TipoModulo = cgTipoModulo) then //and (LIdModulo = FIdModulo)
    begin
      {$IFDEF CompilarPara_PA}
      CarregarParametrosPA;
      if Assigned(dmUnidades.FormClient) then
        dmUnidades.FormClient.CarregarParametrosDB(vgParametrosModulo.IDPA, aIdUnidade);
      {$ENDIF CompilarPara_PA}

      {$IFDEF CompilarPara_MULTIPA}
      CarregarParametrosMultiPA;
      if Assigned(dmUnidades.FormClient) then
      begin
        LDMClient.cdsPAs.First;
        while not LDMClient.cdsPAs.Eof do
        begin
          LCodPA := LDMClient.cdsPAs.FieldByName('ID').AsInteger;
          if (dmUnidades.FormClient.GetPaJaFoiCriada(LCodPA)) then
            dmUnidades.FormClient.CarregarParametrosDB(LCodPA, aIdUnidade);

          LDMClient.cdsPAs.Next
        end;
      end;
      {$ENDIF CompilarPara_MULTIPA}

      {$IFDEF CompilarPara_TGS}
      CarregarParametrosTGS;
      if Assigned(MainForm) then
        MainForm.CarregarParametrosDB;
      {$ENDIF CompilarPara_TGS}

      {$IFDEF CompilarPara_ONLINE}
      CarregarParametrosOnline;
      if Assigned(FrmSicsOnLine) then
      begin
        FrmSicsOnLine.CarregarParametrosDB;
      end;
      {$ENDIF CompilarPara_ONLINE}

      {$IFDEF CompilarPara_CALLCENTER}
      CarregarParametrosCallCenter;
      if Assigned(dmUnidades.FormClient) then
      begin
        dmUnidades.FormClient.NumeroMesa := vgParametrosModulo.NumeroMesa;
        dmUnidades.FormClient.VerificaLoginAutomaticoUsuarioWindows;
      end;
      {$ENDIF}

      {$IFDEF CompilarPara_TOTEMTOUCH}
      if Assigned(dmUnidades.FormClient) then
      begin
        dmUnidades.FormClient.LoadInitialData(Parametros);
      end;
      {$ENDIF}

      {$IFDEF CompilarPara_TV}
      if ProtData[1] = 'V' then
        CarregarParametrosTV(Parametros)
      else
        CarregarParametrosTVPaineis(Parametros);
      {$ENDIF}

      vgParametrosModulo.JaEstaConfigurado := True;
    end
    else
      ErrorMessage('Os parâmetros solicitados diferem dos parâmetros retornados.');
  end;
begin
  try
    if ((s <> '') and (s[1] = STX) and (s[length(s)] = ETX) and (length(s) >= 11)) then
    begin
{$IFnDEF CompilarPara_TV}
      frmDataModuleClientes              := (Application.FindComponent('frmSicsCommon_DataModuleClientes'   + inttostr(IdUnidade)) as TfrmSicsCommon_DataModuleClientes     );
      frmSicsCommon_VisualizaManipulaPPs := (Application.FindComponent('frmSicsCommon_VisualizaManipulaPPs' + inttostr(IdUnidade)) as TfrmSicsCommon_VisualizaManipulaPPs   );

{$ENDIF}
{$IFDEF CompilarPara_TGS_ONLINE}
      frmMostraSituacaoAtendimento := (Application.FindComponent('frmSicsCommon_MostraSituacaoAtendimento' + inttostr(IdUnidade)) as TfrmSicsCommon_MostraSituacaoAtendimento);
{$ENDIF}
{$IFDEF CompilarPara_TGS}
      frmLines                     := (Application.FindComponent('frmSicsLines'                            + inttostr(IdUnidade)) as TfrmSicsLines                           );
{$ENDIF}
{$IF Defined(CompilarPara_TGS_ONLINE) or Defined(CompilarPara_TV) }
      frmPIs                       := (Application.FindComponent('frmSicsCommom_PIShow'                    + inttostr(IdUnidade)) as TfrmSicsCommom_PIShow                   );
{$IFEND}

      VersaoProtocolo := StrToInt('$'+s[2]+s[3]+s[4]+s[5]);
      PA              := StrToInt('$'+s[6]+s[7]+s[8]+s[9]);
      CMD             := s[10];
      ProtData        := Copy(s,11,Length(s)-11);

      if (((VersaoProtocolo <> cgVERSAOPROTOCOLO) and (CMD <> #$0B)) or (CMD = #$0C)) then
      begin
        //AtualizarVersao;  IniciarAtualizacao(aIdUnidade);
        Exit;
      end;

      TLog.MyLog('Comando: ' + CMD + ' | Protocolo: ' + PROTDATA, Self);

      if frmSicsTVPrincipal.ValidarPA (PA) then
      begin
        case CMD of
{$IFDEF CompilarPara_TV}
          Chr($0B): begin
                      vgParametrosSicsClient.ArqUpdateDir := ProtData;
                      frmSicsTVPrincipal.ExecutaAtualizacaoApp;
                    end;
          Chr($B2): // antigo 8D
                begin
                  ParametrosModuloSICS;
                end;
          Chr($23) : begin
                       //frmSicsPrincipal.SetTicketLabel (PA, ProtData);
                       SolicitarTags        (PA, ProtData);
                       SolicitarNomeCliente (PA, strtoint(ProtData));
                     end;  { case 23 }
{$ENDIF}

{$IFDEF CompilarPara_PA_MULTIPA}
          Chr($23) : begin
                       frmSicsPrincipal.SetTicketLabel (PA, ProtData);
                       SolicitarTags        (PA, ProtData);
                       SolicitarNomeCliente (PA, strtoint(ProtData));
                     end;  { case 23 }
          Chr($24) : begin
                       case s[7] of
                         'N' : begin
                                 Application.Restore;
                                 Application.BringToFront;
                                 Senha := Copy(s,8,length(s)-8);
                                 if AppMessageBox('Senha solicitada ('+Senha+') não se encontra em nenhuma fila!'#13'Chamar mesmo assim?', 'Atenção', MB_ICONWARNING OR MB_YESNO) = idyes then
                                 begin
                                   if ((not gfManualRedirect) or (frmSicsPrincipal.GetTicketLabel(PA) = '---') or (frmSicsCommon_EscolheFila.listFilas.ItemIndex = 0)) then
                                     ForcaChamada(PA, strtoint(Senha))
                                   else
                                     RedirecionaEForca(PA,strtoint(frmSicsCommon_EscolheFila.listFilas.Items[frmSicsCommon_EscolheFila.listFilas.ItemIndex].Caption), strtoint(Senha))
                                 end
                                 else
                                 begin
                                   Application.MessageBox ('Operação abortada.', 'Informação', MB_ICONINFORMATION);
                                   frmSicsPrincipal.BackToProximo(PA);
                                 end;
                               end;  { case 00 }
                         'P' : begin
                                 Application.Restore;
                                 Application.BringToFront;
                                 Senha := Copy(s,8,length(s)-8);
                                 if AppMessageBox('Senha solicitada ('+Senha+') se encontra em uma fila que não deveria ser atendida por este atendente!'#13'Chamar mesmo assim?', 'Atenção', MB_ICONWARNING OR MB_YESNO) = idyes then
                                 begin
                                   if ((not gfManualRedirect) or (frmSicsPrincipal.GetTicketLabel(PA) = '---') or (frmSicsCommon_EscolheFila.listFilas.ItemIndex = 0)) then
                                     ForcaChamada(PA, strtoint(Senha))
                                   else
                                     RedirecionaEForca(PA,strtoint(frmSicsCommon_EscolheFila.listFilas.Items[frmSicsCommon_EscolheFila.listFilas.ItemIndex].Caption), strtoint(Senha))
                                 end
                                 else
                                 begin
                                   Application.MessageBox ('Operação abortada.', 'Informação', MB_ICONINFORMATION);
                                   frmSicsPrincipal.BackToProximo (PA);
                                 end;
                               end;  { case 00 }
                         'L' : begin
                                 Application.Restore;
                                 Application.BringToFront;
                                 Application.MessageBox('Não há atendente logado nesta PA. Por favor faça login.', 'Erro', MB_ICONERROR);
                                 frmSicsPrincipal.BackToProximo (PA);
                               end;
                         'I' : begin
                                 Application.Restore;
                                 Application.BringToFront;
                                 Application.MessageBox('Senha inválida.', 'Erro', MB_ICONERROR);
                                 frmSicsPrincipal.BackToProximo (PA);
                               end;
                         else begin
                                frmSicsPrincipal.SetTicketLabel(PA, '---');
                                frmSicsPrincipal.BackToProximo (PA);
                              end;  { case 00 }
                       end;  { case Ord(s[7]) }
                     end;  { case Chr(24) }
{$ENDIF}
{$IFDEF CompilarPara_TGS}
          Chr($26) : dmSicsMain.CarregaTabelasPAsEFilas;
{$ENDIF}
{$IFDEF CompilarPara_TGS_ONLINE}
          Chr($2D) : begin
                       frmDataModuleClientes.cdsStatusPAs.EmptyDataSet;

                       aux := ProtData;
                       aux := Copy(aux,5,Length(aux)-4);
                       aux2 := '';
                       for i := 1 to length (aux) do
                       begin
                         if aux[i] = TAB then
                         begin
                           IdStatusPA := strtoint('$' + Copy(aux2,1,4));
                           Nome       := Copy (aux2, 5, length(aux2)-4);

                           frmDataModuleClientes.InsertStatusPA (IdStatusPA, Nome);

                           aux2 := '';
                         end
                         else if aux[i] <> ETX then
                           aux2 := aux2 + aux[i];
                       end;

                       frmMostraSituacaoAtendimento.AtualizaLookUps;
//LBC 26/11/15 Removido para seguir recebendo quando for TGS MultiUnidades                       lfStatusPAsConfigured := true;
                     end;  // case $2D
{$ENDIF}
          Chr($33) : begin
                       Application.MessageBox('Comando não suportado pelo servidor.', 'Erro', MB_ICONSTOP);
                     end;  { case $33 }
{$IFDEF CompilarPara_TGS}
          Chr($35) : begin
                       aux := ProtData;
//                       NF := StrToInt('$'+aux[1]+aux[2]+aux[3]+aux[4]);
                       aux := Copy(aux,5,Length(aux)-4);
                       aux2 := '';
                       for i := 1 to length (aux) do
                       begin
                         if aux[i] = TAB then
                         begin
                           Fila  := StrToInt('$'+aux2[1]+aux2[2]+aux2[3]+aux2[4]);
                           NPSWD := StrToInt('$'+aux2[5]+aux2[6]+aux2[7]+aux2[8]);
                           try
                             TIM := EncodeDate(strtoint(aux2[13]+aux2[14]+aux2[15]+aux2[16]),strtoint(aux2[11]+aux2[12]),strtoint(aux2[9]+aux2[10])) +
                                    EncodeTime(strtoint(aux2[17]+aux2[18]),strtoint(aux2[19]+aux2[20]),strtoint(aux2[21]+aux2[22]),0);
                           except
                             TIM := EncodeDate(1,1,1) + EncodeTime(1,1,1,1);
                           end;  { try .. except }
                           frmLines.UpdateSituation(Fila,NPSWD,TIM);
                           aux2 := '';
                         end
                         else if aux[i] <> ETX then
                           aux2 := aux2 + aux[i];
                       end;
                       if aux2 <> '' then
                         Application.MessageBox ('Texto maior do que deveria.', 'Informação', MB_ICONWARNING);
                     end;  { case Chr($16) }
{$ENDIF}
{$IFDEF CompilarPara_ONLINE}
{$ENDIF}
{$IFDEF CompilarPara_PA_MULTIPA}
          Chr($3B) : begin
                       aux := Copy (s, 7, length(s)-6);
                       aux := Copy (aux,5,Length(aux)-4);
                       aux2 := '';
                       for i := 1 to length (aux) do
                       begin
                         if aux[i] = TAB then
                         begin
                           PA    := StrToInt('$'+Copy(aux2,1,4));
                           NPSWD := StrToInt('$'+Copy(aux2,5,4));
                           aux2 := '';
                           frmSicsPrincipal.SetQueueLabel(PA, NPSWD);
{$IFDEF CompilarPara_PA}
                           if PA = vlCurrentPA then
                             break;
{$ENDIF}
                         end
                         else if aux[i] <> ETX then
                           aux2 := aux2 + aux[i];
                       end;
                       if aux2 <> '' then
                         Application.MessageBox ('Texto maior do que o esperado.', 'Info - Senhas em espera', MB_ICONWARNING);
                     end;
{$ENDIF}
{$IFnDEF CompilarPara_TV}
          Chr($3C) : begin
                       if lfPAsConfigured then
                       begin
                         aux := ProtData;
                         aux := TAB + Copy(aux,5,Length(aux)-4);  //COLOCADO ESTE TAB PARA FUNCIONAR A "AlterouStatusPA"
  {$IFDEF CompilarPara_TGS_ONLINE}
                         if aux <> UltimoProtocolo3C then
  {$ENDIF}  //No OnLine e TGS, para otimizar processamento
                         begin
                           aux2 := '';
                           for i := 2 to length (aux) do  // COMEÇAR DE 2 PARA CORTAR O TAB COLOCADO ACIMA
                           begin
                             if aux[i] = TAB then
                             begin
                               PA   := StrToInt('$'+Copy(aux2,1,4));
                               if frmDataModuleClientes.IsAllowedPA(PA) then
                               begin
  {$IFDEF CompilarPara_TGS_ONLINE}
                                 if AlterouStatusPA (PA, UltimoProtocolo3C, aux) then
  {$ENDIF}  //No OnLine e TGS, para otimizar processamento
//			<DATA> = <NPA> <PA1> <TIME1> <STAT1> <ATD1> <FILA1> <MP1> <PWD1> <PV> <NOME1> <TAB> ... <PAn> <TIMEn> <STATn> <ATDn> <FILAn> <MPn> <PWDn> <PV> <NOMEn> <TAB>
// 1234567 101234567 201234567 301234567 401234567 50
// PA--ddmmyyyyhhnnssATD-FILAPWD;NOME

// PA--ddmmyyyyhhnnssSTATATD-FILAMP--PWD;NOME
                                 begin
                                   if Copy(aux2,19,4) = '----' then
                                     StatusPA := -1
                                   else
                                     StatusPA := StrToInt('$'+Copy(aux2,19,4));
                                   if Copy(aux2,23,4) = '----' then
                                     ATD := -1
                                   else
                                     ATD := StrToInt('$'+Copy(aux2,23,4));
                                   if Copy(aux2,31,4) = '----' then
                                     MotivoPausa := -1
                                   else
                                     MotivoPausa := StrToInt('$'+Copy(aux2,31,4));
                                   PSWD := Copy(aux2, 35, Pos (';', aux2) - 35);
                                   Nome := Copy(aux2, Pos (';', aux2) + 1, length(aux2) - Pos (';', aux2));
  {$IFDEF CompilarPara_PA_MULTIPA}
                                   frmSicsPrincipal.UpdateAtdStatus (PA, StatusPA, MotivoPausa, ATD, PSWD, Nome);
                                   SolicitarTags(PA, PSWD);
  {$ELSE} {$IFDEF CompilarPara_TGS_ONLINE}
                                   if Copy(aux2,27,4) = '----' then
                                     Fila := -1
                                   else
                                     Fila := StrToInt('$'+Copy(aux2,27,4));
                                   TIM := EncodeDate(strtoint(aux2[9]+aux2[10]+aux2[11]+aux2[12]),strtoint(aux2[7]+aux2[8]),strtoint(aux2[5]+aux2[6])) +
                                          EncodeTime(strtoint(aux2[13]+aux2[14]),strtoint(aux2[15]+aux2[16]),strtoint(aux2[17]+aux2[18]),0);
                                   frmMostraSituacaoAtendimento.UpdatePASituation(PA, StatusPA, ATD, PSWD, Fila, MotivoPausa, TIM, Nome);
  {$ENDIF} {$ENDIF}
                                 end;
                               end;
                               aux2 := '';
                             end
                             else if aux[i] <> ETX then
                               aux2 := aux2 + aux[i];
                           end;
                           if aux2 <> '' then
                             Application.MessageBox ('Texto maior do que o esperado.', 'Info - Senhas em espera', MB_ICONWARNING);

                           UltimoProtocolo3C := aux;
                         end;  { if aux <> UltimoProtocolo3C }
                       end;  { if lfPAsConfigured }
                     end;  { case $3C }
          Chr($3E) : begin
                       frmDataModuleClientes.cdsPAs.EmptyDataSet;

                       aux := Copy (s, 7, length(s)-6);
                       { NATD := StrToInt('$'+aux[1]+aux[2]+aux[3]+aux[4]); }
                       aux := Copy(aux,5,Length(aux)-4);
                       aux2 := '';
                       for i := 1 to length (aux) do
                       begin
                         if aux[i] = TAB then
                         begin
                           PA   := StrToInt('$'+Copy(aux2,1,4));
                           aux2 := Copy (aux2, 5, length(aux2)-4);
                           SeparaStrings(aux2, ';', Nome , Grupo );

                           if Grupo = '' then
                             frmDataModuleClientes.InsertPA (PA, Nome, -1)
                           else
                             frmDataModuleClientes.InsertPA (PA, Nome, strtoint(Grupo));

                           aux2 := '';
                         end
                         else if aux[i] <> ETX then
                           aux2 := aux2 + aux[i];
                       end;

                       frmSicsCommon_VisualizaManipulaPPs.AtualizaLookUps;

  {$IFDEF CompilarPara_PA_MULTIPA}
                       frmSicsCommon_LoginAtd.AtualizaListaDePAs;
  {$ELSE} {$IFDEF CompilarPara_TGS_ONLINE}
                       frmMostraSituacaoAtendimento.AtualizaListaDePAs;
  {$ENDIF} {$ENDIF}

                       lfPAsConfigured := true;

// ********************************************************************************
// 07/07/2014 - Tabela de Atendentes e PAs serão carregadas via Query
// LBC 27/11/2015 - VERIFICAR SE PODE TIRAR MESMO
// ********************************************************************************
//                       SendCommandToHost(0, $29, '', IdUnidade);


//VERIFICAR SE PODE TIRAR (UNICO AFETADO = MODULO PA)                       frmSicsPrincipal.UpdatePAStatus;

                       if aux2 <> '' then
                         AppMessageBox ('Texto maior do que o esperado. Caso $' + inttostr(Ord(s[4])), 'Informação', MB_ICONWARNING);
                     end;

          Chr($40) : begin
                       frmDataModuleClientes.cdsPPs.EmptyDataSet;

  {$IFDEF CompilarPara_PA_MULTIPA}
                       frmSicsCommon_EscolhePP.listPPs.Clear;
  {$ENDIF}

                       aux := ProtData;
                       aux := Copy(aux,5,Length(aux)-4);
                       aux2 := '';
                       for i := 1 to length (aux) do
                       begin
                         if aux[i] = TAB then
                         begin
                           IdPP := StrToInt('$'+Copy(aux2,1,4));
                           Cor  := StrToInt('$'+Copy(aux2,5,6));
                           aux2 := Copy(aux2, 11, length(aux2)-10);
                           SeparaStrings(aux2, ';', Grupo, Nome);

                           if Grupo = '' then
                             Grupo := '-1';

                           if frmDataModuleClientes.IsAllowedGrupoPP(strtoint(Grupo)) then
                           begin
                             frmDataModuleClientes.InsertPP (IdPP, Nome, strtoint(Grupo), Cor);
                             {$IFDEF CompilarPara_PA_MULTIPA}
                               frmSicsCommon_EscolhePP.InsertPP (IdPP, Nome);
                             {$ENDIF}
                           end;

                           aux2 := '';
                         end
                         else if aux[i] <> ETX then
                           aux2 := aux2 + aux[i];
                       end;

                       frmSicsCommon_VisualizaManipulaPPs.AtualizaLookUps;

                       lfPPsConfigured := true;
                     end;  // case $40

          Chr($42) : begin
                       frmDataModuleClientes.cdsMotivosPausa.EmptyDataSet;

  {$IFDEF CompilarPara_PA_MULTIPA}
                       frmSicsCommon_EscolheMotivoPausa.listMotivosPausa.Clear;
  {$ENDIF}

                       aux := ProtData;
                       aux := Copy(aux,5,Length(aux)-4);
                       aux2 := '';
                       for i := 1 to length (aux) do
                       begin
                         if aux[i] = TAB then
                         begin
                           IdMP := StrToInt('$'+Copy(aux2,1,4));
                           Cor  := StrToInt('$'+Copy(aux2,5,6));
                           aux2 := Copy(aux2, 11, length(aux2)-10);
                           SeparaStrings(aux2, ';', Grupo, Nome);

                           if Grupo = '' then
                             Grupo := '-1';

                           if frmDataModuleClientes.IsAllowedMotivoPausa(strtoint(Grupo)) then
                           begin
                             frmDataModuleClientes.InsertMotivoPausa (IdMP, Nome, strtoint(Grupo), Cor);
                             {$IFDEF CompilarPara_PA_MULTIPA}
                               frmSicsCommon_EscolheMotivoPausa.InsertMotivoPausa (IdMP, Nome);
                             {$ENDIF}
                           end;

                           aux2 := '';
                         end
                         else if aux[i] <> ETX then
                           aux2 := aux2 + aux[i];
                       end;

                       {$IFDEF CompilarPara_TGS_ONLINE}
                         frmMostraSituacaoAtendimento.AtualizaLookUps;
                       {$ENDIF}

                       lfMotivosPausaConfigured := true;
                     end;  // case $42
{$ENDIF}

{$IFDEF CompilarPara_PA_MULTIPA}
          Chr($50) : begin
                       Application.Restore;
                       Application.BringToFront;
                       Senha := ProtData;
                       if AppMessageBox('Senha solicitada ('+Senha+') não se encontra em nenhuma fila!'#13'Chamar mesmo assim?', 'Atenção', MB_ICONWARNING OR MB_YESNO) = idyes then
                       begin
                         if ((not gfManualRedirect) or (frmSicsPrincipal.GetTicketLabel(PA) = '---') or (frmSicsCommon_EscolheFila.listFilas.ItemIndex = 0)) then
                             ForcaChamada(PA, strtoint(Senha))
                         else
                             RedirecionaEForca(PA,strtoint(frmSicsCommon_EscolheFila.listFilas.Items[frmSicsCommon_EscolheFila.listFilas.ItemIndex].Caption), strtoint(Senha))
                       end
                       else
                         Application.MessageBox ('Operação abortada.', 'Informação', MB_ICONINFORMATION);
                     end;  { case 50h }
          Chr($51) : begin
                       Application.Restore;
                       Application.BringToFront;
                       Senha := ProtData;
                       if AppMessageBox('Senha solicitada ('+Senha+') se encontra em uma fila que não deveria ser atendida por este atendente!'#13'Chamar mesmo assim?', 'Atenção', MB_ICONWARNING OR MB_YESNO) = idyes then
                       begin
                         if ((not gfManualRedirect) or (frmSicsPrincipal.GetTicketLabel(PA) = '---') or (frmSicsCommon_EscolheFila.listFilas.ItemIndex = 0)) then
                           ForcaChamada(PA, strtoint(Senha))
                         else
                           RedirecionaEForca(PA,strtoint(frmSicsCommon_EscolheFila.listFilas.Items[frmSicsCommon_EscolheFila.listFilas.ItemIndex].Caption), strtoint(Senha))
                       end
                       else
                         Application.MessageBox ('Operação abortada.', 'Informação', MB_ICONINFORMATION);
                     end;  { case 51h }
{$ENDIF}
          Chr($57) : begin
                       SeparaStrings(ProtData, TAB, Senha, aux);
                       frmSicsTVPrincipal.DefinirNomeParaSenha(IdUnidade, strtoint(Senha), aux);
                     end;
{$IFnDEF CompilarPara_TV}
          Chr($59) : begin
                       aux := ProtData;
  {$IFDEF CompilarPara_TGS_ONLINE}
                       if aux <> UltimoProtocolo59 then
  {$ENDIF}  //No OnLine e TGS, para otimizar processamento
                       begin
                         frmSicsCommon_VisualizaManipulaPPs.IniciarAtualizacao;

                         aux2 := '';
                         for i := 1 to length (aux) do
                         begin
                           if aux[i] = TAB then
                           begin
                             SeparaStrings(aux2, ';', aux3, aux4);

                             IdEventoPP := strtoint(aux3);

                             SeparaStrings(aux4, ';', aux3, aux4);

                             IdPP := strtoint('$' + Copy(aux3, 1, 4));

                             if Copy(aux3,5,4) = '----' then
                               PA := -1
                             else
                               PA := StrToInt('$'+Copy(aux3,5,4));

                             if Copy(aux3,9,4) = '----' then
                               ATD := -1
                             else
                               ATD := StrToInt('$'+Copy(aux3,9,4));

                             TIM        := EncodeDate(strtoint(aux3[17]+aux3[18]+aux3[19]+aux3[20]),strtoint(aux3[15]+aux3[16]),strtoint(aux3[13]+aux3[14])) +
                                           EncodeTime(strtoint(aux3[21]+aux3[22]),strtoint(aux3[23]+aux3[24]),strtoint(aux3[25]+aux3[26]),0);

                             PSWD       := Copy(aux3, 27, length(aux3) - 26);

                             Nome       := aux4;

                             if frmDataModuleClientes.IsAllowedPP(IdPP) then
                               frmSicsCommon_VisualizaManipulaPPs.UpdatePPSituation(IdEventoPP, IdPP, PA, ATD, strtoint(PSWD), Nome, TIM);

                             aux2 := '';
                           end
                           else if aux[i] <> ETX then
                             aux2 := aux2 + aux[i];
                         end;
                         if aux2 <> '' then
                           Application.MessageBox ('Texto maior do que o esperado.', 'Info - Senhas em espera', MB_ICONWARNING);

                         UltimoProtocolo59 := aux;

                         frmSicsCommon_VisualizaManipulaPPs.ConcluirAtualizacao;
                       end;  { if aux <> UltimoProtocolo59 }
                     end;  // case 59
{$ENDIF}

{$IF Defined(CompilarPara_TGS_ONLINE) or Defined(CompilarPara_TV) }
          Chr($65) : begin
                       aux := ProtData;
                       {IdModulo := StrToInt('$'+aux[1]+aux[2]+aux[3]+aux[4]);}
                       {NPI := StrToInt('$'+aux[5]+aux[6]+aux[7]+aux[8]);}
                       aux := Copy (aux,9,Length(aux)-8);
                       aux2 := '';
                       for i := 1 to length (aux) do
                       begin
                         if aux[i] = TAB then
                         begin
                           PI   := StrToInt('$'+aux2[1]+aux2[2]+aux2[3]+aux2[4]);
                           Nome := Copy(aux2, 5, length(aux2)-4);
                           if frmPIs.IsAllowedPI (PI) then
                             frmPIs.AssociaNomePI (PI, Nome);
                           aux2 := '';
                         end
                         else if aux[i] <> ETX then
                           aux2 := aux2 + aux[i];
                       end;
                       if aux2 <> '' then
                         AppMessageBox ('Texto maior do que o esperado. Caso $' + inttostr(Ord(s[4])), 'Informação', MB_ICONWARNING);
                     end;  { case Chr($65) }
          Chr($67), Chr($2B) :
                     begin
                       TextoJornalEletronico := frmSicsTVPrincipal.TextoOriginalJornalEletronico;
                       aux := ProtData;
                       NPI := StrToInt('$'+aux[1]+aux[2]+aux[3]+aux[4]);
                       if NPI = 0 then
                         ClearTitledStringGrid(frmPIs.sgPIs)
                       else
                       begin
                         aux := Copy (aux,5,Length(aux)-4);
                         aux2 := '';
                         IndexPI := 1;
                         TodosPIsOK := true;
                         for i := 1 to length (aux) do
                         begin
                           if aux[i] = TAB then
                           begin
                             PI       := StrToInt('$'+aux2[1]+aux2[2]+aux2[3]+aux2[4]);
                             EstadoPI := aux2[5];
                             Valor    := Copy(aux2, 6, length(aux2)-5);
                             SeparaStrings (Valor, ';', Valor, aux3);  //aux3, no SicsTV, é "lixo" pois o valor numerico e tipo não precisa para nada no SicsTV

                             {$IFDEF CompilarPara_TV}
                             //********************************************************************
                             // Início do "alerta" de indicador de performance | GOT 12.02.2016
                             //********************************************************************
                             for P := 0 to Pred(frmSicsTVPrincipal.ComponentCount) do
                             begin
                               LComponent := frmSicsTVPrincipal.Components[P];
                               if (LComponent is TJvPanel) and ((LComponent as TJvPanel).Hint = IntToStr(ord(tpIndicadorPerformance))) then
                               begin
                                 frmSicsTVPrincipal.GetPanelProperties(LComponent as TJvPanel);
                                 LIdAlertaPI        := StrToIntDef(frmSicsProperties.edtIndicador.Text,-1);
                                 LFileNameAlertaPI  := frmSicsProperties.edtSomPI.Text;

                                 if LIdAlertaPI = PI then
                                 begin
                                   if Length(LValorAlertaPI) < PI+1 then
                                     SetLength(LValorAlertaPI,PI+1);


                                   LEmitirAlertaPI    := StrToIntDef(Valor,0) > StrToIntDef(LValorAlertaPI[PI],0);
                                   LValorAlertaPI[PI] := Valor;

                                   if LEmitirAlertaPI and (LFileNameAlertaPI <> '') then
                                     sndPlaySound(PChar(LFileNameAlertaPI), SND_ASYNC);
                                 end;
                               end;
                             end;
                             //********************************************************************
                             // Fim do "alerta" de indicador de performance | GOT 12.02.2016
                             //********************************************************************


                             //****************************************************************************************************
                             // Início do indicador de performance no jornal eletrônico | GOT 31.03.2016 | Corrigido LBC 08.07.2016
                             //****************************************************************************************************
                             LPosInicioTAG := Pos(InicioTagJE,TextoJornalEletronico);

                             if LPosInicioTAG > 0 then
                             begin
                               LPosInicioTAG := LPosInicioTAG + Length(InicioTagJE);
                               LPosFimTAG    := Pos(FimTagJE,TextoJornalEletronico) - LPosInicioTAG;

                               LIdIndicador  := StrToIntDef(Copy(TextoJornalEletronico,LPosInicioTAG,LPosFimTAG),0);

                               if LIdIndicador = PI then
                               begin
                                 LTagJE:= InicioTagJE + IntToStr(LIdIndicador) + FimTagJE;
                                 TextoJornalEletronico := StringReplace(TextoJornalEletronico,LTagJE,Valor,[rfReplaceAll]);
                               end;
                             end;
                             //*************************************************************************************************
                             // Fim do indicador de performance no jornal eletrônico | GOT 31.03.2016 | Corrigido LBC 08.07.2016
                             //*************************************************************************************************


                             {$ENDIF}
                             if frmPIs.IsAllowedPI (PI) then
                             begin
                               TodosPIsOK := (frmPIs.AtualizaStatusPI(NPI, IndexPI, PI, EstadoPI, Valor) and TodosPISOK);
                               IndexPI := IndexPI + 1;
                             end;
                             aux2 := '';
                           end
                           else if aux[i] <> ETX then
                             aux2 := aux2 + aux[i];
                         end;
                         if aux2 <> '' then
                           AppMessageBox ('Texto maior do que o esperado. Caso $' + inttostr(Ord(s[4])), 'Informação', MB_ICONWARNING);

                         if not TodosPIsOK then
                           SendCommandToHost($FFFF, $64, '', IdUnidade)
{$IFDEF CompilarPara_TV}
                         else
                           frmSicsTVPrincipal.AtualizaPanelsIndicadoresDesempenho;

                         if frmSicsTVPrincipal.vgJornalEletronico <> nil then
                         begin
                          frmSicsTVPrincipal.vgJornalEletronico.Active := False;
                          if frmSicsTVPrincipal.vgJornalEletronico.Items.Count = 0 then
                            frmSicsTVPrincipal.vgJornalEletronico.Items.Add;
                          frmSicsTVPrincipal.vgJornalEletronico.Items[0].Text := TextoJornalEletronico;
                          frmSicsTVPrincipal.vgJornalEletronico.Active := True;
                         end;
{$ENDIF}
                       end;  { else }
                     end;  { case Chr($67) }
{$IFEND}
{$IFDEF CompilarPara_ONLINE}
          Chr($6D) : begin
                       Fila := StrToInt('$'+Copy(ProtData,1,4));
                       if frmSicsPrincipal.ExisteAFila(Fila) then
                       begin
                         frmSicsPrincipal.LimpaFila(Fila);

                         aux  := Copy(s, 11, length(s)-10);
                         aux2 := '';
                         d1   := 0;
                         m1   := 0;
                         y1   := 0;
                         h1   := 0;
                         n1   := 0;
                         s1   := 0;
                         for i := 1 to length (aux) do
                         begin
                           if aux[i] = ';' then
                           begin
                             SeparaStrings(aux2, TAB, Senha  , aux2);
                             SeparaStrings(aux2, TAB, Nome   , aux2);
                             SeparaStrings(aux2, TAB, TagsStr, aux2);
                             HoraStr := aux2;

                             if Pos(',', Senha) > 0 then
                               Senha := Copy(Senha, 1, Pos(',', Senha) - 1);

//LBC 07/02/13                             Senha   := Copy(aux2, 1, Pos(',', aux2) - 1);
//LBC 07/02/13                             Nome    := Copy(aux2, Pos(',', aux2) + 1, Pos(TAB, aux2) - Pos(',', aux2) - 1);
//LBC 07/02/13                             HoraStr := Copy(aux2, Pos(TAB, aux2) + 1, length(aux2) - Pos(TAB, aux2));

                             if Length(HoraStr) >= 2 then
                               s1 := StrToInt(HoraStr[1]  + HoraStr[2] );
                             if Length(HoraStr) >= 4 then
                               n1 := StrToInt(HoraStr[3]  + HoraStr[4] );
                             if Length(HoraStr) >= 6 then
                               h1 := StrToInt(HoraStr[5]  + HoraStr[6] );
                             if Length(HoraStr) >= 8 then
                               d1 := StrToInt(HoraStr[7]  + HoraStr[8]);
                             if Length(HoraStr) >= 10 then
                               m1 := StrToInt(HoraStr[9]  + HoraStr[10]);
                             if Length(HoraStr) >= 14 then
                               y1 := StrToInt(HoraStr[11] + HoraStr[12] + HoraStr[13] + HoraStr[14]);

                             TIM := EncodeDate(y1, m1, d1) + EncodeTime(h1, n1, s1, 0);

                             StrToIntArray(TagsStr, Tags);

                             frmSicsPrincipal.InsertPswd(Fila, StrToInt(Senha), Nome, TIM, Tags, -2);

                             Finalize(Tags);  //LBC 07/02/13  VERIFICAR SE É NECESSÁRIO E SE NÃO DÁ PAU ASSIM
                             aux2 := '';
                           end
                           else if aux[i] <> #3 then
                             aux2 := aux2 + aux[i];
                         end;
                       end;
                     end;
          Chr($6F) : begin
                       aux  := ProtData;
                       aux2 := '';
                       for i := 1 to length (aux) do
                       begin
                         if aux[i] = TAB then
                         begin
                           Fila := StrToInt('$'+Copy(aux2,1,4));
                           if frmSicsPrincipal.ExisteAFila(Fila) then
                           begin
                             frmSicsPrincipal.SetListBlocked   (Fila, (aux2[5] = '1'));
                             frmSicsPrincipal.SetPrioritaryList(Fila, (aux2[6] = '1'));
                           end;

                           aux2 := '';
                         end
                         else if aux[i] <> #3 then
                           aux2 := aux2 + aux[i];
                       end;
                     end;
{$ENDIF}
{$IFnDEF CompilarPara_TV}
          Chr($72) : begin
                       frmDataModuleClientes.cdsAtendentes.EmptyDataSet;

                       aux := ProtData;
                       { NATD := StrToInt('$'+aux[1]+aux[2]+aux[3]+aux[4]); }
                       aux := Copy(aux,5,Length(aux)-4);
                       aux2 := '';
                       for i := 1 to length (aux) do
                       begin
                         if aux[i] = TAB then
                         begin
                           ATD  := StrToInt('$'+Copy(aux2,1,4));
                           aux2 := Copy (aux2, 5, length(aux2)-4);
                           SeparaStrings(aux2, ';', Nome              , aux2 );
                           SeparaStrings(aux2, ';', RegistroFuncional , aux2 );
                           SeparaStrings(aux2, ';', Grupo             , Senha);
                           if Grupo = '' then
                             Grupo := '-1';

                          //GOT 06.04.2016
                          //Senha := DecriptLegivel(Senha);

                           frmDataModuleClientes.InsertAtd (ATD, Nome, RegistroFuncional, Senha, strtoint(Grupo));

                           aux2 := '';
                         end
                         else if aux[i] <> ETX then
                           aux2 := aux2 + aux[i];
                       end;

                       frmSicsCommon_VisualizaManipulaPPs.AtualizaLookUps;

  {$IFNDEF CompilarPara_TV}
                       frmSicsCommon_LoginAtd.AtualizaListaDeAtendentes;
  {$ENDIF}

  {$IFDEF CompilarPara_PA}
                       frmSicsCommon_LogoutAtd.AtualizaListaDeAtendentes;
  {$ELSE} {$IFDEF CompilarPara_TGS_ONLINE}
                       frmMostraSituacaoAtendimento.AtualizaListaDeAtendentes;
  {$ENDIF} {$ENDIF}

                       lfAtdsConfigured := true;

                       SendCommandToHost(0, $29, '', IdUnidade);  //Para atualizar os nomes dos atendentes nas PAs => posteriormente alterar por um loop que atualize estes nomes no módulo PA e MultiPA e TGS

                       if aux2 <> '' then
                         AppMessageBox ('Texto maior do que o esperado. Caso $' + inttostr(Ord(s[4])), 'Informação', MB_ICONWARNING);
                     end;
{$ENDIF}
{$IFDEF CompilarPara_TGS}
          Chr($75) : begin
                       aux := ProtData;
                       ATD := StrToInt('$'+aux[1]+aux[2]+aux[3]+aux[4]);

                       AppMessageBox ('Atendente inserido: #' + inttostr(ATD), 'Informação', MB_ICONINFORMATION);
                     end;  { case Chr($75) }
{$ENDIF}
{$IFnDEF CompilarPara_TV}
          Chr($79) : begin
                       case s[7] of
                         'A' : frmDataModuleClientes.cdsGruposDeAtendentes  .EmptyDataSet;
                         'P' : frmDataModuleClientes.cdsGruposDePAs         .EmptyDataSet;
                         'T' : frmDataModuleClientes.cdsGruposDeTags        .EmptyDataSet;
                         'p' : frmDataModuleClientes.cdsGruposDePPs         .EmptyDataSet;
                         'M' : frmDataModuleClientes.cdsGruposDeMotivosPausa.EmptyDataSet;
                         else  Exit;
                       end;
                       aux := Copy (s, 8, length(s)-7);
                       { NATD := StrToInt('$'+aux[1]+aux[2]+aux[3]+aux[4]); }
                       aux := Copy(aux,5,Length(aux)-4);
                       aux2 := '';
                       for i := 1 to length (aux) do
                       begin
                         if aux[i] = TAB then
                         begin
                           Grupo  := Copy(aux2,1,4);
                           Nome   := Copy (aux2, 5, length(aux2)-4);

                           case s[7] of
                             'A' : frmDataModuleClientes.InsertGrupoAtd         (StrToInt('$'+Grupo), Nome);
                             'P' : frmDataModuleClientes.InsertGrupoPA          (StrToInt('$'+Grupo), Nome);
                             'T' : frmDataModuleClientes.InsertGrupoTAG         (StrToInt('$'+Grupo), Nome);
                             'p' : frmDataModuleClientes.InsertGrupoPP          (StrToInt('$'+Grupo), Nome);
                             'M' : frmDataModuleClientes.InsertGrupoMotivoPausa (StrToInt('$'+Grupo), Nome);
                             else  Exit;
                           end;

                           aux2 := '';
                         end
                         else if aux[i] <> ETX then
                           aux2 := aux2 + aux[i];
                       end;

                       case s[7] of
                         'A' : lfGruposAtdsConfigured         := true;
                         'P' : lfGruposPAsConfigured          := true;
                         'T' : lfGruposTAGsConfigured         := true;
                         'p' : lfGruposPPsConfigured          := true;
                         'M' : lfGruposMotivosPausaConfigured := true;
                       end;

//                       SendCommandToHost(0, $29, '', IdUnidade);  //Para atualizar os nomes dos atendentes nas PAs => posteriormente alterar por um loop que atualize estes nomes no módulo PA e MultiPA e TGS
                       if aux2 <> '' then
                         AppMessageBox ('Texto maior do que o esperado. Caso $' + inttostr(Ord(s[4])), 'Informação', MB_ICONWARNING);
                     end;

          Chr($7C) : begin
                       aux := ProtData;
//                       NF := StrToInt('$'+aux[1]+aux[2]+aux[3]+aux[4]);
  {$IFDEF CompilarPara_PA_MULTIPA}
                       frmSicsCommon_EscolheFila.listFilas.Clear;
  {$ELSE} {$IFDEF CompilarPara_TGS}
                       frmLines.ClearGrid;
  {$ENDIF} {$ENDIF}

                       frmDataModuleClientes.cdsFilas.EmptyDataSet;

                       aux := Copy(aux,5,Length(aux)-4);
                       aux2 := '';
                       for i := 1 to length (aux) do
                       begin
                         if aux[i] = TAB then
                         begin
                           Fila := StrToInt('$'+Copy(aux2,1,4));
                           Cor  := StrToInt('$'+Copy(aux2,5,6));
                           Nome := Copy(aux2, 11, length(aux2)-10);
                           aux2 := '';
                           frmDataModuleClientes.InsertFila (Fila, Nome);

  {$IFDEF CompilarPara_PA_MULTIPA}
                           frmSicsCommon_EscolheFila.InsertFila (Fila, Nome);
  {$ELSE} {$IFDEF CompilarPara_TGS}
                           frmLines.InsertFila (Fila, Nome);
  {$ELSE} {$IFDEF CompilarPara_ONLINE}
                           if ( (not frmSicsPrincipal.ExisteAFila(Fila)) and (frmSicsPrincipal.FilaEhPermitida(Fila)) ) then
                             frmSicsPrincipal.CriaComponenteFila (Fila, Nome, Cor);
  {$ENDIF} {$ENDIF} {$ENDIF}
                         end
                         else if aux[i] <> ETX then
                           aux2 := aux2 + aux[i];
                       end;

                       lfFilasConfigured := true;
  {$IFDEF CompilarPara_ONLINE}
                       frmSicsPrincipal.AlinhaComponentesNaTela;
                       if frmSicsPrincipal.fModoTotemTouch then
                         SendCommandToHost (0, $85, '', 0);
  {$ENDIF}

                       if aux2 <> '' then
                         Application.MessageBox ('Texto maior do que o esperado.', 'Info - Senhas em espera', MB_ICONWARNING);
                     end;
{$ENDIF}
//RAP - INICIO //////////////////////////////////////////////////////////////////////////////////////////////
{$IF Defined(CompilarPara_PA_MULTIPA) or Defined(CompilarPara_ONLINE)}  //RAP
  {$IFDEF CompilarPara_PA_MULTIPA}
          Chr($7E) : begin
                       aux := ProtData;
                       if aux = '0' then
                       begin
                        // sucesso
                       end
                       else
                       begin
                         // erro ao definir a TAG, decidir o que fazer
                       end;
                     end;
  {$ENDIF} //RAP
          Chr($80) : begin
                       frmDataModuleClientes.cdsTags.EmptyDataSet;

                       aux := ProtData;
                       aux := Copy(aux,5,Length(aux)-4);
                       aux2 := '';
                       for i := 1 to length (aux) do
                       begin
                         if aux[i] = TAB then
                         begin
                           IdTag := StrToInt('$'+Copy(aux2,1,4));
                           Cor   := StrToInt('$'+Copy(aux2,5,6));
                           aux2  := Copy(aux2, 11, length(aux2)-10);
                           SeparaStrings(aux2, ';', Grupo, Nome);

                           if Grupo = '' then
                             Grupo := '-1';

                           frmDataModuleClientes.InsertTAG (IdTag, Nome, strtoint(Grupo), Cor);

                           aux2 := '';
                         end
                         else if aux[i] <> ETX then
                           aux2 := aux2 + aux[i];
                       end;

  {$IFDEF CompilarPara_PA_MULTIPA} //RAP
                      frmSicsPrincipal.CriaTags;
  {$ENDIF} //RAP

                       lfTAGsConfigured := true;
                     end;
  {$IFDEF CompilarPara_PA_MULTIPA} //RAP
          Chr($82) : begin
                       aux := ProtData;
                       SeparaStrings(aux, ';', Senha, aux2);
                       StrToIntArray(aux2, Tags);
                       frmSicsPrincipal.SelecionarTags(PA, Tags);
                     end;
          Chr($84) : begin
                       aux := ProtData;
                       if aux = '0' then
                       begin
                        // sucesso
                       end
                       else
                       begin
                         // erro ao definir a TAG, decidir o que fazer
                       end;
                     end;
  {$ENDIF} //RAP
{$IFEND} //RAP 
//RAP - FIM //////////////////////////////////////////////////////////////////////////////////////////////
{$IFDEF CompilarPara_ONLINE}
          Chr($86) : begin
                       aux := ProtData;
//                       NF := StrToInt('$'+aux[1]+aux[2]+aux[3]+aux[4]);
                       aux := Copy(aux,5,Length(aux)-4);
                       aux2 := '';
                       for i := 1 to length (aux) do
                       begin
                         if aux[i] = TAB then
                         begin
                           Fila := StrToInt('$'+Copy(aux2,1,4));
                           Cor  := StrToInt('$'+Copy(aux2,5,6));
                           Nome := Copy(aux2, 11, length(aux2)-10);
                           aux2 := '';
                           frmSicsPrincipal.CriaComponenteTotem(Fila, Nome, Cor);
                         end
                         else if aux[i] <> ETX then
                           aux2 := aux2 + aux[i];
                       end;

                       frmSicsTotemTouchScreen.fBotoesCriados := true;
                       frmSicsTotemTouchScreen.EscondePainelSemConexao;

                       if aux2 <> '' then
                         Application.MessageBox ('Texto maior do que o esperado.', 'Info - Senhas em espera', MB_ICONWARNING);
                     end;
{$ENDIF}
          else begin
               end;  { case else }
        end;  { case }
      end;  { if gfMultipleAtds.. }
    end;  { if s <> '' }
  except
    on E: Exception do
    begin
      MyLogException(Exception.Create ('Erro ao decifrar protocolo TCP/IP (clientport): "' +
                                        s + '" / Remote: "' + Socket.RemoteAddress + '" / Erro: "' + E.Message + '"'));
    end;
  end;  { try .. except }
end;  { proc DecifraProtocolo }

{=============================================================================}
{ procedures do leitor de código de barras }

procedure TdmSicsClientConnection.CodeBarPortRxChar (Sender: TObject; Count: Integer);
const
  ReceivingCodeBar : boolean = false;
  CodeBar          : string = '';
var
  x : AnsiChar;
  i : word;
  s : string;
begin
  for i := 1 to Count do
  begin
    CodeBarPort.ReadChar(x);

{$IFDEF CompilarPara_PA_MULTIPA}
    if frmSicsCommon_LCDBInput.Visible then
      frmSicsCommon_LCDBInput.memoLCDBInput.Text := frmSicsCommon_LCDBInput.memoLCDBInput.Text + x;
{$ENDIF}

    if ((x = '/') or (x = '%')) then
    begin
      ReceivingCodeBar := true;
      CodeBar := '';
    end
    else if ((x = '\') or (x = '$')) then
    begin
      ReceivingCodeBar := false;

      CodeBar := '/' + CodeBar + '\';
      DecifraCodeBar (CodeBar);
      if s <> '' then
        CodeBarPort.WriteText(s);

      CodeBar := '';
    end
    else if ReceivingCodeBar then
      CodeBar := CodeBar + x;
  end;  { for }
end;


procedure TdmSicsClientConnection.DecifraCodeBar (s : string);
{$IFDEF CompilarPara_PA_MULTIPA}
var
  Senha               : string;
{$IFDEF CompilarPara_MULTIPA}
  RegFuncional        : string;
  NomeAtd             : string;
  i                   : integer;
  AchouPA             : boolean;
  frmDataModuleClientes : TfrmSicsCommon_DataModuleClientes;
{$ENDIF} {$ENDIF}
begin
{$IFDEF CompilarPara_PA_MULTIPA}
  if ((s <> '') and (s[1] = '/') and (s[length(s)] = '\')) then
  begin
{$IFDEF CompilarPara_MULTIPA}
    frmDataModuleClientes := (Application.FindComponent('frmSicsCommon_DataModuleClientes' + inttostr(0)) as TfrmSicsCommon_DataModuleClientes);
    if ((Pos ('PA:', s) > 0) or (Pos ('PA', s) > 0)) then
    begin
      frmSicsPrincipal.tmrClearAtdTimer(Self);

      if Pos ('PA:', s) > 0 then
        vlCurrentPA := strtoint(Copy (s, Pos('PA:',s)+Length('PA:'), length(s)-Pos('PA:',s)-Length('PA:')))
      else
        vlCurrentPA := strtoint(Copy (s, Pos('PA',s)+Length('PA'), length(s)-Pos('PA',s)-Length('PA')));

      if frmDataModuleClientes.IsAllowedPA(vlCurrentPA) then
      begin
        vlCurrentAtd := frmDataModuleClientes.GetIdAtd((frmSicsPrincipal.FindComponent('lblAtd'+inttostr(vlCurrentPA)) as TLabel).Caption);
        frmSicsPrincipal.tmrClearAtd.Enabled := false;
        frmSicsPrincipal.tmrClearAtd.Enabled := true;
        frmSicsPrincipal.DestacaPA (vlCurrentPA);
      end
      else
      begin
        vlCurrentPA  := -1;
        vlCurrentAtd := -1;
      end;
    end;

    if ((Pos ('Atd:', s) > 0) or (Pos ('ATD', s) > 0)) then
    begin
      frmSicsPrincipal.tmrClearAtdTimer(Self);

      if Pos ('Atd:', s) > 0 then
        vlCurrentAtd := strtoint(Copy (s, Pos('Atd:',s)+Length('Atd:'), length(s)-Pos('Atd:',s)-Length('Atd:')))
      else
        vlCurrentAtd := strtoint(Copy (s, Pos('ATD',s)+Length('ATD'), length(s)-Pos('ATD',s)-Length('ATD')));

      NomeAtd := frmDataModuleClientes.GetAtdNome(vlCurrentAtd);
      AchouPA := false;
      for i := 0 to frmSicsPrincipal.ComponentCount - 1 do
        if ((frmSicsPrincipal.Components[i] is TLabel) and ((frmSicsPrincipal.Components[i] as TLabel).Caption = NomeAtd)) then
        begin
          vlCurrentPA := (frmSicsPrincipal.Components[i] as TLabel).Tag;
          frmSicsPrincipal.DestacaPA (vlCurrentPA);
          frmSicsPrincipal.tmrClearAtd.Enabled := true ;
          AchouPA := true;
          break;
        end;

      if not AchouPA then
      begin
        vlCurrentPA  := -1;
        vlCurrentAtd := -1;
      end;
    end;
{$ENDIF}

    if ((Pos ('Tck:', s) > 0) or (Pos ('TCK', s) > 0)) then
    begin
      if Pos ('Tck:', s) > 0 then
        Senha := Copy (s, Pos('Tck:',s)+Length('Tck:'), length(s)-Pos('Tck:',s)-Length('Tck:'))
      else
        Senha := Copy (s, Pos('TCK',s)+Length('TCK'), length(s)-Pos('TCK',s)-Length('TCK'));

      // nesse ponto, poderia ter uma validação se vlCurrentPA <> -1 mas vlCurrentAtd = -1
      // (atendente não logado na PA), aparecer uma mensagem, ou no status bar, mas não finalizar a senha
      if ((vlCurrentPA = -1) or (vlCurrentAtd = -1)) then
      begin
        if vlCurrentFila = -1 then
          FinalizaPelaSenha(strtoint(Senha))
        else
        begin
//VERIFICAR COMO PODE RECOLOCAR ESTA FUNCIONALIDADE          frmSicsPrincipal.PswdLabel.Caption := frmSicsPrincipal.PswdLabel.Caption + ' => Fila ' + inttostr(vlCurrentFila);
          RedirecionaPelaSenha (vlCurrentFila, strtoint(senha));
        end;
      end
      else
        if vlConfirmacoes.SenhaOutraFila then
          ChamaEspecifica(vlCurrentPA,strtoint(Senha))
        else
          ForcaChamada(vlCurrentPA,strtoint(Senha));
    end;

{$IFDEF CompilarPara_MULTIPA}
    if ((Pos ('Reg:', s) > 0) or (Pos ('REG', s) > 0) or (Pos ('Log:', s) > 0) or (Pos ('LOG', s) > 0)) then  // REG = Registro Funcional, para V4. Log para compatibilidade com versões anteriores, descontinuar
    begin
      frmSicsPrincipal.tmrClearAtdTimer(Self);

      if Pos ('Reg:', s) > 0 then
        RegFuncional := Copy (s, Pos('Reg:',s)+Length('Reg:'), length(s)-Pos('Reg:',s)-Length('Reg:'))
      else if Pos ('REG', s) > 0 then
        RegFuncional := Copy (s, Pos('REG',s)+Length('REG'), length(s)-Pos('REG',s)-Length('REG'))
      else if Pos ('Log:', s) > 0 then
        RegFuncional := Copy (s, Pos('Log:',s)+Length('Log:'), length(s)-Pos('Log:',s)-Length('Log:'))
      else
        RegFuncional := Copy (s, Pos('LOG',s)+Length('LOG'), length(s)-Pos('LOG',s)-Length('LOG'));

      vlCurrentAtd := frmDataModuleClientes.GetIdAtdFromRegistroFuncional (RegFuncional);

      NomeAtd := frmDataModuleClientes.GetAtdNome(vlCurrentAtd);
      AchouPA := false;
      for i := 0 to frmSicsPrincipal.ComponentCount - 1 do
        if ((frmSicsPrincipal.Components[i] is TLabel) and ((frmSicsPrincipal.Components[i] as TLabel).Caption = NomeAtd)) then
        begin
          vlCurrentPA := (frmSicsPrincipal.Components[i] as TLabel).Tag;
          frmSicsPrincipal.DestacaPA (vlCurrentPA);
          frmSicsPrincipal.tmrClearAtd.Enabled := true ;
          AchouPA := true;
          break;
        end;

      if not AchouPA then
      begin
        vlCurrentPA  := -1;
        vlCurrentAtd := -1;
      end;
    end;
{$ENDIF}

    if ((Pos ('Fila:', s) > 0) or (Pos ('FILA', s) > 0)) then
    begin
{$IFDEF CompilarPara_MULTIPA}
      frmSicsPrincipal.tmrClearAtdTimer(Self);
{$ENDIF}

      if Pos ('Fila:', s) > 0 then
        vlCurrentFila := strtoint(Copy (s, Pos('Fila:',s)+Length('Fila:'), length(s)-Pos('Fila:',s)-Length('Fila:')))
      else
        vlCurrentFila := strtoint(Copy (s, Pos('FILA',s)+Length('FILA'), length(s)-Pos('FILA',s)-Length('FILA')));

{$IFDEF CompilarPara_MULTIPA}
//      frmSicsPrincipal.tmrClearAtdTimer(Self);
      frmSicsPrincipal.tmrClearAtd.Enabled := false;
      frmSicsPrincipal.tmrClearAtd.Enabled := true;
{$ENDIF}
    end;
  end;
{$ENDIF}
end;  { proc DecifraCodeBar }


end.





