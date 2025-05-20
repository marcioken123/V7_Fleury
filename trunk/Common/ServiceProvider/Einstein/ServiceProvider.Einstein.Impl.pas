unit ServiceProvider.Einstein.Impl;

interface

uses System.SysUtils, System.Classes, ServiceProvider.Intf;

type
  TServiceProviderEinstein = class(TInterfacedObject, IServiceProvider)
  public
    function Send(AAPIKey, AAuthToken, APhoneFrom, APhoneTo, AMessage: String): Boolean;
  end;

implementation

{ TServiceProviderEinstein }

function TServiceProviderEinstein.Send(AAPIKey, AAuthToken, APhoneFrom, APhoneTo,
  AMessage: String): Boolean;
begin
  raise Exception.Create('Interface not implemented');
end;

end.
