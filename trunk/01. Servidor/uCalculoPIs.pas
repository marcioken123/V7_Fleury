unit uCalculoPIs;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Datasnap.DBClient,
  System.Generics.Collections, FireDAC.Phys.FB, Data.FMTBcd,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt,
  FireDAC.VCLUI.Wait, uDataSetHelper, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet;

const
  CONST_DADO_INDISPONIVEL  = -9999;
  CONST_DADO_DESATUALIZADO = -9998;
  CONST_DADO_INVALIDO      = -9997;

type
  TCalculoPIs = class(TDataModule)
    LcdsPIs: TClientDataSet;
    LcdsPIsRel: TClientDataSet;
    LcdsFilas: TClientDataSet;
    LcdsNN_PAs_Filas: TClientDataSet;
    LcdsPAs: TClientDataSet;
    LcdsPIsClone: TClientDataSet;
    con: TFDConnection;
    qryTMA: TFDQuery;
    qryValoresEmBD: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FNowTime       : TDateTime;

    SenhasMaiorEsp : TDictionary<Integer, Double>;
    QtdesSenhas    : TDictionary<Integer, Integer>;
    EsperaUlt20    : TDictionary<Integer, Double>;
    Valores        : TList<Double>;
    Calculados     : TDictionary<Integer, Double>;

    function GetTMAPAs(const ACsvIDsPAs: String): Double;

    procedure GetData_PopularDatasetsLocais;
    procedure GetData_DaTelaParaListasLocais;

    procedure GetValues_PessoasEmFilaAgora;
    procedure GetValues_EsperaMaximaAgora;
    procedure GetValues_EsperaMediaUltimosN;
    procedure GetValues_PessoasEmAtendimentoAgora;
    procedure GetValues_TempoDeAtendimentoAgora;
    procedure GetValues_AtendentesLogadosAgora;
    procedure GetValues_TempoEstimadoDeEspera;
    procedure GetValues_TempoMedioDeAtendimento;
    procedure GetValues_ValoresEmBD_Horario;
    procedure GetValues_ValoresEmBD_Numerico;

    procedure CalculaIndicadoresComuns;
    procedure CalculaIndicadoresCompostos;

    function AplicarFuncaoSobreValores(const AIdPI, AIdFuncao: Integer): Double;
    function SecondToTime(const ASeconds: Cardinal): Double;

    procedure Preparar;
    procedure Calcular;
    procedure Atualizar;
  public
    class procedure Executar;
  end;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses sics_m, sics_94, sics_2, Sics_91, Vcl.StdCtrls, Vcl.Grids, System.DateUtils;

{$R *.dfm}

function TCalculoPIs.SecondToTime(const ASeconds: Cardinal): Double;
var
  ms, ss, mm, hh, dd: Cardinal;
begin
  dd :=   ASeconds div SecsPerDay;
  hh := ( ASeconds mod SecsPerDay) div SecsPerHour;
  mm := ((ASeconds mod SecsPerDay) mod SecsPerHour) div SecsPerMin;
  ss := ((ASeconds mod SecsPerDay) mod SecsPerHour) mod SecsPerMin;
  ms := 0;
  Result := dd + EncodeTime(hh, mm, ss, ms);
end;

procedure TCalculoPIs.Preparar;
begin
  GetData_PopularDatasetsLocais;
  GetData_DaTelaParaListasLocais;
  FNowTime := Now;
end;

function TCalculoPIs.AplicarFuncaoSobreValores(const AIdPI,
  AIdFuncao: Integer): Double;
var
  I: Integer;
begin
  result := 0;
  case TFuncaoPI(AIdFuncao) of
    fpiSoma: begin
      for I := 0 to Valores.Count-1 do
        result := result + Valores.Items[I];
    end;
    fpiMaximo: begin
      for I := 0 to Valores.Count-1 do
        if Valores.Items[I] > result then
          result := Valores.Items[I];
    end;
    fpiMinimo: begin
      result := Valores.Items[0];
      for I := 1 to Valores.Count-1 do
        if Valores.Items[i] < result then
          result := Valores.Items[i];
    end;
    fpiMedia: begin
      if Valores.Count > 0 then
      begin
        for I := 0 to Valores.Count-1 do
          result := result + Valores.Items[I];
        result   := result / Valores.Count;
      end;
    end;
  end; { case }
