unit LogSQLite.DB;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.FMXUI.Wait, Data.DB,  FireDAC.Comp.Client,
  FireDAC.Stan.ExprFuncs, LogSQLite.Config, LogSQLite, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  System.DateUtils, System.SyncObjs, LogSQLite.LogExceptions;

type
  TLogSQLiteDB = class(TDataModule)
    Con: TFDConnection;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    qryAuxScriptBd: TFDQuery;
    cmdInsert: TFDCommand;
    cmdUpdate: TFDCommand;
    ConPendentes: TFDConnection;
    qryProximoPendente: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
  strict private
    class var FInstance: TLogSQLiteDB;
    const
    CONFIG_KEY_BD_VERSION = 'BD_VERSION';
  private
    FConfigLog: TLogSQLiteConfig;
    FUltimoCleanup: TDateTime;
    FCleaning:boolean;
    FActive: Boolean;
    FQtdLogsPendentes: Integer;
    procedure SetActive(const Value: Boolean);
    procedure DoCleanUp;
    function TabelaExiste(const ATableName: String): Boolean;
    procedure ExecutarScriptsBD;
    procedure ClearFDCommandParamsValues(AFDCommand: TFDCommand);
    function GetLogsPendentes: Boolean;
  public
    property QuantidadePendente: Integer read FQtdLogsPendentes;
    property LogsPendentes: Boolean read GetLogsPendentes;
    property Active: Boolean read FActive write SetActive;

    function ProximoPendente(out AId: Integer): TLogSQLite;
    function ProximoPendenteAsString(out AId: Integer): String;
    function Add(const ALog: TLogSQLite): Boolean;
    function UpdateSending(const AId: Integer; const ARemoteId: String): Boolean;

    class function GetInstance: TLogSQLiteDB;
    class destructor Destroy; //finalization
  end;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

var
  {$REGION '//Scripts de atualização do BD'}
  ScriptsBd: array[1..1] of String = (
     'create table logs( ' +
     '  id integer primary key, ' +
     '  datahora datetime not null, ' +
     '  tipomsg int not null, ' +
     '  categoria int, ' +
     '  versaoexe text, ' +
     '  hostname text, ' +
     '  ip text, ' +
     '  nometotem text, ' +
     '  idtotem int, ' +
     '  nomeunidade text, ' +
     '  idunidade int, ' +
     '  msg text, ' +
     '  logasjson text, ' +
     '  issent int default 0, ' +
     '  sentat datetime, ' +
     '  remoteid text ' +
     ') ' //1
    );
  {$ENDREGION}

{ TLogSQLiteDB }

function TLogSQLiteDB.Add(const ALog: TLogSQLite): Boolean;
begin
  if (not Active) then
    exit(True);

  while FCleaning do
    Sleep(100);

  if (FUltimoCleanup <> Date) then
    DoCleanUp;

  TMonitor.Enter(cmdInsert);
  try
    ClearFDCommandParamsValues(cmdInsert);
    try
      cmdInsert.ParamByName('DATAHORA').AsString := DateToISO8601(ALog.DataHoraUTC, False);
      cmdInsert.ParamByName('TIPOMSG').AsInteger := Integer(ALog.TipoMsg);
      cmdInsert.ParamByName('CATEGORIA').AsInteger := Integer(ALog.Categoria);
      cmdInsert.ParamByName('VERSAOEXE').AsString := ALog.VersaoExe;
      cmdInsert.ParamByName('HOSTNAME').AsString := ALog.HostName;
      cmdInsert.ParamByName('IP').AsString := ALog.IP;
      cmdInsert.ParamByName('NOMETOTEM').AsString := ALog.NomeTotem;
      cmdInsert.ParamByName('IDTOTEM').AsInteger := ALog.IdTotem;
      cmdInsert.ParamByName('NOMEUNIDADE').AsString := ALog.NomeUnidade;
      cmdInsert.ParamByName('IDUNIDADE').AsInteger := ALog.IdUnidade;
      cmdInsert.ParamByName('MSG').AsString := ALog.DetailMsg;
      cmdInsert.ParamByName('LOGASJSON').AsString := ALog.ToJSON;
      cmdInsert.Execute();
      result := True;
      TInterlocked.Increment(FQtdLogsPendentes);
    except
      on E: Exception do
      begin
        result := False;
      end;
    end;
  finally
    TMonitor.Exit(cmdInsert);
  end;
