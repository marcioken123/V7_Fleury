unit APIs.Einstein.Hoobox;

interface

uses
  APIs.Common, LogSQLite, System.Classes, REST.Types, REST.Client, System.Net.Mime, System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent,FMX.Graphics;

type
  TParametrosEntradaAPIProvaDeVida =  record
                                        Foto:FMX.Graphics.TBitmap;
                                        FotoStream:TMemoryStream;
                                      end;
  TParametrosSaidaAPIProvaDeVida =  record
                                      Status:Boolean;
                                    end;
	TParametrosEntradaAPIConsultarPessoaData = record
                                              Data:string;
                                              Foto:FMX.Graphics.TBitmap;
                                              FotoStream:TMemoryStream;
                                              CodigoUnidade:string;
                                            end;
	TParametrosSaidaAPIConsultarPessoaData = record
                                            IdsTabela : string;
                                          end;
	TParametrosEntradaAPIConsultarPessoa = record
                                          IdTabela:integer;
                                        end;
	TParametrosSaidaAPIConsultarPessoa = record
                                        Status : boolean;
                                      end;

  TParametrosEntradaAPICadastrarPessoa =  record
                                        Foto: FMX.Graphics.TBitmap;
                                        FotoStream:TMemoryStream;
                                        IdTabela : integer;
                                        NomeUnidade: string;
                                        NomeTotem: string;
                                      end;
  TParametrosSaidaAPICadastrarPessoa =  record
                                      Status:Boolean;
                                    end;
  TParametrosEntradaAPIReconhecerFace =  record
                                        Foto: FMX.Graphics.TBitmap;
                                        FotoStream:TMemoryStream;
                                        IdTabela : integer;
                                      end;
  TParametrosSaidaAPIReconhecerFace =  record
                                      Status:Boolean;
                                    end;

procedure PopularParametros;

function ObterToken(out AToken: string; out AErroApi : TErroApi) : TTipoRetornoAPI;
function ProvaDeVida(const AParametrosEntrada:TParametrosEntradaAPIProvaDeVida; out AParametrosSaida: TParametrosSaidaAPIProvaDeVida; out AErroApi : TErroApi) : TTipoRetornoAPI;
function ConsultarPessoaData(const AParametrosEntrada:TParametrosEntradaAPIConsultarPessoaData; out AParametrosSaida: TParametrosSaidaAPIConsultarPessoaData; out AErroApi : TErroApi) : TTipoRetornoAPI;
function ConsultarPessoa(const AParametrosEntrada:TParametrosEntradaAPIConsultarPessoa; out AParametrosSaida: TParametrosSaidaAPIConsultarPessoa; out AErroApi : TErroApi) : TTipoRetornoAPI;
function CadastrarPessoa(const AParametrosEntrada:TParametrosEntradaAPICadastrarPessoa; out AParametrosSaida: TParametrosSaidaAPICadastrarPessoa; out AErroApi : TErroApi) : TTipoRetornoAPI;
function ReconhecerFace(const AParametrosEntrada:TParametrosEntradaAPIReconhecerFace; out AParametrosSaida: TParametrosSaidaAPIReconhecerFace; out AErroApi : TErroApi) : TTipoRetornoAPI;

implementation

uses
{$IFDEF CompilarPara_TotemAA}
  controller.parametros,
{$ENDIF}
  System.SysUtils, System.Json, untLog, ASPHTTPRequest,System.DateUtils,System.Types, System.StrUtils,Inifiles;

var
  URLHooboxToken : string;
  URLHooboxProvaDeVida : string;
  URLHooboxConsultarPessoa: string;
  URLHooboxConsultarPessoaData: string;
  URLHooboxCadastrarPessoa: string;
  URLHooboxReconhecerFace: string;
  Client_ID: string;
  Client_Secret: string;
  FToken: string;
  FDataHoraToken:TDateTime;
  FLogarFotos:Boolean;
procedure PopularParametros;
begin
{$IFDEF CompilarPara_TotemAA}
  URLHooboxToken              := controller.parametros.CarregarParametroStr('APIs.Einstein', 'URL_HooboxToken', 'http://10.33.1.27:20021/servico/siaf/cep/consultaragrupad');
  URLHooboxProvaDeVida        := controller.parametros.CarregarParametroStr('APIs.Einstein', 'URL_HooboxProvaDeVida', 'http://10.33.1.27:20021/servico/siaf/cep/consultaragrupad');
  URLHooboxCadastrarPessoa    := controller.parametros.CarregarParametroStr('APIs.Einstein', 'URL_HooboxCadastrarPessoa', 'http://10.33.1.27:20021/servico/siaf/cep/consultaragrupad');
  URLHooboxConsultarPessoa    := controller.parametros.CarregarParametroStr('APIs.Einstein', 'URL_HooboxConsultarPessoa', 'http://10.33.1.27:20021/servico/siaf/cep/consultaragrupad');
  URLHooboxConsultarPessoaData:= controller.parametros.CarregarParametroStr('APIs.Einstein', 'URL_HooboxConsultarPessoaData', 'http://10.33.1.27:20021/servico/siaf/cep/consultaragrupad');
  URLHooboxReconhecerFace     := controller.parametros.CarregarParametroStr('APIs.Einstein', 'URL_HooboxReconhecerFace', 'http://10.33.1.27:20021/servico/siaf/cep/consultaragrupad');
  Client_ID                   := controller.parametros.CarregarParametroStr('APIs.Einstein', 'Client_Id_Hoobox', '');
  Client_Secret               := controller.parametros.CarregarParametroStr('APIs.Einstein', 'Client_Secret_Hoobox', '');
{$ENDIF}
end;

