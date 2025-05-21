unit uSMTotem;

interface

//uses
//  System.SysUtils, System.Classes, Datasnap.DSServer, System.JSON,
//  Datasnap.DSAuth, Datasnap.DSProviderDataModuleAdapter, uSMBase;
uses
  System.SysUtils, System.Classes, System.Json,
  DataSnap.DSProviderDataModuleAdapter, FireDAC.Stan.Param,
  Datasnap.DSServer, Datasnap.DSAuth, uSMBase, Datasnap.DSHTTPWebBroker;

type
{$METHODINFO ON}
  TTotem = class(TsmBase)
  private
    { Private declarations }
  public
    { Public declarations }
    function ListarTodos(const AIdUnidade: String): TJSONObject;
    function Download(const AIdTotem: Integer): String;
    function ObterTelas(const aIdTotem: Integer; const AIdUnidade: String): TJSONObject;
    function ObterImagemTela(const AIdTela: Integer; const AIdUnidade: String): String;
    function updateGravaRelatorio(const aParams: TJSONObject): TJSONObject;
    function updateGravaRelatSitef(const aParams: TJSONObject): TJSONObject;
    function updateVersao(const aParams: TJSONObject): TJSONObject;
    function updateImprimirMensagem(AText:TJSONObject): TJSONObject;
    function updateEnviarRespostaPesquisaSatisfacao(const aParams: TJSONObject): TJSONObject;
    function updateBuscarRespostaPesquisaSatisfacaoFluxo(const aParams: TJSONObject): TJSONObject;
    function Parametros(const ATotem: Integer): TJSONObject;
  end;
  //apenas para expor a URI sem o prefixo "T"
  Totem = class(TTotem);
{$METHODINFO OFF}

implementation

uses
  uConsts, System.StrUtils, System.Types, uLibDatasnap, Data.DBXPlatform,
  FireDAC.Comp.Client, Vcl.Imaging.jpeg, Data.DB, UConexaoBD,
  FireDAC.Stan.Intf, SCC_m, udmControleDeTokens,Winapi.Windows,uSMUnidade,
  System.DateUtils;

{$R *.dfm}

{ TTotem }

function TTotem.ListarTodos(const AIdUnidade: String): TJSONObject;
var LResp:  String;
    LTotem: TJSONObject;
    LItens: TJSONArray;
    i, LQtdRecebida: Integer;
    LStrLst: TStringList;
    LItem, LId, LNome, LIP, LIdModeloTotem: String;
    LRespSeparada: TStringDynArray;
begin
  IdUnidade := AIdUnidade;

  if dmControleDeTokens.ChecarComandoDuplicado('get Totem/ListarTodos', IdUnidade) then
    raise Exception.Create('Token duplicado');

  LResp  := EnviarComando(0, CMD_LISTAR_TOTENS, EmptyStr, [CMD_LISTAR_TOTENS_RES]);
//  Result := TJSONObject(TJSONObject.ParseJSONValue(LResp));

  LItens := TJSONArray.Create;
  LQtdRecebida := StrToIntDef('$' + Copy(LResp, 1, 4), 0);
  Delete(LResp, 1, 4);

  LStrLst := TStringList.Create;
  try
    LStrLst.Delimiter       := TAB;
    LStrLst.StrictDelimiter := True;
    LStrLst.DelimitedText   := LResp;
    for i := 0 to LStrLst.Count-1 do
    begin
      LItem := Trim(LStrLst[i]);
      if LItem = EmptyStr then
        continue;

      LRespSeparada := SplitString(LItem, ';');

      LId            := LRespSeparada[0];
      LNome          := LRespSeparada[1];
      LIP            := LRespSeparada[2];
      LIdModeloTotem := LRespSeparada[3];

      LTotem := TJSONObject.Create;
      LTotem.AddPair('ID', TJSONNumber.Create(StrToInt('$' + LId)));
      LTotem.AddPair('Nome', LNome);
      //LTotem.AddPair('IP', LIP);
      //LTotem.AddPair('IdModeloTotem', LIdModeloTotem);
      LItens.Add(LTotem);
    end;
  finally
    FreeAndNil(LStrLst);
  end;

  if LQtdRecebida <> LItens.Count then
    raise Exception.Create('Checksum error. Got ' + LQtdRecebida.ToString +
                           ', sending ' + LItens.Count.ToString);

  result := TJSONObject.Create;
  result.AddPair('Quantidade', TJSONNumber.Create(LItens.Count));
  result.AddPair('Itens', LItens);

  TLibDataSnap.UpdateStatus('Totem.ListarTodos: ' + Result.ToString, AIdUnidade);
end;

function TTotem.Download(const AIdTotem: Integer): String;
const
  cExtensao = '.jpeg';
  LSQL      = 'SELECT E.ID, E.ID_TIPO, E.ORIGINAL_FILENAME, E.ORIGINAL_FILESIZE, E.VERSAO, E.BINARIO, ' +
              'E.BINARIO_HASH, E.UPLOADED_POR, E.UPLOADED_EM, E.ULTIMOUSO_EM, E.DELETADO ' +
              'FROM EXECUTAVEIS E ' +
              'WHERE E.ID = %d';

var
  LConexao: TFDConnection;
  LQuery: TFDQuery;
  LStreamImage: TStream;
