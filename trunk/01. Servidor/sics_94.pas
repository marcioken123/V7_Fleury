unit sics_94;

// RAP "cdsTags" foNoPartialCompare = True

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  SysUtils, Classes, FMTBcd, DB, Provider, DBClient, System.UITypes,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Sics_91, uScriptUnidades,
  MyDlls_DR, IniFiles, System.JSON, UConexaoBD, Vcl.Clipbrd,
  System.Generics.Collections,
{$IFNDEF IS_MOBILE}
  Windows, FireDAC.Phys.IB, FireDAC.Phys.FB
{$ENDIF}
  , MyAspFuncoesUteis_VCL,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.VCLUI.Wait,
  FireDAC.Phys.MSSQL, uDataSetHelper, FireDAC.DApt.Intf;

const
  cgMAXFILAS = 999;

  cgMaxAtTypes       = 5;
  cgMaxAtds          = 999;
  cgMaxPAs           = 999;
  cgMAXBOTOESDOTOTEM = 8;
  cgMaxGrupos        = 999;
  cgMaxTotens        = 20;
  cgMaxTVs           = 30;
  TODOS_OS_PAINEIS   = -1;

  clMaxPIs = 1000;

  CONFIG_KEY_BD_VERSION = 'BD_VERSION';

  CONFIG_KEY_PATHUPDATE_PA         = 'PATH_UPDATE_PA';
  CONFIG_KEY_PATHUPDATE_MULTIPA    = 'PATH_UPDATE_MULTIPA';
  CONFIG_KEY_PATHUPDATE_ONLINE     = 'PATH_UPDATE_ONLINE';
  CONFIG_KEY_PATHUPDATE_TGS        = 'PATH_UPDATE_TGS';
  CONFIG_KEY_PATHUPDATE_TV         = 'PATH_UPDATE_TV';
  CONFIG_KEY_PATHUPDATE_CALLCENTER = 'PATH_UPDATE_CALLCENTER';
  CONFIG_KEY_PATHUPDATE_TOTEMTOUCH = 'PATH_UPDATE_TOTEMTOUCH';


  VERSAO_PROTOCOLO = 3;
  STX              = Chr(2);
  ETX              = Chr(3);
  TAB              = Chr(9);

  // cSELECT_NEXT_GEN = 'SELECT CAST(GEN_ID(GEN_ID_%s, %d) AS INTEGER) AS ID FROM RDB$DATABASE';

  // cSELECT_NEXT_GEN = 'SELECT CAST(GEN_ID(%s, %d) AS INTEGER) AS ID FROM RDB$DATABASE';

type
  TBotoesDoTotem   = array [0 .. cgMAXBOTOESDOTOTEM - 1] of integer;
  TStatusParaTotem = (stSemConexao, stOffLine, stPoucoPapel, stSemPapel);
  TStatusDoTotem   = set of TStatusParaTotem;

  // TTipoBanco = (tbFireBird, tbSqlServer);

  TOpcoesDoTotem = record
    PicoteEntreVias, CorteParcialAoFinal, ImprimirCodigoDeBarrasSenha, ImprimirDataEHoraNaSegundaVia, ImprimirNomeDaFilaNaSegundaVia: boolean;
  end;

  TStatusSocket = (ssIdle, ssLookingUp, ssConnecting, ssConnected);

  TTotem = record
    IP: string{$IFNDEF IS_MOBILE}[15]{$ENDIF IS_MOBILE};
    Botoes: TBotoesDoTotem;
    StatusTotem: TStatusDoTotem;
    StatusSocket: TStatusSocket;
    KeepAliveTimeout: integer;
    IdModeloTotem: integer;
    Nome: String;
    Modelo: String;
    TipoImpressora: TTipoDeImpressora;
    Opcoes: TOpcoesDoTotem;
  end;

  TTotensList = array [1 .. cgMaxTotens] of TTotem;

  TTV = record
    IP:             String;
    Nome:           String;
    TunerPresent:   String;
    VideoState:     String;
    VideoError:     String;
    CurrentUI:      String;
    Legenda:        String;
    CurrentChannel: String;
  end;

  TTVsList = array [1 .. cgMaxTVs] of TTV;

  TEmailsDeMonitoramento = record
    Enviar: boolean;
    ConexaoEquipamentos, FaltaPapel: string;
  end;

  TFormatoHorarioNoJornalEletronico = (fhHoraHMinutos, fhHoraDoisPontosMinutos, fhExtenso);

  TArrConnsRelatorios = array of TFDConnection;

  TParamsNiveisSla = record
    Amarelo: integer;
    Vermelho: integer;
  end;

  TDadoAdicionalNaSenha = record
                            Chave : string;
                            Valor : string;
                          end;

  TDadosAdicionaisNaSenha = array[1..10] of TDadoAdicionalNaSenha;

  TParametrosModulo_Servidor = record
    // ArqUpdateDir,
    PathGBak, PathRT, NomeUnidade: String;
    TCPPort, TCPPortTGS, TCPPortRetrocompatibilidade: integer;
    EmailsMonitoramento: TEmailsDeMonitoramento;
    WebserverAtivo: boolean;
    WebserverPort: integer;
    ReportarTemposMaximos: boolean;
    DirXmlWS: String;
    SmtpNomeRemetente, SmtpEmailRemetente: String;
    TimeOutPA, TimeoutPing: integer;
    ReportarChamadasComTE: boolean;
    SomenteCDB_CorteAoFinal: boolean;
    PermiteExcluirSenhas: boolean;
    ProximoNaoEncerraPausa: boolean;
    DelayChamadaAutomatica: integer;
    QtdeUltimasSenhasParaComporTMA: integer;
    IntervaloEmSegsParaRecalculoDePIs: integer;
    IntervaloEmSegsParaEnvioDePIsViaWS: integer;
    FormatoHorarioNoJornalEletronico: TFormatoHorarioNoJornalEletronico;
    IntervaloEmSegsParaConsiderarDadoObsoleto: integer;
    FileAtivo: integer;
    FilePorta: integer;
    IdUnidade: integer;
    BaseDeUnidades: String;
    CaminhoAPI: String;
    DBDirUnidades: String;
    DBHostUnidades: String;
    DBBancoUnidades: String;
    DBUsuarioUnidades: String;
    DBSenhaUnidades: String;
    DBOSAuthentUnidades: boolean;
    DiasDeviceOcioso: integer;
    AtualizarHoraTrocaFila: Boolean;
    TAGEspecial: integer;
    RetrocompatibilidadeDeProtocolo: boolean;
    QuantidadeSenhasCalculoTMEPorFila                  : Integer;
    LimparFilasMeiaNoite                               : boolean;
    TMAPorFilaInicialEmMinutos                         : Integer;
    DadosAdicionaisAImprimirNaSenha                    : TDadosAdicionaisNaSenha;

    ParametrosTEE : record
                      ConsiderarPAsDeslogadas         : boolean;
                      MinutosConsiderarPAsDeslogadas  : Integer;
                      InverterEnvioDeTEE_TME          : boolean;
                      LogarParametrosDeCalculo        : boolean;
                    end;

    UrlApi, NomeUnidadeApi, Especialidades, TextoSemEspera: String;
    IntervaloApi, TempoMaximoSemRetornoAPI: integer;
    FormatoHorarioEsperaNoJornalEletronico: TFormatoHorarioNoJornalEletronico;
    GerarIdTicketAoChamarEspecificaQueNaoExista: boolean;
    Provider, APIKey, AuthToken, PhoneNumber: String;
    TempoMinutosEnvio: integer;
    HorarioEnvio, Destinatarios: String;
  end;

  TParametrosModulo_Config = record
    ArqUpdateDir, DBDir: String;
    DBHost: String;
    DBBanco: String;
    DBUsuario: String;
    DBSenha: String;
    DBOSAuthent: boolean;
    DiasDeviceOcioso: integer;
  end;

