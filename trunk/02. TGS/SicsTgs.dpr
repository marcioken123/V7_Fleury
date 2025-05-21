program SicsTgs;

{$INCLUDE ..\AspDefineDiretivas.inc}
uses
  MidasLib,
  System.StartUpCopy,
  FMX.Forms,
  FMX.Platform.Win,
  System.sysutils,
  System.IniFiles,
  Sics_Common_Parametros in '..\Common\Sics_Common_Parametros.pas',
  AspJson in '..\Common\Library\AspJson.pas',
  ufrmMensagemPainelEImpressora in 'ufrmMensagemPainelEImpressora.pas' {FrmMensagemPainelEImpressora: TDataModule},
  untCommonDMClient in '..\Common\untCommonDMClient.pas' {DMClient: TDataModule},
  untCommonFormAlteracaoSenha in '..\Common\untCommonFormAlteracaoSenha.pas' {FrmAlteracaoSenha},
  untCommonFormBase in '..\Common\untCommonFormBase.pas' {FrmBase},
  untCommonFormBaseOnLineTGS in '..\Common\untCommonFormBaseOnLineTGS.pas' {FrmBase_OnLine_TGS},
  untCommonFormBaseSelecao in '..\Common\untCommonFormBaseSelecao.pas' {FrmBaseSelecao},
  untCommonFormLogin in '..\Common\untCommonFormLogin.pas' {FrmLogin},
  untCommonFormProcessoParalelo in '..\Common\untCommonFormProcessoParalelo.pas' {FrmProcessoParalelo},
  untCommonFormSelecaoMotivoPausa in '..\Common\untCommonFormSelecaoMotivoPausa.pas' {FrmSelecaoMotivoPausa},
  untCommonFormSelecaoPP in '..\Common\untCommonFormSelecaoPP.pas' {FrmSelecaoPP},
  untCommonFrameBase in '..\Common\untCommonFrameBase.pas' {FrameBase: TFrame},
  untCommonFrameIndicadorPerformance in '..\Common\untCommonFrameIndicadorPerformance.pas' {FraIndicadorPerformance: TFrame},
  untCommonFrameSituacaoAtendimento in '..\Common\untCommonFrameSituacaoAtendimento.pas' {FraSituacaoAtendimento: TFrame},
  untFrmConfigParametros in '..\Common\untFrmConfigParametros.pas' {FrmConfigParametros},
  untLog in '..\Common\Library\untLog.pas',
  udmCadBase in 'udmCadBase.pas' {dmSicsCadBase: TDataModule},
  Sics_Common_Splash in '..\Common\Sics_Common_Splash.pas' {frmSicsSplash},
  ufrmParamsGraficoSLA in 'ufrmParamsGraficoSLA.pas' {frmSicsParamsGraficoSLA},
  ufrmCadAlarmes in 'ufrmCadAlarmes.pas' {frmSicsCadAlarmes},
  ufrmCadPIS in 'ufrmCadPIS.pas' {frmSicsCadPIS},
  ufrmCadNiveis in 'ufrmCadNiveis.pas' {frmSicsCadNiveis},
  ufrmCadHor in 'ufrmCadHor.pas' {frmSicsCadHor},
  ufrmCadBase in 'ufrmCadBase.pas' {frmSicsCadBase},
  udmCadPIS in 'udmCadPIS.pas' {dmSicsCadPIS: TDataModule},
  udmCadNiveis in 'udmCadNiveis.pas' {dmSicsCadNiveis},
  udmCadHor in 'udmCadHor.pas' {dmSicsCadHor: TDataModule},
  untMainForm in 'untMainForm.pas' {MainForm},
  udmCadAlarmes in 'udmCadAlarmes.pas' {dmSicsCadAlarmes: TDataModule},
  ufrmConfigPrioridades in 'ufrmConfigPrioridades.pas' {frmSicsConfigPrioridades},
  ufrmDadosPorUnidade in 'ufrmDadosPorUnidade.pas' {frmDadosPorUnidade},
  ufrmReportBase in 'ufrmReportBase.pas' {frmReportBase},
  ufrmParamsSLABase in 'ufrmParamsSLABase.pas' {frmParamsSLABase},
  ufrmParamsNiveisSLA in 'ufrmParamsNiveisSLA.pas' {frmSicsParamsNiveisSLA},
  ufrmReportCustom in 'ufrmReportCustom.pas' {frmSicsReportCustom},
  ufrmReportPP in 'ufrmReportPP.pas' {frmReportPP},
  ufrmReportPausas in 'ufrmReportPausas.pas' {frmReportPausas},
  ufrmPesquisaRelatorioBase in 'ufrmPesquisaRelatorioBase.pas' {frmPesquisaRelatorioBase},
  ufrmPesquisaRelatorio in 'ufrmPesquisaRelatorio.pas' {frmPesquisaRelatorio},
  ufrmPesquisaRelatorioPP in 'ufrmPesquisaRelatorioPP.pas' {frmPesquisaRelatorioPP},
  ufrmLines in 'ufrmLines.pas' {frmLines},
  ufrmPesquisaRelatorioPausas in 'ufrmPesquisaRelatorioPausas.pas' {frmPesquisaRelatorioPausas},
  ufrmGraphics in 'ufrmGraphics.pas' {frmGraphics},
  ufrmGraphicsBase in 'ufrmGraphicsBase.pas' {frmGraphicsBase},
  ufrmGraphicsPausas in 'ufrmGraphicsPausas.pas' {frmGraphicsPausas},
  ufrmGraphicsPP in 'ufrmGraphicsPP.pas' {frmGraphicsPP},
  ufrmConfiguraTabela in 'ufrmConfiguraTabela.pas' {frmConfiguraTabela},
  ufrmReport in 'ufrmReport.pas' {frmSicsReport: TFrame},
  untCommonDMConnection in '..\Common\untCommonDMConnection.pas' {DMConnection: TDataModule},
  MyAspFuncoesUteis in '..\Common\Library\MyAspFuncoesUteis.pas',
  untCommonFormStyleBook in '..\Common\untCommonFormStyleBook.pas' {frmStyleBook},
  untCommonTCombobox in '..\Common\untCommonTCombobox.pas',
  untCommonTEdit in '..\Common\untCommonTEdit.pas',
  untCommonDMUnidades in '..\Common\untCommonDMUnidades.pas' {dmUnidades: TDataModule},
  ufrmMonitorUnidades in 'ufrmMonitorUnidades.pas' {frmMonitorUnidades},
  untCommonControleInstanciasTelas in '..\Common\untCommonControleInstanciasTelas.pas',
  untCommonFormSelecaoGrupoAtendente in '..\Common\untCommonFormSelecaoGrupoAtendente.pas' {FrmSelecaoGrupoAtendente},
  ufrmDashboard in 'ufrmDashboard.pas' {fraDashboard: TFrame},
  untCommonControleInstanciaAplicacao in '..\Common\untCommonControleInstanciaAplicacao.pas' {dmControleInstanciaAplicacao: TDataModule},
  uPI in '..\Common\uPI.pas',
  ufrmPesquisaRelatorioCallCenter in 'ufrmPesquisaRelatorioCallCenter.pas' {frmPesquisaRelatorioCallCenter},
  UConexaoBD in '..\Common\UConexaoBD.pas',
  ASPGenerator in '..\..\..\..\00. Library\Common\Rio\ASPGenerator.pas',
  ASPHTTPRequest in '..\..\..\..\00. Library\Common\Rio\ASPHTTPRequest.pas',
  uDataSetHelper in '..\Common\uDataSetHelper.pas',
  ufrmPesquisaRelatorioSitef in 'ufrmPesquisaRelatorioSitef.pas' {frmPesquisaRelatorioSitef},
  ufrmExportarEmail in 'ufrmExportarEmail.pas' {frmExportarEmail},
  APIs.Common in '..\Common\APIs\APIs.Common.pas',
  untCommonFormDadosAdicionais in '..\Common\untCommonFormDadosAdicionais.pas' {FrmDadosAdicionais},
  APIs.Einstein.ImprimirEtiqueta in '..\Common\APIs\Einstein\APIs.Einstein.ImprimirEtiqueta.pas',
  APIs.Aspect.Sics.DadosAdicionais in '..\Common\APIs\Aspect\APIs.Aspect.Sics.DadosAdicionais.pas',
  repGraph in 'repGraph.pas',
  repGraphBase in 'repGraphBase.pas' {qrSicsGraphicBase: TQuickRep},
  repGraphPausas in 'repGraphPausas.pas' {qrSicsGraphicPausas: TQuickRep},
  repGraphPP in 'repGraphPP.pas' {qrSicsGraphicPP: TQuickRep},
  repPrview in 'repPrview.pas' {frmSicsRepPreview},
  repDetailBase in 'repDetailBase.pas' {qrSicsDetailBase: TQuickRep},
  repDetail in 'repDetail.pas' {qrSicsDetail: TQuickRep},
  repDetailPausas in 'repDetailPausas.pas' {qrSicsDetailPausas: TQuickRep},
  repDetailPS in 'repDetailPS.pas' {qrSicsDetailPS: TQuickRep},
  repDetailTotem in 'repDetailTotem.pas' {qrSicsDetailTotem: TQuickRep},
  repGraphTotem in 'repGraphTotem.pas' {qrSicsGraphicTotem: TQuickRep},
  ufrmPesquisaRelatorioTotem in 'ufrmPesquisaRelatorioTotem.pas' {frmPesquisaRelatorioTotem},
  ufrmReportTotem in 'ufrmReportTotem.pas' {frmSicsReportTotem: TFrame},
  LogSQLite in '..\Common\Library\LogSQLite.pas',
  LogSQLite.LogExceptions in '..\Common\Library\LogSQLite.LogExceptions.pas',
  APIs.Aspect.Sics.ImprimirEtiqueta in '..\Common\APIs\Aspect\APIs.Aspect.Sics.ImprimirEtiqueta.pas',
  LogSQLite.Config in '..\Common\Library\LogSQLite.Config.pas',
  LogSQLite.DB in '..\Common\Library\LogSQLite.DB.pas' {LogSQLiteDB: TDataModule},
  LogSQLite.Helper in '..\Common\Library\LogSQLite.Helper.pas',
  uFormat in '..\Common\Library\uFormat.pas';

{$R *.res}

const
  APP_TITLE = 'SICS - TGS';

var
  APPLICATION_TITLE: String;

begin
  {$IFDEF DEBUG}
  //ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  APPLICATION_TITLE := APP_TITLE + ' ' + ParamStr(0);

  VerificaInstanciaApp(PWideChar(APPLICATION_TITLE));
  Application.Initialize;
  Application.Title := APPLICATION_TITLE;
  Application.OnException := TLog.MyException;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait, TFormOrientation.InvertedPortrait, TFormOrientation.Landscape, TFormOrientation.InvertedLandscape];
  Application.CreateForm(TdmUnidades, dmUnidades);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
