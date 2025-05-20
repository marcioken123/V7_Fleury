unit uFrmConfiguracoesSicsPA;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Mask, DBCtrls, Buttons, DB, DBGrids, FMTBcd,
  Provider, Sics_91, uFrmBaseConfiguracoesSics, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.Client, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Comp.DataSet, Datasnap.DBClient, uDataSetHelper,
  Vcl.Grids;

type

  TFrmConfiguracoesSicsPA = class(TFrmBaseConfiguracoesSics)
    qryNomePA: TFDQuery;
    cdsNomePA: TClientDataSet;
    cdsNomePAID: TIntegerField;
    cdsNomePANOME: TStringField;
    dspNomePA: TDataSetProvider;
    dscNomePA: TDataSource;
    chkMostrarNomeCliente: TDBCheckBox;
    chkMostrarPA: TDBCheckBox;
    chkPodeFecharPrograma: TDBCheckBox;
    chkTagsObrigatorias: TDBCheckBox;
    DBCheckBox1: TDBCheckBox;
    grpConfirmacoes: TGroupBox;
    chkConfirmarProximo: TDBCheckBox;
    chkConfirmarEncaminha: TDBCheckBox;
    chkConfirmarFinaliza: TDBCheckBox;
    chkConfirmarSenhaOutraFila: TDBCheckBox;
    grpCodigoBarras: TGroupBox;
    chkUtilizarLeitorCodigoBarras: TDBCheckBox;
    DBCheckBox2: TDBCheckBox;
    edtPortaLCDB: TDBEdit;
    lblPortaLCDB: TLabel;
    chkMostrarNomeAtendente: TDBCheckBox;
    groupBotoesVisiveis: TGroupBox;
    chkMostrarBotaoProximo: TDBCheckBox;
    chkMostrarBotaoRechama: TDBCheckBox;
    chkMostrarBotaoEncaminha: TDBCheckBox;
    chkMostrarBotaoFinaliza: TDBCheckBox;
    chkMostrarBotaoEspecifica: TDBCheckBox;
    chkMostrarBotaoPausa: TDBCheckBox;
    dbchkMOSTRAR_BOTAO_PROCESSOS: TDBCheckBox;
    chkMostrarBotaoLoginLogout: TDBCheckBox;
    groupMenusVisiveis: TGroupBox;
    chkMostrarMenuProximo: TDBCheckBox;
    chkMostrarMenuRechama: TDBCheckBox;
    chkMostrarMenuEspecifica: TDBCheckBox;
    chkMostrarMenuEncaminha: TDBCheckBox;
    chkMostrarMenuFinaliza: TDBCheckBox;
    chkMostrarMenuPausa: TDBCheckBox;
    dbchkMenuProcessos: TDBCheckBox;
    chkMostrarMenuLogin: TDBCheckBox;
    chkMostrarMenuAlteraSenha: TDBCheckBox;
    dbchkCONECTAR_VIA_DB: TDBCheckBox;
    DBCheckBox3: TDBCheckBox;
    chkMostrarBotaoSeguirAtendimento: TDBCheckBox;
    chkMostrarMenuSeguirAtendimento: TDBCheckBox;
    chkMostrarBotaoDadosAdicionais: TDBCheckBox;
    ScrollBox1: TScrollBox;
    lblAtendentesPermitidos: TLabel;
    lblGruposTagsPermitidos: TLabel;
    lblGruposProcessosParalelosPermitidos: TLabel;
    lblFilasPermitidas: TLabel;
    lblSegundosRechamar: TLabel;
    lblID_PA: TLabel;
    Label2: TLabel;
    lblPAsPermitidas: TLabel;
    lblGruposPausasPermitidos: TLabel;
    GruposdeAcessoControleRemoto: TLabel;
    lblCodigosUnidades: TLabel;
    lblIdUnidadeCliente: TLabel;
    lblFilaEsperaProfissional: TLabel;
    lblTagAutomatica: TLabel;
    lblGruposTagsLayoutBotao: TLabel;
    lblGruposTagsLayoutLista: TLabel;
    lblGruposTagsSomenteLeitura: TLabel;
    edtGruposAtendentesPermitidos: TDBEdit;
    edtGruposTagsPermitidos: TDBEdit;
    edtGruposProcessosParalelosPermitidos: TDBEdit;
    edtFilasPermitidas: TDBEdit;
    chkVisualizarProcessosParalelos: TDBCheckBox;
    chkManualRedirect: TDBCheckBox;
    edtSegundosRechamar: TDBEdit;
    edtID_PA: TDBEdit;
    btnGruposAtendentesPermitidos: TButton;
    btnGruposTagsPermitidos: TButton;
    btnFilasPermitidas: TButton;
    btnGruposProcessosParalelosPermitidos: TButton;
    cboNomePA: TDBLookupComboBox;
    edtPAsPermitidas: TDBEdit;
    btnPasPermitidas: TButton;
    edtGruposPausasPermitidos: TDBEdit;
    btnGruposPausasPermitidos: TButton;
    chkModoTerminalServer: TDBCheckBox;
    edtGruposAtendentesPermitidosCR: TDBEdit;
    btnGruposAtendentesPermitidosCR: TButton;
    chkHabilitaControleRemoto: TDBCheckBox;
    edtCodigosUnidades: TDBEdit;
    edtIdUnidadeCliente: TDBEdit;
    edtFilaEsperaProfissional: TDBEdit;
    DBCheckBox4: TDBCheckBox;
    edtTagAutomatica: TDBEdit;
    btnTagAutomatica: TButton;
    btnGruposTagsLayoutBotao: TButton;
    edtGruposTagsLayoutBotao: TDBEdit;
    edtGruposTagsLayoutLista: TDBEdit;
    btnGruposTagsLayoutLista: TButton;
    edtGruposTagsSomenteLeitura: TDBEdit;
    btnGruposTagsSomenteLeitura: TButton;
    DBCheckBox5: TDBCheckBox;
    procedure btnGruposAtendentesPermitidosClick(Sender: TObject);
    procedure btnGruposTagsPermitidosClick(Sender: TObject);
    procedure btnFilasPermitidasClick(Sender: TObject);
    procedure btnGruposProcessosParalelosPermitidosClick(Sender: TObject);
    procedure btnPasPermitidasClick(Sender: TObject);
    procedure btnGruposPausasPermitidosClick(Sender: TObject);
    procedure edtID_PAChange(Sender: TObject);
    procedure cboNomePAClick(Sender: TObject);
    procedure grdModulosCellClick(Column: TColumn);
    procedure chkModoTerminalServerClick(Sender: TObject);
    procedure edtPAsPermitidasKeyPress(Sender: TObject; var Key: Char);
    procedure edtPAsPermitidasExit(Sender: TObject);
    procedure chkManualRedirectClick(Sender: TObject);
    procedure chkVisualizarProcessosParalelosClick(Sender: TObject);
    procedure chkUtilizarLeitorCodigoBarrasClick(Sender: TObject);
    procedure btnGruposAtendentesPermitidosCRClick(Sender: TObject);
    procedure btnTagAutomaticaClick(Sender: TObject);
    procedure btnGruposTagsLayoutBotaoClick(Sender: TObject);
    procedure btnGruposTagsLayoutListaClick(Sender: TObject);
    procedure btnGruposTagsSomenteLeituraClick(Sender: TObject);
    procedure edtGruposTagsLayoutBotaoExit(Sender: TObject);
    procedure edtGruposTagsLayoutListaExit(Sender: TObject);
    procedure edtGruposTagsSomenteLeituraExit(Sender: TObject);
    procedure edtGruposTagsLayoutBotaoKeyPress(Sender: TObject; var Key: Char);
    procedure edtGruposTagsLayoutListaKeyPress(Sender: TObject; var Key: Char);
    procedure edtGruposTagsSomenteLeituraKeyPress(Sender: TObject;
      var Key: Char);
  protected
    function PermiteCopiarField(const aField: TField): Boolean; Override;
    procedure SetDefaultConfig; Override;
    procedure PrepareDataSet; Override;
    function GetTipoModulo: TModuloSics; Override;
    function GetDataSetFormPrincipal: TClientDataSet; Override;
    procedure HabilitaBotoes; Override;
  public
    { Public declarations }
  end;

