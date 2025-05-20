unit uFrmConfiguracoesSicsMultiPA;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, DBCtrls, Buttons, DB, FMTBcd, Sics_91,
  uFrmBaseConfiguracoesSics, Vcl.Mask, Datasnap.DBClient, Vcl.Grids,
  Vcl.DBGrids, uDataSetHelper;

type
  TFrmConfiguracoesSicsMultiPA = class(TFrmBaseConfiguracoesSics)
    grpCodigoBarras: TGroupBox;
    chkUtilizarLeitorCodigoBarras: TDBCheckBox;
    grpConfirmacoes: TGroupBox;
    chkConfirmarProximo: TDBCheckBox;
    chkConfirmarEncaminha: TDBCheckBox;
    chkConfirmarFinaliza: TDBCheckBox;
    chkConfirmarSenhaOutraFila: TDBCheckBox;
    chkMostrarNomeCliente: TDBCheckBox;
    chkMostrarPA: TDBCheckBox;
    chkPodeFecharPrograma: TDBCheckBox;
    chkTagsObrigatorias: TDBCheckBox;
    DBCheckBox1: TDBCheckBox;
    DBCheckBox2: TDBCheckBox;
    edtPortaLCDB: TDBEdit;
    lblPortaLCDB: TLabel;
    chkMostrarNomeAtendente: TDBCheckBox;
    groupBotoesVisiveis: TGroupBox;
    chkMostrarBotaoProcessos: TDBCheckBox;
    chkMostrarBotaoPausa: TDBCheckBox;
    chkMostrarBotaoEspecifica: TDBCheckBox;
    chkMostrarBotaoFinaliza: TDBCheckBox;
    chkMostrarBotaoEncaminha: TDBCheckBox;
    chkMostrarBotaoRechama: TDBCheckBox;
    chkMostrarBotaoProximo: TDBCheckBox;
    chkMostrarBotaoLogin: TDBCheckBox;
    groupMenusVisiveis: TGroupBox;
    chkMostrarMenuLogin: TDBCheckBox;
    chkMostrarMenuAlteraSenha: TDBCheckBox;
    chkMostrarMenuProximo: TDBCheckBox;
    chkMostrarMenuRechama: TDBCheckBox;
    chkMostrarMenuEspecifica: TDBCheckBox;
    chkMostrarMenuEncaminha: TDBCheckBox;
    chkMostrarMenuFinaliza: TDBCheckBox;
    chkMostrarMenuPausa: TDBCheckBox;
    chkMostrarMenuProcessos: TDBCheckBox;
    dbchkCONECTAR_VIA_DB: TDBCheckBox;
    chkMostrarBotaoSeguirAtendimento: TDBCheckBox;
    chkMostrarMenuSeguirAtendimento: TDBCheckBox;
    DBCheckBox3: TDBCheckBox;
    chkMostrarBotaoDadosAdicionais: TDBCheckBox;
    ScrollBox1: TScrollBox;
    edtGruposTagsSomenteLeitura: TDBEdit;
    btnGruposTagsLayoutBotao: TButton;
    btnGruposTagsLayoutLista: TButton;
    btnGruposTagsSomenteLeitura: TButton;
    edtGruposTagsLayoutLista: TDBEdit;
    edtGruposTagsLayoutBotao: TDBEdit;
    btnTagAutomatica: TButton;
    edtTagAutomatica: TDBEdit;
    DBCheckBox4: TDBCheckBox;
    edtFilaEsperaProfissional: TDBEdit;
    edtIdUnidadeCliente: TDBEdit;
    edtCodigosUnidades: TDBEdit;
    btnGruposPausasPermitidos: TButton;
    edtGruposPausasPermitidos: TDBEdit;
    Button1: TButton;
    edtPAsPermitidas: TDBEdit;
    edtColunasPA: TDBEdit;
    edtTempoLimparPA: TDBEdit;
    btnGruposProcessosParalelosPermitidos: TButton;
    btnFilasPermitidas: TButton;
    Button3: TButton;
    Button2: TButton;
    edtSegundosRechamar: TDBEdit;
    chkManualRedirect: TDBCheckBox;
    chkVisualizarProcessosParalelos: TDBCheckBox;
    edtFilasPermitidas: TDBEdit;
    edtGruposProcessosParalelosPermitidos: TDBEdit;
    edtGrupoTagsPermitidas: TDBEdit;
    edtGrupoAtendentesPermitidos: TDBEdit;
    lblGruposTagsSomenteLeitura: TLabel;
    lblGruposTagsLayoutLista: TLabel;
    lblGruposTagsLayoutBotao: TLabel;
    lblTagAutomatica: TLabel;
    lblFilaEsperaProfissional: TLabel;
    lblIdUnidadeCliente: TLabel;
    lblCodigosUnidades: TLabel;
    lblSegundosRechamar: TLabel;
    Label3: TLabel;
    Label1: TLabel;
    lblGruposPausasPermitidos: TLabel;
    lblPAsPermitidas: TLabel;
    lblFilasPermitidas: TLabel;
    lblGruposProcessosParalelosPermitidos: TLabel;
    lblGrupoTagsPermitidas: TLabel;
    lblGrupoAtendentesPermitidos: TLabel;
    DBCheckBox5: TDBCheckBox;
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure btnFilasPermitidasClick(Sender: TObject);
    procedure btnGruposProcessosParalelosPermitidosClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnGruposPausasPermitidosClick(Sender: TObject);
    procedure edtPAsPermitidasKeyPress(Sender: TObject; var Key: Char);
    procedure edtPAsPermitidasExit(Sender: TObject);
    procedure chkManualRedirectClick(Sender: TObject);
    procedure chkVisualizarProcessosParalelosClick(Sender: TObject);
    procedure chkUtilizarLeitorCodigoBarrasClick(Sender: TObject);
    procedure btnTagAutomaticaClick(Sender: TObject);
    procedure edtGruposTagsLayoutBotaoExit(Sender: TObject);
    procedure edtGruposTagsLayoutListaExit(Sender: TObject);
    procedure edtGruposTagsSomenteLeituraExit(Sender: TObject);
    procedure edtGruposTagsLayoutBotaoKeyPress(Sender: TObject; var Key: Char);
    procedure edtGruposTagsLayoutListaKeyPress(Sender: TObject; var Key: Char);
    procedure edtGruposTagsSomenteLeituraKeyPress(Sender: TObject;
      var Key: Char);
    procedure btnGruposTagsLayoutBotaoClick(Sender: TObject);
    procedure btnGruposTagsLayoutListaClick(Sender: TObject);
    procedure btnGruposTagsSomenteLeituraClick(Sender: TObject);
  protected
    function GetTipoModulo: TModuloSics; Override;
    function GetDataSetFormPrincipal: TClientDataSet; Override;
    procedure HabilitaBotoes; Override;
  public
    { Public declarations }
  end;

