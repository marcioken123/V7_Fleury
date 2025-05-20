unit uDispositivo;

interface

uses System.SysUtils, System.JSON, FireDAC.Comp.Client, FireDAC.Stan.Def, FireDAC.Stan.Async, Data.DB;

type
  TDispositivoManager = class
  public
    class function StatusPorUnidade(AUnidade: Integer; APath: String): TJSONArray;
  end;

  TDispositivo = class
  private
    function GetConnection(APath: String): TFDConnection;

    function GetUnidades(ADataSet: TDataSet): TJSONArray;
    function GetTipos(AUnidade: Integer; ADataSet: TDataSet): TJSONArray;
    function GetDispositivos(AUnidade: Integer; ATipo: String; ADataSet: TDataSet): TJSONArray;

    function UnidadeOffline(AUnidade: Integer; ADataSet: TDataSet): Boolean;
  public
    function StatusPorUnidade(AUnidade: Integer; APath: String): TJSONArray;
  end;

implementation

{ TDispositivoManager }

class function TDispositivoManager.StatusPorUnidade(AUnidade: Integer; APath: String): TJSONArray;
var
  LDispositivo: TDispositivo;
begin
  LDispositivo := TDispositivo.Create;
  try
    Result := LDispositivo.StatusPorUnidade(AUnidade, APath);
  finally
    FreeAndNil(LDispositivo);
  end;
end;

{ TDispositivoManager }

function TDispositivo.GetConnection(APath: String): TFDConnection;
begin
  Result := TFDConnection.Create(nil);

  try
    Result.Close;
    Result.ConnectionDefName := APath;
    Result.Open;
  except
    on E: Exception do
    begin
      // Levantar Exception de erro de conexão?
    end;
  end;
end;

function TDispositivo.GetDispositivos(AUnidade: Integer; ATipo: String; ADataSet: TDataSet): TJSONArray;
var
  LJSONDispositivo: TJSONObject;
  LArrayDispositivos: TJSONArray;
begin
  LArrayDispositivos := TJSONArray.Create;

  while (not ADataSet.Eof) and
        (AUnidade = ADataSet.FieldByName('ID_UNID_CLI').AsInteger) and
        (ATipo = ADataSet.FieldByName('TIPO_DISPOSITIVO').AsString) do
  begin
    LJSONDispositivo := TJSONObject.Create;
    LJSONDispositivo.AddPair('Nome', ADataSet.FieldByName('NOME_DISPOSITIVO').AsString);
    LJSONDispositivo.AddPair('Modelo', ADataSet.FieldByName('MODELO_DISPOSITIVO').AsString);
    LJSONDispositivo.AddPair('IP', ADataSet.FieldByName('IP').AsString);
    LJSONDispositivo.AddPair('Status', ADataSet.FieldByName('STATUS').AsString);

    LArrayDispositivos.AddElement(LJSONDispositivo);

    ADataSet.Next;
  end;

  Result := LArrayDispositivos;
end;

function TDispositivo.GetTipos(AUnidade: Integer; ADataSet: TDataSet): TJSONArray;
var
  LTipoDispositivo: String;

  LJSONTipo: TJSONObject;
  LArrayTipos: TJSONArray;
  LArrayDispositivos: TJSONArray;
begin
  if UnidadeOffline(AUnidade, ADataSet) then
  begin
    Result := nil;
    Exit;
  end;

  LArrayTipos := TJSONArray.Create;

  while (not ADataSet.Eof) and
        (AUnidade = ADataSet.FieldByName('ID_UNID_CLI').AsInteger) do
  begin
    LJSONTipo := TJSONObject.Create;

    LTipoDispositivo := ADataSet.FieldByName('TIPO_DISPOSITIVO').AsString;

    LArrayDispositivos := GetDispositivos(AUnidade, LTipoDispositivo, ADataSet);

    LJSONTipo.AddPair(LTipoDispositivo, LArrayDispositivos);

    LArrayTipos.AddElement(LJSONTipo);
  end;

  Result := LArrayTipos;
