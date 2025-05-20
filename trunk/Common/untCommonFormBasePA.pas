unit untCommonFormBasePA;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  {$IFNDEF IS_MOBILE}
  ScktComp,
  Vcl.ExtCtrls,
  FMX.Platform.Win,
  Winapi.Windows,
  Winapi.Messages,
  MMSystem,
  {$ENDIF}
  {$IFDEF ANDROID}
  FMX.Platform.Android,
  {$ENDIF}
  FMX.Grid, FMX.Controls, FMX.Forms, FMX.Graphics, Sics_Common_Parametros,
  FMX.Dialogs, FMX.StdCtrls, FMX.ExtCtrls, FMX.Types, FMX.Layouts,
  FMX.Menus, Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs,
  Fmx.Bind.Editors, FMX.Objects, FMX.Edit,
  System.JSon,
  System.UIConsts,
  System.UITypes, System.Types,
  System.SysUtils, System.Classes, System.Variants, DB, DBClient, System.Rtti,
  Data.Bind.EngExt, Data.Bind.Components,
  Data.Bind.Grid,
  Data.Bind.DBScope,
  MyAspFuncoesUteis,
  untCommonFormBase,
  FMX.Controls.Presentation,
  System.ImageList,
  FMX.ImgList,
  untCommonFormStyleBook,
  FMX.Effects,
  APIs.Common,
  untCommonFormDadosAdicionais;

type
  {$IFNDEF IS_MOBILE}
  TClasseMenu = {$IFDEF CompilarPara_MULTIPA}
                  TPopupMenu;
                {$ELSE}
                  TMenuBar;
                {$ENDIF CompilarPara_MULTIPA}
  {$ENDIF IS_MOBILE}

  TTipoDeBotaoPA = (tbProximo, tbRechama, tbEspecifica, tbEncaminha, tbFinaliza, tbProcessosParalelos, tbPausa, tbLoginLogout, tbSeguirAtendimento, tbGrupoPA);
  TControleDelayEntreCliques = array[TTipoDeBotaoPA] of TDateTime;

  TListaBotoes = Array of FMX.StdCtrls.TButton;

  TListBtnsTAGs = class
    public
     ListaBotoes: TListaBotoes;
     PA: Integer;
     constructor Create;
     procedure AddButton(const aBotao: FMX.StdCtrls.TButton);
    end;

  TFrmBase_PA_MPA = class(TFrmBase)
    imgPrincipal: TImageList;
    StyleBook1: TStyleBook;
    bndPessoasNasFilas: TBindSourceDB;
    TimerExibirFormSelecaoDeFilas: TTimer;
    procedure mnuSairClick(Sender: TObject);
    procedure btnProximoClick(Sender: TObject);
    procedure imgDadosAdicionaisClick(Sender: TObject);
    procedure btnGrupoPAClick(Sender: TObject);
    procedure edtNomeClienteExit(Sender: TObject);

    procedure edtNomeClienteKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure lblNomeClienteClick(Sender: TObject);
    procedure btnRechamarClick(Sender: TObject);
    procedure mnuLoginClick(Sender: TObject);
    procedure mnuLogoutClick(Sender: TObject);
    procedure btnLogoutClick(Sender: TObject);   //LBC 09/04/2018 - VERIFICAR SE ESTÁ SENDO UTILIZADO, APARENTEMENTE NÃO
    procedure btnLoginClick(Sender: TObject);
    procedure btnEspecificaClick(Sender: TObject);
    procedure btnEncaminharClick(Sender: TObject);
    procedure btnFinalizarClick(Sender: TObject);
    procedure mnuAlterarSenhaClick(Sender: TObject);
    procedure btnProcessosClick(Sender: TObject);
    procedure btnPausarClick(Sender: TObject);
    procedure btnSeguirAtendimentoClick(Sender: TObject);
    procedure lblSenhaDblClick(Sender: TObject);
    procedure OnClickBtnTag(Sender: TObject);
    procedure OnMouseDownBtnTag(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);

    procedure mnuControleRemotoClick(Sender: TObject);
    procedure TimerExibirFormSelecaoDeFilasTimer(Sender: TObject);
  private
    {$IFNDEF IS_MOBILE}
    FReferenciaMenu: TClasseMenu;
    {$ENDIF}

    FCodPAAtual: Integer;
    FSituacaoPAAoExibirForm: string;
    FFilaChamarEspecifica: Integer;
    FSenhaChamarEspecifica: Integer;
    FPAChamarEspecifica: Integer;
    procedure SenhaEspecifica;
    procedure ChamarEspecificaEncaminhandoSenhaAtual(
      const AResult: TModalResult; const AValues: array of string);
    procedure ChamarEspecificaSemEncaminharSenhaAtual(
      const AResult: TModalResult; const AValues: array of string);
    procedure SeguirAtendimentoSenhaAtual(const AResult: TModalResult; const AValues: array of string);
    procedure SeguirAtendimentoSenhaAtualEmPausa(const AIDMotivoPausa: integer);
  protected
    FListBtnsTAGs: Array of TListBtnsTAGs;   //LBC 09/04/2018 - VERIFICAR SE PRECISA, APARENTEMENTE NÃO
    FMaxTAGsCriadas        : Integer;
    DataClickConfiguracoes : TDateTime;      //LBC 09/04/2018 - VERIFICAR SE PRECISA, APARENTEMENTE NÃO
    FUltimaSituacaoForm: String;
    FListaPaUpdating: TIntegerDynArray;
    LUpdatingBeginUpdatePA: Boolean;
    edtNomeClienteSelecionado : TEdit;

    FControleDelaysBotoes : TControleDelayEntreCliques;

    {$IFNDEF IS_MOBILE}
    function PodeMinimizarParaBandeja(Sender: TObject): Boolean;
    function CriarMenu(const aIDPA: Integer; const aParent: TFmxObject): TClasseMenu; Virtual;
    {$ENDIF IS_MOBILE}

    procedure AtendenteMouseClick(Sender: TObject); Virtual;
    procedure ForcarModoDesconectado; Override;
    function GetIndexPANaListBtnsTAGs(const aIDPA: Integer): Word;
    function GetListBtnsTAGs(const aIDPA: Integer): TListBtnsTAGs;
    procedure CriarItemsMenu(const aIDPA: Integer; const aParent: TFmxObject;
      MenuBar: TFmxObject; const aSufixoNomeItens: String = ''); Virtual;
    property ListBtnsTAGs[const aIDPA: Integer]: TListBtnsTAGs read GetListBtnsTAGs;
    function LerPropriedade(const aNomePropriedade, aNomeComponente: string; const aValorPadrao: Variant; const aPA: Integer): Variant;

    procedure AjustarTopBotao(var TopInicio, LeftInicio: Single; const nBotao: TComponent);
    procedure AjustarTopBotoes(const aSomenteSeModificouSizeForm: Boolean); Virtual;

    procedure DestroyListaBtnsTags;
    function FormataNomeComponente(const aNomeComponente: String; const aPA: Integer): String; Virtual;
    function BotaoProximoEstaRechamando(PA: Integer): Boolean;
    function GetCodPA(const Sender: TObject): Integer; Virtual; Abstract;
    function GetCodGrupoPA(const Sender: TObject): Integer; Virtual; Abstract;
    function GetCodAtend(const aPA: Integer): Integer; Virtual; Abstract;
    function GetSenhaAtend(const aCodAtend: Integer): String; Virtual; Abstract;

    procedure OnPopupMenuBar(Sender: Tobject);
    procedure SetModoConexaoAtual(const aIdUnidade: Integer; const Valor: boolean); Override;

    procedure  mnuSobreClick(Sender : TObject); Virtual;
    procedure AguardandoRetornoComando(ABool: Boolean); override;
  public
    FCountUpdatePA, FCountChanges: Array of SmallInt;
    FSenhaDoubleClickGridPessoasFilaDeEspera: Integer;
    FTAGs : TIntegerDynArray;
    FAlturaMinima: Integer;
    FAlturaTAGs: Integer;

    const
      propText           = 'Text';
      propIsPressed      = 'IsPressed';
      propEnabled        = 'Enabled';
      propVisible        = 'Visible';
      propHeight         = 'Height';
      propTop            = 'Top';
      propPositionY      = 'Position.Y';
      cmnuSairIcon       = 'mnuSairIcon';

      crecTAGs           = 'recTAGs';
      cMnuNomeCliente    = 'mnuNomeCliente';
      cGrpTags           = 'grpTags';
      cBtnTag            = 'btnTag';
      cRecColorTag       = 'recColorTag';
      cLblCodAtendente   = 'lblCodAtendente';

      cMnuArquivo           = 'mnuArquivo';
      cMnuInterrogacao      = 'mnuInterrogacao';
      cMnuLogin             = 'mnuLogin';
      cMnuLogout            = 'mnuLogout';
      cMnuAlterarSenha      = 'mnuAlterarSenha';
      cmnuSobre             = 'mnuSobre';
      cMnuProximo           = 'mnuProximo';
      cMnuSeguirAtendimento = 'mnuSeguirAtendimento';
      cMnuRechamar          = 'mnuRechamar';
      cMnuEspecifica        = 'mnuEspecifica';
      cMnuEncaminhar        = 'mnuEncaminhar';
      cMnuFinalizar         = 'mnuFinalizar';
      cMnuDivProcessos      = 'mnuDivProcessos';
      cMnuProcessos         = 'mnuProcessos';
      cMnuDivPausa          = 'mnuDivPausa';
      cMnuPausa             = 'mnuPausa';
      cmnuDivSair           = 'mnuDivSair';
      cmnuSair              = 'mnuSair';
      cmnuDivLogin          = 'mnuDivLogin';
      cmnuBar               = 'mnuBar';
      cMnuDivControleRemoto = 'mnuDivControleRemoto';
      cMnuControleRemoto    = 'mnuControleRemoto';

    procedure LBC_BotaoProximoViraRechama   (PA : integer);
    procedure LBC_BotaoProximoBackToProximo (PA : integer);
    procedure LBC_tmrBackToProximoTimer (Sender: TObject);

    procedure ClienteConfigurado; Virtual;
    function GetbtnProximo(const aCodPA: Integer): TButton; Virtual; abstract;
    function GetImgDadosAdicionais(const aCodPA: Integer): TImage; Virtual; abstract;
    function GetBtnRechamar(const aCodPA: Integer): TButton; Virtual; abstract;
    function GetBtnEspecifica(const aCodPA: Integer): TButton; Virtual; abstract;
    function GetBtnEncaminhar(const aCodPA: Integer): TButton; Virtual; abstract;
    function GetBtnFinalizar(const aCodPA: Integer): TButton; Virtual; abstract;
    function GetBtnProcessos(const aCodPA: Integer): TButton; Virtual; abstract;
    function GetBtnPausar(const aCodPA: Integer): TButton; Virtual; abstract;
    function GetBtnSeguirAtendimento(const aCodPA: Integer): TButton; Virtual; abstract;
    function GetBtnLogin(const aCodPA: Integer): TButton; Virtual; abstract;

    function GetLblNomeCliente(const aCodPA: Integer): TLabel; Virtual; abstract;
    function GetLblDescNomeCliente(const aCodPA: Integer): TLabel; Virtual; abstract;
    function GetLblSenha(const aCodPA: Integer): TLabel; Virtual; abstract;
    function GetLblDescSenha(const aCodPA: Integer): TLabel; Virtual; abstract;
    function GetLblNomePA(const aCodPA: Integer): TLabel; Virtual; abstract;
    function GetLblAtendente(const aCodPA: Integer): TLabel; Virtual; abstract;
    function GetLblCodAtendente(const aCodPA: Integer): TLabel; Virtual; abstract;
    function GetLblSenhaAtendente(const aCodPA: Integer): TLabel; Virtual; abstract;
    function GetLblEspera(const aCodPA: Integer): TLabel; Virtual; abstract;
    function GetLblMotivoPausa(const aCodPA: Integer): TLabel; Virtual; abstract;
    function GetLblObservacao(const aCodPA: Integer): TLabel; Virtual; abstract;

    function GetpnlTAGs(const aCodPA: Integer): TPanel; Virtual; abstract;

    {$IFDEF CompilarPara_MULTIPA}
    function GetRecFundo(const aCodPA: Integer): TRectangle; Virtual; abstract;
    function GetRecCodigoBarras(const aCodPA: Integer): TRectangle; Virtual; abstract;
    function GetPNL(const aCodPA: Integer): TPanel; Virtual; abstract;
    function GetRecPA(const aCodPA : Integer) : TRectangle; Virtual; abstract;
    function GetRecSenha(const aCodPA : Integer) : TRectangle; Virtual; abstract;
    function GetRecLogin(const aCodPA : Integer) : TRectangle; Virtual; abstract;
    function GetRecBotoes(const aCodPA : Integer) : TRectangle;Virtual; abstract;
    function GetpnlGrupos: TFramedScrollBox; Virtual; abstract;
    {$ENDIF CompilarPara_MULTIPA}
    function GetRecTAGs(const aCodPA: Integer): TRectangle; Virtual; abstract;
    {$IFDEF IS_MOBILE}
    function GetPnlLogin: TPanel; Virtual; abstract;
    {$ENDIF}

    {$IFDEF CompilarPara_PA}
    function GetPnlSenha : TPanel; virtual;abstract;
    function GetPnlPA : TPanel; virtual;abstract;
    {$ENDIF}

    function GetedtNomeCliente(const aCodPA: Integer): TEdit; Virtual; abstract;

   	function GetSituacaoAtualPA(Const aPA: Integer): String; virtual;
   	function GetSituacaoAtual: String; virtual; abstract;
    function GetComponentePA(const aNome: String; const aCodPA: Integer; const aFindInSubComponent: Boolean = True): TComponent;
    function GetComponentePAEdt(const aNome: String; const aCodPA: Integer): TEdit;
    function GetComponentePALabel(const aNome: String; const aCodPA: Integer): TLabel;
    procedure AtualizarPropriedade(const NomePropriedade, NomeComponente: string;
      const ValorPropriedade: Variant; const PA: Integer; const aReplicarMenuTray: Boolean = True); Virtual;

    procedure InicializarMenu;

    procedure AtualizarAtendente(const NomeAtendente: string; const PA, aCodAtend: Integer); Virtual;
    procedure AtualizarEspera(const PA, Qtde: Integer; const aPodeChamarProximo: Boolean = False); virtual;
    procedure AtualizarNomeCliente(NomeCliente: string; PA: Integer);
    procedure AtualizarNomePA(NomePA: string; PA: Integer);
    procedure AtualizarSenha(PA: Integer; Senha: string); Virtual;
    procedure AtualizarMotivoPausa(const aCor: TAlphaColor; const Motivo: string; const PA: Integer); virtual;
    function GetMotivoPausaAtual(const aPA: Integer): String;
    function GetEstaEmPausa(const aPA: Integer): Boolean;

  	function QtdeSenhaEspera(const aPA: Integer): Integer;
  	function PossuiSenhaEspera(const aPA: Integer): Boolean;
    function EstaEmAtendimento(PA: Integer): Boolean;
    function SenhaAtual(PA: Integer): string;
    function GetNomeCliente(PA: Integer): string;
    function NomeAtendente(PA: Integer): string;
    function GetCodAtendente(const aPA: Integer): Integer;
    function NomePA(PA: Integer): string;
    function AtendenteLogado(PA: Integer): Boolean;
  	procedure GetFilaTriagemPorId(const LIdTriagem:integer;var LFilaTriagem:Integer;var LNomeTriagem:string);
    procedure DefinirNomeParaSenha(PA: Integer; Senha: Integer; NomeCliente: string);

    procedure ExibeMensagemDeAlarme(sNomePI, sNomeNivel, sCorNivel, sMensagem: string);

    procedure CriarTAGs; Overload; Virtual; abstract;
    procedure CriarTAGs(const PA: Integer); Overload; virtual;
    procedure SelecionarTAGs(PA: Integer; Ids: array of Integer);
    procedure DesligarTAGs(PA: Integer);
    procedure DesligarOutrasTAGGrupos(const aIDPA: Integer; const aTagAtual: FMX.StdCtrls.TButton);
    procedure AtualizarIsPressedRetangulo(const aBotaoTag: FMX.StdCtrls.TButton);

    procedure ProcessosParalelos(const aPA, aCodAtend: Integer); Overload;
    procedure ProcessosParalelos(const aPA, aCodAtend, aSenha: Integer); Overload;

    function UpdateAtdStatus(const PA, StatusPA, MotivoPausa, Atendente: Integer; const Senha, NomeCliente : string): Boolean; Virtual;
    procedure UpdatePAStatus(const PA: Integer);
    procedure UpdateButtons(const PA: Integer); Overload; Virtual;
    procedure UpdateButtons(const PA, aCodAtend: Integer); Overload; Virtual;
    procedure UpdateButtons(const PA, aCodAtend: Integer; const aValidarBotoesTAG, aAtendenteLogado, aModoAtendimento: Boolean); Overload; Virtual;

    function EndUpdatePA(var aListaPa: TIntegerDynArray): Boolean; Overload;
    function BeginUpdatePA(var aListaPa: TIntegerDynArray; const aCanClearArray: Boolean = True): Boolean; Overload; Virtual; abstract;
    function InUpdatePA: Boolean; Overload; Virtual; abstract;
    function InChanges: Boolean; Overload; Virtual; abstract;

    function EndUpdatePA(const aPA: Integer): Boolean; Overload; Virtual;
    function BeginUpdatePA(const aPA: Integer; const aCanClearArray: Boolean = True): Boolean; Overload; Virtual;
    function InUpdatePA(const aPA: Integer): Boolean; Overload; Virtual;
    function InChanges(const aPA: Integer): Boolean; Overload; Virtual;
    function BeginChanges(const aPA: Integer): Boolean; Virtual;
    function EndChanges(const aPA: Integer): Boolean; Virtual;
    procedure ApplyChanges(const aPA: Integer); Virtual;
    function TAGsObrigatorias(const PA: Integer): Boolean;

    procedure Login(const PA, aCodAtend: Integer); Virtual;
    procedure Logout(const PA, aCodAtend: Integer; const aExibirTelaLogin: Boolean = False; const aAutoLogin: Boolean = False; const aSenhaAtend: String = ''; const aPALogar: Integer = -1;const somenteDeslogar : Boolean = False); Virtual;
    procedure IniciarPausa(PA: Integer; const AExibeBtnSeguirAtendimento:boolean = False);
    procedure TerminarPausa(PA: Integer);
    procedure Proximo(const aSender: TObject; const PA: Integer; const aPodeExibirConfirmacao, aExibirErroForaDeContexto: Boolean);
    procedure ChamarProximo (const PA: Integer; const aExibirErroForaDeContexto: Boolean = True);
    procedure Rechamar(PA: Integer);
    procedure Especifica(PA: Integer);
    procedure Encaminhar(PA: Integer);
    procedure EncaminharSenhaFilaTriagem(const aSenha, aFilaTriagem: Integer;const aNomeTriagem: string = '');
    procedure EncaminharSemConfirmar(PA: Integer);
    procedure Finalizar(PA: Integer);
    procedure Pausa(PA: Integer);
    procedure AlterarSenha(const aPA, aCodAtend: Integer; const aSenhaAtend: String);
    procedure MostraGrupoPA(const ACodGrupoPA:integer);
    procedure CarregarParametrosDB(const aPA, aIdUnidade: Integer); reintroduce;  Overload; Virtual;
    procedure CarregarParametrosDB(const aIDUnidade: Integer); Overload; Override;
    procedure CarregarParametrosDB; Overload; Override;
    procedure CarregarParametrosINI; Override;

    procedure CriarPAs; virtual; abstract; // MultiPA
    procedure CriarGruposPAs; virtual; abstract; // MultiPA
    function GetPaJaFoiCriada(const aPA: Integer): Boolean; virtual;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; Override;
    procedure EscondeEdtNomeCliente(Sender : TObject);
    procedure MostraEscondeBotaoAbrirFecharPessoasNasFilasPA; virtual; abstract;
    procedure OrganizaPAs; virtual; abstract;
    procedure AtualizarObservacaoPA(PA: Integer); virtual; abstract;
  end;

