unit uSMFila;

interface

uses System.SysUtils, System.Classes, System.JSON, Datasnap.DSServer,
  Datasnap.DSAuth, Datasnap.DSProviderDataModuleAdapter, Data.DBXPlatform,
  FireDAC.Stan.Option, FireDAC.Comp.Client, uDMSocket, uSMBase, Data.DB;

type
{$METHODINFO ON}
  TFila = class(TsmBase)
  private
  public
    function ListarPorPA(const aIdPA: Integer; const aIdUnidade: String)
      : TJSONObject;
    function ListarFilas(const aIdUnidade: String): TJSONArray;
    function ListarQuaisGeramSenhas(const aIdUnidade: String): TJSONObject;
    function updateInserirSenha(const pParams: TJSONObject): TJSONObject;
    function ObterQtdEspera(pIDFila, pIdUnidade: String): TJSONObject;
    function ListarSenhas(AIDFila, aIdUnidade: String): TJSONObject;
    function ObterTempoEspera(AIDFila, aIdUnidade: String): TJSONObject;
    function ListarPorModulo(AIDModulo, aIdUnidade: String): TJSONObject;
    function ListarTMETodas(aIdUnidade: String): TJSONObject;
    function ListarTEETodas(aIdUnidade: String): TJSONObject;
    function ListarGrupos(const aIdUnidade: String): TJSONObject;
    function ListarCategorias(const aIdUnidade: String): TJSONObject;

  end;

  // apenas para expor a URI sem o prefixo "T"
  Fila = class(TFila);

{$METHODINFO OFF}

implementation

{$R *.dfm}

uses
  uLibDatasnap,
  uConsts,
  MyDlls_DR,
  udmControleDeTokens,
  untDmTabelasScc,
  UConexaoBD;

{ TFila }

function TFila.ListarQuaisGeramSenhas(const aIdUnidade: String): TJSONObject;
var
  LItens: TJSONArray;
  LFila: TJSONObject;
  LResp: String;
  i, LQtdRecebida: Integer;
  LStrLst: TStringList;
  LItem, LId, LCor, LNome: String;
  IdCategoriaFila: String;
  IdGrupoFila: String;
begin
  IdUnidade := aIdUnidade;

  if dmControleDeTokens.ChecarComandoDuplicado
    ('get Fila/ListarQuaisGeramSenhas', IdUnidade) then
    raise Exception.Create('Token duplicado');

  LResp := EnviarComando(0, CMD_LISTAR_FILAS_GERAM_SENHAS, EmptyStr,
    [CMD_LISTAR_FILAS_GERAM_SENHAS_RES]);
  LItens := TJSONArray.Create;
  LQtdRecebida := StrToIntDef('$' + Copy(LResp, 1, 4), 0);
  Delete(LResp, 1, 4);

  LStrLst := TStringList.Create;
  try
    LStrLst.Delimiter := TAB;
    LStrLst.StrictDelimiter := True;
    LStrLst.DelimitedText := LResp;
    for i := 0 to LStrLst.Count - 1 do
    begin
      LItem := Trim(LStrLst[i]);
      if LItem = EmptyStr then
        continue;

      LId := Copy(LItem, 1, 4);
      LCor := Copy(LItem, 5, 6);
      LNome := Copy(LItem, 11);

      // [LBC] Esta parte de testar se o comprimento do LNome é maior do que 8, para somente então
      // preencher o IdCategoriaFila e o IdGrupoFila, e ainda assim testar se são numéricos (com StrToIntDef)
      // é porque foi desenvolvida na versão do SICS Servidor mais recente que o protocolo do socket
      // inclua o IdCategoriaFila e o IdGrupoFila, porém no mesmo cliente pode haver versões anteriores
      // do SICS Servidor onde não tem o IdCategoriaFila e o IdGrupoFila no protocolo do socket
      IdCategoriaFila := '';
      IdGrupoFila := '';

      if Length(LNome) > 8 then
      begin
        IdCategoriaFila := Copy(LNome, 1, 4);
        IdGrupoFila := Copy(LNome, 5, 4);

        if (StrToIntDef(IdCategoriaFila, -1) <> -1) and
          (StrToIntDef(IdGrupoFila, -1) <> -1) then
          LNome := Copy(LNome, 9);
      end;
      // [LBC] Até aqui.

      LFila := TJSONObject.Create;
      LFila.AddPair('ID', TJSONNumber.Create(StrToInt('$' + LId)));
      LFila.AddPair('Cor', LCor);
      LFila.AddPair('Nome', LNome);

      // [LBC] Idem comentário acima, pode ser que estas variáveis não estejam preenchidas se não vierem no
      // protocolo do socket de versões anteriores do SICS Servidor
      LFila.AddPair('IdCategoriaFila',
        TJSONNumber.Create(StrToIntDef('$' + IdCategoriaFila, -1)));
      LFila.AddPair('IdGrupoFila',
        TJSONNumber.Create(StrToIntDef('$' + IdGrupoFila, -1)));

      LItens.Add(LFila);
    end;
  finally
    LStrLst.Free;
  end;

  if LQtdRecebida <> LItens.Count then
    raise Exception.Create('Checksum error. Got ' + LQtdRecebida.ToString +
      ', sending ' + LItens.Count.ToString);

  result := TJSONObject.Create;
  result.AddPair('Quantidade', TJSONNumber.Create(LItens.Count));
  result.AddPair('Itens', LItens);

  TLibDataSnap.UpdateStatus('Recuperou Lista de Filas que Geram Senhas: ' +
    result.ToString, IdUnidade);
