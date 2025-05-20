unit APIs.Aspect.Sics.Atendente;

interface

uses
  APIs.Common, LogSQLite, FMX.Graphics, System.Classes,IdHTTP;

type
  TParametrosEntradaDadosAPI =  record
                                  IdUnidade: integer;
                                  CODPROFISSIONAL: string;
                                  NOMEPROFISSIONAL: string;
                                end;
type
  TParametrosSaidaDadosAPI =  record
                                  Id_Triagem: integer;
                                  Triagem: boolean;
                                  ImprimirPulseira: boolean;
                                  PA: integer;
                                  Fila: integer;
                                  Localizado: boolean;
                                  ConvenioModular: boolean;
                              end;
type
  TAtendentes =   record
                    CODPROFISSIONAL: integer;
                    NOMEPROFISSIONAL: string;
                  end;

type
  TParametrosEntradaGrupoAPI =  record
                                  IdUnidade: integer;
                                  Grupo: string;
                                end;
type
  TParametrosSaidaGrupoAPI =  record
                                Atendentes: array of TAtendentes;
                              end;
type
  TParametrosEntradaFotosAPI =  record
                                  IdUnidade: integer;
                                  NOMEPROFISSIONAL: string;
                                end;
type
  TAPIAspectSicsAtendente = class

  private

  public
    class var URL: string;
  end;

  function ObterDados(const AParametrosEntrada: TParametrosEntradaDadosAPI; out AParametrosSaida: TParametrosSaidaDadosAPI; out AErroAPI: TErroAPI): TTipoRetornoAPI;
  function ObterFoto(const AParametrosEntrada: TParametrosEntradaFotosAPI;out AFotoSaida: TBitmap; out AErroAPI: TErroAPI): TTipoRetornoAPI;
  function ObterAtendentesPorGrupo(const AParametrosEntrada: TParametrosEntradaGrupoAPI;out AParametrosSaida:TParametrosSaidaGrupoAPI; out AErroAPI: TErroAPI): TTipoRetornoAPI;
  procedure PopularParametros;

implementation

uses
{$IFDEF CompilarPara_TotemAA}
  controller.parametros,
{$ENDIF}
  IniFiles, System.SysUtils, System.JSON,  untLog, System.DateUtils;

procedure PopularParametros;
begin
{$IFDEF CompilarPara_TotemAA}
  TAPIAspectSicsAtendente.URL := controller.parametros.CarregarParametroStr('APIs.Aspect.Sics', 'URL_Atendente', 'http://10.32.10.21:80/aspect/rest/atendente/');
{$ENDIF}
end;

function ObterAtendentesPorGrupo(
  const AParametrosEntrada: TParametrosEntradaGrupoAPI;
  out AParametrosSaida:TParametrosSaidaGrupoAPI;
  out AErroAPI: TErroAPI): TTipoRetornoAPI;
var
  LUrl_SCC_Grupo:String;
  LJSON: TJSONObject;
  LRetorno: string;
  LJSONArray: TJSONArray;
  LCount: integer;
  LNomeProfissional: string;
  LCodProfissional: integer;
