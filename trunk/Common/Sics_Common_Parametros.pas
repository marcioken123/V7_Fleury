unit Sics_Common_Parametros;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  Datasnap.DBClient, Data.DB,
{$IF Defined(FIREMONKEY) AND not Defined(CompilarPara_TV)}
  FMX.Types, MyAspFuncoesUteis, FMX.StdCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Comp.Client
{$ELSE}
  MyDlls_DR, Vcl.StdCtrls, FireDAC.Comp.Client
{$ENDIF}
{$IF not Defined(CompilarPara_TV) AND not Defined(CompilarPara_TotemAA)
   AND not Defined(CompilarPara_ONLINE) AND not Defined(CompilarPara_TGSMOBILE)}
    , uDataSetHelper
{$ENDIF};

type
  // BAH TAspButton  {$IFDEF FIREMONKEY}
  // BAH TAspButton  TButtonParam = TAspButton;
  // BAH TAspButton  {$ELSE}
  // BAH TAspButton  TButtonParam = TButton;
  // BAH TAspButton  {$ENDIF FIREMONKEY}

  TParametrosDebug = record
    ModoDebug, LogSocket, LogVerifcaFilaNaOrdemDasFilas: Boolean;
    NivelDebug: Integer;
    DebugFileName: String;
  end;

  TParametrosSicsClients = record
    TCPSrvAdr: String;
    TCPSrvPort: Integer;
    TCPSrvAdrContingencia: String;
    TCPSrvPortContingencia: Integer;
    IntervaloReceberComando: Integer;
    IntervaloReconectar: Integer;

    // Obtidos do servidor
    ArqUpdateDir: String;
    NomeUnidade: String;
  end;

  TParametrosModuloPA = record
    IdModulo: Integer;
    JaEstaConfigurado: Boolean;

    IdPA: Integer;
    VisualizarProcessosParalelos: Boolean;
    ModoTerminalServer: Boolean;
    PodeFecharPrograma: Boolean;
    TagsObrigatorias: Boolean;
    ManualRedirect: Boolean;
    SecsOnRecall: Integer;
    UseCodeBar: Boolean;
    CodeBarPort: string;
    CodigosUnidades: string;
    IdUnidadeCliente: Integer;
    FilaEsperaProfissional: Integer;
    MinimizarParaBandeja: Boolean;
    VisualizarAgendamentos: Boolean;

    MostrarNomeCliente: Boolean;
    MostrarPA: Boolean;
    MostrarBotaoLogin: Boolean;
    MostrarBotaoProximo: Boolean;
    MostrarBotaoRechama: Boolean;
    MostrarBotaoEncaminha: Boolean;
    MostrarBotaoFinaliza: Boolean;
    MostrarBotaoSeguirAtendimento: Boolean;
    MostrarBotaoEspecifica: Boolean;
    MostrarBotaoPausa: Boolean;
    MostrarMenuLogin: Boolean;
    MostrarMenuLogout: Boolean;
    MostrarMenuAlteraSenha: Boolean;
    MostrarMenuProximo: Boolean;
    MostrarMenuRechama: Boolean;
    MostrarMenuSeguirAtendimento: Boolean;
    MostrarMenuEspecifica: Boolean;
    MostrarMenuEncaminha: Boolean;
    MostrarMenuFinaliza: Boolean;
    MostrarMenuPausa: Boolean;
    MostrarMenuControleRemoto: Boolean;
    MenuEscondido: Boolean;

    ConfirmarProximo: Boolean;
    ConfirmarEncaminha: Boolean;
    ConfirmarFinaliza: Boolean;
    ConfirmarSenhaOutraFila: Boolean;
    MostrarNomeAtendente: Boolean;
    MostrarPainelGrupos: Boolean;
    VisualizaPessoasFilas: Boolean;
    DBDirMultiUnidades: String;
    DBHostUnidades: String;
    DBBancoUnidades: String;
    DBUsuarioUnidades: String;
    DBSenhaUnidades: String;
    DBOSAuthentUnidades: Boolean;
    UnidadePadrao: Integer;
    UnidadesPermitidas: TIntegerDynArray;
    IDUltimaUnidadeAtiva: Integer;
    Unidade: String;
    ListaTriagemJson: String;
    NomeImpressoraEtiqueta: String;
    QtdeImpressao: Integer;
    ModeloImpressora: string;
    EnviaEtiqueta: Boolean;
    IdTagAutomatica: Integer;
    MarcarTagAposAtendimento: Boolean;
    PIAlertaSonoro: Integer;
    MostrarProntuario: Boolean;
    GruposTAGSLayoutBotao: TIntegerDynArray;
    GruposTAGSLayoutLista: TIntegerDynArray;
    GruposTAGSSomenteLeitura: TIntegerDynArray;
    MostrarDadosAdicionais: Boolean;
    URL_BuscarParametro: string;
    PermiteFinalizar: Boolean;

    // a verificar:
    DBDir: String;
    TamanhoBotoesAltura, TamanhoBotoesLargura, TamanhoFonteBotoes: Integer;

  end;

  TParametrosModuloMPA = record
    IdModulo: Integer;
    JaEstaConfigurado: Boolean;
    TempoLimparPA: Integer;
    ColunasPAs: Integer;
    VisualizarAgendamentos: Boolean;
    ConfirmarEncaminha: Boolean;
    ConfirmarFinaliza: Boolean;
    ConfirmarProximo: Boolean;
    ConfirmarSenhaOutraFila: Boolean;
    ManualRedirect: Boolean;
    ModoTerminalServer: Boolean;
    MostrarBotaoEncaminha: Boolean;
    MostrarBotaoEspecifica: Boolean;
    MostrarBotaoFinaliza: Boolean;
    MostrarBotaoSeguirAtendimento: Boolean;
    MostrarBotaoLogin: Boolean;
    MostrarBotaoPausa: Boolean;
    MostrarBotaoProcessos: Boolean;
    MostrarBotaoProximo: Boolean;
    MostrarBotaoRechama: Boolean;
    MostrarMenuAlteraSenha: Boolean;
    MostrarMenuEncaminha: Boolean;
    MostrarMenuEspecifica: Boolean;
    MostrarMenuFinaliza: Boolean;
    MostrarMenuLogin: Boolean;
    MostrarMenuLogout: Boolean;
    MostrarMenuPausa: Boolean;
    MostrarMenuControleRemoto: Boolean;
    MostrarMenuProcessos: Boolean;
    MostrarMenuProximo: Boolean;
    MostrarMenuRechama: Boolean;
    MostrarMenuSeguirAtendimento: Boolean;
    MostrarNomeCliente: Boolean;
    MostrarNomeAtendente: Boolean;
    MostrarPainelGrupos: Boolean;
    MostrarPA: Boolean;
    SecsOnRecall: Integer;
    TagsObrigatorias: Boolean;
    UseCodeBar: Boolean;
    MinimizarParaBandeja: Boolean;
    VisualizarProcessosParalelos: Boolean;
    PodeFecharPrograma: Boolean;
    CodeBarPort: String;

    DBDirMultiUnidades: String;
    DBHostUnidades: String;
    DBBancoUnidades: String;
    DBUsuarioUnidades: String;
    DBSenhaUnidades: String;
    DBOSAuthentUnidades: Boolean;

    UnidadePadrao: Integer;
    UnidadesPermitidas: TIntegerDynArray;
    IDUltimaUnidadeAtiva: Integer;
    Unidade: String;
    IdTagAutomatica: Integer;
    MarcarTagAposAtendimento: Boolean;
    PIAlertaSonoro: Integer;
    GruposTAGSLayoutBotao: TIntegerDynArray;
    GruposTAGSLayoutLista: TIntegerDynArray;
    GruposTAGSSomenteLeitura: TIntegerDynArray;
    MostrarDadosAdicionais: Boolean;

    // a verificar:
    DBDir: String;
    OcultarPADeslogada: Boolean;
    OcultarPASemEspera: Boolean;
    OcultarPASemAtendimento: Boolean;
    TamanhoBotoesAltura, TamanhoBotoesLargura, TamanhoFonteBotoes: Integer;
    EnviaEtiqueta: Boolean;
    NomeImpressoraEtiqueta: String;
    QtdeImpressao: Integer;
    ModeloImpressora: string;
    CodigosUnidades: string;
    IdUnidadeCliente: Integer;
    FilaEsperaProfissional: Integer;
    ListaTriagemJson: String;
    PermiteFinalizar: Boolean;

  end;

  TParametrosTotemTouch = record
    JaEstaConfigurado: Boolean;
    PortaTCP: Integer;
    ImagemFundo: string;
    FonteBotaoNome: String;
    FonteBotaoTamanho: Integer;
    FonteBotaoCor: TAlphaColor;
    FonteBotaoNegrito: Boolean;
    FonteBotaoItalico: Boolean;
    FonteBotaoSublinhado: Boolean;
    BotoesMargemSuperior: Integer;
    BotoesMargemInferior: Integer;
    BotoesMargemEsquerda: Integer;
    BotoesMargemDireita: Integer;
    BotoesEspacoEntreLinhas: Integer;
    BotoesEspacoEntreColunas: Integer;
    MostrarBotaoFechar: Boolean;
    BotaoFecharTamanhoMaior: Boolean;
    PortaSerialImpressora: string;
    BotoesTransparentes: Boolean;
    ColunasDeBotoes: Integer;
  end;

  TParametrosModuloOnline = record
    IdModulo: Integer;
    JaEstaConfigurado: Boolean;
    DBDir: String;
    LinhasDeFilas: Integer;
    ColunasDeFilas: Integer;
    ImpressoraComandada: Integer;
    MaiorFilaCadastrada: Integer;
    PodeFecharPrograma: Boolean;
    VisualizarGruposPAsAtds: Boolean;
    ModoCallCenter: Boolean;
    IdUnidadeCliente: Integer;

    FilasPermitidas: TIntegerDynArray;
    MostrarBotaonasFilas: TIntegerDynArray;
    MostrarBloquearNasFilas: TIntegerDynArray;
    MostrarPrioritarianasFilas: TIntegerDynArray;
    PermitirInclusaonasFilas: TIntegerDynArray;
    PermitirExclusaonasFilas: TIntegerDynArray;
    PermitirReimpressaonasFilas: TIntegerDynArray;
    VisualizarTagsNasFilas: TIntegerDynArray;
    MostrarExcluirTodas: Boolean;

    IndicadoresPermitidos: TIntegerDynArray;
    VisualizarNomeClientes: Boolean;

    DBDirMultiUnidades: String;
    DBHostUnidades: String;
    DBBancoUnidades: String;
    DBUsuarioUnidades: String;
    DBSenhaUnidades: String;
    DBOSAuthentUnidades: Boolean;

    UnidadePadrao: Integer;
    UnidadesPermitidas: TIntegerDynArray;
    IDUltimaUnidadeAtiva: Integer;
    Unidade: String;
    MostrarTempoDecorridoEspera: Boolean;
    TelaPadrao: Integer;
    MenuEscondido: Boolean;
    TamanhoFonte: Integer;
    RepintarFilas: Boolean;

    SituacaoEsperaLayout: Integer;
    SituacaoEsperaCorLayout: Integer;
    SituacaoEsperaEstiloLayout: Integer;
    CaminhoAPI: String;
    PortaServidorArquivos: Integer;
    // KM usado para solicitar as imagens das filas ao servidor
    FontePadrao: Boolean;
    TamanhoFonteFile: Integer;
    ExibirImagem: Boolean;
    ListaIDsTriagem: String;
    NomeImpressoraEtiqueta: String;
    QtdeImpressao: Integer;
    EnviaEtiqueta: Boolean;
    MostrarProntuario: Boolean;
    GruposTAGSLayoutBotao: TIntegerDynArray;
    GruposTAGSLayoutLista: TIntegerDynArray;
    GruposTAGSSomenteLeitura: TIntegerDynArray;
    MostrarDadosAdicionais: Boolean;
    MostrarTAGsPreenchidas: Boolean;
    ModeloImpressora: string;
    URL_BuscarParametro: string;
    ListaTriagemJson: string;
  end;

  TParametrosModuloTotemTouch = record
    IdModulo: Integer;
    IdTotem: Integer;
    JaEstaConfigurado: Boolean;
    DBDir: String;
    // LinhasDeFilas           : Integer;
    // ColunasDeFilas          : Integer;
    // ImpressoraComandada     : Integer;
    // MaiorFilaCadastrada     : Integer;
    // PodeFecharPrograma      : Boolean;
    // VisualizarGruposPAsAtds : Boolean;
    // ModoCallCenter          : Boolean;
    //
    // FilasPermitidas               : TIntegerDynArray;
    // MostrarBotaonasFilas          : TIntegerDynArray;
    // MostrarBloquearNasFilas       : TIntegerDynArray;
    // MostrarPrioritarianasFilas    : TIntegerDynArray;
    // PermitirInclusaonasFilas      : TIntegerDynArray;
    // PermitirExclusaonasFilas      : TIntegerDynArray;
    // PermitirReimpressaonasFilas   : TIntegerDynArray;
    // VisualizarTagsNasFilas        : TIntegerDynArray;
    // MostrarExcluirTodas           : Boolean;
    //
    // IndicadoresPermitidos        : TIntegerDynArray;
    // VisualizarNomeClientes       : Boolean;
    //
    DBDirMultiUnidades: String;
    DBHostUnidades: String;
    DBBancoUnidades: String;
    DBUsuarioUnidades: String;
    DBSenhaUnidades: String;
    DBOSAuthentUnidades: Boolean;
    //
    UnidadePadrao: Integer;
    UnidadesPermitidas: TIntegerDynArray;
    // IDUltimaUnidadeAtiva           : Integer;
    Unidade: String;
    // MostrarTempoDecorridoEspera    : Boolean;
    // TelaPadrao                     : Integer;
    // MenuEscondido                  : Boolean;
    // TamanhoFonte                   : Integer;
    // RepintarFilas                  : Boolean;
    //
    // SituacaoEsperaLayout           : Integer;
    // SituacaoEsperaCorLayout        : Integer;
    // SituacaoEsperaEstiloLayout     : Integer;
    // CaminhoAPI                     : String;
    // PortaServidorArquivos          : Integer; //KM usado para solicitar as imagens das filas ao servidor
  end;

  TParametrosModuloTotemAA = record
    IdModulo: Integer;
    IdTotem: Integer;
  end;

  TParametrosModuloTGSMobile = record
  end;

  TParametrosModuloTGS = record
    IdModulo: Integer;
    JaEstaConfigurado: Boolean;
    DBDir: String;
    VisualizarGruposPAsAtds: Boolean;
    ReportarTemposMaximos: Boolean;
    PodeConfigPrioridadesAtend: Boolean;
    PodeConfigIndDePerformance: Boolean;
    PodeConfigAtendentes: Boolean;
    PodeFecharPrograma: Boolean;
    VisualizarNomeClientes: Boolean;
    ModoCallCenter: Boolean;
    IndicadoresPermitidos: TIntegerDynArray;
    NomesIndicadoresPermitidos: TStringDynArray;
    GruposdeTagsPermitidos: TIntegerDynArray;
    MostrarRelatorioTMAA: Boolean;

    DBDirMultiUnidades: String;
    UnidadePadrao: Integer;
    UnidadesPermitidas: TIntegerDynArray;
    IDUltimaUnidadeAtiva: Integer;
    Unidade: String;
    DBHostUnidades: String;
    DBBancoUnidades: String;
    DBUsuarioUnidades: String;
    DBSenhaUnidades: String;
    DBOSAuthentUnidades: Boolean;

    // verificar
    MinimizarParaBandeja: Boolean;
    Debug: TParametrosDebug;
    MenuEscondido: Boolean;

    // RA
    CaminhoAPI: String;

    FontePadrao: Boolean;
    TamanhoFonteFile: Integer;
    ExibirImagem: Boolean;
  end;

  TParametrosModuloTVPaineis = record
    ID: Integer;
    Id_Modulo_TV: Integer;
    Tipo: Integer;
    BackgroundFile: string;
    Fonte: string;
    ArquivoSom: string;
    FlashFile: string;
    CaminhoDoExecutavel: string;
    NomeDaJanela: string;
    ResolucaoPadrao: string;
    ArquivosVideo: string;
    HostBanco: string;
    PortaBanco: string;
    NomeArquivoBanco: string;
    UsuarioBanco: string;
    SenhaBanco: string;
    DiretorioLocal: string;
    LayoutSenhaX: Integer;
    LayoutSenhaY: Integer;
    LayoutSenhaLARG: Integer;
    LayoutSenhaALT: Integer;
    LayoutPAX: Integer;
    LayoutPAY: Integer;
    LayoutPALARG: Integer;
    LayoutPAALT: Integer;
    LayoutNomeClienteX: Integer;
    LayoutNomeClienteY: Integer;
    LayoutNomeClienteLARG: Integer;
    LayoutNomeClienteALT: Integer;
    Quantidade: string;
    Atraso: string;
    Espacamento: string;
    PASPermitidas: string;
    MargemSuperior: Integer;
    MargemInferior: Integer;
    MargemEsquerda: Integer;
    MargemDireita: Integer;
    Formato: string;
    NomeArquivoHTML: string;
    IndicadorSomPI: string;
    ArquivoSomPI: string;
    Left: Integer;
    Top: Integer;
    Height: Integer;
    Width: Integer;
    Color: Integer;
    FonteSize: Integer;
    FonteColor: Integer;
    SoftwareHomologado: Integer;
    Dispositivo: Integer;
    Resolucao: Integer;
    TempoAlternancia: Integer;
    IDTVPlayListManager: Integer;
    TipoBanco: Integer;
    IntervaloVerificacao: Integer;
    LayoutSenhaAlinhamento: Integer;
    LayoutPAAlinhamento: Integer;
    LayoutNomeClienteAlinhamento: Integer;
    SomVozChamada0: Integer;
    SomVozChamada1: Integer;
    SomVozChamada2: Integer;
    VoiceIndex: Integer;
    AtualizacaoPlaylist: TDate;
    Transparente: Boolean;
    Negrito: Boolean;
    Italico: Boolean;
    Sublinhado: Boolean;
    MostrarSenha: Boolean;
    MostrarPA: Boolean;
    MostrarNomeCliente: Boolean;
    SomArquivo: Boolean;
    SomVoz: Boolean;
    SomVozChamada1Marcado: Boolean;
    SomVozChamada2Marcado: Boolean;
    SomVozChamada3Marcado: Boolean;
    DisposicaoLinhas: Boolean;
    ValorAcompanhaCorDoNivel: Boolean;
  end;

  TParametrosModuloTV = record
    IdModulo: Integer;
    IdPainel: Integer;
    PortaIPPainel: Integer;
    ChamadaInterrompeVideo: Boolean;
    MaximizarMonitor1: Boolean;
    MaximizarMonitor2: Boolean;
    IdTV: Integer;
    IndicadoresPermitidos: string;
    Paineis: array of TParametrosModuloTVPaineis;
    JaEstaConfigurado: Boolean;
    JaEstaConfiguradoPaineis: Boolean;
    Volume: integer;
    FuncionaSabado: Boolean;
    FuncionaDomingo: Boolean;
    DeH: Integer;
    DeM: Integer;
    AteH: Integer;
    AteM: Integer;
    LastMute: Integer;
  end;

  TParametrosModuloCALLCENTER = record
    IdModulo: Integer;
    JaEstaConfigurado: Boolean;
    DBDir: String;
    DBDirMultiUnidades: String;
    DBHostUnidades: String;
    DBBancoUnidades: String;
    DBUsuarioUnidades: String;
    DBSenhaUnidades: String;
    DBOSAuthentUnidades: Boolean;
    UnidadePadrao: Integer;
    Unidade: String;
    UnidadesPermitidas: TIntegerDynArray;
    // verificar
    MinimizarParaBandeja: Boolean;
    Debug: TParametrosDebug;
    MenuEscondido: Boolean;
    NumeroMesa: Integer;
    LoginAutomaticoUsuarioWindows: Boolean;
    MostrarMenuLogin: Boolean;
    MostrarMenuLogout: Boolean;
  end;

  TTipoGrafico = (tgBarras, tgPizza);

  // A REVISAR DAQUI PARA BAIXO

  // TABELA: TIPOS_MODULOS
  // CAMPO : TIPO_MODULO
  // 0 = Servidor
  // 1 = PA
  // 2 = MPA
  // 3 = TV
  // 4 = OnLine
  // 5 = TGS
  TTipoIcone = (icClose);

  TTipoEvento = (teEspera, teRechama, teAtendimento, teOcioso, teLogado,
    teEmPausa);
  TModuloSics = (msNone, msPA, msMPA, msOnLine, msTGS, msTV, msServidor,
    msCallCenter, msTotemTouch);
  // TTipoModulo = msNone..msTGS; //LM Removido porque não foi achado referencia nos projetos

  TTipoDeGrupo = (tgNenhum, tgFila, tgTAG, tgPP, tgPA, tgAtd, tgPausa, tgVisTAG,
    tgMtrBotao, tgMtrBloq, tgMtrPriori, tgMtrPermInc, tgPI);
  TTiposDeGrupo = Set of TTipoDeGrupo;

  TTipoDeGrupoPA = tgFila .. tgPausa;
  TTipoDeGrupoMPA = TTipoDeGrupoPA;
  TTipoDeGrupoOnLine = tgFila .. tgMtrPermInc;

  TGetNomeColunaPorModulo = reference to function
    (aModuloSics: TModuloSics): string;

  TTipoGrupoPorModulo = record
    IdModulo: Integer;
    FModuloSics: TModuloSics;
    TipoDeGrupo: TTipoDeGrupo;
    case TModuloSics of
      msPA:
        (GrupoPA: TTipoDeGrupoPA);
      msOnLine:
        (GrupoOnLine: TTipoDeGrupoOnLine);
      msMPA:
        (GrupoGrupoMPA: TTipoDeGrupoMPA);
      msTGS:
        (GrupoGrupoTGS: TTipoDeGrupo);
  end;