var
  FrmConfiguracoesSicsPA: TFrmConfiguracoesSicsPA;

implementation

uses sics_94;

{$R *.dfm}

procedure TFrmConfiguracoesSicsPA.btnGruposAtendentesPermitidosClick(Sender: TObject);
begin
  CarregaGrupos(lblAtendentesPermitidos, 'GRUPOS_ATENDENTES');
end;

procedure TFrmConfiguracoesSicsPA.btnGruposAtendentesPermitidosCRClick(
  Sender: TObject);
begin
  CarregaGrupos(GruposdeAcessoControleRemoto, 'PAINEIS');
end;

procedure TFrmConfiguracoesSicsPA.btnGruposPausasPermitidosClick(Sender: TObject);
begin
  CarregaGrupos(lblGruposPausasPermitidos, 'GRUPOS_MOTIVOS_PAUSA');
end;

procedure TFrmConfiguracoesSicsPA.btnGruposTagsLayoutBotaoClick(
  Sender: TObject);
begin
  CarregaGrupos(lblGruposTagsLayoutBotao, 'GRUPOS_TAGS');
end;

procedure TFrmConfiguracoesSicsPA.btnGruposTagsLayoutListaClick(
  Sender: TObject);
begin
  CarregaGrupos(lblGruposTagsLayoutLista, 'GRUPOS_TAGS');

