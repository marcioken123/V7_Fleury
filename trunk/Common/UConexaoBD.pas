unit UConexaoBD;

interface

uses System.Classes, System.SysUtils, FireDAC.Comp.Client, FireDAC.DApt, System.JSON,
  System.StrUtils, System.SyncObjs, FireDAC.Stan.Intf;

type
  TTipoBanco = (tbFireBird, tbSqlServer);

type
  TConexaoBD = class
  strict private
    class var FCriticalSection1: TCriticalSection;
    class var FCriticalSection2: TCriticalSection;
    class var FNome: string;
  private
    class var FDriver: TTipoBanco;
    class var FDir: String;
    class var FHost: String;
    class var FBanco: String;
    class var FSenha: String;
    class var FUsuario: String;
    class var FOSAuthent: Boolean;
    class var FNomeUnidade: String;
    class var FIdUnidade: Integer;
    class var FFDManager: TFDManager;
    class procedure SetBanco(const Value: String); static;
    class procedure SetDir(const Value: String); static;
    class procedure SetHost(const Value: String); static;
    class procedure SetOSAuthent(const Value: Boolean); static;
    class procedure SetSenha(const Value: String); static;
    class procedure SetUsuario(const Value: String); static;
    class procedure SetNomeUnidade(const Value: String); static;
    class procedure SetIdUnidade(const Value: Integer); static;
    class procedure UpdateDriver; static;
  public
    class procedure Configurar(oFDManager: TFDManager);
    class procedure DefinirQueriesComoUnidirectional(Sender: TComponent);
    class function  TabelaExiste(Tabela: String; oConexao: TFDConnection): Boolean;
    class function ToJSON: TJSONObject;
    class procedure FromJSON(AJSONObject: TJSONObject); overload;
    class procedure FromJSON(AJSONObject: TJSONObject; AFDManager: TFDManager); overload;
    class procedure Reset;
    class function NomeBasePadrao(const AIdUnidade: Integer = -1): String;
    class procedure CheckFirebirdLocalHost(const AServerAddress: String); static;

    class function GetConnection(pDBDir, pHost, pBanco, pUsuario, pSenha: String; pOSAuthent: Boolean): String; overload;
    class function GetConnection(pDBDir, pHost, pBanco, pUsuario, pSenha: String; pOSAuthent: Boolean; pIDUnidade: Integer): String; overload;
    class property Nome        : String read FNome;
    class property Dir         : String read FDir write SetDir;
    class property Host        : String read FHost write SetHost;
    class property Banco       : String read FBanco write SetBanco;
    class property Usuario     : String read FUsuario write SetUsuario;
    class property Senha       : String read FSenha write SetSenha;
    class property OSAuthent   : Boolean read FOSAuthent write SetOSAuthent;
    class property Driver      : TTipoBanco read FDriver;
    class property NomeUnidade : String read FNomeUnidade write SetNomeUnidade;
    class property IdUnidade   : Integer read FIdUnidade write SetIdUnidade;
    class function ConnectionDefs: IFDStanConnectionDefs;

    class constructor Create;
    class destructor Destroy;
  end;


implementation

uses FireDAC.Phys.Intf;

{ TConexaoBD }

class procedure TConexaoBD.Configurar(oFDManager: TFDManager);
var
  oParams: TStrings;
begin
  oParams    := TStringList.Create;
  try
    FNome := NomeBasePadrao + IdUnidade.ToString;

    UpdateDriver;

    case Driver of
      tbFireBird : begin
                     oParams.Add('DriverID=FB');
                     oParams.Add('Database=' + Dir);
                     oParams.Add('User_Name=SYSDBA');
                     oParams.Add('Password=masterkey');

                     if not oFDManager.IsConnectionDef(Nome) then
                       oFDManager.AddConnectionDef(Nome, 'FB', oParams, True)
                     else
                       oFDManager.ModifyConnectionDef(Nome, oParams);
                   end;

      tbSqlServer : begin
                      oParams.Add('DriverID=MSSQL');
                      oParams.Add('Server='    + Host);
                      oParams.Add('Database='  + Banco);
                      oParams.Add('User_Name=' + Usuario);
                      oParams.Add('Password='  + Senha);
                      oParams.Add('OSAuthent=' + IfThen(OSAuthent, 'Yes', 'No'));

                      if not oFDManager.IsConnectionDef(Nome) then
                        oFDManager.AddConnectionDef(Nome, 'MSSQL', oParams, True)
                      else
                        oFDManager.ModifyConnectionDef(Nome, oParams);
                    end;
    end;
  finally
    //oFDManager.ConnectionDefFileName := 'd:\temp\DefFileName.ini';
    //oFDManager.SaveConnectionDefFile;
    FreeAndNil(oParams);
  end;
end;

class function TConexaoBD.ConnectionDefs: IFDStanConnectionDefs;
begin
  Result := FFDManager.ConnectionDefs;
end;

class procedure TConexaoBD.DefinirQueriesComoUnidirectional(Sender: TComponent);
var iCount: Integer;
begin
  for iCount := 0 to Sender.ComponentCount - 1 do
    if (Sender.Components [iCount] is TFDQuery) then
    begin
      (Sender.Components [iCount] as TFDQuery).FetchOptions.Unidirectional := True;
      (Sender.Components [iCount] as TFDQuery).ConnectionName := TConexaoBD.Nome;
    end;
end;

class constructor TConexaoBD.Create;
begin
  FCriticalSection1 := TCriticalSection.Create;
  FCriticalSection2 := TCriticalSection.Create;
end;