begin
  Result := EmptyStr;

  if dmControleDeTokens.ChecarComandoDuplicado('get Totem/Download', IdUnidade) then
    raise Exception.Create('Token duplicado');

  LConexao := TFDConnection.Create(Self);
  try
    {$REGION 'Configurar objeto de conexão'}
    try
      LConexao.Close;
      LConexao.LoginPrompt := False;
      LConexao.ConnectionDefName := TConexaoBD.NomeBasePadrao(StrToInt('0'));
      LConexao.Open;
    except
      on E: Exception do
      begin
        raise Exception.Create('Erro ao configurar objeto de conexão');
      end;
    end;
    {$ENDREGION}

    {$REGION 'Get da imagem no banco'}
    LQuery := TFDQuery.Create(nil);
    try
      LQuery.Connection := LConexao;
      try
        LQuery.Close;
        LQuery.SQL.Text := Format(LSQL, [AIdTotem]);
        LQuery.Open;

        if not LQuery.FieldByName('BINARIO').IsNull then
        begin
          LStreamImage := TMemoryStream.Create;
          TBlobField(LQuery.FieldByName('BINARIO')).SaveToStream(LStreamImage);

          GetDataSnapWebModule.Response.ContentStream := LStreamImage;
          GetDataSnapWebModule.Response.StatusCode := 200;
          GetDataSnapWebModule.Response.ContentType := 'application/zip';
          GetDataSnapWebModule.Response.SendResponse;
        end
        else
        begin
          GetDataSnapWebModule.Response.StatusCode := 404;
          GetDataSnapWebModule.Response.SendResponse;
        end;
      except
        on E: Exception do
        begin
          raise Exception.Create('Erro ao executar comando SQL');
        end;
      end;
    finally
      FreeAndNil(LQuery);
    end;
    {$ENDREGION}
  finally
    FreeAndNil(LConexao);
  end;
end;


function TTotem.ObterImagemTela(const AIdTela: Integer;
  const AIdUnidade: String): String;
const
  cExtensao = '.jpeg';
  LSQL      = 'SELECT IMAGEM FROM MULTITELAS WHERE ID = %d';

var
  LConexao: TFDConnection;
  LQuery: TFDQuery;
  LStreamImage: TStream;
begin
  Result := EmptyStr;

  if dmControleDeTokens.ChecarComandoDuplicado('get Totem/ObterImagemTela', IdUnidade) then
    raise Exception.Create('Token duplicado');

  LConexao := TFDConnection.Create(Self);
  try
    {$REGION 'Configurar objeto de conexão'}
    try
      LConexao.Close;
      LConexao.LoginPrompt := False;
      LConexao.ConnectionDefName := TConexaoBD.NomeBasePadrao(StrToInt(AIdUnidade));
      LConexao.Open;
    except
      on E: Exception do
      begin
        raise Exception.Create('Erro ao configurar objeto de conexão');
      end;
    end;
    {$ENDREGION}

    {$REGION 'Get da imagem no banco'}
    LQuery := TFDQuery.Create(nil);
    try
      LQuery.Connection := LConexao;
      try
        LQuery.Close;
        LQuery.SQL.Text := Format(LSQL, [AIdTela]);
        LQuery.Open;

        if not LQuery.FieldByName('IMAGEM').IsNull then
        begin
          LStreamImage := TMemoryStream.Create;
          TBlobField(LQuery.FieldByName('IMAGEM')).SaveToStream(LStreamImage);

          GetDataSnapWebModule.Response.ContentStream := LStreamImage;
          GetDataSnapWebModule.Response.StatusCode := 200;
          GetDataSnapWebModule.Response.ContentType := 'image/jpeg';
          GetDataSnapWebModule.Response.SendResponse;
        end
        else
        begin
          GetDataSnapWebModule.Response.StatusCode := 404;
          GetDataSnapWebModule.Response.SendResponse;
        end;
      except
        on E: Exception do
        begin
          raise Exception.Create('Erro ao executar comando SQL');
        end;
      end;
    finally
      FreeAndNil(LQuery);
    end;
    {$ENDREGION}
  finally
    FreeAndNil(LConexao);
  end;
end;

function TTotem.ObterTelas(const aIdTotem: Integer; const AIdUnidade: String): TJSONObject;
var
  LResp: String;
  LDados: String;
  LJSONObject: TJSONObject;
begin
  if aIdTotem <= 0 then
    TLibDataSnap.AbortWithInvalidRequest('Totem não informado');

  IdUnidade      := aIdUnidade;
  LDados         := IntToHex(aIdTotem, 4);

  if dmControleDeTokens.ChecarComandoDuplicado('get Totem/ObterTelas', IdUnidade) then
    raise Exception.Create('Token duplicado');

  LResp          := EnviarComando(0, CMD_OBTER_DADOS_TOTEN , LDados , [CMD_OBTER_DADOS_TOTEN_RES]);

  LJSONObject := TJSONObject(TJSONObject.ParseJSONValue(LResp));
  if not Assigned(LJSONObject) then
  begin
    raise Exception.Create(Format('Falha ao converter JSON com dados' +
                                  ' do Totem "%d".', [aIdTotem])+ #13 +
                                  'Servidor retornou um conteúdo inesperado.');
    exit;
  end
  else
  begin
    Result := TJSONObject(LJSONObject);
  end;

  TLibDataSnap.UpdateStatus('Totem.ObterTelas ' + Result.ToString, AIdUnidade);
end;

function TTotem.Parametros(const ATotem: Integer): TJSONObject;
var
  LConexao                : TFDConnection;
  LSQL_Select_Totem       : String;
  LSQL_Select_Params      : String;
  LJSON                   : TJSONObject;
  LJSONGrupos             : array of TJSONObject;
  LJSONParametros         : TJSONObject;
  LJSONArrayConfiguracoes : TJSONArray;
  LJSONArrayParametros    : array of TJSONArray;
  LQuery                  : TFDQuery;
  LGrupo                  : string;
  LCount                  : integer;
