unit uSMPA;

interface

uses System.SysUtils, System.Classes, System.JSON, Datasnap.DSServer,
  Datasnap.DSAuth, DataSnap.DSProviderDataModuleAdapter, Data.DBXPlatform,
  uDMSocket, uSMBase, System.Types, UConexaoBD;

type
{$METHODINFO ON}
  TPA = class(TsmBase)
  private
    function GetGrupos: TJSONObject;
    function GetPAs(const AIdUnidade: String): TJSONObject;
    function GetGruposTags (PA : integer) : TJSONObject;
    function GetTags (PA : integer) : TJSONObject;
  public
    function SenhasEmEspera(const aIdUnidade: integer; const PA: integer): TJSONArray;overload;
    function Listar(const aIdUnidade: String): TJSONObject;
    function PrioridadeAtendimento(const PA: Integer; const aIdUnidade: String): TJSONArray;
    function ListarTAGsPossiveis(const PA: Integer; const aIdUnidade: String): TJSONObject;
  end;

  //apenas para expor a URI sem o prefixo "T"
  PA = class(TPA);
{$METHODINFO OFF}

implementation

{$R *.dfm}

uses
  uLibDatasnap, uConsts, uTypes, udmControleDeTokens, FireDAC.Comp.Client, Data.DB,
  System.MAth;

{ TPA }

function TPA.GetGrupos: TJSONObject;
var
  LItens: TJSONArray;
  LObj: TJSONObject;
  LResp: String;
  i: Integer;
  LStrLst: TStringList;
  LItem, LId, LNome: String;
begin
  result := TJSONObject.Create;
  LResp := EnviarComando(0, CMD_LISTAR_GRUPOSPAS, 'P0000', [CMD_LISTAR_GRUPOSPAS_RES]);
  Delete(LResp, 1, 5); //descarta os primeiros 5 digitos, que seria o TIPO do grupo (1) + o ID do PA (4)
  LItens := TJSONArray.Create;

  LStrLst := TStringList.Create;
  try
    LStrLst.Delimiter := TAB;
    LStrLst.StrictDelimiter := True;
    LStrLst.DelimitedText := LResp;
    for i := 0 to LStrLst.Count-1 do
    begin
      LItem := Trim(LStrLst[i]);
      if LItem = EmptyStr then
        continue;

      LId      := Copy(LItem, 1, 4);
      LNome    := Copy(LItem, 5);

      LObj := TJSONObject.Create;
      LObj.AddPair('ID', TJSONNumber.Create(StrToInt('$' + LId)));
      LObj.AddPair('Nome', LNome);
      LItens.Add(LObj);
    end;
  finally
    LStrLst.Free;
  end;

  result.AddPair('Quantidade', TJSONNumber.Create(LItens.Count));
  result.AddPair('Itens', LItens);
end;

function TPA.GetPAs(const AIdUnidade: String): TJSONObject;
const
  LSQL = 'SELECT NOME, ID_ATD_CLI FROM ATENDENTES WHERE ID = %s'; // AND ID_UNIDADE = (SELECT ID FROM UNIDADES WHERE ID_UNID_CLI= %s )

var
  LConexao:         TFDConnection;
  LQuery:           TFDQuery;

  LItens: TJSONArray;
  LObj: TJSONObject;

  LResp,
  lRespStatus: String;

  i,
  j,
  LQtdRecebida,
  lStatusPA: Integer;

  LStrLst: TStringList;

  LItem,
  LId,
  LNome,
  LGrupoId,
  lAux,
  lStatus,
  LIDAtendente,
  LHorario,
  LSenha,
  LIDMotivoPausa,
  LNomePaciente,
  LFila,
  LNomeAtendente: String;
