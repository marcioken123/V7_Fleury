unit APIs.Common;

interface

uses
  System.SysUtils, System.DateUtils, System.Json, REST.Types, REST.HttpClient, REST.Client, System.Classes, System.NetEncoding,
{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
  LogSQLite,
  LogSQLite.Helper,
{$ENDIF CompilarPara_TotemAA}
{$ENDIF IS_MOBILE}
  System.Net.Mime, AspHttpRequest ;

type
  TTipoRetornoApi = (raOK, raErroComunicacao, raErroNegocio, raException);

{$IFNDEF IS_MOBILE}
const
  Desc_TTipoRetornoAPI : array[TTipoRetornoApi] of string[20] = ('Retorno OK', 'Erro de comunicação', 'Erro de negócio', 'Exception');
{$ENDIF IS_MOBILE}

type
  TErroAPI = record
               CodErro : integer;
               MsgErro : string;
             end;

  PBytes = ^TBytes;

var
  FTimeOut : integer;

function IntegracaoAPI_Post(const AURL: string; const AJson: TJSONArray;out ARetornoAPI: string;out AErroAPI: TErroAPI;const ATentivas: Integer;const AuthorizationHeaderToken: string = ''): TTipoRetornoAPI; overload;
function IntegracaoAPI_Post(const AURL: string; const AJson: TJSONObject;out ARetornoAPI: string;out AErroAPI: TErroAPI;const ATentivas: Integer;const AuthorizationHeaderToken: string = ''; const AGravarLog:boolean = True): TTipoRetornoAPI; overload;
function IntegracaoAPI_Post(const AURL: string; const AAccept, AContentType:string; const AJson: TJSONArray;out ARetornoAPI: string;out AErroAPI: TErroAPI;const ATentivas: Integer;const AuthorizationHeaderToken: string = ''): TTipoRetornoAPI; overload;
function IntegracaoAPI_Post(const AURL: string; const AAccept, AContentType:string; const AJson: TJSONObject;out ARetornoAPI: string;out AErroAPI: TErroAPI;const ATentivas: Integer;const AuthorizationHeaderToken: string = ''): TTipoRetornoAPI; overload;
function IntegracaoAPI_Post(const AURL: string; const AJson: TJSONArray;out ARetornoAPI: string;out AErroAPI: TErroAPI;const ATentivas: Integer;const ACustomHeader:TCustomHeader): TTipoRetornoAPI; overload;
function IntegracaoAPI_Post(const AURL: string; const AJson: TJSONObject; out ARetornoAPI: string; out AErroAPI: TErroAPI; const ATentivas: Integer; const ACustomHeader:TCustomHeader): TTipoRetornoAPI; overload;
function IntegracaoAPI_Post(const AURL: string; const AJson: TJSONObject; out ARetornoAPI: string; out AErroAPI: TErroAPI; const ATentivas: Integer; const ACustomHeader:Array of TCustomHeader): TTipoRetornoAPI; overload;
function IntegracaoAPI_Post(const AURL: string; const AJson: TJSONObject; out ARetornoAPI: string; out AErroAPI: TErroAPI; const ATentivas: Integer; const ACustomHeader:Array of TCustomHeader; const AGravarLog:boolean = True): TTipoRetornoAPI; overload;
function IntegracaoAPI_Post(const AURL: string; const AMultiPartFormData: TMultipartFormData;out ARetornoAPI: string;out AErroAPI: TErroAPI;const ATentivas: Integer;const ACustomHeader:TCustomHeader; const AGravarLog:boolean = True): TTipoRetornoAPI; overload;
function IntegracaoAPI_Post(const AURL: string; const ARestRequest: TRestRequest; out ARetornoAPI: string; out AErroAPI: TErroAPI; const ATentivas: Integer): TTipoRetornoAPI; overload;
function IntegracaoAPI_Get(const AURL: string; out ARetornoAPI: string; out AErroAPI: TErroAPI; const ACustomHeader:TCustomHeader ): TTipoRetornoAPI; overload;
function IntegracaoAPI_Get(const AURL: string; out ARetornoAPI: string; out AErroAPI: TErroAPI; const AuthorizationHeaderToken: string = ''; const AGravarLog:boolean = True): TTipoRetornoAPI; overload;
function IntegracaoAPI_Put(const AURL: string; const AJson: TJSONObject;out ARetornoAPI: string;out AErroAPI: TErroAPI;const ATentivas: Integer;const AuthorizationHeaderToken: string = ''): TTipoRetornoAPI; overload;

function EncodeString(AParam: String): String;
function DecodeString(AParam: String): String;

implementation

{$IFNDEF IS_MOBILE}
uses
  WinApi.Windows,
  untLog;
{$ENDIF IS_MOBILE}

function IntIntegracaoAPI_Post(const AURL: string; const AJson: TJSONArray; out ARetornoAPI: string; out AErroAPI: TErroAPI; const ATentivas, ATentativaAtual: Integer; const AuthorizationHeaderToken: string): TTipoRetornoAPI; overload;
var
  LStreamJson: TStringStream;
  LStreamRes: TStringStream;
  LStatusCode: string;
  LEnviadoEm : TDateTime;
  LTempoDecorrido : integer;
begin
{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
{$IFDEF DEBUG}
  TLogSQLite.New(tmInfo, clRequest, 'IntegracaoAPI (Enviando)')
    .AddDetail('Tentativa'      , ATentativaAtual)
    .AddDetail('Url'            , AURL           )
    .AddDetail('Metodo'         , 'POST'         )
    .AddDetail('ConteudoEnviado', AJson.ToString )
    .Save;
{$ENDIF DEBUG}
  TLog.MyLogTemp('IntegracaoAPI (Enviando). ' +
                 'Tentativa: "'       + IntToStr(ATentativaAtual) + '" | ' +
                 'Url: "'             + AURL                      + '" | ' +
                 'Metodo: "'          + 'POST'                    + '" | ' +
                 'ConteudoEnviado: "' + AJson.ToString            + '"',
                 nil, 0, False, TCriticalLog.tlINFO);
{$ENDIF CompilarPara_TotemAA}
{$ENDIF IS_MOBILE}
  LStreamJson := TStringStream.Create(Utf8Encode(AJson.ToJSON));
  LStreamRes := TStringStream.Create;
  try
    try
      try
        LEnviadoEm := now;
        LStatusCode:= THTTPRequest.Post(AURL, LStreamJson, LStreamRes, FTimeOut, AuthorizationHeaderToken).StatusCode.ToString;
        LTempoDecorrido := MilliSecondsBetween(Now, LEnviadoEm);
        ARetornoAPI := UTF8ToString(LStreamRes.DataString);

        //LBC: Futuramente remover isso daqui (quando todas as APIs estiverem em units sepaadas)
        if ((ARetornoAPI.Contains('Error receiving data')) or (ARetornoAPI.Contains('ERRO #5001')) or (ARetornoAPI.Contains('ERRO #5808'))) then
        begin
          Result := raErroComunicacao;
          AErroAPI.CodErro := -1;
          AErroAPI.MsgErro := 'Conteúdo recebido veio com palavras chave que indicam erro.';

{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
          TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
            .AddDetail('Tentativa'       , ATentativaAtual                        )
            .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroComunicacao])
            .AddDetail('Url'             , AURL                                   )
            .AddDetail('Metodo'          , 'POST'                                 )
            .AddDetail('ConteudoEnviado' , AJson.ToString                         )
            .AddDetail('ConteudoRecebido', ARetornoAPI                            )
            .AddDetail('HttpStatusCode'  , LStatusCode                            )
            .AddDetail('ErroCatalogado'  , AErroApi.CodErro                       )
            .AddDetail('TempoDecorrido'  , LTempoDecorrido                        )
            .Save;
          TLog.MyLogTemp('IntegracaoAPI (### Erro ###). ' +
                         'Tentativa: "'        + IntToStr(ATentativaAtual)               + '" | ' +
                         'TipoErro: "'         + Desc_TTipoRetornoAPI[raErroComunicacao] + '" | ' +
                         'Url: "'              + AURL                                    + '" | ' +
                         'Metodo: "'           + 'POST'                                  + '" | ' +
                         'ConteudoEnviado: "'  + AJson.ToString                          + '" | ' +
                         'ConteudoRecebido: "' + ARetornoAPI                             + '" | ' +
                         'HttpStatusCode: "'   + LStatusCode                             + '" | ' +
                         'ErroCatalogado: "'   + IntToStr(AErroApi.CodErro)              + '" | ' +
                         'TempoDecorrido: "'   + LTempoDecorrido.ToString                + '"',
                         nil, 0, False, TCriticalLog.tlERROR);
{$ENDIF CompilarPara_TotemAA}
{$ENDIF IS_MOBILE}
        end
        else
        begin
          Result := raOK;
          AErroAPI.CodErro := 0;
          AErroAPI.MsgErro := '';

{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
          TLogSQLite.New(tmInfo, clResponse, 'IntegracaoAPI (Resultado Ok)')
            .AddDetail('Tentativa'       , ATentativaAtual)
            .AddDetail('Url'             , AURL           )
            .AddDetail('Metodo'          , 'POST'         )
            .AddDetail('ConteudoEnviado' , AJson.ToString )
            .AddDetail('ConteudoRecebido', ARetornoAPI    )
            .AddDetail('HttpStatusCode'  , LStatusCode    )
            .AddDetail('TempoDecorrido'  , LTempoDecorrido)
            .Save;
          TLog.MyLogTemp('IntegracaoAPI (Resultado Ok). ' +
                         'Tentativa: "'        + InTtoStr(ATentativaAtual) + '" | ' +
                         'Url: "'              + AURL                      + '" | ' +
                         'Metodo: "'           + 'POST'                    + '" | ' +
                         'ConteudoEnviado: "'  + AJson.ToString            + '" | ' +
                         'ConteudoRecebido: "' + ARetornoAPI               + '" | ' +
                         'HttpStatusCode: "'   + LStatusCode               + '" | ' +
                         'TempoDecorrido: "'   + LTempoDecorrido.ToString  + '"',
                         nil, 0, False, TCriticalLog.tlINFO);
{$ENDIF CompilarPara_TotemAA}
{$ENDIF IS_MOBILE}
        end;
      except
        on E: Exception do
        begin
          AErroAPI.CodErro := -1;
          AErroAPI.MsgErro := E.Message;

          if E is EHTTPProtocolException then
          begin
            Result := raErroComunicacao;
{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
            TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
              .AddDetail('Tentativa'       , ATentativaAtual                             )
              .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroComunicacao]     )
              .AddDetail('Url'             , AURL                                        )
              .AddDetail('Metodo'          , 'POST'                                      )
              .AddDetail('ConteudoEnviado' , AJson.ToString                              )
              .AddDetail('ConteudoRecebido', E.Message                                   )
              .AddDetail('HttpStatusCode'  , EHTTPProtocolException(E).ErrorCode.ToString)
              .AddDetail('HttpStatusText'  , EHTTPProtocolException(E).ErrorMessage      )
              .AddDetail('ErroCatalogado'  , AErroApi.CodErro                            )
              .AddDetail('TempoDecorrido'  , LTempoDecorrido                             )
              .Save;
            TLog.MyLogTemp('IntegracaoAPI (### Erro ###). ' +
                           'Tentativa: "'        + IntToStr(ATentativaAtual)                     + '" | ' +
                           'TipoErro: "'         + Desc_TTipoRetornoAPI[raErroComunicacao]       + '" | ' +
                           'Url: "'              + AURL                                          + '" | ' +
                           'Metodo: "'           + 'POST'                                        + '" | ' +
                           'ConteudoEnviado: "'  + AJson.ToString                                + '" | ' +
                           'ConteudoRecebido: "' + E.Message                                     + '" | ' +
                           'HttpStatusCode: "'   + EHTTPProtocolException(E).ErrorCode.ToString  + '" | ' +
                           'HttpStatusText: "'   + EHTTPProtocolException(E).ErrorMessage        + '" | ' +
                           'ErroCatalogado: "'   + IntToStr(AErroApi.CodErro)                    + '" | ' +
                           'TempoDecorrido: "'   + LTempoDecorrido.ToString                      + '"',
                           nil, 0, False, TCriticalLog.tlERROR);
{$ENDIF CompilarPara_TotemAA}
{$ENDIF IS_MOBILE}

            AErroAPI.CodErro := EHTTPProtocolException(E).ErrorCode;  //LBC: Verificar esta linha pois o AErroAPI.CodErro deveria retornar um Erro Catalogado da Aplicação TotemAA, porém foi populado com o HttpErrorCode e necessário verificar o que está fazendo com essa informação ao sair desse método
          end
          else
          begin
            Result := raException;
{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
            TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
              .AddDetail('Tentativa'       , ATentativaAtual                  )
              .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raException])
              .AddDetail('Url'             , AURL                             )
              .AddDetail('Metodo'          , 'POST'                           )
              .AddDetail('ConteudoEnviado' , AJson.ToString                   )
              .AddDetail('ErroCatalogado'  , AErroApi.CodErro                 )
              .AddDetail('ExceptionMessage', E.Message                        )
              .AddDetail('TempoDecorrido'  , LTempoDecorrido                  )
              .Save;
            TLog.MyLogTemp('IntegracaoAPI (### Erro ###). ' +
                           'Tentativa: "'        + IntToStr(ATentativaAtual)         + '" | ' +
                           'TipoErro: "'         + Desc_TTipoRetornoAPI[raException] + '" | ' +
                           'Url: "'              + AURL                              + '" | ' +
                           'Metodo: "'           + 'POST'                            + '" | ' +
                           'ConteudoEnviado: "'  + AJson.ToString                    + '" | ' +
                           'ErroCatalogado: "'   + IntToStr(AErroApi.CodErro)        + '" | ' +
                           'ExceptionMessage: "' + E.Message                         + '" | ' +
                           'TempoDecorrido: "'   + LTempoDecorrido.ToString          + '"',
                           nil, 0, False, TCriticalLog.tlERROR);
{$ENDIF CompilarPara_TotemAA}
{$ENDIF IS_MOBILE}
          end;

          if ATentativaAtual < ATentivas then
          begin
            Sleep(2000);
            Result := IntIntegracaoAPI_Post(AURL, AJson, ARetornoAPI, AErroAPI, ATentivas, ATentativaAtual + 1, AuthorizationHeaderToken);
          end;
        end;
      end;
    finally
      LStreamRes.Free;
    end;
  finally
    LStreamJson.Free;
  end;
end;

function IntIntegracaoAPI_Post(const AURL: string; const AJson: TJSONObject; out ARetornoAPI: string; out AErroAPI: TErroAPI; const ATentivas, ATentativaAtual: Integer; const AuthorizationHeaderToken: string; const AGravarLog: boolean): TTipoRetornoAPI; overload; overload;
var
  LStreamJson: TStringStream;
  LStreamRes: TStringStream;
  LStatusCode: string;
  LEnviadoEm : TDateTime;
  LTempoDecorrido : integer;
begin
{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
  if AGravarLog then
  begin
{$IFDEF DEBUG}
    TLogSQLite.New(tmInfo, clRequest, 'IntegracaoAPI (Enviando)')
      .AddDetail('Tentativa'      , ATentativaAtual)
      .AddDetail('Url'            , AURL           )
      .AddDetail('Metodo'         , 'POST'         )
      .AddDetail('ConteudoEnviado', AJson.ToString )
      .Save;
{$ENDIF DEBUG}
    TLog.MyLogTemp('IntegracaoAPI (Enviando). ' +
                   'Tentativa: "'       + IntToStr(ATentativaAtual) + '" | ' +
                   'Url: "'             + AURL                      + '" | ' +
                   'Metodo: "'          + 'POST'                    + '" | ' +
                   'ConteudoEnviado: "' + AJson.ToString            + '"',
                   nil, 0, False, TCriticalLog.tlINFO);
  end;
{$ENDIF CompilarPara_TotemAA}
{$ENDIF IS_MOBILE}

  LStreamJson := TStringStream.Create(Utf8Encode(AJson.ToJSON));
  LStreamRes := TStringStream.Create;
  try
    try
      try
        LTempoDecorrido := -1;
        LEnviadoEm := now;
        LStatusCode:= THTTPRequest.Post(AURL, LStreamJson, LStreamRes, FTimeOut, AuthorizationHeaderToken).StatusCode.ToString;
        LTempoDecorrido := MilliSecondsBetween(Now, LEnviadoEm);

        ARetornoAPI := UTF8ToString(LStreamRes.DataString);

        //LBC: Futuramente remover isso daqui (quando todas as APIs estiverem em units sepaadas)
        if ((ARetornoAPI.Contains('Error receiving data')) or (ARetornoAPI.Contains('ERRO #5001')) or (ARetornoAPI.Contains('ERRO #5808'))) then
        begin
          Result := raErroComunicacao;
          AErroAPI.CodErro := -1;
          AErroAPI.MsgErro := 'Conteúdo recebido veio com palavras chave que indicam erro.';

{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
          if AGravarLog then
          begin
            TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
              .AddDetail('Tentativa'       , ATentativaAtual                        )
              .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroComunicacao])
              .AddDetail('Url'             , AURL                                   )
              .AddDetail('Metodo'          , 'POST'                                 )
              .AddDetail('ConteudoEnviado' , AJson.ToString                         )
              .AddDetail('ConteudoRecebido', ARetornoAPI                            )
              .AddDetail('HttpStatusCode'  , LStatusCode                            )
              .AddDetail('ErroCatalogado'  , AErroApi.CodErro                       )
              .AddDetail('TempoDecorrido'  , LTempoDecorrido                        )
              .Save;
            TLog.MyLogTemp('IntegracaoAPI (### Erro ###). ' +
                           'Tentativa: "'        + IntToStr(ATentativaAtual)               + '" | ' +
                           'TipoErro: "'         + Desc_TTipoRetornoAPI[raErroComunicacao] + '" | ' +
                           'Url: "'              + AURL                                    + '" | ' +
                           'Metodo: "'           + 'POST'                                  + '" | ' +
                           'ConteudoEnviado: "'  + AJson.ToString                          + '" | ' +
                           'ConteudoRecebido: "' + ARetornoAPI                             + '" | ' +
                           'HttpStatusCode: "'   + LStatusCode                             + '" | ' +
                           'ErroCatalogado: "'   + IntToStr(AErroApi.CodErro)              + '" | ' +
                           'TempoDecorrido: "'   + LTempoDecorrido.ToString                + '"',
                           nil, 0, False, TCriticalLog.tlERROR);
          end;
{$ENDIF CompilarPara_TotemAA}
{$ENDIF IS_MOBILE}
        end
        else
        begin
          Result := raOK;
          AErroAPI.CodErro := 0;
          AErroAPI.MsgErro := '';