const
  PA_VAZIA = 0;
  {$IFDEF IS_MOBILE}
  BTN_WIDTH  = 40;
  BTN_HEIGHT = 40;
  {$ELSE}
 // BTN_WIDTH  = 22;
 // BTN_HEIGHT = 23;
   BTN_WIDTH  = 22;
   BTN_HEIGHT = 22;
  {$ENDIF}
  cMarginLeft = 4;

function IntInArray(const Value: Integer; IntArray: array of Integer): Boolean;

implementation

uses
  untCommonDMConnection,
  untCommonDMClient,
  untCommonFormSelecaoFila,
  untFrmConfigParametros,
  untCommonFormProcessoParalelo,
  untCommonFormAlteracaoSenha,
  APIs.Aspect.Sics.SeguirAtendimento,
  APIs.Aspect.Sics.ImprimirEtiqueta,
  APIs.Aspect.Sics.BuscarParametro,
  untLog,
  untCommonFormLogin,
  untCommonFormSelecaoMotivoPausa,
  Sics_Common_LCDBInput,
  uNotificacaoPopup,
  untCommonDMUnidades,
  untCommonFormControleRemoto,
  FMX.ListBox,
  System.MaskUtils,
  Vcl.Graphics,
  System.StrUtils,
  System.Math;

{$R *.fmx}

{ %CLASSGROUP 'FMX.Controls.TControl' }

function InvertColor(Color: TColor): TColor;
begin
  if ((GetRValue(Color) * 299 + GetGValue(Color) * 587 + GetBValue(Color) * 114))/1000 < 128 then
    Result := clWhite
  else
    Result := clBlack;
end;

function IntInArray(const Value: Integer; IntArray: array of Integer): Boolean;
var
  I: Integer;
begin
    Result := True;
    for I := Low(IntArray) to High(IntArray) do
        if IntArray[i] = Value then Exit;
    Result := False;
end;

function GetTextOfObject(Const aSender: TObject): String;
begin
  if (aSender is TPresentedTextControl) then
    Result := TPresentedTextControl(aSender).Text
  else
    Result := (aSender as TTextControl).Text;
end;

procedure SetTextInObject(Const aSender: TObject; const aValue: String);
begin
  if (aSender is TPresentedTextControl) then
    TPresentedTextControl(aSender).Text := aValue
  else
    (aSender as TTextControl).Text := aValue;
end;

function TFrmBase_PA_MPA.GetSituacaoAtualPA(Const aPA: Integer): String;
begin
  Result := 'PA: ' + IntToStr(aPA) + ' | Senha: ' + SenhaAtual(aPA) + ' | Atendente: ' + IntToStr(GetCodAtend(aPA)) + ' | Pausa: ' + GetMotivoPausaAtual(aPA) +
    ' | Unidade: ' + IntToStr(IDUnidade);
end;

procedure TFrmBase_PA_MPA.imgDadosAdicionaisClick(Sender: TObject);
var
   LFrmDadosAdicionais: TFrmDadosAdicionais;
begin
  if StrToInt(SenhaAtual(GetCodPA(Sender))) <= 0 then Exit;

  {$IFNDEF IS_MOBILE}
  LockWindowUpdate(WindowHandleToPlatform(Self.Handle).Wnd);
  {$ENDIF IS_MOBILE}
  FreeAndNil(FJSONDadosAdicionais);

  LFrmDadosAdicionais := FrmDadosAdicionais(IDUnidade, True);
  LFrmDadosAdicionais.CarregarDadosAdicionais(GetCodPA(Sender), SenhaAtual(GetCodPA(Sender)), IDUnidade);
  LFrmDadosAdicionais.Show;

  Application.ProcessMessages;
  Sleep(10);

  LockWindowUpdate(0);

  LFrmDadosAdicionais.ShowModal(
    procedure (aModalResult: TModalResult)
    begin
      if (aModalResult = mrOk) then
      begin

      end;
    end);

  AtualizarObservacaoPA(GetCodPA(Sender));
  OrganizaPAs;
end;

function TFrmBase_PA_MPA.AtendenteLogado(PA: Integer): Boolean;
begin
  Result := (NomeAtendente(PA) <> SemAtendente);
end;

procedure TFrmBase_PA_MPA.AtendenteMouseClick(Sender: TObject);
begin
  edtNomeClienteExit(Sender);
end;

procedure TFrmBase_PA_MPA.AtualizarAtendente(const NomeAtendente: string; const PA, aCodAtend: Integer);
var
  LLblAtendente: TLabel;
begin
  LLblAtendente := GetLblAtendente(PA);
  if Assigned(LLblAtendente) then
    LLblAtendente.Text := 'Atendente: ' + NomeAtendente;
end;

procedure TFrmBase_PA_MPA.AtualizarEspera(const PA, Qtde: Integer; const aPodeChamarProximo: Boolean);
var
  LLblEspera: TLabel;
  LDMClient: TDMClient;
begin
  if not GetPaJaFoiCriada(PA) then
    Exit;
  LLblEspera := GetLblEspera(PA);
  if Assigned(LLblEspera) then
    LLblEspera.Text := 'Espera: ' + IntToStr(Qtde);

  {$IFDEF CompilarPara_PA}
  if vgParametrosModulo.VisualizaPessoasFilas then
  begin
    LDMClient := DMClient(IDUnidade, not CRIAR_SE_NAO_EXISTIR);
    DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).EnviarComando(IntToHex(PA, 4) + Chr($4B), IdUnidade);
  end;
  {$ENDIF}

  UpdateButtons(PA);
end;

function TFrmBase_PA_MPA.QtdeSenhaEspera(const aPA: Integer): Integer;
var
  LEsperaText: String;
begin
  LEsperaText := GetLblEspera(aPA).Text;
  LEsperaText := Trim(Copy(LEsperaText, Pos(':', LEsperaText) + 1, Length(LEsperaText)));
  Result := StrToIntDef(Trim(LEsperaText), 0);
end;

procedure TFrmBase_PA_MPA.AtualizarIsPressedRetangulo(const aBotaoTag: FMX.StdCtrls.TButton);

  function GetCircle: TCircle;
  var
    i: Integer;
  begin
    Result := nil;
    for i := 0 to aBotaoTag.ComponentCount -1 do
    begin
      if aBotaoTag.Components[i] is TCircle then
      begin
        Result := TCircle(aBotaoTag.Components[i]);
        Break;
      end;
    end;
  end;
var
  LCircle: TCircle;
begin
  LCircle := GetCircle;
  if not Assigned(LCircle) then
    Exit;

  if aBotaoTag.IsPressed then
      LCircle.Fill.Kind  := TBrushKind.Gradient
  else
      LCircle.Fill.Kind  := TBrushKind.Solid;
end;

procedure TFrmBase_PA_MPA.AtualizarPropriedade(const NomePropriedade, NomeComponente: string;
      const ValorPropriedade: Variant; const PA: Integer; const aReplicarMenuTray: Boolean);
var
  Componente: TComponent;
begin
  Componente := GetComponentePA(NomeComponente, PA);

  {$IFDEF CompilarPara_MULTIPA}
  if not Assigned(Componente) then
    Componente := GetComponentePA(NomeComponente, 0);
  {$ENDIF CompilarPara_MULTIPA}
  AspAtualizarPropriedade(Self, Componente, NomePropriedade, ValorPropriedade);
end;

procedure TFrmBase_PA_MPA.AtualizarMotivoPausa(const aCor: TAlphaColor; const Motivo: string; const PA: Integer);
var
  aLabelMotivoPausa: TLabel;
begin
  aLabelMotivoPausa := GetLblMotivoPausa(PA);
  if Assigned(aLabelMotivoPausa) then
  begin
    aLabelMotivoPausa.Text := Motivo;
    aLabelMotivoPausa.Visible := ((Trim(Motivo) <> '') and vgParametrosModulo.MostrarBotaoPausa);
    aLabelMotivoPausa.StyledSettings := aLabelMotivoPausa.StyledSettings - [TStyledSetting.FontColor];
    if aCor = Self.Fill.Color then
      aLabelMotivoPausa.TextSettings.FontColor := claRed
    else
      aLabelMotivoPausa.TextSettings.FontColor := aCor;
  end;
end;

procedure TFrmBase_PA_MPA.AtualizarNomeCliente(NomeCliente: string; PA: Integer);
var
  LLblNomeCliente: TLabel;
begin
  LLblNomeCliente := GetLblNomeCliente(PA);

  if Assigned(LLblNomeCliente) then
    LLblNomeCliente.Text := Coalesce(NomeCliente, SemNomeCliente);
end;

procedure TFrmBase_PA_MPA.AtualizarNomePA(NomePA: string; PA: Integer);
var
  LFrmLogin: TFrmLogin;
  LLblNomePA: TLabel;
begin
  LLblNomePA := GetLblNomePA(PA);

  if Assigned(LLblNomePA) then
  begin
    LLblNomePA.Text := 'PA: ' + NomePA;
    LLblNomePA.Align := TAlignLayout.Top;
  end;

  LFrmLogin := FrmLogin(IdUnidade);

  if Assigned(LFrmLogin) then
    LFrmLogin.cboPA.ItemIndex := LFrmLogin.cboPA.Items.IndexOf(NomePA);

  OrganizaPAs;
end;

procedure TFrmBase_PA_MPA.AtualizarSenha(PA: Integer; Senha: string);
var
  LLblSenha: TLabel;
  Aux: string;
  {$IFDEF CompilarPara_MULTIPA}
  LDMClient: TDMClient;
  {$ENDIF CompilarPara_MULTIPA}
begin
  if not GetPaJaFoiCriada(PA) then
    Exit;

  DesligarTAGs(PA);
  SeparaStrings(Senha, TAB, Senha, Aux);

  LLblSenha := GetLblSenha(PA);
  if Assigned(LLblSenha) then
    LLblSenha.Text := Senha;

  if (Senha='---') and Assigned(FJSONDadosAdicionais) then
    FreeAndNil(FJSONDadosAdicionais);

  AtualizarNomeCliente(SemNomeCliente, PA);
  AtualizarObservacaoPA(PA);

  {$IFDEF CompilarPara_MULTIPA}
  LDMClient := DMClient(IdUnidade, not CRIAR_SE_NAO_EXISTIR);
  if Assigned(LDMClient) then
    LDMClient.ClearAtdCasoNecessario(PA);
  {$ENDIF CompilarPara_MULTIPA}

  UpdateButtons(PA);
end;

function TFrmBase_PA_MPA.BeginChanges(const aPA: Integer): Boolean;
begin
  if (aPA <= 0) then
  begin
    Result := False;
    Exit;
  end;

  while (Length(FCountChanges) <= aPA) do
  begin
    SetLength(FCountChanges, Length(FCountChanges) + 1);
    FCountChanges[Length(FCountChanges) - 1] := 0;
  end;

  Result := True;
  inc(FCountChanges[aPA]);
end;

function TFrmBase_PA_MPA.BeginUpdatePA(const aPA: Integer; const aCanClearArray: Boolean): Boolean;
begin
  if (aPA <= 0) and (aPA <> PA_VAZIA) then
  begin
    Result := False;
    Exit;
  end;

  while (Length(FCountUpdatePA) <= aPA) do
  begin
    SetLength(FCountUpdatePA, Length(FCountUpdatePA) + 1);
    FCountUpdatePA[Length(FCountUpdatePA) - 1] := 0;
  end;

  Result := FCountUpdatePA[aPA] = 0;
  if Result then inc(FCountUpdatePA[aPA]);
end;

function TFrmBase_PA_MPA.BotaoProximoEstaRechamando(PA: Integer): Boolean;
var
  btnProximo : TButton;
begin
  Result := False;
  btnProximo := GetbtnProximo(PA);

  if Assigned(btnProximo) and btnProximo.Visible then
    Result := (btnProximo.Text = 'Rechamar');
end;

procedure TFrmBase_PA_MPA.LBC_BotaoProximoViraRechama(PA: integer);
var
  btnProximo, btnRechamar : TButton;
  tmr : TTimer;
begin
  //Não muda o botão Próximo para Rechama caso o Rechama esteja visível
  btnRechamar := GetBtnRechamar (PA);

  if Assigned(btnRechamar) and btnRechamar.Visible then
    Exit;

  //Também não muda o botão Próximo para Rechama caso tempo em rechama seja menos de 2 segundos
  if vgParametrosModulo.SecsOnRecall < 2 then
    Exit;

  btnProximo  := GetBtnProximo (PA);

  if Assigned(btnProximo) and btnProximo.Visible then
  begin
    btnProximo.Text        := 'Rechamar';
    btnProximo.StyleLookup := 'BtRechamar';
    UpdateButtons(PA);
    tmr := TTimer(GetApplication.FindComponent('tmrBackToProximo'+inttostr(PA)));

    if(Assigned(tmr)) then tmr.Enabled := true;
  end;
end;

procedure TFrmBase_PA_MPA.LBC_BotaoProximoBackToProximo(PA: integer);
var
  btnProximo : TButton;
begin
  btnProximo  := GetBtnProximo (PA);

  if Assigned(btnProximo) and btnProximo.Visible then
  begin
    btnProximo.Text        := 'Próximo';
    btnProximo.StyleLookup := 'Btseta';
    UpdateButtons(PA);
  end;
end;

procedure TFrmBase_PA_MPA.LBC_tmrBackToProximoTimer(Sender: TObject);
var
  PA : integer;
begin
  if (Sender is TTimer) then
  begin
     (Sender as TTimer).Enabled := false;
     PA := (Sender as TTimer).Tag;
     LBC_BotaoProximoBackToProximo(PA);
  end;
end;

procedure TFrmBase_PA_MPA.btnProximoClick(Sender: TObject);
var
  LCodPA: SmallInt;
begin
  if Assigned(Sender) then
  begin
    if now - FControleDelaysBotoes[tbProximo] < EncodeTime(0, 0, 4, 0) then
      Exit
    else
      FControleDelaysBotoes[tbProximo] := now;

    LCodPA := GetCodPA((Sender as TControl));
    Proximo(Sender, LCodPA, True, true);
  end;
end;

procedure TFrmBase_PA_MPA.btnGrupoPAClick(Sender: TObject);
begin
  if Assigned(Sender) then
  begin
    if now - FControleDelaysBotoes[tbGrupoPA] < EncodeTime(0, 0, 4, 0) then
      Exit
    else
      FControleDelaysBotoes[tbGrupoPA] := now;
  end;
end;

procedure TFrmBase_PA_MPA.btnRechamarClick(Sender: TObject);
begin
  if now - FControleDelaysBotoes[tbRechama] < EncodeTime(0, 0, 4, 0) then
    Exit
  else
    FControleDelaysBotoes[tbRechama] := now;

  Rechamar(GetCodPA(Sender));
end;


procedure TFrmBase_PA_MPA.btnSeguirAtendimentoClick(Sender: TObject);
var
  LCodPA: Integer;
begin
  if now - FControleDelaysBotoes[tbSeguirAtendimento] < EncodeTime(0, 0, 4, 0) then
    Exit
  else
    FControleDelaysBotoes[tbSeguirAtendimento] := now;

  LCodPA := GetCodPA(Sender);

  FCodPAAtual := LCodPA;

  InputQuery('Seguir Atendimento.',
            ['Digite o Número do Prontuário:'],
            [''],
	          SeguirAtendimentoSenhaAtual);
end;

