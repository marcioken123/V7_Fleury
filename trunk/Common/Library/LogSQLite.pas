unit LogSQLite;

interface

uses System.Classes, System.SysUtils, System.JSON, System.DateUtils;

type
  TTipoMsg = (tmInfo, tmWarning, tmError, tmDebug);
  TTipoMsgHelper = record helper for TTipoMsg
  strict private
    const
    STR_INF = 'info';
    STR_WRN = 'warning';
    STR_ERR = 'error';
    STR_DBG = 'debug';
  public
    function ToString: String;
    function FromString(const AString: String): TTipoMsg;
  end;

  TCategoriaLog = (clNoop, clTef, clRequest, clResponse, clUserAction, clOperationRecord, clFaceRecognition, clConfigurationChannel);
  TCategoriaLogHelper = record helper for TCategoriaLog
  strict private
    const
    STR_NOOP           = '<separador>';
    STR_TEF            = 'TEF';
    STR_REQ_HTTP       = 'Requisição HTTP';
    STR_RES_HTTP       = 'Retorno de Requisição';
    STR_USR_ACT        = 'Ação do Usuário';
    STR_OPER_REC       = 'Registro de Operação';
    STR_FACE_RECOG     = 'Biometria Facial';
    STR_CONFIG_CHANNEL = 'Canal de configuração';
  public
    function ToString: String;
    function FromString(const AString: String): TCategoriaLog;
  end;

  TLogSQLite = class(TObject)
  strict private
    const
    PROP_DATAHORA = '@timestamp'; //specífico para indexação do ElasticSearch/Kibana
    PROP_TIPOMSG = 'tipomsg';
    PROP_CATEGORIA = 'categoria';
    PROP_VERSAOEXE = 'versaoexe';
    PROP_HOSTNAME = 'hostname';
    PROP_IP = 'ip';
    PROP_NOMETOTEM = 'nometotem';
    PROP_IDTOTEM = 'idtotem';
    PROP_NOMEUNIDADE = 'nomeunidade';
    PROP_IDUNIDADE = 'idunidade';
    PROP_DETALHES = 'detalhes';
    PROP_DETAIL_MSG = 'detailmsg';
    PROP_DETAIL_TRACKINGID = 'trackingid';
    PROP_DETAIL_TIPOFLUXO = 'tipofluxo';

    constructor Create; overload;
  private
    FObj: TJSONObject;
    FDetails: TJSONObject;

    procedure DoAddDetail(APair: TJSONPair);
    function GetCategoria: TCategoriaLog;
    function GetDataHoraUTC: TDateTime;
    function GetDetailMsg: String;
    function GetDetails(const Name: string): String;
    function GetHostName: String;
    function GetIdTotem: Integer;
    function GetIP: String;
    function GetNomeTotem: String;
    function GetTipoMsg: TTipoMsg;
    function GetDetailsAsJSON: String;
    function GetVersaoExe: string;
    function GetIdUnidade: Integer;
    function GetNomeUnidade: String;
    function GetDataHoraLocalStr: String;
  public
    property DataHoraUTC: TDateTime read GetDataHoraUTC;
    property DataHoraLocalStr: String read GetDataHoraLocalStr;
    property TipoMsg: TTipoMsg read GetTipoMsg;
    property Categoria: TCategoriaLog read GetCategoria;
    property VersaoExe: string read GetVersaoExe;
    property HostName: String read GetHostName;
    property IP: String read GetIP;
    property NomeTotem: String read GetNomeTotem;
    property IdTotem: Integer read GetIdTotem;
    property NomeUnidade: String read GetNomeUnidade;
    property IdUnidade: Integer read GetIdUnidade;
    property DetailMsg: String read GetDetailMsg;
    property Details[const Name: string]: String read GetDetails;
    property DetailsAsJSON: String read GetDetailsAsJSON;

    constructor Create(ATipoMsg: TTipoMsg; ACategoria: TCategoriaLog;
      const ADetailMsg: String); overload;
    destructor Destroy; override;

    function AddDetail(const AKey, AValue: String): TLogSQLite; overload;
    function AddDetail(const AKey: String; AValue: Integer): TLogSQLite; overload;
    function AddDetail(const AKey: String; AValue: Int64): TLogSQLite; overload;
    function AddDetail(const AKey: String; AValue: Real): TLogSQLite; overload;
    function AddDetail(const AKey: String; AValue: TDateTime): TLogSQLite; overload;
    function AddDetail(const AKey: String; AValue: Boolean): TLogSQLite; overload;
    function AddNullDetail(const AKey: String): TLogSQLite;
    function GetDetail<T>(const Name: String): T;
    function ToString: String; reintroduce;
    function ToJSON: String;
    class function FromJSON(const AJSON: String): TLogSQLite;
    class function New(ATipoMsg: TTipoMsg; ACategoria: TCategoriaLog;
      const ADetailMsg: String): TLogSQLite;
    function Save: Boolean;
  end;

