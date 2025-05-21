unit ufrmGraphicsPP;
//Renomeado unit sics_90;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  {$IFNDEF IS_MOBILE}
  ExcelXP,
  Winapi.Windows,
  VCL.OleServer,
  {$ENDIF}
  ufrmPesquisaRelatorioBase, untMainForm, untCommonDMClient, FMX.Grid,
  FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.ExtCtrls, FMX.Types, FMX.Layouts, FMX.ListView.Types, FMX.ListView,
  FMX.ListBox, System.DateUtils, Fmx.Bind.DBEngExt, Fmx.Bind.Grid,
  System.Bindings.Outputs, Fmx.Bind.Editors, FMX.Objects, FMX.Edit,
  FMX.TabControl, FMXTee.Chart, FMXTee.DBChart,  FMXTee.Series, System.UIConsts,
  System.Generics.Defaults, System.Generics.Collections, System.UITypes,
  System.Types, System.SysUtils, System.Classes, System.Variants, Data.DB,
  Datasnap.DBClient, System.Rtti, Data.Bind.EngExt, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope, ufrmGraphicsBase, MyAspFuncoesUteis,
  Math,IniFiles
  {$IFDEF SuportaQuickRep}
  , repGraphBase,
  {$ENDIF SuportaQuickRep}
  Data.FMTBcd, Datasnap.Provider, System.Actions, FMX.ActnList, FMX.Menus,
  FMXTee.Engine, FMXTee.Procs, untCommonFormBase, FMX.Controls.Presentation,
  System.ImageList, FMX.ImgList, FMX.Effects, FMX.Grid.Style, FMX.ScrollBox,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, 
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, Vcl.Clipbrd,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.DBX.Migrate, uDataSetHelper;