procedure TFrmBase_PA_MPA.CarregarParametrosDB(const aPA, aIdUnidade: Integer);
begin
  GetLblNomeCliente(aPA)        .Visible := vgParametrosModulo.MostrarNomeCliente;
  GetLblDescNomeCliente(aPA)    .Visible := vgParametrosModulo.MostrarNomeCliente;
  GetLblAtendente(aPA)          .Visible := vgParametrosModulo.MostrarNomeAtendente;
  //GetLblAtendente(aPA)          .Visible := vgParametrosModulo.MostrarPainelGrupos;
  GetLblNomePA(aPA)             .Visible := vgParametrosModulo.MostrarPA;
  GetBtnLogin(aPA)              .Visible := vgParametrosModulo.MostrarBotaoLogin;
  GetBtnProximo(aPA)            .Visible := vgParametrosModulo.MostrarBotaoProximo;
  GetBtnRechamar(aPA)           .Visible := vgParametrosModulo.MostrarBotaoRechama;
  GetBtnEspecifica(aPA)         .Visible := vgParametrosModulo.MostrarBotaoEspecifica;
  GetBtnEncaminhar(aPA)         .Visible := vgParametrosModulo.MostrarBotaoEncaminha;
  GetBtnFinalizar(aPA)          .Visible := vgParametrosModulo.MostrarBotaoFinaliza;
  GetBtnSeguirAtendimento(aPA)  .Visible := vgParametrosModulo.MostrarBotaoSeguirAtendimento;
  {$IFDEF CompilarPara_MULTIPA}
  GetBtnProcessos(aPA)          .Visible := vgParametrosModulo.VisualizarProcessosParalelos and vgParametrosModulo.MostrarBotaoProcessos;
  GetpnlGrupos              .Visible := vgParametrosModulo.MostrarPainelGrupos;
  {$ELSE}
  GetBtnProcessos(aPA)          .Visible := vgParametrosModulo.VisualizarProcessosParalelos;
  {$ENDIF}
  GetBtnPausar(aPA)             .Visible := vgParametrosModulo.MostrarBotaoPausa;

  {$IFDEF IS_MOBILE}
  btnCloseForm.Visible := False;
  {$ELSE}
  btnCloseForm.Visible := vgParametrosModulo.PodeFecharPrograma; //RAP 15/06/2016
  {$ENDIF}

  {$IFDEF CompilarPara_PA}
  if(not vgParametrosModulo.MostrarNomeCliente)then
    GetPnlSenha.Height := 30;

  if(not vgParametrosModulo.MostrarNomeAtendente)then
    GetPnlPA.Height := GetPnlPA.Height - 23;

  if(not vgParametrosModulo.MostrarPA)then
    GetPnlPA.Height := GetPnlPA.Height - 23;

  if(not GetLblNomePA(aPA).Visible) and (not GetLblAtendente(aPA).Visible)then
      GetLblEspera(aPA).Position.Y := 6
  else if(GetLblNomePA(aPA).Visible) and (not GetLblAtendente(aPA).Visible)then
    GetLblEspera(aPA).Position.Y := 26
  else if( not GetLblNomePA(aPA).Visible) and (GetLblAtendente(aPA).Visible)then
  begin
    GetLblAtendente(aPA).Position.Y := 6;
    GetLblEspera(aPA).Position.Y := 26;
  end;
  {$ENDIF}

  GetLblMotivoPausa(aPA).Visible := ((trim(GetLblMotivoPausa(aPA).Text) <> '') and vgParametrosModulo.MostrarBotaoPausa);

  AtualizarPropriedade(propVisible, cMnuLogin             , vgParametrosModulo.MostrarMenuLogin             , aPA, True);
  AtualizarPropriedade(propVisible, cMnuLogout            , vgParametrosModulo.MostrarMenuLogout            , aPA, True);
  if not (vgParametrosModulo.MostrarMenuLogin or vgParametrosModulo.MostrarMenuLogout) then
    AtualizarPropriedade(propVisible, cmnuDivLogin, False, aPA, True);
  AtualizarPropriedade(propVisible, cMnuAlterarSenha, vgParametrosModulo.MostrarMenuAlteraSenha, aPA, True);
  AtualizarPropriedade(propVisible, cMnuProximo           , vgParametrosModulo.MostrarMenuProximo           , aPA);
  AtualizarPropriedade(propVisible, cMnuRechamar          , vgParametrosModulo.MostrarMenuRechama           , aPA);
  AtualizarPropriedade(propVisible, cMnuEspecifica        , vgParametrosModulo.MostrarMenuEspecifica        , aPA);
  AtualizarPropriedade(propVisible, cMnuSeguirAtendimento , vgParametrosModulo.MostrarMenuSeguirAtendimento , aPA);
  AtualizarPropriedade(propVisible, cMnuEncaminhar        , vgParametrosModulo.MostrarMenuEncaminha         , aPA);
  AtualizarPropriedade(propVisible, cMnuFinalizar         , vgParametrosModulo.MostrarMenuFinaliza          , aPA);
  AtualizarPropriedade(propVisible, cMnuProcessos         , vgParametrosModulo.VisualizarProcessosParalelos , aPA);
  AtualizarPropriedade(propVisible, cMnuDivProcessos      , vgParametrosModulo.VisualizarProcessosParalelos , aPA);
  AtualizarPropriedade(propVisible, cMnuPausa             , vgParametrosModulo.MostrarMenuPausa             , aPA);
  AtualizarPropriedade(propVisible, cMnuDivPausa          , vgParametrosModulo.MostrarMenuPausa             , aPA);
  AtualizarPropriedade(propVisible, cMnuDivControleRemoto , vgParametrosModulo.MostrarMenuControleRemoto    , aPA);
  AtualizarPropriedade(propVisible, cMnuControleRemoto    , vgParametrosModulo.MostrarMenuControleRemoto    , aPA);

  AjustarTopBotoes(False);

  if(not Assigned(GetApplication.FindComponent('tmrBackToProximo'+inttostr(aPA))))then
  begin
    with TTimer.Create(GetApplication) do
    begin
      Enabled  := false;
      Interval := vgParametrosModulo.SecsOnRecall * 1000;
      Tag      := aPA;
      OnTimer  := LBC_tmrBackToProximoTimer;
      Name     := 'tmrBackToProximo'+inttostr(aPA);
    end;
  end;

  FrmLogin(IDUnidade).CarregarParametrosDB;
end;

constructor TFrmBase_PA_MPA.Create(AOwner: TComponent);
var
  i : TTipoDeBotaoPA;
begin
  FUltimaSituacaoForm := '';
  SetLength(FCountChanges, 0);
  SetLength(FCountUpdatePA, 0);
  SetLength(FListBtnsTAGs, 0);
  FMaxTAGsCriadas        := 0;
  DataClickConfiguracoes := 0;

  for i := Low(FControleDelaysBotoes) to High(FControleDelaysBotoes) do
    FControleDelaysBotoes[i] := 0;

  inherited;

  LUpdatingBeginUpdatePA := BeginUpdatePA(FListaPaUpdating);
end;

procedure TFrmBase_PA_MPA.CriarItemsMenu(const aIDPA: Integer;
  const aParent: TFmxObject; MenuBar: TFmxObject; const aSufixoNomeItens: String);
{$IFNDEF IS_MOBILE}
var
  MenuItem: TMenuItem;
  MenuOwner: TFmxObject;

  procedure AddMenuItem(const aNome: String; const aText: string = '-'; const aOnCLick: TNotifyEvent = nil);
  begin
    MenuItem         := TMenuItem.Create(aParent);
    MenuItem.Tag     := aIDPA;
    MenuItem.Name    := FormataNomeComponente(aNome + aSufixoNomeItens, aIDPA);
    MenuItem.Text    := aText;
    MenuItem.OnClick := aOnCLick;
    MenuOwner.AddObject(MenuItem);
  end;
{$ENDIF !IS_MOBILE}

begin
{$IFNDEF IS_MOBILE}
  {$IFDEF CompilarPara_PA}
  MenuOwner := MenuBar;
  AddMenuItem(cMnuArquivo, 'Arquivo');
  MenuOwner := MenuItem;
  {$ELSE}
  MenuOwner := MenuBar;
  {$ENDIF CompilarPara_PA}

  AddMenuItem(cMnuProximo, 'Próximo', btnProximoClick);
  AddMenuItem(cMnuRechamar, 'Rechamar', btnRechamarClick);
  AddMenuItem(cMnuEspecifica, 'Chamar senha específica', btnEspecificaClick);
  AddMenuItem(cMnuEncaminhar, 'Encaminhar', btnEncaminharClick);
  AddMenuItem(cMnuFinalizar, 'Finalizar', btnFinalizarClick);
  AddMenuItem(cMnuDivProcessos);
  AddMenuItem(cMnuProcessos, 'Processos paralelos', btnProcessosClick);
  AddMenuItem(cMnuDivPausa);
  AddMenuItem(cMnuPausa, 'Pausa', btnPausarClick);
  AddMenuItem(cMnuSeguirAtendimento, 'Seguir Atendimento', btnSeguirAtendimentoClick);


  AddMenuItem(cMnuDivControleRemoto);
  AddMenuItem(cMnuControleRemoto, 'Controle remoto - SICS TV', mnuControleRemotoClick);

  {$IFDEF CompilarPara_MultiPA}
  AddMenuItem(cMnuNomeCliente, 'Alterar Nome', lblNomeClienteClick);
  {$ENDIF CompilarPara_MultiPA}

  AddMenuItem(cmnuDivLogin);
  AddMenuItem(cMnuLogin, 'Login', btnLoginClick);
  AddMenuItem(cMnuLogout, 'Logout', btnLogoutClick);
  AddMenuItem(cMnuAlterarSenha, 'Alterar senha', mnuAlterarSenhaClick);
  AddMenuItem(cmnuDivSair);
  AddMenuItem(cmnuSair, 'Sair', mnuSairClick);

  {$IFDEF CompilarPara_PA}
  MenuOwner := MenuBar;
  AddMenuItem(cmnuInterrogacao, '?');
  MenuOwner := MenuItem;

  AddMenuItem(cmnuSobre, 'Sobre', mnuSobreClick);
  {$ENDIF CompilarPara_PA}
{$ENDIF !IS_MOBILE}
end;

procedure TFrmBase_PA_MPA.mnuSobreClick(Sender : TObject);
begin

end;

{$IFNDEF IS_MOBILE}
function TFrmBase_PA_MPA.CriarMenu(const aIDPA: Integer; const aParent: TFmxObject): TClasseMenu;
var
  LParent: TFmxObject;
begin
  if assigned(aParent) then
    LParent   := aParent
  else
    LParent   := Self;

{$IFDEF CompilarPara_MULTIPA}
  Result := TPopupMenu.Create(LParent);
  Result.OnPopup := OnPopupMenuBar;
{$ELSE}
  Result := TMenuBar.Create(LParent);
{$ENDIF CompilarPara_MULTIPA}

  Result.Parent := LParent;
  Result.Name   := FormataNomeComponente(cmnuBar, aIDPA);
  Result.Tag    := aIDPA;
  LParent.InsertComponent(Result);
  CriarItemsMenu(aIDPA, LParent, Result);

  FReferenciaMenu := Result;
end;
{$ENDIF IS_MOBILE}

procedure TFrmBase_PA_MPA.CriarTAGs(const PA: Integer);
var
  iTop, iLeft,
  LTopBtnTag, maiorTamanho : Single;
  grpBox                   : TGroupBox;
  FUltimoGrupBoxTags       : TControl;
  FUltimoBtnTag, btnTag    : TButton;
  LCircle                  : TCircle;
  LComponent, vPanelTAGs   : TComponent;
  LNomeGrupoTag            : String;
  LBeginUpdatePA           : Boolean;
  LDMClient                : TDMClient;
  LListBtnsTAGs            : TListBtnsTAGs;
  tituloGroupTag           : TLabel;

  procedure centralizaGruposTags;
  var
    recTags : TRectangle;
    LChildren: TFMxObject;
  begin
    recTags := GetRecTAGs(PA);

    if recTags.ChildrenCount > 0 then
    for LChildren in  recTags.Children do
    begin
      if(LChildren is TGroupBox)then
      begin
        if(TGroupBox(LChildren).Width < recTags.Width )then
        begin
          TGroupBox(LChildren).Position.X := (recTags.Width - TGroupBox(LChildren).Width)/2
        end;
      end;
    end;
  end;
begin
  if not GetPaJaFoiCriada(PA) then
    exit;

  LDMClient := DMClient(IdUnidade, not CRIAR_SE_NAO_EXISTIR);
{$IFNDEF IS_MOBILE}
  LockWindowUpdate(WindowHandleToPlatform(Self.Handle).Wnd);
{$ENDIF IS_MOBILE}
  try
    LBeginUpdatePA := BeginUpdatePA(PA);
    try
      try
        if not DMConnection(IDUnidade, not CRIAR_SE_NAO_EXISTIR).ValidarPA(PA, IdUnidade) then
          Exit;

        iTop := 5;
        FMaxTAGsCriadas := 0;
        maiorTamanho := 0;

        if (not LDMClient.cdsGruposDeTAGs.IsEmpty) and (not LDMClient.cdsTags.IsEmpty) then
          GetPnlTAGs(PA).Visible := True
        else
        begin
          GetPnlTAGs(PA).Visible := False;
          Exit;
        end;

        vPanelTAGs := GetrecTAGs(PA);

        if Assigned(vPanelTAGs) then
        begin
          vPanelTAGs.DestroyComponents;
          TControl(TControl(vPanelTAGs).Parent).Height := 4;
        end;

        TControl(vPanelTAGs).Width := 20;

        if not(Assigned(vPanelTAGs) and (vPanelTAGs is TControl)) then
          Exit;

        FUltimoGrupBoxTags := nil;

        LDMClient.cdsGruposDeTAGs.First;

        while not LDMClient.cdsGruposDeTAGs.Eof do
        begin
          LDMClient.cdsTags.Filter   := 'IdGrupo=' + LDMClient.cdsGruposDeTAGs.FieldByName('ID').AsString;
          LDMClient.cdsTags.Filtered := True;
          LDMClient.cdsTags.First;

          {$IFDEF CompilarPara_PA_MULTIPA}
          //{$IFDEF CompilarPara_PA}
          if ((LDMClient.cdsTags.IsEmpty) or
             (not IntInArray(LDMClient.cdsTags.FieldByName('IDgrupo').AsInteger, vgParametrosModulo.GruposTAGSLayoutBotao))) then
          begin
            LDMClient.cdsGruposDeTAGs.Next;
            Continue;
          end;
          //{$ENDIF CompilarPara_PA}
          {$ENDIF CompilarPara_PA_MULTIPA}

          Inc(FMaxTAGsCriadas);
          LNomeGrupoTag := FormataNomeComponente(cGrpTags + '_' + IntToStr(FMaxTAGsCriadas), PA);
          LComponent := vPanelTAGs.FindComponent(LNomeGrupoTag);

          if Assigned(LComponent) then
            FreeAndNil(LComponent);

          TControl(vPanelTAGs).width := (LDMClient.cdsTags.RecordCount * (BTN_WIDTH + cMarginLeft)) + 20;    // + 6

          grpBox                         := TGroupBox.Create(vPanelTAGs);
          grpBox.Margins.Left            := 4;
          grpBox.Margins.Top             := 4;
          FUltimoGrupBoxTags             := grpBox;
          grpBox.Enabled                 := True;
          grpBox.Align                   := TAlignLayout.None;
          grpBox.Align                   := TAlignLayout.MostTop;
          grpBox.Name                    := LNomeGrupoTag;
          grpBox.Text                    := '  ';
          grpBox.StyledSettings          := [TStyledSetting.Family, TStyledSetting.Size];
          grpBox.TextSettings.FontColor  := claNull;
          grpBox.TextSettings.Font.Style := [TFontStyle.fsBold];
          grpBox.StyleLookup             := 'grpTags';

          tituloGroupTag := TLabel.Create(grpBox);

          with tituloGroupTag do
          begin
            Parent   := grpBox;
            Name     := 'lbl'+LNomeGrupoTag;
            Text     := LDMClient.cdsGruposDeTAGs.FieldByName('NOME').AsString;
            Align    := TAlignLayout.MostTop;
            TextSettings.HorzAlign := TTextAlign.Center;
            AutoSize := True;
            //Visible  := IntInArray(LDMClient.cdsTags.FieldByName('IDgrupo').AsInteger, vgParametrosModulo.GruposTAGSLayoutBotao);
          end;

          if Assigned(vPanelTAGs) and (vPanelTAGs is TControl) then
            grpBox.Parent   := TControl(vPanelTAGs);

          {$IFNDEF IS_MOBILE}
          grpBox.Height     := 45;
          {$ENDIF IS_MOBILE}

          if (Assigned(vPanelTAGs) and (vPanelTAGs is TControl) and Assigned(TControl(vPanelTAGs).Parent) and
            (TControl(vPanelTAGs).Parent is TControl)) then
          begin
            {$IFDEF CompilarPara_MULTIPA}
            //TControl(TControl(vPanelTAGs).Parent).Height := TControl(TControl(vPanelTAGs).Parent).Height + TControl(vPanelTAGs).Height + TControl(vPanelTAGs).Margins.Top + 20;
            {$ENDIF CompilarPara_MULTIPA}

            {$IFDEF IS_MOBILE}
             TControl(TControl(vPanelTAGs).Parent).Height := 90;
             TControl(vPanelTAGs).Anchors    := [TAnchorKind.akTop];
             TControl(vPanelTAGs).Height     := 80;
             grpBox.Height                   := 80;
             TControl(vPanelTAGs).Position.Y := 5;
             TControl(TControl(vPanelTAGs).Parent).Position.Y := GetPnlLogin.Position.Y;
             GetPnlLogin.Position.Y          := TControl(TControl(vPanelTAGs).Parent).Position.Y + TControl(TControl(vPanelTAGs).Parent).Height;
            {$ELSE}
              TControl(TControl(vPanelTAGs).Parent).Height := 50;
              TControl(vPanelTAGs).Height    := 48;
            {$ENDIF IS_MOBILE}
          end;
         // grpBox.Width      := (LDMClient.cdsTags.RecordCount * (BTN_WIDTH + cMarginLeft)) + 20 + tituloGroupTag.Width;

          grpBox.Position.X := 0;
          grpBox.Position.Y := iTop;

          if(grpBox.Width > maiorTamanho)then
          begin
            maiorTamanho := grpBox.Width;
          end;

          iTop := iTop + grpBox.Height + 2;

          grpBox.Tag        := PA; // id da PA
          grpBox.Anchors    := [TAnchorKind.akLeft, TAnchorKind.akTop];
          grpBox.OnClick    := edtNomeClienteExit;
          grpBox.Visible    := tituloGroupTag.Visible;

          try
            iLeft := 4;
            LTopBtnTag := 17;
            FUltimoBtnTag := nil;

            LDMClient.cdsTags.First;
            while not LDMClient.cdsTags.Eof do
            begin
              btnTag              := TButton.Create(grpBox);
              FUltimoBtnTag       := btnTag;

              btnTag.Name         := FormataNomeComponente(cbtnTag + '_' + LDMClient.cdsTags.FieldByName('ID').AsString, PA);
              btnTag.Anchors      := [TAnchorKind.akLeft, TAnchorKind.akTop];
              btnTag.parent       := grpBox;
              btnTag.Position.X   := ((BTN_WIDTH + cMarginLeft ) * (LDMClient.cdsTags.RecNo - 1)) + ((grpBox.Width - ((BTN_WIDTH + cMarginLeft) * LDMClient.cdsTags.RecordCount)) /2) + 2;
              {$IFDEF IS_MOBILE}
              btnTag.Position.Y   := LTopBtnTag + 12; //RAP 02/06/2016
              {$ELSE}
              btnTag.Position.Y   := LTopBtnTag;
              {$ENDIF}

              btnTag.Width        := BTN_WIDTH;
              btnTag.Margins.Left := cMarginLeft;
              btnTag.Margins.Top  := 4;
              btnTag.Enabled      := True;
              btnTag.Height       := BTN_HEIGHT;
              iLeft := iLeft + btnTag.Width + 4;
              btnTag.StyleLookup  := 'BtCirculoVermelho';

              // *** não compatível com FMX, analisar alternativa!
              // GroupIndex := frmDataModuleClientes.cdsGruposDeTags.FieldByName('ID').AsInteger;

              // *** não compatível com FMX, analisar alternativa!
              // Layout := blGlyphRight; ==> não compatível com FMX

              btnTag.Tag          := LDMClient.cdsTags.FieldByName('ID').AsInteger;
              btnTag.Text         := '';
              btnTag.OnClick      := OnClickBtnTag;
              btnTag.OnMouseDown  := OnMouseDownBtnTag;
              btnTag.StaysPressed := True;

              LCircle                     := TCircle.Create(btnTag);
              LCircle.Name                := FormataNomeComponente(cRecColorTag + '_' + LDMClient.cdsTags.FieldByName('ID').AsString, PA);
              LCircle.Parent              := btnTag;
              LCircle.Align               := TAlignLayout.Client;
              LCircle.Fill.Color          := TAlphaColor(RGBtoBGR(LDMClient.cdsTags.FieldByName('CODIGOCOR').AsInteger) or $FF000000);   //RGBToAlphaColor(LDMClient.cdsTags.FieldByName('CODIGOCOR').AsInteger);
              LCircle.Fill.Kind           := TBrushKind.Solid;
              LCircle.Fill.Gradient.Style := TGradientStyle.Radial;
              LCircle.Fill.Gradient.Color := LCircle.Fill.Color;

              if EhCorClara(LCircle.Fill.Color) then
                LCircle.Fill.Gradient.Color1 := claBlack
              else if EhCorPreta(LCircle.Fill.Color) then
                LCircle.Fill.Gradient.Color1 := claYellow
              else
                LCircle.Fill.Gradient.Color1 := claWhite;