type
  TdmSicsMain = class(TDataModule)
    tblGenerica1: TFDTable;
    cdsFilas: TClientDataSet;
    dspGenerico: TDataSetProvider;
    cdsPaineis: TClientDataSet;
    cdsGruposDePAs: TClientDataSet;
    cdsPAs: TClientDataSet;
    cdsAtendentes: TClientDataSet;
    cdsGruposDeAtendentes: TClientDataSet;
    cdsGruposDePaineis: TClientDataSet;
    cdsCelulares: TClientDataSet;
    cdsEmails: TClientDataSet;
    cdsContadoresDeFilas: TClientDataSet;
    cdsContadoresDeFilasID: TIntegerField;
    cdsContadoresDeFilasCONTADOR: TIntegerField;
    dsFilas: TDataSource;
    dsPaineis: TDataSource;
    cdsControleDePaineis: TClientDataSet;
    cdsControleDePaineisID: TIntegerField;
    cdsControleDePaineisPROXIMACHAMADA: TDateTimeField;
    qryGeneratorGenerico: TFDQuery;
    dsPAs: TDataSource;
    cdsNN_PAs_Filas: TClientDataSet;
    cdsPIS: TClientDataSet;
    dspPIS: TDataSetProvider;
    qryPIS: TFDQuery;
    cdsPisRelacionados: TClientDataSet;
    dspPisRelacionados: TDataSetProvider;
    qryPisRelacionados: TFDQuery;
    dtsPis: TDataSource;
    cdsPISID_PI: TSmallintField;
    cdsPISID_PITIPO: TSmallintField;
    cdsPISID_PIFUNCAO: TSmallintField;
    cdsPISID_PIPOS: TSmallintField;
    cdsPisRelacionadosID_PI: TSmallintField;
    cdsPisRelacionadosID_RELACIONADO: TIntegerField;
    cdsPISVALOR: TFloatField;
    dspMonitoramentos: TDataSetProvider;
    cdsMonitoramentos: TClientDataSet;
    qryMonitoramentos: TFDQuery;
    dspHorarios: TDataSetProvider;
    cdsHorarios: TClientDataSet;
    qryHorarios: TFDQuery;
    cdsAlarmes: TClientDataSet;
    dspAlarmes: TDataSetProvider;
    qryAlarmes: TFDQuery;
    dsMonitoramentos: TDataSource;
    cdsIdsRelacionados: TClientDataSet;
    dspIdsRelacionados: TDataSetProvider;
    qryIdsRelacionados: TFDQuery;
    dsAlarmes: TDataSource;
    cdsMonitoramentosID_PIMONITORAMENTO: TSmallintField;
    cdsMonitoramentosID_PI: TSmallintField;
    cdsMonitoramentosID_PIHORARIO: TSmallintField;
    cdsMonitoramentosPINOME: TStringField;
    cdsMonitoramentosCARACTERES: TIntegerField;
    cdsMonitoramentosALINHAMENTO: TSmallintField;
    cdsMonitoramentosFORMATOHORARIO: TStringField;
    cdsMonitoramentosVALOR: TFloatField;
    cdsUnidades: TClientDataSet;
    cdsUnidadesID: TIntegerField;
    cdsUnidadesNOME: TStringField;
    cdsUnidadesPATH_BASE_ONLINE: TStringField;
    cdsUnidadesPATH_BASE_RELATORIOS: TStringField;
    cdsUnidadesIDX_CONN_RELATORIO: TIntegerField;
    cdsUnidadesClone: TClientDataSet;
    qryAux: TFDQuery;
    qryAuxScriptBd: TFDQuery;
    cdsTags: TClientDataSet;
    cdsGruposDeTags: TClientDataSet;
    qryInserirTotem: TFDQuery;
    cdsTotens: TClientDataSet;
    dspTotens: TDataSetProvider;
    qryTotens: TFDQuery;
    cdsUnidadesIP_ENDERECO: TStringField;
    cdsUnidadesIP_PORTA: TIntegerField;
    cdsUnidadesCONECTADA: TBooleanField;
    cdsTVsCanais: TClientDataSet;
    dspTVsCanais: TDataSetProvider;
    qryTVsCanais: TFDQuery;
    cdsPISNiveis: TClientDataSet;
    cdsCloneGruposDeTags: TClientDataSet;
    cdsPPs: TClientDataSet;
    cdsGruposDePPs: TClientDataSet;
    cdsMotivosDePausa: TClientDataSet;
    cdsStatusDasPAs: TClientDataSet;
    cdsGruposDeMotivosPausa: TClientDataSet;
    dscSicsPA: TDataSource;
    dspSicsPA: TDataSetProvider;
    cdsSicsPA: TClientDataSet;
    cdsSicsPAID: TIntegerField;
    cdsSicsPAID_PA: TIntegerField;
    cdsSicsPAGRUPOS_ATENDENTES_PERMITIDOS: TStringField;
    cdsSicsPAGRUPOS_DE_TAGS_PERMITIDOS: TStringField;
    cdsSicsPAGRUPOS_DE_PPS_PERMITIDOS: TStringField;
    cdsSicsPAVISUALIZAR_PROCESSOS_PARALELOS: TStringField;
    cdsSicsPAMODO_LOGIN_LOGOUT: TStringField;
    cdsSicsPAMODO_TERMINAL_SERVER: TStringField;
    cdsSicsPAPODE_FECHAR_PROGRAMA: TStringField;
    cdsSicsPATAGS_OBRIGATORIAS: TStringField;
    cdsSicsPAMANUAL_REDIRECT: TStringField;
    cdsSicsPASECS_ON_RECALL: TIntegerField;
    cdsSicsPAUSE_CODE_BAR: TStringField;
    cdsSicsPAFILAS_PERMITIDAS: TStringField;
    cdsSicsPAMOSTRAR_NOME_CLIENTE: TStringField;
    cdsSicsPAMOSTRAR_PA: TStringField;
    cdsSicsPAMOSTRAR_BOTAO_LOGIN: TStringField;
    cdsSicsPAMOSTRAR_BOTAO_PROXIMO: TStringField;
    cdsSicsPAMOSTRAR_BOTAO_RECHAMA: TStringField;
    cdsSicsPAMOSTRAR_BOTAO_ENCAMINHA: TStringField;
    cdsSicsPAMOSTRAR_BOTAO_FINALIZA: TStringField;
    cdsSicsPAMOSTRAR_BOTAO_ESPECIFICA: TStringField;
    cdsSicsPAMOSTRAR_MENU_LOGIN: TStringField;
    cdsSicsPAMOSTRAR_MENU_ALTERA_SENHA: TStringField;
    cdsSicsPAMOSTRAR_MENU_PROXIMO: TStringField;
    cdsSicsPAMOSTRAR_MENU_RECHAMA: TStringField;
    cdsSicsPAMOSTRAR_MENU_ESPECIFICA: TStringField;
    cdsSicsPAMOSTRAR_MENU_ENCAMINHA: TStringField;
    cdsSicsPAMOSTRAR_MENU_FINALIZA: TStringField;
    cdsSicsPACONFIRMAR_PROXIMO: TStringField;
    cdsSicsPACONFIRMAR_ENCAMINHA: TStringField;
    cdsSicsPACONFIRMAR_FINALIZA: TStringField;
    cdsSicsPACONFIRMAR_SENHA_OUTRA_FILA: TStringField;
    cdsSicsPAMINIMIZAR_PARA_BANDEJA: TStringField;
    qrySicsPA: TFDQuery;
    cdsFiltroGrupos: TClientDataSet;
    cdsFiltroFilas: TClientDataSet;
    dscSicsMultiPA: TDataSource;
    dspSicsMultiPA: TDataSetProvider;
    cdsSicsMultiPA: TClientDataSet;
    cdsSicsMultiPAID: TIntegerField;
    cdsSicsMultiPAGRUPOS_ATENDENTES_PERMITIDOS: TStringField;
    cdsSicsMultiPAGRUPOS_DE_TAGS_PERMITIDOS: TStringField;
    cdsSicsMultiPAGRUPOS_DE_PPS_PERMITIDOS: TStringField;
    cdsSicsMultiPAVISUALIZAR_PROCESSOS_PARALELOS: TStringField;
    cdsSicsMultiPAMODO_LOGIN_LOGOUT: TStringField;
    cdsSicsMultiPAPODE_FECHAR_PROGRAMA: TStringField;
    cdsSicsMultiPATAGS_OBRIGATORIAS: TStringField;
    cdsSicsMultiPAMANUAL_REDIRECT: TStringField;
    cdsSicsMultiPASECS_ON_RECALL: TIntegerField;
    cdsSicsMultiPAUSE_CODE_BAR: TStringField;
    cdsSicsMultiPAFILAS_PERMITIDAS: TStringField;
    cdsSicsMultiPAMOSTRAR_NOME_CLIENTE: TStringField;
    cdsSicsMultiPAMOSTRAR_PA: TStringField;
    cdsSicsMultiPAMOSTRAR_BOTAO_LOGIN: TStringField;
    cdsSicsMultiPAMOSTRAR_BOTAO_PROXIMO: TStringField;
    cdsSicsMultiPAMOSTRAR_BOTAO_RECHAMA: TStringField;
    cdsSicsMultiPAMOSTRAR_BOTAO_ENCAMINHA: TStringField;
    cdsSicsMultiPAMOSTRAR_BOTAO_FINALIZA: TStringField;
    cdsSicsMultiPAMOSTRAR_BOTAO_ESPECIFICA: TStringField;
    cdsSicsMultiPAMOSTRAR_MENU_LOGIN: TStringField;
    cdsSicsMultiPAMOSTRAR_MENU_ALTERA_SENHA: TStringField;
    cdsSicsMultiPAMOSTRAR_MENU_PROXIMO: TStringField;
    cdsSicsMultiPAMOSTRAR_MENU_RECHAMA: TStringField;
    cdsSicsMultiPAMOSTRAR_MENU_ESPECIFICA: TStringField;
    cdsSicsMultiPAMOSTRAR_MENU_ENCAMINHA: TStringField;
    cdsSicsMultiPAMOSTRAR_MENU_FINALIZA: TStringField;
    cdsSicsMultiPACONFIRMAR_PROXIMO: TStringField;
    cdsSicsMultiPACONFIRMAR_ENCAMINHA: TStringField;
    cdsSicsMultiPACONFIRMAR_FINALIZA: TStringField;
    cdsSicsMultiPACONFIRMAR_SENHA_OUTRA_FILA: TStringField;
    cdsSicsMultiPAMINIMIZAR_PARA_BANDEJA: TStringField;
    cdsSicsMultiPACOLUNAS_PAS: TIntegerField;
    cdsSicsMultiPATEMPO_LIMPAR_PA: TIntegerField;
    qrySicsMultiPA: TFDQuery;
    cdsSicsMultiPAPAS_PERMITIDAS: TStringField;
    cdsSicsMultiPAMOSTRAR_BOTAO_PAUSA: TStringField;
    cdsSicsMultiPAMOSTRAR_BOTAO_PROCESSOS: TStringField;
    dscModulos: TDataSource;
    dspModulos: TDataSetProvider;
    cdsModulos: TClientDataSet;
    qryModulos: TFDQuery;
    cdsModulosID: TIntegerField;
    cdsModulosTIPO: TIntegerField;
    cdsModulosNOME: TStringField;
    cdsSicsPAMOSTRAR_BOTAO_PAUSA: TStringField;
    cdsSicsPAMOSTRAR_MENU_PAUSA: TStringField;
    cdsSicsPAPAS_PERMITIDAS: TStringField;
    cdsFiltroPAs: TClientDataSet;
    qrySicsOnLine: TFDQuery;
    dspSicsOnLine: TDataSetProvider;
    cdsSicsOnLine: TClientDataSet;
    dscSicsOnLine: TDataSource;
    cdsSicsOnLineID: TIntegerField;
    cdsSicsOnLineFILAS_PERMITIDAS: TStringField;
    cdsSicsOnLineGRUPOS_INDICADORES_PERMITIDOS: TStringField;
    cdsSicsOnLineMOSTRAR_BOTAO_NAS_FILAS: TStringField;
    cdsSicsOnLineMOSTRAR_BLOQUEAR_NAS_FILAS: TStringField;
    cdsSicsOnLineMOSTRAR_PRIORITARIA_NAS_FILAS: TStringField;
    cdsSicsOnLinePERMITIR_INCLUSAO_NAS_FILAS: TStringField;
    cdsSicsOnLineIMPRESSORA_COMANDADA: TIntegerField;
    cdsSicsOnLineCOLUNAS_DE_FILAS: TIntegerField;
    cdsSicsOnLineMODO_TOTEM_TOUCH: TStringField;
    cdsSicsOnLineGRUPOS_MOTIVOS_PAUSA_PERMITIDO: TStringField;
    cdsSicsOnLineVISUALIZAR_GRUPOS: TStringField;
    cdsSicsOnLineTOTEM_BOTOES_COLUNAS: TIntegerField;
    cdsSicsOnLineTOTEM_BOTOES_TRANSPARENTES: TStringField;
    cdsSicsOnLineTOTEM_BOTOES_MARGEM_SUPERIOR: TIntegerField;
    cdsSicsOnLineTOTEM_BOTOES_MARGEM_INFERIOR: TIntegerField;
    cdsSicsOnLineTOTEM_BOTOES_MARGEM_DIREITA: TIntegerField;
    cdsSicsOnLineTOTEM_BOTOES_MARGEM_ESQUERDA: TIntegerField;
    cdsSicsOnLineTOTEM_BOTOES_ESPACO_COLUNAS: TIntegerField;
    cdsSicsOnLineTOTEM_BOTOES_ESPACO_LINHAS: TIntegerField;
    cdsSicsOnLineLINHAS_DE_FILAS: TIntegerField;
    cdsSicsOnLineTOTEM_PORTA_TCP: TIntegerField;
    cdsSicsOnLineTOTEM_IMAGEM_FUNDO: TStringField;
    cdsSicsOnLineTOTEM_PORTA_SERIAL_IMPRESSORA: TStringField;
    cdsSicsOnLineTOTEM_MOSTRAR_BOTAO_FECHAR: TStringField;
    cdsSicsOnLineTOTEM_BOTAO_FECHAR_TAM_MAIOR: TStringField;
    cdsSicsMultiPAMOSTRAR_MENU_PAUSA: TStringField;
    cdsSicsMultiPAGRUPOS_DE_PAUSAS_PERMITIDOS: TStringField;
    cdsSicsPAGRUPOS_DE_PAUSAS_PERMITIDOS: TStringField;
    cdsSicsOnLinePODE_FECHAR_PROGRAMA: TStringField;
    cdsSicsOnLineGRUPOS_ATENDENTES_PERMITIDOS: TStringField;
    cdsSicsOnLinePERMITIR_EXCLUSAO_NAS_FILAS: TStringField;
    cdsSicsPAMOSTRAR_BOTAO_PROCESSOS: TStringField;
    dscSicsTGS: TDataSource;
    cdsSicsTGS: TClientDataSet;
    dspSicsTGS: TDataSetProvider;
    qrySicsTGS: TFDQuery;
    cdsSicsTGSID: TIntegerField;
    cdsSicsTGSMINIMIZAR_PARA_BANDEJA: TStringField;
    cdsSicsTGSPODE_FECHAR_PROGRAMA: TStringField;
    cdsSicsTGSPODE_CONFIG_ATENDENTES: TStringField;
    cdsSicsTGSREPORTAR_TEMPOS_MAXIMOS: TStringField;
    cdsSicsTGSPODE_CONFIG_PRIORIDADES_ATEND: TStringField;
    cdsSicsTGSPODE_CONFIG_IND_DE_PERFORMANCE: TStringField;
    cdsSicsTGSGRUPOS_DE_ATENDENTES_PERMITIDOS: TStringField;
    cdsSicsTGSGRUPOS_DE_PAS_PERMITIDAS: TStringField;
    cdsSicsTGSGRUPOS_DE_TAGS_PERMITIDOS: TStringField;
    cdsSicsTGSGRUPOS_DE_MOTIVOS_DE_PAUSA_PERM: TStringField;
    cdsSicsTGSGRUPOS_INDICADORES_PERMITIDOS: TStringField;
    cdsSicsTGSVISUALIZAR_GRUPOS: TStringField;
    cdsSicsTGSVISUALIZAR_NOME_CLIENTES: TStringField;
    cdsConfiguracoesGerais: TClientDataSet;
    cdsConfiguracoesGeraisID: TStringField;
    dspConfiguracoesGerais: TDataSetProvider;
    cdsSicsPAMOSTRAR_MENU_PROCESSOS: TStringField;
    cdsSicsMultiPAMOSTRAR_MENU_PROCESSOS: TStringField;
    cdsSicsOnLineGRUPOS_PAS_PERMITIDAS: TStringField;
    cdsSicsOnLineGRUPOS_TAGS_PERMITIDAS: TStringField;
    cdsSicsOnLineVISUALIZAR_NOME_CLIENTES: TStringField;
    cdsSicsMultiPAPORTA_LDBC: TStringField;
    cdsSicsOnLinePERMITIR_REIMPRESSAO_NAS_FILAS: TStringField;
    cdsSicsPAMOSTRAR_NOME_ATENDENTE: TStringField;
    cdsSicsMultiPAMOSTRAR_NOME_ATENDENTE: TStringField;
    cdsSicsOnLineMOSTRAR_EXCLUIR_TODAS: TStringField;
    cdsTelasOnline: TClientDataSet;
    cdsTelasOnlineID: TIntegerField;
    cdsTelasOnlineNOME: TStringField;
    cdsSicsOnLineTELA_PADRAO: TIntegerField;
    dscTelasOnline: TDataSource;
    cdsTamanhoFonteOnline: TClientDataSet;
    dsTamanhoFonteOnline: TDataSource;
    cdsTamanhoFonteOnlineID: TIntegerField;
    cdsTamanhoFonteOnlineNOME: TStringField;
    cdsSicsOnLineTAMANHO_FONTE: TIntegerField;
    cdsMonitoramentosPITIPO: TSmallintField;
    qryQtdePIsSemFormatoHorario: TFDQuery;
    cdsPaineisClone: TClientDataSet;
    cdsPISClone: TClientDataSet;
    strngfldSicsPACONECTAR_VIA_DB: TStringField;
    strngfldSicsMultiPACONECTAR_VIA_DB: TStringField;
    qryInsertCampoAdicional: TFDQuery;
    qryCamposAdicionais: TFDQuery;
    qryDtHrEmissaoSenha: TFDQuery;
    qryDtHrEmissaoSenhaINICIO: TSQLTimeStampField;
    qryDeviceIdSenha: TFDQuery;
    cdsSicsPAMOSTRAR_CONTROLE_REMOTO: TStringField;
    cdsSicsPAGRUPOS_CONTROLE_REMOTO: TStringField;
    cdsSicsOnLineMOSTRA_TEMPO_DECORRIDO_ESPERA: TStringField;
    cdsSicsOnLineSITUACAOESPERA_LAYOUT: TIntegerField;
    cdsSicsOnLineSITUACAOESPERA_CORLAYOUT: TIntegerField;
    cdsLayoutsEsperaOnLine: TClientDataSet;
    IntegerField1: TIntegerField;
    StringField1: TStringField;
    dsLayoutsEsperaOnLine: TDataSource;
    cdsCorLimiarOnLine: TClientDataSet;
    IntegerField2: TIntegerField;
    StringField2: TStringField;
    dsCorLimiarOnLine: TDataSource;
    cdsEstiloLayoutsEsperaOnline: TClientDataSet;
    IntegerField3: TIntegerField;
    StringField3: TStringField;
    dsEstiloLayoutsEsperaOnline: TDataSource;
    qrySicsCallCenter: TFDQuery;
    dspSicsCallCenter: TDataSetProvider;
    cdsSicsCallCenter: TClientDataSet;
    IntegerField4: TIntegerField;
    IntegerField5: TIntegerField;
    dsSicsCallCenter: TDataSource;
    cdsSicsCallCenterLOGIN_WINDOWS: TStringField;
    qryClientesLogin: TFDQuery;
    qryAtendenteLogin: TFDQuery;
    qryClientesLoginID: TIntegerField;
    qryClientesLoginNOME: TStringField;
    qryClientesLoginLOGIN: TStringField;
    qryClientesLoginSENHALOGIN: TStringField;
    cdsSicsOnLineESTILOESPERA_LAYOUT: TIntegerField;
    cdsSicsOnLineMODO_CALL_CENTER: TStringField;
    cdsSicsTGSMODO_CALL_CENTER: TStringField;
    cdsConfiguracoesGeraisVALOR: TStringField;
    connRelatorio: TFDConnection;
    connUnidades: TFDConnection;
    connOnLine: TFDConnection;
    qryUnidades: TFDQuery;
    qryUnidadesID: TIntegerField;
    qryUnidadesNOME: TStringField;
    qryUnidadesDBDIR: TStringField;
    qryUnidadesIP: TStringField;
    qryUnidadesPORTA: TIntegerField;
    qryUnidadesPORTA_TGS: TIntegerField;
    qryUnidadesID_UNID_CLI: TStringField;
    qryUnidadesIDGRUPO: TIntegerField;
    qryUnidadesHOST: TStringField;
    qryUnidadesBANCO: TStringField;
    qryUnidadesUSUARIO: TStringField;
    qryUnidadesSENHA: TStringField;
    qryUnidadesOSAUTHENT: TStringField;
    qryContadoresDeFilas: TFDQuery;
    dspContadoresDeFilas: TDataSetProvider;
    qryContadoresDeFilasID: TIntegerField;
    qryContadoresDeFilasCONTADOR: TIntegerField;
    tmrAtualizaJornalTVs: TTimer;
    cdsGruposDePAsAtivos: TClientDataSet;
    cdsNN_PAs_Filas_SemFiltro: TClientDataSet;
    dspAux: TDataSetProvider;
    qryFilas: TFDQuery;
    dspFilas: TDataSetProvider;
    qryPAs: TFDQuery;
    dspPAs: TDataSetProvider;
    qryNN_PAs_Filas: TFDQuery;
    dspNN_PAs_Filas: TDataSetProvider;
    qryContadoresDeFilasID_UNIDADE: TIntegerField;
    cdsContadoresDeFilasID_UNIDADE: TIntegerField;
    cdsMonitoramentosID_UNIDADE: TIntegerField;
    cdsPisRelacionadosID_UNIDADE: TIntegerField;
    cdsPISID_UNIDADE: TIntegerField;
    qryClientesLoginID_UNIDADE: TIntegerField;
    cdsSicsTGSID_UNIDADE: TIntegerField;
    cdsModulosID_UNIDADE: TIntegerField;
    cdsSicsPAID_UNIDADE: TIntegerField;
    cdsSicsMultiPAID_UNIDADE: TIntegerField;
    cdsSicsOnLineID_UNIDADE: TIntegerField;
    cdsSicsCallCenterID_UNIDADE: TIntegerField;
    qryDtHrEmissaoSenhaID_UNIDADE: TIntegerField;
    qryDtHrEmissaoSenhaID: TIntegerField;
    qryGruposDeAtendentes: TFDQuery;
    qryAtendentes: TFDQuery;
    qryEmails: TFDQuery;
    qryCelulares: TFDQuery;
    qryTags: TFDQuery;
    qryGruposDeTags: TFDQuery;
    qryPISNiveis: TFDQuery;
    qryGruposDeMotivosPausa: TFDQuery;
    qryMotivosDePausa: TFDQuery;
    qryStatusDasPAs: TFDQuery;
    qryPPs: TFDQuery;
    dspGruposDeAtendentes: TDataSetProvider;
    dspAtendentes: TDataSetProvider;
    dspEmails: TDataSetProvider;
    dspCelulares: TDataSetProvider;
    dspTags: TDataSetProvider;
    dspGruposDeTags: TDataSetProvider;
    dspPISNiveis: TDataSetProvider;
    dspGruposDeMotivosPausa: TDataSetProvider;
    dspMotivosDePausa: TDataSetProvider;
    dspStatusDasPAs: TDataSetProvider;
    dspPPs: TDataSetProvider;
    qryGruposDePPs: TFDQuery;
    dspGruposDePPs: TDataSetProvider;
    qryPaineis: TFDQuery;
    dspPaineis: TDataSetProvider;
    qryGruposDePAs: TFDQuery;
    dspGruposDePAs: TDataSetProvider;
    qryGruposDePaineis: TFDQuery;
    dspGruposDePaineis: TDataSetProvider;
    qryConfiguracoesGerais: TFDQuery;
    qryNN_PAs_Filas_SemFiltro: TFDQuery;
    dspNN_PAs_Filas_SemFiltro: TDataSetProvider;
    cdsPASClone: TClientDataSet;
    cdsFilasClone: TClientDataSet;
    qryGrupoFila: TFDQuery;
    dspGrupoFila: TDataSetProvider;
    cdsGrupoFila: TClientDataSet;
    dsGrupoFila: TDataSource;
    qryCategoriaFilas: TFDQuery;
    dspCategoriaFilas: TDataSetProvider;
    cdsCategoriaFilas: TClientDataSet;
    dsCategoriaFilas: TDataSource;
    cdsSicsPAMOSTRAR_BOTAO_SEGUIRATENDIMENTO: TStringField;
    cdsSicsPAMOSTRAR_MENU_SEGUIRATENDIMENTO: TStringField;
    cdsSicsMultiPAMOSTRAR_BOTAO_SEGUIRATENDIMENTO: TStringField;
    cdsSicsMultiPAMOSTRAR_MENU_SEGUIRATENDIMENTO: TStringField;
    cdsSicsPACODIGOS_UNIDADES: TStringField;
    cdsSicsMultiPACODIGOS_UNIDADES: TStringField;
    cdsSicsPAID_UNIDADE_CLI: TIntegerField;
    cdsSicsMultiPAID_UNIDADE_CLI: TIntegerField;
    cdsSicsPAFILA_ESPERA_PROFISSIONAL: TIntegerField;
    cdsSicsMultiPAFILA_ESPERA_PROFISSIONAL: TIntegerField;
    cdsSicsMultiPAMOSTRAR_PAINEL_GRUPOS: TStringField;
    cdsSicsPAID_TAG_AUTOMATICA: TIntegerField;
    cdsSicsPAMARCAR_TAG_APOS_ATENDIMENTO: TStringField;
    cdsSicsMultiPAID_TAG_AUTOMATICA: TIntegerField;
    cdsSicsMultiPAMARCAR_TAG_APOS_ATENDIMENTO: TStringField;
    cdsSicsPAMOSTRAR_BOTAO_DADOS_ADICIONAIS: TStringField;
    cdsSicsPAGRUPOS_DE_TAGS_LAYOUT_BOTAO: TStringField;
    cdsSicsPAGRUPOS_DE_TAGS_LAYOUT_LISTA: TStringField;
    cdsSicsPAGRUPOS_DE_TAGS_SOMENTE_LEITURA: TStringField;
    cdsSicsMultiPAMOSTRAR_BOTAO_DADOS_ADICIONAIS: TStringField;
    cdsSicsMultiPAGRUPOS_DE_TAGS_LAYOUT_BOTAO: TStringField;
    cdsSicsMultiPAGRUPOS_DE_TAGS_LAYOUT_LISTA: TStringField;
    cdsSicsMultiPAGRUPOS_DE_TAGS_SOMENTE_LEITURA: TStringField;
    cdsSicsOnLineMOSTRAR_DADOS_ADICIONAIS: TStringField;
    qryAddModulos: TFDQuery;
    cdsAddModulos: TClientDataSet;
    cdsAddModulosID: TIntegerField;
    cdsAddModulosTIPO: TIntegerField;
    cdsAddModulosNOME: TStringField;
    dspAddModulos: TDataSetProvider;
    cdsAddPaineis: TClientDataSet;
    cdsAddPaineisID: TIntegerField;
    cdsAddPaineisTIPO: TIntegerField;
    cdsAddPaineisBACKGROUNDFILE: TStringField;
    cdsAddPaineisFONTE: TStringField;
    cdsAddPaineisARQUIVOSOM: TStringField;
    cdsAddPaineisFLASHFILE: TStringField;
    cdsAddPaineisCAMINHODOEXECUTAVEL: TStringField;
    cdsAddPaineisNOMEDAJANELA: TStringField;
    cdsAddPaineisRESOLUCAOPADRAO: TStringField;
    cdsAddPaineisARQUIVOSVIDEO: TStringField;
    cdsAddPaineisHOSTBANCO: TStringField;
    cdsAddPaineisPORTABANCO: TStringField;
    cdsAddPaineisNOMEARQUIVOBANCO: TStringField;
    cdsAddPaineisUSUARIOBANCO: TStringField;
    cdsAddPaineisSENHABANCO: TStringField;
    cdsAddPaineisDIRETORIOLOCAL: TStringField;
    cdsAddPaineisLAYOUTSENHAX: TIntegerField;
    cdsAddPaineisLAYOUTSENHAY: TIntegerField;
    cdsAddPaineisLAYOUTSENHALARG: TIntegerField;
    cdsAddPaineisLAYOUTSENHAALT: TIntegerField;
    cdsAddPaineisLAYOUTPAX: TIntegerField;
    cdsAddPaineisLAYOUTPAY: TIntegerField;
    cdsAddPaineisLAYOUTPALARG: TIntegerField;
    cdsAddPaineisLAYOUTPAALT: TIntegerField;
    cdsAddPaineisLAYOUTNOMECLIENTEX: TIntegerField;
    cdsAddPaineisLAYOUTNOMECLIENTEY: TIntegerField;
    cdsAddPaineisLAYOUTNOMECLIENTELARG: TIntegerField;
    cdsAddPaineisLAYOUTNOMECLIENTEALT: TIntegerField;
    cdsAddPaineisQUANTIDADE: TStringField;
    cdsAddPaineisATRASO: TStringField;
    cdsAddPaineisESPACAMENTO: TStringField;
    cdsAddPaineisPASPERMITIDAS: TStringField;
    cdsAddPaineisMARGEMSUPERIOR: TIntegerField;
    cdsAddPaineisMARGEMINFERIOR: TIntegerField;
    cdsAddPaineisMARGEMESQUERDA: TIntegerField;
    cdsAddPaineisMARGEMDIREITA: TIntegerField;
    cdsAddPaineisFORMATO: TStringField;
    cdsAddPaineisNOMEARQUIVOHTML: TStringField;
    cdsAddPaineisINDICADORSOMPI: TStringField;
    cdsAddPaineisARQUIVOSOMPI: TStringField;
    cdsAddPaineisLEFT: TIntegerField;
    cdsAddPaineisTOP: TIntegerField;
    cdsAddPaineisHEIGHT: TIntegerField;
    cdsAddPaineisCOLOR: TIntegerField;
    cdsAddPaineisFONTESIZE: TIntegerField;
    cdsAddPaineisFONTECOLOR: TIntegerField;
    cdsAddPaineisSOFTWAREHOMOLOGADO: TIntegerField;
    cdsAddPaineisDISPOSITIVO: TIntegerField;
    cdsAddPaineisRESOLUCAO: TIntegerField;
    cdsAddPaineisTEMPOALTERNANCIA: TIntegerField;
    cdsAddPaineisIDTVPLAYLISTMANAGER: TIntegerField;
    cdsAddPaineisTIPOBANCO: TIntegerField;
    cdsAddPaineisINTERVALOVERIFICACAO: TIntegerField;
    cdsAddPaineisLAYOUTSENHAALINHAMENTO: TIntegerField;
    cdsAddPaineisLAYOUTPAALINHAMENTO: TIntegerField;
    cdsAddPaineisLAYOUTNOMECLIENTEALINHAMENTO: TIntegerField;
    cdsAddPaineisSOMVOZCHAMADA0: TIntegerField;
    cdsAddPaineisSOMVOZCHAMADA1: TIntegerField;
    cdsAddPaineisSOMVOZCHAMADA2: TIntegerField;
    cdsAddPaineisVOICEINDEX: TIntegerField;
    cdsAddPaineisATUALIZACAOPLAYLIST: TDateField;
    cdsAddPaineisTRANSPARENT: TStringField;
    cdsAddPaineisNEGRITO: TStringField;
    cdsAddPaineisITALICO: TStringField;
    cdsAddPaineisSUBLINHADO: TStringField;
    cdsAddPaineisMOSTRARSENHA: TStringField;
    cdsAddPaineisMOSTRARPA: TStringField;
    cdsAddPaineisMOSTRARNOMECLIENTE: TStringField;
    cdsAddPaineisSOMARQUIVO: TStringField;
    cdsAddPaineisSOMVOZ: TStringField;
    cdsAddPaineisSOMVOZCHAMADA1MARCADO: TStringField;
    cdsAddPaineisSOMVOZCHAMADA2MARCADO: TStringField;
    cdsAddPaineisSOMVOZCHAMADA3MARCADO: TStringField;
    cdsAddPaineisDISPOSICAOLINHAS: TStringField;
    cdsAddPaineisVALORACOMPANHACORDONIVEL: TStringField;
    cdsAddPaineisID_MODULO_TV: TIntegerField;
    cdsAddPaineisccNOME: TStringField;
    dspAddPaineis: TDataSetProvider;
    qryAddPaineis: TFDQuery;
    cdsModuloTV: TClientDataSet;
    cdsModuloTVID: TIntegerField;
    cdsModuloTVCHAMADAINTERROMPEVIDEO: TStringField;
    cdsModuloTVMAXIMIZARMONITOR1: TStringField;
    cdsModuloTVMAXIMIZARMONITOR2: TStringField;
    cdsModuloTVFUNCIONASABADO: TStringField;
    cdsModuloTVFUNCIONADOMINGO: TStringField;
    cdsModuloTVUSECODEBAR: TStringField;
    cdsModuloTVIDPAINEL: TIntegerField;
    cdsModuloTVIDTV: TIntegerField;
    cdsModuloTVPORTAIPPAINEL: TIntegerField;
    cdsModuloTVLASTMUTE: TIntegerField;
    cdsModuloTVVOLUME: TIntegerField;
    cdsModuloTVDEM: TIntegerField;
    cdsModuloTVATEM: TIntegerField;
    cdsModuloTVCODEBARPORT: TStringField;
    cdsModuloTVINDICADORESPERMITIDOS: TStringField;
    cdsModuloTVDEH: TIntegerField;
    cdsModuloTVATEH: TIntegerField;
    qryModuloTV: TFDQuery;
    dspModuloTV: TDataSetProvider;
    dsSicsTV: TDataSource;
    cdsSicsTV: TClientDataSet;
    dspSicsTV: TDataSetProvider;
    qrySicsTV: TFDQuery;
    cdsModuloTVID_UNIDADE: TIntegerField;
    cdsAddPaineisID_UNIDADE: TIntegerField;
    cdsAddModulosID_UNIDADE: TIntegerField;
    cdsAddPaineisWIDTH: TIntegerField;
    connPIS: TFDConnection;
    procedure DataModuleCreate(Sender: TObject);
    procedure cdsAtendentesReconcileError(DataSet: TCustomClientDataSet; E: EReconcileError; UpdateKind: TUpdateKind; var Action: TReconcileAction);
    procedure cdsUnidadesAfterOpen(DataSet: TDataSet);
    procedure cdsGruposDeTagsAfterOpen(DataSet: TDataSet);
    procedure cdsPaineisAfterOpen(DataSet: TDataSet);
    procedure IntegerField4GetText(Sender: TField; var Text: string; DisplayText: boolean);
    procedure connOnLineRecover(ASender, AInitiator: TObject; AException: Exception; var AAction: TFDPhysConnectionRecoverAction);
    procedure connOnLineError(ASender, AInitiator: TObject; var AException: Exception);
    procedure connOnLineLost(Sender: TObject);
    procedure connOnLineRestored(Sender: TObject);
    procedure tmrAtualizaJornalTVsTimer(Sender: TObject);
    procedure connOnLineBeforeCommit(Sender: TObject);
    procedure connOnLineBeforeStartTransaction(Sender: TObject);
    procedure connOnLineAfterCommit(Sender: TObject);
    procedure connOnLineAfterStartTransaction(Sender: TObject);
    procedure connOnLineAfterRollback(Sender: TObject);
    procedure connOnLineBeforeRollback(Sender: TObject);
  private
    { Private declarations }
    FIsService: boolean;
    // FUnidades: TArrUnidades;
    FConnsRelatorios: TArrConnsRelatorios;

    procedure ExecutarScriptsBDUnidades;
  public
    { Public declarations }
    procedure CheckVersionBD;
    procedure InsereUnidade(AId: integer; const ANome, APathBaseOnLine, APathBaseRelatorios, AEnderecoIP: string; const APortaIP: integer);
    function GetID_MODULOS(AModuloSICS: TModuloSics): Integer;
    procedure SetSelectedItems(var LB: TListBox; s: string);
    function GetSelectedItems(LB: TListBox): string;
    function GetConnRelatorio(IdUnidade: integer): TFDConnection;

    function CheckPromptUnidade: integer;
    function CreateSqlConnUnidade(AOwner: TComponent; IdUnidade: integer): TFDConnection;
    procedure SetNewSqlConnectionForSQLDataSet(AOwner: TComponent; ANewSqlConnection: TFDConnection);

    procedure CarregaTabelasDM;
    procedure CarregaTabelasPAsEFilas;
    procedure CarregaTabelaAtendentes;
    procedure CarregaTabelaTags;
    procedure CarregaPPs;
    procedure CarregaMotivoPausas;
    procedure CarregaTotens;
    procedure CarregaCelulares;
    procedure CarregaEmails;
    procedure CarregaModulos;
    procedure CarregaGrupoFilas;
    procedure CarregaCategoriaFilas;

    procedure AtualizarTabelasPis;
    procedure AtualizarTabelaConfiguracoesGerais;
    procedure AtualizarTabelaClientes;
    procedure LimparNNPASFilasInativas;

    procedure DefinirCanalPadraoTV(IdTV: integer; Canal: integer);

    property IsService: boolean read FIsService write FIsService;
    procedure CriarCdsTelasOnline;
    procedure CriarCdsTamanhoFonteOnline;
    procedure CriarCdsLayoutEsperaOnline;
    procedure CriarCdsCorLimiarOnline;
    procedure CriarCdsEstiloLayoutEspera;

    procedure ConfigurarAtualizacaoJornalTV;
    procedure UpdateDadosJornalAPI;
    procedure AtualizarJornalTV(Sender: TObject); overload;
    procedure AtualizarJornalTV(APainel: integer); overload;

    function PICompostoSomentePorIndicadoresComFormatoHorario(AIdPI: integer): boolean;
    function SalvarDadosAdicionais(const ATicketId: integer; const AObj: TJSONObject; const ExcluirDadosAtuais: boolean = True): boolean;
    function GetDadosAdicionais(const ATicketId: integer): TJSONObject;
    function GetDataHoraEmissaoSenhaNoBD(const ATicketId: integer; const ADataHoraUltimaInteracao: TDateTime): TDateTime;
    function GetDeviceIdSenha(const ATicketId: integer): String;
    function SetDeviceIdSenha(const ATicketId: integer; const ADeviceId: String): boolean;
  end;

