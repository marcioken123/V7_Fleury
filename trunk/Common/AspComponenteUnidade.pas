unit AspComponenteUnidade;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  System.SysUtils, System.Classes, Data.DB, System.Types,
  System.UITypes, System.DateUtils, FMX.Types, untLog,
  FMX.Controls,

  {$IFDEF SuportaDLL}MyDlls_DX,  ClassLibraryVCL, AspectVCL, {$ELSE}

    {$IF Defined(CompilarPara_SICS)}
    MyDlls_DX,
    {$ENDIF}
  ClassLibrary, Aspect,{$ENDIF SuportaDLL}
  FMX.ListBox, System.Generics.Defaults, System.Generics.Collections, AspFuncoesUteis,
  Data.Bind.Grid;

type
  /// <summary>
  ///   O tipo de conexão sepera os status da conexão. Pois para o TGS o app pode estar conectado
  ///  com o banco de dados (Firebird) mais com o Sics Server não.
  /// </summary>
  {$IFDEF CompilarPara_TGS}
  TTipoConexao = (tcServidor, tcDB, tcDBRelatorio);
  {$ELSE}
  TTipoConexao = (tcServidor);
  {$ENDIF CompilarPara_TGS}

  TListaComponentesDesabilitados = class;
  /// <summary>
  ///   Interface para vincular todos os forms, frames e datamodule que possuem instacia por unidade.
  /// </summary>
  IInterfaceUnidade = interface
    ['{CFB511D3-DCB1-4DEE-9EB6-A4C2280222A7}']
    function GetIDUnidade: Integer;
    procedure SetIDUnidade(const Value: Integer);
    property IDUnidade: Integer read GetIDUnidade write SetIDUnidade;
  end;

  /// <summary>
  ///   Boolean com o valor null
  /// </summary>
  TNullBoolena = (tcNaoDefinido, tcSim, tcNao);

  TListNullBoolena = array of TNullBoolena;

  /// <summary>
  ///   Situação da conexão por tipo de conexão.
  ///  Exemplo: Para conexão com servidor a situação é conectado (tcSim).
  /// </summary>
  TlistNullBoolenaPorTipoConexao = array[TTipoConexao] of TListNullBoolena;
  TUnidadeNullBoolena = TlistNullBoolenaPorTipoConexao;


  /// <summary>
  ///   Indificador de objetos\forms que tem uma instancia por unidade.
  ///  Utilizado para facilitar a localização da instância no lugar de Application.FindComponent('Nome')
  ///  Utilizar InstaciaForm := FGerenciadorUnidades.FormGerenciado[tcSituacaoShow, aIDUnidade];
  /// </summary>
  TTipoTela = (tcNenhum,

    {$IFDEF CompilarPara_TGS}
    tcSituacaoShow, tcPesquisaRelatorio,
    tcPesquisaRelatorioPP, tcPesquisaRelatorioPausa, tcMensagemPainelEImpressora, tcDebugParameters,
    tcConfiguraTabela, tcConfigPrioridades, {tcCanalTVMudar, }tcCadPIS, tcCadNiveis, tcCadHor,
    tcCadAlarmes,
      tcSplash,
    tcLines,
    tcPromptUnidade, tcParamsGraficoSLA, tcSicsReport, tcSicsGraphics,
    tcsParamsNiveisSLA, tcReportPausas, tcGraphicsPausas, tcReportPP, tcGraphicsPP, tcDMMain,
    {$ENDIF CompilarPara_TGS}

    {$IFDEF CompilarPara_SICSTV}
    tcSplash, tcPIShow,
    {$ENDIF CompilarPara_SICSTV}
    {$IF Defined(CompilarPara_ONLINE) or Defined(CompilarPara_TGS)}
    tcPIShow, tcSituacaoEspera, tcFraSitAtend,
    {$ENDIF}

    {$IFDEF CompilarPara_ONLINE}
    tcTotemTouch,
    {$ENDIF CompilarPara_ONLINE}
    tcSelecaoMotivoPausa,tcSelecaoPP, tcManipulaPPs, tcConfigParametros, tcAlteracaoSenha,
    tcDMClient, tcLogin, tcSelecaoGrupos, tcSelecaoFila,  tcParametrosModulo
    );

  /// <summary>
  ///   O gerenciador possui a instancia de todos os forms.
  ///  Agrupado por tipo tela e unidade.
  ///  Lista = Array of Tipo tila de Array de unidade com valor igual a instancia do form.
  /// </summary>
  TGerenciadorUnidades = class(TComponent)
  protected
    function GetObjetoGerenciado(const aTipoTela: TTipoTela; const aIDUnidade: Integer = 0): TComponent; Virtual;
    procedure RemoveVazio(const aTipoTela: TTipoTela);
  public
    FListaForms: Array [TTipoTela] of array of TComponent;
    class function GetDescModulo(const aControler: TObject): String;
    constructor Create(AOwner: TComponent); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    procedure Add(const aTipoTela: TTipoTela; const aIDUnidade: Integer; const Value: TComponent); Overload; Virtual;
    procedure Add(const aTipoTela: TTipoTela; const Value: TComponent); Overload; Virtual;
    procedure Remove(const aTipoTela: TTipoTela; const aIdUnidade: Integer); Overload; Virtual;
    procedure Remove(const aTipoTela: TTipoTela; const Value: TComponent); Overload; Virtual;
    procedure Remove(const Value: TComponent); Overload; Virtual;
    property FormGerenciado[const aTipoTela: TTipoTela; const aIDUnidade: Integer = 0]: TComponent read GeTObjetoGerenciado;
  end;

  IAspBaseTela = interface
  ['{07A0DD3C-F106-4423-A871-79A2E1C6AF5E}']
    procedure CarregarParametrosDB(const aIDUnidade: Integer);
    function GetUltimaSituacaoForm: String;
    procedure ConfiguraCloseBtn;
    procedure SetEscala(const Value: Extended);
    function GetEscala: Extended;
    procedure AtualizarColunasGrid;
    function GetContextoCorrente: string;
    function GetDataSetOfLinkGrid(const aLinkGridToDataSource: TLinkGridToDataSource): TDataSet;
  end;

  /// <summary>
  ///   Foi utilizado uma interface para permitir que os forms e frame entrem em modo conectado.
  ///  Quando está com um form aberto (Ex: Seleção fila) e cai a conexão o form é pintado de vermelho e
  ///  componentes são desabilitados.
  /// </summary>
  IFormComponentesDesabilitados = interface
   ['{BB3E3148-273D-400A-8354-F3D29A109D31}']

   /// <summary>
   ///   São os parâmetros configurados no Sics Server
   ///  É executado somente uma vez por PA quando o servidor retorna as configurações da PA
   /// </summary>
    procedure CarregarParametrosDB; Overload;
    procedure CarregarParametrosDB(const aIDUnidade: Integer); Overload;
   /// <summary>
   ///   São os parâmetros configurados no arquivo INI (Local)
   ///  É executado somente uma vez (no Create do form ou quando o ini é carregado)
   /// </summary>
    procedure CarregarParametrosINI;
    procedure SincronizaParametros;
    /// <summary>
    ///   Reabitita componentes que foram desabilitados quando o servidor ficou offline
    /// </summary>
    procedure HabilitarComponentes(const aTipoConexao: TTipoConexao; const aIdUnidade: Integer);
    /// <summary>
    ///   Desabilita componentes quando o servidor entra em offline
    /// </summary>
    procedure DesabilitarComponentes(const aTipoConexao: TTipoConexao; const aIdUnidade: Integer);
    procedure ModoConectado(const aTipoConexao: TTipoConexao; const aIdUnidade: Integer);
    procedure ModoDesconectado(const aTipoConexao: TTipoConexao; const aIdUnidade: Integer);
