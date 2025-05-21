unit uSMAtendente;

interface

uses System.SysUtils, System.Classes, System.JSON, Datasnap.DSServer,
  Datasnap.DSAuth, DataSnap.DSProviderDataModuleAdapter, Data.DBXPlatform,
  uDMSocket, uSMBase;

type
{$METHODINFO ON}
  TAtendente = class(TsmBase)
  private
    //private statements
  public
    function updateLogin(const aParams: TJSONObject): TJSONValue;
    function updateLogout(const aParams: TJSONObject): TJSONValue;
    function updateIniciarPausa(const aParams: TJSONObject): TJSONValue;
    function updateEncerrarPausa(const aParams: TJSONObject): TJSONValue;
    function ObterDados(const ANomeIDAtendente: String; const AIdUnidade: String): TJSONObject;
    function ObterFoto(const ANomeAtendente: String; const AIdUnidade: String): String;
    function ObterAtendentesPorGrupo(const AIDGrupoAtendente: String; const AIdUnidade: String): TJSONArray;
    function ObterAtendentes(const AIdUnidade: String): TJSONArray;
  end;

  //apenas para expor a URI sem o prefixo "T"
  Atendente = class(TAtendente);

{$METHODINFO OFF}

implementation

{$R *.dfm}

uses
  uLibDatasnap,
  uConsts,
  udmControleDeTokens,
  FireDAC.Comp.Client,
  Data.DB,
  Datasnap.DSHTTPWebBroker,
  UConexaoBD;

{ TAtendente }

{$J+}  //diretiva para habilitar alteração de const (necessária para possibilitar "unidade" ou "idunidade" neste endpoint)

function TAtendente.ObterAtendentesPorGrupo(const AIDGrupoAtendente,  AIdUnidade: String): TJSONArray;
const
  LSQL = 'SELECT NOME, ID_ATD_CLI FROM ATENDENTES WHERE ATIVO = %s AND ID_GRUPOATENDENTE = %d';

var
  LConexao:           TFDConnection;
  LQuery:             TFDQuery;
  LID_GRUPOATENDENTE: Integer;
  LATIVO: String;

  LATENDENTE: TJSONObject;
begin
  try
    if dmControleDeTokens.ChecarComandoDuplicado('get Atendente/ObterAtendentesPorGrupo', AIdUnidade) then
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

      {$REGION 'Get Obter Atendentes Por Grupo'}
      LQuery := TFDQuery.Create(nil);
      result := TJSONArray.Create;
      try
        LATIVO             := 'T';
        LID_GRUPOATENDENTE := StrToIntDef(AIDGrupoAtendente,0);


        LQuery.Connection := LConexao;
        try
          LQuery.Close;
          LQuery.SQL.Text := Format(LSQL, [ QuotedStr(LATIVO), LID_GRUPOATENDENTE]);
          LQuery.Open;

          if not LQuery.IsEmpty then
          begin
            LQuery.First;
            while not LQuery.Eof do
            begin
              LATENDENTE := TJSONObject.Create;
              LATENDENTE.AddPair('Nome', LQuery.FieldByName('NOME').AsString);
              LATENDENTE.AddPair('IdAtendenteNoCliente', LQuery.FieldByName('ID_ATD_CLI').AsString);
              result.Add(LATENDENTE);

              LQuery.Next;
            end;
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
  except on E: Exception do
    raise Exception.Create('Error parsing input params');
  end;

  TLibDataSnap.UpdateStatus('Atendente.ObterAtendentesPorGrupo. Grupo:' + AIDGrupoAtendente, IdUnidade);
end;

function TAtendente.ObterAtendentes(const AIdUnidade: String): TJSONArray;
const
  LSQL = 'SELECT ID, NOME, ID_ATD_CLI, ATIVO FROM ATENDENTES';

var
  LConexao:           TFDConnection;
  LQuery:             TFDQuery;
  LATIVO: String;

  LATENDENTE: TJSONObject;
begin
  try
    if dmControleDeTokens.ChecarComandoDuplicado('get Atendente/ObterAtendentes', AIdUnidade) then
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

      {$REGION 'Get Obter Atendentes Por Grupo'}
      LQuery := TFDQuery.Create(nil);
      result := TJSONArray.Create;
      try
        LATIVO             := 'T';
        //LID_GRUPOATENDENTE := StrToIntDef(AIDGrupoAtendente,0);

        LQuery.Connection := LConexao;
        try
          LQuery.Close;
          LQuery.SQL.Text := LSQL;
          LQuery.Open;

          if not LQuery.IsEmpty then
          begin
            LQuery.First;
            while not LQuery.Eof do
            begin
              LATENDENTE := TJSONObject.Create;
              LATENDENTE.AddPair('Id', LQuery.FieldByName('ID').AsString);
              LATENDENTE.AddPair('Nome', LQuery.FieldByName('NOME').AsString);
              LATENDENTE.AddPair('IdAtendenteCliente', LQuery.FieldByName('ID_ATD_CLI').AsString);
              LATENDENTE.AddPair('Ativo', LQuery.FieldByName('ATIVO').AsString);
              result.Add(LATENDENTE);

              LQuery.Next;
            end;
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
  except on E: Exception do
    raise Exception.Create('Error parsing input params');
  end;

  TLibDataSnap.UpdateStatus('Atendente.ObterAtendentes. ', IdUnidade);
