unit udmCadPIS;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  SysUtils, Classes, udmCadBase, Datasnap.Provider, Datasnap.DBClient,
  Data.DB, Data.FMTBcd,System.Variants, MyAspFuncoesUteis,FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, 
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, 
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.DBX.Migrate, uDataSetHelper;

type
  TTipoPI   = (tpiPessoasEmFilaAgora, tpiEsperaMaximaAgora, tpiEsperaMediaUltimos20,
               tpiPessoasEmAtendimentoAgora, tpiTempoDeAtendimentoAgora,
               tpiAtendentesLogadosAgora, tpiCombinacaoDeIndicadores,
               tpiTempoEstimadoDeEspera, tpiTempoMedioDeAtendimento,
                tpiValorBancoDadosHorario, tpiValorBancoDadosNumerico);

  TFuncaoPI = (fpiSoma, fpiMaximo, fpiMinimo, fpiMedia);

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
    qyPisRelacionadosID_PI: TSmallintField;
    qyPisRelacionadosID_RELACIONADO: TIntegerField;
    cdsPisRelacionadosID_PI: TSmallintField;
    cdsPisRelacionadosID_RELACIONADO: TIntegerField;
    qryMonitoramentos: TFDQuery;
    dspMonitoramentos: TDataSetProvider;
    cdsMonitoramentos: TClientDataSet;
    cdsMonitoramentosID_PIMONITORAMENTO: TSmallintField;
    cdsMonitoramentosID_PIHORARIO: TSmallintField;
    cdsMonitoramentosID_PI: TSmallintField;
    cdsPisID_UNIDADE: TIntegerField;
    qyPisRelacionadosID_UNIDADE: TIntegerField;
    cdsPisRelacionadosID_UNIDADE: TIntegerField;
    cdsTiposID_UNIDADE: TIntegerField;
    cdsFuncaoID_UNIDADE: TIntegerField;
    cdsMonitoramentosID_UNIDADE: TIntegerField;
    cdsFilasID_UNIDADE: TIntegerField;
    cdsPASID_UNIDADE: TIntegerField;
    cdsValores: TClientDataSet;
    dspValores: TDataSetProvider;
    qryValores: TFDQuery;
    cdsValoresID: TIntegerField;
    cdsValoresNOME: TStringField;
    cdsValoresCALC_SELECIONADO: TBooleanField;
    cdsValoresID_UNIDADE: TIntegerField;
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
    procedure cdsTiposCalcFields(DataSet: TDataSet);
    procedure cdsFilasCALC_SELECIONADOChange(Sender: TField);
    procedure cdsPASCALC_SELECIONADOChange(Sender: TField);
    procedure cdsValoresCALC_SELECIONADOChange(Sender: TField);
  private
    FIdPiSeq: Integer;
    FIdPiNew: Integer;
  public
    procedure Inicializar; Override;
    procedure RefreshRelacionados;
    function GetDataRelacionado: TClientDataSet;
    function PossuiModificacoes: Boolean; Override;
  end;

implementation

{$R *.dfm}

procedure TdmSicsCadPIS.RefreshRelacionados;
//var
//  Book: TBookMark;
//  DataSet: TDataSet;
begin
  //BAH retirado, verificar necessidade posteriormente
  {DataSet := GetDataRelacionado;

  if (DataSet = nil) or (not DataSet.Active) then Exit;

  with DataSet do
  begin
  	Book := GetBookmark;
  	try
      // pensar melhor nisso
      First;
      Last;
      if BookmarkValid(Book) then
      	GotoBookmark(Book);
  	finally
  		FreeBookmark(Book);
  	end;
  end;  }

end;

procedure TdmSicsCadPIS.DataModuleCreate(Sender: TObject);
begin
  FIdPiSeq := 0;
end;

procedure TdmSicsCadPIS.cdsPisReconcileError(
  DataSet: TCustomClientDataSet; E: EReconcileError;
  UpdateKind: TUpdateKind; var Action: TReconcileAction);
begin
  MyLogException(E);
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