{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
          if AGravarLog then
          begin
            TLogSQLite.New(tmInfo, clResponse, 'IntegracaoAPI (Resultado Ok)')
              .AddDetail('Tentativa'       , ATentativaAtual)
              .AddDetail('Url'             , AURL           )
              .AddDetail('Metodo'          , 'POST'         )
              .AddDetail('ConteudoEnviado' , AJson.ToString )
              .AddDetail('ConteudoRecebido', ARetornoAPI    )
              .AddDetail('HttpStatusCode'  , LStatusCode    )
              .AddDetail('TempoDecorrido'  , LTempoDecorrido)
              .Save;
            TLog.MyLogTemp('IntegracaoAPI (Resultado Ok). ' +
                           'Tentativa: "'        + InTtoStr(ATentativaAtual) + '" | ' +
                           'Url: "'              + AURL                      + '" | ' +
                           'Metodo: "'           + 'POST'                    + '" | ' +
                           'ConteudoEnviado: "'  + AJson.ToString            + '" | ' +
                           'ConteudoRecebido: "' + ARetornoAPI               + '" | ' +
                           'HttpStatusCode: "'   + LStatusCode               + '" | ' +
                           'TempoDecorrido: "'   + LTempoDecorrido.ToString  + '"',
                           nil, 0, False, TCriticalLog.tlINFO);
          end;
{$ENDIF CompilarPara_TotemAA}
{$ENDIF IS_MOBILE}
        end;
      except
        on E: Exception do
        begin
          AErroAPI.CodErro := -1;
          AErroAPI.MsgErro := E.Message;

          if E is EHTTPProtocolException then
          begin
            Result := raErroComunicacao;
{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
            if AGravarLog then
            begin

              TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
                .AddDetail('Tentativa'       , ATentativaAtual                             )
                .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroComunicacao]     )
                .AddDetail('Url'             , AURL                                        )
                .AddDetail('Metodo'          , 'POST'                                      )
                .AddDetail('ConteudoEnviado' , AJson.ToString                              )
                .AddDetail('ConteudoRecebido', E.Message                                   )
                .AddDetail('HttpStatusCode'  , EHTTPProtocolException(E).ErrorCode.ToString)
                .AddDetail('HttpStatusText'  , EHTTPProtocolException(E).ErrorMessage      )
                .AddDetail('ErroCatalogado'  , AErroApi.CodErro                            )
                .AddDetail('TempoDecorrido'  , LTempoDecorrido                             )
                .Save;
              TLog.MyLogTemp('IntegracaoAPI (### Erro ###). ' +
                             'Tentativa: "'        + IntToStr(ATentativaAtual)                     + '" | ' +
                             'TipoErro: "'         + Desc_TTipoRetornoAPI[raErroComunicacao]       + '" | ' +
                             'Url: "'              + AURL                                          + '" | ' +
                             'Metodo: "'           + 'POST'                                        + '" | ' +
                             'ConteudoEnviado: "'  + AJson.ToString                                + '" | ' +
                             'ConteudoRecebido: "' + E.Message                                     + '" | ' +
                             'HttpStatusCode: "'   + EHTTPProtocolException(E).ErrorCode.ToString  + '" | ' +
                             'HttpStatusText: "'   + EHTTPProtocolException(E).ErrorMessage        + '" | ' +
                             'ErroCatalogado: "'   + IntToStr(AErroApi.CodErro)                    + '" | ' +
                             'TempoDecorrido: "'   + LTempoDecorrido.ToString                      + '"',
                             nil, 0, False, TCriticalLog.tlERROR);
            end;
{$ENDIF CompilarPara_TotemAA}
{$ENDIF IS_MOBILE}

            AErroAPI.CodErro := EHTTPProtocolException(E).ErrorCode;  //LBC: Verificar esta linha pois o AErroAPI.CodErro deveria retornar um Erro Catalogado da Aplicação TotemAA, porém foi populado com o HttpErrorCode e necessário verificar o que está fazendo com essa informação ao sair desse método
          end
          else
          begin
            Result := raException;
{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
            if AGravarLog then
            begin

              TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
                .AddDetail('Tentativa'       , ATentativaAtual                  )
                .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raException])
                .AddDetail('Url'             , AURL                             )
                .AddDetail('Metodo'          , 'POST'                           )
                .AddDetail('ConteudoEnviado' , AJson.ToString                   )
                .AddDetail('ErroCatalogado'  , AErroApi.CodErro                 )
                .AddDetail('ExceptionMessage', E.Message                        )
                .AddDetail('TempoDecorrido'  , LTempoDecorrido                  )
                .Save;
              TLog.MyLogTemp('IntegracaoAPI (### Erro ###). ' +
                             'Tentativa: "'        + IntToStr(ATentativaAtual)         + '" | ' +
                             'TipoErro: "'         + Desc_TTipoRetornoAPI[raException] + '" | ' +
                             'Url: "'              + AURL                              + '" | ' +
                             'Metodo: "'           + 'POST'                            + '" | ' +
                             'ConteudoEnviado: "'  + AJson.ToString                    + '" | ' +
                             'ErroCatalogado: "'   + IntToStr(AErroApi.CodErro)        + '" | ' +
                             'ExceptionMessage: "' + E.Message                         + '" | ' +
                             'TempoDecorrido: "'   + LTempoDecorrido.ToString          + '"',
                             nil, 0, False, TCriticalLog.tlERROR);
            end;
{$ENDIF CompilarPara_TotemAA}
{$ENDIF IS_MOBILE}
          end;

          if ATentativaAtual < ATentivas then
          begin
            Sleep(2000);
            Result := IntIntegracaoAPI_Post(AURL, AJson, ARetornoAPI, AErroAPI, ATentivas, ATentativaAtual + 1, AuthorizationHeaderToken, AGravarLog);
          end;
        end;
      end;
    finally
      LStreamRes.Free;
    end;
  finally
    LStreamJson.Free;
  end;
end;

function IntIntegracaoAPI_Post(const AURL: string; const AAccept, AContentType:string; const AJson: TJSONArray; out ARetornoAPI: string; out AErroAPI: TErroAPI; const ATentivas, ATentativaAtual: Integer; const AuthorizationHeaderToken: string): TTipoRetornoAPI; overload;
var
  LStreamJson: TStringStream;
  LStreamRes: TStringStream;
  LStatusCode: string;
  LEnviadoEm : TDateTime;
  LTempoDecorrido : integer;
begin
{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
{$IFDEF DEBUG}
  TLogSQLite.New(tmInfo, clRequest, 'IntegracaoAPI (Enviando)')
    .AddDetail('Tentativa'      , ATentativaAtual)
    .AddDetail('Url'            , AURL           )
    .AddDetail('Metodo'         , 'POST'         )
    .AddDetail('ConteudoEnviado', AJson.ToString )
    .Save;
{$ENDIF DEBUG}
  TLog.MyLogTemp('IntegracaoAPI (Enviando). ' +
                 'Tentativa: "'       + IntToStr(ATentativaAtual) + '" | ' +
                 'Url: "'             + AURL                      + '" | ' +
                 'Metodo: "'          + 'POST'                    + '" | ' +
                 'ConteudoEnviado: "' + AJson.ToString            + '"',
                 nil, 0, False, TCriticalLog.tlINFO);
{$ENDIF CompilarPara_TotemAA}
{$ENDIF IS_MOBILE}

  LStreamJson := TStringStream.Create(Utf8Encode(AJson.ToJSON));
  LStreamRes := TStringStream.Create;
  try
    try
      try
        LEnviadoEm := now;
        LStatusCode:= THTTPRequest.Post(AURL, AAccept, AContentType, LStreamJson, LStreamRes, FTimeOut ).StatusCode.ToString;
        LTempoDecorrido := MilliSecondsBetween(Now, LEnviadoEm);
        ARetornoAPI := UTF8ToString(LStreamRes.DataString);

        //LBC: Futuramente remover isso daqui (quando todas as APIs estiverem em units sepaadas)
        if ((ARetornoAPI.Contains('Error receiving data')) or (ARetornoAPI.Contains('ERRO #5001')) or (ARetornoAPI.Contains('ERRO #5808'))) then
        begin
          Result := raErroComunicacao;
          AErroAPI.CodErro := -1;
          AErroAPI.MsgErro := 'Conteúdo recebido veio com palavras chave que indicam erro.';

{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
          TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
            .AddDetail('Tentativa'       , ATentativaAtual                        )
            .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroComunicacao])
            .AddDetail('Url'             , AURL                                   )
            .AddDetail('Metodo'          , 'POST'                                 )
            .AddDetail('ConteudoEnviado' , AJson.ToString                         )
            .AddDetail('ConteudoRecebido', ARetornoAPI                            )
            .AddDetail('HttpStatusCode'  , LStatusCode                            )
            .AddDetail('ErroCatalogado'  , AErroApi.CodErro                       )
            .AddDetail('TempoDecorrido'  , LTempoDecorrido                        )
            .Save;
          TLog.MyLogTemp('IntegracaoAPI (### Erro ###). ' +
                         'Tentativa: "'        + IntToStr(ATentativaAtual)               + '" | ' +
                         'TipoErro: "'         + Desc_TTipoRetornoAPI[raErroComunicacao] + '" | ' +
                         'Url: "'              + AURL                                    + '" | ' +
                         'Metodo: "'           + 'POST'                                  + '" | ' +
                         'ConteudoEnviado: "'  + AJson.ToString                          + '" | ' +
                         'ConteudoRecebido: "' + ARetornoAPI                             + '" | ' +
                         'HttpStatusCode: "'   + LStatusCode                             + '" | ' +
                         'ErroCatalogado: "'   + IntToStr(AErroApi.CodErro)              + '" | ' +
                         'TempoDecorrido: "'   + LTempoDecorrido.ToString                + '"',
                         nil, 0, False, TCriticalLog.tlERROR);
{$ENDIF CompilarPara_TotemAA}
{$ENDIF IS_MOBILE}
        end
        else
        begin
          Result := raOK;
          AErroAPI.CodErro := 0;
          AErroAPI.MsgErro := '';

{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
          TLogSQLite.New(tmInfo, clResponse, 'IntegracaoAPI (Resultado Ok)')
            .AddDetail('Tentativa'       , ATentativaAtual)
            .AddDetail('Url'             , AURL           )
            .AddDetail('Metodo'          , 'POST'         )
            .AddDetail('ConteudoEnviado' , AJson.ToString )
            .AddDetail('ConteudoRecebido', ARetornoAPI    )
            .AddDetail('HttpStatusCode'  , LStatusCode    )
            .AddDetail('TempoDecorrido'  , LTempoDecorrido)
            .Save;
          TLog.MyLogTemp('IntegracaoAPI (Resultado Ok). ' +
                         'Tentativa: "'        + InTtoStr(ATentativaAtual) + '" | ' +
                         'Url: "'              + AURL                      + '" | ' +
                         'Metodo: "'           + 'POST'                    + '" | ' +
                         'ConteudoEnviado: "'  + AJson.ToString            + '" | ' +
                         'ConteudoRecebido: "' + ARetornoAPI               + '" | ' +
                         'HttpStatusCode: "'   + LStatusCode               + '" | ' +
                         'TempoDecorrido: "'   + LTempoDecorrido.ToString  + '"',
                         nil, 0, False, TCriticalLog.tlINFO);
{$ENDIF CompilarPara_TotemAA}
{$ENDIF IS_MOBILE}
        end;
      except
        on E: Exception do
        begin
          AErroAPI.CodErro := -1;
          AErroAPI.MsgErro := E.Message;

          if E is EHTTPProtocolException then
          begin
            Result := raErroComunicacao;
{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
            TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
              .AddDetail('Tentativa'       , ATentativaAtual                             )
              .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroComunicacao]     )
              .AddDetail('Url'             , AURL                                        )
              .AddDetail('Metodo'          , 'POST'                                      )
              .AddDetail('ConteudoEnviado' , AJson.ToString                              )
              .AddDetail('ConteudoRecebido', E.Message                                   )
              .AddDetail('HttpStatusCode'  , EHTTPProtocolException(E).ErrorCode.ToString)
              .AddDetail('HttpStatusText'  , EHTTPProtocolException(E).ErrorMessage      )
              .AddDetail('ErroCatalogado'  , AErroApi.CodErro                            )
              .AddDetail('TempoDecorrido'  , LTempoDecorrido                             )
              .Save;
            TLog.MyLogTemp('IntegracaoAPI (### Erro ###). ' +
                           'Tentativa: "'        + IntToStr(ATentativaAtual)                     + '" | ' +
                           'TipoErro: "'         + Desc_TTipoRetornoAPI[raErroComunicacao]       + '" | ' +
                           'Url: "'              + AURL                                          + '" | ' +
                           'Metodo: "'           + 'POST'                                        + '" | ' +
                           'ConteudoEnviado: "'  + AJson.ToString                                + '" | ' +
                           'ConteudoRecebido: "' + E.Message                                     + '" | ' +
                           'HttpStatusCode: "'   + EHTTPProtocolException(E).ErrorCode.ToString  + '" | ' +
                           'HttpStatusText: "'   + EHTTPProtocolException(E).ErrorMessage        + '" | ' +
                           'ErroCatalogado: "'   + IntToStr(AErroApi.CodErro)                    + '" | ' +
                           'TempoDecorrido: "'   + LTempoDecorrido.ToString                      + '"',
                           nil, 0, False, TCriticalLog.tlERROR);
{$ENDIF CompilarPara_TotemAA}
{$ENDIF IS_MOBILE}

            AErroAPI.CodErro := EHTTPProtocolException(E).ErrorCode;  //LBC: Verificar esta linha pois o AErroAPI.CodErro deveria retornar um Erro Catalogado da Aplicação TotemAA, porém foi populado com o HttpErrorCode e necessário verificar o que está fazendo com essa informação ao sair desse método
          end
          else
          begin
            Result := raException;
{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
            TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
              .AddDetail('Tentativa'       , ATentativaAtual                  )
              .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raException])
              .AddDetail('Url'             , AURL                             )
              .AddDetail('Metodo'          , 'POST'                           )
              .AddDetail('ConteudoEnviado' , AJson.ToString                   )
              .AddDetail('ErroCatalogado'  , AErroApi.CodErro                 )
              .AddDetail('ExceptionMessage', E.Message                        )
              .AddDetail('TempoDecorrido'  , LTempoDecorrido                  )
              .Save;
            TLog.MyLogTemp('IntegracaoAPI (### Erro ###). ' +
                           'Tentativa: "'        + IntToStr(ATentativaAtual)         + '" | ' +
                           'TipoErro: "'         + Desc_TTipoRetornoAPI[raException] + '" | ' +
                           'Url: "'              + AURL                              + '" | ' +
                           'Metodo: "'           + 'POST'                            + '" | ' +
                           'ConteudoEnviado: "'  + AJson.ToString                    + '" | ' +
                           'ErroCatalogado: "'   + IntToStr(AErroApi.CodErro)        + '" | ' +
                           'ExceptionMessage: "' + E.Message                         + '" | ' +
                           'TempoDecorrido: "'   + LTempoDecorrido.ToString          + '"',
                           nil, 0, False, TCriticalLog.tlERROR);
{$ENDIF CompilarPara_TotemAA}
{$ENDIF IS_MOBILE}
          end;

          if ATentativaAtual < ATentivas then
          begin
            Sleep(2000);
            Result := IntIntegracaoAPI_Post(AURL, AJson, ARetornoAPI, AErroAPI, ATentivas, ATentativaAtual + 1, AuthorizationHeaderToken);
          end;
        end;
      end;
    finally
      LStreamRes.Free;
    end;
  finally
    LStreamJson.Free;
  end;
end;

