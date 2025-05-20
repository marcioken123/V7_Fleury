unit APIs.Aspect.Sics.DadosAdicionais;

interface

uses
  APIs.Common, LogSQLite;

type
  TParametrosEntradaGravarAPI = record
                                  SENHA: string;
                                  IDUnidade: integer;
                                  NOME: string;
                                  TELEFONE: string;
                                  PRONTUARIO: string;
                                  CODPROFISSIONAL: string;
                                  id: string;
                                  medicalRecord: string;
                                  document: string;
                                  passage: string;
                                  queue: string;
                                  password: string;
                                  IDPASSAGEM: string;
                                  LocalParRef:string;
                                  Idioma:string;
                                  idtrakcare:string;
                                  Fluxo:string;
                                end;
type
  TParametrosEntradaObterAPI = record
                                  SENHA: string;
                                  IDUnidade: integer;
                                end;
type
  TParametrosSaidaObterAPI =  record
                                NOME: string;
                                TELEFONE: string;
                                PRONTUARIO: string;
                                CODPROFISSIONAL: string;
                                id: string;
                                medicalRecord: string;
                                document: string;
                                passage: string;
                                queue: string;
                                password: string;
                                IDPASSAGEM: string;
                                LocalParRef: string;
                                Idioma: string;
                                idtrakcare: string;
                                Fluxo:string;
                              end;
type
  TAPIAspectSicsDadosAdicionais = class
  private
  public
    class var URL: string;
  end;
  function GravarDados(const AParametrosEntrada: TParametrosEntradaGravarAPI; out AErroAPI: TErroAPI): TTipoRetornoAPI;
  function ObterDados(const AParametrosEntrada: TParametrosEntradaObterAPI; out AParametrosSaida: TParametrosSaidaObterAPI; out AErroAPI: TErroAPI): TTipoRetornoAPI;
  procedure PopularParametros;

implementation

uses
{$IFDEF CompilarPara_TotemAA}
  controller.parametros,
{$ENDIF}
  IniFiles, System.SysUtils, System.JSON, untLog;

procedure PopularParametros;
begin
{$IFDEF CompilarPara_TotemAA}
  TAPIAspectSicsDadosAdicionais.URL := controller.parametros.CarregarParametroStr('APIs.Aspect.Sics', 'URL_DadosAdicionais', 'http://10.32.10.21:80/aspect/rest/senha/DadosAdicionais');
{$ENDIF}
end;

function GravarDados(
  const AParametrosEntrada: TParametrosEntradaGravarAPI;
  out AErroAPI: TErroAPI): TTipoRetornoAPI;
var
  LJSON: TJSONObject;
  JsonDadosAdicionais: TJSONObject;
  LRetorno: string;
