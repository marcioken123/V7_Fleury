unit APIs.Aspect.Sics.MarcarTag;

interface

uses
  APIs.Common, LogSQLite;

type
  TAPIAspectSicsMarcarTag = class
  private
  public
    type
      TParametrosEntradaAPI = record
        Senha: Integer;
        IDTag: Integer;
        IdUnidade: string;
      end;
    class var URL: string;
    class function Execute(const AParametrosEntrada: TParametrosEntradaAPI; out AErroAPI: TErroAPI): TTipoRetornoAPI;
  end;
  procedure PopularParametros;
implementation

uses
  IniFiles, System.SysUtils, System.JSON, ufrmSicsTotemAA, untLog, controller.parametros;

procedure PopularParametros;
begin
  TAPIAspectSicsMarcarTag.URL := controller.parametros.CarregarParametroStr('APIs.Aspect.Sics', 'URL_MarcarTag', 'http://10.32.10.21:80/aspect/rest/senha/marcarTags');
end;

{ TAPIAspectSicsMarcarTag }

class function TAPIAspectSicsMarcarTag.Execute(const AParametrosEntrada: TParametrosEntradaAPI; out AErroAPI: TErroAPI): TTipoRetornoAPI;
var
  LJSON: TJSONObject;
  LRetorno: string;
begin
  TLogSQLite.New(tmInfo, clResponse, 'Consumindo API MarcarTag').Save;
  TLog.MyLogTemp('Consumindo API MarcarTag', nil, 0, False, TCriticalLog.tlINFO);
  LJSON := TJSONObject.Create;
  try
    try
      LJSON.AddPair('Senha', AParametrosEntrada.Senha.ToString);
      LJSON.AddPair('IdTAG', AParametrosEntrada.IDTag.ToString);
      LJson.AddPair('Marcar', 'True');
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
    TAPIAspectSicsMarcarTag.URL := ReadString('APIs.Aspect.Sics.MarcarTag', 'URL', 'http://10.32.10.21:80/aspect/rest/senha/marcarTags');
    WriteString('APIs.Aspect.Sics.MarcarTag', 'URL', TAPIAspectSicsMarcarTag.URL);
  finally
    Free;
  end;
{$ENDIF}
end.