function IntIntegracaoAPI_Post(const AURL: string; const AAccept, AContentType:string; const AJson: TJSONObject; out ARetornoAPI: string; out AErroAPI: TErroAPI; const ATentivas, ATentativaAtual: Integer; const AuthorizationHeaderToken: string): TTipoRetornoAPI; overload; overload;
var
  LStringJson: string;
  LStreamJson: TStringStream;
  LStreamRes: TStringStream;
  LStatusCode: string;
  LEnviadoEm : TDateTime;
  LTempoDecorrido : integer;
  LCountJson:integer;
  LJsonPair: TJSONPair;
begin
{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
{$IFDEF DEBUG}
  TLogSQLite.New(tmInfo, clRequest, 'IntegracaoAPI (Enviando)')
    .AddDetail('Tentativa'      , ATentativaAtual)
    .AddDetail('Url'            , AURL           )
    .AddDetail('Metodo'         , 'POST'         )
    .AddDetail('ConteudoEnviado', AJson.ToString )
    .Save;
{$ENDIF DEBUG}
  TLog.MyLogTemp('IntegracaoAPI (Enviando). ' +
                 'Tentativa: "'       + IntToStr(ATentativaAtual) + '" | ' +
                 'Url: "'             + AURL                      + '" | ' +
                 'Metodo: "'          + 'POST'                    + '" | ' +
                 'ConteudoEnviado: "' + AJson.ToString            + '"',
                 nil, 0, False, TCriticalLog.tlINFO);
{$ENDIF CompilarPara_TotemAA}
{$ENDIF IS_MOBILE}

  for LCountJson := 0 to Pred(AJson.Size) do
  begin
    LJsonPair := AJson.Get(LCountJson);
    if LStringJson <> EmptyStr then LStringJson := LStringJson + '&';
    LStringJson := LStringJson + LJsonPair.JsonString.Value + '=' + LJsonPair.JsonValue.Value;
  end;
  LStreamJson := TStringStream.Create(LStringJson);
  LStreamRes := TStringStream.Create;
  try
    try
      try
        LTempoDecorrido := -1;
        LEnviadoEm := now;
        LStatusCode:= THTTPRequest.Post(AURL, AAccept, AContentType, LStreamJson, LStreamRes, FTimeout).StatusCode.ToString;
        LTempoDecorrido := MilliSecondsBetween(Now, LEnviadoEm);

        ARetornoAPI := UTF8ToString(LStreamRes.DataString);

        //LBC: Futuramente remover isso daqui (quando todas as APIs estiverem em units sepaadas)
        if ((ARetornoAPI.Contains('Error receiving data')) or (ARetornoAPI.Contains('ERRO #5001')) or (ARetornoAPI.Contains('ERRO #5808'))) then
        begin
          Result := raErroComunicacao;
          AErroAPI.CodErro := -1;
          AErroAPI.MsgErro := 'Conteúdo recebido veio com palavras chave que indicam erro.';

{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
          TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
            .AddDetail('Tentativa'       , ATentativaAtual                        )
            .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroComunicacao])
            .AddDetail('Url'             , AURL                                   )
            .AddDetail('Metodo'          , 'POST'                                 )
            .AddDetail('ConteudoEnviado' , AJson.ToString                         )
            .AddDetail('ConteudoRecebido', ARetornoAPI                            )
            .AddDetail('HttpStatusCode'  , LStatusCode                            )
            .AddDetail('ErroCatalogado'  , AErroApi.CodErro                       )
            .AddDetail('TempoDecorrido'  , LTempoDecorrido                        )
            .Save;
          TLog.MyLogTemp('IntegracaoAPI (### Erro ###). ' +
                         'Tentativa: "'        + IntToStr(ATentativaAtual)               + '" | ' +
                         'TipoErro: "'         + Desc_TTipoRetornoAPI[raErroComunicacao] + '" | ' +
                         'Url: "'              + AURL                                    + '" | ' +
                         'Metodo: "'           + 'POST'                                  + '" | ' +
                         'ConteudoEnviado: "'  + AJson.ToString                          + '" | ' +
                         'ConteudoRecebido: "' + ARetornoAPI                             + '" | ' +
                         'HttpStatusCode: "'   + LStatusCode                             + '" | ' +
                         'ErroCatalogado: "'   + IntToStr(AErroApi.CodErro)              + '" | ' +
                         'TempoDecorrido: "'   + LTempoDecorrido.ToString                + '"',
                         nil, 0, False, TCriticalLog.tlERROR);
{$ENDIF CompilarPara_TotemAA}
{$ENDIF IS_MOBILE}
        end
        else
        begin
          Result := raOK;
          AErroAPI.CodErro := 0;
          AErroAPI.MsgErro := '';

{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
          TLogSQLite.New(tmInfo, clResponse, 'IntegracaoAPI (Resultado Ok)')
            .AddDetail('Tentativa'       , ATentativaAtual)
            .AddDetail('Url'             , AURL           )
            .AddDetail('Metodo'          , 'POST'         )
            .AddDetail('ConteudoEnviado' , AJson.ToString )
            .AddDetail('ConteudoRecebido', ARetornoAPI    )
            .AddDetail('HttpStatusCode'  , LStatusCode    )
            .AddDetail('TempoDecorrido'  , LTempoDecorrido)
            .Save;
          TLog.MyLogTemp('IntegracaoAPI (Resultado Ok). ' +
                         'Tentativa: "'        + InTtoStr(ATentativaAtual) + '" | ' +
                         'Url: "'              + AURL                      + '" | ' +
                         'Metodo: "'           + 'POST'                    + '" | ' +
                         'ConteudoEnviado: "'  + AJson.ToString            + '" | ' +
                         'ConteudoRecebido: "' + ARetornoAPI               + '" | ' +
                         'HttpStatusCode: "'   + LStatusCode               + '" | ' +
                         'TempoDecorrido: "'   + LTempoDecorrido.ToString  + '"',
                         nil, 0, False, TCriticalLog.tlINFO);
{$ENDIF CompilarPara_TotemAA}
{$ENDIF IS_MOBILE}
        end;
      except
        on E: Exception do
        begin
          AErroAPI.CodErro := -1;
          AErroAPI.MsgErro := E.Message;

          if E is EHTTPProtocolException then
          begin
            Result := raErroComunicacao;
{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
            TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
              .AddDetail('Tentativa'       , ATentativaAtual                             )
              .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroComunicacao]     )
              .AddDetail('Url'             , AURL                                        )
              .AddDetail('Metodo'          , 'POST'                                      )
              .AddDetail('ConteudoEnviado' , AJson.ToString                              )
              .AddDetail('ConteudoRecebido', E.Message                                   )
              .AddDetail('HttpStatusCode'  , EHTTPProtocolException(E).ErrorCode.ToString)
              .AddDetail('HttpStatusText'  , EHTTPProtocolException(E).ErrorMessage      )
              .AddDetail('ErroCatalogado'  , AErroApi.CodErro                            )
              .AddDetail('TempoDecorrido'  , LTempoDecorrido                             )
              .Save;
            TLog.MyLogTemp('IntegracaoAPI (### Erro ###). ' +
                           'Tentativa: "'        + IntToStr(ATentativaAtual)                     + '" | ' +
                           'TipoErro: "'         + Desc_TTipoRetornoAPI[raErroComunicacao]       + '" | ' +
                           'Url: "'              + AURL                                          + '" | ' +
                           'Metodo: "'           + 'POST'                                        + '" | ' +
                           'ConteudoEnviado: "'  + AJson.ToString                                + '" | ' +
                           'ConteudoRecebido: "' + E.Message                                     + '" | ' +
                           'HttpStatusCode: "'   + EHTTPProtocolException(E).ErrorCode.ToString  + '" | ' +
                           'HttpStatusText: "'   + EHTTPProtocolException(E).ErrorMessage        + '" | ' +
                           'ErroCatalogado: "'   + IntToStr(AErroApi.CodErro)                    + '" | ' +
                           'TempoDecorrido: "'   + LTempoDecorrido.ToString                      + '"',
                           nil, 0, False, TCriticalLog.tlERROR);
{$ENDIF CompilarPara_TotemAA}
{$ENDIF IS_MOBILE}

            AErroAPI.CodErro := EHTTPProtocolException(E).ErrorCode;  //LBC: Verificar esta linha pois o AErroAPI.CodErro deveria retornar um Erro Catalogado da Aplicação TotemAA, porém foi populado com o HttpErrorCode e necessário verificar o que está fazendo com essa informação ao sair desse método
          end
          else
          begin
            Result := raException;
{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
            TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
              .AddDetail('Tentativa'       , ATentativaAtual                  )
              .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raException])
              .AddDetail('Url'             , AURL                             )
              .AddDetail('Metodo'          , 'POST'                           )
              .AddDetail('ConteudoEnviado' , AJson.ToString                   )
              .AddDetail('ErroCatalogado'  , AErroApi.CodErro                 )
              .AddDetail('ExceptionMessage', E.Message                        )
              .AddDetail('TempoDecorrido'  , LTempoDecorrido                  )
              .Save;
            TLog.MyLogTemp('IntegracaoAPI (### Erro ###). ' +
                           'Tentativa: "'        + IntToStr(ATentativaAtual)         + '" | ' +
                           'TipoErro: "'         + Desc_TTipoRetornoAPI[raException] + '" | ' +
                           'Url: "'              + AURL                              + '" | ' +
                           'Metodo: "'           + 'POST'                            + '" | ' +
                           'ConteudoEnviado: "'  + AJson.ToString                    + '" | ' +
                           'ErroCatalogado: "'   + IntToStr(AErroApi.CodErro)        + '" | ' +
                           'ExceptionMessage: "' + E.Message                         + '" | ' +
                           'TempoDecorrido: "'   + LTempoDecorrido.ToString          + '"',
                           nil, 0, False, TCriticalLog.tlERROR);
{$ENDIF CompilarPara_TotemAA}
{$ENDIF IS_MOBILE}
          end;

          if ATentativaAtual < ATentivas then
          begin
            Sleep(2000);
            Result := IntIntegracaoAPI_Post(AURL, AAccept, AContentType, AJson, ARetornoAPI, AErroAPI, ATentivas, ATentativaAtual+1, AuthorizationHeaderToken);
          end;
        end;
      end;
    finally
      LStreamRes.Free;
    end;
  finally
    LStreamJson.Free;
  end;
end;

function IntIntegracaoAPI_Post(const AURL: string; const AJson: TJSONArray; out ARetornoAPI: string; out AErroAPI: TErroAPI; const ATentivas, ATentativaAtual: Integer; const ACustomHeader:TCustomHeader): TTipoRetornoAPI; overload;
var
  LStreamJson: TStringStream;
  LStreamRes: TStringStream;
  LStatusCode: string;
  LEnviadoEm : TDateTime;
  LTempoDecorrido : integer;
begin
{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
{$IFDEF DEBUG}
  TLogSQLite.New(tmInfo, clRequest, 'IntegracaoAPI (Enviando)')
    .AddDetail('Tentativa'      , ATentativaAtual)
    .AddDetail('Url'            , AURL           )
    .AddDetail('Metodo'         , 'POST'         )
    .AddDetail('ConteudoEnviado', AJson.ToString )
    .Save;
{$ENDIF DEBUG}
  TLog.MyLogTemp('IntegracaoAPI (Enviando). ' +
                 'Tentativa: "'       + IntToStr(ATentativaAtual) + '" | ' +
                 'Url: "'             + AURL                      + '" | ' +
                 'Metodo: "'          + 'POST'                    + '" | ' +
                 'ConteudoEnviado: "' + AJson.ToString            + '"',
                 nil, 0, False, TCriticalLog.tlINFO);
{$ENDIF CompilarPara_TotemAA}
{$ENDIF IS_MOBILE}

  LStreamJson := TStringStream.Create(Utf8Encode(AJson.ToJSON));
  LStreamRes := TStringStream.Create;
  try
    try
      try
        LEnviadoEm := now;
        LStatusCode:= THTTPRequest.Post(AURL, LStreamJson, LStreamRes, FTimeOut, ACustomHeader).StatusCode.ToString;
        LTempoDecorrido := MilliSecondsBetween(Now, LEnviadoEm);
        ARetornoAPI := UTF8ToString(LStreamRes.DataString);

        //LBC: Futuramente remover isso daqui (quando todas as APIs estiverem em units sepaadas)
        if ((ARetornoAPI.Contains('Error receiving data')) or (ARetornoAPI.Contains('ERRO #5001')) or (ARetornoAPI.Contains('ERRO #5808'))) then
        begin
          Result := raErroComunicacao;
          AErroAPI.CodErro := -1;
          AErroAPI.MsgErro := 'Conteúdo recebido veio com palavras chave que indicam erro.';

{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
          TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
            .AddDetail('Tentativa'       , ATentativaAtual                        )
            .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroComunicacao])
            .AddDetail('Url'             , AURL                                   )
            .AddDetail('Metodo'          , 'POST'                                 )
            .AddDetail('ConteudoEnviado' , AJson.ToString                         )
            .AddDetail('ConteudoRecebido', ARetornoAPI                            )
            .AddDetail('HttpStatusCode'  , LStatusCode                            )
            .AddDetail('ErroCatalogado'  , AErroApi.CodErro                       )
            .AddDetail('TempoDecorrido'  , LTempoDecorrido                        )
            .Save;
          TLog.MyLogTemp('IntegracaoAPI (### Erro ###). ' +
                         'Tentativa: "'        + IntToStr(ATentativaAtual)               + '" | ' +
                         'TipoErro: "'         + Desc_TTipoRetornoAPI[raErroComunicacao] + '" | ' +
                         'Url: "'              + AURL                                    + '" | ' +
                         'Metodo: "'           + 'POST'                                  + '" | ' +
                         'ConteudoEnviado: "'  + AJson.ToString                          + '" | ' +
                         'ConteudoRecebido: "' + ARetornoAPI                             + '" | ' +
                         'HttpStatusCode: "'   + LStatusCode                             + '" | ' +
                         'ErroCatalogado: "'   + IntToStr(AErroApi.CodErro)              + '" | ' +
                         'TempoDecorrido: "'   + LTempoDecorrido.ToString                + '"',
                         nil, 0, False, TCriticalLog.tlERROR);
{$ENDIF CompilarPara_TotemAA}
{$ENDIF IS_MOBILE}
        end
        else
        begin
          Result := raOK;
          AErroAPI.CodErro := 0;
          AErroAPI.MsgErro := '';

{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
          TLogSQLite.New(tmInfo, clResponse, 'IntegracaoAPI (Resultado Ok)')
            .AddDetail('Tentativa'       , ATentativaAtual)
            .AddDetail('Url'             , AURL           )
            .AddDetail('Metodo'          , 'POST'         )
            .AddDetail('ConteudoEnviado' , AJson.ToString )
            .AddDetail('ConteudoRecebido', ARetornoAPI    )
            .AddDetail('HttpStatusCode'  , LStatusCode    )
            .AddDetail('TempoDecorrido'  , LTempoDecorrido)
            .Save;
          TLog.MyLogTemp('IntegracaoAPI (Resultado Ok). ' +
                         'Tentativa: "'        + InTtoStr(ATentativaAtual) + '" | ' +
                         'Url: "'              + AURL                      + '" | ' +
                         'Metodo: "'           + 'POST'                    + '" | ' +
                         'ConteudoEnviado: "'  + AJson.ToString            + '" | ' +
                         'ConteudoRecebido: "' + ARetornoAPI               + '" | ' +
                         'HttpStatusCode: "'   + LStatusCode               + '" | ' +
                         'TempoDecorrido: "'   + LTempoDecorrido.ToString  + '"',
                         nil, 0, False, TCriticalLog.tlINFO);
{$ENDIF CompilarPara_TotemAA}
{$ENDIF IS_MOBILE}
        end;
      except
        on E: Exception do
        begin
          AErroAPI.CodErro := -1;
          AErroAPI.MsgErro := E.Message;

          if E is EHTTPProtocolException then
          begin
            Result := raErroComunicacao;
{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
            TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
              .AddDetail('Tentativa'       , ATentativaAtual                             )
              .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroComunicacao]     )
              .AddDetail('Url'             , AURL                                        )
              .AddDetail('Metodo'          , 'POST'                                      )
              .AddDetail('ConteudoEnviado' , AJson.ToString                              )
              .AddDetail('ConteudoRecebido', E.Message                                   )
              .AddDetail('HttpStatusCode'  , EHTTPProtocolException(E).ErrorCode.ToString)
              .AddDetail('HttpStatusText'  , EHTTPProtocolException(E).ErrorMessage      )
              .AddDetail('ErroCatalogado'  , AErroApi.CodErro                            )
              .AddDetail('TempoDecorrido'  , LTempoDecorrido                             )
              .Save;
{$ENDIF CompilarPara_TotemAA}

            TLog.MyLogTemp('IntegracaoAPI (### Erro ###). ' +
                           'Tentativa: "'        + IntToStr(ATentativaAtual)                     + '" | ' +
                           'TipoErro: "'         + Desc_TTipoRetornoAPI[raErroComunicacao]       + '" | ' +
                           'Url: "'              + AURL                                          + '" | ' +
                           'Metodo: "'           + 'POST'                                        + '" | ' +
                           'ConteudoEnviado: "'  + AJson.ToString                                + '" | ' +
                           'ConteudoRecebido: "' + E.Message                                     + '" | ' +
                           'HttpStatusCode: "'   + EHTTPProtocolException(E).ErrorCode.ToString  + '" | ' +
                           'HttpStatusText: "'   + EHTTPProtocolException(E).ErrorMessage        + '" | ' +
                           'ErroCatalogado: "'   + IntToStr(AErroApi.CodErro)                    + '" | ' +
                           'TempoDecorrido: "'   + LTempoDecorrido.ToString                      + '"',
                           nil, 0, False, TCriticalLog.tlERROR);
{$ENDIF IS_MOBILE}

            AErroAPI.CodErro := EHTTPProtocolException(E).ErrorCode;  //LBC: Verificar esta linha pois o AErroAPI.CodErro deveria retornar um Erro Catalogado da Aplicação TotemAA, porém foi populado com o HttpErrorCode e necessário verificar o que está fazendo com essa informação ao sair desse método
          end
          else
          begin
            Result := raException;
{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}

            TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
              .AddDetail('Tentativa'       , ATentativaAtual                  )
              .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raException])
              .AddDetail('Url'             , AURL                             )
              .AddDetail('Metodo'          , 'POST'                           )
              .AddDetail('ConteudoEnviado' , AJson.ToString                   )
              .AddDetail('ErroCatalogado'  , AErroApi.CodErro                 )
              .AddDetail('ExceptionMessage', E.Message                        )
              .AddDetail('TempoDecorrido'  , LTempoDecorrido                  )
              .Save;
{$ENDIF CompilarPara_TotemAA}

            TLog.MyLogTemp('IntegracaoAPI (### Erro ###). ' +
                           'Tentativa: "'        + IntToStr(ATentativaAtual)         + '" | ' +
                           'TipoErro: "'         + Desc_TTipoRetornoAPI[raException] + '" | ' +
                           'Url: "'              + AURL                              + '" | ' +
                           'Metodo: "'           + 'POST'                            + '" | ' +
                           'ConteudoEnviado: "'  + AJson.ToString                    + '" | ' +
                           'ErroCatalogado: "'   + IntToStr(AErroApi.CodErro)        + '" | ' +
                           'ExceptionMessage: "' + E.Message                         + '" | ' +
                           'TempoDecorrido: "'   + LTempoDecorrido.ToString          + '"',
                           nil, 0, False, TCriticalLog.tlERROR);

