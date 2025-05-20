unit APIs.Aspect.Sics.SicsHooboxService;

interface

uses
{$IFNDEF IS_MOBILE}
  LogSQLite,
{$ENDIF IS_MOBILE}
  APIs.Common,
  System.Classes, REST.Types, REST.Client, System.Net.Mime,
  System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent,FMX.Graphics,
  IniFiles, Providers.Consts;

type
  TParametrosEntradaAPIPacienteConsultar =  record
                                        ValorCampoPesquisa:string;
                                        TipoCampoPesquisa:string;
                                        IdDispositivo:string;
                                      end;
  TParametrosEntradaAPIProvaDeVida =  record
                                        Foto:FMX.Graphics.TBitmap;
                                        IdDispositivo:string;
                                      end;
  TParametrosSaidaAPIProvaDeVida =  record
                                      Status:Boolean;
                                    end;
	TParametrosEntradaAPIConsultarPessoaData =  record
                                                Data:string;
                                                Foto:FMX.Graphics.TBitmap;
                                                CodigoUnidade:string;
                                                IdDispositivo:string;
                                              end;
	TParametrosSaidaAPIConsultarPessoaData =  record
                                              IdsTabela : string;
                                            end;
	TParametrosEntradaAPIConsultarPessoa =  record
                                            IdTabela:integer;
                                            IdDispositivo:string;
                                          end;
	TParametrosSaidaAPIConsultarPessoa =  record
                                          Status : boolean;
                                        end;
  TParametrosEntradaAPICadastrarPessoa =  record
                                            Foto: FMX.Graphics.TBitmap;
                                            IdTabela : integer;
                                            NomeUnidade: string;
                                            NomeTotem: string;
                                            IdDispositivo:string;
                                          end;
  TParametrosSaidaAPICadastrarPessoa =  record
                                          Status:Boolean;
                                        end;
  TParametrosEntradaAPIReconhecerFace = record
                                          Foto: FMX.Graphics.TBitmap;
                                          IdTabela : integer;
                                          IdDispositivo:string;
                                        end;
  TParametrosSaidaAPIReconhecerFace = record
                                        Status:Boolean;
                                      end;
  TParametrosEntradaAPIObterImagemTela =  record
                                            IdImagem:Integer;
                                            IdDispositivo:string;
                                          end;
var
  URLSicsHooboxProvaDeVida : string;
  URLSicsHooboxConsultarPessoa: string;
  URLSicsHooboxConsultarPessoaData: string;
  URLSicsHooboxCadastrarPessoa: string;
  URLSicsHooboxReconhecerFace: string;
  URLSicsPacienteConsultar: string;
  URLSicsObterImagemTela: string;

procedure PopularParametros;

function ProvaDeVida(const AParametrosEntrada:TParametrosEntradaAPIProvaDeVida; out AParametrosSaida: TParametrosSaidaAPIProvaDeVida; out AErroApi : TErroApi) : TTipoRetornoAPI;
function ConsultarPessoaData(const AParametrosEntrada:TParametrosEntradaAPIConsultarPessoaData; out AParametrosSaida: TParametrosSaidaAPIConsultarPessoaData; out AErroApi : TErroApi) : TTipoRetornoAPI;
function ConsultarPessoa(const AParametrosEntrada:TParametrosEntradaAPIConsultarPessoa; out AParametrosSaida: TParametrosSaidaAPIConsultarPessoa; out AErroApi : TErroApi) : TTipoRetornoAPI;
function CadastrarPessoa(const AParametrosEntrada:TParametrosEntradaAPICadastrarPessoa; out AParametrosSaida: TParametrosSaidaAPICadastrarPessoa; out AErroApi : TErroApi) : TTipoRetornoAPI;
function ReconhecerFace(const AParametrosEntrada:TParametrosEntradaAPIReconhecerFace; out AParametrosSaida: TParametrosSaidaAPIReconhecerFace; out AErroApi : TErroApi) : TTipoRetornoAPI;
function PacienteConsultar(const AParametrosEntrada:TParametrosEntradaAPIPacienteConsultar; out AParametrosSaida: string; out AErroApi : TErroApi) : TTipoRetornoAPI;
function ObterImagemTela(const AParametrosEntrada:TParametrosEntradaAPIObterImagemTela; out AParametrosSaida: FMX.Graphics.TBitmap; out AErroApi : TErroApi) : TTipoRetornoAPI;

