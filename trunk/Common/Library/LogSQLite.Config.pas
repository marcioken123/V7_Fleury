unit LogSQLite.Config;

interface

uses
  System.SysUtils, System.IniFiles;

type
  TKibanaConfig = class
  strict private
    const
    INI_SESSION = 'LogSQLiteKibana';
    INI_ENDPOINT = 'Endpoint';
    INI_APIKEY = 'ApiKey';
    INI_ACTIVE = 'Ativo';
  private
    FApiKey: String;
    FEndpoint: String;
    FActive: Boolean;
    procedure SetActive(const Value: Boolean);
    procedure Load(AIni: TIniFile);
    constructor Create;
  public
    property Endpoint: String read FEndpoint;
    property ApiKey: String read FApiKey;
    property Active: Boolean read FActive write SetActive;
  end;

  TTotemConfig = class
  strict private
    const
    INI_SESSION = 'Settings';
    INI_NOME_TOTEM = 'NomeTotem';
    INI_ID_TOTEM = 'Totem';
    INI_NOME_UNIDADE = 'NomeUnidade';
    INI_ID_UNIDADE = 'IdUnidade';
  private
    FNome: String;
    FId: Integer;
    FNomeUnidade: String;
    FIdUnidade: Integer;
    constructor Create;
  public
    property Nome: String read FNome;
    property Id: Integer read FId;
    property NomeUnidade: String read FNomeUnidade;
    property IdUnidade: Integer read FIdUnidade;
    procedure Load(AIni: TIniFile);
  end;

  TLogSQLiteConfig = class
  strict private
    class var FInstance: TLogSQLiteConfig;
  const
    INI_INICIO_IP = 'InicioIP';
    INI_SESSION = 'Settings';
  private
    FDiasPersistir: Integer;
    FNomeArquivo: String;
    FNomeMaquina: String;
	  FInicioIP: String;
    FIP: String;
    FKibana: TKibanaConfig;
    FTotem: TTotemConfig;
    FActive: Boolean;
    FLoaded: Boolean;
    FVersaoExe: String;
    FTrackingId: String;
    FTipoFluxo: String;
    procedure SetActive(const Value: Boolean);
    procedure CarregarIPeHostname;
    procedure SetTrackingId(const Value: String);
  public
    property InicioIP: String read FInicioIP;
    property VersaoExe: String read FVersaoExe;
    property NomeArquivo: String read FNomeArquivo;
    property DiasPersistir: Integer read FDiasPersistir;
    property NomeMaquina: String read FNomeMaquina;
    property IP: String read FIP;
    property Kibana: TKibanaConfig read FKibana;
    property Totem: TTotemConfig read FTotem;
    property TrackingId: String read FTrackingId write SetTrackingId;
    property TipoFluxo: String read FTipoFluxo write FTipoFluxo;
    property Active: Boolean read FActive write SetActive;

    class function GetInstance: TLogSQLiteConfig;
    class function IsActive: Boolean;
    class constructor Create; //initialization
    class destructor Destroy; //finalization

    destructor Destroy; override;
    procedure Load(AIni: TIniFile; const AVersaoExe: String);
  end;

implementation

{$IFDEF MSWINDOWS}
uses Winapi.Winsock;
{$ENDIF}

{ TLogConfig }

procedure TLogSQLiteConfig.CarregarIPeHostname;
{$IFDEF MSWINDOWS}
type
  TaPInAddr = array [0..10] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  phe: PHostEnt;
  pptr: PaPInAddr;
  Buffer: array [0..63] of Ansichar;
  i: Integer;
  GInitData: TWSADATA;
  LInicioIP: String;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  WSAStartup($101, GInitData);
  GetHostName(Buffer, SizeOf(Buffer));
  FNomeMaquina := string(Buffer);

  phe := GetHostByName(Buffer);
  if phe = nil then
    Exit;

  LInicioIP := InicioIP.Trim;
  if LInicioIP.Trim.IsEmpty then
    LInicioIP := '.';

  pptr := PaPInAddr(phe^.h_addr_list);
  i := 0;
  while pptr^[i] <> nil do
  begin
    if Pos(LInicioIP, string(inet_ntoa(pptr^[i]^))) > 0 then
      FIP := string(inet_ntoa(pptr^[i]^));
    Inc(i);
  end;
  WSACleanup;
{$ENDIF}
end;

class constructor TLogSQLiteConfig.Create;
var
  LInstance: TLogSQLiteConfig;
begin
  LInstance := GetInstance;
  LInstance.FActive := False;
  LInstance.FVersaoExe := '0';
  LInstance.FDiasPersistir := 30;
  LInstance.FNomeArquivo := 'log.db';
  LInstance.FNomeMaquina := EmptyStr;
  LInstance.FIP := EmptyStr;
  LInstance.FKibana := TKibanaConfig.Create;
  LInstance.FTotem := TTotemConfig.Create;
  LInstance.FLoaded := False;
end;

class destructor TLogSQLiteConfig.Destroy;
begin
  if Assigned(FInstance) then
    FInstance.Free;

  inherited;
end;

