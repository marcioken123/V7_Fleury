unit uServicoSCC;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.SvcMgr, Vcl.Dialogs,
  MyDlls_DR, ExtCtrls, Registry, IniFiles;

type
  ERegistroDeOperacao = class(Exception);

  TsrvSCCApp = class(TService)
    procedure ServiceAfterInstall(Sender: TService);
    procedure ServiceBeforeInstall(Sender: TService);
    procedure ServiceBeforeUninstall(Sender: TService);
    procedure ServiceCreate(Sender: TObject);
    procedure ServiceDestroy(Sender: TObject);
    procedure ServiceExecute(Sender: TService);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
  private
    procedure ServiceLoadInfo(Sender: TObject);
    { Private declarations }
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  srvSCCApp: TsrvSCCApp;

type
  TServiceInfo = record
    Name: string;
    DisplayName: string;
    Description: string;
  end;

function GetServiceInfo: TServiceInfo;

implementation

{$R *.dfm}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  srvSCCApp.Controller(CtrlCode);
end;

function TsrvSCCApp.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TsrvSCCApp.ServiceAfterInstall(Sender: TService);
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

procedure TsrvSCCApp.ServiceBeforeInstall(Sender: TService);
begin
  ServiceLoadInfo(Self);
end;

procedure TsrvSCCApp.ServiceBeforeUninstall(Sender: TService);
begin
  ServiceLoadInfo(Self);
end;

procedure TsrvSCCApp.ServiceCreate(Sender: TObject);
begin
  ServiceLoadInfo(Self);
  FormatSettings.ShortDateFormat := 'dd/mm/yyyy';
  FormatSettings.LongTimeFormat := 'hh:nn:ss';
end;

procedure TsrvSCCApp.ServiceDestroy(Sender: TObject);
begin
  // MyLogException(ERegistroDeOperacao.Create('Término do serviço - '+Self.Name));
end;

procedure TsrvSCCApp.ServiceExecute(Sender: TService);
begin
  while not Terminated do
    ServiceThread.ProcessRequests(True); // wait for termination
end;

procedure TsrvSCCApp.ServiceLoadInfo(Sender: TObject);
// new method, not an override
var
  ServInfo: TServiceInfo;
begin
  ServInfo := GetServiceInfo;
  Self.Name := ServInfo.Name;
  Self.DisplayName := ServInfo.DisplayName;
end;

procedure TsrvSCCApp.ServiceStart(Sender: TService; var Started: Boolean);
begin
  Started := True;
  MyLogException(ERegistroDeOperacao.Create('Inicio do serviço - '+Self.Name));
end;

procedure TsrvSCCApp.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  MyLogException(ERegistroDeOperacao.Create('Término do serviço - '+Self.Name));
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

end.