//    procedure ModoProcessamento(const aTipoConexao: TTipoConexao; const aIdUnidade: Integer);
    function ValidacaoAtivaModoConectado: Boolean;
    procedure SetModoConexaoAtual(const aTipoConexao: TTipoConexao; const aIdUnidade: Integer; const Value: TNullBoolena);
    function GetModoConexaoAtual(const aTipoConexao: TTipoConexao; const aIdUnidade: Integer): TNullBoolena;
    /// <summary>
    ///   Define a situação da conexão com o servidor por unidade no form atual.
    ///  Ao definir a situação os componentes são desabilitados\habilitados e altera a cor fundo quando desconectado.
    /// </summary>
    property ModoConexaoAtual[const aTipoConexao: TTipoConexao; const aIdUnidade: Integer]: TNullBoolena read GetModoConexaoAtual write SetModoConexaoAtual;

    procedure ForcarModoDesconectado;
    function HandlePodeDesativar(aCastControl: TCastControl): Boolean;
    function GetNewListaComponentesDesabilitados: TListaComponentesDesabilitados;
    procedure DefinirCor(const aTipoConexao: TTipoConexao; const aIdUnidade: Integer; const ACor, aCorOld: TAlphaColor; const aPintarRetangulo: Boolean);
  end;

  {$IFDEF IS_MOBILE}
  IIntentMobilePosition = interface
    ['{83E0D7BC-B9ED-4522-B2CB-1605A3BEBC76}']
    function GetAlturaTeclado: Integer;
    function GetKeyboradVisivel: Boolean;
    function GetPodeAtualizarUltimaOrientacao: BOolean;
    function GetPrimeiraMudancaDeOrientacaoMobile: BOolean;
    function GetUltimaScreenOrientation: TScreenOrientation;
    function GetActiveHDControl: TControl;
    procedure SetActiveHDControl(const Value: TControl);
    procedure SetAlturaTeclado(const Value: Integer);
    procedure SetPodeAtualizarUltimaOrientacao(const Value: BOolean);
    procedure SetPrimeiraMudancaDeOrientacaoMobile(const Value: BOolean);
    procedure SetUltimaScreenOrientation(const Value: TScreenOrientation);
    procedure CalculaAlturaLayoutBase;
    procedure SetKeyboradVisivel(const Value: Boolean);
    property KeyboradVisivel: Boolean read GetKeyboradVisivel write SetKeyboradVisivel;
    property PodeAtualizarUltimaOrientacao: BOolean read GetPodeAtualizarUltimaOrientacao write SetPodeAtualizarUltimaOrientacao;
    property UltimaScreenOrientation: TScreenOrientation read GetUltimaScreenOrientation write SetUltimaScreenOrientation;
    property PrimeiraMudancaDeOrientacaoMobile: BOolean read GetPrimeiraMudancaDeOrientacaoMobile write SetPrimeiraMudancaDeOrientacaoMobile;
    property AlturaTeclado: Integer read GetAlturaTeclado write SetAlturaTeclado;

    property ActiveControl: TControl read GetActiveHDControl write SetActiveHDControl;
  end;
  {$ENDIF IS_MOBILE}

  /// <summary>
  ///   Lista de todos os forms e frame da aplicação que estão instanciados.
  /// </summary>
  TListaFormComponentesDesabilitados = class(TComponentFreeNotify)
  protected
    FModoConexaoAtual: TUnidadeNullBoolena;

    procedure SetModoConexaoAtual(const aTipoConexao: TTipoConexao; const aIdUnidade: Integer; const Value: TNullBoolena); Virtual;
    function GetModoConexaoAtual(const aTipoConexao: TTipoConexao; const aIdUnidade: Integer): TNullBoolena; Virtual;
  public
    FLista: TList<IFormComponentesDesabilitados>;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    constructor Create(AOwner: TComponent); Override;
    destructor Destroy; override;
    function Add(const Value: IFormComponentesDesabilitados): Integer; virtual;
    function Remove(const aIndex: Integer): Boolean; Overload;virtual;
    function Remove(const aComponent: IFormComponentesDesabilitados): Boolean; Overload; virtual;
    function Remove(const aComponent: TComponent): Boolean; Overload; virtual;
    procedure Sincroniza(const Value: IFormComponentesDesabilitados); virtual;
    procedure ModoConectado(const aTipoConexao: TTipoConexao; const aIdUnidade: Integer); virtual;
    procedure ModoDesconectado(const aTipoConexao: TTipoConexao; const aIdUnidade: Integer); virtual;
    procedure CarregarParametrosDBForAll; Overload; Virtual;
    procedure CarregarParametrosDBForAll(const aIDUnidade: Integer); Overload; Virtual;
    procedure CarregarParametrosINIForAll; Virtual;
    property ModoConexaoAtual[const aTipoConexao: TTipoConexao; const aIdUnidade: Integer]: TNullBoolena read GetModoConexaoAtual write SetModoConexaoAtual;
  end;

  TOnPodeDesativar = function (aCastControl: TCastControl): Boolean of Object;

  /// <summary>
  ///   Lista de com componentes desabilitados ao entrar em modo offline (Exe: btnProximo).
  ///  Somente fica na lista componente que estão com enabled = false.
  /// </summary>
  TListaComponentesDesabilitados = class(TComponentFreeNotify)
  private
    FOnPodeDesativar: TOnPodeDesativar;
    procedure SetOnPodeDesativar(const Value: TOnPodeDesativar);
  protected
    FActiveControl: TCastControl;
    procedure SetActiveControl(const Value: TCastControl);
  public
    FLista: TListaControl;
    FDesabilitou: Boolean;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure HabilitarComponentes; overload; virtual;
    procedure HabilitarComponentes(const aControl: TCastControl); overload; virtual;
    procedure DesabilitarComponentes; virtual;
    procedure DefineCurrentActiveControl; virtual;
    procedure DesabilitarComponente(const aControl: TCastControl); overload; virtual;
    procedure DesabilitarComponente(const aControl: array of TCastControl); overload; virtual;
    function Remove(const aIndex: Integer): Boolean; Overload; Virtual;
    function Remove(const AComponent: TComponent): Boolean; Overload; Virtual;
    procedure LimparLista;
    constructor Create(AOwner: TComponent); Override;
    destructor Destroy; override;
    property ActiveControl: TCastControl read FActiveControl write SetActiveControl;
    property OnPodeDesativar: TOnPodeDesativar read FOnPodeDesativar write SetOnPodeDesativar;
  end;
  TTipoConexaoListaComponentesDesabilitados = array[TTipoConexao] of TListaComponentesDesabilitados;

  TProcedureOnTimer = reference to function : Boolean;

  TTimerAnonimo = class(TTimer)
  protected
    procedure DoOnTimer; Override;
  public
    FProcedureOnTimer: TProcedureOnTimer;
    FSetDisableOnTimer: Boolean;
    constructor Create(AOwner: TComponent); overload; override;
    constructor Create(AOwner: TComponent; aProcedureOnTimerPA: TProcedureOnTimer;
      const aSetDisableOnTimer: BOolean; const aInterval: Integer = 2000); Reintroduce; overload; virtual;
    destructor Destroy; override;
    procedure HandleOnTimer(Sender: TObject);
  end;