const
  PAINEL_INICIO_TEXTO_WS  = '{{Enviar Para Site - INÍCIO}}';
  PAINEL_FIM_TEXTO_WS     = '{{Enviar Para Site - FIM}}';

var
  vgParametrosModulo: TParametrosModulo_Servidor;
  dmSicsMain: TdmSicsMain;

function NGetPAData(IdPA: integer; var Ativo: boolean; var IdGrupoPA: integer; var PANome: string; var IdPainel: integer;
  var PANomeNoPainel, PANomePorVoz: string;
  var PAMagazine, PAAutoRedir: integer): boolean;
function NGetAtdData(IdAtd: integer; var Ativo: boolean; var IdGrupoAtend: integer; var AtdNome, AtdLogin, AtdSenhaLogin,
  AtdRegFunc: string): boolean;
function NGetPainelData(IdPainel: integer; var Nome, Endereco: string; var IdModelo: integer; var EnderecoIP: string;
  var ManterUltimaSenha, Monitoramento: boolean): boolean;
function NGetFilaData(IdFila: integer; var Ativo: boolean; var FilaNome: string;
  var IdGrupoFila: integer; var MostrarBotaoImprimeSenha, MostrarBloquear,
  MostrarPrioritaria: boolean; var RangeMinimo, RangeMaximo: integer): boolean;

