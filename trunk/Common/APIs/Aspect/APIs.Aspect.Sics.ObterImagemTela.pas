unit APIs.Aspect.Sics.ObterImagemTela;

interface

uses
  APIs.Common, LogSQLite, FMX.Graphics, System.Classes,IdHTTP;

type
  TParametrosEntradaDadosAPI =  record
                                  IdUnidade: integer;
                                  IdImagem: integer;
                                end;
type
  TAPIAspectSicsObterImagemTela  = class

  private

  public
    class var URL: string;
  end;

  function ObterImagemTela(const AParametrosEntrada: TParametrosEntradaDadosAPI;out ATela: TBitmap;out AErroAPI: TErroAPI): TTipoRetornoAPI;overload;
  function ObterImagemTela(const AParametrosEntrada: TParametrosEntradaDadosAPI;out ATela: TMemoryStream;out AErroAPI: TErroAPI): TTipoRetornoAPI;overload;
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
  TAPIAspectSicsObterImagemTela.URL := controller.parametros.CarregarParametroStr('APIs.Aspect.Sics', 'URL_ObterImagemTela', 'http://192.168.0.196:80/aspect/rest/Totem/ObterImagemTela');
{$ENDIF}
end;

function ObterImagemTela(const AParametrosEntrada: TParametrosEntradaDadosAPI;out ATela: TBitmap;out AErroAPI: TErroAPI): TTipoRetornoAPI;
var
  LUrl_SCC_Tela:String;
  LStream: TMemoryStream;
  LIdHTTP: TIdHTTP;
  LTentativas: integer;
  LMensagemRet: string;
  LEnviadoEm : TDateTime;
begin
  {$IFDEF CompilarPara_TotemAA}
    if controller.parametros.CarregarParametroBool('Temporarios', 'GravarLogApiTelaInicial') then
    begin
  {$ENDIF}
      TLogSQLite.New(tmInfo, clResponse, 'Consumindo API ObterImagemTela').Save;
      TLog.MyLogTemp('Consumindo API ObterImagemTela', nil, 0, False, TCriticalLog.tlINFO);
  {$IFDEF CompilarPara_TotemAA}
    end;
  {$ENDIF}
  LUrl_SCC_Tela := StringReplace(TAPIAspectSicsObterImagemTela.Url, '{{IdImagem}}', AParametrosEntrada.IdImagem.ToString, [rfReplaceAll]);
