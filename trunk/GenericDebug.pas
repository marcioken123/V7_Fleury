unit GenericDebug;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo;

type
  TfrmDebug = class(TForm)
    memoDebug: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure MyDebug(s : string);

implementation

{$R *.fmx}

var
  frmDebug: TfrmDebug;

{ TfrmDebug }

procedure MyDebug(s: string);
var
  i: Integer;
begin
  if not Assigned(frmDebug) then
    frmDebug := TfrmDebug.Create(Application);

  frmDebug.Show;

  frmDebug.memoDebug.Lines.Add(FormatDateTime('hh:nn:ss,zzz', now) + ' - ' + s);

  if frmDebug.memoDebug.Lines.Count > 1500 then
  begin
    for i := 1 to 500 do
      frmDebug.memoDebug.Lines.Delete(0);
    frmDebug.memoDebug.GoToTextEnd;
  end;
end;

end.
