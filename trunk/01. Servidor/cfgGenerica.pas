unit cfgGenerica;

interface
{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  sics_94, System.UITypes,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, FMTBcd, Menus, Provider, DB, DBClient, Grids, DBGrids,
  MyDlls_DR,  MyAspFuncoesUteis_VCL,
  ASPDbGrid, Vcl.ExtDlgs, Vcl.ImgList,
  Vcl.Imaging.pngimage,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt, uDataSetHelper,
  FireDAC.Phys.MSSQL, FireDAC.VCLUI.Wait, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  System.ImageList, FireDAC.Comp.DataSet;

type
  TTabelaSics = (ctNone, ctFilas, ctGruposDePaineis, ctPaineis, ctGruposDePAs, ctPAs, ctGruposDeAtendentes, ctAtendentes, ctClientes, ctEmails, ctCelulares,
                 ctTags, ctGruposTags,  ctPPs, ctGruposDePPs, ctMotivosPausa, ctGruposDeMotivosPausa, ctGrupoFilas, ctCategoriaFilas);

  TfrmSicsConfiguraTabela = class(TForm)
    dsGenerico: TDataSource;
    cdsFilas: TClientDataSet;
    dspFilas: TDataSetProvider;
    qryGeneratorGenericoTESTARREMOVER: TFDQuery;
    btnOk: TBitBtn;
    btnCancela: TBitBtn;
    btnIncluir: TBitBtn;
    btnExcluir: TBitBtn;
    lblConfigTabela: TLabel;
    btnPrint: TBitBtn;
    cdsPaineis: TClientDataSet;
    dspPaineis: TDataSetProvider;
    cdsPaineisID: TIntegerField;
    cdsPaineisID_MODELOPAINEL: TIntegerField;
    cdsPaineisNOME: TStringField;
    cdsPaineisENDERECOSERIAL: TStringField;
    cdsPaineisMANTERULTIMASENHA: TStringField;
    cdsPaineisMONITORAMENTO: TStringField;
    cdsGruposDePAs: TClientDataSet;
    dspGruposDePAs: TDataSetProvider;
    cdsLkpModelosDePaineis: TClientDataSet;
    dspLkpModelosDePaineis: TDataSetProvider;
    cdsPaineisLKUP_MODELOPAINEL: TStringField;
    cdsGruposDePaineis: TClientDataSet;
    dspGruposDePaineis: TDataSetProvider;
    cdsGruposDePaineisID: TIntegerField;
    cdsGruposDePaineisNOME: TStringField;
    cdsPAs: TClientDataSet;
    dspPAs: TDataSetProvider;
    cdsGruposDeAtendentes: TClientDataSet;
    dspGruposDeAtendentes: TDataSetProvider;
    cdsAtendentes: TClientDataSet;
    dspAtendentes: TDataSetProvider;
    cdsEmails: TClientDataSet;
    dspEmails: TDataSetProvider;
    cdsCelulares: TClientDataSet;
    dspCelulares: TDataSetProvider;
    cdsGruposDePAsID: TIntegerField;
    cdsGruposDePAsNOME: TStringField;
    cdsPAsID: TIntegerField;
    cdsPAsID_GRUPOPA: TIntegerField;
    cdsPAsID_FILAAUTOENCAMINHA: TIntegerField;
    cdsPAsNOME: TStringField;
    cdsPAsNOMENOPAINEL: TStringField;
    cdsPAsMAGAZINE: TIntegerField;
    cdsPAsATIVO: TStringField;
    cdsGruposDeAtendentesID: TIntegerField;
    cdsGruposDeAtendentesNOME: TStringField;
    cdsAtendentesID: TIntegerField;
    cdsAtendentesID_GRUPOATENDENTE: TIntegerField;
    cdsAtendentesNOME: TStringField;
    cdsAtendentesLOGIN: TStringField;
    cdsAtendentesREGISTROFUNCIONAL: TStringField;
    cdsAtendentesNOMERELATORIO: TStringField;
    cdsAtendentesSENHALOGIN: TStringField;
    cdsAtendentesATIVO: TStringField;
    cdsEmailsID: TIntegerField;
    cdsEmailsNOME: TStringField;
    cdsEmailsENDERECO: TStringField;
    cdsCelularesID: TIntegerField;
    cdsCelularesNOME: TStringField;
    cdsCelularesNUMERO: TStringField;
    btnApagarSenha: TBitBtn;
    cdsPAsID_PAINEL: TIntegerField;
    gridGenerico: TASPDbGrid;
    cdsPAsLKUP_GRUPO: TStringField;
    cdsPAsLKUP_PAINEL: TStringField;
    cdsPAsLKUP_FILAAUTOENCAMINHA: TStringField;
    btnSubir: TBitBtn;
    btnDescer: TBitBtn;
    cdsAtendentesLKUP_GRUPOATENDENTE: TStringField;
    cdsPAsPOSICAO: TIntegerField;
    cdsCelularesPREFIXO: TStringField;
    cdsPaineisTCPIP: TStringField;
    cdsPAsLKP_ATENDENTE: TStringField;
    cdsPAsID_ATENDENTE_AUTOLOGIN: TIntegerField;
    cldCorgeral: TColorDialog;
    mnuPopGrid: TPopupMenu;
    mnuLimpar: TMenuItem;
    btnListagem: TBitBtn;
    edBusca: TEdit;
    btnIncluirBusca: TSpeedButton;
    mnuItemCopiarCor: TMenuItem;
    mnuItemColarCor: TMenuItem;
    cdsTags: TClientDataSet;
    dspTags: TDataSetProvider;
    cdsGruposDeTags: TClientDataSet;
    dspGruposDeTags: TDataSetProvider;
    cdsTagsID: TIntegerField;
    cdsTagsNOME: TStringField;
    cdsTagsID_GRUPOTAG: TIntegerField;
    cdsTagsCODIGOCOR: TIntegerField;
    cdsGruposDeTagsID: TIntegerField;
    cdsGruposDeTagsNOME: TStringField;
    cdsTagsLKP_GRUPO: TStringField;
    cdsGruposDeTagsPOSICAO: TIntegerField;
    cdsTagsPOSICAO: TIntegerField;
    cdsTagsATIVO: TStringField;
    cdsGruposDeTagsATIVO: TStringField;
    qryAtendentes: TFDQuery;
    qryFilas: TFDQuery;
    qryGruposDePaineis: TFDQuery;
    qryPaineis: TFDQuery;
    qryGruposDePAs: TFDQuery;
    qryPAs: TFDQuery;
    qryGrupoDeAtendentes: TFDQuery;
    qryEmails: TFDQuery;
    qryCelulares: TFDQuery;
    qryTags: TFDQuery;
    qryGruposDeTags: TFDQuery;
    qryLkpModelosDePaineis: TFDQuery;
    cdsLkpGruposPAs: TClientDataSet;
    dspLkpGruposPAs: TDataSetProvider;
    qryLkpGruposPAs: TFDQuery;
    cdsLkpGruposAtendentes: TClientDataSet;
    dspLkpGruposAtendentes: TDataSetProvider;
    qryLkpGruposAtendentes: TFDQuery;
    cdsLkpGruposTags: TClientDataSet;
    dspLkpGruposTags: TDataSetProvider;
    qryLkpGruposTags: TFDQuery;
    cdsLkpFila: TClientDataSet;
    dspLkpFila: TDataSetProvider;
    qryLkpFila: TFDQuery;
    cdsLkpPainel: TClientDataSet;
    dspLkpPainel: TDataSetProvider;
    qryLkpPainel: TFDQuery;
    cdsLkpAtendentes: TClientDataSet;
    dspLkpAtendentes: TDataSetProvider;
    qryLkpAtendentes: TFDQuery;
    cdsTVs: TClientDataSet;
    IntegerField1: TIntegerField;
    StringField2: TStringField;
    dspTVs: TDataSetProvider;
    qryTVs: TFDQuery;
    cdsPPs: TClientDataSet;
    dspPPs: TDataSetProvider;
    qryPPs: TFDQuery;
    cdsPPsID: TIntegerField;
    cdsPPsID_GRUPOPP: TIntegerField;
    cdsPPsNOME: TStringField;
    cdsPPsCODIGOCOR: TIntegerField;
    cdsPPsPOSICAO: TIntegerField;
    cdsPPsATIVO: TStringField;
    cdsLkpGruposPPs: TClientDataSet;
    dspLkpGruposPPs: TDataSetProvider;
    qryLkpGruposPPs: TFDQuery;
    cdsPPsLKUP_GRUPO: TStringField;
    cdsGruposDePPs: TClientDataSet;
    dspGruposDePPs: TDataSetProvider;
    qryGruposDePPs: TFDQuery;
    cdsGruposDePPsID: TIntegerField;
    cdsGruposDePPsNOME: TStringField;
    cdsGruposDePPsPOSICAO: TIntegerField;
    cdsMotivosPausa: TClientDataSet;
    IntegerField2: TIntegerField;
    StringField1: TStringField;
    StringField3: TStringField;
    StringField4: TStringField;
    IntegerField4: TIntegerField;
    IntegerField5: TIntegerField;
    dspMotivosPausa: TDataSetProvider;
    qryMotivosPausa: TFDQuery;
    cdsGruposDeMotivosPausa: TClientDataSet;
    IntegerField6: TIntegerField;
    StringField5: TStringField;
    IntegerField7: TIntegerField;
    dspGruposDeMotivosPausa: TDataSetProvider;
    qryGruposDeMotivosPausa: TFDQuery;
    cdsMotivosPausaID_GRUPOMOTIVOSPAUSA: TIntegerField;
    cdsLkpGruposMotivosPausa: TClientDataSet;
    dspLkpGruposMotivosPausa: TDataSetProvider;
    qryLkpGruposMotivosPausa: TFDQuery;
    cdsPAsNOMEPORVOZ: TStringField;
    dlgOpenPic1: TOpenPictureDialog;
    cdsAlinhamentoImagemFila: TClientDataSet;
    cdsAlinhamentoImagemFilaID: TIntegerField;
    cdsAlinhamentoImagemFilaNOME: TStringField;
    ImageList1: TImageList;
    btnCopiarNome: TBitBtn;
    cdsClientes: TClientDataSet;
    dpsClientes: TDataSetProvider;
    qryClientes: TFDQuery;
    cdsClientesID: TIntegerField;
    cdsClientesATIVO: TStringField;
    cdsClientesNOME: TStringField;
    cdsClientesLOGIN: TStringField;
    cdsClientesSENHALOGIN: TStringField;
    cdsCelularesID_PUSH: TStringField;
    cdsCelularesPRATAFORMA: TStringField;
    cdsCache: TClientDataSet;
    cdsClientesID_UNIDADE: TIntegerField;
    cdsClientesLOGADO_NUMERO_MESA: TIntegerField;
    cdsMotivosPausaID_UNIDADE: TIntegerField;
    cdsGruposDeMotivosPausaID_UNIDADE: TIntegerField;
    cdsGruposDePPsID_UNIDADE: TIntegerField;
    cdsTVsID_UNIDADE: TIntegerField;
    cdsGruposDeTagsID_UNIDADE: TIntegerField;
    cdsTagsID_UNIDADE: TIntegerField;
    cdsCelularesID_UNIDADE: TIntegerField;
    cdsEmailsID_UNIDADE: TIntegerField;
    cdsAtendentesID_UNIDADE: TIntegerField;
    cdsGruposDeAtendentesID_UNIDADE: TIntegerField;
    cdsPAsID_UNIDADE: TIntegerField;
    cdsGruposDePAsID_UNIDADE: TIntegerField;
    cdsPaineisID_UNIDADE: TIntegerField;
    cdsGruposDePaineisID_UNIDADE: TIntegerField;
    qryPAsID_UNIDADE: TIntegerField;
    qryPAsID: TIntegerField;
    qryPAsID_GRUPOPA: TIntegerField;
    qryPAsID_PAINEL: TIntegerField;
    qryPAsID_FILAAUTOENCAMINHA: TIntegerField;
    qryPAsNOME: TStringField;
    qryPAsNOMENOPAINEL: TStringField;
    qryPAsMAGAZINE: TIntegerField;
    qryPAsOBEDECERSEQUENCIAFILAS: TStringField;
    qryPAsATIVO: TStringField;
    qryPAsPOSICAO: TIntegerField;
    qryPAsID_ATENDENTE_AUTOLOGIN: TIntegerField;
    qryPAsNOMEPORVOZ: TStringField;
    qryPaineisID_UNIDADE: TIntegerField;
    qryPaineisID: TIntegerField;
    qryPaineisID_MODELOPAINEL: TIntegerField;
    qryPaineisNOME: TStringField;
    qryPaineisENDERECOSERIAL: TStringField;
    qryPaineisTCPIP: TStringField;
    qryPaineisMANTERULTIMASENHA: TStringField;
    qryPaineisMONITORAMENTO: TStringField;
    qryPaineisMENSAGEM: TMemoField;
    qryPaineisID_CANAL_TV: TIntegerField;
    cdsFilasID: TIntegerField;
    cdsFilasATIVO: TStringField;
    cdsFilasNOME: TStringField;
    cdsFilasNOMENOTICKET: TStringField;
    cdsFilasNOMENOTOTEM: TStringField;
    cdsFilasRANGEMINIMO: TIntegerField;
    cdsFilasRANGEMAXIMO: TIntegerField;
    cdsFilasTROCARMILHAR: TStringField;
    cdsFilasTROCARDEZENADEMILHAR: TStringField;
    cdsFilasGERACAOAUTOMATICA: TStringField;
    cdsFilasCODIGOCOR: TIntegerField;
    cdsFilasPOSICAO: TIntegerField;
    cdsFilasIMPRIME_CDB: TStringField;
    cdsFilasLIMIAR_AMARELO: TTimeField;
    cdsFilasLIMIAR_LARANJA: TTimeField;
    cdsFilasLIMIAR_VERMELHO: TTimeField;
    cdsFilasTAMANHO_NOME_FILA: TIntegerField;
    cdsFilasNEGRITO_NOME_FILA: TStringField;
    cdsFilasITALICO_NOME_FILA: TStringField;
    cdsFilasSUBLINHADO_NOME_FILA: TStringField;
    cdsFilasCOR_NOME_FILA: TIntegerField;
    cdsFilasIMAGEM_FILA: TBlobField;
    cdsFilasALINHAMENTO_IMAGEM: TIntegerField;
    cdsFilasALINHAMENTO_IMG_LIST: TStringField;
    cdsFilasID_UNIDADE: TIntegerField;
    cdsPPsID_UNIDADE: TIntegerField;
    qryGrupoFilas: TFDQuery;
    dspGrupoFilas: TDataSetProvider;
    cdsGrupoFilas: TClientDataSet;
    qryCategoriaFilas: TFDQuery;
    dspCategoriaFilas: TDataSetProvider;
    cdsCategoriaFilas: TClientDataSet;
    cdsFilasID_GRUPOFILA: TIntegerField;
    cdsFilasID_CATEGORIAFILA: TIntegerField;
    cdsFilasCATEGORIAFILA_LIST: TStringField;
    cdsFilasGRUPOFILA_LIST: TStringField;
    cdsGrupoFilasID: TIntegerField;
    cdsGrupoFilasNOME: TStringField;
    cdsCategoriaFilasID: TIntegerField;
    cdsCategoriaFilasNOME: TStringField;
    cdsAtendentesID_ATD_CLI: TIntegerField;
    cdsAtendentesID_TRIAGEM: TIntegerField;
    cdsPAsWHATSAPP: TStringField;
    qryPAsWHATSAPP: TStringField;
    cdsAtendentesCONVENIOMODULAR: TStringField;
    cdsAtendentesTriagem: TBooleanField;
    cdsAtendentesIMPRIMIRPULSEIRA: TBooleanField;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure dspGenericoBeforeUpdateRecord(Sender: TObject;
      SourceDS: TDataSet; DeltaDS: TCustomClientDataSet;
      UpdateKind: TUpdateKind; var Applied: Boolean);
    procedure cdsGenericoReconcileError(DataSet: TCustomClientDataSet;
      E: EReconcileError; UpdateKind: TUpdateKind;
      var Action: TReconcileAction);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure cdsGenericoBeforePost(DataSet: TDataSet);
    procedure dsGenericoStateChange(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnSubirClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure gridGenericoDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure gridGenericoColEnter(Sender: TObject);
    procedure cdsFilasBeforeInsert(DataSet: TDataSet);
    procedure gridGenericoDblClick(Sender: TObject);
    procedure cdsFilasNewRecord(DataSet: TDataSet);
    procedure mnuLimparClick(Sender: TObject);
    procedure mnuPopGridPopup(Sender: TObject);
    procedure btnListagemClick(Sender: TObject);
    procedure gridGenericoTitleClick(Column: TColumn);
    procedure cdsAtendentesFilterRecord(DataSet: TDataSet;
      var Accept: Boolean);
    procedure edBuscaKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnIncluirBuscaClick(Sender: TObject);
    procedure edBuscaExit(Sender: TObject);
    procedure edBuscaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edBuscaKeyPress(Sender: TObject; var Key: Char);
    procedure mnuItemCopiarCorClick(Sender: TObject);
    procedure mnuItemColarCorClick(Sender: TObject);
    procedure btnApagarSenhaClick(Sender: TObject);
    procedure cdsFilasTAMANHO_NOME_FILAChange(Sender: TField);
    procedure btnCopiarNomeClick(Sender: TObject);
    procedure cdsClientesFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure cdsFilasReconcileError(DataSet: TCustomClientDataSet; E: EReconcileError; UpdateKind: TUpdateKind;
      var Action: TReconcileAction);
    procedure cdsAtendentesReconcileError(DataSet: TCustomClientDataSet; E: EReconcileError; UpdateKind: TUpdateKind;
      var Action: TReconcileAction);
    procedure cdsAtendentesNewRecord(DataSet: TDataSet);
  private
    { Private declarations }
    ConfigurandoTabela : TTabelaSics;
    FLastPosicao: Integer;
    FCopyColor: Longint;
    FCopyColorName: Longint; //JLS

    FIdUnidade: Integer;
    FSqlConnUnidade: TFDConnection;
    procedure TrocaPosicao(PosAtual: Integer; Incrementa: Boolean);
    procedure ExibirOcultarCampoBusca(Exibir: Boolean);
    procedure GravarCorNoCampo(Cor: TColor);
    procedure GravarCorNomeFilaNoCampo(Cor: TColor);
    procedure GravarImagemFilaNoCampo(Caminho : string);
    procedure CriaCdsAlinhamentoImagem;
  public
    class function ExibeForm(Tabela : TTabelaSics; var IdUnidade: Integer): Boolean;
  end;

implementation

{$IFDEF CompilarPara_CONFIG}
uses
      untMainForm, ASPGenerator;
{$ELSE}
uses
      sics_m, udmContingencia, uqrCfgGenerica, sics_2, ASPGenerator;
{$ENDIF}


{$R *.dfm}

class function TfrmSicsConfiguraTabela.ExibeForm(Tabela : TTabelaSics; var IdUnidade: Integer) : boolean;
var
  frm: TfrmSicsConfiguraTabela;
//  coluna : TColumn;
  {$IFDEF CompilarPara_CONFIG}
  i  : integer;
  {$ENDIF CompilarPara_CONFIG}
begin
{$IFNDEF CompilarPara_CONFIG}
  IdUnidade := dmSicsMain.CheckPromptUnidade;
{$ENDIF}

  try
    frm := TfrmSicsConfiguraTabela.Create(Application);
    with frm do
    try
      FIdUnidade := IdUnidade;

      {$IFDEF CompilarPara_CONFIG}
        //A FAZER: APONTAR A CONNECTION DO MAINFORM PARA O BANCO DA UNIDADE
        for i := 0 to ComponentCount - 1 do
          if Components[i] is TFDQuery then
            (Components[i] as TFDQuery).Connection := dmSicsMain.connOnLine;
        FSqlConnUnidade := dmSicsMain.connOnLine;
      {$ELSE}
        if IdUnidade > 0 then
          FSqlConnUnidade := dmSicsMain.CreateSqlConnUnidade(frm, IdUnidade)
        else
          FSqlConnUnidade := dmSicsMain.connOnLine;

        dmSicsMain.SetNewSqlConnectionForSQLDataSet(frm, FSqlConnUnidade);
      {$ENDIF}

      ConfigurandoTabela := Tabela;

      case Tabela of
        ctFilas                : begin
                                   dsGenerico.DataSet := cdsFilas;
                                   lblConfigTabela.Caption := 'Filas:';
                                   Caption := 'Configuração das Filas';
                                 end;
        ctGruposDePaineis      : begin
                                   dsGenerico.DataSet := cdsGruposDePaineis;
                                   lblConfigTabela.Caption := 'Grupos de painéis:';
                                   Caption := 'Configuração dos Grupos de Painéis';
                                 end;
        ctPaineis              : begin
                                   dsGenerico.DataSet := cdsPaineis;
                                   lblConfigTabela.Caption := 'Painéis:';
                                   Caption := 'Configuração dos Painéis';
                                   cdsLkpModelosDePaineis.Open;
                                 end;
        ctGruposDePAs          : begin
                                   dsGenerico.DataSet := cdsGruposDePAs;
                                   lblConfigTabela.Caption := 'Grupos de PAs:';
                                   Caption := 'Configuração dos Grupos de PAs';
                                 end;
        ctPAs                  : begin
                                   dsGenerico.DataSet := cdsPAs;
                                   lblConfigTabela.Caption := 'PAs:';
                                   Caption := 'Configuração das Posições de Atendimento';
                                   cdsLkpGruposPAs.Open;
                                   cdsLkpPainel.Open;
                                   cdsLkpFila.Open;
                                   cdsLkpAtendentes.Open;
                                 end;
        ctGruposDeAtendentes   : begin
                                   dsGenerico.DataSet := cdsGruposDeAtendentes;
                                   lblConfigTabela.Caption := 'Grupos de atendentes:';
                                   Caption := 'Configuração dos Grupos de Atendentes';
                                 end;
        ctAtendentes           : begin
                                   dsGenerico.DataSet := cdsAtendentes;
                                   lblConfigTabela.Caption := 'Atendentes:';
                                   Caption := 'Configuração dos Atendentes';
                                   cdsLkpGruposAtendentes.Open;
                                 end;
        ctClientes             : begin
                                   dsGenerico.DataSet := cdsClientes;
                                   lblConfigTabela.Caption := 'Clientes:';
                                   Caption := 'Configuração dos Clientes';
                                 end;
        ctEmails               : begin
                                   dsGenerico.DataSet := cdsEmails;
                                   lblConfigTabela.Caption := 'E-mails:';
                                   Caption := 'Configuração dos E-mails';
                                 end;
        ctCelulares            : begin
                                   dsGenerico.DataSet := cdsCelulares;
                                   lblConfigTabela.Caption := 'Celulares:';
                                   Caption := 'Configuração dos Celulares';
                                 end;

        ctTags                 : begin
                                   dsGenerico.DataSet := cdsTags;
                                   lblConfigTabela.Caption := 'Tags:';
                                   Caption := 'Configuração das Tags';
                                   cdsLkpGruposTags.Open;
                                 end;

        ctGruposTags           : begin
                                   dsGenerico.DataSet := cdsGruposDeTags;
                                   lblConfigTabela.Caption := 'Grupos de Tags:';
                                   Caption := 'Configuração dos Grupos de Tags';
                                 end;

        ctGruposDePPs          : begin
                                   dsGenerico.DataSet := cdsGruposDePPs;
                                   lblConfigTabela.Caption := 'Grupos de Processos Paralelos:';
                                   Caption := 'Configuração dos Grupos de Tipos de Processos Paralelos';
                                 end;

        ctPPs                  : begin
                                   dsGenerico.DataSet := cdsPPs;
                                   lblConfigTabela.Caption := 'Processos Paralelos:';
                                   Caption := 'Configuração dos Tipos de Processos Paralelos';
                                   cdsLkpGruposPPs.Open;
                                 end;

        ctGruposDeMotivosPausa : begin
                                   dsGenerico.DataSet := cdsGruposDeMotivosPausa;
                                   lblConfigTabela.Caption := 'Grupos de Motivos de Pausa:';
                                   Caption := 'Configuração dos Grupos de Motivos de Pausa';
                                 end;

        ctMotivosPausa         : begin
                                   dsGenerico.DataSet := cdsMotivosPausa;
                                   lblConfigTabela.Caption := 'Motivos de Pausa:';
                                   Caption := 'Configuração dos Motivos de Pausa';
                                   cdsLkpGruposMotivosPausa.Open;
                                 end;
        ctGrupoFilas           : begin
                                   dsGenerico.DataSet := cdsGrupoFilas;
                                   lblConfigTabela.Caption := 'Grupo de Filas:';
                                   Caption := 'Configuração dos Grupos de Filas';
                                 end;
        ctCategoriaFilas       : begin
                                   dsGenerico.DataSet := cdsCategoriaFilas;
                                   lblConfigTabela.Caption := 'Categoria Filas:';
                                   Caption := 'Configuração das Categorias de Filas';
                                 end;

      end;  { case }

      {$IFDEF CompilarPara_CONFIG}
        btnListagem   .Visible := false;
      {$ENDIF}

      btnPrint      .Visible := Tabela in [ctFilas, ctPAs, ctAtendentes, ctClientes];
      btnApagarSenha.Visible := Tabela in [ctAtendentes, ctClientes];
      btnCopiarNome .Visible := Tabela in [ctAtendentes, ctClientes];

      FCopyColor := -1;
      FCopyColorName := -1; //JLS

      dsGenerico.DataSet.Open;

      Result := (ShowModal = mrOk);
    finally
      FreeAndNil(frm);
    end;  { try .. finally }
  except  on e: exception do
    begin
      showmessage(e.Message);
      Raise;
    end;
  end;  { try .. except }
end;  {  func ConfiguraTabela }


procedure TfrmSicsConfiguraTabela.btnPrintClick(Sender: TObject);
{$IFNDEF CompilarPara_CONFIG}
var
  s1, s2, s3 : string;
{$ENDIF}
begin
{$IFDEF CompilarPara_CONFIG}
  MainForm.ConectarSocketUnidade(Unidade.Porta);

  case ConfigurandoTabela of
    ctFilas      : MainForm.EnviarComando('0000' + Chr($76) + 'F' + (dsGenerico.DataSet as TClientDataSet).FieldByName('ID').AsString);
    ctPAs        : MainForm.EnviarComando('0000' + Chr($76) + 'P' + (dsGenerico.DataSet as TClientDataSet).FieldByName('ID').AsString);
    ctAtendentes : MainForm.EnviarComando('0000' + Chr($76) + 'A' + (dsGenerico.DataSet as TClientDataSet).FieldByName('ID').AsString);
  end;  { case }

  AppMessageBox('Comando enviado para o servidor. Cheque a impressão do código no totem ou impressora de senhas.', 'Confirmação', MB_ICONINFORMATION);
{$ELSE}
  if frmSicsMain.GetModeloImpressoraZero = tiBematech then
  begin
     frmSicsMain.ConfiguraCDBBematech (0);
     Delay(250);
  end;

  case ConfigurandoTabela of
    ctFilas      : begin
                     s1 := 'SICS - FILA ' + (dsGenerico.DataSet as TClientDataSet).FieldByName('ID').AsString + ' (' + (dsGenerico.DataSet as TClientDataSet).FieldByName('Nome').AsString + '){{Quebra de Linha}}';
                     s2 := '{{CDB Code39}}' + FormatLeftString(10,'%FILA' + (dsGenerico.DataSet as TClientDataSet).Fields[0].AsString + '$') + '{{Fim de Bloco CDB Code39}}' +
                           '{{Quebra de Linha}}{{Quebra de Linha}}{{Corte Total}}';
                   end;
    ctPAs        : begin
                     s1 := 'SICS - PA ' + (dsGenerico.DataSet as TClientDataSet).FieldByName('ID').AsString + ' (' + (dsGenerico.DataSet as TClientDataSet).FieldByName('Nome').AsString + '){{Quebra de Linha}}';
                     s2 := '{{CDB Code39}}' + FormatLeftString(10,'%PA' + (dsGenerico.DataSet as TClientDataSet).Fields[0].AsString + '$') + '{{Fim de Bloco CDB Code39}}' +
                           '{{Quebra de Linha}}{{Quebra de Linha}}{{Corte Total}}';
                   end;
    ctAtendentes : begin
                     s1 := 'SICS - ATENDENTE ' + (dsGenerico.DataSet as TClientDataSet).FieldByName('ID').AsString + ' (' + (dsGenerico.DataSet as TClientDataSet).FieldByName('Nome').AsString + '){{Quebra de Linha}}';
                     s2 := '{{CDB Code39}}' + FormatLeftString(10,'%ATD' + (dsGenerico.DataSet as TClientDataSet).Fields[0].AsString + '$') + '{{Fim de Bloco CDB Code39}}' +
                           '{{Quebra de Linha}}{{Quebra de Linha}}{{Corte Total}}';
                   end;
  end;  { case }

  ConverteProtocoloImpressora(s3, s1, frmSicsMain.GetModeloImpressoraZero);
  frmSicsMain.Imprime(0, s3);
  Delay(500);
  ConverteProtocoloImpressora(s3, s2, frmSicsMain.GetModeloImpressoraZero);
  frmSicsMain.Imprime(0, s3);
{$ENDIF}
end;


procedure TfrmSicsConfiguraTabela.btnOkClick(Sender: TObject);
begin
  with (dsGenerico.DataSet as TClientDataSet) do
  begin
    if State in dsEditModes then
    begin
      UpdateRecord;
      Post;
    end;

    if ChangeCount > 0 then
    begin
      if ApplyUpdates(0) = 0 then
      begin
        {$IFNDEF CompilarPara_CONFIG}   // se for apenas o módulo Servidor
          dmSicsContingencia.CheckReplicarTabelasP2C;

          // ****************************************************************************************************
          // GOT 14/11/2014
          // após ApplyUpdates verifica se o form genérico está configurando PAs ou Atendentes ...
          // ****************************************************************************************************
          if ConfigurandoTabela in [ctPAs, ctAtendentes] then
          begin
            if (ConfigurandoTabela = ctPAs) then
            begin
              with frmSicsSituacaoAtendimento.cdsPAs do
              begin
                cdsPAs.First;
                while not cdsPAs.Eof do
                begin
                  // ****************************************************************************************************
                  // verifica todas as PAs ATIVAS no banco de dados e caso exista na situação do atendimento
                  // atualiza "Nome, Grupo e Posição", se não existir insere a nova PA na lista.
                  // ****************************************************************************************************
                  if (cdsPAsATIVO.AsString = 'T') then
                  begin
                    if Locate('ID_PA',cdsPAsID.AsInteger,[]) then
                    begin
                      Edit;
                      if cdsPAsID_ATENDENTE_AUTOLOGIN.IsNull then
                        FieldByName('ID_ATENDENTE_AUTOLOGIN').Clear
                      else
                        FieldByName('ID_ATENDENTE_AUTOLOGIN').AsInteger := cdsPAsID_ATENDENTE_AUTOLOGIN.AsInteger;
                      FieldByName('Ativo').AsBoolean := true;
                      FieldByName('POSICAO').AsInteger := cdsPAsPOSICAO.AsInteger;
                      Post;
                    end else
                    begin
                      Append;
                      FieldByName('Id_PA').AsInteger      := cdsPAsID.AsInteger;
                      FieldByName('Horario').AsDateTime   := Now;
                      FieldByName('Id_Status').AsInteger  := 0;
                      if cdsPAsID_ATENDENTE_AUTOLOGIN.IsNull then
                        FieldByName('ID_ATENDENTE_AUTOLOGIN').Clear
                      else
                        FieldByName('ID_ATENDENTE_AUTOLOGIN').AsInteger := cdsPAsID_ATENDENTE_AUTOLOGIN.AsInteger;
                      FieldByName('Ativo').AsBoolean := true;
                      FieldByName('POSICAO').AsInteger  := cdsPAsPOSICAO.AsInteger;
                      Post;
                    end;
                  end;
                  cdsPAs.Next;
                end;

                // ****************************************************************************************************
                // verifica todas as PAs na situação do atendimento e exclui da lista caso não exista mais ou esteja
                // inativa no banco de dados.
                // ****************************************************************************************************
                First;
                while not Eof do
                begin
                  if (not cdsPAs.Locate('ID',FieldByName('Id_PA').AsInteger,[])) or (cdsPAsATIVO.AsString <> 'T') then
                    Delete
                  else
                    Next;
                end;
              end;
            end else
            if (ConfigurandoTabela = ctAtendentes) then
            begin
              frmSicsSituacaoAtendimento.AtualizarCdsAtendentes(cdsAtendentes);
            end;

              // ****************************************************************************************************
              // atualiza RT
              // ****************************************************************************************************
            frmSicsMain.SalvaSituacao_Atendimento;
          end;
        {$IFEND}

        try
          Refresh;
        except
          {
           Eduardo Rocha
           No cadastro de filas, quando incluia uma fila e MOVIA outros registros (com as setas)
           ao tentar fazer o refresh aqui dava o seguinte erro:
           cdsFilas: Must apply updates before refreshing data
           Acredito ser um bug do clientdataset, nao consegui descobrir,
           o importante eh que pelo menos está gravando corretamente
          }
        end;

        {$IFNDEF CompilarPara_CONFIG}
        if FIdUnidade = 0 then
        begin
          case ConfigurandoTabela of
            ctFilas                : begin
                                       dmSicsMain.cdsFilas.Data := Data;
                                       dmSicsMain.LimparNNPASFilasInativas;
                                      end;
            ctGruposDePaineis      : dmSicsMain.cdsGruposDePaineis    .Data := Data;
            ctPaineis              : dmSicsMain.cdsPaineis            .Data := Data;
            ctGruposDePAs          : dmSicsMain.cdsGruposDePAs        .Data := Data;
            ctPAs                  : begin
                                       dmSicsMain.cdsPAs.Data := Data;
                                       dmSicsMain.LimparNNPASFilasInativas;
                                     end;
            ctGruposDeAtendentes   : dmSicsMain.cdsGruposDeAtendentes  .Data := Data;
            ctAtendentes           : dmSicsMain.cdsAtendentes          .Data := Data;
            ctEmails               : dmSicsMain.cdsEmails              .Data := Data;
            ctCelulares            : dmSicsMain.cdsCelulares           .Data := Data;
            ctTags                 : dmSicsMain.cdsTags                .Data := Data;
            ctGruposTags           : dmSicsMain.cdsGruposDeTags        .Data := Data;
            ctPPs                  : dmSicsMain.cdsPPs                 .Data := Data;
            ctGruposDePPs          : dmSicsMain.cdsGruposDePPs         .Data := Data;
            ctMotivosPausa         : dmSicsMain.cdsMotivosDePausa      .Data := Data;
            ctGruposDeMotivosPausa : dmSicsMain.cdsGruposDeMotivosPausa.Data := Data;
          end;  { case }
        end;
        {$ENDIF}

        ModalResult := mrOk;
      end
    end
    else
      ModalResult := mrCancel;
  end;
end;


procedure TfrmSicsConfiguraTabela.btnApagarSenhaClick(Sender: TObject);
begin
  if cdsAtendentes.Active then
  begin
    if ((cdsAtendentes.RecordCount > 0) and (
      AppMessageBox(Format('Apagar senha do atendente %s - %s?',
        [cdsAtendentes.FieldByName('ID').AsString, cdsAtendentes.FieldByName('NOME').AsString]),
        'Confirmação', MB_ICONQUESTION or MB_YESNOCANCEL) = mrYes)) then
    begin
      cdsAtendentes.Edit;
      cdsAtendentes.FieldByName('SENHALOGIN').AsString := TextHash('');
      cdsAtendentes.Post;
    end;
  end;

  if cdsClientes.Active then
  begin
    if ((cdsClientes.RecordCount > 0) and (
        AppMessageBox(Format('Apagar senha do cliente %s - %s?',
          [cdsClientes.FieldByName('ID').AsString, cdsClientes.FieldByName('NOME').AsString]),
          'Confirmação', MB_ICONQUESTION or MB_YESNOCANCEL) = mrYes)) then
      begin
        cdsClientes.Edit;
        cdsClientes.FieldByName('SENHALOGIN').Clear;
        cdsClientes.Post;
      end;
  end;
end;

procedure TfrmSicsConfiguraTabela.btnCancelaClick(Sender: TObject);
begin
  (dsGenerico.DataSet as TClientDataSet).CancelUpdates;
end;


procedure TfrmSicsConfiguraTabela.btnCopiarNomeClick(Sender: TObject);
begin
  if cdsAtendentes.Active then
  begin
    with cdsAtendentes do
    begin
      First;
      while not Eof do
      begin
        if(FieldByName('LOGIN').AsString = '')then
        begin
          if not( State in [dsEdit])then
          begin
            Edit;
          end;
          FieldByName('LOGIN').AsString := FieldByName('NOME').AsString;
          Post;
        end;
        Next;
      end;
    end;
  end;
  if cdsClientes.Active then
  begin
    with cdsClientes do
    begin
      First;
      while not Eof do
      begin
        if(FieldByName('LOGIN').AsString = '')then
        begin
          if not( State in [dsEdit])then
          begin
            Edit;
          end;
          FieldByName('LOGIN').AsString := FieldByName('NOME').AsString;
          Post;
        end;
        Next;
      end;
    end;
  end;
end;

procedure TfrmSicsConfiguraTabela.dspGenericoBeforeUpdateRecord (Sender: TObject; SourceDS: TDataSet; DeltaDS: TCustomClientDataSet;
                                                             UpdateKind: TUpdateKind; var Applied: Boolean);
begin
  if UpdateKind = ukInsert then
    case ConfigurandoTabela of
      ctFilas                : DeltaDS.FieldByName('ID').NewValue := TGenerator.NGetNextGenerator('GEN_ID_FILA'            , FSqlConnUnidade);
      ctGruposDePaineis      : DeltaDS.FieldByName('ID').NewValue := TGenerator.NGetNextGenerator('GEN_ID_GRUPOPAINEL'     , FSqlConnUnidade);
      ctPaineis              : DeltaDS.FieldByName('ID').NewValue := TGenerator.NGetNextGenerator('GEN_ID_PAINEL'          , FSqlConnUnidade);
      ctGruposDePAs          : DeltaDS.FieldByName('ID').NewValue := TGenerator.NGetNextGenerator('GEN_ID_GRUPOPA'         , FSqlConnUnidade);
      ctPAs                  : DeltaDS.FieldByName('ID').NewValue := TGenerator.NGetNextGenerator('GEN_ID_PA'              , FSqlConnUnidade);
      ctGruposDeAtendentes   : DeltaDS.FieldByName('ID').NewValue := TGenerator.NGetNextGenerator('GEN_ID_GRUPOATENDENTE'  , FSqlConnUnidade);
      ctAtendentes           : DeltaDS.FieldByName('ID').NewValue := TGenerator.NGetNextGenerator('GEN_ID_ATENDENTE'       , FSqlConnUnidade);
      ctClientes             : DeltaDS.FieldByName('ID').NewValue := TGenerator.NGetNextGenerator('GEN_ID_CLIENTE'         , FSqlConnUnidade);
      ctEmails               : DeltaDS.FieldByName('ID').NewValue := TGenerator.NGetNextGenerator('GEN_ID_EMAIL'           , FSqlConnUnidade);
      ctCelulares            : DeltaDS.FieldByName('ID').NewValue := TGenerator.NGetNextGenerator('GEN_ID_CELULAR'         , FSqlConnUnidade);
      ctTags                 : DeltaDS.FieldByName('ID').NewValue := TGenerator.NGetNextGenerator('GEN_ID_TAG'             , FSqlConnUnidade);
      ctGruposTags           : DeltaDS.FieldByName('ID').NewValue := TGenerator.NGetNextGenerator('GEN_ID_GRUPOTAG'        , FSqlConnUnidade);
      ctPPs                  : DeltaDS.FieldByName('ID').NewValue := TGenerator.NGetNextGenerator('GEN_ID_PP'              , FSqlConnUnidade);
      ctGruposDePPs          : DeltaDS.FieldByName('ID').NewValue := TGenerator.NGetNextGenerator('GEN_ID_GRUPOPP'         , FSqlConnUnidade);
      ctMotivosPausa         : DeltaDS.FieldByName('ID').NewValue := TGenerator.NGetNextGenerator('GEN_ID_MOTIVOPAUSA'     , FSqlConnUnidade);
      ctGruposDeMotivosPausa : DeltaDS.FieldByName('ID').NewValue := TGenerator.NGetNextGenerator('GEN_ID_GRUPOMOTIVOPAUSA', FSqlConnUnidade);
      ctGrupoFilas           : DeltaDS.FieldByName('ID').NewValue := TGenerator.NGetNextGenerator('GEN_ID_GRUPOFILAS'      , FSqlConnUnidade);
      ctCategoriaFilas       : DeltaDS.FieldByName('ID').NewValue := TGenerator.NGetNextGenerator('GEN_ID_CATEGORIASFILAS' , FSqlConnUnidade);
    end;  { case }
end;


procedure TfrmSicsConfiguraTabela.cdsGenericoBeforePost(DataSet: TDataSet);
var
  lID: Integer;
begin
  if (FieldExists(DataSet, 'ID')) and DataSet.FieldByName('ID').IsNull then
  begin
    if DataSet is TClientDataSet then
    begin
      cdsCache.IndexFieldNames := 'ID';

      cdsCache.First;

      lID := (cdsCache.FieldByName('ID').AsInteger - 1);

      if lID >= 0 then lID := -1;

      cdsCache.Close;
    end
    else
    begin
      lID := -1;
    end;

    DataSet.FieldByName('ID').AsInteger := lID;
  end;

  if (FieldExists(DataSet, 'SENHALOGIN')) and (DataSet.FieldByName('SENHALOGIN').AsString = '') then
  begin
    DataSet.FieldByName('SENHALOGIN').AsString := TextHash(DataSet.FieldByName('SENHALOGIN').AsString);
  end;
end;


procedure TfrmSicsConfiguraTabela.cdsGenericoReconcileError (DataSet: TCustomClientDataSet; E: EReconcileError;
                                                         UpdateKind: TUpdateKind; var Action: TReconcileAction);
begin
  MyLogException(E);
  raise Exception.Create(e.Message);
end;

procedure TfrmSicsConfiguraTabela.CriaCdsAlinhamentoImagem;
begin
   cdsAlinhamentoImagemFila.CreateDataSet;
   with cdsAlinhamentoImagemFila do
   begin
     Append;
     cdsAlinhamentoImagemFilaID.Value := 0;
     cdsAlinhamentoImagemFilaNOME.Value := 'À direita';
     Post;

     Append;
     cdsAlinhamentoImagemFilaID.Value := 1;
     cdsAlinhamentoImagemFilaNOME.Value := 'À esquerda';
     Post;
   end;
end;

procedure TfrmSicsConfiguraTabela.FormCreate(Sender: TObject);
var
  i : integer;
begin
    for i := 0 to ComponentCount - 1 do
      if Components[i] is TFDQuery then
          (Components[i] as TFDQuery).Connection := dmSicsMain.connOnLine;

  {$IFNDEF CompilarPara_CONFIG}   // se for apenas o módulo Servidor
    if dmSicsContingencia.TipoFuncionamento = tfContingente then
      btnOk.Enabled := False;
  {$ENDIF CompilarPara_CONFIG}   // se for apenas o módulo Servidor

  ConfigurandoTabela := ctNone;

  LoadPosition(Sender as TForm);

  CriaCdsAlinhamentoImagem;
end;


procedure TfrmSicsConfiguraTabela.FormDestroy(Sender: TObject);
begin
  SavePosition(Sender as TForm);
end;


procedure TfrmSicsConfiguraTabela.FormResize(Sender: TObject);
const
  OFF = 10;
  FIXEDCOLWIDTH = 10;
begin
  btnSubir.Visible  := ConfigurandoTabela in [ctFilas, ctPAs, ctGruposTags, ctTags, ctPPs, ctGruposDePPs, ctMotivosPausa, ctGruposDeMotivosPausa];
  btnDescer.Visible := btnSubir.Visible;

  lblConfigTabela.Left  := OFF;
  lblConfigTabela.Top   := OFF;

  edBusca.Left          := lblConfigTabela.Left + lblConfigTabela.Width + 2*OFF;
  edBusca.Top           := lblConfigTabela.Top + (lblConfigTabela.Height - edBusca.Height) div 2;
  btnIncluirBusca.Left  := edBusca.Left + edBusca.Width + OFF;
  btnIncluirBusca.Top   := edBusca.Top;

  gridGenerico.Left     := OFF;
  gridGenerico.Top      := lblConfigTabela.Top + lblConfigTabela.Height + OFF;
  if btnSubir.Visible then
    gridGenerico.Width  := ClientWidth  - btnSubir.Width - 3*OFF
  else
    gridGenerico.Width  := ClientWidth  - 2*OFF;
  gridGenerico.Height   := ClientHeight - gridGenerico.Top - btnIncluir.Height - 2*OFF;
  btnSubir.Left         := gridGenerico.Left + gridGenerico.Width + OFF;
  btnSubir.Top          := gridGenerico.Top;
  btnDescer.Left        := btnSubir.Left;
  btnDescer.Top         := btnSubir.Top + btnSubir.Height + OFF;
  btnIncluir.Left       := OFF;
  btnIncluir.Top        := gridGenerico  .Top  + gridGenerico  .Height + OFF;
  btnExcluir.Left       := btnIncluir    .Left + btnIncluir    .Width  + OFF;
  btnExcluir.Top        := btnIncluir    .Top;
  btnListagem.Left      := btnExcluir    .Left + btnExcluir    .Width  + OFF;
  btnListagem.Top       := btnIncluir    .Top;
  btnPrint.Left         := btnListagem   .Left + btnListagem   .Width  + OFF;
  btnPrint.Top          := btnIncluir    .Top;
  btnApagarSenha.Left   := btnPrint      .Left + btnPrint      .Width  + OFF;
  btnApagarSenha.Top    := btnIncluir    .Top;
  btnCopiarNome.Left    := btnApagarSenha      .Left + btnApagarSenha      .Width  + OFF;
  btnCopiarNome.Top    := btnIncluir    .Top;

  if btnSubir.Visible then
    btnCancela.Left     := btnSubir      .Left + btnSubir      .Width  - btnCancela.Width
  else
    btnCancela.Left     := gridGenerico  .Left + gridGenerico  .Width  - btnCancela.Width;
  btnCancela.Top        := btnIncluir    .Top;
  btnOk.Left            := btnCancela    .Left - btnOk         .Width  - OFF;
  btnOk.Top             := btnIncluir    .Top;

  with gridGenerico do
    case ConfigurandoTabela of
      ctGruposDePaineis      : begin
                               end;
      ctGruposDePAs          : begin
                                 Columns[ 0].Width := Canvas.TextWidth(' 888 ');
                                 Columns[ 1].Width := ClientWidth - FIXEDCOLWIDTH - Columns[0].Width - 4;
                               end;
      ctGruposDeAtendentes   : begin
                                 Columns[ 0].Width := Canvas.TextWidth(' 888 ');
                                 Columns[ 1].Width := ClientWidth - FIXEDCOLWIDTH - Columns[0].Width - 4;
                               end;
      ctGruposTags           : begin
                                 Columns[ 0].Width := Canvas.TextWidth(' 888 ');
                                 Columns[ 1].Width := Canvas.TextWidth(' Ativo ');
                                 Columns[ 2].Width := ClientWidth - FIXEDCOLWIDTH - Columns[0].Width - Columns[1].Width - 5;
                               end;
      ctPaineis              : begin
                                 Columns[ 0].Width := Canvas.TextWidth(' 888 ');
                                 Columns[ 2].Width := Canvas.TextWidth(' 888 ');
                                 Columns[ 4].Width := Canvas.TextWidth(' End.Serial ');
                                 Columns[ 6].Width := Canvas.TextWidth(' Manter Última ');
                                 Columns[ 7].Width := Canvas.TextWidth(' Monitoramento ');
                                 Columns[ 1].Width := (ClientWidth - FIXEDCOLWIDTH - Columns[0].Width - Columns[2].Width - Columns[4].Width -
                                                       Columns[6].Width - Columns[7].Width - 10) div 3;
                                 Columns[ 3].Width := Columns[1].Width;
                                 Columns[ 5].Width := Columns[1].Width;
                               end;
      ctFilas                : begin
                                 Columns[ 0].Width := Canvas.TextWidth(' 888 ');
                                 Columns[ 1].Width := Canvas.TextWidth(' Ativo ');
                                 Columns[ 5].Width := Canvas.TextWidth('  MÁXIMO  ');
                                 Columns[ 6].Width := Columns[5].Width;
                                 Columns[ 7].Width := Canvas.TextWidth(' Gera Autom. ');
                                 Columns[ 8].Width := Canvas.TextWidth('  Cor  ');
                                 Columns[ 9].Width := Canvas.TextWidth('  Imprime CDB  ');
                                 Columns[10].Width := Canvas.TextWidth('  IP/Porta Impressora  ');
                                 Columns[11].Width := Canvas.TextWidth('  Limiar Amarelo  ');
                                 Columns[12].Width := Canvas.TextWidth('  Limiar Laranja  ');
                                 Columns[13].Width := Canvas.TextWidth('  Limiar Vermelho  ');
//                                 Columns[ 2].Width := (ClientWidth - FIXEDCOLWIDTH - Columns[0].Width - Columns[1].Width - Columns[5].Width -
//                                                       Columns[6].Width - Columns[7].Width - Columns[8].Width - Columns[9].Width - Columns[10].Width -
//                                                       Columns[11].Width - Columns[12].Width - Columns[13].Width - 11) div 3;
                                 Columns[ 3].Width := Columns[2].Width;
                                 Columns[ 4].Width := Columns[2].Width;
                               end;
      ctPAs                  : begin
                                 Columns[ 0].Width := Canvas.TextWidth(' 888 ');
                                 Columns[ 1].Width := Canvas.TextWidth(' Ativo ');
                                 Columns[ 3].Width := Canvas.TextWidth(' 888 ');
                                 Columns[ 5].Width := Canvas.TextWidth(' 888 ');
                                 Columns[10].Width := Canvas.TextWidth(' 888 ');
                                 Columns[12].Width := Canvas.TextWidth(' 888 ');
                                 Columns[ 7].Width := Canvas.TextWidth(' Texto No Painel ');
                                 Columns[ 8].Width := Columns[7].Width;
                                 Columns[ 9].Width := Canvas.TextWidth(' Magazine ');
                                 Columns[ 2].Width := (ClientWidth - FIXEDCOLWIDTH - Columns[0].Width - Columns[1].Width - Columns[3].Width -
                                                       Columns[5].Width - Columns[10].Width - Columns[12].Width - Columns[7].Width - Columns[8].Width - Columns[9].Width - 17) div 5;
                                 Columns[ 4].Width := Columns[2].Width;
                                 Columns[ 6].Width := Columns[2].Width;
                                 Columns[11].Width := Columns[2].Width;
                                 Columns[13].Width := Columns[2].Width;
                               end;
      ctAtendentes           : begin
                                 Columns[ 0].Width := Canvas.TextWidth(' 888 ');
                                 Columns[ 1].Width := Canvas.TextWidth(' Ativo ');
                                 Columns[ 3].Width := Canvas.TextWidth(' 888 ');
                                 Columns[ 7].Width := Canvas.TextWidth(' Nome Nos Relatórios ');
                                 Columns[ 6].Width := Columns[7].Width;
                                 Columns[ 5].Width := Columns[7].Width;
                                 Columns[ 4].Width := Columns[7].Width;
                                 Columns[ 2].Width := ClientWidth - FIXEDCOLWIDTH - Columns[0].Width - Columns[1].Width - Columns[3].Width -
                                                      Columns[4].Width - Columns[5].Width - Columns[6].Width - Columns[7].Width - 10;
                               end;
      ctEmails               : begin
                                 Columns[ 0].Width := Canvas.TextWidth(' 888 ');
                                 Columns[ 1].Width := (ClientWidth - FIXEDCOLWIDTH - Columns[0].Width - 5) div 2;
                                 Columns[ 2].Width := Columns[1].Width;
                               end;
      ctCelulares            : begin
                                 Columns[ 0].Width := Canvas.TextWidth(' 888 ');
                                 Columns[ 1].Width := (ClientWidth - FIXEDCOLWIDTH - Columns[0].Width - 6) div 3;
                                 Columns[ 2].Width := Columns[1].Width;
                                 Columns[ 3].Width := Columns[1].Width;
                               end;
      ctTags                 : begin
                                 Columns[ 0].Width := Canvas.TextWidth(' 888 ');
                                 Columns[ 1].Width := Canvas.TextWidth(' Ativo ');
                                 Columns[ 3].Width := Canvas.TextWidth(' 888 ');
                                 Columns[ 5].Width := Canvas.TextWidth('    COR    ');
                                 Columns[ 2].Width := (ClientWidth - FIXEDCOLWIDTH - Columns[0].Width - Columns[1].Width - Columns[3].Width - Columns[5].Width - 8) div 2;
                                 Columns[ 4].Width := Columns[ 2].Width;
                               end;
      ctPPs                  : begin
                                 Columns[ 0].Width := Canvas.TextWidth(' 888 ');
                                 Columns[ 1].Width := Canvas.TextWidth(' Ativo ');
                                 Columns[ 3].Width := Canvas.TextWidth(' 888 ');
                                 Columns[ 5].Width := Canvas.TextWidth('    COR    ');
                                 Columns[ 2].Width := (ClientWidth - FIXEDCOLWIDTH - Columns[0].Width - Columns[1].Width - Columns[3].Width - Columns[5].Width - 8) div 2;
                                 Columns[ 4].Width := Columns[ 2].Width;
                               end;
      ctGruposDePPs          : begin
                                 Columns[ 0].Width := Canvas.TextWidth(' 888 ');
                                 Columns[ 1].Width := ClientWidth - FIXEDCOLWIDTH - Columns[0].Width - 4;
                               end;
      ctMotivosPausa         : begin
                                 Columns[ 0].Width := Canvas.TextWidth(' 888 ');
                                 Columns[ 1].Width := Canvas.TextWidth(' Ativo ');
                                 Columns[ 3].Width := Canvas.TextWidth(' 888 ');
                                 Columns[ 5].Width := Canvas.TextWidth('    COR    ');
                                 Columns[ 2].Width := (ClientWidth - FIXEDCOLWIDTH - Columns[0].Width - Columns[1].Width - Columns[3].Width - Columns[5].Width - 8) div 2;
                                 Columns[ 4].Width := Columns[ 2].Width;
                                 end;
      ctGruposDeMotivosPausa : begin
                                 Columns[ 0].Width := Canvas.TextWidth(' 888 ');
                                 Columns[ 1].Width := ClientWidth - FIXEDCOLWIDTH - Columns[0].Width - 4;
                               end;
    end;  { case }
end;


procedure TfrmSicsConfiguraTabela.dsGenericoStateChange(Sender: TObject);
begin
  btnApagarSenha.Enabled := ((cdsAtendentes.State = dsBrowse) or (cdsClientes.State = dsBrowse));

  if ((dsGenerico.State = dsInsert) and (dsGenerico.DataSet.FindField('ATIVO') <> nil)) then
    dsGenerico.DataSet.FieldByName('ATIVO').AsBoolean := true;
end;


procedure TfrmSicsConfiguraTabela.btnExcluirClick(Sender: TObject);
begin
  if AppMessageBox('Deseja excluir "' + dsGenerico.DataSet.FieldByName('NOME').AsString + '" ?', 'Confirmação', MB_ICONQUESTION or MB_YESNOCANCEL) = mrYes then
    dsGenerico.DataSet.Delete;
end;


procedure TfrmSicsConfiguraTabela.btnIncluirClick(Sender: TObject);
begin
  ExibirOcultarCampoBusca(True);
end;


procedure TfrmSicsConfiguraTabela.TrocaPosicao(PosAtual: Integer; Incrementa: Boolean);
var
  PosNova: integer;
begin
  with gridGenerico.DataSource.DataSet do
  begin
    if Locate('POSICAO', PosAtual, []) then
    begin

      if Incrementa then
      begin
        Next;
        if Eof then Exit;
        PosNova := FieldByName('POSICAO').AsInteger;
        Prior;
      end
      else
      begin
        Prior;
        if Bof then Exit;
        PosNova := FieldByName('POSICAO').AsInteger;
        Next;
      end;

      Edit;
      FieldByName('POSICAO').AsInteger := -1000;
      Post;

      if Locate('POSICAO', PosNova, []) then
      begin
        Edit;
        FieldByName('POSICAO').AsInteger := PosAtual;
        Post;

        Locate('POSICAO', -1000, []);
        Edit;
        FieldByName('POSICAO').AsInteger := PosNova;
        Post;
      end
      else
      begin
        Locate('POSICAO', -1000, []);
        Edit;
        FieldByName('POSICAO').AsInteger := PosAtual;
        Post;
      end;
    end;
  end;
end;


procedure TfrmSicsConfiguraTabela.btnSubirClick(Sender: TObject);
begin
  if gridGenerico.DataSource.DataSet.FindField('POSICAO') <> nil then
    with gridGenerico.DataSource.DataSet do
      if ((Sender = btnSubir) and (RecNo <> 1)) then
        TrocaPosicao(FieldByName('POSICAO').AsInteger, False)
      else if Sender = btnDescer then
        TrocaPosicao(FieldByName('POSICAO').AsInteger, True);
end;


procedure TfrmSicsConfiguraTabela.FormShow(Sender: TObject);
begin
  FormResize(Sender);
end;


procedure TfrmSicsConfiguraTabela.gridGenericoDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
  const
  ICONWIDTH = 16;
  ICONHEIGHT = 16;
//  var
//    image : TBitmap;

begin
inherited;

  with gridGenerico do
  begin
    if DataCol = 0 then
    begin
      Canvas.Brush.Color := clBtnFace;

      if DataSource.DataSet.FieldByName(Column.FieldName).AsInteger <= -1 then
        Canvas.Font.Color := clBtnFace;
    end;

    if Column.FieldName = 'CODIGOCOR' Then
    begin
      Canvas.Brush.Color := TColor(column.Field.AsInteger);
      Canvas.Font.Color  := TColor(column.Field.AsInteger);
    end;

    if Column.FieldName = 'COR_NOME_FILA' Then
    begin
      Canvas.Brush.Color := TColor(column.Field.AsInteger);
      Canvas.Font.Color  := TColor(column.Field.AsInteger);
    end;

    if Column.FieldName = 'IMAGEM_FILA' then
    begin
       Canvas.Font.Color  := clWhite;
       if(not cdsFilas.FieldByName('IMAGEM_FILA').IsNull)then
       begin
         ImageList1.Draw(Canvas, Rect.Left + 1 + (((Rect.Right - Rect.Left) - ICONWIDTH) div 2), Rect.Top + 1 + (((Rect.Bottom - Rect.Top) - ICONHEIGHT) div 2), 0);
       end;
    end;
    if(Column.FieldName <> 'IMAGEM_FILA')then
      DefaultDrawColumnCell(Rect, DataCol, Column, State);
  end;
end;

procedure TfrmSicsConfiguraTabela.gridGenericoColEnter(Sender: TObject);
begin
  with gridGenerico do
  begin
    if SelectedIndex = 0 then
      SelectedIndex := 1;

    if (SelectedField.FieldName = 'CODIGOCOR') or (SelectedField.FieldName = 'COR_NOME_FILA') or (SelectedField.FieldName = 'IMAGEM_FILA') then
      Options := Options - [dgEditing]
    else
      Options := Options + [dgEditing];
  end;
end;

procedure TfrmSicsConfiguraTabela.cdsFilasBeforeInsert(DataSet: TDataSet);
begin
  with DataSet do
  begin
    if FindField('POSICAO') <> nil then
    begin
      Last;
      FLastPosicao := FieldByName('POSICAO').AsInteger;
    end;

    if FindField('ID') <> nil then
    begin
      if DataSet is TClientDataSet then
      begin
        cdsCache.XMLData := TClientDataSet(DataSet).XMLData;
      end;
    end;
  end;
end;

procedure TfrmSicsConfiguraTabela.gridGenericoDblClick(Sender: TObject);
begin
  if gridGenerico.SelectedField.FieldName = 'CODIGOCOR' then
  begin
     cldCorgeral.Color := TColor(dsGenerico.DataSet.FieldByName('CODIGOCOR').AsInteger);
     if (cldCorgeral.Execute) Then
       GravarCorNoCampo(cldCorgeral.Color);
  end;

  if gridGenerico.SelectedField.FieldName = 'COR_NOME_FILA' then
  begin
     cldCorgeral.Color := TColor(dsGenerico.DataSet.FieldByName('COR_NOME_FILA').AsInteger);
    if(cldCorgeral.Execute)then
      GravarCorNomeFilaNoCampo(cldCorgeral.Color);

  end;

  if gridGenerico.SelectedField.FieldName = 'IMAGEM_FILA' then
  begin
    if(dlgOpenPic1.Execute)then
      GravarImagemFilaNoCampo(dlgOpenPic1.FileName);
  end;
end;

procedure TfrmSicsConfiguraTabela.cdsFilasNewRecord(DataSet: TDataSet);
begin
  with DataSet do
  begin
    if FindField('POSICAO') <> nil then
    begin
      FieldByName('POSICAO').AsInteger := FLastPosicao + 1;
    end;

    if DataSet = cdsPAS then
    begin
      DataSet.FieldByName('MAGAZINE').AsInteger := 1;
    end;
  end;
end;

procedure TfrmSicsConfiguraTabela.cdsFilasReconcileError(DataSet: TCustomClientDataSet; E: EReconcileError;
  UpdateKind: TUpdateKind; var Action: TReconcileAction);
begin
  if E.Message.ToUpper.Contains('FOREIGN KEY') then
  begin
    MessageDlg('Não é possível excluir fila, pois existem dependências em outras tabelas do banco de dados.' + sLineBreak +
               'Desative a fila.', mtInformation, [mbOK], 0);
    cdsFilas.CancelUpdates;
    cdsFilas.Refresh;
  end
  else
  begin
    MyLogException(E);
  end;
end;

procedure TfrmSicsConfiguraTabela.cdsFilasTAMANHO_NOME_FILAChange(
  Sender: TField);
begin
  if(Sender.AsInteger > 99 )then
  begin
    ShowMessage('O Tamanho da fonte não pode ser maior que 99.');
    Sender.AsInteger := 99;
  end;
end;

procedure TfrmSicsConfiguraTabela.ExibirOcultarCampoBusca(Exibir: Boolean);
const
  OFF = 10;
begin
  edBusca.Visible         := Exibir;
  btnIncluirBusca.Visible := Exibir;

  if Exibir then
    edBusca.SetFocus
  else
  begin
    edBusca.Clear;
    gridGenerico.DataSource.DataSet.Filtered := False;
  end;
end;

procedure TfrmSicsConfiguraTabela.mnuLimparClick(Sender: TObject);
var
  bOldReadOnly: Boolean;
begin
  with dsGenerico.DataSet do
  begin
    if not (State in dsEditModes) then Edit;

    bOldReadOnly := gridGenerico.SelectedField.ReadOnly;
    gridGenerico.SelectedField.ReadOnly := False;
    try
      if gridGenerico.SelectedField.FieldKind = fkLookup then
        FieldByName(gridGenerico.SelectedField.KeyFields).Clear
      else
        gridGenerico.SelectedField.Clear;
      if(gridGenerico.SelectedField is TBlobField)then
         gridGenerico.SelectedField.Value := null;
    finally
      gridGenerico.SelectedField.ReadOnly := bOldReadOnly;
    end;
  end;
end;

procedure TfrmSicsConfiguraTabela.mnuPopGridPopup(Sender: TObject);
begin
  with mnuLimpar do
  begin
    Visible := (gridGenerico.SelectedField.FieldKind = fkLookup) or
               (gridGenerico.SelectedField.FieldName = 'CODIGOCOR') or
               (gridGenerico.SelectedField.FieldName = 'COR_NOME_FILA') or
                (gridGenerico.SelectedField.FieldName = 'IMAGEM_FILA');
    if(gridGenerico.SelectedField.FieldName <> 'IMAGEM_FILA')then
      Enabled := Visible and (gridGenerico.SelectedField.AsInteger <> 0)
    else
      Enabled := Visible ;
  end;

  with mnuItemColarCor do
  begin
    Visible := (gridGenerico.SelectedField.FieldName = 'CODIGOCOR') or
               (gridGenerico.SelectedField.FieldName = 'COR_NOME_FILA');

    if(gridGenerico.SelectedField.FieldName <> 'IMAGEM_FILA')then
      Enabled := Visible and (((FCopyColor <> -1) and                                     //JLS
                               (gridGenerico.SelectedField.FieldName = 'CODIGOCOR')) or   //JLS
                              ((FCopyColorName <> -1) and                                 //JLS
                               (gridGenerico.SelectedField.FieldName = 'COR_NOME_FILA'))) //JLS
    else
      Enabled := Visible ;
  end;

  with mnuItemCopiarCor do
  begin
    Visible := (gridGenerico.SelectedField.FieldName = 'CODIGOCOR') or
               (gridGenerico.SelectedField.FieldName = 'COR_NOME_FILA');
    Enabled := Visible;
  end;
end;

procedure TfrmSicsConfiguraTabela.btnListagemClick(Sender: TObject);
begin
  {$IFNDEF CompilarPara_CONFIG}
    TqrSicsCfgGenerica.Visualizar(dsGenerico.DataSet, ConfigurandoTabela);
  {$ENDIF}
end;

procedure TfrmSicsConfiguraTabela.gridGenericoTitleClick(Column: TColumn);
begin
  with gridGenerico.DataSource do
    if DataSet.FindField('POSICAO') = nil then
      TClientDataSet(DataSet).IndexFieldNames := Column.Field.FieldName
end;

procedure TfrmSicsConfiguraTabela.cdsAtendentesFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  Accept :=
    (DataSet.Active) and
    ( (Trim(edBusca.Text) = '') or
      (Pos(LowerCase(edBusca.Text), LowerCase(DataSet.FieldByName('nome').AsString)) > 0)
    );
end;

procedure TfrmSicsConfiguraTabela.cdsAtendentesNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('TRIAGEM').AsBoolean := False;
  DataSet.FieldByName('IMPRIMIRPULSEIRA').AsBoolean := False;
end;

procedure TfrmSicsConfiguraTabela.cdsAtendentesReconcileError(DataSet: TCustomClientDataSet; E: EReconcileError;
  UpdateKind: TUpdateKind; var Action: TReconcileAction);
begin
  if E.Message.ToUpper.Contains('FOREIGN KEY') then
  begin
    MessageDlg('Não é possível excluir atendente, pois existem dependências em outras tabelas do banco de dados.' + sLineBreak +
               'Desative a atendente.', mtInformation, [mbOK], 0);
    cdsAtendentes.CancelUpdates;
    cdsAtendentes.Refresh;
  end
  else
  begin
    MyLogException(E);
  end;
end;

procedure TfrmSicsConfiguraTabela.cdsClientesFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  Accept :=
    (DataSet.Active) and
    ( (Trim(edBusca.Text) = '') or
      (Pos(LowerCase(edBusca.Text), LowerCase(DataSet.FieldByName('nome').AsString)) > 0)
    );
end;

procedure TfrmSicsConfiguraTabela.edBuscaKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  with gridGenerico.DataSource.DataSet do
  begin
    Filtered := False;
    Filtered := True;
  end;
end;

procedure TfrmSicsConfiguraTabela.btnIncluirBuscaClick(Sender: TObject);
var
  sNome: string;
begin
  sNome := edBusca.Text;
  ExibirOcultarCampoBusca(False);
  dsGenerico.DataSet.Append;
  dsGenerico.DataSet.FieldByName('NOME').AsString := sNome;
  gridGenerico.SetFocus;
  gridGenerico.SelectedField := dsGenerico.DataSet.FieldByName('NOME');
  gridGenerico.EditorMode := True;
end;

procedure TfrmSicsConfiguraTabela.edBuscaExit(Sender: TObject);
begin
  ExibirOcultarCampoBusca(False);
end;

procedure TfrmSicsConfiguraTabela.edBuscaKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    ExibirOcultarCampoBusca(False);
end;

procedure TfrmSicsConfiguraTabela.edBuscaKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
    btnIncluirBusca.Click;
end;


//JLS - Procedure modificada para detectar os dois tipos de cópia de cor (CODICOR e COR_NOME_FILA).
//    - Antes a cópia da cor do nome da fila não funcionava (COR_NOME_FILA).
procedure TfrmSicsConfiguraTabela.mnuItemCopiarCorClick(Sender: TObject);
begin
  if gridGenerico.SelectedField.FieldName = 'CODIGOCOR' then
  begin
    FCopyColorName := -1;
    FCopyColor := dsGenerico.DataSet.FieldByName('CODIGOCOR').AsInteger;
  end
  else
  if gridGenerico.SelectedField.FieldName = 'COR_NOME_FILA' then
  begin
    FCopyColor := -1;
    FCopyColorName := dsGenerico.DataSet.FieldByName('COR_NOME_FILA').AsInteger;
  end;
end;

//JLS - Procedure modificada para detectar os dois tipos de comando "colar" cor (CODICOR e COR_NOME_FILA).
//    - Antes não permitia colar a cor do nome da fila (COR_NOME_FILA).
procedure TfrmSicsConfiguraTabela.mnuItemColarCorClick(Sender: TObject);
begin
  if (FCopyColor >= 0) and (gridGenerico.SelectedField.FieldName = 'CODIGOCOR') then
    GravarCorNoCampo(TColor(FCopyColor))
  else
  if (FCopyColorName >= 0) and (gridGenerico.SelectedField.FieldName = 'COR_NOME_FILA') then
    GravarCorNomeFilaNoCampo(FCopyColorName);
end;

procedure TfrmSicsConfiguraTabela.GravarCorNoCampo(Cor: TColor);
begin
  with dsGenerico.DataSet do
    if not (State in dsEditModes) then
      Edit;
  with dsGenerico.DataSet.FieldByName('CODIGOCOR') do
  begin
    ReadOnly := False;
    AsInteger := ColorToRGB(Cor);
    ReadOnly := True;
  end;
end;

procedure TfrmSicsConfiguraTabela.GravarCorNomeFilaNoCampo(Cor: TColor);
//var
//  fonteStr : string;
begin
  with dsGenerico.DataSet do
  if not (State in dsEditModes) then
    Edit;
  with dsGenerico.DataSet.FieldByName('COR_NOME_FILA') do
  begin
    ReadOnly := False;
    AsInteger := ColorToRGB(Cor);
    ReadOnly := True;
  end;
end;

procedure TfrmSicsConfiguraTabela.GravarImagemFilaNoCampo(Caminho: string);
begin
 with dsGenerico.DataSet do
  if not (State in dsEditModes) then
    Edit;
   TClientDataSet(dsGenerico.DataSet).FieldByName('IMAGEM_FILA').ReadOnly := false;
   TBlobField(TClientDataSet(dsGenerico.DataSet).FieldByName('IMAGEM_FILA')).LoadFromFile(Caminho);
   TClientDataSet(dsGenerico.DataSet).FieldByName('IMAGEM_FILA').ReadOnly := true;
end;

end.