procedure VarInicializarArrayComponentesDesabilitados(var aComponentesDesabilitados: TTipoConexaoListaComponentesDesabilitados);
procedure VarInicializarArrayConexao(var aModoConexaoAtual: TUnidadeNullBoolena);
function RemoveOrAddFreeNotify(aSender: TComponent; aFormComponentesDesabilitados: IFormComponentesDesabilitados; const aRemove: Boolean): Boolean; Overload;

var
  FListaFormComponentesDesabilitados: TListaFormComponentesDesabilitados;
  FGerenciadorUnidades: TGerenciadorUnidades;

implementation

{ TListaComponentesDesabilitados }

constructor TListaComponentesDesabilitados.Create(AOwner: TComponent);
begin
  FLista := TListaControl.Create;
  FOnPodeDesativar := nil;
  FActiveControl := nil;
  FDesabilitou := False;
  inherited;
end;

procedure TListaComponentesDesabilitados.DefineCurrentActiveControl;
begin
  if Assigned(Owner) and (Owner is TCastForm) then
    ActiveControl := TCastForm(Owner).ActiveControl
  else
    ActiveControl := nil;
end;

procedure TListaComponentesDesabilitados.DesabilitarComponente(const aControl: TCastControl);
begin
  if (Assigned(aControl) and (aControl.Enabled) and
    {$IFDEF FIREMONKEY}((not (aControl is FMX.ListBox.TListBoxItem)) or FMX.ListBox.TListBoxItem(aControl).Selectable) and {$ENDIF FIREMONKEY}
   ((not Assigned(OnPodeDesativar)) or OnPodeDesativar(aControl))) then
  begin
    aControl.Enabled := False;
    {$IFDEF FIREMONKEY}
    if (aControl is FMX.ListBox.TListBoxItem) then
      FMX.ListBox.TListBoxItem(aControl).Selectable := False;
    {$ENDIF FIREMONKEY}

    FLista.Add(aControl);
    RemoveOrAddFreeNotify(Self, aControl, False);
  end;
