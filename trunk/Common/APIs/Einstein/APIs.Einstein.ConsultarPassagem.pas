unit APIs.Einstein.ConsultarPassagem;

interface

uses
  APIs.Common, LogSQLite, System.Types, System.StrUtils;

type
  TStatusPassagem = (tspPreAdmissao, tspAtual);

  TStatusPassagems = set of TStatusPassagem;

  TPassagemCliente = record
    CategoriaAdmissaoDR: string;
    CodEpisodio: string;
    CodLocal: string;
    CodStatusEpisodio: string;
    DataEpisodio: string;
    DescEspecialidadeEpisodio: string;
    DescStatusEpisodio: string;
    DescTipoEpisodio: string;
    HoraEpisodio: string;
    HoraSenha: string;
    IdTabela: string;
    IdTrakCare: string;
    LocalDR: string;
    MensagemConfidencial: string;
    MotivoAdmissaoDR: string;
    NomeProfissionalIndicador: string;
    NomeProfissionalSaude: string;
    NumSenha: string;
    Observacoes: string;
    PacienteDR: string;
    PassagemTrakCare: string;
    ProfissionalSaudeDR: string;
    ProfissionalIndicadorDR: string;
    SubtipoEpisodioDR: string;
    DescSubtipoEpisodio: string;
    TipoEpisodioDR: string;
    CodTipoEpisodio: string;
    DescConvenio: string;
    CodigoConvenio: string;
    UsuarioAlteracaoDR: string;
    UsuarioInclusaoDR: string;
    AlaDR: integer;
  end;

	TParametrosEntradaAPI = record
                            ValorPacienteParRef: string; //"Entrega"  "Retirada"
                            CodigosUnidades: string;
                            StatusPassagem: TStatusPassagems;
                            CodEpisodio:string;
                            IdTabela: string;
                            DescTipoEpisodio:string;
                            SubTipoEpisodio:string;
                            ValidaLocal: boolean;
                            ValidaData: boolean;
                            ValidaDataRetroativa: boolean;
                            ValidaStatus: boolean;
                            ValidaProfissional:boolean;
                            ValidaEpisodio:boolean;
                            ValidaTipoEpisodio:boolean;
                            ValidaSubTipoEpisodio:boolean;
                         end;
	TParametrosSaidaAPI = record
                            Passagens: Array of TPassagemCliente;
                        end;

  procedure PopularParametros;
  function StatusEpisodio(const AStatusEpisodio: String):TStatusPassagem;
  function Execute(const AParametrosEntrada: TParametrosEntradaAPI; out AParametrosSaida: TParametrosSaidaAPI; out AErroApi : TErroApi) : TTipoRetornoAPI;
  function ConsultaPorId(const AParametrosEntrada: TParametrosEntradaAPI; out AParametrosSaida: string; out AErroApi : TErroApi) : TTipoRetornoAPI;
implementation

uses
{$IFDEF CompilarPara_TotemAA}
  controller.parametros,
{$ENDIF}
  IniFiles, System.SysUtils, System.Json, System.DateUtils, untLog;

var
  URL : string;

procedure PopularParametros;
begin
{$IFDEF CompilarPara_TotemAA}
  URL := controller.parametros.CarregarParametroStr('APIs.Einstein', 'URL_ConsultarPassagem', 'http://10.33.1.223:20021/servico/siaf/consultarpassagem');
{$ENDIF}
end;


function Execute(const AParametrosEntrada: TParametrosEntradaAPI; out AParametrosSaida: TParametrosSaidaAPI; out AErroApi : TErroApi) : TTipoRetornoAPI;
var
  LJSON: TJSONObject;
  LRetorno: string;
  LJSONResposta: TJSONObject;
  LJSONArray: TJSONArray;
  LCount: Integer;
  LCategoriaAdmissaoDR: string;
  LCodEpisodio: string;
  LCodLocal: string;
  LCodStatusEpisodio: string;
  LDataEpisodio: string;
  LDescEspecialidadeEpisodio: string;
  LDescStatusEpisodio: string;
  LDescTipoEpisodio: string;
  LHoraEpisodio: string;
  LHoraSenha: string;
  LIdTabela: string;
  LIdTrakCare: string;
  LLocalDR: string;
  LMensagemConfidencial: string;
  LMotivoAdmissaoDR: string;
  LNomeProfissionalIndicador: string;
  LNomeProfissionalSaude: string;
  LNumSenha: string;
  LObservacoes: string;
  LPacienteDR: string;
  LPassagemTrakCare: string;
  LProfissionalSaudeDR: string;
  LProfissionalIndicadorDR: string;
  LSubtipoEpisodioDR: string;
  LDescSubtipoEpisodio: string;
  LTipoEpisodioDR: string;
  LCodTipoEpisodio: string;
  LDescConvenio: string;
  LCodigoConvenio: string;
  LUsuarioInclusaoDR : string;
  LAlaDR:string;
  LCodigosUnidades : TStringDynArray;
  LStatusPassagem:TStatusPassagem;
  LStatusPassagemStr:string;
