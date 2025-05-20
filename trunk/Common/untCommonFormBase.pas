unit untCommonFormBase;

interface
{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  {$IFNDEF IS_MOBILE}
  Windows, Messages, ScktComp,
  {$ENDIF}
  FMX.Grid, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.Dialogs, FMX.StdCtrls, FMX.ExtCtrls, FMX.Types, FMX.Layouts,
   Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors, FMX.Objects, FMX.Edit,

  System.UIConsts, System.Generics.Defaults, System.Generics.Collections,
  System.UITypes, System.Types, System.SysUtils, System.Classes, System.Variants, DB, DBClient, System.Rtti,
  Data.Bind.EngExt, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope, Math, FMX.Platform,
  FMX.VirtualKeyboard,
  MyAspFuncoesUteis,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, Sics_Common_Parametros,
  System.ImageList, FMX.ImgList, FMX.Effects, IniFiles;

type
  TRefFuncGetTextPopup = reference to function(const aSender: TControl): String;
  {$IFNDEF IS_MOBILE}
  TAspPopup = class(TPopup)
  protected
  public
    lblHint: TLabel;
    lblTitle: TLabel;
    FControl: TControl;
    Rect: TRectangle;
    FOnGetTitle, FOnGetHintText: TRefFuncGetTextPopup;

    constructor Create(AOwner: TComponent); override;
    procedure Popup(const AShowModal: Boolean = False); Override;
    procedure Configura(const aForm: TForm; const aControl: TControl; const aTitle, aHintText: string; const aTitleColor, aColorHintText: TAlphaColor; const aTipoIcon: TMsgDlgType); Overload; Virtual;
    procedure Configura; Overload; Virtual;
  end;
  {$ENDIF IS_MOBILE}

  TFrmBase = class(TForm, IFreeNotificationBehavior)
    layBase: TLayout;
    recCaption: TRectangle;
    lblCaption: TLabel;
    lytFundo: TLayout;
    bndList: TBindingsList;
    btnCloseForm: TButton;
    rectFundo: TRectangle;
    recAguardando: TRectangle;
    imgClose: TImage;
    GlowEffect1: TGlowEffect;