function ObterToken(out AToken: string; out AErroApi : TErroApi) : TTipoRetornoAPI;
var
  LJSON, LJSONResposta  : TJSONObject;
  LRetorno              : string;
  LContentType          : string;
  LAccept               : string;
  LToken                : string;
begin
  TLogSQLite.New(tmInfo, clResponse, 'Consumindo API Hoobox.ObterToken').Save;
  TLog.MyLogTemp('Consumindo API Hoobox.ObterToken', nil, 0, False, TCriticalLog.tlINFO);
  LToken := EmptyStr;
  LJSON := TJSONObject.Create;
  try
    try
      LAccept := 'application/x-www-form-urlencoded';
      LContentType := 'application/x-www-form-urlencoded';

      LJSON.AddPair('grant_type', 'client_credentials');
      LJSON.AddPair('client_id', Client_ID);
      LJSON.AddPair('client_secret', Client_Secret);
      LToken := EmptyStr;
      Result := IntegracaoAPI_Post(URLHooboxToken, LAccept, LContentType, LJSON, LRetorno, AErroApi, 3);
      if (Result = raOK) then
      begin
        LJSONResposta := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(LRetorno), 0) as TJSONObject;
        try
          if (LJSONResposta <> nil) and (LJSONResposta.Values['access_token'] <> nil) then
          begin
            LJSONResposta.TryGetValue('access_token', LToken);
          end;
        finally
          LJSONResposta.Free;
        end;
        AToken := LToken;
      end;

      if Result = raErroNegocio then
      begin
        AErroApi.CodErro := -1;
        AErroApi.MsgErro := 'Erro no evento APIs.Einstein.Hoobox.ObterToken ' +
                            'URL: "' + URLHooboxToken + '" / ' +
                            'Enviado: "' + LJSON.ToJSON + '" / ' +
                            'Recebido: "' + LRetorno + '"';

        TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
          .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroNegocio]      )
          .AddDetail('Evento'          , 'APIs.Einstein.Hoobox.ObterToken'        )
          .AddDetail('Url'             , URLHooboxToken                           )
          .AddDetail('Metodo'          , 'POST'                                   )
          .AddDetail('ConteudoEnviado' , LJson.ToString                           )
          .AddDetail('ConteudoRecebido', LRetorno                                 )
          .AddDetail('ErroCatalogado'  , AErroApi.CodErro                         )
          .Save;
        TLog.MyLogTemp(AErroApi.MsgErro, nil, 0, False, TCriticalLog.tlERROR);
      end;
    except
      on E: Exception do
      begin
        Result := raException;
        AErroApi.CodErro := -1;
        AErroApi.MsgErro := 'Exception no evento APIs.Einstein.Hoobox.ObterToken ' +
                            'URL: "' + URLHooboxToken + '" / ' +
                            'Enviado: "' + LJSON.ToJSON + '" / ' +
                            'Recebido: "' + LRetorno + '" / ' +
                            'Erro: "' + E.Message + '"';

        TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
          .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raException]        )
          .AddDetail('Evento'          , 'APIs.Einstein.Hoobox.ObterToken'        )
          .AddDetail('Url'             , URLHooboxToken                           )
          .AddDetail('Metodo'          , 'POST'                                   )
          .AddDetail('ConteudoEnviado' , LJson.ToString                           )
          .AddDetail('ConteudoRecebido', LRetorno                                 )
          .AddDetail('ErroCatalogado'  , AErroApi.CodErro                         )
          .AddDetail('ExceptionMessage', E.Message                                )
          .Save;
        TLog.MyLogTemp(AErroApi.MsgErro, nil, 0, False, TCriticalLog.tlERROR)
      end;
    end;
  finally
    FreeAndNil(LJSON);
  end;
end;

function ProvaDeVida(const AParametrosEntrada:TParametrosEntradaAPIProvaDeVida; out AParametrosSaida: TParametrosSaidaAPIProvaDeVida; out AErroApi : TErroApi) : TTipoRetornoAPI;
var
 LParts: TMultipartFormData;
 LRetorno  : string;
 LFile:string;
 LJSONResposta:TJSONObject;
 LHeaders: TCustomHeader;
 LVidaValidada:Boolean;
 LErroApi : TErroApi;
 LMemoryStream: TMemoryStream;
