unit untCommonDMConnection;

// ****************************************************************************************************
// Analisar / Desenvolver ...
// ****************************************************************************************************
// 1 - verificar como e onde carrega as TAGs e implementar
// 2 - verificar a possibilidade de criar uma thread de conexão para substituir timer
// 3 - access violation ao fechar a main thread com a thread de comando em execução
// 4 - criar const para "----" ref. 3C
// 5 - rever 3E (Form PP)
// 6 - label click not work!


// ****************************************************************************************************
// LBC|GOT - Diretiva desligada para compatibilidade com string base 1
//
// ATENÇÃO: NÃO utilizar métodos da classe TStringHelper. Ex: Aux.Contains('xyz'),
// pois a diretiva é religada durante a compilação desta classe
// ****************************************************************************************************

{$ZEROBASEDSTRINGS OFF}

// ****************************************************************************************************

{$J+}

{$INCLUDE ..\AspDefineDiretivas.inc}
interface

uses
  {$IFDEF CompilarPara_PA_MULTIPA}
  untCommonFormBasePA, uConexaoBD,
  {$ENDIF}

  {$IF Defined(CompilarPara_TGS) or Defined(CompilarPara_Online)}
  untCommonFormBaseOnLineTGS,
  {$ENDIF}

  {$IFDEF CompilarPara_TGS}
  untMainForm, untCommonFormStyleBook, uConexaoBD,
  {$ENDIF}

  {$IFDEF ANDROID}FMX.Helpers.Android,{$ENDIF ANDROID}

  {$IF not Defined(CompilarPara_PA_MULTIPA) AND
       not Defined(CompilarPara_TOTEMTOUCH) AND
       not Defined(CompilarPara_TotemAA) AND
       not Defined(CompilarPara_TGSMOBILE)}
  untCommonFormBase,
  {$ENDIF}

  {$IFDEF CompilarPara_ONLINE}
  untSicsOnLine,  untCommonFrameSituacaoEspera,FMX.ListBox,
  {$ENDIF}

  {$IFDEF CompilarPara_SICSTV}
  SicsTV_m,
  {$ENDIF}

  System.SysUtils, System.Generics.Defaults, System.Generics.Collections, System.DateUtils,
  System.Classes, IdTCPConnection, IdTCPClient, FMX.Forms, FMX.StdCtrls,
  System.JSON, REST.JSON, ASpJson, FMX.Types, IdStack, FMX.Objects, Sics_Common_Parametros,
  IniFiles, FMX.Menus, System.StrUtils,
  Data.DB, System.Variants, FMX.Dialogs, System.Math, System.Types, MyAspFuncoesUteis,

  {$IF not Defined(CompilarPara_TotemAA) AND not Defined(CompilarPara_TGSMOBILE)}
  untCommonFrameBase,
  {$ENDIF}


  FMX.Layouts, IdGlobal, FMX.ExtCtrls, System.UITypes, IdBaseComponent,
  IdComponent, Datasnap.DBClient

  {$IF not Defined(CompilarPara_TotemAA)}
  , untCommonDMUnidades
  {$ENDIF}
  ;

const
  cDelay            = 0;
  cIdentiTCPSrvPort = 'TCPSrvPort';
  cIdentIdModulo    = 'IdModulo';
  cIdentTCPSrvAdr   = 'TCPSrvAdr';
  PONTO_E_VIRGULA   = ';';

type
  TConexao = (tcPrincipal, tcContingente);
  TDadosPessoasNasFilas = (dpfFila, dpfSenha, dpfNome, dpfProntuario, dpfHorario, dpfObservacao);

  TComandoEnvia = record
    Protocolo: string;
    IdUnidade: integer;
    Descricao: String;
    AguardaReceberComando: Boolean;
    Enviar: Boolean;
    procedure Inicializar(const aProtocolo: string; const aIdUnidade: integer; const aDescricao: String = ''; const aAguardaReceberComando: Boolean = True);
  end;

  TIdTCPClient = class(IdTCPClient.TIdTCPClient)
  public
    FPrimeiraVezConectouComServidor: Boolean;
    FUltimoProtocoloEnvio: Word;
    FJaConectou: Boolean;
    FDataPrimeiraTentativaConectar: TDateTime;

    procedure AfterConstruction; override;
  end;

  TDMConnection = class(TDataModule, IFreeNotification)
    ClientSocketPrincipal: TIdTCPClient;
    ClientSocketContingente: TIdTCPClient;
    procedure ClientSocketPrincipalConnected(Sender: TObject);
    procedure ClientSocketPrincipalDisconnected(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure tmrReconnectTimer(Sender: TObject);
    procedure tmrReceberComandoTimer(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);

  private
    tmrReceberComando  : TTimer;
    FIdUnidade         : Integer;
    FNomeUnidade: String;
    FIdModulo: Integer;
    //LProtRegistrosDataSeparado: TStringDynArray;
    //LProtFieldsDataSeparado: TStringDynArray;

    function GetIdUnidade: Integer;
    procedure SetIdUnidade(const Value: Integer);
    {$IFDEF CompilarPara_TGS}
    procedure PreencherNomesIndicadoresPermitidos;
    {$ENDIF}
  var
    ConexaoServidor: TConexao;
    FIniciouAtualizacao: Boolean;

    {$IFDEF CompilarPara_MULTIPA}
    procedure ColocaCorFundoMultiPA(i : Integer;pCor: TAlphaColor);
    {$ENDIF}
  public
    tmrReconnect: TTimer;
    ListaComando: TList<TComandoEnvia>;

    property IdUnidade: Integer read GetIdUnidade write SetIdUnidade;
    property NomeUnidade: String read FNomeUnidade;
    property IdModulo: Integer read FIdModulo;

    function ClienteSocketEstaConectado: Boolean;
    function SocketEmConflito(const aPorta: Word; const aHost: String; aUniqueClientSocketAtivo: TObject): Boolean;
    class function GetInstancia(const aIDUnidade: integer; const aAllowNewInstance: Boolean; const aOwner: TComponent = nil): TDMConnection;
    constructor Create(AOwner: TComponent); overload; override;
    constructor Create(AOwner: TComponent; const aIdUnidade: Integer); overload;
    destructor Destroy; Override;
    procedure CarregarParametros; Virtual;
    procedure DisconnectaOutrosSockets(const aUniqueClientSocketAtivo: TIdTCPClient);
    procedure Notification(AComponent: TComponent; Operation: TOperation); Override;
    procedure FreeNotification(AObject: TObject); Virtual;

    procedure ConfiguraClienteAposCarregarPA(const aIdUnidade: Integer);
    procedure ConfiguraClienteAposCarregarAtend(const aIdUnidade: Integer);
    function EnviaComandosPendentes: Boolean;
    function EnviarComando(const Protocolo: string; const aIdUnidade: integer; const ADescricao: String = ''; const aAguardaReceberComando: Boolean = True;
      const aPersistirEnvioPosteriormente: Boolean = True): Boolean;

    function GetSocket: TIdTCPClient;
    function ReceberComando: Boolean; Overload; virtual;
    function ReceberComando(const aIDUnidade: Integer): Boolean; Overload; virtual;

    function Reconnectar: Boolean; Overload; virtual;
    function Reconnectar(const aIDUnidade: Integer): Boolean; Overload; virtual;

    function ValidarPA(const PA: integer; const aIDUnidade: Integer): Boolean;

    procedure Redirecionar(const PA, Fila, aIdUnidade: Integer);
    procedure Redirecionar_Proximo(const PA, Fila, aIdUnidade: Integer);
    procedure Redirecionar_Especifica(const PA, Fila, Senha, aIdUnidade: Integer);
    procedure Redirecionar_ForcarChamada(const PA, Fila, Senha, aIdUnidade: Integer);
    procedure RedirecionarPelaSenha(const Senha, Fila, aIdUnidade: Integer);
    procedure Proximo(const PA, aIdUnidade: Integer);
    procedure Rechamar(const PA, aIdUnidade: Integer);
    procedure Finalizar(const PA, aIdUnidade: Integer);
    procedure ChamarEspecifica(const PA, Senha, aIdUnidade: Integer);
    procedure ForcarChamada(const PA, Senha, aIdUnidade: Integer);
    procedure FinalizarPelaSenha(const Senha, aIdUnidade: Integer);
    procedure InserirSenhaFila(const Senha, Fila: Integer);

    procedure DefinirNomeCliente(const PA, Senha: integer; const Nome: string; const aIdUnidade: Integer);
    procedure DefinirDadoAdicionalNomeCliente(const PA, Senha: integer; const Nome: string; const aIdUnidade: Integer);
    procedure DefinirTag(const PA, Senha, aTag, aIdUnidade: Integer);
    procedure DesassociarTag(const PA, Senha, aTag: integer; const aIdUnidade: Integer);
    procedure SolicitarNomeCliente(const PA: integer; const Senha: string; const aIdUnidade: Integer);
    procedure SolicitarTAGs(PA: integer; Senha: string; const aIdUnidade: Integer);
    procedure SolicitarAgendamentosFilas(const PA: integer; const Senha: string; const aIdUnidade: Integer);
    procedure SolicitarDadosAdicionais(const PA: integer; const Senha: string; const aIdUnidade: Integer);

    procedure VerificarLogin(const PA: integer; const AtdLogin, Senha: string; const aIdUnidade: Integer);

    function DecifrarProtocolo(S: string; Socket: TIdTCPClient; const aIdUnidade: Integer): Boolean;
    procedure IniciarAtualizacao(const aIdUnidade: Integer);
    procedure DecifrarCodigoBarra(const S: string; const aIdUnidade: Integer);

    procedure SolicitarSituacaoPA(const PA: integer; const aIdUnidade: Integer);
    procedure ClienteModoDesconectado;
    procedure ClienteValidaModoConexao;
    procedure ClienteModoConectado;
    {$IFDEF CompilarPara_PA}
    procedure GravaNoINI(PA : string );
    {$ENDIF}
    procedure AfterConstruction; override;
  end;

const
  cProtocoloPAVazia = 'FFFF';
  IPLocalhost = '127.0.0.1';

  SemSenha        = '---';
  SemAtendente    = SemSenha;
  SemPA           = SemSenha;
  SemNomeCliente  = SemSenha;


  // ****************************************************************************************************
  // inicialização da constante 'vgModulo' de acordo com o projeto compilado
  // ****************************************************************************************************

  cgTipoModulo: TModuloSics = {$IF Defined(CompilarPara_PA)          }
                                msPA
                              {$ELSEIF Defined(CompilarPara_MULTIPA) }
                                msMPA
                              {$ELSEIF Defined(CompilarPara_TGS)     }
                                msTGS
                              {$ELSEIF Defined(CompilarPara_ONLINE)  }
                                msOnLine
                              {$ELSEIF Defined(CompilarPara_SICSTV)  }
                                msTV
                              {$ELSEIF Defined(CompilarPara_CALLCENTER)  }
                                msCallCenter
                              {$ELSEIF Defined(CompilarPara_TOTEMTOUCH)  }
                                msTotemTouch
                              {$ELSE}
                                msNone
                              {$ENDIF};

function DMConnection(const aIDUnidade: integer; const aAllowNewInstance: Boolean; const aOwner: TComponent = nil): TDMConnection;

function EstaPreenchidoCampo(const aValorCampo: string): Boolean;
function GetEncondeProtocoloEhValido(const aProtocolo: String): Boolean;
procedure ExtrairVersaoNoProtocolo(var aProtocolo: String; out aVersaoProtocolo: Integer);
procedure ExtrairProtDataNoProtocolo(const aProtocolo: String; out aProtData: String; var aComando: Integer);
function AlterouStatusPA(aPA: integer; Anterior, Atual: string): Boolean;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

uses
  {$IF (not Defined(CompilarPara_SICSTV    )) and
       (not Defined(CompilarPara_CALLCENTER)) and
       (not Defined(CompilarPara_TOTEMTOUCH)) and
       (not Defined(CompilarPara_TotemAA))    and
       (not Defined(CompilarPara_TGSMOBILE))
       }
  untCommonFormSelecaoPP,
  untCommonFormSelecaoMotivoPausa,
  untCommonFormProcessoParalelo,
  {$ENDIF}

{$IFDEF CompilarPara_TGS}
  ufrmLines,
  untCommonFormSelecaoGrupoAtendente,
{$ENDIF CompilarPara_TGS}

{$IFDEF CompilarPara_TGS_ONLINE}
  untCommonFrameIndicadorPerformance,
  untCommonFrameSituacaoAtendimento,
{$ENDIF CompilarPara_TGS_ONLINE}

{$IFDEF CompilarPara_ONLINE}
  untCommonFormDadosAdicionais,
{$ENDIF CompilarPara_ONLINE}

{$IFDEF CompilarPara_PA_MULTIPA}
  untCommonFormDadosAdicionais,
  untCommonFormLogin,
  untCommonFormSelecaoFila,
  untCommonFormControleRemoto,
{$ENDIF CompilarPara_PA_MULTIPA}

{$IFDEF CompilarPara_CALLCENTER}
  untSicsCallCenter,untCommonFormSelecaoFila, untCommonFormLogin,
  uCallCenterConsts, untLoginGestor,
{$ENDIF CompilarPara_CALLCENTER}
  untLog,
  untCommonDMClient,

 {$IF not Defined(CompilarPara_TOTEMTOUCH) AND not Defined(CompilarPara_TGSMOBILE)}
  untFrmConfigParametros,
 {$ENDIF}

  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.DBX.Migrate

 {$IF not Defined(CompilarPara_TV) AND not Defined(CompilarPara_TotemAA) AND not Defined(CompilarPara_ONLINE) AND not Defined(CompilarPara_TGSMOBILE),
  untCommonFormDadosAdicionais,
  untCommonFormDadosAdicionais}
  , uDataSetHelper
  {$ENDIF};

function DMConnection(const aIDUnidade: integer; const aAllowNewInstance: Boolean; const aOwner: TComponent): TDMConnection;
begin
  Result := TDMConnection(TDMConnection.GetInstancia(aIDUnidade, aAllowNewInstance, aOwner));
end;

{ TDMClientConnection }

function TDMConnection.GetIdUnidade: Integer;
begin
  Result := FIdUnidade;
end;

class function TDMConnection.GetInstancia(const aIDUnidade: integer;
  const aAllowNewInstance: Boolean; const aOwner: TComponent): TDMConnection;
var
  LOwner: TComponent;
begin
  if TDMConnection(GetApplication.FindComponent(ClassName + inttostr(aIDUnidade))) =  nil then begin
    if (aIDUnidade >= 0) and (aAllowNewInstance) then
    begin
      LOwner := aOwner;
      if not Assigned(LOwner) then
        LOwner := GetApplication;
      Result := Self.Create(LOwner, aIDUnidade);
      Result.Name := ClassName + inttostr(aIdUnidade);
    end;
  end else begin
  {$IF Defined(CompilarParaTGS)}
    Sleep(1000);
  {$ENDIF}
    Result := TDMConnection(GetApplication.FindComponent(ClassName + inttostr(aIDUnidade)));
  end;
end;

constructor TDMConnection.Create(AOwner: TComponent; const aIdUnidade: Integer);
begin
  Create(AOwner);
  IdUnidade := aIdUnidade;
end;

function EstaPreenchidoCampo(const aValorCampo: string): Boolean;
begin
  Result := (aValorCampo <> SemSenha) and (Trim(aValorCampo) <> '') and (aValorCampo <> '???');
end;

procedure TDMConnection.ClienteModoConectado;
var
  i : integer;
  layout : TLayout;
  LChildren: TFMxObject;
  LMenuBar: TMenuBar;
  LForm: TComponent;
begin
  for i := 0 to GetApplication.ComponentCount - 1 do
    if GetApplication.Components[i] is TForm then
    begin
      LForm := GetApplication.Components[i];
      if LForm is TTipoFormClient then
        if TTipoFormClient(LForm).IDUnidade <> IdUnidade then
          continue;

      if (GetApplication.Components[i] is TTipoFormClient)then
         (GetApplication.Components[i] as TTipoFormClient).ModoConectado(IdUnidade);

      layout :=((GetApplication.Components[i] as TForm).FindComponent('layFila') as TLayout);
      if layout <> nil then
      begin
        if ((layout.FindComponent('rectFundo'))  <> nil ) then
            (layout.FindComponent('rectFundo') as TRectangle).Fill.Color := CorConectado;
      end;

      layout := ((GetApplication.Components[i] as TForm).FindComponent('lytFundo') as TLayout);
      if (layout <> nil ) then
      begin
        layout.SendToBack;
        {$IFDEF IS_MOBILE}layout.Visible := False;{$ENDIF}
        if (layout.ChildrenCount > 0)then
          for LChildren in layout.Children do
          begin
            if(LChildren is TRectangle)then
            begin
              TRectangle(LChildren).Fill.Color := CorConectado;
            end;
          end;
      end;

      {$IFDEF CompilarPara_PA_MULTIPA}
      LMenuBar := ((GetApplication.Components[i] as TForm).FindComponent(TFrmBase_PA_MPA.cmnuBar) as TMenuBar);
      if Assigned(LMenuBar) then
        LMenuBar.Enabled := True;
      {$ENDIF}

      {$IFDEF CompilarPara_MULTIPA}
      ColocaCorFundoMultiPA(i,CorConectado);
      {$ENDIF CompilarPara_MULTIPA}

      {$IFDEF CompilarPara_TGS}
      if Assigned(MainForm) and dmUnidades.AlgumaConectada then
        MainForm.desabilitaBotoes(true);

      if LForm is TFrmBase then
        TFrmBase(LForm).ModoConectado(IdUnidade);
      {$ENDIF CompilarPara_TGS}

      {$IFDEF CompilarPara_Online}
        if Assigned(FrmSicsOnLine) and dmUnidades.AlgumaConectada then
        begin
          FrmSicsOnLine.desabilitaBotoes(true);
          FrmSicsOnLine.AbrirTelaPadrao;
        end;
      {$ENDIF CompilarPara_ONLINE}
    end;
end;

procedure TDMConnection.ClienteModoDesconectado;
var
  i : integer;
  layout : TLayout;
  LChildren: TFMxObject;
  LMenuBar: TMenuBar;
  classParente : TClass;
  LForm: TComponent;
begin
  for i := 0 to GetApplication.ComponentCount - 1 do
    if GetApplication.Components[i] is TForm then
    begin
      LForm := GetApplication.Components[i];
      if LForm is TTipoFormClient then
        if TTipoFormClient(LForm).IDUnidade <> IdUnidade then
          continue;

      if((GetApplication.Components[i] as TForm).FindComponent('rectFundo') <> nil)then
      begin
        ((GetApplication.Components[i] as TForm).FindComponent('rectFundo') as TRectangle).Fill.Color := CorDesconectado;
      end;

      layout := ((GetApplication.Components[i] as TForm).FindComponent('lytFundo') as TLayout);
      if layout <> nil then
      begin
        {$IFDEF IS_MOBILE}layout.Visible := True;{$ENDIF}
        layout.BringToFront;
        if (layout.ChildrenCount > 0) then
        begin
          for LChildren in layout.Children do
          begin
            if(LChildren is TRectangle)then
            begin
              TRectangle(LChildren).Fill.Color := CorDesconectado;
            end;
          end;
        end;

        {$IFDEF CompilarPara_PA_MULTIPA}
        LMenuBar := ((GetApplication.Components[i] as TForm).FindComponent(TFrmBase_PA_MPA.cmnuBar) as TMenuBar);
        if Assigned(LMenuBar) then
          LMenuBar.Enabled := False;
        {$ENDIF}

        //BAH esconder o frame quando o sics online estiver desconectado do servidor
        {$IFDEF CompilarPara_Online}
        layout := ((GetApplication.Components[i] as TForm).FindComponent('lytFundo') as TLayout);
        for LChildren in layout.Children do
        begin
            if(LChildren is TFrame)then
            begin
              TFrameBase(LChildren).Visible := False;
            end;
        end;
        {$ENDIF CompilarPara_ONLINE}

        {$IFDEF CompilarPara_MULTIPA}
        ColocaCorFundoMultiPA(i,CorDesconectado);
        {$ENDIF CompilarPara_MULTIPA}

        {$IFDEF CompilarPara_TOTEMTOUCH}
        dmUnidades.FormClient.ModoDesconectado(IdUnidade);
        {$ENDIF}
      end;

      {$IFNDEF CompilarPara_TOTEMTOUCH}
      layout := ((GetApplication.Components[i] as TForm).FindComponent('layFila') as TLayout);
      if((layout <> nil) and (layout.ChildrenCount > 0) )then
      begin
        for LChildren in layout.Children do
        begin
            if(LChildren is TRectangle)then
            begin
              TRectangle(LChildren).Fill.Color := CorDesconectado;
            end;
        end;
      end;
      {$ENDIF}

      {$IFDEF CompilarPara_TGS}
      if Assigned(MainForm) and dmUnidades.NenhumaConectada then
        MainForm.desabilitaBotoes(false);
      {$ENDIF CompilarPara_TGS}
      //BAH desabilita o list box do menu quando o Online estiver desconectado do servidor
      {$IFDEF CompilarPara_Online}
      if Assigned(FrmSicsOnLine) and dmUnidades.NenhumaConectada then
        FrmSicsOnLine.desabilitaBotoes(false);
      {$ENDIF CompilarPara_ONLINE}
    end;
end;

function TDMConnection.ClienteSocketEstaConectado: Boolean;
begin
  Result := False;
  ClientSocketPrincipal.CheckForGracefulDisconnect(False);
  Result := ClientSocketPrincipal.Connected;

  if not Result then
  begin
    ClientSocketContingente.CheckForGracefulDisconnect(False);
    Result := ClientSocketContingente.Connected;
  end;
end;

procedure TDMConnection.ClienteValidaModoConexao;
var
  LDMClient: TDMClient;
begin
  try
    if ClienteSocketEstaConectado then
    begin
      dmUnidades.Conectada[IdUnidade] := True;
      ClienteModoConectado
    end
    else
    begin
      dmUnidades.Conectada[IdUnidade] := False;
      ClienteModoDesconectado;
    end;
  except
    on E: Exception do
    begin
      TLog.TreatException('Erro ao validar modo conexão', Self, e);
      Exit;
    end;
  end;
end;

procedure TDMConnection.ClientSocketPrincipalConnected(Sender: TObject);
var
  LIdUnidade     : integer;
  CharTipoModulo: Char;
  LgIdDoModulo  : string;
  TimeOut       : TDateTime;

{$IFDEF CompilarPara_ONLINE}

  I: integer;

{$ENDIF CompilarPara_ONLINE}
  LDMCLient: TDMClient;
  LIdTCPClient: TIdTCPClient;
  {$IF (not Defined(CompilarPara_SICSTV)) and (not Defined(CompilarPara_TGS))}
  //LBC VERIFICAR LParametrosModuloUnidade: TParametrosModuloUnidade;
  {$ENDIF}
  {$IFDEF CompilarPara_PA_MULTIPA}
  LBeginUpdatePA: Boolean;
  LListaPa: TIntegerDynArray;
  {$ENDIF CompilarPara_PA_MULTIPA}
begin
  LgIdDoModulo := TAspEncode.AspIntToHex(FIdModulo, 4);
  TLog.MyLog('ClientSocketPrincipalConnected', Sender, 0, false, TCriticalLog.tlINFO);

  if Sender = ClientSocketContingente then
    ConexaoServidor := tcContingente
  else
    ConexaoServidor := tcPrincipal;

  LIdTCPClient := (Sender as TIdTCPClient);
  DisconnectaOutrosSockets(LIdTCPClient);
  try
    LIdUnidade := IdUnidade;
    try
      try
        tmrReceberComando.Enabled                        := True;
        if LIdTCPClient.FPrimeiraVezConectouComServidor then
        begin
          LIdTCPClient.FPrimeiraVezConectouComServidor := False;
        end;
        IniciarAtualizacao(LIdUnidade);

        {$IFDEF CompilarPara_TGS_ONLINE}

//*** agora que os forms auto-create são criados pelo dmUnidades, pode ser que
//um DMConnection tenha sido criado e conectado ao servidor antes que os forms
//auto-create estejam instanciados
//        if (FraSituacaoAtendimento(LIdUnidade, not CRIAR_SE_NAO_EXISTIR) = nil) then
//        begin
//          Assert(LIdUnidade = ID_UNIDADE_PADRAO, 'Unidade não foi configurada!');
//          Exit;
//        end;

        {$ENDIF CompilarPara_TGS_ONLINE}

        LIdTCPClient.IOHandler.DefStringEncoding := IndyTextEncoding_8Bit;

        // ****************************************************************************************************
        // execução da thread de recebimento de comando
        // ****************************************************************************************************
        // ExecuteThread(ReceberComando);

        tmrReconnect.Enabled := True;
        // ****************************************************************************************************
        // obtém parâmetros do módulo
        // ****************************************************************************************************

        if not vgParametrosModulo.JaEstaConfigurado then
        begin
          case cgTipoModulo of
            msPA         : CharTipoModulo := Chr($50); //P
            msMPA        : CharTipoModulo := Chr($4D); //M
            msTV         : CharTipoModulo := Chr($56); //V
            msOnLine     : CharTipoModulo := Chr($4F); //O
            msTGS        : CharTipoModulo := Chr($54); //T
            msCallCenter : CharTipoModulo := Chr($43); //C
            msTotemTouch : CharTipoModulo := Chr($48); //H
            else raise TAspException.create(Self, 'Tipo módulo não encontrado.');
          end;

          EnviarComando(TAspEncode.AspIntToHex(0, 4) + Chr($8C) + CharTipoModulo + LgIdDoModulo, LIdUnidade, 'obtém parâmetros do módulo');

          //***TLog.MyLog('DEBUG - Enviou comando de obter configurações do módulo', Self);

          // aguardar o recebimento dos parâmetros pois disto depende alguns comandos abaixo
          TimeOut := Now + EncodeTime(0, 0, 30, 0);

          GetApplication.ProcessMessages;
          while ((not GetApplication.Terminated) and (not vgParametrosModulo.JaEstaConfigurado) and (Now < TimeOut)) do
          begin
            ReceberComando;
            GetApplication.ProcessMessages;
            Sleep(100);
          end;

          //***TLog.MyLog('DEBUG - Passou do timeout', Self);

          if GetApplication.Terminated then
            Exit;

          if not vgParametrosModulo.JaEstaConfigurado then
            raise TAspException.create(Self, 'Erro ao configurar parâmetros do módulo.');
        end;

        {$IFDEF CompilarPara_PA_MULTIPA}
        LBeginUpdatePA := Assigned(dmUnidades.FormClient) and dmUnidades.FormClient.BeginUpdatePA(LListaPa);

        {$IFDEF CompilarPara_PA}
        if Assigned(dmUnidades.FormClient) then
          dmUnidades.FormClient.MostraEscondeBotaoAbrirFecharPessoasNasFilasPA;
        {$ENDIF}
        {$ENDIF}

        try
          // ****************************************************************************************************
          // obtém status de pausas
          // ****************************************************************************************************
          LDMCLient := DMClient(LIdUnidade, not CRIAR_SE_NAO_EXISTIR);

          {$IFDEF CompilarPara_PA_MULTIPA}
          if Assigned(dmUnidades.FormClient) then
            dmUnidades.FormClient.bndPessoasNasFilas.DataSet := LDMCLient.cdsPessoasFilaEsperaPA;
          {$ENDIF}

          {$IF Defined(CompilarPara_TGS) or Defined(CompilarPara_Online)}
          if (not LDMClient.ConfiguradoStatusPA) then
          begin
            EnviarComando('0000' + Chr($2A), LIdUnidade, 'obtém status de pausas');
          end;
          {$ENDIF}

          // ****************************************************************************************************
          // obtém grupos de atendentes
          // ****************************************************************************************************
          EnviarComando(LgIdDoModulo + Chr($78) + 'A', LIdUnidade, 'obtém grupos de atendentes');

          // ****************************************************************************************************
          // obtém grupos de PAs
          // ****************************************************************************************************
          EnviarComando(LgIdDoModulo + Chr($78) + 'P', LIdUnidade, 'obtém grupos de PAs');

          // ****************************************************************************************************
          // obtém grupos de TAGs
          // ****************************************************************************************************
          if not LDMCLient.ConfiguradoGrupoTAG then
          begin
            EnviarComando(LgIdDoModulo + Chr($78) + 'T', LIdUnidade, 'obtém grupos de TAGs');
          end;

          // ****************************************************************************************************
          // exceto módulo TV
          // ****************************************************************************************************
          {$IFNDEF CompilarPara_SICSTV}
         // if (cgTipoModulo <> msTV) then
          begin
            // obtém grupos de PPs
            if

        {$IFDEF CompilarPara_PA_MULTIPA}

              vgParametrosModulo.VisualizarProcessosParalelos and

        {$ENDIF CompilarPara_PA_MULTIPA}

              (not LDMCLient.ConfiguradoGrupoPP) then
            begin
              EnviarComando(LgIdDoModulo + Chr($78) + 'p', LIdUnidade);
            end;

            // obtém grupos de motivos de pausa
            if {$IFDEF CompilarPara_PA_MULTIPA}

              (vgParametrosModulo.MostrarBotaoPausa or vgParametrosModulo.MostrarMenuPausa) and

        {$ENDIF CompilarPara_PA_MULTIPA}

              (not LDMCLient.ConfiguradoGrupoMotivoPausa) then
            begin
              EnviarComando(LgIdDoModulo + Chr($78) + 'M', LIdUnidade);
            end;
          end;
          {$ENDIF CompilarPara_SICSTV}

          // ****************************************************************************************************
          // obtém filas
          // ****************************************************************************************************
          EnviarComando(LgIdDoModulo + Chr($7B), LIdUnidade);

          // ****************************************************************************************************
          // obtém TAGs
          // ****************************************************************************************************
          if not LDMCLient.ConfiguradoTAG then
            EnviarComando(LgIdDoModulo + Chr($7F), LIdUnidade);

          {$IF (not Defined(CompilarPara_SICSTV)) and (not Defined(CompilarPara_TGS))}
//LBC VERIFICAR          LParametrosModuloUnidade := ParametrosModuloPorUnidade(LIdUnidade);
          {$ENDIF}

        {$IFDEF CompilarPara_ONLINE}

          for I := 1 to vgParametrosModulo.MaiorFilaCadastrada do
          begin
            if FraSituacaoEspera(LIdUnidade).ExisteAFila(I) then
            begin
              EnviarComando(LgIdDoModulo + Chr($4A) + IntToHex(I, 4), LIdUnidade);
              GetApplication.ProcessMessages;
            end;
          end;
          EnviarComando(cProtocoloPAVazia + Chr($58) , IdUnidade);
        {$ENDIF CompilarPara_ONLINE}

          // ****************************************************************************************************
          // exceto módulo TV
          // ****************************************************************************************************

          {$IFNDEF CompilarPara_SICSTV}
          begin
          {$IFNDEF CompilarPara_TGS} //BAH colocado esta condição a baixo por conta do bug #35 que pediu para retirar o campo GRUPOS_DE_PPS_PERMITIDOS das configurações do TGS
            // obtém PPs
            if

        {$IFDEF CompilarPara_PA_MULTIPA}

//LBC VERIFICAR              LParametrosModuloUnidade.VisualizarProcessosParalelos and

        {$ENDIF CompilarPara_PA_MULTIPA}

              (not LDMCLient.ConfiguradoPP) then
            begin
              EnviarComando( LgIdDoModulo + Chr($3F), LIdUnidade);
            end;
        {$ENDIF CompilarPara_TGS}

            // obtém motivos de pausa
            if

        {$IFDEF CompilarPara_PA_MULTIPA}

              (vgParametrosModulo.MostrarBotaoPausa or vgParametrosModulo.MostrarMenuPausa) and

        {$ENDIF CompilarPara_PA_MULTIPA}

              (not LDMCLient.ConfiguradoMotivoPausa) then
            begin
              EnviarComando(LgIdDoModulo + Chr($41), LIdUnidade);
            end;
          end;
          {$ENDIF CompilarPara_SICSTV}

          // ****************************************************************************************************
          // Tabela de Atendentes e PAs carregadas via Query
          // ****************************************************************************************************
          if DMClient(LIdUnidade, not CRIAR_SE_NAO_EXISTIR).ClientConectarViaDB then
          begin
            DMClient(LIdUnidade, not CRIAR_SE_NAO_EXISTIR).CarregarParametrosViaDB;
          end
          else
          begin

            // ****************************************************************************************************
            // obtém atendentes
            // ****************************************************************************************************
            EnviarComando(LgIdDoModulo + Chr($71), LIdUnidade);

            // ****************************************************************************************************
            // obtém PAs
            // ****************************************************************************************************
            EnviarComando(LgIdDoModulo + Chr($3D), LIdUnidade);
          end;

        {$IFDEF CompilarPara_PA_MULTIPA}

          // ****************************************************************************************************
          // obtém qtde de senhas em espera
          // ****************************************************************************************************
          EnviarComando('0000' + Chr($36), LIdUnidade);

        {$ENDIF CompilarPara_PA_MULTIPA}

        {$IFDEF CompilarPara_TGS}
          if dmUnidades.Quantidade > 1 then
            EnviarComando(cProtocoloPAVazia + Chr($66), LIdUnidade);
        {$ENDIF}

          EnviaComandosPendentes;
        finally
          {$IFDEF CompilarPara_PA_MULTIPA}
          if LBeginUpdatePA then
            dmUnidades.FormClient.EndUpdatePA(LListaPa);
          {$ENDIF CompilarPara_PA_MULTIPA}
        end;
      finally
        ClienteValidaModoConexao;
      end;
    finally
      {$IFDEF CompilarPara_PA_MULTIPA}
      if dmUnidades.FormClient <> nil then
        dmUnidades.FormClient.ClienteConfigurado;
      {$ENDIF CompilarPara_PA_MULTIPA}
    end;
  except
    on E: Exception do
    begin
      e.Message := 'Erro ao configurar o servidor.' + #13 + e.Message;
      MyLogException(E);
      (Sender as TIdTCPClient).Disconnect;
      raise;
    end;
  end;
end;

procedure TDMConnection.ClientSocketPrincipalDisconnected(Sender: TObject);
begin
  TLog.MyLog('ClientSocketPrincipalDisconnected', Sender, 0, false, TCriticalLog.tlINFO);
  tmrReceberComando.Enabled := not ClienteSocketEstaConectado;
  if Assigned(Sender) then
    ClienteValidaModoConexao;
end;

{$IFDEF CompilarPara_MULTIPA}
procedure TDMConnection.ColocaCorFundoMultiPA(i : Integer;pCor: TAlphaColor);
var
  layout                                           :  TLayout;
  LChildren, LChildrenScroll, Children1, Children2 : TFmxObject;
begin
  //BAH feito para pegar o retangulo e colorir para a cor desejada
  try
    layout := ((GetApplication.Components[i] as TForm).FindComponent('lytFundo') as TLayout);
    if((layout <> nil) and (layout is TLayout) and (layout.Children <> nil))then
    begin
      for LChildren in layout.Children do
      begin
        if(LChildren is TFramedScrollBox)then
        begin
          for LChildrenScroll in TFramedScrollBox(LChildren).Children do
          begin
            for Children1 in TFmxObject(LChildren).Children do
            begin
              if(TFmxObject(Children1) <> nil)then
              begin
                for Children2 in TFmxObject(Children1).Children do
                  if(Children2 is TRectangle)then
                    TRectangle(Children2).Fill.Color := pCor;
              end;
            end;
          end;
        end;
      end;
    end;
  Except
       {DO NOTHING}
  end;
end;
{$ENDIF CompilarPara_MULTIPA}

procedure TDMConnection.ConfiguraClienteAposCarregarAtend(const aIdUnidade: Integer);
{$IF ( ((not Defined(CompilarPara_SICSTV)) and
        (not Defined(CompilarPara_CALLCENTER)) and
        (not Defined(CompilarPara_TOTEMTOUCH))) or Defined(CompilarPara_TGS_ONLINE))}
var
  {$IF ( ((not Defined(CompilarPara_SICSTV)) and  (not Defined(CompilarPara_CALLCENTER))) or Defined(CompilarPara_TGS_ONLINE))}
  LFrmProcessoParalelo: TFrmProcessoParalelo;
  {$ENDIF}

  {$IFDEF CompilarPara_TGS_ONLINE}
  LFrmSituacaoAtendimento: TFraSituacaoAtendimento;
  {$ENDIF CompilarPara_TGS_ONLINE}
{$ENDIF}
begin
  {$IF ((not Defined(CompilarPara_SICSTV)) and (not Defined(CompilarPara_CALLCENTER)) and (not Defined(CompilarPara_TOTEMTOUCH))) }
  LFrmProcessoParalelo := FrmProcessoParalelo(aIdUnidade);
  if Assigned(LFrmProcessoParalelo) then
    LFrmProcessoParalelo.AtualizaLookUps;
  {$ENDIF}

  {$IFDEF CompilarPara_TGS_ONLINE}
  LFrmSituacaoAtendimento := FraSituacaoAtendimento(aIdUnidade);
  if Assigned(LFrmSituacaoAtendimento) then
    LFrmSituacaoAtendimento.AtualizaListaDeAtendentes;
  {$ENDIF CompilarPara_TGS_ONLINE}
end;

procedure TDMConnection.ConfiguraClienteAposCarregarPA(const aIdUnidade: Integer);
var
  {$IF ((not Defined(CompilarPara_SICSTV)) and  (not Defined(CompilarPara_CALLCENTER)) and (not Defined(CompilarPara_TOTEMTOUCH)))}
  LFrmProcessoParalelo: TFrmProcessoParalelo;
  {$ENDIF}

  LDMClient: TDMClient;

  {$IFDEF CompilarPara_TGS_ONLINE}
  LFrmSituacaoAtendimento: TFraSituacaoAtendimento;
  {$ENDIF CompilarPara_TGS_ONLINE}


//LBC VERIFICAR  {$IFNDEF CompilarPara_SICSTV}
//LBC VERIFICAR  procedure DefineGrupoPAPermitidas;
//LBC VERIFICAR  var
//LBC VERIFICAR    LParametrosModuloUnidade: TParametrosModuloUnidade;
//LBC VERIFICAR  begin
//LBC VERIFICAR    LParametrosModuloUnidade := ParametrosModuloPorUnidade(aIdUnidade);
//LBC VERIFICAR    SetLength(LParametrosModuloUnidade.GruposDePasPermitidas, LDMClient.cdsPAs.RecordCount);
//LBC VERIFICAR    LDMClient.cdsPAs.First;
//LBC VERIFICAR    while not LDMClient.cdsPAs.Eof do
//LBC VERIFICAR    begin
//LBC VERIFICAR      LParametrosModuloUnidade.GruposDePasPermitidas[LDMClient.cdsPAs.RecNo-1] := LDMClient.cdsPAsID.AsInteger;
//LBC VERIFICAR      LDMClient.cdsPAs.Next;
//LBC VERIFICAR    end;
//LBC VERIFICAR  end;
//LBC VERIFICAR  {$ENDIF CompilarPara_SICSTV}

  procedure UpdatePAStatus;
  begin
    {$IFDEF CompilarPara_MULTIPA}
    try
      if Assigned(dmUnidades.FormClient) then
      begin
        if Assigned(LDMClient) then
        begin
          LDMClient.cdsPAs.First;
          while not LDMClient.cdsPAs.eof do
          begin
            dmUnidades.FormClient.UpdatePAStatus(LDMClient.cdsPAsID.AsInteger);
            LDMClient.cdsPAs.Next;
          end;
        end;
      end;
    except
      TLog.MyLog('Erro ao atualizar PA status.', Self);
      Exit;
    end;
    {$ENDIF}
  end;
begin
  try
    LDMClient := DMClient(aIdUnidade, not CRIAR_SE_NAO_EXISTIR);
    if not Assigned(LDMClient) then
      Exit;

//LBC VERIFICAR    {$IFNDEF CompilarPara_SICSTV}
//LBC VERIFICAR    DefineGrupoPAPermitidas;
//LBC VERIFICAR    {$ENDIF CompilarPara_SICSTV}

    {$IFDEF CompilarPara_MULTIPA}
    if Assigned(dmUnidades.FormClient) then
    begin
      dmUnidades.FormClient.CriarGruposPAs;
      dmUnidades.FormClient.CriarPAs;
      dmUnidades.FormClient.CriarTAGs;
    end;
    {$ENDIF}

    {$IF ((not Defined(CompilarPara_SICSTV)) and (not Defined(CompilarPara_CALLCENTER)) and (not Defined(CompilarPara_TOTEMTOUCH)))}
    try
      LFrmProcessoParalelo := FrmProcessoParalelo(aIdUnidade);
      if Assigned(LFrmProcessoParalelo) then
        LFrmProcessoParalelo.AtualizaLookUps;
    except
      TLog.MyLog('Erro ao atualizar processos paralelos.', Self);
    end;
    {$ENDIF}

    UpdatePAStatus;

    {$IFDEF CompilarPara_PA_MULTIPA}
    FrmLogin(aIdUnidade).AtualizarComboPA;
    {$ENDIF}

    {$IFDEF CompilarPara_TGS_ONLINE}
    LFrmSituacaoAtendimento := FraSituacaoAtendimento(aIdUnidade);
    if Assigned(LFrmSituacaoAtendimento) then
      LFrmSituacaoAtendimento.AtualizaListaDePAs;

    SolicitarSituacaoPA(0, aIdUnidade); // Removido código módulo para servidor retornar a situação de todas as PAs
    {$ENDIF CompilarPara_TGS_ONLINE}

    LDMCLient.ConfiguradoPA := True;

  except
    TLog.MyLog('Erro ao configurar cliente por PA', Self);
    Exit;
  end;
end;

constructor TDMConnection.Create(AOwner: TComponent);
begin
  inherited;
end;

procedure TDMConnection.IniciarAtualizacao(const aIdUnidade: Integer);
begin
  {$IFNDEF IS_MOBILE}
  //EnviarComando(TAspEncode.AspIntToHex(FIdModulo, 4) + Chr($0A), aIdUnidade, 'obtém diretório de atualização.');
  EnviarComando('0000' + Chr($0A)+TAspEncode.AspIntToHex(FIdModulo, 4), aIdUnidade, 'obtém diretório de atualização.');
  {$ENDIF !IS_MOBILE}
end;

procedure TDMConnection.InserirSenhaFila(const Senha, Fila: Integer);
var
  aux: string;
begin
  aux:=    IntToHex(Fila, 4) + IntToStr(Senha);
  EnviarComando(cProtocoloPAVazia + Chr($6B) + aux, IdUnidade);
end;

procedure TDMConnection.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = TOperation.opRemove) and Assigned(AComponent) then
  begin
    if (AComponent = dmUnidades.FormClient) then
      dmUnidades.FormClient := nil;
  end;