end;

function TFila.ListarFilas(const aIdUnidade: String): TJSONArray;
const
  LSQL = 'SELECT NOME, ID, ATIVO, IIF(RANGEMINIMO || RANGEMAXIMO IS NULL,''F'', ''T'') GERASENHA FROM FILAS ';

var
  LConexao: TFDConnection;
  LQuery: TFDQuery;
  LATIVO: String;
  LFilas: TJSONObject;
begin
  IdUnidade := aIdUnidade;

  if dmControleDeTokens.ChecarComandoDuplicado('get Fila/ListarFilas', IdUnidade)
  then
    raise Exception.Create('Token duplicado');

  try
    LConexao := TFDConnection.Create(Self);
    try
{$REGION 'Configurar objeto de conexão'}
      try
        LConexao.Close;
        LConexao.LoginPrompt := False;
        LConexao.ConnectionDefName := TConexaoBD.NomeBasePadrao
          (StrToInt(aIdUnidade));
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
        LATIVO := 'T';
        // LID_GRUPOATENDENTE := StrToIntDef(AIDGrupoAtendente,0);

        LQuery.Connection := LConexao;
        try
          LQuery.Close;
          LQuery.SQL.Text := Format(LSQL, [QuotedStr(LATIVO)]);
          LQuery.Open;

          if not LQuery.IsEmpty then
          begin
            LQuery.First;
            while not LQuery.Eof do
            begin
              LFilas := TJSONObject.Create;
              LFilas.AddPair('Nome', LQuery.FieldByName('NOME').AsString);
              LFilas.AddPair('ID', LQuery.FieldByName('ID').AsString);
              LFilas.AddPair('Ativo', LQuery.FieldByName('ATIVO').AsString);
              LFilas.AddPair('GeraSenha', LQuery.FieldByName('GERASENHA').AsString);
              result.Add(LFilas);

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
  except
    on E: Exception do
      raise Exception.Create('Error parsing input params');
  end;
end;

function TFila.ListarGrupos(const aIdUnidade: String): TJSONObject;
var
  LResp: String;
  LItem: string;
  LId: string;
  LNome: string;
  LGrupoFila: TJSONObject;
  LItensGrupoFila: TJSONArray;
  LStrLst: TStringList;
  i: Integer;
begin
  IdUnidade := aIdUnidade;

  // if dmControleDeTokens.ChecarComandoDuplicado('get Fila/ListarGrupoFilas', IdUnidade) then
  // raise Exception.Create('Token duplicado');

  LResp := EnviarComando(0, CMD_LISTAR_GRUPO_FILAS, EmptyStr,
    [CMD_LISTAR_GRUPO_FILAS_RES]);

  LItensGrupoFila := TJSONArray.Create;

  LStrLst := TStringList.Create;
  try
    LStrLst.Delimiter := TAB;
    LStrLst.StrictDelimiter := True;
    LStrLst.DelimitedText := LResp;
    for i := 0 to LStrLst.Count - 1 do
    begin
      LItem := Trim(LStrLst[i]);
      if LItem = EmptyStr then
        continue;

      LId := Copy(LItem, 1, 4);
      LNome := Copy(LItem, 5);

      LGrupoFila := TJSONObject.Create;
      LGrupoFila.AddPair('ID', TJSONNumber.Create(StrToInt('$' + LId)));
      LGrupoFila.AddPair('Nome', LNome);
      LItensGrupoFila.Add(LGrupoFila);
    end;
  finally
    LStrLst.Free;
  end;

  result := TJSONObject.Create;
  result.AddPair('Itens', LItensGrupoFila);

