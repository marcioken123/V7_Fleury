program sics2;

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  Sharemem,
  Forms,
  Midaslib,
  Dialogs,
  SysUtils,
  SvcMgr,
  WinSvc,
  Classes,
  Windows,
  Vcl.Themes,
  Vcl.Styles,
  IniFiles,
  MyDlls_DR,
  repPrview in 'repPrview.pas' {frmSicsRepPreview},
  sics_m in 'sics_m.pas' {frmSicsMain},
  ProtocoloSics in 'ProtocoloSics.pas',
  NBackup in 'NBackup.pas' {frmSicsBackup},
  cfgGenerica in 'cfgGenerica.pas' {frmSicsConfiguraTabela},
  sics_94 in 'sics_94.pas' {dmSicsMain: TDataModule},
  cfgPrioridades in 'cfgPrioridades.pas' {frmSicsConfigPrioridades},
  Sics_92 in 'Sics_92.pas' {frmSicsGerarNovaSenhaOuUtilizarUltima},
  udmCadPIS in 'udmCadPIS.pas' {dmSicsCadPIS: TDataModule},
  udmCadAlarmes in 'udmCadAlarmes.pas' {dmSicsCadAlarmes: TDataModule},
  udmCadHor in 'udmCadHor.pas' {dmSicsCadHor: TDataModule},
  udmCadNiveis in 'udmCadNiveis.pas' {dmSicsCadNiveis: TDataModule},
  ufrmCadPIS in 'ufrmCadPIS.pas' {frmSicsCadPIS},
  ufrmCadAlarmes in 'ufrmCadAlarmes.pas' {frmSicsCadAlarmes},
  ufrmCadHor in 'ufrmCadHor.pas' {frmSicsCadHor},
  ufrmCadNiveis in 'ufrmCadNiveis.pas' {frmSicsCadNiveis},
  uServico in 'uServico.pas' {srvSicsApp: TService},
  Sics_91 in 'Sics_91.pas',
  sics_dm in 'sics_dm.pas' {dmSicsServidor: TDataModule},
  udmContingencia in 'udmContingencia.pas' {dmSicsContingencia: TDataModule},
  ufrmContingencia in 'ufrmContingencia.pas' {frmSicsContingencia},
  ufrmPrincipalInoperante in 'ufrmPrincipalInoperante.pas' {frmSicsPrincipalInoperante},
  uqrCfgGenerica in 'uqrCfgGenerica.pas' {qrSicsCfgGenerica: TQuickRep},
  udmWebServer in 'udmWebServer.pas' {dmSicsWebServer: TDataModule},
  ufrmCadTotens in 'ufrmCadTotens.pas' {frmSicsCadTotens},
  udmCadTotens in 'udmCadTotens.pas' {dmSicsCadTotens: TDataModule},
  ufrmParamsNiveisSLA in 'ufrmParamsNiveisSLA.pas' {frmSicsParamsNiveisSLA},
  uFrmConfiguracoesSicsMultiPA in 'uFrmConfiguracoesSicsMultiPA.pas' {FrmConfiguracoesSicsMultiPA},
  uFrmBaseConfiguracoesSics in 'uFrmBaseConfiguracoesSics.pas' {FrmBaseConfiguracoesSics},
  uFrmConfiguracoesSicsOnLine in 'uFrmConfiguracoesSicsOnLine.pas' {FrmConfiguracoesSicsOnLine},
  ufrmDebugParameters in 'ufrmDebugParameters.pas' {frmDebugParameters},
  uFrmConfiguracoesSicsTGS in 'uFrmConfiguracoesSicsTGS.pas' {FrmConfiguracoesSicsTGS},
  uFrmConfiguracoesSicsPA in 'uFrmConfiguracoesSicsPA.pas' {FrmConfiguracoesSicsPA},
  udmCadBase in 'udmCadBase.pas' {dmSicsCadBase: TDataModule},
  uSelecaoGrupos in 'uSelecaoGrupos.pas' {FrmSelecaoGrupos},
  Sics_Common_Splash in '..\Common\Sics_Common_Splash.pas' {frmSicsSplash},
  MyAspFuncoesUteis_VCL in '..\Common\Library\MyAspFuncoesUteis_VCL.pas',
  untLog in '..\Common\Library\untLog.pas',
  AspJson in '..\Common\Library\AspJson.pas',
  ASPDbGrid in '..\Common\ASPDbGrid.pas',
  uCalculoPIs in 'uCalculoPIs.pas' {CalculoPIs: TDataModule},
  uPushNotificationServer in 'uPushNotificationServer.pas' {PushNotificationServer: TDataModule},
  uPushConsts in '..\Common\uPushConsts.pas',
  uFrmConfiguracoesSicsCallCenter in 'uFrmConfiguracoesSicsCallCenter.pas' {FrmConfiguracoesSicsCallCenter},
  uCallCenterConsts in '..\Common\uCallCenterConsts.pas',
  uPI in '..\Common\uPI.pas',
  UConexaoBD in '..\Common\UConexaoBD.pas',
  ASPGenerator in '..\..\..\..\00. Library\Common\Rio\ASPGenerator.pas',
  ASPHTTPRequest in '..\..\..\..\00. Library\Common\Rio\ASPHTTPRequest.pas',
  uDataSetHelper in '..\Common\uDataSetHelper.pas',
  ServiceProvider.Intf in '..\Common\ServiceProvider\Intf\ServiceProvider.Intf.pas',
  ServiceProvider.Einstein.Impl in '..\Common\ServiceProvider\Einstein\ServiceProvider.Einstein.Impl.pas',
  ServiceProvider.GupShup.Client in '..\Common\ServiceProvider\GupShup\ServiceProvider.GupShup.Client.pas',
  ServiceProvider.GupShup.Impl in '..\Common\ServiceProvider\GupShup\ServiceProvider.GupShup.Impl.pas',
  ServiceProvider.Twilio.Client in '..\Common\ServiceProvider\Twilio\ServiceProvider.Twilio.Client.pas',
  ServiceProvider.Twilio.Impl in '..\Common\ServiceProvider\Twilio\ServiceProvider.Twilio.Impl.pas',
  uScriptUnidades in '..\Common\uScriptUnidades.pas',
  udmCSC in 'udmCSC.pas' {dmCSC: TDataModule},
  uFrmConfiguracoesSicsTV in 'uFrmConfiguracoesSicsTV.pas' {FrmConfiguracoesSicsTV},
  udmControleDeReimpressao in 'udmControleDeReimpressao.pas' {dmControleDeReimpressao: TDataModule},
  sics_3 in 'sics_3.pas' {frmSicsPIMonitor},
  sics_4 in 'sics_4.pas' {frmSicsConexoes},
  sics_5 in 'sics_5.pas' {frmSicsProcessosParalelos},
  sics_2 in 'sics_2.pas' {frmSicsSituacaoAtendimento},
  controller.Consts in 'src\controllers\controller.Consts.pas',
  controller.Parametros in 'src\controllers\controller.Parametros.pas',
  Controller.ParametrosModulos in 'src\controllers\Controller.ParametrosModulos.pas',
  controller.Prioridades in 'src\controllers\controller.Prioridades.pas',
  AspectVCL in 'src\providers\AspectVCL.pas',
  ClassLibraryVCL in 'src\providers\ClassLibraryVCL.pas',
  provider.Consts in 'src\providers\provider.Consts.pas',
  provider.Types in 'src\providers\provider.Types.pas',
  uFuncoes in 'src\providers\uFuncoes.pas',
  uLibDatasnap in 'src\providers\uLibDatasnap.pas',
  uMessenger in 'src\providers\uMessenger.pas',
  uPushSender in 'src\providers\uPushSender.pas',
  UTaskBarList in 'src\providers\UTaskBarList.pas',
  uTempoUnidade in 'src\providers\uTempoUnidade.pas';

