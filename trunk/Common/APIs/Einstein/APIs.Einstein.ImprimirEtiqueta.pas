unit APIs.Einstein.ImprimirEtiqueta;

interface

uses
  APIs.Common, LogSQLite;
type
  TParametrosEntradaImprimirAPI = record
                                    IdPassagem : string;
                                    Device : string;
                                    QtdeImpressao : integer;
                                    Etiqueta : string;
                                    LocalPArRef : integer;
                                    IdMedico : integer;
                                  end;
type
  TAPIEinsteinImprimirEtiqueta = class
  private
    class var URL: string;
  public
  end;

procedure PopularParametros;
function Imprimir(const AParametrosEntrada: TParametrosEntradaImprimirAPI; out AErroAPI: TErroAPI): TTipoRetornoAPI;

implementation

uses
{$IFDEF CompilarPara_TotemAA}
  controller.parametros,
{$ENDIF}
  IniFiles, System.SysUtils, System.JSON,  untLog;

procedure PopularParametros;
begin
{$IFDEF CompilarPara_TotemAA}
  TAPIEinsteinImprimirEtiqueta.URL := controller.parametros.CarregarParametroStr('APIs.Einstein', 'URL_ImprimirEtiqueta', 'http://10.33.1.223:20009/servico/totem/imprimiretiqueta');
{$ENDIF}
end;

function Imprimir(
	const AParametrosEntrada: TParametrosEntradaImprimirAPI;
	out AErroAPI: TErroAPI): TTipoRetornoAPI;
var
  LJSON: TJSONObject;
  LRetorno: string;
begin
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
        Result := IntegracaoAPI_Post(TAPIEinsteinImprimirEtiqueta.Url, LJSON, LRetorno, AErroAPI,3);

      end;
    finally
      LJSON.Free;
    end;
  except on e:exception do
    begin
        Result := raException;
        AErroAPI.CodErro := -1;
        AErroAPI.MsgErro := 'Exception no evento "' + TAPIEinsteinImprimirEtiqueta.ClassName + '.Execute" / ' +
                            'URL: "' + TAPIEinsteinImprimirEtiqueta.URL + '" / ' +
                            'Enviado: "' + LJSON.ToJSON + '" / ' +
                            'Recebido: "' + LRetorno + '" / ' +
                            'Erro: "' + E.Message + '"';

        TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
          .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raException])
          .AddDetail('Evento'          , TAPIEinsteinImprimirEtiqueta.ClassName                   )
          .AddDetail('Url'             , TAPIEinsteinImprimirEtiqueta.Url                              )
          .AddDetail('Metodo'          , 'Ge t'                           )
          .AddDetail('ConteudoEnviado' , LJSON.ToString                   )
          .AddDetail('ConteudoRecebido', LRetorno                         )
          .AddDetail('ErroCatalogado'  , AErroAPI.CodErro                 )
          .AddDetail('ExceptionMessage', E.Message                        )
          .Save;
        TLog.MyLogTemp(AErroAPI.MsgErro, nil, 0, False, TCriticalLog.tlERROR)
    end;
  end;

end;

initialization
{$IFNDEF CompilarPara_TotemAA}
  with TIniFile.Create(IncludeTrailingPathDelimiter(System.SysUtils.GetCurrentDir) + StringReplace(ExtractFileName(ParamStr(0)), '.exe', '.ini', [rfReplaceAll])) do
  try
    TAPIEinsteinImprimirEtiqueta.URL := ReadString('APIs.Einstein.ImprimirEtiqueta', 'URL', 'http://10.33.1.223:20009/servico/totem/imprimiretiqueta');
    WriteString('APIs.Einstein.ImprimirEtiqueta', 'URL', TAPIEinsteinImprimirEtiqueta.URL);
  finally
    Free;
  end;
{$ENDIF}
end.