end;

procedure TListaComponentesDesabilitados.DesabilitarComponente(const aControl: array of TCastControl);
var
  i: Integer;
begin
  FDesabilitou := True;
  for i := Low(aControl) to High(aControl) do
  begin
    DesabilitarComponente(aControl[i]);
  end;
end;

procedure TListaComponentesDesabilitados.DesabilitarComponentes;
var
  I: Integer;
  LComponent: TComponent;
begin
  if ((not Assigned(Owner))) then
    Exit;

  if not FDesabilitou then
    LimparLista;

  FDesabilitou := True;
  for I := 0 to Pred(Owner.ComponentCount) do
  begin
    LComponent := Owner.Components[I];
    if Assigned(LComponent) and (LComponent is TCastControl) then
      DesabilitarComponente(TCastControl(LComponent));
  end;

  DefineCurrentActiveControl;
end;

destructor TListaComponentesDesabilitados.Destroy;
begin
  ActiveControl := nil;
  FOnPodeDesativar := nil;
  LimparLista;

  FreeAndNil(FLista);
  inherited;
end;

procedure TListaComponentesDesabilitados.HabilitarComponentes(const aControl: TCastControl);
begin
  if (aControl <> nil) then
  begin
    if (not aControl.Enabled) then
      aControl.Enabled := True;

    {$IFDEF FIREMONKEY}
    if ((aControl is FMX.ListBox.TListBoxItem) and (not FMX.ListBox.TListBoxItem(aControl).Selectable)) then
      FMX.ListBox.TListBoxItem(aControl).Selectable := True;
    {$ENDIF FIREMONKEY}
  end;
