unit uServico;

interface

{$INCLUDE ..\AspDefineDiretivas.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs,
  MyDlls_DR, ClassLibraryVCL,
  ExtCtrls, Registry, IniFiles;

type
  ERegistroDeOperacao = class(Exception);

  TsrvSicsApp = class(TService)
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceExecute(Sender: TService);
    procedure ServiceBeforeInstall(Sender: TService);
    procedure ServiceCreate(Sender: TObject);
    procedure ServiceBeforeUninstall(Sender: TService);
    procedure ServiceAfterInstall(Sender: TService);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServiceDestroy(Sender: TObject);
  protected

  private
    procedure ServiceLoadInfo(Sender: TObject);
  public
    function GetServiceController: TServiceController; override;
  end;

var
  srvSicsApp: TsrvSicsApp;

type
  TServiceInfo = record
    Name: string;
    DisplayName: string;
    Description: string;
  end;

function GetServiceInfo: TServiceInfo;
function ServiceStop: Boolean;

implementation

uses
  sics_94, WinSvc;

{$R *.DFM}

function ServiceStop: Boolean;
var
  schm, schs: SC_Handle;
  ss: TServiceStatus;
  dwChkP: DWord;
begin
  schm := OpenSCManager(nil, nil, SC_MANAGER_CONNECT);
  if (schm > 0) then
  begin
    schs := OpenService(schm, PChar(uServico.GetServiceInfo.Name),
      SERVICE_STOP or SERVICE_QUERY_STATUS);
    if (schs > 0) then
    begin
      if (ControlService(schs, SERVICE_CONTROL_STOP, ss)) then
        if (QueryServiceStatus(schs, ss)) then
          while (SERVICE_STOPPED <> ss.dwCurrentState) do
          begin
            dwChkP := ss.dwCheckPoint;
            Sleep(1000);
            if (not QueryServiceStatus(schs, ss)) then
              Break;
            if (ss.dwCheckPoint < dwChkP) then
              Break;
          end;
      CloseServiceHandle(schs);
    end;
    CloseServiceHandle(schm);
  end;
  Result := SERVICE_STOPPED = ss.dwCurrentState;
end;

function GetServiceInfo: TServiceInfo;
begin
  with TIniFile.Create(IncludeTrailingPathDelimiter(ExtractFileDir(ParamStr(0)))
    + ParamStr(2)) do
    try
      Result.Name := ReadString('SERVICE', 'Name', '');
      Result.DisplayName := ReadString('SERVICE', 'DisplayName', '');
      Result.Description := ReadString('SERVICE', 'Description', '');
    finally
      Free;
    end;
end;

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  srvSicsApp.Controller(CtrlCode);
end;

procedure TsrvSicsApp.ServiceLoadInfo(Sender: TObject);
// new method, not an override
var
  ServInfo: TServiceInfo;
begin
  ServInfo := GetServiceInfo;
  Self.Name := ServInfo.Name;
  Self.DisplayName := ServInfo.DisplayName;
end;

function TsrvSicsApp.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TsrvSicsApp.ServiceStart(Sender: TService; var Started: Boolean);
begin
  Started := True;
  MyLogException(ERegistroDeOperacao.Create('Inicio do serviço.'));
end;

procedure TsrvSicsApp.ServiceExecute(Sender: TService);
begin
  while not Terminated do
    ServiceThread.ProcessRequests(True); // wait for termination
end;

procedure TsrvSicsApp.ServiceBeforeInstall(Sender: TService);
begin
  ServiceLoadInfo(Self);
end;

procedure TsrvSicsApp.ServiceCreate(Sender: TObject);
begin
  ServiceLoadInfo(Self);
  SysUtils.FormatSettings.ShortDateFormat := 'dd/mm/yyyy';
  SysUtils.FormatSettings.LongTimeFormat := 'hh:nn:ss';
end;

procedure TsrvSicsApp.ServiceBeforeUninstall(Sender: TService);
begin
  ServiceLoadInfo(Self);
end;

procedure TsrvSicsApp.ServiceAfterInstall(Sender: TService);
var
  reg: TRegistry;
  ServInfo: TServiceInfo;
begin
  ServInfo := GetServiceInfo;
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_LOCAL_MACHINE;
    if reg.OpenKey('SYSTEM\CurrentControlSet\Services\' + Self.Name, True) then
    begin
      reg.WriteExpandString('ImagePath', ParamStr(0) + ' -i "' +
        ParamStr(2) + '"');
      reg.WriteString('Description', ServInfo.Description);
      reg.CloseKey;
    end;
  finally
    reg.Free;
  end;
end;

procedure TsrvSicsApp.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  MyLogException(ERegistroDeOperacao.Create('Término do serviço.'));
end;

procedure TsrvSicsApp.ServiceDestroy(Sender: TObject);
begin
  // MyLogException(ERegistroDeOperacao.Create('Término do serviço.'));
end;

end.