function NGetPAName(IdPA: integer): string;
function NGetPAWhatsApp(IdPA: integer): Boolean;
function NGetAtdName(IdAtd: integer; const ParaRelatorio: boolean = False): string;
function NGetFilaName(IdFila: integer): string;
function NGetGrAtendName(IdGrAtend: integer): string;
function NGetGrPAName(IdGrPA: integer): string;
function NGetUnidadeName(IdUnidade: integer): string;
function NGetTagName(IdTag: integer): string;

function NGetPAId(NomePA: string): integer;
function NGetFilaId(NomeFila: string): integer;

function NGetIdGrAtend(IdAtend: integer; const DataSet: TClientDataSet = nil): integer;
function NGetIdGrPA(IdPA: integer; const DataSet: TClientDataSet = nil): integer;

function NGetRangeMaximo(IdFila: integer): integer;
function NGetRangeMinimo(IdFila: integer): integer;
function NGetFilaFromRange(TicketNo: integer; const DataSet: TClientDataSet = nil): integer;

function NGetMotivoDePausaName(IDMotivo: integer): string;
function NGetAtdLogin(IdAtd: integer): string;
function NGetAtdId(LoginAtd: string): integer;

function NGetCurrentGenerator(GeneratorName: string): integer; deprecated 'Use TGenerator.NGetCurrentGenerator';
function NGetNextGenerator(GeneratorName: string; ANewSqlConnection: TFDConnection = nil): integer; deprecated 'Use TGenerator.NGetNextGenerator';

function NGetEmailAddressesList(IdsList: string): string;

function NGetPainelMsg(IdPainel: integer; var Msg: string): boolean;
function NSetPainelMsg(IdPainel: integer; Msg: string): boolean;
function NGetPrinterMsg(IdPrinter: integer; var Msg: string): boolean;
function NSetPrinterMsg(IdPrinter: integer; Msg: string): boolean;

function NGetNomeDaFilaNoTicket(IdFila: integer): string;
function NGetGerarSenhaAutomaticamente(IdFila: integer): boolean;

function OrdemDasFilasToStr(PA: integer): string;

function GetModuleTypeByID(AConexao: TFDConnection; AIdModulo: integer): TModuloSics;
function GetNomeTabelaDoModulo(const aTipoModulo: TModuloSics): String;
function GetNomeColunaTipoGrupoPorModulo(Const aTipoModulo: TModuloSics; const aTipoDeGrupo: TTipoDeGrupo): string;
function GetNomeColunaTipoGrupoPA(Const aTipoDeGrupoPA: TTipoDeGrupoPA): string;
function GetNomeColunaTipoGrupoMPA(Const aTipoDeGrupoMPA: TTipoDeGrupoMPA): string;
function GetNomeColunaTipoGrupoOnLine(Const aTipoDeGrupoOnLine: TTipoDeGrupoOnLine): string;
function GetNomeColunaTipoGrupoTGS(Const aTipoDeGrupoTGS: TTipoDeGrupo): string;
function GetListaIDPermitidosDoGrupo(AConexao: TFDConnection; const aNomeTabela, aNomeCampo: String; const AIdModulo: integer): TIntArray;
function GetListaIDPermitidosDoGrupoPA(AConexao: TFDConnection; const aNomeTabela, aNomeCampo: String; const AIdModulo: integer): TIntArray;
function GetFilterPorRangerID(const aRangeIDs: TIntArray; const aColuna: String = 'ID'): string;

function GetIdPA(AConexao: TFDConnection; AIdModulo: integer): integer;
function GetIdModulo(AConexao: TFDConnection; PA: integer): integer; // LM

implementation

{$R *.dfm}

uses
  ASPGenerator,
  System.Math
{$IF Defined(CompilarPara_CONFIG) }
    , untMainForm
{$ENDIF}
{$IF (not Defined(CompilarPara_CONFIG)) and (not Defined(CompilarPara_SCC)) )}
  , udmContingencia,
  uFuncoes,
  sics_dm,
  sics_m,
  ufrmDebugParameters,
  uTempoUnidade,
  System.Win.ScktComp
{$ENDIF}
  ;

function TdmSicsMain.PICompostoSomentePorIndicadoresComFormatoHorario(AIdPI: integer): boolean;
begin
  try
    qryQtdePIsSemFormatoHorario.Close;
    try
      qryQtdePIsSemFormatoHorario.ParamByName('ID_PI').AsInteger := AIdPI;
      qryQtdePIsSemFormatoHorario.Open;
      result := qryQtdePIsSemFormatoHorario.Fields[0].AsInteger = 0;
    finally
      qryQtdePIsSemFormatoHorario.Close;
    end;
  except
    result := False;
  end;
end;

procedure TdmSicsMain.SetSelectedItems(var LB: TListBox; s: string);
var
  i, j: integer;
  aux: string;
begin
  aux              := '';
  for j            := 0 to LB.Items.Count - 1 do
  begin
    LB.Selected[j] := False;
  end;

  for i            := 1 to length(s) do
  begin
    if s[i] = ';' then
    begin
      if (Pos('-', aux) <= 0) then
      begin
        if (strtoint(aux) < LB.Items.Count) then
          LB.Selected[strtoint(aux)] := True;
      end
      else
        for j := strtoint(Copy(aux, 1, Pos('-', aux) - 1))
          to strtoint(Copy(aux, Pos('-', aux) + 1, length(aux) - Pos('-', aux))) do
          if j < LB.Items.Count then
            LB.Selected[j] := True;

      aux := '';
    end
    else
      aux := aux + s[i];
  end;

  if aux <> '' then
  begin
    if (Pos('-', aux) <= 0) then
    begin
      if (strtoint(aux) < LB.Items.Count) then
        LB.Selected[strtoint(aux)] := True
    end
    else
      for j := strtoint(Copy(aux, 1, Pos('-', aux) - 1))
        to strtoint(Copy(aux, Pos('-', aux) + 1, length(aux) - Pos('-', aux))) do
        if j < LB.Items.Count then
          LB.Selected[j] := True;
  end;
end;

procedure TdmSicsMain.tmrAtualizaJornalTVsTimer(Sender: TObject);
begin
{$IF (not Defined(CompilarPara_CONFIG)) and (not Defined(CompilarPara_SCC))}
  TfrmDebugParameters.Debugar(tbJornalEletronico, 'Início do Timer AtualizaJornalTV');
  tmrAtualizaJornalTVs.Enabled := False;
  UpdateDadosJornalAPI;
{$ENDIF}
end;

procedure TdmSicsMain.UpdateDadosJornalAPI;
{$IF (not Defined(CompilarPara_CONFIG)) and (not Defined(CompilarPara_SCC))}
var
  LThread: TThread;
  LSucesso: Boolean;
{$ENDIF}
begin
{$IF (not Defined(CompilarPara_CONFIG)) and (not Defined(CompilarPara_SCC))}
  if (vgParametrosModulo.UrlApi.Trim.IsEmpty) or (vgParametrosModulo.NomeUnidadeApi.Trim.IsEmpty) then
  begin
    Exit;
  end;

  LThread := TThread.CreateAnonymousThread(
    procedure
    begin
      TThread.Synchronize(nil,
        procedure
        begin
          TfrmDebugParameters.Debugar(tbJornalEletronico, 'Início Get API ' + vgParametrosModulo.UrlApi);
        end);

      LSucesso := TTempoUnidadeManager.UpdateTags(vgParametrosModulo.UrlApi, vgParametrosModulo.NomeUnidadeApi, vgParametrosModulo.Especialidades);

      TThread.Synchronize(nil,
        procedure
        begin
          tmrAtualizaJornalTVs.Interval := IfThen(LSucesso, tmrAtualizaJornalTVs.Tag, 30000);

          TfrmDebugParameters.Debugar(tbJornalEletronico, 'Fim Get API ' + vgParametrosModulo.UrlApi);
        end);
    end);

  LThread.OnTerminate := AtualizarJornalTV;

  LThread.Start;
{$ENDIF}
end;

function TdmSicsMain.GetSelectedItems(LB: TListBox): string;
var
  i, j: integer;
begin
  result := '';

  try
    i := 0;
    while i < LB.Items.Count do
    begin
      if LB.Selected[i] then
      begin
        j := i + 1;
        while j < LB.Items.Count do
        begin
          if not LB.Selected[j] then
            break;
          j := j + 1;
        end;

        if ((i = j - 1) or (not LB.Selected[j - 1])) then
          result := result + inttostr(i) + ';'
        else
          result := result + inttostr(i) + '-' + inttostr(j - 1) + ';';

        i := j;
      end;
      i := i + 1;
    end;

    result := Copy(result, 1, length(result) - 1); // Extrai o ponto-e-virgula
  except
    result := ''
  end;
end;

// ==============================================================================

function TdmSicsMain.GetConnRelatorio(IdUnidade: integer): TFDConnection;
begin
  if not cdsUnidadesClone.Locate('ID', IdUnidade, []) then
    raise Exception.Create('Unidade ' + inttostr(IdUnidade) + ' nao localizada');

  result := FConnsRelatorios[cdsUnidadesClone.FieldByName('IDX_CONN_RELATORIO').AsInteger];
end;

procedure TdmSicsMain.CarregaTabelasDM;
begin
  CarregaTabelasPAsEFilas;

  AbrirCDS(cdsGruposDePaineis);
  AbrirCDS(cdsPaineis);
  AbrirCDS(cdsGruposDePAs);

  // LM
  cdsGruposDePAsAtivos.CloneCursor(cdsGruposDePAs, True);

  AbrirCDS(cdsGruposDeAtendentes);

  CarregaTabelaAtendentes;

  AbrirCDS(cdsEmails);
  AbrirCDS(cdsCelulares);
  AbrirCDS(cdsTags);
  AbrirCDS(cdsGruposDeTags);
  AbrirCDS(cdsPISNiveis);
  AbrirCDS(cdsGruposDePPs);
  AbrirCDS(cdsPPs);
  AbrirCDS(cdsGruposDeMotivosPausa);
  AbrirCDS(cdsMotivosDePausa);
  AbrirCDS(cdsStatusDasPAs);

  AbrirCDS(cdsPIS);
  AbrirCDS(cdsPisRelacionados);
  AbrirCDS(cdsMonitoramentos);
  AbrirCDS(cdsAlarmes);
  AbrirCDS(cdsIdsRelacionados);
  AbrirCDS(cdsHorarios);
  AbrirCDS(cdsTVsCanais, True);
  // ** Configurações Módulos - GOT 14.10.2014 *****************************************************
  AbrirCDS(cdsModulos, True);
end;

procedure TdmSicsMain.CarregaTabelasPAsEFilas;
begin
  cdsFilas.Close;
  cdsFilas.Open;
  cdsFilas.LogChanges := false;

  cdsPAs.Close;
  cdsPAs.Open;
  cdsPAs.LogChanges := false;

  cdsNN_PAs_Filas.Close;
  cdsNN_PAs_Filas.Open;
  cdsNN_PAs_Filas.LogChanges := false;

  cdsNN_PAs_Filas_SemFiltro.Close;
  cdsNN_PAs_Filas_SemFiltro.Open;
  cdsNN_PAs_Filas_SemFiltro.LogChanges := false;

  {$IFDEF CompilarPara_SICS}
  if Assigned(dmSicsServidor) then
    dmSicsServidor.CarregarFilasComChamadaAutomatica;
  {$ENDIF CompilarPara_SICS}
end;

procedure TdmSicsMain.CarregaTabelaTags;
begin
  cdsGruposDeTags.Close;
  cdsGruposDeTags.Open;
  cdsGruposDeTags.LogChanges := False;

  cdsTags.Close;
  cdsTags.Open;
  cdsTags.LogChanges := False;
end;

procedure TdmSicsMain.CarregaTotens;
begin
  cdsTotens.Close;
  cdsTotens.Open;
  cdsTotens.LogChanges := False;
end;

procedure TdmSicsMain.CarregaCelulares;
begin
  cdsCelulares.Close;
  cdsCelulares.Open;
  cdsCelulares.LogChanges := False;
end;

procedure TdmSicsMain.CarregaEmails;
begin
  cdsEmails.Close;
  cdsEmails.Open;
  cdsEmails.LogChanges := False;
end;

procedure TdmSicsMain.CarregaModulos;
begin
  cdsModulos.Close;
  cdsModulos.Open;
  cdsModulos.LogChanges := False;
end;

procedure TdmSicsMain.CarregaGrupoFilas;
begin
  cdsGrupoFila.Close;
  cdsGrupoFila.Open;
  cdsGrupoFila.LogChanges := False;
end;

procedure TdmSicsMain.CarregaCategoriaFilas;
begin
  cdsCategoriaFilas.Close;
  cdsCategoriaFilas.Open;
  cdsCategoriaFilas.LogChanges := False;
end;

procedure TdmSicsMain.CarregaMotivoPausas;
begin
  cdsGruposDeMotivosPausa.Close;
  cdsGruposDeMotivosPausa.Open;
  cdsGruposDeMotivosPausa.LogChanges := False;

  cdsMotivosDePausa.Close;
  cdsMotivosDePausa.Open;
  cdsMotivosDePausa.LogChanges := False;