//              AddHint(btnTag, LDMClient.cdsTags.FieldByName('NOME').AsString, '', LCircle.Fill.Color);
              AddHint(btnTag, LDMClient.cdsTags.FieldByName('NOME').AsString, '', TAlphaColorRec.Black);

              LCircle.HitTest    := False;
              LCircle.Tag        := btnTag.Tag;
              LCircle.Width      := 100;
              LCircle.Height     := 100;
              LCircle.Position.X := 0;
              LCircle.Position.Y := 0;
              LCircle.Align      := TAlignLayout.Client;
              LListBtnsTAGs      := ListBtnsTAGs[PA];

              if Assigned(LListBtnsTAGs) then
                LListBtnsTAGs.AddButton(btnTag);

              LDMClient.cdsTags.Next;
            end;
          finally
            LDMClient.cdsTags.Filtered := False;
          end;

          grpBox.Repaint;
          LDMClient.cdsGruposDeTAGs.Next;
        end;

        TControl(vPanelTAGs).Repaint;
        GetpnlTAGs(PA).Height := iTop;
        GetRecTAGs(PA).Height := iTop;
        GetRecTAGs(PA).Width  := maiorTamanho;
        //{$IFDEF CompilarPara_MULTIPA}
        //GetPNL(PA).Height := GetPNL(PA).Height + TControl(vPanelTAGs).Height;
        //{$ENDIF CompilarPara_MULTIPA}
        AjustarTopBotoes(False);   //LBC VERIFICAR BUG #85
        {$IFDEF CompilarPara_MULTIPA}
        if (GetpnlTAGs(PA).Height > FAlturaTAGs) then
          FAlturaTAGs := Trunc(GetpnlTAGs(PA).Height);

        //if (GetPNL(PA).Height + TControl(vPanelTAGs).Height) > FAlturaMinima then
          //FAlturaMinima := Trunc(GetPNL(PA).Height + TControl(vPanelTAGs).Height);

        //GetPNL(PA).Height := FAlturaMinima;
        {$ENDIF CompilarPara_MULTIPA}

        centralizaGruposTags;
      except
        on E: Exception do
          TLog.MyLog('Erro ao criar tags ' + E.Message, Self);
      end;
    finally
      if LBeginUpdatePA then
        EndUpdatePA(PA);
    end;
  finally
{$IFNDEF IS_MOBILE}
    LockWindowUpdate(0);
{$ENDIF IS_MOBILE}
  end;
end;

procedure TFrmBase_PA_MPA.DefinirNomeParaSenha(PA, Senha: Integer; NomeCliente: string);
var
  LFrmProcessoParalelo: TFrmProcessoParalelo;
begin
  if (SenhaAtual(PA) = IntToStr(Senha)) then
  begin
    if NomeCliente = '' then
      AtualizarNomeCliente(SemNomeCliente, PA)
    else
      AtualizarNomeCliente(NomeCliente, PA);
  end;

  LFrmProcessoParalelo := FrmProcessoParalelo(IDUnidade);
  if Assigned(LFrmProcessoParalelo) then
    LFrmProcessoParalelo.UpdateNomeCliente(Senha, NomeCliente);
end;

procedure TFrmBase_PA_MPA.DesligarOutrasTAGGrupos(const aIDPA: Integer; const aTagAtual: FMX.StdCtrls.TButton);
var
  i: Integer;
  LSpeedButton: FMX.StdCtrls.TButton;
  OldStaysPressed: Boolean;
  LListBtnsTAGs: TListBtnsTAGs;
begin
  LListBtnsTAGs := ListBtnsTAGs[aIDPA];
  if not Assigned(LListBtnsTAGs) then
    Exit;

  for I := 0 to Length(LListBtnsTAGs.ListaBotoes) - 1 do
  begin
    LSpeedButton              := (LListBtnsTAGs.ListaBotoes[i] as FMX.StdCtrls.TButton);
    //A tag atual e as tags do outro grupo não serão desmarcada
    if (LSpeedButton = aTagAtual) or (LSpeedButton.Parent <> aTagAtual.Parent) then
      Continue;

    OldStaysPressed := LSpeedButton.StaysPressed;
    try
      LSpeedButton.StaysPressed := True;
      LSpeedButton.IsPressed    := False;
      AtualizarIsPressedRetangulo(LSpeedButton);
    finally
      LSpeedButton.StaysPressed := OldStaysPressed;
    end;
  end;
end;

procedure TFrmBase_PA_MPA.DesligarTAGs(PA: Integer);
var
  I           : Integer;
  LSpeedButton: FMX.StdCtrls.TButton;
  OldStaysPressed: Boolean;
  LListBtnsTAGs: TListBtnsTAGs;
begin
  if not GetPaJaFoiCriada(PA) then
    exit;

  if DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).ValidarPA(PA, IDUnidade) then
  begin
    LListBtnsTAGs := ListBtnsTAGs[PA];

    if not Assigned(LListBtnsTAGs) then
      Exit;

    for I := 0 to Length(LListBtnsTAGs.ListaBotoes) - 1 do
    begin
      if (Assigned(LListBtnsTAGs.ListaBotoes[I])) and (LListBtnsTAGs.ListaBotoes[I] is FMX.StdCtrls.TButton) then
      begin
        try
          Sleep(10);
          LSpeedButton              := (LListBtnsTAGs.ListaBotoes[I] as FMX.StdCtrls.TButton);
          //OldStaysPressed := LSpeedButton.StaysPressed;

          //LSpeedButton.StaysPressed := True;
          //LSpeedButton.IsPressed    := False;
          //AtualizarIsPressedRetangulo(LSpeedButton);
        finally
          //LSpeedButton.StaysPressed := OldStaysPressed;
        end;
      end;
    end;

    UpdateButtons(PA);
  end;
end;

destructor TFrmBase_PA_MPA.Destroy;
begin
  DestroyListaBtnsTags;

  {$IFNDEF IS_MOBILE}
  FReferenciaMenu := nil;
  {$ENDIF}

  inherited;
end;

procedure TFrmBase_PA_MPA.DestroyListaBtnsTags;
var
  i: Integer;
begin
  for i := 0 to Length(FListBtnsTAGs) -1 do
  begin
    if (FListBtnsTAGs[i] <> nil) then
      FListBtnsTAGs[i].Free;
    FListBtnsTAGs[i] := nil;
  end;

  SetLength(FListBtnsTAGs, 0);
end;

function TFrmBase_PA_MPA.EstaEmAtendimento(PA: Integer): Boolean;
begin
  Result := (SenhaAtual(PA) <> '');
end;

procedure TFrmBase_PA_MPA.ExibeMensagemDeAlarme(sNomePI, sNomeNivel,
  sCorNivel, sMensagem: string);
var
  LArquivo, LSQL: string;
begin
  //KM - Alteração da exibição do alerta para o modo Notificação em Popup - BT303
  TNotificacaoPopup.Exibir(sMensagem,
                           sNomeNivel,
                           TAlphaColor(RGBtoBGR(StrToIntDef(sCorNivel, TAlphaColorRec.Gray)) or $FF000000),
                           300,
                           sNomePI);

  LArquivo := ExtractFilePath(ParamStr(0))+'\PIALERTASONORO.WAV';

  if (FileExists(LArquivo)) then
    PlaySound(PChar(LArquivo), 0, SND_ASYNC);
  Exit;
  with DMClient(vgParametrosModulo.IdUnidadeCliente, True) do
  begin
    LSQL := qryPIsPermitidos.SQL.Text;

    qryPIsPermitidos.Close;
    qryPIsPermitidos.SQL.Text := Format(LSQL, [IntToStr(vgParametrosModulo.PIAlertaSonoro)]);
    qryPIsPermitidos.Open;

    //(sNomePI = DMClient(IdUnidade, not CRIAR_SE_NAO_EXISTIR).(vgParametrosModulo.PIAlertaSonoro))

    qryPIsPermitidos.Close;
  end;
end;

procedure TFrmBase_PA_MPA.Encaminhar(PA: Integer);
var
  LSituacaoPAAoExibirForm: String;
begin
  inherited;

  if EstaEmAtendimento(PA) then
  begin
    if (not vgParametrosModulo.ConfirmarEncaminha) then
      EncaminharSemConfirmar(PA)
    else
    begin
      LSituacaoPAAoExibirForm := GetSituacaoAtualPA(PA);

      ConfirmationMessage('Deseja encaminhar esta senha para o próximo atendimento?',
        procedure (const aOK: Boolean)
        begin
          if aOK then
          begin
            if (LSituacaoPAAoExibirForm = GetSituacaoAtualPA(PA)) then
              EncaminharSemConfirmar(PA)
            else
              ErrorMessage(Format('A senha %s não foi encaminhada. '+ #13 +
                'Somente é permite encaminhar senhas que estão em atendimento.' + #13 +
                'Situação PA anterior "%s", situação PA atual "%s"',
                [SenhaAtual(PA), LSituacaoPAAoExibirForm, GetSituacaoAtualPA(PA)]));
          end;
        end);
    end;
  end;
end;

procedure TFrmBase_PA_MPA.EncaminharSemConfirmar(PA: Integer);
var
  LFila: Integer;
  LSituacaoPAAoExibirForm: String;
  LFrmSelecaoFila: TFrmSelecaoFila;
  LSenhaAtual: String;
  LIdUnidade: Integer;
begin
  inherited;
  LSenhaAtual:= SenhaAtual(PA);
  LIdUnidade:= IdUnidade;

  LFrmSelecaoFila := FrmSelecaoFila(LIdUnidade);

  if EstaEmAtendimento(PA) then
  begin
    if ((not vgParametrosModulo.ManualRedirect) and (not TAGsObrigatorias(PA))) then
      DMConnection(LIdUnidade, not CRIAR_SE_NAO_EXISTIR).Finalizar(PA, LIdUnidade)
    else
    begin
      LFrmSelecaoFila.PermiteFinalizar := not TAGsObrigatorias(PA);
      LFrmSelecaoFila.FPA    := PA;
      LFrmSelecaoFila.FSenha := StrToIntDef(LSenhaAtual, -1);
      LSituacaoPAAoExibirForm := GetSituacaoAtualPA(PA);

      LFrmSelecaoFila.ShowModal(
        procedure(aResult: TModalResult)
        begin
          if aResult = mrOk then
          begin
            if (LSituacaoPAAoExibirForm = GetSituacaoAtualPA(PA)) then
            begin
              LFila := LFrmSelecaoFila.IdSelecionado;

              if (LFila = 0) or (LFila = -1) then
                DMConnection(LIdUnidade, not CRIAR_SE_NAO_EXISTIR).Finalizar(PA, LIdUnidade)
              else
              begin
                DMConnection(LIdUnidade, not CRIAR_SE_NAO_EXISTIR).Redirecionar(PA, LFila, LIdUnidade);

                if vgParametrosModulo.MarcarTagAposAtendimento then
                begin
                  DMConnection(LIdUnidade, not CRIAR_SE_NAO_EXISTIR).DefinirTag(PA, StrToIntDef(LSenhaAtual,0), vgParametrosModulo.IdTagAutomatica, LIdUnidade);
                end;
              end;
            end
            else
              ErrorMessage(Format ('A senha %s não foi encaminhada. ' + #13 + 'Somente é permite encaminhar senhas que estão em atendimento.' + #13 +
			                             'Situação PA anterior "%s", situação PA atual "%s"', [LSenhaAtual, LSituacaoPAAoExibirForm, GetSituacaoAtualPA(PA)]));
          end;
        end)
    end;
  end;
end;

procedure TFrmBase_PA_MPA.EncaminharSenhaFilaTriagem(const aSenha,
  aFilaTriagem: Integer;const aNomeTriagem: string = '');
begin
  if (aFilaTriagem > 0) and (aSenha > 0) then
  begin
    ConfirmationMessage('Deseja encaminhar a senha ' + aSenha.ToString + ' para ' + aNomeTriagem,
      procedure (const aOK: Boolean)
      var
        LJson:TJSonObject;
        //LParametrosEntradaObterDadosAdicionais: APIs.Aspect.Sics.DadosAdicionais.TParametrosEntradaObterAPI;
        //LParametrosSaidaObterDadosAdicionais: APIs.Aspect.Sics.DadosAdicionais.TParametrosSaidaObterAPI;
        LParametrosEntradaImprimirEtiqueta : APIs.Aspect.Sics.ImprimirEtiqueta.TParametrosEntradaAPI;
        LErroAPI: APIs.Common.TErroAPI;
        LContinua: boolean;
        LIdTrakCare, LLocalParRef, LCodProfissional: string;
      begin
        if aOK then
        begin
          LContinua:= True;

          if vgParametrosModulo.EnviaEtiqueta then
          begin
            //LParametrosEntradaObterDadosAdicionais.SENHA := asenha.ToString;
            //LParametrosEntradaObterDadosAdicionais.IDUnidade := vgParametrosModulo.IdUnidadeCliente;

            with DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR) do
            begin
              //SolicitarDadosAdicionais(FCodPAAtual, aSenha.ToString, vgParametrosModulo.IdUnidadeCliente);

              EnviarComando(TAspEncode.AspIntToHex(FCodPAAtual, 4) + Chr($CD) + aSenha.ToString, IdUnidade);

              Application.ProcessMessages;

              LJson := FJSONDadosAdicionais;
            end;

            //if APIs.Aspect.Sics.DadosAdicionais.ObterDados(LParametrosEntradaObterDadosAdicionais, LParametrosSaidaObterDadosAdicionais, LErroAPI) = raok then

            if LJson.TryGetValue('idtrakcare', LIdTrakCare) then
            begin
              LJson.TryGetValue('LOCALPARREF', LLocalParRef);
              LJson.TryGetValue('CODPROFISSIONAL', LCodProfissional);

              LParametrosEntradaImprimirEtiqueta.IdPassagem    := LIdTrakCare;
              LParametrosEntradaImprimirEtiqueta.Device        := vgParametrosModulo.NomeImpressoraEtiqueta;
              LParametrosEntradaImprimirEtiqueta.QtdeImpressao := vgParametrosModulo.QtdeImpressao;
              LParametrosEntradaImprimirEtiqueta.Etiqueta      := vgParametrosModulo.ModeloImpressora;
              LParametrosEntradaImprimirEtiqueta.LocalPArRef   := StrToIntDef(LLocalParRef, 0);
              LParametrosEntradaImprimirEtiqueta.IdMedico      := StrToIntDef(LCodProfissional, 0);

              if APIs.Aspect.Sics.ImprimirEtiqueta.TAPIAspectSicsImprimirEtiqueta.URL<>'' then
              if APIs.Aspect.Sics.ImprimirEtiqueta.TAPIAspectSicsImprimirEtiqueta.Execute(LParametrosEntradaImprimirEtiqueta, LErroAPI) <> raOk then
              begin
                if MessageDlg('Falha ao imprimir a etiqueta.'+chr(13)+'Continuar o envio da senha?', TMsgDlgType.mtWarning, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) = mrNo then
                begin
                  LContinua:= False;
                end;
              end;
            end;
          end;

          if LContinua then
          begin
            DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).InserirSenhaFila(aSenha, aFilaTriagem);
          end;
        end;
      end);
  end;
end;

function TFrmBase_PA_MPA.EndChanges(const aPA: Integer): Boolean;
begin
  if InChanges(aPA) then
  begin
    FCountChanges[aPA] := 0;
    ApplyChanges(aPA);
  end;
  Result := True;
end;

function TFrmBase_PA_MPA.EndUpdatePA(const aPA: Integer): Boolean;
begin
  Result := False;

  if (Length(FCountUpdatePA) <= aPA) or (aPA < PA_VAZIA) then
    Exit;

  FCountUpdatePA[aPA] := FCountUpdatePA[aPA] -1;
  Result := FCountUpdatePA[aPA] = 0;

  if Result and InChanges(aPA) then
    EndChanges(aPA);
end;

function TFrmBase_PA_MPA.EndUpdatePA(var aListaPa: TIntegerDynArray): Boolean;
var
  i: Integer;
  LList: TIntegerDynArray;
begin
  Result := True;
  LList := aListaPa;
  SetLength(aListaPa, 0);

  for I  in LList do
  begin
    if not (EndUpdatePA(I)) then
    begin
      Result := False;
      SetLength(aListaPa, Length(aListaPa) + 1);
      aListaPa[Length(aListaPa) -1] := i;
    end;
  end;
end;

procedure TFrmBase_PA_MPA.EscondeEdtNomeCliente(Sender: TObject);
begin
  if(edtNomeClienteSelecionado <> nil)then
    edtNomeClienteSelecionado.OnExit(edtNomeClienteSelecionado);
end;

procedure TFrmBase_PA_MPA.SenhaEspecifica;
begin
  FSituacaoPAAoExibirForm := GetSituacaoAtualPA(FPAChamarEspecifica);

  if ((not vgParametrosModulo.ManualRedirect) or (not EstaEmAtendimento(FPAChamarEspecifica))) then
  begin
    if FSenhaDoubleClickGridPessoasFilaDeEspera > 0 then
    begin
      ChamarEspecificaSemEncaminharSenhaAtual(mrOk, [FSenhaDoubleClickGridPessoasFilaDeEspera.ToString]);
      FSenhaDoubleClickGridPessoasFilaDeEspera := 0;
    end
    else
      InputQuery('Chamar senha específica.',
                 ['Digite a senha:'],
                 [''],
	               ChamarEspecificaSemEncaminharSenhaAtual);
  end
  else
  begin
    TimerExibirFormSelecaoDeFilas.Enabled := True;
  end;
end;

procedure TFrmBase_PA_MPA.Especifica(PA: Integer);
begin
  FPAChamarEspecifica     := PA;
  FFilaChamarEspecifica   := -999;
  FSenhaChamarEspecifica  := -999;
  FSituacaoPAAoExibirForm := EmptyStr;

  SenhaEspecifica;
end;

procedure TFrmBase_PA_MPA.Finalizar(PA: Integer);
var
  LSituacaoPAAoExibirForm: String;
begin
  if EstaEmAtendimento(PA) then
  begin
    if (not vgParametrosModulo.ConfirmarFinaliza) then
      DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).Redirecionar(PA, 0, IdUnidade)
    else
    begin
      LSituacaoPAAoExibirForm := GetSituacaoAtualPA(PA);

      ConfirmationMessage('Deseja finalizar o atendimento desta senha?',
      procedure (const aOK: Boolean)
      begin
        if aOK then
        begin
          if (LSituacaoPAAoExibirForm = GetSituacaoAtualPA(PA)) then
            DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).Redirecionar(PA, 0, IdUnidade)
          else
            ErrorMessage(Format('A senha %s não foi encaminhada. '+ #13 +
                'Somente é permite encaminhar senhas que estão em atendimento.' + #13 +
                'Situação PA anterior "%s", situação PA atual "%s"',
                [SenhaAtual(PA), LSituacaoPAAoExibirForm, GetSituacaoAtualPA(PA)]));
        end;
      end);
    end;
  end;