type
  TfrmGraphicsPP = class(TfrmGraphicsBase)
    QtdCheckBox: TCheckBox;
    TMPPCheckBox: TCheckBox;
    QtdChartTypeCombo: TComboBox;
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
    BarSeries13: TBarSeries;
    LineSeries6: TLineSeries;
    Series1: TBarSeries;
    cdsMesTestesTME: TDateTimeField;
    cdsMesTestesTMA: TDateTimeField;
    dspEstatisticas: TDataSetProvider;
    cdsEstatisticas: TClientDataSet;
    cdsPASla: TClientDataSet;
    cdsMesSla: TClientDataSet;
    cdsHoraSla: TClientDataSet;
    cdsAtendSla: TClientDataSet;
    cdsGrPASla: TClientDataSet;
    cdsGrAtendSla: TClientDataSet;
    cdsDiaSmSla: TClientDataSet;
    cdsPPSla: TClientDataSet;
    cdsGrPAFimSla: TClientDataSet;
    cdsPAFimSla: TClientDataSet;
    cdsGrAtendFimSla: TClientDataSet;
    cdsAtendFimSla: TClientDataSet;
    cdsFaixaDeSenhaSla: TClientDataSet;
    cdsUnidadeSla: TClientDataSet;
    cdsEstatisticasSla: TClientDataSet;
    cdsDiaSla: TClientDataSet;
    cdsTagSla: TClientDataSet;
    cdsDiaSmSlaID: TIntegerField;
    cdsDiaSmSlaPP_PERC_VERDE: TFloatField;
    cdsDiaSmSlaPP_PERC_AMARELO: TFloatField;
    cdsDiaSmSlaPP_PERC_VERMELHO: TFloatField;
    cdsDiaSmSlaRECNO: TIntegerField;
    cdsDiaSmSlaDESCRICAO: TStringField;
    cdsDiaSmSlaTIPO_ATD_PP_DCR: TStringField;
    cdsDiaSmSlaPP_PERC_CINZA: TFloatField;
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
    IntegerField21: TIntegerField;
    FloatField73: TFloatField;
    FloatField74: TFloatField;
    FloatField75: TFloatField;
    FloatField76: TFloatField;
    IntegerField22: TIntegerField;
    StringField20: TStringField;
    StringField21: TStringField;
    dtsTagSla: TDataSource;
    chkSlaCinza: TCheckBox;
    Label13: TLabel;
    Label18: TLabel;
    lblParamsSLAPPVermelho: TLabel;
    lblParamsSLAPPAmarelo: TLabel;
    cdsMesSlaPP_QTDE_VERDE: TIntegerField;
    cdsMesSlaPP_QTDE_AMARELO: TIntegerField;
    cdsMesSlaPP_QTDE_VERMELHO: TIntegerField;
    cdsMesSlaPP_QTDE_CINZA: TIntegerField;
    cdsDiaSlaPP_QTDE_VERDE: TIntegerField;
    cdsDiaSlaPP_QTDE_AMARELO: TIntegerField;
    cdsDiaSlaPP_QTDE_VERMELHO: TIntegerField;
    cdsDiaSlaPP_QTDE_CINZA: TIntegerField;
    cdsDiaSmSlaPP_QTDE_VERDE: TIntegerField;
    cdsDiaSmSlaPP_QTDE_AMARELO: TIntegerField;
    cdsDiaSmSlaPP_QTDE_VERMELHO: TIntegerField;
    cdsDiaSmSlaPP_QTDE_CINZA: TIntegerField;
    cdsAtendSlaPP_QTDE_VERDE: TIntegerField;
    cdsAtendSlaPP_QTDE_AMARELO: TIntegerField;
    cdsAtendSlaPP_QTDE_VERMELHO: TIntegerField;
    cdsAtendSlaPP_QTDE_CINZA: TIntegerField;
    cdsGrAtendSlaPP_QTDE_VERDE: TIntegerField;
    cdsGrAtendSlaPP_QTDE_AMARELO: TIntegerField;
    cdsGrAtendSlaPP_QTDE_VERMELHO: TIntegerField;
    cdsGrAtendSlaPP_QTDE_CINZA: TIntegerField;
    cdsGrPASlaPP_QTDE_VERDE: TIntegerField;
    cdsGrPASlaPP_QTDE_AMARELO: TIntegerField;
    cdsGrPASlaPP_QTDE_VERMELHO: TIntegerField;
    cdsGrPASlaPP_QTDE_CINZA: TIntegerField;
    cdsUnidadeSlaPP_QTDE_VERDE: TIntegerField;
    cdsUnidadeSlaPP_QTDE_AMARELO: TIntegerField;
    cdsUnidadeSlaPP_QTDE_VERMELHO: TIntegerField;
    cdsUnidadeSlaPP_QTDE_CINZA: TIntegerField;
    cdsTagSlaPP_QTDE_VERDE: TIntegerField;
    cdsTagSlaPP_QTDE_AMARELO: TIntegerField;
    cdsTagSlaPP_QTDE_VERMELHO: TIntegerField;
    cdsTagSlaPP_QTDE_CINZA: TIntegerField;
    cdsPASlaPP_QTDE_VERDE: TIntegerField;
    cdsPASlaPP_QTDE_AMARELO: TIntegerField;
    cdsPASlaPP_QTDE_VERMELHO: TIntegerField;
    cdsPASlaPP_QTDE_CINZA: TIntegerField;
    cdsHoraSlaPP_QTDE_VERDE: TIntegerField;
    cdsHoraSlaPP_QTDE_AMARELO: TIntegerField;
    cdsHoraSlaPP_QTDE_VERMELHO: TIntegerField;
    cdsHoraSlaPP_QTDE_CINZA: TIntegerField;
    lblParamsSLAPPVerde: TLabel;
    Label16: TLabel;
    Label15: TLabel;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    cdsLkpAtendentes: TClientDataSet;
    cdsLkpGruposAtendentes: TClientDataSet;
    cdsLkpFaixaDeSenhas: TClientDataSet;
    cdsLkpPAS: TClientDataSet;
    cdsLkpGruposPAs: TClientDataSet;
    cdsLkpTags: TClientDataSet;
    cdsMesSlaPP_QTDE_TOTAL: TIntegerField;
    cdsDiaSlaPP_QTDE_TOTAL: TIntegerField;
    cdsDiaSmSlaPP_QTDE_TOTAL: TIntegerField;
    cdsHoraSlaPP_QTDE_TOTAL: TIntegerField;
    cdsAtendSlaPP_QTDE_TOTAL: TIntegerField;
    cdsGrAtendSlaPP_QTDE_TOTAL: TIntegerField;
    cdsPASlaPP_QTDE_TOTAL: TIntegerField;
    cdsGrPASlaPP_QTDE_TOTAL: TIntegerField;
    cdsUnidadeSlaPP_QTDE_TOTAL: TIntegerField;
    cdsTagSlaPP_QTDE_TOTAL: TIntegerField;
    cdsLkpAtendentesID: TIntegerField;
    cdsLkpGruposAtendentesID: TIntegerField;
    cdsLkpGruposAtendentesNOME: TStringField;
    cdsLkpAtendentesNOME: TStringField;
    cdsLkpFaixaDeSenhasID: TIntegerField;
    cdsLkpFaixaDeSenhasNOME: TStringField;
    cdsLkpPASID: TIntegerField;
    cdsLkpPASNOME: TStringField;
    cdsLkpGruposPAsID: TIntegerField;
    cdsLkpGruposPAsNOME: TStringField;
    cdsLkpTagsID: TIntegerField;
    cdsLkpTagsNOME: TStringField;
    lblUnidades: TLabel;
    Label12: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label8: TLabel;
    Label7: TLabel;
    Label6: TLabel;
    Label9: TLabel;
    Label5: TLabel;
    PeriododoRelatorioLabel: TLabel;
    PeriododoDiaLabel: TLabel;
    DuracaoLabel: TLabel;
    SenhasLabel: TLabel;
    AtendentesInicioLabel: TLabel;
    PAsInicioLabel: TLabel;
    AtendentesFimLabel: TLabel;
    PAsFimLabel: TLabel;
    lblUnidadesVal: TLabel;
    dtsFaixaDeSenhaSla: TDataSource;
    IntegerField17: TIntegerField;
    StringField16: TStringField;
    FloatField57: TFloatField;
    FloatField58: TFloatField;
    FloatField59: TFloatField;
    FloatField60: TFloatField;
    IntegerField18: TIntegerField;
    StringField17: TStringField;
    cdsFaixaDeSenhaSlaPP_QTDE_CINZA: TIntegerField;
    cdsFaixaDeSenhaSlaPP_QTDE_VERMELHO: TIntegerField;
    cdsFaixaDeSenhaSlaPP_QTDE_AMARELO: TIntegerField;
    cdsFaixaDeSenhaSlaPP_QTDE_VERDE: TIntegerField;
    cdsFaixaDeSenhaSlaPP_QTDE_TOTAL: TIntegerField;
    cdsMes: TClientDataSet;
    cdsMesMes: TIntegerField;
    cdsMesMesStr: TStringField;
    cdsMesQtdPP: TIntegerField;
    cdsMesTMPP: TDateTimeField;
    cdsMesMaxPP: TDateTimeField;
    MesDS: TDataSource;
    DiaDS: TDataSource;
    cdsDia: TClientDataSet;
    cdsDiaDia: TIntegerField;
    cdsDiaQtdPP: TIntegerField;
    cdsDiaTMPP: TDateTimeField;
    cdsDiaMaxPP: TDateTimeField;
    DiaSmDS: TDataSource;
    cdsDiaSm: TClientDataSet;
    cdsDiaSmDiaSm: TIntegerField;
    cdsDiaSmDiaSmStr: TStringField;
    cdsDiaSmQtdPP: TIntegerField;
    cdsDiaSmTMPP: TDateTimeField;
    cdsDiaSmMaxPP: TDateTimeField;
    cdsHora: TClientDataSet;
    cdsHoraHora: TIntegerField;
    cdsHoraQtdPP: TIntegerField;
    cdsHoraTMPP: TDateTimeField;
    cdsHoraMaxPP: TDateTimeField;
    HoraDS: TDataSource;
    AtendDS: TDataSource;
    cdsAtend: TClientDataSet;
    cdsAtendAtend: TIntegerField;
    cdsAtendAtdRecNo: TIntegerField;
    cdsAtendAtdNome: TStringField;
    cdsAtendQtdPP: TIntegerField;
    cdsAtendTMPP: TDateTimeField;
    cdsAtendMaxPP: TDateTimeField;
    cdsGrAtend: TClientDataSet;
    cdsGrAtendGrAtend: TIntegerField;
    cdsGrAtendGrAtendRecNo: TSmallintField;
    cdsGrAtendGrAtendNome: TStringField;
    cdsGrAtendQtdPP: TIntegerField;
    cdsGrAtendTMPP: TDateTimeField;
    cdsGrAtendMaxPP: TDateTimeField;
    GrAtendDS: TDataSource;
    PADS: TDataSource;
    cdsPA: TClientDataSet;
    cdsPAPA: TIntegerField;
    cdsPAPARecNo: TIntegerField;
    cdsPAPANome: TStringField;
    cdsPAQtdPP: TIntegerField;
    cdsPATMPP: TDateTimeField;
    cdsPAMaxPP: TDateTimeField;
    cdsGrPA: TClientDataSet;
    cdsGrPAGrPA: TIntegerField;
    cdsGrPAGrPARecNo: TSmallintField;
    cdsGrPAGrPANome: TStringField;
    cdsGrPAQtdPP: TIntegerField;
    cdsGrPATMPP: TDateTimeField;
    cdsGrPAMaxPP: TDateTimeField;
    GrPADS: TDataSource;
    FaixaDeSenhaDS: TDataSource;
    cdsFaixaDeSenha: TClientDataSet;
    cdsFaixaDeSenhaFaixaDeSenha: TIntegerField;
    cdsFaixaDeSenhaFaixaDeSenhaRecNo: TIntegerField;
    cdsFaixaDeSenhaFaixaDeSenhaNome: TStringField;
    cdsFaixaDeSenhaQtdPP: TIntegerField;
    cdsFaixaDeSenhaTMPP: TDateTimeField;
    cdsFaixaDeSenhaMaxPP: TDateTimeField;
    cdsUnidade: TClientDataSet;
    cdsUnidadeUnidade: TIntegerField;
    cdsUnidadeUnidadeRecNo: TIntegerField;
    cdsUnidadeUnidadeNome: TStringField;
    cdsUnidadeQtdPP: TIntegerField;
    cdsUnidadeTMPP: TDateTimeField;
    cdsUnidadeMaxPP: TDateTimeField;
    UnidadeDS: TDataSource;
    TagDS: TDataSource;
    cdsTag: TClientDataSet;
    cdsTagTag: TIntegerField;
    cdsTagTagRecNo: TIntegerField;
    cdsTagTagNome: TStringField;
    cdsTagQtdPP: TIntegerField;
    cdsTagTMPP: TDateTimeField;
    cdsTagMaxPP: TDateTimeField;
    cdsAtendFim: TClientDataSet;
    cdsAtendFimAtend: TIntegerField;
    cdsAtendFimAtdRecNo: TIntegerField;
    cdsAtendFimAtdNome: TStringField;
    cdsAtendFimQtdPP: TIntegerField;
    cdsAtendFimTMPP: TDateTimeField;
    cdsAtendFimMaxPP: TDateTimeField;
    AtendFimDS: TDataSource;
    GrAtendFimDS: TDataSource;
    cdsGrAtendFim: TClientDataSet;
    cdsGrAtendFimGrAtend: TIntegerField;
    cdsGrAtendFimGrAtendRecNo: TSmallintField;
    cdsGrAtendFimGrAtendNome: TStringField;
    cdsGrAtendFimQtdPP: TIntegerField;
    cdsGrAtendFimTMPP: TDateTimeField;
    cdsGrAtendFimMaxPP: TDateTimeField;
    cdsPAFim: TClientDataSet;
    cdsPAFimPA: TIntegerField;
    cdsPAFimPARecNo: TIntegerField;
    cdsPAFimPANome: TStringField;
    cdsPAFimQtdPP: TIntegerField;
    cdsPAFimTMPP: TDateTimeField;
    cdsPAFimMaxPP: TDateTimeField;
    PAFimDS: TDataSource;
    GrPAFimDS: TDataSource;
    cdsGrPAFim: TClientDataSet;
    cdsGrPAFimGrPA: TIntegerField;
    cdsGrPAFimGrPARecNo: TSmallintField;
    cdsGrPAFimGrPANome: TStringField;
    cdsGrPAFimQtdPP: TIntegerField;
    cdsGrPAFimTMPP: TDateTimeField;
    cdsGrPAFimMaxPP: TDateTimeField;
    pnlChart: TPanel;
    IntegerField23: TIntegerField;
    StringField22: TStringField;
    FloatField81: TFloatField;
    FloatField82: TFloatField;
    FloatField83: TFloatField;
    FloatField84: TFloatField;
    IntegerField24: TIntegerField;
    StringField23: TStringField;
    cdsAtendFimSlaPP_QTDE_CINZA: TIntegerField;
    cdsAtendFimSlaPP_QTDE_VERMELHO: TIntegerField;
    cdsAtendFimSlaPP_QTDE_AMARELO: TIntegerField;
    cdsAtendFimSlaPP_QTDE_VERDE: TIntegerField;
    cdsAtendFimSlaPP_QTDE_TOTAL: TIntegerField;
    dtsAtendFimSla: TDataSource;
    IntegerField25: TIntegerField;
    StringField24: TStringField;
    FloatField89: TFloatField;
    FloatField90: TFloatField;
    FloatField91: TFloatField;
    FloatField92: TFloatField;
    IntegerField26: TIntegerField;
    StringField25: TStringField;
    cdsGrAtendFimSlaPP_QTDE_CINZA: TIntegerField;
    cdsGrAtendFimSlaPP_QTDE_VERMELHO: TIntegerField;
    cdsGrAtendFimSlaPP_QTDE_AMARELO: TIntegerField;
    cdsGrAtendFimSlaPP_QTDE_VERDE: TIntegerField;
    cdsGrAtendFimSlaPP_QTDE_TOTAL: TIntegerField;
    dtsGrAtendFimSla: TDataSource;
    IntegerField27: TIntegerField;
    StringField26: TStringField;
    FloatField97: TFloatField;
    FloatField98: TFloatField;
    FloatField99: TFloatField;
    FloatField100: TFloatField;
    IntegerField28: TIntegerField;
    StringField27: TStringField;
    cdsPAFimSlaPP_QTDE_CINZA: TIntegerField;
    cdsPAFimSlaPP_QTDE_VERMELHO: TIntegerField;
    cdsPAFimSlaPP_QTDE_AMARELO: TIntegerField;
    cdsPAFimSlaPP_QTDE_VERDE: TIntegerField;
    cdsPAFimSlaPP_QTDE_TOTAL: TIntegerField;
    dtsPAFimSla: TDataSource;
    IntegerField29: TIntegerField;
    StringField28: TStringField;
    FloatField105: TFloatField;
    FloatField106: TFloatField;
    FloatField107: TFloatField;
    FloatField108: TFloatField;
    IntegerField30: TIntegerField;
    StringField29: TStringField;
    cdsGrPAFimSlaPP_QTDE_CINZA: TIntegerField;
    cdsGrPAFimSlaPP_QTDE_VERMELHO: TIntegerField;
    cdsGrPAFimSlaPP_QTDE_AMARELO: TIntegerField;
    cdsGrPAFimSlaPP_QTDE_VERDE: TIntegerField;
    cdsGrPAFimSlaPP_QTDE_TOTAL: TIntegerField;
    dtsGrPAFimSla: TDataSource;
    Label4: TLabel;
    TagsLabel: TLabel;
    Label14: TLabel;
    TiposPPLabel: TLabel;
    cdsPP: TClientDataSet;
    cdsPPPP: TIntegerField;
    cdsPPPPRecNo: TSmallintField;
    cdsPPPPNome: TStringField;
    cdsPPQtdPP: TIntegerField;
    cdsPPTMPP: TDateTimeField;
    cdsPPMaxPP: TDateTimeField;
    PPDS: TDataSource;
    IntegerField33: TIntegerField;
    StringField31: TStringField;
    FloatField5: TFloatField;
    FloatField6: TFloatField;
    FloatField7: TFloatField;
    FloatField8: TFloatField;
    IntegerField34: TIntegerField;
    StringField32: TStringField;
    cdsPPSlaPP_QTDE_CINZA: TIntegerField;
    cdsPPSlaPP_QTDE_VERMELHO: TIntegerField;
    cdsPPSlaPP_QTDE_AMARELO: TIntegerField;
    cdsPPSlaPP_QTDE_VERDE: TIntegerField;
    cdsPPSlaPP_QTDE_TOTAL: TIntegerField;
    dtsPPSla: TDataSource;
    cdsLkpPPs: TClientDataSet;
    cdsLkpPPsId: TIntegerField;
    cdsLkpPPsNome: TStringField;
    PageControlGrids: TTabControl;
    tbsMes: TTabItem;
    MesGrid: TGrid;
    tbsDia: TTabItem;
    DiaGrid: TGrid;
    tbsDiaSM: TTabItem;
    DiaSmGrid: TGrid;
    tbsHora: TTabItem;
    HoraGrid: TGrid;
    tbsPP: TTabItem;
    PPGrid: TGrid;
    tbsAtendentes: TTabItem;
    AtendGrid: TGrid;
    tbsAtendentesFim: TTabItem;
    AtendFimGrid: TGrid;
    GrAtendGrid: TGrid;
    GrAtendFimGrid: TGrid;
    PAGrid: TGrid;
    PAFimGrid: TGrid;
    GrPAGrid: TGrid;
    GrPAFimGrid: TGrid;
    FaixaDeSenhaGrid: TGrid;
    TagGrid: TGrid;
    tbsUnidades: TTabItem;
    UnidadeGrid: TGrid;
    LinkGridToDataSource1: TLinkGridToDataSource;
    LinkGridToDataSource2: TLinkGridToDataSource;
    LinkGridToDataSource3: TLinkGridToDataSource;
    LinkGridToDataSource4: TLinkGridToDataSource;
    LinkGridToDataSource5: TLinkGridToDataSource;
    LinkGridToDataSource6: TLinkGridToDataSource;
    LinkGridToDataSource7: TLinkGridToDataSource;
    LinkGridToDataSource8: TLinkGridToDataSource;
    LinkGridToDataSource9: TLinkGridToDataSource;
    LinkGridToDataSource10: TLinkGridToDataSource;
    LinkGridToDataSource11: TLinkGridToDataSource;
    LinkGridToDataSource12: TLinkGridToDataSource;
    LinkGridToDataSource13: TLinkGridToDataSource;
    LinkGridToDataSource14: TLinkGridToDataSource;
    bnd1: TBindSourceDB;
    bnd2: TBindSourceDB;
    bnd3: TBindSourceDB;
    BindSourceDB1: TBindSourceDB;
    BindSourceDB2: TBindSourceDB;
    BindSourceDB3: TBindSourceDB;
    BindSourceDB4: TBindSourceDB;
    BindSourceDB5: TBindSourceDB;
    BindSourceDB6: TBindSourceDB;
    BindSourceDB7: TBindSourceDB;
    BindSourceDB8: TBindSourceDB;
    BindSourceDB9: TBindSourceDB;
    BindSourceDB10: TBindSourceDB;
    BindSourceDB11: TBindSourceDB;
    LinkGridToDataSource15: TLinkGridToDataSource;
    LinkGridToDataSource16: TLinkGridToDataSource;
    BindSourceDB12: TBindSourceDB;
    BindSourceDB13: TBindSourceDB;
    dbChartSla: TDBChart;
    BarSeries31: TBarSeries;
    BarSeries32: TBarSeries;
    BarSeries33: TBarSeries;
    Series7: TBarSeries;
    dbChart: TDBChart;
    dbPieChart: TDBChart;
    PieSeries1: TPieSeries;
    rectDadosDestaPesquisa: TRectangle;
    rectTituloDados: TRectangle;
    lblTituloDados: TLabel;
    rectApresentar: TRectangle;
    Rectangle1: TRectangle;
    Label3: TLabel;
    rectParametrosSLA: TRectangle;
    Rectangle2: TRectangle;
    Label17: TLabel;
    rectTotais: TRectangle;
    rectTituloTotais: TRectangle;
    lblTituloTotais: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    QtdEspLabel: TLabel;
    TMELabel: TLabel;
    rectApresentarSLA: TRectangle;
    rect2: TRectangle;
    lbl1: TLabel;
    rectLegenda: TRectangle;
    rectVermelho: TRectangle;
    lblProcessos: TLabel;
    Rectangle3: TRectangle;
    Rectangle4: TRectangle;
    Rectangle5: TRectangle;
    tbsTag: TTabItem;
    tbsFaixaSenha: TTabItem;
    tbsGrupoPAFim: TTabItem;
    tbsGrupoPA: TTabItem;
    tbsPAFim: TTabItem;
    tbsPA: TTabItem;
    tbsGrupoAtendenteFim: TTabItem;
    tbsGrupoAtendente: TTabItem;
    cdsMesidUnidade: TIntegerField;
    cdsDiaidUnidade: TIntegerField;
    cdsDiaSmidUnidade: TIntegerField;
    cdsHoraidUnidade: TIntegerField;
    cdsAtendidUnidade: TIntegerField;
    cdsGrAtendidUnidade: TIntegerField;
    cdsPAidUnidade: TIntegerField;
    cdsGrPAidUnidade: TIntegerField;
    cdsAtendFimidUnidade: TIntegerField;
    cdsGrAtendFimidUnidade: TIntegerField;
    cdsPAFimidUnidade: TIntegerField;
    cdsGrPAFimidUnidade: TIntegerField;
    cdsPPidUnidade: TIntegerField;
    cdsFaixaDeSenhaidUnidade: TIntegerField;
    cdsTagidUnidade: TIntegerField;
    cdsDiaNomeUnidade: TStringField;
    cdsDiaSmNomeUnidade: TStringField;
    cdsHoraNomeUnidade: TStringField;
    cdsAtendNomeUnidade: TStringField;
    cdsGrAtendNomeUnidade: TStringField;
    cdsPANomeUnidade: TStringField;
    cdsGrPANomeUnidade: TStringField;
    cdsAtendFimNomeUnidade: TStringField;
    cdsGrAtendFimNomeUnidade: TStringField;
    cdsPAFimNomeUnidade: TStringField;
    cdsGrPAFimNomeUnidade: TStringField;
    cdsPPNomeUnidade: TStringField;
    cdsFaixaDeSenhaNomeUnidade: TStringField;
    cdsTagNomeUnidade: TStringField;
    cdsMesNomeUnidade: TStringField;
    cdsMesSlaIdUnidade: TIntegerField;
    cdsDiaSlaIdUnidade: TIntegerField;
    cdsDiaSmSlaIdUnidade: TIntegerField;
    cdsHoraSlaIdUnidade: TIntegerField;
    cdsAtendSlaIdUnidade: TIntegerField;
    cdsGrAtendSlaIdUnidade: TIntegerField;
    cdsPASlaIdUnidade: TIntegerField;
    cdsGrPASlaIdUnidade: TIntegerField;
    cdsAtendFimSlaIdUnidade: TIntegerField;
    cdsGrAtendFimSlaIdUnidade: TIntegerField;
    cdsPAFimSlaIdUnidade: TIntegerField;
    cdsGrPAFimSlaIdUnidade: TIntegerField;
    cdsPPSlaIdUnidade: TIntegerField;
    cdsFaixaDeSenhaSlaIdUnidade: TIntegerField;
    cdsTagSlaIdUnidade: TIntegerField;
    cdsMesSlaNomeUnidade: TStringField;
    cdsDiaSlaNomeUnidade: TStringField;
    cdsDiaSmSlaNomeUnidade: TStringField;
    strngfldHoraSlaNomeUnidade: TStringField;
    strngfldAtendSlaNomeUnidade: TStringField;
    strngfldGrAtendSlaNomeUnidade: TStringField;
    strngfldPASlaNomeUnidade: TStringField;
    strngfldGrPASlaNomeUnidade: TStringField;
    strngfldAtendFimSlaNomeUnidade: TStringField;
    strngfldGrAtendFimSlaNomeUnidade: TStringField;
    strngfldPAFimSlaNomeUnidade: TStringField;
    strngfldGrPAFimSlaNomeUnidade: TStringField;
    strngfldPPSlaNomeUnidade: TStringField;
    strngfldFaixaDeSenhaSlaNomeUnidade: TStringField;
    strngfldTagSlaNomeUnidade: TStringField;
    procedure cdsDiaSmCalcFields  (DataSet: TDataSet);
    procedure cdsAtendCalcFields  (DataSet: TDataSet);
    procedure cdsPACalcFields     (DataSet: TDataSet);
    procedure cdsFaixaDeSenhaCalcFields   (DataSet: TDataSet);
    procedure cdsGrAtendCalcFields(DataSet: TDataSet);
    procedure cdsGrPACalcFields   (DataSet: TDataSet);
    procedure QtdChartTypeComboChange(Sender: TObject);
    procedure RotateCWBtnClick(Sender: TObject);
    procedure QtdEspAtdComboChange(Sender: TObject);
    procedure actFecharExecute(Sender: TObject);
    procedure actImprimirExecute(Sender: TObject);
    procedure cdsMesCalcFields(DataSet: TDataSet);
    procedure cdsMesTestesCalcFields(DataSet: TDataSet);
    procedure cdsUnidadeCalcFields(DataSet: TDataSet);
    procedure cdsUnidadeUnidadeNomeGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure cdsMesTMPPGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure cdsTagCalcFields(DataSet: TDataSet);

    procedure PageControlGridsChange(Sender: TObject);
    procedure cdsMesAfterOpen(DataSet: TDataSet);
    procedure cdsTagTagNomeGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure StringField20GetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure cdsFilaEsperaFilaEsperaNomeGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure StringField22GetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure cdsAtendFimCalcFields(DataSet: TDataSet);
    procedure cdsGrAtendFimCalcFields(DataSet: TDataSet);
    procedure cdsPAFimCalcFields(DataSet: TDataSet);
    procedure cdsGrPAFimCalcFields(DataSet: TDataSet);
    procedure PreencheNDOnField(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure cdsPPCalcFields(DataSet: TDataSet);
    procedure chkSlaCinzaChange(Sender: TObject);
    procedure dbChartSlaMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single); Override;
    procedure QtdCheckBoxChange(Sender: TObject);
    procedure actExportarPDFExecute(Sender: TObject);
    procedure RotateCCWBtnClick(Sender: TObject);
    procedure FrameResize(Sender: TObject);
  private
    { Private declarations }
    FParamsSla: TParamsNiveisSla;

  protected
    procedure SetParamsSLA(const Value: TParamsNiveisSla);
    procedure ajustaTipoDBChart;
    procedure ExportarGrafico(const ExportarPara : TExportarPara); Override;
    procedure SetVisibleGraphics; Override;
    procedure ExportarDadosExcel; Override;
    procedure CalcularEstatisticas; Override;
    procedure CalcularEstatisticasSla; Override;
    procedure SetGraficoSla(const Value: Boolean); Override;
    procedure PrepararLkpsUnidades; Override;
  	procedure SetVisible(const aValue: Boolean); Override;
    procedure DefineCorChart; Override;
  public
    destructor Destroy; Override;
    property ParamsSLA: TParamsNiveisSla read FParamsSLA write SetParamsSLA;
    constructor Create(AOwner: TComponent); Overload; override;
  end;


