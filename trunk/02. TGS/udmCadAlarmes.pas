unit udmCadAlarmes;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  SysUtils, udmCadBase, Classes, Datasnap.DBClient, Data.FMTBcd, Datasnap.Provider, Data.DB, System.Variants,
  MyAspFuncoesUteis, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, 
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.DBX.Migrate, uDataSetHelper;

type
  TdmSicsCadAlarmes = class(TdmSicsCadBase)
    cdsMonitoramentos: TClientDataSet;
    dspMonitoramentos: TDataSetProvider;
    qryMonitoramentos: TFDQuery;
    cdsAlarmes: TClientDataSet;
    qryAlarmes: TFDQuery;
    dtsLinkMonitoramentos: TDataSource;
    cdsMonitoramentosID_PIMONITORAMENTO: TSmallintField;
    cdsMonitoramentosID_PI: TSmallintField;
    cdsMonitoramentosID_PIHORARIO: TSmallintField;
    cdsMonitoramentosqryAlarmes: TDataSetField;
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
    cdsAlarmesqryAlarmesRelacionados: TDataSetField;
    cdsAlarmesLKP_COR: TIntegerField;
    cdsAlarmesLIMIAR: TFloatField;
    cdsAlarmesINTCALC_POSICAONIVEL: TIntegerField;
    cdsAcoesAlarmesID_PIACAODEALARME: TSmallintField;
    cdsAcoesAlarmesNOME: TStringField;
    cdsAlarmesRelacionadosID_PIALARME: TSmallintField;
    cdsAlarmesRelacionadosID_RELACIONADO: TIntegerField;
    cdsHorariosID_PIHORARIO: TIntegerField;
    cdsHorariosNOME: TStringField;
    cdsPISNOME: TStringField;
    cdsPISFORMATOHORARIO: TStringField;
    cdsPISID_PI: TIntegerField;
    cdsNiveisID_PINIVEL: TIntegerField;
    cdsNiveisNOME: TStringField;
    cdsNiveisCODIGOCOR: TIntegerField;
    cdsNiveisPOSICAO: TIntegerField;
    cdsPISID_PITIPO: TSmallintField;
    cdsAlarmesID_UNIDADE: TIntegerField;
    cdsMonitoramentosID_UNIDADE: TIntegerField;
    cdsAlarmesRelacionadosID_UNIDADE: TIntegerField;
    procedure cdsMonitoramentosNewRecord(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
    procedure dspMonitoramentosBeforeUpdateRecord(Sender: TObject; SourceDS: TDataSet; DeltaDS: TCustomClientDataSet;
      UpdateKind: TUpdateKind; var Applied: Boolean);
    procedure cdsMonitoramentosReconcileError(DataSet: TCustomClientDataSet; E: EReconcileError;
      UpdateKind: TUpdateKind; var Action: TReconcileAction);
    procedure cdsEmailsCalcFields(DataSet: TDataSet);
    procedure cdsAlarmesID_PIACAODEALARMEValidate(Sender: TField);
    procedure cdsAlarmesBeforeDelete(DataSet: TDataSet);
    procedure cdsMonitoramentosBeforePost(DataSet: TDataSet);
    procedure cdsMonitoramentosBeforeDelete(DataSet: TDataSet);
    procedure cdsAlarmesLIMIARGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure cdsAlarmesLIMIARSetText(Sender: TField; const Text: String);
    procedure cdsAlarmesCalcFields(DataSet: TDataSet);
    procedure cdsEmailsCALC_SELECIONADOChange(Sender: TField);
    procedure cdsCelularesCALC_SELECIONADOChange(Sender: TField);
    procedure cdsGruposPasCALC_SELECIONADOChange(Sender: TField);
    procedure cdsPaineisCALC_SELECIONADOChange(Sender: TField);
    procedure cdsAlarmesAfterInsert(DataSet: TDataSet);
  protected
    FIdMonitoramentoSeq: Integer;
    FIdMonitoramentoNew: Integer;
    FIdAlarmeSeq: Integer;
    FIdAlarmeNew,
    FUltimoIDPI: Integer;

  public
    procedure Inicializar; Override;

    function GetDataRelacionado: TClientDataSet;
    procedure RefreshRelacionados;
    function IsFormatoHorario: Boolean;
    function PossuiModificacoes: Boolean; Override;
  end;

implementation

{$R *.dfm}
{ %CLASSGROUP 'FMX.Controls.TControl' }

uses
  Sics_Common_Parametros, untCommonDMClient, udmCadPIS, ASPGenerator;

function TdmSicsCadAlarmes.IsFormatoHorario: Boolean;
var
  LPIComposto, LSomentePIsFormatoHorario: Boolean;
begin
  Result := False;
	if cdsPIS.Locate('ID_PI', cdSMonitoramentos.FieldByName('ID_PI').Value, []) then
  begin
    LPIComposto := (TTipoPI(cdsPIS.FieldByName('ID_PITIPO').AsInteger) = TTipoPI.tpiCombinacaoDeIndicadores);
    LSomentePIsFormatoHorario := LPIComposto and DMClient(IdUnidade, NOT CRIAR_SE_NAO_EXISTIR).PICompostoSomentePorIndicadoresComFormatoHorario(cdsPIS.FieldByName('ID_PI').AsInteger);

    Result := ((not LPIComposto) and cdsPIS.FieldByName('FORMATOHORARIO').AsBoolean) or
              (LPIComposto and LSomentePIsFormatoHorario);
  end;
end;

function TdmSicsCadAlarmes.PossuiModificacoes: Boolean;
begin
  Result := (inherited PossuiModificacoes) or
            ModificouDataSet(cdsAlarmes) or
            ModificouDataSet(cdsAcoesAlarmes) or
            ModificouDataSet(GetDataRelacionado) or
            ModificouDataSet(cdsMonitoramentos);
end;

function TdmSicsCadAlarmes.GetDataRelacionado: TClientDataSet;
begin
	with cdsAlarmes.FieldByName('ID_PIACAODEALARME') do
	begin
  	if IsNull then
    	Result := nil
    else
	begin
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
	 end;
end;

procedure TdmSicsCadAlarmes.RefreshRelacionados;
//var
//  Book: TBookMark;
//  DataSet: TDataSet;
begin
 //BAH - Não irei retirar este comentário, pois irei verificar o impacto do código abaixo
 {BAH DataSet := GetDataRelacionado;

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
  end; }
  
end;

procedure TdmSicsCadAlarmes.cdsMonitoramentosNewRecord(DataSet: TDataSet);
begin
	Dec(FIdMonitoramentoSeq);
  	cdsMonitoramentos.FieldByName('ID_PIMONITORAMENTO').AsInteger := FIdMonitoramentoSeq;
end;

procedure TdmSicsCadAlarmes.DataModuleCreate(Sender: TObject);
begin
  inherited;
  FUltimoIDPI := 0;
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
				FIdMonitoramentoNew := TGenerator.NGetNextGenerator('GEN_ID_PIS_MONITORAMENTOS_ID', TFDConnection(qryMonitoramentos.Connection));

			if DeltaDs.FieldByName('ID_PIMONITORAMENTO').AsInteger < 0 then
    		DeltaDs.FieldByName('ID_PIMONITORAMENTO').NewValue := FIdMonitoramentoNew;
    end;

  	if (SourceDs = qryAlarmes) or (SourceDs = qryAlarmesRelacionados) then
    begin
    	if SourceDs = qryAlarmes then
      	FIdAlarmeNew := TGenerator.NGetNextGenerator('GEN_ID_PIS_ALARMES_ID', TFDConnection(qryMonitoramentos.Connection));

      if DeltaDs.FieldByName('ID_PIALARME').AsInteger < 0 then
      	DeltaDs.FieldByName('ID_PIALARME').NewValue := FIdAlarmeNew;
    end;
	end;
end;

procedure TdmSicsCadAlarmes.cdsCelularesCALC_SELECIONADOChange(
  Sender: TField);
begin
  inherited;
  with cdsAlarmesRelacionados do
  begin
   	if not Sender.AsBoolean then
    begin
     	if Locate('ID_PIALARME;ID_RELACIONADO',
              VarArrayOf( [
                           cdsAlarmes.FieldByName('ID_PIALARME').Value,
                           cdsCelulares.FieldByName('ID').Value
                         ]), []) then
        Delete;

      RefreshRelacionados;
    end
    else
    begin
    	Append;
      FieldByName('ID_PIALARME').Value := cdsAlarmes.FieldByName('ID_PIALARME').Value;    //BAH testando
      FieldByName('ID_RELACIONADO').Value := cdsCelulares.FieldByName('ID').Value;
      Post;

      RefreshRelacionados;
    end;
  end;
end;

procedure TdmSicsCadAlarmes.cdsMonitoramentosReconcileError(
  DataSet: TCustomClientDataSet; E: EReconcileError;
  UpdateKind: TUpdateKind; var Action: TReconcileAction);
begin
  MyLogException(E);
end;

procedure TdmSicsCadAlarmes.cdsPaineisCALC_SELECIONADOChange(
  Sender: TField);
begin
  inherited;
  with cdsAlarmesRelacionados do
  begin
   	if not Sender.AsBoolean then
    begin
     	if Locate('ID_PIALARME;ID_RELACIONADO',
              VarArrayOf( [
                           cdsAlarmes.FieldByName('ID_PIALARME').Value,
                           cdsPaineis.FieldByName('ID').Value
                         ]), []) then
        Delete;

      RefreshRelacionados;
    end
    else
    begin
    	Append;
      FieldByName('ID_PIALARME').Value := cdsAlarmes.FieldByName('ID_PIALARME').Value;    //BAH testando
      FieldByName('ID_RELACIONADO').Value := cdsPaineis.FieldByName('ID').Value;
      Post;

      RefreshRelacionados;
    end;
  end;
end;

procedure TdmSicsCadAlarmes.cdsEmailsCalcFields(DataSet: TDataSet);
begin
	if not cdsAlarmesRelacionados.Active then Exit;

	with DataSet do
  begin
    FieldByName('CALC_SELECIONADO').AsBoolean :=
    	cdsAlarmesRelacionados.Locate('ID_PIALARME;ID_RELACIONADO',  VarArrayOf( [
                                                                                 cdsAlarmes.FieldByName('ID_PIALARME').Value,
                                                                                 FieldByName('ID').Value
                                                                               ]), []);
  end;

end;

procedure TdmSicsCadAlarmes.cdsEmailsCALC_SELECIONADOChange(
  Sender: TField);
begin
  inherited;
   with cdsAlarmesRelacionados do
  begin
   	if not Sender.AsBoolean then
    begin
     	if Locate('ID_PIALARME;ID_RELACIONADO',
              VarArrayOf( [
                           cdsAlarmes.FieldByName('ID_PIALARME').Value,
                           cdsEmails.FieldByName('ID').Value
                         ]), []) then
        Delete;

      RefreshRelacionados;
    end
    else
    begin
    	Append;
      FieldByName('ID_PIALARME').Value := cdsAlarmes.FieldByName('ID_PIALARME').Value;    //BAH testando
      FieldByName('ID_RELACIONADO').Value := cdsEmails.FieldByName('ID').Value;
      Post;

      RefreshRelacionados;
    end;
  end;
end;

procedure TdmSicsCadAlarmes.cdsGruposPasCALC_SELECIONADOChange(
  Sender: TField);
begin
  inherited;
  with cdsAlarmesRelacionados do
  begin
   	if not Sender.AsBoolean then
    begin
     	if Locate('ID_PIALARME;ID_RELACIONADO',
              VarArrayOf( [
                           cdsAlarmes.FieldByName('ID_PIALARME').Value,
                           cdsGruposPas.FieldByName('ID').Value
                         ]), []) then
        Delete;

      RefreshRelacionados;
    end
    else
    begin
    	Append;
      FieldByName('ID_PIALARME').Value := cdsAlarmes.FieldByName('ID_PIALARME').Value;    //BAH testando
      FieldByName('ID_RELACIONADO').Value := cdsGruposPas.FieldByName('ID').Value;
      Post;

      RefreshRelacionados;
    end;
  end;
end;

procedure TdmSicsCadAlarmes.cdsAlarmesID_PIACAODEALARMEValidate(
  Sender: TField);
begin
 	while not cdsAlarmesRelacionados.IsEmpty do
  begin
    cdsAlarmesRelacionados.Delete;
  end;

	RefreshRelacionados;
end;


procedure TdmSicsCadAlarmes.cdsAlarmesAfterInsert(DataSet: TDataSet);
begin
	Dec(FIdAlarmeSeq);

  DataSet.FieldByName('ID_PIALARME'      ).AsInteger := FIdAlarmeSeq;
  DataSet.FieldByName('SUPERIOR'         ).AsBoolean := True;
  DataSet.FieldByName('ID_PIACAODEALARME').AsInteger := 0;
end;

procedure TdmSicsCadAlarmes.cdsAlarmesBeforeDelete(DataSet: TDataSet);
begin
  with cdsAlarmesRelacionados do
		while not IsEmpty do Delete;
end;

procedure TdmSicsCadAlarmes.cdsMonitoramentosBeforePost(DataSet: TDataSet);
begin
  if cdsMonitoramentos.FieldByName('ID_PI').IsNull then
  begin
    FUltimoIDPI := FUltimoIDPI + 1;
    cdsMonitoramentos.FieldByName('ID_PI').AsInteger := FUltimoIDPI;
  end;

  FUltimoIDPI := cdsMonitoramentos.FieldByName('ID_PI').AsInteger;

  if cdsMonitoramentos.FieldByName('ID_PIHORARIO').IsNull then
    raise Exception.Create('Horário não informado');
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

procedure TdmSicsCadAlarmes.cdsAlarmesCalcFields(DataSet: TDataSet);
begin
  with DataSet do
  begin
    if (not FieldByName('ID_PINIVEL').IsNull) and cdsNiveis.Locate('ID_PINIVEL', FieldByName('ID_PINIVEL').Value, []) then
      FieldByName('INTCALC_POSICAONIVEL').Value := cdsNiveis.FieldByName('POSICAO').Value;
  end;
end;

procedure TdmSicsCadAlarmes.Inicializar;
begin
  inherited;

  cdsHorarios.Close;
  cdsPIS.Close;
  cdsAcoesAlarmes.Close;
  cdsNiveis.Close;
  cdsEmails.Close;
  cdsCelulares.Close;
  cdsGruposPas.Close;
  cdsPaineis.Close;
  cdsMonitoramentos.Close;

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

end.