end;

function TFila.ListarCategorias(const aIdUnidade: String): TJSONObject;
var
  LResp: String;
  LItem: string;
  LId: string;
  LNome: string;
  LGrupoCategoria: TJSONObject;
  LItensGrupoCategoria: TJSONArray;
  LStrLst: TStringList;
  i: Integer;
begin
  IdUnidade := aIdUnidade;

  // if dmControleDeTokens.ChecarComandoDuplicado('get Fila/ListarGrupoCategoria', IdUnidade) then
  // raise Exception.Create('Token duplicado');

  LResp := EnviarComando(0, CMD_LISTAR_CATEGORIA_FILAS, EmptyStr,
    [CMD_LISTAR_CATEGORIA_FILAS_RES]);

  LItensGrupoCategoria := TJSONArray.Create;

  LStrLst := TStringList.Create;
  try
    LStrLst.Delimiter := TAB;
    LStrLst.StrictDelimiter := True;
    LStrLst.DelimitedText := LResp;
    for i := 0 to LStrLst.Count - 1 do
    begin
      LItem := Trim(LStrLst[i]);
      if LItem = EmptyStr then
        continue;

      LId := Copy(LItem, 1, 4);
      LNome := Copy(LItem, 5);

      LGrupoCategoria := TJSONObject.Create;
      LGrupoCategoria.AddPair('ID', TJSONNumber.Create(StrToInt('$' + LId)));
      LGrupoCategoria.AddPair('Nome', LNome);
      LItensGrupoCategoria.Add(LGrupoCategoria);
    end;
  finally
    LStrLst.Free;
  end;

  result := TJSONObject.Create;
  result.AddPair('Itens', LItensGrupoCategoria);

end;

function TFila.ObterQtdEspera(pIDFila, pIdUnidade: String): TJSONObject;
var
  i, LFila, lUnidade, lQtd: Integer;

  lAux, LResp: String;
begin
  lUnidade := StrToIntDef(pIdUnidade, 0);
  LFila := StrToIntDef(pIDFila, 0);
  IdUnidade := lUnidade.ToString;

  if dmControleDeTokens.ChecarComandoDuplicado('get Fila/ObterQtdEspera',
    IdUnidade) then
    raise Exception.Create('Token duplicado');

  lQtd := 0;

  if LFila <> 0 then
  begin
    LResp := EnviarComando(0, CMD_QTD_SENHA_EM_ESPERA, EmptyStr,
      [CMD_QTD_SENHA_EM_ESPERA_RES]);

    LResp := Copy(LResp, 5, Length(LResp) - 4);
    lAux := EmptyStr;

    for i := 1 to Length(LResp) do
    begin
      if LResp[i] = TAB then
      begin
        if LFila = StrToInt('$' + lAux[1] + lAux[2] + lAux[3] + lAux[4]) then
        begin
          lQtd := StrToInt('$' + lAux[5] + lAux[6] + lAux[7] + lAux[8]);
          Break;
        end;

        lAux := EmptyStr;
      end
      else
      begin
        lAux := lAux + LResp[i];
      end;
    end;
  end;

  result := TJSONObject.Create;
  result.AddPair('qtd', lQtd.ToString);

  TLibDataSnap.UpdateStatus('Fila.ObterQtdEspera. Fila: ' + pIDFila, IdUnidade);
end;

function TFila.ListarTEETodas(aIdUnidade: String): TJSONObject;
var
  lUnidade: Integer;
  lAux: String;
  LResposta: String;
  LTEES: TStringList;
  LTEE: String;
  LIDFila: String;
  LNomeFila: String;
  LCount: Integer;
  LJSONFila: TJSONObject;
  LJSONItens: TJSONArray;