end;

procedure TFrmConfiguracoesSicsPA.btnGruposTagsPermitidosClick(Sender: TObject);
begin
  CarregaGrupos(lblGruposTagsPermitidos, 'GRUPOS_TAGS');
end;

procedure TFrmConfiguracoesSicsPA.btnGruposTagsSomenteLeituraClick(
  Sender: TObject);
begin
  CarregaGrupos(lblGruposTagsSomenteLeitura, 'GRUPOS_TAGS');
end;

procedure TFrmConfiguracoesSicsPA.btnFilasPermitidasClick(Sender: TObject);
begin
  CarregaGrupos(lblFilasPermitidas, 'FILAS');
end;

procedure TFrmConfiguracoesSicsPA.btnGruposProcessosParalelosPermitidosClick(Sender: TObject);
begin
  CarregaGrupos(lblGruposProcessosParalelosPermitidos, 'GRUPOS_PPS');
end;

function TFrmConfiguracoesSicsPA.GetDataSetFormPrincipal: TClientDataSet;
begin
  dmSicsMain.cdsSicsPA.Close;
  dmSicsMain.cdsSicsPA.Open;

  Result := dmSicsMain.cdsSicsPA;
end;

function TFrmConfiguracoesSicsPA.GetTipoModulo: TModuloSics;
begin
  Result := TModuloSics.msPA;
end;

procedure TFrmConfiguracoesSicsPA.cboNomePAClick(Sender: TObject);
begin
  ModoEdicaoDataSet;
  edtID_PA.Field.Value := cboNomePA.KeyValue;
end;

procedure TFrmConfiguracoesSicsPA.chkManualRedirectClick(Sender: TObject);
begin
  inherited;
  HabilitaBotoes;
end;

procedure TFrmConfiguracoesSicsPA.chkModoTerminalServerClick(Sender: TObject);
begin
  inherited;
  HabilitaBotoes;
end;

procedure TFrmConfiguracoesSicsPA.chkUtilizarLeitorCodigoBarrasClick(Sender: TObject);
begin
  inherited;
  HabilitaBotoes;
end;

