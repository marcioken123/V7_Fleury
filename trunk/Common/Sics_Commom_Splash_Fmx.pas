unit Sics_Commom_Splash_Fmx;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts;

type
  TfrmSICSSplashFmx = class(TForm)
    SICS: TLabel;
    Label1: TLabel;
    StatusLabel: TLabel;
    Line1: TLine;
    Rectangle1: TRectangle;
    Layout1: TLayout;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class procedure ShowStatus(const AStatus: string);
    class procedure Hide;
  end;

implementation

{$R *.fmx}

var
  frmSICSSplashFmx: TfrmSICSSplashFmx;

class procedure TfrmSICSSplashFmx.ShowStatus(const AStatus: string);
begin
  if not Assigned(frmSICSSplashFmx) then
    frmSICSSplashFmx := TfrmSICSSplashFmx.Create(Application);

  with frmSICSSplashFmx do
  begin
    StatusLabel.Text := AStatus;
    Show;
    //TGifImage(imgLogo.Picture.Graphic).Animate := True;
  end;
  Application.ProcessMessages;
end;


procedure TfrmSICSSplashFmx.FormCreate(Sender: TObject);
begin
  height := 200;
  width := 208
end;

class procedure TfrmSICSSplashFmx.Hide;
begin
  if Assigned(frmSICSSplashFmx) then
  begin
    //TGifImage(frmSicsSplash.imgLogo.Picture.Graphic).Animate := False; //necessário parar a animação e então processar as mensagens
    Application.ProcessMessages;                                         //para que a thread do animate encerre, senão dá access violation no FreeAndNil
    FreeAndNil(frmSICSSplashFmx);
  end;
end;


end.
