unit APIs.Aspect.Sics.SeguirAtendimento;

interface

uses
  APIs.Common, LogSQLite;

type
  TParametrosEntradaAPI = record
    Prontuario: string;
    CodPA: integer;
    MotivoPausa: integer;
    Unidade: integer;
    Senha: integer;
  end;

  TParametrosSaidaAPI = record
    Sucesso: Boolean;
    Motivo: string;
  end;

  TAPIAspectSicsSeguirAtendimento = class
  private
  public
    class var URL: string;
    class function Execute(const AParametrosEntrada: TParametrosEntradaAPI; out AParametrosSaida: TParametrosSaidaAPI; out AErroAPI: TErroAPI): TTipoRetornoAPI;
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
  TAPIAspectSicsSeguirAtendimento.URL := controller.parametros.CarregarParametroStr('APIs.Aspect.Sics', 'URL_SeguirAtendimento', 'http://localhost/aspect/backend/SeguirAtendimento');
{$ENDIF CompilarPara_TotemAA}
end;

class function TAPIAspectSicsSeguirAtendimento.Execute(const AParametrosEntrada: TParametrosEntradaAPI; out AParametrosSaida: TParametrosSaidaAPI; out AErroAPI: TErroAPI): TTipoRetornoAPI;
var
  LJSON: TJSONObject;
  LRetorno: string;
  LJSONResposta: TJSONObject;
begin
  TLogSQLite.New(tmInfo, clResponse, 'Consumindo API SeguirAtendimento').Save;
  TLog.MyLogTemp('Consumindo API SeguirAtendimento', nil, 0, False, TCriticalLog.tlINFO);
  LJSON := TJSONObject.Create;

  try
    try
      LJSON.AddPair('Prontuario', AParametrosEntrada.Prontuario);
      LJSON.AddPair('PA', AParametrosEntrada.CodPA.ToString);
      LJSON.AddPair('MotivoPausa', AParametrosEntrada.MotivoPausa.ToString);
      LJSON.AddPair('IdUnidade', AParametrosEntrada.Unidade.ToString);
      LJSON.AddPair('Senha', AParametrosEntrada.Senha.ToString);

      Result := IntegracaoAPI_Post(URL, LJSON, LRetorno, AErroAPI, 1);

      if Result = raOK then
      begin
        LJSONResposta := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(LRetorno), 0) as TJSONObject;
        try
          if (LJSONResposta <> nil) then
          begin
            AErroAPI.CodErro := 0;
            AErroAPI.MsgErro := '';

            LJSONResposta.TryGetValue('sucesso', AParametrosSaida.Sucesso);
            LJSONResposta.TryGetValue('motivo', AParametrosSaida.Motivo);

            if Trim(AParametrosSaida.Motivo)<>'' then
              Result := raErroNegocio
            else
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
        AParametrosSaida.Sucesso := False;
        AParametrosSaida.Motivo := E.Message;

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
        TLog.MyLogTemp(AErroAPI.MsgErro, nil, 0, False, TCriticalLog.tlERROR);

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
    TAPIAspectSicsSeguirAtendimento.URL := ReadString('APIs.Aspect.Sics.SeguirAtendimento', 'URL', '');
    WriteString('APIs.Aspect.Sics.SeguirAtendimento', 'URL', TAPIAspectSicsSeguirAtendimento.URL);
  finally
    Free;
  end;
{$ENDIF}
end.