end;

procedure TFrmBase_PA_MPA.ForcarModoDesconectado;
begin

end;

procedure TFrmBase_PA_MPA.FormActivate(Sender: TObject);
begin
  inherited;

  dmUnidades.FormClient := Self;
  ConfiguraCloseBtn;
  AjustarTopBotoes(True);
end;

function TFrmBase_PA_MPA.FormataNomeComponente(const aNomeComponente: String; const aPA: Integer): String;
begin
  Result := aNomeComponente;
end;

procedure TFrmBase_PA_MPA.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  canClose := ((not vgParametrosModulo.JaEstaConfigurado) or vgParametrosModulo.PodeFecharPrograma);
  inherited;
end;

procedure TFrmBase_PA_MPA.FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  inherited;

  {$IFNDEF IS_MOBILE}
  if ((Key = VK_F8) and (ssCtrl in Shift)) then
  begin
    if not Assigned(frmSicsCommon_LCDBInput) then
      frmSicsCommon_LCDBInput := TfrmSicsCommon_LCDBInput.Create(self, IdUnidade);

    frmSicsCommon_LCDBInput.showmodal(
      procedure (aModalResult: TModalResult)
      begin
      end);
  end;
  {$ENDIF IS_MOBILE}
end;

{$IFNDEF IS_MOBILE}
function TFrmBase_PA_MPA.PodeMinimizarParaBandeja(Sender: TObject): Boolean;
begin
  Result := vgParametrosModulo.MinimizarParaBandeja;
end;
{$ENDIF IS_MOBILE}

function TFrmBase_PA_MPA.PossuiSenhaEspera(const aPA: Integer): Boolean;
begin
  Result := (QtdeSenhaEspera(aPA) > 0);
end;

procedure TFrmBase_PA_MPA.FormResize(Sender: TObject);
  procedure centralizaGruposTags;
  var
    recTags : TRectangle;
    LChildren1: TFMxObject;
  begin
    recTags := GetRecTAGs(DMClient(vgParametrosModulo.IdUnidadeCliente, True).FCurrentPA);
    if not Assigned(recTags) then Exit;
    
//btnTag.Position.X   := ((BTN_WIDTH + cMarginLeft ) * (LDMClient.cdsTags.RecNo - 1)) + ((grpBox.Width - ((BTN_WIDTH + cMarginLeft) * LDMClient.cdsTags.RecordCount)) /2) + 2;

    if recTags.ChildrenCount > 0 then
      for LChildren1 in recTags.Children do
      begin
        if (LChildren1 is TGroupBox) then
        begin
          for var i := 0 to TGroupBox(LChildren1).ComponentCount - 1 do
          begin
            if (LChildren1.Components[i] is TButton) then
            begin
              TButton(LChildren1.Components[i]).Position.X :=
              ((BTN_WIDTH + cMarginLeft) * (i - 1)) + ((TGroupBox(LChildren1).Width - ((BTN_WIDTH + cMarginLeft) * (LChildren1.ComponentCount - 1))) / 2) + 2;
            end;
          end;
        end;
      end;
  end;
begin
  inherited;
  AjustarTopBotoes(True);
  centralizaGruposTags;
end;

procedure TFrmBase_PA_MPA.FormShow(Sender: TObject);
var
  LParametroSaida: APIs.Aspect.Sics.BuscarParametro.TParametrosSaidaAPI;
  LErroAPI: APIs.Common.TErroAPI;
begin
  inherited;
  if APIs.Aspect.Sics.BuscarParametro.TAPIAspectSicsBuscarParametro.URL<>'' then
    if APIs.Aspect.Sics.BuscarParametro.TAPIAspectSicsBuscarParametro.Execute(LParametroSaida, LErroAPI) = TTipoRetornoApi.raOK then
      vgParametrosModulo.ListaTriagemJson := LParametroSaida.Valor;

  AjustarTopBotoes(True);
end;

function TFrmBase_PA_MPA.InChanges(const aPA: Integer): Boolean;
begin
  Result := ((length(FCountChanges) > aPA) and (aPA >= PA_VAZIA) and (FCountChanges[aPA] <> 0));
end;

procedure TFrmBase_PA_MPA.InicializarMenu;
begin

end;

function TFrmBase_PA_MPA.LerPropriedade(const aNomePropriedade, aNomeComponente: string; const aValorPadrao: Variant; const aPA: Integer): Variant;
var
  LComponente: TComponent;
begin
  LComponente := GetComponentePA(aNomeComponente, aPA);
  Result      := AspLerPropriedade(LComponente, aNomePropriedade, aValorPadrao);
end;

procedure TFrmBase_PA_MPA.Login(const PA, aCodAtend: Integer);
begin
  if(GetBtnLogin(PA).Text = 'Logout')then
    Logout(PA, aCodAtend, False)
  else
    Logout(PA, aCodAtend, true);
end;

procedure TFrmBase_PA_MPA.Logout(const PA, aCodAtend: Integer; const aExibirTelaLogin, aAutoLogin: Boolean; const aSenhaAtend: String; const aPALogar: Integer; const somenteDeslogar : Boolean);
var
  Fila, LCodPaLogar: Integer;
  LSituacaoPAAoExibirForm: String;
  LFrmSelecaoFila: TFrmSelecaoFila;
begin
  if EstaEmAtendimento(PA) and TAGsObrigatorias(PA) then
    Exit;

  LFrmSelecaoFila := FrmSelecaoFila(IdUnidade);

  if (aPALogar > -1) then
    LCodPaLogar := aPALogar
  else
    LCodPaLogar := PA;

  if vgParametrosModulo.ManualRedirect and EstaEmAtendimento(PA) and (not somenteDeslogar)then
  begin
    LFrmSelecaoFila.PermiteFinalizar := not TAGsObrigatorias(PA);
    LSituacaoPAAoExibirForm := GetSituacaoAtualPA(PA);

    LFrmSelecaoFila.ShowModal(
      procedure(aResult: TModalResult)
      begin
        if (aResult <> mrOk) then
          Exit;

        if (LSituacaoPAAoExibirForm = GetSituacaoAtualPA(PA)) then
        begin
          Fila := LFrmSelecaoFila.IdSelecionado;
          GetEdtNomeCliente(PA).Visible := False;

          if ((PA <> -1) and (aCodAtend <> -1)) then
            DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).EnviarComando(IntToHex(PA, 4) + Chr($55) + IntToHex(aCodAtend, 4) + IntToHex(Fila, 4), IdUnidade);

          if aExibirTelaLogin and ((PA <> -1) or ((PA = -1) and vgParametrosModulo.ModoTerminalServer)) then
          begin
            FrmLogin(IdUnidade).PA := LCodPaLogar;

            if (aAutoLogin) then
              DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).VerificarLogin(LCodPaLogar, IntToStr(aCodAtend), aSenhaAtend, IdUnidade)
            else
              FrmLogin(IdUnidade).ShowModal(nil);
          end;
        end
        else
          ErrorMessage(Format('A senha %s não está em atendimento. '+ #13 +
			                        'Somente é permite encaminhar senhas que estão em atendimento.' + #13 +
			                        'Situação PA anterior "%s", situação PA atual "%s".',
			                        [SenhaAtual(PA), LSituacaoPAAoExibirForm, GetSituacaoAtualPA(PA)]));
      end);
  end
  else
  begin
    GetEdtNomeCliente(PA).Visible := False;

    if ((PA <> -1) and (aCodAtend <> -1)) then
      DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).EnviarComando(IntToHex(PA, 4) + Chr($55) + IntToHex(aCodAtend, 4) + IntToHex(Fila, 4), IdUnidade);

    if aExibirTelaLogin and ((PA <> -1) or ((PA = -1) and vgParametrosModulo.ModoTerminalServer)) then
    begin
      FrmLogin(IdUnidade).PA := LCodPaLogar;

      if (aAutoLogin) then
        DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).VerificarLogin(LCodPaLogar, IntToStr(aCodAtend), aSenhaAtend, IdUnidade)
      else
        FrmLogin(IdUnidade).ShowModal(nil);
    end;
  end;
end;

procedure TFrmBase_PA_MPA.mnuSairClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TFrmBase_PA_MPA.IniciarPausa(PA: Integer; const AExibeBtnSeguirAtendimento:boolean = False);
var
  Fila: Integer;
  IdMP: Integer;
  LSituacaoPAAoExibirForm: string;
  LFrmSelecaoFila: TFrmSelecaoFila;
  LSeguirAtendimento:boolean;
begin
  Fila := 0;
  IdMP := 0;
  LSituacaoPAAoExibirForm := GetSituacaoAtualPA(PA);
  LFrmSelecaoFila := FrmSelecaoFila(IdUnidade);
  LSeguirAtendimento:= False;

  if AExibeBtnSeguirAtendimento then
  begin
    LFrmSelecaoFila.lytRodape.Height := 105;
    LFrmSelecaoFila.layOkCancelar.Position.Y := 3;
    LFrmSelecaoFila.laySeguirAtendimento.Position.Y := 55;
    LFrmSelecaoFila.laySeguirAtendimento.Visible := True;
  end
  else
  begin
    LFrmSelecaoFila.lytRodape.Height := 55;
    LFrmSelecaoFila.layOkCancelar.Position.Y := 3;
    LFrmSelecaoFila.laySeguirAtendimento.Visible := False;
  end;

  if (vgParametrosModulo.ManualRedirect) and EstaEmAtendimento(PA) then
  begin
    LFrmSelecaoFila.PermiteFinalizar := not TAGsObrigatorias(PA);

    LFrmSelecaoFila.ShowModal(
      procedure(aResult: TModalResult)
      begin
        if (LSituacaoPAAoExibirForm = GetSituacaoAtualPA(PA)) then
        begin
          if (aResult = mrCancel) then
          begin
            GetBtnPausar(PA).IsPressed := False;
            Exit;
          end
          else if (aResult = mrContinue) then
          begin
            LSeguirAtendimento := True;
          end;

          Fila := LFrmSelecaoFila.IdSelecionado;

          FrmSelecaoMotivoPausa(IdUnidade).ShowModal(
            procedure(aResult: TModalResult)
            begin
              if (LSituacaoPAAoExibirForm = GetSituacaoAtualPA(PA)) then
              begin
                if (aResult = mrOk) then
                begin
                  IdMP := FrmSelecaoMotivoPausa(IdUnidade).IdSelecionado;

                  if not LSeguirAtendimento then
                  begin
                    DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).EnviarComando(IntToHex(PA, 4) + Chr($28) + IntToHex(IdMP, 4) + IntToHex(Fila, 4), IdUnidade);
                  end
                  else
                  begin
                    SeguirAtendimentoSenhaAtualEmPausa(IdMP);
                  end;
                end
                else
                  GetBtnPausar(PA).IsPressed := False;
              end
              else
                ErrorMessage(Format('A senha %s não está em atendimento. '+ #13 +
                  'Somente é permite encaminhar senhas que estão em atendimento.' + #13 +
                  'Situação PA anterior "%s", situação PA atual "%s".',
                  [SenhaAtual(PA), LSituacaoPAAoExibirForm, GetSituacaoAtualPA(PA)]));
            end);
        end
        else
          ErrorMessage(Format('A senha %s não está em atendimento. '+ #13 +
            'Somente é permite encaminhar senhas que estão em atendimento.' + #13 +
            'Situação PA anterior "%s", situação PA atual "%s".',
            [SenhaAtual(PA), LSituacaoPAAoExibirForm, GetSituacaoAtualPA(PA)]));
      end);
  end
  else
  begin
    FrmSelecaoMotivoPausa(IdUnidade).ShowModal(
      procedure(aResult: TModalResult)
      begin
        if (LSituacaoPAAoExibirForm = GetSituacaoAtualPA(PA)) then
        begin
          if (aResult = mrOk) then
          begin
            IdMP := FrmSelecaoMotivoPausa(IdUnidade).IdSelecionado;
            DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).EnviarComando(IntToHex(PA, 4) + Chr($28) + IntToHex(IdMP, 4) + IntToHex(Fila, 4), IdUnidade);
          end
          else
            GetBtnPausar(PA).IsPressed := False;
        end
        else
          ErrorMessage(Format('A senha %s não está em atendimento. '+ #13 +
            'Somente é permite encaminhar senhas que estão em atendimento.' + #13 +
            'Situação PA anterior "%s", situação PA atual "%s".',
            [SenhaAtual(PA), LSituacaoPAAoExibirForm, GetSituacaoAtualPA(PA)]));
      end);
  end;
end;

function TFrmBase_PA_MPA.InUpdatePA(const aPA: Integer): Boolean;
begin
  Result := ((length(FCountUpdatePA) > aPA) and (aPA >= PA_VAZIA) and (FCountUpdatePA[aPA] <> 0));
end;

procedure TFrmBase_PA_MPA.TerminarPausa(PA: Integer);
begin
  DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).EnviarComando(TAspEncode.AspIntToHex(PA, 4) + Chr($28) + '----', IdUnidade);
end;

procedure TFrmBase_PA_MPA.ChamarEspecificaSemEncaminharSenhaAtual(
  const AResult: TModalResult; const AValues: array of string);
begin
  if (AResult = mrOk) then
  begin
    if (FSituacaoPAAoExibirForm = GetSituacaoAtualPA(FPAChamarEspecifica)) then
    begin
      FSenhaChamarEspecifica := -1;

      if (length(AValues) = 1)  then
        FSenhaChamarEspecifica := StrToIntDef(AValues[0], -1);

      if (FSenhaChamarEspecifica = -1) then
        ErrorMessage(Format('A senha "%s" informada não é numérica.', [ArrayToString(AValues)]))
      else
      begin
        if vgParametrosModulo.ConfirmarSenhaOutraFila then
          DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).ChamarEspecifica(FPAChamarEspecifica, FSenhaChamarEspecifica, IdUnidade)
        else
          DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).ForcarChamada(FPAChamarEspecifica, FSenhaChamarEspecifica, IdUnidade);
      end;
    end
    else
      ErrorMessage(Format('A senha %s específica não foi chamada. '+ #13 +
      'Somente é permite encaminhar senhas que estão em atendimento.' + #13 +
      'Situação PA anterior "%s", situação PA atual "%s".',
      [SenhaAtual(FPAChamarEspecifica), FSituacaoPAAoExibirForm, GetSituacaoAtualPA(FPAChamarEspecifica)]));
  end;
end;

procedure TFrmBase_PA_MPA.ChamarEspecificaEncaminhandoSenhaAtual(
  const AResult: TModalResult; const AValues: array of string);
begin
  if (AResult = mrOk) then
  begin
    if (FSituacaoPAAoExibirForm = GetSituacaoAtualPA(FPAChamarEspecifica)) then
    begin
      FSenhaChamarEspecifica := -1;

      if (length(AValues) = 1)  then
        FSenhaChamarEspecifica := StrToIntDef(AValues[0], -1);

      if (FSenhaChamarEspecifica = -1) then
        ErrorMessage(Format('A senha "%s" informada não é numérica.', [ArrayToString(AValues)]))
      else
      begin
        if (FFilaChamarEspecifica = 0) or (FFilaChamarEspecifica = -1) then
        begin
          if vgParametrosModulo.ConfirmarSenhaOutraFila then
            DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).ChamarEspecifica(FPAChamarEspecifica, FSenhaChamarEspecifica, IdUnidade)
          else
            DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).ForcarChamada(FPAChamarEspecifica, FSenhaChamarEspecifica, IdUnidade);
        end
        else
        begin
          if vgParametrosModulo.ConfirmarSenhaOutraFila then
            DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).Redirecionar_Especifica(FPAChamarEspecifica, FFilaChamarEspecifica, FSenhaChamarEspecifica, IdUnidade)
          else
            DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).Redirecionar_ForcarChamada(FPAChamarEspecifica, FFilaChamarEspecifica, FSenhaChamarEspecifica, IdUnidade);
        end;
      end;
    end
    else
      ErrorMessage(Format('A senha %s específica não foi chamada. '+ #13 +
        'Somente é permite encaminhar senhas que estão em atendimento.' + #13 +
        'Situação PA anterior "%s", situação PA atual "%s".',
        [SenhaAtual(FPAChamarEspecifica), FSituacaoPAAoExibirForm, GetSituacaoAtualPA(FPAChamarEspecifica)]));
  end;
end;

procedure TFrmBase_PA_MPA.TimerExibirFormSelecaoDeFilasTimer(Sender: TObject);
var
  LFrmSelecaoFila: TFrmSelecaoFila;
begin
    inherited;
    TimerExibirFormSelecaoDeFilas.Enabled := False;
    LFrmSelecaoFila := FrmSelecaoFila(IdUnidade);
    LFrmSelecaoFila.PermiteFinalizar := not TAGsObrigatorias(FPAChamarEspecifica);
    LFrmSelecaoFila.ShowModal(
      procedure(aResult: TModalResult)
      begin
        if (aResult <> mrOk) then
        begin
          FSenhaDoubleClickGridPessoasFilaDeEspera := 0;
          Exit;
        end;

        if (FSituacaoPAAoExibirForm = GetSituacaoAtualPA(FPAChamarEspecifica)) then
        begin
          FFilaChamarEspecifica := LFrmSelecaoFila.IdSelecionado;

          if FSenhaDoubleClickGridPessoasFilaDeEspera > 0 then
          begin
            ChamarEspecificaEncaminhandoSenhaAtual(mrOk, [FSenhaDoubleClickGridPessoasFilaDeEspera.ToString]);
            FSenhaDoubleClickGridPessoasFilaDeEspera := 0;
          end
          else
            InputQuery('Chamar senha específica.',
                       ['Digite a senha:'],
                       [''],
                       ChamarEspecificaEncaminhandoSenhaAtual);
        end
        else
          ErrorMessage(Format('A senha %s específica não foi chamada. '+ #13 +
			      'Somente é permite encaminhar senhas que estão em atendimento.' + #13 +
            'Situação PA anterior "%s", situação PA atual "%s".',
            [SenhaAtual(FPAChamarEspecifica), FSituacaoPAAoExibirForm, GetSituacaoAtualPA(FPAChamarEspecifica)]));
      end)
end;

function TFrmBase_PA_MPA.NomeAtendente(PA: Integer): string;
var
  vLabel: TLabel;
begin
  Result := SemAtendente;
  vLabel := GetLblAtendente(PA);

  if Assigned(vLabel) then
    Result := Copy(vLabel.Text,12);
end;

function TFrmBase_PA_MPA.GetNomeCliente(PA: Integer): string;
begin
  Result := '';

  if GetPaJaFoiCriada(PA) then
  begin
    Result := GetLblNomeCliente(PA).Text;
    if not EstaPreenchidoCampo(Result) then
      Result := '';
  end;