end;

procedure TCalculoPIs.Calcular;
begin
  Valores := TList<double>.Create;
  try
    CalculaIndicadoresComuns;
    CalculaIndicadoresCompostos;
  finally
    Valores.Free;
  end;
end;

procedure TCalculoPIs.Atualizar;
var
  LKey: Integer;
  LValorD: Double;
begin
  LcdsPIS.Filtered := False;
  LcdsPIS.First;

  //Atualiza o dmSicsMain.cdsPIS com o que foi calculado na thread
  TThread.Synchronize(nil, procedure
  begin
    while not LcdsPIS.Eof do
    begin
      LKey := LcdsPIS.FieldByName('ID_PI').AsInteger;

      if Calculados.TryGetValue(LKey, LValorD) and
         dmSicsMain.cdsPIS.Locate('ID_PI', LKey, []) then
      begin
        dmSicsMain.cdsPIS.Edit;
        dmSicsMain.cdsPISVALOR.Value := LValorD;
        dmSicsMain.cdsPIS.Post;
      end;

      LcdsPIS.Next;
    end;
  end);
end;

procedure TCalculoPIs.DataModuleCreate(Sender: TObject);
begin
  SenhasMaiorEsp := TDictionary<Integer, Double>.Create;
  QtdesSenhas    := TDictionary<Integer, Integer>.Create;
  EsperaUlt20    := TDictionary<Integer, Double>.Create;
  Calculados     := TDictionary<Integer, Double>.Create;

  con.DriverName := 'Firebird';
  con.Params.Clear;
end;

procedure TCalculoPIs.DataModuleDestroy(Sender: TObject);
begin
  if Assigned(Calculados) then
    Calculados.Free;
  if Assigned(EsperaUlt20) then
    EsperaUlt20.Free;
  if Assigned(QtdesSenhas) then
    QtdesSenhas.Free;
  if Assigned(SenhasMaiorEsp) then
    SenhasMaiorEsp.Free;
end;

class procedure TCalculoPIs.Executar;
var
  LInstance: TCalculoPIs;
begin
  LInstance := TCalculoPIs.Create(nil);
  try
    LInstance.Preparar;
    LInstance.Calcular;
    LInstance.Atualizar;
  finally
    LInstance.Free;
  end;
end;

procedure TCalculoPIs.GetData_DaTelaParaListasLocais;
var
  LKey: Integer;
  LNomeComp: string;
  LSG: TStringGrid;
  LLabel: TLabel;
begin
  LcdsFilas.First;
  while not LcdsFilas.Eof do
  begin                                               // >= 0 para se precaver do "-1" que eh "excluido"
    if (LcdsFilas.FieldByName('Ativo').AsBoolean) and (LcdsFilas.FieldByName('id').AsInteger >= 0) then
    begin
      LKey := LcdsFilas.FieldByName('ID').AsInteger;

      TThread.Synchronize(nil, procedure
      begin
        LNomeComp := 'SenhasList' + LKey.ToString;
        LSG := frmSicsMain.FindComponent(LNomeComp) as TStringGrid;
        if Assigned(LSG) then
          if Trim(LSG.Cells[COL_DATAHORA, 1]) <> '' then
            SenhasMaiorEsp.Add(LKey, StrToDatetime(LSG.Cells[COL_DATAHORA, 1]));

        LNomeComp := 'SenhasCountLabel' + LKey.ToString;
        LLabel := frmSicsMain.FindComponent(LNomeComp) as TLabel;
        if Assigned(LLabel) then
          QtdesSenhas.Add(LKey, StrToInt(LLabel.Caption));

        LNomeComp := 'EsperaUltimosN' + LKey.ToString;
        LLabel := frmSicsMain.FindComponent(LNomeComp) as TLabel;
        if Assigned(LLabel) then
          EsperaUlt20.Add(LKey, StrToDatetime(LLabel.Caption));
      end);
    end;
    LcdsFilas.Next;
  end;