{$ENDIF IS_MOBILE}
          end;

          if ATentativaAtual < ATentivas then
          begin
            Sleep(2000);
            Result := IntIntegracaoAPI_Post(AURL, AJson, ARetornoAPI, AErroAPI, ATentivas, ATentativaAtual + 1, ACustomHeader);
          end;
        end;
      end;
    finally
      LStreamRes.Free;
    end;
  finally
    LStreamJson.Free;
  end;
end;

function IntIntegracaoAPI_Post(const AURL: string; const AMultiPartFormData: TMultipartFormData; out ARetornoAPI: string; out AErroAPI: TErroAPI; const ATentivas, ATentativaAtual: Integer; const ACustomHeader:TCustomHeader; const AGravarLog:boolean): TTipoRetornoAPI; overload;
var
  LStreamRes: TStringStream;
  LStatusCode: string;
  LEnviadoEm : TDateTime;
  LTempoDecorrido : integer;
begin
{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
  if AGravarLog then
  begin
{$IFDEF DEBUG}
    TLogSQLite.New(tmInfo, clRequest, 'IntegracaoAPI (Enviando)')
      .AddDetail('Tentativa'      , ATentativaAtual)
      .AddDetail('Url'            , AURL           )
      .AddDetail('Metodo'         , 'POST'         )
      .AddDetail('ConteudoEnviado', AMultiPartFormData.ToString )
      .Save;
{$ENDIF DEBUG}
    TLog.MyLogTemp('IntegracaoAPI (Enviando). ' +
                   'Tentativa: "'       + IntToStr(ATentativaAtual) + '" | ' +
                   'Url: "'             + AURL                      + '" | ' +
                   'Metodo: "'          + 'POST'                    + '" | ' +
                   'ConteudoEnviado: "' + AMultiPartFormData.ToString            + '"',
                   nil, 0, False, TCriticalLog.tlINFO);
  end;
{$ENDIF CompilarPara_TotemAA}
{$ENDIF IS_MOBILE}

  LStreamRes := TStringStream.Create;
  try
    try
      LEnviadoEm := now;
      LStatusCode:= THTTPRequest.Post(AURL, AMultiPartFormData, LStreamRes, FTimeOut, ACustomHeader).StatusCode.ToString;
      LTempoDecorrido := MilliSecondsBetween(Now, LEnviadoEm);
      ARetornoAPI := UTF8ToString(LStreamRes.DataString);

      //LBC: Futuramente remover isso daqui (quando todas as APIs estiverem em units sepaadas)
      if ((ARetornoAPI.Contains('Error receiving data')) or (ARetornoAPI.Contains('ERRO #5001')) or (ARetornoAPI.Contains('ERRO #5808'))) then
      begin
        Result := raErroComunicacao;
        AErroAPI.CodErro := -1;
        AErroAPI.MsgErro := 'Conteúdo recebido veio com palavras chave que indicam erro.';

{$IFNDEF IS_MOBILE}
        if AGravarLog then
        begin
{$IFDEF CompilarPara_TotemAA}
          TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
            .AddDetail('Tentativa'       , ATentativaAtual                        )
            .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroComunicacao])
            .AddDetail('Url'             , AURL                                   )
            .AddDetail('Metodo'          , 'POST'                                 )
            .AddDetail('ConteudoEnviado' , AMultiPartFormData.ToString            )
            .AddDetail('ConteudoRecebido', ARetornoAPI                            )
            .AddDetail('HttpStatusCode'  , LStatusCode                            )
            .AddDetail('ErroCatalogado'  , AErroApi.CodErro                       )
            .AddDetail('TempoDecorrido'  , LTempoDecorrido                        )
            .Save;
{$ENDIF CompilarPara_TotemAA}

          TLog.MyLogTemp('IntegracaoAPI (### Erro ###). ' +
                         'Tentativa: "'        + IntToStr(ATentativaAtual)               + '" | ' +
                         'TipoErro: "'         + Desc_TTipoRetornoAPI[raErroComunicacao] + '" | ' +
                         'Url: "'              + AURL                                    + '" | ' +
                         'Metodo: "'           + 'POST'                                  + '" | ' +
                         'ConteudoEnviado: "'  + AMultiPartFormData.ToString             + '" | ' +
                         'ConteudoRecebido: "' + ARetornoAPI                             + '" | ' +
                         'HttpStatusCode: "'   + LStatusCode                             + '" | ' +
                         'ErroCatalogado: "'   + IntToStr(AErroApi.CodErro)              + '" | ' +
                         'TempoDecorrido: "'   + LTempoDecorrido.ToString                + '"',
                         nil, 0, False, TCriticalLog.tlERROR);
        end;
{$ENDIF IS_MOBILE}
      end
      else
      begin
        Result := raOK;
        AErroAPI.CodErro := 0;
        AErroAPI.MsgErro := '';

{$IFNDEF IS_MOBILE}
        if AGravarLog then
        begin
          {$IFDEF CompilarPara_TotemAA}
          TLogSQLite.New(tmInfo, clResponse, 'IntegracaoAPI (Resultado Ok)')
            .AddDetail('Tentativa'       , ATentativaAtual              )
            .AddDetail('Url'             , AURL                         )
            .AddDetail('Metodo'          , 'POST'                       )
            .AddDetail('ConteudoEnviado' , AMultiPartFormData.ToString  )
            .AddDetail('ConteudoRecebido', ARetornoAPI                  )
            .AddDetail('HttpStatusCode'  , LStatusCode                  )
            .AddDetail('TempoDecorrido'  , LTempoDecorrido              )
            .Save;
          {$ENDIF CompilarPara_TotemAA}

          TLog.MyLogTemp('IntegracaoAPI (Resultado Ok). ' +
                         'Tentativa: "'        + InTtoStr(ATentativaAtual)    + '" | ' +
                         'Url: "'              + AURL                         + '" | ' +
                         'Metodo: "'           + 'POST'                       + '" | ' +
                         'ConteudoEnviado: "'  + AMultiPartFormData.ToString  + '" | ' +
                         'ConteudoRecebido: "' + ARetornoAPI                  + '" | ' +
                         'HttpStatusCode: "'   + LStatusCode                  + '" | ' +
                         'TempoDecorrido: "'   + LTempoDecorrido.ToString     + '"',
                         nil, 0, False, TCriticalLog.tlINFO);
        end;
{$ENDIF IS_MOBILE}
      end;
    except
      on E: Exception do
      begin
        AErroAPI.CodErro := -1;
        AErroAPI.MsgErro := E.Message;

        if E is EHTTPProtocolException then
        begin
          Result := raErroComunicacao;
{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
          if AGravarLog then
          begin
            TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
              .AddDetail('Tentativa'       , ATentativaAtual                             )
              .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroComunicacao]     )
              .AddDetail('Url'             , AURL                                        )
              .AddDetail('Metodo'          , 'POST'                                      )
              .AddDetail('ConteudoEnviado' , AMultiPartFormData.ToString                 )
              .AddDetail('ConteudoRecebido', E.Message                                   )
              .AddDetail('HttpStatusCode'  , EHTTPProtocolException(E).ErrorCode.ToString)
              .AddDetail('HttpStatusText'  , EHTTPProtocolException(E).ErrorMessage      )
              .AddDetail('ErroCatalogado'  , AErroApi.CodErro                            )
              .AddDetail('TempoDecorrido'  , LTempoDecorrido                             )
              .Save;
            TLog.MyLogTemp('IntegracaoAPI (### Erro ###). ' +
                           'Tentativa: "'        + IntToStr(ATentativaAtual)                     + '" | ' +
                           'TipoErro: "'         + Desc_TTipoRetornoAPI[raErroComunicacao]       + '" | ' +
                           'Url: "'              + AURL                                          + '" | ' +
                           'Metodo: "'           + 'POST'                                        + '" | ' +
                           'ConteudoEnviado: "'  + AMultiPartFormData.ToString                   + '" | ' +
                           'ConteudoRecebido: "' + E.Message                                     + '" | ' +
                           'HttpStatusCode: "'   + EHTTPProtocolException(E).ErrorCode.ToString  + '" | ' +
                           'HttpStatusText: "'   + EHTTPProtocolException(E).ErrorMessage        + '" | ' +
                           'ErroCatalogado: "'   + IntToStr(AErroApi.CodErro)                    + '" | ' +
                           'TempoDecorrido: "'   + LTempoDecorrido.ToString                      + '"',
                           nil, 0, False, TCriticalLog.tlERROR);
          end;
{$ENDIF CompilarPara_TotemAA}
{$ENDIF IS_MOBILE}

          AErroAPI.CodErro := EHTTPProtocolException(E).ErrorCode;  //LBC: Verificar esta linha pois o AErroAPI.CodErro deveria retornar um Erro Catalogado da Aplicação TotemAA, porém foi populado com o HttpErrorCode e necessário verificar o que está fazendo com essa informação ao sair desse método
        end
        else
        begin
          Result := raException;
{$IFNDEF IS_MOBILE}
          if AGravarLog then
          begin
{$IFDEF CompilarPara_TotemAA}
            TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
              .AddDetail('Tentativa'       , ATentativaAtual                  )
              .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raException])
              .AddDetail('Url'             , AURL                             )
              .AddDetail('Metodo'          , 'POST'                           )
              .AddDetail('ConteudoEnviado' , AMultiPartFormData.ToString      )
              .AddDetail('ErroCatalogado'  , AErroApi.CodErro                 )
              .AddDetail('ExceptionMessage', E.Message                        )
              .AddDetail('TempoDecorrido'  , LTempoDecorrido                  )
              .Save;
{$ENDIF CompilarPara_TotemAA}

            TLog.MyLogTemp('IntegracaoAPI (### Erro ###). ' +
                           'Tentativa: "'        + IntToStr(ATentativaAtual)         + '" | ' +
                           'TipoErro: "'         + Desc_TTipoRetornoAPI[raException] + '" | ' +
                           'Url: "'              + AURL                              + '" | ' +
                           'Metodo: "'           + 'POST'                            + '" | ' +
                           'ConteudoEnviado: "'  + AMultiPartFormData.ToString       + '" | ' +
                           'ErroCatalogado: "'   + IntToStr(AErroApi.CodErro)        + '" | ' +
                           'ExceptionMessage: "' + E.Message                         + '" | ' +
                           'TempoDecorrido: "'   + LTempoDecorrido.ToString          + '"',
                           nil, 0, False, TCriticalLog.tlERROR);
          end;
{$ENDIF IS_MOBILE}
        end;

        if ATentativaAtual < ATentivas then
        begin
          Sleep(2000);
          Result := IntIntegracaoAPI_Post(AURL, AMultiPartFormData, ARetornoAPI, AErroAPI, ATentivas, ATentativaAtual + 1, ACustomHeader, AGravarLog);
        end;
      end;
    end;
  finally
    LStreamRes.Free;
  end;
end;

function IntIntegracaoAPI_Post(const AURL: string; const AJson: TJSONObject; out ARetornoAPI: string; out AErroAPI: TErroAPI; const ATentivas, ATentativaAtual: Integer; const ACustomHeader:TCustomHeader): TTipoRetornoAPI; overload;
var
  LStreamJson: TStringStream;
  LStreamRes: TStringStream;
  LStatusCode: string;
  LEnviadoEm : TDateTime;
  LTempoDecorrido : integer;
begin
{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
{$IFDEF DEBUG}
  TLogSQLite.New(tmInfo, clRequest, 'IntegracaoAPI (Enviando)')
    .AddDetail('Tentativa'      , ATentativaAtual)
    .AddDetail('Url'            , AURL           )
    .AddDetail('Metodo'         , 'POST'         )
    .AddDetail('ConteudoEnviado', AJson.ToString )
    .Save;
{$ENDIF DEBUG}
  TLog.MyLogTemp('IntegracaoAPI (Enviando). ' +
                 'Tentativa: "'       + IntToStr(ATentativaAtual) + '" | ' +
                 'Url: "'             + AURL                      + '" | ' +
                 'Metodo: "'          + 'POST'                    + '" | ' +
                 'ConteudoEnviado: "' + AJson.ToString            + '"',
                 nil, 0, False, TCriticalLog.tlINFO);
{$ENDIF CompilarPara_TotemAA}
{$ENDIF IS_MOBILE}

  LStreamJson := TStringStream.Create(Utf8Encode(AJson.ToJSON));
  LStreamRes := TStringStream.Create;
  try
    try
      try
        LTempoDecorrido := -1;
        LEnviadoEm := now;
        LStatusCode:= THTTPRequest.Post(AURL, LStreamJson, LStreamRes, FTimeOut, ACustomHeader).StatusCode.ToString;
        LTempoDecorrido := MilliSecondsBetween(Now, LEnviadoEm);

        ARetornoAPI := UTF8ToString(LStreamRes.DataString);

        //LBC: Futuramente remover isso daqui (quando todas as APIs estiverem em units sepaadas)
        if ((ARetornoAPI.Contains('Error receiving data')) or (ARetornoAPI.Contains('ERRO #5001')) or (ARetornoAPI.Contains('ERRO #5808'))) then
        begin
          Result := raErroComunicacao;
          AErroAPI.CodErro := -1;
          AErroAPI.MsgErro := 'Conteúdo recebido veio com palavras chave que indicam erro.';

{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
          TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
            .AddDetail('Tentativa'       , ATentativaAtual                        )
            .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroComunicacao])
            .AddDetail('Url'             , AURL                                   )
            .AddDetail('Metodo'          , 'POST'                                 )
            .AddDetail('ConteudoEnviado' , AJson.ToString                         )
            .AddDetail('ConteudoRecebido', ARetornoAPI                            )
            .AddDetail('HttpStatusCode'  , LStatusCode                            )
            .AddDetail('ErroCatalogado'  , AErroApi.CodErro                       )
            .AddDetail('TempoDecorrido'  , LTempoDecorrido                        )
            .Save;
{$ENDIF CompilarPara_TotemAA}
          TLog.MyLogTemp('IntegracaoAPI (### Erro ###). ' +
                         'Tentativa: "'        + IntToStr(ATentativaAtual)               + '" | ' +
                         'TipoErro: "'         + Desc_TTipoRetornoAPI[raErroComunicacao] + '" | ' +
                         'Url: "'              + AURL                                    + '" | ' +
                         'Metodo: "'           + 'POST'                                  + '" | ' +
                         'ConteudoEnviado: "'  + AJson.ToString                          + '" | ' +
                         'ConteudoRecebido: "' + ARetornoAPI                             + '" | ' +
                         'HttpStatusCode: "'   + LStatusCode                             + '" | ' +
                         'ErroCatalogado: "'   + IntToStr(AErroApi.CodErro)              + '" | ' +
                         'TempoDecorrido: "'   + LTempoDecorrido.ToString                + '"',
                         nil, 0, False, TCriticalLog.tlERROR);
{$ENDIF IS_MOBILE}
        end
        else
        begin
          Result := raOK;
          AErroAPI.CodErro := 0;
          AErroAPI.MsgErro := '';

