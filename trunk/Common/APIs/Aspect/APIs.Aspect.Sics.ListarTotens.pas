unit APIs.Aspect.Sics.ListarTotens;

interface

uses
  APIs.Common, LogSQLite;

type
  TAPIAspectSicsListarTotens = class
  private
  public
    type
      TTotem =   record
        ID: integer;
        NOME: string;
      end;
    type
      TParametrosEntradaAPI = record
        IdUnidade: integer;
      end;
      TParametrosSaidaAPI = record
        Totens: array of TTotem;
      end;
    class var URL: string;
    class function Execute(const AParametrosEntrada: TParametrosEntradaAPI;out AParametrosSaida: TParametrosSaidaAPI; out AErroAPI: TErroAPI): TTipoRetornoAPI;
  end;
  procedure PopularParametros;
implementation

uses
  IniFiles, System.SysUtils, System.JSON, ufrmSicsTotemAA, untLog, controller.parametros;

procedure PopularParametros;
begin
    TAPIAspectSicsListarTotens.URL := controller.parametros.CarregarParametroStr('APIs.Aspect.Sics', 'URL_ListarTotens', 'http://10.32.10.21:80/aspect/rest/totem/ListarTodos');
end;

{ TAPIAspectSicsListarTotens }

class function TAPIAspectSicsListarTotens.Execute(const AParametrosEntrada: TParametrosEntradaAPI;out AParametrosSaida: TParametrosSaidaAPI; out AErroAPI: TErroAPI): TTipoRetornoAPI;
var
  LJSON,LJSONItens: TJSONObject;
  LJSONArray: TJSONArray;
  LCount:integer;
  LRetorno: string;
  LNomeTotem:string;
  LIdTotem:integer;
  LURLListarTodos:string;
begin
  TLogSQLite.New(tmInfo, clResponse, 'Consumindo API ListarTotens').Save;
  TLog.MyLogTemp('Consumindo API ListarTotens', nil, 0, False, TCriticalLog.tlINFO);
  LJSON := TJSONObject.Create;
  try
    try
      LURLListarTodos := URL  + '/' + AParametrosEntrada.IdUnidade.ToString;
      Result := IntegracaoAPI_Get(LURLListarTodos,LRetorno, AErroAPI);
      if Result = raOK then
      begin
        LJSON := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(LRetorno), 0) as TJSONObject;
        if LJSON.Values['result'] <> nil then
        begin
          if LJSON.TryGetValue('result', LJSONItens) then begin
            if LJSONItens.TryGetValue('Itens', LJSONArray) then begin
              for LCount := 0 to Pred(LJSONArray.Count) do begin
                LJSON := (LJSONArray.Items[LCount] as TJSONObject);
                LJSON.TryGetValue('Nome', LNomeTotem);
                LJSON.TryGetValue('ID', LIdTotem);
                setlength(AParametrosSaida.Totens,length(AParametrosSaida.Totens)+1);
                AParametrosSaida.Totens[length(AParametrosSaida.Totens)-1].ID := LIdTotem;
                AParametrosSaida.Totens[length(AParametrosSaida.Totens)-1].NOME := LNomeTotem;
              end;
            end;
          end;
          Result := raOK;
        end
        else
        begin
          Result := raErroNegocio;
        end;
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
    TAPIAspectSicsListarTotens.URL := ReadString('APIs.Aspect.Sics.ListarTotens', 'URL', 'http://10.32.10.21:80/aspect/rest/totem/ListarTodos');
    WriteString('APIs.Aspect.Sics.ListarTotens', 'URL', TAPIAspectSicsListarTotens.URL);
  finally
    Free;
  end;
{$ENDIF}
end.