end;

procedure TCalculoPIs.GetData_PopularDatasetsLocais;
begin
  TThread.Synchronize(nil, procedure
  begin
    LcdsFilas.Data        := dmSicsMain.cdsFilas.Data;
    LcdsPAS.Data          := frmSicsSituacaoAtendimento.cdsClonePAs.Data;
    LcdsNN_PAs_Filas.Data := dmSicsMain.cdsNN_PAs_Filas.Data;
    LcdsPIS.Data          := dmSicsMain.cdsPIS.Data;
    LcdsPISRel.Data       := dmSicsMain.cdsPisRelacionados.Data;

    if not qryValoresEmBD.Active then
      qryValoresEmBD.Open
    else
      qryValoresEmBD.Refresh;

     con.Params.AddStrings(dmSicsMain.connOnLine.Params);
  end);
end;

procedure TCalculoPIs.CalculaIndicadoresCompostos;
var
  LIdPI: Integer;
  LValorD: Double;
begin
  //LcdsPISClone é usado para recuperar o valor dos PIS já
  //calculados, que compõe os PIs atuais
  LCdsPISClone.CloneCursor(LcdsPIS, True);

  LcdsPIS.Filter := 'ID_PITIPO = ' + Integer(tpiCombinacaoDeIndicadores).ToString;
  LcdsPIS.Filtered := True;
  LcdsPIS.First;
  while not LcdsPIS.Eof do
  begin
    LIdPI := LcdsPIS.FieldByName('ID_PI').AsInteger;

    LcdsPISRel.Filter := 'ID_PI = ' + LIdPI.ToString;
    LcdsPISRel.Filtered := True;
    Valores.Clear;

    LcdsPISRel.First;
    while not LcdsPISRel.Eof do
    begin
      if Calculados.TryGetValue(LcdsPISRel.FieldByName('ID_RELACIONADO').AsInteger, LValorD) then
        Valores.Add(LValorD);

      LcdsPISRel.Next;
    end;

    LValorD := AplicarFuncaoSobreValores(LIdPI, LcdsPIS.FieldByName('ID_PIFUNCAO').AsInteger);
    Calculados.Add(LIdPI, LValorD);

    LCdsPIS.Next;
  end;
end;

procedure TCalculoPIs.CalculaIndicadoresComuns;
var
  LIdPI: Integer;
  LValorD: Double;
begin
  LcdsPIS.Filter := 'ID_PITIPO <> ' + Integer(tpiCombinacaoDeIndicadores).ToString;
  LcdsPIS.Filtered := True;
  LcdsPIS.First;
  while not LcdsPIS.Eof do
  begin
    LIdPI := LcdsPIS.FieldByName('ID_PI').AsInteger;

    LcdsPISRel.Filter := 'ID_PI = ' + LIdPI.ToString;
    LcdsPISRel.Filtered := True;
    Valores.Clear;

    //conforme o Tipo do PI, percorre a lista dos itens relacionados
    //(PAs, Filas ou PIs) e adiciona os dados na lista "Valores"
    case TTipoPI(LcdsPIS.FieldByName('ID_PITIPO').AsInteger) of
      tpiPessoasEmFilaAgora        : GetValues_PessoasEmFilaAgora;
      tpiEsperaMaximaAgora         : GetValues_EsperaMaximaAgora;
      tpiEsperaMediaUltimosN       : GetValues_EsperaMediaUltimosN;
      tpiPessoasEmAtendimentoAgora : GetValues_PessoasEmAtendimentoAgora;
      tpiTempoDeAtendimentoAgora   : GetValues_TempoDeAtendimentoAgora;
      tpiAtendentesLogadosAgora    : GetValues_AtendentesLogadosAgora;
      tpiTempoEstimadoDeEspera     : GetValues_TempoEstimadoDeEspera;
      tpiTempoMedioDeAtendimento   : GetValues_TempoMedioDeAtendimento;
      tpiValorBancoDadosHorario    : GetValues_ValoresEmBD_Horario;
      tpiValorBancoDadosNumerico   : GetValues_ValoresEmBD_Numerico;
    end;

    //Aplica a função do PI sobre a "Valores" e adiciona nos PIs "Calculados"
    LValorD := AplicarFuncaoSobreValores(LIdPI, LcdsPIS.FieldByName('ID_PIFUNCAO').AsInteger);
    Calculados.Add(LIdPI, LValorD);

    LcdsPIS.Next;
  end;
