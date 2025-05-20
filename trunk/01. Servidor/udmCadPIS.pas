unit udmCadPIS;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  SysUtils, Classes, udmCadBase, Datasnap.Provider, Datasnap.DBClient, Data.DB, Data.FMTBcd,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, uDataSetHelper,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.VCLUI.Wait, FireDAC.Phys.Intf, FireDAC.DApt.Intf;

type
  TdmSicsCadPIS = class(TdmSicsCadBase)
    cdsPis: TClientDataSet;
    cdsPisID_PI: TSmallintField;
    cdsPisID_PITIPO: TSmallintField;
    cdsPisID_PIFUNCAO: TSmallintField;
    cdsPisID_PIPOS: TSmallintField;
    cdsPisNOME: TStringField;
    cdsPisCARACTERES: TIntegerField;
    cdsPisIDSRELACIONADOS: TStringField;
    cdsPisFAZERLOG: TStringField;
    cdsPisqyPisRelacionados: TDataSetField;
    cdsPisCALC_SELECIONADO: TBooleanField;
    cdsPisID: TIntegerField;
    dspPis: TDataSetProvider;
    qryPis: TFDQuery;
    cdsTipos: TClientDataSet;
    cdsTiposID_PITIPO: TSmallintField;
    cdsTiposNOME: TStringField;
    cdsTiposTABELARELACIONADA: TStringField;
    cdsTiposFORMATOHORARIO: TStringField;
    cdsTiposINTCALC_NOME: TStringField;
    dspTipos: TDataSetProvider;
    qryTipos: TFDQuery;
    cdsFuncao: TClientDataSet;
    cdsFuncaoID_PIFUNCAO: TSmallintField;
    cdsFuncaoNOME: TStringField;
    dspFuncao: TDataSetProvider;
    qryFuncao: TFDQuery;
    cdsFilas: TClientDataSet;
    cdsFilasID: TIntegerField;
    cdsFilasNOME: TStringField;
    cdsFilasCALC_SELECIONADO: TBooleanField;
    dspFilas: TDataSetProvider;
    qryFilas: TFDQuery;
    cdsPAS: TClientDataSet;
    cdsPASID: TIntegerField;
    cdsPASNOME: TStringField;
    cdsPASCALC_SELECIONADO: TBooleanField;
    dspPAS: TDataSetProvider;
    qryPAS: TFDQuery;
    cdsPisRelacionados: TClientDataSet;
    qyPisRelacionados: TFDQuery;
    dtsLinkPis: TDataSource;
    cdSPisClone: TClientDataSet;
    cdsPisID_UNIDADE: TIntegerField;
    cdsTiposID_UNIDADE: TIntegerField;
    cdsFuncaoID_UNIDADE: TIntegerField;
    cdsFilasID_UNIDADE: TIntegerField;
    cdsPASID_UNIDADE: TIntegerField;
    cdsValoresEmBD: TClientDataSet;
    dspValoresEmBD: TDataSetProvider;
    qryValoresEmBD: TFDQuery;
    cdsValoresEmBDID_UNIDADE: TIntegerField;
    cdsValoresEmBDNOME: TStringField;
    cdsValoresEmBDVALOR: TStringField;
    cdsValoresEmBDULTIMO_VALOR_EM: TSQLTimeStampField;
    cdsValoresEmBDCALC_SELECIONADO: TBooleanField;
    cdsValoresEmBDID: TIntegerField;
    procedure DataModuleCreate(Sender: TObject);
    procedure cdsPisReconcileError(DataSet: TCustomClientDataSet;
      E: EReconcileError; UpdateKind: TUpdateKind;
      var Action: TReconcileAction);
    procedure cdsPisNewRecord(DataSet: TDataSet);
    procedure cdsFilasCalcFields(DataSet: TDataSet);
    procedure cdsPisID_PITIPOValidate(Sender: TField);
    procedure cdsPisAfterOpen(DataSet: TDataSet);
    procedure dspPisBeforeUpdateRecord(Sender: TObject; SourceDS: TDataSet;
      DeltaDS: TCustomClientDataSet; UpdateKind: TUpdateKind;
      var Applied: Boolean);
    procedure cdsPisBeforeDelete(DataSet: TDataSet);
    procedure cdsPisAfterApplyUpdates(Sender: TObject;
      var OwnerData: OleVariant);
    procedure cdsTiposCalcFields(DataSet: TDataSet);
    procedure cdsPASCalcFields(DataSet: TDataSet);
    procedure cdSPisCloneCalcFields(DataSet: TDataSet);
    procedure cdsPisAfterPost(DataSet: TDataSet);
    procedure cdsValoresEmBDCalcFields(DataSet: TDataSet);
  private
    FIdPiSeq: Integer;
    FIdPiNew: Integer;
  public
    procedure Inicializar; Override;
    procedure RefreshRelacionados;
    function GetDataRelacionado: TClientDataSet;
  end;