procedure TdmSicsCadPIS.cdsFilasCalcFields(DataSet: TDataSet);
begin
 	if not cdsPisRelacionados.Active then Exit;

	with DataSet do
  begin

  	if DataSet = cdsPisClone then
    	FieldByName('ID').Value := FieldByName('ID_PI').Value;

    FieldByName('CALC_SELECIONADO').AsBoolean :=
    	cdsPisRelacionados.Locate('ID_PI;ID_RELACIONADO',
                                 VarArrayOf([cdsPis.FieldByName('ID_PI').Value,
                                                    FieldByName('ID').Value]) , []);
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
      Integer(TTipoPI.tpiEsperaMediaUltimos20),
      Integer(TTipoPI.tpiTempoEstimadoDeEspera): Result := cdsFilas;

      Integer(TTipoPI.tpiPessoasEmAtendimentoAgora),
      Integer(TTipoPI.tpiTempoDeAtendimentoAgora),
      Integer(TTipoPI.tpiAtendentesLogadosAgora),
      Integer(TTipoPI.tpiTempoMedioDeAtendimento): Result := cdsPas;

      Integer(TTipoPI.tpiCombinacaoDeIndicadores): Result := cdSPisClone;
      Integer(TTipoPI.tpiValorBancoDadosHorario),
      Integer(TTipoPI.tpiValorBancoDadosNumerico) : Result := cdsValores;

//      0,1,2: Result := cdsFilas;
//      3,4,5: Result := cdsPas;
//      6: Result := cdsPISClone;
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
  with cdSPisClone do
  begin
    First;
    while not eof do
    begin
      if not(cdSPisClone.State in [dsInsert,dsEdit])then
       Edit;

      FieldByName('ID').Value := FieldByName('ID_PI').Value;

      Post;
      Next;
    end;

  end;
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


procedure TdmSicsCadPIS.cdsFilasCALC_SELECIONADOChange(Sender: TField);
begin
  inherited;
  with cdsPisRelacionados do
  begin
   	if not Sender.AsBoolean then
    begin
     	if Locate('ID_PI;ID_RELACIONADO',
              VarArrayOf( [
                           cdsPis.FieldByName('ID_PI').Value,
                           cdsFilas.FieldByName('ID').Value
                         ]), []) then
        Delete;

      RefreshRelacionados;
    end
    else
    begin
    	Append;
      FieldByName('ID_PI').Value := cdsPis.FieldByName('ID_PI').Value;    //BAH testando
      FieldByName('ID_RELACIONADO').Value := cdsFilas.FieldByName('ID').Value;
      Post;

      RefreshRelacionados;
    end;
  end;

end;

procedure TdmSicsCadPIS.cdsPASCALC_SELECIONADOChange(Sender: TField);
begin
  inherited;
   with cdsPisRelacionados do
  begin
   	if not Sender.AsBoolean then
    begin
     	if Locate('ID_PI;ID_RELACIONADO',
              VarArrayOf( [
                           cdsPis.FieldByName('ID_PI').Value,
                           cdsPAS.FieldByName('ID').Value
                         ]), []) then
        Delete;

      RefreshRelacionados;
    end
    else
    begin
    	Append;
      FieldByName('ID_PI').Value := cdsPis.FieldByName('ID_PI').Value;    //BAH testando
      FieldByName('ID_RELACIONADO').Value := cdsPAS.FieldByName('ID').Value;
      Post;

      RefreshRelacionados;
    end;
  end;
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

procedure TdmSicsCadPIS.cdsValoresCALC_SELECIONADOChange(Sender: TField);
begin
  inherited;
   with cdsPisRelacionados do
  begin
   	if not Sender.AsBoolean then
    begin
     	if Locate('ID_PI;ID_RELACIONADO',
              VarArrayOf( [
                           cdsPis.FieldByName('ID_PI').Value,
                           cdsPAS.FieldByName('ID').Value
                         ]), []) then
        Delete;

      RefreshRelacionados;
    end
    else
    begin
    	Append;
      FieldByName('ID_PI').Value := cdsPis.FieldByName('ID_PI').Value;    //BAH testando
      FieldByName('ID_RELACIONADO').Value := cdsPAS.FieldByName('ID').Value;
      Post;

      RefreshRelacionados;
    end;
  end;
end;

procedure TdmSicsCadPIS.Inicializar;
begin
  inherited;

	cdsPIS.Close;
  cdsTipos.Close;
  cdsFuncao.Close;
  cdsFilas.Close;
  cdsPAS.Close;
  cdsValores.Close;

  cdsPIS.Open;
  cdsTipos.Open;
  cdsFuncao.Open;
  cdsFilas.Open;
  cdsPAS.Open;
  cdsValores.Open;
end;

function TdmSicsCadPIS.PossuiModificacoes: Boolean;
begin
  Result := ((inherited PossuiModificacoes) or
            ModificouDataSet(cdsTipos) or
            ModificouDataSet(cdsPis) or
            ModificouDataSet(cdsFuncao));
end;

end.