implementation

uses
{$IFDEF CompilarPara_TotemAA}
  controller.parametros,
{$ENDIF}
{$IFNDEF IS_MOBILE}
untLog,
{$ENDIF IS_MOBILE}
  System.SysUtils, System.Json, ASPHTTPRequest,System.DateUtils,System.Types, System.StrUtils;

procedure PopularParametros;
begin
{$IFDEF CompilarPara_TotemAA}
  URLHooboxProvaDeVida            := controller.parametros.CarregarParametroStr('APIs.SicsHooboxService', 'URL_SicsHooboxProvaDeVida', 'http://10.33.1.27:20021/servico/siaf/cep/consultaragrupad');
  URLHooboxCadastrarPessoa        := controller.parametros.CarregarParametroStr('APIs.SicsHooboxService', 'URL_SicsHooboxCadastrarPessoa', 'http://10.33.1.27:20021/servico/siaf/cep/consultaragrupad');
  URLHooboxConsultarPessoa        := controller.parametros.CarregarParametroStr('APIs.SicsHooboxService', 'URL_SicsHooboxConsultarPessoa', 'http://10.33.1.27:20021/servico/siaf/cep/consultaragrupad');
  URLHooboxConsultarPessoaData    := controller.parametros.CarregarParametroStr('APIs.SicsHooboxService', 'URL_SicsHooboxConsultarPessoaData', 'http://10.33.1.27:20021/servico/siaf/cep/consultaragrupad');
  URLHooboxReconhecerFace         := controller.parametros.CarregarParametroStr('APIs.SicsHooboxService', 'URL_SicsHooboxReconhecerFace', 'http://10.33.1.27:20021/servico/siaf/cep/consultaragrupad');
  URLSicsPacienteConsultar        := controller.parametros.CarregarParametroStr('APIs.SicsHooboxService', 'URL_SicsPacienteConsultar', 'http://10.33.1.27:20021/servico/siaf/cep/consultaragrupad');
  URLSicsObterImagemTela          := controller.parametros.CarregarParametroStr('APIs.SicsHooboxService', 'URL_SicsObterImagemTela', 'http://10.33.1.27:20021/servico/siaf/cep/consultaragrupad');
  Client_ID                       := controller.parametros.CarregarParametroStr('APIs.SicsHooboxService', 'Client_Id', '');
  Client_Secret                   := controller.parametros.CarregarParametroStr('APIs.SicsHooboxService', 'Client_Secret', '');
{$ENDIF}
end;

function ProvaDeVida(const AParametrosEntrada:TParametrosEntradaAPIProvaDeVida; out AParametrosSaida: TParametrosSaidaAPIProvaDeVida; out AErroApi : TErroApi) : TTipoRetornoAPI;
var
 LParts: TMultipartFormData;
 LRetorno  : string;
 LFile:string;
 LJSONResposta:TJSONObject;
 LVidaValidada:Boolean;
 LHeaders: TCustomHeader;
 LErroApi : TErroApi;
 LMemoryStream: TMemoryStream;