{$IF Defined(CompilarPara_PA)          }

  TParametrosModulo = TParametrosModuloPA;
{$ELSEIF Defined(CompilarPara_MULTIPA) }
  TParametrosModulo = TParametrosModuloMPA;
{$ELSEIF Defined(CompilarPara_TGS)     }
  TParametrosModulo = TParametrosModuloTGS;
{$ELSEIF Defined(CompilarPara_ONLINE)  }
  TParametrosModulo = TParametrosModuloOnline;
{$ELSEIF Defined(CompilarPara_TV)  }
  TParametrosModulo = TParametrosModuloTV;
{$ELSEIF Defined(CompilarPara_CALLCENTER) }
  TParametrosModulo = TParametrosModuloCALLCENTER;
{$ELSEIF Defined(CompilarPara_TOTEMTOUCH)  }
  TParametrosModulo = TParametrosModuloTotemTouch;
{$ELSEIF Defined(CompilarPara_TotemAA)  }
  TParametrosModulo = TParametrosModuloTotemAA;
{$ELSEIF Defined(CompilarPara_TGSMOBILE)  }
  TParametrosModulo = TParametrosModuloTGSMobile;
{$ENDIF}
function GetModuleType(Modulo: TModuloSics): Char;

function GetModuleTypeByID(AConexao: TFDConnection; AIdModulo: Integer)
  : TModuloSics;
