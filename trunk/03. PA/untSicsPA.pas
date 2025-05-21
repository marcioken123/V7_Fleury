unit untSicsPA;

{$INCLUDE ..\AspDefineDiretivas.inc}

interface

uses
  System.SysUtils, MyAspFuncoesUteis, untCommonFormBasePA, untScreenSaver,
  System.Types, System.UITypes, System.Classes, System.Variants, FMX.Types,
  FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, FMX.Objects,
  FMX.Layouts, FMX.Edit, FMX.Menus, FMX.Controls.Presentation, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Components, System.ImageList, FMX.ImgList,
  FMX.Gestures, FMX.ScrollBox, FMX.Memo, System.Notification, FMX.TabControl,
  untCommonFormStyleBook, FMX.Effects, System.IniFiles, FMX.Grid,
  FMX.ListBox, System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.DBScope,
  Data.DB, Fmx.Bind.Grid, Data.Bind.Grid, System.Rtti, FMX.Grid.Style, System.UIConsts,
  System.JSon

  {$IFDEF ANDROID}
  , FMX.platform.Android,Androidapi.JNI.JavaTypes,FMX.Helpers.Android,
  Androidapi.JNI.GraphicsContentViewText, AndroidApi.Jni.App, FMX.VirtualKeyboard
  {$ENDIF}

  {$IFDEF IOS}
  //uses do IOS
  {$ENDIF}

  {$IFDEF MSWINDOWS}
  , Winapi.Windows, FMX.Platform.Win
  {$ENDIF}
  ;

{$INCLUDE ..\SicsVersoes.pas}