begin
  TLogSQLite.New(tmInfo, clResponse, 'Consumindo API Atendente/ObterAtendentesPorGrupo').Save;
  TLog.MyLogTemp('Consumindo API Atendente/ObterAtendentesPorGrupo', nil, 0, False, TCriticalLog.tlINFO);
  LUrl_SCC_Grupo := TAPIAspectSicsAtendente.Url + 'ObterAtendentesPorGrupo/' + AParametrosEntrada.Grupo + '/' + AParametrosEntrada.IdUnidade.ToString;
  try
    Result := IntegracaoAPI_Get(LUrl_SCC_Grupo, LRetorno, AErroAPI);
    LJSON := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(LRetorno), 0) as TJSONObject;
    try
      if LJSON.Values['result'] <> nil then
      begin
        if LJSON.TryGetValue('result', LJSONArray) then begin
          for LCount := 0 to Pred(LJSONArray.Count) do begin
            LJSON := (LJSONArray.Items[LCount] as TJSONObject);
            LNomeProfissional:= EmptyStr;
            LCodProfissional:=0;
            LJSON.TryGetValue('Nome', LNomeProfissional);
            LJSON.TryGetValue('IdAtendenteNoCliente', LCodProfissional);
            setlength(AParametrosSaida.Atendentes,length(AParametrosSaida.Atendentes)+1);
            AParametrosSaida.Atendentes[length(AParametrosSaida.Atendentes)-1].CODPROFISSIONAL := LCodProfissional;
            AParametrosSaida.Atendentes[length(AParametrosSaida.Atendentes)-1].NOMEPROFISSIONAL := LNomeProfissional;
          end;
        end;
        Result := raOK;
      end
      else
      begin
        Result := raErroNegocio;
        AErroAPI.CodErro := -1;
        AErroAPI.MsgErro := 'Erro no evento "' + TAPIAspectSicsAtendente.ClassName + '.Execute" / ' +
                            'URL: "' + LUrl_SCC_Grupo + '" / ' +
                            'Enviado: "' + LJSON.ToJSON + '" / ' +
                            'Recebido: "' + LRetorno + '"';

        TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
          .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroNegocio])
          .AddDetail('Evento'          , TAPIAspectSicsAtendente.ClassName                     )
          .AddDetail('Url'             , LUrl_SCC_Grupo                     )
          .AddDetail('Metodo'          , 'POST'                             )
          .AddDetail('ConteudoEnviado' , LJSON.ToString                     )
          .AddDetail('ConteudoRecebido', LRetorno                           )
          .AddDetail('ErroCatalogado'  , AErroAPI.CodErro                   )
          .Save;
        TLog.MyLogTemp(AErroAPI.MsgErro, nil, 0, False, TCriticalLog.tlERROR);
      end;
    finally
      LJSON.Free;
    end;
  except on e:exception do
    begin
        Result := raException;
        AErroAPI.CodErro := -1;
        AErroAPI.MsgErro := 'Exception no evento "' + TAPIAspectSicsAtendente.ClassName + '.Execute" / ' +
                            'URL: "' + LUrl_SCC_Grupo + '" / ' +
                            'Enviado: "' + LJSON.ToJSON + '" / ' +
                            'Recebido: "' + LRetorno + '" / ' +
                            'Erro: "' + E.Message + '"';

        TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
          .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raException])
          .AddDetail('Evento'          , TAPIAspectSicsAtendente.ClassName                   )
          .AddDetail('Url'             , LUrl_SCC_Grupo                              )
          .AddDetail('Metodo'          , 'Get'                           )
          .AddDetail('ConteudoEnviado' , LJSON.ToString                   )
          .AddDetail('ConteudoRecebido', LRetorno                         )
          .AddDetail('ErroCatalogado'  , AErroAPI.CodErro                 )
          .AddDetail('ExceptionMessage', E.Message                        )
          .Save;
        TLog.MyLogTemp(AErroAPI.MsgErro, nil, 0, False, TCriticalLog.tlERROR)
    end;
  end;
end;

function ObterDados(
  const AParametrosEntrada: TParametrosEntradaDadosAPI;
  out AParametrosSaida: TParametrosSaidaDadosAPI;
  out AErroAPI: TErroAPI): TTipoRetornoAPI;
var
  LUrl_SCC_Dados:String;
  LJSON: TJSONObject;
  LRetorno: string;
  LId_Triagem: integer;
  LTriagem: boolean;
  LImprimirPulseira: boolean;
  LPA: integer;
  LFila: integer;
  LLocalizado: boolean;
  LConvenioModular: boolean;