end;

procedure TdmSicsMain.CarregaPPs;
begin
  cdsGruposDePPs.Close;
  cdsGruposDePPs.Open;
  cdsGruposDePPs.LogChanges := False;

  cdsPPs.Close;
  cdsPPs.Open;
  cdsPPs.LogChanges := False;
end;

procedure TdmSicsMain.CarregaTabelaAtendentes;
begin
  cdsAtendentes.Close;
  cdsAtendentes.Open;
  cdsAtendentes.LogChanges := False;
end;

procedure TdmSicsMain.AtualizarTabelasPis;
begin
  cdsPIS.Refresh;
  cdsPisRelacionados.Refresh;
  cdsMonitoramentos.Refresh;
  cdsAlarmes.Refresh;
  cdsIdsRelacionados.Refresh;
  cdsHorarios.Refresh;
end;

procedure TdmSicsMain.AtualizarTabelaConfiguracoesGerais;
begin
  with cdsConfiguracoesGerais do
  begin
    if not Active then
      Open;

    Refresh;
  end;
end;

procedure TdmSicsMain.AtualizarJornalTV(Sender: TObject);
begin
  AtualizarJornalTV(TODOS_OS_PAINEIS);
end;

procedure TdmSicsMain.AtualizarJornalTV(APainel: integer);
var
  LIdPainel: integer;
  LTextoJornal: String;
  LcdsPaineisClone: TClientDataSet;
  LTextChanged: boolean;
begin
  {$IF (not Defined(CompilarPara_CONFIG)) and (not Defined(CompilarPara_SCC))}
  TfrmDebugParameters.Debugar(tbJornalEletronico, 'Início AtualizarJornalTV');
  try
    LcdsPaineisClone := TClientDataSet.Create(Self);
    try
      LcdsPaineisClone.XMLData := cdsPaineis.XMLData;

      LcdsPaineisClone.First;

      while not LcdsPaineisClone.Eof do
      begin
        if (APainel = TODOS_OS_PAINEIS) or (APainel = LcdsPaineisClone.FieldByName('ID').AsInteger) then
        begin
          LIdPainel := LcdsPaineisClone.FieldByName('ID').AsInteger;

          LTextoJornal := LcdsPaineisClone.FieldByName('Mensagem').AsString;
          frmSicsMain.SubstituirTagsDePIs(LTextoJornal);

          LTextChanged := TTempoUnidadeManager.SubstituirTags(LTextoJornal);

          if (LTextChanged) or (APainel <> TODOS_OS_PAINEIS) then
          begin
            TfrmDebugParameters.Debugar(tbJornalEletronico, 'Texto enviado para Painel ' + LIdPainel.ToString + ': ' + LTextoJornal);

            frmSicsMain.WriteToDisplay(LIdPainel, TAspEncode.AspIntToHex(LIdPainel, 4) + Chr($2B) + TAspEncode.AspIntToHex(LIdPainel, 4) + LTextoJornal);
          end;
        end;

        LcdsPaineisClone.Next;
      end;
    finally
      LcdsPaineisClone.Free;
    end;
  finally
    tmrAtualizaJornalTVs.Enabled  := True;
  end;

  TfrmDebugParameters.Debugar(tbJornalEletronico, 'AtualizarJornalTV');
{$ENDIF}
end;

procedure TdmSicsMain.AtualizarTabelaClientes;
begin
  // Atualmente o sevidor não mantém lista de clientes em memória.
end;

// ==============================================================================

function NGetPAData(IdPA: integer; var Ativo: boolean; var IdGrupoPA: integer;
var PANome: string; var IdPainel: integer;
var PANomeNoPainel, PANomePorVoz: string;
var PAMagazine, PAAutoRedir: integer): boolean;
var
  BM: TBookMark;
begin
  with dmSicsMain.cdsPAs do
  begin
    BM := GetBookmark;
    try
      try
        if Locate('ID', IdPA, []) then
        begin
          Ativo          := FieldByName('ATIVO').AsBoolean;
          IdGrupoPA      := FieldByName('ID_GRUPOPA').AsInteger;
          PANome         := FieldByName('NOME').AsString;
          IdPainel       := FieldByName('ID_PAINEL').AsInteger;
          PANomeNoPainel := FieldByName('NOMENOPAINEL').AsString;
          PANomePorVoz   := FieldByName('NOMEPORVOZ').AsString;
          PAMagazine     := FieldByName('MAGAZINE').AsInteger;
          PAAutoRedir    := FieldByName('ID_FILAAUTOENCAMINHA').AsInteger;
          result := True;
        end
        else
        begin
          Ativo          := False;
          IdGrupoPA      := 0;
          PANome         := '';
          IdPainel       := 0;
          PANomeNoPainel := '';
          PANomePorVoz   := '';
          PAMagazine     := 0;
          PAAutoRedir    := 0;
          result := False;
        end;
      except
        result := False;
      end; { try .. except }
    finally
      GotoBookmark(BM);
      FreeBookmark(BM);
    end;
  end; { with cds }
end;   { func GetPAData }

function NGetAtdData(IdAtd: integer; var Ativo: boolean; var IdGrupoAtend: integer; var AtdNome, AtdLogin, AtdSenhaLogin, AtdRegFunc: string): boolean;
var
  BM: TBookMark;
begin
  with dmSicsMain.cdsAtendentes do
  begin
    BM := GetBookmark;
    try
      try
        if Locate('ID', IdAtd, []) then
        begin
          Ativo         := FieldByName('ATIVO').AsBoolean;
          IdGrupoAtend  := FieldByName('ID_GRUPOATENDENTE').AsInteger;
          AtdNome       := FieldByName('NOME').AsString;
          AtdLogin      := FieldByName('LOGIN').AsString;
          AtdSenhaLogin := FieldByName('SENHALOGIN').AsString;
          AtdRegFunc    := FieldByName('REGISTROFUNCIONAL').AsString;
          // REMAPEAMENTO DE CAMPOS -> NOVOS CAMPOS DE ATENDENTE?
          result := True;
        end
        else
        begin
          IdGrupoAtend  := 0;
          AtdNome       := '';
          AtdLogin      := '';
          AtdSenhaLogin := '';
          AtdRegFunc    := '';
          result := False;
        end;
      except
        result := False;
      end; { try .. except }
    finally
      GotoBookmark(BM);
      FreeBookmark(BM);
    end;
  end; { with cds }
end;   { func GetAtdData }

function NGetPainelData(IdPainel: integer; var Nome, Endereco: string;
var IdModelo: integer; var EnderecoIP: string;
var ManterUltimaSenha, Monitoramento: boolean): boolean;
var
  BM: TBookMark;
begin
  with dmSicsMain.cdsPaineis do
  begin
    BM := GetBookmark;
    try
      try
        if Locate('ID', IdPainel, []) then
        begin
          Nome              := FieldByName('Nome').AsString;
          Endereco          := FieldByName('EnderecoSerial').AsString;
          IdModelo          := FieldByName('ID_MODELOPAINEL').AsInteger;
          EnderecoIP        := FieldByName('TcpIp').AsString;
          ManterUltimaSenha := FieldByName('ManterUltimaSenha').AsBoolean;
          Monitoramento     := FieldByName('Monitoramento').AsBoolean;
          result := True;
        end
        else
        begin
          Nome              := '';
          Endereco          := '';
          IdModelo          := -1;
          EnderecoIP        := '';
          ManterUltimaSenha := False;
          Monitoramento     := False;
          result := False;
        end;
      except
        result := False;
      end; { try .. except }
    finally
      GotoBookmark(BM);
      FreeBookmark(BM);
    end;
  end; { with cds }
end;   { func GetPainelData }

function NGetFilaData(IdFila: integer; var Ativo: boolean; var FilaNome: string;
var IdGrupoFila: integer; var MostrarBotaoImprimeSenha, MostrarBloquear,
  MostrarPrioritaria: boolean; var RangeMinimo, RangeMaximo: integer): boolean;
var
  BM: TBookMark;
begin
  with dmSicsMain.cdsFilas do
  begin
    BM := GetBookmark;
    try
      try
        if Locate('ID', IdFila, []) then
        begin
          Ativo                    := FieldByName('Ativo').AsBoolean;
          FilaNome                 := FieldByName('Nome').AsString;
          RangeMinimo              := FieldByName('RangeMinimo').AsInteger;
          RangeMaximo              := FieldByName('RangeMaximo').AsInteger;
          IdGrupoFila              := 0;
          MostrarBotaoImprimeSenha := True;
          MostrarBloquear := True;
          MostrarPrioritaria := True;
          result := True;
        end
        else
        begin
          FilaNome                 := '';
          IdGrupoFila              := 0;
          MostrarBotaoImprimeSenha := True;
          MostrarBloquear := True;
          MostrarPrioritaria := True;
          RangeMinimo              := 0;
          RangeMaximo              := 0;
          result := False;
        end;
      except
        result := False;
      end; { try .. except }
    finally
      GotoBookmark(BM);
      FreeBookmark(BM);
    end;
  end; { with cds }
end;   { func GetFilaData }

function NGetPAName(IdPA: integer): string;
var
  BM: TBookMark;
begin
  with dmSicsMain.cdsPAs do
  begin
    BM := GetBookmark;
    try
      result := '';
      try
        if Locate('ID', IdPA, []) then
          result := FieldByName('NOME').AsString;
      except
        result := '';
      end;
    finally
      GotoBookmark(BM);
      FreeBookmark(BM);
    end;
  end; { with cds }
end;

function NGetPAWhatsApp(IdPA: integer): Boolean;
var
  BM: TBookMark;
begin
  with dmSicsMain.cdsPAs do
  begin
    BM := GetBookmark;
    try
      result := False;
      try
        if Locate('ID', IdPA, []) then
          result := FieldByName('WHATSAPP').AsBoolean;
      except
        result := False;
      end;
    finally
      GotoBookmark(BM);
      FreeBookmark(BM);
    end;
  end; { with cds }
end;

function NGetAtdName(IdAtd: integer; const ParaRelatorio: boolean = False): string;
var
  BM: TBookMark;
begin
  with dmSicsMain.cdsAtendentes do
  begin
    BM := GetBookmark;
    try
      result := '';
      try
        if Locate('ID', IdAtd, []) then
          result := FieldByName('NOME').AsString;
        if (ParaRelatorio) and (FieldByName('NOMERELATORIO').AsString <> '') then
          result := FieldByName('NOMERELATORIO').AsString;
      except
        result := '';
      end;
    finally
      GotoBookmark(BM);
      FreeBookmark(BM);
    end;
  end; { with cds }
end;

function NGetFilaName(IdFila: integer): string;
var
  BM: TBookMark;
begin
  with dmSicsMain.cdsFilas do
  begin
    BM := GetBookmark;
    try
      result := '';
      try
        if Locate('ID', IdFila, []) then
          result := FieldByName('NOME').AsString;
      except
        result := '';
      end; { try .. except }
    finally
      GotoBookmark(BM);
      FreeBookmark(BM);
    end;
  end; { with cds }
end;

function NGetFilaId(NomeFila: string): integer;
var
  BM: TBookMark;
begin
  with dmSicsMain.cdsFilas do
  begin
    BM := GetBookmark;
    try
      result := 0;
      try
        if Locate('NOME', NomeFila, []) then
          result := FieldByName('ID').AsInteger;
      except
        result := 0;
      end; { try .. except }
    finally
      GotoBookmark(BM);
      FreeBookmark(BM);
    end;
  end; { with cds }
end;

function NGetGrAtendName(IdGrAtend: integer): string;
var
  BM: TBookMark;
begin
  with dmSicsMain.cdsGruposDeAtendentes do
  begin
    BM := GetBookmark;
    try
      result := '';
      try
        if Locate('ID', IdGrAtend, []) then
          result := FieldByName('NOME').AsString;
      except
        result := '';
      end; { try .. except }
    finally
      GotoBookmark(BM);
      FreeBookmark(BM);
    end;
  end; { with cds }
end;

function NGetGrPAName(IdGrPA: integer): string;
var
  BM: TBookMark;
begin
  with dmSicsMain.cdsGruposDePAs do
  begin
    BM := GetBookmark;
    try
      result := '';
      try
        if Locate('ID', IdGrPA, []) then
          result := FieldByName('NOME').AsString;
      except
        result := '';
      end; { try .. except }
    finally
      GotoBookmark(BM);
      FreeBookmark(BM);
    end;
  end; { with cds }
end;

function NGetUnidadeName(IdUnidade: integer): string;
var
  BM: TBookMark;
begin
  with dmSicsMain.cdsUnidades do
  begin
    BM := GetBookmark;
    try
      result := '';
      try
        if Locate('ID', IdUnidade, []) then
          result := FieldByName('NOME').AsString;
      except
        result := '';
      end; { try .. except }
    finally
      GotoBookmark(BM);
      FreeBookmark(BM);
    end;
  end; { with cds }
end;

function NGetTagName(IdTag: integer): string;
var
  BM: TBookMark;
begin
  with dmSicsMain.cdsTags do
  begin
    BM := GetBookmark;
    try
      result := '';
      try
        if Locate('ID', IdTag, []) then
          result := FieldByName('NOME').AsString;
      except
        result := '';
      end; { try .. except }
    finally
      GotoBookmark(BM);
      FreeBookmark(BM);
    end;
  end; { with cds }
end;

function NGetPAId(NomePA: string): integer;
var
  BM: TBookMark;
begin
  with dmSicsMain.cdsPAs do
  begin
    BM := GetBookmark;
    try
      result := -1;
      try
        if Locate('NOME', NomePA, []) then
          result := FieldByName('ID').AsInteger;
      except
        result := -1;
      end; { try .. except }
    finally
      GotoBookmark(BM);
      FreeBookmark(BM);
    end;
  end; { with cds }
end;

function NGetIdGrAtend(IdAtend: integer; const DataSet: TClientDataSet = nil): integer;
var
  BM: TBookMark;
  DsLocal: TClientDataSet;
begin
  if DataSet = nil then
    DsLocal := dmSicsMain.cdsAtendentes
  else
    DsLocal := DataSet;

  with DsLocal do
  begin
    BM := GetBookmark;
    try
      result := -1;
      try
        if Locate('ID', IdAtend, []) then
          result := FieldByName('ID_GRUPOATENDENTE').AsInteger;
      except
        result := -1;
      end; { try .. except }
    finally
      GotoBookmark(BM);
      FreeBookmark(BM);
    end;
  end; { with cds }
end;

function NGetIdGrPA(IdPA: integer; const DataSet: TClientDataSet = nil): integer;
var
  BM: TBookMark;
  DsLocal: TClientDataSet;
begin
  if DataSet = nil then
    DsLocal := dmSicsMain.cdsPAs
  else
    DsLocal := DataSet;

  with DsLocal do
  begin
    BM := GetBookmark;
    try
      result := -1;
      try
        if Locate('ID', IdPA, []) then
          result := FieldByName('ID_GRUPOPA').AsInteger;
      except
        result := -1;
      end; { try .. except }
    finally
      GotoBookmark(BM);
      FreeBookmark(BM);
    end;
  end; { with cds }
end;

function NGetRangeMaximo(IdFila: integer): integer;
var
  BM: TBookMark;
begin
  with dmSicsMain.cdsFilas do
  begin
    BM := GetBookmark;
    try
      result := -1;
      try
        if Locate('ID', IdFila, []) then
          result := FieldByName('RANGEMAXIMO').AsInteger;
      except
        result := -1;
      end;
    finally
      GotoBookmark(BM);
      FreeBookmark(BM);
    end;
  end; { with cds }
