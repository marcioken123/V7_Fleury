unit ufrmGraphics;
//Renomeado unit sics_96;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  {$IFNDEF IS_MOBILE}
  Windows, Messages, ScktComp, ExcelXP, Vcl.OleServer,
  {$ENDIF IS_MOBILE}

  ufrmPesquisaRelatorioBase, untMainForm, FMX.Grid, FMX.Controls, FMX.Forms,
  FMX.Graphics, FMX.Dialogs, FMX.StdCtrls, FMX.ExtCtrls, FMX.Types, FMX.Layouts,
  FMX.ListView.Types, FMX.ListView, FMX.ListBox, System.DateUtils,
  Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors,
  FMX.Objects, FMX.Edit, FMX.TabControl, System.UIConsts,
  System.Generics.Defaults, System.Generics.Collections, System.UITypes,
  System.Types, System.SysUtils, System.Classes, System.Variants, Data.DB,
  Datasnap.DBClient, System.Rtti, Data.Bind.EngExt, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope, Math, MyAspFuncoesUteis, System.IniFiles, Data.FMTBcd, Datasnap.Provider, System.Actions, FMX.ActnList,
  FMX.Menus, FMXTee.Series, FMXTee.Chart, ufrmGraphicsBase,
  FMX.Controls.Presentation, FMX.ComboEdit, FMXTee.Engine, FMXTee.Procs,
  FMXTee.DBChart,Vcl.Clipbrd, System.ImageList, FMX.ImgList, FMX.Effects,
  FMX.Grid.Style, FMX.ScrollBox,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.DBX.Migrate, uDataSetHelper;