implementation

{ TLogSQLite }

uses LogSQLite.Config, LogSQLite.LogExceptions, LogSQLite.DB;

function TLogSQLite.AddDetail(const AKey, AValue: String): TLogSQLite;
begin
  DoAddDetail( TJSONPair.Create(AKey, AVAlue) );
  result := Self;
end;

function TLogSQLite.AddDetail(const AKey: String; AValue: Integer): TLogSQLite;
begin
  DoAddDetail( TJSONPair.Create(AKey, TJSONNumber.Create(AVAlue)) );
  result := Self;
end;

function TLogSQLite.AddDetail(const AKey: String; AValue: Int64): TLogSQLite;
begin
  DoAddDetail( TJSONPair.Create(AKey, TJSONNumber.Create(AVAlue)) );
  result := Self;
end;

function TLogSQLite.AddDetail(const AKey: String; AValue: Real): TLogSQLite;
begin
  DoAddDetail( TJSONPair.Create(AKey, TJSONNumber.Create(AVAlue)) );
  result := Self;
end;

function TLogSQLite.AddDetail(const AKey: String; AValue: Boolean): TLogSQLite;
begin
  DoAddDetail( TJSONPair.Create(AKey, TJSONBool.Create(AVAlue)) );
  result := Self;
end;

function TLogSQLite.AddDetail(const AKey: String; AValue: TDateTime): TLogSQLite;
begin
  DoAddDetail( TJSONPair.Create(AKey, DateToISO8601(AValue, False)) );
  result := Self;
end;

function TLogSQLite.AddNullDetail(const AKey: String): TLogSQLite;
begin
  DoAddDetail( TJSONPair.Create(AKey, TJSONNull.Create) );
  result := Self;
end;

constructor TLogSQLite.Create;
begin
  inherited;
end;

constructor TLogSQLite.Create(ATipoMsg: TTipoMsg; ACategoria: TCategoriaLog;
  const ADetailMsg: String);
var
  LDataHora: String;
  LConf: TLogSQLiteConfig;
begin
  inherited Create;

  LConf := TLogSQLiteConfig.GetInstance;
  LDataHora := DateToISO8601(Now, False);

  FObj := TJSONObject.Create;
  FObj.AddPair(PROP_DATAHORA, LDataHora);
  FObj.AddPair(PROP_TIPOMSG, ATipoMsg.ToString);
  FObj.AddPair(PROP_CATEGORIA, ACategoria.ToString);
  FObj.AddPair(PROP_VERSAOEXE, LConf.VersaoExe);
  FObj.AddPair(PROP_HOSTNAME, LConf.NomeMaquina);
  FObj.AddPair(PROP_IP, LConf.IP);
  FObj.AddPair(PROP_NOMETOTEM, LConf.Totem.Nome);
  FObj.AddPair(PROP_IDTOTEM, TJSONNumber.Create(LConf.Totem.Id));
  FObj.AddPair(PROP_NOMEUNIDADE, LConf.Totem.NomeUnidade);
  FObj.AddPair(PROP_IDUNIDADE, TJSONNumber.Create(LConf.Totem.IdUnidade));

  FDetails := TJSONObject.Create;
  FObj.AddPair(PROP_DETALHES, FDetails);
  AddDetail(PROP_DETAIL_MSG, ADetailMsg);
  if not LConf.TrackingId.IsEmpty then
    AddDetail(PROP_DETAIL_TRACKINGID, LConf.TrackingId);
  if not LConf.TipoFluxo.IsEmpty then
    AddDetail(PROP_DETAIL_TIPOFLUXO, LConf.TipoFluxo);
end;

destructor TLogSQLite.Destroy;
begin
  FObj.Free;
  inherited;
end;

procedure TLogSQLite.DoAddDetail(APair: TJSONPair);
begin
  FDetails.AddPair(APair);
end;

class function TLogSQLite.FromJSON(const AJSON: String): TLogSQLite;
var
  LObj, LDet: TJSONObject;
begin
  if AJSON.Trim.IsEmpty then
    exit(nil);

  try
    LObj := TJSONObject.ParseJSONValue(AJSON) as TJSONObject;
    if Assigned(LObj) then
    begin
      LDet := LObj.GetValue(result.PROP_DETALHES) as TJSONObject;
      if not Assigned(LDet) then
      begin
        LDet := TJSONObject.Create;
        LObj.AddPair(PROP_DETALHES, LDet);
      end;

      result := TLogSQLite.Create;
      result.FObj := LObj;
      result.FDetails := LDet;
    end
    else
      result := nil;
  except
    on E: Exception do
    begin
      result := nil;
      FreeAndNil(LObj);
      FreeAndNil(LDet);
      TLogSQLiteExceptions.Log('Falha ao criar objeto a partir do JSON: ' + E.Message, AJSON);
    end;
  end;