begin
  TLogSQLite.New(tmInfo, clResponse, 'Consumindo API Hoobox.ProvaDeVida').Save;
  TLog.MyLogTemp('Consumindo API Hoobox.ProvaDeVida', nil, 0, False, TCriticalLog.tlINFO);
  if FToken.IsEmpty or (SecondsBetween(now,FDataHoraToken)>=300) then
  begin
    if ObterToken(FToken,LErroApi) = raOk then
    begin
      FDataHoraToken := Now;
    end
    else
    begin
      FToken := EmptyStr;
    end;
  end;
  if not FToken.IsEmpty then
  begin
    try
      LFile:= FormatDateTime('ddmmyyyyhhmmss',now)+'.jpg';
      LMemoryStream:= TMemoryStream.Create;
      LMemoryStream.Position := 0;
      if (AParametrosEntrada.FotoStream <> nil) and (AParametrosEntrada.FotoStream.Size > 0) then
      begin
        AParametrosEntrada.FotoStream.SaveToStream(LMemoryStream);
      end
      else
      begin
        AParametrosEntrada.Foto.SaveToStream(LMemoryStream);
      end;
      LVidaValidada:= False;
      LHeaders.Nome := 'Authorization';
      LHeaders.Valor :=  'Bearer ' + FToken;
      LParts := TMultipartFormData.Create;
      try
        LParts.AddStream('picture', LMemoryStream,LFile,'image/jpeg');
        Result := IntegracaoAPI_Post(URLHooboxProvaDeVida, LParts, LRetorno, LErroApi, 3, LHeaders);

        if (Result = raOK) then
        begin
          LJSONResposta := TJSONObject.ParseJSONValue(LRetorno) as TJSONObject;
          try
            if (LJSONResposta <> nil) and (LJSONResposta.Values['is_alive'] <> nil) then
            begin
              LJSONResposta.TryGetValue('is_alive', LVidaValidada);
            end;
          finally
            LJSONResposta.Free;
          end;
        end;
        if Result = raErroNegocio then
        begin
          AErroApi.CodErro := -1;
          AErroApi.MsgErro := 'Erro no evento APIs.Einstein.Hoobox.ProvaDeVida ' +
                              'URL: "' + URLHooboxProvaDeVida + '" / ' +
                              'Recebido: "' + LRetorno + '"';

          TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
            .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroNegocio]      )
            .AddDetail('Evento'          , 'APIs.Einstein.Hoobox.ProvaDeVida'       )
            .AddDetail('Url'             , URLHooboxProvaDeVida                     )
            .AddDetail('Metodo'          , 'POST'                                   )
            .AddDetail('ConteudoRecebido', LRetorno                                 )
            .AddDetail('ErroCatalogado'  , AErroApi.CodErro                         )
            .Save;
          TLog.MyLogTemp(AErroApi.MsgErro, nil, 0, False, TCriticalLog.tlERROR);
        end;
        if FLogarFotos then
        begin
          if LVidaValidada then
          begin
            ForceDirectories(ExtractFilePath(ParamStr(0)) + '\ProvaDeVida\True\');
            LMemoryStream.Position := 0;
            LMemoryStream.SaveToFile(ExtractFilePath(ParamStr(0)) + '\ProvaDeVida\True\' + LFile);
          end
          else
          begin
            ForceDirectories(ExtractFilePath(ParamStr(0)) + '\ProvaDeVida\False\');
            LMemoryStream.Position := 0;
            LMemoryStream.SaveToFile(ExtractFilePath(ParamStr(0)) + '\ProvaDeVida\False\' + LFile);
          end;
        end;
        AParametrosSaida.Status := LVidaValidada;
      except
        on E: Exception do
        begin
          Result := raException;
          AErroApi.CodErro := -1;
          AErroApi.MsgErro := 'Exception no evento APIs.Einstein.Hoobox.ProvaDeVida' +
                              'URL: "' + URLHooboxProvaDeVida + '" / ' +
                              'Recebido: "' + LRetorno + '" / ' +
                              'Erro: "' + E.Message + '"';

          TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
            .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raException]        )
            .AddDetail('Evento'          , 'APIs.Einstein.Hoobox.ProvaDeVida'       )
            .AddDetail('Url'             , URLHooboxProvaDeVida                     )
            .AddDetail('Metodo'          , 'POST'                                   )
            .AddDetail('ConteudoRecebido', LRetorno                  )
            .AddDetail('ErroCatalogado'  , AErroApi.CodErro                         )
            .AddDetail('ExceptionMessage', E.Message                                )
            .Save;
          TLog.MyLogTemp(AErroApi.MsgErro, nil, 0, False, TCriticalLog.tlERROR)
        end;
      end;
    finally
      LParts.DisposeOf;
      LParts := nil;
      LMemoryStream.DisposeOf;
      LMemoryStream := nil;
    end;
  end
  else
  begin
    Result := raErroNegocio;
    AErroApi.CodErro := -1;
    AErroApi.MsgErro := 'Erro no evento APIs.Einstein.Hoobox.ObterToken';
    TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
      .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroNegocio]      )
      .AddDetail('Evento'          , 'APIs.Einstein.Hoobox.ObterToken'        )
      .AddDetail('Url'             , URLHooboxToken                           )
      .AddDetail('Metodo'          , 'POST'                                   )
      .AddDetail('ErroCatalogado'  , AErroApi.CodErro                         )
      .Save;
    TLog.MyLogTemp(AErroApi.MsgErro, nil, 0, False, TCriticalLog.tlERROR);
  end;
end;

