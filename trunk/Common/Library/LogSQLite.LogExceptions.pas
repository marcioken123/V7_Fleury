unit LogSQLite.LogExceptions;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils, System.Math, LogSQLite;

type
  TLogSQLiteExceptions = class
  strict private
    class var FLogDir: String;
    class function GetLogName(const ADateTime: TDateTime): String;
  public
    class constructor Create; //initialization
    class procedure Log(const AExceptionMsg: String); overload;
    class procedure Log(const AExceptionMsg: String; ALogSQLIte: TLogSQLite); overload;
    class procedure Log(const AExceptionMsg, ALogSQLite: String); overload;
  end;


implementation

{ TLogSQLiteExceptions }

class constructor TLogSQLiteExceptions.Create;
var
  LAppPath: String;
  LLogPath: String;
begin
  {$IFDEF MSWINDOWS}
  LAppPath := ExtractFilePath(ParamStr(0));
  {$ELSE}
  LAppPath := TPath.GetDocumentsPath;
  {$ENDIF}
  LLogPath := TPath.Combine(LAppPath, 'LogSQLiteExceptions');
  if not ForceDirectories(LLogPath) then
    LLogPath := LAppPath;
  FLogDir := LLogPath;
end;

class function TLogSQLiteExceptions.GetLogName(const ADateTime: TDateTime): String;
var
  LFileName, LFullFilePath, LFileNumber: String;
  LRandom: integer;
  LNumber: string;
begin
  Randomize;
  LRandom := RandomRange(0, 999999999);
  LNumber := FormatFloat('000000000', LRandom);
  LFileName := FormatDateTime('YYYY-MM-DD-HH-NN-SS-ZZZ-', ADateTime) + LNumber + '.log';
  LFullFilePath := TPath.Combine(FLogDir, LFileName);
  LFileNumber := EmptyStr;
  while FileExists(LFullFilePath + LFileNumber) do
    LFileNumber := FormatFloat('00', StrToIntDef(LFileNumber, 0) + 1);
  result := LFullFilePath + LFileNumber;
end;

class procedure TLogSQLiteExceptions.Log(const AExceptionMsg,
  ALogSQLite: String);
var
  LDataHora: TDateTime;
  LFileName, LText: String;
  LStrStream: TStringStream;
begin
  LDataHora := Now;
  LFileName := GetLogName(LDataHora);
  LText := FormatDateTime('DD/MM/YY HH:NN:SS.ZZZ', LDataHora) + '||' +
           AExceptionMsg + '||' +
           ALogSQLite;
  LStrStream := TStringStream.Create(LText, TEncoding.UTF8);
  try
    LStrStream.SaveToFile(LFileName);
  finally
    LStrStream.Free;
  end;
end;

class procedure TLogSQLiteExceptions.Log(const AExceptionMsg: String;
  ALogSQLIte: TLogSQLite);
begin
  if Assigned(ALogSQLIte) then
    Log(AExceptionMsg, ALogSQLIte.ToString)
  else
    Log(AExceptionMsg);
end;

class procedure TLogSQLiteExceptions.Log(const AExceptionMsg: String);
begin
  Log(AExceptionMsg, EmptyStr);
end;

end.
