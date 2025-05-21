unit Providers.FileUtils;

interface

type
  TFileUtils = class
  public
    class function GetFileVersion(const AFile: string): string;
  end;

implementation

uses Winapi.Windows, System.SysUtils;

class function TFileUtils.GetFileVersion(const AFile: string): string;
var
  Size, Handle: DWORD;
  Buffer: TBytes;
  FixedPtr: PVSFixedFileInfo;
begin
  Result := '0.0.0.0';
  if FileExists(AFile) then
  begin
    Size := GetFileVersionInfoSize(PChar(AFile), Handle);
    if Size = 0 then
      RaiseLastOSError;
    SetLength(Buffer, Size);
    if not GetFileVersionInfo(PChar(AFile), Handle, Size, Buffer) then
      RaiseLastOSError;
    if not VerQueryValue(Buffer, '\', Pointer(FixedPtr), Size) then
      RaiseLastOSError;
    Result := Format('%d.%d.%d.%d', [LongRec(FixedPtr.dwFileVersionMS).Hi, LongRec(FixedPtr.dwFileVersionMS).Lo,
      LongRec(FixedPtr.dwFileVersionLS).Hi, LongRec(FixedPtr.dwFileVersionLS).Lo]);
  end;
end;

end.
