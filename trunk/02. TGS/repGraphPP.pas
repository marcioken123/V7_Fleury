unit repGraphPP;

interface
{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  Qrctrls, quickrpt, qrprntr,
   repGraphBase,
  System.UITypes, System.Types, System.SysUtils, System.Classes, System.Variants, Data.DB, System.Rtti,
  Data.Bind.EngExt, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope, Vcl.Graphics, Vcl.Controls, Vcl.ExtCtrls, VclTee.TeeGDIPlus, VCLTee.TeEngine,
  VCLTee.TeeProcs, VCLTee.Chart;

type
  TqrSicsGraphicPP = class(TqrSicsGraphicBase)
    DetailBand: TQRBand;
    ColumnHeaderBand: TQRBand;
    QtdEDBText: TQRDBText;
    ItemDBText: TQRDBText;
    TMEDBText: TQRDBText;
    PageHeaderBand: TQRBand;
    QRLabel2: TQRLabel;
    QRImage1: TQRImage;
    QRLabel3: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel5: TQRLabel;
    QRLabel6: TQRLabel;
    AtendantsLabel: TQRLabel;
    SenhasLabel: TQRLabel;
    PeriodoDoRelatorioLabel: TQRLabel;
    PeriodoDoDiaLabel: TQRLabel;
    QRSysData1: TQRSysData;
    DateTimeLabel: TQRSysData;
    ItemLabel: TQRLabel;
    QtdELabel: TQRLabel;
    TMELabel: TQRLabel;
    PswdGroup: TQRGroup;
    SummaryBand: TQRBand;
    TotaisQtdELabel: TQRLabel;
    TotaisTMELabel: TQRLabel;
    QRLabel1: TQRLabel;
    PAsLabel: TQRLabel;
    QRLabel8: TQRLabel;
    DurationLabel: TQRLabel;
    UnidadeLabel: TQRLabel;
    lblRelatorio: TQRLabel;
    QRLabel7: TQRLabel;
    AtendantsFimLabel: TQRLabel;
    lblMultiUnidades: TQRLabel;
    lblMultiUnidadesVal: TQRLabel;
    QRLabel9: TQRLabel;
    PAsFimLabel: TQRLabel;
    qrlblSlaDescricao: TQRLabel;
    qrlblPPPercVerde: TQRLabel;
    qrlblPPPercAmarelo: TQRLabel;
    qrlblPPPercVermelho: TQRLabel;
    qrlblPPPercCinza: TQRLabel;
    qrlblSlaPP: TQRLabel;
    qrShapeSlaPP: TQRShape;
    qrdbtextPPPercVerde: TQRDBText;
    qrdbtextPPPercAmarelo: TQRDBText;
    qrdbtextPPPercVermelho: TQRDBText;
    qrdbtextPPPercCinza: TQRDBText;
    qrdbtextSlaDescricao: TQRDBText;
    QRLabel10: TQRLabel;
    TiposPPLabel: TQRLabel;
    QRLabel12: TQRLabel;
    TagsLabel: TQRLabel;
  end;

implementation

{$R *.dfm}



end.