implementation

{$R *.fmx}

uses
 {$IFDEF SuportaQuickRep}
 repGraphPP, VCL.Graphics,
 {$ENDIF SuportaQuickRep}
  ufrmPesquisaRelatorioPP, Sics_Common_Splash, ufrmMensagemPainelEImpressora, Sics_Common_Parametros,
  untCommonDMUnidades;

const

  AGRUPADOR_ATENDENTE_FIM = 11;
  AGRUPADOR_GRUPO_ATENDENTE_FIM = 12;
  AGRUPADOR_PA_FIM = 13;
  AGRUPADOR_GRUPO_PA_FIM = 14;
  AGRUPADOR_PP = 15;

constructor TfrmGraphicsPP.Create(AOwner: TComponent);
begin
  inherited;
end;

procedure TfrmGraphicsPP.ExportarGrafico(const ExportarPara : TExportarPara);
var
  Chart : TDBChart;
begin
  inherited;
  if pnlChartSla.Visible then
    Chart := dbChartSla
  else
    Chart := dbChart;

  ExportarGrafico(ExportarPara, Chart);
end;

procedure TfrmGraphicsPP.FrameResize(Sender: TObject);
const
  OFF = 5;
begin
  inherited;

  {if (ParametrosSLA <> nil) and (ParametrosSLA.Visible) then
  begin
    //ParametrosSLA.Position.X := FiltragemGroup.Position.X + FiltragemGroup.Width + OFF;
    ShowGroupSla .Position.X := ParametrosSLA .Position.X + ParametrosSLA .Width + OFF;
  end;}
end;

procedure TfrmGraphicsPP.ExportarDadosExcel;
{$IFNDEF IS_MOBILE}
  procedure exportToExcel;
    var
      ExcelApplication: TExcelApplication;
      ExcelWorkbook: TExcelWorkbook;
      ExcelWorksheet: TExcelWorksheet;
      iSheetIndex: Integer;
      iRowCount: Integer;

      procedure CriarSheetByFieldName(const SheetName: string; DataSet: TDataSet; const CampoDescr: string);
      var
        cColExcel: Char;
        iField, iRowExcel: Integer;
        sValue: string;
        FDadosExcel: TStringList;
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
              FDadosExcel := TStringList.Create;
              try
                with FDadosExcel do
                begin
                  Add(CampoDescr);

                  if not FGraficoSla then
                  begin
                    Add('QtdPP');
                    Add('TMPP');
                    if vgParametrosModulo.ReportarTemposMaximos then
                      Add('MaxPP');
                  end
                  else
                  begin
                    Add('PP_PERC_VERDE');
                    Add('PP_PERC_AMARELO');
                    Add('PP_PERC_VERMELHO');
                    Add('PP_PERC_CINZA');
                  end;

                  for iField := 0 to Count -1 do
                  begin
                    if iRowExcel = 1 then
                      sValue := FieldByName(Strings[iField]).DisplayLabel
                    else
                      sValue := FieldByName(Strings[iField]).Text;

                    with ExcelWorksheet.Range[cColExcel + IntToStr(iRowExcel), cColExcel + IntToStr(iRowExcel)] do
                    begin
                      if iRowExcel = 1 then
                        Font.Bold := True;
                      Value2 := sValue;
                    end;

                    cColExcel := Chr(Ord(cColExcel)+1);
                  end;
                end;
              finally
                FreeAndNil(FDadosExcel);
              end;

              if iRowExcel <> 1 then
                Next;
            end;
            First;
          end;
        end;

        procedure CriarSheet(const SheetName: string; DataSet: TDataSet; const CampoDescr: TField);
        begin
          CriarSheetByFieldName(SheetName, DataSet, CampoDescr.FieldName);
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
                  CriarSheet('Mes', cdsMes, cdsMesmesStr);
                  CriarSheet('Dia', cdsDia, cdsDiaDia);
                  CriarSheet('Dia Sem', cdsDiaSm, cdsDiaSmDiaSmStr);
                  CriarSheet('Hora', cdsHora, cdsHoraHora);
                  CriarSheet('PP', cdsPP, cdsPPPPNome);                               //LBC
                  CriarSheet('Atend. Inicio', cdsAtend, cdsAtendAtdNome);
                  CriarSheet('Grupo de Atend. Inicio', cdsGrAtend, cdsGrAtendGrAtendNome);
                  CriarSheet('PA Inicio', cdsPa, cdsPaPANome);
                  CriarSheet('Grupo PA Inicio', cdsGrPa, cdsGrPaGrPANome);
                  CriarSheet('Atend. Fim', cdsAtendFim, cdsAtendFimAtdNome);
                  CriarSheet('Grupo de Atend. Fim', cdsGrAtendFim, cdsGrAtendFimGrAtendNome);
                  CriarSheet('PA Fim', cdsPaFim, cdsPAFimPANome);
                  CriarSheet('Grupo PA Fim', cdsGrPaFim, cdsGrPAFimGrPANome);
                  CriarSheet('Faixa de Senha', cdsFaixaDeSenha, cdsFaixaDeSenhaFaixaDeSenhaNome);
                  CriarSheet('Tags', cdsTag, cdsTagTagNome);
                end
                else
                begin
                  CriarSheetByFieldName('Mes'                   , cdsMesSla          , 'DESCRICAO');
                  CriarSheetByFieldName('Dia'                   , cdsDiaSla          , 'DESCRICAO');
                  CriarSheetByFieldName('Dia Sem'               , cdsDiaSmSla        , 'DESCRICAO');
                  CriarSheetByFieldName('Hora'                  , cdsHoraSla         , 'DESCRICAO');
                  CriarSheetByFieldName('PP'                    , cdsPPSla           , 'DESCRICAO');
                  CriarSheetByFieldName('Atend. Inicio'         , cdsAtendSla        , 'DESCRICAO');
                  CriarSheetByFieldName('Grupo de Atend. Inicio', cdsGrAtendSla      , 'DESCRICAO');
                  CriarSheetByFieldName('PA Inicio'             , cdsPaSla           , 'DESCRICAO');
                  CriarSheetByFieldName('Grupo PA Inicio'       , cdsGrPaSla         , 'DESCRICAO');
                  CriarSheetByFieldName('Atend. Fim'            , cdsAtendFimSla     , 'DESCRICAO');
                  CriarSheetByFieldName('Grupo de Atend. Fim'   , cdsGrAtendFimSla   , 'DESCRICAO');
                  CriarSheetByFieldName('PA Fim'                , cdsPaFimSla        , 'DESCRICAO');
                  CriarSheetByFieldName('Grupo PA Fim'          , cdsGrPaFimSla      , 'DESCRICAO');
                  CriarSheetByFieldName('Faixa de Senha'        , cdsFaixaDeSenhaSla , 'DESCRICAO');
                  CriarSheetByFieldName('Tags'                  , cdsTagSla          , 'DESCRICAO');
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
{$ENDIF IS_MOBILE}
begin
  {$IFNDEF IS_MOBILE}
  if(SaveDialogExcel.Execute)then
    exportToExcel;
  {$ENDIF IS_MOBILE}
end;


procedure TfrmGraphicsPP.SetGraficoSla(const Value: Boolean);
begin
  if Value then
  begin
    MesDS.DataSet := cdsMesSla;
    DiaDS.DataSet := cdsDiaSla;
    DiaSmDS.DataSet := cdsDiaSmSla;
    HoraDS.DataSet := cdsHoraSla;
    AtendDS.DataSet := cdsAtendSla;

    GrAtendDS.DataSet := cdsGrAtendSla;
    PADS.DataSet := cdsPASla;
    GrPADS.DataSet := cdsGrPASla;
    FaixaDeSenhaDS.DataSet := cdsFaixaDeSenhaSla;
    TagDS.DataSet := cdsTagSla;

    UnidadeDS.DataSet := cdsUnidadeSla;
    PPDS.DataSet := cdsPPSla;
    GrPAFimDS.DataSet := cdsGrPAFimSla;
    PAFimDS.DataSet := cdsPAFimSla;
    GrAtendFimDS.DataSet := cdsGrAtendFimSla;

    AtendFimDS.DataSet := cdsAtendFimSla;
  end
  else
  begin
    MesDS.DataSet := cdsMes;
    DiaDS.DataSet := cdsDia;
    DiaSmDS.DataSet := cdsDiaSm;
    HoraDS.DataSet := cdsHora;
    AtendDS.DataSet := cdsAtend;

    GrAtendDS.DataSet := cdsGrAtend;
    PADS.DataSet := cdsPA;
    GrPADS.DataSet := cdsGrPA;
    FaixaDeSenhaDS.DataSet := cdsFaixaDeSenha;
    TagDS.DataSet := cdsTag;

    UnidadeDS.DataSet := cdsUnidade;
    PPDS.DataSet := cdsPP;
    GrPAFimDS.DataSet := cdsGrPAFim;
    PAFimDS.DataSet := cdsPAFim;
    GrAtendFimDS.DataSet := cdsGrAtendFim;

    AtendFimDS.DataSet := cdsAtendFim;
  end;
  inherited;
end;

procedure TfrmGraphicsPP.SetParamsSLA(const Value: TParamsNiveisSla);
var
  LfrmPesquisaRelatorioPP: TfrmPesquisaRelatorioPP;