function GetIdPA(AConexao: TFDConnection; AIdModulo: Integer): Integer;
function GetNomeTabelaDoModulo(const aTipoModulo: TModuloSics): String;
function GetNomeColunaTipoGrupoPorModulo(Const aTipoModulo: TModuloSics;
  const aTipoDeGrupo: TTipoDeGrupo): string;
function GetNomeColunaTipoGrupoMPA(Const aTipoDeGrupoMPA
  : TTipoDeGrupoMPA): string;
function GetNomeColunaTipoGrupoOnLine(Const aTipoDeGrupoOnLine
  : TTipoDeGrupoOnLine): string;
function GetNomeColunaTipoGrupoTGS(Const aTipoDeGrupoTGS: TTipoDeGrupo): string;
function GetNomeColunaTipoGrupoPA(Const aTipoDeGrupoPA: TTipoDeGrupoPA): string;
function GetFilterPorRangerID(const aRangeIDs: TIntArray;
  const aColuna: String = 'ID'): string;
function GetListaIDPermitidosDoGrupo(AConexao: TFDConnection;
  const aNomeTabela, aNomeCampo: String; const AIdModulo: Integer): TIntArray;
function GetTipoDeGrupo(Const aPrefixo: Char): TTipoDeGrupo;
procedure FiltraDataSetComPermitidas(AConexao: TFDConnection;
  const aDataSet: TClientDataSet; const AIdModulo: Integer;
  const aNomeCampo: TTipoDeGrupo; aColunaFiltrarCDS: String = 'ID';
  const aGetNomeColunaPorModulo: TGetNomeColunaPorModulo = nil);
