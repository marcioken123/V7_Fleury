unit APIs.Aspect.Sics.ChamarEspecifica;

interface

uses
  APIs.Common, LogSQLite;

type
  TAPIAspectSicsChamarEspecifica = class
  private
  public
    type
      TParametrosEntradaAPI = record
                                PA: Integer;
                                Senha: Integer;
                                IdUnidade:Integer;
                              end;
      TParametrosSaidaAPI = record
                              Sucesso: Boolean;
                              Motivo: String;
                            end;
    class var URL: string;
    class function Execute(const AParametrosEntrada: TParametrosEntradaAPI; out AParametrosSaida: TParametrosSaidaAPI; out AErroAPI: TErroAPI): TTipoRetornoAPI;
  end;
  procedure PopularParametros;

implementation

uses
  IniFiles, System.SysUtils, System.JSON, ufrmSicsTotemAA, untLog, controller.parametros;

procedure PopularParametros;
begin
  TAPIAspectSicsChamarEspecifica.URL := controller.parametros.CarregarParametroStr('APIs.Aspect.Sics', 'URL_ChamarEspecifica', 'http://10.32.10.21:80/aspect/rest/senha/ChamarEspecifica');
end;

{ TAPIAspectSicsChamarEspecifica }

class function TAPIAspectSicsChamarEspecifica.Execute(const AParametrosEntrada: TParametrosEntradaAPI; out AParametrosSaida: TParametrosSaidaAPI; out AErroAPI: TErroAPI): TTipoRetornoAPI;
var
  LJSON: TJSONObject;
  LRetorno: string;
  LJSONResposta: TJSONObject;
  LSucesso: boolean;
  LMotivo: string;
begin
  TLogSQLite.New(tmInfo, clResponse, 'Consumindo API ChamarEspecifica').Save;
  TLog.MyLogTemp('Consumindo API ChamarEspecifica', nil, 0, False, TCriticalLog.tlINFO);
  LJSON := TJSONObject.Create;
  try
    try
      LJSON.AddPair('PA', AParametrosEntrada.PA.ToString);
      LJSON.AddPair('Senha', AParametrosEntrada.Senha.ToString);
	    LJSON.AddPair('IdUnidade', AParametrosEntrada.IdUnidade.ToString);
      Result := IntegracaoAPI_Post(URL, LJSON, LRetorno, AErroAPI, 3);

      if Result = raOK then
      begin
        LJSONResposta := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(LRetorno), 0) as TJSONObject;
        try
          if LJSONResposta <> nil then
          begin
            LJSONResposta.TryGetValue('sucesso', LSucesso);
            LJSONResposta.TryGetValue('motivo', LMotivo);
            AErroAPI.CodErro := 0;
            AErroAPI.MsgErro := '';

            AParametrosSaida.Sucesso := LSucesso;
            AParametrosSaida.Motivo := LMotivo;

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
{$IFNDEF CompilarPara_TotemAA}
  with TIniFile.Create(IncludeTrailingPathDelimiter(System.SysUtils.GetCurrentDir) + StringReplace(ExtractFileName(ParamStr(0)), '.exe', '.ini', [rfReplaceAll])) do
  try
    TAPIAspectSicsChamarEspecifica.URL := ReadString('APIs.Aspect.Sics.ChamarEspecifica', 'URL', 'http://10.32.10.21:80/aspect/rest/senha/ChamarEspecifica');
    WriteString('APIs.Aspect.Sics.ChamarEspecifica', 'URL', TAPIAspectSicsChamarEspecifica.URL);
  finally
    Free;
  end;
{$ENDIF}
end.