type
  TFrmSicsPA = class(TFrmBase_PA_MPA)
    memoDebug: TMemo;
    tmrScreenSaver: TTimer;
    NotificationCenter: TNotificationCenter;
    pnlSettingsPassword: TPanel;
    edSettingsPassword: TEdit;
    recSettingsPassword: TRectangle;
    laySettingsPassword: TLayout;
    btnSettingsPassowrdOk: TButton;
    GestureManager: TGestureManager;
    lytGridRec: TLayout;
    lytGrid: TLayout;
    rectFechar: TRectangle;
    Rectangle2: TRectangle;
    imgSetaFechar: TImage;
    GridPessoasNasFilas: TGrid;
    LinkGridToDataSourceBindSourceDB12: TLinkGridToDataSource;
    lytComponentesBase: TLayout;
    pnlFila: TPanel;
    recFila: TRectangle;
    ScrollFundo: TVertScrollBox;
    layFila: TLayout;
    btnEncaminhar: TButton;
    btnEspecifica: TButton;
    btnFinalizar: TButton;
    btnPausar: TButton;
    btnProcessos: TButton;
    btnProximo: TButton;
    btnRechamar: TButton;
    lblMotivoPausa: TLabel;
    rectAbrir: TRectangle;
    rectSeta: TRectangle;
    imgSetaAbrir: TImage;
    pnlLogin: TPanel;
    recLogin: TRectangle;
    btnLogin: TButton;
    btnLogout: TButton;
    pnlPA: TPanel;
    recPA: TRectangle;
    lblNomePA: TLabel;
    lblAtendente: TLabel;
    lblEspera: TLabel;
    lblCodAtendente: TLabel;
    LblSenhaAtendente: TLabel;
    pnlSenha: TPanel;
    tabcontrolSenhasConfig: TTabControl;
    tabitemSenha: TTabItem;
    recSenha: TRectangle;
    RecInfoSenha: TRectangle;
    edtNomeCliente: TEdit;
    lblDescNomeCliente: TLabel;
    lblDescSenha: TLabel;
    lblNomeCliente: TLabel;
    lblSenha: TLabel;
    tabitemConfiguracoes: TTabItem;
    recSettings: TRectangle;
    btnSettings: TButton;
    btnVersao: TButton;
    btnVoltar: TButton;
    pnlTAGs: TPanel;
    recTAGs: TRectangle;
    Layout1: TLayout;
    TimerChamarEspecificaViaGridDePessoas: TTimer;
    btnSeguirAtendimento: TButton;
    ppmGridPessoas: TPopupMenu;
    PopUpMenuRenomear: TMenuItem;
    Timer2: TTimer;
    imgDadosAdicionais: TImage;
    lblObservacaoORIGINAL: TLabel;
    pnlObservacao: TPanel;
    Rectangle1: TRectangle;
    lblObservacao2: TLabel;
    TimerObsHint: TTimer;
    recObsHint: TRectangle;
    recObsHintCenter: TRectangle;
    procedure ppmGridPessoasItemClick(Sender: TObject);
    procedure mnuProximoClick(Sender: TObject);
    procedure mnuRechamarClick(Sender: TObject);
    procedure mnuEspecificaClick(Sender: TObject);
    procedure mnuEncaminharClick(Sender: TObject);
    procedure mnuFinalizarClick(Sender: TObject);
    procedure mnuSeguirAtendimentoClick(Sender: TObject);
    procedure btnRechamarClick(Sender: TObject);
    procedure btnProximoClick(Sender: TObject);
    procedure btnPausarClick(Sender: TObject);
    procedure btnLogoutClick(Sender: TObject);
    procedure lblSenhaDblClick(Sender: TObject);
    procedure btnCloseFormClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tmrScreenSaverTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormTouch(Sender: TObject; const Touches: TTouches; const Action: TTouchAction);
    procedure FormActivate(Sender: TObject);
    procedure RecInfoSenhaGesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure btnSettingsClick(Sender: TObject);
    procedure recSettingsPasswordClick(Sender: TObject);
    procedure btnSettingsPassowrdOkClick(Sender: TObject);
    procedure btnVersaoClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure RecInfoSenhaClick(Sender: TObject);
    procedure layFilaClick(Sender: TObject);
    procedure pnlTAGsClick(Sender: TObject);
    procedure recTAGsClick(Sender: TObject);
    procedure recPAClick(Sender: TObject);
    procedure lblNomePAClick(Sender: TObject);
    procedure lblAtendenteClick(Sender: TObject);
    procedure lblEsperaClick(Sender: TObject);
    procedure lblDescSenhaClick(Sender: TObject);
    procedure lblSenhaClick(Sender: TObject);
    procedure rectFundoClick(Sender: TObject);
    procedure ScrollFundoClick(Sender: TObject);
    procedure recLoginClick(Sender: TObject);
    procedure btnSettingsGesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure btnVersaoGesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure btnVoltarClick(Sender: TObject);
    procedure AbreMenu;
    function GetMaxFormWidthWithMenu: Integer;
    function GetMaxFormWidthWithoutMenu: Integer;
    procedure FechaMenu(pAlteraParametroINI:Boolean);
    procedure imgSetaAbrirClick(Sender: TObject);
    procedure imgSetaFecharClick(Sender: TObject);
    procedure GridPessoasNasFilasHeaderClick(Column: TColumn);
    procedure GridPessoasNasFilasCellDblClick(const Column: TColumn;
      const Row: Integer);
    procedure TimerChamarEspecificaViaGridDePessoasTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ppmGridPessoasPopup(Sender: TObject);
    procedure GridPessoasNasFilasSetValue(Sender: TObject; const ACol,
      ARow: Integer; const Value: TValue);
    procedure PopUpMenuRenomearClick(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure imgDadosAdicionaisClick(Sender: TObject);
    procedure pnlObservacaoClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure TimerObsHintTimer(Sender: TObject);
  private
    procedure GravaSituacaoMenu;
  protected
    {$IFNDEF IS_MOBILE}
    FClasseMenu: TClasseMenu;
    {$ENDIF IS_MOBILE}

    function GetCodPA(const Sender: TObject): Integer; override;
    function GetCodAtend(const aPA: Integer): Integer; override;
    function GetSenhaAtend(const aCodAtend: Integer): string; override;
    procedure  mnuSobreClick(Sender : TObject); override;
  public
    procedure MostraEscondeBotaoAbrirFecharPessoasNasFilasPA; override;
    function BeginUpdatePA(var aListaPa: TIntegerDynArray; const aCanClearArray: Boolean = True): Boolean; override;
    function InUpdatePA: Boolean; override;
    function InChanges: Boolean; override;
    procedure DefinirCor(const aIdUnidade: Integer; const ACor, aCorOld: TAlphaColor; const aPintarRetangulo: Boolean); override;
    {$IFNDEF IS_MOBILE}
    function GetMenu(const aCodPA: Integer): TClasseMenu;
    {$ENDIF IS_MOBILE}
    function GetbtnProximo(const aCodPA: Integer): TButton; override;
    function GetImgDadosAdicionais(const aCodPA: Integer): TImage; override;
    function GetBtnRechamar(const aCodPA: Integer): TButton; override;
    function GetBtnEspecifica(const aCodPA: Integer): TButton; override;
    function GetBtnEncaminhar(const aCodPA: Integer): TButton; override;
    function GetBtnFinalizar(const aCodPA: Integer): TButton; override;
    function GetBtnProcessos(const aCodPA: Integer): TButton; override;
    function GetBtnPausar(const aCodPA: Integer): TButton; override;
    function GetBtnSeguirAtendimento(const aCodPA: Integer): TButton; override;
    function GetBtnLogin(const aCodPA: Integer): TButton; override;

    function GetLblNomeCliente(const aCodPA: Integer): TLabel; override;
    function GetLblDescNomeCliente(const aCodPA: Integer): TLabel; override;
    function GetLblSenha(const aCodPA: Integer): TLabel; override;
    function GetLblDescSenha(const aCodPA: Integer): TLabel; override;
    function GetLblNomePA(const aCodPA: Integer): TLabel; override;
    function GetLblAtendente(const aCodPA: Integer): TLabel; override;
    function GetLblCodAtendente(const aCodPA: Integer): TLabel; override;
    function GetLblSenhaAtendente(const aCodPA: Integer): TLabel; override;
    function GetLblEspera(const aCodPA: Integer): TLabel; override;
    function GetLblMotivoPausa(const aCodPA: Integer): TLabel; override;
    function GetedtNomeCliente(const aCodPA: Integer): TEdit; override;
    function GetRecTAGs(const aCodPA: Integer): TRectangle; override;
    function GetpnlTAGs(const aCodPA: Integer): TPanel; override;
    function GetPnlPA : TPanel; override;
    function GetPnlSenha : TPanel; override;
    {$IFDEF IS_MOBILE} //***IOS
    function GetPnlLogin: TPanel; override;
    {$ENDIF}

    {$IFNDEF IS_MOBILE}
    procedure CriarMenu; reintroduce;
    {$ENDIF IS_MOBILE}
    procedure CriarTAGs; override;
    function GetSituacaoAtual: string; override;
    procedure CarregarParametrosDB(const aPA, aIdUnidade: Integer); overload; override;
    procedure CarregarParametrosDB; overload; override;
    procedure CarregarParametrosINI; override;
    procedure AtualizarAtendente(const NomeAtendente: string; const PA, aCodAtend: Integer); override;
    procedure AtualizarObservacaoPA(PA: Integer); override;
    procedure UpdateButtons(const PA, aCodAtend: Integer); overload; override;
    procedure UpdateButtons(const PA, aCodAtend: Integer; const aValidarBotoesTAG, aAtendenteLogado, aModoAtendimento: Boolean); overload; override;
    procedure AtualizarMotivoPausa(const aCor: TAlphaColor; const Motivo: string; const PA: Integer); override;
//LBC VERIFICAR    function GetListCurrentPA: TIntegerDynArray; override;
    procedure ConfiguraLayoutAndroid; //RAP 02/06/2016

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure  OrganizaPosicaoBotoes;
    procedure  Fechar;
  end;

var
  FrmSicsPA: TFrmSicsPA;
  FrmScreenSaver: TFrmScreenSaver;

const
  WIDTH_GRID_PESSOAS_FILAS = 465;
  NOME_POPUPHINT = 'PopupHint';

implementation

uses
  untFrmConfigParametros,
  untCommonDMConnection,
  untCommonFormSelecaoFila,
  untCommonFormSelecaoMotivoPausa,
  Sics_Common_Parametros,
  {$IFDEF ANDROID}
  Androidapi.Helpers,
  {$ENDIF}
  untCommonDMClient,
  untCommonControleInstanciaAplicacao,
  FMX.Platform,
  System.Math,
  System.StrUtils,
  APIs.Aspect.Sics.BuscarParametro,
  untCommonFormDadosAdicionais,
  untCommonFormBase;

{$R *.fmx}

{ TFrmSicsPA }

//JLS - Alterado, porque o mecanismo de ativação e desativação do menu para os atendimentos em espera, não funcionava corretamente.
procedure TFrmSicsPA.MostraEscondeBotaoAbrirFecharPessoasNasFilasPA;
begin
  if (vgParametrosModulo.VisualizaPessoasFilas) then
  begin
    rectAbrir.Visible          := True;
    lytGridRec.Visible         := FrmSicsPA.rectAbrir.Visible;
    //lytSetaFechar.Visible      := True;
    //lytComponentesBase.Anchors := [TAnchorKind.akLeft, TAnchorKind.akTop, TAnchorKind.akBottom];
    //imgSetaAbrir.RotationAngle := 0;
    rectFechar.Visible         := False;
    if (vgParametrosModulo.MenuEscondido) then
      FechaMenu(false)
    else
      AbreMenu;
  end
  else
  begin
    rectAbrir.Visible          := False;
    lytGridRec.Visible         := rectFechar.Visible;
    //lytSetaFechar.Visible      := True;
    //lytComponentesBase.Anchors := [TAnchorKind.akLeft, TAnchorKind.akTop, TAnchorKind.akRight, TAnchorKind.akBottom];
    rectAbrir.Visible          := False;
    rectFechar.Visible         := lytGridRec.Visible;
  end;
end;

function TFrmSicsPA.GetBtnEncaminhar(const aCodPA: Integer): TButton;
begin
  Result := BtnEncaminhar;
end;

function TFrmSicsPA.GetBtnSeguirAtendimento(const aCodPA: Integer): TButton;
begin
  Result := BtnSeguirAtendimento;
end;

function TFrmSicsPA.GetBtnEspecifica(const aCodPA: Integer): TButton;
begin
  Result := BtnEspecifica;
end;

function TFrmSicsPA.GetBtnFinalizar(const aCodPA: Integer): TButton;
begin
  Result := BtnFinalizar;
end;

function TFrmSicsPA.GetBtnLogin(const aCodPA: Integer): TButton;
begin
  Result := BtnLogin;
end;

function TFrmSicsPA.GetBtnPausar(const aCodPA: Integer): TButton;
begin
  Result := BtnPausar;
end;

function TFrmSicsPA.GetBtnProcessos(const aCodPA: Integer): TButton;
begin
  Result := BtnProcessos;
end;

function TFrmSicsPA.GetbtnProximo(const aCodPA: Integer): TButton;
begin
  Result := btnProximo;
end;

function TFrmSicsPA.GetBtnRechamar(const aCodPA: Integer): TButton;
begin
  Result := btnRechamar;
end;

procedure TFrmSicsPA.AtualizarAtendente(const NomeAtendente: string; const PA, aCodAtend: Integer);
var
  LDMClient: TDMClient;
begin
  inherited;
  LDMClient := DMClient(IdUnidade, not CRIAR_SE_NAO_EXISTIR);
  if Assigned(LDMClient) then
    LDMClient.FCurrentAtd := aCodAtend;
end;

procedure TFrmSicsPA.AtualizarMotivoPausa(const aCor: TAlphaColor; const Motivo: string; const PA: Integer);
begin
  inherited;
  AjustarTopBotoes(False);
end;

procedure TFrmSicsPA.AtualizarObservacaoPA(PA: Integer);
var
  LObservacao: string;
begin
  lblObservacao2.Text := EmptyStr;
  pnlObservacao.Visible := false;

  if Assigned(FJSONDadosAdicionais) and (FJSONDadosAdicionais.TryGetValue('OBSERVACAO', LObservacao)) and (LObservacao <> EmptyStr) and (SenhaAtual(PA)<>'---') then
  begin
    lblObservacao2.Text := 'Obs.: '+LObservacao;
    pnlObservacao.Visible := vgParametrosModulo.MostrarDadosAdicionais;
  end;
end;

function TFrmSicsPA.BeginUpdatePA(var aListaPa: TIntegerDynArray; const aCanClearArray: Boolean): Boolean;
var
  LDMClient: TDMClient;
begin
  if aCanClearArray then
  begin
    SetLength(aListaPa, 0);
  end;
  LDMClient := DMClient(IDUnidade, not CRIAR_SE_NAO_EXISTIR);
  Result := Assigned(LDMClient) and inherited BeginUpdatePA(LDMClient.FCurrentPA, False);
  if Result then
  begin
    SetLength(aListaPa, Length(aListaPa) + 1);
    aListaPa[Length(aListaPa) - 1] := LDMClient.FCurrentPA;
  end;
end;

procedure TFrmSicsPA.btnCloseFormClick(Sender: TObject);
begin
  //RAP 02/06/2016
  {$IFDEF ANDROID}
    MainActivity.finish;
  {$ELSE} //***IOS
    inherited;
  {$ENDIF ANDROID}
end;

procedure TFrmSicsPA.btnLogoutClick(Sender: TObject);
begin
  inherited;
  //
end;

procedure TFrmSicsPA.btnPausarClick(Sender: TObject);
begin
  inherited;
  //
end;

procedure TFrmSicsPA.btnProximoClick(Sender: TObject);
begin
  inherited;
  //
end;

procedure TFrmSicsPA.btnRechamarClick(Sender: TObject);
begin
  inherited;
  //
end;

procedure TFrmSicsPA.btnSettingsClick(Sender: TObject);
begin
  laySettingsPassword.Visible := true;

  pnlSettingsPassword.Position.X := btnSettings.Position.X + ((btnSettings.Width - pnlSettingsPassword.Width) / 2) ;
  pnlSettingsPassword.Position.Y := btnSettings.Position.Y - btnSettings.Margins.Top + btnSettings.Height ;

  if recCaption.Visible then
    pnlSettingsPassword.Position.Y := pnlSettingsPassword.Position.Y + recCaption.Height;

  edSettingsPassword.Text := '';
  edSettingsPassword.SetFocus;
end;

procedure TFrmSicsPA.btnSettingsGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
var
  Gesto : string;
begin
  inherited;

  if GestureToIdent(EventInfo.GestureID, Gesto) then
    begin
      case EventInfo.GestureID of
        sgiLeft : tabcontrolSenhasConfig.Next;
        sgiRight: tabcontrolSenhasConfig.Previous;
      end;
    end;
end;

procedure TFrmSicsPA.btnSettingsPassowrdOkClick(Sender: TObject);
begin
  laySettingsPassword.Visible := false;

  if edSettingsPassword.Text = 'admin' then
    TFrmConfigParametros.ConfiguraParametrosConexao(procedure begin
      Self.tabcontrolSenhasConfig.ActiveTab := tabitemSenha;
    end);
end;

procedure TFrmSicsPA.btnVersaoClick(Sender: TObject);
{$IFDEF ANDROID}
var
  PackageManager : JPackageManager;
  PackageInfo :  JPackageInfo;
{$ENDIF}
begin
  inherited;
 {$IFDEF ANDROID}
  PackageManager := MainActivity.getPackageManager;
  PackageInfo := PackageManager.getPackageInfo(MainActivity.getPackageName,TJPackageManager.JavaClass.GET_ACTIVITIES);
  ShowMessage('ASPECT Mídia Versão '+JStringToString(PackageInfo.versionName));
 {$ENDIF}
 {$IFDEF IOS}
  ShowMessage('ASPECT Mídia Versão iOS');
 {$ENDIF}
end;

procedure TFrmSicsPA.btnVersaoGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
var
  Gesto : string;
begin
  inherited;

  if GestureToIdent(EventInfo.GestureID, Gesto) then
    begin
      case EventInfo.GestureID of
        sgiLeft : tabcontrolSenhasConfig.Next;
        sgiRight: tabcontrolSenhasConfig.Previous;
      end;
    end;
end;

procedure TFrmSicsPA.btnVoltarClick(Sender: TObject);
begin
  inherited;
  tabcontrolSenhasConfig.Previous;
end;

procedure TFrmSicsPA.Button3Click(Sender: TObject);
begin

end;

//BAH TESTANDO procedure TFrmSicsPA.Button1Click(Sender: TObject);
//BAH TESTANDO var
//BAH TESTANDO   MyNot : TNotification;
//BAH TESTANDO begin
//BAH TESTANDO   inherited;
//BAH TESTANDO   MyNot := NotificationCenter.CreateNotification;
//BAH TESTANDO
//BAH TESTANDO   with MyNot do
//BAH TESTANDO   begin
//BAH TESTANDO     try
//BAH TESTANDO       Name        := 'Teste Notificação';
//BAH TESTANDO       AlertBody   := 'Corpo de Notificação';
//BAH TESTANDO       EnableSound := False;
//BAH TESTANDO       AlertAction := 'Launch';
//BAH TESTANDO       HasAction   := True;
//BAH TESTANDO
//BAH TESTANDO       NotificationCenter.PresentNotification(MyNot);
//BAH TESTANDO     finally
//BAH TESTANDO       DisposeOf;
//BAH TESTANDO     end;
//BAH TESTANDO   end;
//BAH TESTANDO end;

procedure TFrmSicsPA.CarregarParametrosDB;
begin
  inherited;
end;

procedure TFrmSicsPA.CarregarParametrosINI;
  procedure ConfiguraBotoes;
  begin
    ConfiguraBotaoModuloPA(btnProximo);
    ConfiguraBotaoModuloPA(btnEncaminhar);
    ConfiguraBotaoModuloPA(btnEspecifica);
    ConfiguraBotaoModuloPA(btnFinalizar);
    ConfiguraBotaoModuloPA(btnProcessos);
    ConfiguraBotaoModuloPA(btnPausar);
    ConfiguraBotaoModuloPA(btnRechamar);
    ConfiguraBotaoModuloPA(btnSeguirAtendimento);
    ConfiguraBotaoModuloPA(btnLogin);
   // ConfiguraBotaoModuloPA(btnLogout);
  end;
begin
  inherited;

  pnlLogin.Visible := btnLogin.Visible;
  ConfiguraBotoes;
end;

procedure TFrmSicsPA.ConfiguraLayoutAndroid; //RAP 02/06/2016
var
  Altura, Largura, TamanhoFonte, TamanhoFonteBotoes: Integer;
begin
  Altura := 80;
  Largura := 350;
  TamanhoFonte := 18;
  TamanhoFonteBotoes := 25;

  recCaption.Height := 50;
  btnCloseForm.Width := 50;

  self.lblCaption.TextSettings.Font.Size := 20;

  btnProximo.TextSettings.Font.Size := TamanhoFonteBotoes;
  btnProximo.Height := Altura;
  btnProximo.Width := Largura;
  btnRechamar.TextSettings.Font.Size := TamanhoFonteBotoes;
  btnRechamar.Height := Altura;
  btnRechamar.Width := Largura;
  btnEspecifica.TextSettings.Font.Size := TamanhoFonteBotoes;
  btnEspecifica.Height := Altura;
  btnEspecifica.Width := Largura;
  btnEncaminhar.TextSettings.Font.Size := TamanhoFonteBotoes;
  btnEncaminhar.Height := Altura;
  btnEncaminhar.Width := Largura;
  btnFinalizar.TextSettings.Font.Size := TamanhoFonteBotoes;
  btnFinalizar.Height := Altura;
  btnFinalizar.Width := Largura;
  btnProcessos.TextSettings.Font.Size := TamanhoFonteBotoes;
  btnProcessos.Height := Altura;
  btnProcessos.Width := Largura;
  btnPausar.TextSettings.Font.Size := TamanhoFonteBotoes;
  btnPausar.Height := Altura;
  btnPausar.Width := Largura;
  btnSeguirAtendimento.TextSettings.Font.Size := TamanhoFonteBotoes;
  btnSeguirAtendimento.Height := Altura;
  btnSeguirAtendimento.Width := Largura;

  btnLogin.TextSettings.Font.Size := TamanhoFonteBotoes;
  btnLogin.Height := 50;
  btnLogin.Width := Largura; //Largura;
 // btnLogin.Width := 250; //Largura;
 { btnLogout.TextSettings.Font.Size := TamanhoFonteBotoes;
  btnLogout.Height := 50;
  btnLogout.Width := 250; //Largura;
  }
  lblDescSenha.Position.Y := 20;
  lblDescSenha.Width := 75;
  lblDescSenha.Height := 20;
  lblDescSenha.TextSettings.Font.Size := TamanhoFonte;

  lblSenha.Position.Y := 20;
  lblSenha.Position.X := lblDescSenha.Width + lblDescSenha.Position.X + 5;
  lblSenha.TextSettings.Font.Size := TamanhoFonte;
  lblSenha.Height := 20;

  lblDescNomeCliente.Position.Y := 42;
  lblDescNomeCliente.Width := 75;
  lblDescNomeCliente.TextSettings.Font.Size := TamanhoFonte;
  lblDescNomeCliente.Height := 20;

  lblNomeCliente.Position.Y := 42;
  lblNomeCliente.Position.X := lblDescNomeCliente.Width + lblDescNomeCliente.Position.X + 5;
  lblNomeCliente.TextSettings.Font.Size := TamanhoFonte;
  lblNomeCliente.Height := 20;

  lblNomePA.TextSettings.Font.Size := 16;
  lblAtendente.TextSettings.Font.Size := 16;
  lblEspera.TextSettings.Font.Size := 16;

 // pnlLogin.Height := 52;
  pnlLogin.Height := 65;

  lblMotivoPausa.TextSettings.Font.Size := 25;
  lblMotivoPausa.Align := TAlignLayout.MostBottom;
  lblMotivoPausa.TextSettings.HorzAlign := TTextAlign.Center;
  pnlPA.Align := TAlignLayout.MostBottom;
  pnlLogin.Align := TAlignLayout.Bottom;
end;

procedure TFrmSicsPA.CarregarParametrosDB(const aPA, aIdUnidade: Integer);
begin
  {$IFNDEF IS_MOBILE}
  CriarMenu;
  {$ENDIF IS_MOBILE}
  inherited;
  OrganizaPosicaoBotoes;
  pnlLogin.Visible := btnLogin.Visible;
  GridPessoasNasFilas.Columns[2].Visible := vgParametrosModulo.MostrarProntuario;
  GridPessoasNasFilas.Columns[2].Width := 0;
  imgDadosAdicionais.Visible := vgParametrosModulo.MostrarDadosAdicionais;
end;

constructor TFrmSicsPA.Create(AOwner: TComponent);
begin
  {$IFNDEF IS_MOBILE}
  FClasseMenu := nil;
  with(TdmControleInstanciaAplicacao.Create(Self)) do
  begin
    Tela := Self;
  end;
  {$ENDIF}

  inherited;
  Self.Caption := 'SICS - Módulo PA';
end;

{$IFNDEF IS_MOBILE}
procedure TFrmSicsPA.CriarMenu;
var
  LDMClient: TDMClient;
begin
  LDMClient := DMClient(IdUnidade, not CRIAR_SE_NAO_EXISTIR);
  FClasseMenu := nil;
  if Assigned(LDMClient) then
  begin
    FClasseMenu := inherited CriarMenu(LDMClient.FCurrentPA, Self);
  end;
end;
{$ENDIF IS_MOBILE}

procedure TFrmSicsPA.CriarTAGs;
var
  LDMClient: TDMClient;
begin
  LDMClient := DMClient(IdUnidade, not CRIAR_SE_NAO_EXISTIR);
  if Assigned(LDMClient) then
    inherited CriarTAGs(LDMClient.FCurrentPA);
end;

procedure TFrmSicsPA.DefinirCor(const aIdUnidade: Integer; const ACor, aCorOld: TAlphaColor; const aPintarRetangulo: Boolean);
begin
  inherited DefinirCor(aIdUnidade, ACor, aCorOld, False);
end;

destructor TFrmSicsPA.Destroy;
begin
  inherited;
end;

procedure TFrmSicsPA.Fechar;
begin
  Application.Terminate;
end;

procedure TFrmSicsPA.FormActivate(Sender: TObject);
{$IFDEF IS_MOBILE}
var
  KeyboardService: IFMXVirtualKeyboardService;
{$ENDIF}
begin
  inherited;
  {$IFDEF IS_MOBILE}
  //BAH IMPLEMENTAÇÃO FUTURA FrmScreenSaver := TFrmScreenSaver.Create(Self);
  if TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(KeyboardService)) then
  begin
    KeyboardService.HideVirtualKeyboard;
  end;
  {$ENDIF}
  GridPessoasNasFilas.Columns[2].Visible := vgParametrosModulo.MostrarProntuario;
  GridPessoasNasFilas.Columns[1].Width := IfThen(vgParametrosModulo.MostrarProntuario, 140, 200);
  AtualizarObservacaoPA(0);