end;

function TFrmBase_PA_MPA.NomePA(PA: Integer): string;
var
  vLabel: TLabel;
begin
  Result := SemNomeCliente;
  vLabel := GetLblNomePA(PA);

  if Assigned(vLabel) then
    Result := Copy(vLabel.Text, Pos(':', vLabel.Text) + 2);
end;

procedure TFrmBase_PA_MPA.OnClickBtnTag(Sender: TObject);
var
  PA  : Integer;
  PSWD: string;

  function BtnIsPressed(aControl: TObject): Boolean;
  var
    LButton: FMX.StdCtrls.TButton;
  begin
    Result := False;
    if Assigned(aControl) then
    begin
      if (aControl is FMX.StdCtrls.TButton) then
      begin
        LButton := FMX.StdCtrls.TButton(aControl);
        Result := LButton.IsPressed;
        //if LButton.IsPressed then
          //DesligarOutrasTAGGrupos(PA, LButton);
        AtualizarIsPressedRetangulo(LButton);
      end
      else
      if (Sender is TControl) then
        Result := BtnIsPressed(TControl(aControl).Parent);
    end;
  end;
begin
  if not (Assigned(Sender) and (Sender is TControl)) then
    Exit;

  {$IFDEF CompilarPara_PA}
  if(vgParametrosModulo.ModoTerminalServer)then
    PA := DMClient(IdUnidade, not CRIAR_SE_NAO_EXISTIR).FCurrentPA
  else
  {$ENDIF}
    PA   := (Sender as TControl).parent.Tag;
  PSWD := SenhaAtual(PA);

  if PSWD <> '' then
  begin
    if BtnIsPressed(Sender) then
      DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).DefinirTag(PA, StrToInt(PSWD), TControl(Sender).Tag, IdUnidade)
    else
      DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).DesassociarTag(PA, StrToInt(PSWD), TControl(Sender).Tag, IdUnidade);

    if vgParametrosModulo.TAGsObrigatorias then
      UpdateButtons(PA);
  end;
end;

procedure TFrmBase_PA_MPA.OnMouseDownBtnTag(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
var
  PA  : Integer;
  PSWD: string;
begin
  // esse codigo foi necessario para NAO deixar o botão AFUNDAR quando NAO tiver senha

  PA   := (Sender as TControl).parent.Tag;
  PSWD := SenhaAtual(PA);

  if PSWD = '' then
    Abort;
end;

procedure TFrmBase_PA_MPA.OnPopupMenuBar(Sender: Tobject);
begin
  if Assigned(Sender) and (Sender is TControl) then
    UpdateButtons(TControl(Sender).tag);
end;

procedure TFrmBase_PA_MPA.Pausa(PA: Integer);
var
  MotivoPausa: Integer;
  Fila       : Integer;
  vIsPressed : Boolean;
  vbtnProximo: TComponent;
  LSituacaoPAAoExibirForm: String;
  LFrmSelecaoFila: TFrmSelecaoFila;
begin
  MotivoPausa := 0;
  Fila        := 0;
  vIsPressed  :=  GetBtnPausar(PA).IsPressed;
  LFrmSelecaoFila := FrmSelecaoFila(IdUnidade);
  if vIsPressed then
  begin
    LSituacaoPAAoExibirForm := GetSituacaoAtualPA(PA);
    if vgParametrosModulo.ManualRedirect and (SenhaAtual(PA) <> '') then
    begin
      LFrmSelecaoFila.PermiteFinalizar := not TAGsObrigatorias(PA);
      LFrmSelecaoFila.ShowModal(
        procedure(aModalResult: TModalResult)
        begin
          if (LSituacaoPAAoExibirForm = GetSituacaoAtualPA(PA)) then
          begin
            if (aModalResult <> mrOk) then
            begin
               GetBtnPausar(PA).IsPressed := False;
              Exit;
            end;
            Fila := LFrmSelecaoFila.IdSelecionado;
            FrmSelecaoMotivoPausa(IdUnidade).ShowModal(
              procedure(aModalResult: TModalResult)
              begin
                if (LSituacaoPAAoExibirForm = GetSituacaoAtualPA(PA)) then
                begin
                  if (aModalResult = mrOk) then
                  begin
                    MotivoPausa := FrmSelecaoMotivoPausa(IdUnidade).IdSelecionado;
                    DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).EnviarComando(IntToHex(PA, 4) + Chr($28) + IntToHex(MotivoPausa, 4) + IntToHex(Fila, 4), IdUnidade)
                  end
                  else
                     GetBtnPausar(PA).IsPressed := False;
                end
                else
					        ErrorMessage(Format('A senha %s não está em atendimento. '+ #13 +
			                                'Somente é permite encaminhar senhas que estão em atendimento.' + #13 +
			                                'Situação PA anterior "%s", situação PA atual "%s".',
			                                [SenhaAtual(PA), LSituacaoPAAoExibirForm, GetSituacaoAtualPA(PA)]));
              end);
          end
          else
			      ErrorMessage(Format('A senha %s não está em atendimento. '+ #13 +
			                          'Somente é permite encaminhar senhas que estão em atendimento.' + #13 +
			                          'Situação PA anterior "%s", situação PA atual "%s".',
			                          [SenhaAtual(PA), LSituacaoPAAoExibirForm, GetSituacaoAtualPA(PA)]));
        end);
    end
    else
    begin
      FrmSelecaoMotivoPausa(IdUnidade).ShowModal(
        procedure(aModalResult: TModalResult)
        begin
          if (LSituacaoPAAoExibirForm = GetSituacaoAtualPA(PA)) then
          begin
            if (aModalResult = mrOk) then
            begin
              MotivoPausa := FrmSelecaoMotivoPausa(IdUnidade).IdSelecionado;
              DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).EnviarComando(IntToHex(PA, 4) + Chr($28) + IntToHex(MotivoPausa, 4) + IntToHex(Fila, 4), IdUnidade)
            end
            else
               GetBtnPausar(PA).IsPressed := False;
          end
          else
			      ErrorMessage(Format('A senha %s não está em atendimento. '+ #13 +
			                          'Somente é permite encaminhar senhas que estão em atendimento.' + #13 +
			                          'Situação PA anterior "%s", situação PA atual "%s".',
			                          [SenhaAtual(PA), LSituacaoPAAoExibirForm, GetSituacaoAtualPA(PA)]));
        end);
    end;
  end
  else
  begin
    DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).EnviarComando(TAspEncode.AspIntToHex(PA, 4) + Chr($28) + '----', IdUnidade);
    vbtnProximo := GetBtnProximo(PA);
    if Assigned(vbtnProximo) and (vbtnProximo is FMX.StdCtrls.TButton) and FMX.StdCtrls.TButton(vbtnProximo).CanFocus then
      FMX.StdCtrls.TButton(vbtnProximo).SetFocus;
  end;
end;

procedure TFrmBase_PA_MPA.ProcessosParalelos(const aPA, aCodAtend: Integer);
var
  Senha  : Integer;
  LSituacaoPAAoExibirForm: String;
begin
  if (not EstaEmAtendimento(aPA)) then
  begin

    LSituacaoPAAoExibirForm := GetSituacaoAtualPA(aPA);
    InputQuery('Processos Paralelos.',
      ['Digite a senha:'], [''],
	    procedure (const AResult: TModalResult; const AValues: array of string)
      begin
        if (AResult = mrOk) then
        begin
          if (LSituacaoPAAoExibirForm = GetSituacaoAtualPA(aPA)) then
          begin
            Senha := -1;
            if (length(AValues) = 1)  then
              Senha := StrToIntDef(AValues[0], -1);
            if (Senha = -1) then
              ErrorMessage(Format('A senha "%s" informada não é numérica.', [ArrayToString(AValues)]))
            else
              ProcessosParalelos(aPA, aCodAtend, Senha);
          end
          else
            ErrorMessage(Format('A senha %s não está em atendimento. '+ #13 +
	      		                    'Somente é permite encaminhar senhas que estão em atendimento.' + #13 +
			                          'Situação PA anterior "%s", situação PA atual "%s".',
      			                    [SenhaAtual(aPA), LSituacaoPAAoExibirForm, GetSituacaoAtualPA(aPA)]));
        end;
      end);
  end
  else
  begin
    Senha := StrToIntDef(SenhaAtual(aPA), -1);
    if (Senha = -1) then
      ErrorMessage(Format('A senha "%s" informada não é numérica.', [SenhaAtual(aPA)]))
    else
      ProcessosParalelos(aPA, aCodAtend, Senha);
  end;
end;

procedure TFrmBase_PA_MPA.ProcessosParalelos (const aPA, aCodAtend, aSenha: Integer);
var
  Timeout: TDateTime;
  LFrmProcessoParalelo: TFrmProcessoParalelo;
begin
  LFrmProcessoParalelo := FrmProcessoParalelo(IdUnidade);
  LFrmProcessoParalelo.ListagemServidor := False;

  DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).EnviarComando(TAspEncode.AspIntToHex(aPA, 4) + Chr($58) + IntToStr(aSenha), IdUnidade);

  Timeout := Now + EncodeTime(0, 0, 10, 0);
  while (Now < Timeout) and (not LFrmProcessoParalelo.ListagemServidor) do
  begin
    Application.ProcessMessages;
    Sleep(100);
  end;

  if LFrmProcessoParalelo.ListagemServidor then
  begin
    LFrmProcessoParalelo.SenhaAtual := aSenha;
    LFrmProcessoParalelo.PAAtual    := aPA;
    LFrmProcessoParalelo.AtdAtual   := aCodAtend;
    LFrmProcessoParalelo.ShowModal(nil);
  end
  else
    ErrorMessage('Timeout ao obter lista de processos paralelos do servidor.');
end;

procedure TFrmBase_PA_MPA.Proximo(const aSender: TObject; const PA: Integer; const aPodeExibirConfirmacao, aExibirErroForaDeContexto: Boolean);
var
  LSituacaoPAAoExibirFormProximo: string;
  TextoBotaoProximo            : string;
  TextoBotaoRechamar           : string;
begin
  try
    if not ASsigned(aSender) then
    begin
      TLog.MyLog('Sender próximo não informado.', Self, ID_ERRO_Sender);
      Exit;
    end;

    TextoBotaoProximo := GetTextOfObject(aSender);
    TextoBotaoRechamar := GetBtnRechamar(PA).Text;

    if (TextoBotaoProximo = TextoBotaoRechamar) then
      Rechamar(PA)
    else if not(vgParametrosModulo.TAGsObrigatorias and (EstaEmAtendimento(PA)) and TAGsObrigatorias(PA)) then
    begin
      if (not (aPodeExibirConfirmacao and vgParametrosModulo.ConfirmarProximo)) then
        ChamarProximo(PA, aExibirErroForaDeContexto)
      else
      begin
        LSituacaoPAAoExibirFormProximo := GetSituacaoAtualPA(PA);
        ConfirmationMessage('Deseja chamar o próximo atendimento?',
          procedure (const aOK: Boolean)
          begin
            if aOK then
            begin
              if (LSituacaoPAAoExibirFormProximo = GetSituacaoAtualPA(PA)) then
                ChamarProximo(PA, aExibirErroForaDeContexto)
              else
              if aExibirErroForaDeContexto then
                ErrorMessage(Format('A senha %s não foi encaminhada. '+ #13 +
                                    'Somente é permite encaminhar senhas que estão em atendimento.' + #13 +
                                    'Situação PA anterior "%s", situação PA atual "%s"',
                                    [SenhaAtual(PA), LSituacaoPAAoExibirFormProximo, GetSituacaoAtualPA(PA)]));
            end;
          end);
      end;
    end;
  except
    TLog.MyLog('Erro ao chamar o próximo.', Self);
    Exit;
  end;
end;

procedure TFrmBase_PA_MPA.CarregarParametrosDB(const aIDUnidade: Integer);
begin
  inherited;
end;

procedure TFrmBase_PA_MPA.CarregarParametrosDB;
begin
  inherited;

  if LUpdatingBeginUpdatePA then
    BeginUpdatePA(FListaPaUpdating, False);
end;

procedure TFrmBase_PA_MPA.CarregarParametrosINI;
begin
  inherited;

end;

procedure TFrmBase_PA_MPA.ChamarProximo (const PA: Integer; const aExibirErroForaDeContexto: Boolean);
var
  LSituacaoPAAoExibirForm       : string;
  Fila                          : Integer;
  LFrmSelecaoFila               : TFrmSelecaoFila;
begin
  LFrmSelecaoFila := FrmSelecaoFila(IdUnidade);
  if ((not vgParametrosModulo.ManualRedirect) or (SenhaAtual(PA) = '')) then
    DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).Proximo(PA, IdUnidade)
  else
  begin
    LFrmSelecaoFila.PermiteFinalizar := not TAGsObrigatorias(PA);
    LSituacaoPAAoExibirForm := GetSituacaoAtualPA(PA);
    LFrmSelecaoFila.ShowModal(
      procedure(aResult: TModalResult)
      begin
        if (aResult <> mrOk) then
          Exit;

        if (LSituacaoPAAoExibirForm = GetSituacaoAtualPA(PA)) then
        begin
          Fila := LFrmSelecaoFila.IdSelecionado;

          if (Fila = 0) or (Fila = -1) then
            DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).Proximo(PA, IdUnidade)
          else
            DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).Redirecionar_Proximo(PA, Fila, IdUnidade);

          if (not EstaEmAtendimento(PA)) then                                                  //comentaria devido BT #351, porém ao comentar não sai mais da tela de seleção de fila
          begin                                                                                //comentaria devido BT #351, porém ao comentar não sai mais da tela de seleção de fila
            //if aExibirErroForaDeContexto and (not PossuiSenhaEspera(PA)) then
            //  InformationMessage('No momento nenhuma senha está aguardando atendimento.');
            Exit;                                                                              //comentaria devido BT #351, porém ao comentar não sai mais da tela de seleção de fila
          end;
        end
        else
        if aExibirErroForaDeContexto then
          ErrorMessage(Format('A senha %s não está em atendimento. '+ #13 +
                              'Somente é permite encaminhar senhas que estão em atendimento.' + #13 +
                              'Situação PA anterior "%s", situação PA atual "%s".',
                              [SenhaAtual(PA), LSituacaoPAAoExibirForm, GetSituacaoAtualPA(PA)]));
      end);
  end;
end;

procedure TFrmBase_PA_MPA.ClienteConfigurado;
begin
  if LUpdatingBeginUpdatePA then
    EndUpdatePA(FListaPaUpdating);
end;

function TFrmBase_PA_MPA.GetCodAtendente(const aPA: Integer): Integer;
begin
  Result := StrToIntDef(GetLblCodAtendente(aPA).Text, -1);
end;

function TFrmBase_PA_MPA.GetComponentePA(const aNome: String; const aCodPA: Integer; const aFindInSubComponent: Boolean): TComponent;
begin
  Result := AspFindComponentAndSubComp(Self, FormataNomeComponente(aNome, aCodPA), aFindInSubComponent);
end;

function TFrmBase_PA_MPA.GetComponentePAEdt(const aNome: String; const aCodPA: Integer): TEdit;
var
  LObjAux: TComponent;
begin
  Result  := nil;
  LObjAux := GetComponentePA(aNome, aCodPA);
  if Assigned(LObjAux) then
    Result := LObjAux as TEdit;
end;

function TFrmBase_PA_MPA.GetComponentePALabel(const aNome: String; const aCodPA: Integer): TLabel;
var
  LObjAux: TComponent;
begin
  Result  := nil;
  LObjAux := GetComponentePA(aNome, aCodPA);
  if Assigned(LObjAux) then
    Result := LObjAux as TLabel;
end;

function TFrmBase_PA_MPA.GetEstaEmPausa(const aPA: Integer): Boolean;
begin
  Result := GetMotivoPausaAtual(aPA) <> '';
end;

procedure TFrmBase_PA_MPA.GetFilaTriagemPorId(const LIdTriagem: integer;
  var LFilaTriagem: Integer; var LNomeTriagem: string);
var
  LJson : TjsonObject;
  LArrayObjeto: TJSONArray;
  LIdJson   : integer;
  LFilaJson : integer;
  LNomeJson : String;
  LNomeImpressoraEtiquetaJSON: string;
  LQtdeImpressaoJSON: integer;
  LModeloImpressoraJSON: string;
  LCount:integer;
begin
  try
    LFilaTriagem := 0;
    LNomeTriagem := '';
    LJson := TJSONObject.ParseJSONValue(vgParametrosModulo.ListaTriagemJson) as TJSONObject;
    if LJson.TryGetValue('Triagens', LArrayObjeto) then
    begin
      for LCount := 0 to Pred(LArrayObjeto.Count) do
      begin
        LJson := (LArrayObjeto.Items[LCount] as TJSONObject);
        LJson.TryGetValue('ID', LIdJson);

        if LIdTriagem =  LIdJson then
        begin
          LJson.TryGetValue('Fila', LFilaJson);
          LJson.TryGetValue('Nome', LNomeJson);
          LJson.TryGetValue('NomeImpressoraEtiqueta', vgParametrosModulo.NomeImpressoraEtiqueta);
          LJson.TryGetValue('QtdeImpressao', vgParametrosModulo.QtdeImpressao);
          LJson.TryGetValue('ModeloImpressora', vgParametrosModulo.ModeloImpressora);

          LFilaTriagem := LFilaJson;
          LNomeTriagem := LNomeJson;
        end;
      end;
    end;
  finally
    LJson.Free;
  end;
end;

function TFrmBase_PA_MPA.GetIndexPANaListBtnsTAGs(const aIDPA: Integer): Word;
var
  i: Integer;
begin
  for i := 0 to Length(FListBtnsTAGs) -1 do
  begin
    if ((FListBtnsTAGs[i] <> nil) and (FListBtnsTAGs[i].PA = aIDPA)) then
    begin
      Result := i;
      Exit;
    end;
  end;

  SetLength(FListBtnsTAGs, Length(FListBtnsTAGs) +1);
  Result := Length(FListBtnsTAGs) -1;
  FListBtnsTAGs[Result]     := TListBtnsTAGs.Create;
  FListBtnsTAGs[Result].PA  := aIDPA;
end;

function TFrmBase_PA_MPA.GetListBtnsTAGs(const aIDPA: Integer): TListBtnsTAGs;
var
  LIndex: Integer;
begin
  LIndex := GetIndexPANaListBtnsTAGs(aIDPA);
  Result := nil;
  if ((LIndex > -1) and (LIndex < Length(FListBtnsTAGs))) then
    Result := FListBtnsTAGs[LIndex];
end;

function TFrmBase_PA_MPA.GetMotivoPausaAtual(const aPA: Integer): String;
var
  aLabelMotivoPausa: TLabel;
begin
  Result := '';
  aLabelMotivoPausa := GetLblMotivoPausa(aPA);
  if Assigned(aLabelMotivoPausa) then
    Result := Trim(aLabelMotivoPausa.Text);
end;

