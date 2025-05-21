unit uSMSenha;

interface

uses
  System.SysUtils, System.Classes, System.JSON, uDMSocket, uSMBase,
  Datasnap.DSHTTPWebBroker, Web.HTTPApp, MyDlls_DR, ASPHTTPRequest, SCC_m,
  System.Net.HttpClient, System.SyncObjs;

type
{$METHODINFO ON}
  TSenha = class(TsmBase)
  public
    function updateNomearCliente(const aParams: TJSONObject): TJSONValue;
    function updateEncaminhar(const aParams: TJSONObject): TJSONObject;
    function updateEncaminharComProximo(const aParams: TJSONObject): TJSONObject;
    function updateEncaminharComEspecifica(const aParams: TJSONObject): TJSONObject;
    function updateEncaminharComPausa(const aParams: TJSONObject): TJSONValue;
    function updateEncaminharComLogout(const aParams: TJSONObject): TJSONValue;
    function updateChamarEspecifica(const aParams: TJSONObject): TJSONObject;
    function updateGerarSenha(const aParams: TJSONObject): TJSONObject;
    function Status(const ASenha: Integer; const aIdUnidade: String): TJSONObject;
    function DadosAdicionais(const ASenha: Integer; const aIdUnidade: String): TJSONObject;
    function updateDadosAdicionais(const aParams: TJSONObject): TJSONObject;
    function updateReimprimirSenha(const aParams: TJSONObject): TJSONObject;
    function updateRemoverDaEspera(const aParams: TJSONObject): TJSONObject;
    function ChamarProximo (const aPA: Integer; const aIdUnidade: String): TJSONObject;
    function ListarTags (const ASenha: Integer; const aIdUnidade: String): TJSONObject;
    function updateMarcarTags (const aParams: TJSONObject): TJSONObject;
    function updateStatusSenhaSiaf(const aParams: TJSONObject): TJSONObject;
  end;

  //apenas para expor a URI sem o prefixo "T"
  Senha = class(TSenha);
{$METHODINFO OFF}

implementation

{$R *.dfm}

uses
  uLibDatasnap, uConsts, System.Types, Winapi.Windows, udmControleDeTokens;

var
  LCrit: TCriticalSection;

{ TSenha }

function TSenha.ChamarProximo(const aPA: Integer; const aIdUnidade: String): TJSONObject;
const
  P_SENHA = 'Senha';

  CHAVE_SUCESSO      = 'Sucesso';
  CHAVE_IDMOTIVO     = 'IdMotivo';
  CHAVE_DESCMOTIVO   = 'DescricaoMotivo';
  CHAVE_SENHACHAMADA = 'Senha';
  CHAVE_IDFILA       = 'IdFila';
  CHAVE_NOMEFILA     = 'NomeFila';
  CHAVE_DATAHORA     = 'DataHora';

var
  LAddr : Integer;
  LData, LResp: String;
  LComandosEsperados: TIntegerDynArray;

  LCmdResp, LMotivoNaoChamou : Integer;
  LMsgStatus, SenhaChamada, DataHora, IdFila, NomeFila: string;
begin
  try
    LComandosEsperados := [CMD_RES_SENHA_CHAMOU, CMD_RES_SENHA_NAO_CHAMOU];

    LAddr     := aPA;
    IdUnidade := aIdUnidade;
    LData     := '';
  except
    raise Exception.Create('Error parsing input params');
  end;

  IdUnidade := aIdUnidade;

  if dmControleDeTokens.ChecarComandoDuplicado('get Senha/ChamarProximo', IdUnidade) then
    raise Exception.Create('Token duplicado');

  LResp := EnviarComando(LAddr,
                         CMD_CHAMAR_PROXIMO,
                         LData,
                         LComandosEsperados);

  {$IFDEF DEBUG}OutputDebugString(PChar(LResp));{$ENDIF}

  if LResp = EmptyStr then
  begin
    result := TJSONObject.Create;
    result.AddPair(CHAVE_SUCESSO, TJSONFalse.Create);
    result.AddPair(CHAVE_IDMOTIVO, IntToHex(MNC_FILA_PARA_CHAMADA, 4));
    result.AddPair(CHAVE_DESCMOTIVO, GetDescricaoMotivo(MNC_FILA_PARA_CHAMADA));
    TLibDataSnap.UpdateStatus(Format('Endpoint Senha/ChamarProximo na PA %d falhou devido a motivo %s (%s).',
                                      [aPA, IntToHex(MNC_FILA_PARA_CHAMADA, 4), GetDescricaoMotivo(MNC_FILA_PARA_CHAMADA)]),
                              IdUnidade);
  end
  else
  begin
    LMotivoNaoChamou := -1;
    LMsgStatus := '';

    if Length(LResp) > 0 then
      LCmdResp := Ord(LResp[1])
    else
      LCmdResp := -1;

    case LCmdResp of
      CMD_RES_SENHA_CHAMOU     : begin
                                   //SenhaChamada :=  Copy(LResp, 2);
                                   SeparaStrings(Copy(LResp, 2), TAB, SenhaChamada, LResp);
                                   LMsgStatus := Format('Endpoint Senha/ChamarProximo chamou a senha %s para a PA %d.', [SenhaChamada, aPA]);
                                 end;
      CMD_RES_SENHA_NAO_CHAMOU : begin
                                   if Length(LResp) > 1 then
                                     LMotivoNaoChamou := Ord(LResp[2])
                                   else
                                     LMotivoNaoChamou := $FFFF;

                                   LMsgStatus := Format('Nenhuma senha foi chamada para a PA %d, motivo %s (%s).', [aPA, IntToHex(LMotivoNaoChamou, 4), GetDescricaoMotivo(LMotivoNaoChamou)]);
                                 end;
      else begin
             TLibDataSnap.UpdateStatus (Format('Retorno inesperado ao chamar próximo na PA %s: %s', [aPA, LResp]),
                                        IdUnidade);
             raise Exception.Create('Servidor retornou um conteúdo inesperado');
           end;
    end;

    TLibDataSnap.UpdateStatus(LMsgStatus, IdUnidade);

    result := TJSONObject.Create;

    if LMotivoNaoChamou < 0 then
    begin
      var
        Aux1, Aux2, Aux3: string;

      SeparaStrings(LResp, TAB, IdFila, Aux1);
      SeparaStrings(Aux1, TAB, NomeFila, DataHora); //

      result.AddPair(CHAVE_SUCESSO     , TJSONTrue.Create);
      result.AddPair(CHAVE_SENHACHAMADA, TJSONNumber.Create(StrToInt(SenhaChamada)));
      result.AddPair(CHAVE_DATAHORA    , TJSONString.Create(DataHora));
      result.AddPair(CHAVE_IDFILA      , TJSONNumber.Create(StrToIntDef(IdFila, 0)));
      result.AddPair(CHAVE_NOMEFILA    , TJSONString.Create(NomeFila));
    end
    else
    begin
      result.AddPair(CHAVE_SUCESSO   , TJSONFalse.Create);
      result.AddPair(CHAVE_IDMOTIVO  , IntToHex(LMotivoNaoChamou, 4));
      result.AddPair(CHAVE_DESCMOTIVO, GetDescricaoMotivo(LMotivoNaoChamou));
    end;
  end;
end;

function TSenha.DadosAdicionais(const ASenha: Integer; const aIdUnidade: String): TJSONObject;
var
  LAddr, LSenhaRetorno, LPosTab: Integer;
  LData, LResp: String;
  LComandosEsperados: TIntegerDynArray;
  LJSONObject: TJSONObject;
  LStatus, LMsg: String;

  procedure FinalizarComFalha(const AMsgLog, AMsgRetorno: String);
  begin
    TLibDataSnap.UpdateStatus(AMsgLog, IdUnidade);
    result := TJSONObject.Create;
    result.AddPair('senha', TJSONNumber.Create(ASenha));
    result.AddPair('sucesso', TJSONFalse.Create);
    if AMsgRetorno <> EmptyStr then
      result.AddPair('motivo', AMsgRetorno);
  end;