end;
 {$IFDEF CompilarPara_TGS}
procedure TDMConnection.PreencherNomesIndicadoresPermitidos;
var
  lSQL: String;
  LDMClient: TDMClient;
  lStrLst: TStringList;
  i: Integer;
begin
  if Length(vgParametrosModulo.IndicadoresPermitidos) > 0 then
  begin
    //SetLength(vgParametrosModulo.NomesIndicadoresPermitidos, Length(vgParametrosModulo.IndicadoresPermitidos));
    lStrLst := TStringList.Create;
    try
      for i := Low(vgParametrosModulo.IndicadoresPermitidos) to High(vgParametrosModulo.IndicadoresPermitidos) do
        lStrLst.Add(vgParametrosModulo.IndicadoresPermitidos[i].ToString);
      LDMCLient := DMClient(IdUnidade, not CRIAR_SE_NAO_EXISTIR);
      lSQL := LDMClient.qryPIsPermitidos.SQL.Text;
      try
        LDMClient.qryPIsPermitidos.Close;
        LDMClient.qryPIsPermitidos.SQL.Text := Format(lSQL, [lStrLst.CommaText]);
        LDMClient.qryPIsPermitidos.Open;

        SetLength(vgParametrosModulo.NomesIndicadoresPermitidos, LDMClient.qryPIsPermitidos.RecordCount);

        i := 0;
        while not LDMClient.qryPIsPermitidos.Eof do
        begin
          vgParametrosModulo.NomesIndicadoresPermitidos[i] := LDMClient.qryPIsPermitidos.Fields[0].AsString;
          LDMClient.qryPIsPermitidos.Next;
          Inc(i);
        end;
        LDMClient.qryPIsPermitidos.Close;
      finally
        LDMClient.qryPIsPermitidos.SQL.Text := lSQL;
      end;
    finally
      lStrLst.Free;
    end;
  end;
end;
 {$ENDIF CompilarPara_TGS}
function TDMConnection.DecifrarProtocolo(S: string; Socket: TIdTCPClient; const aIdUnidade: Integer): Boolean;

{$REGION 'Variáveis'}
var
  Atendente, Cor, Fila, MotivoPausa, PA, StatusPA,
    IdEventoPP, IdMP, IdPP, IdTAG, LIdModulo                   : integer;
  Grupo, Nome, NomeTotem, Parametros,
  ProtData, RegFuncional, Senha, Prontuario,
  UltimoProt3C, UltimoProt59, Aux, Aux2, Aux3, Aux4,LLogin: string;
  LValorNumerico, LFlagValorEmSegundos: String;
  LPAAux, Comando, aCurrenIndextInParameter: integer;
  TipoModulo                          : TModuloSics;
  TIM                                 : TDateTime;
  LgIdDoModulo                        : String;
  LDMClient: TDMClient;
  DataHora               : TDateTime;
  dd, mm, yy, hh, nn     : integer;
  LimiarAmarelo,LimiarVermelho,LimiarLaranja,Fonte :string;

{$IFDEF CompilarPara_ONLINE}
  d1     : integer;
  m1     : integer;
  y1     : integer;
  h1     : integer;
  n1     : integer;
  s1     : integer;
  TagsStr: string;
  HoraStr: string;
{$ENDIF CompilarPara_ONLINE}

{$IF Defined(CompilarPara_TGS_ONLINE) or Defined(CompilarPara_TV) }

  TodosPIsOK                          : Boolean;
  EstadoPI                            : Char;
  Valor              : String;
  IndexPI, CodPI, NPI: integer;

{$ENDIF}

{$IFDEF CompilarPara_PA_MULTIPA}
  QtdeSenha: Integer;
//  TAGs                                : TIntegerDynArray;
  sGruposDePAs, sNomePI, sNomeNivel, sMensagem, sCorNivel : string;
  GruposDePAs : TIntArray;
  LCount: Integer;
{$ENDIF CompilarPara_PA_MULTIPA}


{$IFDEF CompilarPara_CALLCENTER}

{$ENDIF}