end;

procedure TFrmSicsPA.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  GravaSituacaoMenu;

  inherited;
end;

procedure TFrmSicsPA.FormCreate(Sender: TObject);
var
 sFileName : String;
  I: Integer;
begin
  inherited;
  {$IFDEF IS_MOBILE}
   //BAH IMPLEMENTAÇÃO FUTURA Self.FullScreen := True;
  {$ENDIF}
  Self.Caption := 'SICS - Módulo PA';

  AddHint(recObsHintCenter, 'OBS', '', TAlphaColorRec.Black);
end;

procedure TFrmSicsPA.FormResize(Sender: TObject);
begin
  inherited;
  OrganizaPosicaoBotoes;
end;

procedure TFrmSicsPA.FormShow(Sender: TObject);
begin
  inherited;
  {$IFDEF IS_MOBILE} //RAP 02/06/2016
    ConfiguraLayoutAndroid; //***IOS
    tabcontrolSenhasConfig.ActiveTab := tabitemSenha;
    lytFundo.Margins.Top := pnlFila.Position.Y;
  {$ELSE}
    btnVersao.Visible := False;
    btnSettings.Align := TAlignLayout.Center;
    btnSettings.Width := 100;
    btnSettings.Height := 30;
  {$ENDIF}
end;

procedure TFrmSicsPA.FormTouch(Sender: TObject; const Touches: TTouches; const Action: TTouchAction);
begin
  inherited;
  //BAH implementação futura do screen saver
  //BAH enquanto tiver tocando na tela o timer é reinicializado
  //tmrScreenSaver.Enabled:= False;
  //tmrScreenSaver.Enabled := True;