type
  TParamsSla = record
    EspAmarelo: Integer;
    EspVermelho: Integer;
    AtdAmarelo: Integer;
    AtdVermelho: Integer;
  end;

  TfrmSicsGraphics = class(TfrmGraphicsBase)
     MesDS: TDataSource;
    DiaSmDS: TDataSource;
    DiaDS: TDataSource;
    HoraDS: TDataSource;
    AtendDS: TDataSource;
    PADS: TDataSource;
    GrAtendDS: TDataSource;
    GrPADS: TDataSource;
    cdsMes: TClientDataSet;
    cdsMesMes: TIntegerField;
    cdsMesMesStr: TStringField;
    cdsMesQtdE: TIntegerField;
    cdsMesTME: TDateTimeField;
    cdsMesQtdA: TIntegerField;
    cdsMesTMA: TDateTimeField;
    cdsMesMaxTE: TDateTimeField;
    cdsMesMaxTA: TDateTimeField;
    qryMes: TFDQuery;
    dspMes: TDataSetProvider;
    cdsPA: TClientDataSet;
    cdsPAPA: TIntegerField;
    cdsPAPARecNo: TIntegerField;
    cdsPAPANome: TStringField;
    cdsPAQtdE: TIntegerField;
    cdsPATME: TDateTimeField;
    cdsPAQtdA: TIntegerField;
    cdsPATMA: TDateTimeField;
    cdsPAMaxTA: TDateTimeField;
    cdsPAMaxTE: TDateTimeField;
    cdsHora: TClientDataSet;
    cdsHoraHora: TIntegerField;
    cdsHoraQtdE: TIntegerField;
    cdsHoraTME: TDateTimeField;
    cdsHoraQtdA: TIntegerField;
    cdsHoraTMA: TDateTimeField;
    cdsHoraMaxTA: TDateTimeField;
    cdsHoraMaxTE: TDateTimeField;
    cdsAtend: TClientDataSet;
    cdsAtendAtend: TIntegerField;
    cdsAtendAtdRecNo: TIntegerField;
    cdsAtendAtdNome: TStringField;
    cdsAtendQtdE: TIntegerField;
    cdsAtendTME: TDateTimeField;
    cdsAtendQtdA: TIntegerField;
    cdsAtendTMA: TDateTimeField;
    cdsAtendMaxTA: TDateTimeField;
    cdsAtendMaxTE: TDateTimeField;
    cdsGrAtend: TClientDataSet;
    cdsGrAtendGrAtend: TIntegerField;
    cdsGrAtendGrAtendRecNo: TSmallintField;
    cdsGrAtendGrAtendNome: TStringField;
    cdsGrAtendQtdE: TIntegerField;
    cdsGrAtendTME: TDateTimeField;
    cdsGrAtendQtdA: TIntegerField;
    cdsGrAtendTMA: TDateTimeField;
    cdsGrAtendMaxTA: TDateTimeField;
    cdsGrAtendMaxTE: TDateTimeField;
    cdsGrPA: TClientDataSet;
    cdsGrPAGrPA: TIntegerField;
    cdsGrPAGrPARecNo: TSmallintField;
    cdsGrPAGrPANome: TStringField;
    cdsGrPAQtdE: TIntegerField;
    cdsGrPATME: TDateTimeField;
    cdsGrPAQtdA: TIntegerField;
    cdsGrPATMA: TDateTimeField;
    cdsGrPAMaxTA: TDateTimeField;
    cdsGrPAMaxTE: TDateTimeField;
    cdsDia: TClientDataSet;
    cdsDiaDia: TIntegerField;
    cdsDiaQtdE: TIntegerField;
    cdsDiaTME: TDateTimeField;
    cdsDiaQtdA: TIntegerField;
    cdsDiaTMA: TDateTimeField;
    cdsDiaMaxTA: TDateTimeField;
    cdsDiaMaxTE: TDateTimeField;

    cdsDiaSm: TClientDataSet;
    cdsDiaSmDiaSm: TIntegerField;
    cdsDiaSmDiaSmStr: TStringField;
    cdsDiaSmQtdE: TIntegerField;
    cdsDiaSmTME: TDateTimeField;
    cdsDiaSmQtdA: TIntegerField;
    cdsDiaSmTMA: TDateTimeField;
    cdsDiaSmMaxTA: TDateTimeField;
    cdsDiaSmMaxTE: TDateTimeField;
    cdsMesTestes: TClientDataSet;
    SmallintField1: TSmallintField;
    StringField1: TStringField;
    IntegerField1: TIntegerField;
    IntegerField2: TIntegerField;
    cdsMesTestesTME_MSECS: TFMTBCDField;
    cdsMesTestesTMA_MSECS: TFMTBCDField;
    cdsMesTestesTME: TDateTimeField;
    cdsMesTestesTMA: TDateTimeField;
    UnidadeDS: TDataSource;
    cdsUnidade: TClientDataSet;
    cdsUnidadeUnidade: TIntegerField;
    cdsUnidadeUnidadeRecNo: TIntegerField;
    cdsUnidadeUnidadeNome: TStringField;
    cdsUnidadeQtdE: TIntegerField;
    cdsUnidadeTME: TDateTimeField;
    cdsUnidadeQtdA: TIntegerField;
    cdsUnidadeTMA: TDateTimeField;
    cdsUnidadeMaxTA: TDateTimeField;
    cdsUnidadeMaxTE: TDateTimeField;
    cdsTag: TClientDataSet;
    cdsTagTag: TIntegerField;
    cdsTagTagRecNo: TIntegerField;
    cdsTagTagNome: TStringField;
    cdsTagQtdE: TIntegerField;
    cdsTagTME: TDateTimeField;
    cdsTagQtdA: TIntegerField;
    cdsTagTMA: TDateTimeField;
    cdsTagMaxTA: TDateTimeField;
    cdsTagMaxTE: TDateTimeField;
    TagDS: TDataSource;
    dspEstatisticas: TDataSetProvider;
    cdsEstatisticas: TClientDataSet;
    cdsDiaSmSla: TClientDataSet;
    cdsDiaSmSlaID: TIntegerField;
    cdsDiaSmSlaDESCRICAO: TStringField;
    cdsDiaSmSlaESP_PERC_VERDE: TFloatField;
    cdsDiaSmSlaESP_PERC_AMARELO: TFloatField;
    cdsDiaSmSlaESP_PERC_VERMELHO: TFloatField;
    cdsDiaSmSlaESP_PERC_CINZA: TFloatField;
    cdsDiaSmSlaATD_PERC_VERDE: TFloatField;
    cdsDiaSmSlaATD_PERC_AMARELO: TFloatField;
    cdsDiaSmSlaATD_PERC_VERMELHO: TFloatField;
    cdsDiaSmSlaATD_PERC_CINZA: TFloatField;
    cdsDiaSmSlaRECNO: TIntegerField;
    cdsDiaSmSlaTIPO_ATD_ESP_DCR: TStringField;
    cdsDiaSmSlaATD_QTDE_CINZA: TIntegerField;
    cdsDiaSmSlaATD_QTDE_VERMELHO: TIntegerField;
    cdsDiaSmSlaATD_QTDE_AMARELO: TIntegerField;
    cdsDiaSmSlaATD_QTDE_VERDE: TIntegerField;
    cdsDiaSmSlaESP_QTDE_CINZA: TIntegerField;
    cdsDiaSmSlaESP_QTDE_VERMELHO: TIntegerField;
    cdsDiaSmSlaESP_QTDE_AMARELO: TIntegerField;
    cdsDiaSmSlaESP_QTDE_VERDE: TIntegerField;
    cdsDiaSmSlaATD_QTDE_TOTAL: TIntegerField;
    cdsDiaSmSlaESP_QTDE_TOTAL: TIntegerField;
    dspEstatisticasSla: TDataSetProvider;
    dtsDiaSmSla: TDataSource;
    cdsEstatisticasSla: TClientDataSet;
    dtsDiaSla: TDataSource;
    cdsDiaSla: TClientDataSet;
    IntegerField3: TIntegerField;
    StringField2: TStringField;
    FloatField1: TFloatField;
    FloatField2: TFloatField;
    FloatField3: TFloatField;
    FloatField4: TFloatField;
    FloatField5: TFloatField;
    FloatField6: TFloatField;
    FloatField7: TFloatField;
    FloatField8: TFloatField;
    IntegerField4: TIntegerField;
    StringField3: TStringField;
    cdsDiaSlaATD_QTDE_CINZA: TIntegerField;
    cdsDiaSlaATD_QTDE_VERMELHO: TIntegerField;
    cdsDiaSlaATD_QTDE_AMARELO: TIntegerField;
    cdsDiaSlaATD_QTDE_VERDE: TIntegerField;
    cdsDiaSlaESP_QTDE_CINZA: TIntegerField;
    cdsDiaSlaESP_QTDE_VERMELHO: TIntegerField;
    cdsDiaSlaESP_QTDE_AMARELO: TIntegerField;
    cdsDiaSlaESP_QTDE_VERDE: TIntegerField;
    cdsDiaSlaATD_QTDE_TOTAL: TIntegerField;
    cdsDiaSlaESP_QTDE_TOTAL: TIntegerField;
    dtsMesSla: TDataSource;
    cdsMesSla: TClientDataSet;
    IntegerField5: TIntegerField;
    StringField4: TStringField;
    FloatField9: TFloatField;
    FloatField10: TFloatField;
    FloatField11: TFloatField;
    FloatField12: TFloatField;
    FloatField13: TFloatField;
    FloatField14: TFloatField;
    FloatField15: TFloatField;
    FloatField16: TFloatField;
    IntegerField6: TIntegerField;
    StringField5: TStringField;
    cdsMesSlaATD_QTDE_CINZA: TIntegerField;
    cdsMesSlaATD_QTDE_VERMELHO: TIntegerField;
    cdsMesSlaATD_QTDE_AMARELO: TIntegerField;
    cdsMesSlaATD_QTDE_VERDE: TIntegerField;
    cdsMesSlaESP_QTDE_CINZA: TIntegerField;
    cdsMesSlaESP_QTDE_VERMELHO: TIntegerField;
    cdsMesSlaESP_QTDE_AMARELO: TIntegerField;
    cdsMesSlaESP_QTDE_VERDE: TIntegerField;
    cdsMesSlaESP_QTDE_TOTAL: TIntegerField;
    cdsMesSlaATD_QTDE_TOTAL: TIntegerField;
    dtsHoraSla: TDataSource;
    cdsHoraSla: TClientDataSet;
    IntegerField7: TIntegerField;
    StringField6: TStringField;
    FloatField17: TFloatField;
    FloatField18: TFloatField;
    FloatField19: TFloatField;
    FloatField20: TFloatField;
    FloatField21: TFloatField;
    FloatField22: TFloatField;
    FloatField23: TFloatField;
    FloatField24: TFloatField;
    IntegerField8: TIntegerField;
    StringField7: TStringField;
    cdsHoraSlaATD_QTDE_CINZA: TIntegerField;
    cdsHoraSlaATD_QTDE_VERMELHO: TIntegerField;
    cdsHoraSlaATD_QTDE_AMARELO: TIntegerField;
    cdsHoraSlaATD_QTDE_VERDE: TIntegerField;
    cdsHoraSlaESP_QTDE_CINZA: TIntegerField;
    cdsHoraSlaESP_QTDE_VERMELHO: TIntegerField;
    cdsHoraSlaESP_QTDE_AMARELO: TIntegerField;
    cdsHoraSlaESP_QTDE_VERDE: TIntegerField;
    cdsHoraSlaATD_QTDE_TOTAL: TIntegerField;
    cdsHoraSlaESP_QTDE_TOTAL: TIntegerField;
    dtsAtendSla: TDataSource;
    cdsAtendSla: TClientDataSet;
    IntegerField9: TIntegerField;
    StringField8: TStringField;
    FloatField25: TFloatField;
    FloatField26: TFloatField;
    FloatField27: TFloatField;
    FloatField28: TFloatField;
    FloatField29: TFloatField;
    FloatField30: TFloatField;
    FloatField31: TFloatField;
    FloatField32: TFloatField;
    IntegerField10: TIntegerField;
    StringField9: TStringField;
    cdsAtendSlaATD_QTDE_CINZA: TIntegerField;
    cdsAtendSlaATD_QTDE_VERMELHO: TIntegerField;
    cdsAtendSlaATD_QTDE_AMARELO: TIntegerField;
    cdsAtendSlaATD_QTDE_VERDE: TIntegerField;
    cdsAtendSlaESP_QTDE_CINZA: TIntegerField;
    cdsAtendSlaESP_QTDE_VERMELHO: TIntegerField;
    cdsAtendSlaESP_QTDE_AMARELO: TIntegerField;
    cdsAtendSlaESP_QTDE_VERDE: TIntegerField;
    cdsAtendSlaATD_QTDE_TOTAL: TIntegerField;
    cdsAtendSlaESP_QTDE_TOTAL: TIntegerField;
    dtsGrAtendSla: TDataSource;
    cdsGrAtendSla: TClientDataSet;
    IntegerField11: TIntegerField;
    StringField10: TStringField;
    FloatField33: TFloatField;
    FloatField34: TFloatField;
    FloatField35: TFloatField;
    FloatField36: TFloatField;
    FloatField37: TFloatField;
    FloatField38: TFloatField;
    FloatField39: TFloatField;
    FloatField40: TFloatField;
    IntegerField12: TIntegerField;
    StringField11: TStringField;
    cdsGrAtendSlaATD_QTDE_CINZA: TIntegerField;
    cdsGrAtendSlaATD_QTDE_VERMELHO: TIntegerField;
    cdsGrAtendSlaATD_QTDE_AMARELO: TIntegerField;
    cdsGrAtendSlaATD_QTDE_VERDE: TIntegerField;
    cdsGrAtendSlaESP_QTDE_CINZA: TIntegerField;
    cdsGrAtendSlaESP_QTDE_VERMELHO: TIntegerField;
    cdsGrAtendSlaESP_QTDE_AMARELO: TIntegerField;
    cdsGrAtendSlaESP_QTDE_VERDE: TIntegerField;
    cdsGrAtendSlaATD_QTDE_TOTAL: TIntegerField;
    cdsGrAtendSlaESP_QTDE_TOTAL: TIntegerField;
    cdsPASla: TClientDataSet;
    IntegerField13: TIntegerField;
    StringField12: TStringField;
    FloatField41: TFloatField;
    FloatField42: TFloatField;
    FloatField43: TFloatField;
    FloatField44: TFloatField;
    FloatField45: TFloatField;
    FloatField46: TFloatField;
    FloatField47: TFloatField;
    FloatField48: TFloatField;
    IntegerField14: TIntegerField;
    StringField13: TStringField;
    cdsPASlaATD_QTDE_CINZA: TIntegerField;
    cdsPASlaATD_QTDE_VERMELHO: TIntegerField;
    cdsPASlaATD_QTDE_AMARELO: TIntegerField;
    cdsPASlaATD_QTDE_VERDE: TIntegerField;
    cdsPASlaESP_QTDE_CINZA: TIntegerField;
    cdsPASlaESP_QTDE_VERMELHO: TIntegerField;
    cdsPASlaESP_QTDE_AMARELO: TIntegerField;
    cdsPASlaESP_QTDE_VERDE: TIntegerField;
    cdsPASlaESP_QTDE_TOTAL: TIntegerField;
    cdsPASlaATD_QTDE_TOTAL: TIntegerField;
    dtsPASla: TDataSource;
    cdsGrPASla: TClientDataSet;
    IntegerField15: TIntegerField;
    StringField14: TStringField;
    FloatField49: TFloatField;
    FloatField50: TFloatField;
    FloatField51: TFloatField;
    FloatField52: TFloatField;
    FloatField53: TFloatField;
    FloatField54: TFloatField;
    FloatField55: TFloatField;
    FloatField56: TFloatField;
    IntegerField16: TIntegerField;
    StringField15: TStringField;
    cdsGrPASlaATD_QTDE_CINZA: TIntegerField;
    cdsGrPASlaATD_QTDE_VERMELHO: TIntegerField;
    cdsGrPASlaATD_QTDE_AMARELO: TIntegerField;
    cdsGrPASlaATD_QTDE_VERDE: TIntegerField;
    cdsGrPASlaESP_QTDE_CINZA: TIntegerField;
    cdsGrPASlaESP_QTDE_VERMELHO: TIntegerField;
    cdsGrPASlaESP_QTDE_AMARELO: TIntegerField;
    cdsGrPASlaESP_QTDE_VERDE: TIntegerField;
    cdsGrPASlaESP_QTDE_TOTAL: TIntegerField;
    cdsGrPASlaATD_QTDE_TOTAL: TIntegerField;
    dtsGrPASla: TDataSource;
    cdsUnidadeSla: TClientDataSet;
    IntegerField19: TIntegerField;
    StringField18: TStringField;
    FloatField65: TFloatField;
    FloatField66: TFloatField;
    FloatField67: TFloatField;
    FloatField68: TFloatField;
    FloatField69: TFloatField;
    FloatField70: TFloatField;
    FloatField71: TFloatField;
    FloatField72: TFloatField;
    IntegerField20: TIntegerField;
    StringField19: TStringField;
    cdsUnidadeSlaATD_QTDE_CINZA: TIntegerField;
    cdsUnidadeSlaATD_QTDE_VERMELHO: TIntegerField;
    cdsUnidadeSlaATD_QTDE_AMARELO: TIntegerField;
    cdsUnidadeSlaATD_QTDE_VERDE: TIntegerField;
    cdsUnidadeSlaESP_QTDE_CINZA: TIntegerField;
    cdsUnidadeSlaESP_QTDE_VERMELHO: TIntegerField;
    cdsUnidadeSlaESP_QTDE_AMARELO: TIntegerField;
    cdsUnidadeSlaESP_QTDE_VERDE: TIntegerField;
    cdsUnidadeSlaESP_QTDE_TOTAL: TIntegerField;
    cdsUnidadeSlaATD_QTDE_TOTAL: TIntegerField;
    dtsUnidadeSla: TDataSource;
    cdsTagSla: TClientDataSet;
    IntegerField21: TIntegerField;
    StringField20: TStringField;
    FloatField73: TFloatField;
    FloatField74: TFloatField;
    FloatField75: TFloatField;
    FloatField76: TFloatField;
    FloatField77: TFloatField;
    FloatField78: TFloatField;
    FloatField79: TFloatField;
    FloatField80: TFloatField;
    IntegerField22: TIntegerField;
    StringField21: TStringField;
    cdsTagSlaATD_QTDE_CINZA: TIntegerField;
    cdsTagSlaATD_QTDE_VERMELHO: TIntegerField;
    cdsTagSlaATD_QTDE_AMARELO: TIntegerField;
    cdsTagSlaATD_QTDE_VERDE: TIntegerField;
    cdsTagSlaESP_QTDE_CINZA: TIntegerField;
    cdsTagSlaESP_QTDE_VERMELHO: TIntegerField;
    cdsTagSlaESP_QTDE_AMARELO: TIntegerField;
    cdsTagSlaESP_QTDE_VERDE: TIntegerField;
    cdsTagSlaESP_QTDE_TOTAL: TIntegerField;
    cdsTagSlaATD_QTDE_TOTAL: TIntegerField;
    dtsTagSla: TDataSource;
    cdsLkpAtendentes: TClientDataSet;
    cdsLkpAtendentesID: TIntegerField;
    cdsLkpAtendentesNOME: TStringField;
    cdsLkpGruposAtendentes: TClientDataSet;
    cdsLkpGruposAtendentesID: TIntegerField;
    cdsLkpGruposAtendentesNOME: TStringField;
    cdsLkpFaixaDeSenhas: TClientDataSet;
    cdsLkpFaixaDeSenhasID: TIntegerField;
    cdsLkpFaixaDeSenhasNOME: TStringField;
    cdsLkpPAS: TClientDataSet;
    cdsLkpPASID: TIntegerField;
    cdsLkpPASNOME: TStringField;
    cdsLkpGruposPAs: TClientDataSet;
    cdsLkpGruposPAsID: TIntegerField;
    cdsLkpGruposPAsNOME: TStringField;
    cdsLkpTags: TClientDataSet;
    cdsLkpTagsID: TIntegerField;
    cdsLkpTagsNOME: TStringField;
    dtsFaixaDeSenhaSla: TDataSource;
    FaixaDeSenhaDS: TDataSource;
    cdsFaixaDeSenha: TClientDataSet;
    cdsFaixaDeSenhaFaixaDeSenha: TIntegerField;
    cdsFaixaDeSenhaFaixaDeSenhaRecNo: TIntegerField;
    cdsFaixaDeSenhaFaixaDeSenhaNome: TStringField;
    cdsFaixaDeSenhaQtdE: TIntegerField;
    cdsFaixaDeSenhaTME: TDateTimeField;
    cdsFaixaDeSenhaQtdA: TIntegerField;
    cdsFaixaDeSenhaTMA: TDateTimeField;
    cdsFaixaDeSenhaMaxTA: TDateTimeField;
    cdsFaixaDeSenhaMaxTE: TDateTimeField;
    cdsFaixaDeSenhaSla: TClientDataSet;
    IntegerField17: TIntegerField;
    StringField16: TStringField;
    FloatField57: TFloatField;
    FloatField58: TFloatField;
    FloatField59: TFloatField;
    FloatField60: TFloatField;
    FloatField61: TFloatField;
    FloatField62: TFloatField;
    FloatField63: TFloatField;
    FloatField64: TFloatField;
    IntegerField18: TIntegerField;
    StringField17: TStringField;
    cdsFaixaDeSenhaSlaATD_QTDE_CINZA: TIntegerField;
    cdsFaixaDeSenhaSlaATD_QTDE_VERMELHO: TIntegerField;
    cdsFaixaDeSenhaSlaATD_QTDE_AMARELO: TIntegerField;
    cdsFaixaDeSenhaSlaATD_QTDE_VERDE: TIntegerField;
    cdsFaixaDeSenhaSlaESP_QTDE_CINZA: TIntegerField;
    cdsFaixaDeSenhaSlaESP_QTDE_VERMELHO: TIntegerField;
    cdsFaixaDeSenhaSlaESP_QTDE_AMARELO: TIntegerField;
    cdsFaixaDeSenhaSlaESP_QTDE_VERDE: TIntegerField;
    cdsFaixaDeSenhaSlaESP_QTDE_TOTAL: TIntegerField;
    cdsFaixaDeSenhaSlaATD_QTDE_TOTAL: TIntegerField;
    cdsFilaEspera: TClientDataSet;
    cdsFilaEsperaFilaEspera: TIntegerField;
    cdsFilaEsperaFilaEsperaRecNo: TIntegerField;
    cdsFilaEsperaFilaEsperaNome: TStringField;
    cdsFilaEsperaQtdE: TIntegerField;
    cdsFilaEsperaTME: TDateTimeField;
    cdsFilaEsperaQtdA: TIntegerField;
    cdsFilaEsperaTMA: TDateTimeField;
    cdsFilaEsperaMaxTA: TDateTimeField;
    cdsFilaEsperaMaxTE: TDateTimeField;
    FilaEsperaDS: TDataSource;
    cdsFilaEsperaSla: TClientDataSet;
    IntegerField23: TIntegerField;
    StringField22: TStringField;
    FloatField81: TFloatField;
    FloatField82: TFloatField;
    FloatField83: TFloatField;
    FloatField84: TFloatField;
    FloatField85: TFloatField;
    FloatField86: TFloatField;
    FloatField87: TFloatField;
    FloatField88: TFloatField;
    IntegerField24: TIntegerField;
    StringField23: TStringField;
    cdsFilaEsperaSlaATD_QTDE_CINZA: TIntegerField;
    cdsFilaEsperaSlaATD_QTDE_VERMELHO: TIntegerField;
    cdsFilaEsperaSlaATD_QTDE_AMARELO: TIntegerField;
    cdsFilaEsperaSlaATD_QTDE_VERDE: TIntegerField;
    cdsFilaEsperaSlaESP_QTDE_CINZA: TIntegerField;
    cdsFilaEsperaSlaESP_QTDE_VERMELHO: TIntegerField;
    cdsFilaEsperaSlaESP_QTDE_AMARELO: TIntegerField;
    cdsFilaEsperaSlaESP_QTDE_VERDE: TIntegerField;
    cdsFilaEsperaSlaESP_QTDE_TOTAL: TIntegerField;
    cdsFilaEsperaSlaATD_QTDE_TOTAL: TIntegerField;
    dtsFilaEsperaSla: TDataSource;
    pnlChartSla: TPanel;
    lblUnidades: TLabel;
    lblTags: TLabel;
    lblFaixaSenhas: TLabel;
    lblPas: TLabel;
    lblAtendente: TLabel;
    lblSenha: TLabel;
    lblDuracao: TLabel;
    lblPeriodoDia: TLabel;
    lblPeriodo: TLabel;
    PeriododoRelatorioLabel: TLabel;
    PeriododoDiaLabel: TLabel;
    DuracaoLabel: TLabel;
    SenhasLabel: TLabel;
    AtendentesLabel: TLabel;
    PAsLabel: TLabel;
    FaixaDeSenhaLabel: TLabel;
    TagsLabel: TLabel;
    lblUnidadesVal: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    lblQtdAtdLabel: TLabel;
    TMALabel: TLabel;
    QtdAtdLabel: TLabel;
    TMELabel: TLabel;
    lblTMALabel: TLabel;
    QtdEspLabel: TLabel;
    Label18: TLabel;
    Label16: TLabel;
    Label15: TLabel;
    Label14: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    chkSlaCinza: TCheckBox;
    chkSlaEspera: TCheckBox;
    chkSlaAtendimento: TCheckBox;
    QtdCheckBox: TCheckBox;
    TMECheckBox: TCheckBox;
    TMACheckBox: TCheckBox;
    cboChartType: TComboBox;
    QtdEspAtdCombo: TComboBox;
    pnlGraficosTmeTma: TPanel;
    Panel3: TPanel;
    Label17: TLabel;
    lblParamsSLAAtdVermelho: TLabel;
    lblParamsSLAAtdAmarelo: TLabel;
    lblParamsSLAAtdVerde: TLabel;
    Shape6: TShape;
    Label13: TLabel;
    lblParamsSLAEspVermelho: TLabel;
    lblParamsSLAEspAmarelo: TLabel;
    lblParamsSLAEspVerde: TLabel;
    Shape1: TShape;
    Shape5: TShape;
    Shape4: TShape;
    Shape3: TShape;
    Shape2: TShape;
    LinkGridMES: TLinkGridToDataSource;
    LinkGridDIA: TLinkGridToDataSource;
    LinkGridDiaSM: TLinkGridToDataSource;
    LinkGridHora: TLinkGridToDataSource;
    LinkGridAtend: TLinkGridToDataSource;
    LinkGridGrAtend: TLinkGridToDataSource;
    LinkGridPA: TLinkGridToDataSource;
    LinkGridGrPa: TLinkGridToDataSource;
    LinkGridFilaEspera: TLinkGridToDataSource;
    LinkGridFaixaDeSenha: TLinkGridToDataSource;
    LinkGridTag: TLinkGridToDataSource;
    LinkGridUnidade: TLinkGridToDataSource;

    bndMES: TBindSourceDB;
    bndDia: TBindSourceDB;
    bndDiaSM: TBindSourceDB;
    bndHora: TBindSourceDB;
    bndAtend: TBindSourceDB;
    bndGrAtend: TBindSourceDB;
    bndPA: TBindSourceDB;
    bndGrPA: TBindSourceDB;
    bndFilaEspera: TBindSourceDB;
    bndFaixaDeSenha: TBindSourceDB;
    bndTag: TBindSourceDB;
    bndUnidade: TBindSourceDB;

    dbChartSla: TDBChart;
    dbPieChartTmeTma: TDBChart;
    PieSeries6: TPieSeries;
    dbChartTmeTma: TDBChart;
    RotateCCWBtn: TButton;
    RotateCWBtn: TButton;
    barSeriesTME: TBarSeries;
    barSeriesTMA: TBarSeries;
    LineSeriesQTD: TLineSeries;
    MesQtdBarSeries: TBarSeries;
    barSeriesEsperaVerde: TBarSeries;
    barSeriesEsperaAmarelo: TBarSeries;
    barSeriesEsperaVermelho: TBarSeries;
    barSeriesEsperaCinza: TBarSeries;
    barSeriesAtendimentoVerde: TBarSeries;
    barSeriesAtendimentoAmarelo: TBarSeries;
    barSeriesAtendimentoVermelho: TBarSeries;
    barSeriesAtendimentoCinza: TBarSeries;
    rectDadosDestaPesquisa: TRectangle;
    rectTituloDados: TRectangle;
    lblTituloDados: TLabel;
    rectTotais: TRectangle;
    rectTituloTotais: TRectangle;
    lblTituloTotais: TLabel;
    rectApresentar: TRectangle;
    Rectangle1: TRectangle;
    Label21: TLabel;
    rectParametrosSLA: TRectangle;
    Rectangle2: TRectangle;
    Label22: TLabel;
    rectApresentarSLA: TRectangle;
    rect2: TRectangle;
    lbl1: TLabel;
    rectLegenda: TRectangle;
    rectAzul: TRectangle;
    rectVermelho: TRectangle;
    lblEspera: TLabel;
    lblAtendimento: TLabel;
    rectAmarelo: TRectangle;
    rectVerde: TRectangle;
    Rectangle3: TRectangle;
    Rectangle4: TRectangle;
    Rectangle5: TRectangle;
    Rectangle6: TRectangle;
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
    intgrfldFaixaDeSenhaIdUnidade: TIntegerField;
    strngfldFaixaDeSenhaNomeUnidade: TStringField;
    intgrfldFilaEsperaIdUnidade: TIntegerField;
    strngfldFilaEsperaNomeUnidade: TStringField;
    intgrfldTagIdUnidade: TIntegerField;
    strngfldTagNomeUnidade: TStringField;
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
    intgrfldGrPASlaIdUnidade: TIntegerField;
    strngfldGrPASlaNomeUnidade: TStringField;
    intgrfldFaixaDeSenhaSlaIdUnidade: TIntegerField;
    strngfldFaixaDeSenhaSlaNomeUnidade: TStringField;
    intgrfldFilaEsperaSlaIdUnidade: TIntegerField;
    strngfldFilaEsperaSlaNomeUnidade: TStringField;
    intgrfldTagSlaIdUnidade: TIntegerField;
    strngfldTagSlaNomeUnidade: TStringField;
    PageControlGrids: TTabControl;
    tbsMes: TTabItem;
    MesGrid: TGrid;
    tbsDia: TTabItem;
    DiaGrid: TGrid;
    tbsDiaSemana: TTabItem;
    DiaSmGrid: TGrid;
    tbsHora: TTabItem;
    HoraGrid: TGrid;
    tbsAtendentes: TTabItem;
    AtendGrid: TGrid;
    tbsGrupoAtendente: TTabItem;
    GrAtendGrid: TGrid;
    tbsPA: TTabItem;
    PAGrid: TGrid;
    tbsGrupoPA: TTabItem;
    GrPAGrid: TGrid;
    tbsFilaEspera: TTabItem;
    FilaEsperaGrid: TGrid;
    tbsFaixaSenha: TTabItem;
    FaixaDeSenhaGrid: TGrid;
    tbsTag: TTabItem;
    TagGrid: TGrid;
    tbsUnidades: TTabItem;
    UnidadeGrid: TGrid;
    tbsClientes: TTabItem;
    ClienteGrid: TGrid;
    bndCliente: TBindSourceDB;
    ClientesDS: TDataSource;
    cdsCliente: TClientDataSet;
    cdsClienteCliente: TIntegerField;
    cdsClienteClienteRecNo: TIntegerField;
    cdsClienteClienteNome: TStringField;
    cdsClienteQtdE: TIntegerField;
    cdsClienteTME: TDateTimeField;
    cdsClienteMaxTE: TDateTimeField;
    cdsClienteIdUnidade: TIntegerField;
    cdsClienteNomeUnidade: TStringField;
    LinkGridClientes: TLinkGridToDataSource;
    cdsLkpClientes: TClientDataSet;
    cdsLkpClientesID: TIntegerField;
    cdsLkpClientesNOME: TStringField;
    cdsClienteQtdA: TIntegerField;
    cdsClienteTMA: TDateTimeField;
    cdsClienteMaxTA: TDateTimeField;

    procedure cdsDiaSmCalcFields(DataSet: TDataSet);
    procedure cdsAtendCalcFields(DataSet: TDataSet);
    procedure cdsPACalcFields(DataSet: TDataSet);
    procedure cdsFaixaDeSenhaCalcFields(DataSet: TDataSet);
    procedure cdsGrAtendCalcFields(DataSet: TDataSet);
    procedure cdsGrPACalcFields(DataSet: TDataSet);
    procedure cboChartTypeChange(Sender: TObject);
    procedure RotateCWBtnClick(Sender: TObject);
    procedure QtdEspAtdComboChange(Sender: TObject);
    procedure actFecharExecute(Sender: TObject);
    procedure actImprimirExecute(Sender: TObject);
    procedure cdsMesCalcFields(DataSet: TDataSet);
    procedure cdsMesTestesCalcFields(DataSet: TDataSet);
    procedure cdsUnidadeCalcFields(DataSet: TDataSet);
    procedure cdsUnidadeUnidadeNomeGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure cdsMesTMEGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure cdsTagCalcFields(DataSet: TDataSet);
    procedure PageControlGridsChange(Sender: TObject);
    procedure cdsMesAfterOpen(DataSet: TDataSet);
    procedure cdsTagTagNomeGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure StringField20GetText(Sender: TField; var Text: String; DisplayText: Boolean);

    procedure cdsFilaEsperaCalcFields(DataSet: TDataSet);
    procedure cdsFilaEsperaFilaEsperaNomeGetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure StringField22GetText(Sender: TField; var Text: String; DisplayText: Boolean);
    procedure dbChartSlaMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Single); Override;
    procedure QtdCheckBoxChange(Sender: TObject);
    procedure chkSlaAtendimentoChange(Sender: TObject);
    procedure chkSlaCinzaChange(Sender: TObject);
    procedure chkSlaEsperaChange(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure RotateCCWBtnClick(Sender: TObject);

    procedure AtendDSDataChange(Sender: TObject; Field: TField);
    procedure FrameResize(Sender: TObject);
    procedure cdsClienteCalcFields(DataSet: TDataSet);
  public

  private
    procedure ComponentesCallCenter;
  protected
    FParamsSla: TParamsSla;
  	procedure SetVisible(const aValue: Boolean); Override;
    procedure SetGraficoSla(const Value: Boolean); Override;
    procedure AjustaTipoDBChart;
    procedure SetParamsSla(const Value: TParamsSla);
    procedure ExportarGrafico(const ExportarPara : TExportarPara); Override;
    procedure SetVisibleGraphics; Override;
    procedure ExportarDadosExcel; Override;
    procedure CalcularEstatisticas; Override;
    procedure CalcularEstatisticasSla; Override;
    procedure PrepararLkpsUnidades; Override;
    procedure DefineCorChart; Override;
  public
    property ParamsSla: TParamsSla read FParamsSla write SetParamsSla;
	  constructor Create(aOwer: TComponent); Override;
    destructor Destroy; Override;
  end;

implementation

{$R *.fmx}

uses

  {$IFDEF SuportaQuickRep}
  repGraph, Vcl.Graphics,
  {$ENDIF SuportaQuickRep}
  Sics_Common_Parametros, ufrmPesquisaRelatorio, Sics_Common_Splash,
  untCommonFrameBase, untCommonDMClient, untCommonDMUnidades;

constructor TfrmSicsGraphics.Create(aOwer: TComponent);
begin
  inherited;

end;

procedure TfrmSicsGraphics.DefineCorChart;
begin
//BAH Não precisa usar aqui, foi mantido pq o formulario Base possui declaração que outros formularios usam
end;

procedure TfrmSicsGraphics.ExportarGrafico(const ExportarPara: TExportarPara);
var
  Chart: TDBChart;
begin
  inherited;
  if not FGraficoSla then
  begin
    if cboChartType.ItemIndex = 0 then
      Chart := dbChartTmeTma
    else
      Chart := dbPieChartTmeTma;
  end
  else
    Chart := dbChartSla;

  ExportarGrafico(ExportarPara, Chart);
end;

procedure TfrmSicsGraphics.FrameResize(Sender: TObject);
begin
  inherited;
  if vgParametrosModulo.ModoCallCenter then
    ComponentesCallCenter;
end;

procedure TfrmSicsGraphics.ExportarDadosExcel;
{$IFNDEF IS_MOBILE}
var
  LStringListTmp: TStringList;

procedure exportToExcel;
    var
      ExcelApplication: TExcelApplication;
      ExcelWorkbook   : TExcelWorkbook;
      ExcelWorksheet  : TExcelWorksheet;
      iSheetIndex     : Integer;
      iRowCount       : Integer;

      procedure CriarSheet(const SheetName: string; DataSet: TDataSet; const CampoDescr: string);
      var
        cColExcel        : Char;
        iField, iRowExcel: Integer;
        sValue           : string;
      begin
        Inc(iSheetIndex);

        if iSheetIndex > ExcelWorkbook.Sheets.Count then
          ExcelWorkbook.Sheets.Add(EmptyParam, ExcelWorkbook.Sheets[iSheetIndex - 1], EmptyParam, EmptyParam, LCID);

        ExcelWorksheet.ConnectTo(ExcelWorkbook.WorkSheets[iSheetIndex] as _Worksheet);
        ExcelWorksheet.Activate(LCID);
        ExcelWorksheet.Name := SheetName;

        with DataSet do
        begin
          First;
          iRowCount     := RecordCount + 1;
          for iRowExcel := 1 to iRowCount do
          begin
            cColExcel := 'A';

              LStringListTmp := TStringList.Create;
              try
                LStringListTmp.Add(CampoDescr);

                if not FGraficoSla then
                begin
                  LStringListTmp.Add('QtdE');
                  LStringListTmp.Add('TME');
                  LStringListTmp.Add('QtdA');
                  if vgParametrosModulo.ModoCallCenter then
                  begin
                    if vgParametrosModulo.ReportarTemposMaximos then
                      LStringListTmp.Add('MaxTE');
                  end
                  else
                  begin
                    LStringListTmp.Add('TMA');
                    if vgParametrosModulo.ReportarTemposMaximos then
                    begin
                      LStringListTmp.Add('MaxTE');
                      LStringListTmp.Add('MaxTA');
                    end;
                  end;
                end
                else
                begin
                  LStringListTmp.Add('ESP_PERC_VERDE');
                  LStringListTmp.Add('ESP_PERC_AMARELO');
                  LStringListTmp.Add('ESP_PERC_VERMELHO');
                  LStringListTmp.Add('ESP_PERC_CINZA');
                  LStringListTmp.Add('ATD_PERC_VERDE');
                  LStringListTmp.Add('ATD_PERC_AMARELO');
                  LStringListTmp.Add('ATD_PERC_VERMELHO');
                  LStringListTmp.Add('ATD_PERC_CINZA');
                end;

                for iField := 0 to LStringListTmp.Count - 1 do
                begin
                  if iRowExcel = 1 then
                    sValue := FieldByName(LStringListTmp.Strings[iField]).DisplayLabel
                  else
                    sValue := FieldByName(LStringListTmp.Strings[iField]).Text;

                  with ExcelWorksheet.Range[cColExcel + IntToStr(iRowExcel), cColExcel + IntToStr(iRowExcel)] do
                  begin
                    if iRowExcel = 1 then
                      Font.Bold := true;
                    Value2      := sValue;
                  end;

                  cColExcel := Chr(Ord(cColExcel) + 1);
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

            ExcelApplication := TExcelApplication.Create(nil);
            ExcelWorkbook    := TExcelWorkbook.Create(nil);
            ExcelWorksheet   := TExcelWorksheet.Create(nil);
            try
              ExcelApplication.ConnectKind := TConnectKind.ckNewInstance;

              LCID                                 := GetUserDefaultLCID;
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

                if vgParametrosModulo.ModoCallCenter then
                begin
                  CriarSheet('Atendentes', cdsCliente, 'ClienteNome');
                  CriarSheet('Coordenadores', cdsAtend, 'AtdNome');
                  CriarSheet('Grupo de Coordenadores', cdsGrAtend, 'GrAtendNome');
                  CriarSheet('Faixa de Mesas', cdsFaixaDeSenha, 'FaixaDeSenhaNome');
                end
                else
                begin
                  CriarSheet('Atendentes', cdsAtend, 'AtdNome');
                  CriarSheet('Grupo de Atendentes', cdsGrAtend, 'GrAtendNome');
                  CriarSheet('PA', cdsPA, 'PANome');
                  CriarSheet('Grupo PA', cdsGrPA, 'GrPANome');
                  CriarSheet('Faixa de Senha', cdsFaixaDeSenha, 'FaixaDeSenhaNome');
                  CriarSheet('Tags', cdsTag, 'TagNome');
                end;

                CriarSheet('FilaEspera', cdsFilaEspera, 'FilaEsperaNome');
              end
              else
              begin
                CriarSheet('Mes', cdsMesSla, 'DESCRICAO');
                CriarSheet('Dia', cdsDiaSla, 'DESCRICAO');
                CriarSheet('Dia Sem', cdsDiaSmSla, 'DESCRICAO');
                CriarSheet('Hora', cdsHoraSla, 'DESCRICAO');
                CriarSheet('Atendente', cdsAtendSla, 'DESCRICAO');
                CriarSheet('Grupo de Atendente', cdsGrAtendSla, 'DESCRICAO');
                CriarSheet('PA', cdsPASla, 'DESCRICAO');
                CriarSheet('Grupo PA', cdsGrPASla, 'DESCRICAO');
                CriarSheet('Faixa de Senha', cdsFaixaDeSenhaSla, 'DESCRICAO');
                CriarSheet('Tags', cdsTagSla, 'DESCRICAO');
                CriarSheet('FilaEspera', cdsFilaEsperaSla, 'DESCRICAO');
              end;

              // votlando pra primeira aba
              ExcelWorksheet.ConnectTo(ExcelWorkbook.WorkSheets[1] as _Worksheet);
              ExcelWorksheet.Activate(LCID);

              ExcelWorkbook.SaveAs(SaveDialogExcel.FileName, xlWorkbookNormal, EmptyParam, EmptyParam, False, False, xlNoChange, xlLocalSessionChanges, EmptyParam, EmptyParam, EmptyParam, EmptyParam, LCID);
              ExcelWorkbook.Close;

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

  if(SaveDialogExcel.Execute)then
  begin
    exportToExcel;
  end;
end;
{$ELSE}
begin
  raise Exception.Create('Função não suporta mobile.');
end;
{$ENDIF IS_MOBILE}

procedure TfrmSicsGraphics.SetGraficoSla(const Value: Boolean);
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
    FilaEsperaDS.DataSet := cdsFilaEsperaSla;
    FaixaDeSenhaDS.DataSet := cdsFaixaDeSenhaSla;
    TagDS.DataSet := cdsTagSla;
    UnidadeDS.DataSet := cdsUnidadeSla;
  end
  else
  begin
    MesDS.DataSet := cdsMes;
    DiaDS.DataSet := cdsDia;
    DiaSmDS.DataSet := cdsDiaSm;
    HoraDS.DataSet := cdsHora;
    AtendDS.DataSet := cdsAtend;
    ClientesDS.DataSet := cdsCliente;
    GrAtendDS.DataSet := cdsGrAtend;
    PADS.DataSet := cdsPA;
    GrPADS.DataSet := cdsGrPA;
    FilaEsperaDS.DataSet := cdsFilaEspera;
    FaixaDeSenhaDS.DataSet := cdsFaixaDeSenha;
    TagDS.DataSet := cdsTag;
    UnidadeDS.DataSet := cdsUnidade;
  end;
  inherited;
end;

procedure TfrmSicsGraphics.SetParamsSla(const Value: TParamsSla);
var
  LfrmPesquisaRelatorio: TfrmPesquisaRelatorio;
begin
  FParamsSla := Value;

  TfrmSicsSplash.ShowStatus('Gerando os Gráficos...');
  try
    LfrmPesquisaRelatorio := (Owner as TfrmPesquisaRelatorio);
    begin
      FMultiUnidades := LfrmPesquisaRelatorio.vlRepVars.MultiUnidades <> '';

      if LfrmPesquisaRelatorio.vlRepVars.QtdeUnidadesSelecionadas = 1 then
      begin
        if not LfrmPesquisaRelatorio.cdsUnidades.Locate('SELECIONADO', true, []) then
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

        PeriododoRelatorioLabel.Text := LfrmPesquisaRelatorio.vlRepVars.PeriodoDoRelatorio;
        PeriododoDiaLabel.Text       := LfrmPesquisaRelatorio.vlRepVars.PeriodoDoDia;
        DuracaoLabel.Text            := LfrmPesquisaRelatorio.vlRepVars.Duracao;
        AtendentesLabel.Text         := LfrmPesquisaRelatorio.vlRepVars.Atendentes;
        PAsLabel.Text                := LfrmPesquisaRelatorio.vlRepVars.PAs;
        SenhasLabel.Text             := LfrmPesquisaRelatorio.vlRepVars.Senhas;
        FaixaDeSenhaLabel.Text       := LfrmPesquisaRelatorio.vlRepVars.Filas;
        TagsLabel.Text               := LfrmPesquisaRelatorio.vlRepVars.Tags;
        lblUnidadesVal.Visible          := FMultiUnidades;
        lblUnidades.Visible             := FMultiUnidades;
        lblUnidadesVal.Text          := LfrmPesquisaRelatorio.vlRepVars.MultiUnidades;

        if LfrmPesquisaRelatorio.vlRepVars.QtdeUnidadesSelecionadas > 1 then
        begin
          tbsAtendentes.Visible     := False;
          tbsGrupoAtendente.Visible := False;
          tbsPA.Visible             := False;
          tbsGrupoPA.Visible        := False;
          tbsFaixaSenha.Visible     := False;
          tbsFilaEspera.Visible     := False;
          tbsTag.Visible            := False;
          tbsUnidades.Visible       := True;
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
          tbsFaixaSenha.Visible     := True;
          tbsFilaEspera.Visible     := True;
          tbsTag.Visible            := True;
          tbsUnidades.Visible       := False;
        end;

        if FGraficoSla then
        begin
          lblParamsSLAEspVermelho.Text := FormatDateTime('hh:mm:ss', IncSecond(0, FParamsSla.EspVermelho));
          lblParamsSLAEspAmarelo.Text  := FormatDateTime('hh:mm:ss', IncSecond(0, FParamsSla.EspAmarelo));
          lblParamsSLAAtdVermelho.Text := FormatDateTime('hh:mm:ss', IncSecond(0, FParamsSla.AtdVermelho));
          lblParamsSLAAtdAmarelo.Text  := FormatDateTime('hh:mm:ss', IncSecond(0, FParamsSla.AtdAmarelo));
        end;

        AjustaTipoDBChart;
      finally

      end; { try .. finally }
    end;
  finally
    TfrmSicsSplash.Hide;
  end;
end;

procedure TfrmSicsGraphics.SetVisible(const aValue: Boolean);
begin
  inherited;
  if aValue then
    PageControlGrids.OnChange(PageControlGrids);
end;

procedure TfrmSicsGraphics.SetVisibleGraphics;
begin
  pnlGraficosTmeTma.Visible := not FGraficoSla;

  if FGraficoSla then
  begin
    pnlChartSla.Visible         := true;

    rectTotais.Visible := False;
  end;

  rectApresentar.Visible     := not FGraficoSla;
  rectApresentarSLA.Visible  := FGraficoSla;
  rectParametrosSLA.Visible := FGraficoSla;

  TMECheckBox.IsChecked := (PageControlGrids.ActiveTab <> tbsAtendentes) and (PageControlGrids.ActiveTab <> tbsPA);
end;

procedure TfrmSicsGraphics.QtdCheckBoxChange(Sender: TObject);
begin
  if Sender =  QtdCheckBox then
    QtdEspAtdComboChange(Sender)
  else
  begin
    cdsMesTME.Visible          := TMECheckBox.IsChecked;
    cdsDiaTME.Visible          := TMECheckBox.IsChecked;
    cdsDiaSmTME.Visible        := TMECheckBox.IsChecked;
    cdsHoraTME.Visible         := TMECheckBox.IsChecked;
    cdsAtendTME.Visible        := TMECheckBox.IsChecked;
    cdsGrAtendTME.Visible      := TMECheckBox.IsChecked;
    cdsPATME.Visible           := TMECheckBox.IsChecked;
    cdsGrPATME.Visible         := TMECheckBox.IsChecked;
    cdsFaixaDeSenhaTME.Visible := TMECheckBox.IsChecked;
    cdsFilaEsperaTME.Visible   := TMECheckBox.IsChecked;
    cdsTagTME.Visible          := TMECheckBox.IsChecked;
    cdsUnidadeTME.Visible      := TMECheckBox.IsChecked;

    cdsMesTMA.Visible          := TMACheckBox.IsChecked;
    cdsDiaTMA.Visible          := TMACheckBox.IsChecked;
    cdsDiaSmTMA.Visible        := TMACheckBox.IsChecked;
    cdsHoraTMA.Visible         := TMACheckBox.IsChecked;
    cdsAtendTMA.Visible        := TMACheckBox.IsChecked;
    cdsGrAtendTMA.Visible      := TMACheckBox.IsChecked;
    cdsPATMA.Visible           := TMACheckBox.IsChecked;
    cdsGrPATMA.Visible         := TMACheckBox.IsChecked;
    cdsFaixaDeSenhaTMA.Visible := TMACheckBox.IsChecked;
    cdsFilaEsperaTMA.Visible   := TMACheckBox.IsChecked;
    cdsTagTMA.Visible          := TMACheckBox.IsChecked;
    cdsUnidadeTMA.Visible      := TMACheckBox.IsChecked;
  end;
  AtualizarColunasGrid;

  if (QtdCheckBox.IsChecked and (not TMECheckBox.IsChecked) and (not TMACheckBox.IsChecked)) then
    cboChartType.Enabled := true
  else
  begin
    cboChartType.ItemIndex := 0;
    cboChartTypeChange(Self);
    cboChartType.Enabled := False;

    if (QtdCheckBox.IsChecked) then
    begin
      if (TMECheckBox.IsChecked) then
      begin
        QtdEspAtdCombo.ItemIndex := 0;
        QtdEspAtdComboChange(Self);
      end
      else if ((not TMECheckBox.IsChecked) and (TMACheckBox.IsChecked)) then
      begin
        QtdEspAtdCombo.ItemIndex := 1;
        QtdEspAtdComboChange(Self);
      end;
    end
    else
    begin
      QtdEspAtdCombo.ItemIndex := -1;
      QtdEspAtdComboChange(Self);
    end;
  end;
  AjustaTipoDBChart;

  barSeriesTME.Active := TMECheckBox.IsChecked;
  barSeriesTMA.Active := TMACheckBox.IsChecked;
  LineSeriesQTD.Active := (QtdCheckBox.IsChecked and (TMACheckBox.IsChecked or TMECheckBox.IsChecked));
  MesQtdBarSeries.Active := (QtdCheckBox.IsChecked and (not TMACheckBox.IsChecked) and (not TMECheckBox.IsChecked));
end;

procedure TfrmSicsGraphics.cdsMesCalcFields(DataSet: TDataSet);
begin
  cdsMesMesStr.AsString := String(MesStrArray[cdsMesMes.AsInteger]);
end;

procedure TfrmSicsGraphics.cdsDiaSmCalcFields(DataSet: TDataSet);
begin
  cdsDiaSmDiaSmStr.AsString := String(DiaSmStrArray[cdsDiaSmDiaSm.AsInteger]);
end;

procedure TfrmSicsGraphics.cdsAtendCalcFields(DataSet: TDataSet);
begin
  cdsAtendAtdRecNo.AsInteger := cdsAtend.RecNo;
end;

procedure TfrmSicsGraphics.cdsClienteCalcFields(DataSet: TDataSet);
begin
  cdsClienteClienteRecNo.AsInteger := cdsCliente.RecNo;
end;

procedure TfrmSicsGraphics.cdsGrAtendCalcFields(DataSet: TDataSet);
begin
  if (cdsGrAtend.RecNo > 0) and (cdsGrAtend.RecNo < 32000) then
    cdsGrAtendGrAtendRecNo.AsInteger := cdsGrAtend.RecNo;
end;

procedure TfrmSicsGraphics.cdsPACalcFields(DataSet: TDataSet);
begin
  cdsPAPARecNo.AsInteger := cdsPA.RecNo;
end;

procedure TfrmSicsGraphics.cdsGrPACalcFields(DataSet: TDataSet);
begin
  if (cdsGrPA.RecNo > 0) and (cdsGrPA.RecNo < 32000) then
    cdsGrPAGrPARecNo.AsInteger := cdsGrPA.RecNo;
end;

procedure TfrmSicsGraphics.cdsFaixaDeSenhaCalcFields(DataSet: TDataSet);
begin
  cdsFaixaDeSenhaFaixaDeSenhaRecNo.AsInteger := cdsFaixaDeSenha.RecNo;
end;

procedure TfrmSicsGraphics.cdsUnidadeCalcFields(DataSet: TDataSet);
begin
  cdsUnidadeUnidadeRecNo.AsInteger := cdsUnidade.RecNo;
end;

{ ================================================================= }
{ Procedures Field.GetText }
{ ================================================================= }

procedure TfrmSicsGraphics.cdsUnidadeUnidadeNomeGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text := dmUnidades.Nome[cdsUnidadeUnidade.AsInteger];
end;

procedure TfrmSicsGraphics.cboChartTypeChange(Sender: TObject);
begin
  dbChartTmeTma.Visible    := (cboChartType.ItemIndex = 0);
  dbPieChartTmeTma.Visible := not dbChartTmeTma.Visible;
  RotateCCWBtn.Visible := dbPieChartTmeTma.Visible;
  RotateCWBtn.Visible := RotateCCWBtn.Visible;
end;

procedure TfrmSicsGraphics.RotateCCWBtnClick(Sender: TObject);
begin
  RotacionarPie((dbPieChartTmeTma.Series[0] as TPieSeries), False);
end;

procedure TfrmSicsGraphics.RotateCWBtnClick(Sender: TObject);
begin
  RotacionarPie((dbPieChartTmeTma.Series[0] as TPieSeries), True);
end;

procedure TfrmSicsGraphics.QtdEspAtdComboChange(Sender: TObject);
begin
  cdsMesQtdE.Visible   := (QtdEspAtdCombo.ItemIndex = 0) and QtdCheckBox.IsChecked;
  cdsDiaQtdE.Visible   := (QtdEspAtdCombo.ItemIndex = 0) and QtdCheckBox.IsChecked;
  cdsDiaSmQtdE.Visible := (QtdEspAtdCombo.ItemIndex = 0) and QtdCheckBox.IsChecked;
  cdsHoraQtdE.Visible  := (QtdEspAtdCombo.ItemIndex = 0) and QtdCheckBox.IsChecked;
  cdsAtendQtdE.Visible := (QtdEspAtdCombo.ItemIndex = 0) and QtdCheckBox.IsChecked;

  cdsGrAtendQtdE.Visible := true;
  cdsPAQtdE.Visible      := (QtdEspAtdCombo.ItemIndex = 0) and QtdCheckBox.IsChecked;

  cdsGrPAQtdE.Visible         := true;
  cdsFaixaDeSenhaQtdE.Visible := (QtdEspAtdCombo.ItemIndex = 0) and QtdCheckBox.IsChecked;
  cdsFilaEsperaQtdE.Visible   := (QtdEspAtdCombo.ItemIndex = 0) and QtdCheckBox.IsChecked;
  cdsTagQtdE.Visible          := (QtdEspAtdCombo.ItemIndex = 0) and QtdCheckBox.IsChecked;
  cdsUnidadeQtdE.Visible      := (QtdEspAtdCombo.ItemIndex = 0) and QtdCheckBox.IsChecked;

  cdsMesQtdA.Visible   := (QtdEspAtdCombo.ItemIndex = 1) and QtdCheckBox.IsChecked;
  cdsDiaQtdA.Visible   := (QtdEspAtdCombo.ItemIndex = 1) and QtdCheckBox.IsChecked;
  cdsDiaSmQtdA.Visible := (QtdEspAtdCombo.ItemIndex = 1) and QtdCheckBox.IsChecked;
  cdsHoraQtdA.Visible  := (QtdEspAtdCombo.ItemIndex = 1) and QtdCheckBox.IsChecked;
  cdsAtendQtdA.Visible := (QtdEspAtdCombo.ItemIndex = 1) and QtdCheckBox.IsChecked;
  cdsGrAtendQtdA.Visible := true;
  cdsPAQtdA.Visible      := (QtdEspAtdCombo.ItemIndex = 1) and QtdCheckBox.IsChecked;

  cdsGrPAQtdA.Visible         := true;
  cdsFaixaDeSenhaQtdA.Visible := (QtdEspAtdCombo.ItemIndex = 1) and QtdCheckBox.IsChecked;
  cdsFilaEsperaQtdA.Visible   := (QtdEspAtdCombo.ItemIndex = 1) and QtdCheckBox.IsChecked;
  cdsTagQtdA.Visible          := (QtdEspAtdCombo.ItemIndex = 1) and QtdCheckBox.IsChecked;
  cdsUnidadeQtdA.Visible      := (QtdEspAtdCombo.ItemIndex = 1) and QtdCheckBox.IsChecked;

  if Sender = QtdEspAtdCombo then
    AtualizarColunasGrid;

  case QtdEspAtdCombo.ItemIndex of
    0:
      begin
        LineSeriesQTD.YValues.ValueSource := 'QtdE';
        MesQtdBarSeries.YValues.ValueSource := 'QtdE';
         (dbPieChartTmeTma.Series[0] as TPieSeries).PieValues.ValueSource := 'QtdE';
      end;
    1:
      begin
        LineSeriesQTD.YValues.ValueSource := 'QtdA';
        MesQtdBarSeries.YValues.ValueSource := 'QtdA';
         (dbPieChartTmeTma.Series[0] as TPieSeries).PieValues.ValueSource := 'QtdA';
      end;
  end;
  AjustaTipoDBChart;
end;

procedure TfrmSicsGraphics.actImprimirExecute(Sender: TObject);
{$IFDEF SuportaQuickRep}
var
  DS: TDataSet;
  qrSicsGraphic: TqrSicsGraphic;
{$ENDIF SuportaQuickRep}
begin
  {$IFDEF SuportaQuickRep}
  qrSicsGraphic := TqrSicsGraphic.Create(Self);
  try
    with qrSicsGraphic do
    begin
      if vgParametrosModulo.ModoCallCenter then
      begin
        qrlSenhas.Caption       := 'Mesas:';
        qrlAtendentes.Caption   := 'Coordenadores:';
        qrlPas.Enabled          := False;
        PAsLabel.Enabled        := False;
        qrlTags.Enabled         := False;
        TagsLabel.Enabled       := False;
        qrlFilas.Top            := 50;
        FilasLabel.Top          := 50;
      end;
      ItemLabel.Enabled  := not FGraficoSla;
      QtdELabel.Enabled  := not FGraficoSla;
      TMELabel.Enabled   := not FGraficoSla;
      QtdALabel.Enabled  := not FGraficoSla;
      TMALabel.Enabled   := ((not FGraficoSla) and (not vgParametrosModulo.ModoCallCenter));
      ItemDBText.Enabled := not FGraficoSla;
      QtdEDBText.Enabled := not FGraficoSla;
      TMEDBText.Enabled  := not FGraficoSla;
      QtdADBText.Enabled := not FGraficoSla;
      TMADBText.Enabled  := not FGraficoSla;

      qrlblSlaEspera.Enabled          := FGraficoSla;
      qrlblSlaAtendimento.Enabled     := FGraficoSla;
      qrShapeSlaEspera.Enabled        := FGraficoSla;
      qrShapeSlaAtendimento.Enabled   := FGraficoSla;
      qrlblEspPercVerde.Enabled       := FGraficoSla;
      qrlblEspPercAmarelo.Enabled     := FGraficoSla;
      qrlblEspPercVermelho.Enabled    := FGraficoSla;
      qrlblEspPercCinza.Enabled       := FGraficoSla;
      qrlblAtdPercVerde.Enabled       := FGraficoSla;
      qrlblAtdPercAmarelo.Enabled     := FGraficoSla;
      qrlblAtdPercVermelho.Enabled    := FGraficoSla;
      qrlblAtdPercCinza.Enabled       := FGraficoSla;
      qrlblSlaDescricao.Enabled       := FGraficoSla;
      qrdbtextSlaDescricao.Enabled    := FGraficoSla;
      qrdbtextEspPercVerde.Enabled    := FGraficoSla;
      qrdbtextEspPercAmarelo.Enabled  := FGraficoSla;
      qrdbtextEspPercVermelho.Enabled := FGraficoSla;
      qrdbtextEspPercCinza.Enabled    := FGraficoSla;
      qrdbtextAtdPercVerde.Enabled    := FGraficoSla;
      qrdbtextAtdPercAmarelo.Enabled  := FGraficoSla;
      qrdbtextAtdPercVermelho.Enabled := FGraficoSla;
      qrdbtextAtdPercCinza.Enabled    := FGraficoSla;

      if FGraficoSla then
      begin
        qrlblSlaEspera.Top          := ItemLabel.Top;
        qrlblSlaAtendimento.Top     := ItemLabel.Top;
        qrShapeSlaEspera.Top        := ItemLabel.Top + 17;
        qrShapeSlaAtendimento.Top   := ItemLabel.Top + 17;
        qrlblSlaDescricao.Top       := qrShapeSlaAtendimento.Top + 2;
        qrlblEspPercVerde.Top       := qrlblSlaDescricao.Top;
        qrlblEspPercAmarelo.Top     := qrlblSlaDescricao.Top;
        qrlblEspPercVermelho.Top    := qrlblSlaDescricao.Top;
        qrlblEspPercCinza.Top       := qrlblSlaDescricao.Top;
        qrlblAtdPercVerde.Top       := qrlblSlaDescricao.Top;
        qrlblAtdPercAmarelo.Top     := qrlblSlaDescricao.Top;
        qrlblAtdPercVermelho.Top    := qrlblSlaDescricao.Top;
        qrlblAtdPercCinza.Top       := qrlblSlaDescricao.Top;
        qrdbtextSlaDescricao.Top    := 2;
        qrdbtextEspPercVerde.Top    := 2;
        qrdbtextEspPercAmarelo.Top  := 2;
        qrdbtextEspPercVermelho.Top := 2;
        qrdbtextEspPercCinza.Top    := 2;
        qrdbtextAtdPercVerde.Top    := 2;
        qrdbtextAtdPercAmarelo.Top  := 2;
        qrdbtextAtdPercVermelho.Top := 2;
        qrdbtextAtdPercCinza.Top    := 2;
      end;

      if FGraficoSla then
        ColumnHeaderBand.Height := 45
      else
        ColumnHeaderBand.Height := 24;
      DetailBand.Height         := 16;
      SummaryBand.Enabled       := not FGraficoSla;
    end;

    DS := nil;
    if not FGraficoSla then
    begin
      case PageControlGrids.TabIndex of
        0:
          begin
            DS                                 := cdsMes;
            qrSicsGraphic.ItemLabel.Caption    := 'Mês';
            qrSicsGraphic.ItemDBText.DataField := 'MesStr';
          end;
        1:
          begin
            DS                                 := cdsDia;
            qrSicsGraphic.ItemLabel.Caption    := 'Dia';
            qrSicsGraphic.ItemDBText.DataField := 'Dia';
          end;
        2:
          begin
            DS                                 := cdsDiaSm;
            qrSicsGraphic.ItemLabel.Caption    := 'Dia da Semana';
            qrSicsGraphic.ItemDBText.DataField := 'DiaSmStr';
          end;
        3:
          begin
            DS                                 := cdsHora;
            qrSicsGraphic.ItemLabel.Caption    := 'Hora';
            qrSicsGraphic.ItemDBText.DataField := 'Hora';
          end;
        4:
          begin
            DS                                 := cdsAtend;
            qrSicsGraphic.ItemLabel.Caption    := 'Atendente';
            qrSicsGraphic.ItemDBText.DataField := 'AtdNome';
          end;
        5:
          begin
            DS                                 := cdsGrAtend;
            qrSicsGraphic.ItemLabel.Caption    := 'Grupo de Atendente';
            qrSicsGraphic.ItemDBText.DataField := 'GrAtendNome';
          end;
        6:
          begin
            DS                                 := cdsPA;
            qrSicsGraphic.ItemLabel.Caption    := 'PA';
            qrSicsGraphic.ItemDBText.DataField := 'PANome';
          end;
        7:
          begin
            DS                                 := cdsGrPA;
            qrSicsGraphic.ItemLabel.Caption    := 'Grupo de PA';
            qrSicsGraphic.ItemDBText.DataField := 'GrPANome';
          end;
        8:
          begin
            DS                                 := cdsFilaEspera;
            qrSicsGraphic.ItemLabel.Caption    := 'Fila';
            qrSicsGraphic.ItemDBText.DataField := 'FilaEsperaNome';
          end;
        9:
          begin
            DS                                 := cdsFaixaDeSenha;
            qrSicsGraphic.ItemLabel.Caption    := 'Tipo';
            qrSicsGraphic.ItemDBText.DataField := 'FaixaDeSenhaNome';
          end;
        10:
          begin
            DS                                 := cdsTag;
            qrSicsGraphic.ItemLabel.Caption    := 'Tag';
            qrSicsGraphic.ItemDBText.DataField := 'TagNome';
          end;
        11:
          begin
            DS                                 := cdsUnidade;
            qrSicsGraphic.ItemLabel.Caption    := 'Unidade';
            qrSicsGraphic.ItemDBText.DataField := 'UnidadeNome';
          end;
        12:
          begin
            DS                                 := cdsCliente;
            qrSicsGraphic.ItemLabel.Caption    := 'Cliente';
            qrSicsGraphic.ItemDBText.DataField := 'ClienteNome';
          end;



      end; { case }

      if cboChartType.ItemIndex = 0 then
        dbChartTmeTma.MakeScreenshot.SaveToFile(SettingsPathName + 'Graphics.bmp')
      else
        dbPieChartTmeTma.MakeScreenshot.SaveToFile(SettingsPathName + 'Graphics.bmp');

      qrSicsGraphic.QrImageChart.Picture.LoadFromFile(SettingsPathName + 'Graphics.bmp');

      qrSicsGraphic.DataSet            := DS;
      qrSicsGraphic.ItemDBText.DataSet := DS;
      if ((QtdCheckBox.IsChecked) and (QtdEspAtdCombo.ItemIndex = 0)) then
        qrSicsGraphic.QtdEDBText.DataSet := DS
      else
        qrSicsGraphic.QtdEDBText.DataSet := nil;
      if TMECheckBox.IsChecked then
        qrSicsGraphic.TMEDBText.DataSet := DS
      else
        qrSicsGraphic.TMEDBText.DataSet := nil;
      if ((QtdCheckBox.IsChecked) and (QtdEspAtdCombo.ItemIndex = 1)) then
        qrSicsGraphic.QtdADBText.DataSet := DS
      else
        qrSicsGraphic.QtdADBText.DataSet := nil;
      if TMACheckBox.IsChecked then
        qrSicsGraphic.TMADBText.DataSet := DS
      else
        qrSicsGraphic.TMADBText.DataSet := nil;
    end
    else
    begin
      case PageControlGrids.TabIndex of
        0:
          begin
            qrSicsGraphic.qrlblSlaDescricao.Caption := 'Mês';//
            DS                                      := cdsMesSla;
          end;
        1:
          begin
            qrSicsGraphic.qrlblSlaDescricao.Caption := 'Dia';
            DS                                      := cdsDiaSla;
          end;
        2:
          begin
            qrSicsGraphic.qrlblSlaDescricao.Caption := 'Dia da Semana';
            DS                                      := cdsDiaSmSla;
          end;
        3:
          begin
            qrSicsGraphic.qrlblSlaDescricao.Caption := 'Hora';
            DS                                      := cdsHoraSla;
          end;
        4:
          begin
            qrSicsGraphic.qrlblSlaDescricao.Caption := 'Atendente';
            DS                                      := cdsAtendSla;
          end;
        5:
          begin
            qrSicsGraphic.qrlblSlaDescricao.Caption := 'Grupo Atendente';
            DS                                      := cdsGrAtendSla;
          end;
        6:
          begin
            qrSicsGraphic.qrlblSlaDescricao.Caption := 'PA';
            DS                                      := cdsPASla;
          end;
        7:
          begin
            qrSicsGraphic.qrlblSlaDescricao.Caption := 'Grupo de PA';
            DS                                      := cdsGrPASla;
          end;
        8:
          begin
            qrSicsGraphic.qrlblSlaDescricao.Caption := 'Fila';
            DS                                      := cdsFilaEsperaSla;
          end;
        9:
          begin
            qrSicsGraphic.qrlblSlaDescricao.Caption := 'Tipo';
            DS                                      := cdsFaixaDeSenhaSla;
          end;
        10:
          begin
            qrSicsGraphic.qrlblSlaDescricao.Caption := 'Tag';
            DS                                      := cdsTagSla;
          end;
        11:
          begin
            qrSicsGraphic.qrlblSlaDescricao.Caption := 'Unidade';
            DS                                      := cdsUnidadeSla;
          end;
      end;

      qrSicsGraphic.qrdbtextSlaDescricao.DataSet    := DS;
      qrSicsGraphic.qrdbtextEspPercVerde.DataSet    := DS;
      qrSicsGraphic.qrdbtextEspPercAmarelo.DataSet  := DS;
      qrSicsGraphic.qrdbtextEspPercVermelho.DataSet := DS;
      qrSicsGraphic.qrdbtextEspPercCinza.DataSet    := DS;
      qrSicsGraphic.qrdbtextAtdPercVerde.DataSet    := DS;
      qrSicsGraphic.qrdbtextAtdPercAmarelo.DataSet  := DS;
      qrSicsGraphic.qrdbtextAtdPercVermelho.DataSet := DS;
      qrSicsGraphic.qrdbtextAtdPercCinza.DataSet    := DS;
      qrSicsGraphic.DataSet                         := DS;

      dbChartSla.MakeScreenshot.SaveToFile(SettingsPathName + 'Graphics.bmp');
      qrSicsGraphic.QrImageChart.Picture.LoadFromFile(SettingsPathName + 'Graphics.bmp');
    end;

    qrSicsGraphic.Prepare;

    qrSicsGraphic.QrImageChart.Top         := qrSicsGraphic.DetailBand.Top + qrSicsGraphic.DetailBand.Height * (qrSicsGraphic.RecordCount + 1) + qrSicsGraphic.SummaryBand.Height;
    qrSicsGraphic.QrImageChart.Height      :=
      (qrSicsGraphic.Height - (qrSicsGraphic.QrImageChart.Top + Trunc(qrSicsGraphic.Page.BottomMargin) +
        qrSicsGraphic.SummaryBand.Height));

    if (qrSicsGraphic.QrImageChart.Height < 0) then
      qrSicsGraphic.QrImageChart.Height := qrSicsGraphic.QrImageChart.Height * -1;
    qrSicsGraphic.QrImageChart.Left        := qrSicsGraphic.PageHeaderBand.Left;
    qrSicsGraphic.QrImageChart.Width       := qrSicsGraphic.PageHeaderBand.Width;

    qrSicsGraphic.AtendantsLabel.Caption          := AtendentesLabel.Text;
    qrSicsGraphic.PAsLabel.Caption                := PAsLabel.Text;
    qrSicsGraphic.FilasLabel.Caption              := FaixaDeSenhaLabel.Text;
    qrSicsGraphic.TagsLabel.Caption               := TagsLabel.Text;
    qrSicsGraphic.SenhasLabel.Caption             := SenhasLabel.Text;
    qrSicsGraphic.PeriododoRelatorioLabel.Caption := PeriododoRelatorioLabel.Text;
    qrSicsGraphic.PeriododoDiaLabel.Caption       := PeriododoDiaLabel.Text;
    qrSicsGraphic.DurationLabel.Caption           := DuracaoLabel.Text;
    qrSicsGraphic.lblMultiUnidades.Enabled        := FMultiUnidades;
    qrSicsGraphic.lblMultiUnidadesVal.Enabled     := FMultiUnidades;
    qrSicsGraphic.lblMultiUnidadesVal.Caption     := lblUnidadesVal.Text;

    if FMultiUnidades then
    begin
      qrSicsGraphic.lblRelatorio.Caption := '';
      qrSicsGraphic.UnidadeLabel.Caption := '';
    end
    else
    begin
      qrSicsGraphic.lblRelatorio.Caption := 'Relatório';
      qrSicsGraphic.UnidadeLabel.Caption := vgParametrosModulo.Unidade;
    end;

    qrSicsGraphic.TotaisQtdELabel.Caption := QtdEspLabel.Text;
    qrSicsGraphic.TotaisTMELabel.Caption  := TMELabel.Text;
    qrSicsGraphic.TotaisQtdALabel.Caption := QtdAtdLabel.Text;
    qrSicsGraphic.TotaisTMALabel.Caption  := TMALabel.Text;

    qrSicsGraphic.PreviewModal;
  finally
    FreeAndNil(qrSicsGraphic);
  end;
  {$ENDIF SuportaQuickRep}
end;

procedure TfrmSicsGraphics.AjustaTipoDBChart;
begin
  if (QtdEspAtdCombo.ItemIndex = -1) then
    QtdEspAtdCombo.ItemIndex := 0;

  if (cboChartType.ItemIndex = -1) then
    cboChartType.ItemIndex := 0;
end;

procedure TfrmSicsGraphics.AtendDSDataChange(Sender: TObject; Field: TField);
begin
  inherited;

end;

{ proc ActionImprimir }

procedure TfrmSicsGraphics.actFecharExecute(Sender: TObject);
begin
  inherited;
  Exit;
end; { proc ActionFechar }


procedure TfrmSicsGraphics.btnFecharClick(Sender: TObject);
begin
  inherited;
  //
end;

procedure TfrmSicsGraphics.cdsMesTestesCalcFields(DataSet: TDataSet);
begin
  // VER COMO FUNCIONA O MSCES
  cdsMesTestesTME.AsDateTime := TimeStampToDateTime(MSecsToTimeStamp(cdsMesTestesTME_MSECS.AsInteger));
  cdsMesTestesTMA.AsDateTime := TimeStampToDateTime(MSecsToTimeStamp(cdsMesTestesTMA_MSECS.AsInteger));
end;

procedure TfrmSicsGraphics.cdsMesTMEGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text := MyFormatDateTime('[h]:nn:ss', Sender.AsDateTime);
end;

procedure TfrmSicsGraphics.cdsTagCalcFields(DataSet: TDataSet);
begin
  cdsTagTagRecNo.AsInteger := cdsTag.RecNo;
end;

procedure TfrmSicsGraphics.CalcularEstatisticas;

  function SegundosParaDateTime(Segundos: Integer): TDateTime;
  begin
    Result := IncSecond(0, Segundos);
  end;

  function DateTimeToSegundos(Data: TDateTime): Integer;
  begin
    Result := SecondsBetween(0, Data);
  end;

var
  iAgrupador,LIdUnidade                               : Integer;
  CdsTemp                                               : TClientDataSet;
  sCampoId, sDescricao, sWhere, sInTags, sCampoDescricao: string;
  iQtdETotal, iTMETotal, iQtdATotal, iTMATotal, iNovoTME, iNovoTMA: Integer;
  qryEstatisticasTemp: TFDQuery;
  DataSetDescricao   : TDataSet;
  sMax,NomeUnidade   : string;
  LfrmPesquisaRelatorio: TfrmPesquisaRelatorio;
begin
  LfrmPesquisaRelatorio := (Owner as TfrmPesquisaRelatorio);

  Self.cdsMes.Close;
  Self.cdsHora.Close;
  Self.cdsDia.Close;
  Self.cdsDiaSm.Close;
  Self.cdsAtend.Close;
  Self.cdsCliente.Close;
  Self.cdsPA.Close;
  Self.cdsFaixaDeSenha.Close;
  Self.cdsFilaEspera.Close;
  Self.cdsGrAtend.Close;
  Self.cdsGrPA.Close;
  Self.cdsUnidade.Close;
  Self.cdsTag.Close;

  Self.cdsMes.CreateDataSet;
  Self.cdsHora.CreateDataSet;
  Self.cdsDia.CreateDataSet;
  Self.cdsDiaSm.CreateDataSet;
  Self.cdsAtend.CreateDataSet;
  Self.cdsCliente.CreateDataSet;
  Self.cdsPA.CreateDataSet;
  Self.cdsFaixaDeSenha.CreateDataSet;
  Self.cdsFilaEspera.CreateDataSet;
  Self.cdsGrAtend.CreateDataSet;
  Self.cdsGrPA.CreateDataSet;
  Self.cdsUnidade.CreateDataSet;
  Self.cdsTag.CreateDataSet;

  iQtdETotal := 0;
  iTMETotal  := 0;
  iQtdATotal := 0;
  iTMATotal  := 0;

  LfrmPesquisaRelatorio.cdsUnidades.First;
  while not LfrmPesquisaRelatorio.cdsUnidades.Eof do
  begin

    if not LfrmPesquisaRelatorio.cdsUnidades.FieldByName('SELECIONADO').AsBoolean then
    begin
      LfrmPesquisaRelatorio.cdsUnidades.Next;
      Continue;
    end;

    LIdUnidade := LfrmPesquisaRelatorio.cdsUnidades.FieldByName('ID').AsInteger;
    NomeUnidade := LfrmPesquisaRelatorio.cdsUnidades.FieldByName('NOME').AsString;

    PrepararLkpsUnidades;

    // GOT / LBC correção de bug conforme OS 14481
    // início
    qryEstatisticas.Sql.Text := FSqlEstatisticas;

    qryEstatisticas.Sql.Add('where E.ID_UNIDADE = :ID_UNIDADE AND                                                      ');

    LfrmPesquisaRelatorio.MontarWhere(qryEstatisticas, sInTags, False);
    sWhere                   := Copy(qryEstatisticas.Sql.Text, Length(FSqlEstatisticas), Length(qryEstatisticas.Sql.Text) - Length(FSqlEstatisticas));

    //LM
    //Adcionado pois pois adcionava o numero 2 na frente //verificar
    Delete(sWhere,1,1);

    qryEstatisticas.Sql.Text := StringReplace(FSqlEstatisticas, '/* WHERE */', sWhere, [rfReplaceAll, rfIgnoreCase]);


    if vgParametrosModulo.ReportarTemposMaximos then
    begin
      sMax                     := 'COALESCE( MAX( (CASE WHEN E.ID_TIPOEVENTO = 0 THEN CAST(E.DURACAO_SEGUNDOS AS BIGINT) END) ), 0) AS MAX_TE,' + #13 + #10 + 'COALESCE( MAX( (CASE WHEN E.ID_TIPOEVENTO = 2 THEN CAST(E.DURACAO_SEGUNDOS AS BIGINT) END)), 0) AS MAX_TA,';
      qryEstatisticas.Sql.Text := StringReplace(qryEstatisticas.Sql.Text, '/* MAX_TE_TA */', sMax, [rfReplaceAll, rfIgnoreCase]);
    end;

    //if LfrmPesquisaRelatorio.vlQueryParams.ChoosePswd then
      qryEstatisticas.Sql.Text := StringReplace(qryEstatisticas.Sql.Text, '/* JOINS */', 'INNER JOIN TICKETS S ON S.ID = E.ID_TICKET AND E.ID_UNIDADE = S.ID_UNIDADE LEFT JOIN CLIENTES C ON S.ID_CLIENTE = C .ID AND S.ID_UNIDADE = C.ID_UNIDADE', [rfReplaceAll, rfIgnoreCase]);

    if sInTags <> '' then
      qryEstatisticas.Sql.Text := StringReplace(qryEstatisticas.Sql.Text, '/* JOIN_TICKETS_TAGS_ON */', ' AND TT.ID_TAG IN(' + sInTags + ')', [rfIgnoreCase]);
    // fim
    // GOT / LBC correção de bug conforme OS 14481

    // devido a um bug na dbexpress, temos que criar uma nova sqlquery quando muda
    // a conexao, pois o clientedataset nao consegue "enxergar" as mudancas
    qryEstatisticasTemp := TFDQuery.Create(Self);
    try
      qryEstatisticas.ParamByName('ID_UNIDADE').DataType := ftInteger;
      qryEstatisticas.ParamByName('ID_UNIDADE').AsInteger := LIdUnidade;

      qryEstatisticasTemp.Sql.Text := qryEstatisticas.Sql.Text;
      qryEstatisticasTemp.Params.Assign(qryEstatisticas.Params);
      qryEstatisticasTemp.Connection := DMClient(LIdUnidade, not CRIAR_SE_NAO_EXISTIR).ConnRelatorio;
      dspEstatisticas.DataSet           := qryEstatisticasTemp;
      qryEstatisticas.Prepare;

      // RAP Deixei para testes
      {$IFDEF DEBUG}
      //para conseguir pegar a SQL "pós processamento das macros" é necessário
      //chamar o método Prepare

      ClipBoard.AsText := qryEstatisticas.Text;
      {$ENDIF}

      cdsEstatisticas.Open;
      try
        cdsEstatisticas.Filtered := true;

        for iAgrupador := AGRUPADOR_MES to AGRUPADOR_CLIENTE do
        begin
          case iAgrupador of
            AGRUPADOR_MES:
              begin
                CdsTemp          := Self.cdsMes;
                sCampoId         := 'Mes';
                sDescricao       := 'Mês';
                DataSetDescricao := nil;
              end;
            AGRUPADOR_DIA:
              begin
                CdsTemp          := Self.cdsDia;
                sCampoId         := 'Dia';
                sDescricao       := 'Dia';
                DataSetDescricao := nil;
              end;
            AGRUPADOR_SEMANA:
              begin
                CdsTemp          := Self.cdsDiaSm;
                sCampoId         := 'DiaSm';
                sDescricao       := 'Semana';
                DataSetDescricao := nil;
              end;
            AGRUPADOR_HORA:
              begin
                CdsTemp          := Self.cdsHora;
                sCampoId         := 'Hora';
                sDescricao       := 'Hora';
                DataSetDescricao := nil;
              end;
            AGRUPADOR_ATENDENTE:
              begin
                CdsTemp          := Self.cdsAtend;
                sCampoId         := 'Atend';
                sDescricao       := 'Atendente';
                DataSetDescricao := cdsLkpAtendentes;
                sCampoDescricao  := 'AtdNome';
              end;

            AGRUPADOR_CLIENTE:
              begin
                CdsTemp          := Self.cdsCliente;
                sCampoId         := 'Cliente';
                sDescricao       := 'ClienteNome';
                DataSetDescricao := cdsLkpClientes;
                sCampoDescricao  := 'ClienteNome';
              end;

            AGRUPADOR_GRUPO_ATENDENTE:
              begin
                CdsTemp          := Self.cdsGrAtend;
                sCampoId         := 'GrAtend';
                sDescricao       := 'Grupo de Atendente';
                DataSetDescricao := cdsLkpGruposAtendentes;
                sCampoDescricao  := 'GrAtendNome';
              end;
            AGRUPADOR_PA:
              begin
                CdsTemp          := Self.cdsPA;
                sCampoId         := 'PA';
                sDescricao       := 'PA';
                DataSetDescricao := cdsLkpPAS;
                sCampoDescricao  := 'PANome';
              end;
            AGRUPADOR_GRUPO_PA:
              begin
                CdsTemp          := Self.cdsGrPA;
                sCampoId         := 'GrPA';
                sDescricao       := 'Grupo de PA';
                DataSetDescricao := cdsLkpGruposPAs;
                sCampoDescricao  := 'GrPANome';
              end;
            AGRUPADOR_FAIXADESENHA:
              begin
                CdsTemp          := Self.cdsFaixaDeSenha;
                sCampoId         := 'FaixaDeSenha';
                sDescricao       := 'Faixa de Senha';
                DataSetDescricao := cdsLkpFaixaDeSenhas;
                sCampoDescricao  := 'FaixaDeSenhaNome';
              end;
            AGRUPADOR_FILAESPERA:
              begin
                CdsTemp          := Self.cdsFilaEspera;
                sCampoId         := 'FilaEspera';
                sDescricao       := 'Fila Espera';
                DataSetDescricao := cdsLkpFaixaDeSenhas;
                sCampoDescricao  := 'FilaEsperaNome';
              end;
            AGRUPADOR_TAG:
              begin
                CdsTemp          := Self.cdsTag;
                sCampoId         := 'Tag';
                sDescricao       := 'Tag';
                DataSetDescricao := cdsLkpTags;
                sCampoDescricao  := 'TagNome';
              end
          else
            begin
              CdsTemp          := nil;
              sCampoId         := '';
              sDescricao       := '';
              DataSetDescricao := nil;
              sCampoDescricao  := '';
            end;
          end;

          CdsTemp.FieldByName('NomeUnidade').Visible := (LfrmPesquisaRelatorio.vlRepVars.QtdeUnidadesSelecionadas > 1);

          TfrmSicsSplash.ShowStatus('Gravando dados -  por ' + sDescricao + '...');
          with cdsEstatisticas do
          begin
            Filter := 'AGRUPADOR=' + IntToStr(iAgrupador);
            try
              while not Eof do
              begin
                if cdsTemp.Locate(sCampoId, FieldByName('ID').Value, []) then
                begin
                  CdsTemp.Edit;

                  if CdsTemp.FieldByName('QtdE').AsInteger > 0 then
                    iNovoTME := Round(((CdsTemp.FieldByName('QtdE').AsInteger * DateTimeToSegundos(CdsTemp.FieldByName('TME').AsDateTime)) + (FieldByName('QtdE').AsInteger * FieldByName('TME').AsInteger)) / (CdsTemp.FieldByName('QtdE').AsInteger + FieldByName('QtdE').AsInteger))
                  else
                    iNovoTME := FieldByName('TME').AsInteger;

                  if CdsTemp.FieldByName('QtdA').AsInteger > 0 then
                    iNovoTMA := Round(((CdsTemp.FieldByName('QtdA').AsInteger * DateTimeToSegundos(CdsTemp.FieldByName('TMA').AsDateTime)) + (FieldByName('QtdA').AsInteger * FieldByName('TMA').AsInteger)) / (CdsTemp.FieldByName('QtdA').AsInteger + FieldByName('QtdA').AsInteger))
                  else
                    iNovoTMA := FieldByName('TMA').AsInteger;

                  CdsTemp.FieldByName('TME').AsDateTime := SegundosParaDateTime(iNovoTME);
                  CdsTemp.FieldByName('QtdE').AsInteger := CdsTemp.FieldByName('QtdE').AsInteger + FieldByName('QtdE').AsInteger;
                  CdsTemp.FieldByName('TMA').AsDateTime := SegundosParaDateTime(iNovoTMA);
                  CdsTemp.FieldByName('QtdA').AsInteger := CdsTemp.FieldByName('QtdA').AsInteger + FieldByName('QtdA').AsInteger;


                  if vgParametrosModulo.ReportarTemposMaximos then
                  begin
                    CdsTemp.FieldByName('MaxTA').AsDateTime := SegundosParaDateTime(Max(DateTimeToSegundos(CdsTemp.FieldByName('MaxTA').AsDateTime), FieldByName('MAX_TA').AsInteger));
                    CdsTemp.FieldByName('MaxTE').AsDateTime := SegundosParaDateTime(Max(DateTimeToSegundos(CdsTemp.FieldByName('MaxTE').AsDateTime), FieldByName('MAX_TE').AsInteger));
                  end;
                end
                else
                begin
                  CdsTemp.Append;
                  CdsTemp.FieldByName(sCampoId).Value   := FieldByName('ID').Value;
                  CdsTemp.FieldByName('QtdE').AsInteger := FieldByName('QtdE').AsInteger;
                  CdsTemp.FieldByName('QtdA').AsInteger := FieldByName('QtdA').AsInteger;
                  CdsTemp.FieldByName('TME').AsDateTime := SegundosParaDateTime(FieldByName('TME').AsInteger);
                  CdsTemp.FieldByName('TMA').AsDateTime := SegundosParaDateTime(FieldByName('TMA').AsInteger);
                  CdsTemp.FieldByName('IdUnidade').AsInteger := LIdUnidade;
                  CdsTemp.FieldByName('NomeUnidade').AsString := NomeUnidade;

                  if vgParametrosModulo.ReportarTemposMaximos then
                  begin
                    CdsTemp.FieldByName('MaxTA').AsDateTime := SegundosParaDateTime(FieldByName('MAX_TA').AsInteger);
                    CdsTemp.FieldByName('MaxTE').AsDateTime := SegundosParaDateTime(FieldByName('MAX_TE').AsInteger);
                  end;

                  if (DataSetDescricao <> nil) and (sCampoDescricao <> '') then
                  begin
                    if DataSetDescricao.Locate('ID', FieldByName('ID').Value, []) then
                      CdsTemp.FieldByName(sCampoDescricao).Value := DataSetDescricao.FieldByName('NOME').Value;
                  end;
                end;

                CdsTemp.Post;
                Next;
              end;
              CdsTemp.First;
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
            cdsUnidade.FieldByName('TME').AsDateTime    := SegundosParaDateTime(FieldByName('TME').AsInteger);
            cdsUnidade.FieldByName('TMA').AsDateTime    := SegundosParaDateTime(FieldByName('TMA').AsInteger);
            cdsUnidade.FieldByName('QtdE').AsInteger    := FieldByName('QtdE').AsInteger;
            cdsUnidade.FieldByName('QtdA').AsInteger    := FieldByName('QtdA').AsInteger;

            if vgParametrosModulo.ReportarTemposMaximos then
            begin
              cdsUnidade.FieldByName('MaxTA').AsDateTime := SegundosParaDateTime(FieldByName('MAX_TA').AsInteger);
              cdsUnidade.FieldByName('MaxTE').AsDateTime := SegundosParaDateTime(FieldByName('MAX_TE').AsInteger);
            end;

            cdsUnidade.Post;

            if iTMETotal > 0 then
              iTMETotal := Round(((iQtdETotal * iTMETotal) + (FieldByName('QtdE').AsInteger * FieldByName('TME').AsInteger)) / (iQtdETotal + FieldByName('QtdE').AsInteger))
            else
              iTMETotal := FieldByName('TME').AsInteger;

            if iTMATotal > 0 then
              iTMATotal := Round(((iQtdATotal * iTMATotal) + (FieldByName('QtdA').AsInteger * FieldByName('TMA').AsInteger)) / (iQtdATotal + FieldByName('QtdA').AsInteger))
            else
              iTMATotal := FieldByName('TMA').AsInteger;

            iQtdETotal := iQtdETotal + FieldByName('QtdE').AsInteger;
            iQtdATotal := iQtdATotal + FieldByName('QtdA').AsInteger;
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

    LfrmPesquisaRelatorio.cdsUnidades.Next;
  end;

  Self.QtdEspLabel.Text := IntToStr(iQtdETotal);
  Self.TMELabel.Text    := MyFormatDateTime('[h]:nn:ss', SegundosParaDateTime(iTMETotal));
  Self.QtdAtdLabel.Text := IntToStr(iQtdATotal);
  Self.TMALabel.Text    := MyFormatDateTime('[h]:nn:ss', SegundosParaDateTime(iTMATotal));

  Self.dbChartTmeTma.Visible := (Self.cdsMes.RecordCount > 1) or
   (Self.cdsDia.RecordCount > 1) or
   (Self.cdsDiaSm.RecordCount > 1) or
   (Self.cdsHora.RecordCount > 1) or
   (Self.cdsAtend.RecordCount > 1) or
   (Self.cdsPA.RecordCount > 1) or
   (Self.cdsFaixaDeSenha.RecordCount > 1) or
   (Self.cdsFilaEspera.RecordCount > 1) or
   (Self.cdsGrAtend.RecordCount > 1) or
   (Self.cdsGrPA.RecordCount > 1) or
   (Self.cdsTag.RecordCount > 1) or
   (Self.cdsUnidade.RecordCount > 1);

  Self.cboChartTypeChange(Self);
  AtualizarColunasGrid;
end;

procedure TfrmSicsGraphics.CalcularEstatisticasSla;

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
        Result := GetDcrFromLkp(Value, cdsLkpGruposPAs);
      AGRUPADOR_FAIXADESENHA:
        Result := GetDcrFromLkp(Value, cdsLkpFaixaDeSenhas);
      AGRUPADOR_FILAESPERA:
        Result := GetDcrFromLkp(Value, cdsLkpFaixaDeSenhas);
      AGRUPADOR_TAG:
        Result := GetDcrFromLkp(Value, cdsLkpTags);
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
  sInTags, sWhere, sDescricao, sCondVerde, sCondAmarelo, sCondVermelho, sCondCinza, sNotCondCinza, sCondCinzaBase, sAux: string;
  iAgrupador, iRecNo, iAtdEsp, iAmarelo, iVermelho, iTipoDuracao: Integer;
  CdsTemp             : TClientDataSet;
  qryEstatisticasTemp : TFDQuery;
  IdUnidade, iEspAtd  : Integer;
  dblNovoPerc: Double;
  sEspAtd, sCor, sCampoQtde, sCampoPerc, sCampoQtdeTotal, sCampoQtdeCinza,NomeUnidade: string;
  iCor: Integer;
  chk : TCheckBox;
  LfrmPesquisaRelatorio: TfrmPesquisaRelatorio;
begin
  LfrmPesquisaRelatorio := (Owner as TfrmPesquisaRelatorio);

  qryEstatisticasSla.Sql.Text := FSqlEstatisticasSla;
  qryEstatisticasSla.Sql.Add('where (                                                      ');
  LfrmPesquisaRelatorio.MontarWhere(qryEstatisticasSla, sInTags, true);
  sWhere := Copy(qryEstatisticasSla.Sql.Text, Length(FSqlEstatisticasSla), Length(qryEstatisticasSla.Sql.Text) - Length(FSqlEstatisticasSla));

  //LM
  //Adcionado pois pois adcionava o numero 2 na frente //verificar
  Delete(sWhere,1,1);

  qryEstatisticasSla.Sql.Text := StringReplace(FSqlEstatisticasSla, '/* WHERE */', sWhere, [rfReplaceAll, rfIgnoreCase]);

  //if LfrmPesquisaRelatorio.vlQueryParams.ChoosePswd then
    qryEstatisticasSla.Sql.Text := StringReplace(qryEstatisticasSla.Sql.Text, '/* JOINS */', 'INNER JOIN TICKETS S ON S.ID = E.ID_TICKET AND S.ID_UNIDADE = E.ID_UNIDADE LEFT JOIN CLIENTES C ON S.ID_CLIENTE = C.ID AND S.ID_UNIDADE = C.ID_UNIDADE', [rfReplaceAll, rfIgnoreCase]);

  if sInTags <> '' then
    qryEstatisticasSla.Sql.Text := StringReplace(qryEstatisticasSla.Sql.Text, '/* JOIN_TICKETS_TAGS_ON */', ' AND TT.ID_TAG IN(' + sInTags + ')', [rfIgnoreCase]);


  // pegar do filtro
  for iAtdEsp := 1 to 2 do
  begin
    if iAtdEsp = 1 then
    begin
      sAux         := 'ESP';
      iAmarelo     := FParamsSla.EspAmarelo;
      iVermelho    := FParamsSla.EspVermelho;
      iTipoDuracao := 1;
      chk          := chkSlaEspera;
    end
    else
    begin
      sAux         := 'ATD';
      iAmarelo     := FParamsSla.AtdAmarelo;
      iVermelho    := FParamsSla.AtdVermelho;
      iTipoDuracao := 3;
      chk          := chkSlaAtendimento;
    end;

    if not LfrmPesquisaRelatorio.vlQueryParams.DuracaoPorTipo[iTipoDuracao].Habilitado then
    begin
      chk.IsChecked := False;
      chk.Enabled := False;
    end;

    case LfrmPesquisaRelatorio.vlQueryParams.DuracaoPorTipo[iTipoDuracao].TipoDeDuracao of
      TTipoDeDuracao.tdMenor:
        sCondCinzaBase := 'E.DURACAO_SEGUNDOS < ' + IntToStr(SecondsBetween(0, LfrmPesquisaRelatorio.vlQueryParams.DuracaoPorTipo[iTipoDuracao].Tempo1));
      TTipoDeDuracao.tdMaiorIgual:
        sCondCinzaBase := 'E.DURACAO_SEGUNDOS >= ' + IntToStr(SecondsBetween(0, LfrmPesquisaRelatorio.vlQueryParams.DuracaoPorTipo[iTipoDuracao].Tempo1));
      TTipoDeDuracao.tdEntre:
        sCondCinzaBase := 'E.DURACAO_SEGUNDOS BETWEEN ' + IntToStr(SecondsBetween(0, LfrmPesquisaRelatorio.vlQueryParams.DuracaoPorTipo[iTipoDuracao].Tempo1)) + ' AND ' + IntToStr(SecondsBetween(0, LfrmPesquisaRelatorio.vlQueryParams.DuracaoPorTipo[iTipoDuracao].Tempo2));
    else
      sCondCinzaBase := '';
    end;

    // sCondCinzaBase := '';
    if sCondCinzaBase <> '' then
    begin
      sCondCinza    := ' AND NOT ' + sCondCinzaBase;
      sNotCondCinza := ' AND ' + sCondCinzaBase;
    end
    else
    begin
      sCondCinza    := 'AND 1 = 2'; // p/ forcar sempre ser FALSE e nao calcular o CINZA
      sNotCondCinza := '';
    end;
    sCondVerde                  := 'AND E.DURACAO_SEGUNDOS < ' + IntToStr(iAmarelo) + sNotCondCinza;
    sCondAmarelo                := 'AND E.DURACAO_SEGUNDOS BETWEEN ' + IntToStr(iAmarelo) + ' AND ' + IntToStr(iVermelho - 1) + sNotCondCinza;
    sCondVermelho               := 'AND E.DURACAO_SEGUNDOS >= ' + IntToStr(iVermelho) + sNotCondCinza;
    qryEstatisticasSla.Sql.Text := StringReplace(qryEstatisticasSla.Sql.Text, '/* CONDICAO_' + sAux + '_VERDE */', sCondVerde, [rfReplaceAll, rfIgnoreCase]);
    qryEstatisticasSla.Sql.Text := StringReplace(qryEstatisticasSla.Sql.Text, '/* CONDICAO_' + sAux + '_AMARELO */', sCondAmarelo, [rfReplaceAll, rfIgnoreCase]);
    qryEstatisticasSla.Sql.Text := StringReplace(qryEstatisticasSla.Sql.Text, '/* CONDICAO_' + sAux + '_VERMELHO */', sCondVermelho, [rfReplaceAll, rfIgnoreCase]);
    qryEstatisticasSla.Sql.Text := StringReplace(qryEstatisticasSla.Sql.Text, '/* CONDICAO_' + sAux + '_CINZA */', sCondCinza, [rfReplaceAll, rfIgnoreCase]);
    qryEstatisticasSla.Sql.Text := StringReplace(qryEstatisticasSla.Sql.Text, '[GROUP BY]', ')GROUP BY', [rfReplaceAll, rfIgnoreCase]);
    qryEstatisticasSla.Sql.Text := StringReplace(qryEstatisticasSla.Sql.Text, '[ORDER BY]', ')ORDER BY', [rfReplaceAll, rfIgnoreCase]);

  end;

  Self.cdsMesSla.Close;
  Self.cdsMesSla.FieldDefs.Clear;
  Self.cdsHoraSla.Close;
  Self.cdsHoraSla.FieldDefs.Clear;
  Self.cdsDiaSla.Close;
  Self.cdsDiaSla.FieldDefs.Clear;
  Self.cdsDiaSmSla.Close;
  Self.cdsDiaSmSla.FieldDefs.Clear;
  Self.cdsAtendSla.Close;
  Self.cdsAtendSla.FieldDefs.Clear;
  Self.cdsPASla.Close;
  Self.cdsPASla.FieldDefs.Clear;
  Self.cdsFaixaDeSenhaSla.Close;
  Self.cdsFaixaDeSenhaSla.FieldDefs.Clear;
  Self.cdsFilaEsperaSla.Close;
  Self.cdsFilaEsperaSla.FieldDefs.Clear;
  Self.cdsGrAtendSla.Close;
  Self.cdsGrAtendSla.FieldDefs.Clear;
  Self.cdsGrPASla.Close;
  Self.cdsGrPASla.FieldDefs.Clear;
  Self.cdsUnidadeSla.Close;
  Self.cdsUnidadeSla.FieldDefs.Clear;
  Self.cdsTagSla.Close;
  Self.cdsTagSla.FieldDefs.Clear;

  Self.cdsMesSla.CreateDataSet;
  Self.cdsHoraSla.CreateDataSet;
  Self.cdsDiaSla.CreateDataSet;
  Self.cdsDiaSmSla.CreateDataSet;
  Self.cdsAtendSla.CreateDataSet;
  Self.cdsPASla.CreateDataSet;
  Self.cdsFaixaDeSenhaSla.CreateDataSet;
  Self.cdsFilaEsperaSla.CreateDataSet;
  Self.cdsGrAtendSla.CreateDataSet;
  Self.cdsGrPASla.CreateDataSet;
  Self.cdsUnidadeSla.CreateDataSet;
  Self.cdsTagSla.CreateDataSet;

  LfrmPesquisaRelatorio.cdsUnidades.First;
  while not LfrmPesquisaRelatorio.cdsUnidades.Eof do
  begin

    if not LfrmPesquisaRelatorio.cdsUnidades.FieldByName('SELECIONADO').AsBoolean then
    begin
      LfrmPesquisaRelatorio.cdsUnidades.Next;
      Continue;
    end;

    IdUnidade := LfrmPesquisaRelatorio.cdsUnidades.FieldByName('ID').AsInteger;
    NomeUnidade := LfrmPesquisaRelatorio.cdsUnidades.FieldByName('NOME').AsString;

    PrepararLkpsUnidades;

    // devido a um bug na dbexpress, temos que criar uma nova sqlquery quando muda
    // a conexao, pois o clientedataset nao consegue "enxergar" as mudancas
    qryEstatisticasTemp := TFDQuery.Create(Self);
    try
      qryEstatisticasTemp.Sql.Text := qryEstatisticasSla.Sql.Text;
      qryEstatisticasTemp.Params.Assign(qryEstatisticasSla.Params);
      qryEstatisticasTemp.Connection := DMClient(IDunidade, not CRIAR_SE_NAO_EXISTIR).ConnRelatorio;
      dspEstatisticasSla.DataSet        := qryEstatisticasTemp;

      {$IFDEF DEBUG}
      qryEstatisticasTemp.Prepare;
      ClipBoard.AsText := qryEstatisticasTemp.Text;
      {$ENDIF}
      cdsEstatisticasSla.Open;
      try
        cdsEstatisticasSla.Filtered := true;

        for iAgrupador := AGRUPADOR_MES to AGRUPADOR_FILAESPERA do
        begin
          case iAgrupador of
            AGRUPADOR_MES             : begin
                                          CdsTemp    := cdsMesSla;
                                          sDescricao := 'Mês';
                                        end;
            AGRUPADOR_DIA             : begin
                                          CdsTemp    := cdsDiaSla;
                                          sDescricao := 'Dia';
                                        end;
            AGRUPADOR_SEMANA          : begin
                                          CdsTemp    := cdsDiaSmSla;
                                          sDescricao := 'Semana';
                                        end;
            AGRUPADOR_HORA            : begin
                                          CdsTemp    := cdsHoraSla;
                                          sDescricao := 'Hora';
                                        end;
            AGRUPADOR_ATENDENTE       : begin
                                          CdsTemp    := cdsAtendSla;
                                          sDescricao := 'Atendente';
                                        end;
            AGRUPADOR_GRUPO_ATENDENTE : begin
                                          CdsTemp    := cdsGrAtendSla;
                                          sDescricao := 'Grupo de Atendente';
                                        end;
            AGRUPADOR_PA              : begin
                                          CdsTemp    := cdsPASla;
                                          sDescricao := 'PA';
                                        end;
            AGRUPADOR_GRUPO_PA        : begin
                                          CdsTemp    := cdsGrPASla;
                                          sDescricao := 'Grupo de PA';
                                        end;
            AGRUPADOR_FAIXADESENHA    : begin
                                          CdsTemp    := cdsFaixaDeSenhaSla;
                                          sDescricao := 'Faixa de Senha';
                                        end;
            AGRUPADOR_FILAESPERA      : begin
                                          CdsTemp    := cdsFilaEsperaSla;
                                          sDescricao := 'Fila Espera';
                                        end;
            AGRUPADOR_TAG             : begin
                                          CdsTemp    := cdsTagSla;
                                          sDescricao := 'Tag';
                                        end
            else                        begin
                                          CdsTemp    := nil;
                                          sDescricao := '';
                                        end;
          end;

          CdsTemp.FieldByName('NomeUnidade').Visible := (LfrmPesquisaRelatorio.vlRepVars.QtdeUnidadesSelecionadas > 1);

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
                  CdsTemp.Edit;

                  for iEspAtd := 1 to 2 do
                  begin

                    if iEspAtd = 1 then
                      sEspAtd := 'ESP'
                    else
                      sEspAtd := 'ATD';

                    for iCor := 1 to 4 do
                    begin
                      case iCor of
                        1:
                          sCor := 'VERDE';
                        2:
                          sCor := 'AMARELO';
                        3:
                          sCor := 'VERMELHO';
                        4:
                          sCor := 'CINZA';
                      end;

                      sCampoQtde      := sEspAtd + '_QTDE_' + sCor;
                      sCampoPerc      := sEspAtd + '_PERC_' + sCor;
                      sCampoQtdeTotal := sEspAtd + '_QTDE_TOTAL';
                      sCampoQtdeCinza := sEspAtd + '_QTDE_CINZA';

                      // se for cor cinza
                      if iCor = 4 then
                        dblNovoPerc := Dividir((CdsTemp.FieldByName(sCampoQtde).AsInteger + FieldByName(sCampoQtde).AsInteger), (CdsTemp.FieldByName(sCampoQtdeTotal).AsInteger + FieldByName(sCampoQtdeTotal).AsInteger)) * 100
                      else
                        dblNovoPerc := Dividir((CdsTemp.FieldByName(sCampoQtde).AsInteger + FieldByName(sCampoQtde).AsInteger), (CdsTemp.FieldByName(sCampoQtdeTotal).AsInteger - CdsTemp.FieldByName(sCampoQtdeCinza).AsInteger + FieldByName(sCampoQtdeTotal).AsInteger - FieldByName(sCampoQtdeCinza)
                          .AsInteger)) * 100;

                      CdsTemp.FieldByName(sCampoPerc).AsFloat := dblNovoPerc;
                    end;
                  end;

                end
                else
                begin
                  CdsTemp.Append;
                  CdsTemp.FieldByName('ID').Value               := FieldByName('ID').Value;
                  CdsTemp.FieldByName('ESP_PERC_VERDE').AsFloat := Dividir(FieldByName('ESP_QTDE_VERDE').AsInteger, FieldByName('ESP_QTDE_TOTAL').AsInteger - FieldByName('ESP_QTDE_CINZA').AsInteger) * 100;
                  CdsTemp.FieldByName('ESP_PERC_AMARELO').AsFloat := Dividir(FieldByName('ESP_QTDE_AMARELO').AsInteger, FieldByName('ESP_QTDE_TOTAL').AsInteger - FieldByName('ESP_QTDE_CINZA').AsInteger) * 100;
                  CdsTemp.FieldByName('ESP_PERC_VERMELHO').AsFloat := Dividir(FieldByName('ESP_QTDE_VERMELHO').AsInteger, FieldByName('ESP_QTDE_TOTAL').AsInteger - FieldByName('ESP_QTDE_CINZA').AsInteger) * 100;
                  CdsTemp.FieldByName('ESP_PERC_CINZA').AsFloat := Dividir(FieldByName('ESP_QTDE_CINZA').AsInteger, FieldByName('ESP_QTDE_TOTAL').AsInteger) * 100;
                  CdsTemp.FieldByName('ATD_PERC_VERDE').AsFloat := Dividir(FieldByName('ATD_QTDE_VERDE').AsInteger, FieldByName('ATD_QTDE_TOTAL').AsInteger - FieldByName('ATD_QTDE_CINZA').AsInteger) * 100;
                  CdsTemp.FieldByName('ATD_PERC_AMARELO').AsFloat := Dividir(FieldByName('ATD_QTDE_AMARELO').AsInteger, FieldByName('ATD_QTDE_TOTAL').AsInteger - FieldByName('ATD_QTDE_CINZA').AsInteger) * 100;
                  CdsTemp.FieldByName('ATD_PERC_VERMELHO').AsFloat := Dividir(FieldByName('ATD_QTDE_VERMELHO').AsInteger, FieldByName('ATD_QTDE_TOTAL').AsInteger - FieldByName('ATD_QTDE_CINZA').AsInteger) * 100;
                  CdsTemp.FieldByName('ATD_PERC_CINZA').AsFloat := Dividir(FieldByName('ATD_QTDE_CINZA').AsInteger, FieldByName('ATD_QTDE_TOTAL').AsInteger) * 100;
                  CdsTemp.FieldByName('RECNO').AsInteger    := iRecNo;
                  CdsTemp.FieldByName('DESCRICAO').AsString := GetDescricao(iAgrupador, FieldByName('ID').Value);
                  CdsTemp.FieldByName('IdUnidade').AsInteger := IdUnidade;
                  CdsTemp.FieldByName('NomeUnidade').AsString := NomeUnidade;
                end;

                // nao precisaria destas qtdes abaixo, mas é bom ja guardar caso precise no futuro
                CdsTemp.FieldByName('ESP_QTDE_VERDE').AsInteger := CdsTemp.FieldByName('ESP_QTDE_VERDE').AsInteger + FieldByName('ESP_QTDE_VERDE').AsInteger;
                CdsTemp.FieldByName('ESP_QTDE_AMARELO').AsInteger := CdsTemp.FieldByName('ESP_QTDE_AMARELO').AsInteger + FieldByName('ESP_QTDE_AMARELO').AsInteger;
                CdsTemp.FieldByName('ESP_QTDE_VERMELHO').AsInteger := CdsTemp.FieldByName('ESP_QTDE_VERMELHO').AsInteger + FieldByName('ESP_QTDE_VERMELHO').AsInteger;
                CdsTemp.FieldByName('ESP_QTDE_CINZA').AsInteger := CdsTemp.FieldByName('ESP_QTDE_CINZA').AsInteger + FieldByName('ESP_QTDE_CINZA').AsInteger;
                CdsTemp.FieldByName('ESP_QTDE_TOTAL').AsInteger := CdsTemp.FieldByName('ESP_QTDE_TOTAL').AsInteger + FieldByName('ESP_QTDE_TOTAL').AsInteger;
                CdsTemp.FieldByName('ATD_QTDE_VERDE').AsInteger := CdsTemp.FieldByName('ATD_QTDE_VERDE').AsInteger + FieldByName('ATD_QTDE_VERDE').AsInteger;
                CdsTemp.FieldByName('ATD_QTDE_AMARELO').AsInteger := CdsTemp.FieldByName('ATD_QTDE_AMARELO').AsInteger + FieldByName('ATD_QTDE_AMARELO').AsInteger;
                CdsTemp.FieldByName('ATD_QTDE_VERMELHO').AsInteger := CdsTemp.FieldByName('ATD_QTDE_VERMELHO').AsInteger + FieldByName('ATD_QTDE_VERMELHO').AsInteger;
                CdsTemp.FieldByName('ATD_QTDE_CINZA').AsInteger := CdsTemp.FieldByName('ATD_QTDE_CINZA').AsInteger + FieldByName('ATD_QTDE_CINZA').AsInteger;
                CdsTemp.FieldByName('ATD_QTDE_TOTAL').AsInteger := CdsTemp.FieldByName('ATD_QTDE_TOTAL').AsInteger + FieldByName('ATD_QTDE_TOTAL').AsInteger;

                CdsTemp.Post;

                Next;
              end;

              if CdsTemp <> nil then
              begin
                CdsTemp.FieldByName('ESP_PERC_VERDE').Visible   := chkSlaEspera.IsChecked;
                CdsTemp.FieldByName('ESP_PERC_AMARELO').Visible := chkSlaEspera.IsChecked;
                CdsTemp.FieldByName('ESP_PERC_VERMELHO').Visible := chkSlaEspera.IsChecked;
                CdsTemp.FieldByName('ESP_PERC_CINZA').Visible := chkSlaEspera.IsChecked;

                CdsTemp.FieldByName('ATD_PERC_VERDE').Visible   := chkSlaAtendimento.IsChecked;
                CdsTemp.FieldByName('ATD_PERC_AMARELO').Visible := chkSlaAtendimento.IsChecked;
                CdsTemp.FieldByName('ATD_PERC_VERMELHO').Visible := chkSlaAtendimento.IsChecked;
                CdsTemp.FieldByName('ATD_PERC_CINZA').Visible := chkSlaAtendimento.IsChecked;

                CdsTemp.First;
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
            cdsUnidadeSla.FieldByName('ID').AsInteger           := IdUnidade;
            cdsUnidadeSla.FieldByName('DESCRICAO').AsString     := dmUnidades.Nome[IdUnidade];
            cdsUnidadeSla.FieldByName('ESP_PERC_VERDE').AsFloat := Dividir(FieldByName('ESP_QTDE_VERDE').AsInteger, FieldByName('ESP_QTDE_TOTAL').AsInteger - FieldByName('ESP_QTDE_CINZA').AsInteger) * 100;
            cdsUnidadeSla.FieldByName('ESP_PERC_AMARELO').AsFloat := Dividir(FieldByName('ESP_QTDE_AMARELO').AsInteger, FieldByName('ESP_QTDE_TOTAL').AsInteger - FieldByName('ESP_QTDE_CINZA').AsInteger) * 100;
            cdsUnidadeSla.FieldByName('ESP_PERC_VERMELHO').AsFloat := Dividir(FieldByName('ESP_QTDE_VERMELHO').AsInteger, FieldByName('ESP_QTDE_TOTAL').AsInteger - FieldByName('ESP_QTDE_CINZA').AsInteger) * 100;
            cdsUnidadeSla.FieldByName('ESP_PERC_CINZA').AsFloat := Dividir(FieldByName('ESP_QTDE_CINZA').AsInteger, FieldByName('ESP_QTDE_TOTAL').AsInteger) * 100;
            cdsUnidadeSla.FieldByName('ATD_PERC_VERDE').AsFloat := Dividir(FieldByName('ATD_QTDE_VERDE').AsInteger, FieldByName('ATD_QTDE_TOTAL').AsInteger - FieldByName('ATD_QTDE_CINZA').AsInteger) * 100;
            cdsUnidadeSla.FieldByName('ATD_PERC_AMARELO').AsFloat := Dividir(FieldByName('ATD_QTDE_AMARELO').AsInteger, FieldByName('ATD_QTDE_TOTAL').AsInteger - FieldByName('ATD_QTDE_CINZA').AsInteger) * 100;
            cdsUnidadeSla.FieldByName('ATD_PERC_VERMELHO').AsFloat := Dividir(FieldByName('ATD_QTDE_VERMELHO').AsInteger, FieldByName('ATD_QTDE_TOTAL').AsInteger - FieldByName('ATD_QTDE_CINZA').AsInteger) * 100;
            cdsUnidadeSla.FieldByName('ATD_PERC_CINZA').AsFloat := Dividir(FieldByName('ATD_QTDE_CINZA').AsInteger, FieldByName('ATD_QTDE_TOTAL').AsInteger) * 100;
            cdsUnidadeSla.FieldByName('RECNO').AsInteger := IdUnidade + 1;
            // nao precisaria destas qtdes abaixo, mas é bom ja guardar caso precise no futuro
            cdsUnidadeSla.FieldByName('ESP_QTDE_VERDE').Value   := FieldByName('ESP_QTDE_VERDE').Value;
            cdsUnidadeSla.FieldByName('ESP_QTDE_AMARELO').Value := FieldByName('ESP_QTDE_AMARELO').Value;
            cdsUnidadeSla.FieldByName('ESP_QTDE_VERMELHO').Value := FieldByName('ESP_QTDE_VERMELHO').Value;
            cdsUnidadeSla.FieldByName('ESP_QTDE_CINZA').Value   := FieldByName('ESP_QTDE_CINZA').Value;
            cdsUnidadeSla.FieldByName('ESP_QTDE_TOTAL').Value   := FieldByName('ESP_QTDE_TOTAL').Value;
            cdsUnidadeSla.FieldByName('ATD_QTDE_VERDE').Value   := FieldByName('ATD_QTDE_VERDE').Value;
            cdsUnidadeSla.FieldByName('ATD_QTDE_AMARELO').Value := FieldByName('ATD_QTDE_AMARELO').Value;
            cdsUnidadeSla.FieldByName('ATD_QTDE_VERMELHO').Value := FieldByName('ATD_QTDE_VERMELHO').Value;
            cdsUnidadeSla.FieldByName('ATD_QTDE_CINZA').Value := FieldByName('ATD_QTDE_CINZA').Value;
            cdsUnidadeSla.FieldByName('ATD_QTDE_TOTAL').Value := FieldByName('ATD_QTDE_TOTAL').Value;
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

    LfrmPesquisaRelatorio.cdsUnidades.Next;
  end;

  AtualizarColunasGrid;
end;

procedure TfrmSicsGraphics.chkSlaCinzaChange(Sender: TObject);
begin
  inherited;

  dbChartSla.Series[3].Active := chkSlaCinza.IsChecked and chkSlaEspera.IsChecked;
  dbChartSla.Series[7].Active := chkSlaCinza.IsChecked and chkSlaAtendimento.IsChecked;
end;

procedure TfrmSicsGraphics.chkSlaEsperaChange(Sender: TObject);
begin
  inherited;

  dbChartSla.Series[0].Active := chkSlaEspera.IsChecked;
  dbChartSla.Series[1].Active := chkSlaEspera.IsChecked;
  dbChartSla.Series[2].Active := chkSlaEspera.IsChecked;
  dbChartSla.Series[3].Active := chkSlaEspera.IsChecked and chkSlaCinza.IsChecked;

  if not chkSlaEspera.IsChecked then
  begin
    dbChartSla.Series[4].XLabelsSource := 'TIPO_ATD_ESP_DCR';
    dbChartSla.Series[4].HorizAxis     := aTopAxis;
    dbChartSla.Series[5].XLabelsSource := 'DESCRICAO';
    dbChartSla.Series[5].HorizAxis     := aBottomAxis;
  end;
end;

procedure TfrmSicsGraphics.chkSlaAtendimentoChange(Sender: TObject);
begin
  inherited;

  dbChartSla.Series[4].Active := chkSlaAtendimento.IsChecked;
  dbChartSla.Series[5].Active := chkSlaAtendimento.IsChecked;
  dbChartSla.Series[6].Active := chkSlaAtendimento.IsChecked;
  dbChartSla.Series[7].Active := chkSlaAtendimento.IsChecked and chkSlaCinza.IsChecked;
end;

procedure TfrmSicsGraphics.dbChartSlaMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Single);
begin
  inherited;
  //