begin
  LJSON := TJSONObject.Create;
  try
    try
      LJSON.AddPair('PacienteDR'           , AParametrosEntrada.ValorPacienteParRef);
      LStatusPassagemStr:= Emptystr;
      for LStatusPassagem in AParametrosEntrada.StatusPassagem do
      begin
        if LStatusPassagemStr <> EmptyStr then LStatusPassagemStr := LStatusPassagemStr + ';';
        Case LStatusPassagem of
          tspPreAdmissao:LStatusPassagemStr := LStatusPassagemStr + 'P';
          tspAtual:LStatusPassagemStr := LStatusPassagemStr + 'A';
        end;
      end;
      LJSON.AddPair('CodStatusEpisodio'    , LStatusPassagemStr);

      Result := IntegracaoAPI_Post (URL, LJSON, LRetorno, AErroAPI, 3);
      if Result = raOK then
      begin
        LCodigosUnidades := SplitString(stringreplace(stringreplace(UpperCase(AParametrosEntrada.CodigosUnidades),' ','',[rfReplaceAll]),',',';',[rfReplaceAll]),';');
        LJSONResposta := TJSONObject.ParseJSONValue(LRetorno) as TJSONObject;
        try
          if (LJSONResposta <> nil) and (LJSONResposta.Values['Objeto'] <> nil) then
          begin
            LJSONArray := LJSONResposta.GetValue<TJSONArray>('Objeto') as TJSONArray;
            for LCount := 0 to Pred(LJSONArray.Count) do
            begin
              LCategoriaAdmissaoDR:= EmptyStr;
              LCodEpisodio:= EmptyStr;
              LCodLocal:= EmptyStr;
              LCodStatusEpisodio:= EmptyStr;
              LDataEpisodio:= EmptyStr;
              LDescEspecialidadeEpisodio:= EmptyStr;
              LDescStatusEpisodio:= EmptyStr;
              LDescTipoEpisodio:= EmptyStr;
              LHoraEpisodio:= EmptyStr;
              LHoraSenha:= EmptyStr;
              LIdTabela:= EmptyStr;
              LIdTrakCare:= EmptyStr;
              LLocalDR:= EmptyStr;
              LMensagemConfidencial:= EmptyStr;
              LMotivoAdmissaoDR:= EmptyStr;
              LNomeProfissionalIndicador:= EmptyStr;
              LNomeProfissionalSaude:= EmptyStr;
              LNumSenha:= EmptyStr;
              LObservacoes:= EmptyStr;
              LPacienteDR:= EmptyStr;
              LPassagemTrakCare:= EmptyStr;
              LProfissionalSaudeDR:= EmptyStr;
              LProfissionalIndicadorDR:= EmptyStr;
              LSubtipoEpisodioDR:= EmptyStr;
              LDescSubtipoEpisodio:= EmptyStr;
              LTipoEpisodioDR:= EmptyStr;
              LCodTipoEpisodio:= EmptyStr;
              LDescConvenio:= EmptyStr;
              LCodigoConvenio:= EmptyStr;
              LUsuarioInclusaoDR:= EmptyStr;
              LAlaDR:= EmptyStr;
              LJSONResposta := (LJSONArray.Items[LCount] as TJSONObject);
              LJSONResposta.TryGetValue('CategoriaAdmissaoDR',        LCategoriaAdmissaoDR);
              LJSONResposta.TryGetValue('CodEpisodio',                LCodEpisodio);
              LJSONResposta.TryGetValue('CodLocal',                   LCodLocal);
              LJSONResposta.TryGetValue('CodStatusEpisodio',          LCodStatusEpisodio);
              LJSONResposta.TryGetValue('DataEpisodio',               LDataEpisodio);
              LJSONResposta.TryGetValue('DescEspecialidadeEpisodio',  LDescEspecialidadeEpisodio);
              LJSONResposta.TryGetValue('DescStatusEpisodio',         LDescStatusEpisodio);
              LJSONResposta.TryGetValue('DescTipoEpisodio',           LDescTipoEpisodio);
              LJSONResposta.TryGetValue('HoraEpisodio',               LHoraEpisodio);
              LJSONResposta.TryGetValue('HoraSenha',                  LHoraSenha);
              LJSONResposta.TryGetValue('IdTabela',                   LIdTabela);
              LJSONResposta.TryGetValue('IdTrakCare',                 LIdTrakCare);
              LJSONResposta.TryGetValue('LocalDR',                    LLocalDR);
              LJSONResposta.TryGetValue('MensagemConfidencial',       LMensagemConfidencial);
              LJSONResposta.TryGetValue('MotivoAdmissaoDR',           LMotivoAdmissaoDR);
              LJSONResposta.TryGetValue('NomeProfissionalIndicador',  LNomeProfissionalIndicador);
              LJSONResposta.TryGetValue('NomeProfissionalSaude',      LNomeProfissionalSaude);
              LJSONResposta.TryGetValue('NumSenha',                   LNumSenha);
              LJSONResposta.TryGetValue('Observacoes',                LObservacoes);
              LJSONResposta.TryGetValue('PacienteDR',                 LPacienteDR);
              LJSONResposta.TryGetValue('PassagemTrakCare',           LPassagemTrakCare);
              LJSONResposta.TryGetValue('ProfissionalSaudeDR',        LProfissionalSaudeDR);
              LJSONResposta.TryGetValue('ProfissionalIndicadorDR',    LProfissionalIndicadorDR);
              LJSONResposta.TryGetValue('SubtipoEpisodioDR',          LSubtipoEpisodioDR);
              LJSONResposta.TryGetValue('DescSubtipoEpisodio',        LDescSubtipoEpisodio);
              LJSONResposta.TryGetValue('TipoEpisodioDR',             LTipoEpisodioDR);
              LJSONResposta.TryGetValue('CodTipoEpisodio',            LCodTipoEpisodio);
              LJSONResposta.TryGetValue('DescConvenio',               LDescConvenio);
              LJSONResposta.TryGetValue('CodigoConvenio',             LCodigoConvenio);
              LJSONResposta.TryGetValue('UsuarioInclusaoDR',          LUsuarioInclusaoDR);
              LJSONResposta.TryGetValue('AlaDR',                      LAlaDR);
              if ((not AParametrosEntrada.ValidaLocal) or
                  ((AParametrosEntrada.ValidaLocal) and (MatchStr(UpperCase(LCodLocal), LCodigosUnidades)))
                 ) and
                 ((not AParametrosEntrada.ValidaStatus) or
                  ((AParametrosEntrada.ValidaStatus) and (StatusEpisodio(LCodStatusEpisodio) in AParametrosEntrada.StatusPassagem))
                 ) and
                 ((not AParametrosEntrada.ValidaProfissional) or
                  ((AParametrosEntrada.ValidaProfissional) and ((LNomeProfissionalIndicador <> EmptyStr) or (LNomeProfissionalSaude <> EmptyStr)) )
                 ) and
                 ((not AParametrosEntrada.ValidaEpisodio) or
                  ((AParametrosEntrada.ValidaEpisodio) and ((AParametrosEntrada.CodEpisodio = EmptyStr) or SameText(AParametrosEntrada.CodEpisodio, LCodEpisodio)))
                 ) and
                 ((not AParametrosEntrada.ValidaTipoEpisodio) or
                  ((AParametrosEntrada.ValidaTipoEpisodio) and ((AParametrosEntrada.DescTipoEpisodio = EmptyStr) or SameText(AParametrosEntrada.DescTipoEpisodio, LDescTipoEpisodio)))
                 ) and
                 ((not AParametrosEntrada.ValidaSubTipoEpisodio) or
                  ((AParametrosEntrada.ValidaSubTipoEpisodio) and ((AParametrosEntrada.SubTipoEpisodio = EmptyStr) or SameText(AParametrosEntrada.SubTipoEpisodio, LSubtipoEpisodioDR)))
                 ) and
                 (  ((AParametrosEntrada.ValidaDataRetroativa) and
                    (   (LDataEpisodio = FormatDateTime('YYYY-MM-DD', Now)) or
                      ( (HourOf(Now) < 6) and
                        (HourOf(StrToTime(LHoraEpisodio)) >= 22) and
                        (LDataEpisodio = FormatDateTime('YYYY-MM-DD', IncDay(Now,-1)))
                      )
                    )
                    )
                    or
                   ((not AParametrosEntrada.ValidaDataRetroativa) and
                    ((not AParametrosEntrada.ValidaData) or
                    ((AParametrosEntrada.ValidaData) and (LDataEpisodio = FormatDateTime('YYYY-MM-DD', Now)))))
                 ) then
              begin
                SetLength(AParametrosSaida.Passagens,length(AParametrosSaida.Passagens)+1);
                AParametrosSaida.Passagens[length(AParametrosSaida.Passagens)-1].CategoriaAdmissaoDR        := LCategoriaAdmissaoDR;
                AParametrosSaida.Passagens[length(AParametrosSaida.Passagens)-1].CodEpisodio                := LCodEpisodio;
                AParametrosSaida.Passagens[length(AParametrosSaida.Passagens)-1].CodLocal                   := LCodLocal;
                AParametrosSaida.Passagens[length(AParametrosSaida.Passagens)-1].CodStatusEpisodio          := LCodStatusEpisodio;
                AParametrosSaida.Passagens[length(AParametrosSaida.Passagens)-1].DataEpisodio               := LDataEpisodio;
                AParametrosSaida.Passagens[length(AParametrosSaida.Passagens)-1].DescEspecialidadeEpisodio  := LDescEspecialidadeEpisodio;
                AParametrosSaida.Passagens[length(AParametrosSaida.Passagens)-1].DescStatusEpisodio         := LDescStatusEpisodio;
                AParametrosSaida.Passagens[length(AParametrosSaida.Passagens)-1].DescTipoEpisodio           := LDescTipoEpisodio;
                AParametrosSaida.Passagens[length(AParametrosSaida.Passagens)-1].HoraEpisodio               := LHoraEpisodio;
                AParametrosSaida.Passagens[length(AParametrosSaida.Passagens)-1].HoraSenha                  := LHoraSenha;
                AParametrosSaida.Passagens[length(AParametrosSaida.Passagens)-1].IdTabela                   := LIdTabela;
                AParametrosSaida.Passagens[length(AParametrosSaida.Passagens)-1].IdTrakCare                 := LIdTrakCare;
                AParametrosSaida.Passagens[length(AParametrosSaida.Passagens)-1].LocalDR                    := LLocalDR;
                AParametrosSaida.Passagens[length(AParametrosSaida.Passagens)-1].MensagemConfidencial       := LMensagemConfidencial;
                AParametrosSaida.Passagens[length(AParametrosSaida.Passagens)-1].MotivoAdmissaoDR           := LMotivoAdmissaoDR;
                AParametrosSaida.Passagens[length(AParametrosSaida.Passagens)-1].NomeProfissionalIndicador  := LNomeProfissionalIndicador;
                AParametrosSaida.Passagens[length(AParametrosSaida.Passagens)-1].NomeProfissionalSaude      := LNomeProfissionalSaude;
                AParametrosSaida.Passagens[length(AParametrosSaida.Passagens)-1].NumSenha                   := LNumSenha;
                AParametrosSaida.Passagens[length(AParametrosSaida.Passagens)-1].Observacoes                := LObservacoes;
                AParametrosSaida.Passagens[length(AParametrosSaida.Passagens)-1].PacienteDR                 := LPacienteDR;
                AParametrosSaida.Passagens[length(AParametrosSaida.Passagens)-1].PassagemTrakCare           := LPassagemTrakCare;
                AParametrosSaida.Passagens[length(AParametrosSaida.Passagens)-1].ProfissionalSaudeDR        := LProfissionalSaudeDR;
                AParametrosSaida.Passagens[length(AParametrosSaida.Passagens)-1].ProfissionalIndicadorDR    := LProfissionalIndicadorDR;
                AParametrosSaida.Passagens[length(AParametrosSaida.Passagens)-1].SubtipoEpisodioDR          := LSubtipoEpisodioDR;
                AParametrosSaida.Passagens[length(AParametrosSaida.Passagens)-1].DescSubtipoEpisodio        := LDescSubtipoEpisodio;
                AParametrosSaida.Passagens[length(AParametrosSaida.Passagens)-1].TipoEpisodioDR             := LTipoEpisodioDR;
                AParametrosSaida.Passagens[length(AParametrosSaida.Passagens)-1].CodTipoEpisodio            := LCodTipoEpisodio;
                AParametrosSaida.Passagens[length(AParametrosSaida.Passagens)-1].DescConvenio               := LDescConvenio;
                AParametrosSaida.Passagens[length(AParametrosSaida.Passagens)-1].CodigoConvenio             := LCodigoConvenio;
                AParametrosSaida.Passagens[length(AParametrosSaida.Passagens)-1].UsuarioInclusaoDR          := LUsuarioInclusaoDR;
                AParametrosSaida.Passagens[length(AParametrosSaida.Passagens)-1].AlaDR                      := StrToIntDef(LAlaDR,0);
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
            AErroApi.MsgErro := 'Erro no evento APIs.Einstein.ConsultarPassagem.Execute. ' +
                                'URL: "' + URL + '" / ' +
                                'Enviado: "' + LJSON.ToJSON + '" / ' +
                                'Recebido: "' + LRetorno + '"';

            TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
              .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroNegocio]               )
              .AddDetail('Evento'          , 'APIs.Einstein.ConsultarPassagem.Execute')
              .AddDetail('Url'             , URL                                               )
              .AddDetail('Metodo'          , 'POST'                                            )
              .AddDetail('ConteudoEnviado' , LJson.ToString                                    )
              .AddDetail('ConteudoRecebido', LRetorno                                          )
              .AddDetail('ErroCatalogado'  , AErroApi.CodErro                                  )
              .Save;
            TLog.MyLogTemp(AErroApi.MsgErro, nil, 0, False, TCriticalLog.tlERROR);
          end;
        finally
          LJSONResposta.Free;
        end;
      end;
    except
      on E: Exception do
      begin
        Result := raException;
        AErroApi.CodErro := -1;
        AErroApi.MsgErro := 'Erro no evento APIs.Einstein.ConsultarPassagem.Execute. ' +
                            'URL: "' + URL + '" / ' +
                            'Enviado: "' + LJSON.ToJSON + '" / ' +
                            'Recebido: "' + LRetorno + '"';

        TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
          .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroNegocio]               )
          .AddDetail('Evento'          , 'APIs.Einstein.ConsultarPassagem.Execute')
          .AddDetail('Url'             , URL                                               )
          .AddDetail('Metodo'          , 'POST'                                            )
          .AddDetail('ConteudoEnviado' , LJson.ToString                                    )
          .AddDetail('ConteudoRecebido', LRetorno                                          )
          .AddDetail('ErroCatalogado'  , AErroApi.CodErro                                  )
          .Save;
        TLog.MyLogTemp(AErroApi.MsgErro, nil, 0, False, TCriticalLog.tlERROR);
      end;
    end;
  finally
    FreeAndNil(LJSON);
  end;
