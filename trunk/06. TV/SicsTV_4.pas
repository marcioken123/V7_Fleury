unit SicsTV_4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, JvExExtCtrls, JvImage;

type
  TfrmSicsLogo = class(TForm)
    JvImage1: TJvImage;
    procedure JvImage1Click(Sender: TObject);
    procedure CreateParams(var Params: TCreateParams); override;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSicsLogo: TfrmSicsLogo;

implementation

{$R *.dfm}

procedure TfrmSicsLogo.CreateParams(var Params: TCreateParams);
begin
  Inherited CreateParams(Params);
  with Params do
    Style := Style + WS_DISABLED;
end;


procedure TfrmSicsLogo.JvImage1Click(Sender: TObject);
begin
  sHOWmESSAGE('TESTE');
end;

procedure TfrmSicsLogo.FormCreate(Sender: TObject);
const
  OFF = 5;
begin
  ClientHeight := JvImage1.Height + OFF;
  ClientWidth  := JvImage1.Width  + OFF;
end;

end.
