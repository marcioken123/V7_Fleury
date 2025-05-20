unit untCommonFrameBase;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}
uses
  {$IFNDEF IS_MOBILE}
  Windows, Messages, ScktComp,
  {$ENDIF}
  FMX.Grid, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.Platform, FMX.VirtualKeyboard,
  FMX.Dialogs, FMX.StdCtrls, FMX.ExtCtrls, FMX.Types, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView, FMX.ListBox,
   Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors, FMX.Objects, FMX.Edit, FMX.TabControl,
  Sics_Common_Parametros, untLog,
  untCommonFormBase, System.UITypes, System.Types, System.SysUtils, System.Classes, System.Variants, Data.DB, System.Rtti,
  Data.Bind.EngExt, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope, Math, FMX.Controls.Presentation,
  MyAspFuncoesUteis, System.ImageList, FMX.ImgList, FMX.Effects,
  Datasnap.DBClient;

type
  TProcOnHide = reference to procedure (aSender: TObject);
  TFrameBase = class(TFrame, IFreeNotificationBehavior)
    layBase: TLayout;
    recCaption: TRectangle;
    lblCaption: TLabel;
    lytFundo: TLayout;
    bndList: TBindingsList;
    btnCloseFrame: TButton;
    rectFundo: TRectangle;
    ilPrincipal: TImageList;
    imgClose: TImage;
    GlowEffect1: TGlowEffect;
    procedure btnCloseFrameClick(Sender: TObject);
    procedure FrameResize(Sender: TObject);
  private
    function GetActiveHDControl: TControl;
    procedure SetActiveHDControl(const Value: TControl);
  protected
    //class var FInstancia: TFrameBase;

    {$IFDEF IS_MOBILE}
    FPodeAtualizarUltimaOrientacao: Boolean;
    FUltimaScreenOrientation: TScreenOrientation;
    FPrimeiraMudancaDeOrientacaoMobile: BOolean;
    FAlturaTeclado: Integer;
    FModificouPosicaoLayout: BOolean;
    {$ENDIF IS_MOBILE}
    FListaProcOnClose: Array of TProcOnHide;
    FEscala: Extended;
    FCarregouParametroDB, FCarregouParametroINI: Boolean;
    FIDUnidade: Integer;
    FUltimaSituacaoFormGrid: String;

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
    procedure ForcarModoDesconectado; Virtual;
    function HandlePodeDesativar(aCastControl: TCastControl): Boolean; Virtual;
    {$ENDREGION}

    procedure SetCaption(const Value: string); Virtual;
    function GetCaption: string; Virtual;
    procedure DefinirCor(const aIdUnidade: Integer; const ACor, aCOrOld: TAlphaColor; const aPintarRetangulo: Boolean); Virtual;
  	procedure SetVisible(const aValue: Boolean); Override;

    function GetDataSetOfLinkGrid(const aLinkGridToDataSource: TLinkGridToDataSource): TDataSet; Virtual;

    procedure CloseOpenNosCDSsAtivos;
  public
    { Public declarations }
    botaoMenu : TButton;
    imgSeta   : TImage;
    botaoSubMenu : TListBoxItem;
    lytSubMenu : TLayout;
    botaoSubMenuPI : TListBoxItem;
    procedure ExecutaOnClose; Virtual;
    function AddOnClose(const aOnClose: TProcOnHide; const aSomenteQuandoVazio: Boolean = true): Boolean; Virtual;
    function GetIndexProcOnClose(const aOnClose: TProcOnHide): Integer; Virtual;

    {$IFDEF IS_MOBILE}
    property KeyboradVisivel: Boolean read GetKeyboradVisivel write SetKeyboradVisivel;
    property PodeAtualizarUltimaOrientacao: BOolean read GetPodeAtualizarUltimaOrientacao write SetPodeAtualizarUltimaOrientacao;
    property UltimaScreenOrientation: TScreenOrientation read GetUltimaScreenOrientation write SetUltimaScreenOrientation;
    property PrimeiraMudancaDeOrientacaoMobile: BOolean read GetPrimeiraMudancaDeOrientacaoMobile write SetPrimeiraMudancaDeOrientacaoMobile;
    property AlturaTeclado: Integer read GetAlturaTeclado write SetAlturaTeclado;
    {$ENDIF IS_MOBILE}

    /// <summary>
    ///   Cria colunas definindo nome e largura
    /// </summary>
    procedure AtualizarColunasGrid; Virtual;

    /// <summary>
    ///   Retorna a situação dos dados tela
    /// </summary>
    function GetContextoCorrente: string; Virtual;

    property ActiveControl: TControl read GetActiveHDControl write SetActiveHDControl;
    procedure FreeNotification(AObject: TObject); Override;
    class function GetInstancia(const aIDUnidade: integer; const aAllowNewInstance: Boolean = False; const aOwner: TComponent = nil): TFMXObject; //TFrameBase;
    procedure AfterConstruction; override;
    function ValidacaoAtivaModoConectado: Boolean; Virtual;
    constructor Create(AOwner: TComponent); overload; override;
    constructor Create(AOwner: TComponent; const aIdUnidade: Integer); reintroduce; overload; virtual;
    constructor Create(AOwner: TComponent;const aIdUnidade: Integer; const aOnClose: TProcOnHide); reintroduce; overload; virtual;
    destructor Destroy; Override;
    procedure UpdateColunasGrid(const aGrid: TCustomGrid; const aDataSet: TDataSet); overload;
    procedure CarregarParametrosDB; Overload; Virtual;
    procedure CarregarParametrosDB(const aIDUnidade: Integer); Overload; Virtual;
    procedure CarregarParametrosINI; Virtual;
    property IDUnidade: Integer read GetIDUnidade write SetIDUnidade;

  published
    property Caption: string read GetCaption write SetCaption;
    property Escala: Extended read GetEscala write SetEscala;
  end;