begin
  try
    LFile:= FormatDateTime('ddmmyyyyhhmmss',now)+'.jpg';
    LMemoryStream:= TMemoryStream.Create;
    LMemoryStream.Position := 0;
    AParametrosEntrada.Foto.SaveToStream(LMemoryStream);
    LVidaValidada:= False;
    LHeaders.Nome := 'Authorization';
    LHeaders.Valor :=  'Bearer';
    LParts := TMultipartFormData.Create;
    try
      LParts.AddStream('picture', LMemoryStream,LFile,'image/jpeg');
      LParts.AddField('tentativas','1');
      LParts.AddField('iddispositivo',AParametrosEntrada.IdDispositivo);
      Result := IntegracaoAPI_Post(URLSicsHooboxProvaDeVida, LParts, LRetorno, LErroApi,  3, LHeaders);

      if (Result = raOK) then
      begin
        LJSONResposta := TJSONObject.ParseJSONValue(LRetorno) as TJSONObject;
        try
          if (LJSONResposta <> nil) and (LJSONResposta.Values['Status'] <> nil) then
          begin
            LJSONResposta.TryGetValue('Status', LVidaValidada);
          end;
        finally
          LJSONResposta.Free;
        end;
      end;
      if Result = raErroNegocio then
      begin
      end;
      AParametrosSaida.Status := LVidaValidada;
    except
      on E: Exception do
      begin
        Result := raException;
        AParametrosSaida.Status := LVidaValidada;
      end;
    end;
  finally
    LParts.DisposeOf;
    LParts := nil;
    LMemoryStream.DisposeOf;
    LMemoryStream := nil;
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
  LIdsTabela:string;
  LCodigosUnidades:TStringDynArray;
  LCountUnidades:integer;
  LRetornoIds:TStringDynArray;
  LCountRetorno:integer;
  LMemoryStream: TMemoryStream;
begin
  try
    LFile:= FormatDateTime('ddmmyyyyhhmmss',now)+'.jpg';
    LMemoryStream:= TMemoryStream.Create;
    LMemoryStream.Position := 0;
    AParametrosEntrada.Foto.SaveToStream(LMemoryStream);

    LHeaders.Nome := 'Authorization';
    LHeaders.Valor :=  'Bearer';
    LIdsTabela:= EmptyStr;
    LParts := TMultipartFormData.Create;
    LCodigosUnidades := SplitString(StringReplace(UpperCase(AParametrosEntrada.CodigoUnidade),',',';', [rfReplaceAll]), ';');
    try
      LJSONArray:= TJSONArray.Create;
      try
        for LCountUnidades := 0 to Pred(Length(LCodigosUnidades)) do
        begin
          LJSONArray.Add(LCodigosUnidades[LCountUnidades]);
        end;
        if LJSONArray.Count > 0 then
        begin
          LParts.AddField('tags',String.Join(',',LCodigosUnidades));
        end
        else
        begin
          LParts.AddField('tag','TOTEM');
        end;
      finally
        LJSONArray.DisposeOf;
        LJSONArray := nil;
      end;
      LParts.AddField('date', AParametrosEntrada.Data);
      LParts.AddStream('picture', LMemoryStream,LFile,'image/jpeg');
      LParts.AddField('tentativas','1');
      LParts.AddField('iddispositivo',AParametrosEntrada.IdDispositivo);
      Result := IntegracaoAPI_Post(URLSicsHooboxConsultarPessoaData, LParts, LRetorno, LErroApi, 3, LHeaders);
      if (Result = raOK) then
      begin
        LJSONResposta := TJSONObject.ParseJSONValue(LRetorno) as TJSONObject;
        try
          if (LJSONResposta <> nil) and (LJSONResposta.Values['IdsTabela'] <> nil) then
          begin
            LJSONResposta.TryGetValue('IdsTabela', LIdsTabela);
          end;
        finally
          LJSONResposta.Free;
        end;
      end;
      AParametrosSaida.IdsTabela := LIdsTabela;
    except
      on E: Exception do
      begin
        Result := raException;
      end;
    end;
  finally
    LParts.DisposeOf;
    LParts := nil;
    LMemoryStream.DisposeOf;
    LMemoryStream := nil;
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
  try
    LUrlConsulta := URLSicsHooboxConsultarPessoa + '?id=' + AParametrosEntrada.IdTabela.ToString;
    LCustomHeader.Nome := 'Authorization';
    LCustomHeader.Valor :=  'Bearer';
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
  try
    LFile:= FormatDateTime('ddmmyyyyhhmmss',now)+'.jpg';
    LMemoryStream:= TMemoryStream.Create;
    LMemoryStream.Position := 0;
    AParametrosEntrada.Foto.SaveToStream(LMemoryStream);

    LHeaders.Nome := 'Authorization';
    LHeaders.Valor :=  'Bearer';
    LIdTabela := 0;
    LParts := TMultipartFormData.Create;

    try
      LParts.AddField('id_table', AParametrosEntrada.IdTabela.ToString);
      LParts.AddField('totem_name', AParametrosEntrada.NomeTotem);
      LParts.AddField('registration_date_time',FormatDateTime('YYYY-MM-DD''T''HH:NN:SS-03:00',now));
      LParts.AddField('unit_name',AParametrosEntrada.NomeUnidade);
      LParts.AddStream('picture', LMemoryStream,LFile,'image/jpeg');
      Result := IntegracaoAPI_Post(URLSicsHooboxCadastrarPessoa, LParts, LRetorno, LErroApi, 3, LHeaders);
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
      AParametrosSaida.Status := (LIdTabela = AParametrosEntrada.IdTabela);
    except
      on E: Exception do
      begin
        Result := raException;
        AParametrosSaida.Status := (LIdTabela = AParametrosEntrada.IdTabela);
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
  try
    LFile:= FormatDateTime('ddmmyyyyhhmmss',now)+'.jpg';
    LMemoryStream:= TMemoryStream.Create;
    LMemoryStream.Position := 0;
    AParametrosEntrada.Foto.SaveToStream(LMemoryStream);

    LHeaders.Nome := 'Authorization';
    LHeaders.Valor :=  'Bearer';

    LParts := TMultipartFormData.Create;

    try
      LParts.AddField('id_table', AParametrosEntrada.IdTabela.ToString);
      LParts.AddStream('picture', LMemoryStream,LFile,'image/jpeg');
      Result := IntegracaoAPI_Post(URLSicsHooboxReconhecerFace, LParts, LRetorno, LErroApi, 3, LHeaders);

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
      AParametrosSaida.Status := LVidaValidada;
    except
      on E: Exception do
      begin
        Result := raException;
        AParametrosSaida.Status := LVidaValidada;
      end;
    end;
  finally
    LParts.DisposeOf;
    LParts := nil;
    LMemoryStream.DisposeOf;
    LMemoryStream := nil;
  end;