var
  FrmConfiguracoesSicsMultiPA: TFrmConfiguracoesSicsMultiPA;

implementation

uses sics_94;

{$R *.dfm}

procedure TFrmConfiguracoesSicsMultiPA.Button1Click(Sender: TObject);
begin
  CarregaGrupos(lblPAsPermitidas, 'PAS');
end;

procedure TFrmConfiguracoesSicsMultiPA.Button2Click(Sender: TObject);
begin
  CarregaGrupos(lblGrupoAtendentesPermitidos, 'GRUPOS_ATENDENTES');
end;

procedure TFrmConfiguracoesSicsMultiPA.Button3Click(Sender: TObject);
begin
  CarregaGrupos(lblGrupoTagsPermitidas, 'GRUPOS_TAGS');
end;

procedure TFrmConfiguracoesSicsMultiPA.btnFilasPermitidasClick(Sender: TObject);
begin
  CarregaGrupos(lblFilasPermitidas, 'FILAS');
end;

procedure TFrmConfiguracoesSicsMultiPA.btnGruposProcessosParalelosPermitidosClick(Sender: TObject);
begin
  CarregaGrupos(lblGruposProcessosParalelosPermitidos, 'GRUPOS_PPS');
end;

procedure TFrmConfiguracoesSicsMultiPA.btnGruposTagsLayoutBotaoClick(
  Sender: TObject);
begin
  CarregaGrupos(lblGruposTagsLayoutBotao, 'GRUPOS_TAGS');
end;

procedure TFrmConfiguracoesSicsMultiPA.btnGruposTagsLayoutListaClick(
  Sender: TObject);
begin
  CarregaGrupos(lblGruposTagsLayoutLista, 'GRUPOS_TAGS');