function FormatarProtocolo(const aProtocolo: string): String;
// Mover para DLL e ClassLibrary function WriteOrReadSettings(const aWrite: Boolean; const ASection, AIdent: string; const AValueDefault: Variant; const aCanForceWrite: Boolean = True): Variant;

var
  vgParametrosModulo: TParametrosModulo;
  FDashboardConfigFileName: String = 'dashboardconfig.dat';

const
  TTipoDeGrupoTGS: TTiposDeGrupo = [tgTAG .. tgVisTAG, tgPI];
  cNaoPossuiConexaoDiretoDB =
{$IFDEF IS_MOBILE}True{$ELSE}False{$ENDIF IS_MOBILE};
  cSettings = 'Settings';
  SecaoConexoes = 'Conexoes';
  IdentiTCPSrvPort = 'TCPSrvPort';
  IdentIdModulo = 'IdModulo';
  IdentTCPSrvAdr = 'TCPSrvAdr';
  IP_DEFAULT = '127.0.0.1';
  cgMaxUnidades = 40;
  VERSAO_PROTOCOLO = 3;
  STX = Chr(2);
  ETX = Chr(3);
  TAB = Chr(9);
  ACK = Chr(6);

  CRIAR_SE_NAO_EXISTIR = True;

{$IFDEF ANDROID} // ***IOS
  // Para o android tem pastas que não possui permissão para criar o arquivo de configuração então tenta criar o ini em varias pastas