begin
  result := TJSONObject.Create;
  LResp := EnviarComando(0, CMD_LISTAR_PAS, EmptyStr, [CMD_LISTAR_PAS_RES]);
  Delete(LResp, 1, 4); //descarta os primeiros 4 digitos, que seria o ID do PA

  lRespStatus := EnviarComando(0, CMD_STATUS_PAS, EmptyStr, [CMD_STATUS_PAS_RES]);
  Delete(lRespStatus, 1, 4);

  LItens := TJSONArray.Create;
  LQtdRecebida := StrToIntDef('$' + Copy(LResp, 1, 4), 0);
  Delete(LResp, 1, 4);
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
        LNomeAtendente := EmptyStr;
        raise Exception.Create('Erro ao configurar objeto de conexão');
      end;
    end;
    {$ENDREGION}

    LStrLst := TStringList.Create;
    try
      LStrLst.Delimiter := TAB;
      LStrLst.StrictDelimiter := True;
      LStrLst.DelimitedText := LResp;
      for i := 0 to LStrLst.Count-1 do
      begin
        LItem := Trim(LStrLst[i]);
        if LItem = EmptyStr then
          continue;

        LId      := Copy(LItem, 1, 4);
        LNome    := Copy(LItem, 5, Pos(';', LItem)-1-4);
        LGrupoId := Copy(LItem, Pos(';', LItem)+1);

        {$REGION 'Status da PA'}
        lAux    := EmptyStr;
        lStatus := EmptyStr;

        for j := 1 to Length(lRespStatus) do
        begin
          if lRespStatus[j] = TAB then
          begin
            if StrToInt('$'+LId) = StrToInt('$'+Copy(lAux,1,4)) then
            begin
              if Copy(lAux,19,4) = '----' then
              begin
                lStatusPA := -1;
              end
              else
              begin
                lStatusPA := StrToInt('$'+Copy(lAux,19,4));
              end;

              case TStatusPA(lStatusPA) of
                spDeslogado    : lStatus := 'Deslogado';
                spEmAtendimento: lStatus := 'Em Atendimento';
                spEmPausa      : lStatus := 'Em Pausa';
                spDisponivel   : lStatus := 'Disponível';
              else lStatus := lStatusPA.ToString;
              end;

              if Copy(lAux, 23, 4) = '----' then
                LIDAtendente := '-1'
              else
                LIDAtendente := StrToInt('$' + Copy(lAux, 23, 4)).ToString;
              LHorario := formatDateTime('DD/MM/YYYY HH:NN:SS', EncodeDate(StrToInt(lAux[9] + lAux[10] + lAux[11] + lAux[12]), StrToInt(lAux[7] + lAux[8]), StrToInt(lAux[5] + lAux[6])) + EncodeTime(StrToInt(lAux[13] + lAux[14]), StrToInt(lAux[15] + lAux[16]), StrToInt(lAux[17] + lAux[18]), 0));
              if Copy(lAux, 31, 4) = '----' then
                LIDMotivoPausa := '-1'
              else
                LIDMotivoPausa := StrToInt('$' + Copy(lAux, 31, 4)).ToString;

              LSenha := Copy(lAux, 35, Pos(';', lAux) - 35);
              LNomePaciente := Copy(lAux, Pos(';', lAux) + 1, Length(lAux) - Pos(';', lAux));
              if Copy(lAux, 27, 4) = '----' then
                LFila := '-1'
              else
                LFila := StrToInt('$' + Copy(lAux, 27, 4)).ToString;

              if LIDAtendente <> '-1' then
              begin
                  {$REGION 'Get dados Atendente'}
                  LQuery := TFDQuery.Create(nil);
                  try
                    LQuery.Connection := LConexao;
                    try
                      LQuery.Close;

                      if TConexaoBD.TabelaExiste('UNIDADES', LConexao) then
                        LQuery.SQL.Text := Format(LSQL + ' AND ID_UNIDADE = (SELECT ID FROM UNIDADES WHERE ID_UNID_CLI= %s )', [LIDAtendente, AIdUnidade])
                      else
                        LQuery.SQL.Text := Format(LSQL, [LIDAtendente]);

                      LQuery.Open;

                      if not LQuery.IsEmpty then
                      begin
                        LNomeAtendente := LQuery.FieldByName('Nome').AsString;
                      end
                      else
                      begin
                        LNomeAtendente := EmptyStr;
                      end;
                    except
                      on E: Exception do
                      begin
                        LNomeAtendente := EmptyStr;
                        raise Exception.Create('Erro ao executar comando SQL');
                      end;
                    end;
                  finally
                    FreeAndNil(LQuery);
                  end;
                  {$ENDREGION}
              end
              else
              begin
                LNomeAtendente := EmptyStr;
              end;
              Break;
            end;

            lAux := EmptyStr;
          end
          else
          begin
            lAux := lAux + lRespStatus[j];
          end;
        end;
        {$ENDREGION}

        LObj := TJSONObject.Create;
        LObj.AddPair('ID', TJSONNumber.Create(StrToInt('$' + LId)));
        LObj.AddPair('Nome', LNome);
        LObj.AddPair('GrupoId', TJSONNumber.Create(StrToIntDef(LGrupoId,0)));
        //RA - Alterar para o status da PA no momento
        LObj.AddPair('Status', lStatus);

        LObj.AddPair('IdAtendente', LIDAtendente);
        LObj.AddPair('Horario', LHorario);
        LObj.AddPair('IdMotivoPausa', LIDMotivoPausa);
        LObj.AddPair('Senha', LSenha);
        LObj.AddPair('NomePaciente', LNomePaciente);
        LObj.AddPair('NomeAtendente', LNomeAtendente);
        //  RV - comentado pois não foi solicitado
        //      LObj.AddPair('Fila', LFila);
        LItens.Add(LObj);
      end;
    finally
      LStrLst.Free;
    end;

  finally
    FreeAndNil(LConexao);
  end;

  if LQtdRecebida <> LItens.Count then
    raise Exception.Create('PAs Checksum error. Got ' + LQtdRecebida.ToString +
                           ', sending ' + LItens.Count.ToString);

  result.AddPair('Quantidade', TJSONNumber.Create(LItens.Count));
  result.AddPair('Itens', LItens);