destructor TLogSQLiteConfig.Destroy;
begin
  if Assigned(FInstance.Kibana) then
    FInstance.Kibana.Free;

  if Assigned(FInstance.Totem) then
    FInstance.Totem.Free;

  inherited;
end;

class function TLogSQLiteConfig.GetInstance: TLogSQLiteConfig;
begin
  if not Assigned(FInstance) then
    FInstance := TLogSQLiteConfig.Create;
  result := FInstance;
end;

class function TLogSQLiteConfig.IsActive: Boolean;
begin
  result := GetInstance.Active;
end;

procedure TLogSQLiteConfig.Load(AIni: TIniFile; const AVersaoExe: String);
begin
  //Não deixar que as configurações sejam recarregadas, pois o objeto pode estar
  //sendo utilizado por uma Thread, por exemplo
  if FLoaded then
    exit;

  FVersaoExe := AVersaoExe;

  if not Assigned(AIni) then
    exit;

  //leitura
  FNomeArquivo   := 'log.db';
  FDiasPersistir := 30;

  //gravação dos valores default
  FKibana.Load(AIni);

  FTotem.Load(AIni);

//  FInicioIP    := AIni.ReadString( INI_SESSION, INI_INICIO_IP, '127.0.0.1');
//  AIni.WriteString( INI_SESSION, INI_INICIO_IP, FInicioIP);

  CarregarIPeHostname;
  FLoaded := True;

  Active := True;
end;

procedure TLogSQLiteConfig.SetActive(const Value: Boolean);
begin
  if Value <> FActive then
  begin
    if Value then
    begin
      if not FLoaded then
        raise Exception.Create('Não é possível ativar o log antes de Carregar' +
          ' as configurações');
      if (not FTotem.Nome.Trim.IsEmpty) and
         (FTotem.Id > -1) and
         (not FTotem.NomeUnidade.Trim.IsEmpty) and
         (FTotem.IdUnidade > -1) then
      begin
        FActive := Value
      end
      else
        FActive := False;
      {        raise Exception.Create('Necesário configurar IdTotem, NomeTotem,' +
          ' IdUnidade e NomeUnidade antes de ativar o LogSQLite!');}
    end;
  end;
end;

procedure TLogSQLiteConfig.SetTrackingId(const Value: String);
begin
  TMonitor.Enter(FInstance);
  try
    FTrackingId := Value.Trim;
  finally
    TMonitor.Exit(FInstance);
  end;
end;

{ TKibanaConfig }

constructor TKibanaConfig.Create;
begin
  FEndpoint := EmptyStr;
  FApiKey := EmptyStr;
  FActive := False;
end;

procedure TKibanaConfig.Load(AIni: TIniFile);
  function UrlPrefix(const AUrl: String): String; inline;
  begin
    result := AUrl;
    if (not AUrl.Trim.IsEmpty) and (Pos('http', AUrl) = 0) then
      result := 'https://' + AUrl;
  end;
begin
  //leitura
  FEndpoint := UrlPrefix(AIni.ReadString(INI_SESSION, INI_ENDPOINT, FEndpoint));
  FApiKey := AIni.ReadString(INI_SESSION, INI_APIKEY, FApiKey);
  Active := AIni.ReadBool(INI_SESSION, INI_ACTIVE, FActive);

  //gravação dos valores default
  AIni.WriteString(INI_SESSION, INI_ENDPOINT, FEndpoint);
  AIni.WriteString(INI_SESSION, INI_APIKEY, FApiKey);
  AIni.WriteBool(  INI_SESSION, INI_ACTIVE, FActive);
end;

procedure TKibanaConfig.SetActive(const Value: Boolean);
begin
  if Value <> FActive then
  begin
    if Value then
    begin
      if (not FEndpoint.Trim.IsEmpty) and (not FApiKey.Trim.IsEmpty) then
      begin
        FActive := Value
      end
      else
        raise Exception.Create('Necesário configurar Endpoint e ApiKey antes' +
          ' de ativar LogSQLiteKibana');
    end;
  end;
end;

{ TTotemConfig }

constructor TTotemConfig.Create;
begin
  FNome := EmptyStr;
  FId := -1;
  FNomeUnidade := EmptyStr;
  FIdUnidade := -1;
end;

procedure TTotemConfig.Load(AIni: TIniFile);
begin
  //leitura
  FNome        := AIni.ReadString( INI_SESSION, INI_NOME_TOTEM, 'SemNome');
  FId          := AIni.ReadInteger(INI_SESSION, INI_ID_TOTEM, 0);
  FNomeUnidade := AIni.ReadString( INI_SESSION, INI_NOME_UNIDADE, 'SemUnidade');
  FIdUnidade   := AIni.ReadInteger(INI_SESSION, INI_ID_UNIDADE, 0);
  //gravação dos valores default
  AIni.WriteString( INI_SESSION, INI_NOME_TOTEM, FNome);
  AIni.WriteInteger(INI_SESSION, INI_ID_TOTEM, FId);
  AIni.WriteString( INI_SESSION, INI_NOME_UNIDADE, FNomeUnidade);
  AIni.WriteInteger(INI_SESSION, INI_ID_UNIDADE, FIdUnidade);
end;


end.