end;

function TAtendente.ObterDados(const ANomeIDAtendente: String; const AIdUnidade: String): TJSONObject;
const
  LSQL_NOME   = 'SELECT ID, ID_TRIAGEM, TRIAGEM, IMPRIMIRPULSEIRA, CONVENIOMODULAR, NOME FROM ATENDENTES WHERE UPPER(NOME) = %s';
  LSQL_ID_ATD = 'SELECT ID, ID_TRIAGEM, TRIAGEM, IMPRIMIRPULSEIRA, CONVENIOMODULAR, NOME FROM ATENDENTES WHERE ID_ATD_CLI = %d';
  LSQL_PA     = 'SELECT ID_PA FROM ATEND_ATDS WHERE ID_ATD = %d';
  LSQL_FILAS  = 'SELECT ID_FILA FROM NN_PAS_FILAS WHERE ID_PA = %d';

var
  LConexao:         TFDConnection;
  LQuery:           TFDQuery;
  LID_ATD:          Integer;
  LID_PA:           Integer;
  LBool:            Boolean;
  LConvenioModular: Boolean;
  LIdAtdCli:        Integer;
  LIdTriagem:       Integer;
  LNome:            string;
begin
  try
    if dmControleDeTokens.ChecarComandoDuplicado('get Atendente/ObterDados', AIdUnidade) then
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

      {$REGION 'Get dados Atendente'}
      LQuery := TFDQuery.Create(nil);
      LIdAtdCli := strtointdef(ANomeIDAtendente,-1);
      try
        LQuery.Connection := LConexao;
        try
          LQuery.Close;
          if LIdAtdCli = - 1 then
            LQuery.SQL.Text := Format(LSQL_NOME, [QuotedStr(UpperCase(ANomeIDAtendente))])
          else
            LQuery.SQL.Text := Format(LSQL_ID_ATD, [LIdAtdCli]);
          LQuery.Open;

          if not LQuery.IsEmpty then
          begin
            LIdTriagem := 0;

            LID_ATD := LQuery.FieldByName('ID').AsInteger;

            if not LQuery.FieldByName('ID_TRIAGEM').IsNull then
            begin
              LIdTriagem  := LQuery.FieldByName('ID_TRIAGEM').AsInteger;
            end;

            LBool   := False;

            if not LQuery.FieldByName('TRIAGEM').IsNull then
            begin
              LBool  := (UpperCase(LQuery.FieldByName('TRIAGEM').AsString) = 'T');
            end;

            LConvenioModular   := False;

            if not LQuery.FieldByName('CONVENIOMODULAR').IsNull then
            begin
              LConvenioModular  := (UpperCase(LQuery.FieldByName('CONVENIOMODULAR').AsString) = 'T');
            end;

            LNome := EmptyStr;

            if not LQuery.FieldByName('NOME').IsNull then
            begin
              LNome  := UpperCase(LQuery.FieldByName('NOME').AsString);
            end;

            Result := TJSONObject.Create;
            Result.AddPair('Localizado', TJSONBool.Create(True));
            Result.AddPair('Id_Triagem', TJSONNumber.Create(LIdTriagem));
            Result.AddPair('Triagem', TJSONBool.Create(LBool));
            Result.AddPair('ConvenioModular', TJSONBool.Create(LConvenioModular));
            Result.AddPair('Nome', LNome);

            LBool   := False;

            if not LQuery.FieldByName('IMPRIMIRPULSEIRA').IsNull then
            begin
              LBool  := (UpperCase(LQuery.FieldByName('IMPRIMIRPULSEIRA').AsString) = 'T');
              Result.AddPair('ImprimirPulseira', TJSONBool.Create(LBool));
            end;

            LQuery.Close;
            LQuery.SQL.Clear;
            LQuery.SQL.Text := Format(LSQL_PA, [LID_ATD]);
            LQuery.Open;

            if not LQuery.FieldByName('ID_PA').IsNull then
            begin
              Result.AddPair('PA', TJSONNumber.Create( LQuery.FieldByName('ID_PA').AsInteger));

              LID_PA := LQuery.FieldByName('ID_PA').AsInteger;

              LQuery.Close;
              LQuery.SQL.Clear;
              LQuery.SQL.Text := Format(LSQL_FILAS, [LID_PA]);
              LQuery.Open;

              if not LQuery.IsEmpty then
              begin
                Result.AddPair('Fila', TJSONNumber.Create( LQuery.FieldByName('ID_FILA').AsInteger));
              end;
            end
            else
            begin
              Result.AddPair('PA', TJSONNumber.Create(0));
              Result.AddPair('Fila', TJSONNumber.Create(0));
            end;
          end
          else
          begin
            Result := TJSONObject.Create;
            Result.AddPair('Localizado', TJSONBool.Create(False));
            Result.AddPair('Triagem', TJSONBool.Create(False));
            Result.AddPair('PA', TJSONNumber.Create(0));
            Result.AddPair('Fila', TJSONNumber.Create(0));
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
  except on E: Exception do
    raise Exception.Create('Error parsing input params');
  end;

  TLibDataSnap.UpdateStatus('Atendente.ObterDados. Dados: ' + ANomeIDAtendente, IdUnidade);
