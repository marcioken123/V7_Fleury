unit ServiceProvider.Intf;

interface

type
  IServiceProvider = interface
  ['{CBF6111C-2610-4EAD-A1B6-13B9B70F3914}']
    function Send(AAPIKey, AAuthToken, APhoneFrom, APhoneTo: String; AMessage: String): Boolean;
  end;

implementation

end.
