unit uSMAA;

interface

//uses
//  System.SysUtils, System.Classes, Datasnap.DSServer, System.JSON,
//  Datasnap.DSAuth, Datasnap.DSProviderDataModuleAdapter, uSMBase;
uses System.SysUtils, System.Classes, System.Json,
    DataSnap.DSProviderDataModuleAdapter,
    Datasnap.DSServer, Datasnap.DSAuth, uSMBase, Datasnap.DSHTTPWebBroker,
    Data.DBXPlatform, FireDAC.Comp.Client, FireDAC.Stan.Intf, Data.DB,
  FireDAC.Comp.DataSet;

type
{$METHODINFO ON}
  TAutoAtendimento = class(TsmBase)
  private
    { Private declarations }
  public
    { Public declarations }
    function updateIniciarAtendimento(const aParams: TJSONObject): TJSONObject;
    function updateAtualizarAtendimento(const aParams: TJSONObject): TJSONObject;
    function updateFinalizarAtendimento(const aParams: TJSONObject): TJSONObject;
    //function updateConsultarRegistro(const aParams: TJSONObject): TJSONObject;
    function ObterAtendimento(const AIdUnidade, ATrackingID: string): TJSONObject;
    procedure TryConnect(SQLConn: TFDCustomConnection);
    procedure QueryBeforeOpen(DataSet: TFDDataSet);
  end;
  //apenas para expor a URI sem o prefixo "T"
  AA = class(TAutoAtendimento);
{$METHODINFO OFF}

implementation

uses
  uConsts, System.StrUtils, System.Types, uLibDatasnap,
  Vcl.Imaging.jpeg, UConexaoBD, SCC_m, udmControleDeTokens, Winapi.Windows,
  ASPGenerator, FireDAC.Stan.Option;

const
  CHAVE_SUCESSO      = 'Sucesso';
  CHAVE_MOTIVO       = 'motivo';
  CHAVE_TOTEM        = 'Totem';
  CHAVE_UNIDADE      = 'idUnidade';

{$R *.dfm}

{ TAutoAtendimento }

procedure TAutoAtendimento.QueryBeforeOpen(DataSet: TFDDataSet);
begin
  TryConnect(tFDQuery(DataSet).Connection);
  // ...
end;

procedure TAutoAtendimento.TryConnect(SQLConn: TFDCustomConnection);
var
  i: Integer;
  Error: String;
begin
  i := 0;
  SQLConn.Close;
  SQLConn.ConnectionDefName := TConexaoBD.NomeBasePadrao(SQLConn.Tag);

  while (not SQLConn.Connected) and (i < 3) do
  begin
    try
      i := i + 1;

      SQLConn.Connected := True;
    except
    on e: exception do
    begin
      Error := Error + ' ' + e.Message;
      TLibDataSnap.UpdateStatus('Não foi possível conectar ao banco de dados.' + Error, IdUnidade);
      raise Exception.Create('Não foi possível conectar ao banco de dados.');
      Sleep(500);
    end;
    end;
  end;

  if i = 3 then
  begin
    TLibDataSnap.UpdateStatus('Não foi possível conectar ao banco de dados.' + Error, IdUnidade);
    raise Exception.Create('Não foi possível conectar ao banco de dados.');
  end;
end;

function TAutoAtendimento.ObterAtendimento(const AIdUnidade, ATrackingID: string): TJSONObject;
const
  P_IDUNIDADE          = 'AIdUnidade';
  P_TRACKINGID         = 'ATrackingID';

var
  LConexao                : TFDConnection;
  LSQL_Select             : String;
  LJSON                   : TJSONObject;
  LQuery                  : TFDQuery;
