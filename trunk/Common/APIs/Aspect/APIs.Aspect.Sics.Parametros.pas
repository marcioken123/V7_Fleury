unit APIs.Aspect.Sics.Parametros;

interface

uses
  APIs.Common, LogSQLite;

type
  TAPIAspectSicsParametros = class
  private
  public
    type
	  TParametrosEntradaAPI = record
        IDTotem: Integer;
        URL_BuscarParametros: String;
      end;

	  TParametroSaida = record
        GRUPO: string;
        CHAVE: string;
        VALOR: string;
      end;

	  TParametrosSaidaAPI = record
        nometotem:string;
        enderecoip:string;
        idunidade:string;
        nomeunidade:string;
        Parametros : Array of TParametroSaida;
      end;
    class function Execute(const AParametrosEntradaAPI: TParametrosEntradaAPI; out AParametrosSaida: TParametrosSaidaAPI; out AErroAPI: TErroAPI): TTipoRetornoAPI;
  end;

implementation

uses
  IniFiles, System.SysUtils, System.JSON, untLog;

{ TAPIAspectSicsParametros }

class function TAPIAspectSicsParametros.Execute(const AParametrosEntradaAPI: TParametrosEntradaAPI; out AParametrosSaida: TParametrosSaidaAPI; out AErroAPI: TErroAPI): TTipoRetornoAPI;
var
  LUrl_SCC_Parametros:String;
  LJSON, LJSONItens, LJSONItensGrupos, LJSONItensParams: TJSONObject;
  LRetorno: string;
  LJSONArrayConfiguracoes, LJSONArrayDados: TJSONArray;
  LCountGrupos, LCountDados: integer;
  Lnometotem:string;
  Lenderecoip:string;
  Lidunidade:string;
  Lnomeunidade:string;
  LGrupo: string;
  LChave: string;
  LValor: string;
begin
  TLogSQLite.New(tmInfo, clResponse, 'Consumindo API BuscarParametros').Save;
  TLog.MyLogTemp('Consumindo API BuscarParametros', nil, 0, False, TCriticalLog.tlINFO);
  LUrl_SCC_Parametros := AParametrosEntradaAPI.URL_BuscarParametros + '/' + AParametrosEntradaAPI.IDTotem.ToString;
  try
    Result := IntegracaoAPI_Get(LUrl_SCC_Parametros, LRetorno, AErroAPI);
    if Result = raOK then
    begin
      LJSON := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(LRetorno), 0) as TJSONObject;
      try
        if LJSON.TryGetValue('result', LJSONItens) then
        begin
          LJSONItens.TryGetValue('nomeTotem', Lnometotem);
          LJSONItens.TryGetValue('enderecoIP', Lenderecoip);
          LJSONItens.TryGetValue('idUnidade', Lidunidade);
          LJSONItens.TryGetValue('nomeUnidade', Lnomeunidade);
          AParametrosSaida.nometotem:= Lnometotem;
          AParametrosSaida.enderecoip:= Lenderecoip;
          AParametrosSaida.idunidade:= Lidunidade;
          AParametrosSaida.nomeunidade:= Lnomeunidade;
          if LJSONItens.TryGetValue('configuracoes', LJSONArrayConfiguracoes) then
          begin
            for LCountGrupos := 0 to Pred(LJSONArrayConfiguracoes.Count) do
            begin
              LJSONItensGrupos := (LJSONArrayConfiguracoes.Items[LCountGrupos] as TJSONObject);
              LJSONItensGrupos.TryGetValue('grupo', LGRUPO);
              if LJSONItensGrupos.TryGetValue('parametros', LJSONArrayDados) then
              begin
                for LCountDados := 0 to Pred(LJSONArrayDados.Count) do
                begin
                  LJSONItensParams := (LJSONArrayDados.Items[LCountDados] as TJSONObject);
                  LJSONItensParams.TryGetValue('chave', LCHAVE);
                  LJSONItensParams.TryGetValue('valor', LVALOR);
                  setlength(AParametrosSaida.Parametros,length(AParametrosSaida.Parametros)+1);
                  AParametrosSaida.Parametros[length(AParametrosSaida.Parametros)-1].GRUPO := LGRUPO;
                  AParametrosSaida.Parametros[length(AParametrosSaida.Parametros)-1].CHAVE := LCHAVE;
                  AParametrosSaida.Parametros[length(AParametrosSaida.Parametros)-1].VALOR := LVALOR;
                end;
              end;
            end;
          end;
          Result := raOK;
        end
        else
        begin
          Result := raErroNegocio;
        end;
      finally
        LJSON.Free;
      end;
    end
    else if Result = raErroNegocio then
    begin
      AErroAPI.CodErro := -1;
      AErroAPI.MsgErro := 'Erro no evento "' + TAPIAspectSicsParametros.ClassName + '.Execute" / ' +
                          'URL: "' + LUrl_SCC_Parametros + '" / ' +
                          'Enviado: "' + LJSON.ToJSON + '" / ' +
                          'Recebido: "' + LRetorno + '"';

      TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
        .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroNegocio])
        .AddDetail('Evento'          , TAPIAspectSicsParametros.ClassName )
        .AddDetail('Url'             , LUrl_SCC_Parametros                )
        .AddDetail('Metodo'          , 'POST'                             )
        .AddDetail('ConteudoEnviado' , LJSON.ToString                     )
        .AddDetail('ConteudoRecebido', LRetorno                           )
        .AddDetail('ErroCatalogado'  , AErroAPI.CodErro                   )
        .Save;
      TLog.MyLogTemp(AErroAPI.MsgErro, nil, 0, False, TCriticalLog.tlERROR);
    end;
  except on e:exception do
    begin
        Result := raException;
        AErroAPI.CodErro := -1;
        AErroAPI.MsgErro := 'Exception no evento "' + TAPIAspectSicsParametros.ClassName + '.Execute" / ' +
                            'URL: "' + LUrl_SCC_Parametros + '" / ' +
                            'Enviado: "' + LJSON.ToJSON + '" / ' +
                            'Recebido: "' + LRetorno + '" / ' +
                            'Erro: "' + E.Message + '"';

        TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
          .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raException])
          .AddDetail('Evento'          , TAPIAspectSicsParametros.ClassName )
          .AddDetail('Url'             , LUrl_SCC_Parametros                )
          .AddDetail('Metodo'          , 'Get'                              )
          .AddDetail('ConteudoEnviado' , LJSON.ToString                     )
          .AddDetail('ConteudoRecebido', LRetorno                           )
          .AddDetail('ErroCatalogado'  , AErroAPI.CodErro                   )
          .AddDetail('ExceptionMessage', E.Message                          )
          .Save;
        TLog.MyLogTemp(AErroAPI.MsgErro, nil, 0, False, TCriticalLog.tlERROR);
    end;
  end;
end;

initialization

end.