implementation

{$R *.fmx}

uses untCommonDMConnection, untCommonDMUnidades,
  {$IFNDEF CompilarPara_TOTEMTOUCH}untCommonControleInstanciasTelas,{$ENDIF}
  System.Generics.Collections {$IFDEF CompilarPara_ONLINE}, untSicsOnLine{$ENDIF};

{ TFrameBase }

procedure TFrameBase.UpdateColunasGrid(const aGrid: TCustomGrid; const aDataSet: TDataSet);
begin
  if Self.Visible then
    AspUpdateColunasGrid(Self, aGrid, aDataSet);
end;

function TFrameBase.ValidacaoAtivaModoConectado: Boolean;
begin
  Result := True;
end;

constructor TFrameBase.Create(AOwner: TComponent);
begin
  {$IFDEF IS_MOBILE}
  FAlturaTeclado := 0;
  FPrimeiraMudancaDeOrientacaoMobile := False;
  FPodeAtualizarUltimaOrientacao := True;
  FUltimaScreenOrientation := TScreenOrientation.Portrait;
  FModificouPosicaoLayout := False;
  {$ENDIF IS_MOBILE}

  SetLength(FListaProcOnClose, 0);
  FEscala := 0;
  FUltimaSituacaoFormGrid := '';
  FCarregouParametroDB := False;
  FCarregouParametroINI := False;
  Self.Visible := False;

  //Tem que criar o FrameBase sem nenhuma unidade, para que o SetIdUnidade de
  //cada frame faça seu trabalho
  FidUnidade := vgParametrosModulo.UnidadePadrao; //-1

  inherited;
end;

function TFrameBase.AddOnClose(const aOnClose: TProcOnHide; const aSomenteQuandoVazio: Boolean): Boolean;
begin
  Result := Assigned(aOnClose) and ((not aSomenteQuandoVazio) or (Length(FListaProcOnClose) = 0));
  if Result then
  begin
    SetLength(FListaProcOnClose, Length(FListaProcOnClose) + 1);
    FListaProcOnClose[Length(FListaProcOnClose) -1] := aOnClose;
  end;
end;

procedure TFrameBase.AfterConstruction;
begin
  inherited;

  if (IdUnidade = ID_UNIDADE_VAZIA) then
    IdUnidade := vgParametrosModulo.UnidadePadrao;
end;

procedure TFrameBase.AtualizarColunasGrid;
begin
  if Self.Visible then
    AspUpdateColunasGrid(Self, bndList, GetDataSetOfLinkGrid);
end;

procedure TFrameBase.btnCloseFrameClick(Sender: TObject);
begin
  Visible := False;
  if(botaoMenu <> nil)then
    botaoMenu.StaysPressed := false;

  if(imgSeta <> nil)then
    imgSeta.Visible := False;

  if(botaoSubMenu <> nil)then
    botaoSubMenu.IsSelected := false;

  if(botaoSubMenuPI <> nil)then
    botaoSubMenuPI.IsSelected := false;

  if(lytSubMenu <> nil)then
    lytSubMenu.Visible := False;


end;

procedure TFrameBase.CarregarParametrosDB;
begin
  FCarregouParametroDB := True;
end;

procedure TFrameBase.CarregarParametrosDB(const aIDUnidade: Integer);
begin
  FCarregouParametroDB := True;
end;

procedure TFrameBase.CarregarParametrosINI;
begin
  FCarregouParametroINI := True;
end;

//fecha e abre todos os datasets que já estão abertos, para o caso de estar
//trocando a unidade com a tela ativa
procedure TFrameBase.CloseOpenNosCDSsAtivos;
type
  TListaDeCDS = TList<TClientDataSet>;
