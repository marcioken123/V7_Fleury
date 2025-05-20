unit uFrmConfiguracoesSicsOnLine;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, DBCtrls, Buttons, DB, FMTBcd, Sics_91,
  uFrmBaseConfiguracoesSics, Vcl.Mask, Datasnap.DBClient, uDataSetHelper,
  Vcl.Grids, Vcl.DBGrids;

type
  TFrmConfiguracoesSicsOnLine = class(TFrmBaseConfiguracoesSics)
    dbchkVISUALIZAR_GRUPOS: TDBCheckBox;
    dbchkPODE_FECHAR_PROGRAMA: TDBCheckBox;
    lblGruposMotivosPausaPermitidos: TLabel;
    lblImpressoraComanda: TLabel;
    lblGrupoAtendPermitidos: TLabel;
    edtGruposMotivosPausaPermitidos: TDBEdit;
    btnGruposMotivosPausaPermitidos: TButton;
    edtImpressoraComanda: TDBEdit;
    edtGruposTagsPermitidos: TDBEdit;
    btnGruposTagsPermitidos: TButton;
    edtGrupoAtendPermitidos: TDBEdit;
    btnGrupoAtendPermitidos: TButton;
    lblGrupoIndicadoresPermitidos: TLabel;
    edtGrupoIndicadoresPermitidos: TDBEdit;
    btnGrupoIndicadoresPermitidos: TButton;
    dbchkVISUALIZAR_NOME_CLIENTES: TDBCheckBox;
    scrlbxConfiguracoes: TScrollBox;
    edtGruposPAsPermitidas: TDBEdit;
    btnGruposPAsPermitidas: TButton;
    lblGruposPAsPermitidas: TLabel;
    lblGruposTagsPermitidos: TLabel;
    cbTelas: TDBLookupComboBox;
    Label1: TLabel;
    grpVisualizacaoEspera: TGroupBox;
    lblFilasPermitidas: TLabel;
    edtFilasPermitidas: TDBEdit;
    btnFilasPermitidas: TButton;
    lblPermiteExclusaoFilas: TLabel;
    edtPermiteExclusaoFilas: TDBEdit;
    btnPermiteExclusaoFilas: TButton;
    lblPermitirReimpressaoFilas: TLabel;
    edtPermitirReimpressao: TDBEdit;
    btnPermitirReimpressao: TButton;
    lblMostrarBotaoFilas: TLabel;
    edtMostrarBotaoFilas: TDBEdit;
    btnMostrarBotaoFilas: TButton;
    lblMostrarBloquearFilas: TLabel;
    edtMostrarBloquearFilas: TDBEdit;
    btnMostrarBloquearFilas: TButton;
    lblMostrarPrioritariaFilas: TLabel;
    edtMostrarPrioritariaFilas: TDBEdit;
    lblPermitirInclusaoFilas: TLabel;
    edtPermitirInclusaoFilas: TDBEdit;
    btnMostrarPrioritariaFilas: TButton;
    btnPermitirInclusaoFilas: TButton;
    lblColunasFilas: TLabel;
    edtColunasFilas: TDBEdit;
    lblFilasPorPagina: TLabel;
    edtLinhasDeFilas: TDBEdit;
    lblTamanhoFonte: TLabel;
    cbTamanhoFonte: TDBLookupComboBox;
    lblLayoutFilas: TLabel;
    cbLayoutFilas: TDBLookupComboBox;
    chkMostrarTodas: TDBCheckBox;
    chkMostrarTempoDecorridoEspera: TDBCheckBox;
    cbCorLimiar: TDBLookupComboBox;
    lblCorLimiar: TLabel;
    cbEstiloLayout: TDBLookupComboBox;
    Label2: TLabel;
    DBCheckBox1: TDBCheckBox;
    lblIdUnidadeCliente: TLabel;
    edtIdUnidadeCliente: TDBEdit;
    DBCheckBox2: TDBCheckBox;
    DBCheckBox3: TDBCheckBox;
    procedure btnMostrarPrioritariaFilasClick(Sender: TObject);
    procedure btnFilasPermitidasClick(Sender: TObject);
    procedure chkModoTotemTouchClick(Sender: TObject);
    procedure btnMostrarBotaoFilasClick(Sender: TObject);
    procedure btnMostrarBloquearFilasClick(Sender: TObject);
    procedure btnGruposTagsPermitidosClick(Sender: TObject);
    procedure btnPermitirInclusaoFilasClick(Sender: TObject);
    procedure btnGruposMotivosPausaPermitidosClick(Sender: TObject);
    procedure btnPermiteExclusaoFilasClick(Sender: TObject);
    procedure btnGrupoAtendPermitidosClick(Sender: TObject);
    procedure btnGrupoIndicadoresPermitidosClick(Sender: TObject);
    procedure btnGruposPAsPermitidasClick(Sender: TObject);
    procedure edtFilasPermitidasKeyPress(Sender: TObject; var Key: Char);
    procedure edtFilasPermitidasExit(Sender: TObject);
    procedure btnPermitirReimpressaoClick(Sender: TObject);
  private
    procedure HabilitaBotoesTotem;
  protected
    procedure HabilitaBotoes; Override;
    function GetTipoModulo: TModuloSics; Override;
    function GetDataSetFormPrincipal: TClientDataSet; Override;
    procedure SetDefaultConfig; Override;
  public
    { Public declarations }
  end;

