unit uMessenger;

interface

uses
  System.SysUtils, System.StrUtils;

type
  TMessageType = (SMS, WhatsApp);
  TServiceProviderEnum = (Twilio, GupShup, Einstein, None);


  TMessenger = class
  private
    function StrToServiceProviderEnum(AProvider: String): TServiceProviderEnum;

    function DoSendSMSMessage(APhoneTo: String; AMessageText: String): Boolean;
    function DoSendWhatsAppMessage(APhoneTo: String; AMessageText: String): Boolean;
    function DoGetServiceProviderParameters(out AServiceProviderEnum: TServiceProviderEnum; out AAPIKey, AAuthToken, APhoneFrom: String): Boolean;
  end;

function SendMessage(APhoneTo: String; AMessageText: String; AMessageType: TMessageType): Boolean;

implementation

{ TMessenger }

uses ServiceProvider.Intf, ServiceProvider.Twilio.Impl, ServiceProvider.GupShup.Impl,
  ServiceProvider.Einstein.Impl, sics_94;

function SendMessage(APhoneTo, AMessageText: String;
  AMessageType: TMessageType): Boolean;
var
  LMessenger: TMessenger;
begin
  if APhoneTo.Trim.IsEmpty then
    raise Exception.Create('Parameter PhoneTo cannot be empty!');

  if AMessageText.Trim.IsEmpty then
    raise Exception.Create('Parameter MessageText cannot be empty!');

  LMessenger := TMessenger.Create;
  try
    case AMessageType of
      SMS: Result := LMessenger.DoSendSMSMessage(APhoneTo, AMessageText);
      WhatsApp: Result := LMessenger.DoSendWhatsAppMessage(APhoneTo, AMessageText);
    else raise Exception.Create('Message Type not found!');
    end;
  finally
    LMessenger.Free;
  end;
end;

function TMessenger.DoGetServiceProviderParameters(
  out AServiceProviderEnum: TServiceProviderEnum; out AAPIKey, AAuthToken,
  APhoneFrom: String): Boolean;
begin
  Result := False;

  AServiceProviderEnum := StrToServiceProviderEnum(vgParametrosModulo.Provider);
  AAPIKey := vgParametrosModulo.APIKey;
  AAuthToken := vgParametrosModulo.APIKey;
  APhoneFrom := vgParametrosModulo.PhoneNumber;

  Result := (AServiceProviderEnum <> TServiceProviderEnum.None) and
            (not AAPIKey.Trim.IsEmpty) and
            (not AAuthToken.Trim.IsEmpty) and
            (not APhoneFrom.Trim.IsEmpty);
end;

function TMessenger.DoSendSMSMessage(APhoneTo, AMessageText: String): Boolean;
begin
  Result := False;
end;

function TMessenger.DoSendWhatsAppMessage(APhoneTo, AMessageText: String): Boolean;
var
  LServiceProvider: IServiceProvider;

  LServiceProviderEnum: TServiceProviderEnum;
  LAPIKey: String;
  LAuthToken: String;
  LPhoneFrom: String;
begin
  if not DoGetServiceProviderParameters(LServiceProviderEnum, LAPIKey, LAuthToken, LPhoneFrom) then
    raise Exception.Create('Parameters not found');

  case LServiceProviderEnum of
    Twilio: LServiceProvider := TServiceProviderTwilio.Create;
    GupShup: LServiceProvider := TServiceProviderGupShup.Create;
    Einstein: LServiceProvider := TServiceProviderEinstein.Create;
  else raise Exception.Create('Service Provider not found');
  end;

  Result := LServiceProvider.Send(LAPIKey, LAuthToken, LPhoneFrom, APhoneTo, AMessageText);
end;

function TMessenger.StrToServiceProviderEnum(
  AProvider: String): TServiceProviderEnum;
begin
  case AnsiIndexStr(AProvider, ['Twilio', 'GupShup', 'Einstein']) of
    0: Result := TServiceProviderEnum.Twilio;
    1: Result := TServiceProviderEnum.GupShup;
    2: Result := TServiceProviderEnum.Einstein;
  else Result := TServiceProviderEnum.None;
  end;
end;

end.