begin
  LfrmPesquisaRelatorioPP := (Owner as TfrmPesquisaRelatorioPP);
  FParamsSLA := Value;

  TfrmSicsSplash.ShowStatus('Gerando os Gráficos...');
  try
    FGraficoSla := FGraficoSla;
    FParamsSla := FParamsSla;
    FMultiUnidades := LfrmPesquisaRelatorioPP.vlRepVars.MultiUnidades <> '';

    if LfrmPesquisaRelatorioPP.vlRepVars.QtdeUnidadesSelecionadas = 1 then
    begin
      if not LfrmPesquisaRelatorioPP.cdsUnidades.Locate('SELECIONADO', True, []) then
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

      PeriodoDoRelatorioLabel.Text := LfrmPesquisaRelatorioPP.vlRepVars.PeriodoDoRelatorio;
      PeriodoDoDiaLabel.Text       := LfrmPesquisaRelatorioPP.vlRepVars.PeriodoDoDia;
      DuracaoLabel.Text            := LfrmPesquisaRelatorioPP.vlRepVars.Duracao;
      AtendentesInicioLabel.Text   := LfrmPesquisaRelatorioPP.vlRepVars.Atds;
      AtendentesFimLabel.Text      := LfrmPesquisaRelatorioPP.vlRepVars.AtdsFim;
      PAsInicioLabel.Text          := LfrmPesquisaRelatorioPP.vlRepVars.PAs;
      PAsFimLabel.Text             := LfrmPesquisaRelatorioPP.vlRepVars.PAsFim;
      SenhasLabel.Text             := LfrmPesquisaRelatorioPP.vlRepVars.Senhas;
      lblUnidadesVal.Visible          := FMultiUnidades;
      lblUnidades.Visible             := FMultiUnidades;
      lblUnidadesVal.Text          := LfrmPesquisaRelatorioPP.vlRepVars.MultiUnidades;
      TagsLabel.Text               := LfrmPesquisaRelatorioPP.vlRepVars.Tags;
      TiposPPLabel.Text            := LfrmPesquisaRelatorioPP.vlRepVars.PPs;

      if LfrmPesquisaRelatorioPP.vlRepVars.QtdeUnidadesSelecionadas > 1 then
      begin
        tbsAtendentes.Visible := False;
        tbsGrupoAtendente.Visible := False;
        tbsPA.Visible := False;
        tbsGrupoPA.Visible := False;
        tbsFaixaSenha.Visible := False;
        tbsTag.Visible := False;
        tbsUnidades.Visible := True;
      end
      else
      begin
        tbsMes              .Visible := True;
        tbsDia              .Visible := True;
        tbsDiaSM            .Visible := True;
        tbsHora             .Visible := True;
        tbsPP               .Visible := True;
        tbsAtendentes       .Visible := True;
        tbsAtendentesFim    .Visible := True;
        tbsGrupoAtendente   .Visible := True;
        tbsGrupoAtendenteFim.Visible := True;
        tbsPA               .Visible := True;
        tbsPAFim            .Visible := True;
        tbsGrupoPA          .Visible := True;
        tbsGrupoPAFim       .Visible := True;
        tbsFaixaSenha       .Visible := True;
        tbsTag              .Visible := True;
        tbsUnidades         .Visible := False;
      end;

      if FGraficoSLA then
      begin
        lblParamsSLAPPVermelho.Text  := FormatDateTime('hh:mm:ss', IncSecond(0, FPAramsSLA.Vermelho));
        lblParamsSLAPPAmarelo.Text   := FormatDateTime('hh:mm:ss', IncSecond(0, FPAramsSLA.Amarelo));
      end;

      ajustaTipoDBChart;
    finally
    end;  { try .. finally }
  finally
    TfrmSicsSplash.Hide;
  end;

end;

procedure TfrmGraphicsPP.SetVisible(const aValue: Boolean);
begin
  inherited;
  if aValue then
    PageControlGrids.OnChange(PageControlGrids);
end;

procedure TfrmGraphicsPP.SetVisibleGraphics;
begin
  if FGraficoSla then
  begin
    rectTotais.Visible := False;
  end;

  pnlChartSla.Visible := FGraficoSla;
  pnlChart.Visible := not pnlChartSla.Visible;

  rectApresentar.Visible := not FGraficoSla;
  rectApresentarSLA.Visible := FGraficoSla;
  rectParametrosSLA.Visible := FGraficoSla;

end;


procedure TfrmGraphicsPP.QtdCheckBoxChange(Sender: TObject);
begin
  inherited;
  cdsMesTMPP         .Visible := TMPPCheckBox.IsChecked;
  cdsDiaTMPP         .Visible := TMPPCheckBox.IsChecked;
  cdsDiaSmTMPP       .Visible := TMPPCheckBox.IsChecked;
  cdsHoraTMPP        .Visible := TMPPCheckBox.IsChecked;
  cdsAtendTMPP       .Visible := TMPPCheckBox.IsChecked;
  cdsGrAtendTMPP     .Visible := TMPPCheckBox.IsChecked;
  cdsPATMPP          .Visible := TMPPCheckBox.IsChecked;
  cdsGrPATMPP        .Visible := TMPPCheckBox.IsChecked;
  cdsFaixaDeSenhaTMPP.Visible := TMPPCheckBox.IsChecked;
  cdsTagTMPP         .Visible := TMPPCheckBox.IsChecked;
  cdsUnidadeTMPP     .Visible := TMPPCheckBox.IsChecked;
  cdsAtendFimTMPP    .Visible := TMPPCheckBox.IsChecked;
  cdsGrAtendFimTMPP  .Visible := TMPPCheckBox.IsChecked;
  cdsPAFimTMPP       .Visible := TMPPCheckBox.IsChecked;
  cdsGrPAFimTMPP     .Visible := TMPPCheckBox.IsChecked;
  cdsPPTMPP          .Visible := TMPPCheckBox.IsChecked;

  if (QtdCheckBox.IsChecked and (not TMPPCheckBox.IsChecked)) then
    QtdChartTypeCombo.Enabled := true
  else
  begin
    QtdChartTypeCombo.ItemIndex := 0;
    QtdChartTypeCombo.OnChange(QtdChartTypeCombo);
    QtdChartTypeCombo.Enabled := false;

    if (QtdCheckBox.IsChecked) then
    begin
      if (TMPPCheckBox.IsChecked) then
      begin
        QtdEspAtdComboChange(Self);
      end
      else if ((not TMPPCheckBox.IsChecked) ) then
      begin
        QtdEspAtdComboChange(Self);
      end;
    end
    else
    begin
      QtdEspAtdComboChange(Self);
    end;
  end;

  AtualizarColunasGrid;
  ajustaTipoDBChart;

  BarSeries31.Active := TMPPCheckBox.IsChecked;
  BarSeries32.Active := (QtdCheckBox.IsChecked and (TMPPCheckBox.IsChecked));
  BarSeries33.Active := (QtdCheckBox.IsChecked and (not TMPPCheckBox.IsChecked));
end;


{=================================================================}
{               Procedures Table.CalcFields                       }
{=================================================================}

procedure TfrmGraphicsPP.cdsMesCalcFields(DataSet: TDataSet);
begin
  cdsMesMesStr.AsString := String(MesStrArray[cdsMesMes.AsInteger]);
end;

procedure TfrmGraphicsPP.cdsDiaSmCalcFields(DataSet: TDataSet);
begin

  cdsDiaSmDiaSmStr.AsString := String(DiaSmStrArray[cdsDiaSmDiaSm.AsInteger]);
end;

procedure TfrmGraphicsPP.cdsAtendCalcFields(DataSet: TDataSet);
begin
  cdsAtendAtdRecNo.AsInteger := cdsAtend.RecNo;
end;

procedure TfrmGraphicsPP.cdsGrAtendCalcFields(DataSet: TDataSet);
begin
  cdsGrAtendGrAtendRecNo.AsInteger := cdsGrAtend.RecNo;
end;

procedure TfrmGraphicsPP.cdsPACalcFields(DataSet: TDataSet);
begin
  cdsPAPARecNo.AsInteger := cdsPA.RecNo;
end;

procedure TfrmGraphicsPP.cdsGrPACalcFields(DataSet: TDataSet);
begin
  cdsGrPAGrPARecNo.AsInteger := cdsGrPA.RecNo;
end;

procedure TfrmGraphicsPP.cdsFaixaDeSenhaCalcFields(DataSet: TDataSet);
begin
  cdsFaixaDeSenhaFaixaDeSenhaRecNo.AsInteger := cdsFaixaDeSenha.RecNo;
end;

procedure TfrmGraphicsPP.cdsUnidadeCalcFields(DataSet: TDataSet);
begin
  cdsUnidadeUnidadeRecNo.AsInteger := cdsUnidade.RecNo;
end;

procedure TfrmGraphicsPP.cdsPPCalcFields(DataSet: TDataSet);
begin
  cdsPPPPRecNo.AsInteger := cdsPP.RecNo;
end;

procedure TfrmGraphicsPP.cdsUnidadeUnidadeNomeGetText (Sender: TField;
                                                      var Text: String; DisplayText: Boolean);
begin
  Text := dmUnidades.Nome[cdsUnidadeUnidade.AsInteger];
end;

procedure TfrmGraphicsPP.QtdChartTypeComboChange(Sender: TObject);
begin
  dbPieChart.Visible := dbChart.Visible and (QtdChartTypeCombo.ItemIndex = 1);
  dbChart.Visible := not dbPieChart.Visible;
  RotateCCWBtn.Visible := dbPieChart.Visible;
  RotateCWBtn.Visible := RotateCCWBtn.Visible;
end;

procedure TfrmGraphicsPP.RotateCCWBtnClick(Sender: TObject);
begin
  RotacionarPie(PieSeries1, False);
end;

procedure TfrmGraphicsPP.RotateCWBtnClick(Sender: TObject);
begin
  RotacionarPie(PieSeries1, True);
end;

procedure TfrmGraphicsPP.QtdEspAtdComboChange(Sender: TObject);
begin
  cdsMesQtdPP            .Visible := QtdCheckBox.IsChecked;
  cdsDiaQtdPP            .Visible := QtdCheckBox.IsChecked;
  cdsDiaSmQtdPP          .Visible := QtdCheckBox.IsChecked;
  cdsHoraQtdPP           .Visible := QtdCheckBox.IsChecked;
  cdsAtendQtdPP          .Visible := QtdCheckBox.IsChecked;
  cdsAtendFimQtdPP       .Visible := QtdCheckBox.IsChecked;
  cdsGrAtendQtdPP        .Visible := QtdCheckBox.IsChecked;
  cdsGrAtendFimQtdPP     .Visible := QtdCheckBox.IsChecked;
  cdsPAQtdPP             .Visible := QtdCheckBox.IsChecked;
  cdsPAFimQtdPP          .Visible := QtdCheckBox.IsChecked;
  cdsGrPAQtdPP           .Visible := QtdCheckBox.IsChecked;
  cdsGrPAFimQtdPP        .Visible := QtdCheckBox.IsChecked;
  cdsFaixaDeSenhaQtdPP   .Visible := QtdCheckBox.IsChecked;
  cdsTagQtdPP            .Visible := QtdCheckBox.IsChecked;
  cdsUnidadeQtdPP        .Visible := QtdCheckBox.IsChecked;
  cdsPPQtdPP             .Visible := QtdCheckBox.IsChecked;
end;

