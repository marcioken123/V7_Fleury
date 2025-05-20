unit ServiceProvider.GupShup.Client;

interface

uses
  System.SysUtils, REST.Types, REST.Client;

type
  TGupShupClient = class
  private
    FAPIKey: String;
    FSrcName: String;
  public
    constructor Create(AAPIKey: String; ASrcName: String);

    function Post(APhoneFrom: String; APhoneTo: String; AMessage: String): Boolean;
  end;

const
  CONTENT_TYPE = 'application/x-www-form-urlencoded';
  URL = 'https://api.gupshup.io/sm/api/v1/msg';
  CHANNEL = 'whatsapp';
  &MESSAGE = '{"isHSM":"true","type":"text","text":"%s"}';

implementation

{ TGupShupClient }

constructor TGupShupClient.Create(AAPIKey, ASrcName: String);
begin
  FAPIKey := AAPIKey;
  FSrcName := ASrcName;
end;

function TGupShupClient.Post(APhoneFrom, APhoneTo, AMessage: String): Boolean;
var
  LRESTClient: TRESTClient;
  LRESTRequest: TRESTRequest;
  LRESTResponse: TRESTResponse;
  LParameter: TRESTRequestParameter;
begin
  LRESTClient := TRESTClient.Create(nil);
  try
    LRESTClient.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
    LRESTClient.AcceptCharset := 'utf-8, *;q=0.8';
    LRESTClient.BaseURL := URL;
    LRESTClient.ContentType := CONTENT_TYPE;

    LRESTClient.RaiseExceptionOn500 := False;

    LRESTResponse := TRESTResponse.Create(nil);
    try
      LRESTResponse.ContentType := 'application/json';

      LRESTRequest := TRESTRequest.Create(nil);
      try
        LRESTRequest.Client := LRESTClient;
        LRESTRequest.Method := rmPOST;

        LParameter := LRESTRequest.Params.AddItem;
        LParameter.Name := 'channel';
        LParameter.Value := CHANNEL;
        LParameter.Kind := pkGETorPOST;

        LParameter := LRESTRequest.Params.AddItem;
        LParameter.Name := 'source';
        LParameter.Value := APhoneFrom;
        LParameter.Kind := pkGETorPOST;

        LParameter := LRESTRequest.Params.AddItem;
        LParameter.Name := 'destination';
        LParameter.Value := APhoneTo;
        LParameter.Kind := pkGETorPOST;

        LParameter := LRESTRequest.Params.AddItem;
        LParameter.Name := 'message';
        LParameter.Value := Format(&MESSAGE, [AMessage]);
        LParameter.Kind := pkGETorPOST;

        LParameter := LRESTRequest.Params.AddItem;
        LParameter.Name := 'src.name';
        LParameter.Value := FSrcName;
        LParameter.Kind := pkGETorPOST;

        LParameter := LRESTRequest.Params.AddItem;
        LParameter.Name := 'apikey';
        LParameter.Value := FAPIKey;
        LParameter.Kind := pkHTTPHEADER;

        LRESTRequest.Response := LRESTResponse;

        LRESTRequest.SynchronizedEvents := False;

        LRESTRequest.Execute;

        Result := LRESTResponse.StatusCode = 200;
      finally
        LRESTRequest.Free;
      end;
    finally
      LRESTResponse.Free;
    end;
  finally
    LRESTClient.Free;
  end;
end;

end.