{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
          TLogSQLite.New(tmInfo, clResponse, 'IntegracaoAPI (Resultado Ok)')
            .AddDetail('Tentativa'       , ATentativaAtual)
            .AddDetail('Url'             , AURL           )
            .AddDetail('Metodo'          , 'POST'         )
            .AddDetail('ConteudoEnviado' , AJson.ToString )
            .AddDetail('ConteudoRecebido', ARetornoAPI    )
            .AddDetail('HttpStatusCode'  , LStatusCode    )
            .AddDetail('TempoDecorrido'  , LTempoDecorrido)
            .Save;
{$ENDIF CompilarPara_TotemAA}
          TLog.MyLogTemp('IntegracaoAPI (Resultado Ok). ' +
                         'Tentativa: "'        + InTtoStr(ATentativaAtual) + '" | ' +
                         'Url: "'              + AURL                      + '" | ' +
                         'Metodo: "'           + 'POST'                    + '" | ' +
                         'ConteudoEnviado: "'  + AJson.ToString            + '" | ' +
                         'ConteudoRecebido: "' + ARetornoAPI               + '" | ' +
                         'HttpStatusCode: "'   + LStatusCode               + '" | ' +
                         'TempoDecorrido: "'   + LTempoDecorrido.ToString  + '"',
                         nil, 0, False, TCriticalLog.tlINFO);
{$ENDIF IS_MOBILE}
        end;
      except
        on E: Exception do
        begin
          AErroAPI.CodErro := -1;
          AErroAPI.MsgErro := E.Message;

          if E is EHTTPProtocolException then
          begin
            Result := raErroComunicacao;
{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
            TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
              .AddDetail('Tentativa'       , ATentativaAtual                             )
              .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroComunicacao]     )
              .AddDetail('Url'             , AURL                                        )
              .AddDetail('Metodo'          , 'POST'                                      )
              .AddDetail('ConteudoEnviado' , AJson.ToString                              )
              .AddDetail('ConteudoRecebido', E.Message                                   )
              .AddDetail('HttpStatusCode'  , EHTTPProtocolException(E).ErrorCode.ToString)
              .AddDetail('HttpStatusText'  , EHTTPProtocolException(E).ErrorMessage      )
              .AddDetail('ErroCatalogado'  , AErroApi.CodErro                            )
              .AddDetail('TempoDecorrido'  , LTempoDecorrido                             )
              .Save;
{$ENDIF CompilarPara_TotemAA}
            TLog.MyLogTemp('IntegracaoAPI (### Erro ###). ' +
                           'Tentativa: "'        + IntToStr(ATentativaAtual)                     + '" | ' +
                           'TipoErro: "'         + Desc_TTipoRetornoAPI[raErroComunicacao]       + '" | ' +
                           'Url: "'              + AURL                                          + '" | ' +
                           'Metodo: "'           + 'POST'                                        + '" | ' +
                           'ConteudoEnviado: "'  + AJson.ToString                                + '" | ' +
                           'ConteudoRecebido: "' + E.Message                                     + '" | ' +
                           'HttpStatusCode: "'   + EHTTPProtocolException(E).ErrorCode.ToString  + '" | ' +
                           'HttpStatusText: "'   + EHTTPProtocolException(E).ErrorMessage        + '" | ' +
                           'ErroCatalogado: "'   + IntToStr(AErroApi.CodErro)                    + '" | ' +
                           'TempoDecorrido: "'   + LTempoDecorrido.ToString                      + '"',
                           nil, 0, False, TCriticalLog.tlERROR);
{$ENDIF IS_MOBILE}

            AErroAPI.CodErro := EHTTPProtocolException(E).ErrorCode;  //LBC: Verificar esta linha pois o AErroAPI.CodErro deveria retornar um Erro Catalogado da Aplicação TotemAA, porém foi populado com o HttpErrorCode e necessário verificar o que está fazendo com essa informação ao sair desse método
          end
          else
          begin
            Result := raException;
{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
            TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
              .AddDetail('Tentativa'       , ATentativaAtual                  )
              .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raException])
              .AddDetail('Url'             , AURL                             )
              .AddDetail('Metodo'          , 'POST'                           )
              .AddDetail('ConteudoEnviado' , AJson.ToString                   )
              .AddDetail('ErroCatalogado'  , AErroApi.CodErro                 )
              .AddDetail('ExceptionMessage', E.Message                        )
              .AddDetail('TempoDecorrido'  , LTempoDecorrido                  )
              .Save;
{$ENDIF CompilarPara_TotemAA}
            TLog.MyLogTemp('IntegracaoAPI (### Erro ###). ' +
                           'Tentativa: "'        + IntToStr(ATentativaAtual)         + '" | ' +
                           'TipoErro: "'         + Desc_TTipoRetornoAPI[raException] + '" | ' +
                           'Url: "'              + AURL                              + '" | ' +
                           'Metodo: "'           + 'POST'                            + '" | ' +
                           'ConteudoEnviado: "'  + AJson.ToString                    + '" | ' +
                           'ErroCatalogado: "'   + IntToStr(AErroApi.CodErro)        + '" | ' +
                           'ExceptionMessage: "' + E.Message                         + '" | ' +
                           'TempoDecorrido: "'   + LTempoDecorrido.ToString          + '"',
                           nil, 0, False, TCriticalLog.tlERROR);
{$ENDIF IS_MOBILE}
          end;

          if ATentativaAtual < ATentivas then
          begin
            Sleep(2000);
            Result := IntIntegracaoAPI_Post(AURL, AJson, ARetornoAPI, AErroAPI, ATentivas, ATentativaAtual + 1, ACustomHeader);
          end;
        end;
      end;
    finally
      LStreamRes.Free;
    end;
  finally
    LStreamJson.Free;
  end;
end;


function IntIntegracaoAPI_Post(const AURL: string; const AJson: TJSONObject; out ARetornoAPI: string; out AErroAPI: TErroAPI; const ATentivas, ATentativaAtual: Integer; const ACustomHeader:Array of TCustomHeader): TTipoRetornoAPI; overload;
var
  LStreamJson: TStringStream;
  LStreamRes: TStringStream;
  LStatusCode: string;
  LEnviadoEm : TDateTime;
  LTempoDecorrido : integer;
begin
{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
{$IFDEF DEBUG}
  TLogSQLite.New(tmInfo, clRequest, 'IntegracaoAPI (Enviando)')
    .AddDetail('Tentativa'      , ATentativaAtual)
    .AddDetail('Url'            , AURL           )
    .AddDetail('Metodo'         , 'POST'         )
    .AddDetail('ConteudoEnviado', AJson.ToString )
    .Save;
{$ENDIF DEBUG}
{$ENDIF CompilarPara_TotemAA}
  TLog.MyLogTemp('IntegracaoAPI (Enviando). ' +
                 'Tentativa: "'       + IntToStr(ATentativaAtual) + '" | ' +
                 'Url: "'             + AURL                      + '" | ' +
                 'Metodo: "'          + 'POST'                    + '" | ' +
                 'ConteudoEnviado: "' + AJson.ToString            + '"',
                 nil, 0, False, TCriticalLog.tlINFO);
{$ENDIF IS_MOBILE}

  LStreamJson := TStringStream.Create(Utf8Encode(AJson.ToJSON));
  LStreamRes := TStringStream.Create;
  try
    try
      try
        LTempoDecorrido := -1;
        LEnviadoEm := now;
        LStatusCode:= THTTPRequest.Post(AURL, LStreamJson, LStreamRes, ACustomHeader).StatusCode.ToString;
        LTempoDecorrido := MilliSecondsBetween(Now, LEnviadoEm);

        ARetornoAPI := UTF8ToString(LStreamRes.DataString);

        //LBC: Futuramente remover isso daqui (quando todas as APIs estiverem em units sepaadas)
        if ((ARetornoAPI.Contains('Error receiving data')) or (ARetornoAPI.Contains('ERRO #5001')) or (ARetornoAPI.Contains('ERRO #5808'))) then
        begin
          Result := raErroComunicacao;
          AErroAPI.CodErro := -1;
          AErroAPI.MsgErro := 'Conteúdo recebido veio com palavras chave que indicam erro.';

{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
          TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
            .AddDetail('Tentativa'       , ATentativaAtual                        )
            .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroComunicacao])
            .AddDetail('Url'             , AURL                                   )
            .AddDetail('Metodo'          , 'POST'                                 )
            .AddDetail('ConteudoEnviado' , AJson.ToString                         )
            .AddDetail('ConteudoRecebido', ARetornoAPI                            )
            .AddDetail('HttpStatusCode'  , LStatusCode                            )
            .AddDetail('ErroCatalogado'  , AErroApi.CodErro                       )
            .AddDetail('TempoDecorrido'  , LTempoDecorrido                        )
            .Save;
{$ENDIF CompilarPara_TotemAA}
          TLog.MyLogTemp('IntegracaoAPI (### Erro ###). ' +
                         'Tentativa: "'        + IntToStr(ATentativaAtual)               + '" | ' +
                         'TipoErro: "'         + Desc_TTipoRetornoAPI[raErroComunicacao] + '" | ' +
                         'Url: "'              + AURL                                    + '" | ' +
                         'Metodo: "'           + 'POST'                                  + '" | ' +
                         'ConteudoEnviado: "'  + AJson.ToString                          + '" | ' +
                         'ConteudoRecebido: "' + ARetornoAPI                             + '" | ' +
                         'HttpStatusCode: "'   + LStatusCode                             + '" | ' +
                         'ErroCatalogado: "'   + IntToStr(AErroApi.CodErro)              + '" | ' +
                         'TempoDecorrido: "'   + LTempoDecorrido.ToString                + '"',
                         nil, 0, False, TCriticalLog.tlERROR);
{$ENDIF IS_MOBILE}
        end
        else
        begin
          Result := raOK;
          AErroAPI.CodErro := 0;
          AErroAPI.MsgErro := '';

{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
          TLogSQLite.New(tmInfo, clResponse, 'IntegracaoAPI (Resultado Ok)')
            .AddDetail('Tentativa'       , ATentativaAtual)
            .AddDetail('Url'             , AURL           )
            .AddDetail('Metodo'          , 'POST'         )
            .AddDetail('ConteudoEnviado' , AJson.ToString )
            .AddDetail('ConteudoRecebido', ARetornoAPI    )
            .AddDetail('HttpStatusCode'  , LStatusCode    )
            .AddDetail('TempoDecorrido'  , LTempoDecorrido)
            .Save;
{$ENDIF CompilarPara_TotemAA}
          TLog.MyLogTemp('IntegracaoAPI (Resultado Ok). ' +
                         'Tentativa: "'        + InTtoStr(ATentativaAtual) + '" | ' +
                         'Url: "'              + AURL                      + '" | ' +
                         'Metodo: "'           + 'POST'                    + '" | ' +
                         'ConteudoEnviado: "'  + AJson.ToString            + '" | ' +
                         'ConteudoRecebido: "' + ARetornoAPI               + '" | ' +
                         'HttpStatusCode: "'   + LStatusCode               + '" | ' +
                         'TempoDecorrido: "'   + LTempoDecorrido.ToString  + '"',
                         nil, 0, False, TCriticalLog.tlINFO);
{$ENDIF IS_MOBILE}
        end;
      except
        on E: Exception do
        begin
          AErroAPI.CodErro := -1;
          AErroAPI.MsgErro := E.Message;

          if E is EHTTPProtocolException then
          begin
            Result := raErroComunicacao;
{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
            TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
              .AddDetail('Tentativa'       , ATentativaAtual                             )
              .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroComunicacao]     )
              .AddDetail('Url'             , AURL                                        )
              .AddDetail('Metodo'          , 'POST'                                      )
              .AddDetail('ConteudoEnviado' , AJson.ToString                              )
              .AddDetail('ConteudoRecebido', E.Message                                   )
              .AddDetail('HttpStatusCode'  , EHTTPProtocolException(E).ErrorCode.ToString)
              .AddDetail('HttpStatusText'  , EHTTPProtocolException(E).ErrorMessage      )
              .AddDetail('ErroCatalogado'  , AErroApi.CodErro                            )
              .AddDetail('TempoDecorrido'  , LTempoDecorrido                             )
              .Save;
{$ENDIF CompilarPara_TotemAA}
            TLog.MyLogTemp('IntegracaoAPI (### Erro ###). ' +
                           'Tentativa: "'        + IntToStr(ATentativaAtual)                     + '" | ' +
                           'TipoErro: "'         + Desc_TTipoRetornoAPI[raErroComunicacao]       + '" | ' +
                           'Url: "'              + AURL                                          + '" | ' +
                           'Metodo: "'           + 'POST'                                        + '" | ' +
                           'ConteudoEnviado: "'  + AJson.ToString                                + '" | ' +
                           'ConteudoRecebido: "' + E.Message                                     + '" | ' +
                           'HttpStatusCode: "'   + EHTTPProtocolException(E).ErrorCode.ToString  + '" | ' +
                           'HttpStatusText: "'   + EHTTPProtocolException(E).ErrorMessage        + '" | ' +
                           'ErroCatalogado: "'   + IntToStr(AErroApi.CodErro)                    + '" | ' +
                           'TempoDecorrido: "'   + LTempoDecorrido.ToString                      + '"',
                           nil, 0, False, TCriticalLog.tlERROR);
{$ENDIF IS_MOBILE}

            AErroAPI.CodErro := EHTTPProtocolException(E).ErrorCode;  //LBC: Verificar esta linha pois o AErroAPI.CodErro deveria retornar um Erro Catalogado da Aplicação TotemAA, porém foi populado com o HttpErrorCode e necessário verificar o que está fazendo com essa informação ao sair desse método
          end
          else
          begin
            Result := raException;
{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
            TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
              .AddDetail('Tentativa'       , ATentativaAtual                  )
              .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raException])
              .AddDetail('Url'             , AURL                             )
              .AddDetail('Metodo'          , 'POST'                           )
              .AddDetail('ConteudoEnviado' , AJson.ToString                   )
              .AddDetail('ErroCatalogado'  , AErroApi.CodErro                 )
              .AddDetail('ExceptionMessage', E.Message                        )
              .AddDetail('TempoDecorrido'  , LTempoDecorrido                  )
              .Save;
{$ENDIF CompilarPara_TotemAA}
            TLog.MyLogTemp('IntegracaoAPI (### Erro ###). ' +
                           'Tentativa: "'        + IntToStr(ATentativaAtual)         + '" | ' +
                           'TipoErro: "'         + Desc_TTipoRetornoAPI[raException] + '" | ' +
                           'Url: "'              + AURL                              + '" | ' +
                           'Metodo: "'           + 'POST'                            + '" | ' +
                           'ConteudoEnviado: "'  + AJson.ToString                    + '" | ' +
                           'ErroCatalogado: "'   + IntToStr(AErroApi.CodErro)        + '" | ' +
                           'ExceptionMessage: "' + E.Message                         + '" | ' +
                           'TempoDecorrido: "'   + LTempoDecorrido.ToString          + '"',
                           nil, 0, False, TCriticalLog.tlERROR);
{$ENDIF IS_MOBILE}
          end;

          if ATentativaAtual < ATentivas then
          begin
            Sleep(2000);
            Result := IntIntegracaoAPI_Post(AURL, AJson, ARetornoAPI, AErroAPI, ATentivas, ATentativaAtual + 1, ACustomHeader);
          end;
        end;
      end;
    finally
      LStreamRes.Free;
    end;
  finally
    LStreamJson.Free;
  end;
end;


function IntIntegracaoAPI_Post(const AURL: string; const AJson: TJSONObject; out ARetornoAPI: string; out AErroAPI: TErroAPI; const ATentivas, ATentativaAtual: Integer; const ACustomHeader:Array of TCustomHeader; const AGravarLog:boolean): TTipoRetornoAPI; overload;
var
  LStreamJson: TStringStream;
  LStreamRes: TStringStream;
  LStatusCode: string;
  LEnviadoEm : TDateTime;
  LTempoDecorrido : integer;
begin
{$IFNDEF IS_MOBILE}
  if AGravarLog then
  begin
{$IFDEF CompilarPara_TotemAA}
{$IFDEF DEBUG}
    TLogSQLite.New(tmInfo, clRequest, 'IntegracaoAPI (Enviando)')
      .AddDetail('Tentativa'      , ATentativaAtual)
      .AddDetail('Url'            , AURL           )
      .AddDetail('Metodo'         , 'POST'         )
      .AddDetail('ConteudoEnviado', AJson.ToString )
      .Save;
{$ENDIF DEBUG}
{$ENDIF CompilarPara_TotemAA}
    TLog.MyLogTemp('IntegracaoAPI (Enviando). ' +
                   'Tentativa: "'       + IntToStr(ATentativaAtual) + '" | ' +
                   'Url: "'             + AURL                      + '" | ' +
                   'Metodo: "'          + 'POST'                    + '" | ' +
                   'ConteudoEnviado: "' + AJson.ToString            + '"',
                   nil, 0, False, TCriticalLog.tlINFO);
  end;
{$ENDIF IS_MOBILE}

  LStreamJson := TStringStream.Create(Utf8Encode(AJson.ToJSON));
  LStreamRes := TStringStream.Create;
  try
    try
      try
        LTempoDecorrido := -1;
        LEnviadoEm := now;
        LStatusCode:= THTTPRequest.Post(AURL, LStreamJson, LStreamRes, ACustomHeader).StatusCode.ToString;
        LTempoDecorrido := MilliSecondsBetween(Now, LEnviadoEm);

        ARetornoAPI := UTF8ToString(LStreamRes.DataString);

        //LBC: Futuramente remover isso daqui (quando todas as APIs estiverem em units sepaadas)
        if ((ARetornoAPI.Contains('Error receiving data')) or (ARetornoAPI.Contains('ERRO #5001')) or (ARetornoAPI.Contains('ERRO #5808'))) then
        begin
          Result := raErroComunicacao;
          AErroAPI.CodErro := -1;
          AErroAPI.MsgErro := 'Conteúdo recebido veio com palavras chave que indicam erro.';