begin
  result := nil;

  lUnidade := StrToIntDef(aIdUnidade, 0);
  IdUnidade := lUnidade.ToString;

  if dmControleDeTokens.ChecarComandoDuplicado('get Fila/ListarTEETodas',
    IdUnidade) then
    raise Exception.Create('Token duplicado');

  if lUnidade > 0 then
  begin
    LResposta := EnviarComando(0, CMD_OBTER_TEMPO_ESTIMADO_UNIDADE, lAux,
      [CMD_OBTER_TEMPO_ESTIMADO_UNIDADE_RES]);

    if LResposta <> EmptyStr then
    begin
      LTEES := TStringList.Create;
      try
        LTEES.Delimiter := TAB;
        LTEES.StrictDelimiter := True;
        LTEES.DelimitedText := LResposta;

        LJSONItens := TJSONArray.Create;

        for LCount := 0 to LTEES.Count - 1 do
        begin
          SeparaStrings(LTEES.Strings[LCount], '|', lAux, LTEE);

          if LTEE <> EmptyStr then
          begin
            LIDFila := Copy(lAux, 1, 4);
            LNomeFila := Copy(lAux, 5);

            LJSONFila := TJSONObject.Create;
            LJSONFila.AddPair('ID',
              TJSONNumber.Create(StrToInt('$' + LIDFila)));
            LJSONFila.AddPair('Nome', LNomeFila);
            LJSONFila.AddPair('TEE', LTEE);
            LJSONItens.Add(LJSONFila);
          end;
        end;

        result := TJSONObject.Create;
        result.AddPair('Filas', LJSONItens);
      finally
        FreeAndNil(LTEES);
      end;
    end;
  end;
  TLibDataSnap.UpdateStatus('Fila.ListarTEETodas', IdUnidade);
end;

function TFila.ListarTMETodas(aIdUnidade: String): TJSONObject;
var
  lUnidade: Integer;
  lAux: String;
  LResposta: String;
  LTMES: TStringList;
  LTME: String;
  LIDFila: String;
  LNomeFila: String;
  LCount: Integer;
  LJSONFila: TJSONObject;
  LJSONItens: TJSONArray;
begin
  result := nil;

  lUnidade := StrToIntDef(aIdUnidade, 0);
  IdUnidade := lUnidade.ToString;

  if dmControleDeTokens.ChecarComandoDuplicado('get Fila/ListarTMETodas',
    IdUnidade) then
    raise Exception.Create('Token duplicado');

  if lUnidade > 0 then
  begin
    LResposta := EnviarComando(0, CMD_OBTER_TEMPO_ESPERA_UNIDADE, lAux,
      [CMD_OBTER_TEMPO_ESPERA_UNIDADE_RES]);

    if LResposta <> EmptyStr then
    begin
      LTMES := TStringList.Create;
      try
        LTMES.Delimiter := TAB;
        LTMES.StrictDelimiter := True;
        LTMES.DelimitedText := LResposta;

        LJSONItens := TJSONArray.Create;

        for LCount := 0 to LTMES.Count - 1 do
        begin
          SeparaStrings(LTMES.Strings[LCount], '|', lAux, LTME);

          if LTME <> EmptyStr then
          begin
            LIDFila := Copy(lAux, 1, 4);
            LNomeFila := Copy(lAux, 5);

            LJSONFila := TJSONObject.Create;
            LJSONFila.AddPair('ID',
              TJSONNumber.Create(StrToInt('$' + LIDFila)));
            LJSONFila.AddPair('Nome', LNomeFila);
            LJSONFila.AddPair('TME', LTME);
            LJSONItens.Add(LJSONFila);
          end;
        end;

        result := TJSONObject.Create;
        result.AddPair('Filas', LJSONItens);
      finally
        FreeAndNil(LTMES);
      end;
    end;
  end;

  TLibDataSnap.UpdateStatus('Fila.ListarTMETodas. ' + result.ToString,
    IdUnidade);
end;

function TFila.ObterTempoEspera(AIDFila, aIdUnidade: String): TJSONObject;
const
  cObservacao =
    'O TEE (Tempo Estimado de Espera) real pode sofrer alterações em relação ao calculado neste momento, devido a motivos diversos inerentes ao próprio atendimento.';
