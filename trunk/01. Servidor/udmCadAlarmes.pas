unit udmCadAlarmes;


interface

uses
  SysUtils, Classes, FMTBcd, Provider, DB, DBClient, MyDlls_DR,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt, FireDAC.Comp.DataSet, uDataSetHelper,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf;

type
  TdmSicsCadAlarmes = class(TDataModule)
    cdsMonitoramentos: TClientDataSet;
    dspMonitoramentos: TDataSetProvider;
    qryMonitoramentos: TFDQuery;
    cdsAlarmes: TClientDataSet;
    qryAlarmes: TFDQuery;
    dtsLinkMonitoramentos: TDataSource;
    cdsMonitoramentosID_PIMONITORAMENTO: TSmallintField;
    cdsMonitoramentosID_PI: TSmallintField;
    cdsMonitoramentosID_PIHORARIO: TSmallintField;
    cdsHorarios: TClientDataSet;
    dspHorarios: TDataSetProvider;
    qryHorarios: TFDQuery;
    cdsMonitoramentosLKP_HORARIO: TStringField;
    cdsPIS: TClientDataSet;
    dspPIS: TDataSetProvider;
    qryPIS: TFDQuery;
    cdsMonitoramentosLKP_PI: TStringField;
    cdsAlarmesID_PIALARME: TSmallintField;
    cdsAlarmesID_PIMONITORAMENTO: TSmallintField;
    cdsAlarmesID_PINIVEL: TSmallintField;
    cdsAlarmesID_PIACAODEALARME: TSmallintField;
    cdsAlarmesSUPERIOR: TStringField;
    cdsAlarmesMENSAGEM: TStringField;
    cdsAcoesAlarmes: TClientDataSet;
    dspAcoesAlarmes: TDataSetProvider;
    qryAcoesAlarmes: TFDQuery;
    cdsNiveis: TClientDataSet;
    dspNiveis: TDataSetProvider;
    qryNiveis: TFDQuery;
    cdsAlarmesLKP_ACAOALARME: TStringField;
    cdsAlarmesLKP_NIVEL: TStringField;
    cdsEmails: TClientDataSet;
    dspEmails: TDataSetProvider;
    qryEmails: TFDQuery;
    cdsCelulares: TClientDataSet;
    dspCelulares: TDataSetProvider;
    qryCelulares: TFDQuery;
    cdsGruposPas: TClientDataSet;
    dspGruposPas: TDataSetProvider;
    qryGruposPas: TFDQuery;
    cdsPaineis: TClientDataSet;
    dspPaineis: TDataSetProvider;
    qryPaineis: TFDQuery;
    cdsEmailsID: TIntegerField;
    cdsEmailsNOME: TStringField;
    cdsEmailsCALC_SELECIONADO: TBooleanField;
    cdsCelularesID: TIntegerField;
    cdsCelularesNOME: TStringField;
    cdsCelularesCALC_SELECIONADO: TBooleanField;
    cdsGruposPasID: TIntegerField;
    cdsGruposPasNOME: TStringField;
    cdsGruposPasCALC_SELECIONADO: TBooleanField;
    cdsPaineisID: TIntegerField;
    cdsPaineisNOME: TStringField;
    cdsPaineisCALC_SELECIONADO: TBooleanField;
    cdsAlarmesRelacionados: TClientDataSet;
    qryAlarmesRelacionados: TFDQuery;
    dtsLinkAlarmes: TDataSource;
    cdsAlarmesLKP_COR: TIntegerField;
    cdsAlarmesLIMIAR: TFloatField;
    cdsAlarmesINTCALC_POSICAONIVEL: TIntegerField;
    cdsMonitoramentosID_UNIDADE: TIntegerField;
    cdsAlarmesID_UNIDADE: TIntegerField;
    cdsCelularesID_UNIDADE: TIntegerField;
    cdsGruposPasID_UNIDADE: TIntegerField;
    cdsPaineisID_UNIDADE: TIntegerField;
    cdsAlarmesRelacionadosID_UNIDADE: TIntegerField;
    cdsAlarmesRelacionadosID_PIALARME: TSmallintField;
    cdsAlarmesRelacionadosID_RELACIONADO: TIntegerField;
    cdsMonitoramentosqryAlarmes: TDataSetField;
    cdsAlarmesqryAlarmesRelacionados: TDataSetField;
    procedure cdsMonitoramentosNewRecord(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
    procedure dspMonitoramentosBeforeUpdateRecord(Sender: TObject;
      SourceDS: TDataSet; DeltaDS: TCustomClientDataSet;
      UpdateKind: TUpdateKind; var Applied: Boolean);
    procedure cdsAlarmesNewRecord(DataSet: TDataSet);
    procedure cdsMonitoramentosReconcileError(
      DataSet: TCustomClientDataSet; E: EReconcileError;
      UpdateKind: TUpdateKind; var Action: TReconcileAction);
    procedure cdsEmailsCalcFields(DataSet: TDataSet);
    procedure cdsAlarmesID_PIACAODEALARMEValidate(Sender: TField);
    procedure cdsAlarmesBeforeDelete(DataSet: TDataSet);
    procedure cdsMonitoramentosBeforePost(DataSet: TDataSet);
    procedure cdsMonitoramentosBeforeDelete(DataSet: TDataSet);
    procedure cdsAlarmesLIMIARGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure cdsAlarmesLIMIARSetText(Sender: TField; const Text: String);
    procedure cdsMonitoramentosAfterApplyUpdates(Sender: TObject;
      var OwnerData: OleVariant);
    procedure cdsAlarmesCalcFields(DataSet: TDataSet);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FSqlConnUnidade: TFDConnection;
    FIdMonitoramentoSeq: Integer;
    FIdMonitoramentoNew: Integer;
    FIdAlarmeSeq: Integer;
    FIdAlarmeNew: Integer;
  public
    procedure Inicializar(IdUnidade: Integer);

    function GetDataRelacionado: TClientDataSet;
    procedure RefreshRelacionados;
    function IsFormatoHorario: Boolean;
  end;

var
  dmSicsCadAlarmes: TdmSicsCadAlarmes;

implementation

uses sics_94, Sics_91, UConexaoBD, ASPGenerator;

{$R *.dfm}

function TdmSicsCadAlarmes.IsFormatoHorario: Boolean;
var
  LPIComposto, LSomentePIsFormatoHorario: Boolean;
begin
	cdsPIS.Locate('ID_PI', cdSMonitoramentos.FieldByName('ID_PI').Value, []);

  LPIComposto := (TTipoPI(cdsPIS.FieldByName('ID_PITIPO').AsInteger) = tpiCombinacaoDeIndicadores);
  LSomentePIsFormatoHorario := LPIComposto and dmSicsMain.PICompostoSomentePorIndicadoresComFormatoHorario(cdsPIS.FieldByName('ID_PI').AsInteger);

  Result := ((not LPIComposto) and cdsPIS.FieldByName('FORMATOHORARIO').AsBoolean) or
            (LPIComposto and LSomentePIsFormatoHorario);
end;

function TdmSicsCadAlarmes.GetDataRelacionado: TClientDataSet;
begin
	with cdsAlarmes.FieldByName('ID_PIACAODEALARME') do
  	if IsNull then
    	Result := nil
    else
      case AsInteger of
        0: Result := nil;
        1: Result := cdsEmails;
        2: Result := cdsPaineis;
        3: Result := cdsGruposPas;
        4: Result := cdsCelulares;
      else
        Result := nil;
      end;
end;

procedure TdmSicsCadAlarmes.RefreshRelacionados;
var
  Book: TBookMark;
  DataSet: TDataSet;
begin
  DataSet := GetDataRelacionado;

  if (DataSet = nil) or (not DataSet.Active) then Exit;

  with DataSet do
  begin
  	Book := GetBookmark;
  	try
      // pensar melhor nisso
      First;
      Last;

    	GotoBookmark(Book);
  	finally
  		FreeBookmark(Book);
  	end;
  end;
  
end;

procedure TdmSicsCadAlarmes.cdsMonitoramentosNewRecord(DataSet: TDataSet);
begin
	Dec(FIdMonitoramentoSeq);
	with cdsMonitoramentos do
  begin
  	FieldByName('ID_PIMONITORAMENTO').AsInteger := FIdMonitoramentoSeq;
  end;
end;

procedure TdmSicsCadAlarmes.DataModuleCreate(Sender: TObject);
begin
  TConexaoBD.DefinirQueriesComoUnidirectional(Self);
	FIdMonitoramentoSeq := 0;
  FIdAlarmeSeq := 0;
end;

procedure TdmSicsCadAlarmes.dspMonitoramentosBeforeUpdateRecord(
  Sender: TObject; SourceDS: TDataSet; DeltaDS: TCustomClientDataSet;
  UpdateKind: TUpdateKind; var Applied: Boolean);
begin
	if UpdateKind = ukInsert then
  begin

  	if (SourceDs = qryMonitoramentos) or (SourceDs = qryAlarmes) then
    begin
    	if SourceDs = qryMonitoramentos then
				FIdMonitoramentoNew := TGenerator.NGetNextGenerator('GEN_ID_PIS_MONITORAMENTOS_ID', FSqlConnUnidade);

			if DeltaDs.FieldByName('ID_PIMONITORAMENTO').AsInteger < 0 then
    		DeltaDs.FieldByName('ID_PIMONITORAMENTO').NewValue := FIdMonitoramentoNew;
    end;

  	if (SourceDs = qryAlarmes) or (SourceDs = qryAlarmesRelacionados) then
    begin
    	if SourceDs = qryAlarmes then
      	FIdAlarmeNew := TGenerator.NGetNextGenerator('GEN_ID_PIS_ALARMES_ID', FSqlConnUnidade);

      if DeltaDs.FieldByName('ID_PIALARME').AsInteger < 0 then
      	DeltaDs.FieldByName('ID_PIALARME').NewValue := FIdAlarmeNew;
    end;

	end;
end;

procedure TdmSicsCadAlarmes.cdsAlarmesNewRecord(DataSet: TDataSet);
begin
	Dec(FIdAlarmeSeq);
	with DataSet do
  begin
  	FieldByName('ID_PIALARME').AsInteger := FIdAlarmeSeq;
    FieldByName('SUPERIOR').AsBoolean := True;
  end;
end;

procedure TdmSicsCadAlarmes.cdsMonitoramentosReconcileError(
  DataSet: TCustomClientDataSet; E: EReconcileError;
  UpdateKind: TUpdateKind; var Action: TReconcileAction);
begin
	MyLogException(E);
end;

procedure TdmSicsCadAlarmes.cdsEmailsCalcFields(DataSet: TDataSet);
begin
	if not cdsAlarmesRelacionados.Active then Exit;

	with DataSet do
  begin
    FieldByName('CALC_SELECIONADO').AsBoolean :=
    	cdsAlarmesRelacionados.Locate('ID_RELACIONADO', FieldByName('ID').Value, []);
  end;

end;

procedure TdmSicsCadAlarmes.cdsAlarmesID_PIACAODEALARMEValidate(
  Sender: TField);
begin
	with cdsAlarmesRelacionados do
  	while not Isempty do Delete;

	RefreshRelacionados;
end;

procedure TdmSicsCadAlarmes.cdsAlarmesBeforeDelete(DataSet: TDataSet);
begin
  with cdsAlarmesRelacionados do
		while not IsEmpty do Delete;
end;

procedure TdmSicsCadAlarmes.cdsMonitoramentosBeforePost(DataSet: TDataSet);
begin
	with DataSet do
  begin
  	if FieldByName('ID_PI').IsNull then
    	raise Exception.Create('Indicador não informado');

  	if FieldByName('ID_PIHORARIO').IsNull then
    	raise Exception.Create('Horário não informado');
  end;
end;

procedure TdmSicsCadAlarmes.cdsMonitoramentosBeforeDelete(DataSet: TDataSet);
begin
	with cdsAlarmes do
  	while not IsEmpty do Delete;
end;

procedure TdmSicsCadAlarmes.cdsAlarmesLIMIARGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if Sender.IsNull then
  begin
  	Text := '';
    Exit;
  end;

	if IsFormatoHorario then
  	Text := FormatDateTime('hh:nn', Sender.AsFloat)
	else
  	Text := Sender.AsString;

end;

procedure TdmSicsCadAlarmes.cdsAlarmesLIMIARSetText(Sender: TField;
  const Text: String);
begin
	if Text = '' then
  	Sender.Clear
  else
		if IsFormatoHorario then
  		Sender.AsFloat := StrToTime(Text)
		else
  		Sender.AsFloat := StrToInt(Text);
end;

procedure TdmSicsCadAlarmes.cdsMonitoramentosAfterApplyUpdates(Sender: TObject;
  var OwnerData: OleVariant);
begin
   dmSicsMain.AtualizarTabelasPis;
end;

procedure TdmSicsCadAlarmes.cdsAlarmesCalcFields(DataSet: TDataSet);
begin
  with DataSet do
  begin
    if (not FieldByName('ID_PINIVEL').IsNull) and cdsNiveis.Locate('ID_PINIVEL', FieldByName('ID_PINIVEL').Value, []) then
      FieldByName('INTCALC_POSICAONIVEL').Value := cdsNiveis.FieldByName('POSICAO').Value;
  end;
end;

procedure TdmSicsCadAlarmes.Inicializar(IdUnidade: Integer);
begin
  if IdUnidade > 0 then
  begin
    FSqlConnUnidade := dmSicsMain.CreateSqlConnUnidade(Self, IdUnidade);
    dmSicsMain.SetNewSqlConnectionForSQLDataSet(Self, FSqlConnUnidade);
  end
  else
    FSqlConnUnidade := dmSicsMain.connOnLine;

  cdsHorarios.Open;
  cdsPIS.Open;
  cdsAcoesAlarmes.Open;
  cdsNiveis.Open;
  cdsEmails.Open;
  cdsCelulares.Open;
  cdsGruposPas.Open;
  cdsPaineis.Open;

  cdsMonitoramentos.Open;
end;

procedure TdmSicsCadAlarmes.DataModuleDestroy(Sender: TObject);
begin
  if Assigned(FSqlConnUnidade) then
    FSqlConnUnidade.Connected := False;
end;

end.