procedure TfrmGraphicsPP.actImprimirExecute(Sender: TObject);
{$IFDEF SuportaQuickRep}
var
  DS : TDataSet;
  qrSicsGraphicPP: TqrSicsGraphicPP;
{$ENDIF SuportaQuickRep}
begin
 {$IFDEF SuportaQuickRep}
  qrSicsGraphicPP := TqrSicsGraphicPP.Create(Self);
  try

    with qrSicsGraphicPP do
    begin
      ItemLabel.Enabled := not FGraficoSla;
      QtdELabel.Enabled := not FGraficoSla;
      TMELabel.Enabled := not FGraficoSla;
      ItemDBText.Enabled := not FGraficoSla;
      QtdEDBText.Enabled := not FGraficoSla;
      TMEDBText.Enabled := not FGraficoSla;

      qrlblSlaPP.Enabled := FGraficoSla;
      qrShapeSlaPP.Enabled := FGraficoSla;
      qrlblPPPercVerde.Enabled := FGraficoSla;
      qrlblPPPercAmarelo.Enabled := FGraficoSla;
      qrlblPPPercVermelho.Enabled := FGraficoSla;
      qrlblPPPercCinza.Enabled := FGraficoSla;
      qrlblSlaDescricao.Enabled := FGraficoSla;
      qrdbtextSlaDescricao.Enabled := FGraficoSla;
      qrdbtextPPPercVerde.Enabled := FGraficoSla;
      qrdbtextPPPercAmarelo.Enabled := FGraficoSla;
      qrdbtextPPPercVermelho.Enabled := FGraficoSla;
      qrdbtextPPPercCinza.Enabled := FGraficoSla;

      if FGraficoSla then
      begin
        qrlblSlaPP            .Top := ItemLabel.Top;
        qrShapeSlaPP          .Top := ItemLabel.Top + 17;
        qrlblSlaDescricao     .Top := qrShapeSlaPP.Top + 2;
        qrlblPPPercVerde      .Top := qrlblSlaDescricao.Top;
        qrlblPPPercAmarelo    .Top := qrlblSlaDescricao.Top;
        qrlblPPPercVermelho   .Top := qrlblSlaDescricao.Top;
        qrlblPPPercCinza      .Top := qrlblSlaDescricao.Top;
        qrdbtextSlaDescricao  .Top := 2;
        qrdbtextPPPercVerde   .Top := 2;
        qrdbtextPPPercAmarelo .Top := 2;
        qrdbtextPPPercVermelho.Top := 2;
        qrdbtextPPPercCinza   .Top := 2;
      end;

      if FGraficoSla then
        ColumnHeaderBand.Height := 45
      else
        ColumnHeaderBand.Height := 24;
      DetailBand.Height := 16;
      SummaryBand.Enabled := not FGraficoSla;
    end;

    DS := nil;
    if not FGraficoSla then
    begin
      case PageControlGrids.TabIndex of
        0 : begin
              DS := cdsMes;
              qrSicsGraphicPP.ItemLabel .Caption := 'Mês';
              qrSicsGraphicPP.ItemDBText.DataField := 'MesStr';
            end;
        1 : begin
              DS := cdsDia;
              qrSicsGraphicPP.ItemLabel .Caption := 'Dia';
              qrSicsGraphicPP.ItemDBText.DataField := 'Dia';
            end;
        2 : begin
              DS := cdsDiaSm;
              qrSicsGraphicPP.ItemLabel .Caption := 'Dia da Semana';
              qrSicsGraphicPP.ItemDBText.DataField := 'DiaSmStr';
            end;
        3 : begin
              DS := cdsHora;
              qrSicsGraphicPP.ItemLabel .Caption := 'Hora';
              qrSicsGraphicPP.ItemDBText.DataField := 'Hora';
            end;
        4 : begin
              DS := cdsPP;
              qrSicsGraphicPP.ItemLabel .Caption := 'PP';
              qrSicsGraphicPP.ItemDBText.DataField := 'PPNome';
            end;
        5 : begin
              DS := cdsAtend;
              qrSicsGraphicPP.ItemLabel .Caption := 'Atendente';
              qrSicsGraphicPP.ItemDBText.DataField := 'AtdNome';
            end;
        6 : begin
              DS := cdsAtendFim;
              qrSicsGraphicPP.ItemLabel .Caption := 'Atendente Fim';
              qrSicsGraphicPP.ItemDBText.DataField := 'AtdNome';
            end;
        7 : begin
              DS := cdsGrAtend;
              qrSicsGraphicPP.ItemLabel .Caption := 'Grupo de Atendente';
              qrSicsGraphicPP.ItemDBText.DataField := 'GrAtendNome';
            end;
        8 : begin
              DS := cdsGrAtendFim;
              qrSicsGraphicPP.ItemLabel .Caption := 'Grupo de Atendente Fim';
              qrSicsGraphicPP.ItemDBText.DataField := 'GrAtendNome';
            end;
        9 : begin
              DS := cdsPA;
              qrSicsGraphicPP.ItemLabel .Caption := 'PA';
              qrSicsGraphicPP.ItemDBText.DataField := 'PANome';
            end;
       10 : begin
              DS := cdsPAFim;
              qrSicsGraphicPP.ItemLabel .Caption := 'PA Fim';
              qrSicsGraphicPP.ItemDBText.DataField := 'PANome';
            end;
       11 : begin
              DS := cdsGrPA;
              qrSicsGraphicPP.ItemLabel .Caption := 'Grupo de PA';
              qrSicsGraphicPP.ItemDBText.DataField := 'GrPANome';
            end;
       12 : begin
              DS := cdsGrPAFim;
              qrSicsGraphicPP.ItemLabel .Caption := 'Grupo de PA Fim';
              qrSicsGraphicPP.ItemDBText.DataField := 'GrPANome';
            end;
       13 : begin
              DS := cdsFaixaDeSenha;
              qrSicsGraphicPP.ItemLabel .Caption := 'Tipo da Senha';
              qrSicsGraphicPP.ItemDBText.DataField := 'FaixaDeSenhaNome';
            end;
       14 : begin
              DS := cdsTag;
              qrSicsGraphicPP.ItemLabel .Caption := 'Tag';
              qrSicsGraphicPP.ItemDBText.DataField := 'TagNome';
            end;
       15 : begin
              DS := cdsUnidade;
              qrSicsGraphicPP.ItemLabel .Caption := 'Unidade';
              qrSicsGraphicPP.ItemDBText.DataField := 'UnidadeNome';

            end;
      end;  { case }

      {$IFDEF SuportaQuickRep}
      if QtdChartTypeCombo.ItemIndex = 0 then
        dbChart.MakeScreenshot.SaveToFile(SettingsPathName + 'Graphics.bmp')
      else
        dbPieChart.MakeScreenshot.SaveToFile(SettingsPathName + 'Graphics.bmp');
      {$ENDIF SuportaQuickRep}
      qrSicsGraphicPP.QrImageChart.Picture.LoadFromFile(SettingsPathName + 'Graphics.bmp');

      qrSicsGraphicPP.DataSet            := DS;
      qrSicsGraphicPP.ItemDBText.DataSet := DS;

      if QtdCheckBox.IsChecked then
        qrSicsGraphicPP.QtdEDBText.DataSet := DS
      else
        qrSicsGraphicPP.QtdEDBText.DataSet := nil;

      if TMPPCheckBox.IsChecked then
        qrSicsGraphicPP.TMEDBText .DataSet := DS
      else
        qrSicsGraphicPP.TMEDBText .DataSet := nil;
    end
    else
    begin
      case PageControlGrids.TabIndex of
        0 : begin
              qrSicsGraphicPP.qrlblSlaDescricao.Caption := 'Mês';
              DS := cdsMesSla;
            end;
        1 : begin
              qrSicsGraphicPP.qrlblSlaDescricao.Caption := 'Dia';
              DS := cdsDiaSla;
            end;
        2 : begin
              qrSicsGraphicPP.qrlblSlaDescricao.Caption := 'Dia da Semana';
              DS := cdsDiaSmSla;
            end;
        3 : begin
              qrSicsGraphicPP.qrlblSlaDescricao.Caption := 'Hora';
              DS := cdsHoraSla;
            end;
        4 : begin
              qrSicsGraphicPP.qrlblSlaDescricao.Caption := 'PP';
              DS := cdsPPSla;
            end;
        5 : begin
              qrSicsGraphicPP.qrlblSlaDescricao.Caption := 'Atendente';
              DS := cdsAtendSla;
            end;
        6 : begin
              qrSicsGraphicPP.qrlblSlaDescricao.Caption := 'Atend. Fim';
              DS := cdsAtendFimSla;
            end;
        7 : begin
              qrSicsGraphicPP.qrlblSlaDescricao.Caption := 'Grupo Atendente';
              DS := cdsGrAtendSla;
            end;
        8 : begin
              qrSicsGraphicPP.qrlblSlaDescricao.Caption := 'Grupo Atend. Fim';
              DS := cdsGrAtendFimSla;
            end;
        9 : begin
              qrSicsGraphicPP.qrlblSlaDescricao.Caption := 'PA';
              DS := cdsPASla;
            end;
       10 : begin
              qrSicsGraphicPP.qrlblSlaDescricao.Caption := 'PA Fim';
              DS := cdsPAFimSla;
            end;
       11 : begin
              qrSicsGraphicPP.qrlblSlaDescricao.Caption := 'Grupo de PA';
              DS := cdsGrPASla;
            end;
       12 : begin
              qrSicsGraphicPP.qrlblSlaDescricao.Caption := 'Grupo de PA Fim';
              DS := cdsGrPAFimSla;
            end;
       13 : begin
              qrSicsGraphicPP.qrlblSlaDescricao.Caption := 'Tipo da Senha';
              DS := cdsFaixaDeSenhaSla;
            end;
       14 : begin
              qrSicsGraphicPP.qrlblSlaDescricao.Caption := 'Tag';
              DS := cdsTagSla;
            end;
       15 : begin
              qrSicsGraphicPP.qrlblSlaDescricao.Caption := 'Unidade';
              DS := cdsUnidadeSla;
            end;
        end;

      qrSicsGraphicPP.qrdbtextSlaDescricao.DataSet := DS;
      qrSicsGraphicPP.qrdbtextPPPercVerde.DataSet := DS;
      qrSicsGraphicPP.qrdbtextPPPercAmarelo.DataSet := DS;
      qrSicsGraphicPP.qrdbtextPPPercVermelho.DataSet := DS;
      qrSicsGraphicPP.qrdbtextPPPercCinza.DataSet := DS;
      qrSicsGraphicPP.DataSet := DS;

      dbChartSla.MakeScreenshot.SaveToFile(SettingsPathName + 'Graphics.bmp');
      qrSicsGraphicPP.QrImageChart.Picture.LoadFromFile(SettingsPathName + 'Graphics.bmp');
    end;

    qrSicsGraphicPP.Prepare;

     qrSicsGraphicPP.QrImageChart.Top         := qrSicsGraphicPP.DetailBand.Top + qrSicsGraphicPP.DetailBand.Height * (qrSicsGraphicPP.RecordCount + 1) + qrSicsGraphicPP.SummaryBand.Height;
     qrSicsGraphicPP.QrImageChart.Height      := Trunc(qrSicsGraphicPP.Page.Length) - Trunc(qrSicsGraphicPP.Page.BottomMargin) -
                                         (qrSicsGraphicPP.DetailBand.Top + qrSicsGraphicPP.DetailBand.Height * 32 + qrSicsGraphicPP.SummaryBand.Height);
     qrSicsGraphicPP.QrImageChart.Left        := qrSicsGraphicPP.PageHeaderBand.Left;
     qrSicsGraphicPP.QrImageChart.Width       := qrSicsGraphicPP.PageHeaderBand.Width;

    if (qrSicsGraphicPP.QrImageChart.Height < 0) then
      qrSicsGraphicPP.QrImageChart.Height := qrSicsGraphicPP.QrImageChart.Height * -1;

    qrSicsGraphicPP.AtendantsLabel.Caption := AtendentesInicioLabel.Text;
    qrSicsGraphicPP.PAsLabel               .Caption := PAsInicioLabel         .Text;
    qrSicsGraphicPP.AtendantsFimLabel      .Caption := AtendentesFimLabel     .Text;
    qrSicsGraphicPP.PAsFimLabel            .Caption := PAsFimLabel            .Text;
    qrSicsGraphicPP.SenhasLabel            .Caption := SenhasLabel            .Text;
    qrSicsGraphicPP.PeriodoDoRelatorioLabel.Caption := PeriodoDoRelatorioLabel.Text;
    qrSicsGraphicPP.PeriodoDoDiaLabel      .Caption := PeriodoDoDiaLabel      .Text;
    qrSicsGraphicPP.DurationLabel          .Caption := DuracaoLabel           .Text;
    qrSicsGraphicPP.TagsLabel              .Caption := TagsLabel              .Text;
    qrSicsGraphicPP.TiposPPLabel           .Caption := TiposPPLabel           .Text;
    qrSicsGraphicPP.lblMultiUnidades.Enabled := FMultiUnidades;
    qrSicsGraphicPP.lblMultiUnidadesVal.Enabled := FMultiUnidades;
    qrSicsGraphicPP.lblMultiUnidadesVal.Caption := lblUnidadesVal.Text;

    if FMultiUnidades then
    begin
      qrSicsGraphicPP.lblRelatorio.Caption := '';
      qrSicsGraphicPP.UnidadeLabel.Caption := '';
    end
    else
    begin
      qrSicsGraphicPP.lblRelatorio.Caption := 'Relatório';
      qrSicsGraphicPP.UnidadeLabel.Caption := vgParametrosModulo.Unidade;
    end;

    qrSicsGraphicPP.TotaisQtdELabel.Caption := QtdEspLabel.Text;
    qrSicsGraphicPP.TotaisTMELabel .Caption := TMELabel   .Text;

    qrSicsGraphicPP.PreviewModal;
  finally
    FreeAndNil(qrSicsGraphicPP);
  end;
 {$ENDIF SuportaQuickRep}
end;  { proc ActionImprimir }


procedure TfrmGraphicsPP.actExportarPDFExecute(Sender: TObject);
begin
  inherited;
 //
end;

procedure TfrmGraphicsPP.actFecharExecute(Sender: TObject);
begin
  Visible := False;
end;  { proc ActionFechar }


procedure TfrmGraphicsPP.cdsMesTestesCalcFields(DataSet: TDataSet);
begin
  // VER COMO FUNCIONA O MSCES
  cdsMesTestesTME.AsDateTime := TimeStampToDateTime(MSecsToTimeStamp(cdsMesTestesTME_MSECS.AsInteger));
  cdsMesTestesTMA.AsDateTime := TimeStampToDateTime(MSecsToTimeStamp(cdsMesTestesTMA_MSECS.AsInteger));
end;

procedure TfrmGraphicsPP.cdsMesTMPPGetText(Sender: TField; var Text: String;
  DisplayText: Boolean);
begin
  Text := MyFormatDateTime('[h]:nn:ss', Sender.AsDateTime);
end;

procedure TfrmGraphicsPP.cdsTagCalcFields(DataSet: TDataSet);
begin
  cdsTagTagRecNo.AsInteger := cdsTag.RecNo;
end;

procedure TfrmGraphicsPP.CalcularEstatisticas;

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
  iQtdETotal, iTMETotal, iNovoTME: Integer;
  qryEstatisticasTemp: TFDQuery;
  DataSetDescricao: TDataSet;
  sMax,NomeUnidade: string;

var
  LfrmPesquisaRelatorioPP: TfrmPesquisaRelatorioPP;