end;

//recupera o Tempo Médio de Atendimento (em segundos) das PAs que atendem as filas do PI
function TCalculoPIs.GetTMAPAs(const ACsvIDsPAs: String): Double;
const
  LSQL = 'select avg(duracao_segundos) from (' +
         //'  select first %d e.duracao_segundos from eventos e' +
         '  select {LIMIT(0, %d)} e.duracao_segundos from eventos e' + {DONE -oRafael Araujo -cCompatibilização SQL Server : First só funcionará com Firebird}
         '  where id_unidade = %d and e.id_tipoevento = 2 and e.id_pa in (%s)' +
         '  order by e.id desc)';
begin
  try
    qryTMA.SQL.Text :=
      Format(LSQL, [vgParametrosModulo.QtdeUltimasSenhasParaComporTMA, vgParametrosModulo.IdUnidade, ACsvIDsPAs]);
    try
      qryTMA.Open;
      result := qryTMA.Fields[0].AsFloat;
    finally
      con.Close;
    end;
  except
    con.Close;
    result := 0;
  end;
end;

procedure TCalculoPIs.GetValues_TempoEstimadoDeEspera;
begin
  TThread.Synchronize(nil,
    procedure
    var
      LQTDEPAProdutiva, LQTDEPessoasEspera, LIDTEE:integer;
    begin
      LcdsPISRel.First;
      Valores.Add(frmSicsMain.CalculaTEE(LcdsPISRel.FieldByName('ID_RELACIONADO').AsInteger,LQTDEPAProdutiva, LQTDEPessoasEspera, LIDTEE));
    end);
end;

procedure TCalculoPIs.GetValues_TempoMedioDeAtendimento;
var
  LKey: Integer;
  LCsvIDs: String;
  LMediaSegs: Integer;
begin
  LCsvIDs := '';

  LcdsPISRel.First;
  while not LcdsPISRel.Eof do
  begin
    LKey := LcdsPISRel.FieldByName('ID_RELACIONADO').AsInteger;
    if LcdsPAS.Locate('ID_PA', LKey, []) then
      LCsvIDs := LCsvIDs + LKey.ToString + ',';
    LcdsPISRel.Next;
  end;

  if LCsvIDs <> '' then
  begin
    Delete(LCsvIDs, Length(LCsvIDs), 1);
    LMediaSegs := Round(GetTMAPAs(LCsvIDs));
    Valores.Add(SecondToTime(LMediaSegs));
  end;
end;

procedure TCalculoPIs.GetValues_ValoresEmBD_Horario;
var
  LKey: Integer;
begin
  LcdsPISRel.First;
  while not LcdsPISRel.Eof do
  begin
    LKey := LcdsPISRel.FieldByName('ID_RELACIONADO').AsInteger;
    if qryValoresEmBD.Locate('ID', LKey, []) then
      try
        if (vgParametrosModulo.IntervaloEmSegsParaConsiderarDadoObsoleto = 0) or (qryValoresEmBD.FieldByName('ULTIMO_VALOR_EM').AsDateTime > IncSecond(now, -vgParametrosModulo.IntervaloEmSegsParaConsiderarDadoObsoleto)) then
          Valores.Add(StrToTime(qryValoresEmBD.FieldByName('VALOR').AsString))
        else
          Valores.Add(CONST_DADO_DESATUALIZADO);
      except
        Valores.Add(CONST_DADO_INVALIDO);
      end
    else
      Valores.Add(CONST_DADO_INDISPONIVEL);
    LcdsPISRel.Next;
  end;
end;

procedure TCalculoPIs.GetValues_ValoresEmBD_Numerico;
var
  LKey: Integer;
