unit SCC_m;

{$J+}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ScktComp, ExtCtrls, MyDlls_DR, IniFiles, StdCtrls, Menus, // RXShell,
  LEDR, DB, DBClient, Grids, DBGrids, uTypes, uDMSocket, IdHTTPWebBrokerBridge,
  uLibDatasnap, System.StrUtils, IdBaseComponent, IdIntercept, IdServerInterceptLogBase, IdServerInterceptLogFile,
  Horse, Horse.Jhonson, Horse.HandleException, Horse.OctetStream, Controllers.App;

{$INCLUDE ..\..\SicsVersoes.pas}

type
  ERegistroDeOperacao = class(Exception);

  TMainForm = class(TForm)
    tmrCheckInterface: TTimer;
    memoStatus: TMemo;
    PopUpMenu: TPopupMenu;
    menuRestaurar: TMenuItem;
    menuSobre: TMenuItem;
    menuSair: TMenuItem;
    N1: TMenuItem;
    ledDataSourceAvailable: TLEDRLabel;
    cdsMV: TClientDataSet;
    dsMV: TDataSource;
    gridMV: TDBGrid;
    cdsMVSala: TStringField;
    cdsMVIdPA: TIntegerField;
    sktMV: TServerSocket;
    ledPastaDestinoConfigurada: TLEDRLabel;
    TrayIcon: TTrayIcon;
    TimerTentarCarregarParametrosUnidades: TTimer;
    IdServerInterceptLogFile: TIdServerInterceptLogFile;
    tmrLog: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tmrCheckInterfaceTimer(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure menuSobreClick(Sender: TObject);
    procedure menuSairClick(Sender: TObject);
    procedure TrayIconDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ledDataSourceAvailableChangeState(Sender: TObject);
    procedure sktMVClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure sktMVClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure sktMVClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure sktMVListen(Sender: TObject; Socket: TCustomWinSocket);
    procedure sktMVClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure cdsMVAfterPost(DataSet: TDataSet);
    procedure TrayIconClick(Sender: TObject);
    procedure TimerTentarCarregarParametrosUnidadesTimer(Sender: TObject);
    procedure tmrLogTimer(Sender: TObject);
  private
    { Private declarations }
    fTipoDaInterface: TTipoDaInterface;
    fPastaDeIntercambio: string;
    fApertouBotaoSair: boolean;
    fPortaSocketMV: Integer;
    fSalvarRespostasArquivos: boolean;
    fPastaSaida: string;
    fPastaCriada: boolean;

    FPortaREST               : Integer;
    FUrlEnviaSenha           : String;
    FAuthorization           : String;
    FClientSocketAddres      : String;
    FClientSocketPort        : Integer;
    FCaminhoBDUnidades       : String;
    FDBHost                  : String;
    FDBBanco                 : String;
    FDBUsuario               : String;
    FDBSenha                 : String;
    FDBOSAuthent             : Boolean;
    FDiasDeviceOcioso        : Integer;
    FIDsUnidadesSmartSurvey  : String;
    FHorsePort               : Integer;
    FdmSocket                : TdmSocket;
    FRESTServer              : TIdHTTPWebBrokerBridge;
    FDia                     : Integer;
    FURL_AtualizaStatusSenha : String;
    Icon                     : TIcon;

    procedure LoadSettings;
    procedure SaveSettings;
    procedure DecodificaArquivo(FileName: TFileName);
    procedure DecodificaArquivoV5(FileName: TFileName);
    procedure MyExceptionHandler(Sender: TObject; E: Exception);
    procedure MinimizeApp(Sender: TObject);
    procedure SetTrayIcon;
    function DecifraProtocoloMV(s: string): string;
    procedure SalvaArquivoResposta(s: String);

    // métodos "movidos" para o DMSocket
    procedure onSocketConnect;
    procedure onSocketDisconnect;
    procedure onSocketError(ErrorCode: Integer);
    procedure onSocketReadException(AException: Exception);
    procedure StartHorseServer;
    procedure StopHorseServer;
    procedure StartRESTServer;
    procedure StopRESTServer;
    procedure TentarCarregarDadosUnidades;
    procedure SetCaminhoBDUnidades(const Value: String);
    procedure SetDia(const Value: Integer);
    procedure SetURL_AtualizaStatusSenha(const Value: String);
  protected

  public
    FModoDesktop: boolean;
    FID_versao: Integer;
    //FVersao_Stream: TMemoryStream;
    property CaminhoBDUnidades: String read FCaminhoBDUnidades write SetCaminhoBDUnidades;
    property Dia: Integer read FDia write SetDia;
    property URL_AtualizaStatusSenha: String read FURL_AtualizaStatusSenha write SetURL_AtualizaStatusSenha;
    procedure ShowStatus(s: string);
    property IDsUnidadesSmartSurvey: string read FIDsUnidadesSmartSurvey write FIDsUnidadesSmartSurvey;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses uConsts, Datasnap.DSSession, untLog, uFuncoes, udmControleDeTokens;

procedure TMainForm.MyExceptionHandler(Sender: TObject; E: Exception);
begin
  MyLogException(ERegistroDeOperacao.Create(
    FormatDateTime('dd/mm/yy  hh:nn:ss', now) + ' - ' +
    'Classe: ' + E.ClassName + ' - ' + '  Erro: ' + E.Message ));

  if E.ClassNameIs('ESocketError') then
  begin
    if Assigned(FdmSocket) then
      FdmSocket.ClientSocket.Close;
    sktMV.Close;
  end;
end; { proc MyExceptionHandler }

procedure TMainForm.MinimizeApp(Sender: TObject);
begin
  MainForm.Hide;
end; { proc MinimizeApp }

procedure TMainForm.SetCaminhoBDUnidades(const Value: String);
begin
  FCaminhoBDUnidades := Value;
end;

procedure TMainForm.SetDia(const Value: Integer);
begin
  FDia := Value;
end;

procedure TMainForm.SetTrayIcon;
var
  isOk: boolean;
begin
  TrayIcon.Hint := 'SICS Customização de Chamadas';

  if fTipoDaInterface = tiREST then
  begin
    TrayIcon.IconIndex := 0;
    isOk := true;
  end
  else
  begin
    isOk := false;
    if ((Assigned(FdmSocket) and (FdmSocket.ClientSocket.Active)) and
      (ledDataSourceAvailable.Lit)) then
    begin
      if (not fSalvarRespostasArquivos) then
      begin
        TrayIcon.IconIndex := 0;
        isOk := true;
      end
      else if (ledPastaDestinoConfigurada.Lit) then
      begin
        TrayIcon.IconIndex := 0;
        isOk := true;
      end;
    end;
  end;

  if not isOk then
  begin
    TrayIcon.IconIndex := 1;
    if Assigned(FdmSocket) and (not FdmSocket.ClientSocket.Active) then
      TrayIcon.Hint := TrayIcon.Hint + #13'Sem conexão com SICS Servidor';
    if not ledDataSourceAvailable.Lit then
      TrayIcon.Hint := TrayIcon.Hint + #13'Fonte de dados indisponível';
    if (fSalvarRespostasArquivos) and (not ledPastaDestinoConfigurada.Lit) then
    begin
      if (fPastaCriada) then
        TrayIcon.Hint := TrayIcon.Hint + #13'Pasta de destino não configurada'
      else
        TrayIcon.Hint := TrayIcon.Hint + #13'Pasta de destino inacessível';
    end;

  end; { if }

end; procedure TMainForm.SetURL_AtualizaStatusSenha(const Value: String);
begin
  FURL_AtualizaStatusSenha := Value;
end;

{ proc SetTrayIcon }

procedure TMainForm.LoadSettings;
var
  IniFile: TIniFile;
  aux: string;
  i: TTipoDaInterface;

begin
  IniFile := TIniFile.Create(GetAppIniFileName);
  with IniFile do
    try
      aux := ReadString('Settings', 'TipoDaInterface', StrTipoDaInterface[tiFlatFiles]);
      FClientSocketAddres := ReadString('Settings', 'TCPSrvAdr', '127.0.0.1');
      FClientSocketPort := ReadInteger('Settings', 'TCPSrvPort', 6501);
      tmrCheckInterface.Interval := ReadInteger('Settings', 'IntervaloDeChecagem', 1000);
      FIDsUnidadesSmartSurvey := ReadString ('Settings', 'IDsUnidadesSmartSurvey', '');

      URL_AtualizaStatusSenha := ReadString('EndPointsSiaf', 'URL_ATUALIZASTATUSSENHA', EmptyStr);

      fTipoDaInterface := tiNone;
      for i := low(StrTipoDaInterface) to high(StrTipoDaInterface) do
        if AnsiUpperCase(StrTipoDaInterface[i]) = AnsiUpperCase(aux) then
        begin
          fTipoDaInterface := i;
          break;
        end;

      FdmSocket := TdmSocket.Create(Self);
      //FdmSocket.ClientSocket.Host := FClientSocketAddres;
      //FdmSocket.ClientSocket.Port := FClientSocketPort;
      //FdmSocket.OnConnect := onSocketConnect;
      FdmSocket.OnDisconnect := onSocketDisconnect;
      FdmSocket.OnError := onSocketError;
      FdmSocket.OnReadException := onSocketReadException;
      FdmSocket.OnStatusChange := ShowStatus;
      FdmSocket.ProcSalvaArquivoResposta := SalvaArquivoResposta;
      FdmSocket.TipoInterface := fTipoDaInterface;
      FdmSocket.SalvarRespostasArquivos := fSalvarRespostasArquivos;

      case fTipoDaInterface of
        tiFlatFiles:
          begin
            fPastaDeIntercambio := ExcludeTrailingPathDelimiter
              (ReadString(StrTipoDaInterface[fTipoDaInterface], 'Pasta', ''));
          end;
        tiMV:
          begin
            fPortaSocketMV := ReadInteger(StrTipoDaInterface[fTipoDaInterface],
              'Porta', 3000);
            if FileExists(ExcludeTrailingPathDelimiter(GetApplicationPath) +
              '\MV.dat') then
              cdsMV.LoadFromFile
                (ExcludeTrailingPathDelimiter(GetApplicationPath) + '\MV.dat');
          end;
        tiSilab:
          begin
            fPastaDeIntercambio := ExcludeTrailingPathDelimiter
              (ReadString(StrTipoDaInterface[fTipoDaInterface],
              'PastaEntrada', ''));
            fPastaSaida := ExcludeTrailingPathDelimiter
              (ReadString(StrTipoDaInterface[fTipoDaInterface],
              'PastaSaida', ''));
            fSalvarRespostasArquivos := true;
          end;
        tiREST:
          begin
            IdServerInterceptLogFile.Filename := ExtractFilePath(ParamStr(0)) + 'Log_SCC_REST_' + FormatDateTime('DDMMYYYY', Now) + '.log';

            tmrCheckInterface.Enabled := False;
            FPortaREST := ReadInteger(StrTipoDaInterface[fTipoDaInterface], 'Porta', 80);
            FUrlEnviaSenha := ReadString(StrTipoDaInterface[fTipoDaInterface], 'UrlEnviarSenha', '');
            FAuthorization := ReadString(StrTipoDaInterface[fTipoDaInterface], 'Authorization', '');
            FdmSocket.IdHTTP1.Request.ContentType := 'application/json'; FdmSocket.IdHTTP1.Request.CustomHeaders.AddValue('Authorization', FAuthorization);

            FCaminhoBDUnidades      := ReadString (StrTipoDaInterface[fTipoDaInterface], 'BDUnidades'             , '');
            FDBHost                 := ReadString (StrTipoDaInterface[fTipoDaInterface], 'DBHost'                 , '');
            FDBBanco                := ReadString (StrTipoDaInterface[fTipoDaInterface], 'DBBanco'                , '');
            FDBUsuario              := ReadString (StrTipoDaInterface[fTipoDaInterface], 'DBUsuario'              , '');
            FDBSenha                := ReadString (StrTipoDaInterface[fTipoDaInterface], 'DBSenha'                , '');
            FDBOSAuthent            := ReadString (StrTipoDaInterface[fTipoDaInterface], 'DBOSAuthent'            , '') = 'S';
            FDiasDeviceOcioso       := ReadInteger(StrTipoDaInterface[fTipoDaInterface], 'DiasDeviceOcioso'       , 7);

            FdmSocket.UrlEnviaSenha := FUrlEnviaSenha;
            FRESTServer := TIdHTTPWebBrokerBridge.Create(Self);
            FRESTServer.Intercept := IdServerInterceptLogFile;
            FRESTServer.MaxConnections := 150;

            TLibDataSnap.ProcStatusChange := ShowStatus;
            TLibDataSnap.SocketAdress := FClientSocketAddres;
            TLibDataSnap.SocketPort   := FClientSocketPort;

            if ((FCaminhoBDUnidades <> EmptyStr) or (FDBHost <> EmptyStr)) then
              TentarCarregarDadosUnidades;

            dmControleDeTokens := TdmControleDeTokens.Create(Application);

            StartRESTServer;
          end;
        tiHORSE:
          begin
            IdServerInterceptLogFile.Filename := ExtractFilePath(ParamStr(0)) + 'Log_SCC_HORSE_' + FormatDateTime('DDMMYYYY', Now) + '.log';

            tmrCheckInterface.Enabled := False;
            FHorsePort := ReadInteger('HORSE', 'Porta', 0);
            FUrlEnviaSenha := ReadString(StrTipoDaInterface[fTipoDaInterface], 'UrlEnviarSenha', '');
            FAuthorization := ReadString(StrTipoDaInterface[fTipoDaInterface], 'Authorization', '');
            FdmSocket.IdHTTP1.Request.ContentType := 'application/json'; FdmSocket.IdHTTP1.Request.CustomHeaders.AddValue('Authorization', FAuthorization);

            FCaminhoBDUnidades      := ReadString (StrTipoDaInterface[fTipoDaInterface], 'BDUnidades'      , '');
            FDBHost                 := ReadString (StrTipoDaInterface[fTipoDaInterface], 'DBHost'          , '');
            FDBBanco                := ReadString (StrTipoDaInterface[fTipoDaInterface], 'DBBanco'         , '');
            FDBUsuario              := ReadString (StrTipoDaInterface[fTipoDaInterface], 'DBUsuario'       , '');
            FDBSenha                := ReadString (StrTipoDaInterface[fTipoDaInterface], 'DBSenha'         , '');
            FDBOSAuthent            := ReadString (StrTipoDaInterface[fTipoDaInterface], 'DBOSAuthent'     , '') = 'S';
            FDiasDeviceOcioso       := ReadInteger(StrTipoDaInterface[fTipoDaInterface], 'DiasDeviceOcioso', 7);

            if ((FCaminhoBDUnidades <> EmptyStr) or (FDBHost <> EmptyStr)) then
            begin
              TentarCarregarDadosUnidades;
            end;
            dmControleDeTokens := TdmControleDeTokens.Create(Application);
            StartHorseServer;
          end;
      end;

      SaveSettings;
    finally
      Free;
    end;
end; { proc LoadSettings }

procedure TMainForm.TentarCarregarDadosUnidades;
begin
  if not TLibDatasnap.CarregarParametrosUnidades(FCaminhoBDUnidades,
                                                 FDBHost,
                                                 FDBBanco,
                                                 FDBUsuario,
                                                 FDBSenha,
                                                 FDBOSAuthent,
                                                 FDiasDeviceOcioso) then
  begin
    //Feito pois o serviço do Firebird pode subir antes do serviço do SCC.
    //Quando isso acontece o timer é reativado para nova tentativa
    TimerTentarCarregarParametrosUnidades.Enabled := True;
    ShowStatus('Erro ao conectar ao Banco: ' + FCaminhoBDUnidades);
  end
  else
  begin
    ShowStatus('Conectado ao Banco: ' + FCaminhoBDUnidades);
  end;
end;

procedure TMainForm.SaveSettings;
var
  IniFile: TIniFile;
  i: TTipoDaInterface;
begin
  IniFile := TIniFile.Create(GetAppIniFileName);
  with IniFile do
    try
      WriteString  ('Settings', 'TipoDaInterface',        StrTipoDaInterface[fTipoDaInterface]);
      WriteString  ('Settings', 'TCPSrvAdr',              FClientSocketAddres);
      WriteInteger ('Settings', 'TCPSrvPort',             FClientSocketPort);
      WriteInteger ('Settings', 'IntervaloDeChecagem',    tmrCheckInterface.Interval);
      WriteString  ('Settings', 'IDsUnidadesSmartSurvey', FIDsUnidadesSmartSurvey);

      WriteString('EndPointsSiaf', 'URL_ATUALIZASTATUSSENHA', URL_AtualizaStatusSenha);

      for i := low(StrTipoDaInterface) to high(StrTipoDaInterface) do
        EraseSection(StrTipoDaInterface[i]);

      case fTipoDaInterface of
        tiFlatFiles:
          begin
            WriteString(StrTipoDaInterface[fTipoDaInterface], 'Pasta',
              fPastaDeIntercambio);
          end;
        tiMV:
          begin
            WriteInteger(StrTipoDaInterface[fTipoDaInterface], 'Porta',
              fPortaSocketMV);
          end;
        tiSilab:
          begin
            WriteString(StrTipoDaInterface[fTipoDaInterface], 'PastaEntrada',
              fPastaDeIntercambio);
            WriteString(StrTipoDaInterface[fTipoDaInterface], 'PastaSaida',
              fPastaSaida);
          end;
        tiREST:
          begin
            WriteInteger(StrTipoDaInterface[fTipoDaInterface], 'Porta'           , FPortaREST        );
            WriteString (StrTipoDaInterface[fTipoDaInterface], 'UrlEnviarSenha'  , FUrlEnviaSenha    );
            WriteString (StrTipoDaInterface[fTipoDaInterface], 'Authorization'   , FAuthorization    );
            WriteString (StrTipoDaInterface[fTipoDaInterface], 'BDUnidades'      , FCaminhoBDUnidades);
            WriteString (StrTipoDaInterface[fTipoDaInterface], 'DBHost'          , FDBHost           );
            WriteString (StrTipoDaInterface[fTipoDaInterface], 'DBBanco'         , FDBBanco          );
            WriteString (StrTipoDaInterface[fTipoDaInterface], 'DBUsuario'       , FDBUsuario        );
            WriteString (StrTipoDaInterface[fTipoDaInterface], 'DBSenha'         , FDBSenha          );
            WriteString (StrTipoDaInterface[fTipoDaInterface], 'DBOSAuthent'     , IfThen(FDBOSAuthent, 'S', 'N'));
            WriteInteger(StrTipoDaInterface[fTipoDaInterface], 'DiasDeviceOcioso', FDiasDeviceOcioso);
          end;
        tiHORSE:
          begin
            WriteInteger(StrTipoDaInterface[fTipoDaInterface], 'Porta'           , FHorsePort        );
            WriteString (StrTipoDaInterface[fTipoDaInterface], 'BDUnidades'      , FCaminhoBDUnidades);
            WriteString (StrTipoDaInterface[fTipoDaInterface], 'DBHost'          , FDBHost           );
            WriteString (StrTipoDaInterface[fTipoDaInterface], 'DBBanco'         , FDBBanco          );
            WriteString (StrTipoDaInterface[fTipoDaInterface], 'DBUsuario'       , FDBUsuario        );
            WriteString (StrTipoDaInterface[fTipoDaInterface], 'DBSenha'         , FDBSenha          );
            WriteString (StrTipoDaInterface[fTipoDaInterface], 'DBOSAuthent'     , IfThen(FDBOSAuthent, 'S', 'N'));
          end;
      end;
    finally
      Free;
    end;

end; { proc SaveSettings }

procedure TMainForm.ShowStatus(s: string);
begin
  untLog.TLog.MyLog(s, nil, 0, false, tlINFO);

  TThread.Synchronize(nil,
    procedure
    var
      i  : word;
      SL : TStrings;
    begin
      if not GetIsService then
      begin
        if memoStatus.Lines.Count >= 1000 then
        begin
          SL := TStringList.Create;
          try
            SL.Assign(memoStatus.Lines);
            for i := 1 to 500 do
              SL.Delete(0);
            memoStatus.Lines.Clear;
            memoStatus.Lines.Assign(SL);
          finally
            SL.Free;
          end;
        end;

        memoStatus.Lines.Add(Format('%s - %s', [FormatDateTime('hh:nn:ss', now), s]));
      end;
    end);
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  //Icon: TIcon;
  LDia, LMes, LAno: Word;
begin
{$R 'OkNotOk.RES'}
  Application.OnMinimize := MinimizeApp;
  Application.OnException := MyExceptionHandler;

  TrayIcon.Icons := TImageList.Create(Self);
  Icon := TIcon.Create;
  Icon.LoadFromResourceName(Hinstance, 'OK');
  TrayIcon.Icon.Assign(Icon);
  TrayIcon.Icons.AddIcon(Icon);
  Icon.LoadFromResourceName(Hinstance, 'NOTOK');
  TrayIcon.Icons.AddIcon(Icon);

  TrayIcon.IconIndex := 0;
  TrayIcon.Visible := true;

  SetTrayIcon;

  fPastaCriada := true;

  fApertouBotaoSair := false;
  LoadSettings;
  SaveSettings;

  //FVersao_Stream := TMemoryStream.Create;

  if fTipoDaInterface = tiMV then
  begin
    sktMV.Port := fPortaSocketMV;
    sktMV.Open;
  end;

  LoadPosition(Sender as TForm);

  DecodeDate(Now, LAno, LMes, LDia);
  Dia := LDia;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  Icon.Free;
  if fTipoDaInterface = tiREST then
    StopRESTServer
  else if fTipoDaInterface = tiHORSE then
    THorse.StopListen
  else if Assigned(FdmSocket) then
    FdmSocket.ClientSocket.Close;
  SaveSettings;
  SavePosition(Sender as TForm);
end;

procedure TMainForm.DecodificaArquivo(FileName: TFileName);
var
  f: textfile;
  s, s1, s2, DATA: string;
  PA, CMD: Integer;
begin
  try
    if not FileExists(FileName) then
      raise Exception.Create('Arquivo não existe');

    AssignFile(f, FileName);
    Reset(f);
    try
      Readln(f, s);
      ShowStatus('Conteúdo do arquivo: ' + s);
      SeparaStrings(s, ';', s1, s);
      SeparaStrings(s, ';', s2, DATA);
      PA := strtoint(s1);
      CMD := strtoint('$' + s2);
      case CMD of
        $20:
          begin
            s := #2 + inttohex(PA, 4) + Chr(CMD) + #3;
            ShowStatus('Chamando próxima senha para PA ' + inttostr(PA));
          end;
        $21:
          begin
            s := #2 + inttohex(PA, 4) + Chr($30) + DATA + #3;
            ShowStatus('Chamando senha ' + DATA + ' para PA ' + inttostr(PA));
          end;
        $22:
          begin
            s := #2 + inttohex(PA, 4) + Chr(CMD) + #3;
            ShowStatus('Rechamando a senha em atendimento para PA ' +
              inttostr(PA));
          end;
        $25:
          begin
            s := #2 + inttohex(PA, 4) + Chr(CMD) + #3;
            ShowStatus('Finalizando a senha em atendimento para PA ' +
              inttostr(PA));
          end;
        $2E:
          begin
            s := #2 + inttohex(PA, 4) + Chr(CMD) +
              inttohex(strtoint(DATA), 4) + #3;
            ShowStatus('Encaminhando a senha em atendimento na PA ' +
              inttostr(PA) + ' para a fila ' + DATA);
          end;
        $54:
          begin
            s := #2 + inttohex(PA, 4) + Chr(CMD) +
              inttohex(strtoint(DATA), 4) + #3;
            ShowStatus('Fazendo login do atendente ' + DATA + ' para PA ' +
              inttostr(PA));
          end;
        $5D:
          begin
            s := #2 + inttohex(PA, 4) + Chr(CMD) + #3;
            ShowStatus('Fazendo logout do atendente que estiver logado na PA ' +
              inttostr(PA));
          end;
      else
        begin
          s := '';
          raise Exception.Create
            ('Comando requerido pelo arquivo é inválido nesta versão.');
        end;
      end;
      if ((s <> '') and (FdmSocket.ClientSocket.Active)) then
        FdmSocket.ClientSocket.Socket.SendText(s);
    finally
      CloseFile(f);
    end;
  except
    ShowStatus('Erro ao decodificar arquivo.');
    Raise;
  end;
end;

procedure TMainForm.DecodificaArquivoV5(FileName: TFileName);
var
  f: textfile;
  s, s1, s2, DATA: string;
  PA, CMD: Integer;
  ProtVersion: Integer;
  MP, Fila: Integer;
  AtdLogin, AtdNome, Senha, Nome, Lista: string;
begin
  try
    if not FileExists(FileName) then
      raise Exception.Create('Arquivo não existe');

    AssignFile(f, FileName);
    Reset(f);
    try
      Readln(f, s);
      ShowStatus('Conteúdo do arquivo: ' + s);
      SeparaStrings(s, ';', s1, s);
      SeparaStrings(s, ';', s2, DATA);
      PA := strtoint(s1);
      CMD := strtoint('$' + s2);
      ProtVersion := cgVERSAOPROTOCOLO;
      case CMD of
        $20:
          begin // incluida para compatibilidade do SILAB V4 com o SICS V5. Pode ser removida quando for SILAB V5 com SICS V5 (integração SICS<=>SILAB 2016
            s := #2 + inttohex(ProtVersion, 4) + inttohex(PA, 4) + Chr(CMD) +
              DATA + #3;
            // incluida para compatibilidade do SILAB V4 com o SICS V5. Pode ser removida quando for SILAB V5 com SICS V5 (integração SICS<=>SILAB 2016
            ShowStatus('Chamando próxima senha para PA ' + inttostr(PA));
            // incluida para compatibilidade do SILAB V4 com o SICS V5. Pode ser removida quando for SILAB V5 com SICS V5 (integração SICS<=>SILAB 2016
          end; // incluida para compatibilidade do SILAB V4 com o SICS V5. Pode ser removida quando for SILAB V5 com SICS V5 (integração SICS<=>SILAB 2016
        $21:
          begin // incluida para compatibilidade do SILAB V4 com o SICS V5. Pode ser removida quando for SILAB V5 com SICS V5 (integração SICS<=>SILAB 2016
            s := #2 + inttohex(ProtVersion, 4) + inttohex(PA, 4) + Chr($30) +
              DATA + #3;
            // incluida para compatibilidade do SILAB V4 com o SICS V5. Pode ser removida quando for SILAB V5 com SICS V5 (integração SICS<=>SILAB 2016
            ShowStatus('Chamando senha ' + DATA + ' para PA ' + inttostr(PA));
            // incluida para compatibilidade do SILAB V4 com o SICS V5. Pode ser removida quando for SILAB V5 com SICS V5 (integração SICS<=>SILAB 2016
          end; // incluida para compatibilidade do SILAB V4 com o SICS V5. Pode ser removida quando for SILAB V5 com SICS V5 (integração SICS<=>SILAB 2016
        $22:
          begin // incluida para compatibilidade do SILAB V4 com o SICS V5. Pode ser removida quando for SILAB V5 com SICS V5 (integração SICS<=>SILAB 2016
            s := #2 + inttohex(ProtVersion, 4) + inttohex(PA, 4) + Chr(CMD) +
              DATA + #3;
            // incluida para compatibilidade do SILAB V4 com o SICS V5. Pode ser removida quando for SILAB V5 com SICS V5 (integração SICS<=>SILAB 2016
            ShowStatus('Rechamando a senha em atendimento para PA ' +
              inttostr(PA));
            // incluida para compatibilidade do SILAB V4 com o SICS V5. Pode ser removida quando for SILAB V5 com SICS V5 (integração SICS<=>SILAB 2016
          end; // incluida para compatibilidade do SILAB V4 com o SICS V5. Pode ser removida quando for SILAB V5 com SICS V5 (integração SICS<=>SILAB 2016
        $25:
          begin // incluida para compatibilidade do SILAB V4 com o SICS V5. Pode ser removida quando for SILAB V5 com SICS V5 (integração SICS<=>SILAB 2016
            s := #2 + inttohex(ProtVersion, 4) + inttohex(PA, 4) + Chr(CMD) +
              DATA + #3;
            // incluida para compatibilidade do SILAB V4 com o SICS V5. Pode ser removida quando for SILAB V5 com SICS V5 (integração SICS<=>SILAB 2016
            ShowStatus('Finalizando a senha em atendimento para PA ' +
              inttostr(PA));
            // incluida para compatibilidade do SILAB V4 com o SICS V5. Pode ser removida quando for SILAB V5 com SICS V5 (integração SICS<=>SILAB 2016
          end; // incluida para compatibilidade do SILAB V4 com o SICS V5. Pode ser removida quando for SILAB V5 com SICS V5 (integração SICS<=>SILAB 2016
        $28:
          begin
            s := #2 + inttohex(ProtVersion, 4) + inttohex(PA, 4) + Chr(CMD) +
              DATA + #3;
            MP := strtoint('$' + Copy(DATA, 1, 4));
            Fila := strtoint('$' + Copy(DATA, 5, 4));
            ShowStatus('Encaminhando a senha em atendimento na PA ' +
              inttostr(PA) + ' para a fila ' + inttostr(Fila) +
              ' e colocando em pausa pelo motivo ' + inttostr(MP));
          end;
        $2E:
          begin
            s := #2 + inttohex(ProtVersion, 4) + inttohex(PA, 4) + Chr(CMD) +
              DATA + #3;
            ShowStatus('Encaminhando a senha em atendimento na PA ' +
              inttostr(PA) + ' para a fila ' + DATA);
          end;
        $30:
          begin
            s := #2 + inttohex(ProtVersion, 4) + inttohex(PA, 4) + Chr($30) +
              DATA + #3;
            ShowStatus('Chamando senha ' + DATA + ' para PA ' + inttostr(PA));
          end;
        $32:
          begin
            s := #2 + inttohex(ProtVersion, 4) + inttohex(PA, 4) + Chr(CMD) +
              DATA + #3;
            Fila := strtoint('$' + Copy(DATA, 1, 4));
            Senha := Copy(DATA, 5);
            ShowStatus('Encaminhando a senha em atendimento na PA ' +
              inttostr(PA) + ' para a fila ' + inttostr(Fila) +
              ' e chamando a senha ' + Senha);
          end;
        $41:
          begin
            s := #2 + inttohex(ProtVersion, 4) + inttohex(PA, 4) + Chr(CMD) +
              DATA + #3;
            ShowStatus('Requisitando lista de motivos de pausa para a PA ' +
              inttostr(PA));
          end;
        $54:
          begin // incluida para compatibilidade do SILAB V4 com o SICS V5. Pode ser removida quando for SILAB V5 com SICS V5 (integração SICS<=>SILAB 2016
            s := #2 + inttohex(ProtVersion, 4) + inttohex(PA, 4) + Chr(CMD) +
              DATA + #3;
            // incluida para compatibilidade do SILAB V4 com o SICS V5. Pode ser removida quando for SILAB V5 com SICS V5 (integração SICS<=>SILAB 2016
            ShowStatus('Fazendo login do atendente ' + DATA + ' para PA ' +
              inttostr(PA));
            // incluida para compatibilidade do SILAB V4 com o SICS V5. Pode ser removida quando for SILAB V5 com SICS V5 (integração SICS<=>SILAB 2016
          end; // incluida para compatibilidade do SILAB V4 com o SICS V5. Pode ser removida quando for SILAB V5 com SICS V5 (integração SICS<=>SILAB 2016
        $57:
          begin
            s := #2 + inttohex(ProtVersion, 4) + inttohex(PA, 4) + Chr(CMD) +
              DATA + #3;
            SeparaStrings(DATA, TAB, Senha, Nome);
            ShowStatus('Atrelando nome "' + Nome + '" à senha ' + Senha);
          end;
        $5D:
          begin
            s := #2 + inttohex(ProtVersion, 4) + inttohex(PA, 4) + Chr(CMD) +
              DATA + #3;
            Fila := strtointdef('$' + Copy(DATA, 1, 4), 0);
            ShowStatus('Encaminhando a senha em atendimento na PA ' +
              inttostr(PA) + ' para a fila ' + inttostr(Fila) +
              ' e fazendo logout do atendente desta PA');
          end;
        $77:
          begin
            s := #2 + inttohex(ProtVersion, 4) + inttohex(PA, 4) + Chr(CMD) +
              DATA + #3;
            Fila := strtoint('$' + Copy(DATA, 1, 4));
            Senha := Copy(DATA, 5);
            ShowStatus('Solicitando redirecionamento da senha ' + Senha +
              ' para a fila ' + inttostr(Fila));
          end;
        $7B:
          begin
            s := #2 + inttohex(ProtVersion, 4) + inttohex(PA, 4) + Chr(CMD) +
              DATA + #3;
            ShowStatus
              ('Requisitando lista de filas para encaminhamento a partir da PA '
              + inttostr(PA));
          end;
        $C1:
          begin
            s := #2 + inttohex(ProtVersion, 4) + inttohex(PA, 4) + Chr(CMD) +
              DATA + #3;
            SeparaStrings(DATA, ';', AtdLogin, AtdNome);
            ShowStatus('Fazendo login do atendente "' + AtdNome +
              '", de login "' + AtdLogin + '" na PA ' + inttostr(PA));
          end;
        $C3:
          begin
            s := #2 + inttohex(ProtVersion, 4) + inttohex(PA, 4) + Chr(CMD) +
              DATA + #3;
            SeparaStrings(DATA, ';', Senha, Lista);
            ShowStatus('Enviando ao SICS a lista de agendamentos da senha ' +
              Senha + ': "' + Lista + '"');
          end;
      else
        begin
          s := '';
          ShowStatus('Comando requerido pelo arquivo é inválido nesta versão.');
          raise Exception.Create
            ('Comando requerido pelo arquivo é inválido nesta versão.');
        end;
      end;
      if ((s <> '') and (FdmSocket.ClientSocket.Active)) then
        FdmSocket.ClientSocket.Socket.SendText(s);
    finally
      CloseFile(f);
    end;
  except
    ShowStatus('Erro ao decodificar arquivo.');
    Raise;
  end;

end;

procedure TMainForm.tmrCheckInterfaceTimer(Sender: TObject);
var
  sr: TSearchRec;
begin
  case fTipoDaInterface of
    tiFlatFiles:
      begin
        if not DirectoryExists(fPastaDeIntercambio) then
        begin
          ShowStatus('Pasta inacessível: ' + QuotedStr(fPastaDeIntercambio));
          ledDataSourceAvailable.Lit := false;
          Exit;
        end;

        ledDataSourceAvailable.Lit := true;
        if not FdmSocket.ClientSocket.Active then
        begin
          ShowStatus
            ('Pasta de interface acessível, mas sistema sem conexão com servidor SICS');
          Exit;
        end;

        if FindFirst(fPastaDeIntercambio + '\*.*', 0, sr) = 0 then
        begin
          repeat
            ShowStatus('Arquivo encontrado: ' + QuotedStr(sr.Name));
            try
              DecodificaArquivo(fPastaDeIntercambio + '\' + sr.Name);
            finally
              if not DeleteFile(fPastaDeIntercambio + '\' + sr.Name) then
                ShowStatus('Erro ao excluir arquivo.');
            end;
          until FindNext(sr) <> 0;
          FindClose(sr);
        end;
      end;
    tiMV:
      begin
        if not sktMV.Active then
          sktMV.Open;

        ledDataSourceAvailable.Lit := (sktMV.Active);
      end;
    tiSilab:
      begin
        if not DirectoryExists(fPastaDeIntercambio) then
        begin
          ShowStatus('Pasta inacessível: ' + QuotedStr(fPastaDeIntercambio));
          ledDataSourceAvailable.Lit := false;
          Exit;
        end;

        if ((fSalvarRespostasArquivos) and (fPastaSaida = '') or
          not(fPastaCriada)) then
          ledPastaDestinoConfigurada.Lit := false
        else
          ledPastaDestinoConfigurada.Lit := true;

        ledDataSourceAvailable.Lit := true;
        if not FdmSocket.ClientSocket.Active then
        begin
          ShowStatus
            ('Pasta de interface acessível, mas sistema sem conexão com servidor SICS');
          Exit;
        end;

        if FindFirst(fPastaDeIntercambio + '\*.*', 0, sr) = 0 then
        begin
          repeat
            ShowStatus('Arquivo encontrado: ' + QuotedStr(sr.Name));
            try
              DecodificaArquivoV5(fPastaDeIntercambio + '\' + sr.Name);
            finally
              if not DeleteFile(fPastaDeIntercambio + '\' + sr.Name) then
                ShowStatus('Erro ao excluir arquivo.');
            end;
          until FindNext(sr) <> 0;
          FindClose(sr);
        end;
      end;
  end;
end;

procedure TMainForm.tmrLogTimer(Sender: TObject);
var
  LAno, LMes, LDia: Word;
begin
  if fTipoDaInterface <> tiREST then
    Exit;

  DecodeDate(Now, LAno, LMes, LDia);

  if Dia <> LDia then
  begin
    try
      tmrLog.Enabled := False;
      Dia := LDia;
      System.TMonitor.Enter(FRESTServer);
      try
        FRESTServer.Intercept := nil;
        IdServerInterceptLogFile.Free;
        IdServerInterceptLogFile := TIdServerInterceptLogFile.Create(Self);
        IdServerInterceptLogFile.Filename := ExtractFilePath(ParamStr(0)) + 'Log_SCC_REST_' + FormatDateTime('DDMMYYYY', Now) + '.log';
        FRESTServer.Intercept := IdServerInterceptLogFile;
      finally
        System.TMonitor.Exit(FRestServer);
      end;
    finally
      tmrLog.Enabled := True;
    end;
  end;
end;

procedure TMainForm.onSocketConnect;
begin
  Color := clBtnFace;
  SetTrayIcon;
end;

procedure TMainForm.onSocketDisconnect;
begin
  //Color := clRed;
  SetTrayIcon;
end;

procedure TMainForm.onSocketError(ErrorCode: Integer);
begin
  ShowStatus(Format('Erro no socket: %d', [ErrorCode]));
end;

procedure TMainForm.FormResize(Sender: TObject);
const
  OFF = 10;
begin
  gridMV.Visible := (fTipoDaInterface = tiMV);

  case fTipoDaInterface of
    tiMV:
      memoStatus.Left := gridMV.Left + gridMV.Width + OFF;
    tiFlatFiles, tiSilab, tiREST, tiHORSE:
      memoStatus.Left := OFF;
  end;

  gridMV.Left := OFF;
  gridMV.Top := OFF;

  memoStatus.Top := OFF;
  memoStatus.Width := ClientWidth - memoStatus.Left - OFF;

  // O led de pasta configurada só aparece quando a chave SalvarRespostasArquivos no arquivo ini estiver true
  if (fSalvarRespostasArquivos) then
    memoStatus.Height := ClientHeight - ledDataSourceAvailable.Height -
      ledPastaDestinoConfigurada.Height - 3 * OFF
  else
    memoStatus.Height := ClientHeight - ledDataSourceAvailable.Height - 3 * OFF;

  gridMV.Height := memoStatus.Height;

  ledDataSourceAvailable.Left := OFF;
  ledDataSourceAvailable.Top := memoStatus.Top + memoStatus.Height + OFF;

  if (fSalvarRespostasArquivos) then
  begin
    ledPastaDestinoConfigurada.Left := OFF;
    ledPastaDestinoConfigurada.Top := memoStatus.Top + memoStatus.Height +
      ledPastaDestinoConfigurada.Height + OFF
  end
  else
    ledPastaDestinoConfigurada.Visible := false;

end;

procedure TMainForm.menuSobreClick(Sender: TObject);
begin
  AppMessageBox(VERSAO + #13#13 + GetExeVersion, 'Sobre...',
    MB_ICONINFORMATION);
end;

procedure TMainForm.menuSairClick(Sender: TObject);
begin
  if Application.MessageBox
    ('Fechando este programa a integração com o SICS deixará de funcionar!!'#13#13'Confirma?',
    'Atenção', MB_ICONWARNING or MB_YESNO) = mrYES then
  begin
    fApertouBotaoSair := true;
    Close;
  end;
end;

procedure TMainForm.TrayIconClick(Sender: TObject);
begin
  // if Button = mbRight then
  // PopUpMenu.Popup(x,y);
end;

procedure TMainForm.TrayIconDblClick(Sender: TObject);
begin
  MainForm.Show;
  Application.Restore;
  Application.BringToFront;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not fApertouBotaoSair then
  begin
    Action := caNone;
    MainForm.Hide;
  end
  else
  begin
    if fTipoDaInterface = tiREST then
      StopRESTServer
    else if fTipoDaInterface = tiHORSE then
      THorse.StopListen
    else if Assigned(FdmSocket) then
      FdmSocket.ClientSocket.Close;

    Action := caFree;
    MainForm := nil;
  end;
end;

procedure TMainForm.ledDataSourceAvailableChangeState(Sender: TObject);
begin
  SetTrayIcon;
end;

procedure TMainForm.sktMVClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  ShowStatus('Fonte de dados MV conectada. IP = ' + Socket.RemoteAddress);
end;

procedure TMainForm.sktMVClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  ShowStatus('Fonte de dados MV desconectada. IP = ' + Socket.RemoteAddress);
end;

procedure TMainForm.sktMVClientError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ShowStatus('Erro na comunicação com fonte de dados MV. Erro = ' +
    inttostr(ErrorCode));
  (Sender as TServerSocket).Close;
  Delay(500);
  (Sender as TServerSocket).Open;
end;

procedure TMainForm.sktMVListen(Sender: TObject; Socket: TCustomWinSocket);
begin
  ShowStatus('Fonte de dados MV escutando.');
end;

procedure TMainForm.sktMVClientRead(Sender: TObject; Socket: TCustomWinSocket);
const
  ReceivingProtocol: boolean = false;
  Protocol: string = '';
var
  i: word;
  s, aux: string;
begin
  s := Socket.ReceiveText;
  ShowStatus('Mensagem recebida da fonte de dados MV: ' + s);

  for i := 1 to length(s) do
  begin
    if s[i] = '!' then
    begin
      ReceivingProtocol := true;
      Protocol := '';
    end
    else if s[i] = '.' then
    begin
      ReceivingProtocol := false;
      if Protocol <> '' then
      begin
        aux := DecifraProtocoloMV(Protocol);
        if aux <> '' then
        begin
          if FdmSocket.ClientSocket.Socket.Connected then
          begin
            ShowStatus('Enviando comando ao servidor SICS.');
            FdmSocket.ClientSocket.Socket.SendText(aux);
          end
          else
            ShowStatus('Não conectado ao servidor SICS. Comando não enviado.');
        end;
      end;

      Protocol := '';
    end
    else if ReceivingProtocol then
      Protocol := Protocol + s[i];
  end; { for }
end;

function TMainForm.DecifraProtocoloMV(s: string): string;
var
  IdPA, sala, Senha: Integer;
begin
  Result := '';
  if ((length(s) = 6) and (s[1] = '#')) then
  begin
    sala := strtoint(Copy(s, 2, 2));
    Senha := strtoint(Copy(s, 4, 3));

    ShowStatus('MV chamando senha ' + inttostr(Senha) + ' para sala ' +
      inttostr(sala) + '.');

    if cdsMV.Locate('Sala', sala, []) then
    begin
      IdPA := cdsMV.fieldbyname('IdPA').AsInteger;
      ShowStatus('Enviando comando ao servidor SICS: chamando senha ' +
        inttostr(Senha) + ' para PA ' + inttostr(IdPA) + '.');
      Result := #2 + inttohex(IdPA, 2) + Chr($30) + inttostr(Senha) + #3;
    end
    else
      ShowStatus('Sala não encontrada na tabela.');
  end
  else
    ShowStatus('Protocolo MV inválido.');
end;

procedure TMainForm.cdsMVAfterPost(DataSet: TDataSet);
begin
  cdsMV.SaveToFile(ExcludeTrailingPathDelimiter(GetApplicationPath) + '\MV.dat',
    dfBinary);
end;

procedure TMainForm.SalvaArquivoResposta(s: String);
var
  vArquivo: textfile;
  vCaminhoArquivo: string;
  vNomeArquivo: string;
begin
  if (fPastaSaida = '') then
    Exit;

  vCaminhoArquivo := fPastaSaida + '\';

  if (not ForceDirectories(vCaminhoArquivo)) then
  begin
    fPastaCriada := false;
    Exit;
  end
  else
    fPastaCriada := true;

  vNomeArquivo := 'SICS_OUT_' + FormatDateTime('ddmmyyyyhhnnsszzz',
    now) + '.txt';

  // se o arquivo existir, da um sleep de 5 ms e gera um novo nome
  if (FileExists(vCaminhoArquivo + vNomeArquivo)) then
  begin
    Sleep(5);
    vNomeArquivo := 'SICS_OUT_' + FormatDateTime('ddmmyyyyhhnnsszzz', now)
      + '.txt';;
  end;
  vCaminhoArquivo := vCaminhoArquivo + vNomeArquivo;
  try
    AssignFile(vArquivo, vCaminhoArquivo);

    Rewrite(vArquivo);

    WriteLn(vArquivo, s);
  finally
    CloseFile(vArquivo);
  end;
  ShowStatus('Arquivo gravado: ' + vNomeArquivo);
end;

procedure TMainForm.onSocketReadException(AException: Exception);
begin
  ShowStatus('Erro ao receber comandos TCP/IP: ' + AException.Message);
end;

procedure TMainForm.StartRESTServer;
begin
  if not FRESTServer.Active then
  begin
    FRESTServer.Bindings.Clear;
    FRESTServer.DefaultPort := FPortaREST;
    FRESTServer.Active := true;
    ShowStatus('Servidor REST iniciado na porta ' + FPortaREST.ToString);
    ShowStatus('     UrlEnviarSenha=' + FUrlEnviaSenha);
    ShowStatus('     Authorization=' + FAuthorization);
    ledDataSourceAvailable.Lit := true;
  end;
end;

procedure TMainForm.StopRESTServer;
begin
  if TDSSessionManager.Instance <> nil then
    TDSSessionManager.Instance.TerminateAllSessions;

  FRESTServer.Active := false;
  FRESTServer.Bindings.Clear;

  ShowStatus('Servidor REST finalizado');
  ledDataSourceAvailable.Lit := False;
end;

procedure TMainForm.StartHorseServer;
begin
  THorse
    .Use(Jhonson())
    .Use(HandleException)
    .Use(OctetStream);

  Controllers.App.Registry;

  THorse.Listen(FHorsePort);
  ShowStatus('Servidor HORSE iniciado na porta ' + FHorsePort.ToString);
  ledDataSourceAvailable.Lit := true;
end;

procedure TMainForm.StopHorseServer;
begin
  THorse.StopListen;
  ShowStatus('Servidor HORSE finalizado');
  ledDataSourceAvailable.Lit := False;
end;

procedure TMainForm.TimerTentarCarregarParametrosUnidadesTimer(Sender: TObject);
begin
  TimerTentarCarregarParametrosUnidades.Enabled := False;
  TentarCarregarDadosUnidades;
end;

end.
