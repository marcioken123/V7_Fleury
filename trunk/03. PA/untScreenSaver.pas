unit untScreenSaver;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts,
  FMX.ExtCtrls, FMX.Gestures;

type
  TFrmScreenSaver = class(TForm)
    pnlFundo: TPanel;
    stbFundo: TStyleBook;
    imgLogo: TImage;
    tmrLogo: TTimer;
    procedure tmrLogoTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormTouch(Sender: TObject; const Touches: TTouches;
      const Action: TTouchAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmScreenSaver: TFrmScreenSaver;

implementation

uses
  untSicsPA;

{$R *.fmx}

procedure TFrmScreenSaver.FormCreate(Sender: TObject);
begin
  {$IFDEF IS_MOBILE}
    //BAH FrmSicsPA.tmrScreenSaver.Enabled:= True;
  {$ENDIF}
end;

procedure TFrmScreenSaver.FormTouch(Sender: TObject;
  const Touches: TTouches; const Action: TTouchAction);
begin
  {$IFDEF IS_MOBILE}
    Self.Visible := False;
    Self.Close;
   //BAH FrmSicsPA.tmrScreenSaver.Enabled := False;
  {$ENDIF}
end;

procedure TFrmScreenSaver.tmrLogoTimer(Sender: TObject);
begin
  {$IFDEF IS_MOBILE}
    imgLogo.Position.Y := Random(ClientHeight);
    imgLogo.Position.X := Random(ClientWidth);
  {$ENDIF}
end;
end.