end;

function TFrmSicsPA.GetCodAtend(const aPA: Integer): Integer;
var
  LDMClient: TDMClient;
begin
  Result := -1;
  LDMClient := DMClient(IdUnidade, not CRIAR_SE_NAO_EXISTIR);
  if Assigned(LDMClient) then
    Result := LDMClient.FCurrentAtd;
end;

function TFrmSicsPA.GetCodPA(const Sender: TObject): Integer;
var
  LDMClient: TDMClient;
begin
  Result := -1;
  LDMClient := DMClient(IdUnidade, not CRIAR_SE_NAO_EXISTIR);
  if Assigned(LDMClient) then
    Result := LDMClient.FCurrentPA;
end;

function TFrmSicsPA.GetedtNomeCliente(const aCodPA: Integer): TEdit;
begin
  Result := edtNomeCliente;
end;

function TFrmSicsPA.GetImgDadosAdicionais(const aCodPA: Integer): TImage;
begin
  Result := imgDadosAdicionais;
end;

function TFrmSicsPA.GetLblAtendente(const aCodPA: Integer): TLabel;
begin
  Result := lblAtendente;
end;

function TFrmSicsPA.GetLblCodAtendente(const aCodPA: Integer): TLabel;
begin
  Result := lblCodAtendente;
end;