{$R *.RES}

function IsServiceRunning: Boolean;
var
  Svc     : Integer;
  SvcMgr  : Integer;
  ServSt  : TServiceStatus;
  ServInfo: uServico.TServiceInfo;
begin
  ServInfo := uServico.GetServiceInfo;

  Result := False;
  SvcMgr := OpenSCManager(nil, nil, SC_MANAGER_CONNECT);
  if SvcMgr = 0 then
    Exit;
  try
    // RTC_DATASERVICE_NAME is the name of your Service component
    Svc := OpenService(SvcMgr, PChar(ServInfo.Name), SERVICE_QUERY_STATUS);
    if Svc = 0 then
      Exit;
    try
      if not QueryServiceStatus(Svc, ServSt) then
        Exit;
      Result := (ServSt.dwCurrentState = SERVICE_RUNNING) or (ServSt.dwCurrentState = SERVICE_START_PENDING);
    finally
      CloseServiceHandle(Svc);
    end;
  finally
    CloseServiceHandle(SvcMgr);
  end;
end;

function IsDesktopMode: Boolean;
begin
  // I use "-S" parameter to run the app in GUI mode, even when the service is active
  if (Win32Platform <> VER_PLATFORM_WIN32_NT) or FindCmdLineSwitch('S', ['-', '/'], True) then // standard
    Result := True
  else
    Result := not FindCmdLineSwitch('INSTALL', ['-', '/'], True) and not FindCmdLineSwitch('UNINSTALL', ['-', '/'], True) and not IsServiceRunning;