end;

destructor TfrmSicsGraphics.Destroy;
begin
  cdsMes.Close;
  cdsDia.Close;
  cdsDiaSm.Close;
  cdsHora.Close;
  cdsAtend.Close;
  cdsCliente.Close;
  cdsPA.Close;
  cdsFaixaDeSenha.Close;
  cdsFilaEspera.Close;
  cdsGrAtend.Close;
  cdsGrPA.Close;
  cdsTag.Close;
  cdsUnidade.Close;
  inherited;
end;

procedure TfrmSicsGraphics.PageControlGridsChange(Sender: TObject);


  procedure ConfiguraChart(const aDS: TClientDataSet; const aFieldSource: String; aFieldLabel: String = '';
    const aLabelsAngle: Integer= 0);
  begin
    ConfiguraDBChart(PieSeries6, dbChartTmeTma, aDS, aFieldSource, aFieldLabel, aLabelsAngle);
  end;

  procedure ConfiguraGraficoSla;
  var
    DS    : TClientDataSet;
    iSerie: Integer;
  begin
    case PageControlGrids.TabIndex of
      0:
        DS := cdsMesSla;
      1:
        DS := cdsDiaSla;
      2:
        DS := cdsDiaSmSla;
      3:
        DS := cdsHoraSla;
      4:
        DS := cdsAtendSla;
      5:
        DS := cdsGrAtendSla;
      6:
        DS := cdsPASla;
      7:
        DS := cdsGrPASla;
      8:
        DS := cdsFilaEsperaSla;
      9:
        DS := cdsFaixaDeSenhaSla;
      10:
        DS := cdsTagSla;
      11:
        DS := cdsUnidadeSla;
    else
      DS := nil;
    end;
    for iSerie                             := 0 to dbChartSla.SeriesList.Count - 1 do
      dbChartSla.Series[iSerie].DataSource := DS;

    if PageControlGrids.TabIndex > 3 then
      dbChartSla.BottomAxis.LabelsAngle := 90
    else
      dbChartSla.BottomAxis.LabelsAngle := 0;
  end;