begin
  try
    LComandosEsperados := [CMD_OBTER_DADOS_ADICIONAIS_SENHA_RES];
    LAddr  := 0;
    LData  := IntToStr(ASenha);
  except
    raise Exception.Create('Error parsing input params');
  end;
  IdUnidade := aIdUnidade;

  if dmControleDeTokens.ChecarComandoDuplicado('get Senha/DadosAdicionais', IdUnidade) then
    raise Exception.Create('Token duplicado');

  LResp := EnviarComando(LAddr,
                         CMD_OBTER_DADOS_ADICIONAIS_SENHA,
                         LData,
                         LComandosEsperados);

  {$IFDEF DEBUG}OutputDebugString(PChar(LResp));{$ENDIF}

  if LResp <> EmptyStr then
  begin
    LPosTab := Pos(TAB, LResp);
    LSenhaRetorno := StrToIntDef(Copy(LResp, 1, LPosTab-1), -1);
    if ASenha <> LSenhaRetorno then
    begin
      FinalizarComFalha(Format('Falha ao obter status da senha "%d". O' +
                               ' servidor retornou dados da senha "%d".',
                               [ASenha, LSenhaRetorno]), '');
      exit;
    end;

    Delete(LResp, 1, LPosTab);

    LStatus := LResp[1];
    LMsg    := Copy(LResp, 2);

    TLibDataSnap.UpdateStatus(Format('Obtidos dados adicionais da senha "%d"', [ASenha]),
                              IdUnidade);

    LJSONObject := nil;
    if LStatus = '2' then
    begin
      LJSONObject := TJSONObject(TJSONObject.ParseJSONValue(LMsg));
      if not Assigned(LJSONObject) then
      begin
        FinalizarComFalha(Format('Falha ao converter JSON com dados adicionais' +
                                 ' da senha "%d"', [ASenha]),
                                 'Servidor retornou um conteúdo inesperado');
        exit;
      end;
    end;

    result := TJSONObject.Create;
    result.AddPair('sucesso', TJSONTrue.Create);
    result.AddPair('senha',   TJSONNumber.Create(ASenha));
    if Assigned(LJSONObject) then
      result.AddPair('dados', LJSONObject)
    else
    begin
      result.AddPair('dados', TJSONNull.Create);
      if (LMsg <> EmptyStr) then
        result.AddPair('motivo', LMsg);
    end;
  end
  else
    FinalizarComFalha(Format('Falha ao obter dados adicionais da senha "%d"', [ASenha]), '');
end;

function TSenha.updateStatusSenhaSiaf(const aParams: TJSONObject): TJSONObject;
const
  P_ID = 'id';
  P_MEDICALRECORD = 'medicalRecord';
  P_DOCUMENT = 'document';
  P_PASSAGE = 'passage';
  P_QUEUE = 'queue';
  P_PASSWORD = 'password';
  P_STATUS = 'status';

  CHAVE_SUCESSO = 'sucesso';
  CHAVE_FALHA   = 'falha';
var
  LStreamJson: TStringStream;
  LRetorno: IHTTPResponse;
  LStatus: String;
  LJSON: TJSONObject;
begin
  LJSON := TJSONObject.Create;

  try
    if not TLibDataSnap.ValidateInputParams(aParams, [P_ID, P_MEDICALRECORD, P_DOCUMENT, P_PASSAGE,
                                                      P_QUEUE, P_PASSWORD, P_STATUS])
    then
      raise Exception.Create('Error parsing input params');

    LStreamJson := TStringStream.Create(Utf8Encode(aParams.ToJSON));

    try
      LRetorno := ASPHTTPRequest.THTTPRequest.Post(MainForm.URL_AtualizaStatusSenha, LStreamJson);

      case LRetorno.StatusCode of
        200:
          begin
            Result := LJSON.AddPair('Status', CHAVE_SUCESSO);
            MainForm.ShowStatus(LStatus);
            TLibDataSnap.UpdateStatus('Senha.StatusSenhaSiaf: Endpoint remoto retornou Status 200 - ' + aParams.ToString, IdUnidade);
          end;
        400:
          begin
             LJSON.AddPair('Status', CHAVE_FALHA);
             LJSON.AddPair('Mensagem', LStatus);
             MainForm.ShowStatus('Erro no processamento. ' + LStatus);
             raise Exception.Create('Erro no processamento. ' + LStatus);
          end;
        404:
          begin
             LJSON.AddPair('Status', CHAVE_FALHA);
             LJSON.AddPair('Mensagem', LStatus);
             MainForm.ShowStatus('Usuario nao encontrado. ' + LStatus);
             raise Exception.Create('Usuario nao encontrado. ' + LStatus);
          end;
        else
          begin
             LJSON.AddPair('Status', CHAVE_FALHA);
             LJSON.AddPair('Mensagem', LStatus);
             MainForm.ShowStatus('Falha no processamento. ' + LStatus);
             raise Exception.Create('Falha no processamento. ' + LStatus);
          end;
      end;
    finally
      LStreamJson.Free;
    end;
  except
    Result := LJSON;
    TLibDataSnap.UpdateStatus('Senha.StatusSenhaSiaf: Endpoint remoto retornou status ' + inttostr(LRetorno.StatusCode) + ' - ' + aParams.ToString, IdUnidade);
    raise;
  end;
end;

function TSenha.ListarTags(const ASenha: Integer; const aIdUnidade: String): TJSONObject;
var
  LAddr              : Integer;
  LData, LResp       : String;
  LComandosEsperados : TIntegerDynArray;

  LSenha    : string;
  strTags   : string;
  arrayTags : TIntArray;
  LItens    : TJSONArray;
  LObj      : TJSONObject;

  LQtd      : integer;
  i         : Integer;
begin
  try
    LComandosEsperados := [CMD_LISTAR_TAGS_SENHA_RES];

    LAddr     := 0;
    LData     := IntToStr(ASenha);
    IdUnidade := aIdUnidade;
  except
    raise Exception.Create('Error parsing input params');
  end;

  if dmControleDeTokens.ChecarComandoDuplicado('get Senha/ListarTags', IdUnidade) then
    raise Exception.Create('Token duplicado');

  LResp := EnviarComando(LAddr,
                         CMD_LISTAR_TAGS_SENHA,
                         LData,
                         LComandosEsperados);

  if LResp <> EmptyStr then
  begin
    SeparaStrings(LResp, ';', LSenha, strTags);

    if LSenha = inttostr(ASenha) then
    begin
      strtointarray(strTags, arrayTags);

      LQtd := length(arrayTags);

      LItens := TJSONArray.Create;
      if LQtd > 0 then
      begin
        for i := Low(arrayTags) to High(arrayTags) do
        begin
          LObj := TJSONObject.Create;
          LObj.AddPair('ID', TJSONNumber.Create(arrayTags[i]));
          LItens.Add(LObj);
        end;
      end;

      result := TJSONObject.Create;
      result.AddPair('Quantidade', TJSONNumber.Create(LQtd));
      result.AddPair('Itens', LItens);

      TLibDataSnap.UpdateStatus(Format('Recuperou lista de TAGs da senha %d.', [aSenha]), IdUnidade);
    end
    else
    begin
      TLibDataSnap.UpdateStatus(Format('Erro ao recuperar lista de TAGs da senha %d. Senha retornada pelo servidor difere da senha solicitada.', [aSenha]), IdUnidade);
      raise Exception.Create(Format('Erro ao recuperar lista de TAGs da senha %d. Senha retornada pelo servidor difere da senha solicitada.', [aSenha]));
    end;
  end
  else
  begin
    TLibDataSnap.UpdateStatus(Format('Erro ao recuperar lista de TAGs da senha %d. Resposta inválida do servidor.', [aSenha]), IdUnidade);
    raise Exception.Create(Format('Erro ao recuperar lista de TAGs da senha %d. Resposta inválida do servidor.', [aSenha]));
  end;