{$ENDREGION}


  procedure AtivaLeitorCodigoBarras;
  begin
    {$IFDEF SuportaCodigoBarras}
    try
      if vgParametrosModulo.UseCodeBar then
      begin
        LDMClient.CodeBarPort.DeviceName := vgParametrosModulo.CodebarPort;
        LDMClient.CodeBarPort.Open;
      end;
    except
      on E: Exception do
      begin
        ErrorMessage('Erro ao abrir porta serial do leitor de código de barras.' + #13 + 'Erro: ' + e.message);
        Exit;
      end;
    end;
    {$ENDIF SuportaCodigoBarras}
  end;

  {$IFDEF CompilarPara_PA_MULTIPA}
  procedure CarregarParametrosPAMultiPA(LJsonObjeto: TJSONObject);
  var
    LJsonObjectConexaoBD: TJSONObject;
  begin
    vgParametrosModulo.IdModulo      := (TAspJson.GetValueOfJson(LJsonObjeto, 'ID'));
    vgParametrosModulo.SecsOnRecall  := (TAspJson.GetValueOfJson(LJsonObjeto, 'SECS_ON_RECALL'));

    vgParametrosModulo.ConfirmarEncaminha           := TAspJson.GetValueOfJson(LJsonObjeto, 'CONFIRMAR_ENCAMINHA');
    vgParametrosModulo.ConfirmarFinaliza            := TAspJson.GetValueOfJson(LJsonObjeto, 'CONFIRMAR_FINALIZA');
    vgParametrosModulo.ConfirmarProximo             := TAspJson.GetValueOfJson(LJsonObjeto, 'CONFIRMAR_PROXIMO');
    vgParametrosModulo.ConfirmarSenhaOutraFila      := TAspJson.GetValueOfJson(LJsonObjeto, 'CONFIRMAR_SENHA_OUTRA_FILA');
    vgParametrosModulo.ManualRedirect               := TAspJson.GetValueOfJson(LJsonObjeto, 'MANUAL_REDIRECT');
    vgParametrosModulo.MinimizarParaBandeja         := TAspJson.GetValueOfJson(LJsonObjeto, 'MINIMIZAR_PARA_BANDEJA');
    vgParametrosModulo.ModoTerminalServer           := TAspJson.GetValueOfJson(LJsonObjeto, 'MODO_TERMINAL_SERVER');
    vgParametrosModulo.VisualizarAgendamentos       := TAspJson.GetValueOfJson(LJsonObjeto, 'VISUALIZAR_AGENDAMENTOS');
    vgParametrosModulo.MostrarBotaoEncaminha        := TAspJson.GetValueOfJson(LJsonObjeto, 'MOSTRAR_BOTAO_ENCAMINHA');
    vgParametrosModulo.MostrarBotaoEspecifica       := TAspJson.GetValueOfJson(LJsonObjeto, 'MOSTRAR_BOTAO_ESPECIFICA');
    vgParametrosModulo.MostrarBotaoFinaliza         := TAspJson.GetValueOfJson(LJsonObjeto, 'MOSTRAR_BOTAO_FINALIZA');
    vgParametrosModulo.MostrarBotaoSeguirAtendimento:= TAspJson.GetValueOfJson(LJsonObjeto, 'MOSTRAR_BOTAO_SEGUIRATENDIMENTO');
    vgParametrosModulo.MostrarBotaoLogin            := TAspJson.GetValueOfJson(LJsonObjeto, 'MOSTRAR_BOTAO_LOGIN_LOGOUT');
    vgParametrosModulo.MostrarBotaoPausa            := TAspJson.GetValueOfJson(LJsonObjeto, 'MOSTRAR_BOTAO_PAUSA');
    vgParametrosModulo.MostrarBotaoProximo          := TAspJson.GetValueOfJson(LJsonObjeto, 'MOSTRAR_BOTAO_PROXIMO');
    vgParametrosModulo.MostrarBotaoRechama          := TAspJson.GetValueOfJson(LJsonObjeto, 'MOSTRAR_BOTAO_RECHAMA');
    vgParametrosModulo.CodigosUnidades              := TAspJson.GetValueOfJson(LJsonObjeto, 'CODIGOS_UNIDADES');
    vgParametrosModulo.IdUnidadeCliente             := TAspJson.GetValueOfJson(LJsonObjeto, 'ID_UNIDADE_CLI');
    vgParametrosModulo.FilaEsperaProfissional       := TAspJson.GetValueOfJson(LJsonObjeto, 'FILA_ESPERA_PROFISSIONAL');
    {$IFNDEF CompilarPara_PA}
    vgParametrosModulo.MostrarBotaoProcessos        := TAspJson.GetValueOfJson(LJsonObjeto, 'MOSTRAR_BOTAO_PROCESSOS');
    {$ENDIF}
    vgParametrosModulo.MostrarMenuAlteraSenha       := TAspJson.GetValueOfJson(LJsonObjeto, 'MOSTRAR_MENU_ALTERA_SENHA');
    vgParametrosModulo.MostrarMenuEncaminha         := TAspJson.GetValueOfJson(LJsonObjeto, 'MOSTRAR_MENU_ENCAMINHA');
    vgParametrosModulo.MostrarMenuEspecifica        := TAspJson.GetValueOfJson(LJsonObjeto, 'MOSTRAR_MENU_ESPECIFICA');
    vgParametrosModulo.MostrarMenuFinaliza          := TAspJson.GetValueOfJson(LJsonObjeto, 'MOSTRAR_MENU_FINALIZA');
    vgParametrosModulo.MostrarMenuLogin             := TAspJson.GetValueOfJson(LJsonObjeto, 'MOSTRAR_MENU_LOGIN_LOGOUT');
    vgParametrosModulo.MostrarMenuLogout            := TAspJson.GetValueOfJson(LJsonObjeto, 'MOSTRAR_MENU_LOGIN_LOGOUT');
    vgParametrosModulo.MostrarMenuProximo           := TAspJson.GetValueOfJson(LJsonObjeto, 'MOSTRAR_MENU_PROXIMO');
    vgParametrosModulo.MostrarMenuRechama           := TAspJson.GetValueOfJson(LJsonObjeto, 'MOSTRAR_MENU_RECHAMA');
    vgParametrosModulo.MostrarMenuSeguirAtendimento := TAspJson.GetValueOfJson(LJsonObjeto, 'MOSTRAR_MENU_SEGUIRATENDIMENTO');
    vgParametrosModulo.MostrarNomeCliente           := TAspJson.GetValueOfJson(LJsonObjeto, 'MOSTRAR_NOME_CLIENTE');
    vgParametrosModulo.MostrarNomeAtendente         := TAspJson.GetValueOfJson(LJsonObjeto, 'MOSTRAR_NOME_ATENDENTE');
    vgParametrosModulo.MostrarPainelGrupos          := TAspJson.GetValueOfJson(LJsonObjeto, 'MOSTRAR_PAINEL_GRUPOS');
    vgParametrosModulo.MostrarPA                    := TAspJson.GetValueOfJson(LJsonObjeto, 'MOSTRAR_PA');
    vgParametrosModulo.PodeFecharPrograma           := TAspJson.GetValueOfJson(LJsonObjeto, 'PODE_FECHAR_PROGRAMA');
    vgParametrosModulo.TAGsObrigatorias             := TAspJson.GetValueOfJson(LJsonObjeto, 'TAGS_OBRIGATORIAS');
    vgParametrosModulo.UseCodeBar                   := TAspJson.GetValueOfJson(LJsonObjeto, 'USE_CODE_BAR');
    vgParametrosModulo.VisualizarProcessosParalelos := TAspJson.GetValueOfJson(LJsonObjeto, 'VISUALIZAR_PROCESSOS_PARALELOS');
    vgParametrosModulo.MostrarMenuPausa             := TAspJson.GetValueOfJson(LJsonObjeto, 'MOSTRAR_MENU_PAUSA');
    vgParametrosModulo.MostrarMenuControleRemoto    := TAspJson.GetValueOfJson(LJsonObjeto, 'MOSTRAR_CONTROLE_REMOTO');
    vgParametrosModulo.CodebarPort                  := TAspJson.GetValueOfJson(LJsonObjeto, 'PORTA_LCDB');//'com1,9600,8,n,1';
    vgParametrosModulo.IdTagAutomatica              := TAspJson.GetValueOfJson(LJsonObjeto, 'ID_TAG_AUTOMATICA');
    vgParametrosModulo.MarcarTagAposAtendimento     := TAspJson.GetValueOfJson(LJsonObjeto, 'MARCAR_TAG_APOS_ATENDIMENTO');
    vgParametrosModulo.PIAlertaSonoro               := TAspJson.GetValueOfJson(LJsonObjeto, 'ID_PIALERTASONORO');
    vgParametrosModulo.MostrarDadosAdicionais       := TAspJson.GetValueOfJson(LJsonObjeto, 'MOSTRAR_BOTAO_DADOS_ADICIONAIS');
    vgParametrosModulo.PermiteFinalizar             := TAspJson.GetValueOfJson(LJsonObjeto, 'PERMITEFINALIZAR');

    StrToIntArray(TAspJson.GetValueOfJson(LJsonObjeto, 'GRUPOS_DE_TAGS_LAYOUT_BOTAO'), vgParametrosModulo.GruposTAGSLayoutBotao);
    StrToIntArray(TAspJson.GetValueOfJson(LJsonObjeto, 'GRUPOS_DE_TAGS_LAYOUT_LISTA'), vgParametrosModulo.GruposTAGSLayoutLista);
    StrToIntArray(TAspJson.GetValueOfJson(LJsonObjeto, 'GRUPOS_DE_TAGS_SOMENTE_LEITURA'), vgParametrosModulo.GruposTAGSSomenteLeitura);

    if LJsonObjeto.TryGetValue('ConexaoBD', LJsonObjectConexaoBD) then
    begin
      TConexaoBD.FromJSON(LJsonObjectConexaoBD);
      TConexaoBD.CheckFirebirdLocalHost(vgParametrosSicsClient.TCPSrvAdr);
      TConexaoBD.Configurar(dmUnidades.FDManager);
      {$IFDEF CompilarPara_TGS}
      LNomeConexao := TConexaoBD.Nome;
      {$ENDIF}
    end;

    {$IFDEF CompilarPara_PA}
    vgParametrosModulo.VisualizaPessoasFilas        := TAspJson.GetValueOfJson(LJsonObjeto, 'VISUALIZA_PESSOAS_FILAS');
    {$ENDIF}
  end;
  {$ENDIF CompilarPara_PA_MULTIPA}

  {$IFDEF CompilarPara_PA}
  procedure CarregarParametrosPA;
  var
    ObjJSon: TJSONValue;
    LJsonObjeto: TJSONObject;
  begin
    ObjJson := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(Parametros), 0);
    try
      LJsonObjeto := TAspJson.GetJsonObjectOfJson(ObjJson);

      CarregarParametrosPAMultiPA(LJsonObjeto);
      vgParametrosModulo.IDPA         := (TAspJson.GetValueOfJson(LJsonObjeto, 'ID_PA'));
      GravaNoINI(Inttostr(vgParametrosModulo.IDPA));

      {$IFDEF IS_MOBILE}
      vgParametrosModulo.TamanhoBotoesAltura  := 80;  //RAP 02/06/2016 40;
      vgParametrosModulo.TamanhoBotoesLargura := 200; //RAP 02/06/2016 100;
      vgParametrosModulo.TamanhoFonteBotoes   := 28;  //RAP 02/06/2016 14;
      {$ELSE}
      vgParametrosModulo.TamanhoBotoesAltura  := 42;
      vgParametrosModulo.TamanhoBotoesLargura := 70;
      vgParametrosModulo.TamanhoFonteBotoes   := 12;
      {$ENDIF ANDROID}
      vgParametrosModulo.IdTagAutomatica              := TAspJson.GetValueOfJson(LJsonObjeto, 'ID_TAG_AUTOMATICA');
      vgParametrosModulo.MarcarTagAposAtendimento     := TAspJson.GetValueOfJson(LJsonObjeto, 'MARCAR_TAG_APOS_ATENDIMENTO');
      vgParametrosModulo.PIAlertaSonoro               := TAspJson.GetValueOfJson(LJsonObjeto, 'ID_PIALERTASONORO');
      vgParametrosModulo.MostrarProntuario            := TAspJson.GetValueOfJson(LJsonObjeto, 'MOSTRAR_PRONTUARIO');
      vgParametrosModulo.MostrarDadosAdicionais       := TAspJson.GetValueOfJson(LJsonObjeto, 'MOSTRAR_BOTAO_DADOS_ADICIONAIS');
      vgParametrosModulo.PermiteFinalizar             := TAspJson.GetValueOfJson(LJsonObjeto, 'PERMITEFINALIZAR');

      StrToIntArray(TAspJson.GetValueOfJson(LJsonObjeto, 'GRUPOS_DE_TAGS_LAYOUT_BOTAO'), vgParametrosModulo.GruposTAGSLayoutBotao);
      StrToIntArray(TAspJson.GetValueOfJson(LJsonObjeto, 'GRUPOS_DE_TAGS_LAYOUT_LISTA'), vgParametrosModulo.GruposTAGSLayoutLista);
      StrToIntArray(TAspJson.GetValueOfJson(LJsonObjeto, 'GRUPOS_DE_TAGS_SOMENTE_LEITURA'), vgParametrosModulo.GruposTAGSSomenteLeitura);

      //<FIM> Preenchendo valores default que não estão no banco

      AtivaLeitorCodigoBarras;

      if Assigned(LDMClient) then
        LDMClient.FCurrentPA := vgParametrosModulo.IDPA;
    finally
      ObjJSon.Free;
    end;
  end;
  {$ENDIF CompilarPara_PA}

  {$IFDEF CompilarPara_MULTIPA}
  procedure CarregarParametrosMultiPA;
  var
    ObjJSon: TJSONValue;
    LJsonObjeto: TJSONObject;
    LCodPA: Integer;
  begin
    ObjJson := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(Parametros), 0);
    try
      LJsonObjeto := TAspJson.GetJsonObjectOfJson(ObjJson);
      vgParametrosModulo.COLUNASPAS    := (TAspJson.GetValueOfJson(LJsonObjeto, 'COLUNAS_PAS'));
      vgParametrosModulo.TEMPOLIMPARPA := (TAspJson.GetValueOfJson(LJsonObjeto, 'TEMPO_LIMPAR_PA'));
      CarregarParametrosPAMultiPA(LJsonObjeto);

      //Preenchendo valores default que não estão no banco
      //LBC A FAZER - CARREGAR DO INI
      vgParametrosModulo.OcultarPADeslogada      := False;
      vgParametrosModulo.OcultarPASemEspera      := False;
      vgParametrosModulo.OcultarPASemAtendimento := False;


      {$IFDEF IS_MOBILE}
      vgParametrosModulo.TamanhoBotoesAltura  := 40;  //RAP 02/06/2016 20;
      vgParametrosModulo.TamanhoBotoesLargura := 100; //RAP 02/06/2016 50;
      vgParametrosModulo.TamanhoFonteBotoes   := 28;  //RAP 02/06/2016 14;
      {$ELSE}
      vgParametrosModulo.TamanhoBotoesAltura  := 20;
      vgParametrosModulo.TamanhoBotoesLargura := 50;
      vgParametrosModulo.TamanhoFonteBotoes   := 12;
      {$ENDIF ANDROID}
      //<FIM> Preenchendo valores default que não estão no banco

      AtivaLeitorCodigoBarras;
      if ASsigned(LDMClient) then
        LDMClient.tmrClearAtd.Interval := (vgParametrosModulo.TempoLimparPA*1000);
    finally
      FreeAndNil(ObjJSon);
    end;
  end;
  {$ENDIF CompilarPara_MULTIPA}

  function StrFlagToBool(const aStr: string): Boolean;
  begin
    Result := UpperCase(aStr) = 'T';
  end;

  {$IF Defined(CompilarPara_ONLINE)}
  procedure CarregarParametrosOnline;
  var
    LArray: TJSONArray;
    ObjJSon: TJSONValue;
    LJsonObjeto: TJSONObject;
    LPort: Integer;
  begin
    LArray := TJSONArray(TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(Parametros), 0));
    try
      //O segundo item do Array (Items[1]) são os parâmetros do servidor que não
      //vem do Banco de dados. Se ocorrer uma exceção é porque não veio o segundo
      //item do array, ou seja, o servidor está desatualizado.
      try
        ObjJson := LArray.Items[1];
        if ObjJSon.TryGetValue('FileServerPort', LPort) then
          vgParametrosModulo.PortaServidorArquivos := LPort;
      except
        vgParametrosModulo.PortaServidorArquivos := 80;
      end;

      //o primeiro item do Array (Items[0]) são os parâmetros do servidor que
      //vem do banco de dados. Veja a procedure SolicitarParametrosModuloSICSONLINE
      //da unit ProtocoloSics, no servidor
      LJsonObjeto := TJSONObject(LArray.Items[0]);

      StrToIntArray(TAspJson.GetValueOfJson(LJsonObjeto, 'FILAS_PERMITIDAS'), vgParametrosModulo.FilasPermitidas);
      StrToIntArray(TAspJson.GetValueOfJson(LJsonObjeto, 'MOSTRAR_BOTAO_NAS_FILAS'), vgParametrosModulo.MostrarBotaoNasFilas);
      StrToIntArray(TAspJson.GetValueOfJson(LJsonObjeto, 'MOSTRAR_BLOQUEAR_NAS_FILAS'), vgParametrosModulo.MostrarBloquearNasFilas);
      StrToIntArray(TAspJson.GetValueOfJson(LJsonObjeto, 'MOSTRAR_PRIORITARIA_NAS_FILAS'), vgParametrosModulo.MostrarPrioritariaNasFilas);
      StrToIntArray(TAspJson.GetValueOfJson(LJsonObjeto, 'PERMITIR_INCLUSAO_NAS_FILAS'), vgParametrosModulo.PermitirInclusaoNasFilas);
      StrToIntArray(TAspJson.GetValueOfJson(LJsonObjeto, 'PERMITIR_EXCLUSAO_NAS_FILAS'), vgParametrosModulo.PermitirExclusaoNasFilas);
      StrToIntArray(TAspJson.GetValueOfJson(LJsonObjeto, 'PERMITIR_REIMPRESSAO_NAS_FILAS'), vgParametrosModulo.PermitirReimpressaonasFilas);
      StrToIntArray(TAspJson.GetValueOfJson(LJsonObjeto, 'GRUPOS_INDICADORES_PERMITIDOS'), vgParametrosModulo.IndicadoresPermitidos);

      vgParametrosModulo.IdModulo                    := LIdModulo;
      vgParametrosModulo.MostrarExcluirTodas         := TAspJson.GetValueOfJson(LJsonObjeto, 'MOSTRAR_EXCLUIR_TODAS');
      vgParametrosModulo.VisualizarGruposPAsAtds     := TAspJson.GetValueOfJson(LJsonObjeto, 'VISUALIZAR_GRUPOS');
      vgParametrosModulo.ColunasDeFilas              := TAspJson.GetValueOfJson(LJsonObjeto, 'COLUNAS_DE_FILAS');
      vgParametrosModulo.LinhasDeFilas               := TAspJson.GetValueOfJson(LJsonObjeto, 'LINHAS_DE_FILAS');
      vgParametrosModulo.PodeFecharPrograma          := TAspJson.GetValueOfJson(LJsonObjeto, 'PODE_FECHAR_PROGRAMA');
      vgParametrosModulo.ImpressoraComandada         := TAspJson.GetValueOfJson(LJsonObjeto, 'IMPRESSORA_COMANDADA');
      vgParametrosModulo.VisualizarNomeClientes      := TAspJson.GetValueOfJson(LJsonObjeto, 'VISUALIZAR_NOME_CLIENTES');
      vgParametrosModulo.MostrarTempoDecorridoEspera := TAspJson.GetValueOfJson(LJsonObjeto, 'MOSTRA_TEMPO_DECORRIDO_ESPERA');
      vgParametrosModulo.TelaPadrao                  := TAspJson.GetValueOfJson(LJsonObjeto, 'TELA_PADRAO');
      vgParametrosModulo.TamanhoFonte                := TAspJson.GetValueOfJson(LJsonObjeto, 'TAMANHO_FONTE');
      vgParametrosModulo.ModoCallCenter              := TAspJson.GetValueOfJson(LJsonObjeto, 'MODO_CALL_CENTER');
      vgParametrosModulo.IdUnidadeCliente            := TAspJson.GetValueOfJson(LJsonObjeto, 'ID_UNIDADE_CLI');
      vgParametrosModulo.MostrarProntuario           := TAspJson.GetValueOfJson(LJsonObjeto, 'MOSTRAR_PRONTUARIO');
      vgParametrosModulo.MostrarDadosAdicionais      := TAspJson.GetValueOfJson(LJsonObjeto, 'MOSTRAR_DADOS_ADICIONAIS');
      vgParametrosModulo.MostrarTAGsPreenchidas      := TAspJson.GetValueOfJson(LJsonObjeto, 'MOSTRAR_TAGS_PREENCHIDAS');

      StrToIntArray(TAspJson.GetValueOfJson(LJsonObjeto, 'GRUPOS_DE_TAGS_LAYOUT_BOTAO'), vgParametrosModulo.GruposTAGSLayoutBotao);
      StrToIntArray(TAspJson.GetValueOfJson(LJsonObjeto, 'GRUPOS_DE_TAGS_LAYOUT_LISTA'), vgParametrosModulo.GruposTAGSLayoutLista);
      StrToIntArray(TAspJson.GetValueOfJson(LJsonObjeto, 'GRUPOS_DE_TAGS_SOMENTE_LEITURA'), vgParametrosModulo.GruposTAGSSomenteLeitura);

      //LBC 22/08/2017: Parametrização para atender módulo OnLine "de parede" do HCor.
      //Para funcionar, deve ser criado no banco o campo "REPINTARFILAS" na tabela "MODULOS_ONLINE" e preencher com TRUE no módulo respectivo.
      //O campo não é criado por script pois trata-se de solução específica para um cliente e, possivelmente, provisória.
      vgParametrosModulo.RepintarFilas := false;
      if not VarIsNull(TAspJson.GetValueOfJson(LJsonObjeto, 'REPINTARFILAS')) then
        vgParametrosModulo.RepintarFilas := TAspJson.GetValueOfJson(LJsonObjeto, 'REPINTARFILAS');

      vgParametrosModulo.SituacaoEsperaLayout         := TAspJson.GetValueOfJson(LJsonObjeto, 'SITUACAOESPERA_LAYOUT');
      vgParametrosModulo.SituacaoEsperaCorLayout      := TAspJson.GetValueOfJson(LJsonObjeto, 'SITUACAOESPERA_CORLAYOUT');
      vgParametrosModulo.SituacaoEsperaEstiloLayout   := TAspJson.GetValueOfJson(LJsonObjeto, 'ESTILOESPERA_LAYOUT');
    finally
      FreeAndNil(LArray);
    end;
  end;
  {$ENDIF CompilarPara_ONLINE}

  {$IFDEF CompilarPara_TGS}
  procedure CarregarParametrosTGS;
  var
    LNomeConexao   : string;
    LQuery         : TFDQuery;
    LJSONObject    : TJSONObject;
  begin
    if dmUnidades.Quantidade > 1 then
    begin
      LNomeConexao := TConexaoBD.NomeBasePadrao(IdUnidade);
    end
    else
    begin
      LJSONObject := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(Parametros),0) as TJSONObject;
      try
        TConexaoBD.FromJSON(LJSONObject);
        TConexaoBD.CheckFirebirdLocalHost(vgParametrosSicsClient.TCPSrvAdr);
        TConexaoBD.Configurar(dmUnidades.FDManager);
        LNomeConexao := TConexaoBD.Nome;
      finally
        LJSONObject.Free;
      end;
    end;

    //LBC: VERIFICAR POIS NÃO SERIA NECESSÁRIO TER DUAS CONEXÕES AO MESMO BANCO, VERIFICAR SE DEIXA SÓ UMA E APONTAR OS RELATÓRIOS PARA ESTA
    LDMClient.connDMClient.Close;
    LDMClient.connDMClient.Params.Clear;
    LDMClient.connDMClient.ConnectionDefName := LNomeConexao;
    LDMClient.connDMClient.Open;

    LDMClient.connRelatorio.Close;
    LDMClient.connRelatorio.Params.Clear;
    LDMClient.connRelatorio.ConnectionDefName := LNomeConexao;

    LQuery := TFDQuery.Create(Self);
    try
      LQuery.Connection := LDMClient.connDMClient;
      LQuery.SQL.Text   := 'SELECT C.*, M.NOME FROM MODULOS_TGS C INNER JOIN MODULOS M ON M.ID_UNIDADE = C.ID_UNIDADE'
        + ' AND M.ID = C.ID WHERE C.ID_UNIDADE = :ID_UNIDADE AND C.ID = ' + IntToStr(LIdModulo);
      LQuery.Open;

      vgParametrosModulo.IdModulo                        := LQuery.FieldByName('ID'                              ).AsInteger;
      vgParametrosModulo.MinimizarParaBandeja            := LQuery.FieldByName('MINIMIZAR_PARA_BANDEJA'          ).AsBoolean;
      vgParametrosModulo.PodeFecharPrograma              := LQuery.FieldByName('PODE_FECHAR_PROGRAMA'            ).AsBoolean;
      vgParametrosModulo.PodeConfigAtendentes            := LQuery.FieldByName('PODE_CONFIG_ATENDENTES'          ).AsBoolean;
      vgParametrosModulo.ReportarTemposMaximos           := LQuery.FieldByName('REPORTAR_TEMPOS_MAXIMOS'         ).AsBoolean;
      vgParametrosModulo.PodeConfigPrioridadesAtend      := LQuery.FieldByName('PODE_CONFIG_PRIORIDADES_ATEND'   ).AsBoolean;
      vgParametrosModulo.PodeConfigIndDePerformance      := LQuery.FieldByName('PODE_CONFIG_IND_DE_PERFORMANCE'  ).AsBoolean;
      vgParametrosModulo.VisualizarGruposPAsAtds         := LQuery.FieldByName('VISUALIZAR_GRUPOS'               ).AsBoolean;
      vgParametrosModulo.VisualizarNomeClientes          := LQuery.FieldByName('VISUALIZAR_NOME_CLIENTES'        ).AsBoolean;
      vgParametrosModulo.ModoCallCenter                  := StrFlagToBool(LQuery.FieldByName('MODO_CALL_CENTER').AsString);
      vgParametrosModulo.MostrarRelatorioTMAA            := LQuery.FieldByName('MOSTRAR_RELATORIO_TMAA'          ).AsBoolean;

      StrToIntArray(LQuery.FieldByName('GRUPOS_DE_TAGS_PERMITIDOS'       ).AsString, vgParametrosModulo.GRUPOSDETAGSPERMITIDOS );
      StrToIntArray(LQuery.FieldByName('GRUPOS_INDICADORES_PERMITIDOS'   ).AsString, vgParametrosModulo.IndicadoresPermitidos  );
      PreencherNomesIndicadoresPermitidos;
    finally
      FreeAndNil(LQuery);
    end;
  end;
  {$ENDIF CompilarPara_TGS}

  {$IFDEF CompilarPara_CALLCENTER}
  procedure CarregarParametrosCallCenter;
  var
    ObjJSon: TJSONValue;
    LJsonObjeto: TJSONObject;
  begin
    ObjJson := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(Parametros), 0);
    try
      LJsonObjeto := TAspJson.GetJsonObjectOfJson(ObjJson);
      vgParametrosModulo.NumeroMesa                     := TAspJson.GetValueOfJson(LJsonObjeto, 'NUMERO_MESA');
      vgParametrosModulo.LoginAutomaticoUsuarioWindows  := TAspJson.GetValueOfJson(LJsonObjeto, 'LOGIN_WINDOWS');
    finally
      FreeAndNil(ObjJSon);
    end;
  end;
  {$ENDIF}

  procedure ParametrosModuloSICS;
  {$IFDEF CompilarPara_MULTIPA}
  var
    LCodPA : integer;
  {$ENDIF CompilarPara_MULTIPA}
  begin
    case ProtData[1] of
      'P' : TipoModulo := msPA;
      'M' : TipoModulo := msMPA;
      'O' : TipoModulo := msOnLine;
      'T' : TipoModulo := msTGS;
      'V' : TipoModulo := msTV;
      'C' : TipoModulo := msCallCenter;
      'H' : TipoModulo := msTotemTouch;
      else raise TAspException.create(Self, 'Tipo módulo não encontrado');
    end;

    LIdModulo := StrToInt('$' + Copy(ProtData, 2, 4));

    Parametros := Copy(ProtData, 6, Length(ProtData));
    if (Length(Parametros) <= 1) then
    begin
      ErrorMessage(Format('O ID módulo %d não foi encontrado no servidor.', [FIdModulo]));
      Exit;
    end;

    if (TipoModulo = cgTipoModulo) and (LIdModulo = FIdModulo) then
    begin
      {$IFDEF CompilarPara_PA}
      CarregarParametrosPA;
      if Assigned(dmUnidades.FormClient) then
        dmUnidades.FormClient.CarregarParametrosDB(vgParametrosModulo.IDPA, aIdUnidade);
      {$ENDIF CompilarPara_PA}

      {$IFDEF CompilarPara_MULTIPA}
      CarregarParametrosMultiPA;
      if Assigned(dmUnidades.FormClient) then
      begin
        LDMClient.cdsPAs.First;
        while not LDMClient.cdsPAs.Eof do
        begin
          LCodPA := LDMClient.cdsPAs.FieldByName('ID').AsInteger;
          if (dmUnidades.FormClient.GetPaJaFoiCriada(LCodPA)) then
            dmUnidades.FormClient.CarregarParametrosDB(LCodPA, aIdUnidade);

          LDMClient.cdsPAs.Next
        end;
      end;
      {$ENDIF CompilarPara_MULTIPA}

      {$IFDEF CompilarPara_TGS}
      CarregarParametrosTGS;
      if Assigned(MainForm) then
        MainForm.CarregarParametrosDB;
      {$ENDIF CompilarPara_TGS}

      {$IFDEF CompilarPara_ONLINE}
      CarregarParametrosOnline;
      if Assigned(FrmSicsOnLine) then
      begin
        FrmSicsOnLine.CarregarParametrosDB;
      end;
      {$ENDIF CompilarPara_ONLINE}

      {$IFDEF CompilarPara_CALLCENTER}
      CarregarParametrosCallCenter;
      if Assigned(dmUnidades.FormClient) then
      begin
        dmUnidades.FormClient.NumeroMesa := vgParametrosModulo.NumeroMesa;
        dmUnidades.FormClient.VerificaLoginAutomaticoUsuarioWindows;
      end;
      {$ENDIF}

      {$IFDEF CompilarPara_TOTEMTOUCH}
      if Assigned(dmUnidades.FormClient) then
      begin
        dmUnidades.FormClient.LoadInitialData(Parametros);
      end;
      {$ENDIF}

      vgParametrosModulo.JaEstaConfigurado := True;
    end
    else
      ErrorMessage('Os parâmetros solicitados diferem dos parâmetros retornados.');
  end;