function ConsultarPessoaData(const AParametrosEntrada:TParametrosEntradaAPIConsultarPessoaData; out AParametrosSaida: TParametrosSaidaAPIConsultarPessoaData; out AErroApi : TErroApi) : TTipoRetornoAPI;
var
  LParts: TMultipartFormData;
  LRetorno  : string;
  LFile:string;
  LJSONResposta:TJSONObject;
  LJSONArray: TJSONArray;
  LHeaders: TCustomHeader;
  LErroApi : TErroApi;
  LVidaValidada: Boolean;
  LIdTabela:integer;
  LIdsTabela: string;
  LCodigosUnidades:TStringDynArray;
  LCountUnidades:integer;
  LCountRetorno:integer;
  LMemoryStream: TMemoryStream;
begin
  TLogSQLite.New(tmInfo, clResponse, 'Consumindo API Hoobox.ConsultarPessoaData').Save;
  TLog.MyLogTemp('Consumindo API Hoobox.ConsultarPessoaData', nil, 0, False, TCriticalLog.tlINFO);
  if FToken.IsEmpty or (SecondsBetween(now,FDataHoraToken)>=300) then
  begin
    if ObterToken(FToken,LErroApi) = raOk then
    begin
      FDataHoraToken := Now;
    end
    else
    begin
      FToken := EmptyStr;
    end;
  end;
  if not FToken.IsEmpty then
  begin
    try
      LFile:= FormatDateTime('ddmmyyyyhhmmss',now)+'.jpg';
      LMemoryStream:= TMemoryStream.Create;
      LMemoryStream.Position := 0;
      if (AParametrosEntrada.FotoStream <> nil) and (AParametrosEntrada.FotoStream.Size > 0) then
      begin
        AParametrosEntrada.FotoStream.SaveToStream(LMemoryStream);
      end
      else
      begin
        AParametrosEntrada.Foto.SaveToStream(LMemoryStream);
      end;
      LHeaders.Nome := 'Authorization';
      LHeaders.Valor :=  'Bearer ' + FToken;
      LVidaValidada:= False;
      LIdTabela:=0;
      LIdsTabela:=EmptyStr;
      LParts := TMultipartFormData.Create;
      LCodigosUnidades := SplitString(StringReplace(UpperCase(AParametrosEntrada.CodigoUnidade),',',';', [rfReplaceAll]), ';');
      try
        LJSONArray:= TJSONArray.Create;
        try
          for LCountUnidades := 0 to Pred(Length(LCodigosUnidades)) do
          begin
            LJSONArray.Add(LCodigosUnidades[LCountUnidades]);
          end;
          if LJSONArray.Count >= 1 then
          begin
            LParts.AddField('tags',String.Join(',',LCodigosUnidades));
          end
          else
          begin
            LParts.AddField('tags','TOTEM');
          end;
        finally
          LJSONArray.DisposeOf;
          LJSONArray := nil;
        end;
        LParts.AddField('date',AParametrosEntrada.Data);
        LParts.AddStream('picture', LMemoryStream,LFile,'image/jpeg');
        LParts.AddField('upload', 'true');
        Result := IntegracaoAPI_Post(URLHooboxConsultarPessoaData, LParts, LRetorno, LErroApi, 3, LHeaders);
        if (Result = raOK) then
        begin
          LJSONResposta := TJSONObject.ParseJSONValue(LRetorno) as TJSONObject;
          try
            if (LJSONResposta <> nil) and (LJSONResposta.Values['match'] <> nil) then
            begin
              LJSONResposta.TryGetValue('match', LVidaValidada);
              if LVidaValidada then
              begin
                if (LJSONResposta.Values['results'] <> nil) then
                begin
                  LJSONArray := LJSONResposta.GetValue<TJSONArray>('results') as TJSONArray;
                  for LCountRetorno := 0 to Pred(LJSONArray.Count) do
                  begin
                    LJSONResposta := (LJSONArray.Items[LCountRetorno] as TJSONObject);
                    if (LJSONResposta.Values['Person'] <> nil) then
                    begin
                      LJSONResposta.TryGetValue('Person', LJSONResposta);
                      if (LJSONResposta.Values['id_table'] <> nil) then
                      begin
                        LJSONResposta.TryGetValue('id_table', LIdTabela);
                      end;
                    end;
                    if not LIdsTabela.IsEmpty then LIdsTabela := LIdsTabela + ';';
                    LIdsTabela := LIdsTabela +  LIdTabela.ToString;
                  end;
                end;
              end;
            end;
          finally
            LJSONResposta.Free;
          end;
        end;
        if Result = raErroNegocio then
        begin
          AErroApi.CodErro := -1;
          AErroApi.MsgErro := 'Erro no evento APIs.Einstein.Hoobox.ConsultarPessoaData ' +
                              'URL: "' + URLHooboxConsultarPessoaData + '" / ' +
                              'Recebido: "' + LRetorno + '"';

          TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)'          )
            .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroNegocio]        )
            .AddDetail('Evento'          , 'APIs.Einstein.Hoobox.ConsultarPessoaData' )
            .AddDetail('Url'             , URLHooboxConsultarPessoaData               )
            .AddDetail('Metodo'          , 'POST'                                     )
            .AddDetail('ConteudoRecebido', LRetorno                                   )
            .AddDetail('ErroCatalogado'  , AErroApi.CodErro                           )
            .Save;
          TLog.MyLogTemp(AErroApi.MsgErro, nil, 0, False, TCriticalLog.tlERROR);
        end;
        if FLogarFotos then
        begin
          if not LIdsTabela.IsEmpty then
          begin
            ForceDirectories(ExtractFilePath(ParamStr(0)) + '\ConsultarAgendamento\True\');
            LMemoryStream.Position := 0;
            LMemoryStream.SaveToFile(ExtractFilePath(ParamStr(0)) + '\ConsultarAgendamento\True\' + LFile);
          end
          else
          begin
            ForceDirectories(ExtractFilePath(ParamStr(0)) + '\ConsultarAgendamento\False\');
            LMemoryStream.Position := 0;
            LMemoryStream.SaveToFile(ExtractFilePath(ParamStr(0)) + '\ConsultarAgendamento\False\' + LFile);
          end;
        end;
        AParametrosSaida.IdsTabela := LIdsTabela;
      except
        on E: Exception do
        begin
          Result := raException;
          AErroApi.CodErro := -1;
          AErroApi.MsgErro := 'Exception no evento APIs.Einstein.Hoobox.ConsultarPessoaData' +
                              'URL: "' + URLHooboxConsultarPessoaData + '" / ' +
                              'Recebido: "' + LRetorno + '" / ' +
                              'Erro: "' + E.Message + '"';

          TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
            .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raException]          )
            .AddDetail('Evento'          , 'APIs.Einstein.Hoobox.ConsultarPessoaData' )
            .AddDetail('Url'             , URLHooboxConsultarPessoaData               )
            .AddDetail('Metodo'          , 'POST'                                     )
            .AddDetail('ConteudoRecebido', LRetorno                                   )
            .AddDetail('ErroCatalogado'  , AErroApi.CodErro                           )
            .AddDetail('ExceptionMessage', E.Message                                  )
            .Save;
          TLog.MyLogTemp(AErroApi.MsgErro, nil, 0, False, TCriticalLog.tlERROR)
        end;
      end;
    finally
      LParts.DisposeOf;
      LParts := nil;
      LMemoryStream.DisposeOf;
      LMemoryStream := nil;
    end;
  end
  else
  begin
    Result := raErroNegocio;
    AErroApi.CodErro := -1;
    AErroApi.MsgErro := 'Erro no evento APIs.Einstein.Hoobox.ObterToken';
    TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
      .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroNegocio]      )
      .AddDetail('Evento'          , 'APIs.Einstein.Hoobox.ObterToken'        )
      .AddDetail('Url'             , URLHooboxToken                           )
      .AddDetail('Metodo'          , 'POST'                                   )
      .AddDetail('ErroCatalogado'  , AErroApi.CodErro                         )
      .Save;
    TLog.MyLogTemp(AErroApi.MsgErro, nil, 0, False, TCriticalLog.tlERROR);
  end;
