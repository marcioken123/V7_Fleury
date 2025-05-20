unit uTempoUnidade;

interface

uses
  System.Classes, System.SysUtils, System.StrUtils, REST.Json, System.DateUtils;

type
  TTempoUnidadeManager = class;
  TTempoUnidade        = class;
  TArrayTempoUnidade   = Array of TTempoUnidade;
  TListaTempoUnidade   = class;
  TFuncFormataHora     = function (const ASeconds, AFormatHour: Integer): String of object;

  TTempoUnidadeManager = class
  private
    class var FTempoUnidades: String;
    class var FTempoUnidadesAnt: String;
    class var FUltimaAtualizacao: TDateTime;

    class function FormatHour(AMinutes: Integer): String;
    class function GetFromAPI(AURL: String): TListaTempoUnidade;
    class procedure DoFilters(AListaTempoUnidade: TListaTempoUnidade; AUnidade, AEspecialidades: String);
    class procedure ChangeTags(ATempoUnidade: String; var AMsg: String);

    const
      INICIO_TAG_TEMPO_UNIDADE = '{{inicio_tempo_espera_einstein}}';
      FINAL_TAG_TEMPO_UNIDADE  = '{{fim_tempo_espera_einstein}}';
      DELIMITADOR              = '|';
      SEPARADOR                = ': ';
  public
    class var FTextoSemEspera: String;
    class var FFormatoHorarioEsperaNoJornalEletronico: Integer;
    class var FTempoMaximoSemRetornoAPI: Integer;
    class var FFuncFormataHora: TFuncFormataHora;

    class function UpdateTags(AURL, AUnidade, AEspecialidades: String): Boolean;
    class function SubstituirTags(var AMsg: String): Boolean;
  end;

  TListaTempoUnidade = class
  strict private
    Fitems: TArrayTempoUnidade;
    procedure Setitems(const Value: TArrayTempoUnidade);
  public
    property items: TArrayTempoUnidade read Fitems write Setitems;

    destructor Destroy; override;
    procedure Add(ATempoUnidade: TTempoUnidade);
    procedure Delete(AIndex: Integer);

    function DelimitedText(ASeparador: String = '='): String;
    procedure DoFilterUnidade(AUnidade: String);
    procedure DoFilterEspecialidades(AEspecialidades: String);
    procedure DoAddEspecialidades(AEspecialidades: String);
  end;

  TTempoUnidade = class
  strict private
    Fmax_min: Integer;
    Fid: Integer;
    Funidade: String;
    Fqtd_passagem: Integer;
    Fespecialidade: String;
    procedure Setespecialidade(const Value: String);
    procedure Setid(const Value: Integer);
    procedure Setmax_min(const Value: Integer);
    procedure Setqtd_passagem(const Value: Integer);
    procedure Setunidade(const Value: String);
  public
    property id           : Integer read Fid            write Setid;
    property unidade      : String  read Funidade       write Setunidade;
    property especialidade: String  read Fespecialidade write Setespecialidade;
    property qtd_passagem : Integer read Fqtd_passagem  write Setqtd_passagem;
    property max_min      : Integer read Fmax_min       write Setmax_min;
  end;

implementation

{ TTempoUnidade }

uses ASPHTTPRequest;

procedure TTempoUnidade.Setespecialidade(const Value: String);
begin
  Fespecialidade := Value;
end;

procedure TTempoUnidade.Setid(const Value: Integer);
begin
  Fid := Value;
end;

procedure TTempoUnidade.Setmax_min(const Value: Integer);
begin
  Fmax_min := Value;
end;

procedure TTempoUnidade.Setqtd_passagem(const Value: Integer);
begin
  Fqtd_passagem := Value;
end;

procedure TTempoUnidade.Setunidade(const Value: String);
begin
  Funidade := Value;
end;

{ TListaTempoUnidade }

procedure TListaTempoUnidade.Add(ATempoUnidade: TTempoUnidade);
begin
  SetLength(Fitems, Length(Fitems) + 1);
  Fitems[High(Fitems)] := ATempoUnidade;
end;

procedure TListaTempoUnidade.Delete(AIndex: Integer);
begin
  Fitems[AIndex].Free;
  System.Delete(Fitems, AIndex, 1);
end;

