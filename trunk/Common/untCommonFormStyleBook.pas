unit untCommonFormStyleBook;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls

  {$IFDEF MSWINDOWS}
    , Winapi.Windows, System.Win.Registry
  {$ENDIF}
  ;

type
  TfrmStyleBook = class(TForm)
    stbWin10: TStyleBook;
    stbWin7: TStyleBook;
  private
    { Private declarations }
    {$IFDEF MSWINDOWS}
    //function GetWindowsVersion: String;
    {$ENDIF}
  public
    { Public declarations }
    function GetStyleBook: TStyleBook;
  end;

var
  frmStyleBook: TfrmStyleBook;

implementation

{$R *.fmx}

function TfrmStyleBook.GetStyleBook: TStyleBook;
const
  TAG_WINDOWS_10 = 'WINDOWS 10';
begin
  Result := stbWin10;

  {$IFDEF MSWINDOWS}
  if not TOSVersion.Name.ToUpper.Contains(TAG_WINDOWS_10) then
     Result := stbWin7;
//  if not GetWindowsVersion.ToUpper.Contains(TAG_WINDOWS_10) then
//  begin
//    Result := stbWin7;
//  end;
  {$ENDIF}
end;

//{$IFDEF MSWINDOWS}
//function TfrmStyleBook.GetWindowsVersion: String;
//var
//  LName,
//  LVersion,
//  LCurrentBuild: String;
//  LReg: TRegistry;
//begin
//  LReg := TRegistry.Create;
//  try
//    LReg.Access  := KEY_READ;
//    LReg.RootKey := HKEY_LOCAL_MACHINE;
//
//    LReg.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion\', true);
//
//    LName := LReg.ReadString('ProductName');
//    LVersion := LReg.ReadString('CurrentVersion');
//    LCurrentBuild := LReg.ReadString('CurrentBuild');
//
//    Result := LName + ' - ' + LVersion + ' - ' + LCurrentBuild;
//  finally
//    LReg.CloseKey;
//    LReg.Free;
//  end;
//end;
//{$ENDIF}

end.