function TFrmSicsPA.GetLblDescNomeCliente(const aCodPA: Integer): TLabel;
begin
  Result := LblDescNomeCliente;
end;

function TFrmSicsPA.GetLblDescSenha(const aCodPA: Integer): TLabel;
begin
  Result := LblDescSenha;
end;

function TFrmSicsPA.GetLblEspera(const aCodPA: Integer): TLabel;
begin
  Result := LblEspera;
end;

function TFrmSicsPA.GetLblMotivoPausa(const aCodPA: Integer): TLabel;
begin
  Result := LblMotivoPausa;
end;

function TFrmSicsPA.GetLblNomeCliente(const aCodPA: Integer): TLabel;
begin
  Result := LblNomeCliente;
end;

function TFrmSicsPA.GetLblNomePA(const aCodPA: Integer): TLabel;
begin
  Result := LblNomePA;
end;

function TFrmSicsPA.GetLblSenha(const aCodPA: Integer): TLabel;
begin
  Result := LblSenha;
end;

function TFrmSicsPA.GetLblSenhaAtendente(const aCodPA: Integer): TLabel;
begin
  Result := LblSenhaAtendente;
end;

//LBC VERIFICAR function TFrmSicsPA.GetListCurrentPA: TIntegerDynArray;
//LBC VERIFICAR begin
//LBC VERIFICAR   SetLength(Result, 1);
//LBC VERIFICAR   Result[0] := GetCodPA(nil);
//LBC VERIFICAR end;

{$IFNDEF IS_MOBILE}
function TFrmSicsPA.GetMaxFormWidthWithoutMenu: Integer;
begin
  Result := Round(FrmSicsPA.Width - WIDTH_GRID_PESSOAS_FILAS);
  if FrmSicsPA.Width - WIDTH_GRID_PESSOAS_FILAS > Screen.Width then
    Result := Screen.Width;
end;

function TFrmSicsPA.GetMaxFormWidthWithMenu: Integer;
begin
  Result := Round(FrmSicsPA.Width + WIDTH_GRID_PESSOAS_FILAS);
  if FrmSicsPA.Width + WIDTH_GRID_PESSOAS_FILAS > Screen.Width then
    Result := Screen.Width;
end;

function TFrmSicsPA.GetMenu(const aCodPA: Integer): TClasseMenu;
begin
  Result := FClasseMenu;
end;
{$ENDIF}

function TFrmSicsPA.GetpnlTAGs(const aCodPA: Integer): TPanel;
begin
  Result := pnlTAGs;
end;

{$IFDEF IS_MOBILE}
function TFrmSicsPA.GetPnlLogin: TPanel;
begin
  Result := pnlLogin;
end;
{$ENDIF}

{$IFDEF CompilarPara_PA}
function TFrmSicsPA.GetPnlPA: TPanel;
begin
  Result := pnlPA;
end;

function TFrmSicsPA.GetPnlSenha: TPanel;
begin
  Result := pnlSenha;
end;
{$ENDIF}
function TFrmSicsPA.GetRecTAGs(const aCodPA: Integer): TRectangle;
begin
  Result := recTAGs;
end;

function TFrmSicsPA.GetSenhaAtend(const aCodAtend: Integer): string;
begin
  Result := EmptyStr;
end;

function TFrmSicsPA.GetSituacaoAtual: string;
begin
  Result := GetSituacaoAtualPA(DMClient(IDUnidade, not CRIAR_SE_NAO_EXISTIR).FCurrentPA)
end;

procedure TFrmSicsPA.GridPessoasNasFilasCellDblClick(const Column: TColumn;
  const Row: Integer);
begin
  TimerChamarEspecificaViaGridDePessoas.Enabled := True = btnEspecifica.Enabled;
end;

procedure TFrmSicsPA.GridPessoasNasFilasHeaderClick(Column: TColumn);
var
  LDMClient: TDMClient;
  LCampo: String;
  LIdxAsc, LIdxDesc: String;
  LField: TField;