end;

function ConsultarPessoa(const AParametrosEntrada:TParametrosEntradaAPIConsultarPessoa; out AParametrosSaida: TParametrosSaidaAPIConsultarPessoa; out AErroApi : TErroApi) : TTipoRetornoAPI;
var
  LRetorno      : string;
  LJSONResposta : TJSONObject;
  LJSONArray    : TJSONArray;
  LCount        : Integer;
  LCustomHeader : TCustomHeader;
  LErroApi      : TErroApi;
  LUrlConsulta  :string;
  LIdTabela     :Integer;
begin
  TLogSQLite.New(tmInfo, clResponse, 'Consumindo API Hoobox.ConsultaPessoa').Save;
  TLog.MyLogTemp('Consumindo API Hoobox.ConsultaPessoa', nil, 0, False, TCriticalLog.tlINFO);
  if FToken.IsEmpty or (SecondsBetween(now,FDataHoraToken)>=300) then
  begin
    if ObterToken(FToken,LErroApi) = raOk then
    begin
      FDataHoraToken := Now;
    end
    else
    begin
      FToken := EmptyStr;
    end;
  end;
  if not FToken.IsEmpty then
  begin
    try
      LUrlConsulta := URLHooboxConsultarPessoa + '?id=' + AParametrosEntrada.IdTabela.ToString;
      LCustomHeader.Nome := 'Authorization';
      LCustomHeader.Valor :=  'Bearer ' + FToken;
      LIdTabela:=0;
      Result := IntegracaoAPI_Get(LUrlConsulta, LRetorno, AErroAPI, LCustomHeader);
      if Result = raOK then
      begin
        LJSONResposta := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(LRetorno), 0) as TJSONObject;
        try
          if (LJSONResposta <> nil) and (LJSONResposta.Values['peopleList'] <> nil) then
          begin
            LJSONArray := LJSONResposta.GetValue<TJSONArray>('peopleList') as TJSONArray;
            LIdTabela := 0;
            if LJSONArray.Count = 1 then
            begin
              LJSONResposta := (LJSONArray.Items[0] as TJSONObject);
              if (LJSONResposta.Values['id_table'] <> nil) then
              begin
                LJSONResposta.TryGetValue('id_table', LIdTabela);
              end;
            end;
            AErroApi.CodErro := 0;
            AErroApi.MsgErro := '';

            Result := raOK;
          end
          else
          begin
            Result := raErroNegocio;

            AErroApi.CodErro := -1;
            AErroApi.MsgErro := 'Erro no evento APIs.Einstein.ConsultarPessoa.Execute. ' +
                                'URL: "' + LUrlConsulta + '" / ' +
                                'Recebido: "' + LRetorno + '"';

            TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
              .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroNegocio]               )
              .AddDetail('Evento'          , 'APIs.Einstein.ConsultarPessoa.Execute'         )
              .AddDetail('Url'             , LUrlConsulta                                      )
              .AddDetail('Metodo'          , 'POST'                                            )
              .AddDetail('ConteudoRecebido', LRetorno                                          )
              .AddDetail('ErroCatalogado'  , AErroApi.CodErro                                  )
              .Save;
            TLog.MyLogTemp(AErroApi.MsgErro, nil, 0, False, TCriticalLog.tlERROR);
          end;
          AParametrosSaida.Status := (LIdTabela = AParametrosEntrada.IdTabela);
        finally
          LJSONResposta.Free;
        end;
      end;
    except
      on E: Exception do
      begin
        Result := raException;
        AErroApi.CodErro := -1;
        AErroApi.MsgErro := 'Erro no evento APIs.Einstein.ConsultarPessoa.Execute. ' +
                            'URL: "' + LUrlConsulta + '" / ' +
                            'Recebido: "' + LRetorno + '"';

        TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
          .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroNegocio]               )
          .AddDetail('Evento'          , 'APIs.Einstein.ConsultarPessoa.Execute'         )
          .AddDetail('Url'             , LUrlConsulta                                      )
          .AddDetail('Metodo'          , 'POST'                                            )
          .AddDetail('ConteudoRecebido', LRetorno                                          )
          .AddDetail('ErroCatalogado'  , AErroApi.CodErro                                  )
          .Save;
        TLog.MyLogTemp(AErroApi.MsgErro, nil, 0, False, TCriticalLog.tlERROR);
      end;
    end;
  end;