var
  LId: String;
  LFila: Integer;
  lUnidade: Integer;
  lAux: String;
  LResposta: String;
  LTEE: String;
  LTME: String;
  LQTDEPAProdutiva: String;
  LQTDEPessoasEspera: String;
begin
  result := nil;

  lUnidade := StrToIntDef(aIdUnidade, 0);
  LFila := StrToIntDef(AIDFila, 0);
  lAux := IntToHex(LFila, 4);
  IdUnidade := lUnidade.ToString;

  if dmControleDeTokens.ChecarComandoDuplicado('get Fila/ObterTempoEspera',
    IdUnidade) then
    raise Exception.Create('Token duplicado');

  if LFila <> 0 then
  begin
    LResposta := EnviarComando(0, CMD_OBTER_TEMPO_ESPERA, lAux,
      [CMD_OBTER_TEMPO_ESPERA_RES]);

    if LResposta <> EmptyStr then
    begin
      SeparaStrings(LResposta, ';', LTEE, LResposta);
      SeparaStrings(LResposta, ';', LTME, LResposta);
      SeparaStrings(LResposta, ';', LQTDEPAProdutiva, LResposta);
      SeparaStrings(LResposta, ';', LQTDEPessoasEspera, LResposta);
      SeparaStrings(LResposta, ';', LId, LResposta);

      result := TJSONObject.Create;
      result.AddPair('ID', TJSONNumber.Create(StrToIntDef(LId, 0)));
      result.AddPair('TME', LTME);
      result.AddPair('TEE', LTEE);
      result.AddPair('QTDEPAProdutiva',
        TJSONNumber.Create(StrToIntDef(LQTDEPAProdutiva, 0)));
      result.AddPair('QTDEPessoasEspera',
        TJSONNumber.Create(StrToIntDef(LQTDEPessoasEspera, 0)));
      result.AddPair('Obs', cObservacao);
    end;
  end;

  TLibDataSnap.UpdateStatus
    (Format('Fila.ObterTempoEspera - Id %s, IDFila %d, TME %s, TEE %s',
    [LId, LFila, LTME, LTEE]), IdUnidade);
end;

function TFila.ListarSenhas(AIDFila, aIdUnidade: String): TJSONObject;
var
  i, LFila, lUnidade, d1, m1, y1, h1, n1, s1: Integer;

  lJSONSenha: TJSONObject;
  LJSONItens: TJSONArray;

  lAux, lAux2, LResp, LNome, lSenha, lTagsStr, lHoraStr: String;

  TIM: TDateTime;
begin
  lUnidade := StrToIntDef(aIdUnidade, 0);
  LFila := StrToIntDef(AIDFila, 0);
  IdUnidade := lUnidade.ToString;

  if dmControleDeTokens.ChecarComandoDuplicado('get Fila/ListarSenhas',
    IdUnidade) then
    raise Exception.Create('Token duplicado');

  lAux := IntToHex(LFila, 4);

  LJSONItens := TJSONArray.Create;

  if LFila <> 0 then
  begin
    LResp := EnviarComando(0, CMD_SITUACAO_FILA, lAux, [CMD_SITUACAO_FILA_RES]);

    LResp := Copy(LResp, 5, Length(LResp) - 4);
    lAux2 := EmptyStr;
    d1 := 0;
    m1 := 0;
    y1 := 0;
    h1 := 0;
    n1 := 0;
    s1 := 0;

    for i := 1 to Length(LResp) do
    begin
      if LResp[i] = ';' then
      begin
        SeparaStrings(lAux2, TAB, lSenha, lAux2);
        SeparaStrings(lAux2, TAB, LNome, lAux2);
        SeparaStrings(lAux2, TAB, lTagsStr, lAux2);

        if Pos(',', lSenha) > 0 then
        begin
          lSenha := Copy(lSenha, 1, Pos(',', lSenha) - 1);
        end;

        lHoraStr := lAux2;

        if Length(lHoraStr) >= 2 then
        begin
          s1 := StrToInt(lHoraStr[1] + lHoraStr[2]);
        end;

        if Length(lHoraStr) >= 4 then
        begin
          n1 := StrToInt(lHoraStr[3] + lHoraStr[4]);
        end;

        if Length(lHoraStr) >= 6 then
        begin
          h1 := StrToInt(lHoraStr[5] + lHoraStr[6]);
        end;

        if Length(lHoraStr) >= 8 then
        begin
          d1 := StrToInt(lHoraStr[7] + lHoraStr[8]);
        end;

        if Length(lHoraStr) >= 10 then
        begin
          m1 := StrToInt(lHoraStr[9] + lHoraStr[10]);
        end;

        if Length(lHoraStr) >= 14 then
        begin
          y1 := StrToInt(lHoraStr[11] + lHoraStr[12] + lHoraStr[13] +
            lHoraStr[14]);
        end;

        TIM := EncodeDate(y1, m1, d1) + EncodeTime(h1, n1, s1, 0);

        lAux2 := '';

        lJSONSenha := TJSONObject.Create;
        lJSONSenha.AddPair('senha', lSenha);
        lJSONSenha.AddPair('nome', LNome);
        lJSONSenha.AddPair('tags', lTagsStr);
        lJSONSenha.AddPair('datahora',
          FormatDateTime('DD/MM/YYYY HH:NN:SS', TIM));

        LJSONItens.Add(lJSONSenha);
      end
      else if LResp[i] <> ETX then
      begin
        lAux2 := lAux2 + LResp[i];
      end;
    end;
  end;

  result := TJSONObject.Create;
  result.AddPair('Fila', AIDFila);
  result.AddPair('Senhas', LJSONItens);

  TLibDataSnap.UpdateStatus('Fila.ListarSenhas. ' + result.ToString, IdUnidade);
