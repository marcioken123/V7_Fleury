unit APIs.Aspect.Sics.FinalizarAtendimento;

interface

uses
  APIs.Common, LogSQLite;

type
  TAPIAspectSicsFinalizarAtendimento = class
  private
  public
    type
      TParametrosEntradaAPI = record
        IdUnidade: string;
        TrackingID: string;
        IdResultado: string;
      end;
      TParametrosSaidaAPI = record
      end;
    class var URL: string;
    class function Execute(const AParametrosEntrada: TParametrosEntradaAPI; out AParametrosSaida: TParametrosSaidaAPI; out AErroAPI: TErroAPI): TTipoRetornoAPI;
  end;
  procedure PopularParametros;

implementation

uses
  IniFiles, System.SysUtils, System.JSON, ufrmSicsTotemAA, untLog,
  controller.parametros;

{ TAPIAspectSicsGerarSenha }

procedure PopularParametros;
begin
  TAPIAspectSicsFinalizarAtendimento.URL := controller.parametros.CarregarParametroStr('APIs.Aspect.Sics', 'URL_FinalizarAtendimento', 'http://localhost/aspect/rest/AA/FinalizarAtendimento');
end;

class function TAPIAspectSicsFinalizarAtendimento.Execute(const AParametrosEntrada: TParametrosEntradaAPI; out AParametrosSaida: TParametrosSaidaAPI; out AErroAPI: TErroAPI): TTipoRetornoAPI;
var
  LJSON: TJSONObject;
  LRetorno: string;
  LJSONResposta: TJSONObject;
begin
  TLogSQLite.New(tmInfo, clResponse, 'Consumindo API FinalizarAtendimento').Save;
  TLog.MyLogTemp('Consumindo API FinalizarAtendimento', nil, 0, False, TCriticalLog.tlINFO);
  LJSON := TJSONObject.Create;
  try
    try
      LJSON.AddPair('AIdUnidade', AParametrosEntrada.IdUnidade);
      LJSON.AddPair('ATrackingID', AParametrosEntrada.TrackingID);
      LJSON.AddPair('AIdResultado', AParametrosEntrada.IdResultado);
      Result := IntegracaoAPI_Post(URL, LJSON, LRetorno, AErroAPI, 1);

      if Result = raOK then
      begin
        LJSONResposta := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(LRetorno), 0) as TJSONObject;
        try
          if (LJSONResposta <> nil) then
          begin
            AErroAPI.CodErro := 0;
            AErroAPI.MsgErro := '';

            Result := raOk;
          end
          else
          begin
            Result := raErroNegocio;

            AErroAPI.CodErro := -1;
            AErroAPI.MsgErro := 'Erro no evento "' + Self.ClassName + '.Execute" / ' +
                                'URL: "' + URL + '" / ' +
                                'Enviado: "' + LJSON.ToJSON + '" / ' +
                                'Recebido: "' + LRetorno + '"';

            TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
              .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroNegocio])
              .AddDetail('Evento'          , Self.ClassName                     )
              .AddDetail('Url'             , URL                                )
              .AddDetail('Metodo'          , 'POST'                             )
              .AddDetail('ConteudoEnviado' , LJSON.ToString                     )
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
                            'Enviado: "' + LJSON.ToJSON + '" / ' +
                            'Recebido: "' + LRetorno + '" / ' +
                            'Erro: "' + E.Message + '"';

        TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
          .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raException])
          .AddDetail('Evento'          , Self.ClassName                   )
          .AddDetail('Url'             , URL                              )
          .AddDetail('Metodo'          , 'POST'                           )
          .AddDetail('ConteudoEnviado' , LJSON.ToString                   )
          .AddDetail('ConteudoRecebido', LRetorno                         )
          .AddDetail('ErroCatalogado'  , AErroAPI.CodErro                 )
          .AddDetail('ExceptionMessage', E.Message                        )
          .Save;
        TLog.MyLogTemp(AErroAPI.MsgErro, nil, 0, False, TCriticalLog.tlERROR)
      end;
    end;
  finally
    FreeAndNil(LJSON);
  end;
end;

initialization

end.