{$IFNDEF IS_MOBILE}
          if AGravarLog then
          begin

{$IFDEF CompilarPara_TotemAA}
            TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
              .AddDetail('Tentativa'       , ATentativaAtual                        )
              .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroComunicacao])
              .AddDetail('Url'             , AURL                                   )
              .AddDetail('Metodo'          , 'POST'                                 )
              .AddDetail('ConteudoEnviado' , AJson.ToString                         )
              .AddDetail('ConteudoRecebido', ARetornoAPI                            )
              .AddDetail('HttpStatusCode'  , LStatusCode                            )
              .AddDetail('ErroCatalogado'  , AErroApi.CodErro                       )
              .AddDetail('TempoDecorrido'  , LTempoDecorrido                        )
              .Save;
{$ENDIF CompilarPara_TotemAA}
            TLog.MyLogTemp('IntegracaoAPI (### Erro ###). ' +
                           'Tentativa: "'        + IntToStr(ATentativaAtual)               + '" | ' +
                           'TipoErro: "'         + Desc_TTipoRetornoAPI[raErroComunicacao] + '" | ' +
                           'Url: "'              + AURL                                    + '" | ' +
                           'Metodo: "'           + 'POST'                                  + '" | ' +
                           'ConteudoEnviado: "'  + AJson.ToString                          + '" | ' +
                           'ConteudoRecebido: "' + ARetornoAPI                             + '" | ' +
                           'HttpStatusCode: "'   + LStatusCode                             + '" | ' +
                           'ErroCatalogado: "'   + IntToStr(AErroApi.CodErro)              + '" | ' +
                           'TempoDecorrido: "'   + LTempoDecorrido.ToString                + '"',
                           nil, 0, False, TCriticalLog.tlERROR);
          end;
{$ENDIF IS_MOBILE}
        end
        else
        begin
          Result := raOK;
          AErroAPI.CodErro := 0;
          AErroAPI.MsgErro := '';

{$IFNDEF IS_MOBILE}
          if AGravarLog then
          begin

{$IFDEF CompilarPara_TotemAA}
            TLogSQLite.New(tmInfo, clResponse, 'IntegracaoAPI (Resultado Ok)')
              .AddDetail('Tentativa'       , ATentativaAtual)
              .AddDetail('Url'             , AURL           )
              .AddDetail('Metodo'          , 'POST'         )
              .AddDetail('ConteudoEnviado' , AJson.ToString )
              .AddDetail('ConteudoRecebido', ARetornoAPI    )
              .AddDetail('HttpStatusCode'  , LStatusCode    )
              .AddDetail('TempoDecorrido'  , LTempoDecorrido)
              .Save;
{$ENDIF CompilarPara_TotemAA}
            TLog.MyLogTemp('IntegracaoAPI (Resultado Ok). ' +
                           'Tentativa: "'        + InTtoStr(ATentativaAtual) + '" | ' +
                           'Url: "'              + AURL                      + '" | ' +
                           'Metodo: "'           + 'POST'                    + '" | ' +
                           'ConteudoEnviado: "'  + AJson.ToString            + '" | ' +
                           'ConteudoRecebido: "' + ARetornoAPI               + '" | ' +
                           'HttpStatusCode: "'   + LStatusCode               + '" | ' +
                           'TempoDecorrido: "'   + LTempoDecorrido.ToString  + '"',
                           nil, 0, False, TCriticalLog.tlINFO);
          end;
{$ENDIF IS_MOBILE}
        end;
      except
        on E: Exception do
        begin
          AErroAPI.CodErro := -1;
          AErroAPI.MsgErro := E.Message;

          if E is EHTTPProtocolException then
          begin
            Result := raErroComunicacao;
{$IFNDEF IS_MOBILE}
            if AGravarLog then
            begin

{$IFDEF CompilarPara_TotemAA}
              TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
                .AddDetail('Tentativa'       , ATentativaAtual                             )
                .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroComunicacao]     )
                .AddDetail('Url'             , AURL                                        )
                .AddDetail('Metodo'          , 'POST'                                      )
                .AddDetail('ConteudoEnviado' , AJson.ToString                              )
                .AddDetail('ConteudoRecebido', E.Message                                   )
                .AddDetail('HttpStatusCode'  , EHTTPProtocolException(E).ErrorCode.ToString)
                .AddDetail('HttpStatusText'  , EHTTPProtocolException(E).ErrorMessage      )
                .AddDetail('ErroCatalogado'  , AErroApi.CodErro                            )
                .AddDetail('TempoDecorrido'  , LTempoDecorrido                             )
                .Save;
{$ENDIF CompilarPara_TotemAA}
              TLog.MyLogTemp('IntegracaoAPI (### Erro ###). ' +
                             'Tentativa: "'        + IntToStr(ATentativaAtual)                     + '" | ' +
                             'TipoErro: "'         + Desc_TTipoRetornoAPI[raErroComunicacao]       + '" | ' +
                             'Url: "'              + AURL                                          + '" | ' +
                             'Metodo: "'           + 'POST'                                        + '" | ' +
                             'ConteudoEnviado: "'  + AJson.ToString                                + '" | ' +
                             'ConteudoRecebido: "' + E.Message                                     + '" | ' +
                             'HttpStatusCode: "'   + EHTTPProtocolException(E).ErrorCode.ToString  + '" | ' +
                             'HttpStatusText: "'   + EHTTPProtocolException(E).ErrorMessage        + '" | ' +
                             'ErroCatalogado: "'   + IntToStr(AErroApi.CodErro)                    + '" | ' +
                             'TempoDecorrido: "'   + LTempoDecorrido.ToString                      + '"',
                             nil, 0, False, TCriticalLog.tlERROR);
            end;
{$ENDIF IS_MOBILE}

            AErroAPI.CodErro := EHTTPProtocolException(E).ErrorCode;  //LBC: Verificar esta linha pois o AErroAPI.CodErro deveria retornar um Erro Catalogado da Aplicação TotemAA, porém foi populado com o HttpErrorCode e necessário verificar o que está fazendo com essa informação ao sair desse método
          end
          else
          begin
            Result := raException;
{$IFNDEF IS_MOBILE}
            if AGravarLog then
            begin

{$IFDEF CompilarPara_TotemAA}
              TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
                .AddDetail('Tentativa'       , ATentativaAtual                  )
                .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raException])
                .AddDetail('Url'             , AURL                             )
                .AddDetail('Metodo'          , 'POST'                           )
                .AddDetail('ConteudoEnviado' , AJson.ToString                   )
                .AddDetail('ErroCatalogado'  , AErroApi.CodErro                 )
                .AddDetail('ExceptionMessage', E.Message                        )
                .AddDetail('TempoDecorrido'  , LTempoDecorrido                  )
                .Save;
{$ENDIF CompilarPara_TotemAA}
              TLog.MyLogTemp('IntegracaoAPI (### Erro ###). ' +
                             'Tentativa: "'        + IntToStr(ATentativaAtual)         + '" | ' +
                             'TipoErro: "'         + Desc_TTipoRetornoAPI[raException] + '" | ' +
                             'Url: "'              + AURL                              + '" | ' +
                             'Metodo: "'           + 'POST'                            + '" | ' +
                             'ConteudoEnviado: "'  + AJson.ToString                    + '" | ' +
                             'ErroCatalogado: "'   + IntToStr(AErroApi.CodErro)        + '" | ' +
                             'ExceptionMessage: "' + E.Message                         + '" | ' +
                             'TempoDecorrido: "'   + LTempoDecorrido.ToString          + '"',
                             nil, 0, False, TCriticalLog.tlERROR);
            end;
{$ENDIF IS_MOBILE}
          end;

          if ATentativaAtual < ATentivas then
          begin
            Sleep(2000);
            Result := IntIntegracaoAPI_Post(AURL, AJson, ARetornoAPI, AErroAPI, ATentivas, ATentativaAtual + 1, ACustomHeader);
          end;
        end;
      end;
    finally
      LStreamRes.Free;
    end;
  finally
    LStreamJson.Free;
  end;
end;


function IntIntegracaoAPI_Post(const AURL: string; const ARESTRequest: TRESTRequest; out ARetornoAPI: string; out AErroAPI: TErroAPI; const ATentivas, ATentativaAtual: Integer): TTipoRetornoAPI; overload;
var
  LStatusCode: string;
  LEnviadoEm : TDateTime;
  LTempoDecorrido : integer;
begin
{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
{$IFDEF DEBUG}
  TLogSQLite.New(tmInfo, clRequest, 'IntegracaoAPI (Enviando)')
    .AddDetail('Tentativa'      , ATentativaAtual             )
    .AddDetail('Url'            , AURL                        )
    .AddDetail('Metodo'         , 'POST'                      )
    .AddDetail('ConteudoEnviado', ARESTRequest.Params.ToString)
    .Save;
{$ENDIF DEBUG}
{$ENDIF CompilarPara_TotemAA}
  TLog.MyLogTemp('IntegracaoAPI (Enviando). ' +
                 'Tentativa: "'       + IntToStr(ATentativaAtual)    + '" | ' +
                 'Url: "'             + AURL                         + '" | ' +
                 'Metodo: "'          + 'POST'                       + '" | ' +
                 'ConteudoEnviado: "' + ARESTRequest.Params.ToString + '"',
                 nil, 0, False, TCriticalLog.tlINFO);
{$ENDIF IS_MOBILE}
  try
    if not Assigned(ARESTRequest.Client) then
      ARESTRequest.Client := TRESTClient.Create(ARESTRequest);
    ARESTRequest.Client.BaseURL := AURL;
    ARESTRequest.Method := TRESTRequestMethod.rmPOST;

    {EF O timeout default de 3000 do TRESTRequest não foi suficiente para subir um arquivo de 1.5 MB na URL http://10.33.1.27:20009/servico/siaf/episodioinserirdocumento
    Fiz testes com timeout de 4000 a 30000 e quase sempre falha.
    Pedi para o Einstein fazer testes de stress e carga e eventuais ajustes no timeout deles, pois o timeout deles parece ser menor do que o nosso.
    Depois que eles fizerem este trabalho de estabilização da API, quero fazer mais testes e escalar o timeout com o tamanho do arquivo e talvez com o n?mero de tentativas.}

    ARESTRequest.Timeout := FTimeOut;

    LEnviadoEm := now;
    ARESTRequest.Execute;
    LTempoDecorrido := MilliSecondsBetween(Now, LEnviadoEm);

    if not (ARESTRequest.Response.StatusCode in [200, 201]) then
      raise EHTTPProtocolException.Create(ARESTRequest.Response.StatusCode, ARESTRequest.Response.StatusText, ARESTRequest.Response.Content);
    LStatusCode := ARESTRequest.Response.StatusCode.ToString;
    ARetornoAPI := ARESTRequest.Response.Content;

    //LBC: Futuramente remover isso daqui (quando todas as APIs estiverem em units sepaadas)
    if ((ARetornoAPI.Contains('Error receiving data')) or (ARetornoAPI.Contains('ERRO #5001')) or (ARetornoAPI.Contains('ERRO #5808'))) then
    begin
      Result := raErroComunicacao;
      AErroAPI.CodErro := -1;
      AErroAPI.MsgErro := 'Conte?do recebido veio com palavras chave que indicam erro.';

{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
      TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
        .AddDetail('Tentativa'       , ATentativaAtual                        )
        .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroComunicacao])
        .AddDetail('Url'             , AURL                                   )
        .AddDetail('Metodo'          , 'POST'                                 )
        .AddDetail('ConteudoEnviado' , ARESTRequest.Params.ToString           )
        .AddDetail('ConteudoRecebido', ARetornoAPI                            )
        .AddDetail('HttpStatusCode'  , LStatusCode                            )
        .AddDetail('ErroCatalogado'  , AErroApi.CodErro                       )
        .AddDetail('TempoDecorrido'  , LTempoDecorrido                        )
        .Save;
{$ENDIF CompilarPara_TotemAA}
      TLog.MyLogTemp('IntegracaoAPI (### Erro ###). ' +
                     'Tentativa: "'        + IntToStr(ATentativaAtual)               + '" | ' +
                     'TipoErro: "'         + Desc_TTipoRetornoAPI[raErroComunicacao] + '" | ' +
                     'Url: "'              + AURL                                    + '" | ' +
                     'Metodo: "'           + 'POST'                                  + '" | ' +
                     'ConteudoEnviado: "'  + ARESTRequest.Params.ToString            + '" | ' +
                     'ConteudoRecebido: "' + ARetornoAPI                             + '" | ' +
                     'HttpStatusCode: "'   + LStatusCode                             + '" | ' +
                     'ErroCatalogado: "'   + IntToStr(AErroApi.CodErro)              + '" | ' +
                     'TempoDecorrido: "'   + LTempoDecorrido.ToString                + '"',
                     nil, 0, False, TCriticalLog.tlERROR);
{$ENDIF IS_MOBILE}
    end
    else
    begin
      Result := raOK;
      AErroAPI.CodErro := 0;
      AErroAPI.MsgErro := '';

{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
      TLogSQLite.New(tmInfo, clResponse, 'IntegracaoAPI (Resultado Ok)')
        .AddDetail('Tentativa'       , ATentativaAtual             )
        .AddDetail('Url'             , AURL                        )
        .AddDetail('Metodo'          , 'POST'                      )
        .AddDetail('ConteudoEnviado' , ARESTRequest.Params.ToString)
        .AddDetail('ConteudoRecebido', ARetornoAPI                 )
        .AddDetail('HttpStatusCode'  , LStatusCode                 )
        .AddDetail('TempoDecorrido'  , LTempoDecorrido             )
        .Save;
{$ENDIF CompilarPara_TotemAA}
      TLog.MyLogTemp('IntegracaoAPI (Resultado Ok). ' +
                     'Tentativa: "'        + InTtoStr(ATentativaAtual)    + '" | ' +
                     'Url: "'              + AURL                         + '" | ' +
                     'Metodo: "'           + 'POST'                       + '" | ' +
                     'ConteudoEnviado: "'  + ARESTRequest.Params.ToString + '" | ' +
                     'ConteudoRecebido: "' + ARetornoAPI                  + '" | ' +
                     'HttpStatusCode: "'   + LStatusCode                  + '" | ' +
                     'TempoDecorrido: "'   + LTempoDecorrido.ToString     + '"',
                     nil, 0, False, TCriticalLog.tlINFO);
{$ENDIF IS_MOBILE}
    end;
  except
    on E: Exception do
    begin
      AErroAPI.CodErro := -1;
      AErroAPI.MsgErro := E.Message;

      if E is EHTTPProtocolException then
      begin
        Result := raErroComunicacao;
{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
        TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
          .AddDetail('Tentativa'       , ATentativaAtual                             )
          .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroComunicacao]     )
          .AddDetail('Url'             , AURL                                        )
          .AddDetail('Metodo'          , 'POST'                                      )
          .AddDetail('ConteudoEnviado' , ARESTRequest.Params.ToString                              )
          .AddDetail('ConteudoRecebido', E.Message                                   )
          .AddDetail('HttpStatusCode'  , EHTTPProtocolException(E).ErrorCode.ToString)
          .AddDetail('HttpStatusText'  , EHTTPProtocolException(E).ErrorMessage      )
          .AddDetail('ErroCatalogado'  , AErroApi.CodErro                            )
          .AddDetail('TempoDecorrido'  , LTempoDecorrido                             )
          .Save;
{$ENDIF CompilarPara_TotemAA}
        TLog.MyLogTemp('IntegracaoAPI (### Erro ###). ' +
                       'Tentativa: "'        + IntToStr(ATentativaAtual)                     + '" | ' +
                       'TipoErro: "'         + Desc_TTipoRetornoAPI[raErroComunicacao]       + '" | ' +
                       'Url: "'              + AURL                                          + '" | ' +
                       'Metodo: "'           + 'POST'                                        + '" | ' +
                       'ConteudoEnviado: "'  + ARESTRequest.Params.ToString                  + '" | ' +
                       'ConteudoRecebido: "' + E.Message                                     + '" | ' +
                       'HttpStatusCode: "'   + EHTTPProtocolException(E).ErrorCode.ToString  + '" | ' +
                       'HttpStatusText: "'   + EHTTPProtocolException(E).ErrorMessage        + '" | ' +
                       'ErroCatalogado: "'   + IntToStr(AErroApi.CodErro)                    + '" | ' +
                       'TempoDecorrido: "'   + LTempoDecorrido.ToString                      + '"',
                       nil, 0, False, TCriticalLog.tlERROR);
{$ENDIF IS_MOBILE}

        AErroAPI.CodErro := EHTTPProtocolException(E).ErrorCode;  //LBC: Verificar esta linha pois o AErroAPI.CodErro deveria retornar um Erro Catalogado da Aplica磯 TotemAA, por魠foi populado com o HttpErrorCode e necessᲩo verificar o que estᠦazendo com essa informa磯 ao sair desse m鴯do
      end
      else
      begin
        Result := raException;
{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
        TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
          .AddDetail('Tentativa'       , ATentativaAtual                  )
          .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raException])
          .AddDetail('Url'             , AURL                             )
          .AddDetail('Metodo'          , 'POST'                           )
          .AddDetail('ConteudoEnviado' , ARESTRequest.Params.ToString     )
          .AddDetail('ErroCatalogado'  , AErroApi.CodErro                 )
          .AddDetail('ExceptionMessage', E.Message                        )
          .AddDetail('TempoDecorrido'  , LTempoDecorrido                  )
          .Save;
{$ENDIF CompilarPara_TotemAA}
        TLog.MyLogTemp('IntegracaoAPI (### Erro ###). ' +
                       'Tentativa: "'        + IntToStr(ATentativaAtual)         + '" | ' +
                       'TipoErro: "'         + Desc_TTipoRetornoAPI[raException] + '" | ' +
                       'Url: "'              + AURL                              + '" | ' +
                       'Metodo: "'           + 'POST'                            + '" | ' +
                       'ConteudoEnviado: "'  + ARESTRequest.Params.ToString      + '" | ' +
                       'ErroCatalogado: "'   + IntToStr(AErroApi.CodErro)        + '" | ' +
                       'ExceptionMessage: "' + E.Message                         + '" | ' +
                       'TempoDecorrido: "'   + LTempoDecorrido.ToString          + '"',
                       nil, 0, False, TCriticalLog.tlERROR);
{$ENDIF IS_MOBILE}
      end;

      if ATentativaAtual < ATentivas then
      begin
        Sleep(2000);
        Result := IntIntegracaoAPI_Post(AURL, ARESTRequest, ARetornoAPI, AErroAPI, ATentivas, ATentativaAtual + 1);
      end;
    end;
  end;
