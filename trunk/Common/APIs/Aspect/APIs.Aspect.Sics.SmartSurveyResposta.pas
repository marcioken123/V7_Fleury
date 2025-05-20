unit APIs.Aspect.Sics.SmartSurveyResposta;

interface

uses
  APIs.Common, LogSQLite,System.Classes;

type
  TParametrosEntradaAPI = record
                            ID_Unidade     : integer;
                            ID_TOTEM       : integer;
                            ID_PERGUNTA    : integer;
                            ID_ALTERNATIVA : integer;
                            ID_DEVICE      : integer;
                            SENHA          : string;
                            GUID           : string;
                          end;

  TParametrosEntradaAPIBuscaFluxo = record
                                      PARAMETRO_PRONTUARIO : string;
                                      FLUXO                : string;
                                      FRESPONDIDADIAS      : integer;
                                      FIGNORADADIAS        : integer;
                                    end;
  TAPIAspectSicsSmartSurveyBuscaFluxo = class
  private


  public
    type TParametrosSaidaAPI = record
                                  ID_Alternativa  : integer;
                                  DATAHORA        : TDateTime;
                                  ID_UNIDADE      : string;
                                  STATUS          : integer;
                                end;
    class var URL : string;
    class function BuscarRespostaFluxo(const AParametrosEntrada : TParametrosEntradaAPIBuscaFluxo;out AParametrosSaida: TParametrosSaidaAPI; out AErroApi : TErroApi) : TTipoRetornoAPI;
  end;

  TAPIAspectSicsSmartSurveyResposta = class
  private


  public
    type TParametrosSaidaAPI = string;
    class var URL : string;
    class function GravarResposta(const AParametrosEntrada : TParametrosEntradaAPI;out AParametrosSaida: TParametrosSaidaAPI; out AErroApi : TErroApi) : TTipoRetornoAPI;
  end;

  TResposta           = class;
  TRespostaDet        = class;
  TArrayRespostaDet   = Array of TRespostaDet;

  TResposta = class
  private
    Fid: Integer;
    Falternativa_id: Integer;
    Fdevice_id: Integer;
    Funidade_id: Integer;
    Ftotem_id: Integer;
    Fsenha:string;
    Fdatahora: TDateTime;
    Fguid: String;
    Fdetalhes: TArrayRespostaDet;
  public

    property id             : Integer           read Fid             write Fid;
    property alternativa_id : Integer           read Falternativa_id write Falternativa_id;
    property device_id      : Integer           read Fdevice_id      write Fdevice_id;
    property unidade_id     : Integer           read Funidade_id     write Funidade_id;
    property totem_id       : Integer           read Ftotem_id       write Ftotem_id;
    property senha          : String            read Fsenha          write Fsenha;
    property datahora       : TDateTime         read Fdatahora       write Fdatahora;
    property guid           : String            read Fguid           write Fguid;
    property detalhes       : TArrayRespostaDet read Fdetalhes       write Fdetalhes;
  end;


  TRespostaDet = class
  private
    Fvalor: String;
    Fcampo: String;
  public
    property campo: String read Fcampo write Fcampo;
    property valor: String read Fvalor write Fvalor;
  end;

  TAlternativa = class
  private
    Fid: Integer;
    Ftexto: String;
    Fordem: Integer;
    Fcor: Integer;
    Fbtn_top: Integer;
    Fbtn_left: Integer;
    Fbtn_width: Integer;
    Fbtn_height: Integer;
    Fimg_pressionado: String;
    Fimg_normal: String;
    Fcampo: String;
    Ftipo: Integer;
  public
    property id             : Integer read Fid              write Fid;
    property texto          : String  read Ftexto           write Ftexto;
    property ordem          : Integer read Fordem           write Fordem;
    property cor            : Integer read Fcor             write Fcor;
    property btn_top        : Integer read Fbtn_top         write Fbtn_top;
    property btn_left       : Integer read Fbtn_left        write Fbtn_left;
    property btn_width      : Integer read Fbtn_width       write Fbtn_width;
    property btn_height     : Integer read Fbtn_height      write Fbtn_height;
    property img_normal     : String  read Fimg_normal      write Fimg_normal;
    property img_pressionado: String  read Fimg_pressionado write Fimg_pressionado;
    property campo          : String  read Fcampo           write Fcampo;
    property tipo           : Integer read Ftipo            write Ftipo;
  end;
  procedure PopularParametros;

implementation

uses
  IniFiles, System.SysUtils, System.Json, ufrmSicsTotemAA, untLog, controller.parametros,
  UDMPrincipal;

procedure PopularParametros;
begin
  TAPIAspectSicsSmartSurveyResposta.URL := controller.parametros.CarregarParametroStr('APIs.Aspect.Sics', 'URL_SmartSurveyResposta',  'http://10.32.10.21:80/aspect/rest/totem/EnviarRespostaPesquisaSatisfacao');
  TAPIAspectSicsSmartSurveyBuscaFluxo.URL := controller.parametros.CarregarParametroStr('APIs.Aspect.Sics', 'URL_SmartSurveyRespostaBuscaFluxo',  'http://10.32.10.21:80/aspect/rest/totem/BuscarRespostaPesquisaSatisfacaoFluxo');
