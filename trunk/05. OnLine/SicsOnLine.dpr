program SicsOnLine;

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  {$IFNDEF IS_MOBILE}
  MidasLib,
  Windows,
  {$ENDIF }
  FMX.Forms,
  AspJson in '..\Common\Library\AspJson.pas',
  ASPHTTPRequest in '..\..\..\..\00. Library\Common\Rio\ASPHTTPRequest.pas',
  untCommonFormBase in '..\Common\untCommonFormBase.pas' {FrmBase},
  untCommonFormBaseSelecao in '..\Common\untCommonFormBaseSelecao.pas' {FrmBaseSelecao},
  untCommonFormAlteracaoSenha in '..\Common\untCommonFormAlteracaoSenha.pas' {FrmAlteracaoSenha},
  untCommonFormLogin in '..\Common\untCommonFormLogin.pas' {FrmLogin},
  untCommonFormProcessoParalelo in '..\Common\untCommonFormProcessoParalelo.pas' {FrmProcessoParalelo},
  untCommonFormSelecaoMotivoPausa in '..\Common\untCommonFormSelecaoMotivoPausa.pas' {FrmSelecaoMotivoPausa},
  untCommonFormSelecaoPP in '..\Common\untCommonFormSelecaoPP.pas' {FrmSelecaoPP},
  untCommonDMClient in '..\Common\untCommonDMClient.pas' {DMClient: TDataModule},
  untSicsOnLine in 'untSicsOnLine.pas' {FrmSicsOnLine},
  untLog in '..\Common\Library\untLog.pas',
  untCommonFormBaseOnLineTGS in '..\Common\untCommonFormBaseOnLineTGS.pas' {FrmBase_OnLine_TGS},
  untCommonFrameBase in '..\Common\untCommonFrameBase.pas' {FrameBase: TFrame},
  untCommonFrameSituacaoEspera in '..\Common\untCommonFrameSituacaoEspera.pas' {FraSituacaoEspera: TFrame},
  untCommonFrameSituacaoAtendimento in '..\Common\untCommonFrameSituacaoAtendimento.pas' {FraSituacaoAtendimento: TFrame},
  untFrmConfigParametros in '..\Common\untFrmConfigParametros.pas' {FrmConfigParametros},
  untCommonFrameIndicadorPerformance in '..\Common\untCommonFrameIndicadorPerformance.pas' {FraIndicadorPerformance: TFrame},
  MyAspFuncoesUteis in '..\Common\Library\MyAspFuncoesUteis.pas',
  untCommonFormStyleBook in '..\Common\untCommonFormStyleBook.pas' {frmStyleBook},
  untCommonTEdit in '..\Common\untCommonTEdit.pas',
  untCommonTCombobox in '..\Common\untCommonTCombobox.pas',
  untCommonControleInstanciasTelas in '..\Common\untCommonControleInstanciasTelas.pas',
  Sics_Commom_Splash_Fmx in '..\Common\Sics_Commom_Splash_Fmx.pas' {frmSICSSplashFmx},
  untCommonControleInstanciaAplicacao in '..\Common\untCommonControleInstanciaAplicacao.pas' {dmControleInstanciaAplicacao: TDataModule},
  uCriadorFila in '..\Common\uCriadorFila.pas',
  uConstsCriacaoFilas in '..\Common\uConstsCriacaoFilas.pas',
  UConexaoBD in '..\Common\UConexaoBD.pas',
  ASPGenerator in '..\..\..\..\00. Library\Common\Tokyo\ASPGenerator.pas',
  uPI in '..\Common\uPI.pas',
  Sics_Common_Parametros in '..\Common\Sics_Common_Parametros.pas',
  untCommonDMConnection in '..\Common\untCommonDMConnection.pas' {DMConnection: TDataModule},
  untCommonDMUnidades in '..\Common\untCommonDMUnidades.pas' {dmUnidades: TDataModule},
  APIs.Common in '..\Common\APIs\APIs.Common.pas',
  LogSQLite in '..\Common\Library\LogSQLite.pas',
  LogSQLite.Helper in '..\Common\Library\LogSQLite.Helper.pas',
  LogSQLite.DB in '..\Common\Library\LogSQLite.DB.pas' {LogSQLiteDB: TDataModule},
  LogSQLite.Config in '..\Common\Library\LogSQLite.Config.pas',
  LogSQLite.LogExceptions in '..\Common\Library\LogSQLite.LogExceptions.pas',
  untCommonFormDadosAdicionais in '..\Common\untCommonFormDadosAdicionais.pas' {FrmDadosAdicionais},
  uFormat in '..\Common\Library\uFormat.pas',
  APIs.Aspect.Sics.BuscarParametro in '..\Common\APIs\Aspect\APIs.Aspect.Sics.BuscarParametro.pas',
  APIs.Aspect.Sics.ImprimirEtiqueta in '..\Common\APIs\Aspect\APIs.Aspect.Sics.ImprimirEtiqueta.pas';

{$R *.res}

const
  APP_TITLE = 'SICS - OnLine';

var
  APPLICATION_TITLE: String;

begin
  APPLICATION_TITLE := APP_TITLE + ' ' + ParamStr(0);

  {$IFNDEF IS_MOBILE}
  VerificaInstanciaApp(PWideChar(APPLICATION_TITLE));
  {$ENDIF }

  Application.Initialize;
  Application.Title := APPLICATION_TITLE;
  Application.OnException := TLog.MyException;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait, TFormOrientation.InvertedPortrait, TFormOrientation.Landscape, TFormOrientation.InvertedLandscape];
  TfrmSICSSplashFMX.ShowStatus('Carregando...');
  Application.CreateForm(TdmUnidades, dmUnidades);
  Application.CreateForm(TFrmSicsOnLine, FrmSicsOnLine);
  Application.CreateForm(TfrmStyleBook, frmStyleBook);
  Application.Run;
end.