end;

function TAtendente.ObterFoto(const ANomeAtendente: String; const AIdUnidade: String): String;
const
  cExtensao = '.jpeg';
  //Foi mudado a pesquisa por nome mais como não é um bom campo para pesquisa até por pode haver "Homônimo"
  //Temos que mudar o mais rapido possivel o campo de pesquisa o LBC está sabendo dessa situação
  LSQL      = 'SELECT FOTO FROM ATENDENTES WHERE UPPER(NOME) = %s';

var
  LConexao: TFDConnection;
  LQuery: TFDQuery;
  LStreamImage: TStream;
begin
  Result := EmptyStr;

  if dmControleDeTokens.ChecarComandoDuplicado('get Atendente/ObterFoto', IdUnidade) then
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
        LQuery.SQL.Text := Format(LSQL, [QuotedStr(UpperCase(ANomeAtendente))]);
        LQuery.Open;

        LStreamImage := TMemoryStream.Create;

        if not LQuery.FieldByName('FOTO').IsNull then
          TBlobField(LQuery.FieldByName('FOTO')).SaveToStream(LStreamImage);

        GetDataSnapWebModule.Response.ContentStream := LStreamImage;
        GetDataSnapWebModule.Response.StatusCode := 200;
        GetDataSnapWebModule.Response.ContentType := 'image/jpeg';
        GetDataSnapWebModule.Response.SendResponse;
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

function TAtendente.updateEncerrarPausa(const aParams: TJSONObject): TJSONValue;
const
  P_PA = 'PA';
var
  LAddr: Integer;
  LIdUnidade, LData, LResp: String;
begin
  TLibDataSnap.ValidateInputParams(aParams, [P_PA]);
  try
    LAddr := StrToInt(aParams.Values[P_PA].Value);
    if aParams.TryGetValue(P_IDUNIDADE, LIdUnidade) then
     IdUnidade := LIdUnidade;
    LData := '----'; //comando para finalizar a pausa
  except
    raise Exception.Create('Error parsing input params');
  end;

  if dmControleDeTokens.ChecarComandoDuplicado('post Atendente/EncerrarPausa', IdUnidade) then
    raise Exception.Create('Token duplicado');

  LResp := EnviarComando(LAddr, CMD_PAUSA, LData, [CMD_PAUSA_RES]);

  if LResp = '1' then
  begin
    result := TJSONTrue.Create;
    TLibDataSnap.UpdateStatus(Format('Pausa encerrada na PA "%s"',
                                     [aParams.Values['PA'].Value]),
                              IdUnidade);
  end
  else
  begin
    result := TJSONFalse.Create;
    TLibDataSnap.UpdateStatus(Format('Não foi possível encerrar a pausa na PA' +
                                     ' "%s"', [aParams.Values['PA'].Value]),
                              IdUnidade);
  end;
end;

function TAtendente.updateIniciarPausa(const aParams: TJSONObject): TJSONValue;
const
  P_PA = 'PA';
  P_MOTIVOPAUSA = 'MotivoPausa';
var
  LAddr, LMoti: Integer;
  LIdUnidade, LData, LResp: String;
