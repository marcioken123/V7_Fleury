unit uFuncoes;

interface

uses
  System.SysUtils, System.Classes, System.UITypes, Data.DB, Dialogs, ExtCtrls, MyDlls_DT,
  JvPanel, Menus, IniFiles, JvImage, jpeg, Buttons, JvExExtCtrls, JvComponent, JvComponentBase, JvTrayIcon,
  JvGIF, JvExControls, JvImageTransform, JvSecretPanel, JvBackgrounds,
  JvExStdCtrls, JvBehaviorLabel, JvExtComponent, OleCtrls,
  QuickRpt, ComCtrls, AppEvnts, RealTimeMarquee, ShockwaveFlashObjects_TLB, ASPLabel,
  ComObj, VideoCaptureMain, VideoCapturetypes, WMPLib_TLB, Vcl.Imaging.pngimage, DirectShow9, System.JSON,
  Math, System.Types, untLog, WinAPI.Windows, WinAPI.Messages, FMX.Platform.Win, provider.Types;

function Explode(const Delim, Str: string): TArrString;
procedure VerificaInstanciaApp(WindowTitle: PWideChar; UseFindWindowByTitle : boolean = False);
function MyConverteStringToASCII (s : string; const ConverterTudo : boolean = true; const Decimal : boolean = false) : string;

implementation

{ TResolucaoMonitor }

function Explode(const Delim, Str: string): TArrString;
var
  i: Integer;
begin
  SetLength(Result, 0);
  with TStringList.Create do
  try
    Text := StringReplace(Str, Delim, #13 + #10, [rfReplaceAll]);
    for i := 0 to Count -1 do
    begin
      SetLength(Result, Length(Result) + 1);
      Result[High(Result)] := Strings[i];
    end;
  finally
    Free;
  end;
end;

procedure VerificaInstanciaApp(WindowTitle: PWideChar; UseFindWindowByTitle : boolean);
var
  LHandle: THandle;
begin
  //if(ContaProcessos(ApplicationName(true)) > 1)then
  begin
//    if(UseFindWindowByTitle)then
//      LHandle := FindWindowByTitle(WindowTitle, ApplicationHWND)
//    else
      LHandle := WinAPI.Windows.FindWindow(nil, WindowTitle);
    if(LHandle <> 0)then
    begin
      SendMessage(LHandle, WM_SYSCOMMAND, SC_RESTORE, 0);
      SetForegroundWindow(LHandle);

//      Halt(0);
    end;
  end;
end;

function MyConverteStringToASCII (s : string; const ConverterTudo : boolean = true; const Decimal : boolean = false) : string;
var
  i : integer;
begin
  Result := '';

  for i := 1 to length(s) do
  begin
    if (ConverterTudo) or (s[i] < '!') or (s[i] > 'z') then
    begin
      if Decimal then
        Result := Result + '<' + FormatNumber(3, ord(s[i])) + 'd> '
      else
        Result := Result + '<' + IntToHex(ord(s[i]), 2) + '> '
    end
    else
      Result := Result + s[i] + ' ' ;
  end;
end;

end.