end;

function PacienteConsultar(const AParametrosEntrada:TParametrosEntradaAPIPacienteConsultar; out AParametrosSaida: string; out AErroApi : TErroApi) : TTipoRetornoAPI;
var
  LParts: TMultipartFormData;
  LHeaders: TCustomHeader;
  LVidaValidada:Boolean;
  LErroApi : TErroApi;
  LIdTabela: string;
begin
  try
    LHeaders.Nome := 'Authorization';
    LHeaders.Valor :=  'Bearer';
    LParts := TMultipartFormData.Create;
    try
      LParts.AddField('TipoCampoPesquisa', AParametrosEntrada.TipoCampoPesquisa);
      LParts.AddField('ValorCampoPesquisa',AParametrosEntrada.ValorCampoPesquisa);
      LParts.AddField('iddispositivo',AParametrosEntrada.IdDispositivo);
      Result := IntegracaoAPI_Post(URLSicsPacienteConsultar, LParts, LIdTabela, LErroApi, 3, LHeaders);
      if (Result = raOK) then
      begin
        AParametrosSaida := LIdTabela;
      end
      else
      begin
        AParametrosSaida := EmptyStr;
      end;
    except
      on E: Exception do
      begin
        Result := raException;
        AParametrosSaida := EmptyStr;
      end;
    end;
  finally
    LParts.DisposeOf;
    LParts := nil;
  end;
end;

function ObterImagemTela(const AParametrosEntrada:TParametrosEntradaAPIObterImagemTela; out AParametrosSaida: FMX.Graphics.TBitmap; out AErroApi : TErroApi) : TTipoRetornoAPI;
var
 LParts: TMultipartFormData;
 LRetorno: string;
 Lmagem  : String;
 LJSONResposta:TJSONObject;
 LHeaders: TCustomHeader;
 LVidaValidada:Boolean;
 LErroApi : TErroApi;
 LMemoryStream : TMemoryStream;
