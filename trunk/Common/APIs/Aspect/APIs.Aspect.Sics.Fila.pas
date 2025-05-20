unit APIs.Aspect.Sics.Fila;

interface

uses
  APIs.Common, LogSQLite;

type
  TParametrosEntradaListarPorPAAPI = record
    IDPa: Integer;
    IdUnidade: string;
  end;
type
  TParametrosSaidaListarPorPAAPI = record
    Nome: string;
  end;

type
  TAPIAspectSicsFila = class

  private
  public
    class var URL: string;
  end;
  function ListarPorPA(const AParametrosEntrada: TParametrosEntradaListarPorPAAPI; out AParametrosSaida: TParametrosSaidaListarPorPAAPI; out AErroAPI: TErroAPI): TTipoRetornoAPI;
  procedure PopularParametros;

implementation

uses
  IniFiles, System.SysUtils, System.JSON, ufrmSicsTotemAA, untLog, controller.parametros;

procedure PopularParametros;
begin
  TAPIAspectSicsFila.URL := controller.parametros.CarregarParametroStr('APIs.Aspect.Sics', 'URL_Fila', 'http://10.32.10.21:80/aspect/rest/Fila/');
end;

{ TAPIAspectSicsGerarSenha }

function ListarPorPA(const AParametrosEntrada: TParametrosEntradaListarPorPAAPI; out AParametrosSaida: TParametrosSaidaListarPorPAAPI; out AErroAPI: TErroAPI): TTipoRetornoAPI;
var
  LJSON: TJSONObject;
  LUrl_Fila_ListarPorPA: string;
  LRetorno: string;
  LJSONResposta: TJSONObject;
  LArrayObjeto: TJSONArray;
  LNome: String;
  LIDPA: String;
  LCount: integer;
begin
  TLogSQLite.New(tmInfo, clResponse, 'Consumindo API Fila').Save;
  TLog.MyLogTemp('Consumindo API Fila', nil, 0, False, TCriticalLog.tlINFO);
  try
    try
      LUrl_Fila_ListarPorPA := TAPIAspectSicsFila.URL + 'ListarPorPA/' + inttostr(AParametrosEntrada.IDPa)+ '/' + AParametrosEntrada.IdUnidade;
      Result := IntegracaoAPI_Get(LUrl_Fila_ListarPorPA, LRetorno, AErroAPI);

      if Result = raOK then
      begin
        LJSONResposta := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(LRetorno), 0) as TJSONObject;
        try
          if LJSONResposta.Values['result'] <> nil then
          begin
            LJSONResposta := LJSONResposta.GetValue<TJSONObject>('result') as TJSONObject;
            if LJSONResposta.TryGetValue('Itens', LArrayObjeto) then
            begin
              for LCount := 0 to Pred(LArrayObjeto.Count) do
              begin
                LJSONResposta := (LArrayObjeto.Items[LCount] as TJSONObject);
                LNome := EmptyStr;
                LIDPA := EmptyStr;
                LJSONResposta.TryGetValue('Nome', LNome);
                LJSONResposta.TryGetValue('ID', LIDPA);
                if strtointdef(LIDPA,0) =  AParametrosEntrada.IDPa then
                begin
                  AParametrosSaida.Nome := LNome
                end;
              end;
            end;
          end
          else
          begin
            Result := raErroNegocio;

            AErroAPI.CodErro := -1;
            AErroAPI.MsgErro := 'Erro no evento "' + TAPIAspectSicsFila.ClassName + '.Execute" / ' +
                                'URL: "' + LUrl_Fila_ListarPorPA + '" / ' +
                                'Enviado: "' + LJSON.ToJSON + '" / ' +
                                'Recebido: "' + LRetorno + '"';

            TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
              .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroNegocio])
              .AddDetail('Evento'          , TAPIAspectSicsFila.ClassName                     )
              .AddDetail('Url'             , LUrl_Fila_ListarPorPA              )
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
        AErroAPI.MsgErro := 'Exception no evento "' + TAPIAspectSicsFila.ClassName + '.Execute" / ' +
                            'URL: "' + LUrl_Fila_ListarPorPA + '" / ' +
                            'Enviado: "' + LJSON.ToJSON + '" / ' +
                            'Recebido: "' + LRetorno + '" / ' +
                            'Erro: "' + E.Message + '"';

        TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
          .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raException])
          .AddDetail('Evento'          , TAPIAspectSicsFila.ClassName                   )
          .AddDetail('Url'             , LUrl_Fila_ListarPorPA            )
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
    TAPIAspectSicsFila.URL := ReadString('APIs.Aspect.Sics.Fila', 'URL', 'http://10.32.10.21:80/aspect/rest/Fila/');
    WriteString('APIs.Aspect.Sics.Fila', 'URL', TAPIAspectSicsFila.URL);
  finally
    Free;
  end;
{$ENDIF}
end.
