unit ufrmGraphicsPausas;
//Renomeado unit sics_85;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  {$IFNDEF IS_MOBILE}
  ExcelXP,
  VCL.OleServer,
  Winapi.Windows,
  {$ENDIF}

  ufrmPesquisaRelatorioBase, System.Types, untMainForm, untCommonDMClient,
  FMX.Grid, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.ExtCtrls, FMX.Types, FMX.Layouts, FMX.ListView.Types, FMX.ListView,
  FMX.ListBox, System.DateUtils, Fmx.Bind.DBEngExt, Fmx.Bind.Grid,
  System.Bindings.Outputs, Fmx.Bind.Editors, FMX.Objects, FMX.Edit,
  FMX.TabControl, System.UIConsts, System.Generics.Defaults,
  System.Generics.Collections, System.UITypes, System.SysUtils, System.Classes,
  System.Variants, Data.DB, Datasnap.DBClient, System.Rtti, Data.Bind.EngExt,
  Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope, MyAspFuncoesUteis,
  Math, Sics_Common_Parametros, IniFiles, ufrmGraphicsBase,
  Data.FMTBcd, Datasnap.Provider, System.Actions, FMX.ActnList, FMX.Menus,
  FMXTee.Engine, FMXTee.Procs, FMXTee.Chart, FMXTee.DBChart,
  FMX.Controls.Presentation, FMXTee.Series, System.ImageList, FMX.ImgList,
  FMX.Effects, FMX.Grid.Style, FMX.ScrollBox,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, 
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, 
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.DBX.Migrate, uDataSetHelper;