end;


function ConsultaPorId(const AParametrosEntrada: TParametrosEntradaAPI; out AParametrosSaida: string; out AErroApi : TErroApi) : TTipoRetornoAPI;
var
  LJSON: TJSONObject;
  LRetorno: string;
  LJSONResposta: TJSONObject;
  LArrayObjeto : TJSonArray;
  LJSONObjeto : TJSONObject;
  LCountPassagens: Integer;
  LCount: Integer;
  LJsonPair: TJSONPair;
  LNomeChave: string;
  LIdTabela: string;
begin
  LJSON := TJSONObject.Create;
  try
    try
      LJSON.AddPair('PacienteDR'           , AParametrosEntrada.ValorPacienteParRef);
      LJSON.AddPair('CodStatusEpisodio'    , 'A;P');

      Result := IntegracaoAPI_Post (URL, LJSON, LRetorno, AErroAPI, 3);
      if Result = raOK then
      begin
        Result := raErroNegocio;
        LJSONResposta := TJSONObject.ParseJSONValue(LRetorno) as TJSONObject;
        try
          if (LJSONResposta <> nil) and (LJSONResposta.Values['Objeto'] <> nil) then
          begin
            LRetorno := LJSONResposta.Values['Objeto'].ToJSON;
            LArrayObjeto := TJSONObject.ParseJSONValue(LRetorno) as TJSONArray;
            if LArrayObjeto.Count > 0 then
            begin
              for LCountPassagens := 0 to Pred(LArrayObjeto.Count) do
              begin
                LJSONObjeto := (LArrayObjeto.Items[LCountPassagens] as TJSONObject);
                LJSONObjeto.TryGetValue('IdTabela', LIdTabela);
                if LIdTabela = AParametrosEntrada.IdTabela then
                begin

                  for LCount := Pred(LJSONObjeto.Size) downto 0 do
                  begin
                    LJsonPair := LJSONObjeto.Get(LCount);
                    LNomeChave:= LJsonPair.JsonString.Value;
                    try
                      LArrayObjeto := LJSONObjeto.GetValue<TJSONArray>(LNomeChave) as TJSONArray;
                      if LArrayObjeto <> nil then
                        LJSONObjeto.RemovePair(LNomeChave);
                    except

                    end;
                  end;

                  AParametrosSaida := LJSONObjeto.ToJson;

                  AErroApi.CodErro := 0;
                  AErroApi.MsgErro := '';

                  Result := raOK;
                  Break;
                end;
              end;
            end;
          end;
          if Result =  raErroNegocio then
          begin
            AErroApi.CodErro := -1;
            AErroApi.MsgErro := 'Erro no evento APIs.Einstein.ConsultarPassagem.ConsultaPorId. ' +
                                'URL: "' + URL + '" / ' +
                                'Enviado: "' + LJson.ToString + '" / ' +
                                'Recebido: "' + LRetorno + '"';

            TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
              .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroNegocio]               )
              .AddDetail('Evento'          , 'APIs.Einstein.ConsultarPassagem.ConsultaPorId')
              .AddDetail('Url'             , URL                                               )
              .AddDetail('Metodo'          , 'POST'                                            )
              .AddDetail('ConteudoEnviado' , LJson.ToString                                    )
              .AddDetail('ConteudoRecebido', LRetorno                                          )
              .AddDetail('ErroCatalogado'  , AErroApi.CodErro                                  )
              .Save;
            TLog.MyLogTemp(AErroApi.MsgErro, nil, 0, False, TCriticalLog.tlERROR);
          end;
        finally
          LJSONResposta.Free;
        end;
      end;
    except
      on E: Exception do
      begin
        Result := raException;
        AErroApi.CodErro := -1;
        AErroApi.MsgErro := 'Erro no evento APIs.Einstein.ConsultarPassagem.ConsultaPorId. ' +
                            'URL: "' + URL + '" / ' +
                            'Enviado: "' + LJson.ToString + '" / ' +
                            'Recebido: "' + LRetorno + '"';

        TLogSQLite.New(tmError, clResponse, 'IntegracaoAPI (### Erro ###)')
          .AddDetail('TipoErro'        , Desc_TTipoRetornoAPI[raErroNegocio]               )
          .AddDetail('Evento'          , 'APIs.Einstein.ConsultarPassagem.ConsultaPorId')
          .AddDetail('Url'             , URL                                               )
          .AddDetail('Metodo'          , 'POST'                                            )
          .AddDetail('ConteudoEnviado' , LJson.ToString                                    )
          .AddDetail('ConteudoRecebido', LRetorno                                          )
          .AddDetail('ErroCatalogado'  , AErroApi.CodErro                                  )
          .Save;
        TLog.MyLogTemp(AErroApi.MsgErro, nil, 0, False, TCriticalLog.tlERROR);
      end;
    end;
  finally
    FreeAndNil(LJSON);
  end;
end;

function StatusEpisodio(const AStatusEpisodio: String):TStatusPassagem;
begin
  if AStatusEpisodio = 'A' then
    Result:= tspAtual
  else if AStatusEpisodio = 'P' then
    Result:= tspPreAdmissao;
end;

initialization
{$IFNDEF CompilarPara_TotemAA}
  with TIniFile.Create(IncludeTrailingPathDelimiter(System.SysUtils.GetCurrentDir) + StringReplace(ExtractFileName(ParamStr(0)), '.exe', '.ini', [rfReplaceAll])) do
  try
    URL := ReadString ('APIs.Einstein.ConsultarPassagem', 'URL', 'http://10.33.1.223:20021/servico/siaf/consultarpassagem');
    WriteString ('APIs.Einstein.ConsultarPassagem', 'URL', URL);
  finally
    Free;
  end;
{$ENDIF}
end.