end;

begin
  {$IFDEF DEBUG}ReportMemoryLeaksOnShutdown := True;{$ENDIF}

  SysUtils.FormatSettings.ShortDateFormat := 'dd/mm/yyyy';
  SysUtils.FormatSettings.LongTimeFormat  := 'hh:nn:ss';

  vIsDesktopMode := IsDesktopMode;

  TfrmDebugParameters.CarregaParametros;
  //TfrmDebugParameters.Debugar(tbGeral, 'INICIOU');
  TfrmDebugParameters.Debugar(tbGeral, '                                                                                                                    ');
  TfrmDebugParameters.Debugar(tbGeral, '                                                                                                                    ');
  TfrmDebugParameters.Debugar(tbGeral, '********************************************************************************************************************');
  TfrmDebugParameters.Debugar(tbGeral, 'Iniciou o Servidor SICS - ' + Trim(Versao));

  if not vIsDesktopMode then
    SetIniFileName(GetServiceIniFileName);

  // Depending on mode we want to use, initialize the application and forms/datamodules ...
  if not vIsDesktopMode then
  begin
    SvcMgr.Application.Initialize;
    SvcMgr.Application.Title := 'SICS';
    CriarForm(vIsDesktopMode, TsrvSicsApp, srvSicsApp);

    // Forms.Application.OnException := GlobalLog.ExceptionHandler;
  end
  else
  begin
    if ContaProcessos(ExtractFileName(Vcl.Forms.Application.ExeName)) > 1 then
    begin
      Vcl.Forms.Application.MessageBox ('Um processo deste aplicativo já está rodando. Por favor feche-o antes de tentar rodar o programa novamente.',
                                    'SICS - Sistema Inteligente de Chamada de Senhas', MB_ICONINFORMATION);
      Halt;
    end;

    Vcl.Forms.Application.Initialize;
    //Vcl.Forms.Application.OnException := GlobalLog.ExceptionHandler;
    Vcl.Forms.Application.OnException := untLog.TLog.MyException;
    Vcl.Forms.Application.Title       := 'SICS';
  end;

  CarregarParametrosINI;

  try
    if vIsDesktopMode then
      TfrmSicsSplash.ShowStatus('Carregando...');

    CriarForm(vIsDesktopMode, TdmSicsContingencia, dmSicsContingencia);
    dmSicsContingencia.CarregarConfiguracoes(True);

    if not dmSicsContingencia.SituacaoIrregular then
    begin
      if (dmSicsContingencia.TipoFuncionamento = tfPrincipal) and (dmSicsContingencia.ContingenciaAtivo) then
        CriarForm(vIsDesktopMode, TfrmSicsPrincipalInoperante, frmSicsPrincipalInoperante)
      else
      begin
        if (dmSicsContingencia.TipoFuncionamento = tfContingente) and (not dmSicsContingencia.ContingenciaAtivo) then
          CriarForm(vIsDesktopMode, TfrmSicsContingencia, frmSicsContingencia)
        else
          CriarFormsDmsInicializacao(False);
      end
    end;
  finally
    if vIsDesktopMode then
      TfrmSicsSplash.Hide;
  end;

  if not dmSicsContingencia.SituacaoIrregular then
  begin
    if vIsDesktopMode then
      Vcl.Forms.Application.Run
    else
      SvcMgr.Application.Run;
  end;

end.