end;


function TSenha.updateMarcarTags (const aParams: TJSONObject): TJSONObject;
const
  P_SENHA = 'Senha';
  P_IDTAG = 'IdTAG';
  P_MARCAR = 'Marcar';

  CHAVE_SUCESSO = 'sucesso';
var
  LMarcar, LSucesso                      : boolean;
  LIdTag, LAddr, LSenha, LComandoEnviado : Integer;
  LIdUnidade, LData, LResp               : String;
  LComandosEsperados                     : TIntegerDynArray;
begin
  LSucesso := false;

  TLibDataSnap.ValidateInputParams(aParams, [P_SENHA, P_IDTAG, P_MARCAR]);
  try
    LAddr   := 0;
    LSenha  := StrToInt (aParams.Values[P_SENHA ].Value);
    LIdTag  := StrToInt (aParams.Values[P_IDTAG ].Value);
    LMarcar := StrToBool(aParams.Values[P_MARCAR].Value);
    if aParams.TryGetValue(P_IDUNIDADE, LIdUnidade) then
      IdUnidade := LIdUnidade;

    if LMarcar then
    begin
      LComandoEnviado := CMD_MARCAR_TAG_SENHA;
      LComandosEsperados := [CMD_MARCAR_TAG_SENHA_RES];
    end
    else
    begin
      LComandoEnviado := CMD_DESMARCAR_TAG_SENHA;
      LComandosEsperados := [CMD_DESMARCAR_TAG_SENHA_RES];
    end;

    LData := IntToHex(LIdTag, 4) + inttostr(LSenha);
  except
    raise Exception.Create('Error parsing input params');
  end;

  if dmControleDeTokens.ChecarComandoDuplicado('post Senha/MarcarTags', IdUnidade) then
    raise Exception.Create('Token duplicado');

  LResp := EnviarComando(LAddr,
                         LComandoEnviado,
                         LData,
                         LComandosEsperados);

  if LResp <> EmptyStr then
    LSucesso := (Length(LResp) >= 1) and (LResp[1] = '0');

  result := TJSONObject.Create;
  if LSucesso then
    result.AddPair(CHAVE_SUCESSO, TJSONTrue.Create)
  else
    result.AddPair(CHAVE_SUCESSO, TJSONFalse.Create);

  if LSucesso then
  begin
    if LMarcar then
      TLibDataSnap.UpdateStatus(Format('TAGs %d marcada para a senha %d.', [LIdTag, LSenha]), IdUnidade)
    else
      TLibDataSnap.UpdateStatus(Format('TAGs %d desmarcada para a senha %d.', [LIdTag, LSenha]), IdUnidade)
  end
  else
  begin
    if LMarcar then
      TLibDataSnap.UpdateStatus(Format('Falhou o comando para marcar TAG %d para a senha %d.', [LIdTag, LSenha]), IdUnidade)
    else
      TLibDataSnap.UpdateStatus(Format('Falhou o comando para desmarcar TAG %d para a senha %d.', [LIdTag, LSenha]), IdUnidade)
  end;
end;


function TSenha.Status(const ASenha: Integer; const aIdUnidade: String): TJSONObject;
const
  P_SENHA = 'Senha';
var
  LAddr, LSenhaRetorno, LPosTab: Integer;
  LData, LResp: String;
  LComandosEsperados: TIntegerDynArray;
  LJSONObject: TJSONObject;
  LStatus, LIdLocal, LNomeLocal, LDtHrSenha: String;

  procedure FinalizarComFalha(const AMsgLog: String);
  begin
    TLibDataSnap.UpdateStatus(AMsgLog, IdUnidade);
    result := TJSONObject.Create;
    result.AddPair('senha', TJSONNumber.Create(ASenha));
    result.AddPair('sucesso', TJSONFalse.Create);
  end;

begin
  try
    LComandosEsperados := [CMD_GET_STATUS_SENHA_RES];
    LAddr  := 0;
    LData  := IntToStr(ASenha);
  except
    raise Exception.Create('Error parsing input params');
  end;
  IdUnidade := aIdUnidade;

  if dmControleDeTokens.ChecarComandoDuplicado('get Senha/Status', IdUnidade) then
    raise Exception.Create('Token duplicado');

  LResp := EnviarComando(LAddr,
                         CMD_GET_STATUS_SENHA,
                         LData,
                         LComandosEsperados);

  {$IFDEF DEBUG}OutputDebugString(PChar(LResp));{$ENDIF}

  if LResp <> EmptyStr then
  begin
    LPosTab := Pos(TAB, LResp);
    LSenhaRetorno := StrToIntDef(Copy(LResp, 1, LPosTab-1), -1);
    if ASenha <> LSenhaRetorno then
    begin
      FinalizarComFalha(Format('Falha ao obter status da senha "%d". O' +
                               ' servidor retornou o status da senha "%d".',
                               [ASenha, LSenhaRetorno]));

      exit;
    end;

    Delete(LResp, 1, LPosTab);

    LStatus    := LResp[1];
    LIdLocal   := IntToStr(StrToInt('$' + Copy(LResp, 2, 4)));
    Delete(LResp, 1, 5);
    LPosTab    := Pos(TAB, LResp);
    LNomeLocal := Copy(LResp, 1, LPosTab-1);
    Delete(LResp, 1, LPosTab);
    LDtHrSenha := LResp;

    TLibDataSnap.UpdateStatus(Format('Obtido o status da senha "%d"', [ASenha]),
                              IdUnidade);

    result := TJSONObject.Create;
    result.AddPair('sucesso', TJSONTrue.Create);
    result.AddPair('senha',   TJSONNumber.Create(ASenha));
    result.AddPair('status',  LStatus);
    result.AddPair('emissao', LDtHrSenha);

    if LStatus <> 'I' then
    begin
      LJSONObject := TJSONObject.Create;
      LJSONObject.AddPair('id', TJSONNumber.Create(LIDLocal));
      LJSONObject.AddPair('nome', LNomeLocal);
      result.AddPair('local', LJSONObject);
    end;
  end
  else
    FinalizarComFalha(Format('Falha ao obter status da senha "%d"', [ASenha]));
end;

function TSenha.updateRemoverDaEspera(const aParams: TJSONObject): TJSONObject;
const
  P_SENHA   = 'Senha';
  P_MOTIVO  = 'Motivo';
  P_USUARIO = 'Usuario';
  CHAVE_SUCESSO = 'sucesso';
var
  LAddr: Integer;
  LIdUnidade, LSenha, LMotivo , LUsuario, LDados, LResp, LOrigemIP,
  LOrigemHost: string;
  LDadosJSON: TJSONObject;
  LRequest: TWebRequest;
begin
  LAddr := 0;
  TLibDataSnap.ValidateInputParams(aParams, [P_IDUNIDADE, P_SENHA, P_MOTIVO, P_USUARIO]);
  try
    aParams.TryGetValue(P_SENHA, LSenha);
    aParams.TryGetValue(P_MOTIVO, LMotivo);
    aParams.TryGetValue(P_USUARIO, LUsuario);
    aParams.TryGetValue(P_IDUNIDADE, LIdUnidade);
  except
    raise Exception.Create('Error parsing input params');
  end;

  if dmControleDeTokens.ChecarComandoDuplicado('post Senha/RemoverDaEspera', IdUnidade) then
    raise Exception.Create('Token duplicado');

  try
    LRequest := GetDataSnapWebModule.Request;
    LOrigemIP := LRequest.RemoteIP;
    LOrigemHost := LRequest.RemoteHost;
  except
    LOrigemIP := EmptyStr;
    LOrigemHost := EmptyStr;
  end;

  LDadosJSON := TJSONObject.Create;
  try
    LDadosJSON.AddPair('delmotivo', LMotivo);
    LDadosJSON.AddPair('delusuario', LUsuario);
    if LOrigemIP <> EmptyStr then
      LDadosJSON.AddPair('deliporigem', LOrigemIP);
    if LOrigemHost <> EmptyStr then
      LDadosJSON.AddPair('delhostorigem', LOrigemHost);

    IdUnidade := LIdUnidade;
    LDados := LSenha + TAB + LDadosJSON.ToString;

    LResp := EnviarComando(LAddr,
                         CMD_CANCELAR_SENHA,
                         LDados,
                         [ACK]);

    result := TJSONObject.Create;
    result.AddPair(CHAVE_SUCESSO, TJSONTrue.Create);
  finally
    LDadosJSON.Free;
  end;

  TLibDataSnap.UpdateStatus('Senha.RemoverDaEspera:' + aParams.ToString, IdUnidade);