function TListaTempoUnidade.DelimitedText(ASeparador: String = '='): String;
var
  LTempo: String;
  LTempoUnidade: TTempoUnidade;
  LResult: TStrings;
begin
  LResult := TStringList.Create;

  try
    for LTempoUnidade in Self.items do
    begin
      LTempo := TTempoUnidadeManager.FormatHour(LTempoUnidade.max_min);

      LResult.Add(LTempoUnidade.especialidade + ASeparador + LTempo);    
    end;

    LResult.Delimiter := TTempoUnidadeManager.DELIMITADOR;
    Result := LResult.DelimitedText;
  finally
    LResult.Free;
  end;
end;

destructor TListaTempoUnidade.Destroy;
var
  i: Integer;
begin
  for i := 0 to High(Fitems) do
  begin
    Fitems[i].Free;
  end;

  SetLength(Fitems, 0);

  inherited;
end;

procedure TListaTempoUnidade.DoAddEspecialidades(AEspecialidades: String);
var
  i: Integer;
  LEspecialidades,
  LEspecialidadesFormatadas,
  LListaTempoUnidade: TStrings;
  LTempoUnidade: TTempoUnidade;
begin
  LEspecialidades := TStringList.Create;

  try
    LEspecialidades.Delimiter     := ',';
    LEspecialidades.DelimitedText := ReplaceStr(AEspecialidades, ' ', '|');

    LEspecialidadesFormatadas := TStringList.Create;

    try
      LEspecialidadesFormatadas.Delimiter     := ',';
      LEspecialidadesFormatadas.DelimitedText := ReplaceStr(AEspecialidades.ToUpper, ' ', EmptyStr);

      LListaTempoUnidade := TStringList.Create;

      try
        LListaTempoUnidade.Delimiter     := TTempoUnidadeManager.DELIMITADOR;
        LListaTempoUnidade.DelimitedText := ReplaceStr(Self.DelimitedText.ToUpper, ' ', EmptyStr);

        for i := 0 to LEspecialidades.Count - 1 do
        begin
          if LListaTempoUnidade.IndexOfName(LEspecialidadesFormatadas[i]) < 0 then
          begin
            LTempoUnidade := TTempoUnidade.Create;

            LTempoUnidade.id            := Length(Self.items) + 100;
            LTempoUnidade.unidade       := EmptyStr;
            LTempoUnidade.especialidade := ReplaceStr(LEspecialidades[i], '|', ' ').Trim;
            LTempoUnidade.qtd_passagem   := 0;
            LTempoUnidade.max_min        := 0;

            Self.Add(LTempoUnidade);
          end;
        end;
      finally
        LListaTempoUnidade.Free;
      end;
    finally
      LEspecialidadesFormatadas.Free;
    end;
  finally
    LEspecialidades.Free;
  end;
end;

procedure TListaTempoUnidade.DoFilterEspecialidades(AEspecialidades: String);
var
  i: Integer;
  LEspecialidades: TStrings;
  LEspecialidadeFormatada: String;
begin
  LEspecialidades := TStringList.Create;

  try
    LEspecialidades.Delimiter     := ',';
    LEspecialidades.DelimitedText := ReplaceStr(AEspecialidades.ToUpper, ' ', EmptyStr);

    for i := High(Self.items) downto 0 do
    begin
      LEspecialidadeFormatada := ReplaceStr(Self.items[i].especialidade.ToUpper, ' ', EmptyStr);

      if LEspecialidades.IndexOf(LEspecialidadeFormatada) < 0 then
      begin
        Self.Delete(i);
      end;
    end;
  finally
    LEspecialidades.Free;
  end;
end;

procedure TListaTempoUnidade.DoFilterUnidade(AUnidade: String);
var
  i: Integer;
begin
  for i := High(Self.items) downto 0 do
  begin       
    if Self.items[i].unidade.ToUpper <> AUnidade.ToUpper then
    begin
      Self.Delete(i);
    end;
  end;
end;

procedure TListaTempoUnidade.Setitems(const Value: TArrayTempoUnidade);
begin
  Fitems := Value;
end;

{ TTempoUnidadeManager }

class procedure TTempoUnidadeManager.ChangeTags(ATempoUnidade: String; var AMsg: String);
var
  LSeparador,
  LTempoUnidade: String;
  LPosTagInicio: Integer;
  LPosTagFinal : Integer;
