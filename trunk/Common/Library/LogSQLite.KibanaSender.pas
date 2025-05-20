unit LogSQLite.KibanaSender;

(* Exemplo de Retorno da API do Kibana
   StatusCode: 201, e Response:
   {"_index": "totem_hml_tecnico",
    "_type": "_doc",
    "_id": "ux_543kBTqFUmrCQyaCY",
    "_version": 1,
    "result": "created",
    "_shards": {
        "total": 2,
        "successful": 2,
        "failed": 0
    },
    "_seq_no": 2,
    "_primary_term": 2}
*)

interface

uses
  System.Classes, System.SysUtils, LogSQLite, LogSQLite.DB, LogSQLite.Config,
  System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent,
  REST.HttpClient, System.JSON, WinApi.Windows, FMX.Forms;

type
  TLogSQLiteKibanaSender = class;

  TLogSQLiteKibanaSenderManager = class(TObject)
  strict private
    class var FInstance: TLogSQLiteKibanaSenderManager;
    class var FKibanaSender: TLogSQLiteKibanaSender;
  private
  public
    procedure KibanaSenderTerminateEvent(Sender: TObject);
    class procedure InicializarSender;
    class procedure TerminarSender;
  end;

  TLogSQLiteKibanaSender = class(TThread)
  strict private
    FArrayIntervalos: Array of Integer;
    FTentativasEnvio: Integer;
    FEndpoint: String;
    FApiKey: String;
    FLogDB: TLogSQLiteDB;
  private
    function ObterIntervaloDeEspera: Integer;
    procedure InicializarArrayDeIntervalos;
    procedure IncrementarTentativasEnvio;
    procedure RaiseExceptionOnRequestError(const Sender: TObject; const AError: string);
    procedure SendLog(const AId: Integer; ALog: String); overload;
  protected
    procedure Execute; override;
  public
    constructor Create(const Endpoint, ApiKey: String);
  end;

implementation

{ LogSQLiteKibanaSender }

uses LogSQLite.LogExceptions;

constructor TLogSQLiteKibanaSender.Create(const Endpoint, ApiKey: String);
begin
  inherited Create(True);
  FreeOnTerminate := True;
  FEndpoint := Endpoint;
  FApiKey := ApiKey;
  FLogDB := TLogSQLiteDB.GetInstance;
  FTentativasEnvio := 0;
  InicializarArrayDeIntervalos;
end;

procedure TLogSQLiteKibanaSender.InicializarArrayDeIntervalos;
begin
  {$IFDEF DEBUG}
  SetLength(FArrayIntervalos, 6);
  FArrayIntervalos[0] := 100;    //100ms
  FArrayIntervalos[1] := 2000;   //  2s
  FArrayIntervalos[2] := 5000;   //  5s
  FArrayIntervalos[3] := 10000;  // 10s
  FArrayIntervalos[4] := 20000;  // 20s
  FArrayIntervalos[5] := 600000; // 10m
  {$ELSE}
  SetLength(FArrayIntervalos, 6);
  FArrayIntervalos[0] := 100;    //100ms
  FArrayIntervalos[1] := 5000;   //  5s
  FArrayIntervalos[2] := 30000;  // 30s
  FArrayIntervalos[3] := 60000;  //  1m
  FArrayIntervalos[4] := 300000; //  5m
  FArrayIntervalos[5] := 600000; // 10m
  {$ENDIF}
end;

procedure TLogSQLiteKibanaSender.IncrementarTentativasEnvio;
begin
  if FTentativasEnvio < High(FArrayIntervalos) then
    Inc(FTentativasEnvio);
end;

procedure TLogSQLiteKibanaSender.Execute;
var
  LTempoDeEspera: Integer;
  LLog: String;
  LId: Integer;
begin
  NameThreadForDebugging('LogSQLiteKibanaSender');

  while not Terminated do
  begin
    LTempoDeEspera := ObterIntervaloDeEspera;
    for var i := 0 to LTempoDeEspera do
    begin
      Sleep(1);
      if Terminated then
        Exit;
    end;

    LId := 0;
    LLog := EmptyStr;
    try
      if FLogDB.LogsPendentes then
      begin
        {$IFDEF DEBUG}OutputDebugString('Logs Pendentes! Recuperando...');{$ENDIF}
        LLog := FLogDB.ProximoPendenteAsString(LId);
        if not LLog.Trim.IsEmpty then
        begin
          {$IFDEF DEBUG}OutputDebugString(PChar('Enviando Log ' + LId.ToString));{$ENDIF}
          SendLog(LId, LLog);
          FTentativasEnvio := 0;
        end;
      end;
    except
      on E: EHTTPProtocolException do
      begin
        IncrementarTentativasEnvio;
        TLogSQLiteExceptions.Log('Falha enviar log (ID Local: ' + LId.ToString + '): [' + E.ErrorCode.ToString + '] ' + E.ErrorMessage + ' - ' + E.Message, LLog);
      end;

      on E: Exception do
      begin
        IncrementarTentativasEnvio;
        TLogSQLiteExceptions.Log('Falha ao processar logs para envio (ID Local: ' + LId.ToString + '): ' + E.Message, LLog);
      end;
    end;
  end;