end;

procedure TLogSQLiteDB.ClearFDCommandParamsValues(AFDCommand: TFDCommand);
var
  i: Integer;
begin
  for i := 0 to AFDCommand.Params.Count-1 do
    AFDCommand.Params[0].Clear;
end;

procedure TLogSQLiteDB.DataModuleCreate(Sender: TObject);
begin
  FConfigLog := TLogSQLiteConfig.GetInstance;
  Con.Params.Database := FConfigLog.NomeArquivo;
  ConPendentes.Params.Database := Con.Params.Database;
  FUltimoCleanup := Date-1;
  FCleaning := False;
  Active := FConfigLog.Active;

  //se não está ativo nas configurações, não precisa fazer cleanup nem recuperar
  //a quantidade de logs pendentes
  if not Active then
  exit;

  if (FUltimoCleanup <> Date) and (not FCleaning) then
    DoCleanUp;

  try
    FQtdLogsPendentes := ConPendentes.ExecSQLScalar(
      'select count(*) from logs where issent = 0');
  except
    on E: Exception do
    begin
      FQtdLogsPendentes := 0;
      TLogSQLiteExceptions.Log('Falha ao obter quantidade de logs pendentes na' +
        ' na inicialização: ' + E.Message);
    end;
  end;
end;

class destructor TLogSQLiteDB.Destroy;
begin
  if Assigned(FInstance) then
    FInstance.Free;
end;

procedure TLogSQLiteDB.DoCleanUp;
begin
  try
    FCleaning := True;
    TMonitor.Enter(ConPendentes);
    try
      //fecha a conexão de gerenciamento dos logs pendentes de envio
      ConPendentes.Close;
      //refaz a conexão principal para garantir que não existam transações
      //pendentes, o que impediria o vacuum
      Con.Close;
      Con.Open;
      Con.ExecSQL('delete from logs where ' +
                  'issent > 0 and ' +
                  'datahora < :datahora',
                  [DateToISO8601(Date-FConfigLog.DiasPersistir, False)],
                  [ftString]);
      Con.ExecSQL('vacuum');
      Con.Close;
      Con.Open;
      FUltimoCleanup := Date;
    finally
      FCleaning := False;
      TMonitor.Exit(ConPendentes);
    end;
  except
    on E: Exception do
      begin
        FCleaning := False;
        TLogSQLiteExceptions.Log('Falha ao executar Cleanup: ' + E.Message);
      end;
  end;
end;

class function TLogSQLiteDB.GetInstance: TLogSQLiteDB;
begin
  if not Assigned(FInstance) then
    FInstance := TLogSQLiteDB.Create(nil);
  result := FInstance;
end;

function TLogSQLiteDB.GetLogsPendentes: Boolean;
begin
  result := QuantidadePendente > 0;
end;

function TLogSQLiteDB.ProximoPendenteAsString(out AId: Integer): String;
begin
  try
    TMonitor.Enter(ConPendentes);
    try
      result := EmptyStr;
      qryProximoPendente.Open;
      try
        if not qryProximoPendente.IsEmpty then
        begin
          AId := qryProximoPendente.FieldByName('ID').AsInteger;
          result := qryProximoPendente.FieldByName('LOGASJSON').AsString;
        end;
      finally
        qryProximoPendente.Close;
      end;
    finally
      TMonitor.Exit(ConPendentes);
    end;
  except
    on E: Exception do
    begin
      AId := -1;
      result := EmptyStr;
      TLogSQLiteExceptions.Log('Falha ao obter próximo pendente: ' + E.Message, nil);
    end;
  end;
end;