begin
  if not Self.Visible then
    Exit;

  pnlGraficosTmeTma.Visible := not FGraficoSla;

  if FGraficoSla then
    ConfiguraGraficoSla
  else
  begin
    pnlGraficosTmeTma.Visible := True;
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
            ConfiguraChart(cdsAtend, 'AtdRecNo', 'AtdNome', 90);
          end;
      5 : begin
            ConfiguraChart(cdsGrAtend, 'GrAtendRecNo', 'GrAtendNome', 90);
          end;
      6 : begin
            ConfiguraChart(cdsPA, 'PARecNo', 'PANome', 90);
          end;
     7 : begin
            ConfiguraChart(cdsGrPA, 'GrPARecNo', 'GrPANome', 90);
          end;

     8 : begin
            ConfiguraChart(cdsFilaEspera, 'FilaEsperaRecNo', 'FilaEsperaNome', 90);
          end;
     9 : begin
            ConfiguraChart(cdsFaixaDeSenha, 'FaixaDeSenhaRecNo', 'FaixaDeSenhaNome', 90);
          end;
     10 : begin
            ConfiguraChart(cdsTag, 'TAGRecNo', 'TAGNome', 90);
          end;
     11 : begin
            ConfiguraChart(cdsUnidade, 'UnidadeRecNo', 'UnidadeNome', 90);
          end;
     12 : begin
            ConfiguraChart(cdsCliente, 'ClienteRecNo', 'ClienteNome', 90);
          end;
    end; // case
  end;

  TMECheckBox.IsChecked := (PageControlGrids.ActiveTab <> tbsAtendentes) and (PageControlGrids.ActiveTab <> tbsPA);
  AtualizarColunasGrid;
