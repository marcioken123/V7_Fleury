program SCC;

uses
//  {$IFNDEF DEBUG}
  Sharemem,
//  {$ENDIF }
  MidasLib,
  Vcl.Forms,
  Vcl.SvcMgr,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  MyDlls_DR,
  SysUtils,
  Winapi.Windows,
  Winapi.WinSvc,
  SCC_m in 'SCC_m.pas' {MainForm},
  uConsts in 'uConsts.pas',
  uTypes in 'uTypes.pas',
  uDMSocket in 'uDMSocket.pas' {dmSocket: TDataModule},
  uSMUnidade in 'uSMUnidade.pas' {Unidade: TDataModule},
  uWebModule in 'uWebModule.pas' {WebModule1: TWebModule},
  uLibDatasnap in 'uLibDatasnap.pas',
  uSMFila in 'uSMFila.pas' {Fila: TDataModule},
  uSMMotivoDePausa in 'uSMMotivoDePausa.pas' {MotivoDePausa: TDataModule},
  uSMPA in 'uSMPA.pas' {PA: TDataModule},
  uSMBase in 'uSMBase.pas' {smBase: TDataModule},
  uServicoSCC in 'uServicoSCC.pas' {srvSCCApp: TService},
  untLog in '..\..\Common\Library\untLog.pas',
  uFuncoes in 'uFuncoes.pas',
  MyAspFuncoesUteis_VCL in '..\..\Common\Library\MyAspFuncoesUteis_VCL.pas',
  untDmUnidadesScc in 'untDmUnidadesScc.pas' {dmUnidadesScc: TDataModule},
  untDmTabelasScc in 'untDmTabelasScc.pas' {dmTabelasScc: TDataModule},
  uSMOpiniometro in 'uSMOpiniometro.pas' {Opiniometro: TDataModule},
  uSMIndicador in 'uSMIndicador.pas' {Indicador: TDataModule},
  uPI in '..\..\Common\uPI.pas',
  ASPHTTPRequest in '..\..\..\..\..\00. Library\Common\Rio\ASPHTTPRequest.pas',
  uSMTGSMobile in 'uSMTGSMobile.pas' {TGSMobile: TDataModule},
  uDevice in '..\..\Common\uDevice.pas',
  uSMConfig in 'uSMConfig.pas' {SMConfig: TDataModule},
  UConexaoBD in '..\..\Common\UConexaoBD.pas',
  uSMDispositivo in 'uSMDispositivo.pas' {Dispositivo: TDataModule},
  uDispositivo in '..\..\Common\uDispositivo.pas',
  uSMTotem in 'uSMTotem.pas' {Totem: TDSServerModule},
  udmControleDeTokens in 'udmControleDeTokens.pas' {dmControleDeTokens: TDataModule},
  sics_94 in '..\..\01. Servidor\sics_94.pas' {dmSicsMain: TDataModule},
  Sics_91 in '..\..\01. Servidor\Sics_91.pas',
  uDataSetHelper in '..\..\Common\uDataSetHelper.pas',
  ASPGenerator in '..\..\..\..\..\00. Library\Common\Rio\ASPGenerator.pas',
  uScriptUnidades in '..\..\Common\uScriptUnidades.pas',
  uSMSenha in 'uSMSenha.pas' {Senha: TDataModule},
  uSMAtendente in 'uSMAtendente.pas' {Atendente: TDataModule},
  Horse,
  Horse.Jhonson,
  Horse.HandleException,
  Horse.OctetStream,
  Providers.FileUtils in 'src\providers\Providers.FileUtils.pas',
  Providers.Consts in 'src\providers\Providers.Consts.pas',
  Providers.Connection in 'src\providers\Providers.Connection.pas' {ProviderConnection: TDataModule},
  Controllers.App in 'src\controllers\Controllers.App.pas',
  Services.App in 'src\services\Services.App.pas' {ServiceApp: TDataModule},
  uSMAA in 'uSMAA.pas' {AutoAtendimento: TDataModule};

{$R *.res}

function IsServiceRunning: Boolean;
var
  Svc: Integer;
  SvcMgr: Integer;
  ServSt: TServiceStatus;
  ServInfo: uServicoSCC.TServiceInfo;
begin
  ServInfo := uServicoSCC.GetServiceInfo;

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
      Result := (ServSt.dwCurrentState = SERVICE_RUNNING) or
        (ServSt.dwCurrentState = SERVICE_START_PENDING);
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
  if (Win32Platform <> VER_PLATFORM_WIN32_NT) or
    FindCmdLineSwitch('S', ['-', '/'], True) then // standard
    Result := True
  else
    Result := not FindCmdLineSwitch('INSTALL', ['-', '/'], True) and
      not FindCmdLineSwitch('UNINSTALL', ['-', '/'], True) and
      not IsServiceRunning;
end;

var
  vIsDesktopMode: Boolean;

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;

  vIsDesktopMode := IsDesktopMode;

  if not vIsDesktopMode then
    SetIniFileName(GetServiceIniFileName);
  if vIsDesktopMode then
  begin
    {$IFDEF DEBUG}
    ReportMemoryLeaksOnShutdown := True;
    {$ENDIF}
    if ContaProcessos(ExtractFileName(Vcl.Forms.Application.ExeName)) > 1 then
    begin
      Vcl.Forms.Application.MessageBox
        ('Um processo deste aplicativo já está rodando. Por favor feche-o antes de tentar rodar o programa novamente.',
        'SICS Customização de Chamadas', 0);
      Halt;
    end;

    Vcl.Forms.Application.Initialize;
    Vcl.Forms.Application.Title := 'SICS Customização de Chamadas';
    Vcl.Forms.Application.CreateForm(TMainForm, MainForm);
    Application.CreateForm(TdmSicsMain, dmSicsMain);
    Vcl.Forms.Application.ShowMainForm := False;
    Vcl.Forms.Application.Run;

  end
  else
  begin
    if not Vcl.SvcMgr.Application.DelayInitialize or Application.Installing then
      Vcl.SvcMgr.Application.Initialize;
    Vcl.SvcMgr.Application.CreateForm(TsrvSCCApp, srvSCCApp);
    Vcl.Forms.Application.CreateForm(TMainForm, MainForm);
    Application.Run;
  end;
end.
