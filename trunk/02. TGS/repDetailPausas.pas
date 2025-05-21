unit repDetailPausas;

interface
{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  Qrctrls, quickrpt, qrprntr, repGraphBase, Vcl.Graphics, Vcl.Controls, Vcl.ExtCtrls,
  System.UITypes, System.Types, System.SysUtils, System.Classes, System.Variants, Data.DB, System.Rtti,
  Data.Bind.EngExt, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope;

type
  TqrSicsDetailPausas = class(TqrSicsGraphicBase)
    DetailBand1: TQRBand;
    ColumnHeaderBand1: TQRBand;
    dbAtendente: TQRDBText;
    dbInicio: TQRDBText;
    dbTermino: TQRDBText;
    dbDuracao: TQRDBText;
    PageHeaderBand1: TQRBand;
    QRLabel2: TQRLabel;
    QRImage1: TQRImage;
    QRSysData1: TQRSysData;
    DateTimeLabel: TQRSysData;
    lblAtendente: TQRLabel;
    lblInicio: TQRLabel;
    lblTermino: TQRLabel;
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
    QRLabel14: TQRLabel;
    QRLabel15: TQRLabel;
    AtendantsLabel: TQRLabel;
    PAsLabel: TQRLabel;
    lblRelatorio: TQRLabel;
    UnidadeLabel: TQRLabel;
    lblMultiUnidades: TQRLabel;
    lblMultiUnidadesVal: TQRLabel;
    QRLabel1: TQRLabel;
    MotivosPausaLabel: TQRLabel;
    qrgrpUnidade: TQRGroup;
    QRDBText2: TQRDBText;
    QRLabel8: TQRLabel;
    QRLabel9: TQRLabel;
    QRLabel17: TQRLabel;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText5: TQRDBText;
    lblEvento: TQRLabel;
    dbEvento: TQRDBText;
    lblMotivoPausa: TQRLabel;
    dbMotivoPausa: TQRDBText;
    procedure QRDBText3Print(sender: TObject; var Value: String);
    procedure QRDBText4Print(sender: TObject; var Value: String);
    procedure QRDBText5Print(sender: TObject; var Value: String);
  private
    { Private declarations }
  public
    StrListUnidadesAtds: TStringList;
    StrListUnidadesPAs: TStringList;
    StrListUnidadesMotivosPausa: TStringList;

    procedure AlinharLabels;
	constructor Create(aOwner: TComponent); Override;
	destructor Destroy; Override;

  end;

implementation

{$R *.dfm}

constructor TqrSicsDetailPausas.Create(aOwner: TComponent);
begin
  inherited;
  StrListUnidadesAtds := TStringList.Create;
  StrListUnidadesPAs := TStringList.Create;
  StrListUnidadesMotivosPausa := TStringList.Create;
end;

destructor TqrSicsDetailPausas.Destroy;
begin
  FreeAndNil(StrListUnidadesAtds);
  FreeAndNil(StrListUnidadesPAs);
  FreeAndNil(StrListUnidadesMotivosPausa);
  inherited;
end;

procedure TqrSicsDetailPausas.AlinharLabels;
const
  OFF = 6;
var
  Labels: array[1..7] of TQRLabel;
  DBTexts: array[1..7] of TQRDBText;
  i, iLastLeft: integer;
  QtdColunasDeLarguraFixa, QtdColunasDeLarguraVariavel, LarguraPadrao : integer;
begin
  Labels[1] := lblEvento;
  DBTexts[1] := dbEvento;

  Labels[2] := lblMotivoPausa;
  DBTexts[2] := dbMotivoPausa;

  Labels[3] := lblPA;
  DBTexts[3] := dbPA;

  Labels[4] := lblAtendente;
  DBTexts[4] := dbAtendente;

  Labels[5] := lblInicio;
  DBTexts[5] := dbInicio;

  Labels[6] := lblTermino;
  DBTexts[6] := dbTermino;

  Labels[7] := lblDuracao;
  DBTexts[7] := dbDuracao;

  //Calcula largura das colunas, de acordo com as que estão ou não visíveis
  QtdColunasDeLarguraFixa     := 4;  //EVENTO, INICIO, TERMINO, DURACAO
  QtdColunasDeLarguraVariavel := 3;  //MOTIVO, PA e ATD

  LarguraPadrao := (ColumnHeaderBand1.ClientWidth - lblEvento.Width - lblInicio.Width - lblTermino.Width - lblDuracao.Width -
                   (QtdColunasDeLarguraVariavel + QtdColunasDeLarguraFixa - 1) * OFF) div QtdColunasDeLarguraVariavel;

  for i := Low(Labels) to High(Labels) do
    if i in [2, 3, 4] then  //indices no array dos campos que variam sua largura
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
end;

procedure TqrSicsDetailPausas.QRDBText3Print(sender: TObject; var Value: String);
begin
  Value := StrListUnidadesAtds.Values[Value];
end;

procedure TqrSicsDetailPausas.QRDBText4Print(sender: TObject; var Value: String);
begin
  Value := StrListUnidadesPAs.Values[Value];
end;

procedure TqrSicsDetailPausas.QRDBText5Print(sender: TObject; var Value: String);
begin
   Value := StrListUnidadesMotivosPausa.Values[Value];
end;

end.
