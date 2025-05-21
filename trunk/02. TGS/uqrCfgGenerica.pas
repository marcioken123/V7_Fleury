unit uqrCfgGenerica;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses Windows, SysUtils, Messages, Classes, vcl.Graphics, vcl.Controls,
  repGraphBase, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Forms, QuickRpt, QRCtrls,
  DB, qrprntr, ufrmConfiguraTabela;

type
  TqrSicsCfgGenerica = class(TqrSicsGraphicBase)
    dtlbnd: TQRBand;
    pgheader: TQRBand;
    qrlblTitulo: TQRLabel;
    QRShape1: TQRShape;
    QRImage1: TQRImage;              
    QRLabel2: TQRLabel;
    DateTimeLabel: TQRSysData;
    QRSysData1: TQRSysData;
    procedure QuickRepPreview(Sender: TObject);
  private
    procedure QRDBTextPrintBoolean(Sender: TObject; var Value: String);
  public
    procedure AjustarQR(Tipo: TTabelaSics; ADataSet: TDataSet);
  end;

implementation

uses
  Variants, repPrview, Sics_Common_Parametros;

{$R *.DFM}

{ TqrCfgGenerica }

procedure TqrSicsCfgGenerica.AjustarQR(Tipo: TTabelaSics; ADataSet: TDataSet);
var
  sTitulo: string;
  ArrCampos: array of string;
  i, iLeft: Integer;
  ArrTamanhos: array of Integer;
  FieldAux: TField;
begin
  DataSet := ADataSet;

  case Tipo of
    ctFilas:              begin
                            sTitulo     := 'Filas';
                            ArrCampos   := VarArrayOf(['ID', 'ATIVO', 'NOME', 'NOMENOTICKET',   'RANGEMINIMO', 'RANGEMAXIMO', 'GERACAOAUTOMATICA']);
                            ArrTamanhos := VarArrayOf([30,   30,      250,    190,              50,            50,            50                 ]);
                          end;

    ctGruposDePaineis:    begin
                            sTitulo     := 'Grupos de Painéis';
                            ArrCampos   := VarArrayOf(['ID', 'NOME']);
                            ArrTamanhos := VarArrayOf([30,   300]);
                          end;

    ctPaineis:            begin
                            sTitulo     := 'Painéis';
                            ArrCampos   := VarArrayOf(['ID', 'NOME', 'LKUP_MODELOPAINEL', 'ENDERECOSERIAL', 'TCPIP',  'MANTERULTIMASENHA', 'MONITORAMENTO']);
                            ArrTamanhos := VarArrayOf([30,   200,    120,                 75,               130,      50,                  50             ]);
                          end;

    ctGruposDePAs:        begin
                            sTitulo     := 'Grupos de PAs';
                            ArrCampos   := VarArrayOf(['ID', 'NOME']);
                            ArrTamanhos := VarArrayOf([30,   300]);
                          end;

    ctPAs:                begin
                            sTitulo     := 'PAs';
                            ArrCampos   := VarArrayOf(['ID', 'ATIVO', 'NOME', 'LKUP_GRUPO', 'LKUP_PAINEL', 'NOMENOPAINEL', 'MAGAZINE', 'LKUP_FILAAUTOENCAMINHA', 'LKP_ATENDENTE']);
                            ArrTamanhos := VarArrayOf([30,   30,      170,    75,           75,            90,             25,         60,                       60             ]);
                          end;

    ctGruposDeAtendentes: begin
                            sTitulo     := 'Grupos de Atendentes';
                            ArrCampos   := VarArrayOf(['ID', 'NOME']);
                            ArrTamanhos := VarArrayOf([30,   300]);
                          end;

    ctAtendentes:         begin
                            if vgParametrosModulo.ModoCallCenter then
                              sTitulo   := 'Coordenadores'
                            else
                              sTitulo   := 'Atendentes';   
                            
                            ArrCampos   := VarArrayOf(['ID', 'ATIVO', 'NOME', 'LKUP_GRUPOATENDENTE', 'LOGIN', 'REGISTROFUNCIONAL', 'NOMERELATORIO']);
                            ArrTamanhos := VarArrayOf([30,   30,      200,    170,                   100,     80,                  50             ]);
                          end;

    ctClientes:           begin
                            sTitulo     := 'Atendentes';
                            ArrCampos   := VarArrayOf(['ID', 'ATIVO', 'NOME', 'LOGIN']);
                            ArrTamanhos := VarArrayOf([30,   30,      200,    100]);
                          end;

    ctEmails:             begin
                            sTitulo     := 'Emails';
                            ArrCampos   := VarArrayOf(['ID', 'NOME', 'ENDERECO']);
                            ArrTamanhos := VarArrayOf([30,   200,    300]);
                          end;

    ctCelulares:          begin
                            sTitulo     := 'Celulares';
                            ArrCampos   := VarArrayOf(['ID', 'NOME', 'PREFIXO', 'NUMERO']);
                            ArrTamanhos := VarArrayOf([30,   200,    50,        200]);
                          end;
  else
    raise Exception.Create('Tipo de Tabela não preparada no relatório');
  end;

  iLeft := 0;
  for i := Low(ArrCampos) to High(ArrCampos) do
  begin

    FieldAux := ADataSet.FieldByName(ArrCampos[i]);

    with TQRLabel.Create(Self) do
    begin
      AutoSize := False;
      Width := ArrTamanhos[i];
      Parent := pgheader;
      Left := iLeft;
      Top := 80;
      Font.Size := 8;
      Font.Style := [fsBold];
      Font.Name := 'Arial';

      // copiando/ se baseando em algumas caracteres do "field"
      Alignment := FieldAux.Alignment;
      Caption := FieldAux.DisplayLabel;
    end;

    with TQRDBText.Create(Self) do
    begin
      DataSet := ADataSet;
      DataField := ArrCampos[i];
      AutoSize := False;
      Width := ArrTamanhos[i];
      Parent := dtlbnd;
      Left := iLeft;
      Top := 0;
      Font.Size := 8;
      Font.Name := 'Arial';

      // copiando/ se baseando em algumas caracteres do "field"
      Alignment := FieldAux.Alignment;
      if FieldAux.Tag = 1 then // se for um campo booleano
        OnPrint := QRDBTextPrintBoolean;

      Inc(iLeft, Width + 5);
    end;
  end;

  qrlblTitulo.Caption := 'Relatório de ' + sTitulo;
end;

procedure TqrSicsCfgGenerica.QRDBTextPrintBoolean(sender: TObject; var Value: String);
begin
  if Value = 'T' then
    Value := 'S'
  else
    Value := 'N';
end;

procedure TqrSicsCfgGenerica.QuickRepPreview(Sender: TObject);
begin
  //DataSet.DisableControls;
  TfrmSicsRepPreview.Preview(Self, TQRPrinter(Sender));
end;

end.