begin
  LJSONArrayConfiguracoes := nil;

  try
    LSQL_Select_Totem  := 'SELECT TT.NOME NOMETOTEM, UN.ID IDUNIDADE, ' + sLineBreak +
                          'trim(UN.NOME) NOMEUNIDADE, ' + sLineBreak +
                          'TT.IP ENDERECOIP ' + sLineBreak +
                          'FROM TOTENS TT ' + sLineBreak +
                          'LEFT JOIN UNIDADES UN ON TT.ID_UNIDADE = UN.ID ' + sLineBreak +
                          'LEFT JOIN SETORES S ON TT.ID_SETOR = S.ID ' + sLineBreak +
                          'WHERE TT.ID = %s';

    LSQL_Select_Params := 'SELECT PGC.NOME GRUPO, PC.NOME CHAVE, PCT.VALOR ' + sLineBreak +
                          'FROM NN_PARAMTOTENS_CHAVES_TOTENS PCT ' + sLineBreak +
                          'LEFT JOIN PARAMTOTENS_CHAVES PC ON PCT.ID_CHAVE = PC.ID ' + sLineBreak +
                          'LEFT JOIN  PARAMTOTENS_GRUPOSCHAVES PGC ON PC.ID_GRUPO = PGC.ID ' + sLineBreak +
                          'WHERE PCT.ID_TOTEM = %s' + sLineBreak +
                          'ORDER BY PGC.NOME ';

    if dmControleDeTokens.ChecarComandoDuplicado('get Totem/Parametros', aTotem.ToString) then
      raise Exception.Create('Token duplicado');

    LConexao := TFDConnection.Create(Self);
    try
      {$REGION 'Configurar objeto de conexão'}
      try
        LConexao.Close;
        LConexao.LoginPrompt := False;
        LConexao.ConnectionDefName := TConexaoBD.NomeBasePadrao(StrToInt('0'));
        LConexao.Open;
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
          LQuery.Close;
          LQuery.SQL.Text := Format(LSQL_Select_Totem, [aTotem.ToString]);
          LQuery.Open;
          LJSON := TJSONObject.Create;
          LJSON.AddPair('nomeTotem',LQuery.FieldByName('NOMETOTEM').AsString);
          LJSON.AddPair('idUnidade',LQuery.FieldByName('IDUNIDADE').AsString);
          LJSON.AddPair('nomeUnidade',LQuery.FieldByName('NOMEUNIDADE').AsString);
          LJSON.AddPair('enderecoIP',LQuery.FieldByName('ENDERECOIP').AsString);
          LQuery.Close;
          LQuery.SQL.Text := Format(LSQL_Select_Params, [aTotem.ToString]);
          LQuery.Open;

          if not LQuery.eof then
          begin
            while not LQuery.eof do
            begin
              if LGrupo = EmptyStr then
              begin
                LGrupo := LQuery.FieldByName('GRUPO').AsString;
                LJSONArrayConfiguracoes := TJSONArray.Create;
                SetLength(LJSONGrupos,Length(LJSONGrupos)+1);
                SetLength(LJSONArrayParametros,Length(LJSONArrayParametros)+1);
                LJSONGrupos[Length(LJSONGrupos)-1] := TJSONObject.Create;
                LJSONArrayParametros[Length(LJSONArrayParametros)-1] := TJSONArray.Create;
              end
              else if LGrupo <> LQuery.FieldByName('GRUPO').AsString then
              begin
                LJSONGrupos[Length(LJSONGrupos)-1].AddPair('grupo',LGrupo);
                LJSONGrupos[Length(LJSONGrupos)-1].AddPair('parametros',LJSONArrayParametros[Length(LJSONArrayParametros)-1]);

                LGrupo := LQuery.FieldByName('GRUPO').AsString;

                SetLength(LJSONGrupos,Length(LJSONGrupos)+1);
                SetLength(LJSONArrayParametros,Length(LJSONArrayParametros)+1);
                LJSONGrupos[Length(LJSONGrupos)-1] := TJSONObject.Create;
                LJSONArrayParametros[Length(LJSONArrayParametros)-1] := TJSONArray.Create;
              end;
              LJSONParametros := TJSONObject.Create;
              LJSONParametros.AddPair('chave',LQuery.FieldByName('CHAVE').AsString);
              LJSONParametros.AddPair('valor',LQuery.FieldByName('VALOR').AsString);
              LJSONArrayParametros[Length(LJSONArrayParametros)-1].Add(LJSONParametros);
              LQuery.Next;
            end;
            LJSONGrupos[Length(LJSONGrupos)-1].AddPair('grupo',LGrupo);
            LJSONGrupos[Length(LJSONGrupos)-1].AddPair('parametros',LJSONArrayParametros[Length(LJSONArrayParametros)-1]);
            for LCount  := 0 to Length(LJSONGrupos)-1 do
            begin
              LJSONArrayConfiguracoes.Add(LJSONGrupos[LCount]);
            end;
            LJSON.AddPair('configuracoes', LJSONArrayConfiguracoes);
          end;
          Result := LJSON;
          MainForm.ShowStatus('Retornados os parâmetros do Totem ID ' + aTotem.ToString);
        except
          on E: Exception do
          begin
            MainForm.ShowStatus('Erro ao retornar os parâmetros do Totem ID ' + aTotem.ToString + '. Erro: ' + E.Message);
            raise Exception.Create('Erro ao executar comando SQL');
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
      raise Exception.Create('Error parsing input params');
    end;
  end;
end;

function TTotem.updateGravaRelatorio(const aParams: TJSONObject): TJSONObject;
const
  P_TOTEM              = 'Totem';
  P_IDUNIDADE          =  'idUnidade';
  P_TRANSACAODATA      = 'Data';
  P_TRANSACAODESCRICAO = 'Descricao';
  P_TRANSACAOVALOR     = 'Valor';

  CHAVE_SUCESSO      = 'Sucesso';
  CHAVE_MOTIVO       = 'motivo';
  CHAVE_TOTEM        = 'Totem';
  CHAVE_UNIDADE      = 'idUnidade';
var
  LConexao    :     TFDConnection;
  LSQL_Delete :  String;
  LSQL_Insert :  String;
  LMsg        : String;

  LIdUnidade, LUnidCli, LTotem, LDescricao, LValor: String;
  LData: String;

  procedure FinalizarComFalha(const AMsgLog, AMsgRetorno: String);
  begin
    TLibDataSnap.UpdateStatus(AMsgLog, IdUnidade);
    Result := TJSONObject.Create;
    Result.AddPair(P_TOTEM, TJSONNumber.Create(LTotem));
    Result.AddPair(CHAVE_SUCESSO, TJSONFalse.Create);
    if AMsgRetorno <> EmptyStr then
      Result.AddPair(CHAVE_MOTIVO, AMsgRetorno);
  end;