    procedure FormVirtualKeyboardHidden(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardShown(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure btnCloseFormClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    class var FInstancia: TfrmBase;

    /// <summary>
    ///   Mostra um TRectangle por cima de tudo enquanto a aplicação aguarda
    ///  um retorno do servidor. Método chamado pela procedure
    ///  AguardandoRetornoComando(True)
    /// </summary>
    procedure ExibirRecAguardando;
    /// <summary>
    ///   Oculta o TRectangle que está por cima de tudo após a aplicação receber
    ///  o retorno do servidor. Método chamado pela procedure
    ///  AguardandoRetornoComando(False)
    /// </summary>
    procedure OcultarRecAguardando;
  protected
    FUltimaSituacaoFormGrid: String;
    FEscala: Extended;
    FCarregouParametroDB, FCarregouParametroINI: Boolean;
    FIDUnidade: Integer;

    {$IFDEF IS_MOBILE}
    FPodeAtualizarUltimaOrientacao, FKeyboradVisivel: Boolean;
    FUltimaScreenOrientation: TScreenOrientation;
    FPrimeiraMudancaDeOrientacaoMobile: BOolean;
    FAlturaTeclado: Integer;
    FModificouPosicaoLayout: BOolean;
    {$ENDIF IS_MOBILE}

    {$IFDEF IS_MOBILE}
    /// <summary>
    ///   Retorna a altura do teclado virtual (Android)
    /// </summary>
    function GetAlturaTeclado: Integer; Virtual;
    procedure SetAlturaTeclado(const Value: Integer); Virtual;
    /// <summary>
    ///   Teclado virtual android está visível.
    /// </summary>
    function GetKeyboradVisivel: Boolean; Virtual;
    procedure SetKeyboradVisivel(const Value: Boolean); Virtual;

    /// <summary>
    ///   Não permite que a função seja recursiva
    ///  Assim somente atualiza orientação da tela 1 vez ao chamar "AtualizaUltimaOrientacao"
    /// </summary>
    function GetPodeAtualizarUltimaOrientacao: BOolean; Virtual;
    procedure SetPodeAtualizarUltimaOrientacao(const Value: BOolean); Virtual;

    /// <summary>
    ///   Verificação para capturar a orientação da tela somente 1 vez após
    ///   Exibir o form.
    /// </summary>
    function GetPrimeiraMudancaDeOrientacaoMobile: BOolean; Virtual;
    procedure SetPrimeiraMudancaDeOrientacaoMobile(const Value: BOolean); Virtual;

    /// <summary>
    ///   Retorna a orientação da tela anterior
    /// </summary>
    function GetUltimaScreenOrientation: TScreenOrientation; Virtual;
    procedure SetUltimaScreenOrientation(const Value: TScreenOrientation); Virtual;

    /// <summary>
    ///   Recalcula alinhamento layout para caber o teclado virtual sem ocultar controles.
    /// </summary>
    procedure CalculaAlturaLayoutBase; Virtual;
    {$ENDIF IS_MOBILE}

    {$REGION 'Interface "IBaseTela"'}
    /// <summary>
    ///   Retorna a configuração visual (Altura, Largura, orientação tela, keyboard visível)
    /// </summary>
    function GetUltimaSituacaoForm: String; Virtual;

    /// <summary>
    ///   Define icone de fechar no botão
    /// </summary>
    procedure ConfiguraCloseBtn; Virtual;

    {$REGION 'Escala do Zoom'}
    procedure SetEscala(const Value: Extended); Virtual;
    function GetEscala: Extended; Virtual;
    {$ENDREGION}
    {$ENDREGION}

    /// <summary>
    ///   Instância da tela por unidade "IInterfaceUnidade"
    /// </summary>
    function GetIDUnidade: Integer; Virtual;
    procedure SetIDUnidade(const Value: Integer); Virtual;

    {$REGION 'Situação da conexão com servidor "IFormComponentesDesabilitados"'}
    procedure SetModoConexaoAtual(const aIdUnidade: Integer;const Value: Boolean); Virtual;
    procedure HabilitarComponentes(const aIdUnidade: Integer); Virtual;
    procedure DesabilitarComponentes(const aIdUnidade: Integer); Virtual;
    procedure ForcarModoDesconectado; Virtual;
    {$ENDREGION}

    function GetDataSetOfLinkGrid(const aLinkGridToDataSource: TLinkGridToDataSource): TDataSet; Virtual;
    procedure DoClose(var CloseAction: TCloseAction); Override;
    procedure DoShow; override;
    procedure DoHide; override;

  public
    {$IFDEF IS_MOBILE}
    {$REGION 'Corrigi alinhamento e altura componentes conforme orientação tela "IIntentMobilePosition"'}
    property KeyboradVisivel: Boolean read GetKeyboradVisivel write SetKeyboradVisivel;
    property PodeAtualizarUltimaOrientacao: BOolean read GetPodeAtualizarUltimaOrientacao write SetPodeAtualizarUltimaOrientacao;
    property UltimaScreenOrientation: TScreenOrientation read GetUltimaScreenOrientation write SetUltimaScreenOrientation;
    property PrimeiraMudancaDeOrientacaoMobile: BOolean read GetPrimeiraMudancaDeOrientacaoMobile write SetPrimeiraMudancaDeOrientacaoMobile;
    property AlturaTeclado: Integer read GetAlturaTeclado write SetAlturaTeclado;
    {$ENDREGION}
    {$ENDIF IS_MOBILE}

    /// <summary>
    ///   Cria colunas definindo nome e largura
    /// </summary>
    procedure AtualizarColunasGrid; Virtual;

    /// <summary>
    ///   Retorna a situação dos dados tela
    /// </summary>
    function GetContextoCorrente: string; Virtual;

    /// <summary>
    ///   Localiza na lista de instância tela atual com o id unidade identifico
    ///  Caso não encontra cria nova tela.
    /// </summary>
    class function GetInstancia(const aIDUnidade: integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TFMXObject {TFrmBase};  Virtual;

    {$REGION 'Notificação ao destruir um objeto parent'}
    /// <summary>
    ///   Adicionar controle que será notificado ao destruir o form "IFreeNotificationBehavior"
    /// </summary>
    procedure AddFreeNotify(const AObject: IFreeNotification); virtual;
    /// <summary>
    ///   Remove controle que será notificado ao destruir o form "IFreeNotificationBehavior"
    /// </summary>
    procedure RemoveFreeNotify(const AObject: IFreeNotification); virtual;
    procedure FreeNotification(AObject: TObject); Override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    {$ENDREGION}

    {$REGION 'Situação da conexão com servidor "IFormComponentesDesabilitados"'}
    class procedure DefinirCor(aOwner: TComponent; const ACor, aCOrOld: TAlphaColor; const aPintarRetangulo: Boolean); overload; Virtual;
    class procedure DefinirCor(aOwner: TComponent; aComponenteDesabilitar: TComponent; const ACor, aCOrOld: TAlphaColor; const aPintarRetangulo: Boolean); overload; Virtual;
    class procedure DefinirCor(aOwner: TComponent; const aIdUnidade: Integer; const ACor, aCorOld: TAlphaColor; const aPintarRetangulo: Boolean); overload; Virtual;
    /// <summary>
    ///   Pinta retangulos e TaspLayout para vermelho se desconectado
    /// </summary>
    procedure DefinirCor(const aIdUnidade: Integer; const ACor, aCorOld: TAlphaColor; const aPintarRetangulo: Boolean); overload; Virtual;

    function ValidacaoAtivaModoConectado: Boolean; Virtual;
    property ModoConexaoAtual[const aIdUnidade: Integer]: Boolean write SetModoConexaoAtual;
    procedure ModoConectado(const aIdUnidade: Integer); virtual;
    procedure ModoDesconectado(const aIdUnidade: Integer); virtual;
    {$ENDREGION}

    /// <summary>
    ///   Instância da tela por unidade "IInterfaceUnidade"
    /// </summary>
    property IDUnidade: Integer read GetIDUnidade write SetIDUnidade;

    {$REGION 'Hint de controles'}
    {$IFDEF IS_MOBILE}procedure{$ELSE}function{$ENDIF}
    AddHint(const aControl: TControl; const aTitle: String; const aHintText: string = '';
      const aTitleColor: TAlphaColor = claBlack; const aColorHintText: TAlphaColor = claBlack;
      const aTipoIcon: TMsgDlgType = TMsgDlgType.mtInformation)
      {$IFNDEF IS_MOBILE}: TAspPopup{$ENDIF !IS_MOBILE}; Overload; Virtual;

    class {$IFDEF IS_MOBILE}procedure{$ELSE}function{$ENDIF}
    AddHint(const aForm: TForm; const aControl: TControl;
      const aTitle: String; const aHintText: string = '';
      const aOnGetTitle: TRefFuncGetTextPopup = nil; const aOnGetHintText: TRefFuncGetTextPopup = nil;
      const aTitleColor: TAlphaColor = claBlack; const aColorHintText: TAlphaColor = claBlack;
      const aTipoIcon: TMsgDlgType = TMsgDlgType.mtInformation)
      {$IFNDEF IS_MOBILE}: TAspPopup{$ENDIF !IS_MOBILE}; Overload; Virtual;

    class {$IFDEF IS_MOBILE}procedure{$ELSE}function{$ENDIF}
    AddHint(const aForm: TForm; const aControl: TControl;
      const aTitle: String; const aHintText: TRefFuncGetTextPopup;
      const aTitleColor: TAlphaColor = claBlack; const aColorHintText: TAlphaColor = claBlack;
      const aTipoIcon: TMsgDlgType = TMsgDlgType.mtInformation)
      {$IFNDEF IS_MOBILE}: TAspPopup{$ENDIF !IS_MOBILE}; Overload; Virtual;
    class {$IFDEF IS_MOBILE}procedure{$ELSE}function{$ENDIF}
    AddHint(const aForm: TForm; const aControl: TControl;
      const aTitle: TRefFuncGetTextPopup; const aHintText: TRefFuncGetTextPopup;
      const aTitleColor: TAlphaColor = claBlack; const aColorHintText: TAlphaColor = claBlack;
      const aTipoIcon: TMsgDlgType = TMsgDlgType.mtInformation)
      {$IFNDEF IS_MOBILE}: TAspPopup{$ENDIF !IS_MOBILE}; Overload; Virtual;
    {$IFNDEF IS_MOBILE}
    /// <summary>
    ///   Exibe popup do hint
    /// </summary>
    class procedure OnControlHintMouseEnter(Sender: TObject);
    /// <summary>
    ///   Oculta popup do hint
    /// </summary>
    class procedure OnControlHintMouseLeave(Sender: TObject);
    {$ENDIF !IS_MOBILE}
    {$ENDREGION}

    {$REGION 'Ao carregar parâmetros do servidor e arquivo INI "IFormComponentesDesabilitados"'}
    procedure CarregarParametrosDB; Overload; Virtual;
    procedure CarregarParametrosDB(const aIDUnidade: Integer); Overload; Virtual;
    procedure CarregarParametrosINI; Virtual;
    {$ENDREGION}

    /// <summary>
    ///   Cria form configurando
    /// </summary>
    constructor Create(AOwner: TComponent); overload; override;
    constructor Create(AOwner: TComponent; const aIdUnidade: Integer); reintroduce; overload; virtual;

    procedure AfterConstruction; override;

    destructor Destroy; Override;

    /// <summary>
    ///   Objetivo: proteger a tela da interação do usuário enquanto aguarda
    ///  um retorno de comando do servidor.
    /// </summary>
    procedure AguardandoRetornoComando(ABool: Boolean); Virtual;
  published
    property Escala: Extended read GetEscala write SetEscala;
  end;

implementation

{$R *.fmx}

uses
  untCommonDMConnection,
  untLog, untCommonFormStyleBook, untCommonDMUnidades
  {$IFNDEF CompilarPara_TOTEMTOUCH}
  , untCommonControleInstanciasTelas, FMX.Platform.Win
  {$ENDIF};


const
  NOME_POPUPHINT = 'PopupHint';

procedure TFrmBase.AddFreeNotify(const AObject: IFreeNotification);
begin
  inherited AddFreeNotify(AObject);
end;

procedure TFrmBase.RemoveFreeNotify(const AObject: IFreeNotification);
begin
  inherited RemoveFreeNotify(AObject);
end;


procedure TFrmBase.AfterConstruction;
begin
  inherited;

  if (IdUnidade = ID_UNIDADE_VAZIA) then
    IdUnidade := vgParametrosModulo.UnidadePadrao;
end;

procedure TFrmBase.ExibirRecAguardando;
begin
  recAguardando.Align := TAlignLayout.Contents;
  //recAguardando.Margins.Top := recCaption.Position.Y + recCaption.Height;
  recAguardando.Visible := True;
  recAguardando.BringToFront;
  layBase.Enabled := False;
end;

procedure TFrmBase.OcultarRecAguardando;
begin
  recAguardando.Visible := False;
  layBase.Enabled := True;
end;

procedure TFrmBase.AguardandoRetornoComando(ABool: Boolean);
begin
  if ABool then
    ExibirRecAguardando
  else
    OcultarRecAguardando;
end;

procedure TFrmBase.AtualizarColunasGrid;
begin
  if Visible then
    AspUpdateColunasGrid(Self, bndList);
end;

procedure TFrmBase.btnCloseFormClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmBase.CarregarParametrosDB;
begin
  FCarregouParametroDB := True;
end;

procedure TFrmBase.CarregarParametrosDB(const aIDUnidade: Integer);
begin
  FCarregouParametroDB := True;
end;

procedure TFrmBase.CarregarParametrosINI;
begin
  FCarregouParametroINI := True;
end;

procedure TFrmBase.ConfiguraCloseBtn;
begin
  if Assigned(btnCloseForm) then
  begin
    {$IFDEF IS_MOBILE}
    //BAH Verificar outro modo de colocar icone no botão
//    btnCloseForm.Visible := Assigned(btnCloseForm.Images) and vgParametrosModulo.PodeFecharPrograma;
//    if Assigned(DMConnection) and Assigned(DMConnection.FormClient) then
//      DMConnection.FormClient.SetResourceIcon(btnCloseForm, icClose);
    {$ELSE}
    btnCloseForm.Visible := False;
    {$ENDIF IS_MOBILE}
  end;
end;

constructor TFrmBase.Create(AOwner: TComponent; const aIdUnidade: Integer);
begin
  Create(AOwner);
  IDUnidade := aIDUnidade;
end;

constructor TFrmBase.Create(AOwner: TComponent);
var
  Mobile: Boolean;
begin
  {$IFDEF IS_MOBILE}
  FAlturaTeclado := 0;
  FPrimeiraMudancaDeOrientacaoMobile := False;
  FKeyboradVisivel := False;
  FPodeAtualizarUltimaOrientacao := True;
  FUltimaScreenOrientation := TScreenOrientation.Portrait;
  FModificouPosicaoLayout := False;
  {$ENDIF IS_MOBILE}

  FUltimaSituacaoFormGrid := '';
  FCarregouParametroDB := False;
  FCarregouParametroINI := False;
  FEscala := 0;
  FidUnidade := ID_UNIDADE_VAZIA;

  inherited;
  FInstancia := Self;

  Mobile := MobileDevice;

  recCaption.Visible := Mobile;
  if not Mobile then
    Self.Height := Self.Height - Round(recCaption.Height);
end;


procedure TFrmBase.DefinirCor(const aIdUnidade: Integer; const ACor, aCorOld: TAlphaColor; const aPintarRetangulo: Boolean);
begin
  TFrmBase.DefinirCor(Self, ACor, aCorOld, aPintarRetangulo);
end;

procedure TFrmBase.ForcarModoDesconectado;
begin
  dmUnidades.ExecutaParaTodasUnidades(ModoDesconectado);
end;

procedure TFrmBase.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not Assigned(Parent) then
    MyAspFuncoesUteis.SavePosition(Self);

  inherited;
end;

procedure TFrmBase.FormCreate(Sender: TObject);
begin
  if not Assigned(Parent) then
     LoadPosition(Self);

  Self.StyleBook := frmStyleBook.GetStyleBook;

  recAguardando.Visible := False;
end;

procedure TFrmBase.FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  {$IFNDEF IS_MOBILE}
  if (Key = vkHardwareBack) then
  begin
    Key := 0;
    if Assigned(GetApplication.MainForm) and (@Self = @GetApplication.MainForm) then
      FinalizeApplication
    else
      Self.Close;
  end;
  {$ENDIF IS_MOBILE}
  inherited;
end;

procedure TFrmBase.FormResize(Sender: TObject);
var
  LUltimaSituacaoForm: String;
begin
  {$IFDEF IS_MOBILE}
  if (FModificouPosicaoLayout and (layBase.Align = TAlignLayout.Top)) then
    CalculaAlturaLayoutBase;
  {$ENDIF IS_MOBILE}

  LUltimaSituacaoForm := GetUltimaSituacaoForm;
  if (FUltimaSituacaoFormGrid <> LUltimaSituacaoForm) then
  begin
    FUltimaSituacaoFormGrid := LUltimaSituacaoForm;
  end;
end;

procedure TFrmBase.FormShow(Sender: TObject);
begin
  lblCaption.Text := Self.Caption;
  ConfiguraCloseBtn;
  inherited;
end;

procedure TFrmBase.FormVirtualKeyboardHidden(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
begin
  {$IFDEF IS_MOBILE}
  KeyboradVisivel := False;
  {$ENDIF IS_MOBILE}
  inherited;
end;

procedure TFrmBase.FormVirtualKeyboardShown(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
begin
  {$IFDEF IS_MOBILE}
  FAlturaTeclado := Bounds.Height;
  KeyboradVisivel := True;
  {$ENDIF IS_MOBILE}
  inherited;
end;

procedure TFrmBase.FreeNotification(AObject: TObject);
begin
  inherited;

end;

function TFrmBase.GetContextoCorrente: string;
begin
  Result := '';
end;

function TFrmBase.GetDataSetOfLinkGrid(const aLinkGridToDataSource: TLinkGridToDataSource): TDataSet;
begin
  Result := nil;
end;

function TFrmBase.GetEscala: Extended;
begin
  Result := FEscala;
end;

function TFrmBase.GetIDUnidade: Integer;
begin
  Result := FIDUnidade;
end;

class function TFrmBase.GetInstancia(const aIDUnidade: integer; const aAllowNewInstance: Boolean; const aOwner: TComponent): TFMXObject; //TFrmBase;
var
  LOwner: TComponent;
begin
  result := nil;

  {$IFNDEF CompilarPara_TOTEMTOUCH}
  if TControleInstanciasTelas.Existe(Self, result) then
    exit;

  if aAllowNewInstance then
  begin
    if Assigned(aOwner) then
      LOwner := aOwner
    else
      LOwner := GetApplication;
    Result := Self.Create(LOwner, aIDUnidade);
    TControleInstanciasTelas.Adicionar(Self, Result);
  end;
  {$ENDIF}
end;


function TFrmBase.GetUltimaSituacaoForm: String;
begin
  Result := Format('PDB%dPINI%dV%dW%dH%dP%d', [Integer(FCarregouParametroDB),
    Integer(FCarregouParametroINI),
    Integer(Self.Visible), Self.Width, self.Height, Integer(Position)]);
  {$IFDEF IS_MOBILE}
  Result := Result + Format('K%dO%D', [Integer(KeyboradVisivel), Integer(FUltimaScreenOrientation)]);
  {$ENDIF IS_MOBILE}
end;

procedure TFrmBase.HabilitarComponentes(const aIdUnidade: Integer);
var
  i: Integer;
  LComponent: TControl;
begin
  if Self.ComponentCount > 0 then
  begin
    for i := 0 to Self.ComponentCount - 1 do
    begin
      if Self.Components[i] is TControl then
      begin
        LComponent := TControl(Self.Components[i]);
        EnableDisableAllControls(LComponent, true);
      end;
    end;

    Self.Invalidate;
  end;
end;

class procedure TFrmBase.DefinirCor (aOwner: TComponent; const aIdUnidade: Integer; const ACor, aCorOld: TAlphaColor; const aPintarRetangulo: Boolean);
var
  I: Integer;
  LComponent: TComponent;
begin
  if not Assigned(aOwner) then
  begin
    Assert(False, 'Controle não criado.');
    Exit;
  end;

  for I := 0 to Pred(aOwner.ComponentCount) do
  begin
    LComponent := aOwner.Components[I];
    if Assigned(LComponent) then
      TFrmBase.DefinirCor(aOwner, LComponent, ACor, aCOrOld, aPintarRetangulo);
  end;

  if (aOwner is Tform) then
    Tform(aOwner).Invalidate;
end;


class procedure TFrmBase.DefinirCor (aOwner: TComponent; const ACor, aCOrOld: TAlphaColor; const aPintarRetangulo: Boolean);
var
  I: Integer;
  LComponent: TControl;
begin
  if (Assigned(aOwner) and (csDestroying in aOwner.ComponentState)) then
    Exit;

  for I := 0 to aOwner.ComponentCount - 1 do
  begin
    if aOwner.Components[i] is TControl then
    begin
      LComponent := TControl(aOwner.Components[i]);
      if Assigned(LComponent) then
        TFrmBase.DefinirCor(aOwner, LComponent, ACor, aCOrOld, aPintarRetangulo);
    end;
  end;

  if Assigned(aOwner) and (aOwner is Tform) then
    Tform(aOwner).Invalidate;
end;

class procedure TFrmBase.DefinirCor(aOwner, aComponenteDesabilitar: TComponent; const ACor, aCOrOld: TAlphaColor; const aPintarRetangulo: Boolean);

  function PodePintar(const aCorAtual: TAlphaColor): BOolean;
  begin
    Result := (aCorAtual = 0) or (aCOrOld = aCorAtual) or (aCorAtual = TAlphaColor($FFE0E0E0));
  end;
begin
  if Assigned(aOwner) and (csDestroying in aOwner.ComponentState) then
    Exit;

  if (aComponenteDesabilitar is TRectangle) then
  begin
    if PodePintar(TRectangle(aComponenteDesabilitar).Fill.Color) then
      TRectangle(aComponenteDesabilitar).Fill.Color := ACor
  end;

  if Assigned(aOwner) and (aOwner is Tform) then
    Tform(aOwner).Invalidate;
end;

procedure TFrmBase.DesabilitarComponentes(const aIdUnidade: Integer);
var
  i : integer;
  LComponent: TControl;
begin
  if Self.ComponentCount > 0 then
  begin
    for I := 0 to Self.ComponentCount - 1 do
    begin
      if Self.Components[i] is TControl then
      begin
        LComponent := TControl(Self.Components[i]);
        EnableDisableAllControls(LComponent, false);
      end;
    end;

    Self.Invalidate;
  end;
end;

destructor TFrmBase.Destroy;
begin
  inherited;
end;

procedure TFrmBase.DoClose(var CloseAction: TCloseAction);
begin
  inherited;

  {$IFDEF AplicacaoFiremokeySemVCL}

  if (Self = GetApplication.MainForm ) then
  begin
    CloseAction := TCloseAction.caFree;
    FinalizeApplication;
  end;
  {$ENDIF AplicacaoFiremokeySemVCL}

end;

procedure TFrmBase.DoHide;
begin
  inherited;
end;

procedure TFrmBase.DoShow;
begin
  {$IFDEF IS_MOBILE}
  FPrimeiraMudancaDeOrientacaoMobile := True;
  {$ENDIF IS_MOBILE}

  inherited;

  AtualizarColunasGrid;
end;

procedure TFrmBase.ModoConectado(const aIdUnidade: Integer);
begin
  ModoConexaoAtual[aIdUnidade] := true;
end;

procedure TFrmBase.ModoDesconectado(const aIdUnidade: Integer);
begin
  ModoConexaoAtual[aIdUnidade] := false;
end;

procedure TFrmBase.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
end;


procedure TFrmBase.SetEscala(const Value: Extended);
begin
  FEscala         := Value;
  layBase.Scale.X := FEscala;
  layBase.Scale.Y := FEscala;
end;

procedure TFrmBase.SetIDUnidade(const Value: Integer);
begin
  if (IDUnidade <> Value) then
  begin
    FCarregouParametroDB := False;
    ModoConexaoAtual[Value] := dmUnidades.Conectada[Value];
    FIDUnidade := Value;
  end;
end;

procedure TFrmBase.SetModoConexaoAtual(const aIdUnidade: Integer; const Value: Boolean);
begin
  if (aIdUnidade < 0) then
    Exit;

  if (csDestroying in ComponentState) or (not ValidacaoAtivaModoConectado) then
    Exit;

  {$IFNDEF CompilarPara_TOTEMTOUCH}

  {$IFNDEF CompilarPara_TGS}
  if (aIdUnidade = IdUnidade) then
  begin
  {$ENDIF}
    if Value or (not dmUnidades.FoiConfiguradoConexao) then
    begin
      DefinirCor(aIdUnidade, CorConectado, CorDesconectado, True);
      HabilitarComponentes(aIdUnidade);
    end
    else
    begin
      DesabilitarComponentes(aIdUnidade);
      DefinirCor(aIdUnidade, CorDesconectado, CorConectado, True);
    end;
  {$IFNDEF CompilarPara_TGS}
  end;
  {$ENDIF}

  {$ENDIF}
end;

function TFrmBase.ValidacaoAtivaModoConectado: Boolean;
begin
  Result := true;
end;

{$IFDEF IS_MOBILE}
function TFrmBase.GetPodeAtualizarUltimaOrientacao: BOolean;
begin
  Result := FPodeAtualizarUltimaOrientacao;
end;

function TFrmBase.GetPrimeiraMudancaDeOrientacaoMobile: BOolean;
begin
  Result := FPrimeiraMudancaDeOrientacaoMobile;
end;

function TFrmBase.GetAlturaTeclado: Integer;
begin
  Result := FAlturaTeclado;
end;

function TFrmBase.GetKeyboradVisivel: Boolean;
begin
  Result := FKeyboradVisivel;
end;

function TFrmBase.GetUltimaScreenOrientation: TScreenOrientation;
begin
  Result := FUltimaScreenOrientation;
end;

procedure TFrmBase.SetAlturaTeclado(const Value: Integer);
begin
  FAlturaTeclado := Value;
end;

procedure TFrmBase.SetPodeAtualizarUltimaOrientacao(const Value: BOolean);
begin
  FPodeAtualizarUltimaOrientacao := Value;
end;

procedure TFrmBase.SetPrimeiraMudancaDeOrientacaoMobile(const Value: BOolean);
begin
  FPrimeiraMudancaDeOrientacaoMobile := Value;
end;

procedure TFrmBase.SetUltimaScreenOrientation(const Value: TScreenOrientation);
begin
  FUltimaScreenOrientation := Value;
end;

procedure TFrmBase.CalculaAlturaLayoutBase;
var
  AlturaClient: Single;

  function GetAlturaParents(const aComponent: TComponent; const aCurrentComponent: TObject): Single;
  var
    LComponent: TComponent;
    i: Integer;
  begin
    Result := 0;
    if not (Assigned(aComponent)) then
      Exit;

    for i := 0 to aComponent.ComponentCount -1 do
    begin
      LComponent := aComponent.Components[i];
      if Assigned(LComponent) and (LComponent <> aCurrentComponent) and (LComponent is TControl) and
        TControl(LComponent).Visible and (LComponent.name <> '') and (TControl(LComponent).Parent = aComponent) then
        Result := Result + TControl(LComponent).Height;
    end;
  end;
begin
  AlturaClient := layBase.Height;
  if Assigned(layBase.Parent) then
  begin
    if (layBase.Parent is TCommonCustomForm) then
      AlturaClient := (TCommonCustomForm(layBase.Parent).Height -
      GetAlturaParents(TCommonCustomForm(layBase.Parent), layBase)) +
      layBase.margins.Bottom + layBase.margins.top
    else
    if (layBase.Parent is TFrame) then
      AlturaClient := (TFrame(layBase.Parent).Height -
      GetAlturaParents(TFrame(layBase.Parent), layBase)) +
      layBase.margins.Bottom + layBase.margins.top
    else
    if (layBase.Parent is TControl) then
      AlturaClient := TControl(layBase.Parent).Height + layBase.margins.Bottom + layBase.margins.top;
  end;

  layBase.Height := (AlturaClient - FAlturaTeclado);
end;

procedure TFrmBase.SetKeyboradVisivel(const Value: Boolean);
begin
  if Value then
  begin
    if FModificouPosicaoLayout then
      CalculaAlturaLayoutBase
    else
    if (((layBase.Align = TAlignLayout.Client) or (layBase.Align = TAlignLayout.Contents))
       and (FAlturaTeclado > 0)) then
    begin
      FModificouPosicaoLayout := true;
      layBase.Align  := TAlignLayout.Top;
      CalculaAlturaLayoutBase;
    end;
  end
  else
  begin
    if ((layBase.Align = TAlignLayout.Top) and FModificouPosicaoLayout) then
      layBase.Align := TAlignLayout.Client;
  end;

  if (FKeyboradVisivel <> Value) then
  begin
    FKeyboradVisivel := Value;
  end;
  Self.FormResize(Self);
end;
{$ENDIF IS_MOBILE}

class
  {$IFDEF IS_MOBILE}procedure{$ELSE}function{$ENDIF}
  TFrmBase.AddHint(const aForm: TForm; const aControl: TControl; const aTitle, aHintText: string;
  const aOnGetTitle, aOnGetHintText: TRefFuncGetTextPopup;
  const aTitleColor, aColorHintText: TAlphaColor; const aTipoIcon: TMsgDlgType)
  {$IFDEF IS_MOBILE};{$ELSE}: TAspPopup;{$ENDIF}

begin
  {$IFDEF IS_MOBILE}
    aControl.hint := '';
  if (aTitle <> '') then
    aControl.hint := aTitle;

  if (aHintText <> '') then
  begin
    if (aControl.hint <> '') then
      aControl.hint := aControl.hint + ' - ';

    aControl.hint := aControl.hint + aHintText;
  end;

  acontrol.ShowHint := (aControl.hint <> '');
  {$ELSE}
  Result := nil;
  if ((aTitle = '') and (aHintText = '')) then
    Exit;
  if not (Assigned(aControl) and Assigned(aForm)) then
  begin
    Assert(False, 'Controles não estão criados.');
    Exit;
  end;
  Result := TAspPopup.Create(aControl);
  Result.Parent := aForm;
  Result.Name := NOME_POPUPHINT;
  Result.PlacementTarget := aControl;
  Result.FOnGetHintText := aOnGetHintText;
  Result.FOnGetTitle := aOnGetTitle;
  Result.Configura(aForm, aControl, aTitle, aHintText, aTitleColor, aColorHintText, aTipoIcon);

  aControl.OnMouseEnter := OnControlHintMouseEnter;
  aControl.OnMouseLeave := OnControlHintMouseLeave;
  {$ENDIF IS_MOBILE}
end;

{$IFNDEF IS_MOBILE}
class procedure TFrmBase.OnControlHintMouseEnter(Sender: TObject);
var
  PopupHint: TAspPopup;
begin
  PopupHint := nil;
  if Assigned(Sender) and (Sender is TComponent) then
    PopupHint := TAspPopup((Sender as Tcomponent).FindComponent(NOME_POPUPHINT));

  if Assigned(PopupHint) then
    PopupHint.IsOpen := True;
end;

class procedure TFrmBase.OnControlHintMouseLeave(Sender: TObject);
var
  PopupHint: TAspPopup;
begin
  PopupHint := nil;
  if Assigned(Sender) and (Sender is TComponent) then
    PopupHint := TAspPopup((Sender as Tcomponent).FindComponent(NOME_POPUPHINT));

  if Assigned(PopupHint) then
    PopupHint.IsOpen := False;
end;

{ TAspPopup }

procedure TAspPopup.Configura(const aForm: TForm; const aControl: TControl; const aTitle, aHintText: string; const aTitleColor, aColorHintText: TAlphaColor;
  const aTipoIcon: TMsgDlgType);
begin
  Placement := TPlacement.Top;
  FControl := aControl;
  Position.X := 0;
  Position.Y := 0;

  if not Assigned(Rect) then
    Rect := TRectangle.Create(Self);
  Rect.Parent := Self;

  if (EhCorClara(aTitleColor)) then
    Rect.Fill.Color := claBlack
  else
    Rect.Fill.Color := claWhite;
  Rect.Align := TAlignLayout.Client;
  Width := 8;
  Height := 10;
  configura;

  if (aTitle <> '') or Assigned(FOnGetTitle) then
  begin
    if not Assigned(lblTitle) then
      lblTitle := TLabel.Create(Self);
    lblTitle.Align := TAlignLayout.Center;
    lblTitle.Parent := Rect;
    lblTitle.StyledSettings := [TStyledSetting.Family, TStyledSetting.Size];
    lblTitle.Height := 17;
    lblTitle.Size.PlatformDefault := False;
    lblTitle.Position.X := 0;
    lblTitle.TextSettings.FontColor := aTitleColor;
    lblTitle.TextSettings.Font.Style := [TFontStyle.fsBold, TFontStyle.fsItalic];
    lblTitle.Text := aTitle;
    lblTitle.Visible := True;
    lblTitle.Height := 30;
	  lblTitle.enabled := False;
	  lblTitle.AutoSize := True;
  end
  else
  if Assigned(lblTitle) then
    FreeAndNil(lblTitle);

  if (aHintText <> '') or Assigned(FOnGetHintText) then
  begin
    if not Assigned(lblHint) then
      lblHint := TLabel.Create(Self);
    lblHint.Align := TAlignLayout.Center;
    lblHint.Parent := Rect;
    lblHint.StyledSettings := [TStyledSetting.Family, TStyledSetting.Size];
    lblHint.Position.X := 6;
    lblHint.TextSettings.FontColor := aTitleColor;
    lblHint.TextSettings.Font.Style := [TFontStyle.fsItalic];
    lblHint.Text := aHintText;
    lblHint.Visible := True;
    lblHint.WordWrap := True;
	  lblHint.enabled := False;
    lblHint.AutoSize := True;
  end
  else
  if Assigned(lblHint) then
    FreeAndNil(lblHint);

  Configura;

  if (Assigned(aForm) and (Width > aForm.Width)) then
    Width := aForm.Width;
end;

procedure TAspPopup.Configura;
var
  FTamanhoOcupadoTexto, LLarguraHint, LTop: Single;
  LTitle, LHintText: String;
  LQtdeCabe: Integer;
begin
  LTop := 8;
  LTitle := '';
  if Assigned(FOnGetTitle) then
    LTitle := FOnGetTitle(FControl)
  else
  if Assigned(lblTitle) then
    LTitle := lblTitle.text;

  LHintText := '';
  if Assigned(FOnGetHintText) then
    LHintText := FOnGetHintText(FControl)
  else
  if Assigned(lblHint) then
    LHintText := lblHint.text;

  if (LTitle <> '') and Assigned(lblTitle) then
  begin
    LTop := LTop + lblTitle.Height + 4;
    lblTitle.text := LTitle;
    Width := Math.Max((Length(LTitle) * lblTitle.TextSettings.Font.Size) / 2, 180);
    Height := lblTitle.Height;
    lblTitle.TextSettings.VertAlign := TTextAlign.Center;
    lblTitle.TextSettings.HorzAlign := TTextAlign.Center;
  end;

  if (LHintText <> '') and Assigned(lblHint) then
  begin
    lblHint.Position.Y := LTop;
    lblHint.Text := LHintText;
    lblHint.TextSettings.VertAlign := TTextAlign.Center;
    lblHint.TextSettings.HorzAlign := TTextAlign.Center;

    FTamanhoOcupadoTexto :=  (Length(LHintText) * lblHint.TextSettings.Font.Size) / 2;
    LLarguraHint := Math.Max(FTamanhoOcupadoTexto, 180);

    if LLarguraHint > Width then
      Width := LLarguraHint
    else
      LLarguraHint := Width;
    LQtdeCabe := Trunc(FTamanhoOcupadoTexto / LLarguraHint);
    if (((FTamanhoOcupadoTexto / LLarguraHint) - LQtdeCabe) <> 0) then
      Inc(LQtdeCabe);

    Height := Height + (Math.Max(LQtdeCabe, 1) * 22);

  end;
end;

constructor TAspPopup.Create(AOwner: TComponent);
begin
  inherited;
  FOnGetTitle := nil;
  FOnGetHintText := nil;
  lblHint := nil;
  lblTitle := nil;
  Rect := nil;
end;

procedure TAspPopup.Popup(const AShowModal: Boolean);
begin
  Configura;
  inherited;
end;
{$ENDIF IS_MOBILE}

class
  {$IFDEF IS_MOBILE}procedure{$ELSE}function{$ENDIF}
  TFrmBase.AddHint(const aForm: TForm; const aControl: TControl; const aTitle: String; const aHintText: TRefFuncGetTextPopup; const aTitleColor,
  aColorHintText: TAlphaColor; const aTipoIcon: TMsgDlgType)
  {$IFNDEF IS_MOBILE}: TAspPopup{$ENDIF !IS_MOBILE};
begin
  {$IFNDEF IS_MOBILE}Result := {$ENDIF !IS_MOBILE}AddHint(aForm, aControl, aTitle, '', nil, aHintText, aTitleColor, aColorHintText, aTipoIcon);
end;


{$IFDEF IS_MOBILE}procedure{$ELSE}function{$ENDIF} TFrmBase.AddHint(const aControl: TControl; const aTitle, aHintText: String; const aTitleColor, aColorHintText: TAlphaColor;
  const aTipoIcon: TMsgDlgType)
  {$IFNDEF IS_MOBILE}: TAspPopup{$ENDIF !IS_MOBILE};
begin
  {$IFNDEF IS_MOBILE}Result := {$ENDIF !IS_MOBILE}AddHint(Self, aControl, aTitle, aHintText, nil, nil, aTitleColor, aColorHintText, aTipoIcon);
end;


class
  {$IFDEF IS_MOBILE}procedure{$ELSE}function{$ENDIF}
  TFrmBase.AddHint(const aForm: TForm; const aControl: TControl; const aTitle, aHintText: TRefFuncGetTextPopup; const aTitleColor, aColorHintText: TAlphaColor;
  const aTipoIcon: TMsgDlgType)
  {$IFNDEF IS_MOBILE}: TAspPopup{$ENDIF !IS_MOBILE};
begin
  {$IFNDEF IS_MOBILE}Result := {$ENDIF !IS_MOBILE}AddHint(aForm, aControl, '', '', aTitle, aHintText, aTitleColor, aColorHintText, aTipoIcon);
end;

end.