function TFrmBase_PA_MPA.GetPaJaFoiCriada(const aPA: Integer): Boolean;
begin
  Result := True;
end;

procedure TFrmBase_PA_MPA.Rechamar(PA: Integer);
begin
  DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).Rechamar(PA, IdUnidade);
end;

procedure TFrmBase_PA_MPA.SeguirAtendimentoSenhaAtualEmPausa(const AIDMotivoPausa: integer);
begin
  InputQuery('Seguir Atendimento.',
            ['Digite o Número do Prontuário:'],
            [''],
            procedure (const AResult: TModalResult; const AValues: array of string)
            var
              LValues: array of string;
            begin
              if (AResult = mrOk) then
              begin
                SetLength(LValues,3);
                LValues[0] := AValues[0];
                LValues[1] := 'TRUE';
                LValues[2] := AIDMotivoPausa.ToString;
                SeguirAtendimentoSenhaAtual(AResult,LValues);
              end;
            end);
end;

procedure TFrmBase_PA_MPA.SeguirAtendimentoSenhaAtual(const AResult: TModalResult; const AValues: array of string);
var
  LParametrosEntradaSeguirAtendimento: APIs.Aspect.Sics.SeguirAtendimento.TParametrosEntradaAPI;
  LParametrosSaidaSeguirAtendimento: APIs.Aspect.Sics.SeguirAtendimento.TParametrosSaidaAPI;
  LErroAPI: APIs.Common.TErroAPI;
  //LSender: TButton;
  LResposta: string;
begin
  if (AResult = mrOk) then
  begin
    if StrToIntDef(AValues[0], 0) > 0 then
    begin
      LParametrosEntradaSeguirAtendimento.Prontuario := AValues[0];
      LParametrosEntradaSeguirAtendimento.CodPA      := FCodPAAtual;
      LParametrosEntradaSeguirAtendimento.Unidade    := StrToIntDef(vgParametrosModulo.Unidade, 0);
      LParametrosEntradaSeguirAtendimento.Senha      := StrToInt(SenhaAtual(FCodPAAtual));

      AtualizarMotivoPausa(TAlphaColorRec.Red, 'Seguindo com o Atendimento da Senha... Aguarde...', LParametrosEntradaSeguirAtendimento.CodPA);
      Application.ProcessMessages;

      if Length(AValues) >= 2 then
      begin
        //LEmPausa := UpperCase(AValues[1]) = 'TRUE';
        LParametrosEntradaSeguirAtendimento.MotivoPausa := StrToIntDef(AValues[2],0);
      end;

      try
        AtualizarMotivoPausa(TAlphaColorRec.Red, 'Buscando Paciente... Aguarde...', LParametrosEntradaSeguirAtendimento.CodPA);
        Application.ProcessMessages;

        if APIs.Aspect.Sics.SeguirAtendimento.TAPIAspectSicsSeguirAtendimento.URL<>'' then
        if APIs.Aspect.Sics.SeguirAtendimento.TAPIAspectSicsSeguirAtendimento.Execute(LParametrosEntradaSeguirAtendimento, LParametrosSaidaSeguirAtendimento, LErroAPI) <> raOK then
        begin
          LResposta := EmptyStr;
          ShowMessage('Ocorreu um erro: ' + LParametrosSaidaSeguirAtendimento.Motivo);
          AtualizarMotivoPausa(TAlphaColorRec.Red, '', LParametrosEntradaSeguirAtendimento.CodPA);
          Application.ProcessMessages;
          exit;
        end
        else
          ShowMessage('Atendimento seguido com sucesso.');
      except on e:exception do
        begin
          LResposta := EmptyStr;
          ShowMessage('Ocorreu um erro API: ' + APIs.Aspect.Sics.SeguirAtendimento.TAPIAspectSicsSeguirAtendimento.URL + e.Message);
          AtualizarMotivoPausa(TAlphaColorRec.Red, '', LParametrosEntradaSeguirAtendimento.CodPA);
          Application.ProcessMessages;
          exit;
        end;
      end;

      AtualizarMotivoPausa(TAlphaColorRec.Red, '', LParametrosEntradaSeguirAtendimento.CodPA);
    end;
  end;
end;

procedure TFrmBase_PA_MPA.SelecionarTAGs(PA: Integer; Ids: array of Integer);
var
  iTag, J : Integer; // RAP
  LDMClient: TDMClient;
  ListBoxTAG: TListBox;

  procedure AddListBox_TAGs(LListBox: TListBox; LListItem: string; LCodigoCor: Integer);
  var
    LListBoxItem: TListBoxItem;
    LRectangle: TRectangle;
  begin
    if LListBox.Items.IndexOf(LListItem) > -1 then Exit;

    LListBoxItem := TListBoxItem.Create(LListBox);

    with LListBoxItem do
    begin
      Parent                   := LListBox;
      StyledSettings           := [];
      TextSettings.Font.Family := 'Montserrat';
      TextSettings.Font.Size   := 20;
      TextSettings.HorzAlign   := TTextAlign.Center;
      //Margins.Bottom         := 5;
      Position.Y               := 49;
      Size.Width               := 459;
      Size.Height              := 44;
      Size.PlatformDefault     := False;
      //StyleLookup            := 'listboxitemstyle';
      Name                     := 'ListBoxItem_' + IntToStr(LDMClient.cdsTags.FieldByName('ID').AsInteger);
      Text                     := LListItem;
      Hint                     := LListItem;
      ShowHint                 := True;
      Margins.Bottom           := 2;

      BringToFront;
    end;

    if LListBox.Height < 149 then
      LListBox.Height := LListBox.Height + 50;

    LRectangle := TRectangle.Create(LListBoxItem);

    with LRectangle do
    begin
      Parent := LListBoxItem;
      Fill.Color := TAlphaColor(RGBtoBGR(LCodigoCor) or $FF000000);
      Fill.Kind := TBrushKind.bkSolid;
      Stroke.Kind := TBrushKind.bkNone;
      Width := 0;
      Height := 0;
      Position.X := 0;
      Position.Y := 0;
      Align := TAlignLayout.Client;
      AddHint(LRectangle, LListItem, '', TAlphaColorRec.Black);
    end;

    with TLabel.Create(LListBoxItem) do
    begin
      Parent := LRectangle;
      StyledSettings := [];
      TextSettings.Font.Family := 'Montserrat';
      TextSettings.Font.Size := 20;
      TextSettings.HorzAlign := TTextAlign.Center;
      TextSettings.FontColor := TAlphaColor(RGBtoBGR(InvertColor(LCodigoCor)) or $FF000000);
      Text := LListItem;
      Hint := LListItem;
      ShowHint := True;
      Align := TAlignLayout.Client;
      BringToFront;
    end;
  end;

  function SelecionarTAG(IdTag: Integer; grpName: string; Visible: Boolean): Boolean;
  var
    btn     : FMX.StdCtrls.TButton; // RAP
    grpBox  : TComponent;
    OldStaysPressed: Boolean;
  begin
    grpBox := GetComponentePA(grpName, PA, True);

    if not Assigned(grpBox) then Exit;

    TGroupBox(grpBox).Visible := True;
    btn := FMX.StdCtrls.TButton(grpBox.FindComponent(FormataNomeComponente(cbtnTag + '_' + IntToStr(IdTag), PA)));

    if Assigned(btn) then
    begin
      //DesligarOutrasTAGGrupos(PA, btn);
      OldStaysPressed := btn.StaysPressed;
      try
        btn.StaysPressed := True;
        btn.IsPressed := True;
      finally
        btn.StaysPressed := OldStaysPressed;
      end;

      AtualizarIsPressedRetangulo(btn);

      if (LDMClient.cdsTags.Locate('ID', IdTag, [])) then
      begin
        if (FListaTAGs.IndexOf(LDMClient.cdsTags.FieldByName('Nome').AsString) = -1) then
          FListaTAGs.AddObject(LDMClient.cdsTags.FieldByName('Nome').AsString, TGroupBox(grpBox).Clone(nil));
      end;
    end;
  end;

  function CriarListaTAG(IdTag: Integer; grpName: string): Boolean;
  //var
    //grpBox,
    //ListBoxTAG: TComponent;
  begin
    //grpBox := GetComponentePA(grpName, PA, True); //GetPnlTAGs(PA);// GetrecTAGs(PA); //

    //if not Assigned(grpBox) then Exit;

    //TGroupBox(grpBox).Visible := True;
    //TGroupBox(grpBox).Align := TAlignLayout.Client;
    //ListBoxTAG := GetRecTAGs(PA).FindComponent('ListBoxTAG_' + IntToStr(LDMClient.cdsTags.FieldByName('ID').AsInteger));

    if not Assigned(ListBoxTAG) then
    begin
      ListBoxTAG := TListBox.Create(GetRecTAGs(PA));
      TListBox(ListBoxTAG).Parent := GetRecTAGs(PA);
      TListBox(ListBoxTAG).Align := TAlignLayout.None;
      TListBox(ListBoxTAG).Align := TAlignLayout.Top;
      TListBox(ListBoxTAG).Height := 50;
      TListBox(ListBoxTAG).Name := 'ListBoxTAG';
      TListBox(ListBoxTAG).ShowScrollBars := True;
      TListBox(ListBoxTAG).StyleLookup := 'ListBox_TAGsStyle1';

      GetRecTAGs(PA).Height := GetRecTAGs(PA).Height + 50;
      GetPnlTAGs(PA).Height := GetPnlTAGs(PA).Height + 50;
      {$IFDEF CompilarPara_MULTIPA}
      GetPNL(PA).Height := GetPNL(PA).Height + 50;
      if GetPNL(PA).Height > FAlturaMinima then FAlturaMinima := Trunc(GetPNL(PA).Height);
      {$ENDIF CompilarPara_MULTIPA}

      if GetpnlTAGs(PA).Height > FAlturaTAGs then FAlturaTAGs := Trunc(GetpnlTAGs(PA).Height);
    end;

    LDMClient.cdsTags.Filtered := False;

    if (LDMClient.cdsTags.Locate('ID', IdTag, [])) then
    begin
      if (FListaTAGs.IndexOf(LDMClient.cdsTags.FieldByName('Nome').AsString) = -1) then
        FListaTAGs.AddObject(LDMClient.cdsTags.FieldByName('Nome').AsString, TObject(LDMClient.cdsTags.FieldByName('CodigoCor').AsInteger));

      if (TListBox(ListBoxTAG).Items.IndexOf(LDMClient.cdsTags.FieldByName('Nome').AsString) = -1) then
        AddListBox_TAGs(TListBox(ListBoxTAG), LDMClient.cdsTags.FieldByName('Nome').AsString, LDMClient.cdsTags.FieldByName('CODIGOCOR').AsInteger);
    end;
  end;
begin
  if not GetPaJaFoiCriada(PA) then
    exit;
  //GetPnlTAGs(PA).DestroyComponents;
  GetRecTAGs(PA).DestroyComponents;
  Finalize(FListBtnsTAGs);
  ListBoxTAG := nil;
  //GetRecTAGs(PA).Height := 4;
  //FTAGs := Ids;

  LDMClient := DMClient(IdUnidade, not CRIAR_SE_NAO_EXISTIR);

  //CriarTAGs(LDMClient.FCurrentPA);
  CriarTAGs(PA);

  if LDMClient.cdsGruposDeTAGs.IsEmpty then
    Exit;

  if not Assigned(FListaTAGs) then
    FListaTAGs := TStringList.Create
  else
    FListaTAGs.Clear;

  DesligarTAGs(PA);
  LDMClient.cdsTags.Filtered := False;

  for iTag := Low(Ids) to High(Ids) do
  begin
    for J := 0 to FMaxTAGsCriadas do
    //for J := 1 to LDMClient.cdsGruposDeTAGs.RecordCount do
    begin
      //ShowMessage(IntToStr(Ids[iTag]));

      if (LDMClient.cdsTags.Locate('ID', Ids[iTag], [])) then
      begin
        if ((IntInArray(LDMClient.cdsTags.FieldByName('IDgrupo').AsInteger, vgParametrosModulo.GruposTAGSSomenteLeitura)) or
           (IntInArray(LDMClient.cdsTags.FieldByName('IDgrupo').AsInteger, vgParametrosModulo.GruposTAGSLayoutLista))) then
        begin
          //CriarListaTAG(Ids[iTag], cGrpTags + '_' + IntToStr(Ids[iTag]));
          var LListBox: TComponent;

          LListBox := GetRecTAGs(PA).FindComponent('ListBoxTAG');

          if not Assigned(LListBox) then
            CriarListaTAG(Ids[iTag], cGrpTags + '_' + IntToStr(Ids[iTag]))
          else
            ListBoxTAG := TListBox(LListBox);

          AddListBox_TAGs(TListBox(ListBoxTAG),
                          LDMClient.cdsTags.FieldByName('Nome').AsString,
                          LDMClient.cdsTags.FieldByName('codigocor').AsInteger);
        end
        else
        if IntInArray(LDMClient.cdsTags.FieldByName('IDgrupo').AsInteger, vgParametrosModulo.GruposTAGSLayoutBotao) then
          SelecionarTAG(Ids[iTag], cGrpTags + '_' + IntToStr(FMaxTAGsCriadas), True);
      end;
    end;
  end;

  if Assigned(ListBoxTAG) then
  begin
    ListBoxTAG.Height := 0;

    for var iCont := 0 to Pred(ListBoxTAG.Items.Count) do
      if ListBoxTAG.Height < 149 then
        ListBoxTAG.Height := ListBoxTAG.Height + 50;
  end;

  GetPnlTAGs(PA).Height := 0;

  for var iCont := 0 to GetRecTAGs(PA).ComponentCount-1 do
    GetPnlTAGs(PA).Height := GetPnlTAGs(PA).Height + TControl(GetRecTAGs(PA).Components[iCont]).Height;

  if vgParametrosModulo.TAGsObrigatorias then  // RAP
    UpdateButtons(PA);                         // RAP
end;

function TFrmBase_PA_MPA.SenhaAtual(PA: Integer): string;
var
  LLblSenha: TLabel;
begin
  Result := '';
  if GetPaJaFoiCriada(PA) then
  begin
    LLblSenha := GetLblSenha(PA);
    if Assigned(LLblSenha) then
      Result := LLblSenha.Text;

    if not EstaPreenchidoCampo(Result) then
      Result := '';
  end;
end;

procedure TFrmBase_PA_MPA.SetModoConexaoAtual(const aIdUnidade: Integer; const Valor: Boolean);
var
  FListaPaUpdating     : TIntegerDynArray;
  LCodPA               : Integer;
begin
  inherited;
  if Valor then
  begin
//LBC VERIFICAR      FListaPaUpdating := GetListCurrentPA;
   {$IFDEF CompilarPara_PA}
      DMConnection(aIdUnidade, not CRIAR_SE_NAO_EXISTIR).SolicitarSituacaoPA(0, aIdUnidade);
      DMConnection(aIdUnidade, not CRIAR_SE_NAO_EXISTIR).EnviarComando(TAspEncode.AspIntToHex(vgParametrosModulo.IdPA, 4) + Chr($36), aIdUnidade);
   {$ELSE}
    with DMClient(0, not CRIAR_SE_NAO_EXISTIR).cdsPAs do
    begin
      First;
      while not eof do
      begin
        LCodPA := FieldByName('ID').AsInteger;
        DMConnection(aIdUnidade, not CRIAR_SE_NAO_EXISTIR).SolicitarSituacaoPA(0, aIdUnidade);
        DMConnection(aIdUnidade, not CRIAR_SE_NAO_EXISTIR).EnviarComando(TAspEncode.AspIntToHex(LCodPA, 4) + Chr($36), aIdUnidade);
        Next;
      end;
    end;
   {$ENDIF CompilarPara_PA}

  {  for LCodPA in FListaPaUpdating do
    begin
      DMConnection(IdUnidade).SolicitarSituacaoPA(0, aIdUnidade);
      DMConnection(IdUnidade).EnviarComando(TAspEncode.AspIntToHex(LCodPA, 4) + Chr($36), aIdUnidade);
    end;   }
  end;
end;


function TFrmBase_PA_MPA.TAGsObrigatorias(const PA: Integer): Boolean;
var
  I, ButtonsDown: Integer;
  LButton: TComponent;
  grpBox: TComponent;
  i2: Integer;
begin
  Result := vgParametrosModulo.TAGsObrigatorias;

  if not Result then
    Exit;

  ButtonsDown := 0;
  for I       := 1 to FMaxTAGsCriadas do
  begin
    grpBox       := GetComponentePA(cGrpTags + '_' + IntToStr(I), PA, True);
    if Assigned(grpBox) then
    begin
      for i2 := 0 to grpBox.ComponentCount -1 do
      begin
        LButton := grpBox.Components[i2];
        if Assigned(LButton) and (LButton is FMX.StdCtrls.TButton) and FMX.StdCtrls.TButton(LButton).IsPressed then
        begin
          Inc(ButtonsDown);
          Break;
        end;
      end;
    end;
  end;

  Result := not(FMaxTAGsCriadas = ButtonsDown);
end;

function TFrmBase_PA_MPA.UpdateAtdStatus(const PA, StatusPA, MotivoPausa, Atendente: Integer; const Senha, NomeCliente : string): Boolean;
var
  EmPausa: Boolean;
  LDMClient: TDMClient;
begin
  Result := DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).ValidarPA(PA, IDUnidade);

  if Result then
  begin
    LDMClient := DMClient(IdUnidade, not CRIAR_SE_NAO_EXISTIR);
    if Atendente = -1 then
      AtualizarAtendente(SemAtendente, PA, Atendente)
    else
      AtualizarAtendente(LDMClient.GetAtdNome(Atendente), PA, Atendente);

    AtualizarSenha(PA, Senha);
    DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).SolicitarTAGs(PA, Senha, IdUnidade);
    DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).SolicitarDadosAdicionais(PA, Senha, IdUnidade);
    //Beep;
    SelecionarTAGs(PA, TAGs);

    if NomeCliente = '' then
      AtualizarNomeCliente(SemNomeCliente, PA)
    else
      AtualizarNomeCliente(NomeCliente, PA);

    if Senha = '---' then
      GetRecTAGs(PA).DestroyComponents;

    EmPausa := MotivoPausa <> -1;
    GetBtnPausar(PA).IsPressed := EmPausa;

    if EmPausa then
      AtualizarMotivoPausa(LDMClient.GetMotivoPausaCor(MotivoPausa), LDMClient.GetMotivoPausaNome(MotivoPausa), PA)
    else
      AtualizarMotivoPausa(LDMClient.GetMotivoPausaCor(-1), '', PA);

    UpdateButtons(PA, Atendente);
    UpdatePAStatus(PA);

    Self.Invalidate;
  end;
end;

procedure TFrmBase_PA_MPA.UpdateButtons(const PA: Integer);
begin
  try
    if InUpdatePA(PA) then
    begin
      BeginChanges(PA);
      Exit;
    end;

    EndChanges(PA);
    if not GetPaJaFoiCriada(PA) then
      Exit;

    UpdateButtons(PA, GetCodAtend(PA));
  except
    TLog.MyLog('Erro ao atualizar botões.', Self);
  end;