end;

function TLogSQLite.GetCategoria: TCategoriaLog;
var
  LStr: String;
begin
  FObj.TryGetValue<string>(PROP_CATEGORIA, LStr);
  result.FromString(LStr);
end;

function TLogSQLite.GetDataHoraLocalStr: String;
begin
  FObj.TryGetValue<string>(PROP_DATAHORA, result);
end;

function TLogSQLite.GetDataHoraUTC: TDateTime;
begin
  FObj.TryGetValue<TDateTime>(PROP_DATAHORA, result);
end;

function TLogSQLite.GetDetail<T>(const Name: String): T;
begin
  FDetails.TryGetValue<T>(Name, result);
end;

function TLogSQLite.GetDetailMsg: String;
begin
  FObj.TryGetValue<string>(PROP_DETALHES + '.' + PROP_DETAIL_MSG, result);
end;

function TLogSQLite.GetDetails(const Name: string): String;
begin
  FDetails.TryGetValue<string>(Name, result);
end;

function TLogSQLite.GetDetailsAsJSON: String;
begin
  result := FDetails.ToJSON;
end;

function TLogSQLite.GetHostName: String;
begin
  FObj.TryGetValue<string>(PROP_HOSTNAME, result);
end;

function TLogSQLite.GetIdTotem: Integer;
begin
  FObj.TryGetValue<integer>(PROP_IDTOTEM, result);
end;

function TLogSQLite.GetIdUnidade: Integer;
begin
  FObj.TryGetValue<integer>(PROP_IDUNIDADE, result);
end;

function TLogSQLite.GetIP: String;
begin
  FObj.TryGetValue<string>(PROP_IP, result);
end;

function TLogSQLite.GetNomeTotem: String;
begin
  FObj.TryGetValue<string>(PROP_NOMETOTEM, result);
end;

function TLogSQLite.GetNomeUnidade: String;
begin
  FObj.TryGetValue<string>(PROP_NOMEUNIDADE, result);
end;

function TLogSQLite.GetTipoMsg: TTipoMsg;
var
  LStr: String;
begin
  FObj.TryGetValue<string>(PROP_TIPOMSG, LStr);
  result.FromString(LStr);
end;

function TLogSQLite.GetVersaoExe: string;
begin
  FObj.TryGetValue<string>(PROP_VERSAOEXE, result);
end;

class function TLogSQLite.New(ATipoMsg: TTipoMsg; ACategoria: TCategoriaLog;
  const ADetailMsg: String): TLogSQLite;
begin
  result := Create(ATipoMsg, ACategoria, ADetailMsg);
end;

function TLogSQLite.Save: Boolean;
begin
  result := TLogSQLiteDB.GetInstance.Add(Self);
  Free;
end;

function TLogSQLite.ToJSON: String;
begin
  result := FObj.ToJSON;
end;

function TLogSQLite.ToString: String;
begin
  result := FObj.ToString;
end;

{ TTipoMsgHelper }

function TTipoMsgHelper.FromString(const AString: String): TTipoMsg;
begin
  if AString = STR_INF then
    Self := tmInfo
  else if AString = STR_WRN then
    Self := tmWarning
  else if AString = STR_ERR then
    Self := tmError
  else
    Self := tmDebug;

  result := Self;
end;

function TTipoMsgHelper.ToString: String;
begin
  case Self of
    tmInfo: result := STR_INF;
    tmWarning: result := STR_WRN;
    tmError: result := STR_ERR;
    tmDebug: result := STR_DBG;
  end;
end;

{ TCategoriaLogHelper }

function TCategoriaLogHelper.FromString(const AString: String): TCategoriaLog;
begin
  if AString = STR_NOOP then
    Self := clNoop
  else if AString = STR_TEF then
    Self := clTef
  else if AString = STR_REQ_HTTP then
    Self := clRequest
  else if AString = STR_RES_HTTP then
    Self := clResponse
  else if AString = STR_USR_ACT then
    Self := clUserAction
  else if AString = STR_OPER_REC then
    Self := clOperationRecord
  else
    Self := clFaceRecognition;

  result := Self;
end;

function TCategoriaLogHelper.ToString: String;
begin
  case Self of
    clNoop: result := STR_NOOP;
    clTef: result := STR_TEF;
    clRequest: result := STR_REQ_HTTP;
    clResponse: result := STR_RES_HTTP;
    clUserAction: result := STR_USR_ACT;
    clOperationRecord: result := STR_OPER_REC;
    clFaceRecognition: result := STR_FACE_RECOG;
    clConfigurationChannel: result := STR_CONFIG_CHANNEL;
  end;
end;

end.
