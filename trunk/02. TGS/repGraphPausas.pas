unit repGraphPausas;

interface
{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  Qrctrls, quickrpt, qrprntr, repGraphBase,
  System.UITypes, System.Types, System.SysUtils, System.Classes, System.Variants, Data.DB, System.Rtti,
  Data.Bind.EngExt, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope, Vcl.Graphics, Vcl.Controls, Vcl.ExtCtrls,
  VclTee.TeeGDIPlus, VCLTee.TeEngine, VCLTee.TeeProcs, VCLTee.Chart;

type
  TqrSicsGraphicPausas = class(TqrSicsGraphicBase)
    DetailBand: TQRBand;
    ColumnHeaderBand: TQRBand;
    QtdPausasDBText: TQRDBText;
    ItemDBText: TQRDBText;
    TMPDBText: TQRDBText;
    PageHeaderBand: TQRBand;
    QRLabel2: TQRLabel;
    QRImage1: TQRImage;
    QRLabel3: TQRLabel;
    QRLabel5: TQRLabel;
    QRLabel6: TQRLabel;
    AtendantsLabel: TQRLabel;
    PeriodoDoRelatorioLabel: TQRLabel;
    PeriodoDoDiaLabel: TQRLabel;
    QRSysData1: TQRSysData;
    DateTimeLabel: TQRSysData;
    ItemLabel: TQRLabel;
    QtdPausasLabel: TQRLabel;
    TMPLabel: TQRLabel;
    PswdGroup: TQRGroup;
    SummaryBand: TQRBand;
    TotaisQtdPausasLabel: TQRLabel;
    TotaisTMPLabel: TQRLabel;
    QRLabel1: TQRLabel;
    PAsLabel: TQRLabel;
    QRLabel8: TQRLabel;
    DurationLabel: TQRLabel;
    UnidadeLabel: TQRLabel;
    lblRelatorio: TQRLabel;
    lblMultiUnidades: TQRLabel;
    lblMultiUnidadesVal: TQRLabel;
    qrlblSlaDescricao: TQRLabel;
    qrlblPausasPercVerde: TQRLabel;
    qrlblPausasPercAmarelo: TQRLabel;
    qrlblPausasPercVermelho: TQRLabel;
    qrlblPausasPercCinza: TQRLabel;
    qrlblSlaPausas: TQRLabel;
    qrShapeSlaPausas: TQRShape;
    qrdbtextPausasPercVerde: TQRDBText;
    qrdbtextPausasPercAmarelo: TQRDBText;
    qrdbtextPausasPercVermelho: TQRDBText;
    qrdbtextPausasPercCinza: TQRDBText;
    qrdbtextSlaDescricao: TQRDBText;
    QRLabel10: TQRLabel;
    MotivosPausaLabel: TQRLabel;
    QtdLoginsLabel: TQRLabel;
    TMLLabel: TQRLabel;
    QtdLoginsDBText: TQRDBText;
    TMLDBText: TQRDBText;
    QRLabel4: TQRLabel;
    QRLabel7: TQRLabel;
    QRLabel9: TQRLabel;
    QRLabel11: TQRLabel;
    qrlblSlaLogins: TQRLabel;
    QRShape1: TQRShape;
    TotaisQtdLoginsLabel: TQRLabel;
    TotaisTMLLabel: TQRLabel;
  end;

implementation

{$R *.dfm}


end.