end;

procedure TListaComponentesDesabilitados.HabilitarComponentes;
var
  i: Integer;
begin
  if ((not Assigned(FLista)) or (not FDesabilitou)) then
    Exit;

  FDesabilitou := False;
  for I := 0 to Pred(FLista.Count) do
  begin
    HabilitarComponentes(FLista.Items[i]);
  end;

  if Assigned(FActiveControl) and FActiveControl.Visible and
    FActiveControl.CanFocus and FActiveControl.Enabled and
    (Owner is TCastForm) then
    TCastForm(Owner).ActiveControl := FActiveControl;

  ActiveControl := nil;
  LimparLista;
end;

procedure TListaComponentesDesabilitados.LimparLista;
var
  i: Integer;
begin
  for I := FLista.Count -1 downto 0 do
  begin
    Remove(i);
  end;
end;

procedure TListaComponentesDesabilitados.Notification(AComponent: TComponent;
  Operation: TOperation);
var
  LIndex: Integer;
begin
  inherited;
  if (Operation = TOperation.opRemove) and Assigned(AComponent) then
  begin
    if Assigned(AComponent) and Assigned(FLista) and (FLista.Count > 0) and (AComponent is TCastControl) then
    begin
      LIndex := FLista.IndexOf(TCastControl(AComponent));
      if (LIndex > -1) then
        FLista.Delete(LIndex);
    end;

    if (AComponent = FActiveControl) then
      FActiveControl := nil;
  end;
end;

function TListaComponentesDesabilitados.Remove(const AComponent: TComponent): Boolean;
begin
  Result := False;
  if Assigned(AComponent) and Assigned(FLista) and (FLista.Count > 0) and (AComponent is TCastControl) then
    Result := Remove(FLista.IndexOf(TCastControl(AComponent)));
end;

function TListaComponentesDesabilitados.Remove(const aIndex: Integer): Boolean;
begin
  Result := False;
  if (aIndex <= -1) then
    Exit;

  RemoveOrAddFreeNotify(Self, FLista.Items[aIndex], True);
  FLista.Delete(aIndex);
  Result := True;
end;

procedure TListaComponentesDesabilitados.SetActiveControl(const Value: TCastControl);
begin
  FActiveControl := TCastControl(GetComponenteFreeNotify(Self, FActiveControl, Value));
end;

procedure TListaComponentesDesabilitados.SetOnPodeDesativar(const Value: TOnPodeDesativar);
begin
  FOnPodeDesativar := Value;
end;

{ TListaFormComponentesDesabilitados }

function TListaFormComponentesDesabilitados.Add(const Value: IFormComponentesDesabilitados): Integer;
begin
  Result := FLista.Add(Value);
  if not Assigned(Value) then
    Exit;

  RemoveOrAddFreeNotify(Self, Value, False);
  Sincroniza(Value);
end;

procedure TListaFormComponentesDesabilitados.CarregarParametrosDBForAll;
var
  i: Integer;
  LNotifyParametrosParsed: IFormComponentesDesabilitados;
begin
  for I := 0 to Pred(FLista.Count) do
  begin
    LNotifyParametrosParsed := FLista[i];

    if Assigned(LNotifyParametrosParsed) then
      LNotifyParametrosParsed.CarregarParametrosDB;
  end;
end;

procedure TListaFormComponentesDesabilitados.CarregarParametrosDBForAll(const aIDUnidade: Integer);
var
  i: Integer;
  LNotifyParametrosParsed: IFormComponentesDesabilitados;
begin
  for I := 0 to Pred(FLista.Count) do
  begin
    LNotifyParametrosParsed := FLista[i];

    if Assigned(LNotifyParametrosParsed) then
      LNotifyParametrosParsed.CarregarParametrosDB(aIDUnidade);
  end;
end;

procedure TListaFormComponentesDesabilitados.CarregarParametrosINIForAll;
var
  i: Integer;
  LNotifyParametrosParsed: IFormComponentesDesabilitados;
begin
  for I := 0 to Pred(FLista.Count) do
  begin
    LNotifyParametrosParsed := FLista[i];

    if Assigned(LNotifyParametrosParsed) then
      LNotifyParametrosParsed.CarregarParametrosINI;
  end;
