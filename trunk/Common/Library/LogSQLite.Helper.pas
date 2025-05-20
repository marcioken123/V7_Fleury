unit LogSQLite.Helper;

interface

uses
  System.SysUtils, LogSQLite, LogSQLite.Config, LogSQLite.DB, REST.HttpClient;

type
  TLogSQLiteHelper = class helper for TLogSQLite
  public
    class function NewApiException(const URL, Method: String; E: Exception): Boolean;
    class function NewApiHTTPProtocolException(const URL, Method: String; E: EHTTPProtocolException): Boolean;
  end;

implementation

{ TLogSQLiteHelper }

class function TLogSQLiteHelper.NewApiException(const URL, Method: String;
  E: Exception): Boolean;
begin
  if not TLogSQLiteConfig.IsActive then
    exit(True);

  var LLog := TLogSQLite.Create(tmError, clResponse, 'IntegracaoAPI (### Erro ###)');
  try
    LLog.AddDetail('Url', URL);
    LLog.AddDetail('Metodo', Method);
    LLog.AddDetail('ExceptionClass', E.ClassName);
    LLog.AddDetail('ExceptionMessage', E.Message);
    result := TLogSQLiteDB.GetInstance.Add(LLog);
  finally
    LLog.Free;
  end;
end;

class function TLogSQLiteHelper.NewApiHTTPProtocolException(const URL,
  Method: String; E: EHTTPProtocolException): Boolean;
begin
  if not TLogSQLiteConfig.IsActive then
    exit(True);

  var LLog := TLogSQLite.Create(tmError, clResponse, 'IntegracaoAPI (### Erro ###)');
  try
    LLog.AddDetail('Url', URL);
    LLog.AddDetail('Metodo', Method);
    LLog.AddDetail('HttpStatusCode', E.ErrorCode.ToString);
    LLog.AddDetail('HttpStatusText', E.ErrorMessage);
    LLog.AddDetail('ConteudoRecebido', E.Message);
    result := TLogSQLiteDB.GetInstance.Add(LLog);
  finally
    LLog.Free;
  end;
end;

end.