procedure ConfigurarDiretorioParametros;
{$ENDIF ANDROID}
// LBC FEITO:
procedure ConfiguraBotaoModuloPA(const aBotao: TButton);
procedure ConfiguraBotaoModuloMPA(const aBotao: TButton);

implementation

uses
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt;

procedure ConfiguraBotaoModuloPA(const aBotao: TButton);
begin
{$IFDEF CompilarPara_PA}
  aBotao.Height := vgParametrosModulo.TamanhoBotoesAltura;
  aBotao.Width := vgParametrosModulo.TamanhoBotoesLargura;

{$IFDEF FIREMONKEY}
  aBotao.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style,
    TStyledSetting.FontColor];
  aBotao.TextSettings.Font.Size := vgParametrosModulo.TamanhoFonteBotoes;
{$ENDIF FIREMONKEY}
{$ENDIF CompilarPara_PA}
end;

procedure ConfiguraBotaoModuloMPA(const aBotao: TButton);
begin
{$IFDEF CompilarPara_MPA}
  aBotao.Height := vgParametrosModulo.TamanhoBotoesAltura;
  aBotao.Width := vgParametrosModulo.TamanhoBotoesLargura;
{$IFDEF FIREMONKEY}
  aBotao.StyledSettings := [TStyledSetting.Family, TStyledSetting.Style,
    TStyledSetting.FontColor];
  aBotao.TextSettings.Font.Size := vgParametrosModulo.TamanhoFonteBotoes;
{$ENDIF FIREMONKEY}
{$ENDIF CompilarPara_MPA}
end;