end;


function TSenha.updateChamarEspecifica(const aParams: TJSONObject): TJSONObject;
const
  P_PA = 'PA';
  P_SENHA = 'Senha';
  P_FORCAR_CHAMADA = 'ForcarChamada';

  CHAVE_SUCESSO  = 'sucesso';
  CHAVE_MOTIVO   = 'motivo';
  CHAVE_IDFILA   = 'IdFila';
  CHAVE_NOMEFILA = 'NomeFila';
  CHAVE_DATAHORA = 'DataHora';

var
  LAddr, LSenh: Integer;
  LData, LResp, LMsgStatus, SenhaChamada: String;
  LComandosEsperados: TIntegerDynArray;
  LCmdResp, LMotivoNaoChamou: Integer;
  LIdUnidade, LMsgStatusDefault, DataHora, IdFila, NomeFila: String;
  LForcarChamada:boolean;
begin
  TLibDataSnap.ValidateInputParams(aParams, [P_PA, P_SENHA]);
  try
    LComandosEsperados := [CMD_RES_SENHA_CHAMOU,
                           CMD_RES_SENHA_NAO_CHAMOU,
                           CMD_RES_SENHA_EM_NENHUMA_FILA,
                           CMD_RES_SENHA_FORA_PRIORI_ATD,
                           0];

    LAddr := StrToInt(aParams.Values[P_PA].Value);
    LSenh := StrToInt(aParams.Values[P_SENHA].Value);

    if aParams.Values[P_FORCAR_CHAMADA] = nil then
    begin
      LForcarChamada:= True;
    end
    else
    begin
      if Uppercase(aParams.Values[P_FORCAR_CHAMADA].Value) = 'TRUE' then
      begin
        LForcarChamada:= True;
      end
      else
      begin
        LForcarChamada:= False;
      end;
    end;


    if aParams.TryGetValue(P_IDUNIDADE, LIdUnidade) then
     IdUnidade := LIdUnidade;
    LData := LSenh.ToString;
  except
    raise Exception.Create('Error parsing input params');
  end;

  if dmControleDeTokens.ChecarComandoDuplicado('post Senha/ChamarEspecifica', IdUnidade) then
    raise Exception.Create('Token duplicado');

  LMsgStatusDefault := Format('senha "%s" na PA "%s"',
                              [aParams.Values[P_SENHA].Value,
                               aParams.Values[P_PA].Value]);

  if LForcarChamada then
  begin
    LResp := EnviarComando(LAddr,
                           CMD_FORCAR_CHAMADA_ESPECIFICA,
                           LSenh.ToString,
                           LComandosEsperados);
  end
  else
  begin
    LResp := EnviarComando(LAddr,
                           CMD_CHAMAR_ESPECIFICA,
                           LSenh.ToString,
                           LComandosEsperados);
  end;

  if LResp = EmptyStr then
  begin
    result := TJSONObject.Create;
    result.AddPair(CHAVE_SUCESSO, TJSONFalse.Create);
    result.AddPair(CHAVE_MOTIVO, IntToHex(MNC_FILA_PARA_CHAMADA, 4));
    TLibDataSnap.UpdateStatus('Tentou "rechamar" a ' + LMsgStatusDefault,
                              IdUnidade);
  end
  else
  begin
    LMotivoNaoChamou := -1;
    LMsgStatus := EmptyStr;

    if Length(LResp) > 0 then
      LCmdResp := Ord(LResp[1])
    else
      LCmdResp := -1;

    case LCmdResp of
      CMD_RES_SENHA_CHAMOU:
        {$REGION '//Chamou uma senha'}begin
          SeparaStrings(Copy(LResp, 2), TAB, SenhaChamada, LResp);

          if SenhaChamada = LSenh.ToString then
            LMsgStatus := 'Chamou a ' + LMsgStatusDefault
          else
          begin
            LMotivoNaoChamou := MNC_SENHA_DIVERGENTE;
            LMsgStatus := Format('Falha ao chamar a ' + LMsgStatusDefault +
                                 '. Retornou: %s', [LResp]);
          end;
        end{$ENDREGION};
      CMD_RES_SENHA_NAO_CHAMOU:
        {$REGION '//Nenhuma senha chamada'}begin
          if Length(LResp) > 1 then
            LMotivoNaoChamou := Ord(LResp[2])
          else
            LMotivoNaoChamou := $FFFF;

          LMsgStatus := Format('Nenhuma senha foi chamada, motivo "%s"',
                               [IntToHex(LMotivoNaoChamou, 4)]);
        end;{$ENDREGION}
      CMD_RES_SENHA_EM_NENHUMA_FILA:
        {$REGION '//Senha em nenhuma fila'}begin
            LMotivoNaoChamou := MNC_SENHA_NENHUMA_FILA;
            LMsgStatus := 'Falha ao chamar a ' + LMsgStatusDefault + ': não' +
                          ' está em nenhuma fila';
        end;{$ENDREGION}
      CMD_RES_SENHA_FORA_PRIORI_ATD:
        {$REGION '//Senha fora da Prioridade de Atend. do PA'}begin
          LMotivoNaoChamou := MNC_FORA_PRIORI_ADDR;
          LMsgStatus := 'Falha ao chamar a ' + LMsgStatusDefault + ': fora' +
                        ' das prioridades do PA';
        end;{$ENDREGION}
      else
      begin
        TLibDataSnap.UpdateStatus(Format('Retorno inesperado ao chamar senha' +
                                         ' "%s" na PA "%s": %s',
                                         [aParams.Values[P_SENHA].Value,
                                          aParams.Values[P_PA].Value,
                                          LResp]),
                                  IdUnidade);
        raise Exception.Create('Servidor retornou um conteúdo inesperado');
      end;
    end;

    TLibDataSnap.UpdateStatus(LMsgStatus, IdUnidade);

    result := TJSONObject.Create;

    if LMotivoNaoChamou < 0 then
    begin
      // #4870'#9'2'#9'Prioridade'#9'29/03/2023 11:59:20
      var
        Aux1: string;

      SeparaStrings(LResp, TAB, IdFila, Aux1);
      SeparaStrings(Aux1, TAB, NomeFila, DataHora); //

      result.AddPair(CHAVE_SUCESSO  , TJSONTrue.Create);
      result.AddPair(CHAVE_DATAHORA , TJSONString.Create(DataHora));
      result.AddPair(CHAVE_IDFILA   , TJSONNumber.Create(StrToIntDef(IdFila, 0)));
      result.AddPair(CHAVE_NOMEFILA , TJSONString.Create(NomeFila));
    end
    else
    begin
      result.AddPair(CHAVE_SUCESSO, TJSONFalse.Create);
      result.AddPair(CHAVE_MOTIVO, IntToHex(LMotivoNaoChamou, 4));
    end;
  end;

  TLibDataSnap.UpdateStatus('Senha.ChamarEspecifica:' + aParams.ToString, IdUnidade);
end;