end;

procedure TfrmSicsGraphics.PrepararLkpsUnidades;
var
  LfrmPesquisaRelatorio: TfrmPesquisaRelatorio;

  procedure CopiarNestedDataSet(const AFieldName: string; ADataSetLkp: TClientDataSet);
  var
    LCDSCopia: TClientDataSet;
  begin
    LCDSCopia := TClientDataSet.Create(nil);
    try
      LCDSCopia.DataSetField := TDataSetField(LfrmPesquisaRelatorio.cdsUnidades.FieldByName(AFieldName));

      if ADataSetLkp.Active then
        ADataSetLkp.EmptyDataSet
      else
        ADataSetLkp.CreateDataSet;

      LCDSCopia.First;
      while not LCDSCopia.Eof do
      begin
        ADataSetLkp.Append;
        ADataSetLkp.FieldByName('ID').Value   := LCDSCopia.FieldByName('ID').Value;
        ADataSetLkp.FieldByName('NOME').Value := LCDSCopia.FieldByName('NOME').Value;
        ADataSetLkp.Post;
        LCDSCopia.Next;
      end;
    finally
      FreeAndNil(LCDSCopia);
    end;
  end;

begin
  LfrmPesquisaRelatorio := (Owner as TfrmPesquisaRelatorio);
  CopiarNestedDataSet('ATENDENTES', cdsLkpAtendentes);
  CopiarNestedDataSet('PAS', cdsLkpPAS);
  CopiarNestedDataSet('FILAS', cdsLkpFaixaDeSenhas);
  CopiarNestedDataSet('TAGS', cdsLkpTags);
  CopiarNestedDataSet('GRUPOS_ATENDENTES', cdsLkpGruposAtendentes);
  CopiarNestedDataSet('GRUPOS_PAS', cdsLkpGruposPAs);
  CopiarNestedDataSet('CLIENTES', cdsLkpClientes);