end;

constructor TListaFormComponentesDesabilitados.Create(AOwner: TComponent);
begin
  inherited;
  VarInicializarArrayConexao(FModoConexaoAtual);
  FLista := TList<IFormComponentesDesabilitados>.Create;
end;

destructor TListaFormComponentesDesabilitados.Destroy;
var
  I: Integer;
begin
  if Assigned(FLista) then
  begin
    for i := FLista.Count -1 downto 0 do
    begin
      Remove(i);
    end;
  end;
  FreeAndNil(FLista);
  inherited;
end;
function TListaFormComponentesDesabilitados.GetModoConexaoAtual(const aTipoConexao: TTipoConexao; const aIdUnidade: Integer): TNullBoolena;
begin
  if (Length(FModoConexaoAtual[aTipoConexao]) <= aIdUnidade) then
    Result := tcNaoDefinido
  else
    Result := FModoConexaoAtual[aTipoConexao][aIDUnidade];
end;

procedure TListaFormComponentesDesabilitados.ModoConectado(const aTipoConexao: TTipoConexao; const aIdUnidade: Integer);
begin
  ModoConexaoAtual[aTipoConexao, aIdUnidade] := tcSim;
end;

procedure TListaFormComponentesDesabilitados.ModoDesconectado(const aTipoConexao: TTipoConexao; const aIdUnidade: Integer);
begin
  ModoConexaoAtual[aTipoConexao, aIdUnidade] := tcNao;
end;

procedure TListaFormComponentesDesabilitados.Notification(
  AComponent: TComponent; Operation: TOperation);
begin
  inherited;

  if (Operation = opRemove) and Assigned(AComponent) then
    Remove(AComponent);
end;

function TListaFormComponentesDesabilitados.Remove(const aComponent: TComponent): Boolean;
var
  LFormComponentesDesabilitados: IFormComponentesDesabilitados;
begin
  Result := False;
  if Assigned(aComponent) and Supports(aComponent, IFormComponentesDesabilitados, LFormComponentesDesabilitados) then
    Result := Remove(LFormComponentesDesabilitados);
end;

function TListaFormComponentesDesabilitados.Remove(const aComponent: IFormComponentesDesabilitados): Boolean;
begin
  Result := Remove(FLista.IndexOf(aComponent));
end;

function TListaFormComponentesDesabilitados.Remove(const aIndex: Integer): BOolean;
begin
  Result := False;
  if (aIndex > -1) then
  begin
    RemoveOrAddFreeNotify(Self, FLista.Items[aIndex], True);
    FLista.Delete(aIndex);
    Result := true;
  end;
end;

procedure VarInicializarArrayComponentesDesabilitados(var aComponentesDesabilitados: TTipoConexaoListaComponentesDesabilitados);
var
  i: Integer;
begin
  for i := Ord(Low(TTipoConexao)) to Ord(High(TTipoConexao)) do
  begin
    aComponentesDesabilitados[TTipoConexao(i)] := nil;
  end;
end;

procedure VarInicializarArrayConexao(var aModoConexaoAtual: TUnidadeNullBoolena);
var
  i: Integer;
begin
  for i := Ord(Low(TTipoConexao)) to Ord(High(TTipoConexao)) do
  begin
    SetLength(aModoConexaoAtual[TTipoConexao(i)], 1);
    aModoConexaoAtual[TTipoConexao(i)][ID_UNIDADE_PRINCIPAL] := tcNaoDefinido;
  end;
end;

function RemoveOrAddFreeNotify(aSender: TComponent; aFormComponentesDesabilitados: IFormComponentesDesabilitados; const aRemove: Boolean): Boolean;
var
  sErroInfo: string;
  {$IFDEF FIREMONKEY}
  LFreeNotificationBehavior: IFreeNotificationBehavior;
  LFreeNotification: IFreeNotification;
  {$ENDIF FIREMONKEY}