function TSenha.updateDadosAdicionais(const aParams: TJSONObject): TJSONObject;
const
  P_SENHA = 'Senha';
  P_DADOS = 'Dados';

  CHAVE_SUCESSO = 'sucesso';
  CHAVE_SENHA   = 'senha';
  CHAVE_MOTIVO  = 'motivo';
var
  LAddr, LSenha, LPosTab, LSenhaRetorno: Integer;
  LIdUnidade, LData, LResp, LStatus, LMsg: String;
  LComandosEsperados: TIntegerDynArray;

  procedure FinalizarComFalha(const AMsgLog, AMsgRetorno: String);
  begin
    TLibDataSnap.UpdateStatus(AMsgLog, IdUnidade);
    result := TJSONObject.Create;
    result.AddPair(CHAVE_SENHA, TJSONNumber.Create(LSenha));
    result.AddPair(CHAVE_SUCESSO, TJSONFalse.Create);
    if AMsgRetorno <> EmptyStr then
      result.AddPair(CHAVE_MOTIVO, AMsgRetorno);
  end;

begin
  TLibDataSnap.ValidateInputParams(aParams, [P_SENHA, P_DADOS]);
  try
    LComandosEsperados := [CMD_ATUALIZAR_DADOS_ADICIONAIS_SENHA_RES];
    LAddr  := 0;
    LSenha := StrToInt(aParams.Values[P_SENHA].Value);
    if aParams.TryGetValue(P_IDUNIDADE, LIdUnidade) then
     IdUnidade := LIdUnidade;
    LData  := IntToStr(LSenha) + TAB + aParams.Values[P_DADOS].ToJSON;
  except
    raise Exception.Create('Error parsing input params');
  end;

  if dmControleDeTokens.ChecarComandoDuplicado('post Senha/DadosAdicionais', IdUnidade) then
    raise Exception.Create('Token duplicado');

  LResp := EnviarComando(LAddr,
                         CMD_ATUALIZAR_DADOS_ADICIONAIS_SENHA,
                         LData,
                         LComandosEsperados);

  {$IFDEF DEBUG}OutputDebugString(PChar(LResp));{$ENDIF}

  if LResp <> EmptyStr then
  begin
    LPosTab := Pos(TAB, LResp);
    LSenhaRetorno := StrToIntDef(Copy(LResp, 1, LPosTab-1), -1);
    if LSenha <> LSenhaRetorno then
    begin
      FinalizarComFalha(Format('Falha ao atualizar dados adicionais da senha' +
                               ' "%d". O servidor retornou dados da senha "%d".',
                               [LSenha, LSenhaRetorno]), 'senha divergente');
      exit;
    end;

    Delete(LResp, 1, LPosTab);
    LStatus := LResp[1];
    LMsg    := Trim(Copy(LResp, 2));
    if LMsg = EmptyStr then
      LMsg := 'desconhecido';

    result := TJSONObject.Create;
    if LStatus = '0' then
      FinalizarComFalha(Format('Falha ao atualizar dados adicionais da senha' +
                               ' "%d": %s.', [LSenha, LMsg]), LMsg)
    else
    begin
      TLibDataSnap.UpdateStatus(Format('Atualizado dados adicionais da senha "%d"', [LSenha]),
                                IdUnidade);
      result.AddPair(CHAVE_SUCESSO, TJSONTrue.Create);
      result.AddPair(CHAVE_SENHA,   TJSONNumber.Create(LSenha));
    end;
  end
  else
    FinalizarComFalha(Format('Falha ao gerar senha para a Fila "%d"', [LSenha]), '');

  TLibDataSnap.UpdateStatus('Senha.DadosAdicionais:' + aParams.ToString, IdUnidade);
end;

function TSenha.updateEncaminhar(const aParams: TJSONObject): TJSONObject;
const
  P_PA = 'PA';
  P_FILA = 'Fila';
  CHAVE_SUCESSO = 'sucesso';
  CHAVE_MOTIVO = 'motivo';
var
  LAddr, LFila, LCmdResp, LMotivoNaoChamou: Integer;
  LIdUnidade, LData, LResp, LMsgStatus, LMsgStatusDefault: String;
  LComandosEsperados: TIntegerDynArray;
begin
  TLibDataSnap.ValidateInputParams(aParams, [P_PA, P_FILA]);
  try
    LComandosEsperados := [CMD_RES_SENHA_CHAMOU, CMD_RES_SENHA_NAO_CHAMOU, 0];
    LAddr := StrToInt(aParams.Values[P_PA].Value);
    LFila := StrToInt(aParams.Values[P_FILA].Value);
    if aParams.TryGetValue(P_IDUNIDADE, LIdUnidade) then
     IdUnidade := LIdUnidade;
    LData := IntToHex(LFila, 4);
  except
    raise Exception.Create('Error parsing input params');
  end;

  if dmControleDeTokens.ChecarComandoDuplicado('post Senha/Encaminhar', IdUnidade) then
    raise Exception.Create('Token duplicado');

  LResp := EnviarComando(LAddr,
                         CMD_REDIRECIONA,
                         LData,
                         LComandosEsperados);

  LMsgStatusDefault := Format('cliente na PA "%s" para a Fila "%s"',
                              [aParams.Values[P_PA].Value,
                               aParams.Values[P_FILA].Value]);

  if LResp = EmptyStr then
  begin
    result := TJSONObject.Create;
    result.AddPair(CHAVE_SUCESSO, TJSONFalse.Create);
    result.AddPair(CHAVE_MOTIVO, IntToHex(MNC_FILA_PARA_CHAMADA, 4));
    TLibDataSnap.UpdateStatus('Tentou refazer a transferência do ' +
                              LMsgStatusDefault,
                              IdUnidade);
  end
  else
  begin
    LMotivoNaoChamou := -1;
    LMsgStatus := EmptyStr;

    if Length(LResp) > 0 then
      LCmdResp := Ord(LResp[1])
    else
      LCmdResp := -1;

    case LCmdResp of
      CMD_RES_SENHA_CHAMOU:
        {$REGION '//Chamou uma senha'}begin
          LMsgStatus := 'Encaminhou ' + LMsgStatusDefault + ' e chamou a' +
                        ' senha ' + Copy(LResp, 2);
        end{$ENDREGION};
      CMD_RES_SENHA_NAO_CHAMOU:
        {$REGION '//Nenhuma senha chamada'}begin
          if (Length(LResp) > 1)  then
          begin
            if LResp[2] <> '0' then
              LMotivoNaoChamou := Ord(LResp[2])
          end
          else
            LMotivoNaoChamou := $FFFF;

          if LMotivoNaoChamou = -1 then
            LMsgStatus := 'Encaminhou ' + LMsgStatusDefault
          else
            LMsgStatus := Format('Falha ao encaminhar o ' + LMsgStatusDefault +
                                 ', motivo: %s',
                                 [IntToHex(LMotivoNaoChamou, 4)]);
        end;{$ENDREGION}
      else
      begin
        TLibDataSnap.UpdateStatus(Format('Retorno inesperado ao encaminhar a' +
                                         'senha "%s" para a fila "%s": %s',
                                         [aParams.Values[P_PA].Value,
                                          aParams.Values[P_FILA].Value,
                                          LResp]),
                                  IdUnidade);
        raise Exception.Create('Servidor retornou um conteúdo inesperado');
      end;
    end;

    TLibDataSnap.UpdateStatus(LMsgStatus, IdUnidade);
    result := TJSONObject.Create;
    if LMotivoNaoChamou < 0 then
      result.AddPair(CHAVE_SUCESSO, TJSONTrue.Create)
    else
    begin
      result.AddPair(CHAVE_SUCESSO, TJSONFalse.Create);
      result.AddPair(CHAVE_MOTIVO, IntToHex(LMotivoNaoChamou, 4));
    end;
  end;

