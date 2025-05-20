unit APIs.Einstein.ObterTokenRHSSO;

interface
uses
  APIs.Common, LogSQLite, System.SysUtils, System.Generics.Collections;

type
  TParametrosEntradaAPIRefresh =  record
                                    token : string;
                                  end;
  TParametrosSaidaAPI = record
                          token : string;
                        end;

procedure PopularParametros;

function ObterToken(out AParametrosSaida : TParametrosSaidaAPI; out AErroApi : TErroAPI) : TTipoRetornoApi;

implementation

uses
{$IFDEF CompilarPara_TotemAA}
  controller.parametros,
{$ENDIF}
  IniFiles, System.Json, untLog;

var
  URL: string;
  Client_ID: string;
  Client_Secret: string;

procedure PopularParametros;
begin
{$IFDEF CompilarPara_TotemAA}
  URL := controller.parametros.CarregarParametroStr('APIs.Einstein', 'URL_ObterTokenRHSSO', 'https://rh-sso-hom.einstein.br/auth/realms/ESB/protocol/openid-connect/token');
  Client_ID:= controller.parametros.CarregarParametroStr('APIs.Einstein', 'Client_Id_RHSSO', '');
  Client_Secret:= controller.parametros.CarregarParametroStr('APIs.Einstein', 'Client_Secret_RHSSO', '');
{$ENDIF}
end;

function ObterToken(out AParametrosSaida : TParametrosSaidaAPI; out AErroApi : TErroAPI) : TTipoRetornoApi;
var
  LJSON, LJSONResposta  : TJSONObject;
  LRetorno              : string;
  LObjeto               : TJSONArray;
  LJo                   : TJSONObject;
  LContentType          : string;
  LAccept               : string;
  LToken                : string;
begin
  TLogSQLite.New(tmInfo, clResponse, 'Consumindo API ObterTokenRHSSO').Save;
  TLog.MyLogTemp('Consumindo API ObterTokenRHSSO', nil, 0, False, TCriticalLog.tlINFO);
  LToken := EmptyStr;
  LJSON := TJSONObject.Create;
  try
    try
      LAccept := 'application/x-www-form-urlencoded';
      LContentType := 'application/x-www-form-urlencoded';

      LJSON.AddPair('grant_type', 'client_credentials');
      LJSON.AddPair('client_id', Client_ID);
      LJSON.AddPair('client_secret', Client_Secret);

      Result := IntegracaoAPI_Post(URL, LAccept, LContentType, LJSON, LRetorno, AErroApi, 3);

      if (Result = raOK) then
      begin
        LJSONResposta := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(LRetorno), 0) as TJSONObject;
        try
          LJSONResposta.TryGetValue('access_token', LToken);
        finally
          LJSONResposta.Free;
        end;
        AParametrosSaida.token := LToken;
      end;

      if Result = raErroNegocio then
      begin
        AErroApi.CodErro := -1;
        AErroApi.MsgErro := 'Erro no evento APIs.Einstein.ObterTokenRHSSO. ' +
                            'URL: "' + URL + '" / ' +
                            'Enviado: "' + LJSON.ToJSON + '" / ' +
                            'Recebido: "' + LRetorno + '"';

        TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
          .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroNegocio]      )
          .AddDetail('Evento'          , 'APIs.Einstein.ObterTokenRHSSO')
          .AddDetail('Url'             , URL                                      )
          .AddDetail('Metodo'          , 'POST'                                   )
          .AddDetail('ConteudoEnviado' , LJson.ToString                           )
          .AddDetail('ConteudoRecebido', LRetorno                                 )
          .AddDetail('ErroCatalogado'  , AErroApi.CodErro                         )
          .Save;
        TLog.MyLogTemp(AErroApi.MsgErro, nil, 0, False, TCriticalLog.tlERROR);
      end;
    except
      on E: Exception do
      begin
        Result := raException;
        AErroApi.CodErro := -1;
        AErroApi.MsgErro := 'Exception no evento APIs.Einstein.ObterTokenRHSSO. ' +
                            'URL: "' + URL + '" / ' +
                            'Enviado: "' + LJSON.ToJSON + '" / ' +
                            'Recebido: "' + LRetorno + '" / ' +
                            'Erro: "' + E.Message + '"';

        TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
          .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raException]        )
          .AddDetail('Evento'          , 'APIs.Einstein.ObterTokenRHSSO')
          .AddDetail('Url'             , URL                                      )
          .AddDetail('Metodo'          , 'POST'                                   )
          .AddDetail('ConteudoEnviado' , LJson.ToString                           )
          .AddDetail('ConteudoRecebido', LRetorno                                 )
          .AddDetail('ErroCatalogado'  , AErroApi.CodErro                         )
          .AddDetail('ExceptionMessage', E.Message                                )
          .Save;
        TLog.MyLogTemp(AErroApi.MsgErro, nil, 0, False, TCriticalLog.tlERROR)
      end;
    end;
  finally
    FreeAndNil(LJSON);
  end;

end;


initialization
{$IFNDEF CompilarPara_TotemAA}
  with TIniFile.Create(IncludeTrailingPathDelimiter(System.SysUtils.GetCurrentDir) + StringReplace(ExtractFileName(ParamStr(0)), '.exe', '.ini', [rfReplaceAll])) do
  try
    URL := ReadString ('APIs.Einstein.ObterTokenRHSSO', 'URL', 'https://rh-sso-hom.einstein.br/auth/realms/ESB/protocol/openid-connect/token');
    WriteString ('APIs.Einstein.ObterTokenRHSSO', 'URL', URL);
    Client_ID := ReadString ('APIs.Einstein.ObterTokenRHSSO', 'Client_Id', '');
    WriteString ('APIs.Einstein.ObterTokenRHSSO', 'Client_Id', Client_ID);
    Client_Secret := ReadString ('APIs.Einstein.ObterTokenRHSSO', 'Client_Secret', '');
    WriteString ('APIs.Einstein.ObterTokenRHSSO', 'Client_Secret', Client_Secret);
  finally
    Free;
  end;
{$ENDIF}


end.