class destructor TConexaoBD.Destroy;
begin
  FCriticalSection1.Free;
  FCriticalSection2.Free;
end;

class procedure TConexaoBD.Reset;
begin
  FNome        := EmptyStr;
  FDir         := EmptyStr;
  FHost        := EmptyStr;
  FBanco       := EmptyStr;
  FUsuario     := EmptyStr;
  FSenha       := EmptyStr;
  FOSAuthent   := False;
  FNomeUnidade := EmptyStr;
  FIdUnidade   := 0;
end;

class procedure TConexaoBD.SetBanco(const Value: String);
begin
  FBanco := Value;
end;

class procedure TConexaoBD.SetDir(const Value: String);
begin
  FDir := Value;
end;

class procedure TConexaoBD.SetHost(const Value: String);
begin
  FHost := Value;
end;

class procedure TConexaoBD.SetIdUnidade(const Value: Integer);
begin
  FIdUnidade := Value;
end;

class procedure TConexaoBD.SetNomeUnidade(const Value: String);
begin
  FNomeUnidade := Value;
end;

class procedure TConexaoBD.SetOSAuthent(const Value: Boolean);
begin
  FOSAuthent := Value;
end;

class procedure TConexaoBD.SetSenha(const Value: String);
begin
  FSenha := Value;
end;

class procedure TConexaoBD.SetUsuario(const Value: String);
begin
  FUsuario := Value;
end;

class function TConexaoBD.TabelaExiste(Tabela: String;
  oConexao: TFDConnection): Boolean;
var oListaTabelas: TStrings;
begin
//  Result        := False;

  oListaTabelas := TStringList.Create;
  try
    oConexao.GetTableNames('','','',oListaTabelas,[osMy],[tkTable],false);

    Result := (oListaTabelas.IndexOf(Tabela) >= 0);
  finally
    FreeAndNil(oListaTabelas);
  end;
end;

class function TConexaoBD.ToJSON: TJSONObject;
begin
  result := TJSONObject.Create;
  result.AddPair('Dir', Dir);
  result.AddPair('Host', Host);
  result.AddPair('Banco', Banco);
  result.AddPair('Senha', Senha);
  result.AddPair('Usuario', Usuario);
  result.AddPair('OSAuthent', TJSONBool.Create(OSAuthent));
  result.AddPair('NomeUnidade', NomeUnidade);
  result.AddPair('IdUnidade', TJSONNumber.Create(IdUnidade));
end;

class procedure TConexaoBD.FromJSON(AJSONObject: TJSONObject);
begin
  Reset;

  AJSONObject.TryGetValue('Dir', FDir);
  AJSONObject.TryGetValue('Host', FHost);
  AJSONObject.TryGetValue('Banco', FBanco);
  AJSONObject.TryGetValue('Senha', FSenha);
  AJSONObject.TryGetValue('Usuario', FUsuario);
  AJSONObject.TryGetValue('OSAuthent', FOSAuthent);
  AJSONObject.TryGetValue('NomeUnidade', FNomeUnidade);
  AJSONObject.TryGetValue('IdUnidade', FIdUnidade);

  UpdateDriver;
end;

class procedure TConexaoBD.FromJSON(AJSONObject: TJSONObject; AFDManager: TFDManager);
begin
  FromJSON(AJSONObject);
  Configurar(AFDManager);
end;

class function TConexaoBD.GetConnection(pDBDir, pHost, pBanco, pUsuario, pSenha: String; pOSAuthent: Boolean): String;
begin
  FCriticalSection1.Enter;
  try
    TConexaoBD.Dir       := pDBDir;
    TConexaoBD.Host      := pHost;
    TConexaoBD.Banco     := pBanco;
    TConexaoBD.Usuario   := pUsuario;
    TConexaoBD.Senha     := pSenha;
    TConexaoBD.OSAuthent := pOSAuthent;
    TConexaoBD.Configurar(FFDManager);

    Result := TConexaoBD.Nome;
  finally
    FCriticalSection1.Leave;
  end;
end;

class function TConexaoBD.GetConnection(pDBDir, pHost, pBanco, pUsuario, pSenha: String; pOSAuthent: Boolean;
  pIDUnidade: Integer): String;
begin
  FCriticalSection2.Enter;
  try
    TConexaoBD.IdUnidade := pIDUnidade;
    Result := TConexaoBD.GetConnection(pDBDir, pHost, pBanco, pUsuario, pSenha, pOSAuthent);
  finally
    FCriticalSection2.Leave;
  end;
end;

class function TConexaoBD.NomeBasePadrao(const AIdUnidade: Integer = -1): String;
begin
  result := 'ConexaoBD';
  if AIdUnidade >= 0 then
    result := result + AIdUnidade.ToString;
end;

class procedure TConexaoBD.UpdateDriver;
begin
  if (Dir <> EmptyStr) then
    FDriver := tbFireBird
  else
    FDriver := tbSqlServer;
end;

class procedure TConexaoBD.CheckFirebirdLocalHost(const AServerAddress: String);
var
  LStringConexao, LPathDB, LServidor: String;
begin
  if Dir.Trim.IsEmpty then
  begin
    Exit;
  end;

  LStringConexao := Dir;
  LPathDB        := Copy(LStringConexao, Pred(Pos(':\', LStringConexao)));
  LServidor      := StringReplace(LStringConexao, LPathDB, '', [rfReplaceAll]);
  if (LServidor = '127.0.0.1:') or (LowerCase(LServidor) = 'localhost:') then
    LServidor := '';

  if LServidor = '' then
    Dir := AServerAddress + ':' + LPathDB;
end;

end.