begin
  TLogSQLite.New(tmInfo, clResponse, 'Consumindo API DadosAdicionais').Save;
  TLog.MyLogTemp('Consumindo API DadosAdicionais', nil, 0, False, TCriticalLog.tlINFO);
  try
    try
      LJSON := TJSONObject.Create;
      JsonDadosAdicionais := TJSONObject.Create;
      if AParametrosEntrada.TELEFONE <> EmptyStr then JsonDadosAdicionais.AddPair('TELEFONE', AParametrosEntrada.TELEFONE);
      if AParametrosEntrada.PRONTUARIO <> EmptyStr then JsonDadosAdicionais.AddPair('PRONTUARIO', AParametrosEntrada.PRONTUARIO);
      if AParametrosEntrada.CODPROFISSIONAL <> EmptyStr then JsonDadosAdicionais.AddPair('CODPROFISSIONAL', AParametrosEntrada.CODPROFISSIONAL);
      if AParametrosEntrada.NOME <> EmptyStr then JsonDadosAdicionais.AddPair('NOME', AParametrosEntrada.NOME);
      if AParametrosEntrada.id <> EmptyStr then JsonDadosAdicionais.AddPair('id', AParametrosEntrada.id);
      if AParametrosEntrada.medicalRecord <> EmptyStr then JsonDadosAdicionais.AddPair('medicalRecord', AParametrosEntrada.medicalRecord);
      if AParametrosEntrada.document <> EmptyStr then JsonDadosAdicionais.AddPair('document', AParametrosEntrada.document);
      if AParametrosEntrada.passage <> EmptyStr then JsonDadosAdicionais.AddPair('passage', AParametrosEntrada.passage);
      if AParametrosEntrada.queue <> EmptyStr then JsonDadosAdicionais.AddPair('queue', AParametrosEntrada.queue);
      if AParametrosEntrada.password <> EmptyStr then JsonDadosAdicionais.AddPair('password', AParametrosEntrada.password);
      if AParametrosEntrada.IDPASSAGEM <> EmptyStr then JsonDadosAdicionais.AddPair('IDPASSAGEM', AParametrosEntrada.IDPASSAGEM);
      if AParametrosEntrada.LocalParRef <> EmptyStr then JsonDadosAdicionais.AddPair('LOCALPARREF', AParametrosEntrada.LocalParRef);
      if AParametrosEntrada.Idioma <> EmptyStr then JsonDadosAdicionais.AddPair('IDIOMA', AParametrosEntrada.Idioma);
      if AParametrosEntrada.idtrakcare <> EmptyStr then JsonDadosAdicionais.AddPair('idtrakcare', AParametrosEntrada.idtrakcare);
      if AParametrosEntrada.Fluxo <> EmptyStr then JsonDadosAdicionais.AddPair('FLUXO', AParametrosEntrada.Fluxo);
      LJSON.AddPair('Senha', AParametrosEntrada.SENHA);
      LJSON.AddPair('Dados', JsonDadosAdicionais);
      LJSON.AddPair('IdUnidade', AParametrosEntrada.IDUnidade.ToString);
      Result := IntegracaoAPI_Post(TAPIAspectSicsDadosAdicionais.URL, LJSON,LRetorno, AErroAPI,1);
      if Result <> raOK then
      begin
        AErroAPI.CodErro := -1;
        AErroAPI.MsgErro := 'Exception no evento "' + TAPIAspectSicsDadosAdicionais.ClassName + '.Execute" / ' +
                            'URL: "' + TAPIAspectSicsDadosAdicionais.URL + '" / ' +
                            'Enviado: "' + LJSON.ToJSON + '"';

        TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
          .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raException])
          .AddDetail('Evento'          , TAPIAspectSicsDadosAdicionais.ClassName                   )
          .AddDetail('Url'             , TAPIAspectSicsDadosAdicionais.URL                              )
          .AddDetail('Metodo'          , 'POST'                           )
          .AddDetail('ConteudoEnviado' , LJSON.ToString                   )
          .AddDetail('ErroCatalogado'  , AErroAPI.CodErro                 )
          .Save;
        TLog.MyLogTemp(AErroAPI.MsgErro, nil, 0, False, TCriticalLog.tlERROR)
      end;
    finally
      LJSON.Free;
    end;
  except on e: Exception do
    begin
      Result := raException;
      AErroAPI.CodErro := -1;
      AErroAPI.MsgErro := 'Exception no evento "' + TAPIAspectSicsDadosAdicionais.ClassName + '.Execute" / ' +
                          'URL: "' + TAPIAspectSicsDadosAdicionais.URL + '" / ' +
                          'Enviado: "' + LJSON.ToJSON + '" / ' +
                          'Erro: "' + E.Message + '"';

      TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
        .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raException])
        .AddDetail('Evento'          , TAPIAspectSicsDadosAdicionais.ClassName                   )
        .AddDetail('Url'             , TAPIAspectSicsDadosAdicionais.URL                              )
        .AddDetail('Metodo'          , 'POST'                           )
        .AddDetail('ConteudoEnviado' , LJSON.ToString                   )
        .AddDetail('ErroCatalogado'  , AErroAPI.CodErro                 )
        .AddDetail('ExceptionMessage', E.Message                        )
        .Save;
      TLog.MyLogTemp(AErroAPI.MsgErro, nil, 0, False, TCriticalLog.tlERROR)

    end;
  end;

end;

function ObterDados(
  const AParametrosEntrada: TParametrosEntradaObterAPI;
  out AParametrosSaida: TParametrosSaidaObterAPI;
  out AErroAPI: TErroAPI): TTipoRetornoAPI;
var
  LUrl_SCC_DadosAcicionais:String;
  LJSON: TJSONObject;
  LRetorno: string;
  LNOME: string;
  LTELEFONE: string;
  LPRONTUARIO: string;
  LCODPROFISSIONAL: string;
  Lid: string;
  LmedicalRecord: string;
  Ldocument: string;
  Lpassage: string;
  Lqueue: string;
  Lpassword: string;
  LIDPASSAGEM: string;
  LLOCALPARREF: string;
  LIdioma: String;
  LIDTRAKCARE: string;
  LFLUXO: string;