begin
  TLogSQLite.New(tmInfo, clResponse, 'Consumindo API Atendente/ObterDados').Save;
  TLog.MyLogTemp('Consumindo API Atendente/ObterDados', nil, 0, False, TCriticalLog.tlINFO);
  if (AParametrosEntrada.CODPROFISSIONAL <> EmptyStr)then
  begin
    TLogSQLite.New(tmInfo, clOperationRecord, 'Consultando atendente no SICS...')
      .AddDetail('CodigoAtendente', AParametrosEntrada.CODPROFISSIONAL)
      .Save;
    TLog.MyLogTemp('Consultando atendente no SICS: ' + AParametrosEntrada.CODPROFISSIONAL, nil, 0, False, TCriticalLog.tlINFO);
    LUrl_SCC_Dados := TAPIAspectSicsAtendente.Url + 'ObterDados/' + AParametrosEntrada.CODPROFISSIONAL + '/' + AParametrosEntrada.IdUnidade.ToString;
  end
  else
  begin
    TLogSQLite.New(tmInfo, clOperationRecord, 'Consultando atendente no SICS...')
      .AddDetail('NomeAtendente', AParametrosEntrada.NOMEPROFISSIONAL)
      .Save;
    TLog.MyLogTemp('Consultando atendente no SICS: ' + AParametrosEntrada.NOMEPROFISSIONAL, nil, 0, False, TCriticalLog.tlINFO);
    LUrl_SCC_Dados := TAPIAspectSicsAtendente.Url + 'ObterDados/' + AParametrosEntrada.NOMEPROFISSIONAL + '/' + AParametrosEntrada.IdUnidade.ToString;
  end;
  try
    Result := IntegracaoAPI_Get(LUrl_SCC_Dados, LRetorno, AErroAPI);
    LJSON := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(LRetorno), 0) as TJSONObject;
    try
      if LJSON.Values['result'] <> nil then
      begin
        LJSON := LJSON.GetValue<TJSONObject>('result') as TJSONObject;
        LJSON.TryGetValue('Id_Triagem', LId_Triagem);
        LJSON.TryGetValue('Triagem', LTriagem);
        LJSON.TryGetValue('ImprimirPulseira', LImprimirPulseira);
        LJSON.TryGetValue('Fila', LFila);
        LJSON.TryGetValue('PA', LPA);
        LJSON.TryGetValue('Localizado', LLocalizado);
        LJSON.TryGetValue('ConvenioModular', LConvenioModular);
        AParametrosSaida.Id_Triagem       := LId_Triagem;
        AParametrosSaida.Triagem          := LTriagem;
        AParametrosSaida.ImprimirPulseira := LImprimirPulseira;
        AParametrosSaida.Fila             := LFila;
        AParametrosSaida.PA               := LPA;
        AParametrosSaida.Localizado       := LLocalizado;
        AParametrosSaida.ConvenioModular  := LConvenioModular;
        Result := raOK;
      end
      else
      begin
        Result := raErroNegocio;
        AErroAPI.CodErro := -1;
        AErroAPI.MsgErro := 'Erro no evento "' + TAPIAspectSicsAtendente.ClassName + '.Execute" / ' +
                            'URL: "' + LUrl_SCC_Dados + '" / ' +
                            'Enviado: "' + LJSON.ToJSON + '" / ' +
                            'Recebido: "' + LRetorno + '"';

        TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
          .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroNegocio])
          .AddDetail('Evento'          , TAPIAspectSicsAtendente.ClassName  )
          .AddDetail('Url'             , LUrl_SCC_Dados                     )
          .AddDetail('Metodo'          , 'POST'                             )
          .AddDetail('ConteudoEnviado' , LJSON.ToString                     )
          .AddDetail('ConteudoRecebido', LRetorno                           )
          .AddDetail('ErroCatalogado'  , AErroAPI.CodErro                   )
          .Save;
        TLog.MyLogTemp(AErroAPI.MsgErro, nil, 0, False, TCriticalLog.tlERROR);
      end;
    finally
      LJSON.Free;
    end;
  except on e:exception do
    begin
        Result := raException;
        AErroAPI.CodErro := -1;
        AErroAPI.MsgErro := 'Exception no evento "' + TAPIAspectSicsAtendente.ClassName + '.Execute" / ' +
                            'URL: "' + LUrl_SCC_Dados + '" / ' +
                            'Enviado: "' + LJSON.ToJSON + '" / ' +
                            'Recebido: "' + LRetorno + '" / ' +
                            'Erro: "' + E.Message + '"';

        TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
          .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raException])
          .AddDetail('Evento'          , TAPIAspectSicsAtendente.ClassName    )
          .AddDetail('Url'             , LUrl_SCC_Dados                       )
          .AddDetail('Metodo'          , 'Get'                                )
          .AddDetail('ConteudoEnviado' , LJSON.ToString                       )
          .AddDetail('ConteudoRecebido', LRetorno                             )
          .AddDetail('ErroCatalogado'  , AErroAPI.CodErro                     )
          .AddDetail('ExceptionMessage', E.Message                            )
          .Save;
        TLog.MyLogTemp(AErroAPI.MsgErro, nil, 0, False, TCriticalLog.tlERROR)
    end;
  end;