end;

function CadastrarPessoa(const AParametrosEntrada:TParametrosEntradaAPICadastrarPessoa; out AParametrosSaida: TParametrosSaidaAPICadastrarPessoa; out AErroApi : TErroApi) : TTipoRetornoAPI;
var
  LParts: TMultipartFormData;
  LRetorno  : string;
  LFile:string;
  LJSONResposta:TJSONObject;
  LHeaders: TCustomHeader;
  LRESTClient: TNetHTTPClient;
  LRESTRequest: TNetHTTPRequest;
  LErroApi : TErroApi;
  LIdTabela     :Integer;
  LMemoryStream: TMemoryStream;
begin
  TLogSQLite.New(tmInfo, clResponse, 'Consumindo API Hoobox.CadastraPessoa').Save;
  TLog.MyLogTemp('Consumindo API Hoobox.CadastraPessoa', nil, 0, False, TCriticalLog.tlINFO);
  if FToken.IsEmpty or (SecondsBetween(now,FDataHoraToken)>=300) then
  begin
    if ObterToken(FToken,LErroApi) = raOk then
    begin
      FDataHoraToken := Now;
    end
    else
    begin
      FToken := EmptyStr;
    end;
  end;
  if not FToken.IsEmpty then
  begin
    try
      LFile:= FormatDateTime('ddmmyyyyhhmmss',now)+'.jpg';
      LMemoryStream:= TMemoryStream.Create;
      LMemoryStream.Position := 0;
      if (AParametrosEntrada.FotoStream <> nil) and (AParametrosEntrada.FotoStream.Size > 0) then
      begin
        AParametrosEntrada.FotoStream.SaveToStream(LMemoryStream);
      end
      else
      begin
        AParametrosEntrada.Foto.SaveToStream(LMemoryStream);
      end;
      LHeaders.Nome := 'Authorization';
      LHeaders.Valor :=  'Bearer ' + FToken;
      LIdTabela := 0;
      LParts := TMultipartFormData.Create;
      try
        LParts.AddField('id_table', AParametrosEntrada.IdTabela.ToString);
        LParts.AddField('totem_name', AParametrosEntrada.NomeTotem);
        LParts.AddField('registration_date_time',FormatDateTime('YYYY-MM-DD''T''HH:NN:SS-03:00',now));
        LParts.AddField('unit_name',AParametrosEntrada.NomeUnidade);
        LParts.AddStream('picture', LMemoryStream,LFile,'image/jpeg');
        Result := IntegracaoAPI_Post(URLHooboxCadastrarPessoa, LParts, LRetorno, LErroApi, 3, LHeaders);
        if (Result = raOK) then
        begin
          LJSONResposta := TJSONObject.ParseJSONValue(LRetorno) as TJSONObject;
          try
            if (LJSONResposta <> nil) and (LJSONResposta.Values['id_table'] <> nil) then
            begin
              LJSONResposta.TryGetValue('id_table', LIdTabela);
            end;
          finally
            LJSONResposta.Free;
          end;
        end;
        if Result = raErroNegocio then
        begin
          AErroApi.CodErro := -1;
          AErroApi.MsgErro := 'Erro no evento APIs.Einstein.Hoobox.CadastrarPessoa ' +
                              'URL: "' + URLHooboxCadastrarPessoa + '" / ' +
                              'Recebido: "' + LRetorno + '"';

          TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)'        )
            .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroNegocio]      )
            .AddDetail('Evento'          , 'APIs.Einstein.Hoobox.CadastrarPessoa'   )
            .AddDetail('Url'             , URLHooboxCadastrarPessoa                 )
            .AddDetail('Metodo'          , 'POST'                                   )
            .AddDetail('ConteudoRecebido', LRetorno                                 )
            .AddDetail('ErroCatalogado'  , AErroApi.CodErro                         )
            .Save;
          TLog.MyLogTemp(AErroApi.MsgErro, nil, 0, False, TCriticalLog.tlERROR);
        end;
        AParametrosSaida.Status := (LIdTabela = AParametrosEntrada.IdTabela);
      except
        on E: Exception do
        begin
          Result := raException;
          AErroApi.CodErro := -1;
          AErroApi.MsgErro := 'Exception no evento APIs.Einstein.Hoobox.CadastrarPessoa' +
                              'URL: "' + URLHooboxCadastrarPessoa + '" / ' +
                              'Recebido: "' + LRetorno + '" / ' +
                              'Erro: "' + E.Message + '"';

          TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
            .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raException]        )
            .AddDetail('Evento'          , 'APIs.Einstein.Hoobox.CadastrarPessoa'   )
            .AddDetail('Url'             , URLHooboxCadastrarPessoa                 )
            .AddDetail('Metodo'          , 'POST'                                   )
            .AddDetail('ConteudoRecebido', LRetorno                                 )
            .AddDetail('ErroCatalogado'  , AErroApi.CodErro                         )
            .AddDetail('ExceptionMessage', E.Message                                )
            .Save;
          TLog.MyLogTemp(AErroApi.MsgErro, nil, 0, False, TCriticalLog.tlERROR)
        end;
      end;
    finally
      LParts.DisposeOf;
      LParts := nil;
      LRESTClient.DisposeOf;
      LRESTClient := nil;
      LRESTRequest.DisposeOf;
      LRESTRequest := nil;
      LMemoryStream.DisposeOf;
      LMemoryStream := nil;
    end;
  end
  else
  begin
    Result := raErroNegocio;
    AErroApi.CodErro := -1;
    AErroApi.MsgErro := 'Erro no evento APIs.Einstein.Hoobox.ObterToken';
    TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
      .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroNegocio]      )
      .AddDetail('Evento'          , 'APIs.Einstein.Hoobox.ObterToken'        )
      .AddDetail('Url'             , URLHooboxToken                           )
      .AddDetail('Metodo'          , 'POST'                                   )
      .AddDetail('ErroCatalogado'  , AErroApi.CodErro                         )
      .Save;
    TLog.MyLogTemp(AErroApi.MsgErro, nil, 0, False, TCriticalLog.tlERROR);
  end;