begin
  try
    if dmControleDeTokens.ChecarComandoDuplicado('get Totem/Parametros', ATrackingID) then
      raise Exception.Create('Token duplicado');

    LConexao := TFDConnection.Create(Self);
    try
       {$REGION 'Configurar objeto de conexão'}
      try
        LConexao.Close;
        LConexao.LoginPrompt := False;
        LConexao.ConnectionDefName := TConexaoBD.NomeBasePadrao(StrToInt(AIdUnidade));
        LConexao.Tag := StrToInt(AIdUnidade);
        //LConexao.Open;
      except
        on E: Exception do
        begin
          raise Exception.Create('Erro ao configurar objeto de conexão');
        end;
      end;
      {$ENDREGION}

      {$REGION 'Get dos parametros no banco'}
      LQuery := TFDQuery.Create(nil);
      try
        LQuery.Connection := LConexao;
        try
          LSQL_Select := 'SELECT ID, ID_TIPOFLUXO, ID_TOTEM, ID_RESULTADO, ' + sLineBreak +
                         'ID_FILAENCAMINHAMENTO, TRACKINGID, QTDPESSOAS,  ' + sLineBreak +
                         'INICIO, FIM, DURACAO_SEGUNDOS ' + sLineBreak +
                         'FROM AA ' + sLineBreak +
                         'WHERE REPLACE(REPLACE(TRACKINGID, ''{'', ''''), ''}'', '''') = %s';

          LQuery.Close;
          LQuery.SQL.Text := Format(LSQL_Select, [ATrackingID.QuotedString]);
          LQuery.Open;

          LJSON := TJSONObject.Create;

          if not LQuery.eof then
          begin
            LJSON.AddPair('ID', LQuery.FieldByName('ID').AsString);
            LJSON.AddPair('ID_TIPOFLUXO', LQuery.FieldByName('ID_TIPOFLUXO').AsString);
            LJSON.AddPair('ID_TOTEM', LQuery.FieldByName('ID_TOTEM').AsString);
            LJSON.AddPair('ID_RESULTADO', LQuery.FieldByName('ID_RESULTADO').AsString);
            LJSON.AddPair('ID_FILAENCAMINHAMENTO', LQuery.FieldByName('ID_FILAENCAMINHAMENTO').AsString);
            LJSON.AddPair('TRACKINGID', LQuery.FieldByName('TRACKINGID').AsString);
            LJSON.AddPair('QTDPESSOAS', LQuery.FieldByName('QTDPESSOAS').AsString);
            LJSON.AddPair('INICIO', LQuery.FieldByName('INICIO').AsString);
            LJSON.AddPair('FIM', LQuery.FieldByName('FIM').AsString);
            LJSON.AddPair('DURACAO_SEGUNDOS', LQuery.FieldByName('DURACAO_SEGUNDOS').AsString);
          end
          else
            LJSON.AddPair('result', 'Nenhum registro foi encontrado');

          LConexao.Close;
          Result := LJSON;
          MainForm.ShowStatus('Retornados os parâmetros do Totem ID ' + ATrackingID);
        except
          on E: Exception do
          begin
            MainForm.ShowStatus('Erro ao retornar os parâmetros do Totem ID ' + ATrackingID + '. Erro: ' + E.Message);
            raise Exception.Create('Erro ao executar comando SQL: ' + E.Message);
          end;
        end;
      finally
        FreeAndNil(LQuery);
      end;
      {$ENDREGION}
    finally
      FreeAndNil(LConexao);
    end;
  except
    on E: Exception do begin
      TLibDataSnap.UpdateStatus('Totem.updateParametros. ' + E.Message, IdUnidade);
      raise Exception.Create('Error parsing input params:' + E.Message);
    end;
  end;
end;

function TAutoAtendimento.updateIniciarAtendimento(const aParams: TJSONObject): TJSONObject;
const
  P_TOTEM              = 'AIdTotem';
  P_IDUNIDADE          = 'AIdUnidade';
  P_TRACKINGID         = 'ATrackingID';
  P_TRANSACAODATA      = 'Data';
  P_TRANSACAODESCRICAO = 'Descricao';
  P_TRANSACAOVALOR     = 'Valor';
  P_IDFLUXO            = 'AIdFluxo';

  CHAVE_SUCESSO      = 'Sucesso';
  CHAVE_MOTIVO       = 'motivo';
  CHAVE_TOTEM        = 'Totem';
  CHAVE_UNIDADE      = 'idUnidade';

var
  LConexao: TFDConnection;
  LQuery: TFDQuery;
  LSQL_Select:  String;

  AIdUnidade, AIdTotem, ATrackingID: String;