end;


function ObterFoto(
  const AParametrosEntrada: TParametrosEntradaFotosAPI;
  out AFotoSaida: TBitmap;
  out AErroAPI: TErroAPI): TTipoRetornoAPI;
var
  LUrl_SCC_Foto:String;
  LStream: TMemoryStream;
  LIdHTTP: TIdHTTP;
  LTentativas: integer;
  LMensagemRet: string;
  LEnviadoEm : TDateTime;
begin
  if controller.parametros.CarregarParametroBool('Temporarios', 'GravarLogApiFotoAtendente') then
  begin
    TLogSQLite.New(tmInfo, clResponse, 'Consumindo API Atendente/ObterFoto').Save;
    TLog.MyLogTemp('Consumindo API Atendente/ObterFoto', nil, 0, False, TCriticalLog.tlINFO);
  end;
  LUrl_SCC_Foto := TAPIAspectSicsAtendente.Url + 'ObterFoto/' + AParametrosEntrada.NOMEPROFISSIONAL + '/' + AParametrosEntrada.IdUnidade.ToString;
  LStream := TMemoryStream.Create;
  LIdHTTP := TIdHTTP.Create(nil);
  LIdHTTP.ReadTimeout := 3000;
  LIdHTTP.ConnectTimeout := 3000;
  try
    try
      for LTentativas := 1 to 3 do
      begin
        if controller.parametros.CarregarParametroBool('Temporarios', 'GravarLogApiFotoAtendente') then
        begin
          TLogSQLite.New(tmInfo, clRequest, 'IntegracaoAPI (Enviando)')
            .AddDetail('Tentativa', IntToStr(LTentativas))
            .AddDetail('Url'      , LUrl_SCC_Foto        )
            .AddDetail('Metodo'   , 'GET'                )
            .Save;
          TLog.MyLogTemp('IntegracaoAPI (Enviando). ' +
                         'Tentativa: "' + IntToStr(LTentativas) + '" | ' +
                         'Url: "'       + LUrl_SCC_Foto         + '" | ' +
                         'Metodo: "'    + 'GET'                 + '"',
                         nil, 0, False, TCriticalLog.tlINFO);

        end;
        LEnviadoEm := Now;
        LIdHTTP.Get(LUrl_SCC_Foto, LStream);