end;

{$J+}
// diretiva para habilitar alteração de const (necessária para possibilitar "unidade" ou "idunidade" neste endpoint)
function TFila.updateInserirSenha(const pParams: TJSONObject): TJSONObject;
const
  P_FILA = 'fila';
  P_SENHA = 'senha';
  P_UNIDADE: string = 'idunidade';

var
  LFila, lSenha, lUnidade: Integer;

  lAux, lSucesso: String;
begin
  // loop inicial trocando eventual parâmetro "unidade" pelo correto "idunidade" apenas para manter
  // compatibilidade com clientes que já utilizam com parâmetro "unidade"
  P_UNIDADE := 'idunidade';
  if pParams.Values['unidade'] <> nil then
    P_UNIDADE := 'unidade';

  TLibDataSnap.ValidateInputParams(pParams, [P_FILA, P_SENHA]);

  try
    pParams.TryGetValue(P_FILA, LFila);
    pParams.TryGetValue(P_SENHA, lSenha);

    if pParams.TryGetValue(P_UNIDADE, lUnidade) then
    begin
      IdUnidade := lUnidade.ToString;
    end;

    if dmControleDeTokens.ChecarComandoDuplicado('post Fila/InserirSenha',
      IdUnidade) then
      raise Exception.Create('Token duplicado');

    if (LFila <> 0) and (lSenha <> 0) then
    begin
      // Inserir senha na fila lFila
      lAux := IntToHex(LFila, 4) + lSenha.ToString;

      // Comando de encaminhamento de senha insere senha na última posição da fila
      EnviarComando(0, CMD_ENCAMINHAR_SENHA_PARA_FILA, lAux,
        [CMD_ENCAMINHAR_SENHA_PARA_FILA_RES]);

      TLibDataSnap.UpdateStatus(Format('Inserindo a senha %d na fila %d.',
        [lSenha, LFila]), IdUnidade);

      lSucesso := 'true';
    end
    else
    begin

      TLibDataSnap.UpdateStatus
        (Format('Valor inválido ao inserir a senha %d na fila %d.',
        [lSenha, LFila]), IdUnidade);

      lSucesso := 'false';
    end;

    result := TJSONObject.Create;
    result.AddPair('sucesso', lSucesso);
  except
    raise Exception.Create('Error parsing input params');
  end;

end;

function TFila.ListarPorModulo(AIDModulo, aIdUnidade: String): TJSONObject;
var
  LFilas: TStringList;
  LResposta: String;
  LCount: Integer;
  LJSONFila: TJSONObject;
  LJSONItens: TJSONArray;
  LIDFila: String;
  LNomeFila: String;
  LCorFila: String;
  lQtd: String;