begin
  LcdsPISRel.First;
  while not LcdsPISRel.Eof do
  begin
    LKey := LcdsPISRel.FieldByName('ID_RELACIONADO').AsInteger;
    if qryValoresEmBD.Locate('ID', LKey, []) then
      try
        if (vgParametrosModulo.IntervaloEmSegsParaConsiderarDadoObsoleto = 0) or (qryValoresEmBD.FieldByName('ULTIMO_VALOR_EM').AsDateTime > IncSecond(now, -vgParametrosModulo.IntervaloEmSegsParaConsiderarDadoObsoleto)) then
          Valores.Add(StrToInt(qryValoresEmBD.FieldByName('VALOR').AsString))
        else
          Valores.Add(CONST_DADO_DESATUALIZADO);
      except
        Valores.Add(CONST_DADO_INVALIDO);
      end
    else
      Valores.Add(CONST_DADO_INDISPONIVEL);

    LcdsPISRel.Next;
  end;
end;

procedure TCalculoPIs.GetValues_AtendentesLogadosAgora;
var
  LKey: Integer;
begin
  LcdsPISRel.First;
  while not LcdsPISRel.Eof do
  begin
    LKey := LcdsPISRel.FieldByName('ID_RELACIONADO').AsInteger;
    if LcdsPAS.Locate('ID_PA', LKey, []) then
      if not LcdsPAS.FieldByName('ID_ATD').IsNull then
        Valores.Add(1);
    LcdsPISRel.Next;
  end;
end;

procedure TCalculoPIs.GetValues_TempoDeAtendimentoAgora;
var
  LKey: Integer;
begin
  LcdsPISRel.First;
  while not LcdsPISRel.Eof do
  begin
    LKey := LcdsPISRel.FieldByName('ID_RELACIONADO').AsInteger;
    if LcdsPAS.Locate('ID_PA', LKey, []) then
      if not LcdsPAS.FieldByName('SENHA').IsNull then
        Valores.Add(FNowTime - LcdsPAS.FieldByName('HORARIO').AsDateTime);
    LcdsPISRel.Next;
  end;
end;

procedure TCalculoPIs.GetValues_PessoasEmAtendimentoAgora;
var
  LKey: Integer;
begin
  LcdsPISRel.First;
  while not LcdsPISRel.Eof do
  begin
    LKey := LcdsPISRel.FieldByName('ID_RELACIONADO').AsInteger;
    if LcdsPAS.Locate('ID_PA', LKey, []) then
      if not LcdsPAS.FieldByName('SENHA').IsNull then
        Valores.Add(1);
    LcdsPISRel.Next;
  end;
end;

procedure TCalculoPIs.GetValues_EsperaMediaUltimosN;
var
  LKey: Integer;
  LValorD: Double;
begin
  LcdsPISRel.First;
  while not LcdsPISRel.Eof do
  begin
    LKey := LcdsPISRel.FieldByName('ID_RELACIONADO').AsInteger;
    if EsperaUlt20.TryGetValue(LKey, LValorD) then
      Valores.Add(LValorD);
    LcdsPISRel.Next;
  end;
end;

procedure TCalculoPIs.GetValues_EsperaMaximaAgora;
var
  LKey: Integer;
  LValorD: Double;
begin
  LcdsPISRel.First;
  while not LcdsPISRel.Eof do
  begin
    LKey := LcdsPISRel.FieldByName('ID_RELACIONADO').AsInteger;
    if SenhasMaiorEsp.TryGetValue(LKey, LValorD) then
      Valores.Add(FNowTime - LValorD);
    LcdsPISRel.Next;
  end;
end;

procedure TCalculoPIs.GetValues_PessoasEmFilaAgora;
var
  LKey, LValorI: Integer;
begin
  LcdsPISRel.First;
  while not LcdsPISRel.Eof do
  begin
    LKey := LcdsPISRel.FieldByName('ID_RELACIONADO').AsInteger;
    if QtdesSenhas.TryGetValue(LKey, LValorI) then
      Valores.Add(LValorI);
    LcdsPISRel.Next;
  end;
end;

end.
