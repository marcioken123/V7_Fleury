unit APIs.Einstein.ConsultarPaciente;

interface

uses
  APIs.Common, LogSQLite;

type
	TTipoPesquisa = (tpNumCPF, tpNumPassaporte, tpNumProntuario,tpIdTabela);
	TParametrosEntradaAPI = record
                         TipoCampoPesquisa : TTipoPesquisa;
                         ValorCampoPesquisa: string; //"Entrega"  "Retirada"
                         Token: string;

end;
procedure PopularParametros;
function Execute(const AParametrosEntrada: TParametrosEntradaAPI; out AParametrosSaida: string; out AErroApi : TErroApi) : TTipoRetornoAPI;

implementation

uses
{$IFDEF CompilarPara_TotemAA}
  controller.parametros,
{$ENDIF}
  ASPHTTPRequest,IniFiles, System.SysUtils, System.Json, untLog;

var
  URL : string;

procedure PopularParametros;
begin
{$IFDEF CompilarPara_TotemAA}
  URL := controller.parametros.CarregarParametroStr('APIs.Einstein', 'URL_ConsultarPaciente', 'http://10.33.1.223:20021/servico/siaf/consultarpaciente');
{$ENDIF}
end;

function Execute(const AParametrosEntrada: TParametrosEntradaAPI; out AParametrosSaida: string; out AErroApi : TErroApi) : TTipoRetornoAPI;
var
  LJSON: TJSONObject;
  LRetorno      : string;
  LJSONResposta : TJSONObject;
  LCustomHeader: TCustomHeader;
begin
  LJSON := TJSONObject.Create;
  try
    try
      case AParametrosEntrada.TipoCampoPesquisa of
        tpNumCPF:         LJSON.AddPair('NumCPF'           , AParametrosEntrada.ValorCampoPesquisa);
        tpNumPassaporte:  LJSON.AddPair('NumPassaporte'    , AParametrosEntrada.ValorCampoPesquisa);
        tpNumProntuario:  LJSON.AddPair('NumProntuario'    , AParametrosEntrada.ValorCampoPesquisa);
        tpIdTabela:       LJSON.AddPair('IdTabela'         , AParametrosEntrada.ValorCampoPesquisa);
      end;
      if AParametrosEntrada.Token <> EmptyStr then
      begin
        LCustomHeader.Nome := 'Token';
        LCustomHeader.Valor :=  AParametrosEntrada.Token;
        Result := IntegracaoAPI_Post (URL, LJSON, LRetorno, AErroAPI, 3 , LCustomHeader);
      end
      else
      begin
        Result := IntegracaoAPI_Post (URL, LJSON, LRetorno, AErroAPI, 3);
      end;
      if Result = raOK then
      begin
        LJSONResposta := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(LRetorno), 0) as TJSONObject;
        try
          if (LJSONResposta <> nil) and (LJSONResposta.Values['Objeto'] <> nil) then
          begin
            AParametrosSaida := LRetorno;

            AErroApi.CodErro := 0;
            AErroApi.MsgErro := '';

            Result := raOK;
          end
          else
          begin
            Result := raErroNegocio;

            AErroApi.CodErro := -1;
            AErroApi.MsgErro := 'Erro no evento APIs.Einstein.ConsultarPaciente.Execute. ' +
                                'URL: "' + URL + '" / ' +
                                'Enviado: "' + LJSON.ToJSON + '" / ' +
                                'Recebido: "' + LRetorno + '"';

            TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
              .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroNegocio]               )
              .AddDetail('Evento'          , 'APIs.Einstein.ConsultarPaciente.Execute')
              .AddDetail('Url'             , URL                                               )
              .AddDetail('Metodo'          , 'POST'                                            )
              .AddDetail('ConteudoEnviado' , LJson.ToString                                    )
              .AddDetail('ConteudoRecebido', LRetorno                                          )
              .AddDetail('ErroCatalogado'  , AErroApi.CodErro                                  )
              .Save;
            TLog.MyLogTemp(AErroApi.MsgErro, nil, 0, False, TCriticalLog.tlERROR);
          end;
        finally
          LJSONResposta.Free;
        end;
      end;
    except
      on E: Exception do
      begin
        Result := raException;
        AErroApi.CodErro := -1;
        AErroApi.MsgErro := 'Erro no evento APIs.Einstein.ConsultarPaciente.Execute. ' +
                            'URL: "' + URL + '" / ' +
                            'Enviado: "' + LJSON.ToJSON + '" / ' +
                            'Recebido: "' + LRetorno + '"';

        TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
          .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroNegocio]               )
          .AddDetail('Evento'          , 'APIs.Einstein.ConsultarPaciente.Execute')
          .AddDetail('Url'             , URL                                               )
          .AddDetail('Metodo'          , 'POST'                                            )
          .AddDetail('ConteudoEnviado' , LJson.ToString                                    )
          .AddDetail('ConteudoRecebido', LRetorno                                          )
          .AddDetail('ErroCatalogado'  , AErroApi.CodErro                                  )
          .Save;
        TLog.MyLogTemp(AErroApi.MsgErro, nil, 0, False, TCriticalLog.tlERROR);
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
    URL := ReadString ('APIs.Einstein.ConsultarPaciente', 'URL', 'http://10.33.1.223:20021/servico/siaf/consultarpaciente');
    WriteString ('APIs.Einstein.ConsultarPaciente', 'URL', URL);
  finally
    Free;
  end;
{$ENDIF}
end.