end;

procedure TfrmSicsGraphics.cdsMesAfterOpen(DataSet: TDataSet);
begin
  with DataSet do
  begin
    FieldByName('MaxTE').Visible := vgParametrosModulo.ReportarTemposMaximos;
    FieldByName('MaxTA').Visible := vgParametrosModulo.ReportarTemposMaximos;
  end;
end;

procedure TfrmSicsGraphics.cdsTagTagNomeGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := 'Não classificado'
  else
    Text := Sender.AsString;
end;

procedure TfrmSicsGraphics.StringField20GetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if Sender.AsString = '' then
    Text := 'Não classificado'
  else
    Text := Sender.AsString;
end;

procedure TfrmSicsGraphics.cdsFilaEsperaCalcFields(DataSet: TDataSet);
begin
  cdsFilaEsperaFilaEsperaRecNo.AsInteger := cdsFilaEspera.RecNo;
end;

procedure TfrmSicsGraphics.cdsFilaEsperaFilaEsperaNomeGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if Sender.IsNull then
    Text := '(nenhuma)'
  else
    Text := Sender.AsString;
end;

procedure TfrmSicsGraphics.StringField22GetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  if Sender.AsString = '' then
    Text := '(nenhuma)'
  else
    Text := Sender.AsString;
end;

