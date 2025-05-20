unit APIs.Aspect.Sics.BuscarParametro;

interface

uses
  APIs.Common, LogSQLite;

type
  TParametrosSaidaAPI = record
    Valor: string;
  end;

  TAPIAspectSicsBuscarParametro = class
  private
  public
    class var URL: string;
    class function Execute(out AParametrosSaida: TParametrosSaidaAPI; out AErroAPI: TErroAPI): TTipoRetornoAPI;
  end;
  procedure PopularParametros;

implementation

uses
  IniFiles,
  System.SysUtils,
  System.JSON,
  untLog;

{ TAPIAspectSicsAtualizarAtendimento }

procedure PopularParametros;
begin
{$IFDEF CompilarPara_TotemAA}
  TAPIAspectSicsBuscarParametro.URL := controller.parametros.CarregarParametroStr('APIs.Aspect.Sics', 'URL_BuscarParametro', 'http://localhost/aspect/backend/BuscarParametro');
{$ENDIF CompilarPara_TotemAA}
end;

class function TAPIAspectSicsBuscarParametro.Execute(out AParametrosSaida: TParametrosSaidaAPI; out AErroAPI: TErroAPI): TTipoRetornoAPI;
var
  LRetorno: string;
  LJSONResposta: TJSONObject;
begin
  TLogSQLite.New(tmInfo, clResponse, 'Consumindo API BuscarParametro').Save;
  TLog.MyLogTemp('Consumindo API BuscarParametro', nil, 0, False, TCriticalLog.tlINFO);

  try
    try
      Result := IntegracaoAPI_Get(URL, LRetorno, AErroAPI);

      if Result = raOK then
      begin
        LJSONResposta := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(LRetorno), 0) as TJSONObject;
        try
          if (LJSONResposta <> nil) then
          begin
            AErroAPI.CodErro := 0;
            AErroAPI.MsgErro := '';

            AParametrosSaida.Valor := LRetorno;
          end
          else
          begin
            Result := raErroNegocio;

            AErroAPI.CodErro := -1;
            AErroAPI.MsgErro := 'Erro no evento "' + Self.ClassName + '.Execute" / ' +
                                'URL: "' + URL + '" / ' +
                                'Recebido: "' + LRetorno + '"';

            TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
              .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroNegocio])
              .AddDetail('Evento'          , Self.ClassName                     )
              .AddDetail('Url'             , URL                                )
              .AddDetail('Metodo'          , 'GET'                              )
              .AddDetail('ConteudoRecebido', LRetorno                           )
              .AddDetail('ErroCatalogado'  , AErroAPI.CodErro                   )
              .Save;
            TLog.MyLogTemp(AErroAPI.MsgErro, nil, 0, False, TCriticalLog.tlERROR);
          end;
        finally
          LJSONResposta.Free;
        end;
      end;
    except
      on E: Exception do
      begin
        Result := raException;

        AErroAPI.CodErro := -1;
        AErroAPI.MsgErro := 'Exception no evento "' + Self.ClassName + '.Execute" / ' +
                            'URL: "' + URL + '" / ' +
                            'Recebido: "' + LRetorno + '" / ' +
                            'Erro: "' + E.Message + '"';

        TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
          .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raException])
          .AddDetail('Evento'          , Self.ClassName                   )
          .AddDetail('Url'             , URL                              )
          .AddDetail('Metodo'          , 'GET'                            )
          .AddDetail('ConteudoRecebido', LRetorno                         )
          .AddDetail('ErroCatalogado'  , AErroAPI.CodErro                 )
          .AddDetail('ExceptionMessage', E.Message                        )
          .Save;
        TLog.MyLogTemp(AErroAPI.MsgErro, nil, 0, False, TCriticalLog.tlERROR);
      end;
    end;
  finally
  end;
end;

initialization
{$IFNDEF CompilarPara_TotemAA}
  with TIniFile.Create(IncludeTrailingPathDelimiter(System.SysUtils.GetCurrentDir) + StringReplace(ExtractFileName(ParamStr(0)), '.exe', '.ini', [rfReplaceAll])) do
  try
    TAPIAspectSicsBuscarParametro.URL := ReadString('APIs.Aspect.Sics.BuscarParametro', 'URL', '');
    WriteString('APIs.Aspect.Sics.BuscarParametro', 'URL', TAPIAspectSicsBuscarParametro.URL);
  finally
    Free;
  end;
{$ENDIF}
end.