end;

class function TAPIAspectSicsSmartSurveyResposta.GravarResposta(const AParametrosEntrada : TParametrosEntradaAPI;out AParametrosSaida: TParametrosSaidaAPI; out AErroApi : TErroApi) : TTipoRetornoAPI;
var
  LJSON : TJSONObject;
  LRetorno : String;
  FGUID: TGuid;
begin
  TLogSQLite.New(tmInfo, clResponse, 'Consumindo API EnviarRespostaPesquisaSatisfacao').Save;
  TLog.MyLogTemp('Consumindo API EnviarRespostaPesquisaSatisfacao', nil, 0, False, TCriticalLog.tlINFO);
  try
    try
      CreateGUID(FGUID);
      LJSON := TJSONObject.Create;
      LJSON.AddPair('PERGUNTA_ID', TJSONNumber.Create(AParametrosEntrada.ID_PERGUNTA));
      LJSON.AddPair('DEVICE_ID', TJSONNumber.Create(AParametrosEntrada.ID_TOTEM));
      LJSON.AddPair('UNIDADE_ID', TJSONNumber.Create(AParametrosEntrada.ID_UNIDADE));
      LJSON.AddPair('ALTERNATIVA_ID', TJSONNumber.Create(AParametrosEntrada.ID_ALTERNATIVA));
      LJSON.AddPair('GUID', GUIDToString(FGUID));
      LJSON.AddPair('SENHA', AParametrosEntrada.SENHA);
      Result := IntegracaoAPI_Post (URL, LJSON, LRetorno, AErroAPI, 3);

      if Result = raOK then
      begin
        if LRetorno <> '{"result":{"sucesso":false}}' then
        begin

          AErroApi.CodErro := 0;
          AErroApi.MsgErro := '';

          Result := raOK;
        end
        else
        begin
          Result := raErroNegocio;

          AErroApi.CodErro := -1;
          AErroApi.MsgErro := 'Erro no evento "' + Self.ClassName + '.Execute" / ' +
                              'URL: "' + URL + '" / ' +
                              'Enviado: "' + LJSON.ToJSON + '" / ' +
                              'Recebido: "' + LRetorno + '"';

          AParametrosSaida := '';

          TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
            .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroNegocio])
            .AddDetail('Evento'          , Self.ClassName                     )
            .AddDetail('Url'             , URL                                )
            .AddDetail('Metodo'          , 'POST'                             )
            .AddDetail('ConteudoEnviado' , LJson.ToString                     )
            .AddDetail('ConteudoRecebido', LRetorno                           )
            .AddDetail('ErroCatalogado'  , AErroApi.CodErro                   )
            .Save;
          TLog.MyLogTemp(AErroApi.MsgErro, nil, 0, False, TCriticalLog.tlERROR);
        end;
      end;
    except
      on E: Exception do
      begin
        Result := raException;
        AErroApi.CodErro := -1;
        AErroApi.MsgErro := 'Exception no evento "' + Self.ClassName + '.Execute" / ' +
                            'URL: "' + URL + '" / ' +
                            'Enviado: "' + LJSON.ToJSON + '" / ' +
                            'Recebido: "' + LRetorno + '" / ' +
                            'Erro: "' + E.Message + '"';

        TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
          .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raException])
          .AddDetail('Evento'          , Self.ClassName                   )
          .AddDetail('Url'             , URL                              )
          .AddDetail('Metodo'          , 'POST'                           )
          .AddDetail('ConteudoEnviado' , LJson.ToString                   )
          .AddDetail('ConteudoRecebido', LRetorno                         )
          .AddDetail('ErroCatalogado'  , AErroApi.CodErro                 )
          .AddDetail('ExceptionMessage', E.Message                        )
          .Save;
        TLog.MyLogTemp(AErroApi.MsgErro, nil, 0, False, TCriticalLog.tlERROR)
      end;
    end;
  finally
    FreeAndNil(LJSON);
  end;
end;

class function TAPIAspectSicsSmartSurveyBuscaFluxo.BuscarRespostaFluxo(const AParametrosEntrada : TParametrosEntradaAPIBuscaFluxo;out AParametrosSaida: TParametrosSaidaAPI; out AErroApi : TErroApi) : TTipoRetornoAPI;
var
  LJSON, LJSONResposta : TJSONObject;
  LRetorno : String;
  LIdAlternativa:integer;
  LDataHora:String;
  LStatus:integer;
  LUnidade: string;
  fs: TFormatSettings;