//  if Length(LResp) > 0 then
//  begin
//    LMotivoNaoChamou := -1;
//    LMsgStatus := EmptyStr;
//
//    if Length(LResp) > 0 then
//      LCmdResp := Ord(LResp[1])
//    else
//      LCmdResp := -1;
//
//    case LCmdResp of
//      CMD_RES_SENHA_CHAMOU,
//      CMD_RES_SENHA_NAO_CHAMOU:
//        begin
//          if Length(LResp) > 1 then
//            LMotivoNaoChamou := Ord(LResp[2])
//          else
//            LMotivoNaoChamou := $FFFF;
//
//          LMsgStatus := Format('Nenhuma senha foi chamada, motivo "%s"',
//                               [IntToHex(LMotivoNaoChamou, 4)]);
//        end;
//      else
//      begin
//        TLibDataSnap.UpdateStatus(Format('Retorno inesperado ao encaminhar' +
//                                         ' cliente do PA "%s" para a Fila' +
//                                         ' "%s": %s',
//                                         [aParams.Values[P_PA].Value,
//                                          aParams.Values[P_FILA].Value,
//                                          LResp]));
//        raise Exception.Create('Servidor retornou um conteúdo inesperado');
//      end;
//    end;
//
//    TLibDataSnap.UpdateStatus(LMsgStatus);
//    result := TJSONObject.Create;
//    if LMotivoNaoChamou < 0 then
//      result.AddPair(CHAVE_SUCESSO, TJSONTrue.Create)
//    else
//    begin
//      result.AddPair(CHAVE_SUCESSO, TJSONFalse.Create);
//      result.AddPair(CHAVE_MOTIVO, IntToHex(LMotivoNaoChamou, 4));
//    end;
//  end
//  else
//  begin
//    TLibDataSnap.UpdateStatus(Format('Falha ao encaminhar cliente do PA "%s"' +
//                                     ' para a Fila "%s"',
//                                     [aParams.Values[P_PA].Value,
//                                      aParams.Values[P_FILA].Value]));
//    result := TJSONObject.Create;
//    result.AddPair(CHAVE_SUCESSO, TJSONFalse.Create)
//  end;

(*
  if Length(LResp) > 0 then
  begin
    TLibDataSnap.UpdateStatus(Format('Encaminhou cliente do PA "%s"' +
                                     ' para a Fila "%s"',
                                     [aParams.Values[P_PA].Value,
                                      aParams.Values[P_FILA].Value]));
    result := TJSONTrue.Create
  end

*)
end;

function TSenha.updateEncaminharComEspecifica(const aParams: TJSONObject): TJSONObject;
const
  P_PA = 'PA';
  P_SENHA = 'Senha';
  P_FILA = 'Fila';

  CHAVE_SUCESSO = 'sucesso';
  CHAVE_MOTIVO = 'motivo';
var
  LAddr, LSenh,LFila: Integer;
  LData, LResp, LMsgStatus: String;
  LComandosEsperados: TIntegerDynArray;
  LCmdResp, LMotivoNaoChamou: Integer;
  LIdUnidade, LMsgStatusDefault: String;
begin
  TLibDataSnap.ValidateInputParams(aParams, [P_PA, P_SENHA,P_FILA]);
  try
    LComandosEsperados := [CMD_RES_SENHA_CHAMOU,
                           CMD_RES_SENHA_NAO_CHAMOU,
                           CMD_RES_SENHA_EM_NENHUMA_FILA,
                           CMD_RES_SENHA_FORA_PRIORI_ATD,
                           0];

    LAddr := StrToInt(aParams.Values[P_PA].Value);
    LSenh := StrToInt(aParams.Values[P_SENHA].Value);
    LFila := StrToInt(aParams.Values[P_Fila].Value);
    if aParams.TryGetValue(P_IDUNIDADE, LIdUnidade) then
     IdUnidade := LIdUnidade;
    LData := IntToHex(LFila, 4) + LSenh.ToString;
  except
    raise Exception.Create('Error parsing input params');
  end;

  if dmControleDeTokens.ChecarComandoDuplicado('post Senha/EncaminharComEspecifica', IdUnidade) then
    raise Exception.Create('Token duplicado');

  LMsgStatusDefault := Format('senha "%s" na PA "%s"',
                              [aParams.Values[P_SENHA].Value,
                               aParams.Values[P_PA].Value]);

  LResp := EnviarComando(LAddr,
                         CMD_REDIRECIONA_E_ESPECIFICA,
                         LData,
                         LComandosEsperados);

  if LResp = EmptyStr then
  begin
    result := TJSONObject.Create;
    result.AddPair(CHAVE_SUCESSO, TJSONFalse.Create);
    result.AddPair(CHAVE_MOTIVO, IntToHex(MNC_FILA_PARA_CHAMADA, 4));
    TLibDataSnap.UpdateStatus('Tentou "rechamar" a ' + LMsgStatusDefault,
                              IdUnidade);
  end
  else
  begin
    LMotivoNaoChamou := -1;
    LMsgStatus := EmptyStr;

    if Length(LResp) > 0 then
      LCmdResp := Ord(LResp[1])
    else
      LCmdResp := -1;

    case LCmdResp of
      CMD_RES_SENHA_CHAMOU:
        {$REGION '//Chamou uma senha'}begin
          if Copy(LResp, 2) = LSenh.ToString then
            LMsgStatus := 'Chamou a ' + LMsgStatusDefault
          else
          begin
            LMotivoNaoChamou := MNC_SENHA_DIVERGENTE;
            LMsgStatus := Format('Falha ao chamar a ' + LMsgStatusDefault +
                                 '. Retornou: %s', [LResp]);
          end;
        end{$ENDREGION};
      CMD_RES_SENHA_NAO_CHAMOU:
        {$REGION '//Nenhuma senha chamada'}begin
          if Length(LResp) > 1 then
            LMotivoNaoChamou := Ord(LResp[2])
          else
            LMotivoNaoChamou := $FFFF;

          LMsgStatus := Format('Nenhuma senha foi chamada, motivo "%s"',
                               [IntToHex(LMotivoNaoChamou, 4)]);
        end;{$ENDREGION}
      CMD_RES_SENHA_EM_NENHUMA_FILA:
        {$REGION '//Senha em nenhuma fila'}begin
            LMotivoNaoChamou := MNC_SENHA_NENHUMA_FILA;
            LMsgStatus := 'Falha ao chamar a ' + LMsgStatusDefault + ': não' +
                          ' está em nenhuma fila';
        end;{$ENDREGION}
      CMD_RES_SENHA_FORA_PRIORI_ATD:
        {$REGION '//Senha fora da Prioridade de Atend. do PA'}begin
          LMotivoNaoChamou := MNC_FORA_PRIORI_ADDR;
          LMsgStatus := 'Falha ao chamar a ' + LMsgStatusDefault + ': fora' +
                        ' das prioridades do PA';
        end;{$ENDREGION}
      else
      begin
        TLibDataSnap.UpdateStatus(Format('Retorno inesperado ao chamar senha' +
                                         ' "%s" na PA "%s": %s',
                                         [aParams.Values[P_SENHA].Value,
                                          aParams.Values[P_PA].Value,
                                          LResp]),
                                  IdUnidade);
        raise Exception.Create('Servidor retornou um conteúdo inesperado');
      end;
    end;

    TLibDataSnap.UpdateStatus(LMsgStatus, IdUnidade);
    result := TJSONObject.Create;
    if LMotivoNaoChamou < 0 then
      result.AddPair(CHAVE_SUCESSO, TJSONTrue.Create)
    else
    begin
      result.AddPair(CHAVE_SUCESSO, TJSONFalse.Create);
      result.AddPair(CHAVE_MOTIVO, IntToHex(LMotivoNaoChamou, 4));
    end;
  end;
