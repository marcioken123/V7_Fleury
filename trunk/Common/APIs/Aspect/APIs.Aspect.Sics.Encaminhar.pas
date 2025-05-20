unit APIs.Aspect.Sics.Encaminhar;

interface

uses
  APIs.Common, LogSQLite;

  type
    TParametrosEntradaAPI = record
      IdPA: Integer;
      Fila: Integer;
      IdUnidade: string;
    end;

  TAPIAspectSicsEncaminhar = class
  private
  public
    class var URL: string;
    class function Execute(const AParametrosEntrada: TParametrosEntradaAPI; out AErroAPI: TErroAPI): TTipoRetornoAPI;
  end;

procedure PopularParametros;

implementation

uses
  IniFiles, System.SysUtils, System.JSON, untLog;

procedure PopularParametros;
begin
{$IFDEF CompilarPara_TotemAA}
  TAPIAspectSicsEncaminhar.URL := controller.parametros.CarregarParametroStr('APIs.Aspect.Sics', 'URL_Encaminhar', 'http://10.32.10.21:80/aspect/rest/Senha/Encaminhar');
{$ENDIF CompilarPara_TotemAA}
end;

{ TAPIAspectSicsEncaminharSenha }

class function TAPIAspectSicsEncaminhar.Execute(const AParametrosEntrada: TParametrosEntradaAPI; out AErroAPI: TErroAPI): TTipoRetornoAPI;
var
  LJSON: TJSONObject;
  LRetorno: string;
begin
  TLogSQLite.New(tmInfo, clResponse, 'Consumindo API Encaminhar').Save;
  TLog.MyLogTemp('Consumindo API Encaminhar', nil, 0, False, TCriticalLog.tlINFO);
  LJSON := TJSONObject.Create;
  try
    try
      LJSON.AddPair('PA', AParametrosEntrada.IdPA.ToString);
      LJSON.AddPair('Fila', AParametrosEntrada.Fila.ToString);
      LJSON.AddPair('IdUnidade', AParametrosEntrada.IdUnidade);
      Result := IntegracaoAPI_Post(URL, LJSON, LRetorno, AErroAPI, 3);

      if Result = raOK then
      begin
        AErroAPI.CodErro := 0;
        AErroAPI.MsgErro := '';

        if Pos('"sucesso":true', LRetorno) = 0 then Result := raErroNegocio;
      end;
      if Result = raErroNegocio then
      begin
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
    TAPIAspectSicsEncaminhar.URL := ReadString('APIs.Aspect.Sics.Encaminhar', 'URL', 'http://10.32.10.21:80/aspect/rest/Senha/Encaminhar');
    WriteString('APIs.Aspect.Sics.Encaminhar', 'URL', TAPIAspectSicsEncaminhar.URL);
  finally
    Free;
  end;
{$ENDIF}
end.