end;

procedure TFrmConfiguracoesSicsMultiPA.btnGruposTagsSomenteLeituraClick(
  Sender: TObject);
begin
  CarregaGrupos(lblGruposTagsSomenteLeitura, 'GRUPOS_TAGS');
end;

procedure TFrmConfiguracoesSicsMultiPA.btnTagAutomaticaClick(Sender: TObject);
begin
  CarregaGrupos(lblTagAutomatica, 'TAGS');
end;

procedure TFrmConfiguracoesSicsMultiPA.chkManualRedirectClick(
  Sender: TObject);
begin
  inherited;
  HabilitaBotoes;
end;

procedure TFrmConfiguracoesSicsMultiPA.chkUtilizarLeitorCodigoBarrasClick(Sender: TObject);
begin
  inherited;
  HabilitaBotoes;
end;

procedure TFrmConfiguracoesSicsMultiPA.chkVisualizarProcessosParalelosClick(Sender: TObject);
begin
  inherited;
  HabilitaBotoes;
end;

procedure TFrmConfiguracoesSicsMultiPA.edtGruposTagsLayoutBotaoExit(
  Sender: TObject);
begin
  inherited;
  VerificaSequenciaNumeros(Sender);
end;

procedure TFrmConfiguracoesSicsMultiPA.edtGruposTagsLayoutBotaoKeyPress(
  Sender: TObject; var Key: Char);
begin
  inherited;
  SomenteNumeros(Key);
end;

procedure TFrmConfiguracoesSicsMultiPA.edtGruposTagsLayoutListaExit(
  Sender: TObject);
begin
  inherited;
  VerificaSequenciaNumeros(Sender);
end;

procedure TFrmConfiguracoesSicsMultiPA.edtGruposTagsLayoutListaKeyPress(
  Sender: TObject; var Key: Char);
begin
  inherited;
  SomenteNumeros(Key);
end;

procedure TFrmConfiguracoesSicsMultiPA.edtGruposTagsSomenteLeituraExit(
  Sender: TObject);
begin
  inherited;
  VerificaSequenciaNumeros(Sender);
end;

procedure TFrmConfiguracoesSicsMultiPA.edtGruposTagsSomenteLeituraKeyPress(
  Sender: TObject; var Key: Char);
begin
  inherited;
  SomenteNumeros(Key);
end;

procedure TFrmConfiguracoesSicsMultiPA.edtPAsPermitidasExit(
  Sender: TObject);
begin
  inherited;
  VerificaSequenciaNumeros(Sender);
end;

procedure TFrmConfiguracoesSicsMultiPA.edtPAsPermitidasKeyPress(
  Sender: TObject; var Key: Char);
begin
  inherited;
  SomenteNumeros(Key);
end;

function TFrmConfiguracoesSicsMultiPA.GetDataSetFormPrincipal: TClientDataSet;
begin
  Result := dmSicsMain.cdsSicsMultiPA;
end;

function TFrmConfiguracoesSicsMultiPA.GetTipoModulo: TModuloSics;
begin
  Result := TModuloSics.msMPA;
end;

procedure TFrmConfiguracoesSicsMultiPA.btnGruposPausasPermitidosClick(Sender: TObject);
begin
  CarregaGrupos(lblGruposPausasPermitidos, 'GRUPOS_MOTIVOS_PAUSA');
end;

procedure TFrmConfiguracoesSicsMultiPA.HabilitaBotoes;
begin
  inherited;

  lblFilasPermitidas.Enabled := chkManualRedirect.Checked;
  edtFilasPermitidas.Enabled := lblFilasPermitidas.Enabled;
  btnFilasPermitidas.Enabled := lblFilasPermitidas.Enabled;

  lblGruposProcessosParalelosPermitidos.Enabled := chkVisualizarProcessosParalelos.Checked;
  edtGruposProcessosParalelosPermitidos.Enabled := lblGruposProcessosParalelosPermitidos.Enabled;
  btnGruposProcessosParalelosPermitidos.Enabled := lblGruposProcessosParalelosPermitidos.Enabled;

  lblPortaLCDB.Enabled := chkUtilizarLeitorCodigoBarras.Checked;
  edtPortaLCDB.Enabled := lblPortaLCDB.Enabled;
end;

end.