end;

function TPA.GetGruposTags (PA : integer): TJSONObject;
var
  LItens: TJSONArray;
  LObj: TJSONObject;
  LResp: String;
  i: Integer;
  LStrLst: TStringList;
  LItem, LId, LNome: String;
begin
  result := TJSONObject.Create;
  LResp := EnviarComando(PA, CMD_LISTAR_GRUPOSTAGS, 'T', [CMD_LISTAR_GRUPOSTAGS_RES]);
  Delete(LResp, 1, 5); //descarta os primeiros 5 digitos, que seria o TIPO do grupo (1) + a quantidade de grupos (4)
  LItens := TJSONArray.Create;

  LStrLst := TStringList.Create;
  try
    LStrLst.Delimiter := TAB;
    LStrLst.StrictDelimiter := True;
    LStrLst.DelimitedText := LResp;
    for i := 0 to LStrLst.Count-1 do
    begin
      LItem := Trim(LStrLst[i]);
      if LItem = EmptyStr then
        continue;

      LId      := Copy(LItem, 1, 4);
      LNome    := Copy(LItem, 5);

      LObj := TJSONObject.Create;
      LObj.AddPair('ID', TJSONNumber.Create(StrToInt('$' + LId)));
      LObj.AddPair('Nome', LNome);
      LItens.Add(LObj);
    end;
  finally
    LStrLst.Free;
  end;

  result.AddPair('Quantidade', TJSONNumber.Create(LItens.Count));
  result.AddPair('Itens', LItens);
end;

function TPA.GetTags (PA : integer) : TJSONObject;
var
  LItens: TJSONArray;
  LObj: TJSONObject;

  LResp : String;

  i,
  LQtdRecebida : Integer;

  LStrLst: TStringList;

  LItem,
  LId,
  LCor,
  LNome,
  LGrupoId : String;
begin
  result := TJSONObject.Create;
  LResp := EnviarComando(PA, CMD_LISTAR_TAGS, EmptyStr, [CMD_LISTAR_TAGS_RES]);
  Delete(LResp, 1, 4); //descarta os primeiros 4 digitos, que seria o ID da PA

  LItens := TJSONArray.Create;
  LQtdRecebida := StrToIntDef('$' + Copy(LResp, 1, 4), 0);
  Delete(LResp, 1, 4);

  LStrLst := TStringList.Create;
  try
    LStrLst.Delimiter := TAB;
    LStrLst.StrictDelimiter := True;
    LStrLst.DelimitedText := LResp;
    for i := 0 to LStrLst.Count-1 do
    begin
      LItem := Trim(LStrLst[i]);
      if LItem = EmptyStr then
        continue;

      LId      := Copy(LItem, 1, 4);
      LCor     := Copy(LItem, 5, 6);
      LGrupoId := Copy(LItem, 11, Pos(';', LItem)-1-10);
      LNome    := Copy(LItem, Pos(';', LItem)+1);

      LObj := TJSONObject.Create;
      LObj.AddPair('ID', TJSONNumber.Create(StrToInt('$' + LId)));
      LObj.AddPair('Nome', LNome);
      LObj.AddPair('GrupoId', TJSONNumber.Create(StrToInt(LGrupoId)));
      LObj.AddPair('Cor', LCor);
      LItens.Add(LObj);
    end;
  finally
    LStrLst.Free;
  end;

  if LQtdRecebida <> LItens.Count then
    raise Exception.Create('TAGs Checksum error. Got ' + LQtdRecebida.ToString + ', sending ' + LItens.Count.ToString);

  result.AddPair('Quantidade', TJSONNumber.Create(LItens.Count));
  result.AddPair('Itens', LItens);