var
  i: Integer;
  LListaReabrir: TlistaDeCDS;
  LListaRecriar: TListaDeCDS;
  Lcds: TClientDataSet;
begin
  LListaRecriar := TListaDeCDS.Create;
  try
    LListaReabrir := TListaDeCDS.Create;
    try
      for i := 0 to ComponentCount-1 do
        if Components[i] is TClientDataSet then
        begin
          Lcds := TClientDataSet(Components[i]);
          if Lcds.Active then
          begin
            Lcds.DisableControls;
            Lcds.Close;
            if (Lcds.ProviderName <> EmptyStr) then
              LListaReabrir.Add(Lcds)
            else
              LListaRecriar.Add(Lcds);
          end;
        end;

      for Lcds in LListaReabrir do
      begin
        Lcds.Open;
        Lcds.EnableControls;
      end;

      for Lcds in LListaRecriar do
      begin
        Lcds.CreateDataSet;
        Lcds.EnableControls;
      end;
    finally
      LListaReabrir.Free;
    end;
  finally
    LListaRecriar.Free;
  end;
end;

constructor TFrameBase.Create(AOwner: TComponent; const aIdUnidade: Integer);
begin
  Create(AOwner);
  IDUnidade := aIDUnidade;
end;

procedure TFrameBase.DefinirCor(const aIdUnidade: Integer; const ACor, aCOrOld: TAlphaColor; const aPintarRetangulo: Boolean);
begin
  TFrmBase.DefinirCor(Self, ACor, aCOrOld, aPintarRetangulo);
end;

destructor TFrameBase.Destroy;
begin
  if Self.Visible then
    Self.Visible := False;

  inherited;
end;

procedure TFrameBase.ExecutaOnClose;
var
  i: Integer;
begin
  for i := 0 to Length(FListaProcOnClose) -1 do
  begin
    if (FListaProcOnClose[i] <> nil) then
      FListaProcOnClose[i](Self);
  end;
end;

procedure TFrameBase.ForcarModoDesconectado;
begin

end;

procedure TFrameBase.FrameResize(Sender: TObject);
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

procedure TFrameBase.FreeNotification(AObject: TObject);
begin
  inherited;

end;

function TFrameBase.GetActiveHDControl: TControl;
begin
  Result := nil;
end;

function TFrameBase.GetCaption: string;
begin
  Result := lblCaption.Text;
end;

function TFrameBase.GetContextoCorrente: string;
begin
  Result := '';
end;

function TFrameBase.GetDataSetOfLinkGrid(const aLinkGridToDataSource: TLinkGridToDataSource): TDataSet;
begin
  Result := nil;
end;

function TFrameBase.GetEscala: Extended;
begin
  Result := FEscala;
end;

function TFrameBase.GetIDUnidade: Integer;
begin
  Result := FIDunidade;
end;

function TFrameBase.GetIndexProcOnClose(const aOnClose: TProcOnHide): Integer;
var
  I: Integer;
begin
  Result := -1;
  if Assigned(aOnClose) then
  begin
    for I := 0 to Length(FListaProcOnClose) -1 do
    begin
      if (@FListaProcOnClose[i] = @aOnClose) then
      begin
        Result := i;
        break;
      end;
    end;
  end;
end;

class function TFrameBase.GetInstancia(const aIDUnidade: integer; const aAllowNewInstance: Boolean; const aOwner: TComponent): TFMXObject; //TFrameBase;
var
  LOwner: TComponent;
  LFrameBase: TFrameBase;
begin
  result := nil;

  {$IFNDEF CompilarPara_TOTEMTOUCH}
  if TControleInstanciasTelas.Existe(Self, result) then
  begin
    TFrameBase(Result).IDUnidade := aIDUnidade;
    exit;
  end;

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

function TFrameBase.GetUltimaSituacaoForm: String;
begin
  Result := Format('PDB%dPINI%dV%dW%nH%nP%d', [Integer(FCarregouParametroDB), Integer(FCarregouParametroINI),
    Integer(Self.Visible), Self.Width, self.Height, Integer(Position)]);

  {$IFDEF IS_MOBILE}
  Result := Result + Format('K%dO%D', [Integer(KeyboradVisivel), Integer(FUltimaScreenOrientation)]);
  {$ENDIF IS_MOBILE}
end;

function TFrameBase.HandlePodeDesativar(aCastControl: TCastControl): Boolean;
begin
  Result := Assigned(aCastControl);
end;

procedure TFrameBase.SetActiveHDControl(const Value: TControl);
begin
  Exit;
end;

procedure TFrameBase.SetCaption(const Value: string);
begin
  lblCaption.Text := Value;
end;

