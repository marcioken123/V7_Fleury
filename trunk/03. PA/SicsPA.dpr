program SicsPA;

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  {$IFNDEF IS_MOBILE}
  MidasLib,
  Windows,
  {$ENDIF }
  FMX.Forms,
  FMX.Dialogs,
  untLog in '..\Common\Library\untLog.pas',
  AspJson in '..\Common\Library\AspJson.pas',
  untCommonDMConnection in '..\Common\untCommonDMConnection.pas' {DMConnection: TDataModule},
  untCommonDMClient in '..\Common\untCommonDMClient.pas' {DMClient: TDataModule},
  untCommonFormBasePA in '..\Common\untCommonFormBasePA.pas' {FrmBase_PA_MPA},
  untCommonFormBase in '..\Common\untCommonFormBase.pas' {FrmBase},
  untCommonFormBaseSelecao in '..\Common\untCommonFormBaseSelecao.pas' {FrmBaseSelecao},
  untCommonFormSelecaoFila in '..\Common\untCommonFormSelecaoFila.pas' {FrmSelecaoFila},
  untCommonFormSelecaoPP in '..\Common\untCommonFormSelecaoPP.pas' {FrmSelecaoPP},
  untCommonFormSelecaoMotivoPausa in '..\Common\untCommonFormSelecaoMotivoPausa.pas' {FrmSelecaoMotivoPausa},
  untCommonFormProcessoParalelo in '..\Common\untCommonFormProcessoParalelo.pas' {FrmProcessoParalelo},
  untCommonFormLogin in '..\Common\untCommonFormLogin.pas' {FrmLogin},
  untCommonFormAlteracaoSenha in '..\Common\untCommonFormAlteracaoSenha.pas' {FrmAlteracaoSenha},
  Sics_Common_LCDBInput in '..\Common\Sics_Common_LCDBInput.pas' {frmSicsCommon_LCDBInput},
  untCommonFrameBase in '..\Common\untCommonFrameBase.pas' {FrameBase: TFrame},
  Sics_Common_Parametros in '..\Common\Sics_Common_Parametros.pas',
  untFrmConfigParametros in '..\Common\untFrmConfigParametros.pas' {FrmConfigParametros},
  untSicsPA in 'untSicsPA.pas' {FrmSicsPA},
  untScreenSaver in 'untScreenSaver.pas' {FrmScreenSaver},
  MyAspFuncoesUteis in '..\Common\Library\MyAspFuncoesUteis.pas',
  uNotificacaoPopup in '..\Common\uNotificacaoPopup.pas' {NotificacaoPopup},
  untCommonFormStyleBook in '..\Common\untCommonFormStyleBook.pas' {frmStyleBook},
  untCommonTEdit in '..\Common\untCommonTEdit.pas',
  untCommonTCombobox in '..\Common\untCommonTCombobox.pas',
  untCommonDMUnidades in '..\Common\untCommonDMUnidades.pas' {dmUnidades: TDataModule},
  untCommonControleInstanciaAplicacao in '..\Common\untCommonControleInstanciaAplicacao.pas' {dmControleInstanciaAplicacao: TDataModule},
  untCommonFormControleRemoto in '..\Common\untCommonFormControleRemoto.pas' {FrmControleRemoto},
  untCommonControleInstanciasTelas in '..\Common\untCommonControleInstanciasTelas.pas' {/  MyDebug in '..\MyDebug.pas';: TDataModule},
  UConexaoBD in '..\Common\UConexaoBD.pas',
  ASPGenerator in '..\..\..\..\00. Library\Common\Rio\ASPGenerator.pas',
  uDataSetHelper in '..\Common\uDataSetHelper.pas',
  APIs.Common in '..\Common\APIs\APIs.Common.pas',
  LogSQLite.Config in '..\Common\Library\LogSQLite.Config.pas',
  LogSQLite in '..\Common\Library\LogSQLite.pas',
  LogSQLite.Helper in '..\Common\Library\LogSQLite.Helper.pas',
  LogSQLite.LogExceptions in '..\Common\Library\LogSQLite.LogExceptions.pas',
  LogSQLite.DB in '..\Common\Library\LogSQLite.DB.pas' {LogSQLiteDB: TDataModule},
  ASPHTTPRequest in '..\..\..\..\00. Library\Common\Rio\ASPHTTPRequest.pas',
  untCommonFormDadosAdicionais in '..\Common\untCommonFormDadosAdicionais.pas' {FrmDadosAdicionais},
  uFormat in '..\Common\Library\uFormat.pas',
  APIs.Aspect.Sics.SeguirAtendimento in '..\Common\APIs\Aspect\APIs.Aspect.Sics.SeguirAtendimento.pas',
  APIs.Aspect.Sics.ImprimirEtiqueta in '..\Common\APIs\Aspect\APIs.Aspect.Sics.ImprimirEtiqueta.pas',
  APIs.Aspect.Sics.BuscarParametro in '..\Common\APIs\Aspect\APIs.Aspect.Sics.BuscarParametro.pas';

//  MyDebug in '..\MyDebug.pas';

{$R *.res}

const
  APP_TITLE = 'SICS - PA';

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

  Application.CreateForm(TdmUnidades, dmUnidades);
  Application.CreateForm(TFrmSicsPA, FrmSicsPA);
  Application.CreateForm(TfrmStyleBook, frmStyleBook);
  Application.Run;
end.
