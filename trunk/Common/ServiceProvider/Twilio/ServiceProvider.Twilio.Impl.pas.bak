unit ServiceProvider.Twilio.Impl;

interface

uses System.SysUtils, System.Classes, ServiceProvider.Intf;

type
  TServiceProviderTwilio = class(TInterfacedObject, IServiceProvider)
  public
    function Send(AAPIKey, AAuthToken, APhoneFrom, APhoneTo, AMessage: String): Boolean;
  end;

const
  ACCOUNT_SID = 'AC5ff43b1a65703bbb18c05e01f1c57457';
  AUTH_TOKEN  = '805ec4845937fe1486bc3794cfa97f21';
  PHONE_FROM = '17867139445';

implementation

{ TServiceProviderTwilio }

uses ServiceProvider.Twilio.Client;

function TServiceProviderTwilio.Send(AAPIKey, AAuthToken, APhoneFrom, APhoneTo,
  AMessage: String): Boolean;
var
  LTwilio: TTwilioClient;
  LParams: TStrings;
begin
  LTwilio := TTwilioClient.Create(ACCOUNT_SID, AUTH_TOKEN);
  try
    LParams := TStringList.Create;
    try
      LParams.Add('From=whatsapp:+'+PHONE_FROM);
      LParams.Add('To=whatsapp:+'+APhoneTo);
      LParams.Add('Body=' + AMessage);

      Result := LTwilio.Post('Messages', LParams).Success;
    finally
      LParams.Free;
    end;
  finally
    LTwilio.Free;
  end;
end;

end.