end;

procedure TFrmBase_PA_MPA.UpdateButtons(const PA, aCodAtend: Integer; const aValidarBotoesTAG, aAtendenteLogado, aModoAtendimento: Boolean);
var
  LBotaoProximoEstaRechamando: Boolean;
begin
  BeginUpdate;
  try
    try
      AtualizarPropriedade(propEnabled, cMnuNomeCliente, aModoAtendimento, PA, True);
      GetrecTAGs(PA).Enabled := aModoAtendimento;

      LBotaoProximoEstaRechamando := BotaoProximoEstaRechamando(PA);

      GetBtnProximo(PA).Enabled := aAtendenteLogado and (LBotaoProximoEstaRechamando or (aValidarBotoesTAG)); //PossuiSenhaEspera(PA) and
      GetBtnEspecifica(PA).Enabled := aAtendenteLogado and aValidarBotoesTAG;

      if(aAtendenteLogado)then
      begin
        GetBtnLogin(PA).StyleLookup := 'BtVermelho';
        GetBtnLogin(PA).Text := 'Logout';
      end
      else
      begin
        GetBtnLogin(PA).StyleLookup := 'BtAzulEscuro';
        GetBtnLogin(PA).Text := 'Login';
      end;
      GetBtnLogin(PA).Enabled :=  aValidarBotoesTAG; //(not aAtendenteLogado) and

      AtualizarPropriedade(propEnabled, cMnuLogin,(not aAtendenteLogado) and aValidarBotoesTAG, PA, True);

      AtualizarPropriedade(propEnabled, cMnuLogout, aAtendenteLogado and aValidarBotoesTAG, PA, True);
      GetBtnRechamar(PA).Enabled := aModoAtendimento;

      GetBtnEncaminhar(PA).Enabled := aModoAtendimento and aValidarBotoesTAG;

      GetBtnFinalizar(PA).Enabled := aModoAtendimento and aValidarBotoesTAG;
      GetBtnProcessos(PA).Enabled := aAtendenteLogado;
      AtualizarPropriedade(propEnabled, cMnuProcessos, aAtendenteLogado, PA, True);

      GetBtnPausar(PA).Enabled := aAtendenteLogado and aValidarBotoesTAG;
      AtualizarPropriedade(propEnabled, cMnuAlterarSenha      , aAtendenteLogado, PA, True);

      AtualizarPropriedade(propEnabled, cMnuRechamar          , aModoAtendimento, PA, True);
      AtualizarPropriedade(propEnabled, cMnuEncaminhar        , aModoAtendimento and aValidarBotoesTAG, PA, True);
      AtualizarPropriedade(propEnabled, cMnuFinalizar         , aModoAtendimento and aValidarBotoesTAG, PA, True);
      AtualizarPropriedade(propEnabled, cMnuProximo           , aAtendenteLogado and aValidarBotoesTAG, PA, True);
      AtualizarPropriedade(propEnabled, cMnuSeguirAtendimento , aAtendenteLogado and aValidarBotoesTAG, PA, True);
      AtualizarPropriedade(propEnabled, cMnuEspecifica        , aAtendenteLogado and aValidarBotoesTAG, PA, True);
      AtualizarPropriedade(propEnabled, cMnuPausa             , aAtendenteLogado and aValidarBotoesTAG, PA, True);
      AtualizarPropriedade(propEnabled, cmnuSairIcon          , True, PA, True);
      self.invalidate;
    except
      TLog.MyLog('Erro ao habilitar botões.', Self);
      Exit;
    end;
  finally
    EndUpdate;
  end;
end;

procedure TFrmBase_PA_MPA.UpdateButtons(const PA, aCodAtend: Integer);
var
  LValidarBotoesTAG: Boolean;
  LAtendenteLogado : Boolean;
  LModoAtendimento : Boolean;
begin
  LAtendenteLogado := not(((PA = -1) and vgParametrosModulo.ModoTerminalServer) or ((PA <> -1) and (aCodAtend = -1)));

  if vgParametrosModulo.TAGsObrigatorias and EstaEmAtendimento(PA) then
    LValidarBotoesTAG :=  not TAGsObrigatorias(PA)
  else
    LValidarBotoesTAG := True;
  LModoAtendimento := (LAtendenteLogado and EstaEmAtendimento(PA));

  UpdateButtons(PA, aCodAtend, LValidarBotoesTAG, LAtendenteLogado, LModoAtendimento);
end;

procedure TFrmBase_PA_MPA.UpdatePAStatus(const PA: Integer);
var
  LDMClient: TDMCLient;
begin
  LDMClient := DMClient(IdUnidade, not CRIAR_SE_NAO_EXISTIR);

  if (PA = -1) or (not Assigned(LDMClient)) then
    AtualizarNomePA(SemPA, PA)
  else
    AtualizarNomePA(LDMClient.GetPANome(PA), PA);
end;

procedure TFrmBase_PA_MPA.AguardandoRetornoComando(ABool: Boolean);
begin
  inherited AguardandoRetornoComando(ABool);

  {$IFNDEF IS_MOBILE}
  if Assigned(FReferenciaMenu) then
  begin
    {$IFDEF CompilarPara_MULTIPA}
      if ABool then
        FReferenciaMenu.OnPopup := nil
      else
        FReferenciaMenu.OnPopup := OnPopupMenuBar;
    {$ELSE}
      FReferenciaMenu.Enabled := not ABool;
    {$ENDIF CompilarPara_MULTIPA}
  end;
  {$ENDIF IS_MOBILE}
end;

procedure TFrmBase_PA_MPA.AjustarTopBotao(var TopInicio, LeftInicio: Single; const nBotao: TComponent);
const
  cOffset: Integer = 5;
var
  nBotaoAux: TControl;

  procedure DefinePosicaoBotao;
  begin
    nBotaoAux.Position.Y := TopInicio;
    nBotaoAux.Position.X := LeftInicio;
  end;

  procedure PosicionaBotoesLateralmente;
  {$IFDEF IS_MOBILE}
  var
    LOwnerBotao: TControl;
  {$ENDIF}
  begin
    {$IFDEF IS_MOBILE}
    if Assigned(nBotaoAux.Parent) and (nBotaoAux.Parent is TControl) then
    begin
      LOwnerBotao := TControl(nBotaoAux.Parent);
      if ((LOwnerBotao.Height < (nBotaoAux.Position.Y + nBotaoAux.Height)) and
        (LOwnerBotao.Width > (LeftInicio + nBotaoAux.Width))) then
      begin
        LeftInicio := LeftInicio + nBotaoAux.Width;
        TopInicio := 5;
        DefinePosicaoBotao;
      end;
    end;
    {$ENDIF}
  end;
begin
  try
    if not Assigned(nBotao) then
      Exit;

    nBotaoAux := (nBotao as TControl);

    if nBotaoAux.Visible then
    begin
      DefinePosicaoBotao;
      PosicionaBotoesLateralmente;
      TopInicio            := TopInicio + nBotaoAux.Height + cOffset;
    end;
  except
    raise; // Trocar para tratamento padrão de erro da Aspect //DM MRZ
  end;
end;

procedure TFrmBase_PA_MPA.AjustarTopBotoes(const aSomenteSeModificouSizeForm: Boolean);
var
  LUltimaSituacaoForm: String;
begin
  try
    LUltimaSituacaoForm := GetUltimaSituacaoForm;
    try
      if ((not aSomenteSeModificouSizeForm) or (FUltimaSituacaoForm <> LUltimaSituacaoForm)) then
        self.invalidate;
    finally
      FUltimaSituacaoForm := LUltimaSituacaoForm;
    end;
  except
    TLog.MyLog('Erro ao ajustar top botões.', Self);
    exit;
  end;
end;

procedure TFrmBase_PA_MPA.MostraGrupoPA(const ACodGrupoPA:integer);
begin
// RV Codar
end;

procedure TFrmBase_PA_MPA.AlterarSenha(const aPA, aCodAtend: Integer; const aSenhaAtend: String);
var
  Grupo            : Integer;
  Nome, Reg, Senha, LLogin : string;
  FrmAlteracaoSenha: TFrmAlteracaoSenha;
begin
  if (aCodAtend = -1) or (not DMClient(IdUnidade, not CRIAR_SE_NAO_EXISTIR).GetAtdData(aCodAtend, Grupo, Nome, Reg, Senha, LLogin)) then
  begin
    WarningMessage('Atendente não existe ou está inativo.');
    Abort;
  end;

  AtualizarAtendente(Nome, aPA, aCodAtend);

  FrmAlteracaoSenha               := TFrmAlteracaoSenha.Create(Application, IdUnidade);
  FrmAlteracaoSenha.SenhaServidor := Senha;
  FrmAlteracaoSenha.AtualizaDadosAtendente(aCodAtend, Nome);
  FrmAlteracaoSenha.ShowModal(
    procedure(aResult: TModalResult)
    begin
      if (aResult = mrOk) and
        DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).EnviarComando('0000' + Chr($72) + '0001' +
        TAspEncode.AspIntToHex(aCodAtend, 4) + Nome + ';' + Reg + ';' +
        IntToStr(Grupo) + ';' + FrmAlteracaoSenha.SenhaServidor + ';' + LLogin + ';' + '1;1', IdUnidade) then
        InformationMessage('Senha alterada.');
      FrmAlteracaoSenha := nil;
    end);
end;

procedure TFrmBase_PA_MPA.ApplyChanges(const aPA: Integer);
begin
  UpdateButtons(aPA);
  if not InChanges then
  begin
    FUltimaSituacaoForm := '';
    FormResize(Self);
  end;
end;

procedure TFrmBase_PA_MPA.lblNomeClienteClick(Sender: TObject);
var
  LCodPA        : Integer;
  edtNomeCliente: TEdit;
  lblNomeCliente: TLabel;
begin
  inherited;
  LCodPA := GetCodPA(Sender);
  if not EstaEmAtendimento(LCodPA) then
    Exit;

  edtNomeCliente := GetEdtNomeCliente(LCodPA);
  edtNomeClienteSelecionado := edtNomeCliente;
  lblNomeCliente := GetLblNomeCliente(LCodPA);
  if not (Assigned(edtNomeCliente) and Assigned(lblNomeCliente)) then
    Exit;

  edtNomeCliente.Text     := GetNomeCliente(LCodPA);
  edtNomeCliente.Visible  := True;
  lblNomeCliente.Visible := not edtNomeCliente.Visible;
  edtNomeCliente.Position.X := lblNomeCliente.Position.X;
  edtNomeCliente.Position.Y := lblNomeCliente.Position.Y;
  {$IFDEF IS_MOBILE}
  edtNomeCliente.Position.Y := edtNomeCliente.Position.Y - 2;
  {$ENDIF IS_MOBILE}
  {$IFDEF CompilarPara_MULTIPA}
  edtNomeCliente.Width    := 77;//(GetbtnProximo(LCodPA).Position.X - (edtNomeCliente.Position.X + 10));
  {$ELSE}
  edtNomeCliente.Width    := ((edtNomeCliente.Parent as TControl).Width - (edtNomeCliente.Position.X + 10));
  {$ENDIF CompilarPara_MULTIPA}
  edtNomeCliente.BringToFront;
  edtNomeCliente.SetFocus;
end;

procedure TFrmBase_PA_MPA.lblSenhaDblClick(Sender: TObject);
var
  LSituacaoPAAoExibirForm: string;
  LPA, Senha: Integer;
  LDMClient: TDMClient;
begin
  edtNomeClienteSelecionado.OnExit(edtNomeClienteSelecionado);
  LPA := GetCodPA(Sender);
  LDMClient := TDMClient(IDUnidade);
  if not ASsigned(LDMClient) then
    exit;
  LDMClient.FCurrentPA := LPA;
  LDMClient.FCurrentAtd := GetCodAtend(LPA);
  LSituacaoPAAoExibirForm := GetSituacaoAtualPA(LPA);

  if (LDMClient.FCurrentAtd > -1) then
  begin
   InputQuery('Nova senha.',
      ['Digite o número da nova senha:'], [''],
	    procedure (const AResult: TModalResult; const AValues: array of string)
      begin
        if (AResult = mrOk) then
        begin
          if (LSituacaoPAAoExibirForm = GetSituacaoAtualPA(LPA)) then
          begin
            Senha := -1;
            if (length(AValues) = 1)  then
              Senha := StrToIntDef(AValues[0], -1);

            if (Senha = -1) then
              ErrorMessage(Format('A senha "%s" informada não é numérica.', [ArrayToString(AValues)]))
            else
              DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).DecifrarCodigoBarra('/TCK' + IntToStr(Senha) + '\', IdUnidade);
          end
          else
            ErrorMessage(Format('A senha %s específica não foi chamada. '+ #13 +
                                'Somente é permite encaminhar senhas que estão em atendimento.' + #13 +
                                'Situação PA anterior "%s", situação PA atual "%s".',
                                [SenhaAtual(LPA), LSituacaoPAAoExibirForm, GetSituacaoAtualPA(LPA)]));
        end;
      end);
  end;
end;

procedure TFrmBase_PA_MPA.edtNomeClienteKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
var
  edtNomeCliente: TEdit;
begin
  inherited;

  if Key = vkReturn then
  begin
    edtNomeCliente := Sender as TEdit;
    edtNomeCliente.OnExit(edtNomeCliente);
    Key := 0;
  end;

  if Key = vkEscape then
  begin
    edtNomeCliente      := Sender as TEdit;
    edtNomeCliente.Text := GetNomeCliente(GetCodPA(Sender));
    edtNomeCliente.OnExit(edtNomeCliente);
    Key := 0;
  end;
end;

procedure TFrmBase_PA_MPA.edtNomeClienteExit(Sender: TObject);
var
  edtNomeCliente: TEdit;
  LCodPA        : Integer;
begin
  inherited;

  if Assigned(Sender) and (Sender is TEdit) then
  begin
    edtNomeCliente := TEdit(Sender);
    if edtNomeCliente.Visible then
    begin
      LCodPA := GetCodPA(Sender);
      edtNomeCliente.Visible := False;
      GetlblNomeCliente(LCodPA).Visible := not edtNomeCliente.Visible;
      if EstaEmAtendimento(LCodPA) and (edtNomeCliente.Text <> GetNomeCliente(LCodPA)) then
      begin
        DMConnection(IdUnidade, not CRIAR_SE_NAO_EXISTIR).DefinirNomeCliente(LCodPA, StrToInt(SenhaAtual(LCodPA)), edtNomeCliente.Text, IdUnidade);
        AtualizarNomeCliente(edtNomeCliente.Text, LCodPA);
      end;
    end;
  end;
end;

procedure TFrmBase_PA_MPA.mnuAlterarSenhaClick(Sender: TObject);
var
  LPA, LCodAtend: Integer;
begin
  LPA       := GetCodPA(Sender);
  LCodAtend := GetCodAtend(LPA);

  AlterarSenha(LPA, LCodAtend, GetSenhaAtend(LCodAtend));
end;

procedure TFrmBase_PA_MPA.mnuControleRemotoClick(Sender: TObject);
begin
  FrmControleRemoto := TFrmControleRemoto.Create(Self);
  FrmControleRemoto.showmodal(Nil);
end;

procedure TFrmBase_PA_MPA.mnuLoginClick(Sender: TObject);
var
  LPA: Integer;
begin
  LPA := GetCodPA(Sender);
  Login(LPA, GetCodAtend(LPA));
end;

procedure TFrmBase_PA_MPA.mnuLogoutClick(Sender: TObject);
var
  PA: Integer;
begin
  PA := GetCodPA(Sender);
  Logout(PA, GetCodAtend(PA));
end;

procedure TFrmBase_PA_MPA.btnEncaminharClick(Sender: TObject);
begin
  if now - FControleDelaysBotoes[tbEncaminha] < EncodeTime(0, 0, 4, 0) then
    Exit
  else
    FControleDelaysBotoes[tbEncaminha] := now;

  Encaminhar(GetCodPA(Sender));
end;

procedure TFrmBase_PA_MPA.btnEspecificaClick(Sender: TObject);
begin
  if now - FControleDelaysBotoes[tbEspecifica] < EncodeTime(0, 0, 4, 0) then
    Exit
  else
    FControleDelaysBotoes[tbEspecifica] := now;

  Especifica(GetCodPA(Sender));
end;

procedure TFrmBase_PA_MPA.btnFinalizarClick(Sender: TObject);
begin
  if now - FControleDelaysBotoes[tbFinaliza] < EncodeTime(0, 0, 4, 0) then
    Exit
  else
    FControleDelaysBotoes[tbFinaliza] := now;

  Finalizar(GetCodPA(Sender));
end;

procedure TFrmBase_PA_MPA.btnLoginClick(Sender: TObject);
var
  LCodPA: Integer;
begin
  if now - FControleDelaysBotoes[tbLoginLogout] < EncodeTime(0, 0, 4, 0) then
    Exit
  else
    FControleDelaysBotoes[tbLoginLogout] := now;

  LCodPA := GetCodPA(Sender);
  Login(LCodPA, GetCodAtend(LCodPA));
end;

procedure TFrmBase_PA_MPA.btnLogoutClick(Sender: TObject);
var
  LCodPA: Integer;
begin
  if now - FControleDelaysBotoes[tbLoginLogout] < EncodeTime(0, 0, 4, 0) then
    Exit
  else
    FControleDelaysBotoes[tbLoginLogout] := now;

  LCodPA := GetCodPA(Sender);
  Logout(LCodPA, GetCodAtend(LCodPA));
end;

procedure TFrmBase_PA_MPA.btnPausarClick(Sender: TObject);
var
  LCodPA: Integer;
begin
  if now - FControleDelaysBotoes[tbPausa] < EncodeTime(0, 0, 4, 0) then
    Exit
  else
    FControleDelaysBotoes[tbPausa] := now;

  LCodPA := GetCodPA(Sender);
  if not GetEstaEmPausa(LCodPA) then
    IniciarPausa(LCodPA, vgParametrosModulo.MostrarBotaoSeguirAtendimento)
  else
    TerminarPausa(LCodPA);
end;

procedure TFrmBase_PA_MPA.btnProcessosClick(Sender: TObject);
var
  LPA: Integer;
begin
  if now - FControleDelaysBotoes[tbProcessosParalelos] < EncodeTime(0, 0, 4, 0) then
    Exit
  else
    FControleDelaysBotoes[tbProcessosParalelos] := now;

  LPA := GetCodPA(Sender);
  ProcessosParalelos(LPA, GetCodAtend(LPA));
end;

{ TListBtnsTAGs }

procedure TListBtnsTAGs.AddButton(const aBotao: FMX.StdCtrls.TButton);
begin
  SetLength(ListaBotoes, Length(ListaBotoes) + 1);
  ListaBotoes[Length(ListaBotoes) - 1] := aBotao;
end;

constructor TListBtnsTAGs.Create;
begin
  SetLength(ListaBotoes, 0);
  PA := 0;
end;

end.
