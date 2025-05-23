unit uFuncoes;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  SysUtils, MyDlls_DR,  ClassLibraryVCL, uServico, Forms, Classes, IniFiles, Dialogs, Winapi.Windows;

type
  TLog = class(TComponent)
  public
    procedure ExceptionHandler(Sender: TObject; E: Exception);
  end;

  TThreadCreateFormsWhenService = class(TThread)
  private
    procedure CreateForms;
  public
    procedure Execute; override;
  end;

function GetIniFileName: string;
function GetIsService: Boolean;
//function GetPathRealTime: string;
function GetServiceIniFileName: string;
procedure CriarFormsDmsInicializacao(Splash: Boolean);
procedure DestruirFormsDmsInicializacao;
procedure CriarForm(IsDesktopMode: Boolean; AClass: TComponentClass; var Form);

var
  vIsDesktopMode: Boolean;

implementation

uses
  sics_94,
  sics_dm,
  sics_m,
  sics_2,
  sics_3,
  sics_5,
  NBackup,
  SvcMgr,
  Sics_Common_Splash;

function GetServiceIniFileName: string;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFileDir(ParamStr(0))) + ParamStr(2)
end;

function GetIniFileName: string;
begin
  if GetIsService then
    Result := GetServiceIniFileName
  else
    Result := GetAppIniFileName;
end;

function GetIsService: Boolean;
begin
  Result := Assigned(srvSicsApp) or (not vIsDesktopMode);
end;

//function GetPathRealTime: string;
//begin
//  if GetIsService then
//  begin
//    Result := GetApplicationPath + '\RT-' + srvSicsApp.Name + '\';
//  end
//  else
//  begin
//    Result := GetApplicationPath + '\RT\';
//  end;
//end;

procedure CriarFormsDmsInicializacao(Splash: Boolean);
begin
  if not GetIsService then
  begin
    if Splash then
      TfrmSicsSplash.ShowStatus('Carregando...');

    try
      TfrmSicsSplash.ShowStatus('Carregando o Módulo Principal...');
      Forms.Application.CreateForm(TdmSicsMain, dmSicsMain);
      TfrmSicsSplash.ShowStatus('Carregando o Módulo do Servidor...');
      Forms.Application.CreateForm(TdmSicsServidor, dmSicsServidor);
      TfrmSicsSplash.ShowStatus('Carregando a Tela Principal...');
      Forms.Application.CreateForm(TfrmSicsMain, frmSicsMain);
      TfrmSicsSplash.ShowStatus('Carregando a Tela de Situação de Atendimentos...');
      Forms.Application.CreateForm(TfrmSicsSituacaoAtendimento, frmSicsSituacaoAtendimento);
      TfrmSicsSplash.ShowStatus('Carregando a Tela de Indicadores de Performance...');
      Forms.Application.CreateForm(TfrmSicsPIMonitor, frmSicsPIMonitor);
      TfrmSicsSplash.ShowStatus('Carregando a Tela de Processos Paralelos...');
      Forms.Application.CreateForm(TfrmSicsProcessosParalelos, frmSicsProcessosParalelos);
      TfrmSicsSplash.ShowStatus('Carregando a Tela de Backups...');
      Forms.Application.CreateForm(TfrmSicsBackup, frmSicsBackup);
      TfrmSicsSplash.ShowStatus('Inicializando os Dados...');

      dmSicsMain.UpdateDadosJornalAPI;

      frmSicsMain.InicializarDados;
      if Splash then
        frmSicsMain.Show;
    finally
      if Splash then
        TfrmSicsSplash.Hide;
    end;
  end
  else
  begin
    // fomos obrigados a criar uma thread no caso de servico, pois por padrao
    // o windows tem um timeout de 30 segundos para iniciar um servico, portanto,
    // como a inicializacao dos forms pode demorar, criamos numa thread
    // para nao segurar o startup do servico, POREM, quando esta INSTALANDO ou DESINSTALANDO
    // nao faco NADA pra ser rapido
    if FindCmdLineSwitch('INSTALL', ['-', '/'], True) or FindCmdLineSwitch('UNINSTALL', ['-', '/'], True) then
    begin
      // nao faco nada, pra ficar rapido
    end
    else
      with TThreadCreateFormsWhenService.Create(False) do
      begin
        FreeOnTerminate := True;
        Resume;
      end;
  end;
end;

procedure DestruirFormsDmsInicializacao;
begin
  FreeAndNil(frmSicsBackup);
  FreeAndNil(frmSicsPIMonitor);
  FreeAndNil(frmSicsSituacaoAtendimento);
  FreeAndNil(frmSicsProcessosParalelos);
  FreeAndNil(frmSicsMain);
  FreeAndNil(dmSicsServidor);
  FreeAndNil(dmSicsMain);
end;

{ TThreadCreateFormsWhenService }

procedure TThreadCreateFormsWhenService.CreateForms;
begin
  SvcMgr.Application.CreateForm(TdmSicsMain, dmSicsMain);
  SvcMgr.Application.CreateForm(TdmSicsServidor, dmSicsServidor);
  SvcMgr.Application.CreateForm(TfrmSicsMain, frmSicsMain);
  SvcMgr.Application.CreateForm(TfrmSicsSituacaoAtendimento, frmSicsSituacaoAtendimento);
  SvcMgr.Application.CreateForm(TfrmSicsProcessosParalelos, frmSicsProcessosParalelos);
  SvcMgr.Application.CreateForm(TfrmSicsPIMonitor, frmSicsPIMonitor);
  SvcMgr.Application.CreateForm(TfrmSicsBackup, frmSicsBackup);
  frmSicsMain.InicializarDados;
end;

procedure TThreadCreateFormsWhenService.Execute;
begin
  inherited;
  Synchronize(CreateForms);
end;

procedure CriarForm(IsDesktopMode: Boolean; AClass: TComponentClass; var Form);
begin
  if IsDesktopMode then
    Forms.Application.CreateForm(AClass, Form)
  else
    SvcMgr.Application.CreateForm(AClass, Form);
end;

{ Log }

procedure TLog.ExceptionHandler(Sender: TObject; E: Exception);
begin
  Winapi.Windows.Beep(1400, 1700);
  MyLogException(ERegistroDeOperacao.Create('ExceptionHandler'), True);
  ErrorMessage(E.Message);
end;


{ TCreateFormsService }

end.