var
  I, vVersaoProtocolo: Integer;
  sPAs, LSituacaoPAAoExibirForm, LSituacaoFrmSelecaoFila: string;
  LProtRegistrosDataSeparado: TStringDynArray;
  LProtFieldsDataSeparado: TStringDynArray;

  {$IFDEF CompilarPara_ONLINE}
  LFraSituacaoEspera: TFraSituacaoEspera;
  {$ENDIF CompilarPara_ONLINE}

  {$IFDEF CompilarPara_PA_MULTIPA}
  LFrmSelecaoFila: TFrmSelecaoFila;
  LBeginUpdatePA: Boolean;
  LFrmSelecaoPP: TfrmSelecaoPP;
  LFrmSelecaoMotivoPausa: TfrmSelecaoMotivoPausa;
  {$ENDIF CompilarPara_PA_MULTIPA}

  {$IFDEF CompilarPara_TGS_ONLINE}
  LFraSituacaoAtendimento: TFraSituacaoAtendimento;
  {$ENDIF}

  {$IFDEF CompilarPara_TGS}
  LfrmLines: TfrmLines;
  {$ENDIF}

  {$IF ((not Defined(CompilarPara_SICSTV)) and (not Defined(CompilarPara_CALLCENTER)) and (not Defined(CompilarPara_TOTEMTOUCH))) }
  LFrmProcessoParalelo: TFrmProcessoParalelo;
  {$ENDIF}

  {$IFDEF CompilarPara_CALLCENTER}
  LFrmSelecaoFila: TFrmSelecaoFila;
  LFrmLoginGestor: TFrmLoginGestor;
  {$ENDIF}

  DebugInicio : TDateTime;

  LPAs: TStrings;
const
  DebugItem : integer = 0;
  SHOW = True;
