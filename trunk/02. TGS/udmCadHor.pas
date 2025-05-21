unit udmCadHor;

interface
{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  SysUtils, Classes, udmCadBase, Data.FMTBcd, Datasnap.Provider, Data.DB, Datasnap.DBClient,MyAspFuncoesUteis,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, 
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, 
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.DBX.Migrate, uDataSetHelper;

type
  TdmSicsCadHor = class(TdmSicsCadBase)
    cdsCadHor: TClientDataSet;
    dspCadHor: TDataSetProvider;
    qryCadHor: TFDQuery;
    cdsCadHorID_PIHORARIO: TSmallintField;
    cdsCadHorNOME: TStringField;
    cdsCadHorHORAINICIO: TTimeField;
    cdsCadHorHORAFIM: TTimeField;
    cdsCadHorDOMINGO: TStringField;
    cdsCadHorSEGUNDAFEIRA: TStringField;
    cdsCadHorTERCAFEIRA: TStringField;
    cdsCadHorQUARTAFEIRA: TStringField;
    cdsCadHorQUINTAFEIRA: TStringField;
    cdsCadHorSEXTAFEIRA: TStringField;
    cdsCadHorSABADO: TStringField;
    cdsMonitoramentos: TClientDataSet;
    cdsMonitoramentosID_PIMONITORAMENTO: TSmallintField;
    cdsMonitoramentosID_PIHORARIO: TSmallintField;
    cdsMonitoramentosID_PI: TSmallintField;
    dspMonitoramentos: TDataSetProvider;
    qryMonitoramentos: TFDQuery;
    cdsCadHorID_UNIDADE: TIntegerField;
    procedure cdsCadHorReconcileError(DataSet: TCustomClientDataSet;
      E: EReconcileError; UpdateKind: TUpdateKind;
      var Action: TReconcileAction);
    procedure cdsCadHorBeforeInsert(DataSet: TDataSet);
    procedure cdsCadHorAfterInsert(DataSet: TDataSet);
  private
    FLastId: Integer;
  public
    procedure Inicializar; Override;
    function PossuiModificacoes: Boolean;
    destructor Destroy; Override;
  end;

implementation

uses
  untCommonDMUnidades, untMainForm;


{$R *.dfm}

procedure TdmSicsCadHor.cdsCadHorReconcileError(DataSet: TCustomClientDataSet;
  E: EReconcileError; UpdateKind: TUpdateKind;
  var Action: TReconcileAction);
begin
  MyLogException(E);
end;

destructor TdmSicsCadHor.Destroy;
begin

  inherited;
end;

procedure TdmSicsCadHor.cdsCadHorBeforeInsert(DataSet: TDataSet);
begin
  DataSet.Last;
  FLastId := DataSet.FieldByName('ID_PIHORARIO').AsInteger;
end;

procedure TdmSicsCadHor.cdsCadHorAfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID_PIHORARIO').AsInteger := FLastId + 1;
  DataSet.FieldByName('ID_UNIDADE').AsInteger := dmUnidades.IdUnidadeConformePosicaoNaLista(untMainForm.MainForm.cbbUnidadeAtiva.ItemIndex+1)
end;

procedure TdmSicsCadHor.Inicializar;
begin
  inherited;
  cdsCadHor.Close;
  cdsCadHor.Open;
end;

function TdmSicsCadHor.PossuiModificacoes: Boolean;
begin
  Result := ModificouDataSet(cdsCadHor);
end;

end.
