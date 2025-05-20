unit APIs.Aspect.Sics.GerarSenha;

interface

uses
  APIs.Common, LogSQLite;

type
  TAPIAspectSicsGerarSenha = class
  private
  public
    type
      TParametrosEntradaAPI = record
        Fila: Integer;
        IdUnidade: string;
      end;
      TParametrosSaidaAPI = record
        Senha: string;
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
  TAPIAspectSicsGerarSenha.URL := controller.parametros.CarregarParametroStr('APIs.Aspect.Sics', 'URL_GerarSenha', 'http://10.32.10.21:80/aspect/rest/senha/gerarsenha');
end;

{ TAPIAspectSicsGerarSenha }

class function TAPIAspectSicsGerarSenha.Execute(const AParametrosEntrada: TParametrosEntradaAPI; out AParametrosSaida: TParametrosSaidaAPI; out AErroAPI: TErroAPI): TTipoRetornoAPI;
var
  LJSON: TJSONObject;
  LRetorno: string;
  LJSONResposta: TJSONObject;
  LSenha: string;
begin
  TLogSQLite.New(tmInfo, clResponse, 'Consumindo API GerarSenha').Save;
  TLog.MyLogTemp('Consumindo API GerarSenha', nil, 0, False, TCriticalLog.tlINFO);
  LJSON := TJSONObject.Create;
  try
    try
      LJSON.AddPair('Fila', AParametrosEntrada.Fila.ToString);
      //EF o parâmetro 0 é para nunca imprimir a senha logo ao gerar
      LJSON.AddPair('Totem', '0');
      LJSON.AddPair('IdUnidade', AParametrosEntrada.IdUnidade);
      {EF Todas as APIs de consulta, sejam SIAF ou SCC, são 3 tentativas.
      Já as APIs de alteração/inserção SIAF é 1 tentativa.
      As APIs de alteração/inserção podem sim serem 3 tentativas.}
      Result := IntegracaoAPI_Post(URL, LJSON, LRetorno, AErroAPI, 3);

      if Result = raOK then
      begin
        LJSONResposta := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(LRetorno), 0) as TJSONObject;
        try
          if (LJSONResposta <> nil) and
             (LJSONResposta.GetValue<TJSONObject>('result') as TJSONObject).TryGetValue('senha', LSenha) and
             (LSenha <> EmptyStr) then
          begin
            AErroAPI.CodErro := 0;
            AErroAPI.MsgErro := '';

            AParametrosSaida.Senha := LSenha;

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
    TAPIAspectSicsGerarSenha.URL := ReadString('APIs.Aspect.Sics.GerarSenha', 'URL', 'http://10.32.10.21:80/aspect/rest/senha/gerarsenha');
    WriteString('APIs.Aspect.Sics.GerarSenha', 'URL', TAPIAspectSicsGerarSenha.URL);
  finally
    Free;
  end;
{$ENDIF}
end.