begin
  try
    TLibDataSnap.ValidateInputParams(aParams, [P_IDUNIDADE, P_TOTEM, P_TRACKINGID]);

    AIdUnidade := aParams.Values[P_IDUNIDADE].Value;
    AIdTotem := aParams.Values[P_TOTEM].Value;
    ATrackingID := aParams.Values[P_TRACKINGID].Value;
    //AIdFluxo := aParams.Values[P_IDFLUXO].Value;

    if dmControleDeTokens.ChecarComandoDuplicado('get AA/IniciarAtendimento', AIdUnidade) then
      raise Exception.Create('Token duplicado');

    LConexao := TFDConnection.Create(Self);
    try
      {$REGION 'Configurar objeto de conexão'}
    try
      LConexao.Close;
      LConexao.LoginPrompt := False;
      LConexao.ConnectionDefName := TConexaoBD.NomeBasePadrao(StrToInt(AIdUnidade));
      LConexao.Tag := StrToInt(AIdUnidade);
      LConexao.Open;

      //if (not TConexaoBD.TabelaExiste('AA', LConexao)) or (not TConexaoBD.TabelaExiste('CONFIGURACOES_GERAIS', LConexao)) then
        //Exit;
    except
      on E: Exception do
      begin
        raise Exception.Create('Erro ao configurar objeto de conexão' + E.Message);
      end;
    end;
    {$ENDREGION}
      LSQL_Select := 'INSERT INTO AA (ID, ID_TIPOFLUXO, ID_TOTEM, ID_RESULTADO, ID_FILAENCAMINHAMENTO, '+ sLineBreak +
                     'TRACKINGID, QTDPESSOAS, INICIO, FIM, DURACAO_SEGUNDOS) ' + sLineBreak +
                     'VALUES (' + sLineBreak +
                     TGenerator.NGetNextGenerator_V6('GEN_ID_AA', LConexao).ToString + ', ' + sLineBreak +
                     'NULL,' + sLineBreak + // ID_TIPOFLUXO
                     AIdTotem + ','+ sLineBreak + // ID_TOTEM
                     'NULL,' + sLineBreak +  // ID_RESULTADO
                     'NULL,' + sLineBreak +  // ID_FILAENCAMINHAMENTO
                     ATrackingID.QuotedString + ', ' + sLineBreak +
                     '0,' + sLineBreak + // QTDPESSOAS
                     FormatDateTime('YYYY-MM-DD HH:NN:SS', Now).QuotedString + ', ' + sLineBreak + // INICIO
                     'NULL,' + sLineBreak + // FIM
                     '0)'; // DURACAO_SEGUNDOS

    {$REGION 'Get da imagem no banco'}
      LQuery := TFDQuery.Create(nil);
      LQuery.Connection := LConexao;
      LQuery.BeforeExecute := QueryBeforeOpen;
      try
        LQuery.Close;
        LQuery.SQL.Text := LSQL_Select;
        LQuery.ExecSQL;
      except
        on E: Exception do
        begin
          raise Exception.Create('Erro ao executar comando SQL: ' + LSQL_Select + ' ' + E.Message + ' - ' + LConexao.ConnectionDefName + ' - ' + LConexao.Params.Database);
        end;
      end;
    {$ENDREGION}
    finally
      FreeAndNil(LQuery);
      FreeAndNil(LConexao);
    end;

    Result := TJSONObject.Create;
    Result.AddPair(CHAVE_SUCESSO, TJSONTrue.Create);

    TLibDataSnap.UpdateStatus('AA.updateIniciarAtendimento: ' + Result.ToString, AIdUnidade);

    //GetDataSnapWebModule.Response.StatusCode := 200;
    //GetDataSnapWebModule.Response.Content := LJSON.ToString;
    //GetDataSnapWebModule.Response.SendResponse;
  except
    on E: Exception do
    begin
      Result := TJSONObject.Create;
      Result.AddPair(CHAVE_SUCESSO, TJSONFalse.Create);

      TLibDataSnap.UpdateStatus('AA.updateIniciarAtendimento. ' + E.Message, IdUnidade);
      raise Exception.Create('Erro: ' + E.Message);

      //GetDataSnapWebModule.Response.StatusCode := 404;
      //GetDataSnapWebModule.Response.Content := LJSON.ToString;
      //GetDataSnapWebModule.Response.SendResponse;
    end;
  end;
end;

function TAutoAtendimento.updateAtualizarAtendimento(const aParams: TJSONObject): TJSONObject;
const
  P_IDUNIDADE          = 'AIdUnidade';
  P_TRACKINGID         = 'ATrackingID';
  P_IDRESULTADO        = 'AIdResultado';
  P_IDFLUXO            = 'AIdFluxo';
  P_FILA               = 'AIdFila';
  P_QTDPESSOAS         = 'AQtdPessoas';
  P_SENHA              = 'ASenha';