begin
  LfrmPesquisaRelatorioPP := (Owner as TfrmPesquisaRelatorioPP);

  Self.cdsMes         .Close;
  Self.cdsHora        .Close;
  Self.cdsDia         .Close;
  Self.cdsDiaSm       .Close;
  Self.cdsAtend       .Close;
  Self.cdsPA          .Close;
  Self.cdsFaixaDeSenha.Close;
  Self.cdsGrAtend     .Close;
  Self.cdsGrPA        .Close;
  Self.cdsUnidade     .Close;
  Self.cdsTAG         .Close;
  Self.cdsAtendFim    .Close;
  Self.cdsPAFim       .Close;
  Self.cdsGrAtendFim  .Close;
  Self.cdsGrPAFim     .Close;
  Self.cdsPP          .Close;

  Self.cdsMes         .CreateDataSet;
  Self.cdsHora        .CreateDataSet;
  Self.cdsDia         .CreateDataSet;
  Self.cdsDiaSm       .CreateDataSet;
  Self.cdsAtend       .CreateDataSet;
  Self.cdsPA          .CreateDataSet;
  Self.cdsFaixaDeSenha.CreateDataSet;
  Self.cdsGrAtend     .CreateDataSet;
  Self.cdsGrPA        .CreateDataSet;
  Self.cdsUnidade     .CreateDataSet;
  Self.cdsTAG         .CreateDataSet;
  Self.cdsAtendFim    .CreateDataSet;
  Self.cdsPAFim       .CreateDataSet;
  Self.cdsGrAtendFim  .CreateDataSet;
  Self.cdsGrPAFim     .CreateDataSet;
  Self.cdsPP          .CreateDataSet;

  iQtdETotal := 0;
  iTMETotal  := 0;

  LfrmPesquisaRelatorioPP.cdsUnidades.First;
  while not LfrmPesquisaRelatorioPP.cdsUnidades.Eof do
  begin

    if not LfrmPesquisaRelatorioPP.cdsUnidades.FieldByName('SELECIONADO').AsBoolean then
    begin
      LfrmPesquisaRelatorioPP.cdsUnidades.Next;
      Continue;
    end;

    LIdUnidade := LfrmPesquisaRelatorioPP.cdsUnidades.FieldByName('ID').AsInteger;
    NomeUnidade := LfrmPesquisaRelatorioPP.cdsUnidades.FieldByName('NOME').AsString;
    PrepararLkpsUnidades;

    qryEstatisticas.Sql.Text := FSqlEstatisticas;
    qryEstatisticas.Sql.Add ('where EPP.ID_UNIDADE = :ID_UNIDADE AND (                                                      ');
    LfrmPesquisaRelatorioPP.MontarWhere(qryEstatisticas, sInTags, False);
    sWhere := Copy(qryEstatisticas.Sql.Text, Length(FSqlEstatisticas), Length(qryEstatisticas.Sql.Text) - Length(FSqlEstatisticas));
    sWhere := Copy(sWhere, 2, Length(sWhere));

    qryEstatisticas.Sql.Text := StringReplace(FSqlEstatisticas, '/* WHERE */', sWhere, [rfReplaceAll, rfIgnoreCase]);
    if vgParametrosModulo.ReportarTemposMaximos then
    begin
      sMax := 'COALESCE( MAX( EPP.DURACAO_SEGUNDOS  ), 0) AS MAXPP,';
      qryEstatisticas.Sql.Text := StringReplace(qryEstatisticas.Sql.Text, '/* MAX_TE_TA */', sMax, [rfReplaceAll, rfIgnoreCase]);
    end;

    if LfrmPesquisaRelatorioPP.vlQueryParamsPP.ChoosePswd then
      qryEstatisticas.Sql.Text :=
        StringReplace(qryEstatisticas.Sql.Text, '/* JOINS */', 'INNER JOIN TICKETS S ON S.ID = EPP.ID_TICKET AND EPP.ID_UNIDADE = S.ID_UNIDADE', [rfReplaceAll, rfIgnoreCase]);

    if sInTags <> '' then
      qryEstatisticas.Sql.Text := StringReplace(qryEstatisticas.Sql.Text, '/* JOIN_TICKETS_TAGS_ON */', ' AND TT.ID_TAG IN(' + sInTags + ')', [rfIgnoreCase]);

    // devido a um bug na dbexpress, temos que criar uma nova sqlquery quando muda
    // a conexao, pois o clientedataset nao consegue "enxergar" as mudancas
    qryEstatisticasTemp := TFDQuery.Create(Self);
    try
      qryEstatisticas.Sql.Text := StringReplace(qryEstatisticas.Sql.Text, 'GROUP BY', ') GROUP BY', [rfReplaceAll, rfIgnoreCase]);

      qryEstatisticas.ParamByName('ID_UNIDADE').DataType := ftInteger;
      qryEstatisticas.ParamByName('ID_UNIDADE').AsInteger := LIdUnidade;

      qryEstatisticasTemp.Sql.Text := qryEstatisticas.Sql.Text;
      qryEstatisticasTemp.Params.Assign(qryEstatisticas.Params);
      qryEstatisticasTemp.Connection := DMClient(LIdUnidade, not CRIAR_SE_NAO_EXISTIR).ConnRelatorio;
      dspEstatisticas.DataSet := qryEstatisticasTemp;

      qryEstatisticasTemp.Prepare;
      qryEstatisticas.Prepare;
      {$IFDEF DEBUG}
      ClipBoard.AsText := qryEstatisticas.SQL.GetText;
      {$ENDIF}
      cdsEstatisticas.Open;
      try
        cdsEstatisticas.Filtered := True;

        for iAgrupador := AGRUPADOR_MES to AGRUPADOR_PP do
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
            AGRUPADOR_FAIXADESENHA:
            begin
              CdsTemp := Self.cdsFaixaDeSenha;
              sCampoId := 'FaixaDeSenha';
              sDescricao := 'Faixa de Senha';
              DataSetDescricao := cdsLkpFaixaDeSenhas;
              sCampoDescricao := 'FaixaDeSenhaNome';
            end;
            AGRUPADOR_TAG:
            begin
              CdsTemp := Self.cdsTAG;
              sCampoId := 'Tag';
              sDescricao := 'Tag';
              DataSetDescricao := cdsLkpTags;
              sCampoDescricao := 'TagNome';
            end;
            AGRUPADOR_ATENDENTE_FIM:
            begin
              CdsTemp := Self.cdsAtendFim;
              sCampoId := 'Atend';
              sDescricao := 'Atendente Fim';
              DataSetDescricao := cdsLkpAtendentes;
              sCampoDescricao := 'AtdNome';
            end;
            AGRUPADOR_GRUPO_ATENDENTE_FIM:
            begin
              CdsTemp := Self.cdsGrAtendFim;
              sCampoId := 'GrAtend';
              sDescricao := 'Grupo de Atend. Fim';
              DataSetDescricao := cdsLkpGruposAtendentes;
              sCampoDescricao := 'GrAtendNome';
            end;
            AGRUPADOR_PA_FIM:
            begin
              CdsTemp := Self.cdsPAFim;
              sCampoId := 'PA';
              sDescricao := 'PA Fim';
              DataSetDescricao := cdsLkpPAS;
              sCampoDescricao := 'PANome';
            end;
            AGRUPADOR_GRUPO_PA_FIM:
            begin
              CdsTemp := Self.cdsGrPAFim;
              sCampoId := 'GrPA';
              sDescricao := 'Grupo de PA Fim';
              DataSetDescricao := cdsLkpGruposPAs;
              sCampoDescricao := 'GrPANome';
            end;
            AGRUPADOR_PP:
            begin
              CdsTemp := Self.cdsPP;
              sCampoId := 'PP';
              sDescricao := 'PP';
              DataSetDescricao := cdsLkpPPs;
              sCampoDescricao := 'PPNome';
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
          if(LfrmPesquisaRelatorioPP.vlRepVars.QtdeUnidadesSelecionadas > 1)then
            CdsTemp.FieldByName('NomeUnidade').Visible := true
          else
            CdsTemp.FieldByName('NomeUnidade').Visible := false;

          TfrmSicsSplash.ShowStatus('Gravando dados -  por ' + sDescricao + '...');
          with cdsEstatisticas do
          begin
            Filter := 'AGRUPADOR=' + IntToStr(iAgrupador);
            try
              First;
              while not Eof do
              begin
                if cdsTemp.Locate(sCampoId, FieldByName('ID').Value, []) then
                begin
                  cdsTemp.Edit;

                  if cdsTemp.FieldByName('QtdPP').AsInteger > 0 then
                    iNovoTME := Round(
                      ( (cdsTemp.FieldByName('QtdPP').AsInteger * DateTimeToSegundos(cdsTemp.FieldByName('TMPP').AsDateTime)) +
                        (FieldByName('QtdPP').AsInteger * FieldByName('TMPP').AsInteger)
                      ) /
                      (cdsTemp.FieldByName('QtdPP').AsInteger + FieldByName('QtdPP').AsInteger)
                    )
                  else
                    iNovoTME := FieldByName('TMPP').AsInteger;

                  cdsTemp.FieldByName('TMPP').AsDateTime := SegundosParaDateTime(iNovoTME);
                  cdsTemp.FieldByName('QtdPP').AsInteger := cdsTemp.FieldByName('QtdPP').AsInteger + FieldByName('QtdPP').AsInteger;

                  if vgParametrosModulo.ReportarTemposMaximos then
                  begin
                    cdsTemp.FieldByName('MaxPP').AsDateTime := SegundosParaDateTime(Max(DateTimeToSegundos(cdsTemp.FieldByName('MaxPP').AsDateTime), FieldByName('MAXPP').AsInteger));
                  end;
                end
                else
                begin
                  cdsTemp.Append;
                  cdsTemp.FieldByName(sCampoId).Value    := FieldByName('ID').Value;
                  cdsTemp.FieldByName('QtdPP').AsInteger  := FieldByName('QtdPP').AsInteger;
                  cdsTemp.FieldByName('TMPP').AsDateTime  := SegundosParaDateTime(FieldByName('TMPP').AsInteger);
                  cdsTemp.FieldByName('idUnidade').AsInteger := LIdUnidade;
                  cdsTemp.FieldByName('NomeUnidade').AsString := NomeUnidade;
                  if vgParametrosModulo.ReportarTemposMaximos then
                  begin
                    cdsTemp.FieldByName('MaxPP').AsDateTime := SegundosParaDateTime(FieldByName('MAXPP').AsInteger);
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
            cdsUnidade.FieldByName('TMPP').AsDateTime := SegundosParaDateTime(FieldByName('TMPP').AsInteger);
            cdsUnidade.FieldByName('QtdPP').AsInteger := FieldByName('QtdPP').AsInteger;

            if vgParametrosModulo.ReportarTemposMaximos then
            begin
              cdsUnidade.FieldByName('MaxPP').AsDateTime := SegundosParaDateTime(FieldByName('MAXPP').AsInteger);
            end;

            cdsUnidade.Post;

            if iTMETotal > 0 then
              iTMETotal := Round(
                ( (iQtdETotal * iTMETotal) +
                  (FieldByName('QtdPP').AsInteger * FieldByName('TMPP').AsInteger)
                ) /
                (iQtdETotal + FieldByName('QtdPP').AsInteger)
              )
            else
              iTMETotal := FieldByName('TMPP').AsInteger;

            iQtdETotal := iQtdETotal + FieldByName('QtdPP').AsInteger;
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
    end;

    LfrmPesquisaRelatorioPP.cdsUnidades.Next;
  end;

  Self.QtdEspLabel.Text := IntToStr(iQtdETotal);
  Self.TMELabel.Text    := MyFormatDateTime('[h]:nn:ss', SegundosParaDateTime(iTMETotal));



  Self.QtdChartTypeCombo.OnChange(Self.QtdChartTypeCombo);
  AtualizarColunasGrid;
end;

procedure TfrmGraphicsPP.CalcularEstatisticasSla;

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
      AGRUPADOR_MES                 : Result := String(MesStrArray[Integer(Value)]);
      AGRUPADOR_DIA                 : Result := Value;
      AGRUPADOR_SEMANA              : Result := String(DiaSmStrArray[Integer(Value)]);
      AGRUPADOR_HORA                : Result := Value;
      AGRUPADOR_ATENDENTE           : Result := GetDcrFromLkp(Value, cdsLkpAtendentes);
      AGRUPADOR_GRUPO_ATENDENTE     : Result := GetDcrFromLkp(Value, cdsLkpGruposAtendentes);
      AGRUPADOR_PA                  : Result := GetDcrFromLkp(Value, cdsLkpPAS);
      AGRUPADOR_GRUPO_PA            : Result := GetDcrFromLkp(Value, cdsLkpGruposPAS);
      AGRUPADOR_FAIXADESENHA        : Result := GetDcrFromLkp(Value, cdsLkpFaixaDeSenhas);
      AGRUPADOR_TAG                 : Result := GetDcrFromLkp(Value, cdsLkpTags);
      AGRUPADOR_ATENDENTE_FIM       : Result := GetDcrFromLkp(Value, cdsLkpAtendentes);
      AGRUPADOR_GRUPO_ATENDENTE_FIM : Result := GetDcrFromLkp(Value, cdsLkpGruposAtendentes);
      AGRUPADOR_PA_FIM              : Result := GetDcrFromLkp(Value, cdsLkpPAS);
      AGRUPADOR_GRUPO_PA_FIM        : Result := GetDcrFromLkp(Value, cdsLkpGruposPAS);
      AGRUPADOR_PP                  : Result := GetDcrFromLkp(Value, cdsLkpPPs);
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
  iAgrupador, iRecNo, iAmarelo, iVermelho: Integer;
  CdsTemp: TClientDataSet;
  qryEstatisticasTemp: TFDQuery;
  LIdUnidade{, iEspAtd}: Integer;
  dblNovoPerc: Double;
  {sEspAtd, }sCor, sCampoQtde, sCampoPerc, sCampoQtdeTotal, sCampoQtdeCinza,NomeUnidade: string;
  iCor: Integer;
  LfrmPesquisaRelatorioPP: TfrmPesquisaRelatorioPP;