end;

function NGetRangeMinimo(IdFila: integer): integer;
var
  BM: TBookMark;
begin
  with dmSicsMain.cdsFilas do
  begin
    BM := GetBookmark;
    try
      result := -1;
      try
        if Locate('ID', IdFila, []) then
          result := FieldByName('RANGEMINIMO').AsInteger;
      except
        result := -1;
      end;
    finally
      GotoBookmark(BM);
      FreeBookmark(BM);
    end;
  end; { with cds }
end;

function NGetFilaFromRange(TicketNo: integer; const DataSet: TClientDataSet = nil): integer;
var
  BM: TBookMark;
  DsLocal: TClientDataSet;
begin
  if DataSet = nil then
    DsLocal := dmSicsMain.cdsFilas
  else
    DsLocal := DataSet;

  with DsLocal do
  begin
    BM := GetBookmark;
    try
      result := -1;
      try
        First;
        while not Eof do
        begin
          if ((TicketNo >= FieldByName('RANGEMINIMO').AsInteger) and (TicketNo <= FieldByName('RANGEMAXIMO').AsInteger)) then
          begin
            result := FieldByName('ID').AsInteger;
            break;
          end; { if TicketNo between RangeMinimo e RangeMaximo }
          Next;
        end;
      except
        result := -1;
      end;
    finally
      GotoBookmark(BM);
      FreeBookmark(BM);
    end;
  end; // with cds
end;

function NGetMotivoDePausaName(IDMotivo: integer): string;
var
  vNomeTabela: string;
  LSQLQuery: TFDQuery;
begin
  result := EmptyStr;

  vNomeTabela := 'MOTIVOS_PAUSA';
  LSQLQuery := TFDQuery.Create(nil);
  try
    LSQLQuery.Connection := dmSicsMain.connOnLine;
    LSQLQuery.SQL.Text := Format('SELECT NOME FROM %s WHERE ID_UNIDADE = %d AND ID = %d', [vNomeTabela, vgParametrosModulo.IdUnidade, IDMotivo]);
    LSQLQuery.Open;
    result := LSQLQuery.Fields[0].AsString;
  finally
    FreeAndNil(LSQLQuery);
  end;
end;

function NGetAtdLogin(IdAtd: integer): string;
var
  BM: TBookMark;
begin
  BM := dmSicsMain.cdsAtendentes.GetBookmark;
  try
    result := EmptyStr;
    try
      if dmSicsMain.cdsAtendentes.Locate('ID', IdAtd, []) then
        result := dmSicsMain.cdsAtendentes.FieldByName('LOGIN').AsString;
    except
      result := EmptyStr;
    end;
  finally
    dmSicsMain.cdsAtendentes.GotoBookmark(BM);
    dmSicsMain.cdsAtendentes.FreeBookmark(BM);
  end;
end;

function NGetAtdId(LoginAtd: string): integer;
var
  BM: TBookMark;
begin
  BM := dmSicsMain.cdsAtendentes.GetBookmark;
  try
    result := -1;
    try
      if dmSicsMain.cdsAtendentes.Locate('LOGIN', LoginAtd, [loCaseInsensitive]) then
        result := dmSicsMain.cdsAtendentes.FieldByName('ID').AsInteger;
    except
      result := -1;
    end;
  finally
    dmSicsMain.cdsAtendentes.GotoBookmark(BM);
    dmSicsMain.cdsAtendentes.FreeBookmark(BM);
  end;
end;

function NGetCurrentGenerator(GeneratorName: string): integer;
begin
  {
  with dmSicsMain.qryGeneratorGenerico do
  begin
    Close;
    SQL.Clear;
    SQL.Add(Format(cSELECT_NEXT_GEN, [GeneratorName, 0]));
    Open;
    Result := FieldByName('ID').AsInteger;
    Close;
  end;
  }

  result := TGenerator.NGetCurrentGenerator(GeneratorName, dmSicsMain.connOnLine);
end;

function NGetNextGenerator(GeneratorName: string; ANewSqlConnection: TFDConnection = nil): integer;
begin
  (* RA
  // edu - tive que criar o objeto ao inves de aproveitar o qryGeneratorGenerico
  // pois agora pode passar como parametro outro sqlconnection,
  // e em alguns momentos quando trocava de sqlconnection dava Access Violation
  with TFDQuery.Create(nil) do
    try
      if ANewSqlConnection <> nil then
        Connection := ANewSqlConnection
      else
        Connection := dmSicsMain.connOnLine;
      SQL.Text        := Format(cSELECT_NEXT_GEN, [GeneratorName, 1]);
      Open;
      try
        Result := FieldByName('ID').AsInteger;
      finally
        Close;
      end;
    finally
      Free;
    end;
  *)

  if ANewSqlConnection = nil then
  begin
    ANewSqlConnection := dmSicsMain.connOnLine;
  end;

  result := TGenerator.NGetNextGenerator(GeneratorName, ANewSqlConnection);
end;

// pra que esta função NGetEmailAddressesList?
function NGetEmailAddressesList(IdsList: string): string;
var
  BM: TBookMark;
begin
  with dmSicsMain.cdsEmails do
  begin
    BM := GetBookmark;
    try
      result := '';
      try
        First;
        while not Eof do
        begin
          if Pos(';' + FieldByName('ID').AsString + ';', IdsList) > 0 then
            result := result + FieldByName('NOME').AsString + ',';
          Next;
        end;
        result := Copy(result, 1, length(result) - 1);
      except
        result := '';
      end;
    finally
      GotoBookmark(BM);
      FreeBookmark(BM);
    end;
  end; { with cds }
end;   { func NGetEmailAddressesList }

function NGetPainelMsg(IdPainel: integer; var Msg: string): boolean;
var
  BM: TBookMark;
begin
  with dmSicsMain.cdsPaineis do
  begin
    BM := GetBookmark;
    try
      try
        if Locate('ID', IdPainel, []) then
        begin
          Msg    := FieldByName('Mensagem').AsString;
          result := True;
        end
        else
        begin
          Msg    := '';
          result := False;
        end;
      except
        result := False;
      end; { try .. except }
    finally
      GotoBookmark(BM);
      FreeBookmark(BM);
    end;
  end; { with cds }
end;   { func NGetPainelMsg }

function NSetPainelMsg(IdPainel: integer; Msg: string): boolean;
var
  BM: TBookMark;
begin
  result := False;
  with dmSicsMain.cdsPaineis do
  begin
    BM := GetBookmark;
    try
      try
        if Locate('ID', IdPainel, []) then
        begin
          Edit;
          FieldByName('Mensagem').AsString := Msg;
          Post;
          result := True;
        end;
      except
        result := False;
      end; { try .. except }
    finally
      GotoBookmark(BM);
      FreeBookmark(BM);
    end;
  end; { with cds }
end;   { func NSetPainelMsg }

function NGetPrinterMsg(IdPrinter: integer; var Msg: string): boolean;
begin
  with dmSicsMain.cdsTotens do
    try
      if Locate('ID', IdPrinter, []) then
      begin
        Msg    := FieldByName('Mensagem').AsString;
        result := True;
      end
      else
      begin
        Msg    := '';
        result := False;
      end;
    except
      result := False;
    end; { try .. except }
end;     { func NGetPrinterMsg }

function NSetPrinterMsg(IdPrinter: integer; Msg: string): boolean;
begin
  dmSicsMain.cdsTotens.Refresh;
  result := True;
end; { func NSetPrinterMsg }

function NGetNomeDaFilaNoTicket(IdFila: integer): string;
var
  BM: TBookMark;
begin
  with dmSicsMain.cdsFilas do
  begin
    BM := GetBookmark;
    try
      result := '';
      try
        if Locate('ID', IdFila, []) then
          result := FieldByName('NOMENOTICKET').AsString;
      except
        result := '';
      end;
    finally
      GotoBookmark(BM);
      FreeBookmark(BM);
    end;
  end; { with cds }
end;   { func NGetNomeDaFilaNoTicket }

function NGetGerarSenhaAutomaticamente(IdFila: integer): boolean;
var
  BM: TBookMark;
begin
  with dmSicsMain.cdsFilas do
  begin
    BM := GetBookmark;
    try
      result := False;
      try
        if Locate('ID', IdFila, []) then
          result := FieldByName('GERACAOAUTOMATICA').AsBoolean;
      except
        result := False;
      end;
    finally
      GotoBookmark(BM);
      FreeBookmark(BM);
    end;
  end; { with cds }
end;   { func NGetGerarSenhaAutomaticamente }

function OrdemDasFilasToStr(PA: integer): string;
var
  BM1, BM2: TBookMark;
begin
  BM1 := dmSicsMain.cdsPAs.GetBookmark;
  try
    result := '';
    try
      if dmSicsMain.cdsPAs.Locate('ID', PA, []) then
      begin
        if dmSicsMain.cdsPAs.FieldByName('ATIVO').AsBoolean then
          result := '0'
        else
        begin
          if dmSicsMain.cdsPAs.FieldByName('OBEDECERSEQUENCIAFILAS').AsBoolean
          then
            result := '1'
          else
            result := '0';

          BM2 := dmSicsMain.cdsNN_PAs_Filas.GetBookmark;
          try
            dmSicsMain.cdsNN_PAs_Filas.First;
            while not dmSicsMain.cdsNN_PAs_Filas.Eof do
            begin
              result := result + TAspEncode.AspIntToHex(dmSicsMain.cdsNN_PAs_Filas.FieldByName('ID_FILA').AsInteger, 4);
              dmSicsMain.cdsNN_PAs_Filas.Next;
            end;
          finally
            dmSicsMain.cdsNN_PAs_Filas.GotoBookmark(BM2);
            dmSicsMain.cdsNN_PAs_Filas.FreeBookmark(BM2);
          end;
        end;
      end;
    except
      result := '';
    end;
  finally
    dmSicsMain.cdsPAs.GotoBookmark(BM1);
    dmSicsMain.cdsPAs.FreeBookmark(BM1);
  end;
end;

function GetModuleTypeByID(AConexao: TFDConnection; AIdModulo: integer): TModuloSics;
var
  LSQLQuery: TFDQuery;
begin
  Result := msNone;
  LSQLQuery := TFDQuery.Create(nil);
  try
    LSQLQuery.Connection := AConexao;
    LSQLQuery.SQL.Text := 'SELECT TIPO FROM MODULOS WHERE ID_UNIDADE = :ID_UNIDADE AND ID = :ID';
    LSQLQuery.ParamByName('ID_UNIDADE').AsInteger := vgParametrosModulo.IdUnidade;
    LSQLQuery.ParamByName('ID').AsInteger :=  AIdModulo;
    LSQLQuery.Open;
    if not LSQLQuery.IsEmpty then
    begin
      Result := TModuloSics(LSQLQuery.Fields[0].AsInteger);
    end;
  finally
    FreeAndNil(LSQLQuery);
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
  else
    result := EmptyStr;
  end;
end;

function GetNomeColunaTipoGrupoPorModulo(Const aTipoModulo: TModuloSics; const aTipoDeGrupo: TTipoDeGrupo): string;
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
    tgNomesPAs:
      result := 'PAS_PERMITIDAS';
  else
    raise Exception.Create('Tipo de grupo PA não configurado.');
  end;
end;

function GetNomeColunaTipoGrupoMPA(Const aTipoDeGrupoMPA: TTipoDeGrupoMPA): string;
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
    tgNomesPAs:
      result := 'PAS_PERMITIDAS';
  else
    raise Exception.Create('Tipo de grupo MultiPA não configurado.');
  end;
end;

function GetNomeColunaTipoGrupoOnLine(Const aTipoDeGrupoOnLine: TTipoDeGrupoOnLine): string;
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
    tgVisTAG:
      result := 'VISUALIZAR_TAGS_NAS_FILAS';
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
    tgNomesPAs:
      result := 'GRUPOS_PAS_PERMITIDAS';
  else
    result := '';
  end;
end;

function GetNomeColunaTipoGrupoTGS(Const aTipoDeGrupoTGS: TTipoDeGrupo): string;
begin
  case aTipoDeGrupoTGS of
    tgNomesPAs:
      result := 'GRUPOS_DE_PAS_PERMITIDAS';
    tgTAG:
      result := 'GRUPOS_DE_TAGS_PERMITIDOS';
    tgPA:
      result := 'GRUPOS_DE_PAS_PERMITIDAS';
    tgAtd:
      result := 'GRUPOS_DE_ATENDENTES_PERMITIDOS';
    tgPausa:
      result := 'GRUPOS_DE_MOTIVOS_DE_PAUSA_PERM';
    tgPI:
      result := 'GRUPOS_INDICADORES_PERMITIDOS';
  else
    result := '';
  end;
end;

function GetListaIDPermitidosDoGrupo(AConexao: TFDConnection; const aNomeTabela, aNomeCampo: String; const AIdModulo: integer): TIntArray;
var
  aQuery: TFDQuery;
begin
  SetLength(result, 0);

  aQuery := TFDQuery.Create(nil);
  try
    aQuery.Connection := AConexao;
    aQuery.SQL.Text := Format('SELECT %s FROM %s A WHERE ID_UNIDADE = %d AND ID = %d',
      [aNomeCampo, aNomeTabela, vgParametrosModulo.IdUnidade, AIdModulo]);
    aQuery.Open;
    StrToIntArray(aQuery.Fields[0].AsString, result);
  finally
    FreeAndNil(aQuery);
  end;
end;

function GetListaIDPermitidosDoGrupoPA(AConexao: TFDConnection; const aNomeTabela, aNomeCampo: String; const AIdModulo: integer): TIntArray;
var
  aQuery: TFDQuery;
  vPasPermitidas: TIntArray;
  vFilter: string;
  i: integer;
begin
  SetLength(result, 0);
  aQuery := TFDQuery.Create(nil);
  try
    aQuery.Connection := AConexao;
    aQuery.SQL.Text := Format('SELECT %s FROM %s A WHERE ID = %d AND ID_UNIDADE=%d', [aNomeCampo, aNomeTabela, AIdModulo, vgParametrosModulo.IdUnidade]);
    aQuery.Open;

    StrToIntArray(aQuery.Fields[0].AsString, vPasPermitidas);
    vFilter :=  GetFilterPorRangerID(vPasPermitidas);

    aQuery.Close;
    aQuery.SQL.Text := 'SELECT ID_GRUPOPA FROM PAS WHERE ID_UNIDADE = ' + vgParametrosModulo.IdUnidade.ToString + ' AND ' + vFilter;
    aQuery.Open;
    
    SetLength(result, aQuery.RecordCount);
    i := 0;
    while not aQuery.Eof do
    begin
      result[i] := aQuery.FieldByName('ID_GRUPOPA').AsInteger;
      Inc(i);
      aQuery.Next;
    end;
  finally
    FreeAndNil(aQuery);
  end;
end;

function GetFilterPorRangerID(const aRangeIDs: TIntArray; const aColuna: String = 'ID'): string;
var
  i: integer;
begin
  try
    if length(aRangeIDs) = 0 then
    begin
      result := '1 = 2';
    end
    else
    begin
      result := EmptyStr;

      for i := 0 to High(aRangeIDs) do
      begin
        if result <> '' then
          result := result + ' OR ';

        result := result + '(' + aColuna + ' = ' + inttostr(aRangeIDs[i]) + ')';
      end;
    end;
  except
    on E: Exception do
      MyLogException(ERegistroDeOperacao.Create('GetFilterPorRangerID'), True);
  end;
