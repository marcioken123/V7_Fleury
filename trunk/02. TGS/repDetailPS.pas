unit repDetailPS;

interface
{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  Qrctrls, quickrpt, qrprntr, repGraphBase, repDetailBase,
  System.UITypes, System.Types, System.SysUtils, System.Classes, System.Variants, Data.DB, System.Rtti,
  Data.Bind.EngExt, Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope, Vcl.Graphics, Vcl.Controls, Vcl.ExtCtrls;

type
  TqrSicsDetailPS = class(TqrSicsDetailBase)
    DetailBand1: TQRBand;
    dbSenha: TQRDBText;
    dbAlternativa: TQRDBText;
    dbProntuario: TQRDBText;
    PageHeaderBand1: TQRBand;
    QRLabel2: TQRLabel;
    QRImage1: TQRImage;
    QRSysData1: TQRSysData;
    DateTimeLabel: TQRSysData;
    QRLabel6: TQRLabel;
    QRLabel5: TQRLabel;
    PeriodoDoRelatorioLabel: TQRLabel;
    PeriodoDoDiaLabel: TQRLabel;
    dbCliente: TQRDBText;
    dbDataHora: TQRDBText;
    lblAlternativa: TQRLabel;
    lblCliente: TQRLabel;
    lblDataHora: TQRLabel;
    lblProntuario: TQRLabel;
    lblSenha: TQRLabel;
    lblAlternativas: TQRLabel;
    lblAlternativasVal: TQRLabel;
    QRDBText1: TQRDBText;
    QRLabel1: TQRLabel;
    QRDBText2: TQRDBText;
  private
    { Private declarations }
  public
  end;

implementation

{$R *.dfm}

end.