begin
  LfrmPesquisaRelatorioPP := (Owner as TfrmPesquisaRelatorioPP);

  sAux := 'PP';
  iAmarelo  := FParamsSla.Amarelo;
  iVermelho := FParamsSla.Vermelho;

  case LfrmPesquisaRelatorioPP.vlQueryParamsPP.Duracao.TipoDeDuracao of
    tdMenor      : sCondCinzaBase := 'EPP.DURACAO_SEGUNDOS < ' + IntToStr(SecondsBetween(0, LfrmPesquisaRelatorioPP.vlQueryParamsPP.Duracao.Tempo1));
    tdMaiorIgual : sCondCinzaBase := 'EPP.DURACAO_SEGUNDOS >= ' + IntToStr(SecondsBetween(0, LfrmPesquisaRelatorioPP.vlQueryParamsPP.Duracao.Tempo1));
    tdEntre      : sCondCinzaBase := 'EPP.DURACAO_SEGUNDOS BETWEEN ' + IntToStr(SecondsBetween(0, LfrmPesquisaRelatorioPP.vlQueryParamsPP.Duracao.Tempo1)) +
                                     ' AND ' + IntToStr(SecondsBetween(0, LfrmPesquisaRelatorioPP.vlQueryParamsPP.Duracao.Tempo2));
  else
    sCondCinzaBase := '';
  end;

  if sCondCinzaBase <> '' then
  begin
    sCondCinza := ' NOT ' + sCondCinzaBase;
    sNotCondCinza := ' AND ' + sCondCinzaBase;
  end
  else
  begin
    sCondCinza := ' 1 = 2'; // p/ forcar sempre ser FALSE e nao calcular o CINZA
    sNotCondCinza := '';
  end;
  sCondVerde := ' EPP.DURACAO_SEGUNDOS < ' + IntToStr(iAmarelo) + sNotCondCinza;
  sCondAmarelo := ' EPP.DURACAO_SEGUNDOS BETWEEN ' + IntToStr(iAmarelo) + ' AND ' + IntToStr(iVermelho -1) + sNotCondCinza;
  sCondVermelho := ' EPP.DURACAO_SEGUNDOS >= ' + IntToStr(iVermelho) + sNotCondCinza;

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
  Self.cdsFaixaDeSenhaSla          .Close;
  Self.cdsFaixaDeSenhaSla.FieldDefs.Clear;
  Self.cdsGrAtendSla               .Close;
  Self.cdsGrAtendSla     .FieldDefs.Clear;
  Self.cdsGrPASla                  .Close;
  Self.cdsGrPASla        .FieldDefs.Clear;
  Self.cdsUnidadeSla               .Close;
  Self.cdsUnidadeSla     .FieldDefs.Clear;
  Self.cdsTAGSla                   .Close;
  Self.cdsTAGSla         .FieldDefs.Clear;
  Self.cdsAtendFimSla              .Close;
  Self.cdsAtendFimSla    .FieldDefs.Clear;
  Self.cdsPAFimSla                 .Close;
  Self.cdsPAFimSla       .FieldDefs.Clear;
  Self.cdsGrAtendFimSla            .Close;
  Self.cdsGrAtendFimSla  .FieldDefs.Clear;
  Self.cdsGrPAFimSla               .Close;
  Self.cdsGrPAFimSla     .FieldDefs.Clear;
  Self.cdsPPSla                    .Close;
  Self.cdsPPSla          .FieldDefs.Clear;


  Self.cdsMesSla         .CreateDataSet;
  Self.cdsHoraSla        .CreateDataSet;
  Self.cdsDiaSla         .CreateDataSet;
  Self.cdsDiaSmSla       .CreateDataSet;
  Self.cdsAtendSla       .CreateDataSet;
  Self.cdsPASla          .CreateDataSet;
  Self.cdsFaixaDeSenhaSla.CreateDataSet;
  Self.cdsGrAtendSla     .CreateDataSet;
  Self.cdsGrPASla        .CreateDataSet;
  Self.cdsUnidadeSla     .CreateDataSet;
  Self.cdsTAGSla         .CreateDataSet;
  Self.cdsAtendFimSla    .CreateDataSet;
  Self.cdsPAFimSla       .CreateDataSet;
  Self.cdsGrAtendFimSla  .CreateDataSet;
  Self.cdsGrPAFimSla     .CreateDataSet;
  Self.cdsPPSla          .CreateDataSet;

  LfrmPesquisaRelatorioPP.cdsUnidades.First;
  while not LfrmPesquisaRelatorioPP.cdsUnidades.Eof do
  begin
    if not LfrmPesquisaRelatorioPP.cdsUnidades.FieldByName('SELECIONADO').AsBoolean then
    begin
      LfrmPesquisaRelatorioPP.cdsUnidades.Next;
      Continue;
    end;

    LIdUnidade := LfrmPesquisaRelatorioPP.cdsUnidades.FieldByName('ID').AsInteger;
    NomeUnidade := LfrmPesquisaRelatorioPP.cdsUnidades.FieldByName('NOME').AsString;
    PrepararLkpsUnidades;

    qryEstatisticasSla.Sql.Text := FSqlEstatisticasSla;
    qryEstatisticasSla.Sql.Add ('where EPP.ID_UNIDADE = :ID_UNIDADE AND (                                                      ');
    LfrmPesquisaRelatorioPP.MontarWhere(qryEstatisticasSla, sInTags, True);
    sWhere := Copy(qryEstatisticasSla.Sql.Text, Length(FSqlEstatisticasSla), Length(qryEstatisticasSla.Sql.Text) - Length(FSqlEstatisticasSla));
    sWhere := Copy(sWhere, 2, Length(sWhere));

    qryEstatisticasSla.Sql.Text := StringReplace(FSqlEstatisticasSla, '/* WHERE */', sWhere, [rfReplaceAll]);

    if LfrmPesquisaRelatorioPP.vlQueryParamsPP.ChoosePswd then
      qryEstatisticasSla.Sql.Text :=
        StringReplace(qryEstatisticasSla.Sql.Text, '/* JOINS */', 'INNER JOIN TICKETS S ON S.ID = EPP.ID_TICKET', [rfReplaceAll]);

    if sInTags <> '' then
      qryEstatisticasSla.Sql.Text :=
        StringReplace(qryEstatisticasSla.Sql.Text, '/* JOIN_TICKETS_TAGS_ON */', ' AND TT.ID_TAG IN(' + sInTags + ')', []);


    qryEstatisticasSla.Sql.Text := StringReplace(qryEstatisticasSla.Sql.Text, '/* CONDICAO_' + sAux + '_VERDE */', sCondVerde, [rfReplaceAll, rfIgnoreCase]);
    qryEstatisticasSla.Sql.Text := StringReplace(qryEstatisticasSla.Sql.Text, '/* CONDICAO_' + sAux + '_AMARELO */', sCondAmarelo, [rfReplaceAll, rfIgnoreCase]);
    qryEstatisticasSla.Sql.Text := StringReplace(qryEstatisticasSla.Sql.Text, '/* CONDICAO_' + sAux + '_VERMELHO */', sCondVermelho, [rfReplaceAll, rfIgnoreCase]);
    qryEstatisticasSla.Sql.Text := StringReplace(qryEstatisticasSla.Sql.Text, '/* CONDICAO_' + sAux + '_CINZA */', sCondCinza, [rfReplaceAll, rfIgnoreCase]);


    // devido a um bug na dbexpress, temos que criar uma nova sqlquery quando muda
    // a conexao, pois o clientedataset nao consegue "enxergar" as mudancas
    qryEstatisticasTemp := TFDQuery.Create(Self);
    try
      qryEstatisticasSLA.Sql.Text := StringReplace(qryEstatisticasSLA.Sql.Text, 'GROUP BY', ') GROUP BY', [rfReplaceAll, rfIgnoreCase]);

      qryEstatisticasTemp.Sql.Text := qryEstatisticasSLA.Sql.Text;
      qryEstatisticasTemp.Params.Assign(qryEstatisticasSLA.Params);
      qryEstatisticasTemp.Connection := DMClient(LIdUnidade, not CRIAR_SE_NAO_EXISTIR).ConnRelatorio;
      dspEstatisticasSLA.DataSet := qryEstatisticasTemp;

       //ClipBoard.AsText := qryEstatisticasTemp.Sql.Text;
      //qryEstatisticasTemp.Sql.SaveToFile('C:\sql.txt');
      qryEstatisticasSla.ParamByName('ID_UNIDADE').DataType := ftInteger;
      qryEstatisticasTemp.ParamByName('ID_UNIDADE').DataType := ftInteger;
      qryEstatisticasTemp.Prepare;
      qryEstatisticasSla.Prepare;
      {$IFDEF DEBUG}
      ClipBoard.AsText := qryEstatisticasSLA.SQL.GetText;
      {$ENDIF}
      cdsEstatisticasSla.Open;
      try
        cdsEstatisticasSla.Filtered := True;

        for iAgrupador := AGRUPADOR_MES to AGRUPADOR_PP do
        begin
          case iAgrupador of
            AGRUPADOR_MES                 : begin
                                              CdsTemp := cdsMesSla;
                                              sDescricao := 'Mês';
                                            end;
            AGRUPADOR_DIA                 : begin
                                              CdsTemp := cdsDiaSla;
                                              sDescricao := 'Dia';
                                            end;
            AGRUPADOR_SEMANA              : begin
                                              CdsTemp := cdsDiaSmSla;
                                              sDescricao := 'Semana';
                                            end;
            AGRUPADOR_HORA                : begin
                                              CdsTemp := cdsHoraSla;
                                              sDescricao := 'Hora';
                                            end;
            AGRUPADOR_ATENDENTE           : begin
                                              CdsTemp := cdsAtendSla;
                                              sDescricao := 'Atendente';
                                            end;
            AGRUPADOR_GRUPO_ATENDENTE     : begin
                                              CdsTemp := cdsGrAtendSla;
                                              sDescricao := 'Grupo de Atendente';
                                            end;
            AGRUPADOR_PA                  : begin
                                              CdsTemp := cdsPASla;
                                              sDescricao := 'PA';
                                            end;
            AGRUPADOR_GRUPO_PA            : begin
                                              CdsTemp := cdsGrPASla;
                                              sDescricao := 'Grupo de PA';
                                            end;
            AGRUPADOR_FAIXADESENHA        : begin
                                              CdsTemp := cdsFaixaDeSenhaSla;
                                              sDescricao := 'Faixa de Senha';
                                            end;
            AGRUPADOR_TAG                 : begin
                                              CdsTemp := cdsTAGSla;
                                              sDescricao := 'Tag';
                                            end;
            AGRUPADOR_ATENDENTE_FIM       : begin
                                              CdsTemp := cdsAtendFimSla;
                                              sDescricao := 'Atend. Fim';
                                            end;
            AGRUPADOR_GRUPO_ATENDENTE_FIM : begin
                                              CdsTemp := cdsGrAtendFimSla;
                                              sDescricao := 'Grupo de Atend. Fim';
                                              end;
            AGRUPADOR_PA_FIM              : begin
                                              CdsTemp := cdsPAFimSla;
                                              sDescricao := 'PA Fim';
                                            end;
            AGRUPADOR_GRUPO_PA_FIM        : begin
                                              CdsTemp := cdsGrPAFimSla;
                                              sDescricao := 'Grupo de PA Fim';
                                            end;
            AGRUPADOR_PP                  : begin
                                              CdsTemp := cdsPPSla;
                                              sDescricao := 'PP';
                                            end;
            else
            begin
              CdsTemp := nil;
              sDescricao := '';
            end;
          end;
          if(LfrmPesquisaRelatorioPP.vlRepVars.QtdeUnidadesSelecionadas > 1)then
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

                    sCampoQtde := 'PP_QTDE_' + sCor;
                    sCampoPerc := 'PP_PERC_' + sCor;
                    sCampoQtdeTotal := 'PP_QTDE_TOTAL';
                    sCampoQtdeCinza := 'PP_QTDE_CINZA';

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
                  cdsTemp.FieldByName('ID').Value                  := FieldByName('ID').Value;
                  cdsTemp.FieldByName('PP_PERC_VERDE').AsFloat     := Dividir(FieldByName('PP_QTDE_VERDE').AsInteger, FieldByName('PP_QTDE_TOTAL').AsInteger - FieldByName('PP_QTDE_CINZA').AsInteger) * 100;
                  cdsTemp.FieldByName('PP_PERC_AMARELO').AsFloat   := Dividir(FieldByName('PP_QTDE_AMARELO').AsInteger, FieldByName('PP_QTDE_TOTAL').AsInteger - FieldByName('PP_QTDE_CINZA').AsInteger) * 100;
                  cdsTemp.FieldByName('PP_PERC_VERMELHO').AsFloat  := Dividir(FieldByName('PP_QTDE_VERMELHO').AsInteger, FieldByName('PP_QTDE_TOTAL').AsInteger - FieldByName('PP_QTDE_CINZA').AsInteger) * 100;
                  cdsTemp.FieldByName('PP_PERC_CINZA').AsFloat     := Dividir(FieldByName('PP_QTDE_CINZA').AsInteger, FieldByName('PP_QTDE_TOTAL').AsInteger) * 100;
                  cdsTemp.FieldByName('RECNO').AsInteger           := iRecNo;
                  cdsTemp.FieldByName('DESCRICAO').AsString        := GetDescricao(iAgrupador, FieldByName('ID').Value);
                  cdsTemp.FieldByName('IdUnidade').AsInteger       := LIdUnidade;
                  cdsTemp.FieldByName('NomeUnidade').AsString      := NomeUnidade;
                end;

                // nao precisaria destas qtdes abaixo, mas é bom ja guardar caso precise no futuro
                cdsTemp.FieldByName('PP_QTDE_VERDE').AsInteger    := cdsTemp.FieldByName('PP_QTDE_VERDE').AsInteger + FieldByName('PP_QTDE_VERDE').AsInteger;
                cdsTemp.FieldByName('PP_QTDE_AMARELO').AsInteger  := cdsTemp.FieldByName('PP_QTDE_AMARELO').AsInteger + FieldByName('PP_QTDE_AMARELO').AsInteger;
                cdsTemp.FieldByName('PP_QTDE_VERMELHO').AsInteger := cdsTemp.FieldByName('PP_QTDE_VERMELHO').AsInteger + FieldByName('PP_QTDE_VERMELHO').AsInteger;
                cdsTemp.FieldByName('PP_QTDE_CINZA').AsInteger    := cdsTemp.FieldByName('PP_QTDE_CINZA').AsInteger + FieldByName('PP_QTDE_CINZA').AsInteger;
                cdsTemp.FieldByName('PP_QTDE_TOTAL').AsInteger    := cdsTemp.FieldByName('PP_QTDE_TOTAL').AsInteger + FieldByName('PP_QTDE_TOTAL').AsInteger;

                cdsTemp.Post;

                Next;
              end;

              if cdsTemp <> nil then
              begin
                cdsTemp.FieldByName('PP_PERC_VERDE').Visible     := true;
                cdsTemp.FieldByName('PP_PERC_AMARELO').Visible   := true;
                cdsTemp.FieldByName('PP_PERC_VERMELHO').Visible  := true;
                cdsTemp.FieldByName('PP_PERC_CINZA').Visible     := true;

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
            cdsUnidadeSla.FieldByName('PP_PERC_VERDE').AsFloat     := Dividir(FieldByName('PP_QTDE_VERDE').AsInteger, FieldByName('PP_QTDE_TOTAL').AsInteger - FieldByName('PP_QTDE_CINZA').AsInteger) * 100;
            cdsUnidadeSla.FieldByName('PP_PERC_AMARELO').AsFloat   := Dividir(FieldByName('PP_QTDE_AMARELO').AsInteger, FieldByName('PP_QTDE_TOTAL').AsInteger - FieldByName('PP_QTDE_CINZA').AsInteger) * 100;
            cdsUnidadeSla.FieldByName('PP_PERC_VERMELHO').AsFloat  := Dividir(FieldByName('PP_QTDE_VERMELHO').AsInteger, FieldByName('PP_QTDE_TOTAL').AsInteger - FieldByName('PP_QTDE_CINZA').AsInteger) * 100;
            cdsUnidadeSla.FieldByName('PP_PERC_CINZA').AsFloat     := Dividir(FieldByName('PP_QTDE_CINZA').AsInteger, FieldByName('PP_QTDE_TOTAL').AsInteger) * 100;
            cdsUnidadeSla.FieldByName('RECNO').AsInteger            := LIdUnidade + 1;
            // nao precisaria destas qtdes abaixo, mas é bom ja guardar caso precise no futuro
            cdsUnidadeSla.FieldByName('PP_QTDE_VERDE').Value := FieldByName('PP_QTDE_VERDE').Value;
            cdsUnidadeSla.FieldByName('PP_QTDE_AMARELO').Value := FieldByName('PP_QTDE_AMARELO').Value;
            cdsUnidadeSla.FieldByName('PP_QTDE_VERMELHO').Value := FieldByName('PP_QTDE_VERMELHO').Value;
            cdsUnidadeSla.FieldByName('PP_QTDE_CINZA').Value := FieldByName('PP_QTDE_CINZA').Value;
            cdsUnidadeSla.FieldByName('PP_QTDE_TOTAL').Value := FieldByName('PP_QTDE_TOTAL').Value;
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
    end;

    LfrmPesquisaRelatorioPP.cdsUnidades.Next;
  end;
  AtualizarColunasGrid;