function FormatarProtocolo(const aProtocolo: string): String;
begin
  // LBC TRAZER TAspEncode para VCL e FMX  result := STX + TAspEncode.AspIntToHex(VERSAO_PROTOCOLO, 4) + aProtocolo + ETX;
  result := STX + IntToHex(VERSAO_PROTOCOLO, 4) + aProtocolo + ETX;
end;

procedure FiltraDataSetComPermitidas(AConexao: TFDConnection;
  const aDataSet: TClientDataSet; const AIdModulo: Integer;
  const aNomeCampo: TTipoDeGrupo; aColunaFiltrarCDS: String;
  const aGetNomeColunaPorModulo: TGetNomeColunaPorModulo);
var
  vRangeIDs: TIntArray;
  vRangePermitido: string;
  vTipoModulo: TModuloSics;
  vNomeTabela, vNomeColuna: string;
begin
  vRangePermitido := EmptyStr;
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

    vRangeIDs := GetListaIDPermitidosDoGrupo(AConexao, vNomeTabela, vNomeColuna,
      AIdModulo);
    try
      vRangePermitido := GetFilterPorRangerID(vRangeIDs, aColunaFiltrarCDS);
    finally
      Finalize(vRangeIDs);
    end;
  finally
    aDataSet.Filtered := False;
    aDataSet.Filter := vRangePermitido;
    aDataSet.Filtered := vRangePermitido <> '';
  end;
end;

function GetTipoDeGrupo(Const aPrefixo: Char): TTipoDeGrupo;
begin
  case UpperCase(aPrefixo)[1] of
    'A':
      result := tgAtd;
    'B':
      result := tgMtrBloq;
    'F':
      result := tgFila;
    'I', 'K':
      result := tgPI;
    'M':
      result := tgPausa;
    'N':
      result := tgMtrPermInc;
    'P':
      result := tgPA;
    'O':
      result := tgMtrPriori;
    'S':
      result := tgMtrBotao;
    'T':
      result := tgTAG;
    'p', 'R':
      result := tgPP;
    'V':
      result := tgVisTAG;
  else
    result := tgNenhum;
  end;
end;