begin
  PA := 0;
  LgIdDoModulo := TAspEncode.AspIntToHex(FIdModulo, 4);
  LDMClient := DMClient(aIdUnidade, not CRIAR_SE_NAO_EXISTIR);
  Comando :=  0;
  Result := False;

  {$IFDEF DEBUG}
    DebugInicio := now;
    DebugItem := DebugItem + 1;
    Tlog.MyLog('[DEBUG ' + inttostr(DebugItem) + '] DecifrarProtocolo : ' + s, nil, 0, false, TCriticalLog.tlDEBUG);
  {$ENDIF DEBUG}

  try
    try
      if GetEncondeProtocoloEhValido(s) then
      begin
        ExtrairVersaoNoProtocolo(s, vVersaoProtocolo);
        PA       := StrToInt('$' + Copy(s, 2, 4));
        {$IFDEF CompilarPara_PA_MULTIPA}                                             //LBC VERIFICAR BUG #85
        LBeginUpdatePA := Assigned(dmUnidades.FormClient) and dmUnidades.FormClient.BeginUpdatePA(PA);     //LBC VERIFICAR BUG #85
        {$ENDIF CompilarPara_PA_MULTIPA}                                             //LBC VERIFICAR BUG #85
        try
          ExtrairProtDataNoProtocolo(s, ProtData, Comando);

          if (((vVersaoProtocolo <> VERSAO_PROTOCOLO) and (Comando <> $0B)) or (Comando = $0C)) then
          begin
            IniciarAtualizacao(aIdUnidade);
            Exit;
          end;

          if ValidarPA(PA, aIdUnidade) then
          begin
            Result := true;
    {$REGION 'Comandos'}

            case Comando of
    {$REGION 'Comandos Global'}
              $0B : begin
                      vgParametrosSicsClient.ArqUpdateDir := ProtData;
                      dmUnidades.ExecutaAtualizacaoApp;
                    end;
              $06 : begin
                      //Não faz nada, recebimento de ACK do servidor
                    end;
              // ****************************************************************************************************
              // RE: Chamou senha específica
              // ****************************************************************************************************
              $23 : begin
                       SeparaStrings(ProtData, TAB, Senha, Aux);

                      {$IFDEF CompilarPara_PA_MULTIPA}
                      if Assigned(dmUnidades.FormClient) and (IdUnidade = dmUnidades.UnidadeAtiva) then
                      begin
                        dmUnidades.FormClient.AtualizarSenha(PA, Senha);
                        dmUnidades.FormClient.LBC_BotaoProximoViraRechama(PA);
                      end;
                      {$ENDIF CompilarPara_PA_MULTIPA}

                      LDMClient.LimparAgendamentos(PA);

                      SolicitarTAGs(PA, Senha, aIdUnidade);
                      SolicitarNomeCliente(PA, Senha, aIdUnidade);
                      SolicitarAgendamentosFilas(PA, Senha, aIdUnidade);
                      SolicitarDadosAdicionais(PA, Senha, aIdUnidade);
                      {$IFDEF CompilarPara_MULTIPA}
                      LDMClient.ClearAtdCasoNecessario(PA);
                      {$ENDIF CompilarPara_MULTIPA}
                    end;
              {$IFNDEF CompilarPara_SICSTV}

              // ****************************************************************************************************
              // RE: Não chamou nenhuma senha
              // ****************************************************************************************************
              $24 : begin
                      case S[7] of
                        'N' : begin
                                {$IFDEF CompilarPara_PA_MULTIPA}
                                // trazer para frente (verificar como fazer no FMX)
                                Senha := Copy(S, 8, Length(S) - 8);
                                LSituacaoPAAoExibirForm := dmUnidades.FormClient.GetSituacaoAtualPA(PA);
                                LFrmSelecaoFila := FrmSelecaoFila(aIdUnidade);
                                LSituacaoFrmSelecaoFila := LFrmSelecaoFila.GetSituacaoAtual;
                                ConfirmationMessage('Senha solicitada (' + Senha + ') não se encontra em nenhuma fila!'#13'Chamar mesmo assim?',
                                  procedure (const aOK: Boolean)
                                  begin
                                    if aOK then
                                    begin
                                      if (LSituacaoPAAoExibirForm = dmUnidades.FormClient.GetSituacaoAtualPA(PA)) and
                                         (LSituacaoFrmSelecaoFila = LFrmSelecaoFila.GetSituacaoAtual) then
                                      begin
                                        if //{$IFDEF CompilarPara_PA_MULTIPA}
                                          (not vgParametrosModulo.ManualRedirect) or
                                          (Assigned(dmUnidades.FormClient) and
                                            (not dmUnidades.FormClient.EstaEmAtendimento(PA))
                                          ) or
                                          //{$ENDIF CompilarPara_PA_MULTIPA}
                                          (LFrmSelecaoFila.Lista.ItemIndex <= 0) then
                                          ForcarChamada(PA, StrToInt(Senha), aIdUnidade)
                                        else
                                          Redirecionar_ForcarChamada(PA, LFrmSelecaoFila.IdSelecionado, StrToInt(Senha), aIdUnidade)
                                      end
                                      else
                                        ErrorMessage(Format('A situação da PA foi alterada. Situação do atendimento anterior "%s" para "%s", situação da seleção anterior "%s" para "%s"',
                                          [LSituacaoPAAoExibirForm, dmUnidades.FormClient.GetSituacaoAtualPA(PA),
                                          LSituacaoFrmSelecaoFila, LFrmSelecaoFila.GetSituacaoAtual]));
                                    end
                                    else
                                    begin
                                      InformationMessage('Operação abortada.');

                                      if Assigned(dmUnidades.FormClient) then
                                        dmUnidades.FormClient.LBC_BotaoProximoBackToProximo(PA);
                                    end;
                                  end);
                                {$ENDIF CompilarPara_PA_MULTIPA}
                              end;
                        'P' : begin
                                {$IFDEF CompilarPara_PA_MULTIPA}
                                // trazer para frente (verificar como fazer no FMX)
                                Senha := Copy(S, 8, Length(S) - 8);
                                LSituacaoPAAoExibirForm := dmUnidades.FormClient.GetSituacaoAtualPA(PA);
                                LFrmSelecaoFila := FrmSelecaoFila(aIdUnidade);
                                LSituacaoFrmSelecaoFila := LFrmSelecaoFila.GetSituacaoAtual;
                                ConfirmationMessage('Senha (' + Senha + ') se encontra em uma fila que não deveria ser atendida por este atendente!'#13'Chamar mesmo assim?',
                                  procedure (const aOK: Boolean)
                                  begin
                                    if aOK then
                                    begin
                                      if (LSituacaoPAAoExibirForm = dmUnidades.FormClient.GetSituacaoAtualPA(PA)) and
                                         (LSituacaoFrmSelecaoFila = LFrmSelecaoFila.GetSituacaoAtual) then
                                      begin
                                        if (not vgParametrosModulo.ManualRedirect) or
                                           (Assigned(dmUnidades.FormClient) and (not dmUnidades.FormClient.EstaEmAtendimento(PA))) or
                                           (LFrmSelecaoFila.Lista.ItemIndex <= 0) then
                                          ForcarChamada(PA, StrToInt(Senha), aIdUnidade)
                                        else
                                          Redirecionar_ForcarChamada(PA, LFrmSelecaoFila.IdSelecionado, StrToInt(Senha), aIdUnidade);
                                      end
                                      else
                                        ErrorMessage(Format('A situação da PA foi alterada. Situação do atendimento anterior "%s" para "%s", situação da seleção anterior "%s" para "%s"',
                                          [LSituacaoPAAoExibirForm, dmUnidades.FormClient.GetSituacaoAtualPA(PA),
                                           LSituacaoFrmSelecaoFila, LFrmSelecaoFila.GetSituacaoAtual]));
                                    end
                                    else
                                    begin
                                      InformationMessage('Operação abortada.');

                                      if Assigned(dmUnidades.FormClient) then
                                        dmUnidades.FormClient.LBC_BotaoProximoBackToProximo(PA);
                                    end;
                                  end);
                                {$ENDIF CompilarPara_PA_MULTIPA}
                              end;
                        'L' : begin
                                // trazer para frente (verificar como fazer no FMX)
                                ErrorMessage('Não há atendente logado nesta PA. Por favor faça login.');

                                {$IFDEF CompilarPara_PA_MULTIPA}
                                if Assigned(dmUnidades.FormClient) then
                                  dmUnidades.FormClient.LBC_BotaoProximoBackToProximo(PA);
                                {$ENDIF CompilarPara_PA_MULTIPA}
                              end;
                        'I' : begin
                                // trazer para frente (verificar como fazer no FMX)
                                {$IFDEF CompilarPara_PA_MULTIPA}
                                  if vgParametrosModulo.UseCodeBar then
                                    TLog.MyLog('Senha inválida', nil, 0, false, TCriticalLog.tlERROR)
                                  else
                                    ErrorMessage('Senha inválida');
                                {$ELSE}
                                  ErrorMessage('Senha inválida');
                                {$ENDIF}

                                {$IFDEF CompilarPara_PA_MULTIPA}
                                if Assigned(dmUnidades.FormClient) then
                                  dmUnidades.FormClient.LBC_BotaoProximoBackToProximo(PA);
                                {$ENDIF CompilarPara_PA_MULTIPA}
                              end;
                        'p' : begin
                                // trazer para frente (verificar como fazer no FMX)
                                ErrorMessage('PA em pausa. Necessário encerrar pausa antes de chamar próximo.');

                                {$IFDEF CompilarPara_PA_MULTIPA}
                                if Assigned(dmUnidades.FormClient) then
                                  dmUnidades.FormClient.LBC_BotaoProximoBackToProximo(PA);
                                {$ENDIF CompilarPara_PA_MULTIPA}
                              end;
                        else begin
                               {$IFDEF CompilarPara_PA_MULTIPA}
                               if Assigned(dmUnidades.FormClient) then
                               begin
                                 dmUnidades.FormClient.AtualizarSenha(PA, SemSenha);
                                 dmUnidades.FormClient.LBC_BotaoProximoBackToProximo(PA);
                               end;
                               {$ENDIF CompilarPara_PA_MULTIPA}
                        end;
                      end;
                    end;
              {$ENDIF CompilarPara_SICSTV}

              // ****************************************************************************************************
              // RE: Comando não suportado pela versão
              // ****************************************************************************************************
              $33:
                begin
                  ErrorMessage('Comando não suportado pelo servidor.');
                end;

              // ****************************************************************************************************
              // RE: Definir nome de cliente para uma senha
              // ****************************************************************************************************
              $57:
                begin
                  SeparaStrings(ProtData, TAB, Senha, Aux);

                  {$IF Defined(CompilarPara_PA_MULTIPA) or Defined(CompilarPara_TGS_ONLINE) or Defined(CompilarPara_SICSTV)}
                  if Assigned(dmUnidades.FormClient) and (IdUnidade = dmUnidades.UnidadeAtiva) then
                    dmUnidades.FormClient.DefinirNomeParaSenha(PA, StrToInt(Senha), Aux);
                  {$ENDIF}

                  {$IFDEF CompilarPara_TGS_ONLINE}

                  LDMClient.UpdateNomeCliente(PA, StrToInt(Senha), Aux); // Atualiza o nome cliente para para situação de espera
                  {$ELSE}
                  {$IF ((not Defined(CompilarPara_SICSTV)) and
                        (not Defined(CompilarPara_CALLCENTER)) and
                        (not Defined(CompilarPara_TOTEMTOUCH)) ) }
                  if (aIdUnidade = dmUnidades.UnidadeAtiva) and
                     (FrmProcessoParalelo(aIdUnidade) <> nil) then
                    FrmProcessoParalelo(aIdUnidade).UpdateNomeCliente(StrToInt(Senha), Aux);
                  {$ENDIF}
                  {$ENDIF CompilarPara_TGS_ONLINE}
                end;

              // ****************************************************************************************************
              // RE: Agendamentos por fila de uma senha
              // ****************************************************************************************************
              $C3: begin
                     Senha  := Copy(ProtData, 1, Pos(';', ProtData) - 1);

                     if PA > 0 then  //PA é o campo ADR do protocolo inteiro
                     begin
                       LDMClient.LimparAgendamentos(PA);

                       aux := Copy(ProtData, Pos(';', ProtData) + 1);
                       { NF := StrToInt('$'+aux[1]+aux[2]+aux[3]+aux[4]); }
                       aux := Copy(aux,5);

                       aux2 := '';
                       for i := 1 to length (aux) do
                       begin
                         if aux[i] = TAB then
                         begin
                           Fila  := StrToInt('$'+Copy(aux2,1,4));
                           aux2 := Copy (aux2, 5, length(aux2)-4);
                           if length(aux2) = 4 then
                           begin
                             hh := strtoint(Copy(aux2, 1, 2));
                             nn := strtoint(Copy(aux2, 3, 2));
                             DataHora := Today + EncodeTime(hh, nn, 0, 0);
                           end
                           else if length(aux2) = 12 then
                           begin
                             dd := strtoint(Copy(aux2,  1, 2));
                             mm := strtoint(Copy(aux2,  3, 2));
                             yy := strtoint(Copy(aux2,  5, 4));
                             hh := strtoint(Copy(aux2,  9, 2));
                             nn := strtoint(Copy(aux2, 11, 2));
                             DataHora := EncodeDate(dd, mm, yy) + EncodeTime(hh, nn, 0, 0);
                           end
                           else
                             DataHora := 0;

                           LDMClient.InsertAgendamentoFila(PA, strtoint(Senha), Fila, DataHora);

                           aux2 := '';
                         end
                         else if aux[i] <> ETX then
                           aux2 := aux2 + aux[i];
                       end;
                     end;
                   end;

              // ****************************************************************************************************
              // Re: Nomes das TAGs
              // ****************************************************************************************************
              // comando alterado a partir daqui
              $AA: // antigo 80
                begin
                  LDMClient.cdsTags.EmptyDataSet;

                  Aux   := ProtData;
                  Aux   := Copy(Aux, 9, Length(Aux) - 8);
                  Aux2  := '';
                  for I := 1 to Length(Aux) do
                  begin
                    if Aux[I] = TAB then
                    begin
                      IdTAG := StrToInt('$' + Copy(Aux2, 1, 4));
                      Cor   := StrToInt('$' + Copy(Aux2, 5, 6));
                      Aux2  := Copy(Aux2, 11, Length(Aux2) - 10);
                      SeparaStrings(Aux2, ';', Grupo, Nome);

                      if Grupo = '' then
                        Grupo := '-1';

                      LDMClient.InsertTAG(IdTAG, Nome, StrToInt(Grupo), Cor);

                      Aux2 := '';
                    end
                    else if Aux[I] <> ETX then
                      Aux2 := Aux2 + Aux[I];
                  end;

    {$IFDEF CompilarPara_MULTIPA}
                  //if Assigned(dmUnidades.FormClient) then
                    //dmUnidades.FormClient.CriarTAGs;
    {$ENDIF}

                  LDMClient.ConfiguradoTAG := True;
                end;

              $B2: // antigo 8D
                begin
                  ParametrosModuloSICS;
                end;
    {$ENDREGION}
    {$REGION 'Comandos global except TV'}
    {$IFNDEF CompilarPara_TV}

              // ****************************************************************************************************
              // RE: Situação do atendimento, por PAs
              // ****************************************************************************************************
              $3C: begin
                         {$IFDEF DEBUG}
                         TLog.MyLog('[DEBUG Comando 3C Início]', nil, 0, false, TCriticalLog.tlDEBUG);
                         {$ENDIF}

                         if LDMClient.ConfiguradoPA then
                         begin
                           {$IFDEF CompilarPara_TGS_ONLINE}
                           LFraSituacaoAtendimento := nil;
                           {$ENDIF CompilarPara_TGS_ONLINE}

                           Aux := ProtData;
                           Aux := TAB + Copy(Aux, 5, Length(Aux) - 4);

                           {$IFDEF CompilarPara_TGS_ONLINE}
                           if Aux <> UltimoProt3C then
                           {$ENDIF CompilarPara_TGS_ONLINE}
                           begin
                             Aux2  := '';
                             for I := 2 to Length(Aux) do
                             begin
                               if Aux[I] = TAB then
                               begin
                                 LPAAux := StrToInt('$' + Copy(Aux2, 1, 4));

                                 {$IFDEF CompilarPara_TGS_ONLINE}
                                 if AlterouStatusPA(LPAAux, UltimoProt3C, Aux) then
                                 {$ENDIF CompilarPara_TGS_ONLINE}
                                 begin
                                   if Copy(Aux2, 19, 4) = '----' then
                                     StatusPA := -1
                                   else
                                     StatusPA := StrToInt('$' + Copy(Aux2, 19, 4));

                                   {$IF Defined(CompilarPara_PA_MULTIPA) or Defined(CompilarPara_TGS_ONLINE)}
                                   if Copy(Aux2, 23, 4) = '----' then
                                     Atendente := -1
                                   else
                                     Atendente := StrToInt('$' + Copy(Aux2, 23, 4));
                                   {$ENDIF}

                                   if Copy(Aux2, 31, 4) = '----' then
                                     MotivoPausa := -1
                                   else
                                     MotivoPausa := StrToInt('$' + Copy(Aux2, 31, 4));
                                   Senha         := Copy(Aux2, 35, Pos(';', Aux2) - 35);
                                   Nome          := Copy(Aux2, Pos(';', Aux2) + 1, Length(Aux2) - Pos(';', Aux2));

                                   {$IFDEF CompilarPara_PA_MULTIPA}
                                   if Assigned(dmUnidades.FormClient) and (dmUnidades.FormClient.IDUnidade = aIdUnidade) then
                                   begin
                                     dmUnidades.FormClient.UpdateAtdStatus(LPAAux, StatusPA, MotivoPausa, Atendente, Senha, Nome);
                                   end;

                                   if Senha <> '---' then
                                   begin
                                     LDMClient.LimparAgendamentos(LPAAux);

                                     SolicitarTAGs(LPAAux, Senha, aIdUnidade);
                                     SolicitarNomeCliente(LPAAux, Senha, aIdUnidade);
                                     SolicitarAgendamentosFilas(LPAAux, Senha, aIdUnidade);
                                     //SolicitarDadosAdicionais(LPAAux, Senha, aIdUnidade);
                                   end;
                                   {$ENDIF}

                                   {$IFDEF CompilarPara_TGS_ONLINE}
                                   if Copy(Aux2, 27, 4) = '----' then
                                     Fila := -1
                                   else
                                     Fila := StrToInt('$' + Copy(Aux2, 27, 4));
                                   TIM    := EncodeDate(StrToInt(Aux2[9] + Aux2[10] + Aux2[11] + Aux2[12]), StrToInt(Aux2[7] + Aux2[8]), StrToInt(Aux2[5] + Aux2[6])) + EncodeTime(StrToInt(Aux2[13] + Aux2[14]), StrToInt(Aux2[15] + Aux2[16]), StrToInt(Aux2[17] + Aux2[18]), 0);
                                   if (aIdUnidade = dmUnidades.UnidadeAtiva) then
                                   begin
                                     if LFraSituacaoAtendimento = nil then
                                     begin
                                       LFraSituacaoAtendimento := FraSituacaoAtendimento(aIdUnidade);
                                       LFraSituacaoAtendimento.PreLoader := SHOW;
                                       LFraSituacaoAtendimento.MaxRecords := Length(Aux);
                                     end;

                                     LFraSituacaoAtendimento.UpdateProgress(i);
                                     LFraSituacaoAtendimento.UpdatePASituation(LPAAux, StatusPA, Atendente, Senha, Fila, MotivoPausa, TIM, Nome);
                                  end;
                                   {$ENDIF}
                                 end;

                                 Aux2 := '';
                               end
                               else if Aux[I] <> ETX then
                               begin
                                 Aux2 := Aux2 + Aux[I];
                               end;
                             end;

                             {$IFDEF CompilarPara_TGS_ONLINE}
                             if Aux2 <> '' then
                               WarningMessage('Texto maior do que o esperado.');

                             if Assigned(LFraSituacaoAtendimento) then
                             begin
                               LFraSituacaoAtendimento.RepaintGrid;

                               LFraSituacaoAtendimento.PreLoader := not SHOW;
                             end;
                             {$ENDIF}

                             UltimoProt3C := Aux;
                           end;
                         end;

                         {$IFDEF DEBUG}
                         TLog.MyLog('[DEBUG Comando 3C Fim]', nil, 0, false, TCriticalLog.tlDEBUG);
                         {$ENDIF}
                   end;
              // ****************************************************************************************************
              // RE: Nomes das PAs
              // ****************************************************************************************************
              $3E:
                begin
                  LDMClient.cdsPAs.EmptyDataSet;

                  Aux            := ProtData;
                  Aux            := Copy(Aux, 9, Length(Aux) - 8);
                  Aux2           := '';
                  for I          := 1 to Length(Aux) do
                  begin
                    if Aux[I] = TAB then
                    begin
                      LPAAux   := StrToInt('$' + Copy(Aux2, 1, 4));
                      Aux2 := Copy(Aux2, 5, Length(Aux2) - 4);
                      SeparaStrings(Aux2, ';', Nome, Grupo);

                      if Grupo = '' then
                        LDMClient.InsertPA(LPAAux, Nome, -1)
                      else
                        LDMClient.InsertPA(LPAAux, Nome, StrToInt(Grupo));

                      Aux2 := '';
                    end
                    else if Aux[I] <> ETX then
                      Aux2 := Aux2 + Aux[I];
                  end;

                  if aIdUnidade = dmUnidades.UnidadeAtiva then
                    ConfiguraClienteAposCarregarPA(aIdUnidade);

                  if Aux2 <> '' then
                    WarningMessage('Texto maior do que o esperado. Caso $' + IntToStr(Ord(S[4])));
                end;

              // ****************************************************************************************************
              // RE: Tabela de PPs
              // ****************************************************************************************************
              $40:
                begin
                  LDMClient.cdsPPs.EmptyDataSet;

    {$IFDEF CompilarPara_PA_MULTIPA}

                  if (aIdUnidade = dmUnidades.UnidadeAtiva) then
                    FrmSelecaoPP(aIdUnidade).Lista.Clear;

    {$ENDIF CompilarPara_PA_MULTIPA}

                  Aux   := ProtData;
                  Aux   := Copy(Aux, 9, Length(Aux) - 8);
                  Aux2  := '';
                  for I := 1 to Length(Aux) do
                  begin
                    if Aux[I] = TAB then
                    begin
                      IdPP := StrToInt('$' + Copy(Aux2, 1, 4));
                      Cor  := StrToInt('$' + Copy(Aux2, 5, 6));
                      Aux2 := Copy(Aux2, 11, Length(Aux2) - 10);
                      SeparaStrings(Aux2, ';', Grupo, Nome);

                      if Grupo = '' then
                        Grupo := '-1';


                      LDMClient.InsertPP(IdPP, Nome, StrToInt(Grupo), Cor);
    {$IFDEF CompilarPara_PA_MULTIPA}
                      if (aIdUnidade = dmUnidades.UnidadeAtiva) then
                      begin
                        LFrmSelecaoPP := FrmSelecaoPP(aIdUnidade);
                        if Assigned(LFrmSelecaoPP) then
                          LFrmSelecaoPP.Incluir(IdPP, Nome);
                      end;
    {$ENDIF CompilarPara_PA_MULTIPA}



                      Aux2 := '';
                    end
                    else if Aux[I] <> ETX then
                      Aux2 := Aux2 + Aux[I];
                  end;

                  {$IF ((not Defined(CompilarPara_SICSTV)) and
                        (not Defined(CompilarPara_CALLCENTER)) and
                        (not Defined(CompilarPara_TOTEMTOUCH))) }
                  if (aIdUnidade = dmUnidades.UnidadeAtiva) then
                  begin
                    LFrmProcessoParalelo := FrmProcessoParalelo(aIdUnidade);
                    if Assigned(LFrmProcessoParalelo) then
                      LFrmProcessoParalelo.AtualizaLookUps;
                  end;
                  {$ENDIF}

                  LDMClient.ConfiguradoPP := True;
                end;

              // ****************************************************************************************************
              // RE: Tabela de Motivos de Pausa
              // ****************************************************************************************************
              $42:
                begin
                  LDMClient.cdsMotivosPausa.EmptyDataSet;

    {$IFDEF CompilarPara_PA_MULTIPA}
                  if (aIdUnidade = dmUnidades.UnidadeAtiva) then
                    FrmSelecaoMotivoPausa(aIdUnidade).Lista.Clear;
    {$ENDIF CompilarPara_PA_MULTIPA}

                  Aux   := ProtData;
                  Aux   := Copy(Aux, 5, Length(Aux) - 4);
                  Aux2  := '';
                  for I := 1 to Length(Aux) do
                  begin
                    if Aux[I] = TAB then
                    begin
                      IdMP := StrToInt('$' + Copy(Aux2, 1, 4));
                      Cor  := StrToInt('$' + Copy(Aux2, 5, 6));
                      Aux2 := Copy(Aux2, 11, Length(Aux2) - 10);
                      SeparaStrings(Aux2, ';', Grupo, Nome);

                      if Grupo = '' then
                        Grupo := '-1';

                      LDMClient.InsertMotivoPausa(IdMP, Nome, StrToInt(Grupo), Cor);

    {$IFDEF CompilarPara_PA_MULTIPA}
                      if (aIdUnidade = dmUnidades.UnidadeAtiva) then
                      begin
                        LFrmSelecaoMotivoPausa := FrmSelecaoMotivoPausa(aIdUnidade);
                        if Assigned(LFrmSelecaoMotivoPausa) then
                          LFrmSelecaoMotivoPausa.Incluir(IdMP, Nome);
                      end;
    {$ENDIF CompilarPara_PA_MULTIPA}


                      Aux2 := '';
                    end
                    else if Aux[I] <> ETX then
                      Aux2 := Aux2 + Aux[I];
                  end;

    {$IFDEF CompilarPara_TGS_ONLINE}
                  if (aIdUnidade = dmUnidades.UnidadeAtiva) then
                  begin
                    LFraSituacaoAtendimento := FraSituacaoAtendimento(aIdUnidade);
                    if Assigned(LFraSituacaoAtendimento) then
                      LFraSituacaoAtendimento.AtualizaLookUps;
                  end;
    {$ENDIF CompilarPara_TGS_ONLINE}

                  LDMClient.ConfiguradoMotivoPausa := True;
                end;

              {$IF ((not Defined(CompilarPara_SICSTV)) and
                    (not Defined(CompilarPara_CALLCENTER)) and
                    (not Defined(CompilarPara_TOTEMTOUCH))) }
              // ****************************************************************************************************
              // RE: Situação dos processos paralelos
              // ****************************************************************************************************
              $59:
                begin
                  Aux := ProtData;

    {$IFDEF CompilarPara_TGS_ONLINE}

                  if Aux <> UltimoProt59 then

    {$ENDIF CompilarPara_TGS_ONLINE}

                  begin
                    if (aIdUnidade = dmUnidades.UnidadeAtiva) then
                      FrmProcessoParalelo(aIdUnidade).IniciarAtualizacao;

                    Aux2  := '';
                    for I := 1 to Length(Aux) do
                    begin
                      if Aux[I] = TAB then
                      begin
                        SeparaStrings(Aux2, ';', Aux4, Aux3);

                        IdEventoPP := StrToInt(Aux4);

                        IdPP := StrToInt('$' + Copy(Aux3, 1, 4));

                        if Copy(Aux3, 5, 4) = '----' then
                          LPAAux := -1
                        else
                          LPAAux := StrToInt('$' + Copy(Aux3, 5, 4));

                        if Copy(Aux3, 9, 4) = '----' then
                          Atendente := -1
                        else
                          Atendente := StrToInt('$' + Copy(Aux3, 9, 4));

                        TIM := EncodeDate(StrToInt(Aux3[17] + Aux3[18] + Aux3[19] + Aux3[20]), StrToInt(Aux3[15] + Aux3[16]), StrToInt(Aux3[13] + Aux3[14])) + EncodeTime(StrToInt(Aux3[21] + Aux3[22]), StrToInt(Aux3[23] + Aux3[24]), StrToInt(Aux3[25] + Aux3[26]), 0);


                        Aux2 := Aux3;
                        SeparaStrings(Aux2, ';', Aux3, Aux4);
                        Senha := Copy(Aux3, 27, Length(Aux3) - 26);
                        Nome := Aux4;

                        if (aIdUnidade = dmUnidades.UnidadeAtiva) then
                          FrmProcessoParalelo(aIdUnidade).UpdatePPSituation(IdEventoPP, IdPP, LPAAux, Atendente, StrToInt(Senha), Nome, TIM);

                        Aux2 := '';
                      end
                      else if Aux[I] <> ETX then
                        Aux2 := Aux2 + Aux[I];
                    end;
                    if Aux2 <> '' then
                      WarningMessage('Texto maior do que o esperado.');

                    UltimoProt59 := Aux;

                    if (aIdUnidade = dmUnidades.UnidadeAtiva) then
                    begin
                      LFrmProcessoParalelo := FrmProcessoParalelo(aIdUnidade);
                      if Assigned(LFrmProcessoParalelo) then
                        LFrmProcessoParalelo.ConcluirAtualizacao;
                    end;
                  end;
                end;
              {$ENDIF}

              // ****************************************************************************************************
              // RE: Nome, login, grupo, senha e ativo de atendentes,
              // também utilizado para solicitar alteração de dados para um atendente
              // OBS: Servidor sempre envia somente os ativos
              // ****************************************************************************************************
              $72:
                begin
                  LDMClient.cdsAtendentes.EmptyDataSet;

                  Aux   := ProtData;
                  Aux   := Copy(Aux, 5, Length(Aux) - 4);
                  Aux2  := '';
                  for I := 1 to Length(Aux) do
                  begin
                    if Aux[I] = TAB then
                    begin
                      Senha         := '';
                      Grupo         := '';
                      Nome          := '';
                      RegFuncional  := '';
                      Atendente     := StrToInt('$' + Copy(Aux2, 1, 4));
                      Aux2          := Copy(Aux2, 5, Length(Aux2) - 4);
                      SeparaStrings(Aux2, ';', Nome, Aux2);
                      SeparaStrings(Aux2, ';', RegFuncional, Aux2);
                      SeparaStrings(Aux2, ';', Grupo, Aux2);
                      if Grupo = '' then
                        Grupo := '-1';
                      SeparaStrings(Aux2, ';', Senha, LLogin);

                      LDMClient.InsertAtd(Atendente, Nome, RegFuncional, Senha, LLogin, StrToInt(Grupo));

                      Aux2 := '';
                    end
                    else if Aux[I] <> ETX then
                      Aux2 := Aux2 + Aux[I];
                  end;
                  if (aIdUnidade = dmUnidades.UnidadeAtiva) then
                    ConfiguraClienteAposCarregarAtend(aIdUnidade);
                end;

              // ****************************************************************************************************
              // RE: Nomes dos Grupos (PAs, Atendentes, Filas, TAGs, PPs, etc)
              // ****************************************************************************************************
              $79:
                begin
                  case S[7] of
                    'A':
                      begin
                        LDMClient.cdsGruposDeAtendentes.EmptyDataSet;
                        {$IFDEF CompilarPara_TGS}
                        if (aIdUnidade = dmUnidades.UnidadeAtiva) then
                          frmSelecaoGrupoAtendente(aIdUnidade).Lista.Clear;
                        {$ENDIF CompilarPara_TGS}
                      end;
                    'P':
                      LDMClient.cdsGruposDePAs.EmptyDataSet;
                    'T':
                      LDMClient.cdsGruposDeTAGs.EmptyDataSet;
                    'p':
                      LDMClient.cdsGruposDePPs.EmptyDataSet;
                    'M':
                      LDMClient.cdsGruposDeMotivosPausa.EmptyDataSet;
                  else
                    Exit;
                  end;
                  Aux   := Copy(S, 12, Length(S) - 11);
                  Aux2  := '';
                  for I := 1 to Length(Aux) do
                  begin
                    if Aux[I] = TAB then
                    begin
                      Grupo := Copy(Aux2, 1, 4);
                      Nome  := Copy(Aux2, 5, Length(Aux2) - 4);

                      case S[7] of
                        'A':
                          begin
                            LDMClient.InsertGrupoAtd(StrToInt('$' + Grupo), Nome);
                             {$IFDEF CompilarPara_TGS}
                             if (aIdUnidade = dmUnidades.UnidadeAtiva) then
                              frmSelecaoGrupoAtendente(aIdUnidade).Incluir(StrToInt('$' + Grupo),Nome);
                             {$ENDIF CompilarPara_TGS}
                          end;
                        'P':
                          LDMClient.InsertGrupoPA(StrToInt('$' + Grupo), Nome);
                        'T':
                          LDMClient.InsertGrupoTAG(StrToInt('$' + Grupo), Nome);
                        'p':
                          LDMClient.InsertGrupoPP(StrToInt('$' + Grupo), Nome);
                        'M':
                          LDMClient.InsertGrupoMotivoPausa(StrToInt('$' + Grupo), Nome);
                      else
                        Exit;
                      end;

                      Aux2 := '';
                    end
                    else if Aux[I] <> ETX then
                      Aux2 := Aux2 + Aux[I];
                  end;

                  case S[7] of
    //                'A':
    //                  ConfiguradoGrupoAtendente := True;
    //                'P':
    //                  ConfiguradoGrupoPA := True;
                    'T':
                      LDMClient.ConfiguradoGrupoTAG := True;
                    'p':
                      LDMClient.ConfiguradoGrupoPP := True;
                    'M':
                      LDMClient.ConfiguradoGrupoMotivoPausa := True;
                  end;

                  if Aux2 <> '' then
                    WarningMessage('Texto maior do que o esperado. Caso $' + IntToStr(Ord(S[4])));
                end;

              // ****************************************************************************************************
              // RE: Nomes e cores das filas
              // ****************************************************************************************************
              $7C:
                begin
                  Aux := ProtData;

    {$IFDEF CompilarPara_PA_MULTIPA}
                  if (aIdUnidade = dmUnidades.UnidadeAtiva) then
                    FrmSelecaoFila(aIdUnidade).Lista.Clear;
    {$ENDIF}

                  {$IFDEF CompilarPara_TGS}
                  // analisar quando for migrar o referido modulo
                  if (aIdUnidade = dmUnidades.UnidadeAtiva) then
                  begin
                    LfrmLines := frmLines(aIdUnidade);
                    if Assigned(LfrmLines) then
                      LfrmLines.ClearGrid;
                  end;
                  {$ENDIF CompilarPara_TGS}

                  LDMClient.cdsFilas.EmptyDataSet;
    {$IFDEF CompilarPara_ONLINE}
                  if (aIdUnidade = dmUnidades.UnidadeAtiva) then
                  begin
                    LFraSituacaoEspera := FraSituacaoEspera(aIDUnidade);
                    LFraSituacaoEspera.BeginUpdate;
                  end;
    {$ENDIF CompilarPara_ONLINE}
                  Aux   := Copy(Aux, 5, Length(Aux) - 4);
                  Aux2  := '';
                  for I := 1 to Length(Aux) do
                  begin
                    if Aux[I] = TAB then
                    begin
                      Fila      := StrToInt('$' + Copy(Aux2, 1, 4));
                      Nome      := Copy(Aux2, 48, Pos(';', Aux2) - 48);
                      NomeTotem := Copy(Aux2, Pos(';', Aux2) + 1, Length(Aux2));
                      Cor       := StrToIntDef('$' + Copy(Aux2, 5, 6), -1);
                      LimiarAmarelo := Copy(Aux2,11,8);
                      LimiarVermelho := Copy(Aux2,19,8);
                      LimiarLaranja := Copy(Aux2,27,8);
                      Fonte := Copy(Aux2,35,13);

                      LDMClient.InsertFila(Fila, Nome, Cor);

                      {$IFDEF CompilarPara_PA_MULTIPA}
                        if (aIdUnidade = dmUnidades.UnidadeAtiva) then
                        begin
                          LFrmSelecaoFila := FrmSelecaoFila(aIdUnidade);
                          if Assigned(LFrmSelecaoFila) then
                            LFrmSelecaoFila.Incluir(Fila, Nome);
                        end;
                      {$ENDIF}

                      {$IFDEF CompilarPara_TGS}
                        if (aIdUnidade = dmUnidades.UnidadeAtiva) then
                        begin
                          LfrmLines := frmLines(aIdUnidade);
                          if Assigned(LfrmLines) then
                            LfrmLines.InsertFila(Fila, Nome);
                        end;
                      {$ENDIF}
                      {$IFDEF CompilarPara_ONLINE}
                        if ((not LFraSituacaoEspera.ExisteAFila(Fila)) and (LFraSituacaoEspera.FilaEhPermitida(Fila))) then
                          LFraSituacaoEspera.CriaComponenteFila(Fila, Nome, Cor,LimiarAmarelo,LimiarVermelho,LimiarLaranja,Fonte);
                      {$ENDIF }

                      {$IFDEF CompilarPara_CALLCENTER}
                        LFrmSelecaoFila := FrmSelecaoFila(IdUnidade,True,Nil);
                        if Assigned(LFrmSelecaoFila) then
                          LFrmSelecaoFila.Incluir(Fila, Nome);
                      {$ENDIF}


                      Aux2 := '';
                    end
                    else if Aux[I] <> ETX then
                      Aux2 := Aux2 + Aux[I];
                  end;

                  {$IFDEF CompilarPara_ONLINE}
                    if Assigned(LFraSituacaoEspera) then
                    begin
                      LFraSituacaoEspera.FrameResize(LFraSituacaoEspera);
                      LFraSituacaoEspera.EndUpdate;
                    end;

                    if Assigned(dmUnidades.FormClient) and (aIdUnidade = dmUnidades.UnidadeAtiva) then
                      dmUnidades.FormClient.AlinhaComponentesNaTela;
                  {$ENDIF CompilarPara_ONLINE}

                  //*** IMPLEMENTAR TRATAMENTO DAS FILAS NO CALL CENTER.

                  //ConfiguradoFila := True;

                  if Aux2 <> '' then
                    WarningMessage('Texto maior que o esperado.');
                end;

    {$ENDIF CompilarPara_TV}
    {$ENDREGION}
    {$REGION 'Comandos para PA ou MultiPA'}
    {$IFDEF CompilarPara_PA_MULTIPA}

              // ****************************************************************************************************
              // RE: Número de senhas em espera, por PA
              // ****************************************************************************************************
              $3B:
                begin
                  Aux   := Copy(S, 7, Length(S) - 6);
                  Aux   := Copy(Aux, 5, Length(Aux) - 4);
                  Aux2  := '';
                  for I := 1 to Length(Aux) do
                  begin
                    if Aux[I] = TAB then
                    begin
                      LPAAux        := StrToInt('$' + Copy(Aux2, 1, 4));
                      QtdeSenha := StrToInt('$' + Copy(Aux2, 5, 4));
                      Aux2      := '';

    {$IFDEF CompilarPara_PA_MULTIPA}
                      if ValidarPA(LPAAux, aIdUnidade) then
                      begin
                        if Assigned(dmUnidades.FormClient) then
                          dmUnidades.FormClient.AtualizarEspera(LPAAux, QtdeSenha, True);
                      end;
    {$ENDIF CompilarPara_PA_MULTIPA}
    {$IFDEF CompilarPara_PA}

                      if LPAAux = LDMClient.FCurrentPA then
                        Break;

    {$ENDIF CompilarPara_PA}

                    end
                    else if Aux[I] <> ETX then
                      Aux2 := Aux2 + Aux[I];
                  end;
                  if Aux2 <> '' then
                    WarningMessage('Texto maior do que o esperado.');

                  // TESTE//
                  // EnviarComando(TAspEncode.AspIntToHex(PA, 4) + Chr($28), aIdUnidade);
                end;

              // ****************************************************************************************************
              // RE: Não chamou nenhuma senha - SENHA NÃO SE ENCONTRA EM NENHUMA FILA
              // ****************************************************************************************************
              $50:
                begin
                  // trazer para frente (verificar como fazer no FMX)
                  Senha := ProtData;
                  LSituacaoPAAoExibirForm := dmUnidades.FormClient.GetSituacaoAtualPA(PA);
                  LSituacaoFrmSelecaoFila := FrmSelecaoFila(aIdUnidade).GetSituacaoAtual;
                  ConfirmationMessage('Senha solicitada (' + Senha + ') não se encontra em nenhuma fila!'#13'Chamar mesmo assim?',
                    procedure (const aOK: Boolean)
                    begin
                      if aOK then
                      begin
                        if (LSituacaoPAAoExibirForm = dmUnidades.FormClient.GetSituacaoAtualPA(PA)) and
                           (LSituacaoFrmSelecaoFila = FrmSelecaoFila(aIdUnidade).GetSituacaoAtual) then
                        begin
                          if ((not vgParametrosModulo.ManualRedirect)

                              {$IFDEF CompilarPara_PA_MULTIPA}
                              or (Assigned(dmUnidades.FormClient) and (not dmUnidades.FormClient.EstaEmAtendimento(PA)))
                              {$ENDIF CompilarPara_PA_MULTIPA}

                            or (FrmSelecaoFila(aIdUnidade).Lista.ItemIndex <= 0)) then
                            ForcarChamada(PA, StrToInt(Senha), aIdUnidade)
                          else
                            Redirecionar_ForcarChamada(PA, FrmSelecaoFila(aIdUnidade).IdSelecionado, StrToInt(Senha), aIdUnidade);
                        end
                        else
                          ErrorMessage(Format('A situação da PA foi alterada. Situação do atendimento anterior "%s" para "%s", situação da seleção anterior "%s" para "%s"',
                            [LSituacaoPAAoExibirForm, dmUnidades.FormClient.GetSituacaoAtualPA(PA),
                              LSituacaoFrmSelecaoFila, FrmSelecaoFila(aIdUnidade).GetSituacaoAtual]));
                      end
                      else
                        InformationMessage('Operação abortada.');
                    end);
                end;

              // ****************************************************************************************************
              // RE: Não chamou nenhuma senha - SENHA NÃO SE ENCONTRA NAS PRIORIDADES DO ATENDENTE
              // ****************************************************************************************************
              $51:
                begin
                  // trazer para frente (verificar como fazer no FMX)
                  Senha := ProtData;
                  LSituacaoPAAoExibirForm := dmUnidades.FormClient.GetSituacaoAtualPA(PA);
                  LSituacaoFrmSelecaoFila := FrmSelecaoFila(aIdUnidade).GetSituacaoAtual;
                  ConfirmationMessage('Senha solicitada (' + Senha + ') se encontra em uma fila que não deveria ser atendida por este atendente!'#13'Chamar mesmo assim?',
                    procedure (const aOK: Boolean)
                    begin
                      if aOK then
                      begin
                        if (LSituacaoPAAoExibirForm = dmUnidades.FormClient.GetSituacaoAtualPA(PA)) and
                           (LSituacaoFrmSelecaoFila = FrmSelecaoFila(aIdUnidade).GetSituacaoAtual) then
                        begin
                          if ((not vgParametrosModulo.ManualRedirect) or (Assigned(dmUnidades.FormClient) and (not dmUnidades.FormClient.EstaEmAtendimento(PA))) or (FrmSelecaoFila(aIdUnidade).Lista.ItemIndex <= 0)) then
                            ForcarChamada(PA, StrToInt(Senha), aIdUnidade)
                          else
                            Redirecionar_ForcarChamada(PA, FrmSelecaoFila(aIdUnidade).IdSelecionado, StrToInt(Senha), aIdUnidade);
                        end
                        else
                          ErrorMessage(Format('A situação da PA foi alterada. Situação do atendimento anterior "%s" para "%s", situação da seleção anterior "%s" para "%s"',
                            [LSituacaoPAAoExibirForm, dmUnidades.FormClient.GetSituacaoAtualPA(PA),
                              LSituacaoFrmSelecaoFila, FrmSelecaoFila(aIdUnidade).GetSituacaoAtual]));
                      end
                      else
                        InformationMessage('Operação abortada.');
                    end);
                end;
              $A3 : begin
                      SeparaStrings(ProtData, TAB, sGruposDePAs, ProtData );
                      SeparaStrings(ProtData, TAB, sNomePI     , ProtData );
                      SeparaStrings(ProtData, TAB, sNomeNivel  , ProtData );
                      SeparaStrings(ProtData, TAB, sCorNivel   , sMensagem);

                      StrToIntArray(sGruposDePAs, GruposDePAs);

                      for i := Low(GruposDePAs) to High(GruposDePAs) do
                        if LDMClient.ExisteGrupoPA (GruposDePAs[i]) then
                        begin
                          if Assigned(dmUnidades.FormClient) then
                            dmUnidades.FormClient.ExibeMensagemDeAlarme(sNomePI, sNomeNivel, sCorNivel, sMensagem);
                          break;
                        end;
                    end;

              // ****************************************************************************************************
              // RE: Solicitação de login
              // ****************************************************************************************************
              $B4: // antigo 8F
                begin

                  if ProtData[1] = '0' then
                  begin
                    ErrorMessage('Login inválido ou senha não confere ou atendente não permitido nesta PA.');
                    FrmLogin(aIdUnidade).edtAtendente.Enabled := True;
                    FrmLogin(aIdUnidade).edtSenha.Enabled     := True;
                    FrmLogin(aIdUnidade).edtSenha.Text        :='';
                    if FrmLogin(aIdUnidade).Visible then
                      FrmLogin(aIdUnidade).edtAtendente.SetFocus;
                  end
                  else if ProtData[1] = '1' then
                  begin
                    if FrmLogin(aIdUnidade).Visible then
                      FrmLogin(aIdUnidade).Close;
                    SolicitarSituacaoPA(0, aIdUnidade);
                    {$IFDEF CompilarPara_PA}
                    EnviarComando(TAspEncode.AspIntToHex(vgParametrosModulo.IdPA, 4) + Chr($36), aIdUnidade);
                    {$ENDIF}
                  end;
                end;

              // ****************************************************************************************************
              // Re: TAG para uma determinada senha
              // ****************************************************************************************************
              $7E:
                begin
                  Aux := ProtData;
                  if Aux = '0' then
                  begin
                    // Sucesso (já existia na v4)
                  end
                  else
                  begin
                    // Erro ao definir TAG, decidir o que fazer  (já existia na v4)
                  end;
                end;

              // ****************************************************************************************************
              // Re: TAGs de uma senha específica
              // ****************************************************************************************************
              $AC: // antigo 82
                begin
                  Aux := ProtData;
                  SeparaStrings(Aux, ';', Senha, Aux2);
                  StrToIntArray(Aux2, TAGs);
                  if Assigned(dmUnidades.FormClient) then
                    dmUnidades.FormClient.SelecionarTAGs(PA, TAGs);
                end;
              // ****************************************************************************************************
              // Re: Desassociaçao de TAGs
              // ****************************************************************************************************
              $AE: // antigo 84
                begin
                  Aux := ProtData;
                  if Aux = '0' then
                  begin
                    // Sucesso (já existia na v4)
                  end
                  else
                  begin
                    // Erro ao definir a TAG, decidir o que fazer (já existia na v4)
                  end;
                end;
              // ****************************************************************************************************
              // Re: Obter Paineis do Tipo TV
              // ****************************************************************************************************
              $D0:  //LM
              begin
                Aux := ProtData;
                if Aux <> '' then
                begin
                  FrmControleRemoto.GetlistPainelTV(Aux);
                end;
              end;

              // ****************************************************************************************************
              // Re: Obter Lista de Pessoas nas Filas de Espera PA
              // ****************************************************************************************************
              $DD:  //AG
              begin
                // Fila, Senha, Nome, Horario
                  //LDMClient.cdsPessoasFilaEsperaPA.DisableControls;
                  try
                    LDMClient.cdsPessoasFilaEsperaPA.EmptyDataSet;
                    LProtRegistrosDataSeparado := SplitString(ProtData, TAB);
                    for LCount := low(LProtRegistrosDataSeparado) to high(LProtRegistrosDataSeparado) -1 do
                    begin
                      LProtFieldsDataSeparado := SplitString(LProtRegistrosDataSeparado[LCount], PONTO_E_VIRGULA);
                      Aux := EmptyStr;

                      if High(LProtFieldsDataSeparado) > Integer(TDadosPessoasNasFilas.dpfHorario) then
                        with TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(LProtFieldsDataSeparado[Integer(TDadosPessoasNasFilas.dpfObservacao)]), 0) as TJSONObject do
                        begin
                          TryGetValue('OBSERVACAO', Aux);
                          Free;
                        end;

                      LDMClient.InsertPessoasFilaEsperaPA(LProtFieldsDataSeparado
                        [Integer(TDadosPessoasNasFilas.dpfFila)],
                        StrToInt(LProtFieldsDataSeparado
                        [Integer(TDadosPessoasNasFilas.dpfSenha)]),
                        LProtFieldsDataSeparado
                        [Integer(TDadosPessoasNasFilas.dpfNome)],
                        LProtFieldsDataSeparado
                        [Integer(TDadosPessoasNasFilas.dpfProntuario)],
                        StrToTime(LProtFieldsDataSeparado
                        [Integer(TDadosPessoasNasFilas.dpfHorario)]),
                        Aux);

                        Finalize(LProtFieldsDataSeparado);
                    end;

                    Finalize(LProtRegistrosDataSeparado);
                    LDMClient.cdsPessoasFilaEsperaPA.First;
                  finally;
                    //LDMClient.cdsPessoasFilaEsperaPA.EnableControls;
                  end;
              end;

              $CE: // RE: Obter Dados Adicionais de uma senha
                begin
                  SeparaStrings(ProtData, TAB, Senha, Aux2);
                  Aux3 := Copy(Aux2, 2, Length(Aux2));
                  //if Assigned(dmUnidades.FormClient) then

                  with TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(Aux3), 0) as TJSONObject do
                  begin
                    if (TryGetValue('OBSERVACAO', Aux)) and (LDMClient.cdsPessoasFilaEsperaPA.Locate('Senha', Senha, [])) then
                    begin
                      LDMClient.cdsPessoasFilaEsperaPA.Edit;
                      LDMClient.cdsPessoasFilaEsperaPAObservacao.AsString := Aux;
                      LDMClient.cdsPessoasFilaEsperaPA.Post;
                    end;

                    Free;
                  end;

                  if dmUnidades.FormClient.SenhaAtual(PA) = Senha then
                    FJSONDadosAdicionais := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(Aux3), 0) as TJSONObject;

                  dmUnidades.FormClient.AtualizarObservacaoPA(PA);
                end;
    {$ENDIF CompilarPara_PA_MULTIPA}
    {$ENDREGION}
    {$REGION 'Comandos para TGS'}
    {$IFDEF CompilarPara_TGS}

              // ****************************************************************************************************
              // RE: Prioridades de atendimento redefinidas. Faça Refresh.
              // ****************************************************************************************************
              $26:
                begin
                  //Este comando era necessário quando o módulo TGS ficava
                  //conectado ao banco e alguma alteração das configurações de
                  //prioridade de atendimento eram feitas no servidor ou no
                  //OnLine. isso disparava um comando para notificar o TGS que
                  //ele precisava atualizar seus Datasets, para carregar as
                  //modificações. Como ele não olha mais para o BD neste ponto,
                  //o comando não é mais necessário.
                end;
              // ****************************************************************************************************
              // RE: Situação das filas
              // ****************************************************************************************************

              $35:
                begin
                  Aux   := ProtData;
                  Aux   := Copy(Aux, 5, Length(Aux) - 4);
                  Aux2  := '';
                  for I := 1 to Length(Aux) do
                  begin
                    if Aux[I] = TAB then
                    begin
                      Fila  := StrToInt('$' + Aux2[1] + Aux2[2] + Aux2[3] + Aux2[4]);
                      Senha := Aux2[5] + Aux2[6] + Aux2[7] + Aux2[8];
                      try
                        TIM := EncodeDate(StrToInt(Aux2[13] + Aux2[14] + Aux2[15] + Aux2[16]), StrToInt(Aux2[11] + Aux2[12]), StrToInt(Aux2[9] + Aux2[10])) + EncodeTime(StrToInt(Aux2[17] + Aux2[18]), StrToInt(Aux2[19] + Aux2[20]), StrToInt(Aux2[21] + Aux2[22]), 0);
                      except
                        TIM := EncodeDate(1, 1, 1) + EncodeTime(1, 1, 1, 1);
                      end;
                      if aIdUnidade = dmUnidades.UnidadeAtiva then
                      begin
                        LfrmLines := frmLines(aIdUnidade);
                        if Assigned(LFrmLines) then
                          LFrmLines.UpdateSituation(Fila, StrToInt('$' + Senha), TIM);
                      end;
                      Aux2 := '';
                    end
                    else if Aux[I] <> ETX then
                      Aux2 := Aux2 + Aux[I];
                  end;
                  if Aux2 <> '' then
                    MessageDlg('Texto maior do que deveria.', TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK], 0);
                end;
              // ****************************************************************************************************
              // RE: Novo atendente inserido
              // ****************************************************************************************************
              $75:
                begin
                  Aux       := ProtData;
                  Atendente := StrToInt('$' + Aux[1] + Aux[2] + Aux[3] + Aux[4]);

                  InformationMessage('Atendente inserido: #' + IntToStr(Atendente));
                end;

    {$ENDIF CompilarPara_TGS}
    {$ENDREGION}
    {$REGION 'Comandos para TGS, Online ou TV'}
    {$IF Defined(CompilarPara_TGS_ONLINE) or Defined(CompilarPara_TV) }

              // ****************************************************************************************************
              // RE: Nomes dos PIs
              // ****************************************************************************************************
              $65:
                begin
                  Aux   := ProtData;
                  Aux   := Copy(Aux, 9, Length(Aux) - 8);
                  Aux2  := '';
                  for I := 1 to Length(Aux) do
                  begin
                    if Aux[I] = TAB then
                    begin
                      CodPI := StrToInt('$' + Aux2[1] + Aux2[2] + Aux2[3] + Aux2[4]);
                      Nome  := Copy(Aux2, 5, Length(Aux2) - 4);
                      // implementar PIs
                      if ((dmUnidades.Quantidade > 1) or LDMClient.IsAllowedPI(CodPI)) then
                        LDMClient.AssociaNomePI(CodPI, Nome);
                      Aux2 := '';
                    end
                    else if Aux[I] <> ETX then
                      Aux2 := Aux2 + Aux[I];
                  end;
                  if Aux2 <> '' then
                    WarningMessage('Texto maior do que o esperado. Caso $' + IntToStr(Ord(S[4])));
                end;

              // ****************************************************************************************************
              // RE: Situação dos PIs
              // ****************************************************************************************************
              $67:
                begin
                  Aux := ProtData;
                  NPI := StrToInt('$' + Aux[1] + Aux[2] + Aux[3] + Aux[4]);
                  if NPI = 0 then
                  begin
                    if LDMClient.CDSPIs.Active then
                    begin
                      LDMClient.CDSPIs.First;
                      while not LDMClient.CDSPIs.eof do
                      begin
                        LDMClient.CDSPIs.Delete;
                      end;
                    end;
                  end
                  else
                  begin
                    Aux        := Copy(Aux, 5, Length(Aux) - 4);
                    Aux2       := '';
                    IndexPI    := 1;
                    TodosPIsOK := True;
                    for I      := 1 to Length(Aux) do
                    begin
                      if Aux[I] = TAB then
                      begin
                        CodPI    := StrToInt('$' + Aux2[1] + Aux2[2] + Aux2[3] + Aux2[4]);
                        EstadoPI := Aux2[5];
                        aux3     := Copy(Aux2, 6, Length(Aux2) - 5);
                        SeparaStrings (aux3, ';', Valor, LValorNumerico);
                        SeparaStrings (LValorNumerico, ';', LValorNumerico, LFlagValorEmSegundos);

                        if ((dmUnidades.Quantidade > 1) or LDMClient.IsAllowedPI(CodPI)) then
                        begin
                          TodosPIsOK := (LDMClient.AtualizaStatusPI(NPI, IndexPI, CodPI, EstadoPI, Valor, StrToIntDef(LValorNumerico, 0), (LFlagValorEmSegundos = '1')) and TodosPIsOK);
                          IndexPI    := IndexPI + 1;
                        end;
                        Aux2 := '';
                      end
                      else if Aux[I] <> ETX then
                        Aux2 := Aux2 + Aux[I];
                    end;
                    if Aux2 <> '' then
                      WarningMessage('Texto maior do que o esperado. Caso $' + IntToStr(Ord(S[4])));

                    if not TodosPIsOK then
                      EnviarComando(LgIdDoModulo + Chr($64), aIdUnidade);

    {$IFDEF CompilarPara_TV}

                    if TodosPIsOK and Assigned(FormClient) then
                      FormClient.AtualizaPanelsIndicadoresDesempenho;

    {$ENDIF CompilarPara_TV}

                  end;
                end;

    {$ENDIF}
    {$ENDREGION}
    {$REGION 'Comandos para TGS Online'}
    {$IFDEF CompilarPara_TGS_ONLINE}

              $CE: // RE: Obter Dados Adicionais de uma senha
                begin
                  Aux := ProtData;
                  SeparaStrings(Aux, TAB, Senha, Aux2);
                  Aux3 := Copy(Aux2, 2, Length(Aux2));
                  //if Assigned(dmUnidades.FormClient) then
                  {$IFDEF CompilarPara_ONLINE}
                  FJSONDadosAdicionais := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(Aux3), 0) as TJSONObject;
                  {$ENDIF CompilarPara_ONLINE}
                end;
              // ****************************************************************************************************
              // RE: Lista dos status das PAs
              // ****************************************************************************************************
              $2D:
                begin
                  LDMClient.cdsStatusPAs.EmptyDataSet;

                  Aux   := ProtData;
                  Aux   := Copy(Aux, 5, Length(Aux) - 4);
                  Aux2  := '';
                  for I := 1 to Length(Aux) do
                  begin
                    if Aux[I] = TAB then
                    begin

                      StatusPA := StrToInt('$' + Copy(Aux2, 1, 4));
                      Nome     := Copy(Aux2, 5, Length(Aux2) - 4);

                      LDMClient.InsertStatusPA(StatusPA, Nome);

                      Aux2 := '';
                    end
                    else if Aux[I] <> ETX then
                      Aux2 := Aux2 + Aux[I];
                  end;

                  if (aIdUnidade = dmUnidades.UnidadeAtiva) then
                  begin
                    LFraSituacaoAtendimento := FraSituacaoAtendimento(aIdUnidade);
                    if Assigned(LFraSituacaoAtendimento) then
                      LFraSituacaoAtendimento.AtualizaLookUps;
                  end;

                  LDMClient.ConfiguradoStatusPA := True;
                end;

    {$ENDIF CompilarPara_TGS_ONLINE}
    {$ENDREGION}
    {$REGION 'Comandos para Online'}
    {$IFDEF CompilarPara_ONLINE}
            {  $86:
                begin
                  aux := ProtData;
                  aux := Copy(aux,5,Length(aux)-4);
                  aux2 := '';
                  for i := 1 to length (aux) do
                  begin
                    if aux[i] = TAB then
                    begin
                      Fila := StrToInt('$'+Copy(aux2,1,4));
                      Cor  := StrToInt('$'+Copy(aux2,5,6));
                      Nome := Copy(aux2, 11, length(aux2)-10);
                      aux2 := '';
                    end
                    else if aux[i] <> ETX then
                      aux2 := aux2 + aux[i];
                  end;

                  if aux2 <> '' then
                    WarningMessage('Texto maior do que o esperado.' + #13 + 'Info - Senhas em espera');
                end;   }
              // ****************************************************************************************************
              // RE: Situação detalhada das senhas de uma ou mais filas
              // ****************************************************************************************************
              $6D:
                begin
                  if (aIdUnidade = dmUnidades.UnidadeAtiva) then
                  begin
                    LFraSituacaoEspera := FraSituacaoEspera(aIDUnidade);
                    Fila := StrToInt('$' + Copy(ProtData, 1, 4));
                    if LFraSituacaoEspera.ExisteAFila(Fila) then
                    begin
                      LFraSituacaoEspera.LimpaFila(Fila);
                      Aux  := Copy(S, 11, Length(S) - 10);
                      Aux2 := '';
                      d1   := 0;
                      m1   := 0;
                      y1   := 0;
                      h1   := 0;
                      n1   := 0;
                      s1   := 0;

                      for I := 1 to Length(Aux) do
                      begin
                        if Aux[I] = ';' then
                        begin
                          SeparaStrings(Aux2, TAB, Senha, Aux2);
                          SeparaStrings(Aux2, TAB, Nome, Aux2);
                          SeparaStrings(Aux2, TAB, TagsStr, Aux2);

                          if Pos(TAB, Aux2) > -1 then
                            SeparaStrings(Aux2, TAB, Prontuario, Aux2);
                          //if Nome<>'' then
                          HoraStr := Aux2;

                          if Pos(',', Senha) > 0 then
                            Senha := Copy(Senha, 1, Pos(',', Senha) - 1);

                          if Length(HoraStr) >= 2 then
                            s1 := StrToInt(HoraStr[1] + HoraStr[2]);
                          if Length(HoraStr) >= 4 then
                            n1 := StrToInt(HoraStr[3] + HoraStr[4]);
                          if Length(HoraStr) >= 6 then
                            h1 := StrToInt(HoraStr[5] + HoraStr[6]);
                          if Length(HoraStr) >= 8 then
                            d1 := StrToInt(HoraStr[7] + HoraStr[8]);
                          if Length(HoraStr) >= 10 then
                            m1 := StrToInt(HoraStr[9] + HoraStr[10]);
                          if Length(HoraStr) >= 14 then
                            y1 := StrToInt(HoraStr[11] + HoraStr[12] + HoraStr[13] + HoraStr[14]);

                          TIM := EncodeDate(y1, m1, d1) + EncodeTime(h1, n1, s1, 0);

                          StrToIntArray(TagsStr, TAGs);

                          LFraSituacaoEspera.InsertPswd(Fila, StrToInt(Senha), StrToInt(Prontuario), Nome, TIM, TAGs, -2, False);

                          Finalize(TAGs);
                          Aux2 := '';
                        end
                        else if Aux[I] <> #3 then
                          Aux2 := Aux2 + Aux[I];
                      end;
                    end;

                    LFraSituacaoEspera.AtivaLocalSQL(Fila);
                    LFraSituacaoEspera.RefreshGrid(Fila);
                  end;
                end;

              // ****************************************************************************************************
              // RE: Situação detalhada dos status "prioritária" e "bloqueada" das filas
              // ****************************************************************************************************
              $6F:
                begin
                  if (aIdUnidade = dmUnidades.UnidadeAtiva) then
                  begin
                    LFraSituacaoEspera := FraSituacaoEspera(aIDUnidade);
                    Aux   := ProtData;
                    Aux2  := '';
                    for I := 1 to Length(Aux) do
                    begin
                      if Aux[I] = TAB then
                      begin
                        Fila := StrToInt('$' + Copy(Aux2, 1, 4));
                        if Assigned(LFraSituacaoEspera) and LFraSituacaoEspera.ExisteAFila(Fila) then
                        begin
                          LFraSituacaoEspera.SetListBlocked(Fila, (Aux2[5] = '1'));
                          LFraSituacaoEspera.SetPrioritaryList(Fila, (Aux2[6] = '1'));
                        end;

                        Aux2 := '';
                      end
                      else if Aux[I] <> #3 then
                        Aux2 := Aux2 + Aux[I];
                    end;
                  end;
                end;
              // ****************************************************************************************************
              // RE: Nomes no totem e cores das filas
              // ****************************************************************************************************
              $B0: // antigo 86
                begin
                  Aux   := ProtData;
                  Aux   := Copy(Aux, 5, Length(Aux) - 4);
                  Aux2  := '';
                  for I := 1 to Length(Aux) do
                  begin
                    if Aux[I] = TAB then
                    begin
                      // Fila := StrToInt('$' + Copy(Aux2, 1, 4));
                      // Cor  := StrToInt('$' + Copy(Aux2, 5, 6));
                      // Nome := Copy(Aux2, 11, Length(Aux2) - 10);
                      // Aux2 := '';
                      // GOT 07.12 ... comentado até implementar form herdado base on-line
                      // FrmSicsOnLine.CriaComponenteTotem(Fila, Nome, Cor);
                    end
                    else if Aux[I] <> ETX then
                      Aux2 := Aux2 + Aux[I];
                  end;

                  // DM Verificar se a utilizade desse parâmetro
                  // ParametrosModuloDB.BotoesCriados := True;
                  // GOT 07.12 ... comentado para analisar posteriormente
                  // FrmTotemTouch.EscondePainelSemConexao;

                  if Aux2 <> '' then
                    WarningMessage('Texto maior que o esperado.');
                end;

               $AC: // antigo 82
                begin
                  Aux := ProtData;
                  SeparaStrings(Aux, ';', Senha, Aux2);
                  StrToIntArray(Aux2, TAGs);

                  //if Assigned(dmUnidades.FormClient) then
                    //dmUnidades.FormClient.SelecionarTAGs(PA, TAGs);
                end;

              // ****************************************************************************************************
              // Toca som quando gerado nova senha Call Center
              // ****************************************************************************************************
              $D9: //
                begin
                 //Senha + TAB + Fila + TAB + ID + TAB + Nome;
                  FrmSicsOnLine.TocaSomNovaSenha;
                end;

    {$ENDIF}
    {$ENDREGION}
    {$REGION 'Comandos para CallCenter'}
    {$IFDEF CompilarPara_CALLCENTER}
              $E1:
                begin
                  if ProtData[1] = 'T' then
                  begin
                    Delete(ProtData, 1, 2); //2, pq Apaga o T e o TAB
                    SeparaStrings(ProtData, TAB, Aux, Aux2);
                    frmsicsCallCenter.IdCliente := StrToInt(Aux);
                    SeparaStrings(Aux2, TAB, Aux, Aux2);
                    frmSicsCallCenter.NomeCliente := Aux;

                    if Assigned(FrmLogin(aIdUnidade)) then
                    begin
                      frmSicsCallCenter.SenhaLogin   := TextHash(FrmLogin(aIdUnidade).edtSenha.Text);
                      frmSicsCallCenter.ClienteLogin := FrmLogin(aIdUnidade).edtAtendente.Text;
                      FrmLogin(aIdUnidade).Close;
                    end;

                    frmSicsCallCenter.UpdateButtons;
                  end
                  else
                  begin
                    if ProtData[1] = 'F' then
                      WarningMessage(Copy(ProtData,3))
                    else
                      if ProtData[1] = 'L' then
                      begin
                        LFrmLoginGestor := FrmLoginGestor(IdUnidade, True);
                        LFrmLoginGestor.ShowModal;

                      end
                      else
                        ErrorMessage('Falha ao processar requisição.');

                    if Assigned(FrmLogin(aIdUnidade)) then
                    begin
                      FrmLogin(aIdUnidade).edtAtendente.Enabled := True;
                      FrmLogin(aIdUnidade).edtSenha.Enabled     := True;
                      FrmLogin(aIdUnidade).edtSenha.Text        := '';
                      FrmLogin(aIdUnidade).edtAtendente.SetFocus;
                    end;
                  end;
                end;

              $D4:
                begin
                  if ProtData[1] = 'T' then
                  begin
                    if Assigned(FrmLoginGestor(aIdUnidade)) then
                      FrmLoginGestor(aIdUnidade).Close;

                    frmSicsCallCenter.OcultarTelaAguardandoGestor;
                  end
                  else if ProtData[1] = 'E' then
                    ErrorMessage('Falha ao processar requisição.')
                  else
                  begin
                    WarningMessage(Trim(Copy(ProtData, 2)));
                    if FrmLoginGestor(aIdUnidade).Visible then
                      FrmLoginGestor(aIdUnidade).ListaAtds.SetFocus;
                  end;
                end;

              $D6:
                begin
                  if ProtData[1] = 'T' then
                  begin
                    frmSicsCallCenter.ExibirTelaAguardandoGestor;
                  end
                  else
                  begin
                    WarningMessage('Falha ao solicitar ajuda!');
                  end;
                end;

              $D8:
                begin
                  if ProtData[1] = 'T' then
                  begin
                    InformationMessage('Senha alterada.');
                  end
                  else
                  begin
                    WarningMessage('Falha ao alterar senha!');
                  end;
                end;

    {$ENDIF}
    {$ENDREGION}

              $CA, //retorno do $C9 - status de uma senha
              $C6, //retorno do $70 - com a senha que foi gerada para uma fila específica
              $B8, //retorno do $5D - com o status se conseguiu ou não fazer logout de uma PA
              $B9, //retorno do $28 - com o status se conseguiu ou não entrar em pausa
              $DF: //retorno do $DE - Senha gerada via solicitação do comando $DE
                begin

                end;
            else
              if (PA <> 0) then
                Tlog.MyLog(Format('Comando %d (dec) não existe. Linha: %s ', [Comando, S]), Self);
            end;

    {$ENDREGION}

          end
          else
            Result := False;
        finally
          {$IFDEF CompilarPara_PA_MULTIPA}                            //LBC VERIFICAR BUG #85
          if LBeginUpdatePA then                                      //LBC VERIFICAR BUG #85
            dmUnidades.FormClient.EndUpdatePA(PA);                    //LBC VERIFICAR BUG #85
          {$ENDIF CompilarPara_PA_MULTIPA}                            //LBC VERIFICAR BUG #85
        end;
      end
      else
        Result := False;
    except
      on E: exception do
      begin
        Result := False;
        TLog.TreatException('Erro ao decifrar protocolo: ' + S + '.', Socket, True);
        Exit;
      end;
    end;
  finally
    {$IFDEF DEBUG}
      Tlog.MyLog('[DEBUG ' + inttostr(DebugItem) + FormatDateTime(' hh:nn:ss,zzz]', now - DebugInicio) + ' DecifrarProtocolo Término: ' + s, nil, 0, false, TCriticalLog.tlDEBUG);
    {$ENDIF DEBUG}
  end;

end;

procedure TDMConnection.DataModuleCreate(Sender: TObject);
begin
  //como este componente (ClientSocketPrincipal) é da Indy,
  //não é necessário resolver manualmente o host do servidor,
  //que possivelmente virá do dmUnidades.IP[]
  ClientSocketPrincipal.host    := dmUnidades.IP[IdUnidade]; //vgParametrosSicsClient.TCPSrvAdr;
  ClientSocketPrincipal.Port    := dmUnidades.Porta[IdUnidade]; // vgParametrosSicsClient.TCPSrvPort;
  ClientSocketContingente.host  := EmptyStr; //vgParametrosSicsClient.TCPSrvAdrContingencia;
  ClientSocketContingente.Port  := 0; //vgParametrosSicsClient.TCPSrvPortContingencia;
  FIdModulo                     := dmUnidades.IDModulo[IdUnidade];

  //Timers criados em tempo de execução devido a restrições do Android
  tmrReconnect          := TTimer.Create(Application);
  tmrReconnect.Enabled  := false;
  tmrReconnect.OnTimer  := tmrReconnectTimer;
  tmrReconnect.Interval := vgParametrosSicsClient.IntervaloReconectar;

  tmrReceberComando          := TTimer.Create(Application);
  tmrReceberComando.Enabled  := false;
  tmrReceberComando.OnTimer  := tmrReceberComandoTimer;
  tmrReceberComando.Interval := vgParametrosSicsClient.IntervaloReceberComando;

  ListaComando               := TList<TComandoEnvia>.Create;

  //ValidaAppMultiInstancia;


  //todo o trecho que estava aqui, referente à inicialização dos forms, foi
  //movido para o método AfterConstruct, abaixo

  // dmClient
  {LDMClient := }DMClient(IdUnidade, true, GetApplication);
end;

procedure TDMConnection.DataModuleDestroy(Sender: TObject);
begin
  Sleep(1);
end;

procedure TDMConnection.AfterConstruction;
var
  LDMClient    : TDMClient;
begin
  inherited;

  // dmClient
  //LDMClient := DMClient(IdUnidade, true, GetApplication);
end;

procedure TDMConnection.DecifrarCodigoBarra(const S: string; const aIdUnidade: Integer);

{$IFDEF SuportaCodigoBarras}

var
  Senha: string;
  LDMClient: TDMClient;

  {$IFDEF CompilarPara_MULTIPA}
  LFrmLogin: TFrmLogin;
  RegFuncional    : string;
  I               : integer;
  AchouPA         : Boolean;

  procedure DestacaPA(const PA: integer);
  var
    rec: TRectangle;
  begin
    if Assigned(dmUnidades.FormClient) then
    begin
      rec := dmUnidades.FormClient.GetRecCodigoBarras(PA);
      if Assigned(rec) then
        rec.Visible := True;
    end;
  end;
  {$ENDIF CompilarPara_MULTIPA}

begin
  if ((S <> '') and (S[1] = '/') and (S[Length(S)] = '\')) then
  begin
     LDMClient := DMClient(aIdUnidade, not CRIAR_SE_NAO_EXISTIR);

    {$IFDEF CompilarPara_MULTIPA}
    if ((Pos('PA:', S) > 0) or (Pos('PA', S) > 0)) then
    begin
      if Assigned(dmUnidades.FormClient) then
        LDMClient.tmrClearAtd.OnTimer(LDMClient.tmrClearAtd);

      if Pos('PA:', S) > 0 then
        LDMClient.FCurrentPA := StrToInt(Copy(S, Pos('PA:', S) + Length('PA:'), Length(S) - Pos('PA:', S) - Length('PA:')))
      else
        LDMClient.FCurrentPA := StrToInt(Copy(S, Pos('PA', S) + Length('PA'), Length(S) - Pos('PA', S) - Length('PA')));

      if Assigned(dmUnidades.FormClient)then
      begin
        LDMClient.FCurrentAtd         := dmUnidades.FormClient.GetCodAtendente(LDMClient.FCurrentPA);
        LDMClient.tmrClearAtd.Enabled := False;
        LDMClient.tmrClearAtd.Enabled := True;
        DestacaPA(LDMClient.FCurrentPA);
      end
      else
      begin
        LDMClient.FCurrentPA  := -1;
        LDMClient.FCurrentAtd := -1;
      end;
    end;

    if ((Pos('Atd:', S) > 0) or (Pos('ATD', S) > 0)) then
    begin
      if Assigned(dmUnidades.FormClient) then
        LDMClient.tmrClearAtd.OnTimer(LDMClient.tmrClearAtd);

      AchouPA := False;
      if Pos('Atd:', S) > 0 then
        LDMClient.FCurrentAtd := StrToInt(Copy(S, Pos('Atd:', S) + Length('Atd:'), Length(S) - Pos('Atd:', S) - Length('Atd:')))
      else
        LDMClient.FCurrentAtd := StrToInt(Copy(S, Pos('ATD', S) + Length('ATD'), Length(S) - Pos('ATD', S) - Length('ATD')));

      if Assigned(dmUnidades.FormClient) and (LDMClient.FCurrentAtd > -1) then
      begin
        for I := 0 to dmUnidades.FormClient.ComponentCount - 1 do
        begin
          if
          (Assigned(dmUnidades.FormClient.Components[I]) and (dmUnidades.FormClient.Components[I] is TLabel) and
          (Pos(TFrmBase_PA_MPA.cLblCodAtendente, dmUnidades.FormClient.Components[I].Name) > 0) and
          (StrToIntDef((dmUnidades.FormClient.Components[I] as TLabel).Text, -1) = LDMClient.FCurrentAtd)) then
          begin
            LDMClient.FCurrentPA := (dmUnidades.FormClient.Components[I] as TLabel).Tag;
            DestacaPA(LDMClient.FCurrentPA);
            LDMClient.tmrClearAtd.Enabled := True;
            AchouPA                      := True;
            Break;
          end;
        end;
      end;

      if not AchouPA then
      begin
        LFrmLogin := FrmLogin(aIDUnidade);
        if Assigned(LFrmLogin) then
        begin
    	    LFrmLogin.PA := LDMClient.FCurrentPA;
  	      LFrmLogin.edtAtendente.Text := IntToStr(LDMClient.FCurrentAtd) ;
        end;

        LDMClient.FCurrentPA  := -1;
        LDMClient.FCurrentAtd := -1;
        if Assigned(LFrmLogin) then
  		    LFrmLogin.Showmodal(nil);
      end;
    end;
    {$ENDIF}

    if ((Pos('Tck:', S) > 0) or (Pos('TCK', S) > 0)) then
    begin
      if Pos('Tck:', S) > 0 then
        Senha := Copy(S, Pos('Tck:', S) + Length('Tck:'), Length(S) - Pos('Tck:', S) - Length('Tck:'))
      else
        Senha := Copy(S, Pos('TCK', S) + Length('TCK'), Length(S) - Pos('TCK', S) - Length('TCK'));

      // nesse ponto, poderia ter uma validação se FCurrentPA <> -1 mas FCurrentAtd = -1
      // (atendente não logado na PA), aparecer uma mensagem, ou no status bar, mas não finalizar a senha
      if ((LDMClient.FCurrentPA = -1) or (LDMClient.FCurrentAtd = -1)) then
      begin
        if LDMClient.FCurrentFila = -1 then
          FinalizarPelaSenha(StrToInt(Senha), aIdUnidade)
        else
        begin
          // VERIFICAR COMO PODE RECOLOCAR ESTA FUNCIONALIDADE          FormClient.PswdLabel.Caption := FormClient.PswdLabel.Caption + ' => Fila ' + inttostr(FCurrentFila);
          RedirecionarPelaSenha(StrToInt(Senha), LDMClient.FCurrentFila, aIdUnidade);
        end;
      end

      {$IFDEF CompilarPara_PA_MULTIPA}
      else if vgParametrosModulo.ConfirmarSenhaOutraFila then
        ChamarEspecifica(LDMClient.FCurrentPA, StrToInt(Senha), aIdUnidade)
      {$ENDIF CompilarPara_PA_MULTIPA}
      else
        ForcarChamada(LDMClient.FCurrentPA, StrToInt(Senha), aIdUnidade);
    end;

{$IFDEF CompilarPara_MULTIPA}

    if ((Pos('Reg:', S) > 0) or (Pos('REG', S) > 0) or (Pos('Log:', S) > 0) or (Pos('LOG', S) > 0)) then // REG = Registro Funcional, para V4. Log para compatibilidade com versões anteriores, descontinuar
    begin
      LDMClient.tmrClearAtd.OnTimer(LDMClient.tmrClearAtd);

      if Pos('Reg:', S) > 0 then
        RegFuncional := Copy(S, Pos('Reg:', S) + Length('Reg:'), Length(S) - Pos('Reg:', S) - Length('Reg:'))
      else if Pos('REG', S) > 0 then
        RegFuncional := Copy(S, Pos('REG', S) + Length('REG'), Length(S) - Pos('REG', S) - Length('REG'))
      else if Pos('Log:', S) > 0 then
        RegFuncional := Copy(S, Pos('Log:', S) + Length('Log:'), Length(S) - Pos('Log:', S) - Length('Log:'))
      else
        RegFuncional := Copy(S, Pos('LOG', S) + Length('LOG'), Length(S) - Pos('LOG', S) - Length('LOG'));

      LDMClient.FCurrentAtd := LDMClient.GetIdAtdFromRegistroFuncional(RegFuncional);

      AchouPA := False;
      if Assigned(dmUnidades.FormClient) and (LDMClient.FCurrentAtd > -1) then
      begin
        for I := 0 to dmUnidades.FormClient.ComponentCount - 1 do
        begin
          if (Assigned(dmUnidades.FormClient.Components[I]) and
             (dmUnidades.FormClient.Components[I] is TLabel) and
             (Pos(TFrmBase_PA_MPA.cLblCodAtendente, dmUnidades.FormClient.Components[I].Name) > 0) and
             (StrToIntDef((dmUnidades.FormClient.Components[I] as TLabel).Text, -1) = LDMClient.FCurrentAtd)) then
          begin
            LDMClient.FCurrentPA := (dmUnidades.FormClient.Components[I] as TLabel).Tag;
            LDMClient.FCurrentAtd := dmUnidades.FormClient.GetCodAtendente(LDMClient.FCurrentPA);
            DestacaPA(LDMClient.FCurrentPA);
            LDMClient.tmrClearAtd.Enabled := True;
            AchouPA                      := True;
            Break;
          end;
        end;
      end;

      if not AchouPA then
      begin
        LDMClient.FCurrentPA  := -1;
        LDMClient.FCurrentAtd := -1;
      end;
    end;

{$ENDIF}

    if ((Pos('Fila:', S) > 0) or (Pos('FILA', S) > 0)) then
    begin

{$IFDEF CompilarPara_MULTIPA}

      LDMClient.tmrClearAtd.OnTimer(LDMClient.tmrClearAtd);

{$ENDIF}

      if Pos('Fila:', S) > 0 then
        LDMClient.FCurrentFila := StrToInt(Copy(S, Pos('Fila:', S) + Length('Fila:'), Length(S) - Pos('Fila:', S) - Length('Fila:')))
      else
        LDMClient.FCurrentFila := StrToInt(Copy(S, Pos('FILA', S) + Length('FILA'), Length(S) - Pos('FILA', S) - Length('FILA')));

{$IFDEF CompilarPara_MULTIPA}
      LDMClient.tmrClearAtd.Enabled := False;
      LDMClient.tmrClearAtd.Enabled := True;
{$ENDIF}
    end;
  end;
end; { proc DecifraCodeBar }

{$ELSE}

begin
end;

{$ENDIF SuportaCodigoBarras}

function TDMConnection.EnviaComandosPendentes: Boolean;
var
  i: Integer;
  ListaIndexRemover: Array of Integer;
  LComandoEnvia: TComandoEnvia;
begin
  Result := True;

  CriticalEnviaComando.BeginRead;
  try
    SetLength(ListaIndexRemover, ListaComando.Count);
    for i := 0 to ListaComando.Count -1 do
    begin
      LComandoEnvia := ListaComando[i];
      ListaIndexRemover[i] := -1;
      if LComandoEnvia.Enviar then
      begin
        if not EnviarComando(LComandoEnvia.Protocolo, LComandoEnvia.IdUnidade, LComandoEnvia.Descricao, False) then
        begin
          Result := False;
          Break;
        end
        else
          ListaIndexRemover[i] := i;
      end;
    end;

    for i := 0 to length(ListaIndexRemover) -1 do
    begin
      if (ListaIndexRemover[i] <> -1) then
      begin
        CriticalEnviaComando.BeginWrite;
        try
          ListaComando.Delete(ListaIndexRemover[i]);
        finally
          CriticalEnviaComando.EndWrite;
        end;
      end;
    end;
  finally
    CriticalEnviaComando.EndRead;
  end;
end;

function TDMConnection.EnviarComando(const Protocolo: string; const aIdUnidade: integer; const ADescricao: String; const aAguardaReceberComando: Boolean;
  const aPersistirEnvioPosteriormente: Boolean): Boolean;
var
  ClientSocket: TIdTCPClient;
  TimeOut: TDateTime;
  LOldUltimoProtocoloEnvio: Word;
  {$IFDEF CompilarPara_PA_MULTIPA}
  LBeginUpdatePA: Boolean;
  LListaPa: TIntegerDynArray;
  {$ENDIF CompilarPara_PA_MULTIPA}

  procedure SelecionarSocket;
  begin
    ClientSocket := GetSocket;
    LOldUltimoProtocoloEnvio := ClientSocket.FUltimoProtocoloEnvio;
    ClientSocket.FUltimoProtocoloEnvio := 0;
  end;

  procedure Enviar;
  var
    Comando: Integer;
  begin
    if Assigned(dmUnidades.FormClient) and aAguardaReceberComando and (dmUnidades.UnidadeAtiva = IdUnidade) then
      dmUnidades.FormClient.AguardandoRetornoComando(True);


    try
      CriticalEnviaComando.BeginWrite;
      ClientSocket.FUltimoProtocoloEnvio := TAspEncode.AspCharToEncode(Protocolo[5]);
      try
        Comando := TAspEncode.AspCharToEncode((Copy(Protocolo, 5, 1) + '0')[1]);
        ClientSocket.IOHandler.WriteLn(FormatarProtocolo(Protocolo));
      finally
        CriticalEnviaComando.EndWrite;
      end;
      Result := True;
    except
      TLog.MyLog('Erro ao enviar protocolo | Comando: ' + Protocolo, Self);
      Result := False;
      Exit;
    end;
  end;

  procedure AdicionaComando;
  var
    ComandoEnvia: TComandoEnvia;
  begin
    ComandoEnvia.Inicializar(Protocolo, aIdUnidade, ADescricao, aAguardaReceberComando);
    CriticalEnviaComando.BeginWrite;
    try
      ListaComando.Add(ComandoEnvia);
    finally
      CriticalEnviaComando.EndWrite;
    end;
  end;

begin
  LOldUltimoProtocoloEnvio := 0;
  Result := False;
  try
    {$IFDEF CompilarPara_PA_MULTIPA}
    LBeginUpdatePA := Assigned(dmUnidades.FormClient) and
                      dmUnidades.FormClient.BeginUpdatePA(LListaPa) and
                      (IdUnidade = dmUnidades.UnidadeAtiva);
    {$ENDIF CompilarPara_PA_MULTIPA}
    try
      try
        CriticalEnviaComando.BeginRead;
        try
          SelecionarSocket;
          if Assigned(ClientSocket) and Assigned(dmUnidades.FormClient) and
             (aIdUnidade <> IDUnidade) then
            Exit;

          if Assigned(ClientSocket) and ClientSocket.Connected then
            Enviar
          else
          begin
            tmrReconnectTimer(tmrReconnect);

            Delay(500);

            SelecionarSocket;

            if Assigned(ClientSocket) and ClientSocket.Connected then
              Enviar;
          end;
        finally
          CriticalEnviaComando.EndRead;
        end;

        if Result then
        begin
          if aAguardaReceberComando then
          begin
            TimeOut := Now + EncodeTime(0, 0, 2, 0);
            while (tmrReceberComando.Enabled and (not ReceberComando) and (Now < TimeOut)) do
            begin
              Sleep(100);
              GetApplication.ProcessMessages;
            end;
          end;
        end;
      except
        TLog.MyLog('Evento: EnviarComando | Status: Connectado | Descrição: ' + ADescricao + ' | Unidade: ' + IntToStr(aIdUnidade) + ' | Protocolo: ' + Protocolo, Self);
        TLog.TreatException('Erro ao enviar comando', Self);
        raise;
      end;
    finally
      {$IFDEF CompilarPara_PA_MULTIPA}
      if LBeginUpdatePA then
        dmUnidades.FormClient.EndUpdatePA(LListaPa);
      {$ENDIF CompilarPara_PA_MULTIPA}
    end;
  finally
    if not (Result and aPersistirEnvioPosteriormente) then
      AdicionaComando;

	  if Assigned(ClientSocket) then
      ClientSocket.FUltimoProtocoloEnvio := LOldUltimoProtocoloEnvio;
  end;
end;

function TDMConnection.ReceberComando(const aIDUnidade: Integer): Boolean;
var
  Socket : TIdTCPClient;
  Comando, PrimeiroComando : string;
  {$IFDEF CompilarPara_PA_MULTIPA}
  LBeginUpdatePA: Boolean;
  LListaPa: TIntegerDynArray;
  {$ENDIF CompilarPara_PA_MULTIPA}

  DebugInicio : TDateTime;

const
  DebugItem : integer = 0;

  function GetDefaultTextEncoding: IIdTextEncoding;
  begin
    Result := IndyTextEncoding_8Bit;
  end;

begin
  Result := False;

  {$IFDEF DEBUG}
    DebugInicio := now;
    DebugItem := DebugItem + 1;
    TLog.MyLog('[DEBUG ' + inttostr(DebugItem) + '] ReceberComando', nil, 0, false, TCriticalLog.tlDEBUG);
  {$ENDIF DEBUG}

  if not tmrReceberComando.Enabled then
    Exit;
  tmrReceberComando.Enabled := False;

  CriticalEnviaComando.BeginRead;
  try
    {$IFDEF CompilarPara_PA_MULTIPA}
    LBeginUpdatePA := False;
    {$ENDIF CompilarPara_PA_MULTIPA}
    try
      Comando := '';
      try
        Socket := GetSocket;

        if Assigned(Socket) and Socket.Connected then
        begin
          CriticalEnviaComando.BeginWrite;
          try
            Socket.IOHandler.CheckForDataOnSource(100);

            while (not GetApplication.Terminated) and
                  (Socket.Connected) and
                  (not Socket.IOHandler.InputBufferIsEmpty) do
            begin
              Comando := Socket.IOHandler.ReadLn(ETX, -1, 0, GetDefaultTextEncoding);

              if Comando <> '' then
              begin
                Comando := Comando + ETX;

                SeparaStrings(Comando, ETX, PrimeiroComando, Comando);

                //LBC 09/04/2018 - Colocado este Log abaixo apenas para verificar, com o tempo, se esta situação ocorre.
                //                 Foi feito desta forma, usando o SeparaStrings e tratando o "PrimeiroComando" no DecifrarProtocolo,
                //                 para corrigir o BT #552, porém aparentemente não está ocorrendo o log, ou seja, aparentemente o bug não existia.
                //                 Após algum tempo e análises de LOGs, pode remover este log abaixo. Se nunca tiver sido logado, é porque o bug de fato não existia
                //                 (e eventualmente pode até ser desfeita esta correção, eliminando a var "PrimeiroComando" e seu respectivo algoritmo)
                if Comando <> '' then
                  TLog.MyLog('Tratando comando concatenado: ' + PrimeiroComando + ' || ' + Comando, nil, 0, false, TCriticalLog.tlDEBUG, 'log');

                while PrimeiroComando <> '' do
                begin
                  PrimeiroComando := PrimeiroComando + ETX;
                  if DecifrarProtocolo(PrimeiroComando, Socket, aIDUnidade) then
                  begin
                    Result := True;

                    if Assigned(dmUnidades.FormClient) and (aIDUnidade = dmUnidades.UnidadeAtiva) then
                      dmUnidades.FormClient.AguardandoRetornoComando(False);
                  end;

                  SeparaStrings(Comando, ETX, PrimeiroComando, Comando);
                end;
              end;

              if Socket.Connected then
                Socket.IOHandler.CheckForDataOnSource(100);
            end;
          finally
            CriticalEnviaComando.EndWrite;
          end;
        end;
      except
        on E: Exception do
        begin
          //aqui podem ocorrer os erros 10053, 10054 (mais comum, quando fecha o servidor abruptamente), 10060, 10061 ou 10065
          TLog.TreatException('Erro ao receber comando. Comando: ' + Comando + ' Erro: ' + e.Message, Self, True);

          ClientSocketPrincipal  .Disconnect(False);
          ClientSocketContingente.Disconnect(False);

          raise;
        end;
      end;
    finally
      {$IFDEF CompilarPara_PA_MULTIPA}
      if LBeginUpdatePA then
        dmUnidades.FormClient.EndUpdatePA(LListaPa);
      {$ENDIF CompilarPara_PA_MULTIPA}
    end;
  finally
    CriticalEnviaComando.EndRead;
    tmrReceberComando.Enabled := True;

    {$IFDEF DEBUG}
      Tlog.MyLog('[DEBUG ' + inttostr(DebugItem) + FormatDateTime(' hh:nn:ss,zzz]', now - DebugInicio) + ' ReceberComando Término', nil, 0, false, TCriticalLog.tlDEBUG);
    {$ENDIF DEBUG}
  end;
end;

procedure TDMConnection.Redirecionar(const PA, Fila, aIdUnidade: Integer);
begin
  EnviarComando(TAspEncode.AspIntToHex(PA, 4) + Chr($2E) + TAspEncode.AspIntToHex(Fila, 4), aIdUnidade, 'Redirecionar');
end;

procedure TDMConnection.Redirecionar_Proximo(const PA, Fila, aIdUnidade: Integer);
begin
  EnviarComando(TAspEncode.AspIntToHex(PA, 4) + Chr($2F) + TAspEncode.AspIntToHex(Fila, 4), aIdUnidade);
end;

procedure TDMConnection.Redirecionar_Especifica(const PA, Fila, Senha, aIdUnidade: Integer);
begin
  EnviarComando(TAspEncode.AspIntToHex(PA, 4) + Chr($31) + TAspEncode.AspIntToHex(Fila, 4) + IntToStr(Senha), aIdUnidade);
end;

procedure TDMConnection.Redirecionar_ForcarChamada(const PA, Fila, Senha, aIdUnidade: Integer);
begin
  EnviarComando(TAspEncode.AspIntToHex(PA, 4) + Chr($32) + TAspEncode.AspIntToHex(Fila, 4) + IntToStr(Senha), aIdUnidade);
end;

procedure TDMConnection.RedirecionarPelaSenha(const Senha, Fila, aIdUnidade: Integer);
begin
  EnviarComando(TAspEncode.AspIntToHex(0, 4) + Chr($77) + TAspEncode.AspIntToHex(Fila, 4) + IntToStr(Senha), aIdUnidade);
end;

procedure TDMConnection.Proximo(const PA, aIdUnidade: Integer);
begin
  EnviarComando(TAspEncode.AspIntToHex(PA, 4) + Chr($20), aIdUnidade);
end;

function TDMConnection.ReceberComando: Boolean;
begin
  Result := ReceberComando(IDUnidade);
end;

procedure TDMConnection.Rechamar(const PA, aIdUnidade: Integer);
begin
  EnviarComando(TAspEncode.AspIntToHex(PA, 4) + Chr($22), aIdUnidade);
end;

function TDMConnection.Reconnectar: Boolean;
begin
  Result := Reconnectar(IDUnidade);
end;

function TDMConnection.Reconnectar(const aIDUnidade: Integer): Boolean;

  procedure TratamentoErroLocal(AExcecao: exception);
  begin
    case EIdSocketError(AExcecao).LastError of
      10053, 10054, 10060, 10061, 10065 :  ;// IGNORAR ESTES ERROS
      else ErrorHandling(AExcecao);
    end;
  end;

  {$IFDEF CompilarPara_TGS}
  procedure ConnectaDB;
  var
    LDMClient: TDMClient;
  begin
    LDMClient := DMClient(aIDUnidade, not CRIAR_SE_NAO_EXISTIR);
    if Assigned(LDMClient) then
      LDMClient.ConnectarDB;
  end;
  {$ENDIF CompilarPara_TGS}

  procedure ConnectaSocket(aIdTCPClient: TIdTCPClient);
  begin
    if ((aIdTCPClient.host <> '') and (aIdTCPClient.Port > 0) and
        (not aIdTCPClient.Connected)) then
    begin
      try
        try
          aIdTCPClient.Connect;
          if ClienteSocketEstaConectado then
          begin
            Result := True;
            DisconnectaOutrosSockets(aIdTCPClient);
          end
          else
            ClientSocketPrincipalDisconnected(aIdTCPClient);

        except
          on E: exception do
          begin
            ClientSocketPrincipalDisconnected(aIdTCPClient);
            TratamentoErroLocal(E);
            Exit;
          end;
        end;
      finally
        if not aIdTCPClient.FJaConectou then
        begin
          if aIdTCPClient.Connected then
            aIdTCPClient.FJaConectou := True
          else
            if (aIdTCPClient.FDataPrimeiraTentativaConectar = 0) then
              aIdTCPClient.FDataPrimeiraTentativaConectar := Now
        end;
      end;
    end;
  end;

var
  I: integer;
  LIdTCPClient: TIdTCPClient;
begin
  Result := False;
  CriticalEnviaComando.BeginWrite;
  try
    for I := Ord(Low(TConexao)) to Ord(High(TConexao)) do
    begin
      LIdTCPClient := GetSocket;

      if ClienteSocketEstaConectado then
        Exit;

      DisconnectaOutrosSockets(LIdTCPClient);

      ClienteModoDesconectado;

      case ConexaoServidor of
        tcPrincipal   : begin
                          ConexaoServidor := tcContingente;
                          ConnectaSocket(ClientSocketPrincipal);
                        end;

        tcContingente : begin
                          ConexaoServidor := tcPrincipal;
                          ConnectaSocket(ClientSocketContingente);
                        end;
      end;

      if Result then
        Break;
    end;
  finally
    CriticalEnviaComando.EndWrite;
  end;
end;

procedure TDMConnection.Finalizar(const PA, aIdUnidade: Integer);
begin
  EnviarComando(TAspEncode.AspIntToHex(PA, 4) + Chr($25), aIdUnidade);
end;

procedure TDMConnection.CarregarParametros;
begin
end;

procedure TDMConnection.ChamarEspecifica(const PA, Senha, aIdUnidade: Integer);
begin
  EnviarComando(TAspEncode.AspIntToHex(PA, 4) + Chr($21) + IntToStr(Senha), aIdUnidade);
end;

procedure TDMConnection.ForcarChamada(const PA, Senha, aIdUnidade: Integer);
begin
  EnviarComando(TAspEncode.AspIntToHex(PA, 4) + Chr($30) + IntToStr(Senha), aIdUnidade);
end;

procedure TDMConnection.FreeNotification(AObject: TObject);
begin
  if (Assigned(AObject) and (AObject is TComponent)) then
    Notification(TComponent(AObject), OpRemove);
end;

function TDMConnection.GetSocket: TIdTCPClient;
begin
  if ClientSocketPrincipal.Connected then
    Result := ClientSocketPrincipal
  else
    Result := ClientSocketContingente;
end;

{$IFDEF CompilarPara_PA}
procedure TDMConnection.GravaNoINI(PA: string);
var
  IniFile : TIniFile;
begin
 IniFile := TIniFile.Create (GetAppIniFileName);
  with(IniFile)do
  begin
    try
      WriteString('Retrocompatibilidade','PA',PA);
    finally
      Free;
    end;
  end;
end;
{$ENDIF CompilarPara_PA}

procedure TDMConnection.FinalizarPelaSenha(const Senha, aIdUnidade: Integer);
begin
  EnviarComando(TAspEncode.AspIntToHex(0, 4) + Chr($53) + IntToStr(Senha), aIdUnidade);
end;

procedure TDMConnection.DefinirNomeCliente(const PA, Senha: integer; const Nome: string; const aIdUnidade: Integer);
begin
  EnviarComando(TAspEncode.AspIntToHex(PA, 4) + Chr($57) + IntToStr(Senha) + TAB + Nome, aIdUnidade);
end;

procedure TDMConnection.DefinirDadoAdicionalNomeCliente(const PA, Senha: integer; const Nome: string; const aIdUnidade: Integer);
begin
  EnviarComando(TAspEncode.AspIntToHex(PA, 4) + Chr($CB) + IntToStr(Senha) + TAB + '{"NOME":"' + Nome + '"}', aIdUnidade);
end;

procedure TDMConnection.DefinirTag(const PA, Senha, aTag, aIdUnidade: Integer);
begin
  EnviarComando(TAspEncode.AspIntToHex(PA, 4) + Chr($7D) + TAspEncode.AspIntToHex(aTag, 4) + IntToStr(Senha), aIdUnidade);
end;

procedure TDMConnection.DesassociarTag(const PA, Senha, aTag: integer; const aIdUnidade: Integer);
begin
  EnviarComando(TAspEncode.AspIntToHex(PA, 4) + Chr($AD) + TAspEncode.AspIntToHex(aTag, 4) + IntToStr(Senha), aIdUnidade);
end;

destructor TDMConnection.Destroy;
begin
  tmrReconnect     .Enabled := False;
  tmrReceberComando.Enabled := False;

  FreeAndNil(ListaComando);
  inherited;
end;

procedure TDMConnection.DisconnectaOutrosSockets(const aUniqueClientSocketAtivo: TIdTCPClient);
{$IFDEF CompilarPara_TGS_ONLINE}
var
  LIdTCPClient: TIdTCPClient;
{$ENDIF CompilarPara_TGS_ONLINE}

  procedure DisconnectaSeConnectado(const aCurrentSOcket: TIdTCPClient);
  var
    LDMClient: TDMClient;
  begin
    try
      if Assigned(aCurrentSOcket) and (aCurrentSOcket <> aUniqueClientSocketAtivo) then
      begin
        if aCurrentSOcket.Connected then
          aCurrentSOcket.Disconnect;

        if (aCurrentSOcket.Tag <> aUniqueClientSocketAtivo.Tag) then
        begin
          LDMClient := DMClient(aCurrentSOcket.Tag, not CRIAR_SE_NAO_EXISTIR);
          if Assigned(LDMClient) and LDMClient.connDMClient.Connected then
            LDMClient.connDMClient.Close;
          if Assigned(LDMClient) and LDMClient.connRelatorio.Connected then
            LDMClient.connRelatorio.Close;
        end;
      end;
    except
      on E: Exception do
      begin
        ErrorMessage('Erro ao disconectar o socket da unidade ' + IntTOStr(aCurrentSOcket.Tag) + '.' + #13 + 'Erro: ' + e.Message);
        Exit;
      end;
    end;
  end;


begin
  DisconnectaSeConnectado(ClientSocketPrincipal);
  DisconnectaSeConnectado(ClientSocketContingente);
end;

procedure TDMConnection.SetIdUnidade(const Value: Integer);
begin
  if (IDUnidade <> Value) then
  begin
    FIDUnidade := Value;
    FNomeUnidade := dmUnidades.Nome[Value];
  end;
end;

function TDMConnection.SocketEmConflito(const aPorta: Word; const aHost: String; aUniqueClientSocketAtivo: TObject): Boolean;

  function FormataHost(const aHostFormatar: String): String;
  const
    CLocalhost = 'LOCALHOST';
  begin
    Result := Trim(UpperCase(aHostFormatar));
    if (Result = CLocalhost) then
      Result := IPLocalhost;
  end;

  function GetSocketEstaEmConflito(const aCurrentSocket: TIdTCPClient): Boolean;
  begin
    try
      Result := (Assigned(aCurrentSocket) and
                (aCurrentSocket <> aUniqueClientSocketAtivo) and
                ( (aCurrentSocket.Port = aPorta) and
                  (FormataHost(aCurrentSocket.Host) = FormataHost(aHost))
                ));
    except
      on E: Exception do
      begin
        Result := False;
        ErrorMessage('Erro ao validar porta ativa.' + #13 + 'Erro: ' + e.Message);
        Exit;
      end;
    end;
  end;

begin
  Result := GetSocketEstaEmConflito(ClientSocketPrincipal) or
            GetSocketEstaEmConflito(ClientSocketContingente);
end;

procedure TDMConnection.SolicitarNomeCliente(const PA: integer; const Senha: string; const aIdUnidade: Integer);
begin
  EnviarComando(TAspEncode.AspIntToHex(PA, 4) + Chr($56) + Senha, aIdUnidade);
end;

procedure TDMConnection.SolicitarAgendamentosFilas(const PA: integer; const Senha: string; const aIdUnidade: Integer);
begin
  EnviarComando(TAspEncode.AspIntToHex(PA, 4) + Chr($C2) + Senha, aIdUnidade);
end;

procedure TDMConnection.SolicitarDadosAdicionais(const PA: integer;
  const Senha: string; const aIdUnidade: Integer);
begin
  EnviarComando(TAspEncode.AspIntToHex(PA, 4) + Chr($CD) + Senha, aIdUnidade);
end;

procedure TDMConnection.SolicitarSituacaoPA(const PA: integer; const aIdUnidade: Integer);
begin
  EnviarComando(TAspEncode.AspIntToHex(PA, 4) + Chr($29), aIdUnidade);
end;

procedure TDMConnection.SolicitarTAGs(PA: integer; Senha: string; const aIdUnidade: Integer);
begin
  if DMClient(aIdUnidade, not CRIAR_SE_NAO_EXISTIR).cdsGruposDeTAGs.IsEmpty then
    Exit;

  if ValidarPA(PA, aIdUnidade) then
  begin
    if EstaPreenchidoCampo(Senha) then
      EnviarComando(TAspEncode.AspIntToHex(PA, 4) + Chr($AB) + Senha, aIdUnidade)
    else
    begin

      {$IFDEF CompilarPara_PA_MULTIPA}

      if Assigned(dmUnidades.FormClient) then
        dmUnidades.FormClient.DesligarTAGs(PA);

      {$ENDIF CompilarPara_PA_MULTIPA}

    end;
  end;
end;

procedure TDMConnection.tmrReceberComandoTimer(Sender: TObject);
begin
  ReceberComando;
end;

procedure TDMConnection.tmrReconnectTimer(Sender: TObject);
var
  FOldReconnectEnabled: Boolean;
  LClientSocket : TIdTCPClient;
begin
  if not tmrReconnect.Enabled then
    Exit;

  FOldReconnectEnabled := tmrReconnect.Enabled;
  tmrReconnect.Enabled := False;
  try
    tmrReconnect.Interval := vgParametrosSicsClient.IntervaloReconectar;
    Reconnectar;
  finally
    tmrReconnect.Enabled := FOldReconnectEnabled;
    GetApplication.ProcessMessages;
  end;

  //envia "Keep alive"
  case ConexaoServidor of
    tcPrincipal   : LClientSocket := ClientSocketPrincipal;
    tcContingente : LClientSocket := ClientSocketContingente;
  end;
  try
    if(LClientSocket.Connected)then
      LClientSocket.IOHandler.Write(ACK);
  except
    LClientSocket.Disconnect;
  end;
end;



function TDMConnection.ValidarPA(const PA: integer; const aIDUnidade: Integer): Boolean;
begin
  {$IFDEF CompilarPara_PA}
  Result := ((PA = 0) or (PA = DMClient(aIdUnidade, not CRIAR_SE_NAO_EXISTIR).FCurrentPA));
  {$ELSE}
  {$IFDEF CompilarPara_MULTIPA}
  Result := ((PA = 0) or (DMClient(0, not CRIAR_SE_NAO_EXISTIR).ExistePA(PA)));
  {$ELSE}
  {$IFDEF CompilarPara_TGS_ONLINE}
  Result := ((PA = 0) or (PA = $FFFF) or (DMClient(aIdUnidade, not CRIAR_SE_NAO_EXISTIR).ExistePA(PA)));
  {$ELSE}
  {$IFDEF CompilarPara_CALLCENTER}
  Result := True;
  {$ELSE}
  {$IFDEF CompilarPara_TOTEMTOUCH}
  Result := True;
  {$ELSE}
        Result := True;
        Assert(False, 'Para o módulo atual não foi implementado a validação da PA. TDMConnection.ValidarPA');
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}
end;

procedure TDMConnection.VerificarLogin(const PA: integer; const AtdLogin, Senha: string; const aIdUnidade: Integer);
begin
  EnviarComando(TAspEncode.AspIntToHex(System.Math.Max(PA, 0), 4) + Chr($54) + TAspEncode.AspIntToHex(FIdModulo, 4) + AtdLogin + Chr(9) + Senha, aIdUnidade);
end;

{ TComandoEnvia }

procedure TComandoEnvia.Inicializar(const aProtocolo: string; const aIdUnidade: integer; const aDescricao: String = ''; const aAguardaReceberComando: Boolean = True);
begin
  Enviar := True;
  Protocolo := aProtocolo;
  IdUnidade := aIdUnidade;
  Descricao := aDescricao;
  AguardaReceberComando := aAguardaReceberComando;
end;

{ TIdTCPClient }

procedure TIdTCPClient.AfterConstruction;
begin
  inherited;
  FJaConectou := False;
  FDataPrimeiraTentativaConectar := 0;
  FUltimoProtocoloEnvio := 0;
  FPrimeiraVezConectouComServidor := true;
end;

function GetEncondeProtocoloEhValido(const aProtocolo: String): Boolean;
begin
  Result := ((aProtocolo <> '') and (aProtocolo[1] = STX) and (aProtocolo[Length(aProtocolo)] = ETX) and (Length(aProtocolo) >= 11));
end;

procedure ExtrairVersaoNoProtocolo(var aProtocolo: String; out aVersaoProtocolo: Integer);
begin
  aVersaoProtocolo := StrToIntDef('$' + ExtractStr(aProtocolo, 2, 4), 0);
end;

procedure ExtrairProtDataNoProtocolo(const aProtocolo: String; out aProtData: String; var aComando: Integer);
begin
  aProtData := Copy(aProtocolo, 7, Length(aProtocolo) - 7);
  aComando := TAspEncode.AspCharToEncode(aProtocolo[6]);
end;

function AlterouStatusPA(aPA: integer; Anterior, Atual: string): Boolean;
  var
    BlocoAnterior, BlocoAtual: string;
    I                        : integer;
  begin
    try
      BlocoAnterior := '';
      BlocoAtual    := '';

      I := Pos(TAB + TAspEncode.AspIntToHex(aPA, 4), Anterior) + 1;
      if I >= 2 then
      begin
        while Anterior[I] <> TAB do
        begin
          BlocoAnterior := BlocoAnterior + Anterior[I];
          I             := I + 1;
        end;
      end;

      I := Pos(TAB + TAspEncode.AspIntToHex(aPA, 4), Atual) + 1;
      if I >= 2 then
      begin
        while Atual[I] <> TAB do
        begin
          BlocoAtual := BlocoAtual + Atual[I];
          I          := I + 1;
        end;
      end;

      Result := BlocoAnterior <> BlocoAtual;
    except
      Result := True;
      Exit;
    end;
  end;

end.