var
  dmSicsCadPIS: TdmSicsCadPis;

implementation



{$R *.dfm}

uses Sics_91;


procedure TdmSicsCadPIS.RefreshRelacionados;
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

procedure TdmSicsCadPIS.DataModuleCreate(Sender: TObject);
begin
  FIdPiSeq := 0;
end;

procedure TdmSicsCadPIS.cdsPisReconcileError(
  DataSet: TCustomClientDataSet; E: EReconcileError;
  UpdateKind: TUpdateKind; var Action: TReconcileAction);
begin
	OnReconcileError(DataSet, E, UpdateKind, Action);
end;

procedure TdmSicsCadPIS.cdsPisNewRecord(DataSet: TDataSet);
begin
  Dec(FIdPiSeq);

	with cdsPis do
  begin
    FieldByName('ID_PI').AsInteger := FIdPiSeq;
  	FieldByName('FAZERLOG').AsBoolean := False;
  end;
end;

function TdmSicsCadPIS.GetDataRelacionado: TClientDataSet;
begin
  if cdsPis.FieldByName('ID_PITIPO').IsNull then
    Result := nil
  else
    case cdsPis.FieldByName('ID_PITIPO').AsInteger of
      Integer(TTipoPI.tpiPessoasEmFilaAgora),
      Integer(TTipoPI.tpiEsperaMaximaAgora),
      Integer(TTipoPI.tpiEsperaMediaUltimosN),
      Integer(TTipoPI.tpiTempoEstimadoDeEspera): Result := cdsFilas;

      Integer(TTipoPI.tpiPessoasEmAtendimentoAgora),
      Integer(TTipoPI.tpiTempoDeAtendimentoAgora),
      Integer(TTipoPI.tpiAtendentesLogadosAgora),
      Integer(TTipoPI.tpiTempoMedioDeAtendimento): Result := cdsPas;

      Integer(TTipoPI.tpiCombinacaoDeIndicadores): Result := cdSPisClone;

      Integer(TTipoPI.tpiValorBancoDadosHorario),
      Integer(TTipoPI.tpiValorBancoDadosNumerico): Result := cdsValoresEmBD;
    else
      Result := nil;
    end;
end;

procedure TdmSicsCadPIS.cdsPisID_PITIPOValidate(Sender: TField);
begin
	with cdsPisRelacionados do
  	while not Isempty do Delete;

	RefreshRelacionados;
end;

procedure TdmSicsCadPIS.cdsPisAfterOpen(DataSet: TDataSet);
begin
	cdsPisClone.CloneCursor(cdsPis, True);
end;

procedure TdmSicsCadPIS.cdsPisAfterPost(DataSet: TDataSet);
begin
  inherited;
  DataSet.Locate('ID_PI', FIdPiSeq, []);
end;