end;

function GetIdPA(AConexao: TFDConnection; AIdModulo: integer): integer;
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
      LSQLQuery.SQL.Text := Format('SELECT ID_PA FROM %s WHERE ID_UNIDADE = %d AND ID = %d', [vNomeTabela, vgParametrosModulo.IdUnidade, AIdModulo]);
      LSQLQuery.Open;

      Result := LSQLQuery.Fields[0].AsInteger;
    finally
      FreeAndNil(LSQLQuery);
    end;
  end;
end;

function GetIdModulo(AConexao: TFDConnection; PA: integer): integer; // LM
var
  vNomeTabela: string;
  LSQLQuery: TFDQuery;
begin
  // Result := 0;

  vNomeTabela := 'MODULOS_PAS';
  LSQLQuery := TFDQuery.Create(nil);
  try
    LSQLQuery.Connection := AConexao;
    LSQLQuery.SQL.Text := Format('SELECT ID FROM %s WHERE ID_UNIDADE = %d AND ID_PA = %d', [vNomeTabela, vgParametrosModulo.IdUnidade, PA]);
    LSQLQuery.Open;
    result := LSQLQuery.Fields[0].AsInteger;
  finally
    FreeAndNil(LSQLQuery);
  end;
end;

procedure TdmSicsMain.CheckVersionBD;

  function GetCurrentVersion: integer;
  begin
    result := 0;

    if not TConexaoBD.TabelaExiste('CONFIGURACOES_GERAIS', connOnLine) then
      Exit;

    with qryAuxScriptBd do
    begin
      SQL.Text := 'SELECT VALOR FROM CONFIGURACOES_GERAIS WHERE ID_UNIDADE = ' + IntToStr(vgParametrosModulo.IdUnidade) + ' AND  ID = ' +
      QuotedStr(CONFIG_KEY_BD_VERSION);
      Open;
      try
        if not IsEmpty then
          result := StrToIntDef(FieldByName('VALOR').AsString, 0);
      finally
        Close;
      end;
    end;
  end;

var
  LCurrentVersion: integer;
begin
  LCurrentVersion := GetCurrentVersion;

  if (LCurrentVersion <> High(ScriptsBdUnidades)) then
    raise Exception.CreateFmt('Versão da base de dados "%d" difere da versão deste EXE "%d".', [LCurrentVersion, High(ScriptsBdUnidades)]);
end;

procedure TdmSicsMain.ExecutarScriptsBDUnidades;
var
  i, iVersao: integer;
  conn : TFDConnection;
begin
  {$IF Defined(CompilarPara_CONFIG) }
    conn := MainForm.connUnidades;
  {$ELSE}
    conn := connOnLine;
  {$IFEND}

  with qryAuxScriptBd do
  begin
    if not TConexaoBD.TabelaExiste('CONFIGURACOES_GERAIS', conn) then
      conn.ExecSQL ('CREATE TABLE CONFIGURACOES_GERAIS (ID_UNIDADE INT NOT NULL, ID VARCHAR(50) NOT NULL, VALOR VARCHAR(50)) CONSTRAINT PK_CONFIGURACOES_GERAIS PRIMARY KEY (ID_UNIDADE, ID)');

    Close;
    Sql.Text := 'SELECT VALOR FROM CONFIGURACOES_GERAIS WHERE ID = ' + QuotedStr(CONFIG_KEY_BD_VERSION);
    Open;
    try
      if IsEmpty then
      begin
        conn.ExecSQL('INSERT INTO CONFIGURACOES_GERAIS (ID, VALOR) VALUES (' + QuotedStr(CONFIG_KEY_BD_VERSION) + ', ' + QuotedStr('0') + ')');
        iVersao := 0;
      end
      else
      begin
        if FieldByName('VALOR').AsString = '' then
          iVersao := 0
        else
          iVersao := FieldByName('VALOR').AsInteger;
      end;
    finally
      Close;
    end;

    for i := Low(ScriptsBdUnidades) to High(ScriptsBdUnidades) do
    begin
      if i <= iVersao then
        Continue;

      conn.StartTransaction;
      try
        conn.ExecSQL(ScriptsBdUnidades[i]);
        conn.ExecSQL('UPDATE CONFIGURACOES_GERAIS SET VALOR = ' + QuotedStr(inttostr(i)) +
                       ' WHERE ID = ' + QuotedStr(CONFIG_KEY_BD_VERSION));
        conn.Commit;
      except
        conn.Rollback;
        raise;
      end;
    end;
  end;
end;

procedure TdmSicsMain.InsereUnidade(AId: integer; const ANome, APathBaseOnLine,
  APathBaseRelatorios, AEnderecoIP: string; const APortaIP: integer);
var
  iIdxConn: integer;
  SqlConnLocal: TFDConnection;
begin
  with cdsUnidades do
  begin
    if not Active then
      CreateDataSet;

    Append;
    FieldByName('ID').AsInteger                  := AId;
    FieldByName('NOME').AsString                 := ANome;
    FieldByName('PATH_BASE_ONLINE').AsString     := APathBaseOnLine;
    FieldByName('PATH_BASE_RELATORIOS').AsString := APathBaseRelatorios;
    FieldByName('IP_ENDERECO').AsString          := AEnderecoIP;
    FieldByName('IP_PORTA').AsInteger            := APortaIP;
    FieldByName('CONECTADA').AsBoolean           := False;

    if AId = 0 then
    begin
      SqlConnLocal                       := connRelatorio;
      FieldByName('CONECTADA').AsBoolean := True;
    end
    else
    begin
      SqlConnLocal := TFDConnection.Create(Self);
      with SqlConnLocal do
      begin
        DriverName    := connOnLine.DriverName;

        // VendorLib     := connOnLine.VendorLib;

        LoginPrompt   := False;
        Params.Assign(connOnLine.Params);
        Params.Values['DataBase'] := APathBaseRelatorios;
      end;
    end;

    SetLength(FConnsRelatorios, length(FConnsRelatorios) + 1);
    iIdxConn                                    := High(FConnsRelatorios);
    FConnsRelatorios[iIdxConn]                  := SqlConnLocal;
    FieldByName('IDX_CONN_RELATORIO').AsInteger := iIdxConn;

    Post;

  end;
end;

procedure TdmSicsMain.IntegerField4GetText(Sender: TField; var Text: string;
DisplayText: boolean);
begin
  if Sender.AsInteger = -1 then
    Text := EmptyStr
  else
    Text := Sender.AsString;

 // DisplayText := true;
end;

procedure TdmSicsMain.DataModuleCreate(Sender: TObject);
// {$IFNDEF CompilarPara_CONFIG}
// var
// sUnidade, sBaseOnLine, sBaseRelatorios, sEnderecoIP: string;
// iUnidade, iPortaIP                                 : integer;
// {$ENDIF CompilarPara_CONFIG}
begin

  SetLength(FConnsRelatorios, 0);

{$IF (Defined(CompilarPara_CONFIG)) or (Defined(CompilarPara_SCC))}
  FIsService     := false;
{$ELSE}
  FIsService     := GetIsService;
{$ENDIF}
{$IF (not Defined(CompilarPara_CONFIG)) and (not Defined(CompilarPara_SCC))}
  InsereUnidade(0, TConexaoBD.NomeUnidade, TConexaoBD.Dir,
    TConexaoBD.Dir, '', 0);

  //LM
  //if vgParametrosModulo.WebserverAtivo then
  //begin
    //dmSicsWebServer := TdmSicsWebServer.Create(Self);
    //dmSicsWebServer.Iniciar(vgParametrosModulo.WebserverPort);
  //end;

  if (vgParametrosModulo.SMTPNomeRemetente = '') then
  begin
    vgParametrosModulo.SmtpNomeRemetente :=
      'SICS - Sistema Inteligente de Chamada de Senhas';
    vgParametrosModulo.SMTPEmailRemetente := 'suporte_sw@aspect.com.br';
  end;

  // Configurar Conexão para Unidades
  try
    connUnidades.Close;
    connUnidades.ConnectionDefName := TConexaoBD.GetConnection
      (vgParametrosModulo.DBDirUnidades, vgParametrosModulo.DBHostUnidades,
      vgParametrosModulo.DBBancoUnidades, vgParametrosModulo.DBUsuarioUnidades,
                                                               vgParametrosModulo.DBSenhaUnidades,
                                                               vgParametrosModulo.DBOSAuthentUnidades);
    connUnidades.Open;
  except
    on E: Exception do
    begin
      MyLogException(E);

      if vgParametrosModulo.DBDirUnidades.Trim.IsEmpty then
      begin
        MessageDlg('Erro ao abrir base de dados de Unidades!!' + #13 + 'Erro: '
          + E.Message, mtInformation, [mbAbort], 0);
      end
      else
      begin
        MessageDlg('Erro ao abrir base de dados de Unidades.' + sLineBreak +
          'Arquivo ' + vgParametrosModulo.DBDirUnidades.Trim +
          ' não encontrado.', mtInformation, [mbAbort], 0);
      end;

      Halt;
    end;
  end;

  try
    // Configurar Conexão para Sics Servidor
    TConexaoBD.Reset;

    {
    tblUnidades.Open;
    if not tblUnidades.Locate('ID',vgParametrosModulo.IdUnidade,[]) then
    begin
      MessageDlg('Erro ID da Unidade não definido no arquivo INI!', TMsgDlgType.mtError, [TMsgDlgBtn.mbAbort], 0);
      Halt;
    end;
    }

    qryUnidades.Close;
    qryUnidades.ParamByName('ID').AsInteger := vgParametrosModulo.IdUnidade;
    qryUnidades.Open;

    if qryUnidades.IsEmpty then
    begin
      MessageDlg('Erro ID da Unidade não definido no arquivo INI!',
        TMsgDlgType.mtError, [TMsgDlgBtn.mbAbort], 0);
      Halt;
    end;

    // Nome da unidade vindo do cadastro
    vgParametrosModulo.NomeUnidade := qryUnidadesNOME.AsString.Trim;
    vgParametrosModulo.TCPPort     := qryUnidadesPORTA.AsInteger;
    vgParametrosModulo.TCPPortTGS  := qryUnidadesPORTA_TGS.AsInteger;

    connOnLine.Close;
    connOnLine.ConnectionDefName := TConexaoBD.GetConnection
      (qryUnidadesDBDIR.AsString, qryUnidadesHOST.AsString,
      qryUnidadesBANCO.AsString, qryUnidadesUSUARIO.AsString,
      qryUnidadesSENHA.AsString, qryUnidadesOSAUTHENT.AsString = 'T',
                                                             qryUnidadesID.AsInteger);
    connOnLine.Open;
  except
    on E: Exception do
    begin
      MyLogException(E);
      MessageDlg('Erro ao abrir base de dados do Servidor!' + #13 + 'Erro: ' +
        E.Message, TMsgDlgType.mtError, [TMsgDlgBtn.mbAbort], 0);
      Halt;
    end;
  end;

  try
    connRelatorio.Close;
    connRelatorio.ConnectionDefName := TConexaoBD.Nome;
    connRelatorio.Open;
  except
    on E: Exception do
    begin
      MyLogException(E);
      MessageDlg('Erro ao abrir base de dados de relatórios!' + #13 + 'Erro: ' +
        E.Message, TMsgDlgType.mtError, [TMsgDlgBtn.mbAbort], 0);
      Halt;
    end;
  end;

  try
    if connOnLine.Connected then
      ExecutarScriptsBDUnidades;
  except
    on E: Exception do
    begin
      MyLogException(E);
      MessageDlg('Erro ao executar scripts de atualização da base de dados!' +
        #13 + 'Erro: ' + E.Message, TMsgDlgType.mtError,
        [TMsgDlgBtn.mbAbort], 0);
      Halt;
    end;
  end;