var
  FrmConfiguracoesSicsOnLine: TFrmConfiguracoesSicsOnLine;

implementation

uses
  sics_94;

{$R *.dfm}

function TFrmConfiguracoesSicsOnLine.GetDataSetFormPrincipal: TClientDataSet;
begin
  Result := dmSicsMain.cdsSicsOnLine;
end;

function TFrmConfiguracoesSicsOnLine.GetTipoModulo: TModuloSics;
begin
  Result := TModuloSics.msOnLine;
end;

procedure TFrmConfiguracoesSicsOnLine.btnMostrarBloquearFilasClick(Sender: TObject);
begin
  CarregaGrupos(lblMostrarBloquearFilas, 'FILAS');
end;

procedure TFrmConfiguracoesSicsOnLine.btnMostrarPrioritariaFilasClick(Sender: TObject);
begin
  CarregaGrupos(lblMostrarPrioritariaFilas, 'FILAS');
end;

procedure TFrmConfiguracoesSicsOnLine.btnMostrarBotaoFilasClick(Sender: TObject);
begin
  CarregaGrupos(lblMostrarBotaoFilas, 'FILAS');
end;

procedure TFrmConfiguracoesSicsOnLine.btnPermiteExclusaoFilasClick(Sender: TObject);
begin
  CarregaGrupos(lblPermiteExclusaoFilas, 'FILAS');
end;

procedure TFrmConfiguracoesSicsOnLine.btnPermitirInclusaoFilasClick(Sender: TObject);
begin
  CarregaGrupos(lblPermitirInclusaoFilas, 'FILAS');
end;

procedure TFrmConfiguracoesSicsOnLine.btnPermitirReimpressaoClick(
  Sender: TObject);
begin
  inherited;
  CarregaGrupos(lblPermitirReimpressaoFilas, 'FILAS');
end;

procedure TFrmConfiguracoesSicsOnLine.btnFilasPermitidasClick(Sender: TObject);
begin
  CarregaGrupos(lblFilasPermitidas, 'FILAS');
end;

procedure TFrmConfiguracoesSicsOnLine.btnGruposTagsPermitidosClick(Sender: TObject);
begin
  CarregaGrupos(lblGruposTagsPermitidos, 'GRUPOS_TAGS');
end;

procedure TFrmConfiguracoesSicsOnLine.chkModoTotemTouchClick(Sender: TObject);
begin
  HabilitaBotoesTotem;
end;

procedure TFrmConfiguracoesSicsOnLine.edtFilasPermitidasExit(
  Sender: TObject);
begin
  inherited;
  VerificaSequenciaNumeros(Sender);
end;

procedure TFrmConfiguracoesSicsOnLine.edtFilasPermitidasKeyPress(
  Sender: TObject; var Key: Char);
begin
  inherited;
  SomenteNumeros(Key);
end;

procedure TFrmConfiguracoesSicsOnLine.btnGrupoAtendPermitidosClick(Sender: TObject);
begin
  CarregaGrupos(lblGrupoAtendPermitidos, 'GRUPOS_ATENDENTES');
end;

procedure TFrmConfiguracoesSicsOnLine.btnGrupoIndicadoresPermitidosClick(Sender: TObject);
begin
  inherited;
  CarregaGrupos(lblGrupoIndicadoresPermitidos, 'PIS');
end;

procedure TFrmConfiguracoesSicsOnLine.btnGruposMotivosPausaPermitidosClick(Sender: TObject);
begin
  CarregaGrupos(lblGruposMotivosPausaPermitidos, 'GRUPOS_MOTIVOS_PAUSA');
end;

procedure TFrmConfiguracoesSicsOnLine.btnGruposPAsPermitidasClick(
  Sender: TObject);
begin
  inherited;
  CarregaGrupos(lblGruposPAsPermitidas, 'GRUPOS_PAS');
end;

procedure TFrmConfiguracoesSicsOnLine.HabilitaBotoes;
begin
  inherited;
  HabilitaBotoesTotem;
end;

procedure TFrmConfiguracoesSicsOnLine.HabilitaBotoesTotem;
begin
end;

procedure TFrmConfiguracoesSicsOnLine.SetDefaultConfig;
begin
  inherited;
end;

end.
