program SicsTV;

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  Sharemem,
  Forms,
  MidasLib,
  SicsTV_2 in 'SicsTV_2.pas' {frmSicsProperties},
  SicsTV_3 in 'SicsTV_3.pas' {frmSicsHorarioDeFuncionamento},
  SicsTV_4 in 'SicsTV_4.pas' {frmSicsLogo},
  Sics_Common_Splash in '..\Common\Sics_Common_Splash.pas' {frmSicsSplash},
  Sics_Common_DataModuleClientConnection in 'Sics_Common_DataModuleClientConnection.pas' {dmSicsClientConnection: TDataModule},
  Sics_Common_PIShow in 'Sics_Common_PIShow.pas' {frmSicsCommom_PIShow},
  untConstsWM in '..\Common\untConstsWM.pas' {$R *.res},
  udmPlayListManager in 'udmPlayListManager.pas' {DMPlayListManager: TDataModule},
  MyAspFuncoesUteis_VCL in '..\Common\Library\MyAspFuncoesUteis_VCL.pas',
  Sics_Common_Parametros in '..\Common\Sics_Common_Parametros.pas',
  SicsTV_m in 'SicsTV_m.pas' {frmSicsTVPrincipal},
  untLog in '..\Common\Library\untLog.pas',
  AspJson in '..\Common\Library\AspJson.pas',
  SicsTV_Parametros in 'SicsTV_Parametros.pas';

{$R *.res}

begin
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  ValidaAppMultiInstancia;
  Application.Initialize;
  Application.Title := 'SICS TV';
  Application.OnException := TLog.MyException;
  TfrmSicsSplash.ShowStatus('Inicializando o SICS TV...');

  Application.CreateForm(TfrmSicsTVPrincipal, frmSicsTVPrincipal);
  Application.CreateForm(TfrmSicsProperties, frmSicsProperties);
  Application.CreateForm(TfrmSicsLogo, frmSicsLogo);
  Application.CreateForm(TdmSicsClientConnection, dmSicsClientConnection);
  Application.Run;
end.