begin
  if AIDModulo = EmptyStr then
    TLibDataSnap.AbortWithInvalidRequest('Módulo não informado');

  IdUnidade := aIdUnidade;

  if dmControleDeTokens.ChecarComandoDuplicado('get Fila/ListarPorModulo',
    IdUnidade) then
    raise Exception.Create('Token duplicado');

  LFilas := TStringList.Create;
  LFilas.Delimiter := TAB;
  LFilas.StrictDelimiter := True;
  try
    LResposta := EnviarComando(StrToIntDef(AIDModulo, 0),
      CMD_LISTAR_FILAS_MODULO, EmptyStr, [CMD_LISTAR_FILAS_MODULO_RES]);
    LResposta := Copy(LResposta, 5, Length(LResposta) - 4);
    LFilas.DelimitedText := LResposta;

    LJSONItens := TJSONArray.Create;

    for LCount := 0 to (LFilas.Count - 1) do
    begin
      LIDFila := Copy(LFilas.Strings[LCount], 1, 4);
      LCorFila := Copy(LFilas.Strings[LCount], 5, 6);
      lQtd := Copy(LFilas.Strings[LCount], 11, 4);
      LNomeFila := Copy(LFilas.Strings[LCount], 15);

      if LIDFila <> EmptyStr then
      begin
        LJSONFila := TJSONObject.Create;
        LJSONFila.AddPair('ID', TJSONNumber.Create(StrToInt('$' + LIDFila)));
        LJSONFila.AddPair('Cor', LCorFila);
        LJSONFila.AddPair('Nome', LNomeFila);
        LJSONFila.AddPair('QTD', TJSONNumber.Create(StrToInt('$' + lQtd)));
        LJSONItens.Add(LJSONFila);
      end;
    end;

    result := TJSONObject.Create;
    result.AddPair('Filas', LJSONItens);
  finally
    FreeAndNil(LFilas);
  end;

  TLibDataSnap.UpdateStatus('Fila.ListarPorModulo. Modulo: ' + AIDModulo + ' - '
    + result.ToString, IdUnidade);
end;

function TFila.ListarPorPA(const aIdPA: Integer; const aIdUnidade: String)
  : TJSONObject;
var
  LItens: TJSONArray;
  LFila: TJSONObject;
  LResp: String;
  i, LQtdRecebida: Integer;
  LStrLst: TStringList;
  LItem, LId, { LCor, } LNome: String;
begin
  if aIdPA <= 0 then
    TLibDataSnap.AbortWithInvalidRequest('PA não informado');

  IdUnidade := aIdUnidade;

  if dmControleDeTokens.ChecarComandoDuplicado('get Fila/ListarPorPA', IdUnidade)
  then
    raise Exception.Create('Token duplicado');

  LResp := EnviarComando(aIdPA, CMD_LISTAR_FILAS_PA, EmptyStr,
    [CMD_LISTAR_FILAS_PA_RES]);
  LItens := TJSONArray.Create;
  LQtdRecebida := StrToIntDef('$' + Copy(LResp, 1, 4), 0);
  Delete(LResp, 1, 4);

  LStrLst := TStringList.Create;
  try
    LStrLst.Delimiter := TAB;
    LStrLst.StrictDelimiter := True;
    LStrLst.DelimitedText := LResp;
    for i := 0 to LStrLst.Count - 1 do
    begin
      LItem := Trim(LStrLst[i]);
      if LItem = EmptyStr then
        continue;

      LId := Copy(LItem, 1, 4);
      // LCor  := Copy(LItem, 5, 6);
      LNome := Copy(LItem, 48);
      LNome := Copy(LNome, 1, Pos(';', LNome) - 1);

      LFila := TJSONObject.Create;
      LFila.AddPair('ID', TJSONNumber.Create(StrToInt('$' + LId)));
      // LFila.AddPair('Cor', TJSONNumber.Create(StrToInt('$' + LCor)));
      LFila.AddPair('Nome', LNome);
      LItens.Add(LFila);
    end;
  finally
    LStrLst.Free;
  end;

  if LQtdRecebida <> LItens.Count then
    raise Exception.Create('Checksum error. Got ' + LQtdRecebida.ToString +
      ', sending ' + LItens.Count.ToString);

  result := TJSONObject.Create;
  result.AddPair('Quantidade', TJSONNumber.Create(LItens.Count));
  result.AddPair('Itens', LItens);

  TLibDataSnap.UpdateStatus(Format('Recuperou Lista de Filas para o PA "%d"',
    [aIdPA]), IdUnidade);
end;

end.