begin
  GridPessoasNasFilas.BeginUpdate;

  try
    LDMClient := DMClient(IdUnidade, not CRIAR_SE_NAO_EXISTIR);
    LCampo := LinkGridToDataSourceBindSourceDB12.Columns[Column.Index].MemberName;
    LField := LDMClient.cdsPessoasFilaEsperaPA.FieldByName(LCampo);
    LIdxAsc := LDMClient.GetIndexName(LField, False);
    LIdxDesc := LDMClient.GetIndexName(LField, True);

    if LDMClient.cdsPessoasFilaEsperaPA.IndexName = LIdxAsc then
      LDMClient.cdsPessoasFilaEsperaPA.IndexName := LIdxDesc
    else if LDMClient.cdsPessoasFilaEsperaPA.IndexName = LIdxDesc then
      LDMClient.cdsPessoasFilaEsperaPA.IndexName := EmptyStr
    else
      LDMClient.cdsPessoasFilaEsperaPA.IndexName := LIdxAsc;
  finally
    GridPessoasNasFilas.EndUpdate;
  end;
end;

procedure TFrmSicsPA.GridPessoasNasFilasSetValue(Sender: TObject; const ACol,
  ARow: Integer; const Value: TValue);
begin
  inherited;
end;
//JLS - Alterado, porque o mecanismo de ativação e desativação do menu para os atendimentos em espera, não funcionava corretamente.
procedure TFrmSicsPA.FechaMenu(pAlteraParametroINI:Boolean);
begin
  //imgSetaAbrir.RotationAngle       := 0;

  lytGridRec.Visible               := False;
  rectAbrir.Visible                := not lytGridRec.Visible;
  rectFechar.Visible               := lytGridRec.Visible;

  if Self.WindowState <> TWindowState.wsMaximized then
  begin
    if (vgParametrosModulo.VisualizaPessoasFilas) and (not vgParametrosModulo.MenuEscondido) then
    begin
      if not Application.Terminated then
         FrmSicsPA.Left := FrmSicsPA.Left + 465;
      FrmSicsPA.Width                  := GetMaxFormWidthWithoutMenu;
    end;
  end;

  if (pAlteraParametroINI) then
    vgParametrosModulo.MenuEscondido := rectAbrir.Visible;

  OrganizaPosicaoBotoes;
end;
//JLS - Alterado, porque o mecanismo de ativação e desativação do menu para os atendimentos em espera, não funcionava corretamente.
procedure TFrmSicsPA.AbreMenu;
begin
  //imgSetaFechar.RotationAngle:=0;
  if Self.WindowState <> TWindowState.wsMaximized then
  begin
    FrmSicsPA.Width            := GetMaxFormWidthWithMenu;
    FrmSicsPA.Left := FrmSicsPA.Left - 465;
  end;

  lytGridRec.Visible               := True;
  rectAbrir.Visible                := not lytGridRec.Visible;
  rectFechar.Visible               := lytGridRec.Visible;
  vgParametrosModulo.MenuEscondido := False;

  OrganizaPosicaoBotoes;
end;

procedure TFrmSicsPA.imgSetaFecharClick(Sender: TObject);
begin
  FechaMenu(true);
  vgParametrosModulo.MenuEscondido := True;
end;

procedure TFrmSicsPA.imgDadosAdicionaisClick(Sender: TObject);
begin
  inherited;
  //
end;

procedure TFrmSicsPA.imgSetaAbrirClick(Sender: TObject);
begin
  AbreMenu;
  vgParametrosModulo.MenuEscondido := False;
end;

function TFrmSicsPA.InChanges: Boolean;
var
  LDMClient: TDMClient;
begin
  LDMClient := DMClient(IDUnidade, not CRIAR_SE_NAO_EXISTIR);
  Result := ((Assigned(LDMClient) and (inherited InChanges(LDMClient.FCurrentPA))) or (inherited InChanges(PA_VAZIA)));
end;

function TFrmSicsPA.InUpdatePA: Boolean;
var
  LDMClient: TDMClient;
begin
  LDMClient := DMClient(IDUnidade, not CRIAR_SE_NAO_EXISTIR);
  Result := ((Assigned(LDMClient) and (inherited InUpdatePA(LDMClient.FCurrentPA))) or (inherited InUpdatePA(PA_VAZIA)));
end;

procedure TFrmSicsPA.layFilaClick(Sender: TObject);
begin
  inherited;
  edtNomeCliente.OnExit(edtNomeCliente);
end;

procedure TFrmSicsPA.lblAtendenteClick(Sender: TObject);
begin
  inherited;
  edtNomeCliente.OnExit(edtNomeCliente);
end;

procedure TFrmSicsPA.lblDescSenhaClick(Sender: TObject);
begin
  inherited;
  edtNomeCliente.OnExit(edtNomeCliente);
end;

procedure TFrmSicsPA.lblEsperaClick(Sender: TObject);
begin
  inherited;
  edtNomeCliente.OnExit(edtNomeCliente);
end;

procedure TFrmSicsPA.lblNomePAClick(Sender: TObject);
begin
  inherited;
  edtNomeCliente.OnExit(edtNomeCliente);
end;

procedure TFrmSicsPA.lblSenhaClick(Sender: TObject);
begin
  inherited;
  edtNomeCliente.OnExit(edtNomeCliente);
end;

procedure TFrmSicsPA.lblSenhaDblClick(Sender: TObject);
begin
  inherited;
  //
end;

procedure TFrmSicsPA.mnuEncaminharClick(Sender: TObject);
begin
  inherited;
  btnEncaminharClick(btnEncaminhar);
end;

procedure TFrmSicsPA.mnuEspecificaClick(Sender: TObject);
begin
  inherited;
  btnEspecificaClick(btnEspecifica);
end;

procedure TFrmSicsPA.mnuFinalizarClick(Sender: TObject);
begin
  inherited;
  btnFinalizarClick(btnFinalizar);
end;

procedure TFrmSicsPA.mnuProximoClick(Sender: TObject);
begin
  inherited;
  btnProximoClick(Sender);
end;

procedure TFrmSicsPA.mnuRechamarClick(Sender: TObject);
begin
  inherited;
  btnRechamarClick(btnRechamar);
end;

procedure TFrmSicsPA.mnuSeguirAtendimentoClick(Sender: TObject);
begin
  btnSeguirAtendimentoClick(btnFinalizar);
end;