begin
  LPosTagInicio := Pos(INICIO_TAG_TEMPO_UNIDADE, AMsg);
  LSeparador    := EmptyStr;

  if AMsg.Contains(FINAL_TAG_TEMPO_UNIDADE) then
  begin
    LPosTagFinal := Pos(FINAL_TAG_TEMPO_UNIDADE, AMsg);

    LSeparador := Copy(AMsg,
      LPosTagInicio + INICIO_TAG_TEMPO_UNIDADE.Length,
      LPosTagFinal - (LPosTagInicio + INICIO_TAG_TEMPO_UNIDADE.Length));
  end;

  LTempoUnidade := ReplaceStr(ReplaceStr(ATempoUnidade, DELIMITADOR, LSeparador), '"', EmptyStr);

  AMsg := ReplaceStr(AMsg, INICIO_TAG_TEMPO_UNIDADE, EmptyStr);
  AMsg := ReplaceStr(AMsg, LSeparador              , EmptyStr);
  AMsg := ReplaceStr(AMsg, FINAL_TAG_TEMPO_UNIDADE , EmptyStr);

  Insert(LTempoUnidade, AMsg, LPosTagInicio);
end;

class procedure TTempoUnidadeManager.DoFilters(AListaTempoUnidade: TListaTempoUnidade;
  AUnidade, AEspecialidades: String);
begin
  AListaTempoUnidade.DoFilterUnidade(AUnidade);
  AListaTempoUnidade.DoFilterEspecialidades(AEspecialidades);
  AListaTempoUnidade.DoAddEspecialidades(AEspecialidades);
end;

class function TTempoUnidadeManager.FormatHour(AMinutes: Integer): String;
begin
  if AMinutes = 0 then
  begin
    Result := TTempoUnidadeManager.FTextoSemEspera;
    Exit;
  end;

  if Assigned(FFuncFormataHora) then
  begin
    Result := FFuncFormataHora(AMinutes * 60, FFormatoHorarioEsperaNoJornalEletronico);
    Exit;
  end;

  Result := AMinutes.ToString;
end;

class function TTempoUnidadeManager.GetFromAPI(AURL: String): TListaTempoUnidade;
var
  LStreamRes: TStringStream;
  LResponse : String;
begin
  LStreamRes := TStringStream.Create;

  try
    THTTPRequest.Get(AURL, LStreamRes);

    LResponse := Utf8ToAnsi(LStreamRes.DataString);

    LResponse := '{"items": ' + LResponse + '}';

    Result := TJson.JsonToObject<TListaTempoUnidade>(LResponse);
  finally
    LStreamRes.Free;
  end;
end;

class function TTempoUnidadeManager.SubstituirTags(var AMsg: String): Boolean;
begin
  Result := True;

  if not AMsg.Contains(INICIO_TAG_TEMPO_UNIDADE) then
  begin
    Exit;
  end;

  ChangeTags(FTempoUnidades, AMsg);

  if FTempoUnidades = FTempoUnidadesAnt then
  begin
    Result := False;
    Exit;
  end;
end;

class function TTempoUnidadeManager.UpdateTags(AURL, AUnidade, AEspecialidades: String): Boolean;
var
  LListaTempoUnidade: TListaTempoUnidade;
  LTempoUnidades: String;
  LUltimaAtualizacao: TDateTime;
begin
  Result := True;

  FTempoUnidadesAnt := FTempoUnidades;
  LTempoUnidades    := FTempoUnidades;

  LUltimaAtualizacao := FUltimaAtualizacao;

  try
    LListaTempoUnidade := GetFromAPI(AURL);

    try
      DoFilters(LListaTempoUnidade, AUnidade, AEspecialidades);

      LTempoUnidades     := LListaTempoUnidade.DelimitedText(SEPARADOR);

      LUltimaAtualizacao := Now;
    finally
      LListaTempoUnidade.Free;
    end;
  except
    on E: Exception do
    begin
      if LUltimaAtualizacao <= (IncMinute(Now, FTempoMaximoSemRetornoAPI * -1)) then
      begin
        LTempoUnidades := EmptyStr;
      end;

      Result := False;
    end;
  end;  

  TThread.Synchronize(nil,
    procedure
    begin
      FTempoUnidades     := LTempoUnidades;
      FUltimaAtualizacao := LUltimaAtualizacao;
    end);
end;

end.