end;


function TPA.Listar(const aIdUnidade: String): TJSONObject;
var
  LGrupos, LPAs: TJSONObject;
begin
  IdUnidade := aIdUnidade;

  if dmControleDeTokens.ChecarComandoDuplicado('get PA/Listar', IdUnidade) then
    raise Exception.Create('Token duplicado');

  LGrupos := GetGrupos;
  LPAs    := GetPAs(aIdUnidade);

  result  := TJSONObject.Create;
  result.AddPair('Grupos', LGrupos);
  result.AddPair('PAs', LPAs);

  TLibDataSnap.UpdateStatus('Recuperou Lista de PAs '  + Result.ToString, IdUnidade);
end;

function TPA.ListarTAGsPossiveis (const PA: Integer; const aIdUnidade: String): TJSONObject;
var
  LGrupos, LTAGs : TJSONObject;
begin
  IdUnidade := aIdUnidade;

  if dmControleDeTokens.ChecarComandoDuplicado('get PA/ListarTAGsPossiveis', IdUnidade) then
    raise Exception.Create('Token duplicado');

  LGrupos := GetGruposTags(PA);
  LTAGs   := GetTags(PA);

  result  := TJSONObject.Create;
  result.AddPair('GruposDeTags', LGrupos);
  result.AddPair('TAGs', LTAGs);

  TLibDataSnap.UpdateStatus('Recuperou Lista de TAGs ' + Result.ToString, IdUnidade);
end;

function TPA.PrioridadeAtendimento(const PA: Integer; const aIdUnidade: String): TJSONArray;
var
  i,LIdPA,j : Integer;
  LData, LResp, LItem,LFilas: String;
  LComandosEsperados: TIntegerDynArray;
  LStrLst,LStrLstFilas: TStringList;
  LArray,LFilasArray: TJSONArray;
  LItems: TJSONObject;
begin
  IdUnidade := aIdUnidade;

  if PA < 0 then
    TLibDataSnap.AbortWithInvalidRequest('PA inválida');

  if dmControleDeTokens.ChecarComandoDuplicado('get PA/PrioridadeAtendimento', IdUnidade) then
    raise Exception.Create('Token duplicado');

  LComandosEsperados := [CMD_SOLIC_PRIORID_ATENDEND_RES];
  LData := IntToHex(PA, 4);
  LResp := EnviarComando(PA,
                         CMD_SOLIC_PRIORID_ATENDEND,
                         LData,
                         LComandosEsperados);

  LArray := TJSONArray.Create;

  LStrLst := TStringList.Create;
  try
    LStrLst.Delimiter := TAB;
    LStrLst.StrictDelimiter := True;
    LStrLst.DelimitedText := LResp;

    for i := 0 to LStrLst.Count -1 do
    begin
      LItems := TJSONObject.Create;

      LItem := Trim(LStrLst[i]);
      if LItem = EmptyStr then
        continue;

      LIdPA := StrToIntDef('$' + Copy(LItem,1,4), -1);
      LFilas:= Copy(LItem,5);

      LStrLstFilas := TStringList.Create;
      LFilasArray := TJSONArray.Create;
      try
        LStrLstFilas.Delimiter :=  ';';
        LStrLstFilas.StrictDelimiter := True;
        LStrLstFilas.DelimitedText := LFilas;
        for j := 0 to LStrLstFilas.Count -1 do
        begin
         LFilasArray.Add(StrToIntDef('$' + LStrLstFilas[j], -1));
        end;

        LItems.AddPair('PA',TJSONNumber.Create(LIdPA));
        LItems.AddPair('Filas',LFilasArray);
        LArray.Add(LItems);
      finally
        LStrLstFilas.Free;
      end;
    end;
  finally
    LStrLst.Free;
  end;

  result  := LArray;
  if(PA = 0)then
    TLibDataSnap.UpdateStatus('Recuperou Lista de Prioridades de Atendimento para todas as PAs ' + Result.ToString, IdUnidade)
  else
    TLibDataSnap.UpdateStatus(Format('Recuperou Lista de Prioridades de Atendimento para o PA "%d"',
                                      [PA]),
                              IdUnidade);