begin
  TLogSQLite.New(tmInfo, clResponse, 'Consumindo API DadosAdicionais/ObterDados').Save;
  TLog.MyLogTemp('Consumindo API DadosAdicionais/ObterDados', nil, 0, False, TCriticalLog.tlINFO);
  LUrl_SCC_DadosAcicionais := TAPIAspectSicsDadosAdicionais.Url + '/' + AParametrosEntrada.SENHA + '/' + AParametrosEntrada.IdUnidade.ToString;
  try
    Result := IntegracaoAPI_Get(LUrl_SCC_DadosAcicionais, LRetorno, AErroAPI);
    LJSON := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(LRetorno), 0) as TJSONObject;
    try
      if LJSON.Values['result'] <> nil then
      begin
        LJSON := LJSON.GetValue<TJSONObject>('result') as TJSONObject;
        if LJSON.Values['dados'] <> nil then
        begin
          LJSON := LJSON.GetValue<TJSONObject>('dados') as TJSONObject;
          LJSON.TryGetValue('NOME',LNOME);
          LJSON.TryGetValue('TELEFONE',LTELEFONE);
          LJSON.TryGetValue('PRONTUARIO',LPRONTUARIO);
          LJSON.TryGetValue('CODPROFISSIONAL',LCODPROFISSIONAL);
          LJSON.TryGetValue('id',Lid);
          LJSON.TryGetValue('medicalRecord',LmedicalRecord);
          LJSON.TryGetValue('document',Ldocument);
          LJSON.TryGetValue('passage',Lpassage);
          LJSON.TryGetValue('queue',Lqueue);
          LJSON.TryGetValue('password',Lpassword);
          LJSON.TryGetValue('IDPASSAGEM',LIDPASSAGEM);
          LJSON.TryGetValue('LOCALPARREF',LLOCALPARREF);
          LJSON.TryGetValue('Idioma',LIdioma);
          LJSON.TryGetValue('idtrakcare',LIDTRAKCARE);
          LJSON.TryGetValue('FLUXO',LFLUXO);
          AParametrosSaida.NOME := LNOME;
          AParametrosSaida.TELEFONE := LTELEFONE;
          AParametrosSaida.PRONTUARIO := LPRONTUARIO;
          AParametrosSaida.CODPROFISSIONAL := LCODPROFISSIONAL;
          AParametrosSaida.id := Lid;
          AParametrosSaida.medicalRecord := LmedicalRecord;
          AParametrosSaida.document := Ldocument;
          AParametrosSaida.passage := Lpassage;
          AParametrosSaida.queue := Lqueue;
          AParametrosSaida.password := Lpassword;
          AParametrosSaida.IDPASSAGEM := LIDPASSAGEM;
          AParametrosSaida.LocalParRef := LLOCALPARREF;
          AParametrosSaida.Idioma := LIdioma;
          AParametrosSaida.idtrakcare := LIDTRAKCARE;
          AParametrosSaida.Fluxo := LFluxo;
          Result := raOK;
        end
        else
        begin
          Result := raErroNegocio;
        end;
      end
      else
      begin
        Result := raErroNegocio;
      end;
      if Result <> raOK then
      begin
        AErroAPI.CodErro := -1;
        AErroAPI.MsgErro := 'Exception no evento "' + TAPIAspectSicsDadosAdicionais.ClassName + '.Execute" / ' +
                            'URL: "' + TAPIAspectSicsDadosAdicionais.URL + '" / ' +
                            'Enviado: "' + LJSON.ToJSON + '"';

        TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
          .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raException])
          .AddDetail('Evento'          , TAPIAspectSicsDadosAdicionais.ClassName                   )
          .AddDetail('Url'             , TAPIAspectSicsDadosAdicionais.URL                              )
          .AddDetail('Metodo'          , 'POST'                           )
          .AddDetail('ConteudoEnviado' , LJSON.ToString                   )
          .AddDetail('ErroCatalogado'  , AErroAPI.CodErro                 )
          .Save;
        TLog.MyLogTemp(AErroAPI.MsgErro, nil, 0, False, TCriticalLog.tlERROR)
      end;
    finally
      LJSON.Free;
    end;

  except on e:exception do
    begin
      Result := raException;
      AErroAPI.CodErro := -1;
      AErroAPI.MsgErro := 'Exception no evento "' + TAPIAspectSicsDadosAdicionais.ClassName + '.Execute" / ' +
                          'URL: "' + TAPIAspectSicsDadosAdicionais.URL + '" / ' +
                          'Enviado: "' + LJSON.ToJSON + '" / ' +
                          'Erro: "' + E.Message + '"';

      TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
        .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raException])
        .AddDetail('Evento'          , TAPIAspectSicsDadosAdicionais.ClassName                   )
        .AddDetail('Url'             , TAPIAspectSicsDadosAdicionais.URL                              )
        .AddDetail('Metodo'          , 'POST'                           )
        .AddDetail('ConteudoEnviado' , LJSON.ToString                   )
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
    TAPIAspectSicsDadosAdicionais.URL := ReadString('APIs.Aspect.Sics.DadosAdicionais', 'URL', 'http://10.32.10.21:80/aspect/rest/senha/DadosAdicionais');
    WriteString('APIs.Aspect.Sics.DadosAdicionais', 'URL', TAPIAspectSicsDadosAdicionais.URL);
  finally
    Free;
  end;
{$ENDIF}
end.
