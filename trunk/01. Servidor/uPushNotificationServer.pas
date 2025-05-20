unit uPushNotificationServer;

interface

uses
  System.SysUtils, System.Classes, IPPeerClient, REST.Backend.ServiceTypes,
  REST.Backend.MetaTypes, System.JSON, REST.Backend.KinveyServices,
  REST.Backend.Providers, REST.Backend.ServiceComponents,
  REST.Backend.KinveyProvider, REST.Backend.KinveyPushDevice,
  System.PushNotification, REST.Backend.PushTypes, Data.Bind.Components,
  Data.Bind.ObjectScope,
  REST.Backend.KinveyAPI, REST.Backend.EMSServices, REST.Backend.EMSProvider,
  REST.Backend.EMSApi, REST.Backend.BindSource;

type
  TPushNotificationServer = class(TDataModule)
    BackendPush: TBackendPush;
    EMSProvider: TEMSProvider;
    KinveyProvider: TKinveyProvider;
    procedure DataModuleCreate(Sender: TObject);
  private
//    FConnectionInfo: TKinveyApi.TConnectionInfo;
    FKinveyApi: TKinveyApi;
    LEMSClientAPI: TEMSClientAPI;
    LPushStatus: TEMSClientApi.TPushStatus;
    procedure Setup;
    function MontaJSONCorpoMensagem(aTitle, aMessage: String): TJsonObject;
    function MontaJSONDestinatarios(aDeviceTokenArray: TJSONArray): TJSONValue;
  public
    function PushDataToUsers(const aMsg, aModulo, aSenha, aOperacao,
      aDestino: String; const aUsers: TStrings; out ErrorMsg: String): Boolean;
    function PushDataBroadcast(const aMsg, aModulo, aSenha, aOperacao,
      aDestino: String; out ErrorMsg: String): Boolean;
    function PushMsgToUsers(const aMsg: String; const aUsers: TStrings;
      out ErrorMsg: String): Boolean;
    function PushMsgBroadcast(const aMsg: String;
      out ErrorMsg: String): Boolean;
  end;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses uPushConsts;

{$R *.dfm}

{ TPushNotificationServer }

procedure TPushNotificationServer.DataModuleCreate(Sender: TObject);
begin
  Setup;
end;

function TPushNotificationServer.PushDataBroadcast(const aMsg, aModulo,
  aSenha, aOperacao, aDestino: String; out ErrorMsg: String): Boolean;
var
  LExtra: TCustomBackendPush.TExtrasItem;
begin
  result := False;
  ErrorMsg := EmptyStr;

  KinveyProvider.PushEndpoint := 'pushDataBroadcast';
  BackendPush.Message := aMsg;

  LExtra := TCustomBackendPush.TExtrasItem(BackendPush.Extras.Add);
  LExtra.Name  := PUSH_MODULE_NAME;
  LExtra.Value := aModulo;

  LExtra := TCustomBackendPush.TExtrasItem(BackendPush.Extras.Add);
  LExtra.Name  := PUSH_SENHA_NAME;
  LExtra.Value := aSenha;

  LExtra := TCustomBackendPush.TExtrasItem(BackendPush.Extras.Add);
  LExtra.Name  := PUSH_OPSENHA_NAME;
  LExtra.Value := aOperacao;

  LExtra := TCustomBackendPush.TExtrasItem(BackendPush.Extras.Add);
  LExtra.Name  := PUSH_DESTINO_NAME;
  LExtra.Value := aDestino;

  try
    BackendPush.Push;
    result := True;
  except
    on E: Exception do
      ErrorMsg := E.Message;
  end;
end;

function TPushNotificationServer.PushDataToUsers(const aMsg, aModulo,
  aSenha, aOperacao, aDestino: String; const aUsers: TStrings;
  out ErrorMsg: String): Boolean;
var
  LRequestBody, {LiOSAps, LiOSExtras, LandroidPayload, }LAndroidJSON: TJSONObject;
  LArrayUsers: TJSONArray;
  i: Integer;
//  Data: TPushData;
  LTarget{, LJSONPushData}: TJSONObject;
  LPushData: TPushData;
begin
  result := False;
  ErrorMsg := EmptyStr;
  LRequestBody := TJSONObject.Create;
  try
    LArrayUsers := TJSONArray.Create;
    for i := 0 to aUsers.Count-1 do
      LArrayUsers.Add(aUsers[i]);