procedure TdmSicsCadPIS.dspPisBeforeUpdateRecord(Sender: TObject;
  SourceDS: TDataSet; DeltaDS: TCustomClientDataSet;
  UpdateKind: TUpdateKind; var Applied: Boolean);
begin
	if UpdateKind = ukInsert then
  begin
  	if SourceDs = qryPis then
    	FIdPiNew := GetNextGenerator('GEN_ID_PIS_ID_PI');

    if DeltaDs.FieldByName('ID_PI').AsInteger < 0 then
      DeltaDs.FieldByName('ID_PI').NewValue := FIdPiNew;
	end;

end;

procedure TdmSicsCadPIS.cdsPisBeforeDelete(DataSet: TDataSet);
begin
  with cdsPisRelacionados do
		while not IsEmpty do Delete;
end;


procedure TdmSicsCadPIS.cdSPisCloneCalcFields(DataSet: TDataSet);
var
  LId: Integer;
begin
  inherited;
  LId := DataSet.FieldByName('ID_PI').AsInteger;
  DataSet.FieldByName('ID').AsInteger := LId;
  DataSet.FieldByName('CALC_SELECIONADO').AsBoolean :=
    cdsPisRelacionados.Locate('ID_RELACIONADO', LId, []);
end;

procedure TdmSicsCadPIS.cdsFilasCalcFields(DataSet: TDataSet);
begin
	if not cdsPisRelacionados.Active then Exit;

	with DataSet do
  begin
  	if DataSet = cdsPisClone then
    	FieldByName('ID').Value := FieldByName('ID_PI').Value;

    FieldByName('CALC_SELECIONADO').AsBoolean :=
    	cdsPisRelacionados.Locate('ID_RELACIONADO', FieldByName('ID').Value, []);
  end;
end;

procedure TdmSicsCadPIS.cdsPASCalcFields(DataSet: TDataSet);
begin
  if not cdsPisRelacionados.Active then Exit;

	with DataSet do
  begin
  	if DataSet = cdsPisClone then
    	FieldByName('ID').Value := FieldByName('ID_PI').Value;

    FieldByName('CALC_SELECIONADO').AsBoolean :=
    	cdsPisRelacionados.Locate('ID_RELACIONADO', FieldByName('ID').Value, []);
  end;
end;

procedure TdmSicsCadPIS.cdsValoresEmBDCalcFields(DataSet: TDataSet);
begin
  if not cdsPisRelacionados.Active then Exit;

	with DataSet do
  begin
  	if DataSet = cdsPisClone then
    	FieldByName('ID').Value := FieldByName('ID_PI').Value;

    FieldByName('CALC_SELECIONADO').AsBoolean :=
    	cdsPisRelacionados.Locate('ID_RELACIONADO', FieldByName('ID').Value, []);
  end;
end;

procedure TdmSicsCadPIS.cdsPisAfterApplyUpdates(Sender: TObject;
  var OwnerData: OleVariant);
begin
   AtualizarTabelasPis;
end;

procedure TdmSicsCadPIS.cdsTiposCalcFields(DataSet: TDataSet);
begin
  with DataSet do
  begin
    FieldByName('INTCALC_NOME').AsString := FieldByName('NOME').AsString;
    if FieldByName('ID_PITIPO').AsInteger <> 6 then
      if FieldByName('FORMATOHORARIO').AsBoolean then
        FieldByName('INTCALC_NOME').AsString :=  FieldByName('INTCALC_NOME').AsString + ' [hh:mm:ss]'
      else
        FieldByName('INTCALC_NOME').AsString :=  FieldByName('INTCALC_NOME').AsString + ' [qtde]';
  end;
end;

procedure TdmSicsCadPIS.Inicializar;
begin
  inherited;

	cdsPIS.Open;
  cdsTipos.Open;
  cdsFuncao.Open;

  cdsFilas.Open;
  cdsPAS.Open;
  cdsValoresEmBD.Open;
end;

end.
