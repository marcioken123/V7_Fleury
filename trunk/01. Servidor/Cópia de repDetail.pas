unit repDetail;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Qrctrls, quickrpt, qrprntr, DB, DBTables, ExtCtrls, Sics_95;

type
  TDetailReport = class(TQuickRep)
    DetailBand1: TQRBand;
    ColumnHeaderBand1: TQRBand;
    DBlblAtendente: TQRDBText;
    DBlblCliente: TQRDBText;
    DBlblSenha: TQRDBText;
    QRDBText6: TQRDBText;
    QRDBText7: TQRDBText;
    QRDBText8: TQRDBText;
    PageHeaderBand1: TQRBand;
    QRLabel2: TQRLabel;
    QRImage1: TQRImage;
    QRSysData1: TQRSysData;
    DateTimeLabel: TQRSysData;
    lblTipo: TQRLabel;
    lblAtendente: TQRLabel;
    lblSenha: TQRLabel;
    QRLabel10: TQRLabel;
    QRLabel11: TQRLabel;
    QRLabel12: TQRLabel;
    PswdGroup: TQRGroup;
    lblPA: TQRLabel;
    DBlblPA: TQRDBText;
    QRLabel3: TQRLabel;
    QRLabel6: TQRLabel;
    QRLabel5: TQRLabel;
    PeriodoDoRelatorioLabel: TQRLabel;
    PeriodoDoDiaLabel: TQRLabel;
    DurationLabel: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel14: TQRLabel;
    QRLabel15: TQRLabel;
    AtendantsLabel: TQRLabel;
    PAsLabel: TQRLabel;
    SenhasLabel: TQRLabel;
    lblRelatorio: TQRLabel;
    UnidadeLabel: TQRLabel;
    lblCliente: TQRLabel;
    DBlblTipo: TQRDBText;
    lblMultiUnidades: TQRLabel;
    lblMultiUnidadesVal: TQRLabel;
    QRLabel1: TQRLabel;
    FilasLabel: TQRLabel;
    QRLabel7: TQRLabel;
    QRDBText1: TQRDBText;
    procedure DetailReportPreview(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DetailReport: TDetailReport;

implementation

{$R *.DFM}

uses
  repPrview;

procedure TDetailReport.DetailReportPreview(Sender: TObject);
begin
  DetailReport.DataSet.DisableControls;
  TrepPreviewForm.Preview(DetailReport, TQRPrinter(Sender));
end;

end.
