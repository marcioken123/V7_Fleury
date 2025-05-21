unit repGraphTotem;

interface
{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  Qrctrls, quickrpt, qrprntr, repGraphBase,
  System.UITypes, System.Types, System.SysUtils, System.Classes, System.Variants, Data.DB, System.Rtti,
  Data.Bind.EngExt, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope, Vcl.Graphics, Vcl.Controls, Vcl.ExtCtrls,
  VclTee.TeeGDIPlus, VCLTee.TeEngine, VCLTee.TeeProcs, VCLTee.Chart, VCLTee.Series;

type
  TqrSicsGraphicTotem = class(TqrSicsGraphicBase)
    DetailBand: TQRBand;
    ColumnHeaderBand: TQRBand;
    QtdEDBText: TQRDBText;
    ItemDBText: TQRDBText;
    TMEDBText: TQRDBText;
    QtdADBText: TQRDBText;
    TMADBText: TQRDBText;
    PageHeaderBand: TQRBand;
    QRLabel2: TQRLabel;
    QRImage1: TQRImage;
    qrlAtendentes: TQRLabel;
    qrlSenhas: TQRLabel;
    qrlPeriodo: TQRLabel;
    qrlHorario: TQRLabel;
    AtendantsLabel: TQRLabel;
    SenhasLabel: TQRLabel;
    PeriodoDoRelatorioLabel: TQRLabel;
    PeriodoDoDiaLabel: TQRLabel;
    QRSysData1: TQRSysData;
    DateTimeLabel: TQRSysData;
    ItemLabel: TQRLabel;
    QtdELabel: TQRLabel;
    TMELabel: TQRLabel;
    QtdALabel: TQRLabel;
    TMALabel: TQRLabel;
    PswdGroup: TQRGroup;
    SummaryBand: TQRBand;
    TotaisQtdELabel: TQRLabel;
    TotaisTMELabel: TQRLabel;
    TotaisQtdALabel: TQRLabel;
    TotaisTMALabel: TQRLabel;
    qrlPas: TQRLabel;
    PAsLabel: TQRLabel;
    qrlDuracao: TQRLabel;
    DurationLabel: TQRLabel;
    UnidadeLabel: TQRLabel;
    lblRelatorio: TQRLabel;
    qrlFilas: TQRLabel;
    FilasLabel: TQRLabel;
    lblMultiUnidades: TQRLabel;
    lblMultiUnidadesVal: TQRLabel;
    qrlTotens: TQRLabel;
    TotensLabel: TQRLabel;
    qrlblSlaDescricao: TQRLabel;
    qrlblEspPercVerde: TQRLabel;
    qrlblEspPercAmarelo: TQRLabel;
    qrlblEspPercVermelho: TQRLabel;
    qrlblEspPercCinza: TQRLabel;
    qrlblAtdPercCinza: TQRLabel;
    qrlblAtdPercVermelho: TQRLabel;
    qrlblAtdPercAmarelo: TQRLabel;
    qrlblAtdPercVerde: TQRLabel;
    qrlblSlaAtendimento: TQRLabel;
    qrlblSlaEspera: TQRLabel;
    qrShapeSlaEspera: TQRShape;
    qrShapeSlaAtendimento: TQRShape;
    qrdbtextEspPercVerde: TQRDBText;
    qrdbtextEspPercAmarelo: TQRDBText;
    qrdbtextEspPercVermelho: TQRDBText;
    qrdbtextEspPercCinza: TQRDBText;
    qrdbtextAtdPercVerde: TQRDBText;
    qrdbtextAtdPercAmarelo: TQRDBText;
    qrdbtextAtdPercVermelho: TQRDBText;
    qrdbtextAtdPercCinza: TQRDBText;
    qrdbtextSlaDescricao: TQRDBText;
    qrlFluxos: TQRLabel;
    FluxosLabel: TQRLabel;
  end;


implementation

{$R *.dfm}
end.