procedure TFrmSicsPA.mnuSobreClick(Sender: TObject);
begin
  inherited;
  InformationMessage(VERSAO {$IFNDEF IS_MOBILE} + #13#13 + GetExeVersion{$ENDIF IS_MOBILE});
end;

procedure TFrmSicsPA.OrganizaPosicaoBotoes;
const
  OFF = 5;

var
  TopPosition : Single;
  metadeTamanhoParent, tamBotao, metadeTamanhoBotao, posX : Single;
begin
  {$IFDEF IS_MOBILE}
  tamBotao := 350;
  metadeTamanhoParent := Screen.Width /2;
 // btnLogout.Position.X := metadeTamanhoParent + 5;
  btnLogin.Position.X :=  (Screen.Width - btnLogin.Width) /2;
  btnLogin.Position.Y := (pnlLogin.Height - btnLogin.Height)/2;
 // btnLogout.Position.Y := 5;
  {$ELSE}
  tamBotao := 142;
  metadeTamanhoParent := layFila.Width /2;
 // btnLogout.Position.X := (recLogin.Width /2) + 5;
  btnLogin.Position.X :=  (recLogin.Width - btnLogin.Width)/2;
  btnLogin.Width := tamBotao;
//  btnLogin.Width := 81;
//  btnLogout.Width := 81;
  {$ENDIF}
  metadeTamanhoBotao := tamBotao / 2;
  posX := metadeTamanhoParent - metadeTamanhoBotao;
  btnProximo.Position.X := posX;
  btnRechamar.Position.X := posX;
  btnEspecifica.Position.X := posX;
  btnEncaminhar.Position.X := posX;
  btnSeguirAtendimento.Position.X := posX;
  btnFinalizar.Position.X := posX;
  btnProcessos.Position.X := posX;
  btnPausar.Position.X := posX;

  TopPosition := 11;

  with btnProximo do
  begin
    if Visible then
    begin
      Position.Y := TopPosition;
      TopPosition := TopPosition + Height + OFF;
    end;
  end;

  with btnRechamar do
  begin
    if Visible then
    begin
      Position.Y := TopPosition;
      TopPosition := TopPosition + Height + OFF;
    end;
  end;

  with btnEspecifica do
  begin
    if Visible then
    begin
      Position.Y := TopPosition;
      TopPosition := TopPosition + Height + OFF;
    end;
  end;

  with btnEncaminhar do
  begin
    if Visible then
    begin
      Position.Y := TopPosition;
      TopPosition := TopPosition + Height + OFF;
    end;
  end;

  with btnFinalizar do
  begin
    if Visible then
    begin
      Position.Y := TopPosition;
      TopPosition := TopPosition + Height + OFF;
    end;
  end;

  with btnProcessos do
  begin
    if Visible then
    begin
      Position.Y := TopPosition;
      TopPosition := TopPosition + Height + OFF;
    end;
  end;

  with btnPausar do
  begin
    if Visible then
    begin
      Position.Y := TopPosition;
      TopPosition := TopPosition + Height + OFF;
    end;
  end;

  with btnSeguirAtendimento do
  begin
    if Visible then
    begin
      Position.Y := TopPosition;
      TopPosition := TopPosition + Height + OFF;
    end;
  end;

  with lblMotivoPausa do
  begin
    Position.Y := TopPosition;
    Margins.Bottom := 10;
  end;

  btnProximo.Width := tamBotao;
  btnRechamar.Width := tamBotao;
  btnEspecifica.Width := tamBotao;
  btnEncaminhar.Width := tamBotao;
  btnFinalizar.Width := tamBotao;
  btnProcessos.Width := tamBotao;
  btnPausar.Width := tamBotao;
  btnSeguirAtendimento.Width := tamBotao;
end;

procedure TFrmSicsPA.pnlObservacaoClick(Sender: TObject);
begin
  inherited;
  imgDadosAdicionais.OnClick(imgDadosAdicionais);
end;

procedure TFrmSicsPA.pnlTAGsClick(Sender: TObject);
begin
  inherited;
  edtNomeCliente.OnExit(edtNomeCliente);
end;

procedure TFrmSicsPA.PopUpMenuRenomearClick(Sender: TObject);
begin
  inherited;
  with DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR), DMClient(IdUnidade, not CRIAR_SE_NAO_EXISTIR) do
  begin
    InputQuery(PChar(('Senha: ' + cdsPessoasFilaEsperaPASenha.AsString)), ['Digite o nome do paciente:'], [cdsPessoasFilaEsperaPANome.AsString],
      procedure(const AResult: TModalResult; const AValues: array of string)
      begin
        if AResult = mrOk then
        begin
          cdsPessoasFilaEsperaPA.Edit;
          cdsPessoasFilaEsperaPANome.AsString := AValues[0];
          cdsPessoasFilaEsperaPA.Post;

          DefinirDadoAdicionalNomeCliente(vgParametrosModulo.IDPA, cdsPessoasFilaEsperaPASenha.AsInteger, cdsPessoasFilaEsperaPANome.AsString, IdUnidade);
        end;
      end);
  end;
end;

procedure TFrmSicsPA.ppmGridPessoasItemClick(Sender: TObject);
var
  LDMClient: TDMClient;
  LFilaTriagem: integer;
  LNomeTriagem: string;
begin
  LDMClient := DMClient(IdUnidade, not CRIAR_SE_NAO_EXISTIR);
  if not LDMClient.cdsPessoasFilaEsperaPA.IsEmpty then
  begin
    if ((sender as TMenuItem).Tag > 0) and (LDMClient.cdsPessoasFilaEsperaPASenha.AsInteger > 0)  then
    begin
      GetFilaTriagemPorId(Trunc((sender as TMenuItem).TagFloat), LFilaTriagem, LNomeTriagem);
      EncaminharSenhaFilaTriagem(LDMClient.cdsPessoasFilaEsperaPASenha.AsInteger, (sender as TMenuItem).Tag, (sender as TMenuItem).Text);
    end;
  end;
end;

procedure TFrmSicsPA.ppmGridPessoasPopup(Sender: TObject);
var
  mnuitem      : TMenuItem;
  LJson        : TJsonObject;
  LArrayObjeto : TJSONArray;
  LFilaJson    : integer;
  LNomeJson    : string;
  LCount       : integer;
  LIdTriagem   : integer;
  LDMClient    : TDMClient;
begin
  inherited;
  //ppmGridPessoas.Clear;
  if ppmGridPessoas.ItemsCount > 1 then Exit;

  LDMClient := DMClient(IdUnidade, not CRIAR_SE_NAO_EXISTIR);

  if not LDMClient.cdsPessoasFilaEsperaPA.IsEmpty then
  begin
    try
      LJson := TJSONObject.ParseJSONValue(vgParametrosModulo.ListaTriagemJson) as TJSONObject;

      if LJson.TryGetValue('Triagens', LArrayObjeto) then
      begin
        for LCount := 0 to Pred(LArrayObjeto.Count) do
        begin
          LJson := (LArrayObjeto.Items[LCount] as TJSONObject);
          LJson.TryGetValue('Fila', LFilaJson);
          LJson.TryGetValue('Nome', LNomeJson);
          LJson.TryGetValue('ID', LIdTriagem);

          mnuitem := TMenuItem.Create(ppmGridPessoas);
          mnuitem.Text :=LNomeJson;
          mnuitem.Tag := LFilaJson;
          mnuitem.TagFloat := LIdTriagem;
          mnuitem.OnClick := ppmGridPessoasItemClick;
          ppmGridPessoas.AddObject(mnuitem);
        end;
      end;
    finally
      LJson.Free;
    end;
  end;
end;

procedure TFrmSicsPA.RecInfoSenhaClick(Sender: TObject);
begin
  inherited;
  edtNomeCliente.OnExit(edtNomeCliente);
end;

procedure TFrmSicsPA.RecInfoSenhaGesture(Sender: TObject; const EventInfo: TGestureEventInfo; var Handled: Boolean);
var
  Gesto : string;
begin
  if GestureToIdent(EventInfo.GestureID, Gesto) then
    begin
      case EventInfo.GestureID of
        sgiLeft : tabcontrolSenhasConfig.Next;
        sgiRight: tabcontrolSenhasConfig.Previous;
      end;
    end;
end;