//  TLibDataSnap.ValidateInputParams(aParams, ['PA', 'Fila', 'SenhaEspecifica']);
//
//  Sleep(1000);
//
//  Result := TJSONTrue.Create;
//
//  TLibDataSnap.UpdateStatus(Format('Encaminhou cliente na PA "%s" para a Fila' +
//                                   ' "%s", chamando a senha "%s"',
//                                   [aParams.Values['PA'].Value,
//                                    aParams.Values['Fila'].Value,
//                                    aParams.Values['SenhaEspecifica'].Value]));
end;

function TSenha.updateEncaminharComLogout(const aParams: TJSONObject): TJSONValue;
const
  P_PA = 'PA';
  P_FILA = 'Fila';
var
  LAddr, LFila: Integer;
  LIdUnidade, LData, LResp: String;
  LComandosEsperados: TIntegerDynArray;
begin
  TLibDataSnap.ValidateInputParams(aParams, [P_PA, P_FILA]);
  try
    LComandosEsperados := [CMD_LOGOUT_RES];

    LAddr := StrToInt(aParams.Values[P_PA].Value);
    LFila := StrToInt(aParams.Values[P_FILA].Value);
    if aParams.TryGetValue(P_IDUNIDADE, LIdUnidade) then
     IdUnidade := LIdUnidade;
    LData := IntToHex(LFila, 4);
  except
    raise Exception.Create('Error parsing input params');
  end;

  if dmControleDeTokens.ChecarComandoDuplicado('post Senha/EncaminharComLogout', IdUnidade) then
    raise Exception.Create('Token duplicado');

  LResp := EnviarComando(LAddr,
                         CMD_LOGOUT,
                         LData,
                         LComandosEsperados);

  if LResp = '1' then
  begin
    result := TJSONTrue.Create;
    TLibDataSnap.UpdateStatus(Format('Cliente encaminhado do PA "%s" para a' +
                                     ' fila "%s", fazendo logout do atendente',
                                     [aParams.Values[P_PA].Value,
                                      aParams.Values[P_FILA].Value]),
                              IdUnidade);
  end
  else
  begin
    result := TJSONFalse.Create;
    TLibDataSnap.UpdateStatus(Format('Não foi possível encaminhar o cliente do' +
                                     ' PA "%s" para a fila "%s" e fazer logout' +
                                     ' do atendente',
                                     [aParams.Values[P_PA].Value,
                                      aParams.Values[P_FILA].Value]),
                              IdUnidade);
  end;
end;

function TSenha.updateEncaminharComPausa(const aParams: TJSONObject): TJSONValue;
const
  P_PA = 'PA';
  P_FILA = 'Fila';
  P_MOTIVOPAUSA = 'MotivoPausa';
var
  LAddr, LFila, LMoti: Integer;
  LIdUnidade, LData, LResp: String;
  LComandosEsperados: TIntegerDynArray;
begin
  TLibDataSnap.ValidateInputParams(aParams, [P_PA, P_FILA, P_MOTIVOPAUSA]);
  try
    LComandosEsperados := [CMD_PAUSA_RES];

    LAddr := StrToInt(aParams.Values[P_PA].Value);
    LFila := StrToInt(aParams.Values[P_FILA].Value);
    LMoti := StrToInt(aParams.Values[P_MOTIVOPAUSA].Value);
    if aParams.TryGetValue(P_IDUNIDADE, LIdUnidade) then
     IdUnidade := LIdUnidade;
    LData := IntToHex(LMoti, 4) + IntToHex(LFila, 4);
  except
    raise Exception.Create('Error parsing input params');
  end;

  if dmControleDeTokens.ChecarComandoDuplicado('post Senha/EncaminharComPausa', IdUnidade) then
    raise Exception.Create('Token duplicado');

  LResp := EnviarComando(LAddr,
                         CMD_PAUSA,
                         LData,
                         LComandosEsperados);

  if LResp = '1' then
  begin
    result := TJSONTrue.Create;
    TLibDataSnap.UpdateStatus(Format('Cliente encaminhado do PA "%s" para a' +
                                     ' fila "%s", iniciando pausa com motivo "%s"',
                                     [aParams.Values[P_PA].Value,
                                      aParams.Values[P_FILA].Value,
                                      aParams.Values[P_MOTIVOPAUSA].Value]),
                              IdUnidade);
  end
  else
  begin
    result := TJSONFalse.Create;
    TLibDataSnap.UpdateStatus(Format('Não foi possível encaminhar o cliente do' +
                                     ' PA "%s" para a fila "%s" e iniciar a' +
                                     ' pausa com motivo "%s"',
                                     [aParams.Values[P_PA].Value,
                                      aParams.Values[P_FILA].Value,
                                      aParams.Values[P_MOTIVOPAUSA].Value]),
                              IdUnidade);
  end;
end;

function TSenha.updateEncaminharComProximo(const aParams: TJSONObject): TJSONObject;
const
  P_PA = 'PA';
  P_FILA = 'Fila';

  CHAVE_SUCESSO = 'sucesso';
  CHAVE_MOTIVO = 'motivo';
var
  LAddr, LFila: Integer;
  LData, LResp, LMsgStatus: String;
  LComandosEsperados: TIntegerDynArray;
  LCmdResp, LMotivoNaoChamou: Integer;
  LIdUnidade, LMsgStatusDefault: String;
begin
  TLibDataSnap.ValidateInputParams(aParams, [P_PA, P_FILA]);
  try
    LComandosEsperados := [CMD_RES_SENHA_CHAMOU,
                           CMD_RES_SENHA_NAO_CHAMOU,
                           0];

    LAddr := StrToInt(aParams.Values[P_PA].Value);
    LFila := StrToInt(aParams.Values[P_FILA].Value);
    if aParams.TryGetValue(P_IDUNIDADE, LIdUnidade) then
     IdUnidade := LIdUnidade;
    LData :=IntToHex(LFila, 4);
  except
    raise Exception.Create('Error parsing input params');
  end;

  if dmControleDeTokens.ChecarComandoDuplicado('post Senha/EncaminharComProximo', IdUnidade) then
    raise Exception.Create('Token duplicado');

  LMsgStatusDefault := Format('cliente na PA "%s" para a Fila "%s"',
                              [aParams.Values[P_PA].Value,
                               aParams.Values[P_FILA].Value]);

  LResp := EnviarComando(LAddr,
                         CMD_REDIRECIONA_E_PROXIMO,
                         LData,
                         LComandosEsperados);

  if LResp = EmptyStr then
  begin
    result := TJSONObject.Create;
    result.AddPair(CHAVE_SUCESSO, TJSONFalse.Create);
    result.AddPair(CHAVE_MOTIVO, IntToHex(MNC_FILA_PARA_CHAMADA, 4));
    TLibDataSnap.UpdateStatus('Tentou refazer a transferência do ' +
                              LMsgStatusDefault,
                              IdUnidade);
  end
  else
  begin
    LMotivoNaoChamou := -1;
    LMsgStatus := EmptyStr;

    if Length(LResp) > 0 then
      LCmdResp := Ord(LResp[1])
    else
      LCmdResp := -1;

    case LCmdResp of
      CMD_RES_SENHA_CHAMOU:
        {$REGION '//Chamou uma senha'}begin
          LMsgStatus := 'Encaminhou ' + LMsgStatusDefault + ' e chamou a' +
                        ' senha ' + Copy(LResp, 2);
        end{$ENDREGION};
      CMD_RES_SENHA_NAO_CHAMOU:
        {$REGION '//Nenhuma senha chamada'}begin
          if Length(LResp) > 1 then
            LMotivoNaoChamou := Ord(LResp[2])
          else
            LMotivoNaoChamou := $FFFF;

          LMsgStatus := Format('Falha ao encaminhar o ' + LMsgStatusDefault +
                               ', motivo: %s',
                               [IntToHex(LMotivoNaoChamou, 4)]);
        end;{$ENDREGION}
      else
      begin
        TLibDataSnap.UpdateStatus(Format('Retorno inesperado ao encaminhar a' +
                                         'senha "%s" para a fila "%s": %s',
                                         [aParams.Values[P_PA].Value,
                                          aParams.Values[P_FILA].Value,
                                          LResp]),
                                  IdUnidade);
        raise Exception.Create('Servidor retornou um conteúdo inesperado');
      end;
    end;

    TLibDataSnap.UpdateStatus(LMsgStatus, IdUnidade);
    result := TJSONObject.Create;
    if LMotivoNaoChamou < 0 then
      result.AddPair(CHAVE_SUCESSO, TJSONTrue.Create)
    else
    begin
      result.AddPair(CHAVE_SUCESSO, TJSONFalse.Create);
      result.AddPair(CHAVE_MOTIVO, IntToHex(LMotivoNaoChamou, 4));
    end;
  end;