type
  TfrmGraphicsPausas = class(TfrmGraphicsBase)
    LinkGridHora: TLinkGridToDataSource;
    LinkGridMP: TLinkGridToDataSource;
    LinkGridAtend: TLinkGridToDataSource;
    LinkGridGrAtend: TLinkGridToDataSource;
    LinkGridPA: TLinkGridToDataSource;
    LinkGridGRPA: TLinkGridToDataSource;
    LinkGridUnidade: TLinkGridToDataSource;
    LinkGridMes: TLinkGridToDataSource;
    LinkGridDia: TLinkGridToDataSource;
    LinkGridDiaSm: TLinkGridToDataSource;
    RotateCWBtn: TButton;
    RotateCCWBtn: TButton;
    qryMes: TFDQuery;
    dspMes: TDataSetProvider;
    cdsMesTestes: TClientDataSet;
    SmallintField1: TSmallintField;
    StringField1: TStringField;
    IntegerField1: TIntegerField;
    IntegerField2: TIntegerField;
    cdsMesTestesTME_MSECS: TFMTBCDField;
    cdsMesTestesTMA_MSECS: TFMTBCDField;
    cdsMesTestesTME: TDateTimeField;
    cdsMesTestesTMA: TDateTimeField;
    dspEstatisticas: TDataSetProvider;
    cdsEstatisticas: TClientDataSet;
    cdsDiaSmSlaID: TIntegerField;
    cdsDiaSmSlaPAUSAS_PERC_VERDE: TFloatField;
    cdsDiaSmSlaPAUSAS_PERC_AMARELO: TFloatField;
    cdsDiaSmSlaPAUSAS_PERC_VERMELHO: TFloatField;
    cdsDiaSmSlaRECNO: TIntegerField;
    cdsDiaSmSlaDESCRICAO: TStringField;
    cdsDiaSmSlaTIPO_ATD_PAUSAS_DCR: TStringField;
    cdsDiaSmSlaPAUSAS_PERC_CINZA: TFloatField;
    dspEstatisticasSla: TDataSetProvider;
    dtsDiaSmSla: TDataSource;
    pnlChartSla: TPanel;
    dtsDiaSla: TDataSource;
    IntegerField3: TIntegerField;
    FloatField1: TFloatField;
    FloatField2: TFloatField;
    FloatField3: TFloatField;
    FloatField4: TFloatField;
    IntegerField4: TIntegerField;
    StringField2: TStringField;
    StringField3: TStringField;
    dtsMesSla: TDataSource;
    IntegerField5: TIntegerField;
    FloatField9: TFloatField;
    FloatField10: TFloatField;
    FloatField11: TFloatField;
    FloatField12: TFloatField;
    IntegerField6: TIntegerField;
    StringField4: TStringField;
    StringField5: TStringField;
    dtsHoraSla: TDataSource;
    cdsMotivoPausaSla: TClientDataSet;
    cdsUnidadeSla: TClientDataSet;
    cdsPASla: TClientDataSet;
    cdsGrPASla: TClientDataSet;
    cdsHoraSla: TClientDataSet;
    cdsEstatisticasSla: TClientDataSet;
    cdsMesSla: TClientDataSet;
    cdsDiaSmSla: TClientDataSet;
    cdsAtendSla: TClientDataSet;
    cdsDiaSla: TClientDataSet;
    cdsGrAtendSla: TClientDataSet;
    IntegerField7: TIntegerField;
    FloatField17: TFloatField;
    FloatField18: TFloatField;
    FloatField19: TFloatField;
    FloatField20: TFloatField;
    IntegerField8: TIntegerField;
    StringField6: TStringField;
    StringField7: TStringField;
    dtsAtendSla: TDataSource;
    IntegerField9: TIntegerField;
    FloatField25: TFloatField;
    FloatField26: TFloatField;
    FloatField27: TFloatField;
    FloatField28: TFloatField;
    IntegerField10: TIntegerField;
    StringField8: TStringField;
    StringField9: TStringField;
    dtsGrAtendSla: TDataSource;
    IntegerField11: TIntegerField;
    FloatField33: TFloatField;
    FloatField34: TFloatField;
    FloatField35: TFloatField;
    FloatField36: TFloatField;
    IntegerField12: TIntegerField;
    StringField10: TStringField;
    StringField11: TStringField;
    IntegerField13: TIntegerField;
    FloatField41: TFloatField;
    FloatField42: TFloatField;
    FloatField43: TFloatField;
    FloatField44: TFloatField;
    IntegerField14: TIntegerField;
    StringField12: TStringField;
    StringField13: TStringField;
    dtsPASla: TDataSource;
    IntegerField15: TIntegerField;
    FloatField49: TFloatField;
    FloatField50: TFloatField;
    FloatField51: TFloatField;
    FloatField52: TFloatField;
    IntegerField16: TIntegerField;
    StringField14: TStringField;
    StringField15: TStringField;
    dtsGrPASla: TDataSource;
    IntegerField19: TIntegerField;
    FloatField65: TFloatField;
    FloatField66: TFloatField;
    FloatField67: TFloatField;
    FloatField68: TFloatField;
    IntegerField20: TIntegerField;
    StringField18: TStringField;
    StringField19: TStringField;
    dtsUnidadeSla: TDataSource;
    cdsMesSlaPAUSAS_QTDE_VERDE: TIntegerField;
    cdsMesSlaPAUSAS_QTDE_AMARELO: TIntegerField;
    cdsMesSlaPAUSAS_QTDE_VERMELHO: TIntegerField;
    cdsMesSlaPAUSAS_QTDE_CINZA: TIntegerField;
    cdsDiaSlaPAUSAS_QTDE_VERDE: TIntegerField;
    cdsDiaSlaPAUSAS_QTDE_AMARELO: TIntegerField;
    cdsDiaSlaPAUSAS_QTDE_VERMELHO: TIntegerField;
    cdsDiaSlaPAUSAS_QTDE_CINZA: TIntegerField;
    cdsDiaSmSlaPAUSAS_QTDE_VERDE: TIntegerField;
    cdsDiaSmSlaPAUSAS_QTDE_AMARELO: TIntegerField;
    cdsDiaSmSlaPAUSAS_QTDE_VERMELHO: TIntegerField;
    cdsDiaSmSlaPAUSAS_QTDE_CINZA: TIntegerField;
    cdsAtendSlaPAUSAS_QTDE_VERDE: TIntegerField;
    cdsAtendSlaPAUSAS_QTDE_AMARELO: TIntegerField;
    cdsAtendSlaPAUSAS_QTDE_VERMELHO: TIntegerField;
    cdsAtendSlaPAUSAS_QTDE_CINZA: TIntegerField;
    cdsGrAtendSlaPAUSAS_QTDE_VERDE: TIntegerField;
    cdsGrAtendSlaPAUSAS_QTDE_AMARELO: TIntegerField;
    cdsGrAtendSlaPAUSAS_QTDE_VERMELHO: TIntegerField;
    cdsGrAtendSlaPAUSAS_QTDE_CINZA: TIntegerField;
    cdsGrPASlaPAUSAS_QTDE_VERDE: TIntegerField;
    cdsGrPASlaPAUSAS_QTDE_AMARELO: TIntegerField;
    cdsGrPASlaPAUSAS_QTDE_VERMELHO: TIntegerField;
    cdsGrPASlaPAUSAS_QTDE_CINZA: TIntegerField;
    cdsUnidadeSlaPAUSAS_QTDE_VERDE: TIntegerField;
    cdsUnidadeSlaPAUSAS_QTDE_AMARELO: TIntegerField;
    cdsUnidadeSlaPAUSAS_QTDE_VERMELHO: TIntegerField;
    cdsUnidadeSlaPAUSAS_QTDE_CINZA: TIntegerField;
    cdsPASlaPAUSAS_QTDE_VERDE: TIntegerField;
    cdsPASlaPAUSAS_QTDE_AMARELO: TIntegerField;
    cdsPASlaPAUSAS_QTDE_VERMELHO: TIntegerField;
    cdsPASlaPAUSAS_QTDE_CINZA: TIntegerField;
    cdsHoraSlaPAUSAS_QTDE_VERDE: TIntegerField;
    cdsHoraSlaPAUSAS_QTDE_AMARELO: TIntegerField;
    cdsHoraSlaPAUSAS_QTDE_VERMELHO: TIntegerField;
    cdsHoraSlaPAUSAS_QTDE_CINZA: TIntegerField;
    cdsLkpAtendentes: TClientDataSet;
    cdsLkpGruposAtendentes: TClientDataSet;
    cdsLkpPAS: TClientDataSet;
    cdsLkpGruposPAs: TClientDataSet;
    cdsMesSlaPAUSAS_QTDE_TOTAL: TIntegerField;
    cdsDiaSlaPAUSAS_QTDE_TOTAL: TIntegerField;
    cdsDiaSmSlaPAUSAS_QTDE_TOTAL: TIntegerField;
    cdsHoraSlaPAUSAS_QTDE_TOTAL: TIntegerField;
    cdsAtendSlaPAUSAS_QTDE_TOTAL: TIntegerField;
    cdsGrAtendSlaPAUSAS_QTDE_TOTAL: TIntegerField;
    cdsPASlaPAUSAS_QTDE_TOTAL: TIntegerField;
    cdsGrPASlaPAUSAS_QTDE_TOTAL: TIntegerField;
    cdsUnidadeSlaPAUSAS_QTDE_TOTAL: TIntegerField;
    cdsLkpAtendentesID: TIntegerField;
    cdsLkpGruposAtendentesID: TIntegerField;
    cdsLkpGruposAtendentesNOME: TStringField;
    cdsLkpAtendentesNOME: TStringField;
    cdsLkpPASID: TIntegerField;
    cdsLkpPASNOME: TStringField;
    cdsLkpGruposPAsID: TIntegerField;
    cdsLkpGruposPAsNOME: TStringField;
    cdsMes: TClientDataSet;
    cdsMesMes: TIntegerField;
    cdsMesMesStr: TStringField;
    cdsMesQtd: TIntegerField;
    cdsMesTMP: TDateTimeField;
    cdsMesMAX_DURACAO: TDateTimeField;
    MesDS: TDataSource;
    DiaDS: TDataSource;
    cdsDia: TClientDataSet;
    cdsDiaDia: TIntegerField;
    cdsDiaQtd: TIntegerField;
    cdsDiaTMP: TDateTimeField;
    cdsDiaMAX_DURACAO: TDateTimeField;
    DiaSmDS: TDataSource;
    cdsDiaSm: TClientDataSet;
    cdsDiaSmDiaSm: TIntegerField;
    cdsDiaSmDiaSmStr: TStringField;
    cdsDiaSmQtd: TIntegerField;
    cdsDiaSmTMP: TDateTimeField;
    cdsDiaSmMAX_DURACAO: TDateTimeField;
    cdsHora: TClientDataSet;
    cdsHoraHora: TIntegerField;
    cdsHoraQtd: TIntegerField;
    cdsHoraTMP: TDateTimeField;
    cdsHoraMAX_DURACAO: TDateTimeField;
    HoraDS: TDataSource;
    AtendDS: TDataSource;
    cdsAtend: TClientDataSet;
    cdsAtendAtend: TIntegerField;
    cdsAtendAtdRecNo: TIntegerField;
    cdsAtendAtdNome: TStringField;
    cdsAtendQtd: TIntegerField;
    cdsAtendTMP: TDateTimeField;
    cdsAtendMAX_DURACAO: TDateTimeField;
    cdsGrAtend: TClientDataSet;
    cdsGrAtendGrAtend: TIntegerField;
    cdsGrAtendGrAtendRecNo: TSmallintField;
    cdsGrAtendGrAtendNome: TStringField;
    cdsGrAtendQtd: TIntegerField;
    cdsGrAtendTMP: TDateTimeField;
    cdsGrAtendMAX_DURACAO: TDateTimeField;
    GrAtendDS: TDataSource;
    PADS: TDataSource;
    cdsPA: TClientDataSet;
    cdsPAPA: TIntegerField;
    cdsPAPARecNo: TIntegerField;
    cdsPAPANome: TStringField;
    cdsPAQtd: TIntegerField;
    cdsPATMP: TDateTimeField;
    cdsPAMAX_DURACAO: TDateTimeField;
    cdsGrPA: TClientDataSet;
    cdsGrPAGrPA: TIntegerField;
    cdsGrPAGrPARecNo: TSmallintField;
    cdsGrPAGrPANome: TStringField;
    cdsGrPAQtd: TIntegerField;
    cdsGrPATMP: TDateTimeField;
    cdsGrPAMAX_DURACAO: TDateTimeField;
    GrPADS: TDataSource;
    cdsUnidade: TClientDataSet;
    cdsUnidadeUnidade: TIntegerField;
    cdsUnidadeUnidadeRecNo: TIntegerField;
    cdsUnidadeUnidadeNome: TStringField;
    cdsUnidadeQtd: TIntegerField;
    cdsUnidadeTMP: TDateTimeField;
    cdsUnidadeMAX_DURACAO: TDateTimeField;
    UnidadeDS: TDataSource;
    cdsMotivoPausa: TClientDataSet;
    cdsMotivoPausaMP: TIntegerField;
    cdsMotivoPausaMPRecNo: TSmallintField;
    cdsMotivoPausaMPNome: TStringField;
    cdsMotivoPausaQtd: TIntegerField;
    cdsMotivoPausaTMP: TDateTimeField;
    cdsMotivoPausaMAX_DURACAO: TDateTimeField;
    MotivoPausaDS: TDataSource;
    IntegerField33: TIntegerField;
    StringField31: TStringField;
    FloatField5: TFloatField;
    FloatField6: TFloatField;
    FloatField7: TFloatField;
    FloatField8: TFloatField;
    IntegerField34: TIntegerField;
    StringField32: TStringField;
    cdsMotivoPausaSlaPAUSAS_QTDE_CINZA: TIntegerField;
    cdsMotivoPausaSlaPAUSAS_QTDE_VERMELHO: TIntegerField;
    cdsMotivoPausaSlaPAUSAS_QTDE_AMARELO: TIntegerField;
    cdsMotivoPausaSlaPAUSAS_QTDE_VERDE: TIntegerField;
    cdsMotivoPausaSlaPAUSAS_QTDE_TOTAL: TIntegerField;
    dtsMotivoPausaSla: TDataSource;
    cdsLkpMotivosPausa: TClientDataSet;
    cdsLkpMotivosPausaId: TIntegerField;
    cdsLkpMotivosPausaNome: TStringField;
    bnd1: TBindSourceDB;
    bnd2: TBindSourceDB;
    bnd3: TBindSourceDB;
    bnd4: TBindSourceDB;
    bnd5: TBindSourceDB;
    BindSourceDB1: TBindSourceDB;
    bnd6: TBindSourceDB;
    BindSourceDB2: TBindSourceDB;
    bnd7: TBindSourceDB;
    bnd8: TBindSourceDB;
    dbChartSla: TDBChart;
    BarSeries31: TBarSeries;
    BarSeries32: TBarSeries;
    BarSeries33: TBarSeries;
    Series7: TBarSeries;
    Label1: TLabel;
    Label2: TLabel;
    TMPLabel: TLabel;
    QtdPausasLabel: TLabel;
    QtdCheckBoxP: TCheckBox;
    TMPCheckBox: TCheckBox;
    QtdChartTypeCombo: TComboBox;
    chkSlaCinza: TCheckBox;
    Label3: TLabel;
    Label4: TLabel;
    lblParamsSLAPausasVermelho: TLabel;
    lblParamsSLAPausasAmarelo: TLabel;
    lblParamsSLAPausasVerde: TLabel;
    Label7: TLabel;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    lblUnidades: TLabel;
    Label10: TLabel;
    Label8: TLabel;
    Label6: TLabel;
    Label9: TLabel;
    Label5: TLabel;
    PeriododoRelatorioLabel: TLabel;
    PeriododoDiaLabel: TLabel;
    DuracaoLabel: TLabel;
    AtendentesInicioLabel: TLabel;
    PAsInicioLabel: TLabel;
    lblUnidadesVal: TLabel;
    Label11: TLabel;
    MotivosPausaLabel: TLabel;
    PageControlGrids: TTabControl;
    tbsMes: TTabItem;
    MesGrid: TGrid;
    tbsDia: TTabItem;
    DiaGrid: TGrid;
    tbsDiaSemana: TTabItem;
    DiaSmGrid: TGrid;
    tbsHora: TTabItem;
    HoraGrid: TGrid;
    tbsMotivoPausa: TTabItem;
    MPGrid: TGrid;
    tbsAtendentes: TTabItem;
    AtendGrid: TGrid;
    tbsGrupoAtendente: TTabItem;
    GrAtendGrid: TGrid;
    tbsPA: TTabItem;
    PAGrid: TGrid;
    tbsGrupoPA: TTabItem;
    GrPAGrid: TGrid;
    tbsUnidades: TTabItem;
    UnidadeGrid: TGrid;
    rectDadosDestaPesquisa: TRectangle;
    rectTotais: TRectangle;
    rectTituloDados: TRectangle;
    lblTituloDados: TLabel;
    rectTituloTotais: TRectangle;
    lblTituloTotais: TLabel;
    rectApresentar: TRectangle;
    Rectangle2: TRectangle;
    Label12: TLabel;
    rectParametrosSLA: TRectangle;
    Rectangle3: TRectangle;
    Label13: TLabel;
    rectApresentarSLA: TRectangle;
    rect2: TRectangle;
    lbl1: TLabel;
    rectLegenda: TRectangle;
    rectAzul: TRectangle;
    lblPausas: TLabel;
    rectVermelho: TRectangle;
    rectAmarelo: TRectangle;
    rectVerde: TRectangle;
    intgrfldMesIdUnidade: TIntegerField;
    strngfldMesNomeUnidade: TStringField;
    intgrfldDiaIdUnidade: TIntegerField;
    strngfldDiaNomeUnidade: TStringField;
    intgrfldDiaSmIdUnidade: TIntegerField;
    strngfldDiaSmNomeUnidade: TStringField;
    intgrfldHoraIdUnidade: TIntegerField;
    strngfldHoraNomeUnidade: TStringField;
    intgrfldAtendIdUnidade: TIntegerField;
    strngfldAtendNomeUnidade: TStringField;
    intgrfldGrAtendIdUnidade: TIntegerField;
    strngfldGrAtendNomeUnidade: TStringField;
    intgrfldPAIdUnidade: TIntegerField;
    strngfldPANomeUnidade: TStringField;
    intgrfldGrPAIdUnidade: TIntegerField;
    strngfldGrPANomeUnidade: TStringField;
    intgrfldMesSlaIdUnidade: TIntegerField;
    strngfldMesSlaNomeUnidade: TStringField;
    intgrfldDiaSlaIdUnidade: TIntegerField;
    strngfldDiaSlaNomeUnidade: TStringField;
    intgrfldDiaSmSlaIdUnidade: TIntegerField;
    strngfldDiaSmSlaNomeUnidade: TStringField;
    intgrfldHoraSlaIdUnidade: TIntegerField;
    strngfldHoraSlaNomeUnidade: TStringField;
    intgrfldAtendSlaIdUnidade: TIntegerField;
    strngfldAtendSlaNomeUnidade: TStringField;
    intgrfldGrAtendSlaIdUnidade: TIntegerField;
    strngfldGrAtendSlaNomeUnidade: TStringField;
    intgrfldPASlaIdUnidade: TIntegerField;
    strngfldPASlaNomeUnidade: TStringField;
    intgrfldMotivoPausaSlaIdUnidade: TIntegerField;
    strngfldMotivoPausaSlaNomeUnidade: TStringField;
    intgrfldMotivoPausaIdUnidade: TIntegerField;
    strngfldMotivoPausaNomeUnidade: TStringField;
    intgrfldGrPASlaIdUnidade: TIntegerField;
    strngfldGrPASlaNomeUnidade: TStringField;
    Label14: TLabel;
    Label15: TLabel;
    TMLLabel: TLabel;
    QtdLoginsLabel: TLabel;
    TMLCheckBox: TCheckBox;
    cdsMesQtdL: TIntegerField;
    cdsMesTML: TDateTimeField;
    cdsMesMax_DURACAO_LOGIN: TDateTimeField;
    cdsDiaQtdL: TIntegerField;
    cdsDiaTML: TDateTimeField;
    cdsDiaMAX_DURACAO_LOGIN: TDateTimeField;
    cdsDiaSmQtdL: TIntegerField;
    cdsDiaSmTML: TDateTimeField;
    cdsHoraQtdL: TIntegerField;
    cdsHoraTML: TDateTimeField;
    cdsAtendQtdL: TIntegerField;
    cdsAtendTML: TDateTimeField;
    cdsGrAtendQtdL: TIntegerField;
    cdsGrAtendTML: TDateTimeField;
    cdsGrAtendMAX_DURACAO_LOGIN: TDateTimeField;
    cdsAtendMAX_DURACAO_LOGIN: TDateTimeField;
    cdsMotivoPausaQtdL: TIntegerField;
    cdsMotivoPausaTML: TDateTimeField;
    cdsMotivoPausaMAX_DURACAO_LOGIN: TDateTimeField;
    cdsUnidadeQtdL: TIntegerField;
    cdsUnidadeTML: TDateTimeField;
    cdsUnidadeMAX_DURACAO_LOGIN: TDateTimeField;
    cdsGrPAQtdL: TIntegerField;
    cdsGrPATML: TDateTimeField;
    cdsGrPAMAX_DURACAO_LOGIN: TDateTimeField;
    cdsPAQtdL: TIntegerField;
    cdsPATML: TDateTimeField;
    cdsPAMAX_DURACAO_LOGIN: TDateTimeField;
    cdsDiaSmMAX_DURACAO_LOGIN: TDateTimeField;
    cdsHoraMAX_DURACAO_LOGIN: TDateTimeField;
    pnlGraficosTmpTml: TPanel;
    dbChartTmpTml: TDBChart;
    barSeriesTML: TBarSeries;
    barSeriesTMP: TBarSeries;
    LineSeriesQTDP: TLineSeries;
    MesQtdBarSeries: TBarSeries;
    dbPieChartTmpTml: TDBChart;
    PieSeries6: TPieSeries;
    LineSeriesQTDL: TLineSeries;
    QtdCheckBoxL: TCheckBox;
    procedure cdsDiaSmCalcFields  (DataSet: TDataSet);
    procedure cdsAtendCalcFields  (DataSet: TDataSet);
    procedure cdsPACalcFields     (DataSet: TDataSet);
    procedure cdsGrAtendCalcFields(DataSet: TDataSet);
    procedure cdsGrPACalcFields   (DataSet: TDataSet);
    procedure QtdChartTypeComboChange(Sender: TObject);
    procedure RotateCWBtnClick(Sender: TObject);
    procedure QtdEspAtdComboChange(Sender: TObject);
    procedure actImprimirExecute(Sender: TObject);
    procedure cdsMesCalcFields(DataSet: TDataSet);
    procedure cdsMesTestesCalcFields(DataSet: TDataSet);
    procedure cdsUnidadeCalcFields(DataSet: TDataSet);
    procedure cdsUnidadeUnidadeNomeGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure cdsMesTMPGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure PageControlGridsChange(Sender: TObject);
    procedure cdsMesAfterOpen(DataSet: TDataSet);
    procedure cdsTagTagNomeGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure StringField20GetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure cdsFilaEsperaFilaEsperaNomeGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure StringField22GetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure PreencheNDOnField(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure cdsMotivoPausaCalcFields(DataSet: TDataSet);
    procedure chkSlaCinzaChange(Sender: TObject);
    procedure btnCloseFrameClick(Sender: TObject);
    procedure RotateCCWBtnClick(Sender: TObject);
    procedure cdsMesTMLGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure cdsMesMax_DURACAO_LOGINGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure QtdCheckBoxPChange(Sender: TObject);
    procedure QtdCheckBoxLChange(Sender: TObject);
  private
    procedure SetParamsSla(const Value: TParamsNiveisSla);
    procedure AjustaTipoDBChart;
    { Private declarations }
  protected
    FParamsSla: TParamsNiveisSla;
    procedure DefineCorChart; Override;
    procedure SetGraficoSla(const Value: Boolean); Override;
    procedure ExportarGrafico(const ExportarPara : TExportarPara); Override;
    procedure SetVisibleGraphics; Override;
    procedure ExportarDadosExcel; Override;
    procedure CalcularEstatisticas; Override;
    procedure CalcularEstatisticasSla; Override;
    procedure PrepararLkpsUnidades; Override;
  	procedure SetVisible(const aValue: Boolean); Override;
  public
    property ParamsSla: TParamsNiveisSla read FParamsSla write SetParamsSla;
  	constructor Create(aOwer: TComponent); Override;
    destructor Destroy; Override;
  end;

implementation

{$R *.fmx}

uses
  {$IFDEF SuportaQuickRep}
  VCL.Graphics, repGraphPausas,
  {$ENDIF SuportaQuickRep}
  Sics_Common_Splash, ufrmPesquisaRelatorioPausas, untCommonFrameBase,
  untCommonDMUnidades, Vcl.Clipbrd;

const
  AGRUPADOR_MP = 9;

constructor TfrmGraphicsPausas.Create(aOwer: TComponent);
begin
  inherited;
end;

procedure TfrmGraphicsPausas.ExportarGrafico(const ExportarPara : TExportarPara);
var
  Chart : TDBChart;
begin
  inherited;
  if pnlChartSla.Visible then
    Chart := dbChartSla
  else
    Chart := dbChartTmpTml;

  ExportarGrafico(ExportarPara, Chart);
end;

procedure TfrmGraphicsPausas.ExportarDadosExcel;
{$IFNDEF IS_MOBILE}
var
  LStringListTmp: TStringList;
  procedure exportToExcel;
    var
      ExcelApplication: TExcelApplication;
      ExcelWorkbook: TExcelWorkbook;
      ExcelWorksheet: TExcelWorksheet;
      iSheetIndex: Integer;
      iRowCount: Integer;

      procedure CriarSheet(const SheetName: string; DataSet: TDataSet; const CampoDescr: string);
      var
        cColExcel: Char;
        iField, iRowExcel: Integer;
        sValue: string;
      begin
        Inc(iSheetIndex);

        if iSheetIndex > ExcelWorkbook.Sheets.Count then
          ExcelWorkbook.Sheets.Add(EmptyParam, ExcelWorkbook.Sheets[iSheetIndex -1], EmptyParam, EmptyParam, lcid);

        ExcelWorksheet.ConnectTo(ExcelWorkbook.WorkSheets[iSheetIndex] as _Worksheet);
        ExcelWorksheet.Activate(LCID);
        ExcelWorksheet.Name := SheetName;

        with DataSet do
        begin
          First;
          iRowCount := RecordCount + 1;
          for iRowExcel := 1 to iRowCount do
          begin
            cColExcel := 'A';

            LStringListTmp := TStringList.Create;
            try
              LStringListTmp.Add(CampoDescr);

              if not FGraficoSla then
              begin
                LStringListTmp.Add('Qtd');
                LStringListTmp.Add('TMP');
                LStringListTmp.Add('QtdL');
                LStringListTmp.Add('TML');

                if vgParametrosModulo.ReportarTemposMaximos then
                begin
                  LStringListTmp.Add('MAX_DURACAO');
                  LStringListTmp.Add('MAX_DURACAO_LOGIN');
                end;
              end
              else
              begin
                LStringListTmp.Add('PERC_VERDE');
                LStringListTmp.Add('PERC_AMARELO');
                LStringListTmp.Add('PERC_VERMELHO');
                LStringListTmp.Add('PERC_CINZA');
              end;

              for iField := 0 to LStringListTmp.Count -1 do
              begin
                if iRowExcel = 1 then
                  sValue := FieldByName(LStringListTmp.Strings[iField]).DisplayLabel
                else
                  sValue := FieldByName(LStringListTmp.Strings[iField]).Text;

                with ExcelWorksheet.Range[cColExcel + IntToStr(iRowExcel), cColExcel + IntToStr(iRowExcel)] do
                begin
                  if iRowExcel = 1 then
                    Font.Bold := True;
                  Value2 := sValue;
                end;

                cColExcel := Chr(Ord(cColExcel)+1);
              end;

            finally
              FreeAndNil(LStringListTmp);
            end;

            if iRowExcel <> 1 then
              Next;
          end;
          First;
        end;
      end;
    begin


       try
         try

           iSheetIndex := 0;

           ExcelApplication := nil;
           ExcelWorkbook := nil;
           ExcelWorksheet := nil;
           try
             ExcelApplication := TExcelApplication.Create(nil);
             ExcelWorkbook := TExcelWorkbook.Create(nil);
             ExcelWorksheet := TExcelWorksheet.Create(nil);
             ExcelApplication.ConnectKind := ckNewInstance;

             LCID := GetUserDefaultLCID;
             ExcelApplication.DisplayAlerts[LCID] := False;
             ExcelApplication.Workbooks.Add(EmptyParam, LCID);
             ExcelWorkbook.ConnectTo(ExcelApplication.Workbooks[1] as _Workbook);

             ExcelApplication.ScreenUpdating[LCID] := true;

             if not FGraficoSla then
             begin
               CriarSheet('Mes', cdsMes, 'MesStr');
               CriarSheet('Dia', cdsDia, 'Dia');
               CriarSheet('Dia Sem', cdsDiaSm, 'DiaSmStr');
               CriarSheet('Hora', cdsHora, 'Hora');
               CriarSheet('Motivo Pausa', cdsMotivoPausa, 'MPNome');
               CriarSheet('Atend. Inicio', cdsAtend, 'AtdNome');
               CriarSheet('Grupo de Atend. Inicio', cdsGrAtend, 'GrAtendNome');
               CriarSheet('PA Inicio', cdsPa, 'PANome');
               CriarSheet('Grupo PA Inicio', cdsGrPa, 'GrPANome');
             end
             else
             begin
               CriarSheet('Mes'                   , cdsMesSla          , 'DESCRICAO');
               CriarSheet('Dia'                   , cdsDiaSla          , 'DESCRICAO');
               CriarSheet('Dia Sem'               , cdsDiaSmSla        , 'DESCRICAO');
               CriarSheet('Hora'                  , cdsHoraSla         , 'DESCRICAO');
               CriarSheet('Motivo Pausa'          , cdsMotivoPausaSla  , 'DESCRICAO');
               CriarSheet('Atend. Inicio'         , cdsAtendSla        , 'DESCRICAO');
               CriarSheet('Grupo de Atend. Inicio', cdsGrAtendSla      , 'DESCRICAO');
               CriarSheet('PA Inicio'             , cdsPaSla           , 'DESCRICAO');
               CriarSheet('Grupo PA Inicio'       , cdsGrPaSla         , 'DESCRICAO');
             end;

             // votlando pra primeira aba
             ExcelWorksheet.ConnectTo(ExcelWorkbook.Worksheets[1] as _Worksheet);
             ExcelWorksheet.Activate(LCID);
             ExcelWorkBook.SaveAs(SaveDialogExcel.FileName, xlWorkbookNormal, EmptyParam, EmptyParam,
               False, False, xlNoChange, xlLocalSessionChanges, EmptyParam, EmptyParam,
               EmptyParam, EmptyParam, LCID);
             ExcelWorkBook.Close;

           finally
             FreeAndNil(ExcelWorksheet);
             FreeAndNil(ExcelWorkbook);
             FreeAndNil(ExcelApplication);
           end;
         finally

         end;
         InformationMessage('Dados exportados.');
       except
         on E: Exception do
         begin
           ErrorMessage('Erro ao exportar os dados para Excel. Verifique se o Excel está instalado nesta máquina e se não é a versão "Starter"');
           raise;
         end;
       end;
    end;
begin

  if SaveDialogExcel.Execute then
    exportToExcel;

end;
{$ELSE}
begin
end;
{$ENDIF IS_MOBILE}


procedure TfrmGraphicsPausas.SetGraficoSla(const Value: Boolean);
begin
  if Value then
  begin
    MotivoPausaDS.DataSet := cdsMotivoPausaSla;

    MesDS.DataSet := cdsMesSla;
    DiaDS.DataSet := cdsDiaSla;
    DiaSmDS.DataSet := cdsDiaSmSla;
    HoraDS.DataSet := cdsHoraSla;
    AtendDS.DataSet := cdsAtendSla;
    GrAtendDS.DataSet := cdsGrAtendSla;
    PADS.DataSet := cdsPASla;
    GrPADS.DataSet := cdsGrPASla;
    UnidadeDS.DataSet := cdsUnidadeSla;
  end
  else
  begin
    MotivoPausaDS.DataSet := cdsMotivoPausa;

    MesDS.DataSet := cdsMes;
    DiaDS.DataSet := cdsDia;
    DiaSmDS.DataSet := cdsDiaSm;
    HoraDS.DataSet := cdsHora;
    AtendDS.DataSet := cdsAtend;
    GrAtendDS.DataSet := cdsGrAtend;
    PADS.DataSet := cdsPA;
    GrPADS.DataSet := cdsGrPA;
    UnidadeDS.DataSet := cdsUnidade;
  end;
  inherited;
end;

procedure TfrmGraphicsPausas.SetParamsSla(const Value: TParamsNiveisSla);
var
  LfrmPesquisaRelatorioPausas: TfrmPesquisaRelatorioPausas;
begin
  LfrmPesquisaRelatorioPausas := (Owner as TfrmPesquisaRelatorioPausas);
  FParamsSla := Value;

  TfrmSicsSplash.ShowStatus('Gerando os Gráficos...');
  try
   FMultiUnidades := LfrmPesquisaRelatorioPausas.vlRepVars.MultiUnidades <> '';

   if LfrmPesquisaRelatorioPausas.vlRepVars.QtdeUnidadesSelecionadas = 1 then
   begin
     if not LfrmPesquisaRelatorioPausas.cdsUnidades.Locate('SELECIONADO', True, []) then
       raise Exception.Create('Nenhuma unidade selecionada');
   end;

   PageControlGrids.TabIndex := 0;
   PageControlGridsChange(PageControlGrids);
   SetVisibleGraphics;

    try
      if not FGraficoSla then
        CalcularEstatisticas
      else
        CalcularEstatisticasSla;

      PeriodoDoRelatorioLabel.Text := LfrmPesquisaRelatorioPausas.vlRepVars.PeriodoDoRelatorio;
      PeriodoDoDiaLabel.Text       := LfrmPesquisaRelatorioPausas.vlRepVars.PeriodoDoDia;
      DuracaoLabel.Text            := LfrmPesquisaRelatorioPausas.vlRepVars.Duracao;
      AtendentesInicioLabel.Text   := LfrmPesquisaRelatorioPausas.vlRepVars.Atds;
      PAsInicioLabel.Text          := LfrmPesquisaRelatorioPausas.vlRepVars.PAs;
      lblUnidadesVal.Visible          := FMultiUnidades;
      lblUnidades.Visible             := FMultiUnidades;
      lblUnidadesVal.Text          := LfrmPesquisaRelatorioPausas.vlRepVars.MultiUnidades;
      MotivosPausaLabel.Text       := LfrmPesquisaRelatorioPausas.vlRepVars.MPs;

      if LfrmPesquisaRelatorioPausas.vlRepVars.QtdeUnidadesSelecionadas > 1 then
      begin
        tbsAtendentes    .Visible := False;
        tbsGrupoAtendente.Visible := False;
        tbsPA            .Visible := False;
        tbsGrupoPA       .Visible := False;
        tbsUnidades      .Visible := True;
      end
      else
      begin
        tbsMes.Visible            := True;
        tbsDia.Visible            := True;
        tbsDiaSemana.Visible      := True;
        tbsHora.Visible           := True;
        tbsAtendentes.Visible     := True;
        tbsGrupoAtendente.Visible := True;
        tbsPA.Visible             := True;
        tbsGrupoPA.Visible        := True;
        tbsMotivoPausa.Visible    := True;
        tbsUnidades.Visible       := False;
      end;

      if FGraficoSLA then
      begin
        lblParamsSLAPausasVermelho.Text  := FormatDateTime('hh:mm:ss', IncSecond(0, FPAramsSLA.Vermelho));
        lblParamsSLAPausasAmarelo.Text   := FormatDateTime('hh:mm:ss', IncSecond(0, FPAramsSLA.Amarelo ));
      end;

      AjustaTipoDBChart;
    finally

    end;  { try .. finally }
  finally
    TfrmSicsSplash.Hide;
  end;
end;

procedure TfrmGraphicsPausas.SetVisible(const aValue: Boolean);
begin
  inherited;
  if aValue then
    PageControlGrids.OnChange(PageControlGrids);
end;

procedure TfrmGraphicsPausas.SetVisibleGraphics;
begin

  if FGraficoSla then
  begin
    rectTotais.Visible    := False            ;
  end;

  pnlChartSla.Visible := FGraficoSla;
  pnlGraficosTmpTml.Visible := not pnlChartSla.Visible;

  rectApresentar.Visible := not FGraficoSla;
  rectApresentarSLA.Visible := FGraficoSla;
  rectParametrosSLA.Visible := FGraficoSla;
end;

{=================================================================}
{               Procedures Table.CalcFields                       }
{=================================================================}

procedure TfrmGraphicsPausas.cdsMesCalcFields(DataSet: TDataSet);
begin
  cdsMesMesStr.AsString := String(MesStrArray[cdsMesMes.AsInteger]);
end;

procedure TfrmGraphicsPausas.cdsMesMax_DURACAO_LOGINGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text := MyFormatDateTime('[h]:nn:ss', Sender.AsDateTime);
end;

procedure TfrmGraphicsPausas.cdsDiaSmCalcFields(DataSet: TDataSet);
begin
  cdsDiaSmDiaSmStr.AsString := String(DiaSmStrArray[cdsDiaSmDiaSm.AsInteger]);
end;

procedure TfrmGraphicsPausas.cdsAtendCalcFields(DataSet: TDataSet);
begin
  cdsAtendAtdRecNo.AsInteger := cdsAtend.RecNo;
end;

procedure TfrmGraphicsPausas.cdsGrAtendCalcFields(DataSet: TDataSet);
begin
  cdsGrAtendGrAtendRecNo.AsInteger := cdsGrAtend.RecNo;
end;

procedure TfrmGraphicsPausas.cdsPACalcFields(DataSet: TDataSet);
begin
  cdsPAPARecNo.AsInteger := cdsPA.RecNo;
end;

procedure TfrmGraphicsPausas.cdsGrPACalcFields(DataSet: TDataSet);
begin
  cdsGrPAGrPARecNo.AsInteger := cdsGrPA.RecNo;
end;

procedure TfrmGraphicsPausas.cdsUnidadeCalcFields(DataSet: TDataSet);
begin
  cdsUnidadeUnidadeRecNo.AsInteger := cdsUnidade.RecNo;
end;

procedure TfrmGraphicsPausas.cdsMotivoPausaCalcFields(DataSet: TDataSet);
begin
  cdsMotivoPausaMPRecNo.AsInteger := cdsMotivoPausa.RecNo;
end;

{=================================================================}
{                 Procedures Field.GetText                        }
{=================================================================}

procedure TfrmGraphicsPausas.cdsUnidadeUnidadeNomeGetText (Sender: TField;
                                                      var Text: String; DisplayText: Boolean);
begin
  Text := dmUnidades.Nome[cdsUnidadeUnidade.AsInteger];
end;


procedure TfrmGraphicsPausas.QtdChartTypeComboChange(Sender: TObject);
begin
   dbPieChartTmpTml.Visible :=  dbChartTmpTml.Visible and (QtdChartTypeCombo.ItemIndex = 1);
   dbChartTmpTml   .Visible := not  dbPieChartTmpTml.Visible;
  RotateCCWBtn.Visible := dbPieChartTmpTml.Visible;
  RotateCWBtn.Visible := RotateCCWBtn.Visible;
end;


procedure TfrmGraphicsPausas.QtdCheckBoxLChange(Sender: TObject);
begin
  cdsMesQtdL.Visible      := QtdCheckBoxL.IsChecked;
  cdsDiaQtdL.Visible      := QtdCheckBoxL.IsChecked;

  cdsDiaSmQtdL.Visible    := QtdCheckBoxL.IsChecked;
  cdsHoraQtdL.Visible     := QtdCheckBoxL.IsChecked;
  cdsAtendQtdL.Visible    := QtdCheckBoxL.IsChecked;
  cdsGrAtendQtdL.Visible  := true;
  cdsPAQtdL.Visible       := QtdCheckBoxL.IsChecked;

  cdsGrPAQtdL.Visible     := true;
  cdsUnidadeQtdL.Visible  := QtdCheckBoxL.IsChecked;

  cdsMesTML.Visible          := TMLCheckBox.IsChecked;
  cdsDiaTML.Visible          := TMLCheckBox.IsChecked;
  cdsDiaSmTML.Visible        := TMLCheckBox.IsChecked;
  cdsHoraTML.Visible         := TMLCheckBox.IsChecked;
  cdsAtendTML.Visible        := TMLCheckBox.IsChecked;
  cdsGrAtendTML.Visible      := TMLCheckBox.IsChecked;
  cdsPATML.Visible           := TMLCheckBox.IsChecked;
  cdsGrPATML.Visible         := TMLCheckBox.IsChecked;
  cdsUnidadeTML.Visible      := TMLCheckBox.IsChecked;

  AtualizarColunasGrid;

  if (QtdCheckBoxL.IsChecked and (not TMLCheckBox.IsChecked) and (not TMPCheckBox.IsChecked)) then
    QtdChartTypeCombo.Enabled := true;

  AjustaTipoDBChart;

  barSeriesTMP.Active := TMPCheckBox.IsChecked;
  barSeriesTML.Active := TMLCheckBox.IsChecked;
  LineSeriesQTDP.Active := QtdCheckBoxP.IsChecked and TMPCheckBox.IsChecked;
  LineSeriesQTDL.Active := QtdCheckBoxL.IsChecked and TMLCheckBox.IsChecked;

  MesQtdBarSeries.Active := (QtdCheckBoxP.IsChecked and (not TMPCheckBox.IsChecked) and (not TMLCheckBox.IsChecked));
end;

procedure TfrmGraphicsPausas.QtdCheckBoxPChange(Sender: TObject);
begin
  cdsMesQtd.Visible       := QtdCheckBoxP.IsChecked;
  cdsDiaQtd.Visible       := QtdCheckBoxP.IsChecked;
  cdsDiaSmQtd.Visible     := QtdCheckBoxP.IsChecked;
  cdsHoraQtd.Visible      := QtdCheckBoxP.IsChecked;
  cdsAtendQtd.Visible     := QtdCheckBoxP.IsChecked;

  cdsGrAtendQtd.Visible   := true;
  cdsPAQtd.Visible        := QtdCheckBoxP.IsChecked;

  cdsGrPAQtd.Visible      := true;
  cdsUnidadeQtd.Visible   := QtdCheckBoxP.IsChecked;

  cdsMesTMP.Visible       := TMPCheckBox.IsChecked;
  cdsDiaTMP.Visible       := TMPCheckBox.IsChecked;
  cdsDiaSmTMP.Visible     := TMPCheckBox.IsChecked;
  cdsHoraTMP.Visible      := TMPCheckBox.IsChecked;
  cdsAtendTMP.Visible     := TMPCheckBox.IsChecked;
  cdsGrAtendTMP.Visible   := TMPCheckBox.IsChecked;
  cdsPATMP.Visible        := TMPCheckBox.IsChecked;
  cdsGrPATMP.Visible      := TMPCheckBox.IsChecked;
  cdsUnidadeTMP.Visible   := TMPCheckBox.IsChecked;

  AtualizarColunasGrid;

  if (QtdCheckBoxP.IsChecked and (not TMPCheckBox.IsChecked) and (not TMLCheckBox.IsChecked)) then
    QtdChartTypeCombo.Enabled := true;

  AjustaTipoDBChart;

  barSeriesTMP.Active := TMPCheckBox.IsChecked;
  barSeriesTML.Active := TMLCheckBox.IsChecked;
  LineSeriesQTDP.Active := QtdCheckBoxP.IsChecked and TMPCheckBox.IsChecked;
  LineSeriesQTDL.Active := QtdCheckBoxL.IsChecked and TMLCheckBox.IsChecked;

  MesQtdBarSeries.Active := (QtdCheckBoxP.IsChecked and (not TMPCheckBox.IsChecked) and (not TMLCheckBox.IsChecked));
end;

procedure TfrmGraphicsPausas.RotateCCWBtnClick(Sender: TObject);
begin
  RotacionarPie((dbPieChartTmpTml.Series[0] as TPieSeries), False);
end;

procedure TfrmGraphicsPausas.RotateCWBtnClick(Sender: TObject);
begin
  RotacionarPie((dbPieChartTmpTml.Series[0] as TPieSeries), True);
end;


procedure TfrmGraphicsPausas.QtdEspAtdComboChange(Sender: TObject);
begin
  cdsMesQtd        .Visible := QtdCheckBoxP.IsChecked;
  cdsDiaQtd        .Visible := QtdCheckBoxP.IsChecked;
  cdsDiaSmQtd      .Visible := QtdCheckBoxP.IsChecked;
  cdsHoraQtd       .Visible := QtdCheckBoxP.IsChecked;
  cdsAtendQtd      .Visible := QtdCheckBoxP.IsChecked;
  cdsGrAtendQtd    .Visible := QtdCheckBoxP.IsChecked;
  cdsPAQtd         .Visible := QtdCheckBoxP.IsChecked;
  cdsGrPAQtd       .Visible := QtdCheckBoxP.IsChecked;
  cdsUnidadeQtd    .Visible := QtdCheckBoxP.IsChecked;
  cdsMotivoPausaQtd.Visible := QtdCheckBoxP.IsChecked;
end;

procedure TfrmGraphicsPausas.actImprimirExecute(Sender: TObject);
{$IFDEF SuportaQuickRep}
var
  DS : TDataSet;
  qrSicsGraphicPausas: TqrSicsGraphicPausas;
{$ENDIF SuportaQuickRep}
begin
  {$IFDEF SuportaQuickRep}
  DS := nil;
  qrSicsGraphicPausas := TqrSicsGraphicPausas.Create(Self);
  try
    with qrSicsGraphicPausas do
    begin
      ItemLabel      .Enabled := not FGraficoSla;
      QtdPausasLabel .Enabled := not FGraficoSla;
      TMPLabel       .Enabled := not FGraficoSla;
      ItemDBText     .Enabled := not FGraficoSla;
      QtdPausasDBText.Enabled := not FGraficoSla;
      TMPDBText      .Enabled := not FGraficoSla;
      QtdLoginsLabel .Enabled := not FGraficoSla;
      TMLLabel       .Enabled := not FGraficoSla;
      QtdLoginsDBText.Enabled := not FGraficoSla;
      TMLDBText      .Enabled := not FGraficoSla;

      qrlblSlaPausas             .Enabled := FGraficoSla;
      qrShapeSlaPausas           .Enabled := FGraficoSla;
      qrlblPausasPercVerde       .Enabled := FGraficoSla;
      qrlblPausasPercAmarelo     .Enabled := FGraficoSla;
      qrlblPausasPercVermelho    .Enabled := FGraficoSla;
      qrlblPausasPercCinza       .Enabled := FGraficoSla;
      qrlblSlaDescricao          .Enabled := FGraficoSla;
      qrdbtextSlaDescricao       .Enabled := FGraficoSla;
      qrdbtextPausasPercVerde    .Enabled := FGraficoSla;
      qrdbtextPausasPercAmarelo  .Enabled := FGraficoSla;
      qrdbtextPausasPercVermelho .Enabled := FGraficoSla;
      qrdbtextPausasPercCinza    .Enabled := FGraficoSla;

      if FGraficoSla then
      begin
        qrlblSlaPausas            .Top := ItemLabel.Top;
        qrShapeSlaPausas          .Top := ItemLabel.Top + 17;
        qrlblSlaDescricao         .Top := qrShapeSlaPausas.Top + 2;
        qrlblPausasPercVerde      .Top := qrlblSlaDescricao.Top;
        qrlblPausasPercAmarelo    .Top := qrlblSlaDescricao.Top;
        qrlblPausasPercVermelho   .Top := qrlblSlaDescricao.Top;
        qrlblPausasPercCinza      .Top := qrlblSlaDescricao.Top;
        qrdbtextSlaDescricao      .Top := 2;
        qrdbtextPausasPercVerde   .Top := 2;
        qrdbtextPausasPercAmarelo .Top := 2;
        qrdbtextPausasPercVermelho.Top := 2;
        qrdbtextPausasPercCinza   .Top := 2;
      end;

      if FGraficoSla then
        ColumnHeaderBand.Height := 45
      else
        ColumnHeaderBand.Height := 24;
      DetailBand.Height := 16;
      SummaryBand.Enabled := not FGraficoSla;
    end;

    if not FGraficoSla then
    begin
      case PageControlGrids.TabIndex of
        0 : begin
               ds := cdsMes;
              qrSicsGraphicPausas.ItemLabel .Caption := 'Mês';
              qrSicsGraphicPausas.ItemDBText.DataField := 'MesStr';
            end;
        1 : begin
               ds := cdsDia;
              qrSicsGraphicPausas.ItemLabel .Caption := 'Dia';
              qrSicsGraphicPausas.ItemDBText.DataField := 'Dia';
            end;
        2 : begin
               ds := cdsDiaSm;
              qrSicsGraphicPausas.ItemLabel .Caption := 'Dia da Semana';
              qrSicsGraphicPausas.ItemDBText.DataField := 'DiaSmStr';
            end;
        3 : begin
               ds := cdsHora;
              qrSicsGraphicPausas.ItemLabel .Caption := 'Hora';
              qrSicsGraphicPausas.ItemDBText.DataField := 'Hora';
            end;
        4 : begin
               ds := cdsMotivoPausa;
              qrSicsGraphicPausas.ItemLabel .Caption := 'Motivo Pausa';
              qrSicsGraphicPausas.ItemDBText.DataField := 'MPNome';
            end;
        5 : begin
               ds := cdsAtend;
              qrSicsGraphicPausas.ItemLabel .Caption := 'Atendente';
              qrSicsGraphicPausas.ItemDBText.DataField := 'AtdNome';
            end;
        6 : begin
               ds := cdsGrAtend;
              qrSicsGraphicPausas.ItemLabel .Caption := 'Grupo de Atendente';
              qrSicsGraphicPausas.ItemDBText.DataField := 'GrAtendNome';
            end;
        7 : begin
               ds := cdsPA;
              qrSicsGraphicPausas.ItemLabel .Caption := 'PA';
              qrSicsGraphicPausas.ItemDBText.DataField := 'PANome';
            end;
        8 : begin
               ds := cdsGrPA;
              qrSicsGraphicPausas.ItemLabel .Caption := 'Grupo de PA';
              qrSicsGraphicPausas.ItemDBText.DataField := 'GrPANome';
            end;
        9 : begin
               ds := cdsUnidade;
              qrSicsGraphicPausas.ItemLabel .Caption := 'Unidade';
              qrSicsGraphicPausas.ItemDBText.DataField := 'UnidadeNome';

            end;
      end;  { case }



      if QtdChartTypeCombo.ItemIndex = 0 then
        dbChartTmpTml.MakeScreenshot.SaveToFile(SettingsPathName + 'Graphics.bmp')
      else
        dbPieChartTmpTml.MakeScreenshot.SaveToFile(SettingsPathName + 'Graphics.bmp');

      qrSicsGraphicPausas.QrImageChart.Picture.LoadFromFile(SettingsPathName + 'Graphics.bmp');

      qrSicsGraphicPausas.DataSet            := DS;
      qrSicsGraphicPausas.ItemDBText.DataSet := DS;

      if QtdCheckBoxP.IsChecked then
        qrSicsGraphicPausas.QtdPausasDBText.DataSet := DS
      else
        qrSicsGraphicPausas.QtdPausasDBText.DataSet := nil;

      if TMPCheckBox.IsChecked then
        qrSicsGraphicPausas.TMPDBText .DataSet := DS
      else
        qrSicsGraphicPausas.TMPDBText .DataSet := nil;
    end
    else
    begin
      case PageControlGrids.TabIndex of
        0 : begin
              qrSicsGraphicPausas.qrlblSlaDescricao.Caption := 'Mês';
               ds := cdsMesSla;
            end;
        1 : begin
              qrSicsGraphicPausas.qrlblSlaDescricao.Caption := 'Dia';
               ds := cdsDiaSla;
            end;
        2 : begin
              qrSicsGraphicPausas.qrlblSlaDescricao.Caption := 'Dia da Semana';
               ds := cdsDiaSmSla;
            end;
        3 : begin
              qrSicsGraphicPausas.qrlblSlaDescricao.Caption := 'Hora';
               ds := cdsHoraSla;
            end;
        4 : begin
              qrSicsGraphicPausas.qrlblSlaDescricao.Caption := 'Motivo Pausa';
               ds := cdsMotivoPausaSla;
            end;
        5 : begin
              qrSicsGraphicPausas.qrlblSlaDescricao.Caption := 'Atendente';
               ds := cdsAtendSla;
            end;
        6 : begin
              qrSicsGraphicPausas.qrlblSlaDescricao.Caption := 'Grupo Atendente';
               ds := cdsGrAtendSla;
            end;
        7 : begin
              qrSicsGraphicPausas.qrlblSlaDescricao.Caption := 'PA';
               ds := cdsPASla;
            end;
        8 : begin
              qrSicsGraphicPausas.qrlblSlaDescricao.Caption := 'Grupo de PA';
               ds := cdsGrPASla;
            end;
        9 : begin
              qrSicsGraphicPausas.qrlblSlaDescricao.Caption := 'Unidade';
               ds := cdsUnidadeSla;
            end;
        end;

      qrSicsGraphicPausas.qrdbtextSlaDescricao      .DataSet := DS;
      qrSicsGraphicPausas.qrdbtextPausasPercVerde   .DataSet := DS;
      qrSicsGraphicPausas.qrdbtextPausasPercAmarelo .DataSet := DS;
      qrSicsGraphicPausas.qrdbtextPausasPercVermelho.DataSet := DS;
      qrSicsGraphicPausas.qrdbtextPausasPercCinza   .DataSet := DS;
      qrSicsGraphicPausas.DataSet := DS;

      dbChartSla.MakeScreenshot.SaveToFile(SettingsPathName + 'Graphics.bmp');
      qrSicsGraphicPausas.QrImageChart.Picture.LoadFromFile(SettingsPathName + 'Graphics.bmp');

    end;

    qrSicsGraphicPausas.Prepare;

     qrSicsGraphicPausas.QrImageChart.Top         := qrSicsGraphicPausas.DetailBand.Top + qrSicsGraphicPausas.DetailBand.Height * (qrSicsGraphicPausas.RecordCount + 1) + qrSicsGraphicPausas.SummaryBand.Height;
     qrSicsGraphicPausas.QrImageChart.Height      := Trunc(qrSicsGraphicPausas.Page.Length) - Trunc(qrSicsGraphicPausas.Page.BottomMargin) -
                                               (qrSicsGraphicPausas.DetailBand.Top + qrSicsGraphicPausas.DetailBand.Height * 32 + qrSicsGraphicPausas.SummaryBand.Height);
     if (qrSicsGraphicPausas.QrImageChart.Height < 0) then
      qrSicsGraphicPausas.QrImageChart.Height := qrSicsGraphicPausas.QrImageChart.Height * -1;
     qrSicsGraphicPausas.QrImageChart.Left        := qrSicsGraphicPausas.PageHeaderBand.Left;
     qrSicsGraphicPausas.QrImageChart.Width       := qrSicsGraphicPausas.PageHeaderBand.Width;

    qrSicsGraphicPausas.AtendantsLabel         .Caption := AtendentesInicioLabel  .Text;
    qrSicsGraphicPausas.PAsLabel               .Caption := PAsInicioLabel         .Text;
    qrSicsGraphicPausas.PeriodoDoRelatorioLabel.Caption := PeriodoDoRelatorioLabel.Text;
    qrSicsGraphicPausas.PeriodoDoDiaLabel      .Caption := PeriodoDoDiaLabel      .Text;
    qrSicsGraphicPausas.DurationLabel          .Caption := DuracaoLabel           .Text;
    qrSicsGraphicPausas.MotivosPausaLabel      .Caption := MotivosPausaLabel      .Text;

    qrSicsGraphicPausas.lblMultiUnidades   .Enabled := FMultiUnidades;
    qrSicsGraphicPausas.lblMultiUnidadesVal.Enabled := FMultiUnidades;
    qrSicsGraphicPausas.lblMultiUnidadesVal.Caption := lblUnidadesVal.Text;

    if FMultiUnidades then
    begin
      qrSicsGraphicPausas.lblRelatorio.Caption := '';
      qrSicsGraphicPausas.UnidadeLabel.Caption := '';
    end
    else
    begin
      qrSicsGraphicPausas.lblRelatorio.Caption := 'Relatório de Pausas e Logins';
      qrSicsGraphicPausas.UnidadeLabel.Caption := vgParametrosModulo.Unidade;
    end;

    qrSicsGraphicPausas.TotaisQtdPausasLabel.Caption := QtdPausasLabel.Text;
    qrSicsGraphicPausas.TotaisTMPLabel      .Caption := TMPLabel      .Text;
    qrSicsGraphicPausas.TotaisQtdLoginsLabel.Caption := QtdLoginsLabel.Text;
    qrSicsGraphicPausas.TotaisTMLLabel      .Caption := TMLLabel      .Text;
    qrSicsGraphicPausas.PreviewModal;
  finally
    FreeAndNil(qrSicsGraphicPausas);
  end;
  {$ENDIF SuportaQuickRep}
end;

procedure TfrmGraphicsPausas.AjustaTipoDBChart;
begin
  //if (QtdPausasLoginsCombo.ItemIndex = -1) then
   // QtdPausasLoginsCombo.ItemIndex := 0;

  if (QtdChartTypeCombo.ItemIndex = -1) then
    QtdChartTypeCombo.ItemIndex := 0;
end;


{ proc ActionImprimir }


procedure TfrmGraphicsPausas.btnCloseFrameClick(Sender: TObject);
begin
  inherited;
//
end;

procedure TfrmGraphicsPausas.cdsMesTestesCalcFields(DataSet: TDataSet);
begin
  // VER COMO FUNCIONA O MSCES
 // cdsMesTestesTME.AsDateTime := TimeStampToDateTime(MSecsToTimeStamp(cdsMesTestesTME_MSECS.AsInteger));
 // cdsMesTestesTMA.AsDateTime := TimeStampToDateTime(MSecsToTimeStamp(cdsMesTestesTMA_MSECS.AsInteger));
end;


procedure TfrmGraphicsPausas.cdsMesTMLGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text := MyFormatDateTime('[h]:nn:ss', Sender.AsDateTime);
end;

procedure TfrmGraphicsPausas.cdsMesTMPGetText(Sender: TField; var Text: String;
  DisplayText: Boolean);
begin
  Text := MyFormatDateTime('[h]:nn:ss', Sender.AsDateTime);
end;

procedure TfrmGraphicsPausas.CalcularEstatisticas;

  function SegundosParaDateTime(Segundos: Integer): TDateTime;
  begin
    Result := IncSecond(0, Segundos);
  end;

  function DateTimeToSegundos(Data: TDateTime): Integer;
  begin
    Result := SecondsBetween(0, Data);
  end;
var
  iAgrupador, LIdUnidade: Integer;
  CdsTemp: TClientDataSet;
  sCampoId, sDescricao, sWhere, sInTags, sCampoDescricao: string;
  iQtdPTotal, iTMPTotal, iNovoTMP, iNovoTML: Integer;
  qryEstatisticasTemp: TFDQuery;
  DataSetDescricao: TDataSet;
  sMax,NomeUnidade: string;
  LfrmPesquisaRelatorioPausas: TfrmPesquisaRelatorioPausas;
  iQtdLTotal: Integer;
  iTMLTotal: Integer;
begin
  iNovoTML := 0;
  LfrmPesquisaRelatorioPausas := (Owner as TfrmPesquisaRelatorioPausas);
  qryEstatisticas.Sql.Text := FSqlEstatisticas;
  qryEstatisticas.Sql.Add ('where E.ID_UNIDADE = :ID_UNIDADE AND                                                   ');
  LfrmPesquisaRelatorioPausas.MontarWhere(qryEstatisticas, sInTags, False);
  sWhere := Copy(qryEstatisticas.Sql.Text, Length(FSqlEstatisticas), Length(qryEstatisticas.Sql.Text) - Length(FSqlEstatisticas));

  //LM
  //Adcionado pois pois adcionava o numero 2 na frente //verificar
  Delete(sWhere,1,1);

  qryEstatisticas.Sql.Text := StringReplace(FSqlEstatisticas, '/* WHERE */', sWhere, [rfReplaceAll, rfIgnoreCase]);

  if vgParametrosModulo.ReportarTemposMaximos then
  begin
    sMax := 'COALESCE( MAX( (CASE WHEN E.ID_TIPOEVENTO = 5 THEN E.DURACAO_SEGUNDOS END) ), 0) AS MAX_DURACAO,' + #13 + #10 +
            'COALESCE( MAX( (CASE WHEN E.ID_TIPOEVENTO = 4 THEN E.DURACAO_SEGUNDOS END) ), 0) AS MAX_DURACAO_LOGIN,';
    qryEstatisticas.Sql.Text := StringReplace(qryEstatisticas.Sql.Text, '/* MAX_TP_TL */', sMax, [rfReplaceAll, rfIgnoreCase]);
  end;

  Self.cdsMes         .Close;
  Self.cdsHora        .Close;
  Self.cdsDia         .Close;
  Self.cdsDiaSm       .Close;
  Self.cdsAtend       .Close;
  Self.cdsPA          .Close;
  Self.cdsGrAtend     .Close;
  Self.cdsGrPA        .Close;
  Self.cdsUnidade     .Close;
  Self.cdsMotivoPausa .Close;

  Self.cdsMes         .CreateDataSet;
  Self.cdsHora        .CreateDataSet;
  Self.cdsDia         .CreateDataSet;
  Self.cdsDiaSm       .CreateDataSet;
  Self.cdsAtend       .CreateDataSet;
  Self.cdsPA          .CreateDataSet;
  Self.cdsGrAtend     .CreateDataSet;
  Self.cdsGrPA        .CreateDataSet;
  Self.cdsUnidade     .CreateDataSet;
  Self.cdsMotivoPausa .CreateDataSet;

  iQtdPTotal := 0;
  iTMPTotal  := 0;
  iQtdLTotal := 0;
  iTMLTotal  := 0;

  LfrmPesquisaRelatorioPausas.cdsUnidades.First;
  while not LfrmPesquisaRelatorioPausas.cdsUnidades.Eof do
  begin

    if not LfrmPesquisaRelatorioPausas.cdsUnidades.FieldByName('SELECIONADO').AsBoolean then
    begin
      LfrmPesquisaRelatorioPausas.cdsUnidades.Next;
      Continue;
    end;

    LIdUnidade := LfrmPesquisaRelatorioPausas.cdsUnidades.FieldByName('ID').AsInteger;
    NomeUnidade := LfrmPesquisaRelatorioPausas.cdsUnidades.FieldByName('NOME').AsString;
    PrepararLkpsUnidades;

    // devido a um bug na dbexpress, temos que criar uma nova sqlquery quando muda
    // a conexao, pois o clientedataset nao consegue "enxergar" as mudancas
    qryEstatisticasTemp := TFDQuery.Create(Self);
    try
      qryEstatisticas.ParamByName('ID_UNIDADE').DataType := ftInteger;
      qryEstatisticas.ParamByName('ID_UNIDADE').AsInteger := LIdUnidade;

      qryEstatisticasTemp.Sql.Text := qryEstatisticas.Sql.Text;
      qryEstatisticasTemp.Params.Assign(qryEstatisticas.Params);
      qryEstatisticasTemp.Connection := DMClient(LIdUnidade, not CRIAR_SE_NAO_EXISTIR).ConnRelatorio;
      dspEstatisticas.DataSet := qryEstatisticasTemp;
      qryEstatisticas.Prepare;
      {$IFDEF DEBUG}
      //para conseguir pegar a SQL "pós processamento das macros" é necessário
      //chamar o método Prepare

      ClipBoard.AsText := qryEstatisticas.Text;
      {$ENDIF}

      cdsEstatisticas.Open;
      try
        cdsEstatisticas.Filtered := True;

        for iAgrupador := AGRUPADOR_MES to AGRUPADOR_MP do
        begin
          case iAgrupador of
            AGRUPADOR_MES:
            begin
              CdsTemp := Self.cdsMes;
              sCampoId := 'Mes';
              sDescricao := 'Mês';
              DataSetDescricao := nil;
            end;
            AGRUPADOR_DIA:
            begin
              CdsTemp := Self.cdsDia;
              sCampoId := 'Dia';
              sDescricao := 'Dia';
              DataSetDescricao := nil;
            end;
            AGRUPADOR_SEMANA:
            begin
              CdsTemp := Self.cdsDiaSm;
              sCampoId := 'DiaSm';
              sDescricao := 'Semana';
              DataSetDescricao := nil;
            end;
            AGRUPADOR_HORA:
            begin
              CdsTemp := Self.cdsHora;
              sCampoId := 'Hora';
              sDescricao := 'Hora';
              DataSetDescricao := nil;
            end;
            AGRUPADOR_ATENDENTE:
            begin
              CdsTemp := Self.cdsAtend;
              sCampoId := 'Atend';
              sDescricao := 'Atendente';
              DataSetDescricao := cdsLkpAtendentes;
              sCampoDescricao := 'AtdNome';
            end;
            AGRUPADOR_GRUPO_ATENDENTE:
            begin
              CdsTemp := Self.cdsGrAtend;
              sCampoId := 'GrAtend';
              sDescricao := 'Grupo de Atendente';
              DataSetDescricao := cdsLkpGruposAtendentes;
              sCampoDescricao := 'GrAtendNome';
            end;
            AGRUPADOR_PA:
            begin
              CdsTemp := Self.cdsPA;
              sCampoId := 'PA';
              sDescricao := 'PA';
              DataSetDescricao := cdsLkpPAS;
              sCampoDescricao := 'PANome';
            end;
            AGRUPADOR_GRUPO_PA:
            begin
              CdsTemp := Self.cdsGrPA;
              sCampoId := 'GrPA';
              sDescricao := 'Grupo de PA';
              DataSetDescricao := cdsLkpGruposPAs;
              sCampoDescricao := 'GrPANome';
            end;
            AGRUPADOR_MP:
            begin
              CdsTemp := Self.cdsMotivoPausa;
              sCampoId := 'MP';
              sDescricao := 'MP';
              DataSetDescricao := cdsLkpMotivosPausa;
              sCampoDescricao := 'MPNome';
            end;
            else
            begin
              CdsTemp := nil;
              sCampoId := '';
              sDescricao := '';
              DataSetDescricao := nil;
              sCampoDescricao := '';
            end;
          end;
         if LfrmPesquisaRelatorioPausas.vlRepVars.QtdeUnidadesSelecionadas > 1 then
            CdsTemp.FieldByName('NomeUnidade').Visible := true
         else
            CdsTemp.FieldByName('NomeUnidade').Visible := false;

          TfrmSicsSplash.ShowStatus('Gravando dados -  por ' + sDescricao + '...');
          with cdsEstatisticas do
          begin
            Filter := 'AGRUPADOR=' + IntToStr(iAgrupador);
            Filtered := True;
            try
              First;
              while not Eof do
              begin
                if cdsTemp.Locate(sCampoId, FieldByName('ID').Value, []) then
                begin
                  cdsTemp.Edit;
                  {$REGION 'Calcula TMP_Qtde e TMP'}
                    if cdsTemp.FieldByName('Qtd').AsInteger > 0 then
                      iNovoTMP := Round(
                        ( (cdsTemp.FieldByName('Qtd').AsInteger * DateTimeToSegundos(cdsTemp.FieldByName('TMP').AsDateTime)) +
                          (cdsTemp.FieldByName('Qtd').AsInteger * FieldByName('TMP').AsInteger)
                        ) /
                        (cdsTemp.FieldByName('Qtd').AsInteger + FieldByName('QtdP').AsInteger)
                      )
                    else
                      iNovoTMP := FieldByName('TMP').AsInteger;

                    cdsTemp.FieldByName('TMP').AsDateTime := SegundosParaDateTime(iNovoTMP);
                    cdsTemp.FieldByName('Qtd').AsInteger := cdsTemp.FieldByName('Qtd').AsInteger + FieldByName('QtdP').AsInteger;

                    if vgParametrosModulo.ReportarTemposMaximos then
                    begin
                      cdsTemp.FieldByName('MAX_DURACAO').AsDateTime := SegundosParaDateTime(Max(DateTimeToSegundos(cdsTemp.FieldByName('MAX_DURACAO').AsDateTime), FieldByName('MAX_DURACAO').AsInteger));
                    end;
                  {$ENDREGION}

                  {$REGION 'Calcula TML_Qtde e TML'}
                    if cdsTemp.FieldByName('QtdL').AsInteger > 0 then
                      iNovoTML := Round(
                        ( (cdsTemp.FieldByName('QtdL').AsInteger * DateTimeToSegundos(cdsTemp.FieldByName('TML').AsDateTime)) +
                          (FieldByName('QtdL').AsInteger * FieldByName('TML').AsInteger)
                        ) /
                        (cdsTemp.FieldByName('QtdL').AsInteger + FieldByName('QtdL').AsInteger)
                      );
//                    else
//                      iNovoTMP := FieldByName('TML').AsInteger;

                    cdsTemp.FieldByName('TML').AsDateTime := SegundosParaDateTime(iNovoTML);
                    cdsTemp.FieldByName('QtdL').AsInteger := cdsTemp.FieldByName('QtdL').AsInteger + FieldByName('QtdL').AsInteger;

                    if vgParametrosModulo.ReportarTemposMaximos then
                    begin
                      cdsTemp.FieldByName('MAX_DURACAO_LOGIN').AsDateTime := SegundosParaDateTime(Max(DateTimeToSegundos(cdsTemp.FieldByName('MAX_DURACAO_LOGIN').AsDateTime), FieldByName('MAX_DURACAO_LOGIN').AsInteger));
                    end;
                  {$ENDREGION}

                end
                else
                begin
                  cdsTemp.Append;
                  cdsTemp.FieldByName(sCampoId).Value    := FieldByName('ID').Value;
                  cdsTemp.FieldByName('Qtd').AsInteger   := FieldByName('QtdP').AsInteger;
                  cdsTemp.FieldByName('TMP').AsDateTime  := SegundosParaDateTime(FieldByName('TMP').AsInteger);
                  cdsTemp.FieldByName('QtdL').AsInteger  := FieldByName('QtdL').AsInteger;
                  cdsTemp.FieldByName('TML').AsDateTime  := SegundosParaDateTime(FieldByName('TML').AsInteger);
                  CdsTemp.FieldByName('IdUnidade').AsInteger := LIdUnidade;
                  CdsTemp.FieldByName('NomeUnidade').AsString := NomeUnidade;

                  if vgParametrosModulo.ReportarTemposMaximos then
                  begin
                    cdsTemp.FieldByName('MAX_DURACAO').AsDateTime := SegundosParaDateTime(FieldByName('MAX_DURACAO').AsInteger);
                    cdsTemp.FieldByName('MAX_DURACAO_LOGIN').AsDateTime := SegundosParaDateTime(FieldByName('MAX_DURACAO_LOGIN').AsInteger);
                  end;

                  if (DataSetDescricao <> nil) and (sCampoDescricao <> '') then
                  begin
                    if DataSetDescricao.Locate('ID', FieldByName('ID').Value, []) then
                      cdsTemp.FieldByName(sCampoDescricao).Value := DataSetDescricao.FieldByName('NOME').Value;
                  end;
                end;

                cdsTemp.Post;
                Next;
              end;
              cdsTemp.First;
            finally
              Filter := '';
            end;
          end;
        end;

        with cdsEstatisticas do
        begin
          Filter := 'AGRUPADOR=' + IntToStr(AGRUPADOR_TOTAIS);
          try

            cdsUnidade.Append;
            cdsUnidade.FieldByName('UNIDADE').AsInteger := LIdUnidade;
            cdsUnidade.FieldByName('TMP').AsDateTime := SegundosParaDateTime(FieldByName('TMP').AsInteger);
            cdsUnidade.FieldByName('Qtd').AsInteger := FieldByName('QtdP').AsInteger;

            if vgParametrosModulo.ReportarTemposMaximos then
            begin
              cdsUnidade.FieldByName('MAX_DURACAO').AsDateTime := SegundosParaDateTime(FieldByName('MAX_DURACAO').AsInteger);
              cdsUnidade.FieldByName('MAX_DURACAO_LOGIN').AsDateTime := SegundosParaDateTime(FieldByName('MAX_DURACAO_LOGIN').AsInteger);
            end;

            cdsUnidade.Post;

            {$REGION 'Calcula TMP_Total e Qtde TMP'}
              if iTMPTotal > 0 then
                iTMPTotal := Round(
                  ( (iQtdPTotal * iTMPTotal) +
                    (FieldByName('QtdP').AsInteger * FieldByName('TMP').AsInteger)
                  ) /
                  (iQtdPTotal + FieldByName('QtdP').AsInteger)
                )
              else
                iTMPTotal := FieldByName('TMP').AsInteger;

              iQtdPTotal := iQtdPTotal + FieldByName('QtdP').AsInteger;
            {$ENDREGION}

            {$REGION 'Calcula TML_Total e Qtde TML'}
              if iTMLTotal > 0 then
                iTMLTotal := Round(
                  ( (iQtdLTotal * iTMLTotal) +
                    (FieldByName('QtdL').AsInteger * FieldByName('TML').AsInteger)
                  ) /
                  (iQtdLTotal + FieldByName('QtdL').AsInteger)
                )
              else
                iTMLTotal := FieldByName('TML').AsInteger;

              iQtdLTotal := iQtdLTotal + FieldByName('QtdL').AsInteger;
            {$ENDREGION}
          finally
            Filter := '';
          end;

        end;

        TfrmSicsSplash.ShowStatus('Finalizando...');

      finally
        cdsEstatisticas.Close;
      end;
    finally
      FreeAndNil(qryEstatisticasTemp);
      dspEstatisticas.DataSet := qryEstatisticasSLA;
    end;

    LfrmPesquisaRelatorioPausas.cdsUnidades.Next;
  end;

  Self.QtdPausasLabel.Text := IntToStr(iQtdPTotal);
  Self.TMPLabel      .Text := MyFormatDateTime('[h]:nn:ss', SegundosParaDateTime(iTMPTotal));

  Self.QtdLoginsLabel.Text := IntToStr(iQtdLTotal);
  Self.TMLLabel      .Text := MyFormatDateTime('[h]:nn:ss', SegundosParaDateTime(iTMLTotal));

  Self.QtdChartTypeComboChange(Self);
  AtualizarColunasGrid;
end;

procedure TfrmGraphicsPausas.CalcularEstatisticasSla;

  function GetDcrFromLkp(Id: Variant; DataSet: TDataSet): string;
  begin
    Result := '';
    if DataSet <> nil then
    begin
      if not DataSet.Active then
        DataSet.Open;
      if DataSet.Locate('ID', Id, []) then
        Result := DataSet.FieldByName('NOME').AsString;
    end;
  end;

  function GetDescricao(Agrupador: Integer; Value: Variant): string;
  begin
    case Agrupador of
      AGRUPADOR_MES:
        Result := String(MesStrArray[Integer(Value)]);
      AGRUPADOR_DIA:
        Result := Value;
      AGRUPADOR_SEMANA:
        Result := String(DiaSmStrArray[Integer(Value)]);
      AGRUPADOR_HORA:
        Result := Value;
      AGRUPADOR_ATENDENTE:
        Result := GetDcrFromLkp(Value, cdsLkpAtendentes);
      AGRUPADOR_GRUPO_ATENDENTE:
        Result := GetDcrFromLkp(Value, cdsLkpGruposAtendentes);
      AGRUPADOR_PA:
        Result := GetDcrFromLkp(Value, cdsLkpPAS);
      AGRUPADOR_GRUPO_PA:
        Result := GetDcrFromLkp(Value, cdsLkpGruposPAS);
      AGRUPADOR_MP:
        Result := GetDcrFromLkp(Value, cdsLkpMotivosPausa);
    else
      Result := '';
    end;
  end;

  function Dividir(A, B: Double): Double;
  begin
    if B = 0 then
      Result := 0
    else
      Result := A / B;

  end;

var
  sInTags, sWhere, sDescricao, sCondVerde, sCondAmarelo,
  sCondVermelho, sCondCinza, sNotCondCinza, sCondCinzaBase, sAux: string;
  iAgrupador, iRecNo,iAmarelo, iVermelho: Integer;
  CdsTemp: TClientDataSet;
  qryEstatisticasTemp: TFDQuery;
  LIdUnidade{, iEspAtd}: Integer;
  dblNovoPerc: Double;
  {sEspAtd, }sCor, sCampoQtde, sCampoPerc, sCampoQtdeTotal, sCampoQtdeCinza,NomeUnidade: string;
  iCor: Integer;
  LfrmPesquisaRelatorioPausas: TfrmPesquisaRelatorioPausas;
begin
  LfrmPesquisaRelatorioPausas := (Owner as TfrmPesquisaRelatorioPausas);
  qryEstatisticasSla.Sql.Text := FSqlEstatisticasSla;
  qryEstatisticasSla.Sql.Add ('where E.ID_UNIDADE = :ID_UNIDADE AND                                                   ');
  LfrmPesquisaRelatorioPausas.MontarWhere(qryEstatisticasSla, sInTags, True);
  sWhere := Copy(qryEstatisticasSla.Sql.Text, Length(FSqlEstatisticasSla), Length(qryEstatisticasSla.Sql.Text) - Length(FSqlEstatisticasSla));

  //LM
  //Adcionado pois pois adcionava o numero 2 na frente //verificar
  Delete(sWhere,1,1);

  qryEstatisticasSla.Sql.Text := StringReplace(FSqlEstatisticasSla, '/* WHERE */', sWhere, [rfReplaceAll, rfIgnoreCase]);

    sAux := 'PAUSAS';
    iAmarelo  := FParamsSla.Amarelo;
    iVermelho := FParamsSla.Vermelho;

    case LfrmPesquisaRelatorioPausas.vlQueryParams.DuracaoPausa.TipoDeDuracao of
      tdMenor      : sCondCinzaBase := 'E.DURACAO_SEGUNDOS < ' + IntToStr(SecondsBetween(0, LfrmPesquisaRelatorioPausas.vlQueryParams.DuracaoPausa.Tempo1));
      tdMaiorIgual : sCondCinzaBase := 'E.DURACAO_SEGUNDOS >= ' + IntToStr(SecondsBetween(0, LfrmPesquisaRelatorioPausas.vlQueryParams.DuracaoPausa.Tempo1));
      tdEntre      : sCondCinzaBase := 'E.DURACAO_SEGUNDOS BETWEEN ' + IntToStr(SecondsBetween(0, LfrmPesquisaRelatorioPausas.vlQueryParams.DuracaoPausa.Tempo1)) +
                                       ' AND ' + IntToStr(SecondsBetween(0, LfrmPesquisaRelatorioPausas.vlQueryParams.DuracaoPausa.Tempo2));
    else
      sCondCinzaBase := '';
    end;

    if sCondCinzaBase <> '' then
    begin
      sCondCinza := ' NOT ' + sCondCinzaBase; //RAP RETIREI O "AND"
      sNotCondCinza := ' AND ' + sCondCinzaBase; //RAP RETIREI O "AND"
    end
    else
    begin
      sCondCinza := ' 1 = 2'; // p/ forcar sempre ser FALSE e nao calcular o CINZA //RAP RETIREI O "AND"
      sNotCondCinza := '';
    end;
    sCondVerde    := ' E.DURACAO_SEGUNDOS < ' + IntToStr(iAmarelo) + sNotCondCinza; //RAP RETIREI O "AND"
    sCondAmarelo  := ' E.DURACAO_SEGUNDOS BETWEEN ' + IntToStr(iAmarelo) + ' AND ' + IntToStr(iVermelho -1) + sNotCondCinza; //RAP RETIREI O "AND"
    sCondVermelho := ' E.DURACAO_SEGUNDOS >= ' + IntToStr(iVermelho) + sNotCondCinza; //RAP RETIREI O "AND"
    qryEstatisticasSla.Sql.Text := StringReplace(qryEstatisticasSla.Sql.Text, '/* CONDICAO_' + sAux + '_VERDE */', sCondVerde, [rfReplaceAll, rfIgnoreCase]);
    qryEstatisticasSla.Sql.Text := StringReplace(qryEstatisticasSla.Sql.Text, '/* CONDICAO_' + sAux + '_AMARELO */', sCondAmarelo, [rfReplaceAll, rfIgnoreCase]);
    qryEstatisticasSla.Sql.Text := StringReplace(qryEstatisticasSla.Sql.Text, '/* CONDICAO_' + sAux + '_VERMELHO */', sCondVermelho, [rfReplaceAll, rfIgnoreCase]);
    qryEstatisticasSla.Sql.Text := StringReplace(qryEstatisticasSla.Sql.Text, '/* CONDICAO_' + sAux + '_CINZA */', sCondCinza, [rfReplaceAll, rfIgnoreCase]);


  Self.cdsMesSla                   .Close;
  Self.cdsMesSla         .FieldDefs.Clear;
  Self.cdsHoraSla                  .Close;
  Self.cdsHoraSla        .FieldDefs.Clear;
  Self.cdsDiaSla                   .Close;
  Self.cdsDiaSla         .FieldDefs.Clear;
  Self.cdsDiaSmSla                 .Close;
  Self.cdsDiaSmSla       .FieldDefs.Clear;
  Self.cdsAtendSla                 .Close;
  Self.cdsAtendSla       .FieldDefs.Clear;
  Self.cdsPASla                    .Close;
  Self.cdsPASla          .FieldDefs.Clear;
  Self.cdsGrAtendSla               .Close;
  Self.cdsGrAtendSla     .FieldDefs.Clear;
  Self.cdsGrPASla                  .Close;
  Self.cdsGrPASla        .FieldDefs.Clear;
  Self.cdsUnidadeSla               .Close;
  Self.cdsUnidadeSla     .FieldDefs.Clear;
  Self.cdsMotivoPausaSla           .Close;
  Self.cdsMotivoPausaSla .FieldDefs.Clear;

  Self.cdsMesSla         .CreateDataSet;
  Self.cdsHoraSla        .CreateDataSet;
  Self.cdsDiaSla         .CreateDataSet;
  Self.cdsDiaSmSla       .CreateDataSet;
  Self.cdsAtendSla       .CreateDataSet;
  Self.cdsPASla          .CreateDataSet;
  Self.cdsGrAtendSla     .CreateDataSet;
  Self.cdsGrPASla        .CreateDataSet;
  Self.cdsUnidadeSla     .CreateDataSet;
  Self.cdsMotivoPausaSla .CreateDataSet;

  LfrmPesquisaRelatorioPausas.cdsUnidades.First;
  while not LfrmPesquisaRelatorioPausas.cdsUnidades.Eof do
  begin

    if not LfrmPesquisaRelatorioPausas.cdsUnidades.FieldByName('SELECIONADO').AsBoolean then
    begin
      LfrmPesquisaRelatorioPausas.cdsUnidades.Next;
      Continue;
    end;

    LIdUnidade := LfrmPesquisaRelatorioPausas.cdsUnidades.FieldByName('ID').AsInteger;
    NomeUnidade := LfrmPesquisaRelatorioPausas.cdsUnidades.FieldByName('NOME').AsString;
    PrepararLkpsUnidades;

    // devido a um bug na dbexpress, temos que criar uma nova sqlquery quando muda
    // a conexao, pois o clientedataset nao consegue "enxergar" as mudancas
    qryEstatisticasTemp := TFDQuery.Create(Self);
    try
      qryEstatisticasTemp.Sql.Text := qryEstatisticasSLA.Sql.Text;
      qryEstatisticasTemp.Params.Assign(qryEstatisticasSLA.Params);
      qryEstatisticasTemp.Connection := DMClient(LIdUnidade, not CRIAR_SE_NAO_EXISTIR).ConnRelatorio;
      dspEstatisticasSLA.DataSet := qryEstatisticasTemp;

       //ClipBoard.AsText := qryEstatisticasTemp.Sql.Text;


      {$IFDEF DEBUG}
      //para conseguir pegar a SQL "pós processamento das macros" é necessário
      //chamar o método Prepare
      qryEstatisticasSla.Prepare;
      ClipBoard.AsText := qryEstatisticasSla.Text;
      {$ENDIF}


      cdsEstatisticasSla.Open;
      try
        cdsEstatisticasSla.Filtered := True;

        for iAgrupador := AGRUPADOR_MES to AGRUPADOR_MP do
        begin
          case iAgrupador of
            AGRUPADOR_MES:
            begin
              CdsTemp := cdsMesSla;
              sDescricao := 'Mês';
            end;
            AGRUPADOR_DIA:
            begin
              CdsTemp := cdsDiaSla;
              sDescricao := 'Dia';
            end;
            AGRUPADOR_SEMANA:
            begin
              CdsTemp := cdsDiaSmSla;
              sDescricao := 'Semana';
            end;
            AGRUPADOR_HORA:
            begin
              CdsTemp := cdsHoraSla;
              sDescricao := 'Hora';
            end;
            AGRUPADOR_ATENDENTE:
            begin
              CdsTemp := cdsAtendSla;
              sDescricao := 'Atendente';
            end;
            AGRUPADOR_GRUPO_ATENDENTE:
            begin
              CdsTemp := cdsGrAtendSla;
              sDescricao := 'Grupo de Atendente';
            end;
            AGRUPADOR_PA:
            begin
              CdsTemp := cdsPASla;
              sDescricao := 'PA';
            end;
            AGRUPADOR_GRUPO_PA:
            begin
              CdsTemp := cdsGrPASla;
              sDescricao := 'Grupo de PA';
            end;
            AGRUPADOR_MP:
            begin
              CdsTemp := cdsMotivoPausaSla;
              sDescricao := 'Motivo de Pausa';
            end;
            else
            begin
              CdsTemp := nil;
              sDescricao := '';
            end;
          end;
          if LfrmPesquisaRelatorioPausas.vlRepVars.QtdeUnidadesSelecionadas > 1 then
            CdsTemp.FieldByName('NomeUnidade').Visible := true
          else
            CdsTemp.FieldByName('NomeUnidade').Visible := false;
          TfrmSicsSplash.ShowStatus('Gravando dados -  por ' + sDescricao + '...');
          with cdsEstatisticasSla do
          begin
            iRecNo := 0;
            Filter := 'AGRUPADOR=' + IntToStr(iAgrupador);
            try
              First;
              while not Eof do
              begin
                Inc(iRecNo);
                if cdsTemp.Locate('ID', FieldByName('ID').Value, []) then
                 begin
                  cdsTemp.Edit;

                  for iCor := 1 to 4 do
                  begin
                    case iCor of
                      1: sCor := 'VERDE';
                      2: sCor := 'AMARELO';
                      3: sCor := 'VERMELHO';
                      4: sCor := 'CINZA';
                    end;

                    sCampoQtde := 'PAUSAS_QTDE_' + sCor;
                    sCampoPerc := 'PAUSAS_PERC_' + sCor;
                    sCampoQtdeTotal := 'PAUSAS_QTDE_TOTAL';
                    sCampoQtdeCinza := 'PAUSAS_QTDE_CINZA';

                    // se for cor cinza
                    if iCor = 4 then
                      dblNovoPerc :=
                        Dividir( (cdsTemp.FieldByName(sCampoQtde).AsInteger + FieldByName(sCampoQtde).AsInteger),
                                  (cdsTemp.FieldByName(sCampoQtdeTotal).AsInteger + FieldByName(sCampoQtdeTotal).AsInteger)
                               ) * 100
                    else
                      dblNovoPerc :=
                        Dividir( (cdsTemp.FieldByName(sCampoQtde).AsInteger + FieldByName(sCampoQtde).AsInteger),
                                  (cdsTemp.FieldByName(sCampoQtdeTotal).AsInteger - cdsTemp.FieldByName(sCampoQtdeCinza).AsInteger + FieldByName(sCampoQtdeTotal).AsInteger - FieldByName(sCampoQtdeCinza).AsInteger)
                               ) * 100;

                    cdsTemp.FieldByName(sCampoPerc).AsFloat := dblNovoPerc;
                  end;
                end
                else
                begin
                  cdsTemp.Append;
                  cdsTemp.FieldByName('ID').Value                   := FieldByName('ID').Value;
                  cdsTemp.FieldByName('PAUSAS_PERC_VERDE').AsFloat     := Dividir(FieldByName('PAUSAS_QTDE_VERDE').AsInteger, FieldByName('PAUSAS_QTDE_TOTAL').AsInteger - FieldByName('PAUSAS_QTDE_CINZA').AsInteger) * 100;
                  cdsTemp.FieldByName('PAUSAS_PERC_AMARELO').AsFloat   := Dividir(FieldByName('PAUSAS_QTDE_AMARELO').AsInteger, FieldByName('PAUSAS_QTDE_TOTAL').AsInteger - FieldByName('PAUSAS_QTDE_CINZA').AsInteger) * 100;
                  cdsTemp.FieldByName('PAUSAS_PERC_VERMELHO').AsFloat  := Dividir(FieldByName('PAUSAS_QTDE_VERMELHO').AsInteger, FieldByName('PAUSAS_QTDE_TOTAL').AsInteger - FieldByName('PAUSAS_QTDE_CINZA').AsInteger) * 100;
                  cdsTemp.FieldByName('PAUSAS_PERC_CINZA').AsFloat     := Dividir(FieldByName('PAUSAS_QTDE_CINZA').AsInteger, FieldByName('PAUSAS_QTDE_TOTAL').AsInteger) * 100;
                  cdsTemp.FieldByName('RECNO').AsInteger            := iRecNo;
                  cdsTemp.FieldByName('DESCRICAO').AsString         := GetDescricao(iAgrupador, FieldByName('ID').Value);
                  cdsTemp.FieldByName('IdUnidade').AsInteger  := LIdUnidade;
                  CdsTemp.FieldByName('NomeUnidade').AsString := NomeUnidade;
                end;

                // nao precisaria destas qtdes abaixo, mas é bom ja guardar caso precise no futuro
                cdsTemp.FieldByName('PAUSAS_QTDE_VERDE').AsInteger    := cdsTemp.FieldByName('PAUSAS_QTDE_VERDE').AsInteger + FieldByName('PAUSAS_QTDE_VERDE').AsInteger;
                cdsTemp.FieldByName('PAUSAS_QTDE_AMARELO').AsInteger  := cdsTemp.FieldByName('PAUSAS_QTDE_AMARELO').AsInteger + FieldByName('PAUSAS_QTDE_AMARELO').AsInteger;
                cdsTemp.FieldByName('PAUSAS_QTDE_VERMELHO').AsInteger := cdsTemp.FieldByName('PAUSAS_QTDE_VERMELHO').AsInteger + FieldByName('PAUSAS_QTDE_VERMELHO').AsInteger;
                cdsTemp.FieldByName('PAUSAS_QTDE_CINZA').AsInteger    := cdsTemp.FieldByName('PAUSAS_QTDE_CINZA').AsInteger + FieldByName('PAUSAS_QTDE_CINZA').AsInteger;
                cdsTemp.FieldByName('PAUSAS_QTDE_TOTAL').AsInteger    := cdsTemp.FieldByName('PAUSAS_QTDE_TOTAL').AsInteger + FieldByName('PAUSAS_QTDE_TOTAL').AsInteger;

                cdsTemp.Post;

                Next;
              end;

              if cdsTemp <> nil then
              begin
                cdsTemp.FieldByName('PAUSAS_PERC_VERDE').Visible     := true;
                cdsTemp.FieldByName('PAUSAS_PERC_AMARELO').Visible   := true;
                cdsTemp.FieldByName('PAUSAS_PERC_VERMELHO').Visible  := true;
                cdsTemp.FieldByName('PAUSAS_PERC_CINZA').Visible     := true;

                cdsTemp.First;
              end;

            finally
              Filter := '';
            end;
          end;
        end;


        // totais
        with cdsEstatisticasSla do
        begin
          Filter := 'AGRUPADOR=' + IntToStr(AGRUPADOR_TOTAIS);
          try

            cdsUnidadeSla.Append;
            cdsUnidadeSla.FieldByName('ID').AsInteger := LIdUnidade;
            cdsUnidadeSla.FieldByName('DESCRICAO').AsString := dmUnidades.Nome[LIdUnidade];
            cdsUnidadeSla.FieldByName('PAUSAS_PERC_VERDE').AsFloat     := Dividir(FieldByName('PAUSAS_QTDE_VERDE').AsInteger, FieldByName('PAUSAS_QTDE_TOTAL').AsInteger - FieldByName('PAUSAS_QTDE_CINZA').AsInteger) * 100;
            cdsUnidadeSla.FieldByName('PAUSAS_PERC_AMARELO').AsFloat   := Dividir(FieldByName('PAUSAS_QTDE_AMARELO').AsInteger, FieldByName('PAUSAS_QTDE_TOTAL').AsInteger - FieldByName('PAUSAS_QTDE_CINZA').AsInteger) * 100;
            cdsUnidadeSla.FieldByName('PAUSAS_PERC_VERMELHO').AsFloat  := Dividir(FieldByName('PAUSAS_QTDE_VERMELHO').AsInteger, FieldByName('PAUSAS_QTDE_TOTAL').AsInteger - FieldByName('PAUSAS_QTDE_CINZA').AsInteger) * 100;
            cdsUnidadeSla.FieldByName('PAUSAS_PERC_CINZA').AsFloat     := Dividir(FieldByName('PAUSAS_QTDE_CINZA').AsInteger, FieldByName('PAUSAS_QTDE_TOTAL').AsInteger) * 100;
            cdsUnidadeSla.FieldByName('RECNO').AsInteger            := LIdUnidade + 1;
            // nao precisaria destas qtdes abaixo, mas é bom ja guardar caso precise no futuro
            cdsUnidadeSla.FieldByName('PAUSAS_QTDE_VERDE').Value := FieldByName('PAUSAS_QTDE_VERDE').Value;
            cdsUnidadeSla.FieldByName('PAUSAS_QTDE_AMARELO').Value := FieldByName('PAUSAS_QTDE_AMARELO').Value;
            cdsUnidadeSla.FieldByName('PAUSAS_QTDE_VERMELHO').Value := FieldByName('PAUSAS_QTDE_VERMELHO').Value;
            cdsUnidadeSla.FieldByName('PAUSAS_QTDE_CINZA').Value := FieldByName('PAUSAS_QTDE_CINZA').Value;
            cdsUnidadeSla.FieldByName('PAUSAS_QTDE_TOTAL').Value := FieldByName('PAUSAS_QTDE_TOTAL').Value;
            cdsUnidadeSla.Post;

          finally
            Filter := '';
          end;

        end;

        TfrmSicsSplash.ShowStatus('Finalizando...');
      finally
        cdsEstatisticasSla.Close;
      end;
    finally
      FreeAndNil(qryEstatisticasTemp);
      dspEstatisticas.DataSet := qryEstatisticasSLA;
    end;

    LfrmPesquisaRelatorioPausas.cdsUnidades.Next;
  end;
  AtualizarColunasGrid;
end;

procedure TfrmGraphicsPausas.chkSlaCinzaChange(Sender: TObject);
begin
  inherited;
   dbChartSla.Series[3].Active := chkSlaCinza.IsChecked;
end;


procedure TfrmGraphicsPausas.DefineCorChart;
begin
  {BarSeries13.SeriesColor := TAlphaColor(RGBtoBGR($0080FF) or $FF000000);
  LineSeries6.SeriesColor := claBlue;
  Series1.SeriesColor := claBlue;

  PieSeries1.SeriesColor := claRed; }

  BarSeries31.SeriesColor := TAlphaColor(RGBtoBGR($FFAA55) or $FF000000);
  BarSeries32.SeriesColor := TAlphaColor(RGBtoBGR($FFAA55) or $FF000000);
  BarSeries33.SeriesColor := TAlphaColor(RGBtoBGR($FFAA55) or $FF000000);
  Series7.SeriesColor := claSilver;
end;

destructor TfrmGraphicsPausas.Destroy;
begin
  cdsMes         .Close;
  cdsDia         .Close;
  cdsDiaSm       .Close;
  cdsHora        .Close;
  cdsAtend       .Close;
  cdsPA          .Close;
  cdsGrAtend     .Close;
  cdsGrPA        .Close;
  cdsUnidade     .Close;
  cdsMotivoPausa .Close;
  inherited;
end;

procedure TfrmGraphicsPausas.PageControlGridsChange(Sender: TObject);
var
  ds: TClientDataSet;
  iSerie: Integer;

  procedure ConfiguraChart(const aDS: TClientDataSet; const aFieldSource: String; aFieldLabel: String = '';
    const aLabelsAngle: Integer= 0);
  begin
    ds := aDS;
     if (aFieldLabel = '') then
       aFieldLabel := aFieldSource;

     ConfiguraDBChart(dbChartTmpTml, aDS, aFieldSource, aFieldLabel, aLabelsAngle);

     dbPieChartTmpTml.Series[0].XLabelsSource := '';
     dbPieChartTmpTml.Series[0].DataSource := aDS;
     dbPieChartTmpTml.Series[0].XLabelsSource := ds.FieldByName(aFieldLabel).FieldName;
  end;
begin
  if not Self.Visible then
    Exit;
  if FGraficoSla then
  begin
    pnlGraficosTmpTml.Visible := False;
    pnlChartSla.Visible := True;
    case PageControlGrids.TabIndex of
      0 :  ds := cdsMesSla;
      1 :  ds := cdsDiaSla;
      2 :  ds := cdsDiaSmSla;
      3 :  ds := cdsHoraSla;
      4 :  ds := cdsMotivoPausaSla;
      5 :  ds := cdsAtendSla;
      6 :  ds := cdsGrAtendSla;
      7 :  ds := cdsPASla;
      8 :  ds := cdsGrPASla;
      9 :  ds := cdsUnidadeSla;
    else
       ds :=  nil;
    end;
     for iSerie := 0 to dbChartSla.SeriesList.Count - 1 do
       dbChartSla.Series[iSerie].DataSource := ds;
    if PageControlGrids.TabIndex > 3 then
       dbChartSla.BottomAxis.LabelsAngle := 90
    else
       dbChartSla.BottomAxis.LabelsAngle := 0;
  end else begin
    pnlChartSla.Visible := True;
    pnlChartSla.Visible := False;
    case PageControlGrids.TabIndex of
      0 : begin
            ConfiguraChart(cdsMes, 'Mes', 'MesStr');
          end;
      1 : begin
            ConfiguraChart(cdsDia, 'Dia');
          end;
      2 : begin
            ConfiguraChart(cdsDiaSm, 'DiaSm', 'DiaSMStr');
          end;
      3 : begin
            ConfiguraChart(cdsHora, 'Hora');
          end;
      4 : begin
            ConfiguraChart(cdsMotivoPausa, 'MPRecNo', 'MPNome', 90);
          end;
      5 : begin
            ConfiguraChart(cdsAtend, 'AtdRecNo', 'AtdNome', 90);
          end;
      6 : begin
            ConfiguraChart(cdsGrAtend, 'GrAtendRecNo', 'GrAtendNome', 90);
          end;
      7 : begin
            ConfiguraChart(cdsPA, 'PARecNo', 'PANome', 90);
          end;
      8 : begin
            ConfiguraChart(cdsGrPA, 'GrPARecNo', 'GrPANome', 90);
          end;
      9 : begin
            ConfiguraChart(cdsUnidade, 'UnidadeRecNo', 'UnidadeNome', 90);
          end;
    end; // case
  end;


  TMPCheckBox.IsChecked := (PageControlGrids.ActiveTab <> tbsAtendentes) and (PageControlGrids.ActiveTab <> tbsPA);
  AtualizarColunasGrid;
end;

procedure TfrmGraphicsPausas.PrepararLkpsUnidades;
var
  LfrmPesquisaRelatorioPausas: TfrmPesquisaRelatorioPausas;

  procedure CopiarNestedDataSet(const AFieldName: string; ADataSetLkp: TClientDataSet);
  var
    LCDSCopia: TClientDataSet;
  begin
    LCDSCopia := TClientDataSet.Create(nil);
    try
      LCDSCopia.DataSetField := TDataSetField(LfrmPesquisaRelatorioPausas.cdsUnidades.FieldByName(AFieldName));

      if ADataSetLkp.Active then
        ADataSetLkp.EmptyDataSet
      else
        ADataSetLkp.CreateDataSet;

      LCDSCopia.First;
      while not LCDSCopia.eof do
      begin
        ADataSetLkp.Append;
        ADataSetLkp.FieldByName('ID'  ).Value := LCDSCopia.FieldByName('ID'  ).Value;
        ADataSetLkp.FieldByName('NOME').Value := LCDSCopia.FieldByName('NOME').Value;
        ADataSetLkp.Post;
        LCDSCopia.Next;
      end;
    finally
      FreeAndNil(LCDSCopia);
    end;
  end;

begin
  LfrmPesquisaRelatorioPausas := (Owner as TfrmPesquisaRelatorioPausas);
   CopiarNestedDataSet('ATENDENTES'       , cdsLkpAtendentes       );
   CopiarNestedDataSet('PAS'              , cdsLkpPAS              );
   CopiarNestedDataSet('GRUPOS_ATENDENTES', cdsLkpGruposAtendentes );
   CopiarNestedDataSet('GRUPOS_PAS'       , cdsLkpGruposPAS        );
   CopiarNestedDataSet('MOTIVOS_PAUSA'    , cdsLkpMotivosPausa     );
end;

procedure TfrmGraphicsPausas.cdsMesAfterOpen(DataSet: TDataSet);
begin
  with DataSet do
  begin
    FieldByName('MAX_DURACAO').Visible := vgParametrosModulo.ReportarTemposMaximos;
    FieldByName('MAX_DURACAO_LOGIN').Visible := vgParametrosModulo.ReportarTemposMaximos;
  end;
end;

procedure TfrmGraphicsPausas.cdsTagTagNomeGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := 'Não classificado'
  else
    Text := Sender.AsString;
end;

procedure TfrmGraphicsPausas.StringField20GetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if Sender.AsString = '' then
    Text := 'Não classificado'
  else
    Text := Sender.AsString;
end;

procedure TfrmGraphicsPausas.cdsFilaEsperaFilaEsperaNomeGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := '(nenhuma)'
  else
    Text := Sender.AsString;
end;

procedure TfrmGraphicsPausas.StringField22GetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if Sender.AsString = '' then
    Text := '(nenhuma)'
  else
    Text := Sender.AsString;
end;

procedure TfrmGraphicsPausas.PreencheNDOnField (Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if Sender.AsString = '' then
    Text := '(nenhum)'
  else
    Text := Sender.AsString;
end;

end.