{$ENDIF}

  try
    connPIS.Close;
    connPIS.ConnectionDefName := TConexaoBD.Nome;
    connPIS.Open;
  except
    on E: Exception do
    begin
      MyLogException(E);
      MessageDlg('Erro ao abrir base de dados de relatórios!' + #13 + 'Erro: ' + e.Message, TMsgDlgType.mtError, [TMsgDlgBtn.mbAbort], 0);
      Halt;
    end;
  end;
  {
  cdsContadoresDeFilas.CreateDataSet;
  cdsContadoresDeFilas.IndexFieldNames := 'ID';
  cdsContadoresDeFilas.MasterSource    := dsFilas;
  cdsContadoresDeFilas.MasterFields    := 'ID';
  cdsContadoresDeFilas.LogChanges      := False;
  }

  cdsControleDePaineis.CreateDataSet;
  cdsControleDePaineis.IndexFieldNames := 'ID';
  cdsControleDePaineis.MasterSource    := dsPaineis;
  cdsControleDePaineis.MasterFields    := 'ID';
  cdsControleDePaineis.LogChanges      := False;

  if connOnLine.Connected then
  begin
    CarregaTabelasDM;
  end;

  CriarCdsTelasOnline;
  CriarCdsTamanhoFonteOnline;
  CriarCdsLayoutEsperaOnline;
  CriarCdsCorLimiarOnline;
  CriarCdsEstiloLayoutEspera;
  ConfigurarAtualizacaoJornalTV;
end;

procedure TdmSicsMain.cdsAtendentesReconcileError(DataSet: TCustomClientDataSet;
E: EReconcileError; UpdateKind: TUpdateKind; var Action: TReconcileAction);
begin
  MyLogException(E);
end;

procedure TdmSicsMain.cdsUnidadesAfterOpen(DataSet: TDataSet);
begin
  cdsUnidadesClone.CloneCursor(cdsUnidades, true);
end;

procedure TdmSicsMain.LimparNNPASFilasInativas;
const
  DELETE_PA   = 'delete from nn_pas_filas where ID_UNIDADE = %d AND id_pa in (select id from pas where ID_UNIDADE = %d AND ativo = ''F'')';
  DELETE_FILA = 'delete from nn_pas_filas where ID_UNIDADE = %d AND id_fila in (select id from filas where ID_UNIDADE = %d AND ativo = ''F'')';
begin
  connOnLine.ExecSQL(Format(DELETE_PA, [vgParametrosModulo.IdUnidade, vgParametrosModulo.IdUnidade]));
  connOnLine.ExecSQL(Format(DELETE_FILA, [vgParametrosModulo.IdUnidade, vgParametrosModulo.IdUnidade]));
end;

function TdmSicsMain.CreateSqlConnUnidade(AOwner: TComponent;
IdUnidade: integer): TFDConnection;
begin
  if not cdsUnidadesClone.Locate('ID', IdUnidade, []) then
    raise Exception.Create('Unidade não localizada');

  Result := TFDConnection.Create(AOwner);
  with Result do
  begin
    DriverName    := connOnLine.DriverName;

    // VendorLib     := connOnLine.VendorLib;

    LoginPrompt   := False;
    Params.Assign(connOnLine.Params);
    Params.Values['DataBase'] := cdsUnidadesClone.FieldByName
      ('PATH_BASE_ONLINE').AsString;
  end;

end;

procedure TdmSicsMain.CriarCdsTamanhoFonteOnline;
begin
  with cdsTamanhoFonteOnline do
  begin
    CreateDataSet;

    Append;
    FieldByName('ID').AsInteger := 0;
    FieldByName('NOME').AsString  := 'Normal';
    Post;

    Append;
    FieldByName('ID').AsInteger := 1;
    FieldByName('NOME').AsString  := 'Médio';
    Post;

    Append;
    FieldByName('ID').AsInteger := 2;
    FieldByName('NOME').AsString  := 'Grande';
    Post;

    Append;
    FieldByName('ID').AsInteger := 3;
    FieldByName('NOME').AsString  := 'Extra Grande';
    Post;
  end;
end;


procedure TdmSicsMain.CriarCdsLayoutEsperaOnline;
begin
  with cdsLayoutsEsperaOnLine do
  begin
    CreateDataSet;

    Append;
    FieldByName('ID').AsInteger := 0;
    FieldByName('NOME').AsString  := 'Grid';
    Post;

    Append;
    FieldByName('ID').AsInteger := 1;
    FieldByName('NOME').AsString  := 'Cartões';
    Post;
  end;
end;


procedure TdmSicsMain.CriarCdsCorLimiarOnline;
begin
  with cdsCorLimiarOnLine do
  begin
    CreateDataSet;

    Append;
    FieldByName('ID').AsInteger := 0;
    FieldByName('NOME').AsString  := 'Clean';
    Post;

    Append;
    FieldByName('ID').AsInteger := 1;
    FieldByName('NOME').AsString  := 'Registro inteiro';
    Post;
  end;
end;

procedure TdmSicsMain.CriarCdsEstiloLayoutEspera;
begin
  with cdsEstiloLayoutsEsperaOnline do
  begin
    CreateDataSet;

    Append;
    FieldByName('ID').AsInteger := 0;
    FieldByName('NOME').AsString  := 'Clear';
    Post;

    Append;
    FieldByName('ID').AsInteger := 1;
    FieldByName('NOME').AsString  := 'Solido';
    Post;
  end;
end;

procedure TdmSicsMain.CriarCdsTelasOnline;
begin
  with cdsTelasOnline do
  begin
    CreateDataSet;

    Append;
    FieldByName('ID').AsInteger := 0;
    FieldByName('NOME').AsString  := 'Nenhuma';
    Post;

    Append;
    FieldByName('ID').AsInteger := 1;
    FieldByName('NOME').AsString  := 'Situação da Espera';
    Post;

    Append;
    FieldByName('ID').AsInteger := 2;
    FieldByName('NOME').AsString  := 'Situação do Atendimento';
    Post;

    Append;
    FieldByName('ID').AsInteger := 3;
    FieldByName('NOME').AsString  := 'Indicadores de Performance (KPIs)';
    Post;
  end;
end;

function TdmSicsMain.SalvarDadosAdicionais(const ATicketId: Integer;
const AObj: TJSONObject; const ExcluirDadosAtuais: boolean): boolean;
var
  i: Integer;
begin
  connOnLine.StartTransaction;
  try
    if ExcluirDadosAtuais then
      connOnLine.ExecSQL('delete from TICKETS_CAMPOSADIC ' +
        'where ID_UNIDADE = :ID_UNIDADE AND ID_TICKET = :ID_TICKET', [vgParametrosModulo.IdUnidade, ATicketId]);

    for i := 0 to AObj.Count - 1 do
    begin
      qryInsertCampoAdicional.Close;
      qryInsertCampoAdicional.ParamByName('ID_UNIDADE').AsInteger := vgParametrosModulo.IdUnidade;
      qryInsertCampoAdicional.ParamByName('ID_TICKET').AsInteger := ATicketId;
      qryInsertCampoAdicional.ParamByName('CAMPO').AsString := AObj.Pairs[i].JsonString.Value;
      qryInsertCampoAdicional.ParamByName('VALOR').AsString := AObj.Pairs[i].JsonValue.Value;
      qryInsertCampoAdicional.ExecSQL;
      qryInsertCampoAdicional.Close;

{$IF (not Defined(CompilarPara_CONFIG)) and (not Defined(CompilarPara_SCC))}
      if UpperCase(AObj.Pairs[i].JsonString.Value) = 'NOME' then
        frmSicsMain.SetNomeCliente(ATicketId, rnDadosAdicionais,
          AObj.Pairs[i].JsonValue.Value);
{$ENDIF}
    end;

    connOnLine.Commit;
    result := True;
  except
    on E: Exception do
    begin
      MyLogException(E);
      result := False;
      connOnLine.Rollback;
    end;
  end;
end;

function TdmSicsMain.GetDadosAdicionais(const ATicketId: Integer): TJSONObject;
begin
  result := nil;
  qryCamposAdicionais.Close;
  try
    qryCamposAdicionais.ParamByName('ID_UNIDADE').AsInteger := vgParametrosModulo.IdUnidade;
    qryCamposAdicionais.ParamByName('ID_TICKET').AsInteger := ATicketId;
    qryCamposAdicionais.Open;
    if not qryCamposAdicionais.IsEmpty then
    begin
      result := TJSONObject.Create;
      while not qryCamposAdicionais.Eof do
      begin
        result.AddPair(qryCamposAdicionais.Fields[0].AsString,
                       qryCamposAdicionais.Fields[1].AsString);
        qryCamposAdicionais.Next;
      end;
    end;
  finally
    qryCamposAdicionais.Close;
  end;
end;

function TdmSicsMain.GetDataHoraEmissaoSenhaNoBD(const ATicketId: integer;
const ADataHoraUltimaInteracao: TDateTime): TDateTime;
begin
  result := ADataHoraUltimaInteracao;
  qryDtHrEmissaoSenha.Close;
  try
    qryDtHrEmissaoSenha.ParamByName('ID_UNIDADE').AsInteger := vgParametrosModulo.IdUnidade;
    qryDtHrEmissaoSenha.ParamByName('TICKETID').AsInteger := ATicketId;

{$IFDEF DEBUG}
    // para conseguir pegar a SQL "pós processamento das macros" é necessário
    // chamar o método Prepare
    qryDtHrEmissaoSenha.Prepare;
    ClipBoard.AsText := qryDtHrEmissaoSenha.Text;
{$ENDIF}
    qryDtHrEmissaoSenha.Open;
    if (not qryDtHrEmissaoSenha.IsEmpty) and
       (not qryDtHrEmissaoSenhaINICIO.IsNull) then
      result := qryDtHrEmissaoSenhaINICIO.AsDateTime;
  finally
    qryDtHrEmissaoSenha.Close;
  end;
end;

function TdmSicsMain.GetDeviceIdSenha(const ATicketId: Integer): String;
begin
  result := EmptyStr;
  try
    try
      qryDeviceIdSenha.Close;
      qryDeviceIdSenha.ParamByName('ID_UNIDADE').AsInteger := vgParametrosModulo.IdUnidade;
      qryDeviceIdSenha.ParamByName('ID').AsInteger := ATicketId;
      qryDeviceIdSenha.Open;
      if not qryDeviceIdSenha.IsEmpty then
        result := qryDeviceIdSenha.Fields[0].AsString;
    finally
      qryDeviceIdSenha.Close;
    end;
  except
    result := EmptyStr;
  end;
end;

// Gravar ID do Cliente
function TdmSicsMain.SetDeviceIdSenha(const ATicketId: Integer;
const ADeviceId: String): boolean;
var
  i: Integer;
begin
  connOnLine.StartTransaction;
  try
    i := connOnLine.ExecSQL('update TICKETS set ' + 'DEVICEID = ''' + ADeviceId
      + ''' ' + 'where ID_UNIDADE = ' + vgParametrosModulo.IdUnidade.ToString + ' AND ID = ' + ATicketId.ToString);
    connOnLine.Commit;
    result := (i = 1);
  except
    result := False;
    connOnLine.Rollback;
  end;
end;

procedure TdmSicsMain.SetNewSqlConnectionForSQLDataSet(AOwner: TComponent;
ANewSqlConnection: TFDConnection);
var
  i: integer;
begin
  for i := 0 to AOwner.ComponentCount - 1 do
    if AOwner.Components[i] is TFDCustomQuery then
      TFDCustomQuery(AOwner.Components[i]).Connection := ANewSqlConnection;
end;

function TdmSicsMain.CheckPromptUnidade: integer;
begin
  Result := 0;
end;

procedure TdmSicsMain.ConfigurarAtualizacaoJornalTV;
begin
{$IF (not Defined(CompilarPara_CONFIG)) and (not Defined(CompilarPara_SCC))}
  if (vgParametrosModulo.IntervaloApi <= 0) or
    (vgParametrosModulo.UrlApi.Trim.IsEmpty) or
     (vgParametrosModulo.NomeUnidadeApi.Trim.IsEmpty) then
  begin
    Exit;
  end;

  TTempoUnidadeManager.FTextoSemEspera                         := vgParametrosModulo.TextoSemEspera;
  TTempoUnidadeManager.FFormatoHorarioEsperaNoJornalEletronico :=
    integer(vgParametrosModulo.FormatoHorarioEsperaNoJornalEletronico);
  TTempoUnidadeManager.FTempoMaximoSemRetornoAPI :=
    vgParametrosModulo.TempoMaximoSemRetornoAPI;
  TTempoUnidadeManager.FFuncFormataHora :=
    frmSicsMain.FormatarPIHorarioParaJornalEletronico;

  tmrAtualizaJornalTVs.Enabled  := False;
  tmrAtualizaJornalTVs.Interval := vgParametrosModulo.IntervaloApi * 60 * 1000;
  tmrAtualizaJornalTVs.Tag      := tmrAtualizaJornalTVs.Interval;
{$ENDIF}
end;

procedure TdmSicsMain.connOnLineAfterCommit(Sender: TObject);
begin
  {$IF (not Defined(CompilarPara_CONFIG)) and (not Defined(CompilarPara_SCC)) and (not Defined(CompilarPara_TV))}
  TThread.Synchronize(nil,
  procedure
  begin
    TfrmDebugParameters.Debugar (tbAtividadeConexaoBD, 'Evento connOnLineAfterCommit');
  end);
  {$ENDIF}
end;

procedure TdmSicsMain.connOnLineAfterRollback(Sender: TObject);
begin
  {$IF (not Defined(CompilarPara_CONFIG)) and (not Defined(CompilarPara_SCC)) and (not Defined(CompilarPara_TV))}
  TThread.Synchronize(nil,
  procedure
  begin
    TfrmDebugParameters.Debugar (tbAtividadeConexaoBD, 'Evento connOnLineAfterRollback');
  end);
  {$ENDIF}
end;

procedure TdmSicsMain.connOnLineAfterStartTransaction(Sender: TObject);
begin
  {$IF (not Defined(CompilarPara_CONFIG)) and (not Defined(CompilarPara_SCC)) and (not Defined(CompilarPara_TV))}
  TThread.Synchronize(nil,
  procedure
  begin
    TfrmDebugParameters.Debugar (tbAtividadeConexaoBD, 'Evento connOnLineAfterStartTransaction');
  end);
  {$ENDIF}
end;

procedure TdmSicsMain.connOnLineBeforeCommit(Sender: TObject);
begin
  {$IF (not Defined(CompilarPara_CONFIG)) and (not Defined(CompilarPara_SCC)) and (not Defined(CompilarPara_TV))}
  TThread.Synchronize(nil,
  procedure
  begin
    TfrmDebugParameters.Debugar (tbAtividadeConexaoBD, 'Evento connOnLineBeforeCommit');
  end);
  {$ENDIF}
end;

procedure TdmSicsMain.connOnLineBeforeRollback(Sender: TObject);
begin
  {$IF (not Defined(CompilarPara_CONFIG)) and (not Defined(CompilarPara_SCC)) and (not Defined(CompilarPara_TV))}
  TThread.Synchronize(nil,
  procedure
  begin
    TfrmDebugParameters.Debugar (tbAtividadeConexaoBD, 'Evento connOnLineBeforeRollback');
  end);
  {$ENDIF}
end;

procedure TdmSicsMain.connOnLineBeforeStartTransaction(Sender: TObject);
begin
  {$IF (not Defined(CompilarPara_CONFIG)) and (not Defined(CompilarPara_SCC)) and (not Defined(CompilarPara_TV))}
  TThread.Synchronize(nil,
  procedure
  begin
    TfrmDebugParameters.Debugar (tbAtividadeConexaoBD, 'Evento connOnLineBeforeStartTransaction');
  end);
  {$ENDIF}
end;

procedure TdmSicsMain.connOnLineError(ASender, AInitiator: TObject; var AException: Exception);
begin
  MyLogException(Exception.Create('Conexão principal com erro: ' + AException.Message));
end;

procedure TdmSicsMain.connOnLineLost(Sender: TObject);
begin
  MyLogException(Exception.Create('Conexão principal foi perdida.'));
end;

procedure TdmSicsMain.connOnLineRecover(ASender, AInitiator: TObject; AException: Exception; var AAction: TFDPhysConnectionRecoverAction);
begin
  MyLogException(Exception.Create('Conexão principal se recuperando.'));
end;

procedure TdmSicsMain.connOnLineRestored(Sender: TObject);
begin
  MyLogException(Exception.Create('Conexão principal restaurada.'));
end;

procedure TdmSicsMain.DefinirCanalPadraoTV(IdTV, Canal: integer);
begin
  with qryAux do
  begin
    SQL.Text := 'UPDATE TVS SET ID_CANAL_TV_PADRAO = :ID_CANAL_TV_PADRAO WHERE ID_UNIDADE = :ID_UNIDADE AND ID = :ID';
    ParamByName('ID_UNIDADE').AsInteger := vgParametrosModulo.IdUnidade;
    ParamByName('ID').AsInteger                 := IdTV;
    ParamByName('ID_CANAL_TV_PADRAO').AsInteger := Canal;
    ExecSQL;
  end;
end;

procedure TdmSicsMain.cdsGruposDeTagsAfterOpen(DataSet: TDataSet);
begin
  cdsCloneGruposDeTags.CloneCursor(cdsGruposDeTags, true); // RAP
end;

procedure TdmSicsMain.cdsPaineisAfterOpen(DataSet: TDataSet);
begin
  { Para voltar a institucional logo que acionar o timer de checagem do outbuffer }
  cdsPaineis.First;
  while not cdsPaineis.eof do
  begin
    cdsControleDePaineis.Edit;
    cdsControleDePaineis.FieldByName('ProximaChamada').AsDateTime := now;
    cdsControleDePaineis.Post;
    cdsPaineis.Next;
  end;
end;

function TdmSicsMain.GetID_MODULOS(AModuloSICS: TModuloSics): Integer;
const
  GENERATOR_MODULO = 'GEN_ID_MODULOS';

var
  LGenerator: String;
begin
//  Result := TGenerator.NGetNextGenerator('GEN_ID_MODULOS', connOnLine);

  LGenerator := GENERATOR_MODULO;

  {case AModuloSICS of
    msPA: LGenerator := LGenerator + '_PA';
    msMPA: LGenerator := LGenerator + '_MPA';
    msOnLine: LGenerator := LGenerator + '_ONLINE';
    msTGS: LGenerator := LGenerator + '_TGS';
    msTV: LGenerator := LGenerator + '_TV';
    msServidor: LGenerator := LGenerator + '_SERVIDOR';
    msCallCenter: LGenerator := LGenerator + '_CALLCENTER';
    msTotemTouch: LGenerator := LGenerator + '_TOTEMTOUCH';
  end;}

  Result := TGenerator.NGetNextGenerator(LGenerator, connOnLine);
end;

initialization

dmSicsMain := nil;

end.