begin
  try
    LSQL_Delete := 'DELETE FROM MONITOR_TOTEM' + sLineBreak +
                   'WHERE ID_UNIDADE = %d AND TOTEM = %s AND DESCRICAO = %s AND R_DATA = %s';

    LSQL_Insert := 'INSERT INTO MONITOR_TOTEM(ID, ID_UNIDADE, TOTEM, DESCRICAO, VALOR, R_DATA)' + sLineBreak +
                   'VALUES((SELECT COALESCE(MAX(ID), 0) +1 FROM MONITOR_TOTEM), %d, %s, %s, %s, %s);';

    LIDUnidade  := aParams.Values[P_IDUNIDADE].Value;
    LTotem := aParams.Values[P_TOTEM].Value;
    LDescricao := aParams.Values[P_TRANSACAODESCRICAO].Value;
    LValor := aParams.Values[P_TRANSACAOVALOR].Value;
    LData := aParams.Values[P_TRANSACAODATA].Value;

    LSQL_Delete := Format(LSQL_Delete, [StrToInt(LIDUnidade), QuotedStr(LTotem), QuotedStr(LDescricao), QuotedStr(LData)]);
    LSQL_Insert := Format(LSQL_Insert, [StrToInt(LIDUnidade), QuotedStr(LTotem), QuotedStr(LDescricao), QuotedStr(LValor), QuotedStr(LData)]);

    if dmControleDeTokens.ChecarComandoDuplicado('get Totem/GravaRelatorio', LIDUnidade) then
      raise Exception.Create('Token duplicado');

    LUnidCli := '0';

    if TLibDataSnap.dmUnidades.cdsUn.Active and
       TLibDataSnap.dmUnidades.cdsUn.Locate('ID', LIDUnidade, [loCaseInsensitive]) then
    begin
      LUnidCli := TLibDataSnap.dmUnidades.cdsUn.FieldByName('ID_UNID_CLI').AsString;
    end;

    LConexao := TFDConnection.Create(Self);
    try
      {$REGION 'Configurar objeto de conexão'}
      try
        LConexao.Close;
        LConexao.LoginPrompt := False;
        LConexao.ConnectionDefName := TConexaoBD.NomeBasePadrao(StrToInt(LUnidCli));
        LConexao.Open;
      except
        on E: Exception do
        begin
          raise Exception.Create('Erro ao configurar objeto de conexão');
        end;
      end;
      {$ENDREGION}

      {$REGION 'Get dados Totem'}
      try
        LConexao.ExecSQL(LSQL_Delete);
        if LConexao.ExecSQL(LSQL_Insert) = 1 then
        begin
          TLibDataSnap.UpdateStatus(Format('Incluido informações do Totem "%s"', [LTotem]), LUnidCli);
          result := TJSONObject.Create;
          result.AddPair(CHAVE_SUCESSO, TJSONTrue.Create);
          result.AddPair(CHAVE_UNIDADE, TJSONNumber.Create(LIDUnidade));
          result.AddPair(CHAVE_TOTEM,   TJSONNumber.Create(LTotem));
        end else begin
          FinalizarComFalha(Format('Falha ao gravar informações do Totem' +
                                   ' "%d": %s.', [LIDUnidade  + '-' + LTotem, LSQL_Insert]), LMsg)
        end;

      except
        on E: Exception do
        begin
           TLibDataSnap.UpdateStatus('Totem.updateGravaRelatorio. ' + E.Message, IdUnidade);
          raise Exception.Create('Erro ao executar comando SQL: ' + E.message);
        end;
      end;

      TLibDataSnap.UpdateStatus('Totem.updateGravaRelatorio - Gravando dados de totens.', IdUnidade);
      {$ENDREGION}
    finally
      FreeAndNil(LConexao);
    end;
  except
    on E: Exception do begin
      TLibDataSnap.UpdateStatus('Totem.updateGravaRelatorio. ' + E.Message, IdUnidade);
      raise Exception.Create('Error parsing input params');
    end;
  end;
end;


function TTotem.updateGravaRelatSitef(const aParams: TJSONObject): TJSONObject;
const

  P_CUPOM_FISCAL        = 'CUPOM_FISCAL';
  P_PASSAGEM            = 'PASSAGEM';
  P_NSU                 = 'NSU';
  P_AUTORIZACAO         = 'AUTORIZACAO';
  P_PARCELAS            = 'PARCELAS';
  P_DATAHORA            = 'DATAHORA';
  P_DOC                 = 'DOC';
  P_REDE                = 'REDE';
  P_STATUS_TRANSACAO    = 'STATUS_TRANSACAO';
  P_TIPO_TRANSACAO      = 'TIPO_TRANSACAO';
  P_TERMINAL            = 'TERMINAL';
  P_TOTEM               = 'TOTEM';
  P_VALOR               = 'VALOR';
  P_CNPJESTABELECIMENTO = 'CNPJESTABELECIMENTO';
  P_CODIGOLOJA          = 'CODIGOLOJA';
  P_ID_TOTEM            = 'ID_TOTEM';
  P_ID_UNIDADE          = 'ID_UNIDADE';


//  P_TOTEM              = 'Totem';
//  P_IDUNIDADE          =  'idUnidade';
//  P_TRANSACAODATA      = 'Data';
//  P_TRANSACAODESCRICAO = 'Descricao';
//  P_TRANSACAOVALOR     = 'Valor';

  CHAVE_SUCESSO      = 'Sucesso';
  CHAVE_MOTIVO       = 'motivo';
  CHAVE_TOTEM        = 'Totem';
  CHAVE_UNIDADE      = 'idUnidade';
  CHAVE_CUPOM        = 'cupom';
var
  LConexao:     TFDConnection;
  LSQL_Delete:  String;
  LSQL_Insert:  String;
  LMsg: String;

  LUnidCli, LCupom_fiscal, LPassagem, LNsu, LAutorizacao, LParcelas,
  LDatahora, LDoc, LRede, LStatus_transacao, LTipo_transacao,
  LTerminal, LTotem, LValor, LCnpjEstabelecimento,
  LCodigoloja, LId_totem, LId_unidade : String;

  fs: TFormatSettings;

  procedure FinalizarComFalha(const AMsgLog, AMsgRetorno: String);
  begin
    TLibDataSnap.UpdateStatus(AMsgLog, IdUnidade);
    Result := TJSONObject.Create;
    Result.AddPair(P_TOTEM, TJSONNumber.Create(LTotem));
    Result.AddPair(CHAVE_SUCESSO, TJSONFalse.Create);
    if AMsgRetorno <> EmptyStr then
      Result.AddPair(CHAVE_MOTIVO, AMsgRetorno);
  end;