//  LUrl_SCC_Tela := TAPIAspectSicsObterImagemTela.Url + '/' + AParametrosEntrada.IdImagem.ToString + '/' + AParametrosEntrada.IdUnidade.ToString;
  LStream := TMemoryStream.Create;
  LIdHTTP := TIdHTTP.Create(nil);
  LIdHTTP.ReadTimeout := 3000;
  LIdHTTP.ConnectTimeout := 3000;
  try
    try
      for LTentativas := 1 to 3 do
      begin
        {$IFDEF CompilarPara_TotemAA}
          if controller.parametros.CarregarParametroBool('Temporarios', 'GravarLogApiTelaInicial') then
          begin
        {$ENDIF}
            TLogSQLite.New(tmInfo, clRequest, 'IntegracaoAPI (Enviando)')
              .AddDetail('Tentativa', IntToStr(LTentativas))
              .AddDetail('Url'      , LUrl_SCC_Tela        )
              .AddDetail('Metodo'   , 'GET'                )
              .Save;
            TLog.MyLogTemp('IntegracaoAPI (Enviando). ' +
                           'Tentativa: "' + IntToStr(LTentativas) + '" | ' +
                           'Url: "'       + LUrl_SCC_Tela         + '" | ' +
                           'Metodo: "'    + 'GET'                 + '"',
                           nil, 0, False, TCriticalLog.tlINFO);
        {$IFDEF CompilarPara_TotemAA}
          end;
        {$ENDIF}
        LEnviadoEm := Now;
        LIdHTTP.Get(LUrl_SCC_Tela, LStream);
        if LIdHTTP.ResponseCode = 200 then
        begin
          {$IFDEF CompilarPara_TotemAA}
            if controller.parametros.CarregarParametroBool('Temporarios', 'GravarLogApiTelaInicial') then
            begin
          {$ENDIF}
              TLogSQLite.New(tmInfo, clResponse, 'IntegracaoAPI (Resultado Ok)')
                .AddDetail('Tentativa'       , IntToStr(LTentativas))
                .AddDetail('Url'             , LUrl_SCC_Tela  )
                .AddDetail('Metodo'          , 'GET'          )
                .AddDetail('HttpStatusCode'  , IntToStr(LIdHTTP.ResponseCode))
                .AddDetail('TempoDecorrido'  , IntToStr(MilliSecondsBetween(Now, LEnviadoEm)))
                .Save;
              TLog.MyLogTemp('IntegracaoAPI (Resultado Ok). ' +
                             'Tentativa: "'        + IntToStr(LTentativas) + '" | ' +
                             'Url: "'              + LUrl_SCC_Tela         + '" | ' +
                             'Metodo: "'           + 'GET'                 + '" | ' +
                             'HttpStatusCode: "'   + IntToStr(LIdHTTP.ResponseCode)     + '" | ' +
                             'TempoDecorrido: "'   + IntToStr(MilliSecondsBetween(Now, LEnviadoEm)) + '"',
                             nil, 0, False, TCriticalLog.tlINFO);
          {$IFDEF CompilarPara_TotemAA}
            end;
          {$ENDIF}

          if (LStream.Size > 0) then
          begin
            LMensagemRet := 'Tela encontrada.'
          end
          else
          begin
            LMensagemRet := 'Tela não encontrada.';
          end;
          {$IFDEF CompilarPara_TotemAA}
            if controller.parametros.CarregarParametroBool('Temporarios', 'GravarLogApiTelaInicial') then
            begin
          {$ENDIF}
              TLogSQLite.New(tmInfo, clOperationRecord, LMensagemRet + ' - Retorno: ' + LIdHTTP.ResponseCode.ToString + ' - ' + LIdHTTP.ResponseText).Save;
              TLog.MyLogTemp(LMensagemRet + ' - Retorno: ' + LIdHTTP.ResponseCode.ToString + ' - ' + LIdHTTP.ResponseText, nil, 0, False, TCriticalLog.tlInfo);
          {$IFDEF CompilarPara_TotemAA}
            end;
          {$ENDIF}
          LStream.Position := 0;
          ATela.LoadFromStream(LStream);
          Result := raOK;
          break;
        end;
      end;
      if Result <> raOK then
      begin
        AErroAPI.CodErro := -1;
        AErroAPI.MsgErro := 'Erro no evento "' + TAPIAspectSicsObterImagemTela.ClassName + '.Execute" / ' +
                            'URL: "' + LUrl_SCC_Tela + '"';
        {$IFDEF CompilarPara_TotemAA}
          if controller.parametros.CarregarParametroBool('Temporarios', 'GravarLogApiTelaInicial') then
          begin
        {$ENDIF}
            TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
              .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroNegocio])
              .AddDetail('Evento'          , TAPIAspectSicsObterImagemTela.ClassName  )
              .AddDetail('Url'             , LUrl_SCC_Tela                      )
              .AddDetail('Metodo'          , 'POST'                             )
              .AddDetail('ErroCatalogado'  , AErroAPI.CodErro                   )
              .Save;
            TLog.MyLogTemp(AErroAPI.MsgErro, nil, 0, False, TCriticalLog.tlERROR);
        {$IFDEF CompilarPara_TotemAA}
          end;
        {$ENDIF}
      end;
    finally
    end;
  except on e:exception do
    begin
      Result := raException;
      AErroAPI.CodErro := -1;
      AErroAPI.MsgErro := 'Exception no evento "' + TAPIAspectSicsObterImagemTela.ClassName + '.Execute" / ' +
                          'URL: "' + LUrl_SCC_Tela + '" / ' +
                          'Erro: "' + E.Message + '"';
      {$IFDEF CompilarPara_TotemAA}
        if controller.parametros.CarregarParametroBool('Temporarios', 'GravarLogApiTelaInicial') then
        begin
      {$ENDIF}
          TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
            .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raException])
            .AddDetail('Evento'          , TAPIAspectSicsObterImagemTela.ClassName                   )
            .AddDetail('Url'             , LUrl_SCC_Tela                    )
            .AddDetail('Metodo'          , 'Get'                            )
            .AddDetail('ErroCatalogado'  , AErroAPI.CodErro                 )
            .AddDetail('ExceptionMessage', E.Message                        )
            .Save;
          TLog.MyLogTemp(AErroAPI.MsgErro, nil, 0, False, TCriticalLog.tlERROR)
      {$IFDEF CompilarPara_TotemAA}
        end;
      {$ENDIF}
    end;
  end;
end;


function ObterImagemTela(const AParametrosEntrada: TParametrosEntradaDadosAPI;out ATela: TMemoryStream;out AErroAPI: TErroAPI): TTipoRetornoAPI;
var
  LUrl_SCC_Tela:String;
  LStream: TMemoryStream;
  LIdHTTP: TIdHTTP;
  LTentativas: integer;
  LMensagemRet: string;
  LEnviadoEm : TDateTime;
begin
  TLogSQLite.New(tmInfo, clResponse, 'Consumindo API ObterImagemTela').Save;
  TLog.MyLogTemp('Consumindo API ObterImagemTela', nil, 0, False, TCriticalLog.tlINFO);
  LUrl_SCC_Tela := StringReplace(TAPIAspectSicsObterImagemTela.Url, '{{IdImagem}}', AParametrosEntrada.IdImagem.ToString, [rfReplaceAll]);
