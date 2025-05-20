unit ServiceProvider.GupShup.Impl;

interface

uses System.SysUtils, System.Classes, ServiceProvider.Intf,
  REST.Types, REST.Client, Data.Bind.Components, Data.Bind.ObjectScope;

type
  TServiceProviderGupShup = class(TInterfacedObject, IServiceProvider)
  public
    function Send(AAPIKey, AAuthToken, APhoneFrom, APhoneTo, AMessage: String): Boolean;
  end;

const
  API_KEY = '204f3def3c934266c2b5ff7dcbc7c64c';
  SRC_NAME = 'EventZAP';
  PHONE_FROM = '917834811114';

implementation

{ TServiceProviderGupShup }

uses ServiceProvider.GupShup.Client;

function TServiceProviderGupShup.Send(AAPIKey, AAuthToken, APhoneFrom, APhoneTo, AMessage: String): Boolean;
var
  LGupShupClient: TGupShupClient;
begin
  LGupShupClient := TGupShupClient.Create(API_KEY, SRC_NAME);
  try
    Result := LGupShupClient.Post(PHONE_FROM, APhoneTo, AMessage);
  finally
    LGupShupClient.Free;
  end;
end;

end.