end;

function TSenha.updateGerarSenha(const aParams: TJSONObject): TJSONObject;
const
  P_FILA     = 'Fila';
  P_TOTEM_ID = 'Totem';

  CHAVE_SUCESSO = 'sucesso';
  CHAVE_SENHA   = 'senha';
  CHAVE_EMISSAO = 'emissao';
var
  LAddr, LFila, LTotem, LSenha, LPosTab: Integer;
  LIdUnidade, LData, LResp, LDataHora : String;
  LComandosEsperados: TIntegerDynArray;
begin
  TLibDataSnap.ValidateInputParams(aParams, [P_FILA]);
  try
    LComandosEsperados := [CMD_GERAR_SENHA_RES];
    LAddr  := 0;
    LFila  := StrToInt(aParams.Values[P_FILA].Value);
    if(aParams.TryGetValue(P_TOTEM_ID,LTotem))then
      LTotem := StrToIntDef(aParams.Values[P_TOTEM_ID].Value,0)
    else
      LTotem := 0;

    if aParams.TryGetValue(P_IDUNIDADE, LIdUnidade) then
    begin
      LCrit.Enter;
      try
        IdUnidade := LIdUnidade;
      finally
        LCrit.Leave;
      end;
    end;

    LData := IntToHex(LFila, 4)+IntToHex(LTotem,4);
  except
    raise Exception.Create('Error parsing input params');
  end;

  if dmControleDeTokens.ChecarComandoDuplicado('post Senha/GerarSenha', IdUnidade) then
    raise Exception.Create('Token duplicado');

  LResp := EnviarComando(LAddr,
                         CMD_GERAR_SENHA,
                         LData,
                         LComandosEsperados);

  {$IFDEF DEBUG}OutputDebugString(PChar(LResp));{$ENDIF}

  if LResp <> EmptyStr then
  begin
    Delete(LResp, 1, 4); //apaga a fila, que vem nos primeiros 4 caracteres
    LPosTab := Pos(TAB, LResp);
    LSenha := StrToIntDef(Copy(LResp, 1, LPosTab-1), -1); //Senha do 5 em diante
    Delete(LResp, 1, LPosTab);
    LDataHora := LResp;
    TLibDataSnap.UpdateStatus(Format('Senha "%s" gerada para a Fila "%s"',
                                     [IntToStr(LSenha),
                                      aParams.Values[P_FILA].Value]),
                              IdUnidade);
    result := TJSONObject.Create;
    result.AddPair(CHAVE_SUCESSO, TJSONTrue.Create);
    result.AddPair(CHAVE_SENHA,   TJSONNumber.Create(LSenha));
    result.AddPair(CHAVE_EMISSAO, LDataHora);
  end
  else
  begin
    TLibDataSnap.UpdateStatus(Format('Falha ao gerar senha para a Fila "%s"',
                                     [aParams.Values[P_FILA].Value]),
                              IdUnidade);
    result := TJSONObject.Create;
    result.AddPair(CHAVE_SUCESSO, TJSONFalse.Create);
  end;
end;

function TSenha.updateNomearCliente(const aParams: TJSONObject): TJSONValue;
const
  P_PA = 'PA';
  P_SENHA = 'Senha';
  P_NOMECLIENTE = 'NomeCliente';
  P_PUSHDEVICEID = 'PushDeviceId';
var
  LAddr, LSenh: Integer;
  LIdUnidade, LData, LDataResp, LResp: String;
  LVal: TJSONValue;
begin
  TLibDataSnap.ValidateInputParams(aParams, [P_PA, P_SENHA, P_NOMECLIENTE]);
  try
    LAddr := 0; //StrToInt(aParams.Values[P_PA   ].Value);
    LSenh := StrToInt(aParams.Values[P_SENHA].Value);
    if aParams.TryGetValue(P_IDUNIDADE, LIdUnidade) then
      IdUnidade := LIdUnidade;
    LData := LSenh.ToString + TAB + aParams.Values[P_NOMECLIENTE].Value;
    //se foi enviado junto com o nome da senha o ID do Device para receber as
    //notificações push, injeta-o no DATA do protocolo
    LDataResp := LData;
    LVal := aParams.Values[P_PUSHDEVICEID];
    if Assigned(LVal) then
      LData := LData + '|<' + LVal.Value + '>|';
  except
    raise Exception.Create('Error parsing input params');
  end;

  if dmControleDeTokens.ChecarComandoDuplicado('post Senha/NomearCliente', IdUnidade) then
    raise Exception.Create('Token duplicado');

  LResp := EnviarComando(LAddr, CMD_NOMEAR_SENHA, LData, [CMD_NOMEAR_SENHA_RES]);

  if LResp = LDataResp then
  begin
    result := TJSONTrue.Create;
    TLibDataSnap.UpdateStatus(Format('Nomeou cliente na PA "%s", senha "%s", ' +
                                     'como "%s"',
                                     [aParams.Values[P_PA].Value,
                                      aParams.Values[P_SENHA].Value,
                                      aParams.Values[P_NOMECLIENTE].Value]),
                              IdUnidade);
  end
  else
  begin
    result := TJSONFalse.Create;
    TLibDataSnap.UpdateStatus(Format('Falha ao nomear cliente na PA "%s",' +
                                     ' senha "%s", como "%s"',
                                     [aParams.Values[P_PA].Value,
                                      aParams.Values[P_SENHA].Value,
                                      aParams.Values[P_NOMECLIENTE].Value]),
                              IdUnidade);
  end;
end;

function TSenha.updateReimprimirSenha(const aParams: TJSONObject): TJSONObject;
const
  P_SENHA = 'Senha';
  P_TOTEM = 'Totem';
  CHAVE_SUCESSO = 'sucesso';
var
  LSenha: Integer;
  LIdUnidade, LData, LDataResp, LResp: String;
begin
  TLibDataSnap.ValidateInputParams(aParams, [P_SENHA, P_TOTEM]);
  try
    LSenha := StrToInt(aParams.Values[P_SENHA].Value);

    if aParams.TryGetValue(P_IDUNIDADE, LIdUnidade) then
    begin
      LCrit.Enter;
      try
        IdUnidade := LIdUnidade;
      finally
        LCrit.Leave;
      end;
    end;

    LData := LSenha.ToString + ';' + IntToHex(aParams.Values[P_TOTEM].Value.ToInteger,4);

    LDataResp := LData;
  except
    raise Exception.Create('Error parsing input params');
  end;

  if dmControleDeTokens.ChecarComandoDuplicado('post Senha/ReimprimirSenha', IdUnidade) then
    raise Exception.Create('Token duplicado');

  LResp  := EnviarComando(0, CMD_REIMPRIMIR_SENHA, LDataResp, [ACK]);

  result := TJSONObject.Create;
  result.AddPair(CHAVE_SUCESSO, TJSONTrue.Create);

  TLibDataSnap.UpdateStatus('Senha.updateReimprimirSenha: ' + aParams.ToString, IdUnidade);
end;

initialization

  LCrit := TCriticalSection.Create;

finalization

  LCrit.Free;

end.
