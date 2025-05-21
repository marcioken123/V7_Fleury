unit repDetailPP;

interface
{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  Qrctrls, quickrpt, qrprntr, repGraphBase, repDetailBase,
  System.UITypes, System.Types, System.SysUtils, System.Classes, System.Variants, Data.DB, System.Rtti,
  Data.Bind.EngExt, Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope, Vcl.Graphics, Vcl.Controls, Vcl.ExtCtrls;
  
type
  TqrSicsDetailPP = class(TqrSicsDetailBase)
    DetailBand1: TQRBand;
    ColumnHeaderBand1: TQRBand;
    dbAtendente: TQRDBText;
    dbCliente: TQRDBText;
    dbSenha: TQRDBText;
    dbInicio: TQRDBText;
    dbTermino: TQRDBText;
    dbDuracao: TQRDBText;
    PageHeaderBand1: TQRBand;
    QRLabel2: TQRLabel;
    QRImage1: TQRImage;
    QRSysData1: TQRSysData;
    DateTimeLabel: TQRSysData;
    lblAtendente: TQRLabel;
    lblSenha: TQRLabel;
    lblInicioFim: TQRLabel;
    lblDuracao: TQRLabel;
    PswdGroup: TQRGroup;
    lblPA: TQRLabel;
    dbPA: TQRDBText;
    QRLabel3: TQRLabel;
    QRLabel6: TQRLabel;
    QRLabel5: TQRLabel;
    PeriodoDoRelatorioLabel: TQRLabel;
    PeriodoDoDiaLabel: TQRLabel;
    DurationLabel: TQRLabel;
    QRLabel4: TQRLabel;
    SenhasLabel: TQRLabel;
    lblRelatorio: TQRLabel;
    UnidadeLabel: TQRLabel;
    lblCliente: TQRLabel;
    dbTipoSenha: TQRDBText;
    lblMultiUnidades: TQRLabel;
    lblMultiUnidadesVal: TQRLabel;
    qrgrpUnidade: TQRGroup;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    lblTipoPP: TQRLabel;
    lblTipoSenha: TQRLabel;
    dbTipoPP: TQRDBText;
    QRLabel11: TQRLabel;
    AtendantsLabel: TQRLabel;
    QRLabel13: TQRLabel;
    PAsLabel: TQRLabel;
    QRLabel18: TQRLabel;
    AtendantsFimLabel: TQRLabel;
    QRLabel19: TQRLabel;
    PAsFimLabel: TQRLabel;
    QRLabel20: TQRLabel;
    TiposPPLabel: TQRLabel;
    QRLabel21: TQRLabel;
    TagsLabel: TQRLabel;
    QRLabel1: TQRLabel;
    QRLabel7: TQRLabel;
    QRLabel14: TQRLabel;
    QRLabel15: TQRLabel;
    QRLabel23: TQRLabel;
    QRLabel24: TQRLabel;
    QRDBText1: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText5: TQRDBText;
    QRDBText6: TQRDBText;
    QRDBText7: TQRDBText;
    lblTags: TQRLabel;
    dbTags: TQRDBText;
    dbPaFim: TQRDBText;
    dbAtdFim: TQRDBText;
    procedure QRDBText3Print(sender: TObject; var Value: String); Override;
    procedure QRDBText4Print(sender: TObject; var Value: String); Override;
    procedure QRDBText5Print(sender: TObject; var Value: String); Override;
    procedure QRDBText1Print(sender: TObject; var Value: String); Override;
  private
    { Private declarations }
  public
    procedure AlinharLabels; Override;
  end;

implementation

{$R *.dfm}



procedure TqrSicsDetailPP.AlinharLabels;
const
  OFF = 6;
var
  Labels: array[1..9] of TQRLabel;
  DBTexts: array[1..9] of TQRDBText;
  i, iLastLeft: integer;
  QtdColunasDeLarguraFixa, QtdColunasDeLarguraVariavel, LarguraPadrao : integer;
begin
  Labels[1] := lblSenha;
  DBTexts[1] := dbSenha;

  Labels[2] := lblCliente;
  DbTexts[2] := dbCliente;

  Labels[3] := lblTipoSenha;
  DBTexts[3] := dbTipoSenha;

  Labels[4] := lblTipoPP;
  DBTexts[4] := dbTipoPP;

  Labels[5] := lblPA;
  DBTexts[5] := dbPA;

  Labels[6] := lblAtendente;
  DBTexts[6] := dbAtendente;

  Labels[7] := lblInicioFim;
  DBTexts[7] := dbInicio;

  Labels[8] := lblDuracao;
  DBTexts[8] := dbDuracao;

  Labels[9] := lblTags;
  DBTexts[9] := dbTags;

  //Calcula largura das colunas, de acordo com as que estão ou não visíveis
  QtdColunasDeLarguraFixa     := 3;  //SENHA, INICIO/FIM, DURACAO
  QtdColunasDeLarguraVariavel := 3;  //PP, PA e ATD
  if lblCliente  .Visible then QtdColunasDeLarguraVariavel := QtdColunasDeLarguraVariavel + 1;
  if lblTipoSenha.Visible then QtdColunasDeLarguraVariavel := QtdColunasDeLarguraVariavel + 1;
  if lblTags     .Visible then QtdColunasDeLarguraVariavel := QtdColunasDeLarguraVariavel + 1;

  LarguraPadrao := (ColumnHeaderBand1.ClientWidth - lblSenha.Width - lblInicioFim.Width - lblDuracao.Width -
                    (QtdColunasDeLarguraVariavel + QtdColunasDeLarguraFixa - 1) * OFF) div QtdColunasDeLarguraVariavel;

  for i := Low(Labels) to High(Labels) do
    if i in [2, 3, 4, 5, 6, 9] then  //indices no array dos campos que variam sua largura
    begin
      Labels [i].Width := LarguraPadrao;
      DBTexts[i].Width := LarguraPadrao;
    end;

  //Posiciona as colunas horizontalmente
  iLastLeft := 0;
  for i := Low(Labels) to High(Labels) do
  begin
    if not Labels[i].Visible then
    begin
      Labels[i].Enabled := False;
      DBTexts[i].Enabled := False;
    end
    else
    begin
      Labels[i].Enabled := True;
      DBTexts[i].Enabled := True;
      Labels[i].Left := iLastLeft;
      DBTexts[i].Left := iLastLeft;
      iLastLeft := iLastLeft + Labels[i].Width + OFF;
    end;
  end;

  //Posiciona dbTexts que são alinhados na linha de baixo
  dbPaFim  .Left  := dbPA.Left;
  dbPaFim  .Width := dbPA.Width;
  dbAtdFim .Left  := dbAtendente.Left;
  dbAtdFim .Width := dbAtendente.Width;
  dbTermino.Left  := dbInicio.Left;
  dbTermino.Width := dbInicio.Width
end;

procedure TqrSicsDetailPP.QRDBText3Print(sender: TObject; var Value: String);
begin
  Value := StrListUnidadesAtds.Values[Value];
end;

procedure TqrSicsDetailPP.QRDBText4Print(sender: TObject; var Value: String);
begin
  Value := StrListUnidadesPAs.Values[Value];
end;

procedure TqrSicsDetailPP.QRDBText5Print(sender: TObject; var Value: String);
begin
   Value := StrListUnidadesFilas.Values[Value];
end;

procedure TqrSicsDetailPP.QRDBText1Print(sender: TObject; var Value: String);
begin
   Value := StrListUnidadesTags.Values[Value];
end;

end.