procedure TFrmSicsPA.recLoginClick(Sender: TObject);
begin
  inherited;
  edtNomeCliente.OnExit(edtNomeCliente);
end;

procedure TFrmSicsPA.recPAClick(Sender: TObject);
begin
  inherited;
  edtNomeCliente.OnExit(edtNomeCliente);
end;

procedure TFrmSicsPA.recSettingsPasswordClick(Sender: TObject);
begin
  laySettingsPassword.Visible := false;
end;

procedure TFrmSicsPA.recTAGsClick(Sender: TObject);
begin
  inherited;
  edtNomeCliente.OnExit(edtNomeCliente);
  imgDadosAdicionais.OnClick(imgDadosAdicionais);
end;

procedure TFrmSicsPA.rectFundoClick(Sender: TObject);
begin
  inherited;
  edtNomeCliente.OnExit(edtNomeCliente);
end;

procedure TFrmSicsPA.ScrollFundoClick(Sender: TObject);
begin
  inherited;
  edtNomeCliente.OnExit(edtNomeCliente);
end;

procedure TFrmSicsPA.TimerObsHintTimer(Sender: TObject);
var
  LObs, LMouse: TPointF;
  LCol, LRow: Integer;
  PopupHint: TAspPopup;
begin
  //if (Screen.MousePos.X >= pnt.X) and (Screen.MousePos.Y >= pnt.Y) and

  LMouse := ScreenToClient(Screen.MousePos);

  if GridPessoasNasFilas.CellByPoint(LMouse.X, LMouse.Y, LCol, LRow) then // Verifica se posição do cursor está sobre uma célula
  begin
    LRow := LRow - 1;

    LObs := GridPessoasNasFilas.Columns[5].LocalRect.TopLeft;
    //LObs := GridPessoasNasFilas.CellRect(LCol, LRow).Top;
    LObs := ScreenToClient(LObs);

//    Caption := 'Mouse X: ' + FloatToStr(LMouse.X) +
//               ' Y: ' + FloatToStr(LMouse.Y) +
//               ' Coluna OBS X:' + FloatToStr(GridPessoasNasFilas.CellRect(5, LRow).Left) +
//               ' Y:' + FloatToStr(GridPessoasNasFilas.CellRect(5, LRow).Top);
//
//    Caption := Caption + ' Cell Col: ' + FloatToStr(LCol) + ' Row: ' + FloatToStr(LRow);

    GridPessoasNasFilas.SelectCell(LCol, LRow);
    recObsHintCenter.Margins.Top := LMouse.Y - 10;

    if (LMouse.X >= GridPessoasNasFilas.CellRect(5, LRow).Left - 10) and
       (LMouse.Y >= GridPessoasNasFilas.CellRect(5, LRow).Top - GridPessoasNasFilas.VScrollBar.Value - 10) and
       (LMouse.X <= GridPessoasNasFilas.CellRect(5, LRow).Left-5 + GridPessoasNasFilas.CellRect(LCol, LRow).Width + 50) and
       (LMouse.Y <= (GridPessoasNasFilas.CellRect(5, LRow).Top-5 + GridPessoasNasFilas.CellRect(LCol, LRow).Height + 50) - GridPessoasNasFilas.VScrollBar.Value) then
    begin
      PopupHint := TAspPopup(recObsHintCenter.FindComponent(NOME_POPUPHINT));

      if Assigned(PopupHint) then
      begin
        //PopupHint.Position.X := GridPessoasNasFilas.CellRect(5, LRow).Left;
        //PopupHint.Position.Y := GridPessoasNasFilas.CellRect(5, LRow).Top;
        if PopupHint.lblTitle.Text <> DMClient(IdUnidade, not CRIAR_SE_NAO_EXISTIR).cdsPessoasFilaEsperaPAObservacao.AsString then
        begin
          OnControlHintMouseLeave(recObsHintCenter);
          PopupHint.lblTitle.Text := DMClient(IdUnidade, not CRIAR_SE_NAO_EXISTIR).cdsPessoasFilaEsperaPAObservacao.AsString;

          PopupHint.lblTitle.WordWrap := False;
          PopupHint.lblTitle.WordWrap := True;
          PopupHint.Height := PopupHint.lblTitle.Height + 20;
          PopupHint.Width := PopupHint.lblTitle.Width + 20;
        end;

        if PopupHint.lblTitle.Text <> EmptyStr then
          OnControlHintMouseEnter(recObsHintCenter)
        else
          OnControlHintMouseLeave(recObsHintCenter);
      end;
    end
    else
      OnControlHintMouseLeave(recObsHintCenter);
  end
  else
    OnControlHintMouseLeave(recObsHintCenter);
end;

procedure TFrmSicsPA.Timer2Timer(Sender: TObject);
begin
  inherited;
  GridPessoasNasFilas.Columns[2].Visible := vgParametrosModulo.MostrarProntuario;
  GridPessoasNasFilas.Columns[1].Width := IfThen(vgParametrosModulo.MostrarProntuario, 140, 200);
end;

procedure TFrmSicsPA.TimerChamarEspecificaViaGridDePessoasTimer(
  Sender: TObject);
var
  LDMClient: TDMClient;
begin
  TimerChamarEspecificaViaGridDePessoas.Enabled := False;

  LDMClient := DMClient(IdUnidade, not CRIAR_SE_NAO_EXISTIR);

  if not LDMClient.cdsPessoasFilaEsperaPA.IsEmpty then
  begin
    FSenhaDoubleClickGridPessoasFilaDeEspera := LDMClient.cdsPessoasFilaEsperaPASenha.AsInteger;

    MessageDlg('Chamar a senha "' + FSenhaDoubleClickGridPessoasFilaDeEspera.ToString + '" ? ',
               TMsgDlgType.mtConfirmation,
               [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
               0,
               TMsgDlgBtn.mbYes,
               procedure (const AResult: TModalResult)
               begin
                 if AResult = mrYes then
                   btnEspecificaClick(btnEspecifica)
                 else
                   FSenhaDoubleClickGridPessoasFilaDeEspera := 0;
               end);
  end;
end;

procedure TFrmSicsPA.tmrScreenSaverTimer(Sender: TObject);
begin
  inherited;
  {$IFDEF IS_MOBILE}
  tmrScreenSaver.Enabled := False;

  if FrmScreenSaver.Visible = False then
  begin
    FrmScreenSaver.Visible := True;
    FrmScreenSaver.Show;
  end;
  {$ENDIF}
end;

procedure TFrmSicsPA.UpdateButtons(const PA, aCodAtend: Integer);
begin
  inherited;
end;

procedure TFrmSicsPA.UpdateButtons(const PA, aCodAtend: Integer; const aValidarBotoesTAG, aAtendenteLogado, aModoAtendimento: Boolean);
begin
  inherited;
end;

procedure TFrmSicsPA.GravaSituacaoMenu;
var
  LIni: TIniFile;
begin
  LIni := TIniFile.Create(AspLib_GetAppIniFileName);
  try
    //JLS - Alterado, porque o mecanismo de ativação e desativação do menu para os atendimentos em espera, não funcionava corretamente.
    if (not vgParametrosModulo.MenuEscondido) then
      FechaMenu(false);
    LIni.WriteBool('Settings', 'MenuEscondido'   , vgParametrosModulo.MenuEscondido);
  finally
    LIni.Free;
  end;
end;

end.