var
  LConexao: TFDConnection;
  LQuery: TFDQuery;
  LSQL_AA:  String;
  LSQL_TICKETS:  String;

  AIdUnidade, AIdResultado, ATrackingID,
  AIdFluxo, AIdFila, AQtdPessoas, ASenha: String;
begin
  try
    if dmControleDeTokens.ChecarComandoDuplicado('get AA/AtualizarAtendimento', AIdUnidade) then
      raise Exception.Create('Token duplicado');

    TLibDataSnap.ValidateInputParams(aParams, [P_IDUNIDADE, P_TRACKINGID, P_IDRESULTADO]);

    AIdUnidade := aParams.Values[P_IDUNIDADE].Value;
    ATrackingID := aParams.Values[P_TRACKINGID].Value;
    AIdResultado := aParams.Values[P_IDRESULTADO].Value;
    AIdFluxo := aParams.Values[P_IDFLUXO].Value;
    AIdFila := aParams.Values[P_FILA].Value;
    AQtdPessoas := aParams.Values[P_QTDPESSOAS].Value;
    ASenha := aParams.Values[P_SENHA].Value;

    LConexao := TFDConnection.Create(Self);
    try
      {$REGION 'Configurar objeto de conexão'}
    try
      LConexao.Close;
      LConexao.LoginPrompt := False;
      LConexao.ConnectionDefName := TConexaoBD.NomeBasePadrao(StrToInt(AIdUnidade));
      LConexao.Tag := StrToInt(AIdUnidade);
      //LConexao.Open;
    except
      on E: Exception do
      begin
        raise Exception.Create('Erro ao configurar objeto de conexão');
      end;
    end;
    {$ENDREGION}

      LSQL_AA := 'UPDATE AA SET ID_RESULTADO = ' + AIdResultado + sLineBreak +
                     ', ID_TIPOFLUXO = ' + AIdFluxo+ sLineBreak +
                     ', ID_FILAENCAMINHAMENTO = '+ AIdFila + sLineBreak +
                     ', QTDPESSOAS = ' + AQtdPessoas + sLineBreak +
                     ' WHERE TRACKINGID = '+ATrackingID.QuotedString +';'; // DURACAO_SEGUNDOS

      LSQL_TICKETS := 'UPDATE OR INSERT INTO NN_AA_TICKETS (ID_AA, ID_TICKET)' + sLineBreak +
                      ' VALUES ((SELECT MAX(ID) FROM AA WHERE TRACKINGID='+ATrackingID.QuotedString+'),'+ sLineBreak +
                      ' (SELECT MAX(ID) FROM TICKETS WHERE NUMEROTICKET='+ASenha.QuotedString+'))'+ sLineBreak +
                      ' MATCHING (ID_AA);';

    {$REGION 'Get da imagem no banco'}
      LQuery := TFDQuery.Create(nil);
      LQuery.BeforeExecute := QueryBeforeOpen;
      LQuery.Connection := LConexao;
      try
        LQuery.Close;
        LQuery.SQL.Text := LSQL_AA;
        LQuery.ExecSQL;

        if StrToIntDef(ASenha, 0)<> 0 then
        begin
          LQuery.SQL.Text := LSQL_TICKETS;
          LQuery.ExecSQL;
        end;
      except
        on E: Exception do
        begin
          raise Exception.Create('Erro ao executar comando SQL: ' + E.Message);
        end;
      end;
    {$ENDREGION}

      Result := TJSONObject.Create;
      Result.AddPair(CHAVE_SUCESSO, TJSONTrue.Create);

      TLibDataSnap.UpdateStatus('AA.updateAtualizarAtendimento: ' + Result.ToString, AIdUnidade);

      //GetDataSnapWebModule.Response.StatusCode := 200;
      //GetDataSnapWebModule.Response.Content := LJSON.ToString;
      //GetDataSnapWebModule.Response.SendResponse;
    except
      on E: Exception do
      begin
        Result := TJSONObject.Create;
        Result.AddPair(CHAVE_SUCESSO, TJSONFalse.Create);

        TLibDataSnap.UpdateStatus('AA.updateAtualizarAtendimento. ' + E.Message, IdUnidade);

        //GetDataSnapWebModule.Response.StatusCode := 404;
        //GetDataSnapWebModule.Response.Content := LJSON.ToString;
        //GetDataSnapWebModule.Response.SendResponse;
        raise Exception.Create('Error parsing input params' + E.Message);
      end;
    end;
  finally
    FreeAndNil(LQuery);
    FreeAndNil(LConexao);
  end;