function TLogSQLiteDB.ProximoPendente(out AId: Integer): TLogSQLite;
var
  LStr: String;
begin
  LStr := ProximoPendenteAsString(AId);
  result := TLogSQLite.FromJSON(LStr);
end;

procedure TLogSQLiteDB.SetActive(const Value: Boolean);
begin
  FActive := Value;
  if Value then
    ExecutarScriptsBD;
end;

function TLogSQLiteDB.TabelaExiste(const ATableName: String): Boolean;
var
  LStrLst: TStringList;
begin
  LStrLst := TStringList.Create;
  try
    LStrLst.CaseSensitive := False;
    Con.GetTableNames('', '', '', LStrLst);
    result := LStrLst.IndexOf(ATableName) > -1;
  finally
    LStrLst.Free;
  end;
end;

function TLogSQLiteDB.UpdateSending(const AId: Integer; const ARemoteId: String): Boolean;
begin
  TMonitor.Enter(ConPendentes);
  try
    ClearFDCommandParamsValues(cmdUpdate);
    try
      cmdUpdate.ParamByName('ISSENT').AsInteger := 1;
      cmdUpdate.ParamByName('SENTAT').AsString := DateToISO8601(Now, False);
      if not ARemoteId.Trim.IsEmpty then
        cmdUpdate.ParamByName('REMOTEID').AsString := ARemoteId;
      cmdUpdate.ParamByName('ID').AsInteger := AId;
      cmdUpdate.Execute();
      result := cmdUpdate.RowsAffected = 1;
      if result then
        TInterlocked.Decrement(FQtdLogsPendentes);
    except
      on E: Exception do
      begin
        result := False;
        TLogSQLiteExceptions.Log('Falha ao atualizar log enviado ' +
          '(ID Local: ' + AId.ToString + ', ID Remoto: ' + ARemoteId + '): ' +
          E.Message, EmptyStr);
      end;
    end;
  finally
    TMonitor.Exit(ConPendentes);
  end;
end;

procedure TLogSQLiteDB.ExecutarScriptsBD;

  procedure InsereCofiguracaoVersaoBD;
  begin
    Con.ExecSQL(
      'INSERT INTO CONFIGURACOES_GERAIS (ID, VALOR) VALUES (' +
       QuotedStr(CONFIG_KEY_BD_VERSION) + ', ''0'' )');
  end;

var
  i, iVersao: integer;
begin
  if not TabelaExiste('CONFIGURACOES_GERAIS') then
  begin
    Con.ExecSQL(
      'CREATE TABLE CONFIGURACOES_GERAIS( ' +
      'ID TEXT NOT NULL, ' +
      'VALOR TEXT, ' +
      'PRIMARY KEY(ID) )');
    InsereCofiguracaoVersaoBD;
    iVersao := 0;
    FUltimoCleanup := Date;
  end
  else
  begin
    qryAuxScriptBd.Open('SELECT VALOR FROM CONFIGURACOES_GERAIS' +
      ' WHERE ID = ' + QuotedStr(CONFIG_KEY_BD_VERSION));
    try
      if qryAuxScriptBd.IsEmpty then
      begin
        InsereCofiguracaoVersaoBD;
        iVersao := 0;
      end
      else
        iVersao := qryAuxScriptBd.FieldByName('VALOR').AsInteger;
    finally
      qryAuxScriptBd.Close;
    end;
  end;

  if iVersao <> High(ScriptsBd) then
    for i := Low(ScriptsBd) to High(ScriptsBd) do
    begin
      if i <= iVersao then
        Continue;

      Con.StartTransaction;
      try
        Con.ExecSQL(ScriptsBd[i]);
        Con.ExecSQL('UPDATE CONFIGURACOES_GERAIS SET ' +
          ' VALOR = ' + QuotedStr(inttostr(i)) +
          ' WHERE ID = ' + QuotedStr(CONFIG_KEY_BD_VERSION));
        Con.Commit;
      except
        Con.Rollback;
        raise;
      end;
    end;
end;

end.
