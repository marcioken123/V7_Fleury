unit repDetailTotem;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  repDetailBase,
  Windows, Messages, SysUtils, Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Qrctrls, quickrpt, qrprntr, DB, DBTables, Vcl.ExtCtrls;

type
  TqrSicsDetailTotem = class(TqrSicsDetailBase)
    DetailBand1: TQRBand;
    ColumnHeaderBand1: TQRBand;
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
    lblSenha: TQRLabel;
    lblInicio: TQRLabel;
    lblTermino: TQRLabel;
    lblDuracao: TQRLabel;
    PswdGroup: TQRGroup;
    qrlDuracao: TQRLabel;
    qrlHorario: TQRLabel;
    qrlPeriodo: TQRLabel;
    PeriodoDoRelatorioLabel: TQRLabel;
    PeriodoDoDiaLabel: TQRLabel;
    DurationLabel: TQRLabel;
    qrlSenhas: TQRLabel;
    qrlPas: TQRLabel;
    qrlAtendente: TQRLabel;
    AtendantsLabel: TQRLabel;
    PAsLabel: TQRLabel;
    SenhasLabel: TQRLabel;
    lblRelatorio: TQRLabel;
    UnidadeLabel: TQRLabel;
    lblCliente: TQRLabel;
    dbTipo: TQRDBText;
    qrlMultiUnidades: TQRLabel;
    lblMultiUnidadesVal: TQRLabel;
    qrlFilas: TQRLabel;
    FilasLabel: TQRLabel;
    qrgrpUnidade: TQRGroup;
    QRDBText2: TQRDBText;
    QRLabel8: TQRLabel;
    QRLabel9: TQRLabel;
    QRLabel17: TQRLabel;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText5: TQRDBText;
    lblEvento: TQRLabel;
    lblTipo: TQRLabel;
    dbEvento: TQRDBText;
    qrlFluxos: TQRLabel;
    qrlTotens: TQRLabel;
    TotensLabel: TQRLabel;
    FluxosLabel: TQRLabel;
    procedure DetailReportPreview(Sender: TObject); Override;
    procedure QRDBText3Print(sender: TObject; var Value: String); override;
    procedure QRDBText4Print(sender: TObject; var Value: String); override;
    procedure QRDBText5Print(sender: TObject; var Value: String); override;
    procedure QRDBText1Print(sender: TObject; var Value: String); override;
  private
    { Private declarations }
  public
    procedure AlinharLabels; override;
  end;

implementation

{$R *.DFM}

uses
  repPrview,
  Sics_Common_Parametros;

procedure TqrSicsDetailTotem.AlinharLabels;
const
  OFF = 6;

var
  Labels: array[1..11] of TQRLabel;
  DBTexts: array[1..11] of TQRDBText;
  i, iLastLeft: integer;
  QtdColunasDeLarguraFixa, QtdColunasDeLarguraVariavel, LarguraPadrao : integer;
begin
  {if vgParametrosModulo.ModoCallCenter then
  begin
    lblSenha.Caption     := 'Mesa';
    lblAtendente.Caption := 'Coordenador';
    lblCliente.Caption   := 'Atendente';
    lblPA.Visible        := False;
    lblCliente.Visible   := True;

    Labels[1] := lblSenha;
    DBTexts[1] := dbSenha;

    Labels[2] := lblEvento;
    DBTexts[2] := dbEvento;

    Labels[3] := lblFila;
    DBTexts[3] := dbFila;

    Labels[4] := lblAtendente;
    DBTexts[4] := dbAtendente;

    Labels[5] := lblCliente;
    DbTexts[5] := dbCliente;

    Labels[6] := lblInicio;
    DBTexts[6] := dbInicio;

    Labels[7] := lblTermino;
    DBTexts[7] := dbTermino;

    Labels[8] := lblDuracao;
    DBTexts[8] := dbDuracao;

    Labels[9] := lblPA;
    DBTexts[9] := dbPA;

    Labels[10] := lblTipo;
    DBTexts[10] := dbTipo;
  end
  else
  begin
    Labels[1] := lblSenha;
    DBTexts[1] := dbSenha;

    Labels[2] := lblCliente;
    DbTexts[2] := dbCliente;

    Labels[3] := lblTipo;
    DBTexts[3] := dbTipo;

    Labels[4] := lblEvento;
    DBTexts[4] := dbEvento;

    Labels[5] := lblFila;
    DBTexts[5] := dbFila;

    Labels[6] := lblPA;
    DBTexts[6] := dbPA;

    Labels[7] := lblAtendente;
    DBTexts[7] := dbAtendente;

    Labels[8] := lblInicio;
    DBTexts[8] := dbInicio;

    Labels[9] := lblTermino;
    DBTexts[9] := dbTermino;

    Labels[10] := lblDuracao;
    DBTexts[10] := dbDuracao;
  end;

  //Calcula largura das colunas, de acordo com as que estão ou não visíveis
  QtdColunasDeLarguraFixa     := 5;  //SENHA, EVENTO, INICIO, TERMINO, DURACAO
  QtdColunasDeLarguraVariavel := 3;  //FILA, PA e ATD
  if lblCliente.Visible then QtdColunasDeLarguraVariavel := QtdColunasDeLarguraVariavel + 1;
  if lblTipo   .Visible then QtdColunasDeLarguraVariavel := QtdColunasDeLarguraVariavel + 1;

  LarguraPadrao := (ColumnHeaderBand1.ClientWidth - lblSenha.Width - lblEvento.Width - lblInicio.Width - lblTermino.Width - lblDuracao.Width -
                    (QtdColunasDeLarguraVariavel + QtdColunasDeLarguraFixa - 1) * OFF) div QtdColunasDeLarguraVariavel;

  for i := Low(Labels) to High(Labels) do
    if i in [2, 3, 5, 6, 7, 11] then  //indices no array dos campos que variam sua largura
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
  end;}
end;

procedure TqrSicsDetailTotem.DetailReportPreview(Sender: TObject);
begin
  TfrmSicsRepPreview.Preview(Self, TQRPrinter(Sender));
end;

procedure TqrSicsDetailTotem.QRDBText3Print(sender: TObject; var Value: String);
begin
  Value := StrListUnidadesAtds.Values[Value];
end;

procedure TqrSicsDetailTotem.QRDBText4Print(sender: TObject; var Value: String);
begin
  Value := StrListUnidadesPAs.Values[Value];
end;

procedure TqrSicsDetailTotem.QRDBText5Print(sender: TObject; var Value: String);
begin
   Value := StrListUnidadesFilas.Values[Value];
end;

procedure TqrSicsDetailTotem.QRDBText1Print(sender: TObject; var Value: String);
begin
   Value := StrListUnidadesTags.Values[Value];
end;

end.