begin
  TLogSQLite.New(tmInfo, clResponse, 'Consumindo API BuscarRespostaPesquisaSatisfacaoFluxo').Save;
  TLog.MyLogTemp('Consumindo API BuscarRespostaPesquisaSatisfacaoFluxo', nil, 0, False, TCriticalLog.tlINFO);
  try
    try
      LJSON := TJSONObject.Create;
      LJSON.AddPair('PRONTUARIO', AParametrosEntrada.PARAMETRO_PRONTUARIO);
      LJSON.AddPair('UNIDADE', vgParametrosGlobais.IdUnidade);
      LJSON.AddPair('FLUXO', AParametrosEntrada.Fluxo);
      LJSON.AddPair('PRAZO_NAO_QUERO_OPINA', AParametrosEntrada.FIGNORADADIAS.ToString);
      LJSON.AddPair('PRAZO_OUTRAS_RESPOSTAS', AParametrosEntrada.FRESPONDIDADIAS.ToString);
      APIs.Common.FTimeout := 60000;
      Result := IntegracaoAPI_Post (URL, LJSON, LRetorno, AErroAPI, 3);
      APIs.Common.FTimeout := 0;
      LDataHora := EmptyStr;
      LIdAlternativa := 0;
      fs := TFormatSettings.Create;
      fs.DateSeparator := '/';
      fs.ShortDateFormat := 'DD/MM/YYYY';
      fs.TimeSeparator := ':';
      fs.ShortTimeFormat := 'hh:mm';
      fs.LongTimeFormat := 'hh:mm:ss';
      if Result = raOK then
      begin
        LJSONResposta := TJSONObject.ParseJSONValue(LRetorno) as TJSONObject;
        try
          if (LJSONResposta <> nil) then
          begin
            AErroApi.CodErro := 0;
            AErroApi.MsgErro := '';
            (LJSONResposta.GetValue<TJSONObject>('result') as TJSONObject).TryGetValue('DATAHORA', LDataHora);
            (LJSONResposta.GetValue<TJSONObject>('result') as TJSONObject).TryGetValue('ALTERNATIVA', LIdAlternativa);
            (LJSONResposta.GetValue<TJSONObject>('result') as TJSONObject).TryGetValue('STATUS', LStatus);
            (LJSONResposta.GetValue<TJSONObject>('result') as TJSONObject).TryGetValue('UNIDADE', LUnidade);
            AParametrosSaida.STATUS := LStatus;
            if LStatus = 1 then
            begin
              AParametrosSaida.ID_Alternativa := LIdAlternativa;
              AParametrosSaida.DATAHORA := StrToDateTime(LDataHora,fs);
              AParametrosSaida.ID_UNIDADE := LUnidade;
            end;
          end
          else
          begin
            Result := raErroNegocio;
          end;
        finally
          LJSONResposta.Free;
        end;
      end;
      if Result = raErroNegocio then
      begin
        AErroApi.CodErro := -1;
        AErroApi.MsgErro := 'Erro no evento "' + Self.ClassName + '.BuscarRespostaFluxo" / ' +
                            'URL: "' + URL + '" / ' +
                            'Enviado: "' + LJSON.ToJSON + '" / ' +
                            'Recebido: "' + LRetorno + '"';
        TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
          .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroNegocio])
          .AddDetail('Evento'          , Self.ClassName                     )
          .AddDetail('Url'             , URL                                )
          .AddDetail('Metodo'          , 'POST'                             )
          .AddDetail('ConteudoEnviado' , LJson.ToString                     )
          .AddDetail('ConteudoRecebido', LRetorno                           )
          .AddDetail('ErroCatalogado'  , AErroApi.CodErro                   )
          .Save;
        TLog.MyLogTemp(AErroApi.MsgErro, nil, 0, False, TCriticalLog.tlERROR);
      end;

    except
      on E: Exception do
      begin
        Result := raException;
        AErroApi.CodErro := -1;
        AErroApi.MsgErro := 'Exception no evento "' + Self.ClassName + '.BuscarRespostaFluxo" / ' +
                            'URL: "' + URL + '" / ' +
                            'Enviado: "' + LJSON.ToJSON + '" / ' +
                            'Recebido: "' + LRetorno + '" / ' +
                            'Erro: "' + E.Message + '"';

        TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
          .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raException])
          .AddDetail('Evento'          , Self.ClassName                   )
          .AddDetail('Url'             , URL                              )
          .AddDetail('Metodo'          , 'POST'                           )
          .AddDetail('ConteudoEnviado' , LJson.ToString                   )
          .AddDetail('ConteudoRecebido', LRetorno                         )
          .AddDetail('ErroCatalogado'  , AErroApi.CodErro                 )
          .AddDetail('ExceptionMessage', E.Message                        )
          .Save;
        TLog.MyLogTemp(AErroApi.MsgErro, nil, 0, False, TCriticalLog.tlERROR)
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
    TAPIAspectSicsSmartSurveyResposta.URL := ReadString ('APIs.Aspect.Sics.SmartSurveyResposta', 'URL',  'http://10.32.10.21:80/aspect/rest/totem/EnviarRespostaPesquisaSatisfacao');
    WriteString ('APIs.Aspect.Sics.SmartSurveyResposta', 'URL', TAPIAspectSicsSmartSurveyResposta.URL);
  finally
    Free;
  end;
{$ENDIF}
end.