begin
  try
    fs := TFormatSettings.Create;
    fs.DateSeparator := '/';
    fs.ShortDateFormat := 'DD/MM/YYYY';
    fs.TimeSeparator := ':';
    fs.ShortTimeFormat := 'hh:mm';
    fs.LongTimeFormat := 'hh:mm:ss';

    LSQL_Delete := 'DELETE FROM RELAT_SITEF ' + sLineBreak +
                   'WHERE ID_UNIDADE = %d AND ID_TOTEM = %d AND CUPOM_FISCAL = %s AND PASSAGEM = %s';

    LSQL_Insert := 'INSERT INTO RELAT_SITEF (ID_UNIDADE, ID_TOTEM, CUPOM_FISCAL, ' +
                                              'CNPJESTABELECIMENTO,CODIGOLOJA, ' +
                                              'DATAHORA, TERMINAL, TOTEM, PASSAGEM, ' +
                                              'TIPO_TRANSACAO, STATUS_TRANSACAO, REDE, ' +
                                              'PARCELAS, VALOR, NSU, DOC, AUTORIZACAO) ' + sLineBreak +
                   'VALUES (%d, %d, %s, %s, %s,%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)';

    LId_unidade           := aParams.Values[P_ID_UNIDADE].Value;
    LId_totem             := aParams.Values[P_ID_TOTEM].Value;
    LCupom_fiscal         := aParams.Values[P_CUPOM_FISCAL].Value;
    LPassagem             := aParams.Values[P_PASSAGEM].Value;
    LNsu                  := aParams.Values[P_NSU].Value;
    LAutorizacao          := aParams.Values[P_AUTORIZACAO].Value;
    LParcelas             := aParams.Values[P_PARCELAS].Value;
    LDatahora             := FormatDateTime('YYYY-MM-DD  HH:NN:SS',StrToDateTime(aParams.Values[P_DATAHORA].Value, fs));
    LDoc                  := aParams.Values[P_DOC].Value;
    LRede                 := aParams.Values[P_REDE].Value;
    LStatus_transacao     := IfThen(aParams.Values[P_STATUS_TRANSACAO].Value <> '',aParams.Values[P_STATUS_TRANSACAO].Value, 'APROVADA') ;
    LTipo_transacao       := aParams.Values[P_TIPO_TRANSACAO].Value;
    LTerminal             := aParams.Values[P_TERMINAL].Value;
    LTotem                := aParams.Values[P_TOTEM].Value;
    LValor                := StringReplace(aParams.Values[P_VALOR].Value,',','.',[rfReplaceAll]);
    LCnpjEstabelecimento  := aParams.Values[P_CNPJESTABELECIMENTO].Value;
    LCodigoloja           := aParams.Values[P_CODIGOLOJA].Value;

    LSQL_Delete := Format(LSQL_Delete, [StrToInt(LId_unidade), StrToInt(LId_totem), QuotedStr(LCupom_fiscal),QuotedStr(LPassagem)]);
    LSQL_Insert := Format(LSQL_Insert, [StrToInt(LId_unidade), StrToInt(LId_totem), QuotedStr(LCupom_fiscal),
                                        QuotedStr(LCnpjEstabelecimento), QuotedStr(LCodigoloja),
                                        QuotedStr(LDatahora), QuotedStr(LTerminal), QuotedStr(LTotem), QuotedStr(LPassagem),
                                        QuotedStr(LTipo_transacao), QuotedStr(LStatus_transacao),
                                        QuotedStr(LRede), LParcelas, LValor, QuotedStr(LNsu),QuotedStr(LDoc), QuotedStr(LAutorizacao)]);

    if dmControleDeTokens.ChecarComandoDuplicado('get Totem/GravaRelatSitef', LID_Unidade) then
      raise Exception.Create('Token duplicado');

    LUnidCli := '0';

    if TLibDataSnap.dmUnidades.cdsUn.Active and
       TLibDataSnap.dmUnidades.cdsUn.Locate('ID', LID_Unidade, [loCaseInsensitive]) then
    begin
      LUnidCli := TLibDataSnap.dmUnidades.cdsUn.FieldByName('ID_UNID_CLI').AsString;
    end;

    LConexao := TFDConnection.Create(Self);
    try
      {$REGION 'Configurar objeto de conexão'}
      try
        LConexao.Close;
        LConexao.LoginPrompt := False;
        LConexao.ConnectionDefName := TConexaoBD.NomeBasePadrao(0);
        LConexao.Open;
      except
        on E: Exception do
        begin
          raise Exception.Create('Erro ao configurar objeto de conexão');
        end;
      end;
      {$ENDREGION}

      {$REGION 'Get dados Totem'}
      try
        LConexao.ExecSQL(LSQL_Delete);
        if LConexao.ExecSQL(LSQL_Insert) = 1 then
        begin
          TLibDataSnap.UpdateStatus(Format('Incluido informações do Totem "%s"', [LTotem]), LUnidCli);
          result := TJSONObject.Create;
          result.AddPair(CHAVE_SUCESSO, TJSONTrue.Create);
          result.AddPair(CHAVE_UNIDADE, TJSONNumber.Create(LId_unidade));
          result.AddPair(CHAVE_TOTEM,   TJSONNumber.Create(LId_totem));
          result.AddPair(CHAVE_CUPOM,   TJSONNumber.Create(LCupom_fiscal));
        end else begin
          FinalizarComFalha(Format('Falha ao gravar informações do Totem' +
                                   ' "%d": %s.', [LID_Unidade  + '-' + LId_totem + '-' + LCupom_fiscal, LSQL_Insert]), LMsg)
        end;

      except
        on E: Exception do
        begin
           TLibDataSnap.UpdateStatus('Totem.updateGravaRelatSitef. ' + E.Message, IdUnidade);
          raise Exception.Create('Erro ao executar comando SQL: ' + E.message);
        end;
      end;

      TLibDataSnap.UpdateStatus('Totem.updateGravaRelatSitef - Gravando dados de totens.', IdUnidade);
      {$ENDREGION}
    finally
      FreeAndNil(LConexao);
    end;
  except
    on E: Exception do begin
      TLibDataSnap.UpdateStatus('Totem.updateGravaRelatSitef. ' + E.Message, IdUnidade);
      raise Exception.Create('Error parsing input params');
    end;
  end;