begin
  try
    LHeaders.Nome := 'Authorization';
    LHeaders.Valor :=  'Bearer';

    LParts := TMultipartFormData.Create;

    try
      LParts.AddField('IdImagem', AParametrosEntrada.IdImagem.ToString);
      Result := IntegracaoAPI_Post(URLSicsObterImagemTela, LParts, LRetorno, LErroApi, 3, LHeaders);
      LMemoryStream := TMemoryStream.Create;
      if (Result = raOK) then
      begin
        LMemoryStream.Position:=0;
        LMemoryStream.Write(LRetorno,Length(LRetorno));
        AParametrosSaida.LoadFromStream(LMemoryStream);
      end
      else
      begin
        AParametrosSaida := nil;
      end;
    except
      on E: Exception do
      begin
        Result := raException;
        AParametrosSaida := nil;
      end;
    end;
  finally
    LParts.DisposeOf;
    LParts := nil;
  end;
end;

initialization
{$IFNDEF CompilarPara_TotemAA}

{$IFNDEF IS_MOBILE}
  with TIniFile.Create(IncludeTrailingPathDelimiter(System.SysUtils.GetCurrentDir) + StringReplace(ExtractFileName(ParamStr(0)), '.exe', '.ini', [rfReplaceAll])) do
  try
    URLSicsHooboxProvaDeVida        := ReadString('EndPoints',  'URL_SicsHooboxProvaDeVida',        'http://localhost:9000/facial/provadevida');
    URLSicsHooboxCadastrarPessoa    := ReadString('EndPoints',  'URL_SicsHooboxCadastrarPessoa',    'http://localhost:9000/facial/cadastrarpessoa');
    URLSicsHooboxConsultarPessoa    := ReadString('EndPoints',  'URL_SicsHooboxConsultarPessoa',    'http://localhost:9000/facial/consultarpessoa');
    URLSicsHooboxConsultarPessoaData:= ReadString('EndPoints',  'URL_SicsHooboxConsultarPessoaData','http://localhost:9000/facial/consultarpessoaopcao');
    URLSicsHooboxReconhecerFace     := ReadString('EndPoints',  'URL_SicsHooboxReconhecerFace',     'http://localhost:9000/facial/reconhecerface');
    URLSicsPacienteConsultar        := ReadString('EndPoints',  'URL_SicsPacienteConsultar',        'http://localhost:9000/paciente/consultar');
    URLSicsObterImagemTela          := ReadString('EndPoints',  'URL_SicsObterImagemTela',          'http://localhost:9000/totem/obrterimagemtela');
    Client_ID                       := ReadString('Hoobox',     'Client_Id',                        EmptyStr);
    Client_Secret                   := ReadString('Hoobox',     'Client_Secret',                    EmptyStr);

    WriteString('EndPoints', 'URL_SicsHooboxProvaDeVida',         URLSicsHooboxProvaDeVida);
    WriteString('EndPoints', 'URL_SicsHooboxCadastrarPessoa',     URLSicsHooboxCadastrarPessoa);
    WriteString('EndPoints', 'URL_SicsHooboxConsultarPessoa',     URLSicsHooboxConsultarPessoa);
    WriteString('EndPoints', 'URL_SicsHooboxConsultarPessoaData', URLSicsHooboxConsultarPessoaData);
    WriteString('EndPoints', 'URL_SicsHooboxReconhecerFace',      URLSicsHooboxReconhecerFace);
    WriteString('EndPoints', 'URL_SicsPacienteConsultar',         URLSicsPacienteConsultar);
    WriteString('EndPoints', 'URL_SicsObterImagemTela',           URLSicsObterImagemTela);
    WriteString('Hoobox',    'Client_Id',                         Client_ID);
    WriteString('Hoobox',    'Client_Secret',                     Client_Secret);
  finally
    Free;
  end;
{$ELSE}
  URLSicsHooboxProvaDeVida := Providers.Consts.FURLProvaDeVida;
  URLSicsHooboxConsultarPessoa := Providers.Consts.FURLConsultarPessoa;
  URLSicsHooboxConsultarPessoaData := Providers.Consts.FURLConsultarPessoaData;
//  URLSicsHooboxCadastrarPessoa := Providers.Consts.FURLCadastrarPessoa;
  URLSicsHooboxReconhecerFace := Providers.Consts.FURLReconhecerFace;
  URLSicsPacienteConsultar := Providers.Consts.FURLPacienteConsultar;
  URLSicsObterImagemTela := Providers.Consts.FURLObterImagemTela;

{$ENDIF}
{$ENDIF}

end.