function GetNomeTabelaDoModulo(const aTipoModulo: TModuloSics): String;
begin
  case aTipoModulo of
    msPA:
      result := 'MODULOS_PAS';
    msMPA:
      result := 'MODULOS_MULTIPAS';
    msOnLine:
      result := 'MODULOS_ONLINE';
    msTGS:
      result := 'MODULOS_TGS';
    msCallCenter:
      result := 'MODULOS_CALLCENTER';
  else
    result := EmptyStr;
  end;
end;

function GetNomeColunaTipoGrupoPorModulo(Const aTipoModulo: TModuloSics;
  const aTipoDeGrupo: TTipoDeGrupo): string;
begin
  case aTipoModulo of
    msPA:
      result := GetNomeColunaTipoGrupoPA(TTipoDeGrupoPA(aTipoDeGrupo));
    msMPA:
      result := GetNomeColunaTipoGrupoMPA(TTipoDeGrupoMPA(aTipoDeGrupo));
    msOnLine:
      result := GetNomeColunaTipoGrupoOnLine(TTipoDeGrupoOnLine(aTipoDeGrupo));
    msTGS:
      result := GetNomeColunaTipoGrupoTGS(aTipoDeGrupo);
  else
    result := '';
  end;
end;

function GetNomeColunaTipoGrupoMPA(Const aTipoDeGrupoMPA
  : TTipoDeGrupoMPA): string;
begin
  case aTipoDeGrupoMPA of
    tgPA:
      result := 'PAS_PERMITIDAS';
    tgAtd:
      result := 'GRUPOS_ATENDENTES_PERMITIDOS';
    tgTAG:
      result := 'GRUPOS_DE_TAGS_PERMITIDOS';
    tgPP:
      result := 'GRUPOS_DE_PPS_PERMITIDOS';
    tgFila:
      result := 'FILAS_PERMITIDAS';
    tgPausa:
      result := 'GRUPOS_DE_PAUSAS_PERMITIDOS';
  else
    result := '';
    // raise TAspException.create(nil, 'Tipo de grupo MultiPA não configurado.');
  end;
end;

function GetNomeColunaTipoGrupoOnLine(Const aTipoDeGrupoOnLine
  : TTipoDeGrupoOnLine): string;
begin
  case aTipoDeGrupoOnLine of
    tgMtrBotao:
      result := 'MOSTRAR_BOTAO_NAS_FILAS';
    tgMtrBloq:
      result := 'MOSTRAR_BLOQUEAR_NAS_FILAS';
    tgMtrPriori:
      result := 'MOSTRAR_PRIORITARIA_NAS_FILAS';
    tgMtrPermInc:
      result := 'PERMITIR_INCLUSAO_NAS_FILAS';
    // tgVisTAG     : Result := 'VISUALIZAR_TAGS_NAS_FILAS';  BAH
    tgPausa:
      result := 'GRUPOS_MOTIVOS_PAUSA_PERMITIDO';
    tgAtd:
      result := 'GRUPOS_ATENDENTES_PERMITIDOS';
    tgPA:
      result := 'GRUPOS_PAS_PERMITIDAS';
    tgTAG:
      result := 'GRUPOS_TAGS_PERMITIDAS';
    tgFila:
      result := 'FILAS_PERMITIDAS';
  else
    result := '';
    // raise TAspException.create(nil, 'Tipo de grupo OnLine não configurado.');
  end;
end;

function GetNomeColunaTipoGrupoTGS(Const aTipoDeGrupoTGS: TTipoDeGrupo): string;
begin
  case aTipoDeGrupoTGS of
    tgTAG:
      result := 'GRUPOS_DE_TAGS_PERMITIDOS';
    tgPP:
      result := 'GRUPOS_DE_PPS_PERMITIDOS';
    tgPA:
      result := 'GRUPOS_DE_PAS_PERMITIDAS';
    tgAtd:
      result := 'GRUPOS_DE_ATENDENTES_PERMITIDOS';
    tgPausa:
      result := 'GRUPOS_DE_MOTIVOS_DE_PAUSA_PERM';
    tgVisTAG:
      result := 'VISUALIZAR_TAGS_NAS_FILAS';
    tgPI:
      result := 'GRUPOS_INDICADORES_PERMITIDOS';
  else
    result := '';
    // raise TAspException.create(Self, 'Grupo da configuração TGS não foi implementado.');
  end;
end;

function GetNomeColunaTipoGrupoPA(Const aTipoDeGrupoPA: TTipoDeGrupoPA): string;
begin
  case aTipoDeGrupoPA of
    tgPausa:
      result := 'GRUPOS_DE_PAUSAS_PERMITIDOS';
    tgAtd:
      result := 'GRUPOS_ATENDENTES_PERMITIDOS';
    tgTAG:
      result := 'GRUPOS_DE_TAGS_PERMITIDOS';
    tgPP:
      result := 'GRUPOS_DE_PPS_PERMITIDOS';
    tgFila:
      result := 'FILAS_PERMITIDAS';
    tgPA:
      result := 'PAS_PERMITIDAS';
  else
    result := '';
    // raise TAspException.create(nil, 'Tipo de grupo PA não configurado.');
  end;
