unit untMainForm;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  {$IFNDEF IS_MOBILE}
  Winapi.Windows,
  {$ENDIF IS_MOBILE}

  System.UITypes,
  System.SysUtils, System.Types, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts,  System.UIConsts,
  untCommonFrameBase,
  FMX.Edit, FMX.Grid, System.Rtti, untCommonFormBaseOnLineTGS, FMX.Platform,
  MyAspFuncoesUteis,FMX.ListBox,
  FMX.Menus, FMX.Controls.Presentation, System.ImageList,
  FMX.ImgList, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components, FMX.SearchBox, System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.DBScope, Data.DB,
  Datasnap.DBClient,untCommonFormStyleBook, FMX.Effects, FMX.TabControl, FMX.Ani,FMX.Platform.Win;

{$INCLUDE ..\SicsVersoes.pas}

type
  TMainForm = class(TFrmBase_OnLine_TGS)
    layCenter: TLayout;
    imgResources: TImageList;
    imgResources20x20: TImageList;
    tmrBuscaSituacaoFila: TTimer;
    stb1: TStyleBook;
    rectLogo: TRectangle;
    scrollMenu: TVertScrollBox;
    rectMenu: TRectangle;
    btnSituacaoAtendimento: TButton;
    btnRelatorios: TButton;
    btnConfiguracoes: TButton;
    btnDashboard: TButton;
    rectBarraTop: TRectangle;
    lblSics: TLabel;
    lblSistemaInteligente: TLabel;
    imgIconSituacaoAtendimento: TImage;
    lblSituacaoAtendimento: TLabel;
    imgIconRelatorios: TImage;
    lblRelatorios: TLabel;
    imgConfiguracoes: TImage;
    lblConfiguracoes: TLabel;
    imgIconDashboard: TImage;
    lblDashboard: TLabel;
    imgLogo: TImage;
    imgSetaSituacaoAtendimento: TImage;
    lytSubMenu: TLayout;
    lstSubMenu: TListBox;
    lstItemIndicadorPerformance: TListBoxItem;
    lstItemSituacaoAtendimento: TListBoxItem;
    lstItemSituacaoFila: TListBoxItem;
    lstItemEsperasAtendimento: TListBoxItem;
    lstItemPausas: TListBoxItem;
    lstItemProcessosParalelos: TListBoxItem;
    lstItemPrioridadesAtendimento: TListBoxItem;
    lstItemPainelEletronico: TListBoxItem;
    lstItemImpressoraSenhas: TListBoxItem;
    lstItemAtendentes: TListBoxItem;
    lstItemDefinicaoIndicadores: TListBoxItem;
    lstItemDefinicoesHorarios: TListBoxItem;
    lstItemAlarmes: TListBoxItem;
    imgSetaConfiguracoes: TImage;
    imgSetaRelatorios: TImage;
    imgSetaDashboard: TImage;
    lstItensOcultos: TListBox;
    lytSubMenuPI: TLayout;
    lstSubMenuPI: TListBox;
    lstItemIndicadoresPerformance: TListBoxItem;
    lstItemDashboardConfig: TListBoxItem;
    lstItemDashboard: TListBoxItem;
    lytUnidadeAtiva: TLayout;
    Rectangle1: TRectangle;
    cbbUnidadeAtiva: TComboBox;
    lstItemClientes: TListBoxItem;
    lstItemSitef: TListBoxItem;
    lstItemTempoAtendimentoTotem: TListBoxItem;
    procedure ExitBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure menuTraySairClick(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure FormActivate(Sender: TObject);
    procedure tmrBuscaSituacaoFilaTimer(Sender: TObject);
    procedure lstItemIndicadorPerformanceClick(Sender: TObject);
    procedure lstItem2Click(Sender: TObject);
    procedure btnSituacaoAtendimentoClick(Sender: TObject);
    procedure btnRelatoriosClick(Sender: TObject);
    procedure btnConfiguracoesClick(Sender: TObject);
    procedure btnDashboardClick(Sender: TObject);
    procedure lstItemEsperasAtendimentoClick(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lstItemAlarmesClick(Sender: TObject);
    procedure lstItemAtendentesClick(Sender: TObject);
    procedure lstItemDefinicaoIndicadoresClick(Sender: TObject);
    procedure lstItemDefinicoesHorariosClick(Sender: TObject);
    procedure lstItemImpressoraSenhasClick(Sender: TObject);
    procedure lstItemPainelEletronicoClick(Sender: TObject);
    procedure lstItemPausasClick(Sender: TObject);
    procedure lstItemPrioridadesAtendimentoClick(Sender: TObject);
    procedure lstItemProcessosParalelosClick(Sender: TObject);
    procedure lstItemSituacaoAtendimentoClick(Sender: TObject);
    procedure lstItemSituacaoFilaClick(Sender: TObject);
    procedure lstItemIndicadoresPerformanceClick(Sender: TObject);
    procedure cbbUnidadeAtivaChange(Sender: TObject);
    procedure lstItemDashboardConfigClick(Sender: TObject);
    procedure lstItemDashboardClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure lstItemClientesClick(Sender: TObject);
    procedure imgSetaAbrirClick(Sender: TObject);
    procedure lstItemSitefClick(Sender: TObject);
    procedure lstItemTempoAtendimentoTotemClick(Sender: TObject);
  private
    procedure MyExceptionHandler(Sender: TObject; E: Exception);
    procedure GetAllParameters(const aIdUnidade: Integer);
    procedure ApresentarSelecaoMultiUnidades;
    procedure AoMudarStatusConexaoUnidade(const aIdUnidade: Integer;
      const aConectada: Boolean);
  protected

    procedure SetIDUnidade(const Value: Integer); override;
    procedure DesabilitarComponentes(const aIdUnidade: Integer); Override;
    procedure SetModoConexaoAtual(const aIdUnidade: Integer; const Value: Boolean); Override;
    function GetIsIndexOfFrame(const aCurrentIndex: Integer; const aClass: TClass): Boolean; Override;
    procedure AgruparGrupoMenu(const aIndexGrupo: Integer; const aExpandir: Boolean = True); Overload;
    procedure AgruparGrupoMenu(const aIndexGrupo: Integer; const aListBoxItem: TListBoxItem); Overload;
    procedure AgruparTordosGrupoMenu(const aExpandir: Boolean = True);
    procedure OrganizaSubMenu(Sender : TObject);

  public
    constructor Create(AOwner: TComponent); override;

    procedure ExibirFrame(const aIndexItem: Integer); Override;
    procedure CarregarParametrosINI; Override;
    procedure CarregarParametrosDB; Overload; Override;
    procedure CarregarParametrosDB(const aIDUnidade: Integer); Overload; Override;
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    procedure DesabilitaListBoxItem;
    function  GetLstItem(index : Integer) : TListBoxItem;
    procedure desabilitaBotoes(desabilita :boolean);
    procedure AbrirFrameDashboard;
    procedure Fechar;
  end;

var
  MainForm: TMainForm;

const
  //INDEX_GRUPO_SituacaoAtend = 0;

  INDEX_Lines = 0;
  INDEX_SituacaoAtendimento = INDEX_Lines + 1;
  INDEX_IndicadorPerformance =  INDEX_SituacaoAtendimento + 1 ;

//  INDEX_GRUPO_Relatorio = INDEX_Lines + 1;
  INDEX_EsperasEAtendimentos = INDEX_IndicadorPerformance + 1;
  INDEX_Pausas = INDEX_EsperasEAtendimentos + 1;
  INDEX_ProcessosParalelos = INDEX_Pausas + 1;

//  INDEX_GRUPO_Config = INDEX_ProcessosParalelos + 1;
  INDEX_PrioridadesDeAtendimento = INDEX_ProcessosParalelos + 1;
  INDEX_PainelEletronico = INDEX_PrioridadesDeAtendimento + 1;
  INDEX_ImpressoraDeSenhas = INDEX_PainelEletronico + 1;
  INDEX_Atendentes = INDEX_ImpressoraDeSenhas + 1;
  INDEX_Clientes   = INDEX_Atendentes + 1;

  INDEX_Dashboard = INDEX_Clientes + 1;
  INDEX_DashboardConfig = INDEX_Dashboard + 1;

  INDEX_GRUPO_IndicadorPerforma = INDEX_DashboardConfig + 1;
  INDEX_DefiniesDeIndicadores = INDEX_GRUPO_IndicadorPerforma + 1;
  INDEX_DefiniesDeHorarios = INDEX_DefiniesDeIndicadores + 1;
  INDEX_Alarmes = INDEX_DefiniesDeHorarios + 1;
  INDEX_Sitef = INDEX_Alarmes + 1;
  INDEX_PesquisaSatisfacao = INDEX_Sitef + 1;
  INDEX_TempoAtendimentoTotem = INDEX_PesquisaSatisfacao + 1;

implementation

{$R *.fmx}

uses
  untCommonDMClient, Sics_Common_Parametros, untCommonFrameIndicadorPerformance,
  untCommonFrameSituacaoAtendimento, ufrmLines, ufrmDadosPorUnidade,
  ufrmMensagemPainelEImpressora, udmCadPIS, ufrmCadPIS, udmCadHor, ufrmCadHor,
  ufrmCadAlarmes, ufrmConfiguraTabela, untCommonFormProcessoParalelo,
  ufrmConfigPrioridades, Sics_Common_Splash, ufrmPesquisaRelatorio,
  ufrmPesquisaRelatorioPausas, ufrmPesquisaRelatorioPP, ufrmCadBase,
  untCommonDMConnection, untCommonDMUnidades, ufrmDashboard,
  ufrmDashboardConfig,untCommonControleInstanciaAplicacao,ufrmPesquisaRelatorioSitef,
  ufrmPesquisaRelatorioTotem;

procedure TMainForm.CarregarParametrosDB;
begin
  lstItemIndicadoresPerformance.Enabled := vgParametrosModulo.PodeConfigIndDePerformance;
  lstItemAtendentes.Enabled             := vgParametrosModulo.PodeConfigAtendentes;
  lstItemPrioridadesAtendimento.Enabled := vgParametrosModulo.PodeConfigPrioridadesAtend;
  lstItemIndicadoresPerformance.Enabled := vgParametrosModulo.PodeConfigIndDePerformance;

  if vgParametrosModulo.ModoCallCenter then
  begin
    lstItemAtendentes.Text  := 'Coordenadores';
    lstItemClientes.Text    := 'Atendentes';
    btnDashboard.Visible    := dmUnidades.Quantidade > 1;;
  end;

  inherited;
end;

procedure TMainForm.CarregarParametrosDB(const aIDUnidade: Integer);
begin
  inherited;
end;

procedure TMainForm.CarregarParametrosINI;
begin
  inherited;
end;

procedure TMainForm.cbbUnidadeAtivaChange(Sender: TObject);
var
  LIdUnidadeSelecionada: Integer;
  LDMConnectionAtual, LDMConnectionNovo: TDMConnection;
  LfrmSicsConfigPrioridades: TFrmSicsConfigPrioridades;
begin
  LIdUnidadeSelecionada :=
    dmUnidades.IdUnidadeConformePosicaoNaLista(cbbUnidadeAtiva.ItemIndex+1);
  if LIdUnidadeSelecionada = IDUnidade then
    exit;

  LDMConnectionAtual := DMConnection(IDUnidade, CRIAR_SE_NAO_EXISTIR);
  LDMConnectionNovo  := DMConnection(LIdUnidadeSelecionada, CRIAR_SE_NAO_EXISTIR);
  if Assigned(LDMConnectionAtual) and Assigned(LDMConnectionNovo) then
  begin
    LDMConnectionAtual.tmrReconnect.Enabled := False;
    LDMConnectionAtual.ClientSocketPrincipal.Disconnect(False);
    LDMConnectionAtual.ClientSocketContingente.Disconnect(False);

    LDMConnectionNovo.tmrReconnect.Enabled := True;
    LDMConnectionNovo.tmrReconnectTimer(LDMConnectionNovo.tmrReconnect);
  end;

  dmUnidades.UnidadeAtiva := LIdUnidadeSelecionada;
  IDunidade := dmUnidades.UnidadeAtiva;

  LfrmSicsConfigPrioridades := FrmSicsConfigPrioridades(IDUnidade, CRIAR_SE_NAO_EXISTIR);
  LfrmSicsConfigPrioridades.cdsPAs.Close;
  LfrmSicsConfigPrioridades.cdsPAs.Open;
end;

constructor TMainForm.Create(AOwner: TComponent);
begin
  inherited;
  Self.Caption := 'SICS - Módulo TGS';
  Application.OnException := MyExceptionHandler;
  OrganizaSubMenu(nil);
end;

procedure TMainForm.desabilitaBotoes(desabilita: boolean);
begin
  btnSituacaoAtendimento.Enabled := desabilita;
  btnRelatorios.Enabled := desabilita;
  btnConfiguracoes.Enabled := desabilita;
  btnDashboard.Enabled    := desabilita;
  lstSubMenu.Enabled:= desabilita;
end;

procedure TMainForm.AbrirFrameDashboard;
var
  frame: TFrameBase;
begin
  frame := TFrameBase(ExibeFormPorUnidade(@FraDashboard));
  frame.botaoMenu := btnSituacaoAtendimento;
  frame.imgSeta := imgSetaSituacaoAtendimento;
  frame.botaoSubMenu := lstItemIndicadorPerformance;
  frame.lytSubMenu := lytSubMenu;
end;

procedure TMainForm.ExibirFrame(const aIndexItem: Integer);
var
  lListBoxItem: TListBoxItem;
  frame : TFrameBase;
  LfrmSicsConfigPrioridades: TfrmSicsConfigPrioridades;
  LfrmMensagemPainelEImpressora: TfrmMensagemPainelEImpressora;
  LFrmSicsConfiguraTabela: TfrmSicsConfiguraTabela;
  LFrmSicsCadPIS: TfrmSicsCadPIS;
  LFrmSicsCadHor: TfrmSicsCadHor;
  LFrmSicsCadAlarmes: TFrmSicsCadAlarmes;
  frmPesquisaRelatorioSitef : TfrmPesquisaRelatorioSitef;

  procedure SetFrameAtivo(const AFrame: TFrameBase);
  var
    LProcZerarFrameAtivoAoFechar: TProcOnHide;
  begin
    LProcZerarFrameAtivoAoFechar := procedure (Sender: TObject) begin
                                      FFrameAtivo := nil;
                                    end;
    FFrameAtivo := AFrame;
    FFrameAtivo.AddOnClose(LProcZerarFrameAtivoAoFechar)
  end;

begin
  inherited;
  if (aIndexItem <= -1) then
    Exit;
  lListBoxItem := GetLstItem(aIndexItem) ;
  if not (lListBoxItem.Enabled) then
    Exit;

  if lytSubMenuPI.Visible then
  begin
    TAnimator.AnimateFloatWait(lytSubMenuPI, 'opacity', 0, 0.1);
    lytSubMenuPI.Visible := False;
  end;

  case (aIndexItem) of
    {$REGION 'Grupo Situação em tempo real'}
    INDEX_IndicadorPerformance:
      begin
        frame := TFrameBase(ExibeFormPorUnidade(@FraIndicadorPerformance));
        frame.botaoMenu := btnSituacaoAtendimento;
        frame.imgSeta := imgSetaSituacaoAtendimento;
        frame.botaoSubMenu := lstItemIndicadorPerformance;
        frame.lytSubMenu := lytSubMenu;
        SetFrameAtivo(frame);
      end;
    INDEX_SituacaoAtendimento:
      begin
        frame := TFrameBase(ExibeFormPorUnidade(@FraSituacaoAtendimento));
        frame.botaoMenu := btnSituacaoAtendimento;
        frame.imgSeta := imgSetaSituacaoAtendimento;
        frame.botaoSubMenu := lstItemSituacaoAtendimento;
        frame.lytSubMenu := lytSubMenu;
        SetFrameAtivo(frame);
      end;
    INDEX_Lines:
      begin
        frame := TFrameBase(ExibeFormPorUnidade(@frmLines));
        frame.botaoMenu := btnSituacaoAtendimento;
        frame.imgSeta := imgSetaSituacaoAtendimento;
        frame.botaoSubMenu := lstItemSituacaoFila;
        frame.lytSubMenu := lytSubMenu;
        SetFrameAtivo(frame);
      end;
    INDEX_Dashboard:
      begin
        AbrirFrameDashboard;
      end;
    {$ENDREGION}

    {$REGION 'Grupo Relatórios'}
    INDEX_EsperasEAtendimentos:
      begin
        ExibeFormPorUnidade(@frmSicsPesquisaRelatorio);
      end;
    INDEX_Pausas:
      begin
        ExibeFormPorUnidade(@frmSicsPesquisaRelatorioPausas);
      end;
    INDEX_ProcessosParalelos:
      begin
        ExibeFormPorUnidade(@frmSicsPesquisaRelatorioPP);
      end;
    INDEX_Sitef:
      begin
        frmPesquisaRelatorioSitef := TfrmPesquisaRelatorioSitef.Create(Self);
        frmPesquisaRelatorioSitef.lblCaption.Text := 'Relatório Sitef';
        frmPesquisaRelatorioSitef.ShowModal;
        frmPesquisaRelatorioSitef.DisposeOf;
        frmPesquisaRelatorioSitef := nil;
      end;
    INDEX_TempoAtendimentoTotem:
      begin
        ExibeFormPorUnidade(@frmSicsPesquisaRelatorioTotem);
      end;
    {$ENDREGION}

    {$REGION 'Grupo Configurações'}
    INDEX_PrioridadesDeAtendimento:
      begin
        LfrmSicsConfigPrioridades := FrmSicsConfigPrioridades(IDUnidade, CRIAR_SE_NAO_EXISTIR);

        try
          LfrmSicsConfigPrioridades.ProcIDUnidade :=
            procedure(IDUnidade: Integer)
            begin
              DMConnection(IDUnidade, not CRIAR_SE_NAO_EXISTIR)
                .EnviarComando(cProtocoloPAVazia + Chr($26), IdUnidade);
            end;

          ExibeFormPorUnidade(LfrmSicsConfigPrioridades);
          LfrmSicsConfigPrioridades.botaoMenu := btnConfiguracoes;
          LfrmSicsConfigPrioridades.imgSeta := imgSetaConfiguracoes;
          LfrmSicsConfigPrioridades.botaoSubMenu := lstItemPrioridadesAtendimento;
          LfrmSicsConfigPrioridades.lytSubMenu := lytSubMenu;
          SetFrameAtivo(LfrmSicsConfigPrioridades);
          LfrmSicsConfigPrioridades.cbbPA.ItemIndex := 0;
          LfrmSicsConfigPrioridades.btnIncluir.SetFocus;
        finally
        end;
      end;
    INDEX_PainelEletronico:
      begin
        LfrmMensagemPainelEImpressora := frmMensagemPainelEImpressora(IDUnidade, CRIAR_SE_NAO_EXISTIR);

        try
          LfrmMensagemPainelEImpressora.TipoDeConfiguracao := tcPainel;
          LfrmMensagemPainelEImpressora.ProcPainel :=
            procedure(IdPainel: Integer; aMensagem: String; IdUnidade: Integer)
            begin
              DMConnection(IDUnidade, not CRIAR_SE_NAO_EXISTIR)
                .EnviarComando(cProtocoloPAVazia + Chr($2B) +
                               TAspEncode.AspIntToHex(IdPainel, 4) + aMensagem,
                               IdUnidade);
            end;
          ExibeFormPorUnidade(LfrmMensagemPainelEImpressora);
          LfrmMensagemPainelEImpressora.botaoMenu := btnConfiguracoes;
          LfrmMensagemPainelEImpressora.botaoSubMenu := lstItemPainelEletronico;
          LfrmMensagemPainelEImpressora.imgSeta := imgSetaConfiguracoes;
          LfrmMensagemPainelEImpressora.lytSubMenu := lytSubMenu;
          SetFrameAtivo(LfrmMensagemPainelEImpressora);
        finally
        end;
      end;
    INDEX_ImpressoraDeSenhas:
      begin
        LFrmMensagemPainelEImpressora := frmMensagemPainelEImpressora(IDUnidade, CRIAR_SE_NAO_EXISTIR);

        try
          LFrmMensagemPainelEImpressora.TipoDeConfiguracao := tcImpressora;
          LFrmMensagemPainelEImpressora.ProcPainel :=
            procedure(IdPrinter: Integer; aMensagem: String; IdUnidade: Integer)
            begin
              DMConnection(IDUnidade, not CRIAR_SE_NAO_EXISTIR)
                .EnviarComando(cProtocoloPAVazia + Chr($2C) + TAspEncode.AspIntToHex(IdPrinter,4) + aMensagem, IdUnidade);
            end;
          ExibeFormPorUnidade(LFrmMensagemPainelEImpressora);
          LfrmMensagemPainelEImpressora.botaoMenu := btnConfiguracoes;
          LfrmMensagemPainelEImpressora.botaoSubMenu := lstItemImpressoraSenhas;
          LfrmMensagemPainelEImpressora.imgSeta := imgSetaConfiguracoes;
          LfrmMensagemPainelEImpressora.lytSubMenu := lytSubMenu;
          SetFrameAtivo(LfrmMensagemPainelEImpressora);
        finally
        end;
      end;
    INDEX_Atendentes:
      begin
        LFrmSicsConfiguraTabela := FrmSicsConfiguraTabela(IDUnidade, CRIAR_SE_NAO_EXISTIR);

         try
           LFrmSicsConfiguraTabela.ConfigurandoTabela := ctAtendentes;
           LFrmSicsConfiguraTabela.ProcUnidade :=
             procedure(IDUnidade: Integer)
             begin
               DMConnection(IDUnidade, not CRIAR_SE_NAO_EXISTIR)
                 .EnviarComando(cProtocoloPAVazia + Chr($7A) + 'A', IdUnidade);
             end;
           ExibeFormPorUnidade(LFrmSicsConfiguraTabela);
           LFrmSicsConfiguraTabela.botaoMenu := btnConfiguracoes;
           LFrmSicsConfiguraTabela.imgSeta := imgSetaConfiguracoes;
           LFrmSicsConfiguraTabela.botaoSubMenu := lstItemAtendentes;
           LFrmSicsConfiguraTabela.lytSubMenu := lytSubMenu;
           LFrmSicsConfiguraTabela.ExibirOcultarCampoBusca(false);
           SetFrameAtivo(LFrmSicsConfiguraTabela);
         finally
         end;
      end;
    INDEX_Clientes:
      begin
        LFrmSicsConfiguraTabela := FrmSicsConfiguraTabela(IDUnidade, CRIAR_SE_NAO_EXISTIR);

         try
           LFrmSicsConfiguraTabela.ConfigurandoTabela := ctClientes;
           LFrmSicsConfiguraTabela.ProcUnidade :=
             procedure(IDUnidade: Integer)
             begin
               DMConnection(IDUnidade, not CRIAR_SE_NAO_EXISTIR)
                 .EnviarComando(cProtocoloPAVazia + Chr($7A) + 'L', IdUnidade);
             end;
           ExibeFormPorUnidade(LFrmSicsConfiguraTabela);
           LFrmSicsConfiguraTabela.botaoMenu := btnConfiguracoes;
           LFrmSicsConfiguraTabela.imgSeta := imgSetaConfiguracoes;
           LFrmSicsConfiguraTabela.botaoSubMenu := lstItemAtendentes;
           LFrmSicsConfiguraTabela.lytSubMenu := lytSubMenu;
           LFrmSicsConfiguraTabela.ExibirOcultarCampoBusca(false);
           SetFrameAtivo(LFrmSicsConfiguraTabela);
         finally
         end;
      end;
    INDEX_DashboardConfig:
      begin
        frame := TFrameBase(ExibeFormPorUnidade(@fraDashboardConfig));
        frame.botaoMenu := btnConfiguracoes;
        frame.imgSeta := imgSetaConfiguracoes;
        frame.botaoSubMenu := lstItemDashboardConfig;
        frame.lytSubMenu := lytSubMenu;
        SetFrameAtivo(frame);
      end;
    {$ENDREGION}

    {$REGION 'Grupo Ind. Performace'}
    INDEX_GRUPO_IndicadorPerforma :
      begin
        OcultaTodosFrames(nil);
        lytSubMenuPI.Opacity := 0;
        lytSubMenuPI.Visible := True;
        TAnimator.AnimateFloat(lytSubMenuPI, 'opacity', 1, 0.1);
      end;
    INDEX_DefiniesDeIndicadores:
      begin
        LFrmSicsCadPIS := FrmSicsCadPIS(IDUnidade, CRIAR_SE_NAO_EXISTIR);

        ExibeFormPorUnidade(LFrmSicsCadPIS);
        LFrmSicsCadPIS.botaoMenu := btnConfiguracoes;
        LFrmSicsCadPIS.imgSeta := imgSetaConfiguracoes;
        LFrmSicsCadPIS.lytSubMenu := lytSubMenu;
        LFrmSicsCadPIS.botaoSubMenu := lstItemIndicadorPerformance;
        LFrmSicsCadPIS.botaoSubMenuPI := lstItemDefinicaoIndicadores;
        SetFrameAtivo(LFrmSicsCadPIS);
      end;
    INDEX_DefiniesDeHorarios:
      begin
        LFrmSicsCadHor := FrmSicsCadHor(IDUnidade, CRIAR_SE_NAO_EXISTIR);

        ExibeFormPorUnidade(LFrmSicsCadHor);
        LFrmSicsCadHor.botaoMenu := btnConfiguracoes;
        LFrmSicsCadHor.botaoSubMenu := lstItemIndicadorPerformance;
        LFrmSicsCadHor.lytSubMenu := lytSubMenu;
        LFrmSicsCadHor.imgSeta := imgSetaConfiguracoes;
        LFrmSicsCadHor.botaoSubMenuPI := lstItemDefinicoesHorarios;
        SetFrameAtivo(LFrmSicsCadHor);
      end;
    INDEX_Alarmes:
      begin
        LFrmSicsCadAlarmes := FrmSicsCadAlarmes(IDunidade, CRIAR_SE_NAO_EXISTIR);
        LFrmSicsCadAlarmes.AtualizarPIS;

        ExibeFormPorUnidade(LFrmSicsCadAlarmes);
        LFrmSicsCadAlarmes.botaoMenu := btnConfiguracoes;
        LFrmSicsCadAlarmes.imgSeta := imgSetaConfiguracoes;
        LFrmSicsCadAlarmes.botaoSubMenu := lstItemIndicadorPerformance;
        LFrmSicsCadAlarmes.lytSubMenu := lytSubMenu;
        LFrmSicsCadAlarmes.botaoSubMenuPI := lstItemAlarmes;
        SetFrameAtivo(LFrmSicsCadAlarmes);
      end;
    {$ENDREGION}

  else
    Exit;
  end;
  if Assigned(LListBoxItem) then
  begin
    LListBoxItem.Selectable := true;
    LListBoxItem.IsSelected := True;
  end;
end;

procedure TMainForm.Fechar;
begin
Application.Terminate;
end;

procedure TMainForm.FormActivate(Sender: TObject);
var
  LOldFirtActivate: Boolean;
begin
  LOldFirtActivate := FFirstActivate;
  inherited;
  if LOldFirtActivate then
  begin
    dmUnidades.FormClient := Self;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  inherited;
  lstItensOcultos.Visible := False;
  lytSubMenuPI.Visible := False;
  TdmControleInstanciaAplicacao.Create(self).Tela := self;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
 inherited;

  If FFrameAtivo is TfrmSicsConfigPrioridades Then
     FFrameAtivo.OnKeyDown(Sender, Key, KeyChar, Shift);
end;

procedure TMainForm.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  inherited;

  if((Button = TMouseButton.mbRight) and(Shift = [ssAlt])) then
    InformationMessage(VERSAO {$IFNDEF IS_MOBILE} + #13#13 + GetExeVersion{$ENDIF IS_MOBILE});
end;

procedure TMainForm.lstItemImpressoraSenhasClick(Sender: TObject);
begin
  inherited;
  ExibirFrame(INDEX_ImpressoraDeSenhas);
end;

procedure TMainForm.lstItemIndicadoresPerformanceClick(Sender: TObject);
begin
  inherited;
  ExibirFrame(INDEX_GRUPO_IndicadorPerforma);
end;

procedure TMainForm.lstItemIndicadorPerformanceClick(Sender: TObject);
begin
  inherited;
  ExibirFrame(INDEX_IndicadorPerformance);
end;

procedure TMainForm.lstItemPainelEletronicoClick(Sender: TObject);
begin
  inherited;
  ExibirFrame(INDEX_PainelEletronico);
end;

procedure TMainForm.lstItemPausasClick(Sender: TObject);
begin
  inherited;
  ExibirFrame(INDEX_Pausas);
end;

procedure TMainForm.lstItemPrioridadesAtendimentoClick(Sender: TObject);
begin
  inherited;
  ExibirFrame(INDEX_PrioridadesDeAtendimento);
end;

procedure TMainForm.lstItemProcessosParalelosClick(Sender: TObject);
begin
  inherited;
  ExibirFrame(INDEX_ProcessosParalelos);
end;

procedure TMainForm.lstItemSitefClick(Sender: TObject);
begin
  inherited;
  ExibirFrame(INDEX_Sitef);
end;

procedure TMainForm.lstItemSituacaoAtendimentoClick(Sender: TObject);
begin
  inherited;
  ExibirFrame(INDEX_SituacaoAtendimento);
end;

procedure TMainForm.lstItemSituacaoFilaClick(Sender: TObject);
begin
  inherited;
  ExibirFrame(INDEX_Lines);
end;

procedure TMainForm.lstItemTempoAtendimentoTotemClick(Sender: TObject);
begin
  inherited;
  ExibirFrame(INDEX_TempoAtendimentoTotem);
end;

procedure TMainForm.lstItemClientesClick(Sender: TObject);
begin
  inherited;
  ExibirFrame(INDEX_Clientes);
end;

procedure TMainForm.lstItem2Click(Sender: TObject);
begin
  inherited;
  ShowMessage('clicou');
end;

procedure TMainForm.lstItemAlarmesClick(Sender: TObject);
begin
  inherited;
  ExibirFrame(INDEX_Alarmes);
end;

procedure TMainForm.lstItemAtendentesClick(Sender: TObject);
begin
  inherited;
  ExibirFrame(INDEX_Atendentes);
end;

procedure TMainForm.lstItemDashboardClick(Sender: TObject);
begin
  inherited;
  ExibirFrame(INDEX_Dashboard);
end;

procedure TMainForm.lstItemDashboardConfigClick(Sender: TObject);
begin
  inherited;
  ExibirFrame(INDEX_DashboardConfig);
end;

procedure TMainForm.lstItemDefinicaoIndicadoresClick(Sender: TObject);
begin
  inherited;
  ExibirFrame(INDEX_DefiniesDeIndicadores);
end;

procedure TMainForm.lstItemDefinicoesHorariosClick(Sender: TObject);
begin
  inherited;
  ExibirFrame(INDEX_DefiniesDeHorarios);
end;

procedure TMainForm.lstItemEsperasAtendimentoClick(Sender: TObject);
begin
  inherited;
  ExibirFrame(INDEX_EsperasEAtendimentos);
end;

procedure TMainForm.MyExceptionHandler(Sender: TObject; E: Exception);
begin
  MyLogException(E);
end;

procedure TMainForm.OrganizaSubMenu(Sender: TObject);
//var
//  i: Integer;
//  lbi: TListBoxItem;
begin
  if( Sender = nil )then
  begin
    TAnimator.AnimateFloatWait(lytSubMenu, 'opacity', 0, 0.1);
    lytSubMenu.Visible := False;
    Exit;
  end;
  lytSubMenu.Opacity := 0;
  lytSubMenu.Visible := True;
  lytSubMenuPI.Visible := false;
  lstSubMenu.BeginUpdate;
  lytUnidadeAtiva.Visible := False;
  try
    while lstSubMenu.Items.Count > 0 do
      lstSubMenu.ItemByIndex(0).Parent := lstItensOcultos;

    btnSituacaoAtendimento.StaysPressed := False;
    imgSetaSituacaoAtendimento.Visible := False;
    btnRelatorios.StaysPressed := False;
    imgSetaRelatorios.Visible := False;
    btnConfiguracoes.StaysPressed := False;
    imgSetaConfiguracoes.Visible := False;
    btnDashboard.StaysPressed := False;
    imgSetaDashboard.Visible := False;
    case (TComponent(Sender).Tag) of
       0 : begin
             OcultaTodosFrames(nil);
             btnSituacaoAtendimento.StaysPressed := True;
             imgSetaSituacaoAtendimento.Visible := True;
             lstItemSituacaoFila.Parent := lstSubMenu;
             lstItemSituacaoFila.Index := INDEX_Lines;
             lstItemIndicadorPerformance.Parent := lstSubMenu;
             lstItemIndicadorPerformance.Index := INDEX_IndicadorPerformance;
             if not vgParametrosModulo.ModoCallCenter then
             begin
               lstItemSituacaoAtendimento.Parent := lstSubMenu;
               lstItemSituacaoAtendimento.Index := INDEX_SituacaoAtendimento;
             end;
             ApresentarSelecaoMultiUnidades;
           end;
       1 : begin
             if vgParametrosModulo.ModoCallCenter then
             begin
               btnRelatorios.StaysPressed := True;
               imgSetaRelatorios.Visible := True;
               lstItemEsperasAtendimento.Parent := lstSubMenu;
               lstItemEsperasAtendimento.Index := INDEX_EsperasEAtendimentos;
               lstItemEsperasAtendimentoClick(lstItemEsperasAtendimento);
             end
             else
             begin
               OcultaTodosFrames(nil);
               btnRelatorios.StaysPressed := True;
               imgSetaRelatorios.Visible := True;
               lstItemEsperasAtendimento.Parent := lstSubMenu;
               lstItemEsperasAtendimento.Index := INDEX_EsperasEAtendimentos;
               lstItemPausas.Parent := lstSubMenu;
               lstItemPausas.Index := INDEX_Pausas;
               lstItemProcessosParalelos.Parent := lstSubMenu;
               lstItemProcessosParalelos.Index := INDEX_ProcessosParalelos;
               lstItemSitef.Parent := lstSubMenu;
               lstItemSitef.Index := INDEX_Sitef;
               lstItemTempoAtendimentoTotem.Parent := lstSubMenu;
               lstItemTempoAtendimentoTotem.Index := INDEX_TempoAtendimentoTotem;
               lstItemTempoAtendimentoTotem.Visible := vgParametrosModulo.MostrarRelatorioTMAA;
             end;
           end;
       2 : begin
             if vgParametrosModulo.ModoCallCenter then
             begin
               OcultaTodosFrames(nil);
               btnConfiguracoes.StaysPressed := True;
               imgSetaConfiguracoes.Visible := True;
               lstItemPrioridadesAtendimento.Parent := lstSubMenu;
               lstItemPrioridadesAtendimento.Index := INDEX_PrioridadesDeAtendimento;
               lstItemAtendentes.Parent := lstSubMenu;
               lstItemAtendentes.Index := INDEX_Atendentes;
               lstItemClientes.Parent := lstSubMenu;
               lstItemClientes.Index := INDEX_Clientes;
             end
             else
             begin
               OcultaTodosFrames(nil);
               btnConfiguracoes.StaysPressed := True;
               imgSetaConfiguracoes.Visible := True;
               lstItemPrioridadesAtendimento.Parent := lstSubMenu;
               lstItemPrioridadesAtendimento.Index := INDEX_PrioridadesDeAtendimento;
               lstItemPainelEletronico.Parent := lstSubMenu;
               lstItemPainelEletronico.Index := INDEX_PainelEletronico;
               lstItemImpressoraSenhas.Parent := lstSubMenu;
               lstItemImpressoraSenhas.Index := INDEX_ImpressoraDeSenhas;
               lstItemAtendentes.Parent := lstSubMenu;
               lstItemAtendentes.Index := INDEX_Atendentes;
             end;


             lstItemIndicadoresPerformance.Parent := lstSubMenu;
             lstItemIndicadoresPerformance.Index := INDEX_GRUPO_IndicadorPerforma;
//             lstItemDefinicaoIndicadores.Parent := lstSubMenu;
//             lstItemDefinicaoIndicadores.Index := INDEX_DefiniesDeIndicadores;
//             lstItemDefinicoesHorarios.Parent := lstSubMenu;
//             lstItemDefinicoesHorarios.Index := INDEX_DefiniesDeHorarios;
//             lstItemAlarmes.Parent := lstSubMenu;
//             lstItemAlarmes.Index := INDEX_Alarmes;
             ApresentarSelecaoMultiUnidades;
           end;
       3 : begin
             OcultaTodosFrames(nil);
             btnDashboard.StaysPressed := True;
             imgSetaDashboard.Visible := True;
             lstItemDashboard.Parent := lstSubMenu;
             lstItemDashboard.Index := INDEX_Dashboard;
             lstItemDashboardConfig.Parent := lstSubMenu;
             lstItemDashboardConfig.Index := INDEX_DashboardConfig;
           end;
    end;

  finally
    lstSubMenu.EndUpdate;
  end;
  TAnimator.AnimateFloat(lytSubMenu, 'opacity', 1, 0.1);
end;


procedure TMainForm.GetAllParameters(const aIdUnidade: Integer);
var
  LDMConnection: TDMConnection;
begin
  LDMConnection := DMConnection(IDUnidade, not CRIAR_SE_NAO_EXISTIR);
  if Assigned(LDMConnection) then
  begin
    LDMConnection.EnviarComando(cProtocoloPAVazia + Chr($29), aIdUnidade);
    LDMConnection.EnviarComando(cProtocoloPAVazia + Chr($34), aIdUnidade);
  end;
end;

function TMainForm.GetIsIndexOfFrame(const aCurrentIndex: Integer; const aClass: TClass): Boolean;
begin
  result := INDEX_VAZIO = aCurrentIndex;
  if (aClass = TFraIndicadorPerformance) then
    Result := INDEX_IndicadorPerformance = aCurrentIndex
  else
  if (aClass = TFraSituacaoAtendimento) then
    Result := INDEX_SituacaoAtendimento = aCurrentIndex
  else
  if (aClass = TfrmLines) then
    Result := INDEX_Lines = aCurrentIndex
  else
  if (aClass = TfrmPesquisaRelatorio) then
    Result := INDEX_EsperasEAtendimentos = aCurrentIndex
  else
  if (aClass = TfrmPesquisaRelatorioPausas) then
    Result := INDEX_Pausas = aCurrentIndex
  else
  if (aClass = TfrmPesquisaRelatorioPP) then
    Result := INDEX_ProcessosParalelos = aCurrentIndex
  else
  if (aClass = TfrmPesquisaRelatorioSitef) then
    Result := INDEX_Sitef = aCurrentIndex
  else
  if (aClass = TfrmSicsConfigPrioridades) then
    Result := INDEX_PrioridadesDeAtendimento = aCurrentIndex
  else
  if (aClass = TfrmMensagemPainelEImpressora) or (aClass = TfrmMensagemPainelEImpressora) then
    Result := ((INDEX_PainelEletronico = aCurrentIndex) or (INDEX_ImpressoraDeSenhas = aCurrentIndex))
  else
  if (aClass = TfrmSicsConfiguraTabela) then
    Result := INDEX_Atendentes = aCurrentIndex
  else
  if (aClass = TfrmSicsCadPIS) then
    Result :=  INDEX_DefiniesDeIndicadores = aCurrentIndex
  else
  if (aClass = TfrmSicsCadHor) then
    Result := INDEX_DefiniesDeHorarios = aCurrentIndex
  else
  if (aClass = TFrmSicsCadAlarmes) then
    Result :=  INDEX_Alarmes = aCurrentIndex;
end;

function TMainForm.GetLstItem(index: Integer): TListBoxItem;
begin
  Result := nil;

  case (index) of
    INDEX_IndicadorPerformance:     Result := lstItemIndicadorPerformance;
    INDEX_SituacaoAtendimento:      Result := lstItemSituacaoAtendimento;
    INDEX_Lines:                    Result := lstItemSituacaoFila;
    INDEX_EsperasEAtendimentos:     Result := lstItemEsperasAtendimento;
    INDEX_Pausas:                   Result := lstItemPausas;
    INDEX_ProcessosParalelos:       Result := lstItemProcessosParalelos;
    INDEX_Sitef:                    Result := lstItemSitef;
    INDEX_TempoAtendimentoTotem:    Result := lstItemTempoAtendimentoTotem;
    INDEX_PrioridadesDeAtendimento: Result := lstItemPrioridadesAtendimento;
    INDEX_PainelEletronico:         Result := lstItemPainelEletronico;
    INDEX_ImpressoraDeSenhas:       Result := lstItemImpressoraSenhas;
    INDEX_Atendentes:               Result := lstItemAtendentes;
    INDEX_Clientes:                 Result := lstItemClientes;
    INDEX_DefiniesDeIndicadores:    Result := lstItemDefinicaoIndicadores;
    INDEX_DefiniesDeHorarios:       Result := lstItemDefinicoesHorarios;
    INDEX_Alarmes:                  Result := lstItemAlarmes;
    INDEX_GRUPO_IndicadorPerforma:  Result := lstItemIndicadoresPerformance;
    INDEX_Dashboard:                Result := lstItemDashboard;
    INDEX_DashboardConfig:          Result := lstItemDashboardConfig;
  end;
end;

procedure TMainForm.imgSetaAbrirClick(Sender: TObject);
begin
  inherited;

end;

{ proc GetAllParameters }

procedure TMainForm.AgruparGrupoMenu(const aIndexGrupo: Integer; const aExpandir: Boolean);
begin

end;

procedure TMainForm.AfterConstruction;
begin
  inherited;

  if not vgParametrosModulo.JaEstaConfigurado then
    AgruparTordosGrupoMenu(False);
end;

procedure TMainForm.AgruparGrupoMenu(const aIndexGrupo: Integer; const aListBoxItem: TListBoxItem);
begin
  if not Assigned(aListBoxItem) then
    Exit;

  AgruparGrupoMenu(aIndexGrupo, (aListBoxItem.Tag = 0));
end;

procedure TMainForm.AgruparTordosGrupoMenu(const aExpandir: Boolean);
begin
 { AgruparGrupoMenu(INDEX_GRUPO_SituacaoAtend, aExpandir);
  AgruparGrupoMenu(INDEX_GRUPO_Relatorio, aExpandir);
  AgruparGrupoMenu(INDEX_GRUPO_Config, aExpandir);
  AgruparGrupoMenu(INDEX_GRUPO_IndicadorPerforma, aExpandir);}
end;

procedure TMainForm.BeforeDestruction;
begin
  inherited;
end;

procedure TMainForm.btn1Click(Sender: TObject);
begin
  inherited;
  ShowMessage(Inttostr(ApplicationHWND));
end;

procedure TMainForm.btnConfiguracoesClick(Sender: TObject);
begin
  inherited;
  OrganizaSubMenu(Sender);
end;

procedure TMainForm.btnDashboardClick(Sender: TObject);
begin
  inherited;
  OrganizaSubMenu(Sender);
end;

procedure TMainForm.btnRelatoriosClick(Sender: TObject);
begin
  inherited;
  OrganizaSubMenu(Sender);
end;

procedure TMainForm.btnSituacaoAtendimentoClick(Sender: TObject);
begin
  inherited;
  OrganizaSubMenu(Sender);
end;

procedure TMainForm.ExitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.AoMudarStatusConexaoUnidade(
  const aIdUnidade: Integer; const aConectada: Boolean);
var
  LPosicao: Integer;
begin
  LPosicao := dmUnidades.PosicaoNaLista(aIdUnidade)-1;
  if LPosicao >= 0 then
  begin
    if aConectada then
      cbbUnidadeAtiva.ListItems[LPosicao].FontColor := TAlphaColorRec.Black
    else
      cbbUnidadeAtiva.ListItems[LPosicao].FontColor := TAlphaColorRec.Red;
  end;
end;

procedure TMainForm.FormShow(Sender: TObject);
var
  LOldChange: TNotifyEvent;
  i: Integer;
begin
  inherited;

  dmUnidades.OnChangeStatusConexao := AoMudarStatusConexaoUnidade;

  LOldChange := cbbUnidadeAtiva.OnChange;
  try
    cbbUnidadeAtiva.OnChange := nil;
    cbbUnidadeAtiva.BeginUpdate;
    try
      cbbUnidadeAtiva.Clear;
      dmUnidades.PreencherListaUnidades(cbbUnidadeAtiva.Items,
                                        dmUnidades.cdsUnidadesNOME.FieldName);
      //percorre os itens do combobox deixando-os em vermelho
      for i := 0 to cbbUnidadeAtiva.Items.Count-1 do
      begin
        with cbbUnidadeAtiva.ListItems[i] do
        begin
          if not dmUnidades.Conectada[dmUnidades.IdUnidadeConformePosicaoNaLista(i+1)] then
          begin
            StyledSettings := StyledSettings - [TStyledSetting.FontColor];
            FontColor      := TAlphaColorRec.Red;
          end;
        end;
      end;
    finally
      cbbUnidadeAtiva.EndUpdate;
    end;
    cbbUnidadeAtiva.ItemIndex := dmUnidades.PosicaoNaLista(dmUnidades.UnidadeAtiva)-1;
  finally
    cbbUnidadeAtiva.OnChange := LOldChange;
  end;

  IDUnidade := dmUnidades.UnidadeAtiva;
  ApresentarSelecaoMultiUnidades;

  Application.Title := 'SICS - Terminal Gerenciador do Sistema(' +
    vgParametrosModulo.Unidade + ')';
  if(dmUnidades.cdsUnidades.Active and
    (dmUnidades.Quantidade <= 1)) then
    Self.Caption := 'SICS - Módulo TGS - ' + vgParametrosModulo.Unidade;

  if(vgParametrosModulo.Unidade = '')then
  Self.Caption := 'SICS - Módulo TGS'
end;

procedure TMainForm.DesabilitaListBoxItem;
begin
end;

procedure TMainForm.DesabilitarComponentes(const aIdUnidade: Integer);
begin
  if not ((Self.ComponentCount > 0) and (aIdUnidade = IDUnidade)) then
    Exit;

  DefinirCor(Self, layCenter, CorConectado, CorDesconectado, True);

  Self.Invalidate;
end;

procedure TMainForm.menuTraySairClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.SetIDUnidade(const Value: Integer);
begin
  if (IDUnidade <> Value) then
  begin
    //***ExibeSomenteOFrame(nil);

    inherited;
  end;
end;

procedure TMainForm.SetModoConexaoAtual(const aIdUnidade: Integer; const Value: Boolean);
begin
  inherited;

  if Value then
    GetAllParameters(aIdUnidade);
end;

procedure TMainForm.tmrBuscaSituacaoFilaTimer(Sender: TObject);
begin
  inherited;
  DMConnection(IDUnidade, not CRIAR_SE_NAO_EXISTIR)
    .EnviarComando(cProtocoloPAVazia + Chr($34), FIDUnidade);
end;

procedure TMainForm.ApresentarSelecaoMultiUnidades;
begin
  lytUnidadeAtiva.Visible := dmUnidades.Quantidade > 1;
  //LM
  btnDashboard.Visible    := dmUnidades.Quantidade > 1;;
end;

procedure CloseForm(aForm: TForm);
begin
  if Assigned(aForm) and aForm.Visible then
    aForm.Close;
end;

procedure CloseFrame(aFrame: TFrame);
begin
  if Assigned(aFrame) and aFrame.Visible then
    aFrame.Visible := False;
end;

initialization

MainForm := nil;

end.
