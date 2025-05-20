unit APIs.Aspect.Sics.PA;

interface

uses
  APIs.Common, LogSQLite;
type
  TGruposListar = record
                    ID : Integer;
                    NOME: string;
                  end;
type
  TPAsListar  = record
                  ID : Integer;
                  Nome: string;
                  GrupoId : Integer;
                  Status: string;
                end;
type
  TGrupos = record
              ID : Integer;
              NOME: string;
            end;
type
  TParametrosEntradaListarAPI = record
                                  IdUnidade: string;
                                end;
type
  TParametrosSaidaListarAPI = record
                                Grupos: Array of TGruposListar;
                                PAs: Array of TPAsListar;
                              end;
type
  TAPIAspectSicsPA = class
  private
  public
    class var URL: string;
  end;
  function Listar(const AParametrosEntrada: TParametrosEntradaListarAPI; out AParametrosSaida: TParametrosSaidaListarAPI; out AErroAPI: TErroAPI): TTipoRetornoAPI;
  procedure PopularParametros;
implementation

uses
  IniFiles, System.SysUtils, System.JSON, ufrmSicsTotemAA, untLog, controller.parametros;

procedure PopularParametros;
begin
  TAPIAspectSicsPA.URL := controller.parametros.CarregarParametroStr('APIs.Aspect.Sics', 'URL_PA', 'http://10.32.10.21:80/aspect/rest/PA/');
end;

function Listar(const AParametrosEntrada: TParametrosEntradaListarAPI; out AParametrosSaida: TParametrosSaidaListarAPI; out AErroAPI: TErroAPI): TTipoRetornoAPI;
var
  LUrlListar : String;
  LRetorno: string;
  LJSONResposta: TJSONObject;
  LJSONRespostaGrupos: TJSONObject;
  LJSONRespostaPAs: TJSONObject;
  LArrayObjeto: TJSONArray;
  LGrupoNome: String;
  LGrupoID: String;
  LPAID : Integer;
  LPANome: string;
  LPAGrupoId : Integer;
  LPAStatus: string;
  LCount: integer;
