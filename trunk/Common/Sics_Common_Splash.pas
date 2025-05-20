unit Sics_Common_Splash;

interface

uses
  SysUtils, Windows, Messages, Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Imaging.GIFImg, Vcl.ComCtrls;

type
  TfrmSicsSplash = class(TForm)
    Panel1: TPanel;
    Label3: TLabel;
    Bevel1: TBevel;
    StatusLabel: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    imgLogo: TImage;
    public
      { Public declarations }
      class procedure ShowStatus(const AStatus: string);
      class procedure Hide;
    end;

implementation

{$R *.DFM}

var
  frmSicsSplash: TfrmSicsSplash;

class procedure TfrmSicsSplash.ShowStatus(const AStatus: string);
begin
  if not Assigned(frmSicsSplash) then
    frmSicsSplash := TfrmSicsSplash.Create(Application);

  with frmSicsSplash do
  begin
    StatusLabel.Caption := AStatus;
    Show;
    TGifImage(imgLogo.Picture.Graphic).Animate := True;
  end;
  Application.ProcessMessages;
end;


class procedure TfrmSicsSplash.Hide;
//var
//  Timeout : TDateTime;
begin
  if Assigned(frmSicsSplash) then
  begin
    TGifImage(frmSicsSplash.imgLogo.Picture.Graphic).Animate := False; //necessário parar a animação e então processar as mensagens
    Application.ProcessMessages;          //para que a thread do animate encerre, senão dá access violation no FreeAndNil
    FreeAndNil(frmSicsSplash);
  end;
end;

end.