end;

function GetFilterPorRangerID(const aRangeIDs: TIntArray;
  const aColuna: String = 'ID'): string;
var
  i: Integer;
begin
  result := EmptyStr;

  for i := 0 to High(aRangeIDs) do
  begin
    if result <> '' then
      result := result + ' OR ';
    result := result + '(' + aColuna + ' = ' + IntToStr(aRangeIDs[i]) + ')';
  end;
end;

function GetModuleType(Modulo: TModuloSics): Char;
begin
  case Modulo of
    msPA:
      result := Chr($50);
    msMPA:
      result := Chr($4D);
    msTV:
      result := Chr($56);
    msOnLine:
      result := Chr($4F);
    msTGS:
      result := Chr($54);
    msCallCenter:
      result := Chr($43);
  else
    result := #0;
    // raise TAspException.create(nil, 'Módulo inválido.');
  end;
end;

function GetModuleTypeByID(AConexao: TFDConnection; AIdModulo: Integer)
  : TModuloSics;
var
  LSQLQuery: TFDQuery;
begin
  result := msNone;
  LSQLQuery := TFDQuery.Create(nil);
  try
    LSQLQuery.Connection := AConexao;
    LSQLQuery.SQL.Text :=
      'SELECT TIPO FROM MODULOS WHERE ID_UNIDADE = :ID_UNIDADE AND ID = ' +
      IntToStr(AIdModulo);
    LSQLQuery.Open;
    if not LSQLQuery.IsEmpty then
    begin
      result := TModuloSics(LSQLQuery.Fields[0].AsInteger);
    end;
  finally
    freeAndNil(LSQLQuery);
  end;
end;

function GetListaIDPermitidosDoGrupo(AConexao: TFDConnection;
  const aNomeTabela, aNomeCampo: String; const AIdModulo: Integer): TIntArray;
var
  aQuery: TFDQuery;
begin
  SetLength(result, 0);
  aQuery := TFDQuery.Create(nil);
  try
    aQuery.Connection := AConexao;
    aQuery.SQL.Text :=
      Format('SELECT %s FROM %s WHERE ID_UNIDADE = :ID_UNIDADE AND ID = %d',
      [aNomeCampo, aNomeTabela, AIdModulo]);
    aQuery.Open;
    StrToIntArray(aQuery.Fields[0].AsString, result);
  finally
    freeAndNil(aQuery);
  end;
end;

function GetIdPA(AConexao: TFDConnection; AIdModulo: Integer): Integer;
var
  vNomeTabela: string;
  LSQLQuery: TFDQuery;
begin
  result := 0;

  if GetModuleTypeByID(AConexao, AIdModulo) = msPA then
  begin
    vNomeTabela := 'MODULOS_PAS';
    LSQLQuery := TFDQuery.Create(nil);
    try
      LSQLQuery.Connection := AConexao;
      LSQLQuery.SQL.Text :=
        Format('SELECT ID_PA FROM %s WHERE ID_UNIDADE = :ID_UNIDADE AND ID = %d',
        [vNomeTabela, AIdModulo]);
      LSQLQuery.Open;
      result := LSQLQuery.Fields[0].AsInteger;
    finally
      freeAndNil(LSQLQuery);
    end;
  end;
end;


// Mover para DLL e ClassLibrary function WriteOrReadSettings (const aWrite: Boolean; const ASection, AIdent: string; const AValueDefault: Variant; const aCanForceWrite: Boolean): Variant;
// Mover para DLL e ClassLibrary begin
// Mover para DLL e ClassLibrary   Result := AValueDefault;
// Mover para DLL e ClassLibrary   if awrite then
// Mover para DLL e ClassLibrary     WriteSettings(ASection, AIdent, AValueDefault, aCanForceWrite)
// Mover para DLL e ClassLibrary   else
// Mover para DLL e ClassLibrary     Result := ReadSettings(ASection, AIdent, AValueDefault, aCanForceWrite);
// Mover para DLL e ClassLibrary end;

{$IFDEF ANDROID}

// ***IOS
procedure ConfigurarDiretorioParametros;
var
  oFile: TStringList;

  function SetNewDir(const aDir: String): Boolean;
  begin
    try
      FDiretorioAsp := IncludeTrailingPathDelimiter(aDir);
      SetIniFileName('');
      oFile.SaveToFile(SettingsFileName);
      result := FileExists(SettingsFileName);
    except
      result := False;
      Exit;
    end;
  end;

begin
  if FileExists(SettingsFileName) then
    Exit;

  oFile := TStringList.Create;
  try
    try
      oFile.SaveToFile(SettingsFileName);
      if FileExists(SettingsFileName) then
        Exit;
    except
    end;

    if SetNewDir(TPath.GetSharedDocumentsPath) or
      SetNewDir(TPath.GetDocumentsPath) or SetNewDir(TPath.GetPublicPath) or
      SetNewDir(TPath.GetTempPath) or SetNewDir(TPath.GetCachePath) then
      Exit;
  finally
    freeAndNil(oFile);
  end;
end;

initialization

ConfigurarDiretorioParametros;
{$ENDIF ANDROID}

end.