end;

function TTotem.updateVersao(const aParams: TJSONObject): TJSONObject;
const
  P_Totem           = 'idtotem';
  P_Versao          = 'versao';
  CHAVE_SUCESSO      = 'Sucesso';
  CHAVE_MOTIVO       = 'motivo';

var
  LConexao : TFDConnection;
  LQuery :TFDQuery;
  LSQL_UpdateVersao: String;
  LSQL_SelectVersao: String;
  LJSON : TJSONObject;
  LVersao, LIDTotem, LId_unidade : String;

  procedure FinalizarComFalha(const AMsgLog, AMsgRetorno: String);
  begin
    TLibDataSnap.UpdateStatus(AMsgLog, IdUnidade);
    Result := TJSONObject.Create;
    Result.AddPair(P_TOTEM, TJSONNumber.Create(LIDTotem));
    Result.AddPair(CHAVE_SUCESSO, TJSONFalse.Create);
    if AMsgRetorno <> EmptyStr then
      Result.AddPair(CHAVE_MOTIVO, AMsgRetorno);
  end;

begin
  try
    LVersao  := aParams.Values[P_Versao].Value;
    LIDTotem := aParams.Values[P_Totem].Value;


    LSQL_UpdateVersao :=  'UPDATE TOTENS_VERSOES ' +
                          '   SET ID_STATUS_DEPLOY = 2, VERSAO_PROXIMA_ID = NULL ' +
                          ' WHERE ID_STATUS_DEPLOY = 1 ' +
                          '   AND ID_TOTEM = %d ' +
                          '   AND VERSAO_PROXIMA_ID = (SELECT ID ' +
                          '                              FROM EXECUTAVEIS ' +
                          '                             WHERE VERSAO = %s ' +
                          '                               AND DELETADO = ''F'')';

    LSQL_UpdateVersao := Format(LSQL_UpdateVersao, [StrToInt(LIDTotem), QuotedStr(LVersao)]);

    LSQL_SelectVersao :=  'SELECT V.ID_TOTEM, V.ID_TIPOEXECUTAVEL, V.VERSAO_ANTERIOR_ID, V.VERSAO_ANTERIOR_DEPLOYED_POR, ' +
                          'V.VERSAO_ANTERIOR_DEPLOYED_EM, V.VERSAO_ATUAL_ID, V.VERSAO_ATUAL_DEPLOYED_POR, ' +
                          'V.VERSAO_ATUAL_DEPLOYED_EM, V.VERSAO_PROXIMA_ID, V.VERSAO_PROXIMA_DEPLOYED_POR, ' +
                          'V.VERSAO_PROXIMA_DEPLOYED_EM, V.ID_STATUS_DEPLOY ' +
                          'FROM TOTENS_VERSOES V ' +
                          'WHERE V.ID_TOTEM = %d';

    LSQL_SelectVersao := Format(LSQL_SelectVersao, [StrToInt(LIDTotem)]);


    if dmControleDeTokens.ChecarComandoDuplicado('get Totem/Versao', LID_Unidade) then
      raise Exception.Create('Token duplicado');

    LConexao := TFDConnection.Create(Self);
    try
      {$REGION 'Configurar objeto de conexão'}
      try
        LConexao.Close;
        LConexao.LoginPrompt := False;
        LConexao.ConnectionDefName := TConexaoBD.NomeBasePadrao(StrToInt('0'));
        LConexao.Open;
      except
        on E: Exception do
        begin
          raise Exception.Create('Erro ao configurar objeto de conexão');
        end;
      end;
      {$ENDREGION}

      {$REGION 'Set versao Totem'}
      try
        LConexao.ExecSQL(LSQL_UpdateVersao);
        {$REGION 'Get se tem versao no banco'}
        LQuery := TFDQuery.Create(nil);
        try
          LQuery.Connection := LConexao;
          try
            LQuery.Close;
            LQuery.SQL.Text := LSQL_SelectVersao;
            LQuery.Open;
            LJSON := TJSONObject.Create;
            if not LQuery.Eof then
            begin
              LJSON.AddPair('hasUpdate',TJSONBool.Create(not LQuery.FieldByName('versao_proxima_id').IsNull));
            end
            else
            begin
              LJSON.AddPair('hasUpdate',TJSONBool.Create(False));
            end;
            Result := LJSON;
            MainForm.ShowStatus('Retornado se existe versão dispon do Totem ID ' + LIDTotem + ' ');
          except
            on E: Exception do
            begin
              MainForm.ShowStatus('Erro ao retornar se possui versao disponivel do Totem ID ' + LIDTotem + '. Erro: ' + E.Message);
              raise Exception.Create('Erro ao executar comando SQL');
            end;
          end;
        finally
          FreeAndNil(LQuery);
        end;
      {$ENDREGION}
      except
        on E: Exception do
        begin
           TLibDataSnap.UpdateStatus('Totem.updateVersao. ' + E.Message, IdUnidade);
          raise Exception.Create('Erro ao executar comando SQL: ' + E.message);
        end;
      end;

      TLibDataSnap.UpdateStatus('Totem.updateVersao - Retornando a versao disponivel do totem.', IdUnidade);
      {$ENDREGION}
    finally
      FreeAndNil(LConexao);
    end;
  except
    on E: Exception do begin
      TLibDataSnap.UpdateStatus('Totem.updateVersao. ' + E.Message, IdUnidade);
      raise Exception.Create('Error parsing input params');
    end;
  end;
end;


function TTotem.updateImprimirMensagem(AText:TJSONObject): TJSONObject;
var
  LAux : string;
  LBool:Boolean;
  LInteger:Integer;
