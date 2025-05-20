unit APIs.Aspect.Sics.ReimprimirSenha;

interface

uses
  APIs.Common, LogSQLite;

type
  TAPIAspectSicsReimprimirSenha = class
  private
  public
    type
      TParametrosEntradaAPI = record
        Senha: Integer;
        Totem: Integer;
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
  TAPIAspectSicsReimprimirSenha.URL := controller.parametros.CarregarParametroStr('APIs.Aspect.Sics', 'URL_ReimprimirSenha', 'http://10.32.10.21:80/aspect/rest/senha/ReimprimirSenha');
end;

{ TAPIAspectSicsReimprimirSenha }

class function TAPIAspectSicsReimprimirSenha.Execute(const AParametrosEntrada: TParametrosEntradaAPI; out AErroAPI: TErroAPI): TTipoRetornoAPI;
var
  LJSON: TJSONObject;
  LRetorno: string;
begin
  TLogSQLite.New(tmInfo, clResponse, 'Consumindo API ReimprimirSenha').Save;
  TLog.MyLogTemp('Consumindo API ReimprimirSenha', nil, 0, False, TCriticalLog.tlINFO);
  LJSON := TJSONObject.Create;
  try
    try
      LJSON.AddPair('Senha', AParametrosEntrada.Senha.ToString);
      LJSON.AddPair('Totem', AParametrosEntrada.Totem.ToString);
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
    TAPIAspectSicsReimprimirSenha.URL := ReadString('APIs.Aspect.Sics.ReimprimirSenha', 'URL', 'http://10.32.10.21:80/aspect/rest/senha/ReimprimirSenha');
    WriteString('APIs.Aspect.Sics.ReimprimirSenha', 'URL', TAPIAspectSicsReimprimirSenha.URL);
  finally
    Free;
  end;
{$ENDIF}
end.