procedure TfrmSicsGraphics.ComponentesCallCenter;
begin
  lblSenha.Text                 := 'Mesas';
  lblAtendente.Text             := 'Coordenador';
  lblFaixaSenhas.Text           := 'Faixa Mesas';
  tbsAtendentes.Text            := 'Coordenadores';
  tbsClientes.Text              := 'Atendentes';
  tbsGrupoAtendente.Text        := 'Grupo de Coordenadores';
  tbsFaixaSenha.Text            := 'Faixa de Mesas';
  cdsMesMaxTA.Visible           := False;
  cdsClienteTMA.Visible         := False;
  tbsTag.Visible                := False;
  tbsPA.Visible                 := False;
  tbsGrupoPA.Visible            := False;
  lblTags.Visible               := False;
  lblUnidades.Visible           := False;
  TagsLabel.Visible             := False;
  lblUnidadesVal.Visible        := False;
  lblPas.Visible                := False;
  PAsLabel.Visible              := False;
  QtdEspLabel.Visible           := False;
  lblQtdAtdLabel.Visible        := False;
  lblTMALabel.Visible           := False;
  TMALabel.Visible              := False;
  TMACheckBox.IsChecked         := False;
  TMACheckBox.Visible           := False;
  tbsClientes.Visible           := True;
  lblFaixaSenhas.Position.Y     := 103;
  FaixaDeSenhaLabel.Position.Y  := 103;
  rectDadosDestaPesquisa.Height := 135;
  QtdEspAtdCombo.Items.Clear;
  QtdEspAtdCombo.Items.Add('Espera');
end;

end.
