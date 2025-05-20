unit udmCadHor;

interface

uses
  SysUtils, Classes, udmCadBase, Data.FMTBcd, Datasnap.Provider, Data.DB, Datasnap.DBClient,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, uDataSetHelper,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf;

{$INCLUDE ..\AspDefineDiretivas.inc}

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
    cdsCadHorID_UNIDADE: TIntegerField;
    procedure cdsCadHorReconcileError(DataSet: TCustomClientDataSet;
      E: EReconcileError; UpdateKind: TUpdateKind;
      var Action: TReconcileAction);
    procedure cdsCadHorBeforeInsert(DataSet: TDataSet);
    procedure cdsCadHorAfterInsert(DataSet: TDataSet);
    procedure cdsCadHorAfterApplyUpdates(Sender: TObject;
      var OwnerData: OleVariant);
  private
    FLastId: Integer;
  public
    procedure Inicializar; Override;
  end;

var
  dmSicsCadHor: TdmSicsCadHor;

implementation


{$R *.dfm}

procedure TdmSicsCadHor.cdsCadHorReconcileError(DataSet: TCustomClientDataSet;
  E: EReconcileError; UpdateKind: TUpdateKind;
  var Action: TReconcileAction);
begin
  OnReconcileError(DataSet, E, UpdateKind, Action);
end;

procedure TdmSicsCadHor.cdsCadHorBeforeInsert(DataSet: TDataSet);
begin
  DataSet.Last;
  FLastId := DataSet.FieldByName('ID_PIHORARIO').AsInteger;
end;

procedure TdmSicsCadHor.cdsCadHorAfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('ID_PIHORARIO').AsInteger := FLastId + 1;
end;

procedure TdmSicsCadHor.cdsCadHorAfterApplyUpdates(Sender: TObject;
  var OwnerData: OleVariant);
begin
  AtualizarTabelasPis;
end;

procedure TdmSicsCadHor.Inicializar;
begin
  inherited;

	cdsCadHor.Open;
end;

end.