procedure TFrameBase.SetEscala(const Value: Extended);
begin
  FEscala         := Value;
  layBase.Scale.X := FEscala;
  layBase.Scale.Y := FEscala;
end;

procedure TFrameBase.SetIDUnidade(const Value: Integer);
begin
  if (IDUnidade <> Value) then
    FIDUnidade := Value;
end;

procedure TFrameBase.SetModoConexaoAtual(const aIdUnidade: Integer;const Value: Boolean);
begin
  if (aIdUnidade < 0) then
    Exit;

  if (csDestroying in ComponentState) or (not ValidacaoAtivaModoConectado) then
    Exit;

  {$IFNDEF CompilarPara_TGS}
  if (aIdUnidade = IdUnidade) then
  begin
  {$ENDIF}
    if Value or (not dmUnidades.FoiConfiguradoConexao) then
    begin
      DefinirCor(aIdUnidade, CorConectado, CorDesconectado, True);
    end
    else
    begin
      DefinirCor(aIdUnidade, CorDesconectado, CorConectado, True);
    end;
  {$IFNDEF CompilarPara_TGS}
  end;
  {$ENDIF}
end;

procedure TFrameBase.SetVisible(const aValue: Boolean);
var
  LJaExibiuFrame, LModificou: Boolean;
begin
  LModificou := Visible <> aValue;

  if (not Assigned(Parent)) then
  begin
    if aValue then
      MyAspFuncoesUteis.LoadPosition(Self)
    else
    if (LJaExibiuFrame) then
      MyAspFuncoesUteis.SavePosition(Self);
  end;
  if (LModificou and (not aValue) and LJaExibiuFrame) then
    ExecutaOnClose;

  inherited;
  if aValue and (LModificou or (not LJaExibiuFrame)) then
    AtualizarColunasGrid;

  {$IFDEF CompilarPara_ONLINE}
    if(Assigned(FrmSicsOnLine))then
       FrmSicsOnLine.existeTelaAberta := aValue;
  {$ENDIF}
end;


{$IFDEF IS_MOBILE}
function TFrameBase.GetPodeAtualizarUltimaOrientacao: BOolean;
begin
  Result := FPodeAtualizarUltimaOrientacao;
end;

function TFrameBase.GetPrimeiraMudancaDeOrientacaoMobile: BOolean;
begin
  Result := FPrimeiraMudancaDeOrientacaoMobile;
end;

function TFrameBase.GetAlturaTeclado: Integer;
begin
  Result := FAlturaTeclado;
end;

function TFrameBase.GetKeyboradVisivel: Boolean;
var
  LVirtualKeyboardService: IFMXVirtualKeyboardService;
begin
  Result := False;
  if (TPlatformServices.Current <> nil) and TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, LVirtualKeyboardService) then
    Result := TVirtualKeyboardState.Visible in LVirtualKeyboardService.VirtualKeyboardState;
end;

function TFrameBase.GetUltimaScreenOrientation: TScreenOrientation;
begin
  Result := FUltimaScreenOrientation;
end;

procedure TFrameBase.SetAlturaTeclado(const Value: Integer);
begin
  FAlturaTeclado := Value;
end;

procedure TFrameBase.SetPodeAtualizarUltimaOrientacao(const Value: BOolean);
begin
  FPodeAtualizarUltimaOrientacao := Value;
end;

procedure TFrameBase.SetPrimeiraMudancaDeOrientacaoMobile(const Value: BOolean);
begin
  FPrimeiraMudancaDeOrientacaoMobile := Value;
end;

procedure TFrameBase.SetUltimaScreenOrientation(const Value: TScreenOrientation);
begin
  FUltimaScreenOrientation := Value;
end;

procedure TFrameBase.CalculaAlturaLayoutBase;
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

procedure TFrameBase.SetKeyboradVisivel(const Value: Boolean);
var
  LVirtualKeyboardService: IFMXVirtualKeyboardService;
  LEstaVisivel: Boolean;
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

  if ((TPlatformServices.Current <> nil) and TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, LVirtualKeyboardService)) then
  begin
    LEstaVisivel := (TVirtualKeyboardState.Visible in LVirtualKeyboardService.VirtualKeyboardState);
    if (LEstaVisivel <> Value) then
    begin
      if Value then
        LVirtualKeyboardService.ShowVirtualKeyboard(activeControl)
      else
        LVirtualKeyboardService.HideVirtualKeyboard;

    end;
  end;
  Self.FrameResize(Self);
end;

{$ENDIF IS_MOBILE}

constructor TFrameBase.Create(AOwner: TComponent; const aIdUnidade: Integer; const aOnClose: TProcOnHide);
begin
  Create(AOwner, aIdUnidade);
  AddOnClose(aOnClose);
end;

end.