begin

  if dmControleDeTokens.ChecarComandoDuplicado('get Fila/ListarGrupoCategoria', IdUnidade) then
    raise Exception.Create('Token duplicado');

  if AText.TryGetValue<Integer>('IdUnidade', LInteger) then
    IdUnidade:= AText.GetValue('IdUnidade').Value;

  if AText.TryGetValue<Boolean>('ManterCabecalho', LBool) and LBool then
    LAux := 'S'
  else
    LAux := 'N';

  if AText.TryGetValue<Boolean>('ManterRodape', LBool) and LBool then
    LAux := LAux + 'S'
  else
    LAux := LAux + 'N';

  LAux := LAux + Inttohex(AText.GetValue<Integer>('Totem'), 4);

  LAux := LAux + AText.GetValue('Mensagem').Value;

  Result := TJSONObject.Create;
  if EnviarComando(0, CMD_ENVIAR_TEXTO_IMPRESSAO, LAux, [CMD_ENVIAR_TEXTO_IMPRESSAO_RES]) = '0' then
    Result.AddPair('sucesso', TJSONFalse.Create)
  else
    Result.AddPair('sucesso', TJSONTrue.Create);

end;

function TTotem.updateEnviarRespostaPesquisaSatisfacao(const aParams: TJSONObject): TJSONObject;
const

  P_PERGUNTA_ID = 'PERGUNTA_ID';
  P_UNIDADE_ID = 'UNIDADE_ID';
  P_DEVICE_ID = 'DEVICE_ID';
  P_ALTERNATIVA_ID = 'ALTERNATIVA_ID';
  P_GUID = 'GUID';
  P_SENHA = 'SENHA';
  CHAVE_SUCESSO = 'sucesso';

var
  LAddr,LPergunta_ID, LDevice_ID, LAlterantiva_ID, LIdUnidade: integer;
  LGuid, LSenha, LData, LResp: String;

  LComandosEsperados: TIntegerDynArray;
begin
  try
    LComandosEsperados := [CMD_ENVIAR_TEXTO_IMPRESSAO_RES];
    LAddr := 0;
    aParams.TryGetValue(P_PERGUNTA_ID,LPergunta_ID);
    aParams.TryGetValue(P_DEVICE_ID,LDevice_ID);
    aParams.TryGetValue(P_ALTERNATIVA_ID,LAlterantiva_ID);
    aParams.TryGetValue(P_GUID,LGuid);
    aParams.TryGetValue(P_SENHA,LSenha);
    if aParams.TryGetValue(P_UNIDADE_ID, LIdUnidade) then
     IdUnidade := inttostr(LIdUnidade);
    LData := aParams.ToString;

  except
    raise Exception.Create('Error parsing input params');
  end;

  if dmControleDeTokens.ChecarComandoDuplicado('post PesquisaSatisfacao/EnviarResposta', IdUnidade) then
    raise Exception.Create('Token duplicado');

  LResp := EnviarComando(LAddr,
                         CMD_ENVIAR_RESPOSTA_PESQUISA,
                         LData,
                         LComandosEsperados);

  if LResp = '1' then
  begin
    TLibDataSnap.UpdateStatus('Pesquisa de Satisfação da Senha ' + LSenha + ' Gravada com Sucesso . ', IdUnidade);
    result := TJSONObject.Create;
    result.AddPair(CHAVE_SUCESSO, TJSONTrue.Create);

  end
  else
  begin
    TLibDataSnap.UpdateStatus('Falha ao Gravar a Pesquisa de Satisfação da Senha ' + LSenha , IdUnidade);
    result := TJSONObject.Create;
    result.AddPair(CHAVE_SUCESSO, TJSONFalse.Create);

  end;
end;

function TTotem.updateBuscarRespostaPesquisaSatisfacaoFluxo(const aParams: TJSONObject): TJSONObject;
const
  P_PRONTUARIO = 'PRONTUARIO';
  P_UNIDADE = 'UNIDADE';
  P_FLUXO = 'FLUXO';
  P_PRAZO_NAO_QUERO_OPINAR = 'PRAZO_NAO_QUERO_OPINAR';
  P_PRAZO_OUTRAS_RESPOSTAS = 'PRAZO_OUTRAS_RESPOSTAS';
  P_IDS_NAO_QUERO_OPINAR = 'PRAZO_NAO_QUERO_OPINAR';
  P_IDS_OUTRAS_RESPOSTAS = 'PRAZO_OUTRAS_RESPOSTAS';

  //PSQL_Select_Unidades = 'SELECT ID FROM UNIDADES';
  PSQL_SmartSurv = ' SELECT FIRST 1 srA.ALTERNATIVA_ID, srA.DATAHORA '+
                   ' FROM SMARTSURV_RESPOSTAS srA '+
                   '  JOIN TICKETS_CAMPOSADIC tcA ON srA.TICKET =tcA.ID_TICKET '+
                   '  JOIN TICKETS_CAMPOSADIC tcB ON tcA.ID_TICKET = tcB.ID_TICKET '+
                   ' WHERE tcA.CAMPO = ''PRONTUARIO''' +
                   '   AND tcA.VALOR = :PRONTUARIO '+
                   '   AND tcB.CAMPO = ''FLUXO''' +
                   '   AND tcB.VALOR = :FLUXO ' +
                   '   AND ((srA.DATAHORA >= :DATA_1 AND srA.ALTERNATIVA_ID IN (1)) '+
                   '     OR (srA.DATAHORA >= :DATA_2 AND srA.ALTERNATIVA_ID IN (2, 3, 4, 5, 6)))' +
                   ' ORDER BY srA.DATAHORA DESC';
var
  LPARAMETRO_PRONTUARIO,
  LPARAMETRO_UNIDADE,
  LPARAMETRO_FLUXO,
  LPARAMETRO_PRAZO_NAO_QUERO_OPINAR,
  LPARAMETRO_PRAZO_OUTRAS_RESPOSTAS,
  LPARAMETRO_IDS_NAO_QUERO_OPINAR,
  LPARAMETRO_IDS_OUTRAS_RESPOSTAS,
  LUnidadeResposta,
  LDataRespostaRet        : String;
  LData, LResp            : String;

  LConexao                : TFDConnection;
  LQuery                  : TFDQuery;
  LDataResposta           : TDateTime;
  LResposta               : TJSONObject;
  LIdResposta, LStatus    : Integer;
  fs                      : TFormatSettings;
  LIDsUnidades            : TStringDynArray;