end;

function TLogSQLiteKibanaSender.ObterIntervaloDeEspera: Integer;
begin
  result := FArrayIntervalos[FTentativasEnvio];
end;

procedure TLogSQLiteKibanaSender.SendLog(const AId: Integer; ALog: String);
var
  LRemoteId: String;
  LAtualizou: Boolean;
  LCli: TNetHTTPClient;
  LReq: TNetHTTPRequest;
  LBody: TStringStream;
  LResponse: IHTTPResponse;
  LRespJSON: TJSONObject;
begin
  LBody := TStringStream.Create(ALog);
  try
    LCli := TNetHTTPClient.Create(nil);
    try
      LCli.ContentType := 'application/json';
      LCli.ConnectionTimeout := 30000;
      LCli.ResponseTimeout := 30000;

      LReq := TNetHTTPRequest.Create(nil);
      try
        LReq.Client := LCli;
        LReq.URL := FEndpoint;
        LReq.CustomHeaders['Authorization'] := 'ApiKey ' + FApiKey;
        LReq.OnRequestError := RaiseExceptionOnRequestError;
        LResponse := LReq.Post(LReq.URL, LBody);
        if not (LResponse.StatusCode in [200,201])  then
          raise EHTTPProtocolException.Create(
            LResponse.StatusCode,
            LResponse.StatusText,
            LResponse.ContentAsString);
        {$IFDEF DEBUG}OutputDebugString('Enviado');{$ENDIF}
      finally
        LReq.Free;
      end;
    finally
      LCli.Free;
    end;
  finally
    LBody.Free;
  end;

  LRemoteId := EmptyStr;
  LRespJSON := TJSONObject.ParseJSONValue(LResponse.ContentAsString) as TJSONObject;
  if Assigned(LRespJSON) then
    try
      LRespJSON.TryGetValue('_id', LRemoteId);
    finally
      LRespJSON.Free;
    end;

  {$IFDEF DEBUG}OutputDebugString(PChar('Atualizando Log com Id Remoto (' + LRemoteId + ')'));{$ENDIF}
  LAtualizou := FLogDB.UpdateSending(AId, LRemoteId);
  {$IFDEF DEBUG}
    if LAtualizou then
      OutputDebugString(PChar('Log ' + AId.ToString + ' atualizado'))
    else
      OutputDebugString(PChar('Falha ao atualizar o log ' + AId.ToString + '. Veja o log de exceções!'));
  {$ENDIF}

  if LAtualizou and LRemoteId.Trim.IsEmpty then
    TLogSQLiteExceptions.Log('Log local (ID ' + AId.ToString + ') atualizado sem ID Remoto', ALog);
end;

procedure TLogSQLiteKibanaSender.RaiseExceptionOnRequestError(
  const Sender: TObject; const AError: string);
begin
  raise Exception.Create(AError);
end;

{ TKibanaSenderTerminateObject }

class procedure TLogSQLiteKibanaSenderManager.TerminarSender;
begin
  if Assigned(FKibanaSender) then
  begin
    FKibanaSender.Terminate;
    while Assigned(FKibanaSender) do
    begin
      sleep(250);
      Application.ProcessMessages;
    end;
    //***KM: Interessante fazer algum timeout aqui para não correr o risco de ficar preso eternamente
  end;
  if Assigned(FInstance) then
    FInstance.Free;
end;

class procedure TLogSQLiteKibanaSenderManager.InicializarSender;
var
  LConf: TLogSQLIteConfig;
begin
  if Assigned(FKibanaSender) then
    exit;

  FInstance := TLogSQLiteKibanaSenderManager.Create;
  LConf := TLogSQLiteConfig.GetInstance;
  FKibanaSender := TLogSQLiteKibanaSender.Create(LConf.Kibana.Endpoint, LConf.Kibana.ApiKey);
  FKibanaSender.OnTerminate := FInstance.KibanaSenderTerminateEvent;
  FKibanaSender.Start;
end;

procedure TLogSQLiteKibanaSenderManager.KibanaSenderTerminateEvent(Sender: TObject);
begin
  FKibanaSender := nil;
end;

end.