end;

function ReconhecerFace(const AParametrosEntrada:TParametrosEntradaAPIReconhecerFace; out AParametrosSaida: TParametrosSaidaAPIReconhecerFace; out AErroApi : TErroApi) : TTipoRetornoAPI;
var
 LParts: TMultipartFormData;
 LRetorno  : String;
 LFile:string;
 LJSONResposta:TJSONObject;
 LHeaders: TCustomHeader;
 LVidaValidada:Boolean;
 LErroApi : TErroApi;
 LMemoryStream: TMemoryStream;
begin
  TLogSQLite.New(tmInfo, clResponse, 'Consumindo API Hoobox.ReconhecerFace').Save;
  TLog.MyLogTemp('Consumindo API Hoobox.ReconhecerFace', nil, 0, False, TCriticalLog.tlINFO);
  if FToken.IsEmpty or (SecondsBetween(now,FDataHoraToken)>=300) then
  begin
    if ObterToken(FToken,LErroApi) = raOk then
    begin
      FDataHoraToken := Now;
    end
    else
    begin
      FToken := EmptyStr;
    end;
  end;
  if not FToken.IsEmpty then
  begin
    try
      LFile:= FormatDateTime('ddmmyyyyhhmmss',now)+'.jpg';
      LMemoryStream:= TMemoryStream.Create;
      LMemoryStream.Position := 0;
      if (AParametrosEntrada.FotoStream <> nil) and (AParametrosEntrada.FotoStream.Size > 0) then
      begin
        AParametrosEntrada.FotoStream.SaveToStream(LMemoryStream);
      end
      else
      begin
        AParametrosEntrada.Foto.SaveToStream(LMemoryStream);
      end;
      LHeaders.Nome := 'Authorization';
      LHeaders.Valor :=  'Bearer ' + FToken;
      LParts := TMultipartFormData.Create;
      try
        LParts.AddField('id_table', AParametrosEntrada.IdTabela.ToString);
        LParts.AddStream('picture', LMemoryStream,LFile,'image/jpeg');
        Result := IntegracaoAPI_Post(URLHooboxReconhecerFace, LParts, LRetorno, LErroApi, 3, LHeaders);

        if (Result = raOK) then
        begin
          LJSONResposta := TJSONObject.ParseJSONValue(LRetorno) as TJSONObject;
          try
            if (LJSONResposta <> nil) and (LJSONResposta.Values['match'] <> nil) then
            begin
              LJSONResposta.TryGetValue('match', LVidaValidada);
            end;
          finally
            LJSONResposta.Free;
          end;
        end;

        if Result = raErroNegocio then
        begin
          AErroApi.CodErro := -1;
          AErroApi.MsgErro := 'Erro no evento APIs.Einstein.Hoobox.ReconhecerFace ' +
                              'URL: "' + URLHooboxReconhecerFace + '" / ' +
                              'Recebido: "' + LRetorno + '"';

          TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
            .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroNegocio]      )
            .AddDetail('Evento'          , 'APIs.Einstein.Hoobox.ReconhecerFace'       )
            .AddDetail('Url'             , URLHooboxReconhecerFace                     )
            .AddDetail('Metodo'          , 'POST'                                   )
            .AddDetail('ConteudoRecebido', LRetorno                  )
            .AddDetail('ErroCatalogado'  , AErroApi.CodErro                         )
            .Save;
          TLog.MyLogTemp(AErroApi.MsgErro, nil, 0, False, TCriticalLog.tlERROR);
        end;
        AParametrosSaida.Status := LVidaValidada;
      except
        on E: Exception do
        begin
          Result := raException;
          AErroApi.CodErro := -1;
          AErroApi.MsgErro := 'Exception no evento APIs.Einstein.Hoobox.ReconhecerFace' +
                              'URL: "' + URLHooboxReconhecerFace + '" / ' +
                              'Recebido: "' + LRetorno + '" / ' +
                              'Erro: "' + E.Message + '"';

          TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
            .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raException]        )
            .AddDetail('Evento'          , 'APIs.Einstein.Hoobox.ReconhecerFace'       )
            .AddDetail('Url'             , URLHooboxReconhecerFace                     )
            .AddDetail('Metodo'          , 'POST'                                   )
            .AddDetail('ConteudoRecebido', LRetorno                  )
            .AddDetail('ErroCatalogado'  , AErroApi.CodErro                         )
            .AddDetail('ExceptionMessage', E.Message                                )
            .Save;
          TLog.MyLogTemp(AErroApi.MsgErro, nil, 0, False, TCriticalLog.tlERROR)
        end;
      end;
    finally
      LParts.DisposeOf;
      LParts := nil;
      LMemoryStream.DisposeOf;
      LMemoryStream := nil;
    end;
  end
  else
  begin
    Result := raErroNegocio;
    AErroApi.CodErro := -1;
    AErroApi.MsgErro := 'Erro no evento APIs.Einstein.Hoobox.ObterToken';
    TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
      .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroNegocio]      )
      .AddDetail('Evento'          , 'APIs.Einstein.Hoobox.ObterToken'        )
      .AddDetail('Url'             , URLHooboxToken                           )
      .AddDetail('Metodo'          , 'POST'                                   )
      .AddDetail('ErroCatalogado'  , AErroApi.CodErro                         )
      .Save;
    TLog.MyLogTemp(AErroApi.MsgErro, nil, 0, False, TCriticalLog.tlERROR);
  end;