begin
  try
    aParams.TryGetValue(P_PRONTUARIO, LPARAMETRO_PRONTUARIO);
    aParams.TryGetValue(P_UNIDADE, LPARAMETRO_UNIDADE);
    aParams.TryGetValue(P_FLUXO, LPARAMETRO_FLUXO);
    aParams.TryGetValue(P_PRAZO_NAO_QUERO_OPINAR, LPARAMETRO_PRAZO_NAO_QUERO_OPINAR);
    aParams.TryGetValue(P_PRAZO_OUTRAS_RESPOSTAS, LPARAMETRO_PRAZO_OUTRAS_RESPOSTAS);
    LData := aParams.ToString;
  except
    raise Exception.Create('Error parsing input params');
  end;

  if dmControleDeTokens.ChecarComandoDuplicado('post PesquisaSatisfacao/BuscarResposta', IdUnidade) then
    raise Exception.Create('Token duplicado');

  fs := TFormatSettings.Create;
  fs.DateSeparator := '/';
  fs.ShortDateFormat := 'DD/MM/YYYY';
  fs.TimeSeparator := ':';
  fs.ShortTimeFormat := 'hh:mm';
  fs.LongTimeFormat := 'hh:mm:ss';


  LIDsUnidades := SplitString(MainForm.IDsUnidadesSmartSurvey, ';');

  if MatchStr(LPARAMETRO_UNIDADE, LIDsUnidades) then
    Delete(LIDsUnidades, IndexStr(LPARAMETRO_UNIDADE, LIDsUnidades), 1);

  Insert(LPARAMETRO_UNIDADE, LIDsUnidades, 0);
  LConexao := TFDConnection.Create(Self);

  LStatus := 0;
  LDataResposta := Date;
  LIdResposta := 0;

  try
    {$REGION 'Configurar objeto de conexão'}
    //for var LCont := 0 to Pred(TConexaoBD.ConnectionDefs.Count) do
    for var LCont := Low(LIDsUnidades) to High(LIDsUnidades) do
    begin
      try
        if LStatus = 1 then Break;
        LConexao.Close;
        LConexao.LoginPrompt := False;

        //if ((Pos('ConexaoBD', TConexaoBD.ConnectionDefs.Items[LCont].Name) = 0) or
        //   (not MatchStr(StringReplace(TConexaoBD.ConnectionDefs.Items[LCont].Name, 'ConexaoBD', '', []), LIDsUnidades))) then
        //  Continue;

        LConexao.ConnectionDefName := TConexaoBD.NomeBasePadrao(StrToInt(LIDsUnidades[LCont]));
        LConexao.Open;

        if not TConexaoBD.TabelaExiste('SMARTSURV_RESPOSTAS', LConexao) then
          Continue;
      except
        on E: Exception do
        begin
          Continue;
          //raise Exception.Create('Erro ao configurar objeto de conexão');
        end;
      end;
      {$ENDREGION}
      {$REGION 'Get dos parametros no banco'}
      LQuery := TFDQuery.Create(nil);
      try
        LQuery.Connection := LConexao;
        try
          LQuery.Close;
          LQuery.SQL.Text := PSQL_SmartSurv;
          LQuery.ParamByName('PRONTUARIO').Value := LPARAMETRO_PRONTUARIO;
          LQuery.ParamByName('FLUXO').Value      := LPARAMETRO_FLUXO;
          LQuery.ParamByName('DATA_1').Value     := FormatDateTime('MM/DD/YYYY', IncDay(Date, StrToIntDef(LPARAMETRO_PRAZO_NAO_QUERO_OPINAR, 0) * -1));
          LQuery.ParamByName('DATA_2').Value     := FormatDateTime('MM/DD/YYYY', IncDay(Date, StrToIntDef(LPARAMETRO_PRAZO_OUTRAS_RESPOSTAS, 0) * -1));
          LQuery.Open;
          TLibDataSnap.UpdateStatus('Buscando resposta da pesquisa de Satisfação no fluxo ' + LPARAMETRO_FLUXO + ' para o prontuário' + ' = "' + LPARAMETRO_PRONTUARIO + '" em ' + LQuery.RecordCount.ToString + ' unidades', IdUnidade);

          while not LQuery.eof do
          begin
            try
              begin
                LStatus := 1;
                LResposta.TryGetValue('DATAHORA', LDataRespostaRet);

                LDataResposta := StrToDateTime(LQuery.FieldByName('DATAHORA').AsString, fs);

                //LResposta.TryGetValue('ALTERNATIVA', LQuery.FieldByName('ALTERNATIVA_ID').AsInteger);
                LIdResposta := LQuery.FieldByName('ALTERNATIVA_ID').AsInteger;
                LUnidadeResposta := LIDsUnidades[LCont];
                Break;
              end;

              TLibDataSnap.UpdateStatus('Sucesso ao buscar resposta da pesquisa de Satisfação na unidade ' + IdUnidade , IdUnidade);
            except on e:exception do
              begin
                TLibDataSnap.UpdateStatus('Falha ao buscar resposta da pesquisa de Satisfação na unidade ' + IdUnidade + e.Message, IdUnidade);
              end;
            end;

            LQuery.Next;
          end;
        except on e:exception do
          TLibDataSnap.UpdateStatus('Falha ao buscar resposta da pesquisa de Satisfação' + e.Message , IdUnidade);
        end;
      finally
        FreeAndNil(LQuery);
      end;
      {$ENDREGION}
    end;
  finally
    Finalize(LIDsUnidades);
    FreeAndNil(LConexao);
  end;

  Result := TJSONObject.Create;
  Result.AddPair('STATUS', TJSONNumber.Create(LStatus));

  if LStatus = 1  then
  begin
    Result.AddPair('DATAHORA', FormatDateTime('DD/MM/YYYY HH:NN:SS', LDataResposta));
    Result.AddPair('ALTERNATIVA', TJSONNumber.Create(LIdResposta));
    Result.AddPair('UNIDADE', TJSONNumber.Create(LUnidadeResposta));
  end;
end;

end.