end;

function TDispositivo.GetUnidades(ADataSet: TDataSet): TJSONArray;
var
  LIdUnidade: Integer;
  LJSONUnidade: TJSONObject;
  LArrayUnidades: TJSONArray;
  LArrayTipos: TJSONArray;
begin
  LArrayUnidades := TJSONArray.Create;

  ADataSet.First;
  while not ADataSet.Eof do
  begin
    LJSONUnidade := TJSONObject.Create;

    LJSONUnidade.AddPair('IdUnidade', ADataSet.FieldByName('ID_UNID_CLI').AsString);
    LJSONUnidade.AddPair('NomeUnidade', ADataSet.FieldByName('NOME_UNIDADE').AsString);
    LJSONUnidade.AddPair('Status', ADataSet.FieldByName('STATUS_UNIDADE').AsString);
    LJSONUnidade.AddPair('DataHoraStatus',
      FormatDateTime('dd/mm/yyyy hh:mm:ss', ADataSet.FieldByName('ULTIMAATUALIZACAO').AsDateTime));
    LJSONUnidade.AddPair('UltimaVezOnline',
      FormatDateTime('dd/mm/yyyy hh:mm:ss', ADataSet.FieldByName('ULTIMA_VEZ_ONLINE').AsDateTime));

    LIdUnidade := ADataSet.FieldByName('ID_UNID_CLI').AsInteger;

    LArrayTipos := GetTipos(LIdUnidade, ADataSet);

    LJSONUnidade.AddPair('Dispositivos:', LArrayTipos); //***KM este ":" era pra estar aqui mesmo?

    LArrayUnidades.AddElement(LJSONUnidade);
  end;

  Result := LArrayUnidades;
end;

function TDispositivo.StatusPorUnidade(AUnidade: Integer; APath: String): TJSONArray;
const
  SELECT = 'SELECT DS.*, DSO.DATAHORA AS ULTIMA_VEZ_ONLINE ' +
           'FROM DISPOSITIVOS_STATUS DS ' +
           'LEFT OUTER JOIN DISPOSITIVOS_STATUS_ONLINE DSO ON ' +
           '  DS.ID_UNIDADE = DSO.ID_UNIDADE AND ' +
           '  DS.TIPO_DISPOSITIVO = DSO.TIPO_DISPOSITIVO AND ' +
           '  DS.NOME_DISPOSITIVO = DSO.NOME_DISPOSITIVO AND ' +
           '  DS.MODELO_DISPOSITIVO = DSO.MODELO_DISPOSITIVO ' +
           ' %s ' +
           'ORDER BY DS.ID_UNID_CLI, DS.TIPO_DISPOSITIVO, DS.NOME_DISPOSITIVO ' ;
var
  LConn: TFDConnection;
  LWhere: String;
  LDataSet: TDataSet;
begin
  if AUnidade > 0 then
    LWhere := 'WHERE DS.ID_UNIDADE = ' + AUnidade.ToString
  else
    LWhere := EmptyStr;

  LConn := GetConnection(APath);
  try
    LConn.ExecSQL(Format(SELECT, [LWhere]), LDataSet);
    try
      Result := GetUnidades(LDataSet);
    finally
      FreeAndNil(LDataSet);
    end;
  finally
    FreeAndNil(LConn);
  end;
end;

function TDispositivo.UnidadeOffline(AUnidade: Integer; ADataSet: TDataSet): Boolean;
begin
  if ADataSet.FieldByName('STATUS_UNIDADE').AsString.ToUpper <> 'ONLINE' then
  begin
    while (not ADataSet.Eof) and
          (AUnidade = ADataSet.FieldByName('ID_UNID_CLI').AsInteger) do
    begin
      ADataSet.Next;
    end;

    Result := True;
    Exit;
  end;

  ADataSet.Next;
  Result := False;
end;

end.