end;

function TAutoAtendimento.updateFinalizarAtendimento(const aParams: TJSONObject): TJSONObject;
const
  P_IDUNIDADE          = 'AIdUnidade';
  P_TRACKINGID         = 'ATrackingID';
  P_IDRESULTADO        = 'AIdResultado';

  P_TRANSACAODATA      = 'Data';
  P_TRANSACAODESCRICAO = 'Descricao';
  P_TRANSACAOVALOR     = 'Valor';

var
  LConexao: TFDConnection;
  LQuery: TFDQuery;
  LSQL_Select:  String;
  AIdUnidade, AIdResultado, ATrackingID: String;
begin
  try
    if dmControleDeTokens.ChecarComandoDuplicado('get Totem/GravaRelatorio', AIdUnidade) then
      raise Exception.Create('Token duplicado');

    TLibDataSnap.ValidateInputParams(aParams, [P_IDUNIDADE, P_TRACKINGID, P_IDRESULTADO]);

    AIdUnidade := aParams.Values[P_IDUNIDADE].Value;
    ATrackingID := aParams.Values[P_TRACKINGID].Value;
    AIdResultado := aParams.Values[P_IDRESULTADO].Value;

    LConexao := TFDConnection.Create(Self);
    try
      {$REGION 'Configurar objeto de conexão'}
    try
      LConexao.Close;
      LConexao.LoginPrompt := False;
      LConexao.ConnectionDefName := TConexaoBD.NomeBasePadrao(StrToInt(AIdUnidade));
      LConexao.UpdateOptions.LockMode := lmOptimistic;
      LConexao.UpdateOptions.LockWait := False;
      LConexao.Tag := StrToInt(AIdUnidade);
      LConexao.Open;

      //if (not TConexaoBD.TabelaExiste('AA', LConexao)) or (not TConexaoBD.TabelaExiste('CONFIGURACOES_GERAIS', LConexao)) then
       // Exit;
    except
      on E: Exception do
      begin
        raise Exception.Create('Erro ao configurar objeto de conexão: Erro '+ E.Message);
      end;
    end;
    {$ENDREGION}
      LSQL_Select := 'UPDATE AA SET ID_RESULTADO = ' + AIdResultado + sLineBreak +
                     ', FIM=' + FormatDateTime('YYYY-MM-DD HH:NN:SS', Now).QuotedString + sLineBreak +
                     ', DURACAO_SEGUNDOS=DATEDIFF(SECOND, INICIO, CURRENT_TIMESTAMP)' + sLineBreak +
                     ' WHERE TRACKINGID='+ATrackingID.QuotedString; // DURACAO_SEGUNDOS

    {$REGION 'Executa SQL'}
      LQuery := TFDQuery.Create(nil);
      LQuery.BeforeExecute := QueryBeforeOpen;
      LQuery.Connection := LConexao;
      try
        LQuery.Close;
        LQuery.SQL.Text := LSQL_Select;
        LQuery.ExecSQL;
      except
        on E: Exception do
        begin
          raise Exception.Create('Erro ao executar comando SQL: ' + E.Message + #13#10#13#10'Query: ' + LQuery.SQL.Text);
        end;
      end;
    {$ENDREGION}
    finally
      FreeAndNil(LQuery);
      FreeAndNil(LConexao);
    end;

    Result := TJSONObject.Create;
    Result.AddPair(CHAVE_SUCESSO, TJSONTrue.Create);

    TLibDataSnap.UpdateStatus('AA.updateFinalizarAtendimento: ' + Result.ToString, AIdUnidade);

    //GetDataSnapWebModule.Response.StatusCode := 200;
    //GetDataSnapWebModule.Response.Content := LJSON.ToString;
    //GetDataSnapWebModule.Response.SendResponse;
  except
    on E: Exception do
    begin
      Result := TJSONObject.Create;
      Result.AddPair(CHAVE_SUCESSO, TJSONFalse.Create);

      TLibDataSnap.UpdateStatus('AA.updateFinalizarAtendimento. ' + E.Message, IdUnidade);
      raise Exception.Create('Error parsing input params' + E.Message);

      //GetDataSnapWebModule.Response.StatusCode := 404;
      //GetDataSnapWebModule.Response.Content := LJSON.ToString;
      //GetDataSnapWebModule.Response.SendResponse;
    end;
  end;
end;

end.

