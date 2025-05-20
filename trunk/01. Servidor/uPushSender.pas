unit uPushSender;

interface

uses System.SysUtils, System.Classes, uPushNotificationServer, System.Threading,
  uPushConsts;

type
  TPushSender = class
  private
    function GetPushServerInstance: TPushNotificationServer;
    procedure ExecutarEmThread(AProc: TProc);
    function GetUserAsTStrings(const ADeviceId: String): TStringList;

    procedure DoChamadaDeSenha(const ADeviceId, ASenha, ADestino: String);
    procedure DoSenhaFinalizada(const ADeviceId, ASenha: String);
  public
    class procedure ChamadaDeSenha(const ADeviceId, ASenha, ADestino: String);
    class procedure SenhaFinalizada(const ADeviceId, ASenha: String);
  end;

implementation

{ TPushSender }

class procedure TPushSender.ChamadaDeSenha(const ADeviceId, ASenha, ADestino: String);
var
  FInstance: TPushSender;
begin
  FInstance := TPushSender.Create;
  FInstance.ExecutarEmThread(procedure
  begin
    try
      FInstance.DoChamadaDeSenha(ADeviceId, ASenha, ADestino);
    finally
      FInstance.Free;
    end;
  end);
end;

procedure TPushSender.DoChamadaDeSenha(const ADeviceId, ASenha,
  ADestino: String);
var
  LPushServer: TPushNotificationServer;
  LUsers: TStrings;
  LError: String;
begin
  LUsers := GetUserAsTStrings(ADeviceId);
  try
    LPushServer := GetPushServerInstance;
    try
      LPushServer.PushDataToUsers(
        'Sua senha (' + ASenha + ') foi chamada em "' + ADestino + '".',
        PUSH_MODULE_NAME,
        ASenha,
        PUSH_OPSENHA_CHAMADA,
        ADestino,
        LUsers,
        LError
      );
    finally
      LPushServer.Free
    end;
  finally
    LUsers.Free;
  end;
end;

procedure TPushSender.DoSenhaFinalizada(const ADeviceId, ASenha: String);
var
  LPushServer: TPushNotificationServer;
  LUsers: TStrings;
  LError: String;
begin
  LUsers := GetUserAsTStrings(ADeviceId);
  try
    LPushServer := GetPushServerInstance;
    try
      LPushServer.PushDataToUsers(
        'Seu atendimento (senha ' + ASenha + ') foi finalizado!',
        PUSH_MODULE_NAME,
        ASenha,
        PUSH_OPSENHA_FINALIZADA,
        EmptyStr,
        LUsers,
        LError
      );
    finally
      LPushServer.Free
    end;
  finally
    LUsers.Free;
  end;
end;

procedure TPushSender.ExecutarEmThread(AProc: TProc);
begin
  TTask.Run(procedure
    begin
      try
        AProc;
      except on E: Exception do
        //Log? Tem que ser ThreadSafe!
      end;
    end
  );
end;

function TPushSender.GetPushServerInstance: TPushNotificationServer;
begin
  result := TPushNotificationServer.Create(nil);
end;

function TPushSender.GetUserAsTStrings(const ADeviceId: String): TStringList;
begin
  result := TStringList.Create;
  result.Add(ADeviceid);
end;

class procedure TPushSender.SenhaFinalizada(const ADeviceId, ASenha: String);
var
  FInstance: TPushSender;
begin
  FInstance := TPushSender.Create;
  FInstance.ExecutarEmThread(procedure
  begin
    try
      FInstance.DoSenhaFinalizada(ADeviceId, ASenha);
    finally
      FInstance.Free;
    end;
  end);
end;

end.

