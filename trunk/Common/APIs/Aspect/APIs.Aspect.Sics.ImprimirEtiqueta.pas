unit APIs.Aspect.Sics.ImprimirEtiqueta;

interface

uses
  APIs.Common, LogSQLite;

type
  TParametrosEntradaAPI = record
    IdPassagem : string;
    Device : string;
    QtdeImpressao : integer;
    Etiqueta : string;
    LocalPArRef : integer;
    IdMedico : integer;
  end;

  TAPIAspectSicsImprimirEtiqueta = class
  private
  public
    class var URL: string;
    class function Execute(const AParametrosEntrada: TParametrosEntradaAPI; out AErroAPI: TErroAPI): TTipoRetornoAPI;
  end;
  procedure PopularParametros;

implementation

uses
  IniFiles,
  System.SysUtils,
  System.JSON,
  untLog;

{ TAPIAspectSicsImprimirEtiqueta }

procedure PopularParametros;
begin
{$IFDEF CompilarPara_TotemAA}
  TAPIAspectSicsImprimirEtiqueta.URL := controller.parametros.CarregarParametroStr('APIs.Aspect.Sics', 'URL_ImprimirEtiqueta', 'http://localhost/aspect/backend/SeguirAtendimento');
{$ENDIF CompilarPara_TotemAA}
end;

class function TAPIAspectSicsImprimirEtiqueta.Execute(const AParametrosEntrada: TParametrosEntradaAPI; out AErroAPI: TErroAPI): TTipoRetornoAPI;
var
  LJSON: TJSONObject;
  LRetorno: string;
  LJSONResposta: TJSONObject;
begin
  TLogSQLite.New(tmInfo, clResponse, 'Consumindo API ImprimirEtiqueta').Save;
  TLog.MyLogTemp('Consumindo API ImprimirEtiqueta', nil, 0, False, TCriticalLog.tlINFO);
  LJSON := TJSONObject.Create;

  try
    try
      if  (AParametrosEntrada.IdPassagem = EmptyStr) or
          (AParametrosEntrada.Device = EmptyStr) or
          (AParametrosEntrada.QtdeImpressao <= 0) or
          (((AParametrosEntrada.Etiqueta = EmptyStr) or (AParametrosEntrada.Etiqueta = 'NAOLOCALIZADA')) and
          ((AParametrosEntrada.LocalPArRef <= 0)or(AParametrosEntrada.IdMedico <= 0)))
      then
      begin
        Result := raErroNegocio;
      end
      else
      begin
        LJSON := TJSONObject.Create;
        LJSON.AddPair('IdPassagem',  AParametrosEntrada.IdPassagem);
        LJSON.AddPair('Device', AParametrosEntrada.Device);
        LJSON.AddPair('QtdeImpressao', AParametrosEntrada.QtdeImpressao.ToString);
        if (AParametrosEntrada.Etiqueta <> EmptyStr) and (AParametrosEntrada.Etiqueta <> 'NAOLOCALIZADA') then
        begin
          LJSON.AddPair('Etiqueta', AParametrosEntrada.Etiqueta);
        end
        else
        begin
          LJSON.AddPair('IdLocal', AParametrosEntrada.LocalPArRef.ToString);
          LJSON.AddPair('IdMedico', AParametrosEntrada.IdMedico.ToString);
        end;

        Result := IntegracaoAPI_Post(TAPIAspectSicsImprimirEtiqueta.URL, LJSON, LRetorno, AErroAPI,3);
      end;

      if Result = raOK then
      begin
        LJSONResposta := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(LRetorno), 0) as TJSONObject;
        try
          if (LJSONResposta <> nil) then
          begin
            AErroAPI.CodErro := 0;
            AErroAPI.MsgErro := '';

            //LJSONResposta.TryGetValue('sucesso', AParametrosSaida.Sucesso);
            //LJSONResposta.TryGetValue('motivo', AParametrosSaida.Motivo);
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
        //AParametrosSaida.Sucesso := False;
        //AParametrosSaida.Motivo := E.Message;

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
    TAPIAspectSicsImprimirEtiqueta.URL := ReadString('APIs.Aspect.Sics.ImprimirEtiqueta', 'URL', '');
    WriteString('APIs.Aspect.Sics.ImprimirEtiqueta', 'URL', TAPIAspectSicsImprimirEtiqueta.URL);
  finally
    Free;
  end;
{$ENDIF}
end.