//        TLogSQLite.New(tmInfo, clOperationRecord, 'Tentativa ' + LTentativas.ToString + ' Retorno: ' + LIdHTTP.ResponseCode.ToString + ' - ' + LIdHTTP.ResponseText).Save;
//        TLog.MyLogTemp( 'Tentativa ' + LTentativas.ToString + ' Retorno: ' + LIdHTTP.ResponseCode.ToString + ' - ' + LIdHTTP.ResponseText, nil, 0, False, TCriticalLog.tlInfo);
        if LIdHTTP.ResponseCode = 200 then
        begin
          if controller.parametros.CarregarParametroBool('Temporarios', 'GravarLogApiFotoAtendente') then
          begin
            TLogSQLite.New(tmInfo, clResponse, 'IntegracaoAPI (Resultado Ok)')
              .AddDetail('Tentativa'       , IntToStr(LTentativas))
              .AddDetail('Url'             , LUrl_SCC_Foto  )
              .AddDetail('Metodo'          , 'GET'          )
              .AddDetail('HttpStatusCode'  , IntToStr(LIdHTTP.ResponseCode))
              .AddDetail('TempoDecorrido'  , IntToStr(MilliSecondsBetween(Now, LEnviadoEm)))
              .Save;
            TLog.MyLogTemp('IntegracaoAPI (Resultado Ok). ' +
                           'Tentativa: "'        + IntToStr(LTentativas) + '" | ' +
                           'Url: "'              + LUrl_SCC_Foto         + '" | ' +
                           'Metodo: "'           + 'GET'                 + '" | ' +
                           'HttpStatusCode: "'   + IntToStr(LIdHTTP.ResponseCode)     + '" | ' +
                           'TempoDecorrido: "'   + IntToStr(MilliSecondsBetween(Now, LEnviadoEm)) + '"',
                           nil, 0, False, TCriticalLog.tlINFO);
          end;
          if (LStream.Size > 0) then
            LMensagemRet := 'Foto do profissional encontrada.'
          else
            LMensagemRet := 'Profissional não possui foto cadastrada.';
          if controller.parametros.CarregarParametroBool('Temporarios', 'GravarLogApiFotoAtendente') then
          begin
            TLogSQLite.New(tmInfo, clOperationRecord, LMensagemRet + ' - Retorno: ' + LIdHTTP.ResponseCode.ToString + ' - ' + LIdHTTP.ResponseText).Save;
            TLog.MyLogTemp(LMensagemRet + ' - Retorno: ' + LIdHTTP.ResponseCode.ToString + ' - ' + LIdHTTP.ResponseText, nil, 0, False, TCriticalLog.tlInfo);
          end;
          LStream.Position := 0;
          AFotoSaida.LoadFromStream(LStream);
          Result := raOK;
          break;
        end;
      end;
      if Result <> raOK then
      begin
        AErroAPI.CodErro := -1;
        AErroAPI.MsgErro := 'Erro no evento "' + TAPIAspectSicsAtendente.ClassName + '.Execute" / ' +
                            'URL: "' + LUrl_SCC_Foto + '"';
        if controller.parametros.CarregarParametroBool('Temporarios', 'GravarLogApiFotoAtendente') then
        begin
          TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
            .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroNegocio])
            .AddDetail('Evento'          , TAPIAspectSicsAtendente.ClassName  )
            .AddDetail('Url'             , LUrl_SCC_Foto                      )
            .AddDetail('Metodo'          , 'POST'                             )
            .AddDetail('ErroCatalogado'  , AErroAPI.CodErro                   )
            .Save;
          TLog.MyLogTemp(AErroAPI.MsgErro, nil, 0, False, TCriticalLog.tlERROR);
        end;
      end;
    finally
    end;
  except on e:exception do
    begin
      Result := raException;
      AErroAPI.CodErro := -1;
      AErroAPI.MsgErro := 'Exception no evento "' + TAPIAspectSicsAtendente.ClassName + '.Execute" / ' +
                          'URL: "' + LUrl_SCC_Foto + '" / ' +
                          'Erro: "' + E.Message + '"';
      if controller.parametros.CarregarParametroBool('Temporarios', 'GravarLogApiFotoAtendente') then
      begin
        TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
          .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raException])
          .AddDetail('Evento'          , TAPIAspectSicsAtendente.ClassName                   )
          .AddDetail('Url'             , LUrl_SCC_Foto                    )
          .AddDetail('Metodo'          , 'Get'                            )
          .AddDetail('ErroCatalogado'  , AErroAPI.CodErro                 )
          .AddDetail('ExceptionMessage', E.Message                        )
          .Save;
        TLog.MyLogTemp(AErroAPI.MsgErro, nil, 0, False, TCriticalLog.tlERROR)
      end;
    end;
  end;
end;

initialization
{$IFNDEF CompilarPara_TotemAA}
  with TIniFile.Create(IncludeTrailingPathDelimiter(System.SysUtils.GetCurrentDir) + StringReplace(ExtractFileName(ParamStr(0)), '.exe', '.ini', [rfReplaceAll])) do
  try
    TAPIAspectSicsAtendente.URL := ReadString('APIs.Aspect.Sics.Atendente', 'URL', 'http://10.32.10.21:80/aspect/rest/atendente/');
    WriteString('APIs.Aspect.Sics.Atendente', 'URL', TAPIAspectSicsAtendente.URL);
  finally
    Free;
  end;
{$ENDIF}
end.