end;

function IntegracaoAPI_Post(const AURL: string; const AJson: TJSONArray; out ARetornoAPI: string; out AErroAPI: TErroAPI; const ATentivas: Integer; const AuthorizationHeaderToken: string): TTipoRetornoAPI;
var
  LTentativaAtual: Integer;
begin
  if FTimeOut = 0 then FTimeOut := 20000;
  LTentativaAtual := 1;
  Result := IntIntegracaoAPI_Post(AURL, AJson, ARetornoAPI, AErroAPI, ATentivas, LTentativaAtual, AuthorizationHeaderToken);
end;

function IntegracaoAPI_Post(const AURL: string; const AJson: TJSONObject; out ARetornoAPI: string; out AErroAPI: TErroAPI; const ATentivas: Integer; const AuthorizationHeaderToken: string; const AGravarLog:boolean): TTipoRetornoAPI;
var
  LTentativaAtual: Integer;
begin
  if FTimeOut = 0 then FTimeOut := 20000;
  LTentativaAtual := 1;
  Result := IntIntegracaoAPI_Post(AURL, AJson, ARetornoAPI, AErroAPI, ATentivas, LTentativaAtual, AuthorizationHeaderToken, AGravarLog);
end;

function IntegracaoAPI_Post(const AURL: string;const AAccept, AContentType:string; const AJson: TJSONArray; out ARetornoAPI: string; out AErroAPI: TErroAPI; const ATentivas: Integer; const AuthorizationHeaderToken: string): TTipoRetornoAPI;
var
  LTentativaAtual: Integer;
begin
  if FTimeOut = 0 then FTimeOut := 20000;
  LTentativaAtual := 1;
  Result := IntIntegracaoAPI_Post(AURL, AAccept, AContentType, AJson, ARetornoAPI, AErroAPI, ATentivas, LTentativaAtual, AuthorizationHeaderToken);
end;

function IntegracaoAPI_Post(const AURL: string; const AAccept, AContentType:string; const AJson: TJSONObject; out ARetornoAPI: string; out AErroAPI: TErroAPI; const ATentivas: Integer; const AuthorizationHeaderToken: string): TTipoRetornoAPI;
var
  LTentativaAtual: Integer;
begin
  if FTimeOut = 0 then FTimeOut := 20000;
  LTentativaAtual := 1;
  Result := IntIntegracaoAPI_Post(AURL, AAccept, AContentType, AJson, ARetornoAPI, AErroAPI, ATentivas, LTentativaAtual, AuthorizationHeaderToken);
end;

function IntegracaoAPI_Post(const AURL: string; const AJson: TJSONArray; out ARetornoAPI: string; out AErroAPI: TErroAPI; const ATentivas: Integer; const ACustomHeader:TCustomHeader): TTipoRetornoAPI;
var
  LTentativaAtual: Integer;
begin
  if FTimeOut = 0 then FTimeOut := 20000;
  LTentativaAtual := 1;
  Result := IntIntegracaoAPI_Post(AURL, AJson, ARetornoAPI, AErroAPI, ATentivas, LTentativaAtual, ACustomHeader);
end;

function IntegracaoAPI_Post(const AURL: string; const AJson: TJSONObject; out ARetornoAPI: string; out AErroAPI: TErroAPI; const ATentivas: Integer; const ACustomHeader:TCustomHeader): TTipoRetornoAPI;
var
  LTentativaAtual: Integer;
begin
  if FTimeOut = 0 then FTimeOut := 20000;
  LTentativaAtual := 1;
  Result := IntIntegracaoAPI_Post(AURL, AJson, ARetornoAPI, AErroAPI, ATentivas, LTentativaAtual, ACustomHeader);
end;

function IntegracaoAPI_Post(const AURL: string; const AJson: TJSONObject; out ARetornoAPI: string; out AErroAPI: TErroAPI; const ATentivas: Integer; const ACustomHeader:Array of TCustomHeader): TTipoRetornoAPI;
var
  LTentativaAtual: Integer;
begin
  if FTimeOut = 0 then FTimeOut := 20000;
  LTentativaAtual := 1;
  Result := IntIntegracaoAPI_Post(AURL, AJson, ARetornoAPI, AErroAPI, ATentivas, LTentativaAtual, ACustomHeader);
end;

function IntegracaoAPI_Post(const AURL: string; const AJson: TJSONObject; out ARetornoAPI: string; out AErroAPI: TErroAPI; const ATentivas: Integer; const ACustomHeader:Array of TCustomHeader; const AGravarLog:boolean = True): TTipoRetornoAPI; overload;
var
  LTentativaAtual: Integer;
begin
  if FTimeOut = 0 then FTimeOut := 20000;
  LTentativaAtual := 1;
  Result := IntIntegracaoAPI_Post(AURL, AJson, ARetornoAPI, AErroAPI, ATentivas, LTentativaAtual, ACustomHeader, AGravarLog);
end;

function IntegracaoAPI_Post(const AURL: string; const AMultiPartFormData: TMultipartFormData;out ARetornoAPI: string;out AErroAPI: TErroAPI;const ATentivas: Integer;const ACustomHeader:TCustomHeader; const AGravarLog:boolean): TTipoRetornoAPI;
var
  LTentativaAtual: Integer;
begin
  if FTimeOut = 0 then FTimeOut := 20000;
  LTentativaAtual := 1;
  Result := IntIntegracaoAPI_Post(AURL, AMultiPartFormData, ARetornoAPI, AErroAPI, ATentivas, LTentativaAtual, ACustomHeader, AGravarLog);
end;

function IntegracaoAPI_Post(const AURL: string; const ARESTRequest: TRESTRequest; out ARetornoAPI: string; out AErroAPI: TErroAPI; const ATentivas: Integer): TTipoRetornoAPI; overload;
var
  LTentativaAtual: Integer;
begin
  if FTimeOut = 0 then FTimeOut := 20000;
  LTentativaAtual := 1;
  Result := IntIntegracaoAPI_Post(AURL, ARESTRequest, ARetornoAPI, AErroAPI, ATentivas, LTentativaAtual);
end;

function IntIntegracaoAPI_Get(const AURL: string; out ARetornoAPI: string; out AErroAPI: TErroAPI; const ATentativaAtual: Integer; const ACustomHeader:TCustomHeader): TTipoRetornoAPI;overload;
var
  LStreamRes: TStringStream;
  LStatusCode: string;
  LEnviadoEm : TDateTime;
  LTempoDecorrido : integer;
begin
{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
{$IFDEF DEBUG}
  TLogSQLite.New(tmInfo, clRequest, 'IntegracaoAPI (Enviando)')
    .AddDetail('Tentativa', ATentativaAtual)
    .AddDetail('Url'      , AURL           )
    .AddDetail('Metodo'   , 'GET'          )
    .Save;
{$ENDIF DEBUG}
{$ENDIF CompilarPara_TotemAA}
  TLog.MyLogTemp('IntegracaoAPI (Enviando). ' +
                 'Tentativa: "' + IntToStr(ATentativaAtual) + '" | ' +
                 'Url: "'       + AURL                      + '" | ' +
                 'Metodo: "'    + 'GET'                     + '"',
                 nil, 0, False, TCriticalLog.tlINFO);
{$ENDIF IS_MOBILE}

  try
    LStreamRes := TStringStream.Create;
    try
      LEnviadoEm := now;
      LStatusCode:= THTTPRequest.Get(AURL, LStreamRes, ACustomHeader).StatusCode.ToString;
      LTempoDecorrido := MilliSecondsBetween(Now, LEnviadoEm);
      ARetornoAPI := UTF8ToString(LStreamRes.DataString);

      //Simular erro para tratar retorno RAP 04/05/2021

      Result := raOK;
      AErroAPI.CodErro := 0;
      AErroAPI.MsgErro := '';

{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
      TLogSQLite.New(tmInfo, clResponse, 'IntegracaoAPI (Resultado Ok)')
        .AddDetail('Tentativa'       , ATentativaAtual)
        .AddDetail('Url'             , AURL           )
        .AddDetail('Metodo'          , 'GET'          )
        .AddDetail('ConteudoRecebido', ARetornoAPI    )
        .AddDetail('HttpStatusCode'  , LStatusCode    )
        .AddDetail('TempoDecorrido'  , LTempoDecorrido)
        .Save;
{$ENDIF CompilarPara_TotemAA}
      TLog.MyLogTemp('IntegracaoAPI (Resultado Ok). ' +
                     'Tentativa: "'        + IntToStr(ATentativaAtual) + '" | ' +
                     'Url: "'              + AURL                      + '" | ' +
                     'Metodo: "'           + 'GET'                     + '" | ' +
                     'ConteudoRecebido: "' + ARetornoAPI               + '" | ' +
                     'HttpStatusCode: "'   + LStatusCode               + '" | ' +
                     'TempoDecorrido: "'   + LTempoDecorrido.ToString  + '"',
                     nil, 0, False, TCriticalLog.tlINFO);
{$ENDIF IS_MOBILE}
    finally
      LStreamRes.Free;
    end;
  except
    on E: Exception do
    begin
      AErroAPI.CodErro := -1;
      AErroAPI.MsgErro := E.Message;

      if E is EHTTPProtocolException then
      begin
        Result := raErroComunicacao;
{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
        TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
          .AddDetail('Tentativa'       , ATentativaAtual                             )
          .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroComunicacao]     )
          .AddDetail('Url'             , AURL                                        )
          .AddDetail('Metodo'          , 'GET'                                       )
          .AddDetail('ConteudoRecebido', E.Message                                   )
          .AddDetail('HttpStatusCode'  , EHTTPProtocolException(E).ErrorCode.ToString)
          .AddDetail('HttpStatusText'  , EHTTPProtocolException(E).ErrorMessage      )
          .AddDetail('ErroCatalogado'  , AErroApi.CodErro                            )
          .AddDetail('TempoDecorrido'  , LTempoDecorrido                             )
          .Save;
{$ENDIF CompilarPara_TotemAA}
        TLog.MyLogTemp('IntegracaoAPI (### Erro ###). ' +
                       'Tentativa: "'        + IntToStr(ATentativaAtual)                    + '" | ' +
                       'TipoErro: "'         + Desc_TTipoRetornoAPI[raErroComunicacao]      + '" | ' +
                       'Url: "'              + AURL                                         + '" | ' +
                       'Metodo: "'           + 'GET'                                        + '" | ' +
                       'ConteudoRecebido: "' + E.Message                                    + '" | ' +
                       'HttpStatusCode: "'   + EHTTPProtocolException(E).ErrorCode.ToString + '" | ' +
                       'HttpStatusText: "'   + EHTTPProtocolException(E).ErrorMessage       + '" | ' +
                       'ErroCatalogado: "'   + IntToStr(AErroApi.CodErro)                   + '" | ' +
                       'TempoDecorrido: "'   + LTempoDecorrido.ToString                     + '"',
                       nil, 0, False, TCriticalLog.tlERROR);
{$ENDIF IS_MOBILE}

        AErroAPI.CodErro := EHTTPProtocolException(E).ErrorCode;  //LBC: Verificar esta linha pois o AErroAPI.CodErro deveria retornar um Erro Catalogado da Aplicação TotemAA, porém foi populado com o HttpErrorCode e necessário verificar o que está fazendo com essa informação ao sair desse método
      end
      else
      begin
        Result := raException;
{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
        TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
          .AddDetail('Tentativa'       , ATentativaAtual                  )
          .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raException])
          .AddDetail('Url'             , AURL                             )
          .AddDetail('Metodo'          , 'GET'                            )
          .AddDetail('ErroCatalogado'  , AErroApi.CodErro                 )
          .AddDetail('ExceptionMessage', E.Message                        )
          .AddDetail('TempoDecorrido'  , LTempoDecorrido                  )
          .Save;
{$ENDIF CompilarPara_TotemAA}
        TLog.MyLogTemp('IntegracaoAPI (### Erro ###). ' +
                       'Tentativa: "'        + IntToStr(ATentativaAtual)         + '" | ' +
                       'TipoErro: "'         + Desc_TTipoRetornoAPI[raException] + '" | ' +
                       'Url: "'              + AURL                              + '" | ' +
                       'Metodo: "'           + 'GET'                             + '" | ' +
                       'ErroCatalogado: "'   + IntToStr(AErroApi.CodErro)        + '" | ' +
                       'ExceptionMessage: "' + E.Message                         + '" | ' +
                       'TempoDecorrido: "'   + LTempoDecorrido.ToString          + '"',
                       nil, 0, False, TCriticalLog.tlERROR);
{$ENDIF IS_MOBILE}
      end;

      if ATentativaAtual < 3 then
      begin
        Sleep(2000);
        Result := IntIntegracaoAPI_Get(AURL, ARetornoAPI, AErroAPI, ATentativaAtual + 1, ACustomHeader);
      end;
    end;
  end;
end;

function IntIntegracaoAPI_Get(const AURL: string; out ARetornoAPI: string; out AErroAPI: TErroAPI; const ATentativaAtual: Integer; const AuthorizationHeaderToken: string; const AGravarLog:boolean): TTipoRetornoAPI;overload;
var
  LStreamRes: TStringStream;
  LStatusCode: string;
  LEnviadoEm : TDateTime;
  LTempoDecorrido : integer;
begin
{$IFNDEF IS_MOBILE}
  if AGravarLog then
  begin
{$IFDEF CompilarPara_TotemAA}
{$IFDEF DEBUG}
    TLogSQLite.New(tmInfo, clRequest, 'IntegracaoAPI (Enviando)')
      .AddDetail('Tentativa', ATentativaAtual)
      .AddDetail('Url'      , AURL           )
      .AddDetail('Metodo'   , 'GET'          )
      .Save;
{$ENDIF DEBUG}
{$ENDIF CompilarPara_TotemAA}
    TLog.MyLogTemp('IntegracaoAPI (Enviando). ' +
                   'Tentativa: "' + IntToStr(ATentativaAtual) + '" | ' +
                   'Url: "'       + AURL                      + '" | ' +
                   'Metodo: "'    + 'GET'                     + '"',
                   nil, 0, False, TCriticalLog.tlINFO);
  end;
{$ENDIF IS_MOBILE}

  try
    LStreamRes := TStringStream.Create;
    try
      LEnviadoEm := now;
      LStatusCode:= THTTPRequest.Get(AURL, LStreamRes, AuthorizationHeaderToken).StatusCode.ToString;
      LTempoDecorrido := MilliSecondsBetween(Now, LEnviadoEm);
      ARetornoAPI := UTF8ToString(LStreamRes.DataString);

      //Simular erro para tratar retorno RAP 04/05/2021

      Result := raOK;
      AErroAPI.CodErro := 0;
      AErroAPI.MsgErro := '';