procedure TFrmConfiguracoesSicsPA.chkVisualizarProcessosParalelosClick (Sender: TObject);
begin
  inherited;
  HabilitaBotoes;
end;

procedure TFrmConfiguracoesSicsPA.grdModulosCellClick(Column: TColumn);
begin
  inherited;
  cboNomePA.KeyValue := CDSConfig.FieldByName('ID_PA').Value;
end;

procedure TFrmConfiguracoesSicsPA.HabilitaBotoes;
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

  lblPAsPermitidas.Enabled := chkModoTerminalServer.Checked;
  edtPAsPermitidas.Enabled := lblPAsPermitidas.Enabled;
  btnPasPermitidas.Enabled := lblPAsPermitidas.Enabled;

  lblID_PA.Enabled  := not lblPAsPermitidas.Enabled;
  edtID_PA.Enabled  := lblID_PA.Enabled;
  Label2.Enabled    := lblID_PA.Enabled;
  cboNomePA.Enabled := lblID_PA.Enabled;

  if((not chkModoTerminalServer.Checked) and (dtsConfig.DataSet.State in [dsEdit,dsInsert]))then
    dtsConfig.DataSet.FieldByName('PAS_PERMITIDAS').Value := '';
end;

function TFrmConfiguracoesSicsPA.PermiteCopiarField(const aField: TField): Boolean;
begin
  Result := inherited PermiteCopiarField(aField) and (aField.FieldName <> 'ID_PA');
end;

procedure TFrmConfiguracoesSicsPA.PrepareDataSet;
begin
  qryNomePA.Open;
  cdsNomePA.Open;
  inherited;
end;

procedure TFrmConfiguracoesSicsPA.btnPasPermitidasClick(Sender: TObject);
begin
  CarregaGrupos(lblPAsPermitidas, 'PAS');
end;

procedure TFrmConfiguracoesSicsPA.btnTagAutomaticaClick(Sender: TObject);
begin
  CarregaGrupos(lblTagAutomatica, 'TAGS');
end;

procedure TFrmConfiguracoesSicsPA.edtGruposTagsLayoutBotaoExit(Sender: TObject);
begin
  inherited;
  VerificaSequenciaNumeros(Sender);
end;

procedure TFrmConfiguracoesSicsPA.edtGruposTagsLayoutBotaoKeyPress(
  Sender: TObject; var Key: Char);
begin
  inherited;
  SomenteNumeros(Key);
end;

procedure TFrmConfiguracoesSicsPA.edtGruposTagsLayoutListaExit(Sender: TObject);
begin
  inherited;
  VerificaSequenciaNumeros(Sender);
end;

procedure TFrmConfiguracoesSicsPA.edtGruposTagsLayoutListaKeyPress(
  Sender: TObject; var Key: Char);
begin
  inherited;
  SomenteNumeros(Key);
end;

procedure TFrmConfiguracoesSicsPA.edtGruposTagsSomenteLeituraExit(
  Sender: TObject);
begin
  inherited;
  VerificaSequenciaNumeros(Sender);
end;

procedure TFrmConfiguracoesSicsPA.edtGruposTagsSomenteLeituraKeyPress(
  Sender: TObject; var Key: Char);
begin
  inherited;
  SomenteNumeros(Key);
end;

procedure TFrmConfiguracoesSicsPA.edtID_PAChange(Sender: TObject);
begin
  cboNomePA.KeyValue := StrToIntDef(edtID_PA.Text, -1);
end;

procedure TFrmConfiguracoesSicsPA.edtPAsPermitidasExit(Sender: TObject);
begin
  inherited;
  VerificaSequenciaNumeros(Sender);
end;

procedure TFrmConfiguracoesSicsPA.edtPAsPermitidasKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  SomenteNumeros(Key);
end;

procedure TFrmConfiguracoesSicsPA.SetDefaultConfig;
begin
  inherited;
  cboNomePA.KeyValue := CDSConfig.FieldByName('ID_PA').Value;
end;

end.