end;


function TPA.SenhasEmEspera(const aIdUnidade: integer; const PA: integer): TJSONArray;

const
  P_IDUNIDADE          = 'AIdUnidade';
  P_TRACKINGID         = 'ATrackingID';

var
  LConexao                : TFDConnection;
  LSQL_Select             : String;
  LJSON                   : TJSONObject;
  LQuery                  : TFDQuery;
  ATrackingID             : String;

  lIDUnidade: integer;
begin

   {RP 04/08 *** Atenção *** Se usuario passar apenas o parametro aIdUnidade na API
    ela será tratada como Unidade... OK

    Caso ele passe, aIdUnidade e o parametro PA...  na codificação
    os parametros serao invertido onde PA será aIdUnidade e vice versa
    }

  lIDUnidade :=  ifthen(PA=0,AIdUnidade,PA);
  try
    if dmControleDeTokens.ChecarComandoDuplicado('get PA/SenhasEmEspera', ATrackingID) then
      raise Exception.Create('Token duplicado');   //sLineBreak

    LConexao := TFDConnection.Create(Self);
    try
       {$REGION 'Configurar objeto de conexão'}
      try
        LConexao.Close;
        LConexao.LoginPrompt := False;
        LConexao.ConnectionDefName := TConexaoBD.NomeBasePadrao(lIDUnidade);
        LConexao.Tag := lIDUnidade;
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
        LSQL_Select :=
                 '       SELECT nexiste.id pa,                                      '+
                 '     COALESCE(existe.qtd,0) qtd                                   '+
                 '         FROM (SELECT pas.id,                                     '+
                 '                      0 qtd                                       '+
                 '                 FROM pas)nexiste                                 '+
                 '         LEFT OUTER join                                          '+
                 '              (SELECT pa.id,                                      '+
                 '                      pa.nome PA,                                 '+
                 '                      count(*) qtd                                '+
                 '                 FROM PAS PA                                      '+
                 '                 join NN_PAS_FILAS npf ON (pa.ID = npf.ID_PA)     '+
                 '                 JOIN FILAS f          ON (F.ID = NPF.ID_FILA)    '+
                 '                 JOIN TICKETS T        ON (T.FILA_ID = F.ID)      '+
                 '                GROUP BY pa.id, pa.nome)existe                    '+
                 '           ON (nexiste.id = existe.id)                            '+
                 '        where 0 = 0                                               ';

                 if PA >0 then
                 LSQL_Select := LSQL_Select+
                 ' and nexiste.id = '+inttostr(aIdUnidade);

                 LSQL_Select := LSQL_Select+
                 '        order by nexiste.id                                       ';

          LQuery.Close;
          LQuery.SQL.Text := Format(LSQL_Select, [ATrackingID.QuotedString]);
          LQuery.Open;

          result := TJSONArray.Create;

          LQuery.first;
          if LQuery.eof then
          begin
            LJSON := TJSONObject.Create;
            LJSON.AddPair('result', 'Nenhum registro foi encontrado');
          end;

          while not LQuery.eof do
          begin
            LJSON := TJSONObject.Create;
            LJSON.AddPair('PA',TJSONNumber.Create(LQuery.FieldByName('pa').AsInteger));
            LJSON.AddPair('QuantidadeEspera', TJSONNumber.Create(LQuery.FieldByName('qtd').AsInteger));
            result.Add(LJSON);

            LQuery.next;
          end;


          LConexao.Close;
        except
          on E: Exception do
          begin
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
      TLibDataSnap.UpdateStatus('PA/SenhasEmEspera ' + E.Message, IdUnidade);
      raise Exception.Create('Error parsing input params:' + E.Message);
    end;
  end;
end;

end.