//  LUrl_SCC_Tela := TAPIAspectSicsObterImagemTela.Url + '/' + AParametrosEntrada.IdImagem.ToString + '/' + AParametrosEntrada.IdUnidade.ToString;
  LStream := TMemoryStream.Create;
  LIdHTTP := TIdHTTP.Create(nil);
  LIdHTTP.ReadTimeout := 3000;
  LIdHTTP.ConnectTimeout := 3000;
  try
    try
      for LTentativas := 1 to 3 do
      begin
        TLogSQLite.New(tmInfo, clRequest, 'IntegracaoAPI (Enviando)')
          .AddDetail('Tentativa', IntToStr(LTentativas))
          .AddDetail('Url'      , LUrl_SCC_Tela        )
          .AddDetail('Metodo'   , 'GET'                )
          .Save;
        TLog.MyLogTemp('IntegracaoAPI (Enviando). ' +
                       'Tentativa: "' + IntToStr(LTentativas) + '" | ' +
                       'Url: "'       + LUrl_SCC_Tela         + '" | ' +
                       'Metodo: "'    + 'GET'                 + '"',
                       nil, 0, False, TCriticalLog.tlINFO);

        LEnviadoEm := Now;
        LIdHTTP.Get(LUrl_SCC_Tela, LStream);
        if LIdHTTP.ResponseCode = 200 then
        begin
          TLogSQLite.New(tmInfo, clResponse, 'IntegracaoAPI (Resultado Ok)')
            .AddDetail('Tentativa'       , IntToStr(LTentativas))
            .AddDetail('Url'             , LUrl_SCC_Tela  )
            .AddDetail('Metodo'          , 'GET'          )
            .AddDetail('HttpStatusCode'  , IntToStr(LIdHTTP.ResponseCode))
            .AddDetail('TempoDecorrido'  , IntToStr(MilliSecondsBetween(Now, LEnviadoEm)))
            .Save;
          TLog.MyLogTemp('IntegracaoAPI (Resultado Ok). ' +
                         'Tentativa: "'        + IntToStr(LTentativas) + '" | ' +
                         'Url: "'              + LUrl_SCC_Tela         + '" | ' +
                         'Metodo: "'           + 'GET'                 + '" | ' +
                         'HttpStatusCode: "'   + IntToStr(LIdHTTP.ResponseCode)     + '" | ' +
                         'TempoDecorrido: "'   + IntToStr(MilliSecondsBetween(Now, LEnviadoEm)) + '"',
                         nil, 0, False, TCriticalLog.tlINFO);

          if (LStream.Size > 0) then
            LMensagemRet := 'Tela encontrada.'
          else
            LMensagemRet := 'Tela não encontrada.';

          TLogSQLite.New(tmInfo, clOperationRecord, LMensagemRet + ' - Retorno: ' + LIdHTTP.ResponseCode.ToString + ' - ' + LIdHTTP.ResponseText).Save;
          TLog.MyLogTemp(LMensagemRet + ' - Retorno: ' + LIdHTTP.ResponseCode.ToString + ' - ' + LIdHTTP.ResponseText, nil, 0, False, TCriticalLog.tlInfo);
          LStream.Position := 0;
          LStream.SaveToStream(ATela);
          Result := raOK;
          break;
        end;
      end;
      if Result <> raOK then
      begin
        AErroAPI.CodErro := -1;
        AErroAPI.MsgErro := 'Erro no evento "' + TAPIAspectSicsObterImagemTela.ClassName + '.Execute" / ' +
                            'URL: "' + LUrl_SCC_Tela + '"';

        TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
          .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroNegocio])
          .AddDetail('Evento'          , TAPIAspectSicsObterImagemTela.ClassName  )
          .AddDetail('Url'             , LUrl_SCC_Tela                      )
          .AddDetail('Metodo'          , 'POST'                             )
          .AddDetail('ErroCatalogado'  , AErroAPI.CodErro                   )
          .Save;
        TLog.MyLogTemp(AErroAPI.MsgErro, nil, 0, False, TCriticalLog.tlERROR);
      end;
    finally
    end;
  except on e:exception do
    begin
      Result := raException;
      AErroAPI.CodErro := -1;
      AErroAPI.MsgErro := 'Exception no evento "' + TAPIAspectSicsObterImagemTela.ClassName + '.Execute" / ' +
                          'URL: "' + LUrl_SCC_Tela + '" / ' +
                          'Erro: "' + E.Message + '"';

      TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
        .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raException])
        .AddDetail('Evento'          , TAPIAspectSicsObterImagemTela.ClassName                   )
        .AddDetail('Url'             , LUrl_SCC_Tela                    )
        .AddDetail('Metodo'          , 'Get'                            )
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
    TAPIAspectSicsObterImagemTela.URL := ReadString('APIs.Aspect.Sics',  'URL_ObterImagemTela', 'http://192.168.0.196:80/aspect/rest/Totem/ObterImagemTela/{{IdImagem}}/2');

    WriteString('APIs.Aspect.Sics', 'URL_ObterImagemTela',               TAPIAspectSicsObterImagemTela.URL);
  finally
    Free;
  end;
{$ENDIF}

end.