begin
  Result := False;
  sErroInfo := '';
  try
    if not Assigned(aFormComponentesDesabilitados) then
      Exit;

    if (aFormComponentesDesabilitados is TComponent) then
    begin
      sErroInfo := sErroInfo + ' Classe: ' + TComponent(aFormComponentesDesabilitados).ClassName;
      sErroInfo := sErroInfo + ' Nome: ' + TComponent(aFormComponentesDesabilitados).Name;
      if aRemove then
        TComponent(aFormComponentesDesabilitados).RemoveFreeNotification(aSender)
      else
        TComponent(aFormComponentesDesabilitados).FreeNotification(aSender);
      Result := True;
    end
    else
    begin
      {$IFDEF FIREMONKEY}
      if Supports(aFormComponentesDesabilitados, IFreeNotificationBehavior, LFreeNotificationBehavior)
        and Supports(aSender, IFreeNotification, LFreeNotification) then
      begin
        if aRemove then
          LFreeNotificationBehavior.RemoveFreeNotify(LFreeNotification)
        else
          LFreeNotificationBehavior.AddFreeNotify(LFreeNotification);
        Result := True;
      end;
      {$ENDIF FIREMONKEY}
    end;
  except
    on E: Exception do
    begin
      Assert(False, 'Erro ao remover forms desabilitados.' + #13 +
        sErroInfo + #13 + 'Erro: ' + e.message);
      Exit;
    end;
  end;
end;

{ TGerenciadorUnidades }

procedure TGerenciadorUnidades.Add(const aTipoTela: TTipoTela; const aIDUnidade: Integer; const Value: TComponent);
var
  LIDUnidade: Integer;
begin
  LIDUnidade := aIDUnidade;
  if (LIDUnidade < 0) then
    LIDUnidade := 0;
  if Assigned(Value) then
  begin
    Remove(aTipoTela, Value);
  end;

  while (Length(FListaForms[aTipoTela]) < (LIDUnidade + 1)) do
  begin
    SetLength(FListaForms[aTipoTela], Length(FListaForms[aTipoTela]) + 1);
    FListaForms[aTipoTela][Length(FListaForms[aTipoTela]) - 1] := nil;
  end;

  if (FListaForms[aTipoTela][LIDUnidade] <> Value) then
  begin
    if (FListaForms[aTipoTela][LIDUnidade] <> nil) then
    begin
      RemoveOrAddFreeNotify(Self, FListaForms[aTipoTela][LIDUnidade], True);
      FListaForms[aTipoTela][LIDUnidade] := nil;
    end;
    RemoveOrAddFreeNotify(Self, Value, False);
    FListaForms[aTipoTela][LIDUnidade] := Value;
  end;
  RemoveVazio(aTipoTela);
end;

procedure TGerenciadorUnidades.Add(const aTipoTela: TTipoTela; const Value: TComponent);
var
  LInterfaceUnidade: IInterfaceUnidade;
begin
  if Supports(Value, IInterfaceUnidade, LInterfaceUnidade) then
    Add(aTipoTela, LInterfaceUnidade.IDUnidade, Value)
  else
    Add(aTipoTela, Value.Tag, Value);
end;

constructor TGerenciadorUnidades.Create(AOwner: TComponent);
var
  I: Integer;
begin
  inherited;
  for I := Ord(Low(TTipoTela)) to Ord(High(TTipoTela)) do
  begin
    SetLength(FListaForms[TTipoTela(i)], 0);
  end;
end;

function TGerenciadorUnidades.GetObjetoGerenciado(const aTipoTela: TTipoTela; const aIdUnidade: Integer): TComponent;
var
  LIdUnidade: Integer;
begin
  Result := nil;
  LIdUnidade := aIdUnidade;
  if (LIdUnidade < 0) then
    LIdUnidade := 0;
  if (Length(FListaForms[aTipoTela]) > LIdUnidade) then
    Result := FListaForms[aTipoTela][LIdUnidade];
end;

procedure TGerenciadorUnidades.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = TOperation.opRemove) and Assigned(AComponent) then
    Remove(AComponent);
end;

procedure TGerenciadorUnidades.Remove(const aTipoTela: TTipoTela; const Value: TComponent);
var
  i: Integer;
begin
  if not Assigned(Value) then
    Exit;

  for i := 0 to Length(FListaForms[aTipoTela]) -1 do
  begin
    if FListaForms[aTipoTela, i] = Value then
    begin
      RemoveOrAddFreeNotify(Self, Value, True);
      FListaForms[aTipoTela, i] := nil;
      RemoveVazio(aTipoTela);
      Break;
    end;
  end;
end;

procedure TGerenciadorUnidades.Remove(const Value: TComponent);
var
  I: Integer;
begin
  for I := Ord(Low(TTipoTela)) to Ord(High(TTipoTela)) do
  begin
    Remove(TTipoTela(i), Value);
  end;
end;

procedure TGerenciadorUnidades.RemoveVazio(const aTipoTela: TTipoTela);
var
  i, NewLength: Integer;
begin
  NewLength := Length(FListaForms[aTipoTela]);
  for i := Length(FListaForms[aTipoTela]) -1 downto 0 do
  begin
    if Assigned(FListaForms[aTipoTela, i]) then
      Break
    else
      Dec(NewLength);
  end;
  SetLength(FListaForms[aTipoTela], NewLength);