begin
  TLogSQLite.New(tmInfo, clResponse, 'Consumindo API PA').Save;
  TLog.MyLogTemp('Consumindo API PA', nil, 0, False, TCriticalLog.tlINFO);
  try
    try
      LUrlListar := TAPIAspectSicsPA.URL + 'Listar/' + AParametrosEntrada.IdUnidade + '/';
      Result := IntegracaoAPI_Get(LUrlListar, LRetorno, AErroAPI);

      if Result = raOK then
      begin
        LJSONResposta := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(LRetorno), 0) as TJSONObject;
        try
          if LJSONResposta.Values['result'] <> nil then
          begin
            LJSONResposta := LJSONResposta.GetValue<TJSONObject>('result') as TJSONObject;

            if LJSONResposta.Values['Grupos'] <> nil then
            begin
              LJSONRespostaGrupos := LJSONResposta.GetValue<TJSONObject>('Grupos') as TJSONObject;
              if LJSONRespostaGrupos.Values['Itens'] <> nil then
              begin
                if LJSONRespostaGrupos.TryGetValue('Itens', LArrayObjeto) then
                begin
                  for LCount := 0 to Pred(LArrayObjeto.Count) do
                  begin
                    LJSONRespostaGrupos := (LArrayObjeto.Items[LCount] as TJSONObject);
                    LGrupoNome := EmptyStr;
                    LGrupoID := EmptyStr;
                    LJSONRespostaGrupos.TryGetValue('Nome', LGrupoNome);
                    LJSONRespostaGrupos.TryGetValue('ID', LGrupoID);
                    setlength(AParametrosSaida.Grupos, Length(AParametrosSaida.Grupos)+1);
                    AParametrosSaida.Grupos[Length(AParametrosSaida.Grupos)-1].ID := StrToIntDef(LGrupoID,0);
                    AParametrosSaida.Grupos[Length(AParametrosSaida.Grupos)-1].NOME := LGrupoNome;
                  end;
                end;
              end;
            end;

            if LJSONResposta.Values['PAs'] <> nil then
            begin
              LJSONRespostaPAs := LJSONResposta.GetValue<TJSONObject>('PAs') as TJSONObject;
              if LJSONRespostaPAs.Values['Itens'] <> nil then
              begin
                if LJSONRespostaPAs.TryGetValue('Itens', LArrayObjeto) then
                begin
                  for LCount := 0 to Pred(LArrayObjeto.Count) do
                  begin
                    LJSONRespostaPAs := (LArrayObjeto.Items[LCount] as TJSONObject);
                    LGrupoNome := EmptyStr;
                    LGrupoID := EmptyStr;
                    LJSONRespostaPAs.TryGetValue('ID',LPAID);
                    LJSONRespostaPAs.TryGetValue('Nome',LPANome);
                    LJSONRespostaPAs.TryGetValue('GrupoId',LPAGrupoId);
                    LJSONRespostaPAs.TryGetValue('Status',LPAStatus);
                    setlength(AParametrosSaida.PAs, Length(AParametrosSaida.PAs)+1);
                    AParametrosSaida.PAs[Length(AParametrosSaida.PAs)-1].ID := LPAID;
                    AParametrosSaida.PAs[Length(AParametrosSaida.PAs)-1].NOME := LPANome;
                    AParametrosSaida.PAs[Length(AParametrosSaida.PAs)-1].GrupoId := LPAGrupoId;
                    AParametrosSaida.PAs[Length(AParametrosSaida.PAs)-1].Status := LPAStatus;
                  end;
                end;
              end;
            end;
          end
          else
          begin
            Result := raErroNegocio;

            AErroAPI.CodErro := -1;
            AErroAPI.MsgErro := 'Erro no evento "' + TAPIAspectSicsPA.ClassName + '.Execute" / ' +
                                'URL: "' + LUrlListar + '" / ' +
                                'Recebido: "' + LRetorno + '"';

            TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
              .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroNegocio])
              .AddDetail('Evento'          , TAPIAspectSicsPA.ClassName                     )
              .AddDetail('Url'             , LUrlListar                                )
              .AddDetail('Metodo'          , 'Get'                             )
              .AddDetail('ConteudoRecebido', LRetorno                           )
              .AddDetail('ErroCatalogado'  , AErroAPI.CodErro                   )
              .Save;
            TLog.MyLogTemp(AErroAPI.MsgErro, nil, 0, False, TCriticalLog.tlERROR);
          end;

        finally
          LJSONResposta.Free;
        end;
      end
      else
      begin
        Result := raErroNegocio;

        AErroAPI.CodErro := -1;
        AErroAPI.MsgErro := 'Erro no evento "' + TAPIAspectSicsPA.ClassName + '.Execute" / ' +
                            'URL: "' + LUrlListar + '" / ' +
                            'Recebido: "' + LRetorno + '"';

        TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
          .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroNegocio])
          .AddDetail('Evento'          , TAPIAspectSicsPA.ClassName                     )
          .AddDetail('Url'             , LUrlListar                                )
          .AddDetail('Metodo'          , 'Get'                             )
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
        AErroAPI.MsgErro := 'Exception no evento "' + TAPIAspectSicsPA.ClassName + '.Execute" / ' +
                            'URL: "' + LUrlListar + '" / ' +
                            'Recebido: "' + LRetorno + '" / ' +
                            'Erro: "' + E.Message + '"';

        TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
          .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raException])
          .AddDetail('Evento'          , TAPIAspectSicsPA.ClassName                   )
          .AddDetail('Url'             , LUrlListar                              )
          .AddDetail('Metodo'          , 'Get'                           )
          .AddDetail('ConteudoRecebido', LRetorno                         )
          .AddDetail('ErroCatalogado'  , AErroAPI.CodErro                 )
          .AddDetail('ExceptionMessage', E.Message                        )
          .Save;
        TLog.MyLogTemp(AErroAPI.MsgErro, nil, 0, False, TCriticalLog.tlERROR)
      end;
    end;
  finally
  end;
end;

initialization

{$IFNDEF CompilarPara_TotemAA}
  with TIniFile.Create(IncludeTrailingPathDelimiter(System.SysUtils.GetCurrentDir) + StringReplace(ExtractFileName(ParamStr(0)), '.exe', '.ini', [rfReplaceAll])) do
  try
    TAPIAspectSicsPA.URL := ReadString('APIs.Aspect.Sics.PA', 'URL', 'http://10.32.10.21:80/aspect/rest/PA/');
    WriteString('APIs.Aspect.Sics.PA', 'URL', TAPIAspectSicsPA.URL);
  finally
    Free;
  end;
{$ENDIF}

end.