end;

procedure TfrmGraphicsPP.chkSlaCinzaChange(Sender: TObject);
begin
  inherited;
  BarSeries33.Active := chkSlaCinza.IsChecked;
end;


procedure TfrmGraphicsPP.ajustaTipoDBChart;
begin
  if (QtdChartTypeCombo.ItemIndex = -1) then
    QtdChartTypeCombo.ItemIndex := 0;
end;

procedure TfrmGraphicsPP.dbChartSlaMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Single);
begin
  inherited;
  //
end;

procedure TfrmGraphicsPP.DefineCorChart;
begin
  BarSeries31.SeriesColor := TAlphaColor(RGBtoBGR($00FF00) or $FF000000);
  BarSeries32.SeriesColor := TAlphaColor(RGBtoBGR($0000FF) or $FF000000);
  BarSeries33.SeriesColor := TAlphaColor(RGBtoBGR($0000FF) or $FF000000);
  Series7.SeriesColor := claSilver;
  PieSeries1.SeriesColor := claRed;

  BarSeries13.SeriesColor:= claLime;
  LineSeries6.SeriesColor := claBlue;
  Series1.SeriesColor := claBlue;
end;

destructor TfrmGraphicsPP.Destroy;
begin


  cdsMes         .Close;
  cdsDia         .Close;
  cdsDiaSm       .Close;
  cdsHora        .Close;
  cdsAtend       .Close;
  cdsPA          .Close;
  cdsFaixaDeSenha.Close;
  cdsGrAtend     .Close;
  cdsGrPA        .Close;
  cdsTag         .Close;
  cdsUnidade     .Close;
  cdsAtendFim    .Close;
  cdsPAFim       .Close;
  cdsGrAtendFim  .Close;
  cdsGrPAFim     .Close;
  cdsPP          .Close; //LBCx



  inherited;
end;

procedure TfrmGraphicsPP.PageControlGridsChange(Sender: TObject);

  procedure ConfiguraChart(const aDS: TClientDataSet; const aFieldSource: String; aFieldLabel: String = '';
    const aLabelsAngle: Integer= 0);
  begin
    ConfiguraDBChart(PieSeries1, dbChart, aDS, aFieldSource, aFieldLabel, aLabelsAngle);
  end;

  procedure ConfiguraGraficoSla;
  var
    DS    : TClientDataSet;
    iSerie: Integer;
  begin
    pnlChart.Visible := False;
    pnlChartSla.Visible := True;
    case PageControlGrids.TabIndex of
       0 : ds := cdsMesSla;
       1 : ds := cdsDiaSla;
       2 : ds := cdsDiaSmSla;
       3 : ds := cdsHoraSla;
       4 : ds := cdsPPSla;
       5 : ds := cdsAtendSla;
       6 : ds := cdsAtendFimSla;
       7 : ds := cdsGrAtendSla;
       8 : ds := cdsGrAtendFimSla;
       9 : ds := cdsPASla;
      10 : ds := cdsPAFimSla;
      11 : ds := cdsGrPASla;
      12 : ds := cdsGrPAFimSla;
      13 : ds := cdsFaixaDeSenhaSla;
      14 : ds := cdsTagSla;
      15 : ds := cdsUnidadeSla;
    else
      ds :=  nil;
    end;
    for iSerie := 0 to  dbChartSla.SeriesList.Count - 1 do
       dbChartSla.Series[iSerie].DataSource := ds;
    if PageControlGrids.TabIndex > 3 then
       dbChartSla.BottomAxis.LabelsAngle := 90
    else
       dbChartSla.BottomAxis.LabelsAngle := 0;
  end;
begin
  if not Self.Visible then
    Exit;
  if FGraficoSla then
    ConfiguraGraficoSla
  else
  begin
    pnlChart.Visible := True;
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
            ConfiguraChart(cdsPP, 'PPRecNo', 'PPNome', 90);
          end;
      5 : begin
            ConfiguraChart(cdsAtend, 'AtdRecNo', 'AtdNome', 90);
          end;
      6 : begin
            ConfiguraChart(cdsAtendFim, 'AtdRecNo', 'AtdNome', 90);
          end;
      7 : begin
            ConfiguraChart(cdsGrAtend, 'GrAtendRecNo', 'GrAtendNome', 90);
          end;
      8 : begin
            ConfiguraChart(cdsGrAtendFim, 'GrAtendRecNo', 'GrAtendNome', 90);
          end;
      9 : begin
            ConfiguraChart(cdsPA, 'PARecNo', 'PANome', 90);
          end;
     10 : begin
            ConfiguraChart(cdsPAFim, 'PARecNo', 'PANome', 90);
          end;
     11 : begin
            ConfiguraChart(cdsGrPA, 'GrPARecNo', 'GrPANome', 90);
          end;
     12 : begin
            ConfiguraChart(cdsGrPAFim, 'GrPARecNo', 'GrPANome', 90);
          end;
     13 : begin
            ConfiguraChart(cdsFaixaDeSenha, 'FaixaDeSenhaRecNo', 'FaixaDeSenhaNome', 90);
          end;
     14 : begin
            ConfiguraChart(cdsTag, 'TAGRecNo', 'TAGNome', 90);
          end;
     15 : begin
            ConfiguraChart(cdsUnidade, 'UnidadeRecNo', 'UnidadeNome', 90);
          end;
    end; // case
  end;

  TMPPCheckBox.IsChecked := (PageControlGrids.ActiveTab <> tbsAtendentes) and (PageControlGrids.ActiveTab <> tbsPA);
  AtualizarColunasGrid;
end;

procedure TfrmGraphicsPP.PrepararLkpsUnidades;
var
  LfrmPesquisaRelatorioPP: TfrmPesquisaRelatorioPP;

  procedure CopiarNestedDataSet(const AFieldName: string; ADataSetLkp: TClientDataSet);
  var
    LNestedDataSet: TClientDataSet;
  begin
    LNestedDataSet := TClientDataSet.Create(nil);
    try
      LNestedDataSet.DataSetField := TDataSetField(LfrmPesquisaRelatorioPP.cdsUnidades.FieldByName(AFieldName));

      if ADataSetLkp.Active then
        ADataSetLkp.EmptyDataSet
      else
        ADataSetLkp.CreateDataSet;

      LNestedDataSet.First;
      while not LNestedDataSet.eof do
      begin
        ADataSetLkp.Append;
        ADataSetLkp.FieldByName('ID'  ).Value := LNestedDataSet.FieldByName('ID'  ).Value;
        ADataSetLkp.FieldByName('NOME').Value := LNestedDataSet.FieldByName('NOME').Value;
        ADataSetLkp.Post;
        LNestedDataSet.Next;
      end;
    finally
      FreeAndNil(LNestedDataSet);
    end;
  end;


begin
  LfrmPesquisaRelatorioPP := (Owner as TfrmPesquisaRelatorioPP);
   CopiarNestedDataSet('ATENDENTES'       , cdsLkpAtendentes       );
   CopiarNestedDataSet('PAS'              , cdsLkpPAS              );
   CopiarNestedDataSet('FILAS'            , cdsLkpFaixaDeSenhas    );
   CopiarNestedDataSet('TAGS'             , cdsLkpTAGS             );
   CopiarNestedDataSet('GRUPOS_ATENDENTES', cdsLkpGruposAtendentes );
   CopiarNestedDataSet('GRUPOS_PAS'       , cdsLkpGruposPAS        );
   CopiarNestedDataSet('PPS'              , cdsLkpPPs              );
end;

procedure TfrmGraphicsPP.cdsMesAfterOpen(DataSet: TDataSet);
begin
  with DataSet do
  begin
    FieldByName('MaxPP').Visible := vgParametrosModulo.ReportarTemposMaximos;
  end;
end;

procedure TfrmGraphicsPP.cdsTagTagNomeGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := 'Não classificado'
  else
    Text := Sender.AsString;
end;

procedure TfrmGraphicsPP.StringField20GetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if Sender.AsString = '' then
    Text := 'Não classificado'
  else
    Text := Sender.AsString;
end;

procedure TfrmGraphicsPP.cdsFilaEsperaFilaEsperaNomeGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := '(nenhuma)'
  else
    Text := Sender.AsString;
end;

procedure TfrmGraphicsPP.StringField22GetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if Sender.AsString = '' then
    Text := '(nenhuma)'
  else
    Text := Sender.AsString;
end;

procedure TfrmGraphicsPP.cdsAtendFimCalcFields(DataSet: TDataSet);
begin
  cdsAtendFimAtdRecNo.AsInteger := cdsAtendFim.RecNo;
end;

procedure TfrmGraphicsPP.cdsGrAtendFimCalcFields(DataSet: TDataSet);
begin
  cdsGrAtendFimGrAtendRecNo.AsInteger := cdsGrAtendFim.RecNo;
end;

procedure TfrmGraphicsPP.cdsPAFimCalcFields(DataSet: TDataSet);
begin
  cdsPAFimPARecNo.AsInteger := cdsPAFim.RecNo;
end;

procedure TfrmGraphicsPP.cdsGrPAFimCalcFields(DataSet: TDataSet);
begin
  cdsGrPAFimGrPARecNo.AsInteger := cdsGrPAFim.RecNo;
end;

procedure TfrmGraphicsPP.PreencheNDOnField (Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if Sender.AsString = '' then
    Text := '(nenhum)'
  else
    Text := Sender.AsString;
end;

end.