end;

procedure TGerenciadorUnidades.Remove(const aTipoTela: TTipoTela; const aIdUnidade: Integer);
begin
  Add(aTipoTela, aIDUnidade, nil);
end;


procedure TListaFormComponentesDesabilitados.SetModoConexaoAtual(const aTipoConexao: TTipoConexao; const aIdUnidade: Integer; const Value: TNullBoolena);
var
  LFormComponentesDesabilitados: IFormComponentesDesabilitados;
begin
  while (Length(FModoConexaoAtual[aTipoConexao]) <= aIdUnidade) do
  begin
    SetLength(FModoConexaoAtual[aTipoConexao], Length(FModoConexaoAtual[aTipoConexao]) + 1);
    FModoConexaoAtual[aTipoConexao][Length(FModoConexaoAtual[aTipoConexao]) - 1] := tcNaoDefinido;
  end;

  if (FModoConexaoAtual[aTipoConexao, aIdUnidade] <> Value) then
  begin
    FModoConexaoAtual[aTipoConexao, aIdUnidade] := Value;
    for LFormComponentesDesabilitados in FLista do
    begin
      if Assigned(LFormComponentesDesabilitados) then
        LFormComponentesDesabilitados.ModoConexaoAtual[aTipoConexao, aIdUnidade] := Value;
    end;
  end;
end;

procedure TListaFormComponentesDesabilitados.Sincroniza(const Value: IFormComponentesDesabilitados);
var
  i, i2: Integer;
  LTipoConexao: TTipoConexao;
begin
  Exit;  //LBC NÃO SEI O QUE ISTO FAZ MAS APARENTEMENTE DEIXA A TELA VERMELHA E COM OS COMPONENTES DISABLED. TIRANDO, PORTANTO...

  for i2 := Ord(Low(TTipoConexao)) to Ord(High(TTipoConexao)) do
  begin
    LTipoConexao := TTipoConexao(i2);
    for i := Low(FModoConexaoAtual[LTipoConexao]) to High(FModoConexaoAtual[LTipoConexao]) do
    begin
      Value.ModoConexaoAtual[LTipoConexao, i] := FModoConexaoAtual[LTipoConexao][i];
    end;
  end;
end;

class function TGerenciadorUnidades.GetDescModulo(const aControler: TObject): String;
var
  LInterfaceUnidade: IInterfaceUnidade;
begin
  Result := '';
  if Assigned(aControler) then
  begin
    if Supports(aControler, IInterfaceUnidade, LInterfaceUnidade) then
      Result := 'ID Unidade: ' + IntToStr(LInterfaceUnidade.IDUnidade)
    else
    if ((aControler is TComponent) and Supports(TComponent(aControler).owner, IInterfaceUnidade, LInterfaceUnidade)) then
      Result := 'ID Unidade: ' + IntToStr(LInterfaceUnidade.IDUnidade);
  end;
end;

{ TTimerAnonimo }

constructor TTimerAnonimo.Create(AOwner: TComponent);
begin
  inherited;
  FProcedureOnTimer := nil;
  FSetDisableOnTimer := False;
end;

constructor TTimerAnonimo.Create(AOwner: TComponent; aProcedureOnTimerPA: TProcedureOnTimer; const aSetDisableOnTimer: BOolean;
  const aInterval: Integer);
begin
  create(aowner);
  FProcedureOnTimer := aProcedureOnTimerPA;
  Interval := aInterval;
  Enabled := False;
  FSetDisableOnTimer := aSetDisableOnTimer;
  OnTimer := HandleOnTimer;
end;

destructor TTimerAnonimo.Destroy;
begin

  inherited;
end;

procedure TTimerAnonimo.DoOnTimer;
begin
  inherited;
  if Assigned(FProcedureOnTimer) then
  begin
    Enabled := False;
    try
      if (not FProcedureOnTimer) then
        Enabled := True;
    finally
      if ((not FSetDisableOnTimer) and (not Enabled)) then
        Enabled := True;
    end;
  end;
end;

procedure TTimerAnonimo.HandleOnTimer(Sender: TObject);
begin

end;

initialization
  FListaFormComponentesDesabilitados := TListaFormComponentesDesabilitados.Create(nil);
  FGerenciadorUnidades := TGerenciadorUnidades.Create(nil);
  TLog.OnGetDescControl := TGerenciadorUnidades.GetDescModulo;

finalization
  FreeAndNil(FGerenciadorUnidades);
  FreeAndNil(FListaFormComponentesDesabilitados);
end.