begin
  TLibDataSnap.ValidateInputParams(aParams, [P_PA, P_MOTIVOPAUSA]);
  try
    LAddr := StrToInt(aParams.Values[P_PA].Value);
    LMoti := StrToInt(aParams.Values[P_MOTIVOPAUSA].Value);
    if aParams.TryGetValue(P_IDUNIDADE, LIdUnidade) then
     IdUnidade := LIdUnidade;
    //forçar fila ZERO, isto é, finalizar o atendimento SE estiver em andamento
    LData := IntToHex(LMoti, 4) + '0000';
  except
    raise Exception.Create('Error parsing input params');
  end;

  if dmControleDeTokens.ChecarComandoDuplicado('post Atendente/IniciarPausa', IdUnidade) then
    raise Exception.Create('Token duplicado');

  LResp := EnviarComando(LAddr, CMD_PAUSA, LData, [CMD_PAUSA_RES]);

  if LResp = '1' then
  begin
    result := TJSONTrue.Create;
    TLibDataSnap.UpdateStatus(Format('Pausa iniciada na PA "%s", motivo "%s"',
                                     [aParams.Values[P_PA].Value,
                                     aParams.Values[P_MOTIVOPAUSA].Value]),
                              IdUnidade);
  end
  else
  begin
    result := TJSONFalse.Create;
    TLibDataSnap.UpdateStatus(Format('Não foi possível iniciar pausa na PA' +
                                     ' "%s" com o motivo "%s"',
                                     [aParams.Values[P_PA].Value,
                                      aParams.Values[P_MOTIVOPAUSA].Value]),
                              IdUnidade);
  end;
end;

function TAtendente.updateLogin(const aParams: TJSONObject): TJSONValue;
const
  P_PA = 'PA';
  P_LOGIN = 'Login';
  P_NOME  = 'Nome';
  P_GRUPOID = 'GrupoId';
  P_GRUPONOME = 'GrupoNome';
var
  LAddr, LGrId: Integer;
  LIdUnidade, LData, LResp: String;
begin
  TLibDataSnap.ValidateInputParams(aParams, [P_PA, P_LOGIN, P_NOME, P_GRUPOID,
                                             P_GRUPONOME]);
  try
    LAddr := StrToInt(aParams.Values[P_PA].Value);
    LGrId := StrToInt(aParams.Values[P_GRUPOID  ].Value);

    if aParams.TryGetValue(P_IDUNIDADE, LIdUnidade) then
      IdUnidade := LIdUnidade;

    LData := aParams.Values[P_LOGIN    ].Value + ';' +
             aParams.Values[P_NOME     ].Value + ';' +
             LGrId.ToString                    + ';' +
             aParams.Values[P_GRUPONOME].Value;
  except
    raise Exception.Create('Error parsing input params');
  end;

  if dmControleDeTokens.ChecarComandoDuplicado('post Atendente/Login', IdUnidade) then
    raise Exception.Create('Token duplicado');

  LResp := EnviarComando(LAddr, CMD_LOGIN, LData, [CMD_LOGIN_RES]);

  if LResp = '1' then
  begin
    result := TJSONTrue.Create;
    TLibDataSnap.UpdateStatus(Format('Logou atendente "%s" na PA "%s", com o' +
                                     ' grupo "%s"',
                                     [aParams.Values[P_NOME].Value,
                                      aParams.Values[P_PA].Value,
                                      aParams.Values[P_GRUPOID].Value + '-' +
                                      aParams.Values[P_GRUPONOME].Value]),
                              IdUnidade);
  end
  else
  begin
    result := TJSONFalse.Create;
    TLibDataSnap.UpdateStatus(Format('Não foi possível logar o atendente "%s"' +
                                     ' na PA "%s", com o grupo "%s"',
                                     [aParams.Values[P_NOME].Value,
                                      aParams.Values[P_PA].Value,
                                      aParams.Values[P_GRUPOID].Value + '-' +
                                      aParams.Values[P_GRUPONOME].Value]),
                              IdUnidade);
  end;
end;

function TAtendente.updateLogout(const aParams: TJSONObject): TJSONValue;
const
  P_PA = 'PA';
var
  LIdUnidade, LResp, LData: String;
  LAddr: Integer;
begin
  TLibDataSnap.ValidateInputParams(aParams, [P_PA]);

  try
    LAddr := StrToInt(aParams.Values[P_PA].Value);
    if aParams.TryGetValue(P_IDUNIDADE, LIdUnidade) then
     IdUnidade := LIdUnidade;
    LData := '0000'; //força redirecionar para a fila "0-Finalizar"
  except
    raise Exception.Create('Error parsing input params');
  end;

  if dmControleDeTokens.ChecarComandoDuplicado('post Atendente/Logout', IdUnidade) then
    raise Exception.Create('Token duplicado');

  LResp := EnviarComando(LAddr, CMD_LOGOUT, LData, [CMD_LOGOUT_RES]);

  if LResp = '1' then
  begin
    result := TJSONTrue.Create;
    TLibDataSnap.UpdateStatus(Format('Efetuou logout do atendente na PA "%s"',
                                     [aParams.Values['PA'].Value]),
                              IdUnidade);
  end
  else
  begin
    result := TJSONFalse.Create;
    TLibDataSnap.UpdateStatus(Format('Não foi possível efetuar logout do' +
                                     ' atendente na PA "%s"',
                                     [aParams.Values['PA'].Value]),
                              IdUnidade);
  end;
end;

end.

