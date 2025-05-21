program SicsMultiPA;

uses
  MidasLib,
  FMX.Forms,
  untLog in '..\Common\Library\untLog.pas',
  AspJson in '..\Common\Library\AspJson.pas',
  Sics_Common_Parametros in '..\Common\Sics_Common_Parametros.pas',
  untCommonFormBase in '..\Common\untCommonFormBase.pas' {FrmBase},
  untCommonFormBasePA in '..\Common\untCommonFormBasePA.pas' {FrmBase_PA_MPA},
  untCommonFormBaseSelecao in '..\Common\untCommonFormBaseSelecao.pas' {FrmBaseSelecao},
  untCommonFormLogin in '..\Common\untCommonFormLogin.pas' {FrmLogin},
  untCommonFormSelecaoFila in '..\Common\untCommonFormSelecaoFila.pas' {FrmSelecaoFila: TFrame},
  untCommonFormSelecaoPP in '..\Common\untCommonFormSelecaoPP.pas' {FrmSelecaoPP},
  untCommonFrameBase in '..\Common\untCommonFrameBase.pas' {FrameBase: TFrame},
  untCommonFormProcessoParalelo in '..\Common\untCommonFormProcessoParalelo.pas' {FrmProcessoParalelo},
  untCommonFormSelecaoMotivoPausa in '..\Common\untCommonFormSelecaoMotivoPausa.pas' {FrmSelecaoMotivoPausa},
  untFrmConfigParametros in '..\Common\untFrmConfigParametros.pas' {FrmConfigParametros},
  untCommonFormAlteracaoSenha in '..\Common\untCommonFormAlteracaoSenha.pas' {FrmAlteracaoSenha},
  untSicsMultiPA in 'untSicsMultiPA.pas' {FrmSicsMultiPA},
  untCommonDMClient in '..\Common\untCommonDMClient.pas' {DMClient: TDMClient},
  untCommonDMConnection in '..\Common\untCommonDMConnection.pas' {DMConnection: TDataModule},
  Sics_Common_LCDBInput in '..\Common\Sics_Common_LCDBInput.pas' {frmSicsCommon_LCDBInput},
  MyAspFuncoesUteis in '..\Common\Library\MyAspFuncoesUteis.pas',
  uNotificacaoPopup in '..\Common\uNotificacaoPopup.pas' {NotificacaoPopup},
  untCommonFormStyleBook in '..\Common\untCommonFormStyleBook.pas' {frmStyleBook},
  untCommonTEdit in '..\Common\untCommonTEdit.pas',
  untCommonTCombobox in '..\Common\untCommonTCombobox.pas',
  untCommonDMUnidades in '..\Common\untCommonDMUnidades.pas' {dmUnidades: TDataModule},
  untCommonControleInstanciasTelas in '..\Common\untCommonControleInstanciasTelas.pas',
  untCommonFormControleRemoto in '..\Common\untCommonFormControleRemoto.pas' {FrmControleRemoto},
  untCommonControleInstanciaAplicacao in '..\Common\untCommonControleInstanciaAplicacao.pas' {dmControleInstanciaAplicacao: TDataModule},
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
  APIs.Aspect.Sics.SeguirAtendimento in '..\Common\APIs\Aspect\APIs.Aspect.Sics.SeguirAtendimento.pas',
  APIs.Aspect.Sics.ImprimirEtiqueta in '..\Common\APIs\Aspect\APIs.Aspect.Sics.ImprimirEtiqueta.pas',
  APIs.Aspect.Sics.BuscarParametro in '..\Common\APIs\Aspect\APIs.Aspect.Sics.BuscarParametro.pas',
  uFormat in '..\Common\Library\uFormat.pas';

{$R *.res}

const
  APP_TITLE = 'SICS - MultiPA';

var
  APPLICATION_TITLE: String;

begin
  APPLICATION_TITLE := APP_TITLE + ' ' + ParamStr(0);

  VerificaInstanciaApp(PWideChar(APPLICATION_TITLE));
  Application.Initialize;
  Application.Title := APPLICATION_TITLE;
  Application.OnException := TLog.MyException;
  Application.CreateForm(TdmUnidades, dmUnidades);
  Application.CreateForm(TFrmSicsMultiPA, FrmSicsMultiPA);
  Application.CreateForm(TfrmStyleBook, frmStyleBook);
  Application.CreateForm(TFrmControleRemoto, FrmControleRemoto);
  Application.Run;
end.
