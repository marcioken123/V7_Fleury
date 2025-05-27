unit sics_m;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}
{$J+}

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, IniFiles, Buttons, Menus, Printers,
  Grids, ScktComp, ComCtrls, Variants, System.DateUtils,
  untLog, ASPClientSocket, Sics_2, Sics_5, ProtocoloSics, Sics_91, Sics_92,
  Sics_94, DBClient, Db, cfgGenerica, VaClasses, VaComm, MyDlls_DR,
  MyAspFuncoesUteis_VCL, System.UITypes, Datasnap.Provider, AspJson,
  System.JSON, IdContext, IdCustomHTTPServer,
  IdHTTPServer, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Comp.Client, UTaskBarList,
  System.Generics.Collections ,uDataSetHelper, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.Comp.DataSet, System.StrUtils, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, IdBaseComponent, IdComponent, IdCustomTCPServer, FireDAC.DApt;

// {$DEFINE USEKEY}

{$INCLUDE ..\SicsVersoes.pas}

const
  COL_SENHA        = 0;
  COL_NOME         = 1;
  COL_HORA         = 2;
  COL_DATAHORA     = 3;
  COL_PRIMEIRA_TAG = 4;  // RAP
  WIDTH_COLS_TAGS  = 10; // RAP
  CANEXCLUDE: Boolean = True;
  TAB = Chr(9);
const
  cStatusDePapel = 'Status de papel nos totens e impressoras do SICS';

type
  TRefProc = reference to procedure;
  EEnvioDeEmail       = class(Exception);
  ERegistroDeOperacao = class(Exception);

  TWaitingPswd = record
    TicketNumber: Integer;
    PswdDateTime: TDateTime;
  end; { record }

  TWaitingPswdFile = file of TWaitingPswd;

  TRegistroDeAtendimento = record
    PA, ATD, TicketNumber, FilaProveniente: Integer;
    Horario: TDateTime;
  end;

  TRegistroDeAtendimentoFile = file of TRegistroDeAtendimento;

  TRegistroDePP = record
    EventoPP, TipoPP, PA, ATD, TicketNumber: Integer;
    Horario: TDateTime;
  end;

  TRegistroDePPFile = file of TRegistroDePP;

  TReplicacaoNomeCliente = (rnSenha, rnDadosAdicionais);

  TfrmSicsMain = class(TForm)
    ClearOutBufferTimer: TTimer;
    MainMenu1: TMainMenu;
    But1: TMenuItem;
    But2: TMenuItem;
    But3: TMenuItem;
    But4: TMenuItem;
    But5: TMenuItem;
    But6: TMenuItem;
    But7: TMenuItem;
    But8: TMenuItem;
    But9: TMenuItem;
    But10: TMenuItem;
    But11: TMenuItem;
    But12: TMenuItem;
    OutBuffer: TStringGrid;
    Shortcuts1: TMenuItem;
    MenuArquivo: TMenuItem;
    MenuSair: TMenuItem;
    MenuConfigurar: TMenuItem;
    Bevel0: TBevel;
    MenuVisualizar: TMenuItem;
    MenuQuestionMark: TMenuItem;
    SubMenuSobre: TMenuItem;
    SubMenuSituacao: TMenuItem;
    ManagePswdPopMenu: TPopupMenu;
    PopUpMenuExcluir: TMenuItem;
    SubMenuPrioridadesDosBoxes: TMenuItem;
    ServerSocket1: TServerSocket;
    SubMenuConfiguracoesAvancadas: TMenuItem;
    SubMenuAtendentes: TMenuItem;
    SubMenuFilas: TMenuItem;
    OneMinuteTimer: TTimer;
    PrinterPort: TVaComm;
    Panel1: TPanel;
    SenhaLabel: TLabel;
    GuicheLabel: TLabel;
    PainelPort: TVaComm;
    PainelTcpPort: TServerSocket;
    SubMenuPosicoesDeAtendimento: TMenuItem;
    SubMenuPaineis: TMenuItem;
    menuIndicadoresdePerformance: TMenuItem;
    menuDefinicoesDeIndicadores: TMenuItem;
    menuDefinicoesDeHorarios: TMenuItem;
    SubMenuResetarPaineis: TMenuItem;
    SubMenuInicializarPaineis: TMenuItem;
    SubMenuEmails: TMenuItem;
    N4: TMenuItem;
    CheckConnectionsTimer: TTimer;
    N5: TMenuItem;
    SubMenuTestarEnvioDeEmail: TMenuItem;
    SubMenuStatusDosTotens: TMenuItem;
    SubMenuValidade: TMenuItem;
    SubMenuAjustarHorarioDosPaineis: TMenuItem;
    Botoeiras3B2LPort: TVaComm;
    TecladoPort: TVaComm;
    SubMenuIndicadoresDePerformance: TMenuItem;
    SubMenuGruposDeAtendentes: TMenuItem;
    SubMenuGruposDePosicoesDeAtendimento: TMenuItem;
    SubMenuPaineisAlfanumericos: TMenuItem;
    SubMenuPaineisNumericos: TMenuItem;
    SubMenuApagarPaineis: TMenuItem;
    SubMenuTestarComunicacao: TMenuItem;
    SubMenuConfiguracoesDeEnvioDeEmail: TMenuItem;
    SubMenuConfiguracoesDeEnvioDeSms: TMenuItem;
    SubMenuTestarEnvioDeSms: TMenuItem;
    TGSServerSocket: TServerSocket;
    SubMenuStatusDasConexoesTcpIp: TMenuItem;
    Backups1: TMenuItem;
    N6: TMenuItem;
    menuCelulares: TMenuItem;
    cdsIdsTickets: TClientDataSet;
    cdsIdsTicketsID: TIntegerField;
    cdsIdsTicketsNumeroTicket: TIntegerField;
    menuAlarmes: TMenuItem;
    TrayIcon1: TTrayIcon;
    menuConfigurarEnderecosSeriais: TMenuItem;
    menuTray: TPopupMenu;
    menuTrayRestaurar: TMenuItem;
    N7: TMenuItem;
    menuTraySair: TMenuItem;
    menuTags: TMenuItem;
    SubMenuGruposTags: TMenuItem;
    menuTotens: TMenuItem;
    Grupos1: TMenuItem;
    cdsIdsTicketsTags: TClientDataSet;
    cdsIdsTicketsTagsId: TIntegerField;
    cdsIdsTicketsTagsTicket_Id: TIntegerField;
    cdsIdsTicketsTagsTag_Id: TIntegerField;
    ServerSocketRetrocompatibilidade: TServerSocket;
    cdsIdsTicketsNomeCliente: TStringField;
    menuVisualizarPPs: TMenuItem;
    menuConfigurarPPs: TMenuItem;
    SubMenuGruposPPs: TMenuItem;
    SubMenuGruposMotivosPausa: TMenuItem;
    menuMotivosDePausa: TMenuItem;
    menuModulosDoSics: TMenuItem;
    menuModulosSicsPA: TMenuItem;
    menuModulosSicsMultiPA: TMenuItem;
    menuModulosSicsOnLine: TMenuItem;
    menuModulosSicsTGS: TMenuItem;
    Debug1: TMenuItem;
    mnuExcluirTodos: TMenuItem;
    cdsIdsTicketsAgendamentosFilas: TClientDataSet;
    socketImprimeCDB: TASPClientSocket;
    cdsTmp: TClientDataSet;
    SubMenuClientes: TMenuItem;
    MenuModuloSicsCallCenter: TMenuItem;
    IdHTTPServer: TIdHTTPServer;
    cdsIdsTicketsFila_Id: TIntegerField;
    cdsIdsTicketsAgendamentosFilasID: TIntegerField;
    cdsIdsTicketsAgendamentosFilasID_TICKET: TIntegerField;
    cdsIdsTicketsAgendamentosFilasID_FILA: TIntegerField;
    cdsIdsTicketsAgendamentosFilasCONCLUIDO: TStringField;
    cdsIdsTicketsAgendamentosFilasDATAHORA: TSQLTimeStampField;
    Button1: TButton;
    FDTGruposPAS_AlarmesPapelTotens: TFDMemTable;
    FDTGruposPAS_AlarmesPapelTotensID_TOTEM: TIntegerField;
    FDTGruposPAS_AlarmesPapelTotensSTATUS: TStringField;
    FDTGruposPAS_AlarmesPapelTotensGRUPO_PAS: TStringField;
    RoboFilaEsperaProfissional: TTimer;
    cdsIdsTicketsTagsId_Unidade: TIntegerField;
    qryIdsTicketsAgendamentosFilas: TFDQuery;
    qryIdsTicketsAgendamentosFilasID_UNIDADE: TIntegerField;
    qryIdsTicketsAgendamentosFilasID: TIntegerField;
    qryIdsTicketsAgendamentosFilasID_TICKET: TIntegerField;
    qryIdsTicketsAgendamentosFilasID_FILA: TIntegerField;
    qryIdsTicketsAgendamentosFilasDATAHORA: TSQLTimeStampField;
    qryIdsTicketsAgendamentosFilasCONCLUIDO: TStringField;
    dspIdsTicketsAgendamentosFilas: TDataSetProvider;
    qryIdsTicketsTags: TFDQuery;
    qryIdsTicketsTagsID_UNIDADE: TIntegerField;
    qryIdsTicketsTagsID: TIntegerField;
    qryIdsTicketsTagsTICKET_ID: TIntegerField;
    qryIdsTicketsTagsTAG_ID: TIntegerField;
    qryIdsTicketsTagsNUMEROTICKET: TIntegerField;
    qryIdsTicketsTagsID_GRUPOTAG: TIntegerField;
    dspIdsTicketsTags: TDataSetProvider;
    dspIdsTickets: TDataSetProvider;
    qryIdsTickets: TFDQuery;
    qryIdsTicketsID_UNIDADE: TIntegerField;
    qryIdsTicketsID: TIntegerField;
    qryIdsTicketsNUMEROTICKET: TIntegerField;
    qryIdsTicketsNOMECLIENTE: TStringField;
    qryIdsTicketsFILA_ID: TIntegerField;
    qryIdsTicketsORDEM: TIntegerField;
    qryIdsTicketsCREATEDAT: TSQLTimeStampField;

    procedure FormCreate(Sender: TObject);
    procedure ClearOutBufferTimerTimer(Sender: TObject);
    procedure SenhaEdit1Enter(Sender: TObject);
    procedure InsertSenhaButton1Click(Sender: TObject);
    procedure SenhaEdit1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BitBtnClick(Sender: TObject);
    procedure SenhasList1DrawCell(Sender: TObject; Col, Row: Longint; Rect: TRect; State: TGridDrawState);
    procedure SubMenuSobreClick(Sender: TObject);
    procedure MenuSairClick(Sender: TObject);
    procedure SubMenuSituacaoClick(Sender: TObject);
    procedure SenhasList1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PopUpMenuExcluirClick(Sender: TObject);
    procedure SubMenuPrioridadesDosBoxesClick(Sender: TObject);
    procedure ServerSocket1ClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure SubMenuAtendentesClick(Sender: TObject);
    procedure SubMenuFilasClick(Sender: TObject);
    procedure SenhasList1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ListBlocked1Click(Sender: TObject);
    procedure PrioritaryList1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure OneMinuteTimerTimer(Sender: TObject);
    procedure PainelPortCts(Sender: TObject);
    procedure SubMenuPosicoesDeAtendimentoClick(Sender: TObject);
    procedure SubMenuPaineisClick(Sender: TObject);
    procedure menuDefinicoesDeIndicadoresClick(Sender: TObject);
    procedure menuDefinicoesDeHorariosClick(Sender: TObject);
    procedure SubMenuResetarPaineisClick(Sender: TObject);
    procedure SubMenuInicializarPaineisClick(Sender: TObject);
    procedure SubMenuEmailsClick(Sender: TObject);
    procedure SubMenuHabilitarBotoesDaImpressoraClick(Sender: TObject);
    procedure SubMenuDesabilitarBotoesDaImpressoraClick(Sender: TObject);
    procedure CheckConnectionsTimerTimer(Sender: TObject);
    procedure PrinterClientSocketLookup(Sender: TObject; Socket: TCustomWinSocket);
    procedure PrinterClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure PrinterClientSocketConnecting(Sender: TObject; Socket: TCustomWinSocket);
    procedure PrinterClientSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure PrinterClientSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure PrinterClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure PainelClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure SubMenuTestarEnvioDeEmailClick(Sender: TObject);
    procedure SubMenuStatusDosTotensClick(Sender: TObject);
    procedure SubMenuValidadeClick(Sender: TObject);
    procedure PainelPortDsr(Sender: TObject);
    procedure ServerSocket1ClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure PrinterPortRxChar(Sender: TObject; Count: Integer);
    procedure SubMenuAjustarHorarioDosPaineisClick(Sender: TObject);
    procedure Botoeiras3B2LPortRxChar(Sender: TObject; Count: Integer);
    procedure TecladoPortRxChar(Sender: TObject; Count: Integer);
    procedure TecladoTcpPortRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure PainelPortTxEmpty(Sender: TObject);
    procedure SubMenuIndicadoresDePerformanceClick(Sender: TObject);
    procedure SubMenuGruposDeAtendentesClick(Sender: TObject);
    procedure SubMenuGruposDePosicoesDeAtendimentoClick(Sender: TObject);
    procedure SubMenuApagarPaineisClick(Sender: TObject);
    procedure SubMenuTestarComunicacaoClick(Sender: TObject);
    procedure SubMenuConfiguracoesDeEnvioDeEmailClick(Sender: TObject);
    procedure SubMenuConfiguracoesDeEnvioDeSmsClick(Sender: TObject);
    procedure SubMenuTestarEnvioDeSmsClick(Sender: TObject);
    procedure ClientSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ServerSocket1ClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure Backups1Click(Sender: TObject);
    procedure menuGruposDePaineisClick(Sender: TObject);
    procedure menuCelularesClick(Sender: TObject);
    procedure menuAlarmesClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure menuConfigurarEnderecosSeriaisClick(Sender: TObject);
    procedure menuTrayRestaurarClick(Sender: TObject);
    procedure cdsIdsTicketsAfterPost(DataSet: TDataSet);
    procedure cdsContadoresDeFilasAfterPost(DataSet: TDataSet);
    procedure SubMenuStatusDasConexoesTcpIpClick(Sender: TObject);
    procedure SubMenuGruposTagsClick(Sender: TObject);
    procedure menuTagsClick(Sender: TObject);
    procedure menuTotensClick(Sender: TObject);
    procedure menuVisualizarPPsClick(Sender: TObject);
    procedure menuConfigurarPPsClick(Sender: TObject);
    procedure SubMenuGruposPPsClick(Sender: TObject);
    procedure menuMotivosDePausaClick(Sender: TObject);
    procedure SubMenuGruposMotivosPausaClick(Sender: TObject);
    procedure menuModulosSicsPAClick(Sender: TObject);
    procedure menuModulosSicsMultiPAClick(Sender: TObject);
    procedure menuModulosSicsOnLineClick(Sender: TObject);

    procedure CarregarConexoes(var S: string);
    procedure Debug1Click(Sender: TObject);
    procedure menuModulosSicsTGSClick(Sender: TObject);
    procedure mnuExcluirTodosClick(Sender: TObject);
    procedure socketImprimeCDBError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);

    procedure ImprimeSomenteCDB (NF : Integer; Senha  : Integer);
    procedure ManagePswdPopMenuPopup(Sender: TObject);
    procedure SubMenuClientesClick(Sender: TObject);
    procedure MenuModuloSicsCallCenterClick(Sender: TObject);
    function  VerificaLoginCliente(Login, Senha, Posicao: String): String;
    function  LogoutCliente(ID: integer; Posicao: String): String;
    function  AtenderChamadoCallcenter(Login,Senha,Posicao: String): String;
    function  InserirSenhaCallcenter(Fila, Senha: Integer): Integer;
    function  SetIdClienteSenha(IDTicket, IDCliente: Integer): Boolean;
    function  AlterarSenhaCliente(Login, SenhaA, SenhaN: String): String;

    procedure IdHTTPServerCommandGet(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure cdsIdsTicketsTagsAfterInsert(DataSet: TDataSet);
    function SetNomeCliente(ATicketId: Integer; ATipoReplicacao: TReplicacaoNomeCliente; ANomeCliente: String): Boolean;
    function  GetNome_NumeroFicha(ASenha:Integer): String;
    procedure Button1Click(Sender: TObject);
    procedure RoboFilaEsperaProfissionalTimer(Sender: TObject);
  private
    { Private declarations }
    vlUsarBotoeiras3B2L,vlUsarTeclados1100, vlUsarTeclados1200, vlDesabilitarBipes, vlFinalizarPelaSenhaCancelaEspera, vlRegistrarAtividadesImpressoras, fTransmitindoParaPainel, fFecharPrograma: Boolean;
    vlPAsComTeclados: TIntArray;
    fFilaPrioritaria, fMaxTags: Integer; // RAP fMaxTags
    vlOutBufferInterval       : Word;
    vlBotoesRetiradaManual    : array [1 .. 2] of Integer;
    vlDisposicaoDasFilas      : record
                                  linhas, colunas: Integer;
                                end;

    /// <summary>
    ///   Grava qtde tentativas de acessar configuração PA\MULTIPA com senha inválida
    /// </summary>
    FTentativasAcessoMenuProtegido: Integer;
    FDataUltimaTentativasAcessoMenuProtegido: TDateTime;
    FRoboFilaEsperaStatus : Boolean;
    FFilaEsperaProfissional : integer;
    FRoboFilaEsperaTempoSegundos: integer;

    Col, Row: Integer; // RAP
    //LM
    ADia: TDate;
    AQTDSenhas: Integer;
    ChamarDaFila: Integer;
    hora: string;

    function VerificaVersoesDLLs: Boolean;
    procedure EnviaEmail(IdPrinter: Integer; status: TStatusParaTotem; normalizar: Boolean);
    procedure EnviaAlarmeDeStatusDePapelParaPas(const AIdTotem: Integer; const ANomeImpressora: String; status: TStatusParaTotem);

    function AbrePortaPainel: Boolean;
    function AbrePortaImpressora: Boolean;
    procedure FechaPortaImpressora;
    function AbrePortaTeclado: Boolean;
    function GetPainelPortConfig: string;
    function SetPainelPortConfig(PainelConfig: string): Boolean;
    function ProcuraNasFilas(Pswd: Integer; out ANomeFila: String; out ADtHrSenha: TDateTime): Integer;
    function ProcuraNasPAs(Pswd: Integer; out ANomePA: String; out ADtHrSenha: TDateTime): Integer;
    function TemNoOutBuffer(const S: string; aLimparBuffer: Boolean = true): Boolean;
    procedure InsertInOutBuffer(Senha, IdPA: Integer; HoraSenha : String = '');
    procedure PrintPassword(IdPrinter, Senha: Integer; fila: Integer);
    procedure CallOnDisplay(IdPA, Pswd: Integer);
    procedure ClearDisplay(IdPainel: Integer);
    procedure AtualizaSenhaCountLabel(fila: Integer);
    procedure AtualizaLEDsDasBotoeiras3B2L(PAsString, ESPString: string);
    function CriaComponenteFila(FilaNo: Integer; FilaNome: string; ShowButton, ShowBlocked, ShowPriority: Boolean; Cor: Integer): Boolean;
    function CriaComponentePainelClientSocket(ClientSocketNo: Integer; IPAddress: string; IPPort: Integer): Boolean;
    function CriaComponenteTecladoClientSocket(ClientSocketNo: Integer; IPAddress: string; IPPort: Integer): Boolean;
    function CriaComponentePrinterClientSocket(ClientSocketNo: Integer; IPAddress: string; IPPort: Integer): Boolean;
    procedure LoadFilasToScreen;
    procedure DecifraProtocoloTotem(IdPrinter: Integer; S: string);

    procedure InicializaEsperaUltimosN(fila: Integer);
    procedure InicializaAtendimentoUltimos10(fila: Integer);
    procedure AtualizaEsperaUltimosN(fila: Integer; TIM: TDateTime);
    procedure AtualizaAtendimentoUltimos10(fila: Integer; TIM: TDateTime);
    function ObtemColunaDaTag(ID_GrupoTag: Integer): Integer; // RAP
    procedure SenhasListMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    function GetNewCDSFilter(const aDatasetOrigem: TClientDataSet): TClientDataSet;
    procedure FiltraDataSetComPermitidas (AConexao: TFDConnection; const aDataSet: TClientDataSet; const AIdModulo: Integer; const aNomeCampo: TTipoDeGrupo;
                                          aColunaFiltrarCDS: String = 'ID'; const aGetNomeColunaPorModulo: TGetNomeColunaPorModulo = nil);
    function EnviaComando(const ASocket: TCustomWinSocket; const AComando: string): Integer;

    procedure EnviarPushDeSenhaFinalizada(const ASenha: String);
    //RA
    //procedure CarregarDadosDatasetPA(arqname: string);
    //procedure CarregarDadosDatasetAtendentes(arqname: string);
    function BuscarImagemTotem(const IDTotem:Integer; var FileName: String; ImagemTela: Integer = 0): TStream;

    function BuscarImagemTotemMultiTelas(const IDTela:Integer): TStream;

    function BuscarImagemFila(const IDFila:Integer; var FileName: String; out Alinhamento:String): TStream;

    function GetWaitingPeopleOnTheLine(AIdPA: Integer; AProntuario: Boolean = False): String;
    procedure ProcessarTelas(AIdTela, AIdTelaPrincipal: integer;
      AArray: TJSONArray; AProcessadas: TList<integer>);

    procedure ConfigurarRoboFilaEsperaProfissional;
    procedure SetRoboFilaEsperaStatus(const Value: Boolean);
    procedure SetFilaEsperaProfissional(const Value:integer);
    procedure SetRoboFilaEsperaTempoSegundos(const Value: integer);
    property RoboFilaEsperaStatus : Boolean read FRoboFilaEsperaStatus write SetRoboFilaEsperaStatus;
    property RoboFilaEsperaTempoSegundos: integer read FRoboFilaEsperaTempoSegundos write SetRoboFilaEsperaTempoSegundos;

  public
    { Estas funcoes retornam: }
    { -3  -> a senha está numa fila não contida nas prioridades de atendimento }
    { -2  -> o atendente está aguardando para ser anunciado na painel }
    { -1  -> a senha não está em nenhuma fila }
    { 0,1,2... -> senha chamada }
    PortaImpressora   : Integer;
    vlTotens          : TTotensList;
    //LM
    vlTVs             : TTVsList;

    ImpressoraDefault : Integer;

    class procedure ExibirConfigModuloPA(const aOwner: TComponent;
      var aTentativasAcessoMenuProtegido: Integer; var aDataUltimaTentativasAcessoMenuProtegido: TDateTime);
    class procedure ExibirConfigModuloCallCenter(const aOwner: TComponent;
      var aTentativasAcessoMenuProtegido: Integer; var aDataUltimaTentativasAcessoMenuProtegido: TDateTime);
    class procedure ExibirConfigModuloMultiPA(const aOwner: TComponent;
      var aTentativasAcessoMenuProtegido: Integer; var aDataUltimaTentativasAcessoMenuProtegido: TDateTime);
    class procedure ExibirConfigModuloOnline(const aOwner: TComponent;
      var aTentativasAcessoMenuProtegido: Integer; var aDataUltimaTentativasAcessoMenuProtegido: TDateTime);
    class procedure ExibirConfigModuloTGS(const aOwner: TComponent;
      var aTentativasAcessoMenuProtegido: Integer; var aDataUltimaTentativasAcessoMenuProtegido: TDateTime);
    class procedure ExecutaComandoPorPermissaoAdmin(const aProcExecutar: TRefProc;
      var aTentativasAcessoMenuProtegido: Integer; var aDataUltimaTentativasAcessoMenuProtegido: TDateTime);
    procedure EnviaParaTodosOsClients(Socket: TServerWinSocket; S: string);
    procedure AjustaCanalDasTVs(IdTV, Canal: Integer);
    procedure EnviaCanaisPermissionados(IdTV: Integer);
    procedure ConfiguraCDBBematech(IdPrinter: Integer);
    procedure InicializaImpressoraFujitsu(IdPrinter: Integer);
    procedure InicializaImpressoraSeiko(IdPrinter: Integer);
    procedure InicializaImpressoraCustom(IdPrinter: Integer);
    function Imprime(IdPrinter: Integer; S: string) : boolean;
    procedure GeraSenhaEImprime(fila, IdPrinter: Integer; out Senha: Integer; out DtHr: TDateTime); Overload;
    procedure GeraSenhaEImprime(Fila, IdTotem: Integer; ATAGsAtribuir: String; out Senha: Integer; out DtHr: TDateTime); Overload;
    procedure InserirSenhaNaFila(AFila, ASenha, APosIt: Integer; ATipo: TTipoDeInsercaoDeSenha);

    function LoadCabecalhoTicket(IdPrinter: Integer): string;

    procedure Reimprime(Senha, IdPrinter: Integer);
    procedure WriteToDisplay(const IdPainel: Integer; aProtocolo: string);
    function AtualizarContadoresDeFilas(pFila: Integer): Boolean;

    function FormatarPIHorarioParaJornalEletronico(const AQtdeSegundos: Integer): String; overload;
    function FormatarPIHorarioParaJornalEletronico(const AQtdeSegundos, AFormatoHorario: Integer): String; overload;

    function Login                        (IdModulo, IdPA    : Integer; AtdIdOuLogin, Senha: string): Boolean; Overload;
    function Login                        (IdPA              : Integer; AtdLogin: string; ForcarLogin: Boolean; var MotivoErro : string): boolean; Overload;
    function Logout                       (IdAtd             : integer) : boolean;
    function LogoutPA                     (IdPA              : integer) : boolean;
    function ForcaLogin                   (IdPA              : Integer; AtdLogin, AtdNome : string; AtdGrupoId : integer; AtdGrupoNome: String): Boolean;
    function IniciarPausa                 (IdPA, MotivoPausa : integer) : boolean;
    function FinalizarPausa               (IdPA              : integer) : boolean;
    function Proximo                      (IdPA              : integer; var IniTime : TDateTime) : integer;
    function Rechama                      (IdPA              : integer) : integer;
    function Finaliza                     (IdPA              : integer) : integer;
    function FinalizaPelaSenha            (Pswd              : integer) : integer;
    function ChamaEspecifica              (IdPA, Pswd        : integer; var IniTimeEspera : TDateTime) : integer;
    function ForcaChamada                 (IdPA, Pswd        : integer; var IniTimeEspera : TDateTime; var IdFila : integer; var NomeFila : string) : integer;
    function Redireciona                  (IdPA, NF          : integer) : integer;
    function RedirecionaEProximo          (IdPA, NF          : integer) : integer;
    function RedirecionaEEspecifica       (IdPA, NF, Pswd    : integer) : integer;
    function RedirecionaEForca            (IdPA, NF, Pswd    : integer) : integer;

    function GetIdTicket (Senha : Integer) : Integer;
    function GetIdTicketIfPwdExists(Senha: Integer): Integer; overload;
    function GetIdTicketIfPwdExists(Senha: Integer; Out IdFila, IdPA: Integer): Integer; overload;

    function DefinirTagParaSenha(Senha, IdTag: Integer)        : Integer;
    function DesassociarTagParaSenha(Senha, IdTag: Integer)    : Integer;
    function GetTagsTicket(Ticket: Integer)                    : TIntArray;
    function DefinirNomeParaSenha(Senha: Integer; Nome: string): Boolean;
    function GetNomeParaSenha(Ticket: Integer)                 : string;
    procedure InsereAgendamentoFila (IdTicket, IdFila : integer; DataHora : TDateTime);

    procedure FazChamadaAutomatica        (Fila              : integer; ExcetoPA :  Integer = -1);

    procedure LoadPswds;
    procedure SaveTags;
    procedure SaveAgendamentosFilas;
    procedure SalvaSituacao_Fila(ID: Integer);
    procedure SalvaSituacao_Counters;
    procedure SalvaSituacao_Atendimento;
    procedure SalvaSituacao_PPs;
    procedure SalvaSituacao_Tickets;
    function EnviarComandoTeclado(const aProtocolo: String): BOolean;

    procedure AtualizaTagsNoStringGrid(Senha : integer; sg : TStringGrid);
    procedure PopularStringGridFilas(pGrid: TStringGrid; pFila: Integer);
    procedure AtualizarIDsTickets;
    procedure AtualizarIDsTicketsTags;
    procedure AtualizarAgendamentoFilas;
    procedure AtualizarProcessoParalelo;

    procedure LoadTotens;

    procedure LoadTVs;

    function RetrievePswd(fila: Integer; var Pswd: Integer; var PswdTime: TDateTime): Boolean;

    procedure InsertPswd                   (Fila : integer; Pswd : integer; PswdDateTime : TDateTime; Posit : integer; ExcetoPA : Integer = -1);

    procedure SetNomeDoClienteNoStringGrid(fila: Integer; Pswd: Integer; Nome: string);

    function GetWaitingTickets(PA: Integer): Integer;

    procedure GetSendOnePASituationText(PA: Integer; var S: string);
    procedure GetSendPAsSituationText(PA: Integer; var S: string);
    procedure GetSendOnePAStatus(PA: Integer; var S: string);
    procedure GetSendPAsSituationTextParaTeclado(var S: string);
    procedure GetSendFilasText(var S: string);
    procedure GetSendOneFilaText(ID: Integer; var S: string);
    procedure GetSendWaitingPswdsText(var S: string);
    procedure GetSendWaitingPswdsTextParaTeclado(var S: string);
    procedure GetSendAtdsListText(const aIdModulo: Integer; var S: string);
    procedure GetSendPAsListText(const IdModulo: Integer; var S: string);
    procedure GetSendFilasNamesText(const IdModulo: Integer; var S: string);
    procedure GetSendTagsNamesText(const aIdModulo: Integer; var S: string);
    procedure GetSendPPsTableText(const AIdModulo: Integer; var S: string);
    procedure GetSendMotivosDePausaTableText(const AIDModulo: Integer; var S: string);

    //JLS
    function  CheckMotivoPausaPermitidoNaPA(const PA: Integer; MotivoPausaRequisitado:Integer):boolean;

    function  GetSendMotivosDePausaTableTextPA(const PA: Integer): String;
    procedure GetSendStatusDasPAsTableText(var S: string);
    procedure GetSendConfiguracoesGeraisText(var aRetorno: string; const aFiltroIDConfig: String; const aIncluirID: Boolean = True);
    procedure GetJSONBySQLText(var aRetorno: string; const aSQL: String);
    procedure GetSendGruposNamesText(const aTipoGroupoPorModulo: TTipoGrupoPorModulo; var S: string);
    procedure GetSendPrioritiesText(var S: string);
    procedure GetSendPIsNamesText(const AIdModulo: Integer; var S: string);
    procedure GetSendPIsSituationText(var S: string);
    procedure GetSendAlarmesAtivosText(const PA: Integer; var S: string);
    procedure GetSendPIsPossiveis(const AIdModulo: Integer; var S: string);

    procedure GetSendOneFilaDetailedSituationText(fila: Integer; var S: string; AProntuario: boolean = True);
    procedure GetSendSituacaoPrioritariasBloqueadasText(var S: string);
    procedure GetSendCanaisNamesText(IdTV: Integer; var S: string);
    procedure GetSendPPsSituationText(Senha: Integer; var S: string);
    procedure GetSendAgendamentosFilasText(Senha: Integer; var s : string);
    procedure GetSendPrioridadesAtendimentoPAText(const aPA: Integer; var s: string);
    procedure GetSendFilasComRange(var s: string);
    procedure GetStatusSenha(const APwd: Integer; var s: string);
    function  GetSendListaDeTotens: String;
    //LM
    function  GetSendListaDeBotoesPorTotem(const AIDTotem: Integer): String;
    procedure GetPaineisTV(out s: string);
    procedure BroadcastListaDeAtendentes;
    function AtualizaAtendente(const aIdAtd: Integer; const aAtivo: Boolean; const aNome, aLogin,
      aSenhaLogin, aAtdRegFunc: string; const aGrupoAtend: Integer): Boolean;
    function  GetNomeFilas(const IdModulo: Integer): String;


    procedure BroadcastAgendamentosPorFila(Senha : integer);
    procedure BroadcastChamadasComTE (PA, Senha : integer; DataHora : TDateTime);

    procedure EnviaAlarmesParaPAs (GruposDePAs : string; NomePI, NomeNivel : string; CorNivel : integer; Mensagem : string);
    procedure GravarAlarmesAtivosPorPA;

    /// <summary>
    ///   Calcula o TEE de uma Fila
    /// </summary>
    function CalculaTEE (Fila : integer;var AQTDEPAProdutiva,AQTDEPessoasEspera, AIDTEE:integer) : TDateTime; overload;
    /// <summary>
    ///   Calcula o TEE de todas as filas de uma Unidade
    /// </summary>
    function CalculaTEE: String; overload;

    function GetTempoEsperaUltimosN(Fila : integer): TDateTime; overload;
    function GetTempoEsperaUltimosN: String; overload;

    /// <summary>
    ///   Calcula o TMA de todas as filas Ativas
    /// </summary>
    function GetTMAFilas: String;

    function MinutesBetween(aNow, aThen :TDateTime) :Int64;

    function AtualizaSenhaAtendente(const aIdAtd: Integer; const aSenhaLogin: string): Boolean;
    function InsereAtendente(Nome, Login, SenhaLogin: string; GrupoAtend: Integer): Integer;
    function VerificaSeAtendenteEPermitidoNoModulo (IdAtd, IdModulo : integer) : boolean;
    function InsereGrupoAtendente(Id:Integer; Nome : string) : Boolean;
    function AtualizaGrupoAtendente(Nome : string) : Boolean;
    function PessoasNasFilasEsperaPA(AIdPA: Integer; AProntuario: Boolean = False) : String;

    procedure InicializarDados;

    procedure GravarLogSocket(AComando: string);

    procedure CriarItemsFormConexoes;

    function GetModeloImpressoraZero: TTipoDeImpressora;

    procedure AtualizaSituacaoPA(IdPA: Integer);

    procedure ConstroiXMLDaIntegracaoWebService(IdPainel: Integer; var Mensagem: string);
    function  RemoveTag(AText: string): string;
    procedure ExcluirSenhasPelaFila(IdFila : integer);
    procedure SalvaUltimaPAModoTerminalServer(idModulo,idPA :  integer);
    procedure SendMessageToPanel(const AIdPanel: Integer; const AMsg: String);
    procedure ProcessarMensagensPaineis;
    procedure SubstituirTagsDePIs(var AMsg: string);
    //ALTERADO POR: Jefferson Luis de Simone. - DATA: 07/01/2019.
    procedure EscondeAplicacao;
    procedure RestauraOuEscondeAplicacaoNaBandeja(pStatusTryIcon:boolean);

    procedure WMSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;

    function BuscarMaxIDSenha(ASenha: Integer): Boolean;
    function GetTelefoneDadosAdicionais(ASenha: Integer; out ATelefone, AIdioma: String): Boolean;
    function GetCodProfissional(ASenha: Integer; out ACodProfissional: String): Boolean;
    //
    procedure AtualizaStatusTV(AIP, ATunerPresent, AVideoState, AVideoError, ACurrentUI, ALegenda, ACurrentChannel : String);
    function  BuscaStatusTV(AIP: String): String;

    //LM
    procedure CarregarGruposPAS_AlarmesPapelTotens;
    procedure LimparObjetosCalculoTMEPorFila;
    procedure LimparObjetosCalculoTMAPorFila;
    procedure ApagarSenhasEmEsperas;
    procedure FazerLogoutsDasPAs;
    function GravaRespostaPesquisaSatisfacao(ADados:TJsonObject):Boolean;
    function BuscaRespostaPesquisaSatisfacaoFluxo(ADados:TJsonObject):TJsonObject;
    procedure GetGrupoFilas(var s: string);
    procedure GetCategoriaFilas(var s: string);
    property FilaEsperaProfissional : integer read FFilaEsperaProfissional write SetFilaEsperaProfissional;
    procedure GetFilaProximaSenha(out IdFila: Integer; out NomeFila: string; out DataHora: string);
  end;

var
  frmSicsMain          : TfrmSicsMain;
  vgMostrarNomeCliente : Boolean;
  ChamarProximoNoLogin : Boolean;
  SomenteRedirecionar  : Boolean;

implementation

{$R *.DFM}

uses
  NBackup, cfgPrioridades, ufrmCadAlarmes, ufrmCadHor, ufrmCadPIS, Sics_3,
  Sics_Common_Splash, sics_dm, udmContingencia, Windows, uFuncoes, Math, sics_4,
  uServico, ufrmDebugParameters, ufrmCadTotens, uFrmConfiguracoesSicsPA,
  Winapi.WinSock, uFrmConfiguracoesSicsMultiPA, uFrmConfiguracoesSicsOnLine,
  uFrmConfiguracoesSicsTGS, uPushSender, uFrmConfiguracoesSicsCallCenter, uCallCenterConsts,
  ASPGenerator, UConexaoBD, uTempoUnidade, uMessenger;

var
  vlNumeroDePainelClientSockets, vlNumeroDeTecladoClientSockets, vlNumeroDePrinterClientSockets: Integer;
  IdsTotens: array [1 .. cgMaxTotens] of Integer;

const
  cSenhaAdmin = 'admin';

function GetProntuarioPaciente(IdTicket: Integer): Integer;
begin
  dmSicsMain.qryCamposAdicionais.Close;
  dmSicsMain.qryCamposAdicionais.Params[0].AsInteger := IdTicket;
  dmSicsMain.qryCamposAdicionais.Open;

  if ((not dmSicsMain.qryCamposAdicionais.IsEmpty) and (dmSicsMain.qryCamposAdicionais.Locate('CAMPO', 'PRONTUARIO', []))) then
    Result := dmSicsMain.qryCamposAdicionais.FieldByName('VALOR').AsInteger
  else
    Result := 0;

  dmSicsMain.qryCamposAdicionais.Close;
end;

procedure TfrmSicsMain.EscondeAplicacao;
begin
  TTaskbarList.Remove(Application.Handle);
end;

procedure TfrmSicsMain.WMSysCommand(var Msg: TWMSysCommand);
begin
  if (Msg.CmdType = SC_MINIMIZE) then
    EscondeAplicacao;

  inherited
end;

procedure TfrmSicsMain.RestauraOuEscondeAplicacaoNaBandeja(pStatusTryIcon:boolean);
begin
  TrayIcon1.visible := true;
  if (pStatusTryIcon) then
  begin
    TTaskbarList.Insert(Application.Handle);
    Application.Restore;
  end
  else
  begin
    Application.Minimize;
    EscondeAplicacao;
  end;
end;

function TfrmSicsMain.VerificaVersoesDLLs: Boolean; // ainda a ser implementada
begin
  Result := True;
end;

procedure TfrmSicsMain.EnviaEmail(IdPrinter: Integer; status: TStatusParaTotem; normalizar: Boolean);
var
  {$IFDEF SuportaEmail}
  E    : EEnvioDeEmail;
  {$ENDIF SuportaEmail}
  S    : string;
  email: string;
begin
  if not vgParametrosModulo.EmailsMonitoramento.Enviar then
    Exit;

  if normalizar then
  begin
    case status of
      stSemConexao  : S := 'NORMALIZADO - O sistema está conectado ao tótem.';
      stOffLine     : S := 'NORMALIZADO - Impressora online.';
      stPoucoPapel  : S := 'NORMALIZADO - Impressora com papel';
      stSemPapel    : S := 'NORMALIZADO - Impressora com papel';
    end; { case }
  end
  else
  begin
    case status of
      stSemConexao  : S := 'O sistema não está conseguindo conexão com o tótem.';
      stOffLine     : S := 'Impressora offline. Totem inoperante.';
      stPoucoPapel  : S := 'O papel está acabando.';
      stSemPapel    : S := 'O papel acabou. Totem inoperante.';
    end; { case }
  end;

  // obtendo o email
  case status of
    stSemConexao, stOffLine   : email := vgParametrosModulo.EmailsMonitoramento.ConexaoEquipamentos;
    stPoucoPapel, stSemPapel  : email := vgParametrosModulo.EmailsMonitoramento.FaltaPapel;
    else email := '';
  end;

  {$IFDEF SuportaEmail}
  if email <> '' then
  begin
    if AspEnviaEmail(email, '*** SICS - Totem de Auto-Retirada de Senhas ***', '*********************************************************************'#13#10 +
                                                                               '*  Unidade: ' + FormatLeftString(54, vgParametrosModulo.NomeUnidade) + '  *'#13#10 +
                                                                               '*  Horário: ' + FormatLeftString(54, FormatDateTime('dd/mm/yyyy hh:nn:ss', now)) + '  *'#13#10 +
                                                                               '*  Totem:   ' + FormatLeftString(54, '#' + IntToStr(IdPrinter) + ' - ' + string(vlTotens[IdPrinter].IP)) + '  *'#13#10 +
                                                                               '*  Status:  ' + FormatLeftString(54, S) + '  *'#13#10 +
                                                                               '*********************************************************************') then
      E := EEnvioDeEmail.Create('E-mail de monitoramento enviado com sucesso.')
    else
      E := EEnvioDeEmail.Create('Falha ao enviar e-mail de monitoramento.');

    MyLogException(E);
  end;
  {$ENDIF SuportaEmail}
end;

function TfrmSicsMain.AbrePortaPainel: Boolean;
var
  VetorDeConexoesIP: TConexaoIPArray;
  I                : Integer;
  S                : string;
  ArqIni           : TIniFile;
begin
  try
    if (PainelPort.DeviceName <> '') then
    begin
      if (UpperCase(PainelPort.DeviceName[1]) <> 'C') then
      begin
        PainelTcpPort.Port := StrToInt(PainelPort.DeviceName);
        PainelTcpPort.Open;
        Delay(700);
        if not PainelTcpPort.Active then
        begin
          Result := false;
          Application.MessageBox('Erro ao abrir porta do painel.', 'Erro', MB_ICONSTOP);
        end
        else
          Result := True;
      end
      else
      begin
        PainelPort.Open;
        Result := True;
      end;
    end
    else
    begin
      Result := false;
    end; { if PainelPort.DeviceName <> '' }
  except
    Result := false;
    Application.MessageBox('Erro ao abrir porta do painel.', 'Erro', MB_ICONSTOP);
  end; { try .. except }

  ArqIni := TIniFile.Create(GetIniFileName);
  try
    S := ArqIni.ReadString('ConexoesTcpIp', 'Paineis', '');
    ArqIni.WriteString('ConexoesTcpIp', 'Paineis', S);
  finally
    ArqIni.Free;
  end;

  try
    if S <> '' then
    begin
      VetorDeConexoesIP := StrToConexaoIpArray(S);
      for I             := low(VetorDeConexoesIP) to high(VetorDeConexoesIP) do
        CriaComponentePainelClientSocket(I + 1, VetorDeConexoesIP[I].EnderecoIP, VetorDeConexoesIP[I].PortaIP);
      Finalize(VetorDeConexoesIP);
    end;
  except
    Result := false;
    Application.MessageBox('Erro ao criar componentes de comunicação TCP/IP com painéis.', 'Erro', MB_ICONSTOP);
  end;
end; { func AbrePortaPainel }

function TfrmSicsMain.AbrePortaImpressora: Boolean;
var
  I: Integer;
begin
  try
    if ((PrinterPort.DeviceName <> '') and (UpperCase(PrinterPort.DeviceName[1]) = 'L')) then
    begin
      PortaImpressora := 0;
      PortaImpressora := CreateFile('LPT1', GENERIC_WRITE, 0, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL or FILE_FLAG_NO_BUFFERING, 0);
    end
    else if ((PrinterPort.DeviceName <> '') and ((PrinterPort.DeviceName[1] >= '0') and (PrinterPort.DeviceName[1] <= '9'))) then
    begin
      // MUDA O DEVICENAME PARA NÃO SALVAR O IP NO PRINTERPORT E SIM NO SAVETOTENS
      PrinterPort.DeviceName := '';
    end
    else if PrinterPort.DeviceName <> '' then
      try
        PrinterPort.Open;
      except
        Application.MessageBox('Erro ao abrir porta da impressora.', 'Erro', MB_ICONSTOP);
      end; { try .. except }

    for I := 1 to cgMaxTotens do
      if vlTotens[I].IP <> '' then
        CriaComponentePrinterClientSocket(I, string(vlTotens[I].IP), 3001);

    Result := True;
  except
    Result := false;
  end;
end; { func AbrePortaImpressora }

procedure TfrmSicsMain.FechaPortaImpressora;
var
  I: Integer;
begin
  if ((PrinterPort.DeviceName <> '') and (UpperCase(PrinterPort.DeviceName[1]) = 'L')) then
  begin
    CloseHandle(PortaImpressora);
    PortaImpressora := 0;
  end
  else
  begin
    PrinterPort.Close;
  end;

  for I := 1 to vlNumeroDePrinterClientSockets do
  begin
    (FindComponent('PrinterClientSocket' + IntToStr(IdsTotens[I])) as TClientSocket).Close;
    vlTotens[IdsTotens[I]].StatusSocket := ssIdle;
  end;
end; { proc FechaPortaImpressora }

function TfrmSicsMain.AbrePortaTeclado: Boolean;
var
  VetorDeConexoesIP: TConexaoIPArray;
  I                : Integer;
  S                : string;
  ArqIni           : TIniFile;
begin
  Result := True;
  try
    if (TecladoPort.DeviceName <> '') then
      TecladoPort.Open;
  except
    Result := false;
    Application.MessageBox('Erro ao abrir porta dos teclados.', 'Erro', MB_ICONSTOP);
  end; { try .. except }

  ArqIni := TIniFile.Create(GetIniFileName);
  try
    S := ArqIni.ReadString('ConexoesTcpIp', 'Teclados', '');
    ArqIni.WriteString('ConexoesTcpIp', 'Teclados', S);
  finally
    ArqIni.Free;
  end;

  try
    if S <> '' then
    begin
      VetorDeConexoesIP := StrToConexaoIpArray(S);
      for I             := low(VetorDeConexoesIP) to high(VetorDeConexoesIP) do
        CriaComponenteTecladoClientSocket(I + 1, VetorDeConexoesIP[I].EnderecoIP, VetorDeConexoesIP[I].PortaIP);
      Finalize(VetorDeConexoesIP);
    end;
  except
    Result := false;
    Application.MessageBox('Erro ao criar componentes de comunicação TCP/IP com teclados.', 'Erro', MB_ICONSTOP);
  end;
end; { func AbrePortaPainel }


procedure TfrmSicsMain.GetPaineisTV(out s: string);
begin
  try
    dmSicsMain.cdsPaineisClone.CloneCursor(dmSicsMain.cdsPaineis, True);
    dmSicsMain.cdsPaineisClone.Filter   := 'ID_MODELOPAINEL = ' + IntToStr(10);
    dmSicsMain.cdsPaineisClone.Filtered := True;
    dmSicsMain.cdsPaineisClone.First;
    while not dmSicsMain.cdsPaineisClone.Eof do
    begin
      S := S + dmSicsMain.cdsPaineisClone.FieldByName('NOME').AsString + ';' +
        dmSicsMain.cdsPaineisClone.FieldByName('TCPIP').AsString + TAB;
      dmSicsMain.cdsPaineisClone.Next;
    end;
    dmSicsMain.cdsPaineisClone.Close;
  finally
    dmSicsMain.cdsPaineisClone.Filtered := false;
    dmSicsMain.cdsPaineisClone.Filter   := '';
  end;
end;

function TfrmSicsMain.GetPainelPortConfig : string;
begin
  case PainelPort.Baudrate of
    br1200  : Result := '1200,';
    br2400  : Result := '2400,';
    br4800  : Result := '4800,';
    br9600  : Result := '9600,';
    br14400 : Result := '14400,';
    br19200 : Result := '19200,';
    else
      Result := 'bbbb,';
  end;  { case }

  case PainelPort.Databits of
    db7 : Result := Result + '7,';
    db8 : Result := Result + '8,';
    else
      Result := Result + 'd,';
  end;  { case }

  case PainelPort.Parity of
    paNone : Result := Result + 'n,';
    paEven : Result := Result + 'e,';
    paOdd  : Result := Result + 'o,';
    else
      Result := Result + 'p,';
  end;  { case }

  case PainelPort.Stopbits of
    sb1 : Result := Result + '1';
    sb2 : Result := Result + '2';
    else
      Result := Result + 's';
  end;  { case }
end;  { func GetPainelPortConfig }


function TfrmSicsMain.SetPainelPortConfig (PainelConfig : string) : boolean;
var
  i, auxbaud, auxdatalength, auxstopbits : integer;
  auxparity                              : char;
  aux                                    : string;
begin
  Result := true;
  try
    auxbaud       := 0;
    auxdatalength := 0;
    auxparity     := #0;
    aux           := '';

    for i := 1 to length(PainelConfig) do
    begin
      if PainelConfig[i] = ',' then
      begin
        if auxbaud = 0 then
          auxbaud := strtoint(aux)
        else if auxdatalength = 0 then
          auxdatalength := strtoint(aux)
        else
          auxparity := aux[1];
        aux := '';
      end
      else
        aux := aux + PainelConfig[i];
    end;
    auxstopbits := strtoint(aux);

    case auxbaud of
      1200   : PainelPort.Baudrate := br1200 ;
      2400   : PainelPort.Baudrate := br2400 ;
      4800   : PainelPort.Baudrate := br4800 ;
      9600   : PainelPort.Baudrate := br9600 ;
      14400  : PainelPort.Baudrate := br14400;
      19200  : PainelPort.Baudrate := br19200;
      else
        Result := false;
    end;  { case }

    case auxdatalength of
      7 : PainelPort.Databits := db7;
      8 : PainelPort.Databits := db8;
      else
        Result := false;
    end;  { case }

    case auxstopbits of
      1 : PainelPort.Stopbits := sb1;
      2 : PainelPort.Stopbits := sb2;
      else
        Result := false;
    end;  { case }

    case auxparity of
      'N', 'n' : PainelPort.Parity := paNone;
      'E', 'e' : PainelPort.Parity := paEven;
      'O', 'o' : PainelPort.Parity := paOdd;
      else
        Result := false;
    end;  { case }

    // Para gerar erro na function de abertura de porta do painel
    if not Result then
      PainelPort.DeviceName := 'COM_ERRO';
  except
    Result := false;
  end;
end;

procedure TfrmSicsMain.SetRoboFilaEsperaStatus(const Value: Boolean);
begin
  FRoboFilaEsperaStatus := Value;
end;

procedure TfrmSicsMain.SetRoboFilaEsperaTempoSegundos(const Value: integer);
begin
  FRoboFilaEsperaTempoSegundos := Value;
end;

procedure TfrmSicsMain.socketImprimeCDBError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  Socket.Close;

  if vlRegistrarAtividadesImpressoras then
    MyLogException(ERegistroDeOperacao.Create('SocketError - Impressora: Fila nº ' + IntToStr((Sender as TClientSocket).Tag) + ' - IP: ' + (Sender as TClientSocket).Host + ' - Erro: ' + IntToStr(ErrorCode)));

  ErrorCode := 0;
end;

{ func SetPainelPortConfig }

procedure TfrmSicsMain.IdHTTPServerCommandGet(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  LPath: TArray<string>;
  LPathLength: Integer;
  LStream: TStream;
  LTotem: Integer;
  LTela: Integer;
  LFila: Integer;
  LFileName: String;
  LAlinhamento: String;
  LTelaImagem: Integer;
  procedure ResponseWithInvalidRequest;
  begin
    AResponseInfo.ResponseNo := 400;
    AResponseInfo.ContentText := 'invalid request';
  end;
begin
  //http://localhost/imagens/totem/99/0
  //('', 'imagens', 'totem', '99', 0)
  LPath := ARequestInfo.URI.ToLower.Split(['/']);
  LPathLength := Length(LPath);
  if LPathLength > 1 then
  begin
    //  localhost/imagens
    if LPath[1] = 'imagens' then
    begin
      //localhost/imagens/totem
      if (LPathLength > 2) then
      begin
        if (LPath[2] = 'totem') then
        begin
          if (LPathLength > 3) and (LPath[3] <> EmptyStr) then
            LTotem := StrToIntDef(LPath[3], 0)
          else
          begin
            ResponseWithInvalidRequest;
            exit
          end;

          if ((LPathLength > 4) and (LPath[4] <> EmptyStr)) then
          begin
            LTelaImagem := StrToIntDef(LPath[4], 0)
          end
          else
          begin
            LTelaImagem := 0;
            //Default que é primeira tela caso não foi enviado o parametro de imagem
          end;

          {$REGION '//Processar obtenção de imagem de Totem'}
          try
            LStream := BuscarImagemTotem(LTotem, LFileName, LTelaImagem);

            if Assigned(LStream) then
            begin
              AResponseInfo.ResponseNo := 200;
              AResponseInfo.FreeContentStream := True;
              AResponseInfo.ContentType := AResponseInfo.HTTPServer.MIMETable.GetFileMIMEType(LFileName);
              AResponseInfo.ContentStream := LStream;
            end
            else
            begin
              AResponseInfo.ResponseNo := 404;
            end;
          except
            on E: Exception do
            begin
              AResponseInfo.ResponseNo := 500;
              AResponseInfo.ContentText := 'Erro: ' + E.Message;
            end;
          end;
          {$ENDREGION}
        end
        else
        if (LPath[2] = 'fila') then
        begin
          if (LPathLength > 3) and (LPath[3] <> EmptyStr) then
            LFila := StrToIntDef(LPath[3], 0)
          else
            ResponseWithInvalidRequest;

          {$REGION '//Processar obtenção de imagem de Fila'}
          try
            LStream := BuscarImagemFila(LFila, LFileName, LAlinhamento);
            if Assigned(LStream) then
            begin
              AResponseInfo.ResponseNo := 200;
              AResponseInfo.FreeContentStream := True;
              AResponseInfo.CustomHeaders.AddValue('Alinhamento',LAlinhamento);
              AResponseInfo.ContentType := AResponseInfo.HTTPServer.MIMETable.GetFileMIMEType(LFileName);
              AResponseInfo.ContentStream := LStream;
            end
            else
            begin
              AResponseInfo.ResponseNo := 404;
            end;
          except
            on E: Exception do
            begin
              AResponseInfo.ResponseNo := 500;
              AResponseInfo.ContentText := 'Erro: ' + E.Message;
            end;
          end;
          {$ENDREGION}
        end
        else
        if (LPath[2] = 'totemmultitelas') then
        begin
          if (LPathLength > 3) and (LPath[3] <> EmptyStr) then
            LTela := StrToIntDef(LPath[3], 0)
          else
          begin
            ResponseWithInvalidRequest;
            exit
          end;

          {$REGION '//Processar obtenção de imagem de Totem'}
          try
            LStream := BuscarImagemTotemMultiTelas(LTela);

            if Assigned(LStream) then
            begin
              AResponseInfo.ResponseNo := 200;
              AResponseInfo.FreeContentStream := True;
              AResponseInfo.ContentType := AResponseInfo.HTTPServer.MIMETable.GetFileMIMEType(LFileName);
              AResponseInfo.ContentStream := LStream;
            end
            else
            begin
              AResponseInfo.ResponseNo := 404;
            end;
          except
            on E: Exception do
            begin
              AResponseInfo.ResponseNo := 500;
              AResponseInfo.ContentText := 'Erro: ' + E.Message;
            end;
          end;
          {$ENDREGION}
        end
      end;
    end
    else
      ResponseWithInvalidRequest;
  end
  else
  begin
    AResponseInfo.ResponseNo := 200;
    AResponseInfo.ContentText := 'SICS File Server';
  end;
end;

function TfrmSicsMain.Imprime(IdPrinter: Integer; S: string) : boolean;
var
  b : array[0..1024] of char;
  x : DWord;
  i : integer;
begin
  Result := false;
  if PrinterPort.DeviceName <> '' then
  begin
    if UpperCase(PrinterPort.DeviceName[1]) = 'L' then
    begin
      if PortaImpressora = 0 then
        AbrePortaImpressora;

      for i := 1 to length(s) do
        b[i-1] := s[i];
      b[length(s)] := #0;
      WriteFile (PortaImpressora, b, length(s), x, nil);
    end
    else if PrinterPort.Active then
    begin
      PrinterPort.WriteText(s);
      Result := true;
    end;
  end
  else if IdPrinter = 0 then
  begin
    if ((FindComponent('PrinterClientSocket1') <> nil) and ((FindComponent('PrinterClientSocket1') as TClientSocket).Active)) then
    begin
      (FindComponent('PrinterClientSocket1') as TClientSocket).Socket.SendText(s);
      Result := true;
    end;
  end
  else if ((FindComponent('PrinterClientSocket'+inttostr(IdPrinter)) <> nil) and ((FindComponent('PrinterClientSocket'+inttostr(IdPrinter)) as TClientSocket).Active)) then
  begin
    (FindComponent('PrinterClientSocket'+inttostr(IdPrinter)) as TClientSocket).Socket.SendText(s);
    Result := true;
  end;
end;


procedure TfrmSicsMain.ImprimeSomenteCDB(NF, Senha: Integer);

var
  s1,s2 : string;
  BM    : TBookmark;

  function AbreSocket(IpPort : string; NF : Integer) : boolean;
  var
    EndIp, PortaIp : string;
    Timeout        : TDateTime;
  begin
    Result  := false;
    SeparaStrings(IpPort, ':', EndIp, PortaIp);
    with socketImprimeCDB do
    begin
      Host    := EndIp;
      Port    := StrToIntDef(PortaIp, 3001);
      Tag     := NF;

      Timeout := now + EncodeTime(0, 0, 7, 0);
      while (not Active) and (now < Timeout) do
      begin
        if Status = AspClientSocket.TStatusSocket(ssIdle) then
          Open;
        Application.ProcessMessages;
      end;

      Result := Active;
    end;
  end;

  procedure configuraCDB;
  var
    S : string;
  begin
     { setar impressora para modo ESC BEMA }
     s := #29#249#32#0;

     socketImprimeCDB.Socket.SendText(s);
     Delay(100);

          { configura altura do codigo de barras para 162 x 0,125mm = 20,25mm }
     s := #29#104#162  +

          { configura largura da barra do codigo de barras para "grossa" }
          #29#119#2  +

          { configura para nao aparecer o texto no codigo de barras }
          #29#72#0;

     socketImprimeCDB.Socket.SendText(s);
  end;

begin
  with dmSicsMain.cdsFilas do
  begin
    BM := GetBookmark;
    try
      try
        if Locate('ID', NF, []) then
        begin
          if not FieldByName('IMPRIME_CDB').AsBoolean then
            Exit;

          if FindField ('IP_PORTA_IMPRESSORA') <> nil then
          begin
            if not AbreSocket(FieldByName('IP_PORTA_IMPRESSORA').AsString, NF) then
              Exit;
          end
          else
          begin
            Exit;
          end;
        end;
      finally
        if BookmarkValid(BM) then
          GotoBookmark(BM);
      end;
    finally
      FreeBookmark(BM);
    end;
  end;

  configuraCDB;

  s1 := '{{Liga Altura Dupla}}{{Liga Largura Dupla}}{{Liga Negrito}}{{Liga Largura Dupla, Altura Dupla e Negrito}}' +
        'SENHA:  ' + IntToStr(Senha) +
        '{{Desliga Negrito}}{{Desliga Largura Dupla}}{{Desliga Altura Dupla}}{{Quebra de Linha}}{{Quebra de Linha}}';

  { Codigo de barras padrao CODE39 }
  s1 := s1 + '{{CDB Code39}}' + FormatLeftString(10, '%TCK' + IntToStr(Senha) + '$') + '{{Fim de Bloco CDB Code39}}';

  ConverteProtocoloImpressora(s2, s1, tiBematech);
  socketImprimeCDB.Socket.SendText(s2);

  if vgParametrosModulo.SomenteCdb_CorteAoFinal then
  begin
    s1 := '{{Corte Total}}';

    ConverteProtocoloImpressora(s2, s1, tiBematech);
    socketImprimeCDB.Socket.SendText(s2);
  end;

  socketImprimeCDB.Close;
end;

{ ----------------------------------------------------------- }
{ procedures genéricas de processamento em baixo nível }

procedure RemoveRow(SG: TStringGrid; RowNo: Integer);
var
  I: Integer;
begin
  for I := RowNo + 1 to (SG.RowCount - 1) do
    SG.Rows[I - 1].Assign(SG.Rows[I]);
  if SG.RowCount > 2 then
    SG.RowCount := SG.RowCount - 1
  else
    for I            := 0 to (SG.ColCount - 1) do
      SG.Cells[I, 1] := '';
end; { proc RemoveRow }

procedure RemoveCol(SG: TStringGrid; ColNo: Integer);
var
  I: Integer;
begin
  for I := ColNo + 1 to (SG.ColCount - 1) do
    SG.Cols[I - 1].Assign(SG.Cols[I]);
  if SG.ColCount > 2 then
    SG.ColCount := SG.ColCount - 1
  else
    for I            := 0 to (SG.RowCount - 1) do
      SG.Cells[1, I] := '';
end; { proc RemoveCol }

procedure InsertRow(SG: TStringGrid; RowNo: Integer);
var
  I: Integer;
begin
  if ((SG.RowCount > 2) or (SG.Cells[0, 1] <> '')) then
  begin
    SG.RowCount := SG.RowCount + 1;
    for I       := SG.RowCount - 1 downto (RowNo + 1) do
      SG.Rows[I].Assign(SG.Rows[I - 1]);
  end;
end; { proc InsertRow }

procedure TfrmSicsMain.EnviaParaTodosOsClients(Socket: TServerWinSocket; S: string);
var
  I, Ret : Integer;
begin
  TfrmDebugParameters.Debugar (tbAtividadeDeSocket, 'Entrou EnviaParaTodosOsClients');
  for I := Socket.ActiveConnections - 1 downto 0 do
    try
      if I <= Socket.ActiveConnections - 1 then
      begin
        Ret := EnviaComando(Socket.Connections[I], S);
        GravarLogSocket('E - Porta=' + inttostr(Socket.Connections[i].LocalPort) + ' - IP=' + Socket.Connections[i].RemoteAddress + ' - Ret=' + inttostr(Ret) + ' - i=' + inttostr(i) + ' - STR=' + s);
      end;
    except
      MyLogException(ESocketError.Create('Erro de socket. IP Remoto = ' + Socket.Connections[I].RemoteAddress + '. Fechando esta conexão.'));
      Socket.Connections[I].Close;
    end;
  TfrmDebugParameters.Debugar (tbAtividadeDeSocket, 'Saiu   EnviaParaTodosOsClients');
end;

function TfrmSicsMain.EnviaComando(const ASocket: TCustomWinSocket; const AComando: string): Integer;
begin
  Result := SOCKET_ERROR;
  if Assigned(ASocket) and ASocket.Connected then
    Result := ASocket.SendText(AspStringToAnsiString(FormatarProtocolo(AComando)));
end;

// proc EnviaParaTodosOsClients

procedure TfrmSicsMain.AjustaCanalDasTVs(IdTV, Canal: Integer);
var
  BM: TBookmark;
begin
  with dmSicsMain.cdsPaineis do
  begin
    BM := GetBookmark;
    try
      try
      First;
      while not Eof do
      begin
        if TModeloPainel(FieldByName('ID_MODELOPAINEL').AsInteger) = mpTV then
          WriteToDisplay(FieldByName('ID').AsInteger, TAspEncode.AspIntToHex(FieldByName('ID').AsInteger, 4) + Chr($8B) + TAspEncode.AspIntToHex(IdTV, 4) + TAspEncode.AspIntToHex(Canal, 4));
        Next;
      end;
      finally
        if BookmarkValid(BM) then
          GotoBookmark(BM);
      end;
    finally
      FreeBookmark(BM);
    end;
  end; // with cds
end;

function TfrmSicsMain.AlterarSenhaCliente(Login, SenhaA, SenhaN: String): String;
var
  i: Integer;
begin
  dmSicsMain.connOnLine.StartTransaction;
  try
    i := dmSicsMain.connOnLine.ExecSQL('update CLIENTES set' +
                                  ' SENHALOGIN = '  + QuotedStr(SenhaN) +
                                  ' Where ID_UNIDADE = ' + vgParametrosModulo.IdUnidade.ToString +
                                  '   and LOGIN = ' + QuotedStr(Login) +
                                  ' and   SENHALOGIN = ' + QuotedStr(SenhaA));

    dmSicsMain.connOnLine.Commit;
    if i > 0 then
      Result := 'T'
    else
      Result := 'S';
  except
    begin
      dmSicsMain.connOnLine.Rollback;
      Result := 'E';
    end;
  end;
end;

procedure TfrmSicsMain.ApagarSenhasEmEsperas;
var  LStringGrid: TStringGrid;
     LFila:       Integer;
begin
  dmSicsMain.cdsFilasClone.CloneCursor(dmSicsMain.cdsFilas, false, True);

  dmSicsMain.cdsFilasClone.First;
  while not dmSicsMain.cdsFilasClone.Eof do
  begin
    if dmSicsMain.cdsFilasClone.FieldByName('Ativo').AsBoolean then
    begin
      LFila := dmSicsMain.cdsFilasClone.FieldByName('ID').AsInteger;
      try
        LStringGrid := FindComponent('SenhasList' + IntToStr(LFila)) as TStringGrid;

        if (lStringGrid.Cells[0,1] <> EmptyStr) then
        begin
          ExcluirSenhasPelaFila(LFila);
        end;

        LStringGrid := nil;
      except
        on E: Exception do
          MyLogException(E);
      end;
    end;
    dmSicsMain.cdsFilasClone.Next;
  end;
end;

procedure TfrmSicsMain.EnviaAlarmeDeStatusDePapelParaPas(const AIdTotem: Integer; const ANomeImpressora: String; status: TStatusParaTotem);
var
  LIdsGruposPas : String;
  LMensagemPA   : String;
  LCodigoCor    : Integer;
  LNomeNivel    : string;
begin
  //LM
  LIdsGruposPas := ';';
  dmSicsMain.cdsGruposDePAsAtivos.First;
  while not dmSicsMain.cdsGruposDePAsAtivos.Eof do
  begin
    LIdsGruposPas := LIdsGruposPas +
      dmSicsMain.cdsGruposDePAsAtivos.FieldByName('ID').AsString + ';';
    dmSicsMain.cdsGruposDePAsAtivos.Next;
  end;

  case status of
    stPoucoPapel  :begin
                     LMensagemPA := ANomeImpressora + ' o papel está acabando.';
                     LCodigoCor  := 65535;
                     LNomeNivel  := 'Atenção';

                     if FDTGruposPAS_AlarmesPapelTotens.Locate('ID_TOTEM;STATUS',VarArrayOf([AIdTotem,'POUCOPAPEL']),[])then
                     begin
                       LIdsGruposPas := EmptyStr;
                       LIdsGruposPas := FDTGruposPAS_AlarmesPapelTotensGRUPO_PAS.AsString;
                   end;
                   end;

    stSemPapel    :begin
                     LMensagemPA := ANomeImpressora + ' O papel acabou. Totem inoperante.';
                     LCodigoCor  := 255;
                     LNomeNivel  := 'Crítico';

                     if FDTGruposPAS_AlarmesPapelTotens.Locate('ID_TOTEM;STATUS',VarArrayOf([AIdTotem,'SEMPAPEL']),[])then
                     begin
                       LIdsGruposPas := EmptyStr;
                       LIdsGruposPas := FDTGruposPAS_AlarmesPapelTotensGRUPO_PAS.AsString;
                     end;
                   end;
  end;

  EnviaAlarmesParaPAs(LIdsGruposPas, cStatusDePapel, LNomeNivel, LCodigoCor, LMensagemPA);
end;

procedure TfrmSicsMain.EnviaAlarmesParaPAs(GruposDePAs, NomePI,
  NomeNivel: string; CorNivel: integer; Mensagem: string);
begin
  EnviaParaTodosOsClients(ServerSocket1.Socket, IntToHex(00, 4) + Chr($A3) + GruposDePAs + TAB + NomePI + TAB + NomeNivel + TAB + inttostr(CorNivel) + TAB + Mensagem);
  Application.ProcessMessages;
end;

procedure TfrmSicsMain.GravarAlarmesAtivosPorPA;
var
  PA, LIDGrupoPA, ICountToten, LCodigoCornivel : Integer;
  LNomeIndicador, LNomeNivel, LMensagem        : String;
  LGruposPAArray                               : TIntArray;
  LBTem                                        : Boolean;
  BM                                           : TBookmark;
begin
  LimpaTodosAlarmesAtivoPAs;

  BM := dmSicsMain.cdsPAs.GetBookmark;
  try
    dmSicsMain.cdsPAs.First;
    while not dmSicsMain.cdsPAs.Eof do
    begin
      if UpperCase(dmSicsMain.cdsPAs.FieldByName('ATIVO').AsString) <> 'T' then
      begin
        dmSicsMain.cdsPAs.Next;
        Continue;
      end;

      PA         := dmSicsMain.cdsPAs.FieldByName('ID'        ).AsInteger;
      LIDGrupoPA := dmSicsMain.cdsPAs.FieldByName('ID_GRUPOPA').AsInteger;

      frmSicsPIMonitor.cdsPIsClone_AlarmesAtivos.First;
      while not frmSicsPIMonitor.cdsPIsClone_AlarmesAtivos.Eof do
      begin
        StrToIntArray(frmSicsPIMonitor.cdsPIsClone_AlarmesAtivos.FieldByName('GRUPOSPASIDRELACIONADOS').Asstring , LGruposPAArray);

        if ExisteNoIntArray(LIDGrupoPA, LGruposPAArray) then
        begin
          LNomeIndicador  := frmSicsPIMonitor.cdsPIsClone_AlarmesAtivos.FieldByName('PINOME').Asstring;
          LNomeNivel      := frmSicsPIMonitor.cdsPIsClone_AlarmesAtivos.FieldByName('NOMENIVEL').Asstring;
          LCodigoCornivel := frmSicsPIMonitor.cdsPIsClone_AlarmesAtivos.FieldByName('CODIGOCOR').AsInteger;
          LMensagem       := frmSicsPIMonitor.cdsPIsClone_AlarmesAtivos.FieldByName('MENSAGEMTRADUZIDA').AsString;

          GravaAlarmeAtivoPA (PA, LNomeIndicador, LNomeNivel, LCodigoCornivel, LMensagem);
        end;

        frmSicsPIMonitor.cdsPIsClone_AlarmesAtivos.Next;
      end;

      //Verifica se tem algum Totem com Papel Acabando ou Sem
      for ICountToten := 1 to vlNumeroDePrinterClientSockets do
      begin
        LBTem := False;

        if stPoucoPapel in vlTotens[IdsTotens[ICountToten]].StatusTotem then
        begin
          LBTem           := True;
          LMensagem       := 'O papel está acabando.';
          LCodigoCornivel := 65535;
          LNomeNivel      := 'Atenção';
        end
        else if stSemPapel in vlTotens[IdsTotens[ICountToten]].StatusTotem then
        begin
          LBTem           := True;
          LMensagem       := 'O papel acabou. Totem inoperante.';
          LCodigoCornivel := 255;
          LNomeNivel      := 'Crítico';
        end;

        if LBTem then
          GravaAlarmeAtivoPA (PA, cStatusDePapel, LNomeNivel, LCodigoCornivel, LMensagem);
      end;

      dmSicsMain.cdsPAs.Next;
    end;
  finally
    dmSicsMain.cdsPAs.GotoBookmark(BM);
    dmSicsMain.cdsPAs.FreeBookmark(BM);
  end;
end;

function TfrmSicsMain.CalculaTEE(Fila: integer; var AQTDEPAProdutiva, AQTDEPessoasEspera, AIDTEE:integer): TDateTime;

  procedure InsereNoArraySeNaoExistir (var a : TIntArray; numero : integer);
  var
    i     : Integer;
    Achou : boolean;
  begin
    Achou := false;
    for i := low(a) to high(a) do
      if a[i] = numero then
      begin
        Achou := true;
        break;
      end;

    if not Achou then
    begin
      SetLength(a, length(a) + 1);
      a[high(a)] := numero;
    end;
  end;

type
  TParametrosPorFila = record
                         IdFila        : integer;
                         QtdEspera     : integer;
                         TMA           : TDateTime;
                         TEE_Exclusivo : TDateTime;
                       end;
  TParametrosCalculoTEE = record
                            QtdPAs_Disponiveis, QtdPAs_EmAtendimento, QtdPAs_Deslogadas,
                            QtdPAs_DeslogadasPoremProdutivas, QtdPAs_EmPausa, QtdPAs_Produtivas : integer;
                            TempoResidualTotal : TDateTime;
                            ParametrosPorFila : array of TParametrosPorFila;
                          end;

var
  PAsQueAtendemFila             : TIntArray;
  TodasFilasAtendidasNasPAs     : TIntArray;
  FilasAtendidasPorEstaPA       : TIntArray;
  QtdEsperaEstaFila             : integer;
  QtdPAsProdutivas              : integer;
  TMAEstaFila                   : TDateTime;
  TempoResidual                 : TDateTime;
  TempoParaEsvaziarTodasAsFilas : TDateTime;
  i, j                          : integer;

  ParametrosCalculoTEE          : TParametrosCalculoTEE;
begin
  SysUtils.FormatSettings.ShortDateFormat := 'dd/mm/yyyy';
  SysUtils.FormatSettings.LongTimeFormat  := 'hh:nn:ss';

  Result := 0;

  QtdPAsProdutivas              := 0;
  TempoResidual                 := 0;
  TempoParaEsvaziarTodasAsFilas := 0;
  AQTDEPAProdutiva              := 0;
  AQTDEPessoasEspera            := 0;

  with ParametrosCalculoTEE do
  begin
    QtdPAs_Disponiveis               := 0;
    QtdPAs_EmAtendimento             := 0;
    QtdPAs_Deslogadas                := 0;
    QtdPAs_DeslogadasPoremProdutivas := 0;
    QtdPAs_EmPausa                   := 0;
    QtdPAs_Produtivas                := 0;
  end;

  try
    with TClientDataSet.Create(Self) do
    try
      CloneCursor(dmSicsMain.cdsNN_PAs_Filas_SemFiltro, True);

      // 1o. Verificar todas as PAs que atendem esta fila (montar array PAsQueAtendemFila)
      Filter := 'ID_FILA = ' + inttostr(Fila);
      Filtered := true;
      First;
      while not eof do
      begin
        InsereNoArraySeNaoExistir(PAsQueAtendemFila, FieldByName('ID_PA').AsInteger);
        Next;
      end;

      // Se não houver PAs para atender esta fila, o TEE é infinito.
      // Neste caso o TEE será devolvido conforme abaixo.
      if length(PAsQueAtendemFila) = 0 then
      begin
        ParametrosCalculoTEE.QtdPAs_Produtivas := 0;
        Result := EncodeTime(23,59,59,999);
        Exit;
      end;

      // 2o. Verificar todas as filas que estas PAs atendem (montar array TodasFilasAtendidasNasPAs)
      Filtered := false;
      Filter   := '';
      for i := low(PAsQueAtendemFila) to High(PAsQueAtendemFila) do
        Filter := '(ID_PA = ' + inttostr(PAsQueAtendemFila[i]) + ') OR ';
      Filter := Copy(Filter, 1, Length(Filter) - 4);

      Filtered := true;
      First;
      while not eof do
      begin
        InsereNoArraySeNaoExistir(TodasFilasAtendidasNasPAs, FieldByName('ID_FILA').AsInteger);
        Next;
      end;
    finally
      Free;
    end;

    // 3o. Verificar, quais PAs estão produtivas (logadas e disponíveis ou em atendimento),
    //     e o tempo residual (caso esteja em atendimento, quanto falta para acabar o atendimento atual, pelo TMA)
    with TClientDataSet.Create(Self) do
    try
      CloneCursor(frmSicsSituacaoAtendimento.cdsPAs, True);

      for i := low(PAsQueAtendemFila) to high(PAsQueAtendemFila) do
      begin
        //calcula quantas PAs estão logadas
        if Locate('ID_PA', PAsQueAtendemFila[i], []) then
          case TStatusPA(FieldByName('Id_Status').AsInteger) of
            spDeslogado     : begin
                                ParametrosCalculoTEE.QtdPAs_Deslogadas := ParametrosCalculoTEE.QtdPAs_Deslogadas + 1;
                                if vgParametrosModulo.ParametrosTEE.ConsiderarPAsDeslogadas then
                                begin
                                  if MinutesBetween(Now,FieldByName('Horario').AsDateTime) <= vgParametrosModulo.ParametrosTEE.MinutosConsiderarPAsDeslogadas then
                                  begin
                                    ParametrosCalculoTEE.QtdPAs_DeslogadasPoremProdutivas := ParametrosCalculoTEE.QtdPAs_DeslogadasPoremProdutivas + 1;
                                    QtdPAsProdutivas := QtdPAsProdutivas + 1;
                                    TempoResidual    := TempoResidual + 0;
                                  end;
                                end;
                              end;

            spDisponivel    : begin
                                ParametrosCalculoTEE.QtdPAs_Disponiveis := ParametrosCalculoTEE.QtdPAs_Disponiveis + 1;
                                QtdPAsProdutivas := QtdPAsProdutivas + 1;
                                TempoResidual    := TempoResidual + 0;
                              end;

            spEmAtendimento : begin
                                ParametrosCalculoTEE.QtdPAs_EmAtendimento := ParametrosCalculoTEE.QtdPAs_EmAtendimento + 1;
                                QtdPAsProdutivas := QtdPAsProdutivas + 1;
                                if (frmSicsMain.FindComponent('AtendimentoUltimos10' + FieldByName('Id_Fila').AsString) <> nil) then
                                begin
                                  try
                                    TMAEstaFila   := strtodatetime((frmSicsMain.FindComponent('AtendimentoUltimos10' + FieldByName('Id_Fila').AsString) as TLabel).Caption);
                                  except
                                    on E : Exception do
                                    begin
                                      MyLogException(Exception.Create('Erro ao calcular TEE: ' + E.Message + ' // Fila: ' + FieldByName('Id_Fila').AsString + '  //  ' + (frmSicsMain.FindComponent('AtendimentoUltimos10' + FieldByName('Id_Fila').AsString) as TLabel).Caption));
                                    end;
                                  end;
                                end
                                else
                                begin
                                  //Caso a senha não seja proveniente de nenhuma fila, considerar o maior TMAEstaFila dentre as filas atendidas nesta PA

                                  //1o.  Verificar todas as filas que esta PA atende (montar array FilasAtendidasPorEstaPA)
                                  with TClientDataSet.Create(Self) do
                                  try
                                    CloneCursor(dmSicsMain.cdsNN_PAs_Filas_SemFiltro, True);

                                    Filter := '(ID_PA = ' + inttostr(PAsQueAtendemFila[i]) + ')';
                                    Filtered := true;
                                    First;
                                    while not eof do
                                    begin
                                      InsereNoArraySeNaoExistir(FilasAtendidasPorEstaPA, FieldByName('ID_FILA').AsInteger);
                                      Next;
                                    end;
                                  finally
                                    Free;
                                  end;

                                  //2o. Pegar o maior TMAEstaFila dentre as filas selecionadas
                                  TMAEstaFila := 0;
                                  for j := Low(FilasAtendidasPorEstaPA) to High(FilasAtendidasPorEstaPA) do
                                    try
                                      if strtodatetime((frmSicsMain.FindComponent('AtendimentoUltimos10' +  inttostr(FilasAtendidasPorEstaPA[j])) as TLabel).Caption) > TMAEstaFila then
                                        TMAEstaFila := strtodatetime((frmSicsMain.FindComponent('AtendimentoUltimos10' + inttostr(FilasAtendidasPorEstaPA[j])) as TLabel).Caption);
                                    except
                                      on E : Exception do
                                      begin
                                        MyLogException(Exception.Create('Erro ao calcular TEE: ' + E.Message + ' // Fila: ' + inttostr(FilasAtendidasPorEstaPA[j]) + '  //  ' + (frmSicsMain.FindComponent('AtendimentoUltimos10' + inttostr(FilasAtendidasPorEstaPA[j])) as TLabel).Caption));
                                      end;
                                    end;
                                end;

                                if TMAEstaFila > (now - FieldByName('Horario').AsDateTime) then
                                  TempoResidual := TempoResidual + (TMAEstaFila - (now - FieldByName('Horario').AsDateTime))
                                else
                                  TempoResidual := TempoResidual + 0;  //ou seja: neste caso, o tempo decorrido de atendimento já extrapolou o TMA, então em tese a chamada é imediata (TempoResidual desta PA deve ser considerado zero e não negativo)
                              end;

            spEmPausa       : begin
                                ParametrosCalculoTEE.QtdPAs_EmPausa := ParametrosCalculoTEE.QtdPAs_EmPausa + 1;
                              end;
          end;
      end;
    finally
      Free;
    end;

    ParametrosCalculoTEE.TempoResidualTotal := TempoResidual;
    ParametrosCalculoTEE.QtdPAs_Produtivas := QtdPAsProdutivas;

    // Se não houver PAs produtivas para atender esta fila, o TEE é infinito.
    // Neste caso o TEE será devolvido conforme abaixo.
    if QtdPAsProdutivas = 0 then
    begin
      Result := EncodeTime(23,59,59,999);
      Exit;
    end;

    // 4o. Verificar o tempo para atender todas as senhas que já estão em espera nas filas atendidas pelas PAs que atendem a fila em questão
    for i := low(TodasFilasAtendidasNasPAs) to high(TodasFilasAtendidasNasPAs) do
      if (frmSicsMain.FindComponent('SenhasCountLabel' + inttostr(TodasFilasAtendidasNasPAs[i])) <> nil) and (frmSicsMain.FindComponent('AtendimentoUltimos10' + inttostr(TodasFilasAtendidasNasPAs[i])) <> nil) then
      begin
        QtdEsperaEstaFila             := strtoint((frmSicsMain.FindComponent('SenhasCountLabel' + inttostr(TodasFilasAtendidasNasPAs[i])) as TLabel).Caption);
        TMAEstaFila                   := strtodatetime((frmSicsMain.FindComponent('AtendimentoUltimos10' + inttostr(TodasFilasAtendidasNasPAs[i])) as TLabel).Caption);
        TempoParaEsvaziarTodasAsFilas := TempoParaEsvaziarTodasAsFilas + (QtdEsperaEstaFila * TMAEstaFila);   // onde: QtdEsperaEstaFila * TMAEstaFila = Tempo para esvaziar esta fila
        AQTDEPessoasEspera := AQTDEPessoasEspera + QtdEsperaEstaFila;
        SetLength(ParametrosCalculoTEE.ParametrosPorFila, length(ParametrosCalculoTEE.ParametrosPorFila) + 1);
        with ParametrosCalculoTEE.ParametrosPorFila[High(ParametrosCalculoTEE.ParametrosPorFila)] do
        begin
          IdFila        := TodasFilasAtendidasNasPAs[i];
          QtdEspera     := QtdEsperaEstaFila;
          TMA           := TMAEstaFila;
          TEE_Exclusivo := TempoParaEsvaziarTodasAsFilas;
        end;
      end;

    // 5o. Calcular o TEE
    Result := (TempoParaEsvaziarTodasAsFilas + TempoResidual) / QtdPAsProdutivas;

    // 6o. Limitar o TEE em 23:59:59 caso seja maior do que 1 dia
    if Result >= 1 then
      Result := EncodeTime(23,59,59,999);

  finally
    Finalize(PAsQueAtendemFila);
    Finalize(TodasFilasAtendidasNasPAs);

    try
      if vgParametrosModulo.ParametrosTEE.LogarParametrosDeCalculo then
      begin
        var s : string;
        var k : integer;

        s := '{"CapacidadeProdutiva":{"QtdPAs_Disponiveis":"' + inttostr(ParametrosCalculoTEE.QtdPAs_Disponiveis) + '",' +
                                     '"QtdPAs_EmAtendimento":"' + inttostr(ParametrosCalculoTEE.QtdPAs_EmAtendimento) + '",' +
                                     '"QtdPAs_Deslogadas":"' + inttostr(ParametrosCalculoTEE.QtdPAs_Deslogadas) + '",' +
                                     '"QtdPAs_DeslogadasPoremProdutivas":"' + inttostr(ParametrosCalculoTEE.QtdPAs_DeslogadasPoremProdutivas) + '",' +
                                     '"QtdPAs_EmPausa":"' + inttostr(ParametrosCalculoTEE.QtdPAs_EmPausa) + '",' +
                                     '"QtdPAs_Produtivas":"' + inttostr(ParametrosCalculoTEE.QtdPAs_Produtivas) + '"},' +
              '"TempoResidualTotal":"' + MyFormatDateTime ('[h]:nn:ss', ParametrosCalculoTEE.TempoResidualTotal) + '"';

        if Length(ParametrosCalculoTEE.ParametrosPorFila) > 0 then
        begin
          s := s + ',"PorFila":[';
          for k := Low(ParametrosCalculoTEE.ParametrosPorFila) to High(ParametrosCalculoTEE.ParametrosPorFila) do
            s := s + '{"Fila":"' + inttostr(ParametrosCalculoTEE.ParametrosPorFila[k].IdFila) + '",' +
                      '"QtdEspera":"' + inttostr(ParametrosCalculoTEE.ParametrosPorFila[k].QtdEspera) + '",' +
                      '"TMA":"' + MyFormatDateTime ('[h]:nn:ss', ParametrosCalculoTEE.ParametrosPorFila[k].TMA) + '",' +
                      '"TEE_Exclusivo":"' + MyFormatDateTime ('[h]:nn:ss', ParametrosCalculoTEE.ParametrosPorFila[k].TEE_Exclusivo) + '"},';
          s := Copy(s, 1, length(s) - 1);  //remove a última vírgula
          s := s + ']';
        end;
        s := s + '}';

        RegistraParametrosDeCalculoTEE(Fila, s, Result, AIDTEE);
      end;
    finally
      AQTDEPAProdutiva := ParametrosCalculoTEE.QtdPAs_Produtivas;
      Finalize(ParametrosCalculoTEE.ParametrosPorFila);
    end;
  end;
end;


procedure TfrmSicsMain.EnviaCanaisPermissionados(IdTV: Integer);
var
  aux: string;
  BM : TBookmark;
begin
  GetSendCanaisNamesText(IdTV, aux);

  with dmSicsMain.cdsPaineis do
  begin
    BM := GetBookmark;
    try
      try
      First;
      while not Eof do
      begin
        if TModeloPainel(FieldByName('ID_MODELOPAINEL').AsInteger) = mpTV then
          WriteToDisplay(FieldByName('ID').AsInteger, FormatarProtocolo(TAspEncode.AspIntToHex(FieldByName('ID').AsInteger, 4) + Chr($89) + aux));
        Next;
      end;
      finally
        if BookmarkValid(BM) then
          GotoBookmark(BM);
      end;
    finally
      FreeBookmark(BM);
    end;
  end; // with cds
end;

function ExisteAFilaNaOrdemDasFilasDaPA(fila, PA: Integer): Boolean;
var
  BM1 { , BM2 } : TBookmark;
begin
  if dmSicsMain.cdsPAs.FieldByName('ID').AsInteger = PA then
    Result := dmSicsMain.cdsNN_PAs_Filas.Locate('ID_FILA', fila, [])
  else
  begin
    BM1 := dmSicsMain.cdsPAs.GetBookmark;
    try
      try
      Result := false;
      if dmSicsMain.cdsPAs.Locate('ID', PA, []) then
      begin
        if dmSicsMain.cdsPAs.FieldByName('Ativo').AsBoolean then
        begin
          try
            Result := dmSicsMain.cdsNN_PAs_Filas.Locate('ID_FILA', fila, []);
          finally
          end;
        end;
      end;
      finally
        if dmSicsMain.cdsPAs.BookmarkValid(BM1) then
          dmSicsMain.cdsPAs.GotoBookmark(BM1);
      end;
    finally
      dmSicsMain.cdsPAs.FreeBookmark(BM1);
    end;
  end;
end;

function ObedecerSequenciaDeFilas(PA: Integer): Boolean;
var
  BM: TBookmark;
begin
  with dmSicsMain.cdsPAs do
  begin
    BM := GetBookmark;
    try
      try
        Result := Locate('ID', PA, []) and FieldByName('Ativo').AsBoolean and FieldByName('OBEDECERSEQUENCIAFILAS').AsBoolean;
      finally
        if BookmarkValid(BM) then
          GotoBookmark(BM);
      end;
    finally
      FreeBookmark(BM);
    end;
  end; // with cds
end;

function FilaBloqueada(fila: Integer): Boolean;
begin
  Result := ((frmSicsMain.FindComponent('ListBlocked' + IntToStr(fila)) <> nil) and (((frmSicsMain.FindComponent('ListBlocked' + IntToStr(fila))) as TCheckBox).Checked));
end;

function ExisteSenhaNaFila(fila: Integer): Boolean;
begin
  Result := ((frmSicsMain.FindComponent('SenhasCountLabel' + IntToStr(fila)) <> nil) and (StrToInt((frmSicsMain.FindComponent('SenhasCountLabel' + IntToStr(fila)) as TLabel).Caption) > 0));
end;

function QuantidadeSenhasNaFila(fila: Integer): Integer;
begin
  Result := 0;
  try
    if (frmSicsMain.FindComponent('SenhasCountLabel' + IntToStr(fila)) <> nil) then
      Result := StrToInt((frmSicsMain.FindComponent('SenhasCountLabel' + IntToStr(fila)) as TLabel).Caption);
  except
    Result := 0;
  end;
end;

function GetMetaDeEspera(fila: Integer): TTime;
var
  BM: TBookmark;
begin
  with dmSicsMain.cdsFilas do
  begin
    BM := GetBookmark;
    try
      try
      Result := EncodeTime(0, 0, 0, 1);
      if ((Locate('ID', fila, [])) and (FieldByName('METAESPERA').AsDateTime <> 0)) then
        Result := FieldByName('METAESPERA').AsDateTime;
      finally
        if BookmarkValid(BM) then
          GotoBookmark(BM);
      end;
    finally
      FreeBookmark(BM);
    end;
  end; // with cds
end;

function SenhaEhValida(Senha: Integer): Boolean;
var
  BM: TBookmark;
begin
  with dmSicsMain.cdsFilas do
  begin
    BM := GetBookmark;
    try
      try
      Result := false;
      First;
      while not Eof do
      begin
        if ((Senha >= FieldByName('RANGEMINIMO').AsInteger) and (Senha <= FieldByName('RANGEMAXIMO').AsInteger)) then
        begin
          Result := True;
          Exit;
        end;
        Next;
      end;
      finally
        if BookmarkValid(BM) then
          GotoBookmark(BM);
      end;
    finally
      FreeBookmark(BM);
    end;
  end; // with cds
end;

function FilaEhValida(fila: Integer): Boolean;
var
  BM: TBookmark;
begin
  with dmSicsMain.cdsFilas do
  begin
    BM := GetBookmark;
    try
      try
      Result := false;
      First;
      while not Eof do
      begin
        if ((fila = FieldByName('ID').AsInteger) and (FieldByName('Ativo').AsBoolean)) then
        begin
          Result := True;
          Exit;
        end;
        Next;
      end;
      finally
        if BookmarkValid(BM) then
          GotoBookmark(BM);
      end;
    finally
      FreeBookmark(BM);
    end;
  end; // with cds
end;

{ RetrievePswd retira a senha Pswd da fila PswdsList, se houver esta senha na lista, ou
  se Pswd = -1, retira a primeira senha da lista, se Pswd = -2, retira a última. }
function TfrmSicsMain.RetrievePswd(fila: Integer; var Pswd: Integer; var PswdTime: TDateTime): Boolean;
var
  I, Posit : Integer;
  PswdsList: TStringGrid;
begin
  Result := false;

  PswdsList := (FindComponent('SenhasList' + IntToStr(fila))) as TStringGrid;
  if ((PswdsList <> nil) and ((PswdsList.RowCount > 2) or (PswdsList.Cells[COL_SENHA, 1] <> ''))) then
  begin
    Posit := -1;
    if Pswd = -1 then
      Posit := 1
    else if Pswd = -2 then
      Posit := PswdsList.RowCount - 1
    else
      for I := 1 to PswdsList.RowCount - 1 do
        if StrToInt(PswdsList.Cells[COL_SENHA, I]) = Pswd then
          Posit := I;

    if Posit > 0 then
    begin
      Pswd     := StrToInt(PswdsList.Cells[COL_SENHA, Posit]);
      PswdTime := StrToDateTime(PswdsList.Cells[COL_DATAHORA, Posit]);
      RemoveRow(PswdsList, Posit);

      //RA
      RemoverFilaTicketBD(fila, Pswd);
      AtualizarIDsTickets;

      Result := True;

      AtualizaSenhaCountLabel(PswdsList.Tag);
      SalvaSituacao_Fila(PswdsList.Tag);
    end;
  end;
end;

procedure TfrmSicsMain.RoboFilaEsperaProfissionalTimer(Sender: TObject);
const
  SELECT_TICKET = 'SELECT T.NUMEROTICKET, T.CREATEDAT FROM TICKETS T WHERE T.FILA_ID = %d ORDER BY T.ORDEM, T.ID';
  SELECT_FILA = 'SELECT COALESCE(C.ID_FILA,0) ID_FILA FROM ATENDENTES A LEFT JOIN ATEND_ATDS B ON A.ID = B.ID_ATD LEFT JOIN NN_PAS_FILAS C ON B.ID_PA = C.ID_PA WHERE A.ID_ATD_CLI = %s';
var
  FSenhasEspera: TStringlist;
  FCodProfissional : TStringlist;
  FFilaProfissional: TStringlist;
  i, j             : Integer;
  lDS, lDS_Fila    : TDataSet;
  LCodProfissional : String;
begin
//Procedimento de Jogar Senhas da fila nas filas do medico
  try
    try
      FSenhasEspera:= TStringlist.Create;
      FCodProfissional := TStringlist.Create;
      FFilaProfissional := TStringlist.Create;
      AtualizarIDsTickets;
      AtualizarIDsTicketsTags;
      AtualizarAgendamentoFilas;

      dmSicsMain.connOnLine.ExecSQL(Format(SELECT_TICKET, [FilaEsperaProfissional]), lDS);
      lDS := nil;
      lDS_Fila := nil;
      if not lDS.IsEmpty then
      begin
        lDS.First;
        while not lDS.Eof do
        begin
          if lDS.FieldByName('NUMEROTICKET').AsInteger > 0 then
          begin
            if GetCodProfissional(lDS.FieldByName('NUMEROTICKET').AsInteger, LCodProfissional) then
            begin
              FSenhasEspera.Add(lDS.FieldByName('NUMEROTICKET').AsString);
              FCodProfissional.Add(LCodProfissional);
              if (LCodProfissional <> '') and (LCodProfissional <> '0') then
              begin
                dmSicsMain.connOnLine.ExecSQL(Format(SELECT_FILA,[QuotedStr(LCodProfissional)]), lDS_Fila);
                if not lDS_Fila.IsEmpty then
                begin
                  FFilaProfissional.Add(lDS_Fila.FieldByName('ID_FILA').AsString);
                end
                else
                begin
                  FFilaProfissional.Add('0');
                end;
              end
              else
              begin
                FFilaProfissional.Add('0');
              end;
            end;
          end;
          lDS.Next;
        end;
        for i := 0 to Pred(FSenhasEspera.Count) do
        begin
          if FFilaProfissional[i] <> '0' then
          begin
            InsertPswd(strtoint(FFilaProfissional[I]),strtoint(FSenhasEspera[I]),Now,-2);
          end;
        end;
      end;
    except on e: exception do
      begin
        MyLogException(Exception.Create('Erro ao colocar senha da fila de espera na senha do profissional. ' + E.Message ));
      end;
    end;
  finally
    begin
      FSenhasEspera.free;
      FCodProfissional.free;
      FFilaProfissional.free;
      if Assigned(lDS) then FreeAndNil(lDS);
      if Assigned(lDS_Fila) then FreeAndNil(lDS_Fila);
    end;
  end;

end;

{ func RetrieveFirstPswd }

{ InsertPswd insere a senha Pswd na fila PswdsList na posicao Posit.
  Se Posit = -1, insere no comeco da lista, se Posit = -2, insere no fim.
  Se esta senha já existir nesta fila, retira-a e utiliza o seu horario. }
procedure TfrmSicsMain.InsertPswd(Fila : integer; Pswd : integer; PswdDateTime : TDateTime; Posit : integer;ExcetoPA : Integer);

  procedure SortGrid(Grid: TStringGrid; Col: integer);
  var
    i, j : integer;
    prev : string;
  begin
    //in worst-case scenario we'll need RowCount-1 iterations to fully sort the grid
    for j:= 0 to Grid.RowCount- 1 do
      for i:= 2 to Grid.RowCount- 1 do
      begin
        if strtodatetime(Grid.Cells[Col, i]) < strtodatetime(Grid.Cells[Col, i-1]) then
        begin
          prev := Grid.Rows[i- 1].CommaText;
          Grid.Rows[i- 1].CommaText:= Grid.Rows[i].CommaText;
          Grid.Rows[i].CommaText:= prev;
        end;
      end;
  end;

var
  i,
  j,
  LRow,
  LFilaAnterior: Integer;
  NomeCliente  : string;
  RetrieveTime : TDateTime;
  BM           : TBookmark;
  PswdsList    : TStringGrid;
  Tags         : TIntArray; //RAP
  Grupo        : String;    //RAP
  NomeFila     : String;
  DtHrSenha    : TDateTime;
  LRepaint     : Boolean;
begin
  TfrmDebugParameters.Debugar(tbAlocacaoDeSenhasNasFilas, 'Entrou   InsertPswd');

  LRepaint := False;

  PswdsList := (FindComponent('SenhasList' + inttostr(Fila))) as TStringGrid;
  if PswdsList <> nil then
  begin
    LFilaAnterior := frmSicsMain.ProcuraNasFilas(Pswd, NomeFila, DtHrSenha);
    if LFilaAnterior > 0 then
    begin
      //RA
      if LFilaAnterior <> Fila then
      begin
        //DirecionarTicketParaFilaBD(Pswd, lFilaAnterior, Fila, -1);
        RetrievePswd (LFilaAnterior, Pswd, RetrieveTime);
      end
      else
      begin
        for j := 1 to PswdsList.RowCount - 1 do
        begin
          if StrToInt(PswdsList.Cells[COL_SENHA, j]) = Pswd then
          begin
            LRow         := j;
            RetrieveTime := StrToDateTime(PswdsList.Cells[COL_DATAHORA, j]);
          end;
        end;

        RemoveRow(PswdsList, LRow);
      end;

      PswdDateTime := RetrieveTime;

      if PswdsList.Name = 'SenhasList'+inttostr(LFilaAnterior) then
      begin
        LRepaint := True;
      end
      else
      begin
        if vgParametrosModulo.AtualizarHoraTrocaFila then
        begin
          PswdDateTime := Now;
        end;
      end;
    end; { if lFilaAnterior > 0 }

    with frmSicsSituacaoAtendimento.cdsPAs do
    begin
      BM := GetBookmark;
      try
        if Locate('SENHA', Pswd, []) then
          Redireciona(FieldByName('Id_PA').AsInteger,0);
      finally
        GotoBookmark(BM);
        FreeBookmark(BM);
      end;
    end;  // with cds

    if not InRange(Posit, -2, -1) then
    begin
      Posit := -2;
    end;

    //if cdsIdsTickets.Locate('NumeroTicket', Pswd, []) then
    if BuscarMaxIDSenha(Pswd) then
    begin
      NomeCliente := cdsIdsTickets.FieldByName('NomeCliente').AsString;
      RecuperaTicket(cdsIdsTicketsID.AsInteger, Fila, Posit, PswdDateTime);
    end;

    if Posit = -1 then  // inserir no comeco
      Posit := 1
    else if Posit = -2 then
    begin  // inserir no fim
      if ((PswdsList.RowCount > 2) or (PswdsList.Cells[COL_SENHA,1] <> '')) then
        Posit := PswdsList.RowCount
      else
        Posit := PswdsList.RowCount - 1;
    end;
    InsertRow (PswdsList, Posit);
    with PswdsList do
    begin
      for i := 0 to ColCount - 1 do  //necessário limpar todas as células pois, se a senha não tem tag, não coloca conteudo nas colunas de TAGs,
        Cells[i, Posit] := '';       //  e com isso o stringGrid mostra nestas células o conteúdo que tinha de "sujeira" na memória

      Cells[COL_SENHA   ,Posit] := inttostr (Pswd  );
      Cells[COL_NOME    ,Posit] := NomeCliente;
      Cells[COL_HORA    ,Posit] := FormatDateTime ('hh:nn:ss', PswdDateTime);
      Cells[COL_DATAHORA,Posit] := FormatDateTime ('dd/mm/yyyy  hh:nn:ss', PswdDateTime);

      Tags := getTagsTicket(Pswd);
      Grupo := '';
      for I := Low(Tags) to High(Tags) do
        if dmSicsMain.cdsTags.Locate('ID', Tags[I], [loCaseInsensitive]) then
        begin
          if dmSicsMain.cdsGruposDeTags.Locate('ID', dmSicsMain.cdsTags.FieldByName('ID_GRUPOTAG').AsInteger, [loCaseInsensitive]) then
            Grupo := dmSicsMain.cdsGruposDeTags.FieldByName('Nome').AsString + ' - ';

          Cells[ObtemColunaDaTag(dmSicsMain.cdsTags.FieldByName('ID_GRUPOTAG').AsInteger), Posit] := IntToStr(dmSicsMain.cdsTags.FieldByName('ID').AsInteger) + ';' +
                                                                                                            IntToStr(dmSicsMain.cdsTags.FieldByName('CODIGOCOR').AsInteger) + ';' +
                                                                                                            Grupo + dmSicsMain.cdsTags.FieldByName('NOME').AsString
        end;

      Row := Posit;
      Col := 0;
    end;  { with PswdsList }

    if LRepaint then
    begin
      PswdsList.RowCount := 2;
      PswdsList.Cells[COL_SENHA, 1] := EmptyStr;

      PopularStringGridFilas(PswdsList, Fila);
      PswdsList.Row := PswdsList.RowCount - 1;
    end;

    if ExisteNoIntArray(Fila, dmSicsServidor.FilasComOrdenacaoAutomatica) then
      SortGrid(PswdsList, COL_DATAHORA);

    AtualizaSenhaCountLabel(PswdsList.Tag);
    SalvaSituacao_Fila(PswdsList.Tag);
    FazChamadaAutomatica(Fila,ExcetoPA);
    ImprimeSomenteCDB (Fila, Pswd);
    //Forcar repaint aqui...
  end;
  TfrmDebugParameters.Debugar(tbAlocacaoDeSenhasNasFilas, 'Saiu   InsertPswd');
end;  { proc InsertPswd }

procedure TfrmSicsMain.SetFilaEsperaProfissional(const Value: integer);
begin
  FFilaEsperaProfissional := Value;
end;

function TfrmSicsMain.SetIdClienteSenha(IDTicket, IDCliente: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  dmSicsMain.connOnLine.StartTransaction;
  try
    i := dmSicsMain.connOnLine.ExecSQL('update TICKETS ' +
                                       '  set ID_CLIENTE = ''' + IDCliente.ToString + ''' ' +
                                       'where ID_UNIDADE = ' + vgParametrosModulo.IdUnidade.ToString +
                                       ' and  ID   = ' + IDTicket.ToString);
    dmSicsMain.connOnLine.Commit;
    result := (i = 1);
  except
    Result := False;
    dmSicsMain.connOnLine.Rollback;
  end;
  Result := False;
end;

procedure TfrmSicsMain.LimparObjetosCalculoTMEPorFila;
var LFila: string;
begin
  dmSicsMain.cdsFilasClone.CloneCursor(dmSicsMain.cdsFilas, false, True);

  dmSicsMain.cdsFilasClone.First;
  while not dmSicsMain.cdsFilasClone.Eof do
  begin
    if dmSicsMain.cdsFilasClone.FieldByName('Ativo').AsBoolean then
    begin
      LFila := IntToStr(dmSicsMain.cdsFilasClone.FieldByName('ID').AsInteger);
      try
        (FindComponent('SomaEsperasUltimosN'    + LFila) as TLabel).Caption := datetimetostr(0);
        (FindComponent('EsperaUltimosN'         + LFila) as TLabel).Caption := datetimetostr(0);
        (FindComponent('PrimeiraEsperaUltimosN' + LFila) as TLabel).Caption := datetimetostr(0);
        (FindComponent('ListaEsperasUltimosN'   + LFila) as TListBox).Items.Clear;
      except
        on E: Exception do
          MyLogException(E);
      end;
    end;
    dmSicsMain.cdsFilasClone.Next;
  end;
end;

procedure TfrmSicsMain.LimparObjetosCalculoTMAPorFila;
var LFila: string;
begin
  dmSicsMain.cdsFilasClone.CloneCursor(dmSicsMain.cdsFilas, false, True);

  dmSicsMain.cdsFilasClone.First;
  while not dmSicsMain.cdsFilasClone.Eof do
  begin
    if dmSicsMain.cdsFilasClone.FieldByName('Ativo').AsBoolean then
    begin
      LFila := IntToStr(dmSicsMain.cdsFilasClone.FieldByName('ID').AsInteger);
      try
        (FindComponent('SomaAtendimentosUltimos10'    + LFila) as TLabel).Caption := datetimetostr(0);
        (FindComponent('AtendimentoUltimos10'         + LFila) as TLabel).Caption := datetimetostr(0);
        (FindComponent('PrimeiroAtendimentoUltimos10' + LFila) as TLabel).Caption := datetimetostr(0);
        (FindComponent('ListaAtendimentosUltimos10'   + LFila) as TListBox).Items.Clear;
      except
        on E: Exception do
          MyLogException(E);
      end;

      AtualizaAtendimentoUltimos10(StrToIntDef(LFila,0), now - EncodeTime(0, vgParametrosModulo.TMAPorFilaInicialEmMinutos, 0, 0));
    end;
    dmSicsMain.cdsFilasClone.Next;
  end;
end;


function TfrmSicsMain.SetNomeCliente(ATicketId: Integer;
  ATipoReplicacao: TReplicacaoNomeCliente; ANomeCliente: String): Boolean;
var
  LNF: Integer;
  LNomeFila: String;
  LDtHrSenha: TDateTime;
  LSenha:  integer;
begin
  Result := True;

    case ATipoReplicacao of
    rnSenha:
    begin
                 dmSicsMain.qryCamposAdicionais.Close;
      dmSicsMain.qryCamposAdicionais.ParamByName('ID_UNIDADE').AsInteger := vgParametrosModulo.IdUnidade;
      dmSicsMain.qryCamposAdicionais.ParamByName('ID_TICKET').AsInteger := ATicketId;
                 dmSicsMain.qryCamposAdicionais.Open;

                 if ((not dmSicsMain.qryCamposAdicionais.IsEmpty) and (dmSicsMain.qryCamposAdicionais.Locate('CAMPO', 'NOME', []))) then
                 begin
        dmSicsMain.connOnLine.ExecSQL(
                   ' UPDATE TICKETS_CAMPOSADIC SET VALOR = ' + QuotedStr(ANomeCliente) +
        ' WHERE ID_UNIDADE = ' + vgParametrosModulo.IdUnidade.ToString +
        ' AND ID_TICKET  = ' + QuotedStr(IntToStr(ATicketId)) +
        ' AND UPPER(CAMPO) = ' + QuotedStr('NOME'));
                 end
                 else
                 begin
        dmSicsMain.connOnLine.ExecSQL(
        ' INSERT INTO TICKETS_CAMPOSADIC (ID_UNIDADE, ID_TICKET, CAMPO, VALOR) VALUES (' +
        vgParametrosModulo.IdUnidade.ToString + ', ' +
                   QuotedStr(IntToStr(ATicketId)) + ', ' +
        QuotedStr('NOME') + ', ' + QuotedStr(ANomeCliente) + ')');
                 end;
               end;

    rnDadosAdicionais:
    begin
                           LSenha := cdsIdsTicketsNumeroTicket.AsInteger;

                           if BuscarMaxIDSenha(LSenha) then
                           begin
                             cdsIdsTickets.Edit;
                             cdsIdsTickets.FieldByName('NomeCliente').AsString := ANomeCliente;
                             cdsIdsTickets.Post;
        cdsIdsTickets.ApplyUpdates(0);

                             frmSicsSituacaoAtendimento.UpdateNomeDoCliente(LSenha, ANomeCliente);

                             frmSicsProcessosParalelos.UpdateNomeDoCliente(LSenha, ANomeCliente);

                             LNF := ProcuraNasFilas(cdsIdsTicketsNumeroTicket.AsInteger, LNomeFila, LDtHrSenha);
                             if LNF > 0 then
                             begin
                               SetNomeDoClienteNoStringGrid(LNF, cdsIdsTicketsNumeroTicket.AsInteger, ANomeCliente);
                               SalvaSituacao_Fila(LNF);
                             end;
                           end;
                         end;
    end;
end;


procedure TfrmSicsMain.SetNomeDoClienteNoStringGrid(fila: Integer; Pswd: Integer; Nome: string);
var
  I        : Integer;
  PswdsList: TStringGrid;
begin
  PswdsList := (FindComponent('SenhasList' + IntToStr(fila))) as TStringGrid;
  if PswdsList <> nil then
  begin
    with PswdsList do
    begin
      for I := 0 to RowCount - 1 do
        if Cells[COL_SENHA, I] = IntToStr(Pswd) then
        begin
          Cells[COL_NOME, I] := Nome;
          Objects[COL_SENHA, I] := TObject(GetProntuarioPaciente(cdsIdsTicketsID.AsInteger));
          break;
        end;
    end; { with PswdsList }
  end;   { with PswdList }
end;     { proc SetNomeDoClienteNoStringGrid }

function TfrmSicsMain.AtualizaSenhaAtendente (const aIdAtd: Integer; const aSenhaLogin: string): Boolean;
var
  BM: TBookmark;
begin
  Result := false;
  with dmSicsMain.cdsAtendentes do
  begin
    BM := GetBookmark;
    try
      try
      if Locate('ID', aIdAtd, []) then
      begin
        LogChanges                       := True;
        try
          Edit;
          FieldByName('SENHALOGIN').AsString := aSenhaLogin;
          Post;
          if ApplyUpdates(0) = 0 then
          begin
            frmSicsSituacaoAtendimento.AtualizaListaDeAtendentes;
            BroadcastListaDeAtendentes;
            dmSicsContingencia.CheckReplicarTabelasP2C;
            Result := True;
          end;
        finally
          LogChanges := false;
        end;
      end;
      finally
        if BookmarkValid(BM) then
          GotoBookmark(BM);
      end;
    finally
      FreeBookmark(BM);
    end;
  end; { with cds }
end;

procedure TfrmSicsMain.AtualizaSenhaCountLabel(fila: Integer);
begin
  if ((frmSicsMain.FindComponent('SenhasList' + IntToStr(fila)) <> nil) and (frmSicsMain.FindComponent('SenhasCountLabel' + IntToStr(fila)) <> nil)) then
  begin
    with (frmSicsMain.FindComponent('SenhasList' + IntToStr(fila)) as TStringGrid) do
      if ((RowCount > 2) or (Cells[COL_SENHA, 1] <> '')) then
        (frmSicsMain.FindComponent('SenhasCountLabel' + IntToStr(fila)) as TLabel).Caption := IntToStr(RowCount - 1)
      else
        (frmSicsMain.FindComponent('SenhasCountLabel' + IntToStr(fila)) as TLabel).Caption := '0';
  end;
end;

procedure TfrmSicsMain.AtualizaSituacaoPA(IdPA: Integer);
var
  aux: string;
begin
  GetSendPAsSituationText(IdPA, aux);

  EnviaParaTodosOsClients(TGSServerSocket.Socket, '0000' + Chr($3C) + aux);
  EnviaParaTodosOsClients(ServerSocket1.Socket, '0000' + Chr($3C) + aux);
end;

procedure TfrmSicsMain.AtualizaStatusTV(AIP, ATunerPresent, AVideoState,
  AVideoError, ACurrentUI, ALegenda, ACurrentChannel: String);
var LCount: Integer;
begin
  //LM
  for LCount := 1 to cgMaxTVs do
  begin
    if vlTVs[LCount].IP = AIP then
    begin
      vlTVs[LCount].TunerPresent   := ATunerPresent;
      vlTVs[LCount].VideoState     := AVideoState;
      vlTVs[LCount].VideoError     := AVideoError;
      vlTVs[LCount].CurrentUI      := ACurrentUI;
      vlTVs[LCount].Legenda        := ALegenda;
      vlTVs[LCount].CurrentChannel := ACurrentChannel;
    end;
  end;
end;

function TfrmSicsMain.FormatarPIHorarioParaJornalEletronico(const AQtdeSegundos: Integer): String;
begin
  Result := FormatarPIHorarioParaJornalEletronico(AQtdeSegundos, Integer(vgParametrosModulo.FormatoHorarioNoJornalEletronico));
end;

procedure TfrmSicsMain.SubstituirTagsDePIs(var AMsg: string);
const
  INICIO_TAG_PI = '{{PI ';

//  {{inicio_tempo_espera_einstein}} - {{fim_tempo_espera_einstein}}
var
  LPosTagPI, LTamanho: Integer;
  LNomeTag, LValorTag: String;
  i: Integer;
//  LIndicadorValido: Boolean;
begin
  LTamanho := Length(AMsg);
//  LIndicadorValido  := False;

  LPosTagPI := Pos(INICIO_TAG_PI, AMsg);
  while LPosTagPI > 0 do
  begin
    for i := LPosTagPI to Length(AMsg)-1 do
      if (AMsg[i] = '}') and (AMsg[i+1] = '}') then
        break;

    Inc(i, 2);
    if i < LTamanho then
    begin
//      LIndicadorValido := True;
      LNomeTag := Copy(AMsg, LPosTagPI+Length(INICIO_TAG_PI), ((i-LPosTagPI)-2)-Length(INICIO_TAG_PI));
      Delete(AMsg, LPosTagPI, i-LPosTagPI);
      if (frmSicsPIMonitor.cdsPISClone.Locate('PINOME', LNomeTag, [loCaseInsensitive])) then
      begin
        if frmSicsPIMonitor.cdsPIsFLAG_VALOR_EM_SEGUNDOS.Value then
          LValorTag := FormatarPIHorarioParaJornalEletronico(frmSicsPIMonitor.cdsPISClone.FieldByName('VALOR_NUMERICO').AsInteger)
        else
          LValorTag := frmSicsPIMonitor.cdsPISClone.FieldByName('VALOR_NUMERICO').AsString;

        Insert(LValorTag, AMsg, LPosTagPI);
      end
      else
      begin
        Insert('-', AMsg, LPosTagPI);
        //verificar possibilidade de emitir um alerta aqui, por e-mail,
        //por exemplo, notificando que a configuração está errada, já
        //que o nome do PI configurado na mensagem do painel não foi
        //encontrado no CDS de PIs
      end;
    end;

    LPosTagPI := Pos(INICIO_TAG_PI, AMsg);

//    if not LIndicadorValido then
//      exit
  end;
end;

//RA
{$REGION 'Funções de carregamento de PA e Atendentes de arquivo da pasta RT comentada'}
{
procedure TfrmSicsMain.CarregarDadosDatasetPA(arqname: string);
begin
  if FileExists(arqname) then
  begin
    cdsTmp.LoadFromFile(arqname);
    try
      if cdsTmp.FieldCount <> frmSicsSituacaoAtendimento.cdsPAs.FieldDefs.Count then
      begin
        frmSicsSituacaoAtendimento.cdsPAs.DisableControls;
        try
          frmSicsSituacaoAtendimento.cdsPAs.EmptyDataSet;
          cdsTmp.First;
          while not cdsTmp.Eof do
          begin
            frmSicsSituacaoAtendimento.cdsPAs.Append;
            frmSicsSituacaoAtendimento.cdsPAs.FieldByName('Id_PA').AsInteger                  :=   cdsTmp.FieldByName('Id_PA').AsInteger;
            frmSicsSituacaoAtendimento.cdsPAs.FieldByName('Id_Status').AsInteger              :=   cdsTmp.FieldByName('Id_Status').AsInteger;
            frmSicsSituacaoAtendimento.cdsPAs.FieldByName('Id_Atd').AsInteger                 :=   cdsTmp.FieldByName('Id_Atd').AsInteger;
            frmSicsSituacaoAtendimento.cdsPAs.FieldByName('Id_Senha').AsInteger               :=   cdsTmp.FieldByName('Id_Senha').AsInteger;
            frmSicsSituacaoAtendimento.cdsPAs.FieldByName('SENHA').AsInteger                  :=   cdsTmp.FieldByName('SENHA').AsInteger;
            frmSicsSituacaoAtendimento.cdsPAs.FieldByName('NomeCliente').AsString             :=   cdsTmp.FieldByName('NomeCliente').AsString;
            frmSicsSituacaoAtendimento.cdsPAs.FieldByName('Horario').AsDateTime               :=   cdsTmp.FieldByName('Horario').AsDateTime;
            frmSicsSituacaoAtendimento.cdsPAs.FieldByName('Id_Fila').AsInteger                :=   cdsTmp.FieldByName('Id_Fila').AsInteger;
            frmSicsSituacaoAtendimento.cdsPAs.FieldByName('Id_MotivoPausa').AsInteger         :=   cdsTmp.FieldByName('Id_MotivoPausa').AsInteger;
            frmSicsSituacaoAtendimento.cdsPAs.FieldByName('ID_ATENDENTE_AUTOLOGIN').AsInteger :=   cdsTmp.FieldByName('ID_ATENDENTE_AUTOLOGIN').AsInteger;
            frmSicsSituacaoAtendimento.cdsPAs.FieldByName('Ativo').AsBoolean                  :=   cdsTmp.FieldByName('Ativo').AsBoolean;
            frmSicsSituacaoAtendimento.cdsPAs.FieldByName('POSICAO').AsInteger                :=   cdsTmp.FieldByName('POSICAO').AsInteger;
            frmSicsSituacaoAtendimento.cdsPAs.FieldByName('HorarioLogin').Clear;
            frmSicsSituacaoAtendimento.cdsPAs.Post;

            cdsTmp.Next;
          end;
        finally
          frmSicsSituacaoAtendimento.cdsPAs.EnableControls;
        end;
      end
      else
      begin
        frmSicsSituacaoAtendimento.cdsPAs.LoadFromFile(arqname);
      end;
      frmSicsSituacaoAtendimento.cdsPAs.LogChanges := false;
    finally
      cdsTmp.Close;
    end
  end;
end;

procedure TfrmSicsMain.CarregarDadosDatasetAtendentes(arqname: string);
begin
  if FileExists(arqname) then
  begin
    cdsTmp.LoadFromFile(arqname);
    try
      if cdsTmp.FieldCount <> frmSicsSituacaoAtendimento.cdsAtds.FieldDefs.Count then
      begin
        frmSicsSituacaoAtendimento.cdsAtds.DisableControls;
        try
          frmSicsSituacaoAtendimento.cdsAtds.EmptyDataSet;
          cdsTmp.First;
          while not cdsTmp.Eof do
          begin
            frmSicsSituacaoAtendimento.cdsAtds.Append;

            frmSicsSituacaoAtendimento.cdsAtds.FieldByName('Id_Atd').AsInteger          :=   cdsTmp.FieldByName('Id_Atd').AsInteger;
            frmSicsSituacaoAtendimento.cdsAtds.FieldByName('Id_Status').AsInteger       :=   cdsTmp.FieldByName('Id_Status').AsInteger;
            frmSicsSituacaoAtendimento.cdsAtds.FieldByName('Id_Senha').AsInteger        :=   cdsTmp.FieldByName('Id_Senha').AsInteger;
            frmSicsSituacaoAtendimento.cdsAtds.FieldByName('SENHA').AsInteger           :=   cdsTmp.FieldByName('SENHA').AsInteger;
            frmSicsSituacaoAtendimento.cdsAtds.FieldByName('NomeCliente').AsString      :=   cdsTmp.FieldByName('NomeCliente').AsString;
            frmSicsSituacaoAtendimento.cdsAtds.FieldByName('Horario').AsDateTime        :=   cdsTmp.FieldByName('Horario').AsDateTime;
            frmSicsSituacaoAtendimento.cdsAtds.FieldByName('Id_Fila').AsInteger         :=   cdsTmp.FieldByName('Id_Fila').AsInteger;
            frmSicsSituacaoAtendimento.cdsAtds.FieldByName('Id_MotivoPausa').AsInteger  :=   cdsTmp.FieldByName('Id_MotivoPausa').AsInteger;
            frmSicsSituacaoAtendimento.cdsAtds.FieldByName('HorarioLogin').Clear;
            frmSicsSituacaoAtendimento.cdsAtds.Post;

            cdsTmp.Next;
          end;
        finally
          frmSicsSituacaoAtendimento.cdsAtds.EnableControls;
        end;
      end
      else
      begin
        frmSicsSituacaoAtendimento.cdsAtds.LoadFromFile(arqname);
      end;
      frmSicsSituacaoAtendimento.cdsAtds.LogChanges := false;
    finally
      cdsTmp.Close;
    end
  end;
end;
}
{$ENDREGION}

procedure TfrmSicsMain.ProcessarMensagensPaineis;
var
  LId: Integer;
  LMsg: String;
begin
  dmSicsMain.cdsPaineisClone.CloneCursor(dmSicsMain.cdsPaineis, True);
  dmSicsMain.cdsPaineisClone.First;
  while not dmSicsMain.cdsPaineisClone.Eof do
  begin
    LId  := dmSicsMain.cdsPaineisClone.FieldByName('ID').AsInteger;
    LMsg := dmSicsMain.cdsPaineisClone.FieldByName('MENSAGEM').AsString;

    frmSicsMain.SubstituirTagsDePIs(LMsg);
    frmSicsMain.ConstroiXMLDaIntegracaoWebService(LId, LMsg);
    TTempoUnidadeManager.SubstituirTags(LMsg);
    frmSicsMain.SendMessageToPanel(LId, LMsg);

    dmSicsMain.cdsPaineisClone.Next;
  end;
  dmSicsMain.cdsPaineisClone.Close;
end;

procedure TfrmSicsMain.SendMessageToPanel(const AIdPanel: Integer; const AMsg: String);
var
  PainelEndereco         : string;
  PainelEnderecoIP       : string;
  PainelManterUltimaSenha: Boolean;
  PainelMonitoramento    : Boolean;
  PainelNome             : string;
  IdModeloPainel         : Integer;
  vlDest                 : string;
begin
  NGetPainelData(AIdPanel, PainelNome, PainelEndereco, IdModeloPainel, PainelEnderecoIP, PainelManterUltimaSenha, PainelMonitoramento);
  if TModeloPainel(IdModeloPainel) = mpTV then
    frmSicsMain.WriteToDisplay(AIdPanel, TAspEncode.AspIntToHex(AIdPanel, 4) + Chr($2B) + TAspEncode.AspIntToHex(AIdPanel, 4) + AMsg)
  else if ASPEzPorEnviaTexto(AMsg, vlDest, PainelEndereco, 1, False, False) then
    frmSicsMain.WriteToDisplay(AIdPanel, vlDest);
end;

procedure TfrmSicsMain.ConstroiXMLDaIntegracaoWebService(IdPainel: Integer; var Mensagem: string);
const
  cDelimIndicador         = ':';
var
  vInicioWS, vFimWS   : Boolean;
  I, vSetor           : Integer;
  vTextoWS            : TStringList;
  vDataHora, vUnidade, vEspecialidade, vMensagem: string;
  vLinha, vIndicador: string;
  vXML: TStringList;
  vFileName: string;
  vTexto: TStringList;
  sWS: string;

  function XmlEncode(AText: string): string;
  var
    I: Integer;
  begin
    Result := '';
    for I := 1 to Length(AText) do
    begin
      case AText[I] of
        'Ç' : Result := Result + '&#199;';
        'é' : Result := Result + '&#233;';
        'â' : Result := Result + '&#226;';
        'à' : Result := Result + '&#224;';
        'ç' : Result := Result + '&#231;';
        'ê' : Result := Result + '&#234;';
        'É' : Result := Result + '&#201;';
        'ô' : Result := Result + '&#244;';
        'á' : Result := Result + '&#225;';
        'í' : Result := Result + '&#237;';
        'ó' : Result := Result + '&#243;';
        'ú' : Result := Result + '&#250;';
        'Á' : Result := Result + '&#193;';
        'À' : Result := Result + '&#192;';
        'Ã' : Result := Result + '&#195;';
        'ã' : Result := Result + '&#227;';
        'Ê' : Result := Result + '&#202;';
        'Õ' : Result := Result + '&#213;';
        'õ' : Result := Result + '&#245;';
        'Â' : Result := Result + '&#194;';
        'Í' : Result := Result + '&#205;';
        'Ó' : Result := Result + '&#211;';
        'Ô' : Result := Result + '&#212;';
        'Ú' : Result := Result + '&#218;';
        '&' : Result := Result + '&amp;';
        else
          Result := Result + AText[I];
      end; { case }
    end;
  end;

begin
  vTexto   := TStringList.Create;
  vTextoWS := TStringList.Create;
  vXML     := TStringList.Create;

  vInicioWS := False;

  vTexto.Text := Mensagem;

  with vTexto do
  begin
    for I := 0 to Pred(Count) do
    begin
      vLinha := Strings[I];
      if vInicioWS then
      begin
        vFimWS := (Trim(vLinha) = PAINEL_FIM_TEXTO_WS);

        if vFimWS then
        begin
          Break;
        end;

        if (Trim(vLinha) <> EmptyStr) then
        begin
          vTextoWS.Add(vLinha);
        end;
      end else
      begin
        vInicioWS := (Trim(vLinha) = PAINEL_INICIO_TEXTO_WS);
      end;
    end;
  end;

  if vTextoWS.Count > 0 then
  begin

    with vTextoWS do
    begin
      Text := RemoveTag(Text);

      vUnidade  := vgParametrosModulo.NomeUnidade;
      vSetor    := IdPainel;
      vDataHora := FormatDateTime('dd/mm/yyy hh:nn', Now);

      vXML.Add('<?xml version="1.0" encoding="UTF-8"?>');
      vXML.Add('<tempoDeEspera>');
      vXML.Add('  <unidade>' + vUnidade + '</unidade>');
      vXML.Add('  <setor>');
      vXML.Add('    <setorID>' + IntToStr(vSetor) + '</setorID>');

      for I := 0 to Pred(Count) do
      begin
        vIndicador     := Trim(Strings[I]);
        vEspecialidade := Trim(Copy(vIndicador,1,Pos(cDelimIndicador,vIndicador)-1));
        vMensagem      := Trim(Copy(vIndicador,Pos(cDelimIndicador,vIndicador)+1,Length(vIndicador)));

        vXML.Add('    <especialidade>');
        vXML.Add('      <especialidadeNome>' + vEspecialidade + '</especialidadeNome>');
        vXML.Add('      <mensagem>' + vMensagem + '</mensagem>');
        vXML.Add('    </especialidade>');
      end;

      vXML.Add('  </setor>');
      vXML.Add('  <datahora>' + vDataHora + '</datahora>');
      vXML.Add('</tempoDeEspera>');
    end;

    vFileName := vgParametrosModulo.DirXmlWS + AnsiUpperCase(FormatDateTime('YYYYMMDDHHNNSS',Now) + vUnidade + '.XML');

    vXML.Text := XmlEncode(vXML.Text);

    vXML.SaveToFile(vFileName);
  end;

  Mensagem := StringReplace(Mensagem,PAINEL_INICIO_TEXTO_WS,'',[rfReplaceAll]);
  Mensagem := StringReplace(Mensagem,PAINEL_FIM_TEXTO_WS,'',[rfReplaceAll]);

  FreeAndNil(vTextoWS);
  FreeAndNil(vXML);
end;


function TfrmSicsMain.RemoveTag(AText: string): string;
const
  cOpenTag  = '{{';
  cCloseTag = '}}';
var
  A,B: Integer;
  s: string;

  procedure ReadTagPositon;
  begin
    A := Pos(cOpenTag,AText);
    s := Copy(AText, A, Length(AText));
    B := Pos(cCloseTag,s);
  end;

begin
  Result  := EmptyStr;

  ReadTagPositon;

  while ((A > 0) and (B > 0)) do
  begin
    Delete(AText,A, B+1);
    ReadTagPositon;
  end;

  Result := AText;
end;


function TfrmSicsMain.TemNoOutBuffer(const S: string; aLimparBuffer: Boolean ): Boolean;
var
  I: Integer;
begin
  Result := false;
  try
    if StrToInt(S) < 1 then
      Result := True
    else
      for I := 1 to (OutBuffer.ColCount - 1) do
        if OutBuffer.Cells[I, 1] = S then
        begin
          Result := True;
          break;
        end;
  except
    Result := True;
  end; { try .. except }

  if Result and aLimparBuffer then
  begin
    ClearOutBufferTimer.OnTimer(ClearOutBufferTimer);
    Result := TemNoOutBuffer(s, False);
  end;
end;

procedure TfrmSicsMain.TrayIcon1DblClick(Sender: TObject);
begin
  RestauraOuEscondeAplicacaoNaBandeja(true);
end;

{ func TemNoOutBuffer }

procedure TfrmSicsMain.InsertInOutBuffer(Senha, IdPA: Integer; horaSenha : string);
var
  IdGrupoPA, IdPainel, IdModeloPainel, PAMagazine, PAAutoRedir: Integer;
  PANome, PANomeNoPainel, PANomePorVoz                        : string;
  PainelNome, PainelEndereco, PainelEnderecoIP                : string;
  PAAtiva, PainelManterUltimaSenha, PainelMonitoramento       : Boolean;
begin
  PainelEndereco := '';
  if (   (not NGetPAData (IdPA, PAAtiva, IdGrupoPA, PANome, IdPainel, PANomeNoPainel, PANomePorVoz, PAMagazine, PAAutoRedir)) or
         (not PAAtiva) or
         ( ( (IdPainel <> -1) and (IdPainel <> 0) ) and (not NGetPainelData (IdPainel, PainelNome, PainelEndereco, IdModeloPainel, PainelEnderecoIP, PainelManterUltimaSenha, PainelMonitoramento)))) then
  begin
    if ( (IdPainel <> -1) and (IdPainel <> 0) ) then
      MyLogException(Exception.Create('Erro ao obter titulo de PA: ' + IntToStr(IdPA)));
    Exit;
  end;

  if ((OutBuffer.ColCount > 2) or (OutBuffer.Cells[1, 0] <> '')) then
    OutBuffer.ColCount                       := OutBuffer.ColCount + 1;
  OutBuffer.Cells[OutBuffer.ColCount - 1, 0] := IntToStr(Senha);
  OutBuffer.Cells[OutBuffer.ColCount - 1, 1] := IntToStr(IdPA);
  OutBuffer.Cells[OutBuffer.ColCount - 1, 2] := IntToStr(IdPainel);
  OutBuffer.Cells[OutBuffer.ColCount - 1, 3] := horaSenha;
end; { proc InsertInOutBuffer }

function TfrmSicsMain.GetWaitingTickets(PA: Integer): Integer;
var
  BM: TBookmark;
begin
  Result := 0;
  BM     := nil;
  try
    if dmSicsMain.cdsPAs.FieldByName('ID').AsInteger <> PA then
    begin
      BM := dmSicsMain.cdsPAs.GetBookmark;
      if not dmSicsMain.cdsPAs.Locate('ID', PA, []) then
        Exit;
    end;

    with dmSicsMain.cdsNN_PAs_Filas do
    begin
      First;
      while not Eof do
      begin
        if frmSicsMain.FindComponent('SenhasCountLabel' + FieldByName('ID_FILA').AsString) <> nil then
          Result := Result + StrToInt((frmSicsMain.FindComponent('SenhasCountLabel' + FieldByName('ID_FILA').AsString) as TLabel).Caption);

        Next;
      end;
    end;
  finally
    if BM <> nil then
    begin
      dmSicsMain.cdsPAs.GotoBookmark(BM);
      dmSicsMain.cdsPAs.FreeBookmark(BM);
    end;
  end;
end;

function TfrmSicsMain.GetWaitingPeopleOnTheLine(AIdPA: Integer; AProntuario: Boolean = False): String;
var
  BM: TBookmark;
  LNome, LSenha, LFila, LProntuario, s: String;
  LCount: Integer;
  LHorario: TTime;
begin
  Result := EmptyStr;
  BM     := nil;
  try
    if dmSicsMain.cdsPAs.FieldByName('ID').AsInteger <> AIdPA then
    begin
      BM := dmSicsMain.cdsPAs.GetBookmark;
      if not dmSicsMain.cdsPAs.Locate('ID', AIdPA, []) then
        Exit;
    end;

    dmSicsMain.cdsNN_PAs_Filas.Locate('ID_PA', AIdPA, []);
    with dmSicsMain.cdsNN_PAs_Filas do
    begin
      First;
      while not Eof do
      begin
        if frmSicsMain.FindComponent('SenhasList' + FieldByName('ID_FILA').AsString) <> nil then
        begin
          with frmSicsMain.FindComponent('SenhasList' + FieldByName('ID_FILA').AsString) as TStringGrid do
          begin
            for LCount := 1 to RowCount - 1 do
            begin
              if Cells[0, LCount] <> EmptyStr then
              begin
                dmSicsMain.cdsFilas.Locate('ID', FieldByName('ID_FILA').AsString, []);
                LFila       := dmSicsMain.cdsFilas.FieldByName('NOME').AsString + ';';
                LSenha      := Cells[0, LCount] + ';';
                LNome       := Cells[1, LCount] + ';';
                LHorario    := StrToTime(Cells[2, LCount]);
                LProntuario := IntToStr(Integer(Objects[COL_SENHA, LCount])) + ';';

                s := s + LFila + LSenha + LNome + IfThen(AProntuario, LProntuario, '') + TimeToStr(LHorario) + TAB;
              end;
            end;
          end;
        end;
        Next;
      end;

    Result := s;
    end;
  finally
    if BM <> nil then
    begin
      dmSicsMain.cdsPAs.GotoBookmark(BM);
      dmSicsMain.cdsPAs.FreeBookmark(BM);
    end;
  end;
end;


procedure TfrmSicsMain.GravarLogSocket(AComando: string);
begin
  if not (vgDebugParameters.ModoDebug and (tbSocketSendReceive in vgDebugParameters.TiposDebug)) then
    Exit;

  TfrmDebugParameters.Debugar(tbSocketSendReceive, 'SOCKET:   ' + AComando);
end;

procedure TfrmSicsMain.GetSendAlarmesAtivosText(const PA: Integer; var S: string);
var
  ICount, LIDGrupoPA, ICountToten: Integer;
  LNomeIndicador, LNomeNivel, LCodigoCornivel,LMensagem: String;
  LGruposPAArray: TIntArray;
  LBTem: Boolean;
begin
  frmSicsPIMonitor.cdsPIsClone_AlarmesAtivos.First;
  if frmSicsPIMonitor.cdsPIsClone_AlarmesAtivos.IsEmpty then
    frmSicsPIMonitor.PIsUpdateTimer.OnTimer(frmSicsPIMonitor.PIsUpdateTimer);

  ICount     := 0;

  LIDGrupoPA := NGetIdGrPA(PA,nil);

  frmSicsPIMonitor.cdsPIsClone_AlarmesAtivos.First;
  while not frmSicsPIMonitor.cdsPIsClone_AlarmesAtivos.Eof do
  begin
    StrToIntArray(frmSicsPIMonitor.cdsPIsClone_AlarmesAtivos.FieldByName('GRUPOSPASIDRELACIONADOS').Asstring , LGruposPAArray);

    if ExisteNoIntArray(LIDGrupoPA, LGruposPAArray) then
    begin
      ICount := ICount + 1;
      LNomeIndicador  := frmSicsPIMonitor.cdsPIsClone_AlarmesAtivos.FieldByName('PINOME').Asstring;
      LNomeNivel      := frmSicsPIMonitor.cdsPIsClone_AlarmesAtivos.FieldByName('NOMENIVEL').Asstring;
      LCodigoCornivel := IntToHex(GetRValue(frmSicsPIMonitor.cdsPIsClone_AlarmesAtivos.FieldByName('CODIGOCOR').AsInteger), 2) +
                         IntToHex(GetGValue(frmSicsPIMonitor.cdsPIsClone_AlarmesAtivos.FieldByName('CODIGOCOR').AsInteger), 2) +
                         IntToHex(GetBValue(frmSicsPIMonitor.cdsPIsClone_AlarmesAtivos.FieldByName('CODIGOCOR').AsInteger), 2) ;
      LMensagem       := frmSicsPIMonitor.cdsPIsClone_AlarmesAtivos.FieldByName('MENSAGEMTRADUZIDA').AsString;

      S := S + LNomeIndicador + ';' + LNomeNivel + ';' + LCodigoCornivel + ';' + LMensagem + TAB;
    end;

    frmSicsPIMonitor.cdsPIsClone_AlarmesAtivos.Next;
  end;

  //Verifica se tem algum Totem com Papel Acabando ou Sem
  for ICountToten := 1 to vlNumeroDePrinterClientSockets do
  begin
    LBTem := False;

    if stPoucoPapel in vlTotens[IdsTotens[ICountToten]].StatusTotem then
    begin
      LBTem           := True;
      LMensagem       := 'O papel está acabando.';
      LCodigoCornivel := IntToStr(65535);
      LNomeNivel      := 'Atenção';
    end
    else
    if stSemPapel in vlTotens[IdsTotens[ICountToten]].StatusTotem then
    begin
      LBTem           := True;
      LMensagem       := 'O papel acabou. Totem inoperante.';
      LCodigoCornivel := IntToStr(255);
      LNomeNivel      := 'Crítico';
    end;

    if LBTem then
    begin
      ICount := ICount + 1;
      S := S + cStatusDePapel + ';' + LNomeNivel + ';' + LCodigoCornivel + ';' + LMensagem + TAB;
    end;
  end;

  S := TAspEncode.AspIntToHex(ICount, 4) + S;
end;

procedure TfrmSicsMain.GetSendOnePASituationText(PA: Integer; var S: string);
var
  DateTime                   : TDateTime;
  NPSWD, ATD, FilaProveniente: Integer;
  AtdNome, Senha             : string;
  BM                         : TBookmark;
  StatusPA                   : TStatusPA;
  MotivoPausa                : Integer;
begin
  NPSWD    := 0;
  ATD      := 0;
  Senha    := '';
  DateTime := 0;
  S        := '';

  with dmSicsMain.cdsFilas do
  begin
    BM := GetBookmark;
    try
      try
        First;
        while not Eof do
        begin
          if FieldByName('Ativo').AsBoolean then
          begin
            if ((ExisteAFilaNaOrdemDasFilasDaPA(FieldByName('ID').AsInteger, PA)) and (frmSicsMain.FindComponent('SenhasCountLabel' + FieldByName('ID').AsString) <> nil)) then
              NPSWD := NPSWD + StrToIntDef((frmSicsMain.FindComponent('SenhasCountLabel' + FieldByName('ID').AsString) as TLabel).Caption, 0);
          end;
          Next;
        end;
      finally
        if BookmarkValid(BM) then
          GotoBookmark(BM);
      end;
    finally
      FreeBookmark(BM);
    end;
  end;

  frmSicsSituacaoAtendimento.GetPASituation(PA, StatusPA, ATD, Senha, FilaProveniente, MotivoPausa, DateTime);
  AtdNome := NGetAtdName(ATD);

  // Utilizado apenas nos teclados, por isto não colocado o status da PA no protocolo
  if ATD = -1 then
    AtdNome := '----';
  s := TAspEncode.AspIntToHex(NPSWD, 4) + AtdNome + TAB + Senha + TAB + FormatDateTime('ddmmyyyyhhnnss', DateTime);
end;
{ proc GetSendOnePASituationText }

procedure TfrmSicsMain.GetSendPAsSituationText(PA: Integer; var S: string);

  procedure ConcatenaPAnaString;
  var
    StatusPA, ATD, fila, MotivoPausa, TicketNo, Nome: string;
  begin
    with frmSicsSituacaoAtendimento.cdsClonePAs do
    begin
      if FieldByName('Id_Status').IsNull then
        StatusPA := '----'
      else
        StatusPA := TAspEncode.AspIntToHex(FieldByName('Id_Status').AsInteger, 4);

      if FieldByName('Id_Atd').IsNull then
        ATD := '----'
      else
        ATD := TAspEncode.AspIntToHex(FieldByName('Id_Atd').AsInteger, 4);

      if FieldByName('Id_Fila').IsNull then
        fila := '----'
      else
        fila := TAspEncode.AspIntToHex(FieldByName('Id_Fila').AsInteger, 4);

      if FieldByName('Id_MotivoPausa').IsNull then
        MotivoPausa := '----'
      else
        MotivoPausa := TAspEncode.AspIntToHex(FieldByName('Id_MotivoPausa').AsInteger, 4);

      if FieldByName('SENHA').IsNull then
        TicketNo := '---'
      else
        TicketNo := FieldByName('SENHA').AsString;

      Nome := FieldByName('NomeCliente').AsString;

      S := S + TAspEncode.AspIntToHex(FieldByName('Id_PA').AsInteger, 4) + FormatDateTime('ddmmyyyyhhnnss', FieldByName('Horario').AsDateTime) + StatusPA + ATD + fila + MotivoPausa + TicketNo + ';' + Nome + TAB;
    end;
  end;

var
  NPA: Integer;
begin
  S   := '';
  with frmSicsSituacaoAtendimento.cdsClonePAs do
  begin
    NPA := 0;

    if PA > 0 then
    begin
      if Locate('Id_PA', PA, []) and FieldByName('Ativo').AsBoolean then
      begin
        ConcatenaPAnaString;
        NPA := NPA + 1;
      end; { if Ativo }
    end
    else
    begin
      First;
      while not Eof do
      begin
        if FieldByName('Ativo').AsBoolean then
        begin
          ConcatenaPAnaString;
          NPA := NPA + 1;
        end; { if Ativo }

        Next;
      end;
    end;
    S := TAspEncode.AspIntToHex(NPA, 4) + S;
  end; // with cds
end;   { proc GetSendPASituationText }


procedure TfrmSicsMain.GetSendOnePAStatus(PA: Integer; var S: string);

  procedure ConcatenaPAnaString;
  var
    StatusPA, ATD, fila, MotivoPausa, Senha, Nome: string;
  begin
    if frmSicsSituacaoAtendimento.cdsClonePAs.FieldByName('Id_Status').IsNull then
      StatusPA := EmptyStr
    else
    begin
      case TStatusPA(frmSicsSituacaoAtendimento.cdsClonePAs.FieldByName('Id_Status').AsInteger) of
        spDeslogado     : StatusPA := 'Deslogado';
        spEmAtendimento : StatusPA := 'Em atendimento';
        spEmPausa       : StatusPA := 'Em pausa';
        spDisponivel    : StatusPA := 'Disponivel';
      end;
    end;

    if frmSicsSituacaoAtendimento.cdsClonePAs.FieldByName('Id_Atd').IsNull then
      ATD := EmptyStr
    else
      ATD := NGetAtdLogin(frmSicsSituacaoAtendimento.cdsClonePAs.FieldByName('Id_Atd').AsInteger);

    if frmSicsSituacaoAtendimento.cdsClonePAs.FieldByName('SENHA').IsNull then
      Senha := EmptyStr
    else
      Senha := frmSicsSituacaoAtendimento.cdsClonePAs.FieldByName('SENHA').AsString;

    if frmSicsSituacaoAtendimento.cdsClonePAs.FieldByName('Id_MotivoPausa').IsNull then
      MotivoPausa := EmptyStr
    else
      MotivoPausa := NGetMotivoDePausaName(frmSicsSituacaoAtendimento.cdsClonePAs.FieldByName('Id_MotivoPausa').AsInteger);

    S := S + StatusPA + ';' + ATD + ';' + Senha + ';' + MotivoPausa;
  end;

begin
  S   := '';
  with frmSicsSituacaoAtendimento.cdsClonePAs do
  begin
    if PA > 0 then
    begin
      if Locate('Id_PA', PA, []) and FieldByName('Ativo').AsBoolean then
        ConcatenaPAnaString;
    end;
  end; // with cds
end;


procedure TfrmSicsMain.GetSendPAsSituationTextParaTeclado(var S: string);
var
  ATD, fila, TicketNo: string;
  BM                 : TBookmark;
  TotalPAs           : Integer;
begin
  S        := '';
  with frmSicsSituacaoAtendimento.cdsPAs do
  begin
    DisableControls;
    try
      BM := GetBookmark;
      try
        try
          TotalPAs := 0;
          First;
          while not Eof do
          begin
            if ((FieldByName('Ativo').AsBoolean) and (ExisteNoIntArray(FieldByName('Id_PA').AsInteger, vlPAsComTeclados))) then
            begin
              if FieldByName('Id_Atd').IsNull then
                ATD := '----'
              else
                ATD := TAspEncode.AspIntToHex(FieldByName('Id_Atd').AsInteger, 4);

              if FieldByName('Id_Fila').IsNull then
                fila := '----'
              else
                fila := TAspEncode.AspIntToHex(FieldByName('Id_Fila').AsInteger, 4);

              if FieldByName('SENHA').IsNull then
                TicketNo := '---'
              else
                TicketNo := FieldByName('SENHA').AsString;

              S := S + TAspEncode.AspIntToHex(FieldByName('Id_PA').AsInteger, 4) + FormatDateTime('ddmmyyyyhhnnss', FieldByName('Horario').AsDateTime) + ATD { + FILA } + TicketNo + TAB;

              TotalPAs := TotalPAs + 1;
            end;
            Next;
          end;
        finally
          if BookmarkValid(BM) then
            GotoBookmark(BM);
        end;
      finally
        FreeBookmark(BM);
      end;
    finally
      EnableControls;
    end;
  end; // with cds

  S := TAspEncode.AspIntToHex(TotalPAs, 4) + S;
end; { proc GetSendPASituationTextParaTeclado }


procedure TfrmSicsMain.GetSendFilasText(var S: string);
var
  DateTime  : TDateTime;
  ID, I, Qtd: Integer;
  BM        : TBookmark;
  SenhasCountLabel, LGridSenhas: TComponent;
  sValorData: String;

begin
  with dmSicsMain.cdsFilas do
  begin
    BM := GetBookmark;
    I  := 0;
    S  := '';
    try
      try
      First;
      while not Eof do
      begin
        if FieldByName('Ativo').AsBoolean then
        begin
          I  := I + 1;
          ID := FieldByName('ID').AsInteger;

          DateTime := EncodeDate(1, 1, 1);
          Qtd      := 0;
          try
            LGridSenhas := frmSicsMain.FindComponent('SenhasList' + IntToStr(ID));
            SenhasCountLabel := frmSicsMain.FindComponent('SenhasCountLabel' + IntToStr(ID));
            if ((LGridSenhas <> nil) and (SenhasCountLabel <> nil)) then
            begin
              sValorData := (LGridSenhas as TStringGrid).Cells[COL_DATAHORA, 1];
              if (sValorData <> '') then
                DateTime := StrToDateTimeDef(sValorData, EncodeDate(1, 1, 1));

              Qtd := StrToInt((SenhasCountLabel as TLabel).Caption);
            end
          except
            DateTime := EncodeDate(1, 1, 1);
            Qtd      := 0;
          end;

          S := S + TAspEncode.AspIntToHex(ID, 4) + TAspEncode.AspIntToHex(Qtd, 4) + FormatDateTime('ddmmyyyyhhnnss', DateTime) + TAB;
        end;
        Next;
      end;
      S := TAspEncode.AspIntToHex(I, 4) + S;
      finally
        if BookmarkValid(BM) then
          GotoBookmark(BM);
      end;
    finally
      FreeBookmark(BM);
    end;
  end; { with cds }
end;   { proc GetSendFilasText }

procedure TfrmSicsMain.GetSendOneFilaText(ID: Integer; var S: string);
var
  DateTime: TDateTime;
  Qtd     : Integer;
begin
  DateTime := EncodeDate(1, 1, 1);
  Qtd      := 0;
  try
    if ((frmSicsMain.FindComponent('SenhasList' + IntToStr(ID)) <> nil) and (frmSicsMain.FindComponent('SenhasCountLabel' + IntToStr(ID)) <> nil)) then
    begin
      if (frmSicsMain.FindComponent('SenhasList' + IntToStr(ID)) as TStringGrid).Cells[COL_DATAHORA, 1] <> '' then
        DateTime := StrToDateTime((frmSicsMain.FindComponent('SenhasList' + IntToStr(ID)) as TStringGrid).Cells[COL_DATAHORA, 1]);

      Qtd := StrToInt((frmSicsMain.FindComponent('SenhasCountLabel' + IntToStr(ID)) as TLabel).Caption);
    end
  except
    DateTime := EncodeDate(1, 1, 1);
    Qtd      := 0;
  end;

  S := TAspEncode.AspIntToHex(1, 4) + TAspEncode.AspIntToHex(ID, 4) + TAspEncode.AspIntToHex(Qtd, 4) + FormatDateTime('ddmmyyyyhhnnss', DateTime) + TAB;
end; { proc GetSendFilasText }

procedure TfrmSicsMain.GetSendWaitingPswdsText(var S: string);
var
  PA, NPA, NPSWD: Integer;
  BM            : TBookmark;
begin
  LimpaTodasQtdEsperaPAs;

  with dmSicsMain.cdsPAs do
  begin
    BM := GetBookmark;
    try
      try
        NPA := 0;
        S   := '';
        First;
        while not Eof do
        begin
          if FieldByName('Ativo').AsBoolean then
          begin
            PA    := FieldByName('ID').AsInteger;
            NPSWD := GetWaitingTickets(PA);
            NPA   := NPA + 1;
            S     := S + TAspEncode.AspIntToHex(PA, 4) + TAspEncode.AspIntToHex(NPSWD, 4) + TAB;

            GravaQtdEsperaPA(PA, NPSWD);
          end;
          Next;
        end;
        S := TAspEncode.AspIntToHex(NPA, 4) + S;
      finally
        if BookmarkValid(BM) then
          GotoBookmark(BM);
      end;
    finally
      FreeBookmark(BM);
    end;
  end;
  // with cds
end; { proc GetSendWaitingPswdsText }

procedure TfrmSicsMain.GetSendWaitingPswdsTextParaTeclado(var S: string);
var
  PA, NPA, NPSWD: Integer;
  BM            : TBookmark;
begin
  with dmSicsMain.cdsPAs do
  begin
    BM := GetBookmark;
    try
      try
      NPA := 0;
      S   := '';
      First;
      while not Eof do
      begin
        if ((FieldByName('Ativo').AsBoolean) and (ExisteNoIntArray(FieldByName('ID').AsInteger, vlPAsComTeclados))) then
        begin
          PA    := FieldByName('ID').AsInteger;
          NPSWD := GetWaitingTickets(PA);
          NPA   := NPA + 1;
          S     := S + TAspEncode.AspIntToHex(PA, 4) + TAspEncode.AspIntToHex(NPSWD, 4) + TAB;
        end;
        Next;
      end;
      finally
        if BookmarkValid(BM) then
          GotoBookmark(BM);
      end;
    finally
      FreeBookmark(BM);
    end;
  end; // with cds

  S := TAspEncode.AspIntToHex(NPA, 4) + S;
end;

function TfrmSicsMain.PessoasNasFilasEsperaPA(AIdPA : Integer; AProntuario: Boolean = False) : String;
var
  BM       : TBookmark;
  NPSWD, S : String;
begin
  with dmSicsMain.cdsPAs do
  begin
    BM := GetBookmark;
    try
      try
        S   := '';
        Locate('ID', AIdPA, []);
        NPSWD  := GetWaitingPeopleOnTheLine(AIdPA, AProntuario);
        S      := S + NPSWD;
        Result := S;
      finally
        if BookmarkValid(BM) then
          GotoBookmark(BM);
      end;
    finally
      FreeBookmark(BM);
    end;
  end;
  // with cds
end; { proc GetSendWaitingPswdsText }


procedure TfrmSicsMain.GetStatusSenha(const APwd: Integer; var s: string);
var
  LID: Integer;
  LStatus: Char;
  LNome: String;
  LDtHr: TDateTime;

  LFS: TFormatSettings;
begin
  LStatus := 'I';
  LNome   := '';
  LID     := 0;

  LID := ProcuraNasFilas(APwd, LNome, LDtHr);
  if LID >= 0 then
    LStatus := 'E'
  else
  begin
    LID := ProcuraNasPAs(APwd, LNome, LDtHr);
    if LID >= 0 then
      LStatus := 'A';
  end;

  LID := Max(LID, 0);
  LFS := FormatSettings.Invariant;
  s := IntToStr(APwd) + TAB + LStatus + IntToHex(LID, 4) + LNome + TAB +
       FormatDateTime(LFS.ShortDateFormat + ' ' + LFS.LongTimeFormat, LDtHr);
end;

{ proc GetSendWaitingPswdsTextParaTeclado }

procedure TfrmSicsMain.GetSendPrioritiesText(var S: string);
var
  NPA: Integer;
  BM : TBookmark;
begin
  with dmSicsMain.cdsPAs do
  begin
    BM := GetBookmark;
    try
      try
      NPA := 0;
      S   := '';
      First;
      while not Eof do
      begin
        if FieldByName('Ativo').AsBoolean then
        begin
          NPA := NPA + 1;
          S   := S + TAspEncode.AspIntToHex(FieldByName('ID').AsInteger, 4) + OrdemDasFilasToStr(FieldByName('ID').AsInteger) + TAB;
        end;
        Next;
      end;
      S := TAspEncode.AspIntToHex(NPA, 4) + S;
      finally
        if BookmarkValid(BM) then
          GotoBookmark(BM);
      end;
    finally
      FreeBookmark(BM);
    end;
  end; { with cds }
end;   { proc GetSendPrioritiesText }

procedure TfrmSicsMain.GetSendPIsNamesText(const AIdModulo: Integer; var S: string);
var
  IdPI: Integer;
  Nome: string;
  aCDSPIsFiltro: TClientDataSet;
begin
  aCDSPIsFiltro := GetNewCDSFilter(frmSicsPIMonitor.cdsPIsClone);
  try
    with aCDSPIsFiltro do
    begin
      S := TAspEncode.AspIntToHex(RecordCount, 4);
      First;
      while not Eof do
      begin
        IdPI := FieldByName('ID_PI').AsInteger;
        Nome := FieldByName('PINOME').AsString;
        S    := S + TAspEncode.AspIntToHex(IdPI, 4) + Nome + TAB;
        Next;
      end;
    end; { with PIMonitorForm.sgPIs }
  finally
    FreeAndNil(aCDSPIsFiltro);
  end;
end;   { proc GetSendPIsNamesText }

procedure TfrmSicsMain.GetSendPIsSituationText(var S: string);
var
  IdPI  : Integer;
  Estado: char;
  Valor, ValorNumerico, FlagValorEmSegundos : string;
begin
  with frmSicsPIMonitor.cdsPIsClone do
  begin
    First;
    //if frmSicsPIMonitor.cdsPIsClone.IsEmpty then
      frmSicsPIMonitor.PIsUpdateTimer.OnTimer(frmSicsPIMonitor.PIsUpdateTimer);

    S := TAspEncode.AspIntToHex(RecordCount, 4);

    First;
    while not Eof do
    begin
      IdPI  := FieldByName('ID_PI').AsInteger;
      Valor := FieldByName('VALOR').AsString;
      if FieldByName('NOMENIVEL').AsString <> '' then
        Estado := FieldByName('NOMENIVEL').AsString[1]
      else
        Estado := '?';
      ValorNumerico := FieldByName('VALOR_NUMERICO').AsString;
      if FieldByName('FLAG_VALOR_EM_SEGUNDOS').AsBoolean then
        FlagValorEmSegundos := '1'
      else
        FlagValorEmSegundos := '0';

      S := S + TAspEncode.AspIntToHex(IdPI, 4) + Estado + Valor + ';' + ValorNumerico + ';' + FlagValorEmSegundos + TAB;

      Next;
    end;
  end;
end;

procedure TfrmSicsMain.GetSendPIsPossiveis(const AIdModulo: Integer; var S: string);
var
  IdPI: Integer;
  Nome, Detalhes: string;
  aCDSPIsFiltro: TClientDataSet;
begin
  aCDSPIsFiltro := GetNewCDSFilter(frmSicsPIMonitor.cdsPIsClone);
  try
    with aCDSPIsFiltro do
    begin
      //S := TAspEncode.AspIntToHex(RecordCount, 4);
      S := '';
      First;
      while not Eof do
      begin
        IdPI := FieldByName('ID_PI').AsInteger;
        Nome := FieldByName('PINOME').AsString;

        Detalhes := FieldByName('ID_PINIVEL').AsString;
        Detalhes := Detalhes + TAB + FieldByName('NOMENIVEL').AsString;
        Detalhes := Detalhes + TAB + FieldByName('POSICAONIVEL').AsString;
        Detalhes := Detalhes + TAB + FieldByName('VALOR').AsString;
        Detalhes := Detalhes + TAB + FieldByName('VALOR_NUMERICO').AsString;
        Detalhes := Detalhes + TAB + FieldByName('FLAG_VALOR_EM_SEGUNDOS').AsString;
        Detalhes := Detalhes + TAB + FieldByName('CODIGOCOR').AsString;

        S    := S + TAspEncode.AspIntToHex(IdPI, 4) + Nome + TAB + Detalhes + ';';
        Next;
      end;
    end; { with PIMonitorForm.sgPIs }
  finally
    FreeAndNil(aCDSPIsFiltro);
  end;
end;   { proc GetSendPIsNamesText }

procedure TfrmSicsMain.GetSendOneFilaDetailedSituationText(fila: Integer; var S: string; AProntuario: boolean);
var
  I, j                                                    : Integer;
  d1, m1, y1, h1, N1, s1, ms1, d2, m2, y2, h2, N2, s2, ms2: Word;
  Senha, Nome, Tags, aux1, aux2, Prontuario               : string;
  t                                                       : TDateTime;
begin
  S := TAspEncode.AspIntToHex(fila, 4);
  if FindComponent('SenhasList' + IntToStr(fila)) <> nil then
    with FindComponent('SenhasList' + IntToStr(fila)) as TStringGrid do
    begin
      if Cells[COL_SENHA, 1] <> '' then
      begin
        Senha      := Cells[COL_SENHA, 1];
        Nome       := Cells[COL_NOME, 1];
        Prontuario := IntToStr(Integer(Objects[COL_SENHA, 1]));
        Tags  := '';
        for j := 0 to fMaxTags - 1 do
        begin
          SeparaStrings(Cells[COL_PRIMEIRA_TAG + j, 1], ';', aux1, aux2);
          if aux1 <> '' then
            Tags := Tags + aux1 + ',';
        end;
        t := StrToDateTime(Cells[COL_DATAHORA, 1]);
        DecodeDate(t, y1, m1, d1);
        DecodeTime(t, h1, N1, s1, ms1);
        if AProntuario then
          S := S + Senha + TAB + Nome + TAB + Tags + TAB + Prontuario + TAB + FormatDateTime('ssnnhhddmmyyyy', t) + ';'
        else
          S := S + Senha + TAB + Nome + TAB + Tags + TAB + FormatDateTime('ssnnhhddmmyyyy', t) + ';';
      end;
      for I := 2 to RowCount - 1 do
      begin
        Senha := Cells[COL_SENHA, I];
        Nome  := Cells[COL_NOME, I];
        Prontuario := IntToStr(Integer(Objects[COL_SENHA, I]));

        Tags  := '';
        for j := 0 to fMaxTags - 1 do
        begin
          SeparaStrings(Cells[COL_PRIMEIRA_TAG + j, I], ';', aux1, aux2);
          if aux1 <> '' then
            Tags := Tags + aux1 + ',';
        end;

        t := StrToDateTime(Cells[COL_DATAHORA, I]);
        DecodeDate(t, y2, m2, d2);
        DecodeTime(t, h2, N2, s2, ms2);

        if y2 <> y1 then
          S := S + Senha + TAB + Nome + TAB + Tags + IfThen(AProntuario, TAB + Prontuario, '') + TAB + FormatNumber(2, s2) + FormatNumber(2, N2) + FormatNumber(2, h2) + FormatNumber(2, d2) + FormatNumber(2, m2) + FormatNumber(2, y2) + ';' // RAP TAB antes do nome
        else if m2 <> m1 then
          S := S + Senha + TAB + Nome + TAB + Tags + IfThen(AProntuario, TAB + Prontuario, '') + TAB + FormatNumber(2, s2) + FormatNumber(2, N2) + FormatNumber(2, h2) + FormatNumber(2, d2) + FormatNumber(2, m2) + ';' // RAP
        else if d2 <> d1 then
          S := S + Senha + TAB + Nome + TAB + Tags + IfThen(AProntuario, TAB + Prontuario, '') + TAB + FormatNumber(2, s2) + FormatNumber(2, N2) + FormatNumber(2, h2) + FormatNumber(2, d2) + ';' // RAP
        else if h2 <> h1 then
          S := S + Senha + TAB + Nome + TAB + Tags + IfThen(AProntuario, TAB + Prontuario, '') + TAB + FormatNumber(2, s2) + FormatNumber(2, N2) + FormatNumber(2, h2) + ';' // RAP
        else if N2 <> N1 then
          S := S + Senha + TAB + Nome + TAB + Tags + IfThen(AProntuario, TAB + Prontuario, '') + TAB + FormatNumber(2, s2) + FormatNumber(2, N2) + ';' // RAP
        else if s2 <> s1 then
          S := S + Senha + TAB + Nome + TAB + Tags + IfThen(AProntuario, TAB + Prontuario, '') + TAB + FormatNumber(2, s2) + ';' // RAP
        else
          S := S + Senha + TAB + Nome + TAB + Tags + IfThen(AProntuario, TAB + Prontuario, '') + TAB + ';'; // RAP

        d1 := d2;
        m1 := m2;
        y1 := y2;
        h1 := h2;
        N1 := N2;
        s1 := s2;
      end;
    end; { with SenhasList }
end;     { proc GetSendOneFilaDetailedSituationText }

procedure TfrmSicsMain.GetSendSituacaoPrioritariasBloqueadasText(var S: string);
var
  ID: Integer;
  BM: TBookmark;
begin
  S := '';
  with dmSicsMain.cdsFilas do
  begin
    BM := GetBookmark;
    try
      try
      First;
      while not Eof do
      begin
        if FieldByName('Ativo').AsBoolean then
        begin
          ID := FieldByName('ID').AsInteger;
          S  := S + TAspEncode.AspIntToHex(ID, 4);
          if ((frmSicsMain.FindComponent('ListBlocked' + IntToStr(ID)) <> nil) and ((frmSicsMain.FindComponent('ListBlocked' + IntToStr(ID)) as TCheckBox).Checked)) then
            S := S + '1'
          else
            S := S + '0';
          if ((frmSicsMain.FindComponent('PrioritaryList' + IntToStr(ID)) <> nil) and ((frmSicsMain.FindComponent('PrioritaryList' + IntToStr(ID)) as TCheckBox).Checked)) then
            S := S + '1' + TAB
          else
            S := S + '0' + TAB;
        end;
        Next;
      end;
      finally
        if BookmarkValid(BM) then
          GotoBookmark(BM);
      end;
    finally
      FreeBookmark(BM);
    end;
  end; { with cds }
end;   { proc GetSendSituacaoPrioritariasBloqueadasText }

procedure TfrmSicsMain.GetSendCanaisNamesText(IdTV: Integer; var S: string);
begin
  S := TAspEncode.AspIntToHex(IdTV, 4);
  with dmSicsMain.cdsTVsCanais do
  begin
    Filter   := 'ID_TV = ' + IntToStr(IdTV);
    Filtered := True;
    try
      First;
      while not Eof do
      begin
        S := S + TAspEncode.AspIntToHex(FieldByName('ID_CANAL_TV').AsInteger, 4) + FieldByName('CANAL_NOME').AsString + ';' + FieldByName('CANAL_FREQUENCIA').AsString;
        if FieldByName('CANAL_PADRAO').AsString = 'S' then
          S := S + '1' + TAB
        else
          S := S + '0' + TAB;
        Next;
      end;
    finally
      Filtered := false;
      Filter   := '';
    end;
  end; { with cds }
end;

procedure TfrmSicsMain.GetSendConfiguracoesGeraisText(var aRetorno: string;
  const aFiltroIDConfig: String; const aIncluirID: Boolean);
var
  aCloseCDS: TClientDataSet;
begin
  if not dmSicsMain.cdsConfiguracoesGerais.Active then
    dmSicsMain.cdsConfiguracoesGerais.Open;

  aCloseCDS := TClientDataSet.Create(Self);
  try
    aCloseCDS.CloneCursor(dmSicsMain.cdsConfiguracoesGerais, False, False);
    if (aFiltroIDConfig <> '') then
    begin
      aCloseCDS.Filtered := False;
      aCloseCDS.Filter := dmSicsMain.cdsConfiguracoesGeraisID.FieldName + ' = ' + QuotedStr(aFiltroIDConfig);
      aCloseCDS.Filtered := True;
    end;
    aCloseCDS.First;
    while not aCloseCDS.Eof do
    begin
      if (aIncluirID) then
        aRetorno := aRetorno + aCloseCDS.FieldByName(dmSicsMain.cdsConfiguracoesGeraisID.FieldName).AsString + ';';

      aRetorno := aRetorno + aCloseCDS.FieldByName(dmSicsMain.cdsConfiguracoesGeraisVALOR.FieldName).AsString;
      aCloseCDS.Next;
    end;
  finally
    FreeAndNil(aCloseCDS);
  end;
end;

procedure TfrmSicsMain.GetSendPPsSituationText(Senha: Integer; var S: string);
begin
  S := '';
  with frmSicsProcessosParalelos.cdsClonePPs do
    try
      if Senha <> -1 then
      begin
        Filter   := 'TicketNumber = ' + IntToStr(Senha);
        Filtered := True;
      end;

      First;
      while not Eof do
      begin
        S := S + FieldByName('ID_EventoPP').AsString + ';' + TAspEncode.AspIntToHex(FieldByName('ID_TipoPP').AsInteger, 4);

        if ((FieldByName('ID_PA').IsNull) or (FieldByName('ID_PA').AsInteger = -1)) then
          S := S + '----'
        else
          S := S + TAspEncode.AspIntToHex(FieldByName('ID_PA').AsInteger, 4);

        if ((FieldByName('ID_ATD').IsNull) or (FieldByName('ID_ATD').AsInteger = -1)) then
          S := S + '----'
        else
          S := S + TAspEncode.AspIntToHex(FieldByName('ID_ATD').AsInteger, 4);

        S := S + FormatDateTime('ddmmyyyyhhnnss', FieldByName('Horario').AsDateTime) + FieldByName('TicketNumber').AsString + ';' + FieldByName('NomeCliente').AsString + TAB;

        Next;
      end;
    finally
      Filtered := false;
    end;
end;

procedure TfrmSicsMain.GetSendPrioridadesAtendimentoPAText(const aPA: Integer; var s: string);
var
  LAtual: Integer;
begin
  dmSicsMain.qryAux.Close;
  dmSicsMain.qryAux.SQL.Clear;
  dmSicsMain.qryAux.SQL.Add('select A.ID_PA, A.ID_FILA');
  dmSicsMain.qryAux.SQL.Add('from NN_PAS_FILAS A INNER JOIN PAS B ON (A.ID_PA = B.ID and A.ID_UNIDADE = B.ID_UNIDADE)');
  dmSicsMain.qryAux.SQL.Add('where A.ID_UNIDADE = ' + vgParametrosModulo.IdUnidade.ToString + ' and B.ATIVO = ''T''');
  if aPA > 0 then
    dmSicsMain.qryAux.SQL.Add('and A.ID_PA = ' + aPA.ToString);
  dmSicsMain.qryAux.SQL.Add('order by A.ID_PA, A.POSICAO');
  dmSicsMain.qryAux.Open;
  s := '';
  LAtual := 0;
  while not dmSicsMain.qryAux.Eof do
  begin
    if dmSicsMain.qryAux.FieldByName('ID_PA').AsInteger <> LAtual then
    begin
      LAtual := dmSicsMain.qryAux.FieldByName('ID_PA').AsInteger;
      if s <> '' then
      begin
        Delete(s, Length(s), 1);
        s := s + TAB + IntToHex(LAtual, 4);
      end
      else
        s := s + IntToHex(LAtual, 4);
    end;

    s := s + IntToHex(dmSicsMain.qryAux.FieldByName('ID_FILA').AsInteger, 4) + ';';
    dmSicsMain.qryAux.Next;
  end;
  Delete(s, Length(s), 1);
  dmSicsMain.qryAux.Close;
end;

procedure TfrmSicsMain.GetSendAgendamentosFilasText(Senha : Integer; var s : string);
var
  sOldIndexFieldNames: string;
begin
  s := IntToStr(Senha) + ';';

  //if cdsIdsTickets.Locate('NUMEROTICKET', Senha, []) then
  if BuscarMaxIDSenha(Senha) then
  begin
    with cdsIdsTicketsAgendamentosFilas do
    begin
      Filter   := 'Id_Ticket=' + cdsIdsTickets.FieldByName('ID').AsString;
      Filtered := True;
      try
        s := s + InttoHex(RecordCount, 4);

        sOldIndexFieldNames := IndexFieldNames;
        IndexFieldNames     := 'DATAHORA';
        try
          while not Eof do
          begin
            if IsToday(FieldByName('DATAHORA').AsDateTime) then
              s := s + IntToHex(FieldByName('Id_Fila').AsInteger, 4) + FormatDateTime('hhnn', FieldByName('DATAHORA').AsDateTime) + TAB
            else
              s := s + IntToHex(FieldByName('Id_Fila').AsInteger, 4) + FormatDateTime('ddmmyyyyhhnn', FieldByName('DATAHORA').AsDateTime) + TAB;

            Next;
          end;
        finally
          IndexFieldNames := sOldIndexFieldNames;
        end;
      finally
        Filtered := false;
      end;
    end;
  end;
end;

procedure TfrmSicsMain.BroadcastListaDeAtendentes;
var
  aux: string;
begin
  GetSendAtdsListText(0, aux);
  EnviaParaTodosOsClients(TGSServerSocket.Socket, '0000' + Chr($72) + aux);
  Application.ProcessMessages;
  EnviaParaTodosOsClients(ServerSocket1.Socket, '0000' + Chr($72) + aux);
  Application.ProcessMessages;
end;

function TfrmSicsMain.BuscarImagemFila(const IDFila:Integer; var FileName: String; out Alinhamento:String): TStream;
var
  LConexao: TFDConnection;
  LQry: TFDQuery;
  LSQL: String;
begin
  LSQL := 'SELECT IMAGEM_FILA,ALINHAMENTO_IMAGEM FROM FILAS WHERE ID_UNIDADE = ' + vgParametrosModulo.IdUnidade.ToString +
     ' AND ID= ' + IntToStr(IDFila);

  LConexao := TFDConnection.Create(Nil);
  try
    LConexao.Close;
    LConexao.ConnectionDefName := TConexaoBD.Nome;
    LConexao.Open;

    LQry := TFDQuery.Create(Nil);
    try
      LQry.Close;
      LQry.Connection := LConexao;
      LQry.SQL.Text   := LSQL;
      LQry.Open;
      try
        if not LQry.IsEmpty then
        begin
          Alinhamento := LQry.FieldByName('ALINHAMENTO_IMAGEM').AsString;
          Result := TMemoryStream.Create;
          TBlobField(LQry.FieldByName('IMAGEM_FILA')).SaveToStream(Result);
          Result.Position := 0;
          FileName := IDFila.ToString;
        end
        else
          result := nil;
      finally
        LQry.Close;
      end;
    finally
      FreeAndNil(LQry);
    end;
  finally
    FreeAndNil(LConexao);
  end;
end;

function TfrmSicsMain.BuscarImagemTotem(const IDTotem: Integer; var FileName: String; ImagemTela: Integer = 0): TStream;
var
  LConexao: TFDConnection;
  LQry: TFDQuery;
  LSQL: String;
begin
  LSQL :=
    'SELECT IMAGEM, IMAGEM_NOME,ST_IMAGEM_FUNDO, ST_IMAGEM_FUNDO_NOME FROM TOTENS ' +
    'WHERE ID_UNIDADE = ' + vgParametrosModulo.IdUnidade.ToString + ' AND ID=' + IntToStr(IDTotem);

  LConexao := TFDConnection.Create(Nil);
  try
    LConexao.Close;
    LConexao.ConnectionDefName := TConexaoBD.Nome;
    LConexao.Open;

    LQry := TFDQuery.Create(Nil);
    try
      LQry.Close;
      LQry.Connection := LConexao;
      LQry.SQL.Text   := LSQL;
      LQry.Open;

      try
        if not LQry.IsEmpty then
        begin
          Result := TMemoryStream.Create;
          if ImagemTela = 0 then
            TBlobField(LQry.FieldByName('IMAGEM')).SaveToStream(Result)
          else
            TBlobField(LQry.FieldByName('ST_IMAGEM_FUNDO')).SaveToStream(Result);

          Result.Position := 0;
          if ImagemTela = 0 then
            FileName := LQry.FieldByName('IMAGEM_NOME').AsString
          else
            FileName := LQry.FieldByName('ST_IMAGEM_FUNDO_NOME').AsString;
        end
        else
          result := nil;
      finally
        LQry.Close;
      end;
    finally
      FreeAndNil(LQry);
    end;
  finally
    FreeAndNil(LConexao);
  end;
end;

function TfrmSicsMain.BuscarImagemTotemMultiTelas(const IDTela: Integer): TStream;
var
  LConexao: TFDConnection;
  LQry: TFDQuery;
  LSQL: String;
begin
  LSQL := 'SELECT IMAGEM FROM MULTITELAS WHERE ID_UNIDADE = ' + vgParametrosModulo.IdUnidade.ToString +
    ' AND ID = ' + IntToStr(IDTela);

  LConexao := TFDConnection.Create(Nil);
  try
    LConexao.Close;
    LConexao.ConnectionDefName := TConexaoBD.Nome;
    LConexao.Open;

    LQry := TFDQuery.Create(Nil);
    try
      LQry.Close;
      LQry.Connection := LConexao;
      LQry.SQL.Text   := LSQL;
      LQry.Open;

      try
        if not LQry.IsEmpty then
        begin
          Result := TMemoryStream.Create;
          TBlobField(LQry.FieldByName('IMAGEM')).SaveToStream(Result);
          Result.Position := 0;
        end
        else
          result := nil;
      finally
        LQry.Close;
      end;
    finally
      FreeAndNil(LQry);
    end;
  finally
    FreeAndNil(LConexao);
  end;
end;

function TfrmSicsMain.BuscarMaxIDSenha(ASenha: Integer): Boolean;
begin
  cdsIdsTickets.Close;
  cdsIdsTickets.ParamByName('NUMEROTICKET').AsInteger := ASenha;
  cdsIdsTickets.Open;

  Result := not cdsIdsTickets.IsEmpty;
end;

function TfrmSicsMain.BuscaStatusTV(AIP: String): String;
var LCount: Integer;
begin
  for LCount := 1 to cgMaxTVs do
  begin
    if vlTVs[LCount].IP = AIP then
    begin
      Result := 'Placa Captura Conectada: '    + vlTVs[LCount].TunerPresent+', '+
                'Estado do Vídeo: '            + vlTVs[LCount].VideoState  +', '+
                'Vídeo com Erro: '             + vlTVs[LCount].VideoError  +', '+
                'Interface de Usuário Atual: ' + vlTVs[LCount].CurrentUI   +', '+
                'Legenda: '                    + vlTVs[LCount].Legenda;
    end;
  end;
end;

procedure TfrmSicsMain.Button1Click(Sender: TObject);
var
  LQTDEPAProdutiva  :integer;
  LQTDEPessoasEspera:integer;
  LID               :integer;
begin
  ShowMessage(FormatDateTime('hh:nn:ss', CalculaTEE(MyInputInteger, LQTDEPAProdutiva, LQTDEPessoasEspera, LID)));
end;

function TfrmSicsMain.AtualizaAtendente(const aIdAtd: Integer; const aAtivo: Boolean; const aNome, aLogin,
      aSenhaLogin, aAtdRegFunc: string; const aGrupoAtend: Integer): Boolean;
var
  BM: TBookmark;
begin
  Result := false;
  with dmSicsMain.cdsAtendentes do
  begin
    BM := GetBookmark;
    try
      try
      if Locate('ID', aIdAtd, []) then
      begin
        LogChanges := True;
        try
          Edit;
          FieldByName('ATIVO').AsBoolean     := aAtivo;
          FieldByName('NOME').AsString       := aNome;
          FieldByName('LOGIN').AsString      := aLogin;
          FieldByName('SENHALOGIN').AsString := aSenhaLogin;
          FieldByName('REGISTROFUNCIONAL').AsString := aAtdRegFunc;
          if aGrupoAtend = -1 then
            FieldByName('ID_GRUPOATENDENTE').Clear
          else
            FieldByName('ID_GRUPOATENDENTE').AsInteger := aGrupoAtend;
          Post;
          if ApplyUpdates(0) = 0 then
          begin
            frmSicsSituacaoAtendimento.AtualizaListaDeAtendentes;
            BroadcastListaDeAtendentes;
            dmSicsContingencia.CheckReplicarTabelasP2C;
            Result := True;
          end;
        finally
          LogChanges := false;
        end;
      end;
      finally
        if BookmarkValid(BM) then
          GotoBookmark(BM);
      end;
    finally
      FreeBookmark(BM);
    end;
  end; { with cds }
end;   { proc AtualizaAtendente }


procedure TfrmSicsMain.BroadcastAgendamentosPorFila(Senha: integer);
var
  BM                : TBookmark;
  aux               : string;
  EstaEmAtendimento : boolean;
  PA                : integer;
begin
  EstaEmAtendimento := false;
  with frmSicsSituacaoAtendimento.cdsPAs do
  begin
    BM := GetBookmark;
    try
      if Locate('SENHA', Senha, []) then
      begin
        EstaEmAtendimento := true;
        PA := FieldByName('Id_PA').AsInteger;
      end;
    finally
      GotoBookmark(BM);
      FreeBookmark(BM);
    end;
  end;  // with cds

  //Envia para os clients apenas se a senha estiver em atendimento, e apenas para a PA que a estiver atendendo
  //  pois somente a PA que estiver atendendo esta senha precisa montar a tabela de agendamento da senha
  if EstaEmAtendimento then
  begin
    GetSendAgendamentosFilasText(senha, aux);
    EnviaParaTodosOsClients(ServerSocket1.Socket, IntToHex(PA,4) + Chr($C3) + aux);
    Application.ProcessMessages;
  end;
end;


procedure TfrmSicsMain.BroadcastChamadasComTE(PA, Senha: integer; DataHora: TDateTime);
begin
  EnviaParaTodosOsClients(ServerSocket1.Socket, IntToHex(PA,4) + Chr($39) + inttostr(senha) + ';' + FormatDateTime('ddmmyyyyhhnnss', DataHora));
  Application.ProcessMessages;
end;


function TfrmSicsMain.InsereAtendente(Nome, Login, SenhaLogin: string; GrupoAtend: Integer): Integer;
var
  NovoId: Integer;
  BM    : TBookmark;
begin
  NovoId := 0;
  Result := -1;
  with dmSicsMain.cdsAtendentes do
  begin
    BM := GetBookmark;
    try
      LogChanges                       := True;
      try
        try
        NovoId := TGenerator.NGetNextGenerator('GEN_ID_ATENDENTE', dmSicsMain.connOnLine);
        Append;
        FieldByName('ID').AsInteger               := NovoId;
        FieldByName('ATIVO').AsBoolean            := True;
        FieldByName('NOME').AsString              := Nome;
        FieldByName('LOGIN').AsString             := Login;
        FieldByName('SENHALOGIN').AsString        := SenhaLogin;
        FieldByName('TRIAGEM').AsBoolean          := True;;
        FieldByName('IMPRIMIRPULSEIRA').AsBoolean := True;;

        if GrupoAtend = -1 then
          FieldByName('ID_GRUPOATENDENTE').Clear
        else
          FieldByName('ID_GRUPOATENDENTE').AsInteger := GrupoAtend;

        Post;

        if ApplyUpdates(0) = 0 then
        begin
          frmSicsSituacaoAtendimento.AtualizaListaDeAtendentes;
          BroadcastListaDeAtendentes;
          Result := NovoId;

//          if Locate('ID', -1, []) then
//          begin
//            NovoId := TGenerator.NGetNextGenerator('GEN_ID_ATENDENTE', dmSicsMain.connOnLine);
//            Edit;
//            FieldByName('ID').AsInteger := NovoId;
//            Post;
//            if ApplyUpdates(0) = 0 then
//            begin
//              frmSicsSituacaoAtendimento.AtualizaListaDeAtendentes;
//              BroadcastListaDeAtendentes;
//              Result := NovoId;
//            end;
//          end;
          dmSicsContingencia.CheckReplicarTabelasP2C;
        end;
      finally
        LogChanges := false;
      end;
      finally
        if BookmarkValid(BM) then
          GotoBookmark(BM);
      end;
    finally
      FreeBookmark(BM);
    end;
  end; { with cds }
end;   { func InsereAtendente }

function TfrmSicsMain.InsereGrupoAtendente(Id: Integer;
  Nome: string): Boolean;
var
  BM    : TBookmark;
begin
  with dmSicsMain.cdsGruposDeAtendentes do
  begin
    BM := GetBookmark;
    try
      LogChanges                       := True;
      try
        try
          Append;
          FieldByName('ID').AsInteger        := Id;
          FieldByName('NOME').AsString     := Nome;
          Post;
          Result := ApplyUpdates(0) = 0;
        finally
          LogChanges := false;
        end;
      finally
        if BookmarkValid(BM) then
          GotoBookmark(BM);
      end;
    finally
      FreeBookmark(BM);
    end;
  end; { with cds }

end;

function TfrmSicsMain.InserirSenhaCallcenter(Fila, Senha: Integer): Integer;
var
  lNow: TDateTime;
  lID : Integer;
begin
  Result := 0;

  lNow := Now;

  //Gerar a Senha
  //RA
  {$REGION 'Código anterior comentado'}
  (*
  cdsIdsTickets.Append;
  cdsIdsTickets.FieldByName('NUMEROTICKET').AsInteger := Senha;
  cdsIdsTickets.FieldByName('ID').AsInteger := TGenerator.NGetNextGenerator('TICKET');
  RegistraTicket(cdsIdsTickets.FieldByName('ID').AsInteger, Senha, Fila, -2, lNow);
  cdsIdsTickets.Post;

  Result := cdsIdsTickets.FieldByName('ID').AsInteger;
  *)
  {$ENDREGION}

  lID := TGenerator.NGetNextGenerator('GEN_ID_TICKET', dmSicsMain.connOnLine);
  RegistraTicket(lID, Senha, Fila, -2, lNow);

  AtualizarIDsTickets;

  //Inserir a Senha na Fila
  InsertPswd(Fila, Senha, lNow, -2);

  Result := lID;
end;

procedure TfrmSicsMain.InserirSenhaNaFila(AFila, ASenha, APosIt: Integer; ATipo: TTipoDeInsercaoDeSenha);
var
  lIDTicket,
  lIDFila,
  iNegativo: Integer;

  lNomeCliente: String;

  lNow,
  lCreatedAt: TDateTime;

  BM: TBookmark;
begin
  lNow := Now;

  case ATipo of
    isNova, isUltima:
      begin
        //RA
        {$REGION 'Código anterior comentado'}
        (*
        with cdsIdsTickets do
        begin
          if not Locate('NUMEROTICKET', SenhaInserida, []) then
            Edit
          else
          begin
            Append; //Nova
            FieldByName('NUMEROTICKET').AsInteger := SenhaInserida;
          end;

          // se for servidor de contigencia, os ids dos tickets sao inserido como negativos
          if dmSicsContingencia.TipoFuncionamento = tfContingente then
            iNegativo := -1
          else
            iNegativo := 1; //NoVa

          if FieldByName('ID').IsNull then
          begin   //Nova
            FieldByName('ID').AsInteger := TGenerator.NGetNextGenerator('TICKET', dmSicsMain.connOnLine) * iNegativo;

            RegistraTicket(FieldByName('ID').AsInteger, SenhaInserida, i, -2, lNow);
          end;

          Post;
        end;

        InsertPswd(i, SenhaInserida, lNow, -1); //Nova
        (FindComponent('SenhaEdit' + IntToStr(I)) as TEdit).Text := '';
        *)
        {$ENDREGION}

        iNegativo := IfThen(dmSicsContingencia.TipoFuncionamento = tfContingente, -1, 1);

        if LocalizarTicket(ASenha, lIDTicket, lIDFila, lNomeCliente, lCreatedAt) then
        begin
          {$REGION 'Ticket já existiu'}
          if (not lIDFila.ToString.Trim.IsEmpty) and
             (lIDFila <> 0                     ) then
          begin
            {$REGION 'Ticket está em alguma fila, só deverá ser direcionado à nova fila'}
            DirecionarTicketParaFilaBD(ASenha, lIDFila, AFila, APosIt);
            InsertPswd(AFila, ASenha, lNow, APosIt); //Nova
            {$ENDREGION}
          end
          else
          begin
            {$REGION 'Ticket não está em fila alguma - Verificar se está em atendimento'}
            BM := frmSicsSituacaoAtendimento.cdsPAs.GetBookmark;

            try
              if frmSicsSituacaoAtendimento.cdsPAs.Locate('SENHA', ASenha, []) then
              begin
                {$REGION 'Ticket está em atendimento, deverá ser redirecionado para a fila'}
                Redireciona(frmSicsSituacaoAtendimento.cdsPAs.FieldByName('Id_PA').AsInteger, AFila);
                AtualizarIDsTickets;
                {$ENDREGION}
              end
              else
              begin
                {$REGION 'Ticket não está em atendimento, verificar opção selecionada pelo usuário para criar novo ticket ou chamar o último'}
                if ATipo = isNova then
                begin
                  {$REGION 'Gerar novo ticket'}
                  RegistraTicket(TGenerator.NGetNextGenerator('GEN_ID_TICKET', dmSicsMain.connOnLine) * iNegativo,
                                 ASenha, AFila, APosIt, lNow);
                  AtualizarIDsTickets;
                  InsertPswd(AFila, ASenha, lNow, APosIt);
                  {$ENDREGION}
                end
                else
                begin
                  {$REGION 'Chamar último tícket com o número especificado'}
                  InsertPswd(AFila, ASenha, lNow, APosIt);
                  {$ENDREGION}
                end;
                {$ENDREGION}
              end;
            finally
              frmSicsSituacaoAtendimento.cdsPAs.GotoBookmark(BM);
            end;
            {$ENDREGION}
          end;
          {$ENDREGION}
        end
        else
        begin
          {$REGION 'Ticket nunca existiu e deve ser inserido'}
          RegistraTicket(TGenerator.NGetNextGenerator('GEN_ID_TICKET', dmSicsMain.connOnLine) * iNegativo, ASenha, AFila, -1, lNow);
          AtualizarIDsTickets;
          InsertPswd(AFila, ASenha, lNow, -1); //Nova
          {$ENDREGION}
        end;
      end;
    isNone:
      begin
      end;
  end; { case }
end;

function TfrmSicsMain.VerificaLoginCliente(Login, Senha, Posicao: String): String;
var
  LSQL: String;
  LLoginAutomatico : Boolean;
  LPosicao: String;
  LQryLogin: TFDQuery;
begin
  LSQL     := EmptyStr;
  LPosicao := EmptyStr;

  LLoginAutomatico := Senha = TextHash(SENHA_PADRAO_LOGIN_AUTOMATICO);

  Result := '';

  LQryLogin := TFDQuery.Create(Nil);
  try
    LQryLogin.Connection := dmSicsMain.connOnLine;
    try
      if LLoginAutomatico then
      begin
        LSQL := ' Select ID, NOME, LOGIN, SENHALOGIN, LOGADO_NUMERO_MESA'+
                ' From CLIENTES '+
                ' Where ID_UNIDADE = ' + vgParametrosModulo.IdUnidade.ToString +
                ' and UPPER(LOGIN) = ' + QuotedStr(uppercase(Login))+
                ' and   ATIVO = ' + QuotedStr('T');
      end
      else
      begin
        LSQL := ' Select ID, NOME, LOGIN, SENHALOGIN, LOGADO_NUMERO_MESA'+
                ' From CLIENTES'+
                ' Where ID_UNIDADE = ' + vgParametrosModulo.IdUnidade.ToString +
                ' and UPPER(LOGIN) = ' + QuotedStr(uppercase(Login)) +
                ' and   SENHALOGIN = ' + QuotedStr(Senha)+
                ' and   ATIVO = ' + QuotedStr('T');

      end;

      LQryLogin.Close;
      LQryLogin.SQL.Text := LSQL;
      LQryLogin.Open;

      if LQryLogin.IsEmpty then
      begin
        if LLoginAutomatico then
          Result := 'F' + TAB + 'Login Automático: Usuário "' + Login + '" não localizado.'
        else
          Result := 'F' + TAB + 'Usuário ou senha inválidos.';
      end
      else
      begin
        if IntToStr(LQryLogin.FieldByName('LOGADO_NUMERO_MESA').AsInteger) <> EmptyStr then
          LPosicao := LQryLogin.FieldByName('LOGADO_NUMERO_MESA').AsString;

        if LPosicao = EmptyStr then
        begin
          Result := 'T' + TAB + IntToStr(LQryLogin.FieldByName('ID').AsInteger)
            + TAB + LQryLogin.FieldByName('NOME').AsString;

          LSQL := ' UPDATE CLIENTES '+
                  ' SET LOGADO_NUMERO_MESA = ' + IntToStr(StrToInt(Posicao)) +
                  ' Where ID_UNIDADE   = ' + vgParametrosModulo.IdUnidade.ToString +
                  '   and UPPER(LOGIN) = ' + QuotedStr(uppercase(Login)) +
                  ' and   SENHALOGIN = ' + QuotedStr(Senha);

          LQryLogin.Close;
          LQryLogin.SQL.Text := LSQL;
          LQryLogin.ExecSQL;
        end
        else
        if LPosicao <> EmptyStr then
        begin
          Result := 'L' + TAB + 'Usuário já logado na mesa: ' + LPosicao;
        end;
      end;
    except on E: Exception do
      begin
        Result   := 'E'+ TAB + E.Message;
        MyLogException(E);
      end;
    end;
  finally
    FreeAndNil(LQryLogin);
  end;
end;

function TfrmSicsMain.AtenderChamadoCallcenter(Login, Senha, Posicao: String): String;
var
  LFieldLogin: String;
  LValorLogin: String;
  LIdTemp: Integer;
  LIdAtendente: Integer;
  LIdPA: Integer;
  IniTime                 : TDateTime;
begin
  try
    LIdAtendente := -1;
    if TryStrToInt(Login, LIdTemp) then
    begin
      LFieldLogin := 'ID';
      LValorLogin := LIdTemp.ToString;
    end
    else
    begin
      LFieldLogin := 'LOGIN';
      LValorLogin := Login;
    end;

    if ((dmSicsMain.cdsAtendentes.Locate(LFieldLogin, LValorLogin, [loCaseInsensitive])) and
        (dmSicsMain.cdsAtendentes.FieldByName('ATIVO').AsBoolean) and
        ( (Senha = SENHA_FIXA_LOGIN_GESTOR_VIA_COMBO) or
          (dmSicsMain.cdsAtendentes.FieldByName('SENHALOGIN').AsString = Senha)
        )
       ) then
      LIdAtendente := dmSicsMain.cdsAtendentes.FieldByName('ID').AsInteger;

    if LIdAtendente < 0 then
      Exit('FUsuario ou Senha Inválidos');

    if not frmSicsSituacaoAtendimento.GetAtendenteEstaLogado(LIdAtendente, LIdPA) then
      Exit('FGestor não está logado em sua PA');

    LIdTemp := frmSicsMain.ChamaEspecifica(LIdPA, StrToInt(Posicao), IniTime);
    case LIdTemp of
      -1 : Result := 'F' + TAB + 'A senha não está em nenhuma fila';
      -2 : Result := 'F' + TAB + 'O atendente está aguardando para ser anunciado na painel'; { Esta na fila para chamar alguem }
      -3 : Result := 'F' + TAB + 'A senha está numa fila não contida nas prioridades de atendimento';
      //-4 : Result := 'F' + TAB + 'Não chamou ninguém porque numero de atendimentos ultrapassa magazine';
      -5 : Result := 'F' + TAB + 'Não tem atendente logado na PA';
      -6 : Result := 'F' + TAB + 'Senha inválida (out of range)';
    else Result := 'T';
    end;
  except on E: Exception do
    Result := 'E' + TAB + E.Message;
  end;
end;

function TfrmSicsMain.VerificaSeAtendenteEPermitidoNoModulo (IdAtd, IdModulo : integer) : boolean;
var
  aCDSAtdeFiltro: TClientDataSet;
begin
  TfrmDebugParameters.Debugar(tbProtocoloSics, 'Entrou VerificaSeAtendenteEPermitidoNoModulo. IdModulo: ' + IntToStr(IdModulo) + ' IdAtd: ' + IntToStr(IdAtd));
  if IdModulo = 0 then
  begin
    Result := true;
    Exit;
  end;

  aCDSAtdeFiltro := GetNewCDSFilter(dmSicsMain.cdsAtendentes);
  try
    FiltraDataSetComPermitidas(dmSicsMain.connOnLine, aCDSAtdeFiltro, IdModulo, tgAtd, 'ID_GRUPOATENDENTE');

    Result := aCDSAtdeFiltro.Locate('ID', IdAtd, []);
  finally
    FreeAndNil(aCDSAtdeFiltro);
  end;

  TfrmDebugParameters.Debugar(tbProtocoloSics, 'Saiu VerificaSeAtendenteEPermitidoNoModulo. IdModulo: ' + IntToStr(IdModulo) + ' IdAtd: ' + IntToStr(IdAtd));
end;

procedure TfrmSicsMain.GetSendAtdsListText(const aIdModulo: Integer; var S: string);
var
  IdAtd, NoAtds  : Integer;
  LLogin, Nome   : string;
  RegFunc, Grupo : string;
  Senha          : string;
  vNomeTabela    : string;
  vNomeColuna    : string;
  vTipoModulo    : TModuloSics;
  vRangeIDs      : TIntArray;
  vStrRangeIDs   : string;
  LQuery         : TFDQuery;
begin
  TfrmDebugParameters.Debugar(tbProtocoloSics, 'Entrou GetSendAtdsListText. IdModulo: ' + IntToStr(aIdModulo));

//  aCDSAtdeFiltro := GetNewCDSFilter(dmSicsMain.cdsAtendentes);
  try
//    FiltraDataSetComPermitidas(dmSicsMain.connOnLine, aCDSAtdeFiltro, AIdModulo, tgAtd, 'ID_GRUPOATENDENTE');
    vTipoModulo := GetModuleTypeByID(dmSicsMain.connOnLine, aIdModulo);

    if (vTipoModulo = msNone) then
      Exit;

    vNomeTabela := GetNomeTabelaDoModulo(vTipoModulo);
    vNomeColuna := GetNomeColunaTipoGrupoPorModulo(vTipoModulo, tgAtd);

    if (vNomeTabela = EmptyStr) or (vNomeColuna = EmptyStr) then
      Exit;

    vRangeIDs := GetListaIDPermitidosDoGrupo(dmSicsMain.connOnLine, vNomeTabela, vNomeColuna, aIdModulo);

    TfrmDebugParameters.Debugar(tbProtocoloSics, 'GetSendAtdsListText. TipoModulo: ' + IntToStr(Ord(vTipoModulo)) +
                                                                     ' NomeTabela: ' + vNomeTabela +
                                                                     ' NomeColuna: ' + vNomeColuna +
                                                                     ' Range IDs: '  + vStrRangeIDs);
    LQuery := TFDQuery.Create(nil);
    try
      LQuery.Connection := dmSicsMain.connOnLine;
      LQuery.SQL.Text := Format('SELECT ID, NOME, REGISTROFUNCIONAL, ATIVO, '+
                                'ID_GRUPOATENDENTE, LOGIN, SENHALOGIN ' +
                                'FROM ATENDENTES WHERE ID_UNIDADE=%d', [vgParametrosModulo.IdUnidade]);
      LQuery.Open;

      S      := '';
      NoAtds := 0;
      LQuery.First;
      while not LQuery.Eof do
      begin
        if ((LQuery.FieldByName('ATIVO').AsBoolean) and (ExisteNoIntArray(LQuery.FieldByName('ID_GRUPOATENDENTE').AsInteger, vRangeIDs))) then
        begin
          IdAtd   := LQuery.FieldByName('ID').AsInteger;
          Nome    := LQuery.FieldByName('NOME').AsString;
          RegFunc := LQuery.FieldByName('REGISTROFUNCIONAL').AsString;
          Grupo   := LQuery.FieldByName('ID_GRUPOATENDENTE').AsString;
          LLogin  := LQuery.FieldByName('LOGIN').AsString;
          // ********************************************************************************
          // A senha não mais será enviada aos clients
          // Os clients enviarão usuário e senha ao servidor para login
          // ********************************************************************************
          // Senha  := FieldByName('SENHALOGIN').AsString;

          Senha   := LQuery.FieldByName('SENHALOGIN').AsString; // Está enviando ainda para uso nos módulos Client na tela de alteração de senha do usuário (conferir a senha atual para deixar colocar próxima). Alterar isto no futuro
          NoAtds := NoAtds + 1;

          S := S + TAspEncode.AspIntToHex(IdAtd, 4) + Nome + ';' + RegFunc + ';' + Grupo + ';' + Senha + ';' + LLogin + TAB;
        end;

        LQuery.Next;
      end;

      S := TAspEncode.AspIntToHex(NoAtds, 4) + S;
    finally
      Finalize(vRangeIDs);
      FreeAndNil(LQuery);
    end; { with cds }
  except
    on E: Exception do
      MyLogException(E, True);
  end;

  TfrmDebugParameters.Debugar(tbProtocoloSics, 'Saiu GetSendAtdsListText. IdModulo: ' + IntToStr(aIdModulo));
end;   { proc GetSendAtdListText }

procedure TfrmSicsMain.GetSendPAsListText(const IdModulo: Integer; var S: string);
var
  IdPA, NPA    : Integer;
  Nome, Grupo  : string;
  vNomeTabela  : string;
  vNomeColuna  : string;
  vTipoModulo  : TModuloSics;
  vRangeIDs    : TIntArray;
  vStrRangeIDs : string;
  LQuery       : TFDQuery;
begin
  TfrmDebugParameters.Debugar(tbProtocoloSics, 'Entrou GetSendPAsListText. IdModulo: ' + IntToStr(IdModulo));

  //dmSicsMain.cdsFiltroPAs.CloneCursor(dmSicsMain.cdsPAs, True);

//    FiltraDataSetComPermitidas(dmSicsMain.connOnLine, dmSicsMain.cdsFiltroPAs, IdModulo, tgNomesPAs, LColuna,
//      function (aModuloSics: TModuloSics): string
//      begin
//        case aModuloSics of
//          msOnLine, msTGS, msTV: Result := 'ID_GRUPOPA';
//        else
//          Result := LColuna;
//        end;
//      end);

  try
    vTipoModulo := GetModuleTypeByID(dmSicsMain.connOnLine, IdModulo);

    if (vTipoModulo = msNone) then
      Exit;

    vNomeTabela := GetNomeTabelaDoModulo(vTipoModulo);
    vNomeColuna := GetNomeColunaTipoGrupoPorModulo(vTipoModulo, tgNomesPAs);

    if (vNomeTabela = EmptyStr) or (vNomeColuna = EmptyStr) then
      Exit;

    if(vTipoModulo = msPA)then
      vNomeTabela := '(SELECT '+
                     '   ID_UNIDADE, ' +
                     '   ID, '+
                     '   (CASE WHEN MODO_TERMINAL_SERVER = '+QuotedStr('T')+' THEN PAS_PERMITIDAS ELSE ID_PA END) PAS_PERMITIDAS ' +
                     ' FROM ' +
                     '   MODULOS_PAS' +
                     ' WHERE '+
                     '   ID_UNIDADE = ' + vgParametrosModulo.IdUnidade.ToString + ')';

    vRangeIDs := GetListaIDPermitidosDoGrupoPA(dmSicsMain.connOnLine, vNomeTabela, vNomeColuna, IdModulo);

    TfrmDebugParameters.Debugar(tbProtocoloSics, 'GetSendPAsListText. TipoModulo: ' + IntToStr(Ord(vTipoModulo)) +
                                                                    ' NomeTabela: ' + vNomeTabela +
                                                                    ' NomeColuna: ' + vNomeColuna +
                                                                    ' Range IDs: ' + vStrRangeIDs);
    LQuery := TFDQuery.Create(nil);
    try
      LQuery.Connection := dmSicsMain.connOnLine;
      LQuery.SQL.Text := Format('SELECT ID, NOME, ID_GRUPOPA, ATIVO FROM PAS A WHERE ID_UNIDADE=%d', [vgParametrosModulo.IdUnidade]);
      LQuery.Open;

      NPA := 0;
      S   := '';
      LQuery.First;
      while not LQuery.Eof do
      begin
        if (LQuery.FieldByName('Ativo').AsBoolean) and (ExisteNoIntArray(LQuery.FieldByName('ID_GRUPOPA').AsInteger, vRangeIDs)) then
        begin
          IdPA  := LQuery.FieldByName('ID').AsInteger;
          Nome  := LQuery.FieldByName('NOME').AsString;
          Grupo := LQuery.FieldByName('ID_GRUPOPA').AsString;
          NPA   := NPA + 1;
          S     := S + TAspEncode.AspIntToHex(IdPA, 4) + Nome + ';' + Grupo + TAB;
        end;

        LQuery.Next;
      end;

      S := TAspEncode.AspIntToHex(NPA, 4) + S;
    finally
      Finalize(vRangeIDs);
      FreeAndNil(LQuery);
    end;
  except
    on E: Exception do
      MyLogException(E, True);
  end;

  TfrmDebugParameters.Debugar(tbProtocoloSics, 'Saiu GetSendPAsListText. IdModulo: ' + IntToStr(IdModulo));
end;   { proc GetSendAtdListText }

procedure TfrmSicsMain.GetSendFilasComRange(var s: string);
var
  IdFila           : Integer;
  Cor              : Integer;
  Nome             : string;
  I                : Integer;
  IdCategoriaFila  : integer;
  IdGrupoFila      : integer;
begin
  dmSicsMain.cdsFiltroFilas.CloneCursor(dmSicsMain.cdsFilas, false, True);
  dmSicsMain.cdsFiltroFilas.Filtered := False;
  dmSicsMain.cdsFiltroFilas.Filter   := '(RANGEMAXIMO > 0)';
  dmSicsMain.cdsFiltroFilas.Filtered := True;

  I  := 0;
  S  := '';
  dmSicsMain.cdsFiltroFilas.First;
  while not dmSicsMain.cdsFiltroFilas.Eof do
  begin
    if dmSicsMain.cdsFiltroFilas.FieldByName('Ativo').AsBoolean then
    begin
      I                 := I + 1;
      IdFila            := dmSicsMain.cdsFiltroFilas.FieldByName('ID').AsInteger;
      Cor               := dmSicsMain.cdsFiltroFilas.FieldByName('CODIGOCOR').AsInteger;
      Nome              := dmSicsMain.cdsFiltroFilas.FieldByName('NOME').AsString;
      IdCategoriaFila   := dmSicsMain.cdsFiltroFilas.FieldByName('ID_CATEGORIAFILA').AsInteger;
      IdGrupoFila       := dmSicsMain.cdsFiltroFilas.FieldByName('ID_GRUPOFILA').AsInteger;

      S := S + TAspEncode.AspIntToHex(IdFila, 4) +
               TAspEncode.AspIntToHex(Cor, 6) +
               TAspEncode.AspIntToHex(IdCategoriaFila, 4) +
               TAspEncode.AspIntToHex(IdGrupoFila, 4) +
               Nome +
               TAB;
    end;

    dmSicsMain.cdsFiltroFilas.Next;
  end;
  S := TAspEncode.AspIntToHex(I, 4) + S;
end;

procedure TfrmSicsMain.GetGrupoFilas(var s: string);
var
  I: Integer;
  Id:integer;
  Nome:string;
begin
  dmSicsMain.cdsGrupoFila.Close;
  dmSicsMain.cdsGrupoFila.Open;

  I  := 0;
  S  := '';
  dmSicsMain.cdsGrupoFila.First;
  while not dmSicsMain.cdsGrupoFila.Eof do
  begin
    I             := I + 1;
    Id            := dmSicsMain.cdsGrupoFila.FieldByName('ID').AsInteger;
    Nome          := dmSicsMain.cdsGrupoFila.FieldByName('NOME').AsString;

    S := S + TAspEncode.AspIntToHex(Id, 4) + Nome + TAB;

    dmSicsMain.cdsGrupoFila.Next;
  end;
end;

procedure TfrmSicsMain.GetCategoriaFilas(var s: string);
var
  I: Integer;
  Id:integer;
  Nome:string;
begin
  dmSicsMain.cdsCategoriaFilas.Close;
  dmSicsMain.cdsCategoriaFilas.Open;

  I  := 0;
  S  := '';
  dmSicsMain.cdsCategoriaFilas.First;
  while not dmSicsMain.cdsCategoriaFilas.Eof do
  begin
    I             := I + 1;
    Id            := dmSicsMain.cdsCategoriaFilas.FieldByName('ID').AsInteger;
    Nome          := dmSicsMain.cdsCategoriaFilas.FieldByName('NOME').AsString;

    S := S + TAspEncode.AspIntToHex(Id, 4) + Nome + TAB;

    dmSicsMain.cdsCategoriaFilas.Next;
  end;
end;

procedure TfrmSicsMain.GetSendFilasNamesText(const IdModulo: Integer; var S: string);
var
  IdFila, Cor, I     : Integer;
  Nome, NomeTotem    : string;
  LimiarAmarelo      : TTime;
  LimiarVermelho     : TTime;
  LimiarLaranja      : TTime;
  NegritoNomeFila    : string;
  ItalicoNomeFila    : string;
  SublinhadoNomeFila : string;
  TamanhoNomeFila    : Integer;
  CorNomeFila        : Integer;
  vTipoModulo        : TModuloSics;
  LQuery             : TFDQuery;
  vNomeTabela        : string;
  vNomeColuna        : string;
  vRangeIDs          : TIntArray;
  vStrRangeIDs       : string;
begin
  TfrmDebugParameters.Debugar(tbProtocoloSics, 'Entrou GetSendFilasNamesText. IdModulo: ' + IntToStr(IdModulo));
  // GOT
//  dmSicsMain.cdsFiltroFilas.CloneCursor(dmSicsMain.cdsFilas, false, True);


//  if LTipoModulo <> msCallCenter then
//    FiltraDataSetComPermitidas(dmSicsMain.connOnLine, dmSicsMain.cdsFiltroFilas, IdModulo, tgFila);
  try
    vTipoModulo := GetModuleTypeByID(dmSicsMain.connOnLine, IdModulo);

    if (vTipoModulo = msNone) then
      Exit;

    vNomeTabela := GetNomeTabelaDoModulo(vTipoModulo);
    vNomeColuna := GetNomeColunaTipoGrupoPorModulo(vTipoModulo, tgFila);

    if (vNomeTabela = EmptyStr) or (vNomeColuna = EmptyStr) then
      Exit;

    vRangeIDs := GetListaIDPermitidosDoGrupo(dmSicsMain.connOnLine, vNomeTabela, vNomeColuna, IdModulo);

    TfrmDebugParameters.Debugar(tbProtocoloSics, 'GetSendFilasNamesText. TipoModulo: ' + IntToStr(Ord(vTipoModulo)) +
                                                                       ' NomeTabela: ' + vNomeTabela +
                                                                       ' NomeColuna: ' + vNomeColuna +
                                                                       ' Range IDs: ' + vStrRangeIDs);
    LQuery := TFDQuery.Create(nil);
    try
      LQuery.Connection := dmSicsMain.connOnLine;
      LQuery.SQL.Text := Format('SELECT ID, CODIGOCOR, NOME, NOMENOTOTEM, ATIVO, '+
                                'LIMIAR_AMARELO, LIMIAR_VERMELHO, LIMIAR_LARANJA, ' +
                                'TAMANHO_NOME_FILA, NEGRITO_NOME_FILA, ITALICO_NOME_FILA, ' +
                                'SUBLINHADO_NOME_FILA, COR_NOME_FILA ' +
                                'FROM FILAS WHERE ID_UNIDADE=%d', [vgParametrosModulo.IdUnidade]);
      LQuery.Open;

      I  := 0;
      S  := '';

      LQuery.First;
      while not LQuery.Eof do
      begin
        if (LQuery.FieldByName('Ativo').AsBoolean) and (ExisteNoIntArray(LQuery.FieldByName('ID').AsInteger, vRangeIDs)) then
        begin
          I                  := I + 1;
          IdFila             := LQuery.FieldByName('ID').AsInteger;
          Cor                := LQuery.FieldByName('CODIGOCOR').AsInteger;
          Nome               := LQuery.FieldByName('NOME').AsString + ';';
          NomeTotem          := LQuery.FieldByName('NOMENOTOTEM').AsString;
          LimiarAmarelo      := TimeOf(LQuery.FieldByName('LIMIAR_AMARELO').AsDateTime);
          LimiarVermelho     := TimeOf(LQuery.FieldByName('LIMIAR_VERMELHO').AsDateTime);
          LimiarLaranja      := TimeOf(LQuery.FieldByName('LIMIAR_LARANJA').AsDateTime);
          TamanhoNomeFila    := LQuery.FieldByName('TAMANHO_NOME_FILA').AsInteger;
          NegritoNomeFila    := LQuery.FieldByName('NEGRITO_NOME_FILA').AsString;
          ItalicoNomeFila    := LQuery.FieldByName('ITALICO_NOME_FILA').AsString;
          SublinhadoNomeFila := LQuery.FieldByName('SUBLINHADO_NOME_FILA').AsString;
          CorNomeFila        := LQuery.FieldByName('COR_NOME_FILA').AsInteger;

          S := S + TAspEncode.AspIntToHex(IdFila, 4) + TAspEncode.AspIntToHex(Cor, 6) +
                  TimeToStr(LimiarAmarelo) + TimeToStr(LimiarVermelho) +
                  TimeToStr(LimiarLaranja) + TAspEncode.AspIntToHex(TamanhoNomeFila, 4) + NegritoNomeFila +
                  ItalicoNomeFila + SublinhadoNomeFila + TAspEncode.AspIntToHex(CorNomeFila, 6) + Nome + NomeTotem + TAB;
        end;

        LQuery.Next;
      end;

      S := TAspEncode.AspIntToHex(I, 4) + S;
    finally
      Finalize(vRangeIDs);
      FreeAndNil(LQuery);
    end;
  except
    on E: Exception do
      MyLogException(E, True);
  end;

  TfrmDebugParameters.Debugar(tbProtocoloSics, 'Saiu GetSendFilasNamesText. IdModulo: ' + IntToStr(IdModulo));
end;   { proc GetSendFilasNamesText }

procedure TfrmSicsMain.GetSendTagsNamesText(const aIdModulo: Integer; var S: string);
var
  IdTag, Cor, I : Integer;
  Nome          : string;
  Grupo         : Integer;
  vTipoModulo   : TModuloSics;
  LQuery        : TFDQuery;
  vNomeTabela   : string;
  vNomeColuna   : string;
  vRangeIDs     : TIntArray;
  vStrRangeIDs  : string;
begin
  TfrmDebugParameters.Debugar(tbProtocoloSics, 'Entrou GetSendTagsNamesText. IdModulo: ' + IntToStr(aIdModulo));
//  aCDSTagsFiltro := GetNewCDSFilter(dmSicsMain.cdsTags);
  try
//    FiltraDataSetComPermitidas(dmSicsMain.connOnLine, aCDSTagsFiltro, AIdModulo, tgTAG, 'ID_GRUPOTAG');
    vTipoModulo := GetModuleTypeByID(dmSicsMain.connOnLine, aIdModulo);

    if (vTipoModulo = msNone) then
      Exit;

    vNomeTabela := GetNomeTabelaDoModulo(vTipoModulo);
    vNomeColuna := GetNomeColunaTipoGrupoPorModulo(vTipoModulo, tgTAG);

    if (vNomeTabela = EmptyStr) or (vNomeColuna = EmptyStr) then
      Exit;

    vRangeIDs := GetListaIDPermitidosDoGrupo(dmSicsMain.connOnLine, vNomeTabela, vNomeColuna, aIdModulo);

    TfrmDebugParameters.Debugar(tbProtocoloSics, 'GetSendTagsNamesText. TipoModulo: ' + IntToStr(Ord(vTipoModulo)) +
                                                                      ' NomeTabela: ' + vNomeTabela +
                                                                      ' NomeColuna: ' + vNomeColuna +
                                                                      ' Range IDs: ' + vStrRangeIDs);
    LQuery := TFDQuery.Create(nil);
    try
      LQuery.Connection := dmSicsMain.connOnLine;
      LQuery.SQL.Text := Format('SELECT ID, CODIGOCOR, NOME, ID_GRUPOTAG, ATIVO '+
                                'FROM TAGS WHERE ID_UNIDADE=%d', [vgParametrosModulo.IdUnidade]);
      LQuery.Open;

      I  := 0;
      S  := '';
      LQuery.First;
      while not LQuery.Eof do
      begin
        if ((LQuery.FieldByName('Ativo').AsBoolean) and (ExisteNoIntArray(LQuery.FieldByName('ID_GRUPOTAG').AsInteger, vRangeIDs))) then
        begin
          I     := I + 1;
          IdTag := LQuery.FieldByName('ID').AsInteger;
          Cor   := LQuery.FieldByName('CODIGOCOR').AsInteger;
          Grupo := LQuery.FieldByName('ID_GRUPOTAG').AsInteger;
          Nome  := LQuery.FieldByName('NOME').AsString;

          S     := S + TAspEncode.AspIntToHex(IdTag, 4) + TAspEncode.AspIntToHex(Cor, 6) + IntToStr(Grupo) + ';' + Nome + TAB;
        end;

        LQuery.Next;
      end;

      S := TAspEncode.AspIntToHex(I, 4) + S;
    finally
      Finalize(vRangeIDs);
      FreeAndNil(LQuery);
    end;
  except
    on E: Exception do
      MyLogException(E, True);
  end;

  TfrmDebugParameters.Debugar(tbProtocoloSics, 'Saiu GetSendTagsNamesText. IdModulo: ' + IntToStr(aIdModulo));
end;   { proc GetSendFilasNamesText }

procedure TfrmSicsMain.GetSendPPsTableText(const AIdModulo: Integer; var S: string);
var
  IdPP : Integer;
  Cor  : Integer;
  Nome : string;
  I    : Integer;
  Grupo: Integer;
  aCDSPPSFiltro: TClientDataSet;
begin
  aCDSPPSFiltro := GetNewCDSFilter(dmSicsMain.cdsPPs);
  try
    FiltraDataSetComPermitidas(dmSicsMain.connOnLine, aCDSPPSFiltro, AIdModulo, tgPP, 'ID_GRUPOPP');

    with aCDSPPSFiltro do
    begin
      I  := 0;
      S  := '';
      First;
      while not Eof do
      begin
        if FieldByName('Ativo').AsBoolean then
        begin
          I     := I + 1;
          IdPP  := FieldByName('ID').AsInteger;
          Cor   := FieldByName('CODIGOCOR').AsInteger;
          Grupo := FieldByName('ID_GRUPOPP').AsInteger;
          Nome  := FieldByName('NOME').AsString;
          S     := S + TAspEncode.AspIntToHex(IdPP, 4) + TAspEncode.AspIntToHex(Cor, 6) + IntToStr(Grupo) + ';' + Nome + TAB;
        end;

        Next;
      end;
      S := TAspEncode.AspIntToHex(I, 4) + S;
    end; { with cds }
  finally
    FreeAndNil(aCDSPPSFiltro);
  end;
end;   { proc GetSendPPsTableText }

procedure TfrmSicsMain.GetSendMotivosDePausaTableText(const AIDModulo: Integer; var S: string);
var
  IdMP : Integer;
  Cor  : Integer;
  Nome : string;
  I    : Integer;
  Grupo: Integer;
  aCDSPausaFiltro: TClientDataSet;
begin
  TfrmDebugParameters.Debugar(tbProtocoloSics, 'Entrou GetSendMotivosDePausaTableText. IdModulo: ' + IntToStr(AIDModulo));

  aCDSPausaFiltro := GetNewCDSFilter(dmSicsMain.cdsMotivosDePausa);
  try
    FiltraDataSetComPermitidas(dmSicsMain.connOnLine, aCDSPausaFiltro, AIdModulo, tgPausa, 'ID_GRUPOMOTIVOSPAUSA');
    with aCDSPausaFiltro do
    begin
      I  := 0;
      S  := '';
      First;
      while not Eof do
      begin
        if FieldByName('Ativo').AsBoolean then
        begin
          I     := I + 1;
          IdMP  := FieldByName('ID').AsInteger;
          Cor   := FieldByName('CODIGOCOR').AsInteger;
          Grupo := FieldByName('ID_GRUPOMOTIVOSPAUSA').AsInteger;
          Nome  := FieldByName('NOME').AsString;
          S     := S + TAspEncode.AspIntToHex(IdMP, 4) + TAspEncode.AspIntToHex(Cor, 6) + IntToStr(Grupo) + ';' + Nome + TAB;
        end;

        Next;
      end;
      S := TAspEncode.AspIntToHex(I, 4) + S;
    end; { with cds }
  finally
    FreeAndNil(aCDSPausaFiltro);
  end;

  TfrmDebugParameters.Debugar(tbProtocoloSics, 'Saiu GetSendMotivosDePausaTableText. IdModulo: ' + IntToStr(AIDModulo));
end; { proc GetSendMotivosDePausaTableText }


function TfrmSicsMain.GetSendMotivosDePausaTableTextPA(const PA: Integer): String;
var
  IdMP : Integer;
  Nome : string;
  I    : Integer;
  aCDSPausaFiltro: TClientDataSet;
  IdModulo: Integer;
begin
  Result := EmptyStr;

  aCDSPausaFiltro := GetNewCDSFilter(dmSicsMain.cdsMotivosDePausa);
  try
    IdModulo := GetIdModulo(dmSicsMain.connOnLine, PA);

    FiltraDataSetComPermitidas(dmSicsMain.connOnLine, aCDSPausaFiltro, IdModulo, tgPausa, 'ID_GRUPOMOTIVOSPAUSA');
    with aCDSPausaFiltro do
    begin
      I  := 0;
      Result := '';
      First;
      while not Eof do
      begin
        if FieldByName('Ativo').AsBoolean then
        begin
          I      := I + 1;
          IdMP   := FieldByName('ID').AsInteger;
          Nome   := FieldByName('NOME').AsString;
          Result := Result + TAspEncode.AspIntToHex(IdMP, 4) + Nome + TAB;
        end;

        Next;
      end;

      Result := TAspEncode.AspIntToHex(I, 4) + Result;
    end; { with cds }
  finally
    FreeAndNil(aCDSPausaFiltro);
  end;
end;

procedure TfrmSicsMain.GetSendStatusDasPAsTableText(var S: string);
var
  ID  : Integer;
  Nome: string;
  BM  : TBookmark;
  I   : Integer;
begin
  with dmSicsMain.cdsStatusDasPAs do
  begin
    BM := GetBookmark;
    I  := 0;
    S  := '';
    try
      try
      First;
      while not Eof do
      begin
        I    := I + 1;
        ID   := FieldByName('ID').AsInteger;
        Nome := FieldByName('NOME').AsString;
        S    := S + TAspEncode.AspIntToHex(ID, 4) + Nome + TAB;

        Next;
      end;

      S := TAspEncode.AspIntToHex(I, 4) + S;

      finally
        if BookmarkValid(BM) then
          GotoBookmark(BM);
      end;
    finally
      FreeBookmark(BM);
    end;
  end; { with cds }
end;   { proc GetSendStatusDasPAsTableText }

procedure TfrmSicsMain.GetSendGruposNamesText(const aTipoGroupoPorModulo: TTipoGrupoPorModulo; var S: string);
var
  IdGrupo : Integer;
  Nome    : string;
  BM      : TBookmark;
  cds     : TClientDataSet;
begin
  TfrmDebugParameters.Debugar(tbProtocoloSics, 'Entrou GetSendGruposNamesText. IdModulo: ' + IntToStr(Ord(aTipoGroupoPorModulo.TipoDeGrupo)));
  S := '';

  case aTipoGroupoPorModulo.TipoDeGrupo of
    tgPA    : cds := dmSicsMain.cdsGruposDePAs;
    tgAtd   : cds := dmSicsMain.cdsGruposDeAtendentes;
    tgTAG   : cds := dmSicsMain.cdsGruposDeTags;
    tgPP    : cds := dmSicsMain.cdsGruposDePPs;
    tgPausa : cds := dmSicsMain.cdsGruposDeMotivosPausa;
    tgFila  : cds := dmSicsMain.cdsFilas;
  else
    Exit;
  end;

  dmSicsMain.cdsFiltroGrupos.CloneCursor(cds, false, True);
  FiltraDataSetComPermitidas(dmSicsMain.connOnLine, dmSicsMain.cdsFiltroGrupos, aTipoGroupoPorModulo.IdModulo, aTipoGroupoPorModulo.TipoDeGrupo);
  cds := dmSicsMain.cdsFiltroGrupos;

  with cds do
  begin
    BM := GetBookmark;
    try
      try
        First;
        while not Eof do
        begin
          if (aTipoGroupoPorModulo.TipoDeGrupo <> tgTAG) or (FieldByName('ATIVO').AsBoolean) then
          begin
            IdGrupo := FieldByName('ID').AsInteger;
            Nome    := FieldByName('NOME').AsString;
            S       := S + TAspEncode.AspIntToHex(IdGrupo, 4) + Nome + TAB;
          end;

          Next;
        end;

        S := TAspEncode.AspIntToHex(RecordCount, 4) + S;
      finally
        if BookmarkValid(BM) then
          GotoBookmark(BM)
      end;
    finally;
      FreeBookmark(BM);
    end;
  end; { with cds }

  TfrmDebugParameters.Debugar(tbProtocoloSics, 'Saiu GetSendGruposNamesText. IdModulo: ' + IntToStr(Ord(aTipoGroupoPorModulo.TipoDeGrupo)));
end;   { proc GetSendGruposNamesText }

procedure TfrmSicsMain.AtualizaLEDsDasBotoeiras3B2L(PAsString, ESPString: string);
const
  MaxBytesParaBotoeira3B2L = 8;
var
  I, PA, NPSWD   : Integer;
  aux, aux2, Pswd: string;
  Botoeiras3B2L  : array [0 .. MaxBytesParaBotoeira3B2L - 1] of byte;
begin
  if vlUsarBotoeiras3B2L then
  begin
    for I              := 0 to MaxBytesParaBotoeira3B2L - 1 do
      Botoeiras3B2L[I] := 0;

    // atualiza os LEDs das botoeiras referentes `as PAs estarem em atendimento
    aux   := Copy(PAsString, 5, Length(PAsString) - 4); // corta os 04 primeiros bytes referentes a qtd de PAs
    aux2  := '';
    for I := 1 to Length(aux) do
    begin
      if aux[I] = TAB then
      begin
        PA   := StrToInt('$' + Copy(aux2, 1, 4));
        Pswd := Copy(aux2, 23, Length(aux2) - 22);

        if Pswd <> '---' then
          Botoeiras3B2L[(PA - 1) div 4] := Botoeiras3B2L[(PA - 1) div 4] or Eleva(2, (((PA - 1) mod 4) * 2));

        aux2 := '';
      end
      else
        aux2 := aux2 + aux[I];
    end;

    // atualiza os LEDs das botoeiras referentes as existir fila para as PAs
    aux   := Copy(ESPString, 5, Length(ESPString) - 4);
    aux2  := '';
    for I := 1 to Length(aux) do
    begin
      if aux[I] = TAB then
      begin
        PA    := StrToInt('$' + Copy(aux2, 1, 4));
        NPSWD := StrToInt('$' + Copy(aux2, 5, 4));

        if NPSWD <> 0 then
          Botoeiras3B2L[(PA - 1) div 4] := Botoeiras3B2L[(PA - 1) div 4] or Eleva(2, (((PA - 1) mod 4) * 2) + 1);

        aux2 := '';
      end
      else
        aux2 := aux2 + aux[I];
    end;

    aux   := '!00L01';
    for I := 0 to MaxBytesParaBotoeira3B2L - 1 do
      aux := aux + Chr(Botoeiras3B2L[I]);
    aux   := aux + '$';

    Botoeiras3B2LPort.WriteText(AspStringToAnsiString(aux));
  end; { if USARBOTOEIRAS3B2L }
end;{ proc AtualizaLEDsDasBotoeiras3B2L }

procedure TfrmSicsMain.AtualizarAgendamentoFilas;
begin
  cdsIdsTicketsAgendamentosFilas.Close;
  cdsIdsTicketsAgendamentosFilas.ParamByName('ID_UNIDADE').AsInteger := vgParametrosModulo.IdUnidade;
  cdsIdsTicketsAgendamentosFilas.Open;
end;

function TfrmSicsMain.AtualizarContadoresDeFilas(pFila: Integer): Boolean;
begin
  dmSicsMain.cdsContadoresDeFilas.Close;
  dmSicsMain.cdsContadoresDeFilas.ParamByName('ID').AsInteger := pFila;
  dmSicsMain.cdsContadoresDeFilas.Open;

  Result := not dmSicsMain.cdsContadoresDeFilas.IsEmpty;
end;

procedure TfrmSicsMain.AtualizarIDsTickets;
begin
//  cdsIdsTickets.Close;
//  cdsIdsTickets.ParamByName('ID_UNIDADE').AsInteger := vgParametrosModulo.IdUnidade;
//  cdsIdsTickets.Open;
end;

procedure TfrmSicsMain.AtualizarIDsTicketsTags;
begin
  cdsIdsTicketsTags.Close;
  cdsIdsTicketsTags.ParamByName('ID_UNIDADE').AsInteger := vgParametrosModulo.IdUnidade;
  cdsIdsTicketsTags.Open;
end;

procedure TfrmSicsMain.AtualizarProcessoParalelo;
begin
  frmSicsProcessosParalelos.cdsPPs.Close;
  frmSicsProcessosParalelos.cdsPPs.ParamByName('ID_UNIDADE').AsInteger := vgParametrosModulo.IdUnidade;
  frmSicsProcessosParalelos.cdsPPs.Open;
end;

{ ------------------------------------------------------------ }
{ procedures de Carregamento/Salvamento de dados em arquivos }

procedure TfrmSicsMain.LoadPswds;
var
  //arq : TWaitingPswdFile;
  //arq2: file of Integer;
  //arq4       : TRegistroDePPFile;
  //WaitingPswd: TWaitingPswd;
  //RegistroDePP: TRegistroDePP;
  //arqname     : string;
  //Tags        : TIntArray; // RAP
  //Grupo       : String;    // RAP
  //ID, contador: Integer;

  i, ID: Integer;
  SG   : TStringGrid;
begin
  //RA
  {$REGION 'Código anterior comentado - Leitura do arquivo .DAT'}
  (*
//  arqname := vgParametrosModulo.PathRT + 'PSWDSIDS.DAT';
  if FileExists(arqname) then
  begin
    cdsIdsTickets.LoadFromFile(arqname);
    cdsIdsTickets.LogChanges := false;
  end;

//  arqname := vgParametrosModulo.PathRT + 'TAGS.DAT';
  if FileExists(arqname) then
  begin
    cdsIdsTicketsTags.LoadFromFile(arqname);
    cdsIdsTicketsTags.LogChanges := false;
  end;

//  arqname := vgParametrosModulo.PathRT + 'AGENDAMENTOS_FILAS.DAT';
  if FileExists(arqname) then
  begin
    cdsIdsTicketsAgendamentosFilas.LoadFromFile(arqname);
    cdsIdsTicketsAgendamentosFilas.LogChanges := false;
  end;
  *)
  {$ENDREGION}

  TfrmDebugParameters.Debugar(tbCarregarSenhas, 'Entrou LoadPswds');

  AtualizarIDsTickets;
  AtualizarIDsTicketsTags;
  AtualizarAgendamentoFilas;

  TfrmDebugParameters.Debugar(tbCarregarSenhas, 'LoadPswds - Vai varrer as filas para popular StringGrids e atualizar labels de quantidades de senhas em cada fila...');
  dmSicsMain.cdsFilas.First;
  while not dmSicsMain.cdsFilas.Eof do
  begin
    if dmSicsMain.cdsFilas.FieldByName('Ativo').AsBoolean then
    begin
      ID := dmSicsMain.cdsFilas.FieldByName('ID').AsInteger;

      SG := frmSicsMain.FindComponent('SenhasList' + IntToStr(ID)) as TStringGrid;
      if SG <> nil then
      begin
        SG.RowCount      := 2;
        for I            := 0 to SG.ColCount - 1 do
          SG.Cells[I, 1] := '';

        //RA
        {$REGION 'Código anterior comentado - Leitura do arquivo .DAT de Filas'}
        (*
//        arqname := vgParametrosModulo.PathRT + 'PSWD' + IntToStr(ID) + '.DAT';
        if FileExists(arqname) then
        begin
          AssignFile(arq, arqname);
          reset(arq);
          try
            while not Eof(arq) do
            begin
              Read(arq, WaitingPswd);

              with SG do
              begin
                if ((RowCount > 2) or (Cells[COL_SENHA, 1] <> '')) then
                  RowCount := RowCount + 1;

                for I                    := 0 to ColCount - 1 do
                  Cells[I, RowCount - 1] := '';

                Cells[COL_SENHA, RowCount - 1]    := IntToStr(WaitingPswd.TicketNumber);
                Cells[COL_HORA, RowCount - 1]     := FormatDateTime('hh:nn:ss', WaitingPswd.PswdDateTime);
                Cells[COL_DATAHORA, RowCount - 1] := FormatDateTime('dd/mm/yyyy  hh:nn:ss', WaitingPswd.PswdDateTime);
                Cells[COL_NOME, RowCount - 1]     := GetNomeParaSenha(WaitingPswd.TicketNumber);

                for i := 0 to fMaxTags -1 do
                begin
                  Cells[COL_PRIMEIRA_TAG + i, RowCount - 1] := '';
                end;

                Tags         := GetTagsTicket(WaitingPswd.TicketNumber);
                for contador := Low(Tags) to High(Tags) do
                begin
                  if dmSicsMain.cdsTags.Locate('ID', Tags[contador], [loCaseInsensitive]) then
                  begin
                    Grupo        := '';
                    if dmSicsMain.cdsGruposDeTags.Locate('ID', dmSicsMain.cdsTags.FieldByName('ID_GRUPOTAG').AsInteger, [loCaseInsensitive]) then
                      Grupo := dmSicsMain.cdsGruposDeTags.FieldByName('Nome').AsString + ' - ';

                    Cells[ObtemColunaDaTag(dmSicsMain.cdsTags.FieldByName('ID_GRUPOTAG').AsInteger), RowCount - 1] := IntToStr(dmSicsMain.cdsTags.FieldByName('ID').AsInteger) + ';' + IntToStr(dmSicsMain.cdsTags.FieldByName('CODIGOCOR').AsInteger) + ';' + Grupo +
                      dmSicsMain.cdsTags.FieldByName('NOME').AsString
                  end
                  else
                    Cells[ObtemColunaDaTag(dmSicsMain.cdsTags.FieldByName('ID_GRUPOTAG').AsInteger), RowCount - 1] := '';
                end;

                Row := RowCount - 1;
                Col := 0;
              end; { with PswdsList }
            end;   { while not eof(arq) }
          finally
            CloseFile(arq);
            AtualizaSenhaCountLabel(ID);
          end; { try .. finally }
        end;   { if FileExists }
        *)
        {$ENDREGION}

        PopularStringGridFilas(SG, ID);
        AtualizaSenhaCountLabel(ID);
      end;     { if SenhasList <> nil }
    end;

    dmSicsMain.cdsFilas.Next;
  end; { while not eof }
  TfrmDebugParameters.Debugar(tbCarregarSenhas, 'LoadPswds - Varreu e populou.');

  //RA
  {$REGION 'Código anterior comentado - Leitura do arquivo COUNTERS.DAT'}
  (*
//  arqname := vgParametrosModulo.PathRT + 'COUNTERS.DAT';
  if FileExists(arqname) then
  begin
    AssignFile(arq2, arqname);
    reset(arq2);
    try
      while not Eof(arq2) do
      begin
        read(arq2, ID);
        read(arq2, contador);
        if dmSicsMain.cdsFilas.Locate('ID', ID, []) then
        begin
          dmSicsMain.cdsContadoresDeFilas.Edit;
          dmSicsMain.cdsContadoresDeFilas.FieldByName('CONTADOR').AsInteger := contador;
          dmSicsMain.cdsContadoresDeFilas.Post;
        end;
      end;
    finally
      CloseFile(arq2);
    end; { try .. finally }
  end;   { if FileExists (Counters) }

  dmSicsMain.cdsFilas.First;

  while not dmSicsMain.cdsFilas.Eof do
  begin
    if (dmSicsMain.cdsContadoresDeFilas.FieldByName('CONTADOR').AsInteger < dmSicsMain.cdsFilas.FieldByName('RANGEMINIMO').AsInteger) or
       (dmSicsMain.cdsContadoresDeFilas.FieldByName('CONTADOR').AsInteger > dmSicsMain.cdsFilas.FieldByName('RANGEMAXIMO').AsInteger) then
    begin
      dmSicsMain.cdsContadoresDeFilas.Edit;
      dmSicsMain.cdsContadoresDeFilas.FieldByName('CONTADOR').AsInteger := dmSicsMain.cdsFilas.FieldByName('RANGEMINIMO').AsInteger;
      dmSicsMain.cdsContadoresDeFilas.Post;
    end;
    dmSicsMain.cdsFilas.Next;
  end;
  *)
  {$ENDREGION}

  //RA
  //arqname := vgParametrosModulo.PathRT + 'ATEND_PAs.DAT';
  //CarregarDadosDatasetPA(arqname);
  //arqname := vgParametrosModulo.PathRT + 'ATEND_ATDs.DAT';
  //CarregarDadosDatasetAtendentes(arqname);

  //RA
  {$REGION 'Código anterior comentado - Carregamento do arquivo PPs.DAT'}
  (*
//  arqname := vgParametrosModulo.PathRT + 'PPs.DAT';
  if FileExists(arqname) then
  begin
    AssignFile(arq4, arqname);
    reset(arq4);
    try
      while not Eof(arq4) do
      begin
        Read(arq4, RegistroDePP);
        with frmSicsProcessosParalelos.cdsPPs do
        begin
          Append;

          FieldByName('ID_EventoPP').AsInteger  := RegistroDePP.EventoPP;
          FieldByName('ID_TipoPP').AsInteger    := RegistroDePP.TipoPP;
          FieldByName('ID_PA').AsInteger        := RegistroDePP.PA;
          FieldByName('ID_ATD').AsInteger       := RegistroDePP.ATD;
          FieldByName('TicketNumber').AsInteger := RegistroDePP.TicketNumber;
          FieldByName('Horario').AsDateTime     := RegistroDePP.Horario;
          FieldByName('NomeCliente').AsString   := GetNomeParaSenha(RegistroDePP.TicketNumber);

          Post;
        end;
      end; { while }
    finally
      CloseFile(arq4);
    end; { try .. finally }
  end;   { if FileExists (Counters) }
  *)
  {$ENDREGION}

  AtualizarProcessoParalelo;

  TfrmDebugParameters.Debugar(tbCarregarSenhas, 'Saiu LoadPswds');
end; { proc LoadPswds }

procedure TfrmSicsMain.SalvaSituacao_Fila(ID: Integer);
var
  arq                           : TWaitingPswdFile;
  WaitingPswd                   : TWaitingPswd;
  arqname, aux, aux2, aux3, aux4: string;
  I                             : Integer;
begin
  if (dmSicsContingencia.TipoFuncionamento = tfContingente) and (not dmSicsContingencia.ContingenciaAtivo) then
  begin
    // quando esta no modo contingente nao ativo, significa que o servidor esta inoperante
    // apenas recebendo as replicacoes e os grids nao sao atualizados,
    // portanto, ao sair nao deixo gravar, senao atualizara os dats incorretamente
    Exit;
  end;

  TfrmDebugParameters.Debugar(tbAlocacaoDeSenhasNasFilas, 'Entrou SalvaSituacao_Fila');

  dmSicsContingencia.CheckGerarNovoRTId;
  TfrmDebugParameters.Debugar(tbAlocacaoDeSenhasNasFilas, 'GerouNovoRTId');

  //RA
  {$REGION 'As filas são persistidas em banco, não mais necessário salvar arquivo DAT'}
  (*
//  arqname := vgParametrosModulo.PathRT + 'PSWD' + IntToStr(ID) + '.DAT';
  AssignFile(arq, arqname);
  rewrite(arq);
  try
    if frmSicsMain.FindComponent('SenhasList' + IntToStr(ID)) <> nil then
      with frmSicsMain.FindComponent('SenhasList' + IntToStr(ID)) as TStringGrid do
        for I := 1 to RowCount - 1 do
        begin
          if Cells[COL_SENHA, I] <> '' then
          begin
            WaitingPswd.TicketNumber := StrToInt(Cells[COL_SENHA, I]);
            WaitingPswd.PswdDateTime := StrToDateTime(Cells[COL_DATAHORA, I]);
            Write(arq, WaitingPswd);
          end; { if Cells[COL_SENHA,i] <> '' then }
        end;   { for i }
  finally
    CloseFile(arq);
  end; { try .. finally }
  *)
  {$ENDREGION}

  if frmSicsMain.FindComponent('SenhasList' + IntToStr(ID)) <> nil then
  begin
    with frmSicsMain.FindComponent('SenhasList' + IntToStr(ID)) as TStringGrid do
    begin
      for I := 1 to RowCount - 1 do
      begin

      end;
    end;
  end;

  TfrmDebugParameters.Debugar(tbAlocacaoDeSenhasNasFilas, 'Montando strings para enviar aos clients...');
  GetSendOneFilaText(ID, aux);
  GetSendWaitingPswdsText(aux3);
  GetSendOneFilaDetailedSituationText(ID, aux4);
  TfrmDebugParameters.Debugar(tbAlocacaoDeSenhasNasFilas, 'Strings montadas.');

  TfrmDebugParameters.Debugar(tbAlocacaoDeSenhasNasFilas, '"SalvaSituacao_Fila" enviará para todos os clients TGS/OnLine');
  EnviaParaTodosOsClients(TGSServerSocket.Socket, '0000' + Chr($35) + aux);
  EnviaParaTodosOsClients(TGSServerSocket.Socket, '0000' + Chr($6D) + aux4);
  TfrmDebugParameters.Debugar(tbAlocacaoDeSenhasNasFilas, '"SalvaSituacao_Fila" enviou para todos');

  TfrmDebugParameters.Debugar(tbAlocacaoDeSenhasNasFilas, '"SalvaSituacao_Fila" enviará para todos os clients PA/MPA');
  EnviaParaTodosOsClients(ServerSocket1.Socket, '0000' + Chr($3B) + aux3);
  TfrmDebugParameters.Debugar(tbAlocacaoDeSenhasNasFilas, '"SalvaSituacao_Fila" enviou para todos');

  if vlUsarBotoeiras3B2L then
    AtualizaLEDsDasBotoeiras3B2L(aux2, aux3);

  dmSicsContingencia.CheckReplicarArquivosRealTimeP2C;

  if not vlDesabilitarBipes then
    MessageBeep(MB_ICONASTERISK);

  TfrmDebugParameters.Debugar(tbAlocacaoDeSenhasNasFilas, 'Saiu   SalvaSituacao_Fila');
end;
{ proc SalvaSituacao_Fila }

procedure TfrmSicsMain.SalvaSituacao_Counters;
//var
//  arq2   : file of Integer;
//  arqname: string;
//  I      : Integer;
//  BM     : TBookmark;
begin
  if (dmSicsContingencia.TipoFuncionamento = tfContingente) and (not dmSicsContingencia.ContingenciaAtivo) then
  begin
    // quando esta no modo contingente nao ativo, significa que o servidor esta inoperante
    // apenas recebendo as replicacoes e os grids nao sao atualizados,
    // portanto, ao sair nao deixo gravar, senao atualizara os dats incorretamente
    Exit;
  end;

  {$REGION 'Código anterior comentado'}
  (*
//  if not ForceDirectories(vgParametrosModulo.PathRT) then
    Application.MessageBox('Erro ao salvar situação em tempo real.', 'Erro', MB_ICONSTOP)
  else
  begin
    dmSicsContingencia.CheckGerarNovoRTId;

    BM := dmSicsMain.cdsFilas.GetBookmark;
    try
      try
//      arqname := vgParametrosModulo.PathRT + 'COUNTERS.DAT';
      AssignFile(arq2, arqname);
      rewrite(arq2);
      try
        dmSicsMain.cdsFilas.First;
        while not dmSicsMain.cdsFilas.Eof do
        begin
          if dmSicsMain.cdsFilas.FieldByName('Ativo').AsBoolean then
          begin
            I := dmSicsMain.cdsFilas.FieldByName('ID').AsInteger;
            Write(arq2, I);
            I := dmSicsMain.cdsContadoresDeFilas.FieldByName('CONTADOR').AsInteger;
            Write(arq2, I);
          end;
          dmSicsMain.cdsFilas.Next;
        end;
      finally
        CloseFile(arq2);
      end; { try .. finally (counters) }
      finally
        if dmSicsMain.cdsFilas.BookmarkValid(BM) then
           dmSicsMain.cdsFilas.GotoBookmark(BM);
      end;
    finally
      dmSicsMain.cdsFilas.FreeBookmark(BM);
    end;
  end;
  *)
  {$ENDREGION}
end;
{ proc SalvaSituacao_Counters }

procedure TfrmSicsMain.SalvaSituacao_Atendimento;
var
  arqname, aux2, aux3: string;

//  procedure gravaArquivoRT(nomeArq : string; cds : TClientDataSet);
//    var
//      dataHora : TDateTime;
//      novoNome : string;
//      qtdeAtual, qtdeBackup : integer;
//  begin
//    dataHora := now;
//    try
//      if not FileExists(vgParametrosModulo.PathRT +nomeArq+'.DAT') then
//        cds.SaveToFile(vgParametrosModulo.PathRT + nomeArq + '.DAT');
//
//      cdsTmp.LoadFromFile(vgParametrosModulo.PathRT +nomeArq+'.DAT');
//      qtdeBackup := cdsTmp.RecordCount;
//      qtdeAtual := cds.RecordCount;
//      if(qtdeBackup <> qtdeAtual)then
//      begin
//        novoNome := nomeArq +'_'+FormatDateTime('yyyymmddhhnnss',dataHora);
//        cdsTmp.SaveToFile(vgParametrosModulo.PathRT +novoNome+ '.DAT');
//        MyLogException(ERegistroDeOperacao.Create('Feito backup do arquivo '+nomeArq+'(renomeado para '+novoNome+'). Houve diferença de quantidade de dados, backup = '+ inttostr(qtdeBackup) +' e atual = '+IntToStr(qtdeAtual)));
//      end;
//    finally
//     cdsTmp.Close;
//     cds.SaveToFile(vgParametrosModulo.PathRT + nomeArq + '.DAT');
//    end;
//
//  end;
begin
  if (dmSicsContingencia.TipoFuncionamento = tfContingente) and (not dmSicsContingencia.ContingenciaAtivo) then
  begin
    // quando esta no modo contingente nao ativo, significa que o servidor esta inoperante
    // apenas recebendo as replicacoes e os grids nao sao atualizados,
    // portanto, ao sair nao deixo gravar, senao atualizara os dats incorretamente
    Exit;
  end;

  dmSicsContingencia.CheckGerarNovoRTId;

  //RA
  {$REGION 'Código anterior comentado'}
  //gravaArquivoRT('ATEND_PAs',frmSicsSituacaoAtendimento.cdsPAs);  //vgParametrosModulo.PathRT + 'ATEND_PAs.DAT';
  //gravaArquivoRT('ATEND_ATDs',frmSicsSituacaoAtendimento.cdsAtds);
  {$ENDREGION}

  if frmSicsSituacaoAtendimento.cdsAtds.ChangeCount > 0 then
  begin
    frmSicsSituacaoAtendimento.cdsAtds.ApplyUpdates(0);
  end;

  if frmSicsSituacaoAtendimento.cdsPAs.ChangeCount > 0 then
  begin
    frmSicsSituacaoAtendimento.cdsPAs.ApplyUpdates(0);
  end;

  //frmSicsSituacaoAtendimento.cdsPAs.SaveToFile(arqname);
  //arqname := vgParametrosModulo.PathRT + 'ATEND_ATDs.DAT';
  //frmSicsSituacaoAtendimento.cdsAtds.SaveToFile(arqname);

  if vlUsarBotoeiras3B2L then
    AtualizaLEDsDasBotoeiras3B2L(aux2, aux3);

  dmSicsContingencia.CheckReplicarArquivosRealTimeP2C;

  if not vlDesabilitarBipes then
    MessageBeep(MB_ICONASTERISK);
end; { proc SalvaSituacao_Atendimento }

procedure TfrmSicsMain.SalvaSituacao_PPs;
var
  arq3         : TRegistroDePPFile;
  RegistroDePP : TRegistroDePP;
  aux2, arqname: string;
begin
  if (dmSicsContingencia.TipoFuncionamento = tfContingente) and (not dmSicsContingencia.ContingenciaAtivo) then
  begin
    // quando esta no modo contingente nao ativo, significa que o servidor esta inoperante
    // apenas recebendo as replicacoes e os grids nao sao atualizados,
    // portanto, ao sair nao deixo gravar, senao atualizara os dats incorretamente
    Exit;
  end;

  dmSicsContingencia.CheckGerarNovoRTId;

//  arqname := vgParametrosModulo.PathRT + 'PPs.DAT';
//  AssignFile(arq3, arqname);
//  rewrite(arq3);
//  try
//    with frmSicsProcessosParalelos.cdsClonePPs do
//    begin
//      First;
//      while not Eof do
//      begin
//        RegistroDePP.EventoPP     := FieldByName('Id_EventoPP').AsInteger;
//        RegistroDePP.TipoPP       := FieldByName('Id_TipoPP').AsInteger;
//        RegistroDePP.PA           := FieldByName('Id_PA').AsInteger;
//        RegistroDePP.ATD          := FieldByName('Id_ATD').AsInteger;
//        RegistroDePP.TicketNumber := FieldByName('TicketNumber').AsInteger;
//        RegistroDePP.Horario      := FieldByName('HORARIO').AsDateTime;
//
//        Write(arq3, RegistroDePP);
//
//        Next;
//      end;
//    end; // with cds
//  finally
//    CloseFile(arq3);
//  end; { try .. finally }

  if frmSicsProcessosParalelos.cdsPPs.ChangeCount > 0 then
  begin
    frmSicsProcessosParalelos.cdsPPs.ApplyUpdates(0);
  end;

  GetSendPPsSituationText(-1, aux2);

  EnviaParaTodosOsClients(TGSServerSocket.Socket, '0000' + Chr($59) + aux2);

  dmSicsContingencia.CheckReplicarArquivosRealTimeP2C;

  if not vlDesabilitarBipes then
    MessageBeep(MB_ICONASTERISK);
end; { proc SalvaSituacao_PPs }

procedure TfrmSicsMain.SalvaSituacao_Tickets;
var
  arqname: string;
begin
  if (dmSicsContingencia.TipoFuncionamento = tfContingente) and (not dmSicsContingencia.ContingenciaAtivo) then
  begin
    // quando esta no modo contingente nao ativo, significa que o servidor esta inoperante
    // apenas recebendo as replicacoes e os grids nao sao atualizados,
    // portanto, ao sair nao deixo gravar, senao atualizara os dats incorretamente
    Exit;
  end;

  dmSicsContingencia.CheckGerarNovoRTId;

  {$REGION 'Código anterior comentado - Gravação do arquivo .DAT de Filas'}
  (*
  cdsIdsTickets.LogChanges := False;

//  arqname := vgParametrosModulo.PathRT + 'PSWDSIDS.DAT';
  cdsIdsTickets.SaveToFile(arqname);
  *)
  {$ENDREGION}

  dmSicsContingencia.CheckReplicarArquivosRealTimeP2C;
end; { proc SalvaSituacao_Tickets }

procedure TfrmSicsMain.SalvaUltimaPAModoTerminalServer(idModulo, idPA: integer);
begin
  if(dmSicsMain.cdsSicsPA.State in [TDataSetState.dsInactive])then
      dmSicsMain.cdsSicsPA.Open;

  with dmSicsMain.cdsSicsPA do
  begin
    if(Locate('ID',inttostr(idModulo),[]))then
    begin
      if((FieldByName('ID_PA').AsInteger <> idPA) and (FieldByName('MODO_TERMINAL_SERVER').AsString = 'T'))then
      begin
        if not (State in [TDataSetState.dsInsert,TDataSetState.dsEdit])then
          Edit;

        FieldByName('ID_PA').AsInteger := idPA;

        Post;
        ApplyUpdates(0);
      end;
    end;
  end;
end;

procedure TfrmSicsMain.LoadTotens;
var
  IniFile            : TIniFile;
  I, j               : Integer;
  iQtdeBotoes        : Integer;
  Mudou              : Boolean;
  TipoDaImpressoraINI: TTipoDeImpressora;
  tmp: Integer;
begin
  for I := 1 to cgMaxTotens do
  begin

    vlTotens[I].IP                                    := '';
    for j                                             := 0 to cgMaxBotoesDoTotem - 1 do
      vlTotens[I].Botoes[j]                           := 0;
    vlTotens[I].StatusTotem                           := [];
    vlTotens[I].StatusSocket                          := ssIdle;
    vlTotens[I].KeepAliveTimeout                      := 2;
    vlTotens[I].IdModeloTotem                         := TOTEM_MODELO_6_BOTOES;
    vlTotens[I].TipoImpressora                        := tiMecaf;
    vlTotens[I].Opcoes.PicoteEntreVias                := True;
    vlTotens[I].Opcoes.CorteParcialAoFinal            := false;
    vlTotens[I].Opcoes.ImprimirCodigoDeBarrasSenha    := false;
    vlTotens[I].Opcoes.ImprimirDataEHoraNaSegundaVia  := True;
    vlTotens[I].Opcoes.ImprimirNomeDaFilaNaSegundaVia := false;
  end;

  IniFile := TIniFile.Create(GetIniFileName);
  with IniFile do
    try
      { para compatibilidade com versões anteriores: }
      if SectionExists('Totens') then
      begin
        with dmSicsMain.cdsTotens do
        begin
          if not Active then
            Open
          else
            Refresh;

          while not IsEmpty do
            Delete;

          I := 1;
          while I <= cgMaxTotens do
          begin
            vlTotens[I].IP := ShortString(ReadString('Totens', 'Totem' + IntToStr(I) + 'IP', ''));

            if vlTotens[I].IP <> '' then
            begin
              Append;
              FieldByName('ID').AsInteger := TGenerator.NGetNextGenerator('GEN_ID_TOTEM', dmSicsMain.connOnLine);
              FieldByName('IP').AsString  := string(vlTotens[I].IP);
              iQtdeBotoes                 := 0;
              for j                       := 0 to cgMaxBotoesDoTotem - 1 do
              begin
                vlTotens[I].Botoes[j] := ReadInteger('Totens', 'Totem' + IntToStr(I) + 'Botao' + IntToStr(j), 0);
                if vlTotens[I].Botoes[j] <> 0 then
                begin
                  Inc(iQtdeBotoes);
                  FieldByName('IDFILA_BOTAO' + IntToStr(j + 1)).AsInteger := vlTotens[I].Botoes[j];
                end;
              end;
              if iQtdeBotoes <= 6 then
                FieldByName('ID_MODELOTOTEM').AsInteger := TOTEM_MODELO_6_BOTOES
              else
                FieldByName('ID_MODELOTOTEM').AsInteger := TOTEM_MODELO_8_BOTOES;

              FieldByName('OPCOES_PICOTEENTREVIAS').AsBoolean := True;
              FieldByName('OPCOES_CORTEPARCIALAOFINAL').AsBoolean := false;
              FieldByName('OPCOES_CDBSENHAS').AsBoolean       := false;
              FieldByName('OPCOES_DATAHORANA2AVIA').AsBoolean := True;

              Post;
            end;

            I := I + 1;
          end;

          if ApplyUpdates(0) <> 0 then
            CancelUpdates
          else
            EraseSection('Totens');
        end;
      end
      else
      begin
        with dmSicsMain.cdsTotens do
        begin
          if not Active then
            Open
          else
            Refresh;

          First;
          while not Eof do
          begin
            I := FieldByName('ID').AsInteger;
            if (I >= Low(vlTotens)) and (I <= High(vlTotens)) then
            begin
              vlTotens[I].IP := ShortString(FieldByName('IP').AsString);
              for j := 0 to cgMaxBotoesDoTotem - 1 do
                vlTotens[I].Botoes[j] := FieldByName('IDFILA_BOTAO' + IntToStr(j + 1)).AsInteger;
            end;
            Next;
          end;
        end;
      end;

      // Para conversão de modelos de totem e tirar do INI o modelo da impressora
      TipoDaImpressoraINI := tiBematech;
      with dmSicsMain.cdsTotens do
      begin
        if not Active then
          Open
        else
          Refresh;

        Mudou := false;
        First;
        while not Eof do
        begin
          if FieldByName('ID_MODELOTOTEM').AsInteger in [TOTEM_MODELO_6_BOTOES, TOTEM_MODELO_8_BOTOES, TOTEM_MODELO_TOUCH, TOTEM_MODELO_IMPRESSORA] then
          begin
            Mudou := True;
            Edit;
            case FieldByName('ID_MODELOTOTEM').AsInteger of
              TOTEM_MODELO_6_BOTOES  : FieldByName('ID_MODELOTOTEM').AsInteger := TOTEM_MODELO_BALCAO;
              TOTEM_MODELO_8_BOTOES  : begin
                                         if TipoDaImpressoraINI = tiBematech then
                                           FieldByName('ID_MODELOTOTEM').AsInteger := TOTEM_MODELO_SILOUETE_BEMATECH
                                         else
                                           FieldByName('ID_MODELOTOTEM').AsInteger := TOTEM_MODELO_SILOUETE;
                                       end;
              TOTEM_MODELO_TOUCH     : begin
                                         if TipoDaImpressoraINI = tiZebra then
                                           FieldByName('ID_MODELOTOTEM').AsInteger := TOTEM_MODELO_TOUCH_ZEBRA
                                         else
                                           FieldByName('ID_MODELOTOTEM').AsInteger := TOTEM_MODELO_TOUCH_BALCAO_PAREDE;
                                       end;
              TOTEM_MODELO_IMPRESSORA: FieldByName('ID_MODELOTOTEM').AsInteger := TOTEM_MODELO_IMPRESSORA_BEMATECH;
            end;
            Post;
          end;

          Next;
        end; // while not eof

        if Mudou then
        begin
          if ApplyUpdates(0) <> 0 then
          begin
            CancelUpdates;
            MyLogException(Exception.Create('Erro ao atualizar modelos de totens.'));
          end
          else
            DeleteKey('Settings', 'TipoDaImpressora');
        end;
      end; // with cdsTotens
    finally
      Free;
    end; // with IniFile

  // Para preencher demais campos do Totem
  with dmSicsMain.cdsTotens do
  begin
    if not Active then
      Open
    else
      Refresh;

    First;
    while not Eof do
    begin
      I := FieldByName('ID').AsInteger;

      case FieldByName('ID_MODELOTOTEM').AsInteger of
        TOTEM_MODELO_BALCAO                         : vlTotens[I].TipoImpressora := tiMecaf;
        TOTEM_MODELO_SILOUETE                       : vlTotens[I].TipoImpressora := tiMecaf;
        TOTEM_MODELO_SILOUETE_BEMATECH              : vlTotens[I].TipoImpressora := tiBematech;
        TOTEM_MODELO_TOUCH_ZEBRA                    : vlTotens[I].TipoImpressora := tiZebra;
        TOTEM_MODELO_TOUCH_BALCAO_PAREDE            : vlTotens[I].TipoImpressora := tiFujitsu;
        TOTEM_MODELO_IMPRESSORA_BEMATECH            : vlTotens[I].TipoImpressora := tiBematech;
        TOTEM_MODELO_SILOUETE_TOUCH                 : vlTotens[I].TipoImpressora := tiSeiko;
        TOTEM_MODELO_ELGIN                          : vlTotens[I].TipoImpressora := tiCustom;
        TOTEM_MODELO_BALCAO_RAPIDO                  : vlTotens[I].TipoImpressora := tiSeiko;
        TOTEM_MODELO_SILOUETE_RAPIDO                : vlTotens[I].TipoImpressora := tiSeiko;
        TOTEM_MODELO_MULTITELAS                     : vlTotens[I].TipoImpressora := tiSeiko;
        TOTEM_MODELO_STANDALONE                     : vlTotens[I].TipoImpressora := tiSeiko;
        TOTEM_MODELO_SLIMBUTTON                     : vlTotens[I].TipoImpressora := tiSeiko;
        TOTEM_MODELO_SLIMTOUCH                      : vlTotens[I].TipoImpressora := tiSeiko;
        TOTEM_MODELO_TOUCH_BALCAO_PAREDE_MULTITELAS : vlTotens[I].TipoImpressora := tiFujitsu;
      end;

      vlTotens[I].IdModeloTotem                         := FieldByName('ID_MODELOTOTEM').AsInteger;
      vlTotens[I].Nome                                  := FieldByName('NOME').AsString;
      vlTotens[I].Modelo                                := ModelosTotens[FieldByName('ID_MODELOTOTEM').AsInteger].Nome;
      vlTotens[I].Opcoes.PicoteEntreVias                := FieldByName('OPCOES_PICOTEENTREVIAS').AsBoolean;
      vlTotens[I].Opcoes.CorteParcialAoFinal            := FieldByName('OPCOES_CORTEPARCIALAOFINAL').AsBoolean;
      vlTotens[I].Opcoes.ImprimirCodigoDeBarrasSenha    := FieldByName('OPCOES_CDBSENHAS').AsBoolean;
      vlTotens[I].Opcoes.ImprimirDataEHoraNaSegundaVia  := FieldByName('OPCOES_DATAHORANA2AVIA').AsBoolean;
      vlTotens[I].Opcoes.ImprimirNomeDaFilaNaSegundaVia := FieldByName('OPCOES_NOMEFILANA2AVIA').AsBoolean;


      Next;
    end;
  end; // with cdsTotens

  dmSicsMain.cdsTotens.First;
  ImpressoraDefault := dmSicsMain.cdsTotens.FieldByName('ID').AsInteger;

  SubMenuStatusDosTotens.Enabled := false;
  for I                          := 1 to cgMaxTotens do
    if vlTotens[I].IP <> '' then
    begin
      SubMenuStatusDosTotens.Enabled := True;
      break;
    end;
end;

procedure TfrmSicsMain.LoadTVs;
var LCountIPs, LCountTVs: Integer;
    LEnderecosIPS : TConexaoIPArray;
begin
  LCountTVs := 0;
  dmSicsMain.cdsPaineisClone.CloneCursor(dmSicsMain.cdsPaineis, True);
  dmSicsMain.cdsPaineisClone.First;
  while not dmSicsMain.cdsPaineisClone.Eof do
  begin
    if dmSicsMain.cdsPaineisClone.FieldByName('TCPIP').AsString.Trim <> EmptyStr then
    begin
      LEnderecosIPS := StrToConexaoIpArray(dmSicsMain.cdsPaineisClone.FieldByName('TCPIP').AsString);

      for LCountIPs := low(LEnderecosIPS) to high(LEnderecosIPS) do
      begin
        LCountTVs := (LCountTVs + 1);

        vlTVs[LCountTVs].IP := LEnderecosIPS[LCountIPs].EnderecoIP;

        if high(LEnderecosIPS) > 0 then
        begin
          vlTVs[LCountTVs].Nome := dmSicsMain.cdsPaineisClone.FieldByName('NOME').AsString + '-' + IntToStr(LCountTVs)
        end
        else
        begin
          vlTVs[LCountTVs].Nome := dmSicsMain.cdsPaineisClone.FieldByName('NOME').AsString;
        end;
      end;
      Finalize(LEnderecosIPS);
    end;

    dmSicsMain.cdsPaineisClone.Next;
  end;
  dmSicsMain.cdsPaineisClone.Close;
end;

{ ------------------------------------------------------------ }


procedure TfrmSicsMain.InicializaEsperaUltimosN(fila: Integer);
var
  i : integer;
  LSelect: String;
begin
  with TFDQuery.Create(Application) do
  try
    LSelect := Format('select {LIMIT(0, %d)}', [AQTDSenhas]);

    Connection := dmSicsMain.connOnLine;
    SQL.Text := LSelect + ' E.DURACAO_SEGUNDOS from EVENTOS E where (ID_UNIDADE = ' + vgParametrosModulo.IdUnidade.ToString +') AND ' +
      '(E.ID_TIPOEVENTO = 0) and (E.ID_FILAESPERA = :Fila) order by E.ID desc';
    ParamByName('Fila').AsInteger := fila;
    Open;
    while not eof do
    begin
      AtualizaEsperaUltimosN(fila, IncSecond(now, -FieldByName('DURACAO_SEGUNDOS').AsInteger));

      Next;
    end;
    Close;
  finally
    Free;
  end;
end;


procedure TfrmSicsMain.InicializaAtendimentoUltimos10(fila: Integer);
var
  i : integer;
  LSelect: String;
begin
  with TFDQuery.Create(Application) do
  try
    LSelect := Format('select {LIMIT(0, %d)}', [10]);



    Connection := dmSicsMain.connOnLine;
    SQL.Text := LSelect + ' E.DURACAO_SEGUNDOS from EVENTOS E where (ID_UNIDADE = ' + vgParametrosModulo.IdUnidade.ToString + ') AND ' +
      '(E.ID_TIPOEVENTO = 2) and (E.ID_FILAESPERA = :Fila) order by E.ID desc';
    ParamByName('Fila').AsInteger := fila;
    Open;
    while not eof do
    begin
      AtualizaAtendimentoUltimos10(fila, IncSecond(now, -FieldByName('DURACAO_SEGUNDOS').AsInteger));

      Next;
    end;
    Close;
  finally
    Free;
  end;
end;


procedure TfrmSicsMain.AtualizaEsperaUltimosN(fila: Integer; TIM: TDateTime);
begin
  // try finally para tratar error divison by zero
  try
    SysUtils.FormatSettings.ShortDateFormat := 'dd/mm/yyyy';
    SysUtils.FormatSettings.LongTimeFormat  := 'hh:nn:ss';
    (FindComponent('SomaEsperasUltimosN' + IntToStr(fila)) as TLabel).Caption := datetimetostr(StrToDateTime((FindComponent('SomaEsperasUltimosN' + IntToStr(fila)) as TLabel).Caption) + (now - TIM) - StrToDateTime((FindComponent('PrimeiraEsperaUltimosN' + IntToStr(fila)) as TLabel).Caption));

    (FindComponent('ListaEsperasUltimosN' + IntToStr(fila)) as TListBox).Items.Add(datetimetostr(now - TIM));

    (FindComponent('EsperaUltimosN' + IntToStr(fila)) as TLabel).Caption := datetimetostr(StrToDateTime((FindComponent('SomaEsperasUltimosN' + IntToStr(fila)) as TLabel).Caption) / (FindComponent('ListaEsperasUltimosN' + IntToStr(fila)) as TListBox).Count);

    if (FindComponent('ListaEsperasUltimosN' + IntToStr(fila)) as TListBox).Count >= AQTDSenhas then
    begin
      (FindComponent('PrimeiraEsperaUltimosN' + IntToStr(fila)) as TLabel).Caption := (FindComponent('ListaEsperasUltimosN' + IntToStr(fila)) as TListBox).Items[0];
      (FindComponent('ListaEsperasUltimosN' + IntToStr(fila)) as TListBox).Items.Delete(0);
    end;
  except
    on E: Exception do
      MyLogException(E);
  end;
end;


procedure TfrmSicsMain.AtualizaAtendimentoUltimos10(fila: Integer; TIM: TDateTime);
const
  Acumular = 10;
begin
  // try finally para tratar error divison by zero
  try
    SysUtils.FormatSettings.ShortDateFormat := 'dd/mm/yyyy';
    SysUtils.FormatSettings.LongTimeFormat  := 'hh:nn:ss';
    (FindComponent('SomaAtendimentosUltimos10' + IntToStr(fila)) as TLabel).Caption := datetimetostr(StrToDateTime((FindComponent('SomaAtendimentosUltimos10' + IntToStr(fila)) as TLabel).Caption) + (now - TIM) - StrToDateTime((FindComponent('PrimeiroAtendimentoUltimos10' + IntToStr(fila)) as TLabel).Caption));

    (FindComponent('ListaAtendimentosUltimos10' + IntToStr(fila)) as TListBox).Items.Add(datetimetostr(now - TIM));

    (FindComponent('AtendimentoUltimos10' + IntToStr(fila)) as TLabel).Caption := datetimetostr(StrToDateTime((FindComponent('SomaAtendimentosUltimos10' + IntToStr(fila)) as TLabel).Caption) / (FindComponent('ListaAtendimentosUltimos10' + IntToStr(fila)) as TListBox).Count);

    if (FindComponent('ListaAtendimentosUltimos10' + IntToStr(fila)) as TListBox).Count >= Acumular then
    begin
      (FindComponent('PrimeiroAtendimentoUltimos10' + IntToStr(fila)) as TLabel).Caption := (FindComponent('ListaAtendimentosUltimos10' + IntToStr(fila)) as TListBox).Items[0];
      (FindComponent('ListaAtendimentosUltimos10' + IntToStr(fila)) as TListBox).Items.Delete(0);
    end;
  except
    on E: Exception do
      MyLogException(E);
  end;
end;


function TfrmSicsMain.AtualizaGrupoAtendente(Nome: string): Boolean;
var
  BM    : TBookmark;
begin
  with dmSicsMain.cdsGruposDeAtendentes do
  begin
    BM := GetBookmark;
    try
      LogChanges                       := True;
      try
        try
          Edit;
          FieldByName('NOME').AsString     := Nome;
          Post;
          Result := ApplyUpdates(0) = 0;
        finally
          LogChanges := false;
        end;
      finally
        if BookmarkValid(BM) then
          GotoBookmark(BM);
      end;
    finally
      FreeBookmark(BM);
    end;
  end; { with cds }

end;

function TfrmSicsMain.CriaComponenteFila(FilaNo: Integer; FilaNome: string; ShowButton, ShowBlocked, ShowPriority: Boolean; Cor: Integer): Boolean;
var
  shape1                            : TShape;
  lbl1, lbl2, lbl3, lbl4, lbl5, lbl6: TLabel;
  list1                             : TListBox;
  btn1                              : TBitBtn;
  btn2                              : TButton;
  edt1                              : TEdit;
  chk1, chk2                        : TCheckBox;
  bvl1, bvl2                        : TBevel;
  SG                                : TStringGrid;
  I                                 : Integer; // RAP
begin
  try
    shape1 := TShape.Create(Self);
    with shape1 do
    begin
      Parent := Self;
      Left   := 10;
      Top    := 10;
      Name   := 'Shape' + IntToStr(FilaNo);
      if Cor <> 0 then
        Brush.Color := TColor(Cor)
      else
        Brush.Color := frmSicsMain.Color;
      Pen.Style     := psClear;
      Tag           := FilaNo;
    end;

    lbl1 := TLabel.Create(Self);
    with lbl1 do
    begin
      Parent      := Self;
      Left        := 10;
      Top         := 10;
      Name        := 'Label' + IntToStr(FilaNo);
      Caption     := 'Fila ' + IntToStr(FilaNo) + ':';
      Transparent := True;
      Tag         := FilaNo;
    end;

    lbl2 := TLabel.Create(Self);
    with lbl2 do
    begin
      Parent      := Self;
      Left        := 10;
      Top         := 10;
      Name        := 'SenhasCountLabel' + IntToStr(FilaNo);
      Caption     := '0';
      Alignment   := taRightJustify;
      Transparent := True;
      Tag         := FilaNo;
    end;

    lbl3 := TLabel.Create(Self);
    with lbl3 do
    begin
      Parent      := Self;
      Left        := 10;
      Top         := 10;
      Name        := 'FilaLabel' + IntToStr(FilaNo);
      Caption     := FilaNome;
      Alignment   := taCenter;
      Font.Style  := Font.Style + [fsBold];
      Transparent := True;
      Tag         := FilaNo;
    end;

    lbl4 := TLabel.Create(Self);
    with lbl4 do
    begin
      Parent      := Self;
      Left        := 10;
      Top         := 10;
      Name        := 'EsperaUltimosN' + IntToStr(FilaNo);
      Caption     := datetimetostr(0);
      Visible     := false;
      Transparent := True;
      Tag         := FilaNo;
    end;

    lbl5 := TLabel.Create(Self);
    with lbl5 do
    begin
      Parent      := Self;
      Left        := 10;
      Top         := 10;
      Name        := 'PrimeiraEsperaUltimosN' + IntToStr(FilaNo);
      Caption     := datetimetostr(0);
      Visible     := false;
      Transparent := True;
      Tag         := FilaNo;
    end;

    lbl6 := TLabel.Create(Self);
    with lbl6 do
    begin
      Parent      := Self;
      Left        := 10;
      Top         := 10;
      Name        := 'SomaEsperasUltimosN' + IntToStr(FilaNo);
      Caption     := datetimetostr(0);
      Visible     := false;
      Transparent := True;
      Tag         := FilaNo;
    end;

    list1 := TListBox.Create(Self);
    with list1 do
    begin
      Parent  := Self;
      Left    := 10;
      Top     := 10;
      Name    := 'ListaEsperasUltimosN'+ IntToStr(FilaNo);
      Visible := false;
      Tag     := FilaNo;
    end;

    lbl4 := TLabel.Create(Self);
    with lbl4 do
    begin
      Parent      := Self;
      Left        := 10;
      Top         := 10;
      Name        := 'AtendimentoUltimos10' + IntToStr(FilaNo);
      Caption     := datetimetostr(0);
      Visible     := false;
      Transparent := True;
      Tag         := FilaNo;
    end;

    lbl5 := TLabel.Create(Self);
    with lbl5 do
    begin
      Parent      := Self;
      Left        := 10;
      Top         := 10;
      Name        := 'PrimeiroAtendimentoUltimos10' + IntToStr(FilaNo);
      Caption     := datetimetostr(0);
      Visible     := false;
      Transparent := True;
      Tag         := FilaNo;
    end;

    lbl6 := TLabel.Create(Self);
    with lbl6 do
    begin
      Parent      := Self;
      Left        := 10;
      Top         := 10;
      Name        := 'SomaAtendimentosUltimos10' + IntToStr(FilaNo);
      Caption     := datetimetostr(0);
      Visible     := false;
      Transparent := True;
      Tag         := FilaNo;
    end;

    list1 := TListBox.Create(Self);
    with list1 do
    begin
      Parent  := Self;
      Left    := 10;
      Top     := 10;
      Name    := 'ListaAtendimentosUltimos10' + IntToStr(FilaNo);
      Visible := false;
      Tag     := FilaNo;
    end;

    btn1 := TBitBtn.Create(Self);
    with btn1 do
    begin
      btn1.Parent  := Self;
      btn1.Left    := 10;
      btn1.Top     := 10;
      btn1.Name    := 'BitBtn' + IntToStr(FilaNo);
      btn1.Caption := '';
      btn1.Height  := 40;
      btn1.Width   := 40;
      Visible := ShowButton;
      OnClick := BitBtnClick;
      Tag     := FilaNo;
    end;

    edt1 := TEdit.Create(Self);
    with edt1 do
    begin
      Parent   := Self;
      Left     := 10;
      Top      := 10;
      Name     := 'SenhaEdit' + IntToStr(FilaNo);
      Height   := 21;
      Width    := 60;
      Text     := '';
      OnEnter  := SenhaEdit1Enter;
      OnChange := SenhaEdit1Change;
      Tag      := FilaNo;
    end;

    btn2 := TButton.Create(Self);
    with btn2 do
    begin
      btn2.Parent  := Self;
      btn2.Left    := 10;
      btn2.Top     := 10;
      btn2.Name    := 'InsertSenhaButton' + IntToStr(FilaNo);
      btn2.Caption := 'Inserir';
      btn2.Height  := 20;
      btn2.Width   := 44;
      btn2.Enabled := false;
      btn2.OnClick := InsertSenhaButton1Click;
      btn2.Tag     := FilaNo;
    end;

    chk1 := TCheckBox.Create(Self);
    with chk1 do
    begin
      Parent  := Self;
      Left    := 10;
      Top     := 10;
      Name    := 'ListBlocked' + IntToStr(FilaNo);
      Caption := 'Bloquear';
      Height  := 18;
      Width   := 70;
      Visible := ShowBlocked;
      Color   := shape1.Brush.Color;
      OnClick := ListBlocked1Click;
      Tag     := FilaNo;
    end;

    chk2 := TCheckBox.Create(Self);
    with chk2 do
    begin
      Parent  := Self;
      Left    := 10;
      Top     := 10;
      Name    := 'PrioritaryList' + IntToStr(FilaNo);
      Caption := 'Prioritária';
      Height  := 18;
      Width   := 70;
      Visible := ShowPriority;
      Color   := shape1.Brush.Color;
      OnClick := PrioritaryList1Click;
      Tag     := FilaNo;
    end;

    bvl1 := TBevel.Create(Self);
    with bvl1 do
    begin
      Parent := Self;
      Left   := 10;
      Top    := 10;
      Name   := 'BevelV' + IntToStr(FilaNo);
      Width  := 1;
      Style  := bsRaised;
      Tag    := FilaNo;
    end;

    bvl2 := TBevel.Create(Self);
    with bvl2 do
    begin
      Parent := Self;
      Left   := 10;
      Top    := 10;
      Name   := 'BevelH' + IntToStr(FilaNo);
      Height := 1;
      Style  := bsRaised;
      Tag    := FilaNo;
    end;

    SG := TStringGrid.Create(Self);
    with SG do
    begin
      Parent           := Self;
      Left             := 10;
      Top              := 10;
      Name             := 'SenhasList' + IntToStr(FilaNo);
      Height           := 18;
      Width            := 70;
      ColCount         := COL_PRIMEIRA_TAG + fMaxTags; // RAP
      FixedCols        := 0;
      RowCount         := 2;
      DefaultRowHeight := 16;
      Options          := [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goRowSelect, goThumbTracking];
      ScrollBars       := ssVertical;
      OnDrawCell       := SenhasList1DrawCell;
      OnKeyUp          := SenhasList1KeyUp;
      OnMouseUp        := SenhasList1MouseUp;
      OnMouseMove      := SenhasListMouseMove;
      ShowHint         := True;
      Tag              := FilaNo;

      ColWidths[COL_DATAHORA] := -1;
      for I                   := ColCount - 1 downto (ColCount - fMaxTags) do // RAP
      begin // RAP
        Cells[I, 0]  := '';              // RAP
        ColWidths[I] := WIDTH_COLS_TAGS; // RAP
      end;

      Cells[COL_SENHA, 0] := 'Senha';
      Cells[COL_HORA, 0]  := 'Horário';
      Cells[COL_NOME, 0]  := 'Nome';
    end;

    InicializaEsperaUltimosN(FilaNo);
    InicializaAtendimentoUltimos10(FilaNo);

    Result := True;
  except
    Result := false;
  end;
end; { func CriaComponenteFila }

function TfrmSicsMain.CriaComponentePainelClientSocket(ClientSocketNo: Integer; IPAddress: string; IPPort: Integer): Boolean;
var
  cs: TClientSocket;
begin
  try
    cs := TClientSocket.Create(Self);
    with cs do
    begin
      Parent     := Self;
      Name       := 'PainelClientSocket' + IntToStr(ClientSocketNo);
      ClientType := ctNonBlocking;
      Host       := IPAddress;
      Port       := IPPort;
      OnError    := ClientSocketError;
      OnRead     := PainelClientSocketRead;
    end;

    Result := True;
  except
    Result := false;
  end;
end; { proc CriaComponentePainelClientSocket }

function TfrmSicsMain.CriaComponenteTecladoClientSocket(ClientSocketNo: Integer; IPAddress: string; IPPort: Integer): Boolean;
var
  cs: TClientSocket;
begin
  try
    cs := TClientSocket.Create(Self);
    with cs do
    begin
      Parent     := Self;
      Name       := 'TecladoClientSocket' + IntToStr(ClientSocketNo);
      ClientType := ctNonBlocking;
      Host       := IPAddress;
      Port       := IPPort;
      OnRead     := TecladoTcpPortRead;
      OnError    := ClientSocketError;
    end;

    Result := True;
  except
    Result := false;
  end;
end; { proc CriaComponenteTecladoClientSocket }

function TfrmSicsMain.CriaComponentePrinterClientSocket(ClientSocketNo: Integer; IPAddress: string; IPPort: Integer): Boolean;
var
  cs: TClientSocket;
begin
  try
    cs := TClientSocket.Create(Self);
    with cs do
    begin
      Parent       := Self;
      Name         := 'PrinterClientSocket' + IntToStr(ClientSocketNo);
      ClientType   := ctNonBlocking;
      Host         := IPAddress;
      Port         := IPPort;
      Tag          := ClientSocketNo;
      OnRead       := PrinterClientSocketRead;
      OnError      := PrinterClientSocketError;
      OnLookup     := PrinterClientSocketLookup;
      OnConnecting := PrinterClientSocketConnecting;
      OnConnect    := PrinterClientSocketConnect;
      OnDisconnect := PrinterClientSocketDisconnect;
    end;

    Result := True;
  except
    Result := false;
  end;
end; { proc CriaComponentePrinterClientSocket }

procedure TfrmSicsMain.LoadFilasToScreen;
begin
  TfrmDebugParameters.Debugar(tbCarregarFilas, 'LoadFilasToScreen - Iniciou a Criação dos objetos de Filas.');

  with dmSicsMain.cdsFilas do
    try
      First;
      while not Eof do
      begin
        if (FieldByName('Ativo').AsBoolean) and (FieldByName('id').AsInteger >= 0) then // >= 0 para se precaver do "-1" que eh "excluido"
        begin
          if not CriaComponenteFila(FieldByName('ID').AsInteger, FieldByName('Nome').AsString, True, True, True, FieldByName('CODIGOCOR').AsInteger) then
          begin
            Application.MessageBox('Erro ao criar filas.', 'Erro', MB_ICONSTOP);
            Exit;
          end;
        end;

        Next;
      end;
    except
      Application.MessageBox('Erro ao carregar filas.', 'Erro', MB_ICONSTOP);
    end;

  TfrmDebugParameters.Debugar(tbCarregarFilas, 'LoadFilasToScreen - Finalizou a Criação dos objetos de Filas.');
end; { proc LoadFilasToScreen }

function TfrmSicsMain.LoadCabecalhoTicket(IdPrinter: Integer): string;
var
  f          : file of char;
  c          : char;
  S, FileName: string;
begin
  Result := '';
  try
    if FileExists(GetApplicationPath + '\CustHead_V6_' + IntToStr(IdPrinter) + '.dll') then
      FileName := GetApplicationPath + '\CustHead_V6_' + IntToStr(IdPrinter) + '.dll'
    else
    if FileExists(GetApplicationPath + '\CustHead_V6.dll') then
      FileName := GetApplicationPath + '\CustHead_V6.dll'
    else
      Exit;

    if FileExists(FileName) then
    begin
      AssignFile(f, FileName);
      reset(f);
      try
        S := '';
        while not Eof(f) do
        begin
          Read(f, c);
          S := S + c;
        end;
      finally
        CloseFile(f);
      end; { try .. finally }
      Result := Decript(S);
    end;
  except
    Result := '';
  end;
end; { proc LoadCabecalhoTicket }

// OBSOLETO  => { Devolve a fila em que a senha está ou 0 se nao esta em nenhuma }
// VALENDO   => { Devolve a fila em que a senha está ou -1 se nao esta em nenhuma }
function TfrmSicsMain.ProcuraNasFilas(Pswd: Integer; out ANomeFila: String; out ADtHrSenha: TDateTime): Integer;
var
  ID, j: Integer;
  BM   : TBookmark;
begin
  Result := -1;

  with dmSicsMain.cdsFilas do
  begin
    BM := GetBookmark;
    try
      try
      First;
      while not Eof do
      begin
        if FieldByName('Ativo').AsBoolean then
        begin
          ID := FieldByName('ID').AsInteger;

          if frmSicsMain.FindComponent('SenhasList' + IntToStr(ID)) <> nil then
            with (frmSicsMain.FindComponent('SenhasList' + IntToStr(ID)) as TStringGrid) do
              for j := 1 to RowCount - 1 do
                if Cells[COL_SENHA, j] = IntToStr(Pswd) then
                begin
                  Result := ID;
                  ANomeFila := FieldByName('NOME').AsString;
                  ADtHrSenha := dmSicsMain.GetDataHoraEmissaoSenhaNoBD(GetIdTicket(Pswd), StrToDateTime(Cells[COL_DATAHORA, j]));
                  Exit;
                end; { if }
        end;
        Next;
      end;
      finally
        if BookmarkValid(BM) then
          GotoBookmark(BM);
      end;
    finally
      FreeBookmark(BM);
    end;
  end; // with cds
end;   { func ProcuraNasFilas }

// Devolve a fila em que a senha está ou -1 se nao esta em nenhuma
function TfrmSicsMain.ProcuraNasPAs(Pswd: Integer; out ANomePA: String; out ADtHrSenha: TDateTime): Integer;
var
  ID, j: Integer;
  BM   : TBookmark;
begin
  Result := -1;

  BM := frmSicsSituacaoAtendimento.cdsPAs.GetBookmark;
  try
    if frmSicsSituacaoAtendimento.cdsPAs.Locate('SENHA', Pswd, []) then
    begin
      result := frmSicsSituacaoAtendimento.cdsPAs.FieldByName('Id_PA').AsInteger;
      ANomePA := frmSicsSituacaoAtendimento.cdsPAs.FieldByName('LKUP_PA').AsString;
      ADtHrSenha := dmSicsMain.GetDataHoraEmissaoSenhaNoBD(
                      GetIdTicket(Pswd),
                      frmSicsSituacaoAtendimento.cdsPAs.FieldByName('Horario').AsDateTime);
    end;
  finally
    if frmSicsSituacaoAtendimento.cdsPAs.BookmarkValid(BM) then
      frmSicsSituacaoAtendimento.cdsPAs.GotoBookmark(BM);
  end;
end; { func ProcuraNasPAs }

{ ------------------------------------------------------------------- }
{ Procedures públicas }

function TfrmSicsMain.Login(IdModulo, IdPA : Integer; AtdIdOuLogin, Senha: string): Boolean;
var
  i : integer;
  IniTime : TDateTime;
begin
  if TryStrToInt(AtdIdOuLogin, i) then
    Result := ((dmSicsMain.cdsAtendentes.Locate('ID', AtdIdOuLogin, [])) and
               (dmSicsMain.cdsAtendentes.FieldByName('ATIVO').AsBoolean) and
               (dmSicsMain.cdsAtendentes.FieldByName('SENHALOGIN').AsString = Senha) and
               (VerificaSeAtendenteEPermitidoNoModulo (dmSicsMain.cdsAtendentes.FieldByName('ID').AsInteger, IdModulo)) and
               (frmSicsSituacaoAtendimento.LoginAtd(dmSicsMain.cdsAtendentes.FieldByName('ID').AsInteger, IdPA))
               )
  else
    Result := ((dmSicsMain.cdsAtendentes.Locate('LOGIN', AtdIdOuLogin, [loCaseInsensitive])) and
               (dmSicsMain.cdsAtendentes.FieldByName('ATIVO').AsBoolean) and
               (dmSicsMain.cdsAtendentes.FieldByName('SENHALOGIN').AsString = Senha) and
               (VerificaSeAtendenteEPermitidoNoModulo (dmSicsMain.cdsAtendentes.FieldByName('ID').AsInteger, IdModulo)) and
               (frmSicsSituacaoAtendimento.LoginAtd(dmSicsMain.cdsAtendentes.FieldByName('ID').AsInteger, IdPA))
               );
  if(GetModuleTypeByID(dmSicsMain.connOnline, idModulo) = msPA)then
  begin
   if(Result)then
    SalvaUltimaPAModoTerminalServer(IdModulo,IdPA);
  end;

  if Result and ChamarProximoNoLogin and VerificaChamadaAutomatica(IdPA) then
    Proximo(IdPA,IniTime);
end;

function TfrmSicsMain.Login(IdPA: Integer; AtdLogin: string; ForcarLogin: Boolean; var MotivoErro : string): boolean;
type
  TRespostaLogin = (rlLoginRealizado,
                    rlErroDiverso,
                    rlOutroAtendenteJaLogadoNestaPA,
                    rlAtendenteJaLogadoEmOutraPA,
                    rlAtendenteInexistente,
                    rlAtendenteInativo,
                    rlAtendenteNaoPermitidoParaEstaPA,
                    rlAtendenteNulo);
var
  IdAtd, ATD           : integer;
  StatusPA             : TStatusPA;
  PSW                  : String;
  FilaProveniente      : Integer;
  MotivoPausa          : Integer;
  IniTime              : TDateTime;
  LArqIni              : TIniFile;
  LAtdGrupoId          : Integer;
  LIdModulo            : integer;
  MesmoAtdJaEstaLogado : boolean;
  MotivosErro          : set of TRespostaLogin;
  i                    : TRespostaLogin;

begin
  Result               := false;
  MesmoAtdJaEstaLogado := false;
  MotivoErro           := '';

  IdAtd := NGetAtdId(AtdLogin);

  try
    if Trim(AtdLogin) = '' then
    begin
      Result := false;
      MotivosErro := [rlAtendenteNulo];
    end
    else if ForcarLogin then
    begin
      // Verifica se existe o atendente
      if dmSicsMain.cdsAtendentes.Locate('LOGIN', AtdLogin, [loCaseInsensitive]) then
      begin
        frmSicsSituacaoAtendimento.GetPASituation (IdPA, StatusPA, ATD, PSW, FilaProveniente, MotivoPausa, IniTime);
        if ATD = IdAtd then
		    begin
          MesmoAtdJaEstaLogado := true;
          Result      := true;
          MotivosErro := [rlLoginRealizado];
		    end
        else if frmSicsSituacaoAtendimento.LoginAtd(dmSicsMain.cdsAtendentes.FieldByName('ID').AsInteger, IdPA) then
        begin
          Result      := true;
          MotivosErro := [rlLoginRealizado];
        end
        else
        begin
          Result     := false;
          MotivosErro := [rlErroDiverso];
        end;
      end
      else // Se não existe o atendente, cadastrá-lo e fazer o seu login
      begin
        LArqIni := TIniFile.Create(GetIniFileName);
        try
          LAtdGrupoId := LArqIni.ReadInteger('Integracao', 'GrupoAtendente', 1);
          LArqIni.WriteInteger('Integracao', 'GrupoAtendente', LAtdGrupoId);
        finally
          LArqIni.Free;
        end;

        ATD := InsereAtendente(AtdLogin, AtdLogin, '', LAtdGrupoId);

        if ATD <> -1 then // Se cadastrou com sucesso, ATD receberá o ID do atendente recém cadastrado
        begin
          if frmSicsSituacaoAtendimento.LoginAtd(ATD, IdPA) then
          begin
            Result := true;
            MotivosErro := [rlLoginRealizado];
          end
          else
          begin
            Result := false;
            MotivosErro := [rlErroDiverso];
          end;
        end
        else // Se não cadastrou com sucesso, ATD = -1 e, neste caso, retornar rlErroDiverso
        begin
          Result := false;
          MotivosErro := [rlErroDiverso];
        end;
      end;
    end //if ForcarLogin
    else // Se não for para Forçar o Login
    begin
      if dmSicsMain.cdsAtendentes.Locate('LOGIN', AtdLogin, [loCaseInsensitive]) then
      begin
        if not dmSicsMain.cdsAtendentes.FieldByName('ATIVO').AsBoolean then
          MotivosErro := MotivosErro + [rlAtendenteInativo];

        LIdModulo := GetIdModulo(dmSicsMain.connOnLine, IdPA);
        if not VerificaSeAtendenteEPermitidoNoModulo(dmSicsMain.cdsAtendentes.FieldByName('ID').AsInteger, LIdModulo) then
          MotivosErro := MotivosErro + [rlAtendenteNaoPermitidoParaEstaPA];
      end
      else
        MotivosErro := MotivosErro + [rlAtendenteInexistente];

      if (frmSicsSituacaoAtendimento.cdsClonePAs.Locate('Id_Atd', IdAtd,[])) and (frmSicsSituacaoAtendimento.cdsClonePAs.FieldByName('Id_PA').AsInteger <> IdPA) then
        MotivosErro := MotivosErro + [rlAtendenteJaLogadoEmOutraPA];

      frmSicsSituacaoAtendimento.GetPASituation(IdPA, StatusPA, ATD, PSW, FilaProveniente, MotivoPausa, IniTime);
      if ATD <> -1 then
      begin
        if ATD <> IdAtd then
          MotivosErro := MotivosErro + [rlOutroAtendenteJaLogadoNestaPA]
        else
          MesmoAtdJaEstaLogado := true;
      end;

      if MotivosErro = [] then
      begin
        if frmSicsSituacaoAtendimento.LoginAtd(IdAtd, IdPA) then
        begin
          Result := true;
          MotivosErro := [rlLoginRealizado];
        end
        else
        begin
          Result := false;
          MotivosErro := [rlErroDiverso];
        end;
      end;
    end;
  except
    on E: Exception do
    begin
      Result := false;
      MotivosErro := [rlErroDiverso];
    end;
  end;

  MotivoErro := '';
  for I := Low(TRespostaLogin) to High(TRespostaLogin) do
    if i in MotivosErro then
      MotivoErro := MotivoErro + IntToStr(ord(i)) + ',';

  delete(MotivoErro,length(MotivoErro),1);

  if not MesmoAtdJaEstaLogado then
  begin
    if Result and ChamarProximoNoLogin and VerificaChamadaAutomatica(IdPA) then
      Proximo(IdPA,IniTime);
  end;
end;


function TfrmSicsMain.Logout(IdAtd: Integer): Boolean;
begin
  Result := frmSicsSituacaoAtendimento.LogoutAtd(IdAtd);
end;

function TfrmSicsMain.LogoutCliente(ID: integer; Posicao: String): String;
var
  LSQL     : String;
  LPosicao : String;
  LQryLogout: TFDQuery;
begin
  Result := '';

  LQryLogout := TFDQuery.Create(Nil);
  try
    LQryLogout.Connection := dmSicsMain.connOnLine;
    try
      LSQL := ' UPDATE CLIENTES '+
              ' SET LOGADO_NUMERO_MESA = null ' +
              ' Where ID_UNIDADE = ' + vgParametrosModulo.IdUnidade.ToString +
              '   and ID = ' + IntToStr(ID)     +
              ' and   LOGADO_NUMERO_MESA = '    + QuotedStr(Posicao);

      LQryLogout.Close;
      LQryLogout.SQL.Text := LSQL;
      LQryLogout.ExecSQL;
    except on E: Exception do
      begin
        Result   := 'E'+ TAB + E.Message;
        MyLogException(E);
      end;
    end;
  finally
    FreeAndNil(LQryLogout);
  end;
end;

function TfrmSicsMain.LogoutPA(IdPA: Integer): Boolean;
begin
  Result := frmSicsSituacaoAtendimento.LogoutPA(IdPA);
end;

procedure TfrmSicsMain.ManagePswdPopMenuPopup(Sender: TObject);
begin
  PopUpMenuExcluir.Visible := vgParametrosModulo.PermiteExcluirSenhas;
  mnuExcluirTodos.Visible := vgParametrosModulo.PermiteExcluirSenhas;

  if not vgParametrosModulo.PermiteExcluirSenhas then
    Abort;
end;

function TfrmSicsMain.ForcaLogin(IdPA : Integer; AtdLogin, AtdNome : string; AtdGrupoId : integer; AtdGrupoNome: String): Boolean;
var
  IdAtd : integer;
  IdGrupo: integer;
  IniTime : TDateTime;
begin
  Result := false;
  IdAtd  := -1;

  //KM - Incluir grupo caso não exista (integração via REST)
  if AtdGrupoNome <> EmptyStr  then
  begin
    with(dmSicsMain.cdsGruposDeAtendentes) do
    begin
      if (Locate('ID',AtdGrupoId,[]))then
      begin
        AtualizaGrupoAtendente(AtdGrupoNome);
      end
      else
      begin
        InsereGrupoAtendente(AtdGrupoId,AtdGrupoNome);
      end;
    end;
  end;

  if dmSicsMain.cdsAtendentes.Locate('LOGIN', AtdLogin, [loCaseInsensitive]) then
  begin
    IdAtd := dmSicsMain.cdsAtendentes.FieldByName('ID').AsInteger;
    if (not dmSicsMain.cdsAtendentes.FieldByName('ATIVO').AsBoolean) or (dmSicsMain.cdsAtendentes.FieldByName('NOME').AsString <> AtdNome) or (dmSicsMain.cdsAtendentes.FieldByName('ID_GRUPOATENDENTE').AsInteger <> AtdGrupoId) then
      AtualizaAtendente(IdAtd, true, AtdNome, AtdLogin, TextHash(''), '', AtdGrupoId);
  end
  else
    IdAtd := InsereAtendente(AtdNome, AtdLogin, '', AtdGrupoId);

  if IdAtd <> -1 then
    Result := frmSicsSituacaoAtendimento.LoginAtd(IdAtd, IdPA);

  if Result and ChamarProximoNoLogin and VerificaChamadaAutomatica(IdPA) then
    Proximo(IdPA,IniTime);
end;

function TfrmSicsMain.IniciarPausa(IdPA, MotivoPausa: Integer): Boolean;
begin
  Result := frmSicsSituacaoAtendimento.SetPausa(IdPA, MotivoPausa);
end;

function TfrmSicsMain.FinalizarPausa(IdPA: Integer): Boolean;
var
  IniTime : TDateTime;
begin
  Result := frmSicsSituacaoAtendimento.UnSetPausa (IdPA);

  if VerificaChamadaAutomatica (IdPA) then
    Proximo(IdPA,IniTime);
end;

{ Estas funcoes retornam:                                                                     }
{       -7  -> PA está em pausa e sistema configurado para não chamar próximo quando em pausa }
{       -6  -> senha inválida (fora de todos os ranges)                                       }
{       -5  -> nao existe nenhum atendente logado na PA                                       }
{       -4  -> chamada estouraria No max de atendimentos na PA (definido pelo Magazine)       }
{       -3  -> a senha pretendida está numa fila não contida nas priorid. de atendimento      }
{       -2  -> o atendente está aguardando para ser anunciado na painel                       }
{       -1  -> a senha não está em nenhuma fila                                               }
{  0,1,2... -> senha chamada                                                                  }
function TfrmSicsMain.Proximo (IdPA : integer; var IniTime : TDateTime) : integer;
var
  Senha, SenhaGerada                                                   : integer;
  IndiceDeChamada                                                      : extended;
  AuxIniTime, NowTime                                                  : TDateTime;
  SenhaAtendida                                                        : string;
  IdAtd, IdGrupoPA, IdPainel, PAMagazine, PAAutoRedir, FilaProveniente : integer;
  PANome, PANomeNoPainel, PANomePorVoz                                 : string;
  PAAtiva                                                              : boolean;
  StatusPA                                                             : TStatusPA;
  MotivoPausa                                                          : integer;
begin
  nowTime := now;
  ChamarDaFila := 0;

  frmSicsSituacaoAtendimento.GetPASituation (idPA, StatusPA, idAtd, SenhaAtendida, FilaProveniente, MotivoPausa, AuxIniTime);
  if idAtd = -1 then
  begin
    Result := -5;
    Exit;
  end
  else if (StatusPA = spEmPausa) and (vgParametrosModulo.ProximoNaoEncerraPausa) then
  begin
    Result := -7;
    Exit;
  end;

  if not TemNoOutBuffer (inttostr(IdPA)) then
  begin
    senha := -1;  { para retirar do inicio da fila em RetrievePswd }
    if ((fFilaPrioritaria <> 0) and (ExisteAFilaNaOrdemDasFilasDaPA (fFilaPrioritaria, IdPA))) then
    begin
      if ((NGetGerarSenhaAutomaticamente(fFilaPrioritaria)) and
          (FindComponent('SenhasCountLabel'+inttostr(fFilaPrioritaria)) <> nil) and
          (strtoint(((FindComponent('SenhasCountLabel'+inttostr(fFilaPrioritaria))) as TLabel).Caption) = 0) and
          (FindComponent('BitBtn'+inttostr(fFilaPrioritaria)) <> nil)) then
        GeraSenhaEImprime(fFilaPrioritaria, ImpressoraDefault, SenhaGerada, AuxIniTime);

      RetrievePswd (fFilaPrioritaria, Senha, IniTime);
      hora := DateTimeToStr(IniTime);
      ChamarDaFila := fFilaPrioritaria;
      ((FindComponent('PrioritaryList' + inttostr(fFilaPrioritaria))) as TCheckBox).Checked := false;
      fFilaPrioritaria := 0;
    end  { if há uma fila prioritaria }
    else
    begin
      IndiceDeChamada := -1;
      ChamarDaFila    := -1;
      dmSicsMain.cdsPAs.Locate('ID', IdPA, []);
      if dmSicsMain.cdsPAs.FieldByName('Ativo').AsBoolean then
      begin
        dmSicsMain.cdsNN_PAs_Filas.First;
        while not dmSicsMain.cdsNN_PAs_Filas.Eof do
        begin
          if not FilaBloqueada(dmSicsMain.cdsNN_PAs_Filas.FieldByName('ID_FILA').AsInteger) then
          begin
            if NGetGerarSenhaAutomaticamente(dmSicsMain.cdsNN_PAs_Filas.FieldByName('ID_FILA').AsInteger) then
            begin
              GeraSenhaEImprime(dmSicsMain.cdsNN_PAs_Filas.FieldByName('ID_FILA').AsInteger, 0, SenhaGerada,
                                AuxIniTime);
              ChamarDaFila := dmSicsMain.cdsNN_PAs_Filas.FieldByName('ID_FILA').AsInteger;
              break;
            end
            else if dmSicsMain.cdsPAs.FieldByName('OBEDECERSEQUENCIAFILAS').AsBoolean then
            begin
              if ExisteSenhaNaFila(dmSicsMain.cdsNN_PAs_Filas.FieldByName('ID_FILA').AsInteger) then
              begin
                ChamarDaFila := dmSicsMain.cdsNN_PAs_Filas.FieldByName('ID_FILA').AsInteger;
                break;
              end;
            end
            else
            begin
              if ((ExisteSenhaNaFila(dmSicsMain.cdsNN_PAs_Filas.FieldByName('ID_FILA').AsInteger)) and ((ChamarDaFila = 0) or (IndiceDeChamada < ((nowtime - strtodatetime(((FindComponent('SenhasList' + dmSicsMain.cdsNN_PAs_Filas.FieldByName('ID_FILA').AsString)) as TStringGrid).Cells[COL_DATAHORA,1])) / GetMetaDeEspera(dmSicsMain.cdsNN_PAs_Filas.FieldByName('ID_FILA').AsInteger)) - 1))) then
              begin
                IndiceDeChamada := ((nowtime - strtodatetime(((FindComponent('SenhasList' + dmSicsMain.cdsNN_PAs_Filas.FieldByName('ID_FILA').AsString)) as TStringGrid).Cells[COL_DATAHORA,1])) / GetMetaDeEspera(dmSicsMain.cdsNN_PAs_Filas.FieldByName('ID_FILA').AsInteger)) - 1;
                ChamarDaFila := dmSicsMain.cdsNN_PAs_Filas.FieldByName('ID_FILA').AsInteger;
              end;
            end;
          end;
          dmSicsMain.cdsNN_PAs_Filas.Next;
        end;
      end;

      if (ChamarDaFila <> -1) then
      begin
        RetrievePswd (ChamarDaFila, Senha, IniTime);
        hora := DateTimeToStr(IniTime);
      end;
    end;  { else (if nao ha fila prioritaria) }
  end  { if not TemNoOutbuffer }
  else
    senha := -2;

  Result := senha;

  case senha of
    -1 : begin  { Nao há senhas para serem atendidas }
           if StatusPA = spEmPausa then
           begin
             RegistraEvento(ord(teEmPausa), idAtd, IdPA, -1, MotivoPausa, -1, AuxIniTime, NowTime);
             frmSicsSituacaoAtendimento.UpdatePASituation(idPA, '---', -1, nowtime);
           end
           else if SenhaAtendida <> '---' then
           begin { ele estava atendendo alguem }
             if ((NGetPAData(IdPA, PAAtiva, IdGrupoPA, PANome, IdPainel, PANomeNoPainel, PANomePorVoz, PAMagazine, PAAutoRedir)) and (PAAutoRedir <> 0)) then
               InsertPswd(PAAutoRedir,strtoint(SenhaAtendida),NowTime,-2);
             RegistraEvento(ord(teAtendimento), idAtd, IdPA, FilaProveniente, -1, strtoint(SenhaAtendida), AuxIniTime, NowTime);

             if FilaProveniente > 0 then
               AtualizaAtendimentoUltimos10(FilaProveniente, AuxIniTime);

             frmSicsSituacaoAtendimento.UpdatePASituation(idPA, '---', -1, nowtime);
           end  { if SenhaAtendida <> '---' }
           else begin
                 { Ele ja nao estava atendendo ninguem e nao há ninguem p/ chamar - Nada a fazer }
           end;
         end;  { case -1 }
    -2 : ;  { Atd está na fila para aparecer no painel (outbuffer) }
    -3 : ;  { Acho que nunca acontecerá }
    -4 : ;  { Acho que nunca acontecerá }
    -5 : ;  { Acho que nunca acontecerá }
    else begin
           NGetPAData(IdPA, PAAtiva, IdGrupoPA, PANome, IdPainel, PANomeNoPainel, PANomePorVoz, PAMagazine, PAAutoRedir);          //LBC 2016-07-06 Versao 4.4 Rev. R - Ajuste de magazine 0
                                                                                                                                   //LBC 2016-07-06 Versao 4.4 Rev. R - Ajuste de magazine 0

           if IdPainel > 0 then
           begin
             if(VerificaChamadaAutomaticaSemFlag(IdPA))then
                InsertInOutBuffer (Senha, IdPA,hora)                                                                            //LBC 2016-07-06 Versao 4.4 Rev. R - Ajuste de magazine 0
             else
                InsertInOutBuffer (Senha, IdPA);
           end;                                                                                                                    //LBC 2016-07-06 Versao 4.4 Rev. R - Ajuste de magazine 0
                                                                                                                                   //LBC 2016-07-06 Versao 4.4 Rev. R - Ajuste de magazine 0
           RegistraEvento (ord(teEspera), IdAtd, IdPA, ChamarDaFila, -1, Senha, IniTime, NowTime);                                 //LBC 2016-07-06 Versao 4.4 Rev. R - Ajuste de magazine 0
                                                                                                                                   //LBC 2016-07-06 Versao 4.4 Rev. R - Ajuste de magazine 0
           if ChamarDaFila > 0 then                                                                                                //LBC 2016-07-06 Versao 4.4 Rev. R - Ajuste de magazine 0
             AtualizaEsperaUltimosN (ChamarDaFila, IniTime);                                                                      //LBC 2016-07-06 Versao 4.4 Rev. R - Ajuste de magazine 0
                                                                                                                                   //LBC 2016-07-06 Versao 4.4 Rev. R - Ajuste de magazine 0
           if StatusPA = spEmPausa then                                                                                            //LBC 2016-07-06 Versao 4.4 Rev. R - Ajuste de magazine 0
             RegistraEvento(ord(teEmPausa), idAtd, IdPA, -1, MotivoPausa, -1, AuxIniTime, NowTime)                                 //LBC 2016-07-06 Versao 4.4 Rev. R - Ajuste de magazine 0
           else if SenhaAtendida <> '---' then                                                                                     //LBC 2016-07-06 Versao 4.4 Rev. R - Ajuste de magazine 0
           begin                                                                                                                   //LBC 2016-07-06 Versao 4.4 Rev. R - Ajuste de magazine 0
             if PAAutoRedir <> 0 then                                                                                              //LBC 2016-07-06 Versao 4.4 Rev. R - Ajuste de magazine 0
               InsertPswd(PAAutoRedir,strtoint(SenhaAtendida),NowTime,-2);                                                         //LBC 2016-07-06 Versao 4.4 Rev. R - Ajuste de magazine 0
                                                                                                                                   //LBC 2016-07-06 Versao 4.4 Rev. R - Ajuste de magazine 0
             RegistraEvento (ord(teAtendimento), IdAtd, IdPA, FilaProveniente, -1, strtoint(SenhaAtendida), AuxIniTime, NowTime);  //LBC 2016-07-06 Versao 4.4 Rev. R - Ajuste de magazine 0

             if FilaProveniente > 0 then
               AtualizaAtendimentoUltimos10(FilaProveniente, AuxIniTime);
           end;                                                                                                                    //LBC 2016-07-06 Versao 4.4 Rev. R - Ajuste de magazine 0
           if PAMagazine > 0 then                                                                                                  //LBC 2016-07-06 Versao 4.4 Rev. R - Ajuste de magazine 0
             frmSicsSituacaoAtendimento.UpdatePASituation(IdPA, inttostr(Senha), ChamarDaFila, nowtime)                            //LBC 2016-07-06 Versao 4.4 Rev. R - Ajuste de magazine 0
           else                                                                                                                    //LBC 2016-07-06 Versao 4.4 Rev. R - Ajuste de magazine 0
           begin                                                                                                                   //LBC 2016-07-06 Versao 4.4 Rev. R - Ajuste de magazine 0
             if PAAutoRedir <> 0 then                                                                                              //LBC 2016-07-06 Versao 4.4 Rev. R - Ajuste de magazine 0
               InsertPswd(PAAutoRedir,Senha,NowTime,-2);                                                                           //LBC 2016-07-06 Versao 4.4 Rev. R - Ajuste de magazine 0
                                                                                                                                   //LBC 2016-07-06 Versao 4.4 Rev. R - Ajuste de magazine 0
             frmSicsSituacaoAtendimento.UpdatePASituation(IdPA, '---', -1, nowtime);                                               //LBC 2016-07-06 Versao 4.4 Rev. R - Ajuste de magazine 0
             Result := -4;                                                                                                         //LBC 2016-07-06 Versao 4.4 Rev. R - Ajuste de magazine 0
           end;                                                                                                                    //LBC 2016-07-06 Versao 4.4 Rev. R - Ajuste de magazine 0

           if vgParametrosModulo.ReportarChamadasComTE then
             BroadcastChamadasComTE(IdPA, Senha, IniTime);
         end;  { case else }
  end;  { case }
end;  { func Proximo }


function TfrmSicsMain.Rechama (IdPA : integer) : integer;
var
  idAtd, FilaProveniente : integer;
  SenhaAtendida          : string;
  NowTime, IniTime       : TDateTime;
  StatusPA               : TStatusPA;
  MotivoPausa            : integer;
begin
  Result := -1;

  frmSicsSituacaoAtendimento.GetPASituation (idPA, StatusPA, idAtd, SenhaAtendida, FilaProveniente, MotivoPausa, IniTime);
  if idAtd = -1 then
  begin
    Result := -5;
    Exit;
  end;

  if not TemNoOutBuffer (inttostr(idPA)) then
  begin
    if (SenhaAtendida <> '---') then
    begin
      NowTime := now;

      RegistraEvento (ord(teRechama), idAtd, idPA, FilaProveniente, -1, strtoint(SenhaAtendida), IniTime, NowTime);

      frmSicsSituacaoAtendimento.UpdatePASituation(IdPA, SenhaAtendida, FilaProveniente, nowtime);

      Result := strtoint(SenhaAtendida);
      InsertInOutBuffer(Result, idPA);
    end;
  end  { if not TemNoOutBuffer }
  else
    Result := -2;
end;   { func Rechama }


function TfrmSicsMain.Finaliza (IdPA : integer) : integer;
var
  SenhaAtendida                                                        : string;
  IniTime, NowTime                                                     : TDateTime;
  IdAtd, IdGrupoPA, IdPainel, PAMagazine, PAAutoRedir, FilaProveniente : integer;
  PANome, PANomeNoPainel, PANomePorVoz                                 : string;
  PAAtiva                                                              : boolean;
  StatusPA                                                             : TStatusPA;
  MotivoPausa                                                          : integer;
begin
  Result := -1;

  frmSicsSituacaoAtendimento.GetPASituation (idPA, StatusPA, idAtd, SenhaAtendida, FilaProveniente, MotivoPausa, IniTime);
  if idAtd = -1 then
  begin
    Result := -5;
    Exit;
  end;

  if SenhaAtendida <> '---' then
  begin
    if ((NGetPAData(IdPA, PAAtiva, IdGrupoPA, PANome, IdPainel, PANomeNoPainel, PANomePorVoz, PAMagazine, PAAutoRedir)) and (PAAutoRedir <> 0)) then
      Result := Redireciona(IdPA, PAAutoRedir)
    else
    begin
      NowTime := now;
      RegistraEvento (ord(teAtendimento), idAtd, IdPA, FilaProveniente, -1, strtoint(SenhaAtendida), IniTime, NowTime);

      if FilaProveniente > 0 then
        AtualizaAtendimentoUltimos10(FilaProveniente, IniTime);

      frmSicsSituacaoAtendimento.UpdatePASituation(idPA, '---', -1, nowtime);

      EnviarPushDeSenhaFinalizada(SenhaAtendida);

      if VerificaChamadaAutomatica (IdPA) then    //REV4.4 DEBUG MARCOS - COLOQUEI DAQUI AO INVÉS DE DENTRO DE UpdatePASituation
        Result := Proximo(IdPA,IniTime);          //REV4.4 DEBUG MARCOS - COLOQUEI DAQUI AO INVÉS DE DENTRO DE UpdatePASituation
    end;
  end;  { if SenhaAtendida <> '---' }
end;  { func Finaliza }


function TfrmSicsMain.FinalizaPelaSenha (Pswd : integer) : integer;
var
  NF      : integer;
  IniTime : TDateTime;
  BM      : TBookMark;
  NomeFila: String;
begin
  Result := -1;

  if vlFinalizarPelaSenhaCancelaEspera then
  begin
    NF := ProcuraNasFilas(Pswd, NomeFila, IniTime);
    if NF > 0 then
      RetrievePswd (NF, Pswd, IniTime);
  end;

  with frmSicsSituacaoAtendimento.cdsPAs do
  begin
    BM := GetBookmark;
    try
      if Locate('SENHA', Pswd, []) then
        Result := Finaliza(FieldByName('Id_PA').AsInteger);
    finally
      GotoBookmark(BM);
      FreeBookmark(BM);
    end;
  end;  // with cds
end;  { func FinalizaPelaSenha }


function TfrmSicsMain.ChamaEspecifica (IdPA, Pswd : integer; var IniTimeEspera : TDateTime) : integer;
var
  NF                                                                   : integer;
  IniTime, AuxIniTime, AuxTime, NowTime                                : TDateTime;
  SenhaAtendida                                                        : string;
  IdAtd, IdGrupoPA, IdPainel, PAMagazine, PAAutoRedir, FilaProveniente : integer;
  PANome, PANomeNoPainel, PANomePorVoz                                 : string;
  PAAtiva                                                              : boolean;
  StatusPA                                                             : TStatusPA;
  MotivoPausa                                                          : integer;
  NomeFila                                                             : String;
begin
  nowTime := now;
  NF := 0;
  IniTimeEspera := 0;

  frmSicsSituacaoAtendimento.GetPASituation (idPA, StatusPA, idAtd, SenhaAtendida, FilaProveniente, MotivoPausa, AuxIniTime);
  if idAtd = -1 then
  begin
    Result := -5;  // Sem atendente logado na PA
    Exit;
  end;

  if not SenhaEhValida(Pswd) then
  begin
    Result := -6;  // Senha inválida (fora de todos os ranges)
    Exit;
  end;

  if TemNoOutBuffer (inttostr(IdPA)) then
  begin
    Result := -2;  // PA já está no OutBuffer para chamada de alguma senha (PA está aguardando para aparecer no painel)
    Exit;
  end;

  NF := ProcuraNasFilas(Pswd, NomeFila, IniTime);
  if NF < 0 then
  begin
    Result := -1;  // Senha não está em nenhuma fila
    Exit;
  end;

  if not ExisteAFilaNaOrdemDasFilasDaPA(NF, IdPA) then
  begin
    Result := -3;  // Senha está numa fila, mas esta fila esteja fora dos prioridades de atendimento desta PA
    Exit;
  end;

  //Se chegou aqui sem nenhum Exit, senha está numa fila e esta fila está nas prioridades de atendimento desta PA
  RetrievePswd (NF, Pswd, IniTime);
  IniTimeEspera := IniTime;
  Result := Pswd;

  InsertInOutBuffer (Result, IdPA);

  RegistraEvento (ord(teEspera), IdAtd, IdPA, NF, -1, Pswd, IniTime, NowTime);

  if NF > 0 then
    AtualizaEsperaUltimosN (NF, IniTime);

  NGetPAData(IdPA, PAAtiva, IdGrupoPA, PANome, IdPainel, PANomeNoPainel, PANomePorVoz, PAMagazine, PAAutoRedir);

  if PAMagazine <> 0 then
  begin
    if StatusPA = spEmPausa then
      RegistraEvento (ord(teEmPausa), IdAtd, IdPA, -1, MotivoPausa, -1, AuxIniTime, NowTime)
    else if SenhaAtendida <> '---' then  // estava atendendo alguém
    begin
      if PAAutoRedir <> 0 then
        InsertPswd(PAAutoRedir, strtoint(SenhaAtendida), NowTime, -2);

      RegistraEvento (ord(teAtendimento), IdAtd, IdPA, FilaProveniente, -1, strtoint(SenhaAtendida), AuxIniTime, NowTime);

      if FilaProveniente > 0 then
        AtualizaAtendimentoUltimos10(FilaProveniente, AuxIniTime);
    end;

    frmSicsSituacaoAtendimento.UpdatePASituation(IdPA, inttostr(Pswd), NF, Nowtime);
  end
  else
  begin
    if StatusPA = spEmPausa then
      RegistraEvento (ord(teEmPausa), IdAtd, IdPA, -1, MotivoPausa, -1, AuxIniTime, NowTime);

    if PAAutoRedir <> 0 then
    begin
      InsertPswd(PAAutoRedir,Pswd,NowTime,-2);
    end;

    frmSicsSituacaoAtendimento.UpdatePASituation(IdPA, '---', -1, nowtime);

    Result := -4;

    if VerificaChamadaAutomatica (IdPA) then  //REV4.4 DEBUG MARCOS - COLOQUEI DAQUI AO INVÉS DE DENTRO DE UpdatePASituation
      Result := Proximo(IdPA, AuxTime);       //REV4.4 DEBUG MARCOS - COLOQUEI DAQUI AO INVÉS DE DENTRO DE UpdatePASituation
  end;

  if vgParametrosModulo.ReportarChamadasComTE then
    BroadcastChamadasComTE(IdPA, Pswd, IniTime);
end;  { func ChamaEspecifica }


function TfrmSicsMain.ForcaChamada (IdPA, Pswd : integer; var IniTimeEspera : TDateTime; var IdFila : integer; var NomeFila : string) : integer;
var
  NF                                                                   : integer;
  IniTime, AuxIniTime, AuxTime, NowTime                                : TDateTime;
  SenhaAtendida                                                        : string;
  IdAtd, IdGrupoPA, IdPainel, PAMagazine, PAAutoRedir, FilaProveniente : integer;
  PANome, PANomeNoPainel, PANomePorVoz                                 : string;
  BM                                                                   : TBookmark;
  PAAtiva                                                              : boolean;
  StatusPA                                                             : TStatusPA;
  MotivoPausa                                                          : integer;
  LNegativo                                                            : Integer;
  LTicket                                                              : Integer;
begin
  nowTime := now;
  NF := 0;
  IniTimeEspera := 0;
  IdFila := 0;
  NomeFila := '';

  frmSicsSituacaoAtendimento.GetPASituation (idPA, StatusPA, idAtd, SenhaAtendida, FilaProveniente, MotivoPausa, AuxIniTime);
  if idAtd = -1 then
  begin
    Result := -5;
    Exit;
  end;

  if not SenhaEhValida(Pswd) then
  begin
    Result := -6;
    Exit;
  end;

  if SenhaAtendida = inttostr(Pswd) then
  begin
    Result := Rechama(idPA);
    Exit;
  end;

  if not TemNoOutBuffer (inttostr(IdPA)) then
  begin
    NF := ProcuraNasFilas(Pswd, NomeFila, IniTime);
    if NF > 0 then
    begin
      RetrievePswd (NF, Pswd, IniTime);
      IniTimeEspera := IniTime;
      IdFila := NF;
    end
    else
    begin
      with frmSicsSituacaoAtendimento.cdsPAs do
      begin
        BM := GetBookmark;
        try
          if Locate('SENHA', Pswd, []) then
            Redireciona(FieldByName('Id_PA').AsInteger, 0);
        finally
          GotoBookmark(BM);
          FreeBookmark(BM);
        end;
      end;  // with cds

      if vgParametrosModulo.GerarIdTicketAoChamarEspecificaQueNaoExista then
      begin
        // se for servidor de contigencia, os ids dos tickets sao inserido como negativos
        LNegativo := IfThen(dmSicsContingencia.TipoFuncionamento = tfContingente, -1, 1);

        LTicket   := TGenerator.NGetNextGenerator('GEN_ID_TICKET', dmSicsMain.connOnLine) * LNegativo;

        RegistraTicket(LTicket, Pswd, 0, -2, Now);

        AtualizarIDsTickets;
      end;

      IniTime := Nowtime;
    end;
    Result := Pswd;
  end  { if not TemNoOutbuffer }
  else
    Result := -2;

  if Result >= 0 then
  begin
    InsertInOutBuffer (Result, IdPA);

    if IniTime <> NowTime then
    begin
      RegistraEvento (ord(teEspera), IdAtd, IdPA, NF, -1, Pswd, IniTime, NowTime);

      if NF > 0 then
        AtualizaEsperaUltimosN (NF, IniTime);
    end;

    NGetPAData(IdPA, PAAtiva, IdGrupoPA, PANome, IdPainel, PANomeNoPainel, PANomePorVoz, PAMagazine, PAAutoRedir);

    if PAMagazine <> 0 then
    begin
      if StatusPA = spEmPausa then
        RegistraEvento (ord(teEmPausa), IdAtd, IdPA, -1, MotivoPausa, -1, AuxIniTime, NowTime)
      else if SenhaAtendida <> '---' then
      begin
        if PAAutoRedir <> 0 then
          InsertPswd(PAAutoRedir,strtoint(SenhaAtendida),NowTime,-2);

        RegistraEvento (ord(teAtendimento), IdAtd, IdPA, FilaProveniente, -1, strtoint(SenhaAtendida), AuxIniTime, NowTime);

        if FilaProveniente > 0 then
          AtualizaAtendimentoUltimos10(FilaProveniente, AuxIniTime);
      end;
      frmSicsSituacaoAtendimento.UpdatePASituation(IdPA, inttostr(Pswd), NF, nowtime);
    end
    else
    begin
      if StatusPA = spEmPausa then
        RegistraEvento (ord(teEmPausa), IdAtd, IdPA, -1, MotivoPausa, -1, AuxIniTime, NowTime);

      if PAAutoRedir <> 0 then
        InsertPswd(PAAutoRedir,Pswd,NowTime,-2);

      frmSicsSituacaoAtendimento.UpdatePASituation(IdPA, '---', -1, nowtime);
      Result := -4;

      if VerificaChamadaAutomatica (IdPA) then  //REV4.4 DEBUG MARCOS - COLOQUEI DAQUI AO INVÉS DE DENTRO DE UpdatePASituation
        Result := Proximo(IdPA,AuxTime);        //REV4.4 DEBUG MARCOS - COLOQUEI DAQUI AO INVÉS DE DENTRO DE UpdatePASituation
    end;
  end;  { if Result >=0 }

  //Neste caso, pode reportar IniTime = NowTime, caso a senha estivesse em atendimento ou em nenhuma Fila
  if vgParametrosModulo.ReportarChamadasComTE then
    BroadcastChamadasComTE(IdPA, Pswd, IniTime);
end;  { func ForcaChamada }


function TfrmSicsMain.Redireciona (IdPA, NF : integer) : integer;
var
  SenhaAtendida           : string;
  IniTime, NowTime        : TDateTime;
  idAtd, FilaProveniente  : integer;
  StatusPA                : TStatusPA;
  MotivoPausa             : integer;
begin
  Result := -1;

  frmSicsSituacaoAtendimento.GetPASituation (idPA, StatusPA, idAtd, SenhaAtendida, FilaProveniente, MotivoPausa, IniTime);
  if idAtd = -1 then
  begin
    Result := -5;
    Exit;
  end;

  if SenhaAtendida <> '---' then
  begin
    NowTime := now;
    RegistraEvento (ord(teAtendimento), IdAtd, IdPA, FilaProveniente, -1, strtoint(SenhaAtendida), IniTime, NowTime);

    if FilaProveniente > 0 then
      AtualizaAtendimentoUltimos10(FilaProveniente, IniTime);

    frmSicsSituacaoAtendimento.UpdatePASituation(IdPA, '---', -1, nowtime);

    if NF > 0  then
      InsertPswd(NF,strtoint(SenhaAtendida),nowtime,-2,IdPA)
    else
      EnviarPushDeSenhaFinalizada(SenhaAtendida);

    if (VerificaChamadaAutomatica (IdPA) and (not SomenteRedirecionar)) then  //REV4.4 DEBUG MARCOS - COLOQUEI DAQUI AO INVÉS DE DENTRO DE UpdatePASituation
      Result := Proximo(IdPA,IniTime);                  //REV4.4 DEBUG MARCOS - COLOQUEI DAQUI AO INVÉS DE DENTRO DE UpdatePASituation

  end;  { if SenhaAtendida <> '---' }
end;  { func Redireciona }


function TfrmSicsMain.RedirecionaEProximo (IdPA, NF : integer) : integer;
var
  SenhaAtendida          : string;
  IniTime                : TDateTime;
  idAtd, FilaProveniente : integer;
  StatusPA               : TStatusPA;
  MotivoPausa            : integer;
begin
  frmSicsSituacaoAtendimento.GetPASituation (idPA, StatusPa, idAtd, SenhaAtendida, FilaProveniente, MotivoPausa, IniTime);

  if idAtd = -1 then
  begin
    Result := -5;
    Exit;
  end;

  if VerificaChamadaAutomatica (IdPA)then
     SomenteRedirecionar := True;

  if (SenhaAtendida <> '---') then
  begin
    if (NF <> 0) then
      InsertPswd(NF,strtoint(SenhaAtendida),now,-2,IdPA)
    else
      EnviarPushDeSenhaFinalizada(SenhaAtendida);
  end;

   SomenteRedirecionar := False;

  Result := Proximo(IdPA,IniTime);
end;  { func RedirecionaEProximo }


function TfrmSicsMain.RedirecionaEEspecifica (IdPA, NF, Pswd : integer) : integer;
var
  SenhaAtendida, NomeFila                  : string;
  IniTime                                  : TDateTime;
  idAtd, FilaOndeEstaPswd, FilaProveniente : integer;
  StatusPA               : TStatusPA;
  MotivoPausa            : integer;
begin
  FilaOndeEstaPswd := ProcuraNasFilas(Pswd, NomeFila, IniTime);

  if FilaOndeEstaPswd < 0 then
    Result := -1
  else if not (ExisteAFilaNaOrdemDasFilasDaPA (FilaOndeEstaPswd,IdPA)) then   //REPETIR ESTE CÓDIGO NA PROCEDURE DE CHAMAR ESPECÍFICA
    Result := -3
  else
  begin
    frmSicsSituacaoAtendimento.GetPASituation (idPA, StatusPA, idAtd, SenhaAtendida, FilaProveniente, MotivoPausa, IniTime);

    if (SenhaAtendida <> '---') then
    begin
      if (NF <> 0) then
      begin
       SomenteRedirecionar := True;
       InsertPswd(NF,strtoint(SenhaAtendida),now,-2,IdPA);
       SomenteRedirecionar := False;
      end
      else
        EnviarPushDeSenhaFinalizada(SenhaAtendida);
    end;

    Result := ChamaEspecifica (IdPA, Pswd, IniTime);
  end;  { if Result > 0 }
end;  { func RedirecionaEEspecifica }


function TfrmSicsMain.RedirecionaEForca (IdPA, NF, Pswd : integer) : integer;
var
  SenhaAtendida          : string;
  IniTime                : TDateTime;
  idAtd, FilaProveniente : integer;
  StatusPA               : TStatusPA;
  MotivoPausa            : integer;
  IdFila                 : integer;
  NomeFila               : string;
begin
  frmSicsSituacaoAtendimento.GetPASituation (idPA, StatusPA, idAtd, SenhaAtendida, FilaProveniente, MotivoPausa, IniTime);

  if (SenhaAtendida <> '---') then
  begin
    if (NF <> 0) then
    begin
      SomenteRedirecionar := True;
      InsertPswd(NF,strtoint(SenhaAtendida),now,-2,IdPA);
      SomenteRedirecionar := False;
    end
    else
      EnviarPushDeSenhaFinalizada(SenhaAtendida);
  end;

  Result := ForcaChamada (IdPA, Pswd, IniTime, IdFila, NomeFila);
end;  { func RedirecionaEForca }


procedure TfrmSicsMain.GeraSenhaEImprime(Fila, IdTotem: Integer; ATAGsAtribuir: String; out Senha: Integer; out DtHr: TDateTime);
var
  i    : Integer;
  LTAGs: TStrings;
begin
  GeraSenhaEImprime(Fila, IdTotem, Senha, DtHr);

  LTAGs := TStringList.Create;

  try
    LTAGs.Clear;

    LTAGs.Delimiter     := ';';
    LTAGs.DelimitedText := ATAGsAtribuir;

    for i := 0 to LTAGs.Count - 1 do
      frmSicsMain.DefinirTagParaSenha(Senha, StrToInt('$' + LTAGs[i]));
  finally
    LTAGs.Free;
  end;
end;

function TfrmSicsMain.GetIdTicket(Senha: Integer): Integer;
begin
  Result := -1;

  //if frmSicsMain.cdsIdsTickets.Locate('NUMEROTICKET', Senha, []) then
  if BuscarMaxIDSenha(Senha) then
    Result := frmSicsMain.cdsIdsTickets.FieldByName('ID').AsInteger;
end;


function TfrmSicsMain.GetIdTicketIfPwdExists(Senha: Integer): Integer;
var
  Tmp1, Tmp2: Integer;
begin
  result := GetIdTicketIfPwdExists(Senha, Tmp1, Tmp2);
end;

function TfrmSicsMain.GetIdTicketIfPwdExists(Senha: Integer; out IdFila, IdPA: Integer): Integer;
var
  LStr: String;
  LDtHr: TDateTime;
begin
  IdFila := -1;
  IdPA := -1;

  IdFila := ProcuraNasFilas(Senha, LStr, LDtHr);

  if IdFila < 0 then
    IdPA := ProcuraNasPAs(Senha, LStr, LDtHr);

  if (IdFila < 0) and (IdPA < 0) then
    exit(-1);

  result := GetIdTicket(Senha);
end;

function TfrmSicsMain.DefinirTagParaSenha(Senha, IdTag: Integer): Integer;
var
  Fila : integer;
  NomeFila : string;
  DataHoraSenha : TDateTime;
begin
  //if cdsIdsTickets.Locate('NumeroTicket', Senha, []) and RegistraTicketTag(cdsIdsTickets.FieldByName('Id').AsInteger, IdTag) then
  if BuscarMaxIDSenha(Senha) and RegistraTicketTag(cdsIdsTickets.FieldByName('Id').AsInteger, IdTag) then
  begin
    Result := 0;

    //Se esta senha estiver em espera, atualiza o StringGrid da fila em que se encontra em espera
    //  e o "SalvaSituacao_Fila" envia para os OnLines atualizarem seus grids também
    Fila := ProcuraNasFilas(Senha, NomeFila, DataHoraSenha);
    if Fila <> -1 then
    begin
      AtualizaTagsNoStringGrid(Senha, (FindComponent('SenhasList' + inttostr(Fila))) as TStringGrid);
      SalvaSituacao_Fila(Fila);
    end;
  end
  else
    Result := 1;
end;

function TfrmSicsMain.DesassociarTagParaSenha(Senha, IdTag: Integer): Integer;
var
  Fila : integer;
  NomeFila : string;
  DataHoraSenha : TDateTime;
begin
  //if cdsIdsTickets.Locate('NumeroTicket', Senha, []) and DesRegistraTicketTag(cdsIdsTickets.FieldByName('Id').AsInteger, IdTag) then
  if BuscarMaxIDSenha(Senha) and DesRegistraTicketTag(cdsIdsTickets.FieldByName('Id').AsInteger, IdTag) then
  begin
    Result := 0;

    //Se esta senha estiver em espera, atualiza o StringGrid da fila em que se encontra em espera
    //  e o "SalvaSituacao_Fila" envia para os OnLines atualizarem seus grids também
    Fila := ProcuraNasFilas(Senha, NomeFila, DataHoraSenha);
    if Fila <> -1 then
    begin
      AtualizaTagsNoStringGrid(Senha, (FindComponent('SenhasList' + inttostr(Fila))) as TStringGrid);
      SalvaSituacao_Fila(Fila);
    end;
  end
  else
    Result := 1;
end;

function TfrmSicsMain.DefinirNomeParaSenha(Senha: Integer; Nome: string): Boolean;
var
  NF: Integer;
  NomeFila: String;
  DtHrSenha: TDateTime;
begin
  Result := false;
  //if (Senha <> -1) and (cdsIdsTickets.Locate('NumeroTicket', Senha, [])) then
  if (Senha <> -1) and (BuscarMaxIDSenha(Senha)) then
  begin
    if RegistraTicketNome(cdsIdsTickets.FieldByName('Id').AsInteger, Nome) then
    begin
      cdsIdsTickets.Edit;
      cdsIdsTickets.FieldByName('NomeCliente').AsString := Nome;
      cdsIdsTickets.Post;
      cdsIdsTickets.ApplyUpdates(0);
 
      SetNomeCliente(cdsIdsTickets.FieldByName('Id').AsInteger, rnSenha, Nome);

      frmSicsSituacaoAtendimento.UpdateNomeDoCliente(Senha, Nome);

      frmSicsProcessosParalelos.UpdateNomeDoCliente(Senha, Nome);

      NF := ProcuraNasFilas(Senha, NomeFila, DtHrSenha);
      if NF > 0 then
        SetNomeDoClienteNoStringGrid(NF, Senha, Nome);
      Result := True;
    end;
  end;
end;

{ ----------------------------------------------------------------------- }

function PreencheDadosAdicionaisAImprimirNaSenha(Senha : integer) : boolean;
var
  LJSONObj         : TJSONObject;
  LTicket          : Integer;
  i                : integer;

  //Mostra apenas o primeiro nome + a primeira letra do segundo nome, e depois asteriscos
  //  Se o segundo nome tiver só 2 letras ou menos, mostra o segundo nome inteiro também e mais a primeira letra do terceiro nome, e depois asteriscos
  function MascararNome (s : string) : string;
  begin
    Result := Copy (s, 1, Pos(' ', s));
    s := Copy(s, Pos(' ', s)+1);

    if length(Copy (s, 1, Pos(' ', s) - 1)) <= 2 then
    begin
      Result := Result + Copy (s, 1, Pos(' ', s));
      s := Copy(s, Pos(' ', s)+1);
    end;

    Result := Result + Copy (s, 1, 2) + '****';
  end;

begin
  Result := false;
  for i := Low(vgParametrosModulo.DadosAdicionaisAImprimirNaSenha) to High(vgParametrosModulo.DadosAdicionaisAImprimirNaSenha) do
  begin
    vgParametrosModulo.DadosAdicionaisAImprimirNaSenha[i].Valor := '';
    if vgParametrosModulo.DadosAdicionaisAImprimirNaSenha[i].Chave <> '' then
      Result := true;
  end;

  if Result then
  begin
    LTicket  := frmSicsMain.GetIdTicketIfPwdExists(Senha);
    LJSONObj := dmSicsMain.GetDadosAdicionais(LTicket);
    try
      if Assigned(LJSONObj) then
      begin
        for i := Low(vgParametrosModulo.DadosAdicionaisAImprimirNaSenha) to High(vgParametrosModulo.DadosAdicionaisAImprimirNaSenha) do
          if vgParametrosModulo.DadosAdicionaisAImprimirNaSenha[i].Chave <> '' then
          begin
            if UpperCase(vgParametrosModulo.DadosAdicionaisAImprimirNaSenha[i].Chave) = 'NOME' then
              vgParametrosModulo.DadosAdicionaisAImprimirNaSenha[i].Valor := MascararNome(frmSicsMain.GetNomeParaSenha(Senha))
            else
              LJSONObj.TryGetValue(vgParametrosModulo.DadosAdicionaisAImprimirNaSenha[i].Chave , vgParametrosModulo.DadosAdicionaisAImprimirNaSenha[i].Valor)
          end
          else
            break;
      end;
    finally
      if Assigned(LJSONObj) then
        LJSONObj.Free;
    end;
  end;
end;

// ZEBRA - CABEÇALHO SICS:
// ^FO00,60^AQN,40,50^FB455,0,,C^FDS   I   C   S^FS
// ^FO00,100^A0N,20,20^FB455,0,,C^FDSISTEMA INTELIGENTE DE CHAMADA DE SENHAS^FS

// s1 := '^XA';//^LL674^MNN';
// s1 := s1 + '^FO00,60^AQN,40,50^FB455,0,,C^FDS   I   C   S^FS';
// s1 := s1 + '^FO00,100^A0N,20,20^FB455,0,,C^FDSISTEMA INTELIGENTE DE CHAMADA DE SENHAS^FS';
// s1 := s1 + vlCabecalhoTicket;
// s1 := s1 + '^FO00,200^AQN,42,38^FB455,0,,C^FDSENHA:  ' + inttostr(Senha) + '^FS';
// s1 := s1 + '^FO00,280^A0N,20,40^FB455,0,,C^FD' + NomeDaFilaNoTicket + '^FS';
// s1 := s1 + '^FO00,360^ACN,20,10^FB455,0,,C^FD' + FormatDateTime ('dd/mm/yy   hh:nn', NowTime) + '^FS';
// s1 := s1 + '^FO00,440^A0N,20,20^FB455,0,,C^FDAGUARDE A CHAMADA DE SUA SENHA NO PAINEL^FS';
// s1 := s1 + '^FO00,470^A0N,30,35^FB455,0,,C^FDOBRIGADO^FS';
// s1 := s1 + '^FO00,554^ABN,10,10^FB455,0,,C^FD---------------------------------------------^FS';
// s1 := s1 + '^FO00,565^AQN,30,30^FB455,0,,C^FDSENHA ' + inttostr(Senha) + '   ' + FormatDateTime ('dd/mm/yy   hh:nn', NowTime) + '^FS';
// s1 := s1 + '^FO77,590^BY2^B3N,,70,N^FD' + inttostr(Senha) + '^FS';
// s1 := s1 + '^XZ';

procedure TfrmSicsMain.PrintPassword(IdPrinter, Senha: Integer; fila: Integer);
type
  TTipoDeFonte = (tfNormal, tfCondensado, tfExpandido);
const
  LarguraDaLinha: array [TTipoDeImpressora, TTipoDeFonte] of Integer = ((48, 64, 24), (40, 0, 20), (40, 0, 20), (36, 0, 18), (48, 0, 24), (42, 59, 21), (42, 59, 21));
var
  s1, s2, aux1, aux2                 : string;
  NomeDaFilaNoTicket, RodapeImpressao: string;
  NowTime                            : TDateTime;
  TipoDaImpressora                   : TTipoDeImpressora;
  i                                  : integer;
begin
  if IdPrinter > 0 then
  begin
    try
      // Termica Bematech  : Modo normal 48  Condensado 64  Expandido 24
      // Termica Mecaf 57mm: Modo normal 40  Condensado --  Expandido 20
      // Termica Zebra     : Modo normal 40  Condensado --  Expandido 20
      // Matricial         : Modo normal 40  Condensado 52  Expandido 20
      // 1234567 101234567 201234567 301234567 401234567 501234567 601234
  //    if IdPrinter = 0 then
  //    begin
  //      TipoDaImpressora := GetModeloImpressoraZero;
  //      IdPrinter        := 1;
  //      // LBC MRZ - COLOCANDO ISTO NA Versão 4.3 Rev.B 19/07/13, TESTAR DIREITO
  //    end
  //    else
  //      TipoDaImpressora := vlTotens[IdPrinter].TipoImpressora;

      TipoDaImpressora := vlTotens[IdPrinter].TipoImpressora;

      NowTime := now;
      if ((vlTotens[IdPrinter].Opcoes.ImprimirCodigoDeBarrasSenha) and (TipoDaImpressora = tiBematech)) then
      begin
        ConfiguraCDBBematech(IdPrinter);
        Delay(250);
      end;
      if TipoDaImpressora = tiFujitsu then
      begin
        InicializaImpressoraFujitsu(IdPrinter);
        Delay(80);
      end
      else if TipoDaImpressora = tiSeiko then
      begin
        InicializaImpressoraSeiko(IdPrinter);
        Delay(80);
      end
      else if TipoDaImpressora = tiCustom then
      begin
        InicializaImpressoraCustom(IdPrinter);
        Delay(80);
      end;

      NomeDaFilaNoTicket := NGetNomeDaFilaNoTicket(fila);
      NGetPrinterMsg(IdPrinter, RodapeImpressao);

      if TipoDaImpressora = tiZebra then
      begin
        ConverteProtocoloImpressora(NomeDaFilaNoTicket, NomeDaFilaNoTicket, TipoDaImpressora);

        s1 := '^XA^MTD^MD20~SD00^CI0^XZ';
        Imprime(IdPrinter, s1);
        Delay(100);

        s1 := '^XA^LL663^PW456';
        s1 := s1 + LoadCabecalhoTicket(IdPrinter);
        s1 := s1 + '^FO00,140^AQN,42,38^FB455,0,,C^FDSENHA:  ' + IntToStr(Senha) + '^FS';
        s1 := s1 + '^FO00,220^A0N,20,40^FB455,0,,C^FD' + NomeDaFilaNoTicket + '^FS';
        s1 := s1 + '^FO00,300^ACN,20,10^FB455,0,,C^FD' + FormatDateTime('dd/mm/yy   hh:nn', NowTime) + '^FS';
        if RodapeImpressao <> '' then
        begin
          s1 := s1 + '^FO00,370^A0N,20,20^FB455,0,,C^FDAGUARDE A CHAMADA DE SUA SENHA NO PAINEL^FS';
          s1 := s1 + '^FO00,400^A0N,30,35^FB455,0,,C^FDOBRIGADO^FS';
          SeparaStrings(RodapeImpressao, '{{Quebra de Linha}}', aux1, aux2);
          ConverteProtocoloImpressora(aux1, aux1, TipoDaImpressora);
          ConverteProtocoloImpressora(aux2, aux2, TipoDaImpressora);
          s1 := s1 + '^FO00,450^ACN,20,10^FB455,0,,C^FD' + aux1 + '^FS';
          s1 := s1 + '^FO00,470^ACN,20,10^FB455,0,,C^FD' + aux2 + '^FS';
        end
        else
        begin
          s1 := s1 + '^FO00,400^A0N,20,20^FB455,0,,C^FDAGUARDE A CHAMADA DE SUA SENHA NO PAINEL^FS';
          s1 := s1 + '^FO00,430^A0N,30,35^FB455,0,,C^FDOBRIGADO^FS';
        end;
        s1 := s1 + '^FO00,510^AQN,30,30^FB455,0,,C^FDSENHA ' + IntToStr(Senha) + '   ' + FormatDateTime('dd/mm/yy   hh:nn', NowTime) + '^FS';
        s1 := s1 + '^FO77,535^BY2^B3N,,70,N^FD' + IntToStr(Senha) + '^FS';
        s1 := s1 + '^XZ';

        Imprime(IdPrinter, s1);
      end
      else
      begin
        s1 := '';

        if vlTotens[IdPrinter].Opcoes.CorteParcialAoFinal then
          s1 := s1 + '{{Quebra de Linha}}';

        // ********************************************************************************
        // Analisar com LBC erro ao chamar método das DLL's
        // ********************************************************************************
        s1 := s1 + LoadCabecalhoTicket(IdPrinter);

        s1 := s1 + '{{Liga Altura Dupla}}{{Liga Largura Dupla}}{{Liga Negrito}}{{Liga Largura Dupla, Altura Dupla e Negrito}}' + FormatCenterString(LarguraDaLinha[TipoDaImpressora, tfExpandido], 'SENHA:  ' + IntToStr(Senha), false) +
          '{{Desliga Negrito}}{{Desliga Largura Dupla}}{{Desliga Altura Dupla}}{{Quebra de Linha}}{{Quebra de Linha}}';

        if Trim(NomeDaFilaNoTicket) <> '' then
          s1 := s1 + '{{Liga Largura Dupla}}' + FormatCenterString(LarguraDaLinha[TipoDaImpressora, tfExpandido], NomeDaFilaNoTicket, false) + '{{Desliga Largura Dupla}}{{Quebra de Linha}}{{Quebra de Linha}}';

        s1 := s1 + FormatCenterString(LarguraDaLinha[TipoDaImpressora, tfNormal], FormatDateTime('dd/mm/yy   hh:nn', NowTime), false) + '{{Quebra de Linha}}{{Quebra de Linha}}';

        if PreencheDadosAdicionaisAImprimirNaSenha(Senha) then
        begin
          for i := Low(vgParametrosModulo.DadosAdicionaisAImprimirNaSenha) to High(vgParametrosModulo.DadosAdicionaisAImprimirNaSenha) do
            if vgParametrosModulo.DadosAdicionaisAImprimirNaSenha[i].Chave <> '' then
              s1 := s1 + FormatCenterString(LarguraDaLinha[TipoDaImpressora, tfNormal], vgParametrosModulo.DadosAdicionaisAImprimirNaSenha[i].Chave + ': ' + vgParametrosModulo.DadosAdicionaisAImprimirNaSenha[i].Valor, false) + '{{Quebra de Linha}}';

           s1 := s1 + '{{Quebra de Linha}}';
        end;

        s1 := s1 + FormatCenterString(LarguraDaLinha[TipoDaImpressora, tfNormal], 'AGUARDE A CHAMADA DA SENHA NO PAINEL', false) + '{{Quebra de Linha}}';
        s1 := s1 + '{{Liga Largura Dupla}}' + FormatCenterString(LarguraDaLinha[TipoDaImpressora, tfExpandido], 'OBRIGADO', false) + '{{Desliga Largura Dupla}}{{Quebra de Linha}}{{Quebra de Linha}}';

        if RodapeImpressao <> '' then
          s1 := s1 + '{{Liga Condensado}}' + RodapeImpressao + '{{Desliga Condensado}}{{Quebra de Linha}}{{Quebra de Linha}}';

        if vlTotens[IdPrinter].Opcoes.ImprimirCodigoDeBarrasSenha then
        begin
          s1 := s1 + '______________________________{{Quebra de Linha}}';

          if vlTotens[IdPrinter].Opcoes.PicoteEntreVias then
          begin
            if (TipoDaImpressora = tiFujitsu) then
              s1 := s1 + '{{Quebra de Linha}}{{Quebra de Linha}}{{Corte Parcial}}'
            else
              s1 := s1 + '{{Corte Parcial}}{{Quebra de Linha}}'
          end;

          s1 := s1 + '{{Liga Largura Dupla}}{{Liga Negrito}}{{Liga Largura Dupla e Negrito}}' + FormatCenterString(LarguraDaLinha[TipoDaImpressora, tfExpandido], 'SENHA ' + IntToStr(Senha), false) + '{{Desliga Negrito}}{{Desliga Largura Dupla}}{{Quebra de Linha}}';

          if vlTotens[IdPrinter].Opcoes.ImprimirDataEHoraNaSegundaVia then
            s1 := s1 + '{{Liga Largura Dupla}}' + FormatCenterString(LarguraDaLinha[TipoDaImpressora, tfExpandido], FormatDateTime('dd/mm/yy   hh:nn', NowTime), false) + '{{Desliga Largura Dupla}}{{Quebra de Linha}}';

          if vlTotens[IdPrinter].Opcoes.ImprimirNomeDaFilaNaSegundaVia then
            if Trim(NomeDaFilaNoTicket) <> '' then
              s1 := s1 + '{{Liga Largura Dupla}}' + FormatCenterString(LarguraDaLinha[TipoDaImpressora, tfExpandido], NomeDaFilaNoTicket, false) + '{{Desliga Largura Dupla}}{{Quebra de Linha}}{{Quebra de Linha}}';

          ConverteProtocoloImpressora(s2, s1, TipoDaImpressora);

          Imprime(IdPrinter, s2);

          { Codigo de barras padrao CODE39 }
          s1 := '{{CDB Code39}}' + FormatLeftString(10, '%TCK' + IntToStr(Senha) + '$') + '{{Fim de Bloco CDB Code39}}';

          ConverteProtocoloImpressora(s2, s1, TipoDaImpressora);

          Imprime(IdPrinter, s2);

          s1 := '';
        end; { if ImprimirCodigoDeBarras }

        if ((TipoDaImpressora = tiFujitsu) or (TipoDaImpressora = tiSeiko) or (not vlTotens[IdPrinter].Opcoes.PicoteEntreVias)) then
          s1 := s1 + '{{Quebra de Linha}}{{Quebra de Linha}}{{Quebra de Linha}}';

        if vlTotens[IdPrinter].Opcoes.CorteParcialAoFinal then
          s1 := s1 + '{{Corte Parcial}}'
        else
          s1 := s1 + '{{Corte Total}}';

        ConverteProtocoloImpressora(s2, s1, TipoDaImpressora);

        TfrmDebugParameters.Debugar (tbGeracaoSenhas, 'Texto completo da Senha ' + Senha.ToString + ' foi gerado.' );
        Imprime(IdPrinter, s2);
      end;
    except
      Application.MessageBox('Erro ao imprimir senha.', 'Erro', MB_ICONSTOP);
    end;
  end;
end;

{ case PainelDigInicial senha of
  33  -> Modelo 3312 (Beta SICS similar ao 2311)
  351 ou 301 -> Modelo 3512 (Beta SICS similar ao 2511) parte inicial
  352 ou 302 -> Modelo 3512 (Beta SICS similar ao 2511) parte final
  291 -> Modelo 2910 parte inicial
  292 -> Modelo 2910 parte final
  251 -> Modelo 2510 parte inicial
  252 -> Modelo 2510 parte final
  91  -> H9J Guiches       (linha 1 do painel customizado)
  92  -> H9J Triagem       (linha 2 do painel customizado)
  93  -> H9J Consultorios  (linhas 3 e 4 do painel customizado + painel do corredor com endereço 02)
  94  -> H9J Retorno       (linha unica do painel do corredor  modelo 2DigPA + 3DigSENHA com endereço 02)
  95  -> H9J Pediatria     (linha unica do painel da pediatria modelo 3DigSENHA)
  96  -> H9J Consultorios  (linhas 3 e 4 do painel customizado + painel do corredor modelo 2306 com endereço 02)
  97  -> H9J Retorno       (linha unica do painel do corredor  modelo 2305 com endereço 02)
}

function TfrmSicsMain.CalculaTEE: String;
var LIDFila:   Integer;
    LNomeFila: String;
    LTempo: TDateTime;
    LQTDEPAProdutiva  :integer;
    LQTDEPessoasEspera:integer;
    LIDTEE            :integer;
begin
  //
  SysUtils.FormatSettings.ShortDateFormat := 'dd/mm/yyyy';
  SysUtils.FormatSettings.LongTimeFormat  := 'hh:nn:ss';

  dmSicsMain.cdsFilasClone.CloneCursor(dmSicsMain.cdsFilas, false, True);

  dmSicsMain.cdsFilasClone.First;
  while not dmSicsMain.cdsFilasClone.Eof do
  begin

    if dmSicsMain.cdsFilasClone.FieldByName('Ativo').AsBoolean then
    begin
      LIDFila   := dmSicsMain.cdsFilasClone.FieldByName('ID').AsInteger;
      LNomeFila := dmSicsMain.cdsFilasClone.FieldByName('Nome').AsString;

      try
        LTempo := CalculaTEE(LIDFila,LQTDEPAProdutiva,LQTDEPessoasEspera,LIDTEE);
      except
        LTempo := EncodeTime(23, 59, 59, 999);
      end;
    end;

    Result := Result + TAspEncode.AspIntToHex(LIDFila, 4) + LNomeFila + '|' + FormatDateTime('hh:nn:ss',LTempo) + TAB;

    dmSicsMain.cdsFilasClone.Next;
  end;
end;

procedure TfrmSicsMain.CallOnDisplay(IdPA, Pswd: Integer);
const
  H9JDisp3Line1: string[5] = '     ';
  H9JDisp3Line2: string[5] = '     ';
var
  s1, s2                                                      : string;
  IdGrupoPA, IdPainel, IdModeloPainel, PAMagazine, PAAutoRedir: Integer;
  PANome, PANomeNoPainel, PANomePorVoz                        : string;
  PainelNome, PainelEndereco, PainelEnderecoIP                : string;
  PAAtiva, PainelManterUltimaSenha, PainelMonitoramento       : Boolean;
  LIdTicket: Integer;
  LDeviceIdPush: String;
begin
  if ((not NGetPAData(IdPA, PAAtiva, IdGrupoPA, PANome, IdPainel, PANomeNoPainel, PANomePorVoz, PAMagazine, PAAutoRedir)) or (not PAAtiva) or (not NGetPainelData(IdPainel, PainelNome, PainelEndereco, IdModeloPainel, PainelEnderecoIP, PainelManterUltimaSenha, PainelMonitoramento))) then
  begin
    MyLogException(Exception.Create('Erro ao obter titulo de PA: ' + IntToStr(IdPA)));
    Exit;
  end;

  LIdTicket := GetIdTicket(Pswd);
  LDeviceIdPush := dmSicsMain.GetDeviceIdSenha(LIdTicket);
  if LDeviceIdPush <> EmptyStr then
    TPushSender.ChamadaDeSenha(LDeviceIdPush, Pswd.ToString, PANome);

  ClearOutBufferTimer.Enabled := false;
  try
    SenhaLabel.Caption  := 'Senha: ' + IntToStr(Pswd);
    GuicheLabel.Caption := PANome;
    if(PANomeNoPainel = '')then
      PANomeNoPainel := PANome;

    case TModeloPainel(IdModeloPainel) of
      mpTV:
        s2 := TAspEncode.AspIntToHex(IdPainel, 4) + Chr($73) + TAspEncode.AspIntToHex(IdPA, 4) + PANomeNoPainel + ';' + IntToStr(Pswd) + ';' + GetNomeParaSenha(Pswd) + ';' + PANomePorVoz;
      mpBetaBrite:
        begin
          s1 := '{{Efeito Manter}}{{Velocidade 1}}{{Fonte 7 LEDs Serifada}}' + '{{Ambar}}' + FormatNumber(4, Pswd) +
                '   {{Vermelho}}' + FormatRightString(3, PANomeNoPainel) +
                '{{Efeito Manter}}{{Efeito Manter}}{{Efeito Manter}}{{Efeito Manter}}{{Efeito Manter}}{{Efeito Manter}}';
          AspEZPorEnviaTexto(s1, s2, PainelEndereco, 0, false, false);
          WriteToDisplay(IdPainel, s2);
          Delay(300);
          s1 := '{{Especial Bipe 3x}}';
          AspEZPorEnviaTexto(s1, s2, PainelEndereco, 0, false, false);
        end;
      mpBetaSics_LadoEsquerdo:
        begin
          s1 := '{{Efeito Manter}}{{Velocidade 1}}{{Fonte 7 LEDs Serifada}}{{Caractere Largura Fixa}}' + '{{Vermelho}}' + FormatRightString(2, PANomeNoPainel) + '{{Meio Espaco}}{{Meio Espaco}}{{Ambar}}' + FormatNumber(4, Pswd) +
            '{{Efeito Manter}}{{Efeito Manter}}{{Efeito Manter}}{{Efeito Manter}}{{Efeito Manter}}{{Efeito Manter}}';
          AspEZPorEnviaTexto(s1, s2, PainelEndereco, 0, false, false);
          WriteToDisplay(IdPainel, s2);
          Delay(300);
          s1 := '{{Especial Bipe 3x}}';
          AspEZPorEnviaTexto(s1, s2, PainelEndereco, 0, false, false);
        end;
      mpBetaSics_LadoDireito:
        begin
          s1 := '{{Efeito Manter}}{{Velocidade 1}}{{Fonte 7 LEDs Serifada}}{{Caractere Largura Fixa}}' + '{{Meio Espaco}}{{Meio Espaco}}  {{Ambar}}' + FormatNumber(4, Pswd) + '{{Meio Espaco}}{{Meio Espaco}}{{Vermelho}}' + FormatRightString(2, PANomeNoPainel) +
            '{{Efeito Manter}}{{Efeito Manter}}{{Efeito Manter}}{{Efeito Manter}}{{Efeito Manter}}{{Efeito Manter}}';
          AspEZPorEnviaTexto(s1, s2, PainelEndereco, 0, false, false);
          WriteToDisplay(IdPainel, s2);
          Delay(300);
          s1 := '{{Especial Bipe 3x}}';
          AspEZPorEnviaTexto(s1, s2, PainelEndereco, 0, false, false);
        end;
      mp220:
        begin
          s1 := '{{Efeito Manter}}{{Velocidade 1}}{{Vermelho}}Senha: {{Fonte 7 LEDs Serifada}}{{Ambar}}' + IntToStr(Pswd) + '{{Fonte 7 LEDs}}{{Vermelho}} ' + PANomeNoPainel + '{{3 Bipes}}{{Efeito Manter}}{{Efeito Manter}}{{Efeito Manter}}{{Efeito Manter}}';
          AspEZPorEnviaTexto(s1, s2, PainelEndereco, 0, false, false);
          WriteToDisplay(IdPainel, s2);
          Delay(300);
          s1 := '{{Especial Bipe 1x}}';
          AspEZPorEnviaTexto(s1, s2, PainelEndereco, 0, false, false);
        end;
      mp4080:
        begin
          s1 := '{{Efeito Manter}}{{Velocidade 1}}{{Vermelho}}Senha: {{Fonte 7 LEDs Serifada}}{{Ambar}}' + IntToStr(Pswd) + '{{Nova Linha}}{{Fonte 7 LEDs}}{{Vermelho}}' + PANomeNoPainel +
            '{{3 Bipes}}{{Efeito Manter}}{{Efeito Manter}}{{Efeito Manter}}{{Efeito Manter}}{{Efeito Manter}}{{Efeito Manter}}';
          AspEZPorEnviaTexto(s1, s2, PainelEndereco, 0, false, false);
        end;
      mp2911_LadoEsquerdo:
        s2 := '!' + PainelEndereco + 'F01' + PANomeNoPainel + Copy(FormatNumber(3, Pswd), Length(FormatNumber(3, Pswd)) - 2, 3) + '  ' + '$';
      mp2911_LadoDireito:
        s2 := '!' + PainelEndereco + 'F01' + '  ' + Copy(FormatNumber(3, Pswd), Length(FormatNumber(3, Pswd)) - 2, 3) + PANomeNoPainel + '$';
      mp2511_LadoEsquerdo:
        s2 := '!' + PainelEndereco + 'F01' + PANomeNoPainel + Copy(FormatNumber(3, Pswd), Length(FormatNumber(3, Pswd)) - 2, 3) + ' ' + '$';
      mp2511_LadoDireito:
        s2 := '!' + PainelEndereco + 'F01' + ' ' + Copy(FormatNumber(3, Pswd), Length(FormatNumber(3, Pswd)) - 2, 3) + PANomeNoPainel + '$';
      mp2311, mp2411:
        s2 := '!' + PainelEndereco + 'F01' + Copy(FormatNumber(3, Pswd), Length(FormatNumber(3, Pswd)) - 2, 3) + PANomeNoPainel + '$';
      mpNumericoMultiLinhasLinha1:
        s2 := '!' + PainelEndereco + 'F01' + PANomeNoPainel + Copy(FormatNumber(3, Pswd), Length(FormatNumber(3, Pswd)) - 2, 3) + '$';
      mpNumericoMultiLinhasLinha2:
        s2 := '!' + PainelEndereco + 'F06' + PANomeNoPainel + Copy(FormatNumber(3, Pswd), Length(FormatNumber(3, Pswd)) - 2, 3) + '$';
      mpNumericoMultiLinhasLinha3:
        s2 := '!' + PainelEndereco + 'F0B' + PANomeNoPainel + Copy(FormatNumber(3, Pswd), Length(FormatNumber(3, Pswd)) - 2, 3) + '$';
      mp4120:
        begin
          s1 := '{{Efeito Manter}}{{Velocidade 1}}{{Verde}}' + NGetFilaName(NGetFilaFromRange(Pswd)) + '{{Nova Linha}}' + '{{Vermelho}}Senha {{Fonte 7 LEDs Serifada}}{{Ambar}}' + IntToStr(Pswd) + '{{Fonte 7 LEDs}}{{Vermelho}} ' + PANomeNoPainel +
            '{{3 Bipes}}{{Efeito Manter}}{{Efeito Manter}}{{Efeito Manter}}{{Efeito Manter}}{{Efeito Manter}}{{Efeito Manter}}';
          AspEZPorEnviaTexto(s1, s2, PainelEndereco, 0, false, false);
        end;
      // FAZER CUSTOMIZAÇÕES         91 : begin
      // FAZER CUSTOMIZAÇÕES                s2 := '!01E01' + PANomeNoPainel + FormatNumber(3,Pswd) + '$';
      // FAZER CUSTOMIZAÇÕES                WriteToDisplay(IdPainel, s2);
      // FAZER CUSTOMIZAÇÕES                Delay(500);
      // FAZER CUSTOMIZAÇÕES                s2 := '!01S2C02$';
      // FAZER CUSTOMIZAÇÕES              end;
      // FAZER CUSTOMIZAÇÕES         92 : begin
      // FAZER CUSTOMIZAÇÕES                s2 := '!01E06' + PANomeNoPainel + FormatNumber(3,Pswd) + '$';
      // FAZER CUSTOMIZAÇÕES                WriteToDisplay(IdPainel, s2);
      // FAZER CUSTOMIZAÇÕES                Delay(500);
      // FAZER CUSTOMIZAÇÕES                s2 := '!01S2C02$';
      // FAZER CUSTOMIZAÇÕES              end;
      // FAZER CUSTOMIZAÇÕES         93 : begin
      // FAZER CUSTOMIZAÇÕES                if H9JDisp3Line1 <> (PANomeNoPainel + FormatNumber(3,Pswd)) then
      // FAZER CUSTOMIZAÇÕES                begin
      // FAZER CUSTOMIZAÇÕES                  H9JDisp3Line2 := H9JDisp3Line1;
      // FAZER CUSTOMIZAÇÕES                  H9JDisp3Line1 := PANomeNoPainel + FormatNumber(3,Pswd);
      // FAZER CUSTOMIZAÇÕES                  s2 := '!01E11' + H9JDisp3Line1 + H9JDisp3Line2 + '$';
      // FAZER CUSTOMIZAÇÕES                  WriteToDisplay(IdPainel, s2);
      // FAZER CUSTOMIZAÇÕES                  Delay(500);
      // FAZER CUSTOMIZAÇÕES                  s2 := '!01S2C02$';
      // FAZER CUSTOMIZAÇÕES                  WriteToDisplay(IdPainel, s2);
      // FAZER CUSTOMIZAÇÕES                  Delay(500);
      // FAZER CUSTOMIZAÇÕES                  s2 := '!02E01' + H9JDisp3Line1 + '$';
      // FAZER CUSTOMIZAÇÕES                  WriteToDisplay(IdPainel, s2);
      // FAZER CUSTOMIZAÇÕES                  Delay(500);
      // FAZER CUSTOMIZAÇÕES                  s2 := '!02S2C02$';
      // FAZER CUSTOMIZAÇÕES                end
      // FAZER CUSTOMIZAÇÕES                else
      // FAZER CUSTOMIZAÇÕES                begin
      // FAZER CUSTOMIZAÇÕES                  s2 := '!01S2C02$';
      // FAZER CUSTOMIZAÇÕES                  WriteToDisplay(IdPainel, s2);
      // FAZER CUSTOMIZAÇÕES                  Delay(500);
      // FAZER CUSTOMIZAÇÕES                  s2 := '!02S2C02$';
      // FAZER CUSTOMIZAÇÕES                end;
      // FAZER CUSTOMIZAÇÕES              end;
      // FAZER CUSTOMIZAÇÕES         94 : begin
      // FAZER CUSTOMIZAÇÕES                s2 := '!02E01' + PANomeNoPainel + FormatNumber(3,Pswd) + '$';
      // FAZER CUSTOMIZAÇÕES                WriteToDisplay(IdPainel, s2);
      // FAZER CUSTOMIZAÇÕES                Delay(500);
      // FAZER CUSTOMIZAÇÕES                s2 := '!02S2C02$';
      // FAZER CUSTOMIZAÇÕES              end;
      // FAZER CUSTOMIZAÇÕES         95 : begin
      // FAZER CUSTOMIZAÇÕES                s2 := '!03E01' + FormatNumber(3,Pswd) + '$';
      // FAZER CUSTOMIZAÇÕES                WriteToDisplay(IdPainel, s2);
      // FAZER CUSTOMIZAÇÕES                Delay(500);
      // FAZER CUSTOMIZAÇÕES                s2 := '!03S2C02$';
      // FAZER CUSTOMIZAÇÕES              end;
      // FAZER CUSTOMIZAÇÕES         96 : begin
      // FAZER CUSTOMIZAÇÕES                if H9JDisp3Line1 <> (PANomeNoPainel + FormatNumber(3,Pswd)) then
      // FAZER CUSTOMIZAÇÕES                begin
      // FAZER CUSTOMIZAÇÕES                  H9JDisp3Line2 := H9JDisp3Line1;
      // FAZER CUSTOMIZAÇÕES                  H9JDisp3Line1 := PANomeNoPainel + FormatNumber(3,Pswd);
      // FAZER CUSTOMIZAÇÕES                  s2 := '!01E11' + H9JDisp3Line1 + H9JDisp3Line2 + '$';
      // FAZER CUSTOMIZAÇÕES                  WriteToDisplay(IdPainel, s2);
      // FAZER CUSTOMIZAÇÕES                  Delay(500);
      // FAZER CUSTOMIZAÇÕES                  s2 := '!01S2C02$';
      // FAZER CUSTOMIZAÇÕES                  WriteToDisplay(IdPainel, s2);
      // FAZER CUSTOMIZAÇÕES                  Delay(500);
      // FAZER CUSTOMIZAÇÕES                  s2 := '!02F01' + FormatNumber(3,Pswd) + PANomeNoPainel + '$';
      // FAZER CUSTOMIZAÇÕES                end
      // FAZER CUSTOMIZAÇÕES                else
      // FAZER CUSTOMIZAÇÕES                begin
      // FAZER CUSTOMIZAÇÕES                  s2 := '!01S2C02$';
      // FAZER CUSTOMIZAÇÕES                  WriteToDisplay(IdPainel, s2);
      // FAZER CUSTOMIZAÇÕES                  Delay(500);
      // FAZER CUSTOMIZAÇÕES                  s2 := '!02F01' + FormatNumber(3,Pswd) + PANomeNoPainel + '$';
      // FAZER CUSTOMIZAÇÕES                end;
      // FAZER CUSTOMIZAÇÕES              end;
      // FAZER CUSTOMIZAÇÕES         97 : begin
      // FAZER CUSTOMIZAÇÕES                 s2 := '!' + PainelEndereco + 'F01' + Copy(FormatNumber(3,Pswd), length(FormatNumber(3,Pswd))-2, 3) + PANomeNoPainel + '$'
      // FAZER CUSTOMIZAÇÕES              end;
    else
      begin
        AppMessageBox('Erro ao obter modelo de Painel. PA: ' + IntToStr(IdPA), 'Erro', MB_ICONSTOP);
        Exit;
      end; { else }
    end;   { case }

    WriteToDisplay(IdPainel, s2);
  finally
    ClearOutBufferTimer.Enabled := True;
  end; { try .. finally }
end;   { proc CallOnDisplay }

procedure TfrmSicsMain.ClearDisplay(IdPainel: Integer);
var
  s1, s2                                      : string;
  IdModeloPainel                              : Integer;
  PainelNome, PainelEndereco, PainelEnderecoIP: string;
  PainelManterUltimaSenha, PainelMonitoramento: Boolean;
begin
  if not NGetPainelData(IdPainel, PainelNome, PainelEndereco, IdModeloPainel, PainelEnderecoIP, PainelManterUltimaSenha, PainelMonitoramento) then
  begin
    AppMessageBox('Erro ao obter dados de Painel: ' + IntToStr(IdPainel), 'Erro', MB_ICONSTOP);
    Exit;
  end;

  SenhaLabel.Caption  := 'Mensagem';
  GuicheLabel.Caption := 'Institucional';

  case TModeloPainel(IdModeloPainel) of
    mpBetaBrite, mpBetaSics_LadoEsquerdo, mpBetaSics_LadoDireito, mp220, mp4080, mp4120:
      begin
        s1 := '';
        AspEZPorEnviaTexto(s1, s2, PainelEndereco, 0, false, false);
      end;
    mpTV:
      s2 := TAspEncode.AspIntToHex(IdPainel, 4) + Chr($73);
  else
    s2 := '!' + PainelEndereco + 'C$';
  end; { case }

  WriteToDisplay(IdPainel, s2);
end; { proc ClearDisplay }

procedure TfrmSicsMain.WriteToDisplay(const IdPainel: Integer; aProtocolo: string);
var
  I, IdModeloPainel                           : Integer;
  PainelNome, PainelEndereco, PainelEnderecoIP: string;
  PainelManterUltimaSenha, PainelMonitoramento: Boolean;
  EnderecosIP                                 : TConexaoIPArray;
begin
  if (IdPainel <> 0) and (not NGetPainelData(IdPainel, PainelNome, PainelEndereco, IdModeloPainel, PainelEnderecoIP, PainelManterUltimaSenha, PainelMonitoramento)) then
  begin
    AppMessageBox('Erro ao obter dados de Painel: ' + IntToStr(IdPainel), 'Erro', MB_ICONSTOP);
    Exit;
  end;

  if PainelEnderecoIP <> '' then
  begin
    if AnsiUpperCase(PainelEnderecoIP) = 'S' then
    begin
      for I := 1 to vlNumeroDePainelClientSockets do
      begin
        if FindComponent('PainelClientSocket' + IntToStr(I)) <> nil then
          with (FindComponent('PainelClientSocket' + IntToStr(I)) as TClientSocket) do
            if Active then
              EnviaComando(Socket, aProtocolo);
      end;
    end
    else
    begin
      EnderecosIP := StrToConexaoIpArray(PainelEnderecoIP);
      try
        for I := 1 to vlNumeroDePainelClientSockets do
        begin
          if FindComponent('PainelClientSocket' + IntToStr(I)) <> nil then
            with (FindComponent('PainelClientSocket' + IntToStr(I)) as TClientSocket) do
              if ((Active) and (ExisteNoIPArray(Socket.RemoteAddress, EnderecosIP))) then
                EnviaComando(Socket, aProtocolo);
        end;
      finally
        Finalize(EnderecosIP);
      end;
    end;
  end
  else if PainelTcpPort.Active then
  begin
    aProtocolo := Chr(1) + Chr(1) + aProtocolo + Chr(4) + Chr(4);
    for I := 0 to PainelTcpPort.Socket.ActiveConnections - 1 do
      EnviaComando(PainelTcpPort.Socket.Connections[I], aProtocolo);
  end
  else if PainelPort.Active then
  begin
    PainelPort.WriteText(AspStringToAnsiString(aProtocolo));
  end;

  Delay(200);
end; { proc WriteToDisplay }

procedure TfrmSicsMain.ConfiguraCDBBematech(IdPrinter: Integer);
var
  S: string;
begin
  { configura largura da barra do codigo de barras para "grossa" }
  S := #29#119#2;
  Imprime(IdPrinter, S);

  Delay(250);

  { configura para nao aparecer o texto no codigo de barras }
  S := #29#72#0;
  Imprime(IdPrinter, S);
end;

procedure TfrmSicsMain.InicializaImpressoraFujitsu(IdPrinter: Integer);
var
  S: string;
begin
  { configura alinhamento à esquerda }
  S := #$1B#$61#$00;
  Imprime(IdPrinter, S);
end;

//JSL - Modifiquei a "procedure" abaixo para que permita a impressão de caracteres especiais
//      na impressora do tipo SEIKO. Antes, caracteres orientais eram impressos...
procedure TfrmSicsMain.InicializaImpressoraSeiko(IdPrinter: Integer);
const
  CMD_DesabilitaChines          = #$1C#$2E; //JLS
  CMD_AtivaCodePage850          = #$1B#$74#$02;
  CMD_ConfigAlinhamentoEsquerda = #$1B#$61#$00; //JLS
var
  S: string;
begin
  S := CMD_DesabilitaChines + CMD_AtivaCodePage850 + CMD_ConfigAlinhamentoEsquerda; //JLS
  Imprime(IdPrinter, S);
end;

procedure TfrmSicsMain.InicializaImpressoraCustom(IdPrinter: Integer);
var
  S: string;
begin
  { configura alinhamento à esquerda }
  S := #$1B#$61#$00;
  Imprime(IdPrinter, S);
end;

{ protocolo "Zebra", criado para comunicação entre Servidor e OnLine é igual Bematech:
  !Ix$, onde:
  ! = caractere "!" (ASCII 21h) = início de bloco
  I = caractere "I" (ASCII 49h) = informativo de status da impressora
  x = um byte, onde: bit 0 (LSB) indica 1=OnLine     / 0=OffLine
  bit 1 (LSB) indica 1=SemPapel   / 0=ComPapel
  bit 2 (LSB) indica 1=PoucoPapel / 0=BastantePapel
  $ = caractere "$" (ASCII 24h) = início de bloco }
procedure TfrmSicsMain.DecifraProtocoloTotem(IdPrinter: Integer; S: string);

  procedure EnviaStatusDePapelEOnLineParaTotem (IdPrinter: Integer; normalizar: Boolean);
  begin
    if normalizar then
      Imprime(IdPrinter, FormatarProtocolo ('0000' + Chr($37) + '1'))
    else
      Imprime(IdPrinter, FormatarProtocolo ('0000' + Chr($37) + '0'));
  end;

var
  TipoDaImpressora: TTipoDeImpressora;
  SenhaGerada: Integer;
  LDtHrSenha: TDateTime;
begin
  TfrmDebugParameters.Debugar (tbGeracaoSenhas, 'Entrou DecifraProtocoloTotem');

  if IdPrinter = 0 then
    TipoDaImpressora := GetModeloImpressoraZero
  else
    TipoDaImpressora := vlTotens[IdPrinter].TipoImpressora;  //LBC 02/09/16 ESTAVA    TipoDaImpressora := vlTotens[1].TipoImpressora;    ACHO QUE ESTÁ ERRADO E TROQUEI

  if ((Length(S) >= 3) and (S[1] = '!') and (S[Length(S)] = '$')) then
  begin
    case S[2] of
      'B' : if FindComponent('BitBtn' + IntToStr(vlTotens[IdPrinter].Botoes[ord(S[3])])) <> nil then
              GeraSenhaEImprime(vlTotens[IdPrinter].Botoes[ord(S[3])], IdPrinter, SenhaGerada, LDtHrSenha);
      'I' : begin
              vlTotens[IdPrinter].KeepAliveTimeout := 2; { 40 segundos }


              if (stSemConexao in vlTotens[IdPrinter].StatusTotem) then
                EnviaEmail(IdPrinter, stSemConexao, True);
              vlTotens[IdPrinter].StatusTotem := vlTotens[IdPrinter].StatusTotem - [stSemConexao];

              if (((TipoDaImpressora = tiBematech) and (ord(S[3]) and 1 = 0 )) or
                  ((TipoDaImpressora = tiMecaf   ) and (ord(S[3]) and 2 <> 0)) or
                  ((TipoDaImpressora = tiZebra   ) and (ord(S[3]) and 1 = 0 )) or
                  ((TipoDaImpressora = tiFujitsu ) and (ord(S[3]) and 1 = 0 ))
                  // Seiko não tem status de online/offline   ((TipoDaImpressora = tiSeiko   ) and (ord(s[3]) and 1 = 0 ))
                 ) then
              begin
                if not(stOffLine in vlTotens[IdPrinter].StatusTotem) then
                begin
                  EnviaEmail(IdPrinter, stOffLine, false);
                  EnviaStatusDePapelEOnLineParaTotem (IdPrinter, false);
                end;
                vlTotens[IdPrinter].StatusTotem := vlTotens[IdPrinter].StatusTotem + [stOffLine];
              end
              else
              begin
                if (stOffLine in vlTotens[IdPrinter].StatusTotem) then
                begin
                  EnviaEmail(IdPrinter, stOffLine, True);
                  EnviaStatusDePapelEOnLineParaTotem (IdPrinter, true);
                end;
                vlTotens[IdPrinter].StatusTotem := vlTotens[IdPrinter].StatusTotem - [stOffLine];
              end;

              if (((TipoDaImpressora = tiBematech) and (ord(S[3]) and 2 <> 0)) or
                  ((TipoDaImpressora = tiMecaf   ) and (ord(S[3]) and 1 <> 0)) or
                  ((TipoDaImpressora = tiZebra   ) and (ord(S[3]) and 2 <> 0)) or
                  ((TipoDaImpressora = tiFujitsu ) and (ord(S[3]) and 2 <> 0)) or
                  ((TipoDaImpressora = tiSeiko   ) and (ord(S[3]) and 12 <> 0))
                 ) then
              begin
                if not(stSemPapel in vlTotens[IdPrinter].StatusTotem) then
                begin
                  EnviaEmail(IdPrinter, stSemPapel, false);
                  EnviaStatusDePapelEOnLineParaTotem (IdPrinter, false);
                  EnviaAlarmeDeStatusDePapelParaPas(IdPrinter, vlTotens[IdPrinter].Nome, stSemPapel);
                end;
                vlTotens[IdPrinter].StatusTotem := vlTotens[IdPrinter].StatusTotem + [stSemPapel];
              end
              else
              begin
                if (stSemPapel in vlTotens[IdPrinter].StatusTotem) then
                begin
                  EnviaEmail(IdPrinter, stSemPapel, True);
                  EnviaStatusDePapelEOnLineParaTotem (IdPrinter, true);
                end;
                vlTotens[IdPrinter].StatusTotem := vlTotens[IdPrinter].StatusTotem - [stSemPapel];
              end;

              if (((TipoDaImpressora = tiBematech) and (ord(S[3]) and 4 <> 0)) or
                  ((TipoDaImpressora = tiMecaf   ) and (ord(S[3]) and 8 <> 0)) or
                  ((TipoDaImpressora = tiZebra   ) and (ord(S[3]) and 4 <> 0)) or
                  ((TipoDaImpressora = tiFujitsu ) and (ord(S[3]) and 4 <> 0)) or
                  ((TipoDaImpressora = tiSeiko   ) and (ord(S[3]) and 3 <> 0))
                 ) then
              begin
                if not(stPoucoPapel in vlTotens[IdPrinter].StatusTotem) then
                begin
                  EnviaEmail(IdPrinter, stPoucoPapel, false);
                  EnviaAlarmeDeStatusDePapelParaPas(IdPrinter, vlTotens[IdPrinter].Nome, stPoucoPapel);
                end;
                vlTotens[IdPrinter].StatusTotem := vlTotens[IdPrinter].StatusTotem + [stPoucoPapel];
              end
              else
              begin
                if (stPoucoPapel in vlTotens[IdPrinter].StatusTotem) then
                  EnviaEmail(IdPrinter, stPoucoPapel, True);
                vlTotens[IdPrinter].StatusTotem := vlTotens[IdPrinter].StatusTotem - [stPoucoPapel];
              end;
            end;
    end; { case s[2] }
  end;
end;

procedure DecifraBotoeiras3B2L(S: string);
var
  PA: Integer;
  BM: TBookmark;
  IniTime : TDateTime;
begin
  if (Length(S) = 3) and (S[1] = '!') and (S[3] = '$') then
  begin
    PA := ord(S[2]) div 3 + 1;

    BM := dmSicsMain.cdsPAs.GetBookmark;
    try
      try
      if dmSicsMain.cdsPAs.Locate('Id_PA', PA, []) then
      begin
        if dmSicsMain.cdsPAs.FieldByName('Ativo').AsBoolean then
        begin
          case ord(S[2]) mod 3 of
            0 : frmSicsMain.Proximo(PA,IniTime);
            1 : frmSicsMain.Rechama(PA);
            2 : frmSicsMain.Finaliza(PA);
          end;
        end;
      end
      else
        MyLogException(Exception.Create('Erro ao receber comando serial botoeiras. Comando inválido: ' + S));

      finally
        if dmSicsMain.cdsPAs.BookmarkValid(BM) then
          dmSicsMain.cdsPAs.GotoBookmark(BM);
      end;
    finally
      dmSicsMain.cdsPAs.FreeBookmark(BM);
    end;
  end;
end; { proc DecifraBoteorias3B2L }

procedure TfrmSicsMain.ServerSocket1ClientRead(Sender: TObject; Socket: TCustomWinSocket);
const
  ReceivingProtocol : boolean = false;
  Protocol          : string = '';
var
  I       : Word;
  S, aux  : string;
  Ret     : integer;
begin
  S := AspAnsiStringToString(Socket.ReceiveText);

  GravarLogSocket('R - Porta=' + inttostr(Socket.LocalPort) + ' - IP=' + Socket.RemoteAddress + ' - STR=' + s + ' - ASCII=' + MyConverteASCII(s));

  for I := 1 to Length(S) do
  begin
    // try
    if S[I] = STX then
    begin
      ReceivingProtocol := True;
      Protocol          := '';
    end
    else if S[I] = ETX then
    begin
      ReceivingProtocol := false;

      Protocol := STX + Protocol + ETX;

      if (Socket.LocalPort = ServerSocket1.Port) or (Socket.LocalPort = TGSServerSocket.Port) then
        aux := DecifraProtocolo(Protocol, Socket.LocalPort, Socket.RemoteAddress)
      else if Socket.LocalPort = ServerSocketRetrocompatibilidade.Port then
        aux := DecifraProtocoloRetrocompatibilidade(Protocol);

      TfrmDebugParameters.Debugar (tbAtividadeDeSocket, 'Entrou ServerSocket1ClientRead - Socket.SendText');
      if aux <> '' then
      begin
        if (Socket.LocalPort = ServerSocket1.Port) or (Socket.LocalPort = TGSServerSocket.Port) then
          Ret := EnviaComando(Socket, aux)   //LBC 21/10/16: até a V4 era Socket.SendText(aux). Na V5 alterou para este EnviaComando, preciso verificar se é necessário assim.
        else if Socket.LocalPort = ServerSocketRetrocompatibilidade.Port then
          Ret := Socket.SendText(aux);
        GravarLogSocket('E - Porta=' + inttostr(Socket.LocalPort) + ' - IP=' + Socket.RemoteAddress + ' - Ret=' + inttostr(Ret) + ' - STR=' + aux);
      end;
      TfrmDebugParameters.Debugar (tbAtividadeDeSocket, 'Saiu   ServerSocket1ClientRead - Socket.SendText');

      Protocol := '';
    end
    else if ReceivingProtocol then
      Protocol := Protocol + S[I];
  end; { for }
end;   { proc ServerSocket1ClientRead }

procedure TfrmSicsMain.ClientSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  Socket.Close;
  ErrorCode := 0;
end;

{ ------------------------------------------------------------------ }
{ Procedures de abertura e fechamento do programa }

procedure TfrmSicsMain.FormCreate(Sender: TObject);
var
  ArqIni     : TIniFile;
  S          : string;
  E          : ERegistroDeOperacao;
  FilasAtivas: Integer;
  BM         : TBookmark;
begin
  SomenteRedirecionar := False;

  FTentativasAcessoMenuProtegido := 0;
  FDataUltimaTentativasAcessoMenuProtegido := 0;

  ADia := Date;
  //cdsIdsTickets                 .CreateDataSet;
  //cdsIdsTicketsTags             .CreateDataSet;
  //cdsIdsTicketsAgendamentosFilas.CreateDataSet;

  AtualizarIDsTickets;
  AtualizarIDsTicketsTags;
  AtualizarAgendamentoFilas;

  if GetIsService then
    RestauraOuEscondeAplicacaoNaBandeja(false);

  fMaxTags := dmSicsMain.cdsGruposDeTags.RecordCount; // RAP

{$IFDEF USEKEY}

  if not(GetAuthorization and CheckKeyDates) then
    Halt;

  SubMenuValidade.Visible := True;

{$ENDIF}

  if not VerificaVersoesDLLs then
    Halt;

  if LoadCabecalhoTicket(999999) = '' then
  { 999999 para que a function "LoadCabecalhoTicket" não encontre nenhum arquivo "custhead999999.dll" e assim assuma o padrão, "custhead.dll" }
  begin
    Application.MessageBox('Arquivo de recursos CustHead_V6.dll não encontrado ou corrompido', 'Erro', MB_ICONSTOP);
    TfrmSicsSplash.Hide;
    Halt;
  end;

  OutBuffer.Cells[0, 0] := 'Senha';
  OutBuffer.Cells[0, 1] := 'PA';
  OutBuffer.Cells[0, 2] := 'Painel';

  ArqIni := TIniFile.Create(GetIniFileName);
  try
    PainelPort.DeviceName                 := ArqIni.ReadString('Settings', 'PainelPort', '');
    PrinterPort.DeviceName                := ArqIni.ReadString('Settings', 'PrinterPort', '');
    //vlUsarBotoeiras3B2L                   := ArqIni.ReadBool('Settings', 'UsarBotoeiras3B2L', false);
    //Botoeiras3B2LPort.DeviceName          := ArqIni.ReadString('Settings', 'Botoeiras3B2LPort', 'Com2');
    vlUsarTeclados1100                    := ArqIni.ReadBool('Settings', 'UsarTeclados1100', false);
    vlUsarTeclados1200                    := ArqIni.ReadBool('Settings', 'UsarTeclados1200', false);
    TecladoPort.DeviceName                := ArqIni.ReadString('Settings', 'TecladosPort', 'Com3');
    vlOutBufferInterval                   := ArqIni.ReadInteger('Settings', 'SegundosNoPainel', 7);
    vlBotoesRetiradaManual[1]             := ArqIni.ReadInteger('Settings', 'FilaDoBotaoDeRetiradaManual1', 0);
    vlBotoesRetiradaManual[2]             := ArqIni.ReadInteger('Settings', 'FilaDoBotaoDeRetiradaManual2', 0);
    S                                     := ArqIni.ReadString('Settings', 'PainelPortConfig', '9600,8,n,1');
    CANEXCLUDE                            := (ArqIni.ReadString('Settings', 'UsuarioMaster', '') = 'SICS');
    vlDisposicaoDasFilas.colunas          := ArqIni.ReadInteger('Settings', 'ColunasDeFilas', 1);
    vlFinalizarPelaSenhaCancelaEspera     := ArqIni.ReadBool('Settings', 'FinalizarPelaSenhaCancelaEspera', True);
    vlDesabilitarBipes                    := ArqIni.ReadBool('Settings', 'DesabilitarBipes', True);
    vlRegistrarAtividadesImpressoras      := ArqIni.ReadBool('RegistroDeOperacao', 'ComunicacaoComImpressoras', True);
    //ALTERADO POR: Jefferson Luis de Simone. - DATA: 22/11/2018.
    TrayIcon1.Visible                     := ArqIni.ReadBool('Settings', 'MinimizarParaBandeja', True);
    SubMenuAtendentes.Enabled             := ArqIni.ReadBool('Settings', 'PodeConfigAtendentes', True);
    SubMenuPrioridadesDosBoxes.Enabled    := ArqIni.ReadBool('Settings', 'PodeConfigPrioridadesAtendimento', True);
    menuIndicadoresdePerformance.Enabled  := ArqIni.ReadBool('Settings', 'PodeConfigIndicadoresDePerformance', True);
    vgMostrarNomeCliente                  := ArqIni.ReadBool('Configuracoes de tela', 'MostrarNomeCliente', True);
    RoboFilaEsperaStatus                  := ArqIni.ReadBool('Robo Fila Espera Profissional', 'RoboFilaEsperaStatus', False);
    FilaEsperaProfissional                := ArqIni.ReadInteger('Robo Fila Espera Profissional', 'FilaEsperaProfissional', 0);
    RoboFilaEsperaTempoSegundos           := ArqIni.ReadInteger('Robo Fila Espera Profissional', 'RoboFilaEsperaTempoSegundos', 0);


    ChamarProximoNoLogin := ArqIni.ReadBool('Settings', 'ChamarProximoNoLogin', false);

    StrToIntArray(ArqIni.ReadString('Settings', 'PAsComTeclados', ''), vlPAsComTeclados);

    ServerSocket1.Port                    := vgParametrosModulo.TCPPort;
    TGSServerSocket.Port                  := vgParametrosModulo.TCPPortTGS;
    ServerSocketRetrocompatibilidade.Port := vgParametrosModulo.TCPPortRetrocompatibilidade;

    AQTDSenhas := vgParametrosModulo.QuantidadeSenhasCalculoTMEPorFila;
  finally
    ArqIni.Free;
  end; { try .. finaly }

  LoadTotens;

  LoadTVs;

  fFecharPrograma := false;

  fFilaPrioritaria               := 0;
  vlNumeroDePainelClientSockets  := -1;
  vlNumeroDeTecladoClientSockets := -1;
  vlNumeroDePrinterClientSockets := -1;

  FilasAtivas := 0;
  with dmSicsMain.cdsFilas do
  begin
    BM := GetBookmark;
    try
      try
      First;
      while not Eof do
      begin
        if FieldByName('Ativo').AsBoolean then
          FilasAtivas := FilasAtivas + 1;
        Next;
      end;
      finally
        if BookmarkValid(BM) then
          GotoBookmark(BM);
      end;
    finally
      FreeBookmark(BM);
    end;
  end; { with cds }

  if FilasAtivas mod vlDisposicaoDasFilas.colunas = 0 then
    vlDisposicaoDasFilas.linhas := FilasAtivas div vlDisposicaoDasFilas.colunas
  else
    vlDisposicaoDasFilas.linhas := FilasAtivas div vlDisposicaoDasFilas.colunas + 1;

  if vlDisposicaoDasFilas.linhas = 0 then
    vlDisposicaoDasFilas.linhas := 1;

  if not SetPainelPortConfig(S) then
    Application.MessageBox('Erro ao ajustar configurações seriais do painel.', 'Erro', MB_ICONSTOP);

//  cdsIdsTickets.LogChanges := false;
  cdsIdsTicketsTags.LogChanges := false;                   //LBC 29/03/17 Apesar de V4 não ter esta linha, coloquei pois acho que deveria ter (talvez não dê problema na V4 por pouco uso pelos clientes do SICS)
  cdsIdsTicketsAgendamentosFilas.LogChanges := false;

  IdHTTPServer.DefaultPort := vgParametrosModulo.FilePorta;
  IdHTTPServer.Active := (vgParametrosModulo.FileAtivo = 1);

  if not GetIsService then
  begin
    E := ERegistroDeOperacao.Create('Início do programa.');
    MyLogException(E);
  end;

  //LM
  CarregarGruposPAS_AlarmesPapelTotens;
  ConfigurarRoboFilaEsperaProfissional;
end; { proc FormCreate }

function TfrmSicsMain.FormatarPIHorarioParaJornalEletronico(const AQtdeSegundos, AFormatoHorario: Integer): String;
var
  LHor, LMin: Integer;

  procedure GetHorasMinutos;
  const
    SecPerMinute = 60;
    SecPerHour   = SecPerMinute * 60;
    SecPerDay    = SecPerHour   * 24;
  var
    ms, ss, mm, hh, dd: Cardinal;
  begin
    result := EmptyStr;

    dd := AQtdeSegundos div SecPerDay;
    hh := (AQtdeSegundos mod SecPerDay) div SecPerHour;
    mm := ((AQtdeSegundos mod SecPerDay) mod SecPerHour) div SecPerMinute;
    ss := ((AQtdeSegundos mod SecPerDay) mod SecPerHour) mod SecPerMinute;

    LHor := (dd*24) + hh;
    if ss > 0 then
      Inc(mm);
    if mm >= 60 then
    begin
      mm := 0;
      Inc(LHor);
    end;
    LMin := mm;
  end;

begin
  result := '';
  GetHorasMinutos;

  case TFormatoHorarioNoJornalEletronico(AFormatoHorario) of
    fhHoraHMinutos: begin
      result := FormatFloat('00', LHor) + 'h' + FormatFloat('00', LMin);
    end;

    fhHoraDoisPontosMinutos: begin
      result := FormatFloat('00', LHor) + ':' + FormatFloat('00', LMin);
    end;

    fhExtenso: begin
      if LHor > 0 then
      begin
        if LHor = 1 then
          result := '1 HORA'
        else
          result := LHor.ToString + ' HORAS'
      end;

      if LMin > 0 then
      begin
        if result <> '' then
          result := result + ' E ';

        if LMin = 1 then
          result := result + '1 MINUTO'
        else
          result := result + LMin.ToString + ' MINUTOS';
      end;

      if result = '' then
        result := 'IMEDIATO';
    end;
  end;
end;

procedure TfrmSicsMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  ArqIni: TIniFile;
  E     : ERegistroDeOperacao;
  S     : string;
  LTentativas: Integer;
begin
  if not fFecharPrograma then
  begin
    if TrayIcon1.visible then
      RestauraOuEscondeAplicacaoNaBandeja(false);
    Action := caNone;
    Exit;
  end;

  TfrmDebugParameters.Debugar (tbGeral, 'Encerrando servidor SICS...');

  TfrmSicsSplash.ShowStatus('Encerrando...');
  try
    //Aguarda a Thread de Calculo de PIs finalizar, caso esteja em execução
    LTentativas := 0;
    if frmSicsPIMonitor.ThreadCalculoPISRodando then
      repeat
        sleep(500);
        Inc(LTentativas);
        Application.ProcessMessages;                       //2 segundos
      until (not frmSicsPIMonitor.ThreadCalculoPISRodando or (LTentativas = 4) );


    ArqIni := TIniFile.Create(GetIniFileName);
    try
      if PainelPort.DeviceName <> 'COM_ERRO' then
        ArqIni.WriteString('Settings', 'PainelPort', PainelPort.DeviceName);
      ArqIni.WriteString('Settings', 'PrinterPort', PrinterPort.DeviceName);
      //ArqIni.WriteBool('Settings', 'UsarBotoeiras3B2L', vlUsarBotoeiras3B2L);
      //ArqIni.WriteString('Settings', 'Botoeiras3B2LPort', Botoeiras3B2LPort.DeviceName);
      //ArqIni.WriteBool('Settings', 'UsarTeclados1100', vlUsarTeclados1100);
      ArqIni.WriteBool('Settings', 'UsarTeclados1200', vlUsarTeclados1200);
      ArqIni.WriteString('Settings', 'TecladosPort', TecladoPort.DeviceName);
      ArqIni.WriteInteger('Settings', 'SegundosNoPainel', vlOutBufferInterval);
      ArqIni.WriteString('Settings', 'PainelPortConfig', GetPainelPortConfig);
      ArqIni.WriteInteger('Settings', 'FilaDoBotaoDeRetiradaManual1', vlBotoesRetiradaManual[1]);
      ArqIni.WriteInteger('Settings', 'FilaDoBotaoDeRetiradaManual2', vlBotoesRetiradaManual[2]);
      ArqIni.WriteBool('Settings', 'FinalizarPelaSenhaCancelaEspera', vlFinalizarPelaSenhaCancelaEspera);
      ArqIni.WriteBool('Settings', 'DesabilitarBipes', vlDesabilitarBipes);
      IntArrayToStr(vlPAsComTeclados, S);
      ArqIni.WriteString('Settings', 'PAsComTeclados', S);

      ArqIni.WriteInteger('Settings', 'ColunasDeFilas', vlDisposicaoDasFilas.colunas);

      ArqIni.WriteBool('RegistroDeOperacao', 'ComunicacaoComImpressoras', vlRegistrarAtividadesImpressoras);
      ArqIni.WriteBool('Settings', 'PodeConfigAtendentes', SubMenuAtendentes.Enabled);
      ArqIni.WriteBool('Settings', 'PodeConfigPrioridadesAtendimento', SubMenuPrioridadesDosBoxes.Enabled);
      ArqIni.WriteBool('Settings', 'PodeConfigIndicadoresDePerformance', menuIndicadoresdePerformance.Enabled);
      ArqIni.WriteBool('Configuracoes de tela', 'MostrarNomeCliente', vgMostrarNomeCliente);

      ArqIni.WriteBool('Settings', 'ChamarProximoNoLogin', ChamarProximoNoLogin);
      ArqIni.WriteBool('Robo Fila Espera Profissional', 'RoboFilaEsperaStatus', RoboFilaEsperaStatus);
      ArqIni.WriteInteger('Robo Fila Espera Profissional', 'FilaEsperaProfissional', FilaEsperaProfissional);
      ArqIni.WriteInteger('Robo Fila Espera Profissional', 'RoboFilaEsperaTempoSegundos', RoboFilaEsperaTempoSegundos);

      //LM
      ArqIni.WriteString('AlarmesFaltaDePapel', 'GrupoPAs_SemPapel_Totem_1',   EmptyStr);
      ArqIni.WriteString('AlarmesFaltaDePapel', 'GrupoPAs_PoucoPapel_Totem_1', EmptyStr);

      ArqIni.EraseSection('NomesDasFilasNosTickets');
      ArqIni.EraseSection('GeracaoAutomaticaDeSenhas');
      ArqIni.DeleteKey('Settings', 'ImprimirCodigoDeBarras');
      ArqIni.DeleteKey('Settings', 'ImprimirPicote');
      ArqIni.DeleteKey('Settings', 'CorteParcialAoFinalDoTicket');
      ArqIni.DeleteKey('Settings', 'ImprimirDataEHoraNaSegundaVia');
    finally
      ArqIni.Free;
    end; { try .. finaly }

    // SaveTotens;
    SavePosition(frmSicsMain);

    ServerSocket1.Close;
    TGSServerSocket.Close;
    ServerSocketRetrocompatibilidade.Close;

    FechaPortaImpressora;

    PainelTcpPort.Close;
    PainelPort.Close;

    Botoeiras3B2LPort.Close;
    TecladoPort.Close;

    ClearOutBufferTimer.Enabled := false;

    if not GetIsService then
    begin
      E := ERegistroDeOperacao.Create('Término do programa.');
      MyLogException(E);
    end;
  finally
    TfrmSicsSplash.Hide;
  end;
  { try .. finally }
end; { proc FormClose }

procedure TfrmSicsMain.InicializarDados;
begin
  LoadFilasToScreen;

  LoadPswds;

  //RA
  //dmSicsMain.cdsContadoresDeFilas.AfterPost := cdsContadoresDeFilasAfterPost;

  // a abertura de portas e sockets acontece ao mostrar formulario pois precisa ser depois de carregar senhas,
  // que, por sua vez, precisa ser depois de criar outros formulários

  AbrePortaPainel;

  AbrePortaImpressora;

  if vlUsarBotoeiras3B2L then
    try
      Botoeiras3B2LPort.Open;
    except
      begin
        Application.MessageBox('Erro ao abrir porta das botoeiras.', 'Erro', MB_ICONSTOP);
        MyLogException(ERegistroDeOperacao.Create('Erro ao abrir porta das botoeiras.'));
      end;
    end;
  { try .. except }

  if vlUsarTeclados1100 or vlUsarTeclados1200 then
    AbrePortaTeclado;

  if not ServerSocket1.Active then
    try
      Delay(1000);
      ServerSocket1.Open;
    except
      on E:Exception do
      begin
        Application.MessageBox('Erro ao abrir soquete TCP/IP.', 'Erro', MB_ICONSTOP);
        MyLogException(ERegistroDeOperacao.Create('Erro ao abrir soquete TCP/IP. Porta: ' + inttostr(ServerSocket1.Port) + '. Erro: ' + E.Message));
      end;
    end; { try .. except }

  if not TGSServerSocket.Active then
    try
      Delay(1000);
      TGSServerSocket.Open;
    except
      on E:Exception do
      begin
        Application.MessageBox('Erro ao abrir soquete TCP/IP para conexão do TGS.', 'Erro', MB_ICONSTOP);
        MyLogException(ERegistroDeOperacao.Create('Erro ao abrir soquete TCP/IP para conexão do TGS. Porta: ' + inttostr(TGSServerSocket.Port) + '. Erro: ' + E.Message));
      end;
    end; { try .. except }

  if (ServerSocketRetrocompatibilidade.Port <> 0) and (not ServerSocketRetrocompatibilidade.Active) then
    try
      Delay(1000);
      ServerSocketRetrocompatibilidade.Open;
    except
      begin
        Application.MessageBox('Erro ao abrir soquete TCP/IP de retrocompatibilidade.', 'Erro', MB_ICONSTOP);
        MyLogException(ERegistroDeOperacao.Create('Erro ao abrir soquete TCP/IP de retrocompatibilidade.'));
      end;
    end;
  { try .. except }

  SubMenuDesabilitarBotoesDaImpressoraClick(nil);
  ClearOutBufferTimer.Enabled   := True;
  CheckConnectionsTimer.Enabled := True;

  if vgParametrosModulo.NomeUnidade <> '' then
  begin
    Application.Title   := 'SICS Módulo Servidor - ' + vgParametrosModulo.NomeUnidade;
    frmSicsMain.Caption := 'SICS Módulo Servidor - ' + vgParametrosModulo.NomeUnidade;
    TrayIcon1.Hint       := 'SICS Módulo Servidor - ' + vgParametrosModulo.NomeUnidade;
  end
  else
  begin
    Application.Title   := 'SICS Módulo Servidor';
    frmSicsMain.Caption := 'SICS Módulo Servidor';
    TrayIcon1.Hint       := 'SICS Módulo Servidor';
  end;

  if dmSicsContingencia.TipoFuncionamento = tfContingente then
  begin
    Application.Title   := Application.Title + ' - CONTINGENTE!';
    frmSicsMain.Caption := frmSicsMain.Caption + ' - CONTINGENTE!';
    TrayIcon1.Hint       := TrayIcon1.Hint + ' - CONTINGENTE!';
  end;
end;

procedure TfrmSicsMain.FormResize(Sender: TObject);
const
  OFF           = 4;
  AlturaMinima  = 210;
  LarguraMinima = 130;
var
  FilaBounds            : array [1 .. cgMAXFILAS] of TRect;
  I, ID, altura, largura: Integer;
  BM                    : TBookmark;
begin
  if ((VertScrollBar.IsScrollBarVisible) or (HorzScrollBar.IsScrollBarVisible)) then
  begin
    VertScrollBar.Position := 0;
    HorzScrollBar.Position := 0;
    largura                := (ClientWidth - VertScrollBar.Size) div vlDisposicaoDasFilas.colunas;
    altura                 := (ClientHeight - OutBuffer.Height - 2 * OFF - HorzScrollBar.Size) div vlDisposicaoDasFilas.linhas;
  end
  else
  begin
    largura := ClientWidth div vlDisposicaoDasFilas.colunas;
    altura  := (ClientHeight - OutBuffer.Height - 2 * OFF) div vlDisposicaoDasFilas.linhas;
  end;
  if altura < AlturaMinima then
    altura := AlturaMinima;
  if largura < LarguraMinima then
    largura := LarguraMinima;

  OutBuffer.Left  := OFF;
  OutBuffer.Top   := altura * vlDisposicaoDasFilas.linhas + OFF;
  OutBuffer.Width := ClientWidth div 2 - 2 * OFF;
  Panel1.Left     := OutBuffer.Left + OutBuffer.Width + 2 * OFF;
  Panel1.Top      := OutBuffer.Top + (OutBuffer.Height - Panel1.Height) div 2;
  Panel1.Width    := ClientWidth div 2 - 2 * OFF;

  I  := 0;
  BM := dmSicsMain.cdsFilas.GetBookmark;
  try
    try
    dmSicsMain.cdsFilas.First;
    while not dmSicsMain.cdsFilas.Eof do
    begin
      if dmSicsMain.cdsFilas.FieldByName('Ativo').AsBoolean then
      begin
        ID := dmSicsMain.cdsFilas.FieldByName('ID').AsInteger;
        if FindComponent('Shape' + IntToStr(ID)) <> nil then
        begin
          try
            I := I + 1;

            if ((I - 1) mod vlDisposicaoDasFilas.colunas) = 0 then
            begin
              FilaBounds[I].Left   := 0;
              FilaBounds[I].Top    := ((I - 1) div vlDisposicaoDasFilas.colunas) * altura;
              FilaBounds[I].Right  := FilaBounds[1].Left + largura;
              FilaBounds[I].Bottom := FilaBounds[I].Top + altura;
            end
            else
            begin
              FilaBounds[I].Left   := FilaBounds[I - 1].Right;
              FilaBounds[I].Top    := FilaBounds[I - 1].Top;
              FilaBounds[I].Right  := FilaBounds[I].Left + largura;
              FilaBounds[I].Bottom := FilaBounds[I - 1].Bottom;
            end;

            (FindComponent('Shape' + IntToStr(ID)) as TShape).Top := FilaBounds[I].Top + 2;
            (FindComponent('Shape' + IntToStr(ID)) as TShape).Left := FilaBounds[I].Left + 2;
            (FindComponent('Shape' + IntToStr(ID)) as TShape).Width := FilaBounds[I].Right - FilaBounds[I].Left - 4;
            (FindComponent('Shape' + IntToStr(ID)) as TShape).Height := FilaBounds[I].Bottom - FilaBounds[I].Top - 4;
            (FindComponent('Label' + IntToStr(ID)) as TLabel).Top := FilaBounds[I].Top + OFF;
            (FindComponent('Label' + IntToStr(ID)) as TLabel).Left := FilaBounds[I].Left + OFF;
            (FindComponent('SenhasCountLabel' + IntToStr(ID)) as TLabel).Top := FilaBounds[I].Top + OFF;
            (FindComponent('SenhasCountLabel' + IntToStr(ID)) as TLabel).Left := FilaBounds[I].Right - (FindComponent('SenhasCountLabel' + IntToStr(ID)) as TLabel).Width - OFF;
            (FindComponent('FilaLabel' + IntToStr(ID)) as TLabel).Top := (FindComponent('Label' + IntToStr(ID)) as TLabel).Top + (FindComponent('Label' + IntToStr(ID)) as TLabel).Height + OFF;
            (FindComponent('FilaLabel' + IntToStr(ID)) as TLabel).Left := (FindComponent('Label' + IntToStr(ID)) as TLabel).Left;
            (FindComponent('FilaLabel' + IntToStr(ID)) as TLabel).Width := FilaBounds[I].Right - FilaBounds[I].Left - 2 * OFF;
            if (FindComponent('BitBtn' + IntToStr(ID)) as TBitBtn).Visible then
            begin
              (FindComponent('BitBtn' + IntToStr(ID)) as TBitBtn).Top := (FindComponent('FilaLabel' + IntToStr(ID)) as TLabel).Top + (FindComponent('FilaLabel' + IntToStr(ID)) as TLabel).Height + OFF;
              (FindComponent('BitBtn' + IntToStr(ID)) as TBitBtn).Left := FilaBounds[I].Left + (FilaBounds[I].Right - FilaBounds[I].Left - (FindComponent('BitBtn' + IntToStr(ID)) as TBitBtn).Width) div 2;
              (FindComponent('SenhaEdit' + IntToStr(ID)) as TEdit).Top := (FindComponent('BitBtn' + IntToStr(ID)) as TBitBtn).Top + (FindComponent('BitBtn' + IntToStr(ID)) as TBitBtn).Height + OFF;
            end
            else
              (FindComponent('SenhaEdit' + IntToStr(ID)) as TEdit).Top := (FindComponent('FilaLabel' + IntToStr(ID)) as TLabel).Top + (FindComponent('FilaLabel' + IntToStr(ID)) as TLabel).Height + OFF;
            (FindComponent('SenhaEdit' + IntToStr(ID)) as TEdit).Left := FilaBounds[I].Left + (FilaBounds[I].Right - FilaBounds[I].Left - (FindComponent('SenhaEdit' + IntToStr(ID)) as TEdit).Width - (FindComponent('InsertSenhaButton' + IntToStr(ID)) as TButton).Width - OFF) div 2;
            (FindComponent('InsertSenhaButton' + IntToStr(ID)) as TButton).Top := (FindComponent('SenhaEdit' + IntToStr(ID)) as TEdit).Top + ((FindComponent('SenhaEdit' + IntToStr(ID)) as TEdit).Height - (FindComponent('InsertSenhaButton' + IntToStr(ID)) as TButton).Height) div 2;
            (FindComponent('InsertSenhaButton' + IntToStr(ID)) as TButton).Left := (FindComponent('SenhaEdit' + IntToStr(ID)) as TEdit).Left + (FindComponent('SenhaEdit' + IntToStr(ID)) as TEdit).Width + OFF;
            if (FindComponent('ListBlocked' + IntToStr(ID)) as TCheckBox).Visible then
            begin
              (FindComponent('ListBlocked' + IntToStr(ID)) as TCheckBox).Top := (FindComponent('SenhaEdit' + IntToStr(ID)) as TEdit).Top + (FindComponent('SenhaEdit' + IntToStr(ID)) as TEdit).Height + OFF;
              (FindComponent('ListBlocked' + IntToStr(ID)) as TCheckBox).Left := FilaBounds[I].Left + (FilaBounds[I].Right - FilaBounds[I].Left - (FindComponent('ListBlocked' + IntToStr(ID)) as TCheckBox).Width) div 2;
              (FindComponent('SenhasList' + IntToStr(ID)) as TStringGrid).Top := (FindComponent('ListBlocked' + IntToStr(ID)) as TCheckBox).Top + (FindComponent('ListBlocked' + IntToStr(ID)) as TCheckBox).Height + OFF;
            end
            else
              (FindComponent('SenhasList' + IntToStr(ID)) as TStringGrid).Top := (FindComponent('SenhaEdit' + IntToStr(ID)) as TEdit).Top + (FindComponent('SenhaEdit' + IntToStr(ID)) as TEdit).Height + OFF;
            if (FindComponent('PrioritaryList' + IntToStr(ID)) as TCheckBox).Visible then
            begin
              if (FindComponent('ListBlocked' + IntToStr(ID)) as TCheckBox).Visible then
              begin
                (FindComponent('PrioritaryList' + IntToStr(ID)) as TCheckBox).Top := (FindComponent('ListBlocked' + IntToStr(ID)) as TCheckBox).Top + (FindComponent('ListBlocked' + IntToStr(ID)) as TCheckBox).Height + OFF;
                (FindComponent('PrioritaryList' + IntToStr(ID)) as TCheckBox).Left := (FindComponent('ListBlocked' + IntToStr(ID)) as TCheckBox).Left;
              end
              else
              begin
                (FindComponent('PrioritaryList' + IntToStr(ID)) as TCheckBox).Top := (FindComponent('SenhaEdit' + IntToStr(ID)) as TEdit).Top + (FindComponent('SenhaEdit' + IntToStr(ID)) as TEdit).Height + OFF;
                (FindComponent('PrioritaryList' + IntToStr(ID)) as TCheckBox).Left := FilaBounds[I].Left + (FilaBounds[I].Right - FilaBounds[I].Left - (FindComponent('PrioritaryList' + IntToStr(ID)) as TCheckBox).Width) div 2;
              end;
              (FindComponent('SenhasList' + IntToStr(ID)) as TStringGrid).Top := (FindComponent('PrioritaryList' + IntToStr(ID)) as TCheckBox).Top + (FindComponent('PrioritaryList' + IntToStr(ID)) as TCheckBox).Height + OFF;
            end;
            (FindComponent('SenhasList' + IntToStr(ID)) as TStringGrid).Left := FilaBounds[I].Left + OFF;
            (FindComponent('SenhasList' + IntToStr(ID)) as TStringGrid).Width := FilaBounds[I].Right - FilaBounds[I].Left - 2 * OFF;
            (FindComponent('SenhasList' + IntToStr(ID)) as TStringGrid).Height := FilaBounds[I].Bottom - (FindComponent('SenhasList' + IntToStr(ID)) as TStringGrid).Top - OFF;

            (FindComponent('BevelV' + IntToStr(ID)) as TBevel).Top := FilaBounds[I].Top + OFF;
            (FindComponent('BevelV' + IntToStr(ID)) as TBevel).Left := FilaBounds[I].Right - 1;
            (FindComponent('BevelV' + IntToStr(ID)) as TBevel).Height := altura - 2 * OFF;

            (FindComponent('BevelH' + IntToStr(ID)) as TBevel).Top := FilaBounds[I].Bottom - 1;
            (FindComponent('BevelH' + IntToStr(ID)) as TBevel).Left := FilaBounds[I].Left + OFF;
            (FindComponent('BevelH' + IntToStr(ID)) as TBevel).Width := largura - 2 * OFF;

            (FindComponent('SenhasList' + IntToStr(ID)) as TStringGrid).Repaint;
          finally
          end;
        end;
      end;
      dmSicsMain.cdsFilas.Next;
    end; { for i }
    finally
      if dmSicsMain.cdsFilas.BookmarkValid(BM) then
        dmSicsMain.cdsFilas.GotoBookmark(BM);
    end;
  finally

    dmSicsMain.cdsFilas.FreeBookmark(BM);
  end;
end; { proc FormResize }

{ -------------------------------------------- }
{ Procedures dos timers }

procedure TfrmSicsMain.ClearOutBufferTimerTimer(Sender: TObject);
 function verificarDelay(hora: string) :  Boolean;
    var
      horaSenha : TDateTime;
      horaAtual : TDateTime;
      horaSegundos, horaAtualSegundos : integer;
      segundos : integer;
  begin
    Result := True;
    horaAtual := Now;
    horaSenha := StrToDateTime(hora);
    segundos := SecondsBetween(horaAtual,horaSenha);
    if(segundos < vgParametrosModulo.DelayChamadaAutomatica)then
    begin
      Result := False;
    end;
  end;
var
  PA, Senha, k                                : Integer;
  EstaChamandoSenha                           : Boolean;
  PainelIEndereco, PainelJEndereco            : string;
  PainelIModelo, PainelJModelo                : Integer;
  EstaoChamandoSenha, ChamaramSenhaAgora      : TIntArray;
  EstaoChamandoSenhaStr, ChamaramSenhaAgoraStr: string;
  TempBookmark                                : TBookmark;
  horaSenha                                   : string;
  LTelefone                                   : string;
  LIdioma                                     : string;
  LMensagem                                   : string;
  lIDTicket,
  lIDFila: Integer;

  lNomeCliente: String;

  lCreatedAt: TDateTime;
begin
  if (SysUtils.FormatSettings.ShortDateFormat <> 'dd/mm/yyyy') or (SysUtils.FormatSettings.LongTimeFormat <> 'hh:nn:ss') then
  begin
    MyLogException(Exception.Create('Formato de data indevido, ShortDateFormat = "' + SysUtils.FormatSettings.ShortDateFormat + '", LongTimeFormat = "' + SysUtils.FormatSettings.LongTimeFormat + '". Reconfigurando para formatos corretos.'));
    SysUtils.FormatSettings.ShortDateFormat := 'dd/mm/yyyy';
    SysUtils.FormatSettings.LongTimeFormat := 'hh:nn:ss';
  end;

  try
    EstaoChamandoSenhaStr := '';
    with dmSicsMain.cdsPaineis do
    begin
      First;
      while not Eof do
      begin
        EstaChamandoSenha := (dmSicsMain.cdsControleDePaineis.FieldByName('ProximaChamada').AsDateTime > now);
        if not EstaChamandoSenha then
        begin
          PainelIEndereco := FieldByName('EnderecoSerial').AsString;
          PainelIModelo   := FieldByName('ID_MODELOPAINEL').AsInteger;

          case PainelIModelo of
            91, 92, 93, 96, 97, 251, 252, 291, 292, 301, 302:
              begin
                TempBookmark := GetBookmark;
                try
                  try
                  First;
                  while not Eof do
                  begin
                    PainelJEndereco := FieldByName('EnderecoSerial').AsString;
                    PainelJModelo   := FieldByName('ID_MODELOPAINEL').AsInteger;

                    if (PainelJEndereco = PainelIEndereco) and ((PainelJModelo = PainelIModelo) or ((PainelJModelo in [93, 94, 96, 97]) and (PainelIModelo in [93, 94, 96, 97])) or ((PainelJModelo in [251, 252]) and (PainelIModelo in [215, 252])) or
                      (((PainelJModelo = 291) or (PainelJModelo = 292)) and ((PainelIModelo = 291) or (PainelIModelo = 292))) or (((PainelJModelo = 301) or (PainelJModelo = 302)) and ((PainelIModelo = 301) or (PainelIModelo = 302)))) then
                      EstaChamandoSenha := EstaChamandoSenha or (dmSicsMain.cdsControleDePaineis.FieldByName('ProximaChamada').AsDateTime > now);

                    Next;
                  end;
                  finally
                    if BookmarkValid(TempBookmark) then
                      GotoBookmark(TempBookmark);
                  end;
                finally
                  FreeBookmark(TempBookmark);
                end;
              end; { case Modelo }
          end;     { if }
        end;

        if EstaChamandoSenha then
          EstaoChamandoSenhaStr := EstaoChamandoSenhaStr + FieldByName('ID').AsString + ';';

        Next;
      end;
    end; { with cdsPaineis }

    StrToIntArray(EstaoChamandoSenhaStr, EstaoChamandoSenha);

    ChamaramSenhaAgoraStr := '';
    for k                 := 1 to OutBuffer.ColCount - 1 do
      if ((OutBuffer.Cells[k, 2] <> '') and (not ExisteNoIntArray(StrToInt(OutBuffer.Cells[k, 2]), EstaoChamandoSenha)) and (not ExisteNoIntArray(StrToInt(OutBuffer.Cells[k, 2]), ChamaramSenhaAgora))) then
      begin
        horaSenha := OutBuffer.Cells[k, 3];
        if((horaSenha <> '') and (vgParametrosModulo.DelayChamadaAutomatica <> 0))then
        begin
          if(not verificarDelay(horaSenha))then
            Continue;
        end;

        ChamaramSenhaAgoraStr := ChamaramSenhaAgoraStr + OutBuffer.Cells[k, 2] + ';';

        Senha := StrToInt(OutBuffer.Cells[k, 0]);
        PA    := StrToInt(OutBuffer.Cells[k, 1]);

        RemoveCol(OutBuffer, k);

        CallOnDisplay(PA, Senha);

        LMensagem := Senha.ToString + ';' + NGetPAName(PA);

        if NGetPAWhatsApp(PA) then
        begin
          if LocalizarTicket(Senha, lIDTicket, lIDFila, lNomeCliente, lCreatedAt) then
          begin
            if IncMinute(lCreatedAt,vgParametrosModulo.TempoMinutosEnvio) >= Now then
            begin
              if GetTelefoneDadosAdicionais(Senha, LTelefone, LIdioma) then
              begin
                LMensagem := LMensagem +'|'+ LIdioma;
                uMessenger.SendMessage(LTelefone, LMensagem , TMessageType.WhatsApp);
      //          uMessenger.SendMessage(LTelefone, Format(MENSAGEM_CHAMADA_SENHA, [Senha, PA]), TMessageType.WhatsApp);
              end;

            end;
          end;
        end;
        Delay(300);
        StrToIntArray(ChamaramSenhaAgoraStr, ChamaramSenhaAgora);
      end; { if OutBuffer.. }

    with dmSicsMain.cdsPaineis do
    begin
      First;
      while not Eof do
      begin
        if ExisteNoIntArray(FieldByName('ID').AsInteger, ChamaramSenhaAgora) then
        begin
          dmSicsMain.cdsControleDePaineis.Edit;
          dmSicsMain.cdsControleDePaineis.FieldByName('ProximaChamada').AsDateTime := now + EncodeTime(0, 0, vlOutBufferInterval, 0);
          dmSicsMain.cdsControleDePaineis.Post;
        end
        else if ((not ExisteNoIntArray(FieldByName('ID').AsInteger, EstaoChamandoSenha)) and (not dmSicsMain.cdsControleDePaineis.FieldByName('ProximaChamada').IsNull) and (not FieldByName('ManterUltimaSenha').AsBoolean)) then
        begin
          ClearDisplay(FieldByName('ID').AsInteger);
          Delay(200);
          dmSicsMain.cdsControleDePaineis.Edit;
          dmSicsMain.cdsControleDePaineis.FieldByName('ProximaChamada').Clear;
          dmSicsMain.cdsControleDePaineis.Post;
        end;

        Next;
      end; { while not eof }
    end;   { with cdsPaineis }
  except
    begin
      Application.MessageBox('Erro ao esvaziar buffer', 'Erro', MB_ICONSTOP);
    end;
  end; { try .. except }
end;   { proc CheckTimerTimer }

function TfrmSicsMain.GetTelefoneDadosAdicionais(ASenha: Integer; out ATelefone, AIdioma: String): Boolean;
var
  LJSONObj: TJSONObject;
  LTicket: Integer;
begin
  //Telefones do Brasil devem retornar no seguinte formato
  //CCDDNNNNNNNNN ou CCDDNNNNNNNNN
  //CC - Código do País
  //DD - Código do DDD
  //NN - Número do telefone com 8 ou 9 dígitos
  //Exemplo: '5511962833166';

  Result    := False;
  ATelefone := EmptyStr;
  AIdioma := EmptyStr;

  LTicket  := GetIdTicketIfPwdExists(ASenha);
  LJSONObj := dmSicsMain.GetDadosAdicionais(LTicket);
  try
    if Assigned(LJSONObj) then
    begin
      LJSONObj.TryGetValue('TELEFONE', ATelefone);
      LJSONObj.TryGetValue('IDIOMA',   AIdioma);
      Result := (ATelefone <> EmptyStr) and (AIdioma <> EmptyStr);
    end;
  finally
    if Assigned(LJSONObj) then
      LJSONObj.Free;
  end;
end;

procedure TfrmSicsMain.OneMinuteTimerTimer(Sender: TObject);
const
  clClearErrorTimeout: Word = 2;
  timeout: Integer          = 30;
var
  I: Integer;
  Assunto, Mensagem: String;
begin
  if timeout > 0 then
    timeout := timeout - 1
  else
  begin
    for I := 1 to vlNumeroDePrinterClientSockets do
    begin
      if stSemConexao in vlTotens[IdsTotens[I]].StatusTotem then
        EnviaEmail(IdsTotens[I], stSemConexao, false);

      if stOffLine in vlTotens[IdsTotens[I]].StatusTotem then
        EnviaEmail(IdsTotens[I], stOffLine, false);

      if stPoucoPapel in vlTotens[IdsTotens[I]].StatusTotem then
      begin
        EnviaEmail(IdsTotens[I], stPoucoPapel, false);
        EnviaAlarmeDeStatusDePapelParaPas(IdsTotens[I], vlTotens[IdsTotens[I]].Nome, stPoucoPapel);
      end;

      if stSemPapel in vlTotens[IdsTotens[I]].StatusTotem then
      begin
        EnviaEmail(IdsTotens[I], stSemPapel, false);
        EnviaAlarmeDeStatusDePapelParaPas(IdsTotens[I], vlTotens[IdsTotens[I]].Nome, stSemPapel);
      end;
    end;

{$IFDEF USEKEY}
    if not CheckKeyDates then
      Halt;
{$ENDIF}

    timeout := 30;
  end; { else }

  if clClearErrorTimeout > 0 then
    clClearErrorTimeout := clClearErrorTimeout - 1
  else
  begin
    if PainelPort.Active then
      PainelPort.PurgeReadWrite;

    if PrinterPort.Active then
      PrinterPort.PurgeReadWrite;

    if Botoeiras3B2LPort.Active then
      Botoeiras3B2LPort.PurgeReadWrite;

    if TecladoPort.Active then
      TecladoPort.PurgeReadWrite;

    clClearErrorTimeout := 2;
  end; { else }

  //LM
  if ((vgParametrosModulo.LimparFilasMeiaNoite) and (ADia <> Date)) then
  begin
    ApagarSenhasEmEsperas;
    FazerLogoutsDasPAs;
    LimparObjetosCalculoTMEPorFila;
    LimparObjetosCalculoTMAPorFila;
    ADia := Date;
  end;

end;   { proc ClearSerialErrorsTimerTimer }

procedure TfrmSicsMain.CheckConnectionsTimerTimer(Sender: TObject);
const
  DebugContaChecaConexoes: Integer = 0;
var
  I       : Integer;
  s1, s2  : string;
  Timeouts: array [1 .. cgMaxTotens] of Integer;
  E2      : ERegistroDeOperacao;
  {$IFDEF SuportaPing}
  LRoundTripTime: Cardinal;
  {$ENDIF SuportaPing}
  LSolicitaStatusTV: String;
begin
  if fFecharPrograma then
    Exit;

  TfrmDebugParameters.Debugar(tbTimers, 'Entrou   CheckConnectionsTimerTimer');

  if DebugContaChecaConexoes = 2000000000 then
    DebugContaChecaConexoes := 0
  else
    DebugContaChecaConexoes := DebugContaChecaConexoes + 1;

  LSolicitaStatusTV := STX + Chr($A7) + ETX;

  if not ServerSocket1.Active then
  begin
    try
      MyLogException(ERegistroDeOperacao.Create('Soquete TCP/IP está fechado. Reabrindo porta ' + inttostr(ServerSocket1.Port) + '...'));
      ServerSocket1.Open;
      MyLogException(ERegistroDeOperacao.Create('Porta ' + inttostr(ServerSocket1.Port) + ' aberta.'));
    except
      on E:Exception do
      begin
        MyLogException(ERegistroDeOperacao.Create('Erro ao abrir soquete TCP/IP. Porta: ' + inttostr(ServerSocket1.Port) + '. Erro: ' + E.Message));
      end;
    end; { try .. except }
  end
  else
    TfrmDebugParameters.Debugar(tbTimers, '   ServerSocket1 is active');

  if not TGSServerSocket.Active then
  begin
    try
      MyLogException(ERegistroDeOperacao.Create('Soquete TCP/IP para conexão do TGS está fechado. Reabrindo porta: ' + inttostr(TGSServerSocket.Port) + '...'));
      TGSServerSocket.Open;
      MyLogException(ERegistroDeOperacao.Create('Porta: ' + inttostr(TGSServerSocket.Port) + ' aberta.'));
    except
      on E:Exception do
      begin
        MyLogException(ERegistroDeOperacao.Create('Erro ao abrir soquete TCP/IP para conexão do TGS. Porta: ' + inttostr(TGSServerSocket.Port) + '. Erro: ' + E.Message));
      end;
    end; { try .. except }
  end
  else
    TfrmDebugParameters.Debugar(tbTimers, '   TGSServerSocket is active');

{$REGION 'Impressoras e Totens'}
    //conta quantos sockets de totens foram criados em tempo de execução
    if vlNumeroDePrinterClientSockets = -1 then
    begin
      for I := 0 to frmSicsMain.ComponentCount - 1 do
      begin
        if Pos('PrinterClientSocket', frmSicsMain.Components[I].Name) > 0 then
        begin
          if vlNumeroDePrinterClientSockets = -1 then
            vlNumeroDePrinterClientSockets := 1
          else
            vlNumeroDePrinterClientSockets := vlNumeroDePrinterClientSockets + 1;
          IdsTotens[vlNumeroDePrinterClientSockets] := frmSicsMain.Components[I].Tag;
        end;
      end;

      for I         := low(Timeouts) to high(Timeouts) do
        Timeouts[I] := 2;
    end;

    if vlNumeroDePrinterClientSockets = -1 then
      vlNumeroDePrinterClientSockets := -2;

    //conecta cada socket que esteja desconectado
    for I := 1 to vlNumeroDePrinterClientSockets do
      if FindComponent('PrinterClientSocket' + inttostr(IdsTotens[I])) <> nil then
      begin
        if not(FindComponent('PrinterClientSocket' + inttostr(IdsTotens[I])) as TClientSocket).Active then
          try
            if vlTotens[IdsTotens[I]].StatusSocket = ssIdle then
            begin
              if vlRegistrarAtividadesImpressoras then
              begin
                E2 := ERegistroDeOperacao.Create('Abrindo conexão com impressora: ' + inttostr(IdsTotens[I]) + ' - IP: ' + (FindComponent('PrinterClientSocket' + inttostr(IdsTotens[I])) as TClientSocket).Host);
                try
                  MyLogException(E2);
                finally
                  FreeAndNil(E2);
                end;
              end;

              (FindComponent('PrinterClientSocket' + inttostr(IdsTotens[I])) as TClientSocket).Open;
              Delay(100);
            end;
          except
          end;
      end
      else
      begin
        if vlTotens[I].IP <> '' then
        begin
          MyLogException(ERegistroDeOperacao.Create('Recriando socket com impressora ' + IntToStr(I) + ' - IP: ' + vlTotens[I].IP));
          CriaComponentePrinterClientSocket(I, string(vlTotens[I].IP), 3001);
        end;
      end;

    for I := 1 to vlNumeroDePrinterClientSockets do
    begin
      if vlTotens[IdsTotens[I]].StatusSocket = ssConnected then
      begin
        if vlTotens[IdsTotens[I]].KeepAliveTimeout = 0 then
        begin
          if vlRegistrarAtividadesImpressoras then
          begin
            E2 := ERegistroDeOperacao.Create('KeepAliveTimeout - Fechando conexão com impressora: ' + IntToStr(IdsTotens[I]) + ' - IP: ' + (FindComponent('PrinterClientSocket' + IntToStr(IdsTotens[I])) as TClientSocket).Host);
            try
              MyLogException(E2);
            finally
              FreeAndNil(E2);
            end;
          end;

          vlTotens[IdsTotens[I]].KeepAliveTimeout := 2;
          (FindComponent('PrinterClientSocket' + IntToStr(IdsTotens[I])) as TClientSocket).Close;
          vlTotens[IdsTotens[I]].StatusSocket := ssIdle;
        end
        else
          vlTotens[IdsTotens[I]].KeepAliveTimeout := vlTotens[IdsTotens[I]].KeepAliveTimeout - 1;
      end;

      if not(FindComponent('PrinterClientSocket' + IntToStr(IdsTotens[I])) as TClientSocket).Socket.Connected then
      begin
        if (FindComponent('PrinterClientSocket' + IntToStr(IdsTotens[I])) as TClientSocket).Socket.Connected then
          Timeouts[IdsTotens[I]] := 2;

        if Timeouts[IdsTotens[I]] = 0 then
        begin
          Timeouts[IdsTotens[I]] := 2;

          if vlRegistrarAtividadesImpressoras then
          begin
            E2 := ERegistroDeOperacao.Create('Timeout sem conexão com impressora: ' + IntToStr(IdsTotens[I]) + ' - IP: ' + (FindComponent('PrinterClientSocket' + IntToStr(IdsTotens[I])) as TClientSocket).Host);
            try
              MyLogException(E2);
            finally
              FreeAndNil(E2);
            end;
          end;

          if not(stSemConexao in vlTotens[IdsTotens[I]].StatusTotem) then
            EnviaEmail(IdsTotens[I], stSemConexao, false);

          vlTotens[IdsTotens[I]].StatusTotem := vlTotens[IdsTotens[I]].StatusTotem + [stSemConexao];
        end
        else
          Timeouts[IdsTotens[I]] := Timeouts[IdsTotens[I]] - 1;
      end;

      //envia comando de "keep alive" de cada totem
      s1 := '{{Solicita Status}}';
      ConverteProtocoloImpressora(s2, s1, vlTotens[IdsTotens[I]].TipoImpressora);
      Imprime(IdsTotens[I], s2);
    end;

{$ENDREGION}

{$REGION 'Teclados'}
    if vlUsarTeclados1200 then
    begin
      if vlNumeroDeTecladoClientSockets = -1 then
        for I := 0 to frmSicsMain.ComponentCount - 1 do
        begin
          if Pos('TecladoClientSocket', frmSicsMain.Components[I].Name) > 0 then
          begin
            if vlNumeroDeTecladoClientSockets = -1 then
              vlNumeroDeTecladoClientSockets := 1
            else
              vlNumeroDeTecladoClientSockets := vlNumeroDeTecladoClientSockets + 1;
          end;
        end;

      if vlNumeroDeTecladoClientSockets = -1 then
        vlNumeroDeTecladoClientSockets := -2;

      for I := 1 to vlNumeroDeTecladoClientSockets do
        if FindComponent('TecladoClientSocket' + IntToStr(I)) <> nil then
          if not(FindComponent('TecladoClientSocket' + IntToStr(I)) as TClientSocket).Active then
            try
              {$IFDEF SuportaPing}
              if Ping((FindComponent('TecladoClientSocket' + IntToStr(I)) as TClientSocket).Host, vgParametrosModulo.TimeoutPing, LRoundTripTime) then
                (FindComponent('TecladoClientSocket' + IntToStr(I)) as TClientSocket).Open;
              {$ENDIF SuportaPing}
            except
            end;

      GetSendPAsSituationTextParaTeclado(s1);
      GetSendWaitingPswdsTextParaTeclado(s2);

      if TecladoPort.Active then
      begin
        // ALTERAR FIRMWARE DO TECLADO PARA 4 BYTES DE ENDEREÇO!!!
        EnviarComandoTeclado('00' + Chr($3C) + s1);
        EnviarComandoTeclado('00' + Chr($3B) + s2);
        EnviarComandoTeclado('00' + Chr($78) + FormatDateTime('ddmmyyyyhhnnss', now));
      end;

      for I := 1 to vlNumeroDeTecladoClientSockets do
        if ((FindComponent('TecladoClientSocket' + IntToStr(I)) <> nil) and ((FindComponent('TecladoClientSocket' + IntToStr(I)) as TClientSocket).Active)) then
        begin
          //ALTERAR FIRMWARE DO TECLADO PARA 4 BYTES DE ENDEREÇO!!!
          (FindComponent('TecladoClientSocket'+inttostr(i)) as TClientSocket).Socket.SendText(STX + '00' + Chr($3C) + s1 + ETX);
          //tst        Application.ProcessMessages;
          (FindComponent('TecladoClientSocket'+inttostr(i)) as TClientSocket).Socket.SendText(STX + '00' + Chr($3B) + s2 + ETX);
          //tst        Application.ProcessMessages;
          (FindComponent('TecladoClientSocket'+inttostr(i)) as TClientSocket).Socket.SendText(STX + '00' + Chr($78) + FormatDateTime('ddmmyyyyhhnnss', now) + ETX);
          //Application.ProcessMessages;

          //ULog.TLog.GravarLogExecucao('PAsSituation: ' + '00' + Chr($3C) + s1);
          //ULog.TLog.GravarLogExecucao('WaitingPswds: ' + '00' + Chr($3B) + s2);
          //ULog.TLog.GravarLogExecucao('DataHora: ' + '00' + Chr($78) + FormatDateTime('ddmmyyyyhhnnss', now));
          // ALTERAR FIRMWARE DO TECLADO PARA 4 BYTES DE ENDEREÇO!!!
          //EnviaComando((FindComponent('TecladoClientSocket' + IntToStr(I)) as TClientSocket).Socket, '00' + Chr($3C) + s1);
          // tst        Application.ProcessMessages;
          //EnviaComando((FindComponent('TecladoClientSocket' + IntToStr(I)) as TClientSocket).Socket, '00' + Chr($3B) + s2);
          // tst        Application.ProcessMessages;
          //EnviaComando((FindComponent('TecladoClientSocket' + IntToStr(I)) as TClientSocket).Socket, '00' + Chr($78) + FormatDateTime('ddmmyyyyhhnnss', now));
        end;
    end;

{$ENDREGION}

{$REGION 'Paineis e TVs'}
    //conta quantos sockets de painéis foram criados em tempo de execução
    if vlNumeroDePainelClientSockets = -1 then
      for I := 0 to frmSicsMain.ComponentCount - 1 do
      begin
        if Pos('PainelClientSocket', frmSicsMain.Components[I].Name) > 0 then
        begin
          if vlNumeroDePainelClientSockets = -1 then
            vlNumeroDePainelClientSockets := 1
          else
            vlNumeroDePainelClientSockets := vlNumeroDePainelClientSockets + 1;
        end;
      end;

    if vlNumeroDePainelClientSockets = -1 then
      vlNumeroDePainelClientSockets := -2;

    //conecta cada socket que esteja desconectado
    for I := 1 to vlNumeroDePainelClientSockets do
      if FindComponent('PainelClientSocket' + IntToStr(I)) <> nil then
      begin
        if not(FindComponent('PainelClientSocket' + IntToStr(I)) as TClientSocket).Active then
          try
            {$IFDEF SuportaPing}
            if Ping((FindComponent('PainelClientSocket' + IntToStr(I)) as TClientSocket).Host, vgParametrosModulo.TimeoutPing, LRoundTripTime) then
              (FindComponent('PainelClientSocket' + IntToStr(I)) as TClientSocket).Open;
            {$ENDIF SuportaPing}
          except
            on E: Exception do
              TfrmDebugParameters.Debugar(tbTimers, 'Erro em PainelClientSocket.Open: ' + E.Message);
          end;
        //LM
        (FindComponent('PainelClientSocket' + IntToStr(I)) as TClientSocket).Socket.SendText(LSolicitaStatusTV);
        vlTVs[I].IP := (FindComponent('PainelClientSocket' + IntToStr(I)) as TClientSocket).Host;
      end;
{$ENDREGION}

  TfrmDebugParameters.Debugar(tbTimers, 'Saiu  CheckConnectionsTimerTimer');
end;

//JLS
function TfrmSicsMain.CheckMotivoPausaPermitidoNaPA(const PA: Integer;MotivoPausaRequisitado: Integer): boolean;
var
  IdModulo: Integer;
  aCDSPausaFiltro: TClientDataSet;
begin
  Result := False;
  aCDSPausaFiltro := GetNewCDSFilter(dmSicsMain.cdsMotivosDePausa);
  try
    IdModulo := GetIdModulo(dmSicsMain.connOnLine, PA);
    FiltraDataSetComPermitidas(dmSicsMain.connOnLine, aCDSPausaFiltro, IdModulo, tgPausa, 'ID_GRUPOMOTIVOSPAUSA');

    if (aCDSPausaFiltro.Locate('ID', MotivoPausaRequisitado, [])) then
    begin
      Result := aCDSPausaFiltro.FieldByName('Ativo').AsBoolean;
    end;
  finally
    FreeAndNil(aCDSPausaFiltro);
  end;
end;

{ proc CheckConnectionsTimer }

{ -------------------------------------------- }
{ Procedures de funcionamento da tela }

function TfrmSicsMain.EnviarComandoTeclado(const aProtocolo: String): BOolean;
begin
   TecladoPort.WriteText(AspStringToAnsiString(FormatarProtocolo(aProtocolo)));
   Application.ProcessMessages;
   Result := True;
end;

procedure TfrmSicsMain.ExcluirSenhasPelaFila(IdFila: integer);
var
//  iRow,
//  iRowCount,
//  lSenha     : Integer;
//  lDataHora  : TDateTime;
  i          : Integer;
  lStringGrid: TStringGrid;
begin
  lStringGrid := FindComponent('SenhasList' + IntToStr(IdFila)) as TStringGrid;

  {
  iRowCount := lStringGrid.RowCount;

  for iRow := 1 to iRowCount - 1 do
  begin
    lSenha    := StrToInt(lStringGrid.Cells[COL_SENHA, 1]);
    lDataHora := StrToDateTime(lStringGrid.Cells[COL_DATAHORA, 1]);

    RetrievePswd(IdFila, lSenha, lDataHora);
  end;
  }

  RemoverFilaTicketBD(IdFila);

  lStringGrid.Row      := 0;
  lStringGrid.RowCount := 1;
  InsertRow(lStringGrid, 1);

  for i := 0 to lStringGrid.ColCount - 1 do
  begin
    lStringGrid.Cells[i, 1] := '';
  end;

  lStringGrid.Row := 1;

  //RemoveRowTitled(lStringGrid, 1);

  AtualizaSenhaCountLabel(IdFila);
  SalvaSituacao_Fila(IdFila);
end;

class procedure TfrmSicsMain.ExecutaComandoPorPermissaoAdmin(const aProcExecutar: TRefProc;
  var aTentativasAcessoMenuProtegido: Integer; var aDataUltimaTentativasAcessoMenuProtegido: TDateTime);
var
  LListaSenhaDefault: Array of String;
  LDataUltimaTentativasAcessoMenuProtegido, LTentativasAcessoMenuProtegido: Pointer;

begin
  if ((Now - aDataUltimaTentativasAcessoMenuProtegido) > EncodeTime(1, 0, 0, 0)) then
  begin
    aTentativasAcessoMenuProtegido := 0;
  end;

  LTentativasAcessoMenuProtegido := @aTentativasAcessoMenuProtegido;
  aDataUltimaTentativasAcessoMenuProtegido := now;
  LDataUltimaTentativasAcessoMenuProtegido := @aDataUltimaTentativasAcessoMenuProtegido;
  Inc(aTentativasAcessoMenuProtegido);
  if (aTentativasAcessoMenuProtegido > 3) then
    raise Exception.CreateFmt('Quantidade de tentativas de acessar o menu protegido foi excedida %d.', [aTentativasAcessoMenuProtegido]);

  SetLength(LListaSenhaDefault, 1);
  LListaSenhaDefault[0] := '';
  InputQuery('Informe a senha de administrador para acessar o menu!',
    [#31 + 'Digite a senha'], LListaSenhaDefault,
    function (const Values: array of string): Boolean
    begin
      Result := True;
      if (Length(Values) = 1) and (Values[0] = cSenhaAdmin) then
      begin
        Integer(LTentativasAcessoMenuProtegido^) := 0;
        TDateTime(LDataUltimaTentativasAcessoMenuProtegido^) := 0;

        if Assigned(aProcExecutar) then
          aProcExecutar;
      end
      else
      begin
        ErrorMessage('Senha inválida!');
      end;
    end);
end;

class procedure TfrmSicsMain.ExibirConfigModuloCallCenter(
  const aOwner: TComponent; var aTentativasAcessoMenuProtegido: Integer;
  var aDataUltimaTentativasAcessoMenuProtegido: TDateTime);
begin
  ExecutaComandoPorPermissaoAdmin(
    procedure ()
    var
      LFrmConfiguracoesSicsCallCenter: TFrmConfiguracoesSicsCallCenter;
    begin
      LFrmConfiguracoesSicsCallCenter := TFrmConfiguracoesSicsCallCenter.Create(aOwner);
      try
        LFrmConfiguracoesSicsCallCenter.ShowModal;
      finally
        FreeAndNil(LFrmConfiguracoesSicsCallCenter);
      end;
    end, aTentativasAcessoMenuProtegido, aDataUltimaTentativasAcessoMenuProtegido);
end;

class procedure TfrmSicsMain.ExibirConfigModuloMultiPA(const aOwner: TComponent;
      var aTentativasAcessoMenuProtegido: Integer; var aDataUltimaTentativasAcessoMenuProtegido: TDateTime);
begin
  ExecutaComandoPorPermissaoAdmin(
    procedure ()
    var
      LFrmConfiguracoesSicsMultiPA: TFrmConfiguracoesSicsMultiPA;
    begin
      LFrmConfiguracoesSicsMultiPA := TFrmConfiguracoesSicsMultiPA.Create(aOwner);
      try
        LFrmConfiguracoesSicsMultiPA.ShowModal;
      finally
        FreeAndNil(LFrmConfiguracoesSicsMultiPA);
      end;
    end, aTentativasAcessoMenuProtegido, aDataUltimaTentativasAcessoMenuProtegido);
end;

class procedure TfrmSicsMain.ExibirConfigModuloOnline(const aOwner: TComponent;
      var aTentativasAcessoMenuProtegido: Integer; var aDataUltimaTentativasAcessoMenuProtegido: TDateTime);
begin
  ExecutaComandoPorPermissaoAdmin(
    procedure ()
    var
      LFrmConfiguracoesSicsOnLine: TFrmConfiguracoesSicsOnLine;
    begin
      LFrmConfiguracoesSicsOnLine := TFrmConfiguracoesSicsOnLine.Create(aOwner);
      try
        LFrmConfiguracoesSicsOnLine.ShowModal;
      finally
        FreeAndNil(LFrmConfiguracoesSicsOnLine);
      end;
    end, aTentativasAcessoMenuProtegido, aDataUltimaTentativasAcessoMenuProtegido);
end;

class procedure TfrmSicsMain.ExibirConfigModuloPA(const aOwner: TComponent;
      var aTentativasAcessoMenuProtegido: Integer; var aDataUltimaTentativasAcessoMenuProtegido: TDateTime);
begin
  ExecutaComandoPorPermissaoAdmin(
    procedure ()
    var
      LFrmConfiguracoesSicsPA: TFrmConfiguracoesSicsPA;
    begin
      LFrmConfiguracoesSicsPA := TFrmConfiguracoesSicsPA.Create(aOwner);
      try
        LFrmConfiguracoesSicsPA.ShowModal;
      finally
        FreeAndNil(LFrmConfiguracoesSicsPA);
      end;
    end, aTentativasAcessoMenuProtegido, aDataUltimaTentativasAcessoMenuProtegido);
end;

class procedure TfrmSicsMain.ExibirConfigModuloTGS(const aOwner: TComponent;
      var aTentativasAcessoMenuProtegido: Integer; var aDataUltimaTentativasAcessoMenuProtegido: TDateTime);
begin
  ExecutaComandoPorPermissaoAdmin(
    procedure ()
    var
      LFrmConfiguracoesSicsTGS: TFrmConfiguracoesSicsTGS;
    begin
      LFrmConfiguracoesSicsTGS := TFrmConfiguracoesSicsTGS.Create(aOwner);
      try
        LFrmConfiguracoesSicsTGS.ShowModal;
      finally
        FreeAndNil(LFrmConfiguracoesSicsTGS);
      end;
    end, aTentativasAcessoMenuProtegido, aDataUltimaTentativasAcessoMenuProtegido);
end;

procedure TfrmSicsMain.SenhaEdit1Enter(Sender: TObject);
var
  BM: TBookmark;
begin
  with dmSicsMain.cdsFilas do
  begin
    BM := GetBookmark;
    try
      try
      First;
      while not Eof do
      begin
        if FieldByName('Ativo').AsBoolean then
        begin
          (frmSicsMain.FindComponent('InsertSenhaButton' + FieldByName('ID').AsString) as TButton).Default := (Sender = (frmSicsMain.FindComponent('SenhaEdit' + FieldByName('ID').AsString) as TEdit));
        end;
        Next;
      end;
      finally
        if BookmarkValid(BM) then
          GotoBookmark(BM);
      end;
    finally
      FreeBookmark(BM);
    end;
  end; // with cds
end;   { proc SenhaEditEnter }

procedure TfrmSicsMain.InsertSenhaButton1Click(Sender: TObject);
var
  I,
  SenhaInserida: Integer;

  TipoInsercao: TTipoDeInsercaoDeSenha;

  lEdit: TEdit;
begin
  if Sender is TButton then
  begin
    I := (Sender as TButton).Tag;

    lEdit := FindComponent('SenhaEdit' + IntToStr(I)) as TEdit;

    TipoInsercao  := GerarNovaSenhaOuManterUltima(lEdit.Text);
    SenhaInserida := StrToInt(lEdit.Text);

    InserirSenhaNaFila(i, SenhaInserida, -1, TipoInsercao);

    lEdit.Clear;
  end;   { if Sender isTButton }
end;     { proc InsertBtn_X_OnClick }

procedure TfrmSicsMain.SenhaEdit1Change(Sender: TObject);
var
  I: Integer;
begin
  if Sender is TEdit then
  begin
    I := (Sender as TEdit).Tag;
    try
      (FindComponent('InsertSenhaButton' + IntToStr(I)) as TButton).Enabled := True;
      if (Sender as TEdit).Text <> '' then
        StrToInt((Sender as TEdit).Text)
      else
        (FindComponent('InsertSenhaButton' + IntToStr(I)) as TButton).Enabled := false;
    except
      (FindComponent('InsertSenhaButton' + IntToStr(I)) as TButton).Enabled := false;
    end { try .. except }
  end;  { if Sender is TEdit }
end;    { proc Edit_X_OnChange }

procedure TfrmSicsMain.SenhasList1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Sender is TStringGrid then
  begin
    if ((vgParametrosModulo.PermiteExcluirSenhas) and (Key = VK_DELETE) and (Application.MessageBox('Excluir senha selecionada?', 'Confirmação', MB_ICONQUESTION or MB_YESNOCANCEL) = idYES)) then
    begin
      RemoveRow((Sender as TStringGrid), (Sender as TStringGrid).Row);
      AtualizaSenhaCountLabel((Sender as TStringGrid).Tag);
      SalvaSituacao_Fila((Sender as TStringGrid).Tag);
    end;
  end; { if Sender is TStringGrid }
end;   { proc SenhasList1KeyUp }

procedure TfrmSicsMain.ProcessarTelas(AIdTela, AIdTelaPrincipal: integer; AArray: TJSONArray; AProcessadas: TList<integer>);
var
    LJSONTela             : TJSONObject;
    LArrayBotao           : TJSONArray;
    LJSONBotao            : TJSONObject;
    LDSTela               : TDataSet;
    LDSBotao              : TDataSet;
    LSQLMULTITELAS        : String;
    LSQLMULTITELAS_BOTOES : String;
    LIdProxima: Integer;
begin
  {$REGION '//SQL para recuperar uma tela'}
  LSQLMULTITELAS :=
    'SELECT                                           ' + sLineBreak +
    '  TE.*                                           ' + sLineBreak +
    'FROM                                             ' + sLineBreak +
    '  MULTITELAS TE                                  ' + sLineBreak +
    'WHERE                                            ' + sLineBreak +
    '  TE.ID = %d';
  {$ENDREGION}

  {$REGION '//SQL para recuperar os botões de uma tela'}
  LSQLMULTITELAS_BOTOES :=
    'SELECT                   ' + sLineBreak +
    '  B.ID,                  ' + sLineBreak +
    '  B.NOME,                ' + sLineBreak +
    '  B.POS_LEFT,            ' + sLineBreak +
    '  B.POS_TOP,             ' + sLineBreak +
    '  B.TAM_WIDTH,           ' + sLineBreak +
    '  B.TAM_HEIGHT,          ' + sLineBreak +
    '  B.ID_TELA,             ' + sLineBreak +
    '  B.ID_PROXIMATELA,      ' + sLineBreak +
    '  B.ID_FILA,             ' + sLineBreak +
    '  B.ID_TAG,              ' + sLineBreak +
    '  FL.NOMENOTOTEM         ' + sLineBreak +
    'FROM MULTITELAS_BOTOES B ' + sLineBreak +
    '  LEFT JOIN FILAS FL ON (FL.ID = B.ID_FILA) ' + sLineBreak +
    '  WHERE B.ID_TELA = %d';
  {$ENDREGION}

  //recuperar tela do Id
  dmSicsMain.connOnline.ExecSQL( Format(LSQLMULTITELAS,[AIdTela] ), LDSTela);
  try
    LJSONTela := TJSONObject.Create;
    LJSONTela.AddPair('id'               , TJSONNumber.Create(LDSTela.FieldByName('id'               ).AsString));
    LJSONTela.AddPair('nome'             , LDSTela.FieldByName('nome'             ).AsString);
    LJSONTela.AddPair('fechar'           , LDSTela.FieldByName('fechar'           ).AsString);
    LJSONTela.AddPair('intervalo'        , LDSTela.FieldByName('intervalo'        ).AsString);
    LJSONTela.AddPair('momento_impressao', LDSTela.FieldByName('momento_impressao').AsString);
    LJSONTela.AddPair('imagem'           , '');
    if AIdTela = AIdTelaPrincipal then
      LJSONTela.AddPair('principal', 'S')
    else
      LJSONTela.AddPair('principal', 'N');
    AArray.Add(LJSONTela);

    //controle para evitar processar novamente uma mesma tela
    AProcessadas.Add(AIdTela);

    //recuperar botoes da tela do Id
    LArrayBotao := TJSONArray.Create;
    dmSicsMain.connOnline.ExecSQL(Format(LSQLMULTITELAS_BOTOES,[AIdTela]), LDSBotao);
    try
      while not LDSBotao.Eof do
      begin
        LJSONBotao := TJSONObject.Create;
        LJSONBotao.AddPair('id'             , TJSONNumber.Create(LDSBotao.FieldByName('id'            ).AsInteger));
        LJSONBotao.AddPair('nome'           , LDSBotao.FieldByName('nome'          ).AsString);
        LJSONBotao.AddPair('pos_left'       , TJSONNumber.Create(LDSBotao.FieldByName('pos_left'      ).AsInteger));
        LJSONBotao.AddPair('pos_top'        , TJSONNumber.Create(LDSBotao.FieldByName('pos_top'       ).AsInteger));
        LJSONBotao.AddPair('size_width'     , TJSONNumber.Create(LDSBotao.FieldByName('tam_width'     ).AsInteger));
        LJSONBotao.AddPair('size_height'    , TJSONNumber.Create(LDSBotao.FieldByName('tam_height'    ).AsInteger));
        LJSONBotao.AddPair('id_tela'        , TJSONNumber.Create(LDSBotao.FieldByName('id_tela'       ).AsInteger));
        LJSONBotao.AddPair('id_proxima_tela', TJSONNumber.Create(LDSBotao.FieldByName('id_proximatela').AsInteger));
        LJSONBotao.AddPair('id_fila'        , TJSONNumber.Create(LDSBotao.FieldByName('id_fila'       ).AsInteger));
        LJSONBotao.AddPair('id_tag'         , TJSONNumber.Create(LDSBotao.FieldByName('id_tag'        ).AsInteger));
        LJSONBotao.AddPair('texto_no_totem' , LDSBotao.FieldByName('nomenototem'   ).AsString);
        LArrayBotao.AddElement(LJSONBotao);

        //para cada botao, se houver tela vinculada e esta ainda não foi
        //processada, chamar ProcessarTelas(botao.proximaTela)
        LIdProxima := LDSBotao.FieldByName('id_proximatela').AsInteger;
        if (LIdProxima > 0) and (not AProcessadas.Contains(LIdProxima)) then
          ProcessarTelas(LIdProxima, AIdTelaPrincipal, AArray, AProcessadas);

        LDSBotao.Next;
      end;
      LJSONTela.AddPair('botoes', LArrayBotao) ;
    finally
      LDSBotao.Free;
    end;
  finally
    LDSTela.Free;
  end;
end;

function TfrmSicsMain.GetSendListaDeBotoesPorTotem(const AIDTotem: Integer): String;
var LJSONTotem            : TJSONObject;
    LArrayTela            : TJSONArray;
    LDSTotem              : TDataSet;
    LSQLTOTEM             : String;
    LIDTela               : Integer;
    LTelasProcessadas     : TList<integer>;
begin
  LSQLTOTEM := 'SELECT T.* FROM TOTENS T WHERE T.ID = %d';

  LJSONTotem := TJSONObject.Create;
  try
    dmSicsMain.connOnLine.ExecSQL( Format(LSQLTOTEM,[AIDTotem] ), LDSTotem );

    {$REGION 'Totem'}
    LJSONTotem.AddPair('id'                     , TJSONNumber.Create(LDSTotem.FieldByName('id'                     ).AsInteger));
    LJSONTotem.AddPair('nome'                   , LDSTotem.FieldByName('nome'                   ).AsString);
    LJSONTotem.AddPair('id_tela'                , TJSONNumber.Create(LDSTotem.FieldByName('id_tela'                ).AsInteger));
    LJSONTotem.AddPair('tempo_inatividade'      , TJSONNumber.Create(LDSTotem.FieldByName('tempo_inatividade'      ).AsInteger));
    LJSONTotem.AddPair('porta_tcp'              , TJSONNumber.Create(LDSTotem.FieldByName('porta_tcp'              ).AsInteger));
    LJSONTotem.AddPair('porta_serial_impressora', LDSTotem.FieldByName('porta_serial_impressora').AsString);
    {$ENDREGION}

    LIDTela := LDSTotem.FieldByName('id_tela').AsInteger;
    if LIDTela > 0 then
    begin
      LTelasProcessadas := TList<integer>.Create;
      try
        LArrayTela := TJSONArray.Create;
        ProcessarTelas(LIDTela, LIDTela, LArrayTela, LTelasProcessadas);
        LJSONTotem.AddPair('telas', LArrayTela);
      finally
        LTelasProcessadas.Free;
      end;
    end;

    Result :=  LJSONTotem.ToJSON;
  finally
    LJSONTotem.Free;
  end;
end;

function TfrmSicsMain.GetSendListaDeTotens: String;
var
  LConexao: TFDConnection;
  LQuery:   TFDQuery;
  LSQL:     String;
  LCount:   Integer;
begin
  Result   := EmptyStr;
  LCount   := 0;
  LSQL     := 'SELECT ID, NOME, IP, ID_MODELOTOTEM FROM TOTENS WHERE ID_UNIDADE = :ID_UNIDADE';

  LConexao := TFDConnection.Create(Nil);
  LConexao.Close;
  LConexao.ConnectionDefName := TConexaoBD.Nome;
  LConexao.Open;

  try
    LQuery := TFDQuery.Create(nil);
    LQuery.Close;
    LQuery.Connection := LConexao;
    LQuery.SQL.Text   := LSQL;
    LQuery.Open;

    try
      if not LQuery.IsEmpty then
      begin
        while not LQuery.Eof do
        begin
          LCount := (LCount +1);
          Result := Result + LQuery.FieldByName('ID').AsString   +';'+
                             LQuery.FieldByName('NOME').AsString +';'+
                             LQuery.FieldByName('IP').AsString   +';'+
                             LQuery.FieldByName('ID_MODELOTOTEM').AsString + TAB;

          LQuery.Next;
        end;
        Result := TAspEncode.AspIntToHex(LCount, 4) + Result;
      end;
    finally
      FreeAndNil(LQuery);
    end;

  finally
    FreeAndNil(LConexao);
  end;
end;

procedure TfrmSicsMain.ListBlocked1Click(Sender: TObject);
var
  aux: string;
begin
  GetSendSituacaoPrioritariasBloqueadasText(aux);
  EnviaParaTodosOsClients(TGSServerSocket.Socket, '0000' + Chr($6F) + aux);
end; { proc ListBloqued1Click }

procedure TfrmSicsMain.PrioritaryList1Click(Sender: TObject);
var
  aux: string;
  BM : TBookmark;
begin
  if (Sender as TCheckBox).Checked then
  begin
    with dmSicsMain.cdsFilas do
    begin
      BM := GetBookmark;
      try
        try
        First;
        while not Eof do
        begin
          if (((Sender as TCheckBox).Name <> 'PrioritaryList' + FieldByName('ID').AsString) and (frmSicsMain.FindComponent('PrioritaryList' + FieldByName('ID').AsString) <> nil)) then
            ((frmSicsMain.FindComponent('PrioritaryList' + FieldByName('ID').AsString)) as TCheckBox).Checked := false;
          Next;
        end;
        finally
          if BookmarkValid(BM) then
            GotoBookmark(BM);
        end;
      finally
        FreeBookmark(BM);
      end;
    end; // with cds

    fFilaPrioritaria := (Sender as TCheckBox).Tag;

    ((FindComponent('ListBlocked' + IntToStr(fFilaPrioritaria))) as TCheckBox).Checked := false;
  end
  else
    fFilaPrioritaria := 0;

  GetSendSituacaoPrioritariasBloqueadasText(aux);
  EnviaParaTodosOsClients(TGSServerSocket.Socket, '0000' + Chr($6F) + aux);
end;
{ proc PrioritaryList1Click }

procedure TfrmSicsMain.SenhasList1DrawCell(Sender: TObject; Col, Row: Longint; Rect: TRect; State: TGridDrawState);
var
  //Center,
//  sot             : Integer;
  TagColor, TagID, TagNome: String; // RAP
  LGrid: TStringGrid;
begin
  if Assigned(Sender) and (Sender is TStringGrid) then
  begin
    LGrid := TStringGrid(Sender);
    Rect.Left   := Rect.Left - 3;

    if (Row = 0) or (Col = COL_SENHA) or (Col = COL_HORA) then
    else
    begin
      LGrid.ColWidths[COL_SENHA] := LGrid.Canvas.TextWidth(' Senha ');
    end;

    if vgMostrarNomeCliente then
    begin
      LGrid.ColWidths[COL_HORA] := LGrid.Canvas.TextWidth(' 88:88:88 ');
      LGrid.ColWidths[COL_NOME] := LGrid.ClientWidth - LGrid.ColWidths[COL_SENHA] - LGrid.ColWidths[COL_HORA] - (WIDTH_COLS_TAGS * fMaxTags) - fMaxTags - 3; // RAP
    end
    else
    begin
      LGrid.ColWidths[COL_HORA] := LGrid.ClientWidth - LGrid.ColWidths[COL_SENHA] - (WIDTH_COLS_TAGS * fMaxTags) - fMaxTags - 2; // RAP
      LGrid.ColWidths[COL_NOME] := -1;
    end;

    if Row <> 0 then
      try
        if (Col >= COL_PRIMEIRA_TAG)  then
        begin
          if (TStringGrid(Sender).Cells[Col, Row] <> '') then
          begin
            SeparaStrings(LGrid.Cells[Col, Row], ';', TagID, TagColor);
            SeparaStrings(TagColor, ';', TagColor, TagNome);
            TStringGrid(Sender).Canvas.Brush.Color := StrToInt(TagColor);
            LGrid.Canvas.FillRect(Rect);
          end
          else
          begin
            LGrid.Canvas.Brush.Color := clWindow;
            LGrid.Canvas.FillRect(Rect);
          end;
        end;
      except
        { do nothing }
      end;
  end; { if Sender is TStringGrid }
end;   { proc SenhasListDrawCell }

procedure TfrmSicsMain.GeraSenhaEImprime(fila, IdPrinter: Integer; out Senha: Integer; out DtHr: TDateTime);
const
  vlUltimaSenhaGerada: array [0 .. cgMaxTotens] of TDateTime = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
var
  lID,
  SenhaImpressa: Integer;
  BM           : TBookmark;
  iNegativo    : Integer;
  LDtHrSenha   : TDateTime;
  FilaAnterior : integer;
  sAux         : string;
  dtAux        : TDateTime;
begin
  // Considerar como o primeiro totem (até para efeito do array vlUltimaSenhaGerada) caso não seja LPT nem Com
//  if IdPrinter = 0 then
//  begin
//    if (PrinterPort.DeviceName <> '') and ((UpperCase(PrinterPort.DeviceName[1]) <> 'L') and (UpperCase(PrinterPort.DeviceName[1]) <> 'C')) then
//      IdPrinter := 1;
//  end;

  TfrmDebugParameters.Debugar (tbGeracaoSenhas, 'Entrou GeraSenhaEImprime');

  if FilaEhValida(fila) then
  begin
    with TIniFile.Create(GetIniFileName) do
      try

        if ((now - vlUltimaSenhaGerada[IdPrinter] < EncodeTime(0, 0, ReadInteger('DEBUG', 'TimeoutEntreDuasImpressoes', 4), 0)) and
            (IdPrinter > 0)) then
        begin
          Exit
        end
        else
        begin
          vlUltimaSenhaGerada[IdPrinter] := now;
        end;

      finally
        Free;
      end; { try .. finaly }

    BM := dmSicsMain.cdsFilas.GetBookmark;
    try
      try
        if dmSicsMain.cdsFilas.Locate('ID', fila, []) then
        begin
          //RA
          {$REGION 'Código anterior comentado'}
          (*
          with dmSicsMain.cdsContadoresDeFilas do
          begin
            SenhaImpressa := dmSicsMain.cdsFilas.FieldByName('CONTADOR').AsInteger;
            Edit;
            if SenhaImpressa = dmSicsMain.cdsFilas.FieldByName('RANGEMAXIMO').AsInteger then
              FieldByName('CONTADOR').AsInteger := dmSicsMain.cdsFilas.FieldByName('RANGEMINIMO').AsInteger
            else
              FieldByName('CONTADOR').AsInteger := SenhaImpressa + 1;
            Post;
          end;
          *)
          {$ENDREGION}

          if AtualizarContadoresDeFilas(fila) then
          begin
            SenhaImpressa := dmSicsMain.cdsContadoresDeFilas.FieldByName('CONTADOR').AsInteger;

            if (SenhaImpressa <  dmSicsMain.cdsFilas.FieldByName('RANGEMINIMO').AsInteger) or
               (SenhaImpressa >= dmSicsMain.cdsFilas.FieldByName('RANGEMAXIMO').AsInteger) then
            begin
              SenhaImpressa := dmSicsMain.cdsFilas.FieldByName('RANGEMINIMO').AsInteger;
            end
            else
            begin
              SenhaImpressa := SenhaImpressa + 1;
            end;

            LimparFilaTicket(SenhaImpressa, fila);
            FilaAnterior := ProcuraNasFilas(SenhaImpressa, sAux, dtAux);
            if FilaAnterior > 0 then
              RetrievePswd(FilaAnterior, SenhaImpressa, dtAux);

            dmSicsMain.cdsContadoresDeFilas.Edit;
            dmSicsMain.cdsContadoresDeFilas.FieldByName('CONTADOR').AsInteger := SenhaImpressa;
            dmSicsMain.cdsContadoresDeFilas.Post;
            dmSicsMain.cdsContadoresDeFilas.ApplyUpdates(0);
          end;

          dmSicsMain.cdsContadoresDeFilas.Close;

          LDtHrSenha := Now;

          with cdsIdsTickets do
          begin
            //if Locate('NUMEROTICKET', SenhaImpressa, []) then
            if BuscarMaxIDSenha(SenhaImpressa) then
            begin
              // limpando as tags
              with cdsIdsTicketsTags do
              begin
                Filter   := 'Ticket_Id=' + cdsIdsTickets.FieldByName('ID').AsString;
                Filtered := True;
                try
                  while not IsEmpty do
                    Delete;

                  if ChangeCount > 0 then
                  begin
                    ApplyUpdates(0);
                  end;
                finally
                  Filtered := false;
                end;
              end;

              // limpando os agendamentos por fila
              with cdsIdsTicketsAgendamentosFilas do
              begin
                Filter   := 'Id_Ticket=' + cdsIdsTickets.FieldByName('ID').AsString;
                Filtered := True;
                try
                  while not IsEmpty do
                  begin
                    Delete;
                  end;

                  if ChangeCount > 0 then
                  begin
                    ApplyUpdates(0);
                  end;
                finally
                  Filtered := false;
                end;
              end;
            end;

            // se for servidor de contigencia, os ids dos tickets sao inserido como negativos
            iNegativo := IfThen(dmSicsContingencia.TipoFuncionamento = tfContingente, -1, 1);

            lID := TGenerator.NGetNextGenerator('GEN_ID_TICKET', dmSicsMain.connOnLine) * iNegativo;

            RegistraTicket(lID, SenhaImpressa, Fila,  -2, LDtHrSenha);

            AtualizarIDsTickets;
          end;

          TfrmDebugParameters.Debugar (tbGeracaoSenhas, 'Gerou Senha ' + SenhaImpressa.ToString + ', inserindo na fila ' + fila.ToString + '...' );
          InsertPswd(fila, SenhaImpressa, LDtHrSenha, -2);
          TfrmDebugParameters.Debugar (tbGeracaoSenhas, 'Senha ' + SenhaImpressa.ToString + ', inserida na fila ' + fila.ToString + '.' );

          Senha := SenhaImpressa;
          DtHr  := LDtHrSenha;

          TfrmDebugParameters.Debugar (tbGeracaoSenhas, 'Imprimindo Senha ' + SenhaImpressa.ToString + '...' );
          PrintPassword(IdPrinter, SenhaImpressa, fila);
          TfrmDebugParameters.Debugar (tbGeracaoSenhas, 'Senha ' + SenhaImpressa.ToString + ' impressa.' );
        end
        else
          AppMessageBox('Erro ao gerar senha. Fila = ' + IntToStr(fila), 'ERRO', MB_ICONSTOP);
      finally
        if dmSicsMain.cdsFilas.BookmarkValid(BM) then
          dmSicsMain.cdsFilas.GotoBookmark(BM);
      end;
    finally
      dmSicsMain.cdsFilas.FreeBookmark(BM);
      TfrmDebugParameters.Debugar (tbGeracaoSenhas, 'Saiu GeraSenhaEImprime');
    end;
  end;
end;

procedure TfrmSicsMain.Reimprime(Senha, IdPrinter: Integer);
begin
  // Considerar como o primeiro totem (até para efeito do array vlUltimaSenhaGerada) caso não seja LPT nem Com
//  if IdPrinter = 0 then
//  begin
//    if (PrinterPort.DeviceName <> '') and ((UpperCase(PrinterPort.DeviceName[1]) <> 'L') and (UpperCase(PrinterPort.DeviceName[1]) <> 'C')) then
//      IdPrinter := 1;
//  end;

  PrintPassword(IdPrinter, Senha, NGetFilaFromRange(Senha));
end;

procedure TfrmSicsMain.BitBtnClick(Sender: TObject);
var
  fila, SenhaGerada: Integer;
  LDtHrSenha: TDateTime;
begin
  if ((Sender is TBitBtn) or (Sender is TMenuItem)) then
  begin
    fila := (Sender as TComponent).Tag;

    if ((FindComponent('BitBtn' + IntToStr(fila)) <> nil) and ((FindComponent('BitBtn' + IntToStr(fila)) as TBitBtn).Visible)) then
      GeraSenhaEImprime(fila, ImpressoraDefault, SenhaGerada, LDtHrSenha);
  end; { if Sender is TBitBtn }
end;   { proc BitBtn1Click }

procedure TfrmSicsMain.PainelPortCts(Sender: TObject);
var
  SenhaGerada: Integer;
  LDtHrSenha: TDateTime;
begin
  if PainelPort.CTS then
    GeraSenhaEImprime(vlBotoesRetiradaManual[1], ImpressoraDefault, SenhaGerada, LDtHrSenha);
end;
{ proc PainelPortCts }

procedure TfrmSicsMain.PainelPortDsr(Sender: TObject);
var
  SenhaGerada: Integer;
  LDtHrSenha: TDateTime;
begin
  if PainelPort.DSR then
    GeraSenhaEImprime(vlBotoesRetiradaManual[2], ImpressoraDefault, SenhaGerada, LDtHrSenha);
end;

procedure TfrmSicsMain.PainelPortTxEmpty(Sender: TObject);
begin
  fTransmitindoParaPainel := false;
end; { proc PainelPortTxEmpty }

procedure TfrmSicsMain.PrinterClientSocketLookup(Sender: TObject; Socket: TCustomWinSocket);
begin
  vlTotens[(Sender as TClientSocket).Tag].StatusSocket := ssLookingUp;

  if vlRegistrarAtividadesImpressoras then
    MyLogException(ERegistroDeOperacao.Create('SocketLookUp - Impressora: ' + IntToStr((Sender as TClientSocket).Tag) + ' - IP: ' + (Sender as TClientSocket).Host));
end; { proc PrinterClientSocketLookup }

procedure TfrmSicsMain.PrinterClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  vlTotens[(Sender as TClientSocket).Tag].StatusSocket := ssConnected;

  if vlRegistrarAtividadesImpressoras then
    MyLogException(ERegistroDeOperacao.Create('SocketConnect - Impressora: ' + IntToStr((Sender as TClientSocket).Tag) + ' - IP: ' + (Sender as TClientSocket).Host));
end; { proc PrinterClientSocketConnect }

procedure TfrmSicsMain.PrinterClientSocketConnecting(Sender: TObject; Socket: TCustomWinSocket);
begin
  vlTotens[(Sender as TClientSocket).Tag].StatusSocket := ssConnecting;

  if vlRegistrarAtividadesImpressoras then
    MyLogException(ERegistroDeOperacao.Create('SocketConnecting - Impressora: ' + IntToStr((Sender as TClientSocket).Tag) + ' - IP: ' + (Sender as TClientSocket).Host));
end; { proc PrinterClientSocketConnecting }

procedure TfrmSicsMain.PrinterClientSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  vlTotens[(Sender as TClientSocket).Tag].StatusSocket := ssIdle;

  if vlRegistrarAtividadesImpressoras then
    MyLogException(ERegistroDeOperacao.Create('SocketDisconnect - Impressora: ' + IntToStr((Sender as TClientSocket).Tag) + ' - IP: ' + (Sender as TClientSocket).Host));
end; { proc PrinterClientSocketDisconnect }

procedure TfrmSicsMain.PrinterClientSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  Socket.Close;
  vlTotens[(Sender AS TClientSocket).Tag].StatusSocket := ssIdle;

  if vlRegistrarAtividadesImpressoras then
    MyLogException(ERegistroDeOperacao.Create('SocketError - Impressora: ' + IntToStr((Sender as TClientSocket).Tag) + ' - IP: ' + (Sender as TClientSocket).Host + ' - Erro: ' + IntToStr(ErrorCode)));

  if ErrorCode = 10038 then
  begin
    (Sender as TClientSocket).Destroy;
    TClientSocket(Sender) := nil;
    MyLogException(ERegistroDeOperacao.Create('Erro 10038 - Socket foi inutilizado e será reconstruído.'));
  end;

  ErrorCode := 0;
end; { proc PrinterClientSocketError }

procedure TfrmSicsMain.PrinterClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
const
  ReceivingProtocol: array [1 .. cgMaxTotens] of Boolean = (false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false);
  Protocol: array [1 .. cgMaxTotens] of string           = ('', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
var
  S: string;
  I: Word;
begin
  S := AspAnsiStringToString(Socket.ReceiveText);

  for I := 1 to Length(S) do
  begin
    if S[I] = '!' then
      ReceivingProtocol[(Sender as TClientSocket).Tag] := True
    else if S[I] = '$' then
    begin
      ReceivingProtocol[(Sender as TClientSocket).Tag] := false;

      Protocol[(Sender as TClientSocket).Tag] := '!' + Protocol[(Sender as TClientSocket).Tag] + '$';
      DecifraProtocoloTotem((Sender as TClientSocket).Tag, Protocol[(Sender as TClientSocket).Tag]);

      Protocol[(Sender as TClientSocket).Tag] := '';
    end
    else if ReceivingProtocol[(Sender as TClientSocket).Tag] then
      Protocol[(Sender as TClientSocket).Tag] := Protocol[(Sender as TClientSocket).Tag] + S[I];
  end; { for }
end;   { proc PrinterClientSocketRead }

procedure TfrmSicsMain.PainelClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
const
  ReceivingProtocol: Boolean = false;
  Protocol: string           = '';
var
  I     : Word;
  S, aux: string;
begin
  S := AspAnsiStringToString(Socket.ReceiveText);

  for I := 1 to Length(S) do
  begin
    // try
    if S[I] = STX then
    begin
      ReceivingProtocol := True;
      Protocol          := '';
    end
    else if S[I] = ETX then
    begin
      ReceivingProtocol := false;

      Protocol := STX + Protocol + ETX;

      aux := DecifraProtocolo(Protocol, Socket.LocalPort, Socket.RemoteAddress + ' (socket de painel ou SICS TV)');

      if aux <> '' then
        EnviaComando(Socket, aux);

      Protocol := '';
    end
    else if ReceivingProtocol then
      Protocol := Protocol + S[I];
  end; { for }
end;

procedure TfrmSicsMain.PrinterPortRxChar(Sender: TObject; Count: Integer);
{$IFDEF SuportaPortaCom}
const
  ReceivingProtocol: Boolean = false;
  Protocol: string           = '';
var
  I: Word;
  X: TAspAnsiChar;
{$ENDIF SuportaPortaCom}
begin
  {$IFDEF SuportaPortaCom}
  for I := 1 to Count do
  begin

    PrinterPort.ReadChar(X);
    if X = '!' then
      ReceivingProtocol := True
    else if X = '$' then
    begin
      ReceivingProtocol := false;

      Protocol := '!' + Protocol + '$';
      DecifraProtocoloTotem(0, Protocol);

      Protocol := '';
    end
    else if ReceivingProtocol then
      Protocol := Protocol + AspAnsiCharToString(X);
  end; { for }
  {$ENDIF SuportaPortaCom}
end;

procedure TfrmSicsMain.Botoeiras3B2LPortRxChar(Sender: TObject; Count: Integer);
{$IFDEF SuportaPortaCom}
const
  ReceivingProtocol: Boolean = false;
  Protocol: string           = '';
var
  X: TAspAnsiChar;
  I: Word;
{$ENDIF SuportaPortaCom}
begin
  {$IFDEF SuportaPortaCom}
  for I := 1 to Count do
  begin
    Botoeiras3B2LPort.ReadChar(X);
    if X = '!' then
      ReceivingProtocol := True
    else if X = '$' then
    begin
      ReceivingProtocol := false;

      Protocol := '!' + Protocol + '$';
      DecifraBotoeiras3B2L(Protocol);

      Protocol := '';
    end
    else if ReceivingProtocol then
      Protocol := Protocol + AspAnsiCharToString(X);
  end; { for }
  {$ENDIF SuportaPortaCom}
end;

procedure TfrmSicsMain.TecladoPortRxChar(Sender: TObject; Count: Integer);
{$IFDEF SuportaPortaCom}
const
  ReceivingProtocol: Boolean = false;
  Protocol: string           = '';
var
  X: AnsiChar;
  I: Word;
  S: string;
{$ENDIF SuportaPortaCom}
begin
  {$IFDEF SuportaPortaCom}
  for I := 1 to Count do
  begin
    TecladoPort.ReadChar(X);
    if X = STX then
    begin
      ReceivingProtocol := True;
      Protocol          := '';
    end
    else if X = ETX then
    begin
      ReceivingProtocol := false;

      // ADD '00' PQ TECLADO AINDA NÃO MANDA 4 DIGITOS PARA A PA. REVISAR FW e TIRAR ISTO!
      Protocol := FormatarProtocolo('00' + Protocol);

      // NO COMANDO DE ENCAMINHA PARA OUTRA FILA, ADD '00' PQ TECLADO AINDA NÃO MANDA 4 DIGITOS PARA A FILA. REVISAR FW!
      if Pos(#$2E, Protocol) > 0 then
        Protocol := Copy(Protocol, 1, Pos(#$2E, Protocol)) + '00' + Copy(Protocol, Pos(#$2E, Protocol) + 1, Length(Protocol) - Pos(#$2E, Protocol));

      // NO COMANDO DE LOGOUT, ADD '0000' AO FINAL DO PROT PQ TECLADO AINDA NÃO MANDA A FILA DE 'REDIRECIONA'. REVISAR FW!
      if Pos(#$5D, Protocol) > 0 then
        Insert('0000',Protocol,Length(Protocol));

      S := DecifraProtocolo(Protocol, 0, '"porta serial de teclado"');
      if S <> '' then
      begin
        // TIRA OS DOIS BYTES INICIAIS DO ADR DO TECLADO, REVISAR FW DO TECLADO!
        S := Copy(S, 4, Length(S) - 3);

        // NO COMANDO DE Situacao total de uma PA, TIRA UM BYTE DO NPSWD, REVISAR FW DO TECLADO!
        if Pos(#$5F, S) > 0 then
          S := Copy(S, 1, Pos(#$5F, S)) + Copy(S, Pos(#$5F, S) + 2, Length(S) - Pos(#$5F, S) - 1);

        EnviarComandoTeclado(S);
      end;

      Protocol := '';
    end
    else if ReceivingProtocol then
      Protocol := Protocol + AspAnsiCharToString(X);
  end; { for }
  {$ENDIF SuportaPortaCom}
end;   { proc TecladosPortRxChar }

procedure TfrmSicsMain.TecladoTcpPortRead(Sender: TObject; Socket: TCustomWinSocket);
const
  ReceivingProtocol: Boolean = false;
  Protocol: string           = '';
var
  I     : Word;
  s1, s2: string;
begin
  s1 := AspAnsiStringToString(Socket.ReceiveText);
  //ULog.TLog.GravarLogExecucao('Recebido: ' + s1);

  for I := 1 to Length(s1) do
  begin
    if s1[I] = STX then
    begin
      ReceivingProtocol := True;
      Protocol          := '';
    end
    else if s1[I] = ETX then
    begin
      try
        ReceivingProtocol := false;

        // ADD '00' PQ TECLADO AINDA NÃO MANDA 4 DIGITOS PARA A PA. REVISAR FW e TIRAR ISTO!
        Protocol := FormatarProtocolo('00' + Protocol);

        // NO COMANDO DE ENCAMINHA PARA OUTRA FILA, ADD '00' PQ TECLADO AINDA NÃO MANDA 4 DIGITOS PARA A FILA. REVISAR FW!
        if Pos(#$2E, Protocol) > 0 then
          Protocol := Copy(Protocol, 1, Pos(#$2E, Protocol)) + '00' + Copy(Protocol, Pos(#$2E, Protocol) + 1, Length(Protocol) - Pos(#$2E, Protocol));

        // NO COMANDO DE LOGOUT, ADD '0000' AO FINAL DO PROT PQ TECLADO AINDA NÃO MANDA A FILA DE 'REDIRECIONA'. REVISAR FW!
        if Pos(#$5D, Protocol) > 0 then
          Insert('0000',Protocol,Length(Protocol));

        //ULog.TLog.GravarLogExecucao('DecifraProtocolo: ' + Protocol);
        //Application.ProcessMessages;
        s2 := DecifraProtocolo(Protocol, Socket.LocalPort, Socket.RemoteAddress + '(socket de teclado TCP/IP)');

        if s2 <> '' then
        begin
          // TIRA OS DOIS BYTES INICIAIS DO ADR DO TECLADO, REVISAR FW DO TECLADO!
          s2 := STX + s2 + ETX;
          s2 := STX + Copy(s2, 4, Length(s2) - 3);

          // NO COMANDO DE Situacao total de uma PA, TIRA UM BYTE DO NPSWD, REVISAR FW DO TECLADO!
          if Pos(#$5F, s2) > 0 then
            s2 := Copy(s2, 1, Pos(#$5F, s2)) + Copy(s2, Pos(#$5F, s2) + 2, Length(s2) - Pos(#$5F, s2) - 1);

          if (Pos(#$23, s2) > 0) and (Pos(#$9, s2) > 0) then
            s2 := Copy(s2, 1, Pos(#$9, s2)-1) + ETX;

          //if (Pos(#$5C, s2) > 0) then
            //s2 := Copy(s2, 1, Pos(#$5C, s2)-1) + ETX;

          //EnviaComando(Socket, s2);

          Socket.SendText(s2);
          //ULog.TLog.GravarLogExecucao('Enviado: ' + s2);

          GetSendPAsSituationTextParaTeclado(s1);
          GetSendWaitingPswdsTextParaTeclado(s2);

          Socket.SendText(STX + '00' + Chr($3C) + s1 + ETX);
          //tst        Application.ProcessMessages;
          Socket.SendText(STX + '00' + Chr($3B) + s2 + ETX);
          //tst        Application.ProcessMessages;
          Socket.SendText(STX + '00' + Chr($78) + FormatDateTime('ddmmyyyyhhnnss', now) + ETX);
        end;
      except
        on E: Exception do
          //ULog.TLog.GravarLogExecucao('Erro Teclado : ' + E.Message + ' - Recebido: ' + s1 +' - Enviado: ' + s2);
      end;

      Protocol := '';
    end
    else if ReceivingProtocol then
      Protocol := Protocol + s1[I];
  end; { for }
end; { proc TecladoTcpPortRead }

{ --------------------------------------------------- }
{ procedures dos menus }

procedure TfrmSicsMain.MenuSairClick(Sender: TObject);
begin
  if Application.MessageBox('Deseja fechar o SICS Servidor? Todo o sistema de gerenciamento do atendimento não funcionará!', 'Confirmação', MB_ICONQUESTION or MB_YESNOCANCEL) = mrYes then
  begin
    fFecharPrograma := True;
    if GetIsService then
    begin
      TfrmSicsSplash.ShowStatus('Encerrando...');
      try
        uServico.ServiceStop;
        try
          Close;
        finally
          Halt;
        end;
      finally
        // TfrmSicsSplash.Hide;
      end;
    end
    else
    begin
      try
        Close;
      finally
        Halt; // resolver isso
      end;
    end;
  end;
end; { proc MenuSairClick }

procedure TfrmSicsMain.SubMenuPrioridadesDosBoxesClick(Sender: TObject);
var
  IdUnidade: Integer;
begin
  if TfrmSicsConfigPrioridades.ExibeForm(IdUnidade) then
    EnviaParaTodosOsClients(TGSServerSocket.Socket, '0000' + Chr($29));
end;
{ proc SubMenuPrioridadesDosBoxesClick }

procedure TfrmSicsMain.SubMenuSituacaoClick(Sender: TObject);
begin
  frmSicsSituacaoAtendimento.Show;
end; { proc SubMenuSituacaoClick }

procedure TfrmSicsMain.SubMenuIndicadoresDePerformanceClick(Sender: TObject);
begin
  frmSicsPIMonitor.Show;
end;
{ proc SubMenuIndicadoresDePerformanceClick }

procedure TfrmSicsMain.menuVisualizarPPsClick(Sender: TObject);
begin
  frmSicsProcessosParalelos.Show;
end;

function TfrmSicsMain.MinutesBetween(aNow, aThen: TDateTime): Int64;
begin
  Result := Abs(Trunc((aThen - aNow) *24 *60));
end;

procedure TfrmSicsMain.mnuExcluirTodosClick(Sender: TObject);
var
  LStringGrid: TStringGrid;
begin
  if Application.MessageBox('Excluir todas as senhas?', 'Confirmação', MB_ICONQUESTION or MB_YESNOCANCEL) = idYES then
  begin
    LStringGrid := FindComponent('SenhasList' + IntToStr(ManagePswdPopMenu.Tag)) as TStringGrid;

    if (lStringGrid.Cells[0,1] <> EmptyStr) then
    begin
      ExcluirSenhasPelaFila(ManagePswdPopMenu.Tag);
    end;
  end;
end;

{ proc subMenuProcessosParalelosClick }

procedure TfrmSicsMain.SubMenuDesabilitarBotoesDaImpressoraClick(Sender: TObject);
begin

end;
{ proc SubMenuDesabilitarBotoesDaImpressora }

procedure TfrmSicsMain.SubMenuHabilitarBotoesDaImpressoraClick(Sender: TObject);
begin

end; { proc SubMenuHabilitarBotoesDaImpressora }

procedure TfrmSicsMain.SubMenuFilasClick(Sender: TObject);
var
  IdUnidade: Integer;
begin
  TfrmSicsConfiguraTabela.ExibeForm(ctFilas, IdUnidade);
end;
{ proc SubMenuFilasClick }

procedure TfrmSicsMain.menuGruposDePaineisClick(Sender: TObject);
var
  IdUnidade: Integer;
begin
  TfrmSicsConfiguraTabela.ExibeForm(ctGruposDePaineis, IdUnidade);
end;

procedure TfrmSicsMain.MenuModuloSicsCallCenterClick(Sender: TObject);
begin
  ExibirConfigModuloCallCenter(Self, FTentativasAcessoMenuProtegido, FDataUltimaTentativasAcessoMenuProtegido);
end;

{ proc menuGruposDePaineis }

procedure TfrmSicsMain.SubMenuPaineisClick(Sender: TObject);
var
  IdUnidade: Integer;
begin
  TfrmSicsConfiguraTabela.ExibeForm(ctPaineis, IdUnidade);
end;
{ proc SubMenuPaineisClick }

procedure TfrmSicsMain.SubMenuGruposDePosicoesDeAtendimentoClick(Sender: TObject);
var
  IdUnidade: Integer;
begin
  TfrmSicsConfiguraTabela.ExibeForm(ctGruposDePAs, IdUnidade);
end; { proc SubMenuGruposDePosicoesDeAtendimentoClick }

procedure TfrmSicsMain.SubMenuPosicoesDeAtendimentoClick(Sender: TObject);
var
  IdUnidade: Integer;
begin
  TfrmSicsConfiguraTabela.ExibeForm(ctPAs, IdUnidade);
end; { proc SubMenuPosicoesDeAtendimentoClick }

procedure TfrmSicsMain.SubMenuGruposDeAtendentesClick(Sender: TObject);
var
  IdUnidade: Integer;
begin
  TfrmSicsConfiguraTabela.ExibeForm(ctGruposDeAtendentes, IdUnidade);
end; { proc SubMenuGruposDeAtendentesClick }

procedure TfrmSicsMain.SubMenuAtendentesClick(Sender: TObject);
var
  IdUnidade: Integer;
begin
  if TfrmSicsConfiguraTabela.ExibeForm(ctAtendentes, IdUnidade) then
    BroadcastListaDeAtendentes;
end; { proc SubMenuAtendentesClick }

procedure TfrmSicsMain.SubMenuEmailsClick(Sender: TObject);
var
  IdUnidade: Integer;
begin
  TfrmSicsConfiguraTabela.ExibeForm(ctEmails, IdUnidade);
end;
{ proc SubMenuEmailsClick }

procedure TfrmSicsMain.menuCelularesClick(Sender: TObject);
var
  IdUnidade: Integer;
begin
  TfrmSicsConfiguraTabela.ExibeForm(ctCelulares, IdUnidade);
end;
{ proc menuCelularesClick }

procedure TfrmSicsMain.SubMenuValidadeClick(Sender: TObject);

{$IFDEF USEKEY}

var
  S        : string;
  Terminals: Integer;

{$ENDIF}

begin

{$IFDEF USEKEY}

  S         := ReadStringFromKey(16, 2);
  Terminals := StrToInt('$' + S);
  if GetAccessUntilDate <> EncodeDate(1, 1, 1) then
    S := 'Este software é válido até ' + FormatDateTime('dd/mm/yyyy  hh:nn', GetAccessUntilDate)
  else
    S := 'Este software não expira por data.';
  if Terminals <> 0 then
    S := S + #13'Terminais permissionados: ' + IntToStr(Terminals)
  else
    S := S + #13'Terminais permissionados: ilimitado';

  AppMessageBox(S, 'Permissões', MB_ICONINFORMATION)

{$ENDIF}

end; { proc SubMenuValidadeClick }

procedure TfrmSicsMain.SubMenuSobreClick(Sender: TObject);
begin
  AppMessageBox(VERSAO
{$IFNDEF IS_MOBILE} + #13#13 + GetExeVersion
{$ENDIF IS_MOBILE}, 'SICS - Informação', MB_ICONINFORMATION);
end; { procSubMenuSobreClick }

procedure TfrmSicsMain.AtualizaTagsNoStringGrid(Senha : integer; sg : TStringGrid);
var
  i        : integer;
  SenhaRow : integer;
  lTags    : TIntArray;
  lGrupo   : String;
begin
  SenhaRow := -1;
  for i := 1 to sg.RowCount -1 do
  begin
    if sg.cells[COL_SENHA, i] = Senha.ToString then
    begin
      SenhaRow := i;
      break;
    end;
  end;

  if SenhaRow = -1 then
    Exit;

  for i := 0 to fMaxTags -1 do
    sg.Cells[COL_PRIMEIRA_TAG + i, sg.RowCount - 1] := '';

  lTags := GetTagsTicket(Senha);

  for i := Low(lTags) to High(lTags) do
  begin
    if dmSicsMain.cdsTags.Locate('ID', lTags[i], [loCaseInsensitive]) then
    begin
      lGrupo := '';

      if dmSicsMain.cdsGruposDeTags.Locate('ID', dmSicsMain.cdsTags.FieldByName('ID_GRUPOTAG').AsInteger, [loCaseInsensitive]) then
      begin
        lGrupo := dmSicsMain.cdsGruposDeTags.FieldByName('Nome').AsString + ' - ';
      end;

      if  dmSicsMain.cdsTags.FieldByName('ID_GRUPOTAG').AsInteger > 0 then
      begin
        sg.Cells[ObtemColunaDaTag(dmSicsMain.cdsTags.FieldByName('ID_GRUPOTAG').AsInteger), SenhaRow] :=
          IntToStr(dmSicsMain.cdsTags.FieldByName('ID').AsInteger) + ';' +
          IntToStr(dmSicsMain.cdsTags.FieldByName('CODIGOCOR').AsInteger) + ';' +
          lGrupo +
          dmSicsMain.cdsTags.FieldByName('NOME').AsString;
      end;
    end
    else
    begin
      if  dmSicsMain.cdsTags.FieldByName('ID_GRUPOTAG').AsInteger > 0 then
      begin
        sg.Cells[ObtemColunaDaTag(dmSicsMain.cdsTags.FieldByName('ID_GRUPOTAG').AsInteger), SenhaRow] := '';
      end;
    end;
  end;
end;

procedure TfrmSicsMain.PopularStringGridFilas(pGrid: TStringGrid; pFila: Integer);
const
  SELECT_TICKET = 'SELECT ' +
                  '  T.NUMEROTICKET, T.CREATEDAT ' +
                  'FROM ' +
                  '  TICKETS T  '+
                  'WHERE ' +
                  '  T.ID_UNIDADE = %d AND '+
                  '  T.FILA_ID = %d '+
                  'ORDER BY '+
                  '  T.ORDEM, T.ID';

var
  i,
  j     : Integer;
  lDS   : TDataSet;
begin
  dmSicsMain.connOnLine.ExecSQL(Format(SELECT_TICKET, [vgParametrosModulo.IdUnidade, pFila]), lDS);

  try
    if not lDS.IsEmpty then
    begin
      lDS.First;

      while not lDS.Eof do
      begin
        if ((pGrid.RowCount > 2) or (pGrid.Cells[COL_SENHA, 1] <> '')) then
        begin
          pGrid.RowCount := pGrid.RowCount + 1;
        end;

        for i := 0 to pGrid.ColCount - 1 do
        begin
          pGrid.Cells[I, pGrid.RowCount - 1] := '';
        end;

        pGrid.Cells[COL_SENHA   , pGrid.RowCount - 1]   := lDS.FieldByName('NUMEROTICKET').AsString;
        pGrid.Cells[COL_HORA    , pGrid.RowCount - 1]   := FormatDateTime('hh:nn:ss', lDS.FieldByName('CREATEDAT').AsDateTime);
        pGrid.Cells[COL_DATAHORA, pGrid.RowCount - 1]   := FormatDateTime('dd/mm/yyyy  hh:nn:ss', lDS.FieldByName('CREATEDAT').AsDateTime);

        //pGrid.Objects[COL_SENHA    , pGrid.RowCount - 1] := TObject(GetProntuarioPaciente(lDS.FieldByName('ID').AsInteger));

        pGrid.Cells[COL_NOME    , pGrid.RowCount - 1]   := GetNomeParaSenha(lDS.FieldByName('NUMEROTICKET').AsInteger);

        AtualizaTagsNoStringGrid(lDS.FieldByName('NUMEROTICKET').AsInteger, pGrid);

        Row := pGrid.RowCount - 1;
        Col := 0;

        lDS.Next;
      end;
    end;
  finally
    FreeAndNil(lDS);
  end;
end;

procedure TfrmSicsMain.PopUpMenuExcluirClick(Sender: TObject);
var
  lGrid    : TStringGrid;
  lSenha   : Integer;
  lDataHora: TDateTime;
begin
  if Application.MessageBox('Excluir senha selecionada?', 'Confirmação', MB_ICONQUESTION or MB_YESNOCANCEL) = idYES then
  begin
    lGrid     := FindComponent('SenhasList' + IntToStr(ManagePswdPopMenu.Tag)) as TStringGrid;

    //RA
    lSenha    := StrToInt(lGrid.Cells[COL_SENHA, lGrid.Row]);
    lDataHora := StrToDateTime(lGrid.Cells[COL_DATAHORA, lGrid.Row]);

    RetrievePswd(ManagePswdPopMenu.Tag, lSenha, lDataHora);

    //RemoveRow(FindComponent('SenhasList' + IntToStr(ManagePswdPopMenu.Tag)) as TStringGrid, (FindComponent('SenhasList' + IntToStr(ManagePswdPopMenu.Tag)) as TStringGrid).Row);
    //AtualizaSenhaCountLabel(ManagePswdPopMenu.Tag);
    //SalvaSituacao_Fila(ManagePswdPopMenu.Tag);
  end; { if Application.MessageBox }
end;   { proc PopUpMenuExcluirClick }

{ --------------------------------------------- }

procedure TfrmSicsMain.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if ((Button = mbRight) and (Shift = [ssAlt])) then
    Application.MessageBox('ASPECT Mídia'#13'aspect@aspect.com.br'#13#13'Luciano B. Chieco', 'Info - SICS', MB_ICONINFORMATION)
end; { proc FormMouseUp }

procedure TfrmSicsMain.SenhasList1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Selecteds     : TGridRect;
  ColSel, RowSel: Longint;
begin
  if ((Sender is TStringGrid) and (Button = mbRight)) then
  begin
    with (Sender as TStringGrid) do
    begin
      MouseToCell(X, Y, ColSel, RowSel);
      if RowSel <> 0 then
      begin
        Selecteds.Top         := RowSel;
        Selecteds.Bottom      := RowSel;
        Selecteds.Left        := 0;
        Selecteds.Right       := ColCount - 1;
        Selection             := Selecteds;
        ManagePswdPopMenu.Tag := (Sender as TStringGrid).Tag;
        ManagePswdPopMenu.PopUp(ClientOrigin.X + X, ClientOrigin.Y + Y);
      end;
      { if RowSel <> 0 }
    end; { with }
  end;   { if Sender is TStringGrid }
end;     { proc SenhasListMouseUp }

procedure TfrmSicsMain.menuDefinicoesDeIndicadoresClick(Sender: TObject);
var
  IdUnidade: Integer;
begin
  TfrmSicsCadPIS.ExibeForm(IdUnidade);
end;

procedure TfrmSicsMain.menuDefinicoesDeHorariosClick(Sender: TObject);
var
  IdUnidade: Integer;
begin
  TfrmSicsCadHor.ExibeForm(IdUnidade);
end;

procedure TfrmSicsMain.SubMenuResetarPaineisClick(Sender: TObject);
var
  S : string;
  BM: TBookmark;
begin
  S := #0#0#0#0#0#0#0#0#0#0#1'Z00'#2'E$'#4;
  with dmSicsMain.cdsPaineis do
  begin
    BM := GetBookmark;
    try
      try
      First;
      while not Eof do
      begin
        if (TModeloPainel(FieldByName('ID_MODELOPAINEL').AsInteger) in [mpBetaBrite, mpBetaSics_LadoEsquerdo, mpBetaSics_LadoDireito, mp220, mp4080, mp2411, mp4120]) then
          WriteToDisplay(FieldByName('ID').AsInteger, S);
        Next;
      end;
      finally
        if BookmarkValid(BM) then
          GotoBookmark(BM);
      end;
    finally
      FreeBookmark(BM);
    end;
  end;
  // with cds

  Application.MessageBox('Painéis resetados.', 'Informação', MB_ICONINFORMATION);
end;

procedure TfrmSicsMain.SubMenuInicializarPaineisClick(Sender: TObject);
var
  s1, s2: string;
  BM    : TBookmark;
begin
  s1 := 'T1;2000'#9'V1-75;31'#9;

  with dmSicsMain.cdsPaineis do
  begin
    BM := GetBookmark;
    try
      try
      First;
      while not Eof do
      begin
        if (TModeloPainel(FieldByName('ID_MODELOPAINEL').AsInteger) in [mpBetaBrite, mpBetaSics_LadoEsquerdo, mpBetaSics_LadoDireito, mp220, mp4080, mp2411, mp4120]) then
        begin
          ASPEzPorConfiguraPainel(s1, s2, FieldByName('ENDERECOSERIAL').AsString, false, false);
          WriteToDisplay(FieldByName('ID').AsInteger, s2);
        end;
        Next;
      end;
      finally
        if BookmarkValid(BM) then
          GotoBookmark(BM);
      end;
    finally
      FreeBookmark(BM);
    end;
  end; // with cds

  Application.MessageBox('Painéis inicializados.', 'Informação', MB_ICONINFORMATION);
end;

procedure TfrmSicsMain.SubMenuAjustarHorarioDosPaineisClick(Sender: TObject);
var
  S : string;
  BM: TBookmark;
begin
  S := #0#0#0#0#0#0#0#0#0#0#1'Z00'#2'E ' + FormatDateTime('hhnn', now) + #4;
  with dmSicsMain.cdsPaineis do
  begin
    BM := GetBookmark;
    try
      try
      First;
      while not Eof do
      begin
        if (TModeloPainel(FieldByName('ID_MODELOPAINEL').AsInteger) in [mpBetaBrite, mpBetaSics_LadoEsquerdo, mpBetaSics_LadoDireito, mp220, mp4080, mp2411, mp4120]) then
          WriteToDisplay(FieldByName('ID').AsInteger, S);
        Next;
      end;

      Delay(300);

      S := #0#0#0#0#0#0#0#0#0#0#1'Z00'#2'E' + Chr(39) + 'M'#4;

      First;
      while not Eof do
      begin
        if (TModeloPainel(FieldByName('ID_MODELOPAINEL').AsInteger) in [mpBetaBrite, mpBetaSics_LadoEsquerdo, mpBetaSics_LadoDireito, mp220, mp4080, mp2411, mp4120]) then
          WriteToDisplay(FieldByName('ID').AsInteger, S);
        Next;
      end;
      finally
        if BookmarkValid(BM) then
          GotoBookmark(BM);
      end;
    finally
      FreeBookmark(BM);
    end;
  end; // with cds

  Application.MessageBox('Horários dos painéis configurados.', 'Informação', MB_ICONINFORMATION);
end; { proc SubMenuAjustarHorarioDosPaineisClick }

procedure TfrmSicsMain.SubMenuApagarPaineisClick(Sender: TObject);
var
  S : string;
  BM: TBookmark;
begin
  S := '!00C$';

  with dmSicsMain.cdsPaineis do
  begin
    BM := GetBookmark;
    try
      try
      First;
      while not Eof do
      begin
        if not(TModeloPainel(FieldByName('ID_MODELOPAINEL').AsInteger) in [mpBetaBrite, mpBetaSics_LadoEsquerdo, mpBetaSics_LadoDireito, mp220, mp4080, mp2411, mp4120]) then
          WriteToDisplay(FieldByName('ID').AsInteger, S);
        Next;
      end;
      finally
        if BookmarkValid(BM) then
          GotoBookmark(BM);
      end;
    finally
      FreeBookmark(BM);
    end;
  end;
  // with cds

  Application.MessageBox('Painéis numéricos apagados.', 'Informação', MB_ICONINFORMATION);
end;

procedure TfrmSicsMain.SubMenuTestarComunicacaoClick(Sender: TObject);
var
  s1, s2: string;
begin
  s1 := '00';
  s2 := '88888';
  if InputQuery('Endereço dos painéis para teste de transmissão', 'Digite o endereço dos painéis a serem testados:', s1) and InputQuery('Texto para teste de transmissão', 'Digite o texto a ser enviado aos painéis:', s2) then
  begin
    with dmSicsMain.cdsPaineis do
    begin
      First;
      while not Eof do
      begin
        if not(TModeloPainel(FieldByName('ID_MODELOPAINEL').AsInteger) in [mpBetaBrite, mpBetaSics_LadoEsquerdo, mpBetaSics_LadoDireito, mp220, mp4080, mp4120]) then
          WriteToDisplay(FieldByName('ID').AsInteger, '!' + s1 + 'F01' + s2 + '$');
        Next;
      end;
    end;

    Application.MessageBox('Painéis numéricos testados.', 'Informação', MB_ICONINFORMATION);
  end;
end;

procedure TfrmSicsMain.SubMenuClientesClick(Sender: TObject);
var
  IdUnidade: Integer;
begin
  if TfrmSicsConfiguraTabela.ExibeForm(ctClientes, IdUnidade) then
    BroadcastListaDeAtendentes;
end; { proc SubMenuAtendentesClick }

procedure TfrmSicsMain.SubMenuConfiguracoesDeEnvioDeEmailClick(Sender: TObject);
begin
  {$IFDEF SuportaEmail}
  AspConfiguraEmail;
  {$ENDIF SuportaEmail}
end; { proc SubMenuConfiguracoesDeEnvioDeEmail }

procedure TfrmSicsMain.SubMenuTestarEnvioDeEmailClick(Sender: TObject);
var
  S: string;
begin
  S := 'suporte_sw@aspect.com.br';
  {$IFDEF SuportaEmail}
  if InputQuery('Teste de envio de e-mail', 'Digite e-mail do destinatário:', S) then
  begin
    if AspEnviaEmail(S, '*** SICS - Teste de envio de e-mail ***', '*********************************************************************'#13#10 + '*  Unidade: ' + FormatLeftString(54, vgParametrosModulo.NomeUnidade) + '  *'#13#10 + '*  Horário: ' + FormatLeftString(54, FormatDateTime('dd/mm/yyyy hh:nn:ss', now)) +
      '  *'#13#10 + '*  Status:  ' + FormatLeftString(54, 'Teste de sistema para envio de e-mail.') + '  *'#13#10 + '*********************************************************************') then
      AppMessageBox('Um e-mail foi enviado para o endereço "' + S + '". Por favor cheque esta caixa postal dentro de instantes para confirmar o seu recebimento.', 'Informação', MB_ICONINFORMATION)
    else
      AppMessageBox('Falha ao enviar e-mail. Por favor cheque as configurações de SMTP deste software. Para maiores informações, consulte o arquivo "ErrorLog.dat", criado na mesma pasta deste software.', 'Erro', MB_ICONSTOP);
  end;
  {$ENDIF SuportaEmail}
end;

procedure TfrmSicsMain.SubMenuConfiguracoesDeEnvioDeSmsClick(Sender: TObject);
begin
  {$IFDEF SuportaSMS}
  AspConfiguraSms;
  {$ENDIF SuportaSMS}
end; { proc SubMenuConfiguracoesDeEnvioDeSmsClick }

procedure TfrmSicsMain.SubMenuTestarEnvioDeSmsClick(Sender: TObject);
{$IFDEF SuportaSMS}
var
  S: string;
{$ENDIF SuportaSMS}
begin
  {$IFDEF SuportaSMS}
  S := '55xx99999999';
  if InputQuery('Teste de envio de SMS', 'Digite SMS do destinatário:', S) then
  begin
    if AspEnviaSMS(S, '*** SICS - Teste de envio de SMS ***') then
      AppMessageBox('Um SMS foi enviado para o número "' + S + '". Por favor cheque esta caixa postal dentro de instantes para confirmar o seu recebimento.', 'Informação', MB_ICONINFORMATION)
    else
      AppMessageBox('Falha ao enviar SMS. Por favor cheque as configurações de SMS e a correta digitação do número do destinatário. Para maiores informações, consulte o arquivo "ErrorLog.dat", criado na mesma pasta deste software.', 'Erro', MB_ICONSTOP);
  end;
  {$ENDIF SuportaSMS}
end; { proc SubMenuTestarEnvioDeSmsClick }

procedure TfrmSicsMain.SubMenuStatusDosTotensClick(Sender: TObject);
var
  S: string;
  I: Integer;
begin
  S := '';

  for I := 1 to cgMaxTotens do
  begin
    if vlTotens[I].IP <> '' then
    begin
      S := S + '#' + IntToStr(I) + ' - ' + String(vlTotens[I].IP) + ': ';

      if stSemConexao in vlTotens[I].StatusTotem then
        S := S + 'SEM CONEXÃO'
      else
        S := S + 'CONECTADO';
      if stOffLine in vlTotens[I].StatusTotem then
        S := S + ', IMPRESSORA OFFLINE';
      if stPoucoPapel in vlTotens[I].StatusTotem then
        S := S + ', POUCO PAPEL';
      if stSemPapel in vlTotens[I].StatusTotem then
        S := S + ', SEM PAPEL';

      S := S + #13#13;
    end;
  end;

  AppMessageBox(S, 'Status do Totem', MB_ICONINFORMATION);
end;

procedure TfrmSicsMain.ServerSocket1ClientConnect(Sender: TObject; Socket: TCustomWinSocket);
{$IFDEF USEKEY}
var
  S        : string;
  Terminals: Integer;
{$ENDIF}
begin
{$IFDEF USEKEY}
  try
    S         := ReadStringFromKey(16, 2);
    Terminals := StrToInt('$' + S);
    if ((Terminals > 0) and ((ServerSocket1.Socket.ActiveConnections + TGSServerSocket.Socket.ActiveConnections) > Terminals)) then
      Socket.Close;
  except
    Socket.Close;
  end;
{$ENDIF}
end;

procedure TfrmSicsMain.ServerSocket1ClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  case ErrorCode of
    10053, 10065:
      ErrorCode := 0;
  else
    begin
      if Sender is TServerSocket then
      begin
        if ((Sender = ServerSocket1) or (Sender = TGSServerSocket)) then
          MyLogException(ESocketError.Create('Erro ' + IntToStr(ErrorCode) + ' no socket principal (' + (Sender as TServerSocket).Name + '). Reiniciando socket...'))
        else if Sender = ServerSocketRetrocompatibilidade then
          MyLogException(ESocketError.Create('Erro ' + IntToStr(ErrorCode) + ' no socket de retrocompatibilidade (' + (Sender as TServerSocket).Name + '). Reiniciando socket...'));

        (Sender as TServerSocket).Close;
        Delay(3500);
        (Sender as TServerSocket).Open;
      end;
    end;
  end;
end;

procedure TfrmSicsMain.Backups1Click(Sender: TObject);
begin
  frmSicsBackup.ConfiguraBackup;
end;

procedure TfrmSicsMain.menuAlarmesClick(Sender: TObject);
var
  IdUnidade: Integer;
begin
  TfrmSicsCadAlarmes.ExibeForm(IdUnidade);
end;

procedure TfrmSicsMain.FormShow(Sender: TObject);
begin
  LoadPosition(frmSicsMain);

  FormResize(frmSicsMain);
  OnResize := FormResize;
end;

procedure TfrmSicsMain.menuConfigurarEnderecosSeriaisClick(Sender: TObject);
var
  IniFile: TIniFile;
  I      : Integer;
  S, s2  : string;
begin
  IniFile := TIniFile.Create(GetIniFileName);
  try
    for I := 1 to vlNumeroDePainelClientSockets do
      if FindComponent('PainelClientSocket' + IntToStr(I)) <> nil then
        with (FindComponent('PainelClientSocket' + IntToStr(I)) as TClientSocket) do
          if Active then
          begin
            s2 := IniFile.ReadString('PaineisAlfanumericosEnderecosSeriais', Socket.RemoteAddress, '');
            if s2 = '' then
              IniFile.WriteString('PaineisAlfanumericosEnderecosSeriais', Socket.RemoteAddress, '')
            else
            begin
              EnviaComando(Socket, #0#0#0#0#0#0#0#0#0#0#1'Z00'#2 + 'E7' + s2 + #4);
              S := S + Socket.RemoteAddress + '  =>  ' + s2 + #13;
            end;
          end;
  finally
    IniFile.Free;
  end; { try .. finally }

  if S = '' then
    Application.MessageBox('Nenhum endereço serial de painel alfanumérico foi configurado', 'Configuração de endereços seriais', MB_ICONINFORMATION)
  else
    AppMessageBox(S, 'Configuração de endereços seriais', MB_ICONINFORMATION);
end; { proc menuConfigurarEnderecosSeriaisClick }

procedure TfrmSicsMain.menuTrayRestaurarClick(Sender: TObject);
begin
  RestauraOuEscondeAplicacaoNaBandeja(true);
end;

function TfrmSicsMain.GetNome_NumeroFicha(ASenha:Integer): String;
var
  LJSONObj  : TJSONObject;
  LTicket   : Integer;
  LNome     : String;
  LNumFicha : String;
begin
  Result    := EmptyStr;

  LTicket  := GetIdTicketIfPwdExists(ASenha);
  LJSONObj := dmSicsMain.GetDadosAdicionais(LTicket);
  try
    if Assigned(LJSONObj) then
    begin
      LJSONObj.TryGetValue('NOME' , LNome);
      LJSONObj.TryGetValue('NUMERODAFICHA' , LNumFicha);
      Result := LNome + ';' + LNumFicha
    end;
  finally
    if Assigned(LJSONObj) then
      LJSONObj.Free;
  end;
end;


procedure TfrmSicsMain.Debug1Click(Sender: TObject);
begin
  TfrmDebugParameters.ShowForm;
end;

procedure TfrmSicsMain.cdsIdsTicketsAfterPost(DataSet: TDataSet);
begin
  SalvaSituacao_Tickets;
end;

procedure TfrmSicsMain.cdsIdsTicketsTagsAfterInsert(DataSet: TDataSet);
begin
  cdsIdsTicketsTagsId.AsInteger := TGenerator.NGetNextGenerator('GEN_ID_TICKETS_TAGS', dmSicsMain.connOnLine);
end;

procedure TfrmSicsMain.cdsContadoresDeFilasAfterPost(DataSet: TDataSet);
begin
  SalvaSituacao_Counters;
end;

procedure TfrmSicsMain.CriarItemsFormConexoes;

  function GetNodeByText(ATree: TTreeView; AValue: String; AVisible: Boolean): TTreeNode;
  var
    Node: TTreeNode;
  begin
    Result := nil;
    if ATree.Items.Count = 0 then
      Exit;
    Node := ATree.Items[0];
    while Node <> nil do
    begin
      if UpperCase(Node.Text) = UpperCase(AValue) then
      begin
        Result := Node;
        if AVisible then
          Result.MakeVisible;
        break;
      end;
      Node := Node.GetNext;
    end;
  end;

const
  NODE_TEXT_PAS_MULTIPAS = 'PAs e MultiPAs';
  NODE_TEXT_ONLINE_TGS   = 'OnLines e TGSs';
  NODE_TEXT_PAINEIS      = 'Painéis';
  NODE_TEXT_TOTENS       = 'Tótens';
  NODE_TEXT_TECLADOS     = 'Teclados';

var
  I, iActiveCount, iInactiveCount: Integer;
  LStatusTV: String;
begin
  frmSicsConexoes.tvConexoes.Items.Clear;

  with frmSicsConexoes do
  begin
    NodePasMultiPas := tvConexoes.Items.AddChild(nil, NODE_TEXT_PAS_MULTIPAS);
    NodeOnLineTGS   := tvConexoes.Items.AddChild(nil, NODE_TEXT_ONLINE_TGS);
    NodePaineis     := tvConexoes.Items.AddChild(nil, NODE_TEXT_PAINEIS);
    NodeTotens      := tvConexoes.Items.AddChild(nil, NODE_TEXT_TOTENS);
    NodeTeclados    := tvConexoes.Items.AddChild(nil, NODE_TEXT_TECLADOS);

    NodePasMultiPas.ImageIndex    := IMG_CONEXAO;
    NodePasMultiPas.SelectedIndex := IMG_CONEXAO;

    NodeOnLineTGS.ImageIndex    := IMG_CONEXAO;
    NodeOnLineTGS.SelectedIndex := IMG_CONEXAO;

    NodePaineis.ImageIndex    := IMG_CONEXAO;
    NodePaineis.SelectedIndex := IMG_CONEXAO;

    NodeTotens.ImageIndex    := IMG_CONEXAO;
    NodeTotens.SelectedIndex := IMG_CONEXAO;

    NodeTeclados.ImageIndex    := IMG_CONEXAO;
    NodeTeclados.SelectedIndex := IMG_CONEXAO;
  end;

  for I := 0 to ServerSocket1.Socket.ActiveConnections - 1 do
    with frmSicsConexoes.tvConexoes.Items.AddChild(frmSicsConexoes.NodePasMultiPas, ServerSocket1.Socket.Connections[I].RemoteAddress) do
    begin
      ImageIndex    := IMG_OK;
      SelectedIndex := IMG_OK;
      MakeVisible;
    end;

  frmSicsConexoes.NodePasMultiPas.Text := NODE_TEXT_PAS_MULTIPAS + ' (' + IntToStr(frmSicsConexoes.NodePasMultiPas.Count) + ')';

  for I := 0 to TGSServerSocket.Socket.ActiveConnections - 1 do
    with frmSicsConexoes.tvConexoes.Items.AddChild(frmSicsConexoes.NodeOnLineTGS, TGSServerSocket.Socket.Connections[I].RemoteAddress) do
    begin
      ImageIndex    := IMG_OK;
      SelectedIndex := IMG_OK;
      MakeVisible;
    end;

  frmSicsConexoes.NodeOnLineTGS.Text := NODE_TEXT_ONLINE_TGS + ' (' + IntToStr(frmSicsConexoes.NodeOnLineTGS.Count) + ')';

  iActiveCount   := 0;
  iInactiveCount := 0;
  for I          := 1 to vlNumeroDePainelClientSockets do
    if FindComponent('PainelClientSocket' + IntToStr(I)) <> nil then
    begin
      with FindComponent('PainelClientSocket' + IntToStr(I)) as TClientSocket do
      begin
        LStatusTV := BuscaStatusTV(Host);
        with frmSicsConexoes.tvConexoes.Items.AddChild(frmSicsConexoes.NodePaineis, Host +' '+ LStatusTV) do
        begin
          if Active then
          begin
            ImageIndex    := IMG_OK;
            SelectedIndex := IMG_OK;
            Inc(iActiveCount);
          end
          else
          begin
            ImageIndex    := IMG_NOTOK;
            SelectedIndex := IMG_NOTOK;
            Inc(iInactiveCount);
          end;

          MakeVisible;
        end;
      end;
    end;

  frmSicsConexoes.NodePaineis.Text := NODE_TEXT_PAINEIS + ' (ON: ' + IntToStr(iActiveCount) + ' - OFF: ' + IntToStr(iInactiveCount) + ')';

  iActiveCount   := 0;
  iInactiveCount := 0;
  for I          := 1 to vlNumeroDePrinterClientSockets do
    if FindComponent('PrinterClientSocket' + IntToStr(IdsTotens[I])) <> nil then
      with FindComponent('PrinterClientSocket' + IntToStr(IdsTotens[I])) as TClientSocket do
        with frmSicsConexoes.tvConexoes.Items.AddChild(frmSicsConexoes.NodeTotens, Host) do
        begin
          if Active then
          begin
            ImageIndex    := IMG_OK;
            SelectedIndex := IMG_OK;
            Inc(iActiveCount);
          end
          else
          begin
            ImageIndex    := IMG_NOTOK;
            SelectedIndex := IMG_NOTOK;
            Inc(iInactiveCount);
          end;

          MakeVisible;
        end;

  frmSicsConexoes.NodeTotens.Text := NODE_TEXT_TOTENS + ' (ON: ' + IntToStr(iActiveCount) + ' - OFF: ' + IntToStr(iInactiveCount) + ')';

  iActiveCount   := 0;
  iInactiveCount := 0;

  for I          := 1 to vlNumeroDeTecladoClientSockets do
    if FindComponent('TecladoClientSocket' + IntToStr(I)) <> nil then
      with FindComponent('TecladoClientSocket' + IntToStr(I)) as TClientSocket do
        with frmSicsConexoes.tvConexoes.Items.AddChild(frmSicsConexoes.NodeTeclados, Host) do
        begin
          if Active then
          begin
            ImageIndex    := IMG_OK;
            SelectedIndex := IMG_OK;
            Inc(iActiveCount);
          end
          else
          begin
            ImageIndex    := IMG_NOTOK;
            SelectedIndex := IMG_NOTOK;
            Inc(iInactiveCount);
          end;

          MakeVisible;
        end;

  frmSicsConexoes.NodeTeclados.Text := NODE_TEXT_TECLADOS + ' (ON: ' + IntToStr(iActiveCount) + ' - OFF: ' + IntToStr(iInactiveCount) + ')';
end;

procedure TfrmSicsMain.SubMenuStatusDasConexoesTcpIpClick(Sender: TObject);
begin
  if not Assigned(frmSicsConexoes) then
    frmSicsConexoes := TfrmSicsConexoes.Create(Application);
  CriarItemsFormConexoes;
  frmSicsConexoes.Show;
end;
{ proc SubMenuStatusDasConexoesTcpIpClick }

procedure TfrmSicsMain.SubMenuGruposTagsClick(Sender: TObject);
var
  IdUnidade: Integer;
begin
  TfrmSicsConfiguraTabela.ExibeForm(ctGruposTags, IdUnidade);
end;

procedure TfrmSicsMain.SubMenuGruposPPsClick(Sender: TObject);
var
  IdUnidade: Integer;
begin
  TfrmSicsConfiguraTabela.ExibeForm(ctGruposDePPs, IdUnidade);
end;

procedure TfrmSicsMain.SubMenuGruposMotivosPausaClick(Sender: TObject);
var
  IdUnidade: Integer;
begin
  TfrmSicsConfiguraTabela.ExibeForm(ctGruposDeMotivosPausa, IdUnidade);
end;

procedure TfrmSicsMain.menuTagsClick(Sender: TObject);
var
  IdUnidade: Integer;
begin
  TfrmSicsConfiguraTabela.ExibeForm(ctTags, IdUnidade);
end;

procedure TfrmSicsMain.menuConfigurarPPsClick(Sender: TObject);
var
  IdUnidade: Integer;
begin
  TfrmSicsConfiguraTabela.ExibeForm(ctPPs, IdUnidade);
end;

procedure TfrmSicsMain.menuMotivosDePausaClick(Sender: TObject);
var
  IdUnidade: Integer;
begin
  TfrmSicsConfiguraTabela.ExibeForm(ctMotivosPausa, IdUnidade);
end;

procedure TfrmSicsMain.menuTotensClick(Sender: TObject);
begin
  TfrmSicsCadTotens.ExibeForm;
end;

procedure TfrmSicsMain.SaveTags;
begin
  //cdsIdsTicketsTags.SaveToFile(vgParametrosModulo.PathRT + 'TAGS.DAT');
end;

procedure TfrmSicsMain.SaveAgendamentosFilas;
begin
  //cdsIdsTicketsAgendamentosFilas.SaveToFile(vgParametrosModulo.PathRT + 'AGENDAMENTOS_FILAS.DAT');
end;

function TfrmSicsMain.GetTagsTicket(Ticket: Integer): TIntArray;
var
  sOldIndexFieldNames: string;
begin
  SetLength(Result, 0);
  //if cdsIdsTickets.Locate('NUMEROTICKET', Ticket, []) then
  if BuscarMaxIDSenha(Ticket) then
  begin
    with cdsIdsTicketsTags do
    begin
      Filter   := 'TICKET_ID=' + cdsIdsTickets.FieldByName('ID').AsString;
      Filtered := True;
      try
        sOldIndexFieldNames := IndexFieldNames;
        IndexFieldNames     := 'TAG_ID';
        First;
        try
          while not Eof do
          begin
            SetLength(Result, Length(Result) + 1);
            Result[High(Result)] := FieldByName('TAG_ID').AsInteger;
            Next;
          end;
        finally
          IndexFieldNames := sOldIndexFieldNames;
        end;
      finally
        Filtered := false;
      end;
    end;
  end;
end;

procedure TfrmSicsMain.GetFilaProximaSenha(out IdFila: Integer; out NomeFila: string; out DataHora: string);
begin
  IdFila := ChamarDaFila;
  DataHora := hora;

  if dmSicsMain.cdsFilas.Locate('ID', ChamarDaFila, []) then
    NomeFila := dmSicsMain.cdsFilas.FieldByName('NOME').AsString;
end;

function TfrmSicsMain.GetTempoEsperaUltimosN: String;
var
  LIDFila:   Integer;
  LNomeFila: String;
  LTempo: TDateTime;
begin
  SysUtils.FormatSettings.ShortDateFormat := 'dd/mm/yyyy';
  SysUtils.FormatSettings.LongTimeFormat  := 'hh:nn:ss';

  dmSicsMain.cdsFilasClone.CloneCursor(dmSicsMain.cdsFilas, false, True);
  dmSicsMain.cdsFilasClone.First;

  while not dmSicsMain.cdsFilasClone.Eof do
  begin

    if dmSicsMain.cdsFilasClone.FieldByName('Ativo').AsBoolean then
    begin
      LIDFila   := dmSicsMain.cdsFilasClone.FieldByName('ID').AsInteger;
      LNomeFila := dmSicsMain.cdsFilasClone.FieldByName('Nome').AsString;

      LTempo := GetTempoEsperaUltimosN(LIDFila);

    Result := Result + TAspEncode.AspIntToHex(LIDFila, 4) + LNomeFila + '|' + FormatDateTime('hh:nn:ss',LTempo) + TAB;
    end;

    dmSicsMain.cdsFilasClone.Next;
  end;
end;

function TfrmSicsMain.GetTMAFilas: String;
var
  LIDFila:  Integer;
  LTMAFila: TDateTime;
  LNomeFila: String;
begin
  dmSicsMain.cdsFilasClone.CloneCursor(dmSicsMain.cdsFilas, false, True);
  dmSicsMain.cdsFilasClone.First;

  while not dmSicsMain.cdsFilasClone.Eof do
  begin
    LTMAFila := 0;
    if dmSicsMain.cdsFilasClone.FieldByName('Ativo').AsBoolean then
    begin
      LIDFila    := dmSicsMain.cdsFilasClone.FieldByName('ID').AsInteger;
      LNomeFila  := dmSicsMain.cdsFilasClone.FieldByName('Nome').AsString;

      try
        if strtodatetime((frmSicsMain.FindComponent('AtendimentoUltimos10' +  inttostr(LIDFila)) as TLabel).Caption) > LTMAFila then
          LTMAFila := strtodatetime((frmSicsMain.FindComponent('AtendimentoUltimos10' + inttostr(LIDFila)) as TLabel).Caption);
      except
        on E : Exception do
        begin
          MyLogException(Exception.Create('Erro ao calcular TMAFila: ' + E.Message + ' // Fila: ' + LNomeFila + '  //  ' +
            (frmSicsMain.FindComponent('AtendimentoUltimos10' + inttostr(LIDFila)) as TLabel).Caption));
        end;
      end;
      Result := Result + TAspEncode.AspIntToHex(LIDFila, 4) + LNomeFila + '|' + FormatDateTime('hh:nn:ss',LTMAFila) + TAB;
    end;
    dmSicsMain.cdsFilasClone.Next;
  end;
end;

function TfrmSicsMain.GetTempoEsperaUltimosN(Fila: integer): TDateTime;
begin
  try
    SysUtils.FormatSettings.ShortDateFormat := 'dd/mm/yyyy';
    SysUtils.FormatSettings.LongTimeFormat  := 'hh:nn:ss';
    Result := strtodatetime((FindComponent('EsperaUltimosN' + IntToStr(fila)) as TLabel).Caption);
  except on E: Exception do
    Result := EncodeTime(23, 59, 59, 999);
  end;
end;

function TfrmSicsMain.GetNewCDSFilter(const aDatasetOrigem: TClientDataSet): TClientDataSet;
begin
  Result := TClientDataSet.Create(nil);
  try
    Result.CloneCursor(aDatasetOrigem, True);
  except
    FreeAndNil(Result);
    raise;
  end;
end;

procedure TfrmSicsMain.FiltraDataSetComPermitidas (AConexao: TFDConnection; const aDataSet: TClientDataSet; const AIdModulo: Integer;
  const aNomeCampo: TTipoDeGrupo; aColunaFiltrarCDS: String = 'ID'; const aGetNomeColunaPorModulo: TGetNomeColunaPorModulo = nil);
var
  vRangeIDs       : TIntArray;
  vRangePermitido : string;
  vTipoModulo     : TModuloSics;
  vNomeTabela     : string;
  vNomeColuna     : string;
begin
  TfrmDebugParameters.Debugar (tbAtividadeConexaoBD, 'Entrou FiltraDataSetComPermitidas. Dataset: ' + aDataSet.Name +
                                                                                       ' Módulo: ' + IntToStr(AIdModulo));

  vRangePermitido := EmptyStr;
  try
    try
      vTipoModulo := GetModuleTypeByID(AConexao, AIdModulo);

      if (vTipoModulo = msNone) then
        Exit;

      vNomeTabela := GetNomeTabelaDoModulo(vTipoModulo);
      vNomeColuna := GetNomeColunaTipoGrupoPorModulo(vTipoModulo, aNomeCampo);

      if (vNomeTabela = EmptyStr) or (vNomeColuna = EmptyStr) then
        Exit;

      if Assigned(aGetNomeColunaPorModulo) then
        aColunaFiltrarCDS := aGetNomeColunaPorModulo(vTipoModulo);

      if (aColunaFiltrarCDS = '') then
        Exit;

      if((aNomeCampo = tgPA) or (aNomeCampo = tgNomesPAs))then
      begin
        if(vTipoModulo = msPA)then
          vNomeTabela := '(SELECT '+
                         '   ID_UNIDADE, ' +
                         '   ID, '+
                         '   (CASE WHEN MODO_TERMINAL_SERVER = '+QuotedStr('T')+' THEN PAS_PERMITIDAS ELSE ID_PA END) PAS_PERMITIDAS ' +
                         ' FROM ' +
                         '   MODULOS_PAS' +
                         ' WHERE '+
                         '   ID_UNIDADE = ' + vgParametrosModulo.IdUnidade.ToString + ')';

        if((aNomeCampo = tgNomesPAs) or ((aNomeCampo = tgPA) and ((vTipoModulo = msTGS) or (vTipoModulo = msOnLine))))then
          vRangeIDs := GetListaIDPermitidosDoGrupo(AConexao, vNomeTabela, vNomeColuna, AIdModulo)
        else
          vRangeIDs := GetListaIDPermitidosDoGrupoPA(AConexao, vNomeTabela, vNomeColuna, AIdModulo)
      end
      else
        vRangeIDs := GetListaIDPermitidosDoGrupo(AConexao, vNomeTabela, vNomeColuna, AIdModulo);
      try
        vRangePermitido := GetFilterPorRangerID(vRangeIDs, aColunaFiltrarCDS);
      finally
        Finalize(vRangeIDs);
      end;
    except
      on E: Exception do
        MyLogException(E, True);
    end;
  finally
    aDataSet.Filtered := False;
    aDataSet.Filter   := vRangePermitido;
    aDataSet.Filtered := vRangePermitido <> '';
  end;
end;

function TfrmSicsMain.GetNomeFilas(const IdModulo: Integer): String;
var
  IdFila            : Integer;
  Cor               : Integer;
  Nome              : String;
  BM                : TBookmark;
  I                 : Integer;
  LTipoModulo       : TModuloSics;
  LQtdSenhas        : Integer;
  LSenhasCountLabel : TComponent;
begin
  dmSicsMain.cdsFiltroFilas.CloneCursor(dmSicsMain.cdsFilas, false, True);

  LTipoModulo  := GetModuleTypeByID(dmSicsMain.connOnLine, IdModulo);

  if LTipoModulo <> msCallCenter then
    FiltraDataSetComPermitidas(dmSicsMain.connOnLine, dmSicsMain.cdsFiltroFilas, IdModulo, tgFila);

  // with dmSicsMain.cdsFilas do
  with dmSicsMain.cdsFiltroFilas do
  begin
    BM := GetBookmark;
    I  := 0;
    Result := EmptyStr;
    try
      try
        First;
        while not Eof do
        begin
          if FieldByName('Ativo').AsBoolean then
          begin
            I         := I + 1;
            IdFila    := FieldByName('ID').AsInteger;
            Cor       := FieldByName('CODIGOCOR').AsInteger;
            Nome      := FieldByName('NOME').AsString;

            LQtdSenhas := 0;
            try
              LSenhasCountLabel := frmSicsMain.FindComponent('SenhasCountLabel' + IntToStr(IdFila));
              if (LSenhasCountLabel <> nil) then
                LQtdSenhas := StrToInt((LSenhasCountLabel as TLabel).Caption);
            except
              LQtdSenhas := 0;
            end;

            Result := Result + TAspEncode.AspIntToHex(IdFila, 4) + TAspEncode.AspIntToHex(Cor, 6) + TAspEncode.AspIntToHex(LQtdSenhas, 4) + Nome + TAB;
          end;
          Next;
        end;

        Result := TAspEncode.AspIntToHex(I, 4) + Result;
      finally
        if BookmarkValid(BM) then
          GotoBookmark(BM);
      end;
    finally
      FreeBookmark(BM);
    end;
  end; { with cds }
end;

function TfrmSicsMain.GetNomeParaSenha(Ticket: Integer): string;
begin
  Result := '';
  //if cdsIdsTickets.Locate('NUMEROTICKET', Ticket, []) then
  if BuscarMaxIDSenha(Ticket) then
    Result := cdsIdsTickets.FieldByName('NomeCliente').AsString;
end;


procedure TfrmSicsMain.InsereAgendamentoFila(IdTicket, IdFila : integer; DataHora : TDateTime);
begin
  if (IdTicket <= 0) or (IdFila <= 0) or (DataHora <= 0) then
    Exit;

  with cdsIdsTicketsAgendamentosFilas do
  begin
    Append;
    FieldByName('Id'       ).AsInteger  := TGenerator.NGetNextGenerator('GEN_ID_AGENDAMENTOS_FILAS', dmSicsMain.connOnLine);
    FieldByName('Id_Ticket').AsInteger  := IdTicket;
    FieldByName('Id_Fila'  ).AsInteger  := IdFila  ;
    FieldByName('DATAHORA' ).AsDateTime := DataHora;
    Post;

    ApplyUpdates(0);
  end;
end;


procedure TfrmSicsMain.CarregarConexoes(var S: string);

  procedure Carregar(Tipo: Integer; Node: TTreeNode);
  var
    I, J       : Integer;
    IP         : string;
    ArrayDeIPs : TConexaoIPArray;
    Achou      : boolean;
  begin
    if Node.Count > 0 then
    begin
      for I := 0 to Pred(Node.Count) do
      begin
        S  := S + IntToStr(Tipo) + IntToStr(Node[I].ImageIndex) + Node[I].Text;
        IP := Node[I].Text;

        if (Tipo = 2) then
        begin
          if Node[I].ImageIndex = 0 then
            S := S + ';' + 'SEM CONEXÃO' + ';'
          else
            S := S + ';' + 'CONECTADO' + ';';
        end;

        if (Tipo = 3) then
        begin
          //Painéis
          if ((dmSicsMain.cdsPaineis.Active) and (not dmSicsMain.cdsPaineisClone.Active)) then
          begin
            dmSicsMain.cdsPaineisClone.CloneCursor(dmSicsMain.cdsPaineis, True);
          end;

          if dmSicsMain.cdsPaineisClone.Locate('TCPIP', IP, []) then
          begin
            S := S + ';' + dmSicsMain.cdsPaineisClone.FieldByName('NOME').AsString + ';' +
              ModelosPaineis[TModeloPainel(dmSicsMain.cdsPaineisClone.FieldByName('ID_MODELOPAINEL').AsInteger)].Nome;

            if Node[I].ImageIndex = 0 then
              S := S + ';' + 'SEM CONEXÃO' + ';'
            else
              S := S + ';' + 'CONECTADO' + ';';
          end
          else
          begin
            dmSicsMain.cdsPaineisClone.First;
            while not dmSicsMain.cdsPaineisClone.eof do
            begin
              Achou := false;
              ArrayDeIPs := StrToConexaoIPArray(dmSicsMain.cdsPaineisClone.FieldByName('TCPIP').AsString);
              try
                for j := Low(ArrayDeIPs) to High(ArrayDeIPs) do
                  if IP = ArrayDeIPs[j].EnderecoIP then
                  begin
                    S := S + ';' + dmSicsMain.cdsPaineisClone.FieldByName('NOME').AsString + ';' +
                      ModelosPaineis[TModeloPainel(dmSicsMain.cdsPaineisClone.FieldByName('ID_MODELOPAINEL').AsInteger)].Nome;

                    if Node[I].ImageIndex = 0 then
                      S := S + ';' + 'SEM CONEXÃO' + ';'
                    else
                      S := S + ';' + 'CONECTADO' + ';';

                    Achou := true;
                    break;
                  end;
              finally
                Finalize(ArrayDeIPs);
              end;

              if Achou then
                break;

              dmSicsMain.cdsPaineisClone.Next;
            end;
          end;
        end;

        if (Tipo = 4) then
        begin
          //Totens
          for J := 1 to cgMaxTotens do
          begin
            if (String(vlTotens[J].IP) = IP) then
            begin
              S := S + ';' + vlTotens[J].Nome + ';' + vlTotens[J].Modelo + ';';

              if stSemConexao in vlTotens[J].StatusTotem then
                S := S + 'SEM CONEXÃO'
              else
                S := S + 'CONECTADO';

              if stOffLine in vlTotens[J].StatusTotem then
                S := S + ', IMPRESSORA OFFLINE';

              if stPoucoPapel in vlTotens[J].StatusTotem then
                S := S + ', POUCO PAPEL';

              if stSemPapel in vlTotens[J].StatusTotem then
                S := S + ', SEM PAPEL';
            end;
          end;
        end;

        if (Tipo = 5) then
        begin
          //Teclados
        end;

        S := S + #9;
      end;
    end;
  end;

begin
  S := '';
  frmSicsConexoes := TfrmSicsConexoes.Create(Application);
  try
    CriarItemsFormConexoes;
    with frmSicsConexoes do
    begin
      Carregar(1, NodePasMultiPas);
      Carregar(2, NodeOnLineTGS);
      Carregar(3, NodePaineis);
      Carregar(4, NodeTotens);
      Carregar(5, NodeTeclados);
    end;
  finally
    FreeAndNil(frmSicsConexoes);
  end;
end;

procedure TfrmSicsMain.CarregarGruposPAS_AlarmesPapelTotens;
var
  LIni            : TIniFile;
  LGrupoPASINI    : TStringList;
  LDados          : String;
  LDadosGrupoPAS  : String;
  LCount          : Integer;
  LTotemID        : Integer;
  LTotemStatus    : String;
  LTotemGrupoPAS  : String;
  LPosDados       : Integer;
begin
  //LM
  FDTGruposPAS_AlarmesPapelTotens.Open;
  LIni := TIniFile.Create(GetIniFileName);
  try
    LGrupoPASINI := TStringList.Create;
    try
      //LM
      if LIni.SectionExists('AlarmesFaltaDePapel') then
      begin
        LIni.ReadSection('AlarmesFaltaDePapel', LGrupoPASINI);
      end;

      for LCount := LGrupoPASINI.Count - 1 downto 0 do
      begin
        LPosDados := Pos('_', LGrupoPASINI[LCount]) + 1;

        if LPosDados <> 0 then
        begin
          LDados       := Copy(LGrupoPASINI[LCount], LPosDados);
          LPosDados    := Pos('_', LDados) + 1;
          LTotemStatus := Copy(LDados,1 ,(LPosDados -2 ));
          LDados       := Copy(LDados, LPosDados);
          LPosDados    := Pos('_', LDados) + 1;
          LTotemID     := StrToIntDef(Copy(LDados, LPosDados),0);
        end;

        LDadosGrupoPAS := LIni.ReadString('AlarmesFaltaDePapel', LGrupoPASINI[LCount], EmptyStr);

        if LTotemID <> 0 then
        begin
          FDTGruposPAS_AlarmesPapelTotens.Append;
          FDTGruposPAS_AlarmesPapelTotensID_TOTEM.AsInteger := LTotemID;
          FDTGruposPAS_AlarmesPapelTotensSTATUS.AsString    := UpperCase(LTotemStatus);
          FDTGruposPAS_AlarmesPapelTotensGRUPO_PAS.AsString := LDadosGrupoPAS;
          FDTGruposPAS_AlarmesPapelTotens.Post;
        end;
      end;
    finally
      FreeAndNil(LGrupoPASINI);
    end;
  finally
    FreeAndNil(LIni);
  end;
end;

procedure TfrmSicsMain.GetJSONBySQLText(var aRetorno: string; const aSQL: String);
var
  LSQL: TFDQuery;
  LDataProvider: TDataSetProvider;
  LCDS: TClientDataSet;
begin
  aRetorno := '';
  if Trim(aSQL) = '' then
    Exit;

  LDataProvider := nil;
  LCDS := nil;
  LSQL := TFDQuery.Create(Self);
  try
    LDataProvider := TDataSetProvider.Create(Self);
    LCDS := TClientDataSet.Create(Self);
    try
      LDataProvider.DataSet := LSQL;
      LCDS.ProviderName := LDataProvider.Name;
      LSQL.SQL.Text := aSQL;
      LSQL.Open;
      aRetorno := TAspJson.DataSetToJsonTxt(LCDS);
    except
      on E: Exception do
      begin
        aRetorno := 'Erro: ' + E.Message;
        exit;
      end;
    end;
  finally
    FreeAndNil(LSQL);
    FreeAndNil(LDataProvider);
    FreeAndNil(LCDS);
  end;
end;

function TfrmSicsMain.GetModeloImpressoraZero: TTipoDeImpressora;
begin
  if ((PrinterPort.DeviceName <> '') and CharInSet(PrinterPort.DeviceName[1], ['L', 'l', 'C', 'c'])) then
    Result := tiBematech
  else
    Result := vlTotens[IdsTotens[1]].TipoImpressora;
end;

function TfrmSicsMain.ObtemColunaDaTag(ID_GrupoTag: Integer): Integer; // RAP
begin // RAP
  Result := 0;                                             // RAP
  with dmSicsMain.cdsCloneGruposDeTags do                  // RAP
    if Locate('ID', ID_GrupoTag, [loCaseInsensitive]) then // RAP
      Result := (COL_PRIMEIRA_TAG - 1) + RecNO;            // RAP
end;                                                       // RAP

procedure TfrmSicsMain.SenhasListMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  R, C                    : Integer;
  TagID, TagColor, TagNome: String;
begin
  try
    (Sender as TStringGrid).MouseToCell(X, Y, C, R);
    if ((Row <> R) or (Col <> C)) then
    begin
      if ((R >= 0) and (R <= (Sender as TStringGrid).RowCount - 1) and (C >= 0) and (C <= (Sender as TStringGrid).ColCount - 1)) then
      begin
        Row := R;
        Col := C;
        Application.CancelHint;
        if Pos(';', (Sender as TStringGrid).Cells[Col, Row]) > 0 then
        begin
          SeparaStrings((Sender as TStringGrid).Cells[Col, Row], ';', TagID, TagColor);
          SeparaStrings(TagColor, ';', TagColor, TagNome);
          (Sender as TStringGrid).Hint := TagNome;
        end
        else
          (Sender as TStringGrid).Hint := '';
      end;
    end;
  except
    { do nothing }
  end;
end;

procedure TfrmSicsMain.FazChamadaAutomatica(Fila: integer;ExcetoPA :  Integer);
const
  FazerAlgoritimoNumero : Integer = 1;
var
  StatusPA          : TStatusPA;
  DateTimePA        : TDateTime;
  PAsAlocadas       : TIntArray;
  PAsAlocadasStr    : string;
  PADisponivelDesde : TDateTime;
  I, ChamarParaPA   : integer;
  lixo              : integer;
  strlixo           : string;
  Algoritmo         : Integer;
  IniTime           : TDateTime;
begin
  Algoritmo := FazerAlgoritimoNumero;

  if (not FilaBloqueada(Fila)) and VerificaFilaChamadaAutomatica(Fila) then
  begin

    PAsAlocadas := dmSicsServidor.FilasComChamadaAutomatica[Fila].PAs;

    if length(PAsAlocadas) > 0 then
    begin
      ChamarParaPA      := -1;
      PADisponivelDesde := now + 1;

      //***************************************
      //Alteração Mod.1
      //***************************************
      if FazerAlgoritimoNumero = 1 then
      begin
        for I := Low(PAsAlocadas) to High(PAsAlocadas) do
        begin
          if((ExcetoPA <> -1) and (ExcetoPA = PAsAlocadas[I]))then
            Continue;

          if frmSicsSituacaoAtendimento.cdsPAsDisponiveisComChamadaAutomatica.Locate('ID_PA',PAsAlocadas[I],[]) and (frmSicsSituacaoAtendimento.cdsPAsDisponiveisComChamadaAutomatica.FieldByName('Horario').AsDateTime < PADisponivelDesde) then
          begin
            ChamarParaPA      := PAsAlocadas[I];
            PADisponivelDesde := frmSicsSituacaoAtendimento.cdsPAsDisponiveisComChamadaAutomatica.FieldByName('Horario').AsDateTime;
          end;
        end;

        FazerAlgoritimoNumero := 2;
      end else

      //***************************************
      //Alteração Mod.2
      //***************************************
      if FazerAlgoritimoNumero = 2 then
      begin
        with frmSicsSituacaoAtendimento.cdsPAsDisponiveisComChamadaAutomatica do
        begin
          First;
          while not Eof do
          begin

            if (ExisteNoIntArray(FieldByName('Id_PA').AsInteger, PAsAlocadas))  then
            begin
              if(FieldByName('Id_PA').AsInteger <> ExcetoPA)then
              begin
                ChamarParaPA := FieldByName('Id_PA').AsInteger;
                Break;
              end;
            end;
            Next;
          end;
        end;
        FazerAlgoritimoNumero := 1;
      end;

      if (ChamarParaPA <> -1) then
      begin
          Proximo(ChamarParaPA, IniTime);
      end;
    end;
  end;
end;

procedure TfrmSicsMain.FazerLogoutsDasPAs;
begin
  dmSicsMain.cdsPASClone.CloneCursor(frmSicsSituacaoAtendimento.cdsPAs, false, True);
  dmSicsMain.cdsPASClone.First;

  while not dmSicsMain.cdsPASClone.Eof do
  begin
    if dmSicsMain.cdsPASClone.FieldByName('Ativo').AsBoolean then
    begin
      try
        case TStatusPA(dmSicsMain.cdsPASClone.FieldByName('Id_Status').AsInteger) of
          spDisponivel, spEmAtendimento, spEmPausa: LogoutPA(dmSicsMain.cdsPASClone.FieldByName('ID_PA').AsInteger);
        end;
      except
        on E: Exception do
          MyLogException(E);
      end;
    end;
    dmSicsMain.cdsPASClone.Next;
  end;
end;

procedure TfrmSicsMain.menuModulosSicsPAClick(Sender: TObject);
begin
  ExibirConfigModuloPA(Self, FTentativasAcessoMenuProtegido, FDataUltimaTentativasAcessoMenuProtegido);
end;

procedure TfrmSicsMain.menuModulosSicsTGSClick(Sender: TObject);
begin
  ExibirConfigModuloTGS(Self, FTentativasAcessoMenuProtegido, FDataUltimaTentativasAcessoMenuProtegido);
end;

procedure TfrmSicsMain.menuModulosSicsMultiPAClick(Sender: TObject);
begin
  ExibirConfigModuloMultiPA(Self, FTentativasAcessoMenuProtegido, FDataUltimaTentativasAcessoMenuProtegido);
end;

procedure TfrmSicsMain.menuModulosSicsOnLineClick(Sender: TObject);
begin
  ExibirConfigModuloOnline(Self, FTentativasAcessoMenuProtegido, FDataUltimaTentativasAcessoMenuProtegido);
end;

procedure TfrmSicsMain.EnviarPushDeSenhaFinalizada(const ASenha: String);
var
  LIdTicket: Integer;
  LDeviceIdPush: String;
begin
  LIdTicket := GetIdTicket(StrToIntDef(ASenha, -1));
  LDeviceIdPush := dmSicsMain.GetDeviceIdSenha(LIdTicket);
  if LDeviceIdPush <> EmptyStr then
    TPushSender.SenhaFinalizada(LDeviceIdPush, ASenha);
end;

procedure TfrmSicsMain.ConfigurarRoboFilaEsperaProfissional;
begin
  RoboFilaEsperaProfissional.Interval := RoboFilaEsperaTempoSegundos * 1000;
  RoboFilaEsperaProfissional.Enabled := RoboFilaEsperaStatus;
end;

function TfrmSicsMain.GetCodProfissional(ASenha: Integer; out ACodProfissional: String): Boolean;
var
  LJSONObj: TJSONObject;
  LTicket: Integer;
begin

  Result    := False;
  ACodProfissional := EmptyStr;

  LTicket  := GetIdTicketIfPwdExists(ASenha);
  LJSONObj := dmSicsMain.GetDadosAdicionais(LTicket);
  try
    if Assigned(LJSONObj) then
    begin
      Result := LJSONObj.TryGetValue('CODPROFISSIONAL', ACodProfissional);
    end;
  finally
    if Assigned(LJSONObj) then
      LJSONObj.Free;
  end;
end;

function TfrmSicsMain.GravaRespostaPesquisaSatisfacao(ADados: TJsonObject): Boolean;
var
  LIdTicket: Integer;
  L_RESPOSTA_ID, LPERGUNTA_ID, LDEVICE_ID, LUNIDADE_ID, LALTERNATIVA_ID : integer;
  LGUID, LSENHA : string;
begin
  Result    := False;
  try
    try
      ADados.TryGetValue('PERGUNTA_ID' , LPERGUNTA_ID);
      ADados.TryGetValue('DEVICE_ID' , LDEVICE_ID);
      ADados.TryGetValue('UNIDADE_ID' , LUNIDADE_ID);
      ADados.TryGetValue('ALTERNATIVA_ID' , LALTERNATIVA_ID);
      ADados.TryGetValue('GUID' , LGUID);
      ADados.TryGetValue('SENHA' , LSENHA);
      LIdTicket  := GetIdTicket(strtointdef(LSENHA,0));

      L_RESPOSTA_ID := NGetNextGenerator('GEN_ID_SMARTSURV_RESPOSTAS');

      dmSicsMain.connOnLine.ExecSQL('INSERT INTO SMARTSURV_RESPOSTAS (ID, ALTERNATIVA_ID, DEVICE_ID, DATAHORA, TICKET) VALUES ('+inttostr(L_RESPOSTA_ID) +', '+ inttostr(LALTERNATIVA_ID)+', ' +inttostr(LDEVICE_ID)+ ', current_timestamp, '+ IntToStr(LIdTicket) + ')');

      Result:=True;
    finally

    end;
  except
    on E: Exception do
      Result := False;
  end;
end;

function TfrmSicsMain.BuscaRespostaPesquisaSatisfacaoFluxo(ADados:TJsonObject):TJsonObject;
const
  LSQL =  'SELECT srA.ALTERNATIVA_ID, srA.DATAHORA FROM SMARTSURV_RESPOSTAS srA ' +
          'WHERE srA.TICKET IN (SELECT DISTINCT (tcA.ID_TICKET) ' +
          '                       FROM TICKETS_CAMPOSADIC tcA ' +
		      '                      INNER JOIN TICKETS_CAMPOSADIC tcB ON tcA.ID_TICKET = tcB.ID_TICKET ' +
	        '                      WHERE tcA.CAMPO = :PARAMETRO_NOME AND ' +
	        '                            tcA.VALOR = :PARAMETRO_VALOR AND ' +
	        '                            tcB.CAMPO = ''FLUXO'' AND ' +
	        '                            tcB.VALOR = :FLUXO) ' +
          '  AND srA.DATAHORA = (SELECT MAX(DATAHORA)  ' +
          '                        FROM SMARTSURV_RESPOSTAS srB ' +
	        '                       WHERE srB.TICKET IN (SELECT DISTINCT (tcA.ID_TICKET) ' +
          '                                              FROM TICKETS_CAMPOSADIC tcA ' +
			    '                                             INNER JOIN TICKETS_CAMPOSADIC tcB ON tcA.ID_TICKET = tcB.ID_TICKET ' +
		      '                                             WHERE tcA.CAMPO = :PARAMETRO_NOME AND ' +
		      '                                                   tcA.VALOR = :PARAMETRO_VALOR AND ' +
		      '                                                   tcB.CAMPO = ''FLUXO'' AND ' +
		      '                                                   tcB.VALOR = :FLUXO))';
var
  LFLUXO: integer;
  LPARAMETRO_NOME, LPARAMETRO_VALOR, LResp: String;
begin
  Result    := TJSONObject.Create;
  try
    try
      ADados.TryGetValue('PARAMETRO' , LPARAMETRO_NOME);
      ADados.TryGetValue('VALOR' , LPARAMETRO_VALOR);
      ADados.TryGetValue('FLUXO' , LFLUXO);

      dmSicsMain.qryAux.Close;
      dmSicsMain.qryAux.SQL.Text := LSQL;
      dmSicsMain.qryAux.ParamByName('PARAMETRO_NOME').AsString := LPARAMETRO_NOME;
      dmSicsMain.qryAux.ParamByName('PARAMETRO_VALOR').AsString := LPARAMETRO_VALOR;
      dmSicsMain.qryAux.ParamByName('FLUXO').AsString := LFLUXO.ToString;
      dmSicsMain.qryAux.Open;
      if not dmSicsMain.qryAux.Eof then
      begin
        Result.AddPair('ALTERNATIVA', dmSicsMain.qryAux.FieldByName('ALTERNATIVA_ID').AsString);
        Result.AddPair('DATAHORA', dmSicsMain.qryAux.FieldByName('DATAHORA').AsString);
        Result.AddPair('STATUS', '1');
      end
      else
      begin
        Result.AddPair('STATUS', '0');
      end;
    finally
      dmSicsMain.qryAux.Close;
    end;
  except
    on E: Exception do

  end;
end;

end.