end;

initialization
{$IFNDEF CompilarPara_TotemAA}
  with TIniFile.Create(IncludeTrailingPathDelimiter(System.SysUtils.GetCurrentDir) + StringReplace(ExtractFileName(ParamStr(0)), '.exe', '.ini', [rfReplaceAll])) do
  try
    URLHooboxToken              := ReadString('EndPoints',  'URL_HooboxToken',              'https://sso.homol.hoobox.one/auth/realms/hoobox/protocol/openid-connect/token');
    URLHooboxProvaDeVida        := ReadString('EndPoints',  'URL_HooboxProvaDeVida',        'https://hiae-api.homol.hoobox.one/api/person/liveness');
    URLHooboxCadastrarPessoa    := ReadString('EndPoints',  'URL_HooboxCadastrarPessoa',    'https://hiae-api.homol.hoobox.one/api/person');
    URLHooboxConsultarPessoa    := ReadString('EndPoints',  'URL_HooboxConsultarPessoa',    'https://hiae-api.homol.hoobox.one/api/person');
    URLHooboxConsultarPessoaData:= ReadString('EndPoints',  'URL_HooboxConsultarPessoaData','https://hiae-api.homol.hoobox.one/api/appointment/match');
    URLHooboxReconhecerFace     := ReadString('EndPoints',  'URL_HooboxReconhecerFace',     'https://hiae-api.homol.hoobox.one/api/person/facematch');
    Client_ID                   := ReadString('Hoobox',     'Client_Id',                    EmptyStr);
    Client_Secret               := ReadString('Hoobox',     'Client_Secret',                EmptyStr);
    FLogarFotos                 := (ReadString('Settings',   'LogarFotos',                   '0')) = '1';

    WriteString('EndPoints', 'URL_HooboxToken',               URLHooboxToken);
    WriteString('EndPoints', 'URL_HooboxProvaDeVida',         URLHooboxProvaDeVida);
    WriteString('EndPoints', 'URL_HooboxCadastrarPessoa',     URLHooboxCadastrarPessoa);
    WriteString('EndPoints', 'URL_HooboxConsultarPessoa',     URLHooboxConsultarPessoa);
    WriteString('EndPoints', 'URL_HooboxConsultarPessoaData', URLHooboxConsultarPessoaData);
    WriteString('EndPoints', 'URL_HooboxReconhecerFace',      URLHooboxReconhecerFace);
    WriteString('Hoobox',    'Client_Id',                     Client_ID);
    WriteString('Hoobox',    'Client_Secret',                 Client_Secret);
  finally
    Free;
  end;
{$ENDIF}

end.