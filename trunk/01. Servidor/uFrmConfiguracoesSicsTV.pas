unit uFrmConfiguracoesSicsTV;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Mask, DBCtrls, Buttons, DB, DBGrids, FMTBcd,
  Provider, Sics_91, uFrmBaseConfiguracoesSics, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.Client, Vcl.ComCtrls,
  Vcl.CheckLst, JvExStdCtrls, JvCombobox, JvColorCombo, JvExControls,
  JvSpeedButton, JvExMask, JvToolEdit, JvExExtCtrls, JvExtComponent,
  JvOfficeColorButton, JvImage, Vcl.Menus, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, Datasnap.DBClient, Vcl.Grids, uDataSetHelper;

type
  TTipoChamadaPorVoz = (cvSenha, cvNomePA, cvNomeCliente);
  EEnvioDeEmail = class (Exception);
  THorarioDeFuncionamento = record
                              DesdeHoras, AteHoras : TTime;
                              FuncionaSabado, FuncionaDomingo : boolean;
                            end;

  TTipoAjuste  = (taCanal, taVolume, taClosedCaption);

  TValorAjuste = (vaSubir, vaDescer);

  TArrString = array of string;

  TTipoPlanoDeFundo = (pfImagem, pfCorSolida, pfTransparente);

  TPlanoDeFundo = record
                    Tipo   : TTipoPlanoDeFundo;
                    Cor    : TColor;
                    Imagem : string;
                  end;

  TParametrosQuadrosGerais = record
                               X, Y, Larg, Alt : integer;
                               PlanoDeFundo : TPlanoDeFundo;
                             end;

  TParametrosQuadroTV = record
                          Gerais                  : TParametrosQuadrosGerais;
                          ParentHandle, AppHandle : DWORD;
                          SoftwareHomologado      : integer; //0 = outro (editavel), 1 em diante = parâmetros frequentes de softwares homologados, ex: 1 = AverTV, 2 = VLC, etc
                          CaminhoDoExecutavel     : string;
                          NomeDaJanela            : string;
                          Dispositivo             : Integer;
                          Resolucao               : Integer;
                          TempoAlternancia        : Integer;
                          //PanelVideo              : TJvPanel;
                          //Panel                   : TJvPanel;
                        end;


  TParametrosQuadroPlayListManager = record
                                       Gerais                  : TParametrosQuadrosGerais;
                                       ParentHandle, AppHandle : DWORD;
                                       NomeDaJanela            : string;
                                       IDTV                    : Integer;
                                       TipoBanco               : Integer;
                                       HostBanco               : string;
                                       PortaBanco              : string;
                                       NomeArquivoBanco        : string;
                                       UsuarioBanco            : string;
                                       SenhaBanco              : string;
                                       IntervaloVerificacao    : Integer;
                                       AtualizacaoPlayList     : TDateTime;
                                       DiretorioLocal          : string;
                                       //PanelVideo              : TJvPanel;
                                       //Panel                   : TJvPanel;
                                     end;


  TResolucaoMonitor = record
    Width: Integer;
    Height: Integer;
    //class operator Implicit(AValue: TResolucaoMonitor): String;
    //class operator Implicit(AValue: String): TResolucaoMonitor;
    //procedure Reset;
    //function Valida: Boolean;
  end;

  TTipoDePainel = (tpTela, tpChamadaSenha, tpUltimasSenhas, tpImagem, tpFlash, tpDataHora, tpVideo, tpTV, tpJornalEletronico, tpIndicadorPerformance, tpPlayListManager);

  TFrmConfiguracoesSicsTV = class(TFrmBaseConfiguracoesSics)
    qryNomePA: TFDQuery;
    cdsNomePA: TClientDataSet;
    cdsNomePAID: TIntegerField;
    cdsNomePANOME: TStringField;
    dspNomePA: TDataSetProvider;
    dscNomePA: TDataSource;
    ScrollBox1: TScrollBox;
    Panel1: TPanel;
    pnlListaPanels: TPanel;
    Label26: TLabel;
    PageControlConfigs: TPageControl;
    tbsGeral: TTabSheet;
    groupPosicao: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    edLeft: TDBEdit;
    edTop: TDBEdit;
    edWidth: TDBEdit;
    edHeight: TDBEdit;
    groupBackground: TGroupBox;
    rbBackgroundImage: TRadioButton;
    rbBackGroundColor: TRadioButton;
    cmbBackgroundColor: TJvOfficeColorButton;
    edBackgroundImage: TDBEdit;
    tbsChamadaSenhas: TTabSheet;
    pnlChamadaSenhas: TGroupBox;
    groupChamadaDeSenhasFonte: TGroupBox;
    btnChamadaSenhasNegrito: TJvSpeedButton;
    btnChamadaSenhasItalico: TJvSpeedButton;
    btnChamadaSenhasSublinhado: TJvSpeedButton;
    cmbChamadaSenhasFonte: TJvFontComboBox;
    cmbChamadaSenhasFontSize: TDBComboBox;
    cmbChamadaSenhasFontColor: TJvOfficeColorButton;
    groupChamadaDeSenhasSom: TGroupBox;
    edChamadaSenhasSoundFileName: TJvFilenameEdit;
    lstVozChamada: TCheckListBox;
    btnSubirChamada: TBitBtn;
    btnDescerChamada: TBitBtn;
    chkArquivo: TDBCheckBox;
    chkVoz: TDBCheckBox;
    groupChamadaDeSenhasPAsPermitidas: TGroupBox;
    edChamadaSenhasPASPermitidas: TDBEdit;
    groupChamadaDeSenhasLayout: TGroupBox;
    groupChamadaDeSenhasLayoutSenha: TGroupBox;
    Label32: TLabel;
    Label33: TLabel;
    Label23: TLabel;
    Label35: TLabel;
    btnChamadaDeSenhasLayoutSenhaAlinhaEsquerda: TSpeedButton;
    btnChamadaDeSenhasLayoutSenhaAlinhaCentro: TSpeedButton;
    btnChamadaDeSenhasLayoutSenhaAlinhaDireita: TSpeedButton;
    edChamadaDeSenhasLayoutSenhaX: TDBEdit;
    edChamadaDeSenhasLayoutSenhaY: TDBEdit;
    edChamadaDeSenhasLayoutSenhaLarg: TDBEdit;
    edChamadaDeSenhasLayoutSenhaAlt: TDBEdit;
    chkChamadaDeSenhasLayoutMostrarSenha: TDBCheckBox;
    groupChamadaDeSenhasLayoutPA: TGroupBox;
    Label34: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    btnChamadaDeSenhasLayoutPAAlinhaEsquerda: TSpeedButton;
    btnChamadaDeSenhasLayoutPAAlinhaCentro: TSpeedButton;
    btnChamadaDeSenhasLayoutPAAlinhaDireita: TSpeedButton;
    edChamadaDeSenhasLayoutPAX: TDBEdit;
    edChamadaDeSenhasLayoutPAY: TDBEdit;
    edChamadaDeSenhasLayoutPALarg: TDBEdit;
    edChamadaDeSenhasLayoutPAAlt: TDBEdit;
    chkChamadaDeSenhasLayoutMostrarPA: TDBCheckBox;
    groupChamadaDeSenhasLayoutNomeCliente: TGroupBox;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    btnChamadaDeSenhasLayoutNomeClienteAlinhaEsquerda: TSpeedButton;
    btnChamadaDeSenhasLayoutNomeClienteAlinhaCentro: TSpeedButton;
    btnChamadaDeSenhasLayoutNomeClienteAlinhaDireita: TSpeedButton;
    edChamadaDeSenhasLayoutNomeClienteX: TDBEdit;
    edChamadaDeSenhasLayoutNomeClienteY: TDBEdit;
    edChamadaDeSenhasLayoutNomeClienteLarg: TDBEdit;
    edChamadaDeSenhasLayoutNomeClienteAlt: TDBEdit;
    chkChamadaDeSenhasLayoutMostrarNomeCliente: TDBCheckBox;
    tbsTV: TTabSheet;
    OLDpnlTV: TGroupBox;
    Label24: TLabel;
    Label31: TLabel;
    grbVsVideoCaptureDevice: TGroupBox;
    Label25: TLabel;
    Label104: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    cboVideoInputs: TDBComboBox;
    cboVideoDevices: TDBComboBox;
    cboVideoSubtypes: TDBComboBox;
    cboVideoSizes: TDBComboBox;
    cboAnalogVideoStandard: TDBComboBox;
    grbPreview: TGroupBox;
    btnStartPreview: TBitBtn;
    btnStopPreview: TBitBtn;
    grbAudioCaptureDevice: TGroupBox;
    Label27: TLabel;
    Label49: TLabel;
    Label36: TLabel;
    cboAudioDevices: TDBComboBox;
    cboAudioInputs: TDBComboBox;
    tbrAudioInputLevel: TTrackBar;
    tbrAudioInputBalance: TTrackBar;
    grbAudioRendering: TGroupBox;
    Label28: TLabel;
    Label29: TLabel;
    tbrAudioVolume: TTrackBar;
    tbrAudioBalance: TTrackBar;
    cboAudioRenderers: TDBComboBox;
    dblkpCanalPadrao: TDBLookupComboBox;
    edtIdTV: TDBEdit;
    pnlTV: TGroupBox;
    Label3: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    lblNome: TLabel;
    lblResolucao: TLabel;
    lblResolucaoPadrao: TLabel;
    lblVolume: TLabel;
    cboSoftwaresHomologados: TComboBox;
    edCaminhoExecutavel: TDBEdit;
    edNomeJanela: TDBEdit;
    cbxDispositivo: TDBComboBox;
    cbxResolucao: TDBComboBox;
    edResolucaoPadrao: TDBEdit;
    trckVolume: TTrackBar;
    tbsImagem: TTabSheet;
    pnlImagem: TGroupBox;
    Label6: TLabel;
    tbsUltimasChamadas: TTabSheet;
    pnlUltimasChamadas: TGroupBox;
    grpUltimasChamadasFonte: TGroupBox;
    btnUltimasChamadasNegrito: TJvSpeedButton;
    btnUltimasChamadasItalico: TJvSpeedButton;
    btnUltimasChamadasSublinhado: TJvSpeedButton;
    cmbUltimasChamadasFonte: TJvFontComboBox;
    cmbUltimasChamadasFontSize: TDBComboBox;
    cmbUltimasChamadasFontColor: TJvOfficeColorButton;
    groupUltimasChamadasPAsPermitidas: TGroupBox;
    edUltimasChamadasPASPermitidas: TDBEdit;
    groupUltimasChamadasLayout: TGroupBox;
    Label7: TLabel;
    Label52: TLabel;
    Label59: TLabel;
    groupUltimasChamadasLayoutSenha: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    btnUltimasChamadasLayoutSenhaAlinhaEsquerda: TSpeedButton;
    btnUltimasChamadasLayoutSenhaAlinhaCentro: TSpeedButton;
    btnUltimasChamadasLayoutSenhaAlinhaDireita: TSpeedButton;
    edUltimasChamadasLayoutSenhaX: TDBEdit;
    edUltimasChamadasLayoutSenhaY: TDBEdit;
    edUltimasChamadasLayoutSenhaLarg: TDBEdit;
    edUltimasChamadasLayoutSenhaAlt: TDBEdit;
    chkUltimasChamadasLayoutMostrarSenha: TDBCheckBox;
    groupUltimasChamadasLayoutPA: TGroupBox;
    Label13: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    btnUltimasChamadasLayoutPAAlinhaEsquerda: TSpeedButton;
    btnUltimasChamadasLayoutPAAlinhaCentro: TSpeedButton;
    btnUltimasChamadasLayoutPAAlinhaDireita: TSpeedButton;
    edUltimasChamadasLayoutPAX: TDBEdit;
    edUltimasChamadasLayoutPAY: TDBEdit;
    edUltimasChamadasLayoutPALarg: TDBEdit;
    edUltimasChamadasLayoutPAAlt: TDBEdit;
    chkUltimasChamadasLayoutMostrarPA: TDBCheckBox;
    groupUltimasChamadasLayoutNomeCliente: TGroupBox;
    Label47: TLabel;
    Label48: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    btnUltimasChamadasLayoutNomeClienteAlinhaEsquerda: TSpeedButton;
    btnUltimasChamadasLayoutNomeClienteAlinhaCentro: TSpeedButton;
    btnUltimasChamadasLayoutNomeClienteAlinhaDireita: TSpeedButton;
    edUltimasChamadasLayoutNomeClienteX: TDBEdit;
    edUltimasChamadasLayoutNomeClienteY: TDBEdit;
    edUltimasChamadasLayoutNomeClienteLarg: TDBEdit;
    edUltimasChamadasLayoutNomeClienteAlt: TDBEdit;
    chkUltimasChamadasLayoutMostrarNomeCliente: TDBCheckBox;
    groupUltimasChamadasLayoutDisposicao: TGroupBox;
    rbUltimasChamadasDisposicaoEmLinhas: TRadioButton;
    rbUltimasChamadasDisposicaoEmColunas: TRadioButton;
    edUltimasChamadasQuantidade: TDBEdit;
    edUltimasChamadasEspacamento: TDBEdit;
    edUltimasChamadasAtraso: TDBEdit;
    tbsDataHora: TTabSheet;
    pnlDataHora: TGroupBox;
    groupDataHoraFonte: TGroupBox;
    btnDataHoraNegrito: TJvSpeedButton;
    btnDataHoraItalico: TJvSpeedButton;
    btnDataHoraSublinhado: TJvSpeedButton;
    cmbDataHoraFonte: TJvFontComboBox;
    cmbDataHoraFontSize: TDBComboBox;
    cmbDataHoraFontColor: TJvOfficeColorButton;
    groupDataHoraOutras: TGroupBox;
    Label8: TLabel;
    edDataHoraFormato: TDBEdit;
    groupDataHoraMargens: TGroupBox;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    edDataHoraMargemSuperior: TDBEdit;
    edDataHoraMargemInferior: TDBEdit;
    edDataHoraMargemEsquerda: TDBEdit;
    edDataHoraMargemDireita: TDBEdit;
    tbsVideo: TTabSheet;
    pnlVideo: TGroupBox;
    lblTempoAlternancia: TLabel;
    lstVideoFileNames: TListBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    btnSubir: TBitBtn;
    btnDescer: TBitBtn;
    edtTempoAlternancia: TDBEdit;
    tbsFlash: TTabSheet;
    pnlFlash: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    edFlashRefresh: TDBEdit;
    edFlashFileName: TDBEdit;
    tbsJornalEletronico: TTabSheet;
    GroupBox3: TGroupBox;
    Label30: TLabel;
    groupJornalEletronicoFonte: TGroupBox;
    btnJornalEletronicoNegrito: TJvSpeedButton;
    btnJornalEletronicoItalico: TJvSpeedButton;
    btnJornalEletronicoSublinhado: TJvSpeedButton;
    cmbJornalEletronicoFonte: TJvFontComboBox;
    cmbJornalEletronicoFontSize: TDBComboBox;
    cmbJornalEletronicoFontColor: TJvOfficeColorButton;
    edtJornalEletronicoInterval: TDBEdit;
    tbsIndicadoresDePerformance: TTabSheet;
    GroupBox7: TGroupBox;
    Label22: TLabel;
    edHTMLFileName: TDBEdit;
    chkCorDaFonteAcompanhaNivelPI: TDBCheckBox;
    GroupBox1: TGroupBox;
    lblIndicador: TLabel;
    lblArquivoSomPI: TLabel;
    edtIndicador: TDBEdit;
    edtSomPI: TDBEdit;
    tbsPlayListManager: TTabSheet;
    GroupBox2: TGroupBox;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    lblBancoDados: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    Label63: TLabel;
    edtIDTVPlayListManager: TDBEdit;
    cbTipoBancoPlayList: TDBComboBox;
    edtHostBancoPlayList: TDBEdit;
    edtPortaBancoPlayList: TDBEdit;
    edtNomeArquivoBancoPlayList: TDBEdit;
    edtUsuarioBancoPlayList: TDBEdit;
    edtSenhaBancoPlayList: TDBEdit;
    edtDiretorioLocalPlayList: TDBEdit;
    edtIntervaloVerificacaoPlayList: TDBEdit;
    cdsPaineis: TClientDataSet;
    dscPaineis: TDataSource;
    qryPaineis: TFDQuery;
    dspPaineis: TDataSetProvider;
    DTS: TDataSource;
    CDSModulosID: TIntegerField;
    CDSModulosTIPO: TIntegerField;
    CDSModulosNOME: TStringField;
    grpCodigoBarras: TGroupBox;
    lblPortaLCDB: TLabel;
    chkUtilizarLeitorCodigoBarras: TDBCheckBox;
    edtPortaLCDB: TDBEdit;
    edtID_PA: TDBEdit;
    lblID_PA: TLabel;
    chkMostrarNomeCliente: TDBCheckBox;
    DBCheckBox1: TDBCheckBox;
    DBCheckBox2: TDBCheckBox;
    edtGrupoIndicadoresPermitidos: TDBEdit;
    btnGrupoIndicadoresPermitidos: TButton;
    lblGrupoIndicadoresPermitidos: TLabel;
    edtPortaIPPainel: TDBEdit;
    lblColunasFilas: TLabel;
    CDSConfigID: TIntegerField;
    CDSConfigCHAMADAINTERROMPEVIDEO: TStringField;
    CDSConfigMAXIMIZARMONITOR1: TStringField;
    CDSConfigMAXIMIZARMONITOR2: TStringField;
    CDSConfigFUNCIONASABADO: TStringField;
    CDSConfigFUNCIONADOMINGO: TStringField;
    CDSConfigUSECODEBAR: TStringField;
    CDSConfigIDPAINEL: TIntegerField;
    CDSConfigIDTV: TIntegerField;
    CDSConfigPORTAIPPAINEL: TIntegerField;
    CDSConfigLASTMUTE: TIntegerField;
    CDSConfigVOLUME: TIntegerField;
    CDSConfigDEM: TIntegerField;
    CDSConfigATEM: TIntegerField;
    CDSConfigCODEBARPORT: TStringField;
    CDSConfigINDICADORESPERMITIDOS: TStringField;
    CDSConfigDEH: TIntegerField;
    CDSConfigATEH: TIntegerField;
    btnPASPermitidos: TButton;
    DBEdit1: TDBEdit;
    Label65: TLabel;
    GroupBox4: TGroupBox;
    chkFuncionaDomingo: TDBCheckBox;
    edAteM: TDBEdit;
    edAteH: TDBEdit;
    edDeM: TDBEdit;
    edDeH: TDBEdit;
    chkFuncionaSabado: TDBCheckBox;
    Label64: TLabel;
    Label66: TLabel;
    Label67: TLabel;
    Label68: TLabel;
    btnFlashFilName: TSpeedButton;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    menuPopup: TPopupMenu;
    menuQuadroChamadaSenhas: TMenuItem;
    menuQuadroUltimasChamadas: TMenuItem;
    menuImagem: TMenuItem;
    menuFlash: TMenuItem;
    menuDataHora: TMenuItem;
    menuVideo: TMenuItem;
    V1: TMenuItem;
    JornalEletrnico1: TMenuItem;
    Indicadordeperformance1: TMenuItem;
    MmPlaylistManager: TMenuItem;
    Button3: TButton;
    OpenDialog1: TOpenDialog;
    btnHTMLFileName: TSpeedButton;
    DBGrid1: TDBGrid;
    CDSModulosID_UNIDADE: TIntegerField;
    CDSConfigID_UNIDADE: TIntegerField;
    cdsPaineisID: TIntegerField;
    cdsPaineisTIPO: TIntegerField;
    cdsPaineisBACKGROUNDFILE: TStringField;
    cdsPaineisFONTE: TStringField;
    cdsPaineisARQUIVOSOM: TStringField;
    cdsPaineisFLASHFILE: TStringField;
    cdsPaineisCAMINHODOEXECUTAVEL: TStringField;
    cdsPaineisNOMEDAJANELA: TStringField;
    cdsPaineisRESOLUCAOPADRAO: TStringField;
    cdsPaineisARQUIVOSVIDEO: TStringField;
    cdsPaineisHOSTBANCO: TStringField;
    cdsPaineisPORTABANCO: TStringField;
    cdsPaineisNOMEARQUIVOBANCO: TStringField;
    cdsPaineisUSUARIOBANCO: TStringField;
    cdsPaineisSENHABANCO: TStringField;
    cdsPaineisDIRETORIOLOCAL: TStringField;
    cdsPaineisLAYOUTSENHAX: TIntegerField;
    cdsPaineisLAYOUTSENHAY: TIntegerField;
    cdsPaineisLAYOUTSENHALARG: TIntegerField;
    cdsPaineisLAYOUTSENHAALT: TIntegerField;
    cdsPaineisLAYOUTPAX: TIntegerField;
    cdsPaineisLAYOUTPAY: TIntegerField;
    cdsPaineisLAYOUTPALARG: TIntegerField;
    cdsPaineisLAYOUTPAALT: TIntegerField;
    cdsPaineisLAYOUTNOMECLIENTEX: TIntegerField;
    cdsPaineisLAYOUTNOMECLIENTEY: TIntegerField;
    cdsPaineisLAYOUTNOMECLIENTELARG: TIntegerField;
    cdsPaineisLAYOUTNOMECLIENTEALT: TIntegerField;
    cdsPaineisQUANTIDADE: TStringField;
    cdsPaineisATRASO: TStringField;
    cdsPaineisESPACAMENTO: TStringField;
    cdsPaineisPASPERMITIDAS: TStringField;
    cdsPaineisMARGEMSUPERIOR: TIntegerField;
    cdsPaineisMARGEMINFERIOR: TIntegerField;
    cdsPaineisMARGEMESQUERDA: TIntegerField;
    cdsPaineisMARGEMDIREITA: TIntegerField;
    cdsPaineisFORMATO: TStringField;
    cdsPaineisNOMEARQUIVOHTML: TStringField;
    cdsPaineisINDICADORSOMPI: TStringField;
    cdsPaineisARQUIVOSOMPI: TStringField;
    cdsPaineisLEFT: TIntegerField;
    cdsPaineisTOP: TIntegerField;
    cdsPaineisHEIGHT: TIntegerField;
    cdsPaineisCOLOR: TIntegerField;
    cdsPaineisFONTESIZE: TIntegerField;
    cdsPaineisFONTECOLOR: TIntegerField;
    cdsPaineisSOFTWAREHOMOLOGADO: TIntegerField;
    cdsPaineisDISPOSITIVO: TIntegerField;
    cdsPaineisRESOLUCAO: TIntegerField;
    cdsPaineisTEMPOALTERNANCIA: TIntegerField;
    cdsPaineisIDTVPLAYLISTMANAGER: TIntegerField;
    cdsPaineisTIPOBANCO: TIntegerField;
    cdsPaineisINTERVALOVERIFICACAO: TIntegerField;
    cdsPaineisLAYOUTSENHAALINHAMENTO: TIntegerField;
    cdsPaineisLAYOUTPAALINHAMENTO: TIntegerField;
    cdsPaineisLAYOUTNOMECLIENTEALINHAMENTO: TIntegerField;
    cdsPaineisSOMVOZCHAMADA0: TIntegerField;
    cdsPaineisSOMVOZCHAMADA1: TIntegerField;
    cdsPaineisSOMVOZCHAMADA2: TIntegerField;
    cdsPaineisVOICEINDEX: TIntegerField;
    cdsPaineisATUALIZACAOPLAYLIST: TDateField;
    cdsPaineisTRANSPARENT: TStringField;
    cdsPaineisNEGRITO: TStringField;
    cdsPaineisITALICO: TStringField;
    cdsPaineisSUBLINHADO: TStringField;
    cdsPaineisMOSTRARSENHA: TStringField;
    cdsPaineisMOSTRARPA: TStringField;
    cdsPaineisMOSTRARNOMECLIENTE: TStringField;
    cdsPaineisSOMARQUIVO: TStringField;
    cdsPaineisSOMVOZ: TStringField;
    cdsPaineisSOMVOZCHAMADA1MARCADO: TStringField;
    cdsPaineisSOMVOZCHAMADA2MARCADO: TStringField;
    cdsPaineisSOMVOZCHAMADA3MARCADO: TStringField;
    cdsPaineisDISPOSICAOLINHAS: TStringField;
    cdsPaineisVALORACOMPANHACORDONIVEL: TStringField;
    cdsPaineisID_MODULO_TV: TIntegerField;
    cdsPaineisccNOME: TStringField;
    cdsPaineisWIDTH: TIntegerField;
    cdsPaineisID_UNIDADE: TIntegerField;
    procedure cboNomePAClick(Sender: TObject);
    procedure chkModoTerminalServerClick(Sender: TObject);
    procedure edtPAsPermitidasKeyPress(Sender: TObject; var Key: Char);
    procedure edtPAsPermitidasExit(Sender: TObject);
    procedure chkManualRedirectClick(Sender: TObject);
    procedure chkVisualizarProcessosParalelosClick(Sender: TObject);
    procedure chkUtilizarLeitorCodigoBarrasClick(Sender: TObject);
    procedure lstQuadrosClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cdsPaineisCalcFields(DataSet: TDataSet);
    procedure cdsPaineisAfterScroll(DataSet: TDataSet);
    procedure CDSModulosAfterScroll(DataSet: TDataSet);
    procedure FormActivate(Sender: TObject);
    procedure btnNovaConfigClick(Sender: TObject);
    procedure btnGrupoIndicadoresPermitidosClick(Sender: TObject);
    procedure btnPASPermitidosClick(Sender: TObject);
    procedure MmPlaylistManagerClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure cboSoftwaresHomologadosChange(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure btnSubirClick(Sender: TObject);
    procedure btnDescerClick(Sender: TObject);
    procedure btnFlashFilNameClick(Sender: TObject);
    procedure btnHTMLFileNameClick(Sender: TObject);
  protected
    function PermiteCopiarField(const aField: TField): Boolean; Override;
    procedure SetDefaultConfig; Override;
    procedure PrepareDataSet; Override;
    function GetTipoModulo: TModuloSics; Override;
    procedure HabilitaBotoes; Override;
    function CarregarDadosPainel : boolean;  //GOT
    function SalvarDadosPainel : boolean;  //GOT
    //function GetDataSetFormPrincipal: TClientDataSet; override;
    function GetDataSetFormPrincipal: TClientDataSet; Override;
  public
    { Public declarations }
  end;

var
  FrmConfiguracoesSicsTV: TFrmConfiguracoesSicsTV;

const
  TTipoDePainelStr: array[TTipoDePainel] of string = (
    'Tela',
    'Chamada de Senhas',
    'Últimas Chamadas',
    'Imagem',
    'Flash',
    'Data e Hora',
    'Video',
    'TV',
    'Jornal Eletrônico',
    'Indicador de Performance',
    'Playlist Manager');

  TTipoChamadaPorVozStr : array[TTipoChamadaPorVoz] of string = (
    'Número da senha',
    'Nome da PA',
    'Nome do cliente');

implementation

uses sics_94, System.Math, System.StrUtils;

{$R *.dfm}

function SoftwarePadraoTV(AID: Integer): Boolean;
const //1- AverTV, 5-SichboPVR
  IDS_SOFTWAREPADRAO = [1, 5];
begin
  Result := AID in IDS_SOFTWAREPADRAO;
end;

{function TFrmConfiguracoesSicsTV.GetDataSetFormPrincipal: TClientDataSet;
begin
  Result := dmSicsMain.cdsSicsTV;
end;}

function TFrmConfiguracoesSicsTV.GetDataSetFormPrincipal: TClientDataSet;
begin
  Result := dmSicsMain.cdsSicsTV;
end;

function TFrmConfiguracoesSicsTV.GetTipoModulo: TModuloSics;
begin
  Result := TModuloSics.msTV;
end;

procedure TFrmConfiguracoesSicsTV.BitBtn1Click(Sender: TObject);
begin
  inherited;
  if OpenDialog1.Execute then
    if lstVideoFileNames.Items.IndexOf(OpenDialog1.FileName) >= 0 then
      MessageDlg('Este vídeo já está na lista', mtError, [mbOk], 0)
    else
      lstVideoFileNames.Items.Add(OpenDialog1.FileName);
end;

procedure TFrmConfiguracoesSicsTV.BitBtn2Click(Sender: TObject);
begin
  inherited;
  if lstVideoFileNames.ItemIndex >= 0 then
    if MessageDlg('Confirma a exlcusão deste item?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      lstVideoFileNames.DeleteSelected;
end;

procedure TFrmConfiguracoesSicsTV.btnDescerClick(Sender: TObject);
var
  NewIndex: Integer;
begin
  if lstVideoFileNames.ItemIndex < lstVideoFileNames.Count -1 then
  begin
    NewIndex := lstVideoFileNames.ItemIndex + 1;
    lstVideoFileNames.Items.Move(lstVideoFileNames.ItemIndex, NewIndex);
    lstVideoFileNames.ItemIndex := NewIndex;
  end;
end;

procedure TFrmConfiguracoesSicsTV.btnFlashFilNameClick(Sender: TObject);
begin
  inherited;
  if OpenDialog1.Execute then
    edFlashFileName.Text := OpenDialog1.FileName;
end;

procedure TFrmConfiguracoesSicsTV.btnGrupoIndicadoresPermitidosClick(
  Sender: TObject);
begin
  CarregaGrupos(lblGrupoIndicadoresPermitidos, 'PIS');
end;

procedure TFrmConfiguracoesSicsTV.btnHTMLFileNameClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    edHTMLFileName.Text := OpenDialog1.FileName;
end;

procedure TFrmConfiguracoesSicsTV.btnNovaConfigClick(Sender: TObject);
begin
  CDSModulos.AfterScroll := nil;
  inherited;
  CDSModulos.AfterScroll := CDSModulosAfterScroll;
  CDSModulos.First;
end;

procedure TFrmConfiguracoesSicsTV.btnPASPermitidosClick(Sender: TObject);
begin
  CarregaGrupos(edChamadaSenhasPASPermitidas, 'PAS', 'PAS Permitidas');
end;

procedure TFrmConfiguracoesSicsTV.btnSalvarClick(Sender: TObject);
begin
  inherited;
  SalvarDadosPainel;
  cdsPaineis.ApplyUpdates(0);
end;

procedure TFrmConfiguracoesSicsTV.btnSubirClick(Sender: TObject);
var
  NewIndex: Integer;
begin
  if lstVideoFileNames.ItemIndex >= 1 then
  begin
    NewIndex := lstVideoFileNames.ItemIndex - 1;
    lstVideoFileNames.Items.Move(lstVideoFileNames.ItemIndex, NewIndex);
    lstVideoFileNames.ItemIndex := NewIndex;
  end;
end;

procedure TFrmConfiguracoesSicsTV.Button2Click(Sender: TObject);
begin
  inherited;
  cdsPaineis.Delete;
end;

procedure TFrmConfiguracoesSicsTV.Button3Click(Sender: TObject);
begin
  CarregaGrupos(edUltimasChamadasPASPermitidas, 'PAS', 'PAS Permitidas');
end;

procedure TFrmConfiguracoesSicsTV.cboNomePAClick(Sender: TObject);
begin
  ModoEdicaoDataSet;

end;

procedure TFrmConfiguracoesSicsTV.cboSoftwaresHomologadosChange(
  Sender: TObject);
begin
  inherited;
  case (Sender as TComboBox).ItemIndex of
    0 : begin
          edCaminhoExecutavel.Clear;
          edNomeJanela       .Clear;
          edResolucaoPadrao  .Clear;
          edCaminhoExecutavel.Enabled := true;
          edNomeJanela       .Enabled := true;
          cbxResolucao       .Enabled := False;
          cbxDispositivo     .Enabled := False;
          cbxResolucao       .ItemIndex := -1;
          cbxDispositivo     .ItemIndex := -1;
          edResolucaoPadrao  .Enabled := False;
          lblVolume          .Visible := False;
          trckVolume         .Visible := False;
        end;
    1 : begin
          edCaminhoExecutavel.Text := 'C:\Program Files (x86)\AVerMedia\AVerTV 3D\AVerTV.exe';
          edNomeJanela       .Text := 'AverTV - Vídeo';
          edResolucaoPadrao  .Text := '0x0';
        end;

    2 : begin
          edCaminhoExecutavel.Text := 'C:\Program Files (x86)\VideoLAN\VLC\vlc.exe';
          edNomeJanela       .Text := 'Reprodutor de Mídias VLC';
          edResolucaoPadrao  .Clear;
        end;
    3 : begin
          edCaminhoExecutavel.Clear;
          edNomeJanela       .Clear;
          edCaminhoExecutavel.Enabled := False;
          edNomeJanela       .Enabled := False;
          cbxDispositivo     .Enabled := True;
          cbxResolucao       .ItemIndex := -1;
          cbxDispositivo     .ItemIndex := -1;
          edResolucaoPadrao  .Enabled := False;
          lblVolume          .Visible := False;
          trckVolume         .Visible := False;
        end;
    4,6 : begin
          edCaminhoExecutavel.Clear;
          edNomeJanela       .Clear;
          edCaminhoExecutavel.Enabled := False;
          edNomeJanela       .Enabled := False;
          cbxDispositivo     .Enabled := True;
          cbxResolucao       .ItemIndex := -1;
          cbxDispositivo     .ItemIndex := -1;
          edResolucaoPadrao  .Enabled := False;
          lblVolume          .Visible := True;
          trckVolume         .Visible := True;
        end;
    5 : begin
          edCaminhoExecutavel.Text    := 'SicsLiveTV.exe';
          edNomeJanela       .Text    := 'SICS LIVETV';
          edResolucaoPadrao  .Clear;
        end;
  end;
end;

procedure TFrmConfiguracoesSicsTV.CDSModulosAfterScroll(DataSet: TDataSet);
begin
  inherited;
  cdsPaineis.Filtered := False;
  cdsPaineis.Filter   := 'ID_MODULO_TV=' + IntToStr(CDSModulosID.AsInteger);
  cdsPaineis.Filtered := True;
end;

procedure TFrmConfiguracoesSicsTV.cdsPaineisAfterScroll(DataSet: TDataSet);
begin
  Application.ProcessMessages;
  if (cdsPaineisTIPO.AsString='') then Exit;
  tbsChamadaSenhas           .TabVisible := (TTipoDePainel(cdsPaineisTIPO.AsInteger) = tpChamadaSenha);
  tbsUltimasChamadas         .TabVisible := (TTipoDePainel(cdsPaineisTIPO.AsInteger) = tpUltimasSenhas);
  tbsImagem                  .TabVisible := (TTipoDePainel(cdsPaineisTIPO.AsInteger) = tpImagem              );
  tbsFlash                   .TabVisible := (TTipoDePainel(cdsPaineisTIPO.AsInteger) = tpFlash               );
  tbsDataHora                .TabVisible := (TTipoDePainel(cdsPaineisTIPO.AsInteger) = tpDataHora            );
  tbsVideo                   .TabVisible := (TTipoDePainel(cdsPaineisTIPO.AsInteger) = tpVideo               ) or (TTipoDePainel(cdsPaineisTIPO.AsInteger) = tpTV);
  tbsJornalEletronico        .TabVisible := (TTipoDePainel(cdsPaineisTIPO.AsInteger) = tpJornalEletronico    );
  tbsTV                      .TabVisible := (TTipoDePainel(cdsPaineisTIPO.AsInteger) = tpTV                  );
  tbsIndicadoresDePerformance.TabVisible := (TTipoDePainel(cdsPaineisTIPO.AsInteger) = tpIndicadorPerformance);
  tbsPlayListManager.TabVisible          := (TTipoDePainel(cdsPaineisTIPO.AsInteger) = tpPlayListManager);

  CarregarDadosPainel;
end;

procedure TFrmConfiguracoesSicsTV.cdsPaineisCalcFields(DataSet: TDataSet);
begin
  inherited;
  cdsPaineisccNOME.AsString := TTipoDePainelStr[TTipoDePainel(cdsPaineisTIPO.AsInteger)] + ' - Panel' + IntToStr(cdsPaineis.RecNo);
end;

procedure TFrmConfiguracoesSicsTV.chkManualRedirectClick(Sender: TObject);
begin
  inherited;
  HabilitaBotoes;
end;

procedure TFrmConfiguracoesSicsTV.chkModoTerminalServerClick(Sender: TObject);
begin
  inherited;
  HabilitaBotoes;
end;

procedure TFrmConfiguracoesSicsTV.chkUtilizarLeitorCodigoBarrasClick(Sender: TObject);
begin
  inherited;
  HabilitaBotoes;
end;

procedure TFrmConfiguracoesSicsTV.chkVisualizarProcessosParalelosClick (Sender: TObject);
begin
  inherited;
  HabilitaBotoes;
end;

procedure TFrmConfiguracoesSicsTV.HabilitaBotoes;
begin
  inherited;

 { lblFilasPermitidas.Enabled := chkManualRedirect.Checked;
  edtFilasPermitidas.Enabled := lblFilasPermitidas.Enabled;
  btnFilasPermitidas.Enabled := lblFilasPermitidas.Enabled;

  lblGruposProcessosParalelosPermitidos.Enabled := chkVisualizarProcessosParalelos.Checked;
  edtGruposProcessosParalelosPermitidos.Enabled := lblGruposProcessosParalelosPermitidos.Enabled;
  btnGruposProcessosParalelosPermitidos.Enabled := lblGruposProcessosParalelosPermitidos.Enabled;

  lblPortaLCDB.Enabled := chkUtilizarLeitorCodigoBarras.Checked;
  edtPortaLCDB.Enabled := lblPortaLCDB.Enabled;

  lblPAsPermitidas.Enabled := chkModoTerminalServer.Checked;
  edtPAsPermitidas.Enabled := lblPAsPermitidas.Enabled;
  btnPasPermitidas.Enabled := lblPAsPermitidas.Enabled;

  lblID_PA.Enabled  := not lblPAsPermitidas.Enabled;
  edtID_PA.Enabled  := lblID_PA.Enabled;
  Label2.Enabled    := lblID_PA.Enabled;
  cboNomePA.Enabled := lblID_PA.Enabled;    }

//  if((not chkModoTerminalServer.Checked) and (dtsConfig.DataSet.State in [dsEdit,dsInsert]))then
//    dtsConfig.DataSet.FieldByName('PAS_PERMITIDAS').Value := '';
end;

procedure TFrmConfiguracoesSicsTV.lstQuadrosClick(Sender: TObject);
begin
  //vPanel := TjvPanel(FindComponent(sName));
  //vgPainelSelecionado := vPanel.Tag;

  //GetPanelProperties(vPanel);
  cdsPaineisAfterScroll(nil);
end;

procedure TFrmConfiguracoesSicsTV.MmPlaylistManagerClick(Sender: TObject);
begin
  inherited;

  cdsPaineis.Append;
  cdsPaineisID.AsInteger           := NGetNextGenerator('GEN_MODULOS_TV_PAINEIS_ID', dmSicsMain.connOnLine);
  cdsPaineisTIPO.AsInteger         := (Sender as TMenuItem).Tag;
  cdsPaineisID_MODULO_TV.AsInteger := CDSConfigID.AsInteger;
  cdsPaineis.Post;

  cdsPaineisAfterScroll(cdsPaineis);
end;

function TFrmConfiguracoesSicsTV.PermiteCopiarField(const aField: TField): Boolean;
begin
  Result := inherited PermiteCopiarField(aField) and (aField.FieldName <> 'ID');
end;

procedure TFrmConfiguracoesSicsTV.PrepareDataSet;
begin
  qryNomePA.Close;
  cdsNomePA.Open;
  qryPaineis.Close;
  cdsPaineis.Open;
  Application.ProcessMessages;

  inherited;
end;

procedure TFrmConfiguracoesSicsTV.edtPAsPermitidasExit(Sender: TObject);
begin
  inherited;
  VerificaSequenciaNumeros(Sender);
end;

procedure TFrmConfiguracoesSicsTV.edtPAsPermitidasKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  SomenteNumeros(Key);
end;

procedure TFrmConfiguracoesSicsTV.FormActivate(Sender: TObject);
begin
  inherited;
  CDSModulos.AfterScroll := CDSModulosAfterScroll;
  CDSModulos.First;
end;

procedure TFrmConfiguracoesSicsTV.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  cdsPaineis.Close;
  inherited;
end;

procedure TFrmConfiguracoesSicsTV.SetDefaultConfig;
begin
  inherited;
//  cboNomePA.KeyValue := CDSConfig.FieldByName('ID').Value;
end;

function TFrmConfiguracoesSicsTV.CarregarDadosPainel : boolean;  //GOT
begin
  cmbBackgroundColor.SelectedColor := StrToIntDef(cdsPaineisCOLOR.AsString, 0);

  case TTipoDePainel(cdsPaineisTIPO.AsInteger) of
    tpChamadaSenha:
    begin
       try
         case cdsPaineisLAYOUTSENHAALINHAMENTO.Value of
           1  : btnChamadaDeSenhasLayoutSenhaAlinhaCentro  .Down := true;
           2  : btnChamadaDeSenhasLayoutSenhaAlinhaDireita .Down := true;
           else btnChamadaDeSenhasLayoutSenhaAlinhaEsquerda.Down := true;
         end;
         case cdsPaineisLAYOUTPAALINHAMENTO.AsInteger of
           1  : btnChamadaDeSenhasLayoutPAAlinhaCentro  .Down := true;
           2  : btnChamadaDeSenhasLayoutPAAlinhaDireita .Down := true;
           else btnChamadaDeSenhasLayoutPAAlinhaEsquerda.Down := true;
         end;
         case cdsPaineisLAYOUTNOMECLIENTEALINHAMENTO.AsInteger of
           1  : btnChamadaDeSenhasLayoutNomeClienteAlinhaCentro  .Down := true;
           2  : btnChamadaDeSenhasLayoutNomeClienteAlinhaDireita .Down := true;
           else btnChamadaDeSenhasLayoutNomeClienteAlinhaEsquerda.Down := true;
         end;

         lstVozChamada.Items.Clear;
         lstVozChamada.Items.Add(TTipoChamadaPorVozStr[TTipoChamadaPorVoz(cdsPaineisSomVozChamada0.AsInteger)]);
         lstVozChamada.Items.Add(TTipoChamadaPorVozStr[TTipoChamadaPorVoz(cdsPaineisSomVozChamada1.AsInteger)]);
         lstVozChamada.Items.Add(TTipoChamadaPorVozStr[TTipoChamadaPorVoz(cdsPaineisSomVozChamada2.AsInteger)]);
         lstVozChamada.Checked[0]             := cdsPaineisSOMVOZCHAMADA1MARCADO.AsString = 'T';
         lstVozChamada.Checked[1]             := cdsPaineisSOMVOZCHAMADA2MARCADO.AsString = 'T';
         lstVozChamada.Checked[2]             := cdsPaineisSOMVOZCHAMADA3MARCADO.AsString = 'T';
       finally

       end;

       cmbChamadaSenhasFonte     .FontName      := cdsPaineisFONTE.AsString;
       cmbChamadaSenhasFontSize  .Text          := cdsPaineisFONTESIZE.AsString;
       cmbChamadaSenhasFontColor .SelectedColor := StrToIntDef(cdsPaineisFONTECOLOR.AsString, 0);
       btnChamadaSenhasNegrito   .Down          := cdsPaineisNEGRITO.asstring = 'T';
       btnChamadaSenhasItalico   .Down          := cdsPaineisITALICO.asstring = 'T';
       btnChamadaSenhasSublinhado.Down          := cdsPaineisSUBLINHADO.asstring = 'T';
       // 27/06 - Aqui pegar a lista de videos do Ini ou Variavel Global
     end;

    tpUltimasSenhas:
      begin
       try
         case cdsPaineisLayoutSenhaAlinhamento.AsInteger of
           1  : btnUltimasChamadasLayoutSenhaAlinhaCentro  .Down := true;
           2  : btnUltimasChamadasLayoutSenhaAlinhaDireita .Down := true;
           else btnUltimasChamadasLayoutSenhaAlinhaEsquerda.Down := true;
         end;
         case cdsPaineisLayoutPAAlinhamento.AsInteger of
           1  : btnUltimasChamadasLayoutPAAlinhaCentro  .Down := true;
           2  : btnUltimasChamadasLayoutPAAlinhaDireita .Down := true;
           else btnUltimasChamadasLayoutPAAlinhaEsquerda.Down := true;
         end;
         case cdsPaineisLayoutNomeClienteAlinhamento.AsInteger of
           1  : btnUltimasChamadasLayoutNomeClienteAlinhaCentro  .Down := true;
           2  : btnUltimasChamadasLayoutNomeClienteAlinhaDireita .Down := true;
           else btnUltimasChamadasLayoutNomeClienteAlinhaEsquerda.Down := true;
         end;
       finally

       end;

       cmbUltimasChamadasFonte.FontName             := cdsPaineisFONTE.AsString;
       cmbUltimasChamadasFontSize.Text              := cdsPaineisFONTESIZE.AsString;
       cmbUltimasChamadasFontColor.SelectedColor    := cdsPaineisFONTECOLOR.AsInteger;
       btnUltimasChamadasNegrito.Down               := cdsPaineisNEGRITO.AsString = 'T';
       btnUltimasChamadasItalico.Down               := cdsPaineisITALICO.AsString = 'T';
       btnUltimasChamadasSublinhado.Down            := cdsPaineisSUBLINHADO.AsString = 'T';
       rbUltimasChamadasDisposicaoEmLinhas.Checked  := cdsPaineisDISPOSICAOLINHAS.AsString = 'T';
       rbUltimasChamadasDisposicaoEmColunas.Checked := cdsPaineisDISPOSICAOLINHAS.AsString = 'F';
     end;

    tpImagem:
      begin
        //
      end;

    tpFlash:
      begin
        //
      end;

    tpDataHora:
      begin
        cmbDataHoraFonte     .FontName      := cdsPaineisFONTE.AsString;
        cmbDataHoraFontSize  .Text          := cdsPaineisFONTESIZE.AsString;
        cmbDataHoraFontColor .SelectedColor := cdsPaineisFONTECOLOR.AsInteger;
        btnDataHoraNegrito   .Down          := cdsPaineisNEGRITO.AsString = 'T';
        btnDataHoraItalico   .Down          := cdsPaineisITALICO.AsString = 'T';
        btnDataHoraSublinhado.Down          := cdsPaineisSUBLINHADO.AsString = 'T';
      end;

    tpJornalEletronico:
      begin
        //if vgJornalEletronico <> nil then
          //edtJornalEletronicoInterval.Text := IntToStr(vgJornalEletronico.Interval);

        cmbJornalEletronicoFonte     .FontName      := cdsPaineisFONTE.AsString;
        cmbJornalEletronicoFontSize  .Text          := cdsPaineisFONTESIZE.AsString;
        cmbJornalEletronicoFontColor .SelectedColor := cdsPaineisFONTECOLOR.AsInteger;
        btnJornalEletronicoNegrito   .Down          := cdsPaineisNEGRITO.AsString = 'T';
        btnJornalEletronicoItalico   .Down          := cdsPaineisITALICO.AsString = 'T';
        btnJornalEletronicoSublinhado.Down          := cdsPaineisSUBLINHADO.AsString = 'T';
      end;

    tpVideo:
      begin
        lstVideoFileNames.Items.Text := cdsPaineisARQUIVOSVIDEO.AsString;
        edtTempoAlternancia.Visible := false;
        lblTempoAlternancia.Visible := false;
      end;

    tpTV:
      begin
        cboSoftwaresHomologados.ItemIndex := cdsPaineisSOFTWAREHOMOLOGADO.AsInteger;
        edtTempoAlternancia.Visible       := true;
        lblTempoAlternancia.Visible       := true;

        lstVideoFileNames.Items.Text := cdsPaineisARQUIVOSVIDEO.AsString;

        if cdsPaineisSOFTWAREHOMOLOGADO.AsInteger = -1 then
        begin
          edCaminhoExecutavel.Enabled := false;
          edNomeJanela       .Enabled := false;
          cbxDispositivo     .Enabled := False;
          cbxResolucao       .Enabled := False;

          edCaminhoExecutavel.Text    := '';
          edNomeJanela       .Text    := '';
          cbxDispositivo     .ItemIndex := -1;
          cbxResolucao       .ItemIndex := -1;
          edResolucaoPadrao  .Text := '';
          edResolucaoPadrao  .Enabled := False;
        end

        else if (SoftwarePadraoTV(cdsPaineisSOFTWAREHOMOLOGADO.AsInteger) or (cdsPaineisSOFTWAREHOMOLOGADO.AsInteger = 2)) then
        begin
          edCaminhoExecutavel.Enabled := true;
          edNomeJanela       .Enabled := true;

          if SoftwarePadraoTV(cdsPaineisSOFTWAREHOMOLOGADO.AsInteger) then
            edResolucaoPadrao  .Enabled := True;
        end
        else if(cdsPaineisSOFTWAREHOMOLOGADO.AsInteger = 3)then
        begin
          cbxDispositivo     .Enabled := True;
          //IdentificarPlacaDeCaptura(vgTVComponent.Dispositivo);
          //CriarObjetoDeCapturaPopularResolucao(vgTVComponent.Resolucao,vgTVComponent.ParentHandle);
          //Sleep(1000);
          //StartStreaming;
          edResolucaoPadrao  .Text := '';
          edResolucaoPadrao  .Enabled := False;
        end
        else if(cdsPaineisSOFTWAREHOMOLOGADO.AsInteger = 0)then
        begin
          edCaminhoExecutavel.Enabled := true;
          edNomeJanela       .Enabled := true;
          cbxDispositivo     .Enabled := False;
          cbxResolucao       .Enabled := False;

          cbxDispositivo     .ItemIndex := -1;
          cbxResolucao       .ItemIndex := -1;
          edResolucaoPadrao  .Enabled := False;
          edResolucaoPadrao  .Text := '';
        end;
     end;

    tpIndicadorPerformance:
      begin
        //
      end;

    tpPlayListManager:
      begin
        try
          //edtIDTVPlayListManager.Text          := IntToStr(IniFile.ReadInteger('Panel'+inttostr(no), 'IDTVPlayListManager', 0));
          cbTipoBancoPlayList.ItemIndex        := cdsPaineisTIPOBANCO.AsInteger;
          //edtIntervaloVerificacaoPlayList.Text := IntToStr(IniFile.ReadInteger('Panel'+inttostr(no), 'IntervaloVerificacao', 1));
        finally

        end;
      end;
  end;

  Result := true;
end;

function TFrmConfiguracoesSicsTV.SalvarDadosPainel : boolean;  //GOT
begin
  if cdsPaineis.State in [dsBrowse] then
    cdsPaineis.Edit;

  cdsPaineisCOLOR.AsInteger := cmbBackgroundColor.SelectedColor;

  case TTipoDePainel(cdsPaineisTIPO.AsInteger) of
    tpChamadaSenha:
    begin
       try
         if btnChamadaDeSenhasLayoutSenhaAlinhaCentro.Down then
           cdsPaineisLAYOUTSENHAALINHAMENTO.Value := 1
         else if btnChamadaDeSenhasLayoutSenhaAlinhaDireita.Down then
           cdsPaineisLAYOUTSENHAALINHAMENTO.Value := 2
         else
           cdsPaineisLAYOUTSENHAALINHAMENTO.Value := 3;

         if btnChamadaDeSenhasLayoutPAAlinhaCentro.Down then
           cdsPaineisLAYOUTPAALINHAMENTO.AsInteger := 1
         else if btnChamadaDeSenhasLayoutPAAlinhaDireita .Down then              
           cdsPaineisLAYOUTPAALINHAMENTO.AsInteger := 2
         else
           cdsPaineisLAYOUTPAALINHAMENTO.AsInteger := 3;

         if btnChamadaDeSenhasLayoutNomeClienteAlinhaCentro.Down then
           cdsPaineisLAYOUTNOMECLIENTEALINHAMENTO.AsInteger := 1
         else if btnChamadaDeSenhasLayoutNomeClienteAlinhaDireita.Down then
           cdsPaineisLAYOUTNOMECLIENTEALINHAMENTO.AsInteger := 2
         else
           cdsPaineisLAYOUTNOMECLIENTEALINHAMENTO.AsInteger := 3;

         cdsPaineisSOMVOZCHAMADA1MARCADO.AsString := IfThen(lstVozChamada.Checked[0], 'T', 'F');
         cdsPaineisSOMVOZCHAMADA2MARCADO.AsString := IfThen(lstVozChamada.Checked[1], 'T', 'F');
         cdsPaineisSOMVOZCHAMADA3MARCADO.AsString := IfThen(lstVozChamada.Checked[2], 'T', 'F');
       finally

       end;

       cdsPaineisFONTE.AsString        := cmbChamadaSenhasFonte.FontName;
       cdsPaineisFONTESIZE.AsString    := cmbChamadaSenhasFontSize.Text;
       cdsPaineisFONTECOLOR.AsInteger  := cmbChamadaSenhasFontColor.SelectedColor;
       cdsPaineisNEGRITO.AsString      := IfThen(btnChamadaSenhasNegrito.Down, 'T', 'F');
       cdsPaineisITALICO.AsString      := IfThen(btnChamadaSenhasItalico.Down,'T', 'F');
       cdsPaineisSUBLINHADO.AsString   := IfThen(btnChamadaSenhasSublinhado.Down, 'T', 'F');
       // 27/06 - Aqui pegar a lista de videos do Ini ou Variavel Global
     end;

    tpUltimasSenhas:
      begin
       try
         case cdsPaineisLayoutSenhaAlinhamento.AsInteger of
           1  : btnUltimasChamadasLayoutSenhaAlinhaCentro  .Down := true;
           2  : btnUltimasChamadasLayoutSenhaAlinhaDireita .Down := true;
           else btnUltimasChamadasLayoutSenhaAlinhaEsquerda.Down := true;
         end;
         case cdsPaineisLayoutPAAlinhamento.AsInteger of
           1  : btnUltimasChamadasLayoutPAAlinhaCentro  .Down := true;
           2  : btnUltimasChamadasLayoutPAAlinhaDireita .Down := true;
           else btnUltimasChamadasLayoutPAAlinhaEsquerda.Down := true;
         end;
         case cdsPaineisLayoutNomeClienteAlinhamento.AsInteger of
           1  : btnUltimasChamadasLayoutNomeClienteAlinhaCentro  .Down := true;
           2  : btnUltimasChamadasLayoutNomeClienteAlinhaDireita .Down := true;
           else btnUltimasChamadasLayoutNomeClienteAlinhaEsquerda.Down := true;
         end;
       finally

       end;

       cdsPaineisFONTE.AsString            := cmbUltimasChamadasFonte.FontName;
       cdsPaineisFONTESIZE.AsString        := cmbUltimasChamadasFontSize.Text;
       cdsPaineisFONTECOLOR.AsInteger      := cmbUltimasChamadasFontColor.SelectedColor;
       cdsPaineisNEGRITO.AsString          := IfThen(btnUltimasChamadasNegrito.Down, 'T', 'F');
       cdsPaineisITALICO.AsString          := IfThen(btnUltimasChamadasItalico.Down, 'T', 'F');
       cdsPaineisSUBLINHADO.AsString       := IfThen(btnUltimasChamadasSublinhado.Down, 'T', 'F');
       cdsPaineisDISPOSICAOLINHAS.AsString := IfThen(rbUltimasChamadasDisposicaoEmLinhas.Checked, 'T', 'F');
     end;

    tpImagem:
      begin
        //
      end;

    tpFlash:
      begin
        //
      end;

    tpDataHora:
      begin
        cdsPaineisFONTE.AsString       := cmbDataHoraFonte.FontName;
        cdsPaineisFONTESIZE.AsString   := cmbDataHoraFontSize.Text;
        cdsPaineisFONTECOLOR.AsInteger := cmbDataHoraFontColor .SelectedColor;
        cdsPaineisNEGRITO.AsString     := IfThen(btnDataHoraNegrito.Down,'T', 'F');
        cdsPaineisITALICO.AsString     := IfThen(btnDataHoraItalico.Down, 'T', 'F');
        cdsPaineisSUBLINHADO.AsString  := IfThen(btnDataHoraSublinhado.Down, 'T', 'F');
      end;

    tpJornalEletronico:
      begin
        //if vgJornalEletronico <> nil then
          //edtJornalEletronicoInterval.Text := IntToStr(vgJornalEletronico.Interval);

        cdsPaineisFONTE.AsString        := cmbJornalEletronicoFonte.FontName;
        cdsPaineisFONTESIZE.AsString    := cmbJornalEletronicoFontSize.Text;
        cdsPaineisFONTECOLOR.AsInteger  := cmbJornalEletronicoFontColor.SelectedColor;
        cdsPaineisNEGRITO.AsString      := IfThen(btnJornalEletronicoNegrito.Down, 'T', 'F');
        cdsPaineisITALICO.AsString      := IfThen(btnJornalEletronicoItalico.Down, 'T', 'F');
        cdsPaineisSUBLINHADO.AsString   := IfThen(btnJornalEletronicoSublinhado.Down, 'T', 'F');
      end;

    tpVideo:
      begin
        cdsPaineisARQUIVOSVIDEO.AsString := lstVideoFileNames.Items.Text;
      end;

    tpTV:
      begin
        cdsPaineisSOFTWAREHOMOLOGADO.AsInteger := cboSoftwaresHomologados.ItemIndex;
        cdsPaineisARQUIVOSVIDEO.AsString       := lstVideoFileNames.Items.Text;

        if cdsPaineisSOFTWAREHOMOLOGADO.AsInteger = -1 then
        begin
          edCaminhoExecutavel.Enabled := false;
          edNomeJanela       .Enabled := false;
          cbxDispositivo     .Enabled := False;
          cbxResolucao       .Enabled := False;

          edCaminhoExecutavel.Text    := '';
          edNomeJanela       .Text    := '';
          cbxDispositivo     .ItemIndex := -1;
          cbxResolucao       .ItemIndex := -1;
          edResolucaoPadrao  .Text := '';
          edResolucaoPadrao  .Enabled := False;
        end

        else if (SoftwarePadraoTV(cdsPaineisSOFTWAREHOMOLOGADO.AsInteger) or (cdsPaineisSOFTWAREHOMOLOGADO.AsInteger = 2)) then
        begin
          edCaminhoExecutavel.Enabled := true;
          edNomeJanela       .Enabled := true;

          if SoftwarePadraoTV(cdsPaineisSOFTWAREHOMOLOGADO.AsInteger) then
            edResolucaoPadrao  .Enabled := True;
        end
        else if(cdsPaineisSOFTWAREHOMOLOGADO.AsInteger = 3)then
        begin
          cbxDispositivo     .Enabled := True;
          //IdentificarPlacaDeCaptura(vgTVComponent.Dispositivo);
          //CriarObjetoDeCapturaPopularResolucao(vgTVComponent.Resolucao,vgTVComponent.ParentHandle);
          //Sleep(1000);
          //StartStreaming;
          edResolucaoPadrao  .Text := '';
          edResolucaoPadrao  .Enabled := False;
        end
        else if(cdsPaineisSOFTWAREHOMOLOGADO.AsInteger = 0)then
        begin
          edCaminhoExecutavel.Enabled := true;
          edNomeJanela       .Enabled := true;
          cbxDispositivo     .Enabled := False;
          cbxResolucao       .Enabled := False;

          cbxDispositivo     .ItemIndex := -1;
          cbxResolucao       .ItemIndex := -1;
          edResolucaoPadrao  .Enabled := False;
          edResolucaoPadrao  .Text := '';
        end;
     end;

    tpIndicadorPerformance:
      begin
        //
      end;

    tpPlayListManager:
      begin
        try
          //edtIDTVPlayListManager.Text          := IntToStr(IniFile.ReadInteger('Panel'+inttostr(no), 'IDTVPlayListManager', 0));
          cdsPaineisTIPOBANCO.AsInteger        := cbTipoBancoPlayList.ItemIndex;
          //edtIntervaloVerificacaoPlayList.Text := IntToStr(IniFile.ReadInteger('Panel'+inttostr(no), 'IntervaloVerificacao', 1));
        finally

        end;
      end;
  end;

  if cdsPaineis.State in [dsEdit, dsInsert] then
    cdsPaineis.Post;

  Result := true;
end;

end.