{$IFNDEF IS_MOBILE}
      if AGravarLog then
      begin
{$IFDEF CompilarPara_TotemAA}
        TLogSQLite.New(tmInfo, clResponse, 'IntegracaoAPI (Resultado Ok)')
          .AddDetail('Tentativa'       , ATentativaAtual)
          .AddDetail('Url'             , AURL           )
          .AddDetail('Metodo'          , 'GET'          )
          .AddDetail('ConteudoRecebido', ARetornoAPI    )
          .AddDetail('HttpStatusCode'  , LStatusCode    )
          .AddDetail('TempoDecorrido'  , LTempoDecorrido)
          .Save;
{$ENDIF CompilarPara_TotemAA}
        TLog.MyLogTemp('IntegracaoAPI (Resultado Ok). ' +
                       'Tentativa: "'        + IntToStr(ATentativaAtual) + '" | ' +
                       'Url: "'              + AURL                      + '" | ' +
                       'Metodo: "'           + 'GET'                     + '" | ' +
                       'ConteudoRecebido: "' + ARetornoAPI               + '" | ' +
                       'HttpStatusCode: "'   + LStatusCode               + '" | ' +
                       'TempoDecorrido: "'   + LTempoDecorrido.ToString  + '"',
                       nil, 0, False, TCriticalLog.tlINFO);
      end;
{$ENDIF IS_MOBILE}
    finally
      LStreamRes.Free;
    end;
  except
    on E: Exception do
    begin
      AErroAPI.CodErro := -1;
      AErroAPI.MsgErro := E.Message;

      if E is EHTTPProtocolException then
      begin
        Result := raErroComunicacao;
{$IFNDEF IS_MOBILE}
        if AGravarLog then
        begin
{$IFDEF CompilarPara_TotemAA}
          TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
            .AddDetail('Tentativa'       , ATentativaAtual                             )
            .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroComunicacao]     )
            .AddDetail('Url'             , AURL                                        )
            .AddDetail('Metodo'          , 'GET'                                       )
            .AddDetail('ConteudoRecebido', E.Message                                   )
            .AddDetail('HttpStatusCode'  , EHTTPProtocolException(E).ErrorCode.ToString)
            .AddDetail('HttpStatusText'  , EHTTPProtocolException(E).ErrorMessage      )
            .AddDetail('ErroCatalogado'  , AErroApi.CodErro                            )
            .AddDetail('TempoDecorrido'  , LTempoDecorrido                             )
            .Save;
{$ENDIF CompilarPara_TotemAA}
          TLog.MyLogTemp('IntegracaoAPI (### Erro ###). ' +
                         'Tentativa: "'        + IntToStr(ATentativaAtual)                    + '" | ' +
                         'TipoErro: "'         + Desc_TTipoRetornoAPI[raErroComunicacao]      + '" | ' +
                         'Url: "'              + AURL                                         + '" | ' +
                         'Metodo: "'           + 'GET'                                        + '" | ' +
                         'ConteudoRecebido: "' + E.Message                                    + '" | ' +
                         'HttpStatusCode: "'   + EHTTPProtocolException(E).ErrorCode.ToString + '" | ' +
                         'HttpStatusText: "'   + EHTTPProtocolException(E).ErrorMessage       + '" | ' +
                         'ErroCatalogado: "'   + IntToStr(AErroApi.CodErro)                   + '" | ' +
                         'TempoDecorrido: "'   + LTempoDecorrido.ToString                     + '"',
                         nil, 0, False, TCriticalLog.tlERROR);
        end;
{$ENDIF IS_MOBILE}

        AErroAPI.CodErro := EHTTPProtocolException(E).ErrorCode;  //LBC: Verificar esta linha pois o AErroAPI.CodErro deveria retornar um Erro Catalogado da Aplicação TotemAA, porém foi populado com o HttpErrorCode e necessário verificar o que está fazendo com essa informação ao sair desse método
      end
      else
      begin
        Result := raException;
{$IFNDEF IS_MOBILE}
        if AGravarLog then
        begin
{$IFDEF CompilarPara_TotemAA}
          TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
            .AddDetail('Tentativa'       , ATentativaAtual                  )
            .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raException])
            .AddDetail('Url'             , AURL                             )
            .AddDetail('Metodo'          , 'GET'                            )
            .AddDetail('ErroCatalogado'  , AErroApi.CodErro                 )
            .AddDetail('ExceptionMessage', E.Message                        )
            .AddDetail('TempoDecorrido'  , LTempoDecorrido                  )
            .Save;
{$ENDIF CompilarPara_TotemAA}
          TLog.MyLogTemp('IntegracaoAPI (### Erro ###). ' +
                         'Tentativa: "'        + IntToStr(ATentativaAtual)         + '" | ' +
                         'TipoErro: "'         + Desc_TTipoRetornoAPI[raException] + '" | ' +
                         'Url: "'              + AURL                              + '" | ' +
                         'Metodo: "'           + 'GET'                             + '" | ' +
                         'ErroCatalogado: "'   + IntToStr(AErroApi.CodErro)        + '" | ' +
                         'ExceptionMessage: "' + E.Message                         + '" | ' +
                         'TempoDecorrido: "'   + LTempoDecorrido.ToString          + '"',
                         nil, 0, False, TCriticalLog.tlERROR);
        end;
{$ENDIF IS_MOBILE}
      end;

      if ATentativaAtual < 3 then
      begin
        Sleep(2000);
        Result := IntIntegracaoAPI_Get(AURL, ARetornoAPI, AErroAPI, ATentativaAtual + 1, AuthorizationHeaderToken, AGravarLog);
      end;
    end;
  end;
end;

function IntegracaoAPI_Get(const AURL: string; out ARetornoAPI: string; out AErroAPI: TErroAPI; const ACustomHeader:TCustomHeader ): TTipoRetornoAPI; overload;
var
  LTentativaAtual: Integer;
begin
  LTentativaAtual := 1;
  Result := IntIntegracaoAPI_Get(AURL, ARetornoAPI, AErroAPI, LTentativaAtual, ACustomHeader);
end;

function IntegracaoAPI_Get(const AURL: string; out ARetornoAPI: string; out AErroAPI: TErroAPI; const AuthorizationHeaderToken: string; const AGravarLog:boolean): TTipoRetornoAPI; overload;
var
  LTentativaAtual: Integer;
begin
  LTentativaAtual := 1;
  Result := IntIntegracaoAPI_Get(AURL, ARetornoAPI, AErroAPI, LTentativaAtual, AuthorizationHeaderToken, AGravarLog);
end;

function IntIntegracaoAPI_Put(const AURL: string; const AJson: TJSONObject; out ARetornoAPI: string; out AErroAPI: TErroAPI; const ATentivas, ATentativaAtual: Integer; const AuthorizationHeaderToken: string): TTipoRetornoAPI; overload; overload;
var
  LStreamJson: TStringStream;
  LStreamRes: TStringStream;
  LStatusCode: string;
  LEnviadoEm : TDateTime;
  LTempoDecorrido : integer;
begin
{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
{$IFDEF DEBUG}
  TLogSQLite.New(tmInfo, clRequest, 'IntegracaoAPI (Enviando)')
    .AddDetail('Tentativa'      , ATentativaAtual)
    .AddDetail('Url'            , AURL           )
    .AddDetail('Metodo'         , 'PUT'         )
    .AddDetail('ConteudoEnviado', AJson.ToString )
    .Save;
{$ENDIF DEBUG}
{$ENDIF CompilarPara_TotemAA}
  TLog.MyLogTemp('IntegracaoAPI (Enviando). ' +
                 'Tentativa: "'       + IntToStr(ATentativaAtual) + '" | ' +
                 'Url: "'             + AURL                      + '" | ' +
                 'Metodo: "'          + 'PUT'                    + '" | ' +
                 'ConteudoEnviado: "' + AJson.ToString            + '"',
                 nil, 0, False, TCriticalLog.tlINFO);
{$ENDIF IS_MOBILE}

  LStreamJson := TStringStream.Create(Utf8Encode(AJson.ToJSON));
  LStreamRes := TStringStream.Create;
  try
    try
      try
        LTempoDecorrido := -1;
        LEnviadoEm := now;
        LStatusCode:= THTTPRequest.Put(AURL, LStreamJson, LStreamRes).StatusCode.ToString;
        LTempoDecorrido := MilliSecondsBetween(Now, LEnviadoEm);

        ARetornoAPI := UTF8ToString(LStreamRes.DataString);

        //LBC: Futuramente remover isso daqui (quando todas as APIs estiverem em units sepaadas)
        if ((ARetornoAPI.Contains('Error receiving data')) or (ARetornoAPI.Contains('ERRO #5001')) or (ARetornoAPI.Contains('ERRO #5808'))) then
        begin
          Result := raErroComunicacao;
          AErroAPI.CodErro := -1;
          AErroAPI.MsgErro := 'Conteúdo recebido veio com palavras chave que indicam erro.';

{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
          TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
            .AddDetail('Tentativa'       , ATentativaAtual                        )
            .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroComunicacao])
            .AddDetail('Url'             , AURL                                   )
            .AddDetail('Metodo'          , 'PUT'                                  )
            .AddDetail('ConteudoEnviado' , AJson.ToString                         )
            .AddDetail('ConteudoRecebido', ARetornoAPI                            )
            .AddDetail('HttpStatusCode'  , LStatusCode                            )
            .AddDetail('ErroCatalogado'  , AErroApi.CodErro                       )
            .AddDetail('TempoDecorrido'  , LTempoDecorrido                        )
            .Save;
{$ENDIF CompilarPara_TotemAA}
          TLog.MyLogTemp('IntegracaoAPI (### Erro ###). ' +
                         'Tentativa: "'        + IntToStr(ATentativaAtual)               + '" | ' +
                         'TipoErro: "'         + Desc_TTipoRetornoAPI[raErroComunicacao] + '" | ' +
                         'Url: "'              + AURL                                    + '" | ' +
                         'Metodo: "'           + 'PUT'                                   + '" | ' +
                         'ConteudoEnviado: "'  + AJson.ToString                          + '" | ' +
                         'ConteudoRecebido: "' + ARetornoAPI                             + '" | ' +
                         'HttpStatusCode: "'   + LStatusCode                             + '" | ' +
                         'ErroCatalogado: "'   + IntToStr(AErroApi.CodErro)              + '" | ' +
                         'TempoDecorrido: "'   + LTempoDecorrido.ToString                + '"',
                         nil, 0, False, TCriticalLog.tlERROR);
{$ENDIF IS_MOBILE}
        end
        else
        begin
          Result := raOK;
          AErroAPI.CodErro := 0;
          AErroAPI.MsgErro := '';

{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
         TLogSQLite.New(tmInfo, clResponse, 'IntegracaoAPI (Resultado Ok)')
            .AddDetail('Tentativa'       , ATentativaAtual)
            .AddDetail('Url'             , AURL           )
            .AddDetail('Metodo'          , 'PUT'          )
            .AddDetail('ConteudoEnviado' , AJson.ToString )
            .AddDetail('ConteudoRecebido', ARetornoAPI    )
            .AddDetail('HttpStatusCode'  , LStatusCode    )
            .AddDetail('TempoDecorrido'  , LTempoDecorrido)
            .Save;
{$ENDIF CompilarPara_TotemAA}
          TLog.MyLogTemp('IntegracaoAPI (Resultado Ok). ' +
                         'Tentativa: "'        + InTtoStr(ATentativaAtual) + '" | ' +
                         'Url: "'              + AURL                      + '" | ' +
                         'Metodo: "'           + 'PUT'                     + '" | ' +
                         'ConteudoEnviado: "'  + AJson.ToString            + '" | ' +
                         'ConteudoRecebido: "' + ARetornoAPI               + '" | ' +
                         'HttpStatusCode: "'   + LStatusCode               + '" | ' +
                         'TempoDecorrido: "'   + LTempoDecorrido.ToString  + '"',
                         nil, 0, False, TCriticalLog.tlINFO);
{$ENDIF IS_MOBILE}
        end;
      except
        on E: Exception do
        begin
          AErroAPI.CodErro := -1;
          AErroAPI.MsgErro := E.Message;

          if E is EHTTPProtocolException then
          begin
            Result := raErroComunicacao;
{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
            TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
              .AddDetail('Tentativa'       , ATentativaAtual                             )
              .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroComunicacao]     )
              .AddDetail('Url'             , AURL                                        )
              .AddDetail('Metodo'          , 'PUT'                                       )
              .AddDetail('ConteudoEnviado' , AJson.ToString                              )
              .AddDetail('ConteudoRecebido', E.Message                                   )
              .AddDetail('HttpStatusCode'  , EHTTPProtocolException(E).ErrorCode.ToString)
              .AddDetail('HttpStatusText'  , EHTTPProtocolException(E).ErrorMessage      )
              .AddDetail('ErroCatalogado'  , AErroApi.CodErro                            )
              .AddDetail('TempoDecorrido'  , LTempoDecorrido                             )
              .Save;
{$ENDIF CompilarPara_TotemAA}
            TLog.MyLogTemp('IntegracaoAPI (### Erro ###). ' +
                           'Tentativa: "'        + IntToStr(ATentativaAtual)                     + '" | ' +
                           'TipoErro: "'         + Desc_TTipoRetornoAPI[raErroComunicacao]       + '" | ' +
                           'Url: "'              + AURL                                          + '" | ' +
                           'Metodo: "'           + 'PUT'                                         + '" | ' +
                           'ConteudoEnviado: "'  + AJson.ToString                                + '" | ' +
                           'ConteudoRecebido: "' + E.Message                                     + '" | ' +
                           'HttpStatusCode: "'   + EHTTPProtocolException(E).ErrorCode.ToString  + '" | ' +
                           'HttpStatusText: "'   + EHTTPProtocolException(E).ErrorMessage        + '" | ' +
                           'ErroCatalogado: "'   + IntToStr(AErroApi.CodErro)                    + '" | ' +
                           'TempoDecorrido: "'   + LTempoDecorrido.ToString                      + '"',
                           nil, 0, False, TCriticalLog.tlERROR);
{$ENDIF IS_MOBILE}

            AErroAPI.CodErro := EHTTPProtocolException(E).ErrorCode;  //LBC: Verificar esta linha pois o AErroAPI.CodErro deveria retornar um Erro Catalogado da Aplicação TotemAA, porém foi populado com o HttpErrorCode e necessário verificar o que está fazendo com essa informação ao sair desse método
          end
          else
          begin
            Result := raException;
{$IFNDEF IS_MOBILE}
{$IFDEF CompilarPara_TotemAA}
            TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
              .AddDetail('Tentativa'       , ATentativaAtual                  )
              .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raException])
              .AddDetail('Url'             , AURL                             )
              .AddDetail('Metodo'          , 'PUT'                            )
              .AddDetail('ConteudoEnviado' , AJson.ToString                   )
              .AddDetail('ErroCatalogado'  , AErroApi.CodErro                 )
              .AddDetail('ExceptionMessage', E.Message                        )
              .AddDetail('TempoDecorrido'  , LTempoDecorrido                  )
              .Save;
{$ENDIF CompilarPara_TotemAA}
            TLog.MyLogTemp('IntegracaoAPI (### Erro ###). ' +
                           'Tentativa: "'        + IntToStr(ATentativaAtual)         + '" | ' +
                           'TipoErro: "'         + Desc_TTipoRetornoAPI[raException] + '" | ' +
                           'Url: "'              + AURL                              + '" | ' +
                           'Metodo: "'           + 'PUT'                             + '" | ' +
                           'ConteudoEnviado: "'  + AJson.ToString                    + '" | ' +
                           'ErroCatalogado: "'   + IntToStr(AErroApi.CodErro)        + '" | ' +
                           'ExceptionMessage: "' + E.Message                         + '" | ' +
                           'TempoDecorrido: "'   + LTempoDecorrido.ToString          + '"',
                           nil, 0, False, TCriticalLog.tlERROR);
{$ENDIF IS_MOBILE}
          end;

          if ATentativaAtual < ATentivas then
          begin
            Sleep(2000);
            Result := IntIntegracaoAPI_Put(AURL, AJson, ARetornoAPI, AErroAPI, ATentivas, ATentativaAtual + 1, AuthorizationHeaderToken);
          end;
        end;
      end;
    finally
      LStreamRes.Free;
    end;
  finally
    LStreamJson.Free;
  end;
end;

function IntegracaoAPI_Put(const AURL: string; const AJson: TJSONObject; out ARetornoAPI: string; out AErroAPI: TErroAPI; const ATentivas: Integer; const AuthorizationHeaderToken: string): TTipoRetornoAPI;
var
  LTentativaAtual: Integer;
begin
  if FTimeOut = 0 then FTimeOut := 20000;
  LTentativaAtual := 1;
  Result := IntIntegracaoAPI_Put(AURL, AJson, ARetornoAPI, AErroAPI, ATentivas, LTentativaAtual, AuthorizationHeaderToken);
end;

function EncodeString(AParam: String): String;
var
  LBase64: TBase64Encoding;
begin
  try
    LBase64 := TBase64Encoding.Create(50, '');
    Result := LBase64.Encode(AParam);
  finally
    LBase64.Free;
  end;
end;

function DecodeString(AParam: String): String;
var
  LBase64: TBase64Encoding;
begin
  try
    LBase64 := TBase64Encoding.Create(50, '');
    Result := LBase64.Decode(AParam);
  finally
    LBase64.Free;
  end;
end;

end.
