unit repGraphBase;

interface 
{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  Qrctrls, quickrpt, qrprntr,
  System.UITypes, System.Types, System.SysUtils, System.Classes, System.Variants, Data.DB, System.Rtti,
  Data.Bind.EngExt, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope, Vcl.Controls, Vcl.Graphics;

type
  TqrSicsGraphicBase = class(TQuickRep)
    QrImageChart: TQRImage;
    procedure DetailReportPreview(Sender: TObject); Virtual;
  protected
    function GetDataSet: TDataSet; virtual;
    procedure SetDataSet(const Value: TDataSet); virtual;
    procedure AtualizarDataSetDB;
    procedure CreateReport(CompositeReport : boolean); Override;
  public
  ///  class procedure Preview(AQuickReport: TQuickRep; AQrPrinter: TQrPrinter); Virtual; abstract;
  published
    property DataSet : TDataSet read GetDataSet write SetDataSet;
  end;

implementation

{$R *.dfm}

procedure TqrSicsGraphicBase.AtualizarDataSetDB;
var
  i: Integer;
  LCompTmp: TComponent;
begin
  for i := 0 to self.ComponentCount -1 do
  begin
    LCompTmp := self.Components[i];
    if not Assigned(LCompTmp) then
      Continue;

    if ((LCompTmp is TQRDBText) and (TQRDBText(LCompTmp).DataSet = nil)) then
      TQRDBText(LCompTmp).DataSet := DataSet
    else
    if ((LCompTmp is TQRDBImage) and (TQRDBImage(LCompTmp).DataSet = nil)) then
      TQRDBImage(LCompTmp).DataSet := DataSet
    else
    if ((LCompTmp is TQRDBRichText) and (TQRDBRichText(LCompTmp).DataSet = nil)) then
      TQRDBRichText(LCompTmp).DataSet := DataSet
    else
    if ((LCompTmp is TQRDBCalc) and Assigned(TQRDBCalc(LCompTmp).DataSource) and (TQRDBCalc(LCompTmp).DataSource.DataSet = nil)) then
      TQRDBCalc(LCompTmp).DataSource.DataSet := DataSet;
  end;
end;

procedure TqrSicsGraphicBase.CreateReport(CompositeReport: boolean);
begin
  if (Assigned(DataSet) and (DataSet.Active)) then
    DataSet.DisableControls;
  try
    inherited;
  finally
    if (Assigned(DataSet) and (DataSet.Active)) then
      DataSet.EnableControls;
  end;
end;

procedure TqrSicsGraphicBase.DetailReportPreview(Sender: TObject);
begin
  if (Assigned(DataSet) and (DataSet.Active)) then
    Self.DataSet.DisableControls;
  try
    Self.Preview;//(Self, (Sender as TQRPrinter));
  finally
    if (Assigned(DataSet) and (DataSet.Active)) then
      Self.DataSet.EnableControls;
  end;
end;

function TqrSicsGraphicBase.GetDataSet: TDataSet;
begin
  Result := inherited DataSet;
end;

procedure TqrSicsGraphicBase.SetDataSet(const Value: TDataSet);
var
  LModificouDataSet: Boolean;
begin
  LModificouDataSet := DataSet <> Value;
  inherited DataSet := Value;
  if LModificouDataSet then
    AtualizarDataSetDB;
end;

end.