//    LAndroidJSON := TJSONObject.Create;
    LAndroidJSON := MontaJSONCorpoMensagem(aModulo, aMsg);

//    LTarget      := TJSONObject.Create;
    LTarget      := TJSONObject(MontaJSONDestinatarios(LArrayUsers));

    try
      LPushData := TPushData.Create;
      LPushData.Load(TJSONObject(LAndroidJSON));
//      LJSONPushData := BackendPush.PushAPI.PushDataAsJSON(LPushData);
      LEMSClientApi := (BackendPush.ProviderService as IGetEMSApi).EMSAPI;
      LEMSClientApi.PushToTarget(LAndroidJSON, LTarget, LPushStatus);
      result := True;
    except
      on E: Exception do
        ErrorMsg := E.Message;
    end;
  finally
    LRequestBody.Free;
  end;
end;

function TPushNotificationServer.PushMsgBroadcast(const aMsg: String;
  out ErrorMsg: String): Boolean;
var
  LRequestBody: TJSONObject;
begin
  result := False;
  ErrorMsg := EmptyStr;

  LRequestBody := TJSONObject.Create;
  try
    LRequestBody.AddPair(PUSH_MESSAGE_NAME, aMsg);
    try
      FKinveyApi.InvokeCustomEndPoint('pushMsgBroadcast', LRequestBody, nil);
      result := True;
    except
      on E: Exception do
        ErrorMsg := E.Message;
    end;
  finally
    LRequestBody.Free;
  end;
end;

function TPushNotificationServer.PushMsgToUsers(const aMsg: String;
  const aUsers: TStrings; out ErrorMsg: String): Boolean;
var
  LRequestBody: TJSONObject;
  LArrayUsers: TJSONArray;
  i: Integer;
begin
  result := False;
  ErrorMsg := EmptyStr;

  LRequestBody := TJSONObject.Create;
  try
    LArrayUsers := TJSONArray.Create;
    for i := 0 to aUsers.Count-1 do
      LArrayUsers.Add(aUsers[i]);

    LRequestBody.AddPair(PUSH_USERS_NAME, LArrayUsers);
    LRequestBody.AddPair(PUSH_MESSAGE_NAME, aMsg);
    try
      FKinveyApi.InvokeCustomEndPoint('pushMsgToUsers', LRequestBody, nil);
      result := True;
    except
      on E: Exception do
        ErrorMsg := E.Message;
    end;
  finally
    LRequestBody.Free;
  end;
end;

procedure TPushNotificationServer.Setup;
begin
{  FConnectionInfo              := TKinveyApi.TConnectionInfo.Create(
                                    KinveyProvider.ApiVersion,
                                    KinveyProvider.AppKey);
  FConnectionInfo.MasterSecret := KinveyProvider.MasterSecret;
  FConnectionInfo.UserName     := KinveyProvider.UserName;
  FConnectionInfo.Password     := KinveyProvider.Password;

  if Assigned(FKinveyApi) then
    FreeAndNil(FKinveyApi);
  FKinveyApi := TKinveyApi.Create(KinveyProvider);
  FKinveyApi.ConnectionInfo := FConnectionInfo; }
end;

function TPushNotificationServer.MontaJSONDestinatarios(
  aDeviceTokenArray: TJSONArray): TJSONValue;
var
  LTargetJSON,
  LinDevice,
  LDeviceToken: TJSONObject;
begin
  LinDevice    := TJSONObject.Create;
  LDeviceToken := TJSONObject.Create;
  LTargetJSON  := TJSONObject.Create;

  LinDevice.AddPair('$in', aDeviceTokenArray);
  LDeviceToken.AddPair('deviceToken', LinDevice);
  LTargetJSON.AddPair('where', LDeviceToken);

  Result := LTargetJSON;
end;

function TPushNotificationServer.MontaJSONCorpoMensagem(aTitle, aMessage : String) : TJsonObject;
var
  LAndroidJSON : TJSONObject;
begin
  LAndroidJSON := TJSONObject.Create;
  LAndroidJSON.AddPair('title', aTitle);
  LAndroidJSON.AddPair('message', aMessage);

  Result := LAndroidJSON;
end;

end.
